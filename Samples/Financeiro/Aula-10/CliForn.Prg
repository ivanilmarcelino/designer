/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 23/09/2020-16:10:51 M�quina: IMA2018 Usu�rio:ivani
    C�digo do m�dulo Cliforn
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */

#include <hmg.ch>
#include <SISTEMA.CH>

MEMVAR Rs,Cn,hAcesso

Function Pesquisa_CliForn(cFlag)
    Local FrmPesquisa := IdGlobal("Form")
    Local FrmCliForn  := IdGlobal("Form")
    
    cFlag :=  IIF(Empty(cFlag),"F",cFlag)
    
    Load Window Pesquisa as &(FrmPesquisa) 
        &(FrmPesquisa).Cargo := cFlag
        
        if cFlag="F"
            &(FrmPesquisa).Title:="Cadastro de Fornecedores"
        Else
            &(FrmPesquisa).Title:="Cadastro de Clientes"
        Endif
        &(FrmPesquisa).Grid.Ondblclick     := {||LoadFrmCliforn(2,FrmPesquisa,FrmCliForn)}
        &(FrmPesquisa).TxtPesquisa.OnEnter := {||Pesquisa(FrmPesquisa)}
        &(FrmPesquisa).Novo.Action         := {||LoadFrmCliforn(1,FrmPesquisa,FrmCliForn)}
        &(FrmPesquisa).Editar.Action       := {||LoadFrmCliforn(2,FrmPesquisa,FrmCliForn)}
        &(FrmPesquisa).Excluir.Action      := {||Excluir(FrmPesquisa)}
        
        &(FrmPesquisa).TxtPesquisa.Setfocus()
        RenovaPesquisa("",FrmPesquisa)
        &(FrmPesquisa).Center()
        
    Load Window CliForn as &(FrmCliForn)
        &(FrmCliForn).OnInteractiveClose := {||&(FrmCliForn).Hide,EnableDisableControls(FrmPesquisa,.T.), FALSE}
        &(FrmCliForn).Cancelar.Action    := {||EnableDisableControls(FrmPesquisa,.T.),&(FrmCliForn).Hide}
        &(FrmPesquisa).OnRelease         := {||&(FrmCliForn).onInteractiveclose := {||TRUE} ,&(FrmCliForn).Release}
    
    Activate window &(FrmPesquisa),&(FrmCliForn)
    Return Nil
    
    *************************************************************************************
Static Function EnableDisableControls(FrmPesquisa,lValue)
    &(FrmPesquisa).Grid.Enabled        := lValue
    &(FrmPesquisa).TxtPesquisa.Enabled := lValue
    &(FrmPesquisa).Novo.Enabled        := lValue
    &(FrmPesquisa).Editar.Enabled      := lValue
    &(FrmPesquisa).Excluir.Enabled     := lValue
    Return Nil
    *************************************************************************************

