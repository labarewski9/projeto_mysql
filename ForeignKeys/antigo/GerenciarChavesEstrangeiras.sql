CREATE OR ALTER PROCEDURE GerenciarChavesEstrangeiras
AS
BEGIN

    -- 1. Criar tabela temporária #chaves_estrangeiras
    CREATE TABLE #chaves_estrangeiras (
        ChaveEstrangeira NVARCHAR(250),
        IDChaveEstrangeira INT,
        TabelaReferenciada NVARCHAR(250),
        ColunaTabelaReferenciada NVARCHAR(250),
        TabelaOrigem NVARCHAR(250),
        ColunaTabelaOrigem NVARCHAR(250)
    )

    INSERT INTO #chaves_estrangeiras (ChaveEstrangeira, IDChaveEstrangeira, TabelaReferenciada, ColunaTabelaReferenciada, TabelaOrigem, ColunaTabelaOrigem)
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

	-- 2. Criar tabela temporária #todasTabelas
    CREATE TABLE #todasTabelas (
        nome NVARCHAR(250)
    )

    INSERT INTO #todasTabelas (nome)
    SELECT name
    FROM sys.tables
    WHERE name != 'todasTabelas' AND name != 'chaves_estrangeiras'

    -- 3. Desativar chaves estrangeiras
    DECLARE @chaveEstrangeira NVARCHAR(250)
    DECLARE @tabelaOrigem NVARCHAR(250)

    DECLARE desativarChaves CURSOR FOR 
    SELECT [ChaveEstrangeira], [TabelaOrigem] FROM #chaves_estrangeiras

    OPEN desativarChaves

    FETCH NEXT FROM desativarChaves INTO @chaveEstrangeira, @tabelaOrigem

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @sqlDrop NVARCHAR(250)
        SET @sqlDrop = 'ALTER TABLE ' + @tabelaOrigem + ' DROP CONSTRAINT ' + @chaveEstrangeira;
        EXEC (@sqlDrop)

        FETCH NEXT FROM desativarChaves INTO @chaveEstrangeira, @tabelaOrigem
    END

    CLOSE desativarChaves
    DEALLOCATE desativarChaves

    -- 4. Truncar as tabelas

    DECLARE @nomeTabela NVARCHAR(250)

    DECLARE trucateTables CURSOR FOR 
    SELECT nome FROM #todasTabelas

    OPEN trucateTables

    FETCH NEXT FROM trucateTables INTO @nomeTabela

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @sqlTruncate NVARCHAR(250)
        SET @sqlTruncate = 'TRUNCATE TABLE ' + @nomeTabela
        EXEC  (@sqlTruncate)

        FETCH NEXT FROM trucateTables INTO @nomeTabela
    END

    CLOSE trucateTables
    DEALLOCATE trucateTables

    -- 5. Recriar chaves estrangeiras
    DECLARE @chaveEstrangeiraRecriar NVARCHAR(250)
    DECLARE @tabelaOrigemRecriar NVARCHAR(250)
    DECLARE @ColunaOrigemRecriar NVARCHAR(250)
    DECLARE @tabelaReferenciaRecriar NVARCHAR(250)
    DECLARE @ColunaReferenciaRecriar NVARCHAR(250)

    DECLARE ativarChaves CURSOR FOR
    SELECT [ChaveEstrangeira], [TabelaOrigem], [ColunaTabelaOrigem], [TabelaReferenciada], [ColunaTabelaReferenciada] FROM #chaves_estrangeiras

	OPEN ativarChaves

    FETCH NEXT FROM ativarChaves INTO @chaveEstrangeiraRecriar, @tabelaOrigemRecriar, @ColunaOrigemRecriar, @tabelaReferenciaRecriar, @ColunaReferenciaRecriar

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @sqlAtivar NVARCHAR(MAX)
        SET @sqlAtivar = 'ALTER TABLE ' + @tabelaOrigemRecriar + ' ADD CONSTRAINT ' + @chaveEstrangeiraRecriar + ' FOREIGN KEY (' + @ColunaOrigemRecriar + ') REFERENCES ' + @tabelaReferenciaRecriar + ' (' + @ColunaReferenciaRecriar + ')'
        EXEC (@sqlAtivar)
        

        FETCH NEXT FROM ativarChaves INTO @chaveEstrangeiraRecriar, @tabelaOrigemRecriar, @ColunaOrigemRecriar, @tabelaReferenciaRecriar, @ColunaReferenciaRecriar
    END

    CLOSE ativarChaves
    DEALLOCATE ativarChaves



END
