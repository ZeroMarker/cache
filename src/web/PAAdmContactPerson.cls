Include webimport

IncludeGenerator webimport

Class web.PAAdmContactPerson Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 323;

Parameter SQLDATEFROM = "CONT_DateFrom";

Parameter SQLDATETO = "CONT_DateTo";

Parameter SQLCODE = "CONT_RowId";

Parameter SQLDESCRIPTION = "CONT_RowId";

Parameter SQLROWID = "CONT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindContactDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindContactDetailsFetch ]
{
}

ClassMethod FindContactDetailsExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindContactDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindContactDetailsExecute ]
{
}

ClassMethod GetContactDetails(PersonID As %Library.String) As %Library.String
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.
/// The compref is the  component reference which is the string from which we can deduce the instance of
/// websysComponent
/// websysComponentItem
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

/// ab 15.12.03 39289
/// hidden broker that populates PAAdmContactPerson.Edit and PANok.Edit with nok details
ClassMethod FillClientDetails(itmjs As %String, itmjsex As %String, PatientID As %String = "", Component As %String = "", FromNOK As %String = "") As %Boolean
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

/// ab - no longer used?
ClassMethod zzGetNOKDetails(PatientID As %String = "")
{
}

ClassMethod zzSetPatientContact(EpisodeID As %Library.String, prevadm As %Library.String) As %Library.Boolean
{
}

Query FindContact(EpisodeID As %String) As %SQLQuery(ROWSPEC = "RowId,Code,Desc,Email,ForeignAddress,MobPhone,Name,Name2,TelH,TelO,Zip,City,Sex,StName,DateFrom,DateTo,NGODesc,Title,ConsentToShareInfo,Relation,Age,Dob,PAPMIMedicare,HealthFundNo,Name3,Name4,Name5,Name6,Name7,Name8,PersonID,NGORowId,PROVDesc,CONTCarerContribution")
{
SELECT CONT_RowId, CONT_ContType_DR->CONTTP_Code, CONT_ContType_DR->CONTTP_Desc, CONT_Person_DR->PAPER_Email, CONT_Person_DR->PAPER_ForeignAddress, CONT_Person_DR->PAPER_MobPhone, CONT_Person_DR->PAPER_Name, CONT_Person_DR->PAPER_Name2,CONT_Person_DR->PAPER_TelH, CONT_Person_DR->PAPER_TelO, CONT_Person_DR->PAPER_Zip_DR->CTZIP_Code,CONT_Person_DR->PAPER_CityCode_DR->CTCIT_Desc, 
CONT_Person_DR->PAPER_Sex_DR->CTSEX_Desc,CONT_Person_DR->PAPER_StName,CONT_DateFrom,CONT_DateTo,CONT_NonGovOrg_DR->NGO_Desc,CONT_Person_DR->PAPER_Title_DR->TTL_Desc,CONT_ConsentToShareInfo,CONT_CTRLT_DR->CTRLT_Desc,CONT_Person_DR->PAPER_Age, CONT_Person_DR->PAPER_Dob, CONT_Person_DR->PAPER_PAPMI_DR->PAPMI_Medicare,CONT_Person_DR->PAPER_PAPMI_DR->PAPMI_HealthFundNo, CONT_Person_DR->PAPER_Name3, CONT_Person_DR->PAPER_Name4,
CONT_Person_DR->PAPER_Name5, CONT_Person_DR->PAPER_Name6, CONT_Person_DR->PAPER_Name7, CONT_Person_DR->PAPER_Name8, CONT_Person_DR->PAPER_RowId,CONT_NonGovOrg_DR->NGO_RowId,CONT_Person_DR->PAPER_CT_Province_DR->PROV_Desc,CONT_CarerContribution
FROM SQLUser.PA_AdmContactPerson
WHERE  CONT_ParRef = :EpisodeID
Order by CONT_ContType_DR->CONTTP_Code, CONT_Person_DR->PAPER_Name, CONT_Person_DR->PAPER_Name2
}

Query FindContactDetails(EpisodeID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RowId,Code,Desc,Email,ForeignAddress,MobPhone,Name,Name2,TelH,TelO,Zip,City,Sex,StName,DateFrom,DateTo,NGODesc,Title,ConsentToShareInfo,Relation,Age,Dob,PAPMIMedicare,HealthFundNo,Name3,Name4,Name5,Name6,Name7,Name8,PersonID,NGORowId,fax,PROVDesc,CONTChildsub,CONTCarerContribution")
{
}

}
