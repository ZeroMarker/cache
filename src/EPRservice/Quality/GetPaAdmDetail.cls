/// Class Name:		EPRservice.Quality.GetPaAdmDetail
/// Description:	质控患者查询方法，包括在院和出院
/// Creator:	    YHY
/// Create Date:	2015-04-28
Class EPRservice.Quality.GetPaAdmDetail Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 
/// craater:  YHY
/// Create Date:	2015-04-28
/// Description:	质控患者查询
/// Return:         患者基本信息
/// Debug:    d ##class(%ResultSet).RunQuery("EPRservice.Quality.GetPaAdmDetail","GetPaAdmList","2022-01-01","2022-07-25","D","","191","","","","","")
Query GetPaAdmList(Stdate As %Date, Enddate As %Date, APAAdmStatus As %String, AMedicareNo As %String, ALocID As %String, SpecialAdm As %String, AHospitalID As %String, Diagnos As %String = "", ADocID As %String = "", Ischecked As %String = "", ARegNo As %String = "", APatName As %String = "", Reclaim As %String = "") As %Query(ROWSPEC = "PAPMIDR:%String,MedicareNo:%String,PAADMRowID:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmWard:%String,PAADMReason:%String,PADischgeDate:%String,PADischgeTime:%String,Warddesc:%String,EprDocStatusDesc:%String,EprNurStatusDesc:%String,EprPdfStatusDesc:%String,DisDate:%String,mrEpisodeID:%String,MRVerItemsIDs:%String,StatusDesc:%String,AdmDateTime:%String,ManualFlag,MessageFlag,MainDiagnos,ProblemFlag,DisManualFlag,CreateDisUser,BedNo:%Numeric,CreateAdmUser,Illness,AdmRecordStatus,QualityFlag,DeathDate,InPathWayStatus,Attending,Chief,OutManualFlag,CreateOutUser,Age,TransLocFlag,ResidentDays,KSManualFlag,BSManualFlag,KSUser,BSUser,LYFS,RegNo,QualityDT:%String")
{
}

