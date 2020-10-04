/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 22/09/2020-16:08:46 Máquina: IMA2018 Usuário:ivani
    Código do módulo Acesso
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <SISTEMA.CH>

memvar Rs,cn, hAcesso

Declare window Main

Function LoadFrmAcesso
    Load window Acesso as Acesso
    Acesso.center()
    Acesso.activate()

    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Acesso_p_User_Onenter( )
    (Iif( ! Empty( Acesso.p_User.Value ) , Acesso.p_Password.SetFocus , Acesso.p_User.SetFocus  ))
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Acesso_p_password_Onenter( )
    (Iif( ! Empty( Acesso.p_password.Value ) ,  Acesso.Bt_Login.SetFocus , Acesso.p_password.SetFocus ))
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Acesso_Bt_Login_Action( )
    Local cUser:= Alltrim(Acesso.p_User.value)
    Local cPass:= Alltrim(Acesso.p_Password.Value)
    Local cRet
    if Empty(cUser)
        MsgInfo("Usuário não Informado!!",SISTEMA)
        Acesso.p_user.Setfocus()
        Return Nil
    Endif
    
    Rs:SQL := "Select * from Acesso where apelido='"+cUser+"';"
    Rs:Open()
    If !Rs:Eof()
        if Decripta(Rs:Fields["senha"]:value) <> cPass
            MsgStop("Senha de acesso inválido!",SISTEMA)
            Acesso.p_Password.setfocus()
            Return NIl
        Endif
    
        cRet := Decripta(Rs:Fields["Status"]:value)
        
        hAcesso := Hb_hash()
        hAcesso["coduser"]    := Rs:Fields["id"]:value
        hAcesso["usuario"]    := Rs:Fields["usuario"]:value
        hAcesso["apelido"]    := Rs:Fields["apelido"]:value
        hAcesso["senha"]      := Rs:Fields["senha"]:value
        hAcesso["nivel"]      := Substr(cRet,1,1)
        hAcesso["incluir"]    := IIF(Substr(cRet,2,1)=="1",.T.,.F.)
        hAcesso["alterar"]    := IIF(Substr(cRet,3,1)=="1",.T.,.F.)
        hAcesso["excluir"]    := IIF(Substr(cRet,4,1)=="1",.T.,.F.)
        hAcesso["relatorio"]  := IIF(Substr(cRet,5,1)=="1",.T.,.F.)
        hAcesso["inativo"]   := IIF(Substr(cRet,6,1)=="1",.T.,.F.)
        hAcesso["vencimento"] := Ctod(Substr(cRet,7,10))
        Main.Statusbar.Item(3) := "Usuário:"+hAcesso["apelido"]
    Else
        Msginfo("Usuario "+cUser+" Não cadastrado!!",SISTEMA)
        Acesso.p_user.setfocus()
        Return Nil
    Endif
    
    if hAcesso["inativo"]
        MsgStop("Usuário está inativo.!!",SISTEMA)
        Acesso.p_user.Value := ""
        Acesso.P_Password.value := ""
        Acesso.p_User.Setfocus()
        Return Nil
    Endif
    
    if hAcesso["nivel"] <> "0"
    
        //Cadastro de usuarios
        Main.Mn_Usuarios.Enabled := .F.
        
        if hAcesso["vencimento"] < Date()
            MsgStop("Senha do Usuário venceu!",SISTEMA)
            Acesso.p_user.Value := ""
            Acesso.P_Password.value := ""
            Acesso.p_User.Setfocus()
            Return Nil
        endif
    Endif
    Acesso.Release()    
    Return .T.
