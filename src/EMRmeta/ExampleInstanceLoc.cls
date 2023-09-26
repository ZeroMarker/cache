/// Description:范例病历节点与科室关联
/// Creator:    DongLulu
/// CreateDate: 2019-5-7
Class EMRmeta.ExampleInstanceLoc Extends (%Persistent, %XML.Adaptor)
{

/// EMRmeta.ExampleInstance表ID
Property ExampleID As %Integer;

/// 分享者UserID
Property UserID As %String;

/// 科室ID
Property CTLocID As %String;

/// 模板ID
Property TemplateID As %String;

Index IdxTemplateLocExample On (TemplateID, CTLocID, ExampleID);

Storage Default
{
<Data name="ExampleInstanceLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExampleID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>TemplateID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ExamInsLocD</DataLocation>
<DefaultData>ExampleInstanceLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ExamInsLocD</IdLocation>
<IndexLocation>^DHCEMRM.ExamInsLocI</IndexLocation>
<StreamLocation>^DHCEMRM.ExamInsLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
