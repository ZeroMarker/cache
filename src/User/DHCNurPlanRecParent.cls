/// 护理计划数据主表
Class User.DHCNurPlanRecParent Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = RP_RowId, SqlTableName = DHC_NurPlan_RecParent ]
{

Relationship ChildRecTriggerSub As User.DHCNurPlanRecTriggerSub [ Cardinality = children, Inverse = RTSParRef ];

Relationship ChildRecCompleteSub As User.DHCNurPlanRecCompleteSub [ Cardinality = children, Inverse = RCSParRef ];

Relationship ChildRecLog As User.DHCNurPlanRecLog [ Cardinality = children, Inverse = RLParRef ];

Property RPEpisodeID As %String [ SqlColumnNumber = 2, SqlFieldName = RP_EpisodeID ];

/// 护理计划项目ID
Property RPItemID As %String [ SqlColumnNumber = 3, SqlFieldName = RP_ItemID ];

Property RPPlanDate As %Date [ SqlColumnNumber = 4, SqlFieldName = RP_PlanDate ];

/// 执行状态
Property RPStatus As %String [ SqlColumnNumber = 5, SqlFieldName = RP_Status ];

/// 符合的触发条件描述
Property RPTriggerDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = RP_TriggerDesc ];

/// 目前的完成情况概述
Property RPCompleteDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = RP_CompleteDesc ];

Property RPRecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 8, SqlFieldName = RP_RecDate ];

Property RPRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 9, SqlFieldName = RP_RecTime ];

Property RPRecUser As %String [ SqlColumnNumber = 10, SqlFieldName = RP_RecUser ];

Index EpisodeDate On (RPEpisodeID, RPPlanDate);

Index EpisodeDateItem On (RPEpisodeID, RPPlanDate, RPItemID);

Index EpisodeItem On (RPEpisodeID, RPItemID);

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RPEpisodeID</Value>
</Value>
<Value name="3">
<Value>RPRecDate</Value>
</Value>
<Value name="4">
<Value>RPRecTime</Value>
</Value>
<Value name="5">
<Value>RPRecUser</Value>
</Value>
<Value name="6">
<Value>RPItemID</Value>
</Value>
<Value name="7">
<Value>RPPlanDate</Value>
</Value>
<Value name="8">
<Value>RPStatus</Value>
</Value>
<Value name="9">
<Value>RPCompleteDesc</Value>
</Value>
<Value name="10">
<Value>RPTriggerDesc</Value>
</Value>
</Data>
<DataLocation>^DHCNurPlan("Rec")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCNurPlan("Rec")</IdLocation>
<IndexLocation>^DHCNurPlani("Rec",0)</IndexLocation>
<StreamLocation>^User.DHCNurPlanRecParentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
