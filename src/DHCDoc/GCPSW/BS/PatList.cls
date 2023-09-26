/// CTOR: QP
/// DATE: 2020-11-13
/// DESC: 临床药理患者明细
Class DHCDoc.GCPSW.BS.PatList Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-11-18
/// DESC: 查询药理就诊明细
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.BS.PatList","QryGCPAdmList","","",^QP("hh"))
Query QryGCPAdmList(PPRowId = "", PatientID = "", PList = "") As %Query(ROWSPEC = "PPRowId,PPPID,PPPAID,admid,PapmiDr,mradm,PPCode,PPDesc,CreateLoc,StartUser,PatientNo,PatientName,Sex,Age,OAdmDate,InHospDate,OutHospDate,Diagnosis,MainNote,LastPPCode,LastPPDesc,LastICFDate,LastOutDate")
{
}

ClassMethod QryGCPAdmListExecute(ByRef qHandle As %Binary, PPRowId = "", PatientID = "", PList = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s ^QP("hh")=PList
 	s maxNum=1000,num=0
 	i PPRowId="" {
	 	s PPRowId=0
		f  s PPRowId=$o(^DHCDocPP(PPRowId)) Q:PPRowId=""  d
		.s sub=0
		.f  s sub=$o(^DHCDocPPP(PPRowId,sub)) q:sub=""  d
		..s PapmiDr=$p(^DHCDocPPP(PPRowId,sub),"^",1)
		..q:(PatientID'="")&&(PatientID'=PapmiDr)
		..s id=0
		..f  s id=$o(^DHCDocPPPA(PPRowId,sub,id)) q:id=""  d
		...s admid=$p(^DHCDocPPPA(PPRowId,sub,id),"^",1)
		...;s num=num+1
		...;q:num>maxNum
		...d GetAdmInfo
		
	} else {
		s sub=0
		f  s sub=$o(^DHCDocPPP(PPRowId,sub)) q:sub=""  d
		.s PapmiDr=$p(^DHCDocPPP(PPRowId,sub),"^",1)
		.q:(PatientID'="")&&(PatientID'=PapmiDr)
		.s id=0
		.f  s id=$o(^DHCDocPPPA(PPRowId,sub,id)) q:id=""  d
		..s admid=$p(^DHCDocPPPA(PPRowId,sub,id),"^",1)
		..d GetAdmInfo
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetAdmInfo
	s PPPID=PPRowId_"||"_sub
	s PPPAID=PPRowId_"||"_sub_"||"_id
	s IsExit=..FilterCondition(PPRowId,PapmiDr,admid,PPPAID,PList)
	q:IsExit=1
	s num=num+1
	q:num>maxNum
	s JoinDate=$p(^DHCDocPPPA(PPRowId,sub,id),"^",5)
	s PPCode=$p($g(^DHCDocPP(PPRowId)),"^",1)	;项目编号
	s PPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)	;药物/医疗器械名称
 	s CreateLoc=$p(^DHCDocPP(PPRowId),"^",6)	;立项科室
 	i CreateLoc'="" s CreateLoc=$P(^CTLOC(CreateLoc),"^",2)
 	i CreateLoc["-" s CreateLoc=$p(CreateLoc,"-",2)
 	s StartUser=$p($g(^DHCDocPP(PPRowId)),"^",10)
	i StartUser'="" s StartUser=$p(^SSU("SSUSR",StartUser),"^",2)	;主要研究者
	s PatientNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)	;受试者ID
	s PatientName=$p(^PAPER(PapmiDr,"ALL"),"^",1)	;受试者姓名
 	s Sex=$p(^PAPER(PapmiDr,"ALL"),"^",7)	;受试者性别
 	i Sex'="" s Sex=$p(^CT("SEX",Sex),"^",2)
 	s Age=##class(web.DHCSTKUTIL).GetAge(PapmiDr)	;受试者年龄
 	s mradm=$P($g(^PAADM(admid)),"^",61)
 	s AdmType=$p(^PAADM(admid),"^",2)
 	s OAdmDate=""		;门诊就诊日期
 	s InHospDate=""		;住院日期
 	s OutHospDate=""	;出院日期
 	i AdmType="O" {
	 	s OAdmDate=$P(^PAADM(admid),"^",6)
	 	s OAdmDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(OAdmDate)
 	}
 	i AdmType="I" {
		s OutHospDate=$p($g(^PAADM(admid)),"^",17) 
		s InHospDate=$p($g(^PAADM(admid,"DHC")),"^",31)
		//s inHospTime=$p($g(^PAADM(admid,"DHC")),"^",32)
		s OutHospDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(OutHospDate)
		s InHospDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(InHospDate)
	}
 	s Diagnosis=##class(DHCDoc.GCPSW.BS.Adm).GetMRAdmDiagnosis(mradm)		;诊断
 	s MainNote=""		;主诉
 	s LastInfo=..GetLastGCPInfo(PPRowId,PapmiDr,admid)
 	s LastPPCode=$p(LastInfo,"^",1)	;最近一次临床试验项目编号
 	s LastPPDesc=$p(LastInfo,"^",2)	;最近一次临床试验方案名称
 	s LastICFDate=$p(LastInfo,"^",3)	;最近一次临床试验签署ICF日期
 	s LastOutDate=$p(LastInfo,"^",4)	;最近一次临床试验出组日期
 	
 	Set Data=$lb(PPRowId,PPPID,PPPAID,admid,PapmiDr,mradm,PPCode,PPDesc,CreateLoc,StartUser,PatientNo,PatientName,Sex,Age,OAdmDate,InHospDate,OutHospDate,Diagnosis,MainNote,LastPPCode,LastPPDesc,LastICFDate,LastOutDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryGCPAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGCPAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGCPAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGCPAdmListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 查询药理项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.BS.PatList","QryGCP")
Query FindProPatByUser(CardTypeDefine, CardNo, PatientNo, PatName, StartDate, EndDate, UserID, UserLoc, PPRowId, All, PPStatus As %String = "") As %Query(ROWSPEC = "PPRowId:%String,PPPRowId:%String,PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,AddProDate:%String,AddProTime:%String,AddProUser:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,PAAdmReason:%String,Diagnosis:%String,CancelDate:%String,Age:%String,ProPatReMark:%String,CancelUser:%String,CancelReason:%String,TPPDesc:%String,PatStatus:%String,PPPAgreementDate:%String,ScreenNo:%String,VisitState:%String,StageDr,Stage")
{
}

ClassMethod FindProPatByUserExecute(ByRef qHandle As %Binary, CardTypeDefine, CardNo, PatientNo, PatName, StartDate, EndDate, UserID, UserLoc, PPRowId, All, PPStatus As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	kill ^TempFindProPatByUser($j)
	s ProStartUserDr=""
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProPat","FindProPatByUser","","","","",63137,"",4175,194)
    s CardTypeDefine=$get(CardTypeDefine),CardNo=$get(CardNo),PatientNo=$get(PatientNo),PatName=$get(PatName),StartDate=$get(StartDate),EndDate=$get(EndDate),UserID=$get(UserID),UserLoc=$get(UserLoc)
	if UserID="" Set UserID=%session.Get("LOGON.USERID")
	if UserID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	if UserLoc="" Set UserLoc=%session.Get("LOGON.CTLOCID")
	s UserLocHospDr=$p(^CTLOC(UserLoc),"^",22)
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	d ##class(web.PilotProject.DHCDocPilotService).TransPilotPatToInPatient(UserID,UserLoc)
	s SuperDepRowId=1	;##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("SuperDepRowId")
	if (PPRowId=""){
		if SuperDepRowId=UserLoc {
			s All=""
			s UserProStr=..GetAllProStr()
		}else{
			s UserProStr=..GetUserProStr(UserID)
		}
	}
	i PPRowId'=""  s UserProStr=PPRowId
	if CardNo'="" {
		if (CardTypeDefine="") s CFRowId=$O(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
		else  s CFRowId=$O(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDefine,CardNo,""))
		if CFRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
		
		s PatientID=$p(^DHCCARD("CF",CFRowId),"^",4)
		d PatientIDFindPro
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	/****按登记号查询*****/
	if PatientNo'="" {
		s PatientNo=$e("000000000000000",1,8-$l(PatientNo))_PatientNo
		s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
		if PatientID'="" d PatientIDFindPro
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	/****按姓名查询*****/
	if PatName'="" {
		s Qflag="N"
		s name0=$$ALPHAUP^SSUTIL4(PatName)
		;先找全名
		Set PatientID=0
		For  Set PatientID=$O(^PAPERi("PAPER_PatName",name0,PatientID)) Quit:PatientID=""  Do
		.Do PatientIDFindPro
		
		For  Set name0=$O(^PAPERi("PAPER_PatName",name0)) Quit:(name0="")!(Qflag="Y")  Do
		.If $e(name0,1,$l(PatName))'[$$ALPHAUP^SSUTIL4(PatName) d
		..Set Qflag="Y" 
		.Quit:Qflag="Y"
		.Set PatientID=0
		.For  Set PatientID=$O(^PAPERi("PAPER_PatName",name0,PatientID)) Quit:PatientID=""  Do
		..Do PatientIDFindPro
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	/****按开始日期和结束日期查询*****/
	if StartDate'="" {
		if EndDate="" s EndDate=+$H
		if StartDate>EndDate Set qHandle=$lb(0,repid,0) Quit $$$OK
		for CurDate=StartDate:1:EndDate {
			s CurPPRowId=0
			for {
				s CurPPRowId=$O(^DHCDocPPP("CreateDate",0,CurDate,CurPPRowId))
				Q:CurPPRowId=""
				s CurPPPRowId=0
				for {
					s CurPPPRowId=$O(^DHCDocPPP("CreateDate",0,CurDate,CurPPRowId,CurPPPRowId))
					Q:CurPPPRowId=""
					s PatientID=$p(^DHCDocPPP(CurPPRowId,CurPPPRowId),"^",1)
					s VisitState=$p(^DHCDocPPP(CurPPRowId,CurPPPRowId),"^",2)
			        if PPStatus="" {
				      continue:((VisitState'="N")&& (VisitState'="R"))
			        }else{
				      continue:(VisitState'=PPStatus)
			        }
			        i CurPPRowId="1" b //5
					d PatientIDFindPro
				}
			}
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;输出当前用户可见项目的所有病人
	for i=1:1:$l(UserProStr,"^") {
		s PPRowId=$p(UserProStr,"^",i)
		if PPRowId="" continue
		Set CreateProLoc=$p($g(^DHCDocPP(PPRowId)),"^",6)
		Set ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
		Set ProStartDate=$p($g(^DHCDocPP(PPRowId)),"^",11)
		Set ProEndDate=$p($g(^DHCDocPP(PPRowId)),"^",13)
		Set ProState=$p($g(^DHCDocPP(PPRowId)),"^",16)
		;if ((ProStartDate>=+$H)&&(ProStartDate'=""))||((ProEndDate<=+$H)&&(ProEndDate'=""))||(ProState'="N") continue
		s PPPRowId=0
		for {
			s PPPRowId=$O(^DHCDocPPP(PPRowId,PPPRowId))
			Q:PPPRowId=""
			s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
			if PPStatus="" {
				//continue:((VisitState'="N")&& (VisitState'="R"))
			}else{
				continue:(VisitState'=PPStatus)
			}
			s AddProPatUser=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",5)
			s AddProPatLoc=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",4)
			;if ((AddProPatLoc'=UserLoc)||(AddProPatUser'=UserID))&&(ProStartUserDr'=UserID) continue
			s ^gry("PPRowId",PPRowId,PPPRowId)=CreateProLoc_","_UserLoc_"^"_AddProPatUser_","_UserID
			s PatientID=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
			d OutputRow
		}
	}
	kill ^TempFindProPatByUser($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PatientIDFindPro
    ;必须已经得到PatientID、UserProStr
    s PPRowId=0
	for {
		s PPRowId=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowId))
		Q:PPRowId=""
		if ("^"_UserProStr_"^")'[("^"_PPRowId_"^") continue
		Set CreateProLoc=$p($g(^DHCDocPP(PPRowId)),"^",6)
		Set ProStartDate=$p($g(^DHCDocPP(PPRowId)),"^",11)
		Set ProEndDate=$p($g(^DHCDocPP(PPRowId)),"^",13)
		Set ProState=$p($g(^DHCDocPP(PPRowId)),"^",16)
		;if ((ProStartDate>+$H)&&(ProStartDate'=""))||((ProEndDate>+$H)&&(ProEndDate'=""))||(ProState'="N") continue
		
		s PPPRowId=0
		for {
			s PPPRowId=$o(^DHCDocPPP(PPRowId,PPPRowId))
			Q:PPPRowId=""
			s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
			//if ((VisitState'="N")&& (VisitState'="R")) continue 
			s AddProPatUser=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",5)
			s AddProPatLoc=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",4)
			s ProPatCreate=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",6)
			//20150402 portal查询已结题的患者 是传入日期的
			continue:((StartDate'="")&&(ProPatCreate<StartDate))||((EndDate'="")&&(ProPatCreate>EndDate))
			s PapmiDr=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
			if PapmiDr'=PatientID continue
			d OutputRow
		}
	}
    
    Q
OutputRow
	;Do ResetVariables
	Set PAAdm=..GetActiveProPatAdmID(PPRowId,PPPRowId,UserLoc)
	if PAAdm="" s PAAdm=..GetLastProPatAdmID(PPRowId,PPPRowId)
	Q:PAAdm=""
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PAAdm)
	;Q:UserLocHospDr'=AdmHospitalId
	Set EpisodeID=PAAdm
	Set mradm=$P($g(^PAADM(PAAdm)),"^",61)
	Set Loc=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",4)
	Set PAPMINO=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
	Set PAPMIName=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set Age=$fn((+$H-DobDate)/365,"",0)
	Else  Do
	.Set PAPMIDOB="",Age=""
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,PAAdm,UserLocHospDr)
	Set Sex=$P($g(^PAPER(PatientID,"ALL")),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Else  Set PAPMISex=""
	Set AddProDate=##class(websys.Conversions).DateLogicalToHtml($P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",6)) //$ZD($P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",6),3)
	Set AddProTime=$ZT($P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",7),3)
	Set AddProUserDr=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",5)
	Set AddProUser=""
	if AddProUserDr'="" s AddProUser=$p($g(^SSU("SSUSR",AddProUserDr)),"^",2)
	s AddProUser=$tr(AddProUser,$C(13,10),"")
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Q:(All'="")&&(All'="I")&&(PAAdmType="I")
	Q:(All'="")&&(All="I")&&(PAAdmType'="I")
	;q:$d(^PAC("ADMLOC",0,"AdmType","O",%session.Get("LOGON.CTLOCID")))&&(PAAdmType="I")&&(All'="on")
	;q:'$d(^PAC("ADMLOC",0,"AdmType","O",%session.Get("LOGON.CTLOCID")))&&(PAAdmType="O")&&(All'="on")
	Set Hospital=""
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set Ward=$P($g(^PAADM(PAAdm)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	
	s CancelDate="",CancelUser="",CancelReason=""
	s VisitStatus=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",2)
	i " C R "[(" "_VisitStatus_" ") {
		Set CancelDate=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",8)
		if CancelDate'="" Set CancelDate=##class(websys.Conversions).DateLogicalToHtml(CancelDate) //$ZD(CancelDate,3)
		Set CancelUserDr=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",16)
		if CancelUserDr'="" s CancelUser=$p($g(^SSU("SSUSR",CancelUserDr)),"^",2)
		Set CancelReason=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",11)
	}
	set PPPAgreementDate=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",12)
	if PPPAgreementDate'="" Set PPPAgreementDate=##class(websys.Conversions).DateLogicalToHtml(PPPAgreementDate) //$ZD(PPPAgreementDate,3)
	If $g(mradm)'="" Set Diagnosis=##class(web.DHCDocOutPatientList).GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	Set ProPatReMark=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",10)
    s TPPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
    ;i VisitState="R" s EpisodeID=""
    if VisitState="R"  s PatStatus="退出"
    else  if VisitState="N" s PatStatus="在组"
    else  if VisitState="C" s PatStatus="取消"
    else  if VisitState="O" s PatStatus="完成"
    else  s PatStatus=VisitState
	Q:$d(^TempFindProPatByUser($j,PPPRowId,PatStatus))
    s ScreenNo=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",17)
    s StageDr=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",18)
    s Stage=""
    i StageDr'="" {
	    s StageDic=$P(^CF.DOC.Pilot.ProjectStageD(StageDr),"^",2)
	    s Stage=$p(^CF.DOC.Pilot.OEStageD(StageDic),"^",1)
    }
	set Data=$lb(PPRowId,PPPRowId,PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,AddProDate,AddProTime,AddProUser,PAAdmType,Hospital,PAAdmWard,PAAdmBed,PAAdmReason,Diagnosis,CancelDate,Age,ProPatReMark,CancelUser,CancelReason,TPPDesc,PatStatus,PPPAgreementDate,ScreenNo,VisitState,StageDr,Stage)
 	s ^TempFindProPatByUser($j,PPRowId,PPPRowId,PatStatus)=1
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
ResetVariables
    Set (PPRowId,PPPRowId,PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,AddProDate,AddProTime,AddProUser,PAAdmType,Hospital,PAAdmWard,PAAdmBed,PAAdmReason,Diagnosis,CancelDate,Age,ProPatReMark,CancelUser,CancelReason,TPPDesc,PatStatus,ScreenNo,VisitState)=""
    Quit
}

ClassMethod FindProPatByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProPatByUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
		//
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindProPatByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProPatByUserExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLastProPatAdmID(PPRowId As %String, PPPRowId As %String, UserLoc As %String = "") As %String
{
	s LocType=""
	i UserLoc'="" {
		s ADMLOCID=""
		for {
			s ADMLOCID=$O(^PAC("ADMLOC",ADMLOCID)) Q:ADMLOCID=""
			s CTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",2)
			continue:UserLoc'=CTLOCDR
			s ADMLOCType=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",1)
			s LocType=ADMLOCType
			quit
		}
	}
	if LocType'="" {
		i LocType'="I" s LocType="O"
	}
	s PPPARowId="",FindAdmID=""
	for {
		s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),-1)
		Q:PPPARowId=""
		s PAAdmRowId=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
		s ActiveFlag=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",4)
		s PAAdmType=$p(^PAADM(PAAdmRowId),"^",2)
		i PAAdmType'="I" s PAAdmType="O"
		continue:(LocType'="")&&(LocType'=PAAdmType)
		s FindAdmID=PAAdmRowId
		Q:FindAdmID'=""
	}
	
	Q FindAdmID
}

ClassMethod GetActiveProPatAdmID(PPRowId As %String, PPPRowId As %String, UserLoc As %String = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetActiveProPatAdmID(2,1)
	s FindAdmID=""
	s ActiveProPatAdm=..GetActiveProPatAdm(PPRowId,PPPRowId,UserLoc)
	i ActiveProPatAdm'="" {
		s FindAdmID=$p(^DHCDocPPPA(+ActiveProPatAdm,$p(ActiveProPatAdm,"||",2),$p(ActiveProPatAdm,"||",3)),"^",1)
	}
	
	Q FindAdmID
}

ClassMethod GetActiveProPatAdm(PPRowId As %String, PPPRowId As %String, UserLoc As %String = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetActiveProPatAdmID(2,1)
	;如果传入科室UserLoc不为空,则只找和此科室同类型(门诊/住院)的有效记录
	s LocType=""
	i UserLoc'="" {
		s ADMLOCID=""
		for {
			s ADMLOCID=$O(^PAC("ADMLOC",ADMLOCID)) Q:ADMLOCID=""
			s CTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",2)
			continue:UserLoc'=CTLOCDR
			s ADMLOCType=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",1)
			s LocType=ADMLOCType
			quit
		}
	}
	if LocType'="" {
		i LocType'="I" s LocType="O"
	}
	
	s PPPARowId="",ProPatAdm=""
	for {
		s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),-1)
		Q:PPPARowId=""
		s PAAdmRowId=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
		s ActiveFlag=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",4)
		if ActiveFlag'="Y" continue
		s PAAdmType=$p($g(^PAADM(PAAdmRowId)),"^",2)
		i PAAdmType'="I" s PAAdmType="O"
		continue:(LocType'="")&&(LocType'=PAAdmType)
		s ProPatAdm=PPRowId_"||"_PPPRowId_"||"_PPPARowId
		Q:ProPatAdm'=""
	}
	
	Q ProPatAdm
}

