package plugin.atb.invest.service;

import lombok.*;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.*;
import plugin.atb.invest.domain.*;
import plugin.atb.invest.model.*;
import plugin.atb.invest.repository.*;

@Service
@AllArgsConstructor
public class UserAuthService implements UserDetailsService {

    private ClientRepository clientRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        ClientEntity clientEntity = clientRepository.findByEmail(email);
        if (clientEntity == null) {
            throw new UsernameNotFoundException("User not found");
        }
        return new AuthUserModel(clientEntity);
    }

}
