Class web.PACFollowUpReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

Parameter SQLDATEFROM = "FOLREA_DateFrom";

Parameter SQLDATETO = "FOLREA_DateTo";

Parameter SQLCODE = "FOLREA_Code";

Parameter SQLDESCRIPTION = "FOLREA_Desc";

Parameter SQLROWID = "FOLREA_RowId";

ClassMethod LookUpReasonBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpReasonClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpReasonFetch ]
{
}

ClassMethod LookUpReasonExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpReasonFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpReasonExecute ]
{
}

Query FindAll() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "code,desc")
{
SELECT FOLREA_Code,FOLREA_Desc
FROM SQLUser.PAC_FollowUpReason
}

Query LookUpReason(Desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc,Code,Hidden")
{
}

}
