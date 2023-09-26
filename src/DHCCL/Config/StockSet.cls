Class DHCCL.Config.StockSet Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockSet ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property Dept As %String [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Index Dept On Dept;

Storage Default
{
<Data name="StockSetDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Dept</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.StockSetD</DataLocation>
<DefaultData>StockSetDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.StockSetD</IdLocation>
<IndexLocation>^DHCCL.Config.StockSetI</IndexLocation>
<StreamLocation>^DHCCL.Config.StockSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