Static Function LoadFrmCliforn(nTipo,FrmPesquisa,FrmCliForn)
    Local aItem := &(FrmPesquisa).Grid.Item(&(FrmPesquisa).Grid.value)
    
    EnableDisableControls(FrmPesquisa,FALSE)
    
    if &(FrmPesquisa).Cargo="F"
        &(FrmCliForn).Title:="Cadastro de Fornecedores"
    Else
        &(FrmCliForn).Title:="Cadastro de Clientes"
    Endif
    
    &(FrmCliForn).Status.Value := (nTipo=1)
    &(FrmCliForn).TxtCodigo.Enabled := .F.
    
    &(FrmCliForn).TxtCODIGO.Value	    := Nil
    &(FrmCliForn).Pessoa_Juridica.Value	:= .F.
    &(FrmCliForn).TxtCGC_CPF.Value	    := Nil
    &(FrmCliForn).TxtNOME.Value    	    := Nil
    &(FrmCliForn).TxtENDERECO.Value	    := NIL
    &(FrmCliForn).TxtBAIRRO.Value	    := NIL
    &(FrmCliForn).TxtCEP.Value		    := NIL
    &(FrmCliForn).TxtCIDADE.Value      	:= NIL
    &(FrmCliForn).TxtESTADO.Value	    := NIL
    &(FrmCliForn).TxtDDD.Value	      	:= NIL
    &(FrmCliForn).TxtFONE1.Value	    := NIL
    &(FrmCliForn).TxtFONE2.Value	    := NIL
    &(FrmCliForn).TxtCONTATOS.Value	    := NIL
    &(FrmCliForn).oCliforn.Value        := .F.
        
    &(FrmCliForn).Lb_DT_CAD.Value	    := NIL
    &(FrmCliForn).Lb_DT_ALT.Value	    := NIL
    &(FrmCliForn).Lb_USUARIO.Value	    := NIL    
    
    &(FrmCliForn).Excluir.Enabled := !&(FrmCliForn).Status.Value
    
    if !&(FrmCliForn).Status.Value
        Rs:SQL:="Select * from CliForn where id="+aItem[1]+";"
        Rs:Open()
        if !Rs:Eof()
            &(FrmCliForn).TxtCODIGO.Value	    := hb_ntos(Rs:Fields["id"]:value)
            &(FrmCliForn).Pessoa_Juridica.Value	:= Rs:Fields["Juridica"]:value
            &(FrmCliForn).TxtCGC_CPF.Value	    := Rs:Fields["CGC_CPF"]:value
            &(FrmCliForn).TxtNOME.Value    	    := Rs:Fields["nome"]:value
            &(FrmCliForn).TxtENDERECO.Value	    := Rs:Fields["Endereco"]:value
            &(FrmCliForn).TxtBAIRRO.Value	    := Rs:Fields["bairro"]:value
            &(FrmCliForn).TxtCEP.Value		    := Rs:Fields["Cep"]:value
            &(FrmCliForn).TxtCIDADE.Value      	:= Rs:Fields["cidade"]:value
            &(FrmCliForn).TxtESTADO.Value	    := Rs:Fields["estado"]:value
            &(FrmCliForn).TxtDDD.Value	      	:= Rs:Fields["ddd"]:value
            &(FrmCliForn).TxtFONE1.Value	    := Rs:Fields["Fone1"]:value
            &(FrmCliForn).TxtFONE2.Value	    := Rs:Fields["Fone2"]:value
            &(FrmCliForn).TxtCONTATOS.Value	    := Rs:Fields["contatos"]:value
            &(FrmCliForn).oCliforn.Value        := (Rs:Fields["Origem"]:value="X")
            
            &(FrmCliForn).Lb_DT_CAD.Value	    := "Data Cad: "+Ttoc(Rs:Fields["DtCad"]:Value)
            &(FrmCliForn).Lb_DT_ALT.Value	:= "�lt Altera��o: "+Ttoc(Rs:Fields["dtUpdate"]:value)
            &(FrmCliForn).Lb_USUARIO.Value	:= "Usu�rio: "+hb_ntos(Rs:Fields["usuario"]:value)
        Endif    
    Endif
    &(FrmCliForn).Row := (&(FrmPesquisa).Row)
    &(FrmCliForn).Col := (&(FrmPesquisa).Col)
    &(FrmCliForn).Pessoa_juridica.Setfocus
    &(FrmCliForn).Show()
    Return .T.
    *************************************************************************************
Static Function Pesquisa(FrmPesquisa)
    Local cPesq:= &(FrmPesquisa).TxtPesquisa.Value
    &(FrmPesquisa).Grid.DeleteAllItems()
    Rs:SQL := "Select top "+DEF_MAX_REG +" id,nome,dtupdate from Cliforn "
    Rs:SQL += "where origem in ('"+&(FrmPesquisa).Cargo+"','X') and nome like '"+cPesq+"%' order by nome;"
    Rs:Open()
    While !Rs:Eof()
        &(FrmPesquisa).Grid.AddItem({hb_ntos(Rs:Fields["id"]:value),Rs:Fields["nome"]:value,xDate(Rs:Fields["dtUpdate"]:value)})
        Rs:MoveNext()
    Enddo
    &(FrmPesquisa).TxtPesquisa.Setfocus()
    Return Nil
    *************************************************************************************
Static Function RenovaPesquisa(cNome,FrmPesquisa)
    &(FrmPesquisa).TxtPesquisa.Value := Substr(cNome,1,10)
    &(FrmPesquisa).TxtPesquisa.Setfocus()
    Pesquisa(FrmPesquisa)
    Return NIl
    *************************************************************************************
