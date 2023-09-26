Class dhc.bonus.module.DrgsTargetMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DrgsTargetMapID ]
{

//ZD奖金指标ID

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

//SH辅助项目字典ID

Property DrgsTargetMapID As dhc.bonus.module.DrgsItem [ SqlColumnNumber = 3 ];

Property ItemRate As %Library.Float [ SqlColumnNumber = 4 ];

//修改时间

Property UpdateDate As %Library.String [ SqlColumnNumber = 5 ];

Index WorkitemBonusTarget On (BonusTargetID, DrgsTargetMapID);

Storage Default
{
<Data name="DrgsTargetMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>DrgsTargetMapID</Value>
</Value>
<Value name="4">
<Value>ItemRate</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsDrgsTargetMapD</DataLocation>
<DefaultData>DrgsTargetMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsDrgsTargetMapD</IdLocation>
<IndexLocation>^dhcbsDrgsTargetMapI</IndexLocation>
<StreamLocation>^dhcbsDrgsTargetMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
