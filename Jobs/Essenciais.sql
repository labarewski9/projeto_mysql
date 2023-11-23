USE [msdb]
GO

/****** Object:  Job [Essenciais]    Script Date: 19/09/2023 10:07:23 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 19/09/2023 10:07:23 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Essenciais', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-U8N4LEO\Diego', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [cep_no_stage]    Script Date: 19/09/2023 10:07:23 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'cep_no_stage', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BULK INSERT stage_compras.dbo.CEP
FROM ''C:\Projeto_compras\Inputs\Csv\TB_CEP_BR_2018.csv''
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = '';'', 
    ROWTERMINATOR = ''\n'',
    CODEPAGE = 65001
);', 
		@database_name=N'stage_compras', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [cep_projeto_financeiro]    Script Date: 19/09/2023 10:07:23 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'cep_projeto_financeiro', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert into projeto_financeiro_compras.dbo.CEP 
(CEP, UF,CIDADE,BAIRRO,LOGRADOURO)
select 
CEP,
SUBSTRING(UF_ENDERECO,1,2),
ISNULL(CIDADE_ENDERECO,''N/D''),
ISNULL(BAIRRO_ENDERECO,''N/D''),
ISNULL(NOME_ENDERECO,''N/D'')
from stage_compras.dbo.CEP', 
		@database_name=N'projeto_financeiro_compras', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [tipo_endereco]    Script Date: 19/09/2023 10:07:23 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'tipo_endereco', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'C:\Projeto_compras\Inputs\Bats\tipo_endereco.bat', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [condicao_pagamento]    Script Date: 19/09/2023 10:07:23 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'condicao_pagamento', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'insert INTO PROJETO_FINANCEIRO_COMPRAS.DBO.CONDICAO_PAGAMENTO (DESCRICAO,QTD_PARCELAS, ENTRADA)
VALUES
	(''A vista'', 1,1),
	(''30 dias'',1,0),
	(''30/60 dias'',2,0),
	(''30/60/90 dias'',3,0),
	(''Entrada/30 dias'',2,1),
	(''Entrada/30/60 dias'',3,1),
	(''Entrada/30/60/90 dias'',4,1);', 
		@database_name=N'projeto_financeiro_compras', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


