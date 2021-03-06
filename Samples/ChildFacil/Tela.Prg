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
    �ltima altera��o : 09/10/2020-17:56:07 M�quina: IMA2018 Usu�rio:ivani
    C�digo do m�dulo Tela
    ----------------------------------------------------------------------------------------------
    Projeto : ChildFacil
    */

#include <hmg.ch>
Declare Window &(Frm1)
Declare Window &(Frm2)
Declare Window &(Frm3)

Function LoadFrmTela
    Local Tela := IdGlobal("Tela")
    Local Frm1,Frm2,Frm3
    
    Load window Tela as &(Tela)
        &(Tela).OnRelease := {||&(Frm1).OnInteractiveClose :={||.T.},;
                                &(Frm2).OnInteractiveClose :={||.T.},;
                                &(Frm3).OnInteractiveClose :={||.T.},;
                                &(Frm1).Release(),&(Frm2).Release(),&(Frm3).Release()}

        Frm1 := LoadFrmForm()
        Frm2 := LoadFrmForm()
        Frm3 := LoadFrmForm()
        
        &(Frm1).OnInteractiveClose := {||&(Frm1).Hide(),.F.}
        &(Frm2).OnInteractiveClose := {||&(Frm2).Hide(),.F.}
        &(Frm3).OnInteractiveClose := {||&(Frm3).Hide(),.F.}
        
        &(Tela).oButton1.Action := {||&(Frm1).Show()}
        &(Tela).oButton2.Action := {||&(Frm2).Show()}
        &(Tela).oButton3.Action := {||&(Frm3).Show()}
        
        &(Frm1).Title := "Form 1 "+cStr(DateTime())
        &(Frm2).Title := "Form 2 "+cStr(DateTime())
        &(Frm3).Title := "Form 3 "+cStr(DateTime())
        
        &(Tela).Center()

    Activate window &(Tela),&(Frm1),&(Frm2),&(Frm3)

    Return .T.
