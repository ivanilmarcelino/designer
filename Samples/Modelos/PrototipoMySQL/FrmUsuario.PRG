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
    Última alteração : 26/04/2022-10:53:48 Máquina: IMA2018 Usuário:Ivanil
    FrmUsuario.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : Transacao
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor MySQL oQuery

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_RANGE_RESULT "100"
#Define DEF_CAMPOSSQL  "`CODIGO`,`USUARIO`,`NOME`,`PASSWORD`,`STATUS`,`NIVEL`,`CRC`,`ALTERASENHA`"
#Define DEF_CAMPOS_PESQUISA { "NOME" , "USUARIO" }
#Define DEF_CAMPOS_CABECALHO_PESQUISA { "Nome" , "Usuario" }
Function LoadFrmFrmUsuario()
    Local oQuery

    //Aqui atribuimos o Cursor do Servidor a variavel oQuery
    oQuery.New()

    //Seguindo a boa pratica SQL, trazemos apenas o registro necessário para carregar o form
    oQuery.SQL := 'Select '+DEF_CAMPOSSQL+' from tabuser LIMIT 1;' 
    oQuery.Open()
    IF !oQuery.IsOpen
        oQuery.ErrorSQL()
        Return FALSE
    Endif

    Load window FrmUsuario as FrmUsuario
        FrmUsuario.Center()
    FrmUsuario.activate()

    oQuery.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FrmUsuario_OnInit( oQuery )
        FrmUsuario.oBtnNovo.Cargo              := FALSE
        FrmUsuario.oBtnEdit.Cargo              := FALSE
        FrmUsuario_ToolbarAction(0,Nil,oQuery)
        Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function FrmUsuario_ToolbarAction( nParam , lFlag, oQuery )
    Local oRet,cSQL:='',cCondicao,i,aItem,cCRC
    FrmUsuario.oBtnNaoAutoriza.enabled := .F.
    FrmUsuario.oBtnAutoriza.enabled := .F.
    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            FrmUsuario.oBtnNovo.Picture            := 'Minigui_edit_new'
            FrmUsuario.oBtnNovo.Action             := {||FrmUsuario_ToolbarAction(2,Nil,oQuery)}
            FrmUsuario.oBtnEdit.Picture            := 'Minigui_edit_edit'
            FrmUsuario.oBtnEdit.Action             := {||FrmUsuario_ToolbarAction(3,Nil,oQuery)}
            FrmUsuario.oCodigo.Enabled             := TRUE
            IF !oQuery.Eof() //se recordset não estiver vazio
                FrmUsuario.oBtnSave.Enabled            := FALSE
                FrmUsuario.oBtnEdit.Enabled            := TRUE
                FrmUsuario.oBtnNovo.Enabled            := TRUE
                FrmUsuario.oBtnExclui.Enabled          := TRUE
                FrmUsuario.oBtnNovo.Cargo              := FALSE
                FrmUsuario.oBtnEdit.Cargo              := FALSE

                //Atribuição dos valores encontrados aos objetos
                FrmUsuario.oCodigo.Value               := oQuery.Field.Codigo.Value
                FrmUsuario.oUsuario.Value              := oQuery.Field.Usuario.Value
                FrmUsuario.oNome.Value                 := oQuery.Field.Nome.Value
                FrmUsuario.oPassword.Value             := oQuery.Field.Password.Value
                FrmUsuario.oPassword.Cargo             := oQuery.Field.Password.Value
                FrmUsuario.oStatus.Value               := oQuery.Field.Status.Value
                FrmUsuario.oNivel.Value                := oQuery.Field.Nivel.Value

                FrmUsuario_ToolbarAction(10,FALSE,oQuery)
            else 
                If !FrmUsuario.oBtnNovo.Cargo
                    FrmUsuario.oBtnSave.Enabled            := FALSE
                    FrmUsuario.oBtnEdit.Enabled            := FALSE
                    FrmUsuario.oBtnNovo.Enabled            := TRUE
                    FrmUsuario.oBtnExclui.Enabled          := FALSE
                Else
                    FrmUsuario.oBtnSave.Enabled            := TRUE
                    FrmUsuario.oBtnEdit.Enabled            := FALSE
                    FrmUsuario.oBtnNovo.Enabled            := FALSE
                    FrmUsuario.oBtnExclui.Enabled          := FALSE
                Endif
                FrmUsuario_ToolbarAction(9,Nil,oQuery) //Limpa tudo
                FrmUsuario_ToolbarAction(10,TRUE,oQuery)
            Endif

        Case nParam = 1 //Sair
            FrmUsuario.Release()

        Case nParam = 2 //Novo Registro
            FrmUsuario.oBtnNovo.Cargo              := TRUE
            FrmUsuario.oBtnEdit.Cargo              := FALSE
            FrmUsuario.oBtnSave.Enabled            := TRUE
            FrmUsuario.oBtnEdit.Enabled            := FALSE
            FrmUsuario.oBtnExclui.Enabled          := FALSE

            //Atribuição de valores nulos aos objetos
            FrmUsuario_ToolbarAction(9,TRUE,oQuery)

            FrmUsuario.oUsuario.SetFocus()
            FrmUsuario_ToolbarAction(10,TRUE,oQuery)

            FrmUsuario.oBtnNovo.Picture            := 'Minigui_edit_cancel'
            FrmUsuario.oBtnNovo.Action             := {||FrmUsuario_ToolbarAction(0,Nil,oQuery)}

        Case nParam = 3 //Editar Registro atual
            FrmUsuario.oBtnNovo.Cargo              := FALSE
            FrmUsuario.oBtnSave.Enabled            := TRUE
            FrmUsuario.oBtnNovo.Enabled            := FALSE
            FrmUsuario.oBtnEdit.Cargo              := TRUE
            FrmUsuario.oBtnExclui.Enabled          := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            FrmUsuario.oCodigo.Enabled             := FALSE
            FrmUsuario_ToolbarAction(10,TRUE,oQuery)

            FrmUsuario.oBtnEdit.Picture            := 'Minigui_edit_cancel'
            FrmUsuario.oBtnEdit.Action             := {||FrmUsuario_ToolbarAction(0,Nil,oQuery)}

        Case nParam = 4 //Salvar os dados no banco de dados

            cSQL:='Select '+DEF_CAMPOSSQL+' from tabuser'

            cCondicao := ' Where '
            cCondicao += [CODIGO=]+Tipovar(FrmUsuario.oCODIGO.value)

            cCondicao += " LIMIT 1;"
            
            //Codigo gerado pelo wizard modificado
            //Vamos abrir uma Transacao
            oQuery.BeginTrans()
            
                oQuery.Open(cSQL + cCondicao)
                IF oQuery.Eof()
                    IF FrmUsuario.oBtnEdit.Cargo
                        MsgStop('Consulta não reportou registros para edição ! !')
                        Return FALSE
                    Endif
                    oQuery.AddNew()
                    If oQuery.ErrorSQL()
                        oQuery.Rollbacktrans()
                        Return FALSE
                    Endif
                    //campo auto_incremento; 
                    //oQuery.Field.CODIGO.value              := FrmUsuario.oCODIGO.value
                Else
                    IF FrmUsuario.oBtnNovo.Cargo
                        oQuery.Rollbacktrans()
                        MsgStop('Consulta Reportou registro existente ! !')
                        Return FALSE
                    Endif
                Endif
                oQuery.Field.Usuario.Value             := FrmUsuario.oUsuario.value
                oQuery.Field.Nome.Value                := FrmUsuario.oNome.value
                
                //Aqui verificamos se houve mudança de Senha 
                if FrmUsuario.oPassword.Value <> FrmUsuario.oPassword.Cargo
                    //Se mudou é necessario aplicar md5 no valor do objeto 
                    FrmUsuario.oPassword.Value   := GetToxNo(FrmUsuario.oPassword.Value)
                    oQuery.Field.Password.Value  := FrmUsuario.oPassword.value
                endif
                
                oQuery.Field.Status.Value              := FrmUsuario.oStatus.value
                oQuery.Field.Nivel.Value               := FrmUsuario.oNivel.value
                oQuery.Field.CRC.value                 := HB_MD5(FrmUsuario.oUsuario.value+;
                                                                 FrmUsuario.oNome.value+;
                                                                 FrmUsuario.oPassword.value+;
                                                                 Tipovar(FrmUsuario.oStatus.value)+;
                                                                 hb_ntos(FrmUsuario.oNivel.value))
                //Obrigar o usuário a trocar a senha no proximo acesso.
                oQuery.Field.alterasenha.Value         :=  TRUE 

                oQuery.Update()

                If oQuery.ErrorSQL()
                    oQuery.Rollbacktrans()
                    Return FALSE
                Endif
                
                //Aqui vamos obter o ultimo auto_incremento caso tenha ocorrido  um Insert
                if FrmUsuario.oBtnNovo.Cargo
                    oQuery.SQL :="select LAST_INSERT_ID() as codigo;"
                    oQuery.Open()
                    FrmUsuario.oCODIGO.value := oQuery.Field.codigo.value
                endif
                
                //vamos varrer o grid de autorizados e fazer os inserts
                For i=1 to FrmUsuario.oGridAutorizados.Itemcount
                    aItem := FrmUsuario.oGridAutorizados.item(i)
                    cCRC  := HB_MD5(StrZero(FrmUsuario.oCODIGO.value,10)+StrZero(val(aitem[1]),10))
                   
                    oQuery.SQL := "INSERT IGNORE INTO tabacesso (codigo, codidobj,crc) VALUES("+;
                                   hb_ntos(FrmUsuario.oCODIGO.value)+","+;
                                   aItem[1]+","+;
                                   "'"+cCRC+"')"
                    oQuery.Execute()
                    If oQuery.ErrorSQL()
                        oQuery.Rollbacktrans()
                        Return FALSE
                    Endif
                Next
                
                //Vamos percorrer o grid não autorizados e retirar a autorização
                For i=1 to FrmUsuario.oGridNaoAutorizados.Itemcount
                    aItem := FrmUsuario.oGridNaoAutorizados.item(i)
                    oQuery.SQL := "Delete from tabacesso where codigo="+hb_ntos(FrmUsuario.oCODIGO.value)+" and codidobj="+aItem[1]+";"
                    oQuery.Execute()
                    If oQuery.ErrorSQL()
                        oQuery.Rollbacktrans()
                        Return FALSE
                    Endif
                Next
            oQuery.CommitTrans()
            
            //Atualiza o cursor com os dados salvos;
            oQuery.SQL := "Select "+DEF_CAMPOSSQL+" from tabuser  Where CODIGO="+hb_ntos(FrmUsuario.oCODIGO.value)
            oQuery.Open()

            FrmUsuario_ToolbarAction(10,FALSE,oQuery)
            FrmUsuario.oCodigo.Enabled             := TRUE

            FrmUsuario.Tab1.Value :=1
            FrmUsuario.oCODIGO.SetFocus()

            FrmUsuario.oBtnSave.Enabled            := FALSE
            FrmUsuario.oBtnEdit.Enabled            := TRUE
            FrmUsuario.oBtnNovo.Enabled            := TRUE
            FrmUsuario.oBtnExclui.Enabled          := TRUE
            FrmUsuario_ToolbarAction(0,Nil,oQuery)

        Case nParam = 5 //Exclusão de registro
            //Nota de aviso; em caso de usuário dependendo da profundidade de segurança pode não ser boa pratica excluir
            //o recomendavel é alterar status ou determinar data de validade entre outras;
            //no caso deste prototipo, se houver delegado acesso ao usuario, a tentativa de excluir vai falhar por conta 
            //da regra de relacionamento; num nivel maior de profundidade de segurança isso pode envolver log, historico e outros
            MsgStop("Tem certeza que deseja excluir este registro ?"+CRLF+;
                    "***Nota: Recomendo apenas alterar o status do usuário")
            if !Confirma("Tem certeza que deseja excluir definitivamente este registro ?")
                Return FALSE
            Endif
            cSQL := "Delete from tabuser"
            cSQL += ' Where '
            cSQL += [Codigo=]+Tipovar(FrmUsuario.oCodigo.value)

            oQuery.Execute(cSQL)
            if !oQuery.ErrorSQL()
                oQuery.Open('Select '+DEF_CAMPOSSQL+' from tabuser LIMIT 1;')
                FrmUsuario_OnInit(oQuery)
            endif
            FrmUsuario_ToolbarAction(10,FALSE,oQuery)

        Case nParam = 6 //Pesquisar
            oQuery.Open("Select  "+DEF_CAMPOSSQL+" FROM tabuser LIMIT "+DEF_RANGE_RESULT)
            /*
            //Passando os campos escolhidos no wizard para compor a pesquisa
            //Param 2:  Campo Alvo,será o campo chave a ser buscado na consulta
            //Param 3:  Campos que estarão no GRID, escolha campos que ajude o usuário a identificar homógrafo
            //Param 4:  Cabeçalho das colunas no GRID
            */
            oRet := PesquisaPadraoCRUD(oQuery,"NOME",DEF_CAMPOS_PESQUISA,DEF_CAMPOS_CABECALHO_PESQUISA,/*{row,col,width,height}*/,Val(DEF_RANGE_RESULT))

            if Valtype(oRet)="O"
                cSQL := "Select "+DEF_CAMPOSSQL+" from tabuser"
                cSQL += ' Where '
                cSQL += [Codigo=]+Tipovar(oRet:Codigo)
                oQuery.Open(cSQL)
                //Se achar preenche, senão limpa tudo
                FrmUsuario_ToolbarAction(0,Nil,oQuery)
            Endif

        Case nParam = 9 //Limpa tudo
            FrmUsuario.oCodigo.Value               :=  0
            FrmUsuario.oUsuario.Value              :=  Nil
            FrmUsuario.oNome.Value                 :=  Nil
            FrmUsuario.oPassword.Value             :=  Nil
            FrmUsuario.oStatus.Value               :=  .F.
            FrmUsuario.oNivel.Value                :=  0

        Case nParam = 10 //Habilita ou desabilita os controles
            FrmUsuario.oUsuario.Enabled            := lFlag
            FrmUsuario.oNome.Enabled               := lFlag
            FrmUsuario.oPassword.Enabled           := lFlag
            FrmUsuario.oStatus.Enabled             := lFlag
            FrmUsuario.oNivel.Enabled              := lFlag

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function FrmUsuario_oCodigo_OnEnter(oQuery )
    Local aSave:={},cSQL
    AADD(aSave,FrmUsuario.oCodigo.value)
    cSQL:="Select "+DEF_CAMPOSSQL+" from tabuser"
    cSQL += ' Where '
    cSQL += [Codigo=]+Tipovar(FrmUsuario.oCodigo.value)

    oQuery.Open(cSQL)
    IF !oQuery.Eof()
        FrmUsuario_ToolbarAction(0,Nil,oQuery)
    Else
        FrmUsuario_ToolbarAction(2,Nil,oQuery)
        //devolve o valor que estava
        FrmUsuario.oCodigo.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************
