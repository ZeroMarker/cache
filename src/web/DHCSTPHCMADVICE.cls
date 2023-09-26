Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-06-20
/// Descript: 用药建议
Class web.DHCSTPHCMADVICE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存建议信息
ClassMethod SaveAdvice(medAdvID As %String, medAdvDataList As %String) As %String
{
	n (medAdvID,medAdvDataList)
	s medAdvMasDataList=$p(medAdvDataList,"!",1)  //用药建议主信息
	s medAdvDrgItmList=$p(medAdvDataList,"!",2)   //医嘱信息
	s medAdvContentList=$p(medAdvDataList,"!",3)  //建议信息
	s ret=0
	i medAdvID="" d
	.S ret=..Insert(medAdvMasDataList,medAdvContentList,medAdvDrgItmList)
	e  d
	.S ret="" //..Update(medAdvID,medAdvMasDataList,medAdvContentList,medAdvDrgItmList)
	q ret
}

/// Descript:保存建议信息
ClassMethod Insert(medAdvMasDataList, medAdvContentList, medAdvDrgItmList) As %String
{
	N (medAdvMasDataList,medAdvContentList,medAdvDrgItmList)

	s Err=0
	TS
	s medAdvID=..InsPHMedAdvice(medAdvMasDataList)
	i medAdvID<0 tro

	q:medAdvID<0 medAdvID
	
	//保存建议明细
	i medAdvContentList'="" d
	.s Err=..InsPHMedAdvDetail(medAdvID,medAdvContentList)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//保存医嘱明细
	i medAdvDrgItmList'="" d
	.s Err=..InsPHMedAdvItm(medAdvID,medAdvDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	TC
	Q medAdvID
}

/// Descript:保存建议信息
ClassMethod Update(medAdvID, medAdvMasDataList, medAdvContentList, medAdvDrgItmList) As %String
{
	N (medAdvID,medAdvMasDataList,medAdvContentList,medAdvDrgItmLis)
	s Err=0
	TS
	s medAdvID=..UpdPHMedAdvice(medAdvMasDataList)
	i medAdvID<0 tro
	q:medAdvID<0 medAdvID
	
	//保存建议明细
	i medAdvContentList'="" d
	.s Err=..InsPHMedAdvDetail(medAdvID,medAdvContentList)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//保存医嘱明细
	i medAdvDrgItmList'="" d
	.s Err=..InsPHMedAdvItm(medAdvID,medAdvDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	TC
	Q 0
}

/// Descript:保存用药建议主表
ClassMethod InsPHMedAdvice(medAdvMasDataList As %String) As %String
{
	N (medAdvMasDataList)
	S admDr=$p(medAdvMasDataList,"^",1)
	S userID=$p(medAdvMasDataList,"^",2)
	S docUserID=$p(medAdvMasDataList,"^",3)
	S date=+$h
	S time=$p($h,",",2)
	S curStatus="10"
	
	&SQL(Insert Into DHC_PHAdvice(PHA_User_Dr,PHA_Adm_Dr,PHA_DocUser_Dr,PHA_Date,PHA_Time,PHA_CurStatus) 
		Values(:userID,:admDr,:docUserID,:date,:time,:curStatus))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新用药建议主表
ClassMethod UpdPHMedAdvice(medAdvID As %String, medAdvMasDataList As %String) As %String
{
	N (medAdvID,medAdvMasDataList)
	S admDr=$p(medAdvMasDataList,"^",1)
	S userID=$p(medAdvMasDataList,"^",2)
	S docUserID=$p(medAdvMasDataList,"^",3)
	S date=+$h
	S time=$p($h,",",2)
	S curStatus="10"
	
	&SQL(Update DHC_PHAdvice Set PHA_User_Dr=:userID,PHA_Adm_Dr=:admDr,PHA_DocUser_Dr=:docUserID,
		PHA_Date=:date,PHA_Time=:time,PHA_CurStatus=:curStatus where PHA_RowID=:medAdvID)
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:保存建议明细
/// w ##class(web.DHCSTPHCMADVICE).InsPHMedAdvDetail("25","578^20^qqq")
ClassMethod InsPHMedAdvDetail(medAdvID As %String, medAdvContentList As %String) As %String
{
	N (medAdvID,medAdvContentList)
	S userID=$p(medAdvContentList,"^",1)
	S curStatus=$p(medAdvContentList,"^",2)
	S advContent=$p(medAdvContentList,"^",3)
	S date=+$h
	S time=$p($h,",",2)
	//S curStatus=$p(^DHCPHAD(medAdvID),"^",6)     //zhaowuqiang  2016/09/26 //cancel annotate by qnp
	TS
	&SQL(update DHC_PHAdvice set PHA_CurStatus=:curStatus where PHA_RowID=:medAdvID)
	i SQLCODE'=0 Tro
	Q:SQLCODE="" "-1"
	S childSub=$o(^DHCPHAD(medAdvID,"AD",""),-1)+1
	&SQL(Insert Into DHC_PHAdvDetail(PHAD_PHA_Parref,PHAD_ChildSub,PHAD_User_Dr,PHAD_Date,PHAD_Time,PHAD_Advice) 
		Values(:medAdvID,:childSub,:userID,:date,:time,:advContent))
	i SQLCODE'=0 Tro
	Q:SQLCODE="" "-2"
	TC
	s EpisodeId = $p(^DHCPHAD(medAdvID),"^",1)
	if curStatus="20" {	//医生申诉时发送消息
		s ToUser = $p(^DHCPHAD(medAdvID),"^",2)
		s Para = "1204"_"^"_userID_"^"_EpisodeId_"^"_""_"^"_ToUser
		s Context = "用药建议申诉"
		s linkUrl = "dhcpha.clinical.medadvises.csp?PatientID="_EpisodeId_"&EpisodeID="_EpisodeId
		s OtherPara = {}.%Set("link", linkUrl).%ToJSON()
		s ret = ##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(Context,Para,OtherPara)
	}
	Q 0
}

/// Descript:保存医嘱明细
ClassMethod InsPHMedAdvItm(medAdvID As %String, medAdvDrgItmLis As %String) As %String
{
	N (medAdvID,medAdvDrgItmLis)
	S Len=$L(medAdvDrgItmLis,",")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S tmpStr=$p(medAdvDrgItmLis,",",i)
	.S oeori=$p(tmpStr,"^",1)  //医嘱ID
	.
	.S childSub=$o(^DHCPHAD(medAdvID,"AI",""),-1)+1
	.&SQL(Insert Into DHC_PHAdvItm(PHAI_PHA_Parref,PHAI_ChildSub,PHAI_OEORI_DR) 
		Values(:medAdvID,:childSub,:oeori))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除用药建议
ClassMethod delPatMedAdv(medAdvID As %String) As %String
{
	N (medAdvID)
	Q:'$d(^DHCPHAD(medAdvID)) "-1"
	S medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6)  //当前状态
	Q:medAdvCurStatus'=10 "-2"
	&SQL(delete from DHC_PHAdvice where PHA_RowID=:medAdvID)
	Q SQLCODE
}

/// Descript:删除用药建议明细
ClassMethod delPatMedAdvDetail(medAdvDetID As %String) As %String
{
	N (medAdvDetID)
	S medAdvID=+medAdvDetID
	S CH=$p(medAdvDetID,"_",2)
	Q:'$d(^DHCPHAD(medAdvID,"AD",CH)) "-1"
	s userId=$p(^DHCPHAD(medAdvID,"AD",CH),"^",1)    //SS_User,过滤非临床药师  hezhigang
	s CareProvDR=$p($g(^SSU("SSUSR",userId)),"^",14)
	i CareProvDR'="" s CarPrvTpDR=$p($g(^CTPCP(CareProvDR,1)),"^",4)
	i CarPrvTpDR'="" s CPTDesc=$p($g(^CT("CPT",CarPrvTpDR)),"^",2)
	q:CPTDesc'["药师" "-3"
	//s groupId=$p(^SSU("SSUSR",userId),"^",5)
	//s groupDesc=$p(^SSU("SSGRP",groupId),"^",1)
	//q:groupDesc'[("Inpatient Pharmacy"&"临床药学") "-3"
	S medAdvDetID=medAdvID_"||"_CH
	&SQL(delete from DHC_PHAdvDetail where PHAD_RowID=:medAdvDetID)
	Q SQLCODE
}

/// Descript:更新建议表状态
ClassMethod updPatMedAdv(medAdvID As %String, curStatus As %String) As %String
{
	N (medAdvID,curStatus)
	Q:'$d(^DHCPHAD(medAdvID)) "-1"
	Q:curStatus="" "-2"
	S medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6)  //当前状态
	Q:medAdvCurStatus=curStatus "-3"
	&SQL(update DHC_PHAdvice set PHA_CurStatus=:curStatus where PHA_RowID=:medAdvID)
	Q SQLCODE
}

/// Descript:获取病人建议信息
/// w ##class(web.DHCSTPHCMADVICE).getPatMedAdvInfo("10")
ClassMethod getPatMedAdvInfo(medAdvID As %String) As %String
{
	N (medAdvID,%session)
	Q:'$d(^DHCPHAD(medAdvID)) ""
	S medAdvUser=$p(^DHCPHAD(medAdvID),"^",2) //建议人
	S:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	S medAdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	S medAdvEndDate=medAdvDate+3            //有效期
	S:medAdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvDate)  ;$zd(medAdvDate,3)
	S medAdvTime=$p(^DHCPHAD(medAdvID),"^",5)     //记录时间
	S:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
	S medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6)    //当前状态
	q:medAdvCurStatus=0 ""
	S medAdvCurStatus=$S(medAdvCurStatus="20":"申诉",medAdvCurStatus="30":"已接受",medAdvCurStatus="40":"药师同意",1:"")
	S:medAdvEndDate'="" medAdvEndDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvEndDate) ;$zd(medAdvEndDate,3)
	s medAdvCurStatus=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(medAdvCurStatus)
	s medAdvUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medAdvUser)
	S medAdvMasDataList=medAdvDate_" "_medAdvTime_"^"_medAdvEndDate_" "_medAdvTime_"^"_medAdvCurStatus_"^"_medAdvUser
	s medAdvDrgItmList=..getPHMedAdvDrgItm(medAdvID)   //医嘱信息
	s medAdvContentList=..getPHMedAdvDetail(medAdvID)  //建议信息

	s ret=medAdvID_"!"_medAdvMasDataList_"!"_medAdvDrgItmList_"!"_medAdvContentList
	Q ret
}

