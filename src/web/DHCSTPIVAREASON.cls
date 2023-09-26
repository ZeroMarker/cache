Import SQLUser

Class web.DHCSTPIVAREASON Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetReasonExecute(ByRef qHandle As %Binary, type, code = "", desc = "", set) As %Status
{
	//获取配液拒发原因
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	s rowid=0
    f  s rowid=$o(^PIVAOR(rowid)) q:rowid=""  d
    .s reasoncode=$p(^PIVAOR(rowid),"^",1)
    .q:(code'="")&&(reasoncode'[code)
    .s reasondesc=$p(^PIVAOR(rowid),"^",2)
    .q:(desc'="")&&(reasondesc'[desc)
    .s ctype=$p(^PIVAOR(rowid),"^",3)
    .q:(type'="")&(type'=ctype)
    .i ctype="C" s ctype="取消"
    .i ctype="R" s ctype="拒绝"
    .i ctype="P" s ctype="审核拒绝"
    .s useflag=$p(^PIVAOR(rowid),"^",4)
	.d OutPutRow
	Quit $$$OK
	
OutPutRow
	set Data=$lb(reasoncode,reasondesc,ctype,useflag,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod GetReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReasonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetReason(type, code = "", desc = "", set = "") As %Query(ROWSPEC = "Tcode:%String,Tdesc:%String,Ttype:%String,Tflag:%String,Trowid:%String")
{
}

ClassMethod GetReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCSTPIVAREASON).Update(1,1,"C","N",2,"100000002")
ClassMethod Update(code, desc, type, set, flag, rowid) As %String
{
 n (code,desc,type,set,flag,rowid)
 s existflag=""
 s reasonid=""
 f  s reasonid=$o(^PIVAOR(0,"TYPE",type,reasonid)) q:(reasonid="")||(existflag'="")  d
 .q:+reasonid=0
 .q:(rowid'="")&&(rowid=reasonid)
 .s reasondesc=$p(^PIVAOR(reasonid),"^",2)
 .s reasoncode=$p(^PIVAOR(reasonid),"^",1)
 .i reasondesc=desc s existflag=-12
 .i reasoncode=code s existflag=-11
 q:existflag'="" existflag
 k PLIST
 s rowid=rowid
 s PLIST(1)=""
 s PLIST(2)=code
 s PLIST(3)=desc
 s PLIST(4)=type
 s PLIST(5)=set
 ;i flag=1 &sql(insert into  PIVA_OperReason values PLIST())
 i flag=1 &sql(insert into  PIVA_OperReason (POR_Code,POR_Desc,POR_Type,POR_Flag)values (:code,:desc,:type,:set))
 i flag=2 &sql(update  PIVA_OperReason set POR_Code=:code,POR_Desc=:desc,POR_Type=:type,POR_Flag=:set where POR_RowId=:rowid)
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
}

ClassMethod Delete(rowid) As %String
{
 n (rowid)
 &sql(delete  from  PIVA_OperReason where POR_RowId=:rowid)
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
 q
}

}
