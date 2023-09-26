Class DWR.PAT.MSG.PatientQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 患者列表
Property PatientList As list Of DWR.PAT.MSG.Patient;

Storage Default
{
<Data name="PatientQryRpDefaultData">
<Subscript>"PatientQryRp"</Subscript>
<Value name="1">
<Value>Patients</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
<Value name="4">
<Value>PatientList</Value>
</Value>
</Data>
<DefaultData>PatientQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
