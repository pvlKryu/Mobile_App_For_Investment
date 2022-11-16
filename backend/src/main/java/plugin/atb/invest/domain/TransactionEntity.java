package plugin.atb.invest.domain;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@Table(name = "transactions")
public class TransactionEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    long id;

    String name;

    @ManyToOne
    @JoinColumn(name = "stock_figi")
    StockEntity stocks;

    @ManyToOne
    @JoinColumn(name = "client_id")
    ClientEntity client;

    Boolean operationType;

    BigDecimal transactionPrice;

    int numberOfStock;

    LocalDate localDate;

}