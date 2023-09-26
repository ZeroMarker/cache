Class web.MRPsychDetails Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 308;

Parameter SQLDATEFROM = "PSYCH_DateFrom";

Parameter SQLDATETO = "PSYCH_DateTo";

Parameter SQLCODE = "PSYCH_RowId";

Parameter SQLDESCRIPTION = "PSYCH_RowId";

Parameter SQLROWID = "PSYCH_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckMandatory(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod FindBoldLinks(ID As %String = "") As %String
{
}

/// Default implementation of LookUp Query.
ClassMethod FindByAdmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByCensusDate1Fetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindByAdmExecute(ByRef QHandle As %Library.Binary, EpisodeIDs As %String = "", PatientID As %String = "") As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindByAdmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByCensusDate1Execute ]
{
}

ClassMethod GetAdmissionDetails(PatientID As %Library.String, mrpsych As %Library.String, admcod As %Library.String)
{
}

ClassMethod GetCensusDetails(PatientID As %Library.String, mrpsych As %Library.String, admcod As %Library.String, CensusDate As %Library.String)
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCensusDate1Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByCensusDate1Fetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCensusDate1Execute(ByRef QHandle As %Library.Binary, CensusDate As %Library.Date) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCensusDate1Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByCensusDate1Execute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCensusDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByCensusDateFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCensusDateExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, CensusDate As %Library.Date, Specialty As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCensusDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByCensusDateExecute ]
{
}

ClassMethod websysSavePsych(compref As %Library.String, id As %Library.String, mradm As %Library.String)
{
}

/// ab 10.02.05 - 49101 - used in icon definitions MentalRemind1-4
ClassMethod ShowReminderIcon(EpisodeID As %String = "", FirstDays As %String = "", SecondDays As %String = "") As %String
{
}

Query FindByAdm(EpisodeID As %String, PatientID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "datefrom,dateto,legalst,mentcat,mradm,rowid,psychstatus,pension,reffurthcare,usualaccom,employmentstatus,PSYCHSectionDateFrom,PSYCHSectionDateTo,PSYCHSectionTimeFrom,PSYCHSectionTimeTo,PSYCHConsentDate,PSYCHConsentDateTo,PSYCHConsentTime,PSYCHOnLeave,TFDateTo,TFSecondOpinion,TFConsent,TFConsentObtained")
{
}

Query FindByAdmOLD(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "datefrom,dateto,legalst,mentcat,mradm,rowid,psychstatus,pension,reffurthcare,usualaccom,employmentstatus")
{
SELECT PSYCH_DateFrom,PSYCH_DateTo,PSYCH_LegalStat_DR->LEGST_Desc,PSYCH_MentalCateg_DR->MENTC_Desc,PSYCH_ParRef,PSYCH_RowId,PSYCH_Status,PSYCH_PensionStatus_DR->PENST_Desc,PSYCH_RefFurtherCare_DR->RFCARE_Desc,PSYCH_UsualAccom_DR->USACC_Desc,PSYCH_EmploymentStatus_DR->EMPLST_Desc
FROM SQLUser.MR_PsychDetails
WHERE PSYCH_ParRef->MRADM_ADM_DR=:EpisodeID
ORDER BY	PSYCH_DateFrom Asc
}

Query LookUpByCensusDate(TSRTITM As %Library.String, TSRTORD As %Library.String, CensusDate As %Library.Date, Specialty As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CensusMentalCategory,CensusLegalStatus,codspc,codcons,codstartdate,admdate,dob,sex,surname,forename,NHSNo,rego,pat,adm,admcod,mrpsych,startdate,starttime,cp,spc,marital,CensusDate,mradm,PsychStat,VIPStatus")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

Query LookUpByCensusDate1(CensusDate As %Library.Date, Specialty As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CensusMentalCategory")
{
}

}
