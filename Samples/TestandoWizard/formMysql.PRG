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
    Última alteração : 15/12/2020-22:02:25 Máquina: IMA2018 Usuário:ivani
    formMysql.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : TestSQL
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor MySQL oQuery

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_CAMPOSSQL  "`CODIGO`,`NOME`,`NASCIMENTO`,`ATIVO`,`OBS`"
#Define DEF_CAMPOS_PESQUISA { "NOME" , "NASCIMENTO" }
#Define DEF_CAMPOS_CABECALHO_PESQUISA { "NOME" , "NASCIMENTO" }
#Define DEF_CAMPOS_RELATORIO { "codigo" , "nome" , "nascimento" , "ativo" , "obs" }
#Define DEF_CAMPOS_CABECALHO_RELATORIO { "codigo" , "nome" , "nascimento" , "ativo" , "obs" }

Function LoadFrmformMysql()
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

    Load window formMysql as formMysql
        formMysql.Center()
    formMysql.activate()

    oQuery.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function formMysql_OnInit( oQuery )
        formMysql.oBtnNovo.Cargo                  := FALSE
        formMysql.oBtnEdit.Cargo                  := FALSE
        formMysql_ToolbarAction(0,Nil,oQuery)
        Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function formMysql_ToolbarAction( nParam , lFlag, oQuery ) //<=>TRUE/FALSE> \nnParam=(1.Sair,2.Novo,3.Edit,4.Save,5.Delete,6.Pesquisa,7.Report,8.Limpa,9.Enable/Disable)\nlFlag=(TRUE/FALSE)
    Local i,oRet,cSQL:='',cCondicao
    Local oHTML,cFile,aSQL:=DEF_CAMPOS_RELATORIO

    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            formMysql.Codigo.Enabled                  := TRUE
            IF !oQuery.Eof() //se recordset não estiver vazio
                formMysql.oBtnSave.Enabled                := FALSE
                formMysql.oBtnEdit.Enabled                := TRUE
                formMysql.oBtnNovo.Enabled                := TRUE
                formMysql.oBtnExclui.Enabled              := TRUE
                formMysql.oBtnNovo.Cargo                  := FALSE
                formMysql.oBtnEdit.Cargo                  := FALSE

                //Atribuição dos valores encontrados aos objetos
                formMysql.Codigo.Value                    := oQuery.Field.Codigo.Value
                formMysql.Nome.Value                      := oQuery.Field.Nome.Value
                formMysql.Nascimento.Value                := oQuery.Field.Nascimento.Value
                formMysql.Ativo.Value                     := oQuery.Field.Ativo.Value=1
                formMysql.Obs.Value                       := oQuery.Field.Obs.Value

                formMysql_ToolbarAction(9,FALSE,oQuery)
            else 
                If !formMysql.oBtnNovo.Cargo
                    formMysql.oBtnSave.Enabled                := FALSE
                    formMysql.oBtnEdit.Enabled                := FALSE
                    formMysql.oBtnNovo.Enabled                := TRUE
                    formMysql.oBtnExclui.Enabled              := FALSE
                Else
                    formMysql.oBtnSave.Enabled                := TRUE
                    formMysql.oBtnEdit.Enabled                := FALSE
                    formMysql.oBtnNovo.Enabled                := FALSE
                    formMysql.oBtnExclui.Enabled              := FALSE
                Endif
                formMysql_ToolbarAction(8,Nil,oQuery) //Limpa tudo
                formMysql_ToolbarAction(9,TRUE,oQuery)
            Endif

        Case nParam = 1 //Sair
            formMysql.Release()

        Case nParam = 2 //Novo Registro
            formMysql.oBtnNovo.Cargo                  := TRUE
            formMysql.oBtnEdit.Cargo                  := FALSE
            formMysql.oBtnSave.Enabled                := TRUE
            formMysql.oBtnEdit.Enabled                := FALSE
            formMysql.oBtnNovo.Enabled                := FALSE
            formMysql.oBtnExclui.Enabled              := FALSE

            //Atribuição de valores nulos aos objetos
            formMysql_ToolbarAction(8,TRUE,oQuery)

            formMysql.Codigo.SetFocus()
            formMysql_ToolbarAction(9,TRUE,oQuery)

        Case nParam = 3 //Editar Registro atual
            formMysql.oBtnNovo.Cargo                  := FALSE
            formMysql.oBtnSave.Enabled                := TRUE
            formMysql.oBtnEdit.Enabled                := FALSE
            formMysql.oBtnExclui.Enabled              := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            formMysql.Codigo.Enabled                  := FALSE
            formMysql.Nome.Enabled                    := TRUE
            formMysql.Nascimento.Enabled              := TRUE
            formMysql.Ativo.Enabled                   := TRUE
            formMysql.Obs.Enabled                     := TRUE

            formMysql_ToolbarAction(9,TRUE,oQuery)

        Case nParam = 4 //Salvar os dados no banco de dados

            cSQL:='Select '+DEF_CAMPOSSQL+' from dado'

            cCondicao := ' Where '
            cCondicao += [CODIGO=]+Tipovar(formMysql.CODIGO.value)

            cCondicao += " LIMIT 1;"
            oQuery.Open(cSQL + cCondicao)
            IF oQuery.Eof()
                IF formMysql.oBtnEdit.Cargo
                    MsgStop('Consulta não reportou registros para edição ! !')
                    Return FALSE
                Endif
                oQuery.AddNew()
                If oQuery.ErrorSQL()
                    Return FALSE
                Endif
                oQuery.Field.CODIGO.value                 := formMysql.CODIGO.value
            Else
                IF formMysql.oBtnNovo.Cargo
                    MsgStop('Consulta Reportou registro existente ! !')
                    Return FALSE
                Endif
            Endif
            oQuery.Field.Nome.Value                   := formMysql.Nome.value
            oQuery.Field.Nascimento.Value             := formMysql.Nascimento.value
            oQuery.Field.Ativo.Value                  := IIF(formMysql.Ativo.value,1,0)
            oQuery.Field.Obs.Value                    := formMysql.Obs.value

            oQuery.Update()

            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            formMysql_ToolbarAction(9,FALSE,oQuery)
            formMysql.Codigo.Enabled                  := TRUE

            formMysql.Tab1.Value :=1
            formMysql.CODIGO.SetFocus()

            formMysql.oBtnSave.Enabled                := FALSE
            formMysql.oBtnEdit.Enabled                := TRUE
            formMysql.oBtnNovo.Enabled                := TRUE
            formMysql.oBtnExclui.Enabled              := TRUE
        Case nParam = 5 //Exclusão de registro
            if !Confirma("Tem certeza que deseja excluir este registro ?")
                Return FALSE
            Endif
            cSQL := "Delete from dado"
            cSQL += ' Where '
            cSQL += [Codigo=]+Tipovar(formMysql.Codigo.value)

            oQuery.Execute(cSQL)

            oQuery.Open('Select '+DEF_CAMPOSSQL+' from dado LIMIT 1;')

            formMysql_OnInit(oQuery)
            formMysql_ToolbarAction(9,FALSE,oQuery)

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
                formMysql_ToolbarAction(0,Nil,oQuery)
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
            formMysql.Codigo.Value                    :=  0
            formMysql.Nome.Value                      :=  Nil
            formMysql.Nascimento.Value                :=  Ctod('')
            formMysql.Ativo.Value                     :=  FALSE
            formMysql.Obs.Value                       :=  Nil

        Case nParam = 9 //Habilita ou desabilita os controles
            formMysql.Nome.Enabled                    := lFlag
            formMysql.Nascimento.Enabled              := lFlag
            formMysql.Ativo.Enabled                   := lFlag
            formMysql.Obs.Enabled                     := lFlag

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function formMysql_Codigo_OnEnter(oQuery )
    Local aSave:={},cSQL
    AADD(aSave,formMysql.Codigo.value)
    cSQL:="Select "+DEF_CAMPOSSQL+" from dado"
    cSQL += ' Where '
    cSQL += [Codigo=]+Tipovar(formMysql.Codigo.value)

    oQuery.Open(cSQL)
    IF !oQuery.Eof()
        formMysql_ToolbarAction(0,Nil,oQuery)
    Else
        formMysql_ToolbarAction(2,Nil,oQuery)
        //devolve o valor que estava
        formMysql.Codigo.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function formMysql_Obs_OnEnter(oQuery )
    if MsgYesNo("Salvar o registro no banco de dados ?","Confirmação")
        formMysql_ToolbarAction(4,Nil,oQuery)
    endif
    Return TRUE
