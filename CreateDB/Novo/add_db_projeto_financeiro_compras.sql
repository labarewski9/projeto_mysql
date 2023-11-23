/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     26/10/2023 10:59:18                          */
/*==============================================================*/

use projeto_financeiro_compras;




/*==============================================================*/
/* Table: CEP                                                   */
/*==============================================================*/
create table CEP
(
   CEP                  varchar(20) not null  comment '',
   UF                   varchar(5) not null  comment '',
   CIDADE               varchar(150) not null  comment '',
   BAIRRO               varchar(150) not null  comment '',
   LOGRADOURO           varchar(150) not null  comment '',
   primary key (CEP)
);

/*==============================================================*/
/* Table: CLIENTES                                              */
/*==============================================================*/
create table CLIENTES
(
   ID_CLIENTE           int not null  comment '',
   NOME                 varchar(100) not null  comment '',
   CNPJ                 bigint not null  comment '',
   EMAIL                varchar(100) not null  comment '',
   TELEFONE             varchar(20) not null  comment '',
   primary key (ID_CLIENTE)
);

/*==============================================================*/
/* Table: CONDICAO_PAGAMENTO                                    */
/*==============================================================*/
create table CONDICAO_PAGAMENTO
(
   ID_CONDICAO	INT AUTO_INCREMENT NOT NULL COMMENT '',
   DESCRICAO            varchar(40) not null  comment '',
   QTD_PARCELAS         int not null  comment '',
   ENTRADA		int not null  comment '',
   PRIMARY KEY (ID_CONDICAO)
);

/*==============================================================*/
/* Table: ENDERECOS_CLIENTES                                    */
/*==============================================================*/
create table ENDERECOS_CLIENTES
(
   ID_ENDERECO_CLIENTE  int not null  comment '',
   ID_CLIENTE           int not null  comment '',
   ID_TIPO_ENDERECO     int not null  comment '',
   CEP                  varchar(20) not null  comment '',
   NUMERO               int not null  comment '',
   COMPLEMENTO          varchar(100)  comment '',
   primary key (ID_ENDERECO_CLIENTE)
);

/*==============================================================*/
/* Table: ENDERECOS_FORNECEDORES                                */
/*==============================================================*/
create table ENDERECOS_FORNECEDORES
(
   ID_ENDERECO_FORNECEDOR  INT AUTO_INCREMENT NOT NULL COMMENT '',
   CEP                  varchar(20) not null  comment '',
   ID_FORNECEDOR        int not null  comment '',
   ID_TIPO_ENDERECO     int not null  comment '',
   NUMERO               int not null  comment '',
   COMPLEMENTO          varchar(100)  comment '',
   primary key (ID_ENDERECO_FORNECEDOR)
);

/*==============================================================*/
/* Table: FORECAST                                              */
/*==============================================================*/
create table FORECAST
(
   ID_FORECAST          int not null  comment '',
   DATA_RECEBIDO        date not null  comment '',
   VALOR_ENTRADA_PREVISTO decimal(16,2) not null  comment '',
   VALOR_ENTRADA_REALIZADO decimal(16,2) not null  comment '',
   VALOR_SAIDA_PREVISTO decimal(16,2) not null  comment '',
   VALOR_SAIDA_REALIZADO decimal(16,2) not null  comment '',
   SALDO_DIARIO         decimal(16,2) not null  comment '',
   primary key (ID_FORECAST)
);

/*==============================================================*/
/* Table: FORNECEDORES                                          */
/*==============================================================*/
CREATE TABLE FORNECEDORES
(
   ID_FORNECEDOR        INT AUTO_INCREMENT NOT NULL COMMENT '',
   NOME_FORNECEDOR                VARCHAR(100) NOT NULL COMMENT '',
   CNPJ_FORNECEDOR                BIGINT NOT NULL COMMENT '',
   EMAIL_FORNECEDOR               VARCHAR(100) NOT NULL COMMENT '',
   TELEFONE_FORNECEDOR             VARCHAR(20) NOT NULL COMMENT '',
   PRIMARY KEY (ID_FORNECEDOR)
);

