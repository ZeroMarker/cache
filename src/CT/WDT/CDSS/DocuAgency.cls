/// Creator:高姗姗
/// CreatDate:2021-09-28
/// Description：文献发布机构表
/// Table：CT.WDT.CDSS.DocuAgency
Class CT.WDT.CDSS.DocuAgency Extends (%Persistent, User.Abstract)
{

/// 发布机构代码
Property AgencyCode As %String(MAXLEN = 10) [ Required ];

/// 发布机构名称
Property AgencyDesc As %String(MAXLEN = "") [ Required ];

/// 机构优先级
Property AgencyPriority As %String;

Index CodeIndex On AgencyCode As Exact;

Index DescIndex On AgencyDesc As Exact;

Storage Default
{
<Data name="DocuAgencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AgencyCode</Value>
</Value>
<Value name="3">
<Value>AgencyDesc</Value>
</Value>
<Value name="4">
<Value>AgencyPriority</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DocuAgencyD</DataLocation>
<DefaultData>DocuAgencyDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DocuAgencyD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DocuAgencyI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DocuAgencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
