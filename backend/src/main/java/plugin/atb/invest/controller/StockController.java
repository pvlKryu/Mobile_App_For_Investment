package plugin.atb.invest.controller;

import java.math.*;
import java.util.*;
import java.util.stream.*;

import io.swagger.v3.oas.annotations.*;
import io.swagger.v3.oas.annotations.responses.*;
import io.swagger.v3.oas.annotations.security.*;
import lombok.*;
import org.modelmapper.*;
import org.springframework.data.domain.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import plugin.atb.invest.dto.*;
import plugin.atb.invest.model.*;
import plugin.atb.invest.service.*;

@RestController
@RequestMapping("/stocks")
@AllArgsConstructor
@SecurityRequirement(name = "ATB-Invest")
public class StockController {

    private StockService stockService;

    private final SecurityService securityService;

    private ModelMapper modelMapper;

    @GetMapping("/{figi}")
    @Operation(
        summary = "Получение акции по figi",
        description = "Получение акции по figi"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Акции с таким figi нет"
        )
    })
    public ResponseEntity<StockDto> getStockByFigi(@PathVariable String figi) {
        StockModel stockModel = stockService.getStockByFigi(figi);
        StockDto stockDto = modelMapper.map(stockModel, StockDto.class);
        return ResponseEntity
            .status(HttpStatus.OK)
            .body(stockDto);
    }

    @GetMapping("")
    @Operation(
        summary = "Получение страниц акций",
        description = "Получение страниц акций"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
        @ApiResponse(
            responseCode = "500",
            description = "База данных пуста"
        )
    })
    public ResponseEntity<List<StockDto>> getPageStocks(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "30") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<StockModel> stockModels = stockService.getPageStocks(pageable);
        List<StockDto> stockDto = stockModels.stream()
            .map(stockModel -> modelMapper.map(stockModel, StockDto.class))
            .collect(Collectors.toList());
        return ResponseEntity
            .status(HttpStatus.OK)
            .body(stockDto);
    }

    @PostMapping("/favourite")
    @Operation(
        summary = "Добавить избранную акцию",
        description = "Добавить избранную акцию"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
        @ApiResponse(
            responseCode = "409",
            description = "Данная акция уже есть в портфеле избранных"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Вводимое значение не соответствует figi"
        )
    })
    public ResponseEntity<?> addFavouriteStock(@RequestBody FavouriteStockDtoRequest favouriteStockDtoRequest) {
        FavouriteStockRequestModel favouriteStockRequestModel = modelMapper.map(
            favouriteStockDtoRequest,
            FavouriteStockRequestModel.class);
        stockService.addFavouriteStock(
            securityService.getEmailFromAuth(),
            favouriteStockRequestModel);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

    @GetMapping("/favourite")
    @Operation(
        summary = "Получить список избранных акций",
        description = "Получить список избранных акций"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
    })
    public ResponseEntity<List<FavouriteStockDtoResponse>> getAllFavouriteStocks() {
        List<FavouriteStockResponseModel> favouriteStockResponseModel = stockService.getAllFavouriteStock();
        List<FavouriteStockDtoResponse> favouriteStockDtoResponse = favouriteStockResponseModel.stream()
            .map(model -> modelMapper.map(model, FavouriteStockDtoResponse.class))
            .toList();
        return ResponseEntity.status(HttpStatus.OK).body(favouriteStockDtoResponse);
    }

    @DeleteMapping("/favourite")
    @Operation(
        summary = "Удалить избранную акцию",
        description = "Удалить избранную акцию"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Вводимое значение не соответствует figi"
        ),
        @ApiResponse(
            responseCode = "410",
            description = "Данная избранная акция не существует"
        )
    })
    public ResponseEntity<?> removeFavouriteStock(@RequestBody FavouriteStockDtoRequest favouriteStockDtoRequest) {
        FavouriteStockRequestModel favouriteStockRequestModel = modelMapper.map(
            favouriteStockDtoRequest,
            FavouriteStockRequestModel.class);
        stockService.removeFavouriteStock(
            securityService.getEmailFromAuth(),
            favouriteStockRequestModel);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
