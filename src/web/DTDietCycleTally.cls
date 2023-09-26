Class web.DTDietCycleTally Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TALLY_RowId";

Parameter SQLDESCRIPTION = "TALLY_RowId";

Parameter SQLROWID = "TALLY_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysSaveTallys(IDs As %Library.String, Tallys As %Library.String, CycleIDs As %Library.String, HospitalDR As %Library.String = "")
{
}

}
