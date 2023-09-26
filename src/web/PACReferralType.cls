Include webimport

IncludeGenerator webimport

Class web.PACReferralType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 95;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "REFT_Code";

Parameter SQLDESCRIPTION = "REFT_Desc";

Parameter SQLROWID = "REFT_RowId";

ClassMethod LookUpBrokerNC(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	REFT_Desc,REFT_RowID,REFT_Code,REFT_NationalCode
FROM	 SQLUser.PAC_ReferralType
WHERE	(REFT_Desc %STARTSWITH :desc
OR      REFT_Code=:desc)
}

}
