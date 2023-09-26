/// 名称: web.DHCCPW.MR.ClinPathWayAnalysisSrv
/// 描述: 临床路径统计分析
/// 编写者：zhufei
/// 编写日期: 2011-07-04
Class web.DHCCPW.MR.ClinPathWayAnalysisSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-12-08
/// Description:  根据ID取临床路径月报数据记录
/// Table：       User.DHCMRClinPathWayAnalysis
/// Input：       ID:    User.DHCMRClinPathWayAnalysis.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MR.ClinPathWayAnalysisSrv).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRClinPathWayAnalysis
{
	New (argId)
	Set return=""
	
	Set objAnalysis=##Class(User.DHCMRClinPathWayAnalysis).%OpenId(argId)
	If $IsObject(objAnalysis){
		Set NextDays=-1
		Set EpisodeID=objAnalysis.CPWAPaadm
		//Set DischDate=+$p($g(^PAADM(+EpisodeID)),"^",17)
		//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
		Set DischDate=$p(DischDateTime,"^",1)	

		Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
		Set NextEpisodeID=$o(^PAPERdr(+PatientID,"ADM","I",EpisodeID))
		If NextEpisodeID'="" {
			//Set NextAdmDate=+$p($g(^PAADM(+NextEpisodeID)),"^",6)
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(NextEpisodeID)
			Set NextAdmDate=$p(AdmDateTime,"^",1)
			Set NextDays=NextAdmDate-DischDate
		}
		Set objAnalysis.CPWAIsTimesInHospFlag=NextDays  //此字段记录再住院天数
		Set return=objAnalysis
	}
	Do:objAnalysis'="" objAnalysis.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-07-04
/// Description:  出院病人出入径分析
/// Input：       DateFrom(开始日期),DateTo(结束日期),AnalysysType(统计类型)
///       add by wuqk 2011-11-18
///       ctLoc:科室
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWayAnalysisSrv","QryCPWDischStatByCPWD","2011-06-01","2012-12-21","1","10")
Query QryCPWDischStatByCPWD(argDateFrom As %String, argDateTo As %String, argAnalysysType As %String, ctLoc As %String) As %Query(ROWSPEC = "CPWDicTypeID:%String,CPWDicTypeDesc:%String,CPWDID:%String,CPWDicDesc:%String,InHospCount:%String,InCPWCount:%String,InCPWRatio:%String,OutCPWCount:%String,OutCPWRatio:%String,CloseCPWCount:%String,CloseCPWRatio:%String,VarCPWCount:%String,VarCPWRatio:%String,InHospDays:%String,OperInHospDays:%String,CureRatio:%String,ImproveRatio:%String,DeathRatio:%String,CureCount:%String,ImproveCount:%String,DeathCount:%String,InfPatRatio:%String,OperInfRatio:%String,InHospCost:%String,DayCost:%String,DrugCost:%String,DrugCostRatio:%String,LabCost:%String,LabCostRatio:%String,CheckCost:%String,CheckCostRatio:%String,MaterialCost:%String,MaterialCostRatio:%String,ProprMedCost:%String,HerbalMedCost:%String,WesternMedCost:%String,TherapyCost:%String,ChTherapyCost:%String,CharaTherapyCost:%String,PiecesMedCount:%String,PiecesMedRadio:%String,ProprMedCount:%String,ProprMedRadio:%String,CharaTherapyCount:%String,CharaTherapyRadio:%String,ChTherapyCount:%String,ChTherapyRadio:%String,Pharmacy3Ratio:%String,PharmacyDays:%String,PharmacyCost:%String,PharmacyCostRatio:%String,TimesOperRatio:%String,PreDrugRatio:%String,ComplicationRatio:%String,NextDays14Ratio:%String,NextDays31Ratio:%String")
{
}

ClassMethod QryCPWDischStatByCPWDExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argAnalysysType As %String, ctLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Quit:argAnalysysType="" $$$OK
	Set ctLoc=$g(ctLoc)
	;Set ^Test("QryCPWDischStatByCPWD")=argDateFrom_","_argDateTo_","_argAnalysysType_","_ctLoc
	//批处理统计数据（单独一张表汇总统计数据）
	//Set flg=..BatchAnalysisData("",+$h,"0")
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD")
	
	//按病种统计
	Set DischDate=argDateFrom-1
	For {
		Set DischDate=$o(^DHCMRi("CPWA",0,"IndexDischDate",DischDate))
		Quit:DischDate=""
		Quit:DischDate>argDateTo
		Set AnalysisID=0
		For {
			Set AnalysisID=$o(^DHCMRi("CPWA",0,"IndexDischDate",DischDate,AnalysisID))
			Quit:AnalysisID=""
			Set objAnalysis=..GetObjById(AnalysisID)
			Continue:'$IsObject(objAnalysis)
			//Continue:(objAnalysis.CPWARegLocID'=ctLoc)&(ctLoc'="")  //add by wuqk 2011-11-18
			Continue:(objAnalysis.CPWACPWLoc'=ctLoc)&(ctLoc'="")	//by zhaoyu 2013-01-08 取消注释 临床路径月报表科室ID改为路径ID
			
			Set AdmStatus=objAnalysis.CPWAAdmStatus
			Continue:AdmStatus'="D"
			Set CPWDID=objAnalysis.CPWACPWDID
			Continue:CPWDID=""
			Set PathWayID=objAnalysis.CPWAPathWayID
			Set Paadm=objAnalysis.CPWAPaadm
			//Set AdmLoc=$p($g(^PAADM(+Paadm)),"^",4)	//Note by zhaoyu 2013-01-08 临床路径月报表科室ID改为路径ID
			//Continue:(AdmLoc'=ctLoc)&(ctLoc'="")&(AdmLoc'="")	//Note by zhaoyu 2013-01-08 临床路径月报表科室ID改为路径ID
			
			Set NotInCPWReason=""
			Set CPWLogID=$o(^DHCMRi("LOG",0,"PaadmIndex",Paadm,0))
			If CPWLogID'="" {
				Set objCPWLog=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetObjById(CPWLogID)
				If $IsObject(objCPWLog){
					Set NotInCPWReason=objCPWLog.NotInCPWReason
				}
			}
			//Continue:(PathWayID="")&&(NotInCPWReason'="")      //这个应该是未入径患者 Modified by fcz 20121126
			
			Set CPWStatus=""
			Set num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"病种住院人次"))
			
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			If $IsObject(objPathWay) {
				Set CPWStatus=objPathWay.CPWStatus
				Set num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"入径患者总人次"))
				Set:CPWStatus="O" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"出径患者总人次"))
				Set:CPWStatus="C" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"完成路径总人次"))
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
				Set:IsVarPat="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"出现变异总人次"))
			}
			If ((+argAnalysysType=1)                     //按病种统计
			||((CPWStatus'="")&&(+argAnalysysType=2))    //按入径统计
			||((CPWStatus="C")&&(+argAnalysysType=3))    //按完成统计
			||((CPWStatus="")&&(+argAnalysysType=4)))    //按未入径统计
			{
				Set num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"统计基数"))
				Set AdmitDate=objAnalysis.CPWAAdmitDate
				Set DischDate=objAnalysis.CPWADischDate
				Set AdmDays=DischDate-AdmitDate
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"病种住院总天数")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"病种住院总天数"))+AdmDays
				Set OperDate=objAnalysis.CPWAOperDate
				If OperDate'="" {
					Set num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"手术患者总人次"))
					Set OperAdmDays=OperDate-AdmitDate
					Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"术前住院总天数")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"术前住院总天数"))+OperAdmDays
				}
				Set OutStatus=objAnalysis.CPWAOutStatus
				Set:OutStatus="治愈" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"治愈患者总人次"))
				Set:OutStatus="好转" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"好转患者总人次"))
				Set:OutStatus="死亡" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"死亡患者总人次"))
				Set IsInHospInf=objAnalysis.CPWAIsInHospInf
				Set:IsInHospInf="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"院感患者总人次"))
				Set IsOperInf=objAnalysis.CPWAIsOperInf
				Set:IsOperInf="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"手术部位感染患者总人次"))
				Set HospCost=objAnalysis.CPWAHospCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"总费用")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"总费用"))+HospCost
				Set DrugCost=objAnalysis.CPWADrugCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"总药费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"总药费"))+DrugCost
				Set LabCost=objAnalysis.CPWALabCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"检验费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"检验费"))+LabCost
				Set CheckCost=objAnalysis.CPWACheckCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"检查费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"检查费"))+CheckCost
				Set MaterialCost=objAnalysis.CPWAMaterialCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"耗材费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"耗材费"))+MaterialCost
				
				//**************************************************************************
				//中医相关的临床路径统计指标
				//中成药费、中草药费、西药费、治疗费、中医治疗费、中医特色疗法费
				Set CPWAProprMedCost=objAnalysis.CPWAProprMedCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中成药费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中成药费"))+CPWAProprMedCost
				Set CPWAHerbalMedCost=objAnalysis.CPWAHerbalMedCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中草药费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中草药费"))+CPWAHerbalMedCost
				Set CPWAWesternMedCost=objAnalysis.CPWAWesternMedCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"西药费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"西药费"))+ CPWAWesternMedCost
				Set CPWATherapyCost=objAnalysis.CPWATherapyCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"治疗费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"治疗费"))+ CPWATherapyCost
				Set CPWAChTherapyCost=objAnalysis.CPWAChTherapyCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医治疗费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医治疗费"))+ CPWAChTherapyCost
				Set CPWACharaTherapyCost=objAnalysis.CPWACharaTherapyCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医特色疗法费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医特色疗法费"))+ CPWACharaTherapyCost
				//中药饮片使用人数、中成药使用人数、特色疗法使用人数、中医药治疗使用人数
				Set CPWAIsPiecesMed=objAnalysis.CPWAIsPiecesMed
				Set:CPWAIsPiecesMed="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中药饮片使用人数"))
				Set CPWAIsProprMed=objAnalysis.CPWAIsProprMed
				Set:CPWAIsProprMed="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中成药使用人数"))
				Set CPWAIsCharaTherapy=objAnalysis.CPWAIsCharaTherapy
				Set:CPWAIsCharaTherapy="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"特色疗法使用人数"))
				If (CPWAIsPiecesMed="Y")||(CPWAIsProprMed="Y")||(CPWAIsCharaTherapy="Y") {
					Set num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医药治疗使用人数"))
				}
				//**************************************************************************
				
				Set Is3Pharmacy=objAnalysis.CPWAIs3Pharmacy
				Set:Is3Pharmacy="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用三线抗生素患者总人次"))
				Set PharmacyDays=objAnalysis.CPWAPharmacyDays
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用抗生素总天数")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用抗生素总天数"))+PharmacyDays
				Set PharmacyCost=objAnalysis.CPWAPharmacyCost
				Set ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用抗生素总药费")=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用抗生素总药费"))+PharmacyCost
				Set TimesOperFlag=objAnalysis.CPWATimesOperFlag
				Set:TimesOperFlag="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"非计划重返手术室患者"))
				Set IsPreDrugFlag=objAnalysis.CPWAIsPreDrugFlag
				Set:IsPreDrugFlag="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"预防性抗菌药物使用患者"))
				Set IsComplicationFlag=objAnalysis.CPWAIsComplicationFlag
				Set:IsComplicationFlag="Y" num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"常见并发症患者"))
				Set NextDays=+objAnalysis.CPWAIsTimesInHospFlag
				Set:(NextDays>=0)&&(NextDays<=14) num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"14日再住院"))
				Set:(NextDays>=0)&&(NextDays<=31) num=$i(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"31日再住院"))
				
			}
		}
	}
	
	Set CPWDID=0
	For {
		Set CPWDID=$o(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID))
		Quit:CPWDID=""
		Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
		Continue:'$IsObject(objCPWDic)
		Set CPWDicDesc=objCPWDic.CPWDDesc
		Set CPWDicTypeID=""
		Set CPWDicTypeDesc="其他"
		If $IsObject(objCPWDic.CPWDCPWTypeDR) {
			Set CPWDicTypeID=objCPWDic.CPWDCPWTypeDR.%Id()
			Set CPWDicTypeDesc=objCPWDic.CPWDCPWTypeDR.CLPTDesc
		}
		Set BaseCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"统计基数"))
		Set InHospCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"病种住院人次"))
		Set InCPWCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"入径患者总人次"))
		Set OutCPWCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"出径患者总人次"))
		Set CloseCPWCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"完成路径总人次"))
		Set VarCPWCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"出现变异总人次"))
		Set InHospDays=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"病种住院总天数"))
		Set OperPatCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"手术患者总人次"))
		Set OperInHospDays=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"术前住院总天数"))
		Set CureCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"治愈患者总人次"))
		Set ImproveCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"好转患者总人次"))
		Set DeathCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"死亡患者总人次"))
		Set InfPatCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"院感患者总人次"))
		Set OperInfPatCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"手术部位感染患者总人次"))
		Set InHospCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"总费用"))
		Set DrugCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"总药费"))
		Set LabCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"检验费"))
		Set CheckCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"检查费"))
		Set MaterialCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"耗材费"))
		
		//**************************************************************************
		//中医相关的临床路径统计指标
		//中成药费、中草药费、西药费、治疗费、中医治疗费、中医特色疗法费
		Set ProprMedCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中成药费"))
		Set HerbalMedCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中草药费"))
		Set WesternMedCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"西药费"))
		Set TherapyCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"治疗费"))
		Set ChTherapyCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医治疗费"))
		Set CharaTherapyCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医特色疗法费"))
		//中药饮片使用人数、中成药使用人数、特色疗法使用人数、中医药治疗人数
		Set PiecesMedCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中药饮片使用人数"))
		Set ProprMedCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中成药使用人数"))
		Set CharaTherapyCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"特色疗法使用人数"))
		Set ChTherapyCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"中医药治疗使用人数"))
		//**************************************************************************
		
		Set Pharmacy3PatCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用三线抗生素患者总人次"))
		Set PharmacyDays=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用抗生素总天数"))
		Set PharmacyCost=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"使用抗生素总药费"))
		Set TimesOperCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"非计划重返手术室患者"))
		Set PreDrugCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"预防性抗菌药物使用患者"))
		Set ComplicationCount=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"常见并发症患者"))
		Set NextDays14=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"14日再住院"))
		Set NextDays31=+$g(^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD","单病种",CPWDID,"31日再住院"))
		
		Set (xInHospDays,xInHospCost,xDrugCost,xInHospCost,xDrugCost)="0.00"
		Set (xLabCost,xCheckCost,xPharmacyDays,xPharmacyCost,xOperInHospDays)="0.00"
		Set (xInCPWRatio,xOutCPWRatio,xCloseCPWRatio,xVarCPWRatio,xCureRatio,xImproveRatio)="0.00%"
		Set (xDeathRatio,xInfPatRatio,xOperInfRatio,xPharmacy3Ratio,xDrugCostRatio)="0.00%"
		Set (xLabCostRatio,xCheckCostRatio,xMaterialCostRatio,xPharmacyCostRatio,xTimesOperRatio)="0.00%"
		Set (xPreDrugRatio,xComplicationRatio,xNextDays14Ratio,xNextDays31Ratio,xDayCost)="0.00%"
		Set (xPiecesMedRadio,xProprMedRadio,xCharaTherapyRadio,xChTherapyRadio)="0.00%"
		
		Set (xProprMedCost,xHerbalMedCost,xWesternMedCost,xTherapyCost,xChTherapyCost,xCharaTherapyCost)="0.00"
		
		If InHospCount'=0 {
			Set xInCPWRatio=$fn((InCPWCount/InHospCount)*100,"",2)_"%"
		}
		If InCPWCount'=0 {
			Set xOutCPWRatio=$fn((OutCPWCount/InCPWCount)*100,"",2)_"%"
			Set xCloseCPWRatio=$fn((CloseCPWCount/InCPWCount)*100,"",2)_"%"
			Set xVarCPWRatio=$fn((VarCPWCount/InCPWCount)*100,"",2)_"%"
		}
		If BaseCount'=0 {
			Set xInHospDays=$fn((InHospDays/BaseCount),"",2)
			Set xInHospCost=$fn((InHospCost/BaseCount),"",2)
			Set xDrugCost=$fn((DrugCost/BaseCount),"",2)
			
			Set xProprMedCost=$fn((ProprMedCost/BaseCount),"",2)
			Set xHerbalMedCost=$fn((HerbalMedCost/BaseCount),"",2)
			Set xWesternMedCost=$fn((WesternMedCost/BaseCount),"",2)
			Set xTherapyCost=$fn((TherapyCost/BaseCount),"",2)
			Set xChTherapyCost=$fn((ChTherapyCost/BaseCount),"",2)
			Set xCharaTherapyCost=$fn((CharaTherapyCost/BaseCount),"",2)
			
			Set xCureRatio=$fn((CureCount/BaseCount)*100,"",2)_"%"
			Set xImproveRatio=$fn((ImproveCount/BaseCount)*100,"",2)_"%"
			Set xDeathRatio=$fn((DeathCount/BaseCount)*100,"",2)_"%"
			Set xInfPatRatio=$fn((InfPatCount/BaseCount)*100,"",2)_"%"
			Set xOperInfRatio=$fn((OperInfPatCount/BaseCount)*100,"",2)_"%"
			Set xInHospCost=$fn((InHospCost/BaseCount),"",2)
			Set xDrugCost=$fn((DrugCost/BaseCount),"",2)
			Set xLabCost=$fn((LabCost/BaseCount),"",2)
			Set xCheckCost=$fn((CheckCost/BaseCount),"",2)
			Set xMaterialCost=$fn((MaterialCost/BaseCount),"",2)
			Set xPharmacy3Ratio=$fn((Pharmacy3PatCount/BaseCount)*100,"",2)_"%"
			Set xPharmacyDays=$fn((PharmacyDays/BaseCount),"",2)
			Set xPharmacyCost=$fn((PharmacyCost/BaseCount),"",2)
			Set xPreDrugRatio=$fn((PreDrugCount/BaseCount)*100,"",2)_"%"
			Set xComplicationRatio=$fn((ComplicationCount/BaseCount)*100,"",2)_"%"
			Set xNextDays14Ratio=$fn((NextDays14/BaseCount)*100,"",2)_"%"
			Set xNextDays31Ratio=$fn((NextDays31/BaseCount)*100,"",2)_"%"
			
			//**************************************************************************
			//中药饮片使用率、中成药使用率、特色疗法使用率、中医药治疗使用率
			Set xPiecesMedRadio=$fn((PiecesMedCount/BaseCount)*100,"",2)_"%"
			Set xProprMedRadio=$fn((ProprMedCount/BaseCount)*100,"",2)_"%"
			Set xCharaTherapyRadio=$fn((CharaTherapyCount/BaseCount)*100,"",2)_"%"
			Set xChTherapyRadio=$fn((ChTherapyCount/BaseCount)*100,"",2)_"%"
			//**************************************************************************
		}
		If InHospDays'=0 {
			Set xDayCost=$fn((InHospCost/InHospDays),"",2)
		}
		If InHospCost'=0 {
			Set xDrugCostRatio=$fn((DrugCost/InHospCost)*100,"",2)_"%"
			Set xLabCostRatio=$fn((LabCost/InHospCost)*100,"",2)_"%"
			Set xCheckCostRatio=$fn((CheckCost/InHospCost)*100,"",2)_"%"
			Set xMaterialCostRatio=$fn((MaterialCost/InHospCost)*100,"",2)_"%"
			Set xPharmacyCostRatio=$fn((PharmacyCost/InHospCost)*100,"",2)_"%"
		}
		If OperPatCount'=0 {
			Set xOperInHospDays=$fn((OperInHospDays/OperPatCount),"",2)
			Set xTimesOperRatio=$fn((TimesOperCount/OperPatCount)*100,"",2)_"%"
		}
		/***add by fcz 未入径统计不显示一下信息***/
		//If ((CPWStatus="")&&(+argAnalysysType=4)){
		If (+argAnalysysType=4){	//	zhaoyu 2012-11-26
			Set (InCPWCount,xInCPWRatio,OutCPWCount,xOutCPWRatio,CloseCPWCount,xCloseCPWRatio,VarCPWCount,xVarCPWRatio)="-"
		}
		//病种ID  病种名称  病种出院人数  入径人数  入径率  出径人数
		Set Data=$lb(CPWDicTypeID,CPWDicTypeDesc,CPWDID,CPWDicDesc,InHospCount,InCPWCount,xInCPWRatio,OutCPWCount)
		//出径率  完成路径人数  完成率  出现变异人数  变异率
		Set Data=Data_$lb(xOutCPWRatio,CloseCPWCount,xCloseCPWRatio,VarCPWCount,xVarCPWRatio)
		//平均住院日  术前平均住院日  治愈率%  好转率%  死亡率%
		Set Data=Data_$lb(xInHospDays,xOperInHospDays,xCureRatio,xImproveRatio,xDeathRatio,CureCount,ImproveCount,DeathCount)
		//院感发生率%  手术部位感染率%  平均住院费用  日均费用  平均药费  药费比例
		Set Data=Data_$lb(xInfPatRatio,xOperInfRatio,xInHospCost,xDayCost,xDrugCost,xDrugCostRatio)
		//检验费  检验费比例  检查费  检查费比例  耗材费  耗材费比例
		Set Data=Data_$lb(xLabCost,xLabCostRatio,xCheckCost,xCheckCostRatio,xMaterialCost,xMaterialCostRatio)
		//中成药费、中草药费、西药费、治疗费、中医治疗费、中医特色疗法费
		Set Data=Data_$lb(xProprMedCost,xHerbalMedCost,xWesternMedCost,xTherapyCost,xChTherapyCost,xCharaTherapyCost)
		//中药饮片使用人数、中药饮片使用率、中成药使用人数、中成药使用率、特色疗法使用人数、特色疗法使用率
		Set Data=Data_$lb(PiecesMedCount,xPiecesMedRadio,ProprMedCount,xProprMedRadio,CharaTherapyCount,xCharaTherapyRadio,ChTherapyCount,xChTherapyRadio) 
		//使用三线抗生素比例% 使用抗生素平均天数  使用抗生素平均费用  使用抗生素药物费用比例  非计划重返手术室患者比例%  预防性抗菌药物使用率  常见并发症发生率
		Set Data=Data_$lb(xPharmacy3Ratio,xPharmacyDays,xPharmacyCost,xPharmacyCostRatio,xTimesOperRatio,xPreDrugRatio,xComplicationRatio)
		//14日再住院率  31日再住院率
		Set Data=Data_$lb(xNextDays14Ratio,xNextDays31Ratio)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,"QryCPWDischStatByCPWD")
	
	Quit $$$OK
}

ClassMethod QryCPWDischStatByCPWDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWDischStatByCPWDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWDischStatByCPWDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWDischStatByCPWDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2011-12-07
/// Description:  出院病人月报明细
/// Input：       DateFrom(开始日期),DateTo(结束日期),AnalysysType(统计类型)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWayAnalysisSrv","QryCPWDischDetail","2010-02-01","2012-12-22","","1","")
Query QryCPWDischDetail(argDateFrom As %String, argDateTo As %String, aCPWDID As %String, argAnalysysType As %String = "", argLoc As %String = "") As %Query(ROWSPEC = "AnalysisID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Age:%String,AdmLoc:%String,AdmWard:%String,AdmDoc:%String,Diagnos:%String,CPWDicDesc:%String,CPWStatus:%String,IsVarPat:%String,AdmitDate:%String,DischDate:%String,AdmDays:%Integer,OperDate:%String,OperAdmDays:%Integer,OutStatus:%String,IsInHospInf:%String,IsOperInf:%String,HospCost:%Numeric,DrugCost:%Numeric,LabCost:%Numeric,CheckCost:%Numeric,MaterialCost:%Numeric,ProprMedCost:%Numeric,HerbalMedCost:%Numeric,WesternMedCost:%Numeric,TherapyCost:%Numeric,ChTherapyCost:%Numeric,CharaTherapyCost:%Numeric,IsPiecesMed:%String,IsProprMed:%String,IsCharaTherapy:%String,IsChTherapy:%String,Is3Pharmacy:%String,PharmacyDays:%Integer,PharmacyCost:%Numeric,TimesOperFlag:%String,IsPreDrugFlag:%String,IsComplicationFlag:%String,NextDays:%Integer,NotInCPWReason:%String,CPWDicID:%String,AdmLocID:%String,Is24HOutPathWay:%String,CPWCost:%String,CPWDays:%String,WhetherOverCost:%String,WhetherOverDay:%String,IsPharmacy:%String,Compl1Desc:%String,Compl2Desc:%String,InPathDays:%Integer") [ SqlProc ]
{
}

