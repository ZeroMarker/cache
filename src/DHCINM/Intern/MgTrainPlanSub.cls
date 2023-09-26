/// Creator:wangcc
/// Descriptions:实习生培训计记录表(子表)
/// Date:2020-09-23
Class DHCINM.Intern.MgTrainPlanSub Extends %Persistent
{

/// 父表
Relationship Parref As DHCINM.Intern.MgTrainPlan [ Cardinality = parent, Inverse = ChildSub ];

/// 主讲人
Property Speaker As %String [ SqlColumnNumber = 2, SqlFieldName = PlanSub_Speaker ];

/// 培训日期
Property TrainDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PlanSub_Date ];

/// 培训时间
Property TrainTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PlanSub_Time ];

/// 培训地点
Property TrainPlace As %String [ SqlColumnNumber = 5, SqlFieldName = PlanSub_Place ];

/// 到勤人员
Property TrainMember As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = PlanSub_Member ];

/// 培训病区
Property TrainWard As %String [ SqlColumnNumber = 7, SqlFieldName = PlanSub_Ward ];

/// 状态
Property TrainStatus As %String [ SqlColumnNumber = 8, SqlFieldName = PlanSub_Status ];

Index ward On (Parref, TrainWard);

Index status On (Parref, TrainStatus);

Storage Default
{
<Data name="MgTrainPlanSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Speaker</Value>
</Value>
<Value name="3">
<Value>TrainDate</Value>
</Value>
<Value name="4">
<Value>TrainTime</Value>
</Value>
<Value name="5">
<Value>TrainPlace</Value>
</Value>
<Value name="6">
<Value>TrainMember</Value>
</Value>
<Value name="7">
<Value>TrainWard</Value>
</Value>
<Value name="8">
<Value>TrainStatus</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>MgTrainPlanSubDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgTrainPlanC("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Intern.MgTrainPlanSubI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgTrainPlanSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
