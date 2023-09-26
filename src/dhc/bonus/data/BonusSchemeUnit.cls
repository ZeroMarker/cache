/// 奖金核算方案所单元
Class dhc.bonus.data.BonusSchemeUnit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSchemeUnitID ]
{

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Index inxSchemeUnit On BonusSchemeID;

Index inxScheme On (BonusSchemeID, BonusUnitID);

Storage Default
{
<Data name="BonusSchemeUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeID</Value>
</Value>
<Value name="3">
<Value>BonusUnitID</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusSchemeUnitD</DataLocation>
<DefaultData>BonusSchemeUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusSchemeUnitD</IdLocation>
<IndexLocation>^dhcbsBonusSchemeUnitI</IndexLocation>
<StreamLocation>^dhcbsBonusSchemeUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
