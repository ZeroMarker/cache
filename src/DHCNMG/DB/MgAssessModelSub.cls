/// Creater:王聪聪
/// Descriptions:考核项目子表
/// Date:2019-09-07
Class DHCNMG.DB.MgAssessModelSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgAssessModel [ Cardinality = parent, Inverse = ChildSub ];

/// 考核条目
Property AssessItem As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Assess_Item ];

/// 条目得分
Property AssessItemScore As %String [ SqlColumnNumber = 3, SqlFieldName = AssessItem_Score ];

/// 条目标准
Property AssessItemStand As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = AssessItem_Stand ];

/// 条目标准分值
Property StandardScore As %String [ SqlColumnNumber = 5, SqlFieldName = Standard_Score ];

/// 备注
Property AssessItemRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = AssessItem_Remark ];

/// 对应标版、重组模板ID
Property AssessModelDR As %String [ SqlColumnNumber = 7, SqlFieldName = Assess_ModelDR ];

/// 条目级别位
Property ItemFlag As %String [ SqlColumnNumber = 8, SqlFieldName = Item_Flag ];

/// 合并数量
Property AssessColSpan As %String [ SqlColumnNumber = 9, SqlFieldName = Assess_ColSpan ];

/// 父节点id
Property AssessItemParentDR As %String [ SqlColumnNumber = 10, SqlFieldName = AssessItem_ParentDR ];

/// 二级指标分数
Property AssessTwoScore As %String [ SqlColumnNumber = 11, SqlFieldName = Assess_TwoScore ];

/// 排序
Property AssessSort As %String [ SqlColumnNumber = 12, SqlFieldName = Assess_Sort ];

/// 来源
Property AssessType As %Integer [ SqlColumnNumber = 13, SqlFieldName = Assess_Type ];

/// 星星颗数
Property AssessNum As %Integer [ SqlColumnNumber = 14, SqlFieldName = Assess_Num ];

Index par On AssessItemParentDR;

Index Sort On (Parref, AssessSort);

Index model On (AssessType, AssessModelDR);

Storage Default
{
<Data name="MgAssessModelSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssessItem</Value>
</Value>
<Value name="3">
<Value>AssessItemScore</Value>
</Value>
<Value name="4">
<Value>AssessItemStand</Value>
</Value>
<Value name="5">
<Value>StandardScore</Value>
</Value>
<Value name="6">
<Value>AssessItemRemark</Value>
</Value>
<Value name="7">
<Value>AssessModelDR</Value>
</Value>
<Value name="8">
<Value>ItemFlag</Value>
</Value>
<Value name="9">
<Value>AssessColSpan</Value>
</Value>
<Value name="10">
<Value>AssessItemParentDR</Value>
</Value>
<Value name="11">
<Value>AssessTwoScore</Value>
</Value>
<Value name="12">
<Value>AssessSort</Value>
</Value>
<Value name="13">
<Value>AssessType</Value>
</Value>
<Value name="14">
<Value>AssessNum</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgAssessModelSubD</DataLocation>
<DefaultData>MgAssessModelSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgAssessModelSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgAssessModelSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
