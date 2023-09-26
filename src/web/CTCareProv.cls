Include webimport

IncludeGenerator webimport

Class web.CTCareProv Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 590;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CTPCP_Code";

Parameter SQLDESCRIPTION = "CTPCP_Desc";

Parameter SQLROWID = "CTPCP_RowId";

/// Log 37540/36493
Parameter SQLFILTER = "((CTPCP_DateActiveFrom <=  CURRENT_DATE) OR (CTPCP_DateActiveFrom IS NULL)) AND ((CTPCP_DateActiveTo IS NULL) OR (CTPCP_DateActiveTo >=  CURRENT_DATE))";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetCareProvForClinicalNotes(ID As %Library.String, EpisodeType As %Library.String, EpisodeID As %Library.String, AppointmentID As %Library.String) As %Library.String
{
}

/// ab 7.01.04 - 39586 - returns the full name from SSUser for the corresponding care provider
/// ab 21.09.03 - 46333 no longer using SSUser, will get full desc from CTCareProv
/// wanghc
ClassMethod GetCareProvSSUserName(id As %String = "") As %String
{
	q:id="" ""
	q:'$d(^CTPCP(id,1)) ""
	q $p(^CTPCP(id,1),"^",2)
	;s obj=##class(User.CTCareProv).%OpenId(id)	;obj 会覆盖mac中的obj
	;q:'$IsObject(obj) ""
	;q obj.CTPCPDesc
}

/// ab 7.01.04 - 39586 - used in PAAdm.websysSave to get the CTCareProv row for the SSUser name
/// ab 21.09.03 - 46333 - now getting id from CTCareProv fields
ClassMethod GetIdFromCodeOrUserDesc(desc As %String = "", date As %String = "") As %String
{
	Q ""
}

/// KM 29-Jun-2001: Called from component MRRiskEvaluation.Edit and MRNursingNotes.Edit
ClassMethod GetDescFromRowId(rowid As %String = "")
{
}

ClassMethod GetIsRadiologist(Radiologist As %Library.String = "") As %Library.String
{
}

/// Log 65432
ClassMethod GetIsRadiologistFromUser(userCode As %Library.String = "") As %Library.String
{
}

/// ab 17.02.04 - 42382 - one lookup to rule them all...
/// type = hat delimited string of internal types eg. "DOCTOR^NURSE" 
/// flags - rad^ana^surg (rad = CTPCP_Radiologist, ana= CTPCP_Anaesthetist, surg = CTPCP_Surgeon, spec = CTPCP_SpecialistYN)
/// cpt = care provider type desc (CTCarPrvTp)
/// 
ClassMethod LookUpActiveCareProvExecute(ByRef QHandle As %Library.Binary, desc As %String = "", date As %Date = "", type As %String = "", flags As %String = "", cpt As %String = "", loc As %String = "", cploc As %String = "") As %Library.Status
{
}

ClassMethod LookUpActiveCareProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpActiveCareProvExecute ]
{
}

ClassMethod LookUpActiveCareProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpActiveCareProvFetch ]
{
}

Query LookUpActiveCareProv(desc As %String, date As %Date, type As %String, flags As %String, cpt As %String, loc As %String, cploc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "CTPCPDesc:%String,HIDDEN:%String,CTPCPCode:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// ab 17.02.04 - one broker to rule them all...
/// 
ClassMethod LookUpActiveCareProvBroker(itmjs As %String = "", itmjsex As %String = "", qdesc As %String = "", qdate As %Date = "", qtype As %String = "", flags As %String = "", qcpt As %String = "", qloc As %String = "", qcploc As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, desc As %String = "") As %Library.Status
{
}

ClassMethod LookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpExecute ]
{
}

ClassMethod LookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFetch ]
{
}

Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "CTPCPDesc:%String,HIDDEN:%String,CTPCPCode:%String")
{
}

/// Log 61269 - AI - 02-01-2007 : Query did not exist - copied from W642L. Called from 'VerifiedBy' on OETextResult.Verify.
Query LookUpRadiologist(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTPCPDesc:%Library.String,HIDDEN,CTPCPCode:%Library.String")
{
SELECT	CTPCP_Desc, CTPCP_RowID, CTPCP_Code
FROM	SQLUser.CT_CareProv
WHERE	(CTPCP_Desc %STARTSWITH :desc) AND (CTPCP_Radiologist = 'Y') AND (CTPCP_DateActiveFrom <= CURRENT_DATE) AND ((CTPCP_DateActiveTo IS NULL) OR (CTPCP_DateActiveTo >= CURRENT_DATE))
ORDER	BY CTPCP_Desc
}

ClassMethod GetCPType(CPId As %String = "") As %String
{
}

/// Log 56813 - 15.12.2006 - Get Care Provider Type Description
ClassMethod GetCPTypeDesc(CPId As %String = "") As %String
{
}

/// Log 56813 - 15.12.2006 - Get Care Provider Speciality
ClassMethod GetCPSpecialty(CPId As %String = "") As %String
{
}

ClassMethod GetCareProvIdfromUserIdOrDesc(val As %String) As %String
{
}

}
