/// Creator:lulin
/// Descriptions:考核发布
/// Date:
Class DHCINM.Tea.ExamRelease Extends %Persistent
{

Relationship ChildSub As DHCINM.Tea.ExamReleaseSub [ Cardinality = children, Inverse = Parref ];

/// 隶属类型：类论:T、技操:O、应急预案:E
Property ReleaseMode As %String [ SqlColumnNumber = 2, SqlFieldName = ReleaseMode ];

/// 隶属项目
Property ReleaseType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = ReleaseType ];

/// 考核级别H:院级,L:科级,W:病区
Property ReleaseLevel As %String [ SqlColumnNumber = 4, SqlFieldName = ReleaseLevel ];

/// 考核主题
Property ReleaseDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = ReleaseDesc ];

/// 考核时长
Property Duration As %Integer [ SqlColumnNumber = 6, SqlFieldName = Duration ];

/// 及格成绩
Property ReleasePass As %Integer [ SqlColumnNumber = 7, SqlFieldName = ReleasePass ];

/// 是否可重考N:否，Y:是
Property ReleaseResit As %String [ SqlColumnNumber = 8, SqlFieldName = ReleaseResit ];

/// 重考次数：1、2、3、N:不限定
Property ReleaseResitNum As %String [ SqlColumnNumber = 9, SqlFieldName = ReleaseResitNum ];

/// 考官
Property Examiner As list Of %String [ SqlColumnNumber = 10, SqlFieldName = Examiner ];

/// 关联培训【暂时不管】
Property ReleaseTrain As list Of %String [ SqlColumnNumber = 11, SqlFieldName = ReleaseTrain ];

/// 考核人群类别
Property Examinee As %String [ SqlColumnNumber = 12, SqlFieldName = Examinee ];

/// 考核人群类型
Property ExamineeList As list Of %String [ SqlColumnNumber = 13, SqlFieldName = ExamineeList ];

/// 考核时间多个
Property TimeList As list Of %String [ SqlColumnNumber = 14, SqlFieldName = TimeList ];

/// 出卷方式 I:智能,H:手动,C:调用试卷,
Property PaperType As %String [ SqlColumnNumber = 15, SqlFieldName = PaperType ];

/// 出卷实际方式 I:智能,H:手动
Property RealPaperType As %String [ SqlColumnNumber = 16, SqlFieldName = RealPaperType ];

/// 试卷
Property ReleasePaper As %String [ SqlColumnNumber = 17, SqlFieldName = ReleasePaper ];

/// 是否固定试卷：Y:是，N:否
Property ReleaseDraw As %String [ SqlColumnNumber = 18, SqlFieldName = ReleaseDraw ];

/// 总分
Property Score As %String [ SqlColumnNumber = 19, SqlFieldName = Score ];

/// 考核范围
Property QuestRange As list Of %String [ SqlColumnNumber = 20, SqlFieldName = QuestRange ];

/// 考核范围--流程图
Property QuestRangeEmr As list Of %String [ SqlColumnNumber = 21, SqlFieldName = QuestRangeEmr ];

/// 状态:N/"":保存,Y:发布,
Property Status As %String [ SqlColumnNumber = 22, SqlFieldName = Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 23, SqlFieldName = Creator ];

/// 创建日期
Property CreatDate As %Date [ SqlColumnNumber = 24, SqlFieldName = CreatDate ];

/// 创建时间
Property CreatTime As %Time [ SqlColumnNumber = 25, SqlFieldName = CreatTime ];

/// 智能组卷-固定组卷
Property QuestRangeI As list Of %String [ SqlColumnNumber = 26, SqlFieldName = QuestRangeI ];

/// 阅卷人
Property Markor As %String(MAXLEN = 500) [ SqlColumnNumber = 27, SqlFieldName = Markor ];

/// 阅卷是否显示考生信息
Property MarkShowFlag As %String [ SqlColumnNumber = 28, SqlFieldName = MarkShowFlag ];

/// 考核病区
Property ExamineeWard As %String(MAXLEN = 500) [ SqlColumnNumber = 29, SqlFieldName = ExamineeWard ];

Index Mode On ReleaseMode;

Storage Default
{
<Data name="ExamReleaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReleaseMode</Value>
</Value>
<Value name="3">
<Value>ReleaseType</Value>
</Value>
<Value name="4">
<Value>ReleaseLevel</Value>
</Value>
<Value name="5">
<Value>ReleaseDesc</Value>
</Value>
<Value name="6">
<Value>Duration</Value>
</Value>
<Value name="7">
<Value>ReleasePass</Value>
</Value>
<Value name="8">
<Value>ReleaseResit</Value>
</Value>
<Value name="9">
<Value>ReleaseResitNum</Value>
</Value>
<Value name="10">
<Value>Examiner</Value>
</Value>
<Value name="11">
<Value>ReleaseTrain</Value>
</Value>
<Value name="12">
<Value>Examinee</Value>
</Value>
<Value name="13">
<Value>ExamineeList</Value>
</Value>
<Value name="14">
<Value>TimeList</Value>
</Value>
<Value name="15">
<Value>PaperType</Value>
</Value>
<Value name="16">
<Value>RealPaperType</Value>
</Value>
<Value name="17">
<Value>ReleasePaper</Value>
</Value>
<Value name="18">
<Value>ReleaseDraw</Value>
</Value>
<Value name="19">
<Value>Score</Value>
</Value>
<Value name="20">
<Value>QuestRange</Value>
</Value>
<Value name="21">
<Value>QuestRangeEmr</Value>
</Value>
<Value name="22">
<Value>Status</Value>
</Value>
<Value name="23">
<Value>Creator</Value>
</Value>
<Value name="24">
<Value>CreatDate</Value>
</Value>
<Value name="25">
<Value>CreatTime</Value>
</Value>
<Value name="26">
<Value>QuestRangeI</Value>
</Value>
<Value name="27">
<Value>Markor</Value>
</Value>
<Value name="28">
<Value>MarkShowFlag</Value>
</Value>
<Value name="29">
<Value>ExamineeWard</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.ExamReleaseD</DataLocation>
<DefaultData>ExamReleaseDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.ExamReleaseD</IdLocation>
<IndexLocation>^DHCINM.Tea.ExamReleaseI</IndexLocation>
<StreamLocation>^DHCINM.Tea.ExamReleaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
