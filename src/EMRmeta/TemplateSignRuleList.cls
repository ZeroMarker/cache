/// Desc: 		模板签名规则表
/// Creator:	yejian
/// CreatDate:	2019-3-19
Class EMRmeta.TemplateSignRuleList Extends %Persistent
{

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 标题编码(唯一模板该值规定为"SINGLE")
Property TitleCode As %String;

/// 规则名称
Property TemRuleCode As %String(TRUNCATE = 1);

/// 规则描述
Property TemRuleDesc As %String(TRUNCATE = 1);

/// 规则值
Property TemRuleValue As %String(TRUNCATE = 1);

Index IndexTemTitle On (TemplateID, TitleCode);

Index IdxTemplateIDTitleRuleCodeValue On (TemplateID, TitleCode, TemRuleCode, TemRuleValue);

Storage Default
{
<Data name="TemplateSignRuleListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemRuleCode</Value>
</Value>
<Value name="3">
<Value>TemRuleDesc</Value>
</Value>
<Value name="4">
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>TitleCode</Value>
</Value>
<Value name="6">
<Value>TemRuleValue</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateSignRuleListD</DataLocation>
<DefaultData>TemplateSignRuleListDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TemplateSignRuleListD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateSignRuleListI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateSignRuleListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
