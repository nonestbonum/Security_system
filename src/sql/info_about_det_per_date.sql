CREATE OR REPLACE FUNCTION info_about_det_per_date(t DATE)
    RETURNS TABLE
            (
                ts  time,
                dn  VARCHAR(10),
                act VARCHAR(10),
                new_inf json,
                old_inf json
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT CAST(tstamp AS time), dat_number, CAST(operation AS VARCHAR(10)), new_val, old_val from detectors_logs_table where tstamp::timestamp::date = t;
END
$$
    LANGUAGE plpgsql;