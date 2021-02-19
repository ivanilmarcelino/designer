/*
   Classe ADO
   ivanil Marcelino (ivanil.marcelino@yahoo.com.br)
   Minigui x Xharbour
   Disponibilizado em 22/03/2010
*/

/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.21.108 RELEASE CANDIDATE (RC) 210210 1150"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 21.01.0 (32-bit)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2101261627)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 11/02/2021-17:47:10 Máquina: IMA2018 Usuário:ivani
    Código Módulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Agenda
    */

#include <hmg.ch>
#include <SQLAdo.ch>
DECLARE CURSOR SQLITE RS

memvar cLetra,lNovo

Function Main(  )
    Local lNewDatabase
    *ferase("agenda.sqlite")
    //Include do BD, realocado conteudo para ca por conta da memvar...
    *#Include <Agenda.DB>
    Private oSQL //Variáveis globais de conexao
    oSQL:=TSqLite3():New()
    oSQL:Database:='Agenda.SQLite'
    lNewDatabase := !File(oSQL:Database)
    oSQL:IsCreate:=lNewDatabase
    if !oSQL:Open()
        Return .F.
    endif
    
    if lNewDatabase
        if !CreateDatabase(oSQL)
            Return .F.
        endif
    endif
    
    //Manter o indice Pos alteracao/inclusao de Contato
    Private cLetra:="A"
    
    //controla Novo/alteracao
    Private lNovo := .F.
    #Include <Agenda.CH>
    
    /*Carregando o formulário Principal*/
    Load window Agenda as Main
        Main.OnRelease := {||oSQL:Close()}
    Main.Center
    
    //desabilita todos os controles
    SetHabilitaControls(.F.)
    
    //Ativa agenda para o indice A
    Pesquisa_Agenda("A")
    
    //Codigo sempre desabilitado
    Main.oCodigo.Enabled := .F.
    
    Main.activate()
    
    REturn .T.
    
    
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
Function Pesquisa_Agenda(c)
    Local Rs 
    
    //Objeto REcordSet
    rs.new()
    
    //Desabilitando todos controles
    SetHabilitaControls(.F.)
    
    //String SQL
    Rs.Sql:="Select * from agenda where nome like '"+c+"%'"+" order by nome"
    
    //Abrindo o Cursor
    Rs.OPen()
    IF Rs.ErrorSQL(Rs.SQL)
        Return .F.
    endif
    
    Main.oListaAgenda.DeleteAllItems()
    Main.oListaAgenda.DisableUpdate()
    
    //Enquanto nao for fim do Recordset
    Do While ! Rs.Eof()
        Main.oListaAgenda.AddItem({rs.Field.Codigo.value , Rs.Field.Nome.Value})
        
        //passeando pelo recordset
        Rs.MoveNext()
    EndDo
    Main.oStatus.Value:="Encontrados "+cStr(Main.oListaAgenda.ItemCount)+" Contatos..."
    Main.oListaAgenda.EnableUpdate()
    
    //Fechado o Recorset
    Rs.Close()
    cLetra:=c
    Return Nil
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
Static function AtualizaCrid()
    Local aLinha,Rs,nPos,cImage:=GetTempDir()+"Cache.tmp"//,oStream
    nPos:=Main.oListaAgenda.Value
    if nPos=0
        Return .F.
    endif
    aLinha:=Main.oListaAgenda.Item(nPos)
    
    //Criando o objeto recordset
    Rs.New()
    
    //String sQL
    Rs.SQL := "Select a.*,b.nomecidade from agenda a  left join cidade b on a.cidade=b.codcidade where codigo='"+aLinha[1]+"'"
    
    //Abrindo a Consulta
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    //Enquanto nao for o fim do Recordset
    Main.oCidade.DeleteAllItems()
    Main.oCidade.Cargo:={rs.Field.cidade}
    Main.oCidade.Additem(Defa(rs.Field.nomecidade,""))
    if !Rs.Eof()
        Main.oCodigo.Value      := Rs.Field.codigo
        Main.oNome.Value        := Rs.Field.nome
        Main.oFone1.Value       := Rs.Field.Fone1
        Main.oFone2.Value       := Rs.Field.Fone2
        Main.oCidade.value      := IIF(Empty(Rs.Field.cidade),0,1)
        Main.oBairro.Value      := Rs.Field.bairro
        Main.oEndereco.Value    := Rs.Field.endereco
        Main.oEmail.Value       := Rs.Field.Email
        Main.oUF.Value          := Ascan(Main.oUF.Cargo,Rs.Field.estado.value)
        
        //necessario tratar, controle apresenta erros se nao tiver @
        if At("@",Main.oEmail.Value)>0
            Main.oEmailTo.AddRess:=Main.oEmail.Value
        else
            Main.oEmailto.AddRess:= "@"
        endif
        
        //se não houve foto ou ocorrer problema na foto, vazio é default
        Main.oFoto.Picture:="vazio"
        //Se foto estiver carregada...
        if !Empty(Rs.Field.Foto.value)
            Rs.SaveFile("Foto",cImage)
            Main.oFoto.Picture := cImage
        endif
    Endif
    
    //Fecha o objeto recordset
    rs.close()
    
    lNovo:=.F.
    //Desabilita todos controles
    SetHabilitaControls(.F.)
    
    Return .T.
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
Static function NovoContato()
    
    //Habilita todos os controles
    SetHabilitaControls(.T.)
    
    Main.oCodigo.Value   := ""
    Main.oNome.Value     := ""
    Main.oEndereco.value := ""
    Main.oCidade.Value   := 0
    Main.oBairro.value   := ""
    Main.oFone1.Value    := ""
    Main.oFone2.Value    := ""
    Main.oEmail.Value    := ""
    Main.oEmailto.AddRess:= "@"
    Main.oNome.SetFocus()
    lNovo:=.T.
    Return .T.
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
Static function AlteraContato()
    
    //Habilita todos os controles
    SetHabilitaControls(.T.)

    
    Main.oNome.SetFocus()
    lNovo:=.F.
    Return .T.
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
Static function SalvaContato()
    Local rs,cCod//,e
    //Validando campos que nao podem ficar em branco, criado uma funcao generica para  exemplo.
    if !NaoPermiteCamposVazios({"onome","ocidade","oendereco","obairro"})
        Return .F.
    endif
    Rs.New()
    
    if lNovo
        //Novo registro, temos que descobrir o proximo
        Rs.Sql:="Select codigo from agenda order by codigo desc LIMIT 1"
        
        //Abrindo o recordSet
        Rs.Open()
        if Rs.ErrorSQL()
            Return .F.
        endif
        if Rs.Eof() //nao achou...
            //Vazio, entao=1
            cCod:="00001"
        else
            //pegamos o ultimo e somamos 1
            cCod:=StrZero(val(Rs.Field.codigo.value)+1,4)
        endif
    else
        //nao é novo, alteracao de cadastro
        cCod:=Main.oCodigo.Value
    endif
    
    //String de Conexao
    Rs.SQL:="Select * from agenda where codigo='"+cCod+"'"
    
    //Abrindo o objeto
    Rs.Open()
    *Try
        if Rs.Eof()
            //nao achou o registro, logo temos um novo registro...
            //addnew cria uma nova posicao no recordset
            Rs.AddNew()
            Rs.Field.Codigo := cCod
        endif
        Rs.Field.Nome     := Main.oNome.Value
        Rs.Field.Endereco := Main.oEndereco.value
        Rs.Field.Cidade   := Main.oCidade.Cargo[Main.oCidade.Value]
        Rs.Field.Bairro   := Main.oBairro.value
        Rs.Field.Fone1    := Main.oFone1.Value
        Rs.Field.Fone2    := Main.oFone2.Value
        Rs.Field.Email    := Main.oEmail.Value
        Rs.Field.Estado   := Substr(Main.oUF.DisplayValue,1,2)
        
        Rs.Update()
        if !Rs.ErrorSQL()
            //Refresca o Grid com a letra selecionada
            Pesquisa_Agenda(cLetra)
        else
            Gravalog(Rs.SQL)
        Endif
    *Catch e
     *   MsgInfo(e:Operation+"-"+e:Description)
    *end
    Return .T.
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
Static function ExcluiContato()
    Local cCod:=Main.ocodigo.value,cSql
    if empty(cCod)
        Return .F.
    endif
    if !msgYesNo("Tem certeza que quer excluir este registro ?")
        Return .F.
    endif
    rs.New()
    //nao precisa abrir um recordset, pode enviar o comando direto para a conexao, valido para qualquer comando...insert update,etc...
    cSql:="Delete from agenda where codigo='"+cCod+"'"
    
    Rs.Execute(cSQL)
    if !Rs.ErrorSQL()
        //com sucesso, refresca o grid
        Pesquisa_Agenda(cLetra)
    endif
    
    Return .T.
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
Static function NaoPermiteCamposVazios(a)
    Local c,i
    //a recebe é uma matriz dos campos que devem ser validados, rotina generica, aqui poderia passar o formulario por parametro deixando
    //a rotina mais generica ainda...o foco é devolvido para o controle invalido...
    For i=1 to len(a)
        c:=a[i]
        if empty(Main.&(c).Value)
            MsgInfo("Campo "+c+" é de preenchimento obrigatório...")
            Main.&(c).SetFocus()
            Return .F.
        endif
    Next
    Return .T.
    
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
    //Habilitando-Desabilitando os controles
