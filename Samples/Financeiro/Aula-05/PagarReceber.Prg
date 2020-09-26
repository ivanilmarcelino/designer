/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.084 RELEASE CANDIDATE (RC) 200924 0918"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 4)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 25/09/2020-14:01:52 Máquina: IMA2018 Usuário:ivani
    Código do módulo Pagarreceber
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <SISTEMA.CH>

memvar Flag_P_R, lNovo,Rs,Cn,hAcesso

Declare Window PesquisaPagRec

Function LoadFrmPagarreceber(nTipo)
    Local aItem := PesquisaPagRec.Grid.Item(PesquisaPagRec.Grid.Value)
    Private lNovo := IIF(nTipo=1,.T.,.F.)

    if nTipo=2 .and. val(aItem[1])=0
        MsgSTop("Nenhum registro informado para Edição !",SISTEMA)
        REturn Nil
    Endif
    
    Load window Pagarreceber as Pagarreceber
        if Flag_P_R="R"
            Pagarreceber.Title := "Contas a Receber"
            PagarReceber.lb_Fornecedor.Value := "Cliente"
        Else
            Pagarreceber.Title := "Contas a Pagar"
        Endif
        PagarReceber.StatusBar.Item(1) := IIF(nTipo=1,"Incluindo registro em ","Alterando Registro em ")+PagarReceber.Title
        
        PagarReceber.TxtDiferenca.Value := IIF(Empty(PesquisaPagRec.Dp_Data2.Value), 0 , (PagarReceber.TxtValorPago.Value-PagarReceber.TxtValor.Value))
        PagarReceber.TxtDiferenca.Enabled := .F.
        PagarReceber.cb_CliForn.SetFocus()
        if lNovo
            PagarReceber.Excluir.Enabled := .F.
        endif
        PagarReceber.Center()
    Pagarreceber.activate()

    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PagarReceber_Oninit( )
    Local aItem := PesquisaPagRec.Grid.Item(PesquisaPagRec.Grid.Value)
    if !lNovo
        Rs:SQL:="Select id,Hist,Docto,dtVen,dtPag,valor,valorP,Dtcad,dtUpdate,usuario,apelido,nome,id_cliforn,nomeConta,id_Conta,NomeGrupo,Id_grupo,NomeCusto,Id_custo "
        Rs:SQL+=" from QueryPagarReceber where id="+aItem[1]
        Rs:Open()
        if !Rs:Eof()
            PagarReceber.Lb_Codigo.Value     := hb_ntos(Rs:Fields["id"]:value)
            PagarReceber.TxtHistorico.Value  := Rs:Fields["hist"]:value
            PagarReceber.TxtDocumento.Value  := Rs:Fields["docto"]:value
            PagarReceber.Dp_Vencto.Value     := Rs:Fields["dtVen"]:value
            PagarReceber.Dp_Pagto.Value      := Rs:Fields["dtPag"]:value
            PagarReceber.TxtValor.Value      := Rs:Fields["valor"]:value
            PagarReceber.TxtValorPago.Value  := Rs:Fields["valorP"]:value
            
            PagarReceber.Lb_Data_Cad2.Value  := Rs:Fields["DtCad"]:value
            PagarReceber.Lb_ult_Alt2.value   := Rs:Fields["DtUpdate"]:value
            PagarReceber.Lb_usuario2.value   := hb_ntos(Rs:fields["usuario"]:value)+"-"+Rs:fields["apelido"]:value
            
            PagarReceber.cb_Cliforn.AddItem(Rs:Fields["nome"]:value)
            PagarReceber.cb_Cliforn.Cargo :={Rs:Fields["id_cliforn"]:value}
            PagarReceber.cb_Cliforn.Value :=1
            
            
            PagarReceber.cb_conta.addItem(rS:Fields["nomeConta"]:value)
            PagarReceber.cb_conta.Cargo := {Rs:Fields["id_conta"]:Value}
            PagarReceber.cb_conta.Value := 1
            
            PagarReceber.cb_grupo.AddItem(Rs:Fields["NomeGrupo"]:value)
            PagarReceber.cb_grupo.Cargo := {Rs:Fields["id_grupo"]:value}
            PagarReceber.cb_grupo.Value := 1
            
            PagarReceber.cb_custo.AddItem(Rs:Fields["nomeCusto"]:value)
            PagarReceber.cb_custo.Cargo := {Rs:Fields["id_Custo"]:value}
            PagarReceber.cb_custo.Value := 1
        Endif
    endif
    Return Nil

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PagarReceber_Salvar_Action( )
    Local cSQL,cMsg:="",cFocu:=""
    if PagarReceber.Cb_CliForn.Value=0
        if Flag_P_R="P"
            cMsg += "Informe o fornecedor !"+CRLF
        else
            cMsg+= "Informe o Cliente !" + CRLF
        endif
        cFocu := IIF(Empty(cFocu),"Cb_CliForn",cFocu)
    endif
    
    if Empty(PagarReceber.Dp_Vencto.Value )
        cMsg += "Data de Vencimento não foi informada !"+CRLF
        cFocu := IIF(Empty(cFocu),"Dp_Vencto",cFocu)
    endif
    
    if PagarReceber.TxtValor.value=0
        cMsg += "Valor do documento não foi informado !" + CRLF
        cFocu:=IIF(empty(cFocu),"TxtVAlor",cFocu)
    endif
    
    if PagarReceber.cb_Conta.Value=0
        cMsg += "Informe a Conta !"+CRLF
        cFocu := IIF(Empty(cFocu),"cb_conta",cFocu)
    endif
    
    if PagarREceber.cb_Grupo.value=0
        cMsg += "Informe o Grupo !"+CRLF
        cFocu := IIF(Empty(cFocu),"cb_grupo",cFocu)
    endif
    
    if PagarREceber.cb_custo.value=0
        cMsg += "Informe o Custo !"+CRLF
        cFocu := IIF(Empty(cFocu),"cb_custo",cFocu)
    endif
    
    if !Empty(cMsg)
        MsgSTop(cMsg,SISTEMA)
        PagarReceber.&(cFocu).Setfocus()
        Return Nil
    Endif
    
    if lNovo
        if !hAcesso["incluir"]
            MsgNo("INCLUIR")
            Return Nil
        endif
        lNovo := .F.
        cSQL := "Insert into  PagarReceber (Origem,Id_Cliforn,Hist,Docto,Tipo,Id_Conta,Id_Grupo,Id_custo,DtVen,DtPag,Valor,ValorP,DtUpdate,Usuario,DtCad) Values ("
        cSQL += "'"+FLAG_P_R+"',"
        cSQL += hb_ntos(PagarReceber.cb_CliForn.Cargo[PagarReceber.cb_CliForn.Value])+","
        cSQL += "'"+PagarReceber.TxtHIstorico.Value+"',"
        cSQL += "'"+PagarReceber.TxtDocumento.Value+"',"
        cSQL += IIF(Empty(PagarReceber.dp_Pagto.value),"0","1")+","
        cSQL += hb_ntos(PagarReceber.cb_Conta.Cargo[PagarReceber.cb_Conta.value])+","
        cSQL += hb_ntos(PagarReceber.cb_grupo.Cargo[PagarReceber.cb_grupo.value])+","
        cSQL += hb_ntos(PagarReceber.cb_custo.Cargo[PagarReceber.cb_Custo.value])+","
        cSQL += Rs:DataSQL(PagarReceber.dp_vencto.value)+","
        cSQL += IIF(empty(PagarReceber.dp_pagto.value),"NULL",Rs:DataSQL(PagarReceber.Dp_pagto.VAlue))+","
        cSQL += hb_ntos(PagarREceber.Txtvalor.value)+","
        cSQL += hb_ntos(PagarReceber.TxtValorPago.Value)+","
        cSQL += Rs:DataSQl(DateTime())+","
        cSQL += hb_ntos(hAcesso["coduser"])+","
        cSQL += Rs:DataSQL(Datetime())+")"
        
    else
        if !hAcesso["alterar"]
            MsgNo("ALTERAR")
            Return Nil
        endif
        cSQL := "Update PagarReceber Set "
        cSQL += "id_cliforn="+hb_ntos(PagarReceber.cb_CliForn.Cargo[PagarReceber.cb_CliForn.Value])+","
        cSQL += "Hist='"+PagarReceber.TxtHIstorico.Value+"',"
        cSQL += "Docto='"+PagarReceber.TxtDocumento.Value+"',"
        cSQL += "Tipo="+IIF(Empty(PagarReceber.dp_Pagto.value),"0","1")+","
        cSQL += "id_Conta="+hb_ntos(PagarReceber.cb_Conta.Cargo[PagarReceber.cb_Conta.value])+","
        cSQL += "id_grupo="+hb_ntos(PagarReceber.cb_grupo.Cargo[PagarReceber.cb_grupo.value])+","
        cSQL += "id_custo="+hb_ntos(PagarReceber.cb_custo.Cargo[PagarReceber.cb_Custo.value])+","
        cSQL += "dtVen="+Rs:DataSQL(PagarReceber.dp_vencto.value)+","
        cSQL += "dtPag="+IIF(empty(PagarReceber.dp_pagto.value),"NULL",Rs:DataSQL(PagarReceber.Dp_pagto.VAlue))+","
        cSQL += "valor="+hb_ntos(PagarREceber.Txtvalor.value)+","
        cSQL += "ValorP="+hb_ntos(PagarReceber.TxtValorPago.Value)+","
        cSQL += "DtUpdate="+Rs:DataSQl(DateTime())+","
        cSQL += "Usuario="+hb_ntos(hAcesso["coduser"])
        cSQL +=" Where id="+PagarREceber.lb_codigo.value+" and dtupdate="+Rs:DataSQL(PagarReceber.lb_Ult_Alt2.Value)+";"
    endif
    if cn:Execute(cSQL)
        if cn:nReg<=0
            MsgInfo("Nenhum registro foi alterado ou incluido !",SISTEMA)
        endif
    endif
    PagarREceber.Release()
    Pesquisa_LoadGrid()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PagarReceber_Excluir_Action( )
    Local aItem := PesquisaPagRec.Grid.Item(PesquisaPagRec.Grid.Value)
    if !hAcesso["excluir"]
        msgNo("EXCLUIR")
        Return NIl
    endif
    if val(aItem[1])=0
        MsgiNfo("Nenhum registro informado para exclusão !",SISTEMA)
        Return Nil
    endif
    if MsgYesNo("Excluir o registro <"+aItem[1]+"-"+aItem[4]+"> do sistema ?",SISTEMA)
        if cn:Execute("Delete from PagarReceber where id="+aItem[1]+";")
            if cn:nReg<=0
                MsgInfo("Registro não pode ser excluido !",SISTEMA)
            endif
        endif
    endif
    Pesquisa_LoadGrid()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PagarReceber_Cb_Fornecedor_Onlistdisplay( )
    Local cName := PagarReceber.Cb_Cliforn.DisplayValue
    Rs:SQL := "Select Top "+DEF_MAX_REG+" id,nome  from CliForn where origem in ('"+IIF(Flag_P_R="P","F","C")+"','X') and nome like '"+cName+"%' order by nome"
    Rs:Open()
    PagarReceber.Cb_Cliforn.DeleteAllItems()
    PagarReceber.Cb_Cliforn.DisableUpdate()
    PagarReceber.Cb_Cliforn.Cargo := {}
    While !Rs:Eof()
        PagarReceber.Cb_Cliforn.AddItem(Rs:Fields["nome"]:value)
        AADD(PagarReceber.Cb_Cliforn.Cargo,Rs:Fields["id"]:value)
        Rs:MoveNext()
    Enddo
    PagarReceber.Cb_Cliforn.EnableUpdate()
    Rs:Close()
    Return Nil
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PagarReceber_Cb_Conta_Onlistdisplay( )
    Local cName := PagarReceber.Cb_Conta.DisplayValue
    Rs:SQL := "Select Top "+DEF_MAX_REG+" id,descricao from Tabelas where origem='CO' and ativo=TRUE and descricao like '"+cName+"%' order by descricao"
    Rs:Open()
    PagarReceber.Cb_Conta.DeleteAllItems()
    PagarReceber.Cb_Conta.DisableUpdate()
    PagarReceber.Cb_Conta.Cargo := {}
    While !Rs:Eof()
        PagarReceber.Cb_Conta.AddItem(Rs:Fields["descricao"]:value)
        AADD(PagarReceber.Cb_Conta.Cargo,Rs:Fields["id"]:value)
        Rs:MoveNext()
    Enddo
    PagarReceber.Cb_Conta.EnableUpdate()
    Rs:Close()    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PagarReceber_Cb_Grupo_Onlistdisplay( )
    Local cName := PagarReceber.Cb_Grupo.DisplayValue
    Rs:SQL := "Select Top "+DEF_MAX_REG+" id,descricao from Tabelas where origem='GR' and ativo=TRUE and descricao like '"+cName+"%' order by descricao"
    Rs:Open()
    PagarReceber.Cb_Grupo.DeleteAllItems()
    PagarReceber.Cb_Grupo.DisableUpdate()
    PagarReceber.Cb_Grupo.Cargo := {}
    While !Rs:Eof()
        PagarReceber.Cb_Grupo.AddItem(Rs:Fields["descricao"]:value)
        AADD(PagarReceber.Cb_Grupo.Cargo,Rs:Fields["id"]:value)
        Rs:MoveNext()
    Enddo
    PagarReceber.Cb_Grupo.EnableUpdate()
    Rs:Close()    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PagarReceber_Cb_Custo_Onlistdisplay( )
    Local cName := PagarReceber.Cb_Custo.DisplayValue
    Rs:SQL := "Select Top "+DEF_MAX_REG+" id,descricao from Tabelas where origem='CU' and ativo=TRUE  and descricao like '"+cName+"%' order by descricao"
    Rs:Open()
    PagarReceber.Cb_Custo.DeleteAllItems()
    PagarReceber.Cb_Custo.DisableUpdate()
    PagarReceber.Cb_Custo.Cargo := {}
    While !Rs:Eof()
        PagarReceber.Cb_Custo.AddItem(Rs:Fields["descricao"]:value)
        AADD(PagarReceber.Cb_Custo.Cargo,Rs:Fields["id"]:value)
        Rs:MoveNext()
    Enddo
    PagarReceber.Cb_Custo.EnableUpdate()
    Rs:Close()    
    Return .T.