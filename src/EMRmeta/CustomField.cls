Class EMRmeta.CustomField Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1);

Property FieldType As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

ClassMethod DelFieldByQueryId(AQueryID As %String)
{
 &sql(
 Delete 
 from EMRmeta.CustomField 
 Where QueryID =:AQueryID )
}

Query SelectAllField() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,QueryID:%String,FieldName:%String,FieldType:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CustomField_SELECTAllField, SqlProc ]
{
 SELECT ID,Name, QueryID, FieldName,FieldType, Description
 FROM EMRmeta.CustomField
 ORDER BY ID
}

Query SelectFieldByQID(AQID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String, QueryID:%String,FieldName:%String,FieldType:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CustomField_SELECTFieldByQID, SqlProc ]
{
 SELECT ID,Name, QueryID, FieldName,FieldType, Description
 FROM EMRmeta.CustomField
 Where QueryID =:AQID 
 ORDER BY ID
}

Storage Default
{
<Data name="CustomFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>FieldName</Value>
</Value>
<Value name="4">
<Value>FieldType</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>QueryID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CustomFieldD</DataLocation>
<DefaultData>CustomFieldDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CustomFieldD</IdLocation>
<IndexLocation>^DHCEMRM.CustomFieldI</IndexLocation>
<StreamLocation>^DHCEMRM.CustomFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
