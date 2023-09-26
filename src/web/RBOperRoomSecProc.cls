/// Secondary Operations and Procedures for operation bookings
Class web.RBOperRoomSecProc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod SaveProcsAndOps(OperRoomID As %String = "", procs As %String = "", ops As %String = "")
{
}

Parameter SQLCODE = "SPR_RowId";

Parameter SQLDESCRIPTION = "SPR_RowId";

Parameter SQLROWID = "SPR_RowId";

Property Dummy As %String(TRUNCATE = 1);

ClassMethod OperationsForBooking(OperRoomID As %String = "") As %Library.String
{
}

ClassMethod ProceduresForBooking(OperRoomID As %String = "") As %String
{
}

}
