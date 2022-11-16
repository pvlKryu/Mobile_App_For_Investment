package plugin.atb.invest.service;

import java.math.*;

import lombok.*;
import org.modelmapper.*;
import org.springframework.security.crypto.password.*;
import org.springframework.stereotype.*;
import plugin.atb.invest.domain.*;
import plugin.atb.invest.dto.*;
import plugin.atb.invest.exception.*;
import plugin.atb.invest.model.*;
import plugin.atb.invest.repository.*;

@Service
@AllArgsConstructor
public class ClientService {

    private final SecurityService securityService;

    private final ModelMapper modelMapper;

    private final ClientRepository clientRepository;

    private final StoryBalanceRepository storyBalanceRepository;

    private final PasswordEncoder passwordEncoder;

    public void createClient(ClientModel clientModel) {
        if (clientRepository.findByEmail(clientModel.getEmail()) != null) {
            throw new EmailAlreadyExistsException("User with this email already exists");
        }
        clientModel.setPassword(passwordEncoder.encode(clientModel.getPassword()));
        ClientEntity clientEntity = modelMapper.map(clientModel, ClientEntity.class);
        clientRepository.save(clientEntity);
    }

    public ClientModel getClientByEmail(String email) {
        ClientEntity clientEntity = clientRepository.findByEmail(email);
        return modelMapper.map(clientEntity, ClientModel.class);
    }

    public void changeClient(ClientChangeDataModel clientChangeDataModel) {
        String newEmail = clientChangeDataModel.getEmail();
        if (!securityService.getEmailFromAuth().equals(newEmail) &&
            clientRepository.findByEmail(newEmail) != null) {
            throw new EmailAlreadyExistsException("User with this email already exists");
        }
        ClientEntity clientEntity = clientRepository.findByEmail(securityService.getEmailFromAuth());
        clientEntity.setName(clientChangeDataModel.getName());
        clientEntity.setEmail(clientChangeDataModel.getEmail());
        clientEntity.setPassword(passwordEncoder.encode(clientChangeDataModel.getPassword()));
        clientRepository.save(clientEntity);
    }

    public BigDecimal changeBalance(String email, BalanceDtoRequest balanceDtoRequest) {
        ClientEntity clientEntity = clientRepository.findByEmail(email);
        BigDecimal balance = clientEntity.getBalance();
        if (balanceDtoRequest.getTypeOfOperation().equals(TypeOfOperation.ADD)) {
            balance = balance.add(balanceDtoRequest.getAmount());
        } else {
            if (balance.subtract(balanceDtoRequest.getAmount()).doubleValue() < 0) {
                throw new NegativeBalanceException("After the operation, " +
                                                   "you will get a negative balance");
            }
            balance = balance.subtract(balanceDtoRequest.getAmount());
        }
        clientEntity.setBalance(balance);
        clientRepository.save(clientEntity);
        return balance;
    }

    public BigDecimal getBalance(String email) {
        ClientEntity clientEntity = clientRepository.findByEmail(email);
        return clientEntity.getBalance();
    }

    public void balanceStory(BalanceDtoRequest balanceDtoRequest) {
        ClientEntity clientEntity = clientRepository.findByEmail(securityService.getEmailFromAuth());
        StoryBalanceEntity storyBalanceEntity = new StoryBalanceEntity();
        storyBalanceEntity.setClientEntity(clientEntity);
        storyBalanceEntity.setType(balanceDtoRequest.getTypeOfOperation());
        storyBalanceEntity.setAmount(balanceDtoRequest.getAmount());
        storyBalanceRepository.save(storyBalanceEntity);
    }

    public String SumAllBalanceHistory(BalanceStoryRequestModel balanceStoryRequestModel) {
        ClientEntity clientEntity = clientRepository.findByEmail(securityService.getEmailFromAuth());
        Long id = clientEntity.getId();
        return storyBalanceRepository.SumAllTypes(
            id,
            balanceStoryRequestModel.getTypeOfOperation().toString());
    }

}
