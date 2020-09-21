/*
* Controle Financeiro - Pequeno Exemplo
* Humberto Fornazier - Maio/2003
* hfornazier@brfree.com.br
* www.geocities.com/harbourminas
*
* Harbour Compiler (MiniGUI Distribution) 2003.05.03 (Flex)
* Copyright 1999-2003, http://www.harbour-project.org/
*
* Harbour MiniGUI R.62a Copyright 2002-2003 Roberto Lopez,
* MINIGUI - Harbour Win32 GUI library - Release 62a - 23/05/2003
* Copyright 2002 Roberto Lopez <roblez@ciudad.com.ar>
* http://www.geocities.com/harbourminigui/
*
* Algumas das telas do sistema foram contruídas com auxilio do
* GUIDES - Release 0.12 for MiniGUI
* Carlos Andres - carlos.andres@navegalia.com
* http://www.geocities.com/harbour_links
*
* Este exemplo é uma contribuição ao Projeto Harbour/MiniGUI  e pode ser modificado e distribuído livremente.
*
* Importante	: Este sistema foi desenvolvido com intensão de auxiliar usuários
*	 	  que utilizem o Harbour e o MiniGUI.   É um projeto apenas para			
*		  estudo dos comandos.   Não deve ser utilizado comercialmente 
*		  por estar sujeito a apresentar possiveis erros não detectados em
*		  testes feitos pelo autor. 
*/
#include "minigui.ch"
#Include "F_Sistema.ch"
/*
*/
Function AcessoAoSistema()          
              Local cUser           := ""
              Local cPassWord  := ""        

	*** Abre Aquivo Acesso.DBF
	AcessoOpen(.F.)

	*** Caso exista apenas UM Usuário cadastrado no Arquivo Acesso.dbf
	If Acesso->(LastRec()) == 1 	

		*** Caso o Unico Usuário cadastrado seja o Usuário Padrão, Mostra uma mensagem para o usuário.
		If AllTrim(Acesso->APELIDO) == "USUARIO" .And. Decripta( Acesso->Senha ) == "SENHA"

			**** Muda Status do Label Mensagens (F_MENU.PRG) para Visivel
			Form_0.Label_Mensagens.Visible := .T.	
			
			**** Coloca a Mensagem no Valor do Label			 
			Form_0.Label_Mensagens.value := "Se você ainda não cadastrou nenhum usuário,  Digite:  USUARIO no campo  USUARIO   e   SENHA no campo  SENHA"

		EndIf

	EndIf

	*** Define Janela do Login Principal ao Sistema
	DEFINE WINDOW Form_acesso ;
		AT 0,0 ;
		WIDTH 280 HEIGHT 160 ;
		TITLE 'Acesso ao Sistema'   MODAL NOSYSMENU BACKCOLOR BLUE                                                          

		@010,030 LABEL Label_User                 ;
			 VALUE "Usuário          "          ;
			 WIDTH 120		    ;
			 HEIGHT 35		    ;
			 FONT "Arial" SIZE 09;
                                           BACKCOLOR BLUE ;
                                           FONTCOLOR WHITE BOLD

	 	 @045,030 LABEL Label_Password	;
			   VALUE "Senha       "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	;
                                             BACKCOLOR BLUE 	;
                                             FONTCOLOR WHITE BOLD	

                             @013,120 TEXTBOX  p_User	;
                                            HEIGHT 25		;                           
                                            VALUE cUser		;                       
                                            WIDTH 120		;                           
                                            FONT "Arial" SIZE 09	;              
			  MAXLENGTH 10		;	
			  UPPERCASE		;	               
			  ON ENTER Iif( ! Empty( Form_acesso.p_User.Value ) , Form_acesso.p_Password.SetFocus , Form_acesso.p_User.SetFocus  )
									
                             @048,120 TEXTBOX  p_password	;
                                            VALUE cPassWord	;          
                                            PASSWORD		;                         
                                            FONT "Arial" SIZE 09	;             
                                            TOOLTIP "Senha de Acesso";
			  MAXLENGTH 05		;
			  UPPERCASE		;
			  ON ENTER  Iif( ! Empty( Form_acesso.p_password.Value ) ,  Form_acesso.Bt_Login.SetFocus , Form_acesso.p_password.SetFocus )

                             @ 090,030 BUTTON Bt_Login                 ;
                                            CAPTION '&Login'                  ;
                                            ACTION Verifica_Login()   ;
                                            FONT "MS Sans Serif" SIZE 09 FLAT

                             @ 090,143 BUTTON Bt_Logoff                   ;
                                             CAPTION '&Cancela'                 ;
                                             ACTION Form_0.Release           ;
                                            FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW

	*** Coloca o Cursor no TEXTBOX p_user
	Form_acesso.p_User.SetFocus

	*** Centraliza janela
	CENTER WINDOW Form_acesso

	*** Ativa janela de Login
	ACTIVATE WINDOW Form_acesso

