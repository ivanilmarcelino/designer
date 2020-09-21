#Include "minigui.ch"
#Include "F_sistema.ch"
#Include "Common.ch"
#Include "Fileio.CH"
#Include "Directry.ch"

/*
* Função: BloqueiaRegistronaRede( mArea ) == > .T.
*
*/
Function BloqueiaRegistroNaRede( marea )
	Local op := 0

	Do While ! (marea)->(RLock())	

		If ! MSGRetryCancel("Registro em Uso na Rede Tenta Acesso??",SISTEMA)
			Return .F.
		EndIf

	EndDo

	Return .T.
/*
* 
* Gera próximo codigo na área selecionada
* Sintaxe: GeraCodigo( ALIAS , INDEX , TAMANHO DO CAMPO ) => proximo Codigo
*
* oArea		= Área de trabalho (Alias)
* ordem		= Indice do campo Codigo
* tamanho	= Tamanho do campo Codigo 
*
*/
Function GeraCodigo( oArea , ordem , Tamanho )
	 Local regist	:= (oArea)->(Recno())	&& Guarda registro atual	
	 Local ord	:= (oArea)->(IndexOrd())	&& Guarda Indice atual
	 Local cdg	:= 0

	 (oArea)->(DBSetOrder( ordem ))		&& Posiciona a Area na Ordem desejada
	 (oArea)->(DBGoBottom())			&& vai para o fim do arquivo

	 cdg := StrZero( Val ( (oArea)->CODIGO ) + 1 , Tamanho ) && gera o codigo (Ultimo + 1), genado Zeros à esquerda de acordo com o tamanho solicitado

	*** Se o codigo gerado foi Zero, ocorreu um erro e usuário é informado
	If Val(cdg) == 0
		
		MSGExclamation(PadC("ATENCAO",70)+QUEBRA+;
			   PadC("*** Erro ao Gerar Codigo em "+oArea+" ***",70)+QUEBRA+;
			   PadC("*** Codigo Gerado EM BRANCO ***",70)+QUEBRA+;
			   PadC("Provavelmente existem indices ou Base de Dado Corrompida!!",70)+QUEBRA+;
			   PadC("Efetue a Manutencao do Sistema Antes de qualquer outra Operacao!!",70)+QUEBRA+;
			   PadC("*** Sistema Sera Finalizado!! ***",70),SISTEMA)
		RELEASE WINDOW ALL

	 Endif

	 *** Se Existem mais de um registro no arquivo e o próximo codigo gerado foi 1 , ocorreu um erro		
	If (oArea)->(LastRec()) > 1 .And. Val(cdg) == 1

		MSGExclamation(PadC("ATENCAO",70)+QUEBRA+;
			   PadC("*** Erro Detectado ao Gravar em "+oArea+" ***",70)+QUEBRA+;
			   PadC("*** Codigo Gerado Invalido!! ***",70)+QUEBRA+;
			   PadC("Provavelmente existem indices ou Base de Dado Corrompida!!",70)+QUEBRA+;
			   PadC("Efetue a Manutencao do Sistema Antes de qualquer outra Operacao!!",70)+QUEBRA+;
			   PadC("*** Sistema Sera Finalizado!! ***",70),SISTEMA)
		RELEASE WINDOW ALL

	 Endif

	 (oArea)->(DBSetOrder( ord ) )  && retorna para a Ordem em que arquivo estava
	 (oArea)->(DBGoTo( regist )  )   && retorna para o Registro que estava
	 Return( cdg )

/*
* Rotina que consiste se o registro foi gravado corretamente no DBF
*
* cArea		= Area de trabalho - (Alias)
* mCODIGO	= Codigo à pesquisar
* nIndex		= Index à pesquisar
*
*/
Function GravouCodigoCorretamente( cArea , mCODIGO , nIndex )
	 Local nInd	:= (cArea)->(IndexOrd())	&& Guarda a Ordem atual
	 Local nReg	:= (cArea)->(Recno())	&& Guarda o registro atual	
	 Local lRet := .T.

	(cArea)->(DBSetOrder(nIndex))	&& Posiciona na ordem/Indice desejado

	*** Se o codigo não foi localizado, o usu;ario recebe mensagem
	If ! (cArea)->(DBSeek(mCODIGO))	&& faz a pesquisa do Código

		MSGExclamation(PadC("ATENCAO",70)+QUEBRA+;
			   PadC("*** Registro nÆo incluido em "+cArea+" ***",70)+QUEBRA+;
			   PadC("Provavelmente existem indices ou Base de Dado Corrompida!!",70)+QUEBRA+;
			   PadC("Efetue a Manutencao do Sistema Antes de qualquer outra Operacao!!",70)+QUEBRA+;
			   PadC("*** Sistema Sera Finalizado!! ***",70),SISTEMA)
		RELEASE WINDO ALL

	 EndIf	
	 (cArea)->(DBSetOrder(nInd))	&& retorna para a Ordem em que arquivo estava
	 (cArea)->(DBGoTo(nReg))		&& retorna para o Registro que estava
	 Return lRet

