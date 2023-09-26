/// Creater:lulin
/// Descriptions:技操考核子表
/// Date:2020-07-20
Class DHCINM.Tea.ExamOperaSub Extends %Persistent
{

Relationship Parref As DHCINM.Tea.ExamOpera [ Cardinality = parent, Inverse = ChildSub ];

/// 检查条目
Property SubDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = SubDesc ];

/// 条目得分
Property SubScore As %String [ SqlColumnNumber = 3, SqlFieldName = SubScore ];

/// 条目标准
Property SubStandard As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = SubStandard ];

/// 条目标准分值
Property SubStandardScore As %String [ SqlColumnNumber = 5, SqlFieldName = SubStandardScore ];

/// 备注
Property SubRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = SubRemark ];

/// 对应条目
Property SubReference As CF.DHCINM.DB.TeaOperaSub [ SqlColumnNumber = 7, SqlFieldName = SubReference ];

/// 父节点
Property SubPar As DHCINM.Tea.ExamOperaSub [ SqlColumnNumber = 8, SqlFieldName = SubPar ];

/// 排序
Property SubSort As %String [ SqlColumnNumber = 9, SqlFieldName = SubSort ];

/// 评价标准
Property SubStand As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = SubStand ];

Index Par On SubPar;

Index Sort On (Parref, SubSort);

Index ParrefRefer On (Parref, SubReference);

Index Refer On SubReference;

Storage Default
{
<Data name="ExamOperaSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubDesc</Value>
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
<Value>SubPar</Value>
</Value>
<Value name="9">
<Value>SubSort</Value>
</Value>
<Value name="10">
<Value>SubStand</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.ExamOperaSubD</DataLocation>
<DefaultData>ExamOperaSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Tea.ExamOperaSubI</IndexLocation>
<StreamLocation>^DHCINM.Tea.ExamOperaSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
