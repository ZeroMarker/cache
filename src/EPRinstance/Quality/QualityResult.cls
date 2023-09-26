/// ************************************************************
/// * Class Name:	EPRinstance.Quality.QualityResult
/// * Description:	The model of quality result
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-07-21
/// ************************************************************/
Class EPRinstance.Quality.QualityResult Extends %Library.Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxRuleID On RuleDR;

Index IdxExamineDate On ExamineDate;

Index IdxEpisodeRuleID On (EpisodeID, RuleDR);

Index IdxRuleEpisodeID On (RuleDR, EpisodeID);

Index IdxComposite On (EpisodeID, RuleDR, ExamineDate);

Index IdxCompositeUser On (EpisodeID, RuleDR, ExamineDate, SignUserDR);

Index IdxCompositeAction On (EpisodeID, RuleDR, Action, ExamineDate, SignUserDR) [ Unique ];

Relationship Details As EPRinstance.Quality.QualityResultDetail [ Cardinality = children, Inverse = TheResult ];

/// Represent current visit for one patient
Property EpisodeID As %String(TRUNCATE = 1);

/// Quality rule reference
Property RuleDR As %String(TRUNCATE = 1);

/// 实际得分
Property ActualScore As %String(TRUNCATE = 1);

/// 实际扣分
Property ActualDeScore As %String(TRUNCATE = 1);

/// Represent the grade of current EPR
Property GradeDR As %String(TRUNCATE = 1);

/// User reference, represent who will take responsibility
Property SignUserDR As %String(TRUNCATE = 1);

/// 检查时间 (出院为出院时间加7天)
Property ExamineDate As %String(TRUNCATE = 1);

/// Examine time
Property ExamineTime As %String(TRUNCATE = 1);

/// Execute date, system format
Property ExecuteDate As %String(TRUNCATE = 1);

/// Execute time
Property ExecuteTime As %String(TRUNCATE = 1);

/// Is active for this result
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Resume, mainly for manual examine to write reasons
Property ResumeText As %Library.String(COLLATION = "Exact", TRUNCATE = 0);

/// 实际级别
Property ActualGrade As %String(TRUNCATE = 1);

/// 手工质控操作类型
Property Action As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActualDeScore</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ExamineDate</Value>
</Value>
<Value name="5">
<Value>ExamineTime</Value>
</Value>
<Value name="6">
<Value>ExecuteDate</Value>
</Value>
<Value name="7">
<Value>ExecuteTime</Value>
</Value>
<Value name="8">
<Value>GradeDR</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>ResumeText</Value>
</Value>
<Value name="11">
<Value>RuleDR</Value>
</Value>
<Value name="12">
<Value>ActualScore</Value>
</Value>
<Value name="13">
<Value>SignUserDR</Value>
</Value>
<Value name="14">
<Value>ActualGrade</Value>
</Value>
<Value name="15">
<Value>Action</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityResultD</DataLocation>
<DefaultData>QualityResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRQ.QualityResultD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityResultI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
