package plugin.atb.invest.domain;

import java.math.*;

import javax.persistence.*;

import lombok.*;

@Entity
@Getter
@Setter
@Table(name = "clients")
public class ClientEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private long id;

    private String name;

    private String email;

    private String password;

    private BigDecimal balance;

}
