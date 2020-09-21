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
#Include "F_sistema.ch"
/*
*/
Function Main()      		
             
	SET DATE BRITISH
	SET CENTURY ON             
	SET DELETE ON   

	Cria_File_ini()		

	DEFINE WINDOW Form_0		;
		AT 0,0			;
		WIDTH 640 HEIGHT 480	;
		TITLE SISTEMA		;
		ICON 'ICONE01'		;
		MAIN			;
		NOMAXIMIZE		;
		FONT 'Arial' SIZE 10		;
		BACKCOLOR GRAY		;
		ON INIT Ambiente_Inicial()	;
		ON RELEASE Abandona_Sistema()

		ON KEY ALT+C ACTION Clientes()
		ON KEY ALT+C ACTION Fornecedores()
		ON KEY ALT+T ACTION AcessoAoSistema()		

		DEFINE MAIN MENU 
			POPUP '&Sistema'               
				ITEM 'Contas à &Pagar'  ACTION ContasPagar() NAME Mn_Pagar				
				ITEM 'Contas à Receber' ACTION ContasReceber() NAME Mn_Receber
				SEPARATOR
				ITEM '&Clientes        '     ACTION Clientes() NAME Mn_Clientes
				ITEM '&Fornecedores'      ACTION Fornecedores() NAME Mn_Fornecedores
				SEPARATOR
				POPUP '&Tabelas de Apoio'
					ITEM 'Contas &Financeiras' ACTION CadastroGenerico( "Contas"    ,  "Cadastro de Contas Financeiras"   )  NAME Mn_Contas
					ITEM '&Grupos de Contas  ' ACTION CadastroGenerico( "Grupos" ,  "Cadastro de Grupos de Contas")  NAME Mn_Grupos
					ITEM '&Centros de Custos ' ACTION CadastroGenerico( "Custos"  ,  "Cadastro de Centros de Custo" )  NAME Mn_Custos
				END POPUP	
				SEPARATOR
				POPUP '&Usuários'   
					ITEM 'Cadastros dos &Usuários' ACTION Usuarios() NAME Mn_Usuarios					
					SEPARATOR
					ITEM '&Altera Senha Usuário Atual' ACTION  AlteraSenha() NAME Mn_Altera_Senha   
				END POPUP
				SEPARATOR				
				ITEM '&Troca Usuário' ACTION AcessoAoSistema()
				SEPARATOR 
				POPUP '&Utilitários e Configurações'   
					ITEM 'Inde&xação do Sistema' ACTION Indexa() NAME Mn_Indexar
					SEPARATOR
					ITEM '&Altera Senha Usuário Atual' ACTION  AlteraSenha() NAME Mn_Altera_Senha   
				END POPUP
				SEPARATOR
				ITEM '&Sair'  ACTION  Confirmar_Saida()
			END POPUP
			POPUP '&Help'
				ITEM '&About' ACTION Sobre_o_Sistema()
			END POPUP
		END MENU

		DEFINE CONTEXT MENU
		 	ITEM 'Contas à &Pagar' ACTION ContasPagar()
		 	ITEM 'Contas à &Receber' ACTION ContasReceber()
			SEPARATOR
			ITEM '&Clientes'		ACTION Clientes() 
			ITEM '&Fornecedores'	ACTION Fornecedores()
			SEPARATOR
			ITEM 'Contas &Financeiras' ACTION CadastroGenerico( "Contas"    ,  "Cadastro de Contas Financeiras"   )
			ITEM '&Grupos de Contas ' ACTION CadastroGenerico( "Grupos" ,  "Cadastro de Grupos de Contas")
			ITEM '&Centros de Custos' ACTION CadastroGenerico( "Custos"  ,  "Cadastro de Centros de Custo" )  
			SEPARATOR
			ITEM 'Alterar &Usuário Ativo'	ACTION AcessoAoSistema()		
			ITEM 'Alterar &Senha'	ACTION AlteraSenha()
			SEPARATOR
			ITEM 'Sair'   ACTION Confirmar_Saida()
		END MENU

		DEFINE STATUSBAR FONT 'Verdana' SIZE 7	
			STATUSITEM "Base de Dados: "+BaseDeDados() WIDTH 150
			STATUSITEM "Status: "+Iif( ServidorDeDados() == "SIM" , "SERVIDOR", "TERMINAL" ) WIDTH 115
			STATUSITEM "Usuário: " WIDTH 100	
			STATUSITEM "Rede: "+AllTrim( NetName() ) WIDTH 150	
			CLOCK
		END STATUSBAR

	 	 @380,010 LABEL Label_Mensagens	;
			   VALUE "Linha Livre para Mensagens do Sistema";
			   WIDTH 550		;
			   HEIGHT 25		;
			   FONT "Arial" SIZE 08	;
                                             BACKCOLOR GRAY 	;
                                             FONTCOLOR WHITE BOLD	

		@ 004,005 BUTTON Bt_Clientes		;
				 PICTURE 'Clientes'	;
				 ACTION  Clientes()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Cadastro dos Cientes'

		@ 004,045 BUTTON Bt_Fornecedores		;
				 PICTURE 'Forneced'	;
				 ACTION  Fornecedores()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Cadastro dos Fornecedores'

		@ 004,085 BUTTON Bt_Pagar		;
				 PICTURE 'Pagar'		;
				 ACTION ContasPagar()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Arquivo de Contas à Pagar'

		@ 004,125 BUTTON Bt_Receber		;
				 PICTURE 'Receber'	;
				 ACTION  ContasReceber()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Arquivo de Contas à Receber'

		@ 004,165 BUTTON Bt_Tabelas_Grupos  ;
				 PICTURE 'Grupos';
				 ACTION  CadastroGenerico( "Grupos" ,  "Grupos de Contas") ;
				 WIDTH 40 HEIGHT 27 ;
				 TOOLTIP 'Cadastro dos Grupos de Contas'        
  
		@ 004,205 BUTTON Bt_Tabelas_Contas  ;
				 PICTURE 'Tipos';
				 ACTION  CadastroGenerico( "Contas" ,  "Contas Financeiras") ;
				 WIDTH 40 HEIGHT 27 ;
				 TOOLTIP 'Cadastro das Contas Financeiras'

		@ 004,245 BUTTON Bt_Tabelas_Custos  ;
				 PICTURE 'Custos';
				 ACTION  CadastroGenerico( "Custos" ,  "Centros de Custo") ;
				 WIDTH 40 HEIGHT 27 ;
				 TOOLTIP 'Cadastro dos Centros de Custo'          

		@ 004,510 BUTTON Bt_Acesso			;
				 PICTURE 'Acesso'		;
				 ACTION  AcessoAoSistema()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Trocar Usuário Ativo'         

		@ 004,550 BUTTON Bt_Sair			;
				 PICTURE 'Sair'		;
				 ACTION  Confirmar_Saida()	;
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Sair do Sistema'   
  
		@ 004,590 BUTTON Bt_Help		;
				 PICTURE 'HELP'		;
				 ACTION  Sobre_o_Sistema();
				 WIDTH 40 HEIGHT 27	;
				 TOOLTIP 'Sobre o Sistema'	               

		*** Links ***
		@ 280,210 LABEL            LB_Harbour VALUE "Projeto Harbour:" FONT 'Arial' SIZE 09 AUTOSIZE BACKCOLOR GRAY
		@ 280,360 HYPERLINK    HL_harbour  VALUE "http://www.harbour-project.org"  FONT 'Arial' SIZE 09  AUTOSIZE ;
				           ADDRESS "http://www.harbour-project.org/" ;
				           TOOLTIP "Site oficial do Projeto Harbour" BACKCOLOR GRAY

		@ 300,210  LABEL           LB_MiniGUi VALUE 'Minigui - Site Oficial: ' FONT 'Arial' SIZE 09  AUTOSIZE BACKCOLOR GRAY
		@ 300,360 HYPERLINK    HL_MiniGUI  VALUE 'www.geocites.com/harbourminigui'  FONT 'Arial' SIZE 09 AUTOSIZE;
				           ADDRESS "http://www.geocities.com/harbourminigui";
				           TOOLTIP 'Site oficial MiniGUI'  BACKCOLOR GRAY

		@ 320,210  LABEL           LB_MiniGUIBrasil VALUE 'Minigui Brasil: ' FONT 'Arial' SIZE 09  AUTOSIZE BACKCOLOR GRAY
		@ 320,360 HYPERLINK    HL_MiniGUIBrasil VALUE "www.geocites.com/harbourminas"  FONT 'Arial' SIZE 09 AUTOSIZE ;
				           ADDRESS "http://www.geocities.com/harbourminas";
				           TOOLTIP 'Página MiniGUI Brasil'  BACKCOLOR GRAY

		@ 340,210  LABEL            LB_Forum1 VALUE 'Fórum Harbour / MiniGUI'  FONT 'Arial' SIZE 09 AUTOSIZE BACKCOLOR GRAY
		@ 340,360 HYPERLINK     HL_Forum1 VALUE 'http://groups.yahoo.com/group/harbourminigui/' FONT 'Arial' SIZE 09 AUTOSIZE;
				            ADDRESS "http://groups.yahoo.com/group/harbourminigui/";
				            TOOLTIP 'Fórum de discussão Harbour / MiniGUI'  BACKCOLOR GRAY

		@ 360,210  LABEL            LB_Forum2 VALUE 'Fórum MiniGUI Brasil'  FONT 'Arial' SIZE 09 AUTOSIZE BACKCOLOR GRAY
		@ 360,360 HYPERLINK     HL_Forum2 VALUE 'http://groups.yahoo.com/group/miniguibrasil/' FONT 'Arial' SIZE 09 AUTOSIZE;
				            ADDRESS "http://groups.yahoo.com/group/miniguibrasil/";
				            TOOLTIP 'Fórum de discussão Harbour / MiniGUI Brasil'  BACKCOLOR GRAY

		@ 380,210  LABEL            LB_Guides1 VALUE 'MiniGUI Visual Designers'  FONT 'Arial' SIZE 09 AUTOSIZE BACKCOLOR GRAY
		@ 380,360 HYPERLINK     HL_Guides2 VALUE 'http://www.geocities.com/harbour_links/' FONT 'Arial' SIZE 09 AUTOSIZE;
				            ADDRESS "http://www.geocities.com/harbour_links/";
				            TOOLTIP 'MiniGUI Visual Designers' BACKCOLOR GRAY

	END WINDOW	

	Form_0.Label_Mensagens.Visible := .F.

	CENTER WINDOW Form_0
	ACTIVATE WINDOW Form_0
	Return Nil					

