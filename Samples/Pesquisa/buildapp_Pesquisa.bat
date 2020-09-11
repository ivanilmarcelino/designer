@SetLocal
@echo off
@set proj=Pesquisa

@Set OutPut=Pesquisa

if exist %OutPut%.exe @del %OutPut%.exe >>nul
@Set HB_ARCHITECTURE=w32
@Set OLDPATH=%PATH%

REM Path da IDE
@Set BaseDIR=E:\Prgplus\Youtube\teste\IDE


REM Ajuste aqui seus Paths caso queira criar uma nova configuração
@Set HMGPATH=%BaseDIR%\Tools
@Set HMGRPATH=%HMGPATH%\minigui
@Set HMGRHARBOUR=%HMGPATH%\Harbour

@Set HB_COMPILER=bcc
@Set HMGRCOMP=%HMGPATH%\bcc
@Set PATH=%HMGRHARBOUR%\bin;%HMGRCOMP%\bin
Echo Aguarde... Compilando o projeto...

HBMK2 %proj% 1>%proj%.log 2>&1

if not exist %OUTPUT%.exe start %proj%.log

If exist %OUTPUT%.exe (
Del %proj%.log
Del *.res
Del error*.htm
Del *.ppo
Del syslog.*
Del _hmg_resconfig.h
Del _temp.*
Del *.map
Del t
Del ???_log.htm
Del *.o
)

Goto fim

:fim
@Set HMGPATH=
@Set HMGRPATH=
@Set HMGRHARBOUR=
@Set HMGRCOMP=
@Set PATH=%OLDPATH%
@EndLocal
