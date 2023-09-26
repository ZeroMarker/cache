/// ************************************************************
/// * Class Name:	EPRinstance.Quality.QualityResultDetail
/// * Description:	The model of quality result detail
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-09-14
/// ************************************************************/
Class EPRinstance.Quality.QualityResultDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisodeEntryID On (EpisodeID, EntryDR);

Index IdxResult On TheResult;

// add by HKY 

// RQ质控可查询条目报表

Index IdxEntryID On EntryDR;

Relationship TheResult As EPRinstance.Quality.QualityResult [ Cardinality = parent, Inverse = Details ];

Property People As EPRinstance.Quality.QualityResultPeople;

Property EpisodeID As %String(TRUNCATE = 1);

/// Quality entry reference
Property EntryDR As %String(TRUNCATE = 1);

Property ExamCount As %String(TRUNCATE = 1);

/// Current score for <EntryDR>
Property EntryScore As %String(TRUNCATE = 1);

Property EntryGrade As %String(TRUNCATE = 1);

Property InstanceId As %String(TRUNCATE = 1);

Property EmrDocId As %String(TRUNCATE = 1);

Property Path As %String(TRUNCATE = 1);

/// Trigger date
Property TriggerDate As %String(TRUNCATE = 1);

/// Whether active or not
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Notes
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0);

/// ErrInfo
Property ErrInfo As %Library.String(MAXLEN = 800, TRUNCATE = 0);

Storage Default
{
<Data name="QualityResultDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EntryDR</Value>
</Value>
<Value name="3">
<Value>EntryGrade</Value>
</Value>
<Value name="4">
<Value>EntryScore</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>ExamCount</Value>
</Value>
<Value name="8">
<Value>People</Value>
</Value>
<Value name="9">
<Value>ResumeText</Value>
</Value>
<Value name="10">
<Value>TriggerDate</Value>
</Value>
<Value name="11">
<Value>InstanceId</Value>
</Value>
<Value name="12">
<Value>EmrDocId</Value>
</Value>
<Value name="13">
<Value>Path</Value>
</Value>
<Value name="14">
<Value>ErrInfo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Details")</DataLocation>
<DefaultData>QualityResultDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Details")</IdLocation>
<IndexLocation>^DHCEPRQ.QualityResultDetailI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityResultDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
