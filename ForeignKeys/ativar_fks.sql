CREATE OR ALTER PROCEDURE ativar_fk 
	@DatabaseName NVARCHAR(50)
AS
BEGIN
	BEGIN TRAN
		-- Recriar chaves estrangeiras
		DECLARE @SQL1 NVARCHAR(MAX)
		DECLARE @chaveEstrangeiraRecriar NVARCHAR(250)
		DECLARE @tabelaOrigemRecriar NVARCHAR(250)
		DECLARE @ColunaOrigemRecriar NVARCHAR(250)
		DECLARE @tabelaReferenciaRecriar NVARCHAR(250)
		DECLARE @ColunaReferenciaRecriar NVARCHAR(250)

		SET @SQL1 = 'DECLARE ativarChaves CURSOR FOR
					SELECT [ChaveEstrangeira], [TabelaOrigem], [ColunaTabelaOrigem], [TabelaReferenciada], [ColunaTabelaReferenciada] FROM ' + QUOTENAME(@DatabaseName) + '.dbo.chaves_estrangeiras'

		EXEC(@SQL1)

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

	COMMIT;
END;