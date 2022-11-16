package plugin.atb.invest.exception;

import java.time.*;

import lombok.*;

@Data
@AllArgsConstructor
public class ApiError {

    private String message;

    private LocalDateTime localDateTime;

}
