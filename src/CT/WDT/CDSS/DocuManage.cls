/// Creator:高姗姗
/// CreatDate:2020-12-17
/// Description：文献管理表
/// Table：CT.WDT.CDSS.DocuManage
Class CT.WDT.CDSS.DocuManage Extends (%Persistent, User.Abstract)
{

/// 文献代码
Property DocuCode As %String(MAXLEN = 10) [ Required ];

/// 中文文献名称
Property DocuDesc As %String(MAXLEN = "") [ Required ];

/// 英文文献名称
Property DocuEngDesc As %String(MAXLEN = "");

/// 文献路径
Property DocuPath As %String(MAXLEN = "");

/// 关键词 中间用,分隔
Property DocuKeyWords As %String(MAXLEN = "");

/// 类型(评论、经验交流、病例报告、学术动态、专题评论、专题笔谈、临床指南)
Property DocuType As %String;

/// 发布机构
Property DocuInstitution As CT.WDT.CDSS.DocuAgency;

/// 指南出处
Property DocuSource As %String(MAXLEN = "");

/// 发布年月
Property DocuMonth As %String;

/// 关联文献 中间用,分隔
Property DocuAssociation As %String;

/// 状态(编辑中、待审核、不通过、上线、已下线)
Property DocuState As %String;

/// 修改时间
Property DocuModifyDate As %TimeStamp;

/// 修改人
Property DocuModifyUser As %String;

/// 审核人
Property DocuReviewer As %String;

Index CodeIndex On DocuCode As Exact;

Index DescIndex On DocuDesc As Exact;

Index DateIndex On DocuModifyDate;

Index ModifyUserIndex On DocuModifyUser As Exact;

Index ReviewerIndex On DocuReviewer As Exact;

Index InstitutionIndex On DocuInstitution;

Index DocuTypeIndex On (DocuType As Exact, DocuMonth As Exact);

Index DocuMonthIndex On DocuMonth As Exact;

Storage Default
{
<Data name="DocuManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocuCode</Value>
</Value>
<Value name="3">
<Value>DocuDesc</Value>
</Value>
<Value name="4">
<Value>DocuEngDesc</Value>
</Value>
<Value name="5">
<Value>DocuPath</Value>
</Value>
<Value name="6">
<Value>DocuKeyWords</Value>
</Value>
<Value name="7">
<Value>DocuType</Value>
</Value>
<Value name="8">
<Value>DocuInstitution</Value>
</Value>
<Value name="9">
<Value>DocuSource</Value>
</Value>
<Value name="10">
<Value>DocuMonth</Value>
</Value>
<Value name="11">
<Value>DocuAssociation</Value>
</Value>
<Value name="12">
<Value>DocuState</Value>
</Value>
<Value name="13">
<Value>DocuModifyDate</Value>
</Value>
<Value name="14">
<Value>DocuModifyUser</Value>
</Value>
<Value name="15">
<Value>DocuReviewer</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DocuManageD</DataLocation>
<DefaultData>DocuManageDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DocuManageD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DocuManageI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DocuManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
