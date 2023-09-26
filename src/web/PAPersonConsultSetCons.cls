Include webimport

IncludeGenerator webimport

Class web.PAPersonConsultSetCons Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 436;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CONS_RowId";

Parameter SQLDESCRIPTION = "CONS_RowId";

Parameter SQLROWID = "CONS_RowId";

/// ab 24.08.06 59768 - returns if consult exists with status passed. desc flag returns all consultation categorys for matching consults
ClassMethod GetStatusIcon(PatientID As %String = "", Status As %String = "", Desc As %String = "") As %String
{
}

ClassMethod GetConsetConsultsExecute(QHandle As %Library.Binary, PatientID As %Library.String, ConsultSetDR As %Library.String, SearchDiagnosisID As %Library.String = "", SearchChiefComplaintID As %Library.String = "", SearchDateFrom As %Library.String = "", SearchDateTo As %Library.String = "", SearchCareProvID As %Library.String = "", SearchConsultStatus As %Library.String = "", SearchActiveDiagnosis As %Library.String = "", SearchSignificant As %Library.String = "") As %Library.Status
{
}

ClassMethod GetConsetConsultsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetConsetConsultsExecute ]
{
}

ClassMethod GetConsetConsultsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetConsetConsultsFetch ]
{
}

/// Used in epr.SOAPPlanning
/// - OrdType values -
/// "A" - Assessment Orders (CT->Order & Results->Consult Category->Order List)
/// "T" - Treatment Orders (CT->Electronic Medical Records->ICD Codes->Order List)
ClassMethod LookUpOrdListsExecute(QHandle As %Library.Binary, ConsultID As %String = "", OrdType As %String = "A") As %Library.Status
{
}

ClassMethod LookUpOrdListsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOrdListsExecute ]
{
}

ClassMethod LookUpOrdListsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOrdListsFetch ]
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Library.Boolean
{
}

/// ab 17.08.06 59768
ClassMethod websysSaveEndConsult(compref As %String = "", ByRef id As %String = "")
{
}

ClassMethod websysSaveConsult(compref As %String = "", ByRef id As %String = "")
{
}

ClassMethod ConsultOrdersExecute(QHandle As %Library.Binary, ConsultID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod ConsultOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ConsultOrdersExecute ]
{
}

/// Creates a new consultation with the same details as the passed in ConsultID except for date and time
/// Copies across Subjective Findings and Diagnoses belonging to this ConsultID
/// New fields added to User.PAPersonConsultSetCons must also be added here
ClassMethod CopyConsult(ConsultID As %String = "", EpisodeID As %String = "", ApptID As %String = "")
{
}

ClassMethod ConsultOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ConsultOrdersFetch ]
{
}

Query GetConsetConsults(PatientID As %Library.String, ConsultSetDR As %Library.String, SearchDiagnosisID As %Library.String = "", SearchChiefComplaintID As %Library.String = "", SearchDateFrom As %Library.String = "", SearchDateTo As %Library.String = "", SearchCareProvID As %Library.String = "", SearchConsultStatus As %Library.String = "", SearchActiveDiagnosis As %Library.String = "", SearchSignificant As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ConsultDR,EpisodeID,VisitDate,VisitTime,CareProv,CareProvID,ChiefComplaint,Diagnosis,Significant,ConsultStatus,Notes,ApptId,EpisodeNo")
{
}

Query LookUpOrdLists(ConsultID As %Library.String, OrdType As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Desc")
{
}

Query ConsultOrders(ConsultID As %Library.String, EpisodeID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "isPrevCons,ID,Dosage,Duration,Frequency,FullDetails,OrderName,Instruction,Priority,SequenceNumber,Status,StatusCode,StartDate,Notes,UnitOfMeasure,Paid,PathwayStep,DCDate,DCTime,PatientShare,ExecutionTimes,Specimens,LabEpisNo,OrderType,OrderCat,OrderMsg,DefDurID,OEItemMstID,OrderDoc,ReceivLoc,Group,DateOrdered,TimeOrdered,SpecimenCDate,SpecimenCTime,LabRecDate,LabRecTime,LUUser,LUTime,LUDate,MealTime,Modifiers,RadStatus,RefDoctor:%String,MealType:%String,SpecimenADate,SpecimenATime,StartTime,DayBookAccNums,DayBookSpecs,EpisodeID,LinkedTo,LinkedToItmID,LinkedArcimID,OrdItmEpisodeID,RadSeriesNo:%String,VarianceReason:%String,OrdEndDate:%String,OrdEndTime:%String,Alerts:%String,ReasonForOverride:%String,AuthorisingClinician:%String, PAADMDEpisDate, PAADMEpisType, PAPMIName, PAPMIName2,PAPMIName3,PAPMIDOB,PAPMISex,PatRegNo,MRN,PAADMConsDR,PAADMUnit,PAADMWard, PAADMBed, OrderCode, OrderLink, intMRN, TotalDosage, Hospital, Specialty, CollectedBy:%String,StartHour,ExeTime,ExeDate,DCUser,Quantity,PAADMRoom,DocumentList:%String,mradmdr,ResultAvailableDate:%Date,Ingredients,PharmacyStatus,PrescriptionNo,ToothLocation,drugDESC,OrderNotes:%String,OrderSet:%String,PAADMEpisNo:%String,DiscClasDesc,GenDrugDetails,Payor,Plan,Price,OverrideRowID,PrioColour,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,TestItemResult,DateExecuted,TimeExecuted,PRNMaxDose,PRNTotalDoses,PRNIndication,CollByPatRep,TIAnaOperationNo,TIAnaestNo,NoResultReas,MaxRep,QuestionnaireID,AdmRoute,DrugRoute,ShowDispChangeLink,ExecDoctor,OEORIBilled,OEORIDSReportFlag,Repeat,OEOrdExecID,VIPStatus,lastPRN,HasNotes,AdminFlowRate,MODesc,MOColor,SingleAdmin")
{
}

ClassMethod GetFollowupOrdDefaults(ConsultID As %String = "") As %String
{
}

ClassMethod GetFollowupOrdArcim(ConsultID As %String = "") As %String
{
}

Query LookUpFollowupOrder(ConsultID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String,HIDDEN:%String")
{
}

ClassMethod LookUpFollowupOrderClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFollowupOrderFetch ]
{
}

/// ab 22.08.06 59768
ClassMethod LookUpFollowupOrderExecute(ByRef QHandle As %Library.Binary, ConsultID As %String = "") As %Library.Status
{
}

ClassMethod LookUpFollowupOrderFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFollowupOrderExecute ]
{
}

}
