/// 类名：DHCMed.DPCustom.Meta.ActWardsSrv
Class DHCMed.DPCustom.Meta.ActWardsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2014-2-27
/// Description:  查询常用词组、短语、关键字、特殊符号
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.DPCustom.Meta.ActWardsSrv","QryActWards","1")
Query QryActWards(aActType As %String, aCategory As %String = "") As %Query(ROWSPEC = "RowID:%String,APCategory:%String,APWords:%String,APActType:%String,APText1:%String,APText2:%String,APText3:%String,APText4:%String,APIsActive:%String,APResume:%String")
{
}

ClassMethod QryActWardsExecute(ByRef qHandle As %Binary, aActType As %String, aCategory As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=0
 	For {
		Set xID=$o(^DHCMed.DP.Base.ActWardsD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.DP.Base.ActWards).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set APCategory=obj.APCategory
		Continue:(aCategory'="")&&(aCategory'=APCategory)
		Set APWords=obj.APWords
		Set APActType=obj.APActType
		Continue:(aActType'="")&&(APActType'=aActType)
		
	 	Set APText1=obj.APText1
	 	Set APText2=obj.APText2
	 	Set APText3=obj.APText3
	 	Set APText4=obj.APText4
	 	Set APIsActive=obj.APIsActive
	 	Set APIsActive=$s(APIsActive=1:"是",1:"否")
	 	Set APResume=obj.APResume
	 	
	 	Set Data=$lb(xID,APCategory,APWords,APActType,APText1,APText2,APText3,APText4,APIsActive,APResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryActWardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryActWardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryActWardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryActWardsExecute ]
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
