Class web.PAPersonRoyalOrderExemp Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 17;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EXEMP_RowId";

Parameter SQLDESCRIPTION = "EXEMP_RowId";

Parameter SQLROWID = "EXEMP_RowId";

Property dummy As %String(TRUNCATE = 1);

Query FindRoyalExemp(PARREF As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCIMDesc,ARCBGDesc,ARCSGDesc")
{
SELECT EXEMP_RowId,EXEMP_ARCIM_DR->ARCIM_Desc,EXEMP_BillGrp_DR->ARCBG_Desc,EXEMP_BillSub_DR->ARCSG_Desc
FROM SQLUser.PA_PersonRoyalOrderExemp
WHERE EXEMP_ParRef->ROYAL_RowId = :PARREF
}

}