Static Function SetHabilitaControls(l)
    Main.oFone2.Enabled      := l
    Main.oFone1.Enabled      := l
    Main.oCidade.Enabled     := l
    Main.oBairro.Enabled     := l
    Main.oEndereco.Enabled   := l
    Main.oNome.Enabled       := l
    Main.oEmail.Enabled      := l
    Main.oUF.Enabled         := l
    Main.oSave.Enabled       := l
    Main.oEdit.Enabled       := !l.and.Main.oListaAgenda.Value>0
    Main.oDelete.Enabled     := !l.and.Main.oListaAgenda.Value>0
    Main.oNovo.Enabled       := !l    
    Return .T.
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************
    
Static function LoadFoto()
    Local cCodigo:=Main.oCodigo.Value,cImage ,Rs
    if Empty(cCodigo)
        MsgInfo("Selecione um funcionário...")
        Return .F.
    endif
    if lNovo
        MsgInfo("Um registro esta sendo criado, termino o processo antes de incluir a imagem...")
        Return .F.
    endif
    cImage:=Getfile({{"*.bmp","*.bmp"},{"*.jpg","*.jpg"},{"*.png","*.png"}},"Selecione uma foto...")
    if empty(cImage)
        Return .F.
    endif
    
    //Criando o objeto recordset()
    Rs.New()
  
    //STring SQL
    Rs.Sql:="Select codigo,foto from agenda where codigo='"+cCodigo+"'"
    
    //Abrindo a consulta
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    //Enquanto nao for o fim do cursor
    if !Rs.Eof()
    
        //gravando as alteracaoes/inclusao
        Rs.LoadFile("Foto",cImage)
        Rs.Update()
        IF !Rs.ErrorSQL()
            Main.oFoto.Picture := cImage
        endif
        
    endif
    
    //Fechando o RecordSet
    Rs.Close()
    
    Return .T.
    *****************************************************************************
    /////////////////////////////////////////////////////////////////////////////
    *****************************************************************************

