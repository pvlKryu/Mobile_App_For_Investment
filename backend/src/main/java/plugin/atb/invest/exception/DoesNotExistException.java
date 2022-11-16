package plugin.atb.invest.exception;

public class DoesNotExistException extends RuntimeException {

    public DoesNotExistException(String message) {
        super(message);
    }

}