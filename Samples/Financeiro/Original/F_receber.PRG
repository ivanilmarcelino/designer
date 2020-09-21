#include "minigui.ch"
#Include "F_sistema.ch"
*---------------------------------------------------------------------------------------------------*
* Procedure ContasReceber | Cadastro Contas à Receber		      *
*---------------------------------------------------------------------------------------------------*
Procedure ContasReceber()
	Local aClientes := {}
	Local aContas	    := {}

	Private CodigoAlt	:= 0
	Private cTitulo := "Arquivo de Contas à Receber"
	Private lNovo	:= .F. 		  
	
	ClientesOpen(.F.)
	ReceberOpen(.F.)
	GenericOpen( "Contas" )
	GenericOpen( "Grupos" )
	GenericOpen( "Custos" )

	Receber->(DBSetOrder(1))
	Clientes->(DBSetOrder(2))
	Contas->(DBSetOrder(2))
	Grupos->(DBSetOrder(2))
	Custos->(DBSetOrder(2))	

	EncheGridReceber( @aClientes , @aContas)

	DEFINE WINDOW Form_Receber		  ;
		AT 0,0			;
		WIDTH 560 HEIGHT 450	;
		TITLE "Contas à Receber"  ;
		ICON 'ICONE01'		;
		CHILD			;
		NOSIZE		

		@010,005 GRID Grid_Receber ;
			  WIDTH 540 ; 
			  HEIGHT 220 ; 
			  HEADERS { "Código","DT Vencto", "DT Pagto" , "Cliente" , "Valor"} ;
			  WIDTHS { 80, 80 , 80 , 220 , 80  } ; 
			  FONT 'ARIAL'  SIZE 9;
			  ON DBLCLICK { || Bt_Novo_Receber(2) } ;
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

			@260,310 CHECKBOX Cb_AReceber ;
				  CAPTION 'À Receber' ;
				  WIDTH 62 HEIGHT 25 VALUE FALSE FONT 'ARIAL'  SIZE 8;
				  ON CHANGE {|| Iif ( Form_Receber.Cb_AReceber.Value ,	Form_Receber.Cb_Pagos.Value := .F. ,  Form_Receber.Cb_AReceber.Value := .F. ) ,  Iif ( Form_Receber.Cb_AReceber.Value ,  Form_Receber.Cb_Tudo.Value := .F. ,  Form_Receber.Cb_AReceber.Value := .F. ) }

			@260,400 CHECKBOX Cb_Pagos ; 
				CAPTION 'Pagos' ; 
				WIDTH 70 HEIGHT 25 VALUE FALSE FONT 'ARIAL'  SIZE 8 ;
				ON CHANGE {|| Iif ( Form_Receber.Cb_Pagos.Value ,  Form_Receber.Cb_AReceber.Value := .F. ,  Form_Receber.Cb_Pagos.Value := .F. ) ,  Iif ( Form_Receber.Cb_Pagos.Value ,  Form_Receber.Cb_Tudo.Value := .F. ,  Form_Receber.Cb_Pagos.Value := .F. ) }

			@260,490 CHECKBOX Cb_Tudo ; 
				 CAPTION 'Tudo' ;
				 WIDTH 50  HEIGHT 25 VALUE FALSE FONT 'ARIAL'  SIZE 8
				 ON CHANGE {|| Iif ( Form_Receber.Cb_Tudo.Value ,  Form_Receber.Cb_AReceber.Value := .F. ,  Form_Receber.Cb_Tudo.Value := .F. ) ,  Iif ( Form_Receber.Cb_Tudo.Value ,  Form_Receber.Cb_Pagos.Value := .F. ,  Form_Receber.Cb_Tudo.Value := .F. ) }
				
			@360,000 FRAME Fr_Opcoes ; 
				  CAPTION 'Opções' ; 
				  WIDTH 550 HEIGHT 60 FONT 'ARIAL'  SIZE 9

			@ 300,0 FRAME Fr_Cliente ;
				CAPTION 'Cliente' ;
				WIDTH 250 HEIGHT 56 FONT 'ARIAL' SIZE 9

			@ 320,10 COMBOBOX Cb_Cliente ;
				 ITEMS aClientes ;
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
				ACTION { || Pesquisa_Receber() } ;
				WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

			@ 380,140 BUTTON Bt_Novo ;
				CAPTION '&Novo' ; 
				ACTION { ||  Bt_Novo_Receber(1) } ;
				WIDTH 100 HEIGHT 30 FONT 'ARIAL'  SIZE 9 FLAT

			@ 380,240 BUTTON Bt_Editar ;
				CAPTION '&Editar' ; 
				ACTION { || Bt_Novo_Receber(2) } ;
				WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

			@ 380,340 BUTTON Bt_Excluir ; 
				CAPTION 'E&xcluir' ; 
				ACTION { ||  Bt_Excluir_Receber(1) } ;
				WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

			@ 380,440 BUTTON CONTROL_8 ;
				CAPTION '&Sair' ; 
				ACTION { || Bt_Sair_Receber() } ;
				WIDTH 100  HEIGHT 30 FONT 'ARIAL'  SIZE 9 FLAT


	END WINDOW
	
	Form_Receber.Cb_AReceber.Value := .T.
	Form_Receber.Dp_Data1.SetFocus

	Pesquisa_Receber()

	CENTER	 WINDOW Form_Receber
	ACTIVATE WINDOW Form_Receber

	Return Nil