ClassMethod GetPaAdmListExecute(ByRef qHandle As %Binary, Stdate As %Date, Enddate As %Date, APAAdmStatus As %String, AMedicareNo As %String, ALocID As %String, SpecialAdm As %String, AHospitalID As %String, Diagnos As %String = "", ADocID As %String = "", Ischecked As %String = "", ARegNo As %String = "", APatName As %String = "", Reclaim As %String = "") As %Status
{
	
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s MedicareNo = ""
	s PAADMRowID = ""
	s AdmDate = ""
	s LocID = ALocID

	// 开辟一个临时Global用于排序
	k ^CacheTemp("EPRQuality","PaAdmList")
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()
	if (AMedicareNo '="")
	{
		//病案号查询
		s PAPMIDR=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(AMedicareNo,"I","",.ErrMsg)
		q:(PAPMIDR="") $$$OK
		//s PAPMIDR = $o(^PAPERi("Medicare1",AMedicareNo,""))
		d GetPAADMRowID(LocID)
	}
	if (ARegNo '="")
	{
		//登记号查询
		s PAPMIDR=$o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PAPMIDR="") $$$OK
		d GetPAADMRowID(LocID)
	}
	elseif ((Stdate '= "")&&(Enddate '= "")&&(APAAdmStatus="A")&&(LocID'=""))
	{
		//在院患者按日期查询
		s StDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(Stdate)," ",1)
		s EndDate=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(Enddate)," ",1)
		for i = StDate:1:EndDate {
			s PAADMRowID = ""
			for {	
				s PAADMRowID = $o(^PAADMi("PAADM_AdmDate",i,PAADMRowID))
				q:(PAADMRowID = "")
				s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
				continue:AdmType'="I"
				s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
				continue:(xse'="")
				s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
				continue:(AdmStatus '= APAAdmStatus)
				s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
		        continue:(AHospitalID'="")&&(flag=0) 
				d IsArrivedQue(LocID)
			}
		}			
	}
	elseif ((Stdate '= "")&&(Enddate '= "")&&(APAAdmStatus["D"))
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
				continue:(AdmStatus '= "D")
				s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
		        continue:(AHospitalID'="")&&(flag=0) 
				d IsArrivedQue(LocID)
			}
		}			
	}
	elseif ((Stdate = "")&&(Enddate = "")&&(APAAdmStatus="A"))
	{
		s PAADMRowID = ""
		for {
			
			s PAADMRowID = $o(^PAADMi("AdmTypeCurr","I",PAADMRowID))
			q:(PAADMRowID = "")
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AdmStatus '= APAAdmStatus)
			s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
		    continue:(AHospitalID'="")&&(flag=0) 
			d IsArrivedQue(LocID)
		}
	}
	elseif ((Stdate '= "")&&(Enddate '= "")&&(APAAdmStatus="O"))
	{
		
		//门诊患者按就诊日期查询
		s StDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(Stdate)," ",1)
		s EndDate=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(Enddate)," ",1)
		for AdmDateCurr = StDate:1:EndDate {
			s time = ""
			for {
				s time = $o(^PAADMi("AdmTypeCurrLoc","O",LocID,AdmDateCurr,time))
				q:(time = "")
				s PAADMRowID = ""
				for {
					s PAADMRowID =  $o(^PAADMi("AdmTypeCurrLoc","O",LocID,AdmDateCurr,time,PAADMRowID))
					q:(PAADMRowID = "")
					s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
		            continue:(AHospitalID'="")&&(flag=0)
					//s ret = ##class(EPRservice.Quality.GetPaAdmDetail).GetRecHasAction(PAADMRowID,"print")
					//continue:ret=0
					d IsArrivedQue(LocID)
				}
			}
		}	
	}
	// 按科室、床号排序
	s tmpLoc = ""
	for {
		s tmpLoc = $o(^CacheTemp("EPRQuality","PaAdmList",tmpLoc))
		q:(tmpLoc = "")
		s tmpBedNo = ""
		for {
			s tmpBedNo = $o(^CacheTemp("EPRQuality","PaAdmList",tmpLoc,tmpBedNo))
			q:(tmpBedNo = "")
			s tmpAdmID = ""
			for {
				s tmpAdmID = $o(^CacheTemp("EPRQuality","PaAdmList",tmpLoc,tmpBedNo,tmpAdmID))
				q:(tmpAdmID = "")
				s Data = $g(^CacheTemp("EPRQuality","PaAdmList",tmpLoc,tmpBedNo,tmpAdmID))
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1	
			}
		}
	}
	k ^CacheTemp("EPRQuality","PaAdmList")
	Quit $$$OK
GetPAADMRowID(LocID)
    for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM","I",PAADMRowID))
		q:(PAADMRowID = "")
		s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
		continue:(APAAdmStatus '[AdmStatus)
		s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
		continue:(AHospitalID'="")&&(flag=0) 
	    s AdmComparedate = $P($g(^PAADM(PAADMRowID)),"^",6)
		s DisCompareDate= $P($g(^PAADM(PAADMRowID)),"^",17)
		if (Stdate '= "")
		{
			s StDate = $zdh(Stdate,3)
		 
			continue:((APAAdmStatus="A")||(APAAdmStatus="O"))&&(AdmComparedate < StDate)
			continue:((APAAdmStatus'="A")&&(APAAdmStatus'="O"))&&(DisCompareDate < StDate)
		
		
		}
		if (Enddate '= "")
		{
			s EndDate=$zdh(Enddate,3)
		
			continue:((APAAdmStatus="A")||(APAAdmStatus="O"))&&(AdmComparedate > EndDate)
			continue:((APAAdmStatus'="A")&&(APAAdmStatus'="O"))&&(DisCompareDate > EndDate)
		}
		d IsArrivedQue(LocID)
		
	}
	Quit	
IsArrivedQue(LocID)
	s mCurrRow = $g(^PAADM(PAADMRowID))
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	//B "S"
	q:((LocID'="")&&(PAADMDepCode '=LocID))
	
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
		s:PAAdmDepCodeDR["-" PAAdmDepCodeDR = $p(PAAdmDepCodeDR,"-",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	d outputrow
	Quit
	
outputrow
	s ReclaimFlag = ##class(MA.IPMR.IO.OutService).GetFinishStatus(PAADMRowID,"RC")
	q:(Reclaim="Y")&&(ReclaimFlag'=1)
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	q:(APatName'="")&&(PAPMIName'[APatName)
	s MedicareNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PAPMIDR,"I","",.ErrMsg)
	q:(AMedicareNo'="")&&(MedicareNo'=AMedicareNo)
	//s MedicareNo = $P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
	//日期时间处理
	s PAPMIDOB = $p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	s DeathDate = $p($g(^PAPER(PAPMIDR,"ALL")),"^",13)
	s RegNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	if (PAPMIDOB '= "")
	{
		s PAPMIDOB = $zd(PAPMIDOB,3)
		s PAPMIDOB = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAPMIDOB)
	}
	s PAAdmTime = $p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "")
	{
		s PAAdmTime = $zt(PAAdmTime,3)
		s PAAdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmTime)
	}
	s PAAdmDate = $p($g(mCurrRow),"^",6)
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
		s PAAdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)
	}
	s PADischgeDate=$P($g(^PAADM(PAADMRowID)),"^",17)
	if (PADischgeDate '= "")
	{
		s PADischgeDate = $zd(PADischgeDate,3)
		s PADischgeDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PADischgeDate)
	}
	s PADischgeTime=$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PADischgeTime '= "")
	{
		s PADischgeTime = $zt(PADischgeTime,3)
		s PADischgeTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PADischgeTime)
	}
	
	s PAADMReasonDR = $p($g(^PAADM(PAADMRowID,1)),"^",7)
	if (PAADMReasonDR '= "")
	{
		s PAADMReason = $p($g(^PAC("ADMREA",PAADMReasonDR)),"^",2)
	}
	else
	{
		s PAADMReason = "无"
	}
	s PAADMDocCode=$p($g(mCurrRow),"^",9)
	s:(PAADMDocCode'="") DocCode = $o(^SSU("SSUSR",0,"CTPCP",PAADMDocCode,""))
	q:((ADocID'="")&&(DocCode '=ADocID))
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}

	//以下是获取患者当前病区
	s disWardDR = $P($g(^PAADM(PAADMRowID)),"^",70)
	if (disWardDR '= "")
	{
		s Wardcode =$p($g(^PAWARD(disWardDR)),"^",1)
		s Warddesc =$p($g(^PAWARD(disWardDR)),"^",2) 
	}
	else
	{
		s Wardcode = "无"
		s Warddesc = "无"
	}
	s PTAdmDateTime=##class(web.DHCDischargeHistory).GetAdminDateTime(PAADMRowID)
	s AdmDate=$p(PTAdmDateTime,"^",1)
	s AdmTime=$p(PTAdmDateTime,"^",2)
	s:(AdmDate="") AdmDate=$P($g(^PAADM(PAADMRowID)),"^",6)
	s:(AdmTime="") AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
	s DisTime="",DisDate=""
	s DisDate = $P($g(^PAADM(PAADMRowID)),"^",17)
	s Dischgdate=DisDate
	if (Dischgdate = "")
	{
		s Systemdatetime = $HOROLOG
		s Dischgdate = $p(Systemdatetime,",",1)
	}
	s ResidentDays = ##class(EMRservice.DAL.GetPaAdmDetail).ResidentDays(AdmDate,Dischgdate)
	s AdmDateTime=$zd(AdmDate,3)
	s:(DisDate'="") DisDate=$zd(DisDate,3)
	s AdmDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDateTime)
    s DisDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DisDate)
	// 病案首页科室审核  DKS
	s KSManualFlag = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeKSManualFlag(PAADMRowID)
               q:((APAAdmStatus="DKS")&&(Ischecked'="")&&(Ischecked'[KSManualFlag))
	//q:(APAAdmStatus="DBS")&&(KSManualFlag'="P")
	//病案首页病案室审核  DBS
	s BSManualFlag = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeBSManualFlag(PAADMRowID)
               q:((APAAdmStatus="DBS")&&(Ischecked'="")&&(Ischecked'[BSManualFlag))
	//主要诊断
	s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (MainDiagnos = "")
    {
        s MainDiagnos = ##class(EMRservice.Ajax.patientInfo).getOPdiagnosis(PAADMRowID)
        //s MainDiagnos = $P(MainDiagnos,"^",3)
    }
	if (MainDiagnos '= "")
	{	
		s MainDiagnos =$p($p(MainDiagnos,"$",1),"^",3)
		s MainDiagnos = $tr(MainDiagnos,"'","\'")
	}
	s MainDiagnos=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(MainDiagnos)
	q:(Diagnos'="")&&(MainDiagnos'[Diagnos)
	s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(PAADMRowID)
    s DisScore = $p(ScoreGrade,"^",1)
	s BWYZ="",BZYZ=""
	s Illness = "一般"
	s TerminallyIll = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("TerminallyIll")
	s DiseaseSeve = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("DiseaseSeve")
	s Salvage = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("Salvage")
	s BloodFilter = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("BloodFilter")
 	s Consultation = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("Consultation")
	s Transfer = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("Transfer")

	
	s BWYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,TerminallyIll,"")
	s BZYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,DiseaseSeve,"")
	s SXYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,BloodFilter,"")
	s HZYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,Consultation,"")
	s ZKYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,Transfer,"")
	s QJYZ = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,Salvage,"")


	s OperateDateTime = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetOperDateTime(PAADMRowID)
	s:((BWYZ'="")&&(BZYZ="")) Illness = "病危"
	s:((BWYZ="")&&(BZYZ'="")) Illness = "病重"
	//s HISDeathTime = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(PAADMRowID,"20172||1",1)
	s RegTime = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime1(PAADMRowID)
	s DischTime = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(PAADMRowID)
	s RegHour = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegHour(RegTime,DischTime,"Y")
	//q:((SpecialAdm = "OverAdm")&&(RegHour < 745))
	
	s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(PAADMRowID,"")
	s LYFS=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(PAADMRowID,10896,"")
	s KSSFlag = ##class(EPRservice.Quality.DataGather.AdmInfo).GetAdmKSSSY(PAADMRowID) 
	s TransLocFlag = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetTransLocCount(PAADMRowID)
	s:(TransLocFlag=0) TransLocFlag = ""
	s:(TransLocFlag>0) TransLocFlag = "转科"
	s SpecialFlag=0,SpecialPatConfig="INTERSECTION"   //交集
    //s SpecialPatConfig="Collections"  //合集
	s SpecialCount=0
	s:(IsBSQualityEnable'="Y") SpecialPatParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","SpecialPatConfig",""))
	s:(IsBSQualityEnable="Y") SpecialPatParamID = $o(^CT.MA.QC.QualityParamsI("IdxCode","SpecialPatConfig",""))
    s:(IsBSQualityEnable'="Y")&&(SpecialPatParamID '= "") SpecialPatConfig= $list($g(^DHCEPRM.QualityParamsD(+SpecialPatParamID)),2)  //重点患者筛选配置
    s:(IsBSQualityEnable="Y")&&(SpecialPatParamID '= "") SpecialPatConfig= $list($g(^CT.MA.QC.QualityParamsD(+SpecialPatParamID)),4)  //重点患者筛选配置
    
	s SpecialAdms = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(SpecialAdm,",")
	for k = 1:1:$listlength(SpecialAdms) 
	{
		s ASpecialAdm = $listget(SpecialAdms,k)
		continue:(ASpecialAdm = "")
		if ($ZCVT(SpecialPatConfig,"U")="INTERSECTION")
		{
			s:((ASpecialAdm = "KSSPat")&&(KSSFlag=1)) SpecialFlag=1
			s:((ASpecialAdm = "NoYZLY")&&(LYFS="非医嘱离院")) SpecialFlag=1
			s:((ASpecialAdm = "OverAdm")&&(+ResidentDays>30)) SpecialFlag=1
			s:((ASpecialAdm = "TerminallyIll")&&(BWYZ '= "")) SpecialFlag=1
			s:((ASpecialAdm = "DiseaseSeve")&&(BZYZ '= "")) SpecialFlag=1
			s:((ASpecialAdm = "Death")&&(DeathDate '= "")) SpecialFlag=1
			s:((ASpecialAdm = "BloodFilter")&&(SXYZ'="")) SpecialFlag=1
			s:((ASpecialAdm = "Operate")&&(OperateDateTime'="")) SpecialFlag=1	
			s:((ASpecialAdm ="ZKHZ")&&(TransLocFlag="转科")) SpecialFlag=1
			s:((ASpecialAdm = "Salvage")&&(QJYZ '= "")) SpecialFlag=1
		}
		else
		{
			
			s:((ASpecialAdm = "KSSPat")&&(KSSFlag=1)) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "NoYZLY")&&(LYFS="非医嘱离院")) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "OverAdm")&&(+ResidentDays>30)) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "TerminallyIll")&&(BWYZ '= "")) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "DiseaseSeve")&&(BZYZ '= "")) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "Death")&&(DeathDate '= "")) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "BloodFilter")&&(SXYZ'="")) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "Operate")&&(OperateDateTime'="")) SpecialCount=SpecialCount+1	
			s:((ASpecialAdm ="ZKHZ")&&(TransLocFlag="转科")) SpecialCount=SpecialCount+1
			s:((ASpecialAdm = "Salvage")&&(QJYZ '= "")) SpecialCount=SpecialCount+1
			
		}
	}
	s:((SpecialAdm'="")&&(SpecialCount=$listlength(SpecialAdms))) SpecialFlag=1
	q:(SpecialAdm'="")&&(SpecialFlag=0)
	
	s BedNo = ##Class(EPRservice.Quality.DataGather.AdmInfo).DisBed(PAADMRowID)
	s:APAAdmStatus="O" BedNo=0
	s:BedNo="" BedNo=0
	q:BedNo=""
	s:(IsBSQualityEnable'="Y") YSSGroup = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("YSSGroup")   
	s:(IsBSQualityEnable'="Y") KSSGroup = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("KSSGroup")  
	s:(IsBSQualityEnable="Y") YSSGroup = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("YSSGroup")   
	s:(IsBSQualityEnable="Y") KSSGroup = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("KSSGroup")  
	s ManualFlag = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeAdmManualFlag(PAADMRowID)
	s CreateAdmUser = ""
	s:(ManualFlag'="") CreateAdmUser = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetCreateAdmUserByEpisodeID(PAADMRowID)
	s SSGroupID = $p(ManualFlag,"^",2)
	s manualFlag = $p(ManualFlag,"^",1)
	s QualityDT = $P(ManualFlag,"^",3)
	s:(QualityDT'="") QualityDT = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",QualityDT)
	s:((SSGroupID=YSSGroup)&&(manualFlag>0)) ManualFlag="Y"
	s:((SSGroupID=KSSGroup)&&(manualFlag>0)) ManualFlag="K"
	s CreateDisUser=""
	s DisManualFlag = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeDisManualFlag(PAADMRowID)
	q:((APAAdmStatus="D")&&(Ischecked="Y")&&(DisManualFlag'="Y"))
	q:((APAAdmStatus="D")&&(Ischecked="N")&&(DisManualFlag="Y"))
	s:(DisManualFlag="Y") CreateDisUser=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetCreateUserByEpisodeID(PAADMRowID)
	s OutManualFlag = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeOutManualFlag(PAADMRowID)
	s CreateOutUser = ""
	s:(OutManualFlag["Y") CreateOutUser = ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetCreateOutUserByEpisodeID(PAADMRowID)
	s MessageFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetMessageFlagByEpisodeID(PAADMRowID) 
	s structId = ##Class(EPRservice.Quality.DataAccess.BOQualitySetting).GetRootStructID(PAADMDepCode,2)
	s:(APAAdmStatus["S" )&&(IsBSQualityEnable'="Y") SProblem = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(570,5,PAADMRowID,100,"GetProblemList","")  
	s:(APAAdmStatus["S" )&&(IsBSQualityEnable="Y") SProblem = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructNew(570,5,PAADMRowID,100,"GetProblemList","")  
	s:(APAAdmStatus["S" ) SMsg = ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetSMessageTotalByEpisodeID(PAADMRowID,$tr(APAAdmStatus,"D",""))
	s:(APAAdmStatus["S" ) SMsgTtaol = $p(SMsg,"^",1)
	s:(APAAdmStatus["S" ) SMsgQNum = $p(SMsg,"^",2)
	//##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetSMessageFlagByEpisodeID(PAADMRowID)
	s:(APAAdmStatus["S" ) ProblemFlag = SMsgQNum_"/"_(SProblem+SMsgTtaol)
	s:(APAAdmStatus'["S" )&&(IsBSQualityEnable'="Y") ProblemFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(structId,2,PAADMRowID,100,"GetProblemList","")   //待修改
	s:(APAAdmStatus'["S" )&&(IsBSQualityEnable="Y") ProblemFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructNew(structId,2,PAADMRowID,100,"GetProblemList","")   //待修改
	s QualityFlag = "" //##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(structId,7,PAADMRowID,100,"GetQualityResult","")
	s QualityCount = 0
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOManualCheck:GetManualResult")
	d result.Execute(PAADMRowID,YSSGroup,PAADMDepCode,"A")
	while result.Next()
	{
		s QualityCount = QualityCount + 1
	}
	s:(QualityCount>0) QualityFlag="Y"
	s StatusDescCode =  0   //  ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed(PAADMRowID)
	s AdmRecordStatus = ##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(PAADMRowID)
	s InPathWayStatus = "" //##class(web.DHCCPW.MR.Interface).GetInPathWayStatus(PAADMRowID)
	s MainDocs=""
	s MainDocs = "" //##class(web.DHCDocMain).GetMainDoc(PAADMRowID)
	s Attending = "" //$P(MainDocs,"^",5)
	s Chief = "" //$P(MainDocs,"^",7)
	//s Age  = ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(PAPMIDR,PAADMRowID,PAAdmDate,PAAdmTime)
	//s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR,"",AHospitalID)
	s Age=##class(EMRservice.HISInterface.PatientInfoAssist).Age(PAPMIDR,PAADMRowID,PAAdmDate,PAAdmTime)
	s ResidentDays = ##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(PAADMRowID,"")
	if (StatusDescCode="0") {s StatusDesc = "未审核"}
	if (StatusDescCode="DEPTREVIEWED") {s StatusDesc = "审核通过"}
	if (StatusDescCode="INITIALIZED") {s StatusDesc = "审核退回"}
	s ^CacheTemp("EPRQuality","PaAdmList",PAADMDepCode,BedNo,PAADMRowID) = $LB(PAPMIDR,MedicareNo,PAADMRowID,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmWard,PAADMReason,PADischgeDate,PADischgeTime,Warddesc,EprDocStatusDesc,EprNurStatusDesc,EprPdfStatusDesc,DisDate,mrEpisodeID,MRVerItemsIDs,StatusDesc,AdmDateTime,ManualFlag,MessageFlag,MainDiagnos,ProblemFlag,DisManualFlag,CreateDisUser,BedNo,CreateAdmUser,Illness,AdmRecordStatus,QualityFlag,DeathDate,InPathWayStatus,Attending,Chief,OutManualFlag,CreateOutUser,Age,TransLocFlag,ResidentDays,KSManualFlag,BSManualFlag,KSUser,BSUser,LYFS,RegNo,QualityDT )
	
	
	
	//k ^CacheTemp("EPRQuality","PaAdmList",repid)
	//set ^CacheTemp(repid,ind) = $LB(PAPMIDR,MedicareNo,PAADMRowID,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmWard,PAADMReason,PADischgeDate,PADischgeTime,Warddesc,EprDocStatusDesc,EprNurStatusDesc,EprPdfStatusDesc,DisDate,mrEpisodeID,MRVerItemsIDs,StatusDesc,AdmDateTime,ManualFlag,MessageFlag,MainDiagnos,ProblemFlag,DisManualFlag,BedNo,CreateAdmUser,Illness,AdmRecordStatus,QualityFlag,DeathDate)
	//set ind = ind + 1
	Quit
}

ClassMethod GetPaAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaAdmListExecute ]
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

}
