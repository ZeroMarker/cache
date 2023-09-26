/// Creator:高姗姗
/// CreatDate:2020-12-17
/// Description：文献关联诊断表
/// Table：CT.WDT.CDSS.DocuJoinDisease
Class CT.WDT.CDSS.DocuJoinDisease Extends (%Persistent, User.Abstract)
{

/// 文献指向 文献管理表
Property DocuDR As CT.WDT.CDSS.DocuManage [ Required ];

/// 诊断指向 疾病字典表
Property DiseaseDR As CT.WDT.CDSS.DiseaseDict;

/// 修改时间
Property DocuModifyDate As %TimeStamp;

/// 修改人
Property DocuModifyUser As %String;

/// 识别词指向 识别词字典表
Property WordsDR As CT.WDT.CDSS.IdentifyWords;

/// 识别词指向 识别词字典表[识别条件]
Property IWordsDR As CT.WDT.CDSS.IdentifyWords;

Index DocuIndex On DocuDR;

Index DocuDiseaseIndex On (DocuDR, DiseaseDR);

Index DiseaseDocuIndex On (DiseaseDR, DocuDR);

Index DiseIndex On DiseaseDR;

/// 2022-08-16 ZWW 新增
Index DocuWordsIndex On (DocuDR, WordsDR);

/// 2022-09-02 ZWW 新增
Index DocuIWordsIndex On (DocuDR, IWordsDR);

Index WordsDRIndex On WordsDR;

Index IWordsDRIndex On IWordsDR;

Storage Default
{
<Data name="DocuJoinDiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocuDR</Value>
</Value>
<Value name="3">
<Value>DiseaseDR</Value>
</Value>
<Value name="4">
<Value>DocuModifyDate</Value>
</Value>
<Value name="5">
<Value>DocuModifyUser</Value>
</Value>
<Value name="6">
<Value>WordsDR</Value>
</Value>
<Value name="7">
<Value>IWordsDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DocuJoinDiseaseD</DataLocation>
<DefaultData>DocuJoinDiseaseDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DocuJoinDiseaseD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DocuJoinDiseaseI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DocuJoinDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
