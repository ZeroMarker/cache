/// Creator:wangcc
/// Descriptions:实习生培训计划表
/// Date:2020-09-23
Class DHCINM.Intern.MgTrainPlan Extends %Persistent
{

Relationship ChildSub As DHCINM.Intern.MgTrainPlanSub [ Cardinality = children, Inverse = Parref ];

/// 标题
Property PlanName As %String [ SqlColumnNumber = 2, SqlFieldName = Plan_Name ];

/// 级别
Property PlanLevel As %String [ SqlColumnNumber = 3, SqlFieldName = Plan_Level ];

/// 发布范围 {code:'A',desc:'片区'},{code:'L',desc:'科室'},{code:'W',desc:'病区'}
Property PlanRange As %String [ SqlColumnNumber = 4, SqlFieldName = Plan_Range ];

/// 范围具体
Property PlanRangeSub As %String [ SqlColumnNumber = 5, SqlFieldName = Plan_RangeSub ];

/// 计划日期
Property PlanDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Plan_PlanDate ];

/// 计划时间
Property PlanTime As %Time [ SqlColumnNumber = 7, SqlFieldName = Plan_PlanTime ];

/// 开始日期
Property StDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Plan_StDate ];

/// 结束日期
Property EndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Plan_EndDate ];

/// 指定主讲人 T:统一指定  L:科室指定
Property SpeakerType As %String [ SqlColumnNumber = 10, SqlFieldName = Plan_SpeakerType ];

/// 附件
Property PlanRefer As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Plan_Refer ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 12, SqlFieldName = Plan_Creator ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Plan_CreateDate ];

/// 培训地点
Property Place As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Plan_Place ];

/// 状态 N:保存  S:发布
Property Status As %String [ SqlColumnNumber = 15, SqlFieldName = Plan_Status ];

/// 主讲人
Property Speaker As %String [ SqlColumnNumber = 16, SqlFieldName = Plan_Speaker ];

/// 内容说明
Property Content As %String(MAXLEN = 10000) [ SqlColumnNumber = 17, SqlFieldName = Plan_Content ];

Storage Default
{
<Data name="MgTrainPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanName</Value>
</Value>
<Value name="3">
<Value>PlanLevel</Value>
</Value>
<Value name="4">
<Value>PlanRange</Value>
</Value>
<Value name="5">
<Value>PlanRangeSub</Value>
</Value>
<Value name="6">
<Value>PlanDate</Value>
</Value>
<Value name="7">
<Value>PlanTime</Value>
</Value>
<Value name="8">
<Value>StDate</Value>
</Value>
<Value name="9">
<Value>EndDate</Value>
</Value>
<Value name="10">
<Value>SpeakerType</Value>
</Value>
<Value name="11">
<Value>PlanRefer</Value>
</Value>
<Value name="12">
<Value>Creator</Value>
</Value>
<Value name="13">
<Value>CreateDate</Value>
</Value>
<Value name="14">
<Value>Place</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>Speaker</Value>
</Value>
<Value name="17">
<Value>Content</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgTrainPlanD</DataLocation>
<DefaultData>MgTrainPlanDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgTrainPlanD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgTrainPlanI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgTrainPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
