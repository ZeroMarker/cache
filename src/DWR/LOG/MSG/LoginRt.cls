/// 登录信息
Class DWR.LOG.MSG.LoginRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 用户名
Property UserCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 密码
Property Password As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="LoginRtDefaultData">
<Subscript>"LoginRt"</Subscript>
<Value name="1">
<Value>Password</Value>
</Value>
<Value name="2">
<Value>UserName</Value>
</Value>
<Value name="3">
<Value>UserCode</Value>
</Value>
<Value name="4">
<Value>ResultCode</Value>
</Value>
<Value name="5">
<Value>ResultContent</Value>
</Value>
</Data>
<DefaultData>LoginRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
