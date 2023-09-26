/// Creator:
/// Descriptions:表字段显示公共类
/// Date:2017-11-06
/// 
Class web.NurMgFieldSetComm Extends %RegisteredObject
{

/// Creator:guozj
/// Description:查询列表字段显示配置
/// Date:2017-11-07
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgFieldSetComm","FindSortFields")
Query FindSortFields(menu As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSortFieldsExecute(ByRef qHandle As %Binary, menu As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp=""
	s menurw="" f  s menurw=$O(^DHCNMG.Set.MgMenuI("Code"," "_$zcvt($tr(menu," ",""),"U"),menurw)) q:menurw=""  d
	.s sort="" f  s sort=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_menurw,sort)) q:sort=""  d
	..s rowid="" f  s rowid=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_menurw,sort,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.Set.MgFieldSet).%OpenId(rowid)
	...;i ((obj.FieldCode="PerID")||(obj.FieldCode="PerName")||(obj.FieldCode="PerDepDR")) s sortable="true"
	...;e  s sortable="false"
	...s sortable="false"
	...s ftype=obj.FieldType
	...s tmp(sort)="code|"_obj.FieldCode_"^desc|"_obj.FieldDesc_"^dshow|"_obj.FieldDisplay_"^lock|"_obj.FieldLock_"^loca|"_obj.FieldLockPos_"^width|"_obj.FieldWidth_"^sortable|"_sortable_"^ftype|"_ftype
	s num="" f  s num=$O(tmp(num)) q:num=""  d
	.s ret=tmp(num)
	.do OutputFields
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputFields
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSortFieldsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSortFieldsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSortFieldsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSortFieldsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
