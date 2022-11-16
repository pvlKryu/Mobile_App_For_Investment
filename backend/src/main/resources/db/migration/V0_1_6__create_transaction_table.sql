create table if not exists transactions
(
    id                  bigserial primary key,
    name                varchar(255),
    stock_figi          varchar(255),
    client_id           bigint,
    operation_type      boolean,
    transaction_price   decimal(30, 9),
    number_of_stock     int,
    local_date          date
);
