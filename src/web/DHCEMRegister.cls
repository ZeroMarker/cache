Class web.DHCEMRegister Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, Not ProcedureBlock ]
{

/// Description: 新版急诊 预检分级表
/// Creator:     QQA
/// CreateDate:  2016-10-12
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 开始、结束日期，登记号
/// Return： 	 
/// Others:		w ##class(web.DHCEMRegister).ListRegisterNewBySetting(1,60,"06/02/2018^06/02/2018^^^^^^^^^^^2^")
ClassMethod ListRegisterNewBySetting(page, rows, Params) As %Status
{
	n (page,rows,Params,%session)
	s Start=page-1*rows+1
	s End=page*rows
	s fromDate = $p(Params,"^",1)
	s toDate = $p(Params,"^",2)
	s regNo = $p(Params,"^",3)
	s MarkNo = $p(Params,"^",4)
	s PCLAdmWayNo = $p(Params,"^",5)
	s StaTime = $p(Params,"^",6)
	s EndTime = $p(Params,"^",7)
	s Note = $p(Params,"^",8)
	s Symp = $p(Params,"^",9)         //主诉
	s NurLevel = $p(Params,"^",10)
	s PatHistory = $p(Params,"^",11)  //既往史
	s:PatHistory'="" PatHistory=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatHistory","PHDesc","",$p($g(^DHCEMPHI(PatHistory)),"^",2))
	s Screen = $p(Params,"^",12)
	s hospId=$p(Params,"^",13)       //QQA  2016-10-20
	s errCheckLevNum=0
	s RegisterFlag = $p(Params,"^",14)
	s CareLocID = $p(Params,"^",15)
	s InEmPatType = $p(Params,"^",16)
	s LgUserID=$p(Params,"^",17) //hxy 2021-07-15
	i +MarkNo="0" s MarkNo=""
	I +NurLevel="0" s NurLevel=""
	i ++PCLAdmWayNo="0" s PCLAdmWayNo=""   //来诊方式
    S ID="",curmarkno=""
    S count=0
    k ^TMP("DHCEM","web.DHCEMRegister","ListRegisterNew",+LgUserID) //2016-09-27 congyue
    s repid=$i(^CacheTemp)
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	i fromDate'="" s fromDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i fromDate="" s fromDate=+$h
 	i toDate'="" s toDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
	i toDate=""  s toDate=+$h
	s today=+$h
	s:StaTime'="" StaTime=$zth(StaTime,2) ;2016-09-23  开始时间
	s:EndTime'="" EndTime=$zth(EndTime,2) ;2016-09-23  结束时间
 	s num=0                   																//这里是通过分诊表来查找
 	f date=fromDate:1:toDate  d 
 	.s PCLRowID="0" f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",date,PCLRowID)) q:PCLRowID=""  d
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1)									//来诊病人dr  Pa_PatMas,这里病人信息能走通了
 	..s PCLLocDr= $p(^DHCEMPCL(PCLRowID),"^",10)
 	..S PCARowID="",EpisodeID=""
 	..S:$d(^DHCEMPCA(0,"PatCheckLev",PCLRowID))'=0 PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,""),-1)
 	..s:PCARowID'="" EpisodeID=$p(^DHCEMPCA(PCARowID),"^",2)
 	..s EpiLocID=$p($g(^PAADM(+EpisodeID)),"^",4)
 	..Q:(CareLocID'="")&&('..CareLocIDInPCL(CareLocID,PCLRowID))&&((EpiLocID'="")&&(EpiLocID'=CareLocID))
 	..s EmPatTypeID=+$p(^DHCEMPCL(PCLRowID),"^",40)
 	..q:(InEmPatType'="")&&(InEmPatType'=EmPatTypeID)
 	..s PCLHisDr =$p(^DHCEMPCL(PCLRowID),"^",14) 								//分诊医院
 	..q:PCLHisDr'=hospId							
 	..s PCLToLocDr= $p(^DHCEMPCL(PCLRowID),"^",41)
 	..q:(NurLevel'="")&($p(^DHCEMPCL(PCLRowID),"^",7)'=NurLevel)  							/// 护士分级 ;NurLevel
 	..s curmarknostr=##class(web.DHCEMRegister).GetPatCare(PCLRowID)    			//号别(科室)串串    
 	..s:curmarknostr="" curmarknostr=..GetAdmCare(EpisodeID) 
    ..i MarkNo'=""  s curmarkno=","_##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",$p(^CTPCP(MarkNo,"1"),"^",2))_","				    			//号别
    ..Q:(MarkNo'="")&(","_curmarknostr_","'[curmarkno)    											//过滤号别
 	..s SickHistory=""
    ..s SickHistory= ##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHisDesc(PCLRowID)   
    ..q:(PatHistory'="")&(SickHistory'[PatHistory)											//既往史过滤							
 	..q:(Screen="Y")&($p(^DHCEMPCL(PCLRowID),"^",18)'="Y")                              //过滤
 	..q:(Screen="N")&($p(^DHCEMPCL(PCLRowID),"^",18)="Y")                              //过滤
	..d outputRow
	s errCheckLevRate = ""
	s:count=0 errCheckLevRate=0
	s:count'=0 errCheckLevRate = $DECIMAL(+$g(errCheckLevNum)/count*100,2)
	s errCheckLevRate=errCheckLevRate_"%"
	;W "],""total"":"_count_",""errCheckLevRate"":"""_errCheckLevRate_"""}"
	W "],""total"":"_count_"}"
	Q ""

outputRow
	s dataStr=""
    s dataStr =##class(web.DHCEMRegister).getPatMessage(PAPMIDr,hospId)     
    q:dataStr=""
    s curregno=$p(dataStr,"^",1)        ///病人登记号
    q:(regNo'="")&(regNo'=curregno)		
   	s name = $p(dataStr,"^",2)			/// 病人姓名
    s sexId = $p(dataStr,"^",3)			/// 病人性别
    s age = $p(dataStr,"^",4)			/// 病人年龄
	s tel = $p(dataStr,"^",5)			/// 病人电话
	s Address = $p(dataStr,"^",6)		/// 病人地址
	s PatCardNo = $p(dataStr,"^",7)		/// 病人卡号 
	s VeerLocDr = $p(^DHCEMPCL(PCLRowID),"^",41)                                //QQA 2016-11-02 转向科室Dr
	s VeerLocDesc=$p(^CTLOC(+VeerLocDr),"^",2)
	s VeerLocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",VeerLocDesc) //hxy 2022-10-21
	q:(EpisodeID="")&(RegisterFlag=1)
	q:(EpisodeID'="")&(RegisterFlag=2)
	s MRDiagnos="",SeeDocDateInfo=""
	i EpisodeID'="" d
	.s MRDiagnos = ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)       //诊断(入参：就诊号)   QQA 2016-10-21
	.s SeeDocDateInfo=##class(web.DHCEMRegister).GetPatFirstStatDate(EpisodeID)
	s SeeDocDate=$p(SeeDocDateInfo,"^",1)
	s SeeDocTime=$p(SeeDocDateInfo,"^",2)
	s:SeeDocDate'="" SeeDocDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(SeeDocDate)
	s:SeeDocTime'="" SeeDocTime=$zt(SeeDocTime,2)
	s (PCLNurseLevel,admDate,admTime,symptom,PCSTime,PCSHeart,PCSPCSPulse,PCSSBP,PatDiag,PCLPatAskFlag,PCLAdmWayDr,PCLAdmWay,Screening)=""
	s pclData = ##class(web.DHCEMRegister).getPatFZMessageByPclID(PCLRowID)   //去分诊表中找病人的分诊记录 
	s PCLNurseLevel=$p(pclData,"^",1)   //护士分级
	s admDate = $p(pclData,"^",2)		//分诊日期
	s admTime = $p(pclData,"^",3)		//分诊时间
	q:(##class(web.DHCEMCommonUtil).DateHtmlToLogical(admDate)=fromDate)&(admTime'="")&(StaTime'="")&(StaTime>$zth(admTime,2)) ;2016-09-23  开始日早于就诊时间Q
    q:(##class(web.DHCEMCommonUtil).DateHtmlToLogical(admDate)=toDate)&(admTime'="")&(EndTime'="")&(EndTime<$zth(admTime,2)) ;2016-09-23  结束日晚于就诊时间Q	
	s symptom = $p(pclData,"^",4)		//症状
	s HasSympFlag = ##class(web.DHCEMRegister).HasSymp(Symp,PCLRowID)
	q:(Symp'="")&(+HasSympFlag'=1)
	s PCLPatAskFlag=$p(pclData,"^",6)
	s PCLAdmWay=$p(pclData,"^",7)       //来诊方式
	s PCLAdmWayDr=$p(pclData,"^",8)     //来诊方式Dr
	s EmAware=$p(pclData,"^",9)          //神智
	s curmarkno = curmarknostr 			 //号别(有多个的情况)
	s SignInfo = ##class(web.DHCEMPatCheckLevQuery).GetEmPatChkSignItm(PCLRowID)
	s PCSTemp = $p(SignInfo,"@",2)       //体温
	s PCSHeart = $p(SignInfo,"@",3)		 //心率HR
	s PCSPCSPulse = $p(SignInfo,"@",4)	 //脉搏R
	s PCSBP =$p(SignInfo,"@",5)_"/"_$p(SignInfo,"@",6)       //血压(BP)收缩压
	s EmPcsSoP2=$p(SignInfo,"@",7)   /// 血氧饱合度
	s PCSR = $p(SignInfo,"@",8)         //呼吸频率
	s EmPcsGLU = $p(SignInfo,"@",9)
	s EmRecLevel=$p(pclData,"^",15)      //推荐分级
	s NurseLevel=$p(pclData,"^",16)      //护士分级
	s Screening = $p(^DHCEMPCL(PCLRowID),"^",18)   //筛查
	s SickHistory= ##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHisDesc(PCLRowID)
	s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-20
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"") //hxy 2020-02-20
	
	s PatDiag=""
	q:(PCLAdmWayNo'="")&(PCLAdmWayDr'=PCLAdmWayNo)
	s WaitTime = ##class(web.DHCEMRegister).GetWaitTime(PCLRowID,EpisodeID)
	s PCLCareLoc = ##class(web.DHCEMRegister).GetPCLCareLoc(PCLRowID)
	s:PCLCareLoc="" PCLCareLoc=..GetAdmLoc(EpisodeID)
	s:EmRecLevel'=NurseLevel errCheckLevNum=errCheckLevNum+1
	s IsGreenAdm=""
	s:EpisodeID'="" IsGreenAdm = ##class(web.DHCEMPatGreenRec).checkGreenRec(EpisodeID)   //绿色通道
	s IsGreenAdm = $case(IsGreenAdm,1:"Y",:"N")
	s PCLNurUser = $p(^DHCEMPCL(PCLRowID),"^",3)   //分诊护士
	s:PCLNurUser'="" PCLNurUser=$p(^SSU("SSUSR",PCLNurUser),"^",2)
	s PCLNurUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",PCLNurUser)
	s sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",sex)
	s num=num+1
	s TempTitle = "num^patientID^admDate^admTime^WaitTime^currregno^name^sex^age^curmarkno^symptom"   ;1-11
	s TempTitle=TempTitle_"^MRDiagnos^PCSTemp^PCSHeart^PCSPCSPulse^PCSBP^tel^PCLNurseLevel^ID^EpisodeID" ;12-20
	s TempTitle=TempTitle_"^PCLPatAskFlag^PCLAdmWay^EmAware^PCLRowID^VeerLocDesc^EmRecLevel^NurseLevel" ;21-27
	s TempTitle=TempTitle_"^SickHistory^Screening^PCSR^EmPcsGLU^EmPcsSoP2^PCLCareLoc^IsGreenAdm^PCLNurUser" ;28-35
	s TempTitle=TempTitle_"^SeeDocDate^SeeDocTime"
	s TempStr=num_"^"_PAPMIDr_"^"_admDate_"^"_admTime_"^"_WaitTime_"^"_curregno_"^"_name_"^"_sex_"^"_age_"^"_curmarkno
	s TempStr = TempStr_"^"_symptom_"^"_MRDiagnos_"^"_PCSTemp_"^"_PCSHeart_"^"_PCSPCSPulse
	s TempStr = TempStr_"^"_PCSBP_"^"_tel_"^"_PCLNurseLevel_"^"_ID_"^"_EpisodeID_"^"_PCLPatAskFlag
	s TempStr = TempStr_"^"_PCLAdmWay_"^"_EmAware_"^"_PCLRowID_"^"_VeerLocDesc_"^"_EmRecLevel_"^"_NurseLevel_"^"_SickHistory
	s TempStr = TempStr_"^"_Screening_"^"_PCSR_"^"_EmPcsGLU_"^"_EmPcsSoP2_"^"_PCLCareLoc_"^"_IsGreenAdm_"^"_PCLNurUser
	s TempStr = TempStr_"^"_SeeDocDate_"^"_SeeDocTime

	s ^TMP("DHCEM","web.DHCEMRegister","ListRegisterNew",+LgUserID,num)=TempStr ;2016-09-03 congyue 
	S count=count+1
	Q:count<Start
	Q:count>End
	W $case(count,Start:"",:",") 
	W ##class(web.DHCEMJsonCommon).getJsonData(TempTitle,TempStr)
}

/// w ##class(web.DHCEMRegister).CareLocIDInPCL(266,1)
ClassMethod CareLocIDInPCL(CareLocID, PCLRowID)
{
	n (CareLocID,PCLRowID)
	s Ret=0
	s PCCRowID=""
	f  s PCCRowID = $o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,PCCRowID)) q:(PCCRowID="")||(Ret=1)  d
	.s LocID = $P(^DHCEMPCC(PCCRowID),"^",3)
	.s:CareLocID=LocID Ret=1
	q Ret
}

/// w ##class(web.DHCEMRegister).GetPCLCareLoc(1)
ClassMethod GetPCLCareLoc(PCLRowID)
{
	n (PCLRowID,%session)
	s Ret=""
	s PCCRowID=""
	f  s PCCRowID = $o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,PCCRowID)) q:(PCCRowID="")||(Ret=1)  d
	.s LocID = $P(^DHCEMPCC(PCCRowID),"^",3)
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s LocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	.s:Ret'="" Ret=Ret_","_LocDesc
	.s:Ret="" Ret=LocDesc
	q Ret
}

/// Input:PCLRowID(可为空)
/// w ##class(web.DHCEMRegister).GetWaitTime(16,135)
ClassMethod GetWaitTime(PCLRowID, EpisodeID)
{
	n (PCLRowID,EpisodeID,%session)
	q:+EpisodeID=0 ##class(web.DHCEMCommonUtil).GetTrans("dhcem.register.csp","未挂号") //"未挂号" hxy 2022-12-07
	s:PCLRowID="" PCLRowID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1)
	q:+PCLRowID=0 ""
	s WaitTime=""
	s EmPatChkDateNum=$P($g(^DHCEMPCL(PCLRowID)),"^",4)  //分诊日期 add lp 180825
	s EmPatChkTimeNum=$P($g(^DHCEMPCL(PCLRowID)),"^",5)  //分诊时间
	s EmPatChkAllTime=EmPatChkDateNum*24*60*60+EmPatChkTimeNum
	s HostDate=$p($h,",",1)
	s HostTime=$p($h,",",2)	
	s HostAllTime=HostDate*24*60*60+HostTime
	s WaitTime=HostAllTime-EmPatChkAllTime
	s WaitTime=WaitTime/60
	s WaitTime=+$p(WaitTime,".",1)_##class(web.DHCEMCommonUtil).GetTrans("dhcem.register.csp","分钟") //"分钟" hxy 2022-12-07
	;s WaitTimeNum=$p(WaitTime,"分",1)
	s MedcialStatus = ##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	s VisitStatus=$p(^PAADM(EpisodeID),"^",20)
	i (MedcialStatus'="")&&(VisitStatus="A") d
	.s WaitTime=##class(web.DHCEMCommonUtil).GetTrans("dhcem.register.csp","已就诊") //"已就诊" hxy 2022-12-07
	i (VisitStatus="C") d
	.s WaitTime=##class(web.DHCEMCommonUtil).GetTrans("dhcem.register.csp","已退号") //"已退号" hxy 2022-12-07
	i (VisitStatus="D") d
	.s WaitTime=##class(web.DHCEMCommonUtil).GetTrans("dhcem.register.csp","已离院") //"已离院" hxy 2022-12-07
	
	q WaitTime
}

/// Creator: QQA  
/// Time:2016-10-12
/// 通过病人Id查找病人信息
/// 入参:就诊ID
/// 返回值：登记号^姓名^性别^年龄^电话^家庭住址^卡号
/// w ##class(web.DHCEMRegister).getPatMessage()
ClassMethod getPatMessage(PAPMIDr, HospID)
{
	Q:PAPMIDr="" ""
	s curregno="",name="",sex="",age="",tel="",Address="",PatCardNo=""
	Q:$d(^PAPER(PAPMIDr))=0 ""
	s curregno=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)	   /// 病人登记号	
	s name=$p(^PAPER(PAPMIDr,"ALL"),"^",1)    /// 病人姓名
	s sexId=$p(^PAPER(PAPMIDr,"ALL"),"^",7)      /// 性别
	i sexId'="" s sex=$p(^CT("SEX",sexId),"^",2)
	s age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDr,"",HospID)  /// 年龄:根据病人ID
	s tel=$p(^PAPER(PAPMIDr,"PER",1),"^",11) 	    /// 电话 
	s Address=$g(^PAPER(PAPMIDr,"PER","ADD",1)) 	    /// 家庭住址
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDr,""),-1)
	s:CardNoID'="" PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 			 /// 卡号
	Q curregno_"^"_name_"^"_sex_"^"_age_"^"_tel_"^"_Address_"^"_PatCardNo
}

/// 当病人有分诊信息的时候获取分诊的数据(配置)
/// creater:QQA
/// Time : 2016-10-12
/// 返回值：护士分级^分诊日期^分诊时间^症状^号别^诊断^预检生命体时间^心率HR^脉搏R^血压(BP)收缩压^来诊方式^来诊方式Dr
/// w ##class(web.DHCEMRegister).getPatFZMessageByPclID("40")
ClassMethod getPatFZMessageByPclID(PCLRowID)
{
	n (PCLRowID,%session)
	Q:PCLRowID="" ""
	s FzData=""
	s PCLNurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  //护士分级
    s admDate=$p(^DHCEMPCL(PCLRowID),"^",4)        //分诊日期
    s admDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(admDate) //$zd(admDate,3)
    s admTime=$p(^DHCEMPCL(PCLRowID),"^",5)        //分诊时间
    s admTime=$zt(admTime,1)
	s PCLAdmDr=$p(^DHCEMPCL(PCLRowID),"^",37)
	s symptom=""
	s symptom=$p(^DHCEMPCL(PCLRowID),"^",25)        //症状
	
    s symptom=##Class(web.DHCEMECheck).GetSymDesc(PCLRowID)
    s symptom=$tr(symptom,"!","")
    s symptom=$tr(symptom,"#",",")
    s PCLOther=$p(^DHCEMPCL(PCLRowID),"^",36)       //其他 2016-09-13 congyue
    s:symptom'="" symptom=symptom_";"
    s symptom=symptom_""_PCLOther 					//其他 2016-09-13 congyue
    s FzData=FzData_PCLNurseLevel_"^"_admDate_"^"_admTime_"^"_symptom_"^"_""
	s PCSRowID="",PCSTime="",PCSHeart="",PCSPCSPulse="",PCSSBP=""
	s PCSRowID=$o(^DHCEMPCS(0,"PatCheckLev",PCLRowID,PCSRowID),-1)
	s PCLAdmWay="",PCLAdmWayDr="",PCLPatAskFlag=""
	s PCLAdmWayDr=$p(^DHCEMPCL(PCLRowID),"^",16) 
 	i PCLAdmWayDr'="" d
 	.s PCLAdmWay=$p(^DHCEMPADW(PCLAdmWayDr),"^",2)  //来诊方式
 	s PCLPatAskFlag=$p(^DHCEMPCL(PCLRowID),"^",35)  //是否假条
 	s EmAware=$p(^DHCEMPCL(PCLRowID),"^",17) 	    /// 意识状态 2016-09-21 congyue
	i EmAware'="" s EmAware=$p($g(^DHCEMPAW(EmAware)),"^",2)
	s PCLAdmWay=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatAdmWay","PAWDesc","",PCLAdmWay) //hxy 2022-10-21
	s EmAware=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatAware","PADesc","",EmAware) //hxy 2022-10-21
 	s FzData=FzData_"^"_PCLPatAskFlag_"^"_PCLAdmWay_"^"_PCLAdmWayDr_"^"_EmAware_"^"_PCLRowID
 	s (PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR)=""    	
	i (PCSRowID'="")  d
 	.s PCSTime=$p(^DHCEMPCS(PCSRowID),"^",2)
 	.s PCSTime=$zt(PCSTime,1)
 	.s PCSTemp=$p(^DHCEMPCS(PCSRowID),"^",3)        //体温T 2016-09-03 congyue
 	.s PCSHeart=$p(^DHCEMPCS(PCSRowID),"^",4)
 	.s PCSPCSPulse=$p(^DHCEMPCS(PCSRowID),"^",5)
 	.s PCSDBP=$p(^DHCEMPCS(PCSRowID),"^",7)         // 2016-09-03 congyue
 	.s PCSSBP=$p(^DHCEMPCS(PCSRowID),"^",6)
 	.s PCSBP=PCSSBP_"/"_PCSDBP //BP 2016-09-03 congyue
 	.s PCSR = $p(^DHCEMPCS(PCSRowID),"^",9)
    s FzData=FzData_"^"_PCSTemp_"^"_PCSHeart_"^"_PCSPCSPulse_"^"_PCSBP_":"_PCSR
    
    s EmRecLevel=$p(^DHCEMPCL(PCLRowID),"^",6)  /// 推荐分级
	s NurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  /// 护士分级
    s FzData=FzData_"^"_EmRecLevel_"^"_NurseLevel
    q FzData
}

/// 当病人有分诊信息的时候获取分诊的数据(配置)(这个方法对时间不走配置,用于报表的使用)
/// creater:QQA
/// Time : 2017-08-04
/// 返回值：护士分级^分诊日期^分诊时间^症状^号别^诊断^预检生命体时间^心率HR^脉搏R^血压(BP)收缩压^来诊方式^来诊方式Dr
/// w ##class(web.DHCEMRegister).getPatMessageByPclID("1719")
ClassMethod getPatMessageByPclID(PCLRowID)
{
	Q:PCLRowID="" ""
	s FzData=""
	s PCLNurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  //护士分级
    s admDate=$p(^DHCEMPCL(PCLRowID),"^",4)        //分诊日期
    s admDate=$zd(admDate,3) ;##class(web.DHCEMCommonUtil).DateLogicalToHtml(admDate) //$zd(admDate,3)
    s admTime=$p(^DHCEMPCL(PCLRowID),"^",5)        //分诊时间
    s admTime=$zt(admTime,1)
	s PCLAdmDr=$p(^DHCEMPCL(PCLRowID),"^",37)
	;s MRDiagnos=""
	;i PCLAdmDr'="" d
	.;s MRDiagnos=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(PCLAdmDr,",") //诊断(入参：就诊号) 
	s symptom=""
	s symptom=##Class(web.DHCEMECheck).GetSymDesc(PCLRowID) ;$p(^DHCEMPCL(PCLRowID),"^",25)        //症状   
    ;s symptom=##class(web.DHCEMRegister).TrNumto(symptom,"")
    ;s symptom=$tr(symptom,"!","")
    ;s symptom=$tr(symptom,"#",",")
    s PCLOther=$p(^DHCEMPCL(PCLRowID),"^",36)       //其他 2016-09-13 congyue
    s symptom=symptom_" "_PCLOther 					//其他 2016-09-13 congyue
    s FzData=FzData_PCLNurseLevel_"^"_admDate_"^"_admTime_"^"_symptom_"^"_""
	s PCSRowID="",PCSTime="",PCSHeart="",PCSPCSPulse="",PCSSBP=""
	s PCSRowID=$o(^DHCEMPCS(0,"PatCheckLev",PCLRowID,""),-1)
	s PCLAdmWay="",PCLAdmWayDr="",PCLPatAskFlag=""
	s PCLAdmWayDr=$p(^DHCEMPCL(PCLRowID),"^",16) 
 	i PCLAdmWayDr'="" d
 	.s PCLAdmWay=$p(^DHCEMPADW(PCLAdmWayDr),"^",2)  //来诊方式
 	s PCLPatAskFlag=$p(^DHCEMPCL(PCLRowID),"^",35)  //是否假条
 	s EmAware=$p(^DHCEMPCL(PCLRowID),"^",17) 	    /// 意识状态 2016-09-21 congyue
 	s:EmAware=0 EmAware="" //lvpeng 2017-11-27
	s:((EmAware'="")&(EmAware'=0)) EmAware=$p(^DHCEMPAW(EmAware),"^",2)
 	s FzData=FzData_"^"_PCLPatAskFlag_"^"_PCLAdmWay_"^"_PCLAdmWayDr_"^"_EmAware_"^"_PCLRowID
 	s (PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR)=""    	
	i (PCSRowID'="")  d
 	.s PCSTime=$p(^DHCEMPCS(PCSRowID),"^",2)
 	.s PCSTime=$zt(PCSTime,1)
 	.s PCSTemp=$p(^DHCEMPCS(PCSRowID),"^",3)        //体温T 2016-09-03 congyue
 	.s PCSHeart=$p(^DHCEMPCS(PCSRowID),"^",4)
 	.s PCSPCSPulse=$p(^DHCEMPCS(PCSRowID),"^",5)
 	.s PCSDBP=$p(^DHCEMPCS(PCSRowID),"^",7)         // 2016-09-03 congyue
 	.s PCSSBP=$p(^DHCEMPCS(PCSRowID),"^",6)
 	.s PCSBP=PCSSBP_"/"_PCSDBP //BP 2016-09-03 congyue
 	.s PCSR = $p(^DHCEMPCS(PCSRowID),"^",9)
    s FzData=FzData_"^"_PCSTemp_"^"_PCSHeart_"^"_PCSPCSPulse_"^"_PCSBP_":"_PCSR
    
    s EmRecLevel=$p(^DHCEMPCL(PCLRowID),"^",6)  /// 推荐分级
	s NurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  /// 护士分级
    s FzData=FzData_"^"_EmRecLevel_"^"_NurseLevel
    q FzData
}

/// w ##class(web.DHCEMRegister).TrNumto("ab2c","")
/// Description: 预检号别表 所有号别描述
/// Creator:     huaxiaoying
/// CreateDate:  2016-08-19
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 rowid
/// Return： 	 
/// w ##class(web.DHCEMRegister).TrNumto("ab2c","")
ClassMethod TrNumtoQ(str As %String, str2 As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set return=""
	set length=$l(str)
	for index=1:1:length
	{
		set strIndex=$e(str,index)
		//if +strIndex=0
		if (+strIndex=0)&&(strIndex'=0)

		{
			set return=return_strIndex
		}else
		{
			set return=return_str2
		}
	}
	quit return
}

/// w ##class(web.DHCEMRegister).TrNumtoQ("20!呼吸困难:呼吸停止或暂停#21!呼吸困难:全身性紫绀#22!呼吸困难:抽搐","")
/// Description: 预检号别表 所有号别描述
/// Creator:     QQA
/// CreateDate:  2016-11-03
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 rowid
/// Return： 	 
/// w ##class(web.DHCEMRegister).TrNumto("ab2c","")
ClassMethod TrNumto(str As %String, str2 As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set return=""
	set length=$l(str,"#")
	for index=1:1:length
	{
		s lstr =$p(str,"#",index)
		s return=return_$p(lstr,"!",2)_","
	}
	s return=$e(return,1,$l(return)-1)
	quit return
}

/// Description: 预检号别表 所有号别描述
/// Creator:     huaxiaoying
/// CreateDate:  2016-08-19
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 rowid
/// Return： 	 
/// W ##Class(web.DHCEMRegister).GetEmPatChkCare("8")
ClassMethod GetEmPatChkCare(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPccID=""
	f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	.s EmCareProvID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	.s EmCareProv=$p($g(^CTPCP(EmCareProvID,1)),"^",2)
	.i ListData="" s ListData=EmCareProv
	.E  s ListData=ListData_","_EmCareProv
	q ListData
}

/// ##Class(web.DHCEMRegister).GetPatCare()
ClassMethod GetPatCare1(EmPCLvID, hosp)
{
	n (EmPCLvID,hosp)
	s PatAdm ="",CareDesc = ""
	s EmPCLvAdm = $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""),-1)	
	i EmPCLvAdm'="" d
	.s PatAdm = $p(^DHCEMPCA(EmPCLvAdm),"^",2)
	s:PatAdm'="" CareDesc = ##class(web.DHCEMRegister).GetCareByEmPCLvID(EmPCLvID)
	s:PatAdm="" CareDesc = ##class(web.DHCEMRegister).GetEmPatChkCareAndHosp(EmPCLvID,hosp)
	q CareDesc
}

/// Description: 预检号别表 通过分诊ID取预检分级号别表
/// Creator:     qiaoqingao
/// CreateDate:  2017-04-01
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 rowid
/// Return： 	 
/// W ##Class(web.DHCEMRegister).GetPatCare("8",2)
ClassMethod GetPatCare(EmPCLvID) As %String
{
	n (EmPCLvID,hosp,%session)
	s ListData="",EmPccID=""
	f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	.s EmCareProvID=""
	.s EmCareProvID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	.q:EmCareProvID=""
	.s EmCareProv=$p($g(^CTPCP(EmCareProvID,1)),"^",2)
	.s EmCareProv=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",EmCareProv) //hxy 2022-12-07
	.i ListData'="" s ListData=ListData_","_EmCareProv
	.E  s ListData=EmCareProv
	q ListData
}

/// Description: 预检号别表 所有号别描述,过滤掉医院
/// Creator:     qiaoqingao
/// CreateDate:  2016-10-20
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 rowid
/// Return： 	 
/// W ##Class(web.DHCEMRegister).GetEmPatChkCareAndHosp("8",2)
ClassMethod GetEmPatChkCareAndHosp(EmPCLvID, hosp) As %String
{
	n (EmPCLvID,hosp)
	s ListData="",EmPccID=""
	f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	.s hospFlag="",EmCareProvID=""
	.s EmCareProvID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	.q:EmCareProvID=""
	.s EmCareProv=$p($g(^CTPCP(EmCareProvID,1)),"^",2)
	.s locDr=""
	.f  s locDr=$o(^RB("RES",0,"CTPCP",EmCareProvID,locDr))  q:locDr=""  d
	..s:locDr'="" hospDr = $p(^CTLOC(locDr),"^",22)
	..i hospDr=hosp  s hospFlag=1
	.q:(hospFlag="")&(EmCareProvID'="")
	.i ListData="" s ListData=EmCareProv
	.E  s ListData=ListData_","_EmCareProv
	q ListData
}

///  Descript:	获取病人预检号别信息
///  W ##Class(web.DHCEMPatCheckLevQuery).getPatChkCare("0000000001")
///  input:登记号
///  output:CTCareProv id
ClassMethod getPatChkCare(RegNo)
{
	 n (RegNo)
	 s ret=""
	 q:RegNo="" ret
	 s PatientID=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
	 q:+PatientID=0 ret
	 
	 s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)
	 q:+EmRegID=0 ret
	 s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1)  /// 分诊ID
	 q:+EmPCLvID=0 ret
	 s EmPccID="",i=1
	 f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	 .s $p(ret,"^",i)=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	 .s i=i+1
	 q ret
}

/// Descritp:	号别
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonGetEmPatChkCare("")
ClassMethod jsonGetEmPatChkCare(LocID As %String, HospID As %String) As %String
{
	n (LocID, HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR FROM SQLUser.RB_RESOURCE WHERE RES_CTLOC_DR='"_LocID_"' And (res_schedulerequired='Yes' or res_schedulerequired='Y')"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("RES_CTPCP_DR")
		s Desc = result.Data("CTPCP_Desc")
		Continue:$d(^SSU("SSUSR",0,"CTPCP",ID))
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Description: 急诊科室(号别) 友谊源码
/// Creator:     huaxiaoying
/// CreateDate:  2016-08-18
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 开始、结束日期，登记号
/// Return： 	 
/// Others:		 w ##class(web.DHCEMRegister).getMarkNo()	
ClassMethod getMarkNo()
{
    s repid=$i(^CacheTemp)
 	s ind=1
 	//195	JZKMZO-急诊

    s allmark=""
    s allstr=##class(web.DHCEMRegister).FindAllResDocNew("195")
    s num=$l(allstr,"^")
    f i=1:1:num d
    .s tempmark=$p(allstr,"^",i)
    .s code=$p(tempmark,$c(1),1)
    .s desc=$p(tempmark,$c(1),2)
    .i desc["-" s desc=$p(desc,"-",1)
    .q:desc["不用"
    
    .;i allmark="" s allmark="^"_tempmarkId
    .;e  s allmark=allmark_"^"_tempmarkId
    .d OutRowmarkno

    s qHandle=$lb(0,repid,0)
	q $$$OK
OutRowmarkno
	s Data=$lb(desc,code)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

/// Description: 友谊医院原查询方法
/// Creator:     huaxiaoying
/// CreateDate:  2016-08-15
/// Table: 		 
/// Input:  	 开始、结束日期，登记号
/// Return： 	 
/// Others:		 w ##class(web.DHCEMRegister).ListRegister(0,100,"2000-01-01","2016-08-08","","")	
ClassMethod ListRegister(offset = 0, limit = 10, fromDate As %String, toDate As %String, regNo As %String, MarkNo As %String) As %Status
{
   
    s regNo="0000000001"
    ;allMarkNo 号别
    S End = offset+limit
	S Start = offset+1
    S count=0
	S jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	s repid=$i(^CacheTemp)
 	s ind=1
 	s fromDate="2000-01-01"
 	s toDate="2016-08-08"
 	s MarkNo=""
 	s MarkNo=$g(MarkNo)
 	i fromDate'="" s fromDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)  
 	;i fromDate["-" s fromDate=$zdh(fromDate,3)
 	;i fromDate["/" s fromDate=$zdh(fromDate,4)
 	i fromDate="" s fromDate=+$h
 	i toDate'="" s toDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)  
	;i toDate["-"  s toDate=$zdh(toDate,3)
	;i toDate["/"  s toDate=$zdh(toDate,4)
	i toDate=""  s toDate=+$h
	s allMarkNo=##class(web.DHCEMRegister).getallMarkNo("")
	s today=+$h
 	s num=0
 	//i (fromDate="")!(toDate="")  s qHandle=$lb(0,repid,0) q $$$OK
    
 	f date=fromDate:1:toDate  d 
	.s EpisodeID2="" f  s EpisodeID2=$o(^PAADMi("PAADM_AdmDate",date,EpisodeID2)) q:EpisodeID2=""  d
 	..s EpisodeID=EpisodeID2
 	..s EpisodeIDYY=EpisodeID2
 	..s curmarknostr=##class(web.DHCEMRegister).GetRegMark(EpisodeID)
 	..q:curmarknostr=""
 	..q:curmarknostr="^^"
 	..s curmarkno=$p(curmarknostr,"^",1)
 	..s curmarknoId=$p(curmarknostr,"^",2)
 	..q:curmarknoId=""
 	..q:(MarkNo'="")&(curmarknoId'=MarkNo)
 	..s curmarkno2="^"_curmarknoId_"^"
 	..q:allMarkNo'[curmarkno2
 	..s admDate=date
	..s admDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(admDate) //$zd(admDate,3)
	..s admTime=$p($g(^PAADM(EpisodeID)),"^",7)
	..i admTime'="" s admTime=$zt(admTime,2)
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    ..s curregno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    ..q:(regNo'="")&(regNo'=curregno)
    ..s name=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    ..s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    ..s age=..CalAge(birth,today)
 	..s symptom=""
 	..s mradmId=$p(^PAADM(EpisodeID),"^",61)
 	..s MRDiagnos=""
 	..s mrdiaSub=0
  	..f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  	...s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
  	....s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
  	....q:dtypId=""
  	....s TypCode=$p($G(^MRC("DTYP",dtypId)),"^",1)
  	....//q:TypCode'="OUT"
  	....s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
  	....q:MRDIAICDCodeDR=""
  	....i MRDiagnos="" d
  	.....s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
  	....e  d
  	.....s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
 	..s homeAddres=$p($g(^PAPER(papmiId,"PER",4)),"^",18)  // 住址
	..i homeAddres="" S homeAddres=$g(^PAPER(papmiId,"PER","ADD",1))     // 单位 paperson
    ..s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
    ..s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
    ..s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
 	..s tel=handtel_" "_workTel_" "_homeTel
 	..s ID=$o(^User.DHCADMNurRegistI("PAADM"," "_EpisodeID,""))
 	..i ID="" s symptom=""
 	..e  s symptom=$listget(^User.DHCADMNurRegistD(ID),3)
    ..s num=num+1
   
    ..;S TempStr=num_"^"_StudyNo_"^"_strOrderName_"^"_strDate_"^"_ItemStatus_"^"_IsReaded_"^"_IsModify_"^"_Report_"^"_IsIll_"^"_LocName_"^"_IshasImg_"^"_MediumName_"^"_Memo_"^"_oeorditemdr_"^"_replocdr
	..s TempStr=num_"^"_admDate_"^"_admTime_"^"_curregno_"^"_name_"^"_sex_"^"_age_"^"_curmarkno_"^"_symptom_"^"_MRDiagnos_"^"_tel_"^"_ID_"^"_EpisodeIDYY
	..S count=count+1

	..Q:count<Start
	..Q:count>End
	
    ..W $case(count,Start:"",:",") 
	..W ##class(web.DHCEMJsonCommon).getJsonData("num^admDate^admTime^currregno^name^sex^age^curmarkno^symptom^MRDiagnos^tel^ID^EpisodeIDYY",TempStr)
	W "],""total"":"_count_"}"
	Q ""
}

ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=##class(web.DHCEMCommonUtil).DateLogicalToHtml(IBirth) //$zd(IBirth)
    s XToday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(IToday) //$zd(IToday)
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
	//s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

/// w ##class(web.DHCEMRegister).getallMarkNo("")
ClassMethod getallMarkNo(Dep) As %String
{
 	// w ##class(web.DHCADMVisitStat).getallMarkNo("195")
 	s allmark=""
    //s allstr=##class(web.DHCRBResSession).FindAllResDocNew("195")
    s allstr=##class(web.DHCEMRegister).FindAllResDocNew(Dep)
    s num=$l(allstr,"^")
    f i=1:1:num d
    .s tempmark=$p(allstr,"^",i)
    .s tempmarkId=$p(tempmark,$c(1),1)
    .s desc=$p(tempmark,$c(1),2)
    .i desc["-" s desc=$p(desc,"-",1)
    .q:desc["不用"
    .i allmark="" s allmark="^"_tempmarkId
    .e  s allmark=allmark_"^"_tempmarkId
    i $g(allmark)'="" d
    .s allmark=allmark_"^"
    q allmark
}

/// w ##class(web.DHCEMRegister).FindAllResDocNew("")
ClassMethod FindAllResDocNew(Dep) As %String
{
	   S Rowid=0
	   s ret1=""
	   f  s Rowid=$o(^RB("RES",Rowid))  q:Rowid=""  d
	  .s RESCTLOCDR=$p($g(^RB("RES",Rowid)),"^",1)
	  .q:(Dep'="")&&(Dep'=RESCTLOCDR)
	  .s RESCTPCPDR=$p($g(^RB("RES",Rowid)),"^",2)
	  .s:RESCTPCPDR'="" DocDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)
	  .s RESScheduleRequired=$p($g(^RB("RES",Rowid)),"^",6)
	  .q:RESScheduleRequired'="Y"
	  .s Childsub=0
	  .s SessStartTime=$o(^RBAS(Rowid,0,"DateSTime",+$H,""),-1)
	  .q:SessStartTime=""
	  .s Childsub=$o(^RBAS(Rowid,0,"DateSTime",+$H,SessStartTime,Childsub))
	  .q:Childsub=""
	  .q:Childsub="AQ"
	  .s AsDate=$p(^RBAS(Rowid,Childsub),"^",1)
	  .q:AsDate'=+$H
	  .s DocOtherName="" 
	  .i RESCTPCPDR'="" d
	  ..i $d(^CTPCP(RESCTPCPDR,3)) s DocOtherName=$p(^CTPCP(RESCTPCPDR,3),"^",28)
	  .i DocOtherName'="" s DocDesc=DocDesc_"-"_DocOtherName
	  .s ret=RESCTPCPDR_$C(1)_DocDesc
      .i ret1="" s ret1=ret
	  .e  s ret1=ret1_"^"_ret
	  Q ret1
}

/// 根据就诊ID获取所挂号别 demo：蒋荣猛(副主任)^920^上午
/// w ##class(web.DHCEMRegister).GetCareByAdm(123)
ClassMethod GetCareByEmPCLvID(EmPCLvID As %String)
{
	n (EmPCLvID)
	s PaAdmDr ="",CareStr = "",EmPCLvAdm="0"
	f  s EmPCLvAdm = $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,EmPCLvAdm))	q:EmPCLvAdm=""  d	
	.i EmPCLvAdm'="" d
	.s PaAdmDr = $p(^DHCEMPCA(EmPCLvAdm),"^",2)
	.i CareStr'="" d
	..s CurAdmCare=""
	..s CurAdmCare = ..GetCareByAdm(PaAdmDr)
	..q:CareStr[CurAdmCare
	..s CareStr= CareStr_","
	..s CareStr= CareStr_CurAdmCare
	.i CareStr="" d
	..s CareStr = ..GetCareByAdm(PaAdmDr)
	q CareStr
}

/// 根据就诊ID获取所挂号别 demo：蒋荣猛(副主任)^920^上午
/// w ##class(web.DHCEMRegister).GetCareByAdm(123)
ClassMethod GetCareByAdm(Adm)
{
	n (Adm)
	s CareDesc = ""
	q:Adm="" ""
	s CareDr = $p(^PAADM(Adm),"^",9)
	q:CareDr="" ""
	;s CareDesc =$p(^CTPCP(CareDr,1),"^",2)_"^"_CareDr
	s CareDesc = $p(^CTPCP(CareDr,1),"^",2)
	q CareDesc
}

/// 根据就诊ID获取所挂号别 demo：蒋荣猛(副主任)^920^上午
/// w ##class(web.DHCEMRegister).GetRegMark(8196,2)
ClassMethod GetRegMark(Adm, hospId) As %String
{
	n (Adm,hospId)
	s MarkID=""
	s MarkDesc=""
	s TRDesc=""
	s hosp =""
	&SQL(SELECT ID into :RegfeeRowId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:Adm)
	q:RegfeeRowId="" "^^"
	&SQL(SELECT RegfeeDepDr,RegfeeDocDr,RegfeeTimeRangeDr into :AdmDepRowId,:MarkID,:TRRowId 
	FROM SQLUser.DHCRegistrationFee Where ID=:RegfeeRowId)
	i AdmDepRowId'="" s hosp=$p($g(^CTLOC(AdmDepRowId)),"^",22)		
	i TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2) //ed
	s:MarkID'="" MarkDesc=$P($G(^CTPCP(MarkID,1)),"^",2)
	q:hosp'=hospId "^^"
	Q MarkDesc_"^"_MarkID_"^"_TRDesc
}

/// Description: 新版急诊 分诊查询 科室下拉
/// Creator:     huaxiaoying
/// CreateDate:  2016-08-18
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 
/// Return： 	 科室（号别）
/// 
ClassMethod FindMarkNo(search As %String) As %String
{
	n (LocID, HospID,search)
	s result = ##class(%Library.ResultSet).%New()
	s count = 0
	w "["_"{"_"""id"""_":"_"""0"""_","_"""text"""_":"_"""全部"""_"},"
	;[{"id":"0","text":"全部"},

	s allmark=""
    //s allstr=##class(web.DHCEMRegister).FindAllResDocNew("195") //友谊
    s allstr=##class(web.DHCEMRegister).FindAllResDocNew("67")   //32
    s num=$l(allstr,"^")
    f i=1:1:num d
    .s tempmark=$p(allstr,"^",i)
    .s code=$p(tempmark,$c(1),1)
    .s desc=$p(tempmark,$c(1),2)
    .i desc["-" s desc=$p(desc,"-",1)
    .q:desc["不用"
    .q:(search'="")&&(desc'[search)
    .s tmp=code_"^"_desc
    .s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description: 新版急诊 分诊查询 科室下拉
/// Creator:     qiaoqingao
/// CreateDate:  2016-10-20
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 
/// Return： 	 科室（号别）
/// w ##class(web.DHCEMRegister).FindMarkNoNew()
ClassMethod FindMarkNoNew(hosp, search As %String) As %String
{
	n (LocID,hosp,search)
	s result = ##class(%Library.ResultSet).%New()
	s count = 0
	w "["_"{"_"""id"""_":"_"""0"""_","_"""text"""_":"_"""全部"""_"},"
	;[{"id":"0","text":"全部"},
	s i=0
	s loc="" f  s loc=$o(^CTLOC(0,"LocType","EM",loc)) q:loc=""  d
	.q:+$o(^PAC("ADMLOC",0,"AdmType","E",loc,""))=0
	.s hospitaldr=$p(^CTLOC(loc),"^",22)
	.;q:hospitaldr'=hosp
	.s dateFrom=+$p(^CTLOC(loc),"^",24)
	.s dateTo=+$p(^CTLOC(loc),"^",25)
	.q:dateFrom>+$h
	.q:(+dateTo'=0)&(dateTo<+$h)
	.s resc="" f  s resc=$o(^RB("RES",0,"CTLOC",loc,resc)) q:resc=""  d 
	..q:$d(^SSU("SSUSR",0,"CTPCP",$p(^RB("RES",resc),"^",2)))
	..s schedulerequired=$p(^RB("RES",resc),"^",6)
	..q:((schedulerequired'="Yes")&(schedulerequired'="Y"))
	..s desc=$p(^RB("RES",resc),"^",17)
	..s doc=$p(^RB("RES",resc),"^",2)
	..s actFlag=$p($g(^CTPCP(doc,1)),"^",9)
	..q:actFlag'="Y"
	..s startDate=$p($g(^CTPCP(doc,2)),"^",14)
	..s endDate=$p($g(^CTPCP(doc,2)),"^",15)
	..q:(+startDate'=0)&&(startDate>+$h)
	..q:(+endDate'=0)&&(endDate<+$h)
	..s code=$p(^RB("RES",resc),"^",2)
    ..s tmp=code_"^"_desc
    ..q:(search'="")&(desc'[search)
    ..s count = count+1
	..I count=1 d
	...W ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	..e  d
	...W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description: 新版急诊 分诊查询 来诊方式下拉
/// Creator:     huaxiaoying
/// CreateDate:  2016-09-06
/// Table: 		 DHC_EmPatAdmWay
/// Input:  	 
/// Return： 	 来诊方式
/// d ##class(web.DHCEMRegister).ListPatAdmWay()
ClassMethod ListPatAdmWay(search As %String) As %String
{
	n (LocID, HospID,search,%session)
	s result = ##class(%Library.ResultSet).%New()
	s HospId=%session.Data("LOGON.HOSPID")
	s count = 0
	w "["
	s phId=""
	f  s phId=$o(^DHCEMPADW(phId)) q:phId=""  d
	.q:phId=0
	.;s code=$p(^DHCEMPADW(phId),"^",1)
	.s desc=$p(^DHCEMPADW(phId),"^",2)
	.s active=$p(^DHCEMPADW(phId),"^",3)
	.q:active'="Y"
	.;q:$p(^DHCEMPADW(phId),"^",4)'=HospId //hxy 2020-05-26 注释
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatAdmWay",phId,HospId)'="Y" //hxy 2020-05-26 
    .q:(search'="")&&(desc'[search)
    .s desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatAdmWay","PAWDesc","",desc) //hxy 2022-10-21
    .s tmp=phId_"^"_desc
    .q:(search'="")&(desc'[search)
    .s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description: 新版急诊 分诊查询 导出数据
/// Creator:     congyue
/// CreateDate:  2016-09-12
/// Table: 		 DHC_EmPatCheckLev
/// Input:  	 
/// Return： 	 分诊信息
/// W ##Class(web.DHCEMRegister).GetRegisterNew()
ClassMethod GetRegisterNew(LgUserID) As %String
{
	S count=0, Start=1
	
	s TempTitle = "num^patientID^admDate^admTime^WaitTime^currregno^name^sex^age^curmarkno^symptom"
	s TempTitle=TempTitle_"^MRDiagnos^PCSTemp^PCSHeart^PCSPCSPulse^PCSBP^tel^PCLNurseLevel^ID^EpisodeID"
	s TempTitle=TempTitle_"^PCLPatAskFlag^PCLAdmWay^EmAware^PCLRowID^VeerLocDesc^EmRecLevel^NurseLevel"
	s TempTitle=TempTitle_"^SickHistory^Screening^PCSR^EmPcsGLU^EmPcsSoP2^PCLCareLoc^IsGreenAdm^PCLNurUser"
	
	///转换数据为Json格式
	W "[" //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCEM","web.DHCEMRegister","ListRegisterNew",LgUserID,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCEM","web.DHCEMRegister","ListRegisterNew",LgUserID,index))
	.S count=count+1
    .W $case(count,Start:"",:",") 
	.W ##class(web.DHCEMJsonCommon).getJsonData(TempTitle,mdate) ;2016-09-03 congyue 
	W "]" //输出json结尾符
	
	Q ""
}

/// Description: 新版急诊 通过科室获取医院名称
/// Creator:     QQA
/// CreateDate:  2016-10-20
/// Table: 		 CT_Hospital，CT_Loc
/// Input:  	 
/// Return： 	 医院名称
/// W ##Class(web.DHCEMRegister).gethHospitalName("100")
ClassMethod gethHospitalName(locId As %String)
{
	q:locId=""
	s hospitolName=""
	s hospitolDr = $p(^CTLOC(locId),"^",22)
	s:hospitolDr'="" hospitolName=$p(^CT("HOSP",hospitolDr),"^",2)
	s hospitolName=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTHospital","HOSPDesc","",hospitolName)
	q hospitolName
}

/// Description: 新版急诊 获取既往史
/// Creator:     QQA
/// CreateDate:  2016-10-20
/// Table: 		 
/// Input:  	 
/// Return： 	 医院ID
/// W ##Class(web.DHCEMRegister).GetEmPatChkHis("")
ClassMethod GetEmPatChkHis(HospID As %String, search As %String) As %String
{
	
	n (HospID,search,%session)
	s result = ##class(%Library.ResultSet).%New()
	s HospID=%session.Data("LOGON.HOSPID")
	s sqlStr = "SELECT PH_RowID,PH_Desc FROM DHC_EmPatHistory Where"
	;s:+HospID'=0 sqlStr = sqlStr_"  PH_Hosp_Dr='"_HospID_"' And " //hxy 2020-05-26 注释
	s sqlStr = sqlStr_"  PH_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="id^text"
	s count = 0
	w "["
	While(result.Next())
	{
		s PatHisID = result.Data("PH_RowID")
		s PatHisDesc = result.Data("PH_Desc")
		s PatHisDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatHistory","PHDesc","",PatHisDesc)
		s ListData=PatHisID_"^"_PatHisDesc
		continue:(search'="")&(PatHisDesc'[search)
		continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatHistory",PatHisID,HospID)'="Y" //hxy 2020-05-26
		s count = count+1
		I count=1 d
		.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Description: 新版急诊 获取护士分级
/// Creator:     QQA
/// CreateDate:  2016-11-08
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCEMRegister).GetNurLevel("")
ClassMethod GetNurLevel() As %String
{
	
	w "["
		w ##class(web.DHCEMJsonCommon).getJsonData("id^text","1^Ⅰ级")
		W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text","2^Ⅱ级")
		W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text","3^Ⅲ级")
		W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text","4^Ⅳa级")
		W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text","5^Ⅳb级")
	w "]"
	q ""
}

/// Description: 新版急诊 获取号别
/// Creator:     QQA
/// CreateDate:  2016-11-21
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCEMRegister).GetNurHao("")
ClassMethod GetNurHao() As %String
{
	
	w "["
		w ##class(web.DHCEMJsonCommon).getJsonData("id^text","1468^外科急诊号")
		W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text","876^内科急诊号")
	w "]"
	q ""
}

/// Description: 新版急诊 筛选下拉框
/// Creator:     QQA
/// CreateDate:  2016-11-21
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCEMRegister).GetScreeningInfo()
ClassMethod GetScreeningInfo() As %String
{
	
	w "["
		w ##class(web.DHCEMJsonCommon).getJsonData("id^text","Y^是")
		W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text","N^否")
	w "]"
	q ""
}

/// Description: 新版急诊 获取当前复诊率（72小时就诊多次的人数/至少就诊一次的人数）
/// Creator:     QQA
/// CreateDate:  2016-11-21
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCEMRegister).GetEfficiency()   
ClassMethod GetEfficiency()
{
	s (StarDate,EndDate,EntTime,StarTime)=""
	
	s StarDate= +$h-4    														//72小时永远在4天之内
	s EndDate = +$h
	s pid = $i(^CacheTemp)
	s rs=""
	k ^TEMP("web.DHCEMRegister","GetEfficiency",pid)
	f Date=StarDate:1:EndDate  d 
	.s AdmTime=""
	.f  s AdmTime=$o(^PAADMi("TypeDate","E",Date,AdmTime))   q:AdmTime=""  d
	..s IntervalTime =Date-StarDate*24+(AdmTime\3600)       					//算出现在距离开始时间间隔了多长时间 
	..q:(IntervalTime<0)||(IntervalTime>72)  									//过滤72小时的病人
	..s AdmDr="0"
 	..f  s AdmDr=$o(^PAADMi("TypeDate","E",Date,AdmTime,AdmDr))   q:AdmDr=""  d
	...q:AdmDr=""
	...s PatDr = $p(^PAADM(AdmDr),"^",1)  
	...i $d(^TEMP("web.DHCEMRegister","GetEfficiency",pid,PatDr))="0" d
	....s ^TEMP("web.DHCEMRegister","GetEfficiency",pid,PatDr)="N"
	...else  d
	....s ^TEMP("web.DHCEMRegister","GetEfficiency",pid,PatDr)="Y"    //复诊为Y，没有复诊为N
	
 	s (AllCount,Count)=0
 	s PatDr=""
 	f  s PatDr = $o(^TEMP("web.DHCEMRegister","GetEfficiency",pid,PatDr))  q:PatDr=""  d
 	.q:PatDr=""
 	.s AllCount=AllCount+1
 	.i (^TEMP("web.DHCEMRegister","GetEfficiency",pid,PatDr)="Y")  d
 	..s Count=Count+1
 	i Count=0 s rs="0%" 
 	i Count'=0 s rs = $j(Count/AllCount,",","4")*100_"%" 
 	k ^TEMP("web.DHCEMRegister","GetEfficiency",pid)
	q rs
}

// w ##Class(web.DHCEMRegister).getEmeNumInfo()

// w ##Class(web.DHCEMRegister).getEmeNumInfo()

/// desc :过滤医院取分诊号别
ClassMethod getEmeNumInfo(search As %String, LocID = "")
{
	n (search,LocID,%session)
	s result = ##class(%Library.ResultSet).%New()
	s LocStr = ##Class(web.DHCEMRegister).textGetEmPatLoc("")
	s:LocID'="" LocStr=LocID
	
	s repid=$i(^CacheTemp)
	s sqlStr = "SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR,RES_CTPCP_DR->CTPCP_ActiveFlag,RES_DateActiveFrom,RES_DateActiveTo FROM SQLUser.RB_RESOURCE WHERE RES_CTLOC_DR in ("_LocStr_") And (res_schedulerequired='Yes' or res_schedulerequired='Y')"
    d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{		
		s ID = result.Data("RES_CTPCP_DR")
		s Desc = result.Data("CTPCP_Desc")
		Continue:result.Data("CTPCP_ActiveFlag")'="Y"    //
		Continue:(search'="")&(Desc'[search)    //文字检索
		s DateFrom = result.Data("RES_DateActiveFrom")
		s DateTo = result.Data("RES_DateActiveTo")
		Continue:(DateFrom>+$h)
		Continue:(DateTo'="")&&(DateTo<+$h)
		//Continue:$d(^SSU("SSUSR",0,"CTPCP",ID))
		s CTPCPCarPrvTpDR1=$p($g(^CTPCP(ID,1)),"^",4)    //人员类型ID
		s CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR1)),"^",4)
		Continue:CTCPTDesc'="DOCTOR"
		s CareStDate=$p(^CTPCP(ID,2),"^",14)
		s CareEndDate=$p(^CTPCP(ID,2),"^",15)
		Continue:(CareStDate>+$h)
		Continue:(CareEndDate'="")&&(CareEndDate<+$h)
		s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",Desc) //hxy 2022-10-21
		s tmp=ID_"^"_Desc
		s ^TMP("DHCEM","web.DHCEMRegister","getEmeNumInfo",repid,ID)=tmp 
	}
	
	w "["
	s count = 0
	s ID=""
	f  s ID = $o(^TMP("DHCEM","web.DHCEMRegister","getEmeNumInfo",repid,ID))  q:ID=""  d
	.s tmp = ^TMP("DHCEM","web.DHCEMRegister","getEmeNumInfo",repid,ID)
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	
	k ^TMP("DHCEM","web.DHCEMRegister","getEmeNumInfo")
	
	q ""
}

/// 	
/// Descritp:	获取所有的分诊科室
/// W ##Class(web.DHCEMRegister).textGetEmPatLoc("2")
ClassMethod textGetEmPatLoc(HospID As %String) As %String
{
	n (HospID,%session)
	s HospID=%session.Get("LOGON.HOSPID")
	s LocType=""
	S DataStr=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc,CTLOC_Hospital_DR as lochosp, "
	//s sqlStr = sqlStr_"CTLOC_DateActiveFrom as DateFrom,CTLOC_DateActiveTo as DateTo FROM CT_LOC Where CTLOC_Type = 'EM'"
    s sqlStr = sqlStr_"CTLOC_DateActiveFrom as DateFrom,CTLOC_DateActiveTo as DateTo FROM CT_LOC Where  CTLOC_ROWID IN (SELECT ADMLOC_CTLOC_DR FROM PAC_AdmTypeLocation WHERE ADMLOC_AdmType='E')"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	While(result.Next())
	{	
		s DateFrom = result.Data("DateFrom")
		Continue:DateFrom>+$H
		s lochosp= result.Data("lochosp")
		s DateTo = result.Data("DateTo")
		i DateTo'="" Continue:DateTo<+$H
		s LocDr = result.Data("LocDr")
		s hosp=$p(^CTLOC(LocDr),"^",22)
		;Continue:hosp'=HospID //hxy 2020-05-26 注释
		continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocDr,HospID)'="Y" //hxy 2020-05-26
		s LocDesc = result.Data("LocDesc")
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		i count=1 d
		.s DataStr=LocDr
		i count>1 d
		.s DataStr=DataStr_","_LocDr
	}
	q DataStr
}

// w ##Class(web.DHCEMRegister).getEmeInfoNsj()

ClassMethod getEmeInfoNsj()
{
	s result = ##class(%Library.ResultSet).%New()
	s LocStr = ##Class(web.DHCEMRegister).textGetEmPatLoc("")
	s dataStr=""
	s sqlStr = "SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR FROM SQLUser.RB_RESOURCE WHERE RES_CTLOC_DR in ("_LocStr_") And (res_schedulerequired='Yes' or res_schedulerequired='Y') Group By RES_CTPCP_DR"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	While(result.Next())
	{	
		s ID = result.Data("RES_CTPCP_DR")
		s Desc = result.Data("CTPCP_Desc")
		q:(ID="3315")
		Continue:$d(^SSU("SSUSR",0,"CTPCP",ID))
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.s dataStr=tmp
		e  d
		.s dataStr=dataStr_"!"_tmp
	}
	q dataStr
}

///  Descript: 症状分级树去掉子节点
/// w ##class(web.DHCEMRegister).jsonEmPatSymptomLev()
ClassMethod jsonEmPatSymptomLev(search As %String)
{
	s count = 0
	w "["
	s ID=0,count=0
  	;f  s ID=$o(^User.DHCSymptomLevI("ParIdx","-100000000000000",ID)) q:ID=""  d
  	f  s ID=$o(^User.DHCSymptomLevD(ID)) q:ID=""  d
  	.q:'$d(^User.DHCSymptomLevD(ID))
  	.s Text=$LISTGET(^User.DHCSymptomLevD(ID),3)
  	.s Text=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCSymptomLev","SYLDesc","",Text)
  	.q:(Text'[search)&(search'="")                 //QQA 2017-01-12 检索功能
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStartSign(ID,Text)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStartSign(ID,Text)
	.w "}"
	w "]"
  	q ""
}

ClassMethod GetParams(Params)
{
	n (Params)
	s DateFormate = ##class(web.DHCEMCommonUtil).DateFormat()
	q DateFormate
}

/// 获取分诊主诉父元素ID串串
/// w ##class(web.DHCEMRegister).HasSymp(17,1)
ClassMethod HasSymp(SymDr, PCLRowID)
{
	n (SymDr,PCLRowID)
	q:SymDr="" ""
	q:PCLRowID="" ""
	
	s Ret=""
	
	s SymFielStr=""
	s EmSymFId=""
	f  s EmSymFId=$o(^DHCSYMCONi(0,SymDr,EmSymFId)) Q:EmSymFId=""  D
	.s EmSymDr = EmSymFId
	.f I=$l(EmSymDr):1:6 d
	..s EmSymDr ="0"_EmSymDr
	.
	.s:SymFielStr'="" SymFielStr=SymFielStr_","_EmSymDr
	.s:SymFielStr="" SymFielStr=EmSymDr
	s Symptom=$p(^DHCEMPCL(PCLRowID),"^",25)        //症状
	s Length=$l(Symptom,"#")
	f Index=1:1:Length q:+Ret'=0  d
	.s Lstr =$p(Symptom,"#",Index)
	.s SymDr = $p(Lstr,"!",1)
	.f I=$l(SymDr):1:6 d
	..s SymDr ="0"_SymDr
	.q:SymFielStr'[SymDr
	.s Ret=1
	quit Ret
}

/// Creator:qqa
/// Descipt:生命体征历史
/// w ##class(web.DHCEMRegister).GetSignHis(11)
ClassMethod GetSignHis(EmPCLvID)
{
	n (EmPCLvID)
	s Count=0
	s ListTitle ="Time^Temp^Heart^Pulse^SBP^DBP^SOP2^SCSR^EmPcsGLU"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s PCSRowID=""
	f  s PCSRowID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,PCSRowID)) q:PCSRowID=""  d
 	.s PCSTime=$p(^DHCEMPCS(PCSRowID),"^",2)
 	.s PCSTime=$zt(PCSTime,1)
 	.s PCSTemp=$p(^DHCEMPCS(PCSRowID),"^",3)        //体温T 
 	.s PCSHeart=$p(^DHCEMPCS(PCSRowID),"^",4)		//心律
 	.s PCSPCSPulse=$p(^DHCEMPCS(PCSRowID),"^",5)	//脉搏
 	.s PCSDBP=$p(^DHCEMPCS(PCSRowID),"^",7)         //收缩压
 	.s PCSSBP=$p(^DHCEMPCS(PCSRowID),"^",6)			//舒张压
 	.s EmPcsSoP2=$p(^DHCEMPCS(PCSRowID),"^",8)      //血氧
 	.s PCSR = $p(^DHCEMPCS(PCSRowID),"^",9)			//呼吸频率
 	.s EmPcsGLU=$p(^DHCEMPCS(PCSRowID),"^",10) 		///血糖
	.s ListData = PCSTime_"^"_PCSTemp_"^"_PCSHeart_"^"_PCSPCSPulse_"^"_PCSSBP_"^"_PCSDBP_"^"_EmPcsSoP2_"^"_PCSR_"^"_EmPcsGLU
 	.s Count=Count+1
 	.W $case(Count,1:"",:",")
	.W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Creator:qqa
/// Descript:获取病人第一个状态的时间
/// w ##class(web.DHCEMRegister).GetPatFirstStatDate(1)
ClassMethod GetPatFirstStatDate(EpisodeID = "") As %String
{
	n (EpisodeID)
	s Ret=""
	q:EpisodeID="" ""
	s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""))
	q:AvsID="" ""
	s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
	s Ret=$P(^DHCADMVisitStatus(AvsID),"^",5)_"^"_$P(^DHCADMVisitStatus(AvsID),"^",6)
   	q Ret
}

/// w ##class(web.DHCEMRegister).GetAdmLoc(1)
ClassMethod GetAdmLoc(EpisodeID)
{
	n (EpisodeID,%session)
	q:+EpisodeID=0 ""
	s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
	s LocDesc = $p(^CTLOC(AdmLocID),"^",2)
	s LocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	q LocDesc
}

/// w ##class(web.DHCEMRegister).GetAdmCare(107)
ClassMethod GetAdmCare(EpisodeID)
{
	n (EpisodeID,%session)
	q:+EpisodeID=0 ""
	s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	q:QueRowId="" ""
	s QueDocDr=$List(^User.DHCQueueD(QueRowId),8)
	s QueCare=$p(^CTPCP(QueDocDr,1),"^",2)
	s QueCare=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",QueCare) 
	q QueCare
}

Storage Default
{
<Data name="DHCEMRegisterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMRegisterD</DataLocation>
<DefaultData>DHCEMRegisterDefaultData</DefaultData>
<IdLocation>^web.DHCEMRegisterD</IdLocation>
<IndexLocation>^web.DHCEMRegisterI</IndexLocation>
<StreamLocation>^web.DHCEMRegisterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
