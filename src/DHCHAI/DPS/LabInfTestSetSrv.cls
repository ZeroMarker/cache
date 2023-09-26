/// 名称: DHCHAI.DPS.LabInfTestSetSrv
/// 描述: 院感检验医嘱定义相关服务
/// 编写者：zhoubo
/// 编写日期: 2020-12-03
Class DHCHAI.DPS.LabInfTestSetSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2020-12-10
/// Description:  根据类型代码查询检验医嘱
/// Table：       DHCHAI.DP.LabInfTestSet
/// Input：       aType 业务类型（1环境卫生学、2职业暴露） 
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabInfTestSetSrv","QryByType","1")
Query QryByType(aType As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,LabTypeCode:%String,LabType:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryByTypeExecute(ByRef qHandle As %Binary, aType As %String = "", aAlias As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabInfTestSetD(xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.DP.LabInfTestSet).GetObjById(xID)
		Continue:'$Isobject(obj)
		
		Set Code     = obj.BTTSCode
		Set Desc     = obj.BTTSDesc
		Set Code     = obj.BTTSCode
		Set LabTypeCode = obj.BTLabType
		Continue:(aAlias'="")&&(Desc'[aAlias)
		Continue:(aType'="")&&(LabTypeCode'=aType)
		Set IsActive = obj.BTIsActive
		Continue:(aType'="")&&(IsActive'=1)
		Set LabType=$s(LabTypeCode=1:"环境卫生学",LabTypeCode=2:"职业暴露",1:"")
		
		Set Data = $lb(xID,Code,Desc,LabTypeCode,LabType,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByTypeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-10
/// Description:  根据检验医嘱ID查询关联的外部码
/// Table：       DHCHAI.DP.LabInfTestSetExt
/// Input：       aTestSetID ：DHCHAI.DP.LabInfTestSet.ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabInfTestSetSrv","QryTestSetExt","6")
Query QryTestSetExt(aTestSetID As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,ExtCode:%String,ActDate:%String,ActTime:%String") [ SqlProc ]
{
}

ClassMethod QryTestSetExtExecute(ByRef qHandle As %Binary, aTestSetID As %String = "", aAlias As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aTestSetID="" $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabInfTestSetExtI("IdxofParRef",aTestSetID,xID))
		Quit:xID=""
		
		Set objExt = ##class(DHCHAI.DP.LabInfTestSetExt).GetObjById(aTestSetID_"||"_xID)
		Continue:'$IsObject(objExt)
		
		Set ExtCode = objExt.BTExtCode
		Set ActDate = objExt.BTActDate
		Set ActTime = objExt.BTActTime
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Continue:(aAlias'="")&&(ExtCode'[aAlias)
		
		Set Data = $lb(aTestSetID_"||"_xID,ExtCode,ActDate,ActTime)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestSetExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetExtExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetExtExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
