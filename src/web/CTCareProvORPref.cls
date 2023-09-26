Class web.CTCareProvORPref Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 107;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ORP_RowId";

Parameter SQLDESCRIPTION = "ORP_RowId";

Parameter SQLROWID = "ORP_RowId";

ClassMethod DeleteAll(idstring As %String)
{
}

ClassMethod GetSurgPrefForCPOp(CPId As %String = "", OperID As %String = "") As %String
{
}

ClassMethod GetAnaPrefForCPOp(CPId As %String = "", OperID As %String = "") As %String
{
}

ClassMethod GetRecPrefForCPOp(CPId As %String = "", OperID As %String = "") As %String
{
}

ClassMethod websysSaveSurgPref(compref As %String, id As %String)
{
}

ClassMethod websysSaveAnaPref(compref As %String, id As %String)
{
}

ClassMethod websysSaveRecovPref(compref As %String, id As %String)
{
}

Query LookUpSurgicalPreferences(CareProvID As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefID:%String,OperID:%String,StPPPID:%String,FreeTxt:%String")
{
SELECT ORP_RowId,ORP_Operation_DR,ORP_StatePPP_DR,ORP_Text1
FROM SQLUser.CT_CareProvORPref
WHERE ORP_ParRef =:CareProvID
AND ((ORP_Operation_DR IS NOT NULL) OR (ORP_StatePPP_DR IS NOT NULL))
}

Query LookUpAnaestheticPreferences(CareProvID As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefID:%String,AnaMethod:%String")
{
SELECT ORP_RowId,ORP_AnaestMethod_DR
FROM SQLUser.CT_CareProvORPref
WHERE ORP_ParRef =:CareProvID
AND ORP_AnaestMethod_DR IS NOT NULL
}

Query LookUpRecoveryPreferences(CareProvID As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "OpPrefID:%String,RecOperID:%String,RecStPPPID:%String,RecFreeTxt:%String")
{
SELECT ORP_RowId,ORP_RecovOperation_DR,ORP_RecovStatePPP_DR,ORP_RecovText 
FROM SQLUser.CT_CareProvORPref
WHERE ORP_ParRef =:CareProvID
AND ((ORP_RecovOperation_DR IS NOT NULL) OR (ORP_RecovStatePPP_DR IS NOT NULL))
}

}
