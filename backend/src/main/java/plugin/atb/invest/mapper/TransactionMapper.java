package plugin.atb.invest.mapper;

import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import plugin.atb.invest.domain.TransactionEntity;
import plugin.atb.invest.dto.*;
import plugin.atb.invest.model.*;

@AllArgsConstructor
public class TransactionMapper {
    public static void initModelMapper(ModelMapper modelMapper) {
        modelMapper.createTypeMap(TransactionModel.class, TransactionEntity.class)
                .setConverter(mappingContext -> {
                    TransactionModel transactionModel = mappingContext.getSource();
                    TransactionEntity transactionEntity = new TransactionEntity();
                    transactionEntity.setName(transactionModel.getName());
                    transactionEntity.setStocks(transactionModel.getStocks());
                    transactionEntity.setClient(transactionModel.getClient());
                    transactionEntity.setOperationType(transactionModel.getOperationType());
                    transactionEntity.setTransactionPrice(transactionModel.getTransactionPrice());
                    transactionEntity.setNumberOfStock(transactionModel.getNumberOfStock());
                    transactionEntity.setLocalDate(transactionModel.getLocalDate());

                    return transactionEntity;
                });

        modelMapper.createTypeMap(TransactionModel.class, TransactionDtoResponse.class)
                .setConverter(mappingContext -> {
                    TransactionModel transactionModel = mappingContext.getSource();
                    TransactionDtoResponse transactionDtoResponse = new TransactionDtoResponse();
                    transactionDtoResponse.setName(transactionModel.getName());
                    transactionDtoResponse.setOperationType(transactionModel.getOperationType());
                    transactionDtoResponse.setNumberOfStock(transactionModel.getNumberOfStock());
                    transactionDtoResponse.setTransactionPrice(transactionModel.getTransactionPrice());
                    transactionDtoResponse.setLocalDate(transactionModel.getLocalDate());
                    return transactionDtoResponse;
                });

        modelMapper.createTypeMap(ClientStocksModel.class, ClientStocksDto.class)
            .setConverter(mappingContext -> {
                var model = mappingContext.getSource();
                var dto = new ClientStocksDto();
                dto.setFigi(model.getFigi());
                dto.setCurrency(model.getCurrency());
                dto.setAmount(model.getAmount());
                dto.setName(model.getName());
                dto.setAveragePrice(model.getAveragePrice());
                dto.setProfit(model.getProfit());
                return dto;
            });

    }
}
