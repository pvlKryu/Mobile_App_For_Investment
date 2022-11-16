package plugin.atb.invest.dto;

import java.math.*;

import io.swagger.v3.oas.annotations.media.*;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Ответ на авторизацию пользователя")
public class ClientAuthDtoResponse {

    @Schema(
        description = "Имя пользователя",
        example = "Ivan"
    )
    private String name;

    @Schema(
        description = "Email пользователя",
        example = "mail@mail.ru"
    )
    private String email;

    @Schema(
        description = "Баланс пользователя",
        example = "150.34"
    )
    private BigDecimal balance;

    @Schema(
        description = "Id пользователя",
        example = "4"
    )
    private long id;

}
