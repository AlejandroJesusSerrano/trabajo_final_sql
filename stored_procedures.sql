DELIMITER $$

CREATE PROCEDURE sp_asignar_dispositivo_a_oficina(
  IN p_device_id INT,
  IN p_office_id INT
)
BEGIN
  UPDATE device
  SET office = p_office_id
  WHERE id_device = p_device_id;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_insertar_dispositivo_completo(
  IN p_modelo_id INT,
  IN p_nombre VARCHAR(45),vista_dispositivos_por_oficinadevicevista_dispositivos_por_oficinavista_dispositivos_por_oficina
  IN p_wall_port_id INT,
  IN p_switch_port_id INT,
  IN p_patch_port_id INT,
  IN p_serial VARCHAR(45),
  IN p_ip VARCHAR(45),
  IN p_office_id INT
)
BEGIN
  INSERT INTO device (
    dev_model, device, wall_port_in, switch_port_in, patch_port_in,
    serial_number, ip, office
  )
  VALUES (
    p_modelo_id, p_nombre, p_wall_port_id, p_switch_port_id,
    p_patch_port_id, p_serial, p_ip, p_office_id
  );
END$$

DELIMITER ;


