	CREATE DATABASE infra_compras

	-- Criar tabela chaves_estrangeiras

    CREATE TABLE chaves_estrangeiras (
        ChaveEstrangeira NVARCHAR(250),
        IDChaveEstrangeira INT,
        TabelaReferenciada NVARCHAR(250),
        ColunaTabelaReferenciada NVARCHAR(250),
        TabelaOrigem NVARCHAR(250),
        ColunaTabelaOrigem NVARCHAR(250)
    )

    INSERT INTO chaves_estrangeiras (ChaveEstrangeira, IDChaveEstrangeira, TabelaReferenciada, ColunaTabelaReferenciada, TabelaOrigem, ColunaTabelaOrigem)
    SELECT
        fk.name,
        fk.object_id,
        t.name,
        c.name,
        t2.name,
        c2.name
    FROM projeto_financeiro_compras.sys.foreign_keys AS fk
    INNER JOIN projeto_financeiro_compras.sys.tables AS t ON t.object_id = fk.referenced_object_id 
    INNER JOIN projeto_financeiro_compras.sys.tables AS t2 ON t2.object_id = fk.parent_object_id
    INNER JOIN projeto_financeiro_compras.sys.foreign_key_columns AS fkc ON fkc.constraint_object_id = fk.object_id
    INNER JOIN projeto_financeiro_compras.sys.columns AS c ON c.column_id = fkc.referenced_column_id AND c.object_id = t.object_id
    INNER JOIN projeto_financeiro_compras.sys.columns AS c2 ON c2.column_id = fkc.parent_column_id AND c2.object_id = t2.object_id

		-- Criar tabela com todas as tabelas do projeto financeiro compras
    CREATE TABLE todasTabelas (
        nome NVARCHAR(250)
    )

    INSERT INTO todasTabelas (nome)
    SELECT name
    FROM projeto_financeiro_compras.sys.tables
    WHERE name != 'todasTabelas' AND name != 'chaves_estrangeiras'

	-- Tabelas para colocar os comandos sql
	CREATE TABLE TXT_chaves(
	ComandoSQL NVARCHAR(250)
	)
