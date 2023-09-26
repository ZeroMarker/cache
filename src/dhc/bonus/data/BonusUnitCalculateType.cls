/// 单元核算类型字典
Class dhc.bonus.data.BonusUnitCalculateType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitCalculateTypeID ]
{

Property BonusEmployeeID As dhc.bonus.data.BonusEmployee [ Required, SqlColumnNumber = 2 ];

Property BonusCalculateTypeID As dhc.bonus.data.BonusCalculateType [ Required, SqlColumnNumber = 3 ];

Storage Default
{
<Data name="BonusUnitCalculateTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusEmployeeID</Value>
</Value>
<Value name="3">
<Value>BonusCalculateTypeID</Value>
</Value>
</Data>
<DataLocation>^dhcbsUnitCalculateTypeD</DataLocation>
<DefaultData>BonusUnitCalculateTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsUnitCalculateTypeD</IdLocation>
<IndexLocation>^dhcbsUnitCalculateTypeI</IndexLocation>
<StreamLocation>^dhcbsUnitCalculateTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
