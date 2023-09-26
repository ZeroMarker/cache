Class web.DHCREAGTrace Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

ClassMethod QryTraceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTraceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTraceExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, ReagCode As %String, UserCode As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s ReagCode=$g(ReagCode)
 	s UserCode=$g(UserCode)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGTraceI("DateIndex","D01",61867,203,51827,140)=
    //Index DateIndex On (DepartmentDR, TransDate, ReagentDR, TransTime);
	k ^TMP($zn,$j)
	f Date=DateFrom:1:DateTo d
	.i $l(ReagCode) d  //指定试剂
	..s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(ReagCode)
	..s ^TMP($zn,$j,"reag",ReagCode)=ReagStr
	..s Time="" f  s Time=$o(^lab.DHCREAGTraceI("DateIndex",Depart,Date,ReagCode,Time),-1) q:Time=""  d
	...s id="" f  s id=$o(^lab.DHCREAGTraceI("DateIndex",Depart,Date,ReagCode,Time,id)) q:id=""  d
	....s user=$li(^lab.DHCREAGTraceD(id),7)
	....i $l(UserCode),UserCode'=user q
	....s ^TMP($zn,$j,"data",Date,Time,id)=ReagCode
	.e  d
	..s reag="" f  s reag=$o(^lab.DHCREAGTraceI("DateIndex",Depart,Date,reag)) q:reag=""  d
	...s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(reag)
	...i $l(reag) s ^TMP($zn,$j,"reag",reag)=ReagStr
	...s Time="" f  s Time=$o(^lab.DHCREAGTraceI("DateIndex",Depart,Date,reag,Time),-1) q:Time=""  d
	....s id="" f  s id=$o(^lab.DHCREAGTraceI("DateIndex",Depart,Date,reag,Time,id)) q:id=""  d
	.....s user=$li(^lab.DHCREAGTraceD(id),7)
	.....i $l(UserCode),UserCode'=user q
	.....s ^TMP($zn,$j,"data",Date,Time,id)=reag
	
	s Date="" f  s Date=$o(^TMP($zn,$j,"data",Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^TMP($zn,$j,"data",Date,Time)) q:Time=""  d
	..s id="" f  s id=$o(^TMP($zn,$j,"data",Date,Time,id)) q:id=""  d
	...s reag=$g(^(id))
	...s ReagStr=$g(^TMP($zn,$j,"reag",reag))
	...s (ReagName,UnitDr,UnitName,PackageDr,PackageName,ManuDr,ManuName,SuppDr,SuppName,Group,GroupDr)=""
	...s PackageVol=1
	...i $l(ReagStr) d
	....s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	....s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	....s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	....s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	....s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	....s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	....s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	....s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	....s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	....s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	....s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	....s PackageVol=+$p(ReagStr,$c(2),27)
	....s VolUnit=$p(ReagStr,$c(2),28)
	...i PackageVol=0 s PackageVol=1
	...s TraceStr=$g(^lab.DHCREAGTraceD(id))
	...i '$l(TraceStr) q
	...//<<$LB("","D01","61878","203","42253","O3","demo","No0004","2","BF2010060002","5")>>
	...s Type=$li(TraceStr,6)
	...s OpUserDr=$li(TraceStr,7)
	...s LotNo=$li(TraceStr,8)
	...///
	...s TransNo=$li(TraceStr,10)
	...s OpTypeDr=$li(TraceStr,11)
	...//
	...i OpTypeDr=8 d
	....s Quan=+$li(TraceStr,9)
	....s UnitName=VolUnit
	....i Quan<1,Quan>0 s Quan="0"_Quan
	....s Quan=$fn(Quan,"",3)
	...e  d  
	....s Quan=+$fn($li(TraceStr,9)/PackageVol,"",3)
	....i Quan<1,Quan>0 s Quan="0"_Quan
	....s Quan=$fn(Quan,"",2)
	...//
	...s TypName=Type
	...s OpUserName=""
	...i $l(OpUserDr),$d(^lab.DHCCTUserD(OpUserDr)) s OpUserName=$li(^lab.DHCCTUserD(OpUserDr),3)
	...s OpTypeName=""
	...i $l(OpTypeDr),$d(^lab.DHCCTOperateTypeD(OpTypeDr)) s OpTypeName=$li(^lab.DHCCTOperateTypeD(OpTypeDr),3)
	...s TrDate=$zd(Date,3)
	...s TrTime=$zt(Time)
	...d OutputCheck			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheck
	set Data=$lb(id,TrDate_" "_TrTime,ReagName,LotNo,Quan,UnitName,PackageName,Group,ManuName,OpTypeName,OpUserName,TransNo,TypName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryTraceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTraceExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100602
/// Description:： 台帐查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryTrace(Depart As %String, DateFrom As %String, DateTo As %String, ReagCode As %String, UserCode As %String) As %Query(ROWSPEC = "TraceID:%String,TraceDT:%String,ReagName:%String,LotNo:%String,Quan:%String,UnitName:%String,PackageName:%String,Group:%String,ManuName:%String,OpTypeName:%String,OpUserName:%String,TransNo:%String,TypName:%String")
{
}

}
