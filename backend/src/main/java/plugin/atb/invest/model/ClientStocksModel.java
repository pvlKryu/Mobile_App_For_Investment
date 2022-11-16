package plugin.atb.invest.model;

import java.math.*;

import lombok.*;

@Data
public class ClientStocksModel {

    String figi;

    String name;

    String currency;

    BigDecimal averagePrice;

    double profit;

    int amount;

}
