use projeto_financeiro_compras;
DELIMITER //

CREATE PROCEDURE sp_add_fornecedores()
BEGIN
    -- Variável para indicar quando o cursor chegou ao final do conjunto de resultados
    DECLARE done INT DEFAULT 0;
    
    -- Variáveis para armazenar os dados do cursor
    DECLARE NOME VARCHAR(100);
    DECLARE CNPJ BIGINT;
    DECLARE EMAIL VARCHAR(100);
    DECLARE TELEFONE VARCHAR(20);

    -- Declaração do cursor para selecionar dados distintos do conjunto de resultados
    DECLARE insert_fornecedores CURSOR FOR
    SELECT DISTINCT
        NOME_FORNECEDOR,
        CNPJ_FORNECEDOR,
        EMAIL_FORNECEDOR,
        TELEFONE_FORNECEDOR
    FROM stage_compras.TRATAMENTO_COMPRAS_FINAL
    WHERE CNPJ_FORNECEDOR NOT IN (SELECT CNPJ_FORNECEDOR FROM projeto_financeiro_compras.FORNECEDORES);

    -- Manipulador para lidar com a condição NOT FOUND
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Início do loop
    OPEN insert_fornecedores;

    -- Loop através do cursor
    read_loop: LOOP
        -- Busca dados para as variáveis
        FETCH insert_fornecedores INTO NOME, CNPJ, EMAIL, TELEFONE;

        -- Verifica se não há mais linhas para buscar
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Inicia uma nova transação para cada inserção
        START TRANSACTION;

        -- Insere dados na tabela MySQL
        INSERT INTO projeto_financeiro_compras.FORNECEDORES
        (NOME_FORNECEDOR, CNPJ_FORNECEDOR, EMAIL_FORNECEDOR, TELEFONE_FORNECEDOR)
        VALUES
        (NOME, CNPJ, EMAIL, TELEFONE);

        -- Comita a transação
        COMMIT;
    END LOOP;

    -- Fecha o cursor
    CLOSE insert_fornecedores;
END //

DELIMITER ;


