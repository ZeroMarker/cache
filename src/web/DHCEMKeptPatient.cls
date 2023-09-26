Import SQLUser

Class web.DHCEMKeptPatient Extends %Persistent [ Not ProcedureBlock ]
{

// d ##class(web.DHCEMKeptPatient).FindEmergencydjb("0","15","2017-02-04","2017-02-14","159","")

// 0^15^2016-10-12^2016-10-12^895^

// 0^15^2016-10-13^2016-10-13^895

// w ##class(web.DHCEMKeptPatient).ListObservationPatient(1,0,"2017-03-24","2017-03-24","159","")

ClassMethod ListObservationPatient(page, rows, startDate As %String, endDate As %String, Loc As %String, emWardId As %String, otherParams)
{
    
	s Start=page-1*rows+1
	s End=page*rows
    S count=0
    s inPatName=$p(otherParams,"^",1)
    s inOnlyShowTransInHospPat=$p(otherParams,"^",2)
    
    s pid=$I(^DHCST("EMPatCheckLevCom"))
    K ^TMP("DHCEM","web.DHCEMKeptPatient","ListObservationPatient")
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	i startDate'=""  s startDate=##class(websys.Conversions).DateHtmlToLogical(startDate)
 	i startDate=""  s startDate=+$h
 	i endDate'=""  s endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	i endDate=""  s endDate=+$h
	s today=+$h
 	s Num=0
 	f stDate=startDate:1:endDate  d 
  	.s stTime=""
 	.f  s stTime=$o(^PAADMi("TransDateTime",stDate,stTime))   Q:stTime=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TransDateTime",stDate,stTime,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录
 	...q:$p(^PAADM(EpisodeID),"^",2)'="E"
 	...q:($p(^PAADM(EpisodeID),"^",20)'="A")&($p(^PAADM(EpisodeID),"^",20)'="D")
 	...s WARDId =""
 	...s WARDId=$o(^PAWARD(0,"WARD_LocationDR",Loc,""),-1)
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)                  //用来判断病人是否留观
 	...Q:(WARDId'=PatWarDr)||(WARDId="")
 	...q:$d(^TMP("DHCEM","web.DHCEMKeptPatient","ListObservationPatient",pid,EpisodeID))'=0
 	...s ^TMP("DHCEM","web.DHCEMKeptPatient","ListObservationPatient",pid,EpisodeID,stDate,stTime)=""    //保存数据 用来排序
	s EpisodeID=""
 	f  s EpisodeID=$o(^TMP("DHCEM","web.DHCEMKeptPatient","ListObservationPatient",pid,EpisodeID))   Q:EpisodeID=""  D
 	.s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
 	.s InHospAdmID=""
 	.s InHospWardDesc="" ;入院科室 
 	.i IPBKRowID'="" d
 	..s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
 	..q:ToAdmID=""
 	..s InHospAdmID=ToAdmID
 	..s InHospWardID=$p(^PAADM(ToAdmID),"^",70)
 	..s InHospWardDesc=$p($g(^PAWARD(+InHospWardID)),"^",2)
 	.q:(inOnlyShowTransInHospPat'="")&&(InHospAdmID="")
 	.s Department=..GetRegMark(EpisodeID)                              		//根据就诊ID获取所挂号别
 	.i Department'="" s Department=$p(Department,"^",1) 					//Department  科别						
 	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)   						    //patmasId    病人ID
 	.s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)   	//Sex          
	.s Age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)
    .s CurregNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)  		//regNo
    .s Name=##Class(web.DHCCLCom).GetNamebyEpisodeID(EpisodeID)  		    //patNam
    .
    .q:(inPatName'="")&&(Name'[inPatName)
   	.s BedNum=##class(web.DHCEMKeptPatient).getBedName(EpisodeID)         	//BedNum 
    .s MzblNum=..GetMzblNumeByAdm(EpisodeID)  								//MzblNum  门诊病例号   
   	.s MRDiagnos=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y")   //诊断
   	.s ObsDoc = ##class(web.DHCEMKeptPatient).GetObsDoc(EpisodeID)
   	.s DisDoc= ##class(web.DHCEMKeptPatient).GetDisDoc(EpisodeID)
	.s OrdAction=..GetPhoneByAdm(EpisodeID) 
	.s WhereAdnNotes=..GetWhereByAdmNew(EpisodeID)
	.s Where=$p(WhereAdnNotes,"^",1)
	.s Notes=$p(WhereAdnNotes,"^",2)
	.s scaleInfo = ..GetScaleInfo(EpisodeID)
	.s NurseLevel = $p(scaleInfo,"^",1)
	.s BatchFlag=$p(scaleInfo,"^",2)
	.s SouDr=$p(scaleInfo,"^",3)
	.s CombFlag=$p(scaleInfo,"^",4)
	.s Apache = ##class(web.DHCEMDocApache).GetAppacheScore(EpisodeID)
 	.s stDate=""
 	.f  s stDate=$o(^TMP("DHCEM","web.DHCEMKeptPatient","ListObservationPatient",pid,EpisodeID,stDate))   Q:stDate=""  D
 	..s stTime=""
 	..f  s stTime=$o(^TMP("DHCEM","web.DHCEMKeptPatient","ListObservationPatient",pid,EpisodeID,stDate,stTime))   Q:stTime=""  D
 	...s PatLocDesc=$p($g(^CTLOC(Loc)),"^",2)
 	...s LeaveTime=##class(web.DHCEMKeptPatient).getGoTime(EpisodeID)
 	...s GoDate=$p(LeaveTime,"^",1)
   	...s GoTime=$p(LeaveTime,"^",2) 
    ...s LGTime=""
    ...i GoDate'="" d
    ....s LGDate=GoDate-stDate
    ....s LGHours=(GoTime-stTime)\3600
    ....s LGMin=($j(((GoTime-stTime)#3600\60),1,0)+1)
    ....s AllHours=LGDate*24+LGHours
    ....s AllMin=LGHours*60+LGMin
    ....s TrDay=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patkeptobs.csp","天") //hxy 2022-12-13 st
    ....s TrHou=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patkeptobs.csp","小时")
    ....s TrMin=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patkeptobs.csp","分钟")
    ....s:+LGDate'=0 LGTime=(AllHours\24)_TrDay_(AllHours#24)_TrHou
    ....s:+LGDate=0 LGTime=(AllMin\60)_TrHou_(AllMin#60)_TrMin
#;    ....s:+LGDate'=0 LGTime=(AllHours\24)_"天"_(AllHours#24)_"小时"
#;    ....s:+LGDate=0 LGTime=(AllMin\60)_"小时"_(AllMin#60)_"分钟" //ed
    ...s:GoDate'="" GoDate=##class(websys.Conversions).DateLogicalToHtml(GoDate) //hxy $zd(GoDate,3)
    ...s:GoTime'="" GoTime=$zt(GoTime,2)
    ...s Num=Num+1
    ...d OutRowEme
    K ^TMP("DHCEM","web.DHCEMKeptPatient","ListObservationPatient")
    W "],""total"":"_count_"}"
	Q ""
OutRowEme
	s Department=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",Department) //hxy 2022-12-13
	s Sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",Sex)
	s InHospWardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",InHospWardDesc)
	s PatLocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLocDesc) //ed
 	Set DataStr =Num_"^"_##class(websys.Conversions).DateLogicalToHtml(stDate)_"^"_$zt(stTime,2)_"^"_Department_"^"_PatLocDesc_"^"_Sex_"^"_Age_"^"_BedNum_"^"_Name
	Set DataStr = DataStr_"^"_MRDiagnos_"^"_CurregNo_"^"_MzblNum_"^"_GoDate_"^"_GoTime_"^"_LGTime
	Set DataStr = DataStr_"^"_OrdAction_"^"_Where_"^"_NurseLevel_"^"_BatchFlag_"^"_SouDr_"^"_CombFlag
	Set DataStr = DataStr_"^"_ObsDoc_"^"_DisDoc_"^"_Apache_"^"_EpisodeID_"^"_Notes_"^"_IPBKRowID_"^"_InHospWardDesc
	S title = "Num^Date^Time^Department^PatLocDesc^Sex^Age^BedNum^Name^MRDiagnos"
	S title = title_"^CurregNo^MzblNum^GoDate^GoTime^LGTime^OrdAction^Where^NurseLevel"
	S title = title_"^BatchFlag^SouDr^CombFlag^ObsDoc^DisDoc^Apache^EpisodeID^Notes^IPBKRowID"
	S title = title_"^InHospWardDesc"
	S count=count+1
	Q:count<Start
	Q:count>End
	W $case(count,Start:"",:",")
	W ##class(web.DHCAPPJsonCommon).getJsonData(title,DataStr)
	quit
	q
}

/// creater: QQA  
/// Time: 2016-11-1
/// script:获取离院时间
ClassMethod getGoTime(EpisodeID)
{
	n (EpisodeID)
	s GoDate="",GoTime="",Dadvid="" 
    f  s Dadvid = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid))  q:Dadvid=""  d
    .s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    .q:(DadvStu="")
    .q:(^DHCPACVisitStatus(DadvStu)'["离院")
    .q:(^DHCPACVisitStatus(DadvStu)["离院")&((..GetWhereByAdm(EpisodeID)["留观")||(..GetWhereByAdm(EpisodeID)["抢救"))
    .s GoDate=$p(^DHCADMVisitStatus(Dadvid),"^",5)
    .s GoTime=$p(^DHCADMVisitStatus(Dadvid),"^",6)
    q GoDate_"^"_GoTime
}

/// 获取病人置留观的时候是哪个医生
/// w ##class(web.DHCEMKeptPatient).GetObsDoc(23)
ClassMethod GetObsDoc(EpisodeID)
{
	n (EpisodeID,%session)
	s DocUser="",Dadvid=""
    f  s Dadvid = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid))  q:(Dadvid="")||(DocUser'="")  d
    .s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    .q:(DadvStu="")
    .s StatusDesc=$p(^DHCPACVisitStatus(DadvStu),"^",2)
    .q:(StatusDesc'["留观")&&((StatusDesc'["抢救"))
	.s DocUserDr = $p(^DHCADMVisitStatus(Dadvid),"^",4)
	.q:DocUserDr=""
	.s DocUser = $p(^SSU("SSUSR",DocUserDr),"^",2)
	s DocUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",DocUser) //hxy 2022-12-13
    q DocUser
}

/// creater: QQA  
/// Time: 2016-11-1
/// script:获取诊断
/// W ##
ClassMethod getPatDiag(EpisodeID)
{
	n (EpisodeID)
	s mradmId=$p(^PAADM(EpisodeID),"^",61) 								 //诊断M
 	s MRDiagnos=""
 	s mrdiaSub=0
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  	.s MRDIAICDCodeDesc=""						
  	.s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
  	.s:MRDIAICDCodeDR'="" MRDIAICDCodeDesc=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
  	.i MRDIAICDCodeDR="" d
  	..s:$d(^MR(mradmId,"DIA",mrdiaSub,"DES"))>0 MRDIAICDCodeDesc=^MR(mradmId,"DIA",mrdiaSub,"DES",1)
  	.i MRDiagnos'="" d
  	..s MRDiagnos=MRDiagnos_","_MRDIAICDCodeDesc
  	.e  d
  	..s MRDiagnos=MRDIAICDCodeDesc
	q MRDiagnos
}

/// creater: QQA  
/// Time: 2016-11-1
/// script:获取病床Name
ClassMethod getBedName(EpisodeID)
{
	n (EpisodeID,%session)
	s BedNum=""
   	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
   	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    i bedSub'=""  d
    .s BedNum= $p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
    i (BedNum'="")&(BedNum'["床") s BedNum=BedNum_##class(web.DHCEMCommonUtil).GetTrans("dhcem.patkeptobs.csp","床") //"床" //BedNum 
    Q BedNum
}

/// creater: QQA  
/// Time: 2016-11-1
/// script:获取病人第一次临床时间
ClassMethod getClinicTime(EpisodeID)
{
	n (EpisodeID)
	q:EpisodeID="" "^"
	s stTime="",stDate=""
 	s TrancSub="0"
 	f  s TrancSub=$o(^PAADM(EpisodeID,"TRANS",TrancSub))  q:(TrancSub="")||(stTime'="")  d
  	.Q:+$p(^PAADM(EpisodeID,"TRANS",TrancSub),"^",8)=0
  	.s stDate=$p(^PAADM(EpisodeID,"TRANS",TrancSub),"^",1)
  	.s stTime=$p(^PAADM(EpisodeID,"TRANS",TrancSub),"^",2)
  	q stDate_"^"_stTime
}

ClassMethod FindEmergencydjb2(offset = 0, limit = 10, Date As %String, Loc As %String, emWardId As %String)
{
	//d ##class(%ResultSet).RunQuery("web.DHCADMVisitStat","FindEmergencyYY","2015-10-28","2015-10-28","","")
	//d ##class(%ResultSet).RunQuery("web.DHCADMVisitStat","FindEmergencydjb",63993,"")
    b ;err
    S End = offset+limit
	S Start = offset+1
    S count=0
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	i Date'="" s curDate=##class(websys.Conversions).DateHtmlToLogical(Date) //hxy 
 	;i Date["-" s curDate=$zdh(Date,3)
 	;i Date["/" s curDate=$zdh(Date,4)
 	i Date="" s curDate=+$h
	s today=+$h
 	s Num=0
	s EpisodeID = ""
 	f  s EpisodeID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID))  Q:EpisodeID=""  D
 	.s ^TMP("web.DHCEMKeptPatient","FindEmergencydjb",$i,$j,EpisodeID)=""
 	s EpisodeID = ""
 	f  s EpisodeID=$o(^TMP("web.DHCEMKeptPatient","FindEmergencydjb",$i,$j,EpisodeID))  Q:EpisodeID=""  D
 	.S avsId= $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
 	.q:avsId=""           
 	.S pvsStatus =$p(^DHCADMVisitStatus(avsId),"^",2) 
 	.s pvsId=$o(^DHCPACVisitStatus(0,"Code","STAY",""))    //stay状态
	.q:pvsStatus'=pvsId
   	.q:$d(^DHCADMVisitStatus(0,"DateStatus",curDate,pvsId,avsId))=0
    .s pvsId=$p($g(^DHCADMVisitStatus(avsId)),"^",2)    //
    .s EpisodeID=$p(^DHCADMVisitStatus(avsId),"^",1)
    .S PatLoc=..GetLocByAdm(EpisodeID)
 	.Q:(Loc'="")||(Loc'="0")&&(PatLoc'=Loc)						//就诊ID
    .q:EpisodeID=""
    .s PatLocDesc = $p($g(^CTLOC(PatLoc)),"^",1)
    .s CurregNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)  		//regNo
    .s Name=##Class(web.DHCCLCom).GetNamebyEpisodeID(EpisodeID)  			//patName
    .s admLocDesc=$p(^CTLOC($p(^DHCADMVisitStatus(avsId),"^",3)),"^",2)  	//LocDesc
    .;s locdesc=$p(^CTLOC($p($g(^DHCADMVisitStatus(avsId)),"^",12)),"^",2) 
    .s lgstDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCADMVisitStatus(avsId),"^",5)) //$zd($p(^DHCADMVisitStatus(avsId),"^",5),3)  				//liveDate
    .s lgstTime=$zt($p(^DHCADMVisitStatus(avsId),"^",6),2)  				//liveTime
    .;s wardId=$p($g(^DHCADMVisitStatus(avsId)),"^",10)
    .s wardId=$p($g(^PAADM(EpisodeID)),"^",70)  //
    .s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)   							//patmasId
    .s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)  	//sex
    .s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)     						//birth
    .s Age=##class(web.DHCEMPatientAge).GetPatAge(papmiId)  				//Age
 	.s symptom=""
 	.s mradmId=$p(^PAADM(EpisodeID),"^",61)   //诊断M
 	.s MRDiagnos=""
 	.s mrdiaSub=0
  	.f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  	..s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
  	...s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
  	...q:dtypId=""
  	...s TypCode=$p($G(^MRC("DTYP",dtypId)),"^",1)							//
  	...//q:TypCode'="OUT"
  	...s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
  	...q:MRDIAICDCodeDR=""
  	...i MRDiagnos="" d
  	....s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
  	...e  d
  	....s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
 	.s homeAddres=$p($g(^PAPER(papmiId,"PER",4)),"^",18)  // 住址
	.i homeAddres="" S homeAddres=$g(^PAPER(papmiId,"PER","ADD",1))     // 单位 paperson
    .s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
    .s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
    .s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
 	.s tel=handtel_" "_workTel_" "_homeTel
    .s Time=lgstTime   
    .//s Department=##class(web.DHCOPAdmReg).GetRegMark(EpisodeID)
    .s Department=..GetRegMark(EpisodeID)
    .i Department'="" s Department=$p(Department,"^",1) 
    .s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    .q:bedSub=""
    .s BedNum= $p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
    .i (BedNum'="")&(BedNum'["床") s BedNum=BedNum_"床"
    .s MRDiagnos=MRDiagnos
    .s MzblNum=..GetMzblNumeByAdm(EpisodeID)
    .s GoDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCADMVisitStatus(avsId),"^",5)) //$zd($p(^DHCADMVisitStatus(avsId),"^",5),3)   //离院日期
    .s GoTime=$zt($p(^DHCADMVisitStatus(avsId),"^",6),2)	//离院时间
    .s LGTime=Date                                          //留观时间  取病人安排到病床上的时间
    .s OrdAction=..GetPhoneByAdm(EpisodeID)              
    .s Where=..GetWhereByAdm(EpisodeID)
    .s scaleInfo = ..GetScaleInfo(EpisodeID)
    .s NurseLevel = $p(scaleInfo,"^",1)
    .s BatchFlag=$p(scaleInfo,"^",2)
    .s SouDr=$p(scaleInfo,"^",3)
    .s CombFlag=$p(scaleInfo,"^",4)
    .s Apache=""
    .s Num=Num+1
    .d OutRowEme99
    k ^TMP("web.DHCEMKeptPatient","FindEmergencydjb")
    W "],""total"":"_count_"}"
	Q ""
OutRowEme99
 	Set DataStr =Num_"^"_Time_"^"_Department_"^"_PatLocDesc_"^"_Sex_"^"_Age_"^"_BedNum_"^"
 	Set DataStr=DataStr_Name_"^"_MRDiagnos_"^"_CurregNo_"^"_MzblNum_"^"_GoDate_"^"_GoTime_"^"
 	Set DataStr=DataStr_LGTime_"^"_OrdAction_"^"_Where_"^"_Apache_"^"_NurseLevel_"^"_BatchFlag_"^"_SouDr_"^"_CombFlag
	Set title="Num^Time^Department^PatLocDesc^Sex^Age^BedNum^Name^MRDiagnos^CurregNo^MzblNum^GoDate^GoTime^LGTime^OrdAction^Where^Apache^NurseLevel^BatchFlag^SouDr^CombFlag"
	S count=count+1
	Q:count<Start
	Q:count>End
	W $case(count,Start:"",:",")
	W ##class(web.DHCAPPJsonCommon).getJsonData(title,DataStr)
	quit
	q
}

ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=##class(websys.Conversions).DateLogicalToHtml(IBirth) //hxy $zd(IBirth)
    s XToday=##class(websys.Conversions).DateLogicalToHtml(IToday) //hxy $zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=""
	s yearnew=$p(AgeYr,"|",12)
	i yearnew'="" d
	.s reage=yearnew_"岁"
	i reage="" d
	.s reage=AgeMth_"月"
	i reage="" d
	.s reage=AgeDay_"天"
	q reage
}

