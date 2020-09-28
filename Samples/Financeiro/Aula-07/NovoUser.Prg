/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.084 RELEASE CANDIDATE (RC) 200924 0918"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 4)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 28/09/2020-15:26:31 Máquina: IMA2018 Usuário:ivani
    Código do módulo Novouser
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <sistema.ch>

memvar lNovo,Rs,cn,hAcesso

Function CadUsuarios()
    Private lNovo := .F.
    Load Window Pesquisa as Pesquisa_user
        Pesquisa_user.Title := "Cadastro de Usuários"
        
        Pesquisa_user.grid.OnDblClick     := {||LoadFrmNovoUser(2)}
        Pesquisa_user.TxtPesquisa.OnEnter := {||PesquisaUser()}
        Pesquisa_user.Novo.Action         := {||LoadFrmNovouser(1)}
        Pesquisa_user.Editar.Action       := {||LoadFrmNovouser(2)}
        Pesquisa_user.Excluir.Action      := {||NovoUser_Excluir_Action( )}
        
        Pesquisa_user.Grid.Header(2) := "Apelido"
        Pesquisa_user.Grid.Header(3) := "Nome"
        
        Pesquisa_user.Grid.AddColumn(4,"Update",0,0)
        
        _SetColumnWidth("Grid","Pesquisa_user",2,150)
        _SetColumnWidth("Grid","Pesquisa_user",3,333)
        
        Pesquisa_user.Grid.ColumnWidthLimits := {{30,60},{100,150},{100,333},{0,0}}
        
        RenovaPesquisaUser("")
        
        Pesquisa_user.Center()
    Pesquisa_user.Activate()
    Return Nil
    ********************************************************
