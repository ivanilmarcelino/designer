/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 22/09/2020-16:44:43 Máquina: IMA2018 Usuário:ivani
    Código do módulo Status
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
memvar hAcesso

Function LoadFrmStatus
    Load window Status as Status
    Status.Center()
    Status.activate()

    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Status_Oninit( )
    Status.TITLE :="Status do Usuário: "+hAcesso["apelido"]
    Status.Control_1a.value := ": "+hAcesso["nivel"]
    Status.Control_2a.value := ": "+IIF(hAcesso["incluir"],"SIM","Não")
    Status.Control_3a.value := ": "+IIF(hAcesso["alterar"],"SIM","Não")
    Status.Control_4a.value := ": "+IIF(hAcesso["excluir"],"SIM","Não")
    Status.Control_5a.value := ": "+IIF(hAcesso["relatorio"],"SIM","Não")
    Status.Control_6a.value := ": "+Dtoc(hAcesso["vencimento"])
    Return .T.
