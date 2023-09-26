Class DWR.DIA.MSG.DiagnosisRecQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 患者ID
Property PatientID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊ID
Property EpisodeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 历史诊断             (Y--仅历史诊断,N--仅本次诊断,空--全部)
Property Diagnosishistory As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosisRecQryRtDefaultData">
<Subscript>"DiagnosisRecQryRt"</Subscript>
<Value name="1">
<Value>PatientID</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
</Data>
<DefaultData>DiagnosisRecQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
