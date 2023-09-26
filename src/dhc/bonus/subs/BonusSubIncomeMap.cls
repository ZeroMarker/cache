/// SH收入数据汇总映射
Class dhc.bonus.subs.BonusSubIncomeMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubIncomeMapID ]
{

Property BonusSubMainID As dhc.bonus.subs.BonusSubMain [ SqlColumnNumber = 2 ];

Property BonusSubIncomeDetailID As dhc.bonus.subs.BonusSubIncomeDetail [ SqlColumnNumber = 3 ];

Storage Default
{
<Data name="BonusSubIncomeMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSubIncomeDetailID</Value>
</Value>
<Value name="3">
<Value>IsValid</Value>
</Value>
<Value name="4">
<Value>SubItemCode</Value>
</Value>
<Value name="5">
<Value>SubItemName</Value>
</Value>
<Value name="6">
<Value>SuperiorItemID</Value>
</Value>
<Value name="7">
<Value>BonusSubMainID</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubIncomeMapD</DataLocation>
<DefaultData>BonusSubIncomeMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubIncomeMapD</IdLocation>
<IndexLocation>^dhcbsSubIncomeMapI</IndexLocation>
<StreamLocation>^dhcbsSubIncomeMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
