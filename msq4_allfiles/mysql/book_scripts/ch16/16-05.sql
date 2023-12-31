SHOW VARIABLES LIKE 'event_scheduler';

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS one_time_delete_audit_rows;
DROP EVENT IF EXISTS monthly_delete_audit_rows;

DELIMITER //

CREATE EVENT one_time_delete_audit_rows
ON SCHEDULE AT NOW() + INTERVAL 1 MONTH
DO BEGIN
  DELETE FROM invoices_audit WHERE action_date < NOW() - INTERVAL 1 MONTH;
END//

CREATE EVENT monthly_delete_audit_rows
ON SCHEDULE EVERY 1 MONTH
STARTS '2023-06-01'
DO BEGIN
  DELETE FROM invoices_audit WHERE action_date < NOW() - INTERVAL 1 MONTH;
END//

DELIMITER ;
