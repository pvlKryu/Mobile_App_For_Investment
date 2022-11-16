package plugin.atb.invest.model;

import java.util.*;

import lombok.*;
import org.springframework.security.core.*;
import org.springframework.security.core.authority.*;
import org.springframework.security.core.userdetails.*;
import plugin.atb.invest.domain.*;

@Data
@AllArgsConstructor
public class AuthUserModel implements UserDetails {

    private ClientEntity clientEntity;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return AuthorityUtils.createAuthorityList("user");
    }

    @Override
    public String getPassword() {
        return clientEntity.getPassword();
    }

    @Override
    public String getUsername() {
        return clientEntity.getEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

}
