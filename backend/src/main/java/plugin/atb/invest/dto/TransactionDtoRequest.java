package plugin.atb.invest.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "Запрос на транзакцию")
public class TransactionDtoRequest {
    @Schema(
            description = "figi акции",
            example = "BBG00Y3XYV94"
    )
    private String figi;

    @Schema(
            description = "Количество акций",
            example = "7"
    )
    int numberOfStock;
}
