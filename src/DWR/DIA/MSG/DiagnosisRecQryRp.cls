Class DWR.DIA.MSG.DiagnosisRecQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 诊断记录分组列表
Property DiagnosisRecGroupList As list Of DWR.DIA.MSG.DiagnosisRecGroup;

Storage Default
{
<Data name="DiagnosisRecQryRpDefaultData">
<Subscript>"DiagnosisRecQryRp"</Subscript>
<Value name="1">
<Value>DiagnosisRecords</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
<Value name="4">
<Value>DiagnosisRecList</Value>
</Value>
</Data>
<DefaultData>DiagnosisRecQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