/*
*/
Function Bt_Novo_Receber(nTipo)
	 Local nColuna	:= 1
	 Local nReg	:= PegaValorDaColuna( "Grid_Receber" , "Form_Receber" , nColuna )
	 Local nCliente := 1
	 Local nConta	:= 1
	 Local nGrupo	:= 1
	 Local nCusto	:= 1

	 lNovo		    := Iif(nTipo==1,.T.,.F.)
	
	 If nTipo == 2			&& Editar/Alterar

		If Empty(nReg)
			MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
			Return Nil
		Else			&& Incluir Novo
			Receber->(DBSetOrder(1))
			If ! Receber->(DBSeek(nReg))
				MsgSTOP("Erro de Pesquisa em Receber.DBF!!")
				Return NIl	   
			EndIf
			CodigoAlt := Receber->Codigo
		EndIf

		Clientes->(DBSetOrder(1))
		Clientes->(DBSeek( Receber->Cliente ) )
		nCliente := Clientes->(Recno())
		Clientes->(DBSetOrder(2))

		Contas->(DBSetOrder(1))
		Contas->(DBSeek( Receber->Conta ) )
		nConta := Contas->(Recno())
		Contas->(DBSetOrder(2))		

		Grupos->(DBSetOrder(1))
		Grupos->(DBSeek( Receber->Grupo ) )
		nGrupo := Grupos->(Recno())
		Grupos->(DBSetOrder(2))

		Custos->(DBSetOrder(1))
		Custos->(DBSeek( Receber->CCusto ) )
		nCusto := Custos->(Recno())
		Custos->(DBSetOrder(2))

	Else

		Clientes->(DBSetOrder(2))
		Clientes->(DBGoTop())
		nCliente := Clientes->(Recno())

		Contas->(DBSetOrder(2))
		Contas->(DBGoTop())
		nConta := Contas->(Recno())

		Grupos->(DBSetOrder(2))
		Grupos->(DBGoTop())
		nGrupo := Grupos->(Recno())

		Custos->(DBSetOrder(2))
		Custos->(DBGoTop())
                nCusto := Custos->(Recno())

	EndIf

	DEFINE WINDOW Novo_Receber	  ;
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

		@ 20,170 LABEL Lb_Cliente ;
			 VALUE 'Cliente'  WIDTH 66 HEIGHT 20 FONT 'ARIAL' SIZE 9

		@ 20,240 COMBOBOX Cb_Cliente;
			ITEMSOURCE Clientes->Nome ;
			VALUE nCliente ;
			WIDTH 300 FONT 'ARIAL' SIZE 9 TOOLTIP "Informe Cliente"

		@ 60,0 FRAME Fr_Frame_2  WIDTH 550 HEIGHT 110 FONT 'ARIAL'  SIZE 9

		@ 70,10 LABEL Lb_Historico ; 
			VALUE 'Histórico' ; 
			WIDTH 60 HEIGHT 20 FONT 'ARIAL'  SIZE 9

		@ 70,80 TEXTBOX TxtHistorico; 
			HEIGHT 20 WIDTH 460 FONT 'ARIAL'  SIZE 9 ;
			TOOLTIP "Digite o Histórico desre Lançamento"   ;
			 MAXLENGTH 50 UPPERCASE		 ;
			ON ENTER Novo_Receber.TxtDocumento.SetFocus

		@ 100,10 LABEL Lb_Documento ; 
			VALUE 'Documento' ; 
			WIDTH 65 HEIGHT 20 FONT 'ARIAL'  SIZE 9 

		@ 100,80 TEXTBOX TxtDocumento ; 
			HEIGHT 20  WIDTH 100 ; 
			FONT 'ARIAL'  SIZE 9 ;
			TOOLTIP "Digite o Número do Documento"   ;
			 MAXLENGTH 12 UPPERCASE		 ;
			ON ENTER Novo_Receber.Dp_Vencto.SetFocus

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
			ACTION { || Bt_Salvar_Receber() } ;
			WIDTH 100  HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT

		@ 300,120 BUTTON Bt_Excluir; 
			CAPTION '&Exclui' ; 
			ACTION { || Bt_Excluir_Receber(2) } ;
			WIDTH 100 HEIGHT 30 FONT 'ARIAL'  SIZE 9 FLAT

		@ 300,440 BUTTON CONTROL_39 ; 
			CAPTION 'Ca&ncela' ; 
			ACTION Novo_Receber.Release  ;
			WIDTH 100 HEIGHT 30 FONT 'ARIAL' SIZE 9 FLAT	     

	END WINDOW   

	Receber_Push()

	Novo_Receber.StatusBar.Item(1) := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)
	
	Novo_Receber.TxtDiferenca.Value   := Iif( Empty( Form_Receber.Dp_Data2.Value ) ,  0 , (  Novo_Receber.TxtvalorPago.Value -  Novo_Receber.Txtvalor.Value ) )
	Novo_Receber.TxtDiferenca.Enabled := .F.
	Novo_Receber.Cb_Cliente.SetFocus

	If  lNovo

		Novo_Receber.Bt_Excluir.Enabled := .F.

	EndIf

	CENTER	 WINDOW Novo_Receber
	ACTIVATE WINDOW Novo_Receber

	lNovo := .F.

	Return NIL
