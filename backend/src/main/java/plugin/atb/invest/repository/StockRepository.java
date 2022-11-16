package plugin.atb.invest.repository;

import java.util.*;

import org.jetbrains.annotations.*;
import org.springframework.data.domain.*;
import org.springframework.data.repository.*;
import org.springframework.stereotype.Repository;
import plugin.atb.invest.domain.*;

@Repository
public interface StockRepository extends CrudRepository<StockEntity, Long> {

    StockEntity findByFigi(String figi);

    @Override
    @NotNull
    List<StockEntity> findAll();

    @NotNull
    Page<StockEntity> findAllByCurrency(Pageable pageable, String currency);

}
