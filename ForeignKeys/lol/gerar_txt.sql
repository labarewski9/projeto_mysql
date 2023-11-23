  -- 1. Criar tabela chaves_estrangeiras
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
    FROM sys.foreign_keys AS fk
    INNER JOIN sys.tables AS t ON t.object_id = fk.referenced_object_id 
    INNER JOIN sys.tables AS t2 ON t2.object_id = fk.parent_object_id
    INNER JOIN sys.foreign_key_columns AS fkc ON fkc.constraint_object_id = fk.object_id
    INNER JOIN sys.columns AS c ON c.column_id = fkc.referenced_column_id AND c.object_id = t.object_id
    INNER JOIN sys.columns AS c2 ON c2.column_id = fkc.parent_column_id AND c2.object_id = t2.object_id

	--Tabelas para colocar os comandos sql
	CREATE TABLE TXT_chaves(
	ComandoSQL NVARCHAR(250)
	)
	
	-- 2. Gerar txt
    DECLARE @chaveEstrangeira NVARCHAR(250)
    DECLARE @tabelaOrigem NVARCHAR(250)

    DECLARE GerarTXT CURSOR FOR 
    SELECT [ChaveEstrangeira], [TabelaOrigem] FROM chaves_estrangeiras

    OPEN GerarTXT

    FETCH NEXT FROM GerarTXT INTO @chaveEstrangeira, @tabelaOrigem

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @sqlDrop NVARCHAR(250)
        SET @sqlDrop = 'ALTER TABLE ' + @tabelaOrigem + ' DROP CONSTRAINT ' + @chaveEstrangeira;
        INSERT INTO TXT_chaves(ComandoSQL) VALUES(@sqlDrop)

        FETCH NEXT FROM GerarTXT INTO @chaveEstrangeira, @tabelaOrigem
    END

    CLOSE GerarTXT
    DEALLOCATE GerarTXT