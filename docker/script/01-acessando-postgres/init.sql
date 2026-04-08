-- Criar schema exemplo
CREATE SCHEMA IF NOT EXISTS demo;

-- Criar tabela de usuários
CREATE TABLE IF NOT EXISTS demo.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar tabela de produtos
CREATE TABLE IF NOT EXISTS demo.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar tabela de pedidos
CREATE TABLE IF NOT EXISTS demo.orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES demo.users(id),
    total DECIMAL(10, 2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir dados de exemplo
INSERT INTO demo.users (username, email) VALUES
    ('joao_silva', 'joao@email.com'),
    ('maria_santos', 'maria@email.com'),
    ('pedro_oliveira', 'pedro@email.com')
ON CONFLICT (username) DO NOTHING;

INSERT INTO demo.products (name, price, stock) VALUES
    ('Notebook', 2500.00, 10),
    ('Mouse', 50.00, 50),
    ('Teclado', 120.00, 30),
    ('Monitor', 800.00, 15)
ON CONFLICT DO NOTHING;

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_users_email ON demo.users(email);
CREATE INDEX IF NOT EXISTS idx_products_name ON demo.products(name);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON demo.orders(user_id);

-- Criar view para relatório de vendas
CREATE OR REPLACE VIEW demo.product_sales_report AS
SELECT 
    p.name AS product_name,
    p.price,
    p.stock,
    CASE 
        WHEN p.stock = 0 THEN 'Out of Stock'
        WHEN p.stock < 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM demo.products p;

-- Comentários nas tabelas
COMMENT ON TABLE demo.users IS 'Armazena informações dos usuários';
COMMENT ON TABLE demo.products IS 'Catálogo de produtos';
COMMENT ON TABLE demo.orders IS 'Registro de pedidos dos usuários';