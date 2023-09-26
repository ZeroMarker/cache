/// 名称: web.DHCCPW.MR.ClinPathWayAnalysisBat
/// 描述: 临床路径统计分析
/// 编写者：zhufei
/// 编写日期: 2011-07-04
Class web.DHCCPW.MR.ClinPathWayAnalysisBat Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-07-01
/// Description:  批处理的方式处理统计数据
/// Table：       User.DHCMRClinPathWayAnalysis
/// Input：       DateFrom  开始日期(日期格式 2011-07-01)
///               DateTo 结束日期(日期格式 2011-07-01)
///               Paadm 就诊号
///               Type 是否重复处理数据 0-否、1-是
/// Return：      返回值 return>0:成功  return<0:失败
/// 
/// 自动任务批量处理数据：w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).BatchAnalysisData(+$h-1,+$h-1,"0")
/// 重复处理数据批处理任务：w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).BatchAnalysisData("2011-01-01","2011-07-01","1")
/// 补充处理数据批处理任务：w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).BatchAnalysisData("2011-01-01","2011-02-01","2")
ClassMethod BatchAnalysisData(aDateFrom As %String, aDateTo As %String, aType As %String)
{
	New (aDateFrom,aDateTo,aType)
	Set return=-1
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(+aType'=0)&&(+aType'=1)&&(+aType'=2) return
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set BatDate=$o(^DHCMR("CPWA-Batch","BatDate",""),-1)
	If BatDate="" {
		//设置初始批处理开始日期（首次执行此方法的开始时间）
		Set ^DHCMR("CPWA-Batch","BatDate",$zd(aDateFrom,3))=""
	}
	
	Set BatDateFrom=$o(^DHCMR("CPWA-Batch","BatDate",""))
	Set BatDateFrom=$zdh(BatDateFrom,3)
	Set BatDateTo=$o(^DHCMR("CPWA-Batch","BatDate",""),-1)
	Set BatDateTo=$zdh(BatDateTo,3)
	If +aType=0 {
		//自动任务处理统计数据
		Set:aDateFrom>BatDateTo aDateFrom=BatDateTo
		Set:aDateTo<aDateFrom aDateTo=aDateFrom
	}ElseIf +aType=1 {
		//强制重复处理统计数据
		//Set:aDateFrom<BatDateFrom aDateFrom=BatDateFrom
		//Set:aDateTo>BatDateTo aDateTo=BatDateTo
	}Else {
		//补充处理统计数据
		Set:aDateFrom<BatDateFrom aDateFrom=BatDateFrom
		Set:aDateTo>BatDateTo aDateTo=BatDateTo
	}
	
	Set Count=0
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=aDateFrom:1:aDateTo {
		//自动任务处理统计数据：记录已处理日期
		Set:+aType=0 ^DHCMR("CPWA-Batch","BatDate",$zd(DischDate,3))=""
		Set:+aType=2 ^DHCMR("CPWA-Batch","BatDate",$zd(DischDate,3))=""
		
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"  //退院状态过滤
			Continue:$p(AdmInfo,"^",6)=""    //入院日期为空过滤
			
			//自动任务处理统计数据：不重复处理数据筛查、记录处理数据记录数
			If +aType=0 {
				Set AnaID=$o(^DHCMRi("CPWA",0,"IndexPaadm",Paadm,0))
				Continue:AnaID'=""  //不重复处理数据
				Set num=$i(^DHCMR("CPWA-Batch","BatDate",$zd(DischDate,3),"Count"))  //记录处理数据记录数
			}
			If +aType=2 {
				Set AnaID=$o(^DHCMRi("CPWA",0,"IndexPaadm",Paadm,0))
				Set:AnaID="" num=$i(^DHCMR("CPWA-Batch","BatDate",$zd(DischDate,3),"Count"))  //记录处理数据记录数
			}
			Set flg=..GetDataByPaadm(Paadm,+aType)  //按就诊处理统计数据
			Set:flg>0 Count=Count+1
			w "Paadm="_Paadm_",flg="_flg,!
		}
	}
	
	//预出院、召回病人，重复导入
	Set AdmStatus=""
	For {
		Set AdmStatus=$o(^DHCMRi("CPWA",0,"IndexAdmStatus",AdmStatus))
		Quit:AdmStatus=""
		Continue:AdmStatus="D"
		Set Rowid=0
		For {
			Set Rowid=$o(^DHCMRi("CPWA",0,"IndexAdmStatus","A",Rowid))
			Quit:Rowid=""
			Set AnaInfo=$g(^DHCMR("CPWA",Rowid))
			Continue:AnaInfo=""
			Set Paadm=$list(AnaInfo,2)
			Set flg=..GetDataByPaadm(Paadm,1)  //按就诊处理统计数据
			Set:flg>0 Count=Count+1
			w "Paadm="_Paadm_",flg="_flg,!
		}
	}
	
	//错误就诊记录，重复导入
	//程序异常结果存在: ^DHCMR("CPWA-Batch","PaadmErr",Paadm)=ErrorInfo
	Set Paadm=0
	For {
		Set Paadm=$o(^DHCMR("CPWA-Batch","PaadmErr",Paadm))
		Quit:Paadm=""
		Set flg=..GetDataByPaadm(Paadm,1)  //按就诊处理统计数据
		Set:flg>0 Count=Count+1
		w "Paadm="_Paadm_",flg="_flg,!
	}
	Set return=Count
	
	Quit return
}

