Class web.DHCEQ.Interface.DHCEQToPlat Extends %RegisteredObject
{

/// Creator：czf 2023-04-19
/// Descriptions：获取转移单记录
/// Input:
/// 		StartDate：审批开始日期 yyyy-mm-dd
/// 		EndDate：审批结束日期 yyyy-mm-dd
/// Output:
/// 		TStoreMoveNo:转移单号,TStoreMoveInfo:转移设备明细,TEquipType:管理类组,TMakeDate:制单日期,TMoveType:转移类型,TFromLoc:供给科室,TToLoc:接受科室,TAuditDate:审批时间
/// Command：d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.DHCEQToPlat","GetStoreMove","","")
Query GetStoreMove(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TStoreMoveNo:%String,TStoreMoveInfo:%String,TEquipType:%String,TMakeDate:%String,TMoveType:%String,TFromLoc:%String,TToLoc:%String,TAuditDate:%String")
{
}

ClassMethod GetStoreMoveExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
 	//new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 		
 	i StartDate="" s StartDate=0
 	e  s StartDate=$zdh(StartDate,3)
 	i EndDate=""  s EndDate=+$H
 	e  s EndDate=$zdh(EndDate,3)
 	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
 	
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQStoreMove(rowid))  quit:rowid=""  d
	.d ResetVariablesGetStoreMove
	.q:$p($g(^DHCEQStoreMove(rowid)),"^",13)'=2
	.s TAuditDate=$p($g(^DHCEQStoreMove(rowid)),"^",10)
	.q:(+TAuditDate>EndDate)||(+TAuditDate<StartDate)
	.s TAuditDate=$zd(TAuditDate,3)
	.s SMFlag=$p($g(^DHCEQStoreMove(rowid)),"^",27)
	.q:SMFlag="Y"
	.s TStoreMoveNo = $p($g(^DHCEQStoreMove(rowid)),"^",1)
	.s TEquipTypeDR=$p($g(^DHCEQStoreMove(rowid)),"^",16)
	.s TFromLocDR = $p($g(^DHCEQStoreMove(rowid)),"^",2)
	.s TToLocDR = $p($g(^DHCEQStoreMove(rowid)),"^",3)	
	.s TMoveType = $p($g(^DHCEQStoreMove(rowid)),"^",12)
	.s TEquipType = ##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	.s TFromLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLocDR)
	.s TToLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLocDR)
	.s TMakeDate = $p($g(^DHCEQStoreMove(rowid)),"^",5)
	.i TMakeDate'="" s TMakeDate = $zd(TMakeDate,3)
	.s TMoveType = $CASE(TMoveType,"0":"库房分配","1":"科室调配","2":"转报废库","3":"科室退库","4":"库房调配",:"没有定义") //modify by wl 2020-03-13 WL0062
	.s TStoreMoveInfo=""
	.s SMLRowID = 0
	.f  s SMLRowID = $o(^DHCEQStoreMoveList(0,"StoreMove",rowid,SMLRowID)) q:SMLRowID=""  d
	..s TName = $p($g(^DHCEQStoreMoveList(SMLRowID)),"^", 5)
	..s TNum = $p($g(^DHCEQStoreMoveList(SMLRowID)),"^", 8)
	..s TUnitDR = $p($g(^DHCEQStoreMoveList(SMLRowID)),"^", 10)
	..s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom", TUnitDR)
	..i TUnit="" s TUnit="台"
	..i TStoreMoveInfo'="" s TStoreMoveInfo=TStoreMoveInfo_";"
	..s TStoreMoveInfo=TStoreMoveInfo_TNum_TUnit_TName
	.d OutputRowGetStoreMove
	Quit $$$OK
OutputRowGetStoreMove
	s Data=$lb(TStoreMoveNo,TStoreMoveInfo,TEquipType,TMakeDate,TMoveType,TFromLoc,TToLoc,TAuditDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMove
	s (TStoreMoveNo,TStoreMoveInfo,TEquipType,TMakeDate,TMoveType,TFromLoc,TToLoc,TAuditDate)=""
	quit
}

ClassMethod GetStoreMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveExecute ]
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

ClassMethod GetStoreMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
