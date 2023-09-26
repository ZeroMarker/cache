Class dhc.bonus.data.CalculateTypeTarget Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CalcTypeTargetID ]
{

Property BonusCalculateTypeID As dhc.bonus.data.BonusCalculateType [ SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Property StandardValue As %Library.Float [ SqlColumnNumber = 4 ];

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 5 ];

Property IsValid As %Library.Integer [ SqlColumnNumber = 6 ];

Index idxCaluTypeTarget On (BonusCalculateTypeID, BonusTargetID);

Storage Default
{
<Data name="CalculateTypeTargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusCalculateTypeID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>StandardValue</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
<Value name="6">
<Value>BonusSchemeID</Value>
</Value>
</Data>
<DataLocation>^dhcbsCalcTypeTargetD</DataLocation>
<DefaultData>CalculateTypeTargetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsCalcTypeTargetD</IdLocation>
<IndexLocation>^dhcbsCalcTypeTargetI</IndexLocation>
<StreamLocation>^dhcbsCalcTypeTargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