ClassMethod GetDataByPaadm(aPaadm As %String, aType As %String) As %String
{
	New (aPaadm,aType)
	Set return=-1
	Quit:aPaadm="" return
	Quit:(+aType'=0)&&(+aType'=1)&&(+aType'=2) return
	
	Set $ZT="GetDataByPaadmErr"
	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	
	Set (AdmStatus,AdmitDate,DischDate,CPWDID,Diagnos)=""
	Set (OutStatus,IsInHospInf,IsOperPat,OperDate,IsOperInf)=""
	Set (HospCost,DrugCost,LabCost,CheckCost,PharmacyCost)=""
	Set (PharmacyDays,Is3Pharmacy,CPWLoc,PathWayID,TimesOperFlag)=""
	Set (RegLocID,RegWardID,DischLocID,DischWardID)=""
	
	Set AdmInfo=$g(^PAADM(+aPaadm))
	Quit:$p(AdmInfo,"^",2)'="I" return
	
	//在院/出院(Admit/Dischage)
	Set AdmStatus=$p(AdmInfo,"^",20)
	Quit:AdmStatus="C" return
	Set:AdmStatus'="D" AdmStatus="A"
	
	//入院日期
	//Set AdmitDate=$p(AdmInfo,"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(aPaadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Quit:AdmitDate="" return
	
	//出院日期
	//Set DischDate=$p(AdmInfo,"^",17)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(aPaadm)
	Set DischDate=$p(DischDateTime,"^",1)	
	If DischDate="" {
		Set AdmStatus="A"
	} Else {
		If DischDate>=(+$h+1) {
			Set AdmStatus="A"
		}
	}
	
	Set AnaRowid=$o(^DHCMRi("CPWA",0,"IndexPaadm",aPaadm,0))
	If AnaRowid="" {
		Set obj=##Class(User.DHCMRClinPathWayAnalysis).%New()
	}Else{
		Set obj=##Class(User.DHCMRClinPathWayAnalysis).%OpenId(AnaRowid)
	}
	Quit:'$IsObject(obj) return
	
	//出院情况(治愈/好转/死亡)
	Set OutStatus=obj.CPWAOutStatus
	If (aType=1)||(OutStatus="") {
		Set DisPatOutStatusEPRCode=""
		Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("DisPatOutStatusEPRCode")
		If $IsObject(objConfig){
			Set DisPatOutStatusEPRCode=objConfig.BCValue
		}
		If DisPatOutStatusEPRCode'="" {
			Set OutStatus=..getEPROutStatus(aPaadm,DisPatOutStatusEPRCode,.ArrGlossary)
		}Else{
			Set OutStatus=..getOutStatus(aPaadm)
		}
		
		Set:OutStatus="" OutStatus=..getOutStatus(aPaadm)
		Set:OutStatus="" OutStatus="其他"
	}
	
	//是否院感患者(Y/N)
	Set IsInHospInf=obj.CPWAIsInHospInf
	If (aType=1)||(IsInHospInf="") {
		Set IsInHospInf=..getIsInHospInf(aPaadm)
	}
	
	//是否手术患者(Y/N)、手术日期(第一次)
	Set IsOperPat=obj.CPWAIsOperPat
	Set OperDate=obj.CPWAOperDate
	If (aType=1)||(IsOperPat="")||(OperDate="") {
		Set operInfo=..getOperInfo(aPaadm)
		If operInfo'="" {
			Set IsOperPat=$list(operInfo,1)
			Set OperDate=$list(operInfo,2)
		}
	}
	
	//是否手术部位感染患者(第一次)(Y/N)
	Set IsOperInf=obj.CPWAIsOperInf
	If (aType=1)||(IsOperInf="") {
		Set IsOperInf=..getIsOperInf(aPaadm)
	}
	
	//住院费用、住院药费、检验费用、检查费用
	Set HospCost=+obj.CPWAHospCost
	Set DrugCost=+obj.CPWADrugCost
	Set LabCost=+obj.CPWALabCost
	Set CheckCost=+obj.CPWACheckCost
	Set MaterialCost=+obj.CPWAMaterialCost
	Set ProprMedCost=+obj.CPWAProprMedCost
	Set HerbalMedCost=+obj.CPWAHerbalMedCost
	Set WesternMedCost=+obj.CPWAWesternMedCost
	Set TherapyCost=+obj.CPWATherapyCost
	Set ChTherapyCost=+obj.CPWAChTherapyCost
	Set CharaTherapyCost=+obj.CPWACharaTherapyCost
	Set IsPiecesMed=obj.CPWAIsPiecesMed
	Set IsProprMed=obj.CPWAIsProprMed
	Set IsCharaTherapy=obj.CPWAIsCharaTherapy
	If (aType=1)||(HospCost=0) {
		Set costInfo=..getCostInfo(aPaadm)
		If costInfo'="" {
			Set HospCost=$list(costInfo,1)                        //总费用
			Set DrugCost=$list(costInfo,2)                        //总药费
			Set LabCost=$list(costInfo,3)                         //检验费
			Set CheckCost=$list(costInfo,4)                       //检查费
			Set MaterialCost=$list(costInfo,5)                    //材料费
			Set ProprMedCost=$list(costInfo,6)                    //中成药
			Set HerbalMedCost=$list(costInfo,7)                   //中草药
			Set WesternMedCost=$list(costInfo,8)                  //西药费
			Set TherapyCost=$list(costInfo,9)                     //治疗费
			Set ChTherapyCost=$list(costInfo,10)                  //中医治疗费
			Set CharaTherapyCost=$list(costInfo,11)               //中医特色疗法费
			Set IsPiecesMed=$s(HerbalMedCost>0:"Y",1:"N")         //中药饮片[是/否]    =中草药
			Set IsProprMed=$s(ProprMedCost>0:"Y",1:"N")           //中成药[是/否]
			Set IsCharaTherapy=$s(CharaTherapyCost>0:"Y",1:"N")   //中医特色疗法[是/否]
		}
	}
	
	// 抗生素取值模式 zhaoyu 2013-05-20
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("CPWMonRepPharmacyType")
	Set PharmacyType=""
	Set:$IsObject(objConfig) PharmacyType=objConfig.BCValue	// 1-上了抗菌药物 ;other-没上
	
	// 医嘱模式：是否使用新长期医嘱（medtrak版本号） zhaoyu 2013-05-30
	set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("OEOrderType")
	Set OEOrderType=""
	Set:$IsObject(objConfig) OEOrderType=objConfig.BCValue	// 1-新长期医嘱 ;other-原医嘱模式
	
	Set OEOrderType=$s(+OEOrderType=1:7,1:0)
	
	// 抗生素使用情况 ( 使用_"^"_一线_$c(1)_二线_$c(1)_三线_$c(1)_治疗_$c(1)_预防 )
	// Add by zhaoyu 2013-05-24
	Set tmpCPWAPharmacyInfo=..GetPatAntInfoById(aPaadm)
	Set CPWAPharmacyInfo=obj.CPWAPharmacyInfo
	If (aType=1)||(CPWAPharmacyInfo="") {
		If (+PharmacyType=1) {
			Set CPWAPharmacyInfo=tmpCPWAPharmacyInfo
		} Else {
			Set CPWAPharmacyInfo="0^0"_$c(1)_"0"_$c(1)_"0"_$c(1)_"0"_$c(1)_"0"	//
		}
	}
	
	//抗生素费用、抗生素使用天数
	Set PharmacyCateg="",PharmacySubCat=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("PharmacyCateg")
	If $IsObject(objConfig){
		Set PharmacyCateg=objConfig.BCValue
	}
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("PharmacySubCat")
	If $IsObject(objConfig){
		Set PharmacySubCat=objConfig.BCValue
	}
	Set PharmacyCost=obj.CPWAPharmacyCost
	Set PharmacyDays=obj.CPWAPharmacyDays
	If (aType=1)||(PharmacyCost="")||(PharmacyDays="") {
		// Modified by zhaoyu 2013-05-24 费用&天数
		If (+PharmacyType=1) {
			Set KjxxInfo=..GetKjxxByadmId(aPaadm,OEOrderType)	// zhaoyu 2013-05-30 OEOrderType
			If (KjxxInfo'=0) {
				Set PharmacyCost=$p(KjxxInfo,"^",1)
				Set PharmacyDays=$p(KjxxInfo,"^",2)
			}
		} Else {
			Set pharmacyInfo=..getPharmacyInfo(aPaadm,PharmacyCateg,PharmacySubCat)
			If pharmacyInfo'="" {
				Set PharmacyCost=$list(pharmacyInfo,1)
				Set PharmacyDays=$list(pharmacyInfo,2)
			}
		}
	}
	
	//预防抗菌药物使用患者标记
	Set IsPreDrugFlag=obj.CPWAIsPreDrugFlag
	If (aType=1)||(IsPreDrugFlag="") {
		If (+PharmacyType=1) {
			Set IsPreDrugFlag=$s($p(tmpCPWAPharmacyInfo,$c(1),5)=1:"Y",1:"N")
		} Else {
			Set IsPreDrugFlag=..getIsPreDrugFlag(aPaadm,PharmacyCateg,PharmacySubCat)
		}
	}
	
	//是否三线抗生素患者(Y/N)
	Set PharmacyCateg3="",PharmacySubCat3=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("PharmacyCateg3")
	If $IsObject(objConfig){
		Set PharmacyCateg3=objConfig.BCValue
	}
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("PharmacySubCat3")
	If $IsObject(objConfig){
		Set PharmacySubCat3=objConfig.BCValue
	}
	Set Is3Pharmacy=obj.CPWAIs3Pharmacy
	If (aType=1)||(Is3Pharmacy="") {
		If (+PharmacyType=1) {
			Set Is3Pharmacy=$s($p(tmpCPWAPharmacyInfo,$c(1),3)=1:"Y",1:"N")
		} Else {
			Set Is3Pharmacy=..getIs3Pharmacy(aPaadm,PharmacyCateg3,PharmacySubCat3)
		}
	}
	
	//病种/路径、诊断ICD+诊断描述、出入径记录、路径科室、入院出院信息
	Set CPWDID=obj.CPWACPWDID
	Set Diagnos=obj.CPWADiagnos
	Set PathWayID=obj.CPWAPathWayID
	Set CPWLoc=obj.CPWACPWLoc
	Set RegLocID=obj.CPWARegLocID
	Set RegWardID=obj.CPWARegWardID
	Set DischLocID=obj.CPWADischLocID
	Set DischWardID=obj.CPWADischWardID
	If (aType=1)||(CPWDID="")||(Diagnos="")||(PathWayID="")||(CPWLoc="")
	||(RegLocID="")||(RegWardID="")||(DischLocID="")||(DischWardID="")
	{
		Set GetCPWICDType=""
		Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("GetCPWICDType")
		If $IsObject(objConfig){
			Set GetCPWICDType=objConfig.BCValue
		}
		Set diagInfo=..getDiagInfo(aPaadm,GetCPWICDType)
		If diagInfo'="" {
			Set CPWDID=$list(diagInfo,1)
			Set Diagnos=$list(diagInfo,2)
		}
		Set pathwayInfo=..getPathWayInfo(aPaadm)
		If pathwayInfo'="" {
			Set CPWDID=$list(pathwayInfo,1)
			Set PathWayID=$list(pathwayInfo,2)
			//Set CPWLoc=$list(pathwayInfo,4)	//Note by zhaoyu 2013-01-07
			Set CPWLoc=$list(pathwayInfo,5)	//zhaoyu 2013-01-07 批处理数据科室ID不正确
			Set:PathWayID="" CPWLoc=""
		}
		Set admitInfo=..getAdmitInfo(aPaadm)
		If admitInfo'="" {
			Set RegLocID=$list(admitInfo,1)
			Set RegWardID=$list(admitInfo,2)
			Set DischLocID=$list(admitInfo,3)
			Set DischWardID=$list(admitInfo,4)
		}
		//Set:CPWLoc="" CPWLoc=DischLocID	//Note by zhaoyu 2013-01-07
		Set:(CPWLoc="")||(+CPWLoc=0) CPWLoc=DischLocID	//zhaoyu 2013-01-07 若科室ID不正确，批处理数据后科室ID没被覆盖
	}
	
	//非计划重返手术室标记(Y/N)
	Set TimesOperFlag=obj.CPWATimesOperFlag
	If (aType=1)||(TimesOperFlag="") {
		Set TimesOperFlag=..getTimesOperFlag(aPaadm)
	}
	
	//再住院患者标记
	Set IsTimesInHospFlag=+obj.CPWAIsTimesInHospFlag
	If (aType=1)||(IsTimesInHospFlag<1) {
		Set IsTimesInHospFlag=..GetTimesInHospDays(aPaadm)
	}
	
	//出现常见并发症患者标记
	Set IsComplicationFlag=""
	
	Set obj.CPWAPaadm=aPaadm
	Set obj.CPWAAdmStatus=AdmStatus
	Set obj.CPWADiagnos=Diagnos
	Set obj.CPWACPWDID=CPWDID
	Set obj.CPWAAdmitDate=AdmitDate
	Set obj.CPWADischDate=DischDate
	Set obj.CPWAOutStatus=OutStatus
	Set obj.CPWAIsInHospInf=IsInHospInf
	Set obj.CPWAIsOperPat=IsOperPat
	Set obj.CPWAOperDate=OperDate
	Set obj.CPWAIsOperInf=IsOperInf
	Set obj.CPWAHospCost=HospCost
	Set obj.CPWADrugCost=DrugCost
	Set obj.CPWALabCost=LabCost
	Set obj.CPWACheckCost=CheckCost
	Set obj.CPWAMaterialCost=MaterialCost
	Set obj.CPWAProprMedCost=ProprMedCost
	Set obj.CPWAHerbalMedCost=HerbalMedCost
	Set obj.CPWAWesternMedCost=WesternMedCost
	Set obj.CPWATherapyCost=TherapyCost
	Set obj.CPWAChTherapyCost=ChTherapyCost
	Set obj.CPWACharaTherapyCost=CharaTherapyCost
	Set obj.CPWAIsPiecesMed=IsPiecesMed
	Set obj.CPWAIsProprMed=IsProprMed
	Set obj.CPWAIsCharaTherapy=IsCharaTherapy
	Set obj.CPWAPharmacyCost=PharmacyCost
	Set obj.CPWAPharmacyDays=PharmacyDays
	Set obj.CPWAIs3Pharmacy=Is3Pharmacy
	Set obj.CPWACPWLoc=CPWLoc
	Set obj.CPWAPathWayID=PathWayID
	Set obj.CPWARegLocID=RegLocID
	Set obj.CPWARegWardID=RegWardID
	Set obj.CPWADischLocID=DischLocID
	Set obj.CPWADischWardID=DischWardID
	Set obj.CPWATimesOperFlag=TimesOperFlag
	Set obj.CPWAIsPreDrugFlag=IsPreDrugFlag
	Set obj.CPWAIsTimesInHospFlag=IsTimesInHospFlag
	Set obj.CPWAIsComplicationFlag=IsComplicationFlag
	Set obj.CPWAPharmacyInfo=CPWAPharmacyInfo	// Add by zhaoyu 2013-05-24 抗生素使用情况
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Set ^DHCMR("CPWA-Batch","PaadmErr",+aPaadm)="Save Error!"
   		Set return=-1
	} Else {
		Kill ^DHCMR("CPWA-Batch","PaadmErr",+aPaadm)
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
GetDataByPaadmErr
	Set $ZT=""
	Set ^DHCMR("CPWA-Batch","PaadmErr",+aPaadm)=$ZERROR
	Set return=-1
	Quit return
}

