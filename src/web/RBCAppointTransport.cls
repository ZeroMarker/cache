Include webimport

IncludeGenerator webimport

Class web.RBCAppointTransport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 116;

Parameter SQLDATEFROM = "APTR_DateFrom";

Parameter SQLDATETO = "APTR_DateTo";

Parameter SQLCODE = "APTR_Code";

Parameter SQLDESCRIPTION = "APTR_Desc";

Parameter SQLROWID = "APTR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerTransLoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", Transport As %Library.String, Location As %Library.String)
{
}

ClassMethod LookUpTransLocClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpTransLocFetch ]
{
}

ClassMethod LookUpTransLocExecute(ByRef QHandle As %Library.Binary, Transport As %Library.String, Location As %Library.String) As %Library.Status
{
}

ClassMethod LookUpTransLocFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpTransLocExecute ]
{
}

ClassMethod checkDates(appDate As %Library.String, transport As %Library.String) As %Library.String
{
}

Query LookUpTransLoc(Transport, Location) As %Library.Query(CONTAINID = 0, ROWSPEC = "code,desc")
{
SELECT TRANSP_Transport_DR->APTR_Desc,TRANSP_Transport_DR->APTR_Code
INTO :code, :desc
FROM SQLUser.CT_LocTransport
WHERE ((:Location IS NULL) OR  (%ALPHAUP TRANSP_ParRef->CTLOC_Desc=%ALPHAUP :Location))
AND ((%ALPHAUP TRANSP_Transport_DR->APTR_Desc %STARTSWITH %ALPHAUP :Transport) AND (TRANSP_Transport_DR->APTR_Desc IS NOT NULL)
OR (%ALPHAUP TRANSP_Transport_DR->APTR_Code %STARTSWITH %ALPHAUP :Transport) AND (TRANSP_Transport_DR->APTR_Code IS NOT NULL))
}

/// Used in pawaitinglistadm.edit
Query TransLookUp(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT APTR_Desc,APTR_RowId,APTR_Code
FROM RBC_AppointTransport
WHERE (%UPPER APTR_Desc %STARTSWITH %UPPER :desc) OR 
 (%UPPER APTR_Code %STARTSWITH %UPPER :desc)
}

}
