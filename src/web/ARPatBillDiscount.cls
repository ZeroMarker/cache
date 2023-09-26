Class web.ARPatBillDiscount Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 3;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DISC_RowId";

Parameter SQLDESCRIPTION = "DISC_RowId";

Parameter SQLROWID = "DISC_RowId";

ClassMethod websysSaveDiscount(BillRowIDs As %Library.String, DiscAmt As %Library.String, DiscType As %Library.String = "")
{
}

}