/// 病种/路径、诊断ICD+诊断描述
/// 根据类型判断入院诊断是否符合临床路径准入标准ICD
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getDiagInfo("7030408","2")
ClassMethod getDiagInfo(argPaadm As %String, aDiagType As %String) As %List
{
	New (argPaadm,aDiagType)
	Set return=""
	Quit:argPaadm="" return
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argPaadm)
	Quit:MRAdm="" return
	
	Set CPWDID="",MRICD10="",MRICDDesc="",OperICD="",OperName=""
	
	/* update by zf 20120723
	Set LogID=$o(^DHCMRi("LOG",0,"PaadmIndex",+argPaadm,""),-1)
	Set objLog=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetObjById(LogID)
	If $IsObject(objLog)
	{
		Set MRCICDDxID=objLog.MRCICDRowid
		Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
		Set MRICD10=$p(tmpICD,"^",4)
		Set MRICDDesc=$p(tmpICD,"^",3)
		Set CPWID=objLog.NoticePathWayVerID
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(CPWID)
		If $IsObject(objPathWay)
		{
			If $IsObject(objPathWay.CPWPathwayDR)
			{
				If $IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR) 
				{
					Set CPWDID=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
				}
			}
		}
	}
	*/
	
	//入院日期
	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(argPaadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Quit:AdmitDate="" return
	
	//出院日期
	Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(argPaadm)
	Set DischDate=$p(DischDateTime,"^",1)	
	Set:DischDate="" DischDate=+$h
		
	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	
	//通过诊断来判断是否临床路径患者
	If CPWDID=""
	{
		
		Set LocationDR=$p($g(^PAADM(argPaadm)),"^",4)
		
		Set GetCPWICDType=aDiagType
		If GetCPWICDType=1 {
			//通过临床诊断的第一主要诊断来判断
			Set MRDiagnos=0
			For {
				Set MRDiagnos=$o(^MR(MRAdm,"DIA",MRDiagnos))
				Quit:MRDiagnos=""
				Quit:MRICDDesc'=""  //取到符合标准的数据就退出（只取第一个符合的诊断）
				
				Set TypeDicCode=""
				Set MRDiagType=$o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",0))
				If MRDiagType'="" {
					Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",MRDiagType)),"^",1)
					Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
				}
				Continue:TypeDicCode'="M" //Main(M)为主要诊断类型
				
				Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
				Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
				Set ICD10=$p(tmpICD,"^",4)
				Set ICDDesc=$p(tmpICD,"^",3)
				Continue:ICDDesc=""
				Set MRICD10=ICD10
				Set MRICDDesc=ICDDesc
			}
		} ElseIf GetCPWICDType=2 {
			//通过电子病历诊断的第一诊断来判断
			Set EPRDiagnosICD10Code=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("MRDiagnosICD10EPRCode")
			Set EPRDiagnosDescCode=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("MRDiagnosDescEPRCode")
			Set MRICD10=..getEPRValue(argPaadm,EPRDiagnosICD10Code,.ArrGlossary)
			Set MRICDDesc=..getEPRValue(argPaadm,EPRDiagnosDescCode,.ArrGlossary)
		} ElseIf GetCPWICDType=3 {
			//通过临床诊断的第一入院主诊断来判断
			Set MRDiagnos=0
			For {
				Set MRDiagnos=$o(^MR(MRAdm,"DIA",MRDiagnos))
				Quit:MRDiagnos=""
				Quit:MRICDDesc'=""  //取到符合标准的数据就退出（只取第一个符合的诊断）
				
				Set TypeDicCode=""
				Set MRDiagType=$o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",0))
				If MRDiagType'="" {
					Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",MRDiagType)),"^",1)
					Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
				}
				Continue:TypeDicCode'="PRE" //PRE 为入院主诊断代码
				
				Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
				Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
				Set ICD10=$p(tmpICD,"^",4)
				Set ICDDesc=$p(tmpICD,"^",3)
				Continue:ICDDesc=""
				Set MRICD10=ICD10
				Set MRICDDesc=ICDDesc
			}
		} Else{
			//无主要诊断 通过临床诊断的第一诊断来判断
			Set MRDiagnos=0
			For {
				Set MRDiagnos=$o(^MR(MRAdm,"DIA",MRDiagnos))
				Quit:MRDiagnos=""
				Quit:MRICDDesc'=""  //取到符合标准的数据就退出（只取第一个符合的诊断）
				
				Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
				Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
				Set ICD10=$p(tmpICD,"^",4)
				Set ICDDesc=$p(tmpICD,"^",3)
				Continue:ICDDesc=""
				Set MRICD10=ICD10
				Set MRICDDesc=ICDDesc
			}
		}
		
		Set OperationICDEPRCode=""
		Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("OperationICDEPRCode")
		If $IsObject(objConfig){
			Set OperationICDEPRCode=objConfig.BCValue
		}
		If OperationICDEPRCode'="" {
			Set OperICD=..getEPRValue(argPaadm,OperationICDEPRCode,.ArrGlossary)
		}
		Set OperationNameEPRCode=""
		Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("OperationNameEPRCode")
		If $IsObject(objConfig){
			Set OperationNameEPRCode=objConfig.BCValue
		}
		If OperationNameEPRCode'="" {
			Set OperName=..getEPRValue(argPaadm,OperationNameEPRCode,.ArrGlossary)
		}
		
		//判断此诊断符合哪条路径的准入标准,根据准入ICD来判断
		If MRICD10'="" {
			Set CPWID=0
			For {
				;Set CPWID=$o(^DHCMRC("CPWD",CPWID)) 
				Set CPWID=$o(^DHCMRC("CPW",CPWID))
				Quit:CPWID=""
				Quit:CPWDID'=""  //找到符合的病种
				
				Set (CPWDesc,CPWICD,CurrCPWDID,CurrVersion)=""
				Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
				If $IsObject(objCPW) {
					Set CPWDesc=objCPW.CPWDesc
					Set CPWICD=objCPW.CPWICD
					Set CPWKeys=objCPW.CPWKeys
					Set CPWOperICD=objCPW.CPWOperICD
					Set CPWOperKeys=objCPW.CPWOperKeys
					If $IsObject(objCPW.CPWCPWDicDR) {
						Set CurrCPWDID=objCPW.CPWCPWDicDR.%Id()
						Set CurrVersion=objCPW.CPWCPWDicDR.CPWDVersion
						Set IsActive=objCPW.CPWCPWDicDR.CPWDActive
						Set DateFrom=objCPW.CPWCPWDicDR.CPWDDateFrom
						Set DateTo=objCPW.CPWCPWDicDR.CPWDDateTo
						Continue:IsActive'["Y"
						Continue:(DateFrom'="")&&(DateFrom>DischDate)
						Continue:(DateTo'="")&&(DateTo<AdmitDate)
					}
				}
				Continue:CurrVersion'=CPWID
				Continue:CPWICD=""
				Continue:'$d(^DHCMRCi("DEPCPW",0,"IndexCPW",CurrCPWDID," "_LocationDR))
				
				Set flg1=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(MRICD10,CPWICD)
				//Continue:flg1<=0
				Set flg2=0
				If (CPWKeys'="")&&(MRICDDesc'="")
				{
					Set flg2=##Class(web.DHCCPW.MR.SysBaseSrv).CheckKeysArea(MRICDDesc,CPWKeys)
					//Continue:flg2<=0
				}
				Continue:(flg1<=0)&&(flg2<=0)
				If (CPWOperICD'="")&&(OperICD'="")
				{
					Set flg1=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(OperICD,CPWOperICD)
					Continue:flg1<=0
				}
				If (CPWOperKeys'="")&&(OperName'="")
				{
					Set flg2=##Class(web.DHCCPW.MR.SysBaseSrv).CheckKeysArea(OperName,CPWOperKeys)
					Continue:flg2<=0
				}
				
				Set CPWDID=CurrCPWDID
			}
		}
	}
	
	Set MRICDInfo=MRICD10_"/"_MRICDDesc_"/"_OperICD_"/"_OperName
	Set return=$lb(CPWDID,MRICDInfo)
	
	Quit return
}

