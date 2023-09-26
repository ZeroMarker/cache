/// 名称: 病历模板分组子项表
/// 描述: 病历模板分组子项表
/// 编写者：叶剑
/// 编写日期: 2018-3-22
Class EMRmeta.EMRTemplateDocGroupItem Extends %Persistent
{

Index IdxGroupID On GroupID;

Index IdxCode On (GroupID, DocID) [ Unique ];

Index IdxSeq On (GroupID, Sequence, DocID);

/// 病历模板分组ID
Property GroupID As %String(MAXLEN = 200, TRUNCATE = 1);

/// EMRmeta.EMRTemplateCategory表CategoryType类型为CategoryChapter的ID
Property DocID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 顺序((分组下顺序))
Property Sequence As %Integer;

Storage Default
{
<Data name="EMRTemplateDocGroupItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupID</Value>
</Value>
<Value name="3">
<Value>DocID</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemDGroupItemD</DataLocation>
<DefaultData>EMRTemplateDocGroupItemDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRTemDGroupItemD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemDGroupItemI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemDGroupItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
