/// Creator:
/// Descriptions:真题模考
/// Date:
Class DHCINM.Tea.LearnDryRun Extends %Persistent
{

Relationship ChildSub As DHCINM.Tea.LearnDryRunSub [ Cardinality = children, Inverse = Parref ];

/// 隶属项目
Property ReleaseType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 2, SqlFieldName = ReleaseType ];

/// 考核主题
Property ReleaseDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = ReleaseDesc ];

/// 考核时长
Property Duration As %Integer [ SqlColumnNumber = 4, SqlFieldName = Duration ];

/// 及格成绩
Property ReleasePass As %Integer [ SqlColumnNumber = 5, SqlFieldName = ReleasePass ];

/// 出卷方式 I:智能,H:手动,C:调用试卷,
Property PaperType As %String [ SqlColumnNumber = 6, SqlFieldName = PaperType ];

/// 出卷实际方式 I:智能,H:手动
Property RealPaperType As %String [ SqlColumnNumber = 7, SqlFieldName = RealPaperType ];

/// 试卷
Property ReleasePaper As %String [ SqlColumnNumber = 8, SqlFieldName = ReleasePaper ];

/// 总分
Property Score As %String [ SqlColumnNumber = 9, SqlFieldName = Score ];

/// 考核范围
Property QuestRange As list Of %String [ SqlColumnNumber = 10, SqlFieldName = QuestRange ];

/// 状态:N/"":保存,Y:已做
Property Status As %String [ SqlColumnNumber = 11, SqlFieldName = Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 12, SqlFieldName = Creator ];

/// 创建日期
Property CreatDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CreatDate ];

/// 创建时间
Property CreatTime As %Time [ SqlColumnNumber = 14, SqlFieldName = CreatTime ];

/// 考试日期
Property AnswerDate As %Date [ SqlColumnNumber = 15, SqlFieldName = AnswerDate ];

/// 考试时间
Property AnswerTime As %Time [ SqlColumnNumber = 16, SqlFieldName = AnswerTime ];

/// 总用时秒
Property ExamTime As %String [ SqlColumnNumber = 17, SqlFieldName = ExamTime ];

/// 得分
Property ExamScore As %String [ SqlColumnNumber = 18, SqlFieldName = ExamScore ];

Index Creator On Creator;

Storage Default
{
<Data name="LearnDryRunDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReleaseType</Value>
</Value>
<Value name="3">
<Value>ReleaseDesc</Value>
</Value>
<Value name="4">
<Value>Duration</Value>
</Value>
<Value name="5">
<Value>ReleasePass</Value>
</Value>
<Value name="6">
<Value>PaperType</Value>
</Value>
<Value name="7">
<Value>RealPaperType</Value>
</Value>
<Value name="8">
<Value>ReleasePaper</Value>
</Value>
<Value name="9">
<Value>Score</Value>
</Value>
<Value name="10">
<Value>QuestRange</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>Creator</Value>
</Value>
<Value name="13">
<Value>CreatDate</Value>
</Value>
<Value name="14">
<Value>CreatTime</Value>
</Value>
<Value name="15">
<Value>AnswerDate</Value>
</Value>
<Value name="16">
<Value>AnswerTime</Value>
</Value>
<Value name="17">
<Value>ExamTime</Value>
</Value>
<Value name="18">
<Value>ExamScore</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.LearnDryRunD</DataLocation>
<DefaultData>LearnDryRunDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.LearnDryRunD</IdLocation>
<IndexLocation>^DHCINM.Tea.LearnDryRunI</IndexLocation>
<StreamLocation>^DHCINM.Tea.LearnDryRunS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
