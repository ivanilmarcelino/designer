#include "minigui.ch"
#Include "F_sistema.ch"
*---------------------------------------------------------------------------------------------------*
* Procedure ContasPagar | Cadastro Contas à Pagar 		  *		   
*---------------------------------------------------------------------------------------------------*
Procedure ContasPagar()	
	Local aFornecedores := {} 
	Local aContas	    := {}

	Private CodigoAlt	:= 0
	Private cTitulo	:= "Arquivo de Contas à Pagar"
	Private lNovo	:= .F. 		  
	
	*** Abre Arquivos	
	FornecedOpen(.F.)	
	PagarOpen(.F.)
	GenericOpen( "Contas" )
	GenericOpen( "Grupos" )
	GenericOpen( "Custos" )

	*** Posiciona Indices
	Pagar->(DBSetOrder(1))	
	Forneced->(DBSetOrder(2))
	Contas->(DBSetOrder(2))
	Grupos->(DBSetOrder(2))
	Custos->(DBSetOrder(2))	

	*** Enche Array - Estas variáveis serão utilizadas no Combo Fornecedores e Contas
	EncheArray( @aFornecedores , @aContas)	

	*** Cria Formulário / Grid e Consulta
	DEFINE WINDOW Form_Pagar	;
		AT 0,0			;
		WIDTH 560 HEIGHT 450	;
		TITLE "Contas à Pagar"	;
		ICON 'ICONE01'		;
		CHILD			;
		NOSIZE		

		@010,005 GRID Grid_Pagar ; 
			  WIDTH 540 ; 
			  HEIGHT 220 ; 
			  HEADERS { "Código","DT Vencto", "DT Pagto" , "Fornecedor" , "Valor"} ; 
			  WIDTHS { 80, 80 , 80 , 220 , 80  } ; 
			  FONT 'ARIAL'  SIZE 9;
			  ON DBLCLICK { || Bt_Novo_Pagar(2) } ;						
			  JUSTIFY { BROWSE_JTFY_LEFT , BROWSE_JTFY_CENTER ,  BROWSE_JTFY_CENTER ,  BROWSE_JTFY_LEFT ,  BROWSE_JTFY_RIGHT }
		
			@000,000 FRAME CONTROL_4 WIDTH 550 HEIGHT 235 FONT 'ARIAL'  SIZE 8

			@240,000 FRAME Fr_Pesquisar ;
				  CAPTION 'Pesquisar Período de'  ;
				  WIDTH 250 HEIGHT 56 FONT 'ARIAL' SIZE 9
						
			@260,010 DATEPICKER Dp_Data1 VALUE CtoD( "01/01/2000");
				  WIDTH 100 FONT 'ARIAL' SIZE 9

			@270,120 LABEL CONTROL_11 VALUE 'à' ; 
			 	  WIDTH 10 HEIGHT 15  FONT 'ARIAL'  SIZE 9

			@260,140 DATEPICKER Dp_Data2 ; 
				  WIDTH 100 FONT 'ARIAL' SIZE 9

			@240,300 FRAME Fr_Tipo ; 
				  CAPTION 'Tipo de Documento' ; 
				  WIDTH 250 HEIGHT 56 FONT 'ARIAL'  SIZE 9

			@260,310 CHECKBOX Cb_APagar ; 
				  CAPTION 'À pagar' ; 
				  WIDTH 62 HEIGHT 25 VALUE FALSE FONT 'ARIAL'  SIZE 8;
				  ON CHANGE {|| Iif ( Form_Pagar.Cb_APagar.Value ,  Form_Pagar.Cb_Pagos.Value := .F. ,  Form_Pagar.Cb_APagar.Value := .F. ) ,  Iif ( Form_Pagar.Cb_APagar.Value ,  Form_Pagar.Cb_Tudo.Value := .F. ,  Form_Pagar.Cb_APagar.Value := .F. ) }

			@260,400 CHECKBOX Cb_Pagos ; 
				CAPTION 'Pagos' ; 
				WIDTH 70 HEIGHT 25 VALUE FALSE FONT 'ARIAL'  SIZE 8 ;
				ON CHANGE {|| Iif ( Form_Pagar.Cb_Pagos.Value ,  Form_Pagar.Cb_APagar.Value := .F. ,  Form_Pagar.Cb_Pagos.Value := .F. ) ,  Iif ( Form_Pagar.Cb_Pagos.Value ,  Form_Pagar.Cb_Tudo.Value := .F. ,  Form_Pagar.Cb_Pagos.Value := .F. ) }

			@260,490 CHECKBOX Cb_Tudo ; 
				 CAPTION 'Tudo' ;
				 WIDTH 50  HEIGHT 25 VALUE FALSE FONT 'ARIAL'  SIZE 8
				 ON CHANGE {|| Iif ( Form_Pagar.Cb_Tudo.Value ,  Form_Pagar.Cb_APagar.Value := .F. ,  Form_Pagar.Cb_Tudo.Value := .F. ) ,  Iif ( Form_Pagar.Cb_Tudo.Value ,  Form_Pagar.Cb_Pagos.Value := .F. ,  Form_Pagar.Cb_Tudo.Value := .F. ) }
				
			@360,000 FRAME Fr_Opcoes ; 
				  CAPTION 'Opções' ; 
				  WIDTH 550 HEIGHT 60 FONT 'ARIAL'  SIZE 9

			@ 300,0 FRAME Fr_Fornecedor ; 
				CAPTION 'Fornecedor' ; 
				WIDTH 250 HEIGHT 56 FONT 'ARIAL' SIZE 9

			@ 320,10 COMBOBOX Cb_Fornecedor ; 
				 ITEMS aFornecedores ; 
				 VALUE 1	;				
				 WIDTH 230 FONT 'ARIAL' SIZE 9

			@ 300,300 FRAME Fr_Conta ; 
				CAPTION 'Conta' ; 
				WIDTH 250 HEIGHT 56 FONT 'ARIAL'  SIZE 9

			@ 320,310 COMBOBOX Cb_Contas ; 
				   ITEMS aContas;
				   VALUE 1 ; 
				   WIDTH 230 FONT 'ARIAL'  SIZE 9

			@ 380,10 BUTTON Bt_Pesquisar ; 
				CAPTION 'Pesquisar' ; 
				ACTION { || Pesquisa_Pagar() } ; 
				WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

			@ 380,140 BUTTON Bt_Novo ;
				CAPTION '&Novo' ; 
				ACTION { ||  Bt_Novo_Pagar(1) } ; 
				WIDTH 100 HEIGHT 30 FONT 'ARIAL'  SIZE 9 FLAT

			@ 380,240 BUTTON Bt_Editar ;
				CAPTION '&Editar' ; 
				ACTION { || Bt_Novo_Pagar(2) } ; 
				WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

			@ 380,340 BUTTON Bt_Excluir ; 
				CAPTION 'E&xcluir' ; 
				ACTION { ||  Bt_Excluir_Pagar(1) } ; 
				WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

			@ 380,440 BUTTON CONTROL_8 ;
				CAPTION '&Sair' ; 
				ACTION { || Bt_Sair_Pagar() } ; 
				WIDTH 100  HEIGHT 30 FONT 'ARIAL'  SIZE 9 FLAT


	END WINDOW
	
	*** Marca ChekBox à Pagar
	Form_Pagar.Cb_APagar.Value := .T.

	*** Posiciona cursor/Foco em Data1
	Form_Pagar.Dp_Data1.SetFocus

	*** Efetua primeira pesquisa para atualizar o Grid
	Pesquisa_Pagar()	

	*** Centraliza Janela
	CENTER	 WINDOW Form_Pagar

	*** Ativa janela
	ACTIVATE WINDOW Form_Pagar

	Return Nil


