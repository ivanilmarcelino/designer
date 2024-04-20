#include <hmg.ch>

Declare window (cForm)

Function TranslateUniversal(cForm)
    Local cIni:=hb_Progname(),cName,cType,aIni,cTranslate,cChave,aTemp,nPos,k,nID,cCountry
    cIni:=substr(cIni,1,rat(".",cIni))+"INI"    
    
    //Obtem o valor do Ini
    cCountry := Ini("Translate","Country","BR")
    
    cChave   := cCountry+"_"+cForm
    
    if !_isWindowDefined(cForm)
        msginfo(cForm+" não esta definida...")
        Return .F.
    endif
    
    aIni:=Ini(cChave)
    if (cTranslate := Ini(cChave, "Title", "__VAZIO__" ,cIni , .F. ))=="__VAZIO__"
        cTranslate := Ini(cChave, "Title",(cForm).Title,cIni , .T. )
    endif
    (cForm).Title := cTranslate + " Translate ["+cCountry+"]"
    
    For each cName in _GetArrayOfAllControlsForForm(cForm)
        cType := getcontroltype(cName,cForm)
        if At(cType,"FRAME,MENU,POPUP,STATUSBAR,STATUSITEM"/*Esses controles não tem tooltip*/)=0
            aTemp := (cForm).(cName).Tooltip
            If !Empty(aTemp)
                if valtype(aTemp)="A"
                    for k=1 to len(aTemp)
                        if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".Tooltip." + hb_ntos(k)})) = 0
                            Ini(cChave, cName + ".Tooltip." + hb_ntos(k) , aTemp[k] ,cIni , .T. )
                        else
                            aTemp[k] := aIni[nPos,2]
                        endif
                    Next
                    (cForm).(cName).Tooltip :=  aTemp
                else
                    if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".Tooltip"})) = 0
                        Ini(cChave, cName + ".Tooltip" , aTemp ,cIni , .T. )
                    else
                        (cForm).(cName).Tooltip :=  aIni[nPos,2]
                    endif
                endif
            endif
        Endif

        if cType $ "COMBOBOX,SPINNER,TEXTBOX,MASKEDTEXT,TEXT,MASKEDTEXTBOX,CHARMASKTEXTBOX,NUMTEXTBOX,COMBOBOXEX" .OR. Substr(cType,1,3) = "BTN"
            if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".placeholder"})) = 0 
                Ini(cChave, cName + ".placeholder" , (cForm).(cName).cuebanner ,cIni , .T. )
            else
                (cForm).(cName).cuebanner := aIni[nPos,2]
            endif
        Endif

        if cType="LABEL"
            if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".value"})) = 0
                Ini(cChave,cName + ".value" , (cForm).(cName).value ,cIni , .T. )
            else
                (cForm).(cName).value := aIni[nPos,2]
            endif
            
        Elseif cType $ "MENU,POPUP"
            if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".caption"})) = 0 
                Ini( cChave, cName  + ".caption" ,  _GetMenuItemCaption(cName,cForm) ,cIni , .T. )
            else
                _SetMenuItemCaption(cName,cForm,aIni[nPos,2])
            endif  

            if cType = "MENU"
                nID:=GetControlIndex(cName,cForm)
                if nID>0
                    if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".Message"})) = 0  
                        Ini( cChave, cName  + ".Message" , _HMG_aControlValue[nID] ,cIni , .T. )
                    else
                        _HMG_aControlValue[nID] := aIni[nPos,2]
                    endif
                endif
            Endif
                

        Elseif  cType  $ "TAB,GRID,BROWSE"
            nID:=GetControlIndex(cName,cForm)
            if !Empty(nID)
                aTemp:=_HMG_aControlCaption[nId]
                
                for k=1 to len(aTemp)
                    if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".Header."+ hb_ntos(k)})) = 0 
                        Ini( cChave, cName  + ".Header." + hb_ntos(k) , aTemp[k] ,cIni , .T. )
                    else
                        (cForm).(cName).Header(k)  := aIni[nPos,2]
                    endif
                Next
            Endif
        Elseif cType $ "RADIOGROUP,TOOLBAR,BUTTON,OBUTTON,PICTUREBUTTON,CHECKBOX,LISTBOX,CHECKBUTTON,MULTICHKLIST,CHECKLISTBOX,CHKLISTBOX,CLBUTTON,FRAME,BUTTONEX,TOOLBUTTON"
            aTemp:=(cForm).(cName).caption
            If !Empty(aTemp)
                if valtype(aTemp)="A"
                    for k=1 to len(aTemp)
                        if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".caption."+ hb_ntos(k)})) = 0 
                            Ini( cChave,cName + ".Caption." + hb_ntos(k) , aTemp[k] ,cIni , .T. )
                        else
                            (cForm).(cName).Caption(k) := aIni[nPos,2]
                        endif
                    Next
                else
                    if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".caption"})) = 0
                         Ini( cChave, cName + ".Caption" , aTemp ,cIni , .T. )
                    else
                        (cForm).(cName).caption := aIni[nPos,2]
                    endif
                endif
            endif
        elseif cType="CHECKLABEL"
            if (nPos:=Ascan(aIni,{|a|a[1]==cName + ".value"})) = 0  
                Ini( cChave, cName  + ".value" , (cForm).(cName).value ,cIni , .T. )
            else
                (cForm).(cName).value := aIni[nPos,2]
            endif
        endif
    Next
    (cForm).Redraw()
    Return Nil
        

