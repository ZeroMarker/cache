/// 护理计划项目触发条件
Class User.DHCNurPlanItemTrigger Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = IT_RowId, SqlTableName = DHC_NurPlan_ItemTrigger ]
{

Relationship ITParRef As User.DHCNurPlanItemMast [ Cardinality = parent, Inverse = ChildItemTrigger, SqlFieldName = IT_ParRef ];

/// 触发因素
Property ITTriggerFactor As %String [ SqlColumnNumber = 2, SqlFieldName = IT_TriggerFactor ];

/// 医嘱项ID
Property ITArcimID As %String [ SqlColumnNumber = 3, SqlFieldName = IT_ArcimID ];

/// 事件ID
Property ITEventID As %String [ SqlColumnNumber = 4, SqlFieldName = IT_EventID ];

/// 诊断ID
Property ITDiagID As %String [ SqlColumnNumber = 5, SqlFieldName = IT_DiagID ];

/// 如果是评分或体征的话,此处为单据模版关键字
Property ITEmrCode As %String [ SqlColumnNumber = 6, SqlFieldName = IT_EmrCode ];

/// 如果是评分或体征的话,此处为单据元素关键字
Property ITElementCode As %String [ SqlColumnNumber = 7, SqlFieldName = IT_ElementCode ];

/// 条件类型 =,>,>=,<,<=
Property ITConTyp As %String [ SqlColumnNumber = 8, SqlFieldName = IT_ConTyp ];

/// 条件值
Property ITConValue As %String [ SqlColumnNumber = 9, SqlFieldName = IT_ConValue ];

/// 接口函数
Property ITFunction As %String [ SqlColumnNumber = 10, SqlFieldName = IT_Function ];

/// 参数
Property ITParameter As %String [ SqlColumnNumber = 11, SqlFieldName = IT_Parameter ];

/// 类型
Property ITFuncType As %String [ SqlColumnNumber = 12, SqlFieldName = IT_FuncType ];

/// 备注说明
Property ITNote As %String [ SqlColumnNumber = 13, SqlFieldName = IT_Note ];

/// 频次
Property ITFreq As %String [ SqlColumnNumber = 14, SqlFieldName = IT_Freq ];

/// 自定义频次
Property ITCustomFreq As %String [ SqlColumnNumber = 15, SqlFieldName = IT_CustomFreq ];

Property ITUpdateUser As %String [ SqlColumnNumber = 16, SqlFieldName = IT_UpdateUser ];

Property ITUpdateDate As %Date [ SqlColumnNumber = 17, SqlFieldName = IT_UpdateDate ];

Property ITUpdateTime As %Time [ SqlColumnNumber = 18, SqlFieldName = IT_UpdateTime ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ITArcimID</Value>
</Value>
<Value name="3">
<Value>ITEventID</Value>
</Value>
<Value name="4">
<Value>ITDiagID</Value>
</Value>
<Value name="5">
<Value>ITTriggerFactor</Value>
</Value>
<Value name="6">
<Value>ITEmrCode</Value>
</Value>
<Value name="7">
<Value>ITElementCode</Value>
</Value>
<Value name="8">
<Value>ITConTyp</Value>
</Value>
<Value name="9">
<Value>ITConValue</Value>
</Value>
<Value name="10">
<Value>ITFunction</Value>
</Value>
<Value name="11">
<Value>ITParameter</Value>
</Value>
<Value name="12">
<Value>ITNote</Value>
</Value>
<Value name="13">
<Value>ITUpdateUser</Value>
</Value>
<Value name="14">
<Value>ITUpdateDate</Value>
</Value>
<Value name="15">
<Value>ITUpdateTime</Value>
</Value>
<Value name="16">
<Value>ITFuncType</Value>
</Value>
<Value name="17">
<Value>ITFreq</Value>
</Value>
<Value name="18">
<Value>ITCustomFreq</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ItemTrigger")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ItemTrigger")</IdLocation>
<IndexLocation>^DHCNurPlani("ItemTrigger",0)</IndexLocation>
<SqlChildSub>IT_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCNurPlanItemTriggerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