/*
	Recebe o parâmetro nTipo que controla se é uma inclusão ou alteração
*/
Function Bt_Novo_Pagar(nTipo)
	 Local nReg	:= PegaValorDaColuna( "Grid_Pagar" , "Form_Pagar" , 1 )
	 Local nFornec	:= 1
	 Local nConta	:= 1
	 Local nGrupo	:= 1
	 Local nCusto	:= 1

	 lNovo		    := Iif(nTipo==1,.T.,.F.)
	
	*** Se usuario estiver editando/alterando registro
	If nTipo == 2			

		*** Se nReg for vazio, o Grid não foi clicado
		If Empty(nReg)

			MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
			Return Nil

		Else			
			
			*** Posiciona area/alias no indice 1 - (codigo) do documento
			Pagar->(DBSetOrder(1))
			
			*** Se registro não foi localizado no arquivo - ocorreu erro
			If ! Pagar->(DBSeek(nReg))

				MsgSTOP("Erro de Pesquisa em Pagar.DBF!!")
				Return NIl	   

			EndIf

			*** Guarda o Codigo do documento para posterior pesquisa
			CodigoAlt := Pagar->Codigo			

		EndIf

		*** Posiciona arquivo de fornecedores por ordem de codigo
		*** Posiciona o Arquivo de Fornecedores no Registro igual ao código do fornecedor gravado em Pagar.DBF
		*** Guarda o registro na variável nFornec que será usada em ITEMSOURCE do ComboBox Cb_Fornecedor
		*** Posiciona o Arquivo de Fornecedores na Ordem de Nomes
		Forneced->(DBSetOrder(1))
		Forneced->(DBSeek( Pagar->Fornec ) )
		nFornec := Forneced->(Recno())
		Forneced->(DBSetOrder(2))

		*** Posiciona arquivo de Contas por ordem de codigo
		*** Posiciona o Arquivo de Contas no Registro igual ao código da Conta gravado em Pagar.DBF
		*** Guarda o registro na variável nConta que será usada em ITEMSOURCE do ComboBox Cb_Conta
		*** Posiciona o Arquivo de Contas na Ordem de Descricao
		Contas->(DBSetOrder(1))
		Contas->(DBSeek( Pagar->Conta ) )
		nConta := Contas->(Recno())
		Contas->(DBSetOrder(2))		

		*** Posiciona arquivo de Grupos por ordem de codigo
		*** Posiciona o Arquivo de Grupo no Registro igual ao código do Grupo gravado em Pagar.DBF
		*** Guarda o registro na variável nGrupo que será usada em ITEMSOURCE do ComboBox Cb_Grupo
		*** Posiciona o Arquivo de Grupos na Ordem de Descricao
		Grupos->(DBSetOrder(1))
		Grupos->(DBSeek( Pagar->Grupo ) )
		nGrupo := Grupos->(Recno())
		Grupos->(DBSetOrder(2))

		*** Posiciona arquivo de Custos por ordem de codigo
		*** Posiciona o Arquivo de Custos no Registro igual ao código de CCusto gravado em Pagar.DBF
		*** Guarda o registro na variável nCusto que será usada em ITEMSOURCE do ComboBox Cb_Custo
		*** Posiciona o Arquivo de Contas na Ordem de Descricao
		Custos->(DBSetOrder(1))
		Custos->(DBSeek( Pagar->CCusto ) )
		nCusto := Custos->(Recno())
		Custos->(DBSetOrder(2))

	Else

		*** Posiciona Arquivo de Fornecedores por ordem de Nomes 
		*** Posiciona o Arquivo de Fornecedores no Primeiro Registro
		*** Guarda o registro na variável nFornec que será usada em ITEMSOURCE do ComboBox Cb_Fornecedor
		Forneced->(DBSetOrder(2))
		Forneced->(DBGoTop())
		nFornec := Forneced->(Recno())

		*** Posiciona Arquivo de Contas por ordem de Descricao
		*** Posiciona o Arquivo de Contas no Primeiro Registro
		*** Guarda o registro na variável nConta que será usada em ITEMSOURCE do ComboBox Cb_Conta
		Contas->(DBSetOrder(2))
		Contas->(DBGoTop())
		nConta := Contas->(Recno())

		*** Posiciona Arquivo de Grupos por ordem de Descricao 
		*** Posiciona o Arquivo de Grupos no Primeiro Registro
		*** Guarda o registro na variável nGrupo que será usada em ITEMSOURCE do ComboBox Cb_Grupo
		Grupos->(DBSetOrder(2))
		Grupos->(DBGoTop())
		nGrupo := Grupos->(Recno())

		*** Posiciona Arquivo de Custos por ordem de Descricao
		*** Posiciona o Arquivo de Custos no Primeiro Registro
		*** Guarda o registro na variável nCusto que será usada em ITEMSOURCE do ComboBox Cb_Custo
		Custos->(DBSetOrder(2))
		Custos->(DBGoTop())
		nCusto := Custos->(Recno())

	EndIf

	*** Cria Formulário
	DEFINE WINDOW Novo_Pagar	;
		AT 0,0			;
		WIDTH 559 HEIGHT 385	;
		TITLE cTitulo		;
		ICON 'ICONE01'		;
		MODAL			;
		NOSIZE					       

		DEFINE STATUSBAR		
			STATUSITEM "Manutenção no "+cTitulo
		END STATUSBAR

		@ 3,0 FRAME Fr_Frame_1 WIDTH 550 HEIGHT 55 FONT 'ARIAL'  SIZE 9

		@ 23,10 LABEL Lb_Controle; 
			VALUE 'Controle'  WIDTH 60 HEIGHT 20 FONT 'ARIAL' SIZE 9

		@ 23,70 LABEL Lb_Codigo ; 
			VALUE '0000000000'  WIDTH 70 HEIGHT 20 FONT 'ARIAL' SIZE 9

		@ 20,170 LABEL Lb_Fornecedor ; 
			 VALUE 'Fornecedor'  WIDTH 66 HEIGHT 20 FONT 'ARIAL' SIZE 9

		@ 20,240 COMBOBOX Cb_Fornecedor; 
			ITEMSOURCE Forneced->Nome ;
			VALUE nFornec ; 
			WIDTH 300 FONT 'ARIAL' SIZE 9 TOOLTIP "Informe Fornecedor"

		@ 60,0 FRAME Fr_Frame_2  WIDTH 550 HEIGHT 110 FONT 'ARIAL'  SIZE 9

		@ 70,10 LABEL Lb_Historico ; 
			VALUE 'Histórico' ; 
			WIDTH 60 HEIGHT 20 FONT 'ARIAL'  SIZE 9

		@ 70,80 TEXTBOX TxtHistorico; 
			HEIGHT 20 WIDTH 460 FONT 'ARIAL'  SIZE 9 ;
			TOOLTIP "Digite o Histórico desre Lançamento"   ;
			 MAXLENGTH 50 UPPERCASE		 ;
			ON ENTER Novo_Pagar.TxtDocumento.SetFocus

		@ 100,10 LABEL Lb_Documento ; 
			VALUE 'Documento' ; 
			WIDTH 65 HEIGHT 20 FONT 'ARIAL'  SIZE 9 

		@ 100,80 TEXTBOX TxtDocumento ; 
			HEIGHT 20  WIDTH 100 ; 
			FONT 'ARIAL'  SIZE 9 ;
			TOOLTIP "Digite o Número do Documento"   ;
			 MAXLENGTH 12 UPPERCASE		 ;
			ON ENTER Novo_Pagar.Dp_Vencto.SetFocus

		@ 100,200 LABEL Lb_Vencto; 
			   VALUE 'DT Vencto' ; 
			   WIDTH 60 HEIGHT 20 ; 
			   FONT 'ARIAL'  SIZE 9 

		@ 100,270 DATEPICKER Dp_Vencto ; 
			WIDTH 100 FONT 'ARIAL'  SIZE 9

		@ 100,400 LABEL Lb_Valor; 
			VALUE 'Valor'  WIDTH 36 HEIGHT 20 FONT 'ARIAL'  SIZE 9
	
		@ 100,440 TEXTBOX TxtValor ; 
			 WIDTH 100 VALUE "123456.12" NUMERIC INPUTMASK "$ 9999,999.99" 		

		@ 130,10 LABEL Lb_Pagto ; 
			VALUE 'DT Pagto' ; 
			WIDTH 60  HEIGHT 20 FONT 'ARIAL' SIZE 9

		@ 130,80 DATEPICKER Dp_Pagto; 
			WIDTH 100 FONT 'ARIAL'  SIZE 9 SHOWNONE RIGHTALIGN

		@ 130,200 LABEL Lb_ValorPago ; 
			VALUE 'Valor Pago' ; 
			WIDTH 60 HEIGHT 20 FONT 'ARIAL' SIZE 9 

		@ 130,270 TEXTBOX TxtValorPago ; 
			 WIDTH 100 VALUE "123456.12" NUMERIC INPUTMASK "$ 9999,999.99" 		

		@ 130,380 LABEL Lb_Diferenca ; 
			VALUE 'Diferença' ; 
			WIDTH 60 HEIGHT 20 FONT 'ARIAL' SIZE 9

		@ 130,440 TEXTBOX TxtDiferenca ; 
			 WIDTH 100 VALUE "123456.12" NUMERIC INPUTMASK "$ 9999,999.99" 		

		@ 171,0 FRAME Fr_Frame_3 WIDTH 550 HEIGHT 73 FONT 'ARIAL'  SIZE 9

		@ 180,10 LABEL Lb_Conta ; 
			VALUE 'Conta'  WIDTH 60 HEIGHT 20 FONT 'ARIAL'  SIZE 9

		@ 200,10 COMBOBOX Cb_Conta ; 
			 ITEMSOURCE Contas->Descricao ;			
			VALUE nConta ;
			WIDTH 170  FONT 'ARIAL' SIZE 9 TOOLTIP "Informe Conta Financeira"

		@ 180,190 LABEL Lb_Grupo ; 
			VALUE 'Grupo' WIDTH 60 HEIGHT 20 FONT 'ARIAL'  SIZE 9

		@ 200,190 COMBOBOX Cb_Grupo ; 
			   ITEMSOURCE Grupos->Descricao ;				
			   VALUE nGrupo ;
			   WIDTH 170  FONT 'ARIAL'  SIZE 9 TOOLTIP "Informe Grupo de Contas"

		@ 180,370 LABEL Lb_CCusto ; 
			VALUE 'Centro de Custo'  WIDTH 90 HEIGHT 20 FONT 'ARIAL'  SIZE 9

		@ 200,370 COMBOBOX Cb_CCusto ; 
			 ITEMSOURCE Custos->Descricao ;	
			VALUE nCusto ;
			WIDTH 170  FONT 'ARIAL'  SIZE 9 TOOLTIP "Informe Centro de Custo"

		@ 242,0 FRAME Fr_Frame_4 CAPTION 'Status'  WIDTH 550  HEIGHT 47  FONT 'ARIAL'  SIZE 9

		@ 260,010 LABEL Lb_Data_Cad1  VALUE 'DT Cadastro:'  WIDTH 80 HEIGHT 20 FONT 'ARIAL'  SIZE 9
		@ 260,090 LABEL Lb_Data_Cad2  VALUE '12/05/2003'     WIDTH 70 HEIGHT 20 FONT 'ARIAL'  SIZE 9
 		@ 260,200 LABEL Lb_Ult_Alt1      VALUE 'Últ Alteração:'  WIDTH 80 HEIGHT 20 FONT 'ARIAL'  SIZE 9
		@ 260,280 LABEL Lb_Ult_Alt2      VALUE '12/05/2003'      WIDTH 70 HEIGHT 20 FONT 'ARIAL'  SIZE 9 
		@ 260,380 LABEL Lb_Usuario1     VALUE 'Usuário:' 	  WIDTH 49 HEIGHT 20 FONT 'ARIAL'  SIZE 9 
		@ 260,440 LABEL Lb_Usuario2     VALUE 'HUMBERTO'    WIDTH 90 HEIGHT 20 FONT 'ARIAL'  SIZE 9

		@ 300,10 BUTTON Bt_Salvar ; 
			CAPTION '&Salvar' ; 
			ACTION { || Bt_Salvar_Pagar() } ; 
			WIDTH 100  HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

		@ 300,120 BUTTON Bt_Excluir; 
			CAPTION '&Exclui' ; 
			ACTION { || Bt_Excluir_Pagar(2) } ; 
			WIDTH 100 HEIGHT 30 FONT 'ARIAL'  SIZE 9 FLAT

		@ 300,440 BUTTON CONTROL_39 ; 
			CAPTION 'Ca&ncela' ; 
			ACTION Novo_Pagar.Release  ; 
			WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT	     

	END WINDOW   

	*** Preenche os campos do formulário com os dados do Arquivo de Contas a Pagar
	Pagar_Push()

	*** Altera StatusBar do formulário informando se usuário está fazendo uma inclusão ou Alteração
	Novo_Pagar.StatusBar.Item(1) := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)
	
	*** Calcula Valor do Campo Diferença
	Novo_Pagar.TxtDiferenca.Value	:= Iif( Empty( Form_Pagar.Dp_Data2.Value ) ,  0 , (  Novo_Pagar.TxtvalorPago.Value -  Novo_Pagar.Txtvalor.Value ) )

	*** Desabilita Campo Diferença
	Novo_Pagar.TxtDiferenca.Enabled	:= .F.

	*** Posiciona Cursor/Foco no Campo Cb_Fornecedor (ComboBox Fornecedor)
	Novo_Pagar.Cb_Fornecedor.SetFocus

	*** Se usuário estiver inserindo um novo registro
	If  lNovo

		*** Desabilita Botão excluir
		Novo_Pagar.Bt_Excluir.Enabled := .F.

	EndIf

	*** Centraliza janela
	CENTER	 WINDOW Novo_Pagar

	*** Ativa Janela
	ACTIVATE WINDOW Novo_Pagar

	Return NIL
