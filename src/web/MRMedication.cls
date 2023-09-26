Class web.MRMedication Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 704;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MED_RowId";

Parameter SQLROWID = "MED_RowId";

Parameter SQLDESCRIPTION = "MED_RowId";

ClassMethod GetMedsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetMedsFetch ]
{
}

ClassMethod GetMedsExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod GetMedsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetMedsExecute ]
{
}

/// Log 58610 - GC - 26-04-2006 : Add MEDDSReportFlag to ROWSPEC
Query GetMeds() As %Query(CONTAINID = 0, ROWSPEC = "MEDRowId,MEDParRef,MEDHL7Number,MEDDetails,MEDType,MEDComments,MEDExcludeFromDS,MEDLastUpdateDate,MEDLastUpdateTime,MEDLastUpdateUser,MEDLastUpdateHospital,CanAddDSMedications,MEDDSReportFlag,HiddenFields,PHCGenRtFrm,PHCDrgMast,PHCForm,MEDDose,CTUOM,PHCFreq,PHCDuration,MEDDurationFree,MRCICDDx,MEDCeased,MEDDSReportFlag,PHCStrength,PHCDrugRoute")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveMed(compref As %String, id As %Library.String = "")
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod websysSaveHist() As %Boolean
{
}

/// Log 55973 - PJC - 07-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

ClassMethod ProfileListClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod ProfileListExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PatientID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod ProfileListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

/// List of orders to be shown in medication profile
/// Log 55226 - PJC - 22-02-2006 : Get orders to display in new Medication Profile.
Query ProfileList(TSRTITM, TSRTORD, PatientID, EpisodeID) As %Library.Query(CONTAINID = 1, ROWSPEC = "EpisodeId:%String,EpisodeNumber:%String,OrderStatus:%String,PharmacyItem:%String,GenericItem:%String,DrugForm:%String,ArcimRowId:%String,Priority:%String,DoseUOM:%String,Frequency:%String,Instructions:%String,AdminRoute:%String,Duration:%String,MedicalIllness:%String,Ceased:%String,DateComplete:%String,RowColour:%String,LastUpdateDate:%Date,LastUpdateTime:%String,LastUpdateUser:%String,OrderId:%String,StatusCode:%String,PatientID:%String,MRAdmID:%String,MRMedicationId:%String,Modify:%String,AdminRate:%String,IVType:%String,Strength:%String,DrugRoute:%String,DSReportFlag:%String,MEDComments:%String,MEDDetails:%String")
{
}

/// Log 58610 - GC 26/04/2006 : Save the DS Report Flag.
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

}