/// 根据就诊ID获取所挂号别
/// w ##class(web.DHCEMKeptPatient).GetRegMark(8196)
ClassMethod GetRegMark(Adm) As %String
{
	s MarkID=""
	s MarkDesc=""
	s TRDesc=""
	;// 2023-03-02 st
	&SQL(SELECT ID into :RegfeeRowId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:Adm)
	q:RegfeeRowId="" "^^"
	&SQL(SELECT RegfeeDocDr,RegfeeTimeRangeDr into :MarkID,:TRRowId 
	FROM SQLUser.DHCRegistrationFee Where ID=:RegfeeRowId)
	s:TRRowId'="" TRDesc=$P(^DHCTimeRange(TRRowId),"^",2) //ed
	s:MarkID'="" MarkDesc=$P($G(^CTPCP(MarkID,1)),"^",2)
	s MarkDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",MarkDesc) //hxy 2022-12-20 st
	s TRDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCTimeRange","TRDesc","",TRDesc) //ed

	Q MarkDesc_"^"_MarkID_"^"_TRDesc
}

/// 通过就诊ID，取出病人的电话号码和门诊病历号
ClassMethod GetPhoneByAdm(EpisodeID)
{
 Q:EpisodeID="" ""
 S PatID = $p(^PAADM(EpisodeID),"^",1)
 S PhoneNum  = $p($G(^PAPER(PatID,"PER",1)),"^",11)
 Q PhoneNum
}

