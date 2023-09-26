Class web.PACSuspectCancerType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "CANC_Code";

Parameter SQLDESCRIPTION = "CANC_Desc";

Parameter SQLROWID = "CANC_RowId";

}
