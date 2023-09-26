Class web.PAAlertMsg Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 328;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ALM_RowId";

Parameter SQLDESCRIPTION = "ALM_RowId";

Parameter SQLROWID = "ALM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// CJB 15/09/2003 39075 - validate dates
ClassMethod CheckDates(compref As %String, id As %String)
{
}

ClassMethod DisplayAlertIcon(PatientID As %Library.String) As %Library.String
{
	Q ""
}

/// gets rowid of first alertmsg against the PatientID passed in
/// screens for first active alertmsg
ClassMethod GetFirstRecord(PatientID As %Library.String) As %Library.Boolean
{
}

ClassMethod GetUserHospital(val As %Library.String) As %Library.String
{
}

ClassMethod GetUserRole(val As %Library.String) As %Library.String
{
}

ClassMethod GotActiveAlerts(PatientID As %String = "") As %Boolean
{
}

/// ab 28.08.03 - 37488 returns if patient has any alerts to be confirmed
ClassMethod GotTBCAlerts(PatientID As %String = "") As %String
{
}

/// Called by the web broker.
/// 
/// TN.
/// This is not the normal broker method!!!
/// This is used on textarea's to replace a certain code with it's description.
/// 
ClassMethod LookUpBrokerReplaceCode(code As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCodeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByCodeFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCodeExecute(ByRef QHandle As %Library.Binary, code As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCodeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByCodeExecute ]
{
}

ClassMethod websysSaveHist() As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Query FindAlertsToReview(PatientID As %Library.String, date As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "id")
{
SELECT ALM_RowId
FROM SQLUser.PA_AlertMsg
WHERE (ALM_PAPMI_ParRef = :PatientID)
AND (ALM_ReviewDate <= :date)
AND ((ALM_ExpiryDate > :date) OR (ALM_ExpiryDate IS NULL))
AND 	(ALM_ClosedFlag='N')
}

/// Log 39749 - AI - 09-10-2003 : Replaced User Role due to new requirements - Get the Role from Staff Type codetable instead of Care Provider Type.
/// 			replaced ALM_CreateUser->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_Desc with ALM_ViewUserId->SSUSR_StaffType_DR->STAFF_Desc
/// 			replaced Query ROWSPEC "CTCPTDesc" with "UpdateUserRole"
/// 			- same with CreateUserRole
Query FindClosedAlerts(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId,ClosedFlag,CreateDate,CreateTime,ExpiryDate,Message,PAPMIParRef,ViewDate,ViewTime,CreateUserName,ViewUserName,ALERTDesc,ReviewDate,AlertCategoryDR,ALERTCATDesc,UpdateUserRole,HOSPDesc,OnsetDate,ClosedDate,ClosedTime,CreateUserRole,LastUpdateHosp,AlertStatus,ExternalID:%String,LastUpdateUserID,ALMDSReportFlag")
{
SELECT ALM_RowId, ALM_ClosedFlag, ALM_CreateDate, ALM_CreateTime,ALM_ExpiryDate, ALM_Message, ALM_PAPMI_ParRef, ALM_ViewDate, ALM_ViewTime, ALM_CreateUser->SSUSR_Name, ALM_ViewUserId->SSUSR_Name, ALM_Alert_DR->ALERT_Desc, ALM_ReviewDate, ALM_Alert_DR->ALERT_AlertCategory_DR,ALM_AlertCategory_DR->ALERTCAT_Desc,
ALM_ViewUserId->SSUSR_StaffType_DR->STAFF_Desc, ALM_ViewUserId->SSUSR_DefaultDept_DR->CTLOC_Hospital_DR->HOSP_Desc, ALM_OnsetDate, ALM_ClosedDate, ALM_ClosedTime,
ALM_CreateUser->SSUSR_StaffType_DR->STAFF_Desc, ALM_LastUpdateHospital_DR->HOSP_Desc, ALM_Status, ALM_ExternalID, ALM_ViewUserId->SSUSR_Initials,ALM_DSReportFlag
FROM SQLUser.PA_AlertMsg
WHERE ((ALM_PAPMI_ParRef=:PatientID) AND (ALM_ClosedFlag='Y'))
ORDER BY  ALM_ClosedDate,ALM_ClosedTime Desc
}

/// Log 39749 - AI - 09-10-2003 : Replaced User Role due to new requirements - Get the Role from Staff Type codetable instead of Care Provider Type.
/// 			replaced ALM_CreateUser->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_Desc with ALM_ViewUserId->SSUSR_StaffTypeDR->STAFF_Desc
/// 			replaced Query ROWSPEC "CTCPTDesc" with "UpdateUserRole"
/// 			- same with CreateUserRole
Query FindOpenAlerts(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId,ClosedFlag,CreateDate,CreateTime,ExpiryDate,Message,PAPMIParRef,ViewDate,ViewTime,CreateUserName,ViewUserName,ALERTDesc,ReviewDate,AlertCategoryDR,ALERTCATDesc,UpdateUserRole,HOSPDesc,OnsetDate,CreateUserRole,LastUpdateHosp,AlertStatus,ExternalID:%String,LastUpdateUserID,ALMDSReportFlag")
{
SELECT ALM_RowId, ALM_ClosedFlag, ALM_CreateDate, ALM_CreateTime, ALM_ExpiryDate, ALM_Message, ALM_PAPMI_ParRef, ALM_ViewDate, ALM_ViewTime, ALM_CreateUser->SSUSR_Name, ALM_ViewUserId->SSUSR_Name, ALM_Alert_DR->ALERT_Desc, ALM_ReviewDate, ALM_Alert_DR->ALERT_AlertCategory_DR, ALM_AlertCategory_DR->ALERTCAT_Desc,
ALM_ViewUserId->SSUSR_StaffType_DR->STAFF_Desc, ALM_ViewUserId->SSUSR_DefaultDept_DR->CTLOC_Hospital_DR->HOSP_Desc, ALM_OnsetDate,
ALM_CreateUser->SSUSR_StaffType_DR->STAFF_Desc, ALM_LastUpdateHospital_DR->HOSP_Desc, ALM_Status, ALM_ExternalID, ALM_ViewUserId->SSUSR_Initials,ALM_DSReportFlag
FROM SQLUser.PA_AlertMsg
WHERE ((ALM_PAPMI_ParRef=:PatientID) AND ((ALM_ClosedFlag='N')OR (ALM_ClosedFlag IS NULL)))
ORDER BY  ALM_AlertCategory_DR->ALERTCAT_Desc, ALM_ViewDate,ALM_ViewTime
}

/// Log 55973 - PC - 02-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpByCode(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

/// Log 58610 - GC - 26/04/2006 : Save the DS Report Flag.
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

/// cjb 09/10/2006 36197
ClassMethod GetImages(PatientID As %Library.String, ByRef imgLIST As %Library.String)
{
}

}
