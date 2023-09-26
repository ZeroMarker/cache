/// 名称:		EMRmeta.PrivRuleDetail
/// 描述:		脚本规则表
/// 编写者：	yejian
/// 编写日期: 	2021-11-23
/// 产品组：	电子病历产品组
Class EMRmeta.PrivRuleDetail Extends %Persistent
{

Index IdxPrivRuleIDSeq On (PrivRule, Sequence);

Index IdxPrivRuleStore On PrivRuleStore;

/// 关联权限规则表 EMRmeta.PrivRule
Property PrivRule As EMRmeta.PrivRule;

/// 名称
Property RuleDesc As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 脚本
Property RuleCode As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 关联仓库
Property PrivRuleStore As EMRmeta.PrivRuleStore;

/// 院区分组ID
Property HospGroupID As %String;

/// 规则类型
Property PrivRuleType As EMRmeta.PrivRuleType;

/// 是否启用 1:启用，0:不启用
Property IsActive As %String;

/// 顺序
Property Sequence As %Integer;

Storage Default
{
<Data name="PrivRuleDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrivRule</Value>
</Value>
<Value name="3">
<Value>RuleDesc</Value>
</Value>
<Value name="4">
<Value>RuleCode</Value>
</Value>
<Value name="5">
<Value>PrivRuleStore</Value>
</Value>
<Value name="6">
<Value>HospGroupID</Value>
</Value>
<Value name="7">
<Value>PrivRuleType</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PrivRuleDetailD</DataLocation>
<DefaultData>PrivRuleDetailDefaultData</DefaultData>
<IdLocation>^DHCEMRM.PrivRuleDetailD</IdLocation>
<IndexLocation>^DHCEMRM.PrivRuleDetailI</IndexLocation>
<StreamLocation>^DHCEMRM.PrivRuleDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
