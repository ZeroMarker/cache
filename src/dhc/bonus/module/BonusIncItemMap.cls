Class dhc.bonus.module.BonusIncItemMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusIncItemMapID ]
{

//ZD奖金指标ID

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

//SH辅助项目字典ID

Property BonusIncItemID As dhc.bonus.module.BonusIncItem [ SqlColumnNumber = 3 ];

//开单比例

Property MakeBillRate As %Library.Float [ SqlColumnNumber = 4 ];

//执行比例

Property ExecuteRate As %Library.Float [ SqlColumnNumber = 5 ];

//病人比例

Property SickRate As %Library.Float [ SqlColumnNumber = 6 ];

//修改时间

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 7 ];

//数据类型，MK=开单收入，EX=执行收入，SK=病人收入

Property ItemType As %Library.String [ SqlColumnNumber = 8 ];

Index BonusIncMapIdx On (ItemType, BonusIncItemID, BonusTargetID);

Storage Default
{
<Data name="BonusIncItemMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>BonusIncItemID</Value>
</Value>
<Value name="4">
<Value>MakeBillRate</Value>
</Value>
<Value name="5">
<Value>ExecuteRate</Value>
</Value>
<Value name="6">
<Value>SickRate</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>ItemType</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusIncItemD</DataLocation>
<DefaultData>BonusIncItemMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusIncItemD</IdLocation>
<IndexLocation>^dhcbsBonusIncItemI</IndexLocation>
<StreamLocation>^dhcbsBonusIncItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