/*
* Esta função é ma pesquisa genérica:
* O usuário informa a Area/Alias, a ordem para pesquisa, a variavel a ser pesquisada e o campo que deverá ser retornado
*
* Exemplo1: O usuário deseja o Endereço de um determinado Cliente
* cEnd := Pgeneric( "CLIENTES" ,     1    ,      "0012"             ,  "ENDERECO"    )
*		   Alias             index     Código Cliente      ,  Campo de retorno
* a variavel cEnd receberá o conteúdo da variável ENDERECO
* O campo para retorno poderá ser qualquer campo do DBF
*
* Exemplo2: O usuário deseja a DESCRICAO de Uma Conta no arquivo de Contas do Financeiro
* cDesc := Pgeneric( "CONTAS" ,  1 , "0016" , "DESCRICAO" )
* a variavel cDesc receberá o conteúdo da variável DESCRICAO do Arquivo CONTAS.DBF
*
* oArea	= Area de Trabalho/Alias
* oOrd	= Ordem de pesquisa
* oVar	= Variável a pesquisar
* oCampo = Conteudo do Campo que deve ser retornado	
*
*/
Function PGeneric(  oArea , oOrd   ,  oVar ,  oCampo )
	 Local	nord	   := (oArea)->(IndexOrd () )
	 Local	Oreg	   := (oArea)->(RECNO() )
	 Private  oNome
	 (oArea)->(DBSetOrder( oOrd ) )
	 (oArea)->(DBSeek( oVar ) )
	 oNome := '{ ||' + oArea + '->' + oCampo + '}'
	 oNome := &oNome
	 oNome := Eval( oNome )
	 (oArea)->(DBSetOrder( nord ) )
	 (oArea)->(DBGoTo( oReg ) )
	 Return( oNome )
/*
* Salva o Ambiente do Alias Atual em uma Array
* Salva o Alias, o Indice e o Recno()  da área corrente e guarda em uma Array
*
* Exemplo:
*
* Function Sample01()
*	  Local aAmb := SvAmb()
*
*	  ... Rotinas da Função	
*
*	  RtAmb( aAmb  )  && Restaura o Ambiente anterior
*	
*	  Return Nil
*/
Function SvAmb()
	Local Local1:= {}
	Aadd(Local1,Alias())
	Aadd(Local1,Indexord())
	Aadd(Local1,Recno())
	Return Local1
/*
*  Veja exemplo em SvAmb()
* Restaura o Ambiente gravado em uma Array pelo cmando SvAmb()
*/
Function RtAmb(Arg1)
	If Arg1[1] != Nil .And. Select(Arg1[1]) != 0
		Select(Arg1[1])
		If Arg1[2] != 0
			(Arg1[1])->(DBSetOrder(Arg1[2]))
		Endif
		If Arg1[3] != 0
			(Arg1[1])->(DBGoTo(Arg1[3]))
		 Endif
	 Endif
	 Return Nil
/*
* Pega valor da coluna em um Grid
*
* Sintaxe: PegavalorDacoluna( "Grid_Clientes" , "Form_Grid_Clientes" , 1 ) -> Valor
*
*/
Function PegaValorDaColuna( xObj, xForm, nCol)
	Local nPos := GetProperty ( xForm , xObj , 'Value' )
	Local aRet := GetProperty ( xForm , xObj , 'Item' , nPos )
	Return aRet[nCol]
/*
*
* Sintaxe: LinhaDeMesagem(  [ cMensagem ] )
* Esta função, recebe uma mensagem e atualiza a Linha de Status do Formulário atual
* Se não for passado nenhum parâmetro, a mensagem será atualizada com BaseDeDados()
*
*/
Function LinhaDeStatus(cMensagem)
	cMensagem := Iif( cMensagem == Nil , "Base de Dados: "+BaseDeDados() , AllTrim(cMensagem) )
	Form_0.StatusBar.Item(1) := cMensagem
	Return Nil

