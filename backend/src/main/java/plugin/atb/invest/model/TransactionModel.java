package plugin.atb.invest.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import plugin.atb.invest.domain.ClientEntity;
import plugin.atb.invest.domain.StockEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TransactionModel {

    String name;

    StockEntity stocks;

    ClientEntity client;;

    Boolean operationType;

    BigDecimal transactionPrice;

    int numberOfStock;

    LocalDate localDate;

}