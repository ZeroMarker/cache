Class web.SSUserDefWinContResp Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 64;

Parameter SQLCODE = "RESP_Code";

Parameter SQLDATEFROM = "RESP_DateFrom";

Parameter SQLDATETO = "RESP_DateTo";

Parameter SQLDESCRIPTION = "RESP_Desc";

Parameter SQLROWID = "RESP_RowId";

ClassMethod GetCodeFromDescription(control As %String = "", desc As %String = "") As %String
{
}

ClassMethod GetDescriptionFromCode(control As %String = "", code As %String = "") As %String
{
}

/// ; ab 4.05.06 52166
ClassMethod AddResponse(compref As %String, PARREF As %String = "")
{
}

ClassMethod websysSave(compref As %String, PARREF As %String)
{
}

}
