create table if not exists stocks
(
    figi        varchar(255) primary key,
    ticker      varchar(255),
    name        varchar(255),
    currency    varchar(255),
    description varchar(255),
    class_code  varchar(255)
);
