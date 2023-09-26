/// 方案指标权限
Class dhc.bonus.data.BonusEmployeeTarget Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusEmployeeTargetID ]
{

Index EmployeeTargetI On (BonusEmployeeID, BonusTargetID);

Property BonusEmployeeID As dhc.bonus.data.BonusEmployee [ SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusEmployeeTargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusEmployeeID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusEmployeeTargetD</DataLocation>
<DefaultData>BonusEmployeeTargetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusEmployeeTargetD</IdLocation>
<IndexLocation>^dhcbsBonusEmployeeTargetI</IndexLocation>
<StreamLocation>^dhcbsBonusEmployeeTargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
