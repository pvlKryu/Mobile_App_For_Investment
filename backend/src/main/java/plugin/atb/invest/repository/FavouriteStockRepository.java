package plugin.atb.invest.repository;

import java.util.*;

import org.jetbrains.annotations.*;
import org.springframework.data.repository.*;
import org.springframework.stereotype.Repository;
import plugin.atb.invest.domain.*;

@Repository
public interface FavouriteStockRepository extends CrudRepository<FavouriteStockEntity, Long> {

    @NotNull
    List<FavouriteStockEntity> getFavouriteStockEntitiesByClientEntity(ClientEntity clientEntity);

    FavouriteStockEntity getByClientEntityAndStockEntity(
        ClientEntity clientEntity,
        StockEntity stockEntity
    );

}
