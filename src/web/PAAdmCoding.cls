Class web.PAAdmCoding Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2587;

Parameter SQLCODE = "COD_EndDate";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "COD_RowId";

Parameter SQLROWID = "COD_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// Aji 12/6/03
/// This loads the cab file used to interface with 3M Coder
/// This is the very first thing that's loaded by the hidden frame.  
ClassMethod Load3MCoderCabFile()
{
}

/// Aji 6/6/03  
/// Desc: This creates input packet for 3M Coder Software.
/// This method is loaded after Load3MCoderCabFile()
/// 
ClassMethod Create3MCoderInputPacket(compref As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String)
{
}

ClassMethod websysSaveEncoder(compref As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String)
{
}

/// ajiw - 20/06/2003
/// Desc: This method is used to save codes from 3MEncoder. Called from PAAdmCoding.Edit3MCoder component
/// Param:  FieldAdmWeight - is the adm weight entered on the DRG Screen
ClassMethod websysSave3MCoder(compref As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String, FieldAdmWeight As %Library.String)
{
}

/// Author: ajiw
/// [Previously private]
ClassMethod BuildListCodeAllTag(codeStr As %Library.String, ByRef listProcIdx As %Library.Integer, ByRef listDiag As %Library.ListOfDataTypes, ByRef listProc As %Library.ListOfDataTypes) As %Library.Integer
{
}

/// Author: ajiw 20/06/03
/// [Previously private]
ClassMethod BuildListLegacyTag(codeStr As %Library.String, codePos As %Library.Integer, txtMode As %Library.Integer, ByRef listProcIdx As %Library.Integer, ByRef listDiag As %Library.ListOfDataTypes, ByRef listProc As %Library.ListOfDataTypes)
{
}

/// Author: ajiw 20/06/03  
/// Save Diagnosis codes
/// 
ClassMethod Save3MCoderDiagnosis(compid As %Library.String, EpisodeID As %Library.String, ListDiag As %Library.ListOfDataTypes, diagFields As %Library.String) As %Library.String
{
}

/// Author: ajiw 20/06/03  
/// Save Procedure codes
ClassMethod Save3MCoderProcedures(compid As %Library.String, TransID As %Library.String, EpisodeID As %Library.String, list3MProc As %Library.ListOfDataTypes, procFields As %Library.String) As %Library.String
{
}

/// cjb 11/04/2005 51584 - moved to web.RTCDefCodingMRMove
/// / KK 23/Jul/2003 Log 32778 - to move medical records on PAAdm.DRGCoding screen update. Called from web.PAAdmCoding.websysSaveDRGGrouping
ClassMethod MoveMedicalRecords(PatientID As %String = "", MRLoc As %String = "")
{
}

/// KK 12/Nov/2002 Log 28515  - Method to update the MrcopaymentAmount child table from WIESScore method
ClassMethod AddCopaymentAmount(mradm As %Library.String = "", id As %Library.String = "", c1 As %Library.String = "", c2 As %Library.String = "", Amount As %Library.String = "")
{
}

/// cjb 13/02/2007 52998 - new param SessionId passed from paadmcoding.findbatch.group.csp
ClassMethod BatchProcess(compref As %String = "", id As %String = "", idtrans As %String = "", mode As %String = "", drgpath As %String = "", dischdatefr As %String = "", dischdateto As %String = "", verified As %String = "", payor As %String = "", showadmwithdrgcodes As %String = "", DRGGrouperVersionID As %String = "", SessionId As %String = "")
{
}

/// KK 26/Nov/2002 Log 29160 Method to calculate CRAFT Score
ClassMethod CalculateCRAFTScore(EpisodeID As %Library.String = "")
{
}

/// KK 26/Nov/2002 Log 29160 Method to calculate CRAFT Score for Hypothetical episodes
ClassMethod CalculateHypCRAFTScore(compref As %Library.String = "", id As %Library.String = "")
{
}

/// KK 8/Nov/2002 Log 28515 Calculation of WIES Price
ClassMethod CalculateWIESPrice(EpisodeID As %Library.String = "", WIESScore As %Library.String = "", dischdate As %Library.String = "") As %Library.String
{
}

