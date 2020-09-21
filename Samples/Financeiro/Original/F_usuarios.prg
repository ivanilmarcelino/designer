#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
/*
*/
*---------------------------------------------------------------------------------------------------*
* Procedure Usuarios | Cadastro dos Usuários			  *
*---------------------------------------------------------------------------------------------------*
Procedure Usuarios()	

	  Private cUser	:= Acesso->Codigo	&& Guarda o Codigo do Usuário Atual para reposicionár-lo ao sair deste Cadastro
	  Private CodigoAlt	:= 0			&& Variável utilizada para verificar qual o codigo foi alterado
	  Private cTitulo	:= "Cadastro de Usuarios"	&& Titulo desta rotina, será mostrado em formulários
	  Private lNovo	:= .F. 			&& Variável para controlar se Está Incluindo ou alterando usuários

	  *** Posiciona Alias Acesso na Ordem de Indice 2 ( Apelidos )
	  Acesso->(DBSetOrder(2))  

	  *** Cria Formulário Principal
	  DEFINE WINDOW Form_Usuarios	;
		 AT 05,05		; 
		 WIDTH	425		;
		 HEIGHT 460		;
		 TITLE "Cadastro de usuarios";
		 ICON 'ICONE01'		;
		 CHILD			;
		 NOSIZE			;
		 ON RELEASE Back_Old_User( cUser )

		 @ 010,010 GRID Grid_Usuarios;
		   WIDTH  400          ;
		   HEIGHT 329          ;
		   HEADERS {"Código","Apelido","Nome"};
		   WIDTHS  {60,150,333}    ;
		   VALUE 1             ;
		   FONT "Arial" SIZE 09;
		   ON DBLCLICK { || Bt_Novo_usuario(2) }

		   @ 357,011 LABEL  Label_Pesquisa	 ;
		     VALUE "Pesquisa "                   ;
		     WIDTH 70				 ;
		     HEIGHT 20				 ;
		     FONT "Arial" SIZE 09

		   @ 353,085 TEXTBOX TxtPesquisa	 ;
		     WIDTH 326				 ;
		     TOOLTIP "Digite o Nome para Pesquisa"   ;
		     MAXLENGTH 40 UPPERCASE		 ;
		     ON ENTER { || Pesquisa_Usuario() }

		   @ 397,011 BUTTON Novo_usuario	    ;
			     CAPTION '&Novo'                ;
			     ACTION { || Bt_Novo_usuario(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,111 BUTTON Editar_Usuario	  ;
			     CAPTION '&Editar'           ;
			     ACTION { || Bt_Novo_usuario(2)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,211 BUTTON Excluir_Usuario	 ;
			     CAPTION 'E&xcluir'          ;
			     ACTION { || Bt_Excluir_Usuario(1)};
			     FONT "MS Sans Serif" SIZE 09 FLAT

		   @ 397,311 BUTTON Bt_Sair_Usuario	       ;
			     CAPTION '&Sair'                ;
			     ACTION { || Bt_Sair_Usuario() };
			     FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW
	
	*** Coloca o Cursor/Foco em TxtPesquisa
	Form_Usuarios.TxtPesquisa.SetFocus

	*** Realiza pesquisa para atualizar o Grid pela primeira vez
	Renova_Pesquisa_Usuario(" ")

	*** Centraliza Janela
	CENTER	 WINDOW Form_Usuarios

	*** Ativa Janela
	ACTIVATE WINDOW Form_Usuarios

	Return Nil

/*
	nReg	= Recebe o Código do usuário utilizando a Função PegaValorDaColuna() 
	cStatus	= Variável para informar na barra de Titulos do Formulário  se está Incluindo ou Alterando
	aStatus	= Array com Status do Usuário 
*/ 
Function Bt_Novo_usuario(nTipo)
	 Local nReg	    := PegaValorDaColuna( "Grid_Usuarios" , "Form_Usuarios" , 1 )
	 Local cStatus	    := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)	
	 Local aStatus	    := {  "9"  ,  .F. ,  .F. ,  .F.  , .F. , .F. }

	 *** Variavel Private que controla se está sendo efetuada uma inclusão ou uma alteração
	 lNovo		    := Iif(nTipo==1,.T.,.F.)

	 *** Se Tipo for 2, o usuário está Alterando/Editando um Registro
	 If nTipo == 2			

		*** Se o usuário estiver editando/alterando um registro e a variável nReg estiver vazia é porque o grid não foi clicado
		*** Esta variável recebeu (veja cima) o valor do Grid em PegavalorDaColuna() 
		If Empty(nReg)

			MsgExclamation("Nenhum Registro Informado para Edição!!",SISTEMA)
			Return Nil

		Else			
			*** Posicona o Arquivo no Indice 1 (Codigo)			
			Acesso->(DBSetOrder(1))

			*** Se o codigo não foi localizado no Arquivo, houve um erro de pesquisa
			If ! Acesso->(DBSeek(nReg))
				MsgSTOP("Erro de Pesquisa em USUÁRIOS.DBF!!")
				Return NIl	   
			EndIf
			
			*** Se codigo a ser alterado foi localizado, a variável CodigoAlt Guarda o Valor do Codigo do usuário para posterior pesquisa e gravação
			CodigoAlt := Acesso->Codigo			

		EndIf

	EndIf

	*** Cria Janela de cadastro
	DEFINE WINDOW Novo_Usuario	;
		AT 0,0			;
		WIDTH  377		;
		HEIGHT 270		;
		TITLE cTitulo		;
		MODAL			;
		NOSIZE			       

		DEFINE STATUSBAR		
			STATUSITEM "Manutenção no "+cTitulo
		END STATUSBAR

		@ 22,10 LABEL LCodigo	; 
		             VALUE 'Código'	; 
		             WIDTH 50		; 
		             HEIGHT 30	; 
		             FONT 'Arial' SIZE 09		

		@ 20,60 TEXTBOX TxtCODIGO	;
                                          HEIGHT 25		; 
			WIDTH 50		; 
		              FONT 'Arial' SIZE 09

                            @ 22,283 LABEL LNivel	; 
		               VALUE 'Nível'	; 
	                             WIDTH 50	; 
	                             HEIGHT 25	; 
	                             FONT 'Arial' SIZE 09	
                                            
		@ 20,332 TEXTBOX TxtNIVEL	;
		               HEIGHT 25		; 
		               WIDTH 20		; 
	                             FONT 'Arial' SIZE 09	;
		               TOOLTIP "Digite o Nível do Usuário para o Sistema  0  a 9";
		               MAXLENGTH 01		;	
			 ON ENTER Iif( Novo_Usuario.TxtNIVEL.Value $ "1234567890" ,  Novo_Usuario.TxtNOME.SetFocus , Novo_Usuario.TxtNIVEL.SetFocus )

		@ 53,10 LABEL LNome		; 
		             VALUE 'Nome'		; 
		             WIDTH 50			; 
		             HEIGHT 25		; 
		             FONT 'Arial' SIZE 09           
		
		@ 50,60 TEXTBOX TxtNOME		  ;
		             HEIGHT 25		; 
		             WIDTH 300		; 
	                           FONT 'Arial' SIZE 09	;
		             TOOLTIP "Digite Nome do Usuário";
		             MAXLENGTH 30 UPPERCASE;
		             ON ENTER  Iif( Empty( Novo_Usuario.TxtNOME.Value ) , Novo_Usuario.TxtNOME.SetFocus , Novo_Usuario.TxtAPELIDO.SetFocus )

		@ 84,10 LABEL LApelido		; 
                                         VALUE 'Apelido'		; 
		             WIDTH 50			; 
		             HEIGHT 25		; 
	                           FONT 'Arial' SIZE 09			       

		@ 80,60 TEXTBOX TxtAPELIDO	;
		             HEIGHT 25		; 
		             WIDTH 110		; 
	                           FONT 'Arial' SIZE 09       	;
                                         TOOLTIP "Digite o Apelido deste Usuário";
		             MAXLENGTH 10 UPPERCASE;
		             ON LOSTFOCUS Novo_Usuario.BSalvar.Enabled := .T.	
		             ON ENTER  Iif( Empty( Novo_Usuario.TxtAPELIDO.Value ) , Novo_Usuario.TxtAPELIDO.SetFocus , Novo_Usuario.LInclui.SetFocus )

		@ 84,182 LABEL LVencto		; 
                                         VALUE 'Vence em'		; 
		             WIDTH 100		; 
		             HEIGHT 25		; 
	                           FONT 'Arial' SIZE 09		

		@ 80,240 DATEPICKER DtVencto FONT "Arial" SIZE 09 TOOLTIP "Data de Vencimento da Senha"

                            @ 120,10 FRAME Frame_1		; 
		               CAPTION 'Operações'	; 
		               WIDTH 350		; 
	                             HEIGHT 58		; 
		               FONT 'Arial' SIZE 09

		@ 140,20 CHECKBOX LInclui	; 
	                             CAPTION 'Inc'		; 
		               WIDTH 50		; 
		               HEIGHT 25		; 
		               VALUE FALSE		; 
		               FONT 'Arial' SIZE 09	;
			 TOOLTIP "Habilite se Usuário está autorizado à Incluir Registros no Sistema"
		               
		@ 140,90 CHECKBOX LAltera	; 
		               CAPTION 'Alt'		; 
		               WIDTH 50		; 
		               HEIGHT 25		; 
		               VALUE FALSE		; 
		               FONT 'Arial'  SIZE 09	;
			 TOOLTIP "Habilite se Usuário está autorizado à Alterar Registros no Sistema";

		@ 140,160 CHECKBOX LExclui	; 
	                               CAPTION 'Exc'		; 
		                 WIDTH 50		; 
		                 HEIGHT 25		; 
		                 VALUE FALSE		; 
		                 FONT 'Arial'  SIZE 09	;
 			  TOOLTIP "Habilite se Usuário está autorizado à Excluir Registros no Sistema";

		@ 140,230 CHECKBOX LRel	; 
		                 CAPTION 'Rel'		; 
	                               WIDTH 50		; 
		                 HEIGHT 25		; 
	                               VALUE FALSE		; 
		                 FONT 'Arial'  SIZE 09	;
			  TOOLTIP "Habilite se Usuário está autorizado à Emitir Relatórios no Sistema";

		@ 140,290 CHECKBOX LInativo	; 
	                               CAPTION 'Inativo'	; 
	                               WIDTH 60		; 
	                               HEIGHT 25		; 
		                 VALUE FALSE		; 
		                 FONT 'Arial'  SIZE 09	;
			   TOOLTIP "Habilite se Usuário estiver Inativo no Sistema";

		@ 190,10 BUTTON BSalvar		; 
	                             CAPTION '&Salvar'	; 
	                             ACTION Bt_Salvar_Usuarios(); 
	                             WIDTH 70		; 
	                             HEIGHT 25		; 
		               FONT "MS Sans Serif" SIZE 09 FLAT		   

		@ 190,90 BUTTON BExcluir		; 
	                             CAPTION '&Excluir'	; 
	                             ACTION Bt_Excluir_Usuario(2); 
	                             WIDTH 70		; 
	                             HEIGHT 25		; 
	                             FONT "MS Sans Serif" SIZE 09 FLAT 	 

		@ 190,290 BUTTON BCancelar		; 
		                CAPTION '&Cancelar'		; 
		                ACTION Novo_Usuario.Release	; 
		                WIDTH 70			; 
	 	                HEIGHT 25			; 
		                FONT "MS Sans Serif" SIZE 09 FLAT              

	END WINDOW      

	*** Como o código do Usuário e gerado pelo sistema, o campo código é desabilitado 
	Novo_Usuario.TxtCODIGO.Enabled := .F.		

	*** Se a operação for de Alteração/Edição
	If ! lNovo
		
		*** Preeenche o Status Atual do Usuário que será alterado
		aStatus := StatusDoUsuario( Acesso->Codigo )

		*** Coloca nos objetos do Formulário os dados do usuário a ser alterado
		Novo_Usuario.TxtCodigo.Value	 := AllTrim(Acesso->Codigo)
		Novo_Usuario.TxtNIVEL.Value	 := aStatus[ 1 ]
		Novo_Usuario.TxtNOME.Value	 := AllTrim(Acesso->Usuario)
		Novo_Usuario.TxtAPELIDO.Value	 := AllTrim(Acesso->Apelido)
		Novo_Usuario.Linclui.Value		 := aStatus[ 2 ]
		Novo_Usuario.LAltera.Value		 := aStatus[ 3 ]
		Novo_Usuario.LExclui.Value		 := aStatus[ 4 ]
		Novo_Usuario.LRel.Value		 := aStatus[ 5 ]
		Novo_Usuario.LInativo.Value		 := aStatus[ 6 ]
		Novo_Usuario.DtVencto.Value	 := aStatus[ 7 ]

	Else

		*** Caso a operação seja de inclusão, coloca valor default 9 para Nível do Usuário, Data de vencimento da Senha
		*** 90 dias à partir da data do sistema, desabilita botão Excluir e Salvar. 
		*** O Botão Excluir nunca será habilitado porque está sendo Incluído um novo registro
		*** O Botão salvar só é habilitado quando o nome do usuário é digitado e o cursor/Foco vai para o campo apelido e executa a Cláusula  ON LOSTFOCUS Novo_Usuario.BSalvar.Enabled := .T. 
		Novo_Usuario.TxtNIVEL.Value	:= "9"		
		Novo_Usuario.DtVencto.Value	:= Date() + 90		
		Novo_Usuario.BExcluir.Enabled	:= .F.
		Novo_Usuario.BSalvar.Enabled	:= .F.		

	EndIf				

	*** Coloca na barra de Status do Formulário a variavel com informaç	ão de Alteração ou Inclusão
	Novo_Usuario.StatusBar.Item(1) := cStatus
	
	*** Pociociona o Cursor/Foco em TxtNivel
	Novo_Usuario.TxtNIVEL.SetFocus

	*** Centraliza janela
	CENTER   WINDOW Novo_Usuario
	
	*** Ativa Janela
	ACTIVATE WINDOW Novo_Usuario

	Return NIL
/*

	cPesq				= Recebe o valor do campo de pesquisa TxtPesquisa sem espaços em branco
	nTamanhoNomeParaPesquisa	= Guarda o tamanho da variável a ser pesquisada para comparar 
	Local nQuantRegistrosProcessados	= Contador que controla quantos registros já foram lidos
	Local nQuantMaximaDeRegistrosNoGrid = Limite de registros que serão mostrados no Grid
	
*/
Function Pesquisa_Usuario()
	Local cPesq			:= Upper(AllTrim(   Form_Usuarios.TxtPesquisa.Value  ))
	Local nTamanhoNomeParaPesquisa	:= Len(cPesq)
	Local nQuantRegistrosProcessados	:= 0
	Local nQuantMaximaDeRegistrosNoGrid := 30

	*** Posiciona o Arquivo na Ordem 2 (Apelidos)
	Acesso->(DBSetOrder(2))

	*** Efetua pesquisa no Arquivo para posicionar no primeiro registro que satisfaça a condição
	Acesso->(DBSeek(cPesq))

	*** Exclui todos registros do Grid		
	DELETE ITEM ALL FROM Grid_Usuarios OF Form_Usuarios

	*** Entra no Laço (While ) até que encontre o fim do arquivo
	Do While ! Acesso->(Eof())

		*** Se o Substr do apelido for igual à variavel cPesq ( Conteúdo do campo TxtPesquisa)
		If Substr( Acesso->Apelido,1,nTamanhoNomeParaPesquisa) == cPesq

			*** Acumula contador
			nQuantRegistrosProcessados += 1

			*** Se a quantidade de resgistros lidos atingiu o limite de registros definidos para o grid sai do laço/While
			if nQuantRegistrosProcessados > nQuantMaximaDeRegistrosNoGrid

				EXIT

			EndIf

			*** Nesta rotina, pode-se aproveitar para verificar erros no arquivo
			*** Nesta caso, verifica se existem apelidos em branco, já que é um campo obrigatório
			If Empty( Acesso->Apelido )

				MsgBox("Existe Apelidos em Branco Nesta Tabela, Verifique!!",SISTEMA) 	       

			Endif

			 *** Adiciona registros no Grid
			ADD ITEM { Acesso->Codigo,Acesso->Apelido,Acesso->Usuario } TO Grid_Usuarios OF Form_Usuarios


		*** Se o Substr de Apelido estiver fora da faixa de pesquisa, abandona o laço
		ElseIf Substr( Acesso->Apelido,1,nTamanhoNomeParaPesquisa) > cPesq

			EXIT

		Endif

		** Pula para próximo registro
		Acesso->(DBSkip())

	EndDo

	*** Pisiciona o cursor/Foco no campo TxtPesquisa		
	Form_Usuarios.TxtPesquisa.SetFocus

	Return Nil

/*
	
	Recebe um parâmetro com o nome a ser pesquisado, colocar os Dez primeiros caracteres no TxtPesquisa e
	retorna para a rotina Pesquisa_Usuario()

*/
Function Renova_Pesquisa_Usuario(cNome)
	Form_Usuarios.TxtPesquisa.Value := Substr(AllTrim(cNome),1,10)
	Form_Usuarios.TxtPesquisa.SetFocus
	Pesquisa_Usuario()
	Return Nil
/*
*	Salva Dados do Formulário de Cadastro
*/
Function Bt_Salvar_Usuarios()
	Local cCodigo
	Local cPesq	:= AllTrim( Form_Usuarios.TxtPesquisa.Value )
	
	*** Se o campo Nome ou Apelido não  forem informados, enviar mensagem e posiciona cursor/Foco no campo TxtNome
	If Empty( Novo_Usuario.TxtNome.Value  )   .Or.  Empty( Novo_Usuario.TxtApelido.Value  )
		PlayExclamation()
		MsgInfo("Nome ou Apelido não Informado !!","Operação Inválida")
		Novo_Usuario.txtNOME.SetFocus
		Return Nil
	EndIf

	*** Se for um Novo registro
	If lNovo	  
		*** Marca variavel lNovo como FALSE
		lNovo    := .F.

		*** Gera o próximo Codigo para o usuário - Função GeraCodigo() está em F_Funcoes.PRG
		cCodigo  := GeraCodigo( "Acesso"  , 1 , 04 )

		*** Cria um novo Registro e grava o codigo e a senha Encriptada
		Acesso->(DBAppend())
		Acesso->Codigo     := cCodigo
		Acesso->SENHA    := Encripta("SENHA")

		*** Grava os outros dados do Registro
		Usuarios_Flush()

		*** Verifica se Gravou o Codigo no Arquivo - Esta função está em F_Funcoes.PRG
		GravouCodigoCorretamente( "Acesso" , cCodigo , 1 )
		PlayExclamation()
		MSGExclamation("Inclusão Efetivada no "+cTitulo,SISTEMA)

		*** Release Formulário de Cadastro
		Novo_Usuario.Release
		
		*** envia para a Rotina de Pesquisa os Dez Primeiros caracteres do Novo Apelido
		Renova_Pesquisa_Usuario(Substr( Acesso->Apelido,1,10))

	Else	         	

		*** Se Estiver Alterando/Editando Registro
		*** Posiciona o Arquivo no Indice 1 - Por Código
		Acesso->(DBSetOrder(1))

		*** Faz uma pesquisa para posicionar o Registro no Codigo a ser alterado
		*** Caso não localize o registro, ocorreu algum erro
		If ! Acesso->(DBSeek(CodigoAlt))

			PlayExclamation()
			MsgExclamation("ERRO-G01 # Código não Localizado para Alteração!!",SISTEMA)

		Else
			*** Após posicionar no Registro a ser alterado, bloqueia registro na rede 
			If BloqueiaRegistroNaRede( "Acesso" )

				*** Atualiza Dados no Arquivo
				Usuarios_Flush()				
				
				*** Desbloqueia Registro na Rede					
				Acesso->(DBUnlock())

				*** Envia mensagem para usuário
				MsgINFO("Registro Alterado!!",SISTEMA)

				*** Efetua Release do formulário de Cadastro
				Novo_Usuario.Release

				*** envia para a Rotina de Pesquisa os Dez Primeiros caracteres do Novo Apelido
				Renova_Pesquisa_Usuario(Substr( Acesso->Apelido,1,10))

			EndIf

		 EndIf

	EndIf
	Return Nil

/*
	Esta rotina grava os dados do formuário
*/
Function Usuarios_Flush()	
	Local cStatus	:= CriptografaStatusDoUsuario()
	
	Acesso->Usuario	:= AllTrim( Novo_Usuario.TxtNome.Value )
	Acesso->Apelido	:= AllTrim( Novo_Usuario.TxtApelido.Value )
	Acesso->Status	:= cStatus

	Return Nil

/*
	Criptografa Status do Usuário - gera Sequência para gravar no Campo STATUS 
*/
Function CriptografaStatusDoUsuario()
	Local cSeq	:= ""
	
	cSeq	:= Novo_Usuario.TxtNivel.Value
	cSeq	+= Iif( Novo_Usuario.lInclui.Value  , "1" ,  "0"  )
	cSeq	+= Iif( Novo_Usuario.lAltera.Value , "1" ,  "0"  )
	cSeq	+= Iif( Novo_Usuario.lExclui.Value , "1" ,  "0"  )
	cSeq	+= Iif( Novo_Usuario.lRel.Value     , "1" ,  "0"  )
	cSeq	+= Iif( Novo_Usuario.lInativo.Value , "1" ,  "0"  )
	cSeq      += DtoC( 	Novo_Usuario.DtVencto.Value )

	Return(Encripta( cSeq + Time()+Time()+Time()+Time()))

/*

	Esta função recebe o Parâmetro nGrid -  1 Se a exclusão foi solicitada do Grid   e  2 se
	exclusão foi solicitada pressionando o Botão excluir no formulario de cadastro
	
	nReg		= Recebe o Código do usuário utilizando a Função PegaValorDaColuna() 
	
*/
Function Bt_Excluir_Usuario( nGrid )
	Local nReg	   := PegaValorDaColuna( "Grid_Usuarios" , "Form_Usuarios" , 1 )
	Local cNome	   := ""
	Local cUltimaPesq := Upper(AllTrim( Form_Usuarios.TxtPesquisa.Value ))
	
	cUltimaPesq := Iif( ! Empty(cUltimaPesq) , cUltimaPesq , AllTrim(cNome) )

	nReg := Iif( nGrid == 1 , nReg ,  Novo_Usuario.txtCodigo.Value )

	*** *** Se o codigo não foi localizado no Arquivo, houve um erro de pesquisa
	If Empty(nReg)

		MsgExclamation("Nenhum Registro Informado para Exclusão!!",SISTEMA)
		Return Nil
	
	Else
		*** Posicona Arquivo no Indice 1 - ( Codigo )
		Acesso->(DBSetOrder(1))

		*** Se não localizou codigo no Arquivo - Ocorreu erro
		If ! Acesso->(DBSeek(nReg))

			MsgINFO("Erro de Pesquisa!!")
			Return Nil

		EndIf

		*** Confirma Exclusão do Registro
		If MsgYesNo("Excluir "+AllTrim( Acesso->Apelido )+" ??",SISTEMA)

			*** Bloqueia registro na Rede
			If BloqueiaRegistroNaRede( "Acesso" )

				*** Exclui registro no Arquivo
				Acesso->(DBDelete())
				
				*** Desbloqueia Rede
				Acesso->(DBUnlock())

				*** Se exclusão foi solicitada pelo formulário, efetua release do formulário
				If nGrid != 1

					Novo_Usuario.Release

				EndIf

				*** renova Pesquisa do grid
				Renova_Pesquisa_Usuario(cUltimaPesq)

			 EndIf

		EndIf

	 EndIf
	 Return Nil
/*
*/
Function Bt_Sair_Usuario()	
	Form_Usuarios.Release
	Return Nil
/*
*/
Function StatusDoUsuario(cUsuario)
	Local aAmb	:= SvAmb()
	Local cRet	:= ""
	Local aAcesso	:= {}
	
	Acesso->(DBSetOrder(1))
	Acesso->(DBSeek( cUsuario ))
	cRet	 := Decripta( Acesso->STATUS )

	Aadd( aAcesso , Substr( cRet , 1 , 1) 			) && Nivel do Usuário
	Aadd( aAcesso , Iif( Substr( cRet , 2 , 1) == "1" , .T. , .F.  )) && Inclusões
	Aadd( aAcesso , Iif( Substr( cRet , 3 , 1) == "1" , .T. , .F.  )) && Alteracoes
	Aadd( aAcesso , Iif( Substr( cRet , 4 , 1) == "1" , .T. , .F.  )) && Exclusões
	Aadd( aAcesso , Iif( Substr( cRet , 5 , 1) == "1" , .T. , .F.  )) && Relatórios
	Aadd( aAcesso , Iif( Substr( cRet , 6 , 1) == "1" , .T. , .F.  )) && Ativo
	Aadd( aAcesso , CtoD( Substr( cRet , 7 , 10 ) ) 		 ) && Data de Vencimento da Senha

	RtAmb(aAmb)

	Return( aAcesso )


/*
	Função que retorna o Nivel Atual do Usuario	
*/
Function NivelAtual()	
	Return( Substr( Decripta( Acesso->STATUS ) , 1 , 1) )


/*
	Funcão que retorna  .T.  ou  .F.  para Inclusões
*/
Function NoInclui()	
	Return( Iif( Substr( Decripta( Acesso->STATUS ) , 2 , 1) == "1" , .T. , .F.  ) )	


/*
	Funcão que retorna  .T.  ou  .F.  para Alterações
*/
Function NoAltera()
	Return( Iif( Substr( Decripta( Acesso->STATUS ) , 3 , 1) == "1" , .T. , .F.  ) )	


/*
	Funcão que retorna  .T.  ou  .F.  para Exclusões
*/
Function NoExclui()	
	Return( Iif( Substr( Decripta( Acesso->STATUS ) , 4 , 1) == "1" , .T. , .F.  ) )	


/*
	Funcão que retorna  .T.  ou  .F.  para Emissão de relatórios
*/
Function NoRelat()
	Return( Iif( Substr( Decripta( Acesso->STATUS ) , 5 , 1) == "1" , .T. , .F.  ) )	


/*
	Funcão que retorna  .T.  ou  .F.  para Usuário Ativo ou Inativo
*/
Function NoAtivo()
	Return( Iif( Substr( Decripta( Acesso->STATUS ) , 6 , 1) == "1" , .T. , .F.  ) )	


/*
	Funcão que retorna  Data em que a senha do Usuário atual expira
*/
Function DataExpira()
	Return( CtoD( Substr( Decripta( Acesso->STATUS ) , 7 , 10 ) ) )	


/*
	Funcão de mensagens de Bloqueio
	msgNo( cMsg ) =>  cMsg  =  "INCLUIR"  ,  "ALTERAR"  ,  "EXCLUIR"

*/
Function MsgNO(cMsg)
	MsgINFO( "Usuário <"+ AllTrim( Acesso->Apelido ) +"> sem permissão para "+cMsg+" Registros" , SISTEMA )
	Return Nil		

/*
	Esta função é executa quando ocorre o release do Form_Usuarios  ( ON RELEASE Back_Old_User( cUser ) )
	Posiciona na Área/Alias  "Acesso"  no registro do Usuário que entrou no sistema.
*/
Function Back_Old_User( cCodigo )			
	Local aAmb := SvAmb()
	Acesso->(DBSetOrder(1))
	Acesso->(DBSeek( cCodigo ))
	RtAmb( aAmb )
	Return Nil

/*
	Alteração de Senhas Senhas 
*/
Function AlteraSenha()          
              Local cUser		:= Acesso->Apelido
              Local cPassWord		:= "" 
              Local NewPassWord	:= ""     
              Local ConfirmPassWord	:= ""     

	*** Cria Form Nova_senha
	DEFINE WINDOW Form_Nova_senha ;
		AT 0,0 ;
		WIDTH 280 HEIGHT 235 ;
		TITLE 'Alteração de Senha de Acesso'   MODAL NOSYSMENU BACKCOLOR BLUE                                                          

		@010,030 LABEL Label_User	;
			 VALUE "Usuário Atual"	;
			 WIDTH 120		;
			 HEIGHT 35		;
			 FONT "Arial" SIZE 09	;
                                           BACKCOLOR BLUE	;
                                           FONTCOLOR WHITE BOLD

	 	 @045,030 LABEL Label_Password	;
			   VALUE "Senha       "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	;
                                             BACKCOLOR BLUE 	;
                                             FONTCOLOR WHITE BOLD	

	 	 @080,030 LABEL Label_NewPassword;
			   VALUE "Nova Senha      "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	;
                                             BACKCOLOR BLUE 	;
                                             FONTCOLOR WHITE BOLD	

	 	 @115,030 LABEL Label_ConfirmPassword;
			   VALUE "Confirmação      "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	;
                                             BACKCOLOR BLUE 	;
                                             FONTCOLOR WHITE BOLD	

                             @013,120 TEXTBOX  p_User	;
                                            HEIGHT 25		;                           
                                            VALUE cUser		;                       
                                            WIDTH 120		;                           
                                            FONT "Arial" SIZE 09	

                             @048,120 TEXTBOX  p_password	;
                                            VALUE cPassWord	;          
                                            PASSWORD		;                         
                                            FONT "Arial" SIZE 09	;             
                                            TOOLTIP "Senha de Acesso";
 			  MAXLENGTH 05		;	
			  UPPERCASE		;					
			  ON ENTER  Iif(  Cheka_Senha() ,   Form_Nova_senha.newpassword.SetFocus ,  Form_Nova_senha.p_password.SetFocus )

                             @083,120 TEXTBOX  Newpassword	;
			   VALUE ""                         ;                      
                                            PASSWORD		;                         
                                            FONT "Arial" SIZE 09	;             
                                            TOOLTIP "Digite sua nova senha";
			  MAXLENGTH 05		;	
			  UPPERCASE		;
			  ON ENTER  Iif( ! Empty( Form_Nova_senha.newpassword.Value ) ,  Form_Nova_senha.ConfirmPassword.SetFocus,  Form_Nova_senha.NewPassword.SetFocus )

                             @118,120 TEXTBOX  Confirmpassword;
                                            VALUE ""		;          
                                            PASSWORD		;                         
                                            FONT "Arial" SIZE 09	;             
                                            TOOLTIP "Confirma s senha digitada";
  			  MAXLENGTH 05		;	
			  UPPERCASE		;
			  ON ENTER  Iif( ! Empty( Form_Nova_senha.ConfirmPassword.Value )  ,  Form_Nova_senha.Bt_Confirma.SetFocus,  Form_Nova_senha.ConfirmPassword.SetFocus )

                             @ 160,030 BUTTON Bt_Confirma	;
                                            CAPTION '&Confirma'	;
                                            ACTION Confirma_Troca()	;
                                            FONT "MS Sans Serif" SIZE 09 FLAT

                             @ 160,143 BUTTON Bt_Cancela                   ;
                                             CAPTION '&Cancela'                 ;
			   ACTION Form_Nova_senha.Release	      ;
                                             FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW

	*** Desabilita o TextBox p_user que contém o apelido do usuário ativo
	Form_Nova_senha.p_User.Enabled := .F.

	*** Posiciona o Cursor/Foco no textBox p_passWord
	Form_Nova_senha.p_password.SetFocus

	*** Centraliza janela
	CENTER WINDOW Form_Nova_senha

	*** Ativa Janela
	ACTIVATE WINDOW Form_Nova_senha

	Return Nil

/*
*/
Function Confirma_Troca()

	*** Confirmação da Nova Senha Digitada
	If Form_Nova_senha.NewPassword.Value != Form_Nova_senha.ConfirmPassword.Value
		MsgInfo("Senha de Confirmação Inválida... Redigite!!","Erro na Confirmação da Senha")
		Form_Nova_senha.NewPassword.Value := ""	
		Form_Nova_senha.ConfirmPassword.Value      := ""
		Form_Nova_senha.NewPassword.SetFocus
		Return Nil
	Endif

	*** Solicita ao usuário que confirme a alteração da Senha
	If MsgYesNo( "Confirma Alteração de sua Senha de Acesso?" , SISTEMA )

		*** Bloqueia Registro na Rede
		If BloqueiaRegistroNaRede("Acesso")

			*** Atualiza a Nova senha no Arquivo
			Acesso->Senha := Encripta(  Form_Nova_Senha.NewPassword.Value  )

			*** Desbloqueia registro na Rede
			Acesso->(DBUnlock())

			*** Envia Mensagem ao Usuário
			MsgInfo("Sua senha foi atualizada!!" , SISTEMA )

		Endif	   

	EndIf

	** Efetua Release no Form Nova_Senha
	Form_Nova_Senha.Release

	Return Nil

/*	
*/
Function Cheka_Senha()
	Local lRet := .T.
	
	*** Decripta a Senha do arquivo e compara a Senha do usuário com a senha Digitada
	If Decripta( Acesso->Senha ) != Form_Nova_senha.p_password.Value		
		MsgInfo("Senha de acesso Inválida!!",SISTEMA)		
		lRet := .F.	  
	EndIf			

	Return lRet      