/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.22.0 RELEASE CANDIDATE (RC) 220301 1913
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 22.01.4 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 04/03/2022-22:43:49 M�quina: IMA2018 Usu�rio:Ivanil
    C�digo do m�dulo Funca1
    ----------------------------------------------------------------------------------------------
    Projeto : Gui
    */

#include <hmg.ch>
Function LoadFrmFunca1
    Local Funca1 := IdGlobal("Funca1")
    Load window Funca1 as &(Funca1)

    /*Por padr�o o Activate est� desabilitado, com isso esse formul�rio pode ser chamado por outro M�dulo
    e tratado externamente, neste caso, embora seja desaconselhado pode ser necess�rio.
    Se for chama-lo de outro c�digo, as fun��es abaixo, dever�o ser p�blicas, retire o Static.
    Lembre-se tamb�m que quando for usar o formul�rio em outro m�dulo, voc� deve declar�-lo no Header=> Declare windowFunca1*/

        &(Funca1).Center()

    &(Funca1).activate()

    Return .T.
