Include webimport

IncludeGenerator webimport

Class web.PAPatMas Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 864;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PAPMI_IPNo";

Parameter SQLDESCRIPTION = "PAPMI_OPNo";

Parameter SQLROWID = "PAPMI_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetBarCSS()
{
	w "<style>"
	w "body{padding:0;}#fPAPerson_Banner table td{ vertical-align:top} ;"
	w "</style>"
	q ""
}

ClassMethod IsPatientActive(PatientID As %String = "", compid As %String = "") As %Library.Boolean
{
}

ClassMethod FindWithIconsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWithIconsFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindWithIconsExecute(ByRef QHandle As %Library.Binary, PatientIDs As %String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0) q $$$OK
	
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	q $$$OK
}

ClassMethod FindWithIconsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWithIconsExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// KM 30-Nov-2001: Called from LookUpRegistraton query
ClassMethod GetActivePatIDForMergedPatID(pat As %Library.String)
{
}

/// ab 1.03.02 - also selects medicare, suffix, medicare code and gp free text so individual functions arent needed
/// cjb 16/06/2005 52218 - removed most of the sql, using the globals instead
ClassMethod GetCardDetails(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetDentistDetails(PatientID As %Library.String) As %Library.String
{
}

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod GetMotherDR(PatientID As %Library.String) As %Library.String
{
}

/// Author - John Hart
/// Purpose - To the patient title displayed as tooltip on floor plan and in the page headings
/// 
/// KM 30-Jan-2002: Updated this to exclude age, sex and registration number details for RIE
/// 
ClassMethod GetPatientTitle(PatientID As %Library.String, FPLayout As %Library.String = "") As %Library.String
{
}

/// 49799 - check system patient params for name display order
/// returns patient names in set order otherwise blank to allow default
/// 9-Feb-05: used on floorplan
ClassMethod GetNameOrderDisplay(PatientID) As %Library.String
{
	&SQL(SELECT PAPMI_Name into :PAPMIName
		FROM SQLUser.PA_PatMas
		WHERE (PAPMI_RowID = :PatientID))
	if 'SQLCODE Q PAPMIName
	Q "Anonymous"
}

/// zhouzq 2011.05.31  Used in Component "PAPerson.Banner"
/// w ##class(web.PAPatMas).GetRegistration(1)
ClassMethod GetRegistration(PatientID As %Library.String) As %Library.String
{
	&SQL(SELECT PAPMI_No into :Registration
		FROM SQLUser.PA_PatMas
		WHERE (PAPMI_RowID = :PatientID))
	if 'SQLCODE Q Registration
	Q "Anonymous"
}

/// 30/10/02 Log#29405 HP: Get VIP status.
/// Used by all names component items to display "Anonymous" if VIP status is.
/// zhouzq 2011.05.31  Used in Component "PAPerson.Banner"
/// w ##class(web.PAPatMas).GetVIPStatus(1)
ClassMethod GetVIPStatus(PatientID As %Library.String) As %Library.String
{
	&SQL(SELECT PAPMI_VIPFlag into :VIPStatus
		FROM SQLUser.PA_PatMas
		WHERE (PAPMI_RowID = :PatientID))
	if 'SQLCODE Q VIPStatus
	Q ""
}

/// Author - John Hart
/// Purpose - To the patient title in the waiting room
/// User By - epr.floorplan.csp
ClassMethod GetWaitingPatientDetails(PatientID As %Library.String, PARAMS As %Library.String = "") As %Library.String
{
}

/// Author - PeterC Log 57142
/// Purpose - Convert Est. DOB to Html format
ClassMethod EstDOBLogicalToHtml(h As %Library.String) As %Library.String
{
	s ^Temp($i(^Temp),"h")=h
	s ^Temp($i(^Temp),"h",1)=##class(websys.Conversions).DateHtmlToLogical(h)
	//s ^Temp($i(^Temp),"h",1)=$zd(+h,3)
	//quit $zd(+h,3)
	quit ##class(websys.Conversions).DateLogicalToHtml(h)
}

ClassMethod HistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = HistoryFetch ]
{
}

ClassMethod HistoryExecute(ByRef QHandle As %Library.Binary, PatientID As %String, PAHistoryType As %String = "") As %Library.Status
{
}

ClassMethod HistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = HistoryExecute ]
{
}

/// ab 27.08.02 - is patient a VIP?
/// used in patient banner
ClassMethod IsVIP(PatientID As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpRegistrationClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRegistrationFetch ]
{
}

ClassMethod LookUpRegistrationExecute(ByRef QHandle As %Library.Binary, regno As %Library.String) As %Library.Status
{
}

ClassMethod LookUpRegistrationFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRegistrationExecute ]
{
}

/// converts a multi line text field to a list, for storing
Method MultiLineTextToList(str As %Library.String)
{
}

ClassMethod QuestionnaireClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QuestionnaireFetch ]
{
}

ClassMethod QuestionnaireExecute(ByRef QHandle As %Library.Binary, EpisodeID As %String) As %Library.Status
{
}

ClassMethod QuestionnaireFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QuestionnaireExecute ]
{
}

/// called from questionnaires page (ssuserdefwindowcontrols.questionnaire.csp)
/// fetched the answers for this patient for the last answered question of this questionnaire type
ClassMethod QuestionnaireGetLastAnswers(PatientID As %Library.String, questionnaireClass As %Library.String, ByRef DataList As %Library.String)
{
}

ClassMethod SearchDuplicateReg(reg As %Library.String) As %Library.Boolean
{
}