ClassMethod QryCPWDischDetailExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, aCPWDID As %String, argAnalysysType As %String, argLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	;Set ^Test("QryCPWDischDetailExecute")=argDateFrom_","_argDateTo_","_aCPWDID_","_argAnalysysType_","_argLoc
	//抗生素取值模式 zhaoyu 2013-05-27
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("CPWMonRepPharmacyType")
	Set PharmacyType=""
	Set:$IsObject(objConfig) PharmacyType=objConfig.BCValue	// 1-上了抗菌药物 ;other-没上
	//按病种统计
	Set iDischDate=argDateFrom-1
	For {
		Set iDischDate=$o(^DHCMRi("CPWA",0,"IndexDischDate",iDischDate))
		Quit:iDischDate=""
		Quit:iDischDate>argDateTo
		Set AnalysisID=0
		For {
			Set AnalysisID=$o(^DHCMRi("CPWA",0,"IndexDischDate",iDischDate,AnalysisID))
			Quit:AnalysisID=""
			Set objAnalysis=..GetObjById(AnalysisID)
			Continue:'$IsObject(objAnalysis)
			//Continue:(objAnalysis.CPWARegLocID'=argLoc)&(argLoc'="")
			//Continue:(objAnalysis.CPWACPWLoc'=argLoc)&(argLoc'="")
			Set AdmLocID=objAnalysis.CPWACPWLoc	//Add by zhaoyu 2013-01-08
			//Continue:(AdmLocID'=argLoc)&(argLoc'="")	//Note by zhaoyu 2013-05-28
			Set AdmStatus=objAnalysis.CPWAAdmStatus
			//Continue:AdmStatus'="D" //按照护理配置 可能出现有出院日期 但是住院状态仍是A
			Set PathWayID=objAnalysis.CPWAPathWayID
			Set Paadm=objAnalysis.CPWAPaadm
			//Set AdmLoc=$p($g(^PAADM(+Paadm)),"^",4)	//Note by zhaoyu 2013-01-08
			//Continue:(AdmLoc'=argLoc)&(argLoc'="")&(AdmLoc'="")	//Note by zhaoyu 2013-01-08
		    //fix bug 114960 临床路径月报表按未入径查询统计不到数据
		    Set CPWLog=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetLogByPaadm(Paadm,"")
		    Continue:(PathWayID="")&&(CPWLog="")
		    Set NoticePathWayVerID=$p(CPWLog,"^",8)
		    //update 20170510不入径记录的是临床路径ID，同步数据记录的临床路径字典ID，两者不一致时，导致取临床路径字典描述时病种名称错误
		    Set PathWayVerID=""
		    Set:NoticePathWayVerID'="" PathWayVerID=$o(^DHCMRCi("CPWD",0,"IndexVersion",NoticePathWayVerID,0))
		    Set CPWDID=objAnalysis.CPWACPWDID         //Continue:CPWDID=""，未入径的CPWDID为空，但不应该跳出
			Set:CPWDID="" CPWDID=PathWayVerID
			Continue:(aCPWDID'="")&&(aCPWDID'=CPWDID)
			Set AdmitDate=objAnalysis.CPWAAdmitDate 
			Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
			If $IsObject(objCPWDic) {
				Set IsActive=objCPWDic.CPWDActive
				Set DateFrom=objCPWDic.CPWDDateFrom
				Set DateTo=objCPWDic.CPWDDateTo
				Continue:IsActive'["Y"
				//Continue:(DateFrom'="")&&(DateFrom>DischDate)
				Continue:(DateTo'="")&&(DateTo<AdmitDate)
			}
			Set NotInCPWReason=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetNotInReason(Paadm)
			/*
			Set NotInCPWReason=""
			Set CPWLogID=$o(^DHCMRi("LOG",0,"PaadmIndex",Paadm,0))
			If CPWLogID'="" {
				Set objCPWLog=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetObjById(CPWLogID)
				If $IsObject(objCPWLog){
					Set NotInCPWReason=objCPWLog.NotInCPWReason
				}
			}
			Continue:(PathWayID="")&&(NotInCPWReason'="")
			*/
			Set (PapmiNo,PatName,Sex,Age,Diagnos,CPWDicDesc,CPWStatus,CPWStatusDesc,IsVarPat,AdmitDate,DischDate)=""
			Set (AdmDays,OperDate,OperAdmDays,OutStatus,IsInHospInf,IsOperInf,HospCost,DrugCost,LabCost,CheckCost)=""
			Set (MaterialCost,Is3Pharmacy,PharmacyDays,PharmacyCost,TimesOperFlag,IsPreDrugFlag,IsComplicationFlag,NextDays)=""
		    Set (ProprMedCost,HerbalMedCost,WesternMedCost,TherapyCost,ChTherapyCost,CharaTherapyCost)=""
		    //Set (IsPiecesMed,IsProprMed,IsCharaTherapy,IsChTherapy)=""
		    Set (IsPiecesMed,IsProprMed,IsCharaTherapy,IsChTherapy,Is24HOutPathWay)=""	//zhaoyu 2013-01-07
		    Set (CPWCost,CPWDays,WhetherOverCost,WhetherOverDay)=""
		    
		    Set PatientID=$p($g(^PAADM(+Paadm)),"^",1)
		    Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		    Set PatName=$p($g(^PAPER(+PatientID,"ALL")),"^",1)
		    Set Sex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
		    Set:Sex'="" Sex=$p($g(^CT("SEX",+Sex)),"^",2)
		    Set Birthday=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
		    Set:Birthday'="" Birthda=$zd(Birthday,3)

		    //update by zf 20150228 统一调用年龄计算方法
		    Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”
		    
		    //Set:AdmLocID="" AdmLoc=$p($g(^PAADM(+Paadm)),"^",4) ;路径科室为空取出院科室
		    //Set:AdmLoc'="" AdmLoc=$p($g(^CTLOC(AdmLoc)),"^",2)
		    
			Set AdmLocID=$p($g(^PAADM(+Paadm)),"^",4)	// modify by mxp 路径科室取出院科室
			Continue:(AdmLocID'=argLoc)&&(argLoc'="")	// Add by zhaoyu 2013-05-28 过滤科室
			
		    Set:AdmLocID'="" AdmLoc=$p($g(^CTLOC(AdmLocID)),"^",2)	//zhaoyu 2013-01-08
		    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		    
		    Set AdmWard=$p($g(^PAADM(+Paadm)),"^",70)
		    Set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",2)
		    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
		    
		    Set AdmDoc=$p($g(^PAADM(+Paadm)),"^",9)
		    Set:AdmDoc'="" AdmDoc=$p($g(^CTPCP(AdmDoc,1)),"^",2)
		    Set:$p(AdmDoc,"-",2)'="" AdmDoc=$p(AdmDoc,"-",2)
		    
			Set Diagnos=objAnalysis.CPWADiagnos
			Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
			Continue:'$IsObject(objCPWDic)
			Set CPWDicDesc=objCPWDic.CPWDDesc
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			Set CPWStatus=$s($IsObject(objPathWay):objPathWay.CPWStatus,1:"")
			Set OutPathWayDate=""   //出径日期	//zhaoyu 2013-01-07
			Continue:(argAnalysysType=2)&&(CPWStatus="")    //按入径统计
			Continue:(argAnalysysType=3)&&(CPWStatus'="C")  //按完成统计
			Continue:(argAnalysysType=4)&&(CPWStatus'="")   //按不入径统计
			Set InPathDays=0
			If $IsObject(objPathWay) {
				Set CPWStatus=objPathWay.CPWStatus
				Set:CPWStatus="I" CPWStatusDesc="入径"
				//Set:CPWStatus="O" CPWStatusDesc="出径"
				Set:CPWStatus="O" CPWStatusDesc="出径",OutPathWayDate=objPathWay.CPWOutDate	//zhaoyu 2013-01-07
				Set:CPWStatus="C" CPWStatusDesc="完成"
				Continue:(argAnalysysType=1)&&(CPWStatus)
				If CPWStatus'="I" {
					Set InPathDate=objPathWay.CPWInDate
					Set OutPathDate=objPathWay.CPWOutDate
					Set InPathDays=OutPathDate-InPathDate
				}
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
				Set IsVarPat=$s(IsVarPat["Y":"是",1:"否")
			}
			Set AdmitDate=objAnalysis.CPWAAdmitDate
			Set DischDate=objAnalysis.CPWADischDate
			Set AdmDays=DischDate-AdmitDate
			Set OperDate=objAnalysis.CPWAOperDate
			If OperDate'="" {
				Set OperAdmDays=OperDate-AdmitDate
			}
			Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
			Set:DischDate'="" DischDate=$zd(DischDate,3)
			Set:OperDate'="" OperDate=$zd(OperDate,3)
			
			Set OutStatus=objAnalysis.CPWAOutStatus
			Set IsInHospInf=objAnalysis.CPWAIsInHospInf
			Set IsInHospInf=$s(IsInHospInf["Y":"是",1:"否")
			Set IsOperInf=objAnalysis.CPWAIsOperInf
			Set IsOperInf=$s(IsOperInf["Y":"是",1:"否")
			Set HospCost=objAnalysis.CPWAHospCost
			Set DrugCost=objAnalysis.CPWADrugCost
			Set LabCost=objAnalysis.CPWALabCost
			Set CheckCost=objAnalysis.CPWACheckCost
			Set MaterialCost=objAnalysis.CPWAMaterialCost
			Set Is24HOutPathWay="否"	//zhaoyu 2013-01-07
			Set:(OutPathWayDate'="")&&($zd(OutPathWayDate,3)=AdmitDate) Is24HOutPathWay="是"	//zhaoyu 2013-05-03 入院24h内退出 275
			//*************************************************
			//中医相关的临床路径统计指标
			//中成药费、中草药费、西药费、治疗费、中医治疗费、中医特色疗法费
			Set ProprMedCost=objAnalysis.CPWAProprMedCost
			
			Set HerbalMedCost=objAnalysis.CPWAHerbalMedCost
			Set WesternMedCost=objAnalysis.CPWAWesternMedCost
			Set TherapyCost=objAnalysis.CPWATherapyCost
			Set ChTherapyCost=objAnalysis.CPWAChTherapyCost
			Set CharaTherapyCost=objAnalysis.CPWACharaTherapyCost
			//是否使用中药饮片、是否使用中成药、是否使用特色疗法、是否使用中医药治疗
			Set IsPiecesMed=objAnalysis.CPWAIsPiecesMed
			Set IsProprMed=objAnalysis.CPWAIsProprMed
			Set IsCharaTherapy=objAnalysis.CPWAIsCharaTherapy
			If (IsPiecesMed="Y")||(IsProprMed="Y")||(IsCharaTherapy="Y") {
				Set IsChTherapy="是"
			} Else {
				Set IsChTherapy="否"
			}
			Set IsPiecesMed=$s(IsPiecesMed["Y":"是",1:"否")
			Set IsProprMed=$s(IsProprMed["Y":"是",1:"否")
			Set IsCharaTherapy=$s(IsCharaTherapy["Y":"是",1:"否")
			//*************************************************
			
			//Set Is3Pharmacy=objAnalysis.CPWAIs3Pharmacy
			//Set Is3Pharmacy=$s(Is3Pharmacy["Y":"是",1:"否")
			Set PharmacyDays=objAnalysis.CPWAPharmacyDays
			Set PharmacyCost=objAnalysis.CPWAPharmacyCost
			Set TimesOperFlag=objAnalysis.CPWATimesOperFlag
			Set TimesOperFlag=$s(TimesOperFlag["Y":"是",1:"否")
			
			// Modified by zhaoyu 2013-05-27 抗生素取值模式(是否上了抗菌药物)
			If (+PharmacyType=1) {
				Set CPWAPharmacyInfo=objAnalysis.CPWAPharmacyInfo	// 抗生素信息
				
				Set Is3Pharmacy=$p($p(CPWAPharmacyInfo,"^",2),"$c(1)",3)	// 三线
				Set Is3Pharmacy=$s(+Is3Pharmacy=1:"是",1:"否")
				Set IsPreDrugFlag=$p($p(CPWAPharmacyInfo,"^",2),"$c(1)",5)	// 预防
				Set IsPreDrugFlag=$s(+IsPreDrugFlag=1:"是",1:"否")
				
				Set IsPharmacy=$p(CPWAPharmacyInfo,"^",1)	// 是否抗生素
				Set IsPharmacy=$s(+IsPharmacy=1:"是",1:"否")
			} Else {
				If (PharmacyDays>0)||(PharmacyCost>0) {
					Set IsPharmacy="是"
				} Else {
					Set IsPharmacy="否"
				}
				Set Is3Pharmacy=objAnalysis.CPWAIs3Pharmacy
				Set Is3Pharmacy=$s(Is3Pharmacy["Y":"是",1:"否")
				Set IsPreDrugFlag=objAnalysis.CPWAIsPreDrugFlag
				Set IsPreDrugFlag=$s(IsPreDrugFlag["Y":"是",1:"否")
			}
			// ***************************************************************
			
			Set IsComplicationFlag=objAnalysis.CPWAIsComplicationFlag
			Set IsComplicationFlag=$s(IsComplicationFlag["Y":"是",1:"否")
			Set SyndInfo=##class(web.DHCCPW.MR.ClinPathWaysSyndrome).GetSyndInfoByCPWID(PathWayID)
			Set Compl1Desc=$s($p(SyndInfo,"^",2)="":"无",1:$p(SyndInfo,"^",2))	// 合并症
			Set Compl2Desc=$s($p(SyndInfo,"^",3)="":"无",1:$p(SyndInfo,"^",3))	// 并发症
			Set NextDays=+objAnalysis.CPWAIsTimesInHospFlag
			
			//	*******Modified by zhaoyu 2012-11-12 临床路径月报明细增加:是否费用超标,是否住院日超标,参考费用,参考天数
			If $IsObject(objCPWDic){
				Set CPWDVersion=objCPWDic.CPWDVersion	//	DHC_MRC_ClinPathWays	临床路径版本
				//Set CPWId=$o(^DHCMRCi("CPWD",0,"IndexVersion",CPWDVersion,""))
				Set ObjClinPathWays=##class(User.DHCMRCClinPathWays).%OpenId(CPWDVersion)
				Set CPWCost=ObjClinPathWays.CPWCost	//	参考费用
				Set CPWDays=ObjClinPathWays.CPWDays	//	参考天数
				Set MaxCost=CPWCost	//	Modified by zhaoyu 2012-11-26
				Set MaxDays=CPWDays	//	Modified by zhaoyu 2012-11-26
				Set:CPWCost["-" MaxCost=+$p(CPWCost,"-",2)
				Set:CPWDays["-" MaxDays=+$p(CPWDays,"-",2)
				Set WhetherOverCost="否",WhetherOverDay="否"
				Set:+HospCost>MaxCost WhetherOverCost="是"
				Set:+AdmDays>MaxDays WhetherOverDay="是"
				Do ObjClinPathWays.%Close()
			}
			//	*******
			Set InMedicare=##class(web.DHCCPW.MR.Interface).GetMrNoByEpisodeID(Paadm)
			Set:CPWStatusDesc="" CPWStatusDesc="未入径"	// Add by zhaoyu 2013-05-03 未入径人数统计在入径人数中 282
			
			Set Data=$lb($g(AnalysisID))
			Set Data=Data_$lb($g(PapmiNo))
			Set Data=Data_$lb($g(InMedicare))
			Set Data=Data_$lb($g(PatName))
			Set Data=Data_$lb($g(Sex))
			Set Data=Data_$lb($g(Age))
			Set Data=Data_$lb($g(AdmLoc))
			Set Data=Data_$lb($g(AdmWard))
			Set Data=Data_$lb($g(AdmDoc))
			Set Data=Data_$lb($g(Diagnos))
			Set Data=Data_$lb($g(CPWDicDesc))
			Set Data=Data_$lb($g(CPWStatusDesc))
			Set Data=Data_$lb($g(IsVarPat))
			Set Data=Data_$lb($g(AdmitDate))
			Set Data=Data_$lb($g(DischDate))
			Set Data=Data_$lb($g(AdmDays))
			Set Data=Data_$lb($g(OperDate))
			Set Data=Data_$lb($g(OperAdmDays))
			Set Data=Data_$lb($g(OutStatus))
			Set Data=Data_$lb($g(IsInHospInf))
			Set Data=Data_$lb($g(IsOperInf))
			Set Data=Data_$lb($g(HospCost))
			Set Data=Data_$lb($g(DrugCost))
			Set Data=Data_$lb($g(LabCost))
			Set Data=Data_$lb($g(CheckCost))
			Set Data=Data_$lb($g(MaterialCost))
			
			//****************************************
			//中医相关的临床路径统计指标
			Set Data=Data_$lb($g(ProprMedCost))
			Set Data=Data_$lb($g(HerbalMedCost))
			Set Data=Data_$lb($g(WesternMedCost))
			Set Data=Data_$lb($g(TherapyCost))
			Set Data=Data_$lb($g(ChTherapyCost))
			Set Data=Data_$lb($g(CharaTherapyCost))
			Set Data=Data_$lb($g(IsPiecesMed))
			Set Data=Data_$lb($g(IsProprMed))
			Set Data=Data_$lb($g(IsCharaTherapy))
			Set Data=Data_$lb($g(IsChTherapy))
			//****************************************
			
			Set Data=Data_$lb($g(Is3Pharmacy))
			Set Data=Data_$lb($g(PharmacyDays))
			Set Data=Data_$lb($g(PharmacyCost))
			Set Data=Data_$lb($g(TimesOperFlag))
			Set Data=Data_$lb($g(IsPreDrugFlag))
			Set Data=Data_$lb($g(IsComplicationFlag))
			//Set:NextDays<0 NextDays=0		// Note by zhaoyu 2013-05-03 当天再入院人数比例/14日再住院率/31日再住院率,一直显示为100% 281
			Set Data=Data_$lb($g(NextDays))
			Set Data=Data_$lb($g(NotInCPWReason))
			Set Data=Data_$lb($g(CPWDID))	//zhaoyu 2013-01-07
			Set Data=Data_$lb($g(AdmLocID))	//zhaoyu 2013-01-07
			Set Data=Data_$lb($g(Is24HOutPathWay))	//zhaoyu 2013-01-07
			//	*******Modified by zhaoyu 2012-11-12 临床路径月报明细增加:是否费用超标,是否住院日超标,参考费用,参考天数
			//	CPWCost	CPWDays
			Set Data=Data_$lb($g(CPWCost))
			Set Data=Data_$lb($g(CPWDays))
			//	WhetherOverCost,WhetherOverDay
			Set Data=Data_$lb($g(WhetherOverCost))
			Set Data=Data_$lb($g(WhetherOverDay))
			//	*******
			Set Data=Data_$lb($g(IsPharmacy))	// IsPharmacy Add by zhaoyu 2013-05-27 是否使用抗生素
			Set Data=Data_$lb($g(Compl1Desc))
			Set Data=Data_$lb($g(Compl2Desc))
			Set Data=Data_$lb($g(InPathDays))
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCPWDischDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWDischDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWDischDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWDischDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-07-10
/// Description:  评估记录统计结果
/// Input：       DateFrom(开始日期),DateTo(结束日期),AnalysysType(统计类型)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWayAnalysisSrv","QryPathWayResult","","2012-07-01","2012-07-18","","")
Query QryPathWayResult(argDateFrom As %String, argDateTo As %String, aCPWDID As %String, argAnalysysType As %String = "", argLoc As %String = "") As %Query(ROWSPEC = "ItemCat:%String,ItemDesc:%String,ItemNum:%String,ItemResume:%String")
{
}

ClassMethod QryPathWayResultExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, aCPWDID As %String, argAnalysysType As %String, argLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryPathWayResult"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set ^TMP(ZIndex,JIndex,NIndex,"单一治疗方法","中药汤剂")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"单一治疗方法","中成药")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"单一治疗方法","针灸")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"单一治疗方法","推拿")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"综合治疗方法","2项")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"综合治疗方法","3项")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"综合治疗方法","3项以上")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"疗效","治愈")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"疗效","好转")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"疗效","无效")=0
	Set ^TMP(ZIndex,JIndex,NIndex,"疗效","死亡")=0
	
	//按病种统计
	Set Count=0
	Set iDischDate=argDateFrom-1
	For {
		Set iDischDate=$o(^DHCMRi("CPWA",0,"IndexDischDate",iDischDate))
		Quit:iDischDate=""
		Quit:iDischDate>argDateTo
		Set AnalysisID=0
		For {
			Set AnalysisID=$o(^DHCMRi("CPWA",0,"IndexDischDate",iDischDate,AnalysisID))
			Quit:AnalysisID=""
			
			Set objAnalysis=..GetObjById(AnalysisID)
			Continue:'$IsObject(objAnalysis)
			//Continue:(objAnalysis.CPWARegLocID'=argLoc)&(argLoc'="")
			Continue:(objAnalysis.CPWACPWLoc'=argLoc)&(argLoc'="")
			Set AdmStatus=objAnalysis.CPWAAdmStatus
			Continue:AdmStatus'="D"
			Set CPWDID=objAnalysis.CPWACPWDID
			Continue:CPWDID=""
			Continue:(aCPWDID'="")&&(aCPWDID'=CPWDID)
			
			Set PathWayID=objAnalysis.CPWAPathWayID
			Continue:PathWayID=""
			Set Paadm=objAnalysis.CPWAPaadm
			
			Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
			Continue:'$IsObject(objCPWDic)
			Set CPWDicDesc=objCPWDic.CPWDDesc
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			Set CPWStatus=$s($IsObject(objPathWay):objPathWay.CPWStatus,1:"")
			Continue:(argAnalysysType=2)&&(CPWStatus="")    //按入径统计
			Continue:(argAnalysysType=3)&&(CPWStatus'="C")  //按完成统计
			Continue:(argAnalysysType=4)&&(CPWStatus'="")   //按不入径统计
			
			Set Count=Count+1
			
			Set RstSubID=$o(^DHCMR("CPW",PathWayID,"RST",""),-1)
			Continue:RstSubID=""
			Set objResult=##class(web.DHCCPW.MR.ClinPathWaysResult).GetObjById(PathWayID_"||"_RstSubID)
			Continue:'$IsObject(objResult)
			Set CPWREvaluations=objResult.CPWREvaluations
			Continue:CPWREvaluations=""
			Continue:CPWREvaluations=$c(1)
			
			Set (ZLFF,ZZGS,TZGS,LHZB,LX)=""
			For indEva=1:1:$listlength(CPWREvaluations)
			{
				Set ItemStr=$list(CPWREvaluations,indEva)
				Continue:ItemStr=""
				Set ItemID=$p(ItemStr,":",1)
				Set objItem=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set ItemDesc=objItem.BDSCDesc
				
				If ItemDesc="治疗方法" {
					Set ZLFF=$e(ItemStr,$l(ItemID)+2,$l(ItemStr))
				}
				If ItemDesc="症状改善" {
					Set ZZGS=$e(ItemStr,$l(ItemID)+2,$l(ItemStr))
					Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(ZZGS)
					Continue:'$IsObject(objDic)
					Set ZZGS=objDic.BDDesc
				}
				If ItemDesc="体征改善" {
					Set TZGS=$e(ItemStr,$l(ItemID)+2,$l(ItemStr))
					Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(TZGS)
					Continue:'$IsObject(objDic)
					Set TZGS=objDic.BDDesc
				}
				If ItemDesc="理化指标" {
					Set LHZB=$e(ItemStr,$l(ItemID)+2,$l(ItemStr))
					Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(LHZB)
					Continue:'$IsObject(objDic)
					Set LHZB=objDic.BDDesc
				}
				If ItemDesc="疗效" {
					Set LX=$e(ItemStr,$l(ItemID)+2,$l(ItemStr))
					Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(LX)
					Continue:'$IsObject(objDic)
					Set LX=objDic.BDDesc
				}
			}
			
			Set Item1="",Item2=""
			Set Count=0,ItemValue=""
			For indVal=1:1:$l(ZLFF,",")
			{
				Set DicID=$p(ZLFF,",",indVal)
				Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(DicID)
				Continue:'$IsObject(objDic)
				Set Count=Count+1
				Set ItemValue=objDic.BDDesc
			}
			If Count=1 {
				Set Item1="单一治疗方法"
				Set Item2=ItemValue
			} ElseIf Count=2 {
				Set Item1="综合治疗方法"
				Set Item2="2项"
			} ElseIf Count=3 {
				Set Item1="综合治疗方法"
				Set Item2="3项"
			} ElseIf Count>3 {
				Set Item1="综合治疗方法"
				Set Item2="3项以上"
			} Else {
				//无
			}
			Set:LX="" LX="治愈"
			Set:ZZGS="" ZZGS="是"
			Set:TZGS="" TZGS="是"
			Set:LHZB="" LHZB="是"
			If (Item1'="")&&(Item2'="") {
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,Item1,Item2))
				Set:LX'="" num=$i(^TMP(ZIndex,JIndex,NIndex,Item1,Item2,LX))
			}
			Set:ZZGS'="" num=$i(^TMP(ZIndex,JIndex,NIndex,"治疗效果","症状改善",ZZGS))
			Set:TZGS'="" num=$i(^TMP(ZIndex,JIndex,NIndex,"治疗效果","体征改善",TZGS))
			Set:LHZB'="" num=$i(^TMP(ZIndex,JIndex,NIndex,"治疗效果","理化指标",LHZB))
			Set:LX'="" num=$i(^TMP(ZIndex,JIndex,NIndex,"疗效",LX))
		}
	}
	
	Set Data=$lb("","总人数",Count,"")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set xItem="",xItmCount=0
	For {
		Set xItem=$o(^TMP(ZIndex,JIndex,NIndex,"单一治疗方法",xItem))
		Quit:xItem=""
		Set Num=+$g(^TMP(ZIndex,JIndex,NIndex,"单一治疗方法",xItem))
		Set Num1=+$g(^TMP(ZIndex,JIndex,NIndex,"单一治疗方法",xItem,"治愈"))
		Set Num2=+$g(^TMP(ZIndex,JIndex,NIndex,"单一治疗方法",xItem,"好转"))
		Set Num3=+$g(^TMP(ZIndex,JIndex,NIndex,"单一治疗方法",xItem,"无效"))
		Set Num4=+$g(^TMP(ZIndex,JIndex,NIndex,"单一治疗方法",xItem,"死亡"))
		Set LXStr="治愈 "_Num1_" 例   好转 "_Num2_" 例   无效 "_Num3_" 例   死亡 "_Num4_" 例"
		Set xItmCount=xItmCount+1
		
		Set Data=$lb("单一治疗方法",xItem,Num,LXStr)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xItem=""
	For {
		Set xItem=$o(^TMP(ZIndex,JIndex,NIndex,"综合治疗方法",xItem))
		Quit:xItem=""
		Set Num=+$g(^TMP(ZIndex,JIndex,NIndex,"综合治疗方法",xItem))
		Set Num1=+$g(^TMP(ZIndex,JIndex,NIndex,"综合治疗方法",xItem,"治愈"))
		Set Num2=+$g(^TMP(ZIndex,JIndex,NIndex,"综合治疗方法",xItem,"好转"))
		Set Num3=+$g(^TMP(ZIndex,JIndex,NIndex,"综合治疗方法",xItem,"无效"))
		Set Num4=+$g(^TMP(ZIndex,JIndex,NIndex,"综合治疗方法",xItem,"死亡"))
		Set LXStr="治愈 "_Num1_" 例   好转 "_Num2_" 例   无效 "_Num3_" 例   死亡 "_Num4_" 例"
		Set Data=$lb("综合治疗方法",xItem,Num,LXStr)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set num=$g(^TMP(ZIndex,JIndex,NIndex,"治疗效果","症状改善","是"))
	Set Data=$lb("治疗效果","症状改善",Num,"")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set num=$g(^TMP(ZIndex,JIndex,NIndex,"治疗效果","体征改善","是"))
	Set Data=$lb("治疗效果","体征改善",Num,"")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set num=$g(^TMP(ZIndex,JIndex,NIndex,"治疗效果","理化指标","是"))
	Set Data=$lb("治疗效果","理化指标",Num,"")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set xItem=""
	For {
		Set xItem=$o(^TMP(ZIndex,JIndex,NIndex,"疗效",xItem))
		Quit:xItem=""
		Set Num=+$g(^TMP(ZIndex,JIndex,NIndex,"疗效",xItem))
		Set Data=$lb("疗效",xItem,Num,"")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
}

ClassMethod QryPathWayResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathWayResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathWayResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathWayResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 描述：获取变异记录根据病人就诊ID
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWayAnalysisSrv","QryVariByPaadm",67980)
Query QryVariByAnalysis(argAnalysisID As %String) As %Query(ROWSPEC = "PapmiNo:%String,PatName:%String,CPWDic:%String,VarCate:%String,VarReason:%String,VarNote:%String,Date:%String,Time:%String,User:%String,Doctor:%String,Flag:%String,UpdoUser:%String") [ SqlProc ]
{
}

ClassMethod QryVariByAnalysisExecute(ByRef qHandle As %Binary, argAnalysisID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ObjAnalysis=##Class(User.DHCMRClinPathWayAnalysis).%OpenId(argAnalysisID)
	Quit:'$IsObject(ObjAnalysis) $$$OK
	Set Paadm=ObjAnalysis.CPWAPaadm
    Quit:Paadm=""
	Set MrAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdm,""),-1)
	Set ObjPathWay=##Class(User.DHCMRClinicalPathWay).%OpenId(PathWayID)
	Quit:'$IsObject(ObjPathWay) $$$OK
	Set ObjClinPathWay=ObjPathWay.CPWPathwayDR
	Quit:'$IsObject(ObjClinPathWay) $$$OK
	Set ObjCPWDic=ObjClinPathWay.CPWCPWDicDR
	Quit:'$IsObject(ObjCPWDic) $$$OK
	
	Set Papmi=$p($g(^PAADM(Paadm)),"^",1)
	Quit:Papmi="" $$$OK
	Set PapmiNo=$p($g(^PAPER(Papmi,"PAT",1)),"^",1)  ;登记号
	Set PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)    ;病人姓名
	Set CPWDic=ObjCPWDic.CPWDDesc                    ;路径名称
	Set VarID=0
	For {
		Set VarID=$o(^DHCMR("CPW",PathWayID,"VAR",VarID))
		Quit:VarID=""
		
		Set VarObj=##Class(User.DHCMRClinicalPathWayVariance).%OpenId(PathWayID_"||"_VarID)
		Continue:'$IsObject(VarObj)
		Set (VarCate,VarReason,VarNote,Date,Time,User,Doctor,Flag,UpdoUser)=""
		Set ObjCate=VarObj.CPWVCategoryDR
		If ($IsObject(ObjCate)){
			Set VarCate=ObjCate.VCDesc	
		}
		Set ObjReason=VarObj.CPWVReasonDR
		If ($IsObject(ObjReason)){
			Set VarReason=ObjReason.VRDesc
	    }
	    Set VarNote=VarObj.CPWVNote
	    Set Date=$zd(VarObj.CPWVDate,3)
	    Set Time=$zt(VarObj.CPWVTime,1)
	    Set UserID=VarObj.CPWVUserDR
	    Set User=$p($g(^SSU("SSUSR",UserID)),"^",2)
	    Set DoctorID=VarObj.CPWVDoctorDR
	    Set Doctor=$p($g(^CTPCP(DoctorID,1)),"^",2)
	    Set Flag=VarObj.CPWVUpdoFlag
	    Set UpdoUserID=VarObj.CPWVUpdoUserDR
	    Set:(Flag="Y")&&(UpdoUserID'="") UpdoUser=$p($g(^SSU("SSUSR",UpdoUserID)),"^",2)
	    Continue:Flag="Y"
	    Set Data=$lb(PapmiNo,PatName,CPWDic,VarCate,VarReason,VarNote,Date,Time,User,Doctor,Flag,UpdoUser)
	    Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	    
	}
	Quit $$$OK
}

ClassMethod QryVariByAnalysisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVariByAnalysisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVariByAnalysisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVariByAnalysisExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