/// 通过就诊ID，取出病人的门诊病历号
ClassMethod GetMzblNumeByAdm(EpisodeID)
{
 Q:EpisodeID="" ""
 S PatID = $p(^PAADM(EpisodeID),"^",1)
 S MzblNum  = $p($G(^PAPER(PatID,"PER",4)),"^",5)
 Q MzblNum
}

/// 通过就诊ID，取出病人所在科室
/// w ##class(web.DHCEMKeptPatient).GetWhereByAdm("247")
ClassMethod GetLocByAdm(EpisodeID)
{
 Q:EpisodeID="" ""
 S PatStatusID = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
 Q:PatStatusID="" ""
 S PatLocDr = $p(^DHCADMVisitStatus(PatStatusID),"^",3)
 ;S PatLocDesc = $p($G(^CTLOC(PatLocDr)),"^",1)
 Q PatLocDr
}

/// 通过就诊ID，取出病人就诊分级信息
/// w ##class(web.DHCEMKeptPatient).GetScaleInfo("247")
ClassMethod GetScaleInfo(EpisodeID)
{
 Q:EpisodeID="" ""
 s NurseLevel="",BatchFlag="",SouDr="",CombFlag=""
 &sql(select PCL_NurseLevel,PCL_BatchFlag,PCL_Sou_Dr,PCL_CombFlag into :NurseLevel,:BatchFlag,:SouDr,:CombFlag from DHC_EmPatCheckLev where PCL_PAPMI_Dr=249)
 Q NurseLevel_"^"_BatchFlag_"^"_SouDr_"^"_CombFlag
}

