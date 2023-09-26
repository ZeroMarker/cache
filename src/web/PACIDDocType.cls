Class web.PACIDDocType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

Parameter SQLCODE = "IDDT_Code";

Parameter SQLDATEFROM = "IDDT_DateFrom";

Parameter SQLDATETO = "IDDT_DateTo";

Parameter SQLDESCRIPTION = "IDDT_Desc";

Parameter SQLROWID = "IDDT_RowId";

Query Find(Desc As %String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "IDDT_RowId,IDDT_Desc,IDDT_Code,IDDT_DateFrom,IDDT_DateTo")
{
SELECT  IDDT_RowId,IDDT_Desc,IDDT_Code,IDDT_DateFrom,IDDT_DateTo
FROM 	SQLUser.PAC_IDDocType
WHERE	((%ALPHAUP IDDT_Desc %STARTSWITH %ALPHAUP :Desc)
		OR (%ALPHAUP IDDT_Code %STARTSWITH %ALPHAUP :Desc) OR (:Desc IS NULL))
}

ClassMethod websysBeforeSave(compref As %String, id As %String) As %Library.Boolean
{
}

}
