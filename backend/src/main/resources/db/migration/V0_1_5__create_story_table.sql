create table if not exists story_Balance
(
    id        bigserial primary key,
    client_id bigint NOT NULL,
    type      varchar(255) NOT NULL,
    amount     numeric(12,4) NOT NULL
);