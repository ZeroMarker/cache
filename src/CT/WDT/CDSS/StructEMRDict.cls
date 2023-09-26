/// Creator:谷雪萍
/// CreatDate:2023-03-02
/// Description：结构化电子病历知识库表
/// Table：CT_WDT_CDSS.StructEMRDict
Class CT.WDT.CDSS.StructEMRDict Extends (%Persistent, User.Abstract)
{

/// 中医疾病
Property DiseaseDR As CT.WDT.CDSS.TCMDisease [ Required ];

/// 中医证候
Property TCMSymptomDR As CT.WDT.CDSS.TCMSymptom [ Required ];

/// 科室
Property LocDR As CT.WDT.CDSS.DiseaseDeptDict;

/// 临床症状
Property ClinicalSymptoms As %String(MAXLEN = "");

/// 治则法治
Property TCMTreatment As %String(MAXLEN = "");

/// 方药
Property TCMPrescription As %String(MAXLEN = "");

/// 中医非药物治疗
Property NoMedicineTreat As %String(MAXLEN = "");

/// 使用标志（0已审核，1编辑中）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index DiaSymIndex On (DiseaseDR, TCMSymptomDR);

Index DateIndex On UpdateDate;

Storage Default
{
<Data name="StructEMRDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseDR</Value>
</Value>
<Value name="3">
<Value>TCMSymptomDR</Value>
</Value>
<Value name="4">
<Value>LocDR</Value>
</Value>
<Value name="5">
<Value>ClinicalSymptoms</Value>
</Value>
<Value name="6">
<Value>TCMTreatment</Value>
</Value>
<Value name="7">
<Value>TCMPrescription</Value>
</Value>
<Value name="8">
<Value>NoMedicineTreat</Value>
</Value>
<Value name="9">
<Value>UseFlag</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.StructEMRDictD</DataLocation>
<DefaultData>StructEMRDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.StructEMRDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.StructEMRDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.StructEMRDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
