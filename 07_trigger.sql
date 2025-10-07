CREATE OR REPLACE TRIGGER free_room_after_checkout
AFTER UPDATE OF check_out ON customers
FOR EACH ROW
WHEN (NEW.check_out IS NOT NULL)
BEGIN
    UPDATE rooms SET is_available = 'Y' WHERE room_id = :NEW.room_id;
END;
/