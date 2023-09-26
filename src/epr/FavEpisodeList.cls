Class epr.FavEpisodeList Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 87;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "Name";

Parameter SQLROWID = "ID";

Property Name As %String(TRUNCATE = 1);

Property DefaultList As %Boolean [ InitialExpression = 0 ];

Property Episodes As array Of %String(TRUNCATE = 1);

Property UserDR As User.SSUser;

Index UserIndex On UserDR;

ClassMethod GetDefaultList(UserID As %String = "") As %String
{
}

ClassMethod CreateDefaultList(UserID As %String = "") As %String
{
}

Query LookUpByUserID(desc As %String, UserID As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String")
{
SELECT Name,ID
FROM epr.FavEpisodeList
WHERE ((UserDR->SSUSR_RowId = :UserID)
AND (%ALPHAUP Name %STARTSWITH %ALPHAUP :desc))
}

ClassMethod LookUpBrokerByUserID(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", UserID As %String = "") As %Boolean
{
}

ClassMethod websysSaveList(compref As %String, id As %String)
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

/// ab 25.09.03 - adds an episode to a favourites list
ClassMethod AddEpsToList(ListID As %String = "", EpisodeIDs As %String = "") As %Boolean
{
}

/// ab 26.09.03 - removes an episode from a favourites list
ClassMethod RemEpsFromList(ListID As %String = "", EpisodeID As %String = "")
{
}

/// ab 26.09.03 - returns a delimited string of episodes from a favourites list
ClassMethod GetEpsList(ListID As %String = "", delim As %String = "") As %String
{
}

Storage Default
{
<Data name="FavEpisodeListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Episodes</Value>
</Value>
<Value name="4">
<Value>UserDR</Value>
</Value>
<Value name="5">
<Value>DefaultList</Value>
</Value>
</Data>
<DataLocation>^epr.FavEpisodeListD</DataLocation>
<DefaultData>FavEpisodeListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.FavEpisodeListD</IdLocation>
<IndexLocation>^epr.FavEpisodeListI</IndexLocation>
<StreamLocation>^epr.FavEpisodeListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
