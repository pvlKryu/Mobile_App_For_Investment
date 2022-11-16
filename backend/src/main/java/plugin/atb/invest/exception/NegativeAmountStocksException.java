package plugin.atb.invest.exception;

public class NegativeAmountStocksException extends RuntimeException {

    public NegativeAmountStocksException(String message) {
        super(message);
    }

}
