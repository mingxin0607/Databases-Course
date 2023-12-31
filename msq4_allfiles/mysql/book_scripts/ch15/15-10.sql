USE ap;

DROP FUNCTION IF EXISTS rand_int;

DELIMITER //

CREATE FUNCTION rand_int()
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
  RETURN ROUND(RAND() * 1000);  
END//

DELIMITER ;

-- Test
SELECT rand_int() AS random_number;
