/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 21/09/2020-19:01:05 M�quina: IMA2018 Usu�rio:ivani
    C�digo M�dulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
Function Main( vParam )
    /*Configura��o do banco de dados
Caso queira criar sua pr�pria configura��o, basta excluir a linha abaixo e escrever seu c�digo aqui...*/
    #Include <Financeiro.DB>

    (vParam)

    /* Sets inclu�dos pelo Designer
Caso queira fixar sua pr�pria configura��o, basta excluir a linha abaixo.*/
    #Include <Financeiro.CH>

    /*Carregando o formul�rio Principal*/
    Load window Financeiro as Main
    Main.Center

    Main.activate()

    REturn .T.
