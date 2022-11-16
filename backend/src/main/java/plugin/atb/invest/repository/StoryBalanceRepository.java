package plugin.atb.invest.repository;

import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.*;
import org.springframework.data.repository.query.*;
import org.springframework.stereotype.Repository;
import plugin.atb.invest.domain.*;

@Repository
public interface StoryBalanceRepository extends CrudRepository<StoryBalanceEntity, Long> {

    @Query(
        value = "SELECT SUM(amount) FROM story_balance WHERE client_id = :id and type = :type",
        nativeQuery = true)
    String SumAllTypes(@Param("id") Long id, @Param("type") String type);

}