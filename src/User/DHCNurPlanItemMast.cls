/// 护理计划项目
Class User.DHCNurPlanItemMast Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = IM_RowId, SqlTableName = DHC_NurPlan_ItemMast ]
{

Relationship ChildItemDetail As User.DHCNurPlanItemDetail [ Cardinality = children, Inverse = IDParRef ];

Relationship ChildItemTrigger As User.DHCNurPlanItemTrigger [ Cardinality = children, Inverse = ITParRef ];

Relationship ChildItemComlete As User.DHCNurPlanItemComplete [ Cardinality = children, Inverse = ICParRef ];

/// 代码
Property IMCode As %String [ SqlColumnNumber = 2, SqlFieldName = IM_Code ];

/// 描述
Property IMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = IM_Desc ];

/// 备注
Property IMNote As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = IM_Note ];

/// 关键字
Property IMKeyWord As %String [ SqlColumnNumber = 5, SqlFieldName = IM_KeyWord ];

/// 科室
Property IMLocID As %String [ SqlColumnNumber = 6, SqlFieldName = IM_LocID ];

/// User.DHCNurPlanItemType  项目类型
Property IMItemType As %String [ SqlColumnNumber = 7, SqlFieldName = IM_ItemType_DR ];

/// User.DHCNurPlanItemCategory  项目类别
Property IMItemCat As %String [ SqlColumnNumber = 8, SqlFieldName = IM_ItemCat_DR ];

/// 开始日期
Property IMDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = IM_DateFrom ];

/// 截止日期
Property IMDateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = IM_DateTo ];

/// 频次
Property IMFreq As %String [ SqlColumnNumber = 11, SqlFieldName = IM_Freq ];

/// 自定义频次
Property IMCustomFreq As %String [ SqlColumnNumber = 12, SqlFieldName = IM_CustomFreq ];

Index ItemType On IMItemType;

Index ItemCat On IMItemCat;

Index Loc On IMLocID;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IMCode</Value>
</Value>
<Value name="3">
<Value>IMDesc</Value>
</Value>
<Value name="4">
<Value>IMItemType</Value>
</Value>
<Value name="5">
<Value>IMItemCat</Value>
</Value>
<Value name="6">
<Value>IMDateFrom</Value>
</Value>
<Value name="7">
<Value>IMDateTo</Value>
</Value>
<Value name="8">
<Value>IMKeyWord</Value>
</Value>
<Value name="9">
<Value>IMLocID</Value>
</Value>
<Value name="10">
<Value>IMFreq</Value>
</Value>
<Value name="11">
<Value>IMNote</Value>
</Value>
<Value name="12">
<Value>IMCustomFreq</Value>
</Value>
</Data>
<DataLocation>^DHCNurPlan("Item")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCNurPlan("Item")</IdLocation>
<IndexLocation>^DHCNurPlani("Item",0)</IndexLocation>
<StreamLocation>^User.DHCNurPlanItemMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
