Class web.PACHRGCodes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "HRG_Code";

Parameter SQLDATEFROM = "HRG_DateFrom";

Parameter SQLDATETO = "HRG_DateTo";

Parameter SQLDESCRIPTION = "HRG_Desc";

Parameter SQLROWID = "HRG_RowId";

Query LookUpByName(HRGCode As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HRGCode,HRGDesc")
{
SELECT HRG_Code, HRG_Desc
 FROM	SQLUser.PAC_HRGCodes
 ORDER BY	HRG_Code
}

}
