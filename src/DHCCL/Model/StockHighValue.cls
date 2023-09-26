Class DHCCL.Model.StockHighValue Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockHighValue ]
{

Property StockItemDr As DHCCL.Config.StockItem [ SqlColumnNumber = 2 ];

Property StockTransferDr As StockTransfer [ SqlColumnNumber = 3 ];

Property LocationDr As DHCCL.Config.Location [ SqlColumnNumber = 4 ];

Property BarCode As %String [ SqlColumnNumber = 5 ];

Property BatchNo As %String [ SqlColumnNumber = 6 ];

Property OriginalBarcode As %String [ SqlColumnNumber = 7 ];

Property ProduceDate As %Date [ SqlColumnNumber = 8 ];

Property HighValueDate As %Date [ SqlColumnNumber = 9 ];

Property HighValueTime As %Time [ SqlColumnNumber = 10 ];

Property OrderItemDr As DHCCL.Model.OrderItem [ SqlColumnNumber = 11 ];

Property OperScheduleDr As DHCAN.Model.OperSchedule [ SqlColumnNumber = 12 ];

Index Item On StockItemDr;

Index Location On LocationDr;

Index OPS On OperScheduleDr;

Storage Default
{
<Data name="StockHighValueDefaultData">
<Value name="1">
<Value>StockItemDr</Value>
</Value>
<Value name="2">
<Value>StockTransferDr</Value>
</Value>
<Value name="3">
<Value>LocationDr</Value>
</Value>
<Value name="4">
<Value>BarCode</Value>
</Value>
<Value name="5">
<Value>BatchNo</Value>
</Value>
<Value name="6">
<Value>OriginalBarcode</Value>
</Value>
<Value name="7">
<Value>ProduceDate</Value>
</Value>
<Value name="8">
<Value>HighValueDate</Value>
</Value>
<Value name="9">
<Value>HighValueTime</Value>
</Value>
<Value name="10">
<Value>OrderItemDr</Value>
</Value>
<Value name="11">
<Value>OperScheduleDr</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.StockHighValueD</DataLocation>
<DefaultData>StockHighValueDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.StockHighValueD</IdLocation>
<IndexLocation>^DHCCL.Model.StockHighValueI</IndexLocation>
<StreamLocation>^DHCCL.Model.StockHighValueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
