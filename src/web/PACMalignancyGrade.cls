Class web.PACMalignancyGrade Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MALG_Code";

Parameter SQLDESCRIPTION = "MALG_Desc";

Parameter SQLROWID = "MALG_RowId";

}