/// 出院情况(治愈/好转/死亡)
ClassMethod getOutStatus(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
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

/// 电子病历出院情况
/// #TYPE:Simple#TID:2#TVER:0#SCODE:O0024#VTYPE:V
ClassMethod getEPROutStatus(argPaadm As %String, argCode As %String, ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (argPaadm,argCode,ArrGlossary)
	Set return=""
	Quit:(argPaadm="")||(argCode="") return
	
	//Set DischCondDesc=##class(EPRservice.BOScatterData).GetEPRData(argPaadm,argCode)
	Set DischCondDesc=..GetEPRData(argPaadm,argCode,.ArrGlossary)
	Quit:DischCondDesc="" return
	Set:DischCondDesc["痊愈" DischCondDesc="治愈"
	Set:DischCondDesc["治愈" DischCondDesc="治愈"
	Set:DischCondDesc["好转" DischCondDesc="好转"
	Set:DischCondDesc["已故" DischCondDesc="死亡"
	Set:DischCondDesc["死亡" DischCondDesc="死亡"
	Set:(DischCondDesc'="治愈")&&(DischCondDesc'="好转")&&(DischCondDesc'="死亡") DischCondDesc="其他"
	Set return=DischCondDesc
	
	Quit return
}

/// 取电子病历单元
/// #TYPE:Simple#TID:2#TVER:0#SCODE:O0024#VTYPE:V
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getEPRValue(892,"HDSD00.11.056",.ArrGlossary)
ClassMethod getEPRValue(argPaadm As %String, argCode As %String, ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (argPaadm,argCode,ArrGlossary)
	Set return=""
	Quit:(argPaadm="")||(argCode="") return	
	//Set return=##class(EPRservice.BOScatterData).GetEPRData(argPaadm,argCode)
	Set return=..GetEPRData(argPaadm,argCode,.ArrGlossary)
	Quit return
}

/// Description:  判断2版还是3版电子病历,返回Integer  return>0:表示二版电子病历
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).GetOldRecCount(892)
ClassMethod GetOldRecCount(aEpisodeID As %String) As %Integer
{
	New (aEpisodeID)
	Quit:aEpisodeID="" -1
	
	Set $ZT="GetOldRecCountErr"
	Set return=##Class(EMRservice.BL.BLScatterData).GetOldRecCount(aEpisodeID)
	Quit return
	
GetOldRecCountErr
	Kill SLQCODE
	Set ECRecordCnt=-1
	&SQL(select count(*) into :ECRecordCnt from EPRinstance.ECRecord where EpisodeID = :aEpisodeID)
	Quit ECRecordCnt
}

/// Description:  术语集取东华电子病历首页数据接口
/// Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
/// w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).GetEPRData(892,"HDSD00.11.056",.ArrGlossary)
ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,ArrGlossary)
	Set return=""
	Quit:(aEpisodeID="")||(aElCode="") return
	
	Set $ZT="GetEPRDataNewErr"
	
	Set Count=..GetOldRecCount(aEpisodeID)
	If Count>0 {
		//二版电子病历，GetEPRData方法即可通过模板单元调用，也可通过术语集调用
		Set return=##class(EPRservice.BOScatterData).GetEPRData(aEpisodeID,aElCode)
		
		//二版电子病历，GetDataByGlossary方法为术语集调用接口
		//Set return=##Class(EPRservice.BOScatterData).GetDataByGlossary(aEpisodeID,aElCode)
	} Else {
		//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
		Set Category=$e(aElCode,1,9)
		Quit:Category="" return
		
		If ArrGlossary.GetAt(Category)'=aEpisodeID {
			Set ArrGlossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,Category)
			Do ArrGlossary.SetAt(aEpisodeID,Category)
		}
		Set return=ArrGlossary.GetAt(aElCode)
		
	}
	Quit return
	
GetEPRDataNewErr
	Quit ""
}

/// 是否院感患者(Y/N)
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getIsInHospInf(2074945)
ClassMethod getIsInHospInf(argPaadm As %String) As %String
{
	New (argPaadm)
	Set ret=""
	Quit:(+argPaadm=0) ret
	Set InfRepID=0,IsInHospInf="N"
	For {
		Set InfRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",argPaadm,InfRepID))
		Quit:(+InfRepID=0)!(IsInHospInf="Y")
		Set objInfRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(InfRepID)
		Set ReportStatusDR=objInfRep.ReportStatus
		Continue:'$IsObject(ReportStatusDR)
		Set Description=ReportStatusDR.Description
		Continue:Description'="审核"
		Set IsInHospInf="Y"
	}
	Set ret=IsInHospInf
	Quit ret
	/*New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set InfID=0,IsInHospInf="N"
	For {
		Set InfID=$o(^DHCMedIR(0,"PAADM",argPaadm,InfID))
		Quit:(InfID="")||(IsInHospInf="Y")
		
		Set RepStatus=$p($g(^DHCMedIR(InfID)),"^",11)
		Continue:RepStatus["0"
		//Set RepPlace=$p($g(^DHCMedIR(InfID)),"^",16)
		//Set:RepPlace'="" RepPlace=$o(^DHCMDIC("0","TypeCode","InfectionRepPlace",RepPlace,0))
		//Set:RepPlace'="" RepPlace=$p($g(^DHCMDIC(RepPlace)),"^",2)
		//Continue:RepPlace["社区"
		Set IsInHospInf="Y"
	}
	Set InfID=0,InfType=1
	For {
		Set InfID=$o(^DHCMed.INF.ReportI("TypePaadm"," "_InfType,argPaadm,InfID))
		Quit:(InfID="")||(IsInHospInf="Y")
		
		Set RepStatus=""
		Set InfReport=$g(^DHCMed.INF.ReportD(InfID))
		Set:InfReport'="" RepStatus=$list(InfReport,6)
		Set:RepStatus'="" RepStatus=$o(^DHCMed.SS.DictionaryI("IdxofTypeCode"," "_$ZCVT(RepStatus,"U")," "_$ZCVT("InfectionReportStatus","U"),0))
		If RepStatus'=""
		{
			Set RepStatusLS=$g(^DHCMed.SS.DictionaryD(RepStatus))
			Set:RepStatusLS'="" RepStatus=$list(RepStatusLS,4)
		}
		Continue:(RepStatus'["审")&&(RepStatus'["订")
		
		Set IsInHospInf="Y"
	}
	Set return=IsInHospInf
	
	Quit return*/
}

/// 是否手术患者(Y/N)、手术日期(第一次)
ClassMethod getOperInfo(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
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
	Set return=$lb(IsOperPat,OperDate)
	
	Quit return
}

/* update by zf 20110708
/// 是否手术部位感染患者(Y/N)
/// 从院感报告中手术感情情况判断
ClassMethod getIsOperInf(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set InfID=0,IsOperInf="N"
	For {
		Set InfID=$o(^DHCMedIR(0,"PAADM",argPaadm,InfID))
		Quit:InfID=""
		Quit:IsOperInf="Y"
		
		Set RepStatus=$p($g(^DHCMedIR(InfID)),"^",11)
		Continue:RepStatus["0"
		
		Set SubID=0
		For {
			Set SubID=$o(^DHCMedIR(InfID,"O",SubID))
			Quit:SubID=""
			Quit:IsOperInf="Y"
			
			Set CuteInfFlag=$p($g(^DHCMedIR(InfID,"O",SubID)),"^",11)
			Set InfectionFlag=$p($g(^DHCMedIR(InfID,"O",SubID)),"^",13)
			Continue:(CuteInfFlag'="Y")&&(InfectionFlag'="Y")
			Set IsOperInf="Y"
		}
	}
	Set return=IsOperInf
	
	Quit return
}
*/
/// 是否手术部位感染患者(Y/N)
/// 从院感报告中手术感情情况判断
ClassMethod getIsOperInf(argPaadm As %String) As %String
{
	New (argPaadm)
	Set ret=""
	Quit:(+argPaadm=0) ret
	Set InfRepID=0,IsOperInf="N"
	For {
		Set InfRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",argPaadm,InfRepID))
		Quit:(+InfRepID=0)!(IsOperInf="Y")
		Set objInfRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(InfRepID)
		Set ReportStatusDR=objInfRep.ReportStatus
		Continue:'$IsObject(ReportStatusDR)
		Set Description=ReportStatusDR.Description
		Continue:Description'="审核"
		Set InfOprID=0
		For {
			Set InfOprID=$o(^DHCMed.NINF("InfRep",InfRepID,"Opr",InfOprID))
			Quit:(+InfOprID=0)!(IsOperInf="Y")
			Set objInfOpr=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(InfRepID_"||"_InfOprID)
			Continue:'$IsObject(objInfOpr)
			Set InHospInfFlagDR=objInfOpr.InHospInfFlag
			Continue:'$IsObject(InHospInfFlagDR)
			Set InHospInfFlag=InHospInfFlagDR.Description
			Continue:InHospInfFlag'="是"
			Set IsOperInf="Y"
		}
	}
	Set ret=IsOperInf
	Quit ret
	/*New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set InfID=0,IsOperInf="N"
	For {
		Set InfID=$o(^DHCMedIR(0,"PAADM",argPaadm,InfID))
		Quit:InfID=""
		Quit:IsOperInf="Y"
		
		Set RepStatus=$p($g(^DHCMedIR(InfID)),"^",11)
		Continue:RepStatus["0"
		
		Set SubID=0
		For {
			Set SubID=$o(^DHCMedIR(InfID,"P",SubID))
			Quit:SubID=""
			Quit:IsOperInf="Y"
			
			Set InfPos=$p($g(^DHCMedIR(InfID,"P",SubID)),"^",1)
			Set:InfPos'="" InfPos=$p($g(^DHCMPOS(+InfPos)),"^",2)
			Continue:InfPos=""
			Continue:(InfPos'["表浅切口")&&(InfPos'["深度切口")&&(InfPos'["器官/腔隙")
			Set IsOperInf="Y"
		}
	}
	Set return=IsOperInf
	
	Quit return*/
}

/// 住院费用、住院药费、检验费用、检查费用
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getCostInfo(7185729)
ClassMethod getCostInfo(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	//总费用、药费、检验费、检查费、材料费
	Set CountCost=0,DrugCost=0,LabCost=0,CheckCost=0,MaterialCost=0
	//中成药、中草药、西药、治疗费
	Set ProprMedCost=0,HerbalMedCost=0,WesternMedCost=0,TherapyCost=0
	//中医治疗费、中医特色疗法费
	Set ChTherapyCost=0,CharaTherapyCost=0

	//普通方式通过计费提供接口取费用
	Set strCateFee=##class(web.DHCCPW.MR.Interface).GetAdmCateFees(argPaadm)
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

	/* update by zf 2012-07-09
	//北京中医院取费用方法
	//调用电子病历首页取费用接口
	Set strCateFee=..InPatCostTrakCareSubNew(argPaadm,"")
	For Index=1:1:$l(strCateFee,"!")
	{
		Set Fee=$p(strCateFee,"!",Index)
		//总费用
		Set:$p(Fee,"^",1)="Total" CountCost=CountCost+$p(Fee,"^",3)
		//总药费
		Set:$p(Fee,"^",1)="15" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="16" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="17" DrugCost=DrugCost+$p(Fee,"^",3)
		//化验费
		Set:$p(Fee,"^",1)="6" LabCost=LabCost+$p(Fee,"^",3)
		//检查费
		Set:$p(Fee,"^",1)="7.1" CheckCost=CheckCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="7.2" CheckCost=CheckCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="7.3" CheckCost=CheckCost+$p(Fee,"^",3)
		//材料费
		Set:$p(Fee,"^",1)="23" MaterialCost=MaterialCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="24" MaterialCost=MaterialCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="25" MaterialCost=MaterialCost+$p(Fee,"^",3)
		//中成药费
		Set:$p(Fee,"^",1)="16" ProprMedCost=ProprMedCost+$p(Fee,"^",3)
		//中草药费
		Set:$p(Fee,"^",1)="17" HerbalMedCost=HerbalMedCost+$p(Fee,"^",3)
		//西药费
		Set:$p(Fee,"^",1)="15" WesternMedCost=WesternMedCost+$p(Fee,"^",3)
		//治疗费
		Set:$p(Fee,"^",1)="2.1" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="2.2" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="2.3" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="2.4" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.1" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.2" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.3" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.4" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.5" TherapyCost=TherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.6" TherapyCost=TherapyCost+$p(Fee,"^",3)
		//中医治疗费
		Set:$p(Fee,"^",1)="13.1" ChTherapyCost=ChTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.2" ChTherapyCost=ChTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.3" ChTherapyCost=ChTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.4" ChTherapyCost=ChTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.5" ChTherapyCost=ChTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.6" ChTherapyCost=ChTherapyCost+$p(Fee,"^",3)
		//中医特色疗法费
		Set:$p(Fee,"^",1)="13.1" CharaTherapyCost=CharaTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.2" CharaTherapyCost=CharaTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.3" CharaTherapyCost=CharaTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.4" CharaTherapyCost=CharaTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.5" CharaTherapyCost=CharaTherapyCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="13.6" CharaTherapyCost=CharaTherapyCost+$p(Fee,"^",3)
	}
	
	//北京复兴取费用方法
	//调用电子病历首页取费用接口
	Set strCateFee=..InPatCostTrakCareSubNew(argPaadm,"")
	For Index=1:1:$l(strCateFee,"!")
	{
		Set Fee=$p(strCateFee,"!",Index)
		//总费用
		Set:$p(Fee,"^",1)="Total" CountCost=CountCost+$p(Fee,"^",3)
		//总药费
		Set:$p(Fee,"^",1)="FY231" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY232" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY233" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY234" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY235" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY236" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY240" DrugCost=DrugCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY250" DrugCost=DrugCost+$p(Fee,"^",3)
		//化验费
		Set:$p(Fee,"^",1)="FY130" LabCost=LabCost+$p(Fee,"^",3)
		//检查费
		Set:$p(Fee,"^",1)="FY101" CheckCost=CheckCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY110" CheckCost=CheckCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY120" CheckCost=CheckCost+$p(Fee,"^",3)
		//材料费
		Set:$p(Fee,"^",1)="FY161" MaterialCost=MaterialCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY162" MaterialCost=MaterialCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY170" MaterialCost=MaterialCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY180" MaterialCost=MaterialCost+$p(Fee,"^",3)
		//中成药费
		Set:$p(Fee,"^",1)="FY240" ProprMedCost=ProprMedCost+$p(Fee,"^",3)
		//中草药费
		Set:$p(Fee,"^",1)="FY250" HerbalMedCost=HerbalMedCost+$p(Fee,"^",3)
		//西药费
		Set:$p(Fee,"^",1)="FY231" WesternMedCost=WesternMedCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY232" WesternMedCost=WesternMedCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY233" WesternMedCost=WesternMedCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY234" WesternMedCost=WesternMedCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY235" WesternMedCost=WesternMedCost+$p(Fee,"^",3)
		Set:$p(Fee,"^",1)="FY236" WesternMedCost=WesternMedCost+$p(Fee,"^",3)
	}
	*/
	
	Set return=$lb(CountCost,DrugCost,LabCost,CheckCost,MaterialCost)
	Set return=return_$lb(ProprMedCost,HerbalMedCost,WesternMedCost,TherapyCost,ChTherapyCost,CharaTherapyCost)
	
	Quit return
}

/// 抗生素费用、抗生素使用天数
ClassMethod getPharmacyInfo(argPaadm As %String, argPharmacyCateg As %String, argPharmacySubCat As %String) As %List
{
	New (argPaadm,argPharmacyCateg,argPharmacySubCat)
	Set return=""
	Quit:argPaadm="" return
	Quit:(argPharmacyCateg="")&&(argPharmacySubCat="") return
	
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

ClassMethod GetPhcCat(arcim)
{
     n (arcim) 
     s s=""
     s drgfrmrowid=$p($g(^ARCIM(+arcim,1,1)),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p($g(^PHCD(drugrowid,1)),"^",3)        ;PHC_SubCat药理学子分类
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s s=phccat_"/"_$p($g(^PHCC(phccat)),"^",1)_"/"_$p($g(^PHCC(phccat)),"^",2)
     q s
}

ClassMethod GetPhcSubCat(arcim)
{
     n (arcim) 
     s s=""
     s drgfrmrowid=$p($g(^ARCIM(+arcim,1,1)),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p($g(^PHCD(drugrowid,1)),"^",3)        ;PHC_SubCat药理学子分类
     q:psubcatrowid="" ""
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s phcsub=$p(psubcatrowid,"||",2)
     s s=psubcatrowid_"/"_$p($g(^PHCC(phccat,"SC",phcsub)),"^",1)_"/"_$p($g(^PHCC(phccat,"SC",phcsub)),"^",2)
     q s
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

/// 是否三线抗生素患者(Y/N)
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getIs3Pharmacy(1158753,"","抗生素类")
ClassMethod getIs3Pharmacy(argPaadm As %String, argPharmacyCateg As %String, argPharmacySubCat As %String) As %List
{
	New (argPaadm,argPharmacyCateg,argPharmacySubCat)
	Set return="N"
	Quit:argPaadm="" return
	Quit:(argPharmacyCateg="")&&(argPharmacySubCat="") return
	
	Set PharmacyCateg=argPharmacyCateg
	Set PharmacySubCat=argPharmacySubCat
	Set PharmacyCategory=$ListFromString(PharmacyCateg_","_PharmacySubCat)
	
	Set ArcimCost=0,ArcimDays=0
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",argPaadm,OrderID))
		Quit:OrderID=""
		Quit:return="Y"
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			Quit:return="Y"
			
			/*If PharmacyCateg'="" {                      //药学大类
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
				Quit:return="Y"
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					Quit:return="Y"
					
					Set StatusID=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",13)
					Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),2)
					Continue:StatusDesc["停止"
					
					Set return="Y"
				}
			}
		}
	}
	
	Quit return
}

/// 路径科室
ClassMethod getCPWLoc(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	//入院科室默认为路径科室
	Set TransID=0,CPWLocID="",CPWLoc=""
	For {
		Set TransID=$o(^PAADM(argPaadm,"TRANS",TransID))
		Quit:TransID=""
		Quit:CPWLocID'=""
		Set CPWLocID=$p($g(^PAADM(argPaadm,"TRANS",TransID)),"^",6)
		Set CPWLoc=$p($g(^CTLOC(+CPWLocID)),"^",2)
		Set:$p(CPWLoc,"-",2)'="" CPWLoc=$p(CPWLoc,"-",2)
	}
	Set return=CPWLoc
	
	Quit return
}

/// 病种+出入径信息
ClassMethod getPathWayInfo(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argPaadm)
	Quit:MRAdm="" return
	
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Quit:'$IsObject(objPathWay) return
	Quit:'$IsObject(objPathWay.CPWPathwayDR) return
	Quit:'$IsObject(objPathWay.CPWPathwayDR.CPWCPWDicDR) return
	Set CPWDID=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
	Set CPWStatus=objPathWay.CPWStatus
	//Set DischDate=+$p($g(^PAADM(+argPaadm)),"^",6)
	//Update by pylian 2016-01-22 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(argPaadm)
	Set DischDate=$p(DischDateTime,"^",1)
	Set:DischDate>0 CPWStatus="C"
	
	Set VarID=0,IsVarPat="N"
	For {
		Set VarID=$o(^DHCMR("CPW",PathWayID,"VAR",VarID))
		Quit:VarID=""
		Quit:IsVarPat="Y"
		Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(PathWayID_"||"_VarID)
		Continue:'$IsObject(objVar)
		Set VarUpdoFlag=objVar.CPWVUpdoFlag
		Continue:VarUpdoFlag="Y"
		Set IsVarPat="Y"
	}
	
	//根据入径时间取入径科室
	Set CPWInDate=objPathWay.CPWInDate
	Set CPWInDate=+CPWInDate
	Set CPWInTime=objPathWay.CPWInTime
	Set CPWInTime=+CPWInTime
	Set SubID="",CPWLocID=""
	For {
		Set SubID=$o(^PAADM(argPaadm,"TRANS",SubID),-1)
		Quit:SubID=""
		Quit:CPWLocID'=""
		Set StartDate=$p($g(^PAADM(argPaadm,"TRANS",SubID)),"^",1)
		Set StartTime=$p($g(^PAADM(argPaadm,"TRANS",SubID)),"^",2)
		Continue:StartDate>CPWInDate
		Continue:(StartDate=CPWInDate)&&(StartTime>CPWInTime)
		Set tmpLocID=$p($g(^PAADM(argPaadm,"TRANS",SubID)),"^",6)
		Continue:tmpLocID=""
		Set CPWLocID=tmpLocID
	}
	
	Set return=$lb(CPWDID,PathWayID,CPWStatus,IsVarPat,CPWLocID)
	Quit return
}

/// 非计划重返手术室标记(Y/N)
ClassMethod getTimesOperFlag(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set IsOperPat=0
	Set ANOPArrID=0
	For {
		Set ANOPArrID=$o(^DHCANOPArrange(0,"Adm",argPaadm,ANOPArrID))
		Quit:ANOPArrID=""
		Quit:IsOperPat>=2
		
		Set ANOPArr=$g(^DHCANOPArrange(ANOPArrID))
		Set OperStatus=$p(ANOPArr,"^",27)   //手术排班状态（A-申请,D-拒绝,R-接收,I-入室,O-术中, L-离开,F-完成）
		Continue:(OperStatus="A")||(OperStatus="D")
		Set OperDate=$p(ANOPArr,"^",14)     //手术日期
		Continue:OperDate=""
		Set IsOperPat=IsOperPat+1
	}
	If IsOperPat<=1 {
		Set return="N"
	}Else{
		Set return="Y"
	}
	
	Quit return
}

/// 就诊信息
ClassMethod getAdmitInfo(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	//入院科室
	Set TransID=0,RegLocID=""
	For {
		Set TransID=$o(^PAADM(argPaadm,"TRANS",TransID))
		Quit:TransID=""
		Quit:RegLocID'=""
		Set RegLocID=$p($g(^PAADM(argPaadm,"TRANS",TransID)),"^",6)
	}
	//入院病区
	Set TransID=0,RegWardID=""
	For {
		Set TransID=$o(^PAADM(argPaadm,"TRANS",TransID))
		Quit:TransID=""
		Quit:RegWardID'=""
		
		Set RegWardID=$p($g(^PAADM(argPaadm,"TRANS",TransID)),"^",9)
		Set:RegWardID'="" RegWardID=$p($g(^PAWARD(RegWardID)),"^",5)
	}
	//出院科室
	Set DischLocID=$p($g(^PAADM(argPaadm)),"^",4)
	//出院病区
	Set DischWardID=$p($g(^PAADM(argPaadm)),"^",70)
	Set:DischWardID'="" DischWardID=$p($g(^PAWARD(DischWardID)),"^",5)
	Set return=$lb(RegLocID,RegWardID,DischLocID,DischWardID)
	
	Quit return
}

/// 预防性抗菌药物使用患者
/// 通过用药频次（术前30分钟用药）来判断
ClassMethod getIsPreDrugFlag(argPaadm As %String, argPharmacyCateg As %String, argPharmacySubCat As %String) As %String
{
	New (argPaadm,argPharmacyCateg,argPharmacySubCat)
	Set return=""
	Quit:argPaadm="" return
	Quit:(argPharmacyCateg="")&&(argPharmacySubCat="") return
	
	Set PharmacyCateg=argPharmacyCateg
	Set PharmacySubCat=argPharmacySubCat
	Set PharmacyCategory=$ListFromString(PharmacyCateg_","_PharmacySubCat)
	
	Set IsPreDrugFlag="N"
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",argPaadm,OrderID))
		Quit:OrderID=""
		Quit:IsPreDrugFlag="Y"
		
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			Quit:IsPreDrugFlag="Y"
			
			/*If PharmacyCateg'="" {                      //药学大类
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
				Quit:IsPreDrugFlag="Y"
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					Quit:IsPreDrugFlag="Y"
					
					Set StatusID=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",13)
					Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),2)
					Continue:StatusDesc["停止"
					
					Set PHCFreq=$p($g(^OEORD(OrderID,"I",SubID,2)),"^",4)  //频次 PHC_Freq
					Continue:PHCFreq=""
					Set PHCFreq=$p($g(^PHCFR(+PHCFreq)),"^",3)
					Continue:PHCFreq'["术前"
					Set IsPreDrugFlag="Y"
				}
			}
		}
	}
	Set return=IsPreDrugFlag
	
	Quit return
}

ClassMethod SetBatStartDate()
{
	New
	Set BatStartDate=$o(^DHCMR("CPWA-Batch","BatDate",0))
	Quit:BatStartDate'=""
	
	Set PathWayID=0
	For {
		Set PathWayID=$o(^DHCMR("CPW",PathWayID))
		Quit:PathWayID=""
		Quit:BatStartDate'=""
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		Continue:'$IsObject(objPathWay)
		Set InDate=objPathWay.CPWInDate
		Continue:InDate=""
		Set BatStartDate=$zd(InDate,3)
		Set ^DHCMR("CPWA-Batch","BatDate",BatStartDate)=""
	}
}

/// Desc:	病案费用信息：按照费用子类 一般38项
///         依照病案子类取费用(SQL:DHC_TarMrCate )(Global：^DHCTarC("MC",rowid) )
/// Output:	
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).InPatCostTrakCareSubNew(7185729)
ClassMethod InPatCostTrakCareSubNew(argAdmId As %String, argHospital As %String = "") As %String
{
	New (argAdmId,argHospital)
	Set return=""
	Quit:(($d(argAdmId)=0)||(argAdmId="")) return
	
	Set ZIndex=$zn,JIndex=$j,NIndex="InPatCostTrakCareSubNew"
	Kill ^TMP(ZIndex,JIndex,NIndex),PLIST
	
	// 取费用子类信息
	s n=1
	s rowid="0"
	f  s rowid=$o(^DHCTarC("MCNew",rowid))  q:rowid=""  d
	.i $g(^TMP(ZIndex,JIndex,NIndex))="" s ^TMP(ZIndex,JIndex,NIndex)=0
	.i $p(^DHCTarC("MCNew",rowid),"^",1)'="" d
	..s acctdesc=$p($p(^DHCTarC("MCNew",rowid),"^",1),$c(1)) //DHC_TarMrCate -> TARMC_Code
	..s acctdesc2=$p($p(^DHCTarC("MCNew",rowid),"^",2),$c(1)) //DHC_TarMrCate -> TARMC_Desc
	..s ^TMP(ZIndex,JIndex,NIndex,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
	..s ^TMP(ZIndex,JIndex,NIndex)=n
	..s PLIST(n)=acctdesc
	..s n=n+1
	
	// 初始化
	s argAdmId=$g(argAdmId)
	q:(argAdmId="") 0
	s sum=0, P9=""
	f i=1:1:$g(^TMP(ZIndex,JIndex,NIndex)) d
	.s itmfee(i)=0
	
	// 将病人费用信息按费用子类归并
	s rowid=""
	f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
	.s pboid=""
	.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
	..s pbdid="0"
	..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
	...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
	...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
	...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
	...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
	...i totalamount=""  s totalamount=0
	...s sum=sum+totalamount
	...q:(taritem="")
	...q:($d(^DHCTARI(taritem))=0)
	...s subcate=$p(^DHCTARI(taritem),"^",30)  //DHC_TarMrCate -> Rowid
	...q:(subcate="")
	...//b
	...s acctcate=subcate
	...q:(acctcate="")
	...f i=1:1:$g(^TMP(ZIndex,JIndex,NIndex)) d
	....i $p(acctcate,$c(1))=$p($p(^TMP(ZIndex,JIndex,NIndex,i),"^",1),$c(1)) d
	.....s itmfee(i)=totalamount+itmfee(i)
	
	// 将归并后的费用信息拼成字符串
	f i=1:1:$g(^TMP(ZIndex,JIndex,NIndex)) d
	.//w $p($g(^TMP(ZIndex,JIndex,NIndex,i)),"^",2)_"^"_$p($g(^TMP(ZIndex,JIndex,NIndex,i)),"^",3)_"^"_$fn(itmfee(i),"",2),!
	.s return=return_"!"_$p($g(^TMP(ZIndex,JIndex,NIndex,i)),"^",2)_"^"_$p($g(^TMP(ZIndex,JIndex,NIndex,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
	s return="Total^总费用^"_$fn(sum,"",2)_return
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit return
}

/// Desc:	病案费用信息：按照费用大类 一般24项
///         依照病案大类取费用(SQL:DHC_TarMc )(Global：^DHCTarC("TMC",rowid) )
/// Output:	
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).InPatCostTrakCareNew(7185729)
ClassMethod InPatCostTrakCareNew(argAdmId As %String, argHospital As %String = "") As %String
{
	New (argAdmId,argHospital)
	Set return=""
	Quit:(($d(argAdmId)=0)||(argAdmId="")) return
	
	Set ZIndex=$zn,JIndex=$j,NIndex="InPatCostTrakCareNew"
	Kill ^TMP(ZIndex,JIndex,NIndex),PLIST
	
	// 取费用大类信息
	s n=1
	s rowid="0"
	f  s rowid=$o(^DHCTarC("TMCNew",rowid))  q:rowid=""  d
	.i $g(^TMP(ZIndex,JIndex,NIndex))="" s ^TMP(ZIndex,JIndex,NIndex)=0
	.i $p(^DHCTarC("TMCNew",rowid),"^",1)'="" d
	..s acctdesc=$p($p(^DHCTarC("TMCNew",rowid),"^",1),$c(1))  //DHC_TarMc  -> TARTMC_Code
	..s acctdesc2=$p($p(^DHCTarC("TMCNew",rowid),"^",2),$c(1)) //DHC_TarMc  -> TARTMC_Desc
	..s ^TMP(ZIndex,JIndex,NIndex,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
	..s ^TMP(ZIndex,JIndex,NIndex)=n
	..s PLIST(n)=acctdesc
	..s n=n+1

	// 初始化
	s argAdmId=$g(argAdmId)
	q:(argAdmId="") 0
	s sum=0, P9=""
	f i=1:1:$g(^TMP(ZIndex,JIndex,NIndex)) d
	.s itmfee(i)=0
	
	// 将病人费用按费用大类归并
	s rowid=""
	f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
	.s pboid=""
	.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
	..s pbdid="0"
	..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
	...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
	...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
	...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
	...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
	...i totalamount=""  s totalamount=0
	...s sum=sum+totalamount
	...q:(taritem="")
	...q:($d(^DHCTARI(taritem))=0)
	...s subcate=$p(^DHCTARI(taritem),"^",30)
	...q:(subcate="")
	...//b
	...s acctcate=$p($g(^DHCTarC("MCNew",subcate)),"^",3)
	...q:(acctcate="")
	...f i=1:1:$g(^TMP(ZIndex,JIndex,NIndex)) d
	....i $p(acctcate,$c(1))=$p($p(^TMP(ZIndex,JIndex,NIndex,i),"^",1),$c(1)) d
	.....s itmfee(i)=totalamount+itmfee(i)

	// 将归并后的费用信息拼成字符串
	f i=1:1:$g(^TMP(ZIndex,JIndex,NIndex)) d
	.s return=return_"!"_$p($g(^TMP(ZIndex,JIndex,NIndex,i)),"^",2)_"^"_$p($g(^TMP(ZIndex,JIndex,NIndex,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
	s return="Total^总费用^"_$fn(sum,"",2)_return
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit return
}

/// 取再入院天数
/// w ##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).GetTimesInHospDays(3888114)
ClassMethod GetTimesInHospDays(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set return=-1
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

/// Add by zhaoyu 2013-05-24抗菌药物接口1 抗生素使用情况
/// editor     :shp
/// date       :2013-4-9
/// description:To determine whether the patient is used antibiotics. If used, distinguishing the non-Barring level,
///            Barring level or special level.
/// input      :episodeid
/// output     :"y^x_$c(1)_x_$c(1)_x "      x:0/1    y:0/1
///             y=1  :used               y=0:  non-used 
/// W ##class(web.DHCDocAntiService).GetPatAntInfoById(25)    
/// update     :Increasing the purpose of ant-use by shp,2013-05-10.
/// w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).GetPatAntInfoById(30972)
ClassMethod GetPatAntInfoById(episodeid As %String) As %String
{
	new (episodeid)
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

/// Add by zhaoyu 2013-05-24 抗菌药物接口2 费用&天数1
/// Creator：      lxc
/// CreatDate：    2013-05-24
/// Description:： 获取患者抗菌药物费用和用药天数
/// Table：       DHCMRIPDay
/// Input：       startDate:开始日期,endDate:结束日期。
/// Output：   
/// Return：      retStatus:成功则返回1,执行失败返回0
/// Others：      
/// w ##class(web.DHCCPW.MR.ClinPathWayAnalysisBat).GetKjxxByadmId(30972)
ClassMethod GetKjxxByadmId(admId As %String, flag As %String) As %String
{
	;取出院病人用药天数
	n (admId,flag)
	Set Fee=0,ts=0,outdata=Fee_"^"_ts	// zhaoyu 2013-05-30
	s $zt="ErrorReturn"
	k ^temp($j,"CyTJLxc"),^temp1($j,"CyTJLxc")
	
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

Storage Default
{
<Data name="ClinPathWayAnalysisBatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCC.ClinPathWayAnalysisBaD</DataLocation>
<DefaultData>ClinPathWayAnalysisBatDefaultData</DefaultData>
<IdLocation>^web.DHCC.ClinPathWayAnalysisBaD</IdLocation>
<IndexLocation>^web.DHCC.ClinPathWayAnalysisBaI</IndexLocation>
<StreamLocation>^web.DHCC.ClinPathWayAnalysisBaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
