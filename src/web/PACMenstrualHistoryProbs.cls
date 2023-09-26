Include webimport

Class web.PACMenstrualHistoryProbs Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "MENHP_Code";

Parameter SQLDATEFROM = "MENHP_DateFrom";

Parameter SQLDATETO = "MENHP_DateTo";

Parameter SQLDESCRIPTION = "MENHP_Desc";

Parameter SQLROWID = "MENHP_RowId";

Property dummy As %String(TRUNCATE = 1);

}
