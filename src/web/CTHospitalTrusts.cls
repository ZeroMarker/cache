Class web.CTHospitalTrusts Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 78;

Parameter SQLDATEFROM = "TRUST_DateFrom";

Parameter SQLDATETO = "TRUST_DateTo";

Parameter SQLCODE = "TRUST_Rowid";

Parameter SQLDESCRIPTION = "TRUST_Rowid";

Parameter SQLROWID = "TRUST_Rowid";

Property dummy As %Library.String(TRUNCATE = 1);

/// ab 14.10.03 - 39247 - returns the active trust for a hospital
ClassMethod GetCurrentTrust(hosp As %String = "") As %String
{
}

ClassMethod LookUpByTrustClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByTrustFetch ]
{
}

/// TP: Dec 2001: Called from component webcommon.DateFromTo.Custom
ClassMethod LookUpByTrustExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, trust As %Library.String) As %Library.Status
{
}

ClassMethod LookUpByTrustFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByTrustExecute ]
{
}

Query LookUpByTrust(desc As %String, trust As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

}
