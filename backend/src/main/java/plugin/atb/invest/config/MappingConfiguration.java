package plugin.atb.invest.config;

import org.modelmapper.*;
import org.modelmapper.convention.*;
import org.springframework.context.annotation.*;
import plugin.atb.invest.mapper.*;

import static org.modelmapper.config.Configuration.AccessLevel.*;

@Configuration
public class MappingConfiguration {

    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();
        modelMapper.getConfiguration()
            .setMatchingStrategy(MatchingStrategies.STRICT)
            .setFieldMatchingEnabled(true)
            .setSkipNullEnabled(true)
            .setFieldAccessLevel(PRIVATE);
        StockMapper.initModelMapper(modelMapper);
        ClientMapper.initModelMapper(modelMapper);
        TransactionMapper.initModelMapper(modelMapper);
        return modelMapper;
    }

}
