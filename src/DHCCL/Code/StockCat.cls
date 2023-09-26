Class DHCCL.Code.StockCat Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockCat ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ SqlColumnNumber = 3 ];

Property Type As %String(DISPLAYLIST = ",Drug,Material,Others", VALUELIST = ",D,M,O") [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Storage Default
{
<Data name="StockCatDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.StockCatD</DataLocation>
<DefaultData>StockCatDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.StockCatD</IdLocation>
<IndexLocation>^DHCCL.Code.StockCatI</IndexLocation>
<StreamLocation>^DHCCL.Code.StockCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