/*
*/
Function Pesquisa_Receber()
	Local dData1	:= Form_Receber.Dp_Data1.Value
	Local dData2	:= Form_Receber.Dp_Data2.Value
	Local lAReceber   := Form_Receber.Cb_AReceber.Value
	Local lPagos	:= Form_Receber.Cb_Pagos.Value
	Local lTudo	:= Form_Receber.Cb_Tudo.Value
	Local cCliente	:= Recupera_Cliente_Selecionado()
	Local cConta	:= Recupera_Conta_Selecionada_R()
	
	If lTudo .Or. lAReceber
		Receber->(DBSetOrder(2))    && Por Ordem de Data de Vencimento
	Else
		Receber->(DBSetOrder(3))    && Por Ordem de Data de Recebimento
	EndIf

	Receber->(DBSeek( DTOS( dData1 ) , .T. ) )

	DELETE ITEM ALL FROM Grid_Receber OF Form_Receber

	Do While ! Receber->(Eof())

		If  lAReceber

			If   Receber->DTVEN > dData2
				EXIT		  
			EndIf

			If ! Empty( Receber->DTPAG )
				Receber->(DBSkip())
				Loop
			EndIf

		EndIf

		If lPagos

			If  Receber->DTPAG > dData2
				EXIT		  
			EndIf

			If Empty( Receber->DTPAG )
				Receber->(DBSkip())
				Loop
			EndIf

		EndIf

		If lTudo
		
			If (  Receber->DtVen < dData1 .And. Receber->DtVen > dData2 ) .Or. ;
			   (  Receber->DtPag < dData1 .And. Receber->DtPag > dData2 )

				Receber->(DBSkip())
				Loop

			EndIf

		EndIf				

		If  cCliente != "000000"  .And.  Receber->Cliente != cCliente

			Receber->(DBSkip())
			Loop

		EndIf

		If  cConta != "0000"  .And.  Receber->Conta != cConta

			Receber->(DBSkip())
			Loop

		EndIf

		ADD ITEM { Receber->Codigo , DtoC( Receber->DTVEN ) ,  DTOC( Receber->DTPAG ) , PGENERIC( "Clientes" , 1 , Receber->Cliente , "NOME") , TransForm(  Receber->Valor , "@R 9999,999.99" ) } TO Grid_Receber OF Form_Receber

		Receber->(DBSkip())

	EndDo

	Form_Receber.Dp_Data1.SetFocus

	Return Nil
