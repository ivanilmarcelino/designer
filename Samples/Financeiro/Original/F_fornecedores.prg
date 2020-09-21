#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
/*
*/
*---------------------------------------------------------------------------------------------------*
* Procedure Forneced | Cadastro dos Fornecedores		      *
*---------------------------------------------------------------------------------------------------*
Procedure Fornecedores()

	Private CodigoAlt	:= 0
	Private cTitulo	 := "Cadastro de Fornecedores"
	Private lNovo	:= .F. 
	Private lJuridica	:= .F.
		  
	FornecedOpen()
	Forneced->(DBSetOrder(2))

	  DEFINE WINDOW Form_Forneced	;
		 AT 05,05		; 
		 WIDTH	425		;
		 HEIGHT 460		;
		 TITLE "Cadastro de Fornecedores";
		 ICON 'ICONE01'		;
		 CHILD			;
		 NOSIZE		

		 @ 010,010 GRID Grid_Forneced;
		   WIDTH  400          ;
		   HEIGHT 329          ;
		   HEADERS {"Código","Nome"};
		   WIDTHS  {60,350}    ;
		   VALUE 1             ;
		   FONT "Arial" SIZE 09;
		   ON DBLCLICK { || Bt_Novo_Forneced(2) }

		   @ 357,011 LABEL  Label_Pesquisa	 ;
		     VALUE "Pesquisa "                   ;
		     WIDTH 70				 ;
		     HEIGHT 20				 ;
		     FONT "Arial" SIZE 09

		   @ 353,085 TEXTBOX TxtPesquisa	 ;
		     WIDTH 326				 ;
		     TOOLTIP "Digite o Nome para Pesquisa"   ;
		     MAXLENGTH 40 UPPERCASE		 ;
		     ON ENTER { || Pesquisa_Forneced() }

		   @ 397,011 BUTTON Novo_Forneced      ;
			     CAPTION '&Novo'                ;
			     ACTION { || Bt_Novo_Forneced(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,111 BUTTON Editar_Forneced	  ;
			     CAPTION '&Editar'           ;
			     ACTION { || Bt_Novo_Forneced(2)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,211 BUTTON Excluir_Forneced	 ;
			     CAPTION 'E&xcluir'          ;
			     ACTION { || Bt_Excluir_Forneced(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,311 BUTTON Bt_Sair_Forneced	       ;
			     CAPTION '&Sair'                ;
			     ACTION { || Bt_Sair_Forneced() };
			     FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW
	
	Form_Forneced.TxtPesquisa.SetFocus
	Renova_Pesquisa_Forneced(" ")

	CENTER	 WINDOW Form_Forneced
	ACTIVATE WINDOW Form_Forneced

	Return Nil

/*
*/
Function Bt_Novo_Forneced(nTipo)
	 Local nColuna	    := 1
	 Local nReg	    := PegaValorDaColuna( "Grid_Forneced" , "Form_Forneced" , nColuna )

	 lNovo		    := Iif(nTipo==1,.T.,.F.)
	 lJuridica		    := .F.

	 If nTipo == 2			&& Editar/Alterar

		If Empty(nReg)
			MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
			Return Nil
		Else			&& Incluir Novo
			Forneced->(DBSetOrder(1))
			If ! Forneced->(DBSeek(nReg))
				MsgSTOP("Erro de Pesquisa em Forneced.DBF!!")
				Return NIl	   
			EndIf
			CodigoAlt := Forneced->Codigo
			lJuridica	 := Forneced->Juridica
		EndIf
	EndIf

	DEFINE WINDOW Novo_Forneced	 ;
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
			TOOLTIP "Digite o CGC ou CPF do Fornecedor";
			MAXLENGTH 20 ;
			ON LOSTFOCUS CriaMascara_Fornec();
			ON ENTER Novo_Forneced.TxtNOME.SetFocus
  
		@ 60,10 LABEL Lb_Nome; 
			VALUE 'Nome' ; 
			WIDTH 100 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9

		@ 50,90 TEXTBOX TxtNOME; 
			HEIGHT 25 ; 
			WIDTH 350 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Nome do Fornecedor";
			MAXLENGTH 40;	
			UPPERCASE;
			ON ENTER Iif( Empty( Novo_Forneced.TxtNOME.Value ) ,  Novo_Forneced.TxtNOME.SetFocus , Novo_Forneced.TxtENDERECO.SetFocus )

		@ 90,10 LABEL Lb_Endereco; 
			VALUE 'Endereço' ; 
			WIDTH 80 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9       

		@ 80,90 TEXTBOX TxtENDERECO ; 
			HEIGHT 25 ; 
			WIDTH 350 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Endereço do Fornecedor";
			MAXLENGTH 40;	
			UPPERCASE;
			ON ENTER Novo_Forneced.TxtBAIRRO.SetFocus

		@ 120,10 LABEL Lb_Bairro; 
			VALUE 'Bairro' ; 
			WIDTH 40 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9

		@ 110,90 TEXTBOX TxtBAIRRO; 
			HEIGHT 25 ; 
			WIDTH 180 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Bairro do Fornecedor";
			MAXLENGTH 30;	
			UPPERCASE;
			ON ENTER Novo_Forneced.TxtCEP.SetFocus

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
			TOOLTIP "Digite a Cidade do Fornecedor";
			MAXLENGTH 30;
			UPPERCASE;	
			ON ENTER Novo_Forneced.TxtESTADO.SetFocus

		@ 150,280 LABEL Lb_Estado; 
			VALUE 'Estado' ; 
			WIDTH 38 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL'  SIZE 9 

		@ 140,330 TEXTBOX TxtESTADO; 
			HEIGHT 25 ; 
			WIDTH 35 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Estado do Fornecedor";
			MAXLENGTH 02;	
			UPPERCASE;
			ON ENTER Novo_Forneced.TxtDDD.SetFocus

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
			TOOLTIP "Digite o DDD do Fornecedor";
			MAXLENGTH 04;	
			ON ENTER Novo_Forneced.TxtFONE1.SetFocus

		@ 210,150 LABEL Lb_Fone1; 
			VALUE 'Fone #1' ; 
			WIDTH 45 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL' SIZE 9

		@ 200,200 TEXTBOX TxtFONE1; 
			HEIGHT 25 ; 
			WIDTH 88 ; 
			FONT 'ARIAL' SIZE 9;
			TOOLTIP "Digite o Telefone #1 do Fornecedor";
			MAXLENGTH 11;	
			ON ENTER Novo_Forneced.TxtFONE2.SetFocus

		@ 210,300 LABEL Lb_Fone2; 
			VALUE 'Fone #2'; 
			WIDTH 45 ; 
			HEIGHT 25 ; 
			FONT 'ARIAL'  SIZE 9

		@ 200,350 TEXTBOX TxtFONE2 ; 
			HEIGHT 25 ; 
			WIDTH 88 ; 
			FONT 'ARIAL'  SIZE 9;
			TOOLTIP "Digite o Telefone #2 do Fornecedor";
			MAXLENGTH 11;	
			ON ENTER Novo_Forneced.TxtCONTATOS.SetFocus

		@ 240,0 FRAME Dados_03 CAPTION 'Contatos'  WIDTH 451 HEIGHT 60  FONT 'ARIAL'  SIZE 9

		@ 260,10 TEXTBOX TxtCONTATOS; 
			HEIGHT 25 ; 
			WIDTH 430 ; 
			FONT 'ARIAL'  SIZE 9;
			TOOLTIP "Digite Contatos para este Fornecedor";
			MAXLENGTH 50;	
			UPPERCASE;
			ON ENTER Novo_Forneced.Bt_Salvar.SetFocus

		@ 300,0 FRAME Status_01 CAPTION 'Status'  WIDTH 450 HEIGHT 52 FONT 'ARIAL'  SIZE 9

		@ 320,010 LABEL Lb_DT_CAD   VALUE 'Data Cad: '       WIDTH 120 HEIGHT 25 FONT 'ARIAL'  SIZE 9 
		@ 320,150 LABEL Lb_DT_ALT    VALUE 'Últ Alteração: '  WIDTH 150 HEIGHT 25 FONT 'ARIAL'  SIZE 9
		@ 320,310 LABEL Lb_USUARIO VALUE 'Usuário: '          WIDTH 140 HEIGHT 25 FONT 'ARIAL'  SIZE 9

		@ 360,10 BUTTON Bt_Salvar; 
			CAPTION '&Salvar' ; 
			ACTION Bt_Salvar_Forneced() ;
			WIDTH 100 ; 
			HEIGHT 30 ;
			FONT "MS Sans Serif" SIZE 09 FLAT		

		@ 360,120 BUTTON Bt_Excluir; 
			CAPTION '&Excluir' ; 
			ACTION	Bt_Excluir_Forneced(2) ;
			WIDTH 100 ; 
			HEIGHT 30 ;
			 FONT "MS Sans Serif" SIZE 09 FLAT		

		@ 360,350 BUTTON Bt_Cancelar ; 
			CAPTION '&Cancelar' ; 
			ACTION Novo_Forneced.Release;
			WIDTH 100 ; 
			HEIGHT 30 ; 			
			FONT "MS Sans Serif" SIZE 09 FLAT				     

	END WINDOW   

	Forneced_Push()

	Novo_Forneced.StatusBar.Item(1) := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)
	
	Novo_Forneced.TxtCODIGO.Enabled := .F.
	Novo_Forneced.Pessoa_Juridica.SetFocus

	If  lNovo

		Novo_Forneced.Bt_Excluir.Enabled := .F.

	EndIf

	CENTER	 WINDOW Novo_Forneced
	ACTIVATE WINDOW Novo_Forneced	

	Return NIL
/*
*/
Function Pesquisa_Forneced()
	Local cPesq			:= Upper(AllTrim(   Form_Forneced.TxtPesquisa.Value  ))
	Local nTamanhoNomeParaPesquisa	:= Len(cPesq)
	Local nQuantRegistrosProcessados	:= 0
	Local nQuantMaximaDeRegistrosNoGrid := 30

	Forneced->(DBSetOrder(2))
	Forneced->(DBSeek(cPesq))
	DELETE ITEM ALL FROM Grid_Forneced OF Form_Forneced
	Do While ! Forneced->(Eof())
		If Substr( Forneced->Nome,1,nTamanhoNomeParaPesquisa) == cPesq
			nQuantRegistrosProcessados += 1
			if nQuantRegistrosProcessados > nQuantMaximaDeRegistrosNoGrid
				EXIT
			EndIf
			If Empty( Forneced->Nome )
				MsgBox("Existe Nomes em Branco Nesta Tabela, Verifique!!",SISTEMA)
			Endif
			ADD ITEM { Forneced->Codigo , Forneced->Nome } TO Grid_Forneced OF Form_Forneced
		ElseIf Substr( Forneced->Nome,1,nTamanhoNomeParaPesquisa) > cPesq
			EXIT
		Endif
		Forneced->(DBSkip())
	EndDo
	Form_Forneced.TxtPesquisa.SetFocus
	Return Nil
/*
*/
Function Renova_Pesquisa_Forneced(cNome)
	Form_Forneced.TxtPesquisa.Value := Substr(AllTrim(cNome),1,10)
	Form_Forneced.TxtPesquisa.SetFocus
	Pesquisa_Forneced()
	Return Nil
/*
*/
Function Bt_Salvar_Forneced()
	Local cCodigo
	Local cPesq	:= AllTrim( Form_Forneced.TxtPesquisa.Value )
	
	If Empty( Novo_Forneced.TxtNome.Value  )
		PlayExclamation()
		MsgInfo("Nome do Fornecedor não Informado !!","Operação Inválida")
		Novo_Forneced.txtNOME.SetFocus
		Return Nil
	EndIf

	If lNovo	  
		      If ! NoInclui( Acesso->Status )
			MsgNo( "INCLUIR")
			Return Nil
		EndIf
		lNovo    := .F.
		cCodigo  := GeraCodigo( "Forneced"  , 1 , 06 )
		Forneced->(DBAppend())
		Forneced->Codigo	:= cCodigo
		Forneced->DtCad := Date()
		Forneced_Flush()
		GravouCodigoCorretamente( "Forneced" , cCodigo , 1 )
		PlayExclamation()
		MSGExclamation("Inclusão Efetivada no "+cTitulo,SISTEMA)
		Novo_Forneced.Release
		Renova_Pesquisa_Forneced(Substr( Forneced->Nome,1,10))
	Else	         
		If ! NoAltera( Acesso->Status )
			MsgNo( "ALTERAR")
			Return Nil
		EndIf
		Forneced->(DBSetOrder(1))
		If ! Forneced->(DBSeek(CodigoAlt))
			PlayExclamation()
			MsgExclamation("ERRO-G01 # Código não Localizado para Alteração!!",SISTEMA)
		Else
			If BloqueiaRegistroNaRede( "Forneced" )
				Forneced_Flush()
				Forneced->(DBUnlock())
				MsgINFO("Registro Alterado!!",SISTEMA)
				Novo_Forneced.Release
				Renova_Pesquisa_Forneced(Substr( Forneced->Nome,1,10))
			EndIf
		 EndIf
	EndIf

	Return Nil

/*
*/
Function Forneced_Push()

	If  lNovo
		Forneced->(DBGoBottom())
		Forneced->(DBSkip())

	EndIf			

	Novo_Forneced.TxtCODIGO.Value	  := AllTrim(Forneced->Codigo)
	Novo_Forneced.Pessoa_Juridica.Value	  := Forneced->Juridica
	Novo_Forneced.TxtCGC_CPF.Value	  := AllTrim(Forneced->CGC_CPF)
	Novo_Forneced.TxtNOME.Value	  := AllTrim( Forneced->Nome )
	Novo_Forneced.TxtENDERECO.Value   := AllTrim(Forneced->Endereco)
	Novo_Forneced.TxtBAIRRO.Value	  := AllTrim(Forneced->Bairro)
	Novo_Forneced.TxtCEP.Value		  := AllTrim(Forneced->Cep)
	Novo_Forneced.TxtCIDADE.Value	  := AllTrim(Forneced->Cidade)
	Novo_Forneced.TxtESTADO.Value	  := AllTrim(Forneced->ESTADO)
	Novo_Forneced.TxtDDD.Value		  := AllTrim(Forneced->DDD)
	Novo_Forneced.TxtFONE1.Value	  := AllTrim(Forneced->Fone1)
	Novo_Forneced.TxtFONE2.Value	  := AllTrim(Forneced->Fone2)
	Novo_Forneced.TxtCONTATOS.Value   := AlLTrim(Forneced->Contatos)
	Novo_Forneced.Lb_DT_CAD.Value	  := "Data Cad: "+DtoC(Forneced->DtCad)
	Novo_Forneced.Lb_DT_ALT.Value	  := "Últ Alteração: "+DtoC(Forneced->DtAlt)
	Novo_Forneced.Lb_USUARIO.Value	  := "Usuário: "+PGeneric("ACESSO",1,Forneced->Usuario,"APELIDO")

	Return Nil
/*
*/
Function Forneced_Flush()
	
	Forneced->Nome		:= AllTrim( Novo_Forneced.TxtNOME.Value )
	Forneced->Juridica		:= Novo_Forneced.Pessoa_Juridica.Value
	Forneced->CGC_CPF	:= Novo_Forneced.TxtCGC_CPF.Value
	Forneced->Endereco	:= AllTrim( Novo_Forneced.TxtENDERECO.Value )
	Forneced->Bairro		:= AllTrim( Novo_Forneced.TxtBAIRRO.Value )
	Forneced->Cep		:= AllTrim( Novo_Forneced.TxtCEP.Value )
	Forneced->Cidade		:= AllTrim( Novo_Forneced.TxtCIDADE.Value )
	Forneced->Estado		:= AllTrim( Novo_Forneced.TxtESTADO.Value )
	Forneced->DDD		:= AllTrim( Novo_Forneced.TxtDDD.Value )
	Forneced->Fone1 	:= AllTrim( Novo_Forneced.TxtFONE1.Value )
	Forneced->Fone2 	:= AllTrim( Novo_Forneced.TxtFONE2.Value )
	Forneced->Contatos		:= AllTrim( Novo_Forneced.TxtCONTATOS.Value )
	Forneced->DtAlt 	:= Date()
	Forneced->Usuario		:= Acesso->Codigo

	Return Nil

/*
*/
Function Bt_Excluir_Forneced( nGrid )
	 Local nColuna	   := 1
	 Local nReg	   := PegaValorDaColuna( "Grid_Forneced" , "Form_Forneced" , nColuna )
	 Local cNome	   := ""
	 Local cUltimaPesq := Upper(AllTrim( Form_Forneced.TxtPesquisa.Value ))

	If ! NoExclui( Acesso->Status )
		MsgNo( "EXCLUIR")
		Return Nil
	EndIf

	 cUltimaPesq := Iif( ! Empty(cUltimaPesq) , cUltimaPesq , AllTrim(cNome) )

	 nReg := Iif( nGrid == 1 , nReg ,  Novo_Forneced.txtCodigo.Value )

	 If Empty(nReg)
		MsgExclamation("Nenhum Registro Informado para Exclusão!!",SISTEMA)
		Return Nil
	Else
		Forneced->(DBSetOrder(1))
		If ! Forneced->(DBSeek(nReg))
			MsgINFO("Erro de Pesquisa!!")
			Return Nil
		EndIf
		If MsgYesNo("Excluir "+AllTrim( Forneced->Nome )+" ??",SISTEMA)
			If BloqueiaRegistroNaRede( "Forneced" )
				Forneced->(DBDelete())
				Forneced->(DBUnlock())
				If nGrid != 1
					Novo_Forneced.Release
				EndIf
				Renova_Pesquisa_Forneced(cUltimaPesq)
			 EndIf
		EndIf
	 EndIf
	 Return Nil
/*
*/
Function Bt_Sair_Forneced()
	Forneced->(DBCloseArea())
	Form_Forneced.Release
	Return Nil
/*
*/
Function FornecedOpen( LPack )
	Local nArea	:= Select( 'Forneced' )
	Local cBase	:= BaseDeDados()	
	Local ArqBase	:= cBase+"Forneced.DBF"
	Local aarq	:= {}		
                 
	LinhaDeStatus( "Abrindo Cadastro de Fornecedores" )

	If nArea == 0
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

		PacKArquivo( ArqBase , LPack  )

		Use (ArqBase) Alias Forneced New Shared Via DRIVER
		If ! File(cBase+'Fornec1.ntx')
			LinhaDeStatus("Index Forneced por Código - Fornec1.ntx")
			Index On CODIGO To (cBase)+'Fornec1'
		EndIf
		If ! File(cBase+'Fornec2.ntx')
			LinhaDeStatus("Index Forneced por Nome - Fornec2.ntx")
			Index On NOME to (cBase)+'Fornec2'
		EndIf
	EndIf

	Forneced->(DBCLearIndex())
	Forneced->(DBSetIndex(cBase+'Fornec1'))
	Forneced->(DBSetIndex(cBase+'Fornec2'))

	LinhaDeStatus()

	Return nArea
/*
*/
Function CriaMascara_Fornec()
	Local i		:= 0
	Local cCGC	:= AllTrim( Novo_Forneced.TxtCGC_CPF.Value )
	Local cNewCGC	:= ""

	For i := 1	 To Len( cCGC )

		cNewCGC += Iif(  IsDigit( Substr( cCGC , i , 1 ) )  , Substr( cCGC , i , 1 ) , ""  )

	Next

	If Novo_Forneced.Pessoa_Juridica.Value
		Novo_Forneced.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 99.999.999/9999-99" ) )
	Else
		Novo_Forneced.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 999.999.999-99" ) )
	EndIf

	Return Nil
