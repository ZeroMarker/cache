Class web.PACWaitListReasonForChange Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 68;

Parameter SQLDATEFROM = "WLRC_DateFrom";

Parameter SQLDATETO = "WLRC_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "WLRC_Code";

Parameter SQLDESCRIPTION = "WLRC_Desc";

Parameter SQLROWID = "WLRC_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByReasonGroup(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", reasongroup As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpWLChangeReasonBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

ClassMethod LookUpWLChangeReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpWLChangeReasonExecute ]
{
}

ClassMethod LookUpWLChangeReasonExecute(ByRef qHandle As %Binary, val As %String) As %Status
{
}

ClassMethod LookUpWLChangeReasonFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWLChangeReasonExecute ]
{
}

Query LookUpByReasonGroup(val As %Library.String, reasongroup As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,code:%String,hidden")
{
SELECT WLRC_Desc,WLRC_Code,WLRC_WLStatus_DR->WLS_Groups_DR->WLG_Desc
FROM SQLUser.PAC_WaitListReasonForChange
WHERE ((WLRC_Desc %STARTSWITH :val) OR (WLRC_Code %STARTSWITH :val))
AND     ((WLRC_WLStatus_DR->WLS_Groups_DR->WLG_Desc= :reasongroup) OR (:reasongroup IS NULL))
}

Query LookUpWLChangeReason(val As %String) As %Query(ROWSPEC = "desc:%String,code:%String,hidden:%String")
{
}

}
