/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 23/09/2020-12:29:24 Máquina: IMA2018 Usuário:ivani
    Clientes.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : Minigui
    */

#include <hmg.ch>

Function LoadFrmClientes()
    Memvar cAlias
    Private cAlias
    Use CADCLI.DBF alias &('c'+Strtran(Time(),':','')) new Shared
    cAlias := Alias()
    Load window Clientes as Clientes
        Clientes.Center()
    Clientes.activate()

    (cAlias)->(DbCloseArea())
    REturn .T.
