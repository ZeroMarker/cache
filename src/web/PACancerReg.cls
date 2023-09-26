Class web.PACancerReg Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 226;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PACR_RowId";

Parameter SQLDESCRIPTION = "PACR_RowId";

Parameter SQLROWID = "PACR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindCancerRegByPatientClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCancerRegByPatientFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCancerRegByPatientExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCancerRegByPatientFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCancerRegByPatientExecute ]
{
}

ClassMethod GeHospitalFromEpisodeID(EpisodeID As %Library.String)
{
}

/// RQG 20.05.03 L32781: To return the discharge year for the linked admission. This is called from 
/// PAAdmCoding->CancerDischYear
/// MD 29.06.2005 Log 53576 skip if PACR_Active="N"
ClassMethod GetEpisodeDischargeYear(PatientID As %Library.String = "") As %Library.String
{
}

/// RQG 17.04.03 L32768: This method determines if update is required on Cancer Registration detail. This is based on the following criteria:
/// 1. If any episode for the patient is assigned a diagnosis code that is flagged as requiring cancer rego and no cancer rego details are recorded for the patient
/// 2. If any episode for the patient is assigned a diagnosis code that is flagged as requring cancer rego and
///     the patient is cancer registered but the cancer rego is not linked to the users hospital
/// 3. If the patient has an exstng. cancer rego and the cancer rego is linked to the users hosp. but the 
///     discharge year for the linked admission is less than the discharge year for the episode just coded
/// 4. If the patient has an exstng. cancer rego. and the discharge code for the episode just coded
///     indicates the patient died in hosp. and the cause of death and autopsy fields on the cancer rego. screen are incomplete.
/// 
/// cjb 02/06/2004 - moved here from PAAdmCoding
ClassMethod IsCancerRegRequired() As %Library.Boolean
{
}

/// cjb 03/06/2004 43316
ClassMethod IsCancerRegRequiredOLD() As %Library.Boolean
{
}

ClassMethod IsPatientCancerRegistered(PatientID As %Library.String)
{
}

ClassMethod PatientHasActiveCancer(PatientID As %Library.String)
{
}

ClassMethod websysBeforeDeleteCancer(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysBeforeSaveCancer(compref As %Library.String, id As %Library.String)
{
}

/// CJB 03/09/2002
/// delete the PATumor rows associated with this Cancer Reg as well as the Cancer Reg
ClassMethod websysDeleteCancer(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysSaveCancer(compref As %Library.String, id As %Library.String, patientid As %Library.String)
{
}

Query FindCancerRegByPatient(TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "causeofdeath,autopsyheld,rowid,patientid,regnumber,regdate,description,extractdate,extractneeded,parentcode,parentdesc,parentid,primcode,primdesc")
{
}

}
