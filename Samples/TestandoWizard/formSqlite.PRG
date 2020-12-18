/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.120 RELEASE CANDIDATE (RC) 201213 1910"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.12.0 (32-bit)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2011030937)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 15/12/2020-21:46:55 Máquina: IMA2018 Usuário:ivani
    formSqlite.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : TestSQL
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor SQLite oQuery

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_CAMPOSSQL  "`CODIGO`,`NOME`,`NASCIMENTO`,`ATIVO`,`OBS`"
#Define DEF_CAMPOS_PESQUISA { "NOME" , "NASCIMENTO" }
#Define DEF_CAMPOS_CABECALHO_PESQUISA { "NOME" , "NASCIMENTO" }
#Define DEF_CAMPOS_RELATORIO { "codigo" , "nome" , "nascimento" , "ativo" , "obs" }
#Define DEF_CAMPOS_CABECALHO_RELATORIO { "codigo" , "nome" , "nascimento" , "ativo" , "obs" }

Function LoadFrmformSqlite()
    Local oQuery

    //Aqui atribuimos o Cursor do Servidor a variavel oQuery
    oQuery.New()

    //Seguindo a boa pratica SQL, trazemos apenas o registro necessário para carregar o form
    oQuery.SQL := 'Select '+DEF_CAMPOSSQL+' from dado LIMIT 1;' 
    oQuery.Open()
    IF !oQuery.IsOpen
        oQuery.ErrorSQL()
        Return FALSE
    Endif

    Load window formSqlite as formSqlite
        formSqlite.Center()
    formSqlite.activate()

    oQuery.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function formSqlite_OnInit( oQuery )
        formSqlite.oBtnNovo.Cargo                := FALSE
        formSqlite.oBtnEdit.Cargo                := FALSE
        formSqlite_ToolbarAction(0,Nil,oQuery)
        Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function formSqlite_ToolbarAction( nParam , lFlag, oQuery ) //<=>TRUE/FALSE> \nnParam=(1.Sair,2.Novo,3.Edit,4.Save,5.Delete,6.Pesquisa,7.Report,8.Limpa,9.Enable/Disable)\nlFlag=(TRUE/FALSE)
    Local i,oRet,cSQL:='',cCondicao
    Local oHTML,cFile,aSQL:=DEF_CAMPOS_RELATORIO

    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            formSqlite.Codigo.Enabled                := TRUE
            IF !oQuery.Eof() //se recordset não estiver vazio
                formSqlite.oBtnSave.Enabled              := FALSE
                formSqlite.oBtnEdit.Enabled              := TRUE
                formSqlite.oBtnNovo.Enabled              := TRUE
                formSqlite.oBtnExclui.Enabled            := TRUE
                formSqlite.oBtnNovo.Cargo                := FALSE
                formSqlite.oBtnEdit.Cargo                := FALSE

                //Atribuição dos valores encontrados aos objetos
                formSqlite.Codigo.Value                  := oQuery.Field.Codigo.Value
                formSqlite.Nome.Value                    := oQuery.Field.Nome.Value
                formSqlite.Nascimento.Value              := ctod(oQuery.Field.Nascimento.Value)
                formSqlite.Ativo.Value                   := oQuery.Field.Ativo.Value=1
                formSqlite.Obs.Value                     := oQuery.Field.Obs.Value

                formSqlite_ToolbarAction(9,FALSE,oQuery)
            else 
                If !formSqlite.oBtnNovo.Cargo
                    formSqlite.oBtnSave.Enabled              := FALSE
                    formSqlite.oBtnEdit.Enabled              := FALSE
                    formSqlite.oBtnNovo.Enabled              := TRUE
                    formSqlite.oBtnExclui.Enabled            := FALSE
                Else
                    formSqlite.oBtnSave.Enabled              := TRUE
                    formSqlite.oBtnEdit.Enabled              := FALSE
                    formSqlite.oBtnNovo.Enabled              := FALSE
                    formSqlite.oBtnExclui.Enabled            := FALSE
                Endif
                formSqlite_ToolbarAction(8,Nil,oQuery) //Limpa tudo
                formSqlite_ToolbarAction(9,TRUE,oQuery)
            Endif

        Case nParam = 1 //Sair
            formSqlite.Release()

        Case nParam = 2 //Novo Registro
            formSqlite.oBtnNovo.Cargo                := TRUE
            formSqlite.oBtnEdit.Cargo                := FALSE
            formSqlite.oBtnSave.Enabled              := TRUE
            formSqlite.oBtnEdit.Enabled              := FALSE
            formSqlite.oBtnNovo.Enabled              := FALSE
            formSqlite.oBtnExclui.Enabled            := FALSE

            //Atribuição de valores nulos aos objetos
            formSqlite_ToolbarAction(8,TRUE,oQuery)

            formSqlite.Codigo.SetFocus()
            formSqlite_ToolbarAction(9,TRUE,oQuery)

        Case nParam = 3 //Editar Registro atual
            formSqlite.oBtnNovo.Cargo                := FALSE
            formSqlite.oBtnSave.Enabled              := TRUE
            formSqlite.oBtnEdit.Enabled              := FALSE
            formSqlite.oBtnExclui.Enabled            := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            formSqlite.Codigo.Enabled                := FALSE
            formSqlite.Nome.Enabled                  := TRUE
            formSqlite.Nascimento.Enabled            := TRUE
            formSqlite.Ativo.Enabled                 := TRUE
            formSqlite.Obs.Enabled                   := TRUE

            formSqlite_ToolbarAction(9,TRUE,oQuery)

        Case nParam = 4 //Salvar os dados no banco de dados

            cSQL:='Select '+DEF_CAMPOSSQL+' from dado'

            cCondicao := ' Where '
            cCondicao += [CODIGO=]+Tipovar(formSqlite.CODIGO.value)

            cCondicao += " LIMIT 1;"
            oQuery.Open(cSQL + cCondicao)
            IF oQuery.Eof()
                IF formSqlite.oBtnEdit.Cargo
                    MsgStop('Consulta não reportou registros para edição ! !')
                    Return FALSE
                Endif
                oQuery.AddNew()
                If oQuery.ErrorSQL()
                    Return FALSE
                Endif
                oQuery.Field.CODIGO.value                := formSqlite.CODIGO.value
            Else
                IF formSqlite.oBtnNovo.Cargo
                    MsgStop('Consulta Reportou registro existente ! !')
                    Return FALSE
                Endif
            Endif
            oQuery.Field.Nome.Value                  := formSqlite.Nome.value
            oQuery.Field.Nascimento.Value            := dtoc(formSqlite.Nascimento.value)
            oQuery.Field.Ativo.Value                 := IIF(formSqlite.Ativo.value,1,0)
            oQuery.Field.Obs.Value                   := formSqlite.Obs.value

            oQuery.Update()

            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            formSqlite_ToolbarAction(9,FALSE,oQuery)
            formSqlite.Codigo.Enabled                := TRUE

            formSqlite.Tab1.Value :=1
            formSqlite.CODIGO.SetFocus()

            formSqlite.oBtnSave.Enabled              := FALSE
            formSqlite.oBtnEdit.Enabled              := TRUE
            formSqlite.oBtnNovo.Enabled              := TRUE
            formSqlite.oBtnExclui.Enabled            := TRUE
        Case nParam = 5 //Exclusão de registro
            if !Confirma("Tem certeza que deseja excluir este registro ?")
                Return FALSE
            Endif
            cSQL := "Delete from dado"
            cSQL += ' Where '
            cSQL += [Codigo=]+Tipovar(formSqlite.Codigo.value)

            oQuery.Execute(cSQL)

            oQuery.Open('Select '+DEF_CAMPOSSQL+' from dado LIMIT 1;')

            formSqlite_OnInit(oQuery)
            formSqlite_ToolbarAction(9,FALSE,oQuery)

        Case nParam = 6 //Pesquisar
            oQuery.Open("Select  "+DEF_CAMPOSSQL+" FROM dado LIMIT 100;")
            /*
            //Passando os campos escolhidos no wizard para compor a pesquisa
            //Param 2:  Campo Alvo,será o campo chave a ser buscado na consulta
            //Param 3:  Campos que estarão no GRID, escolha campos que ajude o usuário a identificar homógrafo
            //Param 4:  Cabeçalho das colunas no GRID
            */
            oRet := PesquisaPadraoCRUD(oQuery,"NOME",DEF_CAMPOS_PESQUISA,DEF_CAMPOS_CABECALHO_PESQUISA)

            if Valtype(oRet)="O"
                cSQL := "Select "+DEF_CAMPOSSQL+" from dado"
                cSQL += ' Where '
                cSQL += [Codigo=]+Tipovar(oRet:Codigo)
                oQuery.Open(cSQL)
                //Se achar preenche, senão limpa tudo
                formSqlite_ToolbarAction(0,Nil,oQuery)
            Endif

        Case nParam = 7 //
            cFile := PutFile({{"*.html","*.html"}},"Nome do arquivo",,,[dado_]+Dtos(Date())+"_"+StrTran(Time(),":","")+".html")
            if empty(cFile)
                Return FALSE 
            Endif

            //Colocando o colchete para tirar conflito de nomes de campos
            cSQL := ""
            For i=1 to len(aSQL)
                cSQL+="`"+aSql[i]+"`,"
            Next
            cSQL := Substr(cSQL,1,len(cSQL)-1)

            //Passando a consulta para o Recordset
            cSQL := "Select "+cSQL+" from dado"
            /*
            Aqui você pode incluir  as clausulas Where/order by para um resultado
            mais refinado em filtro e ordenação para o relatório
            cSQL += 'Where ... order by ...'
            */

            //Enviado a consulta para o servidor de Banco de dados
            oQuery.Open(cSQL)
            IF !oQuery.IsOpen()
                oQuery.ErrorSQL()
                Return FALSE
            Endif

            oHtml            := THtmlReport():New()
            oHtml:Rs         := oQuery
            oHtml:Title      := "<h2>Relatório dado</h2>"
            oHtml:File       := cFile
            oHtml:Fields     := aSQL
            oHtml:Header     := DEF_CAMPOS_CABECALHO_RELATORIO
            /*oHtml:FontName := "Arial"
            oHtml:FontSize   := 1
            oHtml:CharSet    := "ISO-8859-1"
            oHtml:BackGround := "#b3d1ff"*/
            oHTml:Report()
            oHtml:Show()
            *oHtml:Zip()
            Return TRUE 

        Case nParam = 8 //Limpa tudo
            formSqlite.Codigo.Value                  :=  0
            formSqlite.Nome.Value                    :=  Nil
            formSqlite.Nascimento.Value              :=  Nil
            formSqlite.Ativo.Value                   :=  FALSE
            formSqlite.Obs.Value                     :=  Nil

        Case nParam = 9 //Habilita ou desabilita os controles
            formSqlite.Nome.Enabled                  := lFlag
            formSqlite.Nascimento.Enabled            := lFlag
            formSqlite.Ativo.Enabled                 := lFlag
            formSqlite.Obs.Enabled                   := lFlag

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function formSqlite_Codigo_OnEnter(oQuery )
    Local aSave:={},cSQL
    AADD(aSave,formSqlite.Codigo.value)
    cSQL:="Select "+DEF_CAMPOSSQL+" from dado"
    cSQL += ' Where '
    cSQL += [Codigo=]+Tipovar(formSqlite.Codigo.value)

    oQuery.Open(cSQL)
    IF !oQuery.Eof()
        formSqlite_ToolbarAction(0,Nil,oQuery)
    Else
        formSqlite_ToolbarAction(2,Nil,oQuery)
        //devolve o valor que estava
        formSqlite.Codigo.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function formSqlite_Obs_OnEnter(oQuery )
    if MsgYesNo("Salvar o registro no banco de dados ?","Confirmação")
        formSqlite_ToolbarAction(4,Nil,oQuery)
    endif
    Return TRUE
