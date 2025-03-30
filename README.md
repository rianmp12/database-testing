# Teste de Banco de Dados

Este repositório contém a resolução do **Teste de Banco de Dados** proposto, utilizando **PostgreSQL**.

---

## 🗂️ Estrutura do Repositório

- `sql/ans_schema_and_data.sql`: Criação das tabelas e importação dos dados.
- `sql/analytic_query`: Queries analíticas.
- `requirements.txt` (opcional): bibliotecas com versões fixas.

## ✅ Requisitos Atendidos

### Preparação de Dados (Script Adicional)

- **3.1** Download dos arquivos dos últimos 2 anos do repositório público:
  - `https://dadosabertos.ans.gov.br/FTP/PDA/demonstracoes_contabeis/`

- **3.2** Download do arquivo CSV com **dados cadastrais das operadoras ativas**:
  - `https://dadosabertos.ans.gov.br/FTP/PDA/operadoras_de_plano_de_saude_ativas/`

> 💡 Embora o teste não exigisse, foi implementado um script Python que automatiza o download e a extração dos arquivos `.zip`.

---

### 🧱 Criação de Tabelas (`ans_schema_and_data.sql`)

- **3.3** Criação das tabelas `operadoras_ativas` e `demonstracoes_contabeis`, com relação entre elas garantida por chave estrangeira.
- Utilização de uma tabela temporária `demonstracoes_tmp` para tratar valores numéricos e datas inconsistentes, convertendo:
  - Vírgulas para ponto decimal (`REPLACE`)
  - Datas nos formatos `DD/MM/YYYY` e `YYYY-MM-DD` para tipo `DATE`

---

### 📥 Importação dos Dados

- **3.4** Uso do comando `COPY` com encoding `UTF8` para garantir compatibilidade com acentos e caracteres especiais.
- Inserção final na tabela `demonstracoes_contabeis` com tratamento dos dados da tabela temporária.

---

### 📊 Análises Analíticas (`analytic_query.sql`)

- **3.5** Duas queries analíticas foram desenvolvidas:

1. **Top 10 operadoras com maiores despesas em sinistros médico-hospitalares (último trimestre)**
2. **Top 10 operadoras com maiores despesas em sinistros médico-hospitalares (último ano)**

---

## 🧠 Tecnologias Utilizadas

- PostgreSQL 16
- SQL (PostgreSQL)
- Python 3.12 (opcional)
- Bibliotecas Python: `requests`, `BeautifulSoup`, `os`, `zipfile`

---

## 📌 Observações

- As tabelas e dados devem ser inseridos em um banco de dados PostgreSQL criado previamente (ex: `ans_dados`).
- O usuário do PostgreSQL precisa ter permissões para executar comandos `COPY` diretamente a partir da pasta `data/import`. (Import foi uma pasta criada para adicionar os arquivos .csv e melhor organização)
- A importação foi feita **sem duplicidade**, com chave primária e integridade entre operadoras e seus demonstrativos.
