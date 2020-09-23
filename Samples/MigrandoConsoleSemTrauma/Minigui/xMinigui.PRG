/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 22/09/2020-22:35:25 Máquina: IMA2018 Usuário:ivani
    Código Módulo Main
    ----------------------------------------------------------------------------------------------
    Projeto : Minigui
    */

#include <hmg.ch>
Function Main( ... )
    //Recebe tantos parametros forem necessarios...
    Local aParam:= Hb_aparams()
    
    //Diz para a Minigui não exigir a criação de uma Main
    SET WINDOW MAIN OFF
    
    //No meu exemplo vou receber 3 parameros...
    If len(aParam)<3
        Return Nil
    Endif
    
    //Aqui voce poderia abrir seu arquivo de senhas verificar se as senhas batem e não se voce tem controle de acesso aos itens de menu pelo
    //cadastro de usuario, mas seria uma forma de garantir essa integridade.
    if !(aParam[2]="Fernando".and.aParam[3]="1234")
        Return Nil
    endif
    
    //Aqui  você poderia estruturar dessa forma
    Do Case
        //Repasando os parametros
        Case aParam[1]="TESTE"
            LoadFrmTeste(aParam)
            
        Case aParam[1]="TFILI"
            LoadFrmTfili()
            
        Case aParam[1]="CADCLIENTES"
            LoadFrmClientes()
            
        Case aParam[1]="CADFORNEC"
            LoadFrmFornecedores()
    Endcase
    REturn Nil
