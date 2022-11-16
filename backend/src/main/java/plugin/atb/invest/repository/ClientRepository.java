package plugin.atb.invest.repository;

import org.springframework.data.repository.*;
import org.springframework.stereotype.Repository;
import plugin.atb.invest.domain.*;

@Repository
public interface ClientRepository extends CrudRepository<ClientEntity, Long> {

    ClientEntity findByEmail(String email);

}
