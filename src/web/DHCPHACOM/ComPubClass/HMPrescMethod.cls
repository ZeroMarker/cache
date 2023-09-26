/// Description:草药处方公共方法类
/// Creator:    hulihua
/// CreateDate: 2019-01-14
Class web.DHCPHACOM.ComPubClass.HMPrescMethod Extends %Persistent [ ClassType = "", ProcedureBlock ]
{

/// Description:通过草药处方号获取其处方剂型的公共配置
/// Creator:	hulihua
/// CreateDate:	2019-01-14
/// Table:      PHAHERB_Config
/// Input:		PrescNo-处方号
/// Output:		
/// Return：	是否需要审方、审方节点、是否报到、是否打印配药单、是否打印用药标签
/// 			是否叫号、是否上屏、是否全送、是否允许退药		
/// Others:
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetHMPrescConfig("O210406000043")
ClassMethod GetHMPrescConfig(PrescNo As %String) As %Library.String
{
	s retData = ""
	q:PrescNo="" ""
	s prescNoStr=..GetPaQueInfo(PrescNo)
	s prescFormDr=$p(prescNoStr,"^",23)
	q:prescFormDr="" ""
	s recPhaLocId=$p(prescNoStr,"^",19)
	q:recPhaLocId="" ""
	s admId = $p(prescNoStr,"^",27)
	s admType = $p($g(^PAADM(+admId)), "^", 2)
	// MaYuqiang 20210413 处方剂型获取配方剂型
	s phptId = ""
	for {
		s phptId = $o(^CD.PHA.HERB.PresTypeItmi("ConCode", prescFormDr, phptId))
		q:((phptId = "")||(retData '= ""))
		s admTypeFlag = ""
		if $d(^CF.PHA.HERB.Configi("LocFormType", recPhaLocId, phptId, admType)){
			s phcfId = $o(^CF.PHA.HERB.Configi("LocFormType", recPhaLocId, phptId, admType,""))
			d GetPhcfData
		}
		s phcfId = ""
		for {
			s phcfId=$o(^CF.PHA.HERB.Configi("LocPresType", recPhaLocId, phptId, phcfId))
			q:((phcfId = "")||(retData '= ""))
			s phcfAdmType = $p($g(^CF.PHA.HERB.Config(phcfId)), "^", 13)
			continue:(phcfAdmType '= "")&&(phcfAdmType '= admType)
			d GetPhcfData			
		}
	}
	
    q $g(retData)

GetPhcfData
	s phcfData = $g(^CF.PHA.HERB.Config(phcfId))
	q:(phcfData = "")
	s presChkFlag=$p(phcfData, "^", 3)
	s presChkSel=$p(phcfData, "^", 4)
	s patRepFlag=$p(phcfData, "^", 5)
	s printPresFlag=$p(phcfData, "^", 6)
	s printLabSelect=$p(phcfData, "^", 7)
	s callFlag=$p(phcfData, "^", 8)
	s screenFlag=$p(phcfData, "^", 9)
	s presAllSendFlag=$p(phcfData, "^", 10)
	s presAgreeRetFlag=$p(phcfData, "^", 11)
	s printDispSheet=$p(phcfData, "^", 12)
	//输出串
	s retData1=$g(presChkFlag)_"^"_$g(presChkSel)_"^"_$g(patRepFlag)_"^"_$g(printPresFlag)_"^"_$g(printLabSelect)		;5
	s retData2=$g(callFlag)_"^"_$g(screenFlag)_"^"_$g(presAllSendFlag)_"^"_$g(presAgreeRetFlag)_"^"_$g(printDispSheet) 	;10
	s retData=retData1_"^"_retData2
	q ""
}

/// Description:通过草药医嘱获取处方信息
/// Creator:	hulihua
/// CreateDate:	2019-01-14
/// Table:      OE_OrdItem
/// Input:		PrescNo-处方号
/// Output:		
/// Return：	开方科室、开单医生、提交护士、提交时间、提交类型、
/// 				下医嘱日期、接收科室ID、接收科室  	
/// Others:
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo("I181221000001")
ClassMethod GetPreOrdInfo(PrescNo As %String) As %Library.String
{
	q:PrescNo="" ""
	s ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	q:ord="" ""
	s itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,""),-1)
	//开方科室
	s orddeptdr=$p(^OEORD(ord,"I",itm,7),"^",2)  
    s DoctorLoc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(orddeptdr),"^",2)
	//门诊留观科室
    s admDr=$p(^OEORD(ord),"^",1) 
	s currWardDr=$p(^PAADM(admDr),"^",70)
	i currWardDr'="" d
	.s admType=$p($g(^PAADM(admDr)),"^",2)
	.q:admType="I"
	.s ctLocDr=$p(^PAWARD(currWardDr),"^",5)
	.s wardLocDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(ctLocDr),"^",2)
	.s DoctorLoc=DoctorLoc_"["_wardLocDesc_"]"
    //提交护士
    s SeekUserId=$p($g(^OEORD(ord,"I",itm,"NUR")),"^",4)
    s SeekUserName=$s(SeekUserId'="":$p(^SSU("SSUSR",SeekUserId),"^",2),1:"")
    //提交时间
    s SeekDate=$p($g(^OEORD(ord,"I",itm,"NUR")),"^",5)
    s SeekDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(SeekDate)
    s SeekTime=$p($g(^OEORD(ord,"I",itm,"NUR")),"^",6)
    s SeekTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(SeekTime)
    s:SeekDate'="" SeekDate=SeekDate_" "_SeekTime
    //提交状态（A-已提交，R-拒绝，空-未提交）
    s SeekType=$p($g(^OEORD(ord,"I",itm,"NUR")),"^",7)
    i SeekType="F" s SeekType="A"	// 包含完成
    //输出串
    s retData1=$g(DoctorLoc)_"^"_$g(admDr)_"^"_$g(SeekUserName)_"^"_$g(SeekDate)_"^"_$g(SeekType)	;5
    s retData=retData1
    q $g(retData)
}

/// Description:获得中草药处方扩展信息 
/// Creator:	hulihua
/// CreateDate:	2017-04-06
/// Table:      PA_Que1、DHCPA_Que1
/// Input:		prescno-处方号
/// Output:		
/// Return：	用法、付数、用量、开始日期、结束日期、处方备注、煎药方式、处方类型、频次、处方配制
/// 			一次用量、处方类、处方名、用药疗程、用药开始描述、频次系数	 
/// Others:			
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo("I200623000125")
ClassMethod GetPaQueInfo(PrescNo As %String) As %String
{
	q ##class(PHA.COM.Order).GetPaQueInfo(PrescNo)
	
	q:PrescNo="" ""
	s ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	q:ord="" ""
	s queId=..PrescCYQueId(PrescNo)
	q:queId="" ""
	s itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,""))
    q:itm="" ""
	s recLocId=+$p($g(^OEORD(ord,"I",itm,3)),"^",6)
    s hospId=$p($g(^CTLOC(recLocId)),"^",22)
    s CookModeHospDr="HospDr_"_hospId
	s admDr=$p(^OEORD(ord),"^",1) 
	//开方医生
    s preDocDr=$p(^PAQUE1(queId,"DHC"),"^",3)
    s preDoctor=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(preDocDr),"^",2)
	//开方日期
    s preCreatDate=$p(^PAQUE1(queId,"DHC"),"^",4)
    s preCreatDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(preCreatDate)
    s preCreatTime=$p(^PAQUE1(queId,"DHC"),"^",5)
    s preCreatTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(preCreatTime)
    s:preCreatDate'="" preCreatDate=preCreatDate_" "_preCreatTime
    //处方开始日期
	s preQueDate=$p(^PAQUE1(queId,"DHC"),"^",6) 
	s preQueDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(preQueDate)
	//频次
	s preFreqDr=$p(^PAQUE1(queId,"DHC"),"^",9)
	s preFreqFac=$s(preFreqDr'="":$p($g(^PHCFR(preFreqDr)),"^",2),1:1) 
	s preFreqDesc=$s(preFreqDr'="":$p($g(^PHCFR(preFreqDr)),"^",3),1:"")	
	//付数、疗程 
	s preDurDr=$p(^PAQUE1(queId,"DHC"),"^",10)
	s preFactor=$s(preDurDr'="":$p($g(^PHCDU(preDurDr)),"^",2),1:"")
	s preDurDesc=$s(preDurDr'="":$p($g(^PHCDU(preDurDr)),"^",3),1:"")
	//处方截止日期 
	s preQueXDate=preQueDate+preFactor-1
	s preQueXDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(preQueXDate)
	//用法
	s preinsDr=$p(^PAQUE1(queId,"DHC"),"^",11)
	s preInstruc=$s(preinsDr'="":$p($g(^PHCIN(preinsDr)),"^",2),1:"")
	s preInstrCode=$s(preinsDr'="":$p($g(^PHCIN(preinsDr)),"^",1),1:"")
	//接收科室
	s preRecDeptDr=$p(^PAQUE1(queId,"DHC"),"^",12)
	s preRecDeptLoc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(preRecDeptDr),"^",2)
	//一次用量
	s preOrdQtyUom=$p(^PAQUE1(queId,"DHC"),"^",13)
	//煎药方式
	s preCoookTypeDr=$p(^PAQUE1(queId,"DHC"),"^",15)
	//s preCoookType=$p($g(^DHCDocConfig("CookMode",+preCoookTypeDr)),"^",2) 
	s preCoookType=$p($g(^DHCDocConfig(CookModeHospDr,"CookMode",+preCoookTypeDr)),"^",2)
	//备注
	s preNotes=$p(^PAQUE1(queId,"DHC"),"^",21)
	//是否加急
	s preEmerFlag=$P(^PAQUE1(queId,"DHC"),"^",22) 								
	//处方剂型	
	s preFormDr=$P(^PAQUE1(queId,"DHC"),"^",26)				
	//s preForm=$s(preFormDr'="":$p($g(^DHCDocConfig("CMPrescTypeList",preFormDr)),"^"),1:"")
	s preForm = $s(+preFormDr'=0:$p($g(^DHCDocConfig(CookModeHospDr,"CMPrescTypeList",preFormDr)),"^"),1:"")
	//s:preForm["膏方" preCoookType="制膏"
    //s:(preForm["颗粒")||(preForm["免煎") preCoookType="免煎"											
	//处方配制
	s preConfigId=$P(^PAQUE1(queId,"DHC"),"^",27)
	s preConfig=$s(preConfigId'="":$p($g(^DHCDocCT("DefineData",+preConfigId,"D",$p(preConfigId,"||",2))),"^",2),1:"")
	//功效（解表类 一般类 滋补类）
	s preEffect=$P(^PAQUE1(queId,"DHC"),"^",29)
	//用药时间(今天、明天、后天)
	s preUseDay=$P(^PAQUE1(queId,"DHC"),"^",31)
	//合并处方ID
	s preMergePaDr=$P(^PAQUE1(queId,"DHC"),"^",32)
	//处方名
	s preName=$P(^PAQUE1(queId,"DHC"),"^",33)	
	//输出列
	s queStr1=$g(preInstruc)_"^"_$g(preFactor)_"^"_$g(preOrdQtyUom)_"^"_$g(preQueDate)_"^"_$g(preQueXDate)		;5
	s queStr2=$g(preNotes)_"^"_$g(preCoookType)_"^"_$g(preForm)_"^"_$g(preFreqDesc)_"^"_$g(preConfig)			;10
	s queStr3=$g(preRecDeptLoc)_"^"_$g(preEffect)_"^"_$g(preName)_"^"_$g(preDurDesc)_"^"_$g(preUseDay)			;15
	s queStr4=$g(preFreqFac)_"^"_$g(preMergePaDr)_"^"_$g(preEmerFlag)_"^"_$g(preRecDeptDr)_"^"_$g(preinsDr)		;20
	s queStr5=$g(preFreqDr)_"^"_$g(preConfigId)_"^"_$g(preFormDr)_"^"_$g(preInstrCode)_"^"_$g(preCreatDate)		;25
	s queStr6=$g(preDoctor)_"^"_$g(admDr)
	s questr=queStr1_"^"_queStr2_"^"_queStr3_"^"_queStr4_"^"_queStr5_"^"_queStr6
	q $g(questr)
}

/// description: 判断是否为草药处方
/// return:		 不为空则为草药,返回Id
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId("O190111000076")
ClassMethod PrescCYQueId(PrescNo)
{
	q:PrescNo="" ""
	s queId=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
	q:queId="" ""
	q:$d(^PAQUE1(queId,"DHC")) queId
	q ""
}

/// Descript:	通过处方号获取处方审方信息
/// Creator:	hulihua
/// Table:		DHC_PHAORDMONITOR--医嘱审核主表、DHC_PHAORDMONITORLIST--医嘱审核子表
/// CreateDate:	2017-09-28
/// Input:		PrescNo-处方号,ResultFlag-N表示获取所有的信息，无论是否通过
/// Output:		
/// Return:     审方时间、审方人ID、审方人名称
/// w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPhaomInfo("I18011806149")
ClassMethod GetPhaomInfo(PrescNo As %String, ResultFlag As %String = "") As %String
{
	s phaomid="",retstr=""
	f  s phaomid=$o(^DHCPHORDM(0,"PrescNo",PrescNo,phaomid),-1)  q:(phaomid="")||(retstr'="")  d
	.s phaomresult=$p(^DHCPHORDM(phaomid),"^",2)
	.q:(ResultFlag="")&&(phaomresult'="Y")
	.s phaomdate=$p(^DHCPHORDM(phaomid),"^",3)
	.s phaomdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phaomdate)
	.s phaomtime=$p(^DHCPHORDM(phaomid),"^",4)
	.s phaomtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phaomtime)
	.s phaomdate=phaomdate_" "_phaomtime
	.s phaomuser=$p(^DHCPHORDM(phaomid),"^",1)
	.s phaomname=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(phaomuser),"^",2) 
	.s retstr=phaomdate_"^"_phaomuser_"^"_phaomname
	q retstr
}

/// Description:通过处方号获取草药处方的味数
/// Creator:	hulihua
/// CreateDate:	2018-10-19
/// Table:		Oe_orditm 
/// Input:		prescno-处方号		
/// Output:		
/// Return：	处方剂数
/// Others:		
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPrescNoCount("I190117000010")
ClassMethod GetPrescNoCount(prescno As %String) As %String
{
	Q:prescno="" 0
	s prescCount=..GetPresCountByDisp(prescno)
	Q:prescCount'=0 prescCount
	s Count=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
	..q:'$d(^OEORD(ord,"I",itm,1))
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..S dspId=$o(^DHCOEDISQTY(0,"OEORI",ord_"||"_itm,""))
	..Q:dspId="" 
	..S Count=Count+1
	Q Count
}

/// Description:通过处方号获取某处方的剂数（已发药）
/// Creator:	hulihua
/// CreateDate:	2017-12-07
/// Table:		DHC_PHACollected、DHC_PHACollectItm、DHC_PHDISPEN、DHC_PHDISITEM 
/// Input:		prescno-处方号		
/// Output:		
/// Return：	处方剂数
/// Others:		
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPresCountByDisp("I190117000010")
ClassMethod GetPresCountByDisp(prescno As %String) As %String
{
	Q:prescno="" 0
	S Type=$s($F(prescno,"I"):"I",1:"O")
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	K ^TMP("DHCINPHA",$this,"GetPresCountByDisp",pid,"PRESCNO")
	I Type="I" D
	.S Phac=$o(^DHCPHACi("PRESCNO",prescno,""),-1)
	.Q:Phac=""
	.S PhacCh=""
	.F  S PhacCh=$o(^DHCPHAC(Phac,"I",PhacCh)) Q:PhacCh=""  D
	..Q:'$D(^DHCPHAC(Phac,"I",PhacCh))
	..S oeori=$p(^DHCPHAC(Phac,"I",PhacCh),"^",7)
	..S Index=prescno_","_oeori
	..Q:$D(^TMP("DHCINPHA",$this,"GetPresCountByDisp",pid,"PRESCNO",Index))
	..S ^TMP("DHCINPHA",$this,"GetPresCountByDisp",pid,"PRESCNO",Index)=""
	.
	E  D
	.S PhdRow=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
	.Q:PhdRow=""
	.S PhdRowCh=""
	.F  S PhdRowCh=$o(^DHCPHDI(PhdRow,"PHDI",PhdRowCh))  Q:PhdRowCh=""  D
	..Q:'$D(^DHCPHDI(PhdRow,"PHDI",PhdRowCh))
	..S oeori=$p(^DHCPHDI(PhdRow,"PHDI",PhdRowCh),"^",5)
	..S Index=prescno_","_oeori
	..Q:$D(^TMP("DHCINPHA",$this,"GetPresCountByDisp",pid,"PRESCNO",Index))
	..S ^TMP("DHCINPHA",$this,"GetPresCountByDisp",pid,"PRESCNO",Index)=""
	.
	S Index="",Count=0
	F  S Index=$o(^TMP("DHCINPHA",$this,"GetPresCountByDisp",pid,"PRESCNO",Index))  Q:Index=""  D
	.S Count=Count+1
	K ^TMP("DHCINPHA",$this,"GetPresCountByDisp",pid,"PRESCNO")
	Q Count
}

/// Description: 判断十八反十九畏
/// Creator:	 yunhaibao
/// CreateDate:	 2019-03-21
/// Table:		
/// Input:		 OrdRowID-医嘱Id		
/// Output:		
/// Return：	
/// Others:	 	
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).CheckCMPrescLimitInfo("")
ClassMethod CheckCMPrescLimitInfo(OrdRowID As %String) As %String
{
	q:OrdRowID="" ""
	s CheckARCIMRowID=$p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),1)),"^",2)
	s FindOrdRowID=OrdRowID
	s LinkOrdRowID=$p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),11)),"^",39)
	i LinkOrdRowID'="" s FindOrdRowID=LinkOrdRowID
	s FindARCIMRowIDALL=""
	s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"OEORI",+FindOrdRowID,FindOrdRowID,OrdSub)) q:OrdSub=""  d
 	.q:'$d(^OEORD(+FindOrdRowID,"I",OrdSub,1))
	.s ARCIMRowIDNew=$p($g(^OEORD(+FindOrdRowID,"I",OrdSub,1)),"^",2)
	.q:ARCIMRowIDNew=""
	.i FindARCIMRowIDALL="" s FindARCIMRowIDALL=ARCIMRowIDNew
	.e  s FindARCIMRowIDALL=FindARCIMRowIDALL_"^"_ARCIMRowIDNew
	i FindOrdRowID'=OrdRowID d
	.s ARCIMRowIDNew=$p($g(^OEORD(+FindOrdRowID,"I",+$p(FindOrdRowID,"||",2),1)),"^",2)
	.i FindARCIMRowIDALL="" s FindARCIMRowIDALL=ARCIMRowIDNew
	.e  s FindARCIMRowIDALL=FindARCIMRowIDALL_"^"_ARCIMRowIDNew
	q:FindARCIMRowIDALL="" ""
	s LimitFlag="N"
	s LimitInfo=##class(web.DHCDocOrderEntryCM).GetCMLimitInfo(CheckARCIMRowID,FindARCIMRowIDALL)
	i (LimitInfo["反")||(LimitInfo["畏") s LimitFlag="Y"
	q LimitFlag
}

}
