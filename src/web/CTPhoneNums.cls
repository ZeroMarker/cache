Class web.CTPhoneNums Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PHNUM_Code";

Parameter SQLDESCRIPTION = "PHNUM_Desc";

Parameter SQLROWID = "PHNUM_RowId";

}
