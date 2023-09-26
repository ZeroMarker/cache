Class web.MRPsychTreatmentForm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "TF_RowId";

Parameter SQLDATEFROM = "TF_DateFrom";

Parameter SQLDATETO = "TF_DateTo";

Parameter SQLDESCRIPTION = "TF_RowId";

Parameter SQLROWID = "TF_RowId";

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

Query FindTreatment(PARREF As %String = "", mradm As %String = "") As %Query(CONTAINID = 1, ROWSPEC = "ID,PARREF,TFDateFrom,TFDateTo,TFTimeFrom,TFConsent,TFConsentObtained,TFSecondOpinion,TFDesc")
{
}

ClassMethod FindTreatmentExecute(ByRef QHandle As %Library.Binary, PARREF As %String = "", mradm As %String = "") As %Library.Status
{
}

ClassMethod FindTreatmentFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindTreatmentExecute ]
{
}

ClassMethod FindTreatmentClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindTreatmentFetch ]
{
}

ClassMethod GetLatestDetails(PARREF As %String = "")
{
}

ClassMethod RecordHistory(compref As %String, PARREF As %String, TreatmentForm As %String = "", DateFrom As %String = "", TimeFrom As %String = "")
{
}

ClassMethod websysDelete(id As %Library.String)
{
}

/// ab 15.03.05 -update the psych details with the latest treatment form
ClassMethod UpdatePsychTF(PARREF As %String = "")
{
}

}
