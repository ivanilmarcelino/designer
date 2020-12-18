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
    Última alteração : 17/12/2020-19:01:56 Máquina: IMA2018 Usuário:ivani
    FormAccess.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : TestSQL
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor SQLAdo oQuery

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_CAMPOSSQL  "`CODIGO`,`NOME`,`NASCIMENTO`,`ATIVO`,`OBS`"
#Define DEF_CAMPOS_PESQUISA { "NOME" , "NASCIMENTO" }
#Define DEF_CAMPOS_CABECALHO_PESQUISA { "NOME" , "NASCIMENTO" }
#Define DEF_CAMPOS_RELATORIO { "codigo" , "nome" , "nascimento" , "ativo" , "obs" }
#Define DEF_CAMPOS_CABECALHO_RELATORIO { "codigo" , "nome" , "nascimento" , "ativo" , "obs" }

Function LoadFrmFormAccess()
    Local oQuery

    //Aqui atribuimos o Cursor do Servidor a variavel oQuery
    oQuery.New()

    //Seguindo a boa pratica SQL, trazemos apenas o registro necessário para carregar o form
    oQuery.SQL := 'Select top 1 '+DEF_CAMPOSSQL+' from dado ;' 
    oQuery.Open()
    IF !oQuery.IsOpen
        oQuery.ErrorSQL()
        Return FALSE
    Endif

    Load window FormAccess as FormAccess
        FormAccess.Center()
    FormAccess.activate()

    oQuery.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FormAccess_OnInit( oQuery )
        FormAccess.oBtnNovo.Cargo                 := FALSE
        FormAccess.oBtnEdit.Cargo                 := FALSE
        FormAccess_ToolbarAction(0,Nil,oQuery)
        Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function FormAccess_ToolbarAction( nParam , lFlag, oQuery ) //<=>TRUE/FALSE> \nnParam=(1.Sair,2.Novo,3.Edit,4.Save,5.Delete,6.Pesquisa,7.Report,8.Limpa,9.Enable/Disable)\nlFlag=(TRUE/FALSE)
    Local i,oRet,cSQL:='',cCondicao
    Local oHTML,cFile,aSQL:=DEF_CAMPOS_RELATORIO

    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            FormAccess.Codigo.Enabled                 := TRUE
            IF !oQuery.Eof() //se recordset não estiver vazio
                FormAccess.oBtnSave.Enabled               := FALSE
                FormAccess.oBtnEdit.Enabled               := TRUE
                FormAccess.oBtnNovo.Enabled               := TRUE
                FormAccess.oBtnExclui.Enabled             := TRUE
                FormAccess.oBtnNovo.Cargo                 := FALSE
                FormAccess.oBtnEdit.Cargo                 := FALSE

                //Atribuição dos valores encontrados aos objetos
                FormAccess.Codigo.Value                   := oQuery.Field.Codigo.Value
                FormAccess.Nome.Value                     := oQuery.Field.Nome.Value
                FormAccess.Nascimento.Value               := oQuery.Field.Nascimento.Value
                FormAccess.Ativo.Value                    := oQuery.Field.Ativo.Value
                FormAccess.Obs.Value                      := oQuery.Field.Obs.Value

                FormAccess_ToolbarAction(9,FALSE,oQuery)
            else 
                If !FormAccess.oBtnNovo.Cargo
                    FormAccess.oBtnSave.Enabled               := FALSE
                    FormAccess.oBtnEdit.Enabled               := FALSE
                    FormAccess.oBtnNovo.Enabled               := TRUE
                    FormAccess.oBtnExclui.Enabled             := FALSE
                Else
                    FormAccess.oBtnSave.Enabled               := TRUE
                    FormAccess.oBtnEdit.Enabled               := FALSE
                    FormAccess.oBtnNovo.Enabled               := FALSE
                    FormAccess.oBtnExclui.Enabled             := FALSE
                Endif
                FormAccess_ToolbarAction(8,Nil,oQuery) //Limpa tudo
                FormAccess_ToolbarAction(9,TRUE,oQuery)
            Endif

        Case nParam = 1 //Sair
            FormAccess.Release()

        Case nParam = 2 //Novo Registro
            FormAccess.oBtnNovo.Cargo                 := TRUE
            FormAccess.oBtnEdit.Cargo                 := FALSE
            FormAccess.oBtnSave.Enabled               := TRUE
            FormAccess.oBtnEdit.Enabled               := FALSE
            FormAccess.oBtnNovo.Enabled               := FALSE
            FormAccess.oBtnExclui.Enabled             := FALSE

            //Atribuição de valores nulos aos objetos
            FormAccess_ToolbarAction(8,TRUE,oQuery)

            FormAccess.Codigo.SetFocus()
            FormAccess_ToolbarAction(9,TRUE,oQuery)

        Case nParam = 3 //Editar Registro atual
            FormAccess.oBtnNovo.Cargo                 := FALSE
            FormAccess.oBtnSave.Enabled               := TRUE
            FormAccess.oBtnEdit.Enabled               := FALSE
            FormAccess.oBtnExclui.Enabled             := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            FormAccess.Codigo.Enabled                 := FALSE
            FormAccess.Nome.Enabled                   := TRUE
            FormAccess.Nascimento.Enabled             := TRUE
            FormAccess.Ativo.Enabled                  := TRUE
            FormAccess.Obs.Enabled                    := TRUE

            FormAccess_ToolbarAction(9,TRUE,oQuery)

        Case nParam = 4 //Salvar os dados no banco de dados

            cSQL:='Select top 1 '+DEF_CAMPOSSQL+' from dado'

            cCondicao := ' Where '
            cCondicao += [CODIGO=]+Tipovar(FormAccess.CODIGO.value)

            oQuery.Open(cSQL + cCondicao)
            IF oQuery.Eof()
                IF FormAccess.oBtnEdit.Cargo
                    MsgStop('Consulta não reportou registros para edição ! !')
                    Return FALSE
                Endif
                oQuery.AddNew()
                If oQuery.ErrorSQL()
                    Return FALSE
                Endif
                oQuery.Field.CODIGO.value                 := FormAccess.CODIGO.value
            Else
                IF FormAccess.oBtnNovo.Cargo
                    MsgStop('Consulta Reportou registro existente ! !')
                    Return FALSE
                Endif
            Endif
            oQuery.Field.Nome.Value                   := FormAccess.Nome.value
            oQuery.Field.Nascimento.Value             := FormAccess.Nascimento.value
            oQuery.Field.Ativo.Value                  := FormAccess.Ativo.value
            oQuery.Field.Obs.Value                    := FormAccess.Obs.value

            oQuery.Update()

            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            FormAccess_ToolbarAction(9,FALSE,oQuery)
            FormAccess.Codigo.Enabled                 := TRUE

            FormAccess.Tab1.Value :=1
            FormAccess.CODIGO.SetFocus()

            FormAccess.oBtnSave.Enabled               := FALSE
            FormAccess.oBtnEdit.Enabled               := TRUE
            FormAccess.oBtnNovo.Enabled               := TRUE
            FormAccess.oBtnExclui.Enabled             := TRUE
        Case nParam = 5 //Exclusão de registro
            if !Confirma("Tem certeza que deseja excluir este registro ?")
                Return FALSE
            Endif
            cSQL := "Delete from dado"
            cSQL += ' Where '
            cSQL += [Codigo=]+Tipovar(FormAccess.Codigo.value)

            oQuery.Execute(cSQL)

            oQuery.Open('Select top 1 '+DEF_CAMPOSSQL+' from dado;')

            FormAccess_OnInit(oQuery)
            FormAccess_ToolbarAction(9,FALSE,oQuery)

        Case nParam = 6 //Pesquisar
            oQuery.Open("Select top 100  "+DEF_CAMPOSSQL+" FROM dado;")
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
                FormAccess_ToolbarAction(0,Nil,oQuery)
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
            FormAccess.Codigo.Value                   :=  0
            FormAccess.Nome.Value                     :=  Nil
            FormAccess.Nascimento.Value               :=  Ctod('')
            FormAccess.Ativo.Value                    :=  .F.
            FormAccess.Obs.Value                      :=  Nil

        Case nParam = 9 //Habilita ou desabilita os controles
            FormAccess.Nome.Enabled                   := lFlag
            FormAccess.Nascimento.Enabled             := lFlag
            FormAccess.Ativo.Enabled                  := lFlag
            FormAccess.Obs.Enabled                    := lFlag

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function FormAccess_Codigo_OnEnter(oQuery )
    Local aSave:={},cSQL
    AADD(aSave,FormAccess.Codigo.value)
    cSQL:="Select "+DEF_CAMPOSSQL+" from dado"
    cSQL += ' Where '
    cSQL += [Codigo=]+Tipovar(FormAccess.Codigo.value)

    oQuery.Open(cSQL)
    IF !oQuery.Eof()
        FormAccess_ToolbarAction(0,Nil,oQuery)
    Else
        FormAccess_ToolbarAction(2,Nil,oQuery)
        //devolve o valor que estava
        FormAccess.Codigo.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function FormAccess_Obs_OnEnter(oQuery )
    if MsgYesNo("Salvar o registro no banco de dados ?","Confirmação")
        FormAccess_ToolbarAction(4,Nil,oQuery)
    endif
    Return TRUE
