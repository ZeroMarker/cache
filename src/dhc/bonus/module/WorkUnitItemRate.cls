/// 科室工作量标准系数表
Class dhc.bonus.module.WorkUnitItemRate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = WorkUnitItemRateID ]
{

/// 科室ID
Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 2 ];

/// 工作量项目ID
Property BonusWorkItemID As dhc.bonus.module.BonusWorkItem [ SqlColumnNumber = 3 ];

/// 工作量标准
Property ItemRate As %Library.Float [ SqlColumnNumber = 4 ];

/// 插入、修改系统时间
Property UpateDate As %Library.String [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="WorkUnitItemRateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitID</Value>
</Value>
<Value name="3">
<Value>BonusWorkItemID</Value>
</Value>
<Value name="4">
<Value>UpateDate</Value>
</Value>
<Value name="5">
<Value>ItemRate</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbonusWorkUnitItemRateD</DataLocation>
<DefaultData>WorkUnitItemRateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbonusWorkUnitItemRateD</IdLocation>
<IndexLocation>^dhcbonusWorkUnitItemRateI</IndexLocation>
<StreamLocation>^dhcbonusWorkUnitItemRateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