Static Function Main_Oninit( )
    Local rs
    Rs.New()
    Main.oUF.DeleteAllItems()
    Main.oUF.Cargo:={}
    Rs.SQL:="Select * from tbUF order by codigo"
    Rs.Open()
    if rs.ErrorSQL()
        return .F.
    endif
    While !Rs.Eof()
        Main.oUF.AddItem(Rs.Field.codigo.value+"-"+Rs.field.descricao.value)
        AADD(Main.oUF.Cargo,rs.field.codigo)
        Rs.MoveNext()
    Enddo
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
    *Este evento é chamado quando se clica no botão de expansão do COMBO, a simplicidade do funcionamento e o poder de filtragem
    *fez com que eu adotasse este procedimento em tudo o que faço, tudo é muito rapido, sem sobrecarregar memoria, 
    *talvez o usuario tenha uma certa dificuldade de aceitação por conta do uso do mouse, mas não da para se falar em mundo grafico
    *querendo se manter aos habitos da tela preta...
Static Function Main_oCidade_Onlistdisplay( )
    Local cUF:=Substr(Main.oUF.DisplayValue,1,2)
    Local Rs
    Rs.New()
    Rs.SQL := "Select codcidade,nomecidade from cidade where nomecidade like '"+Main.oCidade.DisplayValue+"%' "
    if !Empty(cUF)
        Rs.SQL += " and estado='"+cUF+"'"
    endif
    Rs.SQL += "  order by nomecidade LIMIT 100"
    Rs.Open()
    if Rs.ErrorSQL()
        Gravalog(rs.SQL)
        Return .F.
    endif
    Main.oCidade.Cargo:={}
    Main.oCidade.DeleteAllItems()
    While !Rs.Eof()
        Main.oCidade.AddItem(Rs.Field.nomecidade.value)
        AADD(Main.oCidade.Cargo,rs.field.codcidade)
        rs.MoveNext()
    Enddo
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_oPictureButton1_Action( )
    #pragma __binarystreaminclude "version.h" | LOCAL cMsg := %s 
    cMsg += CRLF
    cMsg +="Minigui: " +Miniguiversion()+CRLF
    cMsg += "Harbour :"+Version()+CRLF
    cMsg += "Compiler :"+hb_Compiler()
    MsgInfo(cMsg,"About")
    Return .T.
