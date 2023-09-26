Include webimport

IncludeGenerator webimport

Class web.PANok Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 535;

Parameter SQLCODE = "NOK_RowId";

Parameter SQLDATEFROM = "NOK_DateFrom";

Parameter SQLDESCRIPTION = "NOK_RowId";

Parameter SQLDATETO = "NOK_DateTo";

Parameter SQLROWID = "NOK_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// cjb 16/02/2006 56793 - called from the ID hidden field on PANok.Edit
/// Gets the NOK and looks down that patients NOKs to find the original patient.  If it finds it, sets up RECIPROCALContactType & RECIPROCALRelation
ClassMethod GetReciprocalInfo(ID As %String)
{
}

/// cjb 21/02/2006 56793 - called from the NokID hidden field on PAPerson.Edit
/// defaults the values from PANok to the PAPerson.Edit fields
ClassMethod DefaultFields(ID As %String)
{
}

/// cjb 16/02/2006 56793 - called from web.PAPerson.websysAfterSave
/// If a NOK's details were defaulted into PAPerson.Edit, then saved, update the NOK record with the new PAPER_DR and set the 'NOKName' fields to null
ClassMethod RegisteredNOK(ID As %String, PatientID As %String)
{
}

/// cjb 16/02/2006 56793 - called from websysAfterSave
/// if the Reciprocal Contact Type field has been entered, create the 'reverse' NOK
ClassMethod websysSaveReciprocal(PARREF As %String, PatientID As %String)
{
}

ClassMethod CheckNokOverlap(ToPID As %Library.String = "", FromPID As %Library.String = "") As %Library.String
{
}

ClassMethod ClearFirstContactFlag(id As %String, PatientID As %String)
{
}

/// Copies all contacts that are ongoing or have a blank "Date To" or "DateTo" is greater than today
ClassMethod CopyContactsAgnstAdm(PatientID As %Library.String = "", EpisodeID As %Library.String = "")
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

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
/// 
/// 
/// i ##Class(web.PAPerson).ValidateQASFields(%request.Get("QASPROVDesc"),%request.Get("QASCTCITDesc"),%request.Get("QASCTZIPCode"),%request.Get("QASHealthCareArea"),%request.Get("PROVDesc"),%request.Get("CTCITDesc"),%request.Get("CTZIPCode")) {
/// 	} else {
/// 		d:msg msg.AddItem("E",t("QASFail"),compid,"") 
/// 		s oktosave=0
/// 	}
ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

/*log 60322 6-10-2006 BoC: copy NOK and get new rowId, not uesed anymore, take plan C!
ClassMethod CopyNok(NOKRowId As %Library.String) As %Library.String
{
 n newNOKId 
 k TLIST
 &SQL(SELECT * INTO :TLIST() FROM PA_Nok WHERE NOK_RowId = :NOKRowId)
 i SQLCODE q ""
 k TLIST(2)
 s (TLIST(8),TLIST(30))=""
 &SQL(INSERT INTO SQLUser.PA_Nok VALUES :TLIST())
 i SQLCODE q ""
 s newNOKId=$g(%ROWID)
 q newNOKId
}*/
ClassMethod FindRelByPatClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRelByPatFetch ]
{
}

ClassMethod FindRelByPatExecute(ByRef QHandle As %Library.Binary, patid As %Library.String) As %Library.Status
{
}

ClassMethod FindRelByPatFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRelByPatExecute ]
{
}

ClassMethod GetRFP(EpisodeID As %String = "")
{
}

ClassMethod FindRespNameClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRespNameFetch ]
{
}

ClassMethod FindRespNameExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod FindRespNameFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRespNameExecute ]
{
}

