Include webimport

IncludeGenerator webimport

Class web.OEOrdResult Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1446;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RES_RowId";

Parameter SQLDESCRIPTION = "RES_RowId";

Parameter SQLROWID = "RES_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod BatchReporting(itemIDs As %String)
{
}

/// log 64023
ClassMethod GetVoiceComponent()
{
}

//log59575 TedT remove order result if not updated

ClassMethod RemoveResult(filename As %String, txtfilename As %String) As %String
{
}

/// log 62067 TedT 
ClassMethod GetVoiceLength(ordID As %String) As %String
{
}

/// log 62067 TedT 
ClassMethod FormatTime(millisecs As %String) As %String
{
}

/// log 61271 TedT 
ClassMethod GetUrgentReport(OrdIds As %String) As %String
{
}

/// log 61271 TedT 
/// log 62555 TedT took out usercode
ClassMethod GetReport(OrderID As %String = "", ResultDesc As %String = "", TranscribedBy As %String = "", overseen As %String = "") As %String
{
}

/// log 61271 TedT 
ClassMethod GetResultDate(OrderId As %String = "", type As %String = "") As %String
{
}

ClassMethod UnlinkOrders(compref As %String, itemIDs As %String)
{
}

ClassMethod GetCurrentRadResult(OEOrdItemID As %String = "", FileExt As %String = "") As %Library.String
{
}

ClassMethod GetCounter(OEOrdItemID As %String = "", Type As %String = "", RESRowID As %String = "", OEItmStat As %String = "") As %Integer
{
}

/// Log 57445 - AI - 13-12-2005 : Add 2nd parameter OETextID. Same as web.OETextResult, GetTranscriptionist method.
ClassMethod GetCPReported(OEOrdItemID As %String = "", OETextID As %Library.String = "") As %Library.String
{
}

/// Write the HTML for displaying the DICOM Viewer applet
/// KK 26/Sep/2002 Log: 26224 modified to load 4 applets depending on the number of studies
ClassMethod DicomViewerShow(Study As %Library.String) As %Library.Status
{
}

ClassMethod DicomViewerShow1(Study As %Library.String, width As %Library.String = "", height As %Library.String = "") As %Library.Status
{
}

/// PJC A simple mentod to return the accession number so we can search for dicom images on 3rd party pax
ClassMethod GetAccessionNumber(OrderID As %Library.String, AccessionNo As %Library.String) As %Library.String
{
}

ClassMethod FindPatUnreadResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatUnreadResFetch ]
{
}

ClassMethod FindPatUnreadResExecute(ByRef QHandle As %Library.Binary, CURRLoc As %Library.String, CurrWard As %Library.String) As %Library.Status
{
}

ClassMethod FindPatUnreadResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatUnreadResExecute ]
{
}

ClassMethod FindPreviousRadResultClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPreviousRadResultFetch ]
{
}

ClassMethod FindPreviousRadResultExecute(ByRef QHandle As %Library.Binary, OEId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPreviousRadResultFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPreviousRadResultExecute ]
{
}

ClassMethod FindPreviousResultClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPreviousResultFetch ]
{
}

ClassMethod FindPreviousResultExecute(ByRef QHandle As %Library.Binary, OrderID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPreviousResultFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPreviousResultExecute ]
{
}

ClassMethod GetAlternateReport(rid As %Library.String = "") As %Library.String
{
}

/// Log 57445 - AI - 13-12-2005 : Add 2nd parameter OETextID. Same as web.OETextResult, GetTranscriptionist method.
ClassMethod GetCareProv(OEOrdItemID As %Library.String = "", OETextID As %Library.String = "") As %Library.String
{
}

/// Log 64994 - 24.09.2007 - added new parameter Type
ClassMethod GetDescription(OEOrdItemID As %Library.String = "", Type As %Library.String = "") As %Library.String
{
}

