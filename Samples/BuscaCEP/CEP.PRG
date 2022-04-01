/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.26.0 RELEASE CANDIDATE (RC) 220331 1016
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.03.0 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 31/03/2022-21:41:40 Máquina: IMA2018 Usuário:Ivanil
    Código Módulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : CEP
    */

#include <hmg.ch>
Function Main( vParam )
    /*Configuração do banco de dados
Caso queira criar sua própria configuração, basta excluir a linha abaixo e escrever seu código aqui...*/
    #Include <CEP.DB>

    (vParam)

    /* Sets incluídos pelo Designer
Caso queira fixar sua própria configuração, basta excluir a linha abaixo.*/
    #Include <CEP.CH>

    /*Carregando o formulário Principal*/
    Load window CEP as Main
    Main.Center

    Main.activate()

    REturn .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oButton1_Action( )
    LoadFrmTabCEP()
    Return .T.