/// Log 64629 - rewrite method for readability and new date rule
ClassMethod CalculateWIESScore(EpisodeID As %Library.String = "")
{
}

/// SA 16.1.03 - log 31812: This method is used to retrieve the coding validation status, 
/// given the PAAdmCoding Rowid. Currently called from PAAdmCoding.HiddenValidation component
/// to populate the PAAdmCoding.HiddenValidation to populate the ValidationStatus field
ClassMethod CheckVerified(PatientID As %String = "", EpisodeID As %String = "") As %Library.String
{
}

/// PeterC Log 44877 12/07/04 Changed the above to look at the "VerifiedCoding" in PAAdm2
ClassMethod CheckVerifiedNew(PatientID As %String = "", EpisodeID As %String = "") As %Library.String
{
}

ClassMethod CodingCount(EpisodeID As %Library.String)
{
}

/// SA 9.07.02 - log 24621. Written for DRG Inquiry screen
/// 3M DRG Date is in the format DD/MM/YYYY (eg. 9/07/02 = 09/07/2002)
ClassMethod ConvertLogicalTo3MDate(InternalDate As %Library.String) As %Library.String
{
}

/// SA 27.02.02 - log 23200. Written for Medicode interface
/// Medicode Date is in the format DDMMYYYY (eg. 27/02/02 = 27022002)
ClassMethod ConvertLogicalToMedicodeDate(InternalDate As %Library.String) As %Library.String
{
}

/// SA 14.4.03 - log 32803. Written for Visasys interface
/// Visasys Date is in the format DD/MM/YYYY
ClassMethod ConvertLogicalToVisasysDate(InternalDate As %Library.String) As %Library.String
{
}

/// SA 27.02.02 - log 23200. Written for Medicode interface
/// Medicode Date is in the format DDMMYYYY (eg. 27/02/02 = 27022002)
ClassMethod ConvertMedicodeToLogicalDate(MedicodeDate As %Library.String) As %Library.String
{
}

/// SA 14.4.03 - log 32803. Written for Visasys interface
/// Visasys Date is in the format DD/MM/YYYY
ClassMethod ConvertVisasysToLogicalDate(Visasys As %Library.String) As %Library.String
{
}

/// SA 5.7.02: Method implemented for log 24580/24627
ClassMethod CopyDiagProcsAcrossEpisodes(compref As %Library.String, EpisodeFrom As %Library.String = "", EpisodesTo As %Library.String = "")
{
}

ClassMethod Create3MCounterFile(UDCtrType As %Library.String = "") As %Library.String
{
}

/// SA 27.02.02 - log 23706: Code for 3M DRG grouper
/// This method is used to create the input lines on PAAdmCoding.Edit3MDRG
/// Third party program 3M DRG Drouper is called to code Procedures and Diagnoses. 
/// 
/// SINGLE BATCH INPUT FILE:
/// - Input Lines created via single variable, which will be set to textarea object on component, then Input File created using component javascript
/// 
/// GROUP BATCH INPUT FILE:
/// - Input File created DIRECTLY from this method.
/// 
ClassMethod Create3MDRGInputLines(EpisodeID As %Library.String = "", DischargeDateFrom As %Library.String = "", DischargeDateTo As %Library.String = "", Payor As %Library.String = "", PAADMVerified As %Library.String = "", DRGPath As %Library.String = "", ShowAdmWithDRGCodes As %Library.String = "") As %Library.String
{
}