/*==============================================================*/
/* Table: HISTORICO_PAGAMENTO                                   */
/*==============================================================*/
CREATE TABLE HISTORICO_PAGAMENTO (
    ID_HIST_PAGAMENTO INT AUTO_INCREMENT PRIMARY KEY,
    ID_PROG_PAGAMENTO INT NOT NULL,
    ID_NF_ENTRADA INT NOT NULL,
    TOTAL_PARCELAS INT NOT NULL,
    NUM_PARCELAS INT NOT NULL,
    DATA_VENCIMENTO DATE NOT NULL,
    DATA_PGT_EFETUADO DATE NOT NULL,
    VALOR_PARCELA DECIMAL(16,2) NOT NULL,
    VALOR_PARCELA_PAGO DECIMAL(16,2) NOT NULL,
    VALOR_DESCONTO DECIMAL(16,2) NOT NULL
);
/*==============================================================*/
/* Table: HISTORICO_RECEBIMENTO                                 */
/*==============================================================*/
create table HISTORICO_RECEBIMENTO
(
   ID_HIST_RECEBIMENTO  int not null  comment '',
   ID_PROG_RECEBIMENTO  int not null  comment '',
   ID_DESCONTO          int not null  comment '',
   ID_HIST_RECEB_DIVERGENTE int  comment '',
   DATA_RECEBIDO        date not null  comment '',
   VALOR_TOTAL_EM_HAVER decimal(16,2) not null  comment '',
   VALOR_PAGO           decimal(16,2) not null  comment '',
   primary key (ID_HIST_RECEBIMENTO)
);

/*==============================================================*/
/* Table: HISTORICO_RECEBIMENTO_DIVERGENTE                      */
/*==============================================================*/
create table HISTORICO_RECEBIMENTO_DIVERGENTE
(
   ID_HIST_RECEB_DIVERGENTE int not null  comment '',
   ID_HIST_RECEBIMENTO  int  comment '',
   DATA_RECBIDO         date  comment '',
   VALOR_TOTAL_EM_HAVER decimal(16,2)  comment '',
   VALOR_PAGO           decimal(16,2)  comment '',
   MOTIVO               varchar(80)  comment '',
   primary key (ID_HIST_RECEB_DIVERGENTE)
);

/*==============================================================*/
/* Table: NOTAS_FISCAIS_ENTRADA                                 */
/*==============================================================*/
CREATE TABLE NOTAS_FISCAIS_ENTRADA (
    ID_NF_ENTRADA INT AUTO_INCREMENT PRIMARY KEY,
    ID_FORNECEDOR INT NOT NULL,
    ID_CONDICAO INT NOT NULL,
    NUMERO_NF INT NOT NULL,
    DATA_EMISSAO DATE NOT NULL,
    VALOR_NET DECIMAL(16, 2) NOT NULL,
    VALOR_TRIBUTO DECIMAL(16, 2) NOT NULL,
    VALOR_TOTAL DECIMAL(16, 2) NOT NULL,
    NOME_ITEM VARCHAR(100) NOT NULL,
    QTD_ITEM INT NOT NULL
);

/*==============================================================*/
/* Table: NOTAS_FISCAIS_SAIDA                                   */
/*==============================================================*/
create table NOTAS_FISCAIS_SAIDA
(
   ID_NF_SAIDA          int not null  comment '',
   ID_CLIENTE           int not null  comment '',
   ID_CONDICAO          int not null  comment '',
   NUMERO_NF            int not null  comment '',
   DATA_EMISSAO         date not null  comment '',
   VALOR_PAGO           decimal(16,2) not null  comment '',
   VALOR_TRIBUTO        decimal(16,2) not null  comment '',
   VALOR_TOTAL          decimal(16,2) not null  comment '',
   NOME_ITEM            varchar(100) not null  comment '',
   QTD_ITEM             int not null  comment '',
   primary key (ID_NF_SAIDA)
);

