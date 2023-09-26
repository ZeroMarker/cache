Include webimport

IncludeGenerator webimport

Class web.PACReferralStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "RST_Code";

Parameter SQLDATEFROM = "RST_DateFrom";

Parameter SQLDATETO = "RST_DateTo";

Parameter SQLDESCRIPTION = "RST_Desc";

Parameter SQLROWID = "RST_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetImage(id As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String)
{
}

/// Returns an associated icon in thereferal priority is "Urgent Cancer Wait" and Referral status is "Urgent Cancer"
ClassMethod ShowStatusIcon(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod LookUpRestrictedBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", dval As %Library.String = "", reststring As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetIDfromVisitStatus(visstat As %Library.String)
{
}

Query FindAllForList() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "hidden,desc")
{
SELECT RST_Code,RST_Desc
FROM SQLUser.PAC_ReferralStatus
}

Query LookUpResticted(dval As %String, reststring As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "desc,hidden,code,visitstat")
{
SELECT RST_Desc,RST_RowId,RST_Code,RST_VisitStatus
FROM SQLUser.PAC_ReferralStatus
WHERE ((RST_Desc %STARTSWITH :dval) OR (RST_Code %STARTSWITH :dval) OR (:dval IS NULL))
AND ((RST_DateFrom <= CURRENT_DATE OR RST_DateFrom IS NULL) AND (RST_DateTo >= CURRENT_DATE OR RST_DateTo IS NULL))
AND (({fn CONCAT( '^', {fn CONCAT((:reststring),'^')})} [ {fn CONCAT( '^', {fn CONCAT((RST_VisitStatus),'^')})}) OR (:reststring IS NULL))
ORDER BY RST_DESC
}

}
