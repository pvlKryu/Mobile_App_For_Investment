package plugin.atb.invest.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Ответ на транзакцию")
public class TransactionDtoResponse {
    @Schema(
            description = "Имя акции",
            example = "Аэрофлот"
    )
    private String name;
    @Schema(
            description = "Количество акций",
            example = "3"
    )
    int numberOfStock;
    @Schema(
            description = "Тип операции. true покупка, false продажа",
            example = "3"
    )
    Boolean operationType;
    @Schema(
            description = "Цена акции на момент транзакции",
            example = "28.86"
    )
    BigDecimal transactionPrice;
    @Schema(
            description = "Дата совершения транзакции",
            example = "2022-03-07"
    )
    LocalDate localDate;
}