/// 病案号发放统计
Class web.DHCWMRNoSta Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

/// 统计病案号发放情况
Query StaMRNOAssgin(MrType As %String, FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "Ctloc:%String:部门,User:%String:用户,Number:%String:数量")
{
}

ClassMethod StaMRNOAssginExecute(ByRef qHandle As %Binary, MrType As %String, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)	
	q:(FromDate="")!(ToDate="") $$$OK
	
	q:MrType="" $$$OK
	//^DHCWMRNO(0,"AssignDate",{AssignDate},{MrType_Dr},{Rowid})
	f tmpDate=FromDate:1:ToDate  d
	.s rowid="" f  s rowid=$o(^DHCWMRNO(0,"AssignDate",tmpDate,MrType,rowid)) q:rowid=""  d
	..s NoData=$g(^DHCWMRNO(rowid))
	..s userID=$p(NoData,"^",5)
	..s user=$g(^SSU("SSUSR",userID))
	..s locID=$p(user,"^",4)
	..q:locID=""
	..q:userID=""
	..s ^CacheTemp("StaMRNOAssginExecute",$j,locID,userID)=+$g(^CacheTemp("StaMRNOAssginExecute",$j,locID,userID))+1

	s cnt=0
	s locCnt=0
	s locID="" f  s locID=$o(^CacheTemp("StaMRNOAssginExecute",$j,locID)) q:locID=""  d
	.s locCnt=0
	.s loc=$g(^CTLOC(locID))
	.q:loc=""
	.s locDesc=$p(loc,"^",2)
	.s userID="" f  s userID=$o(^CacheTemp("StaMRNOAssginExecute",$j,locID,userID)) q:userID=""  d
	..s user=$g(^SSU("SSUSR",userID))
	..q:user=""
	..s num=+$g(^CacheTemp("StaMRNOAssginExecute",$j,locID,userID))
	..s data=$lb("")
	..s $li(data,1)=locDesc
	..s $li(data,2)=$p(user,"^",1)_" "_$p(user,"^",2)
	..s $li(data,3)=num
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	..s locCnt=locCnt+num
	..s cnt=cnt+num
	.s data=$lb("")
	.s $li(data,1)=locDesc
	.s $li(data,2)="合计"
	.s $li(data,3)=locCnt
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	.s data=$lb("")
	.s $li(data,1)=""
	.s $li(data,2)=""
	.s $li(data,3)=""
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	s data=$lb("")
	s $li(data,1)="总计"
	s $li(data,2)=""
	s $li(data,3)=cnt
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod StaMRNOAssginClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaMRNOAssginExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^CacheTemp("StaMRNOAssginExecute",$j)
 	Quit $$$OK
}

ClassMethod StaMRNOAssginFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaMRNOAssginExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// w ##class(web.DHCWMRNoSta).Test()
ClassMethod Test()
{
	k ^CacheTemp
	d ##Class(%ResultSet).RunQuery("web.DHCWMRNoSta","StaMRNOAssgin","7","2008-08-31","2009-08-31")
	q ""
}

}