/// Descript:获取建议信息
ClassMethod getPHMedAdvDetail(medAdvID As %String) As %String
{
	N (medAdvID,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHAD(medAdvID,"AD",CH)) Q:CH=""  D
	.S medAdvUser=""
	.S medAdvUser=$p(^DHCPHAD(medAdvID,"AD",CH),"^",1)
	.S:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	.S medAdvDesc=$p(^DHCPHAD(medAdvID,"AD",CH),"^",4)
	.s medAdvUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medAdvUser)
	.s medAdvDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHAdvDetail","PHADAdvice","",medAdvDesc)
	.i ret="" S ret=medAdvUser_": "_medAdvDesc
	.E  S ret=ret_"||"_medAdvUser_": "_medAdvDesc
	Q ret
}

/// Descript:获取医嘱信息
ClassMethod getPHMedAdvDrgItm(medAdvID As %String) As %String
{
	N (medAdvID,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHAD(medAdvID,"AI",CH)) Q:CH=""  D
	.S oeori=$p(^DHCPHAD(medAdvID,"AI",CH),"^",1) //医嘱ID
	.S mdata=..getOeoriInfo(oeori)
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:获取医嘱信息
ClassMethod getOeoriInfo(oeori As %String) As %String
{
	N (oeori,%session)
	S ord=+oeori
	S chl=$p(oeori,"||",2)
	S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    Q:priDr=0 ""
    S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码              
    //Q:priorty["OM" "" //自备药
    S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
	S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	Q:inci="" "" //医嘱名称
	;S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	S inciDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)
	;S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	S dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(oeori)  //剂量
	S dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	;S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    ;S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率
    s freqInfo=##class(PHA.COM.Order).OeoriFreq(oeori)   //取频次调用统一接口
	s freqdr=$p(freqInfo,"^",1)  
    s freq=$p(freqInfo,"^",2)
    S instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
	s duration=""
    s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)         ///用药疗程
	S StartDate=+$p(^OEORD(ord,"I",chl,1),"^",9) //开始日期
	s execStat=##class(web.DHCSTPHCMCOMMON).CheckIfExec(ord,chl)	/// 是否执行 qunianpeng 2018/4/24
	s execStat=$case(execStat,"Y":"已执行","N":"未执行",:"") 
	s sendStat=##class(web.DHCSTPHCMCOMMON).CheckIfSend(ord,chl) 	/// 是否发药 qunianpeng 2018/4/24
	s sendStat=$case(sendStat,"Y":"已发药","N":"未发药",:"") 
	S:StartDate'="" StartDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(StartDate)  ;$zd(StartDate,3)
	s priorty=##class(PHA.FACE.IN.Com).GetTransDesc("User.OECPriority","OECPRDesc","",priorty)
	s inciDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",inciDesc)
	s freq=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCFreq","PHCFRDesc1","",freq)
	s instru=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)
	s duration=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCDuration","PHCDUCode","",duration)
	s execStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(execStat)
	s sendStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(sendStat)
	Q StartDate_" "_priorty_" "_inciDesc_" "_dosage_doseuom_" "_instru_" "_duration_" "_freq_" "_execStat_" "_sendStat
}

