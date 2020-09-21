#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
/*
*/
*---------------------------------------------------------------------------------------------------*
* Procedure Clientes | Cadastro dos Clientes			  *		   
*---------------------------------------------------------------------------------------------------*
Procedure Clientes()	

	Private CodigoAlt	:= 0
	Private cTitulo	:= "Cadastro de Clientes"
	Private lNovo	:= .F. 
	Private lJuridica	:= .F.
		  
	*** Abre arquivo de Clientes
	ClientesOpen()

	*** Posiciona na Ordem de indice 2 - Indexado por nome		
	Clientes->(DBSetOrder(2))  

	*** Cria Formulário
	DEFINE WINDOW Form_Clientes	;
		 AT 05,05		; 
		 WIDTH	425		;
		 HEIGHT 460		;
		 TITLE "Cadastro de Clientes";
		 ICON 'ICONE01'		;
		 CHILD			;
		 NOSIZE		

		 @ 010,010 GRID Grid_Clientes;
		   WIDTH  400          ;
		   HEIGHT 329          ;
		   HEADERS {"Código","Nome"};
		   WIDTHS  {60,350}    ;
		   VALUE 1             ;
		   FONT "Arial" SIZE 09;
		   ON DBLCLICK { || Bt_Novo_Cliente(2) }

		   @ 357,011 LABEL  Label_Pesquisa	 ;
		     VALUE "Pesquisa "                   ;
		     WIDTH 70				 ;
		     HEIGHT 20				 ;
		     FONT "Arial" SIZE 09

		   @ 353,085 TEXTBOX TxtPesquisa	 ;
		     WIDTH 326				 ;
		     TOOLTIP "Digite o Nome para Pesquisa"   ;
		     MAXLENGTH 40 UPPERCASE		 ;
		     ON ENTER { || Pesquisa_Cliente() }

		   @ 397,011 BUTTON Novo_Clientes      ;
			     CAPTION '&Novo'                ;
			     ACTION { || Bt_Novo_Cliente(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,111 BUTTON Editar_Clientes	  ;
			     CAPTION '&Editar'           ;
			     ACTION { || Bt_Novo_Cliente(2)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,211 BUTTON Excluir_Clientes	 ;
			     CAPTION 'E&xcluir'          ;
			     ACTION { || Bt_Excluir_Cliente(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,311 BUTTON Bt_Sair_Clientes	       ;
			     CAPTION '&Sair'                ;
			     ACTION { || Bt_Sair_Clientes() };
			     FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW
	
	*** Posiciona cursor/foco no campo TxtPesquisa
	Form_Clientes.TxtPesquisa.SetFocus

	*** Efetua a primeira pesquisa para preenche o Grid
	Renova_Pesquisa_Cliente(" ")

	*** Centraliza Janela
	CENTER	 WINDOW Form_Clientes

	*** Ativa janela		
	ACTIVATE WINDOW Form_Clientes

	Return Nil

/*
	Recebe o parâmetro nTipo que controla se é uma inclusão ou alteração
*/
Function Bt_Novo_Cliente(nTipo)
	 Local nReg	    := PegaValorDaColuna( "Grid_Clientes" , "Form_Clientes" , 1 )	

	 lNovo		    := Iif(nTipo==1,.T.,.F.)
	 lJuridica		    := .F.

	*** Se usuário estiver Editando/Alterando registro
	If nTipo == 2			

		*** Se nReg for vazio, o Grid não foi clicado
		If Empty(nReg)

			MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
			Return Nil

		Else			

			*** Posiciona area/alias na ordem 1 - por codigo
			Clientes->(DBSetOrder(1))

			*** Se codigo não foi localizado no arquivo - ocorreu um erro
			If ! Clientes->(DBSeek(nReg))

				MsgSTOP("Erro de Pesquisa em CLIENTES.DBF!!")
				Return NIl	   

			EndIf
	
			*** Guarda codigo do Cliente para posterior pesquisa e marca a váriável lJuridica
			CodigoAlt := Clientes->Codigo
			lJuridica	 := Clientes->Juridica

		EndIf

	EndIf

	*** Cria formulário
	DEFINE WINDOW Novo_Cliente	;
		AT 0,0			;
		WIDTH  460		;
		HEIGHT 446		;
		TITLE cTitulo		;
		MODAL			;
		NOSIZE			       

		DEFINE STATUSBAR		
			STATUSITEM "Manutenção no "+cTitulo
		END STATUSBAR

		@ 0,0 FRAME Dados_01 WIDTH 451 HEIGHT 175  FONT 'ARIAL'  SIZE 9

		@030,010 LABEL Lb_Codigo; 
			VALUE 'Código'	; 
			WIDTH 40	; 
			HEIGHT 15	; 
			FONT 'ARIAL' SIZE 9 

		@020,090 TEXTBOX TxtCodigo; 
			HEIGHT 25 ; 
			WIDTH 60 ; 
			FONT 'ARIAL' SIZE 9

		@ 20,175 CHECKBOX Pessoa_Juridica ; 
			CAPTION 'Jurídica' ; 
			WIDTH 63 ; 
			HEIGHT 30 ; 
			VALUE lJuridica ; 
			FONT 'ARIAL'  SIZE 9

		@030,260 LABEL Lb_CGC_CPF; 
			VALUE 'CGC/CPF'	; 
			WIDTH 60	; 
			HEIGHT 30	; 
			FONT 'ARIAL' SIZE 9			

		@ 020,320 TEXTBOX TxtCGC_CPF; 
			HEIGHT 25 ; 
			WIDTH 120 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o CGC ou CPF do Cliente";
			MAXLENGTH 20 ;
			ON LOSTFOCUS CriaMascara();
			ON ENTER Novo_Cliente.TxtNOME.SetFocus
  
		@ 60,10 LABEL Lb_Nome; 
			VALUE 'Nome' ; 
			WIDTH 100 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9

		@ 50,90 TEXTBOX TxtNOME; 
			HEIGHT 25 ; 
			WIDTH 350 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Nome do Cliente";
			MAXLENGTH 40;	
			UPPERCASE;
			ON ENTER Iif( Empty( Novo_Cliente.TxtNOME.Value ) ,  Novo_Cliente.TxtNOME.SetFocus , Novo_Cliente.TxtENDERECO.SetFocus )

		@ 90,10 LABEL Lb_Endereco; 
			VALUE 'Endereço' ; 
			WIDTH 80 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9       

		@ 80,90 TEXTBOX TxtENDERECO ; 
			HEIGHT 25 ; 
			WIDTH 350 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Endereço do Cliente";	
			MAXLENGTH 40;	
			UPPERCASE;
			ON ENTER Novo_Cliente.TxtBAIRRO.SetFocus

		@ 120,10 LABEL Lb_Bairro; 
			VALUE 'Bairro' ; 
			WIDTH 40 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9

		@ 110,90 TEXTBOX TxtBAIRRO; 
			HEIGHT 25 ; 
			WIDTH 180 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Bairro do Cliente";	
			MAXLENGTH 30;	
			UPPERCASE;
			ON ENTER Novo_Cliente.TxtCEP.SetFocus

		@ 120,280 LABEL Lb_Cep; 
			VALUE 'CEP' ; 
			WIDTH 30 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL'  SIZE 9

		@110,320 TEXTBOX TxtCEP;
			VALUE ' 00.000-000' ;
			INPUTMASK '99.999-999'

		@ 150,10 LABEL Lb_Cidade; 
			VALUE 'Cidade' ; 
			WIDTH 60 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9; 

		@ 140,90 TEXTBOX TxtCIDADE; 
			HEIGHT 25 ; 
			WIDTH 180 ; 
			FONT 'ARIAL'  SIZE 9;
			TOOLTIP "Digite a Cidade do Cliente";	
			MAXLENGTH 30;
			UPPERCASE;	
			ON ENTER Novo_Cliente.TxtESTADO.SetFocus

		@ 150,280 LABEL Lb_Estado; 
			VALUE 'Estado' ; 
			WIDTH 38 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL'  SIZE 9 

		@ 140,330 TEXTBOX TxtESTADO; 
			HEIGHT 25 ; 
			WIDTH 35 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Estado do Cliente";	
			MAXLENGTH 02;	
			UPPERCASE;
			ON ENTER Novo_Cliente.TxtDDD.SetFocus

		 @ 180,0 FRAME Dados_02 CAPTION 'Telefones'  WIDTH 450 HEIGHT 60  FONT 'ARIAL'  SIZE 9

		@ 210,20 LABEL Lb_DDD; 
			VALUE 'DDD' ; 
			WIDTH 35 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9

		@ 200,90 TEXTBOX TxtDDD; 
			HEIGHT 25 ; 
			WIDTH 40 ; 
			FONT 'ARIAL' SIZE 9;	
			TOOLTIP "Digite o DDD do Cliente";	
			MAXLENGTH 04;	
			ON ENTER Novo_Cliente.TxtFONE1.SetFocus

		@ 210,150 LABEL Lb_Fone1; 
			VALUE 'Fone #1' ; 
			WIDTH 45 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9

		@ 200,200 TEXTBOX TxtFONE1; 
			HEIGHT 25 ; 
			WIDTH 88 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Telefone #1 do Cliente";	
			MAXLENGTH 11;	
			ON ENTER Novo_Cliente.TxtFONE2.SetFocus

		@ 210,300 LABEL Lb_Fone2; 
			VALUE 'Fone #2'; 
			WIDTH 45 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL'  SIZE 9

		@ 200,350 TEXTBOX TxtFONE2 ; 
			HEIGHT 25 ; 
			WIDTH 88 ; 
			FONT 'ARIAL'  SIZE 9;
			TOOLTIP "Digite o Telefone #2 do Cliente";	
			MAXLENGTH 11;	
			ON ENTER Novo_Cliente.TxtCONTATOS.SetFocus

		@ 240,0 FRAME Dados_03 CAPTION 'Contatos'  WIDTH 451 HEIGHT 60  FONT 'ARIAL'  SIZE 9

		@ 260,10 TEXTBOX TxtCONTATOS; 
			HEIGHT 25 ; 
			WIDTH 430 ; 
			FONT 'ARIAL'  SIZE 9;
			TOOLTIP "Digite Contatos para este Cliente";	
			MAXLENGTH 50;	
			UPPERCASE;
			ON ENTER Novo_Cliente.Bt_Salvar.SetFocus

		@ 300,0 FRAME Status_01 CAPTION 'Status'  WIDTH 450 HEIGHT 52 FONT 'ARIAL'  SIZE 9

		@ 320,010 LABEL Lb_DT_CAD   VALUE 'Data Cad: '       WIDTH 120 HEIGHT 25 FONT 'ARIAL'  SIZE 9 
		@ 320,150 LABEL Lb_DT_ALT    VALUE 'Últ Alteração: '  WIDTH 150 HEIGHT 25 FONT 'ARIAL'  SIZE 9
		@ 320,310 LABEL Lb_USUARIO VALUE 'Usuário: '          WIDTH 140 HEIGHT 25 FONT 'ARIAL'  SIZE 9

		@ 360,10 BUTTON Bt_Salvar; 
			CAPTION '&Salvar' ; 
			ACTION Bt_Salvar_Clientes() ; 
			WIDTH 100 ; 
			HEIGHT 30 ;
			FONT "MS Sans Serif" SIZE 09 FLAT		

		@ 360,120 BUTTON Bt_Excluir; 
			CAPTION '&Excluir' ; 
			ACTION	Bt_Excluir_Cliente(2) ;
			WIDTH 100 ; 
			HEIGHT 30 ;
			 FONT "MS Sans Serif" SIZE 09 FLAT		

		@ 360,350 BUTTON Bt_Cancelar ; 
			CAPTION '&Cancelar' ; 
			ACTION Novo_Cliente.Release; 
			WIDTH 100 ; 
			HEIGHT 30 ; 			
			FONT "MS Sans Serif" SIZE 09 FLAT				     

	END WINDOW   
	
	*** Preenche campos do Formulário
	Clientes_Push()   	

	*** Coloca na barra de Status do Formulário a variavel com informaç	ão de Alteração ou Inclusão
	Novo_Cliente.StatusBar.Item(1) := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)	
	
	*** Desabilita TxtCodigo	
	Novo_Cliente.TxtCODIGO.Enabled := .F.

	*** Posiciona o cursor/Foco no objeto Pessoa_juridica			
	Novo_Cliente.Pessoa_Juridica.SetFocus

	*** Se for uma Inclusão
	If  lNovo

		*** Desabilita botão Excluir
		Novo_Cliente.Bt_Excluir.Enabled	:= .F.		

	EndIf

	*** Centraliza janela
	CENTER	 WINDOW Novo_Cliente

	*** Ativa janela
	ACTIVATE WINDOW Novo_Cliente

	Return NIL
/*

	cPesq				= Recebe o valor do campo de pesquisa TxtPesquisa sem espaços em branco
	nTamanhoNomeParaPesquisa	= Guarda o tamanho da variável a ser pesquisada para comparar 
	Local nQuantRegistrosProcessados	= Contador que controla quantos registros já foram lidos
	Local nQuantMaximaDeRegistrosNoGrid = Limite de registros que serão mostrados no Grid

*/
Function Pesquisa_Cliente()
	Local cPesq			:= Upper(AllTrim(   Form_Clientes.TxtPesquisa.Value  ))
	Local nTamanhoNomeParaPesquisa	:= Len(cPesq)
	Local nQuantRegistrosProcessados	:= 0
	Local nQuantMaximaDeRegistrosNoGrid := 30

	*** Posiciona Area/Alias por ordem de Nomes
	Clientes->(DBSetOrder(2))

	*** Efetua pesquisa no Arquivo para posicionar no primeiro registro que satisfaça a condição
	Clientes->(DBSeek(cPesq))

	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_Clientes OF Form_Clientes

	*** Entra no Laço (While ) até que encontre o fim do arquivo
	Do While ! Clientes->(Eof())

		*** Se o Substr do apelido for igual à variavel cPesq ( Conteúdo do campo TxtPesquisa)
		If Substr( Clientes->Nome,1,nTamanhoNomeParaPesquisa) == cPesq

			*** Acumula contador
			nQuantRegistrosProcessados += 1

			*** Se a quantidade de resgistros lidos atingiu o limite de registros definidos para o grid sai do laço/While
			if nQuantRegistrosProcessados > nQuantMaximaDeRegistrosNoGrid
				EXIT
			EndIf

			*** Nesta rotina, pode-se aproveitar para verificar erros no arquivo
			*** Nesta caso, verifica se existem Nomes de Clientes em branco, já que é um campo obrigatório
			If Empty( Clientes->Nome )

				MsgBox("Existe Nomes em Branco Nesta Tabela, Verifique!!",SISTEMA)

			Endif

			*** Adiciona registro no Grid
			ADD ITEM { Clientes->Codigo , Clientes->Nome } TO Grid_Clientes OF Form_Clientes

		*** Se o Substr de Apelido estiver fora da faixa de pesquisa, abandona o laço
		ElseIf Substr( Clientes->Nome,1,nTamanhoNomeParaPesquisa) > cPesq

				EXIT
		Endif
	
		** Pula para Próximo registro
		Clientes->(DBSkip())
	
	EndDo

	*** Posiciona cursor/foco no campo TxtPesquisa		
	Form_Clientes.TxtPesquisa.SetFocus

	Return Nil

/*
	Recebe um parâmetro com o nome a ser pesquisado, colocar os Dez primeiros caracteres no TxtPesquisa e
	retorna para a rotina Pesquisa_Cliente()
*/
Function Renova_Pesquisa_Cliente(cNome)
	Form_Clientes.TxtPesquisa.Value := Substr(AllTrim(cNome),1,10)
	Form_Clientes.TxtPesquisa.SetFocus
	Pesquisa_Cliente()
	Return Nil


/*
	Salva Dados do Formulário de Cadastro
*/
Function Bt_Salvar_Clientes()
	Local cCodigo
	Local cPesq	:= AllTrim( Form_Clientes.TxtPesquisa.Value )
	
	*** Se o campo Nome não for informado, enviar mensagem e posiciona cursor/Foco no campo TxtNome
	If Empty( Novo_Cliente.TxtNome.Value  )  
		PlayExclamation()
		MsgInfo("Nome do Cliente não Informado !!","Operação Inválida")
		Novo_Cliente.txtNOME.SetFocus
		Return Nil
	EndIf

	*** Se for um Novo registro
	If lNovo	  

		*** verifica se Usuário atual tem permissão para Incluir registros		  
		If ! NoInclui( Acesso->Status )
			MsgNo( "INCLUIR")
			Return Nil
		EndIf

		*** Muda Status de lNovo
		lNovo    := .F.

		*** Gera o próximo Codigo de Cliente - Função GeraCodigo() está em F_Funcoes.PRG
		cCodigo  := GeraCodigo( "Clientes"  , 1 , 06 )

		*** Cria um novo Registro e grava o codigo e a Data de Cadastro
		Clientes->(DBAppend())
		Clientes->Codigo	:= cCodigo	
		Clientes->DtCad	:= Date()	

		*** Grava outros dados do Cliente
		Clientes_Flush()

		*** Verifica se Gravou o Codigo no Arquivo - Esta função está em F_Funcoes.PRG
		GravouCodigoCorretamente( "Clientes" , cCodigo , 1 )
		PlayExclamation()
		MSGExclamation("Inclusão Efetivada no "+cTitulo,SISTEMA)

		*** Release Form			
		Novo_Cliente.Release

		*** Refresh Grid
		Renova_Pesquisa_Cliente(Substr( Clientes->Nome,1,10))

	Else	         
		
		*** Verifica se usuário atual tem permissão para Alterar dados
		If ! NoAltera( Acesso->Status )
			MsgNo( "ALTERAR")
			Return Nil
		EndIf

		*** Posiciona Area/Alias na ordemd e Codigo
		Clientes->(DBSetOrder(1))

		*** Se codigo à ser alterado nAo foi encontrado no arquivo, ocorreu erro
		If ! Clientes->(DBSeek(CodigoAlt))

			PlayExclamation()
			MsgExclamation("ERRO-G01 # Código não Localizado para Alteração!!",SISTEMA)

		Else

			*** Bloqueia registro na rede
			If BloqueiaRegistroNaRede( "Clientes" )
	
				*** Grava dados do formulário no arquivo de clientes
				Clientes_Flush()

				*** Desbloqueia registro na rede
				Clientes->(DBUnlock())

				*** Envia mensgaem para usuario
				MsgINFO("Registro Alterado!!",SISTEMA)

				*** Release formulário
				Novo_Cliente.Release

				*** Refresh Grid
				Renova_Pesquisa_Cliente(Substr( Clientes->Nome,1,10))

			EndIf

		 EndIf

	EndIf

	Return Nil


/*
	Coloca os dados do Arquivo de Clientes nos Campos do Formulário
*/
Function Clientes_Push()

	*** Se for um Novo cliente		
	If  lNovo

		*** vai para o fim do arquivo
		Clientes->(DBGoBottom())		 
		Clientes->(DBSkip())

	EndIf		

	Novo_Cliente.TxtCODIGO.Value	:= AllTrim(Clientes->Codigo)
	Novo_Cliente.Pessoa_Juridica.Value	 := Clientes->Juridica
	Novo_Cliente.TxtCGC_CPF.Value	:= AllTrim(Clientes->CGC_CPF)
	Novo_Cliente.TxtNOME.Value	:= AllTrim( Clientes->Nome )
	Novo_Cliente.TxtENDERECO.Value	:= AllTrim(Clientes->Endereco)
	Novo_Cliente.TxtBAIRRO.Value	:= AllTrim(Clientes->Bairro)
	Novo_Cliente.TxtCEP.Value		:= AllTrim(Clientes->Cep)
	Novo_Cliente.TxtCIDADE.Value	:= AllTrim(Clientes->Cidade)
	Novo_Cliente.TxtESTADO.Value	:= AllTrim(Clientes->ESTADO)
	Novo_Cliente.TxtDDD.Value		:= AllTrim(Clientes->DDD)
	Novo_Cliente.TxtFONE1.Value	:= AllTrim(Clientes->Fone1)
	Novo_Cliente.TxtFONE2.Value	:= AllTrim(Clientes->Fone2)
	Novo_Cliente.TxtCONTATOS.Value	:= AlLTrim(Clientes->Contatos)
	Novo_Cliente.Lb_DT_CAD.Value	:= "Data Cad: "+DtoC(Clientes->DtCad)
	Novo_Cliente.Lb_DT_ALT.Value	:= "Últ Alteração: "+DtoC(Clientes->DtAlt)
	Novo_Cliente.Lb_USUARIO.Value	:= "Usuário: "+PGeneric("ACESSO",1,Clientes->Usuario,"APELIDO")

	*** Funcão PGeneric() - Está ewm F_Funcoes.Prg

	Return Nil
/*

	Grava os Dados do Formulário no Arquivo

*/
Function Clientes_Flush()	
	
	Clientes->Nome		:= AllTrim( Novo_Cliente.TxtNOME.Value )
	Clientes->Juridica		:= Novo_Cliente.Pessoa_Juridica.Value
	Clientes->CGC_CPF	:= Novo_Cliente.TxtCGC_CPF.Value
	Clientes->Endereco	:= AllTrim( Novo_Cliente.TxtENDERECO.Value ) 
	Clientes->Bairro		:= AllTrim( Novo_Cliente.TxtBAIRRO.Value ) 
	Clientes->Cep		:= AllTrim( Novo_Cliente.TxtCEP.Value ) 
	Clientes->Cidade		:= AllTrim( Novo_Cliente.TxtCIDADE.Value ) 
	Clientes->Estado		:= AllTrim( Novo_Cliente.TxtESTADO.Value ) 
	Clientes->DDD		:= AllTrim( Novo_Cliente.TxtDDD.Value ) 
	Clientes->Fone1		:= AllTrim( Novo_Cliente.TxtFONE1.Value ) 
	Clientes->Fone2		:= AllTrim( Novo_Cliente.TxtFONE2.Value ) 
	Clientes->Contatos		:= AllTrim( Novo_Cliente.TxtCONTATOS.Value ) 
	Clientes->DtAlt		:= Date()
	Clientes->Usuario		:= Acesso->Codigo

	Return Nil

/*
	Esta função recebe o Parâmetro nGrid -  1 Se a exclusão foi solicitada do Grid   e  2 se
	exclusão foi solicitada pressionando o Botão excluir no formulario de cadastro
	
	nReg		= Recebe o Código do usuário utilizando a Função PegaValorDaColuna() 

*/
Function Bt_Excluir_Cliente( nGrid )
	Local nReg	   := PegaValorDaColuna( "Grid_Clientes" , "Form_Clientes" , 1 )
	Local cNome	   := ""
	Local cUltimaPesq := Upper(AllTrim( Form_Clientes.TxtPesquisa.Value ))

	*** Verifica se Usuário atual tem permissão para Excluir registros
	If ! NoExclui( Acesso->Status )
		MsgNo( "EXCLUIR")
		Return Nil
	EndIf

	 cUltimaPesq := Iif( ! Empty(cUltimaPesq) , cUltimaPesq , AllTrim(cNome) )

	 nReg := Iif( nGrid == 1 , nReg ,  Novo_Cliente.txtCodigo.Value )

	 If Empty(nReg)

		MsgExclamation("Nenhum Registro Informado para Exclusão!!",SISTEMA)
		Return Nil

	Else

		*** Posiciona area/alias na ordem de codigo
		Clientes->(DBSetOrder(1))
		
		*** Se codigo não foi localizado - ocorreu um erro
		If ! Clientes->(DBSeek(nReg))
			MsgINFO("Erro de Pesquisa!!")
			Return Nil
		EndIf

		*** Solicita confirmação para Exclusão
		If MsgYesNo("Excluir "+AllTrim( Clientes->Nome )+" ??",SISTEMA)

			*** Bloqueia registro na rede
			If BloqueiaRegistroNaRede( "Clientes" )

				*** Exclui Registro
				Clientes->(DBDelete())

				*** Libera rede
				Clientes->(DBUnlock())

				*** Se a exclusão foi solicitada pelo formuário efetua release do form
				If nGrid != 1
					Novo_Cliente.Release
				EndIf

				*** Refresh Grid
				Renova_Pesquisa_Cliente(cUltimaPesq)

			 EndIf

		EndIf

	 EndIf
	 Return Nil

/*
	Fecha Arquivo
	Release formulário
*/
Function Bt_Sair_Clientes()
	Clientes->(DBCloseArea())
	Form_Clientes.Release
	Return Nil

/*

	Select( AREA )	 = retorna 0 se a área passada como parâmetro NÃO estiver em uso
	BasedeDados()	 = Funcão que retorna local da base de Dados do Sistema / Lê o arquivo FINANC.INI / Função está em F_FUNCOES.PRG
	ArqbBase	 = Concatena a variavel cBase + o Arquivo que será aberto
	aarq		 = Array para criar estrutura do arquivo

*/
Function ClientesOpen( LPack )
	Local nArea	:= Select( 'Clientes' )	
	Local cBase	:= BaseDeDados()	
	Local ArqBase	:= cBase+"Clientes.DBF"
	Local aarq	:= {}		
                 
	*** Atualiza mensagem na Barra de Status do Formulário principal / Menu - esta funcão esta em f_funcoes.prg
	LinhaDeStatus( "Abrindo Cadastro de Clientes" )

	*** Se arquivo não estiver em uso
	If nArea == 0

		*** Se arquivo Clientes.DBF não existir
		If ! File( (ArqBase) )
			Aadd( aarq , { 'CODIGO'	, 'C' , 06 , 0 } )
			Aadd( aarq , { 'JURIDICA'	, 'L' , 01 , 0 } )
			Aadd( aarq , { 'NOME'	, 'C' , 40 , 0 } )
			Aadd( aarq , { 'CGC_CPF'	, 'C' , 20 , 0 } )
			Aadd( aarq , { 'DOCTO'	, 'C' , 15 , 0 } )
			Aadd( aarq , { 'ENDERECO', 'C' , 40 , 0 } )
			Aadd( aarq , { 'CEP'	, 'C' , 10 , 0 } )
			Aadd( aarq , { 'ESTADO'	, 'C' , 02 , 0 } )
			Aadd( aarq , { 'CIDADE'	, 'C' , 25 , 0 } )
			Aadd( aarq , { 'BAIRRO'	, 'C' , 25 , 0 } )
			Aadd( aarq , { 'DDD'	, 'C' , 04 , 0 } )
			Aadd( aarq , { 'FONE1'	, 'C' , 11 , 0 } )
			Aadd( aarq , { 'FONE2'	, 'C' , 11 , 0 } )
			Aadd( aarq , { 'CONTATOS'	, 'C' , 50 , 0 } )
			Aadd( aarq , { 'OBS'	, 'C' , 40 , 0 } )
			Aadd( aarq , { 'DTCAD'	, 'D' , 08 , 0 } )
			Aadd( aarq , { 'DTALT'	, 'D' , 08 , 0 } )
			Aadd( aarq , { 'USUARIO'	, 'C' , 04 , 0 } )
			DBCreate     ( (ArqBase)     , aarq, DRIVER   )
		EndIf

		*** Rotina para Efetuar PACK no DBF - Esta função está em F_Funcoes.PRG
		PacKArquivo( ArqBase , LPack  )

		*** abre arquivo em uma nova area em modo compartilhado
		Use (ArqBase) Alias Clientes New Shared Via DRIVER

		*** Se indice 1 não existir cria
		If ! File(cBase+'Cliente1.ntx')
			LinhaDeStatus("Index Clientes por Código - Clientes1.ntx")
			Index On CODIGO To (cBase)+'Cliente1'
		EndIf

		*** Se indice 2 não existir cria
		If ! File(cBase+'Cliente2.ntx')
			LinhaDeStatus("Index Clientes por Nome - Clientes2.ntx")
			Index On NOME to (cBase)+'Cliente2'
		EndIf

	EndIf

	*** Limpa todas as seleções de Indices na Área para reposicioná-los
	Clientes->(DBCLearIndex())
	Clientes->(DBSetIndex(cBase+'Cliente1'))
	Clientes->(DBSetIndex(cBase+'Cliente2'))

	*** limpa linha de status do formu;ário principal
	LinhaDeStatus()

	Return nArea
/*

	Funcão que cria máscara para CGC e CPF e atualiza TextBox

*/
Function CriaMascara()	
	Local i		:= 0
	Local cCGC	:= AllTrim( Novo_Cliente.TxtCGC_CPF.Value )  && Pega dados digitados no TextBox sem nenhum espaco
	Local cNewCGC	:= ""

	*** Entra no contador de 1 à Tamanho da variável cCGC
	For i := 1	 To Len( cCGC )  

		*** Acumula na Variável cNewCGC apenas os Digitos de  0 - 9
		cNewCGC += Iif(  IsDigit( Substr( cCGC , i , 1 ) )  , Substr( cCGC , i , 1 ) , ""  )

	Next

	*** Se Cliente for pessoa Juridica coloca máscara para CGC
	If Novo_Cliente.Pessoa_Juridica.Value

		Novo_Cliente.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 99.999.999/9999-99" ) )

	Else
		
		*** Caso contrário, coloca máscara para CPF
		Novo_Cliente.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 999.999.999-99" ) )

	EndIf

	Return Nil