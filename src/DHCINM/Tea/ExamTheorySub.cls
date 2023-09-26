/// Creator:lulin
/// Descriptions:理论\应急预案--理论题
/// Date:
Class DHCINM.Tea.ExamTheorySub Extends %Persistent
{

Relationship Parref As DHCINM.Tea.ExamTheory [ Cardinality = parent, Inverse = ChildSub ];

/// 题目对应外键
Property ExamSubDR As CF.DHCINM.DB.TeaTheorySub [ SqlColumnNumber = 2, SqlFieldName = ExamSubDR ];

/// 答案
Property Result As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = ExamAnswer ];

/// 得分
Property GetScore As %String [ SqlColumnNumber = 4, SqlFieldName = GetScore ];

/// 总分
Property ExamScore As %String [ SqlColumnNumber = 5, SqlFieldName = ExamScore ];

/// 用时
Property ExamTime As %String [ SqlColumnNumber = 6, SqlFieldName = ExamTime ];

/// 题目
Property SubDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = SubDesc ];

/// 配图url
Property SubUrl As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 8, SqlFieldName = SubUrl ];

/// 方式单选:S、多选:M
Property SubMode As %String [ SqlColumnNumber = 9, SqlFieldName = SubMode ];

/// 题型
Property SubTypeDR As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 10, SqlFieldName = SubTypeDR ];

/// 选项
Property SubOption As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 11, SqlFieldName = SubOption ];

/// 标准答案
Property SubAnswer As %String [ SqlColumnNumber = 12, SqlFieldName = SubAnswer ];

/// 题源
Property SubSource As %String [ SqlColumnNumber = 13, SqlFieldName = SubSource ];

/// 解析
Property SubAnalysis As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = SubAnalysis ];

/// 0≤x≤1得分权重，2：需要手动阅卷,
Property CorrectFlag As %String [ SqlColumnNumber = 15, SqlFieldName = CorrectFlag ];

/// 第几次解答
Property AnswerTimes As %Integer [ SqlColumnNumber = 16, SqlFieldName = AnswerTimes ];

/// 未阅卷：Y
Property AnslyFlag As %String [ SqlColumnNumber = 17, SqlFieldName = AnslyFlag ];

/// 批注
Property AnalyContext As %String(MAXLEN = 1000) [ SqlColumnNumber = 18, SqlFieldName = AnalyContext ];

Index ExamSubDR On ExamSubDR;

Index AnslyFlag On AnslyFlag;

Storage Default
{
<Data name="ExamTheorySubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamSubDR</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
<Value name="4">
<Value>GetScore</Value>
</Value>
<Value name="5">
<Value>ExamScore</Value>
</Value>
<Value name="6">
<Value>ExamTime</Value>
</Value>
<Value name="7">
<Value>SubDesc</Value>
</Value>
<Value name="8">
<Value>SubUrl</Value>
</Value>
<Value name="9">
<Value>SubMode</Value>
</Value>
<Value name="10">
<Value>SubTypeDR</Value>
</Value>
<Value name="11">
<Value>SubOption</Value>
</Value>
<Value name="12">
<Value>SubAnswer</Value>
</Value>
<Value name="13">
<Value>SubSource</Value>
</Value>
<Value name="14">
<Value>SubAnalysis</Value>
</Value>
<Value name="15">
<Value>CorrectFlag</Value>
</Value>
<Value name="16">
<Value>AnswerTimes</Value>
</Value>
<Value name="17">
<Value>AnslyFlag</Value>
</Value>
<Value name="18">
<Value>AnalyContext</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.ExamTheorySubD</DataLocation>
<DefaultData>ExamTheorySubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Tea.ExamTheorySubI</IndexLocation>
<StreamLocation>^DHCINM.Tea.ExamTheorySubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
