/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 21/09/2020-19:01:05 Máquina: IMA2018 Usuário:ivani
    Código Módulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <Sistema.ch>

memvar Rs,Cn,hAcesso

Function Main()
    /*Configuração do banco de dados
Caso queira criar sua própria configuração, basta excluir a linha abaixo e escrever seu código aqui...*/
    #Include <Financeiro.DB>
    
    Private Rs,cn,hAcesso
    Cn := Connection
    Rs := Recordset
    
    /* Sets incluídos pelo Designer
Caso queira fixar sua própria configuração, basta excluir a linha abaixo.*/
    #Include <Financeiro.CH>

    /*Carregando o formulário Principal*/
    Load window Financeiro as Main
    Main.Center
    Main_Onpaint( )
    Main.activate()

    REturn .T.


    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Onpaint( )
    Local nCol1,nCol2
    Local nRow
 
    Main.Bt_Acesso.Col:= (Main.width-140)
    Main.Bt_Sair.Col  := (Main.width-100)
    Main.Bt_Help.Col  := (Main.width-60)
    
    nCol1 := (Main.width - 411)
    nCol2 := (Main.width - 267)
    nRow  := (Main.Height - 266)
    
    Main.LB_Harbour.Col := nCol1
    Main.LB_Harbour.Row := nRow
    Main.HL_harbour.Col := nCol2
    Main.HL_harbour.Row := nRow

    nRow += 26
    Main.LB_MiniGUi.Col := nCol1
    Main.LB_MiniGUi.row := nRow
    Main.Hl_MiniGUi.Col := nCol2
    Main.Hl_MiniGUi.row := nRow
    
    nRow +=26
    Main.LB_MiniGUIBrasil.Col := nCol1
    Main.LB_MiniGUIBrasil.row := nRow
    Main.Hl_MiniGUIBrasil.Col := nCol2
    Main.Hl_MiniGUIBrasil.row := nRow
    
    nRow +=26
    Main.LB_Forum1.Col := nCol1
    Main.LB_Forum1.row := nRow
    Main.HL_Forum1.Col := nCol2
    Main.HL_Forum1.row := nRow
    
    nRow +=26
    Main.LB_Forum2.Col := nCol1
    Main.LB_Forum2.row := nRow
    Main.HL_Forum2.Col := nCol2
    Main.HL_Forum2.row := nRow

    nRow +=26
    Main.LB_Guides1.Col := nCol1
    Main.LB_Guides1.row := nRow
    Main.HL_Guides2.Col := nCol2
    Main.HL_Guides2.row := nRow

    Main.Label_Mensagens.row  := (Main.Height-109)
    Main.Label_Mensagens.Col  := 0
    Main.Label_Mensagens.width:= Main.Width
    Main.Redraw()
    Return Nil
    

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Onsize( )
     Main_Onpaint( )
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Onmaximize( )
     Main_Onpaint( )
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Oninteractiveclose( )
    Return MsgYesNo("Confirma encerramento do aplicativo?",SISTEMA)

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Oninit( )
    LoadFrmAcesso()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main1_Action( )
    LoadFrmStatus()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Mn_Pagar_Action( )
    LoadFrmPesquisapagrec("P")
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Mn_Receber_Action( )
    LoadFrmPesquisapagrec("R")
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oNMenu_MAIN_Main2_Action( )
    CargaInicial()
    Return .T.