Function LoadFrmNovouser(nTipo)
    Local aItem := Pesquisa_user.Grid.Item(Pesquisa_user.Grid.Value)      
    lNovo := IIF(nTipo=1,.T.,.F.)
    if nTipo=2 .and. val(aItem[1])=0
        MsgInfo("Nenhum registro selecionado !",SISTEMA)
        Return Nil
    endif
    
    Load window Novouser as Novouser
        NovoUser.OnINit := {||NovoUser_Oninit(aItem)}
        NovoUser.oSenha.Enabled := (nTipo=2)
        
        NovoUser.center()
    Novouser.activate()

    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function NovoUser_Oninit(aItem )
    Local aStatus 
    NovoUser.txtCodigo.Enabled := .F.
    if !lNovo
        Rs:SQL:="Select * from acesso where id="+aItem[1]+";"
        Rs:Open()
        if !Rs:Eof()
            aStatus := StatusdoUsuario(Rs:Fields["Status"]:value)
            NovoUser.TxtCodigo.Value  :=  hb_ntos(Rs:Fields["id"]:value)
            NovoUser.TxtNivel.Value   :=  aStatus[1]
            NovoUser.TxtNome.Value    :=  Rs:Fields["usuario"]:value
            NovoUser.TxtApelido.Value :=  Rs:Fields["apelido"]:value
            NovoUser.lInclui.Value    :=  aStatus[2]
            NovoUser.lAltera.Value    :=  aStatus[3]
            NovoUser.lExclui.Value    :=  aStatus[4]
            NovoUser.lRel.Value       :=  aStatus[5]
            NovoUser.lInativo.Value   :=  aStatus[6]
            NovoUser.DtVencto.Value   :=  aStatus[7]
        Endif
    else
            NovoUser.TxtNivel.Value   :=  "9"
            NovoUser.DtVencto.Value   := Date()+90
            NovoUser.Excluir.Enabled  := .F.
            NovoUser.Salvar.Enabled   := .F.
    endif
    NovoUser.StatusBar.Item(1) := IIF(lNovo,"Incluindo registro em ","Alterando Registro em ") + Pesquisa_user.Title
    NovoUser.TxtNivel.SEtfocus()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function StatusdoUsuario(cStatus)
    Local aAcesso := {}
    cStatus := Decripta(cStatus)
    AADD(aAcesso, Substr(cStatus,1,1))  //Nivel
    AADD(aAcesso, Substr(cSTatus,2,1)="1") &&Inclusão
    AADD(aAcesso, Substr(cSTatus,3,1)="1") && Alteração
    AADD(aAcesso, Substr(cSTatus,4,1)="1") &&Exclusão
    AADD(aAcesso, Substr(cSTatus,5,1)="1") &&Relatorios
    AADD(aAcesso, Substr(cSTatus,6,1)="1") &&Ativo
    AADD(aAcesso, ctod(substr(cStatus,7,10))) &&Data vencimento da senha
    Return aAcesso
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaUser()
    Rs:SQL:="Select top "+DEF_MAX_REG+" id,apelido,usuario,dtUpdate from acesso where apelido like '"+Pesquisa_User.TxtPesquisa.Value+"%' order by apelido"
    Rs:Open()
    
    Pesquisa_User.Grid.DeleteAllItems()
    Pesquisa_User.Grid.DisableUpdate()
    While !Rs:Eof()
        Pesquisa_User.Grid.AddItem({hb_ntos(rs:Fields["id"]:value),Rs:Fields["apelido"]:value,Rs:Fields["usuario"]:value,xDate(Rs:Fields["dtUpdate"]:value)})
        Rs:MoveNext()
    Enddo
    Pesquisa_User.Grid.EnableUpdate()
    Pesquisa_user.TxtPesquisa.Setfocus()
    Return Nil
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function RenovaPesquisaUser(cNome)
    if Empty(cNome)
        cNome := Pesquisa_user.TxtPesquisa.Value
    endif
    Pesquisa_user.TxtPesquisa.Value := Substr(cNome,1,10)
    Pesquisa_user.TxtPesquisa.Setfocus()
    PesquisaUser()
    Return Nil
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function NovoUser_Salvar_Action( )
    Local aItem :=Pesquisa_user.Grid.Item(Pesquisa_user.Grid.Value)   
    Local cSQL
    if Empty(NovoUser.TxtNome.value)
        MsgInfo("Nome do usuário não informado !",SISTEMA)
        NovoUser.TxtNovo.Setfocus()
        Return .F.
    Endif
    If Empty(NovoUser.TxtApelido.Value) 
        Msginfo("Apelido do usuário não informado !",SISTEMA)
        NovoUser.TxtApelido.Setfocus()
        Return .F.
    endif
    if lNovo
        lNovo := .F.
        cSQL := "Insert into Acesso (Usuario,Apelido,Senha,Status,DtUpdate) Values ("
        cSQL += "'"+NovoUser.TxtNome.Value+"',"
        cSQL += "'"+NovoUser.TxtApelido.Value+"',"
        cSQL += "'"+Encripta("SENHA")+"',"
        cSQL += "'"+CriptografaStatus()+"',"
        cSQL += Rs:DataSQL(DateTime())+")"
    Else
        cSQL := "Update Acesso Set "
        cSQL += "Usuario='"+NovoUser.TxtNome.Value+"',"
        cSQL += "Apelido='"+NovoUser.TxtApelido.Value+"',"
        if NovoUser.oSEnha.Value
            cSQL +="Senha='"+Encripta("SENHA")+"',"
        Endif
        cSQL += "Status='"+CriptografaStatus()+"',"
        cSQL += "DtUpdate="+Rs:DataSQL(DateTime())
        
        cSQL += " Where id="+aItem[1]+" and dtUpdate="+Rs:DataSQL(aItem[4])+";"
    Endif
    if Cn:Execute(cSQL)
        if cn:nReg<=0
            MsgStop("Nenhum registro incluído/alterado ",SISTEMA)
        endif
    endif
    RenovaPesquisaUser()
    NovoUser.Release()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function NovoUser_Excluir_Action( )
    Local aItem :=Pesquisa_user.Grid.Item(Pesquisa_user.Grid.Value)   
    if val(aItem[1]) = 0
        MsgInfo("Nenhum registro informado para exclusão !",SISTEMA)
        Return Nil
    Endif
    if MsgYesNo("Excluir o registro <"+aItem[1]+"-"+aItem[2]+" ?",SISTEMA)
        if cn:Execute("Delete from acesso where id="+aItem[1]+";")
            if cn:nReg<=0
                MsgInfo("Não foi possivel excluir o registro!")
            endif
        endif
    endif
    RenovaPesquisaUser()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function CriptografaStatus()
    Local cSeq := NovoUser.TxtNivel.Value
    cSeq += IIF(NovoUser.lInclui.Value ,"1","0")
    cSeq += IIF(NovoUser.lAltera.Value ,"1","0")    
    cSeq += IIF(NovoUser.lExclui.Value ,"1","0")    
    cSeq += IIF(NovoUser.lRel.Value    ,"1","0")    
    cSeq += IIF(NovoUser.lInativo.Value,"1","0")    
    cSeq += Dtoc(NovoUser.DtVencto.Value)
    Return Encripta(Padr(cSeq,20))
    