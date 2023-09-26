Include webimport

IncludeGenerator webimport

Class web.ARCBillGrp Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ARCBG_Code";

Parameter SQLDESCRIPTION = "ARCBG_Desc";

Parameter SQLROWID = "ARCBG_RowId";

Property dummy As %String(TRUNCATE = 1);

/// wanghc add
Query LookUp(BGDesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT ARCBG_Desc , ARCBG_RowId, ARCBG_Code
FROM SQLUser.ARC_BillGrp
WHERE (:BGDesc is null) OR (ARCBG_Desc  %STARTSWITH %ALPHAUP :BGDesc)
}

}
