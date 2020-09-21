#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
/*

	Função CadastroGenerico()
	Humberto Fornazier - Belo Horizonte/MG - Brasil
	humberto_fornazier@yahoo.com.br
	www.geocities.com/harbourminas

	Em muitos casos necessitamos de tabelas de apoio com campos Codigo e Descrição.
	Esta é uma  função é genérica, que cria , abre o arquivo e possibilita a mnanutenção no mesmo

	Para utilizar o Cadastro utilize a seguinte função:

	CadastroGenerico( cAlias , cTitulo )
	cAlias	= é a area/arquivo que o usuário deseja utilizar, caso o arquivo não exista, cria.
	cTitulo	= Titulo quye deverá ser apresentado nas janelas
	Exemplo	= CadastroGenerico( "CONTAS" ,  "Cadastro de Contas do Financeiro" ) 	
	Será criada a tabela CONTAS.DBF com os campos  -  Codigo	Character	04
						          Descricao	Character	30	
	
	Para utilizar a tabela em qualquer lugar do sistema, utilize a seguinte função: 
	GenericOpen( cAlias )
	cAlias	= Area/Arquivo que deverá ser aberto
	Exemplo	= GenericOpen( "CONTAS" )
	Será aberto o Arquivo Contas em uma nova area com Alias CONTAS

	Para Tratamento do arquivo, deverá ser utilizado os comandos:
	Contas->(DBgoTo()) , Contas->(DBGoBottom()) , Contas->(DBSkip()) , Contas->(DBAppend()) , etc, etc.
	
	Para tratar variaveis do Arquivo: Exemplo:
	cVarCodigo := Contas->Codigo
	cvarDesc    := Contas->Descricao	

	Para Gravar as variaveis no Arquivo:
	Contas->Codigo	:= cVariavel
	Contas->Descricao	:= cVariavel
	
*/
*---------------------------------------------------------------------------------------------------*
* Procedure CadastroGenerico | Cadastro Das Tabelas do Sistema    *
*---------------------------------------------------------------------------------------------------*
Procedure CadastroGenerico( oArea , oTitulo )

	  Private CodigoAlt	:= 0		&& Guarda o Codigo Atual para reposicionár-lo ao sair deste Cadastro 
	  Private cArea	:= oArea		&& Variável usualizada para guardar a área/alias utilizada
	  Private cTitulo	:= oTitulo		&& Titulo desta rotina, será mostrado em formulários
	  Private lNovo	:= .F.		&& Variável para controlar se Está Incluindo ou alterando usuários

	  GenericOpen( oArea )		&& Abre arquivo solicitado

	  (cArea)->(DBSetOrder(2))  		&& Posiciona o arquivo/alias na Ordem 2 - Descricao

	  *** Cria Formulário
	  DEFINE WINDOW Grid_Padrao	;
		 AT 05,05		; 
		 WIDTH	425		;
		 HEIGHT 460		;
		 TITLE cTitulo		;
		 ICON 'ICONE01'		;
		 MODAL			;
		 NOSIZE

		@ 010,010 GRID Grid_1P	;
			   WIDTH  400    	;
			   HEIGHT 329     	;
			   HEADERS {"Código","Descrição"};
			   WIDTHS  {60,333};
			   VALUE 1           	;
			   FONT "Arial" SIZE 09;
			   ON DBLCLICK { || Bt_Novo_Generic(2) }

		@ 357,011 LABEL  Label_Pesq_Generic;
			   VALUE "Pesquisa "	;
			    WIDTH 70		;
			    HEIGHT 20		;
			    FONT "Arial" SIZE 09

		@ 353,085 TEXTBOX PesqGeneric	;
			   WIDTH 326		;
			   TOOLTIP "Digite a Descrição para Pesquisa"   ;
			   MAXLENGTH 40 UPPERCASE		 ;
			   ON ENTER { || Pesquisa_Generic() }

		@ 397,011 BUTTON Generic_Novo	;
			   CAPTION '&Novo'	;
			   ACTION { || Bt_Novo_Generic(1)};
			   FONT "MS Sans Serif" SIZE 09 FLAT

		@ 397,111 BUTTON Generic_Editar	;
			   CAPTION '&Editar'	;
			   ACTION { || Bt_Novo_Generic(2)};
			   FONT "MS Sans Serif" SIZE 09 FLAT

		@ 397,211 BUTTON Generic_Excluir	;
			   CAPTION 'E&xcluir'	;
			   ACTION { || Bt_Excluir_Generic()};
			   FONT "MS Sans Serif" SIZE 09 FLAT

		@ 397,311 BUTTON Generic_Sair	;
			   CAPTION '&Sair'		;
			   ACTION { || Bt_Generic_Sair() };
			   FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW

	*** Posiciona o Foco no TextBox PesqGeneric
	Grid_Padrao.PesqGeneric.SetFocus

	*** Efetua pesquisa ao entrar no form para atualizar o Grid
	Renova_Pesquisa_Generic(" ")

	*** Centraliza Janela
	CENTER   WINDOW Grid_Padrao

	*** Ativa Janela
	ACTIVATE WINDOW Grid_Padrao

	Return Nil

