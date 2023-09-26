/// 名称: DHCWMR.SSService.MrClassSrv
/// 描述: 病案分类的常用操作
/// 编写者：zhouruimeng
/// 编写日期: 2014-08-25
Class DHCWMR.SSService.MrClassSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-25
/// Description:  查询病案分类
/// Table：       DHCWMR.SS.MrClass
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.MrClassSrv","QryMrClass")
Query QryMrClass(MrCode As %String) As %Query(ROWSPEC = "MrID:%String,MrCode:%String,MrDesc:%String,Resume:%String")
{
}

ClassMethod QryMrClassExecute(ByRef qHandle As %Binary, MrCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	If MrCode'=""
 	{
	 	Set xId = ""
 		For	{
	 		Set xId = $o(^DHCWMR.SS.MrClassI("IndexCode"," "_$ZCVT(MrCode,"U"),xId))
	 		Quit:xId=""
	 	
	 		Set objSub = ##class(DHCWMR.SS.MrClass).GetObjById(xId)
	 		Continue:'$IsObject(objSub)
	 	
	 		Set RowId = objSub.%Id()
	 		Set WCode = objSub.MCCode
	 		Set WDesc = objSub.MCDesc
	 		Set Resume = objSub.MCResume
 		
 			Set Data = $LB(RowId,WCode,WDesc,Resume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
 	}
 	Else
 	{
 	Set xId = ""
 	For {
	 	Set xId = $o(^DHCWMR.SS.MrClassD(xId))
	 	Quit:xId=""
	 	
	 	Set objSub = ##class(DHCWMR.SS.MrClass).GetObjById(xId)
	 	Continue:'$IsObject(objSub)
	 	
	 	Set RowId = objSub.%Id()
	 	Set WCode = objSub.MCCode
	 	Set WDesc = objSub.MCDesc
	 	Set Resume  = objSub.MCResume
 		
 		Set Data = $LB(RowId,WCode,WDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	}	
	Quit $$$OK
}

ClassMethod QryMrClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMrClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMrClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMrClassExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
