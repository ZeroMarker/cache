Class web.PACWaitingListType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 219;

Parameter SQLDATEFROM = "WLT_DateFrom";

Parameter SQLDATETO = "WLT_DateTo";

Parameter SQLCODE = "WLT_Code";

Parameter SQLDESCRIPTION = "WLT_Desc";

Parameter SQLROWID = "WLT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpWLTBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", logon As %Library.String = "", recloc As %Library.String = "", locdesc As %Library.String = "", userFlag As %String = "", consultCatDesc As %String = "") As %Library.Boolean
{
}

ClassMethod TypeLookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = TypeLookUpFetch ]
{
}

/// KK 11/jun/2002 Log 25256  -  Iif recloc is blank set recloc to location rowid
ClassMethod TypeLookUpExecute(ByRef QHandle As %Library.Binary, desc As %String, logon As %String, recloc As %Library.String, locdesc As %Library.String, userFlag As %String = "", consultCatDesc As %String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
/// rqg,Log26808: Accomodate DateFrom and DateTo fields in the fetch and dont include the WLTDescr in the
/// fetch if todays date is not within the date range.
ClassMethod TypeLookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = TypeLookUpExecute ]
{
}

ClassMethod GetRecallPeriod(consultCatDesc As %Library.String, ListTypecode As %Library.String) As %Library.String
{
}

/// looks up not only the waiting list type but the Care Provider, Location and Hospital
Query LookUpWLTDetails(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "WLT_Desc:%Library.String,hidden,hidden,hidden")
{
SELECT WLT_Desc, WLT_CTLOC_DR->CTLOC_Desc,WLT_CareProv_DR->CTPCP_Desc, WLT_Hospital_DR->HOSP_Desc
FROM SQLUser.PAC_WaitingListType
WHERE (%UPPER WLT_Desc [ %UPPER :desc)
}

/// lookup site specific for RIE
/// done for log 21900 GR
Query TypeLookUp(desc As %Library.String, logon As %Library.String, recloc As %Library.String, locdesc As %String, userFlag As %String, consultCatDesc As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "WLT_Desc:%Library.String,WLT_Code:%Library.String,hidden,hidden,hidden,hidden,hidden,hidden,hidden")
{
}

}
