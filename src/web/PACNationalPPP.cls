Class web.PACNationalPPP Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 98;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "NPPP_Code";

Parameter SQLDESCRIPTION = "NPPP_Desc";

Parameter SQLROWID = "NPPP_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
