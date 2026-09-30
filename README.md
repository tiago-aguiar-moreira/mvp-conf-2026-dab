# Data API Builder — demo E-commerce

Projeto de demonstração da palestra **"Como expor dados para IA com Data API Builder e MCP"**
(MVP Conf 2026).

O [Data API Builder](https://github.com/Azure/data-api-builder) (DAB) lê o schema de um banco
SQL Server e expõe automaticamente endpoints **REST**, **GraphQL** e um **servidor MCP** — sem
escrever nenhum código de API. Aqui ele aponta para um banco fictício de e-commerce
(`clientes`, `produtos`, `pedidos`, `itenspedido`) para demonstrar:

- Tools MCP geradas automaticamente a partir das entidades do banco.
- Controle de acesso por **role** (`anonymous`, `cliente`, `admin`).
- Exclusão de campos sensíveis por role (`cpf`, `telefone` ocultos para `cliente`).
- Relacionamentos entre entidades navegáveis via GraphQL/MCP.

## Pré-requisitos

- Docker + Docker Compose
- [DAB CLI](https://learn.microsoft.com/azure/data-api-builder/get-started/get-started-with-data-api-builder) (`dotnet tool install -g Microsoft.DataApiBuilder`)
- Extensão [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) no VS Code (opcional, para `requests.http`)

## Rodar

```bash
cp .env.example .env      # ajuste a senha se quiser

# 1. Sobe o SQL Server
docker compose up -d

# 2. Cria o schema e popula os dados de exemplo
sqlcmd -S localhost,1433 -U sa -P "<senha do .env>" -i sql/01_criar_tabelas.sql
sqlcmd -S localhost,1433 -U sa -P "<senha do .env>" -i sql/02_popular_dados.sql

# 3. Sobe o DAB (lê dab-config.json e o .env na pasta atual)
dab start --config dab-config.json
```

O DAB sobe em `http://localhost:5000`. GraphQL fica desabilitado neste ambiente de demo
(`runtime.graphql.enabled = false`) — só REST e MCP.

## Testar

### REST / roles

Use `requests.http` (7 cenários: leitura pública, por role, exclusão de campos sensíveis e
casos de erro de autorização). Cada request define o header `X-MS-API-ROLE`, que o DAB usa para
aplicar as permissões definidas em `dab-config.json`.

### MCP

```bash
npx @modelcontextprotocol/inspector
# conectar em http://localhost:5000/mcp (Streamable HTTP)
```

Ou via Claude Code:

```bash
claude mcp add --transport http dab-demo http://localhost:5000/mcp
claude mcp list
```

Com o servidor MCP conectado, peça para o assistente responder as perguntas de
`queries-exemplo.sql` usando as tools do DAB em vez de SQL direto — é o mesmo dado, mas
navegado pelas entidades e relacionamentos expostos pelo `dab-config.json`.

## Estrutura

```
dab-config.json         # schema, roles/permissions, entidades REST+MCP
sql/
  01_criar_tabelas.sql  # schema (Clientes, Produtos, Pedidos, ItensPedido)
  02_popular_dados.sql  # massa de dados de exemplo
requests.http           # cenários de teste REST (roles, exclusão de campos, 403s)
queries-exemplo.sql     # perguntas de negócio para testar via MCP/assistente
```