/*
*/
Function Pesquisa_Pagar()
	Local dData1	:= Form_Pagar.Dp_Data1.Value	
	Local dData2	:= Form_Pagar.Dp_Data2.Value	
	Local lAPagar	:= Form_Pagar.Cb_APagar.Value	
	Local lPagos	:= Form_Pagar.Cb_Pagos.Value
	Local lTudo	:= Form_Pagar.Cb_Tudo.Value
	Local cFornec	:= Recupera_Fornecedor_Selecionado()
	Local cConta	:= Recupera_Conta_Selecionada()
	
	*** Se usuário selecionar Pesquisa de Todos os Registros ou simente os registros À Pagar
	If lTudo .Or. lAPagar		

		*** Posiciona Indice por ordem de Data de Vencimento
		Pagar->(DBSetOrder(2))   

	Else

		*** Posiciona Indice por ordem de Data de Pagamento
		Pagar->(DBSetOrder(3))    

	EndIf

	*** Efetua Seek tomando por base a primeira Data
	*** Utilizando  .T. no comando Seek é a mesma coisa de habilitar o Set SOFTSEEK .T., ou seja posiciona no registro ou no mais próximo
	Pagar->(DBSeek( DTOS( dData1 ) , .T. ) )	

	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_Pagar OF Form_Pagar

	*** Inicio do Laço / While
	Do While ! Pagar->(Eof())		

		*** Se usuário selecionou os registros À PAGAR
		If  lAPagar

			*** Se Data de Vencimento for maior que a Data 2 Selecionada Sai do While
			If   Pagar->DTVEN > dData2  
				EXIT		  
			EndIf

			*** Se a Documento foi Pago , Salta para o próximo registro e volta ao While
			If ! Empty( Pagar->DTPAG )
				Pagar->(DBSkip())
				Loop
			EndIf

		EndIf

		*** Se usuário selecionou os resgistros PAGOS
		If lPagos

			*** Se Data de Pagamento for maior que a Data 2 Selecionada Sai do While
			If  Pagar->DTPAG > dData2  
				EXIT		  
			EndIf

			*** Se a Documento não foi Pago , Salta para o próximo registro e volta ao While
			If Empty( Pagar->DTPAG )
				Pagar->(DBSkip())
				Loop
			EndIf

		EndIf

		*** Se usuário selecionou Todos os resgistros PAGOS e À PAGAR
		If lTudo
		
			*** Se Data de Vencto ou Data de Pagamento estiver fora do Intervalo de Data1  e  Data2, Salta Registro
			If (  Pagar->DtVen < dData1 .And. Pagar->DtVen > dData2 ) .Or.  (  Pagar->DtPag < dData1 .And. Pagar->DtPag > dData2 )

				Pagar->(DBSkip())
				Loop

			EndIf

		EndIf				

		*** Se Usuário não selecionou TODOS os Fornecedores e Fornecedor Lido Não for igual ao selecionado, Salta Registro
		If  cFornec != "000000"  .And.  Pagar->Fornec != cFornec

			Pagar->(DBSkip())
			Loop

		EndIf

		*** Se Usuário não selecionou TODAS as Contas e Conta Lida Não for igual à Conta selecionada, Salta Registro
		If  cConta != "0000"  .And.  Pagar->Conta != cConta

			Pagar->(DBSkip())
			Loop

		EndIf
			
		*** Adiciona Registro no Grid
		ADD ITEM { Pagar->Codigo , DtoC( Pagar->DTVEN ) ,  DTOC( Pagar->DTPAG ) , PGENERIC( "Forneced" , 1 , Pagar->Fornec , "NOME") , TransForm(  Pagar->Valor , "@R 9999,999.99" ) } TO Grid_Pagar OF Form_Pagar
			
		*** Salta Próximo Registro
		Pagar->(DBSkip())

	EndDo

	*** Posiciona o cursor/Foco em Data1
	Form_Pagar.Dp_Data1.SetFocus

	Return Nil