/*
	nReg	= Recebe o Código do usuário utilizando a Função PegaValorDaColuna() - F_Funcoes.PRG
	cStatus	= Variável para informar na barra de Titulos do Formulário  se está Incluindo ou Alterando
*/
Function Bt_Novo_Generic(nTipo)
	Local nReg	    := PegaValorDaColuna( "Grid_1P" , "Grid_Padrao" , 1 )
	Local cStatus	    := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)	

	*** Variavel Private que controla se está sendo efetuada uma inclusão ou uma alteração
	lNovo		    := Iif(nTipo==1,.T.,.F.)

	 *** Se Tipo for 2, o usuário está Alterando/Editando um Registro
	If nTipo == 2	    && Editar/Alterar

		*** Se o usuário estiver editando/alterando um registro e a variável nReg estiver vazia é porque o grid não foi clicado
		*** Esta variável recebeu (veja cima) o valor do Grid em PegavalorDaColuna() 
		If Empty(nReg)

			MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
			Return Nil
		Else

			*** Posicona o Arquivo no Indice 1 (Codigo)	
			(cArea)->(DBSetOrder(1))

			*** Se o codigo não foi localizado no Arquivo, houve um erro de pesquisa
			If ! (cArea)->(DBSeek(nReg))

				MsgInfo("Erro de Pesquisa!!")
				Return NIl	   

			EndIf

			*** Se codigo a ser alterado foi localizado, a variável CodigoAlt Guarda o Valor do Codigo para posterior pesquisa e gravação
			CodigoAlt := (cArea)->Codigo

		EndIf

	EndIf

	DEFINE WINDOW Novo_Generic;
		AT 10,10		       ;
		WIDTH  590             ;
		HEIGHT 129             ;
		TITLE cTitulo		   ;
		MODAL			       ;
		NOSIZE			       

		DEFINE STATUSBAR		
			STATUSITEM "Manutenção no "+cTitulo
		END STATUSBAR

		       @003,005 FRAME Group_Generic_1 WIDTH 370 HEIGHT 75

		       *------------------------------------------ Campo Codigo
		       @014,020 LABEL  Label_Gen_Codigo    ;
				VALUE "Código"             ;
				WIDTH  70		   ;
				HEIGHT 15		   ;
				FONT "MS Sans Serif" SIZE 8 BOLD

		       @010,100 TEXTBOX  Generic_Codigo  ;
				WIDTH 50		 ;
				FONT "Arial" Size 9      ;
				TOOLTIP "Digite o C¢digo";
				MAXLENGTH 04 UPPERCASE	

		       *----------------------------------------------- Campo Descricao
		       @044,020 LABEL  Label_Gen_Descricao;
				VALUE "Descrição"        ;
				WIDTH  80		 ;
				HEIGHT 19		 ;
				FONT "MS Sans Serif" SIZE 8 BOLD

		       @040,100 TEXTBOX  Generic_Descricao;
				WIDTH 250		  ;
				FONT "Arial" Size 9       ;
				TOOLTIP "Digite a Descrição";
				MAXLENGTH 30 UPPERCASE;
				ON ENTER  Novo_Generic.Generic_Salvar.SetFocus
	  
		      @003,380 FRAME Group_Generic_6 WIDTH 200 HEIGHT 75

		       @10,390 BUTTON Generic_Salvar	;
				CAPTION "&Salvar"            ;
				ACTION { || Bt_Salvar_Generic() } ;
				WIDTH  180		     ;
				HEIGHT	25		     ;
				FONT "MS Sans Serif" SIZE 8 FLAT

		       @40,390 BUTTON Generic_Sair		    ;
				CAPTION "&Cancelar"              ;
				ACTION Novo_Generic.Release ;
				WIDTH  180		     ;
				HEIGHT	25		     ;
				FONT "MS Sans Serif" SIZE 8 FLAT

	 END WINDOW

	 *** Se a operação for de Alteração/Edição		
	If ! lNovo

		*** Preenche campos do formulário com dados do Arquivo		
		Novo_Generic.Generic_Codigo.Value := AllTrim((cArea)->Codigo)
		Novo_Generic.Generic_Descricao.Value := AllTrim((cArea)->Descricao)	

	EndIf

	*** Coloca na barra de Status do Formulário a variavel com informaç	ão de Alteração ou Inclusão
	Novo_Generic.StatusBar.Item(1) := cStatus

	*** Como o código é gerado pelo sistema, o campo código é desabilitado 
	 DISABLE CONTROL Generic_Codigo OF Novo_Generic

	 *** Posiciona a Área/Alias no Indice 2 (Descrição)
	 (cArea)->(DBSetOrder(2))

	*** Pociociona o Cursor/Foco  no campo Descrição do Formulário
	Novo_Generic.Generic_Descricao.SetFocus

	*** Centraliza Janela
	CENTER   WINDOW Novo_Generic

	*** Ativa janela
	ACTIVATE WINDOW Novo_Generic

	Return NIL

