package plugin.atb.invest.service;

import java.math.*;
import java.time.*;
import java.util.*;

import lombok.*;
import org.modelmapper.*;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.*;
import plugin.atb.invest.domain.*;
import plugin.atb.invest.dto.*;
import plugin.atb.invest.exception.*;
import plugin.atb.invest.model.*;
import plugin.atb.invest.repository.*;

@Service
@AllArgsConstructor
public class TransactionService {

    private final ClientRepository clientRepository;

    private final StockRepository stockRepository;

    private final StockService stockService;

    private final ModelMapper modelMapper;

    private final TransactionRepository transactionRepository;

    private TransactionModel createTransaction(
        ClientEntity client,
        StockEntity stock,
        boolean operationType,
        int numberOfStock
    ) {
        LocalDate date = LocalDate.now();
        TransactionModel transactionModel = new TransactionModel();
        transactionModel.setTransactionPrice(stockService.getPriceByFigi(stock.getFigi()));
        transactionModel.setLocalDate(date);
        transactionModel.setClient(client);
        transactionModel.setNumberOfStock(numberOfStock);
        transactionModel.setStocks(stock);
        transactionModel.setOperationType(operationType);
        transactionModel.setName(stock.getName());
        return transactionModel;
    }

    private Map<String, Integer> getAmountStocks(long id) {
        var clientStocks = transactionRepository.getAmountStocksByClientId(id);
        var mapAmountOfStocks = new HashMap<String, Integer>();
        clientStocks.stream()
            .filter(list -> !list.get(1).toString().equals("0"))
            .forEach(list -> mapAmountOfStocks.put(
                list.get(0).toString(),
                Integer.valueOf(list.get(1).toString())
            ));
        return mapAmountOfStocks;
    }

    private Map<String, BigDecimal> getAveragePrice(long id) {
        var clientStocks = transactionRepository.getPriceStocksByClientId(id);
        var mapAveragePriceStocks = new HashMap<String, BigDecimal>();
        clientStocks.forEach(list -> {
            var price = Double.parseDouble(list.get(1).toString());
            mapAveragePriceStocks.put(
                list.get(0).toString(),
                BigDecimal.valueOf(price));
        });
        return mapAveragePriceStocks;
    }

    @Transactional
    public TransactionModel transactionBuy(
        String email,
        TransactionDtoRequest transactionDtoRequest
    ) {
        var figi = transactionDtoRequest.getFigi();
        var numberOfStock = transactionDtoRequest.getNumberOfStock();
        var clientEntity = clientRepository.findByEmail(email);
        var stockEntity = stockRepository.findByFigi(figi);
        if (stockEntity == null) {
            throw new WrongFigiException("Stock not found with figi " + figi);
        }

        BigDecimal balance = clientEntity.getBalance();
        BigDecimal TransactionSum = stockService.getPriceByFigi(figi)
            .multiply(BigDecimal.valueOf(numberOfStock));
        if ((balance.subtract(TransactionSum)).doubleValue() < 0) {
            throw new NegativeBalanceException("After the operation, " +
                                               "you will get a negative balance");
        }
        balance = balance.subtract(TransactionSum);
        clientEntity.setBalance(balance);

        TransactionModel transactionModel = createTransaction(
            clientEntity,
            stockEntity,
            true,
            numberOfStock);
        TransactionEntity transactionEntity = modelMapper.map(
            transactionModel,
            TransactionEntity.class);
        transactionRepository.save(transactionEntity);
        clientRepository.save(clientEntity);

        return transactionModel;
    }

    @Transactional
    public TransactionModel transactionSell(
        String email,
        TransactionDtoRequest transactionDtoRequest
    ) {
        var figi = transactionDtoRequest.getFigi();
        var numberOfStock = transactionDtoRequest.getNumberOfStock();
        var clientEntity = clientRepository.findByEmail(email);
        var stockEntity = stockRepository.findByFigi(figi);
        if (stockEntity == null) {
            throw new WrongFigiException("Stock not found with figi " + figi);
        }

        var mapAmountOfStocks = getAmountStocks(clientEntity.getId());

        if (!mapAmountOfStocks.containsKey(figi)) {
            throw new WrongFigiException("Client does not have stock with figi " + figi);
        }

        if (mapAmountOfStocks.get(figi) < numberOfStock) {
            throw new NegativeAmountStocksException("After the operation, " +
                                                    "you will get a negative amount of stocks");
        }

        BigDecimal balance = clientEntity.getBalance();
        BigDecimal TransactionSum = stockService.getPriceByFigi(transactionDtoRequest.getFigi())
            .multiply(new BigDecimal(numberOfStock));
        balance = balance.add(TransactionSum);
        clientEntity.setBalance(balance);

        TransactionModel transactionModel = createTransaction(
            clientEntity,
            stockEntity,
            false,
            numberOfStock);
        TransactionEntity transactionEntity = modelMapper.map(
            transactionModel,
            TransactionEntity.class);
        transactionRepository.save(transactionEntity);
        clientRepository.save(clientEntity);

        return transactionModel;
    }

    public List<ClientStocksModel> getClientStocks(String email) {
        var clientStocks = new ArrayList<ClientStocksModel>();
        var clientEntity = clientRepository.findByEmail(email);

        var mapAmountStocks = getAmountStocks(clientEntity.getId());
        var mapAveragePriceStocks = getAveragePrice(clientEntity.getId());
        mapAmountStocks.forEach((figi, amount) -> {
            var stock = stockRepository.findByFigi(figi);
            var avgPrice = mapAveragePriceStocks.get(figi).setScale(4, RoundingMode.CEILING);
            var currentPrice = stockService.getPriceByFigi(figi).setScale(4, RoundingMode.CEILING);
            var profit = currentPrice.subtract(avgPrice)
                .divide(avgPrice, RoundingMode.valueOf(4))
                .setScale(4, RoundingMode.CEILING)
                .doubleValue();
            var client = new ClientStocksModel();
            client.setAmount(amount);
            client.setFigi(figi);
            client.setAveragePrice(avgPrice);
            client.setProfit(profit);
            client.setName(stock.getName());
            client.setCurrency(stock.getCurrency());
            clientStocks.add(client);
        });

        return clientStocks;
    }

}
