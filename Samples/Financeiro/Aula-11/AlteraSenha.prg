/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.084 RELEASE CANDIDATE (RC) 200924 0918"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 4)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 28/09/2020-18:54:25 Máquina: IMA2018 Usuário:ivani
    Código do módulo Alterasenha
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <sistema.ch>
memvar hAcesso,rs,cn

Function LoadFrmAlterasenha
    Load window Alterasenha as Alterasenha
        Alterasenha.p_user.Enabled := .F.
        Alterasenha.p_User.Value := hAcesso["apelido"]
        Alterasenha.p_password.Setfocus()
        Alterasenha.Center()
    Alterasenha.activate()

    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function AlteraSenha_Bt_Confirma_Action( )
    if empty(AlteraSenha.newPassword.value) 
        AlteraSenha.newPassword.Setfocus()
        Return Nil
    endif
    if AlteraSenha.newPassword.value <> AlteraSenha.ConfirmPassword.Value
        Msginfo("Senha de confirmação é inválida ",SISTEMA)
        AlteraSenha.ConfirmPassword.Setfocus()
        Return Nil
    endif
    
    if Decripta(hAcesso["senha"]) <> AlteraSenha.p_password.Value
        MsgStop("Senha Inválida !",SISTEMA)
        AlteraSenha.p_password.Setfocus()
        Return Nil
    endif
    
    cn:Execute("Update acesso set senha='"+Encripta(AlteraSenha.NewPassword.value)+"' where id="+hb_ntos(hAcesso["coduser"])+";")
    if cn:nReg<=0
        MsgSTop("Não foi possivel trocar a senha !",SISTEMA)
    endif
    AlteraSEnha.Release()
    Return .T.