/// Descript:获取该病人建议列表
ClassMethod getPatAdviceList(AdmDr) As %String
{
	N (AdmDr)
	S medAdvPatAdviceList=""
	S medAdvID=""
	F  S medAdvID=$o(^DHCPHAD(0,"AdmDr",AdmDr,medAdvID)) Q:medAdvID=""  D
	.S ret=..getPatMedAdvInfo(medAdvID)
	.q:(ret = "")
	.i medAdvPatAdviceList=""  S medAdvPatAdviceList=ret
	.E  S medAdvPatAdviceList=medAdvPatAdviceList_"#"_ret
	Q medAdvPatAdviceList
}

/// Descript:获取病人建议列表
/// w ##class(web.DHCSTPHCMADVICE).QueryMedAdvPatList(15,1,"06/03/2017^09/03/2017^578^P^^")
ClassMethod QueryMedAdvPatList(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)
	s EndPage=page*rows          //结束行
	s StPage=((page-1)*rows)+1   //开始行
	s StartDate=$p(params,"^",1) //开始时间
	s EndDate=$p(params,"^",2)   //截止时间
	s userID=$p(params,"^",3)    //用户ID
	s appType=$p(params,"^",4)   //用户类型(医生-D,药师-P)
	s typeFlag=$p(params,"^",5)  //状态值
	s WardID=$p(params,"^",6)    //病区ID
	s InPatNo=$p(params,"^",7)   //登记号
	s hospID=$p(params,"^",8) 
	//s type=$s(appType="D":"DateDocUser",1:"DateUser")
	s StartDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StartDate) ;$zdh(StartDate,3)
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s num=0
	f dd=StartDate:1:EndDate d
	.s medAdvID=""
	.//f  s medAdvID=$o(^DHCPHAD(0,type,dd,userID,medAdvID)) q:medAdvID=""  d
	.f  s medAdvID=$o(^DHCPHAD(0,"Date",dd,medAdvID)) q:medAdvID=""  d
	..s medAdvAdmDr=$p(^DHCPHAD(medAdvID),"^",1) //病人ADM
	..s Locdr=$p(^PAADM(medAdvAdmDr),"^",4)
	..q:(hospID'="")&(hospID'=$p(^CTLOC(Locdr),"^",22))   //过滤病区
	..s medAdvUserID=$p(^DHCPHAD(medAdvID),"^",2) //操作人
	..s AdmWardID=$p(^PAADM(medAdvAdmDr),"^",70) //病区
	..q:(appType="D")&(WardID'="")&(WardID'=AdmWardID)
	..q:(appType="P")&(userID'=medAdvUserID)
	..s papmi=$p(^PAADM(medAdvAdmDr),"^",1)
	..s patName=$p(^PAPER(papmi,"ALL"),"^",1) //姓名
	..s patNo=$p(^PAPER(papmi,"PAT",1),"^",1) //登记号
	..q:(InPatNo'="")&(InPatNo'=patNo)
	..s bedid=$p(^PAADM(medAdvAdmDr),"^",73) //床号
    ..i bedid="" s AdmBed=""
    ..e  s patBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	..s medAdvUser=$p(^DHCPHAD(medAdvID),"^",2) //建议人
	..s:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	..s AdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	..s medAdvEndDate=AdvDate+3            //有效期
	..s:AdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdvDate)   ;$zd(medAdvDate,3)
	..s AdvTime=$p(^DHCPHAD(medAdvID),"^",5)     //记录时间
	..s:AdvTime'="" medAdvTime=$zt(AdvTime,2)
	..s medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6)    //当前状态
	..q:medAdvCurStatus=0
	..q:(typeFlag'="")&(typeFlag'=medAdvCurStatus)
	..//q:(appType="D")&("30^40"[medAdvCurStatus)
	..//q:(appType="P")&("30^40"[medAdvCurStatus)
	..s medAdvCurStatus=$S(medAdvCurStatus="20":"申诉",medAdvCurStatus="30":"接受",medAdvCurStatus="40":"药师同意",1:"建议")
	..s:medAdvEndDate'="" medAdvEndDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvEndDate)  ;$zd(medAdvEndDate,3)
	..s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)
	..s medAdvCurStatus=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(medAdvCurStatus)
	..s medAdvMasDataList=medAdvID_"^"_medAdvDate_" "_medAdvTime_"^"_patBed_"^"_patName_"^"_patNo_"^"_papmi_"^"_medAdvAdmDr_"^"_medAdvCurStatus
	..s num=num+1
	..s index=AdvDate_" "_AdvTime_"||"_papmi_"||"_medAdvID
	..s ^TMP("DHCST","web.DHCSTPHCMADVICE","QueryMedAdvPatList",pid,index)=medAdvMasDataList

	q:num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	s Title="medAdvID^medAdvTime^PatBed^PatName^PatNo^PatientID^AdmDr^CurStatus"
	s maxrow=num
	i EndPage>maxrow S EndPage=maxrow
	s quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(num) //输出json前缀串
	s Num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADVICE","QueryMedAdvPatList",pid,index)) q:(index="")||(quitflag=1)  D
	.s mdata=^TMP("DHCST","web.DHCSTPHCMADVICE","QueryMedAdvPatList",pid,index)
	.s Num=Num+1
	.q:Num<StPage
	.s:Num=EndPage quitflag=1
	.i Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMADVICE","QueryMedAdvPatList",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADVICE","jsonMedAdvDrgItm",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMADVICE"))
}

