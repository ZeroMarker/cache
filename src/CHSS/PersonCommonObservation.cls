Class CHSS.PersonCommonObservation Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ItemRowId, SqlTableName = PersonCommonObservation ]
{

//对应记录号

Property ItemAssortName As %String(MAXLEN = 60, TRUNCATE = 1);

Property ItemAssortCode As %String(MAXLEN = 10, TRUNCATE = 1);

Property ItemdCode As %String(MAXLEN = 10, TRUNCATE = 1);

Property ItemName As %String(MAXLEN = 50, TRUNCATE = 1);

Property TableType As %String(MAXLEN = 50, TRUNCATE = 1);

Property RecordType As %Integer;

Property TableName As %String(MAXLEN = 50, TRUNCATE = 1);

Property RecordRowIdDR As %Integer;

Storage Default
{
<Data name="PersonCommonObservationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemAssortCode</Value>
</Value>
<Value name="3">
<Value>ItemAssortName</Value>
</Value>
<Value name="4">
<Value>ItemName</Value>
</Value>
<Value name="5">
<Value>ItemdCode</Value>
</Value>
<Value name="6">
<Value>RecordRowIdDR</Value>
</Value>
<Value name="7">
<Value>RecordType</Value>
</Value>
<Value name="8">
<Value>TableName</Value>
</Value>
<Value name="9">
<Value>TableType</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonCommonObservationD</DataLocation>
<DefaultData>PersonCommonObservationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonCommonObservationD</IdLocation>
<IndexLocation>^CHSS.PersonCommonObservationI</IndexLocation>
<StreamLocation>^CHSS.PersonCommonObservationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
