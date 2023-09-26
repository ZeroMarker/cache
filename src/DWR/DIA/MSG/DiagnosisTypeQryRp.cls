Class DWR.DIA.MSG.DiagnosisTypeQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 诊断类型列表
Property DiaTypeList As list Of DWR.DIA.MSG.DiagnosisType;

Storage Default
{
<Data name="DiagnosisTypeQryRpDefaultData">
<Subscript>"DiagnosisTypeQryRp"</Subscript>
<Value name="1">
<Value>DiaTypes</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
<Value name="4">
<Value>DiaTypeList</Value>
</Value>
</Data>
<DefaultData>DiagnosisTypeQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