/// Descript:获取病人建议信息
/// w ##class(web.DHCSTPHCMADVICE).getPatMedAdvIn("10")
ClassMethod getPatMedAdvIn(medAdvID As %String) As %String
{
	n (medAdvID,%session)
	q:'$d(^DHCPHAD(medAdvID)) ""
	s medAdvUser=$p(^DHCPHAD(medAdvID),"^",2) //建议人
	s:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	s medAdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	s medAdvEndDate=medAdvDate+3            //有效期
	s:medAdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvDate)  ;$zd(medAdvDate,3)
	s medAdvTime=$p(^DHCPHAD(medAdvID),"^",5)     //记录时间
	s:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
	s medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6)    //当前状态
	s medAdvCurStatus=$S(medAdvCurStatus="20":"申诉",medAdvCurStatus="30":"已接受",medAdvCurStatus="40":"药师同意",1:"")
	s:medAdvEndDate'="" medAdvEndDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvEndDate) ;$zd(medAdvEndDate,3)
	s medAdvCurStatus=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(medAdvCurStatus)
	s medAdvUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medAdvUser)
	
	s medAdvMasDataList=medAdvDate_" "_medAdvTime_"^"_medAdvEndDate_" "_medAdvTime_"^"_medAdvCurStatus_"^"_medAdvUser
	s medAdvDrgItmList=..getPHMedAdvDrgItm(medAdvID)   //医嘱信息
	s medAdvContentList=..getPHMedAdvInDetail(medAdvID)  //建议信息

	s ret=medAdvID_"!"_medAdvMasDataList_"!"_medAdvDrgItmList_"!"_medAdvContentList
	q ret
}