/// SA 10.07.02 - log 24621: Method created for implementation of DRG Inquiry.
/// This method is called by the standard method called for all DRG grouper calls 
/// web.PAAdmCoding.Create3MDRGInputLines when the EpisodeID="INQUIRY"
/// (This should be set via a d %request.Set("EpisodeID","INQUIRY") from the transition expression
/// in the workflow for the DRG Coding workflow item.
/// Input lines format to be created by this method appears below. It matches the TrakGrouper.inp
/// file which should appear on the clients ARDRG4x directory.
/// 
/// This inputline will be picked up by component PAAdmCoding.Edit3MDRG.js, and 
/// converted via this components' javascript to a txt file which will be picked up by the DRG grouper.
/// 
/// u_AdmRowId(10);      # AdmisionRowId
/// nam(31);             # patient name
/// mrnum(13);           # medical record number
/// adt(10){dd/mm/yyyy}; # admission date
/// ahr(2);              # admit hour 
/// sdt(10){dd/mm/yyyy}; # separation date
/// shr(2);              # separation hour 
/// bdt(10){dd/mm/yyyy}; # birth date
/// sex(1);              # sex 
/// sep(2);              # separation mode 
/// wgt(4);	             # admission weight
/// mhls(1);	     # mental health legal status
/// hmv(4);	             # hours on mechanical ventilation 
/// alos(4);	     # acute length of stay 
/// tlvdays(4);	     # total leave days
/// adx(5);              # admission diagnosis
/// pdx(5);              # principal diagnosis
/// sdx(20)(5);          # secondary diagnoses
/// ppr(7);              # principal procedure
/// spr(20)(7);          # secondary procedure
/// aged(3);             # age in days 
/// agey(3);             # age in years
/// intendedlos(1);	     # intendedlos
ClassMethod Create3MDRGInquiry(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod Create3MFilePath(DRGPath As %Library.String = "") As %Library.String
{
}

ClassMethod Create3MInputFileForInquiry(FilePath As %Library.String = "", FileName As %Library.String = "")
{
}

/// AJI L40679 12.11.03 - added GrouperType as a new parameter
ClassMethod CreateBatch3MInputFile(FilePath As %Library.String = "", FileName As %Library.String = "", DischargeDateFrom As %Library.String = "", DischargeDateTo As %Library.String = "", Payor As %Library.String = "", PAADMVerified As %Library.String = "", ShowAdmWithDRGCodes As %Library.String = "", HOSPDesc As %Library.String = "", RegistrationNo As %Library.String = "", MRN As %Library.String = "", GrouperType As %Library.String = "")
{
}

ClassMethod Create3MGrouperOutFile(FilePath As %Library.String = "", FileName As %Library.String = "", BatchFile As %Library.String = "")
{
}

ClassMethod CreateVisGrouperOutFile(FilePath As %Library.String = "", FileName As %Library.String = "", ExecFile As %Library.String = "", CmdFile As %Library.String = "")
{
}

/// SA 27.02.02 - log 23200: Custom code for McKesson RIE
/// This method is used to create the input lines on PAAdmCoding.EditMedicode 
/// Third party program "Medicode" is called to code Procedures and Diagnoses. 
/// Procedures and Diagnoses for selected episode are passed to Medicode for coding via a text (.in) input file 
/// See RIE's custom js (PAAdmCoding.EditMedicode.js) for creation of input files.
/// See attachment to log 23200 for line format (ie. InL1,2,3 and 4).
/// 
/// Example of Medicode.out
/// 
/// MEDTRAK||S|*|008000065X|MONEYPENNY CLARENCE,|13071978|1|||1|
/// 16|25032002||||25032002|||||DR N GRUBB|CARDIOLOGY||HRG|E04||2|||||
/// 3|A01.1|D|I10|Y|M01.35|A|I10|N|I26.0||I10|Y|
/// 4|K40.2|p|OP4|151|26032002|Y|K11.3|s|OP4|151|26032002|N|K61.1||OP4|151|26032002|Y|Z94.3||OP4|151|26032002|N|
/// EOF
/// 
ClassMethod CreateMedicodeInputLines(PatientID As %Library.String, EpisodeID As %Library.String, AdmCodingID As %Library.String)
{
}

/// cjb 01.08.2005 51278
ClassMethod CreateSimplecodeCodeTable(table As %Library.String = "", type As %Library.String = "") As %Library.String
{
}

/// cjb 01.08.2005 51278
ClassMethod CreateSimplecodeInputLine(cod As %Library.String = "")
{
}

/// RQG 23.10.02 - Code for 3M DRG grouper
/// This method creates single line input file to be used in DRG Grouping. This is called from method 
/// PAAdmCoding.Create3MGrouperFile
/// AJI L40679 12.11.03 - added GrouperType as a new parameter
ClassMethod CreateSingle3MLineInputFile(EpisodeID As %Library.String = "", FilePath As %Library.String = "", FileName As %Library.String = "", GrouperType As %Library.String = "") As %Library.String
{
}

/// KK 16/May/2003 Log 34531
/// To delete DRG and WIES details when a admission or discharge is cancelled.
ClassMethod DeleteDRGandWIESDetails(EpisodeID As %Library.String = "", action As %Library.String = "", compid As %Library.String = "")
{
}

ClassMethod Execute3MGrouper(mode As %Library.String = "", EpisodeID As %Library.String = "", DischargeDateFrom As %Library.String = "", DischargeDateTo As %Library.String = "", Verified As %Library.String = "", Payor As %Library.String = "", ShowAdmWithDRGCodes As %Library.String = "", DRGPath As %Library.String = "", OverNight As %Library.String = "", HOSPDesc As %Library.String = "", RegistrationNo As %Library.String = "", MRN As %Library.String = "", DRGGrouperVersionID As %Library.String = "")
{
}

ClassMethod ExecuteARDrgToVICDrg(Mode As %Library.String = "", DRGPath As %Library.String = "", FileName As %Library.String = "")
{
}

/// SA 15.4.03 - log 32803/32782: New Visasys grouper will recycle code from 3M grouper implementation.
/// Have created method to allow either grouper code to be called from same place.
ClassMethod ExecuteGrouper(mode As %Library.String = "", EpisodeID As %Library.String = "", DischargeDateFrom As %Library.String = "", DischargeDateTo As %Library.String = "", Verified As %Library.String = "", Payor As %Library.String = "", ShowAdmWithDRGCodes As %Library.String = "", DRGPath As %Library.String = "", OverNight As %Library.String = "", HOSPDesc As %Library.String = "", RegistrationNo As %Library.String = "", MRN As %Library.String = "", GrouperType As %Library.String = "")
{
}

ClassMethod ExecuteVisasysGrouper(mode As %Library.String = "", EpisodeID As %Library.String = "", DischargeDateFrom As %Library.String = "", DischargeDateTo As %Library.String = "", Verified As %Library.String = "", Payor As %Library.String = "", ShowAdmWithDRGCodes As %Library.String = "", DRGPath As %Library.String = "", OverNight As %Library.String = "", HOSPDesc As %Library.String = "", RegistrationNo As %Library.String = "", MRN As %Library.String = "")
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCodingAustClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCodingAustFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCodingAustExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String = "", PatientID As %String, EpisodeID As %Library.String, RegistrationNo As %Library.String = "", PAADMVerified As %Library.String = "", CareProvider As %Library.String = "", CareProviderID As %Library.String = "", Speciality As %Library.String = "", StartDate As %Library.Date = "", EndDate As %Library.Date = "", Payor As %Library.String = "", SkipAdmWithNoCodes As %Library.String = "", ShowAdmWithDRGCodes As %Library.String = "", SelectedAdmTypes As %Library.String = "", HiddenFindParam As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCodingAustFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCodingAustExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCodingClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCodingFetch ]
{
}

