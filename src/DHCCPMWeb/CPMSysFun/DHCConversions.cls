Class DHCCPMWeb.CPMSysFun.DHCConversions Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod LookUpClassNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpClassNameExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpClassNameExecute(ByRef qHandle As %Binary, classname As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCConversions","LookUpClassName","")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ResetVariablesDT
	s classname=$g(classname)
	i classname=""{
		s classname="web"
	}
	s ^TEMPMZC="111111"
	k ^TMPDATATYPE($j)
	
	s mylen=$l(classname)
	Set result = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:Summary")
	Do result.Execute()
	While (result.Next()) {
    	s myDataName=result.Data("Name")
    	s mypreabc=$e(myDataName,1,mylen)
    	
    	if ((+result.Data("System")=0)&(mypreabc=classname)){
    		s mySqlTableName=result.Data("SqlTableName")
	    	s ^TMPDATATYPE($j)=$g(^TMPDATATYPE($j))+1
	    	s myCount=$g(^TMPDATATYPE($j))
	    	s ^TMPDATATYPE($j,myCount,"Cls")=$g(myDataName)
	    	i (mySqlTableName=""){
		    	s mySqlTableName=myDataName
	    	}
	    	s ^TMPDATATYPE($j,myCount,"Tab")=$g(mySqlTableName)
    	}
    }
	
	s myNo=""
	f  s myNo=$o(^TMPDATATYPE($j,myNo))  q:(myNo="")  d
	.s No=myNo
	.s myClsName=$g(^TMPDATATYPE($j,myNo,"Cls"))
	.s mySqlTableName=$g(^TMPDATATYPE($j,myNo,"Tab"))
	.Do OutputRow
	
	k ^TMPDATATYPE($j)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(myClsName, mySqlTableName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesDT
	s (No,DataType)=""
	s (myClsName, mySqlTableName)=""
	q
}

ClassMethod LookUpClassNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpClassNameExecute ]
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

Query LookUpClassName(classname As %String) As %Query(ROWSPEC = "ClassName:%String,TableName:%String") [ SqlProc ]
{
}

/// 查询Query名称
Query LookUpQueryName(ClassName As %String) As %Query(ROWSPEC = "QueryName:%String") [ SqlProc ]
{
}

ClassMethod LookUpQueryNameExecute(ByRef qHandle As %Binary, ClassName As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMSysFun.DHCConversions","LookUpQueryName","DHCCPMWeb.CPMSysFun.DHCConversions")
	;d ##class(%ResultSet).RunQuery("%Dictionary.QueryDefinitionQuery","Summary","DHCCPMWeb.CPMSysFun.DHCConversions")
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ResetVariablesQuery
	s classname=$g(ClassName)
	i classname=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	k ^TMPDATATYPE($j)
	
	s mylen=$l(classname)
	
	Set result = ##class(%ResultSet).%New("%Dictionary.QueryDefinitionQuery:Summary")
	Do result.Execute(classname)
	While (result.Next()) {
    	s myDataName=result.Data("Name")
	    s ^TMPDATATYPE($j)=$g(^TMPDATATYPE($j))+1
	    s myCount=$g(^TMPDATATYPE($j))
	    s ^TMPDATATYPE($j,myCount,"Query")=$g(myDataName)
	    i (mySqlTableName=""){
		   	s mySqlTableName=myDataName
	    }
	    s ^TMPDATATYPE($j,myCount,"Tab")=$g(mySqlTableName)
    }
	
	s myNo=""
	f  s myNo=$o(^TMPDATATYPE($j,myNo))  q:(myNo="")  d
	.s No=myNo
	.s myQueryName=$g(^TMPDATATYPE($j,myNo,"Query"))
	.s mySqlTableName=$g(^TMPDATATYPE($j,myNo,"Tab"))
	.Do OutputRowQuery
	
	;k ^TMPDATATYPE($j)
	
	d result.Close()
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowQuery
	set Data=$lb(myQueryName, mySqlTableName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesQuery
	s (No,DataType)=""
	s (myQueryName, mySqlTableName)=""
	q
}

ClassMethod LookUpQueryNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpQueryNameExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpQueryNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpQueryNameExecute ]
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
