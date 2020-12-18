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
    Última alteração : 15/12/2020-21:07:35 Máquina: IMA2018 Usuário:ivani
    FormDBF.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : TestSQL
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor DBF cAlias

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_CAMPOS_RELATORIO { "CODIGO" , "NOME" , "NASCIMENTO" , "ATIVO" , "OBS" }
#Define DEF_CAMPOS_CABECALHO_RELATORIO { "CODIGO" , "NOME" , "NASCIMENTO" , "ATIVO" , "OBS" }

Function LoadFrmFormDBF()
    //Você pode criar sua própria função idGlobal() ou usar a interna, desta forma
    //um formulário pode ser aberto compartilhando a abertura com outro form aberto
    Local cAlias:=IdGlobal('Dbf')

    //Crie sua propria função Dbopen() utilizando os parametros fornecidos
    //a função Dbopen() interna é uma função simples, colocada apenas para deixar o codigo funcional
    //Sua função poderia verificar a existencia dos arquivos/indices e inclusive
    //criá-los em tempo de execução, use a estrutura de parametros indicada abaixo:
    //Dbopen(cFile,aIndices,[E:S],cAlias,cDrive:{Dbfntx,dbfcdx...})
    //Caso use driver diferente de DbfNtx, lembre de incluir o <request ...> apropriado no Main
    cAlias.Open("Dado.DBF",/*aIndices*/,"S"/*S-Shared;E-Exclusive*/,Nil/*"DBFCDX"*/)
    IF !cAlias.IsOpen()
        Return FALSE
    Endif
    
    if !File("dados.ntx")
        index on strzero(field->codigo,5) tag "01" to "dados.ntx"
    else
        DbSetIndex("dados.ntx")
    endif
    DbSEtorder("01")
    
    Load window FormDBF as FormDBF
        FormDBF.Center()
    FormDBF.activate()

    cAlias.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FormDBF_OnInit( cAlias )
        FormDBF.oBtnNovo.Cargo                    := FALSE
        FormDBF.oBtnEdit.Cargo                    := FALSE
        FormDBF_ToolbarAction(0,Nil,cAlias)
        Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function FormDBF_ToolbarAction( nParam , lFlag, cAlias ) //<=>TRUE/FALSE> \nnParam=(1.Sair,2.Novo,3.Edit,4.Save,5.Delete,6.Pesquisa,7.Report,8.Limpa,9.Enable/Disable)\nlFlag=(TRUE/FALSE)
    Local cCondicao
    Local oHTML,cFile,aSQL:=DEF_CAMPOS_RELATORIO

    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            FormDBF.Codigo.Enabled                    := TRUE
            IF !cAlias.Eof() //se recordset não estiver vazio
                FormDBF.oBtnSave.Enabled                  := FALSE
                FormDBF.oBtnEdit.Enabled                  := TRUE
                FormDBF.oBtnNovo.Enabled                  := TRUE
                FormDBF.oBtnExclui.Enabled                := TRUE
                FormDBF.oBtnNovo.Cargo                    := FALSE
                FormDBF.oBtnEdit.Cargo                    := FALSE

                //Atribuição dos valores encontrados aos objetos
                FormDBF.Codigo.Value                      := cAlias.Field.Codigo.Value
                FormDBF.Nome.Value                        := cAlias.Field.Nome.Value
                FormDBF.Nascimento.Value                  := cAlias.Field.Nascimento.Value
                FormDBF.Ativo.Value                       := cAlias.Field.Ativo.Value
                FormDBF.Obs.Value                         := cAlias.Field.Obs.Value

                FormDBF_ToolbarAction(9,FALSE,cAlias)
            else 
                If !FormDBF.oBtnNovo.Cargo
                    FormDBF.oBtnSave.Enabled                  := FALSE
                    FormDBF.oBtnEdit.Enabled                  := FALSE
                    FormDBF.oBtnNovo.Enabled                  := TRUE
                    FormDBF.oBtnExclui.Enabled                := FALSE
                Else
                    FormDBF.oBtnSave.Enabled                  := TRUE
                    FormDBF.oBtnEdit.Enabled                  := FALSE
                    FormDBF.oBtnNovo.Enabled                  := FALSE
                    FormDBF.oBtnExclui.Enabled                := FALSE
                Endif
                FormDBF_ToolbarAction(8,Nil,cAlias) //Limpa tudo
                FormDBF_ToolbarAction(9,TRUE,cAlias)
            Endif

        Case nParam = 1 //Sair
            FormDBF.Release()

        Case nParam = 2 //Novo Registro
            FormDBF.oBtnNovo.Cargo                    := TRUE
            FormDBF.oBtnEdit.Cargo                    := FALSE
            FormDBF.oBtnSave.Enabled                  := TRUE
            FormDBF.oBtnEdit.Enabled                  := FALSE
            FormDBF.oBtnNovo.Enabled                  := FALSE
            FormDBF.oBtnExclui.Enabled                := FALSE

            //Atribuição de valores nulos aos objetos
            FormDBF_ToolbarAction(8,TRUE,cAlias)

            FormDBF.Codigo.SetFocus()
            FormDBF_ToolbarAction(9,TRUE,cAlias)

        Case nParam = 3 //Editar Registro atual
            FormDBF.oBtnNovo.Cargo                    := FALSE
            FormDBF.oBtnSave.Enabled                  := TRUE
            FormDBF.oBtnEdit.Enabled                  := FALSE
            FormDBF.oBtnExclui.Enabled                := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            FormDBF.Codigo.Enabled                    := FALSE
            FormDBF.Nome.Enabled                      := TRUE
            FormDBF.Nascimento.Enabled                := TRUE
            FormDBF.Ativo.Enabled                     := TRUE
            FormDBF.Obs.Enabled                       := TRUE

            FormDBF_ToolbarAction(9,TRUE,cAlias)

        Case nParam = 4 //Salvar os dados no banco de dados

            cCondicao := ''
            cCondicao += StrZero(FormDBF.CODIGO.value,5)

            //(cCondicao) deve ser formatada de acordo com o indice para que DbSeek() retorne TRUE
            cAlias.Seek(cCondicao)
            IF !cAlias.Eof .and. !cAlias.Lock()
                MsgStop('Lock Failure!')
                Return FALSE
            Endif

            IF cAlias.Eof()
                IF FormDBF.oBtnEdit.Cargo
                    MsgStop('Consulta não reportou registros para edição ! !')
                    Return FALSE
                Endif
                cAlias.AddNew()
                If cAlias.ErrorSQL()
                    Return FALSE
                Endif
                cAlias.Field.CODIGO.value                 := FormDBF.CODIGO.value
            Else
                IF FormDBF.oBtnNovo.Cargo
                    MsgStop('Consulta Reportou registro existente ! !')
                    Return FALSE
                Endif
            Endif
            cAlias.Field.Nome.Value                   := FormDBF.Nome.value
            cAlias.Field.Nascimento.Value             := FormDBF.Nascimento.value
            cAlias.Field.Ativo.Value                  := FormDBF.Ativo.value
            cAlias.Field.Obs.Value                    := FormDBF.Obs.value

            cAlias.Update()

            If cAlias.ErrorSQL()
                Return FALSE
            Endif
            FormDBF_ToolbarAction(9,FALSE,cAlias)
            FormDBF.Codigo.Enabled                    := TRUE

            FormDBF.Tab1.Value :=1
            FormDBF.CODIGO.SetFocus()

            FormDBF.oBtnSave.Enabled                  := FALSE
            FormDBF.oBtnEdit.Enabled                  := TRUE
            FormDBF.oBtnNovo.Enabled                  := TRUE
            FormDBF.oBtnExclui.Enabled                := TRUE
        Case nParam = 5 //Exclusão de registro
            if !Confirma("Tem certeza que deseja excluir este registro ?")
                Return FALSE
            Endif
            cAlias.Delete()

            FormDBF_OnInit(cAlias)
            FormDBF_ToolbarAction(9,FALSE,cAlias)

        Case nParam = 7 //
            cFile := PutFile({{"*.html","*.html"}},"Nome do arquivo",,,[Dado_]+Dtos(Date())+"_"+StrTran(Time(),":","")+".html")
            if empty(cFile)
                Return FALSE 
            Endif

            oHtml            := THtmlReport():New()
            oHtml:Rs         := cAlias
            oHtml:Title      := "<h2>Relatório Dado</h2>"
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
            FormDBF.Codigo.Value                      :=  0
            FormDBF.Nome.Value                        :=  Nil
            FormDBF.Nascimento.Value                  :=  Ctod('')
            FormDBF.Ativo.Value                       :=  .F.
            FormDBF.Obs.Value                         :=  Nil

        Case nParam = 9 //Habilita ou desabilita os controles
            FormDBF.Nome.Enabled                      := lFlag
            FormDBF.Nascimento.Enabled                := lFlag
            FormDBF.Ativo.Enabled                     := lFlag
            FormDBF.Obs.Enabled                       := lFlag

        Case nParam = 10 //DbGotop
            cAlias.MoveFirst()
            FormDBF_ToolbarAction(0,Nil,cAlias)

        Case nParam = 11 //DbSkip(-1)
            cAlias.MovePrevious()
            IF cAlias.Bof()
                cAlias.MoveFirst()
                MsgInfo("Inicio de arquivo encontrado !")
            Endif
            FormDBF_ToolbarAction(0,Nil,cAlias)

        Case nParam = 12 //DbSkip(+1)
            cAlias.MoveNext()
            IF cAlias.Eof()
                cAlias.MovePrevious()
                MsgInfo("Fim de arquivo encontrado !")
            Endif
            FormDBF_ToolbarAction(0,Nil,cAlias)

        Case nParam = 13 //DbGobottom
            cAlias.MoveLast()
            FormDBF_ToolbarAction(0,Nil,cAlias)

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function FormDBF_Codigo_OnEnter(cAlias )
    Local aSave:={},cCondicao
    AADD(aSave,FormDBF.Codigo.value)
    cCondicao := ''
    cCondicao += StrZero(FormDBF.Codigo.value,5)
    //Formate <cCondicao> de acordo com o indice para DbSeek retorne TRUE
    cAlias.Seek(cCondicao)
    IF !cAlias.Eof()
        FormDBF_ToolbarAction(0,Nil,cAlias)
    Else
        FormDBF_ToolbarAction(2,Nil,cAlias)
        //devolve o valor que estava
        FormDBF.Codigo.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function FormDBF_Obs_OnEnter(cAlias )
    if MsgYesNo("Salvar o registro no banco de dados ?","Confirmação")
        FormDBF_ToolbarAction(4,Nil,cAlias)
    endif
    Return TRUE
