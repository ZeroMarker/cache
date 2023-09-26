Class web.ORAnOperSecProc Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 13;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SPR_RowId";

Parameter SQLDESCRIPTION = "SPR_RowId";

Parameter SQLROWID = "SPR_RowId";

Property Dummy As %String(TRUNCATE = 1);

ClassMethod SaveProcsAndOps(AnOpID As %String = "", procs As %String = "", ops As %String = "")
{
}

ClassMethod OperationsForBooking(AnOpID As %String = "", OperRoomID As %String = "") As %Library.String
{
}

ClassMethod ProceduresForBooking(AnOpID As %String = "", OperRoomID As %String = "") As %String
{
}

}
