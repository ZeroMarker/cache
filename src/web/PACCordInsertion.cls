Class web.PACCordInsertion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PLCINSRT_Code";

Parameter SQLDATEFROM = "PLCINSRT_DateFrom";

Parameter SQLDATETO = "PLCINSRT_DateTo";

Parameter SQLDESCRIPTION = "PLCINSRT_Desc";

Parameter SQLROWID = "PLCINSRT_RowId";

}