Static Function Excluir(FrmPesquisa)
    Local aItem
    if !hAcesso["excluir"]
        MsgNo("EXCLUIR")
        Return NIl
    endif
    aItem := &(FrmPesquisa).Grid.item( &(FrmPesquisa).Grid.value)
    if val(aItem[1]) = 0
        Return NIl
    Endif
    if MsgYesNo("Confirma exclus�o do registro <"+aItem[1]+"-"+aItem[2]+"> ?",SISTEMA)
        if cn:Execute("Delete from Cliforn were id="+aItem[1]+";")
            if cn:nReg<=0
                MsgSTop("Registro n�o foi excluido !",SISTEMA)
            endif
        endif
        RenovaPesquisa(aItem[2],FrmPesquisa)
    Endif
    Return Nil
    *********************************************************************************************************************************
    *********************************************************************************************************************************
    
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function CliForn_Bt_Salvar_Action(FrmPesquisa,FrmCliForn )
    Local cSQL,aItem
    
    if Empty(&(FrmCliForn).TxtNome.value)
        if &(FrmPesquisa).Cargo="F"
            MsgInfo("Nome do Fornecedor n�o informado !",SISTEMA)
        Else
            MsgInfo("Nome do cliente n�o informado !",SISTEMA)
        Endif
        Return Nil
    endif
    if &(FrmCliForn).Status.value
        if !hAcesso["incluir"]
            MsgNo("INCLUIR")
            Return Nil
        Endif
        
        *** Cria um novo Registro e grava o codigo e a Data de Cadastro
        cSQL := "Insert into CliForn (Origem,Nome,Juridica,CGC_CPF,Endereco,Bairro,CEP,Cidade,Estado,DDD,Fone1,Fone2,Contatos,DtUpdate,Usuario,DtCad) Values ("
        cSQL += IIF(&(FrmCliForn).oCliForn.Value,"'X'","'"+&(FrmPesquisa).Cargo+"'")+","
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtNOME.Value )+"',"
        cSQL += IIF(&(FrmCliForn).Pessoa_Juridica.Value,"1","0")+","
        cSQL += "'"+&(FrmCliForn).TxtCGC_CPF.Value+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtENDERECO.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtBAIRRO.Value ) +"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtCEP.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtCIDADE.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtESTADO.Value ) +"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtDDD.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtFONE1.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtFONE2.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtCONTATOS.Value )+"',"
        cSQL += Rs:DataSQL(DateTime())+","
        cSQL += hb_ntos(hAcesso["coduser"])+","
        cSQL += Rs:DataSQL(DateTime())+");"
        if cn:Execute(cSQL)
            if cn:nReg<=0
                MsgInfo("Registro n�o foi inclu�do !",SISTEMA)
            endif
        endif
    Else
        IF !hAcesso["alterar"]
            MsgNo("ALTERAR")
            Return Nil
        Endif
        aItem := &(FrmPesquisa).Grid.item( &(FrmPesquisa).Grid.value)
        cSQL := "Update CliForn Set "
        cSQL += "Origem="+IIF(&(FrmCliForn).oCliForn.Value,"'X'","'"+&(FrmPesquisa).Cargo+"'")+","
        cSQL += "Nome='"+AllTrim( &(FrmCliForn).TxtNOME.Value )+"',"
        cSQL += "Juridica="+IIF(&(FrmCliForn).Pessoa_Juridica.Value,"1","0")+","
        cSQL += "CGC_CPF='"+&(FrmCliForn).TxtCGC_CPF.Value+"',"
        cSQL += "Endereco='"+AllTrim( &(FrmCliForn).TxtENDERECO.Value )+"',"
        cSQL += "Bairro='"+AllTrim( &(FrmCliForn).TxtBAIRRO.Value ) +"',"
        cSQL += "CEP='"+AllTrim( &(FrmCliForn).TxtCEP.Value )+"',"
        cSQL += "Cidade='"+AllTrim( &(FrmCliForn).TxtCIDADE.Value )+"',"
        cSQL += "Estado='"+AllTrim( &(FrmCliForn).TxtESTADO.Value ) +"',"
        cSQL += "DDD='"+AllTrim( &(FrmCliForn).TxtDDD.Value )+"',"
        cSQL += "Fone1='"+AllTrim( &(FrmCliForn).TxtFONE1.Value )+"',"
        cSQL += "Fone2='"+AllTrim( &(FrmCliForn).TxtFONE2.Value )+"',"
        cSQL += "Contatos='"+AllTrim( &(FrmCliForn).TxtCONTATOS.Value )+"',"
        cSQL += "DtUpdate="+Rs:DataSQL(DateTime())+","
        cSQL += "Usuario="+hb_ntos(hAcesso["coduser"])+" "
        cSQL += "where id="+aItem[1]+" and dtUpdate="+Rs:DataSQL(aItem[3])+";"
        if cn:Execute(cSQL)
            if cn:nReg<=0
                MsgInfo("Registro n�o foi alterado !")
            endif
        endif
    Endif
    &(FrmCliForn).Hide()
    EnableDisableControls(FrmPesquisa,TRUE)
    RenovaPesquisa(&(FrmCliForn).TxtNOME.Value,FrmPesquisa)
    Return Nil
    

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function CliForn_Bt_Excluir_Action( FrmPesquisa)
    Excluir(FrmPesquisa)
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function CliForn_TxtCGC_CPF_Onlostfocus(FrmCliForn )
    Local i		
    Local cCGC	:= AllTrim( &(FrmCliForn).TxtCGC_CPF.Value ) 
    Local cNewCGC	:= ""
    For i := 1	 To Len( cCGC )  
        cNewCGC += Iif(  IsDigit( Substr( cCGC , i , 1 ) )  , Substr( cCGC , i , 1 ) , ""  )
    Next
    If &(FrmCliForn).Pessoa_Juridica.Value
        &(FrmCliForn).TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 99.999.999/9999-99" ) )
    Else
        &(FrmCliForn).TxtCGC_CPF.Value := AllTrim( TransForm( cNewCGC , "@R 999.999.999-99" ) )
    EndIf    
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************