/*
*/
Function Bt_Salvar_Pagar()
	Local nOrd := Pagar->(IndexOrd())	&& Guarda ordem do indice
	Local cCodigo

	*** Se data de Vencimento não foi informada
	If   Empty( Form_Pagar.Dp_Data1.Value )
		MsgInfo("Data de Vencimento não Informada!!" , SISTEMA )
		Novo_Pagar.Dp_Data1.SetFocus
		Return Nil
	EndIf

	*** Se valor do documento for igual à 0 (Zero)
	If  Novo_Pagar.Txtvalor.Value == 0
		MsgInfo("Valor do Documento não Informado!!", SISTEMA )
		Novo_Pagar.TxtValor.SetFocus
		Return Nil
	EndIf
	
	*** Se for um novo Registro
	If lNovo	  
		
		*** verifica se usuário tem permissão para incluir registros no sistema				
		If ! NoInclui( Acesso->Status )
			MsgNo( "INCLUIR")
			Return Nil
		EndIf

		*** Altera status da variável lNovo
		lNovo    := .F.
		
		*** Gera um código / ID para o Novo Documento
		cCodigo  := GeraCodigo( "Pagar"  , 1 , 10 )
		
		*** Cria um novo registro
		Pagar->(DBAppend())
	
		** Grava o Codigo / ID e data de Cadastro		
		Pagar->Codigo	     := cCodigo
		Pagar->DtCad := Date()		

		*** Grava outros dados no arquivo
		Pagar_Flush()

		*** Verifica se dados foram gravados corretamente
		GravouCodigoCorretamente( "Pagar" , cCodigo , 1 )

		*** Envia mensagem para usuário
		PlayExclamation()
		MSGExclamation("Inclusão Efetivada no "+cTitulo,SISTEMA)

		*** Release Form
		Novo_Pagar.Release		

	Else	         

		*** Alterando/Editando Registro

		*** Verifica se usuário tem permissão para Alterar registros
		If ! NoAltera( Acesso->Status )
			MsgNo( "ALTERAR")
			Return Nil
		EndIf

		*** Posiciona arquivo na ordem de Codigo
		Pagar->(DBSetOrder(1))

		*** Se Codigo não foi encontrado - Ocorreu erro		
		If ! Pagar->(DBSeek(CodigoAlt))

			PlayExclamation()
			MsgExclamation("ERRO-G01 # Código não Localizado para Alteração!!",SISTEMA)

		Else

			*** Bloqueia Registro na Rede
			If BloqueiaRegistroNaRede( "Pagar" )

				*** Atualiza Dados no Arquivo
				Pagar_Flush()

				*** Libera registro na Rde
				Pagar->(DBUnlock())

				*** Envia mensagem para Usuário
				MsgINFO("Registro Alterado!!",SISTEMA)

				*** Release Form
				Novo_Pagar.Release
				
			EndIf

		 EndIf

	EndIf

	*** Posiciona Area/Alias no Indice Anterior
	Pagar->(DBSetOrder( nOrd ))

	*** Refresh Grid		
	Pesquisa_Pagar()

	Return Nil

