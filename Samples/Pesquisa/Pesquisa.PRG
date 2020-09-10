/*  SOBRE A IDE
   ==============================================================================================
   Gerado pela IDE Designer criada em 21/08/2019-17:45:12
   IMA Solutions Apoio Téc/Adm em Informática :> (ima.solutions@terra.com.br)
   Responsável:Ivanil Marcelino :> (ivanil.marcelino@yahoo.com.br)
   Local: Florianópolis /SC - Brasil
   Versão Minigui: Harbour MiniGUI Extended Edition 19.08 (32-bit)
   Versão Harbour/xHarbour:Harbour 3.2.0dev (r1904111533)
   Compilador :MinGW GNU C 8.3.1 (32-bit)
   ----------------------------------------------------------------------------------------------
   SOBRE ESTE CÓDIGO GERADO:
   Última alteração : 24/08/19-23:59:36 Máquina: IMA2018 Usuário:ivani
   ----------------------------------------------------------------------------------------------
   Projeto : NewProject
   */

#include <hmg.ch>
Function Main
    Set Default Icon TO  [IconPadrao] /*Altere para o seu padrão*/
    Set Language to Portuguese
    Request hb_codepage_ptiso
    Set Date French
    Set Deleted ON


   Load window Pesquisa as FormPesquisa

   FormPesquisa.activate()

   REturn .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FormPesquisa_Oninit()
   Local aMat:={},i:=0
   FormPesquisa.oLabel1.Value := oLabel1_Caption()
   AADD(aMat , {"cod"   ,"C", 5,0})
   AADD(aMat , {"Nome"  ,"C",30,0})
   DbCreate("Dados",aMat)
   use Dados
   dbCreateIndex( "Dados", "Upper(Nome)", { || Upper(Dados->Nome) })
   APPEND FROM DADOS.txt DELIMITED WITH TAB
   Dados->(DbGotop())
    While !Dados->(Eof()) .and. i<=30
        i++
        FormPesquisa.oPesquisa.AddItem(Dados->Nome)
        FormPesquisa.oLista.AddItem({Dados->Cod,Dados->Nome})
        Dados->(DbSkip())
    enddo
   
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function FormPesquisa_Opesquisa_Ondisplaychange()
    lOCAL cText:=FormPesquisa.oPesquisa.displayvalue,i
    FormPesquisa.oPesquisa.DeleteAllItems()
    FormPesquisa.oLista.DeleteAllItems()
    if !Dados->(DbSeek(Upper(cText)))
        cText:=substr(cText,1,len(cText)-1)
        FormPesquisa.oPesquisa.displayvalue := cText
        _PUSHKEY(VK_END)
        Return .f.
    endif

    I:=0
    While !Dados->(Eof()) .and. (Upper(Dados->Nome) = Upper(cText) .or.empty(cText)) .and. i<=30
        i++
        FormPesquisa.oPesquisa.AddItem(Dados->Nome)
        FormPesquisa.oLista.AddItem({Dados->Cod,Dados->Nome})
        Dados->(DbSkip())
    enddo
    FormPesquisa.oPesquisa.displayvalue := cText
    _PUSHKEY(VK_END)
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function oLabel1_Caption()
    Local cText:="ATENÇÃO"+CRLF
    cText += "Ao abrir o formulário são carregados"+CRLF
    cText += "30 itens por padrão ao combo"+CRLF+CRLF
    cText += "Ao digitar algo no combo o ocorre"+CRLF
    cText += "uma filtragem e na medida que vai"+CRLF
    cText += "digitando o combo vai se alimentando"+CRLF+CRLF
    cText += "Não há prejuizo de memoria ou lentidão"+CRLF
    Return cText
