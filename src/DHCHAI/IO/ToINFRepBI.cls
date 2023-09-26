/// 名称: DHCHAI.IO.ToINFRepBI
/// 描述: 与BI组相关接口
/// 编写者：zhoubo
/// 编写日期: 2018-06-08
Class DHCHAI.IO.ToINFRepBI Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-06-08
/// Description:  根据报告ID获取报告信息
/// Input：       aReportID ：报告ID
/// Return：      报告的信息 
/// 通过HIS就诊ID找数据池就诊ID:w ##class(DHCHAI.IO.ToINFRepBI).GetEpisodeDr()
/// 索引:^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,"1",xID))
/// 取值:arrRepInfo.GetAt("InfRepDigas")
/// w ##class(DHCHAI.IO.ToINFRepBI).GetNewInfByRepID(28)
ClassMethod GetNewInfByRepID(aReportID As %String) As %String
{
	New (aReportID)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:aReportID="" return
	
	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IREpisodeDr) return
	Set EpisodeID = objRep.IREpisodeDr.%Id()
	Set objPaadm  = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm) return
	Set Dischdate   = objPaadm.PADischDate                   // 出院日期
	Set AdmDoctor   = $p(objPaadm.PAAdmDoc,"|",1)            // 主管医生
	Set PAPatientID = objPaadm.PAPatientIDx                  // HIS病人基本信息表 User.PAPatMas ID
	Set PaadmID     = $p(objPaadm.PAEpisodeIDx,"||",2)       // HIS就诊表 User.PAAdm ID
	// 报告状态
	Set objStatus = objRep.IRStatusDr
	Set (RepStatusID,RepStatusDesc,RepStatusCode)=""
	If $IsObject(objStatus){
		Set RepStatusID   = objStatus.%Id()
		Set RepStatusDesc = objStatus.BTDesc
		Set RepStatusCode = objStatus.BTCode
	}
	Quit:((RepStatusCode'=2)&&(RepStatusCode'=3)) return  // 2:提交 3:审核
	Set InfectSource = "医院感染"
	Set RepDate = objRep.IRRepDate    // 报告日期
	Set RepTime = objRep.IRRepTime    // 报告时间
	// 就诊科室
	Set (AdmLocDr,AdmLocDesc)=""
	Set objAdmLoc = objPaadm.PAAdmLocDr
	If $IsObject(objAdmLoc){
		Set AdmLocDr   = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
	}
	// 报告科室
	Set (RepLocDr,RepLocDesc)=""
	Set objRepLoc = objRep.IRRepLocDr
	If $IsObject(objRepLoc){
		Set RepLocDr   = objRepLoc.%Id()
		Set RepLocDesc = objRepLoc.BTDesc
	}
	// 报告人
	Set (RepUserDr,RepUserDesc)=""
	Set objRepUser = objRep.IRRepUser
	If $IsObject(objRepUser){
		Set RepUserDr   = objRepUser.%Id()
		Set RepUserDesc = objRepUser.BTDesc
	}
	Do return.SetAt(InfectSource,"InfectSource")  // 感染类型
	Do return.SetAt(AdmDoctor,"AdmDoctor")        // 主管医生
	Do return.SetAt(PAPatientID,"PAPatientID")    // User.PAPatMas
	Do return.SetAt(PaadmID,"PaadmID")            // User.PAAdm
	Do return.SetAt(RepDate,"RepDate")            // 报告日期
	Do return.SetAt(RepTime,"RepTime")            // 报告时间
	Do return.SetAt(AdmLocDesc,"AdmLocDesc")      // 就诊科室名称
	Do return.SetAt(RepLocDesc,"RepLocDesc")      // 报告科室名称
	Do return.SetAt(RepUserDesc,"RepUserDesc")    // 报告人
	
	// 感染诊断信息
	Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
	Set InfRepDigas = ##Class(%Library.ListOfDataTypes).%New()
	For indx = 1:1:$l(LinkDiags,","){
		Set xDiagID = $p(LinkDiags,",",indx)
		Continue:xDiagID=""
		
		Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiags)
		
		// 感染部位/感染诊断
		Set (InfPosDr,InfPosDesc,InfDiagDr,InfDiagDesc)=""
		Set objInfDiag = objDiags.IRInfPosDr
		If $IsObject(objInfDiag){
			Set InfDiagDr   = objInfDiag.%Id()
			Set InfDiagDesc = objInfDiag.BTDesc
			Set InfDiagCode = objInfDiag.BTCode
			Set objInfPos =##class(DHCHAI.BT.InfPos).GetObjByCode($e(InfDiagCode,1,2))
			If $IsObject(objInfPos){
				Set InfPosDr   = objInfPos.%Id()
				Set InfPosDesc = objInfPos.BTDesc
			}
		}
		// 感染诊断子分类
		Set (InfSubDr,InfSubDesc)=""
		Set objInfSub = objDiags.IRInfSubDr
		If $IsObject(objInfSub){
			Set InfSubDr   = objInfSub.%Id()
			Set InfSubDesc = objInfSub.BTDesc
		}
		// 感染转归/疗效
		Set (InfEffectDr,InfEffectDesc)=""
		Set objInfEffect = objDiags.IRInfEffectDr
		If $IsObject(objInfEffect){
			Set InfEffectDr   = objInfEffect.%Id()
			Set InfEffectDesc = objInfEffect.BTDesc
		}
		// 与死亡关系
		Set (DeathRelDr,DeathRelDesc)=""
		Set objDeathRel = objDiags.IRDeathRelationDr
		If $IsObject(objDeathRel){
			Set DeathRelDr   = objDeathRel.%Id()
			Set DeathRelDesc = objDeathRel.BTDesc
		}
		// 感染科室
		Set (InfLocDr,InfLocDesc)=""
		Set objInfLoc = objDiags.IRInfLocDr
		If $IsObject(objInfLoc){
			Set InfLocDr   = objInfLoc.%Id()
			Set InfLocDesc = objInfLoc.BTDesc
		}
		Set InfDate = objDiags.IRInfDate       // 感染日期
		Set InfEndDate = objDiags.IRInfXDate   // 感染转归日期
		If (InfEndDate'=""){
			Set InfDays = InfEndDate-InfDate   // 感染天数
		}Else{
			If (Dischdate=""){
				Set InfDays = (+$h)-InfDate
			}Else{
				Set InfDays = Dischdate-InfDate
			}
		}
		Set InfDiagStr = xDiagID
		Set InfDiagStr = InfDiagStr_"^"_InfPosDr        // 感染部位Dr
		Set InfDiagStr = InfDiagStr_"^"_InfPosDesc      // 感染部位描述
		Set InfDiagStr = InfDiagStr_"^"_InfDiagDr       // 感染诊断Dr
		Set InfDiagStr = InfDiagStr_"^"_InfDiagDesc     // 感染诊断描述
		Set InfDiagStr = InfDiagStr_"^"_InfSubDr        // 诊断子分类Dr
		Set InfDiagStr = InfDiagStr_"^"_InfSubDesc      // 诊断子分类描述
		Set InfDiagStr = InfDiagStr_"^"_InfEffectDr     // 感染转归/疗效Dr
		Set InfDiagStr = InfDiagStr_"^"_InfEffectDesc   // 感染转归/疗效描述
		Set InfDiagStr = InfDiagStr_"^"_DeathRelDr      // 与死亡关系Dr
		Set InfDiagStr = InfDiagStr_"^"_DeathRelDesc    // 与死亡关系描述
		Set InfDiagStr = InfDiagStr_"^"_InfLocDr        // 感染科室Dr
		Set InfDiagStr = InfDiagStr_"^"_InfLocDesc      // 感染科室描述
		Set InfDiagStr = InfDiagStr_"^"_InfDate         // 感染日期
		Set InfDiagStr = InfDiagStr_"^"_InfEndDate      // 感染转归日期
		Set InfDiagStr = InfDiagStr_"^"_InfDays         // 感染天数
		
		Do InfRepDigas.Insert(InfDiagStr)
	}
	Do return.SetAt(InfRepDigas,"InfRepDigas")          // 感染诊断信息
	
	// 手术信息
	Set LinkOPSs = objRep.GetRepLinkIDs("DHCHAI.IR.INFOPS")
	Set InfRepOPSs = ##Class(%Library.ListOfDataTypes).%New()
	For indx = 1:1:$l(LinkOPSs,","){
		Set xOprID = $p(LinkOPSs,",",indx)
		Continue:xOprID=""
		
		Set objOpr = ##class(DHCHAI.IR.INFOPS).GetObjById(xOprID)
		Continue:'$IsObject(objOpr)
		Set OperName   = objOpr.IROperName    // 手术名称
		Set OperDate   = objOpr.IROperDate    // 手术开始日期
		Set SttTime    = objOpr.IRSttTime     // 手术开始时间
		Set EndDate    = objOpr.IREndDate     // 手术结束日期
		Set EndTime    = objOpr.IREndTime     // 手术结束时间
		Set OperHours  = objOpr.IROperHours   // 手术时长
		Set OperDoc    = objOpr.IROperDocTxt  // 手术医生
		Set CuteNumber = objOpr.IRCuteNumber  // 切口个数
		// 手术科室
		Set (OperLocDr,OperLocDesc)=""
		Set objOperLoc = objOpr.IROperLocDr
		If $IsObject(objOperLoc){
			Set OperLocDr   = objOperLoc.%Id()
			Set OperLocDesc = objOperLoc.BTDesc
		}
		// 手术类型
		Set (OperTypeDr,OperTypeDesc)=""
		Set objOperType = objOpr.IROperTypeDr
		If $IsObject(objOperType){
			Set OperTypeDr   = objOperType.%Id()
			Set OperTypeDesc = objOperType.BTDesc
		}
		// 麻醉方式
		Set (AnestDr,AnestDesc)=""
		Set objAnest = objOpr.IRAnesthesiaDr
		If $IsObject(objAnest){
			Set AnestDr   = objAnest.%Id()
			Set AnestDesc = objAnest.BTDesc
		}
		// NNIS分级
		Set (NNISDr,NNISDesc)=""
		Set objNIS = objOpr.IRNNISLevelDr
		If $IsObject(objNIS){
			Set NNISDr   = objNIS.%Id()
			Set NNISDesc = objNIS.BTDesc
		}
		// 切口类型
		Set (CuteTypeDr,CuteTypeDesc)=""
		Set objCuteType = objOpr.IRCuteTypeDr
		If $IsObject(objCuteType){
			Set CuteTypeDr   = objCuteType.%Id()
			Set CuteTypeDesc = objCuteType.BTDesc
		}
		// 愈合情况
		Set (CuteHealDr,CuteHealDesc)=""
		Set objCuteHeal = objOpr.IRCuteHealingDr
		If $IsObject(objCuteHeal){
			Set CuteHealDr   = objCuteHeal.%Id()
			Set CuteHealDesc = objCuteHeal.BTDesc
		}
		// ASA评分
		Set (ASAScoreDr,ASAScoreDesc)=""
		Set objASAScore = objOpr.IRASAScore
		If $IsObject(objASAScore){
			Set ASAScoreDr   = objASAScore.%Id()
			Set ASAScoreDesc = objASAScore.BTDesc
		}
		// 手术感染类型
		Set (InfTypeDr,InfTypeDesc)=""
		Set objInfType = objOpr.IRInfTypeDr
		If $IsObject(objInfType){
			Set InfTypeDr   = objInfType.%Id()
			Set InfTypeDesc = objInfType.BTDesc
		}
		Set IsOperInf     = objOpr.IRIsOperInf        // 是否切口感染
		Set IsInHospInf   = objOpr.IRIsInHospInf      // 是否引起院内感染
		Set PreoperWBC    = objOpr.IRPreoperWBC       // 术前外周WBC计数
		Set EndoscopeFlag = objOpr.IREndoscopeFlag    // 是否使用窥镜
		Set ImplantFlag   = objOpr.IRImplantFlag      // 是否植入物
		
		Set InfOPSStr = xOprID
		Set InfOPSStr = InfOPSStr_"^"_OperName        // 手术名称
		Set InfOPSStr = InfOPSStr_"^"_OperDate        // 手术日期
		Set InfOPSStr = InfOPSStr_"^"_SttTime         // 手术时间
		Set InfOPSStr = InfOPSStr_"^"_EndDate         // 手术结束日期
		Set InfOPSStr = InfOPSStr_"^"_EndTime         // 手术结束时间
		Set InfOPSStr = InfOPSStr_"^"_OperHours       // 手术时长
		Set InfOPSStr = InfOPSStr_"^"_OperDoc         // 手术医生
		Set InfOPSStr = InfOPSStr_"^"_CuteNumber      // 切口个数
		Set InfOPSStr = InfOPSStr_"^"_OperLocDr       // 手术科室Dr
		Set InfOPSStr = InfOPSStr_"^"_OperLocDesc     // 手术科室名称
		Set InfOPSStr = InfOPSStr_"^"_OperTypeDr      // 手术类型Dr
		Set InfOPSStr = InfOPSStr_"^"_OperTypeDesc    // 手术类型名称
		Set InfOPSStr = InfOPSStr_"^"_AnestDr         // 麻醉方式Dr
		Set InfOPSStr = InfOPSStr_"^"_AnestDesc       // 房最方式名称
		Set InfOPSStr = InfOPSStr_"^"_NNISDr          // NNIS分级Dr
		Set InfOPSStr = InfOPSStr_"^"_NNISDesc        // NNIS分级名称
		Set InfOPSStr = InfOPSStr_"^"_CuteTypeDr      // 切口类型Dr
		Set InfOPSStr = InfOPSStr_"^"_CuteTypeDesc    // 切口类型名称
		Set InfOPSStr = InfOPSStr_"^"_CuteHealDr      // 愈合情况Dr
		Set InfOPSStr = InfOPSStr_"^"_CuteHealDesc    // 愈合情况名称
		Set InfOPSStr = InfOPSStr_"^"_ASAScoreDr      // ASA评分Dr
		Set InfOPSStr = InfOPSStr_"^"_ASAScoreDesc    // ASA评分名称
		Set InfOPSStr = InfOPSStr_"^"_InfTypeDr       // 手术感染类型Dr
		Set InfOPSStr = InfOPSStr_"^"_InfTypeDesc     // 手术感染类型名称
		Set InfOPSStr = InfOPSStr_"^"_IsOperInf       // 是否切口感染
		Set InfOPSStr = InfOPSStr_"^"_IsInHospInf     // 是否引起院内感染
		Set InfOPSStr = InfOPSStr_"^"_PreoperWBC      // 术前外周WBC计数
		Set InfOPSStr = InfOPSStr_"^"_EndoscopeFlag   // 是否使用窥镜
		Set InfOPSStr = InfOPSStr_"^"_ImplantFlag     // 是否植入物
		
		Do InfRepOPSs.Insert(InfOPSStr)
	}
	Do return.SetAt(InfRepOPSs,"InfRepOPSs")          // 手术信息
	
	Quit return
}

/// 通过HIS就诊号取HAI就诊
/// w ##class(DHCHAI.IO.ToINFRepBI).GetEpisodeDr(79)
ClassMethod GetEpisodeDr(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//根据医院对照取HIS系统代码(HISCode)
	Set HISCode=""
	Set XLocID=$p($g(^PAADM(aEpisodeID)),"^",4) //就诊科室
	Quit:XLocID="" return
	Set XHospID=$p($g(^CTLOC(+XLocID)),"^",22)
	Set:XHospID="" XHospID=$o(^CT("HOSP",0))  //部分科室没有关联医院
	Set objHospMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode("HISSYS",XHospID)
	If $IsObject(objHospMap){
		Set objHosp=objHospMap.BTMapHospDr
		Set:$IsObject(objHosp) HISCode=$p(objHosp.BTXCode,"||",1)
	}
	Quit:HISCode="" return
	
	Set EpisodeIDX=HISCode_"||"_aEpisodeID
	Set objEpisodeDr=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(EpisodeIDX)
	If $IsObject(objEpisodeDr){
		Set return=objEpisodeDr.%Id()
	}
	Quit return
}

}