/// LOG 28131 : KK 4 Sep 2002 CodingStatus and ValStatus changed to SelCodingStatus and SelValStatus
///                      inorder to accept multiple values.
ClassMethod FindCodingExecute(ByRef QHandle As %Library.Binary, RegistrationNo As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String, CareProvider As %Library.String, Speciality As %Library.String, StartDate As %Library.String, StartTime As %Library.String, EndDate As %Library.String, EndTime As %Library.String, SelCodingStatus As %Library.String, SMRStatus As %Library.String, Payor As %Library.String, SelValStatus As %Library.String, ClinicalNotes As %Library.String, DisHosp As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod FindCodingFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCodingExecute ]
{
}

/// cjb 01/08/2005 51278
ClassMethod GetConnectionString() As %Library.String
{
}

/// RQG  26.11.02 - Log29161: This method is called from PAAdmDRGCoding and BLCCRAFTCalculation.Edit screens.
ClassMethod GetCRAFTDetails()
{
}

/// RQG 22.04.03 L32787: This will return all the episodes that require followup. 
/// This method is called in PAAdmDRGCoding component.
ClassMethod GetEpisodesReqFollowUp(PatientId As %Library.String = "") As %Library.String
{
}

/// KK 27/Aug/2002 Log 27332 To Calculate the ICU and CCU hours from PAAdmTransaction to dispay in PAAdm.DRGCoding
ClassMethod GetICUandCCUHours(EpisodeID As %Library.String) As %Library.String
{
}

