Class web.PACInterpreter Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Interpreter ]
{

Parameter BUILD = 117;

Parameter SQLDATEFROM = "INTERP_DateFrom";

Parameter SQLDATETO = "INTERP_DateTo";

Parameter SQLCODE = "INTERP_Code";

Parameter SQLDESCRIPTION = "INTERP_Desc";

Parameter SQLROWID = "INTERP_RowId";

ClassMethod LookUpBrokerInterpreterLoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", Interpreter As %Library.String, Location As %Library.String)
{
}

ClassMethod LookUpInterpreterClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpInterpreterFetch ]
{
}

ClassMethod LookUpInterpreterExecute(ByRef QHandle As %Library.Binary, Interpreter As %Library.String, Location As %Library.String) As %Library.Status
{
}

ClassMethod LookUpInterpreterFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpInterpreterExecute ]
{
}

ClassMethod checkDates(appDate As %Library.String, interpreter As %Library.String) As %Library.String
{
}

Query LookUpInterpreter(Interpreter, Location) As %Library.Query(CONTAINID = 0, ROWSPEC = "code,desc")
{
SELECT INTERP_Interpreter_DR->INTERP_Desc,INTERP_Interpreter_DR->INTERP_Code
INTO :code, :desc
FROM SQLUser.CT_LocInterpreter
WHERE ((:Location IS NULL) OR  (%ALPHAUP INTERP_ParRef->CTLOC_Desc=%ALPHAUP :Location))
AND ((%ALPHAUP INTERP_Interpreter_DR->INTERP_Desc %STARTSWITH %ALPHAUP :Interpreter) AND (INTERP_Interpreter_DR->INTERP_Desc IS NOT NULL)
OR (%ALPHAUP INTERP_Interpreter_DR->INTERP_Code %STARTSWITH %ALPHAUP :Interpreter) AND (INTERP_Interpreter_DR->INTERP_Code IS NOT NULL))
}

}
