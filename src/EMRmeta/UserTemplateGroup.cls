/// 名称: 科室模板分组关联表
/// 描述: 科室模板分组关联表
/// 编写者：叶剑
/// 编写日期: 2018-2-26
Class EMRmeta.UserTemplateGroup Extends %Persistent
{

Index IdxParentID On ParentID;

Index IdxCTLocID On CTLocID;

Index IdxGroupCode On GroupCode;

Index IdxSeq On (ParentID, Sequence);

Index IdxLocSeq On (CTLocID, ParentID, Sequence);

Index IdxCTLocGroupCode On (CTLocID, GroupCode);

Index IdxLocParent On (CTLocID, ParentID);

Index IdxDOCIDLocSeq On (EMRDocID, CTLocID, ParentID, Sequence);

/// 科室模板分组代码
Property GroupCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 科室模板分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

/// TemplateID
Property TemplateID As %String;

/// 病历展现结构，业务活动记录ID
Property EMRDocID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserTemplateGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupCode</Value>
</Value>
<Value name="3">
<Value>GroupName</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>TemplateID</Value>
</Value>
<Value name="8">
<Value>EMRDocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateGroupD</DataLocation>
<DefaultData>UserTemplateGroupDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateGroupD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