/*

	cUser		:= Pega o Valor digitado no TextBox p_User
	cPass		:= Pega o Valor digitado no TextBox p_Password
	aStatusDoUsuario	:= {} Array

*/
Function Verifica_Login()
	Local cUser	:= AllTrim(  Form_acesso.p_User.Value        )
	Local cPass	:= AllTrim(  Form_acesso.p_password.Value )
              Local aStatusDoUsuario := {}	

	*** Se o TextBox p_User não foi informado
	If Empty( cUser )
		MsgINFO("Usuário não informado!!",SISTEMA)
		Form_acesso.p_user.SetFocus
		Return Nil
	EndIf   

	*** Posiciona o Arquivo Accesso no Indice 2 - Indexado por Apelido
	Acesso->(DBSetOrder(2))

	*** Se o Apelido digitado em TextBox p_User for encontrado
	If Acesso->(DBSeek( cUser ))	

		*** Decriptografa a Senha do usuário armazenada no arquivo e compara com a senha digitada		
		If Decripta( Acesso->Senha ) != cPass

			*** Se for diferente, envia mensagem e posiciona o cursor no campos p_password
			MsgInfo("Senha de acesso Inválida!!",SISTEMA)
			Form_acesso. p_password .SetFocus
			Return Nil

		EndIf

		** Se a senha for válida,  efetua o release da janela de Login
		Release Form_acesso    

	Else

		** Se o usuário/Apelido não existir, emite mensagem e posiciona o cursor em p_User
		MsgInfo("Usuário: "+cUser+" não Cadastrado!!",SISTEMA)
		Form_acesso.p_User.SetFocus
		Return Nil

	EndIf

	*** A função Status do usuário coloca em uma Array as configurações do usuário ( neste caso a array aStstusDoUsuario )
              aStatusDoUsuario := StatusDoUsuario( Acesso->Codigo ) && Status do Usuário Atual

	*** A Função StatusDoUSuario está em ( F_USUARIOS.PRG )
	*** Obs: a Array contém as configurações na seguintre ordem
	*** 1º Posicão: Níivel do usuário: 0 à  9 - Somente os usuários de níve 0 podem acessar o cadastro de USUARIOS
	*** 2º Posição : Inclusões  no Sistema		.T. ou .F.	 
	*** 3º Posição : Alterações no Sistema	.T. ou .F.	 
	*** 4º Posição : Exclusãoes no Sistema	.T. ou .F.	 
	*** 5º Posição : Emissão de relatórios		.T. ou .F.	 
	*** 6º Posição : Usuário Ativo ou Inativo	.T. ou .F.	 
	*** 7º Posição : Data de Validade da Senha       Cariável tipo Date	 

	*** Se Usuário estiver Inativo, envia mensagem para o usuário, limpa os campos do formulario  e posiicona o cursor em p_User 
              If aStatusDoUsuario[ 6 ]   
                 MsgInfo( "Usuário está Inativo.. Impossível Continuar!!" , SISTEMA )
                 Form_acesso.p_user.Value := ""
                 Form_acesso.p_password .Value := ""
                 Form_acesso.p_user .SetFocus                
	   Return Nil
              EndIf  

	*** Muda o Status do Menu Usuários para Habilitado
	MODIFY CONTROL Mn_Usuarios OF Form_0 ENABLED .T.

              if aStatusDoUsuario[ 1 ] != "0"    && Somente usuários de Nível "0" (Zero) Podem acessar cadastro de Usuários

		*** Se usuário atual não tem Nivel 0 (Zero) Desabilita o menu Usuários
		MODIFY CONTROL Mn_Usuarios OF Form_0 ENABLED .F.	

		*** Se a data de validade é menor que a Data atual do sistema,  envia mensagem para o usuário, limpa os campos do formulario  e posiicona o cursor em p_User 
	              If aStatusDoUsuario[ 7 ] < Date() 
		                 MsgInfo( "Senha do Usuário está Vencida!!. Impossível Continuar!!" , SISTEMA )
		                 Form_acesso.p_user.Value := ""
		                 Form_acesso.p_password .Value := ""
		                 Form_acesso.p_user .SetFocus                
			   Return Nil
		EndIf 

	EndIf 

	*** Efetua Release no formulario de Login
              Form_acesso.Release

	*** Muda Status da linha de mensagens para Invisivel	
	Form_0.Label_Mensagens.Visible := .F.	
          
          	*** Coloca o Apelido do usuário atual na linha de Status do Menu
	Form_0.StatusBar.Item(3) := Acesso->Apelido

	*** Cria uma janela para mostrar ao usuário seuas configurações atuais
	DEFINE WINDOW Form_Status ;
		AT 0,0 ;
		WIDTH 280 HEIGHT 205 ;
		TITLE "Status do Usuário: "+Acesso->Apelido;
                            ICON 'ICONE01';
                            MODAL NOSIZE BACKCOLOR BLUE           

		@010,065 LABEL CONTROL_1	; 
			VALUE "Nível do Usuário"	;
			WIDTH 150		; 
			HEIGHT 15		; 
		              FONT 'ARIAL'  SIZE 9	;
		              BACKCOLOR BLUE	;
		              FONTCOLOR WHITE BOLD

		@010,160 LABEL CONTROL_1a	; 
			VALUE ': ' +aStatusDoUsuario[ 1 ]; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	        
     
		@030,065 LABEL CONTROL_2	; 
			VALUE "Inclusões"	; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD

		@030,160 LABEL CONTROL_2a	; 
			VALUE ": "+ Iif( aStatusDoUsuario[2] , "SIM" , "NÃO")  ; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	        

		@050,065 LABEL CONTROL_3	; 
			VALUE 'Alterações'	; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	        

		@050,160 LABEL CONTROL_3a	; 
			VALUE ": "+Iif( aStatusDoUsuario[3] , "SIM" , "NÃO")  ; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	        

		@070,065 LABEL CONTROL_4	; 
			VALUE 'Exclusões'	; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	        

		@070,160 LABEL CONTROL_4a	; 
			VALUE ': '+Iif( aStatusDoUsuario[4] , "SIM" , "NÃO")  ; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	        

		@090,065 LABEL CONTROL_5	; 
			VALUE 'Relatórios'		; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	; 
			FONTCOLOR WHITE BOLD	   

		@090,160 LABEL CONTROL_5a	; 
			VALUE ': '+Iif( aStatusDoUsuario[5] , "SIM" , "NÃO")  ; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	 

		@110,65 LABEL CONTROL_6	; 
			VALUE 'Senha Vence em'	; 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	   

		@110,160 LABEL CONTROL_6a	; 
			VALUE ': '+DtoC( aStatusDoUsuario[7] ); 
			WIDTH 150 HEIGHT 15	; 
			FONT 'ARIAL'  SIZE 9	;
			BACKCOLOR BLUE	;
			FONTCOLOR WHITE BOLD	   

		@145,095 BUTTON Bt_Fechar	;
			CAPTION '&Fechar'	;
			ACTION Form_Status.Release;
			FONT "MS Sans Serif" SIZE 09 FLAT
	
	END WINDOW

	*** Coloca o Focus no Botão Fechar
              Form_Status.Bt_Fechar.SetFocus                

	*** Centraliza Janela
	CENTER WINDOW Form_Status

	*** Ativa Janela
	ACTIVATE WINDOW Form_Status
	Return Nil

