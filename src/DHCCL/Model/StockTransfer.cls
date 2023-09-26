Class DHCCL.Model.StockTransfer Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockTransfer ]
{

Property StockItemDr As DHCCL.Config.StockItem [ SqlColumnNumber = 2 ];

Property ProvideLocationDr As %String [ SqlColumnNumber = 3 ];

Property ProvideUserDr As %String [ SqlColumnNumber = 4 ];

Property ReceiveLocationDr As %String [ SqlColumnNumber = 5 ];

Property ReceiveUserDr As %String [ SqlColumnNumber = 6 ];

Property BatchNo As %String [ SqlColumnNumber = 7 ];

Property TransferDate As %Date [ SqlColumnNumber = 8 ];

Property TransferTime As %Time [ SqlColumnNumber = 9 ];

Property UomDr As DHCCL.Config.Uom [ SqlColumnNumber = 10 ];

Property Qty As %Float [ SqlColumnNumber = 11 ];

Property Price As %Float [ SqlColumnNumber = 12 ];

Property Amout As %Float [ SqlColumnNumber = 13 ];

Property ExpiryDate As %String [ SqlColumnNumber = 14 ];

/// 材料出库单号
Property FlowID As %String [ SqlColumnNumber = 15 ];

/// 高值耗材注册证号
Property RegCert As %String [ SqlColumnNumber = 16 ];

/// 高值耗材条码
Property BarCode As %String [ SqlColumnNumber = 17 ];

/// 耗材仓库代码
Property RespCode As %String [ SqlColumnNumber = 18 ];

/// 耗材仓库名称
Property RespDesc As %String [ SqlColumnNumber = 19 ];

/// 灭菌批号
Property SterilizationNo As %String [ SqlColumnNumber = 20 ];

/// 制造商
Property Manufacturer As %String [ SqlColumnNumber = 21 ];

/// 供应商
Property Vendor As %String [ SqlColumnNumber = 22 ];

/// 耗材项目名称
Property StockItemDesc As %String [ SqlColumnNumber = 23 ];

Index RecLocItem On (ReceiveLocationDr, StockItemDr);

Index Flow On FlowID;

Index UKey On (FlowID, StockItemDr, Qty) [ Unique ];

Index LocDate On (ReceiveLocationDr, TransferDate);

Index RespCode On RespCode;

Index BarCode On BarCode;

Storage Default
{
<Data name="StockTransferDefaultData">
<Value name="1">
<Value>StockItemDr</Value>
</Value>
<Value name="2">
<Value>ProvideLocationDr</Value>
</Value>
<Value name="3">
<Value>ProvideUserDr</Value>
</Value>
<Value name="4">
<Value>ReceiveLocationDr</Value>
</Value>
<Value name="5">
<Value>ReceiveUserDr</Value>
</Value>
<Value name="6">
<Value>BatchNo</Value>
</Value>
<Value name="7">
<Value>TransferDate</Value>
</Value>
<Value name="8">
<Value>TransferTime</Value>
</Value>
<Value name="9">
<Value>UomDr</Value>
</Value>
<Value name="10">
<Value>Qty</Value>
</Value>
<Value name="11">
<Value>Price</Value>
</Value>
<Value name="12">
<Value>Amout</Value>
</Value>
<Value name="13">
<Value>ExpiryDate</Value>
</Value>
<Value name="14">
<Value>FlowID</Value>
</Value>
<Value name="15">
<Value>RegCert</Value>
</Value>
<Value name="16">
<Value>BarCode</Value>
</Value>
<Value name="17">
<Value>RespCode</Value>
</Value>
<Value name="18">
<Value>RespDesc</Value>
</Value>
<Value name="19">
<Value>SterilizationNo</Value>
</Value>
<Value name="20">
<Value>Manufacturer</Value>
</Value>
<Value name="21">
<Value>Vendor</Value>
</Value>
<Value name="22">
<Value>StockItemDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.StockTransferD</DataLocation>
<DefaultData>StockTransferDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.StockTransferD</IdLocation>
<IndexLocation>^DHCCL.Model.StockTransferI</IndexLocation>
<StreamLocation>^DHCCL.Model.StockTransferS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
