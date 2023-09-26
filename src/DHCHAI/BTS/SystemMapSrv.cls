/// 名称: DHCHAI.BTS.SystemMapSrv
/// 描述: 子系统对照相关业务处理
/// 编写者：zhoubo
/// 编写日期: 2017-04-12
Class DHCHAI.BTS.SystemMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-04-12
/// Description:  查询子系统对照信息
/// Table：       DHCHAI.BT.HospGroup
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.SystemMapSrv","QrySystemMapInfo")
Query QrySystemMapInfo() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,HISCode:%String,SysID:%String,SysCode:%String,SysDesc:%String,HospID:%String,HospCode:%String,HospDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,IsActive:%String,IsActDesc:%String")
{
}

ClassMethod QrySystemMapInfoExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.SystemMapI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.SystemMapI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objSystemMap = ##class(DHCHAI.BT.SystemMap).GetObjById(xID)
			Continue:'$isobject(objSystemMap)
			
			Set Code = objSystemMap.BTCode
			Set Desc = objSystemMap.BTDesc
			Set HISCode = objSystemMap.BTHISCode
			Set (SysCode,SysDesc) = ""
			If $IsObject(objSystemMap.BTTypeDr) {	
				Set SysID =  objSystemMap.BTTypeDr.%Id()  
				Set SysCode = objSystemMap.BTTypeDr.BTCode
				Set SysDesc = objSystemMap.BTTypeDr.BTDesc
		    }
			Set (HospCode,HospDesc) = ""
			If $IsObject(objSystemMap.BTHospDr) {
				Set HospID = objSystemMap.BTHospDr.%Id()	   
				Set HospCode = objSystemMap.BTHospDr.BTCode
				Set HospDesc = objSystemMap.BTHospDr.BTDesc
		    }
			Set ActDate = objSystemMap.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objSystemMap.BTActTime
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set (ActUserCode,ActUserDesc) = ""
			If $IsObject(objSystemMap.BTActUserDr) {	   
				Set ActUserCode = objSystemMap.BTActUserDr.BTCode
				Set ActUserDesc = objSystemMap.BTActUserDr.BTDesc
		    }
			Set IsActive=objSystemMap.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")
					
			Set Data = $lb(xID,Code,Desc,HISCode,SysID,SysCode,SysDesc,HospID,HospCode,HospDesc,ActDate,ActTime,ActUserCode,ActUserDesc,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrySystemMapInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySystemMapInfoExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySystemMapInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySystemMapInfoExecute ]
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
