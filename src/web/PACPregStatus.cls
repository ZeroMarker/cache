Class web.PACPregStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetDescriptionFromCode(code As %Library.String = "") As %Library.String
{
}

ClassMethod GetDescriptionFromRowId(RowId As %Library.String = "") As %Library.String
{
}

Parameter SQLCODE = "PREGST_Code";

Parameter SQLDATEFROM = "PREGST_DateFrom";

Parameter SQLDATETO = "PREGST_DateTo";

Parameter SQLDESCRIPTION = "PREGST_Desc";

Parameter SQLROWID = "PREGST_RowId";

}
