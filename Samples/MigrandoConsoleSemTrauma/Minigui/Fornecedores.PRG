/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 23/09/2020-13:13:06 Máquina: IMA2018 Usuário:ivani
    Fornecedores.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : Minigui
    */

#include <hmg.ch>

Function LoadFrmFornecedores()
    Memvar cAlias
    Private cAlias
    Use CADFOR.DBF alias &('c'+Strtran(Time(),':','')) new Shared
    cAlias := Alias()
    Load window Fornecedores as Fornecedores
        Fornecedores.Center()
    Fornecedores.activate()

    (cAlias)->(DbCloseArea())
    REturn .T.
