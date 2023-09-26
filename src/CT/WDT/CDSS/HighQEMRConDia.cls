/// Creator:谷雪萍
/// CreatDate:2023-03-21
/// Description：优质病历关联诊断表
/// Table：CT_WDT_CDSS.HighQEMRConDia
Class CT.WDT.CDSS.HighQEMRConDia Extends (%Persistent, User.Abstract)
{

/// 优质病历指针
Property EMRDR As CT.WDT.CDSS.HighQualityEMR [ Required ];

/// 诊断分类（中医、西医、证型）
Property DiagnosisClass As %String(MAXLEN = 10) [ Required ];

/// 中医/西医/证型名称
Property DiagnosisName As %String [ Required ];

/// 诊断顺序号
Property DiagnosisSequence As %Integer [ Required ];

/// 是否主诊断（1-是，0-否）
Property IsMainDiagnosis As %Integer [ InitialExpression = 0, Required ];

/// 诊断来源（确诊诊断：1，初步诊断：2，修正诊断：3，补充诊断：4）
Property DiagnosisType As %String(MAXLEN = 10) [ Required ];

/// 备注
Property Remarks As %String(MAXLEN = "");

Index DiagEMRDRIndex On (DiagnosisClass As Exact, DiagnosisName As Exact, EMRDR);

Index DiagNameEMRDRIndex On (DiagnosisName As Exact, IsMainDiagnosis, EMRDR);

Index EMRDRIndex On EMRDR;

Index EMRDRDiagnosisSequenceIndex On (EMRDR As Exact, DiagnosisSequence);

Storage Default
{
<Data name="HighQEMRConDiaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMRDR</Value>
</Value>
<Value name="3">
<Value>DiagnosisClass</Value>
</Value>
<Value name="4">
<Value>DiagnosisName</Value>
</Value>
<Value name="5">
<Value>DiagnosisSequence</Value>
</Value>
<Value name="6">
<Value>IsMainDiagnosis</Value>
</Value>
<Value name="7">
<Value>DiagnosisType</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.HighQEMRConDiaD</DataLocation>
<DefaultData>HighQEMRConDiaDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.HighQEMRConDiaD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.HighQEMRConDiaI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.HighQEMRConDiaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
