Class EMRmeta.EMRDocRestriction.DocGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//规则名称

Property GroupName As %String(TRUNCATE = 1);

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,GroupName:%String")
{
	SELECT ID,GroupName
	FROM EMRmeta_EMRDocRestriction.DocGroup
	ORDER BY ID
}

Storage Default
{
<Data name="DocGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DocRes.DocGroupD</DataLocation>
<DefaultData>DocGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.DocRes.DocGroupD</IdLocation>
<IndexLocation>^DHCEMRM.DocRes.DocGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.DocRes.DocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