ClassMethod GetUserProStr(UserID As %String) As %String
{
	s UserProStr=""
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPP(PPRowId))
		Q:PPRowId=""
		s sflag=0
		s cflag=0
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	i ProStartUserDr=UserID s sflag=1
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	i UserUserDr=UserID s sflag=1
	s child=0
	for{
		 s child=$o(^DHCDocPPD(PPRowId,child))
		 q:child=""  
	s ProStartUserDr1=""
	s UserUserDr1=""
	s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	i (((UserID=ProStartUserDr1)||(UserID=UserUserDr1))&&(UserID'=""))  s sflag=1	
	}	
		
		s PPCRowId=0,FindPPC=""
		for {
			s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId))
			Q:PPCRowId=""
			s JionUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
			s State=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",5)
			if State'="N" continue
			s StartDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",6)
			s EndDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",7)
			if ((StartDate>+$h)&&(StartDate'=""))||((EndDate<+$h)&&(EndDate'="")) continue
			if (JionUserDr=UserID) s cflag=1
			;Q:FindPPC'=""
		}
		if ((cflag=1)||(sflag=1)){
		if (UserProStr="") s UserProStr=PPRowId
		else   s UserProStr=UserProStr_"^"_PPRowId
		}
	}
	
	Q UserProStr
}

