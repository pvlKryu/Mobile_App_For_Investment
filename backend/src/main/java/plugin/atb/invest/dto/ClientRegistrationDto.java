package plugin.atb.invest.dto;

import io.swagger.v3.oas.annotations.media.*;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Запрос на регистрацию пользователя")
public class ClientRegistrationDto {

    @Schema(
        description = "Имя пользователя",
        example = "Alexey"
    )
    private String name;

    @Schema(
        description = "Email пользователя",
        example = "mail@mail.ru"
    )
    private String email;

    @Schema(
        description = "Пароль пользователя",
        example = "s3cret"
    )
    private String password;

}
