/// SH奖金辅助费用类别过滤BonusExpensesFliter
/// 
/// 1：门诊
/// 2：住院
/// 3：急诊
Class dhc.bonus.subs.BonusSubExpensesFliter Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubExpensesFliterID ]
{

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

Property ExpensesFlagCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property ExpensesFlagName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Index BonusTargetIDIndex On BonusTargetID As exact;

Index TargetExpens On (BonusTargetID, ExpensesFlagCode);

Storage Default
{
<Data name="BonusSubExpensesFliterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>ExpensesFlagCode</Value>
</Value>
<Value name="4">
<Value>ExpensesFlagName</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubExpensesFliterD</DataLocation>
<DefaultData>BonusSubExpensesFliterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubExpensesFliterD</IdLocation>
<IndexLocation>^dhcbsSubExpensesFliterI</IndexLocation>
<StreamLocation>^dhcbsSubExpensesFliterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
