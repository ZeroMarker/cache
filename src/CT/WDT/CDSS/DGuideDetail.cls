/// Creator:谷雪萍
/// CreatDate:2021-11-2
/// Description：出院指导详情表
/// Table：CT.WDT.CDSS.DGuideDetail
Class CT.WDT.CDSS.DGuideDetail Extends (%Persistent, User.Abstract)
{

/// 出院指导指针
Property DGuideDR As CT.WDT.CDSS.DischargeGuide [ Required ];

/// 出院指导详情
Property DGuideDetail As %String(MAXLEN = "");

/// 出院指导详情顺序
Property DGuideOrder As %String;

Index DGuideDRIndex On DGuideDR As Exact;

Index DetailDRIndex On (DGuideDetail As Exact, DGuideDR As Exact);

Index OrderIndex On (DGuideDR, DGuideOrder As Exact);

Storage Default
{
<Data name="DGuideDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DGuideDR</Value>
</Value>
<Value name="3">
<Value>DGuideDetail</Value>
</Value>
<Value name="4">
<Value>DGuideOrder</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DGuideDetailD</DataLocation>
<DefaultData>DGuideDetailDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DGuideDetailD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DGuideDetailI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DGuideDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