/*
*/
Function Pagar_Push()

	*** Se for um Novo Registro
	If  lNovo

		Pagar->(DBGoBottom())
		Pagar->(DBSkip())
	
	EndIf					

	*** Atualiza dados no Formulário
	Novo_Pagar.Lb_Codigo.Value	:= AllTrim(Pagar->Codigo)
	Novo_Pagar.TxtHistorico.Value	:= AllTrim(Pagar->Hist)
	Novo_Pagar.TxtDocumento.Value	:= AllTrim(Pagar->Docto)	
	Novo_Pagar.Dp_Vencto.Value	:= Pagar->DtVen
	Novo_Pagar.Dp_Pagto.Value		:= Pagar->DtPag
	Novo_Pagar.TxtValor.Value		:= Pagar->Valor
	Novo_Pagar.TxtValorPago.Value	:= Pagar->ValorP
	//Status-Labels
	Novo_Pagar.Lb_Data_Cad2.Value	:= DtoC(Pagar->DtCad)
	Novo_Pagar.Lb_Ult_Alt2.Value	:= DtoC(Pagar->DtAlt)
	Novo_Pagar.Lb_Usuario2.Value	:= PGeneric("ACESSO",1,Pagar->Usuario,"APELIDO")

	Return Nil
/*
*/
Function Pagar_Flush()

	*** Posicona tabelas: Fornecedores, Contas, Grupos e Custos no registro informado no ComboBox
	Forneced->(DBGoTo(Novo_Pagar.Cb_Fornecedor.Value ))
	Contas->(DBGoTo(Novo_Pagar.Cb_Conta.Value ))
	Grupos->(DBGoTo(Novo_Pagar.Cb_Grupo.Value ))
	Custos->(DBGoTo(Novo_Pagar.Cb_CCusto.Value ))
	
	*** Atualiza Arquivo com Dados do Formulário		
	Pagar->Fornec	     := Forneced->Codigo
	Pagar->Hist 	     := Novo_Pagar.TxtHistorico.Value
	Pagar->Docto	     := Novo_Pagar.TxtDocumento.Value
	Pagar->Tipo	     := Iif( Empty(  Novo_Pagar.Dp_Pagto.Value ) , "0" , "1" )
	Pagar->Conta	     := Contas->Codigo
	Pagar->Grupo	     := Grupos->Codigo
	Pagar->CCusto	     := Custos->Codigo
	Pagar->DtVen	     :=  Novo_Pagar.Dp_Vencto.Value
	Pagar->Dtpag 	     :=  Novo_Pagar.Dp_Pagto.Value 
	Pagar->Valor	     :=  Novo_Pagar.TxtValor.Value
	Pagar->ValorP	     :=  Novo_Pagar.TxtValorPago.Value
	Pagar->DtAlt	     := Date()
	Pagar->Usuario	     := Acesso->Codigo

	Return Nil