/// Descript:获取建议信息
ClassMethod getPHMedAdvInDetail(medAdvID As %String) As %String
{
	n (medAdvID,%session)
	s CH="",ret=""
	f  s CH=$o(^DHCPHAD(medAdvID,"AD",CH)) q:CH=""  d
	.s medAdvuserID=$p(^DHCPHAD(medAdvID,"AD",CH),"^",1) //用户
	.s:medAdvuserID'="" medAdvuser=$p(^SSU("SSUSR",medAdvuserID),"^",2)
	.s medAdvDate=$p(^DHCPHAD(medAdvID,"AD",CH),"^",2) //日期
	.s:medAdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvDate)  ;$zd(medAdvDate,3)
	.s medAdvTime=$p(^DHCPHAD(medAdvID,"AD",CH),"^",3) //时间
	.s:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
	.s medAdvCon=$p(^DHCPHAD(medAdvID,"AD",CH),"^",4) //内容
	.s medAdvuser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medAdvuser)
	.s medAdvCon=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHAdvDetail","PHADAdvice","",medAdvCon)
	.i ret="" S ret=$g(medAdvuser)_"^"_medAdvDate_"^"_medAdvTime_"^"_medAdvCon_"^"_medAdvID_"_"_CH
	.e  s ret=ret_"||"_$g(medAdvuser)_"^"_medAdvDate_"^"_medAdvTime_"^"_medAdvCon_"^"_medAdvID_"_"_CH
	q ret
}

