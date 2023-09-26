/// ZD奖金核算单元 
/// d ##class(dhc.bonus.data.BonusUnit).%BuildIndces()
Class dhc.bonus.data.BonusUnit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusUnitID ]
{

Index BonusUnitCode On BonusUnitCode As Exact;

Index BonusUnitName On BonusUnitName As Exact;

Index Parent On SuperiorUnitID As Exact;

Property BonusUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property Spell As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property UnitFlag As %Library.Integer [ Required, SqlColumnNumber = 5 ];

Property SuperiorUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 6 ];

Property UnitLevel As %Library.Integer [ SqlColumnNumber = 7 ];

Property LastStage As %Library.Integer [ Required, SqlColumnNumber = 8 ];

Property UpdateDate As %Library.Date(FORMAT = 1) [ Required, SqlColumnNumber = 9 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 10 ];

Property BonusUnitTypeID As dhc.bonus.data.BonusUnitType [ SqlColumnNumber = 11, SqlFieldName = BonusUnitTypeID ];

Property EmployeeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Property SumUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 13 ];

Property StartDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BonusUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitCode</Value>
</Value>
<Value name="3">
<Value>BonusUnitName</Value>
</Value>
<Value name="4">
<Value>Spell</Value>
</Value>
<Value name="5">
<Value>UnitFlag</Value>
</Value>
<Value name="6">
<Value>SuperiorUnitID</Value>
</Value>
<Value name="7">
<Value>UnitLevel</Value>
</Value>
<Value name="8">
<Value>LastStage</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>IsValid</Value>
</Value>
<Value name="11">
<Value>BonusUnitTypeID</Value>
</Value>
<Value name="12">
<Value>EmployeeNo</Value>
</Value>
<Value name="13">
<Value>SumUnitID</Value>
</Value>
<Value name="14">
<Value>StartDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusUnitD</DataLocation>
<DefaultData>BonusUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusUnitD</IdLocation>
<IndexLocation>^dhcbsBonusUnitI</IndexLocation>
<StreamLocation>^dhcbsBonusUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