/*
	Esta função recebe o Parâmetro nGrid -  1 Se a exclusão foi solicitada do Grid   e  2 se
	exclusão foi solicitada pressionando o Botão excluir no formulario de cadastro
	
	nReg		= Recebe o Código / ID do Registro utilizando a Função PegaValorDaColuna() 
*/
Function Bt_Excluir_Pagar( nGrid )
	Local nOrd	   := Pagar->(IndexOrd())
	Local nReg	   := PegaValorDaColuna( "Grid_Pagar" , "Form_Pagar" ,  1  )
	
	*** Verifica se usuário tem permissão para excluir registros
	If ! NoExclui( Acesso->Status )
		MsgNo( "EXCLUIR")
		Return Nil
	EndIf

	 nReg := Iif( nGrid == 1 , nReg ,  Novo_Pagar.Lb_Codigo.Value )
	
	If Empty(nReg)

		MsgExclamation("Nenhum Registro Informado para Exclusão!!",SISTEMA)
		Return Nil
	Else

		Pagar->(DBSetOrder(1))
		If ! Pagar->(DBSeek(nReg))
			MsgINFO("Erro de Pesquisa!!")
			Return Nil
		EndIf

		If MsgYesNo("Excluir Registro do Sistema ??",SISTEMA)
			If BloqueiaRegistroNaRede( "Pagar" )
				Pagar->(DBDelete())
				Pagar->(DBUnlock())
				If nGrid != 1
					Novo_Pagar.Release
				EndIf
				
			 EndIf
		EndIf
	 EndIf

	Pagar->(DBSetOrder( nOrd ))
	 Pesquisa_Pagar()

	 Return Nil

