package plugin.atb.invest.dto;

import java.math.*;

import io.swagger.v3.oas.annotations.media.*;
import lombok.*;
import plugin.atb.invest.model.*;

@Data
public class BalanceDtoRequest {

    @Schema(
        description = "Пополнить баланс(typeOfOperation=ADD) или вывести деньги(typeOfOperation=SUBTRACT)",
        example = "ADD"
    )
    private TypeOfOperation typeOfOperation;

    @Schema(
        description = "Баланс",
        example = "228.69"
    )
    private BigDecimal amount;

}
