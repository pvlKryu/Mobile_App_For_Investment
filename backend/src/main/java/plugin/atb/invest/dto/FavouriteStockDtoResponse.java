package plugin.atb.invest.dto;

import java.math.*;

import lombok.*;

@Data
@NoArgsConstructor
public class FavouriteStockDtoResponse {

    private String figi;

    private String name;

    private String currency;

    private BigDecimal lastPrice;

}