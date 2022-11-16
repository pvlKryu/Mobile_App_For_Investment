package plugin.atb.invest.domain;

import javax.persistence.*;

import lombok.*;

@Entity
@Getter
@Setter
@Table(name = "favourite_Stock")
public class FavouriteStockEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    long id;

    @ManyToOne
    @JoinColumn(name = "client_Id")
    private ClientEntity clientEntity;

    @ManyToOne
    @JoinColumn(name = "figi")
    private StockEntity stockEntity;

}

