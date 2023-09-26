Class DHCCL.Model.StockMonthItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockMonthItem ]
{

Property StockMonthDr As DHCCL.Model.StockMonth [ SqlColumnNumber = 2 ];

Property StockItemDr As DHCCL.Config.StockItem [ SqlColumnNumber = 3 ];

Property LocationDr As %String [ SqlColumnNumber = 4 ];

/// 初始数量
Property Qty As %Float [ SqlColumnNumber = 5 ];

/// 入库数量
Property Amount As %Float [ SqlColumnNumber = 6 ];

/// 出库数量
Property CostAmount As %Float [ SqlColumnNumber = 7 ];

/// 月底数量
Property LastQty As %Float [ SqlColumnNumber = 8 ];

Property LastCostAmount As %String [ SqlColumnNumber = 9 ];

Property Remarks As %String [ SqlColumnNumber = 10 ];

Property UpdateUser As %String [ SqlColumnNumber = 11 ];

Property UpdateDate As %Date [ SqlColumnNumber = 12 ];

Property UpdateTime As %Time [ SqlColumnNumber = 13 ];

Index Month On StockMonthDr;

Index MonthLocItem On (StockMonthDr, LocationDr, StockItemDr);

Storage Default
{
<Data name="StockMonthItemDefaultData">
<Value name="1">
<Value>StockMonthDr</Value>
</Value>
<Value name="2">
<Value>StockItemDr</Value>
</Value>
<Value name="3">
<Value>LocationDr</Value>
</Value>
<Value name="4">
<Value>Qty</Value>
</Value>
<Value name="5">
<Value>Amount</Value>
</Value>
<Value name="6">
<Value>CostAmount</Value>
</Value>
<Value name="7">
<Value>LastQty</Value>
</Value>
<Value name="8">
<Value>LastCostAmount</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.StockMonthItemD</DataLocation>
<DefaultData>StockMonthItemDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.StockMonthItemD</IdLocation>
<IndexLocation>^DHCCL.Model.StockMonthItemI</IndexLocation>
<StreamLocation>^DHCCL.Model.StockMonthItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
