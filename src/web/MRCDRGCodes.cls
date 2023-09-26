Include webimport

IncludeGenerator webimport

Class web.MRCDRGCodes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 103;

Parameter SQLDATEFROM = "DRG_DateFrom";

Parameter SQLDATETO = "DRG_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "DRG_Code";

Parameter SQLDESCRIPTION = "DRG_Desc";

Parameter SQLROWID = "DRG_RowID";

/// KK 16/May/2003 Log 34531 To get DRG - This method is called from PAAdm.ChangeStatus screen
ClassMethod GetDRGCode(EpisodeID As %Library.String = "") As %Library.String
{
	n objAdm,code
	Q:EpisodeID="" ""
	s code=""
	s objAdm=##class(User.PAAdm).%OpenId(EpisodeID)
	if $ISObject(objAdm) {
		if $ISObject(objAdm.PAADMMainMRADMDR) {
			if $ISObject(objAdm.PAADMMainMRADMDR.MRADMDRGDR){
				s code=objAdm.PAADMMainMRADMDR.MRADMDRGDR.DRGCode
			}
		}
	}
	Q code
}

ClassMethod LookUpByCodeBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String = "") As %Library.Boolean
{
}

/// KK 13/Mar/2003 Log 28512 - LookUpBroker Implemented - Used in WIESInquiry.Custom component
ClassMethod LookUpCodeByVersionBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String = "", ver As %Library.String = "") As %Library.Boolean
{
}

/// /KK 12/Aug/2004 L:45156
ClassMethod UpdateToVicDRG(DRG As %String = "", mradm As %String = "")
{
}

/// KK 08/Oct/2002 Log 28357 Lookup for DRGCode and Description, Sort by DRG_Code
Query LookUpByCode(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "DRGCode:%String,DRGDesc:%String,HIDDEN:%String")
{
SELECT	DRG_Code, DRG_Desc, DRG_RowId 
FROM	SQLUser.MRC_DRGCodes
WHERE	(((%UPPER DRG_Code %STARTSWITH %UPPER :desc) OR (%UPPER DRG_Desc %STARTSWITH %UPPER :desc) OR (:desc IS NULL))
AND	(DRG_Code IS NOT NULL))
ORDER	BY DRG_Code
}

/// KK 08/Oct/2002 Log 28512 Lookup for DRGCode and Description by DRG Version
Query LookUpCodeByVersion(code, ver) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "DRGCode:%String,DRGDesc:%String,HIDDEN:%String")
{
SELECT VER_ParRef->DRG_Code, VER_ParRef->DRG_Desc, Ver_RowId 
FROM SQLUser.MRC_DRGCodesVersion
WHERE ((VER_Version_DR->DRGVER_Desc=:ver) OR (VER_Version_DR IS NULL))
AND (%UPPER VER_ParRef->DRG_Code [ %UPPER :code)
}

}
