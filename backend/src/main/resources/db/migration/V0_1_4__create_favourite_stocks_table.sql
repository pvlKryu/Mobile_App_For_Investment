create table if not exists favourite_Stock
(
    id        bigserial primary key,
    client_id bigint NOT NULL,
    figi      varchar(255) NOT NULL,
    constraint favourite_Stock_uk unique(client_id, figi)
);
