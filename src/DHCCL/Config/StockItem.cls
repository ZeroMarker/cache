Class DHCCL.Config.StockItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockItem ]
{

Property Code As %String(MAXLEN = 200) [ SqlColumnNumber = 2 ];

Property Description As %String(MAXLEN = 200) [ SqlColumnNumber = 3 ];

Property StockCatDr As DHCCL.Code.StockCat [ SqlColumnNumber = 4 ];

Property UomDr As DHCCL.Config.Uom [ SqlColumnNumber = 5 ];

Property ActiveDateTo As %Date [ SqlColumnNumber = 6 ];

Property OrderItemCode As %String [ SqlColumnNumber = 7 ];

Property IsHighValue As %Boolean [ SqlColumnNumber = 8 ];

Property IsSterile As %Boolean [ SqlColumnNumber = 9 ];

Property IsRequireBatch As %Boolean [ SqlColumnNumber = 10 ];

Property IsRequireExpire As %Boolean [ SqlColumnNumber = 11 ];

Property ManufacturerDr As DHCCL.Code.Manufacturer [ SqlColumnNumber = 12 ];

Property VendorDr As DHCCL.Code.Vendor [ SqlColumnNumber = 13 ];

/// 规格
Property Spec As %String [ SqlColumnNumber = 14 ];

/// 助记码
Property Alias As %String(MAXLEN = 500) [ SqlColumnNumber = 15 ];

/// 通用名
Property GeneralDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 16 ];

/// 通用名助记码
Property GeneralAlias As %String(MAXLEN = 200) [ SqlColumnNumber = 17 ];

Property ChargeItem As DHCAN.Config.ChargeItem [ SqlColumnNumber = 18 ];

Index Code On Code [ Unique ];

Index Cat On StockCatDr;

Index GenDesc On GeneralDesc;

Index GenAlias On GeneralAlias;

Index Alias On Alias;

Index Description On Description;

Index ChargeItem On ChargeItem;

Storage Default
{
<Data name="StockItemDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>StockCatDr</Value>
</Value>
<Value name="4">
<Value>UomDr</Value>
</Value>
<Value name="5">
<Value>ActiveDateTo</Value>
</Value>
<Value name="6">
<Value>OrderItemCode</Value>
</Value>
<Value name="7">
<Value>IsHighValue</Value>
</Value>
<Value name="8">
<Value>IsSterile</Value>
</Value>
<Value name="9">
<Value>IsRequireBatch</Value>
</Value>
<Value name="10">
<Value>IsRequireExpire</Value>
</Value>
<Value name="11">
<Value>ManufacturerDr</Value>
</Value>
<Value name="12">
<Value>VendorDr</Value>
</Value>
<Value name="13">
<Value>Spec</Value>
</Value>
<Value name="14">
<Value>Alias</Value>
</Value>
<Value name="15">
<Value>GeneralDesc</Value>
</Value>
<Value name="16">
<Value>GeneralAlias</Value>
</Value>
<Value name="17">
<Value>ChargeItem</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.StockItemD</DataLocation>
<DefaultData>StockItemDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.StockItemD</IdLocation>
<IndexLocation>^DHCCL.Config.StockItemI</IndexLocation>
<StreamLocation>^DHCCL.Config.StockItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
