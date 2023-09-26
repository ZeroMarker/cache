Class web.PAPregnancy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 200;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PREG_RowId";

Parameter SQLDESCRIPTION = "PREG_RowId";

Parameter SQLROWID = "PREG_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindByPatientClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByPatientFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(ResultSet).RunQuery("web.PAPregnancy","FindByPatient","2970017")
ClassMethod FindByPatientExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{

	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	i PatientID=""
	{
		 q $$$OK
	}
	s ^Temp("wanghc","req")=PatientID
	S ID=""
	F  S ID = $o(^PAPRGi("PREG_Person",PatientID,ID))  Q:ID=""  D
	.s (PREGDateOfBooking,Status,EdcAgreed,MidCommTeam,PregType,Confidential,TotalBabies,FirstDeliveryDate,FirstDeliveryTime)=""
	.s (ModeOfDelivery,BabyOutcome,ComplicationsExist)=""
	.s obj = ##class(User.PAPregnancy).%OpenId(ID,1)
	.s PREGDateOfBooking=obj.PREGDateOfBooking
	.S StatusObj = obj.PREGStatus	;PAC_PregStatus
	.s:$IsObject(StatusObj) Status = StatusObj.PREGSTDesc 
	.s EdcAgreed = obj.PREGEdcAgreed
	.s MidCommTeamObj=obj.PREGMidCommTeamDR	;PACMidwifeCommTeam
	.s:$IsObject(MidCommTeamObj) MidCommTeam=MidCommTeamObj.MIDCOMMDesc  
	.S PregType = obj.PREGPregType
	.s Confidential = obj.PREGConfidential
	.S PREGFetusThisPregObj = obj.PREGFetusThisPreg
	.s:$IsObject(PREGFetusThisPregObj) TotalBabies=PREGFetusThisPregObj.PLURDesc ;PACBabyPlurality
	.s delivery = ..GetDeliveryID(ID)
	.s deliveryObj = ##class(User.PAPregDelivery).%OpenId(ID,1)
	.i $IsObject(deliveryObj) d
	..s FirstDeliveryDate = deliveryObj.DELCsDecisionDate
	..s FirstDeliveryTime = deliveryObj.DELCsDecisionTime
	..s ModeOfDelivery = deliveryObj.DELDeliveryType
	..s DELOutComeObj = deliveryObj.DELMotherOutcomeDR	;PACMotherOutcome
	..s:$IsObject(DELOutComeObj) BabyOutcome = DELOutComeObj.MTHROCDesc
	.s ComplicationsExist = ""
	.s ^CacheTemp(repid,ind)=$lb(ID,PREGDateOfBooking,Status,EdcAgreed,MidCommTeam,PregType,Confidential,TotalBabies,FirstDeliveryDate,FirstDeliveryTime,ModeOfDelivery,BabyOutcome,ComplicationsExist)
	.s ind=ind+1
	
	s QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod FindByPatientFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByPatientExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeliveryID(pregId As %Library.String = "") As %Library.String
{
	s DELRowid=""
	&SQL(select DEL_RowId into:DELRowid from SQLUser.PA_PregDelivery where DEL_ParRef=:pregId)
	q DELRowid
}

ClassMethod GetGravidaCount(patientId As %Library.String) As %Library.Integer
{
	q 0
}

/// yanglei
/// 由就诊号得到preRowid（prerowid=$o(^PAPRGi("DEL_LaborDate",PrtDate,preRowid))
ClassMethod GetIDFromEpisodeID(EpisodeID As %Library.String = "") As %Library.String
{
	s TRowid=""
	;epId
	&SQL(select DEL_ParRef into:TRowid from SQLUser.PA_PregDelivery where DEL_Adm_DR=:EpisodeID)
	i SQLCODE=0 q TRowid
	q ""
}

ClassMethod GetParaCount(patientId As %Library.String) As %Library.Integer
{
	q 0
}

ClassMethod HasEpisodes(PatientID As %Library.String = "", PAPregnancyID As %Library.String = "") As %Library.Boolean
{
}

/// Log 51109 18/4/05 Chandana. Returns 1 if patient is pregnant else returns 0
/// Patient is pregnant if she has an 'Open' pregnancy and there are no baby
/// details attached to the pregnancy.
ClassMethod IsPatPregnant(patId As %Library.String) As %Library.Boolean
{
}

ClassMethod IsPatPregAntComp(patId As %Library.String) As %Library.Boolean
{
}

/// If Patient has an open pregnancy, returns the pregnancy id.
/// Else returns a blank.
ClassMethod GetOpenPregnancy(patId As %Library.String) As %Library.String
{
}

/// Trak.Maternity.PregnancyTree workflow
ClassMethod IsNotFemaleByPatId(patId As %Library.String) As %Library.Boolean
{
	n (patId)
	set FemaleSexDR = ##Class(web.CFPatConf).GetConfiguration("PATCFFemaleSexDR","")
	set obj = ##class(User.PAPerson).%OpenId(patId,0)
	if $IsObject(obj){
		set SexDR = obj.PAPERSexDRGetObjectId()
		If SexDR=FemaleSexDR q 0
	}
	q 1
}

ClassMethod LinkEpsToPregnancy(PatId As %Library.String)
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	Q $$$OK
}

