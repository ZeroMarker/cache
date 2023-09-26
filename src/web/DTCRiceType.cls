/// For Order Entry Diet Orders
Class web.DTCRiceType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "RIC_Code";

Parameter SQLDESCRIPTION = "RIC_Desc";

Parameter SQLROWID = "RIC_RowId";

Query LookUpRiceType(desc As %Library.String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "RICDesc:%String")
{
SELECT RIC_Desc
FROM SQLUser.DTC_RiceType
WHERE RIC_Desc  %STARTSWITH  :desc
ORDER BY RIC_Desc
}

}
