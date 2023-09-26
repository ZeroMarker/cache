Include webimport

IncludeGenerator webimport

Class web.RBCReasonForCancel Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 65;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "RFC_Code";

Parameter SQLDATEFROM = "RFC_DateFrom";

Parameter SQLDATETO = "RFC_DateTo";

Parameter SQLDESCRIPTION = "RFC_Desc";

Parameter SQLROWID = "RFC_RowId";

}
