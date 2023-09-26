Class web.PACNeonatalMorbidity Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "NEOMORB_Code";

Parameter SQLDATEFROM = "NEOMORB_DateFrom";

Parameter SQLDATETO = "NEOMORB_DateTo";

Parameter SQLDESCRIPTION = "NEOMORB_Desc";

Parameter SQLROWID = "NEOMORB_RowId";

}
