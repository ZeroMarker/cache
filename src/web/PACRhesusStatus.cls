Class web.PACRhesusStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "RHSSTS_Code";

Parameter SQLDATEFROM = "RHSSTS_DateFrom";

Parameter SQLDATETO = "RHSSTS_DateTo";

Parameter SQLDESCRIPTION = "RHSSTS_Desc";

Parameter SQLROWID = "RHSSTS_RowId";

}
