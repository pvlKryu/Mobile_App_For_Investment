package plugin.atb.invest.config;

import org.springframework.beans.factory.annotation.*;
import org.springframework.context.annotation.*;
import ru.tinkoff.piapi.core.*;

@Configuration
@ComponentScan
public class StockConfiguration {

    @Bean
    public InvestApi investApi(
        @Value("${tinkoff.api.token}") String token
    ) {
        return InvestApi.create(token);
    }

}