/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 23/09/2020-16:10:51 Máquina: IMA2018 Usuário:ivani
    Código do módulo Cliforn
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <SISTEMA.CH>

MEMVAR lNovo,Rs,Cn,hAcesso,Flag_C_F

Function Pesquisa_CliForn(cFlag)
    Private lNovo := .F.
    Private Flag_C_F:=IIF(Empty(cFlag),"F",cFlag)
    
    Load Window Pesquisa as PesquisaCliForn
        if Flag_C_F="F"
            PesquisaCliForn.Title:="Cadastro de Fornecedores"
        Else
            PesquisaCliForn.Title:="Cadastro de Clientes"
        Endif
        PesquisaCliForn.Grid.Ondblclick     := {||LoadFrmCliforn(2)}
        PesquisaCliForn.TxtPesquisa.OnEnter := {||Pesquisa()}
        PesquisaCliForn.Novo.Action         := {||LoadFrmCliforn(1)}
        PesquisaCliForn.Editar.Action       := {||LoadFrmCliforn(2)}
        PesquisaCliForn.Excluir.Action      := {||Excluir(1)}
        
        PesquisaCliForn.TxtPesquisa.Setfocus()
        RenovaPesquisa("")
        PesquisaCliForn.Center()
        
    PesquisaCliForn.Activate()
    Return Nil
    
    *************************************************************************************
Static Function LoadFrmCliforn(nTipo)
    lNovo := IIF(nTipo=1 ,.T. ,.F.)
    if nTipo == 2 .and. PesquisaCliForn.Grid.Value=0 //alteração
        Return Nil
    Endif
    Load window Cliforn as Cliforn
        if Flag_C_F="F"
            Cliforn.Title:="Cadastro de Fornecedores"
        Else
            Cliforn.Title:="Cadastro de Clientes"
        Endif
        
        CliForn.TxtCodigo.Enabled := .F.
        
        CliForn.Pessoa_juridica.Setfocus
        if lNovo
            Cliforn.Excluir.Enabled := .F.
        else
            DadosPush()
        Endif
        
        Cliforn.Center()
    Cliforn.activate()

    Return .T.
    *************************************************************************************
Static Function Pesquisa
    Local cPesq:= PesquisaCliForn.TxtPesquisa.Value
    PesquisaCliForn.Grid.DeleteAllItems()
    Rs:SQL := "Select top "+DEF_MAX_REG +" id,nome,dtupdate from Cliforn "
    Rs:SQL += "where origem in ('"+Flag_C_F+"','X') and nome like '"+cPesq+"%' order by nome;"
    Rs:Open()
    While !Rs:Eof()
        PesquisaCliForn.Grid.AddItem({hb_ntos(Rs:Fields["id"]:value),Rs:Fields["nome"]:value,xDate(Rs:Fields["dtUpdate"]:value)})
        Rs:MoveNext()
    Enddo
    PesquisaCliForn.TxtPesquisa.Setfocus()
    Return Nil
    *************************************************************************************
Static Function RenovaPesquisa(cNome)
    PesquisaCliForn.TxtPesquisa.Value := Substr(cNome,1,10)
    PesquisaCliForn.TxtPesquisa.Setfocus()
    Pesquisa()
    Return NIl
    *************************************************************************************