/// RQG, 28.10.02: Need to set "OutputLines" from output file in order to display the DRG code and description in 
/// the PAADMCoding component.This method is called from PAAdmCoding.ExecuteDRGGrouper. 
/// 
ClassMethod GetOutputLine(OutputFile As %Library.String)
{
}

/// rqg,Log25417: To return the total number of hours stayed by the patient from admission to discharge
/// using the parameter mradm id.
ClassMethod GetTotalLengthOfStay(EpisodeID As %Library.String) As %Library.Numeric
{
}

/// SA 16.1.03 - log 31812: This method is used to retrieve the coding validation status, given the PAAdmCoding Rowid.
/// Currently called from PAAdmCoding.HiddenValidation component to populate the PAAdmCoding.HiddenValidation to populate the ValidationStatus field
ClassMethod GetValidationStatus(AdmCodingID As %Library.String = "") As %Library.String
{
}

ClassMethod GetWIESDetails(mradmid As %Library.String = "", episodeid As %Library.String = "")
{
}

/// cjb 03/06/2004 43316 - moved this method to PACancerReg.  Delete this in a few months...
ClassMethod IsCancerRegRequired() As %Library.Boolean
{
}

ClassMethod IsCoded(EpisodeID As %Library.String = "") As %Library.Boolean
{
}

/// cjb 08/09/2004 44777 - return the LeaveCat & ContractType values and let the custom script work out if the episode is contracted
ClassMethod IsContractedEpisode(EpisodeID As %Library.String = "") As %Library.Boolean
{
}

/// RQG 22.04.03 L32787: This method will return Boolean value of 1 if the last discharge and readmitted dates is within 
/// 28 days in the same hospital. This method is called in PAAdmDRGCoding - DischargeReadmit.
ClassMethod IsReadmittedIn28Days(PatientId As %Library.String = "") As %Library.Boolean
{
}

/// cjb 01/08/2005 51278
ClassMethod LoadSimpleodeCabFile()
{
}

ClassMethod LookUpByEpisodeIDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByEpisodeIDFetch ]
{
}

ClassMethod LookUpByEpisodeIDExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String) As %Library.Status
{
}

ClassMethod LookUpByEpisodeIDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByEpisodeIDExecute ]
{
}

/// RQG 23.04.03 L32773: This method is called from PAAdmDRGCoding.csp. It sets the value of MRAdmWeight
/// to Admission weight defined in PAAdmDRGCoding component in the ff. cases:
/// 1. If the admission source for the episode is identified as "Born in Hospital" (code 6 in PAC_AdmSource)  and the dob is equal to the date
/// of admission.
/// 2. If the admission source indicates statistical admission(code 9 in PAC_AdmSource) and the prior admission
/// for the patient has an admission source of "Born in Hospital" and the dob is equal to the date of admission.
ClassMethod SetAdmissionWeight(episodeid As %Library.String = "")
{
}

/// rqg,Log27337: This method is called from PAAdmCoding.websysSaveDRGGrouping.This resets the fields and
/// its value in the MRDiagnosis.EditDRG table.
ClassMethod SetDiagTableFields(diagstr As %Library.String)
{
}

/// rqg,Log27337: This method is called from PAAdmCoding.websysSaveDRGGrouping.This resets the fields and
/// its value in the MRProcedure.EditDRG table.
ClassMethod SetProcTableFields(procstr As %Library.String)
{
}

ClassMethod SetValStatus(AdmCoding As %Library.String)
{
}

/// cjb 27/10/2005 43304 - quite a few changes
ClassMethod UngroupBatch(compref As %Library.String, DischargeDateFrom As %Library.String = "", DischargeDateTo As %Library.String = "", Payor As %Library.String = "", PAADMVerified As %Library.String = "") As %Library.String
{
}

ClassMethod ValidateSMR(ValSMR As %Library.String)
{
}

/// KK 21/Nov/2002 Log 28512 Calculation of wies score and price for the wies inquiry screen
ClassMethod WIESInquiryScore(compref As %Library.String = "", id As %Library.String = "")
{
}

