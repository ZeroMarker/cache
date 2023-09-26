Include webimport

IncludeGenerator webimport

Class web.PACRefDoctorClinic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 141;

Parameter SQLDATEFROM = "CLN_DateFrom";

Parameter SQLDATETO = "CLN_DateTo";

Parameter SQLCODE = "CLN_Code";

Parameter SQLDESCRIPTION = "CLN_Code";

Parameter SQLROWID = "CLN_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetIdFromCodeAndRefDocId(code As %Library.String, refdocid As %Library.String) As %Library.String
{
}

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetIdFromCodeAndRefDocIdNew(code As %Library.String, refdocid As %Library.String) As %Library.String
{
}

/// KK 17/Apr/2002 Log: 2430 & 24020
/// Find the object id given the address
/// 
ClassMethod GetIdFromRefDocAddress(Addr As %Library.String) As %Library.String
{
}

ClassMethod ResetClinic(RefDocId As %Library.String) As %Library.String
{
}

ClassMethod VBSetRefDocClinic(RefDocId As %Library.String) As %Library.String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Query LookupByCode(codedesc As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "code:%String,HIDDEN:%String")
{
SELECT CLN_Code,CLN_RowId
FROM PAC_RefDoctorClinic
WHERE (CLN_Code = :codedesc) OR (:codedesc IS NULL)
}

Query LookupByCodeCustom(codedesc As %String, clinicaddr As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CLNCode,CLNRowId,CLNAddress1,CLNAddress2,CLNBusPhone,CTCITDesc,CLNEmail,CLNFax,CLNMobPhone,CLNPhone,CLNPreferredContact,CLNProviderNo,CTZIPCode")
{
SELECT CLN_Code,CLN_RowId,CLN_Address1,CLN_Address2,CLN_BusPhone,CLN_City_DR->CTCIT_Desc,CLN_Email,CLN_Fax,CLN_MobPhone,		            CLN_Phone,CLN_PreferredContact,CLN_ProviderNo,CLN_Zip_DR->CTZIP_Code
FROM PAC_RefDoctorClinic
WHERE ((CLN_Code = :codedesc) OR (:codedesc IS NULL))
AND ((CLN_Address1 =:clinicaddr) OR (:clinicaddr IS NULL))
}

}
