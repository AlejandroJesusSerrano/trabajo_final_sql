vista_dispositivos_por_oficina CREATE VIEW vista_dispositivos_por_oficina AS
SELECT 
    d.device,
    d.serial_number,
    d.ip,
    o.office,
    ol.floor,
    ol.wing,
    e.address AS edificio,
    e.location,
    e.province
FROM device d
JOIN office o ON d.office = o.id_office
JOIN office_loc ol ON o.office_edfice_location = ol.id_office_loc
JOIN edifice e ON ol.edifice = e.id_edifice;


CREATE VIEW vista_puertos_pared_completo AS
SELECT 
    wp.wall_port_name,
    o.office,
    pp.patch_port,
    sp.port_id AS switch_port
FROM wall_port wp
LEFT JOIN office o ON wp.office = o.id_office
LEFT JOIN patch_port pp ON wp.patch_port_in = pp.id_patch_port
LEFT JOIN switch_port sp ON wp.switch_port_in = sp.id_switch_port;

CREATE VIEW vista_rack_conectado AS
SELECT 
    r.rack_name,
    o.office AS ubicacion,
    s.serial_number AS switch_serial,
    p.patchera,
    COUNT(sp.id_switch_port) AS cantidad_puertos_switch
FROM rack r
LEFT JOIN office o ON r.office = o.id_office
LEFT JOIN switch s ON s.rack = r.id_rack
LEFT JOIN patchera p ON p.rack = r.id_rack
LEFT JOIN switch_port sp ON sp.switch = s.id_switch
GROUP BY r.id_rack;
