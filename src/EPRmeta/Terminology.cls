Class EPRmeta.Terminology Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Code As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property TableName As %String(TRUNCATE = 1);

Property TermAliasCol As %String(TRUNCATE = 1);

Property TermCodeCol As %String(TRUNCATE = 1);

Property TermDescCol As %String(TRUNCATE = 1);

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,TableName:%String,TermCodeCol:%String,TermDescCol:%String,TermAliasCol:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Terminology_SELECTALL, SqlProc ]
{
SELECT %ID,Code,Name,Description,TableName,TermCodeCol,TermDescCol,TermAliasCol
 FROM Terminology
 ORDER BY Code
}

Storage Default
{
<Data name="TerminologyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>TableName</Value>
</Value>
<Value name="6">
<Value>TermAliasCol</Value>
</Value>
<Value name="7">
<Value>TermCodeCol</Value>
</Value>
<Value name="8">
<Value>TermDescCol</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.TerminologyD</DataLocation>
<DefaultData>TerminologyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.TerminologyD</IdLocation>
<IndexLocation>^DHCEPRM.TerminologyI</IndexLocation>
<StreamLocation>^DHCEPRM.TerminologyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