/* 
	Select( AREA )	 = retorna 0 se a área passada como parâmetro NÃO estiver em uso
	BasedeDados()	 = Funcão que retorna local da base de Dados do Sistema / Lê o arquivo FINANC.INI / Função está em F_FUNCOES.PRG
	ArqbBase	 = Concatena a variavel cBase + o Arquivo que será aberto
	aarq		 = Array para criar estrutura do arquivo
*/
FUNCTION AcessoOpen()
  	   Local nArea	:= Select( 'ACESSO' )	
	   Local cBase	:= BaseDeDados()
	   Local ArqBase	:= cBase+"ACESSO.DBF"
	   Local aarq := {}	

	   *** Se a área não estiver em uso
	   If nArea == 0	     

		** Se Não existir o arquivo	
		If ! FILE( ArqBase )			

			** Se não for o Servidor de Dados houve erro no acesso de Rede
			If ServidorDeDados() != "SIM"
				MsgBox("Aquivo de Usuários não Localizado em "+AllTrim(cBase),SISTEMA)
				Release Window ALL
			EndIf
			
			*** Adciona na Array a estrutura do arquivo ACESSO.DBF que será  criado
			Aadd( aarq , { 'CODIGO'	, 'C' , 04 , 0 } )
			Aadd( aarq , { 'USUARIO'	, 'C' , 30 , 0 } )
			Aadd( aarq , { 'APELIDO'	, 'C' , 10 , 0 } )
			Aadd( aarq , { 'SENHA'	, 'C' , 05 , 0 } )
			Aadd( aarq , { 'ACESSO'	, 'C' ,250 , 0 } )
			Aadd( aarq , { 'STATUS'	, 'C' ,20  , 0 } )		                    

			*** Cria o Arquivo
			DBCreate     (  (ArqBase)   , aarq )

			*** Abre o arquivo Acesso.DBF na próxima área disponível em modo de compartilhamento
			USE (ArqBase) Alias ACESSO NEW SHARED 

			*** Quando o arquivo é criado, cria-se também um usuário Padrão
			ACESSO->(DBappend())
			ACESSO->CODIGO  := '0001'
			ACESSO->USUARIO := 'USUARIO'
			ACESSO->APELIDO := 'USUARIO'
			ACESSO->SENHA   := Encripta( 'SENHA' )
			ACESSO->STATUS  := Encripta( '011110'+DtoC( Date( )+90) )
		
			** Fecha Arquivo
			ACESSO->(DBCloseArea())

			*** Funcão Encripta está no PRG F_Funcoes.Prg
			*** STATUS =  São seis posiçoes que podem ser 0 (Zero)  ou  1 (UM) - exceto a primeira que pode ir até 09 (NOVE)
			*** 1º Posicão: Níivel do usuário: 0 à  9 - Somente os usuários de níve 0 podem acessar o cadastro de USUARIOS
			*** 2º Posição : Inclusões  no Sistema		1 = SIM   0 = NÃO.
			*** 3º Posição : Alterações no Sistema	1 = SIM   0 = NÃO
			*** 4º Posição : Exclusãoes no Sistema	1 = SIM   0 = NÃO
			*** 5º Posição : Emissão de relatórios		1 = SIM   0 = NÃO
			*** 6º Posição : Usuário Ativo ou Inativo	1 = SIM   0 = NÃO			 
			*** 7º Posição : Data de Validade da Senha       90 Dias após a criação		

		Endif	         

		** Abre Arquivo Acesso.DBF na próxima área disponível em modo de compartilhamento
		Use (ArqBase) Alias ACESSO New Shared                  

		*** Se não existir o Arquivo Acesso1.NTX, cria.
		If ! File( cBase+'ACESSO1.NTX' )
			Index ON CODIGO To (cBase)+"Acesso1"
		EndIf

		*** Se não existir o Arquivo Acesso1.NTX, cria.
		If ! FIle(cBase+'ACESSO2.NTX' )
			Index ON APELIDO To (cBase)+"Acesso2"
		Endif

		*** Limpa todas as seleções de Indices na Área para reposicioná-los
		Acesso->(DBCLearIndex())
		Acesso->(DBSetIndex(cBase+'ACESSO1'))
		Acesso->(DBSetIndex(cBase+'ACESSO2'))
	   
	   Endif
                 Return Nil