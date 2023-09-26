Class web.PACSourceOfAttendance Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 152;

Parameter SQLCODE = "ATTEND_Code";

Parameter SQLDATEFROM = "ATTEND_DateFrom";

Parameter SQLDESCRIPTION = "ATTEND_Desc";

Parameter SQLDATETO = "ATTEND_DateTo";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ATTEND_DateFrom <= CURRENT_DATE OR ATTEND_DateFrom IS NULL) AND (ATTEND_DateTo >= CURRENT_DATE OR ATTEND_DateTo IS NULL))";

Parameter SQLROWID = "ATTEND_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpEpisodeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", admType As %Library.String = "", OrganProcurement As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpWithEpisodeTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithEpisodeTypeFetch ]
{
}

ClassMethod LookUpWithEpisodeTypeExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, admType As %Library.String, OrganProcurement As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpWithEpisodeTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithEpisodeTypeExecute ]
{
}

Query LookUpWithEpisodeType(desc As %String, admType As %String, OrganProcurement As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String,code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT ATTEND_Desc,ATTEND_Code,ATTEND_EpisodeType
FROM SQLUser.PAC_SourceOfAttendance
WHERE    (((ATTEND_Desc %STARTSWITH :desc) OR (ATTEND_Code %STARTSWITH :desc) OR (:desc IS NULL))
AND    (ATTEND_DateFrom <= CURRENT_DATE OR ATTEND_DateFrom IS NULL) 
AND    (ATTEND_DateTo >= CURRENT_DATE OR ATTEND_DateTo IS NULL)
AND    ((ATTEND_EpisodeType =:admType OR ATTEND_EpisodeType IS NULL) OR (:admType IS NULL)))
}

ClassMethod LookUpEpisodeBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", admType As %Library.String = "", OrganProcurement As %Library.String = "") As %Library.Boolean
{
}

Query LookUpWithEpisodeTypeNC(desc As %String, admType As %String, OrganProcurement As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String,code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod LookUpWithEpisodeTypeNCClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithEpisodeTypeNCFetch ]
{
}

ClassMethod LookUpWithEpisodeTypeNCExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, admType As %Library.String, OrganProcurement As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpWithEpisodeTypeNCFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithEpisodeTypeNCExecute ]
{
}

}
