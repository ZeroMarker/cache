/// 名称: DHCMA.Util.BTS.HospGroupSrv
/// 描述: 医院分组 服务类
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BTS.HospGroupSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2018-07-31
/// Description:  查询医院分组列表
/// Table：       DHCMA.Util.BT.HospGroup
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.HospGroupSrv","QryHospGrpInfo")
Query QryHospGrpInfo() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryHospGrpInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.BT.HospGroupD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.BT.HospGroup).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set ID          = obj.%Id()
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Set IsActive	= obj.BTIsActive
		
		Set Data=$lb(ID,Code,Desc,IsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryHospGrpInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospGrpInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospGrpInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospGrpInfoExecute ]
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

}
