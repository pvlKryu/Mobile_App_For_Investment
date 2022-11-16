package plugin.atb.invest.dto;

import java.math.*;

import io.swagger.v3.oas.annotations.media.*;
import lombok.*;

@Data
@AllArgsConstructor
@Schema(description = "Ответ для возвращения баланса клиенту с имейлом email")
public class BalanceDtoResponse {

    @Schema(
        description = "Email пользователя",
        example = "mail@mail.ru"
    )
    private String email;

    @Schema(
        description = "Баланс пользователя",
        example = "1337.420"
    )
    private BigDecimal balance;

}
