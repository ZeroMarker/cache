/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityResultDetail
/// * Description:	The model of quality result detail
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-07-21
/// ************************************************************/
Class EPRmeta.Quality.QualityResultDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEntryID On EntryDR;

Index IdxEpisodeID On EpisodeID;

Index IdxEpisodeEntryID On (EpisodeID, EntryDR);

Relationship TheResult As EPRmeta.Quality.QualityResult [ Cardinality = parent, Inverse = Details ];

//Relationship People As EPRmeta.Quality.QualityResultPeople [ Cardinality = children, Inverse = TheDetail ];

Property People As list Of EPRmeta.Quality.QualityResultPeople;

Property EpisodeID As %String(TRUNCATE = 1);

/// Quality entry reference
Property EntryDR As %String(TRUNCATE = 1);

Property IsMultiExam As %String(TRUNCATE = 1);

/// Current score for <EntryDR>
Property EntryScore As %String(TRUNCATE = 1);

Property EntryGrade As %String(TRUNCATE = 1);

/// Trigger date
Property TriggerDate As %String(TRUNCATE = 1);

/// Whether active or not
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Notes
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0);

Method GetAllPeople() As %ListOfObjects
{
	q ##this.People
}

Storage Default
{
<Data name="QualityResultDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EntryDR</Value>
</Value>
<Value name="4">
<Value>IsMultiExam</Value>
</Value>
<Value name="5">
<Value>EntryScore</Value>
</Value>
<Value name="6">
<Value>EntryGrade</Value>
</Value>
<Value name="7">
<Value>TriggerDate</Value>
</Value>
<Value name="8">
<Value>People</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Details")</DataLocation>
<DefaultData>QualityResultDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Details")</IdLocation>
<IndexLocation>^DHCEPRM.QualityResultDetailI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityResultDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
