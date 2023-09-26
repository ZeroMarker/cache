/// 诊断记录
Class DWR.DIA.MSG.DiagnosisRecord Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "DiagnosisRec";

/// 诊断ID
Property DiagnosisID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 诊断类型
Property DiagnosisType As %String(MAXLEN = 50, TRUNCATE = 1);

/// ICDCode
Property ICDCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// ICDDesc
Property ICDDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 症状
Property Symptoms As %String(MAXLEN = 500, TRUNCATE = 1);

/// 注释
Property Remark As %String(MAXLEN = 500, TRUNCATE = 1);

/// 诊断医生
Property Doctor As %String(MAXLEN = 50, TRUNCATE = 1);

/// 诊断日期
Property UpdateDate As %String(MAXLEN = 50, TRUNCATE = 1);

/// 诊断时间
Property UpdateTime As %String(MAXLEN = 50, TRUNCATE = 1);

/// 本次诊断    (Y--诊断记录，N--历史诊断记录)
Property DiagnosisRecFlag As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosisRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiagnosisID</Value>
</Value>
<Value name="3">
<Value>DiagnosisType</Value>
</Value>
<Value name="4">
<Value>Doctor</Value>
</Value>
<Value name="5">
<Value>ICDCode</Value>
</Value>
<Value name="6">
<Value>ICDDesc</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>Symptoms</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DWR.DIA.MSG.DiagnosisRecordD</DataLocation>
<DefaultData>DiagnosisRecordDefaultData</DefaultData>
<IdLocation>^DWR.DIA.MSG.DiagnosisRecordD</IdLocation>
<IndexLocation>^DWR.DIA.MSG.DiagnosisRecordI</IndexLocation>
<StreamLocation>^DWR.DIA.MSG.DiagnosisRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
