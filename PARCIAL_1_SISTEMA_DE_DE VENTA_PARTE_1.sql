CREATE DATABASE IF NOT EXISTS SISTEMA_DE_VENTA;
USE SISTEMA_DE_VENTA;

-- Tabla: PROVINCIAS
CREATE TABLE PROVINCIAS (
    codpro INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    region ENUM('Norte', 'Sur', 'Este', 'Oeste', 'Centro') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    codigo_postal VARCHAR(10) NOT NULL
);

INSERT INTO PROVINCIAS VALUES
(1, 'Provincia Norte', 'Norte', TRUE, '10000'),
(2, 'Provincia Sur', 'Sur', TRUE, '20000'),
(3, 'Provincia Este', 'Este', TRUE, '30000'),
(4, 'Provincia Oeste', 'Oeste', TRUE, '40000'),
(5, 'Provincia Centro', 'Centro', FALSE, '50000');

-- Tabla: PUEBLOS
CREATE TABLE PUEBLOS (
    codpue INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    codpro INT,
    zona ENUM('Urbana', 'Rural') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    UNIQUE(nombre, codpro),
    FOREIGN KEY (codpro) REFERENCES PROVINCIAS(codpro)
);

INSERT INTO PUEBLOS VALUES
(1, 'Pueblo A', 1, 'Urbana', TRUE),
(2, 'Pueblo B', 2, 'Rural', TRUE),
(3, 'Pueblo C', 3, 'Urbana', FALSE),
(4, 'Pueblo D', 4, 'Rural', TRUE),
(5, 'Pueblo E', 5, 'Urbana', TRUE);

-- Tabla: CLIENTES
CREATE TABLE CLIENTES (
    codcli INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    codpostal VARCHAR(10),
    codpue INT,
    tipo_cliente ENUM('Regular', 'Premium', 'VIP') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    UNIQUE(nombre, direccion),
    FOREIGN KEY (codpue) REFERENCES PUEBLOS(codpue)
);

INSERT INTO CLIENTES VALUES
(1, 'Cliente Uno', 'Calle 1', '1001', 1, 'Regular', TRUE),
(2, 'Cliente Dos', 'Calle 2', '1002', 2, 'Premium', TRUE),
(3, 'Cliente Tres', 'Calle 3', '1003', 3, 'VIP', TRUE),
(4, 'Cliente Cuatro', 'Calle 4', '1004', 4, 'Regular', FALSE),
(5, 'Cliente Cinco', 'Calle 5', '1005', 5, 'Premium', TRUE);

-- Tabla: VENDEDORES
CREATE TABLE VENDEDORES (
    codven INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    codpostal VARCHAR(10),
    codpue INT,
    codjefe INT NULL,
    nivel ENUM('Junior', 'Senior', 'Gerente') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    UNIQUE(nombre, direccion),
    FOREIGN KEY (codpue) REFERENCES PUEBLOS(codpue),
    FOREIGN KEY (codjefe) REFERENCES VENDEDORES(codven)
);

INSERT INTO VENDEDORES VALUES
(1, 'Vendedor Uno', 'Av 1', '2001', 1, NULL, 'Gerente', TRUE),
(2, 'Vendedor Dos', 'Av 2', '2002', 2, 1, 'Senior', TRUE),
(3, 'Vendedor Tres', 'Av 3', '2003', 3, 1, 'Junior', TRUE),
(4, 'Vendedor Cuatro', 'Av 4', '2004', 4, 2, 'Senior', FALSE),
(5, 'Vendedor Cinco', 'Av 5', '2005', 5, 2, 'Junior', TRUE);

-- Tabla: ARTICULOS
CREATE TABLE ARTICULOS (
    codart INT PRIMARY KEY,
    descrip VARCHAR(100) NOT NULL UNIQUE,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    stock_min INT NOT NULL,
    dto DECIMAL(5,2) DEFAULT 0,
    tipo ENUM('Electrónica', 'Ropa', 'Hogar', 'Alimentos') NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

INSERT INTO ARTICULOS VALUES
(1, 'Artículo A', 50.00, 100, 10, 5.00, 'Electrónica', TRUE),
(2, 'Artículo B', 20.00, 200, 15, 2.00, 'Ropa', TRUE),
(3, 'Artículo C', 100.00, 50, 5, 10.00, 'Hogar', TRUE),
(4, 'Artículo D', 10.00, 500, 25, 0.00, 'Alimentos', TRUE),
(5, 'Artículo E', 75.00, 80, 10, 7.50, 'Electrónica', FALSE);

-- Tabla: FACTURAS
CREATE TABLE FACTURAS (
    codfac INT PRIMARY KEY,
    fecha DATE NOT NULL,
    codeli INT NOT NULL,
    codven INT NOT NULL,
    iva DECIMAL(5,2) NOT NULL,
    dto DECIMAL(5,2) NOT NULL,
    tipo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia') NOT NULL,
    pagada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (codeli) REFERENCES CLIENTES(codcli),
    FOREIGN KEY (codven) REFERENCES VENDEDORES(codven)
);

INSERT INTO FACTURAS VALUES
(1, '2024-02-01', 1, 1, 15.00, 5.00, 'Efectivo', TRUE),
(2, '2024-02-02', 2, 2, 12.00, 2.00, 'Tarjeta', FALSE),
(3, '2024-02-03', 3, 3, 18.00, 3.00, 'Transferencia', TRUE),
(4, '2024-02-04', 4, 4, 10.00, 0.00, 'Efectivo', FALSE),
(5, '2024-02-05', 5, 5, 20.00, 7.00, 'Tarjeta', TRUE);

-- Tabla: LINEAS_FAC
CREATE TABLE LINEAS_FAC (
    codfac INT,
    linea INT,
    cant INT NOT NULL,
    codart INT,
    dto DECIMAL(5,2) DEFAULT 0,
    precio DECIMAL(10,2) NOT NULL,
    estado ENUM('Pendiente', 'Entregado', 'Cancelado') NOT NULL,
    urgente BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (codfac, linea),
    FOREIGN KEY (codfac) REFERENCES FACTURAS(codfac),
    FOREIGN KEY (codart) REFERENCES ARTICULOS(codart)
);

INSERT INTO LINEAS_FAC VALUES
(1, 1, 2, 1, 5.00, 50.00, 'Entregado', FALSE),
(1, 2, 1, 2, 0.00, 20.00, 'Entregado', TRUE),
(2, 1, 3, 3, 10.00, 100.00, 'Pendiente', FALSE),
(3, 1, 5, 4, 0.00, 10.00, 'Entregado', TRUE),
(4, 1, 1, 5, 7.50, 75.00, 'Cancelado', FALSE);

-- Mostrar estructura de cada tabla
DESCRIBE PROVINCIAS;
DESCRIBE PUEBLOS;
DESCRIBE CLIENTES;
DESCRIBE VENDEDORES;
DESCRIBE ARTICULOS;
DESCRIBE FACTURAS;
DESCRIBE LINEAS_FAC;

