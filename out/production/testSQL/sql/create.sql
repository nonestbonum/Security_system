CREATE DATABASE test_db;
CREATE USER db_user WITH password 'user';
GRANT ALL privileges ON DATABASE test_db TO db_user;


CREATE TABLE detectors_info
(
    serial_number         VARCHAR(10) PRIMARY KEY NOT NULL UNIQUE,
    installation_location VARCHAR(50)             NOT NULL,
    charge_lvl            DECIMAL                 NOT NULL DEFAULT 100,
    status                INT                     NOT NULL REFERENCES statuses_info (id)
);

CREATE TABLE statuses_info
(
    id          INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
    status_name VARCHAR(30)                                  NOT NULL
);

CREATE TABLE signals_info
(
    id                  INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
    signal_time         TIMESTAMP(0) DEFAULT current_timestamp,
    detector_ser_number VARCHAR(10)                                  NOT NULL REFERENCES detectors_info (serial_number),
    type_of_signal      INT                                          NOT NULL CHECK ( type_of_signal > 0 and type_of_signal < 3)
);

CREATE TABLE detectors_logs_table
(
    id         SERIAL,
    tstamp     TIMESTAMP(0) DEFAULT current_timestamp,
    dat_number VARCHAR(10),
    operation  TEXT,
    who        TEXT         DEFAULT current_user,
    new_val    json,
    old_val    json
);

SELECT signal_time
FROM signals_info;

GRANT SELECT, UPDATE, INSERT ON mytable TO ;