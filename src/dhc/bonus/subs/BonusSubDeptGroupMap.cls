/// 科室组映射
Class dhc.bonus.subs.BonusSubDeptGroupMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubDeptGroupMapID ]
{

Property BonusDeptGroupID As dhc.bonus.subs.BonusSubDeptGroup [ SqlColumnNumber = 2 ];

Property BonusUnit As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Index Parent On (BonusDeptGroupID, BonusUnit);

Storage Default
{
<Data name="BonusSubDeptGroupMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusDeptGroupID</Value>
</Value>
<Value name="3">
<Value>BonusUnit</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubDeptGroupMapD</DataLocation>
<DefaultData>BonusSubDeptGroupMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubDeptGroupMapD</IdLocation>
<IndexLocation>^dhcbsSubDeptGroupMapI</IndexLocation>
<StreamLocation>^dhcbsSubDeptGroupMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
