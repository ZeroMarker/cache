Class User.DHCPaySate Extends (%Persistent, User.Abstract) [ SqlTableName = DHCPaySate, StorageStrategy = Default ]
{

Index No On orderDetailId As Exact;

///  明细编号
Property orderDetailId As %Library.String(COLLATION = "Exact");

/// 配送明细编号
Property distributeId As %String(COLLATION = "Exact");

///   订 单 名 称
Property orderName As %Library.String(COLLATION = "Exact");

///  商品ID
Property procurecatalogId As %Library.String(COLLATION = "Exact");

///  结算金额
Property realAmount As %Library.String(COLLATION = "Exact");

///  结算数量
Property realQuantity As %Library.String(COLLATION = "Exact");

///  生产企业名称
Property companyNameSc As %Library.String(COLLATION = "Exact");

///  配送明细编号
Property companyIdPs As %Library.String(COLLATION = "Exact");

///  配送企业名称
Property companyNamePs As %Library.String(COLLATION = "Exact");

///  发票号
Property invoiceId As %Library.String(COLLATION = "Exact");

///  收退货日期
Property storageDate As %Library.String(COLLATION = "Exact");

///  HIS单号
Property hosIngdNo As %Library.String(COLLATION = "Exact");

Storage Default
{
<Data name="DHCPaySateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>orderDetailId</Value>
</Value>
<Value name="3">
<Value>distributeId</Value>
</Value>
<Value name="4">
<Value>orderName</Value>
</Value>
<Value name="5">
<Value>procurecatalogId</Value>
</Value>
<Value name="6">
<Value>realAmount</Value>
</Value>
<Value name="7">
<Value>realQuantity</Value>
</Value>
<Value name="8">
<Value>companyNameSc</Value>
</Value>
<Value name="9">
<Value>companyIdPs</Value>
</Value>
<Value name="10">
<Value>companyNamePs</Value>
</Value>
<Value name="11">
<Value>invoiceId</Value>
</Value>
<Value name="12">
<Value>storageDate</Value>
</Value>
<Value name="13">
<Value>hosIngdNo</Value>
</Value>
</Data>
<DataLocation>^User.DHCPaySateD</DataLocation>
<DefaultData>DHCPaySateDefaultData</DefaultData>
<IdLocation>^User.DHCPaySateD</IdLocation>
<IndexLocation>^User.DHCPaySateI</IndexLocation>
<StreamLocation>^User.DHCPaySateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
