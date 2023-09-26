Class web.PAMergePatient Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 693;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MRG_RowId";

Parameter SQLDESCRIPTION = "MRG_RowId";

Parameter SQLROWID = "MRG_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckIPADMOverLap(compref As %Library.String, ToPID As %Library.String, FromPID As %Library.String) As %Library.Boolean
{
}

ClassMethod GetMergeDetails(RegNo As %Library.String) As %Library.String
{
}

/// cjb 28/04/2004 43512 - moved the sql here, from the csp page
ClassMethod GetPatientDetails(PatientID As %Library.String) As %Library.String
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String = "", fid As %Library.String = "") As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String, TOPatientId As %Library.String = "", FROMPatientId As %Library.String = "", MergePatList As %Library.String, AliasStr As %Library.String, usercode As %Library.String)
{
}

/// CJB 32430: Admission - Move Admission Episode changes for QH
ClassMethod websysSaveCopyAdmission(compref As %String, FromPat As %Library.String, ToPat As %Library.String, EpisodeIDString As %Library.String, MRNumberString As %Library.String, MRNumberInactiveString As %Library.String)
{
}

Query FindMerges(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "date,time,user,topat,MergeRego,reason,hosp,rowid,frompat")
{
SELECT MRG_Date, MRG_Time, MRG_User_DR->SSUSR_Name, MRG_PAPMI_To_DR, MRG_PAPMI_From_DR->PAPMI_No, MRG_ReasonForMerging_DR->REAMRG_Desc, MRG_Hospital_DR->HOSP_Desc, MRG_RowId,MRG_PAPMI_From_DR
FROM SQLUser.PA_MergePatient
WHERE MRG_PAPMI_To_DR= :PatientID
}

}
