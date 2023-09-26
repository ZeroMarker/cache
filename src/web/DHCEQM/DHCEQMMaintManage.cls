Class web.DHCEQM.DHCEQMMaintManage Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintManage","GetFaultCase","","","","显示器")
/// modified by czf 406455 增加TRow并输出
Query GetFaultCase(FaultCaseDR, FaultCase, No As %String = "", Name As %String = "") As %Query(ROWSPEC = "TFaultCaseDR:%String,TFaultCase:%String,TDescribe:%String,TRow:%String")
{
}

ClassMethod GetFaultCaseExecute(ByRef qHandle As %Binary, FaultCaseDR, FaultCase, No As %String = "", Name As %String = "") As %Status
{
 new repid, index,rowid
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 s index=1
 s rowid=0
 s TRow=1
 ;s ^DHCEQMozy("GetFaultCaseExecute")=No_"^"_Name
 d BuildDataGetFaultCase
 Quit $$$OK
BuildDataGetFaultCase
 f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultCase",rowid))  quit:rowid=""  d
 .d ResetVariablesGetFaultCase
 .q:$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",4)="Y"  //add by wy 2018-2-12 过滤无效的故障现象
 .s TFaultCaseDR = rowid
 .q:(FaultCaseDR'="")&&(TFaultCaseDR'=FaultCaseDR)
 .s TFaultCase = $p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",2)
 .q:(FaultCase'="")&&(TFaultCase'[FaultCase)
 .s TDescribe = $p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",3)
 .s flag=0
 .s mrowid=0
 .f  s mrowid=$o(^DHCEQMMaintRequest(mrowid)) Quit:(mrowid="")||(flag'=0)  d
 ..;web.DHCEQM.DHCEQMMaintRequest.GetOneMaintRequest"))
 ..s (TNo,TName)=""
 ..s result=^DHCEQMMaintRequest(mrowid)
 ..s SourceTypeDR=$p(result,"^",63)
 ..q:$p(result,"^",10)'=rowid
 ..i $p(result,"^",5)'=""  d
 ...i SourceTypeDR=1  d	//设备名称
 ....s EQRowID=$Piece($Get(^DHCEQMExObj($p(result,"^",5))),"^",5)
 ....s TName=$Piece($Get(^DHCEQEquip(EQRowID)),"^",1)
 ....s TNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",71)
 ....s TFileNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",85)
 ...Else  If (SourceTypeDR=2) d //add by zx 2016-06-15 begin
 ....s TName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",5))),"^",1)
 ....s TNo=""
 ....s TFileNo=""  //add by zx 2016-06-15 end
 ...e  d  
 ....s TName=$Piece($Get(^DHCEQMExObj($p(result,"^",5))),"^",1)
 ....s TNo=$Piece($Get(^DHCEQMExObj($p(result,"^",5))),"^",2)
 ....s TFileNo=""
 ...q:(No'="")&(TNo'[No)&&(TFileNo'[No)
 ...q:(Name'="")&(TName'[Name)
 ...s flag=1
 .q:flag=0
 .d OutputRowGetFaultCase
 quit
OutputRowGetFaultCase
 s Data=$lb(TFaultCaseDR,TFaultCase,TDescribe,TRow)
 Set ^CacheTemp(repid,index)=Data
 Set index=index+1
 Set TRow=TRow+1
 quit
ResetVariablesGetFaultCase
 s (TFaultCaseDR,TFaultCase,TDescribe)=""
 quit
}

ClassMethod GetFaultCaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultCaseExecute ]
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

ClassMethod GetFaultCaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultCaseExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/*
/// 修改 by GR0005 2014-09-02 添加条件“MR_DealMethodDR!=null”防止空数据的出现
Query GetDealMethod(FaultCaseDR, FaultReasonDR) As %SQLQuery(ROWSPEC = "TDealMethodDR:%String,TDealMethod:%String,TDescribe:%String")
{
SELECT distinct MR_DealMethodDR TDealMethodDR,
	   MR_DealMethodDR->DM_Desc TDealMethod,
	   MR_DealMethodDR->DM_Remark TDescrible 	   
FROM sqluser.DHC_EQMMaintRequest
where MR_FaultReasonDR=:FaultReasonDR and  MR_Status='2' and MR_DealMethodDR is not null
}

/// 修改 by GR0005 2014-09-02 添加条件“MR_FaultReasonDR!=null”防止空数据的出现
Query GetFaultReason(FaultCaseDR) As %SQLQuery(ROWSPEC = "TFaultReasonDR:%String,TFaultReason:%String,TDescribe:%String")
{
SELECT distinct MR_FaultReasonDR TFaultReasonDR,
	   MR_FaultReasonDR->FR_Desc TFaultReason,
	   MR_FaultReasonDR->FR_Remark TDescrible 	   
FROM sqluser.DHC_EQMMaintRequest
where MR_FaultCaseDR=:FaultCaseDR and  MR_Status='2' and MR_FaultReasonDR is not null
}
*/
/// add by czf 406455
/// 根据故障现象DR和故障原因DR取得不重复的故障解决方法
/// 入参：FaultCaseDR, FaultReasonDR
Query GetDealMethod(FaultCaseDR, FaultReasonDR) As %Query(ROWSPEC = "TDealMethodDR:%String,TDealMethod:%String,TDescribe:%String,TRow:%String")
{
}

ClassMethod GetDealMethodExecute(ByRef qHandle As %Binary, FaultCaseDR, FaultReasonDR) As %Status
{
	new repid, index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s rowid=0
 	s TRow=1
 	i FaultCaseDR=""||FaultReasonDR="" Quit $$$OK
 	
 	d BuildDataGetDealMethod
 	Quit $$$OK
BuildDataGetDealMethod
	s rowid=""
 	f  s rowid=$o(^DHCEQCCode("DHCEQMCDealMethod",rowid))  quit:rowid=""  d
 	.d ResetVariablesGetDealMethod
 	.s TDealMethod = $p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",2)
 	.s TDescribe = $p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",3)
 	.s flag=1
 	.s mrowid=0
 	.f  s mrowid=$o(^DHCEQMMaintRequest(mrowid)) Quit:(mrowid="")||(flag'=1)  d
 	..s TFaultCaseDR=$p($g(^DHCEQMMaintRequest(mrowid)),"^",10)
 	..q:TFaultCaseDR'=FaultCaseDR
 	..s TFaultReasonDR=$p($g(^DHCEQMMaintRequest(mrowid)),"^",12)
 	..q:TFaultReasonDR'=FaultReasonDR
 	..s TDealMethodDR=$p($g(^DHCEQMMaintRequest(mrowid)),"^",14)
 	..q:TDealMethodDR'=rowid
 	..i (TDealMethodDR=rowid) s flag=0
 	..d OutputRowGetDealMethod
 	quit
OutputRowGetDealMethod
 	s Data=$lb(TDealMethodDR,TDealMethod,TDescribe,TRow)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
 	Set TRow=TRow+1
 	quit
ResetVariablesGetDealMethod
 	s (TDealMethod,TDescribe,TFaultReasonDR,TFaultCaseDR)=""
 	quit
}

ClassMethod GetDealMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultCaseExecute ]
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

ClassMethod GetDealMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultCaseExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// add by czf 406455
/// 根据故障现象DR取得不重复的故障原因
/// 入参：FaultCaseDR
Query GetFaultReason(FaultCaseDR) As %Query(ROWSPEC = "TFaultReasonDR:%String,TFaultReason:%String,TDescribe:%String,TRow:%String")
{
}

ClassMethod GetFaultReasonExecute(ByRef qHandle As %Binary, FaultCaseDR) As %Status
{
	new repid, index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s rowid=0
 	s TRow=1
 	i FaultCaseDR="" Quit $$$OK
 	
 	d BuildDataGetFaultReason
 	Quit $$$OK
BuildDataGetFaultReason
	s rowid=""
 	f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultReason",rowid))  quit:rowid=""  d
 	.d ResetVariablesGetFaultReason
 	.s TFaultReason = $p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",2)
 	.s TDescribe = $p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",3)
 	.s flag=1
 	.s mrowid=0
 	.f  s mrowid=$o(^DHCEQMMaintRequest(mrowid)) Quit:(mrowid="")||(flag'=1)  d
 	..s TFaultCaseDR=$p($g(^DHCEQMMaintRequest(mrowid)),"^",10)
 	..q:TFaultCaseDR'=FaultCaseDR
 	..s TFaultReasonDR=$p($g(^DHCEQMMaintRequest(mrowid)),"^",12)
 	..q:TFaultReasonDR'=rowid
 	..i (TFaultReasonDR=rowid) s flag=0
 	..d OutputRowGetFaultReason
 	quit
OutputRowGetFaultReason
 	s Data=$lb(TFaultReasonDR,TFaultReason,TDescribe,TRow)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
 	s TRow=TRow+1
 	quit
ResetVariablesGetFaultReason
 	s (TFaultReason,TDescribe,TFaultReasonDR)=""
 	quit
}

ClassMethod GetFaultReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultCaseExecute ]
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

ClassMethod GetFaultReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultCaseExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Storage Default
{
<Data name="DHCEQMMaintManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQM.DHCEQMMaintManageD</DataLocation>
<DefaultData>DHCEQMMaintManageDefaultData</DefaultData>
<IdLocation>^web.DHCEQM.DHCEQMMaintManageD</IdLocation>
<IndexLocation>^web.DHCEQM.DHCEQMMaintManageI</IndexLocation>
<StreamLocation>^web.DHCEQM.DHCEQMMaintManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
