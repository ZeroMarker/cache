Class epr.LabGraphTestSets Extends (%Library.Persistent, websys.Abstract) [ Not Abstract, ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2958;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "LGPHCode";

Parameter SQLDESCRIPTION = "LGPHDesc";

Parameter SQLROWID = "ID";

Property LGPHCode As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1) [ Required ];

Property LGPHDesc As %Library.String(TRUNCATE = 1);

Property LGPHLabItemCount As %Library.Integer;

Property LGPHLabItemList As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

/// Uniqueness index for property LGPHCode
Index UniqueLGPHCodeIndex On LGPHCode [ Unique ];

ClassMethod GetTestSetItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetTestSetItemsFetch ]
{
}

ClassMethod GetTestSetItemsExecute(ByRef QHandle As %Library.Binary, ID As %Library.String) As %Library.Status
{
}

ClassMethod GetTestSetItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetTestSetItemsExecute ]
{
}

ClassMethod DisplayCumulative(CanRead As %String)
{
}

ClassMethod LabCummResultsGet(PatientID As %Library.String, TestCodeIDs As %Library.String, stdate As %Library.Date, enddate As %Library.Date, TimeFrom As %Library.Time, TimeTo As %Library.Time, ByRef dtmLIST As %Library.String, ByRef chLIST As %Library.String, refLIST As %Library.String, EpisodesAll As %String = "", EpisodeIDs As %String = "", Start As %String = "", Columns As %String = "")
{
}

ClassMethod Sort(ByRef refLIST, params)
{
}

ClassMethod GetCol(ByRef column, ByRef ColValid, ByRef chLIST, ByRef dtmLIST, ByRef arrLabEpisode, date, time, lab, ts, ByRef TSLayout, TestCodeIDs, Start, ByRef Reas, ByRef Display)
{
}

/// KM: 21May2001: Called from epr.Chart.csp
ClassMethod LabCummResultsShow(ByRef dtmLIST As %Library.String, ByRef chLIST As %Library.String, ByRef refLIST As %Library.String, minslots As %Library.String = 60, heading As %Library.String = "", ChartID As %Library.String = "", ItemID As %Library.String = "", Type As %Library.String = "", Context As %Library.String = "", Columns As %Library.String = "", Start As %Library.String = "", IncludeRPrefix As %Library.String = "", ColumnID As %Library.String = "", RefRangePosition As %Library.String = "", CanRead As %String, ColumnWidth As %Library.String = "", ResultJustification As %Library.String = "")
{
}

ClassMethod LabCummResultsGetOLD1(PatientID As %Library.String, TestCodeIDs As %Library.String, stdate As %Library.Date, enddate As %Library.Date, TimeFrom As %Library.Time, TimeTo As %Library.Time, ByRef dtmLIST As %Library.String, ByRef chLIST As %Library.String, refLIST As %Library.String, EpisodesAll As %String = "", EpisodeIDs As %String = "", Start As %String = "", Columns As %String = "")
{
}

/// KM: 21May2001: Called from epr.Chart.csp
ClassMethod LabOrdTestItemSet(ID As %Library.String, EpisodeID As %Library.String)
{
}

ClassMethod PatResultsForGraphClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = PatResultsForGraphFetch ]
{
}

ClassMethod PatResultsForGraphExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, TestCode As %Library.String, DateFrom As %Library.Date, DateTo As %Library.Date, TimeFrom As %Library.Time, TimeTo As %Library.Time) As %Library.Status
{
}

ClassMethod PatResultsForGraphFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = PatResultsForGraphExecute ]
{
}

ClassMethod ResultsForGraphExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, TestCode As %Library.String, DateFrom As %Library.Date, DateTo As %Library.Date, TimeFrom As %Library.Time, TimeTo As %Library.Time) As %Library.Status
{
}

ClassMethod ResultsForGraphFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ResultsForGraphExecute ]
{
}

ClassMethod ResultsForGraphClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ResultsForGraphFetch ]
{
}

ClassMethod ResultItemListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ResultItemListFetch ]
{
}

ClassMethod ResultItemListExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
}

ClassMethod ResultItemListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ResultItemListExecute ]
{
}

/// KM: 21May2001: Called from epr.Chart.csp
/// Log 30556 - AI - 18-12-2002 : Added hospital list, and four new checkboxes to the Input List (Signature).
/// Log 41352 - AI - 16-02-2004 : Add the new subcategories data. Only passed in IDs List.
ClassMethod TabularResultsGet(PatientID As %Library.String, EpisodeID As %Library.String, mradm As %Library.String, catgsID As %Library.String, dateto As %Library.Date = "", datefrom As %Library.Date = "", EpisodesAll As %Library.String = "", markasread As %Library.String, userid As %Library.String, ByRef dtmLIST As %Library.String, hospsID As %Library.String = "", OnlyUnverifiedResults As %Library.String = "", TagResultsOnly As %Library.String = "", OnlyUnreadResults As %Library.String = "", OrderSubcategories As %Library.String = "", Context As %Library.String = "", noCats As %Library.String = "N", ResultStatusList As %Library.String = "")
{
}

