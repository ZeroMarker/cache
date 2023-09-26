Class web.MRFollowUpReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// rqg,Log24386: Method to get all follow up reasons passing mradmid
ClassMethod GetFollowUpReasonDetails(mradm As %Library.String)
{
}

Parameter SQLCODE = "FUR_RowId";

Parameter SQLDESCRIPTION = "FUR_RowId";

Parameter SQLROWID = "FUR_RowId";

/// rqg,Log24386
Query Find(mradm As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String")
{
SELECT FUR_RowId 
FROM SQLUser.MR_FollowUpReason
WHERE (FUR_ParRef = :mradm)
}

}
