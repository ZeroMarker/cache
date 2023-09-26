/// ZD奖金人员
Class dhc.bonus.data.BonusEmployee Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusEmployeeID ]
{

Index Code On EmployeeCode As Exact;

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 5 ];

Property EmployeeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property EmployeeName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusEmployeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmployeeCode</Value>
</Value>
<Value name="3">
<Value>EmployeeName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
<Value name="5">
<Value>BonusUnitID</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusEmployeeD</DataLocation>
<DefaultData>BonusEmployeeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusEmployeeD</IdLocation>
<IndexLocation>^dhcbsBonusEmployeeI</IndexLocation>
<StreamLocation>^dhcbsBonusEmployeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