/*
*/		
Function Bt_Excluir_Generic()
	Local nReg	   := PegaValorDaColuna( "Grid_1P" , "Grid_Padrao" , 1 )
	Local cNome	   := ""
	Local cUltimaPesq := Upper(AllTrim( Grid_Padrao.PesqGeneric.Value ))

	*** Verifica se o Usuário atual tem permissão para Excluir Registros
	If ! NoExclui( Acesso->Status )
		MsgNo( "EXCLUIR")
		Return Nil
	EndIf

	*** Guarda a ultima pesquisa para posterior refresh do Grid
	cUltimaPesq := Iif( ! Empty(cUltimaPesq) , cUltimaPesq , AlLTrim(cNome) )

	*** Se variável nReg estiver em Branco 
	If Empty(nReg)

		MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
		Return Nil

	Else

		*** Posiciona a Área/Alias na Ordem 1 (por código)
		(cArea)->(DBSetOrder(1))
		
		*** Se Codigo que está no Grid não foi localizado no Arquivo, ocorreu um erro
		If ! (cArea)->(DBSeek(nReg))

			MSGINFO("Erro de Pesquisa!!")
			Return Nil

		EndIf

			*** Solicita confirmação do Registro
			If MsgYesNo("Excluir "+AllTrim( (cArea)->Descricao )+" ??",SISTEMA)

				*** Bloqueia Registro na Rede
				If BloqueiaRegistroNaRede( cArea )

					*** Exclui Resgistro
					(cArea)->(DBDelete())

					*** Libera registro na Rede
					(cArea)->(DBUnlock())

					*** Efetua Refresh do Grid
					Renova_Pesquisa_Generic(cUltimaPesq)

				EndIf

			EndIf

	EndIf
	Return Nil