/// Invoked before websysSave - can be used to cancel the save.<br>
/// -When creating a new medtrak pregnancy, checks if an Open pregnancy already exists.  If so an error
/// message is displayed and the Save is cancelled.
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	;wanghc
	q $$$OK
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
	&sql(delete from SQLUser.PA_Pregnancy where PREG_RowId=:id)
	i SQLCODE q $$$OK
	Q ""
}

/// PAPerson.Banner组件用到,需要实现  zhzhq
ClassMethod GetPregnancyDetails(PatientID As %Library.String = "", treeflag As %Library.String = "")
{
	Q ""
}

Query Find(PatientID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID, DateOfBooking, Status, EdcAgreed, MidComm, PregType, Confidential")
{
SELECT 
PREG_RowId, 
PREG_DateOfBooking, 
PREG_Status->PREGST_Desc, 
PREG_EdcAgreed, 
PREG_MidCommTeam_DR->MIDCOMM_Desc, 
PREG_PregType,
PREG_Confidential
FROM SQLUser.PA_Pregnancy
WHERE PREG_Person_DR = :PatientID
}

Query FindByPatient(PatientID As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PREGDateOfBooking,Status,EdcAgreed,MidCommTeam,PregType,Confidential,TotalBabies,FirstDeliveryDate,FirstDeliveryTime,ModeOfDelivery,BabyOutcome,ComplicationsExist")
{
}

Query FindDelMthd(babyID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DLMTHDesc")
{
SELECT PDBDM_DelMthd_DR->DLMTH_Desc
FROM SQLUser.PA_PrDelBabyDelMthd 
WHERE PDBDM_ParRef = :babyID
}

Query FindEpisodes(PatientID As %Library.String = "", PAPregnancyID As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PAADMMainMRADMDR,PAADMADMNo:%Library.String,PAADMAdmDate:%Library.Date,PAADMAdmTime:%Library.Time,PAADMDepCodeDRDesc:%Library.String")
{
SELECT PAADM_RowID, PAADM_MainMRADM_DR, PAADM_ADMNo, PAADM_AdmDate, PAADM_AdmTime, PAADM_DepCode_DR->CTLOC_Desc
FROM SQLUser.PA_Adm
WHERE (PAADM_PAPMI_DR = :PatientID) AND (PAADM_Pregnancy_DR = :PAPregnancyID)
ORDER BY PAADM_AdmDate, PAADM_AdmTime
}

/// 35639: Change functionality of how episodes are attached to Pregnancies
Query LookUpAgreedEDD(PatientID As %Library.String = "", TSRTITM As %Library.String, TSRTORD As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "EdcAgreed,Status,MidCommTeam,DateOfBooking,hidden")
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpAgreedEDDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAgreedEDDFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpAgreedEDDExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, TSRTITM As %Library.String, TSRTORD As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpAgreedEDDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAgreedEDDExecute ]
{
}

Query GetOpenPregnancy(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PREG_DateOfBooking,PREG_EdcAgreed,PREGST_Desc,MIDCOMM_Desc")
{
SELECT PREG_RowId,PREG_DateOfBooking,PREG_EdcAgreed,PREG_Status->PREGST_Desc,
PREG_MidCommTeam_DR->MIDCOMM_Desc 
FROM SQLUser.PA_Pregnancy
WHERE (PREG_Person_DR->PAPER_RowId = :PatientID)
AND PREG_PregType = 'Medtrak' AND PREG_Status->PREGST_Code = 'O'
}

}
