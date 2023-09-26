Class DWR.DIA.MSG.DiagnosisInsRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 诊断ID
Property DiagnosisID As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosisInsRpDefaultData">
<Subscript>"DiagnosisInsRp"</Subscript>
<Value name="1">
<Value>DiagnosisID</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
</Data>
<DefaultData>DiagnosisInsRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