*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Função		: Ambiente_Inicial()
* Finalidade	: Quando o Aplicativo é iniciado, automaticamente é desviado para esta função através da Cláusula
*		: ON INIT definida no Form_0 .
*		: Nesta função o sistema verifica se o aplicativo foi desligado corretamente.
*		: Esta verificação só ocorre se a Cópia estiver configurada como Servidor=SIM no arquivo FINANC.INI
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Ambiente_Inicial()		

	If ServidorDeDados() == "SIM"  .And.  Saida_Irregular() != "SIM" 

		LinhaDeStatus('Saída Irregular do Sistema!!')

		If  MsgYesNo(PadC("*** Sistema Controle Financeiro V.1.0 ***",60)+QUEBRA+;
			PadC(" ",30)+QUEBRA+;
			PadC(" *** Saída Irregular do Sistema ***",60)+QUEBRA+;
			PadC(" ",30)+QUEBRA+;
			PadC(" O Sistema não foi Desligado Corretamente!!",60)+QUEBRA+;
			PadC(" É aconselhável efetuar a Indexação do Sistema!!",60)+QUEBRA+;
			PadC(" ",30)+QUEBRA+;
			PadC(" INICIA indexação Agora??",60)+QUEBRA+;
			PadC("",60) , SISTEMA )		
			
			AcessoOpen()			

			Indexa()	

			LinhaDeStatus()

		EndIf		

	EndIf

	Status_Entrada_Saida("NAO")

	AcessoAoSistema()
	
	Return Nil

