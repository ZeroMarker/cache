/// Creator:lulin
/// Descriptions:理论考核、应急预案考核
/// Date:
Class DHCINM.Tea.ExamTheory Extends %Persistent
{

Relationship ChildSub As DHCINM.Tea.ExamTheorySub [ Cardinality = children, Inverse = Parref ];

Relationship ChildEmr As DHCINM.Tea.ExamTheoryEmr [ Cardinality = children, Inverse = ParrefEmr ];

/// 任务发布
Property ReleaseDR As DHCINM.Tea.ExamRelease [ SqlColumnNumber = 2, SqlFieldName = ReleaseDR ];

/// 用户id
Property UserDR As CF.DHCINM.DB.MgUser [ SqlColumnNumber = 3, SqlFieldName = UserDR ];

/// 所在病区
Property WardDR As %String [ SqlColumnNumber = 4, SqlFieldName = WardDR ];

/// 考核日期
Property ExamDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ExamDate ];

/// 总用时秒
Property ExamTime As %String [ SqlColumnNumber = 6, SqlFieldName = ExamTime ];

/// 得分
Property ExamScore As %String [ SqlColumnNumber = 7, SqlFieldName = ExamScore ];

/// 隶属类型：类论:T、应急预案:E
Property ReleaseMode As %String [ SqlColumnNumber = 8, SqlFieldName = ReleaseMode ];

/// 隶属项目
Property ReleaseType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 9, SqlFieldName = ReleaseType ];

/// 共答题次数
Property AnswerTimes As %Integer [ SqlColumnNumber = 10, SqlFieldName = AnswerTimes ];

/// 未阅卷：Y,已阅卷：N
Property AnslyFlag As %String [ SqlColumnNumber = 11, SqlFieldName = AnslyFlag ];

/// 阅卷人
Property Anslyor As %String [ SqlColumnNumber = 12, SqlFieldName = Anslyor ];

/// 阅卷日期
Property AnslyDate As %Date [ SqlColumnNumber = 13, SqlFieldName = AnslyDate ];

/// 阅卷时间
Property AnslyTime As %Time [ SqlColumnNumber = 14, SqlFieldName = AnslyTime ];

/// 自动计算得分
Property ExamAutoScore As %String [ SqlColumnNumber = 15, SqlFieldName = ExamAutoScore ];

/// 阅卷得分
Property ExamAnslyScore As %String [ SqlColumnNumber = 16, SqlFieldName = ExamAnslyScore ];

Index release On ReleaseDR;

Index releaseUser On (ReleaseDR, UserDR);

Index DateWard On (ExamDate, WardDR);

Index WardDate On (WardDR, ExamDate);

Storage Default
{
<Data name="ExamTheoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReleaseDR</Value>
</Value>
<Value name="3">
<Value>UserDR</Value>
</Value>
<Value name="4">
<Value>WardDR</Value>
</Value>
<Value name="5">
<Value>ExamDate</Value>
</Value>
<Value name="6">
<Value>ExamTime</Value>
</Value>
<Value name="7">
<Value>ExamScore</Value>
</Value>
<Value name="8">
<Value>ReleaseMode</Value>
</Value>
<Value name="9">
<Value>ReleaseType</Value>
</Value>
<Value name="10">
<Value>AnswerTimes</Value>
</Value>
<Value name="11">
<Value>AnslyFlag</Value>
</Value>
<Value name="12">
<Value>Anslyor</Value>
</Value>
<Value name="13">
<Value>AnslyDate</Value>
</Value>
<Value name="14">
<Value>AnslyTime</Value>
</Value>
<Value name="15">
<Value>ExamAutoScore</Value>
</Value>
<Value name="16">
<Value>ExamAnslyScore</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.ExamTheoryD</DataLocation>
<DefaultData>ExamTheoryDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.ExamTheoryD</IdLocation>
<IndexLocation>^DHCINM.Tea.ExamTheoryI</IndexLocation>
<StreamLocation>^DHCINM.Tea.ExamTheoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