/*
	cPesq				= Recebe o valor do campo de pesquisa PesqGeneric sem espaços em branco
	nTamanhoNomeParaPesquisa	= Guarda o tamanho da variável a ser pesquisada para comparar 
	Local nQuantRegistrosProcessados	= Contador que controla quantos registros já foram lidos
	Local nQuantMaximaDeRegistrosNoGrid = Limite de registros que serão mostrados no Grid
*/
Function Pesquisa_Generic()
	Local cPesq			:= Upper(AllTrim(   Grid_Padrao.PesqGeneric.Value  ))
	Local nTamanhoNomeParaPesquisa	:= Len(cPesq)
	Local nQuantRegistrosProcessados	:= 0
	Local nQuantMaximaDeRegistrosNoGrid := 30

	*** Posiciona Area/Alias na Ordem de Descrição		
	(cArea)->(DBSetOrder(2))
	
	*** Efetua pesquisa no Arquivo para posicionar no primeiro registro que satisfaça a condição
	(cArea)->(DBSeek(cPesq))

	*** Exclui todos os Dados do Grid
	DELETE ITEM ALL FROM Grid_1P OF Grid_Padrao

	*** Entra no Laço (While ) até que encontre o fim do arquivo
	Do While ! (cArea)->(Eof())

		*** Se o Substr da Descricao for igual à variavel cPesq ( Conteúdo do campo TxtPesquisa)
		if Substr( (cArea)->Descricao,1,nTamanhoNomeParaPesquisa) == cPesq
			
			*** Acumula contador
			nQuantRegistrosProcessados += 1

			*** Se a quantidade de resgistros lidos atingiu o limite de registros definidos para o grid sai do laço/While
			if nQuantRegistrosProcessados > nQuantMaximaDeRegistrosNoGrid
				EXIT
			EndIf

			*** Nesta rotina, pode-se aproveitar para verificar erros no arquivo
			*** Nesta caso, verifica se existem Descricao em branco, já que é um campo obrigatório
			If Empty( (cArea)->Descricao )
				MSGBOX("Existe Descrição em Branco Nesta Tabela") 	       
			Endif

			 *** Adiciona registro no Grid
			ADD ITEM { (cArea)->Codigo,(cArea)->Descricao} TO Grid_1P OF Grid_Padrao

		*** Se o Substr de Descricao estiver fora da faixa de pesquisa, abandona o laço
		ElseIf Substr( (cArea)->Descricao,1,nTamanhoNomeParaPesquisa) > cPesq

			EXIT
		
		Endif

		*** Salta para próximo registro
		(cArea)->(DBSkip())

	EndDo
	
	
	*** Pisiciona o cursor/Foco no campo PesqGeneric		
	Grid_Padrao.PesqGeneric.SetFocus

	 Return Nil

/*
	Recebe um parâmetro com o nome a ser pesquisado, colocar os Dez primeiros caracteres no PesqGeneric e
	retorna para a rotina Pesquisa_Generic()
*/
Function Renova_Pesquisa_Generic(cNome)
	Grid_Padrao.PesqGeneric.Value := Substr(AllTrim(cNome),1,10)
	 Grid_Padrao.PesqGeneric.SetFocus
	 Pesquisa_Generic()
	 Return Nil

