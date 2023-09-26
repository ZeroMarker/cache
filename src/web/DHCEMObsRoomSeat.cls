Import SQLUser

/// Creator：      qiaoqingao
/// CreatDate：    2017-10-26
Class web.DHCEMObsRoomSeat Extends %Persistent [ Not ProcedureBlock ]
{

/// Creator：      qiaoqingao
/// CreatDate：    2017-10-26
/// Description:获取当前的医生列表
/// Table：
/// Input：
/// Return：
/// W ##class(web.DHCEMObsRoomSeat).GetListDocInfo("","")
/// 返回:
ClassMethod GetListDocInfo1(q = "", LocDr, Date)
{
	n (q,LocDr,Date)
	s LocDesc = $p(^CTLOC(LocDr),"^",2)
	Set result=##class(%Library.ResultSet).%New("web.PAAdmTransaction:LookUpByPartialCareProv")
	Set sc=result.Execute(q,LocDesc,"",Date,"1","","","E","^W^E^O^OP^EM^DS^OR^","","","","")
	If $$$ISERR(sc) Quit ""

	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		If count=0 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
		Set count = count+1
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 q ""
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-10-26
/// Description:获取当前的医生列表
/// Table：
/// Input：
/// Return：
/// W ##class(web.DHCEMObsRoomSeat).GetListDocInfo("","266")
/// 返回:
ClassMethod GetListDocInfo(q = "", LocDr)
{
	n (q,LocDr,%session)
	s Title = "CtPcpId^CtPcpCode^CtPcpName^CtCarPrvTp"
	w "["
	s ResRowID="",Num=0
	f  s ResRowID=$o(^RB("RES",0,"CTLOC",LocDr,ResRowID)) q:ResRowID=""  d
	.s CtPcpId = $p(^RB("RES",ResRowID),"^",2)
	.s CtPcpCode = $p(^CTPCP(CtPcpId,1),"^",1)
	.s CtPcpName = $p(^CTPCP(CtPcpId,1),"^",2)
	.s CtCarPrvTpDr = $p(^CTPCP(CtPcpId,1),"^",4)
	.s CtCarPrvTp = "",CtCarPrvTpCode=""
	.s:CtCarPrvTpDr'="" CtCarPrvTp =$p(^CT("CPT",CtCarPrvTpDr),"^",2)
	.s:CtCarPrvTpDr'="" CtCarPrvTpCode =$p(^CT("CPT",CtCarPrvTpDr),"^",4)
	.q:CtCarPrvTpCode'["DOCTOR"
	.s CtPcpName=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CtPcpName) //hxy 2022-12-20
	.s CtCarPrvTp=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",CtCarPrvTp) //hxy 2022-12-20
	.q:(q'="")&&(CtPcpName'[q)
	.s Temp = CtPcpId_"^"_CtPcpCode_"^"_CtPcpName_"^"_CtCarPrvTp
	.s Num=Num+1
	.w $case(Num,1:"",:",")
	.W ##class(web.DHCAPPJsonCommon).getJsonData(Title,Temp)
	w "]"
	q ""
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-10-26
/// Description:获取当前病区未安排病人的床
/// Table：
/// Input：
/// Return：
/// W ##class(web.DHCEMObsRoomSeat).GetListUnPatBed("",1,10,75)
/// 返回:
ClassMethod GetListUnPatBed(q = "", page, rows, WardId)
{
	n (q,page,rows,WardId,%session)
	;s start=(page-1)*rows+1
	;s end=page*rows
	s start=1
	s end = 999
	s del=""""
	s count=0
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s BedSub=0
	f  s BedSub =$o(^PAWARD(WardId,"BED",BedSub)) q:BedSub=""  d
	.s BedID =  WardId_"||"_BedSub
	.s BedInfoObj = ..GetBedInfoByBedID(BedID)
	.q:BedInfoObj.hasPatFlag="Y"
	.q:BedInfoObj.statusCode="U"    // 包床状态
	.q:BedInfoObj.BedCode'[q
	.s BedFlag=$p(^PAWARD(WardId,"BED",BedSub),"^",4)       //是否可用  yyt  2019-05-17
	.q:BedFlag'="Y"
	.s BedStDate = $p(^PAWARD(WardId,"BED",BedSub),"^",21)
	.s BedEndDate = $p(^PAWARD(WardId,"BED",BedSub),"^",22)
	.q:(BedStDate'="")&&(BedStDate>+$h)
	.q:(BedEndDate'="")&&(BedEndDate<+$H)
	.s count=count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",") 
	.w BedInfoObj.%ToJSON()	
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	q ""
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-11-9
/// Description:获取当前病区48小时之内的离院患者
/// Table：
/// Input：
/// Return：
/// W ##class(web.DHCEMObsRoomSeat).GetListDisPat(75)
/// 返回:
ClassMethod GetListDisPat(WardID)
{
	n (WardID,%session)
	s Count=0
	s CurrentRoom=""
	s Del=""""
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	f  s CurrentRoom= $o(^PAADMi("CurrWard",WardID,CurrentRoom)) q:CurrentRoom=""  d
	.s AdmID =""
	.f  s AdmID = $o(^PAADMi("CurrWard",WardID,CurrentRoom,AdmID)) q:AdmID=""  d
	..q:$p(^PAADM(AdmID),"^",20)'="D"    //D表示离院
	..s PaAdmDate = $p(^PAADM(AdmID),"^",6)
	..s PaAdmTime = $p(^PAADM(AdmID),"^",7)
	..Q:(+PaAdmDate=0)&(+$h>(PaAdmDate+2))    		/// 24小时之内的病人　liangqiang
	..Q:(+PaAdmTime=0)&(+$h=(PaAdmDate+2))&(PaAdmTime<$p($h,",",2)) //24小时之内的病人　liangqiang
	..s PatID = $p(AdmID,"^",1)
	..s PatInfo = ..GetPatInfoByPatId(PatID)
	..s PatInfo.AdmID = AdmID
	..w $case(Count,0:"",Count:",")
	..w PatInfo.%ToJSON()
	..s Count = Count+1
	 w "]"
	 w ","_Del_"total"_Del_":"_Count
	 w "}"
	q ""
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-10-26
/// Description:获取当前登录科室和关联科室所有病区
/// Table：
/// Input：
/// Return：
/// W ##class(web.DHCEMObsRoomSeat).GetCurWard("266")
/// 返回:
ClassMethod GetCurWard(Loc As %String)
{
	n (Loc,%session)
	s Count = 0
	q:+Loc=0 ""
	w "["
	s LinkSub=0,LinkLocDr = 0
	f  s LinkSub = $o(^CTLOC(Loc,"LINK",LinkSub)) q:LinkSub=""  d
	.s LinkLocDr = ^CTLOC(Loc,"LINK",LinkSub)
	.s QyStDate=$p(^CTLOC(LinkLocDr),"^",24)
	.s QyEndDate=$p(^CTLOC(LinkLocDr),"^",25)
	.q:+$H<QyStDate
	.q:(QyEndDate'="")&&(+$H>QyEndDate)
	.q:+LinkLocDr=0
	.s PacWardDr=0
	.f  s PacWardDr = $o(^PAWARD(0,"WARD_LocationDR",LinkLocDr,PacWardDr)) q:PacWardDr=""  d
	..s PacWardDesc = $p(^PAWARD(PacWardDr),"^",2)
	..s PacWardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PacWardDesc) //hxy 2022-12-20
	..s:PacWardDesc["-" PacWardDesc=$p(PacWardDesc,"-",2)
	..s temp = PacWardDr_"^"_PacWardDesc
	..S Count=Count+1
	..W $case(Count,1:"",:",")
	..W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",temp)
	..
	
	s PacWardDr=0
	s PacWardDr = $o(^PAWARD(0,"WARD_LocationDR",Loc,PacWardDr))
	i +PacWardDr'=0 d
	.s QyStDate=$p(^CTLOC(Loc),"^",24)
	.s QyEndDate=$p(^CTLOC(Loc),"^",25)
	.q:+$H<QyStDate
	.q:(QyEndDate'="")&&(+$H>QyEndDate)
	.s PacWardDesc = $p(^PAWARD(PacWardDr),"^",2)
	.s PacWardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PacWardDesc) //hxy 2022-12-20
	.s:PacWardDesc["-" PacWardDesc=$p(PacWardDesc,"-",2)
	.s temp=PacWardDr_"^"_PacWardDesc
	.S Count=Count+1
	.W $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",temp)
	w "]"
	q ""
}

/// Creator：      qiaoqingao
/// CreatDate：    2017-10-26
/// Description:获取当前病区等候区病人
/// Table：
/// Input：
/// Return：
/// W ##class(web.DHCEMObsRoomSeat).GetCurWardObsPat("75")
/// 返回:
ClassMethod GetCurWardObsPat(WardDr, LgParams)
{
	n (WardDr,LgParams,%session)
	q:+WardDr=0 ""
	s count=0
	w "{""rows"":["
	s WardAdmSub=0
	f  s WardAdmSub=$o(^PAWARDA(WardDr,"WADM",WardAdmSub)) q:WardAdmSub=""  d
	.s AdmDr = $p(^PAWARDA(WardDr,"WADM",WardAdmSub),"^",1)
	.s AdmStatus = $p(^PAADM(AdmDr),"^",20)
	.q:AdmStatus'="A"
	.s PatDr = $p(^PAADM(AdmDr),"^",1)
	.s PatInfo= ##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr)
	.s SexId=$p(^PAPER(PatDr,"ALL"),"^",7)
	.s ChPatSex=$p($g(^CT("SEX",+SexId)),"^",2)
	.s IsNewObsPat=##class(web.DHCEMObsRoomSeat).IsNewObsPat(AdmDr) ;是否新入院
	.s BEDORDTIPFORM=##class(web.DHCEMNurExe).GetConfigBySession("BEDORDTIPFORM",LgParams)
	.s:BEDORDTIPFORM="" BEDORDTIPFORM="SYDO"
	.
	.s IsHasSyOrd=##class(web.DHCEMPatientSeat).IsHasSyOrd(PatDr,LgParams,BEDORDTIPFORM) ;是否有需执行医嘱
	.s IsReCall=##class(web.DHCEMObsRoomSeat).IsReCall(AdmDr)	;是否离院召回
	.s IsTransPat=##class(web.DHCEMObsRoomSeat).IsTransPat(AdmDr) ;是否转科
	.s rsData =PatInfo_"^"_AdmDr_"^"_PatDr_"^"_IsNewObsPat_"^"_IsHasSyOrd_"^"_IsReCall_"^"_IsTransPat_"^"_ChPatSex
	.s str="PatNo"_"^"_"PatName"_"^"_"PatSex"_"^"_"PatAge"_"^"_"birthday"_"^"_"IdentNo"
	.s str=str_"^"_"PatNation"_"^"_"PatCountry"_"^"_"PatTelH"_"^"_"Address"_"^"_"PatType"
	.s str=str_"^"_"PatCardNo"_"^"_"CardTypeID"_"^"_"AdmID"_"^"_"PatientID"_"^IsNewObsPat"
	.s str=str_"^IsHasSyOrd^IsReCall^IsTransPat^ChPatSex"
	.w $case(count,0:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(str,rsData)
	.s count=count+1
	W "],""total"":"_count_"}"
	q ""
}

/// Descript:是否新入观患者
/// Return : ""/Y/N
/// w ##class(web.DHCEMObsRoomSeat).IsNewObsPat(2916)
ClassMethod IsNewObsPat(EpisodeID)
{
	n (EpisodeID)
	s Ret=""
	s AvsID=""
	f  s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsID)) q:(AvsID="")||(Ret'="")  d
	.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	.s WalkStatusCode=$p(^DHCPACVisitStatus(PvsID),"^",1)
   	.q:(WalkStatusCode'="Salvage")&&(WalkStatusCode'="Stay")
   	.s CreatDate=$P(^DHCADMVisitStatus(AvsID),"^",8)
   	.s:CreatDate=+$h Ret="Y"
   	.s:CreatDate'=+$h Ret="N"
   	q Ret
}

/// Descript:是否离院召回患者
/// Return : ""/Y
/// w ##class(web.DHCEMObsRoomSeat).IsReCall(112)
ClassMethod IsReCall(EpisodeID)
{
	n (EpisodeID)
	s Ret=""
	s AvsLastID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	q:AvsLastID="" ""
	s PvsLastID=$P(^DHCADMVisitStatus(AvsLastID),"^",2)
	q:PvsLastID="" ""
	s PvsLastDate=$P(^DHCADMVisitStatus(AvsLastID),"^",8)
	q:PvsLastDate'=+$H ""
	
	s AvsTwoLastID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsLastID),-1)
	q:AvsTwoLastID="" ""
	s PvsTwoLastID=$P(^DHCADMVisitStatus(AvsTwoLastID),"^",2)
	q:PvsTwoLastID="" ""
	s LastStatusCode=$p(^DHCPACVisitStatus(PvsLastID),"^",1)
	s TwoLastStatusCode=$p(^DHCPACVisitStatus(PvsTwoLastID),"^",1)
	q:(LastStatusCode'="Salvage")&&(LastStatusCode'="Stay") ""
	q:(TwoLastStatusCode'="Salvage")&&(TwoLastStatusCode'="Stay") ""
	q:LastStatusCode'=TwoLastStatusCode ""
	s Ret="Y"
   	q Ret
}

/// w ##class(web.DHCEMObsRoomSeat).IsTransPat(112)
ClassMethod IsTransPat(EpisodeID)
{
	n (EpisodeID)
	s TrsLastCH=$o(^PAADM(EpisodeID,"TRANS",""),-1)
	q:TrsLastCH="" ""
	s LastWardID=$p(^PAADM(EpisodeID,"TRANS",TrsLastCH),"^",9)    /// 病区
	q:LastWardID="" ""
	s StartDate=$p(^PAADM(EpisodeID,"TRANS",TrsLastCH),"^",1)
	q:StartDate'=+$H ""		;非当天转移
	
	s TrsTwoLastCH=$o(^PAADM(EpisodeID,"TRANS",TrsLastCH),-1)
	s TwoLastWardID=""
	i +TrsTwoLastCH=0 d
	.s TwoLastWardID=##class(web.DHCEMObsRoomSeat).FirstInObsWard(EpisodeID)
	i +TrsTwoLastCH'=0 d
	.s TwoLastWardID=$p(^PAADM(EpisodeID,"TRANS",TrsTwoLastCH),"^",9)    /// 病区
	q:TwoLastWardID="" ""
	q:(LastWardID=TwoLastWardID) ""
	q "Y"
}

/// w ##class(web.DHCEMObsRoomSeat).FirstInObsWard(112)
ClassMethod FirstInObsWard(EpisodeID)
{
	n (EpisodeID)
	s Ret=""
	s AvsID=""
	f  s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsID)) q:(AvsID="")||(Ret'="")  d
	.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	.s WalkStatusCode=$p(^DHCPACVisitStatus(PvsID),"^",1)
   	.q:(WalkStatusCode'="Salvage")&&(WalkStatusCode'="Stay")
   	.s Ret=$P(^DHCADMVisitStatus(AvsID),"^",10)
   	q Ret
}

// W ##class(web.DHCEMObsRoomSeat).GetCurWardDisHospPat("105")

ClassMethod GetCurWardDisHospPat(WardDr)
{
	n (WardDr,%session)
	q:+WardDr=0 ""
	s count=0
	s CurDate = +$h
	s Date = CurDate-2
	s DischargeDr = $o(^DHCPACVisitStatus(0,"Desc","离院",""))  
	s Pid = ##Class(web.DHCEMPatCheckLevCom).NewPid()
	
	k ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetCurWardDisHospPat",Pid)
	f Date=Date:1:CurDate d
	.s AVSRowId=""
	.f  s AVSRowId=$o(^DHCADMVisitStatus(0,"DateStatus",Date,DischargeDr,AVSRowId)) q:AVSRowId=""  d   //遍历当天离院过的就诊
	..s EpisodeID = $p(^DHCADMVisitStatus(AVSRowId),"^",1)
	..;获取就诊下最后一次的状态
	..s ADMVisitStatusDr = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	..s PACVisitStatusDr=$p(^DHCADMVisitStatus(ADMVisitStatusDr),"^",2)
	..s CurStatusDesc = $p(^DHCPACVisitStatus(PACVisitStatusDr),"^",2)
	..q:PACVisitStatusDr'=DischargeDr              //最后一次不是离院
	..s DischargeDate = $p(^DHCADMVisitStatus(AVSRowId),"^",5)
	..s DischargeTime = $p(^DHCADMVisitStatus(AVSRowId),"^",6)
	..;s DischargeDate = $zd(DischargeDate,3)
	..s DischargeDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(DischargeDate) ;$p(DischargeDate,"-",2)_"-"_$p(DischargeDate,"-",3)
	..s DischargeTime = $zt(DischargeTime,2)
	..s ADMVisitStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,ADMVisitStatusDr),-1)
	..s PACVisitStatusDr=$p(^DHCADMVisitStatus(ADMVisitStatusDr),"^",2)
	..s CurStatusDesc = $p(^DHCPACVisitStatus(PACVisitStatusDr),"^",2)
	..;q:(PACVisitStatusDr'=5)&&(PACVisitStatusDr'=10)   //离院状态前非留观或抢救
	..s StayWard = $p(^PAADM(EpisodeID),"^",70)
	..q:StayWard'=WardDr                              //判断病区
	..s PatDr = $p(^PAADM(EpisodeID),"^",1)
	..s PatInfo= ##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr)
	..s rsData =PatInfo_"^"_EpisodeID_"^"_PatDr_"^"_DischargeDate_"^"_DischargeTime
	..s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetCurWardDisHospPat",Pid,EpisodeID)=rsData
	
	s str="PatNo^PatName^PatSex^PatAge^birthday^IdentNo"
	s str=str_"^PatNation^PatCountry^PatTelH^Address^PatType"
	s str=str_"^PatCardNo^CardTypeID^AdmID^PatientID^DischargeDate^DischargeTime"
	w "{""rows"":["
	s EpisodeID=""
	f  s EpisodeID = $o(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetCurWardDisHospPat",Pid,EpisodeID)) q:EpisodeID=""  d
	.s rsData = ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetCurWardDisHospPat",Pid,EpisodeID)
	.w $case(count,0:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(str,rsData)
	.s count=count+1
	W "],""total"":"_count_"}"
	
	k ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetCurWardDisHospPat",Pid)
	q ""
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取床位状态,包床时间以及包床就诊
/// Table：
/// Input：
/// Return：
/// W ##class(web.DHCEMObsRoomSeat).GetBedStatus("30||2")
/// 返回:
ClassMethod GetBedStatus(bedID)
{
	n (bedID)
	s status={"statusCode":"","unavailPatAdm":"","unavailReason":""}
	q:bedID="" status
	s currentDate=+$h,currentTime=$p($h,",",2)  
	s wardID=+bedID,bedSub=$p(bedID,"||",2)
	s unavailReason="",bedStatusCode="",patAdm="",unavailStDate="",unavailStTime="",unavailEndDate="",unavailEndTime=""
	s sub=0  f  s sub=$O(^PAWARDA(wardID,"BED",bedSub,"STAT",sub)) q:sub=""  d  //获取包床时间
	.s data=$g(^PAWARDA(wardID,"BED",bedSub,"STAT",sub))
	.s startDate=$p(data,"^",1),startTime=$p(data,"^",2)   
	.s toDate=$p(data,"^",5),toTime=$p(data,"^",6)
	.q:(startDate'="")&&(startDate>currentDate)   
	.q:(startDate'="")&&(startTime'="")&&(startDate=currentDate)&&(startTime>currentTime)
	.q:(toDate'="")&&(toDate<currentDate)
	.q:(toDate'="")&&(toTime'="")&&(toDate=currentDate)&&(toTime<currentTime)
	.s unavailReasonDR=$p(data,"^",7)    								//床位不可用原因  
	.i unavailReasonDR'="" s unavailReason=$p($g(^PAC("RNAV",unavailReasonDR)),"^",2)  //包床或者已用
	.i unavailReasonDR'="" s unavailStDate=$p($g(^PAWARDA(wardID,"BED",bedSub,"STAT",sub)),"^",1)  //包床或者已用
	.i unavailReasonDR'="" s unavailStTime=$p($g(^PAWARDA(wardID,"BED",bedSub,"STAT",sub)),"^",2)  //包床或者已用
	.i unavailReasonDR'="" s unavailEndDate=$p($g(^PAWARDA(wardID,"BED",bedSub,"STAT",sub)),"^",5)  //包床或者已用
	.i unavailReasonDR'="" s unavailEndTime=$p($g(^PAWARDA(wardID,"BED",bedSub,"STAT",sub)),"^",6)  //包床或者已用
	.s bedStatusDR=$p(data,"^",3)
	.i bedStatusDR'="" s bedStatusCode=$p($g(^PAC("BSTAT",bedStatusDR)),"^",1)     //A U
	.i bedStatusCode="U" d   
	..s episodeID=$p($G(^PAWARDA(wardID,"BED",bedSub,"STAT",sub,"DHC")),"^",1)
	..q:episodeID=""
	..s patAdm = episodeID
	s status.statusCode=bedStatusCode
	s status.unavailPatAdm=patAdm
	s status.unavailReason=unavailReason
	s status.unavailStDate = unavailStDate
	s status.unavailStTime = unavailStTime
	s status.unavailEndDate = unavailEndDate
	s status.unavailEndTime = unavailEndTime
	q status
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取该病区下所有的床位信息以及床位安排病人信息
/// Table：PAC_Ward、PAC_Bed
/// Input：病区ID
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetWardSeatInfo("13","2^70^22^13806","PatName^zl")
ClassMethod GetWardSeatInfo(WardID, LgParams, OtherParams)
{
	n (WardID,LgParams,OtherParams,%session)
	s Del=""""
	s Pid = ##Class(web.DHCEMPatCheckLevCom).NewPid()
	w "{"
	w Del_"SeatData"_Del_":"
	d ##class(web.DHCEMObsRoomSeat).JsonPatSeatData(WardID,LgParams,OtherParams,Pid)
	w ","
	w Del_"ObsRoomData"_Del_":"
	d ##class(web.DHCEMObsRoomSeat).GetObsRoomData(WardID)
	w ","
	w Del_"AdmLocData"_Del_":"
	d ##class(web.DHCEMObsRoomSeat).GetLocBySeatNum(Pid)
	w ","
	w Del_"Pid"_Del_":"_Pid
	w "}"
	q ""
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取该病区下所有的床位信息以及床位安排病人信息
/// Table：PAC_Ward、PAC_Bed
/// Input：病区ID
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPatSeatData("75")
ClassMethod GetPatSeatData(WardID)
{
	n (WardID,%session)
	w "["
	s dynamicObj={},Count=0
	s BedSub=0
	f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	.q:$p(^PAWARD(WardID,"BED",BedSub),"^",4)'="Y"
	.s dynamicObj.BedID = WardID_"||"_BedSub
	.s dynamicObj.BEDCode = $p(^PAWARD(WardID,"BED",BedSub),"^",1)
	.s dynamicObj.BEDPositionLeft = $p(^PAWARD(WardID,"BED",BedSub),"^",15)
	.s dynamicObj.BEDPositionTop = $p(^PAWARD(WardID,"BED",BedSub),"^",16)
	.s dynamicObj.BEDPositionHeight = $p(^PAWARD(WardID,"BED",BedSub),"^",17)
	.s dynamicObj.BEDPositionWidth = $p(^PAWARD(WardID,"BED",BedSub),"^",18)
	.s dynamicObj.BEDStatus = ..GetBedStatus(WardID_"||"_BedSub)   //能获取包床状态
	.s dynamicObj.PatInfo =..GetPatInfoBySeatId(WardID_"||"_BedSub)
	.s:dynamicObj.PatInfo'="" dynamicObj.PatInfoHtmlText = ..GetPatInfoHtmlByAdm(dynamicObj.PatInfo.PaAdm)   //显示在界面的html
	.s:dynamicObj.PatInfo="" dynamicObj.PatInfoHtmlText=""
	.s dynamicObj.IconHtmlText = ..GetPatInconByPatInfo(dynamicObj.PatInfo)
	.w $case(Count,0:"",:",")
	.w dynamicObj.%ToJSON()
	.s Count=Count+1
	w "]"
	q ""
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取该病区下所有的床位信息以及床位安排病人信息
/// Table：PAC_Ward、PAC_Bed
/// Input：病区ID
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPatSeatData("")
ClassMethod GetPatSeatDataNew(WardID, Pid)
{
	n (WardID,Pid,%session)
	w "["
	s dynamicObj=##class(web.DHCEMJsonObject).%New() //代替16语法空对象 lp
	s BedSub=0,Count=0
	f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	.s ActiveFlag=$p(^PAWARD(WardID,"BED",BedSub),"^",4)
	.q:(ActiveFlag'="Y")
	.s BedStDate = $p(^PAWARD(WardID,"BED",BedSub),"^",21)
	.s BedEndDate = $p(^PAWARD(WardID,"BED",BedSub),"^",22)
	.s ADMChildsub ="",PaAdm=""
	.s ADMChildsub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	.s:+ADMChildsub'=0 PaAdm=$p(^PAWARDA(WardID,"BED",BedSub,"ADM",ADMChildsub),"^",1)
	.q:(PaAdm="")&&(BedStDate'="")&&(BedStDate>+$h)
	.q:(PaAdm="")&&(BedEndDate'="")&&(BedEndDate<+$H)
	.q:($p($g(^PAWARD(WardID,"BED",BedSub)),"^",18)="") //没维护宽度
	.d dynamicObj.Put("BedID",WardID_"||"_BedSub)
	.s BedRoomId=$p(^PAWARD(+WardID,"BED",BedSub),"^",3)  //房间名称 （原来取得是床类型名称）  update 180917
	.s BedName = $p(^PAWARD(WardID,"BED",BedSub),"^",1)   //床位名称
	.s BedTipMessage = ""
	.s:(BedStDate'="")&&(BedStDate>+$h) BedTipMessage=BedName_"床尚未至启用时间,请及时处理床位上病人！"
	.s:(BedEndDate'="")&&(BedEndDate<+$H) BedTipMessage=BedName_"床已至停用时间,请及时处理床位上病人！"
	.s BedRoomDesc=""
	.s:BedRoomId'="" BedRoomDesc=$p(^PAROOM(BedRoomId),"^",2)
	.d dynamicObj.Put("BEDCode",BedName)
	.d dynamicObj.Put("BEDPositionLeft",$p(^PAWARD(WardID,"BED",BedSub),"^",15))
	.d dynamicObj.Put("BEDPositionTop",$p(^PAWARD(WardID,"BED",BedSub),"^",16))
	.d dynamicObj.Put("BEDPositionHeight",$p(^PAWARD(WardID,"BED",BedSub),"^",17))
	.d dynamicObj.Put("BEDPositionWidth",$p(^PAWARD(WardID,"BED",BedSub),"^",18))
	.d dynamicObj.Put("BEDStatus",..GetBedStatus(WardID_"||"_BedSub))
	.d dynamicObj.Put("PatInfo",..GetPatInfoBySeatIdNew(WardID_"||"_BedSub,Pid))
	.i dynamicObj.GetValue("PatInfo")'="" d dynamicObj.Put("PatInfoHtmlText",..GetPatInfoHtmlByAdm(PaAdm))   //
	.i dynamicObj.GetValue("PatInfo")="" d dynamicObj.Put("PatInfoHtmlText","")
	.d dynamicObj.Put("IconHtmlText","")   
	.d dynamicObj.Put("BedTipMessage",BedTipMessage)   
	.w $case(Count,0:"",:",")
	.w dynamicObj.JsonNoOp()
	.s Count=Count+1
	w "]"
	q ""
}

/// Creator：   qiaoqingao update（lp） 16语法改10 返回对象改成返回json
/// CreatDate： 2017-10-26
/// Description:通过床位ID获取床位病人信息
/// Table：PAC_Bed、PAC_BedAdm
/// Input：床位ID
/// Return：OBJECT OR ""
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPatInfoBySeatIdNew("75","")
ClassMethod GetPatInfoBySeatIdNew(SeatID, pid)
{
	n (SeatID,pid,%session)
	s DynamicObj=##class(web.DHCEMJsonObject).%New()
	s WardId = $p(SeatID,"||",1)
	s SeatSub = $p(SeatID,"||",2)
	s PatDr="",PatPaAdm=""
	s SeatStatusJosn = ..GetBedStatus(SeatID)
	s SeatStatus= ##class(web.DHCEMJsonObject).FromJSON(SeatStatusJosn)
	i SeatStatus.GetValue("statusCode")="U" d //i SeatStatus.statusCode="U" d
	.q:+SeatStatus.GetValue("unavailPatAdm")=0
	.s PatDr = $p(^PAADM(SeatStatus.GetValue("unavailPatAdm")),"^",1)
	i SeatStatus.GetValue("statusCode")'="U" d
 	.s AdmSub  = $o(^PAWARDA(WardId,"BED",SeatSub,"ADM",0)) 
 	.i (+AdmSub'=0) d
	..s PaAdm = $p(^PAWARDA(WardId,"BED",SeatSub,"ADM",AdmSub),"^",1)
	..q:+PaAdm=""
	..s PatDr = $p(^PAADM(PaAdm),"^",1)
	..s PatPaAdm = PaAdm
	s:+PatDr'=0 DynamicObjJson = ..GetPatInfoByPatId(PatDr)
 	q:+PatDr=0 ""
 	s DynamicObj =##class(web.DHCEMJsonObject).FromJSON(DynamicObjJson)							   //就诊科室
	s QueDepDr=$p(^PAADM(PatPaAdm),"^",4) //就诊科室 update 180914
	s QueDepDesc = $case(QueDepDr,"":"",QueDepDr:$P(^CTLOC(QueDepDr),"^",2))
	s:QueDepDesc["-" QueDepDesc=$p(QueDepDesc,"-",2)
	s PAAdmDocCodeDR=$P($g(^PAADM(PatPaAdm)),"^",9)  //就诊医生 add lp 180917
	I PAAdmDocCodeDR'="" s Doctor=$P($g(^CTPCP(PAAdmDocCodeDR,1)),"^",2)
	s CareLevel = ##class(Nur.CommonInterface.Patient).getCareLevel(PatPaAdm)
	E  s Doctor=""
	s AdmReason=""
	s PAADMAdmReasonDR=$p(^PAADM(PatPaAdm,1),"^",7)
	s:PAADMAdmReasonDR'="" AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s AdmCareInfo = ##class(web.DHCEMInComUseMethod).GetRegMark(PatPaAdm)
	s AdmCare=$p(AdmCareInfo,"^",1)
 	d DynamicObj.Put("PaAdm",PatPaAdm)  	//增加返回Adm
 	d DynamicObj.Put("PatientID",PatDr)		//增加返回病人ID
 	d DynamicObj.Put("AdmReason",AdmReason) //增加返回费别
 	d DynamicObj.Put("PatObsDate",..GetObsPatObstime(PatPaAdm))
 	d DynamicObj.Put("PatObsDateDesc",..GetFirstInSeatDateDesc(PatPaAdm))   //留观开始时间
 	d DynamicObj.Put("Deposit",##class(web.DHCDocOrderCommon).GetCurrentDeposit(PatPaAdm))  //余额

 	s MRDiagnos= ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(PatPaAdm,"","","##")
 	d DynamicObj.Put("MRDiagnos",MRDiagnos)             	//增加返回Adm
 	d DynamicObj.Put("QueDepDesc",QueDepDesc)               //增加返回就诊科室 add lp 180906
 	d DynamicObj.Put("Doctor",Doctor)            		    //增加返回就诊医生 add lp 180906
 	d DynamicObj.Put("CareLevel",CareLevel)
 	d DynamicObj.Put("AdmCare",AdmCare)
 	b ;err
 	i $d(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc))  d
 	.s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)=^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)+1
 	e  d
 	.s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)=$i(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc))
 	s SevenTwoFlag=..GetObsPatSevenTwoFlag(PatPaAdm)    //72小时标志
 	i SevenTwoFlag=1 d
 	.i $d(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时"))  d
 	..s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时")=^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时")+1
 	.e  d
 	..s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时")=$i(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时"))
	q DynamicObj.Json()
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取该病区等候区信息
/// Table：PAC_Ward、PAC_Bed
/// Input：病区ID
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetObsRoomData("75")
ClassMethod GetObsRoomData(WardID)
{
	n (WardID)
	s dynamicObj={},DataFlag=""   //等候区信息
	s RoomSub = 0
	f  s RoomSub=$o(^PAWARD(WardID,"ROOM",RoomSub)) q:(RoomSub="")!(DataFlag'="")  d //获取等候区配置
	.s ROOMDateFrom=$p($g(^PAWARD(WardID,"ROOM",RoomSub)),"^",7)
	.s ROOMDateTo=$p($g(^PAWARD(WardID,"ROOM",RoomSub)),"^",8)
	.q:ROOMDateFrom>+$h   //开始时间大于当前时间
	.q:(ROOMDateTo'="")&&(ROOMDateTo<+$h)	  //结束时间小于当前时间
	.s dynamicObj.PACRoom = $p($g(^PAWARD(WardID,"ROOM",RoomSub)),"^",1)
	.s dynamicObj.BEDPositionLeft = $p($g(^PAWARD(WardID,"ROOM",RoomSub)),"^",2)
	.s dynamicObj.BEDPositionTop = $p($g(^PAWARD(WardID,"ROOM",RoomSub)),"^",3)
	.s dynamicObj.BEDPositionHeight = $p($g(^PAWARD(WardID,"ROOM",RoomSub)),"^",5)
	.s dynamicObj.BEDPositionWidth = $p($g(^PAWARD(WardID,"ROOM",RoomSub)),"^",4)
	.s DataFlag=1   //只取第一个
	s:DataFlag="" dynamicObj={}
	w dynamicObj.%ToJSON()
	q ""
}

/// 这个方法用于获取前台显示病人信息的html内容
/// w ##class(web.DHCEMObsRoomSeat).GetPatInfoHtmlByAdm(1)
ClassMethod GetPatInfoHtmlByAdm(AdmID)
{
	n (AdmID,%session)
	q:AdmID="" ""
	s PatInfoHtml=""
	s PatID = $p(^PAADM(AdmID),"^",1)
	s PatInfoObjJson=..GetPatInfoByPatId(PatID)
	s AdmInfoObjJson=..GetAdmInfo(AdmID)
	s PatInfoObj = ##class(web.DHCEMJsonObject).FromJSON(PatInfoObjJson) //json转对象 lp
	s AdmInfoObj = ##class(web.DHCEMJsonObject).FromJSON(AdmInfoObjJson) //json转对象 lp
	s MRDiagnos = ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(AdmID,"","","##") 
	;s:$l(MRDiagnos)>8 MRDiagnos = $e(MRDiagnos,1,8)_"..."
	s MRDiagnos=$p($g(MRDiagnos),"##",1)
	s:$l(MRDiagnos)>7 MRDiagnos = $e(MRDiagnos,1,6)_"..."
	s EmPCLvID="",NurseLevel="",NurseLevelHtml=""					//分诊ID、护士分级
	s:$d(^DHCEMPCA(0,"AdmChkLev",AdmID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",AdmID,""))
	s:EmPCLvID'="" NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)
	s Priority=+$P($g(^PAADM(AdmID)),"^",33)   /// 就诊表级别
	i Priority'=0 s NurseLevel=+$p($g(^CT("ACU",Priority)),"^",1)
	;s:+NurseLevel'=0 NurseLevelHtml="<span style='border-radius:5px;background:"_$case(NurseLevel,1:"red",2:"red","3":"yellow",4:"#66d466")_"'>"_NurseLevel_"级</span>" //hxy 2020-02-20注释
	s:+NurseLevel'=0 NurseLevelHtml="<span style='border-radius:5px;background:"_$case(NurseLevel,1:"red",2:"orange","3":"yellow",4:"#66d466",5:"#66d466")_"'>"_$case(NurseLevel,1:"Ⅰ",2:"Ⅱ",3:"Ⅲ",4:"Ⅳa",5:"Ⅳb")_"级</span>"
	s:+NurseLevel=0 NurseLevelHtml="<span>未分级</span>"
	s PatInfoHtml ="<table>"
	s sexColor="#000" //hxy 2018-04-25 st
	i PatInfoObj.GetValue("PatSex")="男" s sexColor="#36AAED"
	i PatInfoObj.GetValue("PatSex")="女" s sexColor="#FF7368"
	s PatObsDateDesc = ..GetFirstInSeatDateDesc(AdmID)   //留观开始时间
	s:PatObsDateDesc'="" PatObsDateDesc=$p(PatObsDateDesc," ",1) 
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>ID:</td><td>"_PatInfoObj.GetValue("PatNo")_"</td></tr>"   //name and regNo hxy 2018-04-25 ed
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>姓名:</td><td>"_PatInfoObj.GetValue("PatName")_"</td></tr>"   //name and regNo hxy 2018-04-25 ed
	s PatInfoHtml =PatInfoHtml_"<tr><td>性别:</td><td>"_PatInfoObj.GetValue("PatSex")_"</td></tr>"	//sex and age
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>分级:</td><td>"_NurseLevelHtml_"</td></tr>"   //name and regNo hxy 2018-04-25 ed
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>诊断:</td><td>"_MRDiagnos_"</td></tr>"	//billtype and PatNation
	s PatInfoHtml =PatInfoHtml_"</table>"
	
	q PatInfoHtml
}

/// 获取病人图标
ClassMethod GetPatInconByPatInfo(PatInfoObj)
{
	n (PatInfoObj)
	q:PatInfoObj="" ""
	s PatID = PatInfoObj.PatientID
	s PaAdm = PatInfoObj.PaAdm
	q ##class(web.DHCDocMain).ShowIcon("MAP",PaAdm_"^^^"_PatID,"")
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:通过床位ID获取床位病人信息
/// Table：PAC_Bed、PAC_BedAdm
/// Input：床位ID
/// Return：OBJECT OR ""
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPatInfoBySeatId("30||2")
ClassMethod GetPatInfoBySeatId(SeatID)
{
	n (SeatID,%session)
	s DynamicObj={}
	s WardId = $p(SeatID,"||",1)
	s SeatSub = $p(SeatID,"||",2)
	s PatDr="",PatPaAdm=""
	s SeatStatus = ..GetBedStatus(SeatID)
	i SeatStatus.statusCode="U" d
	.q:+SeatStatus.unavailPatAdm=0
	.s PatDr = $p(^PAADM(SeatStatus.unavailPatAdm),"^",1)
	i SeatStatus.statusCode'="U" d
 	.s AdmSub  = $o(^PAWARDA(WardId,"BED",SeatSub,"ADM",0)) 
 	.i (+AdmSub'=0) d
	..s PaAdm = $p(^PAWARDA(WardId,"BED",SeatSub,"ADM",AdmSub),"^",1)
	..q:+PaAdm=""
	..s PatDr = $p(^PAADM(PaAdm),"^",1)
	..s PatPaAdm = PaAdm
	s:+PatDr'=0 DynamicObj = ..GetPatInfoByPatId(PatDr)
 	q:+PatDr=0 ""
 	s DynamicObj.PaAdm = PatPaAdm            //增加返回Adm
 	s DynamicObj.PatientID = PatDr			 //增加返回病人ID
 	s DynamicObj.PatObsDate =..GetObsPatObstime(PatPaAdm)
 	s DynamicObj.PatObsDateDesc = ..GetFirstInSeatDateDesc(PatPaAdm)   //留观开始时间
 	s DynamicObj.Deposit=##class(web.DHCDocOrderCommon).GetCurrentDeposit(PatPaAdm)  //余额
 	s DynamicObj.MRDiagnos = ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(PatPaAdm,"","",",")             //增加返回Adm
	q DynamicObj
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取安排面板病人信息
/// Table：
/// Input：
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPlanPatInfo("5640")
ClassMethod GetPlanPatInfo(Adm)
{
	n (Adm,%session)
	q:+Adm=0 ""
	q:$p(^PAADM(Adm),"^",20)'="A" "-1"
	s DynamicObj=##class(web.DHCEMJsonObject).%New()
	
	s PatDr = $p(^PAADM(Adm),"^","1")
	s PatInfoObj = ..GetPatInfoByPatId(PatDr)   //获取病人信息
	s AdmInfoObj = ..GetAdmInfo(Adm)  			//获取就诊信息
	d DynamicObj.Put("PatInfo",PatInfoObj)
	d DynamicObj.Put("AdmInfo",AdmInfoObj)
	w DynamicObj.Json()
	q ""
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取安排面板病人信息
/// Table：
/// Input：
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPlanPatInfo("5640")
ClassMethod GetPlanPatJsonData(Adm)
{
	n (Adm,%session)
	q:+Adm=0 ""
	q:$p(^PAADM(Adm),"^",20)'="A" "-1"
	s DynamicObj=##class(web.DHCEMJsonObject).%New()
	
	s PatientID = $p(^PAADM(Adm),"^","1")
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 病人姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	 /// 病人登记号
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 性别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s WardDr = $p(^PAADM(Adm),"^",70)
	s WardDesc = $case(WardDr,"":"",WardDr:$P(^PAWARD(WardDr),"^",2))
	s QueDepDr=$p(^PAADM(Adm),"^",4) //就诊科室 update 180914 (转科操作，不取队列表就诊科室)
	s QueDepDesc = $case(QueDepDr,"":"",QueDepDr:$P(^CTLOC(QueDepDr),"^",2))
	s DHCQueueDr = $o(^User.DHCQueueI("QuePaadmDrIndex",Adm,""),-1) 
	s QueDocDr =$p(^PAADM(Adm),"^",9) ;$LG(^User.DHCQueueD(+DHCQueueDr),5)		//就诊医生
	s QueDocDesc = $case(QueDocDr,"":"",QueDocDr:$P(^CTPCP(QueDocDr,1),"^",2))
	s Deposit=##class(web.DHCDocOrderCommon).GetCurrentDeposit(Adm) 
	s DHCPaAdmID = $o(^DHCPAAdm(0,"PAAdm",Adm,""),-1)    //主管护士和主管护士2
	s MainNurID="",MainNurID2=""
	i +DHCPaAdmID'=0 d
	.s MainNurID = $p(^DHCPAAdm(DHCPaAdmID),"^",2)
	.s MainNurID2 = $p(^DHCPAAdm(DHCPaAdmID),"^",20)
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2023-01-30 st
	s QueDepDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",QueDepDesc)
	s QueDocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",QueDocDesc)
	s WardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",WardDesc) //ed
	d DynamicObj.Put("PatName",PatName)
	d DynamicObj.Put("PatNo",PatNo)
	d DynamicObj.Put("PatSex",PatSex)
	d DynamicObj.Put("WardDesc",WardDesc)
	d DynamicObj.Put("QueDepDr",QueDepDr)
	d DynamicObj.Put("QueDepDesc",QueDepDesc)
	d DynamicObj.Put("Deposit",Deposit)
	d DynamicObj.Put("QueDocDesc",QueDocDesc)
	d DynamicObj.Put("MainNurID",MainNurID)
	d DynamicObj.Put("MainNurID2",MainNurID2)
	w DynamicObj.Json()
	q ""
}

/// Param:UserID^BedID^DocDr^PatAdm^Date^Time
/// W ##class(web.DHCEMObsRoomSeat).PlanPat("4636^^ys01^1725^2018-07-17^16:32:51^3^^74")
ClassMethod PlanPat(Param)
{
	n (Param)
	s rs = ..IfCanPlanPat(Param)  //判断是否可以安排
	q:rs'=0 rs
	s rs = ..PlanPatSeat(Param)  //安排病人
	q:rs'=0 rs
	q 0
}

/// Param:UserID^BedID^PatAdm^Date^Time^DocDr
/// w ##class(web.DHCEMObsRoomSeat).PlanPatSeat("4636^75||18^HBJZ01^407^12/12/2018^17:09:44^3^^75")
ClassMethod PlanPatSeat(Param)
{
	n (Param)
	;s BedID = $p(Param,"^",2)
	;s PatAdm = $p(Param,"^",4)
	;s PatBedID = $p(^PAADM(PatAdm),"^",73)   //当前床铺

	ts
	b ;err
	s rs = ..UpdateOrInsertAdmTrans(Param)     //修改PAC_BEDADM,PA_AdmTransaction
	i rs'=0 tro
	q:rs'=0 rs
	
	s rs = ..UpdateAdm(Param)              	   //修改PAAdm
	i rs'=0 tro
	q:rs'=0 rs
	
	s rs = ..UpdateDHCAdm(Param)              //修改DHCPaAdm
	i rs'=0 tro
	q:rs'=0 rs
	tc
	
	q "0"
}

/// end
ClassMethod ClearOrInsertBedAdm(PatBedID, BedID)
{
	n (PatBedID,BedID)
	i PatBedID'="" d
	.&sql(DELETE PAC_BedAdm WHERE ADM_ParRef=:PatBedID)
	q:BedID="" 0
	&SQL(Insert Into PA_AdmTransaction(TRANS_StartDate,TRANS_StartTime,TRANS_Room_DR,TRANS_Ward_DR,TRANS_Bed_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,TRANS_TransType_DR)
	values(:CurDate,:CurTime,:TRANSRoomDR,:TRANSWardDR,:BedID,:TRANSStatusDR,:TRANSUpdateDate,:TRANSUpdateTime,:TRANSUpdateUserDR,:TRANSTransTypeDR))
	q:SQLCODE'=0 "-108"
	q 0
}

ClassMethod UpdatePatSeat()
{
	n (Param)
	s BedID = $p(Param,"^",2)
	s PatAdm = $p(Param,"^",3)
	s PatBedID = $p(^PAADM(PatAdm),"^",73)
}

/// 修改Adm表中床位指向
/// W ##class(web.DHCEMObsRoomSeat).UpdateAdm("4636^75||10^3461^6114^09/11/2017^15:45:32")
ClassMethod UpdateAdm(Param)
{
	n (Param)
	s PatAdm = $p(Param,"^",4)
	s BedID = $p(Param,"^",2)
	s DocCode = $p(Param,"^",3)
	s DocID=""
	s:DocCode'="" DocID = $o(^CTPCP(0,"Code",$$ALPHAUP(DocCode),""),-1)   //医生ID
	s:BedID'="" RoomDr = $p(^PAWARD(+BedID,"BED",$p(BedID,"||",2)),"^",3)
	s:BedID="" RoomDr = ""
	i DocCode'="" d
	.&SQL(Update Pa_Adm Set PAADM_CurrentBed_DR=:BedID,PAADM_AdmDocCodeDR=:DocID,PAADM_CurrentRoom_DR=:RoomDr Where PAADM_RowID =:PatAdm )      //先是取消床位安排
	i DocCode="" d
	.&SQL(Update Pa_Adm Set PAADM_CurrentBed_DR=:BedID,PAADM_CurrentRoom_DR=:RoomDr Where PAADM_RowID =:PatAdm )      //先是取消床位安排
	q:SQLCODE'=0 "-102"
	q 0
}

/// 修改主管护士
/// W ##class(web.DHCEMObsRoomSeat).UpdateAdm("4636^75||10^3461^6114^09/11/2017^15:45:32")
ClassMethod UpdateDHCAdm(Param)
{
	n (Param)
	s PatAdm = $p(Param,"^",4)
	s MainNurID = +$p(Param,"^",7)
	s MainNurID2 = +$p(Param,"^",8)
	s ERR = 0
	s DHCPaAdmID = $o(^DHCPAAdm(0,"PAAdm",PatAdm,""),-1)
	i DHCPaAdmID="" d
	.&SQL(INSERT INTO DHC_PA_Adm (DHCADM_PAADM_Dr,DHCADM_MainNurse_Dr,DHCADM_MainNurse2_Dr) VALUES (:PatAdm,:MainNurID,:MainNurID2) ) 
	.s ERR = SQLCODE
	i DHCPaAdmID'="" d
	.&SQL(Update DHC_Pa_Adm Set DHCADM_MainNurse_Dr=:MainNurID,DHCADM_MainNurse2_Dr=:MainNurID2 Where DHCADM_PAADM_Dr =:PatAdm )  
	.s ERR = SQLCODE
	q:ERR'=0 "-103"
	q 0
}

/// 修改或者插入PAADMTrans表
/// Param:UserID^BedID^PatAdm^Date^Time^DocDr
/// w ##class(web.DHCEMObsRoomSeat).UpdateOrInsertAdmTrans("4636^75||18^HBJZ01^407^12/12/2018^17:09:44^3^^75")
ClassMethod UpdateOrInsertAdmTrans(Param)
{
	n (Param)
	s BedID = $p(Param,"^",2)                //床位ID:将要安排的床位ID    
	s PatAdm = $p(Param,"^",4)				 //就诊ID:当前患者的就诊ID
	s PatBedID =##class(web.DHCEMObsRoomSeat).GetPatBedID(PatAdm) ;$p(^PAADM(PatAdm),"^",73) 	 //当前安排床位
	s BedCodeName=""
	s:BedID'="" BedCodeName=$p(^PAWARD(+BedID,"BED",$p(BedID,"||",2)),"^",1)
	s PatWardDR = $p(Param,"^",9)            //病人当前病区
	
	s AdmTransSub=$o(^PAADM(PatAdm,"TRANS",""),-1)  //用来记录安排日志
	s:AdmTransSub="" TransID=""
	s:AdmTransSub'="" TransID =PatAdm_"||"_AdmTransSub
	s CurDate = +$h 
	s CurTime = $p($h,",",2)
	s TRANSEndDate =##class(web.DHCEMCommonUtil).DateHtmlToLogical($p(Param,"^",5))     //结束日期
	s TRANSEndTime =$zth($p(Param,"^",6))												//结束时间
	s TRANSStartDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical($p(Param,"^",5))	//
	s TRANSStartTime = $zth($p(Param,"^",6))
	;s AdmInfo = ..GetAdmInfo(PatAdm)
	s TRANSRoomDR = $p(^PAADM(PatAdm),"^",69)  //可直接取Adm表
	s:BedID="" TRANSRoomDR=""
	s TRANSWardDR = PatWardDR
	s TRANSStatusDR = 5
	s TRANSTransTypeDR=2
	s TRANSUpdateDate=CurDate
	s TRANSUpdateTime = CurTime
	s TRANSUpdateUserDR = $p(Param,"^",1)
	
	s SQLCODE=0
	i TransID'="" d
	.;&SQL(Update PA_AdmTransaction Set TRANS_EndDate=:TRANSEndDate,TRANS_EndTime=:TRANSEndTime,TRANS_Room_DR=:TRANSRoomDR,TRANS_Bed_DR=:BedID,TRANS_Status_DR=4 Where TRANS_RowId=:TransID )      //先是取消床位安排
	.&SQL(Update PA_AdmTransaction Set TRANS_EndDate=:TRANSEndDate,TRANS_EndTime=:TRANSEndTime,TRANS_Status_DR=4,TRANS_BedCode=:BedCodeName Where TRANS_RowId=:TransID )      //先是取消床位安排
	.b 
	q:SQLCODE'=0 "-103"
	
	&SQL(Insert Into PA_AdmTransaction(TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,TRANS_Room_DR,TRANS_Ward_DR,TRANS_Bed_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,TRANS_TransType_DR,TRANS_BedCode)
	values(:PatAdm,:TRANSStartDate,:TRANSStartTime,:TRANSRoomDR,:TRANSWardDR,:BedID,:TRANSStatusDR,:TRANSUpdateDate,:TRANSUpdateTime,:TRANSUpdateUserDR,:TRANSTransTypeDR,:BedCodeName))
	q:SQLCODE'=0 "-104"
	s:SQLCODE=0 TransID=%ROWID  
	
	i PatBedID '="" d   ///删除已经安排的座位
	.&SQL(DELETE PAC_BedAdm WHERE ADM_ParRef =:PatBedID)  
	q:SQLCODE'=0 "-105"
	
	i BedID '="" d     ///
	.&SQL(Insert Into PAC_BedAdm(ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR) values(:BedID,:PatAdm,"O",:TransID))
	q:SQLCODE'=0 "-106"
	
	i PatBedID ="" d   ///删除等候区数据
	.s WardAdmSub = $o(^PAWARDA(0,"WADM",PatAdm,+BedID,""),-1)
	.q:+WardAdmSub=0
	.s WardAdmID = +BedID_"||"_WardAdmSub
	.&SQL(DELETE PAC_WardAdm WHERE WADM_RowId = :WardAdmID)
	q:+SQLCODE'=0 "-107"
	
	i BedID="" d       ///取消安排的时候增加一条等候区数据
	.&SQL(INSERT INTO PAC_WardAdm(WADM_ParRef,WADM_PAADM_DR,WADM_Trans_DR,WADM_BookedStatus) VALUES (:TRANSWardDR,:PatAdm,:TransID,"O") )
	q:+SQLCODE'=0 "-108"
	
	q 0
}

/// 通过就诊获取病人当前安排床位
/// w ##class(web.DHCEMObsRoomSeat).GetPatBedID("322")
ClassMethod GetPatBedID(PaAdm)
{
	n (PaAdm)
	q:+PaAdm=0 ""
	q:'$d(^PAWARDA(0,"ADM",PaAdm)) ""
	s WardID="",BedSub="",BedID=""
	s WardID = $o(^PAWARDA(0,"ADM",PaAdm,""))
	s BedSub = $o(^PAWARDA(0,"ADM",PaAdm,WardID,""))
	s BedID = WardID_"||"_BedSub
	q BedID
}

/// Param:UserID^BedID
ClassMethod IfCanPlanPat(Param)
{
	n (Param)
	s UserID = $p(Param,"^",1)
	s BedID = $p(Param,"^",2)
	s PatAdm =$p(Param,"^",4)
	s UserDesc = ..GetUserDesc(UserID)
	q:UserDesc'="NURSE" "非护士,不能操作！"    // 判断医护类型
	q:BedID="" 0                               //如果是到等候区则不需要判断床位状态
	s BedInfo =..GetBedInfoByBedID(BedID)
	q:BedInfo.hasPatFlag="Y" "已经有人,请刷新界面！"
	q:BedInfo.hasPatFlag="U" "床位当前状态不可用！"
	q:$p(^PAADM(PatAdm),"^",73)=BedID "病人已经安排了床位！"
	s TRANSEndDate =##class(web.DHCEMCommonUtil).DateHtmlToLogical($p(Param,"^",5))    
	s TRANSEndTime =$zth($p(Param,"^",6))
	s CurDate = +$h 
	s CurTime = $p($h,",",2)	
								
	q:(TRANSEndDate>CurDate) "开始时间大于当前时间！"
	q:(TRANSEndDate=CurDate)&&(TRANSEndTime>CurTime) "开始时间大于当前时间！"
	
	q 0
}

/// **QQA
/// 当前用户类型
/// return:	Desc
ClassMethod GetUserDesc(UserID)
{
	n (UserID)
	q:UserID="" ""
	s CtpcpId=$p($g(^SSU("SSUSR",UserID)),"^",14)
	q:CtpcpId="" ""
	s CtpcpTypeDr=$P($g(^CTPCP(CtpcpId,1)),"^",4) ;CTPCP_CarPrvTp_DR
	q:CtpcpTypeDr="" ""
    s CtpcpTypeDesc=$P($g(^CT("CPT",CtpcpTypeDr)),"^",4) ;CT_CarPrvTp:CTCPT_InternalType
	q CtpcpTypeDesc
}

/// **QQA
/// 获取就诊基本信息
/// return: 对象
ClassMethod GetAdmInfo(Adm)
{
	n (Adm)
	s AdmInfoObj=##class(web.DHCEMJsonObject).%New()
	s MRDiagnos = ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(Adm,"","","##")    
	s Deposit=##class(web.DHCDocOrderCommon).GetCurrentDeposit(Adm)      
	s WardDr = $p(^PAADM(Adm),"^",70)
	s WardDesc = $case(WardDr,"":"",WardDr:$P(^PAWARD(WardDr),"^",2))
	s BedDr = $p(^PAADM(Adm),"^",73)
	s RoomDr = $p(^PAADM(Adm),"^",69)
	s QueDocDr = $p(^PAADM(Adm),"^",9)
	s DHCQueueDr = $o(^User.DHCQueueI("QuePaadmDrIndex",Adm,""),-1)       
	s CTPCPDr  = $LG(^User.DHCQueueD(DHCQueueDr),8)                           //就诊号别      
	s CTPCPDesc = $p(^CTPCP(CTPCPDr,1),"^",2)
	s:QueDocDr="" QueDocDr = $LG(^User.DHCQueueD(DHCQueueDr),5)							   //就诊医生
	s QueDocDesc = $case(QueDocDr,"":"",QueDocDr:$P(^CTPCP(QueDocDr,1),"^",2))
	s QueDocCode =  $P(^CTPCP(QueDocDr,1),"^",1)  
	s QueDepDr=$p(^PAADM(Adm),"^",4) //就诊科室 update 180914 (转科操作，不取队列表就诊科室)
	s QueDepDesc = $case(QueDepDr,"":"",QueDepDr:$P(^CTLOC(QueDepDr),"^",2))
	s:QueDepDesc["-" QueDepDesc=$p(QueDepDesc,"-",2)
	s DHCPaAdmID = $o(^DHCPAAdm(0,"PAAdm",Adm,""),-1)    //主管护士和主管护士2
	s MainNurID="",MainNurID2=""
	i +DHCPaAdmID'=0 d
	.s MainNurID = $p(^DHCPAAdm(DHCPaAdmID),"^",2)
	.s MainNurID2 = $p(^DHCPAAdm(DHCPaAdmID),"^",20)
	//取下诊断医生作为主管医生 st
	s MRAdmRowid=$p(^PAADM(Adm),"^",61)
	s sub=$o(^MR(MRAdmRowid,"DIA",""))
	s DocDr="",DocDesc=""
	s:sub'="" DocDr=$p(^MR(MRAdmRowid,"DIA",sub),"^",4)
	s:DocDr'="" DocDesc=$p(^CTPCP(DocDr,1),"^",2)
	s:DocDesc'="" QueDocDesc=DocDesc 
	//ed
	d AdmInfoObj.Put("WardDr",WardDr)
	d AdmInfoObj.Put("WardDesc",WardDesc)
	d AdmInfoObj.Put("BedDr",BedDr)
	d AdmInfoObj.Put("CTPCPDr",CTPCPDr)
	d AdmInfoObj.Put("CTPCPDesc",CTPCPDesc)
	d AdmInfoObj.Put("QueDocDr",QueDocDr)
	d AdmInfoObj.Put("QueDocDesc",QueDocDesc)
	d AdmInfoObj.Put("QueDepDr",QueDepDr)
	d AdmInfoObj.Put("QueDepDesc",QueDepDesc)
	d AdmInfoObj.Put("QueDocCode",QueDocCode)
	d AdmInfoObj.Put("MRDiagnos",MRDiagnos)
	d AdmInfoObj.Put("Deposit",Deposit)
	d AdmInfoObj.Put("MainNurID",MainNurID)
	d AdmInfoObj.Put("MainNurID2",MainNurID2)
	
	q AdmInfoObj.Json()
}

/// **QQA
/// 获取病人基本信息
/// return: 对象
ClassMethod GetPatInfoByPatId(PatientID)
{
	n (PatientID,%session)
	s LgHospID=""
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")
	;s PatInfoObj={}
	s PatInfoObj=##class(web.DHCEMJsonObject).%New()
	
	s rs=""
	s PatType=$O(^PAPERdr(PatientID,"ADM",""),-1)
	s EpisodeID=$O(^PAPERdr(PatientID,"ADM",PatType,""))
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	                    /// 病人登记号
	s Medicare=##Class(web.DHCEMCommonUtil).GetMrNo(EpisodeID)      /// 病案号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)                     /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     					/// 性别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)   /// 年龄
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        			/// 出生日期
	i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //hxy
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         			/// 身份证号
	s PatNation=""
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  			/// 民族
	i nationdr'="" s PatNation=$p(^CT("NAT",nationdr),"^",2)
	s PatCountry=""
	s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	 			/// 国家
	i countrydr'="" s PatCountry=$p(^CT("COU",countrydr),"^",2)
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	  				/// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	  				/// 家庭住址
	s PatType=$p(^PAPER(PatientID,"PER",1),"^",10)     			/// 患者类型
	s:PatType'="" PatType=$p(^CT("SS",PatType),"^",2)
	s PatDiag=""
	s PatCardNo=""
	s CardTypeID=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	i CardNoID'="" d
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 		/// 卡号
	.s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 		 	/// 卡类型
	
	d PatInfoObj.Put("PatientID",PatientID)
	d PatInfoObj.Put("PatNo",PatNo)
	d PatInfoObj.Put("PatName",PatName)
	d PatInfoObj.Put("PatSex",PatSex)
	d PatInfoObj.Put("PatAge",PatAge)
	d PatInfoObj.Put("birthday",birthday)
	d PatInfoObj.Put("IdentNo",IdentNo)
	d PatInfoObj.Put("PatNation",PatNation)
	d PatInfoObj.Put("PatCountry",PatCountry)
	d PatInfoObj.Put("PatTelH",PatTelH)
	d PatInfoObj.Put("Address",Address)
	d PatInfoObj.Put("PatType",PatType)
	d PatInfoObj.Put("PatCardNo",PatCardNo)
	d PatInfoObj.Put("CardTypeID",CardTypeID)
	d PatInfoObj.Put("Medicare",Medicare)
	q PatInfoObj.Json()
}

/// **QQA
/// 获取病人基本信息
/// return: 对象
/// w ##class(web.DHCEMObsRoomSeat).GetBedInfoByBedID("30||4").%ToJSON()
ClassMethod GetBedInfoByBedID(BedDr)
{
	n (BedDr,%session)
	s BedInfoObj={}
	s WardId = +BedDr
	s BedSub = $p(BedDr,"||",2)
	s RoomDr = $p(^PAWARD(WardId,"BED",BedSub),"^",3)   //房间ID
	s RoomTypeDr = $p(^PAROOM(RoomDr),"^",3) //房间类型
	s BedStatusInfo = ##class(web.DHCEMObsRoomSeat).GetBedStatus(BedDr)   //获取包床时间
	s BedTypeID = $p(^PAWARD(WardId,"BED",BedSub),"^",2)
	s BedInfoObj.BedID =  BedDr
	s BedInfoObj.BedCode = $p(^PAWARD(WardId,"BED",BedSub),"^",1)
	s BedInfoObj.BedType=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACBedType","BEDTPDesc","",$p($g(^PAC("BEDTP",BedTypeID)),"^",2))
	s BedInfoObj.WardID= WardId
	s BedInfoObj.WardDesc = ##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",$p(^PAWARD(WardId),"^",2))
	s BedInfoObj.WardRoomDR = RoomDr
	s BedInfoObj.WardRoomDesc = ##class(web.DHCEMCommonUtil).GetTransDesc("User.PACRoom","ROOMDesc","",$p(^PAROOM(RoomDr),"^",2))
	S BedInfoObj.WardRoomType = ##class(web.DHCEMCommonUtil).GetTransDesc("User.PACRoomType","ROOMTDesc","",$p(^PAC("ROOMT",RoomTypeDr),"^",2))
	s BedInfoObj.unavailReason = ""
	s BedInfoObj.unavailStDate = ""
	s BedInfoObj.unavailStTime = ""
	s BedInfoObj.unavailEndDate = ""
	s BedInfoObj.unavailEndTime = ""
	s AdmSub  = $o(^PAWARDA(WardId,"BED",BedSub,"ADM",0)) 
 	s:+AdmSub'=0 BedInfoObj.hasPatFlag="Y"              	//床位已经有人
 	s:+AdmSub=0 BedInfoObj.hasPatFlag="N"
	i BedStatusInfo.statusCode="U" d
	.s BedInfoObj.statusCode="U"
	.s BedInfoObj.unavailReason = BedStatusInfo.unavailReason
	.s BedInfoObj.unavailStDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(BedStatusInfo.unavailStDate)
	.s BedInfoObj.unavailStTime = $zt(BedStatusInfo.unavailStTime)
	.s BedInfoObj.unavailEndDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(BedStatusInfo.unavailEndDate)
	.s BedInfoObj.unavailEndTime = $zt(BedStatusInfo.unavailEndTime)
	q BedInfoObj
}

// w ##class(web.DHCEMObsRoomSeat).GetObsPatObstime(1371)

ClassMethod GetObsPatObstime(Adm)
{
	n (Adm,%session)
	q:Adm="" ""
	s TrsH=##class(web.DHCEMCommonUtil).GetTrans("dhcem.obsroomseatnew.csp","时")
	s TrsM=##class(web.DHCEMCommonUtil).GetTrans("dhcem.obsroomseatnew.csp","分")
	s TrsD=##class(web.DHCEMCommonUtil).GetTrans("dhcem.obsroomseatnew.csp","天")
	s ObsAllDate=""
	s ObsDate = ..GetFirstInSeatDate(Adm)
	s ObsStDate = +ObsDate
	s ObsStTime = $p(ObsDate,"^",2)
	s ObsEndDate = +$h
	s ObsEndTime = $p($h,",",2)
	s ObsAllDateMin=(ObsEndDate-ObsStDate*24*60)+(ObsEndTime-ObsStTime\60)   //分钟数
	s:ObsAllDateMin<0 ObsAllDateMin=0
	s ObsAllDateHou = ObsAllDateMin/60
	
	i ObsAllDateHou<24 d 
	.;s ObsAllDate = ObsAllDateMin\60_"时"_$p(ObsAllDateMin#60,".",1)_"分"
	.s:(ObsAllDateMin\60) ObsAllDate = ObsAllDateMin\60_TrsH //"时"
	.s:'(ObsAllDateMin\60) ObsAllDate = $p(ObsAllDateMin#60,".",1)_TrsM //"分"
	.s:ObsAllDateMin=0 ObsAllDate=0_TrsM //"分"
	i ObsAllDateHou>=24 d
	.s ObsAllDate = ObsEndDate-ObsStDate_TrsD //"天"
	q ObsAllDate
}

// w ##class(web.DHCEMObsRoomSeat).GetFirstInSeatDate(1371)

ClassMethod GetFirstInSeatDate(Adm)
{
	n (Adm)
	s ObsStDate="",ObsStTime=""
	s AdmTransSub=0 
	f  s AdmTransSub = $o(^PAADM(Adm,"TRANS",AdmTransSub)) q:(AdmTransSub="")!(ObsStDate'="")  d
	.q:$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",8)=""
	.s ObsStDate=$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",1)
	.s ObsStTime = $p(^PAADM(Adm,"TRANS",AdmTransSub),"^",2)
	q ObsStDate_"^"_ObsStTime
}

ClassMethod GetFirstInSeatDateDesc(Adm)
{
	n (Adm)
	q:Adm="" ""
	s ObsStDate="",ObsStTime=""
	s AdmTransSub=0 
	f  s AdmTransSub = $o(^PAADM(Adm,"TRANS",AdmTransSub)) q:(AdmTransSub="")!(ObsStDate'="")  d
	.q:$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",8)=""
	.s ObsStDate=$p(^PAADM(Adm,"TRANS",AdmTransSub),"^",1)
	.s ObsStTime = $p(^PAADM(Adm,"TRANS",AdmTransSub),"^",2)
	q ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ObsStDate)_" "_$zt(ObsStTime)
}

/// **QQA
/// 将日期格式转换为Sql需要的格式
/// return: 对象
/// w ##class(web.DHCEMObsRoomSeat).GetBedInfoByBedID("30||2")
/// W ##class(web.DHCEMObsRoomSeat).Test()
ClassMethod FormatSqlDate(Date)
{
	n (Date)
	q:Date["-" Date
	q:Date["/" $zd(##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date),3)
	q $zd(+Date,3)
}

ClassMethod Test()
{
 WRITE "start",!
  &html<
    <html>
      <body>
        <b>I'm bold!</b>
        <i>I'm italic</i>
        <u>I'm underlined</u>
      </body>
    </html>
  >
  WRITE "end"
}

/// W ##class(web.DHCEMObsRoomSeat).GetPNurList("286","")
ClassMethod GetPNurList(DepRowId, q = "")
{
	n (DepRowId,q,%session)
	Set result=##class(%Library.ResultSet).%New("web.DHCMainNurse:IPNurList")
	Set sc=result.Execute(DepRowId,q)
	If $$$ISERR(sc) Quit ""
	
	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.s CurData=$P(result.%GetData(i),$C(13,10))
		.i result.GetColumnName(i)="NurDesc" s CurData=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CurData) 
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_CurData_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_CurData_del
#;		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
#;		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		s retObj = ##class(%DynamicAbstractObject).%FromJSON("{"_ret_"}")
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

/// Creator：   lvpeng
/// CreatDate： 2018-09-08
/// Description:获取床位上相关就诊科室人数
/// Table：PAC_Ward、PAC_Bed
/// Input：pid (进程号)
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetLocBySeatNum("3797")
ClassMethod GetLocBySeatNum(pid)
{
	n (pid)
	q:pid="" "[]"
	w "["
	s count=0
	s LocDesc=""
	f  s LocDesc=$o(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,LocDesc)) q:LocDesc=""  d
	.s LocAdmNum=^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,LocDesc)
	.s tmp=LocDesc_"^"_LocAdmNum
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("LocDesc^Num",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("LocDesc^Num",tmp)
	w "]"
	
	k ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid)
	q ""
}

/// 获取病人72小时留观标志
/// return: flag 1：超过 0：没超过
/// w ##class(web.DHCEMObsRoomSeat).GetObsPatSevenTwoFlag()
ClassMethod GetObsPatSevenTwoFlag(Adm)
{
	n (Adm)
	s Flag=0
	q:Adm="" Flag
	s PatType=$p(^PAADM(Adm),"^",2) 
	if (PatType'="E") Q Flag
	s ObsAllDate=""
	s ObsDate = ..GetFirstInSeatDate(Adm)
	q:+ObsDate=0 0
	s ObsStDate = +ObsDate
	s ObsStTime = $p(ObsDate,"^",2)
	s ObsEndDate = +$h
	s ObsEndTime = $p($h,",",2)
	s ObsAllDateMin=(ObsEndDate-ObsStDate*24*60)+(ObsEndTime-ObsStTime/60)   //分钟数
	s ObsAllDateHou = ObsAllDateMin/60
	
	i (ObsAllDateHou>72) d
	.s Flag=1
	
	q Flag
}

/// W ##class(web.DHCEMObsRoomSeat).GetWardIconInfo("75")
ClassMethod GetWardIconInfo(WardID, LgParams)
{
	n (WardID,LgParams,%request,%session)
	q:WardID=""
	s BEDORDTIPFORM=##class(web.DHCEMNurExe).GetConfigBySession("BEDORDTIPFORM",LgParams)
	s:BEDORDTIPFORM="" BEDORDTIPFORM="SYDO"
	s DynamicObj=##class(web.DHCAPPJsonObject).%New() //代替16语法空对象 lp
	w "["
	s BedSub=0,Count=0
	f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	.q:$p(^PAWARD(WardID,"BED",BedSub),"^",4)'="Y"
	.q:($p($g(^PAWARD(WardID,"BED",BedSub)),"^",18)="") //没维护宽度
	.s ADMChildsub ="",PaAdm=""
	.s ADMChildsub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	.q:+ADMChildsub=0 
	.s PaAdm=$p(^PAWARDA(WardID,"BED",BedSub,"ADM",ADMChildsub),"^",1)
	.q:+PaAdm=0 
	.s PatID = $p(^PAADM(PaAdm),"^",1)
	.s IsHasSyOrd=##class(web.DHCEMPatientSeat).IsHasSyOrd(PatID,LgParams,BEDORDTIPFORM)
	.s IconHtmlText = ##class(web.DHCDocMain).ShowIcon("MAP",PaAdm_"^^^"_PatID,"")
	.q:IconHtmlText="" 
	.s SeatID = WardID_"||"_BedSub
	.d DynamicObj.Put("SeatID",SeatID) 
	.d DynamicObj.Put("IconHtmlText",IconHtmlText)
	.d DynamicObj.Put("IsHasSyOrd",IsHasSyOrd) 
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w DynamicObj.JsonNoOp()
	w "]"
	q ""
}

/// Creator:qqa
/// Descript:留观室床位界面获取全局变量的
/// w ##class(web.DHCEMObsRoomSeat).GetGlobleParams(0)
ClassMethod GetGlobleParams(Params)
{
	n (Params)
	s Ret=""
	s Offset=$p(Params,"^",1)
	s CurDate = ##Class(web.DHCEMConsultCom).GetCurSystemDate(Offset)
	s CurTime=$zt($p($h,",",2),1)
	s Ret=CurDate_"^"_CurTime
	q Ret
}

/// 病人转病区、转床 ;wardDescOrId  bedId editPreTrans
/// w ##class(web.DHCEMObsRoomSeat).GetGlobleParams(0)
ClassMethod MoveAdm(EpisodeID = "", UserID = "", WardID = "", BedID = "", EditPreTrans = "Y") As %String
{
	q:(EpisodeID="") "无病人信息!"
	q:(UserID="") "无用户信息!"
	s:BedID'="" WardID=+BedID
	q:(WardID="") "无病区信息!"
	
	s WardDesc=""
	s:WardID'="" WardDesc=$p(^PAWARD(+WardID),"^",2)
	
	s RoomID="",BedSub="",BedCodeName=""
	i BedID'="" s BedSub=$p(BedID,"||",2)
	s:BedID'="" BedCodeName=$p(^PAWARD(+BedID,"BED",BedSub),"^",1)
	i BedSub'="" s RoomID=$p(^PAWARD(+BedID,"BED",BedSub),"^",3)
	s CurDate=+$h,CurTime=$p($h,",",2)
	s ReqstID=$o(^PAC("REQST",0,"Code","T",""))
	s TranstypID=$o(^PAC("TRANSTYP",0,"Code","M",""))
	
	s PreTransSub="",TransSub=0
	f  s PreTransSub=$o(^PAADM(EpisodeID,"TRANS",PreTransSub),-1) q:(PreTransSub="")!(TransSub>0)  d
	.i $p(^PAADM(EpisodeID,"TRANS",PreTransSub),"^",21)=TranstypId s TransSub=PreTransSub
	
	s FirstToBed=1,TmpTransSub=""
	f  s TmpTransSub=$o(^PAADM(EpisodeID,"TRANS",TmpTransSub)) q:(TmpTransSub="")||(FirstToBed=0)  d
	.i +$p($g(^PAADM(EpisodeID,"TRANS",TmpTransSub)),"^",8)>0 s FirstToBed=0
	i (FirstToBed=1){		//第一次分床时记录下时间		
		s MotherAdm=$p($g(^PAADM(EpisodeID)),"^",75)
		i MotherAdm'="" d
		.s PAAdmCurrLoc = $p($g(^PAADM(motherAdm)),"^",4)
		.s AdminDateTimeRtn = ##class(web.DHCDischargeHistory).SaveAdminDateTime(EpisodeID,CurDate,CurTime,2,PAAdmCurrLoc,wardId)	
				
	}
	
	i TransSub>0,EditPreTrans="Y" d
    .s PreTransId=EpisodeID_"||"_TransSub
    .s PreReqstID=$o(^PAC("REQST",0,"Code","D",""))
    .&sql(UPDATE PA_AdmTransaction set TRANS_Status_DR=:PreReqstID,TRANS_EndDate=:CurDate,TRANS_EndTime=:CurTime,TRANS_BedCode=:BedCodeName where TRANS_RowId=:PreTransId)
	&sql(INSERT INTO PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		TRANS_Ward_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
		TRANS_TransType_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_BedCode)  
		Values (:EpisodeID,:CurDate,:CurTime,:WardID,:ReqstID,:CurDate,:CurTime,:UserID,:TranstypId,:RoomID,:BedID,:BedCodeName))
	i SQLCODE q "插入转病区信息出错!"
	s TransID=$g(%ROWID)
	q:TransID="" "插入转病区信息出错!"
	s BookedStatus="O"
	i $o(^PAWARDA(0,"ADM",EpisodeID,""))'="" d
    .;s MBabyBedtpID=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY","")) //hxy 2023-03-21 注释，改为走护理组判断是否未婴儿床接口
    .s CurWardID=$o(^PAWARDA(0,"ADM",EpisodeID,""))
    .s CurBedSub=$o(^PAWARDA(0,"ADM",EpisodeID,+CurWardID,""))
    .s BedtpID=$p(^PAWARD(+CurWardID,"BED",+CurBedSub),"^",2)
    .&sql(DELETE FROM PAC_BedAdm WHERE ADM_PAADM_DR=:EpisodeID)
    .q:SQLCODE
    .s BedTypeCode=$p($g(^PAC("BEDTP",+BedtpID)),"^",1) //hxy 2023-03-21 st 判断是否未婴儿床接口调用(接口判断为包含)
    .s IfBabyBed=##class(web.DHCEMCommonUtil).IfBabyBed(BedTypeCode) 
    .i IfBabyBed="Y" s $p(^PAWARD(CurWardID,"BED",CurBedSub),"^",4)="N"
    .;q:MBabyBedtpID=""
    .;i MBabyBedtpID=BedtpID s $p(^PAWARD(CurWardID,"BED",CurBedSub),"^",4)="N" //ed
    
	i $o(^PAWARDA(0,"WADM",EpisodeID,""))'="" &sql(DELETE FROM PAC_WardAdm WHERE WADM_PAADM_DR=:EpisodeID)
	if BedSub'="" 
	{
		&sql(INSERT INTO PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:BedID,:EpisodeID,:BookedStatus,:TransID))
		i SQLCODE q "插入床位信息出错!"

	}else{
		&sql(INSERT INTO PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR)
			VALUES (:WardID,:EpisodeID,:BookedStatus,:TransID))
		i SQLCODE q "插入等待区信息出错!"
	}
	
	&sql(UPDATE PA_Adm (PAADM_CurrentBed_DR,PAADM_CurrentWard_Dr,PAADM_CurrentRoom_DR) Values (:BedID,:WardID,:RoomID) 
		WHERE PAADM_RowId=:EpisodeID)
	i SQLCODE q "更新就诊病区、房间及床位信息出错!"
	
	s CtacuID=""
	i WardID="" d
	.s LocID="",CptSub="",CaretypID="",CaretypCode=""
	.s LocID=$p(^PAWARD(+WardID),"^",5)
	.s:LocID'="" CptSub=$o(^CTLOC(+LocID,"CPT",0))
	.s:CptSub'="" CaretypID=$p($g(^CTLOC(LocID,"CPT",CptSub)),"^")
	.s:CaretypID'="" CaretypCode=$p(^PAC("CARETYP",CaretypID),"^")
	.s:CaretypCode'="" CtacuID=$o(^CT("ACU",0,"Code",CaretypCode,""))
	i CtacuID'="" d
	.&sql(update PA_Adm (PAADM_Priority_DR) Values (:CtacuID) Where PAADM_RowId=:EpisodeID)
    i SQLCODE q "修改病人等级出错!"
	
	q 0
}

/// Creator：   qiaoqingao
/// CreatDate： 2017-10-26
/// Description:获取该病区下所有的床位信息以及床位安排病人信息
/// Table：PAC_Ward、PAC_Bed
/// Input：病区ID
/// Return：
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPatSeatData("")
ClassMethod JsonPatSeatData(WardID, LgParams, OtherParams, Pid)
{
	n (WardID,LgParams,OtherParams,Pid,%session)
	w "["
	s BedSub=0,Count=0
	f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	.s ActiveFlag=$p(^PAWARD(WardID,"BED",BedSub),"^",4)
	.q:(ActiveFlag'="Y")
	.s BedStDate = $p(^PAWARD(WardID,"BED",BedSub),"^",21)
	.s BedEndDate = $p(^PAWARD(WardID,"BED",BedSub),"^",22)
	.s ADMChildsub ="",PaAdm=""
	.s ADMChildsub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	.s:+ADMChildsub'=0 PaAdm=$p(^PAWARDA(WardID,"BED",BedSub,"ADM",ADMChildsub),"^",1)
	.q:(PaAdm="")&&(BedStDate'="")&&(BedStDate>+$h)
	.q:(PaAdm="")&&(BedEndDate'="")&&(BedEndDate<+$H)
	.q:($p($g(^PAWARD(WardID,"BED",BedSub)),"^",18)="") //没维护宽度
	.s BedRoomId=$p(^PAWARD(+WardID,"BED",BedSub),"^",3)  //房间名称 （原来取得是床类型名称）  update 180917
	.s BedName = $p(^PAWARD(WardID,"BED",BedSub),"^",1)   //床位名称
	.s BedTipMessage = ""
	.s:(BedStDate'="")&&(BedStDate>+$h) BedTipMessage=BedName_"床尚未至启用时间,请及时处理床位上病人！"
	.s:(BedEndDate'="")&&(BedEndDate<+$H) BedTipMessage=BedName_"床已至停用时间,请及时处理床位上病人！"
	.s BedRoomDesc=""
	.s:BedRoomId'="" BedRoomDesc=$p(^PAROOM(BedRoomId),"^",2)
	.s BEDPositionLeft=$p(^PAWARD(WardID,"BED",BedSub),"^",15)
	.s BEDPositionTop=$p(^PAWARD(WardID,"BED",BedSub),"^",16)
	.s BEDPositionHeight=$p(^PAWARD(WardID,"BED",BedSub),"^",17)
	.s BEDPositionWidth=$p(^PAWARD(WardID,"BED",BedSub),"^",18)
	.s PaAdmID=""
	.s AdmSub  = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0)) 
 	.s:+AdmSub'=0 PaAdmID = $p(^PAWARDA(WardID,"BED",BedSub,"ADM",AdmSub),"^",1)
 	
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w "{"
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BedID",WardID_"||"_BedSub,1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BEDCode",BedName,1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BEDPositionLeft",BEDPositionLeft,1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BEDPositionTop",BEDPositionTop,1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BEDPositionHeight",BEDPositionHeight,1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BEDPositionWidth",BEDPositionWidth,1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BEDPositionHeight",BEDPositionHeight,1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("IconHtmlText","",1)
	.w ##class(web.DHCEMObsRoomSeat).JsonItmString("BedTipMessage",BedTipMessage,1)
	.w """BEDStatus"":"
	.w ##class(web.DHCEMJsonCommon).getJsonData("statusCode^unavailPatAdm^unavailReason","")
	.w ","
	.w """PatInfo"":"
	.w ##class(web.DHCEMObsRoomSeat).GetPatJsonData(PaAdmID,LgParams,OtherParams,Pid)
	.w ","
	.w """PatInfoHtmlText"":"
	.w """"_""_""""  ;##class(web.DHCEMObsRoomSeat).GetPatInfoHtmlByAdm(PaAdmID)
	.w "}"
	
	w "]"
	q ""
}

/// Creator：   qiaoqingao update（lp） 16语法改10 返回对象改成返回json
/// CreatDate： 2017-10-26
/// Description:通过床位ID获取床位病人信息
/// Table：PAC_Bed、PAC_BedAdm
/// Input：床位ID
/// Return：Object
/// 返回:Json
/// W ##class(web.DHCEMObsRoomSeat).GetPatJsonData("228","2^70^22^13806","1")
ClassMethod GetPatJsonData(PaAdmID, LgParams, OtherParams, pid)
{
	n (PaAdmID,LgParams,OtherParams,pid,%session)
	
	q:+PaAdmID=0 "{}"
	s FilterType=$p(OtherParams,"^",1)
	s FilterValue=$p(OtherParams,"^",2)
	s PatientID=+^PAADM(PaAdmID)
	s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(PaAdmID)
	s NurseLevel=""
	s Priority=+$P($g(^PAADM(PaAdmID)),"^",33)   /// 就诊表级别
	i Priority'=0 s NurseLevel=+$p($g(^CT("ACU",Priority)),"^",1)
	q:(FilterType="ChkLev")&&(FilterValue'="")&&(+FilterValue'=NurseLevel) "{}"
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)     						/// 性别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	                    /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)                     /// 病人姓名
	s ChPatSex=PatSex
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-20
	q:(FilterType="PatNo")&&(FilterValue'="")&&(FilterValue'=PatNo) "{}"
	q:(FilterType="PatName")&&(FilterValue'="")&&(PatName'[FilterValue) "{}"
	q:(FilterType="PatSex")&&(FilterValue'="")&&(PatSex'[FilterValue) "{}"
	s FilterType=$p(OtherParams,"^",1)
	s FilterValue=$p(OtherParams,"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",AdmHospID)   /// 年龄
	s PatType=$p(^PAPER(PatientID,"PER",1),"^",10)     			/// 患者类型
	s:PatType'="" PatType=$p(^CT("SS",PatType),"^",2)
	s QueDepDr=$p(^PAADM(PaAdmID),"^",4) //就诊科室 update 180914
	s QueDepDesc = $case(QueDepDr,"":"",QueDepDr:$P(^CTLOC(QueDepDr),"^",2))
	s QueDepDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",QueDepDesc) //hxy 2022-12-20
	q:(FilterType="AdmLoc")&&(FilterValue'="")&&(QueDepDesc'[FilterValue) "{}"
	
	s:QueDepDesc["-" QueDepDesc=$p(QueDepDesc,"-",2)
	
	s PAAdmDocCodeDR=$P($g(^PAADM(PaAdmID)),"^",9)  //就诊医生
	s Doctor=""
	s:Doctor'="" Doctor=$P($g(^CTPCP(PAAdmDocCodeDR,1)),"^",2)
	s CareLevel = ##class(Nur.CommonInterface.Patient).getCareLevel(PaAdmID)
	s AdmReason=""
	s PAADMAdmReasonDR=$p(^PAADM(PaAdmID,1),"^",7)
	s:PAADMAdmReasonDR'="" AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s AdmCareInfo = ##class(web.DHCEMInComUseMethod).GetRegMark(PaAdmID)
	s AdmCare=$p(AdmCareInfo,"^",1)
	q:(FilterType="Care")&&(FilterValue'="")&&(AdmCare'[FilterValue) "{}"
	
	s ObsPatObsDate=##class(web.DHCEMObsRoomSeat).GetObsPatObstime(PaAdmID)
	s PatObsDateDesc=##class(web.DHCEMObsRoomSeat).GetFirstInSeatDateDesc(PaAdmID)
	s Deposit=""	;##class(web.DHCDocOrderCommon).GetCurrentDeposit(PaAdmID)
	s MRDiagnos= ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(PaAdmID,"","","","Y")
	q:(FilterType="Diagnos")&&(FilterValue'="")&&(MRDiagnos'[FilterValue) "{}"
	
	s BEDORDTIPFORM=##class(web.DHCEMNurExe).GetConfigBySession("BEDORDTIPFORM",LgParams)
	s:BEDORDTIPFORM="" BEDORDTIPFORM="SYDO"
	s IsHasSyOrd = "" ;##class(web.DHCEMPatientSeat).IsHasSyOrd(PatientID,LgParams,BEDORDTIPFORM)
	q:(FilterType="HasNoExecOrd")&&(FilterValue'="")&&(IsHasSyOrd'=1) "{}"
	s SevenTwoFlag=##class(web.DHCEMObsRoomSeat).GetObsPatSevenTwoFlag(PaAdmID)    //72小时标志
	q:(FilterType="Out72Hours")&&(FilterValue'="")&&(SevenTwoFlag'=1) "{}"
	
	s AdmReason=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACAdmReason","READesc","",AdmReason) //hxy 2022-12-20 st
	s Doctor=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",Doctor) 
	s PatType=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSocialStatus","SSDesc","",PatType) //ed
	
	;就诊科室和72小时超时
	i $d(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc))  d
	.s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)=^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)+1
	e  d
	.s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)=$i(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc))
	
	s SeventyT=##class(web.DHCEMCommonUtil).GetTrans("dhcem.obsroomseatnew.csp","超过72小时") //hxy 2022-12-20
	i SevenTwoFlag=1 d
	.i $d(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,SeventyT))  d
	..s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,SeventyT)=^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,SeventyT)+1
	.e  d
	..s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,SeventyT)=$i(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,SeventyT))	
	
	
	s ItmData = PaAdmID_"^"_PatientID_"^"_AdmReason_"^"_ObsPatObsDate_"^"_PatObsDateDesc_"^"_Deposit
	s ItmData = ItmData_"^"_MRDiagnos_"^"_QueDepDesc_"^"_Doctor_"^"_CareLevel_"^"_AdmCare_"^"_PatNo
	s ItmData = ItmData_"^"_PatName_"^"_PatSex_"^"_NurseLevel_"^"_PatAge_"^"_PatType_"^"_IsHasSyOrd
	s ItmData = ItmData_"^"_ChPatSex
	
	s ItmTitle="PaAdm^PatientID^AdmReason^PatObsDate^PatObsDateDesc^Deposit^MRDiagnos^QueDepDesc^Doctor^CareLevel^AdmCare"
	s ItmTitle=ItmTitle_"^PatNo^PatName^PatSex^NurseLevel^PatAge^PatType^IsHasSyOrd^ChPatSex"
	
 	q ##class(web.DHCEMJsonCommon).getJsonData(ItmTitle,ItmData)
}

/// 这个方法用于获取前台显示病人信息的html内容
/// w ##class(web.DHCEMObsRoomSeat).GetPatInfoHtmlByAdm(1)
ClassMethod GetPatInfoHtmlByAdm1(AdmID)
{
	n (AdmID)
	q:AdmID="" ""
	s PatInfoHtml=""
	s PatientID = $p(^PAADM(AdmID),"^",1)
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)     						/// 性别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	                    /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)                     /// 病人姓名
	
	s MRDiagnos = ##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmID,"##") 
	s MRDiagnos=$p($g(MRDiagnos),"##",1)
	s:$l(MRDiagnos)>7 MRDiagnos = $e(MRDiagnos,1,6)_"..."
	s EmPCLvID="",NurseLevel="",NurseLevelHtml=""					//分诊ID、护士分级
	s:$d(^DHCEMPCA(0,"AdmChkLev",AdmID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",AdmID,""))
	s:EmPCLvID'="" NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)
	s Priority=+$P($g(^PAADM(AdmID)),"^",33)   /// 就诊表级别
	i Priority'=0 s NurseLevel=+$p($g(^CT("ACU",Priority)),"^",1)
	s:+NurseLevel'=0 NurseLevelHtml="<span style='border-radius:5px;background:"_$case(NurseLevel,1:"red",2:"orange","3":"yellow",4:"#66d466",5:"#66d466")_"'>"_$case(NurseLevel,1:"Ⅰ",2:"Ⅱ",3:"Ⅲ",4:"Ⅳa",5:"Ⅳb")_"级</span>"
	s:+NurseLevel=0 NurseLevelHtml="<span>未分级</span>"
	s PatInfoHtml ="<table>"
	s sexColor="#000" //hxy 2018-04-25 st
	i PatSex="男" s sexColor="#36AAED"
	i PatSex="女" s sexColor="#FF7368"
	s PatObsDateDesc = ..GetFirstInSeatDateDesc(AdmID)   //留观开始时间
	s:PatObsDateDesc'="" PatObsDateDesc=$p(PatObsDateDesc," ",1) 
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>ID:</td><td>"_PatNo_"</td></tr>"   
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>姓名:</td><td>"_PatName_"</td></tr>"   
	s PatInfoHtml =PatInfoHtml_"<tr><td>性别:</td><td>"_PatSex_"</td></tr>"	
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>分级:</td><td>"_NurseLevelHtml_"</td></tr>"
	s PatInfoHtml =PatInfoHtml_"<tr><td style='white-space:nowrap'>诊断:</td><td>"_MRDiagnos_"</td></tr>"
	s PatInfoHtml =PatInfoHtml_"</table>"
	
	q PatInfoHtml
}

ClassMethod SetOutTimeNumber(QueDepDesc, PatPaAdm, pid)
{
	n (QueDepDesc,PatPaAdm,pid)
	i $d(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc))  d
	.s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)=^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)+1
	e  d
	.s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc)=$i(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,QueDepDesc))
	s SevenTwoFlag=##class(web.DHCEMObsRoomSeat).GetObsPatSevenTwoFlag(PatPaAdm)    //72小时标志
	i SevenTwoFlag=1 d
	.i $d(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时"))  d
	..s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时")=^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时")+1
	.e  d
	..s ^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时")=$i(^TMP("DHCEM","web.DHCEMObsRoomSeat","GetPatInfoBySeatId",pid,"超过72小时"))	
	q 0
}