/// KM: 21May2001: Called from epr.Chart.csp
ClassMethod TabularResultsShow(ByRef dtmLIST As %Library.String, heading As %Library.String = "", ChartID As %Library.String = "", ItemID As %Library.String, Type As %Library.String, Context As %Library.String = "", ShowVIcon As %Library.String = "", HideTimeInLink As %Library.String = "", Columns As %Library.String = "", Start As %Library.String = 1, IncludeRPrefix As %Library.String = "", columnwidth As %Library.String = "", PageNumber As %Library.String = "", ResultStatusList As %Library.String = "")
{
}

ClassMethod websysSaveAll(id As %Library.String)
{
}

ClassMethod FindForGraphClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindForGraphFetch ]
{
}

ClassMethod FindForGraphExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, OEItemID As %Library.String, DateFrom As %Library.Date, DateTo As %Library.Date, TimeFrom As %Library.Time, TimeTo As %Library.Time) As %Library.Status
{
}

ClassMethod FindForGraphFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindForGraphExecute ]
{
}

ClassMethod LookupLabRefBroker(itmjs As %String = "", itmjsex As %String = "", type As %String = "", desc As %String = "") As %Boolean
{
}

Query FindForGraph(PatientID As %Library.String, OEItemID As %Library.String, DateFrom As %Date, DateTo As %Date, TimeFrom As %Time, TimeTo As %Time) As %Library.Query(CONTAINID = 1, ROWSPEC = "Date:%Date,Time:%Time,DoseQty:%String")
{
}

Query GetLabItemCount(Code As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "LGPHLabItemCount:%Library.Integer")
{
SELECT LGPHLabItemCount
FROM epr.LabGraphTestSets
WHERE (LGPHCode = :Code) OR (LGPHDesc = :Code)
}

/// SA: Implemented for Chart FX test
/// Used by component epr.LabGraphTestSets.Edit to fill field "LabItemsList"
/// and by epr.EMRGraph.asp to retrieve the codes required to fill the graph data
/// Functionality -  to get the saved items for the table 
/// property LGPHLabItemList list
Query GetTestSetItems(ID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "Code:%String,Description:%String")
{
}

/// Log 30600 - AI - 14-05-2003 : Created query to look up all Standard Type Items
/// within the "LabCumProfileRefRange" Standard Type.
/// Query very similar to websys.StandardTypeItem.LookUpByTypeButRestrict, but
/// we do not want to restrict the codelist, as further Items may be added in the future.
/// No other queries returned Description in the first column AND checked that
/// Description %STARTSWITH :desc.
/// 
/// Log 56608 YC - This is now the same as websys.StandardTypeItem.LookUpByType - use that instead
/// 
/// Query LookUpLabCum(type As %String, desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
/// {
/// SELECT Description, Code, StoredValue
/// FROM websys.StandardTypeItem
/// WHERE (ParRef=:type) 
/// AND (Description %STARTSWITH :desc)
/// }
/// old - should no longer be used...
Query PatResultsForGraph(PatientID As %String, TestCode As %String, DateFrom As %String, DateTo As %String, TimeFrom As %String, TimeTo As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "CollDate:%String,CollTime:%String,ResultValue:%String,Units:%String,abnormal:%String,ID:%String,EpisodeID:%String,referencerange:%String,OrderID:%String,RecDate:%String,RecTime:%String,Date,Time,Prefix,ResStatus,Sensitive:%String,Comments:%String,OtherFlags:%String")
{
}

Query ResultsForGraph(PatientID As %String, TestCode As %String, DateFrom As %String, DateTo As %String, TimeFrom As %String, TimeTo As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ResultValue,Date,Time")
{
}

/// SA: Implemented for Chart FX test
/// Used to get a list of valid lab results from which the user chooses to associate
/// with a graphable test set.
Query ResultItemList(desc As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "Code:%String,Description:%String")
{
}

Storage Default
{
<Data name="LabGraphTestSetsClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="LabGraphTestSetsDefaultData">
<Value name="1">
<Value>LGPHCode</Value>
</Value>
<Value name="2">
<Value>LGPHDesc</Value>
</Value>
<Value name="3">
<Value>LGPHLabItemCount</Value>
</Value>
<Value name="4">
<Value>LGPHLabItemList</Value>
</Value>
</Data>
<DataLocation>^epr.LabGraphTestSetsD</DataLocation>
<DefaultData>LabGraphTestSetsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.LabGraphTestSetsD</IdLocation>
<IndexLocation>^epr.LabGraphTestSetsI</IndexLocation>
<StreamLocation>^epr.LabGraphTestSetsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