/*==============================================================*/
/* Table: PROGRAMACAO_PAGAMENTO                                 */
/*==============================================================*/
CREATE TABLE PROGRAMACAO_PAGAMENTO (
    ID_PROG_PAGAMENTO    INT AUTO_INCREMENT,
    ID_NF_ENTRADA        INT NOT NULL,
    DATA_VENCIMENTO      DATE NOT NULL,
    DATA_PGT_EFETUADO    DATE NOT NULL,
    NUM_PARCELA          INT NOT NULL,
    VALOR_PARCELA        DECIMAL(16,2) NOT NULL,
    VALOR_PARCELA_PAGO   DECIMAL(16,2) NOT NULL,
    STATUS_PAGAMENTO     BIT NOT NULL,
    PRIMARY KEY (ID_PROG_PAGAMENTO)
);

/*==============================================================*/
/* Table: PROGRAMACAO_RECEBIMENTO                               */
/*==============================================================*/
create table PROGRAMACAO_RECEBIMENTO
(
   ID_PROG_RECEBIMENTO  int not null  comment '',
   ID_NF_SAIDA          int not null  comment '',
   ID_HIST_RECEBIMENTO  int  comment '',
   DATA_VENCIMENTO      date not null  comment '',
   NUM_PARCELA          int not null  comment '',
   VALOR_PARCELA        decimal(16,2) not null  comment '',
   STATUS_RECEBIMENTO   bool not null  comment '',
   primary key (ID_PROG_RECEBIMENTO)
);

/*==============================================================*/
/* Table: TIPO_DESCONTO                                         */
/*==============================================================*/
create table TIPO_DESCONTO
(
   ID_DESCONTO          int not null  comment '',
   DESCRICAO            varchar(40) not null  comment '',
   MINIMO_DIAS          int  comment '',
   MAXIMO_DIAS          int  comment '',
   MINIMO               decimal(5,2) not null  comment '',
   MAXIMO               decimal(5,2) not null  comment '',
   APROVADOR            varchar(100) not null  comment '',
   DATA_APROVACAO       date not null  comment '',
   TIPO_DESCONTO        bool  comment '',
   STATUS_APROVACAO     bool not null  comment '',
   primary key (ID_DESCONTO)
);

/*==============================================================*/
/* Table: TIPO_ENDERECO                                         */
/*==============================================================*/
create table TIPO_ENDERECO
(
   ID_TIPO_ENDERECO     int not null  comment '',
   DESCRICAO            varchar(40) not null  comment '',
   SIGLA                varchar(20) not null  comment '',
   primary key (ID_TIPO_ENDERECO)
);

alter table ENDERECOS_CLIENTES add constraint FK_ENDERECO_CLIENTE_E_TIPO_END foreign key (ID_TIPO_ENDERECO)
      references TIPO_ENDERECO (ID_TIPO_ENDERECO) on delete restrict on update restrict;

alter table ENDERECOS_CLIENTES add constraint FK_ENDERECO_END_CLIEN_CLIENTES foreign key (ID_CLIENTE)
      references CLIENTES (ID_CLIENTE) on delete restrict on update restrict;

alter table ENDERECOS_CLIENTES add constraint FK_ENDERECO_END_CLIEN_CEP foreign key (CEP)
      references CEP (CEP) on delete restrict on update restrict;

alter table ENDERECOS_FORNECEDORES add constraint FK_ENDERECO_END_FORNE_FORNECED foreign key (ID_FORNECEDOR)
      references FORNECEDORES (ID_FORNECEDOR) on delete restrict on update restrict;

alter table ENDERECOS_FORNECEDORES add constraint FK_ENDERECO_END_FORNE_CEP foreign key (CEP)
      references CEP (CEP) on delete restrict on update restrict;

alter table ENDERECOS_FORNECEDORES add constraint FK_ENDERECO_FORNECEDO_TIPO_END foreign key (ID_TIPO_ENDERECO)
      references TIPO_ENDERECO (ID_TIPO_ENDERECO) on delete restrict on update restrict;

