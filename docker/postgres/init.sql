CREATE TABLE marketing (
    event_id varchar(32) UNIQUE NOT NULL,
    phone_id varchar(32) NOT NULL,
    ad_id INTEGER NOT NULL,
    provider varchar(20),
    placement varchar(20),
    length INTEGER,
    event_ts timestamp,
    PRIMARY KEY(event_id, phone_id) 
);

CREATE TABLE users (
    event_id varchar(32) UNIQUE NOT NULL,
    user_id varchar(32) NOT NULL,
    phone_id varchar(32) NOT NULL,
    property varchar(20),
    property_value varchar(20),
    event_ts timestamp,
    PRIMARY KEY(event_id, user_id)
);

CREATE TABLE ad_scores(
    ad_id INTEGER NOT NULL,
    provider varchar(20),
    score float,
    PRIMARY KEY(ad_id, provider)
);