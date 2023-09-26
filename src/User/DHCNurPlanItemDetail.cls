/// 护理计划项目明细
Class User.DHCNurPlanItemDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = ID_RowId, SqlTableName = DHC_NurPlan_ItemDetail ]
{

Relationship IDParRef As User.DHCNurPlanItemMast [ Cardinality = parent, Inverse = ChildItemDetail, SqlFieldName = ID_ParRef ];

/// 代码
Property IDCode As %String [ SqlColumnNumber = 2, SqlFieldName = ID_Code ];

/// 描述
Property IDDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ID_Desc ];

/// 备注说明
Property IDNote As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = ID_Note ];

/// 元素关键字
Property IDKeyWord As %String [ SqlColumnNumber = 5, SqlFieldName = ID_KeyWord ];

/// 频次
Property IDFreq As %String [ SqlColumnNumber = 6, SqlFieldName = ID_Freq ];

/// 自定义频次
Property IDCustomFreq As %String [ SqlColumnNumber = 7, SqlFieldName = ID_CustomFreq ];

/// 开始日期
Property IDDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = ID_DateFrom ];

/// 截止日期
Property IDDateTo As %Date [ SqlColumnNumber = 9, SqlFieldName = ID_DateTo ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDCode</Value>
</Value>
<Value name="3">
<Value>IDDesc</Value>
</Value>
<Value name="4">
<Value>IDKeyWord</Value>
</Value>
<Value name="5">
<Value>IDNote</Value>
</Value>
<Value name="6">
<Value>IDDateFrom</Value>
</Value>
<Value name="7">
<Value>IDDateTo</Value>
</Value>
<Value name="8">
<Value>IDFreq</Value>
</Value>
<Value name="9">
<Value>IDCustomFreq</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ItemDetail")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ItemDetail")</IdLocation>
<IndexLocation>^DHCNurPlani("ItemDetail",0)</IndexLocation>
<SqlChildSub>ID_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCNurPlanItemDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
