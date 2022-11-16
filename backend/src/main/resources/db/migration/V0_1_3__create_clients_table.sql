create table if not exists clients
(
    id       bigserial primary key,
    name     varchar(255),
    email    varchar(255),
    password varchar(255),
    balance  numeric(12,4)
);
