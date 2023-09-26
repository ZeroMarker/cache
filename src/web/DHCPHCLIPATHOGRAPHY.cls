Import SQLUser

/// Creator:    bianshuai
/// CreateDate: 2014-11-27
/// Descript:   医学查房
Class web.DHCPHCLIPATHOGRAPHY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// rowid&input=16243032^28^70^70^70^120^300^10^12^10^12^12^12^12^12^^hello^21679!image!16149701||14,16149701||15
/// w ##class(web.DHCPHCLIPATHOGRAPHY).SaveCliPathography("34","1609^37^75^75^75^110^300^10^10^11^10^10^11^10^11^^请吃药^578^1.胆总管结石!fdbms!")
/// Descript:医学查房
ClassMethod SaveCliPathography(cliPatID As %String, cpDataList As %String) As %String
{
	n (cliPatID,cpDataList)
	s cpMasDataList=$p(cpDataList,"!",1) //查房主信息
	s cpPreComList=$p(cpDataList,"!",2)  //主诉
	s cpDrgItmList=$p(cpDataList,"!",3)  //药品
	s ret=0
	i cliPatID="" d
	.S ret=..Insert(cpMasDataList,cpPreComList,cpDrgItmList)
	e  d
	.S ret=..Update(cliPatID,cpMasDataList,cpPreComList,cpDrgItmList)
	q ret
}

