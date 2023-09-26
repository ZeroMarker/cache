/// 查询ICD
Class DWR.DIA.MSG.ICDQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 科室ID
Property DepartmentID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 索引字符串
Property FindIndexStr As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="ICDQryRtDefaultData">
<Subscript>"ICDQryRt"</Subscript>
<Value name="1">
<Value>DepartmentID</Value>
</Value>
<Value name="2">
<Value>FindIndexStr</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
</Data>
<DefaultData>ICDQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
