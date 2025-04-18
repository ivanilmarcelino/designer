/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.29.0 RELEASE CANDIDATE (RC) 220426 1943
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Vers�o Minigui:  Harbour MiniGUI Extended Edition 22.03.3 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Vers�o Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE C�DIGO GERADO:
    �ltima altera��o : 26/04/2022-19:57:03 M�quina: IMA2018 Usu�rio:Ivanil
    C�digo do m�dulo Frmlogin
    ----------------------------------------------------------------------------------------------
    Projeto : Transacao
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor MySQL oQuery

Declare window Main
Function LoadFrmFrmlogin
    //Esta vari�vel ser� a respons�vel em fechar a Main caso o login seja mal sucedido.
    Local lFezLogin:=.F.
    //Carregar o form em PRG separado nos permite criar as funcoes static totalmente independente
    //mesmo que este modulo seja chamado e carregado junto da Main
    Load window Frmlogin as Frmlogin
    Frmlogin.Center()
    TranslateUniversal("FrmLogin")
    //Activate n�o deve ser chamado aqui, deve ser chamado junto com a Main, vide o PRG principal.
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Frmlogin_Onrelease( lFezLogin)
    //Aqui no Onrelease do Form � verificado o valor de lFezLogin
    //Qualquer que seja o modo de fechamento do form
    if !lFezLogin
        //Finaliza o Sistema
        Msginfo("exit...")
        ExitProcess(0)
    endif
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Frmlogin_Oninit( )
    //Aqui � um lugar onde podemos dar sobrevida as funcionalidades do form,
    //este evento � chamado apos a cria��o dos objetos e antes que mostrado em tela;
    &&Passando um bloco para o Action do Hyperlink (Nova funcionalidade incluida recentemente no Core)
    FrmLogin.oMudaSenha.Action := {||FrmLoginMostra(TRUE)}
    //Reposiciona o texto para deixar a tela coerente no visual
    FrmLogin.oMudaSenha.Row := (FrmLogin.oMudaSenha.Row)+30
    //define visible=FALSE para os controles de troca de senha
    FrmLoginMostra(FALSE)
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function FrmLoginMostra(lMostrar)
    //Generaliza��o de fun��o para dar visibilidade aos controles
    //de troca de senha
    FrmLogin.oLabelNovaSenha.Visible := lMostrar
    FrmLogin.oLabelRepete.Visible    := lMostrar
    FrmLogin.oNovaSenha.Visible      := lMostrar
    FrmLogin.oRepete.Visible         := lMostrar
    //Se o usuario clicou em mudar senha ou foi acionado pelo sistema
    //automaticamente; o Hyperlink deve sumir.
    if lMostrar
        FrmLogin.oMudaSenha.Visible := !lMostrar
    endif
    Return Nil
    
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Frmlogin_oBtnConfirma_Action( )
    Local lMudaSenha := FrmLogin.oNovaSenha.Visible ,oQuery,cText:=""
    //lMuda senha vem da visibilidade do controle
    IF lMudaSenha
        //Aqui poderia ser for�ado uma complexidade na nova senha
        If len(FrmLogin.oNovaSenha.value)<5 .or. FrmLogin.oNovaSenha.value<>FrmLogin.oRepete.value .or.FrmLogin.oSenha.value==FrmLogin.oNovaSenha.value
            MsgStop("Nova Senha Inv�lida ou n�o confere!!"+CRLF+;
                    "Deve ser maior ou igual a 5 caracteres+"+CRLF+;
                    "Deve ser diferente da senha anterior"+CRLF+;
                    "Nova Senha e repetir senha devem ser iguais")                    
            FrmLogin.oNovaSenha.Setfocus()
            Return .F.
        endif
    ENDIF
    
    //Flaguimento de desenvolvimento
    //Este trecho tem finalidade de desenvolvimento, pela abertura do bin�rio do execut�vel � facilmente 
    //visto a regra deste acesso
    if Upper(FrmLogin.oUsuario.value)=="ADMIN".and.Upper(FrmLogin.oSenha.value)="11111"
        App.Cargo["user"] := hash()
        App.Cargo["user"]["id"]      := 0
        App.Cargo["user"]["usuario"] := "Admin"
        App.Cargo["user"]["nome"]    := "Administrador"
        App.Cargo["user"]["nivel"]   := 3
        Main.statusbar.item(2) := "Administrador"
        Return TRUE
    endif
    
    
    oQuery.New()
    
    //Buscamos o usuario para verifica��o
    //Usuario n�o � PrimaryKey mas � um indice que n�o permite duplica��o
    oQuery.SQL := "Select * from tabUser where Usuario='"+FrmLogin.oUsuario.value+"';"
    oQuery.Open()
    if oQuery.Eof()
        //Nao achou o usu�rio, mas n�o mandamos a mensagem correta.
        MsgInfo("Usu�rio ou senha inv�lido !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //Verificando se o usuario � ativo
    If !oQuery.Field.status.value
        MsgInfo("Usu�rio n�o est� ativo !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //Valida��o da Senha
    if !oQuery.Field.password.value == GetToxNo(FrmLogin.oSenha.value)
        //Nao achou o usu�rio, mas n�o mandamos a mensagem correta.
        MsgInfo("Usu�rio ou senha inv�lido !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //Valida��o do CRC
    //Se qualquer coisa foi alterado via banco, o login � negado.
    if !oQuery.Field.CRC.value == HB_MD5(oQuery.field.Usuario.value+;
                                          oQuery.field.Nome.value+;
                                          oQuery.field.Password.value+;
                                          Tipovar(oQuery.field.Status.value)+;
                                          hb_ntos(oQuery.field.nivel.value))
        //Nao achou o usu�rio, mas n�o mandamos a mensagem correta.
        MsgInfo("CRC inv�lido !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //A senha do usuario foi alterado pelo cadastro, nestes casos � for�ado a troca de senha no primeiro uso
    if !lMudaSenha.and.oQuery.field.alterasenha.value
        FrmLoginMostra(TRUE)
        FrmLogin.oNovaSenha.Setfocus()
        Return .F.
    endif
    
    //Aqui criamos um Hash para uso Geral
    App.Cargo["user"] := hash()
    App.Cargo["user"]["id"]      := oQuery.field.codigo.value
    App.Cargo["user"]["usuario"] := oQuery.field.usuario.value
    App.Cargo["user"]["nome"]    := oQuery.field.nome.value
    App.Cargo["user"]["nivel"]   := oQuery.field.nivel.value
    Main.statusbar.item(2)       := oQuery.field.usuario.value

    //Se houver uma associa��o de troca de senha o comando � enviado para atualiza��o.
    if lMudaSenha
        oQuery.SQL := "Update tabUser set Password='"+GetToxNo(FrmLogin.oNovaSenha.value)+"',"+;
                          "alterasenha=0,"+;
                          "CRC='"+ HB_MD5(App.Cargo["user"]["usuario"]+;
                                          App.Cargo["user"]["nome"]+;
                                          GetToxNo(FrmLogin.oNovaSenha.value)+;
                                          Tipovar(TRUE)+;
                                          hb_ntos(App.Cargo["user"]["nivel"]))+"'"+;
                       " Where codigo="+hb_ntos(App.Cargo["user"]["id"] )
                                          
        oQuery.Execute()
        If oQuery.ErrorSQL()
            Return FALSE
        Endif
                        
    endif
    
    //Vamos desabilitar tudo o que n�o � autorizado
    //Os niveis = 0, s�o op��es de uso comum ent�o n�o s�o monitoradas
    oQuery.SQL:=" select o.*,a.codigo as User from tabobjeto o "
    oQuery.SQL+=" left join tabacesso  a on a.codidobj=o.codidobj and a.codigo="+hb_ntos(App.Cargo["user"]["id"])
    oQuery.SQl+=" where o.nivel>0"
    oQuery.Open()
    While !oQuery.Eof
        if oQuery.field.nivel.value > App.Cargo["user"]["nivel"] .or. empty(oQuery.field.User.value)
            //Verifica se o objeto existe
            if _iscontroldefined(oQuery.field.objeto.value,"Main")
                Main.&(oQuery.field.objeto.value).Enabled := FALSE
            else
                cText += hb_ntos(oQuery.field.codidobj.value) + "-"+;
                         oQuery.field.tipo.value+"."+;
                         oQuery.field.objeto.value+"->"+;
                         Tipovar(oQuery.field.objeto.descricao)+CRLF
            endif
        endif
        oQuery.MoveNext()
    Enddo
    
    //� possivel que durante o projeto objetos troquem de nome ou seja removidos
    //este trecho notifica a inconsistencia para evitar lixo de dados na compila��o final.
    if !Empty(cText)
        cText += "Objetos n�o existem no projeto"+CRLF+cText+CRLF+"Contacte o Administrador!"
        MemoWrite("_objetos.log",cText)
        MsgStop(cText,"Seguran�a")
    endif

    Return TRUE
                                          
