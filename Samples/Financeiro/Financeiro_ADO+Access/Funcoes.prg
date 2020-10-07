/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "00.99.20.083 RELEASE CANDIDATE (RC) 200921 1743"
    Versão Minigui:  Harbour MiniGUI Extended Edition 20.08 (Update 3)  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2008190002)
    Compilador : MinGW GNU C 10.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 22/09/2020-16:39:53 Máquina: IMA2018 Usuário:ivani
    Código do módulo Funcoes.prg
    ----------------------------------------------------------------------------------------------
    Projeto : Financeiro
    */
    
Memvar hAcesso,cn
#include <SISTEMA.CH>
#include <hmg.ch>


Function Decripta( cPalavra )
    Local nTam,i
    Local cChave	:= "@#$%"
    Local cCripitado	:= ""
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
    Local nTam,i
    Local cChave	:= "@#$%"
    Local cCripitado	:= ""
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
    
Function xDate(dDateTime)
    Local cRet 
    if Empty(dDateTime)
        Return "00/00/0000"
    endif
    if Valtype(dDateTime)="C"
      if len(dDateTime)>10
         cRet := hb_StrToTS(Substr(dDateTime,7,4)+"/"+substr(dDateTime,4,2)+"/"+substr(dDateTime,1,2)+" "+substr(dDateTime,12))
      else
         cRet := Stod(Substr(dDateTime,7,4)+"/"+substr(dDateTime,4,2)+"/"+substr(dDateTime,1,2))
      endif        
    elseif valtype(dDatetime)="D"
        cRet := Dtoc(dDateTime)
    elseif Valtype(dDateTime)="T"
        cRet := TToc(dDateTime)
    endif
    Return cRet

Function MsgNO(cMsg)
    MsgINFO( "Usuário <"+ AllTrim( hAcesso["usuario"]) +"> sem permissão para "+cMsg+" Registros" , SISTEMA )
    Return Nil		

Function IdGlobal(cPreNome)
    Static nIdGlobal:=0
    cPrenome:=IIF(empty(cPreNome),"VAR",cPreNome)
    nIdGlobal++
    Return cPreNome+hb_ntos(nIdGlobal)
    
Function IniMes(d)
    d:=IIF(Empty(d),Date(),d)
    Return ctod("01/"+StrZero(Month(d),2)+"/"+StrZero(Year(d),4))
***********************************************************************************************************************
Function FimMes(d)
    Local m,y
    d := IIF(Empty(d),Date(),d)
    m := Month(d)
    y := Year(d)
    Return Ctod("01/"+StrZero(IIF(m=12,1,m+1),2)+"/"+StrZero(IIF(m=12,y+1,y),4))-1
***********************************************************************************************************************
Function CPF( _CPF )
    Local  wSomaDosProdutos ,;
            wResto ,;
            wDigitChk1 ,;
            wDigitChk2 ,;
            wStatus ,;
            wI,i,c
            
    _CPF := SoNumber(_CPF)        
    _CPF:=if(!Empty(_CPF).and.Val(_CPF)=0,Replicate('14',11),_CPF)
    For i=0 to 9
        c:=Str(i,1)
        if _cpf=Replicate(c,11)
            Return .F.
        endif
    Next
    if !Empty(_cpf).and.len(rtrim(_cpf))<>11
        Return .F.
    endif
    //  Calcula o 1o. digit-check.
    
    wSomaDosProdutos := 0
    For wI := 1 to 9
        wSomaDosProdutos := wSomaDosProdutos + ;
                            Val( SubStr( _CPF,wI, 1 ) ) * ( 11 - wI )
    Next wI
    wResto := wSomaDosProdutos - Int( wSomaDosProdutos / 11 ) * 11
    wDigitChk1 := If ( wResto == 0 .Or. wResto == 1 , 0 , 11 - wResto )

    //  Calcula o 2o. digit-check.

    wSomaDosProdutos := 0
    For wI := 1 to 9
        wSomaDosProdutos += Val( SubStr( _CPF,wI, 1 ) ) * ( 12 - wI )
    Next wI
    wSomaDosProdutos += 2 * wDigitChk1
    wResto := wSomaDosProdutos - Int( wSomaDosProdutos / 11 ) * 11
    wDigitChk2 := If ( wResto == 0 .Or. wResto == 1 , 0 , 11 - wResto )
    
   //  Confere.
    
    If ( SubStr( _CPF,10,1 ) == Str( wDigitChk1,1 ) .And. ;
            SubStr( _CPF,11,1 ) == Str( wDigitChk2,1 ) ).or.Empty(_CPF)
        wStatus := .T.
    Else
        wStatus := .F.
    EndIf
    Return( wStatus )
    ***********************************************************************************************************************
Function CNPJ(_CGC)
    LOCAL i,V1,V2,V3,V4,V5,V6,R1,R2,P,S,M:=Array(12),Ret:=.t.
    _CGC:=if(_CGC=Nil,'09',_CGC)
    _CGC:=SoNumber(_CGC)
    For i=1 To 12
        M[i] :=Val(Substr(_CGC,i,1))
    Next
    //1§ Digito
    V1 :=5*M[1]+4*M[2]+3*M[3]+2*M[4]+9*M[5]+8*M[6]+7*M[7]+6*M[8]+5*M[9]+4*M[10]+3*M[11]+2*M[12]
    V2 :=V1/11
    V3 :=INT(V2)*11
    R1 :=V1-V3
    
    P:=If(R1==0.or.R1==1,0,11-R1)
    
    //2§ Digito
    
    V4:=6*M[1]+5*M[2]+4*M[3]+3*M[4]+2*M[5]+9*M[6]+8*M[7]+7*M[8]+6*M[9]+5*M[10]+4*M[11]+3*M[12]+2*P
    V5 :=V4/11
    V6 :=INT(V5)*11
    R2 :=V4-V6
    
    S:=If(R2==0.or.R2==1,0,11-R2)
    
    IF !Empty(_CGC).and.P<>Val(Substr(_CGC,13,1)).or.S <>Val(Substr(_CGC,14,1))
        Ret:=.f.
    Endif
    Return Ret
    ***********************************************************************************************************************
Function CargaInicial()
    Local aList,cLine
    Local cFile:=Getfile({{"*.sql","*.sql"}})
    if Empty(cFile)
        Msginfo("Nenhum arquivo selecionado!",SISTEMA)
        Return Nil
    endif
    aList := Hb_atokens(Memoread(cFile),CRLF)
    For each cLine in aList
        if !Empty(cLine)
            cn:Execute(cLine)
        endif
    Next
    MsgInfo("Dados importados",SISTEMA)
    Return Nil
    ***********************************************************************************************************************
Function SoNumber(cPar)
    Local cRet:="",cNumber:="0123456789",c
    cPar:=IIF(Empty(cPar),"",cPar)
    For each c in cPar
        if At(c,cNumber) > 0
            cRet += c
        endif
    Next
    Return cRet
