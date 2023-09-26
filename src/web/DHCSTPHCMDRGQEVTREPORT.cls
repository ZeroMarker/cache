Import sqluser

/// Descript:药品质量事件报告业务类
Class web.DHCSTPHCMDRGQEVTREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存/更新
/// web.DHCSTPHCMDRGQEVTREPORT
ClassMethod SaveDrgQEvtReport(dqEvtRepID As %String, dqEvtRepList As %String, dqEvtRepDrgItmList As %String, dqEvtRepTriFacList As %String) As %String
{
	N (dqEvtRepID,dqEvtRepList,dqEvtRepDrgItmList,dqEvtRepTriFacList)
	s ret=0
	i dqEvtRepID="" d
	.S ret=..Insert(dqEvtRepList,dqEvtRepDrgItmList,dqEvtRepTriFacList)
	e  d
	.S ret=..Update(dqEvtRepID,dqEvtRepList,dqEvtRepDrgItmList,dqEvtRepTriFacList)
	;q ret
	q ##class(web.DHCSTPHCMCOMMON).getJsonData("ErrCode^dqEvtRepID",ret)  ;qunianpeng 2016-09-23
}

/// Descript:插入质量事件报告
/// w ##class(web.DHCSTPHCMDRGQEVTREPORT).Insert("197^22/06/2018^290^马亭（演示勿动）^1^56^14/12/1961^0000000290^110^22/06/2018^22/06/2018^B^10^^10^^Y^^20/06/2018^11:53:33^^on^^N^N^^^dd^^663^dd^^N","293||13^1330||1^精蛋白锌重组人胰岛素笔芯(优泌林70/30笔芯)[300IU]^1062^32^620^300IU^^^^","10")
ClassMethod Insert(dqEvtRepList As %String, dqEvtRepDrgItmList As %String, dqEvtRepTriFacList As %String) As %String
{
	N (dqEvtRepList,dqEvtRepDrgItmList,dqEvtRepTriFacList)
	s ^qunianpeng(1)=$lb(dqEvtRepList,dqEvtRepDrgItmList,dqEvtRepTriFacList)
	s Err=0
	TS
	s dqEvtRepID=..InsDrgQEvtReport(dqEvtRepList)
	i dqEvtRepID<0 tro
	q:dqEvtRepID<0 dqEvtRepID
	
	//保存药品质量事件报告诱发事件因素
	i dqEvtRepTriFacList'="" d
	.s Err=..InsDQEvtRepTriFac(dqEvtRepID,dqEvtRepTriFacList)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//保存药品质量事件报告相关药品信息
	i dqEvtRepDrgItmList'="" d
	.s Err=..InsDQEvtRepDrgItm(dqEvtRepID,dqEvtRepDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	/*
	//不良反应报告审批流程[默认插入初始状态]
	s Err=..InsAdrRepImpInfo(dqEvtRepID,"")
	i Err'=0 tro
	q:Err'=0 "-17"
	*/
	TC
	Q "0^"_dqEvtRepID	  //qunianpeng 2016-09-23
}

/// Descript:更新质量事件报告
ClassMethod Update(dqEvtRepID As %String, dqEvtRepList As %String, dqEvtRepDrgItmList As %String, dqEvtRepTriFacList As %String) As %String
{
	N (dqEvtRepID,dqEvtRepList,dqEvtRepDrgItmList,dqEvtRepTriFacList)
	s Err=0
	TS
	s dqEvtRepID=..UpdDrgQEvtReport(dqEvtRepID,dqEvtRepList)
	i dqEvtRepID<0 tro
	q:dqEvtRepID<0 dqEvtRepID
	
	//保存药品质量事件报告诱发事件因素
	s Err=..delDQEvtRepTriFac(dqEvtRepID)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	i dqEvtRepTriFacList'="" d
	.s Err=..InsDQEvtRepTriFac(dqEvtRepID,dqEvtRepTriFacList)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	//保存药品质量事件报告相关药品信息
	s Err=..delDQEvtRepDrgItm(dqEvtRepID)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	i dqEvtRepDrgItmList'="" d
	.s Err=..InsDQEvtRepDrgItm(dqEvtRepID,dqEvtRepDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	/*
	//不良反应报告审批流程[默认插入初始状态]
	s Err=..InsAdrRepImpInfo(dqEvtRepID,"")
	i Err'=0 tro
	q:Err'=0 "-17"
	*/
	TC
	Q "0^"_dqEvtRepID		//qunianpeng 2016-09-23
}

/// Descript:保存药品质量报告主表
ClassMethod InsDrgQEvtReport(drgqevtlist As %String) As %String
{
	N (drgqevtlist)
	s ^qunianpeng=drgqevtlist
	S RepLocDr=$p(drgqevtlist,"^",1) //报告科室
	S RepDate=$p(drgqevtlist,"^",2)  //报告日期
	S:RepDate'="" RepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(RepDate) ;$zdh(RepDate,3)
	S PatID=$p(drgqevtlist,"^",3)  //病人ID
	S PatName=$p(drgqevtlist,"^",4) //姓名
	S PatSex=$p(drgqevtlist,"^",5)  //性别

	S PatAge=$p(drgqevtlist,"^",6)  //年龄
	S PatDOB=$p(drgqevtlist,"^",7)  //出生日期
	S:PatDOB'="" PatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(PatDOB) ;$zdh(PatDOB,3)
	S PatMedNo=$p(drgqevtlist,"^",8) //住院号或门诊就诊号
	S AdmLocDr=$p(drgqevtlist,"^",9) //就诊科室
	S EvtOccDate=$p(drgqevtlist,"^",10) //发生时间
	S:EvtOccDate'="" EvtOccDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EvtOccDate) ;$zdh(EvtOccDate,3)
	
	S DisEvtDate=$p(drgqevtlist,"^",11) //发现时间
	S:DisEvtDate'="" DisEvtDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DisEvtDate) ;$zdh(DisEvtDate,3)
	S EvtLevel=$p(drgqevtlist,"^",12)   //错误分级
	S OccLoc=$p(drgqevtlist,"^",13)     //发生科室
	S OccLocDesc=$p(drgqevtlist,"^",14) //发生科室描述
	S RelateInfo=$p(drgqevtlist,"^",15) //相关资相关料
	
	S RelateInfoDesc=$p(drgqevtlist,"^",16) //相关资料描述
	S Death=$p(drgqevtlist,"^",17) //死亡
	S ImCauseOfDeath=$p(drgqevtlist,"^",18) //直接死因
	S DeathDate=$p(drgqevtlist,"^",19) //死亡日期
	S:DeathDate'="" DeathDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DeathDate) ;$zdh(DeathDate,3)
	S DeathTime=$p(drgqevtlist,"^",20) //死亡时间
	S:DeathTime'="" DeathTime=$zth(DeathTime,1)

	S RecProc=$p(drgqevtlist,"^",21) 	 //恢复过程
	S HarmLevel=$p(drgqevtlist,"^",22)   //伤害程度
	S HarmDesc=$p(drgqevtlist,"^",23)    //伤害程度描述
	S ExtHospTime=$p(drgqevtlist,"^",24) //住院是否延长
	S CriticallyIll=$p(drgqevtlist,"^",25) //是否生命垂危
	S CriIllReport=$p(drgqevtlist,"^",26)  //生命垂危报告
	
	S GeneProc=$p(drgqevtlist,"^",27)     //发生经过
	S HandleInfo=$p(drgqevtlist,"^",28)   //处理情形
	S ImproMeasure=$p(drgqevtlist,"^",29) //改进措施
	S Reporter=$p(drgqevtlist,"^",30)  //报告人
	S PriOfRepLoc=$p(drgqevtlist,"^",31) //报告科室负责人
	;S RepCode=$p(drgqevtlist,"^",32) //报告编码
	s CurStatusDr=$p(drgqevtlist,"^",33)  //当前状态   liyarong 2016-09-26
	S HospID=$p(^CTLOC(RepLocDr),"^",22)			//保存时生成编码  qunianpeng 2016-09-23
	S HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	S Prefix=HospitalCode_"DQE"_$zd(+$H,8) 
	S RepCode=..GetReportCurMaxNo(Prefix,"3")
	
	&SQL(Insert Into DHC_PHDrgQuaEvtReport(DQER_RepLoc_Dr,DQER_Date,DQER_PatID,DQER_PatName,DQER_PatSex,
		DQER_PatAge,DQER_PatDOB,DQER_PatMedNo,DQER_AdmLoc_Dr,DQER_EvtOccDate,DQER_DisEvtDate,DQER_EvtLevel,
		DQER_OccLocation,DQER_OccLocDesc,DQER_RelateInfo,DQER_RelateInfoDesc,DQER_Death,DQER_ImCauseOfDeath,
		DQER_DeathDate,DQER_DeathTime,DQER_RecProc,DQER_HarmLevel,DQER_HarmDesc,DQER_ExtHospTime,DQER_CriticallyIll,
		DQER_CriIllReport,DQER_GeneProc,DQER_HandleInfo,DQER_ImproMeasure,DQER_Reporter,DQER_PriOfRepLoc,DQER_RepCode,DQER_CurStatus_DR)
		Values(:RepLocDr,:RepDate,:PatID,:PatName,:PatSex,:PatAge,:PatDOB,:PatMedNo,:AdmLocDr,:EvtOccDate,
			:DisEvtDate,:EvtLevel,:OccLoc,:OccLocDesc,:RelateInfo,:RelateInfoDesc,:Death,:ImCauseOfDeath,
			:DeathDate,:DeathTime,:RecProc,:HarmLevel,:HarmDesc,:ExtHospTime,:CriticallyIll,:CriIllReport,
			:GeneProc,:HandleInfo,:ImproMeasure,:Reporter,:PriOfRepLoc,:RepCode,:CurStatusDr
		))

	Q +%ROWID
}

/// Descript:保存药品质量报告主表
ClassMethod UpdDrgQEvtReport(dqEvtRepID As %String, drgqevtlist As %String) As %String
{
	N (dqEvtRepID,drgqevtlist)
	S RepLocDr=$p(drgqevtlist,"^",1) //报告科室
	S RepDate=$p(drgqevtlist,"^",2)  //报告日期
	S:RepDate'="" RepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(RepDate) ;$zdh(RepDate,3)
	S PatID=$p(drgqevtlist,"^",3)  //病人ID
	S PatName=$p(drgqevtlist,"^",4) //姓名
	S PatSex=$p(drgqevtlist,"^",5)  //性别

	S PatAge=$p(drgqevtlist,"^",6)  //年龄
	S PatDOB=$p(drgqevtlist,"^",7)  //出生日期
	S:PatDOB'="" PatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(PatDOB) ;$zdh(PatDOB,3)
	S PatMedNo=$p(drgqevtlist,"^",8) //住院号或门诊就诊号
	S AdmLocDr=$p(drgqevtlist,"^",9) //就诊科室
	S EvtOccDate=$p(drgqevtlist,"^",10) //发生时间
	S:EvtOccDate'="" EvtOccDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EvtOccDate) ;$zdh(EvtOccDate,3)
	
	S DisEvtDate=$p(drgqevtlist,"^",11) //发现时间
	S:DisEvtDate'="" DisEvtDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DisEvtDate) ;$zdh(DisEvtDate,3)
	S EvtLevel=$p(drgqevtlist,"^",12)   //错误分级
	S OccLoc=$p(drgqevtlist,"^",13)     //发生科室
	S OccLocDesc=$p(drgqevtlist,"^",14) //发生科室描述
	S RelateInfo=$p(drgqevtlist,"^",15) //相关资相关料
	
	S RelateInfoDesc=$p(drgqevtlist,"^",16) //相关资料描述
	S Death=$p(drgqevtlist,"^",17) //死亡
	S ImCauseOfDeath=$p(drgqevtlist,"^",18) //直接死因
	S DeathDate=$p(drgqevtlist,"^",19) //死亡日期
	S:DeathDate'="" DeathDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DisEvtDate) ;$zdh(DeathDate,3)
	S DeathTime=$p(drgqevtlist,"^",20) //死亡时间
	S:DeathTime'="" DeathTime=$zth(DeathTime,1)
	
	S RecProc=$p(drgqevtlist,"^",21) 	 //恢复过程
	S HarmLevel=$p(drgqevtlist,"^",22)   //伤害程度
	S HarmDesc=$p(drgqevtlist,"^",23)    //伤害程度描述
	S ExtHospTime=$p(drgqevtlist,"^",24) //住院是否延长
	S CriticallyIll=$p(drgqevtlist,"^",25) //是否生命垂危
	S CriIllReport=$p(drgqevtlist,"^",26)  //生命垂危报告
	
	S GeneProc=$p(drgqevtlist,"^",27)     //发生经过
	S HandleInfo=$p(drgqevtlist,"^",28)   //处理情形
	S ImproMeasure=$p(drgqevtlist,"^",29) //改进措施
	S Reporter=$p(drgqevtlist,"^",30)     //报告人
	S PriOfRepLoc=$p(drgqevtlist,"^",31)  //报告科室负责人
	S RepCode=$p(drgqevtlist,"^",32)      //报告编码
	s CurStatusDr=$p(drgqevtlist,"^",33)  //当前状态
	&SQL(Update DHC_PHDrgQuaEvtReport Set DQER_RepLoc_Dr=:RepLocDr,DQER_Date=:RepDate,DQER_PatID=:PatID,DQER_PatName=:PatName,DQER_PatSex=:PatSex,
		DQER_PatAge=:PatAge,DQER_PatDOB=:PatDOB,DQER_PatMedNo=:PatMedNo,DQER_AdmLoc_Dr=:AdmLocDr,DQER_EvtOccDate=:EvtOccDate,DQER_DisEvtDate=:DisEvtDate,DQER_EvtLevel=:EvtLevel,
		DQER_OccLocation=:OccLoc,DQER_OccLocDesc=:OccLocDesc,DQER_RelateInfo=:RelateInfo,DQER_RelateInfoDesc=:RelateInfoDesc,DQER_Death=:Death,DQER_ImCauseOfDeath=:ImCauseOfDeath,
		DQER_DeathDate=:DeathDate,DQER_DeathTime=:DeathTime,DQER_RecProc=:RecProc,DQER_HarmLevel=:HarmLevel,DQER_HarmDesc=:HarmDesc,DQER_ExtHospTime=:ExtHospTime,DQER_CriticallyIll=:CriticallyIll,
		DQER_CriIllReport=:CriIllReport,DQER_GeneProc=:GeneProc,DQER_HandleInfo=:HandleInfo,DQER_ImproMeasure=:ImproMeasure,DQER_Reporter=:Reporter,DQER_PriOfRepLoc=:PriOfRepLoc,DQER_RepCode=:RepCode,
		DQER_CurStatus_DR=:CurStatusDr WHERE DQER_RowID=:dqEvtRepID)
	
	Q +%ROWID
}

/// Descript:保存药品质量事件报告相关药品信息
ClassMethod InsDQEvtRepDrgItm(dqEvtRepID As %String, dqEvtRepDrgItmList As %String) As %String
{
	N (dqEvtRepID,dqEvtRepDrgItmList)
	S Len=$L(dqEvtRepDrgItmList,"!!")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S tmpStr=$p(dqEvtRepDrgItmList,"!!",i)
	.S oeori=$p(tmpStr,"^",1)  //医嘱ID
	.S phcddr=$p(tmpStr,"^",2)    //药学项ID
	.S goodsname=$p(tmpStr,"^",3) //商品名
	.S genericdr=$p(tmpStr,"^",4) //通用名
	.S phformdr=$p(tmpStr,"^",5) //剂型
	.S manfdr=$p(tmpStr,"^",6)   //产地
	.S spec=$p(tmpStr,"^",7)     //规格
	.S packtype=$p(tmpStr,"^",8) //包装类型
	.S vendor=$p(tmpStr,"^",9)   //供应商
	.S batnoexp=$p(tmpStr,"^",10) //批号校期
	.S qty=$p(tmpStr,"^",11) //数量
	.S childSub=$o(^DHCPHDQER(dqEvtRepID,"DQERDI",""),-1)+1
	.&SQL(Insert Into DHC_PHDQEvtRepDrgItm(DQERDI_DQER_Parref,DQERDI_ChildSub,DQERDI_OEORI_DR,DQERDI_PHCD_DR,
		DQERDI_GoodsName,DQERDI_Generic_DR,DQERDI_PhForm_DR,DQERDI_Manf_DR,DQERDI_Spec,DQERDI_PackType,DQERDI_Vendor,
		DQERDI_BatNoExp,DQERDI_Qty)
		Values(:dqEvtRepID,:childSub,:oeori,:phcddr,:goodsname,:genericdr,:phformdr,:manfdr,:spec,:packtype,:vendor,:batnoexp,:qty))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:药品质量事件报告相关药品信息
ClassMethod delDQEvtRepDrgItm(dqEvtRepID As %String) As %String
{
	N (dqEvtRepID)
	i $d(^DHCPHDQER(dqEvtRepID,"DQERDI",1)) d
	.&SQL(DELETE DHC_PHDQEvtRepDrgItm WHERE DQERDI_DQER_Parref=:dqEvtRepID)
	Q +$g(SQLCODE)
}

/// Descript:保存药品质量事件报告诱发事件因素
ClassMethod InsDQEvtRepTriFac(dqEvtRepID As %String, dqEvtTFList As %String) As %String
{
	N (dqEvtRepID,dqEvtTFList)
	S Len=$L(dqEvtTFList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S tmpStr=$p(dqEvtTFList,"||",i)
	.S dqEvtTFdr=$p(tmpStr,"^",1)   //诱因
	.S dqEvtTFDesc=$p(tmpStr,"^",2) //诱因描述
	.
	.S childSub=$o(^DHCPHDQER(dqEvtRepID,"DQERTF",""),-1)+1
	.&SQL(Insert Into DHC_PHDQEvtRepTriFac(DQERTF_DQER_Parref,DQERTF_ChildSub,DQERTF_DQETF_DR,DQERTF_ETFDesc)
		Values(:dqEvtRepID,:childSub,:dqEvtTFdr,:dqEvtTFDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:药品质量事件报告诱发事件因素
ClassMethod delDQEvtRepTriFac(dqEvtRepID As %String) As %String
{
	N (dqEvtRepID)
	i $d(^DHCPHDQER(dqEvtRepID,"DQERTF",1)) d
	.&SQL(DELETE DHC_PHDQEvtRepTriFac WHERE DQERTF_DQER_Parref=:dqEvtRepID)
	Q +$g(SQLCODE)
}

/// Descript:查询药品质量事件报告
/// w ##class(web.DHCSTPHCMADRREPORT).QueryDQEvtReport("30","1","")
ClassMethod QueryDQEvtReport(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S pid=..NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1    //开始行
	S StDate=$p(params,"^",1)     //开始日期
	S EndDate=$p(params,"^",2)    //结束日期
	S LocID=$p(params,"^",3)    //科室ID
	S PatNo=$p(params,"^",4)    //登记号
	S curStatus=$P(params,"^",5)
	d ..killTmpGlobal(pid)
	
	S StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate) ;$zdh(StDate,3)
	S EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	S QuitFlag=0
	S Num=0
	F dd=StDate:1:EndDate D
	.S dgERepID=""
	.F  S dgERepID=$o(^DHCPHDQER(0,"RepDate",dd,dgERepID)) Q:dgERepID=""  D
	..S dgERepLoc=""
	..S dgERLocID=$p(^DHCPHDQER(dgERepID),"^",1)  //报告科室
	..Q:(LocID'="")&(dgERLocID'=LocID)
	..S:dgERLocID'="" dgERepLoc=$p(^CTLOC(dgERLocID),"^",2)
	..S dgERepDate=$p(^DHCPHDQER(dgERepID),"^",2) //日期
	..I dgERepDate'="" S dgERepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgERepDate) ;$zd(dgERepDate,3)
	..S dgEPatID=$p(^DHCPHDQER(dgERepID),"^",3)    //病人ID
	..S dgEPatName=$p(^DHCPHDQER(dgERepID),"^",4)  //病人姓名
	..S dgEPatMedNo=$p(^DHCPHDQER(dgERepID),"^",8) //病历号/门诊号
	..S dgERepUser=""
	..S dgERepUserID=$p(^DHCPHDQER(dgERepID),"^",30)  //报告人
	..S:dgERepUserID'="" dgERepUser=$p(^SSU("SSUSR",dgERepUserID),"^",2)
	..S dgERepCode=$p(^DHCPHDQER(dgERepID),"^",32)   //编码
	..S dgEPatNo="",InMedicare=""
	..I dgEPatID'="" d
	...S dgEPatNo=$p(^PAPER(dgEPatID,"PAT",1),"^",1) //登记号
	..Q:(PatNo'="")&(PatNo'=dgEPatNo)
		..S dgERepStatus=""
	..i dgERepID'=""   d //liyarong -2016-09-26
	...S dgERepStatus=$p(^DHCPHDQER(dgERepID),"^",33) //当前状态
	..Q:(curStatus'="")&(curStatus'=dgERepStatus)
	..i dgERepStatus="N" s dgERepStatus="未提交"
    ..i dgERepStatus="Y" s dgERepStatus="提交"
		..S ListData=dgERepID_"^"_$g(dgEPatNo)_"^"_dgEPatName_"^"_dgERepLoc_"^"_dgERepUser_"^"_dgERepDate_"^"_dgERepCode_"^"_dgERepStatus
	..
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","QueryDQEvtReport",pid,Num)=ListData
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","QueryDQEvtReport",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","QueryDQEvtReport",pid,index)
	.S Title="dgERepID^dgEPatNo^dgEPatName^dgERepLoc^dgEReporter^dgERepDate^dgERepCode^dgERepStatus"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取质量事件报告
ClassMethod getDQEvtRepInfo(dgEvtRepID As %String) As %String
{
	N (dgEvtRepID)
	Q:'$d(^DHCPHDQER(dgEvtRepID)) ""
	S dgERepLoc=""
	S dgERLocID=$p(^DHCPHDQER(dgEvtRepID),"^",1) //报告科室
	S:dgERLocID'="" dgERepLoc=$p(^CTLOC(dgERLocID),"^",2) //qunianpeng 2017/8/14 新版科室没有拼音码 $p($p(^CTLOC(dgERLocID),"^",2),"-",2)
	S dgERDate=$p(^DHCPHDQER(dgEvtRepID),"^",2)  //报告日期
	S:dgERDate'="" dgERDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgERDate) ;$zd(dgERDate,3)
	S dgERPatID=$p(^DHCPHDQER(dgEvtRepID),"^",3)   //病人ID
	S dgERPatAdm=$o(^PAPERdr(dgERPatID,"ADM","I",""),-1)
	S dgERPatName=$p(^DHCPHDQER(dgEvtRepID),"^",4) //姓名
	S dgERPatSex=$p(^DHCPHDQER(dgEvtRepID),"^",5)  //性别
	S dgERPatAge=$p(^DHCPHDQER(dgEvtRepID),"^",6)  //年龄
	S dgERPatDOB=$p(^DHCPHDQER(dgEvtRepID),"^",7)  //出生日期
	S:dgERPatDOB'="" dgERPatDOB=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgERPatDOB)
	S dgERPatMedNo=$p(^DHCPHDQER(dgEvtRepID),"^",8) 	//就诊号
	S dgERAdmLoc=""
	S dgERAdmLocID=$p(^DHCPHDQER(dgEvtRepID),"^",9)  	//就诊科室
	S:dgERAdmLocID'="" dgERAdmLoc=$p(^CTLOC(dgERAdmLocID),"^",2) //qunianpeng 2017/8/14  $p($p(^CTLOC(dgERAdmLocID),"^",2),"-",2)
	S evtOccDate=$p(^DHCPHDQER(dgEvtRepID),"^",10)  	//发生时间
	S:evtOccDate'="" evtOccDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(evtOccDate) ;$zd(evtOccDate,3)
	S disEvtDate=$p(^DHCPHDQER(dgEvtRepID),"^",11)  	//发现时间
	S:disEvtDate'="" disEvtDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(disEvtDate) ;$zd(disEvtDate,3)
	S dgEREvtLevel=$p(^DHCPHDQER(dgEvtRepID),"^",12)    //伤害级别
	S dgEOccLoc=$p(^DHCPHDQER(dgEvtRepID),"^",13)       //发生位置
	S dgEOccLocDesc=$p(^DHCPHDQER(dgEvtRepID),"^",14)   //发生位置描述
	S dgERelaInfo=$p(^DHCPHDQER(dgEvtRepID),"^",15)     //相关信息
	S dgERelaInfoDesc=$p(^DHCPHDQER(dgEvtRepID),"^",16) //相关信息描述
	S dgEDeath=$p(^DHCPHDQER(dgEvtRepID),"^",17)        //死亡
	S dgEImCauOfDeath=$p(^DHCPHDQER(dgEvtRepID),"^",18) //直接死因
	S dgEDeathDate=$p(^DHCPHDQER(dgEvtRepID),"^",19) 	//死亡日期
	S:dgEDeathDate'="" dgEDeathDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgEDeathDate) ;$zd(dgEDeathDate,3)
	S dgEDeathTime=$p(^DHCPHDQER(dgEvtRepID),"^",20) 	//死亡时间
	S:dgEDeathTime'="" dgEDeathTime=$zt(dgEDeathTime,1)
	S dgEDeathDate=dgEDeathDate_" "_dgEDeathTime
	S dgERecProc=$p(^DHCPHDQER(dgEvtRepID),"^",21)  	 //恢复过程
	S dgEHarmLevel=$p(^DHCPHDQER(dgEvtRepID),"^",22) 	 //伤害级别
	S dgEHarmLevelDesc=$p(^DHCPHDQER(dgEvtRepID),"^",23) //伤害级别描述
	S extInHospTime=$p(^DHCPHDQER(dgEvtRepID),"^",24)    //住院时间是否延长
	S criticalIll=$p(^DHCPHDQER(dgEvtRepID),"^",25)      //生命垂危
	S criticalIllRep=$p(^DHCPHDQER(dgEvtRepID),"^",26)   //生命垂危相关报告
	S dgEProcDesc=$p(^DHCPHDQER(dgEvtRepID),"^",27)      //事件过程描述
	S dgEHandleInfo=$p(^DHCPHDQER(dgEvtRepID),"^",28)    //事件处理情况
	S dgEImproMeasure=$p(^DHCPHDQER(dgEvtRepID),"^",29)  //事件改进措施
	S dgERUser=""
	S dgERUserID=$p(^DHCPHDQER(dgEvtRepID),"^",30)          //报告人
	S:dgERUserID'="" dgERUser=$p(^SSU("SSUSR",dgERUserID),"^",2)
	S dgERPriOfLoc=$p(^DHCPHDQER(dgEvtRepID),"^",31)     	//科室负责人
	S dgERepCode=$p(^DHCPHDQER(dgEvtRepID),"^",32)     		//编码	
	S dqEvtTriFac=..getdqEvtTriFac(dgEvtRepID) 				//诱发因素
	
	S adrRepDataList=dgEvtRepID_"!"_dgERLocID_"!"_dgERepLoc_"!"_dgERDate_"!"_dgERPatID_"!"_dgERPatAdm_"!"_dgERPatName_"!"_dgERPatSex_"!"_dgERPatAge_"!"_dgERPatDOB_"!"_dgERPatMedNo
	S adrRepDataList=adrRepDataList_"!"_dgERAdmLocID_"!"_dgERAdmLoc_"!"_evtOccDate_"!"_disEvtDate_"!"_dgEREvtLevel_"!"_dgEOccLoc_"!"_dgEOccLocDesc_"!"_dgERelaInfo
	S adrRepDataList=adrRepDataList_"!"_dgERelaInfoDesc_"!"_dgEDeath_"!"_dgEImCauOfDeath_"!"_dgEDeathDate_"!"_dgERecProc_"!"_dgEHarmLevel_"!"_dgEHarmLevelDesc
	S adrRepDataList=adrRepDataList_"!"_extInHospTime_"!"_criticalIll_"!"_criticalIllRep_"!"_dgEProcDesc_"!"_dgEHandleInfo_"!"_dgEImproMeasure_"!"_dgERUserID_"!"_dgERUser
	S adrRepDataList=adrRepDataList_"!"_dgERPriOfLoc_"!"_dgERepCode_"!"_dqEvtTriFac
	
 Q adrRepDataList
}

/// Descript:诱发因素
ClassMethod getdqEvtTriFac(dgEvtRepID As %String) As %String
{
	N (dgEvtRepID)
	S tmpStr="",tmpDescStr=""
	S ch=""
	F  S ch=$o(^DHCPHDQER(dgEvtRepID,"DQERTF",ch)) Q:ch=""  D
	.S dgEvtRepTFDr=$p(^DHCPHDQER(dgEvtRepID,"DQERTF",ch),"^",1)
	.S dgEvtRepTFDesc=$p(^DHCPHDQER(dgEvtRepID,"DQERTF",ch),"^",2) //描述
	.
	.I tmpStr="" S tmpStr=dgEvtRepTFDr_"^"_dgEvtRepTFDesc
	.E  S tmpStr=tmpStr_"||"_dgEvtRepTFDr_"^"_dgEvtRepTFDesc
	Q tmpStr
}

/// Descript:获取不良反应报告药品信息
ClassMethod getDQEvtRepDrgItm(dgEvtRepID As %String) As %String
{
	N (dgEvtRepID)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHDQER(dgEvtRepID,"DQERDI",ch)) Q:ch=""  D
	.S oeori=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",1) //医嘱ID
	.S phcddr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",2) //药学项ID
	.S goodsname=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",3) //商品名
	.S genericdr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",4) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.S formdr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",5) //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.S manfdr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",6) //产地
	.S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.i $d(manf) d
	..S:(manf'="")&(manf["-") manf=$p(manf,"-",2)
	.S spec=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",7) //规格
	.S packtype=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",8) //包装类型
	.S vendor=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",9) //供应商
	.S batnoexp=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",10) //批号校期
	.S qty=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",11) //数量
	.S ListData=oeori_"^"_phcddr_"^"_goodsname_"^"_genericdr_"^"_$g(genenic)_"^"_manfdr
	.S ListData=ListData_"^"_$g(manf)_"^"_formdr_"^"_form_"^"_spec_"^"_packtype_"^"_vendor_"^"_batnoexp_"^"_qty
	.
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","getDQEvtRepDrgItm",pid,Num)=ListData
	
	i 4>Num d
	.S Len=4-Num
	.f i=1:1:Len d
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","getDQEvtRepDrgItm",pid,Num)=""

	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","getDQEvtRepDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","getDQEvtRepDrgItm",pid,index)
	.S Title="orditm^phcdf^incidesc^genenicdr^genenic^manfdr^manf^formdr^form^spec^packtype^vendor^batexp^qty"
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

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","QueryDQEvtReport",pid)
	k ^TMP("DHCST","web.DHCSTPHCMDRGQEVTREPORT","getDQEvtRepDrgItm",pid)
}

/// Descript:获取病人基本信息
ClassMethod getRepPatInfo(AdmDr As %String, LocID As %String) As %String
{
	N (AdmDr,LocID)
	S papmidr=$p(^PAADM(AdmDr),"^",1)
	S patName=$p(^PAPER(papmidr,"ALL"),"^",1) //姓名
	S patNo=$p(^PAPER(papmidr,"PAT",1),"^",1) //登记号
	S sexId=$p(^PAPER(papmidr,"ALL"),"^",7) //姓别
	S patSex=$p(^CT("SEX",sexId),"^",2)
	S birthday=$p(^PAPER(papmidr,"ALL"),"^",6) //出生日期
	S nationdr=$p(^PAPER(papmidr,"PER",1),"^",2) //民族
	i birthday'="" s birthday=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(birthday) ;$zd(birthday,3)
	S patAge=##class(web.DHCSTKUTIL).GetAge(papmidr)  //年龄
	S patW=""
	S patTel=""
	S medicalNo=patNo //##Class(web.DHCWMRService).IGetMrNoByEpisodeID(AdmDr) //病案号
	S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",")
	I LocID'="" D
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
 	.S HospID=$p(^CTLOC(LocID),"^",22)
	.S Hospital=$p(^CT("HOSP",HospID),"^",2)
	.S HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	S AdmLocID=$p(^PAADM(AdmDr),"^",4) //科室
	S:AdmLocID'="" AdmLoc=$p(^CTLOC(AdmLocID),"^",2) // qunianpeng 2017/8/14 新版科室没有拼音码 $p($p(^CTLOC(AdmLocID),"^",2),"-",2)
	S AdmWardID=$p(^PAADM(AdmDr),"^",70) //病区
	S:AdmWardID'="" AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	S AdmBedID=$p(^PAADM(AdmDr),"^",73) //床号
	S bed=""
	I AdmBedID'="" S bed=$p(^PAWARD($p(AdmBedID,"||",1),"BED",$p(AdmBedID,"||",2)),"^",1)
	S repdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+$H) ;$zd(+$H,3)
	;S Prefix=HospitalCode_"DQE"_$zd(+$H,8)  //报告编码规则 医院编码+"ADR"+年月日+顺序号   //qunianpeng 2016-09-23 在插入时才生成
	;S AdrReportCode=..GetReportCurMaxNo(Prefix,"3")
	Q papmidr_"^"_patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge_"^"_birthday_"^"_nationdr_"^"_medicalNo_"^"_patW_"^"_patTel_"^"_PatDiag_"^"_$g(Hospital)_"^"_AdmLoc_"^"_AdmLocID_"^"_repdate_"^"_AdmWard_"^"_AdmWardID_"^"_bed_"^"_$g(LocDesc)  ;_"^"_AdrReportCode
}

/// Creator:    bianshuai
/// CreateDate: 2015-02-03
/// Descript:   取当前编号最大码
ClassMethod GetReportCurMaxNo(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen,CurrMaxNo)
	S NextNo=""
	L +^DHCPHCMADR("DHCPHCMADR",Prefix):10 E  Q -100
	S PreLen=$L(Prefix)
	S MinSuffix=1
	F i=1:1:NoLen-1 S MinSuffix="0"_MinSuffix
	S MinNo=Prefix_MinSuffix	//最小码
	S CurLen=PreLen+NoLen	    //单号长度
	///表里记录的最大码
	S CurrMaxNo=..GetMaxCodeByCode(Prefix)
	S CurPrefix=$E(CurrMaxNo,1,PreLen)
	S CurrNo=$E(CurrMaxNo,PreLen+1,CurLen)

	i Prefix'=CurPrefix D
	.S NextNo=MinNo
	.L -^DHCPHCMADR("DHCPHCMADR",Prefix)
	Q:NextNo'="" NextNo

	S Suffix=CurrNo+1
	
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	L -^DHCPHCMADR("DHCPHCMADR",Prefix)
	Q NextNo
}

/// Descript:获取当前最大码
/// 科室当前处方最编码
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S adrrcode=""
	&sql(select max(DQER_RepCode) into :adrrcode from DHC_PHDrgQuaEvtReport Where DQER_RepCode %STARTSWITH %ALPHAUP :Prefix)
	Q adrrcode
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMDRGQEVTREPORT"))
}

// W ##Class(web.DHCSTPHCMDRGQEVTREPORT).getDQEvtRepExportInfo("14")

/// Descript:获取质量事件报告
ClassMethod getDQEvtRepExportInfo(dgEvtRepID As %String) As %String
{
	N (dgEvtRepID)
	Q:'$d(^DHCPHDQER(dgEvtRepID)) ""
	S dgERepLoc=""
	S dgERLocID=$p(^DHCPHDQER(dgEvtRepID),"^",1) //报告科室
	S:dgERLocID'="" dgERepLoc=$p(^CTLOC(dgERLocID),"^",2)
	i dgERepLoc["-" s dgERepLoc=$p(dgERepLoc,"-",2)
	S dgERDate=$p(^DHCPHDQER(dgEvtRepID),"^",2)  //报告日期
	S:dgERDate'="" dgERDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgERDate) ;$zd(dgERDate,3)
	S dgERPatID=$p(^DHCPHDQER(dgEvtRepID),"^",3)   //病人ID
	S dgERPatAdm=$o(^PAPERdr(dgERPatID,"ADM","I",""),-1)
	S dgERPatName=$p(^DHCPHDQER(dgEvtRepID),"^",4) //姓名
	S dgERPatSex=$p(^DHCPHDQER(dgEvtRepID),"^",5)  //性别
	S:dgERPatSex'="" dgERPatSex=$p(^CT("SEX",dgERPatSex),"^",2)
	S dgERPatAge=$p(^DHCPHDQER(dgEvtRepID),"^",6)  //年龄
	S dgERPatDOB=$p(^DHCPHDQER(dgEvtRepID),"^",7)  //出生日期
	S:dgERPatDOB'="" dgERPatDOB=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgERPatDOB) ;$zd(dgERPatDOB,3)
	S dgERPatMedNo=$p(^DHCPHDQER(dgEvtRepID),"^",8) //就诊号
	S dgERAdmLoc=""
	S dgERAdmLocID=$p(^DHCPHDQER(dgEvtRepID),"^",9)   //就诊科室
	S:dgERAdmLocID'="" dgERAdmLoc=$p(^CTLOC(dgERAdmLocID),"^",2)
	i dgERAdmLoc["-" s dgERAdmLoc=$p(dgERAdmLoc,"-",2)
	S evtOccDate=$p(^DHCPHDQER(dgEvtRepID),"^",10)  //发生时间
	S:evtOccDate'="" evtOccDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(evtOccDate) ;$zd(evtOccDate,3)
	S disEvtDate=$p(^DHCPHDQER(dgEvtRepID),"^",11)  //发现时间
	S:disEvtDate'="" disEvtDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(disEvtDate) ;$zd(disEvtDate,3)
	S dgEREvtLevel=$p(^DHCPHDQER(dgEvtRepID),"^",12) //伤害级别
	S dgEOccLoc=$p(^DHCPHDQER(dgEvtRepID),"^",13)    //发生位置
	S dgEOccLoc=$S(dgEOccLoc="10":"药库",dgEOccLoc="11":"药房",dgEOccLoc="12":"病区",dgEOccLoc="13":"制剂室",dgEOccLoc="14":"输液室",dgEOccLoc="15":"患者取回家中",1:"")
	S dgEOccLocDesc=$p(^DHCPHDQER(dgEvtRepID),"^",14) //发生位置描述
	S dgERelaInfo=$p(^DHCPHDQER(dgEvtRepID),"^",15)   //相关信息
	S dgERelaInfo=$S(dgERelaInfo="10":"是",dgERelaInfo="11":"否",1:"")
	S dgERelaInfoDesc=$p(^DHCPHDQER(dgEvtRepID),"^",16) //相关信息描述
	S dgEDeath=$p(^DHCPHDQER(dgEvtRepID),"^",17)        //死亡
	S:dgEDeath="Y" dgEDeath="是"
	S dgEImCauOfDeath=$p(^DHCPHDQER(dgEvtRepID),"^",18) //直接死因
	S dgEDeathDate=$p(^DHCPHDQER(dgEvtRepID),"^",19)    //死亡日期
	S:dgEDeathDate'="" dgEDeathDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgEDeathDate) ;$zd(dgEDeathDate,3)
	S dgEDeathTime=$p(^DHCPHDQER(dgEvtRepID),"^",20) //死亡时间
	S:dgEDeathTime'="" dgEDeathTime=$zt(dgEDeathTime,1)
	S dgEDeathDate=dgEDeathDate_" "_dgEDeathTime
	S dgERecProc=$p(^DHCPHDQER(dgEvtRepID),"^",21)  //恢复过程
	S dgERecProc=$S(dgERecProc="10":"住院治疗",dgERecProc="11":"门诊随访治疗",dgERecProc="12":"自行恢复",1:"")
	S dgEHarmLevel=$p(^DHCPHDQER(dgEvtRepID),"^",22)     //伤害级别
	S dgEHarmLevel=$S(dgEHarmLevel="10":"无明显伤害",dgEHarmLevel="11":"暂时伤害",dgEHarmLevel="12":"永久性伤害",1:"N")
	S dgEHarmLevelDesc=$p(^DHCPHDQER(dgEvtRepID),"^",23) //伤害级别描述
	S extInHospTime=$p(^DHCPHDQER(dgEvtRepID),"^",24)    //住院时间是否延长
	S:extInHospTime="Y" extInHospTime="是"
	S criticalIll=$p(^DHCPHDQER(dgEvtRepID),"^",25)      //生命垂危
	S:criticalIll="Y" criticalIll="是"
	S criticalIllRep=$p(^DHCPHDQER(dgEvtRepID),"^",26)   //生命垂危相关报告
	S dgEProcDesc=$p(^DHCPHDQER(dgEvtRepID),"^",27)      //事件过程描述
	S dgEHandleInfo=$p(^DHCPHDQER(dgEvtRepID),"^",28)    //事件处理情况
	S dgEImproMeasure=$p(^DHCPHDQER(dgEvtRepID),"^",29)  //事件改进措施
	S dgERUser=""
	S dgERUserID=$p(^DHCPHDQER(dgEvtRepID),"^",30)         //报告人
	S:dgERUserID'="" dgERUser=$p(^SSU("SSUSR",dgERUserID),"^",2)
	S dgERPriOfLoc=$p(^DHCPHDQER(dgEvtRepID),"^",31)     //科室负责人
	S dgERepCode=$p(^DHCPHDQER(dgEvtRepID),"^",32)       //编码
	
	S dqEvtTriFac=..getdqEvtTriFac(dgEvtRepID) //诱发因素
	S dqEvtTriFac=$REPLACE(dqEvtTriFac,"10","药品自身缺陷，企业召回")
	S dqEvtTriFac=$REPLACE(dqEvtTriFac,"11","药品贮存不当，性质发生变化")
	S dqEvtTriFac=$REPLACE(dqEvtTriFac,"12","使用中与其他药品产生配伍禁忌")
	S dqEvtTriFac=$REPLACE(dqEvtTriFac,"13","使用方法不当")
	S dqEvtTriFac=$REPLACE(dqEvtTriFac,"99","其他")
	S dqEvtTriFac=$REPLACE(dqEvtTriFac,"||",",")
	S dqEvtTriFac=$REPLACE(dqEvtTriFac,"^","")
	S dqEvtRepDrgIt=..getExportDQEvtRepDrgItm(dgEvtRepID)
	
	S adrRepDataList=dgEvtRepID_"&&"_dgERLocID_"&&"_dgERepLoc_"&&"_dgERDate_"&&"_dgERPatID_"&&"_dgERPatAdm_"&&"_dgERPatName_"&&"_dgERPatSex_"&&"_dgERPatAge_"&&"_dgERPatDOB_"&&"_dgERPatMedNo
	S adrRepDataList=adrRepDataList_"&&"_dgERAdmLocID_"&&"_dgERAdmLoc_"&&"_evtOccDate_"&&"_disEvtDate_"&&"_dgEREvtLevel_"&&"_dgEOccLoc_"&&"_dgEOccLocDesc_"&&"_dgERelaInfo
	S adrRepDataList=adrRepDataList_"&&"_dgERelaInfoDesc_"&&"_dgEDeath_"&&"_dgEImCauOfDeath_"&&"_dgEDeathDate_"&&"_dgERecProc_"&&"_dgEHarmLevel_"&&"_dgEHarmLevelDesc
	S adrRepDataList=adrRepDataList_"&&"_extInHospTime_"&&"_criticalIll_"&&"_criticalIllRep_"&&"_dgEProcDesc_"&&"_dgEHandleInfo_"&&"_dgEImproMeasure_"&&"_dgERUserID_"&&"_dgERUser
	S adrRepDataList=adrRepDataList_"&&"_dgERPriOfLoc_"&&"_dgERepCode_"&&"_dqEvtTriFac_"&&"_dqEvtRepDrgIt
	
 Q adrRepDataList
}

/// Descript:获取不良反应报告药品信息
ClassMethod getExportDQEvtRepDrgItm(dgEvtRepID As %String) As %String
{
	N (dgEvtRepID)
	S dgEvtRepDrgItmStr=""
	S ch=""
	F  S ch=$o(^DHCPHDQER(dgEvtRepID,"DQERDI",ch)) Q:ch=""  D
	.S oeori=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",1) //医嘱ID
	.S phcddr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",2) //药学项ID
	.S goodsname=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",3) //商品名
	.S genericdr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",4) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.S formdr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",5) //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.S manfdr=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",6) //产地
	.S:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.i $d(manf) d
	..S:(manf'="")&(manf["-") manf=$p(manf,"-",2)
	.S spec=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",7) //规格
	.S packtype=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",8) //包装类型
	.S vendor=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",9) //供应商
	.S batnoexp=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",10) //批号校期
	.S qty=$p(^DHCPHDQER(dgEvtRepID,"DQERDI",ch),"^",11) //数量
	.S ListData=goodsname_"^"_genericdr_"^"_$g(genenic)_"^"_manfdr
	.S ListData=ListData_"^"_$g(manf)_"^"_formdr_"^"_form_"^"_spec_"^"_packtype_"^"_vendor_"^"_batnoexp_"^"_qty
	.i dgEvtRepDrgItmStr="" S dgEvtRepDrgItmStr=ListData
	.E  S dgEvtRepDrgItmStr=dgEvtRepDrgItmStr_"||"_ListData
	
	Q dgEvtRepDrgItmStr
}

Storage Default
{
<Data name="DHCSTPHCMDRGQEVTREPORTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPHCMDRGQEVTREPORTD</DataLocation>
<DefaultData>DHCSTPHCMDRGQEVTREPORTDefaultData</DefaultData>
<IdLocation>^web.DHCSTPHCMDRGQEVTREPORTD</IdLocation>
<IndexLocation>^web.DHCSTPHCMDRGQEVTREPORTI</IndexLocation>
<StreamLocation>^web.DHCSTPHCMDRGQEVTREPORTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
