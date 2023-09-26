/// Creater:wangpf
/// Descriptions:专业会诊子表
/// Date:2020-07-29
Class DHCINM.Special.SpecialConsSub Extends %Persistent
{

Relationship Parref As DHCINM.Special.SpecialConsult [ Cardinality = parent, Inverse = ChildSub ];

/// 类型
Property SubType As %String [ SqlColumnNumber = 2, SqlFieldName = Sub_Type ];

/// 病区或专业组Id
Property SubValue As %String [ SqlColumnNumber = 3, SqlFieldName = Sub_Value ];

/// 接收人
Property SubAccPer As %String [ SqlColumnNumber = 4, SqlFieldName = Sub_AccPer ];

/// 接收日期
Property SubAccDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Sub_AccDate ];

/// 接收时间
Property SubAccTime As %Time [ SqlColumnNumber = 6, SqlFieldName = Sub_AccTime ];

/// 接收状态 Y:接收 N:拒绝
Property SubAccStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Sub_AccStatus ];

/// 派遣人
Property SubPoPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 8, SqlFieldName = Sub_PoPer ];

/// 派遣日期
Property SubPoDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Sub_PoDate ];

/// 派遣时间
Property SubPoTime As %Time [ SqlColumnNumber = 10, SqlFieldName = Sub_PoTime ];

/// 派遣状态 Y:接收 N:拒绝
Property SubPoStatus As %String [ SqlColumnNumber = 11, SqlFieldName = Sub_PoStatus ];

/// 派遣状态日期
Property SubPoStatusDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Sub_PoStatusDate ];

/// 派遣状态时间
Property SubPoStatusTime As %Time [ SqlColumnNumber = 13, SqlFieldName = Sub_PoStatusTime ];

/// 结论
Property SubConclusion As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Sub_Conclusion ];

/// 历史记录
Property SubHistory As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 15, SqlFieldName = Sub_History ];

/// 结论
Property SubFinish As %String [ SqlColumnNumber = 16, SqlFieldName = Sub_Finish ];

/// 完成日期
Property SubFinishDate As %Date [ SqlColumnNumber = 17, SqlFieldName = Sub_FinishDate ];

/// 完成时间
Property SubFinishTime As %Time [ SqlColumnNumber = 18, SqlFieldName = Sub_FinishTime ];

Storage Default
{
<Data name="SpecialConsSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubType</Value>
</Value>
<Value name="3">
<Value>SubValue</Value>
</Value>
<Value name="4">
<Value>SubAccPer</Value>
</Value>
<Value name="5">
<Value>SubAccDate</Value>
</Value>
<Value name="6">
<Value>SubAccTime</Value>
</Value>
<Value name="7">
<Value>SubAccStatus</Value>
</Value>
<Value name="8">
<Value>SubPoPer</Value>
</Value>
<Value name="9">
<Value>SubPoDate</Value>
</Value>
<Value name="10">
<Value>SubPoTime</Value>
</Value>
<Value name="11">
<Value>SubPoStatus</Value>
</Value>
<Value name="12">
<Value>SubPoStatusDate</Value>
</Value>
<Value name="13">
<Value>SubPoStatusTime</Value>
</Value>
<Value name="14">
<Value>SubConclusion</Value>
</Value>
<Value name="15">
<Value>SubHistory</Value>
</Value>
<Value name="16">
<Value>SubFinish</Value>
</Value>
<Value name="17">
<Value>SubFinishDate</Value>
</Value>
<Value name="18">
<Value>SubFinishTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialConsSubD</DataLocation>
<DefaultData>SpecialConsSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialConsSubI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialConsSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
