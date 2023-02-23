CREATE OR REPLACE FUNCTION receive_signal(signal TEXT)
    RETURNS TABLE
            (
                ti  TIMESTAMP(0),
                dsn VARCHAR(10),
                zar DOUBLE PRECISION,
                tos INT
            )
AS
$$
DECLARE
    num  VARCHAR(10);
    type INT;
    info DOUBLE PRECISION;
    I_D  INT;
BEGIN
    num = CAST(substring(signal, 1, 10) AS VARCHAR(10));
    type = CAST(substring(signal, 12, 1) AS INT);
    info = CAST(substring(signal, 14, length(signal)) AS DOUBLE PRECISION);

    INSERT INTO signals_info(detector_ser_number, type_of_signal)
    VALUES (num, type)
    returning id into I_D;
    UPDATE detectors_info
    SET charge_lvl = info
    WHERE serial_number = num;
    UPDATE signals_info
    SET type_of_signal = type
    WHERE detector_ser_number = num;
    RETURN QUERY
        SELECT signal_time, detector_ser_number, di.charge_lvl, type_of_signal
        FROM signals_info
                 join detectors_info di on di.serial_number = signals_info.detector_ser_number
        where id = I_D;
END
$$
    LANGUAGE plpgsql;

select receive_signal('a8agagagag|2|60');

DROP FUNCTION receive_signal(text)