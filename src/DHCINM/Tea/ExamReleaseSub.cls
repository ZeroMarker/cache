/// Creator:lulin
/// Descriptions:考核任务考生
/// Date:2020-08-07
Class DHCINM.Tea.ExamReleaseSub Extends %Persistent
{

Relationship Parref As DHCINM.Tea.ExamRelease [ Cardinality = parent, Inverse = ChildSub ];

/// 人员
Property UserDR As %Integer [ SqlColumnNumber = 2, SqlFieldName = UserDR ];

/// 病区
Property WardDR As %Integer [ SqlColumnNumber = 3, SqlFieldName = WardDR ];

/// 异常说明
Property ExceptionDR As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 4, SqlFieldName = ExceptionDR ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 5, SqlFieldName = Remark ];

/// 成绩是否计入统计:Y：是，N:否
Property ScoreUsedFlag As %String [ SqlColumnNumber = 6, SqlFieldName = ScoreUsedFlag ];

/// 预约批次
Property OrderNum As %String [ SqlColumnNumber = 7, SqlFieldName = OrderNum ];

Index User On (Parref, UserDR);

Storage Default
{
<Data name="ExamReleaseSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserDR</Value>
</Value>
<Value name="3">
<Value>WardDR</Value>
</Value>
<Value name="4">
<Value>ExceptionDR</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>ScoreUsedFlag</Value>
</Value>
<Value name="7">
<Value>OrderNum</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.ExamReleaseSubD</DataLocation>
<DefaultData>ExamReleaseSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Tea.ExamReleaseSubI</IndexLocation>
<StreamLocation>^DHCINM.Tea.ExamReleaseSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
