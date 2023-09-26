Class web.PASMRExtractErrors Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 100;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ERR_Code";

Parameter SQLDESCRIPTION = "ERR_RowId";

Parameter SQLROWID = "ERR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindErrorsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindErrorsFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindErrorsExecute(ByRef QHandle As %Library.Binary, RowId As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindErrorsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindErrorsExecute ]
{
}

ClassMethod GetErrorDescription(RowId As %Library.String, SMRErrorDesc As %Library.String, Parameters As %Library.String)
{
}

ClassMethod GetURNumber(Parameters As %Library.String)
{
}

ClassMethod GetEpisodeNumber(Parameters As %Library.String)
{
}

ClassMethod CheckForError(RowID As %String = "") As %String
{
}

Query FindErrors(RowId As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RowId,Error,Code,National,Id,Desc,ExtractBuild,AdmCoding,Appt,Patient,PatientID,Parameters,Hospital,PatID,EpisodeID,EpisodeNumber,RunLocation")
{
}

Query FindErrors1(RowId As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId,Error,Code,National,Id,Desc,ExtractBuild,AdmCoding,Appt,Patient,PatientID,Parameters,Hospital,PatID,EpisodeID,EpisodeNumber,RunLocation")
{
SELECT ERR_RowId,ERR_Error_DR->SMRERR_Code,ERR_Code,ERR_NationalCode,ERR_Id,ERR_Error_DR->SMRERR_Desc,
ERR_ExtractBuild_DR,ERR_ParRef->SMRE_PASMR_DR->SMR_AdmCoding_DR,ERR_ParRef->SMRE_PASMR_DR->SMR_Appointment_DR,
ERR_ParRef->SMRE_PASMR_DR->SMR_Appointment_DR->APPT_PAPMI_DR->PAPMI_No,ERR_ParRef->SMRE_PASMR_DR->SMR_Appointment_DR->APPT_PAPMI_DR,
ERR_Parameters,ERR_ParRef->SMRE_LocationHospital_DR->HOSP_Desc,ERR_PAADM_DR->PAADM_PAPMI_DR->PAPMI_RowId,ERR_PAADM_DR->PAADM_RowId,
ERR_PAADM_DR->PAADM_ADMNo,ERR_ExtractBuild_DR->SMREB_RunLocation_DR
FROM SQLUser.PA_SMRExtractErrors
WHERE ERR_ExtractBuild_DR = :RowId
ORDER BY	ERR_RowId Asc
}

}
