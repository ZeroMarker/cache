Class web.BLCCRAFTVersion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

/// RQG 16.05.03 L35273: Will return the CRAFT Version based on passed CRAFTCategory.
ClassMethod GetCRAFTVersion(CRAFTCategoryID As %Library.String = "") As %Library.String
{
}

ClassMethod GetCurrentVersion() As %Library.String
{
}

ClassMethod LookUpAllVersionBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "CRAFTV_Code";

Parameter SQLDATEFROM = "CRAFTV_DateFrom";

Parameter SQLDATETO = "CRAFTV_DateTo";

Parameter SQLDESCRIPTION = "CRAFTV_Desc";

Parameter SQLROWID = "CRAFTV_RowId";

Query LookUpAllVersion(val As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "desc,code,hidden")
{
SELECT CRAFTV_Desc,CRAFTV_Code,CRAFTV_RowId
FROM SQLUser.BLC_CRAFTVersion
WHERE ((%UPPER CRAFTV_Code %STARTSWITH %UPPER :val) OR (%UPPER CRAFTV_Desc %STARTSWITH %UPPER :val) OR (:val IS NULL))
ORDER BY CRAFTV_Code
}

}
