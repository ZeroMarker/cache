Class web.OETextResultHistSection Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 81;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetTextResultHist(ID As %Library.String = "") As %Library.String
{
}

Parameter SQLCODE = "HS_RowId";

Parameter SQLDESCRIPTION = "HS_RowId";

Parameter SQLROWID = "HS_RowId";

Query Find(ParRef As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Text:%Library.String,Section:%Library.String")
{
SELECT HS_RowId,HS_Text,HS_TexResSection_DR->SEC_Desc
FROM SQLUser.OE_TextResultHistSection
WHERE HS_ParRef=:ParRef
}

}
