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
    
Memvar hAcesso
#include <SISTEMA.CH>

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

