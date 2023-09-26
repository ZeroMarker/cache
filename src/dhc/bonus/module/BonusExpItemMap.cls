Class dhc.bonus.module.BonusExpItemMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusExpItemMapID ]
{

//ZD奖金指标ID

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

//支出项目

Property BonusExpendItemID As dhc.bonus.module.BonusExpendItem [ SqlColumnNumber = 3 ];

//计提比例

Property ItemRate As %Library.Float [ SqlColumnNumber = 4 ];

//修改时间

Property UpdateDate As %Library.String [ SqlColumnNumber = 5 ];

Index BonusExpendMapIdx On (BonusTargetID, BonusExpendItemID);

Storage Default
{
<Data name="BonusExpItemMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>BonusExpendItemID</Value>
</Value>
<Value name="4">
<Value>ItemRate</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusExpItemMapD</DataLocation>
<DefaultData>BonusExpItemMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusExpItemMapD</IdLocation>
<IndexLocation>^dhcbsBonusExpItemMapI</IndexLocation>
<StreamLocation>^dhcbsBonusExpItemMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
