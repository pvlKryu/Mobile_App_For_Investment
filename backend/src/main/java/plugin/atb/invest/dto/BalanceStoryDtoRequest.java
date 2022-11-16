package plugin.atb.invest.dto;

import io.swagger.v3.oas.annotations.media.*;
import lombok.*;
import plugin.atb.invest.model.*;

@Data
public class BalanceStoryDtoRequest {

    @Schema(
        description = "Вывести баланс операций ADD или вывести баланс операций SUBTRACT",
        example = "ADD"
    )
    private TypeOfOperation typeOfOperation;

}
