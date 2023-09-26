Class DHCCL.Code.Manufacturer Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Manufacturer ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property Address As %String [ SqlColumnNumber = 4 ];

Property Telephone As %String [ SqlColumnNumber = 5 ];

Index Code On Code [ Unique ];

Storage Default
{
<Data name="ManufacturerDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Address</Value>
</Value>
<Value name="4">
<Value>Telephone</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.ManufacturerD</DataLocation>
<DefaultData>ManufacturerDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.ManufacturerD</IdLocation>
<IndexLocation>^DHCCL.Code.ManufacturerI</IndexLocation>
<StreamLocation>^DHCCL.Code.ManufacturerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
