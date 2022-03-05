/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    1.0.22.0 RELEASE CANDIDATE (RC) 220301 1913
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 22.01.4 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.2 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 04/03/2022-22:43:49 Máquina: IMA2018 Usuário:Ivanil
    Código do módulo Funca1
    ----------------------------------------------------------------------------------------------
    Projeto : Gui
    */

#include <hmg.ch>
Function LoadFrmFunca1
    Local Funca1 := IdGlobal("Funca1")
    Load window Funca1 as &(Funca1)

    /*Por padrão o Activate está desabilitado, com isso esse formulário pode ser chamado por outro Módulo
    e tratado externamente, neste caso, embora seja desaconselhado pode ser necessário.
    Se for chama-lo de outro código, as funções abaixo, deverão ser públicas, retire o Static.
    Lembre-se também que quando for usar o formulário em outro módulo, você deve declará-lo no Header=> Declare windowFunca1*/

        &(Funca1).Center()

    &(Funca1).activate()

    Return .T.
