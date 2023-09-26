/// For Order Entry Diet Orders
Class web.DTCVolume Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "VOL_Code";

Parameter SQLDESCRIPTION = "VOL_Desc";

Parameter SQLROWID = "VOL_RowId";

Query LookUpVolume(desc As %Library.String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "VOLDesc:%String")
{
SELECT VOL_Desc
FROM SQLUser.DTC_Volume
WHERE VOL_Desc  %STARTSWITH  :desc
ORDER BY VOL_Desc
}

}
