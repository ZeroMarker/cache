/// 专门针对于系统的Query
Class DHCCPMWeb.CPMSysFun.DHCCPMSysQuery Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query LookupQueryOutPara(ClassName As %String, QueryName As %String) As %Query(ROWSPEC = "ColumnName:%String,ColumnType:%String") [ SqlProc ]
{
}

ClassMethod LookupQueryOutParaExecute(ByRef qHandle As %Binary, ClassName As %String, QueryName As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCCPMSysQuery","LookupQueryOutPara", "web.SSGroup", "LookUpPartial")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ResetVariables
	
	if ((QueryName="")||(ClassName="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s myOutStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList(ClassName,QueryName,"")	
	
	s myColLen=$l(myOutStr, ",")
	s:(myOutStr="") myColLen=""
	f myIdx=1:1:myColLen {
		s myColStr=$p(myOutStr,",",myIdx)
		s myColumnName=$p(myColStr,":",1)
		s myColumnType=$p(myColStr,":",2)
		s:(myColumnType="") myColumnType="%String"
		
		Do OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(myColumnName, myColumnType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	s (No,DataType)=""
	s (myColumnName, myColumnType)=""
	q
}

ClassMethod LookupQueryOutParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupQueryOutParaExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookupQueryOutParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupQueryOutParaExecute ]
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

Query LookupQueryInPara(ClassName As %String, QueryName As %String) As %Query(ROWSPEC = "ParaName:%String,ParaType:%String") [ SqlProc ]
{
}

ClassMethod LookupQueryInParaExecute(ByRef qHandle As %Binary, ClassName As %String, QueryName As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCCPMSysQuery","LookupQueryInPara", "web.DHCOPAdmFind", "AdmQuery")
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCCPMSysQuery","LookupQueryInPara","web.DHCLONGTIMEORD","GetLongOrd")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ResetVariablesIN
	
	if ((QueryName="")||(ClassName="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s myOutStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQInParaList(ClassName,QueryName,"")	
	
	s myColLen=$l(myOutStr, ",")
	s:(myOutStr="") myColLen=0
	f myIdx=1:1:myColLen {
		s myColStr=$p(myOutStr,",",myIdx)
		s myParaName=$p(myColStr,":",1)
		s myParaType=$p(myColStr,":",2)
		Do OutputRowIN
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowIN
	set Data=$lb(myParaName, myParaType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesIN
	s (No,DataType)=""
	s (myParaName, myParaType)=""
	q
}

ClassMethod LookupQueryInParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupQueryInParaExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookupQueryInParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupQueryInParaExecute ]
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

}
