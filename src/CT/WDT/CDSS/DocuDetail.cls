/// Creator:高姗姗
/// CreatDate:2020-12-17
/// Description：文献详情表
/// Table：CT.WDT.CDSS.DocuDetail
Class CT.WDT.CDSS.DocuDetail Extends (%Persistent, User.Abstract)
{

/// 文献指向 文献管理表
Property DocuDR As CT.WDT.CDSS.DocuManage [ Required ];

/// 文献详情标题
Property Title As %String [ Required ];

/// 文献详情内容
Property Content As %String(MAXLEN = "");

/// 文献详情父级
Property ParentDR As CT.WDT.CDSS.DocuDetail;

Index DocuIndex On DocuDR;

Index DocuParentIndex On (DocuDR, ParentDR);

Index DocuTitleIndex On (DocuDR, Title As Exact);

Storage Default
{
<Data name="DocuDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocuDR</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
<Value name="4">
<Value>Content</Value>
</Value>
<Value name="5">
<Value>ParentDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DocuDetailD</DataLocation>
<DefaultData>DocuDetailDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DocuDetailD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DocuDetailI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DocuDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
