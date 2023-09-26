Class web.RTCMRecordType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 227;

Parameter SQLDATEFROM = "TYP_DateFrom";

Parameter SQLDATETO = "TYP_DateTo";

Parameter SQLCODE = "TYP_Code";

Parameter SQLDESCRIPTION = "TYP_Desc";

Parameter SQLROWID = "TYP_RowId";

/// cjb 19/01//2004 41250 Get the MRTyps from the logon location
ClassMethod GetTypeFromLocation(Location As %Library.String = "") As %Library.String
{
}

/// SA 28.9.01: Called by RTVolume.Edit.CSP to set the existing Master MR Types and corresponding Volumes.
ClassMethod GetMRHomeLoc(MRType As %Library.String = "") As %Library.String
{
}

/// SA 28.9.01: Called by RTVolume.Edit.CSP to set the existing Master MR Types and corresponding Volumes.
ClassMethod GetPatientTypeVol(PatientID As %Library.String = "", MRType As %Library.String = "") As %Library.String
{
}

ClassMethod GetURN(PatientID As %String, MRRowID As %String) As %String
{
}

ClassMethod LookUpBrokerMRType(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String = "", PatID As %Library.String = "", HospID As %Library.String = "", CrtTempVol As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpMRTypeDateBroker(itmjs As %Library.String, itmjsex As %Library.String, input As %Library.String = "", HospID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpMRTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpMRTypeFetch ]
{
}

ClassMethod LookUpMRTypeExecute(ByRef QHandle As %Library.Binary, desc As %String, PatID As %Library.String = "", HospID As %Library.String = "", CrtTempVol As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpMRTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpMRTypeExecute ]
{
}

Query LookUpMRType(desc As %Library.String, PatID, HospID, CrtTempVol) As %Library.Query(CONTAINID = 2, ROWSPEC = "MRDesc:%String,MRCode:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpMRTypeDate(desc As %String, HospID As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "desc,HIDDEN,code")
{
	SELECT TYP_Desc,TYP_Rowid,TYP_Code
	FROM SQLUser.RTC_MRecordType
	WHERE ((%ALPHAUP TYP_Desc  %STARTSWITH  %ALPHAUP :desc) OR (%ALPHAUP TYP_Code = %ALPHAUP :desc) OR (:desc IS NULL))
	AND ((TYP_DateFrom IS NULL) OR (Current_Date>=TYP_DateFrom))
	AND ((TYP_DateTo IS NULL) OR (Current_Date<=TYP_DateTo))
	AND ((TYP_CTLOC_DR->CTLOC_Hospital_DR=:HospID) OR (:HospID is NULL))
	ORDER BY TYP_Desc
}

Query RTRecordTypeLookup(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "desc:%String,HIDDEN:%String,Code:%String")
{
SELECT TYP_Desc,TYP_Code,TYP_Rowid
FROM RTC_MRecordType
WHERE ((%ALPHAUP TYP_Desc  %STARTSWITH  %ALPHAUP :desc) OR(:desc IS NULL))
AND ((TYP_DateFrom IS NULL) OR (Current_Date>=TYP_DateFrom))
AND ((TYP_DateTo IS NULL) OR (Current_Date<=TYP_DateTo))
ORDER BY TYP_Desc
}

}
