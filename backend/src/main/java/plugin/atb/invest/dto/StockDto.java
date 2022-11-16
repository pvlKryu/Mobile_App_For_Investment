package plugin.atb.invest.dto;

import java.math.*;

import io.swagger.v3.oas.annotations.media.*;
import lombok.*;

@Data
@Schema(description = "Ответ на получение акции")
public class StockDto {

    @Schema(
        description = "figi",
        example = "BBG00Y3XYV94"
    )
    private String figi;

    @Schema(
        description = "Название акции",
        example = "Мать и дитя"
    )
    private String name;

    @Schema(
        description = "Валюта",
        example = "rub"
    )
    private String currency;

    @Schema(
        description = "Последняя цена",
        example = "412.8"
    )
    private BigDecimal lastPrice;

}
