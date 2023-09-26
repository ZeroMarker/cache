Class DWR.LOG.MSG.LoginRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 用户ID
Property UserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 用户名
Property UserCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 姓名
Property UserName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 所属科室和权限列表
Property DepartmentList As list Of DWR.LOG.MSG.Department;

Storage Default
{
<Data name="LoginRpDefaultData">
<Subscript>"LoginRp"</Subscript>
<Value name="1">
<Value>ResultCode</Value>
</Value>
<Value name="2">
<Value>ResultContent</Value>
</Value>
<Value name="3">
<Value>UserCode</Value>
</Value>
<Value name="4">
<Value>UserDepartments</Value>
</Value>
<Value name="5">
<Value>UserID</Value>
</Value>
<Value name="6">
<Value>UserName</Value>
</Value>
<Value name="7">
<Value>DepartmentList</Value>
</Value>
</Data>
<DefaultData>LoginRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
