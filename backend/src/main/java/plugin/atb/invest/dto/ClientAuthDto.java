package plugin.atb.invest.dto;

import io.swagger.v3.oas.annotations.media.*;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Запрос на авторизацию пользователя")
public class ClientAuthDto {

    @Schema(
        description = "Email пользователя",
        example = "mail@mail.ru"
    )
    private String email;

    @Schema(
        description = "Пароль пользователя",
        example = "secr3t!"
    )
    private String password;

}