/*
*/
Function Bt_Salvar_Receber()
	Local nOrd := Receber->(IndexOrd())
	Local cCodigo

	If   Empty( Form_Receber.Dp_Data1.Value )
		MsgInfo("Data de Vencimento não Informada!!" , SISTEMA )
		Novo_Receber.Dp_Data1.SetFocus
		Return Nil
	EndIf

	If  Novo_Receber.Txtvalor.Value == 0
		MsgInfo("Valor do Documento não Informado!!", SISTEMA )
		Novo_Receber.TxtValor.SetFocus
		Return Nil
	EndIf
	
	If lNovo	  
		      If ! NoInclui( Acesso->Status )
			MsgNo( "INCLUIR")
			Return Nil
		EndIf
		lNovo    := .F.
		cCodigo  := GeraCodigo( "Receber"  , 1 , 10 )
		Receber->(DBAppend())
		Receber->Codigo        := cCodigo
		Receber->DtCad := Date()
		Receber_Flush()
		GravouCodigoCorretamente( "Receber" , cCodigo , 1 )
		PlayExclamation()
		MSGExclamation("Inclusão Efetivada no "+cTitulo,SISTEMA)
		Novo_Receber.Release
	Else	         
		If ! NoAltera( Acesso->Status )
			MsgNo( "ALTERAR")
			Return Nil
		EndIf
		Receber->(DBSetOrder(1))
		If ! Receber->(DBSeek(CodigoAlt))
			PlayExclamation()
			MsgExclamation("ERRO-G01 # Código não Localizado para Alteração!!",SISTEMA)
		Else
			If BloqueiaRegistroNaRede( "Receber" )
				Receber_Flush()
				Receber->(DBUnlock())
				MsgINFO("Registro Alterado!!",SISTEMA)
				Novo_Receber.Release
				
			EndIf
		 EndIf
	EndIf

	Receber->(DBSetOrder( nOrd ))
	Pesquisa_Receber()

	Return Nil

/*
*/
Function Receber_Push()

	If  lNovo

		Receber->(DBGoBottom())
		Receber->(DBSkip())
	
	EndIf					

	Novo_Receber.Lb_Codigo.Value		  := AllTrim(Receber->Codigo)
	Novo_Receber.TxtHistorico.Value   := AllTrim(Receber->Hist)
	Novo_Receber.TxtDocumento.Value   := AllTrim(Receber->Docto)
	Novo_Receber.Dp_Vencto.Value	  := Receber->DtVen
	Novo_Receber.Dp_Pagto.Value		  := Receber->DtPag
	Novo_Receber.TxtValor.Value		  := Receber->Valor
	Novo_Receber.TxtValorPago.Value   := Receber->ValorP
	//Status-Labels
	Novo_Receber.Lb_Data_Cad2.Value   := DtoC(Receber->DtCad)
	Novo_Receber.Lb_Ult_Alt2.Value	  := DtoC(Receber->DtAlt)
	Novo_Receber.Lb_Usuario2.Value	  := PGeneric("ACESSO",1,Receber->Usuario,"APELIDO")

	Return Nil
/*
*/
Function Receber_Flush()

	Clientes->(DBGoTo(Novo_Receber.Cb_Cliente.Value ))
	Contas->(DBGoTo(Novo_Receber.Cb_Conta.Value ))
	Grupos->(DBGoTo(Novo_Receber.Cb_Grupo.Value ))
	Custos->(DBGoTo(Novo_Receber.Cb_CCusto.Value ))
	
	Receber->Cliente       := Clientes->Codigo
	Receber->Hist	       := Novo_Receber.TxtHistorico.Value
	Receber->Docto	       := Novo_Receber.TxtDocumento.Value
	Receber->Tipo	       := Iif( Empty(  Novo_Receber.Dp_Pagto.Value ) , "0" , "1" )
	Receber->Conta	       := Contas->Codigo
	Receber->Grupo	       := Grupos->Codigo
	Receber->CCusto        := Custos->Codigo
	Receber->DtVen	       :=  Novo_Receber.Dp_Vencto.Value
	Receber->Dtpag	       :=  Novo_Receber.Dp_Pagto.Value
	Receber->Valor	       :=  Novo_Receber.TxtValor.Value
	Receber->ValorP        :=  Novo_Receber.TxtValorPago.Value
	Receber->DtAlt	       := Date()
	Receber->Usuario       := Acesso->Codigo

	Return Nil

/*
*/
Function Bt_Excluir_Receber( nGrid )
	 Local nOrd	   := Receber->(IndexOrd())
	 Local nReg	   := PegaValorDaColuna( "Grid_Receber" , "Form_Receber" ,  1  )
	
	If ! NoExclui( Acesso->Status )
		MsgNo( "EXCLUIR")
		Return Nil
	EndIf

	 nReg := Iif( nGrid == 1 , nReg ,  Novo_Receber.Lb_Codigo.Value )

	 If Empty(nReg)
		MsgExclamation("Nenhum Registro Informado para Exclusão!!",SISTEMA)
		Return Nil
	Else
		Receber->(DBSetOrder(1))
		If ! Receber->(DBSeek(nReg))
			MsgINFO("Erro de Pesquisa!!")
			Return Nil
		EndIf
		If MsgYesNo("Exclui Registro do Sistema??",SISTEMA)
			If BloqueiaRegistroNaRede( "Receber" )
				Receber->(DBDelete())
				Receber->(DBUnlock())
				If nGrid != 1
					Novo_Receber.Release
				EndIf
				
			 EndIf
		EndIf
	 EndIf

	Receber->(DBSetOrder( nOrd ))
	 Pesquisa_Receber()

	 Return Nil

