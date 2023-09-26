Class DHCCL.Code.Vendor Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Vendor ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property Address As %String [ SqlColumnNumber = 4 ];

Property Telephone As %String [ SqlColumnNumber = 5 ];

Index Code On Code [ Unique ];

Storage Default
{
<Data name="VendorDefaultData">
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
<DataLocation>^DHCCL.Code.VendorD</DataLocation>
<DefaultData>VendorDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.VendorD</IdLocation>
<IndexLocation>^DHCCL.Code.VendorI</IndexLocation>
<StreamLocation>^DHCCL.Code.VendorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
