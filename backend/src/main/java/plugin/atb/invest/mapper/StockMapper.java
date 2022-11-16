package plugin.atb.invest.mapper;

import java.math.*;

import org.modelmapper.*;
import plugin.atb.invest.domain.*;
import plugin.atb.invest.dto.*;
import plugin.atb.invest.model.*;
import ru.tinkoff.piapi.contract.v1.*;

public class StockMapper {

    public static void initModelMapper(ModelMapper modelMapper) {
        modelMapper.createTypeMap(Share.class, StockEntity.class)
            .setConverter(mappingContext -> {
                Share share = mappingContext.getSource();
                StockEntity stockEntity = new StockEntity();
                stockEntity.setTicker(share.getTicker());
                stockEntity.setCurrency(share.getCurrency());
                stockEntity.setFigi(share.getFigi());
                stockEntity.setName(share.getName());
                stockEntity.setClassCode(share.getClassCode());
                return stockEntity;
            });

        modelMapper.createTypeMap(StockEntity.class, StockModel.class)
            .setConverter(mappingContext -> {
                StockEntity stockEntity = mappingContext.getSource();
                StockModel stockModel = new StockModel();
                stockModel.setFigi(stockEntity.getFigi());
                stockModel.setCurrency(stockEntity.getCurrency());
                stockModel.setName(stockEntity.getName());
                stockModel.setTicker(stockEntity.getTicker());
                stockModel.setClassCode(stockEntity.getClassCode());
                return stockModel;
            });

        modelMapper.createTypeMap(StockModel.class, StockDto.class)
            .setConverter(mappingContext -> {
                StockModel stockModel = mappingContext.getSource();
                StockDto stockDto = new StockDto();
                stockDto.setFigi(stockModel.getFigi());
                stockDto.setCurrency(stockModel.getCurrency());
                stockDto.setName(stockModel.getName());
                stockDto.setLastPrice(stockModel.getLastPrice());
                return stockDto;
            });

        modelMapper.createTypeMap(FavouriteStockEntity.class, FavouriteStockResponseModel.class)
            .setConverter(mappingContext -> {
                FavouriteStockEntity favouriteStockEntity = mappingContext.getSource();
                FavouriteStockResponseModel favouriteStockResponseModel = new FavouriteStockResponseModel();
                favouriteStockResponseModel.setFigi(favouriteStockEntity.getStockEntity()
                    .getFigi());
                favouriteStockResponseModel.setCurrency(favouriteStockEntity.getStockEntity()
                    .getCurrency());
                favouriteStockResponseModel.setName(favouriteStockEntity.getStockEntity()
                    .getName());
                return favouriteStockResponseModel;
            });

        modelMapper.createTypeMap(
                FavouriteStockResponseModel.class,
                FavouriteStockDtoResponse.class)
            .setConverter(mappingContext -> {
                FavouriteStockResponseModel favouriteStockResponseModel = mappingContext.getSource();
                FavouriteStockDtoResponse favouriteStockDtoResponse = new FavouriteStockDtoResponse();
                favouriteStockDtoResponse.setFigi(favouriteStockResponseModel.getFigi());
                favouriteStockDtoResponse.setCurrency(favouriteStockResponseModel.getCurrency());
                favouriteStockDtoResponse.setName(favouriteStockResponseModel.getName());
                favouriteStockDtoResponse.setLastPrice(favouriteStockResponseModel.getLastPrice());
                return favouriteStockDtoResponse;
            });

        modelMapper.createTypeMap(Quotation.class, BigDecimal.class)
            .setConverter(mappingContext -> {
                Quotation price = mappingContext.getSource();
                return BigDecimal.valueOf(price.getUnits() +
                                          price.getNano() / 1000000000.0);
            });
    }

}
