/// 科室在院患者查询
Class DWR.PAT.MSG.PatientQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 科室ID
Property DepartmentID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 患者ID
Property PatientID As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="PatientQryRtDefaultData">
<Subscript>"PatientQryRt"</Subscript>
<Value name="1">
<Value>DeportmentCode</Value>
</Value>
<Value name="2">
<Value>DeportmentID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>DepartmentID</Value>
</Value>
</Data>
<DefaultData>PatientQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
