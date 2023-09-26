Class web.PACWaitingListStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 151;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WLS_Code";

Parameter SQLDESCRIPTION = "WLS_Desc";

Parameter SQLROWID = "WLS_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetCodeFromDescription(Desc As %Library.String) As %Library.String
{
}

/// rqg,Log24363: to return the status description if code is passed.
ClassMethod GetDescriptionFromCode(Code As %Library.String) As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpStatusListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", idflag As %Library.String = "", RestrictStatus As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookupStatusListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupStatusListFetch ]
{
}

ClassMethod LookupStatusListExecute(ByRef QHandle As %Library.Binary, val As %String, idflag As %Library.String = "", RestrictStatus As %Library.String = "") As %Library.Status
{
}

ClassMethod LookupStatusListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupStatusListExecute ]
{
}

Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT WLS_Desc,WLS_Code
FROM SQLUser.PAC_WaitingListStatus
WHERE ((WLS_Code %STARTSWITH :desc) OR (WLS_Desc [:desc))
}

Query LookUpStatus(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String")
{
SELECT WLS_Desc,WLS_Code
FROM SQLUser.PAC_WaitingListStatus
WHERE ((%UPPER WLS_Code [ %UPPER :desc) OR (%UPPER WLS_Desc [ %UPPER :desc))
}

/// KK 16/5/02 Log 24858 - to populate multiple waitinglist statuses listbox
Query LookUpStatusDesc() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Code,Description")
{
SELECT WLS_Code,WLS_Desc
FROM SQLUser.PAC_WaitingListStatus
}

Query LookupStatusList(val As %String, idflag As %String, RestrictStatus As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

Query RemoveOrInital() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "status,code")
{
SELECT WLS_Desc,WLS_Code
FROM SQLUser.PAC_WaitingListStatus
WHERE (WLS_Code = 'R') OR (WLS_Code = 'I')
}

ClassMethod LookUpActiveBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

}
