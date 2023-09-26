Class web.PACReferralStatusReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "REA_RowId";

Parameter SQLDESCRIPTION = "REA_RowId";

Parameter SQLROWID = "REA_RowId";

ClassMethod FindRefStatusReasonBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", refstat As %String = "") As %Boolean
{
}

Query FindRefStatusReason(desc As %String, refstat As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "REFSTREADesc,HIDDEN,REFSTREACode,HIDDEN")
{
SELECT REA_Reason_DR->REFSTREA_Desc,REA_Reason_DR->REFSTREA_RowId,REA_Reason_DR->REFSTREA_Code,REA_RowId  
FROM SQLUser.PAC_ReferralStatusReason
WHERE  REA_ParRef->RST_Desc= :refstat
AND ((REA_Reason_DR->REFSTREA_Desc %STARTSWITH :desc)
OR	 (REA_Reason_DR->REFSTREA_Code=:desc))
}

/// Log 54141 YC - GetReferral Status Reasons, where all are returned if refstat=NULL
/// Used in websys.ReportXRef.Edit and websys.ReportXRef.Find for "RefStatusReason"
ClassMethod GetAllRefStatusReasonBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", refstat As %String) As %Boolean
{
}

/// Log 54141 YC - GetReferral Status Reasons, where all are returned if refstat=NULL
/// Used in websys.ReportXRef.Edit and websys.ReportXRef.Find for "RefStatusReason"
Query GetAllRefStatusReason(desc As %String, refstat As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "REFSTREADesc,HIDDEN,REFSTREACode")
{
SELECT DISTINCT REA_Reason_DR->REFSTREA_Desc,REA_Reason_DR->REFSTREA_RowId,REA_Reason_DR->REFSTREA_Code
FROM SQLUser.PAC_ReferralStatusReason
WHERE  (REA_ParRef->RST_Desc= :refstat OR :refstat=NULL)
AND ((REA_Reason_DR->REFSTREA_Desc %STARTSWITH :desc)
OR	 (REA_Reason_DR->REFSTREA_Code=:desc))
}

}
