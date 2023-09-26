/// SH奖金指标过滤BonusSubTargetFilter
Class dhc.bonus.subs.BonusSubTargetFilter Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubTargetFilterID ]
{

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 3 ];

Index TargetSubItem On (BonusSubItemID, BonusTargetID);

Index BonusTargetIDIndex On BonusTargetID As exact;

Storage Default
{
<Data name="BonusSubTargetFilterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSubItemID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubTargetFilterD</DataLocation>
<DefaultData>BonusSubTargetFilterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubTargetFilterD</IdLocation>
<IndexLocation>^dhcbsSubTargetFilterI</IndexLocation>
<StreamLocation>^dhcbsSubTargetFilterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
