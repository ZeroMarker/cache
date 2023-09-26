Class dhc.bonus.module.WorkItemTargetMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = WorkItemTargetMapID ]
{

/// 奖金指标ID
Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

/// 工作量字典ID
Property BonusWorkItemID As dhc.bonus.module.BonusWorkItem [ SqlColumnNumber = 3 ];

Property ItemRate As %Library.Float [ SqlColumnNumber = 4 ];

/// 修改时间
Property UpdateDate As %Library.String [ SqlColumnNumber = 5 ];

Index WorkitemBonusTarget On (BonusTargetID, BonusWorkItemID);

Storage Default
{
<Data name="WorkItemTargetMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>BonusWorkItemID</Value>
</Value>
<Value name="4">
<Value>ItemRate</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdWorkItemTargetMapD</DataLocation>
<DefaultData>WorkItemTargetMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdWorkItemTargetMapD</IdLocation>
<IndexLocation>^dhcbsmdWorkItemTargetMapI</IndexLocation>
<SQLMap name="BonusTargetID">
<Global>^dhcbsmdBonusTarget</Global>
<Type>index</Type>
</SQLMap>
<SQLMap name="BonusWorkItemID">
<Global>^dhcbsmdBonusWorkItem</Global>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhcbsmdWorkItemTargetMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
