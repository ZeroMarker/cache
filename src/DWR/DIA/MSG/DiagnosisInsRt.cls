/// 新增诊断
Class DWR.DIA.MSG.DiagnosisInsRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 就诊ID
Property EpisodeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 诊断类型ID
Property DiagnosisTypeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// ICDCode
Property ICDCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// ICDID
Property ICDID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 症状
Property Symptoms As %String(MAXLEN = 500, TRUNCATE = 1);

/// 注释
Property Remark As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosisInsRtDefaultData">
<Subscript>"DiagnosisInsRt"</Subscript>
<Value name="1">
<Value>DiagnosisTypeID</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ICDCode</Value>
</Value>
<Value name="4">
<Value>ICDID</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>Symptoms</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
</Data>
<DefaultData>DiagnosisInsRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
