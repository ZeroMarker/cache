/// Creater:wangpf
/// Descriptions:质控查房、夜查房子表
/// Date:2020-06-12
Class DHCINM.CHK.MgCheckResultSub Extends %Persistent
{

Relationship Parref As DHCINM.CHK.MgCheckResult [ Cardinality = parent, Inverse = ChildSub ];

/// 检查条目
Property SubItem As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Sub_Item ];

/// 条目得分
Property SubScore As %String [ SqlColumnNumber = 3, SqlFieldName = Sub_Score ];

/// 条目标准
Property SubStandard As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = Sub_Standard ];

/// 条目标准分值
Property SubStandardScore As %String [ SqlColumnNumber = 5, SqlFieldName = Sub_StandardScore ];

/// 备注
Property SubRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = Sub_Remark ];

/// 对应质控项目条目
Property SubReference As CT.DHCINM.DB.MgQualItemSub [ SqlColumnNumber = 7, SqlFieldName = Sub_Reference ];

/// 父节点
Property SubParent As DHCINM.CHK.MgCheckResultSub [ SqlColumnNumber = 8, SqlFieldName = Sub_Parent ];

/// 排序
Property SubSort As %String [ SqlColumnNumber = 9, SqlFieldName = Sub_Sort ];

/// 评价标准
Property SubStandardList As %String(MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = Sub_StandardList ];

/// 复查结果 Y:通过 N:未通过
Property SubReview As %String [ SqlColumnNumber = 11, SqlFieldName = Sub_Review ];

/// 复查人
Property SubReviewUser As %String [ SqlColumnNumber = 12, SqlFieldName = Sub_ReviewUser ];

/// 复查日期
Property SubReviewDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Sub_ReviewDate ];

/// 复查时间
Property SubReviewTime As %Time [ SqlColumnNumber = 14, SqlFieldName = Sub_ReviewTime ];

/// 符合模式-分值状态扣分
Property SubAccordScore As %String [ SqlColumnNumber = 15, SqlFieldName = Sub_AccordScore ];

Index Par On SubParent;

Index Sort On (Parref, SubSort);

Index Qual On (Parref, SubReference);

Storage Default
{
<Data name="MgCheckResultSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubItem</Value>
</Value>
<Value name="3">
<Value>SubScore</Value>
</Value>
<Value name="4">
<Value>SubStandard</Value>
</Value>
<Value name="5">
<Value>SubStandardScore</Value>
</Value>
<Value name="6">
<Value>SubRemark</Value>
</Value>
<Value name="7">
<Value>SubReference</Value>
</Value>
<Value name="8">
<Value>SubParent</Value>
</Value>
<Value name="9">
<Value>SubSort</Value>
</Value>
<Value name="10">
<Value>SubStandardList</Value>
</Value>
<Value name="11">
<Value>SubReview</Value>
</Value>
<Value name="12">
<Value>SubReviewUser</Value>
</Value>
<Value name="13">
<Value>SubReviewDate</Value>
</Value>
<Value name="14">
<Value>SubReviewTime</Value>
</Value>
<Value name="15">
<Value>SubAccordScore</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgCheckResultSubD</DataLocation>
<DefaultData>MgCheckResultSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.CHK.MgCheckResultSubI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgCheckResultSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
