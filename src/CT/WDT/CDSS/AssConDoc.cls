/// Creator:李得原
/// CreatDate:2021-03-19
/// Description：评估表关联文献表
/// Table：CT.WDT.CDSS.AssConDoc
Class CT.WDT.CDSS.AssConDoc Extends (%Persistent, User.Abstract)
{

/// 评估表指针
Property AssDR As CT.WDT.CDSS.AssBase [ Required ];

/// 文献指针
Property DocDR As %String;

/// 新文献指针
Property NewDocDR As CT.WDT.CDSS.DocuManage;

Index AssIndex On AssDR;

Index DocIndex On DocDR;

Index AssConDocIndex On (AssDR, DocDR);

Index NewAssDocIndex On (AssDR, NewDocDR);

Storage Default
{
<Data name="AssConDocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssDR</Value>
</Value>
<Value name="3">
<Value>DocDR</Value>
</Value>
<Value name="4">
<Value>NewDocDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssConDocD</DataLocation>
<DefaultData>AssConDocDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssConDocD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssConDocI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssConDocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