/// KK 26/Sep/2002 Log: 26224 Method to get dicom images depending on study and series
ClassMethod GetDicomFiles(OrderID As %Library.String, PatientID As %Library.String, mradm As %Library.String, catgsID As %Library.String, dfrom As %Library.String, dto As %Library.String, EpisodeAll As %Library.String) As %Library.String
{
}

ClassMethod GetNoReportCheckBoxStatus(OrderID As %Library.String = "") As %Library.Boolean
{
}

/// find status of result associated to an order item
/// RESV = verified Word document attached to order item 
///   which overrides
/// TYP = Word document attached to order item 
///   which overrides
/// REP = Voice file attached to order item
ClassMethod GetRadiologyStatus(oeitmid As %Library.String, ByRef SupResFlag As %Library.String = "") As %Library.String
{
}

/// KK Log:22796,23603 13/Mar/2002 Get the Saved filename of the word document or the voice file from OEOrdresults
ClassMethod GetSavedFileName(OEOrdItemIDs As %Library.String, type As %Library.String, RESRowId As %Library.String = "")
{
}

ClassMethod GetTestItemData(TestItemPosition As %Library.String = "", TestItemList As %Library.String = "")
{
}

ClassMethod GetUserCareProvLink(UserID As %Library.String = "") As %Library.String
{
}

ClassMethod GetVirtualDirectoryPath() As %Library.String
{
}

/// KK Log:22796 13/Mar/2002 Get OEOrdItemID from IDs and Get Word Template Name
ClassMethod GetWordTemplateName(OEOrdItemIDs As %Library.String)
{
}

/// KK Log:22795 18/Mar/2002
/// This method is called after the voice file is saved in the javascript to update  OEOrdResult. 
ClassMethod SaveVoiceFile(compref As %String = "", OEOrdItemIDs As %Library.String, StatusRowId As %Library.String, fname As %Library.String)
{
}

/// Calculates and sets the parent orderitem resultstatus flag
/// Replicates the old routine at1290
/// 
/// Called straight from the User class triggers in the after insert and after update
ClassMethod SetParentResultStatus(oeitm As %Library.String = "")
{
}

ClassMethod ValidateUser(user As %String) As %String
{
}

ClassMethod ValidateUserBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", user As %Library.String) As %Library.Boolean
{
}

ClassMethod WordViewerShow(width As %Library.String = "", height As %Library.String = "") As %Library.Status
{
}

ClassMethod getUnReadResultsAll(EpisodeIDs As %Library.String) As %Library.String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveImgVer(compref As %String = "", id As %String = "")
{
}

/// Write the HTML for displaying the DICOM Viewer applet
ClassMethod zzDicomViewerShow1() As %Library.Status
{
}

/// Log 56081 - PJC - 06-02-2006 : New method to return if the Episode has Urgent Results or not.
///         Called from "UrgentResults" icon definition, via ^epr.CTIconProfileI("UrgentResults") (epr.CTIconProfile - BuildGlobals).
ClassMethod GotUrgentResult(EpisodeID As %Library.String, ByRef Desc As %Library.String = "") As %Library.String
{
}

