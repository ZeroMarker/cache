/// 名称: 科室模板分组子项表
/// 描述: 科室模板分组子项表
/// 编写者：叶剑
/// 编写日期: 2018-2-26
Class EMRmeta.UserTemplateGroupItem Extends %Persistent
{

Index IdxGroupID On GroupID;

Index IdxCode On (GroupID, Code) [ Unique ];

Index IdxSeq On (GroupID, Sequence, Code);

Index IdxUserCode On Code;

/// 科室模板分组ID
Property GroupID As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 科室模板代码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 顺序((分组下顺序))
Property Sequence As %Integer;

Storage Default
{
<Data name="UserTemplateGroupItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupID</Value>
</Value>
<Value name="3">
<Value>DiagnosCode</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateGroupItemD</DataLocation>
<DefaultData>UserTemplateGroupItemDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateGroupItemD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateGroupItemI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateGroupItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
