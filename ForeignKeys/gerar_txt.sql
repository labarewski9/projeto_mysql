CREATE OR ALTER PROCEDURE gerar_txt
	@DatabaseName NVARCHAR(50)
AS
BEGIN
        BEGIN TRAN
        -- Gerar txt
        DECLARE @SQL1 NVARCHAR(MAX)
        DECLARE @chaveEstrangeira NVARCHAR(250)
        DECLARE @tabelaOrigem NVARCHAR(250)

		CREATE TABLE #tempTXT(comandos NVARCHAR(MAX))

        SET @SQL1 = 'DECLARE GerarTXT CURSOR FOR 
                    SELECT [ChaveEstrangeira], [TabelaOrigem] FROM ' + QUOTENAME(@DatabaseName) + '.dbo.chaves_estrangeiras'

        EXEC(@SQL1)

        OPEN GerarTXT
        FETCH NEXT FROM GerarTXT INTO @chaveEstrangeira, @tabelaOrigem

        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @sqlDrop NVARCHAR(MAX)

            SET @sqlDrop = 'ALTER TABLE ' + @tabelaOrigem + ' DROP CONSTRAINT ' + @chaveEstrangeira
			INSERT INTO #tempTXT VALUES(@sqlDrop)

            FETCH NEXT FROM GerarTXT INTO @chaveEstrangeira, @tabelaOrigem
        END

        CLOSE GerarTXT
        DEALLOCATE GerarTXT

		DECLARE @SQL2 NVARCHAR(MAX)
		DECLARE @SQL3 NVARCHAR(MAX)

		SET @SQL2 = 'TRUNCATE TABLE ' + QUOTENAME(@DatabaseName) + '.dbo.TXT_chaves'
		SET @SQL3 = 'INSERT INTO  ' + QUOTENAME(@DatabaseName) + '.dbo.TXT_chaves 
		SELECT comandos FROM #tempTXT'

		EXEC(@SQL2)
		EXEC(@SQL3)
        
		COMMIT
END;