Query Find(orditm As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RESName:%String,RESFileName:%String,RESType,RESSTCode,RESLastUpdateDate,RESLastUpdateTime")
{
SELECT RES_RowId, RES_Name, RES_FileName, RES_Type, RES_ResStat_DR->RESST_Code,RES_LastUpdateDate,RES_LastUpdateTime
FROM SQLUser.OE_OrdResult
WHERE (RES_ParRef = :orditm)
AND (((RES_Type='W') OR (RES_FileName['.rtf')) OR((RES_Type='V')))
ORDER BY RES_LastUpdateDate DESC,RES_LastUpdateTime DESC
}

/// KM 14-Mar-2001: This dicom stuff is not presently used but leave query here for the moment until we see what happens with it.
Query FindDicomResults(RowId) As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,RESFileName:%String")
{
SELECT RES_RowId,RES_FileName
FROM SQLUser.OE_OrdResult
WHERE (RES_FileName !='')
AND (RES_Type='D') 
AND (RES_ParRef=:RowId)
}

/// Called from MRAdm.ResultsExecute()
/// 
/// KM 18-Sept-2001: Made query order by RES_ParRef so that I can be sure that 
/// all dicom results related to the same order will be returned in sequence.
/// 
/// Log 26096 - AI - 16-07-2002 : Added the following to get the value of the
/// order subcategory's "Only Show Verified Results" flag.
/// RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OnlyShowVerRes
/// 
/// Log 27416 - AI - 27-08-2002 : Replaced the following : ORDER BY RES_ParRef
/// to : ORDER BY RES_ParRef, RES_DateCreated DESC, RES_TimeCreated DESC
/// 
/// SELECT	RES_RowId, RES_DateCreated, RES_TimeCreated, 
/// 	RES_Name, RES_Type, RES_ResStat_DR->RESST_Desc, 
/// 	RES_FileName, RES_ParRef, 
/// 	RES_ResStat_DR->RESST_Code,
/// 	RES_DateRead,RES_TimeRead,
/// 	RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_AdmNo,
/// 	RES_ParRef->OEORI_Rowid,
/// 	RES_ParRef->OEORI_ItmMast_DR->ARCIM_Desc,
/// 	RES_ParRef->OEORI_DateExecuted,
/// 	RES_CTCP_DR->CTPCP_Desc,
/// 	RES_ParRef->OEORI_LabEpisodeNo,
/// 	RES_ParRef->OEORI_Priority_DR,
/// 	RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OnlyShowVerRes
/// 	FROM OE_OrdResult
/// 	WHERE (RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
/// 	AND (:catgsID [ (","_%INTERNAL(RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_","))
/// 	AND ((RES_ParRef->OEORI_DateExecuted <= :dto) OR (:dto is NULL))
/// 	AND ((RES_ParRef->OEORI_DateExecuted >= :dfrom) OR (:dfrom is NULL))	
/// 	ORDER BY RES_ParRef, RES_DateCreated DESC, RES_TimeCreated DESC
/// 
Query FindDicomResultsForOrder(OrderID As %Library.String, catgsID As %Library.String, dfrom As %Library.Date, dto As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RESDateCreated:%Date,RESTimeCreated:%Time,RESName:%String,RESType:%String,RESSTDesc:%String,RESFileName:%String,RESParRef:%String,RESSTCode:%String,RESDateRead:%Date,RESTimeRead:%Time,EpisodeNo:%String,OEORIRowid:%String,OEORIDesc:%String,OEORIDateExecuted:%String,CareProv:%String,OEORILabEpisodeNo:%String,OEORIPriorityDR:%String,ARCICOnlyShowVerRes:%String,RESDICOMStudyInstanceUID:%String,RESDICOMSeriesInstanceUID:%String,RESDICOMSOPInstanceUID:%String,RESDICOMSeriesNumber:%String")
{
SELECT RES_RowId, RES_DateCreated, RES_TimeCreated, 
 RES_Name, RES_Type, RES_ResStat_DR->RESST_Desc, 
 RES_FileName, RES_ParRef, 
 RES_ResStat_DR->RESST_Code,
 RES_DateRead,RES_TimeRead,
 RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_AdmNo,
 RES_ParRef->OEORI_Rowid,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_Desc,
 RES_ParRef->OEORI_DateExecuted,
 RES_CTCP_DR->CTPCP_Desc,
 RES_ParRef->OEORI_LabEpisodeNo,
 RES_ParRef->OEORI_Priority_DR,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OnlyShowVerRes,
 RES_DICOM_StudyInstanceUID,
 RES_DICOM_SeriesInstanceUID,
 RES_DICOM_SOPInstanceUID,
 RES_DICOM_SeriesNumber
 FROM SQLUser.OE_OrdResult
 WHERE (RES_ParRef->OEORI_Rowid = :OrderID)
 AND ((:catgsID [ (','_%INTERNAL(RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_',')) OR :catgsID is NULL)
 AND ((RES_ParRef->OEORI_DateExecuted <= :dto) OR (:dto is NULL))
 AND ((RES_ParRef->OEORI_DateExecuted >= :dfrom) OR (:dfrom is NULL))
 AND (RES_Type='D')
 ORDER BY RES_DICOM_SeriesNumber
}

/// Used in GetDicomFiles method
Query FindDicomResultsForOrderStudy(OrderID As %Library.String, catgsID As %Library.String, dfrom As %Library.Date, dto As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RESDICOMStudyInstanceUID")
{
SELECT DISTINCT RES_DICOM_StudyInstanceUID
 FROM SQLUser.OE_OrdResult
 WHERE (RES_ParRef->OEORI_Rowid = :OrderID)
 AND ((:catgsID [ (','_%INTERNAL(RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_',')) OR :catgsID is NULL)
 AND ((RES_ParRef->OEORI_DateExecuted <= :dto) OR (:dto is NULL))
 AND ((RES_ParRef->OEORI_DateExecuted >= :dfrom) OR (:dfrom is NULL))
 AND (RES_Type='D')
}

/// KK 26/Sep/2002 Log: 26224 Used in GetDicomFiles method
Query FindDicomSeriesImages(SeriesRowId As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,RESFileName,OEOrdResId,SOPInstanceUID")
{
SELECT DCIMG_RowID,DCIMG_ImageFileName,DCIMG_OeOrdRes_DR,DCIMG_SOPInstanceUID
FROM SQLUser.DICOM_Image
WHERE (DCIMG_Series_DR = :SeriesRowId)
ORDER BY DCIMG_ImageNumber DESC
}

/// KK 26/Sep/2002 Log: 26224 Used in GetDicomFiles method
Query FindDicomSeriesResults(StudyInstanceUID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,RESDICOMSeriesInstanceUID")
{
SELECT DCSRS_RowID,DCSRS_SeriesInstanceUID 
FROM SQLUser.DICOM_Series 
WHERE (DCSRS_Study_DR = :StudyInstanceUID)
ORDER BY DCSRS_SeriesNumber
}

/// Called from MRAdm.ResultsExecute()
/// 
/// KM 18-Sept-2001: Made query order by RES_ParRef so that I can be sure that 
/// all dicom results related to the same order will be returned in sequence.
/// 
/// Log 26096 - AI - 16-07-2002 : Added the following to get the value of the
/// order subcategory's "Only Show Verified Results" flag.
/// RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OnlyShowVerRes
/// 
/// Log 27416 - AI - 27-08-2002 : Replaced the following : ORDER BY RES_ParRef
/// to : ORDER BY RES_ParRef, RES_DateCreated DESC, RES_TimeCreated DESC
/// 
/// Log 30564 - AI - 07-02-2003 : Add single line to get the Order Category:
/// RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc
/// and add this to the Row Specification.
/// 
Query FindForResultsProfile(EpisodeID As %Library.String, catgsID As %Library.String, dfrom As %Library.Date, dto As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RESDateCreated:%Date,RESTimeCreated:%Time,RESName:%String,RESType:%String,RESSTDesc:%String,RESFileName:%String,RESParRef:%String,RESSTCode:%String,RESDateRead:%Date,RESTimeRead:%Time,EpisodeNo:%String,OEORIRowid:%String,ARCIMRowid:%String,OEORIDesc:%String,OEORICode:%String,OEORIDateExecuted:%String,OEORITimeExecuted:%String,CareProv:%String,OEORILabEpisodeNo:%String,OEORIPriorityDR:%String,ARCICOnlyShowVerRes:%String,RESDICOMSeriesInstanceUID:%String,RESDICOMSOPInstanceUID:%String,RESDICOMSeriesNumber:%String,OEORISttTim,OEORISttDat,RESDateVerified,RESTimeVerified,OSTATDesc,ResultSensitive,RESUserVerified,RESUserCreated,RESAction,RESComments,OrderCategory:%String,RESNSRDR,RESAbnormal,OEORISeriesNo,REFDDesc,RESCPReported,RESCPVerified")
{
SELECT RES_RowId, RES_DateCreated, RES_TimeCreated, 
 RES_Name, RES_Type, RES_ResStat_DR->RESST_Desc, 
 RES_FileName, RES_ParRef, 
 RES_ResStat_DR->RESST_Code,
 RES_DateRead,RES_TimeRead,
 RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_AdmNo,
 RES_ParRef->OEORI_Rowid,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_Rowid,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_Desc,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_Code,
 RES_ParRef->OEORI_DateExecuted,
 RES_ParRef->OEORI_TimeExecuted,
 RES_CTCP_DR->CTPCP_Desc,
 RES_ParRef->OEORI_LabEpisodeNo,
 RES_ParRef->OEORI_Priority_DR,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OnlyShowVerRes,
 RES_DICOM_SeriesInstanceUID,
 RES_DICOM_SOPInstanceUID,
 RES_DICOM_SeriesNumber,
 RES_ParRef->OEORI_SttTim,
 RES_ParRef->OEORI_SttDat,
 RES_DateVerified,
 RES_TimeVerified,
 RES_ParRef->OEORI_ItemStat_DR->OSTAT_Desc,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive,
 RES_UserVerified->SSUSR_Name,
 RES_UserCreated->SSUSR_Name,
 RES_ParRef->OEORI_Action_DR->ACT_Desc,
 RES_ParRef->OEORI_ResultComments,
 RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc,
 RES_NonSTDRepIssReason_DR,
 RES_ParRef->OEORI_Abnormal,
 RES_ParRef->OEORI_SeriesNo,
 RES_ParRef->OEORI_RefDoc_DR->REFD_Desc,
 RES_CPReported_DR->CTPCP_Desc,
 RES_CPVerified_DR->CTPCP_Desc
FROM OE_OrdResult
WHERE (RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
 AND (:catgsID [ (','_%INTERNAL(RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_','))
 AND ((RES_ParRef->OEORI_DateExecuted <= :dto) OR (:dto is NULL))
 AND ((RES_ParRef->OEORI_DateExecuted >= :dfrom) OR (:dfrom is NULL))	
ORDER BY RES_ParRef, RES_Type DESC, RES_DateCreated DESC, RES_TimeCreated DESC, RES_FileName DESC, RES_ChildSub DESC
}

/// KM 14-Mar-2001: This dicom stuff is not presently used but leave query here for the moment until we see what happens with it.
Query FindImage(orditm As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RESName:%String,RESFileName:%String")
{
SELECT RES_RowId, RES_Name, RES_FileName
FROM OE_OrdResult
WHERE (RES_Type = 'D') AND (RES_ParRef = :orditm)
}

Query FindPatUnreadRes(CURRLoc, CurrWard) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,PatientID,mradm,PAPMIEPRDescription:%String,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,PAPMINo:%String,PAADMAdmDate:%Date,PAADMAdmTime:%Time,CTLOCDesc:%String,Arrived:%String,PresComplt,MRDIADesc,PAADMAdmDocCodeDR,PAADMType,Ward:%String,Bed:%String,BookedWard:%String,BookedBed:%String,Hospital:%String,visstat:%String,refstatus:%String,medRecNo:%String,CurrWardDesc:%String,OERowID:%String,ARCItmMast:%String,RESType:%String,RESRowId:%String,RESDate:%String,OrdSttDate:%String,EpisodeNo:%String,PAPMIName4:%String,PAPMIName5:%String,PAPMIName6:%String,PAPMIName7:%String,PAPMIName8:%String")
{
}

Query FindPreviousRadResult(OEId As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RESFileName,RESRowId,RESNSRDR")
{
}

Query FindPreviousResult(OrderID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RESFileName,RESRowId,RESNSRDR")
{
}

/// Log 27725 - AI -  04-09-2002 :  Gets read result for a pateint episode.
/// 		Query called from method web.MRAdm.GotAnyResults.
/// 
Query FindReadWordResult(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CatDesc,OrderID:%String:""""")
{
SELECT distinct(RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc),RES_ParRef->OEORI_RowId
FROM SQLUser.OE_OrdResult
WHERE (RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
AND (RES_DateRead IS NOT NULL)
AND ((RES_ResStat_DR->RESST_Code='V') OR (RES_ResStat_DR->RESST_Code='P') OR (RES_ResStat_DR->RESST_Code='C'))
AND (RES_Type IS NOT NULL)
}

/// log 61886 TedT if type is "WAV" include "v" type result too
Query FindSavedFileName(OEId As %Library.String, type As %Library.String, RESRowId As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RESFileName,RESRowId,RESNSRDR")
{
SELECT	RES_FileName, RES_RowId, RES_NonSTDRepIssReason_DR
FROM	OE_OrdResult 
WHERE	(RES_ParRef = :OEId) 
AND		(RES_Type <> 'V' OR (%ALPHAUP :type='WAV'))
AND		((RES_RowId=:RESRowId) OR (:RESRowId IS NULL))
AND		((%ALPHAUP RES_FileName [ %ALPHAUP :type) OR ((%ALPHAUP :type='TXT') AND (RES_FileName IS NULL)) OR ((%ALPHAUP :type='RTF') AND (RES_FileName IS NULL)))
}

Query FindUnreadResults(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RESName")
{
SELECT RES_RowId, RES_Name
FROM OE_OrdResult
WHERE (RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) 
 AND (RES_DateRead IS NULL) 
 AND (RES_ResStat_DR->RESST_Code='V') 
 AND (RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code='F')
}

/// KM: 11May2001: Gets all unread results for ALL pateint episodes. 
/// Query called from method web.OEOrdResult.getUnReadResultsAll
/// 
Query FindUnreadResultsAll(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RESName")
{
SELECT RES_RowId, RES_Name
FROM OE_OrdResult
WHERE RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR =  :EpisodeID
 AND (RES_DateRead IS NULL) 
 AND ((RES_ResStat_DR->RESST_Code='V') OR (RES_ResStat_DR->RESST_Code='P') OR (RES_ResStat_DR->RESST_Code='C'))
 AND (RES_Type IS NOT NULL)
}

/// KM: 11May2001: Gets all unread results for ALL pateint episodes. 
/// Query called from method web.OEOrdResult.getUnReadResultsAll
/// 
Query FindUnreadWordResult(EpisodeID As %String, CanViewSensitive) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CatDesc,OrderID:%String:""""")
{
SELECT distinct(RES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc),RES_ParRef->OEORI_RowId
FROM SQLUser.OE_OrdResult
WHERE RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR =  :EpisodeID
AND (RES_DateRead IS NULL) 
AND ((((RES_ResStat_DR->RESST_Code='V') OR (RES_ResStat_DR->RESST_Code='P') OR (RES_ResStat_DR->RESST_Code='C'))
AND (RES_Type IS NOT NULL))
OR (RES_Type ='D'))
AND (((RES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive='Y') AND (:CanViewSensitive='Y')) 
OR ((RES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive='N') OR ((RES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive IS NULL))))
}

/// Find id's associated with a particular word reults document
Query FindbyVoiceFile(FileName As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,counter")
{
Select RES_ParRef,COUNT(RES_ParRef)
FROM OE_OrdResult
WHERE RES_FileName= :FileName
}

Query FindRadiologyStatus() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Desc:%String")
{
SELECT Code,Description
FROM websys.StandardTypeItem
WHERE ParRef='RadiologyOrderStatus'
ORDER BY Description
}

/// Find id's associated with a particular word reults document
Query FindbyWordDoc(FileName As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String")
{
Select RES_RowId
FROM OE_OrdResult
WHERE RES_FileName= :FileName
}

/// log 60189 TedT Find voice file
Query FindVoiceFile(OrderId As %String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "resid:%String,filename:%String")
{
Select RES_RowId, RES_FileName	
From OE_OrdResult
Where RES_ParRef=:OrderId
And RES_Type='V'
Order By RES_FileName desc
}

}
