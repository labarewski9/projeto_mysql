  	---- 1.Lendo txt
	CREATE TABLE #TEMP(
	COMANDOS NVARCHAR(250)
	)

	BULK INSERT #TEMP

	FROM 'C:\Projeto_compras\ForeignKeys\txt_chaves.txt'

	WITH 

	  (
		 ROWTERMINATOR ='\n'
	  )

	---- 2. Desativar chaves estrangeiras
    DECLARE @comandos NVARCHAR(250)

    DECLARE desativarChaves CURSOR FOR 
    SELECT [COMANDOS] FROM #TEMP

    OPEN desativarChaves

    FETCH NEXT FROM desativarChaves INTO @comandos

    WHILE @@FETCH_STATUS = 0
    BEGIN
		EXEC(@comandos)
        FETCH NEXT FROM desativarChaves INTO @comandos
    END

    CLOSE desativarChaves
    DEALLOCATE desativarChaves

	-- 3. Criar tabela temporária #todasTabelas
    CREATE TABLE #todasTabelas (
        nome NVARCHAR(250)
    )

    INSERT INTO #todasTabelas (nome)
    SELECT name
    FROM sys.tables
    WHERE name != 'todasTabelas' AND name != 'chaves_estrangeiras'

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