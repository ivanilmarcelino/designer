/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.084 RELEASE CANDIDATE (RC) 200924 0918"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 4)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 24/09/2020-12:14:01 Máquina: IMA2018 Usuário:ivani
    Código do módulo Apoio
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <SISTEMA.CH>

Memvar cOrigem,lNovo,Rs,Cn,hAcesso

Function CadastroApoio(cApoio,cTitulo)
    Private cOrigem := substr(cApoio,1,2)
    Private lNovo   := .F.
    
    Load Window Pesquisa as PesquisaApoio
        PesquisaApoio.Title := cTitulo
        
        PesquisaApoio.Grid.OndblClick     := {||LoadFrmApoio(2)}
        PesquisaApoio.TxtPesquisa.OnEnter := {||Pesquisa()}
        PesquisaApoio.Novo.Action         := {||LoadFrmApoio(1)}
        PesquisaApoio.Editar.Action       := {||LoadFrmApoio(2)}
        PesquisaApoio.Excluir.Action      := {||Excluir()}
        PesquisaApoio.oReport.Action      := {||PesquisaApoio_oReport_Action()}
        
        PesquisaApoio.TxtPesquisa.Setfocus()
        RenovaPesquisa("")
        
        PesquisaApoio.Center()
        
    PesquisaApoio.Activate()
    Return Nil
    ***********************************************************************************************************
Static Function LoadFrmApoio(nTipo)
    Local aItem := PesquisaApoio.Grid.Item(PesquisaApoio.Grid.Value)
    
    lNovo := IIF(nTipo=1,.T.,.F.)
    
    if nTipo=2 .and. val(aItem[1])=0
        MsgInfo("Nenhum registro selecionado !",SISTEMA)
        Return NIl
    Endif
    Load window Apoio as Apoio
        Apoio.Title := PesquisaApoio.Title
        if !lNovo
            Rs:SQL := "Select Tabelas.*,Acesso.Apelido from Tabelas left join Acesso on tabelas.id_usuario=acesso.id where Tabelas.id="+aItem[1]+";"
            Rs:Open()
            if !Rs:Eof()
                Apoio.Codigo.Value    := hb_ntos(Rs:Fields["id"]:value)
                Apoio.Descricao.Value := Rs:Fields["descricao"]:value
                Apoio.DtUpdate.Value  := xDate(Rs:Fields["dtUpdate"]:value)
                Apoio.Usuario.Value   := hb_ntos(Rs:Fields["id_usuario"]:value)+"-"+Tipovar(Rs:Fields["apelido"]:value)
                Apoio.Dtcad.Value     := xDate(Rs:Fields["dtcad"]:value)
                Apoio.oCheck.Value    := Rs:Fields["ativo"]:value
            Endif
        endif
        Apoio.StatusBar.Item(1) := IF(nTipo=1,"Incluindo Registro em ","Alterando Registro em ")+Apoio.Title
        
        Apoio.Codigo.Enabled := .F.
        Apoio.Descricao.Setfocus()
        Apoio.Center()
    Apoio.activate()
    Return .T.
    ***********************************************************************************************************
Static Function Excluir()
    Local aItem := PesquisaApoio.Grid.Item(PesquisaApoio.Grid.Value)
    if !hAcesso["excluir"]
        MsgNo("EXCLUIR")
        Return Nil
    endif
    if Val(aItem[1])=0
        MsgInfo("Nenhum Reistro informado para exclusão ",SISTEMA)
        Return Nil
    endif
    if MsgYesNo("Tem certeza que deseja excluir o registro <"+aItem[1]+"-"+aItem[2]+"> ?",SISTEMA)
        if cn:Execute("Delete from Tabelas where id="+aItem[1]+";")
            if cn:nReg<=0
                MsgStop("Registro não pode ser excluído !",SISTEMA)
            endif
        endif
        RenovaPesquisa(aItem[2])
    endif
    Return Nil
    ***********************************************************************************************************