/// w ##class(web.DHCEMObsRoomSeat).JsonItmString("name","qqa")
ClassMethod JsonItmString(Key, Value, AddComma = "")
{
	n (Key, Value,AddComma)
	s Ret= """"_Key_""""_":"_""""_Value_""""
	s Ret=Ret_$case(AddComma,1:",",:"")
	q Ret
}

ClassMethod GetPrvDoc(EpisodeID)
{
	n (EpisodeID,%session)
	s QueDocDr = $p(^PAADM(EpisodeID),"^",9)
	s QueDoc = $p($g(^CTPCP(+QueDocDr,1)),"^",2)
	s QueDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",QueDoc) 
	s SeatAdmLoc=$p(^PAADM(EpisodeID),"^",4)
	q QueDocDr_"^"_QueDoc_"^"_SeatAdmLoc
}

ClassMethod UpdPrvDoc(EpisodeID, ChargDoc)
{
	n (EpisodeID,ChargDoc)
	q:+EpisodeID=0 "就诊不能为空!"
	
	&sql(UPDATE PA_Adm Set PAADM_AdmDocCodeDR=:ChargDoc WHERE PAADM_RowID=:EpisodeID)
	q:SQLCODE'=0 "修改就诊表错误,SqlCode:"_SQLCODE
	
	q 0
}

Storage Default
{
<Data name="DHCEMObsRoomSeatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMObsRoomSeatD</DataLocation>
<DefaultData>DHCEMObsRoomSeatDefaultData</DefaultData>
<IdLocation>^web.DHCEMObsRoomSeatD</IdLocation>
<IndexLocation>^web.DHCEMObsRoomSeatI</IndexLocation>
<StreamLocation>^web.DHCEMObsRoomSeatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
