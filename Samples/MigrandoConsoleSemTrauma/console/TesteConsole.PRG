/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 22/09/2020-21:53:03 M�quina: IMA2018 Usu�rio:ivani
    C�digo M�dulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : TesteConsole
    */

/*
    Exemplo de menu usando menumodal e 
    menusys1 (menusys original modificado para eventos do mouse
    Major Anilto - 17Abr2020
    https://www.linguagemclipper.com.br/blogs/exemplos/estudo-da-funcao-menumodal-para-criacao-de-menus-modo-console
*/
 
#include "button.ch"
#include "inkey.ch"
#include "box.ch"
    #ifndef __XHARBOUR__
        #include "hbcompat.ch"
    #endif
 
/* Para usar acentua��es, mouse, etc */
#include "hbgtinfo.ch"      //acrescentado no harbour
REQUEST HB_LANG_PT          //acrescentado no harbour - portugu�s
REQUEST HB_CODEPAGE_PTISO   //acrescentado no harbour - codepage 
REQUEST HB_GT_WVT_DEFAULT

memvar coluna,linha
 
Function Main()
    LOCAL oInfo
    LOCAL Retorno := 0
    PUBLIC Coluna := 80
    PUBLIC Linha := 40
     
    /* Para usar acentua��es, etc.) */
    HB_LANGSELECT('PT')
    HB_CDPSELECT('PTISO')   
    HB_GtInfo( HB_GTI_MAXIMIZED, .F. )
    HB_GtInfo( HB_GTI_FONTNAME, "Courier Prime" )
    HB_GtInfo( HB_GTI_WINTITLE, "Teste de menu" )
     
    /* Configura��es do ambiente */
    SET( _SET_EVENTMASK, INKEY_ALL )       
    MSETCURSOR(.T.)
    set cursor off
    set score off
    setmode(Linha,Coluna)
    Cls
    /* Isto permite mudar toda a paleta de cores */
    PALETA()
    /* Chamada para criar um objeto de menu */
    oInfo:=CriaMenu()
    /* Loop para execu��o do menu */
    WHILE Retorno == 0
        Retorno := MENUMODAL(oInfo,1,Linha-1,0,Coluna-1,"W+/b")
        /* Aqui chama alguma fun��o para tratar a sa�da do sistema */
    ENDDO
Return ( NIL )
     
/* Cria��o da estrutura do menu */
Function CriaMenu() // Usando a fun��o MenuModal()
   LOCAL oTopBar
   LOCAL COR1 := "w+/b,W+/rb,gr+/g,gr+/rb,w/N,w/B"
    
    /* Cria a barra de menus na linha 1, a partir da coluna 1 at� a coluna Coluna-2) */
    oTopBar := TopBar( 1,0, Coluna - 1)     /* linha, coluna tamanho */
    oTopBar:ColorSpec :=cor1                /* especifica as cores */
     
    /* Coloca os elementos do menu */
    oTopBar:AddItem( MenuItem ( "Pedido"      ,{ || Pedido()},,"Novo pedido") )           
    oTopBar:AddItem( MenuItem ( "Teste"       ,{ || RunMInigui("TESTE")},, "Teste de par�metros") ) 
    oTopBar:AddItem( MenuItem ( "Filiais"     ,{ || RunMInigui("TFILI")},, "Cadastro de Filiais") ) 
    oTopBar:AddItem( MenuItem ( "Cadastro"    ,{ || RunMInigui("CADCLIENTES")},, "Cadastro de clientes") ) 
    oTopBar:AddItem( MenuItem ( "Fornecedores",{ || RunMinigui("CADFORNEC")},,"Cadastro de fornecedores") )      
    oTopBar:AddItem( MenuItem ( "Estoque"     ,{ || Estoque()},, "Controle de estoque") )    
    oTopBar:AddItem( MenuItem ( "Utilit�rios" ,{ || Util()},,"POPUP") )  
     
Return ( oTopBar)
 
/* Fun��es chamadas pelos itens do menu */
Function Pedido()
Alert("Novos pedidos")
Return Nil
 
Function Cadastro()
Alert("Cadastramento de clientes")
Return Nil
 
Function Forn()
Alert("Cadastramento de fornecedores")
Return Nil
 
Function Estoque()
Alert("Controle de estoque")
Return Nil
 
Function Util()
Alert("Utilit�rios do sistema")
Return Nil
 
/* Fun��o que muda a paleta de cores */
Function paleta()
    local aPal := {     0x000000, ; //0 N
                        0xd27619, ; //1 B
                        0x004d00, ; //2 G
                        0xc1ac00, ; //3 BG
                        0x1c1cb7, ; //4 R
                        0xdaa89f, ; //5 RB
                        0xc8ccd7, ; //6 GR
                        0x222222, ; //7 N+
                        0x888888, ; //8 W 
                        0xfab481, ; //9 B+
                        0x84c781, ; //10 G+
                        0xf2ebb2, ; //11 BG+
                        0x7373e5, ; //12 R+
                        0xdb9db3, ; //13 RB+
                        0x58eeff, ; //14  GR+
                        0xffffff }  //15 W+
     HB_GtInfo( HB_GTI_PALETTE, aPal)
 
Return Nil

Function RunMInigui(cRotina)
    Local ws:=CreateObject("WScript.Shell"),e
    Local cUser:="Fernando"
    Local cSenha:="1234"
    try
        ws:run("Minigui"+" "+cRotina+" "+cUser+" "+cSenha+' "For�a Brasil, a pandemia vai passar!"',1,.T.)
    catch E
        Alert(e:Operation+"-"+e:Description)
    end   
    Return Nil