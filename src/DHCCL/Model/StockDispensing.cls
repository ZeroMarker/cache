Class DHCCL.Model.StockDispensing Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockDispensing ]
{

Property StockItemDr As DHCCL.Config.StockItem [ SqlColumnNumber = 2 ];

Property StockTransferDr As StockTransfer [ SqlColumnNumber = 3 ];

Property LocationDr As DHCCL.Config.Location [ SqlColumnNumber = 4 ];

Property Qty As %Float [ SqlColumnNumber = 5 ];

Property UomDr As DHCCL.Config.Uom [ SqlColumnNumber = 6 ];

Property Price As %Float [ SqlColumnNumber = 7 ];

Property Amout As %Float [ SqlColumnNumber = 8 ];

Property Type As %String(DISPLAYLIST = ",Normal,Other", VALUELIST = ",N,O") [ SqlColumnNumber = 9 ];

Property UserDr As DHCCL.Config.SecureUser [ SqlColumnNumber = 10 ];

Property ReceiveUserDr As DHCCL.Config.SecureUser [ SqlColumnNumber = 11 ];

Property DispensingDate As %String [ SqlColumnNumber = 12 ];

Property DispensingTime As %String [ SqlColumnNumber = 13 ];

Index Location On LocationDr;

Index Item On StockItemDr;

Storage Default
{
<Data name="StockDispensingDefaultData">
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
<Value>Qty</Value>
</Value>
<Value name="5">
<Value>UomDr</Value>
</Value>
<Value name="6">
<Value>Price</Value>
</Value>
<Value name="7">
<Value>Amout</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>UserDr</Value>
</Value>
<Value name="10">
<Value>ReceiveUserDr</Value>
</Value>
<Value name="11">
<Value>DispensingDate</Value>
</Value>
<Value name="12">
<Value>DispensingTime</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.StockDispensingD</DataLocation>
<DefaultData>StockDispensingDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.StockDispensingD</IdLocation>
<IndexLocation>^DHCCL.Model.StockDispensingI</IndexLocation>
<StreamLocation>^DHCCL.Model.StockDispensingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
