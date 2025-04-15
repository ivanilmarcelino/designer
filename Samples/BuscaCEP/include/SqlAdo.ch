   memvar Connection 
   memvar oFbServer 
   memvar oPgServer 
   memvar oServer 
   memvar oSQL 

   
   
   #xcommand DECLARE CURSOR SQLADO <r> ;
   =>;
   #xtranslate <r> . \<p:Execute\> \[(\<s\>)\] => <r>:\<p\> \[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Open\> (\[\<s\>\]) => (<r>:ReadWrite(.T.) , <r>:Open(\[\<s\>\])) ;;
   #xtranslate <r> . \<p:Seek,DbSeek\> (\<s\>)  => (<r>)->(DbSeek(\<s\>)) ;;
   #xtranslate <r> . \<p:Loadfile,SaveFile\> (\<c\>,\<x\>) => <r>:\<p\>(\<c\>,\<x\>) ;;
   #xtranslate <r> . \<p:Eof,Bof,Close,DbStruct,AddNew,delete,Update,MoveNext,MoveLast,MovePrevious\> \[()\] => <r>:\<p\>() ;;
   #xtranslate <r> . \<p:New\>()  => <r> := Connection:TRecordSet() ;;
   #xtranslate <r> . \<p:Sql\> := \<s\> => <r>:Sql := \<s\> ;;
   #xtranslate <r> . \<p:Sql\> => <r>:Sql ;;
   #xtranslate <r> . \<p:IsOpen\> \[()\] => <r>:IsOpen() ;;
   #xtranslate <r> . \<p:ErrorSQL\> \[(\<s\>)\] => <r>:Error \[(\<s\>)\] ;;
   #xtranslate <r> . field . \<c\>          => <r>:Fields"["\<(c)\>\]:Value\ ;;
   #xtranslate <r> . field . \<c\> := \<n\> => <r>:Fields"["\<"c">\]:Value\ :=  \<n\>;;
   #xtranslate <r> . field . \<c\> . \<p:value\> := \<n\> => <r>:Fields"["\<"c">\]:\<p\>\ :=  \<n\>;;
   #xtranslate <r> . field . \<c\> . \<p:value,name,type\>  => <r>:Fields"["\<"c">\]:\<p\>\ ;;
   #xtranslate <r> . \<p:BeginTrans\> \[()\] => Connection:BeginTrans() ;;
   #xtranslate <r> . \<p:CommitTrans\> \[()\] => Connection:CommitTrans() ;;
   #xtranslate <r> . \<p:RollBackTrans\> \[()\] => Connection:RollBackTrans() ;;

   #xtranslate :Fields\"[" => :Fields\[ 


   #xcommand DECLARE CURSOR FIREBIRD <r> ;
   =>;
   #xtranslate <r> . \<p:New\> \[()\]  => (<r>) ;;
   #xtranslate <r> . \<p:Open\>  \[(\<s\>)\]  => <r> := oFbServer:Query \[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Execute\> \[(\<s\>)\] => oFbServer:Execute\[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Eof,Bof,Close,delete,MoveNext\> \[()\] => <r>:\<p\>() ;;
   #xtranslate <r> . \<p:Loadfile,SaveFile\> (\<c\>,\<x\>) => <r>:Fields:\<p\>(\<c\>,\<x\>) ;;
   #xtranslate <r> . \<p:AddNew\> \[()\] => <r>:GetBlankRow() ;;
   #xtranslate <r> . \<p:Update\> \[()\] => IIF(<r>:Eof(),<r>:Append(),<r>:Update()) ;;
   #xtranslate <r> . \<p:Sql\> := \<s\> => oFbServer:Sql := \<s\> ;;
   #xtranslate <r> . \<p:Sql\> => oFbServer:Sql ;;
   #xtranslate <r> . \<p:IsOpen\> \[()\] => <r>:IsOpen() ;;
   #xtranslate <r> . \<p:ErrorSQL\> \[(\<s\>)\] => oFbServer:ErrorSQL \[(\<s\>)\] ;;
   #xtranslate <r> . field . \<c\>          => <r>:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\>  => <r>:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> := \<n\> => <r>:Fields:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\> := \<n\> => <r>:Fields:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . \<p:BeginTrans\> \[()\] => oFbServer:BeginTrans() ;;
   #xtranslate <r> . \<p:CommitTrans\> \[()\] => oFbServer:CommitTrans() ;;
   #xtranslate <r> . \<p:RollBackTrans\> \[()\] => oFbServer:RollBackTrans() ;;

   #xcommand DECLARE CURSOR POSTGRESQL <r> ;
   =>;
   #xtranslate <r> . \<p:New\> \[()\]  => (<r>) ;;
   #xtranslate <r> . \<p:Open\>  \[(\<s\>)\]  => <r> := oPgServer:Query \[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Execute\> \[(\<s\>)\] => oPgServer:Execute\[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Eof,Bof,Close,delete,MoveNext\> \[()\] => <r>:\<p\>() ;;
   #xtranslate <r> . \<p:Loadfile,SaveFile\> (\<c\>,\<x\>) => <r>:Fields:\<p\>(\<c\>,\<x\>) ;;
   #xtranslate <r> . \<p:AddNew\> \[()\] => <r>:GetBlankRow() ;;
   #xtranslate <r> . \<p:Update\> \[()\] => IIF(<r>:Eof(),<r>:Append(),<r>:Update()) ;;
   #xtranslate <r> . \<p:Sql\> := \<s\> => oPgServer:Sql := \<s\> ;;
   #xtranslate <r> . \<p:Sql\> => oPgServer:Sql ;;
   #xtranslate <r> . \<p:IsOpen\> \[()\] => <r>:IsOpen() ;;
   #xtranslate <r> . \<p:ErrorSQL\> \[(\<s\>)\] => oPgServer:ErrorSQL \[(\<s\>)\] ;;
   #xtranslate <r> . field . \<c\>          => <r>:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\>  => <r>:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> := \<n\> => <r>:Fields:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\> := \<n\> => <r>:Fields:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . \<p:BeginTrans\> \[()\] => oPgServer:BeginTrans() ;;
   #xtranslate <r> . \<p:CommitTrans\> \[()\] => oPgServer:CommitTrans() ;;
   #xtranslate <r> . \<p:RollBackTrans\> \[()\] => oPgServer:RollBackTrans() ;;

   #xcommand DECLARE CURSOR MYSQL <r> ;
   =>;
   #xtranslate <r> . \<p:New\> \[()\]  => (<r>) ;;
   #xtranslate <r> . \<p:Open\>  \[(\<s\>)\]  => <r> := oServer:Query \[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Execute\> \[(\<s\>)\] => oServer:Execute\[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Eof,Bof,Close,DbStruct,delete,MoveNext,MoveLast,MovePrevious\> \[()\] => <r>:\<p\>() ;;
   #xtranslate <r> . \<p:Loadfile,SaveFile\> (\<c\>,\<x\>) => <r>:Fields:\<p\>(\<c\>,\<x\>) ;;
   #xtranslate <r> . \<p:AddNew\> \[()\] => <r>:GetBlankRow() ;;
   #xtranslate <r> . \<p:Update\> \[()\] => IIF(<r>:Eof(),<r>:Append(),<r>:Update()) ;;
   #xtranslate <r> . \<p:Sql\> := \<s\> => oServer:Sql := \<s\> ;;
   #xtranslate <r> . \<p:Sql\> => oServer:Sql ;;
   #xtranslate <r> . \<p:IsOpen\> \[()\] => <r>:IsOpen() ;;
   #xtranslate <r> . \<p:ErrorSQL\> \[(\<s\>)\] => oServer:ErrorSQL \[(\<s\>)\] ;;
   #xtranslate <r> . field . \<c\>          => <r>:Fields:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\>  => <r>:Fields:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> := \<n\> => <r>:Fields:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\> := \<n\> => <r>:Fields:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . \<p:BeginTrans\> \[()\] => oServer:BeginTrans() ;;
   #xtranslate <r> . \<p:CommitTrans\> \[()\] => oServer:CommitTrans() ;;
   #xtranslate <r> . \<p:RollBackTrans\> \[()\] => oServer:RollBackTrans() ;;

   
   #xcommand DECLARE CURSOR SQLITE <r> ;
   =>;
   #xtranslate <r> . \<p:New\> \[()\]  =>  (<r>);;
   #xtranslate <r> . \<p:Open\>  \[(\<s\>)\]  => <r> := oSQL:Prepare \[(\<s\>)\];;
   #xtranslate <r> . \<p:Execute\> \[(\<s\>)\] => oSQL:Execute\[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Eof,Bof,DbStruct,delete,MoveNext,MoveLast,MovePrevious\> \[()\] => <r>:\<p\>() ;;
   #xtranslate <r> . \<p:Loadfile,SaveFile\> (\<c\>,\<x\>) => <r>:\<p\>(\<c\>,\<x\>) ;;
   #xtranslate <r> . \<p:Close\> \[()\] => ;;
   #xtranslate <r> . \<p:AddNew\> \[()\] => <r>:AddNew() ;;
   #xtranslate <r> . \<p:ErrorSQL\> \[(\<s\>)\] => oSQL:OnError \[(\<s\>)\] ;;
   #xtranslate <r> . \<p:Update\> \[()\] => IIF(<r>:Eof(),<r>:PrepareInsert(),<r>:PrepareUpdate()) ;;
   #xtranslate <r> . \<p:Sql\> := \<s\> => oSql:Sql := \<s\> ;;
   #xtranslate <r> . \<p:Sql\> => oSql:Sql  ;;
   #xtranslate <r> . \<p:IsOpen\> \[()\] => <r>:IsOpen() ;;
   #xtranslate <r> . field . \<c\>          => <r>:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\>  => <r>:Fieldget(\<(c)\>) ;;
   #xtranslate <r> . field . \<c\> := \<n\> => <r>:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . field . \<c\> . \<p:value\> := \<n\> => <r>:FieldPut(\<"c">\,\<n\>) ;;
   #xtranslate <r> . \<p:BeginTrans\> \[()\] => oSQL:BeginTrans() ;;
   #xtranslate <r> . \<p:CommitTrans\> \[()\] => oSQL:CommitTrans() ;;
   #xtranslate <r> . \<p:RollBackTrans\> \[()\] => oSQL:RollBackTrans() ;;   
   
   
   #xcommand DECLARE CURSOR DBF <r> ;
   =>;
   #xtranslate <r> . \<p:New\> \[()\]  =>  ;;
   #xtranslate <r> . \<p:Open\> (\<s\> , \[\<a1\>\] , \<a2\> , \<a3\>)  => Dbopen( \<s\>, \<a1\> , \<a2\> , <r> , \<a3\> ) ;;
   #xtranslate <r> . \<p:Seek,DbSeek\> (\<s\>)  => (<r>)->(DbSeek(\<s\>)) ;;
   #xtranslate <r> . \<p:Execute\> \[(\<s\>)\] =>  ;;
   #xtranslate <r> . \<p:dbgobottom,MoveLast\> \[()\] => (<r>)->(DbGoBottom());;
   #xtranslate <r> . \<p:MovePrevious\> \[()\] => (<r>)->(DbSkip(-1));;
   #xtranslate <r> . \<p:MoveNext,DbSkip\> \[()\] => (<r>)->(DbSkip()) ;;
   #xtranslate <r> . \<p:dbgotop,MoveFirst\> \[()\] => (<r>)->(DbGoTop());;
   #xtranslate <r> . \<p:delete\> \[()\] => IIF((<r>)->(Rlock()),((<r>)->(DbDelete()),(<r>)->(DbSkip(-1))),MsgStop("Lock Failure")) ;;
   #xtranslate <r> . \<p:Eof,Bof,DbStruct\> \[()\] => (<r>)->(\<p\>()) ;;
   #xtranslate <r> . \<p:Close\> \[()\] => (<r>)->(DbCloseArea()) ;;
   #xtranslate <r> . \<p:AddNew\> \[()\] => (<r>)->(DbAppend()) ;;
   #xtranslate <r> . \<p:lock\> \[()\] => (<r>)->(Rlock()) ;;
   #xtranslate <r> . \<p:unlock\> \[()\] => (<r>)->(Dbunlock()) ;;
   #xtranslate <r> . \<p:ErrorSQL\>\[()\]  => (!TRUE);;
   #xtranslate <r> . \<p:Update\> \[()\] => (<r>)->(Dbunlock()) ;;
   #xtranslate <r> . \<p:Sql\> =>  ;;
   #xtranslate <r> . \<p:IsOpen\> \[()\] => Select(<r>)>0 ;;
   #xtranslate <r> . field . \<c\>          => (<r>)->\<(c)\> ;;
   #xtranslate <r> . field . \<c\> . \<p:value\>  => (<r>)->\<c\> ;;
   #xtranslate <r> . field . \<c\> := \<n\> => (<r>)->\<c>\ := \<n\> ;;
   #xtranslate <r> . field . \<c\> . \<p:value\> := \<n\> => (<r>)->\<c>\ := \<n\> ;;
   #xtranslate <r> . \<p:BeginTrans\> \[()\] =>  ;;
   #xtranslate <r> . \<p:CommitTrans\> \[()\] =>  ;;
   #xtranslate <r> . \<p:RollBackTrans\> \[()\] =>  ;;   
