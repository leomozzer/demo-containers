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

INSERT INTO people VALUE(0, 'Adriano Cardoso', 'adriano.cardoso@skaylink.com', '', '');
INSERT INTO people VALUE(0, 'Andre Espindola', '', '', '');
INSERT INTO people VALUE(0, 'Alison Pereira Silva', '', 'Support Specialist', '');
INSERT INTO people VALUE(0, 'Antonio Arnoni', '', '', '');
INSERT INTO people VALUE(0, 'Bruno Souza',  '', 'Support Specialist', 'Florianopolis');
INSERT INTO people VALUE(0, 'Carlos Rocha', 'carlos.rocha@skaylink.com', '', '');
INSERT INTO people VALUE(0, 'Chris Chappuie', '', 'IT Support Coordinator', 'Florianopolis');
INSERT INTO people VALUE(0, 'Daniel Rosa', 'daniel.rosa@skaylink.com', '', '');
INSERT INTO people VALUE(0, 'Gabriel Souza', '', '', '');
INSERT INTO people VALUE(0, 'Igor Rudolph', '', 'Support Analyst', 'Florianopolis');
INSERT INTO people VALUE(0, 'Joao Vendruscolo', '', '', '');
INSERT INTO people VALUE(0, 'Jonas Cunha', '', '', '');
INSERT INTO people VALUE(0, 'Jonas Odorizzi', '', 'Security Analyst', 'Florianopolis');
INSERT INTO people VALUE(0, 'Karine Oliveira', '', '', '');
INSERT INTO people VALUE(0, 'Leonardo Benitez', '', '', '');
INSERT INTO people VALUE(0, 'Leonardo Souza', '', '', '');
INSERT INTO people VALUE(0, 'Marcelo Santos', '', '', '');
INSERT INTO people VALUE(0, 'Marcio Konopacki', 'marcio.konopacki@skaylink.com', '', '');
INSERT INTO people VALUE(0, 'Mateus Petrolli', '', '', '');
INSERT INTO people VALUE(0, 'Mateus Pioner', '', 'Support Specialist', 'Florianopolis');
INSERT INTO people VALUE(0, 'Monica Kleesattel', '', '', '');
INSERT INTO people VALUE(0, 'Rafael Ferreira', '', 'Support Analyst', 'Florianopolis');
INSERT INTO people VALUE(0, 'Rafael Teixeira', '', 'Security Analyst', 'Florianopolis');
INSERT INTO people VALUE(0, 'Renan Rendon', 'renan.rendon@skaylink.com', '', '');
INSERT INTO people VALUE(0, 'Rodrigo Costa', 'rodrigo.costa@skaylink.com', '', '');
INSERT INTO people VALUE(0, 'Silvio Kleesattel', 'silvio.kleesattel@skaylink.com', '', '');