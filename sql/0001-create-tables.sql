create table sessions (
    id           char(72)   primary key,
    session_data text,
    expires      integer,
    created      timestamp    not null
);
