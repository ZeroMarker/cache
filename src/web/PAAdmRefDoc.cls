Class web.PAAdmRefDoc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

Parameter SQLCODE = "REFD_RowId";

Parameter SQLDATEFROM = "REFD_DateFrom";

Parameter SQLDATETO = "REFD_DateTo";

Parameter SQLDESCRIPTION = "REFD_RowId";

Parameter SQLROWID = "REFD_RowId";

/// ab 20.03.02
/// returns details for paadmrefdoc.list
Query GetByEpisodeID(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,REFDDesc:%String,CLNCode:%String,CLNAddress1:%String,CLNAddress2:%String,CTCITDesc:%String,REFDDateFrom:%Library.Date,REFDDateTo:%Library.Date,REFDConsent,REFDType:%Library.String")
{
SELECT REFD_RowId,REFD_RefDoc_DR->REFD_Desc,REFD_RefDocClinic_DR->CLN_Code,
 	REFD_RefDocClinic_DR->CLN_Address1,REFD_RefDocClinic_DR->CLN_Address2,REFD_RefDocClinic_DR->CLN_City_DR->CTCIT_Desc,
 	REFD_DateFrom,REFD_DateTo,REFD_Consent,REFD_RefDoc_DR->REFD_Type
FROM SQLUser.PA_AdmRefDoc
WHERE REFD_ParRef = :EpisodeID
ORDER BY	REFD_DateFrom DESC
}

}
