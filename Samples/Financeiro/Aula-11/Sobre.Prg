/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.084 RELEASE CANDIDATE (RC) 200924 0918"
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 4)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 28/09/2020-21:32:01 M�quina: IMA2018 Usu�rio:ivani
    C�digo do m�dulo Sobre
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <version.h>

Function LoadFrmSobre
    Load window Sobre as Sobre
        Sobre.oSobre.Value := LoadRtfSobre()
        Sobre.oVersao.Value := "Vers�o : "+VERSION_PRODUCT
        Sobre.center()
    Sobre.activate()

    Return .T.



Static Function LoadRtfSobre()
    #pragma __binarystreaminclude "Sobre.Rtf" | RETURN %s