Class web.OEOrdDoctor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod PatientDeceased(PatientID As %Library.String = "") As %Library.String
{
}

Parameter SQLCODE = "DOC_RowId";

Parameter SQLDESCRIPTION = "DOC_RowId";

Parameter SQLROWID = "DOC_RowId";

}
