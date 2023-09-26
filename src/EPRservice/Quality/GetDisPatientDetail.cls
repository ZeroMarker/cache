Class EPRservice.Quality.GetDisPatientDetail Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Desc: 科室终末质控查询患者就诊列表
/// Debug: d ##class(%ResultSet).RunQuery("EPRservice.Quality.GetDisPatientDetail","GetDisProcedureList","U,F,B","","2022-09-01","2022-09-28","","","","191","","","","","2","","")
Query GetDisProcedureList(AType As %String, AYType As %String, Stdate As %String, Enddate As %String, AMedicareNo As %String, ARegNo As %String, AName As %String, ALocID As %String = "", ADocCommit As %String = "", ANurCommit As %String = "", APDFCreated As %String = "", SpecialAdm As %String = "", AHospitalID As %String = "", doctorID As %String = "", RcFlag As %String = "", AEpisodeID As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,AdmDateTime:%String,DisDateTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAADMReason:%String,Warddesc:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprNurStatus:%String,EprNurStatusDesc:%String,EprPdfStatus:%String,EprPdfStatusDesc:%String,ReviewStatus:%String,CheckStatus:%String,disReviewStatus,ProblemFlag,Illness,TransLocFlag,ResidentDays,QualityFlag,MainDiagnos,BedNo,Age,RCInfo,score")
{
}

ClassMethod GetDisProcedureListExecute(ByRef qHandle As %Binary, AType As %String, AYType As %String, Stdate As %String, Enddate As %String, AMedicareNo As %String, ARegNo As %String, AName As %String, ALocID As %String = "", ADocCommit As %String = "", ANurCommit As %String = "", APDFCreated As %String = "", SpecialAdm As %String = "", AHospitalID As %String = "", doctorID As %String = "", RcFlag As %String = "", AEpisodeID As %String = "") As %Status
{
	
    set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s MedicareNo = ""
	s PAADMRowID = ""
	s AdmDate = ""
	s LocID = ALocID
	s APAAdmStatus="D"

	if (AMedicareNo '="")
	{
		//病案号查询
		s PAPMIDR=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(AMedicareNo,"I","",.ErrMsg)
		q:(PAPMIDR="") $$$OK
		d GetPAADMRowID(LocID)
	}
	elseif (AName '="")
	{
		s AName=$zcvt($zstrip(AName,"*p"),"U")
		s Name=""
		for {
			s Name = $o(^PAPERi("PAPER_PatName",Name))	
			q:(Name="")
			continue:(Name'[AName)
			s PAPMIDR =""
			for {
				s PAPMIDR = $o(^PAPERi("PAPER_PatName",Name,PAPMIDR))
				q:(PAPMIDR="")
				d GetPAADMRowID(LocID)
			}
			}
	}
	elseif (ARegNo '="")
	{
		while ($l(ARegNo)<10)
		{
			if ($l(ARegNo)=10)
			{
				break	
			}
			s ARegNo="0"_ARegNo
			
		}
		s PAPMIDR = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		d GetPAADMRowID(LocID)
	}
	elseif (AEpisodeID'="")
	{
		S PAADMRowID=AEpisodeID
		d IsArrivedQue(LocID)
	}
	elseif ((Stdate '= "")&&(Enddate '= "")&&(APAAdmStatus="D"))
	{
		
		//出院患者按日期查询
		s StDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(Stdate)," ",1)
		s EndDate=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(Enddate)," ",1)
		for i = StDate:1:EndDate {
			s PAADMRowID = ""
			for {
				s PAADMRowID = $o(^PAADMi("DischDate",i,PAADMRowID))
				q:(PAADMRowID = "")
				s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
				continue:AdmType'="I"
				s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
				continue:(xse'="")
				s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			
				continue:(AdmStatus '= APAAdmStatus)
				d IsArrivedQue(LocID)
			}
		}			
	}
	Quit $$$OK
GetPAADMRowID(LocID)
    for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM","I",PAADMRowID))
		q:(PAADMRowID = "")
		s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
		continue:(AdmStatus '= APAAdmStatus)
		if (Stdate '= "")
		{
			s StDate = $zdh(Stdate,3)
			s AdmStdate = $P($g(^PAADM(PAADMRowID)),"^",17)
			
			continue:(AdmStdate < StDate)
		}
		if (Enddate '= "")
		{
			s EndDate=$zdh(Enddate,3)
			s AdmEndDate = $P($g(^PAADM(PAADMRowID)),"^",17)
			continue:(AdmEndDate > EndDate)
		}
		
		d IsArrivedQue(LocID)
		
	}
	Quit	
	
IsArrivedQue(LocID)
	s mCurrRow = $g(^PAADM(PAADMRowID))
	s PAADMDepCode=$p($g(mCurrRow),"^",4)

	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(LocID,",")
	q:($listlength(lstLocID) > 0)&&($listfind(lstLocID,PAADMDepCode) = 0)	
	s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
    q:(AHospitalID'="")&&(flag=0)
	s LocName=$p($g(^CTLOC(PAADMDepCode)),"^",2)
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
		s PAAdmDepCodeDR = $p(PAAdmDepCodeDR,"-",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	d outputrow
	Quit
outputrow	
	
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	s episodeID=PAADMRowID
	s admStatus = $p(^PAADM(episodeID),"^",20)
	
	s TerminallyIll = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("TerminallyIll")
	s DiseaseSeve = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("DiseaseSeve")
	s Salvage = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("Salvage")
	s BWYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,TerminallyIll,"")
	s BZYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,DiseaseSeve,"")
	s QJYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,Salvage,"")
	q:((SpecialAdm ["TerminallyIll")&&(BWYZ = ""))
	q:((SpecialAdm ["DiseaseSeve")&&(BZYZ = ""))
	q:((SpecialAdm ["Salvage")&&(QJYZ = ""))
	s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(PAADMRowID,"")
	q:((SpecialAdm ["OverAdm")&&(ResidentDays < 31))
	
	s name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	//s medRecordNo = $P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)
	s medRecordNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PAPMIDR,"I","",.ErrMsg)
	//s regNo=..AddZero(PAPMIDR)
	s regNo = $p($g(^PAPER(+PAPMIDR,"PAT",1)),"^",1)
	s paAdmDepID=PAADMDepCode
	
	s patientID = $p(^PAADM(episodeID),"^",1)
	s patDob = $p(^PAPER(patientID,"ALL"),"^",6)
	//s:(patDob '= "") patDob = $zd(patDob,3)
	s:(patDob '= "") patDob = ##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat(patDob,"Date","ChangeToFormat")
	s patSexDR = $p(^PAPER(patientID,"ALL"),"^",7)
	s patSex = $p(^CT("SEX",patSexDR),"^",2)
	
	s paAdmDate = $p(^PAADM(episodeID),"^",6)
	//s:(paAdmDate '= "") admDate = $zd(paAdmDate,3)
	s:(paAdmDate '= "") admDate = ##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat(paAdmDate,"Date","ChangeToFormat")
	s paAdmTime = $p(^PAADM(episodeID),"^",7)
	//s:(paAdmTime '= "") admTime = $zt(paAdmTime)
	s:(paAdmTime '= "") admTime =##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat(paAdmTime,"Time","ChangeToFormat")
	s admDateTime = admDate_" "_admTime
	s paDisDate = $p(^PAADM(episodeID),"^",17)
	s:(paDisDate '= "") disDate=##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat(paDisDate,"Date","ChangeToFormat")
	//s:(paDisDate '= "") disDate = $zd(paDisDate,3)
	s paDisTime = $p(^PAADM(episodeID),"^",18)
	s:(paDisTime '= "") disTime = ##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat(paDisTime,"Time","ChangeToFormat")
	//s:(paDisTime '= "") disTime = $zt(paDisTime)
	s disDateTime = disDate_" "_disTime
	if (paAdmDepID '= "")
	{
		s paAdmDepCodeDR = $p($g(^CTLOC(paAdmDepID)),"^",2)
		if ($l(paAdmDepCodeDR,"-")>1)
		{
			s paAdmDepCodeDR =$p(paAdmDepCodeDR,"-",2)
		}
	}
	else
	{
		s paAdmDepCodeDR = "无"
	}
	s paAdmDocCode=$p(^PAADM(episodeID),"^",9)
	q:(paAdmDocCode=0)
	if (doctorID'="")
	{
		q:(paAdmDocCode="")
		s docNum1=$p(^SSU("SSUSR",doctorID),"^",1)
		s docNum2=$p(^CTPCP(paAdmDocCode,1),"^",1)
		q:(docNum1'=docNum2)
	}
	if (paAdmDocCode '= "")
	{
		s paAdmDocCodeDR = $p(^CTPCP(paAdmDocCode,1),"^",2)
	}
	else
	{
		s paAdmDocCodeDR = "无"
	}
	s paAdmReasonDR = $p(^PAADM(episodeID,1),"^",7)
	if (paAdmReasonDR '= "")
	{
		s paAdmReason = $p(^PAC("ADMREA",paAdmReasonDR),"^",2)
	}
	else
	{
		s paAdmReason = "无"
	}
	s disWardDR = $p(^PAADM(episodeID),"^",70)
	if (disWardDR '= "")
	{
		s wardDesc =$p(^PAWARD(disWardDR),"^",2) 
		if ($l(wardDesc,"-")>1)
		{
			s wardDesc =$p(wardDesc,"-",2)
		}
	}
	else
	{
		s wardDesc = "无"
	}
	
	s RCStatus=##class(MA.IPMR.IO.OutService).GetFinishStatus(PAADMRowID,"RC")
	q:(RcFlag'="")&&(RCStatus=1)&&(RcFlag="n")
	q:(RcFlag'="")&&(RCStatus=0)&&(RcFlag="y")
	s RCInfo="否"
	s:(RCStatus=1) RCInfo="是"
	
	//s eprStatus=##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(episodeID)
	//s eprNurStatus = +$p(eprStatus,"^",1)
    //s eprDocStatus = +$p(eprStatus,"^",2)
    //s eprPdfStatus = +$p(eprStatus,"^",3)
    
	//护士结算时间
	s EstimDisChargDateTime=##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime4(episodeID)
	s eprNurStatus=$s(EstimDisChargDateTime="":"0",1:"1")
	s eprNurStatusDesc = $s(eprNurStatus=1:"是",1:"否")
	
	//获取病历是否全部完成(eprDocStatus 1：提交，0：撤销 -1：退回 空：未提交) 
	s eprDocStatus=##Class(EMRservice.InterfaceService.AdmRecordStatus).GetAdmRecordStatus(episodeID)
	s eprDocStatusDesc = $s(eprDocStatus=1:"是",1:"否")
	
	//PDF病历是否已经离线成功(0: 未生成, 1: 注册最终结算完成标识成功)
	s eprPdfStatus=##Class(DHCEPRFS.BI.BIToHIS).IsRecordCreated(episodeID)
	s eprPdfStatusDesc = $s(eprPdfStatus=1:"是",1:"否")
	
	//过滤医生提交，护士提交，PDF生成
	q:((ADocCommit = "y") && (eprDocStatus '= 1))
	q:((ADocCommit = "n") && (eprDocStatus = 1))
	q:((ANurCommit = "y") && (eprNurStatus '= 1))
	q:((ANurCommit = "n") && (eprNurStatus =1 ))
	q:((APDFCreated = "y") && (eprPdfStatus '= 1))
	q:((APDFCreated = "n") && (eprPdfStatus '= 0))
	
	s reviewStatus = ""
	s:(AType = "U") reviewStatus = "否"   //U,科室未审核
	s:(AType = "F") reviewStatus = "是"   //F,科室已通过
	s:(AType = "B") reviewStatus = "已退回"  //B,科室已退回
	s:(AType["U")&&(AType["F") reviewStatus="否,是"
	s:(AType["U")&&(AType["B") reviewStatus="否,已退回"
	s:(AType["F")&&(AType["B") reviewStatus="是,已退回"
	s:(AType["U")&&(AType["F")&&(AType["B") reviewStatus="否,是,已退回"
	s YreviewStatus = ""
	s:(AYType [ "U") YreviewStatus =YreviewStatus_"否"   //U,院级未审核
	s:(AYType [ "F") YreviewStatus =YreviewStatus_"是"   //F,院级已通过
	s:(AYType [ "B") YreviewStatus =YreviewStatus_"已退回"  //B,院级已退回
	
	s deptReviewStatus = ""
	s depCheckStatus=##class(EPRservice.Quality.SetDepDisFlag).GetDisCheckView(episodeID,"MD")
	s:(depCheckStatus = "") deptReviewStatus = "否"
	s:(depCheckStatus = "Y") deptReviewStatus = "是"
	s:(depCheckStatus = "B") deptReviewStatus = "已退回"
	s:(depCheckStatus = "R") deptReviewStatus = "否"
	s disReviewStatus = ""
	s disCheckStatus=##class(EPRservice.Quality.SetDepDisFlag).GetDisCheckView(episodeID,"D")
	s:(disCheckStatus = "") disReviewStatus = "否"
	s:(disCheckStatus = "Y") disReviewStatus = "是"
	s:(disCheckStatus = "B") disReviewStatus = "已退回"
	s:(disCheckStatus = "R") disReviewStatus = "否"

	q:(reviewStatus'[deptReviewStatus)&&(reviewStatus'="")
	q:(YreviewStatus'[disReviewStatus)&&(YreviewStatus'="")
	s checkStatus = ..GetCheckStatus(episodeID)
	s:(checkStatus = "0") checkStatus = "否"
	s:(checkStatus = "1") checkStatus = "是"

	s Age=##class(EMRservice.HISInterface.PatientInfoAssist).Age(PAPMIDR,PAADMRowID,paAdmDate,paAdmTime)
	//s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR,"",AHospitalID)
	s structId = ##Class(EPRservice.Quality.DataAccess.BOQualitySetting).GetRootStructID(PAADMDepCode,2)
	s ProblemFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(structId,2,PAADMRowID,100,"GetProblemList","")
	s Illness = "一般"
	s:((BWYZ'="")&&(BZYZ="")) Illness = "病危"
	s:((BWYZ="")&&(BZYZ'="")) Illness = "病重"
	s:((BWYZ'="")&&(BZYZ'="")) Illness = "病危 病重"
	s TransLocFlag = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetTransLocCount(PAADMRowID)
	s:(TransLocFlag=0) TransLocFlag = ""
	s:(TransLocFlag>0) TransLocFlag = "转科"
	s YSSGroup = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("YSSGroup")
	s QualityCount=0,QualityFlag=""
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOManualCheck:GetManualResult")
	d result.Execute(PAADMRowID,YSSGroup,PAADMDepCode,"A")
	while result.Next()
	{
		s QualityCount = QualityCount + 1
	}
	s:(QualityCount>0) QualityFlag="Y"
	s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (MainDiagnos = "")
    {
        s MainDiagnos = ##class(EMRservice.Ajax.patientInfo).getOPdiagnosis(PAADMRowID)
    }
	if (MainDiagnos '= "")
	{	
		s MainDiagnos = $P(MainDiagnos,"^",3)
		s MainDiagnos = $tr(MainDiagnos,"'","\'")
	}
	s MainDiagnos=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(MainDiagnos)
	s BedNo = ##Class(EPRservice.Quality.DataGather.AdmInfo).DisBed(PAADMRowID)
	s score=##class(EPRservice.Quality.SetDepDisFlag).GetMDQualityScore(PAADMRowID,APAAdmStatus)
	s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,name,patDob,patSex,admDateTime,disDateTime,paAdmDepCodeDR,paAdmDocCodeDR,paAdmReason,wardDesc,eprDocStatus,eprDocStatusDesc,eprNurStatus,eprNurStatusDesc,eprPdfStatus,eprPdfStatusDesc,deptReviewStatus,checkStatus,disReviewStatus,ProblemFlag,Illness,TransLocFlag,ResidentDays,QualityFlag,MainDiagnos,BedNo,Age,RCInfo,score)
	s ind = ind + 1
	q
}

ClassMethod GetDisProcedureListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisProcedureListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDisProcedureListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisProcedureListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 检查是否通过完整性校验，返回校验状态————"1":通过，"0":未通过
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetCheckStatus("597")
ClassMethod GetCheckStatus(AEpisodeID As %String) As %String
{
	s checkStatus = "1"
	s checkDate = ""
	s checkDate = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate))
	q:((checkDate = "")||(checkDate = "0")) "0"
	s checkTime = ""
	s checkTime = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime))
 	s rowID = ""
 	f {
	 	s rowID = $o(^DHCEPRFS.INST.CheckedRetListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime,rowID))
	 	q:(rowID = "")
	 	s obj = ##class(DHCEPRFS.INST.CheckedRetList).%OpenId(rowID)
	 	s checkResult = obj.CheckResult
	 	s isNeeded = obj.IsNeeded
	 	
	 	d obj.%Close()
	 	if (checkResult = "0")
	 	{
		 	if (isNeeded = "Y")
		 	{
			 	s checkStatus = "0"
		 	}
	 	}
 	}
 	q checkStatus
}

ClassMethod AddZero(ARegNo As %String) As %String
{
	s regNo = ""
	s regNo = $o(^PAPERi("PAPMI_PatNo",regNo))
	s regNo = $tr(regNo, " ")
	s regNo = $tr(regNo,$c(10),"")
	s regNo = $tr(regNo,$c(13),"")
	s length = $l(regNo)
	q:(length = $l(ARegNo)) ARegNo
	
	for index=1:1:(length - $l(ARegNo)) 
	{
		s ARegNo = "0"_ARegNo
	}
	q ARegNo
}

}
