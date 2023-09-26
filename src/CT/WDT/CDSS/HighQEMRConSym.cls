/// Creator:谷雪萍
/// CreatDate:2023-03-21
/// Description：优质病历关联诊断因子表
/// Table：CT_WDT_CDSS.HighQEMRConSym
Class CT.WDT.CDSS.HighQEMRConSym Extends (%Persistent, User.Abstract)
{

/// 优质病历指针
Property EMRDR As CT.WDT.CDSS.HighQualityEMR [ Required ];

/// 病历节点（主诉/现病史）
Property EMRNode As %String [ Required ];

/// 症状顺序号
Property SymptomNum As %Integer [ Required ];

/// 症状
Property Symptom As %String;

/// 持续时长
Property Duration As %String;

/// 异常最大值
Property AbnormalMax As %Float;

/// 异常最小值
Property AbnormalMin As %Float;

/// 正常最大值
Property NormalMax As %Float;

/// 正常最小值
Property NormalMin As %Float;

/// 值域单位
Property RangeUnit As %String;

/// 值域类型
Property RangeType As %String;

/// 病因
Property Cause As %String(MAXLEN = "");

/// 症状类型
Property SymptomType As %String;

/// 归一词
Property SymptomFormal As %String(MAXLEN = 100);

/// 上位词
Property SymptomCore As %String(MAXLEN = 100);

/// 症状属性
Property SymProperty As %String(MAXLEN = 300);

/// 孩子集合
Property SymptomChildren As %String(MAXLEN = 300);

/// 部位
Property PartDR As CT.WDT.CDSS.BodyPartsDict;

/// 方位
Property PositionWordDR As CT.WDT.CDSS.PositionWord;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index SymptomEMRIndex On (Symptom As Exact, EMRDR);

Index EMRDRIndex On EMRDR;

Index SymptomNumIndex On (EMRDR, SymptomNum);

Storage Default
{
<Data name="HighQEMRConSymDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMRDR</Value>
</Value>
<Value name="3">
<Value>EMRNode</Value>
</Value>
<Value name="4">
<Value>SymptomNum</Value>
</Value>
<Value name="5">
<Value>Symptom</Value>
</Value>
<Value name="6">
<Value>Duration</Value>
</Value>
<Value name="7">
<Value>AbnormalMax</Value>
</Value>
<Value name="8">
<Value>AbnormalMin</Value>
</Value>
<Value name="9">
<Value>NormalMax</Value>
</Value>
<Value name="10">
<Value>NormalMin</Value>
</Value>
<Value name="11">
<Value>RangeUnit</Value>
</Value>
<Value name="12">
<Value>RangeType</Value>
</Value>
<Value name="13">
<Value>Cause</Value>
</Value>
<Value name="14">
<Value>SymptomType</Value>
</Value>
<Value name="15">
<Value>SymptomFormal</Value>
</Value>
<Value name="16">
<Value>SymptomCore</Value>
</Value>
<Value name="17">
<Value>SymProperty</Value>
</Value>
<Value name="18">
<Value>SymptomChildren</Value>
</Value>
<Value name="19">
<Value>PartDR</Value>
</Value>
<Value name="20">
<Value>PositionWordDR</Value>
</Value>
<Value name="21">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.HighQEMRConSymD</DataLocation>
<DefaultData>HighQEMRConSymDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.HighQEMRConSymD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.HighQEMRConSymI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.HighQEMRConSymS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
