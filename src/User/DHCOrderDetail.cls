Class User.DHCOrderDetail Extends %Persistent [ Owner = {_SYSTEM} ]
{

/// 平台订单子表的id
Property OrderDetailSubId As %Library.String(COLLATION = "Exact", MAXLEN = 100);

/// 平台订单表的随行单号
Property OrderNo As %Library.String(COLLATION = "Exact", MAXLEN = 100);

/// His订单子表的id
Property InPoiId As User.INPOItm;

Index DetailSubId On OrderDetailSubId As Exact;

Storage Default
{
<Data name="DHCOrderDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderDetailSubId</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>InPoiId</Value>
</Value>
</Data>
<DataLocation>^User.DHCOrderDetailD</DataLocation>
<DefaultData>DHCOrderDetailDefaultData</DefaultData>
<IdLocation>^User.DHCOrderDetailD</IdLocation>
<IndexLocation>^User.DHCOrderDetailI</IndexLocation>
<StreamLocation>^User.DHCOrderDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
