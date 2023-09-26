Class web.RBResEffDateSessionCP Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CP_RowId";

Parameter SQLDESCRIPTION = "CP_RowId";

Parameter SQLROWID = "CP_RowId";

Property Dummy As %String(TRUNCATE = 1);

/// Finds if a care provider has been assigned to a session. Used in operating theathres 
/// 
/// Returns "Y" for yes, "N" for no and "B" if no CPs have been assigned to the session
ClassMethod IsCPInSession(SessionID As %String = "", cpID As %String = "") As %String
{
}

ClassMethod FindCPForResDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCPForResDateExecute ]
{
}

ClassMethod FindCPForResDateExecute(ByRef qHandle As %Binary, RescID As %String = "", Date As %Date = {+$h}) As %Status
{
}

ClassMethod FindCPForResDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCPForResDateExecute ]
{
}

Query FindCPForResDate(RescID As %String = "", Date As %Date = {+$h}) As %Query(ROWSPEC = "SessDesc:%String,SessType:%String,StartTime:%Time,EndTime:%Time,CareProvider:%String,SessionID:%String")
{
}

ClassMethod FindCPBySessIdBroker(itmjs As %String = "", itmjsex As %String = "", desc As %String = "", date As %Date = {+$h}, sessId As %String = "", allcp As %String = "false", flag As %String = "") As %Library.Boolean
{
}

/// Log 51123 - This is used by RBApptScheduleCP.Edit.
/// If 'All care providers' is true then all the care providers are returned.
/// Else only the care providers allocated to the RBResEffDateSession
/// are returned.
ClassMethod FindCPBySessIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCPBySessIdExecute ]
{
}

ClassMethod FindCPBySessIdExecute(ByRef qHandle As %Binary, desc As %String = "", date As %Date = {+$h}, sessId As %String = "", allcp As %String = "false", flag As %String = "") As %Status
{
}

ClassMethod FindCPBySessIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCPBySessIdExecute ]
{
}

Query FindCPBySessId(desc As %String, date As %Date, sessId As %String = "", allcp As %String, flag As %String) As %Query(ROWSPEC = "CTPCPDesc:%String,HIDDEN:%String,CTPCPCode:%String,Surgeon:%String,Anaesthetist:%String")
{
}

}
