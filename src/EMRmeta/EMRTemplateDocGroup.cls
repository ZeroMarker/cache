/// 名称: 病历模板分组关联表
/// 描述: 病历模板分组关联表
/// 编写者：叶剑
/// 编写日期: 2018-3-22
Class EMRmeta.EMRTemplateDocGroup Extends %Persistent
{

Index IdxParentID On ParentID;

Index IdxCTLocID On CTLocID;

Index IdxGroupCode On GroupCode;

Index IdxSeq On (ParentID, Sequence);

Index IdxLocSeq On (CTLocID, ParentID, Sequence);

Index IdxCTLocGroupCode On (CTLocID, GroupCode);

/// 病历模板分组代码
Property GroupCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病历模板分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Storage Default
{
<Data name="EMRTemplateDocGroupDefaultData">
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
</Data>
<DataLocation>^DHCEMRM.EMRTemplateDocGroupD</DataLocation>
<DefaultData>EMRTemplateDocGroupDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRTemplateDocGroupD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplateDocGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplateDocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
