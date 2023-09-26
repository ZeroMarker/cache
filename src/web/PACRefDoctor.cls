Include webimport

IncludeGenerator webimport

Class web.PACRefDoctor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 931;

Parameter SQLCODE = "REFD_Code";

Parameter SQLDATEFROM = "REFD_DateActiveFrom";

Parameter SQLDATETO = "REFD_DateActiveTo";

Parameter SQLDESCRIPTION = "REFD_Desc";

Parameter SQLROWID = "REFD_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod FindClinicExists(refDocID As %Library.String)
{
}

/// md 17/02/2005  -48113 title firstname othername surname
ClassMethod GetFullDoctorName(docid As %String = "") As %String
{
}

/// cjb 29/07/2004 44103
ClassMethod GenerateCode(compid As %String, id As %String) As %String
{
}

ClassMethod GetActiveDRIdByCodeORDesc(value As %Library.String) As %Library.String
{
}

ClassMethod LookUpBrokerDocByClinic(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Param1 As %Library.String = "", Param2 As %Library.String = "", Param3 As %Library.String = "", Restriction As %Library.String = "", DoctorFname As %Library.String = "", DoctorMname As %Library.String = "", Speciality As %Library.String = "", ProvNo As %Library.String = "", DoctorZip As %Library.String = "", sdone As %String = "", ClinicZip As %String = "", notShow As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerPartialWithClinic(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// cjb 08/01/2004 query re-written for 32283.
/// Old query now named LookUpDoctorOLD
/// cjb 11/01/2005 - deleted LookUpDoctorOLD
ClassMethod LookUpDoctorClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDoctorFetch ]
{
}

/// cjb 08/01/2004 query re-written for 32283.
/// log 61979 TedT added notShow parameter
/// Old query now named LookUpDoctorOLD
ClassMethod LookUpDoctorExecute(ByRef QHandle As %Library.Binary, Doctor As %Library.String, ClinicAdd1 As %Library.String, ClinicSuburb As %Library.String, RefDocBroker As %Library.String = "", Restriction As %Library.String = "", DoctorFname As %Library.String = "", DoctorMname As %Library.String = "", Speciality As %Library.String = "", ProvNo As %Library.String = "", DoctorZip As %Library.String = "", sdone As %Library.String = "", ClinicZip As %Library.String = "", notShow As %String = "") As %Library.Status
{
}

/// cjb 08/01/2004 query re-written for 32283.
/// Old query now named LookUpDoctorOLD
ClassMethod LookUpDoctorFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDoctorExecute ]
{
}

ClassMethod LookUpPartialWithClinicClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPartialWithClinicFetch ]
{
}

ClassMethod LookUpPartialWithClinicExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, RefDocBroker As %Library.String) As %Library.Status
{
}

ClassMethod LookUpPartialWithClinicFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPartialWithClinicExecute ]
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSave(compref As %String, id As %String) [ CodeMode = generator ]
{
}

