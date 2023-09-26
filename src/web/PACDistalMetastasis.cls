Class web.PACDistalMetastasis Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "DISM_Code";

Parameter SQLDESCRIPTION = "DISM_Desc";

Parameter SQLROWID = "DISM_RowId";

}
