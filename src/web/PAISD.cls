/// Request ISD(S)1
Class web.PAISD Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod RequestISD(StartDate As %Library.String, EndDate As %Library.String, ISDS1CC1 As %Library.String, ISDS1CC2 As %Library.String, ISDS1CC3 As %Library.String, ISDS1CC4 As %Library.String, ISDS1CC5 As %Library.String, ISDS1CC6 As %Library.String, ISDS1CC7 As %Library.String, ISDS1CC8 As %Library.String)
{
}

Parameter SQLCODE = "ISD1_RowId";

Parameter SQLDESCRIPTION = "ISD1_RowId";

Parameter SQLROWID = "ISD1_RowId";

}
