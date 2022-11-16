package plugin.atb.invest.domain;

import javax.persistence.*;

import lombok.*;

@Entity
@Table(name = "stocks")
@Getter
@Setter
@NoArgsConstructor
public class StockEntity {

    /**
     * Тикер инструмента
     */
    private String ticker;

    /**
     * Figi-идентификатор инструмента
     */
    @Id
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

}
