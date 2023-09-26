Class dhc.bonus.subs.BonusSubIncomeCollect Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubIncomeCollectID ]
{

Property IncomeItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property IncomeItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property MakeBillDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property MakeBillDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property ExecuteDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property ExecuteDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property SickDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property SickDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property ChiefDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Property ChiefDoctorName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Property MakeBillDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

Property MakeBillDoctorName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

Property ExecuteDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

Property ExecuteDoctorName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

Property SickType As %Library.Integer [ SqlColumnNumber = 18 ];

Property ExpensesType As %Library.Integer [ SqlColumnNumber = 19 ];

Property IncomeMoney As %Library.Float [ SqlColumnNumber = 20 ];

Property State As %Library.Integer [ SqlColumnNumber = 21 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 22 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 23 ];

Index IdxYearPeriodMethod On (BonusYear, BonusPeriod, InterLocMethodID);

Index IdxYear On BonusYear;

Storage Default
{
<Data name="BonusSubIncomeCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IncomeItemCode</Value>
</Value>
<Value name="3">
<Value>IncomeItemName</Value>
</Value>
<Value name="4">
<Value>BonusYear</Value>
</Value>
<Value name="5">
<Value>BonusPeriod</Value>
</Value>
<Value name="6">
<Value>MakeBillDeptCode</Value>
</Value>
<Value name="7">
<Value>MakeBillDeptName</Value>
</Value>
<Value name="8">
<Value>ExecuteDeptCode</Value>
</Value>
<Value name="9">
<Value>ExecuteDeptName</Value>
</Value>
<Value name="10">
<Value>SickDeptCode</Value>
</Value>
<Value name="11">
<Value>SickDeptName</Value>
</Value>
<Value name="12">
<Value>ChiefDoctorCode</Value>
</Value>
<Value name="13">
<Value>ChiefDoctorName</Value>
</Value>
<Value name="14">
<Value>MakeBillDoctorCode</Value>
</Value>
<Value name="15">
<Value>MakeBillDoctorName</Value>
</Value>
<Value name="16">
<Value>ExecuteDoctorCode</Value>
</Value>
<Value name="17">
<Value>ExecuteDoctorName</Value>
</Value>
<Value name="18">
<Value>SickType</Value>
</Value>
<Value name="19">
<Value>ExpensesType</Value>
</Value>
<Value name="20">
<Value>IncomeMoney</Value>
</Value>
<Value name="21">
<Value>State</Value>
</Value>
<Value name="22">
<Value>InterLocMethodID</Value>
</Value>
<Value name="23">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubIncomeCollectD</DataLocation>
<DefaultData>BonusSubIncomeCollectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubIncomeCollectD</IdLocation>
<IndexLocation>^dhcbsSubIncomeCollectI</IndexLocation>
<StreamLocation>^dhcbsSubIncomeCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
