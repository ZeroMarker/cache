Include webimport

IncludeGenerator webimport

Class web.MRPresentIllnessKeyw Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 140;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "KEYW_RowId";

Parameter SQLDESCRIPTION = "KEYW_RowId";

Parameter SQLROWID = "KEYW_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod websysSaveKeyword(compref As %Library.String, id As %String)
{
}

Query Find(presiID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,DKEYWDesc:%String,KEYWMRCDKeywDR:%String")
{
SELECT KEYW_RowID, KEYW_MRCDKeyw_DR->DKEYW_Desc, KEYW_MRCDKeyw_DR
FROM MR_PresentIllnessKeyw
WHERE (KEYW_ParRef = :presiID)
}

Query FindKeyword(presiID As %String, keywID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID")
{
SELECT KEYW_RowID
FROM MR_PresentIllnessKeyw
WHERE (KEYW_ParRef = :presiID) AND (KEYW_MRCDKeyw_DR = :keywID)
}

}
