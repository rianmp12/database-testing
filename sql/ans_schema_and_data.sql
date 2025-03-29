-- Criação a tabela operadoras_ativas
CREATE TABLE operadoras_ativas (
    registro_ans INTEGER PRIMARY KEY,
    cnpj VARCHAR(18),
    razao_social VARCHAR(255),
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100),
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    cep VARCHAR(9),
    ddd VARCHAR(3),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255),
    cargo_representante VARCHAR(100),
    regiao_de_comercializacao VARCHAR(255),
    data_registro_ans DATE
);


-- Cria tabela temp para correção de pontuação
CREATE TEMP TABLE demonstracoes_tmp (
    data TEXT,
    reg_ans TEXT,
    cd_conta_contabil TEXT,
    descricao TEXT,
    vl_saldo_inicial TEXT,
    vl_saldo_final TEXT
);


-- Cria a tabela demonstracoes_contabeis
CREATE TABLE demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    data DATE,
    reg_ans INTEGER,
    cd_conta_contabil VARCHAR(20),
    descricao TEXT,
    vl_saldo_inicial NUMERIC(18, 2),
    vl_saldo_final NUMERIC(18, 2),
    CONSTRAINT fk_operadora FOREIGN KEY (reg_ans)
        REFERENCES operadoras_ativas(registro_ans)
);

-- Importação dos dados de operadoras ativas

COPY operadoras_ativas(
    registro_ans, cnpj, razao_social, nome_fantasia, modalidade,
    logradouro, numero, complemento, bairro, cidade, uf, cep,
    ddd, telefone, fax, endereco_eletronico, representante,
    cargo_representante, regiao_de_comercializacao, data_registro_ans
)
FROM 'C:/Program Files/PostgreSQL/16/data/import/operadoras/Relatorio_cadop.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

-- Importação dos dados de demonstrações contábeis temp

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/1T2023.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/2T2023.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/3T2023.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/4T2023.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/1T2024.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/2T2024.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/3T2024.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

COPY demonstracoes_tmp
FROM 'C:/Program Files/PostgreSQL/16/data/import/demonst_contabeis/4T2024.csv'
WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');


-- Transforma a virgula em ponto para ser tratado como numeric e adicionado na tabela
INSERT INTO demonstracoes_contabeis (
    data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final
)
SELECT 
    CASE
        WHEN data LIKE '__/__/____' THEN TO_DATE(REPLACE(data, '/', '-'), 'DD-MM-YYYY')
        ELSE TO_DATE(data, 'YYYY-MM-DD')
    END,
    reg_ans::INTEGER,
    cd_conta_contabil,
    descricao,
    REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC,
    REPLACE(vl_saldo_final, ',', '.')::NUMERIC
FROM demonstracoes_tmp
WHERE reg_ans::INTEGER IN (SELECT registro_ans FROM operadoras_ativas);