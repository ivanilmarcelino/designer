/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.0851 RELEASE CANDIDATE (RC) 201009 1431"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 5)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 09/10/2020-17:56:55 M�quina: IMA2018 Usu�rio:ivani
    C�digo do m�dulo Form
    ----------------------------------------------------------------------------------------------
    Projeto : ChildFacil
    */

#include <hmg.ch>
Function LoadFrmForm
    Local Form := IdGlobal("Form")
    Load window Form as &(Form)
        &(Form).Center()
    Return Form
    
    

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Form_oButton1_Action(Form )
    &(Form).oRichEdit1.Value := &(Form).oRichEdit1.Value + CRLF + "Titulo:"+&(Form).Title
    Return .T.
