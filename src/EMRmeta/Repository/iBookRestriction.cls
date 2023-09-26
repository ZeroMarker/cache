/// 名称:EMRmeta.Repository.iBookRestriction
/// 描述:联机文献主表
/// 编写者：guozongtao
/// 编写日期: 2014-8-19
Class EMRmeta.Repository.iBookRestriction Extends %Persistent
{

/// 联机文档目录表ID
Property iBookCategoryID As %String;

/// 规则条件的项目ID组成的串
Property RuleItemID As %String;

/// 规则条件的项目描述
Property RuleItemDesc As %String;

Index IdxCategoryID On iBookCategoryID;

Index IdxRuleID On RuleItemID;

Index IdxCateRule On (iBookCategoryID, RuleItemID);

Storage Default
{
<Data name="iBookRestrictionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>iBookCategoryID</Value>
</Value>
<Value name="3">
<Value>RuleItemID</Value>
</Value>
<Value name="4">
<Value>RuleItemDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.iBookRestrictionD</DataLocation>
<DefaultData>iBookRestrictionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.iBookRestrictionD</IdLocation>
<IndexLocation>^DHCEMRM.iBookRestrictionI</IndexLocation>
<StreamLocation>^DHCEMRM.iBookRestrictionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
