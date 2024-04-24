/*
Versão Designer : 3.2304.0.0 SPECIAL RHENIUM (Re) Year IV 230512 1634
==============================================================================================================
https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
Versão Minigui:  Harbour MiniGUI Extended Edition 23.04.0 (32-bit) ANSI by Grigory Filatov <gfilatov@inbox.ru>
Versão Harbour/xHarbour: Harbour 3.2.0dev (r2211112015)
Compilador : MinGW GNU C 12.2 (32-bit)
-------------------------------------------------------------------------------------------------------------
Este programa (Apenas o Binário) é distribuído na esperança de que seja útil, mas SEM QUALQUER GARANTIA; sem mesmo a garantia
implícita de COMERCIALIZAÇÃO ou ADEQUAÇÃO PARA UM PROPÓSITO ESPECÍFICO.
-------------------------------------------------------------------------------------------------------------
SOBRE ESTE CÓDIGO GERADO:
--------------------------------------------------------------------------------------------------------------
Projeto : Designer
Este projeto é de código fechado, caso você tenha acesso a este fonte, saiba que você não tem autorização de 
copiar, modificar ou distribuir .
Ultima revisão para lançamento da versão 3 em 12/05/20231
--------------------------------------------------------------------------------------------------------------
*/

#Include <HMG.CH>


Function Ini(cSection, cEntry, cDefault, cIni,lGrava)
    Local cGrava
    if empty(cIni)
        cIni:=cFilePath(hb_argv(0))+"\"+cFileNoExt(hb_argv(0))+".INI"
        if !File(cIni)
            MemoWrit(cIni,"")
        endif
    endif
    IF At( "\", cIni ) == 0
        cIni:=cFilePath(hb_argv(0))+"\"+cIni
    ENDIF
    lGrava    := IIF(empty(lGrava),.F.,lGrava)
    cDefault  := IIF(empty(cDefault),"",Tipovar(cDefault))
    //Aqui vamos ver se  mudou de ini
    if empty( _HMG_ActiveIniFile) .or. Upper( _HMG_ActiveIniFile) <> Upper(cIni)
        _BeginIni( cIni )
    endif
    if empty(cSection)
        return _GetSectionNames(cIni)
    endif
    if empty(cEntry)
        return _GetSection(cSection,cIni)
    endif
    if !lGrava
        cDefault := _GetIni( cSection, cEntry, cDefault, "C")
        
        cDefault := StrTran(cDefault,"{<13>}",chr(13))
        cDefault := StrTran(cDefault,"{<10>}",chr(10))
        cDefault := StrTran(cDefault,"{<26>}",chr(26))        
    else
        //Mecessário manter o default sem  o ajuste de caracteres especiais.
        cGrava:=StrTran(cDefault,chr(13),"{<13>}")
        cGrava:=StrTran(cGrava,chr(10),"{<10>}")
        cGrava:=StrTran(cGrava,chr(26),"{<26>}")
        _SetIni( cSection, cEntry, cGrava )
    endif
    Return cDefault
    **********************************
    //////////////////////////////////    
