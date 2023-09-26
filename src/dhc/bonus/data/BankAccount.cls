Class dhc.bonus.data.BankAccount Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BankAccountID ]
{

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 2 ];

Property EmpCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BankNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 5 ];

Property CardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property BonusRate As %Library.Float [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BankAccountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitID</Value>
</Value>
<Value name="3">
<Value>BankNo</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
<Value name="5">
<Value>EmpCode</Value>
</Value>
<Value name="6">
<Value>CardNo</Value>
</Value>
<Value name="7">
<Value>BonusRate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBankAccountD</DataLocation>
<DefaultData>BankAccountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBankAccountD</IdLocation>
<IndexLocation>^dhcbsBankAccountI</IndexLocation>
<StreamLocation>^dhcbsBankAccountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
