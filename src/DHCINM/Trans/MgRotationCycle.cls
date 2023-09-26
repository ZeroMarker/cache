/// Creater:wangcc
/// Descriptions:轮转时段表
/// Date:2020-07-22
Class DHCINM.Trans.MgRotationCycle Extends %Persistent
{

/// 轮转计划ID
Property PlanDR As %String [ SqlColumnNumber = 2, SqlFieldName = PlanDR ];

/// 轮转开始日期
Property StDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Rotation_StDate ];

/// 轮转结束日期
Property EndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Rotation_EndDate ];

Index plan On PlanDR;

Storage Default
{
<Data name="MgRotationCycleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanDR</Value>
</Value>
<Value name="3">
<Value>StDate</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgRotationCycleD</DataLocation>
<DefaultData>MgRotationCycleDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgRotationCycleD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgRotationCycleI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgRotationCycleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
