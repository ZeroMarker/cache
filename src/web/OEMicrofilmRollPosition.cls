Class web.OEMicrofilmRollPosition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 363;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "POS_RowId";

Parameter SQLDESCRIPTION = "POS_Position";

Parameter SQLROWID = "POS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod CheckDupPosBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", OEMFRollID As %Library.String = "", Pos As %Library.String = "", HospitalDR As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetRollPosComment(POSRowId As %Library.String) As %Library.String
{
}

ClassMethod GetRollPosNumber(POSRowId As %Library.String) As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod URValidateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", MRNo As %Library.String = "", HospitalDR As %Library.String = "", PatientID As %Library.String = "", MRT As %Library.String = "") As %Library.Boolean
{
}

ClassMethod websysDeleteRollPosition(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysSaveRollPosition(compref As %Library.String, id As %Library.String)
{
}

Query Find(OEMFRollID, HospitalDR) As %SQLQuery(CONTAINID = 0, ROWSPEC = "POSPosition,RTMASMRNo,SURName,GIVName,Name3,Name4,Name5,Name6,Name7,Name8,DOB,DateEntered,TimeEntered,Comment,PatientID,MRType,RegNo,OEMFRollDesc,RollNo,PosRowID,POSRTMASDR,RollRowID,RollHosp")
{
Select POS_Position, POS_RTMAS_DR->RTMAS_MRNo, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name2, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name3, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name4, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name5, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name6, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name7, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name8, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_DOB, POS_DateEntered, POS_TimeEntered, POS_Comment, POS_RTMAS_DR->RTMAS_PatNo_DR, POS_MRecordType_DR->TYP_Desc,POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_No,OEMF_RollDesc,OEMF_RollID,POS_RowId,POS_RTMAS_DR,OEMF_RowId,OEMF_Hospital_DR
From SQLUser.OE_MicrofilmRoll, SQLUser.OE_MicrofilmRollPosition
Where ((OEMF_Hospital_DR->HOSP_RowId=:HospitalDR) OR (:HospitalDR IS NULL))
And OEMF_RollID=:OEMFRollID
And POS_ParRef=OEMF_RowId
ORDER BY OEMF_RollID,POS_Position
}

/// Find all Rolls and positions associated with That patient in Login Hospital.
Query FindByPat(PatientID As %Library.String, HospitalDR As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "POSRowId,POSPosition,OEMFRowId,RollDesc,RollID,RTMASMRNo,DateEntered,TimeEntered,Comment,PatientID,MRType,SURName,GIVName,OTHName,OTHName1,OTHName2,OTHName3,OTHName4,OTHName5,DOB,POSRTMASDR,POSLastUpdateUserName,POSLastUpdateUserID,POSLastUpdateUserHosp")
{
Select POS_RowId,POS_Position,OEMF_RowId,OEMF_RollDesc,OEMF_RollID, POS_RTMAS_DR->RTMAS_MRNo, POS_DateEntered, POS_TimeEntered, POS_Comment, POS_RTMAS_DR->RTMAS_PatNo_DR,POS_MRecordType_DR->TYP_Desc,POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name2, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name3, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name4, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name5, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name6, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name7, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name8, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_DOB,POS_RTMAS_DR, POS_LastUpdateUser_DR->SSUSR_Name, POS_LastUpdateUser_DR->SSUSR_Initials, POS_LastUpdateHospital_DR->HOSP_Desc
From SQLUser.OE_MicrofilmRoll, SQLUser.OE_MicrofilmRollPosition
Where ((OEMF_Hospital_DR->HOSP_RowId=:HospitalDR) OR (:HospitalDR IS NULL))
AND POS_RTMAS_DR->RTMAS_PatNo_DR=:PatientID
AND POS_ParRef=OEMF_RowId
ORDER BY OEMF_RollID,POS_Position
}

/// Find all Rolls and positions associated with That patient in Login Hospital.
Query zzFindByPat(PatientID As %Library.String, HospitalDR As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "POSPosition,RTMASMRNo,SURName,GIVName,DOB,DateEntered,TimeEntered,Comment,PatientID,MRType,RegNo,OEMFRollDesc,RollNo,PosRowID,POSRTMASDR,RollRowID")
{
Select POS_Position, POS_RTMAS_DR->RTMAS_MRNo, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_Name2, POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_DOB, POS_DateEntered, POS_TimeEntered, POS_Comment, POS_RTMAS_DR->RTMAS_PatNo_DR, POS_RTMAS_DR->RTMAS_MRType_DR->TYP_Desc,POS_RTMAS_DR->RTMAS_PatNo_DR->PAPMI_No,OEMF_RollDesc,OEMF_RollID,POS_RowId,POS_RTMAS_DR,OEMF_RowId
From SQLUser.OE_MicrofilmRoll, SQLUser.OE_MicrofilmRollPosition
Where ((OEMF_Hospital_DR->HOSP_RowId=:HospitalDR) OR (:HospitalDR IS NULL))
AND POS_RTMAS_DR->RTMAS_PatNo_DR=:PatientID
AND POS_ParRef=OEMF_RowId
ORDER BY OEMF_RollID,POS_Position
}

}
