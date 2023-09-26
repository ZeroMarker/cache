/// SH支出数据汇总映射BonusSubExpendMap
Class dhc.bonus.subs.BonusSubExpendMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubExpendMapID ]
{

Property BonusSubMainID As dhc.bonus.subs.BonusSubMain [ SqlColumnNumber = 2 ];

Property BonusSubExpendDetailID As dhc.bonus.subs.BonusSubExpendDetail [ SqlColumnNumber = 3 ];

Storage Default
{
<Data name="BonusSubExpendMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSubExpendDetailID</Value>
</Value>
<Value name="3">
<Value>BonusSubMainID</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubExpendMapD</DataLocation>
<DefaultData>BonusSubExpendMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubExpendMapD</IdLocation>
<IndexLocation>^dhcbsSubExpendMapI</IndexLocation>
<StreamLocation>^dhcbsSubExpendMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
