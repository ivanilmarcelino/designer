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
    Última alteração : 15/12/2020-21:03:20 Máquina: IMA2018 Usuário:ivani
    Código Módulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : TestSQL
    */

#include <hmg.ch>
Memvar Connection,oServer,oSQL

Function Main( vParam )
    /*Configuração do banco de dados
Caso queira criar sua própria configuração, basta excluir a linha abaixo e escrever seu código aqui...*/

    //ACCESS
    Private Connection //Variáveis globais de conexão
    Connection := TadoConnection():New() //Cria o objeto ADO
    Connection:ConnectString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\Database.mdb;Persist Security Info=False' //String de Conexão
    if !Connection:Open() //Abre o banco de dados
        Return .F.
    Endif
    
    //mysql
    Private oServer//Variáveis globais de conexão
    oServer:=TMySQLServerIma():New('localhost', 'root','root',3311) //Cria o objeto MySQL
    if oServer:Neterr() //verifica se ouve erro na abertura do banco
        MsgStop('Erro ao conectar banco de dados Mysql' + oServer:Error())
        Return .F.
    Endif
    oServer:SelectDB('sfpplus')
    if oServer:Neterr() //verifica se ouve erro na abertura do banco
        MsgStop('Erro ao selecionar o Database !!' + 'sfpplus:'+oServer:Error())
        Return .F.
    Endif
    
    //SQLITE
    Private oSQL //Variáveis globais de conexao
    oSQL:=TSqLite3():New()
    oSQL:Database:='.\Database.SQlite'
    oSQL:IsCreate:=.F.
    if !oSQL:Open()
        Return .F.
    endif
    
    
    *#Include <TestSQL.DB>

    (vParam)

    /* Sets incluídos pelo Designer
Caso queira fixar sua própria configuração, basta excluir a linha abaixo.*/
    #Include <TestSQL.CH>

    /*Carregando o formulário Principal*/
    Load window TestSQL as Main
    Main.Center

    Main.activate()

    REturn .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Toolbar_1Button1_Action( )
    LoadFrmFormDBF()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Toolbar_1Button2_Action( )
    LoadFrmformSqlite()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Toolbar_1Button3_Action( )
    LoadFrmformMysql()
    Return .T.
    

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Main_Toolbar_1Button4_Action( )
    LoadFrmFormAccess()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
