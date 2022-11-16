package plugin.atb.invest.service;

import java.math.*;
import java.util.*;
import java.util.stream.*;

import lombok.*;
import org.modelmapper.*;
import org.springframework.dao.*;
import org.springframework.data.domain.*;
import org.springframework.scheduling.annotation.*;
import org.springframework.stereotype.*;
import plugin.atb.invest.domain.*;
import plugin.atb.invest.exception.*;
import plugin.atb.invest.model.*;
import plugin.atb.invest.repository.*;
import ru.tinkoff.piapi.contract.v1.*;
import ru.tinkoff.piapi.core.*;

@Service
@AllArgsConstructor
public class StockService {

    private InvestApi investApi;

    private ModelMapper modelMapper;

    private FavouriteStockRepository favouriteStockRepository;

    private ClientRepository clientRepository;

    private final SecurityService securityService;

    private StockRepository stockRepository;

    private Map<String, BigDecimal> prices;

    @Scheduled(fixedDelay = 2000)
    private void updatePrices() {
        var stockEntities = stockRepository.findAll();
        if (stockEntities.isEmpty()) {
            throw new EmptyDatabaseException("Empty database error");
        }

        var figies = stockEntities.stream()
            .map(StockEntity::getFigi)
            .toList();

        MarketDataService marketDataService = investApi.getMarketDataService();
        var pricesFromTinkoff = marketDataService.getLastPricesSync(figies);
        if (pricesFromTinkoff.isEmpty()) {
            throw new ExternalApiException("External api error");
        }

        Map<String, BigDecimal> pricesByFigies;
        pricesByFigies = pricesFromTinkoff.stream()
            .collect(Collectors.toMap(
                LastPrice::getFigi,
                p -> modelMapper.map(
                    p.getPrice(),
                    BigDecimal.class
                )
            ));
        this.prices = pricesByFigies;
    }

    public BigDecimal getPriceByFigi(String figi) {
        return prices.get(figi);
    }

    public StockModel getStockByFigi(String figi) {
        StockEntity stockEntity = stockRepository.findByFigi(figi);
        if (stockEntity == null) {
            throw new WrongFigiException("Stock not found with figi " + figi);
        }
        StockModel stockModel = modelMapper.map(stockEntity, StockModel.class);
        BigDecimal price = prices.get(stockModel.getFigi());

        stockModel.setLastPrice(price);
        return stockModel;
    }

    public Page<StockModel> getPageStocks(Pageable pageable) {
        Page<StockEntity> stockEntities = stockRepository.findAllByCurrency(pageable, "rub");
        if (stockEntities.isEmpty()) {
            throw new EmptyDatabaseException("Empty database error");
        }
        List<StockModel> stockModels = stockEntities.stream()
            .map(stockEntity -> modelMapper.map(stockEntity, StockModel.class))
            .toList();

        stockModels.forEach(stockModel -> {
            String figi = stockModel.getFigi();
            BigDecimal price = prices.get(figi);
            stockModel.setLastPrice(price);
        });

        return new PageImpl<>(stockModels.stream()
            .filter(stockModel -> !(stockModel.getLastPrice().compareTo(BigDecimal.ZERO) == 0))
            .toList());
    }

    public void addFavouriteStock(
        String email,
        FavouriteStockRequestModel favouriteStockRequestModel
    ) {
        String figi = favouriteStockRequestModel.getFigi();
        StockEntity stockEntity = stockRepository.findByFigi(figi);
        if (stockEntity == null) {
            throw new BadRequestException("The input value does not match figi");
        }
        ClientEntity clientEntity = clientRepository.findByEmail(email);
        FavouriteStockEntity favouriteStockEntity = new FavouriteStockEntity();
        favouriteStockEntity.setStockEntity(stockEntity);
        favouriteStockEntity.setClientEntity(clientEntity);
        try {
            favouriteStockRepository.save(favouriteStockEntity);
        } catch (DataIntegrityViolationException e) {
            throw new DuplicateConflictException("This favourite stock already exists", e);
        }

    }

    public List<FavouriteStockResponseModel> getAllFavouriteStock() {
        ClientEntity clientEntity = clientRepository.findByEmail(securityService.getEmailFromAuth());
        List<FavouriteStockEntity> favouriteStockEntity = favouriteStockRepository.getFavouriteStockEntitiesByClientEntity(
            clientEntity);
        var favouriteStockResponseModel = favouriteStockEntity.stream()
            .map(favouriteEntity -> modelMapper.map(
                favouriteEntity,
                FavouriteStockResponseModel.class))
            .toList();

        favouriteStockResponseModel.forEach(favouriteStockModel -> {
            String figi = favouriteStockModel.getFigi();
            BigDecimal price = prices.get(figi);
            favouriteStockModel.setLastPrice(price);
        });

        return favouriteStockResponseModel;
    }

    public void removeFavouriteStock(
        String email, FavouriteStockRequestModel favouriteStockRequestModel
    ) {
        String figi = favouriteStockRequestModel.getFigi();
        StockEntity stockEntity = stockRepository.findByFigi(figi);
        if (stockEntity == null) {
            throw new BadRequestException("The input value does not match figi");
        }
        ClientEntity clientEntity = clientRepository.findByEmail(email);
        var existedStock = favouriteStockRepository
            .getByClientEntityAndStockEntity(clientEntity, stockEntity);
        if (existedStock == null) {
            throw new DoesNotExistException("This favourite stock does not exists");
        }
        FavouriteStockEntity favouriteStockEntity = favouriteStockRepository.getByClientEntityAndStockEntity(
            clientEntity,
            stockEntity);
        favouriteStockRepository.delete(favouriteStockEntity);
    }

}
