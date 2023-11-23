CREATE OR ALTER PROCEDURE desativar_fk_truncar_txt 
	@DatabaseName NVARCHAR(50)
AS
BEGIN
	BEGIN TRAN
		
		-- Lendo txt
		CREATE TABLE #TXT_comandos(
		COMANDOS NVARCHAR(250)
		)

		BULK INSERT #TXT_comandos

		FROM 'C:\Projeto_compras\ForeignKeys\txt_chaves.txt'

		WITH 

		  (
			 ROWTERMINATOR ='\n'
		  )
		
		-- Desativar chaves estrangeiras
		DECLARE @comandos NVARCHAR(250)

		DECLARE desativarChaves CURSOR FOR 
		SELECT [COMANDOS] FROM #TXT_comandos

		OPEN desativarChaves

		FETCH NEXT FROM desativarChaves INTO @comandos

		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC(@comandos)
			FETCH NEXT FROM desativarChaves INTO @comandos
		END

		CLOSE desativarChaves
		DEALLOCATE desativarChaves

		-- Truncar as tabelas
		DECLARE @SQL1 NVARCHAR(MAX)
		DECLARE @nomeTabela NVARCHAR(250)

		SET @SQL1 = 'DECLARE trucateTables CURSOR FOR 
					SELECT [nome] FROM ' + QUOTENAME(@DatabaseName) + '.dbo.todasTabelas'

		EXEC(@SQL1)

		OPEN trucateTables
		FETCH NEXT FROM trucateTables INTO @nomeTabela

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @sqlTruncate NVARCHAR(MAX)
			SET @sqlTruncate = 'TRUNCATE TABLE ' + @nomeTabela
			EXEC  (@sqlTruncate)

			FETCH NEXT FROM trucateTables INTO @nomeTabela
		END

		CLOSE trucateTables
		DEALLOCATE trucateTables
	
	COMMIT
END;