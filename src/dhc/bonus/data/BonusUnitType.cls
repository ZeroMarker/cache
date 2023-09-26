/// ZD核算单元类别
Class dhc.bonus.data.BonusUnitType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusUnitTypeID ]
{

Index Code On UnitTypeCode As Exact;

Index Name On UnitTypeName As Exact;

Property IsBillDept As %Integer [ SqlColumnNumber = 5 ];

Property IsDeptmentType As %Integer [ SqlColumnNumber = 9 ];

Property IsExcuteDept As %Integer [ SqlColumnNumber = 4 ];

Property IsExpend As %Integer [ SqlColumnNumber = 8 ];

Property IsIncome As %Integer [ SqlColumnNumber = 7 ];

Property IsMedicalGroup As %Integer [ SqlColumnNumber = 10 ];

Property IsPatientDept As %Integer [ SqlColumnNumber = 6 ];

Property IsPersonType As %Integer [ SqlColumnNumber = 11 ];

Property IsValid As %Integer [ Required, SqlColumnNumber = 12 ];

Property UnitTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property UnitTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Storage Default
{
<Data name="BonusUnitTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UnitTypeCode</Value>
</Value>
<Value name="3">
<Value>UnitTypeName</Value>
</Value>
<Value name="4">
<Value>IsExcuteDept</Value>
</Value>
<Value name="5">
<Value>IsBillDept</Value>
</Value>
<Value name="6">
<Value>IsPatientDept</Value>
</Value>
<Value name="7">
<Value>IsIncome</Value>
</Value>
<Value name="8">
<Value>IsExpend</Value>
</Value>
<Value name="9">
<Value>IsDeptmentType</Value>
</Value>
<Value name="10">
<Value>IsMedicalGroup</Value>
</Value>
<Value name="11">
<Value>IsPersonType</Value>
</Value>
<Value name="12">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusUnitTypeD</DataLocation>
<DefaultData>BonusUnitTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusUnitTypeD</IdLocation>
<IndexLocation>^dhcbsBonusUnitTypeI</IndexLocation>
<StreamLocation>^dhcbsBonusUnitTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
