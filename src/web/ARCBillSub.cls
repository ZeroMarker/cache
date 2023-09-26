Class web.ARCBillSub Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ARCSG_Code";

Parameter SQLDESCRIPTION = "ARCSG_Desc";

Parameter SQLROWID = "ARCSG_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpWithBillGrp(BillGrp As %String = "", BillSubGrp As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,BGDesc:%String")
{
SELECT ARCSG_Desc, ARCSG_RowId, ARCSG_Code, ARCSG_ARCBG_ParRef->ARCBG_Desc
FROM SQLUser.ARC_BillSub
WHERE (ARCSG_ARCBG_ParRef->ARCBG_Desc  = :BillGrp OR :BillGrp IS NULL) AND (%ALPHAUP ARCSG_Desc %STARTSWITH %ALPHAUP :BillSubGrp OR :BillSubGrp IS NULL)
ORDER BY ARCSG_Desc
}

ClassMethod LookUpWithBillGrpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", BillGrp As %Library.String = "", BillSubGrp As %Library.String = "") As %Library.Boolean
{
}

}