/*
*/
Function EncheGridReceber( aClientes , aContas )
	aClientes   := {}
	aContas		:= {}

	Clientes->(DBSetOrder(2))
	Clientes->(DBGoTop())
	Aadd( aClientes ,  "TODOS" )  && Insere um registro em branco caso o Usuário queria escolher todos os Clientes
	Do While ! Clientes->(Eof())
	      Aadd( aClientes ,  Clientes->Nome   )
	      Clientes->(DBSkip())
	EndDo

	Contas->(DBSetOrder(2))
	Contas->(DBGoTop())
	Aadd( aContas , "TODAS"  )  && Insere um registro em branco caso o Usuário queria escolher todas as Contas
	Do While ! Contas->(Eof())
	      Aadd( aContas ,  Contas->Descricao )
	      Contas->(DBSkip())
	EndDo

	 Return Nil
/*
*/
Function Recupera_Cliente_Selecionado()
	Local cRet := "000000"
	If Form_Receber.Cb_Cliente.Value != 1	&& Se for igual a 1 , selecionou "TODOS" os Clientes
		Clientes->(DBGoTop())
		Clientes->(DBSkip( Form_Receber.Cb_Cliente.Value - 2 ) )
		cRet := Clientes->Codigo
	EndIf	   
	Return cRet
/*
*/
Function Recupera_Conta_Selecionada_R()
	Local cRet := "0000"	
	If Form_Receber.Cb_Contas.Value != 1   && Se for igual a 1 , selecionou "TODAS" as Contas
		Contas->(DBGoTop())
		Contas->(DBSkip( Form_Receber.Cb_Contas.Value - 2 ) )
		cRet := Contas->Codigo
	EndIf	   
	Return cRet
/*
*/
Function Bt_Sair_Receber()
	Receber->(DBCloseArea())
	Clientes->(DBCloseArea())
	Contas->(DBCloseArea())
	Grupos->(DBCloseArea())
	Custos->(DBCloseArea())
	Form_Receber.Release
	Return Nil
/*
*/
Function ReceberOpen( LPack  )
	Local nArea	:= Select( 'Receber' )
	Local cBase	:= BaseDeDados()	
	Local ArqBase	:= cBase+"Receber.DBF"
	Local aarq	:= {}
                 
	ClientesOpen(.F.)
	Clientes->(DBSetOrder(1))

	Form_0.StatusBar.Item(1) := "Abrindo Contas à Receber"

	 If nArea == 0    && Se arquivo não está em uso

		If ! File( (ArqBase) )	&& Se Arquivo não exite, cria
			Aadd( aarq , { 'CODIGO'	, 'C' , 10 , 0 } )
			Aadd( aarq , { 'CLIENTE', 'C' , 06 , 0 } )
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

		Use (ArqBase) Alias Receber New Shared Via DRIVER

		If ! File(cBase+'Receber1.ntx')
			LinhaDeStatus("Index Receber por Codigo - Receber1.ntx")
			Index On CODIGO to (cBase)+'Receber1'
		EndIf

		If ! File(cBase+'Receber2.ntx')
			LinhaDeStatus("Index Receber por DTOS( DTVEN )+Cliente - Receber2.ntx")
			Index On DTOS( DTVEN ) + NomeDoCliente(CLIENTE) To (cBase)+'Receber2'
		EndIf

		If ! File(cBase+'Receber3.ntx')
			LinhaDeStatus("Index Receber por DTOS( DTPAG )+Cliente - Receber3.ntx")
			Index On DTOS( DTPAG ) + NomeDoCliente(CLIENTE) To (cBase)+'Receber3'
		EndIf
		
	EndIf

	Receber->(DBCLearIndex())
	Receber->(DBSetIndex(cBase+'Receber1'))
	Receber->(DBSetIndex(cBase+'Receber2'))
	Receber->(DBSetIndex(cBase+'Receber3'))
	
	LinhaDeStatus()

	Return nArea
/*
*/
Function NomeDoCliente( cCod )
	Local cRet := Space(15)
	Clientes->(DBSeek( cCod ))
	Return( Substr(Clientes->Nome,1,15))
