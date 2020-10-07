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

MEMVAR Rs,Cn,hAcesso

Function Pesquisa_CliForn(cFlag)
    Local FrmPesquisa := IdGlobal("Form")
    Local FrmCliForn  := IdGlobal("Form")
    
    cFlag :=  IIF(Empty(cFlag),"F",cFlag)
    
    Load Window Pesquisa as &(FrmPesquisa) 
        &(FrmPesquisa).Cargo := cFlag
        

        &(FrmPesquisa).Editar.Enabled      := .F.
        &(FrmPesquisa).Excluir.Enabled     := .F.
        &(FrmPesquisa).Grid.Ondblclick     := {||LoadFrmCliforn(2,FrmPesquisa,FrmCliForn)}
        &(FrmPesquisa).TxtPesquisa.OnEnter := {||Pesquisa(FrmPesquisa)}
        &(FrmPesquisa).Novo.Action         := {||LoadFrmCliforn(1,FrmPesquisa,FrmCliForn)}
        &(FrmPesquisa).Editar.Action       := {||LoadFrmCliforn(2,FrmPesquisa,FrmCliForn)}
        &(FrmPesquisa).Excluir.Action      := {||Excluir(FrmPesquisa)}
        &(FrmPesquisa).oReport.Action      := {||FrmPesquisa_oReport_Action(FrmPesquisa)}
        
        &(FrmPesquisa).TxtPesquisa.Setfocus()
        RenovaPesquisa("",FrmPesquisa)
        &(FrmPesquisa).Center()
        
    Load Window CliForn as &(FrmCliForn)
        &(FrmCliForn).OnInteractiveClose := {||&(FrmCliForn).Hide,EnableDisableControls(FrmPesquisa,.T.), FALSE}
        &(FrmCliForn).Cancelar.Action    := {||EnableDisableControls(FrmPesquisa,.T.),&(FrmCliForn).Hide}
        &(FrmPesquisa).OnRelease         := {||&(FrmCliForn).onInteractiveclose := {||TRUE} ,&(FrmCliForn).Release}

        if cFlag="F"
            &(FrmPesquisa).Title:="Cadastro de Fornecedores"
            &(FrmCliForn).oTab1.Caption(1) :="Fornecedor"
            &(FrmCliForn).oTab1.Image(1) := "Forneced"
        Else
            &(FrmPesquisa).Title:="Cadastro de Clientes"
            &(FrmCliForn).oTab1.Caption(1) :="Cliente"
            &(FrmCliForn).oTab1.Image(1) := "Clientes"
        Endif
        &(FrmCliForn).Title := &(FrmPesquisa).Title
        
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
        Rs:SQL:="Select CliForn.*, Acesso.Apelido from CliForn left JOIN Acesso ON ACESSO.ID = CliForn.USUARIO where CliForn.id="+aItem[1]+";"
        Rs:Open()
        if !Rs:Eof()
            &(FrmCliForn).TxtCODIGO.Value	    := hb_ntos(Rs:Fields["id"]:value)
            &(FrmCliForn).Pessoa_Juridica.Value	:= Rs:Fields["Juridica"]:value
            &(FrmCliForn).TxtCGC_CPF.Value	    := Eval({|c,p|c:=SoNumBer(Rs:Fields["CGC_CPF"]:value),p:=IIF(&(FrmCliForn).Pessoa_Juridica.Value,"@R 99.999.999/9999-99","@R 999.999.999-99"),Transform(c,p)})
            &(FrmCliForn).TxtNOME.Value    	    := Rs:Fields["nome"]:value
            &(FrmCliForn).TxtENDERECO.Value	    := Rs:Fields["Endereco"]:value
            &(FrmCliForn).TxtBAIRRO.Value	    := Rs:Fields["bairro"]:value
            &(FrmCliForn).TxtCEP.Value		    := Transform(SoNumber(Rs:Fields["Cep"]:value),"@R 99999-999")
            &(FrmCliForn).TxtCIDADE.Value      	:= Rs:Fields["cidade"]:value
            &(FrmCliForn).TxtESTADO.Value	    := Ascan(&(FrmCliForn).TxtESTADO.Cargo,Rs:Fields["estado"]:value)
            &(FrmCliForn).TxtDDD.Value	      	:= Rs:Fields["ddd"]:value
            &(FrmCliForn).TxtFONE1.Value	    := Rs:Fields["Fone1"]:value
            &(FrmCliForn).TxtFONE2.Value	    := Rs:Fields["Fone2"]:value
            &(FrmCliForn).TxtCONTATOS.Value	    := Rs:Fields["contatos"]:value
            &(FrmCliForn).oCliforn.Value        := (Rs:Fields["Origem"]:value="X")
            
            &(FrmCliForn).Lb_DT_CAD.Value	    := Ttoc(Rs:Fields["DtCad"]:Value)
            &(FrmCliForn).Lb_DT_ALT.Value       := Ttoc(Rs:Fields["dtUpdate"]:value)
            &(FrmCliForn).Lb_USUARIO.Value      := hb_ntos(Rs:Fields["usuario"]:value)+"-"+Tipovar(Rs:Fields["apelido"]:value)
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
    if &(FrmPesquisa).Grid.ItemCount > 0
        &(FrmPesquisa).Editar.Enabled      := .T.
        &(FrmPesquisa).Excluir.Enabled     := .T.
        &(FrmPesquisa).Grid.Value          := 1
    endif
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
    if MsgYesNo("Confirma exclusão do registro <"+aItem[1]+"-"+aItem[2]+"> ?",SISTEMA)
        if cn:Execute("Delete from Cliforn were id="+aItem[1]+";")
            if cn:nReg<=0
                MsgSTop("Registro não foi excluido !",SISTEMA)
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
    Local cSQL,aItem,cUF
    
    if Empty(&(FrmCliForn).TxtNome.value)
        if &(FrmPesquisa).Cargo="F"
            MsgInfo("Nome do Fornecedor não informado !",SISTEMA)
        Else
            MsgInfo("Nome do cliente não informado !",SISTEMA)
        Endif
        &(FrmCliForn).TxtNome.SetFocus()
        Return Nil
    endif
    if !Empty(&(FrmCliForn).TxtCGC_CPF.Value)
        if &(FrmCliForn).Pessoa_Juridica.Value
            if !CNPJ(&(FrmCliForn).TxtCGC_CPF.Value)
                MsgInfo("CNPJ está insistente !",SISTEMA)
                &(FrmCliForn).TxtCGC_CPF.Setfocus()
                Return Nil
            endif
        else
            if !CPF(&(FrmCliForn).TxtCGC_CPF.Value)
                MsgInfo("CPR está insistente !",SISTEMA)
                &(FrmCliForn).TxtCGC_CPF.Setfocus()
                Return Nil
            endif
        endif
    endif
    
    cUF:=IIF(&(FrmCliForn).TxtESTADO.Value>0,&(FrmCliForn).TxtESTADO.Cargo[&(FrmCliForn).TxtESTADO.Value],"")
    
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
        cSQL += "'"+SoNumber(&(FrmCliForn).TxtCGC_CPF.Value)+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtENDERECO.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtBAIRRO.Value ) +"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtCEP.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtCIDADE.Value )+"',"
        cSQL += "'"+cUF+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtDDD.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtFONE1.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtFONE2.Value )+"',"
        cSQL += "'"+AllTrim( &(FrmCliForn).TxtCONTATOS.Value )+"',"
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
        aItem := &(FrmPesquisa).Grid.item( &(FrmPesquisa).Grid.value)
        cSQL := "Update CliForn Set "
        cSQL += "Origem="+IIF(&(FrmCliForn).oCliForn.Value,"'X'","'"+&(FrmPesquisa).Cargo+"'")+","
        cSQL += "Nome='"+AllTrim( &(FrmCliForn).TxtNOME.Value )+"',"
        cSQL += "Juridica="+IIF(&(FrmCliForn).Pessoa_Juridica.Value,"1","0")+","
        cSQL += "CGC_CPF='"+SoNumber(&(FrmCliForn).TxtCGC_CPF.Value)+"',"
        cSQL += "Endereco='"+AllTrim( &(FrmCliForn).TxtENDERECO.Value )+"',"
        cSQL += "Bairro='"+AllTrim( &(FrmCliForn).TxtBAIRRO.Value ) +"',"
        cSQL += "CEP='"+AllTrim( &(FrmCliForn).TxtCEP.Value )+"',"
        cSQL += "Cidade='"+AllTrim( &(FrmCliForn).TxtCIDADE.Value )+"',"
        cSQL += "Estado='"+cUF +"',"
        cSQL += "DDD='"+AllTrim( &(FrmCliForn).TxtDDD.Value )+"',"
        cSQL += "Fone1='"+AllTrim( &(FrmCliForn).TxtFONE1.Value )+"',"
        cSQL += "Fone2='"+AllTrim( &(FrmCliForn).TxtFONE2.Value )+"',"
        cSQL += "Contatos='"+AllTrim( &(FrmCliForn).TxtCONTATOS.Value )+"',"
        cSQL += "DtUpdate="+Rs:DataSQL(DateTime())+","
        cSQL += "Usuario="+hb_ntos(hAcesso["coduser"])+" "
        cSQL += "where id="+aItem[1]+" and dtUpdate="+Rs:DataSQL(aItem[3])+";"
        if cn:Execute(cSQL)
            if cn:nReg<=0
                MsgInfo("Registro não foi alterado !",SISTEMA)
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
Static Function FrmCliForn_OnInit(FrmCliForn)
    &(FrmCliForn).TxtEstado.DeleteAllItems()
    &(FrmCliForn).TxtEstado.Cargo := {"AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"}
    &(FrmCliForn).TxtEstado.AddItem("AC-Acre")
    &(FrmCliForn).TxtEstado.AddItem("AL-Alagoas")
    &(FrmCliForn).TxtEstado.AddItem("AP-Amapá")
    &(FrmCliForn).TxtEstado.AddItem("AM-Amazonas")
    &(FrmCliForn).TxtEstado.AddItem("BA-Bahia")
    &(FrmCliForn).TxtEstado.AddItem("CE-Ceará")
    &(FrmCliForn).TxtEstado.AddItem("DF-Distrito Federal")
    &(FrmCliForn).TxtEstado.AddItem("ES-Espírito Santo")
    &(FrmCliForn).TxtEstado.AddItem("GO-Goiás")
    &(FrmCliForn).TxtEstado.AddItem("MA-Maranhão")
    &(FrmCliForn).TxtEstado.AddItem("MT-Mato Grosso")
    &(FrmCliForn).TxtEstado.AddItem("MS-Mato Grosso do Sul")
    &(FrmCliForn).TxtEstado.AddItem("MG-Minas Gerais")
    &(FrmCliForn).TxtEstado.AddItem("PA-Pará")
    &(FrmCliForn).TxtEstado.AddItem("PB-Paraíba")
    &(FrmCliForn).TxtEstado.AddItem("PR-Paraná")
    &(FrmCliForn).TxtEstado.AddItem("PE-Pernambuco")
    &(FrmCliForn).TxtEstado.AddItem("PI-Piauí")
    &(FrmCliForn).TxtEstado.AddItem("RJ-Rio de Janeiro")
    &(FrmCliForn).TxtEstado.AddItem("RN-Rio Grande do Norte")
    &(FrmCliForn).TxtEstado.AddItem("RS-Rio Grande do Sul")
    &(FrmCliForn).TxtEstado.AddItem("RO-Rondônia")
    &(FrmCliForn).TxtEstado.AddItem("RR-Roraima")
    &(FrmCliForn).TxtEstado.AddItem("SC-Santa Catarina")
    &(FrmCliForn).TxtEstado.AddItem("SP-São Paulo")
    &(FrmCliForn).TxtEstado.AddItem("SE-Sergipe")
    &(FrmCliForn).TxtEstado.AddItem("TO-Tocantins")
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FrmCliForn_oBuscaCEP_Action(FrmCliForn )
    Local o,cCep,cRet:="",h:=Nil
    if val(&(FrmCliForn).TxtCEP.Value)=0
        Msginfo("Por favor , preencha o CEP !",SISTEMA)
        Return Nil
    endif
    
    cCep := Strtran(StrTran(Strtran(&(FrmCliForn).TxtCEP.Value,"-","")," ",""),".","")
    Try
        o := CreateObject("Microsoft.XMLHTTP")
        o:Open("GET","http://viacep.com.br/ws/"+cCep+"/json/",.F.)
        o:Send()
        cRet := o:responseBody 
    End

    if !Empty(cRet)
        h:=hb_jsondecode(cRet)
        if valtype(h)="H" .and. HHasKey( h, "cep" )
            if !Empty(h["logradouro"])
                &(FrmCliForn).TxtENDERECO.Value := hb_oemtoansi(hb_utf8toStr(h["logradouro"]))
            endif
            if !Empty(h["bairro"])
                &(FrmCliForn).txtBairro.Value := hb_oemtoansi(hb_utf8toStr(h["bairro"]))
            endif
            if !Empty(h["localidade"])
                &(FrmCliForn).txtCidade.value := hb_oemtoansi(hb_utf8toStr(h["localidade"]))
            endif
            if !Empty(h["uf"])
                &(FrmCliForn).txtEstado.value := Ascan(&(FrmCliForn).TxtEstado.Cargo,h["uf"])
            endif
            if !Empty(h["ddd"]).and.empty(&(FrmCliForn).Txtddd.value)
                &(FrmCliForn).txtddd.value := h["ddd"]
            endif
        else
            Msginfo("Por favor, verifique se o codigo de CEP está correto! <"+cCEP+">",SISTEMA)        
        endif
    else
        Msginfo("Por favor, verifique se o codigo de CEP está correto! <"+cCEP+">",SISTEMA)
    endif
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FrmCliForn_Pessoa_Juridica_Onchange(FrmCliForn )
    Local cValue := SoNumber(&(FrmCliForn).TxtCGC_CPF.Value)
    &(FrmCliForn).TxtCGC_CPF.Release()
    DEFINE TEXTBOX TxtCGC_CPF
        PARENT &(FrmCliForn)
        COL 332
        HEIGHT 25
        MAXLENGTH 20
        ONENTER (&(FrmCliForn).TxtNOME.SetFocus)
        ROW 49
        TOOLTIP "Digite o CGC ou CPF"
        WIDTH 140
        if &(FrmCliForn).Pessoa_Juridica.Value
            INPUTMASK "99.999.999/9999-99"
            MAXLENGTH 11
            TOOLTIP "Digite o CNPJ"
            cValue := Transform(cValue,"@R 99.999.999/9999-99")
        else
            INPUTMASK "999.999.999-99"
            MAXLENGTH 14
            TOOLTIP "Digite o CPF"
            cValue := Transform(cValue,"@R 999.999.999-99")
        Endif
        value cValue
    END TEXTBOX
    &(FrmCliForn).oTab1.AddControl( "TxtCGC_CPF" , 1 , 40+&(FrmCliForn).oTab1.Row , 332 )
    Return .T.
    
