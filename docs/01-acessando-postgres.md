# Acessando o PostgreSQL - Tutorial Completo

## 📋 Overview

Este tutorial fornece um guia prático para acessar e gerenciar um banco de dados PostgreSQL usando Docker. Você aprenderá:

- Como iniciar um ambiente PostgreSQL com Docker Compose
- Métodos de conexão ao banco de dados (CLI, GUI)
- Comandos básicos de administração
- Boas práticas de segurança e gerenciamento

## 🚀 Quick Start

### Pré-requisitos

- [Docker](https://docs.docker.com/desktop/setup/install/linux/) e [Docker Compose](https://docs.docker.com/compose/install/) instalados
- Pelo menos 2GB de RAM livre
- Conhecimento básico de linha de comando

### Iniciar o Ambiente

```bash
# Navegue até o diretório do projeto
cd /caminho/para/seu/projeto

# Inicie os containers
docker-compose -f docker/01-acessando-postgres.yaml up -d
```

### Verificar se está funcionando

```bash
# Verificar status dos containers
docker-compose -f docker/01-acessando-postgres.yaml ps

# Ver logs do PostgreSQL
docker-compose -f docker/01-acessando-postgres.yaml logs postgres
```

## 🔌 Métodos de Conexão

### 1. Acesso via Linha de Comando (CLI)

```bash
# Conectar ao PostgreSQL via psql
docker exec -it postgres_demo psql -U demo_user -d demo_db

# Dentro do psql, você pode executar:
demo_db=> \l                    # Listar todos os bancos
demo_db=> \dt demo.*            # Listar tabelas no schema demo
demo_db=> \d demo.users         # Mostrar estrutura da tabela
demo_db=> SELECT * FROM demo.users;  # Consultar dados
demo_db=> \q                    # Sair
```

### 2. Acesso via pgAdmin (Interface Web)

1. Abra o navegador e acesse: `http://localhost:8080`
2. Login com as credenciais:
   - Email: `admin@demo.com`
   - Senha: `admin_password`
3. Adicione um novo servidor:
   - Nome: `PostgreSQL Demo`
   - Host: `postgres`
   - Port: `5432`
   - Database: `demo_db`
   - Username: `demo_user`
   - Password: `demo_password`

## 📊 Comandos Essenciais do psql

### Conexão e Informações Básicas

```sql
-- Conectar ao banco
\c demo_db

-- Listar todos os bancos de dados
\l

-- Listar todas as tabelas
\dt

-- Listar tabelas de um schema específico
\dt demo.*

-- Mostrar estrutura de uma tabela
\d demo.users
```

### Gerenciamento de Banco

```sql
-- Criar novo banco de dados
CREATE DATABASE novo_banco;

-- Criar novo usuário
CREATE USER novo_user WITH PASSWORD 'senha123';

-- Dar privilégios
GRANT ALL PRIVILEGES ON DATABASE demo_db TO novo_user;

-- Conectar como outro usuário
\c demo_db novo_user
```

### Consultas SQL Básicas

```sql
-- Selecionar todos os usuários
SELECT * FROM demo.users;

-- Inserir novo usuário
INSERT INTO demo.users (username, email) 
VALUES ('ana_costa', 'ana@email.com');

-- Atualizar dados
UPDATE demo.users 
SET email = 'novoemail@email.com' 
WHERE username = 'joao_silva';

-- Deletar registro
DELETE FROM demo.users 
WHERE username = 'pedro_oliveira';

-- Consulta com junção
SELECT u.username, p.name, o.total
FROM demo.users u
JOIN demo.orders o ON u.id = o.user_id
JOIN demo.products p ON p.id = o.id;
```

## 🛠️ Troubleshooting

### Problemas Comuns e Soluções

**1. Porta 5432 já em uso**
```bash
# Verificar processo usando a porta
sudo lsof -i :5432

# Parar serviço PostgreSQL local (Linux)
sudo systemctl stop postgresql

# Ou alterar a porta no docker-compose.yaml
ports:
  - "5433:5432"  # Mude para 5433
```

**2. Erro de permissão**
```bash
# Verificar logs do container
docker logs postgres_demo

# Reiniciar o container
docker-compose -f docker/01-acessando-postgres.yaml restart postgres
```

**3. Container não inicia**
```bash
# Verificar se há containers conflitantes
docker ps -a | grep postgres

# Remover containers antigos
docker-compose -f docker/01-acessando-postgres.yaml down -v

# Tentar novamente
docker-compose -f docker/01-acessando-postgres.yaml up -d
```

## 📈 Performance e Monitoramento

### Comandos de Monitoramento

```sql
-- Ver conexões ativas
SELECT pid, usename, application_name, client_addr, state 
FROM pg_stat_activity;

-- Ver tamanho do banco
SELECT pg_database_size('demo_db')/1024/1024 AS size_mb;

-- Ver tabelas mais acessadas
SELECT schemaname, tablename, seq_scan, seq_tup_read
FROM pg_stat_user_tables
ORDER BY seq_scan DESC
LIMIT 5;
```

### Backup e Restauração

```bash
# Backup do banco
docker exec postgres_demo pg_dump -U demo_user demo_db > backup.sql

# Restaurar backup
cat backup.sql | docker exec -i postgres_demo psql -U demo_user demo_db

# Backup compactado
docker exec postgres_demo pg_dump -U demo_user demo_db | gzip > backup.sql.gz
```

## 🧹 Limpeza e Parada

### Parar o ambiente

```bash
# Parar containers sem remover volumes
docker-compose -f docker/01-acessando-postgres.yaml stop

# Parar e remover containers (dados persistem)
docker-compose -f docker/01-acessando-postgres.yaml down

# Parar e remover TUDO (incluindo dados)
docker-compose -f docker/01-acessando-postgres.yaml down -v
```

### Remover completamente

```bash
# Remover containers, volumes e imagens não utilizados
docker system prune -a --volumes
```

## ✅ Verificação Final

Execute estas verificações para confirmar que tudo está funcionando:

```bash
# 1. Verificar se os containers estão rodando
docker-compose -f docker/01-acessando-postgres.yaml ps

# 2. Testar conexão via psql
docker exec -it postgres_demo psql -U demo_user -d demo_db -c "SELECT 'Conexão OK' as status;"

# 3. Verificar dados de exemplo
docker exec -it postgres_demo psql -U demo_user -d demo_db -c "SELECT COUNT(*) FROM demo.users;"

# 4. Acessar pgAdmin no navegador
# Abra http://localhost:8080
```

## 📚 Próximos Passos

Após dominar o acesso básico, prossiga para:

- [Álgebra Relacional em SQL](./01-relational-algebra.md)
- [Modelagem Entidade-Relacionamento](./02-entity-relationship-modelling.md)
- [Tutorial Avançado de SQL](./03-sql-tutorial.md)

## 🔗 Recursos Úteis

- [Documentação Oficial do PostgreSQL](https://www.postgresql.org/docs/)
- [pgAdmin Documentation](https://www.pgadmin.org/docs/)
- [Docker PostgreSQL Hub](https://hub.docker.com/_/postgres)

---

**Dica:** Mantenha este tutorial aberto enquanto explora os comandos. Pratique cada seção antes de prosseguir!
```

---

## 🚀 Como usar este tutorial:

1. **Crie a estrutura de diretórios:**
```bash
mkdir -p projeto/{docker,docs,scripts}
```

2. **Copie os arquivos** para seus respectivos diretórios

3. **Execute o ambiente:**
```bash
cd projeto
docker-compose -f docker/01-acessando-postgres.yaml up -d
```

4. **Acesse o PostgreSQL:**
```bash
docker exec -it postgres_demo psql -U demo_user -d demo_db
```

5. **Quando terminar, limpe:**
```bash
docker-compose -f docker/01-acessando-postgres.yaml down -v
```

O tutorial está completo e pronto para uso! Ele inclui exemplos práticos, comandos úteis e cenários de troubleshooting.