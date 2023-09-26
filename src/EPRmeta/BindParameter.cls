Class EPRmeta.BindParameter Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxParameterName On ParameterName;

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property ParameterName As %String(TRUNCATE = 1);

Property ParameterType As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

ClassMethod DelParameterByQueryId(AQueryID As %String)
{
 &sql(
 Delete 
 from EPRmeta.BindParameter 
 Where QueryID =:AQueryID )
}

Query SelectAllQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ParameterName:%String,ParameterType:%String,QueryID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_BindParameter_SELECTALLQuery, SqlProc ]
{
 SELECT ID, Name, Description, ParameterName,ParameterType,QueryID
 FROM EPRmeta.BindParameter
 ORDER BY ID
}

Query SelectParameterByQueryID(AQuetyID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ParameterName:%String,ParameterType:%String,QueryID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_BindParameter_SelectParameterByQueryID, SqlProc ]
{
 SELECT ID, Name, Description, ParameterName,ParameterType,QueryID
 FROM EPRmeta.BindParameter
 Where QueryID= :AQuetyID
 ORDER BY ID
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.BindParameter","SelectDistinctParameter")
Query SelectDistinctParameter() As %Query(ROWSPEC = "ParameterName:%String")
{
}

ClassMethod SelectDistinctParameterExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s ParamName = ""
	for {
		s ParamName = $o(^DHCEPRM.BindParameterI("IdxParameterName",ParamName))
		q:(ParamName = "")
		
		s RowID = $o(^DHCEPRM.BindParameterI("IdxParameterName",ParamName,""))
		continue:(RowID = "")
		
		s objParameter = $g(^DHCEPRM.BindParameterD(RowID))
		s ParameterName = $list(objParameter,3)
		
		s Data=$lb(ParameterName)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
		
	q $$$OK
}

ClassMethod SelectDistinctParameterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectDistinctParameterExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectDistinctParameterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectDistinctParameterExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="BindParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ParameterName</Value>
</Value>
<Value name="4">
<Value>ParameterType</Value>
</Value>
<Value name="5">
<Value>QueryID</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.BindParameterD</DataLocation>
<DefaultData>BindParameterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.BindParameterD</IdLocation>
<IndexLocation>^DHCEPRM.BindParameterI</IndexLocation>
<StreamLocation>^DHCEPRM.BindParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
