Class web.RBResEffDateSessionVar Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 148;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Library.Boolean
{
}

Parameter SQLCODE = "VAR_RowId";

Parameter SQLDESCRIPTION = "VAR_RowId";

Parameter SQLROWID = "VAR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetLatestSessionVar(SessionID As %Library.String, SessDate As %Library.Date) As %Library.String
{
}

ClassMethod LookUpBrokerCodeDesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", Variance As %String)
{
}

ClassMethod websysSaveVariance(compref As %String, id As %String)
{
}

Query FindByID(varID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "varCode")
{
SELECT VAR_ReasonForVariance_DR
INTO :varCode
FROM SQLUser.RB_ResEffDateSessionVar
WHERE VAR_RowId=:varID
}

Query LookUpCodeDesc(Variance As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ReaCode:%String,ReaDesc:%String")
{
SELECT REAVAR_Code, REAVAR_Desc
INTO :ReaCode, :ReaDesc
FROM SQLUser.RBC_ReasonForVariance
WHERE (REAVAR_Desc %STARTSWITH :Variance) AND (REAVAR_Desc IS NOT NULL)
}

}
