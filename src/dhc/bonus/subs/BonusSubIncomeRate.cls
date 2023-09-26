Class dhc.bonus.subs.BonusSubIncomeRate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubIncomeRateID ]
{

Property BonusSubItemID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ Required, SqlColumnNumber = 2 ];

Property MakeBillDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property ExecuteDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property SickDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property ChiefDoctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property MakeBillDoctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property ExecuteDoctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property SubItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property ExpensesType As %Library.Integer [ Required, SqlColumnNumber = 10 ];

Property SickType As %Library.Integer [ Required, SqlColumnNumber = 11 ];

Property MakeBillDeptRate As %Library.Float [ Required, SqlColumnNumber = 12 ];

Property ExecuteDeptRate As %Library.Float [ Required, SqlColumnNumber = 13 ];

Property SickDeptRate As %Library.Float [ Required, SqlColumnNumber = 14 ];

Index MakeBill On (BonusSubItemID, SickType, ExpensesType, MakeBillDept, MakeBillDoctor, MakeBillDeptRate);

Index Execute On (BonusSubItemID, SickType, ExpensesType, ExecuteDept, ExecuteDoctor, ExecuteDeptRate);

Index Sick On (BonusSubItemID, SickType, ExpensesType, SickDept, ChiefDoctor, SickDeptRate);

Storage Default
{
<Data name="BonusSubIncomeRateDefaultData">
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
<Value>SubItemName</Value>
</Value>
<Value name="10">
<Value>ExpensesType</Value>
</Value>
<Value name="11">
<Value>SickType</Value>
</Value>
<Value name="12">
<Value>MakeBillDeptRate</Value>
</Value>
<Value name="13">
<Value>ExecuteDeptRate</Value>
</Value>
<Value name="14">
<Value>SickDeptRate</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubIncomeRateD</DataLocation>
<DefaultData>BonusSubIncomeRateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubIncomeRateD</IdLocation>
<IndexLocation>^dhcbsSubIncomeRateI</IndexLocation>
<StreamLocation>^dhcbsSubIncomeRateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
