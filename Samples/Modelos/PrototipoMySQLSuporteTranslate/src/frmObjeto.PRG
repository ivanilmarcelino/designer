/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.29.0 RELEASE CANDIDATE (RC) 220421 1104
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.03.3 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 23/04/2022-11:53:50 Máquina: IMA2018 Usuário:Ivanil
    frmObjeto.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : Transacao
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor MySQL oQuery
Declare window Main

Function LoadFrmfrmObjeto()
    
    //Aqui verificamos se frmObjeto já foi definida
    if _isWindowDefined("frmObjeto")
        DoMethod("frmObjeto","Setfocus")
        Return .T.
    endif
    
   
    Load window frmObjeto as frmObjeto
        frmObjeto.Center()
        TranslateUniversal("frmObjeto")
    frmObjeto.activate()

    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function frmObjeto_OnInit(  )
    Local aObj:={},cName
    Local hItem,nPos,oQuery
    
    //Função interna da minigui, traz uma array com os objetos do formulario; tipo é opcional
    Local aList:=HMG_GetFormControls ( "Main", "MENU")

    //Para nosso modelo vamos monitorar apenas o Menu e a Toolbar, mas nada impede que seja expandido para outros controles
    //None será o tipo de opção não monitorada
    //Os tipos usuário/Manutenção e gerencial estão diretamente ligada ao nivel da tabela de acesso
    FrmObjeto.oNivel.SetArray({"None","usuário","Manutenção","Gerencial"})
    For each cName in aList
        hItem := Hash()
        hItem["id"]        := 0
        hItem["tipo"]      := "MENU"
        hItem["objeto"]    :=  cName
        //vamos usar como default o Prompt do Menu, poderá ser alterado mais tarde
        hItem["descricao"] := _GetMenuItemCaption(cName,"Main") 
        hItem["nivel"]     :=0
        //Este campo ira permtir uma validação extra, impedindo que alguem altera o banco diretamente.
        hItem["crc"]       :=""
        hItem["del"]       :="N"
        AADD(aObj,hItem)
    Next
    
    //Função interna da minigui, traz uma array com os objetos do formulario; tipo é opcional
    aList:=HMG_GetFormControls ( "Main", "TOOLBUTTON")
    For each cName in aList
        hItem := Hash()
        hItem["id"]        := 0
        hItem["tipo"]      := "TOOLBUTTON"
        hItem["objeto"]    :=  cName
        //Vamos usar o caption ou tooltip como default, poderá ser alterado mais tarde
        hItem["descricao"] := hb_defaultValue((Main.&(cName).Caption),(Main.&(cName).Tooltip))
        hItem["nivel"]     :=0
        //Este campo ira permtir uma validação extra, impedindo que alguem altera o banco diretamente.
        hItem["crc"]       :=""
        hItem["del"]       :="N"
        AADD(aObj,hItem)
    Next
    //o Bloco abaixo é uma automação de carga inicial; insere novos objetos na media que o projeto evolui
    For each hItem in aObj
        oQuery.SQL := "Insert into tabobjeto (tipo,objeto,descricao,nivel,crc) "
        oQuery.SQL += "Select '"+hItem["tipo"]+"',"   +;
                             "'"+hItem["objeto"]+"'," +;
                             "'"+hItem["descricao"]+"',"+;
                             "0"+","+;
                             "'"+HB_MD5(hItem["tipo"]+hItem["objeto"]+hItem["descricao"]+"0")+"' from Dual "
        oQuery.SQL += "Where not exists (select * from  tabobjeto where tipo='"+hItem["tipo"]+"' and objeto='"+hItem["objeto"]+"' Limit 1)"
        oQuery.Execute()
    Next

    //é muito importante que os nomes dos objetos estejam definidos antes de acionar esta rotina
    //opcionalmente  pode se implementar o [else] abaixo para excluir os objetos que foram renomeados

    //o trecho abaixo faz a ligação dos objetos encontrados com os objetos no banco;
    oQuery.SQL := "Select * from tabobjeto"
    oQuery.Open()
    While !oQuery.Eof() 
        nPos:=Ascan(aObj,{|h|h["tipo"]=oQuery.Field.tipo.value .and. h["objeto"]=oQuery.Field.objeto.value})
        if nPos>0
            aObj[nPos]["id"]        := oQuery.Field.codidobj.value
            aObj[nPos]["nivel"]     := oQuery.Field.nivel.value
            aObj[nPos]["descricao"] := hb_AnsitoOem(oQuery.Field.descricao.value)
        else
            //AADD para excluir...
            hItem := Hash()
            hItem["id"]        := oQuery.Field.codidobj.value
            hItem["tipo"]      := oQuery.Field.tipo.value 
            hItem["objeto"]    := oQuery.Field.objeto.value
            hItem["descricao"] := hb_AnsitoOem(oQuery.Field.descricao.value)
            hItem["nivel"]     := oQuery.Field.nivel.value
            hItem["crc"]       := oQuery.Field.crc.value
            hItem["del"]       := "S"
            AADD(aObj,hItem)
        endif
        oQuery.MoveNext()
    Enddo
    oQuery.Close()
    
    //Aqui carregamos os objetos dentro de cada grid separados por tipo
    //Monitorados e os não monitorados
    For each hItem in aObj
        if hItem["nivel"]=0
            cName:="oListNaoMonitorados"
        else
            cName:="oListMonitorados"
        endif
        frmObjeto.&(cName).AddItem({hb_ntos(hItem["id"]),;
                                    hItem["tipo"],;
                                    hItem["objeto"],;
                                    hItem["descricao"],;
                                    hb_ntos(hItem["nivel"]),;
                                    hItem["del"]})
    Next
    Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
    &&Função generica, serve para adicionar ou retirar o objeto do monitoramento
