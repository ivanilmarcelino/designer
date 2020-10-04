/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.084 RELEASE CANDIDATE (RC) 200924 0918"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 4)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 28/09/2020-21:32:01 Máquina: IMA2018 Usuário:ivani
    Código do módulo Sobre
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <version.h>

Function LoadFrmSobre
    Load window Sobre as Sobre
        Sobre.oSobre.Value := LoadRtfSobre()
        Sobre.oVersao.Value := "Versão : "+VERSION_PRODUCT
        Sobre.center()
    Sobre.activate()

    Return .T.



Static Function LoadRtfSobre()
    #pragma __binarystreaminclude "Sobre.Rtf" | RETURN %s