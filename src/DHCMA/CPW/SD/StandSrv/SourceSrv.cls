/// 数据源相关信息处理 服务类
Class DHCMA.CPW.SD.StandSrv.SourceSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.StandSrv.SourceSrv","QrySourceOutput","68")
Query QrySourceOutput(aSourceID As %String, aSubFlg As %String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod QrySourceOutputExecute(ByRef qHandle As %Binary, aSourceID As %String, aSubFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aSourceID="" $$$OK
 	Set aClassName=..GetDataClass(aSourceID,aSubFlg)	
	Set obj=##Class(%Dictionary.CompiledClass).%OpenId(aClassName)
	Set cnt=obj.Properties.Count()
	for i=1:1:cnt {
		Set PropertyObj=obj.Properties.GetAt(i)
		Set Desc=PropertyObj.Description
		;Continue:Desc'["输出"
		Set Desc=$p(Desc,"-",1)
		Set Code=PropertyObj.Name	
		Continue:Code["%"
		Set ^CacheTemp(repid,ind)=$lb(Code,Desc)
		Set ind=ind+1
	 }
	Quit $$$OK
}

ClassMethod QrySourceOutputClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySourceOutputExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySourceOutputFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySourceOutputExecute ]
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

ClassMethod GetClassProperty(aClassName As %String) As %String
{
	new (aClassName)
	Set obj=##Class(%Dictionary.CompiledClass).%OpenId(aClassName)
	Set cnt=obj.Properties.Count()
	Set PropertyStr=""
	for i=1:1:cnt {
		Set PropertyName=obj.Properties.GetAt(i).Name	
		Continue:PropertyName["%"
		Set PropertyStr=PropertyStr_"^"_PropertyName
	}
	Set:PropertyStr'="" PropertyStr=$e(PropertyStr,2,$l(PropertyStr))
	Quit PropertyStr
}

/// w ##class(DHCMA.CPW.SD.StandSrv.SourceSrv).GetDataClass(65)
ClassMethod GetDataClass(aSourceID, aSubFlg As %String = "") As %String
{
	New (aSourceID,aSubFlg)
	Quit:aSourceID="" ""
	Set objSource=##class(DHCMA.Util.BT.Dictionary).GetObjById(aSourceID)
 	If (objSource.BTDesc["药物")||(objSource.BTDesc["处置") {
	 	Set ClassName="DHCMA.CPW.SD.Data.OrderInfo"
	}elseif(objSource.BTDesc["检验") {
		Set ClassName="DHCMA.CPW.SD.Data.LisInfo"
		Set:aSubFlg=1 ClassName="DHCMA.CPW.SD.Data.LisItemInfo"
	}elseif(objSource.BTDesc["检查") {
		Set ClassName="DHCMA.CPW.SD.Data.RisInfo"
		//Set:aSubFlg=1 ClassName="DHCMA.CPW.SD.Data.RisItemInfo"
	}else{
		Quit ""
	}
	Quit ClassName
}

}
