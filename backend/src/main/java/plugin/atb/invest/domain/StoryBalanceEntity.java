package plugin.atb.invest.domain;

import java.math.*;

import javax.persistence.*;

import lombok.*;
import plugin.atb.invest.model.*;

@Entity
@Getter
@Setter
@Table(name = "story_Balance")
public class StoryBalanceEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private long id;

    @ManyToOne
    @JoinColumn(name = "client_Id")
    private ClientEntity clientEntity;

    @Column(name = "type")
    @Enumerated(EnumType.STRING)
    private TypeOfOperation type;

    private BigDecimal amount;

}
