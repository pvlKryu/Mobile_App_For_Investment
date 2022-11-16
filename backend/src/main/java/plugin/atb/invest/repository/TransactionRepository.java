package plugin.atb.invest.repository;

import java.util.*;

import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.*;
import org.springframework.stereotype.Repository;
import plugin.atb.invest.domain.*;

@Repository
public interface TransactionRepository extends CrudRepository<TransactionEntity, Long> {

    @Query(value = "select te.stocks.figi, (sum(te.numberOfStock * case " +
                   "                                               when te.operationType = true " +
                   "                                                    then 1 " +
                   "                                                    else -1 " +
                   "                                               end)) " +
                   "from TransactionEntity te " +
                   "where te.client.id = ?1 " +
                   "group by te.stocks.figi")
    List<List<Object>> getAmountStocksByClientId(long id);

    @Query(value = "select te.stocks.figi, avg(te.transactionPrice * te.numberOfStock) " +
                   "from TransactionEntity te " +
                   "where te.client.id = ?1 " +
                   "group by te.stocks.figi")
    List<List<Object>> getPriceStocksByClientId(long id);

}
