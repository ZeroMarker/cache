Class web.ARCPayAgreemBGLimits Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "LIM_RowId";

Parameter SQLDESCRIPTION = "LIM_RowId";

Parameter SQLROWID = "LIM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetPayAgreem(instype, date, auxins)
{
}

}
