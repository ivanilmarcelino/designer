/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 21/09/2020-19:01:05 M�quina: IMA2018 Usu�rio:ivani
    C�digo M�dulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <Sistema.ch>

memvar Rs,Cn,hAcesso

Function Main()
    /*Configura��o do banco de dados
Caso queira criar sua pr�pria configura��o, basta excluir a linha abaixo e escrever seu c�digo aqui...*/
    #Include <Financeiro.DB>
    
    Private Rs,cn,hAcesso
    Cn := Connection
    Rs := Recordset
    
    /* Sets inclu�dos pelo Designer
Caso queira fixar sua pr�pria configura��o, basta excluir a linha abaixo.*/
    #Include <Financeiro.CH>

    /*Carregando o formul�rio Principal*/
    Load window Financeiro as Main
    Main.Title := SISTEMA
    Main.StatusBar.Item(4)  := "Esta��o:"+NetName()
    Main.Maximize()
    Main_Onpaint( )
    Main.activate()

    REturn .T.


    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Onpaint( )
    Local nCol2
    Local nRow
    Main.oFundo.Row     := 43
    Main.oFundo.Col     := 0
    Main.oFundo.Width   := Main.Width
    Main.oFundo.Height  := Main.Height
    Main.oFundo.Picture := "Fundo"
 
    
    nCol2 := (Main.width - 185)
    nRow  := (Main.Height - 266)
    
    Main.HL_harbour.Col := nCol2
    Main.HL_harbour.Row := nRow

    nRow += 26
    Main.Hl_MiniGUi.Col := nCol2
    Main.Hl_MiniGUi.row := nRow
    
    nRow +=26
    Main.Hl_MiniGUIBrasil.Col := nCol2
    Main.Hl_MiniGUIBrasil.row := nRow
    
    nRow +=26
    Main.HL_Forum1.Col := nCol2
    Main.HL_Forum1.row := nRow
    
    nRow +=26
    Main.HL_Forum2.Col := nCol2
    Main.HL_Forum2.row := nRow

    nRow +=26
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

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Mn_Usuarios_Action( )
    CadUsuarios()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Mn_Altera_Senha_Action( )
    LoadFrmAlterasenha()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Onrelease( )
    //Encerra as conexoes
    Rs:Close()
    Cn:Close()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function ConfirmaSaida()
    if MsgYesNo("Tem certeza que deseja encerrar ?")
        Main.Release()
    endif
    Return Nil
    
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Form_0nMenu8_Action( )
    LoadFrmSobre()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Bt_Help_Action( )
     LoadFrmSobre()
    Return .T.
