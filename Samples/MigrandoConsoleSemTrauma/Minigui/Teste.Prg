/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 23/09/2020-10:32:40 M�quina: IMA2018 Usu�rio:ivani
    C�digo do m�dulo Teste
    ----------------------------------------------------------------------------------------------
    Projeto : Minigui
    */

#include <hmg.ch>
Function LoadFrmTeste(aParam)
    Load window Teste as Teste
        Teste.oRotina.Value   := aParam[1]
        Teste.oUsuario.Value  := aParam[2]
        Teste.oSenha.Value    := aParam[3]
        Teste.oMensagem.Value := aParam[4]
    Teste.activate()

    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Teste_oButton1_Action( )
    Teste.Release()
    Return .T.
