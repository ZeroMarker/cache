Class web.CTCarPrvTp Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 112;

Parameter SQLDATEFROM = "CTCPT_DateFrom";

Parameter SQLDATETO = "CTCPT_DateTo";

Parameter SQLCODE = "CTCPT_Code";

Parameter SQLDESCRIPTION = "CTCPT_Desc";

Parameter SQLROWID = "CTCPT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithType(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

/// returns internal type
Query LookUpWithType(val As %String, date As %Library.String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,hidden,Code:%String,IntType:%String")
{
SELECT CTCPT_Desc, CTCPT_RowID, CTCPT_Code, CTCPT_InternalType
FROM SQLUser.CT_CarPrvTp
WHERE ((CTCPT_Desc %STARTSWITH :val) OR (CTCPT_Code =:val))
 AND ((:date IS NULL) OR ((CTCPT_DateFrom IS NULL OR CTCPT_DateFrom <= :date) AND (CTCPT_DateTo IS NULL OR CTCPT_DateTo >= :date)))
ORDER BY CTCPT_Desc
}

}
