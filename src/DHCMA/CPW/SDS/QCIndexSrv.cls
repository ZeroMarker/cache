Class DHCMA.CPW.SDS.QCIndexSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-03-07
/// Description:  查询质控病种指标项
/// Table：       DHCMA.CPW.SDS.QCIndex      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexSrv","QryEntityIndex",4)
Query QryEntityIndex(aParRef As %String, aActive As %String = "") As %Query(ROWSPEC = "RowID:%String,EntityID:%String,BTCode:%String,BTDesc:%String,IsActive:%String,IndexCat:%String,RaqName:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryEntityIndexExecute(ByRef qHandle As %Binary, aParRef As %String, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Set xSubDesc = ""
	Set xSubRowID=""	
	Quit:aParRef="" $$$OK
	k TMPCatMsg
 	For
 	{	
 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCIndexI("IndexParref",aParRef,xSubRowID))
 		Quit:xSubRowID=""
 		Set xRowID = aParRef_"||"_xSubRowID
 		Set (BTCode,BTDesc,BTCalculate,IsActive)=""
 		Set Obj = ##class(DHCMA.CPW.SD.QCIndex).GetObjById(xRowID)
 		Set BTCode          	= Obj.BTCode
 		Set BTDesc         		= Obj.BTDesc
 		Set IsActive			= Obj.IsActive
 		Continue:(aActive'="")&&(aActive'=IsActive)
 		Set IsActive=$s(IsActive=1:"是",1:"否")
 		Set IndexCat			= Obj.BTIndexCat
 		Set RaqName				= Obj.RaqName
 		Set IndNo				= Obj.BTIndNo
		Set TMPCatMsg(BTCode)=$lb(xRowID,aParRef,BTCode,BTDesc,IsActive,IndexCat,RaqName,IndNo)
 	}
 	Set xBTCode=""
 	for {
	 	Set xBTCode=$o(TMPCatMsg(xBTCode))
	 	Quit:xBTCode=""
	 	Set Data=$g(TMPCatMsg(xBTCode))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	 }
 Quit $$$OK
}

ClassMethod QryEntityIndexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEntityIndexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEntityIndexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEntityIndexExecute ]
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

/// 导入病种指标
/// w ##class(DHCMA.CPW.SDS.QCIndexSrv).ImportSDIndex("WS004^^CAP-0.1^填报医生统计^一般信息^CAP-0.1.raq^1^1")
ClassMethod ImportSDIndex(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return		
	Set SDCode		= $p(aInputStr,aSeparete,1)
	Set QCEntity=##class(DHCMA.CPW.SD.QCEntity).GetObjByCode(SDCode)
	Quit:'$IsObject(QCEntity) return
	Set QCEntityID=QCEntity.%Id()
	Set $p(aInputStr,aSeparete,1)=QCEntityID
	Set ret=##class(DHCMA.CPW.SD.QCIndex).Update(aInputStr,aSeparete)
	Set:+ret>0 return=1
	Quit return
}

}