ClassMethod checkUniqueItem(TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PatientID As %Library.String = "", EpisodeID As %Library.String = "", RegistrationNo As %Library.String = "", PAADMVerified As %Library.String = "", CareProvider As %Library.String = "", CareProviderID As %Library.String = "", Speciality As %Library.String = "", StartDate As %Library.Date = "", EndDate As %Library.Date = "", Payor As %Library.String = "", SkipAdmWithNoCodes As %Library.String = "", ShowAdmWithDRGCodes As %Library.String = "", SelectedAdmTypes As %Library.String = "", HiddenFindParam As %Library.String = "")
{
}

//md 20.04.2005 will intro new beforesave routine that is DRG specific

//still in dev do not alternate

ClassMethod websysBeforeDRGSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// SA 27.02.02 - log 23706:  Code for 3M DRG Grouper 
/// This method is used by the update on PAAdmCoding.Edit3MDRG
/// It is part of the conversion of the current VB dll tkMTDRGGRPER (in particular, the GrouperInit Sub in the .bas file)
/// Third party program 3M DRG Grouper is called to code Procedures and Diagnoses. 
/// Procedures and Diagnoses for selected episode are passed to 3M for coding via a text (.in) input file 
/// 3M creates an output file which is translated into an input line which will be picked up by this method.
/// Fields from each line will then be extracted, translated (if neccessary), and saved to the database via this method.
/// See RIE's custom js (PAAdmCoding.Edit3MDRG.js) for creation of input and extraction of output files.
/// This save can be used for Single episode grouping or batch grouping for several episodes/patients.
/// SINGLE BATCH OUTPUT FILE:
/// - Output lines retrieved via textarea object on component.
/// GROUP BATCH INPUT FILE:
/// - Output file retrieved DIRECTLY from this method.
/// RQG 23.10.02 - Method was change to create output file for SINGLE/BATCH/INQUIRY.
/// 
ClassMethod websysSave3MDRG(compref As %Library.String, id As %Library.String = "", mode As %Library.String = "", DRGPath As %Library.String = "", OverNight As %Library.String = "")
{
}

ClassMethod websysSave3MGrouper(compref As %Library.String = "", id As %Library.String = "", idtrans As %Library.String = "")
{
}

/// SA 5.7.02 - logs 24580/24627: Method created to change the coding status for selected episode(s)
ClassMethod websysSaveCodStatusByAdm(compref As %Library.String = "", EpisodeIDs As %Library.String = "", CodingStatus As %Library.String = "")
{
}

/// md log 50057 functoion to validate against 2nd  Code in Pair from CT
ClassMethod Check2ndPair(oktosave)
{
}

ClassMethod websysSaveDRGGrouping(compref As %Library.String = "", id As %String = "", idtrans As %Library.String = "")
{
}

ClassMethod websysSaveMappedICD(icdstr As %Library.String = "", cnt As %Library.String = "")
{
}

/// SA 27.02.02 - log 23200: Custom code for McKesson RIE
/// This method is used by the update on PAAdmCoding.EditMedicode 
/// Third party program "Medicode" is called to code Procedures and Diagnoses. 
/// Procedures and Diagnoses for selected episode are passed to Medicode for coding via a text (.in) input file 
/// Medicode creates an output file which is translated into 4 input lines which will be picked up by this method.
/// Fields from each line will then be extracted, translated (if neccessary), and saved to the database via this method.
/// See RIE's custom js (PAAdmCoding.EditMedicode.js) for creation of input and extraction of output files.
/// See attachment to log 23200 for line format (ie. InL1,2,3 and 4).
/// 
/// Example of Medicode.out
/// 
/// MEDTRAK||S|*|008000065X|MONEYPENNY CLARENCE,|13071978|1|||1|
/// 16|25032002||||25032002|||||DR N GRUBB|CARDIOLOGY||HRG|E04||2|||||
/// 3|A01.1|D|I10|Y|M01.35|A|I10|N|I26.0||I10|Y|
/// 4|K40.2|p|OP4|151|26032002|Y|K11.3|s|OP4|151|26032002|N|K61.1||OP4|151|26032002|Y|Z94.3||OP4|151|26032002|N|
/// EOF
/// 
/// More Line 3 egs (seems record 2 with code M01.35 has problems saving)
/// 3|A01.1|D|I10|Y|M01.35|A|I10|N|I26.0||I10|Y|
/// 6|A01.1|D|I10|Y|M01.35|A|I10|N|I26.0||I10|Y|A01.1|D|I10|Y|M01.35|A|I10|N|I26.0||I10|Y|
/// 3|A01.1|D|I10|Y|I26.0||I10|Y|A01.1|D|I10|Y|
/// 
/// 16|25032002||||25032002|||||DR N GRUBB|CARDIOLOGY||HRG|E04||2|||||
/// 159*1|30042002|01052002|||30042002||01052002||||||HRG||||0||||
/// 159*1|30042002|01052002|||30042002||01052002||||||HRG|A08||2|||||
ClassMethod websysSaveMedicode(compref As %Library.String, id As %Library.String, EpisodeID As %Library.String)
{
}