*------------------------------------------------------------------------------------------------------------------------------------------
* Função		: Cria_Ini()
* Finalidade	: Cria o Arquivo FINANC.INI assim que o sistema é inicializado no diretório atual
* Observação	: Sempre que o sistema é executado, verifica se o Arquivo existe, e se não existir cria.
*-----------------------------------------------------------------------------------------------------------------------------------------
Function Cria_File_Ini()
	If ! File("FINANC.INI")
	     BEGIN INI FILE "Financ.ini"
		SET SECTION "Base de Dados" ENTRY "Servidor"            To "SIM"
		SET SECTION "Base de Dados" ENTRY "Base de Dados" To DiskName()+":\"+CurDir()+"\BASE\" 	      
		SET SECTION "Segurança"        ENTRY "Exit"                 To "SIM"      
		SET SECTION "Segurança"        ENTRY "Último BackUp" To DtoC( Date() )
		SET SECTION "Segurança"        ENTRY "Data BackUp" 	 To DtoC( Date() )
		SET SECTION "Segurança"        ENTRY "Hora BackUp"   To Time()
		SET SECTION "Segurança"        ENTRY "Data Ultimo Acesso" To DtoC( Date() )
		SET SECTION "Segurança"        ENTRY "Hora Ultimo Acesso" To Time()
		SET SECTION "Segurança"        ENTRY "Usuario"  To "NONE"
	     END INI				
	EndIf
              Return Nil
*-------------------------------------------
* Lê o arquivo FINANC.INI e retorna a Base De Dados
Function BaseDeDados()
*-------------------------------------------
	Local cValue := ""
	
	If ! File("FINANC.INI")
	   MsgStop("Arquivo FINANC.INI não encontrado!!" , SISTEMA )
	   ExitProcess(0)
	EndIf

	BEGIN INI FILE "Financ.Ini"
		GET cValue SECTION "Base De Dados" ENTRY "Base De Dados"
	END INI
	
	Return Upper( cValue )
*-------------------------------------------
* Lê o arquivo FINANC.INI e retorna SIM/Não para Servidor de Dados
Function ServidorDeDados()
*-------------------------------------------
	Local cValue := ""
	
	If ! File("FINANC.INI")
	   MsgStop("Arquivo FINANC.INI não encontrado!!" , SISTEMA )
	   ExitProcess(0)
	EndIf

	BEGIN INI FILE "Financ.Ini"
		GET cValue SECTION  "Base De Dados" ENTRY "Servidor"
	END INI
	
	Return Upper( cValue )
*-------------------------------------------
* verifica no Arquivo FINANC.INI se sistema foi desligado corretamente
Function Saida_Irregular()
*-------------------------------------------
	Local cValue := ""
	
	If ! File("FINANC.INI")
	   MsgStop("Arquivo FINANC.INI não encontrado!!" , SISTEMA )
	   ExitProcess(0)
	EndIf

	BEGIN INI FILE "Financ.Ini"
		GET cValue SECTION  "Segurança" ENTRY "Exit"
	END INI
	
	Return Upper( cValue )
*------------------------------------------------------------------------------------------------------------------------------------------
* Função		: Status_Entrada_Saida(cStatus)
* Finalidade	: Controlar se o Sistema Foi desligado Corrretamente
*-----------------------------------------------------------------------------------------------------------------------------------------
Function Status_Entrada_Saida(cStatus)
	Local cValue := ""
	
	If ! File("FINANC.INI")
	   MsgStop("Arquivo FINANC.INI não encontrado!!" , SISTEMA )
	   ExitProcess(0)
	EndIf
	
              BEGIN INI FILE "Financ.ini"       
		SET SECTION "Segurança"  ENTRY "Exit"            To cStatus
		SET SECTION "Segurança"  ENTRY "Data Ultimo Acesso" To DtoC( Date() )
		SET SECTION "Segurança"  ENTRY "Hora Ultimo Acesso" To Time()
		SET SECTION "Segurança"  ENTRY "Usuario" To Iif( Select( "Acesso" ) != 0 , Acesso->APELIDO , "NONE" )
              END INI
	
              Return Nil
/*
*/
Function PackArquivo( cArq , LPack )	
	LPack := Iif( LPack == Nil, .F., LPack )
	If LPack
	   LinhaDeStatus("PACK em "+cArq)
	   USE (cArq) Alias ArqLimpa EXCLUSIVE NEW
	   IF ! NetErr()		
	       PACK
                 ENDIF  
	  ArqLimpa->(DBCloseArea())
             Endif       
             Return Nil	
