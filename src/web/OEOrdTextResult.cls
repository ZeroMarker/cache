Include webimport

IncludeGenerator webimport

Class web.OEOrdTextResult Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 198;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRES_RowId";

Parameter SQLDESCRIPTION = "TRES_RowId";

Parameter SQLROWID = "TRES_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod getUnReadResultsAll(EpisodeIDs As %Library.String) As %Library.String
{
}

Query FindByMRAdm(mradm As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "TRName:%String,TRDateCreated:%Date,TRTimeCreated:%Time,TRTDesc:%String")
{
SELECT TRES_OETR_DR->TR_Name, TRES_OETR_DR->TR_DateCreated, TRES_OETR_DR->TR_TimeCreated, TRES_OETR_DR->TR_TextResultType_DR->TRT_Desc
FROM SQLUser.OE_OrdTextResult
WHERE TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_MainMRADM_DR = :mradm
}

/// KM 14-Mar-2001: Called for creating EPR Results Profile Lists
/// 
/// KM 25-Jul-2001: SQL Query Changed From:
/// SELECT	TRES_Rowid, TRES_OETR_DR->TR_Name, 
/// TRES_OETR_DR->TR_DateCreated, 
/// TRES_OETR_DR->TR_TimeCreated, 
/// TRES_OETR_DR->TR_TextResultType_DR->TRT_Desc, 
/// TRES_OETR_DR->TR_ResStat_DR->RESST_Desc,
/// TRES_OETR_DR->TR_ResStat_DR->RESST_Code,
/// TRES_OETR_DR->TR_Rowid,
/// TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_ADMNo
/// FROM	SQLUser.OE_OrdTextResult
/// WHERE	TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR=:PatientID
/// 	AND ((TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) OR :EpisodeID is NULL)
/// 	AND (:catgsID [ (","_%INTERNAL(TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_",") 
/// 	AND TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR is NOT NULL) 
/// 	AND ((TRES_OETR_DR->TR_DateCreated >= :dfrom) OR :dfrom is NULL)
/// 	AND ((TRES_OETR_DR->TR_DateCreated <= :dto) OR :dto is NULL)
/// 
/// Log 26096 - AI - 16-07-2002 : Added the following to get the value of the
/// order subcategory's "Only Show Verified Results" flag.
/// TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OnlyShowVerRes
/// 
/// Log 30564 - AI - 07-02-2003 : Add single line to get the Order Category:
/// TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc
/// and add this to the Row Specification.
/// 
Query FindForResultsProfile(EpisodeID As %Library.String, catgsID As %Library.String, dfrom As %Library.Date, dto As %Library.Date) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,TRName:%String,TRDateCreated:%Date,TRTimeCreated:%Time,TRTDesc:%String,RESSTDesc:%String,RESSTCode:%String,RESRowid:%String,EpisodeNo:%String,OEORIDateExecuted:%Date,CareProv:%String,OEORILabEpisodeNo:%String,OEORIRowid:%String,ARCIMRowid:%String,ARCIMDesc:%String,ARCICOnlyShowVerRes:%String,OEORIPriorityDR:%String,OEORISttTim,OEORISttDat,TRDateVerified,TRTimeVerified,OSTATDesc,ResultSensitive,TRUserVerified,TRUserCreated,OEORIFillerNo,OEORITimeExecuted,RESAction,RESComments,ExternalResultStatus:%Library.String,OrderCategory:%String,OEORISeriesNo,REFDDesc")
{
SELECT TRES_Rowid,
 TRES_OETR_DR->TR_Name,
 TRES_OETR_DR->TR_DateCreated,
 TRES_OETR_DR->TR_TimeCreated,
 TRES_OETR_DR->TR_TextResultType_DR->TRT_Desc, 
 TRES_OETR_DR->TR_ResStat_DR->RESST_Desc,
 TRES_OETR_DR->TR_ResStat_DR->RESST_Code,
 TRES_OETR_DR->TR_Rowid,
 TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_ADMNo,
 TRES_ParRef->OEORI_DateExecuted,
 TRES_OETR_DR->TR_CTCP_DR->CTPCP_Desc,
 TRES_ParRef->OEORI_LabEpisodeNo,
 TRES_ParRef->OEORI_Rowid,
 TRES_ParRef->OEORI_ItmMast_DR->ARCIM_Rowid,
 TRES_ParRef->OEORI_ItmMast_DR->ARCIM_Desc,
 TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OnlyShowVerRes,
 TRES_ParRef->OEORI_Priority_DR,
 TRES_ParRef->OEORI_SttTim,
 TRES_ParRef->OEORI_SttDat,
 TRES_OETR_DR->TR_DateVerified,
 TRES_OETR_DR->TR_TimeVerified,
 TRES_ParRef->OEORI_ItemStat_DR->OStat_Desc,
 TRES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive,
 TRES_OETR_DR->TR_UserVerified->SSUSR_Name,
 TRES_OETR_DR->TR_UserCreated->SSUSR_Name,
 TRES_ParRef->OEORI_FillerNo,
 TRES_ParRef->OEORI_TimeExecuted,
 TRES_OETR_DR->TR_Action_DR->Act_Desc,
 TRES_OETR_DR->TR_ResultComments,
 TRES_OETR_DR->TR_ExternalResultStatus,
 TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc,
 TRES_ParRef->OEORI_SeriesNo,
 TRES_ParRef->OEORI_RefDoc_DR->REFD_Desc
FROM SQLUser.OE_OrdTextResult
WHERE (TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
 AND (:catgsID [ (','_%INTERNAL(TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_','))
 AND ((TRES_ParRef->OEORI_DateExecuted <= :dto) OR (:dto = NULL))
 AND ((TRES_ParRef->OEORI_DateExecuted >= :dfrom) OR (:dfrom = NULL))
}

Query FindUnreadResults(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,TRName")
{
SELECT TRES_Rowid,  TRES_OETR_DR->TR_Name
FROM OE_ORDTextResult
WHERE (TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) 
 AND (TRES_OETR_DR->TR_DateRead IS NULL) 
 AND (TRES_OETR_DR->TR_ResStat_DR->RESST_Desc='V') 
 AND (TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code='F')
}

/// KM: 11May2001: Gets all unread results for ALL pateint episodes. 
/// Query called from method web.OEOrdTextResult.FindUnreadResultsAll
/// 
Query FindUnreadResultsAll(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "RowId,TResDesc")
{
SELECT TRES_Rowid,  TRES_OETR_DR->TR_Name
FROM OE_ORDTextResult
WHERE TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR =  :EpisodeID
AND     (TRES_OETR_DR->TR_DateRead IS NULL) 
AND     ((TRES_OETR_DR->TR_RESStat_DR->RESST_Code='V') 
OR      (TRES_OETR_DR->TR_RESStat_DR->RESST_Code='P')
OR      (TRES_OETR_DR->TR_RESStat_DR->RESST_Code='C'))
}

Query List(OEItemID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,TRESOETRDR")
{
SELECT  TRES_Rowid,TRES_OETR_DR
FROM SQLUser.OE_OrdTextResult,SQLUser.OE_TextResultSection
WHERE OE_TextResultSection.SEC_ParRef = OE_OrdTextResult.TRES_OETR_DR
AND OE_OrdTextResult.TRES_ParRef = :OEItemID
}

}
