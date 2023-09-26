Class dhc.bonus.data.SchemeTarget Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SchemeTargetID ]
{

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 3 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

Property UpdateDate As %Date [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="SchemeTargetDefaultData">
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
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsSchemeTargetD</DataLocation>
<DefaultData>SchemeTargetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSchemeTargetD</IdLocation>
<IndexLocation>^dhcbsSchemeTargetI</IndexLocation>
<StreamLocation>^dhcbsSchemeTargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
