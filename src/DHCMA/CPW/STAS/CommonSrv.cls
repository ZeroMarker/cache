/// 名称: DHCMA.CPW.STAS.CreateData
/// 描述: 临床路径 公用方法
/// 编写者：jiangpengpeng
/// 编写日期: 2019-03-21
Class DHCMA.CPW.STAS.CommonSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2018-07-03
/// Description:  取当月的起止日期
/// Input：       aDate：任意一天(YYYY-MM 或 YYYY-MM-DD 或 YYYY 或 MM)
/// 			  aIsOriginal：是否返回原生格式 0:YYYY-MM-DD格式(默认) 1:数字格式
/// Return：      该月起止日期2018-02-01^2018-02-28
/// w ##class(DHCMA.CPW.STAS.CommonSrv).GetMonthStaLastDay("2018-02")
ClassMethod GetMonthStaLastDay(aDate As %String = "", aIsOriginal As %String = "0") As %String
{
	New (aDate,aIsOriginal)
	Set return="^"
	Set aDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(aDate)
	Set:(aDate="") aDate=$e($zd(+$h,3),1,7)
	Set $ZT="GetMonthLastDayErr"
	
	Set aYear=$p(aDate,"-",1)
	Set aMonth=$p(aDate,"-",2)
	If (aYear="")||($l(aYear)<4){
		Set aMonth=aYear
		Set aYear=$e($zd($h,3),1,4)
	}
	Set:aMonth="" aMonth=$e($zd($h,3),6,7)
	
	Set StartDay=aYear_"-"_aMonth_"-"_"01"
	Set StartDayOrig=+$zdh(StartDay,3)
	
	Set nextMonth=$zd(StartDayOrig+32,3)
	Set nextMonth=$e(nextMonth,1,7)_"-"_"01"
	
	Set lastDay=+$zdh(nextMonth,3)-1
	If (aIsOriginal="0") {
		Set lastDay=$zd(lastDay,3)
	} Else {
		Set StartDay=StartDayOrig
	}
	Quit StartDay_"^"_lastDay
GetMonthLastDayErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-09-27
/// Description:  From计费组接口
///               根据就诊号取本次住院相关费用
/// Table：       
/// Input：       argEpisodeID:    User.PAADM
/// Return：      return=住院相关费用
/// w ##class(DHCMA.CPW.STAS.CommonSrv).GetAdmCateFees(13479887)
ClassMethod GetAdmCateFees(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=""
	Quit:argEpisodeID="" return
	
	Set $ZT="GetAdmCateFeesErr"
	Set:argEpisodeID["!!" argEpisodeID=$p(argEpisodeID,"!!",1)
	Set return=##Class(web.UDHCJFBaseCommon).GetAdmCateFee(argEpisodeID)
	
	Quit return
	
GetAdmCateFeesErr
	Quit return
}

/// 住院费用、住院药费、检验费用、检查费用
/// w ##Class(DHCMA.CPW.STAS.CommonSrv).getCostInfo(7185729)
ClassMethod getCostInfo(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set:argPaadm["!!" argPaadm=$p(argPaadm,"!!",1)
	//总费用、药费、检验费、检查费、材料费
	Set CountCost=0,DrugCost=0,LabCost=0,CheckCost=0,MaterialCost=0

	//普通方式通过计费提供接口取费用
	Set strCateFee=##class(DHCMA.CPW.STAS.CommonSrv).GetAdmCateFees(argPaadm)
	For Index=1:1:$l(strCateFee,"&")
	{
		Set Fee=$p(strCateFee,"&",Index)
		Set CountCost=CountCost+$p(Fee,"^",2)
		Set:Fee["药" DrugCost=DrugCost+$p(Fee,"^",2)
		Set:Fee["化验" LabCost=LabCost+$p(Fee,"^",2)
		Set:Fee["检验" LabCost=LabCost+$p(Fee,"^",2)
		Set:Fee["检查" CheckCost=CheckCost+$p(Fee,"^",2)
		Set:Fee["材料" MaterialCost=MaterialCost+$p(Fee,"^",2)
		Set:Fee["处置" MaterialCost=MaterialCost+$p(Fee,"^",2)
	}

	Set return=CountCost_"^"_DrugCost_"^"_LabCost_"^"_CheckCost_"^"_MaterialCost
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-21
/// Description:  判断是否发生院感
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).CheckHAIByAdm("")
ClassMethod CheckHAIByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	
	Set SCode="HIS01"
	Set EpisodeIDX=SCode_"||"_aEpisodeID
	Set objEp=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(EpisodeIDX)
	Quit:'$IsObject(objEp) return
	Set aEpisodeDr=objEp.%Id()
	
	Set $ZT="CheckHAIByAdm"
	Set IsHAI=0
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Continue:(xRepType'=1)&&(xRepType'=2) //1医院感染报告、2新生儿感染报告
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xID))
			Quit:xID=""
			
			Set objInfRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Continue:'$IsObject(objInfRep)
			Continue:'$IsObject(objInfRep.IRStatusDr)
			Set StatusCode=objInfRep.IRStatusDr.BTCode
			Continue:StatusCode'="3"  //1保存、2提交、3审核、4删除、5退回、6取消审核
			Set IsHAI=1
			Quit
		}
		Quit:IsHAI=1
	}
	Set return=IsHAI
	Quit return
CheckHAIByAdm
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  判断是否当天再入院
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).CheckReByAdm("")
ClassMethod CheckReByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(aEpisodeID)
    Quit:'$IsObject(objEpisode) return
    
    Set AdmDate=objEpisode.PAAdmDate
    Set xEpisodeID=+objEpisode.OID
    Set PatientID=+objEpisode.PAPatientID
    
    Set IsReAdm=0
	For {
		Set xEpisodeID=$o(^PAPERdr(PatientID,"ADM","I",xEpisodeID))
		Quit:xEpisodeID=""
		Quit:IsReAdm=1
		
		Set xAdmDate=$p($g(^PAADM(xEpisodeID)),"^",6)
		Set:xAdmDate=AdmDate IsReAdm=1
	}
	
	Set return=IsReAdm
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  判断是否入院24小时内退出路径
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).Check24OutByAdm("")
ClassMethod Check24hOutByAdm(aEpisodeID As %String, aPathwayID) As %String
{
	New (aEpisodeID,aPathwayID)
	Set return=""
	Quit:(aEpisodeID="")||(aPathwayID="") return
	
	Set Is24hOut=0
	Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(aEpisodeID)
    Quit:'$IsObject(objEpisode) return
    
    Set AdmDate=objEpisode.PAAdmDate
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set Status=objPathway.CPStatus
	Quit:Status'="O" return
	
	Set OutDate=objPathway.CPOutDate
	Set:OutDate-AdmDate<2 Is24hOut=1
	
	Set return=Is24hOut
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  取术前住院日
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).GetDaysBeforeOpr("")
ClassMethod GetDaysBeforeOpr(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set objEpisode=##class(DHCMA.Util.EPx.Episode).GetObjById(aEpisodeID)
    Quit:'$IsObject(objEpisode) return
    
    Set xEpisodeID=+objEpisode.OID
    Set AdmDate=objEpisode.PAAdmDate
	
	Set OperInfo=..getOperInfo(xEpisodeID)
	Set IsOperPat=$p(OperInfo,"^",1)
	Set OperDate=$p(OperInfo,"^",2)
	
	If (IsOperPat'="Y") {
		Set days=0
	} Else {
		Set days=OperDate-AdmDate
	}
	Set return=days
	Quit return
}

/// 是否手术患者(Y/N)、手术日期(第一次)
ClassMethod getOperInfo(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set:argPaadm["!!" argPaadm=$p(argPaadm,"!!",1)
	Set IsOperPat="N",OperDate=""
	Set ANOPArrID=0
	For {
		Set ANOPArrID=$o(^DHCANOPArrange(0,"Adm",argPaadm,ANOPArrID))
		Quit:ANOPArrID=""
		Quit:IsOperPat="Y"
		
		Set ANOPArr=$g(^DHCANOPArrange(ANOPArrID))
		Set OperStatus=$p(ANOPArr,"^",27)   //手术排班状态（A-申请,D-拒绝,R-接收,I-入室,O-术中, L-离开,F-完成）
		Continue:(OperStatus="A")||(OperStatus="D")
		Set OperDate=$p(ANOPArr,"^",14)     //手术日期
		Set:OperDate'="" IsOperPat="Y"      //手术患者标记
	}
	Set return=IsOperPat_"^"_OperDate
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  取出院情况
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).GetDischCond("")
ClassMethod GetDischCond(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set:argPaadm["!!" argPaadm=$p(argPaadm,"!!",1)
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argPaadm)
	Quit:MRAdm="" return
	
	Set DischCondID=$p($g(^MR(+MRAdm,"PRO",1)),"^",10)
	Set DischCondDesc=$p($g(^PAC("DISCON",+DischCondID)),"^",2)
	Set:DischCondDesc["痊愈" DischCondDesc="治愈"
	Set:DischCondDesc["治愈" DischCondDesc="治愈"
	Set:DischCondDesc["好转" DischCondDesc="好转"
	Set:DischCondDesc["已故" DischCondDesc="死亡"
	Set:DischCondDesc["死亡" DischCondDesc="死亡"
	Set:(DischCondDesc'="治愈")&&(DischCondDesc'="好转")&&(DischCondDesc'="死亡") DischCondDesc="其他"
	Set return=DischCondDesc
	
	Quit return
}

/// 取再入院天数
ClassMethod GetTimesInHospDays(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set return=-1
	Set:argPaadm["!!" argPaadm=$p(argPaadm,"!!",1)
	//Set AdmDate=+$p($g(^PAADM(+argPaadm)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(argPaadm)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set PatientID=$p($g(^PAADM(+argPaadm)),"^",1)
	Set ProEpisodeID=$o(^PAPERdr(+PatientID,"ADM","I",argPaadm),-1)
	If ProEpisodeID'="" {
		//Set ProDischDate=+$p($g(^PAADM(+ProEpisodeID)),"^",17)
		//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(ProEpisodeID)
		Set ProDischDate=$p(DischDateTime,"^",1)
		Set return=AdmDate-ProDischDate
		Set:return=0 return=1
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  判断是否手术部位感染患者
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).CheckOprInf("")
ClassMethod CheckOprInf(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1)
	Set SCode="HIS01"
	Set EpisodeIDX=SCode_"||"_aEpisodeID
	Set objEp=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(EpisodeIDX)
	Quit:'$IsObject(objEp) return
	Set aEpisodeDr=objEp.%Id()
	
	Set IsOperInf=0
	
	Set InfPosDescs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")&&(RepType'="2")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Quit:'$IsObject(objINFRep)
			Set RepStatus=objINFRep.IRStatusDr
			Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
			Continue:RepStatus.BTCode'="3"
			// 感染诊断信息
			Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				// 感染诊断
				Set objInfPos = objDiags.IRInfPosDr
				If $IsObject(objInfPos){
					Set PosDesc=objInfPos.BTDesc
					Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官（或腔隙）感染")))
					Set IsOperInf=1
					Quit
				}
			}
			Quit:IsOperInf=1
		}
	}
	
	Set return=IsOperInf
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  判断是否非计划重返手术室患者
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).CheckReOprPat("")
/// w ##class(CIS.AN.SRV.OperService).CheckReentryOperation(EpisodeID,newVersion)
ClassMethod CheckReOprPat(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1)
	Set BLFlag=##class(%Dictionary.CompiledClass).%OpenId("CIS.AN.BL.OperScheduleList")
	Set ANFlag=##class(%Dictionary.CompiledClass).%OpenId("CIS.AN.OperSchedule")
	if (ANFlag'="")&&(BLFlag'=""){
		Set return=..CheckReentryOperation(aEpisodeID,"Y")
	}else{
		Set return=..CheckReentryOperation(aEpisodeID,"")
	}
	Quit +return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  判断是否预防性抗菌药物使用患者
/// 			  通过用药频次（术前30分钟用药）来判断
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).CheckPreDrug("")
ClassMethod CheckPreDrug(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set:argPaadm["!!" argPaadm=$p(argPaadm,"!!",1)
	Set USTAT=$O(^OEC("OSTAT",0,"Code","U",0))
	Set oeori=0
	For{
		Set oeori=$o(^DAUP("ADM",argPaadm,oeori))
		Quit:oeori=""
		Quit:return=1
		Set OrdStatus=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
		Continue:USTAT=OrdStatus	//作废医嘱不符合条件
		Set rowid=""
		For{
			Set rowid=$o(^DAUP("ADM",argPaadm,oeori,rowid))
			QUit:rowid=""
			Quit:return=1
			//标准版 最新版抗菌药物管理 配置数据
			Set AIMDr=$p(^DAUP("DAUP",rowid),"^",20) //使用目的
			Continue:AIMDr=""
			Set AURDr=$p(^DHCAntBasePurposeDataConfigD(AIMDr),"^",6) //使用目的大类
			Continue:AURDr=""				
			Set Aur=$p(^DHCAntBasePurposeDataConfigD(AURDr),"^",4)
			Set:Aur="YF" return=1
		}
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-10-08
/// Description:  判断是否三线抗生素患者
/// 			  通过用药频次（术前30分钟用药）来判断
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CommonSrv).Check3Pharmacy("")
ClassMethod Check3Pharmacy(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	Set:argPaadm["!!" argPaadm=$p(argPaadm,"!!",1)
	
	Set USTAT=$O(^OEC("OSTAT",0,"Code","U",0))
	Set oeori=0
	For{
		Set oeori=$o(^DAUP("ADM",argPaadm,oeori))
		Quit:oeori=""
		Quit:return=1
		Set OrdStatus=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
		Continue:USTAT=OrdStatus        //作废医嘱不符合条件
		Set Used=1
		Set arcim=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
		Set PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcim)
		Set PoisonCode=""
		Set:PoisonRowid'="" PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
		Set:PoisonCode="KSS3" return=1
	}
	Quit return
}

ClassMethod GetPhcCostDays(aPaadm As %String) As %String
{
	New (aPaadm)
	
	Set:aPaadm["!!" aPaadm=$p(aPaadm,"!!",1)
	Set (PharmacyCost,PharmacyDays)=""
	Set PharmacyCost=..GetAntiFee(aPaadm)
	Set PharmacyDays=..GetAntUseDrugDays(aPaadm)
	
	Set return=PharmacyCost_"^"_PharmacyDays
	Quit return
}

/// Add by zhaoyu 2013-05-24 抗菌药物接口2 费用&天数1      
/// w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).GetKjxxByadmId(30972)
ClassMethod GetKjxxByadmId(admId As %String, flag As %String) As %String
{
	;取出院病人用药天数
	n (admId,flag)
	Set Fee=0,ts=0,outdata=Fee_"^"_ts	// zhaoyu 2013-05-30
	s $zt="ErrorReturn"
	k ^temp($j,"CyTJLxc"),^temp1($j,"CyTJLxc")
	
	s:admId["!!" admId=$p(admId,"!!",1) 
	s WLRowid=0 f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",admId,WLRowid)) q:WLRowid=""  d
	.s PAADMType=$p(^DHCWorkLoad(WLRowid),"^",4) q:PAADMType'="I"
	.s Price=$p(^DHCWorkLoad(WLRowid),"^",16)
	.s arcim=$p(^DHCWorkLoad(WLRowid),"^",2)     ;医嘱项
	.s TarCate=$p(^DHCWorkLoad(WLRowid),"^",9)    ;医嘱子分类 
	.q:'$d(^ARC("IC",0,"OrderType","R",TarCate))  ; 
	.s phcdf=..GetPHCDFByarcim(arcim)
	.s IsAntiDrgflg=..IsAntiDrg(phcdf)
	.i IsAntiDrgflg'=0  d
	..s KJYPrice=$p(^DHCWorkLoad(WLRowid),"^",16)
	..s ^temp($j,"CyTJLxc",admId,"KSFee")=$g(^temp($j,"CyTJLxc",admId,"KSFee"))+KJYPrice ;病人抗菌药品总收入
	..s oeori=$p(^DHCWorkLoad(WLRowid),"^",21) ;医嘱ID
	..s oeordId=$p(oeori,"||",1)
	..s oeoriSub=$p(oeori,"||",2)
	..i flag=7 d
	...s ordExec=0	// zhaoyu 2013-05-30
	...f  s ordExec=$O(^OEORD(oeordId,"I",oeoriSub,"X",ordExec)) q:ordExec=""  d  //OE_OrdExec //oeordId
	....s mExecDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",ordExec)),"^",19)	//执行日期 ;2013-04-02
	....s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",ordExec)),"^",16)  ;医嘱状态
	....q:(ststat'=1) // && (ststat'=6)) // 不是已执行的不要,未执行的没有执行日期和时间?
	....s ^temp1($j,"CyTJLxc",admId,mExecDate,"date")=1
	..i flag'=7 d
	...s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;医嘱开始日期
	...s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;医嘱状态
	...q:((ststat'=1) && (ststat'=6))
	...s ^temp1($j,"CyTJLxc",admId,sttDate,"date")=1
	
	s adm=0 f  s adm=$o(^temp($j,"CyTJLxc",adm))  q:adm=""  d
	.s Fee=$g(^temp($j,"CyTJLxc",adm,"KSFee"))
	.s ts=0 
	.s sdate=0  f  s sdate=$o(^temp1($j,"CyTJLxc",adm,sdate))  q:sdate=""  d
	..s ts=ts+1
	
	s outdata=Fee_"^"_ts
	k ^temp($j,"CyTJLxc"),^temp1($j,"CyTJLxc")
	q outdata
	
ErrorReturn
	k data
	k ^temp($j,"CyTJLxc"),^temp1($j,"CyTJLxc")
	q outdata
}

/// Add by zhaoyu 2013-05-24 抗菌药物接口2 费用&天数2
/// 判断药学项是否抗菌素,是返回1,否则返回0  w $$IsAntiDrg^DHCWLBuildKPICommon("336")
ClassMethod IsAntiDrg(phcdf As %String) As %String
{
	n (phcdf)
	s phcm=+phcdf   
	s phcpo=$p(^PHCD(phcm,1),"^",4) q:phcpo="" 0
	s phcpoCode=$zcvt($p($g(^PHCPO(phcpo)),"^",1),"U")  
    
    q:phcpoCode["KSS1" 1  // 
    q:phcpoCode["KSS2" 2  //限制使用抗菌药
    q:phcpoCode["KSS3" 3  // 
 	q 0
}

/// Add by zhaoyu 2013-05-24 抗菌药物接口2 费用&天数3
/// 通过医嘱项取得药学项
/// $$GetPHCDFByarcim^DHCWLBuildKPICommon(arcim)  
ClassMethod GetPHCDFByarcim(arcim As %String) As %String
{
	n (arcim)
	;s $zt="ReturnNull"
	s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)
	q phcdf
}

/// 抗生素费用、抗生素使用天数
ClassMethod getPharmacyInfo(argPaadm As %String, argPharmacyCateg As %String, argPharmacySubCat As %String) As %List
{
	New (argPaadm,argPharmacyCateg,argPharmacySubCat)
	Set return=""
	Quit:argPaadm="" return
	Quit:(argPharmacyCateg="")&&(argPharmacySubCat="") return
	
	Set:argPaadm["!!" argPaadm=$p(argPaadm,"!!",1) 
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"PharmacyDay")
	
	Set PharmacyCateg=argPharmacyCateg
	Set PharmacySubCat=argPharmacySubCat
	Set PharmacyCategory=$ListFromString(PharmacyCateg_","_PharmacySubCat)
	
	Set ArcimCost=0,ArcimDays=0
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",argPaadm,OrderID))
		Quit:OrderID=""
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			
			/*
			If PharmacyCateg'="" {                      //药学大类
				Set CategInfo=..GetPhcCat(ArcimID)
				Set CategName=$p(CategInfo,"/",3)
				Continue:CategName=""
				Continue:PharmacyCateg'[CategName
			}
			If PharmacySubCat'="" {                     //药学子类
				Set SubCatInfo=..GetPhcSubCat(ArcimID)
				Set SubCatName=$p(SubCatInfo,"/",3)
				Continue:SubCatName=""
				Continue:PharmacySubCat'[SubCatName
			}*/
			
			Set ArcItemCatDr=$p($g(^ARCIM(+ArcimID,1,1)),"^",10)
			Set ARCICOrdCatDR=$p($g(^ARC("IC",+ArcItemCatDr)),"^",8)
			Set ARCICOrderType=$p($g(^ARC("IC",+ARCICOrdCatDR)),"^",7)
			Continue:ARCICOrderType'="R"
			Set tmpPHCCat=..GetPHCCatNew(ArcimID)
			Set PHCCat=$p(tmpPHCCat,$c(1),1)
			Set PHCCatCode=$p(PHCCat,$c(2),2)
			Set PHCCatDesc=$p(PHCCat,$c(2),3)
			Set PHCSubCat=$p(tmpPHCCat,$c(1),2)
			Set PHCSubCatCode=$p(PHCSubCat,$c(2),2)
			Set PHCSubCatDesc=$p(PHCSubCat,$c(2),3)
			Set PHCPoison=$p(tmpPHCCat,$c(1),3)
			Set PHCPoisonCode=$p(PHCPoison,$c(2),2)
			Set PHCPoisonDesc=$p(PHCPoison,$c(2),3)
			Set PHCAntiFlag=$p(tmpPHCCat,$c(1),4)
			If ((PHCCatCode'="")&&($listfind(PharmacyCategory,PHCCatCode)>0))
			||((PHCCatDesc'="")&&($listfind(PharmacyCategory,PHCCatDesc)>0))
			||((PHCSubCatCode'="")&&($listfind(PharmacyCategory,PHCSubCatCode)>0))
			||((PHCSubCatDesc'="")&&($listfind(PharmacyCategory,PHCSubCatDesc)>0))
			||((PHCPoisonCode'="")&&($listfind(PharmacyCategory,PHCPoisonCode)>0))
			||((PHCPoisonDesc'="")&&($listfind(PharmacyCategory,PHCPoisonDesc)>0))
			||((PHCAntiFlag'="")&&($listfind(PharmacyCategory,PHCAntiFlag)>0))
			{
				//符合筛查条件药品
			} Else {
			 	Continue
			}
			
			Set SttDate=0,flg=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Set StatusID=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",13)
					Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),2)
					Continue:StatusDesc["停止"
					
					Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
					Continue:StartDate=""
					If '$d(^TMP(ZIndex,JIndex,"PharmacyDay",StartDate)) {
						Set ^TMP(ZIndex,JIndex,"PharmacyDay",StartDate)=""
						Set ArcimDays=ArcimDays+1
					}
					
					Set OEItemID=OrderID_"||"_SubID
					Set PatBillID=0
					For {
						Set PatBillID=$o(^DHCPBi(0,"OEORI",OEItemID,PatBillID))
						Quit:PatBillID=""
						Set PBOID=0
						For {
							Set PBOID=$o(^DHCPBi(0,"OEORI",OEItemID,PatBillID,PBOID))
							Quit:PBOID=""
							Set tmpCost=+$p($g(^DHCPB(PatBillID,"O",PBOID)),"^",8)
							Set ArcimCost=ArcimCost+tmpCost
						}
					}
				}
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"PharmacyDay")
	Set return=$lb(ArcimCost,ArcimDays)
	
	Quit return
}

/// add by mxp 2017-09-29
/// 取药学大类、药学子类、管制分类、抗菌药物标志
/// w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).GetPHCCatNew(2743)
ClassMethod GetPHCCatNew(aArcimID As %String) As %String
{
	New (aArcimID)
	Set return=""
	Quit:aArcimID="" return
	
	Set DrgFormID=$p($g(^ARCIM(+aArcimID,1,1)),"^",12)  //PHC_DrgForm:药学形态
	Set DrgMastID=+DrgFormID                            //PHC_DrgMast药理学项
	
	Quit:DrgMastID=0 return
	
	Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",8)
	Set AntiFlag=$s(AntiFlag="Y":"ANTI",1:"")
	
	Set SubCatID=$p($g(^PHCD(DrgMastID,1)),"^",3)       //PHC_SubCat药理学子分类
	Set SubCatCode=$p($g(^PHCC(+SubCatID,"SC",+$p(SubCatID,"||",2))),"^",1)
	Set SubCatDesc=$p($g(^PHCC(+SubCatID,"SC",+$p(SubCatID,"||",2))),"^",2)
	
	Set MinCatID=$p($g(^PHCD(DrgMastID,1)),"^",6)       //PHC_MinorSubCat药理学最小分类
	
	Set PHCCatID=+SubCatID                              //PHC_Cat药理学分类
	Set PHCCatCode=$p($g(^PHCC(PHCCatID)),"^",1)
	Set PHCCatDesc=$p($g(^PHCC(PHCCatID)),"^",2)
	
	//新药品学分类
	Set MinCatID=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",20)  //PHC_MinorSubCat药理学最小分类	
	Set PhaCatAllstr=##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetAllPhcCatById(MinCatID,"","","")
	If PhaCatAllstr'="" {
		Set PhaCatAlls=$p(PhaCatAllstr,"^",3)
		Set PHCCatID=$p(PhaCatAlls,"-",1)				//PHC_Cat药理学分类
		Set PHCCatCode=$p($g(^DHCPHCC(PHCCatID)),"^",1) 
		Set PHCCatDesc=$p($g(^DHCPHCC(PHCCatID)),"^",2) 
		Set SubCatID=$p(PhaCatAlls,"-",2)				//PHC_SubCat药理学子分类
		Set SubCatCode=$p($g(^DHCPHCC(+SubCatID)),"^",1) //PHC_SubCat药理学子分类
		set SubCatDesc=$p($g(^DHCPHCC(+SubCatID)),"^",2) 
		Set MinCatID=$p(PhaCatAlls,"-",3)
	}
	
	Set PoisonID=$p($g(^PHCD(DrgMastID,1)),"^",4)      //PHC_Poison  管制分类
	Set PoisonCode=$p($g(^PHCPO(+PoisonID)),"^",1)
	Set PoisonDesc=$p($g(^PHCPO(+PoisonID)),"^",2)
	
	Set return=PHCCatID_$c(2)_PHCCatCode_$c(2)_PHCCatDesc
	Set return=return_$c(1)_SubCatID_$c(2)_SubCatCode_$c(2)_SubCatDesc
	Set return=return_$c(1)_PoisonID_$c(2)_PoisonCode_$c(2)_PoisonDesc
	Set return=return_$c(1)_AntiFlag
	Quit return
}

ClassMethod GetPatAntInfoById(episodeid As %String) As %String
{
	new (episodeid)
	s:episodeid["!!" episodeid=$p(episodeid,"!!",1)
	s Used=0,isKSS1=0,isKSS2=0,isKSS3=0,isZL=0,isYF=0
	s USTAT=$O(^OEC("OSTAT",0,"Code","U",0))
	S oeori=0
	f  s oeori=$o(^DAUP("ADM",episodeid,oeori))  q:oeori=""  d
	.S OrdStatus=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
	.q:USTAT=OrdStatus        //作废医嘱不符合条件
	.s Used=1
	.s arcim=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	.s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcim)
	.s PoisonCode=""
	.i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	.if PoisonCode="KSS1"  S isKSS1=1
	.if PoisonCode="KSS2"  S isKSS2=1
	.if PoisonCode="KSS3"  S isKSS3=1
	.s rowid=""
	.f  s rowid=$o(^DAUP("ADM",episodeid,oeori,rowid))  q:rowid=""  d
	..;s DTAUPDr=$p(^DAUP("DAUP",rowid),"^",20)
	..;S AURDr=$p(^DTAUP("AUP",DTAUPDr),"^",3)
	..;S Aur=$p(^DCTAR("AUR",AURDr),"^",1)
	..;标准版 最新版抗菌药物管理 配置数据
	..s AIMDr=$p(^DAUP("DAUP",rowid),"^",20) //使用目的
	..q:AIMDr=""
	..Set AURDr=$p(^DHCAntBasePurposeDataConfigD(AIMDr),"^",6) //使用目的大类
	..q:AURDr=""				
	..Set Aur=$p(^DHCAntBasePurposeDataConfigD(AURDr),"^",4)
	..I Aur="ZL"  S isZL=1
	..I Aur="YF"  S isYF=1
	S RET=Used_"^"_isKSS1_$C(1)_isKSS2_$C(1)_isKSS3_$C(1)_isZL_$C(1)_isYF
	Q RET
}

/// Creator:	zsz
/// CreatDate:	2022-12-15
/// Desc:		获取抗菌药费用
/// w ##class(DHCMA.CPW.STAS.CommonSrv).GetAntiFee("1708")
ClassMethod GetAntiFee(AdmId As %String) As %String
{
	New (AdmId)
	Set return=0
	Quit:AdmId="" return
	q:'$d(^DHCWorkLoad(0,"PAADM",AdmId)) 0
	s AntiFee=0
	s WlRowid=0 f  s WlRowid=$O(^DHCWorkLoad(0,"PAADM",AdmId,WlRowid)) q:WlRowid=""  d
	.s oeori=$p(^DHCWorkLoad(WlRowid),"^",21)
	.;s mOeoriAntiFlag=$$GetOeoriAntiFlag^DHCWLBaseInforFunction(oeori)
	.s oeoid=+oeori
	.s oeosub=$p(oeori,"||",2)
	.q:oeosub=""
	.q:'$d(^OEORD(oeoid,"I",oeosub,1)) 	
	.s mDaupRowId=0
	.s mDaupRowId=$o(^DAUP("OEORI",oeori,mDaupRowId))
	.q:+$G(mDaupRowId)=0 
	.;q:mOeoriAntiFlag'=1
	.s Price=$p(^DHCWorkLoad(WlRowid),"^",16)
	.s AntiFee=AntiFee+Price
	
	set return=AntiFee
	
	Quit return
}

/// Creator:	zsz
/// CreatDate:	2022-12-15
/// Desc:		获取抗菌药使用天数
/// w ##class(DHCMA.CPW.STAS.CommonSrv).GetAntUseDrugDays("1708")
ClassMethod GetAntUseDrugDays(AdmId As %String) As %String
{
	New (AdmId)
	Set return=0
	q:AdmId="" return
	q:'$d(^DHCWorkLoad(0,"PAADM",AdmId)) return
	s AntUseDrugDays=0
	//k ^||TEMPDHCWL($j)
	k ^TMP($zn,$j,"GetAntUseDrugDays")
	
	s WlRowid=0 f  s WlRowid=$O(^DHCWorkLoad(0,"PAADM",AdmId,WlRowid)) q:WlRowid=""  d
	.s oeori=$p(^DHCWorkLoad(WlRowid),"^",21)
	.s oeoid=+oeori
	.s oeosub=$p(oeori,"||",2)
	.q:oeosub=""
	.q:'$d(^OEORD(oeoid,"I",oeosub,1)) 	
	.s mDaupRowId=0
	.s mDaupRowId=$o(^DAUP("OEORI",oeori,mDaupRowId))
	.q:+$G(mDaupRowId)=0 
	
	.s sttDate=$p($g(^OEORD(oeoid,"I",oeosub,1)),"^",9)  ;医嘱开始日期
	.s itemstaDR=$p(^OEORD(oeoid,"I",oeosub,1),"^",13) q:itemstaDR=""
	.s ordSta=$p(^OEC("OSTAT",itemstaDR),"^",1)
	.q:(ordSta="U")		;医嘱未核实
	.;s ^||TEMPDHCWL($j,"OEORI",oeori)=""
	.s ^TMP($zn,$j,"GetAntUseDrugDays","OEORI",oeori)=""
	
	s Oeori="" f  s Oeori=$O(^TMP($zn,$j,"GetAntUseDrugDays","OEORI",Oeori)) q:Oeori=""  d
	.s oeoid=+Oeori
	.s oeosub=$p(Oeori,"||",2)
	.s exOeordId=0 f  s exOeordId=$O(^OEORD(oeoid,"I",oeosub,"X",exOeordId)) q:exOeordId=""  d
	..s statu=$p(^OEORD(oeoid,"I",oeosub,"X",exOeordId),"^",16)
 	..q:statu'=1  										;1是核实，2是作废，4是停止
 	..s ExStDate=$p(^OEORD(oeoid,"I",oeosub,"X",exOeordId),"^",1)
 	..q:$d(^TMP($zn,$j,"GetAntUseDrugDays","Date",ExStDate))
 	..s AntUseDrugDays=AntUseDrugDays+1
 	..s ^TMP($zn,$j,"GetAntUseDrugDays","Date",ExStDate)=""
	
	set return=AntUseDrugDays
	
	k ^TMP($zn,$j,"GetAntUseDrugDays")
	Quit return
}

/// Creator：      	元琳
/// CreatDate：    	2022-12-28
/// Description： 	医务管理接口-根据就诊Id判断患者是否为非计划重返手术患者
/// Table：        	CIS_AN.OperSchedule
/// Input:		    EpisodeID
/// Return：       	患者是非计划重返手术患者,返回1_"^"_第一次非计划重返手术的非计划重返天数
/// Return：       	患者不是非计划重返手术患者,返回0
/// w ##class(CIS.AN.SRV.OperService).CheckReentryOperation()
ClassMethod CheckReentryOperation(EpisodeID As %String, newVersion As %String = "Y") As %String
{
	New (EpisodeID,newVersion)
	set flag=0
	if (newVersion="Y") {
		set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
		set opsCount=$l(opsIdStr,",")
		for i=1:1:opsCount
		{
			set opsId=$p(opsIdStr,",",i)
			continue:opsId=""
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			if (i=1) set lastOperDate=operSchedule.OperDate
			else  set lastOperDate=OperDate
			set OperDate=operSchedule.OperDate
			set ReentryOperation=operSchedule.ReentryOperation
			if (ReentryOperation="Y") {
				set duration=OperDate-lastOperDate
				set flag=1_"^"_duration
			}
			quit:ReentryOperation="Y"
		}
	}
	else {
		set opaId=""
		set num=0
        for  set opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.set num=num+1
		.set opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.if (num=1) set lastOperDate=opstdate
		.else  set lastOperDate=OperDate
		.set OperDate=opstdate
		.set opUnPlanedOperation=$P(^DHCANOPArrange(opaId),"^",46)	//非计划重返
		.if (opUnPlanedOperation="Y") d
		..set duration=OperDate-lastOperDate
		..set flag=1_"^"_duration
		.quit:opUnPlanedOperation="Y"
	}
	quit flag
}

}
