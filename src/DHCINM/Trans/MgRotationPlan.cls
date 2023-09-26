/// Creater:wangcc
/// Descriptions:轮转计划表
/// Date:2020-07-22
Class DHCINM.Trans.MgRotationPlan Extends %Persistent
{

/// 隶属年度
Property PlanYear As %String [ SqlColumnNumber = 2, SqlFieldName = Plan_Year ];

/// 计划名称
Property PlanName As %String [ SqlColumnNumber = 3, SqlFieldName = Plan_Name ];

/// 轮转人数
Property PlanPerNum As %String [ SqlColumnNumber = 4, SqlFieldName = Plan_PerNum ];

/// 状态（N-保存  P-发布）
Property PlanStatus As %String [ SqlColumnNumber = 5, SqlFieldName = Plan_Status ];

Storage Default
{
<Data name="MgRotationPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanYear</Value>
</Value>
<Value name="3">
<Value>PlanName</Value>
</Value>
<Value name="4">
<Value>PlanPerNum</Value>
</Value>
<Value name="5">
<Value>PlanStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgRotationPlanD</DataLocation>
<DefaultData>MgRotationPlanDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgRotationPlanD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgRotationPlanI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgRotationPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
