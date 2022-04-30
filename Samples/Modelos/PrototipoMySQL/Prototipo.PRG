/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.29.0 RELEASE CANDIDATE (RC) 220421 1104
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.03.3 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 23/04/2022-10:18:52 Máquina: IMA2018 Usuário:Ivanil
    Código Módulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Prototipo de Uso Geral
    */

#include <hmg.ch>
#include <version.h>

Function Main( vParam )
    /*Configuração do banco de dados
Caso queira criar sua própria configuração, basta excluir a linha abaixo e escrever seu código aqui...*/
    #Include <Prototipo.DB>

    (vParam)

    /* Sets incluídos pelo Designer
Caso queira fixar sua própria configuração, basta excluir a linha abaixo.*/
    #Include <Prototipo.CH>
    
    //vamos definir cargo do App como Hash, desta forma o uso é ilimitado
    //Hash está diretamente ligado a Json; principal metodo de troca de dados usado atualmente entre as interfaces
    App.Cargo := hash()
    
    /*Carregando o formulário Principal*/
    Load window Prototipo as Main
        //version.ch gerado a partir do projeto
        Main.Statusbar.item(1) := VERSION_PRODUCT
    //Login
    LoadFrmFrmlogin()
    
    Main.Maximize()

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
