Class dhc.bonus.subs.BonusSubIncomeAllRate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubIncomeAllRateID ]
{

Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 2 ];

Property MakeBillDept As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Property ExecuteDept As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 4 ];

Property SickDept As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 5 ];

Property ChiefDoctor As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 6 ];

Property MakeBillDoctor As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 7 ];

Property ExecuteDoctor As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 8 ];

Property DeptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property ExpensesType As %Library.Integer [ Required, SqlColumnNumber = 10 ];

Property SickType As %Library.Integer [ Required, SqlColumnNumber = 11 ];

Property IncomeRate As %Library.Float [ Required, SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BonusSubIncomeAllRateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSubItemID</Value>
</Value>
<Value name="3">
<Value>MakeBillDept</Value>
</Value>
<Value name="4">
<Value>ExecuteDept</Value>
</Value>
<Value name="5">
<Value>SickDept</Value>
</Value>
<Value name="6">
<Value>ChiefDoctor</Value>
</Value>
<Value name="7">
<Value>MakeBillDoctor</Value>
</Value>
<Value name="8">
<Value>ExecuteDoctor</Value>
</Value>
<Value name="9">
<Value>DeptType</Value>
</Value>
<Value name="10">
<Value>ExpensesType</Value>
</Value>
<Value name="11">
<Value>SickType</Value>
</Value>
<Value name="12">
<Value>IncomeRate</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubIncomeAllRateD</DataLocation>
<DefaultData>BonusSubIncomeAllRateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubIncomeAllRateD</IdLocation>
<IndexLocation>^dhcbsSubIncomeAllRateI</IndexLocation>
<StreamLocation>^dhcbsSubIncomeAllRateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
