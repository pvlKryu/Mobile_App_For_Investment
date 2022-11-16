package plugin.atb.invest.model;

import java.math.*;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ClientModel {

    private String name;

    private String email;

    private String password;

    private BigDecimal balance;

    private long id;

}
