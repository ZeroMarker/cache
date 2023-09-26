Class web.PATempAddress Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 426;

Parameter SQLCODE = "ADDR_RowId";

Parameter SQLDATEFROM = "ADDR_DateFrom";

Parameter SQLDESCRIPTION = "ADDR_RowId";

Parameter SQLDATETO = "ADDR_DateTo";

Parameter SQLROWID = "ADDR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckAddrOverlap(compref As %Library.String, ToPID As %Library.String, FromPID As %Library.String) As %Library.String
{
}

/// LOG 23871 BC 8-4-2002:  This routine checks the temporary addresses of a patient (the TOPatientId) to see
///  if there is one corresponding to the merged patient(the FROMPatient) and then removes the temporary
///  address after the unmerging of the patients.
/// 
/// Called by UnMergePatient in PAPerson
ClassMethod RemoveTempAddress(TOPatientId As %Library.String, FROMPatientId As %Library.String)
{
}

/// HP 3/4/02 Log23866: Method modified from JW original. 
/// Add new DateFrom to DateTo of row of the same address type where new DateFrom 
/// is greater than or equal to previous row's DateFrom.
ClassMethod endDateLastAddress(compref As %Library.String, ByRef id As %Library.String, ADDRID As %Library.String, ADDRTYPE As %Library.String, newdfrom As %Library.String)
{
}

/// KM 8-Oct-2001: Initialise variables before calling websysSave
ClassMethod insertAddress(compref As %Library.String, PARREF As %Library.String, Street As %Library.List, Street2 As %Library.String, ProvinceDR As %Library.String, CityDR As %Library.String, ZipDR As %Library.String, DateFrom As %Library.String, DateTo As %Library.String = "")
{
}

/// HP 19.04.02 - Log 23688 Modified from AB original in PAFamilyDoctor
/// before save, validates date from and date to fields, cancels save if overlap with existing dates, 
/// or invalid date range
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String, newdfrom As %Library.String, newdto As %Library.String, ADDRID As %Library.String, ADDRTYPE As %Library.String) As %Boolean
{
}

/// HP 3/4/02 Log 23866: Save method modified from JW original in PATrafficAccidentContact class, 
/// used for updating the database for Components of type Edit.
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

Query FindDates(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "fdate,tdate,type")
{
SELECT ADDR_DateFrom,ADDR_DateTo,ADDR_AddressType_DR
FROM SQLUser.PA_TempAddress
Where ADDR_ParRef=:PatientID
}

Query FindDatesByType(PatientID As %Library.String, Type As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "fdate,tdate,type")
{
SELECT ADDR_DateFrom,ADDR_DateTo,ADDR_AddressType_DR
FROM SQLUser.PA_TempAddress
Where ADDR_ParRef=:PatientID
and ADDR_AddressType_DR=:Type
}

/// PAADM_DepCode_DR->CTLOC_Desc, 
/// PAADM_AdmDocCodeDR->CTPCP_Desc, 
/// PAADM_Appoint_DR->APPT_RBCServ_DR->SER_Desc,
/// PAADM_PAPMI_DR,PAADM_PAPMI_DR->PAPMI_EPRDescription,
/// PAADM_VisitStatus,PAADM_Type,PAADM_DepCode_DR->CTLOC_Dep_DR->DEP_Desc
/// 
Query temp(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID, Flag, CreateDate, CreateTime, Message, ParRef, ViewDate, ViewTime, CreateUser, ViewUser, Alert")
{
SELECT ALM_RowId, ALM_ClosedFlag, ALM_CreateDate, ALM_CreateTime, ALM_Message, ALM_PAPMI_ParRef, ALM_ViewDate, ALM_ViewTime, ALM_CreateUser->SSUSR_Name, ALM_ViewUserId->SSUSR_Name,
ALM_Alert_DR->ALERT_Desc
FROM SQLUser.PA_AlertMsg
WHERE (ALM_PAPMI_ParRef=:PatientID)
}

}
