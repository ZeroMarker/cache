/// 名称:		EMRmeta.PrivRuleStore
/// 描述:		规则脚本仓库表
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class EMRmeta.PrivRuleStore Extends %Persistent
{

/// 规则描述
Property RuleDesc As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 规则代码
Property RuleCode As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 排序
Property Sequence As %Integer;

Storage Default
{
<Data name="PrivRuleStoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleDesc</Value>
</Value>
<Value name="3">
<Value>RuleCode</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PrivRuleStoreD</DataLocation>
<DefaultData>PrivRuleStoreDefaultData</DefaultData>
<IdLocation>^DHCEMRM.PrivRuleStoreD</IdLocation>
<IndexLocation>^DHCEMRM.PrivRuleStoreI</IndexLocation>
<StreamLocation>^DHCEMRM.PrivRuleStoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
