CREATE SCHEMA IF NOT EXISTS `plan_network` DEFAULT CHARACTER SET utf8;
USE `plan_network`;

-- Tabla: dev_type
CREATE TABLE `dev_type` (
  `id_dev_type` INT NOT NULL AUTO_INCREMENT,
  `dev_type` VARCHAR(45),
  PRIMARY KEY (`id_dev_type`)
) ENGINE = InnoDB;

-- Tabla: brand
CREATE TABLE `brand` (
  `id_brand` INT NOT NULL AUTO_INCREMENT,
  `brand` VARCHAR(45),
  PRIMARY KEY (`id_brand`)
) ENGINE = InnoDB;

-- Tabla: dev_model
CREATE TABLE `dev_model` (
  `id_dev_model` INT NOT NULL AUTO_INCREMENT,
  `fbrand` INT,
  `dev_type` INT,
  `dev_model` VARCHAR(45),
  PRIMARY KEY (`id_dev_model`),
  FOREIGN KEY (`fbrand`) REFERENCES `brand` (`id_brand`) ON DELETE CASCADE,
  FOREIGN KEY (`dev_type`) REFERENCES `dev_type` (`id_dev_type`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla: edifice
CREATE TABLE `edifice` (
  `id_edifice` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(45),
  `location` VARCHAR(45),
  `province` VARCHAR(45),
  PRIMARY KEY (`id_edifice`)
) ENGINE = InnoDB;

-- Tabla: office_loc
CREATE TABLE `office_loc` (
  `id_office_loc` INT NOT NULL AUTO_INCREMENT,
  `edifice` INT,
  `wing` VARCHAR(45),
  `floor` VARCHAR(45),
  PRIMARY KEY (`id_office_loc`),
  FOREIGN KEY (`edifice`) REFERENCES `edifice` (`id_edifice`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla: office
CREATE TABLE `office` (
  `id_office` INT NOT NULL AUTO_INCREMENT,
  `office` VARCHAR(45),
  `office_edfice_location` INT,
  PRIMARY KEY (`id_office`),
  FOREIGN KEY (`office_edfice_location`) REFERENCES `office_loc` (`id_office_loc`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla: rack
CREATE TABLE `rack` (
  `id_rack` INT NOT NULL AUTO_INCREMENT,
  `office` INT,
  `rack_name` VARCHAR(45),
  PRIMARY KEY (`id_rack`),
  FOREIGN KEY (`office`) REFERENCES `office` (`id_office`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla: patchera
CREATE TABLE `patchera` (
  `id_patchera` INT NOT NULL AUTO_INCREMENT,
  `patchera` VARCHAR(45),
  `rack` INT,
  PRIMARY KEY (`id_patchera`),
  FOREIGN KEY (`rack`) REFERENCES `rack` (`id_rack`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla: switch_model
CREATE TABLE `switch_model` (
  `id_switch_model` INT NOT NULL AUTO_INCREMENT,
  `switch_brand` INT,
  `switch_model` VARCHAR(45),
  PRIMARY KEY (`id_switch_model`),
  FOREIGN KEY (`switch_brand`) REFERENCES `brand` (`id_brand`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla: switch
CREATE TABLE `switch` (
  `id_switch` INT NOT NULL AUTO_INCREMENT,
  `switch_model` INT,
  `serial_number` VARCHAR(45),
  `ports_q` VARCHAR(45),
  `rack` INT,
  `office` INT,
  `switch_port_in` INT,
  `wall_port_in` INT,
  `patch_port_in` INT,
  PRIMARY KEY (`id_switch`),
  FOREIGN KEY (`switch_model`) REFERENCES `switch_model` (`id_switch_model`) ON DELETE CASCADE,
  FOREIGN KEY (`rack`) REFERENCES `rack` (`id_rack`) ON DELETE CASCADE,
  FOREIGN KEY (`office`) REFERENCES `office` (`id_office`) ON DELETE CASCADE
  -- FKs diferidas: switch_port_in, wall_port_in, patch_port_in
) ENGINE = InnoDB;

-- Tabla: switch_port
CREATE TABLE `switch_port` (
  `id_switch_port` INT NOT NULL AUTO_INCREMENT,
  `switch` INT,
  `port_id` VARCHAR(45),
  PRIMARY KEY (`id_switch_port`),
  FOREIGN KEY (`switch`) REFERENCES `switch` (`id_switch`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Tabla: patch_port
CREATE TABLE `patch_port` (
  `id_patch_port` INT NOT NULL AUTO_INCREMENT,
  `patchera` INT,
  `patch_port` VARCHAR(45),
  `switch_port_in` INT,
  PRIMARY KEY (`id_patch_port`),
  FOREIGN KEY (`patchera`) REFERENCES `patchera` (`id_patchera`) ON DELETE CASCADE
  -- FK diferida: switch_port_in
) ENGINE = InnoDB;

-- Tabla: wall_port
CREATE TABLE `wall_port` (
  `id_wall_port` INT NOT NULL AUTO_INCREMENT,
  `wall_port_name` VARCHAR(45),
  `office` INT,
  `patch_port_in` INT,
  `switch_port_in` INT,
  PRIMARY KEY (`id_wall_port`),
  FOREIGN KEY (`office`) REFERENCES `office` (`id_office`) ON DELETE CASCADE
  -- FKs diferidas: patch_port_in, switch_port_in
) ENGINE = InnoDB;

-- Tabla: device
CREATE TABLE `device` (
  `id_device` INT NOT NULL AUTO_INCREMENT,
  `dev_model` INT,
  `device` VARCHAR(45),
  `wall_port_in` INT,
  `switch_port_in` INT,
  `patch_port_in` INT,
  `serial_number` VARCHAR(45),
  `ip` VARCHAR(45),
  `office` INT,
  PRIMARY KEY (`id_device`),
  FOREIGN KEY (`dev_model`) REFERENCES `dev_model` (`id_dev_model`) ON DELETE CASCADE
  -- FKs diferidas: wall_port_in, switch_port_in, patch_port_in, office
) ENGINE = InnoDB;

-- Tabla: employee
CREATE TABLE `employee` (
  `id_employee` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45),
  `apellido` VARCHAR(45),
  PRIMARY KEY (`id_employee`)
) ENGINE = InnoDB;

-- Tabla: device_employee
CREATE TABLE `device_employee` (
  `id_device_employee` INT NOT NULL AUTO_INCREMENT,
  `device_id` INT,
  `employee_id` INT,
  PRIMARY KEY (`id_device_employee`),
  FOREIGN KEY (`device_id`) REFERENCES `device` (`id_device`) ON DELETE CASCADE,
  FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id_employee`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- Agregar FKs diferidas (por circularidad o dependencias tardías)
ALTER TABLE `switch` ADD CONSTRAINT `fk_switch_port_in` FOREIGN KEY (`switch_port_in`) REFERENCES `switch_port` (`id_switch_port`) ON DELETE CASCADE;
ALTER TABLE `switch` ADD CONSTRAINT `fk_wall_port_in` FOREIGN KEY (`wall_port_in`) REFERENCES `wall_port` (`id_wall_port`) ON DELETE CASCADE;
ALTER TABLE `switch` ADD CONSTRAINT `fk_patch_port_in` FOREIGN KEY (`patch_port_in`) REFERENCES `patch_port` (`id_patch_port`) ON DELETE CASCADE;
ALTER TABLE `patch_port` ADD CONSTRAINT `fk_switch_port_in_patch` FOREIGN KEY (`switch_port_in`) REFERENCES `switch_port` (`id_switch_port`) ON DELETE CASCADE;
ALTER TABLE `wall_port` ADD CONSTRAINT `fk_patch_port_in_wall` FOREIGN KEY (`patch_port_in`) REFERENCES `patch_port` (`id_patch_port`) ON DELETE CASCADE;
ALTER TABLE `wall_port` ADD CONSTRAINT `fk_switch_port_in_wall` FOREIGN KEY (`switch_port_in`) REFERENCES `switch_port` (`id_switch_port`) ON DELETE CASCADE;
ALTER TABLE `device` ADD CONSTRAINT `fk_wall_port_in_device` FOREIGN KEY (`wall_port_in`) REFERENCES `wall_port` (`id_wall_port`) ON DELETE CASCADE;
ALTER TABLE `device` ADD CONSTRAINT `fk_switch_port_in_device` FOREIGN KEY (`switch_port_in`) REFERENCES `switch_port` (`id_switch_port`) ON DELETE CASCADE;
ALTER TABLE `device` ADD CONSTRAINT `fk_patch_port_in_device` FOREIGN KEY (`patch_port_in`) REFERENCES `patch_port` (`id_patch_port`) ON DELETE CASCADE;
ALTER TABLE `device` ADD CONSTRAINT `fk_office_in_device` FOREIGN KEY (`office`) REFERENCES `office` (`id_office`) ON DELETE CASCADE;
