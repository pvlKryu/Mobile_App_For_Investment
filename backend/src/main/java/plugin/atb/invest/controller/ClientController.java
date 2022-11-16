package plugin.atb.invest.controller;

import java.math.*;
import java.util.*;

import io.swagger.v3.oas.annotations.*;
import io.swagger.v3.oas.annotations.responses.*;
import io.swagger.v3.oas.annotations.security.*;
import lombok.*;
import lombok.extern.slf4j.*;
import org.modelmapper.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import plugin.atb.invest.dto.*;
import plugin.atb.invest.model.*;
import plugin.atb.invest.service.*;

@Slf4j
@RestController
@RequestMapping("/client")
@AllArgsConstructor
@SecurityRequirement(name = "ATB-Invest")
public class ClientController {

    private final ClientService clientService;

    private final ModelMapper modelMapper;

    private final SecurityService securityService;

    private final TransactionService transactionService;

    @PostMapping("/registration")
    @Operation(
        summary = "Регистрация",
        description = "Регистрация пользователя по name, email, password"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
        @ApiResponse(
            responseCode = "409",
            description = "Email уже существует"
        )
    })
    public ResponseEntity<?> createClient(@RequestBody ClientRegistrationDto clientRegistrationDto) {
        ClientModel clientModel = modelMapper.map(clientRegistrationDto, ClientModel.class);
        clientService.createClient(clientModel);
        return ResponseEntity.status(200).build();
    }

    @GetMapping("/profile")
    @Operation(
        summary = "Данные клиента",
        description = "Получить id, name, email и balance клиента"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
        @ApiResponse(
            responseCode = "401",
            description = "Не авторизирован"
        )

    })
    public ResponseEntity<ClientAuthDtoResponse> profileClient() {
        ClientModel clientModel = clientService.getClientByEmail(securityService.getEmailFromAuth());
        ClientAuthDtoResponse clientAuthDtoResponse = modelMapper.map(
            clientModel,
            ClientAuthDtoResponse.class);
        return ResponseEntity.status(200).body(clientAuthDtoResponse);
    }

    @PutMapping("/profile")
    @Operation(
        summary = "Изменение данных клиента",
        description = "Изменение данных клиента"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        ),
        @ApiResponse(
            responseCode = "401",
            description = "Не авторизирован"
        )

    })
    public ResponseEntity<ClientChangeDataModel> changeClientParam(@RequestBody ClientChangeDataDto clientChangeDataDto) {
        ClientChangeDataModel clientChangeDataModel = modelMapper.map(
            clientChangeDataDto,
            ClientChangeDataModel.class);
        clientService.changeClient(clientChangeDataModel);
        return ResponseEntity.status(200).body(clientChangeDataModel);
    }

    @PutMapping("/balance")
    @Operation(
        summary = "Изменение баланса",
        description = "Изменение баланса: пополнить ADD, снять SUBTRACT"
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
    public ResponseEntity<BalanceDtoResponse> changeBalance(@RequestBody BalanceDtoRequest balanceDtoRequest) {
        BigDecimal balance = clientService.changeBalance(
            securityService.getEmailFromAuth(),
            balanceDtoRequest);
        clientService.balanceStory(balanceDtoRequest);
        return ResponseEntity.status(HttpStatus.OK)
            .body(new BalanceDtoResponse(securityService.getEmailFromAuth(), balance));
    }

    @GetMapping("/balance")
    @Operation(
        summary = "Получение баланса",
        description = "Get запрос для получение баланса пользователя"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        )
    })
    public ResponseEntity<BalanceDtoResponse> getBalance() {
        BigDecimal balance = clientService.getBalance(securityService.getEmailFromAuth());
        return ResponseEntity.status(HttpStatus.OK)
            .body(new BalanceDtoResponse(securityService.getEmailFromAuth(), balance));
    }

    @GetMapping("/stocks")
    @Operation(
        summary = "Получение портфеля",
        description = "Get запрос для получение портфеля акций"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        )
    })
    public ResponseEntity<List<ClientStocksDto>> getStocks() {

        var clientStocksModels = transactionService.getClientStocks(securityService.getEmailFromAuth());
        var clientStocksDto = clientStocksModels.stream()
            .map(model -> modelMapper.map(model, ClientStocksDto.class))
            .toList();
        return ResponseEntity.status(HttpStatus.OK)
            .body(clientStocksDto);

    }

    @GetMapping("/balance/history")
    @Operation(
        summary = "Получение суммы всех пополнений или списаний",
        description = "Получение ADD, списание SUBTRACT"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Ok"
        )
    })
    public ResponseEntity<?> ShowBalanceHistory(BalanceStoryDtoRequest balanceStoryDtoRequest) {
        BalanceStoryRequestModel balanceStoryRequestModel = modelMapper.map(
            balanceStoryDtoRequest,
            BalanceStoryRequestModel.class);
        String history = clientService.SumAllBalanceHistory(balanceStoryRequestModel);
        return ResponseEntity
            .status(HttpStatus.OK)
            .body(history);
    }

}
