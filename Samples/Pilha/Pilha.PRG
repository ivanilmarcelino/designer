
#include <hmg.ch>
Function Main(  )
    Load window Pilha as Main
        Main.oForm1.Action := {||LoadForm1()}
        Main.oForm2.Action := {||LoadForm2()}
        Main.oForm3.Action := {||LoadForm3()}
    Main.activate()
    REturn .T.
*************************************************
Static function LoadForm1()
    Main.oForm1.Enabled := .F.
    Load window Pesquisa as PForm1
        PForm1.Row:= 316
        PForm1.Col := 78
        PFORM1.oGrid.onDblclick := {||LoadDetail1()}
        PForm1.oGrid.AddItem({"001","Form 1 = Desc 001"})
        PForm1.oGrid.AddItem({"002","Form 1 = Desc 002"})
        PForm1.oGrid.AddItem({"003","Form 1 = Desc 003"})
        
    Load Window Detalhe as PDetail1 
        PDetail1.OnInteractiveClose := {||.F.}
        PDetail1.Row := (PForm1.Row)
        pDetail1.Col := (PForm1.Col)
        
        PForm1.OnRelease := {|| PDetail1.OnInteractiveClose := {||.T.},PDetail1.Release}

    activate window PForm1,pDetail1
    
    //Não pode ter nada entre activate  e Return coloque a linha abaixo no OnRelease de PFOrm1
    Main.oForm1.Enabled := .T.
    Return .T.
*************************************************
Static function LoadDetail1()
    Local aItem := PForm1.oGrid.Item(PForm1.oGrid.Value)
    pDetail1.oCod.Value := aItem[1]
    pDetail1.oDescricao.Value := aItem[2]
    PDetail1.Show()
    Return .T.
*************************************************
Static function LoadForm2()
    Main.oForm2.Enabled := .F.
    Load window Pesquisa as PForm2
    
        PForm2.Row:= 316
        PForm2.Col:= 500
        PFORM2.oGrid.onDblclick := {||LoadDetail2()}
        PForm2.oGrid.AddItem({"001","Form 2 = Desc 001"})
        PForm2.oGrid.AddItem({"002","Form 2 = Desc 002"})
        PForm2.oGrid.AddItem({"003","Form 2 = Desc 003"})
        
    Load Window Detalhe as PDetail2
        PDetail2.OnInteractiveClose := {||.F.}
        PDetail2.Row := (PForm2.Row)
        pDetail2.Col := (PForm2.Col)
        
        PForm2.OnRelease := {||PDetail2.OnInteractiveClose := {||.T.},PDetail2.Release}
        
    activate window PForm2,pDetail2
    
    //Não pode ter nada entre activate  e Return coloque a liinha abaixo no onRelease de PForm2
    Main.oForm2.Enabled := .T.
    Return .T.
*************************************************
Static function LoadDetail2()
    Local aItem := PForm2.oGrid.Item(PForm2.oGrid.Value)
    pDetail2.oCod.Value := aItem[1]
    pDetail2.oDescricao.Value := aItem[2]
    PDetail2.Show()
    Return .T.
*************************************************
Static function LoadForm3()
    Main.oForm3.Enabled := .F.
    Load window Pesquisa as PForm3
        PForm3.Row:= 316
        PForm3.Col:= 950
        PFORM3.oGrid.onDblclick := {||LoadDetail3()}
        PForm3.oGrid.AddItem({"001","Form 3 = Desc 001"})
        PForm3.oGrid.AddItem({"002","Form 3 = Desc 002"})
        PForm3.oGrid.AddItem({"003","Form 3 = Desc 003"})

    Load Window Detalhe as PDetail3 
        PDetail3.OnInteractiveClose := {||.F.}
        PDetail3.Row := (PForm3.Row)
        pDetail3.Col := (PForm3.Col)
        
        PForm3.OnRelease := {||PDetail3.OnInteractiveClose := {||.T.},PDetail3.Release}
    
    activate window PForm3,pDetail3
    
    //Não pode ter nada entre activate  e Return, coloque a linha abaixo no onRelease de Pform3
    Main.oForm3.Enabled := .T.
    Return .T.
*************************************************
Static function LoadDetail3()
    Local aItem := PForm3.oGrid.Item(PForm3.oGrid.Value)
    pDetail3.oCod.Value := aItem[1]
    pDetail3.oDescricao.Value := aItem[2]
    pDetail3.Show()
    Return .T.
*************************************************