/*
*/
Function Decripta( cPalavra )
	Local nTam	:= 0
	Local cChave	:= "@#$%"
	Local cCripitado	:= ""
	Local i		:=0        	  
	cPalavra := Iif( Empty( cPalavra ), "Ze Coolmeia", cPalavra )
	nTam := Len( cPalavra )
	Do While Len( cChave ) < nTam
		cChave += cChave
	EndDo
	cCripitado := ""
	For i := 1 To nTam
		cCripitado += Chr( Asc( SubStr( cPalavra, i, 1 ) ) - Asc( SubStr( cChave, i, 1 ) ) )
	Next
	Return cCripitado
/*
*/
Function Encripta( cPalavra )
	Local nTam	:= 0
	Local cChave	:= "@#$%"
	Local cCripitado	:= ""
	Local i		:=0                
	cPalavra := Iif( Empty( cPalavra ), "Ze Coolmeia", cPalavra )
	nTam := Len( cPalavra )
	Do While Len( cChave ) < nTam
		cChave += cChave
	EndDo
	cCripitado := ""
	For i := 1 To nTam
		cCripitado += Chr( Asc( SubStr( cPalavra, i, 1 ) ) + Asc( SubStr( cChave, i, 1 ) ) )
	Next	
	Return cCripitado
/*
*/
Function Indexa()
	Local cUsuarioAtual:= Acesso->Codigo
	Local cBase	:= BaseDeDados()
	Local aDir	:= Directory( cBase+"*.NTX" )
	Local i		:= 0

	If ServidorDeDados() == "SIM"

		If  MsgYesNo(PadC("*** Sistema Controle Financeiro V.1.0 ***",60)+QUEBRA+;
		      PadC(" *** Indexação do Sistema ***",60)+QUEBRA+;
		      PadC(" ",30)+QUEBRA+;
		      PadC(" Sua Estação de Trabalho é um Servidor de Dados!!",60)+QUEBRA+;
		      PadC(" Para indexar o sistema, verifique se não existem",60)+QUEBRA+;
		      PadC(" usuários ativos no Sistema e só após desativá-los",60)+QUEBRA+;
		      PadC(" inicie a Indexação!!",60)+QUEBRA+;
		      PadC(" ",30)+QUEBRA+;
	                    PadC(" INICIA indexação Agora??",60)+QUEBRA+;
	                    PadC("",60) , SISTEMA ) 

			LinhaDeStatus('Indexando Sistema Financeiro...  Aguarde !!')

			Close All
			
			** Apaga Arquivos de Indices (NTX)
			For i := 1 To Len( aDir )		
				Delete File (cBase+aDir[ i ][ 1 ])
			Next			

			ClientesOpen  (.T.)
			FornecedOpen(.T.)
			PagarOPen(.T.)

			*** Posiciona no Usuário Atual
			AcessoOpen()
			Acesso->(DBSetOrder(1))
			If ! Acesso->(DBSeek( cUsuarioAtual ))
				MsgBox("*** Erro *** Usuário Ativo não localizado... Reinicie o Sistema!!" , SISTEMA )
			EndIf

			MsgInfo("*** Indexação Finalizada!! ***" , SISTEMA )
			
		EndIf

	Else

		MsgInfo(PadC("*** Sistema Controle Financeiro V.1.0 ***",60)+QUEBRA+;
		      PadC(" *** Indexação do Sistema ***",60)+QUEBRA+;
		      PadC(" ",30)+QUEBRA+;
		      PadC(" Sua Estação de Trabalho é um Terminal de Dados",60)+QUEBRA+;
 		      PadC(" e a indexação só poderá ser feita no Servidor de Dados!!",60)+QUEBRA+;	
	                    PadC("",60) , SISTEMA ) 

	Endif
	
	Return Nil
/*
*/
Function GenericMask( xForm , xObj , cMask )
	Local i		:= 0
	Local cCGC	:= AllTrim( GetProperty ( xForm , xObj , 'Value' ) )
	Local nLen	:= 0
	Local cNewCGC	:= ""	

	For i := 1	 To Len( cMask )
		nLen += Iif(  IsDigit( Substr( cMask , i , 1 ) )  , 1 , 0 )
	Next

	For i := 1	 To Len( cCGC )
		cNewCGC += Iif(  IsDigit( Substr( cCGC , i , 1 ) )  , Substr( cCGC , i , 1 ) , ""  )
	Next

	cNewCGC :=  StrZero( Val( cNewCGC ) , nLen )	

	SetProperty ( xForm , xObj , 'Value' , TransForm( cNewCGC , cMask ) )

	Return Nil
/*
*/
Function NoModulo()
         MsgBox("Modulo não Disponível !!")
         Return Nil
