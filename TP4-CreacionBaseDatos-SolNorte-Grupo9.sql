CREATE DATABASE SolNorteDB;
USE SolNorteDB;

/* Creación de ESQUEMAS */
CREATE SCHEMA Datos;
GO

CREATE SCHEMA Operaciones;
GO

CREATE SCHEMA Facturacion;
GO

CREATE TABLE Datos.Socio (
    DNI INT NOT NULL PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    ID_estado INT NOT NULL,
    ID_membresia INT,
    Email NVARCHAR(100),
    FechaNacimiento DATE NOT NULL,
    Domicilio NVARCHAR(200),
    ObraSocial NVARCHAR(100),
    NumObraSocial NVARCHAR(50),
    TelObraSocial VARCHAR(20),
	Descuento DECIMAL(5,2) DEFAULT 0,
    Activo BIT DEFAULT 1
);
GO

CREATE TABLE Datos.Estado (
	ID_estado INT NOT NULL PRIMARY KEY,
	Nombre VARCHAR(15),
	Descripcion VARCHAR(140)
);
GO

CREATE TABLE Datos.SocioTelefonos (
	DNI INT NOT NULL PRIMARY KEY,
	telefono INT,
	FOREIGN KEY (DNI) REFERENCES Datos.Socio(DNI)
);
GO

CREATE TABLE Datos.SocioEmergencia (
	DNI INT NOT NULL PRIMARY KEY,
	contacto INT,
	FOREIGN KEY (DNI) REFERENCES Datos.Socio(DNI)
);
GO

CREATE TABLE Datos.Parentesco (
    DNIresponsable INT PRIMARY KEY,
    DNImenor INT NOT NULL,
    FOREIGN KEY (DNIresponsable) REFERENCES Datos.Socio(DNI),
    FOREIGN KEY (DNImenor) REFERENCES Datos.Socio(DNI)
);
GO

CREATE TABLE Datos.Actividad (
    ID_Actividad INT PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Costo DECIMAL(10,2) NOT NULL,
    Dias NVARCHAR(200)
);
GO

CREATE TABLE Datos.Membresia (
    ID_Tipo INT PRIMARY KEY,
    Nombre NVARCHAR(100),
    Costo DECIMAL(10,2),
    Activo BIT DEFAULT 1
);
GO

--REHACER FACTURA

CREATE TABLE Datos.MedioDePago (
    IdTipoPago INT NOT NULL PRIMARY KEY,
    IdFuentePago INT NOT NULL PRIMARY KEY,
    Fuente NVARCHAR(50) NOT NULL,
    Activo BIT DEFAULT 1,
    CONSTRAINT PK_MedioDePago PRIMARY KEY (IdTipoPago, IdFuentePago)
);


CREATE TABLE Datos.Usuario (
    ID_rol INT NOT NULL,
    Usuario NVARCHAR(100) NOT NULL PRIMARY,
    Contrasenia NVARCHAR(100) NOT NULL PRIMARY,
    CaducidadContrasenia DATE,
    IDCuotasPagas INT,
    Saldo DECIMAL(10,2) DEFAULT 0,
);

CREATE TABLE Datos.UsuarioCuotasPagas (
    Usuario NVARCHAR(100) NOT NULL PRIMARY KEY,
    Contrasenia NVARCHAR(100) NOT NULL PRIMARY KEY,
	
	FOREIGN KEY (Usuario) REFERENCES Datos.Usuario(Usuario),
	FOREIGN KEY (Contrasenia) REFERENCES Datos.Usuario(Contrasenia)
);

CREATE TABLE Datos.Cobro (
    ID_Factura INT NOT NULL,
    CUIT CHAR(11) NOT NULL,
    FechaHora DATETIME NOT NULL,
    Costo DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (ID_Factura, CUIT, FechaHora),
    FOREIGN KEY (ID_Factura, CUIT, FechaHora) 
        REFERENCES Facturacion.Factura(ID_Factura, CUIT, FechaHora)
);

CREATE TABLE Datos.Reembolso (
    ID_Factura INT NOT NULL,
    CUIT CHAR(11) NOT NULL,
    FechaHora DATETIME NOT NULL,
    Costo DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (ID_Factura, CUIT, FechaHora),
    FOREIGN KEY (ID_Factura, CUIT, FechaHora) 
        REFERENCES Facturacion.Factura(ID_Factura, CUIT, FechaHora)
);


--REHACER OPERACIONES SOCIO


CREATE PROCEDURE Operaciones.InsertarActividad
    @ID_Actividad INT,
    @Nombre NVARCHAR(100),
    @Costo DECIMAL(10,2),
    @Dias NVARCHAR(100)
AS
BEGIN
    INSERT INTO Datos.Actividad (ID_Actividad, Nombre, Costo, Dias)
    VALUES (@ID_Actividad, @Nombre, @Costo, @Dias);
END;
GO

CREATE PROCEDURE Operaciones.ActualizarActividad
    @ID_Actividad INT,
    @Nombre NVARCHAR(100),
    @Costo DECIMAL(10,2),
    @Dias NVARCHAR(100)
AS
BEGIN
    UPDATE Datos.Actividad
    SET 
        Nombre = @Nombre,
        Costo = @Costo,
        Dias = @Dias
    WHERE ID_Actividad = @ID_Actividad;
END;
GO

CREATE PROCEDURE Operaciones.EliminarActividad
    @ID_Actividad INT
AS
BEGIN
    UPDATE Datos.Actividad
    SET Activo = 0
    WHERE ID_Actividad = @ID_Actividad;
END;
GO
CREATE PROCEDURE Operaciones.InsertarMembresia
    @ID_Tipo INT,
    @Nombre NVARCHAR(100),
    @Costo DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Datos.Membresia (ID_Tipo, Nombre, Costo)
    VALUES (@ID_Tipo, @Nombre, @Costo);
END;
GO

CREATE PROCEDURE Operaciones.ActualizarMembresia
    @ID_Tipo INT,
    @Nombre NVARCHAR(100),
    @Costo DECIMAL(10,2)
AS
BEGIN
    UPDATE Datos.Membresia
    SET 
        Nombre = @Nombre,
        Costo = @Costo
    WHERE ID_Tipo = @ID_Tipo;
END;
GO

CREATE PROCEDURE Operaciones.EliminarMembresia
    @ID_Tipo INT
AS
BEGIN
    UPDATE Datos.Membresia
    SET Activo = 0
    WHERE ID_Tipo = @ID_Tipo;
END;
GO


--REHACER OPERACIONS FACTURA

--REHACER OPETACIONES USUARIO

--REHACER OPERACIONES COBRO