/*
*/
Function EncheArray( aFornecedores , aContas )
	aFornecedores	:= {}
	aContas		:= {}

	*** Pociciona Arquivo na Ordem 2 (Nomes)
	Forneced->(DBSetOrder(2))

	*** Posiciona no inicio do arquivo
	Forneced->(DBGoTop())

	*** Adciona um registro "TODOS"  caso o Usuário queira escolher todos os Fornecedores
	Aadd( aFornecedores ,  "TODOS" )
 
	Do While ! Forneced->(Eof())

		*** Adiciona Nomes dos fornecedores na Array
		Aadd( aFornecedores ,  Forneced->Nome   )
		Forneced->(DBSkip())

	EndDo

	*** Pociciona Arquivo na Ordem 2 (Descricao da Conta)
	Contas->(DBSetOrder(2))

	*** Posiciona no inicio do arquivo
	Contas->(DBGoTop())

	*** Adciona um registro "TODAS"  caso o Usuário queira escolher todas as Contas
	Aadd( aContas , "TODAS"  )

	Do While ! Contas->(Eof())

		*** Adiciona Descrição das Contas na Array
		Aadd( aContas ,  Contas->Descricao )
		Contas->(DBSkip())

	EndDo

	 Return Nil
/*
*/
Function Recupera_Fornecedor_Selecionado()
	Local cRet := "000000"
	**** Variável de Retorno (cRet) receb valor default ( Codigo "000000" )

	*** Se ComboBox Fornecedores for igual 1 , o usuário selecionou todos os fornecedores
	If Form_Pagar.Cb_Fornecedor.Value != 1  
		*** Posicina no inicio do arquivo
		Forneced->(DBGoTop())
		*** Posiciona no registro 
		Forneced->(DBSkip( Form_Pagar.Cb_Fornecedor.Value - 2 ) )
		*** Musa valor da variavel cRet para o Codigo do Fornecedor
		cRet := Forneced->Codigo		
	EndIf	   
	Return cRet