alter table HISTORICO_PAGAMENTO add constraint FK_HISTORIC_HIST_PAGO_PROGRAMA foreign key (ID_PROG_PAGAMENTO)
      references PROGRAMACAO_PAGAMENTO (ID_PROG_PAGAMENTO) on delete restrict on update restrict;

alter table HISTORICO_RECEBIMENTO add constraint FK_HISTORIC_HIST_DIVE_HISTORIC foreign key (ID_HIST_RECEB_DIVERGENTE)
      references HISTORICO_RECEBIMENTO_DIVERGENTE (ID_HIST_RECEB_DIVERGENTE) on delete restrict on update restrict;

alter table HISTORICO_RECEBIMENTO add constraint FK_HISTORIC_HIST_RECE_PROGRAMA foreign key (ID_PROG_RECEBIMENTO)
      references PROGRAMACAO_RECEBIMENTO (ID_PROG_RECEBIMENTO) on delete restrict on update restrict;

alter table HISTORICO_RECEBIMENTO add constraint FK_HISTORIC_TIPO_DESC_TIPO_DES foreign key (ID_DESCONTO)
      references TIPO_DESCONTO (ID_DESCONTO) on delete restrict on update restrict;

alter table HISTORICO_RECEBIMENTO_DIVERGENTE add constraint FK_HISTORIC_HIST_DIVE_HISTORIC foreign key (ID_HIST_RECEBIMENTO)
      references HISTORICO_RECEBIMENTO (ID_HIST_RECEBIMENTO) on delete restrict on update restrict;

alter table NOTAS_FISCAIS_ENTRADA add constraint FK_NOTAS_FI_FORNECEDO_FORNECED foreign key (ID_FORNECEDOR)
      references FORNECEDORES (ID_FORNECEDOR) on delete restrict on update restrict;

alter table NOTAS_FISCAIS_ENTRADA add constraint FK_NOTAS_FI_NF_ENTRAD_CONDICAO foreign key (ID_CONDICAO)
      references CONDICAO_PAGAMENTO (ID_CONDICAO) on delete restrict on update restrict;

alter table NOTAS_FISCAIS_SAIDA add constraint FK_NOTAS_FI_CLIENTES__CLIENTES foreign key (ID_CLIENTE)
      references CLIENTES (ID_CLIENTE) on delete restrict on update restrict;

alter table NOTAS_FISCAIS_SAIDA add constraint FK_NOTAS_FI_NF_SAIDA__CONDICAO foreign key (ID_CONDICAO)
      references CONDICAO_PAGAMENTO (ID_CONDICAO) on delete restrict on update restrict;

alter table PROGRAMACAO_PAGAMENTO add constraint FK_PROGRAMA_HIST_PAGO_HISTORIC foreign key (ID_HIST_PAGAMENTO)
      references HISTORICO_PAGAMENTO (ID_HIST_PAGAMENTO) on delete restrict on update restrict;

alter table PROGRAMACAO_PAGAMENTO add constraint FK_PROGRAMA_NF_ENTRAD_NOTAS_FI foreign key (ID_NF_ENTRADA)
      references NOTAS_FISCAIS_ENTRADA (ID_NF_ENTRADA) on delete restrict on update restrict;

alter table PROGRAMACAO_RECEBIMENTO add constraint FK_PROGRAMA_HIST_RECE_HISTORIC foreign key (ID_HIST_RECEBIMENTO)
      references HISTORICO_RECEBIMENTO (ID_HIST_RECEBIMENTO) on delete restrict on update restrict;

alter table PROGRAMACAO_RECEBIMENTO add constraint FK_PROGRAMA_NF_SAIDA__NOTAS_FI foreign key (ID_NF_SAIDA)
      references NOTAS_FISCAIS_SAIDA (ID_NF_SAIDA) on delete restrict on update restrict;
      

