/// 护理计划事件表
Class User.DHCNurPlanEvents Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = E_RowId, SqlTableName = DHC_NurPlan_Events ]
{

/// 事件代码
Property ECode As %String [ SqlColumnNumber = 2, SqlFieldName = E_Code ];

/// 事件描述
Property EDesc As %String [ SqlColumnNumber = 3, SqlFieldName = E_Desc ];

/// 事件关联函数
Property EFunction As %String [ SqlColumnNumber = 4, SqlFieldName = E_Function ];

/// 参数
Property EParameter As %String [ SqlColumnNumber = 5, SqlFieldName = E_Parameter ];

/// 类型
Property EType As %String [ SqlColumnNumber = 6, SqlFieldName = E_Type ];

/// 备注说明
Property ENote As %String [ SqlColumnNumber = 7, SqlFieldName = E_Note ];

Property EDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = E_DateFrom ];

Property EDateTo As %Date [ SqlColumnNumber = 9, SqlFieldName = E_DateTo ];

Index Code On ECode;

Index Desc On EDesc;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECode</Value>
</Value>
<Value name="3">
<Value>EDesc</Value>
</Value>
<Value name="4">
<Value>EDateFrom</Value>
</Value>
<Value name="5">
<Value>EDateTo</Value>
</Value>
<Value name="6">
<Value>EFunction</Value>
</Value>
<Value name="7">
<Value>EParameter</Value>
</Value>
<Value name="8">
<Value>EType</Value>
</Value>
<Value name="9">
<Value>ENote</Value>
</Value>
</Data>
<DataLocation>^DHCNurPlan("Event")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCNurPlan("Event")</IdLocation>
<IndexLocation>^DHCNurPlani("Event",0)</IndexLocation>
<StreamLocation>^User.DHCNurPlanEventsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