/*
/// cjb 05/09/2006 - don't think this is being used anymore
ClassMethod webSetTitleBar(PatientID As %Library.String, doCheck As %Library.String = 1)
{
 //writes some javascript code to set the browser title bar with patient details
 w "<SCRIPT>",$c(13,10)
 n name,namejs,i
 s name=##Class(web.PAPatMas).GetPatientTitle(PatientID)
 s namejs=$p(name,"""",1)
 f i=2:1:$l(name,"""") s namejs=namejs_"\"""_$p(name,"""",i)
 i doCheck {
 	i $g(PatientID)'="" w "websys_setTitleBar(""",namejs,""");",$c(13,10)
 } else {
 	w "websys_setTitleBar(""",namejs,""");",$c(13,10)
 }
 w "</SCRIPT>",$c(13,10)
 q
}
*/
/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Author - John Hart
/// Purpose - Saves Patient Details
/// Used By - EPR page
/// 
/// LOG 26677 - AI - 23-07-2002 : Get the new HistoryID item. If this has a value, we are updating a history row and not inserting a new one. Call the HistoryInserts using this HistoryID too.  Also, add the new item Activechk (Active checkbox).
ClassMethod websysSaveHistory(compref As %Library.String, PatientID As %String)
{
}

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Registration:%String,IdentityNo:%String,Name:%String,Surname:%String,OtherName:%String,PAPERStName:%String,CTCITDesc:%String,REFDDesc:%String,PAPMIDeceased:%String")
{
SELECT PAPMI_RowID, PAPMI_IPNo, PAPMI_ID, PAPMI_Name, PAPMI_Name2, PAPMI_Name3, PAPMI_PAPER_DR->PAPER_StName, PAPMI_PAPER_DR->PAPER_CityCode_DR->CTCIT_Desc, PAPMI_PAPER_DR->PAPER_FamilyDoctor_DR->REFD_Desc,PAPMI_Deceased
FROM PA_PatMas
WHERE (PAPMI_Rowid = :ID)
}

Query EditDeceased(ID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PAPMIDeceased:%Boolean,PAPMIDeceasedDate:%Date,PAPMIDeceasedTime:%Time")
{
SELECT PAPMI_RowID, PAPMI_Deceased, PAPMI_Deceased_Date, PAPMI_DeceasedTime
FROM PA_PatMas
WHERE (PAPMI_Rowid = :ID)
}

Query Find(name As %String, surname As %String, registration As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Name:%String,Surname:%String,Registration:%String")
{
SELECT PAPMI_RowID, PAPMI_Name, PAPMI_Name2, PAPMI_IPNo
FROM PA_PatMas
WHERE (PAPMI_IPNo = :registration)
}

/*
/// cjb 05/09/2006 - don't think this is being used anymore
Query FindBasicDetails(PatientID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,PAPMINo:%String,CTSEXDesc:%String,PAPERAge:%Float,PAPERTelH:%String,PAPMIEPRDescription:%String,PAPMIDOB,PrefLanguage:%String")
{
SELECT PAPMI_RowID, PAPMI_Name,PAPMI_Name2,PAPMI_Name3,
PAPMI_No,PAPMI_Sex_DR->CTSEX_Desc,
PAPMI_PAPER_DR->PAPER_AgeYr,
PAPMI_PAPER_DR->PAPER_TelH,
PAPMI_EPRDescription,PAPMI_DOB,
PAPMI_PAPER_DR->PAPER_PrefLanguage_DR->PREFL_Desc
FROM SQLUser.PA_PatMas
WHERE (PAPMI_RowID = :PatientID)
}
*/
Query FindPatient(PatientID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "PatientID,Name:%String,Name2:%String,Name3:%String,RegistrationNo:%String,Sex:%String,Dob,Name4,Name5,Name6,Name7,Name8,VIPStatus")
{
SELECT PAPMI_RowID, PAPMI_Name,PAPMI_Name2,PAPMI_Name3,
PAPMI_No,PAPMI_Sex_DR->CTSEX_Desc,PAPMI_DOB,PAPMI_Name4,PAPMI_Name5,PAPMI_Name6,PAPMI_Name7,PAPMI_Name8, PAPMI_VIPFlag
FROM SQLUser.PA_PatMas
WHERE (PAPMI_RowID = :PatientID)
}

/// KM 17-Sept-2001: Called From Component PAPatMas.ListEMRPatDetails
Query FindWithIcons(PatientID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PAPMIName,PAPMIName2,PAPMIName3,PAPMINo,CTSEXDesc,PAPERAge,PAPERTelH,PAPMIDOB,Deceased,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,VIPStatus")
{
}

/// Query to retrieve data from multiple tables:
/// PADesease (!),PAPastHistCondition,PAOperation,PAAllergy,PASocHist,PAFamily
/// ;
/// This query requires that the 'Find' queries are consistent.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code.
Query History(PatientID As %String, PAHistoryType As %String) As %Query(CONTAINID = 1, ROWSPEC = "ID,Type:%String,Desc:%String,OnsetDate:%Date,Years,Months,Days,Comments:%List,CareProvider:%String,UpdateUser:%String,HistoryType:%String,HistoryDesc:%String,CommentsDisplay:%String,chkInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String,HiddenFields:%String")
{
}

/// KM 30-Nov-2001: 
/// Altered this to a Fetch/Execute/Close type query to cope with finding the Active registration number for merged regnos
Query LookUpRegistration(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RegistrationNo:%String,HIDDEN:%String,MergedRegNo:%String,Surname:%String,Forename:%String")
{
}

}
