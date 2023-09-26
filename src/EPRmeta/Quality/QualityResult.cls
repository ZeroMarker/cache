/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityResult
/// * Description:	The model of quality result
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-07-21
/// ************************************************************/
Class EPRmeta.Quality.QualityResult Extends %Library.Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxRuleDR On RuleDR;

Index IdxEpisodeID On EpisodeID;

Index IdxComposite On (RuleDR, EpisodeID, ExamineDate) [ Unique ];

Relationship Details As EPRmeta.Quality.QualityResultDetail [ Cardinality = children, Inverse = TheResult ];

/// Represent current visit for one patient
Property EpisodeID As %String(TRUNCATE = 1);

/// Quality rule reference
Property RuleDR As %String(TRUNCATE = 1);

/// 当天扣分合计
Property Score As %String(TRUNCATE = 1);

/// 累计扣分合计
Property ActualScore As %String(TRUNCATE = 1);

/// Represent the grade of current EPR
Property GradeDR As %String(TRUNCATE = 1);

/// User reference, represent who will take responsibility
Property SignUserDR As %String(TRUNCATE = 1);

/// Examine date
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

Storage Default
{
<Data name="QualityResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RuleDR</Value>
</Value>
<Value name="4">
<Value>Score</Value>
</Value>
<Value name="5">
<Value>ActualScore</Value>
</Value>
<Value name="6">
<Value>GradeDR</Value>
</Value>
<Value name="7">
<Value>SignUserDR</Value>
</Value>
<Value name="8">
<Value>ExamineDate</Value>
</Value>
<Value name="9">
<Value>ExamineTime</Value>
</Value>
<Value name="10">
<Value>ExecuteDate</Value>
</Value>
<Value name="11">
<Value>ExecuteTime</Value>
</Value>
<Value name="12">
<Value>IsActive</Value>
</Value>
<Value name="13">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityResultD</DataLocation>
<DefaultData>QualityResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityResultD</IdLocation>
<IndexLocation>^DHCEPRM.QualityResultI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
