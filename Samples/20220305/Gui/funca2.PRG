/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.22.0 RELEASE CANDIDATE (RC) 220305 0032
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.01.4 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 05/03/2022-01:16:29 Máquina: IMA2018 Usuário:Ivanil
    funca2.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : Gui
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor MySQL oQuery

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_RANGE_RESULT "100"
#Define DEF_CAMPOSSQL  "`CODIGO`,`NOME`,`NASCIMENTO`,`SALARIO`,`ATIVO`"
#Define DEF_CAMPOS_PESQUISA { "NOME" , "NASCIMENTO" }
#Define DEF_CAMPOS_CABECALHO_PESQUISA { "Nome" , "Nascimento" }
#Define DEF_CAMPOS_RELATORIO { "codigo" , "nome" , "nascimento" , "salario" , "ativo" }
#Define DEF_CAMPOS_CABECALHO_RELATORIO { "Codigo" , "Nome" , "Nascimento" , "Salario" , "Ativo" }

Function LoadFrmfunca2()
    Local oQuery

    //Aqui atribuimos o Cursor do Servidor a variavel oQuery
    oQuery.New()

    //Seguindo a boa pratica SQL, trazemos apenas o registro necessário para carregar o form
    oQuery.SQL := 'Select '+DEF_CAMPOSSQL+' from tabfunca LIMIT 1;' 
    oQuery.Open()
    IF !oQuery.IsOpen
        oQuery.ErrorSQL()
        Return FALSE
    Endif

    Load window funca2 as funca2
        funca2.Center()
    funca2.activate()

    oQuery.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function funca2_OnInit( oQuery )
        funca2.oBtnNovo.Cargo                    := FALSE
        funca2.oBtnEdit.Cargo                    := FALSE
        funca2_ToolbarAction(0,Nil,oQuery)
        Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function funca2_ToolbarAction( nParam , lFlag, oQuery )
    Local oRet,cSQL:='',cCondicao,oExcel,oHTML
    Local cFile,aSQL:=DEF_CAMPOS_RELATORIO

    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            funca2.oBtnNovo.Picture                  := 'Minigui_edit_new'
            funca2.oBtnNovo.Action                   := {||funca2_ToolbarAction(2,Nil,oQuery)}
            funca2.oBtnEdit.Picture                  := 'Minigui_edit_edit'
            funca2.oBtnEdit.Action                   := {||funca2_ToolbarAction(3,Nil,oQuery)}
            funca2.Codigo.Enabled                    := TRUE
            IF !oQuery.Eof() //se recordset não estiver vazio
                funca2.oBtnSave.Enabled                  := FALSE
                funca2.oBtnEdit.Enabled                  := TRUE
                funca2.oBtnNovo.Enabled                  := TRUE
                funca2.oBtnExclui.Enabled                := TRUE
                funca2.oBtnNovo.Cargo                    := FALSE
                funca2.oBtnEdit.Cargo                    := FALSE

                //Atribuição dos valores encontrados aos objetos
                funca2.Codigo.Value                      := oQuery.Field.Codigo.Value
                funca2.Nome.Value                        := oQuery.Field.Nome.Value
                funca2.Nascimento.Value                  := oQuery.Field.Nascimento.Value
                funca2.Salario.Value                     := oQuery.Field.Salario.Value
                funca2.Ativo.Value                       := oQuery.Field.Ativo.Value=1

                funca2_ToolbarAction(10,FALSE,oQuery)
            else 
                If !funca2.oBtnNovo.Cargo
                    funca2.oBtnSave.Enabled                  := FALSE
                    funca2.oBtnEdit.Enabled                  := FALSE
                    funca2.oBtnNovo.Enabled                  := TRUE
                    funca2.oBtnExclui.Enabled                := FALSE
                Else
                    funca2.oBtnSave.Enabled                  := TRUE
                    funca2.oBtnEdit.Enabled                  := FALSE
                    funca2.oBtnNovo.Enabled                  := FALSE
                    funca2.oBtnExclui.Enabled                := FALSE
                Endif
                funca2_ToolbarAction(9,Nil,oQuery) //Limpa tudo
                funca2_ToolbarAction(10,TRUE,oQuery)
            Endif

        Case nParam = 1 //Sair
            funca2.Release()

        Case nParam = 2 //Novo Registro
            funca2.oBtnNovo.Cargo                    := TRUE
            funca2.oBtnEdit.Cargo                    := FALSE
            funca2.oBtnSave.Enabled                  := TRUE
            funca2.oBtnEdit.Enabled                  := FALSE
            funca2.oBtnExclui.Enabled                := FALSE

            //Atribuição de valores nulos aos objetos
            funca2_ToolbarAction(9,TRUE,oQuery)

            funca2.Codigo.SetFocus()
            funca2_ToolbarAction(10,TRUE,oQuery)

            funca2.oBtnNovo.Picture                  := 'Minigui_edit_cancel'
            funca2.oBtnNovo.Action                   := {||funca2_ToolbarAction(0,Nil,oQuery)}

        Case nParam = 3 //Editar Registro atual
            funca2.oBtnNovo.Cargo                    := FALSE
            funca2.oBtnSave.Enabled                  := TRUE
            funca2.oBtnNovo.Enabled                  := FALSE
            funca2.oBtnEdit.Cargo                    := TRUE
            funca2.oBtnExclui.Enabled                := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            funca2.Codigo.Enabled                    := FALSE
            funca2_ToolbarAction(10,TRUE,oQuery)

            funca2.oBtnEdit.Picture                  := 'Minigui_edit_cancel'
            funca2.oBtnEdit.Action                   := {||funca2_ToolbarAction(0,Nil,oQuery)}

        Case nParam = 4 //Salvar os dados no banco de dados

            cSQL:='Select '+DEF_CAMPOSSQL+' from tabfunca'

            cCondicao := ' Where '
            cCondicao += [CODIGO=]+Tipovar(funca2.CODIGO.value)

            cCondicao += " LIMIT 1;"
            oQuery.Open(cSQL + cCondicao)
            IF oQuery.Eof()
                IF funca2.oBtnEdit.Cargo
                    MsgStop('Consulta não reportou registros para edição ! !')
                    Return FALSE
                Endif
                oQuery.AddNew()
                If oQuery.ErrorSQL()
                    Return FALSE
                Endif
                oQuery.Field.CODIGO.value                := funca2.CODIGO.value
            Else
                IF funca2.oBtnNovo.Cargo
                    MsgStop('Consulta Reportou registro existente ! !')
                    Return FALSE
                Endif
            Endif
            oQuery.Field.Nome.Value                  := funca2.Nome.value
            oQuery.Field.Nascimento.Value            := funca2.Nascimento.value
            oQuery.Field.Salario.Value               := funca2.Salario.value
            oQuery.Field.Ativo.Value                 := IIF(funca2.Ativo.value,1,0)

            oQuery.Update()

            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            funca2_ToolbarAction(10,FALSE,oQuery)
            funca2.Codigo.Enabled                    := TRUE

            funca2.Tab1.Value :=1
            funca2.CODIGO.SetFocus()

            funca2.oBtnSave.Enabled                  := FALSE
            funca2.oBtnEdit.Enabled                  := TRUE
            funca2.oBtnNovo.Enabled                  := TRUE
            funca2.oBtnExclui.Enabled                := TRUE
            funca2_ToolbarAction(0,Nil,oQuery)

        Case nParam = 5 //Exclusão de registro
            if !Confirma("Tem certeza que deseja excluir este registro ?")
                Return FALSE
            Endif
            cSQL := "Delete from tabfunca"
            cSQL += ' Where '
            cSQL += [Codigo=]+Tipovar(funca2.Codigo.value)

            oQuery.Execute(cSQL)

            oQuery.Open('Select '+DEF_CAMPOSSQL+' from tabfunca LIMIT 1;')

            funca2_OnInit(oQuery)
            funca2_ToolbarAction(10,FALSE,oQuery)

        Case nParam = 6 //Pesquisar
            oQuery.Open("Select  "+DEF_CAMPOSSQL+" FROM tabfunca LIMIT "+DEF_RANGE_RESULT)
            /*
            //Passando os campos escolhidos no wizard para compor a pesquisa
            //Param 2:  Campo Alvo,será o campo chave a ser buscado na consulta
            //Param 3:  Campos que estarão no GRID, escolha campos que ajude o usuário a identificar homógrafo
            //Param 4:  Cabeçalho das colunas no GRID
            */
            oRet := PesquisaPadraoCRUD(oQuery,"NOME",DEF_CAMPOS_PESQUISA,DEF_CAMPOS_CABECALHO_PESQUISA,/*{row,col,width,height}*/,Val(DEF_RANGE_RESULT))

            if Valtype(oRet)="O"
                cSQL := "Select "+DEF_CAMPOSSQL+" from tabfunca"
                cSQL += ' Where '
                cSQL += [Codigo=]+Tipovar(oRet:Codigo)
                oQuery.Open(cSQL)
                //Se achar preenche, senão limpa tudo
                funca2_ToolbarAction(0,Nil,oQuery)
            Endif

        Case nParam = 7 //Relatório usando a API do Excel, requer versão >=2007
            cFile := PutFile({},"Nome do arquivo",,,[tabfunca_]+Dtos(Date())+"_"+StrTran(Time(),":","")+".xlsb")
            if empty(cFile)
                Return FALSE 
            Endif

            //Colocando o colchete para tirar conflito de nomes de campos
            cSQL := funca2_MontaSQL(aSQL )
            //Passando a consulta para o Recordset
            cSQL := "Select "+cSQL+" from tabfunca"
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

            //Instanciando o Excel
            oExcel           := TExcel():New()
            //Passando o objeto Recordset para a instancia
            oExcel:Database  := oQuery

            //Criando uma pasta no Excel, por padrão é passado o nome da própria tabela
            oExcel:Add('tabfunca')

            //Definindo os nomes das colunas que foi repassado ao wizard em tempo de projeto
            oExcel:Headers   := DEF_CAMPOS_CABECALHO_RELATORIO

            //Definindo o conteúdo das colunas que foi repassado ao wizard em tempo de projeto
            oExcel:Fields    := DEF_CAMPOS_RELATORIO

            //Recebendo o titulo do formulário passado ao wizard em tempo de projeto
            oExcel:Cabecalho := "Relatório Excel Tabfunca"
            //Fontes das letras a aplicar no relatório
            oExcel:FontName  := "Calibri"
            oExcel:FontSize  := 9

            //Mude para TRUE para obter Linhas Zebradas
            oExcel:lZebra    := FALSE

            //Totaliza os campos numéricos
            oExcel:Totaliza  := TRUE

            //Cada campo é criado com uma formula, isso mantem os zeros a esquerda e outras formatações automáticas do Excel.
            oExcel:lFormula  := TRUE 

            //Transfere os dados dados para o Excel
            oExcel:Refresh()

            //Protege o arquivo contra alterações
            oExcel:Protege(/*senha opcional*/)

            //Formato de saída do arquivo
            oExcel:nFormat   := 50
            /*
            Valor Descrição                          Extensão
               50 Pasta de trabalho binária do Excel *. xlsb
               16 Excel versão 2.0 (1987)            *. xls
               29 Excel versão 3.0 (1990)            *. xls
               33 Excel versão 4.0 (1992)            *. xls
               39 Excel versão 5.0 (1994)            *. xls
               39 Excel 95 (versão 7.0)              *. xls
               56 Pasta de trabalho do Excel 97-2003 *. xls
               43 Excel versão 95 e 97               *. xls
               44 Formato HTML                       *. htm; *. HTML
               60 Planilha do OpenDocument           *.ods
               55 Suplemento XML Aberto              *. xlam
               51 Pasta de trabalho kPadrão           *. xlsx
            -4143 Pasta de trabalho normal           *. xls

            */

            //Salva o relatório em disco
            oExcel:SaveAs(cFile)

            //Destrói a instância do Excel
            oExcel:Close()

        Case nParam = 8 //Report Html
            cFile := PutFile({{"*.html","*.html"}},"Nome do arquivo",,,[tabfunca_]+Dtos(Date())+"_"+StrTran(Time(),":","")+".html")
            if empty(cFile)
                Return FALSE 
            Endif

            //Colocando o colchete para tirar conflito de nomes de campos
            cSQL := funca2_MontaSQL(aSQL )
            //Passando a consulta para o Recordset
            cSQL := "Select "+cSQL+" from tabfunca"
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
            oHtml:Title      := "<h2>Relatório Excel Tabfunca</h2>"
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

        Case nParam = 9 //Limpa tudo
            funca2.Codigo.Value                      :=  0
            funca2.Nome.Value                        :=  Nil
            funca2.Nascimento.Value                  :=  Ctod('')
            funca2.Salario.Value                     :=  0
            funca2.Ativo.Value                       :=  .F.

        Case nParam = 10 //Habilita ou desabilita os controles
            funca2.Nome.Enabled                      := lFlag
            funca2.Nascimento.Enabled                := lFlag
            funca2.Salario.Enabled                   := lFlag
            funca2.Ativo.Enabled                     := lFlag

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function funca2_Codigo_OnEnter(oQuery )
    Local aSave:={},cSQL
    AADD(aSave,funca2.Codigo.value)
    cSQL:="Select "+DEF_CAMPOSSQL+" from tabfunca"
    cSQL += ' Where '
    cSQL += [Codigo=]+Tipovar(funca2.Codigo.value)

    oQuery.Open(cSQL)
    IF !oQuery.Eof()
        funca2_ToolbarAction(0,Nil,oQuery)
    Else
        funca2_ToolbarAction(2,Nil,oQuery)
        //devolve o valor que estava
        funca2.Codigo.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function funca2_MontaSQL(aSQL )
    Local cSQL:='',i
    //Colocando o colchete para tirar conflito de nomes de campos
    For i=1 to len(aSQL)
        cSQL+="`"+aSql[i]+"`,"
    Next
    cSQL := Substr(cSQL,1,len(cSQL)-1)

    Return cSQL
