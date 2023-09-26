Class web.PAAdmDischargeSummary Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1370;

Parameter SQLCODE = "DIS_RowID";

Parameter SQLDESCRIPTION = "DIS_RowID";

Parameter SQLROWID = "DIS_RowID";

ClassMethod GetTemplateName(DocType As %String = "") As %Library.String
{
}

ClassMethod GetGroupSummDocs(GroupID, Expired As %Boolean = 0) As %Library.String
{
}

ClassMethod GetArrayDetails(EpisodeID As %String = "", ByRef ARY As %Library.String)
{
}

ClassMethod LookUpAllEpisodesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAllEpisodesFetch ]
{
}

ClassMethod LookUpAllEpisodesExecute(ByRef QHandle As %Library.Binary, PatientID As %String = "", DischID As %String = "", Copy As %String = "") As %Library.Status
{
}

ClassMethod LookUpAllEpisodesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAllEpisodesExecute ]
{
}

ClassMethod IsCurrent(DischID As %String = "") As %Library.String
{
}

ClassMethod GetPreviousVersions(CurrDischID As %String = "") As %Library.String
{
}

ClassMethod FindDischargeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDischargeFetch ]
{
}

ClassMethod FindDischargeExecute(ByRef QHandle As %Library.Binary, PatientID As %String = "", CurrDischID As %String = "") As %Library.Status
{
}

ClassMethod FindDischargeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDischargeExecute ]
{
}

Query FindDischarge(PatientID, CurrDischID) As %Query(CONTAINID = 0, ROWSPEC = "PARREF,ID,EpNum,DISStatus,DISStatusDesc,DISDocType,doctype,DISLocation,DISHosp,AdmDate,AdmTime,DISDate,DISTime,DISFileName,DISUpdateDate,DISUpdateTime,DISUpdateUserID,DISPrinDiag,DISActiveProb,DISDisSumDesc,DISDisSumType,EpisodeType,CareProv,Unit,DocName,CanDoNew,PrevVer,RepHist,DISUpdateUserType,Hospital,VersionNo,HasResult,ReqID")
{
}

Query LookUpAllEpisodes(PatientID, DischID As %String = "", Copy As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "patientid,epid,selected,epnum,admisdt,disdt,stat,unit,eptyp,eptypdesc,caretyp,notreq,cprov,LinkedEp")
{
}

Query LookUpEpisodes(PatientID, EpisodeNo As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "PAADMAdmNo,PAADMLoc,HIDDEN")
{
SELECT PAADM_ADMNo,PAADM_DepCode_DR->CTLOC_Desc,PAADM_RowID
FROM SQLUser.PA_Adm 
WHERE PAADM_PAPMI_DR=:PatientID
AND %ALPHAUP PAADM_ADMNo %STARTSWITH %ALPHAUP :EpisodeNo
AND (PAADM_DischgDate IS NOT NULL) AND (PAADM_DischgTime IS NOT NULL)
}

ClassMethod LookUpBrokerEpisodes(itmjs As %Library.String = "", itmjsex As %Library.String = "", PatientID, EpisodeNo As %String = "") As %Library.Boolean
{
}

ClassMethod SaveDSEpisodes(compref As %String = "", DischEpisodes As %String = "", DischID As %String = "")
{
}

ClassMethod CopyDSEpisode(compref As %String = "", DischEpisodes As %String = "", DischID As %String = "")
{
}

ClassMethod GetEpisodesFromDischID(DischID As %String)
{
	Quit ""
}

ClassMethod GetLatestEpisode(DischEpisodes As %String = "", ByRef LatestEp As %String = "", ByRef EpArray As %String = "", ByRef mradms As %String = "", ByRef eps As %String = "")
{
	Quit ""
}

ClassMethod GetLatestInpatientEpisode(DischEpisodes As %String = "", ByRef LatestEp As %String = "")
{
}

ClassMethod GetProcedures(eps As %String = "", mradms As %String = "", ByRef procedures As %String = "")
{
}

ClassMethod GetEditDetails(DischEpisodes As %String, DischID As %String, CurrDischID As %String)
{
}

///       Currently, we are using the "Mark the record as Disabled" technique instead of deleting.
ClassMethod websysDeleteDisSum(compref As %String = "", SelectedIDs As %String = "")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveDisSum(compref As %String = "", id As %String = "", Preview As %String = 0)
{
}

ClassMethod DistributeDischSumm(DischID)
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %Library.String, DischID As %Library.String, new As %Boolean) As %Library.Boolean
{
}

ClassMethod getSeperator(sPath As %String = "") As %String
{
}

ClassMethod GetFaxMailDets(doc As %String = "", clin As %String = "", ByRef meth As %String = "", ByRef To As %String = "", ByRef From As %String = "", ByRef subject As %String = "", ByRef refdets As %String, hospID As %String = "", emailsubject As %String = "")
{
}

ClassMethod GetRTF(id As %Library.String = "", name As %String) As %Library.Status
{
}

}
