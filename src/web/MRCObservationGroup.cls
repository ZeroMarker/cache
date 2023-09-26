Include webimport

IncludeGenerator webimport

Class web.MRCObservationGroup Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 175;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "GRP_Code";

Parameter SQLDESCRIPTION = "GRP_Desc";

Parameter SQLROWID = "GRP_RowId";

Property dummy As %String(TRUNCATE = 1);

/// KM 19-Feb-2001: This is used by the epr.chart.csp page to return a delimied string of all items in an observation group.
ClassMethod getItemsForGroup(ObsGrpID As %Library.String) As %Library.String
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,GRPCode:%String,GRPDesc:%String,GRPTableIVDrugs:%String,GRPMarkSize:%String,GRPYAxis1Interval:%Float,GRPYAxis1Max:%Float,GRPYAxis1Min:%Float,GRPYAxis2Interval,GRPYAxis2Max:%Float,GRPYAxis2Min")
{
SELECT GRP_Rowid, GRP_Code, GRP_Desc,GRP_TableIVDrugs,GRP_MarkSize,GRP_YAxis1Interval,GRP_YAxis1Max,GRP_YAxis1Min,GRP_YAxis2Interval,GRP_YAxis2Max,GRP_YAxis2Min
FROM MRC_ObservationGroup
WHERE GRP_Rowid = :ID
ORDER BY GRP_Rowid
}

/// *****
/// NOTE: This query returns Code and Desc around the wrong way. Don't change it though, as it is used in methods, csps, etc ...
/// *****
Query Find(Code As %String, Desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,GRPCode:%String,GRPDesc:%String")
{
SELECT GRP_Rowid,GRP_Desc,GRP_Code	
FROM MRC_ObservationGroup
WHERE  (GRP_Desc %STARTSWITH :Desc) and(GRP_Code %STARTSWITH :Code)
ORDER BY GRP_Code
}

}
