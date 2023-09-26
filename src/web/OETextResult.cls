Class web.OETextResult Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 644;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TR_RowId";

Parameter SQLDESCRIPTION = "TR_RowId";

Parameter SQLROWID = "TR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Used by OEOrdItem.TabularTextResultsEMR component to return some order details
ClassMethod GetOrderItemDetails(OrderID As %Library.String) As %Library.String
{
}

ClassMethod GetTranscriptionist(OETextID As %Library.String = "", OEOrdItemID As %Library.String = "") As %Library.String
{
}

ClassMethod GetPatientID(ID As %Library.String)
{
}

/// Log 61269 - AI - 07-12-2006 : Get all OEORI_DateExecuted values for the given OEORI_RowIDs.
ClassMethod GetDatesExecuted(OEORIROWIDs As %Library.String = "") As %Library.String
{
}

/// Log 61269 - AI - 13-12-2006 : Get the first RES_DateCreated value for each of the given OEORI_RowIDs.
ClassMethod GetDatesReported(OEORIROWIDs As %Library.String = "") As %Library.String
{
}

/// Log 61269 - AI - 02-01-2007 : Get the OEORI_ConsultDr_DR value for each of the given OEORI_RowIDs.
ClassMethod GetPreferredRadiologists(OEORIROWIDs As %Library.String = "") As %Library.String
{
}

/// Log 61269 - AI - 07-12-2006 : Get all OEORI_LabEpisodeNo values for the given OEORI_RowIDs.
ClassMethod GetVisitNumbers(OEORIROWIDs As %Library.String = "") As %Library.String
{
}

ClassMethod GetTextResult(ResultID As %Library.String = "") As %Library.String
{
}

ClassMethod GetTranscribeTextSections(id As %Library.String = "") As %Library.Status
{
}

/// Log 38063 - AI - 18-11-2004 : Called from webOEOrdItem.RadWorkBenchFetch and web.OEOrdResult.GetRadiologyStatus.
///   Returns the LATEST Text Result ID of the Order Item.
///     -> Assumes an Order Item really should only have one Text Result that gets updated over and over ...
ClassMethod GetTextResultIDFromOrderID(OEOrdItemID As %Library.String = "") As %Library.String
{
}

/// Log 62601 - AI - 26-02-2006 : New Method created.
/// Calculates and sets the "parent" orderitem records' resultstatus flag (can be multiple records)
/// Called from the websysSaveTranscribeText method of this class.
ClassMethod SetParentResultStatus(trid As %Library.String = "")
{
}

/// Log 38063 - AI - 01-11-2004 : Before saving the Transcribe Text screen (OETextResult.Edit), check that the details are all valid.
ClassMethod websysBeforeSaveTranscribeText(compref As %Library.String, id As %String = "") As %Boolean
{
}

/// Log 38063 - AI - 01-11-2004 : Save the Transcribe Text screen (OETextResult.Edit) details.
ClassMethod websysSaveTranscribeText(compref As %String = "", id As %String = "", SaveOnlyFlag As %Library.Boolean = 0)
{
}

/// Log 27725 - AI - 04-09-2002 :  Gets read result for a patient episode.
/// 		Query called from method web.MRAdm.GotAnyResults.
Query FindReadTextResultCat(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CatDesc,ResultID:%String:"""",OrderID:%String:"""",ResultStatus:%String")
{
SELECT	distinct(TRES_ParRef->OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc),
	TRES_OETR_DR->TR_RowId,
	TRES_ParRef->OEORI_RowId,
	TRES_OETR_DR->TR_RESStat_DR->RESST_Code
FROM	SQLUser.OE_OrdTextResult
WHERE	(TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
AND	(TRES_OETR_DR->TR_DateRead IS NOT NULL)
AND	((TRES_OETR_DR->TR_RESStat_DR->RESST_Code='V')
OR	(TRES_OETR_DR->TR_RESStat_DR->RESST_Code='P')
OR	(TRES_OETR_DR->TR_RESStat_DR->RESST_Code='C')
OR	(TRES_OETR_DR->TR_RESStat_DR->RESST_Code='E'))
}

/// KM 14May2001:  Gets all unread results for ALL pateint episodes. 
/// Query called from method web.OEOrdItem.FindUnreadResultsAll
Query FindUnReadTextResultCat(EpisodeID As %String, CanViewSensitive) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CatDesc,DateRead,ResultID:%String,OrderID:%String,ResultStatus:%String")
{
SELECT	distinct(TRES_ParRef-> OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc),
TRES_OETR_DR->TR_DateRead,TRES_OETR_DR->TR_RowId,TRES_ParRef->OEORI_RowId,
TRES_OETR_DR->TR_RESStat_DR->RESST_Code
FROM	SQLUser.OE_OrdTextResult
WHERE	TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR =  :EpisodeID
AND	(TRES_OETR_DR->TR_DateRead IS NULL) 
AND	((TRES_OETR_DR->TR_RESStat_DR->RESST_Code='V') 
OR	(TRES_OETR_DR->TR_RESStat_DR->RESST_Code='P')
OR	(TRES_OETR_DR->TR_RESStat_DR->RESST_Code='C')
OR	(TRES_OETR_DR->TR_RESStat_DR->RESST_Code='E'))	
AND	(((TRES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive='Y') AND (:CanViewSensitive='Y')) 
OR	((TRES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive='N') OR ((TRES_ParRef->OEORI_ItmMast_DR->ARCIM_Sensitive IS NULL))))
}

}
