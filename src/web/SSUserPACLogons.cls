Class web.SSUserPACLogons Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PAC_RowId";

Parameter SQLDESCRIPTION = "PAC_RowId";

Parameter SQLROWID = "PAC_RowId";

Query DisplayAll(PARREF As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PACPACSystem:%String,PACUserName:%String,PACPassword:%String,ID:%String")
{
SELECT  PAC_PACSystem,PAC_UserName,PAC_Password, PAC_RowId
FROM  SQLUser.SS_UserPACLogons
WHERE PAC_ParRef= :PARREF
ORDER BY PAC_UserName
}

ClassMethod ChangePassword(compref As %Library.String, PACSPwdID As %Library.String)
{
}

ClassMethod websysSave(compref As %Library.String, ID As %Library.String)
{
}

ClassMethod websysDelete(ID As %Library.String)
{
}

}
