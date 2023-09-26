Class EPRservice.Query.ExportTableColumns Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, ProcedureBlock, StorageStrategy = "" ]
{

Property DataType As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property ItemCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Property Length As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1) [ Required ];

Property GetCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ExportTableColumnsState">
<Subscript>"EPRservice.Query.ExportTableColumns"</Subscript>
<Value name="1">
<Value>DataType</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Length</Value>
</Value>
<Value name="6">
<Value>GetCode</Value>
</Value>
</Data>
<State>ExportTableColumnsState</State>
<StreamLocation>^EPRservi.ExportTableColumnsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
