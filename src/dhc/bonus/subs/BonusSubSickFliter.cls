/// SH奖金辅助费用类别过滤BonusExpensesFliter
/// 
Class dhc.bonus.subs.BonusSubSickFliter Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubExpensesFliterID ]
{

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

Property SickFlagCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property SickFlagName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Index BonusTargetIDIndex On BonusTargetID As exact;

Index TargetSick On (BonusTargetID, SickFlagCode);

Storage Default
{
<Data name="BonusSubSickFliterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>SickFlagCode</Value>
</Value>
<Value name="4">
<Value>SickFlagName</Value>
</Value>
</Data>
<DataLocation>^dhcbsSickFliterD</DataLocation>
<DefaultData>BonusSubSickFliterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSickFliterD</IdLocation>
<IndexLocation>^dhcbsSickFliterI</IndexLocation>
<StreamLocation>^dhcbsSickFliterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
