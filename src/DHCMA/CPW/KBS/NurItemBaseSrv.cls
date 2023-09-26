Class DHCMA.CPW.KBS.NurItemBaseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2022-6-27
/// Description:  查询护理项目库
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.KBS.NurItemBaseSrv","QryNIBase")
Query QryNIBase(aKeyValue As %String = "") As %Query(ROWSPEC = "BTID:%String,BTDesc:%String,BTIsActive:%String,BTNURCode:%String")
{
}

ClassMethod QryNIBaseExecute(ByRef qHandle As %Binary, aKeyValue As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID=""
 	For {
	 	Set xID      = $o(^CT.MA.CPW.KB.NurItemBaseD(xID))
	 	Quit:xID=""
	 	Set obj         = ##class(DHCMA.CPW.KB.NurItemBase).GetObjById(xID)
	 	continue:'$IsObject(obj)
	 	Set Desc          = obj.NIDesc
	 	Continue:(aKeyValue'="")&&(Desc'[aKeyValue)
	 	Set IsActive      = obj.NIIsActive
	 	Set IsActive=$s(IsActive>0:"是",IsActive<=0:"否",1:"")
	 	Set NURCode       = obj.NINURCode
		Set Data=$lb(xID,Desc,IsActive,NURCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryNIBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNIBaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNIBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNIBaseExecute ]
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
