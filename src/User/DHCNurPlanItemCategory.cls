/// 护理计划项目类别
Class User.DHCNurPlanItemCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = IC_RowId, SqlTableName = DHC_NurPlan_ItemCat ]
{

Property ICCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = IC_Code ];

Property ICDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = IC_Desc ];

Property ICDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = IC_DateFrom ];

Property ICDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = IC_DateTo ];

Index Code On ICCode;

Index Desc On ICDesc;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICCode</Value>
</Value>
<Value name="3">
<Value>ICDesc</Value>
</Value>
<Value name="4">
<Value>ICDateFrom</Value>
</Value>
<Value name="5">
<Value>ICDateTo</Value>
</Value>
</Data>
<DataLocation>^DHCNurPlan("ItemCat")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCNurPlan("ItemCat")</IdLocation>
<IndexLocation>^DHCNurPlani("ItemCat",0)</IndexLocation>
<StreamLocation>^User.DHCNurPlanItemCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
