/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.22.0 RELEASE CANDIDATE (RC) 220301 1913
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.01.4 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 04/03/2022-22:28:04 Máquina: IMA2018 Usuário:Ivanil
    Código Módulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Gui
    */

#include <hmg.ch>
Function Main( vParam )
    /*Configuração do banco de dados
Caso queira criar sua própria configuração, basta excluir a linha abaixo e escrever seu código aqui...*/
    #Include <Gui.DB>

    (vParam)

    /* Sets incluídos pelo Designer
Caso queira fixar sua própria configuração, basta excluir a linha abaixo.*/
    #Include <Gui.CH>

    /*Carregando o formulário Principal*/
    Load window Gui as Main
    Main.Center

    Main.activate()

    REturn .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main2_Action( )
    LoadFrmFunca1()
    Return .T.


    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main3_Action( )
    LoadFrmFunca2()
    Return .T.
