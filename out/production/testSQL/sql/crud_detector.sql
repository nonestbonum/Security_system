-- добавление данных о датчиках

CREATE OR REPLACE function add_detector(s VARCHAR(10), i VARCHAR(50), ch double precision, st INT)
    RETURNS TABLE
            (
                ser     VARCHAR(10),
                ins     VARCHAR(50),
                db      DOUBLE PRECISION,
                st_name VARCHAR(30)
            )
AS
$$
DECLARE
BEGIN
    INSERT INTO detectors_info(serial_number, installation_location, charge_lvl, status)
    VALUES (s, i, ch, st);
    RETURN QUERY
        SELECT serial_number, installation_location, charge_lvl, si.status_name
        FROM detectors_info
                 JOIN statuses_info si on si.id = detectors_info.status
        WHERE serial_number = s;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION '% serial number already in the db', s;
END
$$
    LANGUAGE plpgsql;

--

CREATE OR REPLACE FUNCTION add_detector_with_full_charge(s VARCHAR(10), i VARCHAR(50), st INT)
    RETURNS TABLE
            (
                ser     VARCHAR(10),
                ins     VARCHAR(50),
                st_name VARCHAR(30)
            )
AS
$$
BEGIN
    INSERT INTO detectors_info(serial_number, installation_location, status)
    VALUES (s, i, st);
    RETURN QUERY
        SELECT serial_number, installation_location, si.status_name
        FROM detectors_info
                 JOIN statuses_info si on si.id = detectors_info.status
        WHERE serial_number = s;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION '% serial number already in the db', s;
END
$$
    LANGUAGE plpgsql;

-- удаление данных о датчиках

CREATE OR REPLACE FUNCTION delete_detector(s VARCHAR(10))
    RETURNS TABLE
            (
                ser     VARCHAR(10),
                ins     VARCHAR(50),
                st_name VARCHAR(30)
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT serial_number, installation_location, si.status_name
        FROM detectors_info
                 JOIN statuses_info si on si.id = detectors_info.status
        WHERE serial_number = s;
    DELETE FROM detectors_info WHERE serial_number LIKE s;
END
$$
    LANGUAGE plpgsql;

-- изменение данных о датчиках

CREATE OR REPLACE FUNCTION change_detector(s VARCHAR(10), i VARCHAR(50), ch_lvl DOUBLE PRECISION, st INT)
    RETURNS TABLE
            (
                ser     VARCHAR(10),
                ins     VARCHAR(50),
                chlvl   DOUBLE PRECISION,
                st_name VARCHAR(30)
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT serial_number, installation_location, charge_lvl, si.status_name
        FROM detectors_info
                 JOIN statuses_info si on si.id = detectors_info.status
        WHERE serial_number = s;
    UPDATE detectors_info
    SET serial_number         = s,
        installation_location = i,
        charge_lvl            = ch_lvl,
        status                = st
    WHERE serial_number = s;
    RETURN QUERY
        SELECT serial_number, installation_location, charge_lvl, si.status_name
        FROM detectors_info
                 JOIN statuses_info si on si.id = detectors_info.status
        WHERE serial_number = s;
END;
$$
    LANGUAGE plpgsql;