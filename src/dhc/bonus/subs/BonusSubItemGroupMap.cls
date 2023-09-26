/// SH奖金辅助项目组映射BonusSubItemGroupMap
Class dhc.bonus.subs.BonusSubItemGroupMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubItemGroupMapID ]
{

Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 2 ];

Property BonusSubItemGroupID As dhc.bonus.subs.BonusSubItemGroup [ SqlColumnNumber = 3 ];

Index Parent On (BonusSubItemGroupID, BonusSubItemID);

Storage Default
{
<Data name="BonusSubItemGroupMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSubItemGroupID</Value>
</Value>
<Value name="3">
<Value>BonusSubItemID</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubItemGroupMapD</DataLocation>
<DefaultData>BonusSubItemGroupMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubItemGroupMapD</IdLocation>
<IndexLocation>^dhcbsSubItemGroupMapI</IndexLocation>
<StreamLocation>^dhcbsSubItemGroupMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
