Include webimport

IncludeGenerator webimport

Class web.MRCPresIllKeywords Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 105;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpByCareProvBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %Library.String = "", CareProvDR As %Library.String = "")
{
}

Parameter SQLCODE = "DKEYW_Code";

Parameter SQLDESCRIPTION = "DKEYW_Desc";

Parameter SQLROWID = "DKEYW_RowId";

Query LookUpByCareProv(Desc As %String, CareProvDR As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PRESIDesc:%String,PRESICode:%String,HIDDEN:%String")
{
SELECT DKEYW_Desc,DKEYW_Code,DKEYW_RowId
FROM MRC_PresIllKeywords
WHERE (DKEYW_Desc %STARTSWITH :Desc)
AND ((DKEYW_Doct_DR = :CareProvDR) OR (DKEYW_Doct_DR IS NULL))
ORDER BY	DKEYW_Desc
}

}
