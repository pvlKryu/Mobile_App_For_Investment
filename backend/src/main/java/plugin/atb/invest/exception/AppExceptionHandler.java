package plugin.atb.invest.exception;

import java.time.*;

import org.jetbrains.annotations.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.*;
import org.springframework.web.servlet.*;
import org.springframework.web.servlet.mvc.method.annotation.*;

@ControllerAdvice
public class AppExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(EmptyDatabaseException.class)
    public ResponseEntity<Object> handleEmptyDatabaseException(EmptyDatabaseException exception) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(ExternalApiException.class)
    public ResponseEntity<Object> handleExternalApiException(ExternalApiException exception) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.GATEWAY_TIMEOUT);
    }

    @ExceptionHandler(WrongFigiException.class)
    public ResponseEntity<Object> handleWrongFigiException(WrongFigiException exception) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<Object> BadRequestException(
        BadRequestException exception
    ) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(DuplicateConflictException.class)
    public ResponseEntity<Object> DuplicateConflictException(
        DuplicateConflictException exception
    ) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.CONFLICT);
    }

    @ExceptionHandler(DoesNotExistException.class)
    public ResponseEntity<Object> DoesNotExistException(
        DoesNotExistException exception
    ) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.GONE);
    }

    @ExceptionHandler(EmailAlreadyExistsException.class)
    public ResponseEntity<Object> handleEmailAlreadyExistsException(
        EmailAlreadyExistsException exception
    ) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.CONFLICT);
    }

    @ExceptionHandler(NegativeBalanceException.class)
    public ResponseEntity<Object> handleNegativeBalanceException(
        NegativeBalanceException exception
    ) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(NegativeAmountStocksException.class)
    public ResponseEntity<Object> handleNegativeAmountStocksException(
        NegativeAmountStocksException exception
    ) {
        return new ResponseEntity<>(
            new ApiError(
                exception.getMessage(),
                LocalDateTime.now()),
            HttpStatus.BAD_REQUEST);
    }

    @Override
    protected @NotNull ResponseEntity<Object> handleNoHandlerFoundException(
        @NotNull NoHandlerFoundException ex,
        @NotNull HttpHeaders headers,
        @NotNull HttpStatus status,
        @NotNull WebRequest request
    ) {
        return super.handleNoHandlerFoundException(ex, headers, status, request);
    }

}
