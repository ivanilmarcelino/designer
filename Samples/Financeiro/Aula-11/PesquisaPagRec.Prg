/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.084 RELEASE CANDIDATE (RC) 200924 0918"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 4)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 25/09/2020-13:02:59 Máquina: IMA2018 Usuário:ivani
    Código do módulo Pesquisapagrec
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <SISTEMA.CH>
memvar Flag_P_R, Rs, Cn, hAcesso
Declare window Pesquisapagrec

Function LoadFrmPesquisapagrec(cFlag)
    if Type("Flag_P_R")="U"
        Private Flag_P_R
    endif    
    
    cFlag := IIF(cFlag=Nil,"P",cFlag)
    
    if _IsWIndowDefined("Pesquisapagrec")
        if !cFlag=Flag_P_R
            if cFlag="R"
                Msginfo("Feche o <Contas a Pagar> para Abrir o <Contas a Receber> !")
            else
                Msginfo("Feche o <Contas a Receber> para Abrir o <Contas a Pagar> !")
            endif
        endif
        Pesquisapagrec.Setfocus()
        Return .T.
    else
        Flag_P_R := cFlag
    endif
    Load window Pesquisapagrec as Pesquisapagrec
        PesquisaPagRec.Cb_Tudo.Enabled := .F.
        PesquisaPagRec.Cb_Tudo.Value := .F.
        If Flag_P_R="R"
            PesquisaPagRec.Title                 := "Contas a Receber"
            PesquisaPagRec.Grid.Header(4)        := "Cliente"
            PesquisaPagRec.Fr_Fornecedor.Caption := "Cliente"
            PesquisaPagRec.Cb_APagar.Caption     := "à Receber"
        Endif
        PesquisaPagRec.Cb_aPagar.Value := .T.
        PesquisaPagRec.Dp_Data1.setfocus()
        
        Pesquisapagrec.Center()
    Pesquisapagrec.activate()

    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Grid_Ondblclick( )
    LoadFrmPagarreceber(2)
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Oninit( )
    PesquisaPagRec.Dp_Data1.Value := IniMes()
    PesquisaPagRec.Dp_Data2.Value := FimMes()
    Pesquisa_LoadGrid()   
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Function Pesquisa_LoadGrid()
    Local dData1  := PesquisaPagRec.Dp_Data1.Value
    Local dData2  := PesquisaPagRec.Dp_Data2.Value
    
    Rs:SQL := "Select id,DtVen,DtPag,Nome,Valor,DtUpdate from QueryPagarReceber where origem='"+Flag_P_R+"'" 
    Rs:SQL += " and (Dtven <= "+Rs:DataSQL(dData2)+" and DtVen>="+Rs:DataSQL(dData1)
    Rs:SQL += " or DtPag<= "+Rs:DataSQL(dData2)+" and DtPag>="+Rs:DataSQL(dData1)
    Rs:SQL += " or DtVen < "+Rs:DataSQL(dData1)+" and DtPag is Null)"
    
    if PesquisaPagRec.Cb_CliForn.Value > 0
        Rs:SQL += " and id_CliForn="+hb_ntos(PesquisaPagRec.Cb_CliForn.Cargo[PesquisaPagRec.cb_CliForn.Value])
    Endif
    if !PesquisaPagRec.cb_tudo.Value
        if PesquisaPagRec.cb_aPagar.Value
            Rs:SQL += " and DtPag is Null"
        endif
        if PesquisaPagRec.cb_Pagos.Value
            Rs:SQL += " and Not DtPag is Null"
        endif
    Endif
    if PesquisaPagRec.Cb_Contas.Value >0
        Rs:SQL += " and id_conta="+hb_ntos(PesquisaPagRec.Cb_Contas.Cargo[PesquisaPagRec.Cb_Contas.Value])
    endif
    Rs:SQL += " order by Dtven"
    Rs:Open()
    
    PesquisaPagRec.Grid.DeleteAllItems()
    PesquisaPagRec.Grid.DisableUpdate()
    While !Rs:Eof()
        PesquisaPagRec.Grid.AddItem({hb_ntos(Rs:Fields["id"]:value),;
            DtocSQL(Rs:Fields["dtVen"]:value),;
            DtocSQL(Rs:Fields["DtPag"]:value),;
            Rs:Fields["Nome"]:value,;
            Transform(Rs:Fields["valor"]:value, "@R 999,999,99")})
        Rs:MoveNext()
    Enddo
    PesquisaPagRec.Grid.EnableUpdate()   
    Return Nil
    
    
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Cb_CliForn_Onlistdisplay( )
    Local cName := PesquisaPagRec.Cb_Cliforn.DisplayValue
    Rs:SQL := "Select Top "+DEF_MAX_REG+" id,nome  from CliForn where origem in ('"+IIF(Flag_P_R="P","F","C")+"','X') and nome like '"+cName+"%' order by nome"
    Rs:Open()
    PesquisaPagRec.Cb_Cliforn.DeleteAllItems()
    PesquisaPagRec.Cb_Cliforn.Cargo := {}
    While !Rs:Eof()
        PesquisaPagRec.Cb_Cliforn.AddItem(Rs:Fields["nome"]:value)
        AADD(PesquisaPagRec.Cb_Cliforn.Cargo,Rs:Fields["id"]:value)
        Rs:MoveNext()
    Enddo
    PesquisaPagRec.Cb_Cliforn.EnableUpdate()
    Rs:Close()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Cb_Contas_Onlistdisplay( )
    Local cName := PesquisaPagRec.Cb_Contas.DisplayValue
    Rs:SQL := "Select Top "+DEF_MAX_REG+" id,descricao  from Tabelas where origem='CO' and descricao like '"+cName+"%' order by descricao"
    Rs:Open()
    PesquisaPagRec.Cb_Contas.DeleteAllItems()
    PesquisaPagRec.Cb_Contas.Cargo := {}
    While !Rs:Eof()
        PesquisaPagRec.Cb_Contas.AddItem(Rs:Fields["descricao"]:value)
        AADD(PesquisaPagRec.Cb_Contas.Cargo,Rs:Fields["id"]:value)
        Rs:MoveNext()
    Enddo
    PesquisaPagRec.Cb_Contas.EnableUpdate()
    Rs:Close()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function DtocSQL(d)
    Return IIF(Empty(d),"",Dtoc(d))
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Cb_APagar_Onchange( )
    IF PesquisaPagRec.Cb_APagar.Value .and. Upper(This.Name)=="CB_APAGAR"
        PesquisaPagRec.Cb_Pagos.Value := .F.
    Endif
    IF PesquisaPagRec.Cb_Pagos.value .and. Upper(This.Name)=="CB_PAGOS"
        PesquisaPagRec.Cb_aPagar.Value := .F.
    Endif
    PesquisaPagRec.Cb_Tudo.Value := !(PesquisaPagRec.CB_aPagar.Value .or. PesquisaPagRec.Cb_Pagos.Value)
    Pesquisa_LoadGrid()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Novo_Action( )
    LoadFrmPagarreceber(1)
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Editar_Action( )
    LoadFrmPagarreceber(2)
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function PesquisaPagRec_Bt_Pesquisar_Action( )
    Pesquisa_LoadGrid()
    Return .T.
