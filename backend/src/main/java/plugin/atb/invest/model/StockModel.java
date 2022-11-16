package plugin.atb.invest.model;

import java.math.*;

import lombok.*;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class StockModel {

    /**
     * Тикер инструмента
     */
    private String ticker;

    /**
     * Figi-идентификатор инструмента
     */
    private String figi;

    /**
     * Название инструмента
     */
    private String name;

    /**
     * Валюта расчётов
     */
    private String currency;

    /**
     * Описание актива
     */
    private String description;

    /**
     * Класс-код (секция торгов)
     */
    private String classCode;

    /**
     * Последняя цена
     */
    private BigDecimal lastPrice;

}