/*
*/
Function Confirmar_Saida()
	If MSGYesNo( "Confirma Saída do Sistema??" , SISTEMA )
	   Form_0.Release
	EndIf
	Return Nil

/*
*/
Function Abandona_Sistema()
             Status_Entrada_Saida("SIM")
             Close All	
             Return Nil
/*
*/
Function Sobre_o_Sistema()
         PlayExclamation()
         MsgINFO (PadC("*** Sistema Controle Financeiro V.1.0 ***",60)+QUEBRA+;
                  PadC(" Sistema Freeware - Contribuição ao Projeto Harbour/MiniGUI",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Humberto Fornazier  hfornazier@brfree.com.br",60)+QUEBRA+;
                  PadC(" www.geocities.com/harbourminas",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Desenvolvido com Harbour Compiler (MiniGUI Distribution) 2003.05.03 (Flex)",60)+QUEBRA+;
                  PadC(" Copyright 1999-2003, http://www.harbour-project.org/",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC("Harbour MiniGUI R.62a Copyright 2002-2003",60)+QUEBRA+;
                  PadC("Minigui / Roberto Lopez / Arqentina",60)+QUEBRA+;
                  PadC("roblez@ciudad.com.ar  /  www.geocities.com/harbour_minigui",60) , SISTEMA)
	    Return NIL
*---------------------------------------------------------------------------------------- Prgs --------------------------------------------------------------------------------*
#Include "F_funcoes.prg"
#Include "F_login.prg"
#Include "F_usuarios.prg"
#Include "F_datas.prg"
#Include "F_cadgen.prg"
#Include "F_fornecedores.prg"
#Include "F_clientes.prg"
#Include "F_pagar.prg"
#Include "F_receber.prg"
