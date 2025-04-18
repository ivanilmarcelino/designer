/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.29.0 RELEASE CANDIDATE (RC) 220421 1104
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 22.03.3 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 23/04/2022-10:18:52 M�quina: IMA2018 Usu�rio:Ivanil
    C�digo M�dulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Prototipo de Uso Geral
    */

#include <hmg.ch>
#include <version.h>
memvar oServer
Function Main( vParam )
    /*Configura��o do banco de dados
Caso queira criar sua pr�pria configura��o, basta excluir a linha abaixo e escrever seu c�digo aqui...*/
    #Include <Prototipo.DB>
    waitwindow()

    (vParam)

    /* Sets inclu�dos pelo Designer
Caso queira fixar sua pr�pria configura��o, basta excluir a linha abaixo.*/
    #Include <Prototipo.CH>
    
    //vamos definir cargo do App como Hash, desta forma o uso � ilimitado
    //Hash est� diretamente ligado a Json; principal metodo de troca de dados usado atualmente entre as interfaces
    App.Cargo := hash()
    
    /*Carregando o formul�rio Principal*/
    
    Load window Prototipo as Main
    //Login
    LoadFrmFrmlogin()
    
    Main.Maximize()

    TranslateUniversal("Main")
    Main.Statusbar.item(1) := VERSION_PRODUCT
    activate window main,FrmLogin

    REturn .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main19_Action( )
    LoadFrmfrmObjeto()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main12_Action( )
    LoadFrmFrmUsuario()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Function GetToxNo(c)
   Return hb_md5(alltrim(c)+"182f3b425V657z8V9810k11q12R13714A15r16c17A18C19720C21922p23I24D25w26G27528429030631532V")
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Function CloseDatabase()
    //Desativa a confirma��o da tela
    Main.Oninteractiveclose := {||TRUE}
    //Fecha o banco de dados
    if Valtype(oServer)="O"
        oServer:Close()
    endif
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Onrelease( )
    //Chama o Fechamento da base
    CloseDatabase()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Oninteractiveclose( )
    if !Confirma("Tem certeza que deseja encerrar o Sistema?")
        Return .F.
    endif
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Toolbar_1Button1_Action( )
    if Main_Oninteractiveclose( )
        Main.Release()
    endif
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main21_Action( )
    Ini("Translate","Country","BR",,.T.)
    TranslateUniversal("Main")
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main22_Action( )
    Ini("Translate","Country","IT",,.T.)
    TranslateUniversal("Main")
    Return .T.
