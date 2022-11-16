package plugin.atb.invest.model;

import java.math.*;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FavouriteStockResponseModel {

    private String figi;

    private String name;

    private String currency;

    private BigDecimal lastPrice;

}