ClassMethod GetAllProStr() As %String
{
	s AllProStr=""
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPP(PPRowId))
		Q:PPRowId=""
		s State=$p(^DHCDocPP(PPRowId),"^",16)
		if " N A S V "'[(" "_State_" ") continue
		if (AllProStr="") s AllProStr=PPRowId
		else  s AllProStr=AllProStr_"^"_PPRowId
	}
	
	Q AllProStr
}

/// CTOR: QP
/// DATE: 2020-11-19
/// DESC: 获取最近一次临床试验信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.PatList).GetLastGCPInfo(756,3803881,11383094)
ClassMethod GetLastGCPInfo(PPRowId = "", PatientID = "", EpisodeID = "")
{
	s mRtn=""
	Q:(PatientID="")||(PPRowId="") mRtn
	s PID="",LastPID="",Stop=0
	f  s PID=$O(^DHCDocPPP("PapmiDr",0,PatientID,PID)) Q:(PID="")||(Stop=1)  d
	.i PID=PPRowId  s Stop=1
	.Q:Stop=1
	.s LastPID=PID
	
	Q:Stop=0 mRtn	;没有找到
	Q:LastPID="" mRtn	;没有上一次临床试验信息
	s sub=$o(^DHCDocPPP("PapmiDr",0,PatientID,LastPID,""))
	Q:sub="" mRtn
	
	s PPCode=$p($g(^DHCDocPP(LastPID)),"^",1)	;项目编号
	s PPDesc=$p($g(^DHCDocPP(LastPID)),"^",2)	;药物/医疗器械名称
	s ICFDate=""								;临床试验签署ICF日期
	s Status=$p(^DHCDocPPP(LastPID,sub),"^",2)	;
	s OutDate=""
	i Status'="N" {
		s OutDate=$p(^DHCDocPPP(LastPID,sub),"^",8)
		s OutDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(OutDate)	
	}
	s mRtn=PPCode_"^"_PPDesc_"^"_ICFDate_"^"_OutDate
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-19
/// DESC: 过滤条件
/// IN  : 
/// OUT : 1:需要过滤，0：无需过滤
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml("")
ClassMethod FilterCondition(PPRowId, PapmiDr, admid, PPPAID, PList)
{
	//s ^QP("hh")=$lb()
	s EXIT=1,NO=0
	;解析参数
	s PListJson = ##class(ext.util.JsonObject).FromJSON(PList)
	s StartDate=PListJson.GetValue("StartDate")
	s EndDate=PListJson.GetValue("EndDate")
	s StartDate=##class(DHCDoc.GCPSW.COM.Func).DateHtmlToLogical(StartDate)
	s EndDate=##class(DHCDoc.GCPSW.COM.Func).DateHtmlToLogical(EndDate)
	s PPCode=PListJson.GetValue("PPCode")
	s PPDesc=PListJson.GetValue("PPDesc")
	s PI=PListJson.GetValue("PI")
	s PatNo=PListJson.GetValue("PatNo")
	s PatName=PListJson.GetValue("PatName")
	;基本信息
	s sub=$p(PPPAID,"||",2)
	s id=$p(PPPAID,"||",3)
	s JoinDate=$p(^DHCDocPPPA(PPRowId,sub,id),"^",5)
	s Code=$p($g(^DHCDocPP(PPRowId)),"^",1)		;项目编号
	s Desc=$p($g(^DHCDocPP(PPRowId)),"^",2)		;药物/医疗器械名称
 	s CreateLoc=$p(^DHCDocPP(PPRowId),"^",6)	;立项科室
 	s StartUser=$p($g(^DHCDocPP(PPRowId)),"^",10)
 	s PatientNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)	;受试者ID
	s PatientName=$p(^PAPER(PapmiDr,"ALL"),"^",1)	;受试者姓名
	;过滤操作
	i PPPAID="1832||1"  b ;00222
	Q:(StartDate'="")&&(JoinDate<StartDate) EXIT
	Q:(EndDate'="")&&(JoinDate>EndDate) EXIT
	Q:(PPCode'="")&&(Code'[PPCode) EXIT
	Q:(Desc'="")&&(Desc'[PPDesc) EXIT
	Q:(PI'="")&&(PI'=StartUser) EXIT
	Q:(PatName'="")&&(PatientName'[PatName) EXIT
	Q:(PatNo'="")&&(PatientNo'[PatNo) EXIT
	
	Q NO
}

}
