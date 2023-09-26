/// 名称: DHCHAI.DI.DIO.FromINFSrv
/// 描述: 历史院感数据接口
/// 编写者：zhufei
/// 编写日期: 2017-10-27
Class DHCHAI.DI.DIO.FromINFSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-10-27
/// Description:  查询历史院感信息
/// Input：       aEpisodeID : HIS就诊ID
/// Return：      ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromINFSrv","QryInfRepList","1575")
Query QryInfRepList(aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,ReportType:%String,RepLocID:%String,RepLocCode:%String,RepLocDesc:%String,ReportDate:%String,ReportTime:%String,RepUserID:%String,RepUserCode:%String,RepUserDesc:%String,RepStatusCode:%String,RepStatusDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInfRepListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 	
	Set xID=0
	For {
		Set xID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.ReportType)
		Set ReportType=obj.ReportType.Code  //COMP/NCOM/ICU/NICU  院感报告/新生儿感染/ICU调查/NICU调查
		Set ReportLoc=obj.ReportLoc         //报告科室 指向CT_Loc
	    Set RepLocCode="",RepLocDesc=""
	    If ReportLoc'="" {
		    Set RepLocCode=$p($g(^CTLOC(ReportLoc)),"^",1)
		    Set RepLocDesc=$p($g(^CTLOC(ReportLoc)),"^",2)
		}
	    Set ReportUser=obj.ReportUser       //报告人员 指向SS_User
	    Set RepUserCode="",RepUserDesc=""
	    If ReportUser'="" {
		    Set RepUserCode=$p($g(^SSU("SSUSR",ReportUser)),"^",1)
		    Set RepUserDesc=$p($g(^SSU("SSUSR",ReportUser)),"^",2)
	    }
		Set ReportDate=obj.ReportDate          // 报告日期
		Set ReportTime=obj.ReportTime          // 报告时间
		Set RepStatusDesc="",RepStatusCode=""  // 报告状态
		If $IsObject(obj.ReportStatus){
			Set RepStatusCode=obj.ReportStatus.Code
			Set RepStatusDesc=obj.ReportStatus.Description
		}
		
		Set Data=$lb(xID,aEpisodeID,ReportType,ReportLoc,RepLocCode,RepLocDesc,ReportDate,ReportTime,ReportUser,RepUserCode,RepUserDesc,RepStatusCode,RepStatusDesc)
        Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryInfRepListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfRepListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfRepListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfRepListExecute ]
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

