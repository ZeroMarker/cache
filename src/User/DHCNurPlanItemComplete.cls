/// 护理计划项目完成条件
Class User.DHCNurPlanItemComplete Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = IC_RowId, SqlTableName = DHC_NurPlan_ItemComplete ]
{

Relationship ICParRef As User.DHCNurPlanItemMast [ Cardinality = parent, Inverse = ChildItemComlete, SqlFieldName = IC_ParRef ];

/// 完成因素
Property ICCompleteFactor As %String [ SqlColumnNumber = 2, SqlFieldName = IC_CompleteFactor ];

/// 医嘱项ID
Property ICArcimID As %String [ SqlColumnNumber = 3, SqlFieldName = IC_ArcimID ];

/// 如果是评分或体征的话,此处为单据模版关键字
Property ICEmrCode As %String [ SqlColumnNumber = 4, SqlFieldName = IC_EmrCode ];

/// 如果是评分或体征的话,此处为单据元素关键字
Property ICElementCode As %String [ SqlColumnNumber = 5, SqlFieldName = IC_ElementCode ];

/// 条件类型 =,>,>=,<,<=
Property ICConTyp As %String [ SqlColumnNumber = 6, SqlFieldName = IC_ConTyp ];

/// 条件值
Property ICConValue As %String [ SqlColumnNumber = 7, SqlFieldName = IC_ConValue ];

/// 接口函数
Property ICFunction As %String [ SqlColumnNumber = 8, SqlFieldName = IC_Function ];

/// 参数
Property ICParameter As %String [ SqlColumnNumber = 9, SqlFieldName = IC_Parameter ];

/// 类型
Property ICFuncType As %String [ SqlColumnNumber = 10, SqlFieldName = IC_FuncType ];

/// 备注说明
Property ICNote As %String [ SqlColumnNumber = 11, SqlFieldName = IC_Note ];

Property ICUpdateUser As %String [ SqlColumnNumber = 12, SqlFieldName = IC_UpdateUser ];

Property ICUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = IC_UpdateDate ];

Property ICUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = IC_UpdateTime ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICArcimID</Value>
</Value>
<Value name="3">
<Value>ICUpdateUser</Value>
</Value>
<Value name="4">
<Value>ICUpdateDate</Value>
</Value>
<Value name="5">
<Value>ICUpdateTime</Value>
</Value>
<Value name="6">
<Value>ICCompleteFactor</Value>
</Value>
<Value name="7">
<Value>ICEmrCode</Value>
</Value>
<Value name="8">
<Value>ICElementCode</Value>
</Value>
<Value name="9">
<Value>ICConTyp</Value>
</Value>
<Value name="10">
<Value>ICConValue</Value>
</Value>
<Value name="11">
<Value>ICFunction</Value>
</Value>
<Value name="12">
<Value>ICParameter</Value>
</Value>
<Value name="13">
<Value>ICNote</Value>
</Value>
<Value name="14">
<Value>ICFuncType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ItemComplete")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ItemComplete")</IdLocation>
<IndexLocation>^DHCNurPlani("ItemComplete",0)</IndexLocation>
<SqlChildSub>IC_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCNurPlanItemCompleteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
