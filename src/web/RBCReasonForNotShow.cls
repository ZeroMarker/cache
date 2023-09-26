Class web.RBCReasonForNotShow Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "RNS_Code";

Parameter SQLDATEFROM = "RNS_DateFrom";

Parameter SQLDATETO = "RNS_DateTo";

Parameter SQLDESCRIPTION = "RNS_Desc";

Parameter SQLROWID = "RNS_RowId";

}