/// w ##Class(DHCHAI.DI.DIO.FromINFSrv).GetInfReport(64)
ClassMethod GetInfReport(aReportID As %String) As %String
{
	New (aReportID)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:aReportID="" return
	
    Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Set EpisodeID=objReport.EpisodeID
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm) return
	
	//摘要
	Set SummID=$o(^DHCMed.NINF("InfRep",aReportID,"Summ",""),-1)
	Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(aReportID_"||"_SummID)
	If $IsObject(objSumm) {
		Do return.SetAt(objSumm.DiseasePrognosis,"DiseasePrognosis")   // 疾病转归
		Do return.SetAt(objSumm.DiagnosisBasis,"DiagnosisBasis")       // 诊断依据
		Do return.SetAt(objSumm.DiseaseCourse,"DiseaseCourse")         // 感染性疾病病程
		Do return.SetAt(objSumm.TransInDate,"TransInDate")             // 转入日期
		Do return.SetAt(objSumm.TransOutDate,"TransOutDate")           // 转出日期
		Do return.SetAt(objSumm.OutICUStatus,"OutICUStatus")           // 转出ICU时状态(带管情况)
		Do return.SetAt(objSumm.OutICU48Status,"OutICU48Status")       // 转出ICU48小时内状态(带管情况)
		Do return.SetAt(objSumm.ApacheIIScore,"ApacheIIScore")         // APACHE II评分
		
	    Set DeathRelation=""
	    If $IsObject(objSumm.DeathRelation) {
			Set DeathRelation=objSumm.DeathRelation.Description
		}
		Do return.SetAt(DeathRelation,"DeathRelation")                 //与死亡关系
		
	    Set (TransFromLocID,TransFromLocCode,TransFromLocDesc)=""
	    Set objFromLoc=##class(DHCMed.Base.Ctloc).GetObjById(objSumm.TransFromLoc)
		If $IsObject(objFromLoc) {
			Set TransFromLocID=objFromLoc.Rowid
			Set TransFromLocCode=objFromLoc.Code
			Set TransFromLocDesc=objFromLoc.Descs
		}
		Do return.SetAt(TransFromLocID,"TransFromLocID")               // 入科来源ID
		Do return.SetAt(TransFromLocCode,"TransFromLocCode")           // 入科来源代码
		Do return.SetAt(TransFromLocDesc,"TransFromLocDesc")           // 入科来源名称
		
		Set (TransToLocID,TransToLocCode,TransToLocDesc)=""
		Set objToLoc=##class(DHCMed.Base.Ctloc).GetObjById(objSumm.TransToLoc)
		If $IsObject(objToLoc) {
			Set TransToLocID=objToLoc.Rowid
			Set TransToLocCode=objToLoc.Code
			Set TransToLocDesc=objToLoc.Descs
		}
		Do return.SetAt(TransToLocID,"TransToLocID")                   // 出科去向ID
		Do return.SetAt(TransToLocCode,"TransToLocCode")               // 出科去向代码
		Do return.SetAt(TransToLocDesc,"TransToLocDesc")               // 出科去向名称
		
		//易感因素 zhoubo
		Set FactorsDesc=""
		Set Cnt=objSumm.InfFactors.Count()
		For indArr=1:1:Cnt {
			Set objFact=objSumm.InfFactors.GetAt(indArr)
			Continue:'$IsObject(objFact)
			Set tmpFactorsDesc = objFact.Description
			Set:tmpFactorsDesc'="" FactorsDesc=FactorsDesc_","_tmpFactorsDesc
		}
		Set:FactorsDesc'="" FactorsDesc=$e(FactorsDesc,2,$l(FactorsDesc))
		Do return.SetAt(FactorsDesc,"FactorsDesc")
		//侵害性操作 zhoubo
		Set InvasiveDesc=""
		Set Cnt=objSumm.InvasiveOperation.Count()
		For indArr=1:1:Cnt {
			Set objOpr=objSumm.InvasiveOperation.GetAt(indArr)
			Continue:'$IsObject(objOpr)
			Set tmpInvasiveDesc = objOpr.Description
			Set:tmpInvasiveDesc'="" InvasiveDesc=InvasiveDesc_","_tmpInvasiveDesc
		}
		Set:InvasiveDesc'="" InvasiveDesc=$e(InvasiveDesc,2,$l(InvasiveDesc))
		Do return.SetAt(InvasiveDesc,"InvasiveDesc")
	}
	
    //感染诊断
	Set InfRepPos=##Class(%Library.ListOfDataTypes).%New()
	Set xPosID=0
	For {
		Set xPosID=$o(^DHCMed.NINF("InfRep",aReportID,"InfPos",xPosID))
		Quit:xPosID=""
		
		Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(aReportID_"||"_xPosID)
		Continue:'$IsObject(objInfPos)
		
		Set InfPosDesc=""
		If $IsObject(objInfPos.InfPos) {
			Set InfPosDesc=objInfPos.InfPos.IPDesc
		}
		Set InfDate  = objInfPos.InfDate
		Set InfXDate = objInfPos.InfEndDate
		Set InfEndResultDesc=""
	    If $IsObject(objInfPos.InfEndResult) {
			Set InfEndResultDesc=objInfPos.InfEndResult.Description
	    }
		Set InfDiagDesc=""
	    If $IsObject(objInfPos.InfDiag) {
			Set InfDiagDesc=objInfPos.InfDiag.IDDesc
	    }
		Set InfDiagCatDesc=""
		If $IsObject(objInfPos.InfDiagCat) {
			Set InfDiagCatDesc=objInfPos.InfDiagCat.Description
	    }
	    Set DiagnosisBasis = objInfPos.DiagnosisBasis
	    Set DiseaseCourse  = objInfPos.DiseaseCourse
	    
		Set InfPosStr=aReportID_"||"_xPosID
		Set InfPosStr=InfPosStr_"^"_InfPosDesc       //感染部位
		Set InfPosStr=InfPosStr_"^"_InfDiagDesc      //感染诊断
		Set InfPosStr=InfPosStr_"^"_InfDiagCatDesc   //诊断子分类
		Set InfPosStr=InfPosStr_"^"_InfDate          //感染日期
		Set InfPosStr=InfPosStr_"^"_InfXDate         //感染转归日期
		Set InfPosStr=InfPosStr_"^"_InfEndResultDesc //转归
		Set InfPosStr=InfPosStr_"^"_DiagnosisBasis   //诊断依据
		Set InfPosStr=InfPosStr_"^"_DiseaseCourse    //感染性疾病病程
		
		Do InfRepPos.Insert(InfPosStr)
	}
	Do return.SetAt(InfRepPos,"InfRepPos")               // 感染信息
	
	//基础疾病诊断 zhoubo
	Set InfRepDiag=##Class(%Library.ListOfDataTypes).%New()
	Set xDiagID=0
	For {
		Set xDiagID=$o(^DHCMed.NINF("InfRep",aReportID,"Diag",xDiagID))
		Quit:xDiagID=""
		
		Set objInfDiag=##class(DHCMed.NINF.Rep.InfReportDiag).GetObjById(aReportID_"||"_xDiagID)
		Continue:'$IsObject(objInfDiag)
			
		Set DiagnosID   = objInfDiag.DiagnosID     // 诊断ID
		Set Diagnos     = $p($g(^MRC("ID",+DiagnosID)),"^",2)
		Set DiagnosDesc = objInfDiag.DiagnosDesc   // 诊断名称
		Set DiagnosDate = objInfDiag.DiagnosDate   // 诊断日期
		Set DiagnosTime = objInfDiag.DiagnosTime   // 诊断时间
	    
		Set InfDiagStr=aReportID_"||"_xDiagID
		Set InfDiagStr=InfDiagStr_"^"_Diagnos      // 诊断字典 
		Set InfDiagStr=InfDiagStr_"^"_DiagnosDesc  // 诊断名称
		Set InfDiagStr=InfDiagStr_"^"_DiagnosDate  // 诊断日期
		Set InfDiagStr=InfDiagStr_"^"_DiagnosTime  // 诊断时间
		
		Do InfRepDiag.Insert(InfDiagStr)
	}
	Do return.SetAt(InfRepDiag,"InfRepDiag")
	
	// 手术信息 zhoubo
	Set InfRepOper=##Class(%Library.ListOfDataTypes).%New()
	Set xOperID=0
	For {
		Set xOperID=$o(^DHCMed.NINF("InfRep",aReportID,"Opr",xOperID))
		Quit:xOperID=""
		
		Set objInfOper=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(aReportID_"||"_xOperID)
		Continue:'$IsObject(objInfOper)
		
		Set OperationDesc = objInfOper.OperationDesc   // 手术名称
		Set OperStartDate = objInfOper.OperStartDate   // 手术开始日期
		Set OperStartTime = objInfOper.OperStartTime   // 手术开始时间
		Set OperEndDate   = objInfOper.OperEndDate     // 手术结束日期
		Set OperEndTime   = objInfOper.OperEndTime     // 手术结束时间
		Set OperDoc       = objInfOper.OperDoc         // 手术医生
		Set:OperDoc'="" OperDoc= $p($g(^SSU("SSUSR",+OperDoc)),"^",2)
		Set OperTypeDesc=""
		If $IsObject(objInfOper.OperationType) {
			Set OperTypeDesc=objInfOper.OperationType.Description   // 手术类型
		}
		Set AnesDesc=""
		If $IsObject(objInfOper.Anesthesia) {
			Set AnesDesc=objInfOper.Anesthesia.Description   // 麻醉方式
		}
		Set CuteTypeDesc=""
		If $IsObject(objInfOper.CuteType) {
			Set CuteTypeDesc=objInfOper.CuteType.Description   // 切口类型
		}
		Set CuteHealingDesc=""
		If $IsObject(objInfOper.CuteHealing) {
			Set CuteHealingDesc=objInfOper.CuteHealing.Description   // 愈合情况
		}
		Set CuteInfFlag=""
		If $IsObject(objInfOper.CuteInfFlag) {
			Set CuteInfFlag=objInfOper.CuteInfFlag.Description   // 切口感染(是/否)
		}
		Set OperInfTypeDesc=""
		If $IsObject(objInfOper.OperInfType) {
			Set OperInfTypeDesc=objInfOper.OperInfType.Description   // 手术感染类型
		}
		Set ASAScoreDesc=""
		If $IsObject(objInfOper.ASAScore) {
			Set ASAScoreDesc=objInfOper.ASAScore.Description        // ASA(麻醉)评分
		}
		Set InHospInfFlag=""
		If $IsObject(objInfOper.InHospInfFlag) {
			Set InHospInfFlag=objInfOper.InHospInfFlag.Description   // 引起院内感染(是/否)
		}
		Set CuteNumberDesc=""
		If $IsObject(objInfOper.CuteNumber) {
			Set CuteNumberDesc=objInfOper.CuteNumber.Description     // 切口个数
		}
		Set EndoscopeFlag=""
		If $IsObject(objInfOper.EndoscopeFlag) {
			Set EndoscopeFlag=objInfOper.EndoscopeFlag.Description   // 使用窥镜(是/否)
		}
		Set ImplantFlag=""
		If $IsObject(objInfOper.ImplantFlag) {
			Set ImplantFlag=objInfOper.ImplantFlag.Description       // 植入物(是/否)
		}
		Set PreoperWBC = objInfOper.PreoperWBC   // 术前外周WBC计数
		Set BloodLoss  = objInfOper.BloodLoss    // 失血量
		Set BloodTrans = objInfOper.BloodTrans   // 输血量
		
		Set PreoperAntiFlag=""
		If $IsObject(objInfOper.PreoperAntiFlag) {
			Set PreoperAntiFlag=objInfOper.PreoperAntiFlag.Description   // 术前口服抗生素肠道准备(是/否)
		}
		Set BloodLossFlag=""
		If $IsObject(objInfOper.BloodLossFlag) {
			Set BloodLossFlag=objInfOper.BloodLossFlag.Description       // 失血(是/否)
		}
		Set BloodTransFlag=""
		If $IsObject(objInfOper.BloodTransFlag) {
			Set BloodTransFlag=objInfOper.BloodTransFlag.Description     // 输血(是/否)
		}
	    
		Set InfOperStr = aReportID_"||"_xOperID             // 手术表ID
		Set InfOperStr = InfOperStr_"^"_OperationDesc       // 手术名称
		Set InfOperStr = InfOperStr_"^"_OperStartDate       // 手术开始日期
		Set InfOperStr = InfOperStr_"^"_OperStartTime       // 手术开始时间
		Set InfOperStr = InfOperStr_"^"_OperEndDate         // 手术结束日期
		Set InfOperStr = InfOperStr_"^"_OperEndTime         // 手术结束时间
		Set InfOperStr = InfOperStr_"^"_OperDoc             // 手术医生
		Set InfOperStr = InfOperStr_"^"_OperTypeDesc        // 手术类型
		Set InfOperStr = InfOperStr_"^"_AnesDesc            // 麻醉方式
		Set InfOperStr = InfOperStr_"^"_CuteTypeDesc        // 切口类型
		Set InfOperStr = InfOperStr_"^"_CuteHealingDesc     // 愈合情况
		Set InfOperStr = InfOperStr_"^"_CuteInfFlag         // 切口感染(是/否)
		Set InfOperStr = InfOperStr_"^"_OperInfTypeDesc     // 手术感染类型
		Set InfOperStr = InfOperStr_"^"_ASAScoreDesc        // ASA(麻醉)评分
		Set InfOperStr = InfOperStr_"^"_InHospInfFlag       // 引起院内感染(是/否)
		Set InfOperStr = InfOperStr_"^"_CuteNumberDesc      // 切口个数
		Set InfOperStr = InfOperStr_"^"_EndoscopeFlag       // 使用窥镜(是/否)
		Set InfOperStr = InfOperStr_"^"_ImplantFlag         // 植入物(是/否)
		Set InfOperStr = InfOperStr_"^"_PreoperWBC          // 术前外周WBC计数
		Set InfOperStr = InfOperStr_"^"_BloodLoss           // 失血量
		Set InfOperStr = InfOperStr_"^"_BloodTrans          // 输血量
		Set InfOperStr = InfOperStr_"^"_PreoperAntiFlag     // 术前口服抗生素肠道准备
		Set InfOperStr = InfOperStr_"^"_BloodLossFlag       // 失血(是/否)
		Set InfOperStr = InfOperStr_"^"_BloodTransFlag      // 输血(是/否)
		
		Do InfRepOper.Insert(InfOperStr)
	}
	Do return.SetAt(InfRepOper,"InfRepOper")
	
	// 病原学检验 zhoubo
	Set InfRepLab=##Class(%Library.ListOfDataTypes).%New()
	Set xLabID=0
	For {
		Set xLabID=$o(^DHCMed.NINF("InfRep",aReportID,"Lab",xLabID))
		Quit:xLabID=""
		
		Set objInfLab=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(aReportID_"||"_xLabID)
		Continue:'$IsObject(objInfLab)
		
		Set ArcimDesc = objInfLab.ArcimDesc     // 检验医嘱名称
		Set SpecimenDesc=""
		If $IsObject(objInfLab.Specimen) {
			Set SpecimenDesc=objInfLab.Specimen.Description          // 标本
		}
	    Set AssayMethodDesc=""
		If $IsObject(objInfLab.AssayMethod) {
			Set AssayMethodDesc=objInfLab.AssayMethod.Description    // 检验方法
		}
		Set SubmissionDate=objInfLab.SubmissionDate
		Set PathogenTestDesc=""
		If $IsObject(objInfLab.PathogenTest) {
			Set PathogenTestDesc=objInfLab.PathogenTest.Description   // 检验方法
		}
		Set AssayMethodDesc=""
		If $IsObject(objInfLab.AssayMethod) {
			Set AssayMethodDesc=objInfLab.AssayMethod.Description     // 检验方法
		}
		// 检验结果(病原体)
		Set InfRepLabPy=""
		For indLabPy=1:1:objInfLab.TestResults.Count() {
			Set objLabPy=objInfLab.TestResults.GetAt(indLabPy)
			Continue:'$IsObject(objLabPy)
			Set objPathogeny=objLabPy.PathogenyID
			Set (PYWhonet,PYDesc)=""
			If ($IsObject(objPathogeny)){
				Set PYDesc   = objPathogeny.PYDesc
				Set PYWhonet = objPathogeny.PYWhonet
			}
			Set PathogenyDesc = objLabPy.PathogenyDesc   // 病原体
			Set InfLabPyStr   = PathogenyDesc            // 病原体
			Set InfLabPyStr   = InfLabPyStr_"#"_PYWhonet // whonet码
			Set InfLabPyStr   = InfLabPyStr_"#"_PYDesc   // 病原体名称
			
			Set DrugSenTest="" // 药敏实验
			For indDrug=1:1:objLabPy.DrugSenTest.Count() {
				Set objDrugSenTest=objLabPy.DrugSenTest.GetAt(indDrug)
				Continue:'$IsObject(objDrugSenTest)
				
				Set objAntibiotics = objDrugSenTest.AntibioticsID
				Set (ANTDesc,ANTCode)=""
				If ($IsObject(objAntibiotics)){
					Set ANTDesc  = objAntibiotics.ANTDesc
					Set ANTCode  = objAntibiotics.ANTCode
				}
				Set AntibioticsDesc = objDrugSenTest.AntibioticsDesc   // 抗生素
				Set SenTestRstDesc=""
				If $IsObject(objDrugSenTest.SenTestRst) {
					Set SenTestRstDesc=objDrugSenTest.SenTestRst.Description   // 药敏结果
				}
				
				Set InfLabPyDrugStr = AntibioticsDesc                      // 抗生素
				Set InfLabPyDrugStr = InfLabPyDrugStr_"!"_ANTCode          // 代码 
				Set InfLabPyDrugStr = InfLabPyDrugStr_"!"_ANTDesc          // 名称 
				Set InfLabPyDrugStr = InfLabPyDrugStr_"!"_SenTestRstDesc   // 药敏结果 
				Set DrugSenTest     = DrugSenTest_"&"_InfLabPyDrugStr
			}
			Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
			
			Set InfLabPyStr = InfLabPyStr_"#"_DrugSenTest   // 药敏实验
			Set InfRepLabPy = InfRepLabPy_","_InfLabPyStr
		}
		Set:InfRepLabPy'="" InfRepLabPy=$e(InfRepLabPy,2,$l(InfRepLabPy))
		
		Set InfLabStr = aReportID_"||"_xLabID              // 病原学ID
		Set InfLabStr = InfLabStr_"^"_ArcimDesc            // 检验医嘱名称
		Set InfLabStr = InfLabStr_"^"_SpecimenDesc         // 标本
		Set InfLabStr = InfLabStr_"^"_AssayMethodDesc      // 检验方法
		Set InfLabStr = InfLabStr_"^"_SubmissionDate       // 送检日期
		Set InfLabStr = InfLabStr_"^"_PathogenTestDesc     // 病原学检验
		Set InfLabStr = InfLabStr_"^"_InfRepLabPy          // 检验结果(病原体)
		
		Do InfRepLab.Insert(InfLabStr)
	}
	Do return.SetAt(InfRepLab,"InfRepLab")
	// 抗菌药物 zhoubo
	Set InfRepAnti=##Class(%Library.ListOfDataTypes).%New()
	Set xAntiID=0
	For {
		Set xAntiID=$o(^DHCMed.NINF("InfRep",aReportID,"Anti",xAntiID))
		Quit:xAntiID=""
		
		Set objInfAnti=##class(DHCMed.NINF.Rep.InfReportAnti).GetObjById(aReportID_"||"_xAntiID)
		Continue:'$IsObject(objInfAnti)
		
		Set ArcimDesc = objInfAnti.ArcimDesc   // 医嘱名称
		Set StartDate = objInfAnti.StartDate   // 开始日期
		Set StartTime = objInfAnti.StartTime   // 开始时间
		Set EndDate   = objInfAnti.EndDate     // 结束日期
		Set EndTime   = objInfAnti.EndTime     // 结束时间
		
		Set DoseQty   = objInfAnti.DoseQty     // 剂量
		Set DoseUnit  = objInfAnti.DoseUnit    // 剂量单位
		Set:DoseUnit'="" DoseUnit=$p($g(^CT("UOM",+DoseUnit)),"^",2)
		Set PhcFreq   = objInfAnti.PhcFreq     // 频次
		Set PhcFreq   = $p($g(^PHCFR(+PhcFreq)),"^",3)
		Set PreMedTime    = objInfAnti.PreMedTime      // 术前用药时间(分钟)
		Set PostMedDays   = objInfAnti.PostMedDays     // 术后用药天数(天)
		Set UseDesc=""
		If $IsObject(objInfAnti.MedUsePurpose) {
			Set UseDesc=objInfAnti.MedUsePurpose.Description        // 用途
		}
	    Set AdminRouteDesc=""
		If $IsObject(objInfAnti.AdminRoute) {
			Set AdminRouteDesc=objInfAnti.AdminRoute.Description    // 给药途径
		}
		Set MedPurposeDesc=""
		If $IsObject(objInfAnti.MedPurpose) {
			Set MedPurposeDesc=objInfAnti.MedPurpose.Description    // 目的
		}
		Set TreatmentDesc=""
		If $IsObject(objInfAnti.TreatmentMode) {
			Set TreatmentDesc=objInfAnti.TreatmentMode.Description   // 治疗用药方式
		}
		Set PreMedIndDesc=""
		If $IsObject(objInfAnti.PreMedIndicat) {
			Set PreMedIndDesc=objInfAnti.PreMedIndicat.Description   // 预防用药指征
		}
		Set EffectDesc=""
		If $IsObject(objInfAnti.PreMedEffect) {
			Set EffectDesc=objInfAnti.PreMedEffect.Description      // 预防用药效果
		}
		Set CombinedMedDesc=""
		If $IsObject(objInfAnti.CombinedMed) {
			Set CombinedMedDesc=objInfAnti.CombinedMed.Description   // 联合用药
		}
		
		Set InfAntiStr = aReportID_"||"_xAntiID         // 抗菌药物ID
		Set InfAntiStr = InfAntiStr_"^"_ArcimDesc       // 医嘱名称
		Set InfAntiStr = InfAntiStr_"^"_StartDate       // 开始日期
		Set InfAntiStr = InfAntiStr_"^"_StartTime       // 开始日期
		Set InfAntiStr = InfAntiStr_"^"_EndDate         // 结束日期
		Set InfAntiStr = InfAntiStr_"^"_EndTime         // 结束日期
		Set InfAntiStr = InfAntiStr_"^"_DoseQty         // 剂量
		Set InfAntiStr = InfAntiStr_"^"_DoseUnit        // 剂量单位
		Set InfAntiStr = InfAntiStr_"^"_PhcFreq         // 频次
		Set InfAntiStr = InfAntiStr_"^"_PreMedTime      // 术前用药时间(分钟)
		Set InfAntiStr = InfAntiStr_"^"_PostMedDays     // 术后用药天数(天)
		Set InfAntiStr = InfAntiStr_"^"_UseDesc         // 用途
		Set InfAntiStr = InfAntiStr_"^"_AdminRouteDesc  // 给药途径
		Set InfAntiStr = InfAntiStr_"^"_MedPurposeDesc  // 目的
		Set InfAntiStr = InfAntiStr_"^"_TreatmentDesc   // 治疗用药方式
		Set InfAntiStr = InfAntiStr_"^"_PreMedIndDesc   // 预防用药指征
		Set InfAntiStr = InfAntiStr_"^"_EffectDesc      // 预防用药效果
		Set InfAntiStr = InfAntiStr_"^"_CombinedMedDesc // 联合用药
		
		Do InfRepAnti.Insert(InfAntiStr)
	}
	Do return.SetAt(InfRepAnti,"InfRepAnti") 
	
    //日志
	Set InfRepLog=##Class(%Library.ListOfDataTypes).%New()
	Set xLogID=""
	For {
		Set xLogID=$o(^DHCMed.NINF("InfRep",aReportID,"Log",xLogID),-1)
		Quit:xLogID=""
		
		Set objLog=##class(DHCMed.NINF.Rep.InfReportLog).GetObjById(aReportID_"||"_xLogID)
		Continue:'$IsObject(objLog)
		Continue:'$IsObject(objLog.LogStatus)
		Set LogLoc    = objLog.LogLoc     // 更新科室
		Set LogUser   = objLog.LogUser    // 更新人员
		Set LogDate   = objLog.LogDate    // 更新日期
		Set LogTime   = objLog.LogTime    // 更新时间
		Set LogStatus = objLog.LogStatus.Description  // 更新状态
		Set LogResume = objLog.LogResume
		
		Set InfLogStr=aReportID_"||"_xLogID
		Set InfLogStr=InfLogStr_"^"_LogLoc      //操作科室
		Set InfLogStr=InfLogStr_"^"_LogUser     //操作人
		Set InfLogStr=InfLogStr_"^"_LogDate     //更新日期
		Set InfLogStr=InfLogStr_"^"_LogTime     //更新时间
		Set InfLogStr=InfLogStr_"^"_LogStatus   //操作状态
		Set InfLogStr=InfLogStr_"^"_LogResume
		
		Do InfRepLog.Insert(InfLogStr)
	}
	Do return.SetAt(InfRepLog,"InfRepLog")               // 日志信息
	
	Quit return
}

}
