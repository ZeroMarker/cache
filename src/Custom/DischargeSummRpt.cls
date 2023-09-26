Class Custom.DischargeSummRpt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetDischargeSummRpt(dischrowid As %Library.String = "") As %Library.String
{
}

ClassMethod GetPatientDetails(PatientId As %String)
{
}

ClassMethod GetRecipientList(dischrowid As %String)
{
}

ClassMethod GetDisSummFields(dischrowid As %String)
{
}

ClassMethod GetDISSUMData(DISSUMVar As %String, dischrow As %String) As %String
{
}

ClassMethod GetEpisodeDetails(EpisodeList As %String, DischargeDate As %Date)
{
}

ClassMethod GetAllergies(PatientId As %String)
{
}

ClassMethod GetAlerts(PatientId As %String)
{
}

ClassMethod GetChiefComplaints(MRAdmList As %String)
{
}

ClassMethod GetClinicalNotes(MRAdmList As %String)
{
}

ClassMethod GetDiagnosis(MRAdmList As %String)
{
}

ClassMethod GetMRProcedures(MRAdmList As %String)
{
}

ClassMethod GetAnaesthetics(PatientId As %String, EpisodeList As %String)
{
}

ClassMethod GetOperationProcedures(EpisodeList As %String)
{
}

ClassMethod GetCurrentIllness(MRAdmList As %String)
{
}

ClassMethod GetMedications(MRAdmList As %String)
{
}

ClassMethod GetOrders(EpisodeList As %String)
{
}

ClassMethod GetMedicationOrders(EpisodeList As %String)
{
}

ClassMethod GetResults(EpisodeList As %String)
{
}

ClassMethod GetResultType(OrderId As %String, ResultId As %String) As %String
{
}

ClassMethod GetLabResults(ord As %String, itm As %String, EpisodeID As %String = "")
{
}

ClassMethod GetTextResults(ord As %String, itm As %String, EpisodeID As %String = "")
{
}

ClassMethod GetTextResultText(ResultID As %String) As %String
{
}

ClassMethod GetOtherResults(ord As %String, itm As %String, EpisodeID As %String = "")
{
}

ClassMethod GetSurgicalHistory(PatientId As %String)
{
}

ClassMethod GetSocialHistory(PatientId As %String)
{
}

ClassMethod GetFamilyHistory(PatientId As %String)
{
}

}
