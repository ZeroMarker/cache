Class DHCCL.Model.StockConsume Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockConsume ]
{

Property StockItemDr As DHCCL.Config.StockItem [ SqlColumnNumber = 2 ];

Property StockTransferDr As DHCCL.Model.StockTransfer [ SqlColumnNumber = 3 ];

Property LocationDr As %String [ SqlColumnNumber = 4 ];

Property UomDr As %String [ SqlColumnNumber = 5 ];

Property Qty As %Float [ SqlColumnNumber = 6 ];

Property Price As %Float [ SqlColumnNumber = 7 ];

Property Amout As %Float [ SqlColumnNumber = 8 ];

Property SumQty As %Float [ SqlColumnNumber = 9 ];

Property Type As %String(DISPLAYLIST = ",Normal,Other", VALUELIST = ",N,O") [ SqlColumnNumber = 10 ];

Property ConsumeDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11 ];

Property ConsumeTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12 ];

Property RecordSheet As DHCAN.Model.RecordSheet [ SqlColumnNumber = 13 ];

Property UpdateUser As %String [ SqlColumnNumber = 14 ];

Property UpdateDate As %Date [ SqlColumnNumber = 15 ];

Property UpdateTime As %Time [ SqlColumnNumber = 16 ];

Property BarCode As %String [ SqlColumnNumber = 17 ];

Property StockItemDesc As %String [ SqlColumnNumber = 18 ];

Property CertImage As %GlobalCharacterStream(LOCATION = "^DHCCL.Model.StockConsumeS") [ SqlColumnNumber = 19 ];

Index LocDate On (LocationDr, ConsumeDate);

Index LocDateSheet On (LocationDr, ConsumeDate, RecordSheet, StockItemDr);

Index RecordSheet On RecordSheet;

Index BarCode On BarCode;

Storage Default
{
<Data name="StockConsumeDefaultData">
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
<Value>UomDr</Value>
</Value>
<Value name="5">
<Value>Qty</Value>
</Value>
<Value name="6">
<Value>Price</Value>
</Value>
<Value name="7">
<Value>Amout</Value>
</Value>
<Value name="8">
<Value>SumQty</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
<Value name="10">
<Value>ConsumeDate</Value>
</Value>
<Value name="11">
<Value>ConsumeTime</Value>
</Value>
<Value name="12">
<Value>RecordSheet</Value>
</Value>
<Value name="13">
<Value>UpdateUser</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
<Value name="16">
<Value>BarCode</Value>
</Value>
<Value name="17">
<Value>StockItemDesc</Value>
</Value>
<Value name="18">
<Value>CertImage</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.StockConsumeD</DataLocation>
<DefaultData>StockConsumeDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.StockConsumeD</IdLocation>
<IndexLocation>^DHCCL.Model.StockConsumeI</IndexLocation>
<StreamLocation>^DHCCL.Model.StockConsumeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