Static Function Excluir
    Local aItem
    if !hAcesso["excluir"]
        MsgNo("EXCLUIR")
        Return NIl
    endif
    aItem := PesquisaCliForn.Grid.item( PesquisaCliForn.Grid.value)
    if val(aItem[1]) = 0
        Return NIl
    Endif
    if MsgYesNo("Confirma exclusão do registro <"+aItem[1]+"-"+aItem[2]+"> ?",SISTEMA)
        if cn:Execute("Delete from Cliforn were id="+aItem[1]+";")
            if cn:nReg<=0
                MsgSTop("Registro não foi excluido !",SISTEMA)
            endif
        endif
        RenovaPesquisa(aItem[2])
    Endif
    Return Nil
    *********************************************************************************************************************************
    *********************************************************************************************************************************
    
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function CliForn_Bt_Salvar_Action( )
    Local cSQL,aItem
    
    if Empty(CliForn.TxtNome.value)
        if Flag_C_F="F"
            MsgInfo("Nome do Fornecedor não informado !",SISTEMA)
        Else
            MsgInfo("Nome do cliente não informado !",SISTEMA)
        Endif
        Return Nil
    endif
    if lNovo
        if !hAcesso["incluir"]
            MsgNo("INCLUIR")
            Return Nil
        Endif
        
        lNovo := .F.
        *** Cria um novo Registro e grava o codigo e a Data de Cadastro
        cSQL := "Insert into CliForn (Origem,Nome,Juridica,CGC_CPF,Endereco,Bairro,CEP,Cidade,Estado,DDD,Fone1,Fone2,Contatos,DtUpdate,Usuario,DtCad) Values ("
        cSQL += IIF(CliForn.oCliForn.Value,"'X'","'"+Flag_C_F+"'")+","
        cSQL += "'"+AllTrim( CliForn.TxtNOME.Value )+"',"
        cSQL += IIF(CliForn.Pessoa_Juridica.Value,"1","0")+","
        cSQL += "'"+CliForn.TxtCGC_CPF.Value+"',"
        cSQL += "'"+AllTrim( CliForn.TxtENDERECO.Value )+"',"
        cSQL += "'"+AllTrim( CliForn.TxtBAIRRO.Value ) +"',"
        cSQL += "'"+AllTrim( CliForn.TxtCEP.Value )+"',"
        cSQL += "'"+AllTrim( CliForn.TxtCIDADE.Value )+"',"
        cSQL += "'"+AllTrim( CliForn.TxtESTADO.Value ) +"',"
        cSQL += "'"+AllTrim( CliForn.TxtDDD.Value )+"',"
        cSQL += "'"+AllTrim( CliForn.TxtFONE1.Value )+"',"
        cSQL += "'"+AllTrim( CliForn.TxtFONE2.Value )+"',"
        cSQL += "'"+AllTrim( CliForn.TxtCONTATOS.Value )+"',"
        cSQL += Rs:DataSQL(DateTime())+","
        cSQL += hb_ntos(hAcesso["coduser"])+","
        cSQL += Rs:DataSQL(DateTime())+");"
        if cn:Execute(cSQL)
            if cn:nReg<=0
                MsgInfo("Registro não foi incluído !",SISTEMA)
            endif
        endif
    Else
        IF !hAcesso["alterar"]
            MsgNo("ALTERAR")
            Return Nil
        Endif
        aItem := PesquisaCliForn.Grid.item( PesquisaCliForn.Grid.value)
        cSQL := "Update CliForn Set "
        cSQL += "Origem="+IIF(CliForn.oCliForn.Value,"'X'","'"+Flag_C_F+"'")+","
        cSQL += "Nome='"+AllTrim( CliForn.TxtNOME.Value )+"',"
        cSQL += "Juridica="+IIF(CliForn.Pessoa_Juridica.Value,"1","0")+","
        cSQL += "CGC_CPF='"+CliForn.TxtCGC_CPF.Value+"',"
        cSQL += "Endereco='"+AllTrim( CliForn.TxtENDERECO.Value )+"',"
        cSQL += "Bairro='"+AllTrim( CliForn.TxtBAIRRO.Value ) +"',"
        cSQL += "CEP='"+AllTrim( CliForn.TxtCEP.Value )+"',"
        cSQL += "Cidade='"+AllTrim( CliForn.TxtCIDADE.Value )+"',"
        cSQL += "Estado='"+AllTrim( CliForn.TxtESTADO.Value ) +"',"
        cSQL += "DDD='"+AllTrim( CliForn.TxtDDD.Value )+"',"
        cSQL += "Fone1='"+AllTrim( CliForn.TxtFONE1.Value )+"',"
        cSQL += "Fone2='"+AllTrim( CliForn.TxtFONE2.Value )+"',"
        cSQL += "Contatos='"+AllTrim( CliForn.TxtCONTATOS.Value )+"',"
        cSQL += "DtUpdate="+Rs:DataSQL(DateTime())+","
        cSQL += "Usuario="+hb_ntos(hAcesso["coduser"])+" "
        cSQL += "where id="+aItem[1]+" and dtUpdate="+Rs:DataSQL(aItem[3])+";"
        if cn:Execute(cSQL)
            if cn:nReg<=0
                MsgInfo("Registro não foi alterado !")
            endif
        endif
    Endif
    CliForn.Release()
    RenovaPesquisa(CliForn.TxtNOME.Value)
    Return Nil
    

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function CliForn_Bt_Excluir_Action( )
    Excluir()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function CliForn_TxtCGC_CPF_Onlostfocus( )
    Local i		
    Local cCGC	:= AllTrim( CliForn.TxtCGC_CPF.Value ) 
    Local cNewCGC	:= ""
    For i := 1	 To Len( cCGC )  
        cNewCGC += Iif(  IsDigit( Substr( cCGC , i , 1 ) )  , Substr( cCGC , i , 1 ) , ""  )
    Next
    If CliForn.Pessoa_Juridica.Value
        CliForn.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 99.999.999/9999-99" ) )
    Else
        CliForn.TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 999.999.999-99" ) )
    EndIf    
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Function DadosPush()
    Local aItem := PesquisaCliForn.Grid.Item(PesquisaCliForn.Grid.value)
    Rs:SQL:="Select * from CliForn where id="+aItem[1]+";"
    Rs:Open()
    if !Rs:Eof()
        CliForn.TxtCODIGO.Value	        := hb_ntos(Rs:Fields["id"]:value)
        CliForn.Pessoa_Juridica.Value	:= Rs:Fields["Juridica"]:value
        CliForn.TxtCGC_CPF.Value	    := Rs:Fields["CGC_CPF"]:value
        CliForn.TxtNOME.Value    	    := Rs:Fields["nome"]:value
        CliForn.TxtENDERECO.Value	    := Rs:Fields["Endereco"]:value
        CliForn.TxtBAIRRO.Value	        := Rs:Fields["bairro"]:value
        CliForn.TxtCEP.Value		    := Rs:Fields["Cep"]:value
        CliForn.TxtCIDADE.Value      	:= Rs:Fields["cidade"]:value
        CliForn.TxtESTADO.Value	        := Rs:Fields["estado"]:value
        CliForn.TxtDDD.Value	      	:= Rs:Fields["ddd"]:value
        CliForn.TxtFONE1.Value	        := Rs:Fields["Fone1"]:value
        CliForn.TxtFONE2.Value	        := Rs:Fields["Fone2"]:value
        CliForn.TxtCONTATOS.Value	    := Rs:Fields["contatos"]:value
        CliForn.oCliforn.Value          := (Rs:Fields["Origem"]:value="X")
        
        CliForn.Lb_DT_CAD.Value	    := "Data Cad: "+Ttoc(Rs:Fields["DtCad"]:Value)
        CliForn.Lb_DT_ALT.Value	:= "Últ Alteração: "+Ttoc(Rs:Fields["dtUpdate"]:value)
        CliForn.Lb_USUARIO.Value	:= "Usuário: "+hb_ntos(Rs:Fields["usuario"]:value)
    Endif
    Return Nil