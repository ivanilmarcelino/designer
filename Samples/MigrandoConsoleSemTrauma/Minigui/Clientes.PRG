/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 23/09/2020-12:29:24 M�quina: IMA2018 Usu�rio:ivani
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
