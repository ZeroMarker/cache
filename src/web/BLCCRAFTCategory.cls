Class web.BLCCRAFTCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetBLCCategoryDetails(CRAFTCategory As %Library.String = "")
{
}

/// SA: log 24622 -> Used for implementation of CRAFT Inquiry screen.
ClassMethod LookUpActiveInquiryBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpCategoryByVersionBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", verdesc As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpCategoryByVersionClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCategoryByVersionFetch ]
{
}

ClassMethod LookUpCategoryByVersionExecute(ByRef QHandle As %Library.Binary, catdesc As %Library.String, verdesc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpCategoryByVersionFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCategoryByVersionExecute ]
{
}

Parameter SQLCODE = "CRAFTC_Code";

Parameter SQLDATEFROM = "CRAFTC_DateFrom";

Parameter SQLDATETO = "CRAFTC_DateTo";

Parameter SQLDESCRIPTION = "CRAFTC_RowId";

Parameter SQLROWID = "CRAFTC_RowId";

/// TP 26-Nov-2001: Created this LookUp so that you can  now filter on Location Type. 
/// LocType should be passed in as a Menu Value Expression, eg for a Wards lookup:
/// "&LocType=W" 
/// (done for LookUp on webcommon.DateFromTo.Custom)
/// 
/// KM 8-Jan-2002: Added active date clauses
Query LookUpActiveInquiry(val As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc,hidden,code,hidden,hidden,hidden,hidden,hidden,hidden,hidden,hidden")
{
SELECT CRAFTC_Desc, CRAFTC_RowId, CRAFTC_Code, 
 CRAFTC_LowInlierBoundary, CRAFTC_HighInlierBoundary, 
 CRAFTC_DHS_AverageLOS, CRAFTC_SameDayWeight, 
 CRAFTC_ShortStayWeight, CRAFTC_LowOutlierPerDiem, 
 CRAFTC_InlierWeight, CRAFTC_HighOutlierPerDiem
FROM SQLUser.BLC_CRAFTCategory
WHERE ((%UPPER CRAFTC_Desc %STARTSWITH %UPPER :val) OR (%UPPER CRAFTC_Code %STARTSWITH %UPPER :val))
AND (CRAFTC_DateFrom <= CURRENT_DATE) 
AND ((CRAFTC_DateTo IS NULL) OR (CRAFTC_DateTo >= CURRENT_DATE))
ORDER BY CRAFTC_Desc
}

Query LookUpCategoryByVersion(val As %Library.String, verdesc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc,hidden,code,hidden,hidden,hidden,hidden,hidden,hidden,hidden,hidden")
{
}

}
