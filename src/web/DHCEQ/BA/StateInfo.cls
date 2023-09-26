Class web.DHCEQ.BA.StateInfo Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// add by czf 2021-09-20
/// 设备运行情况查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.StateInfo","EQStateInfo","1","2021-01","2021-10")
Query EQStateInfo(EquipDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TRecordDate:%String,TStartDate:%String,TEndDate:%String,TTotalTime:%String,TUseContent:%String,TStartState:%String,TStartStateInfo:%String,TEndState:%String,TEndStateInfo:%String,TUser:%String")
{
}

ClassMethod EQStateInfoExecute(ByRef qHandle As %Binary, EquipDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
 	i (EquipDR="") Quit $$$OK
 	i StartMonth'="" Set PStartDate=$zdh(StartMonth_"-01",3)
 	e  s PStartDate=0
 	i EndMonth'="" Set PEndDate=##Class(web.DHCEQCommon).DateAddInt("M",1,$zdh(EndMonth_"-01",3))-1
	e  s PEndDate=+$h
	
	s SIRowID=""
	f  s SIRowID=$o(^DHCEQStateInfo(0,"Equip","N",0,EquipDR,SIRowID)) quit:SIRowID=""  d
	.d ResetVariablesEQStateInfo
	.s TRowID=SIRowID
	.s TType=##Class(web.DHCEQStateInfo).GetTypeDisplay($p($g(^DHCEQStateInfo(TRowID)),"^",1))		//运行
	.s TRecordDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(TRowID)),"^",3),"date")	//登记日期
	.s TStartDate=$p($g(^DHCEQStateInfo(TRowID)),"^",4)	
	.q:(PStartDate'="")&&(TStartDate<PStartDate)
	.s TEndDate=$p($g(^DHCEQStateInfo(TRowID)),"^",6)
	.q:(PEndDate'="")&&(TEndDate>PEndDate)
	.;q:$p($g(^DHCEQStateInfo(TRowID)),"^",17)'=2
	.s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")	//开机日期
	.s TStartTime=$ZTIME($p($g(^DHCEQStateInfo(TRowID)),"^",5),1)	//开机时间
	.s TEndDate=##class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")	//关机日期
	.s TEndTime=$ZTIME($p($g(^DHCEQStateInfo(TRowID)),"^",7),1)	//关机时间
	.s TStartDate=TStartDate_" "_TStartTime
	.s TEndDate=TEndDate_" "_TEndTime
	.s TTotalTime=$p($g(^DHCEQStateInfo(TRowID)),"^",8)
	.s TUseContent=$p($g(^DHCEQStateInfo(TRowID)),"^",9)		//使用内容
	.s TStartState=$p($g(^DHCEQStateInfo(TRowID)),"^",10)		//设备开始状况
	.s TStartStateInfo=$p($g(^DHCEQStateInfo(TRowID)),"^",11)
	.i TStartStateInfo="" s TStartStateInfo=TStartState
	.s TEndState=$p($g(^DHCEQStateInfo(TRowID)),"^",12)
	.s TEndStateInfo=$p($g(^DHCEQStateInfo(TRowID)),"^",13)		//设备状况
	.i TEndStateInfo="" s TEndStateInfo=TEndState
	.s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQStateInfo(TRowID)),"^",14))	//使用人
	.d OutputRowEQStateInfo
	
	Quit $$$OK
OutputRowEQStateInfo
	Set Data=$lb(TRowID,TType,TRecordDate,TStartDate,TEndDate,TTotalTime,TUseContent,TStartState,TStartStateInfo,TEndState,TEndStateInfo,TUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEQStateInfo
	Set (TRowID,TType,TRecordDate,TStartDate,TStartTime,TEndDate,TEndTime,TTotalTime,TUseContent,TStartState,TStartStateInfo,TEndState,TEndStateInfo,TUser)=""
	quit
}

ClassMethod EQStateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQStateInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod EQStateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQStateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
