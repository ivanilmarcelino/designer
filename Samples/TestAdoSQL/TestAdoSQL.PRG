/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "0.99.23.30 RELEASE CANDIDATE (RC) 210601 1053"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 21.05.0 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.1 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 03/06/2021-09:24:49 M�quina: IMA2018 Usu�rio:ivani
    C�digo M�dulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : TestAdoSQL
    */
#include <SQLAdo.ch>
#include <hmg.ch>
Declare Cursor SQLADO rs
Function Main( vParam )
    /*Configura��o do banco de dados
Caso queira criar sua pr�pria configura��o, basta excluir a linha abaixo e escrever seu c�digo aqui...*/
    #Include <TestAdoSQL.DB>

    (vParam)

    /* Sets inclu�dos pelo Designer
Caso queira fixar sua pr�pria configura��o, basta excluir a linha abaixo.*/
    #Include <TestAdoSQL.CH>

    /*Carregando o formul�rio Principal*/
    Load window TestAdoSQL as Main
    Main.Center

    Main.activate()

    REturn .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oFilter_Action( nPar )
    Local rs.New(),cName:="oFilter"+hb_ntos(nPar)
    Rs.SQL:="Select top 100 * from Municip where nome like '"+Main.&(cName).value+"%' order by nome;"
    rs.Open()
    cName :="oGrid"+hb_ntos(nPar)
    Main.&(cName).DeleteAllItems()
    Main.&(cName).DisableUpdate()
    While !Rs.Eof()
        Main.&(cName).addItem({str(rs.field.cod.value,8),rs.field.nome.value, Padr(hb_TtoC(rs.field.dtUpdate.value,"yyyy-mm-dd hh:mm:ss"),19)})
        rs.MoveNext()
    Enddo
    Main.&(cName).EnableUpdate()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oTimer1_Action( )
    Local rs.new(),nPos:=0,cUF:=""
    Static lActive:=.F.,nStart:=0
    if !lActive
        lActive := .T.
        nStart++
        if Main.oResult.value>0
            cUF := Main.oResult.item(Main.oResult.value)[1]
        endif
        rs.SQL := "Select uf,count(1) as reg from municip group by uf order by uf"
        rs.OPen()
        Main.oResult.DisableUpdate()
        Main.oResult.Deleteallitems()
        While !rs.Eof()
            Main.oResult.AddItem({rs.Field.uf.value,str(rs.field.reg.value,8)})
            if rs.field.uf.value==cUF
                nPos := Main.oResult.Itemcount
            endif
            rs.moveNext()
        enddo
        if nPos >0
            Main.oResult.value := nPos
        endif
        Main.oResult.EnableUpdate()
        Main.oMostra.value := "Result "+hb_ntos(nStart)
        lActive := .F.
    endif
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************

