Class dhc.bonus.data.SchemeAdjustTarget Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SchemeAdjustTargetID ]
{

Property BonusSchemeAdjustID As dhc.bonus.data.BonusSchemeAdjust [ SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Storage Default
{
<Data name="SchemeAdjustTargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>BonusSchemeAdjustID</Value>
</Value>
</Data>
<DataLocation>^dhcbonusSchemeAdjustD</DataLocation>
<DefaultData>SchemeAdjustTargetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbonusSchemeAdjustD</IdLocation>
<IndexLocation>^dhcbonusSchemeAdjustI</IndexLocation>
<StreamLocation>^dhcbonusSchemeAdjustS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
