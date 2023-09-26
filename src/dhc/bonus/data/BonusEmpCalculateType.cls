/// 单元核算类型字典
Class dhc.bonus.data.BonusEmpCalculateType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitCalculateTypeID ]
{

Property BonusEmployeeID As dhc.bonus.data.BonusEmployee [ Required, SqlColumnNumber = 2 ];

Property BonusCalculateTypeID As dhc.bonus.data.BonusCalculateType [ Required, SqlColumnNumber = 3 ];

Index EmpCalcType On (BonusEmployeeID, BonusCalculateTypeID);

Storage Default
{
<Data name="BonusEmpCalculateTypeDefaultData">
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
<DataLocation>^dhcbsEmpCalculateTypeD</DataLocation>
<DefaultData>BonusEmpCalculateTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsEmpCalculateTypeD</IdLocation>
<IndexLocation>^dhcbsEmpCalculateTypeI</IndexLocation>
<StreamLocation>^dhcbsEmpCalculateTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
