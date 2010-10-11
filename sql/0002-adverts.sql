begin;

create table adverts (
    id          serial          primary key,
    created     timestamp       not null,
    enabled     bool            not null,
    
    heading     text            not null,
    blurb       text            not null,
    price       float           not null,
    url         text            not null,
    image_url   text,
    
    view_count  int8            not null,
    click_count int8            not null
);

create table advert_clicks (
    id          serial          primary key,
    created     timestamp       not null,
    advert_id   int8            not null references adverts(id),
    session_id  char(72)        not null,
    referer     text

);

commit;