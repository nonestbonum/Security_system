CREATE OR REPLACE FUNCTION info_about_signal_per_interval(start TIMESTAMP(0), e TIMESTAMP(0))
    RETURNS TABLE
            (
                signn_t TIMESTAMP(0),
                ser_n VARCHAR(10),
                type_of_s INT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT signal_time, detector_ser_number, type_of_signal from signals_info where signal_time >= start  and signal_time <= e;
END
$$
    LANGUAGE plpgsql;