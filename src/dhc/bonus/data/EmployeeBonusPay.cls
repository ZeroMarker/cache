/// FA职工奖金发放
Class dhc.bonus.data.EmployeeBonusPay Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = EmployeeBonusPayID ]
{

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 2 ];

Property BonusValue As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property UpdateDate As %Library.TimeStamp [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="EmployeeBonusPayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusEmployeeID</Value>
</Value>
<Value name="3">
<Value>BonusYear</Value>
</Value>
<Value name="4">
<Value>BonusPeriod</Value>
</Value>
<Value name="5">
<Value>BonusValue</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>BonusUnitID</Value>
</Value>
</Data>
<DataLocation>^dhcbsEmployeeBonusPayD</DataLocation>
<DefaultData>EmployeeBonusPayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsEmployeeBonusPayD</IdLocation>
<IndexLocation>^dhcbsEmployeeBonusPayI</IndexLocation>
<StreamLocation>^dhcbsEmployeeBonusPayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