Query FindRespName(PatientID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIDDEN,HIDDEN,CTRLTDesc,TTLDesc,NOKSurname,NOKOtherName,NOKGivenName")
{
}

Query FindRelByPat(patid As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,Child,CTRLTDesc,Title,Name,Name2,Name3")
{
}

Query FindByType(id As %Library.String, noktype As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "datefrom:%String,dateto:%String,type:%String")
{
SELECT NOK_DateFrom,NOK_DateTo,NOK_ContactType_DR
FROM SQLUser.PA_Nok
WHERE (NOK_PAPMI_ParRef=:id)
AND ((NOK_ContactType_DR = :noktype) OR (:noktype IS NULL))
ORDER BY NOK_ContactType_DR
}

Query FindCurrentContacts(PatID As %Library.String, today As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ContactID,ContactType")
{
SELECT NOK_PAPER_DR,NOK_ContactType_DR
FROM SQLUser.PA_Nok
WHERE (NOK_PAPMI_ParRef=:PatID) 
AND ((NOK_DateTo IS NULL) OR (NOK_DateTo>:today))
Order by NOK_ContactType_DR
}

Query FindRespContact(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Hidden,Hidden,CTRLTDesc,PAPERTTLDesc,PAPERName,PAPERName2,PAPERName3,TTLDesc,NOKName,NOKName2,NOKName3")
{
SELECT NOK_RowId, NOK_ChildSub, NOK_Relation_DR->CTRLT_Desc, NOK_PAPER_DR->PAPER_Title_DR->TTL_Desc, NOK_PAPER_DR->PAPER_Name, NOK_PAPER_DR->PAPER_Name2, NOK_PAPER_DR->PAPER_Name3, NOK_Title_DR->TTL_Desc, NOK_Name, NOK_Name2, NOK_Name3
FROM SQLUser.PA_Nok
WHERE (NOK_PAPMI_ParRef =:PatientID)
}

Query FindFirstContacts(PatientID As %String = "") As %SQLQuery(ROWSPEC = "NOKID:%String")
{
SELECT 	NOK_RowId 
		FROM	SQLUser.PA_Nok
		WHERE	(NOK_PAPMI_ParRef = :PatientID)
		AND NOK_FirstContact='Y'
}

/// cjb 09/02/2006 58127 - rewritten this as an execute/fetch.  Original SQL query below:
/// 
/// SELECT NOK_RowId, NOK_ChildSub, NOK_DateFrom, NOK_DateTo, NOK_PAPER_DR, NOK_PAPMI_ParRef, NOK_Remarks, NOK_ContactType_DR->CONTTP_Code, NOK_ContactType_DR->CONTTP_Desc, NOK_PAPER_DR->PAPER_Email, NOK_PAPER_DR->PAPER_ForeignAddress, NOK_PAPER_DR->PAPER_MobPhone, NOK_PAPER_DR->PAPER_Name, NOK_PAPER_DR->PAPER_Name2, NOK_PAPER_DR->PAPER_Name3, NOK_PAPER_DR->PAPER_StName, NOK_PAPER_DR->PAPER_TelH, NOK_PAPER_DR->PAPER_TelO, NOK_PAPER_DR->PAPER_Title_DR->TTL_Desc, NOK_PAPER_DR->PAPER_Zip_DR->CTZIP_Code, NOK_PAPER_DR->PAPER_CityCode_DR->CTCIT_Desc, NOK_PAPER_DR->PAPER_CT_Province_DR->PROV_Desc, NOK_NonGovOrg_DR->NGO_Desc,NOK_Relation_DR->CTRLT_Desc,NOK_FirstContact,NOK_Email, NOK_ForeignAddress, NOK_MobPhone, NOK_Name, NOK_Name2, NOK_Name3, NOK_StNameLine1, NOK_TelH, NOK_TelO, NOK_Title_DR->TTL_Desc, NOK_Zip_DR->CTZIP_Code, NOK_CityCode_DR->CTCIT_Desc, NOK_Province_DR->PROV_Desc, NOK_PAPER_DR->PAPER_Name4, NOK_PAPER_DR->PAPER_Name5, NOK_PAPER_DR->PAPER_Name6, NOK_PAPER_DR->PAPER_Name7, NOK_PAPER_DR->PAPER_Name8, {fn CONVERT(NOK_ContactType_DR->CONTTP_DisplayOrder, SQL_VARCHAR)} AS Priority,NOK_Country_DR->CTCOU_Desc,NOK_PAPER_DR->PAPER_PAPMI_DR->PAPMI_Medicare,NOK_DateOfBirth,NOK_PAPER_DR->PAPER_Dob,NOK_Address2
/// FROM SQLUser.PA_Nok
/// WHERE (NOK_PAPMI_ParRef =:PARREF)
/// ORDER BY Priority
/// 
ClassMethod FindNOKClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindNOKFetch ]
{
}

ClassMethod FindNOKExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod FindNOKFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindNOKExecute ]
{
}

/// log 61054 TedT
ClassMethod CopyDetail(patientId As %String, PANokIds As %String)
{
}

/// log61054 TedT
ClassMethod GetNokDetails(NokIds As %String) As %String
{
}

/// log61054 TedT
ClassMethod SavePrevAddr(PrimaryId As %String, PatientIds As %String, Addrs As %String) As %String
{
}

/// log 61054 TedT
ClassMethod GetDetail(patientId As %String, code As %String) As %String
{
}

/// log 61054 TedT
ClassMethod ListNokDetailClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListNokDetailFetch ]
{
}

/// log 61054 TedT
ClassMethod ListNokDetailExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// log 61054 TedT
ClassMethod ListNokDetailFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListNokDetailExecute ]
{
}

/// log 61054 TedT
Query ListNokDetail() As %Library.Query(CONTAINID = 0, ROWSPEC = "code:%String,caption:%String,detail:%String")
{
}

Query FindNOK(PatientID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "NOK_RowId,NOK_ChildSub,NOK_DateFrom,NOK_DateTo,NOK_PAPER_DR,NOK_PAPMI_ParRef,NOK_Remarks,CONTTP_Code,CONTTP_Desc,PAPER_Email,PAPER_ForeignAddress,PAPER_MobPhone,PAPER_Name,PAPER_Name2,PAPER_Name3,PAPER_StName,PAPER_TelH,PAPER_TelO,CTRLT_Desc,NOK_FirstContact,NOK_Email,NOK_ForeignAddress,NOK_MobPhone,NOK_Name,NOK_Name2,NOK_Name3,NOK_StNameLine1,NOK_TelH,NOK_TelO,PAPER_Name4,PAPER_Name5,PAPER_Name6,PAPER_Name7,PAPER_Name8,TTL_Desc,CTZIP_Code,CTCIT_Desc,PROV_Desc,NOK_Address2,NGO_Desc,CTCOU_Desc,NOK_DateOfBirth,PAPER_Dob,PAPMI_Medicare,ContactTypeDisplayOrder,VIPStatus,Age,NOKRank,NOKPreferredContactMethod,NOKCarerContribution,fax,rego,EmployeeNo,NOKPayorCTCITDesc")
{
}

Query SQLFindNOK(PARREF As %String = "") As %SQLQuery(ROWSPEC = "NOK_RowId, Priority, NOK_Remarks, PAPER_StName")
{
SELECT NOK_RowId, {fn CONVERT(NOK_ContactType_DR->CONTTP_Priority, SQL_VARCHAR)} AS Priority, NOK_Remarks, NOK_PAPER_DR->PAPER_StName
FROM SQLUser.PA_Nok
WHERE (NOK_PAPMI_ParRef =:PARREF)
ORDER BY Priority
}

}