Static Function Pesquisa()
    Rs:SQL:="Select top "+DEF_MAX_REG+" id,descricao,dtupdate from Tabelas where origem='"+cOrigem+"' and descricao like '"+PesquisaApoio.TxtPesquisa.Value+"%' order by descricao;"
    Rs:Open()

    PesquisaApoio.Grid.DeleteAllItems()
    PesquisaApoio.Grid.DisableUpdate()
    While !Rs:Eof()
        PesquisaApoio.Grid.AddItem({hb_ntos(rs:Fields["id"]:value),Rs:Fields["descricao"]:value,xDate(rs:Fields["dtupdate"]:value)})
        Rs:MoveNext()
    Enddo
    PesquisaApoio.Grid.EnableUpdate()
    PesquisaApoio.TxtPesquisa.Setfocus()
    Return Nil
    ***********************************************************************************************************
Static Function RenovaPesquisa(cNome)
    PesquisaApoio.TxtPesquisa.Value := Substr(cNome,1,10)
    PesquisaApoio.TxtPesquisa.Setfocus()
    Pesquisa()
    Return Nil
    ***********************************************************************************************************
Static Function Salvar()
    Local aItem,cSQL
    if Empty(Apoio.Descricao.Value)
        MsgStop("Descrição não foi informada !",SISTEMA)
        Return Nil
    endif
    if lNovo
        if !hAcesso["incluir"]
            MsgNo("INCLUIR")
            Return Nil
        endif
        lNovo := .F.
        Rs:ReadWrite(.T.)
        Rs:SQL:="Select top 1 * from Tabelas where id=-1;"
        Rs:Open()
        Rs:AddNew()
        Rs:Fields["origem"]:value     := cOrigem
        Rs:Fields["descricao"]:value  := Apoio.Descricao.Value
        Rs:Fields["dtUpdate"]:value   := DataSQL(DateTime())
        Rs:Fields["dtCad"]:value      := DataSQL(DateTime())
        Rs:Fields["id_usuario"]:value := hAcesso["coduser"]
        Rs:Fields["ativo"]:value      := Apoio.oCheck.Value
        if !Rs:MoveNext()
            MsgStop("Registro não pode ser incluido !",SISTEMA)
        endif
        Rs:ReadWrite(.F.)
        Rs:Close()
    Else
        if !hAcesso["alterar"]
            MsgNo("ALTERAR")
            Return Nil
        endif
        
        aItem := PesquisaApoio.Grid.Item(PesquisaApoio.Grid.Value)
        
        cSQL := "Update Tabelas set "
        cSQL += "Descricao='"+Apoio.Descricao.Value+"',"
        cSQL += "DtUpdate="+Rs:DataSQL(DateTime())+","
        cSQL += "Ativo="+IIF(Apoio.oCheck.Value,"1","0")+","
        cSQL += "Id_usuario="+hb_ntos(hAcesso["coduser"])
        cSQL += " Where id="+aItem[1]+" and dtupdate="+Rs:DataSQL(aItem[3])+";"
        if cn:Execute(cSQL)
            if cn:nReg<=0
                MsgInfo("Registro não foi alterado !",SISTEMA)
            endif
        endif
    Endif
    RenovaPesquisa("")
    Apoio.Release()
    Return Nil
    
Static function PesquisaApoio_oReport_Action()
    Local oHtml
    Rs:SQL:="SELECT Tabelas.ID, Tabelas.DESCRICAO as Nome, "+;
            "IIF(Tabelas.ATIVO ,'Sim','Não') as Ativo"+;
            ",Tabelas.DTCAD as [Dt Cadastro], Tabelas.DTUPDATE as Atualização,"+;
            "str( Tabelas.ID_USUARIO)+'-'+ ACESSO.APELIDO as Usuário"+;
            " FROM ACESSO RIGHT JOIN Tabelas ON ACESSO.ID = Tabelas.ID_USUARIO "+;
            "where Tabelas.Origem='"+cOrigem+"';"
    Rs:Open()
    if Rs:Eof()
        Return .F.
    endif
    oHtml := THtmlReport():New()
    oHtml:Rs   := Rs
    oHtml:Title := "<h2>"+PesquisaApoio.Title+"</h2>"
    oHtml:File := PutFile({{"*.HTML","*.HTML"}},"Nome do Arquivo")
    oHTml:Report()
    oHtml:Show()
    Return .T.    
