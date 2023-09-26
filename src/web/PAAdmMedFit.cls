Class web.PAAdmMedFit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 227;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MF_RowId";

Parameter SQLDESCRIPTION = "MF_RowId";

Parameter SQLROWID = "MF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllFetch ]
{
}

ClassMethod FindAllExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod FindAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllExecute ]
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String) As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod websysInsert(id As %Library.String, ParRef As %Library.String, MedicallyFit As %Library.String, MedFitDate As %Library.Date, MedFitTime As %Library.Time, MedUnfitDate As %Library.Date, MedUnfitTime As %Library.Time, delayDischarge As %Library.String = "")
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod websysUpdateMF(compref As %String, EpisodeID As %String)
{
}

Query Find(EpisodeID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "MFRowId:%String,MFDateMedFit:%Library.Date,MFTimeMedFit:%Library.Time,MFDateMedUnfit:%Library.Date,MFTimeMedUnfit:%Library.Time,reason:%String")
{
SELECT MF_RowId,MF_DateMedFit,MF_TimeMedFit,MF_DateMedUnfit,MF_TimeMedUnfit
FROM SQLUser.PA_AdmMedFit
WHERE (MF_ParRef = :EpisodeID) 
ORDER BY MF_DateMedFit ASC, MF_TimeMedFit ASC
}

Query Find1(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MFRowId:%String,MFDateMedFit:%Library.Date,MFTimeMedFit:%Library.Time,MFDateMedUnfit:%Library.Date,MFTimeMedUnfit:%Library.Time,reason:%String")
{
SELECT MF_RowId,MF_DateMedFit,MF_TimeMedFit,MF_DateMedUnfit,MF_TimeMedUnfit,MF_ReasonDelDisch_DR->READEL_Desc
FROM SQLUser.PA_AdmMedFit
WHERE (MF_ParRef = :EpisodeID) 
ORDER BY MF_DateMedFit ASC, MF_TimeMedFit ASC
}

Query FindAll(EpisodeID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "MedicallyFit,Date,Time")
{
SELECT MF_RowId
FROM SQLUser.PA_AdmMedFit
WHERE (MF_ParRef = :EpisodeID) AND (TRANS_Ward_DR IS NULL) AND (TRANS_Room_DR IS NULL) AND (TRANS_Bed_DR IS NULL) AND (TRANS_Main = 'Y')
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC
}

Query FindLastFit(EpisodeID As %Library.String, Date As %Library.Date, Time As %Library.Time) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MF_DateMedFit")
{
SELECT MF_DateMedFit
FROM SQLUser.PA_AdmMedFit
WHERE (MF_ParRef = :EpisodeID) 
ORDER BY MF_DateMedFit DESC
}

Query FindLastFitBeforeDateTime(EpisodeID As %Library.String, Date As %Library.Date, Time As %Library.Time) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Library.String,MFDateMedFit:%Library.Date,MFTimeMedFit:%Library.Time")
{
SELECT MF_RowId,MF_DateMedFit,MF_TimeMedFit
FROM SQLUser.PA_AdmMedFit
WHERE (MF_ParRef = :EpisodeID) 
AND (MF_DateMedFit < :Date OR (MF_DateMedFit = :Date AND MF_TimeMedFit < :Time))
ORDER BY MF_DateMedFit DESC, MF_TimeMedFit DESC
}

Query FindLastUnfit(EpisodeID As %Library.String, Date As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MF_DateMedUnfit")
{
SELECT MF_DateMedUnfit
FROM SQLUser.PA_AdmMedFit
WHERE (MF_ParRef = :EpisodeID) 
ORDER BY MF_DateMedUnfit DESC
}

Query FindLastUnfitBeforeDate(EpisodeID As %Library.String, Date As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID")
{
SELECT MF_RowId
FROM SQLUser.PA_AdmMedFit
WHERE (MF_ParRef = :EpisodeID) 
ORDER BY MF_DateMedFit DESC
}

}
