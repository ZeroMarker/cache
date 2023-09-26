Class web.PACOpDelivIndication Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "OPDEL_Code";

Parameter SQLDATEFROM = "OPDEL_DateFrom";

Parameter SQLDATETO = "OPDEL_DateTo";

Parameter SQLDESCRIPTION = "OPDEL_Desc";

Parameter SQLROWID = "OPDEL_RowId";

}