Static Function FrmUsuario_oNivel_Onchange(oQuery )
    Local aItem
    //Preparando a consulta
    oQuery.SQL:=" select o.*,a.codigo as User from tabobjeto o "
    oQuery.SQL+=" left join tabacesso  a on a.codidobj=o.codidobj and a.codigo="+hb_ntos(frmUsuario.oCodigo.value)
    oQuery.SQl+=" where o.nivel>0 and o.nivel<="+hb_ntos(FrmUsuario.oNivel.Value)
    oQuery.Open()
    frmUsuario.oGridAutorizados.DeleteAllItems()
    FrmUsuario.oGridNaoAutorizados.DeleteAllItems()
    While !oQuery.eof()
        aItem := {hb_ntos(oQuery.field.codidobj.value),;
                  oQuery.field.tipo.value,;
                  oQuery.field.objeto.value,;
                  hb_AnsitoOem(oQuery.field.descricao.value),;
                  hb_ntos(oQuery.field.nivel.value)}
                  
        //O left Join garante todos os objetos user=empty =>Não autorizado
        if empty(oQuery.field.user.value)
            FrmUsuario.oGridNaoAutorizados.additem(aItem)
        else
            FrmUsuario.oGridAutorizados.additem(aItem)
        endif
        oQuery.MoveNext()
    Enddo
    oQuery.close()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FrmUsuario_oGrid_Onchange( )
    Local lAutoriza := (Upper(This.Name)== Upper("oGridAutorizados"))
    FrmUsuario.oBtnNaoAutoriza.Enabled := lAutoriza
    FrmUsuario.oBtnAutoriza.Enabled    := !lAutoriza
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FrmUsuario_oBtnAutorizacao_Action( )
    Local cName := Upper(This.Name)
    Local cGridIn,cGridOu,aLine
    if cName==Upper("oBtnNaoAutoriza")
        cGridIn:="oGridAutorizados"
        cGridOu:="oGridNaoAutorizados"
    else
        cGridIn:="oGridNaoAutorizados"
        cGridOu:="oGridAutorizados"
    endif
    aLine := FrmUsuario.&(cGridIn).item(FrmUsuario.&(cGridIn).Value)
    FrmUsuario.&(cGridOu).AddItem(aLine)
    FrmUsuario.&(cGridIn).DeleteItem(FrmUsuario.&(cGridIn).Value)
    Return .T.
