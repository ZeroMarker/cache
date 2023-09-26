Class User.DHCRetState Extends (%Persistent, User.Abstract) [ SqlTableName = DHCRetState ]
{

Index No On returnID As Exact;

/// 退货明细编号
Property returnID As %String(COLLATION = "Exact");

///   配送明细编号
Property distributionSerialID As %Library.String(COLLATION = "Exact");

///   退货类型
Property returnType As %Library.String(COLLATION = "Exact");

///   退货响应时间
Property returnResponseTime As %Library.String(COLLATION = "Exact");

///   是否响应
Property isResponse As %Library.String(COLLATION = "Exact");

///   拒绝原因
Property refuseReason As %Library.String(COLLATION = "Exact");

///   发票号
Property returnInvoiceId As %Library.String(COLLATION = "Exact");

///   维护发票时间
Property returnMaintenanceInvoiceTime As %Library.String(COLLATION = "Exact");

Storage Default
{
<Data name="DHCRetStateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>returnID</Value>
</Value>
<Value name="3">
<Value>distributionSerialID</Value>
</Value>
<Value name="4">
<Value>returnType</Value>
</Value>
<Value name="5">
<Value>returnResponseTime</Value>
</Value>
<Value name="6">
<Value>isResponse</Value>
</Value>
<Value name="7">
<Value>refuseReason</Value>
</Value>
<Value name="8">
<Value>returnInvoiceId</Value>
</Value>
<Value name="9">
<Value>returnMaintenanceInvoiceTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCRetStateD</DataLocation>
<DefaultData>DHCRetStateDefaultData</DefaultData>
<IdLocation>^User.DHCRetStateD</IdLocation>
<IndexLocation>^User.DHCRetStateI</IndexLocation>
<StreamLocation>^User.DHCRetStateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
