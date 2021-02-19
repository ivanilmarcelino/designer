/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.21.108 RELEASE CANDIDATE (RC) 210211 1254"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 21.01.0 (32-bit)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2101261627)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 16/02/2021-14:03:27 Máquina: IMA2018 Usuário:ivani
    Código do módulo CargaInicial.prg
    ----------------------------------------------------------------------------------------------
    Projeto : Agenda
    */
#include <hmg.ch>
#xcommand TEXT <into:TO,INTO> <v> => #pragma __cstream|<v>:=%s

function CreateDatabase()
    Local cn:=TadoConnection():new(),lRet
    Local oAdoX :=CreateObject("ADOX.Catalog")
    Local cSQL:="Provider=Microsoft.Jet.OLEDB.4.0;Jet OLEDB:Engine Type=5;Data Source=Agenda.mdb"
    oAdoX:Create(cSQL)    
    if !File("Agenda.mdb")
        Return .F.
    endif
    cn:ConnectSTring:=cSQL
    if !cn:Open()
        Return .F.
    endif
    **********************************
    *Create Tabela Agenda
    **********************************
    Text into cSQL
        CREATE TABLE `Agenda` (
            `CODIGO` VarChar(4) NOT NULL PRIMARY KEY, 
            `NOME` VarChar(40) NOT NULL, 
            `ENDERECO` VarChar(40), 
            `BAIRRO` VarChar(25), 
            `CEP` VarChar(8), 
            `CIDADE` Long, 
            `ESTADO` VarChar(2), 
            `NASCTO` DateTime, 
            `FONE1` VarChar(10), 
            `FONE2` VarChar(10), 
            `TIPO` VarChar(4), 
            `EMAIL` VarChar(40), 
            `FOTO` LongBinary, 
            `FUMANTE` Bit NOT NULL DEFAULT 0, 
            `OBSERVACAO` LongText
        )
    EndText
    cn:Execute(cSQL)
    if cn:ErrorSQL()
        Return .F.
    endif
        
    **********************************
    *Create Tabela de estados
    **********************************
    Text into cSQL
        CREATE TABLE `TBUF` (
            `CODIGO` VarChar(2) PRIMARY KEY, 
            `DESCRICAO` VarChar(30)
   
        )
    EndText
    cn:Execute(cSQL)
    if cn:ErrorSQL()
        Return .F.
    endif
    **********************************
    *Create Tabela de Cidade
    **********************************
    Text into cSQL
        CREATE TABLE `Cidade` (
            `codcidade` Long PRIMARY KEY, 
            `nomeCidade` VarChar(50) WITH COMP, 
            `estado` VarChar(2), 
            CONSTRAINT `TBUFCidade` FOREIGN KEY (`estado`)
                REFERENCES `TBUF` (`CODIGO`)
        )
    EndText
    cn:Execute(cSQL)
    if cn:ErrorSQL()
        Return .F.
    endif
    
    //Chamando a carga de dados inicial
    lRet:=CargadeDados(cn)
    cn:Close()
    Return lRet
    //////////////////////////////////////////////////////////////////////
    **********************************************************************
    //////////////////////////////////////////////////////////////////////
Static function CargadeDados(cn)
    Local aList:={"..\TbUF.sql","..\Cidade.SQL","..\Agenda.sql"}
    Local nK ,oFile,cSQL
    SET WINDOW MAIN OFF
    //verificando a existência dos arquivos
    For nk=1 to len(aList)
        if !File(aList[nk])
            MsgStop("Arquivo "+aList[nk]+" não encontrado !")
            Return .F.
        endif
    Next
    //Criando uma transação
    cn:BeginTrans()
    For nk=1 to len(aList)
        oFile:=TfileReader():New(aList[nK])
        oFile:Open()
        While !oFile:Eof()
            //HB_UTF8ToStr tratará os acentos
            cSQL:=HB_UTF8ToStr(oFile:Get())
            if !Empty(cSQL)
            
                //Esta funçao arrebenta com o processo,  colocada apenas para didatica..
                waitwindow(cSQL,.T.)
                
                cn:Execute(cSQL)
                if cn:ErrorSQL(cSQL)
                    //Se houver um erro desfaz tudo...
                    cn:RollbackTrans()
                    waitwindow()
                    Return .F.
                endif
            Endif
        Enddo
        oFile:Close()
    Next
    cn:CommitTrans()
    waitwindow()
    SET WINDOW MAIN ON
    Return .T.
    //////////////////////////////////////////////////////////////////////
    **********************************************************************
    //////////////////////////////////////////////////////////////////////