/// Descript:医学查房
ClassMethod Insert(cpMasDataList, cpPreComList, cpDrgItmList) As %String
{
	N (cpMasDataList,cpPreComList,cpDrgItmList)
	s Err=0

	TS
	//查房主表
	s wardRoundID=..InsCliPathography(cpMasDataList)
	i wardRoundID<0 tro
	q:wardRoundID<0 wardRoundID

	//主诉
	i cpPreComList'="" d
	.s Err=..InsCliPatPreCom(wardRoundID, cpPreComList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//关注药品
	i cpDrgItmList'="" d
	.s Err=..InsCliPatDrgItm(wardRoundID, cpDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:每日病情记录表
ClassMethod Update(cliPatID, cpMasDataList, cpPreComList, cpDrgItmList) As %String
{
	N (cliPatID,cpMasDataList,cpPreComList,cpDrgItmList)
	s Err=0

	TS
	//查房主表
	s Err=..UpdCliPathography(cliPatID,cpMasDataList)
	i Err<0 tro
	q:Err<0 "-10"

	//删除相关子表
	s Err=..DelCliPatRelaTable(cliPatID)
	i Err'=0 tro
	q:Err'=0 Err
	
	//主诉
	i cpPreComList'="" d
	.s Err=..InsCliPatPreCom(cliPatID, cpPreComList)   //sufan 2016/09/18
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//关注药品
	i cpDrgItmList'="" d
	.s Err=..InsCliPatDrgItm(cliPatID, cpDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:插入查房信息
ClassMethod InsCliPathography(cpMasDataList As %String) As %String
{
	N (cpMasDataList)
	S CPAdmDr=$p(cpMasDataList,"^",1)     //病人Adm
	S CPTemper=$p(cpMasDataList,"^",2)    //体温
	S CPPulse=$p(cpMasDataList,"^",3)     //脉搏
	S CPBreathe=$p(cpMasDataList,"^",4)   //呼吸
	S CPHeartRate=$p(cpMasDataList,"^",5) //心率
	S CPBloodPre=$p(cpMasDataList,"^",6)  //血压
	S CPUPD=$p(cpMasDataList,"^",7)       //尿量
	S CPDouLunBrePho=$p(cpMasDataList,"^",8)    //双肺呼吸音
	S CPRale=$p(cpMasDataList,"^",9)            //啰音
	S CPArrhythmia=$p(cpMasDataList,"^",10)     //心律
	S CPPathMurmur=$p(cpMasDataList,"^",11)     //各瓣膜听诊区、病理性杂音
	S CPBelly=$p(cpMasDataList,"^",12)          //腹部
	S CPLivLieCos=$p(cpMasDataList,"^",13)      //肝脾肋下
	S CPPerPain=$p(cpMasDataList,"^",14)        //双肾区叩击痛
	S CPOedema=$p(cpMasDataList,"^",15)         //双下肢水肿
	S CPChaOfDisDesc=$p(cpMasDataList,"^",16)   //每日病情变化描述
	S CPGuidance=$p(cpMasDataList,"^",17)       //指导意见
	S CPUserDr=$p(cpMasDataList,"^",18)         //记录人
	S CPIcd=$p(cpMasDataList,"^",19)         //记录人
	S CPDate=+$H                             //记录日期
	S CPTime=$p($H,",",2)                    //记录时间
	
	&SQL(Insert Into DHC_PHCliPathography(PHCP_Adm_Dr,PHCP_Temper,PHCP_Pulse,PHCP_Breathe,PHCP_HeartRate,PHCP_BloodPre,PHCP_UPD,PHCP_DouLunBrePho,PHCP_Rale,PHCP_Arrhythmia,
		PHCP_PathMurmur,PHCP_Belly,PHCP_LivLieCos,PHCP_PerPain,PHCP_Oedema,PHCP_ChaOfDisDesc,PHCP_Guidance,PHCP_User_Dr,PHCP_Date,PHCP_Time,PHCP_Icd) 
		Values(:CPAdmDr,:CPTemper,:CPPulse,:CPBreathe,:CPHeartRate,:CPBloodPre,:CPUPD,:CPDouLunBrePho,:CPRale,:CPArrhythmia,
		:CPPathMurmur,:CPBelly,:CPLivLieCos,:CPPerPain,:CPOedema,:CPChaOfDisDesc,:CPGuidance,:CPUserDr,:CPDate,:CPTime,:CPIcd))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新查房信息
/// w ##class(web.DHCPHCLIPATHOGRAPHY).UpdCliPathography("16","1609^37^80^80^80^120^22^10^10^10^10^10^10^10^10^^hello^21679")
ClassMethod UpdCliPathography(cliPatID As %String, cpMasDataList As %String) As %String
{
	N (cliPatID,cpMasDataList)
	S CPAdmDr=$p(cpMasDataList,"^",1)     //病人Adm
	S CPTemper=$p(cpMasDataList,"^",2)    //体温
	S CPPulse=$p(cpMasDataList,"^",3)     //脉搏
	S CPBreathe=$p(cpMasDataList,"^",4)   //呼吸
	S CPHeartRate=$p(cpMasDataList,"^",5) //心率
	S CPBloodPre=$p(cpMasDataList,"^",6)  //血压
	S CPUPD=$p(cpMasDataList,"^",7)       //尿量
	S CPDouLunBrePho=$p(cpMasDataList,"^",8)    //双肺呼吸音
	S CPRale=$p(cpMasDataList,"^",9)            //啰音
	S CPArrhythmia=$p(cpMasDataList,"^",10)     //心律
	S CPPathMurmur=$p(cpMasDataList,"^",11)     //各瓣膜听诊区、病理性杂音
	S CPBelly=$p(cpMasDataList,"^",12)          //腹部
	S CPLivLieCos=$p(cpMasDataList,"^",13)      //肝脾肋下
	S CPPerPain=$p(cpMasDataList,"^",14)        //双肾区叩击痛
	S CPOedema=$p(cpMasDataList,"^",15)         //双下肢水肿
	S CPChaOfDisDesc=$p(cpMasDataList,"^",16)   //每日病情变化描述
	S CPGuidance=$p(cpMasDataList,"^",17)       //指导意见
	S CPUserDr=$p(cpMasDataList,"^",18)         //记录人
	S CPDate=+$H                             //记录日期
	S CPTime=$p($H,",",2)                    //记录时间
	
	&SQL(Update DHC_PHCliPathography Set PHCP_Adm_Dr=:CPAdmDr,PHCP_Temper=:CPTemper,PHCP_Pulse=:CPPulse,PHCP_Breathe=:CPBreathe,PHCP_HeartRate=:CPHeartRate,PHCP_BloodPre=:CPBloodPre,PHCP_UPD=:CPUPD,
		PHCP_DouLunBrePho=:CPDouLunBrePho,PHCP_Rale=:CPRale,PHCP_Arrhythmia=:CPArrhythmia,PHCP_PathMurmur=:CPPathMurmur,PHCP_Belly=:CPBelly,PHCP_LivLieCos=:CPLivLieCos,PHCP_PerPain=:CPPerPain,PHCP_Oedema=:CPOedema,
		PHCP_ChaOfDisDesc=:CPChaOfDisDesc,PHCP_Guidance=:CPGuidance,PHCP_User_Dr=:CPUserDr,PHCP_Date=:CPDate,PHCP_Time=:CPTime Where PHCP_RowID=:cliPatID) 
	Q SQLCODE
}

/// Descript:保存主诉
ClassMethod InsCliPatPreCom(cliPatID As %String, cpPreComList As %String) As %String
{
	N (cliPatID,cpPreComList)
	S Len=$L(cpPreComList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S cpPreComList=$p(cpPreComList,"||",i)
	.;S ItemDesc=$p(cpPreCom,"^",1)    //指导意见
	.S ItemDesc=cpPreComList
	.S childSub=$o(^DHCPHCP(cliPatID,"PC",""),-1)+1
	.&SQL(Insert into DHC_PHCliPatPreCom(PHCPC_PHCP_Parref,PHCPC_ChildSub,PHCPC_Desc )
		Values(:cliPatID,:childSub,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除主诉
ClassMethod DelCliPatPreCom(cliPatID As %String) As %String
{
	N (cliPatID)
	&SQL(delete from DHC_PHCliPatPreCom where PHCPC_PHCP_Parref=:cliPatID)
	Q SQLCODE
}

/// Descript:保存关注药品
ClassMethod InsCliPatDrgItm(cliPatID As %String, cpDrgItmList As %String) As %String
{
	N (cliPatID,cpDrgItmList)
	S Len=$L(cpDrgItmList,",")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S cpDrgItm=$p(cpDrgItmList,",",i)
	.S oeoriDr=$p(cpDrgItm,"^",1)     //医嘱ID
	.S childSub=$o(^DHCPHCP(cliPatID,"DI",""),-1)+1
	.&SQL(Insert into DHC_PHCliPatDrgItm(PHCPDI_PHCP_Parref,PHCPDI_ChildSub,PHCPDI_OEORI_DR)
		Values(:cliPatID,:childSub,:oeoriDr))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除关注药品
ClassMethod DelCliPatDrgItm(cliPatID As %String) As %String
{
	N (cliPatID)
	&SQL(delete from DHC_PHCliPatDrgItm where PHCPDI_PHCP_Parref=:cliPatID)
	Q SQLCODE
}

/// Descript: 删除查房相关信息表
ClassMethod DelCliPatRelaTable(cliPatID As %String) As %String
{
	n (cliPatID)
		//主诉
	if $d(^DHCPHCP(cliPatID,"PPC",1)){  //sufan 2016/09/18
	&SQL(delete from DHC_PHCliPatPreCom where PHCPC_PHCP_Parref=:cliPatID) //liyarong 2016-09-30
	Q:SQLCODE'=0 SQLCODE
	}
	
	//关注药品
	if $d(^DHCPHCP(cliPatID,"DI",1)){ 
	&SQL(delete from DHC_PHCliPatDrgItm where PHCPDI_PHCP_Parref=:cliPatID) //liyarong 2016-09-30
	q:SQLCODE'=0 SQLCODE
	}
	q 0
}

/// Descript:获取医学查房数据,首次查房记录
/// w ##class(web.DHCPHCLIPATHOGRAPHY).getMedWardRound("137","First")
ClassMethod getMedWardRound(AdmDr As %String, curStatus As %String) As %String
{
	N (AdmDr,curStatus,%session)
	s StPage = 1, EndPage = 999
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
		
	//首次查房记录,即只取第一条记录
	i curStatus="First"  d
	.s Num=0
	.s PHCPRid=0
	.f  s PHCPRid=$o(^DHCPHCP(0,"Adm",AdmDr,PHCPRid)) q:((PHCPRid="")||(Num>1))  d
	..s Temperature=$p(^DHCPHCP(PHCPRid),"^",2)      ;体温
	..s Pulse=$p(^DHCPHCP(PHCPRid),"^",3)            ;脉搏
	..s Breath=$p(^DHCPHCP(PHCPRid),"^",4)           ;呼吸
	..s Heartrate=$p(^DHCPHCP(PHCPRid),"^",5)        ;心率
	..s Bloodpre=$p(^DHCPHCP(PHCPRid),"^",6)         ;血压
	..s Urineamt=$p(^DHCPHCP(PHCPRid),"^",7)         ;尿量
	..s DouLunBrePho=$p(^DHCPHCP(PHCPRid),"^",8)     ;双肺呼吸音
	..q:DouLunBrePho=""                              ;liubeibei 20180626 过滤掉非首次查房记录
	..s Rale=$p(^DHCPHCP(PHCPRid),"^",9)             ;啰音
	..s Arrhythmia=$p(^DHCPHCP(PHCPRid),"^",10)      ;心律
	..s PathMurmur=$p(^DHCPHCP(PHCPRid),"^",11)      ;各瓣膜听诊区、病理性杂音
	..s Belly=$p(^DHCPHCP(PHCPRid),"^",12)           ;腹部
	..s LivLieCos=$p(^DHCPHCP(PHCPRid),"^",13)       ;肝脾肋下
	..s PerPain=$p(^DHCPHCP(PHCPRid),"^",14)         ;双肾区叩击痛
	..s Oedema=$p(^DHCPHCP(PHCPRid),"^",15)          ;双下肢水肿
	..s ChaOfDisDesc=$p(^DHCPHCP(PHCPRid),"^",16)    ;主要病情变化
	..s Guidance=$p(^DHCPHCP(PHCPRid),"^",17)        ;指导内容
	..s UserDr=$p(^DHCPHCP(PHCPRid),"^",18)          ;记录人
	..s Icd=$p(^DHCPHCP(PHCPRid),"^",21)             ;具体诊断描述
	..s Num=Num+1
	..s ChaOfDisDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPChaOfDisDesc","",ChaOfDisDesc)
	..s Guidance=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPGuidance","",Guidance)
	..s Icd=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPIcd","",Icd)
	..S ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMedWardRound",pid,Num)=PHCPRid_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_Heartrate_"^"_Bloodpre_"^"_Urineamt_"^"_DouLunBrePho_"^"_Rale_"^"_Arrhythmia_"^"_PathMurmur_"^"_Belly_"^"_LivLieCos_"^"_PerPain_"^"_Oedema_"^"_Guidance_"^"_ChaOfDisDesc_"^"_UserDr_"^"_Icd

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="PHCPRid^Temperature^Pulse^Breath^Heartrate^Bloodpre^Urineamt^DouLunBrePho^Rale^Arrhythmia^PathMurmur^Belly^LivLieCos^PerPain^Oedema^Guidance^ChaOfDisDesc^UserDr^Icd"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMedWardRound",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMedWardRound",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	
	k ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMedWardRound")
	q ""
}

/// liubeibei20180626  查询首次查房记录id
/// Descript:获取医学查房数据,首次查房记录ID
/// w ##class(web.DHCPHCLIPATHOGRAPHY).getMedWardRoundID("137","First")
ClassMethod getMedWardRoundID(AdmDr As %String, curStatus As %String) As %String
{
	N (AdmDr,curStatus)
	s StPage = 1, EndPage = 999
	s data=0
	S pid=..NewPid()
	d ..killTmpGlobal(pid)	
	//首次查房记录,即只取第一条记录
	i curStatus="First"  d
	.s Num=0
	.s PHCPRid=0
	.s PHCPRid=$o(^DHCPHCP(0,"Adm",AdmDr,PHCPRid)) q:((PHCPRid="")||(Num>1))  d
	..s Num=Num+1
	..s data=PHCPRid	
	q data
}

/// Descript:获取医学查房数据
/// w ##class(web.DHCPHCLIPATHOGRAPHY).GetMedWardRecord("15","1","70","2018-06-25","2019-11-12")
ClassMethod GetMedWardRecord(rows, page, AdmDr, startDate, endDate) As %String
{
	N (rows,page,AdmDr,startDate,endDate,%session)
	//s StPage = page, EndPage = rows
	s EndPage=page*rows  		/// 结束行
	s StPage=((page-1)*rows)+1	/// 开始行
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	s stdate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(startDate) ;$zdh(startDate,3)
	s enddate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(endDate) ;$zdh(endDate,3)
		
	s h=0
    s Num=0
	s PHCPRid=0
	s fdate=0
	f fdate=stdate:1:enddate  d
	.f  s PHCPRid=$o(^DHCPHCP(0,"DateAdm",fdate,AdmDr,PHCPRid)) q:PHCPRid=""  d
	..s h=h+1
	..s Temperature=$p(^DHCPHCP(PHCPRid),"^",2)      ;体温
	..s Pulse=$p(^DHCPHCP(PHCPRid),"^",3)            ;脉搏
	..s Breath=$p(^DHCPHCP(PHCPRid),"^",4)           ;呼吸
	..s Heartrate=$p(^DHCPHCP(PHCPRid),"^",5)        ;心率
	..s Bloodpre=$p(^DHCPHCP(PHCPRid),"^",6)         ;血压
	..s Urineamt=$p(^DHCPHCP(PHCPRid),"^",7)         ;尿量
	..s DouLunBrePho=$p(^DHCPHCP(PHCPRid),"^",8)     ;双肺呼吸音
	..s Rale=$p(^DHCPHCP(PHCPRid),"^",9)             ;啰音
	..s Arrhythmia=$p(^DHCPHCP(PHCPRid),"^",10)      ;心律
	..s PathMurmur=$p(^DHCPHCP(PHCPRid),"^",11)      ;各瓣膜听诊区、病理性杂音
	..s Belly=$p(^DHCPHCP(PHCPRid),"^",12)           ;腹部
	..s LivLieCos=$p(^DHCPHCP(PHCPRid),"^",13)       ;肝脾肋下
	..s PerPain=$p(^DHCPHCP(PHCPRid),"^",14)         ;双肾区叩击痛
	..s Oedema=$p(^DHCPHCP(PHCPRid),"^",15)          ;双下肢水肿
	..s ChaOfDisDesc=$p(^DHCPHCP(PHCPRid),"^",16)    ;主要病情变化
	..s Guidance=$p(^DHCPHCP(PHCPRid),"^",17)        ;指导内容
	..s UserDr=$p(^DHCPHCP(PHCPRid),"^",18)          ;记录人
	..S:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..s recordDate=$p(^DHCPHCP(PHCPRid),"^",19) 
	..S:recordDate'="" recordDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(recordDate)  ;$zd(recordDate,3)
	..s recordTime=$p(^DHCPHCP(PHCPRid),"^",20) 
	..s Icd=$p(^DHCPHCP(PHCPRid),"^",21)             ;具体诊断描述
	..s ChaOfDisDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPChaOfDisDesc","",ChaOfDisDesc)
	..s Guidance=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPGuidance","",Guidance)
	..s User=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",User)
	..s Icd=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPIcd","",Icd)
	..s Num=Num+1
	..q:Num=1                                        ;liubeibei 20180626 过滤掉首次查房记录
	..S ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","GetMedWardRecord",pid,Num)=PHCPRid_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_Heartrate_"^"_Bloodpre_"^"_Urineamt_"^"_DouLunBrePho_"^"_Rale_"^"_Arrhythmia_"^"_PathMurmur_"^"_Belly_"^"_LivLieCos_"^"_PerPain_"^"_Oedema_"^"_Guidance_"^"_ChaOfDisDesc_"^"_UserDr_"^"_User_"^"_recordDate_"^"_Icd
    i Num>0  S Num=Num-1                                      ;总数减掉过滤的首次查房记录
	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="PHCPRid^Temperature^Pulse^Breath^Heartrate^Bloodpre^Urineamt^DouLunBrePho^Rale^Arrhythmia^PathMurmur^Belly^LivLieCos^PerPain^Oedema^Guidance^ChaOfDisDesc^UserDr^User^recordDate^Icd"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","GetMedWardRecord",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","GetMedWardRecord",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	
	k ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","GetMedWardRecord")
	q ""
}

/// Descript:医学查房关注药品
/// w ##class(web.DHCPHCLIPATHOGRAPHY).getMRDrgItm("5")
ClassMethod getMRDrgItm(cliPatID As %String, StPage = "1", EndPage = "999") As %String
{
	N (cliPatID,StPage,EndPage,%session)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s Num=0
	S CH="",ret=""  
	F  S CH=$o(^DHCPHCP(cliPatID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHCP(cliPatID,"DI",CH),"^",1)  //医嘱ID
	.S ord=+orditm
	.S chl=$p(orditm,"||",2)
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)     //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) //剂量
	.S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)    //剂量单位
	.S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  //OEORI_PHFreq_DR
    .S freq=$p($g(^PHCFR(freqdr)),"^",3)            //频率
    .S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2)        //用法
    .s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	.S duration=$p($g(^PHCDU(durId)),"^",1)         //用药疗程
	.S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s form=$p(^PHCF(formdr),"^",2) //剂型
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($p($g(^PHMNF(manfdr)),"^",2),"-",2)
	.S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm) //医生
	.S StartDate=+$p(^OEORD(ord,"I",chl,1),"^",9)   //开始日期
	.S:StartDate'="" StartDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(StartDate)  ;$zd(StartDate,3)
	.S Num=Num+1
	.s inciDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",inciDesc)
	.s freq=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCFreq","PHCFRDesc1","",freq)
	.s instru=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)
	.s duration=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCDuration","PHCDUCode","",duration)
	.s doctor=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",doctor)
	.s genenic=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCGeneric","PHCGEName","",genenic)
	.s form=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCForm","PHCFDesc","",form)
	.s manf=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHManufacturer","PHMNFName","",manf)
	.S ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMRDrgItm",pid,Num)=orditm_"^"_StartDate_"^"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_doctor_"^"_genenic_"^"_form_"^"_manf

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="orditm^StartDate^incidesc^Dosage^freq^Instance^duration^Doctor^genenic^form^manf"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMRDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMRDrgItm",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	
	k ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getMRDrgItm")
	q ""
}

/// Descript:获取医学查房主诉  //ChiefComplaint
/// w ##class(web.DHCPHCLIPATHOGRAPHY).getChiefComtItm("5")
ClassMethod getChiefComtItm(cliPatID As %String, StPage = "1", EndPage = "999") As %String
{
	N (cliPatID,StPage,EndPage,%session)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s Num=0
	S CH="",ret=""  
	F  S CH=$o(^DHCPHCP(cliPatID,"PPC",CH)) Q:CH=""  D
	.S preComText=$p(^DHCPHCP(cliPatID,"PPC",CH),"^",1)  //主诉
	.s preComText=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPatPreCom","PHCPCDesc","",preComText)
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getChiefComtItm",pid,Num)=preComText

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="preComText"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getChiefComtItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getChiefComtItm",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	
	k ^TMP("DHCST","web.DHCPHCLIPATHOGRAPHY","getChiefComtItm")
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMMEDEDUCATION"))
}

/// Descript:获取医学查房数据
/// w ##class(web.DHCPHCLIPATHOGRAPHY).GetMedWardRecordByPHCPRid()
ClassMethod GetMedWardRecordByPHCPRid(PHCPRid As %String) As %String
{
    N (PHCPRid)
	s Temperature=$p(^DHCPHCP(PHCPRid),"^",2)      ;体温
	s Pulse=$p(^DHCPHCP(PHCPRid),"^",3)            ;脉搏
	s Breath=$p(^DHCPHCP(PHCPRid),"^",4)           ;呼吸
	s Heartrate=$p(^DHCPHCP(PHCPRid),"^",5)        ;心率
	s Bloodpre=$p(^DHCPHCP(PHCPRid),"^",6)         ;血压
	s Urineamt=$p(^DHCPHCP(PHCPRid),"^",7)         ;尿量
	s DouLunBrePho=$p(^DHCPHCP(PHCPRid),"^",8)     ;双肺呼吸音
	s Rale=$p(^DHCPHCP(PHCPRid),"^",9)             ;啰音
	s Arrhythmia=$p(^DHCPHCP(PHCPRid),"^",10)      ;心律
	s PathMurmur=$p(^DHCPHCP(PHCPRid),"^",11)      ;各瓣膜听诊区、病理性杂音
	s Belly=$p(^DHCPHCP(PHCPRid),"^",12)           ;腹部
	s LivLieCos=$p(^DHCPHCP(PHCPRid),"^",13)       ;肝脾肋下
	s PerPain=$p(^DHCPHCP(PHCPRid),"^",14)         ;双肾区叩击痛
	s Oedema=$p(^DHCPHCP(PHCPRid),"^",15)          ;双下肢水肿
	s ChaOfDisDesc=$p(^DHCPHCP(PHCPRid),"^",16)    ;主要病情变化
	s Guidance=$p(^DHCPHCP(PHCPRid),"^",17)        ;指导内容
	s UserDr=$p(^DHCPHCP(PHCPRid),"^",18)          ;记录人
	S:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	s recordDate=$p(^DHCPHCP(PHCPRid),"^",19) 
	S:recordDate'="" recordDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(recordDate)  ;$zd(recordDate,3)
	s recordTime=$p(^DHCPHCP(PHCPRid),"^",20) 
	s Icd=$p(^DHCPHCP(PHCPRid),"^",21)             ;具体诊断描述
    s ret=Temperature_"^"_Pulse_"^"_Breath_"^"_Heartrate_"^"_Bloodpre_"^"_Urineamt_"^"_DouLunBrePho_"^"_Rale_"^"_Arrhythmia_"^"_PathMurmur_"^"_Belly_"^"_LivLieCos_"^"_PerPain_"^"_Oedema_"^"_Guidance_"^"_ChaOfDisDesc_"^"_UserDr_"^"_User_"^"_recordDate_"^"_Icd
    q ret
}

/// Descript:获取医学查房主诉 
/// w ##class(web.DHCPHCLIPATHOGRAPHY).getChiefComt("5")
ClassMethod getChiefComt(cliPatID As %String) As %String
{
	N (cliPatID)
	S CH="",ret=""  
	F  S CH=$o(^DHCPHCP(cliPatID,"PPC",CH)) Q:CH=""  D
	.S preComText=$p(^DHCPHCP(cliPatID,"PPC",CH),"^",1)  //主诉
	.if ret="" s ret=preComText
	.else  s ret=ret_";"_preComText
	q ret
}

/// Creator: Huxt 2019-12-14
/// Desc: 医学查房获取打印数据
/// Input: PHCPRid, adm
/// Output: json
/// w ##class(web.DHCPHCLIPATHOGRAPHY).GetMedWardRecordPrint(3,18)
ClassMethod GetMedWardRecordPrint(PHCPRid, adm)
{
	n (PHCPRid, adm)
	//get data
	s Temperature = $p(^DHCPHCP(PHCPRid),"^",2)      ;体温
	s Pulse = $p(^DHCPHCP(PHCPRid),"^",3)            ;脉搏
	s Breath = $p(^DHCPHCP(PHCPRid),"^",4)           ;呼吸
	s Heartrate = $p(^DHCPHCP(PHCPRid),"^",5)        ;心率
	s Bloodpre = $p(^DHCPHCP(PHCPRid),"^",6)         ;血压
	s Urineamt = $p(^DHCPHCP(PHCPRid),"^",7)         ;尿量
	s DouLunBrePho = $p(^DHCPHCP(PHCPRid),"^",8)     ;双肺呼吸音
	s Rale = $p(^DHCPHCP(PHCPRid),"^",9)             ;啰音
	s Arrhythmia = $p(^DHCPHCP(PHCPRid),"^",10)      ;心律
	s PathMurmur = $p(^DHCPHCP(PHCPRid),"^",11)      ;各瓣膜听诊区、病理性杂音
	s Belly = $p(^DHCPHCP(PHCPRid),"^",12)           ;腹部
	s LivLieCos = $p(^DHCPHCP(PHCPRid),"^",13)       ;肝脾肋下
	s PerPain = $p(^DHCPHCP(PHCPRid),"^",14)         ;双肾区叩击痛
	s Oedema = $p(^DHCPHCP(PHCPRid),"^",15)          ;双下肢水肿
	s ChaOfDisDesc = $p(^DHCPHCP(PHCPRid),"^",16)    ;主要病情变化
	s Guidance = $p(^DHCPHCP(PHCPRid),"^",17)        ;指导内容
	s UserDr = $p(^DHCPHCP(PHCPRid),"^",18)          ;记录人
	S:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	s recordDate=$p(^DHCPHCP(PHCPRid),"^",19) 
	S:recordDate'="" recordDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(recordDate)
	s recordTime=$p(^DHCPHCP(PHCPRid),"^",20) 
	s Icd = $p(^DHCPHCP(PHCPRid),"^",21)             ;具体诊断描述
	s ChiefComt = ..getChiefComt(PHCPRid) 			 ;主诉
	s patInfo = ##class(web.DHCSTPHCMCOMMON).GetPatInfo(adm) ;患者信息
	//超长字符串处理
	s ChaOfDisDesc = ##class(PHA.COM.Print).SplitStr(ChaOfDisDesc,80,4)
	s Guidance = ##class(PHA.COM.Print).SplitStr(Guidance,80,4)
	s Icd = ##class(PHA.COM.Print).SplitStr(Icd,80,4)
	s ChiefComt = ##class(PHA.COM.Print).SplitStr(ChiefComt,80,4)
	//json
	s Para = {}
	s Para.patNo = $p(patInfo,"^",1)
	s Para.patName = $p(patInfo,"^",2)
	s Para.patSex = $p(patInfo,"^",3)
	s Para.patAge = $p(patInfo,"^",4)
	s Para.bedNo = $p(patInfo,"^",5)
	s Para.feeType = $p(patInfo,"^",7)
	s Para.tempt = Temperature
	s Para.pulse = Pulse
	s Para.breath = Breath
	s Para.UrineVol = Urineamt
	s Para.bloodPres = Bloodpre
	s Para.heartRate = Heartrate
	s Para.date = recordDate
	s Para.TreatmentPlan1 = $p(Guidance,"^",1)
	s Para.TreatmentPlan2 = $p(Guidance,"^",2)
	s Para.TreatmentPlan3 = $p(Guidance,"^",3)
	s Para.TreatmentPlan4 = $p(Guidance,"^",4)
	s Para.TreatmentPlan5 = $p(Guidance,"^",5)
	s Para.TreatmentPlan6 = $p(Guidance,"^",6)
	s Para.Diagnosis1 = $p(Icd,"^",1)
	s Para.Diagnosis2 = $p(Icd,"^",2)
	s Para.Diagnosis3 = $p(Icd,"^",3)
	s Para.Diagnosis4 = $p(Icd,"^",4)
	s Para.ChiefComp1 = $p(ChiefComt,"^",1)
	s Para.ChiefComp2 = $p(ChiefComt,"^",2)
	s Para.ChiefComp3 = $p(ChiefComt,"^",3)
	s Para.ChiefComp4 = $p(ChiefComt,"^",4)
	s Para.Change1 = $p(ChaOfDisDesc,"^",1)
	s Para.Change2 = $p(ChaOfDisDesc,"^",2)
	s Para.Change3 = $p(ChaOfDisDesc,"^",3)
	s Para.Change4 = $p(ChaOfDisDesc,"^",4)
	s Para.Change5 = $p(ChaOfDisDesc,"^",5)
	s Para.Change6 = $p(ChaOfDisDesc,"^",6)
	s:DouLunBrePho=10 Para.f11 = "√"
	s:DouLunBrePho=11 Para.f12 = "√"
	s:Rale=10 Para.f13 = "√"
	s:Rale=11 Para.f14 = "√"
	s:Rale=12 Para.f15 = "√"
	s:Rale=13 Para.f16 = "√"
	s:Arrhythmia=10 Para.f21 = "√"
	s:Arrhythmia=11 Para.f22 = "√"
	s:PathMurmur=10 Para.f23 = "√"
	s:PathMurmur=11 Para.f24 = "√"
	s:Belly=10 Para.f31 = "√"
	s:Belly=11 Para.f32 = "√"
	s:LivLieCos=10 Para.f33 = "√"
	s:LivLieCos=11 Para.f34 = "√"
	s:PerPain=10 Para.f41 = "√"
	s:PerPain=11 Para.f42 = "√"
	s:Oedema=10 Para.f43 = "√"
	s:Oedema=11 Para.f44 = "√"
	s:Oedema=12 Para.f45 = "√"
	s:Oedema=13 Para.f46 = "√"
	s retJson = {}
	s retJson.Para = Para
	s retJson.List = []
	q retJson.%ToJSON()
}

/// Desc: 医学查房获取表id串
/// Creator: pushuangcai
/// Input: adm
/// Output: string
/// w ##class(web.DHCPHCLIPATHOGRAPHY).GetPhcpIdStr(18)
ClassMethod GetPhcpIdStr(admId)
{
	n (admId)
	q:admId="" ""
	s retStr=""
	s phcpId=""
	f  s phcpId=$o(^DHCPHCP(0,"Adm",admId,phcpId)) q:phcpId=""  d
	.i retStr="" s retStr=phcpId
	.e  s retStr=retStr_"^"_phcpId
	q retStr
}

}
