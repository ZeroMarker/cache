Include webimport

IncludeGenerator webimport

Class web.RBCTransferApptReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 65;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "APTRAN_Code";

Parameter SQLDATEFROM = "APTRAN_DateFrom";

Parameter SQLDATETO = "APTRAN_DateTo";

Parameter SQLDESCRIPTION = "APTRAN_Desc";

Parameter SQLROWID = "APTRAN_RowId";

}
