package plugin.atb.invest.mapper;

import java.math.*;

import org.modelmapper.*;
import plugin.atb.invest.domain.*;
import plugin.atb.invest.dto.*;
import plugin.atb.invest.model.*;

public class ClientMapper {

    public static void initModelMapper(ModelMapper modelMapper) {
        modelMapper.createTypeMap(ClientEntity.class, ClientModel.class)
            .setConverter(mappingContext -> {
                ClientEntity clientEntity = mappingContext.getSource();
                ClientModel clientModel = new ClientModel();
                clientModel.setId(clientEntity.getId());
                clientModel.setName(clientEntity.getName());
                clientModel.setEmail(clientEntity.getEmail());
                clientModel.setPassword(clientEntity.getPassword());
                clientModel.setBalance(clientEntity.getBalance());
                return clientModel;
            });

        modelMapper.createTypeMap(ClientModel.class, ClientRegistrationDto.class)
            .setConverter(mappingContext -> {
                ClientModel clientModel = mappingContext.getSource();
                ClientRegistrationDto clientRegistrationDto = new ClientRegistrationDto();
                clientRegistrationDto.setName(clientModel.getName());
                clientRegistrationDto.setEmail(clientModel.getEmail());
                clientRegistrationDto.setPassword(clientModel.getPassword());
                return clientRegistrationDto;
            });

        modelMapper.createTypeMap(ClientRegistrationDto.class, ClientModel.class)
            .setConverter(mappingContext -> {
                ClientRegistrationDto clientRegistrationDto = mappingContext.getSource();
                ClientModel clientModel = new ClientModel();
                clientModel.setName(clientRegistrationDto.getName());
                clientModel.setEmail(clientRegistrationDto.getEmail());
                clientModel.setPassword(clientRegistrationDto.getPassword());
                clientModel.setBalance(BigDecimal.ZERO);
                return clientModel;
            });

        modelMapper.createTypeMap(ClientModel.class, ClientEntity.class)
            .setConverter(mappingContext -> {
                ClientModel clientModel = mappingContext.getSource();
                ClientEntity clientEntity = new ClientEntity();
                clientEntity.setName(clientModel.getName());
                clientEntity.setEmail(clientModel.getEmail());
                clientEntity.setPassword(clientModel.getPassword());
                clientEntity.setBalance(clientModel.getBalance());
                return clientEntity;
            });

        modelMapper.createTypeMap(ClientModel.class, ClientAuthDtoResponse.class)
            .setConverter(mappingContext -> {
                ClientModel clientModel = mappingContext.getSource();
                ClientAuthDtoResponse clientAuthDtoResponse = new ClientAuthDtoResponse();
                clientAuthDtoResponse.setId(clientModel.getId());
                clientAuthDtoResponse.setName(clientModel.getName());
                clientAuthDtoResponse.setEmail(clientModel.getEmail());
                clientAuthDtoResponse.setBalance(clientModel.getBalance());
                return clientAuthDtoResponse;
            });

        modelMapper.createTypeMap(BalanceStoryDtoRequest.class, BalanceStoryRequestModel.class)
            .setConverter(mappingContext -> {
                BalanceStoryDtoRequest balanceStoryDtoRequest = mappingContext.getSource();
                BalanceStoryRequestModel balanceStoryRequestModel = new BalanceStoryRequestModel();
                balanceStoryRequestModel.setTypeOfOperation(balanceStoryDtoRequest.getTypeOfOperation());
                return balanceStoryRequestModel;
            });
    }

}
