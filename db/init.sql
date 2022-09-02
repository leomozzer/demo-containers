CREATE DATABASE IF NOT EXISTS skaylinkbr;
USE skaylinkbr;

CREATE TABLE IF NOT EXISTS people (
  id INT(11) AUTO_INCREMENT,
  full_name VARCHAR(255),
  email VARCHAR(255),
  title VARCHAR(100),
  location_name VARCHAR(100),    
  PRIMARY KEY (id)
);

INSERT INTO people VALUE(0, 'Luningning Ingmar', 'luningning.ingmar@contoso.com', '', '');
INSERT INTO people VALUE(0, 'Matty Finn', '', '', '');
INSERT INTO people VALUE(0, 'Laura Jef', '', 'Support Specialist', '');
INSERT INTO people VALUE(0, 'Lise Sesto', '', '', '');
INSERT INTO people VALUE(0, 'Hartwin Aang',  '', 'Support Specialist', 'Springfield');
INSERT INTO people VALUE(0, 'Aldegund Lena', 'aldegund.lena@contoso.com', '', '');
INSERT INTO people VALUE(0, 'Gabrijel Torcull', '', 'IT Support Coordinator', 'Springfield');
INSERT INTO people VALUE(0, 'Cathalán Toufik', 'cathalan.toufik@contoso.com', '', '');