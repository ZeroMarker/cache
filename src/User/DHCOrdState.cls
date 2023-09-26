Class User.DHCOrdState Extends (%Persistent, User.Abstract) [ SqlTableName = DHCOrdState ]
{

Index No On orderDetailId As Exact;

/// 订单编号
Property orderId As %String(COLLATION = "Exact");

///   订 单 名 称
Property orderName As %Library.String(COLLATION = "Exact");

///  订单提交时间
Property submitTime As %Library.String(COLLATION = "Exact");

///  订单备注
Property orderRemark As %Library.String(COLLATION = "Exact");

///  订单明细编号
Property orderDetailId As %Library.String(COLLATION = "Exact");

///  响应时间
Property confirmTime As %Library.String(COLLATION = "Exact");

///  拒绝理由
Property refuseReason As %Library.String(COLLATION = "Exact");

///  订单状态
Property orderDetailState As %Library.String(COLLATION = "Exact");

Storage Default
{
<Data name="DHCOrdStateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>orderId</Value>
</Value>
<Value name="3">
<Value>orderName</Value>
</Value>
<Value name="4">
<Value>submitTime</Value>
</Value>
<Value name="5">
<Value>orderRemark</Value>
</Value>
<Value name="6">
<Value>orderDetailId</Value>
</Value>
<Value name="7">
<Value>confirmTime</Value>
</Value>
<Value name="8">
<Value>refuseReason</Value>
</Value>
<Value name="9">
<Value>orderDetailState</Value>
</Value>
</Data>
<DataLocation>^User.DHCOrdStateD</DataLocation>
<DefaultData>DHCOrdStateDefaultData</DefaultData>
<IdLocation>^User.DHCOrdStateD</IdLocation>
<IndexLocation>^User.DHCOrdStateI</IndexLocation>
<StreamLocation>^User.DHCOrdStateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
