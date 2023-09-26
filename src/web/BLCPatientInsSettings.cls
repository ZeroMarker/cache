Class web.BLCPatientInsSettings Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 15;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INS_RowId";

Parameter SQLDESCRIPTION = "INS_RowId";

Parameter SQLROWID = "INS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
