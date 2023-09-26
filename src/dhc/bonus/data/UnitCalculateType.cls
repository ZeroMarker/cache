/// 单元核算类型字典
Class dhc.bonus.data.UnitCalculateType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitCalculateTypeID ]
{

Property BonusUnitID As dhc.bonus.data.BonusUnit [ Required, SqlColumnNumber = 2 ];

Property CalculateTypeID As dhc.bonus.data.BonusCalculateType [ Required, SqlColumnNumber = 3 ];

Index UnitCalcType On (BonusUnitID, CalculateTypeID);

Storage Default
{
<Data name="UnitCalculateTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitID</Value>
</Value>
<Value name="3">
<Value>CalculateTypeID</Value>
</Value>
</Data>
<DataLocation>^dhcbsUnitCalculateTypeaD</DataLocation>
<DefaultData>UnitCalculateTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsUnitCalculateTypeaD</IdLocation>
<IndexLocation>^dhcbsUnitCalculateTypeaI</IndexLocation>
<StreamLocation>^dhcbsUnitCalculateTypeaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
