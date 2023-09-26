Class DHCCL.Config.StockLocation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockLocation ]
{

Property StockItemDr As StockItem [ SqlColumnNumber = 2 ];

Property LocationDr As Location [ SqlColumnNumber = 3 ];

Property Qty As %Float [ SqlColumnNumber = 4 ];

Property Uom As Uom [ SqlColumnNumber = 5 ];

Property ReplenishCardinal As %Float [ SqlColumnNumber = 6 ];

Property ReplenishQty As %Float [ SqlColumnNumber = 7 ];

Property ReplenishLocationDr As %String [ SqlColumnNumber = 8 ];

Property MaxQty As %Float [ SqlColumnNumber = 9 ];

Property MinQty As %Float [ SqlColumnNumber = 10 ];

Property ReservedQty As %Float [ SqlColumnNumber = 11 ];

Index Item On StockItemDr;

Index Location On LocationDr;

Storage Default
{
<Data name="StockLocationDefaultData">
<Value name="1">
<Value>StockItemDr</Value>
</Value>
<Value name="2">
<Value>LocationDr</Value>
</Value>
<Value name="3">
<Value>Qty</Value>
</Value>
<Value name="4">
<Value>Uom</Value>
</Value>
<Value name="5">
<Value>ReplenishCardinal</Value>
</Value>
<Value name="6">
<Value>ReplenishQty</Value>
</Value>
<Value name="7">
<Value>ReplenishLocationDr</Value>
</Value>
<Value name="8">
<Value>MaxQty</Value>
</Value>
<Value name="9">
<Value>MinQty</Value>
</Value>
<Value name="10">
<Value>ReservedQty</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.StockLocationD</DataLocation>
<DefaultData>StockLocationDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.StockLocationD</IdLocation>
<IndexLocation>^DHCCL.Config.StockLocationI</IndexLocation>
<StreamLocation>^DHCCL.Config.StockLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
