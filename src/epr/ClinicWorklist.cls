Class epr.ClinicWorklist Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetPrefTabs()
{
}

ClassMethod DisplayTabHeaders()
{
}

ClassMethod ClinicworklistOK() As %String
{
}

ClassMethod ClinicWorklistExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "") As %Library.Status
{
}

ClassMethod GetCodes(str)
{
}

ClassMethod ClinicWorklistFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ClinicWorklistExecute ]
{
}

ClassMethod ClinicWorklistClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ClinicWorklistFetch ]
{
}

ClassMethod SignPhoneOrders(compref As %Library.String = "", OrderIds As %Library.String)
{
}

Query ClinicWorklist(TSRTITM, TSRTORD) As %Library.Query(CONTAINID = 1, ROWSPEC = "RESID,RESDescription,RESDateCreated,RESTimeCreated,RESName,RESStatusCode,RESStatus,RESType,RESDateRead,RESOtherRowid,RESFileName,RESEpisodeNo,RESOEORIDateExecuted,RESCareProv,RESOEORILabEpisodeNo,RESaudittable,RESauditfieldno,RESauditid,RESorderid,REScomponentid,RESARCICHL7ResultType,RESCollectionDate,RESCollectionTime,RESOEORIEpisArriveDate,RESOEORIEpisArriveTime,RESOEORISttDat,RESOEORISttTim,RESResultDate,RESResultTime,RESFillerNo,RESLabStatusCode,RESExternalSystemCode,RESDicom,RESOEORILabAction,RESOSTATDesc,RESUserVerified,RESAbnormal,RESPreviousResult,RESUserCreated,RESAction,RESComment,RESOrderCategory,RESDisplayWordFormat,RESOEORICode,RESARCIMRowid,RESOEORISeriesNo,REFDDesc,RESCPReported,RESCPVerified,RESTaggedRowIDs,RESUnTaggedRowIDs,RESResultsLink,RESHiddenData,ID,Dosage,Duration,Frequency,FullDetails,OrderName,Instruction,Priority,SequenceNumber,Status,StatusCode,StartDate,Notes,UnitOfMeasure,Paid,PathwayStep,DCDate,DCTime,PatientShare,ExecutionTimes,Specimens,LabEpisNo,OrderType,OrderCat,OrderMsg,DefDurID,OEItemMstID,OrderDoc,ReceivLoc,Group,DateOrdered,TimeOrdered,SpecimenCDate,SpecimenCTime,LabRecDate,LabRecTime,LUUser,LUTime,LUDate,MealTime,Modifiers,RadStatus,RefDoctor:%String,MealType:%String,SpecimenADate,SpecimenATime,StartTime,DayBookAccNums,DayBookSpecs,EpisodeID,LinkedTo,LinkedToItmID,LinkedArcimID,OrdItmEpisodeID,RadSeriesNo:%String,VarianceReason:%String,OrdEndDate:%String,OrdEndTime:%String,Alerts:%String,ReasonForOverride:%String,AuthorisingClinician:%String, PAADMDEpisDate,PAADMEpisType, PAPMIName, PAPMIName2,PAPMIName3,PAPMIDOB,PAPMISex,PatRegNo,MRN,PAADMConsDR, PAADMUnit, PAADMWard, PAADMBed, OrderCode, OrderLink, intMRN, TotalDosage, Hospital, Specialty, CollectedBy, StartHour,ExeTime,ExeDate,DCUser,Quantity,PAADMRoom,DocumentList,mradmdr,ResultAvailableDate:%Date,Ingredients,PharmacyStatus,PrescriptionNo,ToothLocation,drugDESC,OrderNotes,OrderSet,PAADMEpisNo,DiscClasDesc,GenDrugDetails,Payor,Plan,Price,OverrideRowID,PrioColour,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,TestItemResult,DateExecuted,TimeExecuted,PRNMaxDose,PRNTotalDoses,PRNIndication,CollByPatRep,TIAnaOperationNo,TIAnaestNo,NoResultReas,MaxRep,QuestionnaireID,AdmRoute,DrugRoute,ShowDispChangeLink,ExecDoctor,OEORIBilled,OEORIDSReportFlag,Repeat,OEOrdExecID,VIPStatus,LastPRN,HasNotes,AdminFlowRate,MODesc,MOColor,SingleAdmin,UserAddHosp,DrugForm,DrugStrength,ObservationGroupDR,AdminQuestionnDR,STATCode,AnnotationLink,IVType,LinkedDiag,PrescriptionNoLink,OkToAdminister")
{
}

}