/// 通过就诊ID，取出病人去向	
/// w ##class(web.DHCEMKeptPatient).GetWhereByAdm("247")
ClassMethod GetWhereByAdm(EpisodeID)
{
 Q:EpisodeID="" ""
 S PatStatusID = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
 Q:PatStatusID="" ""
 S PatStDr = $p(^DHCADMVisitStatus(PatStatusID),"^",2)
 Q:PatStDr=""
 S PatWhere = $p(^DHCPACVisitStatus(PatStDr),"^",2)
 Q PatWhere
}

/// 通过就诊ID，取出病人去向	
/// w ##class(web.DHCEMKeptPatient).GetWhereByAdm("247")
ClassMethod GetWhereByAdmNew(EpisodeID)
{
 q:EpisodeID="" ""
 s PatStatusID = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
 q:PatStatusID="" ""
 s PatStDr = $p(^DHCADMVisitStatus(PatStatusID),"^",2)
 s Notes = $p(^DHCADMVisitStatus(PatStatusID),"^",11)
 q:PatStDr=""
 s PatWhere = $p(^DHCPACVisitStatus(PatStDr),"^",2)
 s PatWhere=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",PatWhere) 
 s TrsNotes=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDicItem","EMDesc","",Notes)
 i TrsNotes'=Notes d
 .s Notes=TrsNotes
 q PatWhere_"^"_Notes
}

