-- Crear la base de datos
CREATE DATABASE videojuegos;
USE videojuegos;

-- Crear la tabla de categorías de videojuegos
CREATE TABLE categoria (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);

-- Crear la tabla de clientes
CREATE TABLE cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    correo_cliente VARCHAR(100) UNIQUE NOT NULL
);

-- Crear la tabla de videojuegos
CREATE TABLE videojuego (
    videojuego_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_videojuego VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    fecha_lanzamiento DATE,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categoria(categoria_id)
);

-- Crear la tabla de plataformas de videojuegos
CREATE TABLE plataforma (
    plataforma_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_plataforma VARCHAR(100) NOT NULL
);

-- Crear la tabla para la relación entre videojuegos y plataformas
CREATE TABLE videojuego_plataforma (
    videojuego_id INT,
    plataforma_id INT,
    PRIMARY KEY (videojuego_id, plataforma_id),
    FOREIGN KEY (videojuego_id) REFERENCES videojuego(videojuego_id),
    FOREIGN KEY (plataforma_id) REFERENCES plataforma(plataforma_id)
);

-- Crear la tabla de órdenes
CREATE TABLE orden (
    orden_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha_orden DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
);

-- Crear la tabla de líneas de orden (productos comprados)
CREATE TABLE linea_orden (
    linea_orden_id INT AUTO_INCREMENT PRIMARY KEY,
    orden_id INT,
    videojuego_id INT,
    cantidad INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (orden_id) REFERENCES orden(orden_id),
    FOREIGN KEY (videojuego_id) REFERENCES videojuego(videojuego_id)
);

-- Insertar categorías de videojuegos
INSERT INTO categoria (nombre_categoria) VALUES
('Acción'),
('Aventura'),
('Deportes'),
('RPG'),
('Estrategia');

-- Insertar clientes
INSERT INTO cliente (nombre_cliente, correo_cliente) VALUES
('Juan Pérez', 'juanperez@email.com'),
('Ana García', 'anagarcia@email.com'),
('Carlos Sánchez', 'carlossanchez@email.com');

-- Insertar plataformas de videojuegos
INSERT INTO plataforma (nombre_plataforma) VALUES
('PS5'),
('Xbox Series X'),
('PC'),
('Nintendo Switch');

-- Insertar videojuegos
INSERT INTO videojuego (nombre_videojuego, precio, fecha_lanzamiento, categoria_id) VALUES
('The Last of Us Parte II', 59.99, '2020-06-19', 1),
('Cyberpunk 2077', 49.99, '2020-12-10', 1),
('The Legend of Zelda: Breath of the Wild', 59.99, '2017-03-03', 2),
('FIFA 21', 59.99, '2020-10-09', 3),
('Final Fantasy VII Remake', 59.99, '2020-04-10', 4);

-- Relacionar videojuegos con plataformas
INSERT INTO videojuego_plataforma (videojuego_id, plataforma_id) VALUES
(1, 1), -- The Last of Us Parte II para PS5
(2, 1), -- Cyberpunk 2077 para PS5
(3, 4), -- Zelda: Breath of the Wild para Nintendo Switch
(4, 1), -- FIFA 21 para PS5
(5, 1), -- Final Fantasy VII Remake para PS5
(5, 3); -- Final Fantasy VII Remake para PC

-- Insertar una orden de un cliente
INSERT INTO orden (cliente_id) VALUES
(1);  -- Juan Pérez realizó una orden

-- Insertar líneas de orden para la orden de Juan Pérez
INSERT INTO linea_orden (orden_id, videojuego_id, cantidad, precio) VALUES
(1, 1, 1, 59.99),  -- Juan Pérez compró 1 The Last of Us Parte II
(1, 3, 1, 59.99);  -- Juan Pérez compró 1 Zelda: Breath of the Wild
