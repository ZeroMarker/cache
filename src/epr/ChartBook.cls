/// A group (collection list) of charts
Class epr.ChartBook Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 120;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "Description";

Parameter SQLDESCRIPTION = "Description";

Parameter SQLROWID = "ID";

Property ChartList As list Of epr.Chart;

Property Description As %Library.String(COLLATION = "AlphaUp", TRUNCATE = 1) [ Required ];

Property LeftChartList As list Of epr.Chart;

Property ShowTimeline As %Library.Boolean;

/// Uniqueness index for property Description
Index UniqueDescriptionIndex On Description [ Unique ];

/// ab 24.03.06 58654
/// by wuqk 2011-06-05
ClassMethod CopyChartbook(ID As %String = "", Name As %String = "")
{
}

ClassMethod LookUpItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpItemsFetch ]
{
}

ClassMethod LookUpItemsExecute(ByRef QHandle As %Library.Binary, ID As %String, List As %Library.String) As %Library.Status
{
}

ClassMethod LookUpItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpItemsExecute ]
{
}

ClassMethod ShowSideBar(ChartBookID As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String, mradm As %Library.String)
{
}

ClassMethod ShowTopBar(ChartBookID As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String, mradm As %Library.String)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
/// by wuqk 2011-06-05
ClassMethod websysSave(compref As %String, ChartBookID As %String)
{
}

/// by wuqk 2011-06-01
Query LookUpItems(ID As %Library.String, List As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ChartID:%Library.String,ChartName:%Library.String")
{
}

Query VBFindLE(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Description:%Library.String")
{
SELECT	ID, Description
FROM	epr.ChartBook
WHERE	(Description %STARTSWITH :desc)
ORDER	BY Description
}

ClassMethod ToJson(ChartBookID)
{
}

Storage Default
{
<Data name="ChartBookClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="ChartBookDefaultData">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>ChartList</Value>
</Value>
<Value name="3">
<Value>LeftChartList</Value>
</Value>
<Value name="4">
<Value>ShowTimeline</Value>
</Value>
</Data>
<DataLocation>^epr.ChartBookD</DataLocation>
<DefaultData>ChartBookDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.ChartBookD</IdLocation>
<IndexLocation>^epr.ChartBookI</IndexLocation>
<StreamLocation>^epr.ChartBookS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
