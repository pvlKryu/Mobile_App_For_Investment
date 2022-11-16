package plugin.atb.invest.service;

import java.util.*;

import lombok.*;
import org.modelmapper.*;
import org.springframework.scheduling.annotation.*;
import org.springframework.stereotype.*;
import plugin.atb.invest.domain.*;
import plugin.atb.invest.repository.*;
import ru.tinkoff.piapi.contract.v1.*;
import ru.tinkoff.piapi.core.*;

@Component
@AllArgsConstructor
public class StockRepositoryUpdater {

    private StockRepository stockRepository;

    private InvestApi investApi;

    private ModelMapper modelMapper;

    @Scheduled(fixedDelay = 300000)
    private void updateStocksTable() {
        List<Share> shares = investApi.getInstrumentsService().getAllSharesSync();
        List<StockEntity> stockEntities = shares.stream()
            .map(share -> modelMapper.map(share, StockEntity.class))
            .toList();
        stockRepository.saveAll(stockEntities);
    }

}
