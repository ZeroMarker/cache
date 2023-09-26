/// 护理计划项目类型
Class User.DHCNurPlanItemType Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = IT_RowId, SqlTableName = DHC_NurPlan_ItemType ]
{

Property ITCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = IT_Code ];

Property ITDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = IT_Desc ];

Property ITDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = IT_DateFrom ];

Property ITDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = IT_DateTo ];

Index Code On ITCode;

Index Desc On ITDesc;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ITCode</Value>
</Value>
<Value name="3">
<Value>ITDesc</Value>
</Value>
<Value name="4">
<Value>ITDateFrom</Value>
</Value>
<Value name="5">
<Value>ITDateTo</Value>
</Value>
</Data>
<DataLocation>^DHCNurPlan("ItemType")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCNurPlan("ItemType")</IdLocation>
<IndexLocation>^DHCNurPlani("ItemType",0)</IndexLocation>
<StreamLocation>^User.DHCNurPlanItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
