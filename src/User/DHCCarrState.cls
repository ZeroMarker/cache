Class User.DHCCarrState Extends (%Persistent, User.Abstract) [ SqlTableName = DHCCarrState ]
{

Index No On orderDetailId As Exact;

///  医院编号
Property hospitalId As %String(COLLATION = "Exact");

///  订单明细编号
Property orderDetailId As %Library.String(COLLATION = "Exact");

///  配送明细编号
Property distributeId As %Library.String(COLLATION = "Exact");

///  采购价格
Property purchasePrice As %Library.String(COLLATION = "Exact");

///  票发票号
Property invoiceId As %Library.String(COLLATION = "Exact");

///  票发票代码
Property invoiceCode As %Library.String(COLLATION = "Exact");

///  批号
Property batchCode As %Library.String(COLLATION = "Exact");

///  有 效 期
Property periodDate As %Library.String(COLLATION = "Exact");

///  配 送 数 量
Property distributeCount As %Library.String(COLLATION = "Exact");

///  配送时间
Property distributeTime As %Library.String(COLLATION = "Exact");

///  收货数量
Property warehouseCount As %Library.String(COLLATION = "Exact");

///  收货时间
Property warehouseTime As %Library.String(COLLATION = "Exact");

///  自定义配送信息
Property distributeCustomInfo As %Library.String(COLLATION = "Exact");

///  配送地址
Property detailDistributeAddress As %Library.String(COLLATION = "Exact");

///  多个发票id
Property invoicePrimaryIds As %Library.String(COLLATION = "Exact");

///  产品id
Property goodsId As %Library.String(COLLATION = "Exact");

///  规格
Property outLookc As %Library.String(COLLATION = "Exact");

///  型号
Property model As %Library.String(COLLATION = "Exact");

///  投标企业id
Property companyIdTb As %Library.String(COLLATION = "Exact");

///  投标企业名称
Property companyNameTb As %Library.String(COLLATION = "Exact");

///  配送企业id
Property companyIdPs As %Library.String(COLLATION = "Exact");

///  配送企业名称
Property companyNamePs As %Library.String(COLLATION = "Exact");

Storage Default
{
<Data name="DHCCarrStateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>hospitalId</Value>
</Value>
<Value name="3">
<Value>orderDetailId</Value>
</Value>
<Value name="4">
<Value>distributeId</Value>
</Value>
<Value name="5">
<Value>purchasePrice</Value>
</Value>
<Value name="6">
<Value>invoiceId</Value>
</Value>
<Value name="7">
<Value>invoiceCode</Value>
</Value>
<Value name="8">
<Value>batchCode</Value>
</Value>
<Value name="9">
<Value>periodDate</Value>
</Value>
<Value name="10">
<Value>distributeCount</Value>
</Value>
<Value name="11">
<Value>distributeTime</Value>
</Value>
<Value name="12">
<Value>warehouseCount</Value>
</Value>
<Value name="13">
<Value>warehouseTime</Value>
</Value>
<Value name="14">
<Value>distributeCustomInfo</Value>
</Value>
<Value name="15">
<Value>detailDistributeAddress</Value>
</Value>
<Value name="16">
<Value>invoicePrimaryIds</Value>
</Value>
<Value name="17">
<Value>goodsId</Value>
</Value>
<Value name="18">
<Value>outLookc</Value>
</Value>
<Value name="19">
<Value>model</Value>
</Value>
<Value name="20">
<Value>companyIdTb</Value>
</Value>
<Value name="21">
<Value>companyNameTb</Value>
</Value>
<Value name="22">
<Value>companyIdPs</Value>
</Value>
<Value name="23">
<Value>companyNamePs</Value>
</Value>
</Data>
<DataLocation>^User.DHCCarrStateD</DataLocation>
<DefaultData>DHCCarrStateDefaultData</DefaultData>
<IdLocation>^User.DHCCarrStateD</IdLocation>
<IndexLocation>^User.DHCCarrStateI</IndexLocation>
<StreamLocation>^User.DHCCarrStateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
