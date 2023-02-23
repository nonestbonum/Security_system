CREATE OR REPLACE FUNCTION change_trigger() RETURNS trigger AS
$$
BEGIN
    IF TG_OP = 'INSERT'
    THEN
        INSERT INTO detectors_logs_table (dat_number, operation, new_val)
        VALUES (NEW.serial_number, TG_OP, row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE'
    THEN
        INSERT INTO detectors_logs_table (dat_number, operation, new_val, old_val)
        VALUES (NEW.serial_number, TG_OP, row_to_json(NEW), row_to_json(OLD));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE'
    THEN
        INSERT INTO detectors_logs_table (dat_number, operation, old_val)
        VALUES (OLD.serial_number, TG_OP, row_to_json(OLD));
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

CREATE OR REPLACE TRIGGER detectors_info_trigger
    BEFORE INSERT OR UPDATE OR DELETE
    ON detectors_info
    FOR EACH ROW
EXECUTE PROCEDURE change_trigger();
