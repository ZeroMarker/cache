/// 护理计划操作日志
Class User.DHCNurPlanRecLog Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = RL_RowId, SqlTableName = DHC_NurPlan_RecLog ]
{

Relationship RLParRef As User.DHCNurPlanRecParent [ Cardinality = parent, Inverse = ChildRecLog, SqlFieldName = RL_ParRef ];

/// 执行状态
Property RLStatus As %String [ SqlColumnNumber = 2, SqlFieldName = RL_Status ];

/// 操作方式(自动执行/手动执行)
Property RLExecType As %String [ SqlColumnNumber = 3, SqlFieldName = RL_ExecType ];

Property RLUpdateUser As %String [ SqlColumnNumber = 4, SqlFieldName = RL_UpdateUser ];

Property RLUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = RL_UpdateDate ];

Property RLUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = RL_UpdateTime ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RLEpisodeID</Value>
</Value>
<Value name="3">
<Value>RLItemID</Value>
</Value>
<Value name="4">
<Value>RLStatus</Value>
</Value>
<Value name="5">
<Value>RSUpdateUser</Value>
</Value>
<Value name="6">
<Value>RSUpdateDate</Value>
</Value>
<Value name="7">
<Value>RSUpdateTime</Value>
</Value>
<Value name="8">
<Value>RLDesc</Value>
</Value>
<Value name="9">
<Value>RLUpdateUser</Value>
</Value>
<Value name="10">
<Value>RLUpdateDate</Value>
</Value>
<Value name="11">
<Value>RLUpdateTime</Value>
</Value>
<Value name="12">
<Value>RLExecType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RecLog")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RecLog")</IdLocation>
<IndexLocation>^DHCNurPlani("RecLog",0)</IndexLocation>
<SqlChildSub>RL_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCNurPlanRecLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
