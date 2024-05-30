/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.29.0 RELEASE CANDIDATE (RC) 220426 1943
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.03.3 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 26/04/2022-19:57:03 Máquina: IMA2018 Usuário:Ivanil
    Código do módulo Frmlogin
    ----------------------------------------------------------------------------------------------
    Projeto : Transacao
    */

#include <hmg.ch>
#include <SQLAdo.CH>
Declare Cursor MySQL oQuery

Declare window Main
Function LoadFrmFrmlogin
    //Esta variável será a responsável em fechar a Main caso o login seja mal sucedido.
    Local lFezLogin:=.F.
    //Carregar o form em PRG separado nos permite criar as funcoes static totalmente independente
    //mesmo que este modulo seja chamado e carregado junto da Main
    Load window Frmlogin as Frmlogin
    Frmlogin.Center()
    TranslateUniversal("FrmLogin")
    //Activate não deve ser chamado aqui, deve ser chamado junto com a Main, vide o PRG principal.
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function Frmlogin_Onrelease( lFezLogin)
    //Aqui no Onrelease do Form é verificado o valor de lFezLogin
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
    //Aqui é um lugar onde podemos dar sobrevida as funcionalidades do form,
    //este evento é chamado apos a criação dos objetos e antes que mostrado em tela;
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
    //Generalização de função para dar visibilidade aos controles
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
        //Aqui poderia ser forçado uma complexidade na nova senha
        If len(FrmLogin.oNovaSenha.value)<5 .or. FrmLogin.oNovaSenha.value<>FrmLogin.oRepete.value .or.FrmLogin.oSenha.value==FrmLogin.oNovaSenha.value
            MsgStop("Nova Senha Inválida ou não confere!!"+CRLF+;
                    "Deve ser maior ou igual a 5 caracteres+"+CRLF+;
                    "Deve ser diferente da senha anterior"+CRLF+;
                    "Nova Senha e repetir senha devem ser iguais")                    
            FrmLogin.oNovaSenha.Setfocus()
            Return .F.
        endif
    ENDIF
    
    //Flaguimento de desenvolvimento
    //Este trecho tem finalidade de desenvolvimento, pela abertura do binário do executável é facilmente 
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
    
    //Buscamos o usuario para verificação
    //Usuario não é PrimaryKey mas é um indice que não permite duplicação
    oQuery.SQL := "Select * from tabUser where Usuario='"+FrmLogin.oUsuario.value+"';"
    oQuery.Open()
    if oQuery.Eof()
        //Nao achou o usuário, mas não mandamos a mensagem correta.
        MsgInfo("Usuário ou senha inválido !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //Verificando se o usuario é ativo
    If !oQuery.Field.status.value
        MsgInfo("Usuário não está ativo !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //Validação da Senha
    if !oQuery.Field.password.value == GetToxNo(FrmLogin.oSenha.value)
        //Nao achou o usuário, mas não mandamos a mensagem correta.
        MsgInfo("Usuário ou senha inválido !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //Validação do CRC
    //Se qualquer coisa foi alterado via banco, o login é negado.
    if !oQuery.Field.CRC.value == HB_MD5(oQuery.field.Usuario.value+;
                                          oQuery.field.Nome.value+;
                                          oQuery.field.Password.value+;
                                          Tipovar(oQuery.field.Status.value)+;
                                          hb_ntos(oQuery.field.nivel.value))
        //Nao achou o usuário, mas não mandamos a mensagem correta.
        MsgInfo("CRC inválido !!")
        FrmLogin.oUsuario.Setfocus()
        Return .F.
    endif
    
    //A senha do usuario foi alterado pelo cadastro, nestes casos é forçado a troca de senha no primeiro uso
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

    //Se houver uma associação de troca de senha o comando é enviado para atualização.
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
    
    //Vamos desabilitar tudo o que não é autorizado
    //Os niveis = 0, são opções de uso comum então não são monitoradas
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
    
    //é possivel que durante o projeto objetos troquem de nome ou seja removidos
    //este trecho notifica a inconsistencia para evitar lixo de dados na compilação final.
    if !Empty(cText)
        cText += "Objetos não existem no projeto"+CRLF+cText+CRLF+"Contacte o Administrador!"
        MemoWrite("_objetos.log",cText)
        MsgStop(cText,"Segurança")
    endif

    Return TRUE
                                          
