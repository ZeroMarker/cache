Import SQLUser

Class web.DHCANCDeptOrcOperation Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindOrcOperation(operCategId As %String = "", operDesc As %String = "") As %Query(ROWSPEC = "tOperDesc:%String,tOperId:%String,tDept:%String,tDeptId:%String,tOperAlias:%String,tOperCode:%String")
{
}

ClassMethod FindOrcOperationExecute(ByRef qHandle As %Binary, operCategId As %String = "", operDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s tOperId=0,i=0
	s deptId=%session.Data("LOGON.CTLOCID")
    if (operDesc'="")
    {
		s operDescAlias=$$ALPHAUP^SSUTIL4(operDesc)
		s flag="N"
		s curOperDesc=$O(^ORC("OPER",0,"ALIAS",operDescAlias),-1)
	    if operDescAlias'="" d
	    	.f  s curOperDesc=$O(^ORC("OPER",0,"ALIAS",curOperDesc)) q:(curOperDesc="")!(flag="Y")  d
	    		..i $p(curOperDesc,operDescAlias)'="" s flag="Y" q
	    		..s tOperId=""
	    		..f  s tOperId=$O(^ORC("OPER",0,"ALIAS",curOperDesc,tOperId)) q:tOperId=""  d
	    			...s tOperDesc=$p($g(^ORC("OPER",tOperId)),"^",2)
	    			...s tOperCategId=$p($g(^ORC("OPER",tOperId)),"^",7)
	    			...q:(operCategId'="")&(operCategId'=tOperCategId)
	    			...s idStr=$p($g(^ORC("OPER",tOperId,"DHC")),"^",6)
	    			...q:idStr'[deptId
	    			...s i=i+1
	    			...d SetData
    }
    if i>0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	f  s tOperId=$o(^ORC("OPER",tOperId)) q:tOperId=""  d
	.s tOperDesc=$p($g(^ORC("OPER",tOperId)),"^",2)
	.q:(operDesc'="")&(tOperDesc'[operDesc)
	.s tOperCategId=$p($g(^ORC("OPER",tOperId)),"^",7)
	.q:(operCategId'="")&(operCategId'=tOperCategId)
	.s idStr=$p($g(^ORC("OPER",tOperId,"DHC")),"^",6)
	.q:idStr'[deptId
 	.d SetData	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetData
    s idStr=$p($g(^ORC("OPER",tOperId,"DHC")),"^",6)
    s descStr=""
	s n=$l(idStr,"|")
	f i=1:1:n d
	.s id=$p(idStr,"|",i)
	.q:id=""
	.s desc=$P(^CTLOC(id),"^",2)
	.i descStr="" s descStr=desc
	.e  s descStr=descStr_","_desc
	s tDept=descStr
	s tDeptId=idStr
	s sub=0,tOperAlias=""
	f  s sub=$o(^ORC("OPER",tOperId,"ALIAS",sub)) q:sub=""  d
	.i tOperAlias="" s tOperAlias=^ORC("OPER",tOperId,"ALIAS",sub)
	.e  s tOperAlias=tOperAlias_","_^ORC("OPER",tOperId,"ALIAS",sub)
	s tOperCode=$p($g(^ORC("OPER",tOperId)),"^",1)
    Do OutputRow1
    q

OutputRow1
	set Data=$lb(tOperDesc,tOperId,tDept,tDeptId,tOperAlias,tOperCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrcOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcOperationExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrcOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindOperation(operDesc As %String = "") As %Query(ROWSPEC = "tOperId:%String,tOperDesc:%String")
{
}

ClassMethod FindOperationExecute(ByRef qHandle As %Binary, operDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s tOperId=0,i=0
	s deptId=%session.Data("LOGON.CTLOCID")
    if (operDesc'="")
    {
		s operDescAlias=$$ALPHAUP^SSUTIL4(operDesc)
		s flag="N"
		s curOperDesc=$O(^ORC("OPER",0,"ALIAS",operDescAlias),-1)
	    if operDescAlias'="" d
	    	.f  s curOperDesc=$O(^ORC("OPER",0,"ALIAS",curOperDesc)) q:(curOperDesc="")!(flag="Y")  d
	    		..i $p(curOperDesc,operDescAlias)'="" s flag="Y" q
	    		..s tOperId=""
	    		..f  s tOperId=$O(^ORC("OPER",0,"ALIAS",curOperDesc,tOperId)) q:tOperId=""  d
	    			...s tOperDesc=$p(^ORC("OPER",tOperId),"^",2)
	    			...s tOperCategId=$p(^ORC("OPER",tOperId),"^",7)
	    			...;q:(operCategId'="")&(operCategId'=tOperCategId)
	    			...s i=i+1
	    			...d OutputRow2
    }
    if i>0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	f  s tOperId=$o(^ORC("OPER",tOperId)) q:tOperId=""  d
	.s tOperDesc=$p(^ORC("OPER",tOperId),"^",2)
	.q:(operDesc'="")&(tOperDesc'[operDesc)
	.s tOperCategId=$p(^ORC("OPER",tOperId),"^",7)
	.;q:(operCategId'="")&(operCategId'=tOperCategId)
 	.d OutputRow2	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(tOperId,tOperDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveDHCOrcOperation(operId) As %String
{
   q:operId="" "请选择手术"
    s deptId=%session.Data("LOGON.CTLOCID")
    s str=""
    s str=$p($g(^ORC("OPER",operId,"DHC")),"^",6)
    i str'[deptId d
    .i str="" s $p(^ORC("OPER",operId,"DHC"),"^",6)=deptId
	.e  s $p(^ORC("OPER",operId,"DHC"),"^",6)=str_"|"_deptId
	q 0
}

ClassMethod AddDefOperation(defOpAlias, defOperation) As %String
{
    q:defOpAlias="" "手术别名为空"
    q:defOperation="" "手术名称为空"
    s qFlag=0,ifDef=""
    s opId=0
    f  s opId=$o(^ORC("OPER",opId)) q:opId=""  d
    .s desc=$p(^ORC("OPER",opId),"^",2)
    .s code=$p(^ORC("OPER",opId),"^",1)
    .s ifDef=$e(code,1,7)
    .i (desc=defOperation)&(ifDef="USERDEF") s qFlag=1
    .e  i desc=defOperation s qFlag=2
    q:qFlag=1 "和自定义手术名称重复"
    q:qFlag=2 "和ICD手术名称重复"
    s deptId=%session.Data("LOGON.CTLOCID")
    //TSTART 
    k PLIST 
    s code=""
    s curDesc=$o(^ORC("OPER",0,"Code","USERDEFA"),-1)
    s num=$Extract(curDesc,8,13)+1
    s n=6-$l(num)
    s str0=""
    f i=1:1:n d
    .s str0=str0_"0"
    s code="USERDEF"_str0_num
    s PLIST(2)=code
    s PLIST(3)=defOperation
    &sql(INSERT INTO SQLUser.ORC_Operation VALUES :PLIST())
    s operId=$g(%ROWID)
    k PLIST 
    s PLIST(0)=operId,PLIST(3)=defOpAlias
    &sql(INSERT INTO SQLUser.ORC_OperationAlias VALUES :PLIST())
    //i SQLCODE'=0 TROLLBACK
    q:SQLCODE'=0 "插入手术表错误"
    s str=""
    s str=$p($g(^ORC("OPER",operId,"DHC")),"^",6)
    i str'[deptId d
    .i str="" s $p(^ORC("OPER",operId,"DHC"),"^",6)=deptId
	.e  s $p(^ORC("OPER",operId,"DHC"),"^",6)=str_"|"_deptId
	q 0
}

ClassMethod DeleteDHCOrcOperation(operId) As %String
{
   
    s str=""
    s deptId=%session.Data("LOGON.CTLOCID")
    //s deptId=1
    s stra=$p($g(^ORC("OPER",operId,"DHC")),"^",6)
    s n=$l(stra,"|")
    f i=1:1:n d
    .s id=$p(stra,"|",i)
    .q:id=deptId
    .i str="" s str=id
    .e  s str=str_"|"_id
	//k ^ORC("OPER",operId,"DHC")
	s $p(^ORC("OPER",operId,"DHC"),"^",6)=str
	q 0
}

ClassMethod UpdateDefOrcOperation(operId, defOperation, defOpAlias) As %String
{
  
   s ret=0
   s code=$p(^ORC("OPER",operId),"^",1)
   s ifDef=$e(code,1,7)
   q:ifDef'="USERDEF" "只能修改自定义手术"
   i defOperation'="" d
	.&sql(update SQLUser.ORC_Operation set OPER_Desc=:defOperation where OPER_RowId=:operId)
	q:SQLCODE'=0 "更新手术表失败"
	i defOpAlias'=""  d
	.&sql(update SQLUser.ORC_OperationAlias set  ALIAS_Text=:defOpAlias where ALIAS_ParRef=:operId)
	i SQLCODE'=0 s ret="更新手术别名失败"
	q:ret
}

ClassMethod GetIfDefOper(operId) As %String
{
 
  s ret=0
  s code=$p(^ORC("OPER",operId),"^",1)
  s ifDef=$e(code,1,7)
  i ifDef="USERDEF" s ret=1
  q ret
}

}
