package plugin.atb.invest;

import io.swagger.v3.oas.annotations.*;
import io.swagger.v3.oas.annotations.enums.*;
import io.swagger.v3.oas.annotations.info.*;
import io.swagger.v3.oas.annotations.security.*;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.scheduling.annotation.*;

@SpringBootApplication
@EnableScheduling
@OpenAPIDefinition(
    info = @Info(title = "ATB-Invest",
        version = "V0.1",
        contact = @Contact(name = "Вся документация к проекту доступна в Wiki",
            url = "https://gitlab.zlob.me/team3/atb-plugin-project/-/wikis/home")
    )
)
@SecurityScheme(
    name = "ATB-Invest",
    scheme = "basic",
    type = SecuritySchemeType.HTTP,
    in = SecuritySchemeIn.HEADER
)
public class InvestApplication {

    public static void main(String[] args) {
        SpringApplication.run(InvestApplication.class, args);
    }

}