Query Edit(ID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,Code:%String,Description:%String,Address:%String,City:%String,Zip:%String,Phone:%String,BusPhone:%String,MobPhone:%String,Fax:%String,Email:%String,DateActiveFrom:%Date")
{
SELECT REFD_RowId, REFD_Code, REFD_Desc, REFD_Address, REFD_CITY_DR->CTCIT_Desc, REFD_CTZIP_DR->CTZIP_Desc, REFD_Phone, REFD_BusPhone, REFD_MobilePhone, REFD_Fax, REFD_Email, REFD_DateActiveFrom
FROM SQLUser.PAC_RefDoctor
WHERE (REFD_RowId = :ID)
}

Query LookUpDetailsByCodeOrDesc(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT REFD_Desc, REFD_Code, REFD_RowId
FROM SQLUser.PAC_RefDoctor
WHERE (%ALPHAUP REFD_Desc %STARTSWITH %ALPHAUP :desc) OR (REFD_Code %STARTSWITH :desc)
ORDER BY REFD_Code
}

/// cjb 08/01/2004 query re-written for 32283.
/// Old query now named LookUpDoctorOLD
/// DocCode:%String,DocDesc:%String,HIDDEN:%String,ClinCode:%String,ClinAddr:%String,ClinProvNo:%String,HIDDEN:%String,ClinSuburb:%String,tele:%String,clindatefrom:%Library.Date,clindateto:%Library.Date
Query LookUpDoctor(Doctor As %String, ClinicAdd1 As %String, ClinicSuburb As %String, RefDocBroker As %String, Restriction As %String, DoctorFname As %String, DoctorMname As %String, Speciality As %String, ProvNo As %String, DoctorZip As %String, sdone As %String, ClinicZip As %String, notShow As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "DoctorTitle:%String,DocDesc:%String,DoctorMname:%String,DoctorFname:%String,HIDDEN:%String,DocCode:%String,DocSpec:%String,ClinCode:%String,HIDDEN:%String,ClinProvNo:%String,ClinAddr:%String,ClinSuburb:%String,tele:%String,hidden:%Library.Date,hidden:%Library.Date,hidden:%Library.String,hidden:%Library.String,ClinDesc:%Library.String,ClinCity:%Library.String,ClinZip:%Library.String,DoctorProvNo:%Library.String,DocZip:%Library.String,DocHCA:%Library.String,ClinAddr2:%Library.String,ClinPrefConcat:%Library.String,DocCity:%Library.String,DocProvin:%Library.String,DocPrefCon:%Library.String,DocAddrress:%Library.String,FullClinicAddress:%Library.String,FullDoctorName:%Library.String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpPartialCarProvByCodeDesc(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT REFD_Desc, REFD_Code, REFD_RowId
FROM SQLUser.PAC_RefDoctor
WHERE (%ALPHAUP REFD_Desc [%ALPHAUP :desc) OR (%ALPHAUP REFD_Code [%ALPHAUP :desc)
ORDER BY REFD_Code
}

Query LookUpPartialDoctor(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String")
{
SELECT REFD_Desc
FROM SQLUser.PAC_RefDoctor
WHERE (%ALPHAUP REFD_Desc [%ALPHAUP :desc)
ORDER BY REFD_Desc
}

Query LookUpPartialWithClinic(desc As %String, broker As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "hidden:%String,DocDesc:%String,DocMname:%Library.String,DocFname:%Library.String,DocCode:%String,HIDDEN:%String,ClinCode:%String,ClinAddr:%String,ClinProvNo:%String,HIDDEN:%String,ClinSuburb:%String,clindateto:%Library.Date,clindatefrom:%Library.Date,ClinDesc:%Library.String,ClinCity:%Library.String,ClinZip:%Library.String")
{
}

Query LookUpRestPartCarProvByCodeDesc(desc As %Library.String, type As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT REFD_Desc, REFD_Code, REFD_RowId
FROM SQLUser.PAC_RefDoctor
WHERE ((%ALPHAUP REFD_Desc [%ALPHAUP :desc) OR (%ALPHAUP REFD_Code [%ALPHAUP :desc))
}

/// returns the care provider name and telephone number
Query LookUpWithPhone(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Phone:%String,HIDDEN:%String")
{
SELECT REFD_Desc, REFD_Phone, REFD_RowID
FROM PAC_RefDoctor
WHERE (%ALPHAUP REFD_Desc %STARTSWITH %ALPHAUP :desc)
ORDER BY REFD_Desc
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

/// AJI log 39106 - 3.11.03
ClassMethod LookUpByDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.Date = "") As %Library.Boolean
{
}

/// AJI log 39106 - 3.11.03
Query LookUpByDate(desc As %Library.String, date As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT REFD_Desc, REFD_Code, REFD_RowId
FROM SQLUser.PAC_RefDoctor
WHERE ((%ALPHAUP REFD_Desc %STARTSWITH %ALPHAUP :desc) OR (REFD_Code %STARTSWITH :desc))
AND ((REFD_DateActiveTo >= :date) OR (REFD_DateActiveTo IS NULL))
AND ((REFD_DateActiveFrom <= :date) OR (REFD_DateActiveFrom IS NULL))
ORDER BY REFD_Desc
}

}
