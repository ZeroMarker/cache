/// Creator:谷雪萍
/// CreatDate:2022-01-25
/// Description：中医疾病关联证候表
/// Table：CT_WDT_CDSS.TCMDiseJSym
Class CT.WDT.CDSS.TCMDiseJSym Extends (%Persistent, User.Abstract)
{

/// 中医疾病id
Property TCMDiseDR As CT.WDT.CDSS.TCMDisease [ Required ];

/// 证型（中医证候字典id）
Property TCMSymDR As CT.WDT.CDSS.TCMSymptom [ Required ];

/// 最后操作时间
Property UpdateDate As %TimeStamp;

/// 责任人
Property ResponUser As %String;

/// 审核人
Property ReviewUser As %String;

/// 状态（初始、编辑中、待审核、审核不通过、已上线、已下线，默认初始）
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 西医名称 指向疾病字典
Property DiseaseDR As CT.WDT.CDSS.DiseaseDict;

Index DiseDRIndex On TCMDiseDR;

Index DiseSymIndex On (TCMDiseDR, TCMSymDR);

Index SymIndex On TCMSymDR;

Index DiseTCMIndex On (TCMDiseDR, DiseaseDR);

Index TCMDiseSymIndex On (TCMDiseDR, DiseaseDR, TCMSymDR);

Storage Default
{
<Data name="TCMDiseJSymDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TCMDiseDR</Value>
</Value>
<Value name="3">
<Value>TCMSymDR</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
<Value name="5">
<Value>ResponUser</Value>
</Value>
<Value name="6">
<Value>ReviewUser</Value>
</Value>
<Value name="7">
<Value>State</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
<Value name="9">
<Value>DiseaseDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMDiseJSymD</DataLocation>
<DefaultData>TCMDiseJSymDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMDiseJSymD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMDiseJSymI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMDiseJSymS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
