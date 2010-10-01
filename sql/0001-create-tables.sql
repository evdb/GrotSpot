create table sessions (
    id           char(72)   primary key,
    session_data text,
    expires      integer,
    created      timestamp    not null
);

create table areas (
    id          serial          primary key,
    
    code        varchar(40)     not null unique,
    name        text            not null unique,
    
    north_lat   float           not null,
    west_lng    float           not null,
    south_lat   float           not null,
    east_lng    float           not null
);

insert into areas
    (code, name, north_lat, west_lng, south_lat, east_lng)
    values
    ( 'london', 'London, UK', 51.713416, -0.539703, 51.273944,  0.299377 );



create table locations (
    id          serial          primary key,
    lat         float           not null,
    lng         float           not null
);
create unique index locations_lat_lng_key on locations ( lat, lng );



create table emails (
    id          serial          primary key,
    email       varchar(200)    not null unique
);



create table ratings (
    id          serial          primary key,
    location_id int8            not null references locations(id),
    session_id  char(72)        not null,
    email_id    int8            references emails(id),
    score       int             not null
);