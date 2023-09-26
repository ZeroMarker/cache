Import SQLUser

/// Creator:    wangxuejian
/// CreateDate: 2016-12-15
/// Descript:   医学查房
Class web.DHCSTPHCMMedicalWardRound Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  183#218#1^1^1^^1^1^^^^^^^^^还好吧^你几年级^578^/photo/med_dailyWdRd_183^!!
/// rowid&input=16243032^28^70^70^70^120^300^10^12^10^12^12^12^12^12^^hello^21679!image!16149701||14,16149701||15
/// w ##class(web.DHCSTPHCMMedicalWardRound).SaveMedWdRdInfor("183","218","1^1^1^^1^1^^^^^^^^^还好吧^你几年级^578^/photo/med_dailyWdRd_183^!!")
/// w ##class(web.DHCSTPHCMMedicalWardRound).SaveMedWdRdInfor("","160","37^77^75^75^110^300^^^^^^^^^每日病情变化描述1111^治疗方案^^!!")
/// Descript:保存医学查房信息
ClassMethod SaveMedWdRdInfor(cliPatID As %String, CPAdmDr As %String, cpDataList As %String, InsFlag As %String) As %String
{
	n (cliPatID,CPAdmDr,cpDataList,InsFlag)
	s cpMasDataList=$p(cpDataList,"!",1) //查房主信息
	s cpPreComList=$p(cpDataList,"!",2)  //主诉
	s cpDrgItmList=$p(cpDataList,"!",3)  //药品
	Q:(InsFlag="D")&('$o(^DHCPHCP(0,"Adm",CPAdmDr,""))) "-1"   /// 首次查房未填写,日常查房不允许保存  bianshuai 2017-08-12
	s ret=0
	i cliPatID="" d
	.S ret=..Insert(CPAdmDr,cpMasDataList,cpPreComList,cpDrgItmList)
	e  d
	.S ret=..Update(cliPatID,CPAdmDr,cpMasDataList,cpPreComList,cpDrgItmList)
	q ret
}

/// Descript:医学查房
ClassMethod Insert(CPAdmDr, cpMasDataList, cpPreComList, cpDrgItmList) As %String
{
	N (CPAdmDr,cpMasDataList,cpPreComList,cpDrgItmList)
	s Err=0

	TS
	//查房主表
	s wardRoundID=..InsCliPathography(CPAdmDr,cpMasDataList)
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
	Q wardRoundID
}

/// Descript:每日病情记录表
ClassMethod Update(cliPatID, CPAdmDr, cpMasDataList, cpPreComList, cpDrgItmList) As %String
{
	N (cliPatID,CPAdmDr,cpMasDataList,cpPreComList,cpDrgItmList)
	s Err=0

	TS
	//查房主表
	s Err=..UpdCliPathography(cliPatID,CPAdmDr,cpMasDataList)
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
	q cliPatID
}

/// w ##class(web.DHCSTPHCMMedicalWardRound).InsCliPathography("4","37^77^75^75^110^300^^^^^^^^^啦^请吃^^")
/// Descript:插入查房信息
ClassMethod InsCliPathography(CPAdmDr As %String, cpMasDataList As %String) As %String
{
	N (CPAdmDr,cpMasDataList)
	
  //S CPAdmDr=$p(cpMasDataList,"^",1)     //病人Adm
	S CPTemper=$p(cpMasDataList,"^",1)    //体温
	S CPPulse=$p(cpMasDataList,"^",2)     //脉搏
	S CPBreathe=$p(cpMasDataList,"^",3)   //呼吸
	S CPHeartRate=$p(cpMasDataList,"^",4) //心率
	S CPBloodPre=$p(cpMasDataList,"^",5)  //血压
	S CPUPD=$p(cpMasDataList,"^",6)       //尿量
	S CPDouLunBrePho=$p(cpMasDataList,"^",7)    //双肺呼吸音
	S CPRale=$p(cpMasDataList,"^",8)            //啰音
	S CPArrhythmia=$p(cpMasDataList,"^",9)     //心律
	S CPPathMurmur=$p(cpMasDataList,"^",10)     //各瓣膜听诊区、病理性杂音
	S CPBelly=$p(cpMasDataList,"^",11)          //腹部
	S CPLivLieCos=$p(cpMasDataList,"^",12)      //肝脾肋下
	S CPPerPain=$p(cpMasDataList,"^",13)        //双肾区叩击痛
	S CPOedema=$p(cpMasDataList,"^",14)         //双下肢水肿
	S CPChaOfDisDesc=$p(cpMasDataList,"^",15)   //每日病情变化描述
	S CPGuidance=$p(cpMasDataList,"^",16)       //治疗方案
	S CPUserDr=$p(cpMasDataList,"^",17)         //记录人
	S CPIcd=$p(cpMasDataList,"^",18)         //记录诊断
	S CPPharSignPath=$p(cpMasDataList,"^",19) //签名路径
	S CPDate=+$H                             //记录日期
	S CPTime=$p($H,",",2)                    //记录时间	
	&SQL(Insert Into DHC_PHCliPathography(PHCP_Adm_Dr,PHCP_Temper,PHCP_Pulse,PHCP_Breathe,PHCP_HeartRate,PHCP_BloodPre,PHCP_UPD,PHCP_DouLunBrePho,PHCP_Rale,PHCP_Arrhythmia,
		PHCP_PathMurmur,PHCP_Belly,PHCP_LivLieCos,PHCP_PerPain,PHCP_Oedema,PHCP_ChaOfDisDesc,PHCP_Guidance,PHCP_User_Dr,PHCP_Date,PHCP_Time,PHCP_Icd,PHCP_PharSignPath) 
		Values(:CPAdmDr,:CPTemper,:CPPulse,:CPBreathe,:CPHeartRate,:CPBloodPre,:CPUPD,:CPDouLunBrePho,:CPRale,:CPArrhythmia,
		:CPPathMurmur,:CPBelly,:CPLivLieCos,:CPPerPain,:CPOedema,:CPChaOfDisDesc,:CPGuidance,:CPUserDr,:CPDate,:CPTime,:CPIcd,:CPPharSignPath))
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript:更新查房信息
/// w ##class(web.DHCSTPHCMMedicalWardRound).UpdCliPathography("183","","1^1^1^^1^1^^^^^^^^^还好吧^你几年级^578^^")
ClassMethod UpdCliPathography(cliPatID As %String, CPAdmDr As %String, cpMasDataList As %String) As %String
{
	b ;000
	N (cliPatID,CPAdmDr,cpMasDataList)
	//S CPAdmDr=$p(cpMasDataList,"^",1)     //病人Adm
	S CPTemper=$p(cpMasDataList,"^",1)     //体温
	b ;1122
	S CPPulse=$p(cpMasDataList,"^",2)     //脉搏
	S CPBreathe=$p(cpMasDataList,"^",3)   //呼吸
	S CPHeartRate=$p(cpMasDataList,"^",4) //心率
	S CPBloodPre=$p(cpMasDataList,"^",5)  //血压
	S CPUPD=$p(cpMasDataList,"^",6)       //尿量
	S CPDouLunBrePho=$p(cpMasDataList,"^",7)    //双肺呼吸音
	S CPRale=$p(cpMasDataList,"^",8)            //啰音
	S CPArrhythmia=$p(cpMasDataList,"^",9)     //心律
	S CPPathMurmur=$p(cpMasDataList,"^",10)     //各瓣膜听诊区、病理性杂音
	S CPBelly=$p(cpMasDataList,"^",11)          //腹部
	S CPLivLieCos=$p(cpMasDataList,"^",12)      //肝脾肋下
	S CPPerPain=$p(cpMasDataList,"^",13)        //双肾区叩击痛
	S CPOedema=$p(cpMasDataList,"^",14)         //双下肢水肿
	S CPChaOfDisDesc=$p(cpMasDataList,"^",15)   //每日病情变化描述
	S CPGuidance=$p(cpMasDataList,"^",16)       //指导意见
	S CPUserDr=$p(cpMasDataList,"^",17)         //记录人
	S CPPharSignPath=$p(cpMasDataList,"^",19) //签名路径
	b ;1111
	S CPDate=+$H                             //记录日期
	S CPTime=$p($H,",",2)                    //记录时期	
	&SQL(Update DHC_PHCliPathography Set PHCP_Adm_Dr=:CPAdmDr,PHCP_Temper=:CPTemper,PHCP_Pulse=:CPPulse,PHCP_Breathe=:CPBreathe,PHCP_HeartRate=:CPHeartRate,PHCP_BloodPre=:CPBloodPre,PHCP_UPD=:CPUPD,
		PHCP_DouLunBrePho=:CPDouLunBrePho,PHCP_Rale=:CPRale,PHCP_Arrhythmia=:CPArrhythmia,PHCP_PathMurmur=:CPPathMurmur,PHCP_Belly=:CPBelly,PHCP_LivLieCos=:CPLivLieCos,PHCP_PerPain=:CPPerPain,PHCP_Oedema=:CPOedema,
		PHCP_ChaOfDisDesc=:CPChaOfDisDesc,PHCP_Guidance=:CPGuidance,PHCP_User_Dr=:CPUserDr,PHCP_Date=:CPDate,PHCP_Time=:CPTime, PHCP_PharSignPath=:CPPharSignPath Where PHCP_RowID=:cliPatID) 
	q SQLCODE
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
	q SQLCODE
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

/// Creator:    wangxuejian
/// CreateDate: 2016-01-16
/// Descript:获取医学查房的历史记录(可以过滤掉首次查房的记录)
/// Table: DHC_PHCliPathography    100^1^651^2017-04-10^2017-05-10
/// w ##class(web.DHCSTPHCMMedicalWardRound).GetMedWdRdRecord("100","1","337","2017-04-10","2017-07-10")
ClassMethod GetMedWdRdRecord(rows, page, AdmDr, startDate, endDate) As %GlobalCharacterStream
{
	N (rows,page,AdmDr,startDate,endDate)
	s StPage = page, EndPage = rows
	S pid=..NewPid()
	d ..killTmpGlobal(pid)	
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s stdate=$zdh(startDate,3)
	s enddate=$zdh(endDate,3)	
	s PHCPRid=""
	s l=0
	f  s PHCPRid=$o(^DHCPHCP(0,"Adm",AdmDr,PHCPRid)) q:((PHCPRid="")||l>0)   d
	.s fPHCPRid=PHCPRid                         //取出是首次查房的那一条记录
	.s frecordDate=$p(^DHCPHCP(fPHCPRid),"^",19)          //记录日期 
	.s l=l+1
	s h=0
	s Num=0
	s PHCPRid=0
	s fdate=0
	f fdate=stdate:1:enddate d
	.f  s PHCPRid=$o(^DHCPHCP(0,"DateAdm",fdate,AdmDr,PHCPRid)) q:PHCPRid=""  d
	..s h=h+1
	..s UserDr=$p(^DHCPHCP(PHCPRid),"^",18)            //记录人
	..S:UserDr'="" User=$p(^SSU("SSUSR",UserDr),"^",2)
	..s recordDate=$p(^DHCPHCP(PHCPRid),"^",19)       //记录日期   
	..S:recordDate'="" recordDate=$zd(recordDate,3)
	..s recordTime=$p(^DHCPHCP(PHCPRid),"^",20) 
	..i PHCPRid'=fPHCPRid d               //过滤掉第一条记录，作为首次查房保留下来
	...s Num=Num+1                      
	...S ^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdRecord",pid,Num)=PHCPRid_"#"_recordDate_"#"_User	
	S Title="rowid#recordDate#user"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	S Count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdRecord",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdRecord",pid,index)
	.S Count=Count+1
	.Q:Count<StPage
	.S:Count=EndPage quitflag=1
	.I Count=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	d OutBinStream.Write("]")   //输出json结尾符
	d ..killTmpGlobal(pid)	
	D OutBinStream.OutputToDevice()
	q OutBinStream
}

/// Creator:    wangxuejian
/// CreateDate: 2016-01-21
/// Descript:获取病人医学查房的基本信息(日常查房信息）
/// Table: DHC_PHCliPathography
/// w ##class(web.DHCSTPHCMMedicalWardRound).GetMedWdRdDInfor(178)
ClassMethod GetMedWdRdDInfor(Rowid As %String) As %String
{
	n (Rowid)
	s PHCPRid=Rowid
	q:PHCPRid=""
	s Temperature=$p($g(^DHCPHCP(PHCPRid)),"^",2)     ;体温
	s Pulse=$p($g(^DHCPHCP(PHCPRid)),"^",3)            ;脉搏
	s Breath=$p($g(^DHCPHCP(PHCPRid)),"^",4)           ;呼吸
	//s Heartrate=$p($g(^DHCPHCP(PHCPRid)),"^",5)       ;心率
	s Bloodpre=$p($g(^DHCPHCP(PHCPRid)),"^",6)         ;血压
	s Urineamt=$p($g(^DHCPHCP(PHCPRid)),"^",7)         ;尿量
	s ChaOfDisDesc=$p($g(^DHCPHCP(PHCPRid)),"^",16)    ;主要病情变化
	s Guidance=$p($g(^DHCPHCP(PHCPRid)),"^",17)        ;治疗方案
	s SignPath=$p($g(^DHCPHCP(PHCPRid)),"^",22)        ;签名路径
	q Temperature_"#"_Pulse_"#"_Breath_"#"_Bloodpre_"#"_Urineamt_"#"_ChaOfDisDesc_"#"_Guidance_"#"_SignPath
}

/// CreateDate: 2016-02-05
/// Descript:获取医学查房数据,首次查房记录
/// input : 病人的adm
/// w ##class(web.DHCSTPHCMMedicalWardRound).GetMedWdRdFInfor("336","first")
ClassMethod GetMedWdRdFInfor(AdmDr As %String, curStatus As %String) As %GlobalCharacterStream
{
    N (AdmDr,curStatus)
	s StPage = 1, EndPage = 999
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	s OutBinStream=##Class(%GlobalCharacterStream).%New()	
	//首次查房记录,即只取第一条记录
	i curStatus="first"  d
	.s Num=0
	.i '$d(^DHCPHCP(0,"Adm",AdmDr)) d
	..s LifeSignData=..GetFMedWdInfor(AdmDr)          ;生命体征
	..s Urineamt=$p(LifeSignData,"^",1)               ;尿量
	..s Temperature=$p(LifeSignData,"^",2)            ;体温
	..s Pulse=$p(LifeSignData,"^",3)                  ;脉搏
	..s Breath=$p(LifeSignData,"^",4)                 ;呼吸
	..s Bloodpre=$p(LifeSignData,"^",5)               ;血压
	..s DouLunBrePho="",Rale="",Arrhythmia="",PathMurmur="",Belly="",LivLieCos="",PerPain="",Oedema=""
	..s ChaOfDisDesc="",Guidance="",UserDr="",Icd="",SignPath="",PCDesc=0
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdFInfor",pid,Num)=$g(PHCPRid)_"#"_Urineamt_"#"_Temperature_"#"_Pulse_"#"_Breath_"#"_Bloodpre_"#"_DouLunBrePho_"#"_Rale_"#"_Arrhythmia_"#"_PathMurmur_"#"_Belly_"#"_LivLieCos_"#"_PerPain_"#"_Oedema_"#"_Guidance_"#"_ChaOfDisDesc_"#"_UserDr_"#"_SignPath
	.e  d
	..s PHCPRid=""
	..f  s PHCPRid=$o(^DHCPHCP(0,"Adm",AdmDr,PHCPRid)) q:((PHCPRid="")||(Num>0))  d
	...//s LifeSignData=..GetFMedWdInfor(AdmDr)          ;生命体征
	...//s Urineamt=$p(LifeSignData,"^",1)               ;尿量
	...//s Temperature=$p(LifeSignData,"^",2)            ;体温
	...//s Pulse=$p(LifeSignData,"^",3)                  ;脉搏
	...//s Breath=$p(LifeSignData,"^",4)                 ;呼吸
	...//s Bloodpre=$p(LifeSignData,"^",5)               ;血压
	...s Temperature=$p($g(^DHCPHCP(PHCPRid)),"^",2)     ;体温  /// 修改 2017-08-12 bianshuai
	...s Pulse=$p($g(^DHCPHCP(PHCPRid)),"^",3)           ;脉搏
	...s Breath=$p($g(^DHCPHCP(PHCPRid)),"^",4)          ;呼吸
	...s Bloodpre=$p($g(^DHCPHCP(PHCPRid)),"^",6)        ;血压
	...s Urineamt=$p($g(^DHCPHCP(PHCPRid)),"^",7)        ;尿量
	...s DouLunBrePho=$p(^DHCPHCP(PHCPRid),"^",8)     ;双肺呼吸音
	...s Rale=$p(^DHCPHCP(PHCPRid),"^",9)             ;啰音
	...s Arrhythmia=$p(^DHCPHCP(PHCPRid),"^",10)      ;心律
	...s PathMurmur=$p(^DHCPHCP(PHCPRid),"^",11)      ;各瓣膜听诊区、病理性杂音
	...s Belly=$p(^DHCPHCP(PHCPRid),"^",12)           ;腹部
	...s LivLieCos=$p(^DHCPHCP(PHCPRid),"^",13)       ;肝脾肋下
	...s PerPain=$p(^DHCPHCP(PHCPRid),"^",14)         ;双肾区叩击痛
	...s Oedema=$p(^DHCPHCP(PHCPRid),"^",15)          ;双下肢水肿
	...s ChaOfDisDesc=$p(^DHCPHCP(PHCPRid),"^",16)    ;主要病情变化
	...s Guidance=$p(^DHCPHCP(PHCPRid),"^",17)        ;指导内容
	...s UserDr=$p(^DHCPHCP(PHCPRid),"^",18)          ;记录人
	...s Icd=$p(^DHCPHCP(PHCPRid),"^",21)            ;具体诊断描述
	...s SignPath=$p(^DHCPHCP(PHCPRid),"^",22)       ;签名的路径
	...s PCDesc=0
	...s Num=Num+1
	...S ^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdFInfor",pid,Num)=PHCPRid_"#"_Urineamt_"#"_Temperature_"#"_Pulse_"#"_Breath_"#"_Bloodpre_"#"_DouLunBrePho_"#"_Rale_"#"_Arrhythmia_"#"_PathMurmur_"#"_Belly_"#"_LivLieCos_"#"_PerPain_"#"_Oedema_"#"_Guidance_"#"_ChaOfDisDesc_"#"_UserDr_"#"_SignPath
	S Title="PHCPRid#Urineamt#Temperature#Pulse#Breath#Bloodpre#DouLunBrePho#Rale#Arrhythmia#PathMurmur#Belly#LivLieCos#PerPain#Oedema#Guidance#ChaOfDisDesc#UserDr#SignPath"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	S count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdFInfor",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdFInfor",pid,index)
	.S count=count+1
	.q:count<StPage
	.S:count=EndPage quitflag=1
	.I count=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	d OutBinStream.Write("]")   //输出json结尾符
	
	d ..killTmpGlobal(pid)
	
	//D OutBinStream.OutputToDevice()
	q OutBinStream
}

/// Creator:wangxuejian
/// CreatDate:2017-05-11
/// Description:从电子病历中取病人的生命体征
/// return: 尿量 体温 脉搏 呼吸 血压 
/// other:w ##class(web.DHCSTPHCMMedicalWardRound).GetFMedWdInfor("651")
ClassMethod GetFMedWdInfor(EpisodeID As %String) As %String
{
	s firstLifeInfo=##class(web.DHCTHREEE).GetFirstData(EpisodeID)	//护理病历中取生命体征（尿量）
	s Urineamt=$p(firstLifeInfo,"^",6)	//尿量
	Set obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.13")
	s Temperature=obj.GetAt("HDSD00.13.303")	//体温
	s Pulse=obj.GetAt("HDSD00.13.080")  	//脉搏
	s Breath=obj.GetAt("HDSD00.13.077") 	//呼吸
	s DiastolicPre=obj.GetAt("HDSD00.13.085") 	//收缩压 大 
	s ShrinkPre=obj.GetAt("HDSD00.13.086") 		// 舒张压 小
	s Bloodpre=DiastolicPre_"/"_ShrinkPre	//血压	
	s LifeSignData=Urineamt_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_Bloodpre
	q LifeSignData
}

/// Creator:    wangxuejian
/// CreateDate: 2016-02-05
/// Descript:首次查房获取病人的诊断和主诉(电子病历获取）
/// input : 病人的adm
/// w ##class(web.DHCSTPHCMMedicalWardRound).GetCompDiagnose("336")
ClassMethod GetCompDiagnose(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s (patdiag,patPriActDesc,Guidance,listData)=""
	s patdiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	s patPriActDesc=##class(web.DHCSTPHCMCOMMON).getPatPriAct(EpisodeID) //主诉
	s Guidance=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(EpisodeID,"HDSD00.14.122","0") //qunianpeng 2017/12/5增加诊疗计划			
	s listData=$g(patdiag)_"#"_$g(patPriActDesc)_"#"_$g(Guidance)
	q listData
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	q $i(^DHCST("PHCMMedicalWardRound"))
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
    
    n (pid)
	k ^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdRecord")
	k ^TMP("DHCST","web.DHCSTPHCMMedicalWardRound","GetMedWdRdFInfor")
	q ""
}

}