/// json
/// Descript:病人建议列表
/// w ##class(web.DHCSTPHCMADVICE).jsonPatMedAdvList("326")
ClassMethod jsonPatMedAdvList(EpisodeID As %String) As %String
{
	N (EpisodeID)
	Q:EpisodeID="" ""
	S ListData=""
	S medAdvID=""
	F  S medAdvID=$o(^DHCPHAD(0,"AdmDr",EpisodeID,medAdvID)) Q:medAdvID=""  D
	.S medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6)    //当前状态
	.Q:medAdvCurStatus'="10"
	.
	.i ListData="" S ListData=medAdvID
	.E  S ListData=ListData_"||"_medAdvID
	
	s ListTitle="medAdvIDList"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:病人基本信息
/// w ##class(web.DHCSTPHCMADVICE).jsonMedAdvPatAdmInfo()
ClassMethod jsonMedAdvPatAdmInfo(medAdvID As %String = "") As %String
{
	N (medAdvID)
	S EpisodeID=$p(^DHCPHAD(medAdvID),"^",1) //病人ADM
	d ##CLASS(web.DHCSTCNTANTIBACTERIAL).GetPatEssInfo("",EpisodeID)
	Q ""
}

/// Descript:获取医嘱信息
ClassMethod jsonMedAdvDrgItm(medAdvID As %String) As %String
{
	N (medAdvID)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	s Num=0
	S CH=""
	F  S CH=$o(^DHCPHAD(medAdvID,"AI",CH)) Q:CH=""  D
	.S oeori=$p(^DHCPHAD(medAdvID,"AI",CH),"^",1) //医嘱ID
 	.s ord=+oeori
 	.s chl=$p(oeori,"||",2)
 	.s priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .q:priDr=0 
    .s priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
 	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) //医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))  //医嘱名称
	.q:inci=""
	.;s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S inciDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s presc=$p(^OEORD(ord,"I",chl,1),"^",14)   //处方号
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	.s puomdr=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.
	.s qty=$p(^OEORD(ord,"I",chl,1),"^",12) //医嘱数量
	.s buomdr=+$p($g(^INCI(inci,1)),"^",10)
	.s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	.s uomdr=buomdr
	.i (qty#fac)=0 d
	..s qty=qty/fac   //数量
	..s uomdr=puomdr
	.s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	.;s dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1) //剂量
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(oeori)  //lbb  2019/7/3 同频次不同剂量,剂量串
    .s doseuom=""
	.s dosuomID=$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.i dosuomID'="" s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	.;s freq=""
	.;s freqdr=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    .;i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  //频率
    .s freqInfo=##class(PHA.COM.Order).OeoriFreq(oeori)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2)
    .s instru=""
    .s instrudr=$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .s:instrudr'="" instru=$p(^PHCIN(instrudr),"^",2)  //用法
    .s duration=""
    .s durationdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durationdr'=0 duration=$p(^PHCDU(durationdr),"^",1)  //用药疗程
	.s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)  //医生
	.s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  //剂型
	.i $F(form,$c(13)) s form=$p(form,$c(13))
	.s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	.s:spec'="" spec="["_spec_"]"
	.s orddate=$p(^OEORD(ord,"I",chl,3),"^",7)  //医嘱日期
    .s ordtime=$p(^OEORD(ord,"I",chl,1),"^",10) //医嘱时间
    .i orddate'="" s orddate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(orddate)  ;$zd(orddate,3)
    .i ordtime'="" s ordtime=$zt(ordtime,1)
    .s ordtime=orddate  //开单日期
	.
	.s ListData=priorty_"^"_inciDesc_"^"_form_"^"_spec_"^"_instru_"^"_dosage_doseuom_"^"_uomdesc_"^"_qty_"^"_freq_"^"_duration_"^"_presc_"^"_doctor_"^"_ordtime
	.
	.s Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMADVICE","jsonMedAdvDrgItm",pid,Num)=ListData
	.
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S Title="priorty^inciDesc^form^spec^instru^dosage^uomdesc^qty^freq^duration^presc^doctor^ordtime"
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMADVICE","jsonMedAdvDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMADVICE","jsonMedAdvDrgItm",pid,index)
	.S Num=Num+1
	.//Q:Num<StPage
	.//S:Num=EndPage quitflag=1
	.I Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取建议信息
