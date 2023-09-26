Class web.MRCDRGGrouperVersion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "DGV_Code";

Parameter SQLDATEFROM = "DGV_DateFrom";

Parameter SQLDATETO = "DGV_DateTo";

Parameter SQLDESCRIPTION = "DGV_Desc";

Parameter SQLROWID = "DGV_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
