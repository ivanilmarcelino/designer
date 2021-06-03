/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "0.99.23.30 RELEASE CANDIDATE (RC) 210601 1053"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 21.05.0 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.1 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 03/06/2021-10:43:37 Máquina: IMA2018 Usuário:ivani
    FrmMunicip.PRG Criado automaticamente pelo Wizard
    ----------------------------------------------------------------------------------------------
    Projeto : TestAdoSQL
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor SQLAdo oQuery
Declare Window Main

//Definições: ajustando aqui, o coódigo se reflete no módulo todo
#Define DEF_CAMPOSSQL  "[COD],[NOME],[UF],[DTUPDATE]"
#Define DEF_CAMPOS_PESQUISA { "NOME" , "UF" }
#Define DEF_CAMPOS_CABECALHO_PESQUISA { "NOME" , "UF" }
#Define DEF_CAMPOS_RELATORIO { "cod" , "nome" , "uf" }
#Define DEF_CAMPOS_CABECALHO_RELATORIO { "cod" , "nome" , "uf" }

Function LoadFrmFrmMunicip(nPar)
    Local oQuery,cGrid:="oGrid"+hb_ntos(nPar)
    Local FrmMunicip := IdGlobal("Form") //vai permitir ser chamada varias vezes
    Local nReg := val(Main.&(cGrid).item(Main.&(cGrid).value)[1])
    
    //Aqui atribuimos o Cursor do Servidor a variavel oQuery
    oQuery.New()

    //Seguindo a boa pratica SQL, trazemos apenas o registro necessário para carregar o form
    oQuery.SQL := 'Select '+DEF_CAMPOSSQL+' from Municip where cod='+hb_ntos(nReg)+";"
    oQuery.Open()
    IF !oQuery.IsOpen
        oQuery.ErrorSQL()
        Return FALSE
    Endif

    Load window FrmMunicip as &(FrmMunicip)
        &(FrmMunicip).Center()
    &(FrmMunicip).activate()

    oQuery.Close()
    REturn TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FrmMunicip_OnInit( oQuery ,FrmMunicip)
    &(FrmMunicip).oBtnNovo.Cargo               := FALSE
    &(FrmMunicip).oBtnEdit.Cargo               := FALSE
    &(FrmMunicip).UF.AddItem("Acre")
    &(FrmMunicip).UF.AddItem("Alagoas")
    &(FrmMunicip).UF.AddItem("Amapá")
    &(FrmMunicip).UF.AddItem("Amazonas")
    &(FrmMunicip).UF.AddItem("Bahia")
    &(FrmMunicip).UF.AddItem("Ceará")
    &(FrmMunicip).UF.AddItem("Distrito Federal")
    &(FrmMunicip).UF.AddItem("Espírito Santo")
    &(FrmMunicip).UF.AddItem("Goiás")
    &(FrmMunicip).UF.AddItem("Maranhão")
    &(FrmMunicip).UF.AddItem("Mato Grosso")
    &(FrmMunicip).UF.AddItem("Mato Grosso do Sul")
    &(FrmMunicip).UF.AddItem("Minas Gerais")
    &(FrmMunicip).UF.AddItem("Pará ")
    &(FrmMunicip).UF.AddItem("Paraíba")
    &(FrmMunicip).UF.AddItem("Paraná")
    &(FrmMunicip).UF.AddItem("Pernambuco")
    &(FrmMunicip).UF.AddItem("Piauí")
    &(FrmMunicip).UF.AddItem("Rio de Janeiro")
    &(FrmMunicip).UF.AddItem("Rio Grande do Norte")
    &(FrmMunicip).UF.AddItem("Rio Grande do Sul")
    &(FrmMunicip).UF.AddItem("Rondônia")
    &(FrmMunicip).UF.AddItem("Roraima")
    &(FrmMunicip).UF.AddItem("Santa Catarina")
    &(FrmMunicip).UF.AddItem("São Paulo")
    &(FrmMunicip).UF.AddItem("Sergipe")
    &(FrmMunicip).UF.AddItem("Tocantins")
    &(FrmMunicip).UF.Cargo := {"AC","AL","AP","AM","BA","CE","DF",;
                               "ES","GO","MA","MT","MS","MG","PA",;
                               "PB","PR","PE","PI","RJ","RN","RS",;
                               "RO","RR","SC","SP","SE","TO"}
    FrmMunicip_ToolbarAction(0,Nil,oQuery,FrmMunicip)
    Return TRUE
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function FrmMunicip_ToolbarAction( nParam , lFlag, oQuery,FrmMunicip ) //<=>TRUE/FALSE> \nnParam=(1.Sair,2.Novo,3.Edit,4.Save,5.Delete,6.Pesquisa,7.Report,8.Limpa,9.Enable/Disable)\nlFlag=(TRUE/FALSE)
    Local i,oRet,cSQL:='',cCondicao
    Local oHTML,cFile,aSQL:=DEF_CAMPOS_RELATORIO
    Local cUpdate:=&(FrmMunicip).Dtupdate.Value

    Do Case
        Case nParam = 0 //Atualiza os componentes com os dados do recorset
            &(FrmMunicip).Cod.Enabled                  := TRUE
            IF !oQuery.Eof() //se recordset não estiver vazio
                &(FrmMunicip).oBtnSave.Enabled             := FALSE
                &(FrmMunicip).oBtnEdit.Enabled             := TRUE
                &(FrmMunicip).oBtnNovo.Enabled             := TRUE
                &(FrmMunicip).oBtnExclui.Enabled           := TRUE
                &(FrmMunicip).oBtnNovo.Cargo               := FALSE
                &(FrmMunicip).oBtnEdit.Cargo               := FALSE

                //Atribuição dos valores encontrados aos objetos
                &(FrmMunicip).Cod.Value                    := oQuery.Field.Cod.Value
                &(FrmMunicip).Nome.Value                   := oQuery.Field.Nome.Value
                &(FrmMunicip).Uf.Value                     := Ascan(&(FrmMunicip).UF.Cargo,{|C|C==oQuery.Field.Uf.Value})
                &(FrmMunicip).Dtupdate.Value               := oQuery.Field.Dtupdate.Value

                FrmMunicip_ToolbarAction(9,FALSE,oQuery,FrmMunicip)
            else 
                If !&(FrmMunicip).oBtnNovo.Cargo
                    &(FrmMunicip).oBtnSave.Enabled             := FALSE
                    &(FrmMunicip).oBtnEdit.Enabled             := FALSE
                    &(FrmMunicip).oBtnNovo.Enabled             := TRUE
                    &(FrmMunicip).oBtnExclui.Enabled           := FALSE
                Else
                    &(FrmMunicip).oBtnSave.Enabled             := TRUE
                    &(FrmMunicip).oBtnEdit.Enabled             := FALSE
                    &(FrmMunicip).oBtnNovo.Enabled             := FALSE
                    &(FrmMunicip).oBtnExclui.Enabled           := FALSE
                Endif
                FrmMunicip_ToolbarAction(8,Nil,oQuery,FrmMunicip) //Limpa tudo
                FrmMunicip_ToolbarAction(9,TRUE,oQuery,FrmMunicip)
            Endif

        Case nParam = 1 //Sair
            &(FrmMunicip).Release()

        Case nParam = 2 //Novo Registro
            &(FrmMunicip).oBtnNovo.Cargo               := TRUE
            &(FrmMunicip).oBtnEdit.Cargo               := FALSE
            &(FrmMunicip).oBtnSave.Enabled             := TRUE
            &(FrmMunicip).oBtnEdit.Enabled             := FALSE
            &(FrmMunicip).oBtnNovo.Enabled             := FALSE
            &(FrmMunicip).oBtnExclui.Enabled           := FALSE

            //Atribuição de valores nulos aos objetos
            FrmMunicip_ToolbarAction(8,TRUE,oQuery,FrmMunicip)

            &(FrmMunicip).nome.SetFocus()
            FrmMunicip_ToolbarAction(9,TRUE,oQuery,FrmMunicip)

        Case nParam = 3 //Editar Registro atual
            &(FrmMunicip).oBtnNovo.Cargo               := FALSE
            &(FrmMunicip).oBtnSave.Enabled             := TRUE
            &(FrmMunicip).oBtnEdit.Enabled             := FALSE
            &(FrmMunicip).oBtnEdit.Cargo               := TRUE
            &(FrmMunicip).oBtnExclui.Enabled           := FALSE

            //Habilita campos para edição/Desabilita campos chaves
            &(FrmMunicip).Cod.Enabled                  := FALSE
            FrmMunicip_ToolbarAction(9,TRUE,oQuery,FrmMunicip)


        Case nParam = 4 //Salvar os dados no banco de dados
            if &(FrmMunicip).Uf.value = 0
                MsgStop("Selecione um estado valido ")
                Return .F.
            endif
            if empty(&(FrmMunicip).Nome.value)
                MsgStop("Nome do Municipio deve ser Informado !")
                Return .F.
            endif

            cSQL:='Select top 1 '+DEF_CAMPOSSQL+' from Municip'

            cCondicao := ' Where '
            cCondicao += [COD=]+Tipovar(&(FrmMunicip).COD.value)
            
            //Esta condicao vai garantir a integridade em rede, um client pode ter modificado o registro.
            if !Empty(cUpdate)
                cCondicao += " and dtUpdate="+oQuery:DataSQL(cUpdate)
            endif

            oQuery.Open(cSQL + cCondicao)
            IF oQuery.Eof()
                IF &(FrmMunicip).oBtnEdit.Cargo
                    MsgStop("Registro foi alterado por outra conexão")
                    Return FALSE
                Endif
                oQuery.AddNew()
                If oQuery.ErrorSQL()
                    Return FALSE
                Endif
                *O cod foi definido como automatico, então não deve ser fornecido
                *oQuery.Field.COD.value                  := FrmMunicip.COD.value
            Else
                IF &(FrmMunicip).oBtnNovo.Cargo
                    MsgStop('Consulta Reportou registro existente ! !')
                    Return FALSE
                Endif
            Endif
            oQuery.Field.Nome.Value                 := &(FrmMunicip).Nome.value
            oQuery.Field.Uf.Value                   := &(FrmMunicip).Uf.Cargo[&(FrmMunicip).Uf.value]
            oQuery.Field.Dtupdate.Value             := padr(hb_TtoC(DateTime(),"dd/mm/yyyy hh:mm:ss"),19)//não levar os centesimos.
            cUpdate := oQuery.Field.Dtupdate.Value  //vamos usar para atualizar o form, permitindo alterar sem reabrir
            oQuery.Update()

            If oQuery.ErrorSQL()
                Return FALSE
            Endif
            FrmMunicip_ToolbarAction(9,FALSE,oQuery,FrmMunicip)
            &(FrmMunicip).dtUpdate.value               := cUpdate
            &(FrmMunicip).Cod.Enabled                  := TRUE

            &(FrmMunicip).Tab1.Value :=1
            &(FrmMunicip).COD.SetFocus()

            &(FrmMunicip).oBtnSave.Enabled             := FALSE
            &(FrmMunicip).oBtnEdit.Enabled             := TRUE
            &(FrmMunicip).oBtnNovo.Enabled             := TRUE
            &(FrmMunicip).oBtnExclui.Enabled           := TRUE
        Case nParam = 5 //Exclusão de registro
            if !Confirma("Tem certeza que deseja excluir este registro ?")
                Return FALSE
            Endif
            cSQL := "Delete from Municip"
            cSQL += ' Where '
            cSQL += [Cod=]+Tipovar(&(FrmMunicip).Cod.value)

            oQuery.Execute(cSQL)

            oQuery.Open('Select top 1 '+DEF_CAMPOSSQL+' from Municip;')

            FrmMunicip_OnInit(oQuery,FrmMunicip)
            FrmMunicip_ToolbarAction(9,FALSE,oQuery,FrmMunicip)

        Case nParam = 6 //Pesquisar
            oQuery.Open("Select top 100  "+DEF_CAMPOSSQL+" FROM Municip;")
            /*
            //Passando os campos escolhidos no wizard para compor a pesquisa
            //Param 2:  Campo Alvo,será o campo chave a ser buscado na consulta
            //Param 3:  Campos que estarão no GRID, escolha campos que ajude o usuário a identificar homógrafo
            //Param 4:  Cabeçalho das colunas no GRID
            */
            oRet := PesquisaPadraoCRUD(oQuery,"NOME",DEF_CAMPOS_PESQUISA,DEF_CAMPOS_CABECALHO_PESQUISA)

            if Valtype(oRet)="O"
                cSQL := "Select "+DEF_CAMPOSSQL+" from Municip"
                cSQL += ' Where '
                cSQL += [Cod=]+Tipovar(oRet:Cod)
                oQuery.Open(cSQL)
                //Se achar preenche, senão limpa tudo
                FrmMunicip_ToolbarAction(0,Nil,oQuery,FrmMunicip)
            Endif

        Case nParam = 7 //
            cFile := PutFile({{"*.html","*.html"}},"Nome do arquivo",,,[Municip_]+Dtos(Date())+"_"+StrTran(Time(),":","")+".html")
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
            cSQL := "Select "+cSQL+" from Municip order by uf,nome"
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
            oHtml:Title      := "<h2>Relatório Municip</h2>"
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
            &(FrmMunicip).Cod.enabled                  := .F.
            &(FrmMunicip).Cod.Value                    :=  0
            &(FrmMunicip).Nome.Value                   :=  Nil
            &(FrmMunicip).Uf.Value                     :=  Nil
            &(FrmMunicip).Dtupdate.Value               :=  Ctod('')

        Case nParam = 9 //Habilita ou desabilita os controles
            &(FrmMunicip).Nome.Enabled                 := lFlag
            &(FrmMunicip).Uf.Enabled                   := lFlag
            &(FrmMunicip).Dtupdate.Enabled             := lFlag

    EndCase
    Return TRUE

    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

Static function FrmMunicip_Cod_OnEnter(oQuery,FrmMunicip )
    Local aSave:={},cSQL
    AADD(aSave,&(FrmMunicip).Cod.value)
    cSQL:="Select "+DEF_CAMPOSSQL+" from Municip"
    cSQL += ' Where '
    cSQL += [Cod=]+Tipovar(&(FrmMunicip).Cod.value)

    oQuery.Open(cSQL)
    IF !oQuery.Eof()
        FrmMunicip_ToolbarAction(0,Nil,oQuery,FrmMunicip)
    Else
        FrmMunicip_ToolbarAction(2,Nil,oQuery,FrmMunicip)
        //devolve o valor que estava
        &(FrmMunicip).Cod.value := aSave[1]
        InsertTab()
    Endif

    Return TRUE
    ************************************************************************************************
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ************************************************************************************************

