CREATE TABLE IF NOT EXISTS log_dispositivo (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  dispositivo_nombre VARCHAR(45),
  fecha_insert DATETIME
);


DELIMITER $$

CREATE TRIGGER  tr_log_insert_dispositivo 
AFTER INSERT ON device
FOR EACH ROW
BEGIN
  INSERT INTO log_dispositivo(dispositivo_nombre, fecha_insert)
  VALUES (NEW.device, NOW());
END$$

DELIMITER ;
