Class dhc.bonus.module.KpiTargetMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = KpiTargetMapID ]
{

//ZD奖金指标ID

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

//当TargetType=1时 ，存-1；=2时，存 维度表ID,=3时，存kpi指标ID

Property KpiTargetID As %Library.Integer [ SqlColumnNumber = 3 ];

//计提系数

Property ItemRate As %Library.Float [ SqlColumnNumber = 4 ];

//绩效方案

Property PASchemID As dhc.pa.data.Schem [ SqlColumnNumber = 5 ];

//指标类别：1:方案总分，2：方案维度，3：方案指标

Property TargetType As %Library.String [ SqlColumnNumber = 6 ];

//修改时间

Property UpdateDate As %Library.String [ SqlColumnNumber = 7 ];

Index KPIBonusTargetIDX On (BonusTargetID, KpiTargetID);

Storage Default
{
<Data name="KpiTargetMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>KpiTargetID</Value>
</Value>
<Value name="4">
<Value>ItemRate</Value>
</Value>
<Value name="5">
<Value>PASchemID</Value>
</Value>
<Value name="6">
<Value>TargetType</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsmoduleKpiTargetMapD</DataLocation>
<DefaultData>KpiTargetMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmoduleKpiTargetMapD</IdLocation>
<IndexLocation>^dhcbsmoduleKpiTargetMapI</IndexLocation>
<StreamLocation>^dhcbsmoduleKpiTargetMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
