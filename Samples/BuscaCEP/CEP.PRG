/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.26.0 RELEASE CANDIDATE (RC) 220331 1016
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 22.03.0 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 31/03/2022-21:41:40 M�quina: IMA2018 Usu�rio:Ivanil
    C�digo M�dulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : CEP
    */

#include <hmg.ch>
Function Main( vParam )
    /*Configura��o do banco de dados
Caso queira criar sua pr�pria configura��o, basta excluir a linha abaixo e escrever seu c�digo aqui...*/
    #Include <CEP.DB>

    (vParam)

    /* Sets inclu�dos pelo Designer
Caso queira fixar sua pr�pria configura��o, basta excluir a linha abaixo.*/
    #Include <CEP.CH>

    /*Carregando o formul�rio Principal*/
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
