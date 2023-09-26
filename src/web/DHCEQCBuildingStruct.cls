/// create by GR0021 增加建筑结构查找query
Class web.DHCEQCBuildingStruct Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "HIDDEN:%String,BSCode:%String,BSDesc:%String")
{
SELECT 	BS_RowID,
		BS_Code,
		BS_Desc		 
FROM 	SQLUSER.DHC_EQCBuildingStruct
where BS_InvalidFlag = 'N' and BS_Desc like nvl(:para,'')||'%'
}

/// ##class(%ResultSet).RunQuery("web.DHCEQCBuildingStruct","GetSStruct","")
Query GetStruct(para As %String = "") As %Query(ROWSPEC = "HIDDEN:%String,BSCode:%String,BSDesc:%String")
{
}

ClassMethod GetStructExecute(ByRef qHandle As %Binary, para As %String = "") As %Status
{
	new repid,index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s rowid=0
	
 	s BSRowID=0
 	for  set BSRowID=$Order(^DHCEQCCode("DHCEQCBuildingStruct",BSRowID)) quit:BSRowID=""  d
 	.d ResetVariablesGetOpenCheckRequest
 	.s BSCode=$p(^DHCEQCCode("DHCEQCBuildingStruct",BSRowID),"^",1)
 	.s BSDesc=$p(^DHCEQCCode("DHCEQCBuildingStruct",BSRowID),"^",2)
 	.q:(para'="")&&(para'[BSDesc)
 	.;s BSRemark=$p(^DHCEQCCode("DHCEQCBuildingStruct",BSRowID),"^",3)
 	.s BSInvalidFlag=$p(^DHCEQCCode("DHCEQCBuildingStruct",BSRowID),"^",4)
 	.q:BSInvalidFlag'="N"
 	.d OutputRowGetCheckDetail
 	quit $$$OK
 	
OutputRowGetCheckDetail
	s Data=$lb(BSRowID,BSCode,BSDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheckRequest
	s (BSCode,BSDesc,BSRemark,BSInvalidFlag)=""
	quit
}

ClassMethod GetStructClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSStructExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetStructFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSStructExecute ]
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

Storage Default
{
<Data name="DHCEQCBuildingStructDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCBuildingStructD</DataLocation>
<DefaultData>DHCEQCBuildingStructDefaultData</DefaultData>
<IdLocation>^web.DHCEQCBuildingStructD</IdLocation>
<IndexLocation>^web.DHCEQCBuildingStructI</IndexLocation>
<StreamLocation>^web.DHCEQCBuildingStructS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
