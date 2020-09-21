--Script de Criação do Banco de dados do Contas a Pagar e Receber
--o codigo abaixo é para o SQL server, caso use o Acces, execute bloco por bloco;

--Tabela de Acessos
CREATE TABLE `ACESSO` (
	`ID` Long NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	`USUARIO` VarChar(30), 
	`APELIDO` VarChar(10), 
	`SENHA` VarChar(20), 
	`STATUS` VarChar(20), 
	`DTUPDATE` DateTime
)

GO

--Indice Acesso Usuario, impede a duplição de Apelido
CREATE UNIQUE INDEX `ACESSOAPELIDO`
	ON `ACESSO` (`APELIDO`)
GO

--Tabela de Clientes e Fornecedores
CREATE TABLE `CliForn` (
	`ID` Long NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	`ORIGEM` VarChar(1), 
	`JURIDICA` Bit NOT NULL, 
	`NOME` VarChar(100), 
	`CGC_CPF` VarChar(20), 
	`DOCTO` VarChar(15), 
	`ENDERECO` VarChar(80), 
	`CEP` VarChar(10), 
	`ESTADO` VarChar(2), 
	`CIDADE` VarChar(80), 
	`BAIRRO` VarChar(60), 
	`DDD` VarChar(4), 
	`FONE1` VarChar(11), 
	`FONE2` VarChar(11), 
	`CONTATOS` VarChar(50), 
	`OBS` VarChar(255), 
	`DTCAD` DateTime, 
	`DTUPDATE` DateTime, 
	`USUARIO` Long DEFAULT 0, 
	FOREIGN KEY (`USUARIO`)
		REFERENCES `ACESSO` (`ID`)
)

GO

--Tabelas de Grupos/Centro de Custo e Contas
CREATE TABLE `Tabelas` (
	`ID` Long NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	`ORIGEM` VarChar(2), 
	`DESCRICAO` VarChar(60), 
	`DTUPDATE` DateTime, 
	`ID_USUARIO` Long DEFAULT 0, 
	`DTCAD` DateTime, 
	`ATIVO` Bit NOT NULL DEFAULT No, 
	FOREIGN KEY (`ID_USUARIO`)
		REFERENCES `ACESSO` (`ID`)
)
GO

--Tabela de Historico do Pagar e a Receber
CREATE TABLE `PagarReceber` (
	`ID` Long NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	`Origem` VarChar(1), 
	`ID_CLIFORN` Long DEFAULT 0, 
	`HIST` VarChar(50), 
	`DOCTO` VarChar(12), 
	`TIPO` VarChar(1), 
	`ID_CONTA` Long DEFAULT 0, 
	`ID_GRUPO` Long DEFAULT 0, 
	`ID_CUSTO` Long DEFAULT 0, 
	`DTVEN` DateTime, 
	`DTPAG` DateTime, 
	`VALOR` Double, 
	`VALORP` Double, 
	`DTCAD` DateTime, 
	`DTUPDATE` DateTime, 
	`USUARIO` Long DEFAULT 0, 
	FOREIGN KEY (`USUARIO`)
		REFERENCES `ACESSO` (`ID`), 
	FOREIGN KEY (`ID_CLIFORN`)
		REFERENCES `CliForn` (`ID`), 
	FOREIGN KEY (`ID_GRUPO`)
		REFERENCES `Tabelas` (`ID`), 
	FOREIGN KEY (`ID_CONTA`)
		REFERENCES `Tabelas` (`ID`), 
	FOREIGN KEY (`ID_CUSTO`)
		REFERENCES `Tabelas` (`ID`)
)
GO

--Query muito util, torna o codigo enxuto
CREATE VIEW `QueryPagarReceber` AS
SELECT Pagar.*, acesso.apelido
	, CliForn.NOME, conta.DESCRICAO AS NomeConta
	, grupo.DESCRICAO AS NomeGrupo
	, Tabelas.DESCRICAO AS NomeCusto
	FROM ((((PagarReceber AS Pagar LEFT JOIN acesso ON Pagar.usuario = acesso.id) 
		INNER JOIN CliForn ON Pagar.ID_CLIFORN = CliForn.ID) 
		LEFT JOIN Tabelas AS conta ON Pagar.ID_CONTA = conta.ID) 
		LEFT JOIN Tabelas AS grupo ON Pagar.ID_GRUPO = grupo.ID) 
		INNER JOIN Tabelas ON Pagar.ID_CUSTO = Tabelas.ID;

GO

--Senha='SENHA'
--INDICE NÃO PERMITE CRIAR 2 APELIDO IGUAIS

Insert into acesso (usuario,senha,apelido,status,dtupdate) values ('ADMIN','“hrm','ADMIN','pTUVqSWVoTVTr\]^q\^V',#2020-09-21 15:34:06#);