/*
*/
Function Bt_Salvar_Generic()
	Local cCodigo
	Local cPesq	:= AllTrim( Grid_Padrao.PesqGeneric.Value )

	*** Se o campo Descricao não for informados, enviar mensagem e posiciona cursor/Foco no campo Generic_Descricao 
	If Empty( Novo_Generic.Generic_Descricao.Value  )
		PlayExclamation()
		MSGINFO("Descrição não Informada !!","Operação Inválida")
		Novo_Generic.Generic_Descricao.SetFocus
		Return Nil
	EndIf

	*** Se for um Novo registro
	 If lNovo	  

		*** Verifica se Usuário tem permissão para Incluir Registros
		If ! NoInclui( Acesso->Status )
			MsgNo( "INCLUIR")
			Return Nil
		EndIf

		*** Muda Status da variável lNovo 
		lNovo    := .F.

		*** Gera o próximo Codigo para o Registro - Função GeraCodigo() está em F_Funcoes.PRG
		cCodigo  := GeraCodigo( cArea  , 1 , 04 )

		*** Cria um novo Registro e grava
		(cArea)->(DBAppend())
		(cArea)->Codigo	:= cCodigo
		(cArea)->Descricao	:= Novo_Generic.Generic_Descricao.Value

		*** Verifica se Gravou o Codigo no Arquivo - Esta função está em F_Funcoes.PRG
		GravouCodigoCorretamente( cArea , cCodigo , 1 )
		PlayExclamation()
		MSGExclamation("Inclusão Efetivada no "+cTitulo,SISTEMA)

		*** Release no Formuário
		Novo_Generic.Release

		*** Refresh Grid
		Renova_Pesquisa_Generic(Substr( (cArea)->Descricao,1,10))

	Else	         

		*** Se estiver alterando registro
		*** Verifica se usuário atual tem permissão para Alterar registros
		If ! NoAltera( Acesso->Status )
			MsgNo( "ALTERAR")
			Return Nil
		EndIf

		*** Posiciona a Area/Alias na ordem de Código
		(cArea)->(DBSetOrder(1))

		*** Se código a ser alterado não for lozalizado no Arquivo - Ocorreu um erro
		If ! (cArea)->(DBSeek(CodigoAlt))
			PlayExclamation()
			MsgExclamation("ERRO-G01 # Código não Localizado para Alteração!!",SISTEMA)
		Else

			*** Bloqueia registro na rede
			If BloqueiaRegistroNaRede( cArea )

				*** Grava a Alteração no Arquivo	
				(cArea)->Descricao  := Novo_Generic.Generic_Descricao.Value

				*** Desbloqueia registro na rede
				(cArea)->(DBUnlock())

				*** Envia mensagem para Usuário					
				MsgINFO("Registro Alterado!!",SISTEMA)

				*** Release no Form
				Novo_Generic.Release

				*** Refresh Grid
				Renova_Pesquisa_Generic(Substr( (cArea)->Descricao,1,10))

			EndIf

		EndIf

	EndIf
	Return Nil
/*
*/
Function Bt_Generic_Sair()
	(cArea)->(DBCloseArea())
	Grid_Padrao.Release

/*
	Select( AREA )	 = retorna 0 se a área passada como parâmetro NÃO estiver em uso
	BasedeDados()	 = Funcão que retorna local da base de Dados do Sistema / Lê o arquivo FINANC.INI / Função está em F_FUNCOES.PRG
	ArqbBase	 = Concatena a variavel cBase + o Arquivo que será aberto
	aarq		 = Array para criar estrutura do arquivo

*/
Function GenericOpen( oArea , LPack )
	Local nArea	:= Select( oArea )
	Local aarq	:= {}
	Local xBase	:= BaseDeDados()
	Local ArqBase	:= xBase + oArea + ".DBF"   	 

	*** Se a variável LPack não foi passada como parâmetro, marca como .F.
	LPack := Iif( LPack == Nil ,  .F.  , lPack )

	*** Se Area/Alias nãoe sta em uso
	If nArea == 0		 

		*** Se arquivo não existe, cria
		If ! FILE( (ArqBase) )
			 Aadd( aarq , { 'CODIGO'	, 'C' , 04 , 0 } )
			 Aadd( aarq , { 'DESCRICAO'	, 'C' , 30 , 0 } )                
			 DBCreate     ( (ArqBase)     , aarq   )
		 EndIf     		

		*** Rotina para Efetuar PACK no DBF - Esta funçÃo está em F_Funcoes.PRG
		PacKArquivo( oArea , LPack  )					  

		*** Abre arquivo em uma nova area em mode de compartilhamento
		Use (ArqBase) Alias (oArea) new shared
		
		*** Se indice 1 não existe. cria   (codigo)
		If ! File( xBase + oArea + '1.ntx' )
			 Index on Codigo    to (xBase)+oArea+"1"
		Endif
		
		*** Se indice 2 não existe, cria  (Descricao)
		If ! File( xBase + oArea + '2.ntx' )
			 Index on Descricao to (xBase)+oArea+"2"
		Endif

		*** Limpa todas as seleções de Indices na Área para reposicioná-los
		(oArea)->(DBCLearIndex())
		(oArea)->(DBSetIndex( xBase + oArea + '1'))
		(oArea)->(DBSetIndex( xBase + oArea + '2'))

	Endif

	Return Nil     