ClassMethod jsonPHMedAdvInDet(medAdvID As %String) As %String
{
	n (medAdvID)
	s count = 0
	s ListTitle="medAdvuser^medAdvDate^medAdvTime^medAdvCon"
	w "["
	s CH=""
	f  s CH=$o(^DHCPHAD(medAdvID,"AD",CH)) q:CH=""  d
	.s medAdvuserID=$p(^DHCPHAD(medAdvID,"AD",CH),"^",1) //用户
	.s:medAdvuserID'="" medAdvuser=$p(^SSU("SSUSR",medAdvuserID),"^",2)
	.s medAdvDate=$p(^DHCPHAD(medAdvID,"AD",CH),"^",2) //日期
	.s:medAdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvDate)  ;$zd(medAdvDate,3)
	.s medAdvTime=$p(^DHCPHAD(medAdvID,"AD",CH),"^",3) //时间
	.s:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
	.s medAdvCon=$p(^DHCPHAD(medAdvID,"AD",CH),"^",4)  //内容
	.S ListData=medAdvuser_"^"_medAdvDate_"^"_medAdvTime_"^"_medAdvCon
	.S count = count+1
	.I count=1 d
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	w "]"
	
	q ""
}

/// Descript:检查病人是否存在用药建议
ClassMethod CheckPatIfExitMedAdv(EpisodeID As %String) As %String
{
	N (EpisodeID)
	Q:EpisodeID="" ""
	S quitflag=""
	S medAdvID=""
	F  S medAdvID=$o(^DHCPHAD(0,"AdmDr",EpisodeID,medAdvID)) Q:(medAdvID="")||(quitflag=1)  D
	.S medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6)    //当前状态
	.Q:medAdvCurStatus'="10"
	.s quitflag=1
	Q quitflag
}

}
