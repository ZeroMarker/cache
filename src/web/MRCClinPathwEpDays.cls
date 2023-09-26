Class web.MRCClinPathwEpDays Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 240;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DAYS_RowId";

Parameter SQLDESCRIPTION = "DAYS_Desc";

Parameter SQLROWID = "DAYS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetItemDesc(ItmID As %Library.String) As %Library.String
{
}

ClassMethod GetCPWPathwaysDR(Pathway As %Library.String) As %Library.String
{
}

ClassMethod LookUpServicesBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %Library.String) As %Library.Boolean
{
}

/// log 56894
ClassMethod SavePathwEpDays(DAYS As %Library.String = "", EPRowId As %Library.String = "", CTLOCDR As %Library.String = "", RBResourceDR As %Library.String = "", ServiceDR As %Library.String = "", DAYSRowId As %Library.String = "", ItemIDs As %Library.String = "", OSRowIds As %Library.String = "", EPIPEpisodeRequired As %Library.String = "")
{
}

/// log 56894
ClassMethod DeleteServiceOrder(DAYSRowId As %Library.String = "", OSRowId As %Library.String = "")
{
}

ClassMethod FindCycleDayListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCycleDayListFetch ]
{
}

ClassMethod FindCycleDayListExecute(ByRef QHandle As %Library.Binary, EPRowId As %Library.String = "", DayIDs As %Library.String = "") As %Library.Status
{
}

ClassMethod FindCycleDayListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCycleDayListExecute ]
{
}

ClassMethod FindCycleDayOSItemListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCycleDayOSItemListFetch ]
{
}

ClassMethod FindCycleDayOSItemListExecute(ByRef QHandle As %Library.Binary, ARCOSRowId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindCycleDayOSItemListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCycleDayOSItemListExecute ]
{
}

Query FindStepNotes(StepID As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "DAYSDesc:%String,DAYSDay:%String,DAYSNotes:%List")
{
SELECT DAYS_Desc, DAYS_Day, DAYS_Notes
FROM SQLUser.MRC_ClinPathwEpDays
WHERE (DAYS_RowId = :StepID)
}

Query FindSteps(Step As %String, Pathway As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "HIDDEN:%String,DAYSDesc:%String,HIDDEN:%String,EPEpisode:%String,HIDDEN:%String")
{
SELECT DAYS_RowId, DAYS_Desc, DAYS_ParRef, DAYS_ParRef->EP_Episode, DAYS_ParRef->EP_RowId
FROM SQLUser.MRC_ClinPathwEpDays
WHERE   (DAYS_Desc  %STARTSWITH:Step)
AND ((DAYS_ParRef IS NOT NULL) AND (DAYS_ParRef->EP_ParRef->CPW_Desc  %STARTSWITH :Pathway))
}

Query FindStepsByPWEpisodeID(PathwayEpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "PWEpsStepsID:%String,PWEpsStepsDesc:%String,PWEpsStepsDay,PWEpsStepsNotes:%List")
{
SELECT DAYS_RowId, DAYS_Desc, DAYS_Day, DAYS_Notes
FROM SQLUser.MRC_ClinPathwEpDays
WHERE (DAYS_ParRef = :PathwayEpisodeID)
ORDER BY DAYS_Day
}

Query FindStepsByProbID(ProbID As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "HIDDEN:%String,DAYSDesc:%String,HIDDEN:%String,EPEpisode:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT DAYS_RowId, DAYS_Desc, DAYS_ParRef, DAYS_ParRef->EP_Episode, DAYS_ParRef->EP_RowId, DAYS_ParRef->EP_Desc
FROM SQLUser.MRC_ClinPathwEpDays
WHERE   (DAYS_ParRef->EP_ParRef->CPW_RowId  = :ProbID)
}

Query LookUpServices(SerDesc As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "SERDesc:%Library.String,SERMinutes:%Library.String,HIDDEN:%Library.String")
{
SELECT DAYS_Service_DR->SER_Desc,DAYS_Service_DR->SER_Minutes,DAYS_Service_DR
FROM SQLUser.MRC_ClinPathwEpDays
where (DAYS_Service_DR->SER_Desc=:SerDesc)
OR (DAYS_Service_DR %STARTSWITH :SerDesc)
}

/// 56894
Query GetDaysRowId(DayNumber As %Library.String = "", DAYSParRef As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DAYSRowId:%Library.String")
{
SELECT DAYS_RowId
FROM SQLUser.MRC_ClinPathwEpDays
where (DAYS_DayNumber=:DayNumber)
AND (DAYS_ParRef=:DAYSParRef)
AND (DAYS_Service_DR IS NULL)
}

/// 56894
Query FindCycleDayList(EPRowId As %Library.String = "", DayIDs As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DAYSRowId,DayNumber,Service,Resource,Location,IPEpisodeRequired,OSRowId,OrderItem,ItemDR")
{
}

/// 56894
Query FindCycleDayOSItemList(ARCOSRowId As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OrderItem,ItmMastID")
{
}

}
