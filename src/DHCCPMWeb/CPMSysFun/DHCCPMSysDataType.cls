/// 
/// 提供系统的基本数据类型
/// 1.提供Cache端的数据类型
/// 2.提供Net端端的数据类型
Class DHCCPMWeb.CPMSysFun.DHCCPMSysDataType Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetCacheADataTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCacheADataTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCacheADataTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCCPMSysDataType","GetCacheADataType")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ResetVariablesDT
	
	k ^TMPDATATYPE($j)
	
	Set result = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:Summary")
	Do result.Execute()
	While (result.Next()) {
    	s myDataName=result.Data("Name")
    	if ($p(myDataName,".",1)="%Library"){
	    	b		;;
	    	s ^TMPDATATYPE($j)=$g(^TMPDATATYPE($j))+1
	    	s myCount=$g(^TMPDATATYPE($j))
	    	s ^TMPDATATYPE($j,myCount)="%"_$p(myDataName,".",2)
    	}
    }
	
	s myNo=""
	f  s myNo=$o(^TMPDATATYPE($j,myNo))  q:(myNo="")  d
	.s No=myNo
	.s DataType=$g(^TMPDATATYPE($j,myNo))
	.Do OutputRow
	
	k ^TMPDATATYPE($j)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(No, DataType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesDT
	s (No,DataType)=""
	q
}

ClassMethod GetCacheADataTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCacheADataTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {			
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取所有的简单数据类型
Query GetCacheADataType() As %Query(ROWSPEC = "No:%String,DataType:%String") [ SqlProc ]
{
}

}
