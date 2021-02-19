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

function CreateDatabase(cn)
    Local  cSQL,lRet
    **********************************
    *Create Tabela Agenda
    **********************************
    Text into cSQL
        CREATE TABLE Agenda (
            CODIGO VarChar(4) NOT NULL PRIMARY KEY, 
            NOME VarChar(40) NOT NULL  , 
            ENDERECO VarChar(40) , 
            BAIRRO VarChar(25) , 
            CEP VarChar(8), 
            CIDADE Integer , 
            ESTADO VarChar(2), 
            NASCTO TIMESTAMP, 
            FONE1 VarChar(10), 
            FONE2 VarChar(10), 
            TIPO VarChar(4), 
            EMAIL VarChar(40), 
            FOTO Blob, 
            FUMANTE CHAR(1)  DEFAULT '0', 
            OBSERVACAO Blob
        )
    EndText
    cn:Execute(cSQL)
    if cn:ErrorSQL(cSQL)
        Return .F.
    endif
        
    **********************************
    *Create Tabela de estados
    **********************************
    Text into cSQL
        CREATE TABLE TBUF (
            CODIGO VarChar(2) PRIMARY KEY, 
            DESCRICAO VarChar(30) 
   
        )
    EndText
    cn:Execute(cSQL)
    if cn:ErrorSQL(cSQL)
        Return .F.
    endif
    **********************************
    *Create Tabela de Cidade
    **********************************
    Text into cSQL
        CREATE TABLE Cidade (
            codcidade Integer PRIMARY KEY, 
            nomeCidade VarChar(50) , 
            estado VarChar(2), 
            CONSTRAINT TBUFCidade FOREIGN KEY (estado)
                REFERENCES TBUF (CODIGO)
        )
    EndText
    cn:Execute(cSQL)
    if cn:ErrorSQL(cSQL)
        Return .F.
    endif
    
    //Chamando a carga de dados inicial
    lRet:=CargadeDados(cn)
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
    cn:EndTrans()
    cn:CommitTrans()
    waitwindow()
    SET WINDOW MAIN ON
    Return .T.
    //////////////////////////////////////////////////////////////////////
    **********************************************************************
    //////////////////////////////////////////////////////////////////////

