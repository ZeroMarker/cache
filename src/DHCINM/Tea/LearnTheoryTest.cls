/// Creator:
/// Descriptions:章节练习主表
/// Date:
Class DHCINM.Tea.LearnTheoryTest Extends %Persistent
{

/// 用户外键
Property UserDR As %Integer [ Required, SqlColumnNumber = 2, SqlFieldName = UserDR ];

/// 题目外键
Property TeaTheorySubDR As CF.DHCINM.DB.TeaTheorySub [ Required, SqlColumnNumber = 3, SqlFieldName = TeaTheorySubDR ];

/// 用时--秒
Property UsedTime As %Integer [ SqlColumnNumber = 4, SqlFieldName = UsedTime ];

/// 答案
Property Result As %String [ SqlColumnNumber = 5, SqlFieldName = Result ];

/// 答题日期
Property AnswerDate As %Date [ SqlColumnNumber = 6, SqlFieldName = AnswerDate ];

/// 答题时间
Property AnswerTime As %Time [ SqlColumnNumber = 7, SqlFieldName = AnswerTime ];

/// 第几次解答【需要保证每次答题都是一个顺序】
Property AnswerTimes As %Integer [ SqlColumnNumber = 8, SqlFieldName = AnswerTimes ];

/// 0≤x≤1得分权重，2：需要手动阅卷,
Property CorrectFlag As %String [ SqlColumnNumber = 9, SqlFieldName = CorrectFlag ];

Index PerTheory On (UserDR, TeaTheorySubDR);

Index Theory On TeaTheorySubDR;

Storage Default
{
<Data name="LearnTheoryTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserDR</Value>
</Value>
<Value name="3">
<Value>TeaTheorySubDR</Value>
</Value>
<Value name="4">
<Value>UsedTime</Value>
</Value>
<Value name="5">
<Value>Result</Value>
</Value>
<Value name="6">
<Value>AnswerDate</Value>
</Value>
<Value name="7">
<Value>AnswerTime</Value>
</Value>
<Value name="8">
<Value>AnswerTimes</Value>
</Value>
<Value name="9">
<Value>CorrectFlag</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.LearnTheoryTestD</DataLocation>
<DefaultData>LearnTheoryTestDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.LearnTheoryTestD</IdLocation>
<IndexLocation>^DHCINM.Tea.LearnTheoryTestI</IndexLocation>
<StreamLocation>^DHCINM.Tea.LearnTheoryTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