/// cjb 01/08/2005 51278
ClassMethod websysSaveSimplecode(compref As %Library.String = "", cod As %Library.String = "", record As %Library.String = "", OtherData As %Library.String = "") As %Library.String
{
}

ClassMethod websysSaveVisasysDRG(compref As %Library.String, id As %Library.String = "", mode As %Library.String = "", DRGPath As %Library.String = "", OverNight As %Library.String = "")
{
}

/// LOG 20932 : BC 19 Feb 2002
/// LOG 28131 : KK 4 Sep 2002 CodingStatus and ValStatus changed to SelCodingStatus and SelValStatus
///                      inorder to accept multiple values.
Query FindCoding(RegistrationNo As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String, CareProvider As %Library.String, Speciality As %Library.String, StartDate As %Library.String, StartTime As %Library.String, EndDate As %Library.String, EndTime As %Library.String, SelCodingStatus As %Library.String, SMRStatus As %Library.String, Payor As %Library.String, SelValStatus As %Library.String, ClinicalNotes As %Library.String, DisHosp As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PatientID,EpisodeID,AdmcodingID,RegNo,EpisodeNo,Name,Name2,Name3,CodingStatus,SMRStatus,ClinNotes,CareProvider,Location,Sdate:%Library.Date,Stime:%Library.Time,Edate:%Library.Date,Etime:%Library.Time,bedcode,sigfacility,valstatus,ACP,VIPStatus,dishosp,ward,hosp")
{
}

/// Finding the Coding at the Admission level.  This is for the Australian market. 
/// The UK market does it's coding at the Transaction level (see PAAdmCoding)
Query FindCodingAust(TSRTITM, TSRTORD, PatientID, EpisodeID, RegistrationNo, PAADMVerified, CareProvider, CareProviderID, Speciality, StartDate As %Library.Date, EndDate As %Library.Date, Payor, SkipAdmWithNoCodes, ShowAdmWithDRGCodes, SelectedAdmTypes, HiddenFindParam) As %Library.Query(CONTAINID = 0, ROWSPEC = "PatientID,EpisodeID,RegistNo,EpisodeNo,Name,Name2,Name3,Verified,ClinNotes,CareP,Spec,Sdate:%Library.Date,Stime:%Library.Time,Edate:%Library.Date,Etime:%Library.Time,URN,DOB,MRLoc,Hosp,DateMoved,CareType,AdmType,Deceased,DischUnitCode,InpAdmType,Name4,Name5,Name6,Name7,Name8,VIPStatus")
{
}

Query GetPAAdmCodingIdsByParent(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CODRowId")
{
SELECT COD_RowId
FROM SQLUser.PA_AdmCoding
WHERE COD_ParRef = :EpisodeID
}

Query LookUpByEpisodeID(TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Cons,CareProvider,Location,Sdate:%Library.Date,Stime:%Library.Time,Edate:%Library.Date,Etime:%Library.Time,hidden:%Library.String")
{
}

/// cjb 10/02/2005 49390 - dummy methods as the brokers aren't being used (not actually used, but they are on some hidden fields, DR's to PAAdm...)
/// the dummy methods ensure that websys.abstract doesn't generate nasty sql
ClassMethod LookUpDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetIdFromCodeOrDescription(id As %Library.String) As %Library.String
{
}

ClassMethod GetIdFromDateCodeOrDesc(id As %Library.String, date As %Library.Date = "") As %Library.String
{
}

ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

}
