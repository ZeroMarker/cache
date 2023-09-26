/// 核算单元权限
Class dhc.bonus.data.BonusEmployeeUnit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusEmployeeUnitID ]
{

Index EmployUnitIndex On (BonusEmployeeID, BonusUnitID);

Property BonusEmployeeID As dhc.bonus.data.BonusEmployee [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusEmployeeUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusEmployeeID</Value>
</Value>
<Value name="3">
<Value>BonusUnitID</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusEmployeeUnitD</DataLocation>
<DefaultData>BonusEmployeeUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusEmployeeUnitD</IdLocation>
<IndexLocation>^dhcbsBonusEmployeeUnitI</IndexLocation>
<StreamLocation>^dhcbsBonusEmployeeUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
