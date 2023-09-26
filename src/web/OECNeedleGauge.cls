Class web.OECNeedleGauge Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLCODE = "NEDG_Code";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "NEDG_Desc";

Parameter SQLROWID = "NEDG_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpNeedleGauge(desc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "NEDGDesc:%String")
{
SELECT NEDG_Desc
FROM SQLUser.OEC_NeedleGauge
WHERE NEDG_Desc  %STARTSWITH  :desc
ORDER BY NEDG_Desc
}

}
