-- Trigger to prevent deleting a user who booked a ticket
CREATE OR REPLACE TRIGGER trg_prevent_user_delete_with_ticket
BEFORE DELETE ON cinema_user
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM ticket
  WHERE user_id = :OLD.user_id;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20000, 'User has booked tickets and cannot be deleted!');
  END IF;
END;
/

-- Testing the Trigger
BEGIN
    DELETE FROM cinema_user
    WHERE user_id = 'U0001';  
END;
/


