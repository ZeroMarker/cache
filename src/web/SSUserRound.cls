Class web.SSUserRound Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RND_RowId";

Parameter SQLDESCRIPTION = "RND_RowId";

Parameter SQLROWID = "RND_RowId";

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpRoundClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRoundFetch ]
{
}

ClassMethod LookUpRoundExecute(ByRef QHandle As %Library.Binary, desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpRoundFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRoundExecute ]
{
}

ClassMethod LookUpUserRoundClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpUserRoundFetch ]
{
}

ClassMethod LookUpUserRoundExecute(ByRef QHandle As %Library.Binary, SSUserID As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpUserRoundFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpUserRoundExecute ]
{
}

ClassMethod websysSaveAll(SSUserID As %Library.String = "", LoginRounds As %Library.String = "")
{
}

Query Find(SSUserID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID, RNDCTCPDR,CTPCPDesc")
{
SELECT RND_RowId, RND_CTCP_DR, RND_CTCP_DR->CTPCP_Desc
FROM SQLUser.SS_UserRound
WHERE RND_ParRef = :SSUserID
}

/// SA: This query is used by the SSUserLogon screen. If the user has Care Providers 
/// assigned via SSUserRound, then the lookup is limited by these CP's. Otherwise, 
/// the user may select all care providers from the active list.
Query LookUpRound(desc As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "CTPCPDesc,HIDDEN,CTPCPCode")
{
}

/// SA: This query populates the "CareProvRoundEntered" list box in SSUser.Edit
Query LookUpUserRound(SSUserID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
