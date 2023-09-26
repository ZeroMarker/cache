/// Creater:wangcc
/// Descriptions:轮转记录表
/// Date:2020-07-22
Class DHCINM.Trans.MgRotationDep Extends %Persistent
{

/// 轮转计划
Property PlanDR As %String [ SqlColumnNumber = 2, SqlFieldName = Rotation_PlanDR ];

/// 轮转人
Property DetailDR As DHCINM.Trans.MgRotationDetail [ SqlColumnNumber = 3, SqlFieldName = Rotation_DetailDR ];

/// 轮转时段
Property CycleDR As DHCINM.Trans.MgRotationCycle [ SqlColumnNumber = 4, SqlFieldName = Rotation_CycleDR ];

/// 带教老师
Property Teacher As %String [ SqlColumnNumber = 5, SqlFieldName = Rotation_Teacher ];

/// 实际开始日期
Property ActualStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Rotation_ActualStDate ];

/// 实际结束日期
Property ActualEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Rotation_ActualEndDate ];

/// 终止原因
Property StopReason As %String [ SqlColumnNumber = 8, SqlFieldName = Rotation_StopReason ];

/// 状态 "NR":"待轮转","YR":"轮转中","AR":"轮转完成","TE":"调岗终止","DE":"定科终止","OE":"其他情况终止","TR":"借调"
/// 待轮转 轮转中 轮转完成都是通过轮转开始时间和结束时间判断的
Property Status As %String [ SqlColumnNumber = 9, SqlFieldName = Rotation_Status ];

/// 病区
Property Ward As %String [ SqlColumnNumber = 10, SqlFieldName = Rotation_Ward ];

/// 说明
Property Remark As %String [ SqlColumnNumber = 11, SqlFieldName = Rotation_Remark ];

Index detail On DetailDR;

Index planid On PlanDR;

Index plan On (PlanDR, CycleDR);

Index detaildr On (DetailDR, CycleDR);

Index ward On Ward;

Index status On Status;

Storage Default
{
<Data name="MgRotationDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanDR</Value>
</Value>
<Value name="3">
<Value>DetailDR</Value>
</Value>
<Value name="4">
<Value>CycleDR</Value>
</Value>
<Value name="5">
<Value>Teacher</Value>
</Value>
<Value name="6">
<Value>ActualStDate</Value>
</Value>
<Value name="7">
<Value>ActualEndDate</Value>
</Value>
<Value name="8">
<Value>StopReason</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>Ward</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgRotationDepD</DataLocation>
<DefaultData>MgRotationDepDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgRotationDepD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgRotationDepI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgRotationDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
