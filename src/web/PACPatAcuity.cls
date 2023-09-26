Class web.PACPatAcuity Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ACU_Code";

Parameter SQLDATEFROM = "ACU_DateFrom";

Parameter SQLDATETO = "ACU_DateTo";

Parameter SQLDESCRIPTION = "ACU_Desc";

Parameter SQLROWID = "ACU_RowId";

}
