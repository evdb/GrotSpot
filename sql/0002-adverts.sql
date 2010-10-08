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
    session_id  int8            not null
);


-- FIXME - just for dev

insert into adverts( created, enabled, heading, blurb, price, url, image_url, view_count, click_count )
    values (
        now(),
        true,
        'This is the heading',
        'This is the blurb',
        12.34,
        'http://www.google.co.uk/',
        'http://cindy.local:3000/static/icons/grotspot_logo.png',
        0,
        0
        );
            














commit;