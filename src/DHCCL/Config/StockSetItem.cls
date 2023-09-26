Class DHCCL.Config.StockSetItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockSetItem ]
{

Property StockSet As DHCCL.Config.StockSet [ Required, SqlColumnNumber = 2 ];

Property StockItem As DHCCL.Config.StockItem [ SqlColumnNumber = 3 ];

Property DefaultQty As %Float [ InitialExpression = 1, SqlColumnNumber = 4 ];

Property Uom As DHCCL.Config.Uom [ SqlColumnNumber = 5 ];

Property ActiveDate As %Date [ SqlColumnNumber = 6 ];

Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 价表项目
Property TariffItem As DHCAN.Config.ChargeItem [ SqlColumnNumber = 8 ];

Property SetItemDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 9 ];

Index StockSet On StockSet;

ForeignKey FKStockSet(StockSet) References DHCCL.Config.StockSet() [ OnDelete = cascade ];

Storage Default
{
<Data name="StockSetItemDefaultData">
<Value name="1">
<Value>StockSet</Value>
</Value>
<Value name="2">
<Value>StockItem</Value>
</Value>
<Value name="3">
<Value>DefaultQty</Value>
</Value>
<Value name="4">
<Value>Uom</Value>
</Value>
<Value name="5">
<Value>ActiveDate</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>StockDesc</Value>
</Value>
<Value name="8">
<Value>TariffItem</Value>
</Value>
<Value name="9">
<Value>SetItemDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.StockSetItemD</DataLocation>
<DefaultData>StockSetItemDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.StockSetItemD</IdLocation>
<IndexLocation>^DHCCL.Config.StockSetItemI</IndexLocation>
<StreamLocation>^DHCCL.Config.StockSetItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