Static Function frmObjeto_oMonitoraAddRetira_Action( )
    Local lAdd:=(Upper(this.name)==Upper("oMonitoraAdd"))
    Local aItem,cGrid:=IIF(lAdd,"oListNaoMonitorados","oListMonitorados")
    Local cOut := IIF(!lAdd,"oListNaoMonitorados","oListMonitorados")
    
    //Prevenção de erro de nada selecionado;
    if frmObjeto.&(cGrid).value=0
        Return .F.
    endif
    
    //Obtem a linha do GRID
    aItem := frmObjeto.&(cGrid).item(frmObjeto.&(cGrid).value)
    
    //Prevenção de erro, objeto é o mesmo que esta mostrando?
    if !(frmObjeto.oCodidobj.Value>0 .and.frmObjeto.oCodidobj.Value==val(aItem[1]))
        Return .F.
    endif
    
    //Se for uma adição é necessário definir o nível de acesso.
    if lAdd .and. frmObjeto.oNivel.value<=1
        MsgInfo("Ajuste o nivel de acesso para determinar o controle!")
        frmObjeto.oNivel.Setfocus()
        Return .F.
    endif
    
    //Prepara o comando
    //Se qualquer valor for alterado diretamente na base vai invalidar o CRC
    oQuery.SQL := "Update tabobjeto set descricao='"+FrmObjeto.oDescricao.value+;
                  "',nivel="+str(IIF(lAdd,frmObjeto.oNivel.value-1,0),1)+;
                  ",crc='"+HB_MD5(frmObjeto.oTipo.Value+frmObjeto.oObjeto.Value+frmObjeto.oDescricao.Value+hb_ntos(frmObjeto.oNivel.Value-1))+"'"
    oQuery.SQL += " Where codidobj="+hb_ntos(FrmObjeto.oCodIdobj.value)+";"

    //Executa o comando
    oQuery.Execute()
    If oQuery.ErrorSQL()
        Return FALSE
    Endif
    
    //Ajusta a linha ajustada para envio ao GRID
    aItem[4] := frmObjeto.oDescricao.Value 
    aItem[5] := IIF(lAdd,hb_ntos(frmObjeto.oNivel.Value-1),"0")
    
    //Atualiza o GRID de entrada
    FrmObjeto.&(cOut).AddItem(aItem)
    
    //Elimina a linha do GRID de saida
    FrmObjeto.&(cGrid).DeleteItem(frmObjeto.&(cGrid).value)    
    Return TRUE

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
    &&Função genérica que controla os GRIDS
Static Function frmObjeto_oList_Onchange( )
    Local lInvert := (Upper(This.Name)==Upper("oListMonitorados"))
    Local aItem,cGrid:=If(!lInvert,"oListNaoMonitorados","oListMonitorados")
    
    //Prevenção de erro
    if frmObjeto.&(cGrid).value=0
        Return .F.
    endif

    
    //Obtem a linha selecionada
    aItem := frmObjeto.&(cGrid).item(frmObjeto.&(cGrid).value)  
    
    if aItem[6]="S"
        //Item excluido ou renomeado
        frmObjeto.oMonitoraAdd.Enabled    := FALSE
        frmObjeto.oMonitoraRetira.Enabled := FALSE
        frmObjeto.oMonitoraDelete.Enabled := TRUE
        //Obtendo o nome do grid para ser atualizado apos o delete
        //a propriedade cargo é um otimo recurso que evita a criação de variaveis
        FrmObjeto.oMonitoraDelete.Cargo   := cGrid 
    else
        //Habilita o botão apropriado
        frmObjeto.oMonitoraAdd.Enabled    := !lInvert
        frmObjeto.oMonitoraRetira.Enabled := lInvert
        frmObjeto.oMonitoraDelete.Enabled := FALSE
    endif                  
    //Atualiza os objetos de acordo com a linha selecionada
    frmObjeto.oCodidobj.Value                := val(aItem[1])
    frmObjeto.oTipo.Value                    := aItem[2]
    frmObjeto.oObjeto.Value                  := aItem[3]
    frmObjeto.oDescricao.Value               := aItem[4]
    frmObjeto.oNivel.Value                   := val(aItem[5])+1

    frmObjeto.oDescricao.Enabled             := !lInvert .and. aItem[6]="N"
    frmObjeto.oNivel.Enabled                 := !lInvert .and. aItem[6]="N"
    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function frmObjeto_oMonitoraDelete_Action( )
    Local cName := FrmObjeto.oMonitoraDelete.cargo
    //Neste caso deve ser excluido o objeto da tabela de acesso e 
    //posteriomente da tabela de objetos, nesta ordem
    oQuery.BeginTrans()
        oQuery.SQL := "Delete from tabAcesso where codidobj="+hb_ntos(frmObjeto.oCodidobj.Value)
        oQuery.Execute()
        if oQuery.ErrorSQL()
            oQuery.RollbackTrans()
            Return .F.
        endif
        oQuery.SQL := "Delete from tabobjeto where codidobj="+hb_ntos(frmObjeto.oCodidobj.Value)
        oQuery.Execute()
        if oQuery.ErrorSQL()
            oQuery.RollbackTrans()
            Return .F.
        endif        
    //Não havendo nenhum impecilho, efetiva a transação.
    oQuery.Committrans()
    //Atualiza o grid
    FrmObjeto.&(cName).DeleteItem(FrmObjeto.&(cName).value)
    Return .T.
