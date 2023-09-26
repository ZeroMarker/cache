Class dhc.bonus.data.EmpBonusTemp Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = EmpBonusTempID ]
{

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property EmpCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property EmpName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property ItemValue As %Library.Float [ SqlColumnNumber = 7 ];

Property UpdateDate As %Library.String [ SqlColumnNumber = 8 ];

Property status As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Property DeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="EmpBonusTempDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusYear</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
</Value>
<Value name="4">
<Value>EmpCode</Value>
</Value>
<Value name="5">
<Value>EmpName</Value>
</Value>
<Value name="6">
<Value>ItemName</Value>
</Value>
<Value name="7">
<Value>ItemValue</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>status</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>ItemCode</Value>
</Value>
<Value name="12">
<Value>DeptCode</Value>
</Value>
<Value name="13">
<Value>DeptName</Value>
</Value>
</Data>
<DataLocation>^dhcbsdataEmpBonusTempD</DataLocation>
<DefaultData>EmpBonusTempDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsdataEmpBonusTempD</IdLocation>
<IndexLocation>^dhcbsdataEmpBonusTempI</IndexLocation>
<StreamLocation>^dhcbsdataEmpBonusTempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