/*
*/
Function Recupera_Conta_Selecionada()
	Local cRet := "0000"	
	If Form_Pagar.Cb_Contas.Value != 1   && Se for igual a 1 , selecionou "TODAS" as Contas
		Contas->(DBGoTop())
		Contas->(DBSkip( Form_Pagar.Cb_Contas.Value - 2 ) )
		cRet := Contas->Codigo
	EndIf	   
	Return cRet

/*
*/
Function Bt_Sair_Pagar()
	*** Fecha todas as áreas/Alias
	Pagar->(DBCloseArea())
	Forneced->(DBCloseArea())
	Contas->(DBCloseArea())
	Grupos->(DBCloseArea())
	Custos->(DBCloseArea())

	*** Release Form
	Form_Pagar.Release
	Return Nil
/*
*/
Function PagarOpen( LPack  )	
	Local nArea	:= Select( 'Pagar' )
	Local cBase	:= BaseDeDados()	
	Local ArqBase	:= cBase+"Pagar.DBF"
	Local aarq	:= {}
                 
	FornecedOpen(.F.)
	Forneced->(DBSetOrder(1))

	Form_0.StatusBar.Item(1) := "Abrindo Contas à Pagar"

	 If nArea == 0    && Se arquivo não está em uso

		If ! File( (ArqBase) )	&& Se Arquivo não exite, cria
			Aadd( aarq , { 'CODIGO'	, 'C' , 10 , 0 } )
			Aadd( aarq , { 'FORNEC'	, 'C' , 06 , 0 } )
			Aadd( aarq , { 'HIST'	, 'C' , 50 , 0 } )
			Aadd( aarq , { 'DOCTO'	, 'C' , 12 , 0 } )
			Aadd( aarq , { 'TIPO'	, 'C' , 01 , 0 } )
			Aadd( aarq , { 'CONTA'	, 'C' , 04 , 0 } )
			Aadd( aarq , { 'GRUPO'	, 'C' , 04 , 0 } )
			Aadd( aarq , { 'CCUSTO'	, 'C' , 04 , 0 } )			
			Aadd( aarq , { 'DTVEN'	, 'D' , 08 , 0 } )
			Aadd( aarq , { 'DTPAG'	, 'D' , 08 , 0 } )
			Aadd( aarq , { 'VALOR'	, 'N' , 12 , 2 } )
			Aadd( aarq , { 'VALORP'	, 'N' , 12 , 2 } )
			Aadd( aarq , { 'DTCAD'	, 'D' , 08 , 0 } )
			Aadd( aarq , { 'DTALT'	, 'D' , 08 , 0 } )
			Aadd( aarq , { 'USUARIO'	, 'C' , 04 , 0 } )
			DBCreate     ( (ArqBase)     , aarq, DRIVER   )
		EndIf

		PacKArquivo( ArqBase , LPack  )

		Use (ArqBase) Alias Pagar New Shared Via DRIVER  

		If ! File(cBase+'Pagar1.ntx')
			LinhaDeStatus("Index Pagar por Codigo - Pagar1.ntx")  
			Index On CODIGO to (cBase)+'Pagar1'
		EndIf

		If ! File(cBase+'Pagar2.ntx')
			LinhaDeStatus("Index Pagar por DTOS( DTVEN )+Forneced - Pagar2.ntx")
			Index On DTOS( DTVEN ) + NomeDoFornecedor(FORNEC) To (cBase)+'Pagar2'
		EndIf

		If ! File(cBase+'Pagar3.ntx')			
			LinhaDeStatus("Index Pagar por DTOS( DTPAG )+Forneced - Pagar3.ntx")
			Index On DTOS( DTPAG ) + NomeDoFornecedor(FORNEC) To (cBase)+'Pagar3'		
		EndIf
		
	EndIf

	Pagar->(DBCLearIndex())
	Pagar->(DBSetIndex(cBase+'Pagar1'))
	Pagar->(DBSetIndex(cBase+'Pagar2'))
	Pagar->(DBSetIndex(cBase+'Pagar3'))
	
	LinhaDeStatus()

	Return nArea
/*
	*** Recebe o codigo do fornecedor gravado em Contas a pagar
	*** faz pesquisa no arquivo de fornecedores
	*** Retorna o Nome do Fornecedor
*/
Function NomeDoFornecedor( cCod )
	Local cRet := Space(15)
	Forneced->(DBSeek( cCod ))
	Return( Substr(Forneced->Nome,1,15))