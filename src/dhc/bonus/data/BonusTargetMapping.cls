Class dhc.bonus.data.BonusTargetMapping Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusTargetMappingID ]
{

Property BonusSchemID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Property MappedBonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 4 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 5 ];

Property comeFlag As %Library.Integer [ Required, SqlColumnNumber = 6 ];

Index SchemTarget On (BonusSchemID, BonusTargetID);

Storage Default
{
<Data name="BonusTargetMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
<Value name="5">
<Value>MappedBonusTargetID</Value>
</Value>
<Value name="6">
<Value>comeFlag</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.d54C.BonusTargetM73AD</DataLocation>
<DefaultData>BonusTargetMappingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.bonus.d54C.BonusTargetM73AD</IdLocation>
<IndexLocation>^dhc.bonus.d54C.BonusTargetM73AI</IndexLocation>
<StreamLocation>^dhc.bonus.d54C.BonusTargetM73AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
