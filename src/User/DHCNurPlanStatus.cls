/// 护理计划状态表
Class User.DHCNurPlanStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = S_RowId, SqlTableName = DHC_NurPlan_Status ]
{

Property SCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = S_Code ];

Property SDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = S_Desc ];

Property SDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = S_DateFrom ];

Property SDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = S_DateTo ];

Index Code On SCode;

Index Desc On SDesc;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCode</Value>
</Value>
<Value name="3">
<Value>SDesc</Value>
</Value>
<Value name="4">
<Value>SDateFrom</Value>
</Value>
<Value name="5">
<Value>SDateTo</Value>
</Value>
</Data>
<DataLocation>^DHCNurPlan("Status")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCNurPlan("Status")</IdLocation>
<IndexLocation>^DHCNurPlani("Status",0)</IndexLocation>
<StreamLocation>^User.DHCNurPlanStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
