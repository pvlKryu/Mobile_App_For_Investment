package plugin.atb.invest.dto;

import java.math.*;

import lombok.*;

@Data
public class ClientStocksDto {

    String figi;

    String name;

    String currency;

    BigDecimal averagePrice;

    double profit;

    int amount;

}
