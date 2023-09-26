/// <H3>综合检测主函数</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-07-30</H4>
Class DHCMed.CCService.IntegratedControl.Control Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  就诊号取监控列表数据
/// Return:       $lb() 或 ""
ClassMethod BuildCtrlData(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="BuildCtrlDataErr"
	Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,PersonalID)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc,AdmWard,AdmRoom,AdmBed,AdmDoc,AdmDays)=""
	Set objPaadm=##Class(User.PAAdm).%OpenId(argPaadm)
	Quit:'$IsObject(objPaadm) return
	Do objPaadm.%Close()
    If $IsObject(objPaadm.PAADMPAPMIDR)
    {
	    Set objPatient=objPaadm.PAADMPAPMIDR
	    Set PatientID=objPatient.%Id()
	    //Set PapmiNo=objPatient.PAPMINo
	    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	    Set PatName=objPatient.PAPMIName
	    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
	    Set Birthday=objPatient.PAPMIDOB
	    Set:Birthday'="" Age=##Class(DHCMed.CCService.Sys.CommonSrv).CalAge(+Birthday,+$h)
	    Set:Birthday'="" Birthday=$zd(Birthday,3)
	    Set PersonalID=objPatient.PAPMIID
	}
	
    Set AdmitDate=objPaadm.PAADMAdmDate
    Set AdmitTime=objPaadm.PAADMAdmTime
    Set DisDate=objPaadm.PAADMDischgDate
    Set DisTime=objPaadm.PAADMDischgTime
    If DisDate'="" {
	    Set AdmDays=DisDate-AdmitDate
    } Else {
		Set AdmDays=+$h-AdmitDate
	}
    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
    Set:DisDate'="" DisDate=$zd(DisDate,3)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
    If $IsObject(objPaadm.PAADMDepCodeDR)
    {
	    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
	    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	}
    If $IsObject(objPaadm.PAADMCurrentWardDR)
    {
	    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
	    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	}
	If $IsObject(objPaadm.PAADMCurrentRoomDR)
	{
		Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
	}
	If $IsObject(objPaadm.PAADMCurrentBedDR)
	{
		Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
	}
	If $IsObject(objPaadm.PAADMAdmDocCodeDR)
	{
		Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
	}
	
	Set InfTypes=""
	//旧医院感染报告检查
	Set RepID=0,OInfCount=0
	For {
		Set RepID=$o(^DHCMedIR(0,"PAADM",argPaadm,RepID))
		Quit:RepID=""
		Set RepStatus=$p($g(^DHCMedIR(RepID)),"^",11)
		Continue:RepStatus["0"  //删除和被订报告过滤掉
		Set OInfCount=OInfCount+1
	}
	Set:OInfCount>0 InfTypes=InfTypes_"医院感染报告:"_OInfCount_"份;"_$c(1)
	//新医院感染报告检查
	Set RepID=0,NInfCount=0
	Set:NInfCount>0 InfTypes=InfTypes_"医院感染报告:"_NInfCount_"份;"_$c(1)
	//ICU监测报告检查
	Set RepID=0,ICUCount=0
	Set:ICUCount>0 InfTypes=InfTypes_"ICU监测报告:"_ICUCount_"份;"_$c(1)
	//手术切口报告检查
	Set RepID=0,OperCount=0
	Set:OperCount>0 InfTypes=InfTypes_"手术切口报告:"_OperCount_"份;"_$c(1)
	
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(argPaadm)
	
	//就诊信息
	Set Data=$lb(argPaadm)
    Set Data=Data_$lb(PatientID)
    Set Data=Data_$lb(PapmiNo)
    Set Data=Data_$lb(PatName)
    Set Data=Data_$lb(Sex)
    Set Data=Data_$lb(Birthday)
    Set Data=Data_$lb(Age)
    Set Data=Data_$lb(PersonalID)
	Set Data=Data_$lb(AdmitDate)
	Set Data=Data_$lb(AdmitTime)
	Set Data=Data_$lb(DisDate)
	Set Data=Data_$lb(DisTime)
	Set Data=Data_$lb(AdmLoc)
	Set Data=Data_$lb(AdmWard)
	Set Data=Data_$lb(AdmRoom)
	Set Data=Data_$lb(AdmBed)
	Set Data=Data_$lb(AdmDoc)
	Set Data=Data_$lb(AdmDays)
	Set Data=Data_$lb(InfTypes)
	Set Data=Data_$lb(MRAdm)
    
    Set return=Data
	Quit return
	
BuildCtrlDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  组织监控明细数据
/// Return:       字符串
ClassMethod BuildCtrlDtl(argCtrlDtls As %ListOfObjects) As %List
{
	New (argCtrlDtls)
	Set repid1=$i(^CacheTemp)
	Set return=""
	Set Count=argCtrlDtls.Count()
	For i=1:1:Count
	{
		Set objResult=argCtrlDtls.GetAt(i)
		Set ^CacheTemp(repid1,objResult.KeyWord)=""
	}
	
	Set KeywordID=""
	For
	{
		Set KeywordID=$o(^CacheTemp(repid1,KeywordID))	
		Quit:KeywordID=""
		Set objKeyword=##class(DHCMed.CC.KeyWord).%OpenId(KeywordID)
		Continue:$IsObject(objKeyword)=0
		Set return=return_objKeyword.ToString()_$c(1)
		For i=1:1:Count
		{
			Set objResult=argCtrlDtls.GetAt(i)
			Continue:objResult.KeyWord'=KeywordID
			Quit:i>3
			Set return=return_objResult.ToString()
			Set return=return_$c(1)
		}		
	}
	Kill ^CacheTemp(repid1)
	Quit $lb(return)
}

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  住院患者监控(包括:在院、出院)
/// Input：       Status(在院/出院),DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区),Ctrls(监控项目列表)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.IntegratedControl.Control","QryByPaadm","I","","","","","15/16/17/18/19/20/21/22/23/24/25/26/27/28/",2)
Query QryByPaadm(argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,InfTypes:%String,MRAdm:%String,Score:%String,CtrlDtl:%String,EvalInfo:%String,FeedbackTimes:%String,AcceptTimes:%String,RejectTimes:%String,NoReponseTimes:%String,LastSummaryID:%String")
{
}

ClassMethod QryByPaadmExecute(ByRef qHandle As %Binary, argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argCtrls="" $$$OK
	Quit:(argStatus'="I")&&(argStatus'="O") $$$OK
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argStatus="O")&&((argDateFrom="")||(argDateTo="")) $$$OK
	//Quit:(argStatus="I")&&(argLocID="")&&(argWardID="") $$$OK
	
	If argStatus="I" {
		Set PACWardID=0
		For {
			Set PACWardID=$o(^PAADMi("CurrWard",PACWardID))
			Quit:PACWardID=""
			Set WardID=$p($g(^PAWARD(PACWardID)),"^",5)
			Continue:(argWardID'="")&&(argWardID'=WardID)
			Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",+WardID))
			Set aRoom=""
			For {
				Set aRoom=$o(^PAADMi("CurrWard",PACWardID,aRoom))
				Quit:aRoom=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAADMi("CurrWard",PACWardID,aRoom,Paadm))
					Quit:Paadm=""
					Set AdmInfo=$g(^PAADM(Paadm))
					Continue:$p(AdmInfo,"^",2)'="I"                 //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
					Set AdmDate=$p($g(^PAADM(Paadm)),"^",6)
					Continue:(argDateFrom'="")&&(AdmDate<argDateFrom)
					Continue:(argDateTo'="")&&(AdmDate>argDateTo)
					Set arryDetail=##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultList(Paadm,argSubjectID,argCtrls,"","")
					Continue:arryDetail.Count()=0 //没有任何触发项目
					Set Score=0
					For i=1:1:arryDetail.Count()
					{
						Set objResult=arryDetail.GetAt(i)
						Set Score=Score+objResult.Score	
					}
					Continue:Score'>0 //零分的刨除
					If arryDetail.Count()>0 {
						Set DataDetail=..BuildCtrlDtl(arryDetail)
					}Else{
						Set DataDetail=$lb("")
					}
					Set Data=..BuildCtrlData(Paadm)
					Continue:Data=""
					Set EvalInfo=##Class(DHCMed.CCService.Ctrl.Evaluation).GetEvalInfo(argSubjectID,Paadm)
					Set strFeedbackTimes=##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(Paadm,argSubjectID)
					Set TotalTimes=$p(strFeedbackTimes,"^",1)
					Set AcceptTimes=$p(strFeedbackTimes,"^",2)
					Set RejectTimes=$p(strFeedbackTimes,"^",3)
					Set NoResponseTimes=$p(strFeedbackTimes,"^",4)
					Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",Paadm,argSubjectID,""),-1)
					Set Data=Data_$lb(Score)_DataDetail_$lb(EvalInfo)_$lb(TotalTimes,AcceptTimes,RejectTimes,NoResponseTimes,LastSummaryID)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}ElseIf argStatus="O"{
		Set DischDate=argDateFrom-1
		For {
			Set DischDate=$o(^PAADMi("DischDate",DischDate))
			Quit:(DischDate="")||(DischDate>argDateTo)
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("DischDate",DischDate,Paadm))
				Quit:Paadm=""
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"                 //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
				Set AdmLoc=$p(AdmInfo,"^",4)
				Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
				Set AdmWard=$p(AdmInfo,"^",70)
				Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
				Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
				Set arryDetail=##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultList(Paadm,argSubjectID,argCtrls,"","")
				Continue:arryDetail.Count()=0 //没有任何触发项目
				Set Score=0
				For i=1:1:arryDetail.Count()
				{
					Set objResult=arryDetail.GetAt(i)
					Set Score=Score+objResult.Score	
				}
				Continue:Score'>0 //零分的刨除				
				If arryDetail.Count()>0 {
					Set DataDetail=..BuildCtrlDtl(arryDetail)
				}Else{
					Set DataDetail=$lb("")
				}
				Set Data=..BuildCtrlData(Paadm)
				Continue:Data=""
				Set EvalInfo=##Class(DHCMed.CCService.Ctrl.Evaluation).GetEvalInfo(argSubjectID,Paadm)
				Set strFeedbackTimes=##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(Paadm,argSubjectID)
				Set TotalTimes=$p(strFeedbackTimes,"^",1)
				Set AcceptTimes=$p(strFeedbackTimes,"^",2)
				Set RejectTimes=$p(strFeedbackTimes,"^",3)
				Set NoResponseTimes=$p(strFeedbackTimes,"^",4)
				Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",Paadm,argSubjectID,""),-1)
				Set Data=Data_$lb(Score)_DataDetail_$lb(EvalInfo)_$lb(TotalTimes,AcceptTimes,RejectTimes,NoResponseTimes,LastSummaryID)			
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByPaadmExecute ]
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

}
