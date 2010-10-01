create table sessions (
    id           char(72)   primary key,
    session_data text,
    expires      integer,
    created      timestamp    not null
);

create table locations (
    id          serial          primary key,
    
    code        varchar(40)     not null unique,
    name        text            not null unique,
    
    north_lat   float           not null,
    west_lon    float           not null,
    south_lat   float           not null,
    east_lon    float           not null
);

insert into locations
    (code, name, north_lat, west_lon, south_lat, east_lon)
    values
    ( 'london', 'London, UK', 51.713416, -0.539703, 51.273944,  0.299377 );
