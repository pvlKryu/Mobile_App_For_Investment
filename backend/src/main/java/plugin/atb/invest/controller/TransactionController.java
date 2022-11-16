package plugin.atb.invest.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import plugin.atb.invest.dto.TransactionDtoRequest;
import plugin.atb.invest.dto.TransactionDtoResponse;
import plugin.atb.invest.model.TransactionModel;
import plugin.atb.invest.repository.*;
import plugin.atb.invest.service.SecurityService;
import plugin.atb.invest.service.TransactionService;

@RestController
@RequestMapping("/transaction")
@AllArgsConstructor
@SecurityRequirement(name = "ATB-Invest")
public class TransactionController {
    TransactionService transactionService;
    private final SecurityService securityService;
    private final ModelMapper modelMapper;
    private final TransactionRepository transactionRepository;
    @PutMapping("/buy")
    @Operation(
            summary = "Покупка акций",
            description = "Транзакция на покупку кол-ва акций"
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "Ok"
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "Недостаточно денег для списания"
            )
    })
    public ResponseEntity<TransactionDtoResponse> TransactionBuy (@RequestBody TransactionDtoRequest transactionDtoRequest) {
        TransactionModel transactionModel = transactionService.transactionBuy(
                securityService.getEmailFromAuth(),
                transactionDtoRequest);
        TransactionDtoResponse transactionDtoResponse = modelMapper.map(transactionModel,TransactionDtoResponse.class);
        return ResponseEntity.status(HttpStatus.OK)
                .body(transactionDtoResponse);
    }

    @PutMapping("/sell")
    @Operation(
            summary = "Продажа акций",
            description = "Транзакция на продажу кол-ва акций"
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "Ok"
            )
    })
    public ResponseEntity<TransactionDtoResponse> TransactionSell (@RequestBody TransactionDtoRequest transactionDtoRequest) {
        TransactionModel transactionModel = transactionService.transactionSell(
                securityService.getEmailFromAuth(),
                transactionDtoRequest);
        TransactionDtoResponse transactionDtoResponse = modelMapper.map(transactionModel,TransactionDtoResponse.class);
        return ResponseEntity.status(HttpStatus.OK)
                .body(transactionDtoResponse);
    }

}