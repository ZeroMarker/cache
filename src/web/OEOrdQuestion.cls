Class web.OEOrdQuestion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 186;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "QA_RowId";

Parameter SQLDESCRIPTION = "QA_RowId";

Parameter SQLROWID = "QA_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetQuestionAnswer(OEORIROWID As %Library.String, ClinicalDetails As %Library.String = "") As %Library.String
{
}

ClassMethod websysSaveQuestionAnswer(ARCItmMastIDs As %Library.String, PatientID As %Library.String, ByRef NewOrdArray As %Library.String)
{
}

ClassMethod GetMultiQuestionAnswer(OEORIROWIDs As %Library.String, ClinicalDetails As %Library.String = "") As %Library.String
{
}

}
