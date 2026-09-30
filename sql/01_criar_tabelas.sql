-- ============================================================
-- Demo Data API Builder — E-commerce
-- Script 1/2: criação de tabelas e relacionamentos
-- Banco: SQL Server (container Docker "dab-demo-sql")
-- ============================================================

IF DB_ID('DabDemoEcommerce') IS NULL
BEGIN
    CREATE DATABASE DabDemoEcommerce;
END
GO

USE DabDemoEcommerce;
GO

-- ------------------------------------------------------------
-- Clientes — entidade "usuário": aqui mora a demo de dado sensível
-- (cpf e telefone ficam de fora para a role comum via fields.exclude)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.Clientes', 'U') IS NOT NULL DROP TABLE dbo.Clientes;
GO
CREATE TABLE dbo.Clientes (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    nome          NVARCHAR(120)   NOT NULL,
    email         NVARCHAR(160)   NOT NULL UNIQUE,
    telefone      VARCHAR(20)     NULL,
    cpf           CHAR(11)        NOT NULL UNIQUE,
    endereco      NVARCHAR(200)   NULL,
    criado_em     DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- ------------------------------------------------------------
-- Produtos — entidade aberta, sem policy (contraste com Clientes/Pedidos)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.Produtos', 'U') IS NOT NULL DROP TABLE dbo.Produtos;
GO
CREATE TABLE dbo.Produtos (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    nome          NVARCHAR(150)   NOT NULL,
    categoria     NVARCHAR(80)    NOT NULL,
    preco         DECIMAL(10,2)   NOT NULL,
    estoque       INT             NOT NULL DEFAULT 0
);
GO

-- ------------------------------------------------------------
-- Pedidos — aqui mora a demo de item-level policy
-- (@item.cliente_id eq @claims.sub)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.Pedidos', 'U') IS NOT NULL DROP TABLE dbo.Pedidos;
GO
CREATE TABLE dbo.Pedidos (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id    INT             NOT NULL,
    data_pedido   DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    status        NVARCHAR(30)    NOT NULL DEFAULT 'em_aberto',
    valor_total   DECIMAL(10,2)   NOT NULL DEFAULT 0,
    CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (cliente_id)
        REFERENCES dbo.Clientes(id)
);
GO

-- ------------------------------------------------------------
-- ItensPedido — relação Pedidos <-> Produtos (demo de navegação GraphQL)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.ItensPedido', 'U') IS NOT NULL DROP TABLE dbo.ItensPedido;
GO
CREATE TABLE dbo.ItensPedido (
    id                INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id         INT             NOT NULL,
    produto_id        INT             NOT NULL,
    quantidade        INT             NOT NULL DEFAULT 1,
    preco_unitario    DECIMAL(10,2)   NOT NULL,
    CONSTRAINT FK_ItensPedido_Pedidos FOREIGN KEY (pedido_id)
        REFERENCES dbo.Pedidos(id),
    CONSTRAINT FK_ItensPedido_Produtos FOREIGN KEY (produto_id)
        REFERENCES dbo.Produtos(id)
);
GO

PRINT 'Tabelas criadas com sucesso.';
GO
