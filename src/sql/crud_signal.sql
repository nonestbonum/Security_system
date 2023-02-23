-- добавление данных о сигнале

CREATE OR REPLACE FUNCTION add_signal(t TIMESTAMP(0), det_ser_n VARCHAR(10), st INT)
    RETURNS
        TABLE
        (
            ti  TIMESTAMP(0),
            dsn VARCHAR(10),
            tos INT
        )
AS
$$
DECLARE
    my_result INT;
BEGIN
    INSERT INTO signals_info(signal_time, detector_ser_number, type_of_signal)
    VALUES (t, det_ser_n, st)
    returning id into my_result;
    RETURN QUERY
        SELECT signal_time, detector_ser_number, type_of_signal FROM signals_info where id = my_result;
END
$$
    LANGUAGE plpgsql;

-- удаление данных о сигнале

CREATE OR REPLACE FUNCTION delete_signal(t TIMESTAMP(0), det_ser_n VARCHAR(10), st INT)
    RETURNS TABLE
            (
                ti  TIMESTAMP(0),
                dsn VARCHAR(10),
                tos INT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT signal_time, detector_ser_number, type_of_signal
        FROM signals_info
        WHERE signal_time = t
          and detector_ser_number = det_ser_n
          and type_of_signal = st;
    DELETE
    FROM signals_info
    WHERE signal_time = t
      and detector_ser_number = det_ser_n
      and type_of_signal = st;
END
$$
    LANGUAGE plpgsql;

-- изменение данных о сигнале

CREATE OR REPLACE FUNCTION change_signal(i_d INT, sig_time TIMESTAMP(0), dst_set_n VARCHAR(10),
                                         type_of_s INT)
    RETURNS TABLE
            (
                i   INT,
                ti  TIMESTAMP(0),
                dsn VARCHAR(10),
                tos INT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT id, signal_time, detector_ser_number, type_of_signal from signals_info where id = i_d;
    UPDATE signals_info
    SET signal_time         = sig_time,
        detector_ser_number = dst_set_n,
        type_of_signal      = type_of_s
    WHERE id = i_d;
    RETURN QUERY
        SELECT id, signal_time, detector_ser_number, type_of_signal from signals_info where id = i_d;
END;
$$
    LANGUAGE plpgsql;