Static function FrmPesquisa_oReport_Action(FrmPesquisa)
    Local oHtml
    if !hAcesso["relatorio"]
        MsgNo("RELATORIO")
        Return Nil    
    endif
    Rs:SQL:="SELECT CliForn.ID,"+;
            "IIF(CliForn.JURIDICA,'Sim','Não') as [Pessoa Juridica],"+;
            "CliForn.NOME as Nome,"+;
            "CliForn.CGC_CPF as CNPJ, "+;
            "CliForn.ENDERECO as Endereço, "+;
            "CliForn.CIDADE as Município,"+;
            "CliForn.BAIRRO as Bairro, "+;
            "CliForn.ESTADO as UF, "+;
            "CliForn.CEP as CEP,"+;
            "CliForn.DDD as DDD, "+;
            "CliForn.FONE1 as [#Fone 1],"+;
            "CliForn.FONE2 as [#Fone 2], "+;
            "CliForn.CONTATOS as Contatos, "+;
            "CliForn.OBS as Observação,"+;
            "CliForn.DTCAD as [Dt Cadastro],"+;
            "CliForn.DTUPDATE as Atualização,"+;
            "Str(CliForn.USUARIO)+'-'+ACESSO.APELIDO as Usuário "+;
            "FROM ACESSO RIGHT JOIN CliForn ON ACESSO.ID = CliForn.USUARIO"+;
            " Where origem='"+&(FrmPesquisa).Cargo+"';"
    Rs:Open()
    if Rs:Eof()
        Return .F.
    endif
    oHtml := THtmlReport():New()
    oHtml:Rs   := Rs
    oHtml:Title := "<h2>"+&(FrmPesquisa).Title+"</h2>"
    oHtml:File := PutFile({{"*.HTML","*.HTML"}},"Nome do Arquivo")
    oHTml:Report()
    oHtml:Show()
    Return .T.  


