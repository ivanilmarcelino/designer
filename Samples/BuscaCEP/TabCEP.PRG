/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.26.0 RELEASE CANDIDATE (RC) 220331 1016
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.03.0 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 31/03/2022-21:43:16 Máquina: IMA2018 Usuário:Ivanil
    TabCEP.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : CEP
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor SQLAdo oQuery

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_RANGE_RESULT "100"
#Define DEF_CAMPOSSQL  "[CEP],[LOGRADOURO],[COMPLEMENTO],[BAIRRO],[LOCALIDADE],[UF]"
#Define DEF_CAMPOS_PESQUISA { "LOGRADOURO" , "BAIRRO" , "LOCALIDADE" , "UF" }
#Define DEF_CAMPOS_CABECALHO_PESQUISA { "Logradouro" , "Bairro" , "Localidade" , "Uf" }
#Define DEF_CAMPOS_RELATORIO { "cep" , "logradouro" , "complemento" , "bairro" , "localidade" , "uf" }
#Define DEF_CAMPOS_CABECALHO_RELATORIO { "Cep" , "Logradouro" , "Complemento" , "Bairro" , "Localidade" , "Uf" }

Function LoadFrmTabCEP()
    Local oQuery

    //Aqui atribuimos o Cursor do Servidor a variavel oQuery
    oQuery.New()

    //Seguindo a boa pratica SQL, trazemos apenas o registro necessário para carregar o form
    oQuery.SQL := 'Select top 1 '+DEF_CAMPOSSQL+' from tabcep ;' 
    oQuery.Open()
    IF !oQuery.IsOpen
        oQuery.ErrorSQL()
        Return FALSE
    Endif

    Load window TabCEP as TabCEP
        TabCEP.Center()
    TabCEP.activate()

    oQuery.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function TabCEP_OnInit( oQuery )
        TabCEP.oBtnNovo.Cargo                     := FALSE
        TabCEP.oBtnEdit.Cargo                     := FALSE
        TabCEP_ToolbarAction(0,Nil,oQuery)
        Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function TabCEP_ToolbarAction( nParam , lFlag, oQuery )
    Local oRet,cSQL:='',cCondicao,oExcel,oHTML
    Local cFile,aSQL:=DEF_CAMPOS_RELATORIO

    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            TabCEP.oBtnNovo.Picture                   := 'Minigui_edit_new'
            TabCEP.oBtnNovo.Action                    := {||TabCEP_ToolbarAction(2,Nil,oQuery)}
            TabCEP.oBtnEdit.Picture                   := 'Minigui_edit_edit'
            TabCEP.oBtnEdit.Action                    := {||TabCEP_ToolbarAction(3,Nil,oQuery)}
            TabCEP.Cep.Enabled                        := TRUE
            IF !oQuery.Eof() //se recordset não estiver vazio
                TabCEP.oBtnSave.Enabled                   := FALSE
                TabCEP.oBtnEdit.Enabled                   := TRUE
                TabCEP.oBtnNovo.Enabled                   := TRUE
                TabCEP.oBtnExclui.Enabled                 := TRUE
                TabCEP.oBtnNovo.Cargo                     := FALSE
                TabCEP.oBtnEdit.Cargo                     := FALSE

                //Atribuição dos valores encontrados aos objetos
                TabCEP.Cep.Value                          := oQuery.Field.Cep.Value
                TabCEP.Logradouro.Value                   := oQuery.Field.Logradouro.Value
                TabCEP.Complemento.Value                  := oQuery.Field.Complemento.Value
                TabCEP.Bairro.Value                       := oQuery.Field.Bairro.Value
                TabCEP.Localidade.Value                   := oQuery.Field.Localidade.Value
                TabCEP.Uf.Value                           := oQuery.Field.Uf.Value

                TabCEP_ToolbarAction(10,FALSE,oQuery)
            else 
                If !TabCEP.oBtnNovo.Cargo
                    TabCEP.oBtnSave.Enabled                   := FALSE
                    TabCEP.oBtnEdit.Enabled                   := FALSE
                    TabCEP.oBtnNovo.Enabled                   := TRUE
                    TabCEP.oBtnExclui.Enabled                 := FALSE
                Else
                    TabCEP.oBtnSave.Enabled                   := TRUE
                    TabCEP.oBtnEdit.Enabled                   := FALSE
                    TabCEP.oBtnNovo.Enabled                   := FALSE
                    TabCEP.oBtnExclui.Enabled                 := FALSE
                Endif
                TabCEP_ToolbarAction(9,Nil,oQuery) //Limpa tudo
                TabCEP_ToolbarAction(10,TRUE,oQuery)
            Endif

        Case nParam = 1 //Sair
            TabCEP.Release()

        Case nParam = 2 //Novo Registro
            TabCEP.oBtnNovo.Cargo                     := TRUE
            TabCEP.oBtnEdit.Cargo                     := FALSE
            TabCEP.oBtnSave.Enabled                   := TRUE
            TabCEP.oBtnEdit.Enabled                   := FALSE
            TabCEP.oBtnExclui.Enabled                 := FALSE

            //Atribuição de valores nulos aos objetos
            TabCEP_ToolbarAction(9,TRUE,oQuery)

            TabCEP.Cep.SetFocus()
            TabCEP_ToolbarAction(10,TRUE,oQuery)

            TabCEP.oBtnNovo.Picture                   := 'Minigui_edit_cancel'
            TabCEP.oBtnNovo.Action                    := {||TabCEP_ToolbarAction(0,Nil,oQuery)}

        Case nParam = 3 //Editar Registro atual
            TabCEP.oBtnNovo.Cargo                     := FALSE
            TabCEP.oBtnSave.Enabled                   := TRUE
            TabCEP.oBtnNovo.Enabled                   := FALSE
            TabCEP.oBtnEdit.Cargo                     := TRUE
            TabCEP.oBtnExclui.Enabled                 := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            TabCEP.Cep.Enabled                        := FALSE
            TabCEP_ToolbarAction(10,TRUE,oQuery)

            TabCEP.oBtnEdit.Picture                   := 'Minigui_edit_cancel'
            TabCEP.oBtnEdit.Action                    := {||TabCEP_ToolbarAction(0,Nil,oQuery)}

        Case nParam = 4 //Salvar os dados no banco de dados

            cSQL:='Select top 1 '+DEF_CAMPOSSQL+' from tabcep'

            cCondicao := ' Where '
            cCondicao += [CEP=']+Tipovar(TabCEP.CEP.value)+[']

            oQuery.Open(cSQL + cCondicao)
            IF oQuery.Eof()
                IF TabCEP.oBtnEdit.Cargo
                    MsgStop('Consulta não reportou registros para edição ! !')
                    Return FALSE
                Endif
                oQuery.AddNew()
                If oQuery.ErrorSQL()
                    Return FALSE
                Endif
                oQuery.Field.CEP.value                    := TabCEP.CEP.value
            Else
                IF TabCEP.oBtnNovo.Cargo
                    MsgStop('Consulta Reportou registro existente ! !')
                    Return FALSE
                Endif
            Endif
            oQuery.Field.Logradouro.Value             := TabCEP.Logradouro.value
            oQuery.Field.Complemento.Value            := TabCEP.Complemento.value
            oQuery.Field.Bairro.Value                 := TabCEP.Bairro.value
            oQuery.Field.Localidade.Value             := TabCEP.Localidade.value
            oQuery.Field.Uf.Value                     := TabCEP.Uf.value

            oQuery.Update()

            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            TabCEP_ToolbarAction(10,FALSE,oQuery)
            TabCEP.Cep.Enabled                        := TRUE

            TabCEP.Tab1.Value :=1
            TabCEP.CEP.SetFocus()

            TabCEP.oBtnSave.Enabled                   := FALSE
            TabCEP.oBtnEdit.Enabled                   := TRUE
            TabCEP.oBtnNovo.Enabled                   := TRUE
            TabCEP.oBtnExclui.Enabled                 := TRUE
            TabCEP_ToolbarAction(0,Nil,oQuery)

        Case nParam = 5 //Exclusão de registro
            if !Confirma("Tem certeza que deseja excluir este registro ?")
                Return FALSE
            Endif
            cSQL := "Delete from tabcep"
            cSQL += ' Where '
            cSQL += [Cep=']+Tipovar(TabCEP.Cep.value)+[']

            oQuery.Execute(cSQL)

            oQuery.Open('Select top 1 '+DEF_CAMPOSSQL+' from tabcep;')

            TabCEP_OnInit(oQuery)
            TabCEP_ToolbarAction(10,FALSE,oQuery)

        Case nParam = 6 //Pesquisar
            oQuery.Open("Select top "+DEF_RANGE_RESULT+"  "+DEF_CAMPOSSQL+" FROM tabcep;")
            /*
            //Passando os campos escolhidos no wizard para compor a pesquisa
            //Param 2:  Campo Alvo,será o campo chave a ser buscado na consulta
            //Param 3:  Campos que estarão no GRID, escolha campos que ajude o usuário a identificar homógrafo
            //Param 4:  Cabeçalho das colunas no GRID
            */
            oRet := PesquisaPadraoCRUD(oQuery,"LOGRADOURO",DEF_CAMPOS_PESQUISA,DEF_CAMPOS_CABECALHO_PESQUISA,/*{row,col,width,height}*/,Val(DEF_RANGE_RESULT))

            if Valtype(oRet)="O"
                cSQL := "Select "+DEF_CAMPOSSQL+" from tabcep"
                cSQL += ' Where '
                cSQL += [Cep=']+Tipovar(oRet:Cep)+[']
                oQuery.Open(cSQL)
                //Se achar preenche, senão limpa tudo
                TabCEP_ToolbarAction(0,Nil,oQuery)
            Endif

        Case nParam = 7 //Relatório usando a API do Excel, requer versão >=2007
            cFile := PutFile({},"Nome do arquivo",,,[tabcep_]+Dtos(Date())+"_"+StrTran(Time(),":","")+".xlsb")
            if empty(cFile)
                Return FALSE 
            Endif

            //Colocando o colchete para tirar conflito de nomes de campos
            cSQL := TabCEP_MontaSQL(aSQL )
            //Passando a consulta para o Recordset
            cSQL := "Select "+cSQL+" from tabcep"
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
            oExcel:Add('tabcep')

            //Definindo os nomes das colunas que foi repassado ao wizard em tempo de projeto
            oExcel:Headers   := DEF_CAMPOS_CABECALHO_RELATORIO

            //Definindo o conteúdo das colunas que foi repassado ao wizard em tempo de projeto
            oExcel:Fields    := DEF_CAMPOS_RELATORIO

            //Recebendo o titulo do formulário passado ao wizard em tempo de projeto
            oExcel:Cabecalho := "Relatório Excel Tabcep"
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
            cFile := PutFile({{"*.html","*.html"}},"Nome do arquivo",,,[tabcep_]+Dtos(Date())+"_"+StrTran(Time(),":","")+".html")
            if empty(cFile)
                Return FALSE 
            Endif

            //Colocando o colchete para tirar conflito de nomes de campos
            cSQL := TabCEP_MontaSQL(aSQL )
            //Passando a consulta para o Recordset
            cSQL := "Select "+cSQL+" from tabcep"
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
            oHtml:Title      := "<h2>Relatório Excel Tabcep</h2>"
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
            TabCEP.Cep.Value                          :=  Nil
            TabCEP.Logradouro.Value                   :=  Nil
            TabCEP.Complemento.Value                  :=  Nil
            TabCEP.Bairro.Value                       :=  Nil
            TabCEP.Localidade.Value                   :=  Nil
            TabCEP.Uf.Value                           :=  Nil

        Case nParam = 10 //Habilita ou desabilita os controles
            TabCEP.Logradouro.Enabled                 := lFlag
            TabCEP.Complemento.Enabled                := lFlag
            TabCEP.Bairro.Enabled                     := lFlag
            TabCEP.Localidade.Enabled                 := lFlag
            TabCEP.Uf.Enabled                         := lFlag

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function TabCEP_Cep_OnEnter(oQuery )
    Local aSave:={},cSQL
    AADD(aSave,TabCEP.Cep.value)
    cSQL:="Select "+DEF_CAMPOSSQL+" from tabcep"
    cSQL += ' Where '
    cSQL += [Cep=']+Tipovar(TabCEP.Cep.value)+[']

    oQuery.Open(cSQL)
    IF !oQuery.Eof()
        TabCEP_ToolbarAction(0,Nil,oQuery)
    Else
        TabCEP_ToolbarAction(2,Nil,oQuery)
        //devolve o valor que estava
        TabCEP.Cep.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function TabCEP_Uf_OnEnter(oQuery )
    if MsgYesNo("Salvar o registro no banco de dados ?","Confirmação")
        TabCEP_ToolbarAction(4,Nil,oQuery)
    endif
    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function TabCEP_MontaSQL(aSQL )
    Local cSQL:='',i
    //Colocando o colchete para tirar conflito de nomes de campos
    For i=1 to len(aSQL)
        cSQL+="`"+aSql[i]+"`,"
    Next
    cSQL := Substr(cSQL,1,len(cSQL)-1)

    Return cSQL

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function TabCEP_Cep_Action(oQuery )
    Local oPg,cBuf,hBuf,cCep:=Transform(StrZero(val(this.value),8),"@R 99999999")
    Local cSQL:="Select * from tabcep where cep='"+cCep+"'"
    oQuery.Open(cSQL)
    if oQuery.Eof()
        oPg := CreateObject("Microsoft.XMLHTTP")
        oPg:Open("GET","http://viacep.com.br/ws/"+cCep+"/json/",.F.)
        oPg:Send()
        cBuf := oPg:responseBody //ResponseText
        cBuf := hb_UTF8ToStr(cBuf)
        hb_jsonDecode(cBuf,@hBuf)
        if valtype(hbuf)="H".and.!hb_hHaskey( hBuf,'erro')
            oQuery.AddNew()
            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            oQuery.Field.CEP.value           := cCep
            oQuery.Field.Logradouro.Value    := hBuf["logradouro"]
            oQuery.Field.Complemento.Value   := hbuf["complemento"]
            oQuery.Field.Bairro.Value        := hbuf["bairro"]
            oQuery.Field.Localidade.Value    := hbuf["localidade"]
            oQuery.Field.Uf.Value            := hbuf["uf"]
            oQuery.Update()
            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            oQuery.Open(cSQL)
        endif
    endif
    tabcep_ToolbarAction(0,Nil,oQuery)
    tabcep.Cep.Value := cCEP
    Return .T.