/// 通过就诊ID，取出病人去向	
/// w ##class(web.DHCEMKeptPatient).GetDisDoc("247")
ClassMethod GetDisDoc(EpisodeID)
{
	s DisDoc=""
	Q:EpisodeID="" ""
	S PatStatusID = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	Q:PatStatusID="" ""
	S PatStDr = $p(^DHCADMVisitStatus(PatStatusID),"^",2)
	Q:PatStDr="" ""
	S PatWhere = $p(^DHCPACVisitStatus(PatStDr),"^",2)
	q:PatWhere'="离院" ""
	s DisDocDr = $p(^DHCADMVisitStatus(PatStatusID),"^",4)
	q:DisDocDr="" ""
	s DisDoc =$p(^SSU("SSUSR",DisDocDr),"^",2)
	s DisDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",DisDoc)
	Q DisDoc
}

/// 取出两个日期相差的小时数目
ClassMethod GetDifInTwoData(data1, data2)
{
	Q:(data1="")||(data2="") ""
	i data1'="" s data1=##class(websys.Conversions).DateHtmlToLogical(data1) //hxy
	i data2'="" s data2=##class(websys.Conversions).DateHtmlToLogical(data2) //hxy
	;i data1["-" s data1=$zdh(data1,3)
 	;i data1["/" s data1=$zdh(data1,4)
 	;i data2["-" s data2=$zdh(data2,3)
 	;i data2["/" s data1=$zdh(data2,4)
 	Q data1-data2#3600_"小时"
}

/// w ##class(web.DHCEMKeptPatient).GetObsLoc(286)
ClassMethod GetObsLoc1(CurLoc)
{
	n (CurLoc)
	s:CurLoc="" CurLoc=%session.Data("LOGON.CTLOCID")
	s loc = CurLoc
	w "["
	s locdesc=$p(^CTLOC(loc),"^",2)
	i $f(locdesc,"-") s locdesc=$p(locdesc,"-",2)
	W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",loc_"^"_locdesc)
	
	s link=0
	f  s link=$o(^CTLOC(loc,"LINK",link)) q:link=""  d
	.s linkloc=$p($g(^CTLOC(loc,"LINK",link)),"^",1)
    s tmploc=0
	f  s tmploc=$o(^CTLOC(linkloc,"LINK",tmploc)) q:(tmploc="")||(tmploc=0)  d						
	.s tmplinkloc=$p(^CTLOC(linkloc,"LINK",tmploc),"^",1)
	.q:tmplinkloc=loc	
	.s tmplinklocdesc=$p(^CTLOC(tmplinkloc),"^",2)
	.i $f(tmplinklocdesc,"-") s tmplinklocdesc=$p(tmplinklocdesc,"-",2)  //liangqiang
	.w ","
	.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmplinkloc_"^"_tmplinklocdesc)
	w "]"
	q ""
}

/// w ##class(web.DHCEMKeptPatient).GetObsLoc(286)
ClassMethod GetObsLoc(CurLoc)
{
	n (CurLoc,%session)
	s:CurLoc="" CurLoc=%session.Data("LOGON.CTLOCID")
	s TMPData("LocID",CurLoc)=""
	
	s LinkSub=""
	f  s LinkSub = $o(^CTLOC(CurLoc,"LINK",LinkSub)) q:LinkSub=""  d
	.s LinkLocID = $p($g(^CTLOC(CurLoc,"LINK",LinkSub)),"^",1)
	.s TMPData("LocID",LinkLocID)=""
	
	w "["
	s Count=0
	s LocID=""
	f  s LocID = $o(TMPData("LocID",LocID)) q:LocID=""  d
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.q:$p(^CTLOC(LocID),"^",13)'="EM"
	.s LocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc) //hxy 2022-12-13
	.s ItmData = LocID_"^"_LocDesc
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ItmData)
	w "]"
	
	q ""
}

Storage Default
{
<Data name="DHCEMKeptPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMKeptPatientD</DataLocation>
<DefaultData>DHCEMKeptPatientDefaultData</DefaultData>
<IdLocation>^web.DHCEMKeptPatientD</IdLocation>
<IndexLocation>^web.DHCEMKeptPatientI</IndexLocation>
<StreamLocation>^web.DHCEMKeptPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
