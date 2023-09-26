/// 名称: DHCHAI.IRS.HAITotalSrv
/// 描述: 医院感染管理与控制指标服务(优先13项指标)
/// 编写者：ShenC
/// 编写日期: 2022-11-09
Class DHCHAI.IRS.HAITotalSrv Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2023-03-30
/// Description:  根据日期同步'医院感染管理与控制指标'数据(暂不启用)
/// Input：       aHospIDs:院区
/// 			  aDateFrom:开始日期
/// 			  aDateTo:结束日期
/// 			  -,-,-,-,-,-
/// Return：      0/1
/// w ##class(DHCHAI.IO.FromBPSrv).SyncHAITotal("2011-11-26","2022-09-08")
ClassMethod SyncHAITotal(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	For xDate=aDateFrom:1:aDateTo{
		//取院区组
		//取系统参数判断同步日期
		
		
	}
	
	
	
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2022-11-03
/// Description:  输出'院感质控指标集汇总'数据
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HAITotalSrv","QryHAITotal","1","2020-05-01","2020-05-31","","","","","","W")
Query QryHAITotal(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String = "", aObsType As %String = "", aSubDateType As %String = "", aSubHourType As %String = "", aUseSubDateType As %String = "", aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "Name:%String,Target:%String,Value:%String,Formula:%String") [ SqlProc ]
{
}

ClassMethod QryHAITotalExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String = "", aObsType As %String = "", aSubDateType As %String = "", aSubHourType As %String = "", aUseSubDateType As %String = "", aLocType As %String = "", aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK

 	Set:aLocType'="W" aLocType="E"
 	
	//医院医院感染管理与控制指标(写死,不考虑配置)
	//指标1~2--住院患者医院感染（例次）发病率统计
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S010Inf","QryS010Inf",aHospIDs,aDateFrom,aDateTo,aLocType)
	Set (InfPatRatio,InfPatCnt,PatAdmCnt)=""
	If (rs.GetAt(1)'=""){
		//1.医院感染发病率
		Set InfPatRatio=rs.GetAt(1).GetAt("InfPatRatio")
  		//1.1.同期新发生医院感染人数
  		Set InfPatCnt=rs.GetAt(1).GetAt("InfPatCnt")
  		//1.2.住院患者人数G U77
  		Set PatAdmCnt=rs.GetAt(1).GetAt("PatAdmCnt")
  		
  		//2.医院感染例次发病率
		Set InfCaseRatio=rs.GetAt(1).GetAt("InfCaseRatio")
  		//2.1.同期新发生医院感染例次数
  		Set InfCaseCnt=rs.GetAt(1).GetAt("InfCaseCnt")
  		//2.2.住院患者人数
  		Set PatAdmCnt=rs.GetAt(1).GetAt("PatAdmCnt")
	}
  	Set Data=$lb("医院感染发病率","≤10%",InfPatRatio,"医院感染发病率 = 新发生医院感染的患者人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期新发生医院感染人数","-",InfPatCnt,"医院感染发病率 = 新发生医院感染的患者人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  住院患者人数","-",PatAdmCnt,"医院感染发病率 = 新发生医院感染的患者人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("医院感染例次发病率","≤10%",InfCaseRatio,"医院感染例次发病率 = 新发生医院感染的例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期新发生医院感染例次数","-",InfCaseCnt,"医院感染例次发病率 = 新发生医院感染的例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  住院患者人数","-",PatAdmCnt,"医院感染例次发病率 = 新发生医院感染的例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	//指标3~4--医院感染（例次）现患率统计表
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S030InfPre","QryInfPre",aHospIDs,aDateFrom,aDateTo,aLocType)
	If (rs.GetAt(1)'=""){
		//3.医院感染现患率
		Set HAIRatio=rs.GetAt(1).GetAt("HAIRatio")
  		//3.1.确定时段或时点住院患者中医院感染人数
  		Set HAICount=rs.GetAt(1).GetAt("HAICount")
  		//3.2.住院患者人数
  		Set InCount=rs.GetAt(1).GetAt("InCount")
  	
  		//4.医院感染例次现患率
		Set INFRatio=rs.GetAt(1).GetAt("INFRatio")
  		//4.1.确定时段或时点住院患者中医院感染例次数
  		Set INFCount=rs.GetAt(1).GetAt("INFCount")
  		//4.2.住院患者人数
  		Set InCount=rs.GetAt(1).GetAt("InCount")
	}
	Set Data=$lb("医院感染现患率","-",HAIRatio,"医院感染现患率=确定时段或时点住院患者中医院感染人数/同期住院患者人数×100% ")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  确定时段或时点住院患者中医院感染人数","-",HAICount,"医院感染现患率=确定时段或时点住院患者中医院感染人数/同期住院患者人数×100% ")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  住院患者人数","-",InCount,"医院感染现患率=确定时段或时点住院患者中医院感染人数/同期住院患者人数×100% ")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("医院感染例次现患率","-",INFRatio,"医院感染例次现患率 = 确定时段或时点住院患者中医院感染例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  确定时段或时点住院患者中医院感染例次数","-",INFCount,"医院感染例次现患率 = 确定时段或时点住院患者中医院感染例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  住院患者人数","-",InCount,"医院感染例次现患率 = 确定时段或时点住院患者中医院感染例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	//指标5~7--感染漏报统计
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S370InfMisRep","QryInfMisRep",aHospIDs,aDateFrom,aDateTo,aLocType)
	If (rs.GetAt(1)'=""){
		//5.医院感染病例迟报率
		Set LateRepRatio=rs.GetAt(1).GetAt("LateRepRatio")
  		//5.1.迟报医院感染人数
  		Set InfLatePatCount=rs.GetAt(1).GetAt("InfLatePatCount")
  		//5.2.同期应报告医院感染人数
		Set InfPatCount=rs.GetAt(1).GetAt("InfPatCount")
		
		//6.医院感染病例漏报率
  		Set MissRepRatio=rs.GetAt(1).GetAt("MissRepRatio")
  		//6.1.应报告而未报告的医院感人数
  		Set InfMissPatCount=rs.GetAt(1).GetAt("InfMissPatCount")
  		//6.2.同期应报告医院感染人数
		Set InfPatCount=rs.GetAt(1).GetAt("InfPatCount")
		
		//7.医院感染例次漏报率
  		Set MissCaseRepRatio=rs.GetAt(1).GetAt("MissCaseRepRatio")
  		//7.1.应报告而未报告的医院感染例次数
  		Set InfMissCaseCount=rs.GetAt(1).GetAt("InfMissCaseCount")
  		//7.2.同期应报告医院感染例次数
		Set InfCaseCount=rs.GetAt(1).GetAt("InfCaseCount")
	}
	Set Data=$lb("医院感染病例迟报率","-",LateRepRatio,"医院感染病例迟报率=迟报医院感染人数/同期应报告医院感染人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  迟报医院感染人数","-",InfLatePatCount,"医院感染病例迟报率=迟报医院感染人数/同期应报告医院感染人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期应报告医院感染人数","-",InfPatCount,"医院感染病例迟报率=迟报医院感染人数/同期应报告医院感染人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("医院感染病例漏报率","-",MissRepRatio,"医院感染病例漏报率=应报告而未报告的医院感人数/同期应报告医院感染人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  应报告而未报告的医院感人数","-",InfMissPatCount,"医院感染病例漏报率=应报告而未报告的医院感人数/同期应报告医院感染人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期应报告医院感染人数","-",InfPatCount,"医院感染病例漏报率=应报告而未报告的医院感人数/同期应报告医院感染人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("医院感染例次漏报率","-",MissCaseRepRatio,"医院感染例次漏报率 = 应报告而未报告的医院感染例次数/同期应报告医院感染例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  应报告而未报告的医院感染例次数","-",InfMissCaseCount,"医院感染例次漏报率 = 应报告而未报告的医院感染例次数/同期应报告医院感染例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期应报告医院感染例次数","-",InfCaseCount,"医院感染例次漏报率 = 应报告而未报告的医院感染例次数/同期应报告医院感染例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
 	//指标8~9--多耐相关统计
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.ThirteenInd.STar004","QryMRBInf",aHospIDs,aDateFrom,aDateTo,aLocType)
	If (rs.GetAt(1)'=""){
		//8.1.检出导致医院感染的特定多耐菌人数
		Set MPat=rs.GetAt(1).GetAt("MPat")
		//8.2.同期住院患者人数
		Set PatAdmCnt=rs.GetAt(1).GetAt("PatAdmCnt")
		//8.特定多耐菌医院感染发病率
		Set MPatRatio="0.00%"
		Set:PatAdmCnt>0 MPatRatio=$fn((MPat/PatAdmCnt)*100,"",2)_"%"
  	
		//9.1.检出导致医院感染的特定多耐菌例次数
  		Set MPatCase=rs.GetAt(1).GetAt("MPatCase")
  		//9.2.同期住院患者人数
  		Set PatAdmCnt=rs.GetAt(1).GetAt("PatAdmCnt")
		//9.特定多耐菌医院感染例次发病率
		Set MCaseRatio="0.00%"
		Set:PatAdmCnt>0 MCaseRatio=$fn((MPatCase/PatAdmCnt)*100,"",2)_"%"
	}
	Set Data=$lb("特定多耐菌医院感染发病率","",MPatRatio,"特定多耐菌医院感染发病率 = 检出导致医院感染的特定多耐菌人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  检出导致医院感染的特定多耐菌人数","-",MPat,"特定多耐菌医院感染发病率 = 检出导致医院感染的特定多耐菌人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者人数","-",PatAdmCnt,"特定多耐菌医院感染发病率 = 检出导致医院感染的特定多耐菌人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("特定多耐菌医院感染例次发病率","",MCaseRatio,"特定多耐菌医院感染例次发病率 = 检出导致医院感染的特定多耐菌例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  检出导致医院感染的特定多耐菌例次数","-",MPatCase,"特定多耐菌医院感染例次发病率 = 检出导致医院感染的特定多耐菌例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者人数","-",PatAdmCnt,"特定多耐菌医院感染例次发病率 = 检出导致医院感染的特定多耐菌例次数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	//指标10--多重耐药菌检出率统计
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.ThirteenInd.STar005","QryMRBPos",aHospIDs,aDateFrom,aDateTo,aLocType)
	If (rs.GetAt(1)'=""){
		//10.1.检出特定多耐菌的例次数
  		Set MMRBCase=rs.GetAt(1).GetAt("MMRBCase")
  		//10.2.同期检出特定细菌的例次数
  		Set MPatCase=rs.GetAt(1).GetAt("MBacCase")
		//10.特定多耐菌检出率
		Set MPatRatio="0.00%"
		Set:MPatCase>0 MPatRatio=$fn((MMRBCase/MPatCase)*100,"",2)_"%"
	}
	Set Data=$lb("特定多耐菌检出率","",MPatRatio,"特定多耐菌检出率 = 检出特定多耐菌的例次数/同期检出特定细菌的例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  检出特定多耐菌的例次数","-",MMRBCase,"特定多耐菌检出率 = 检出特定多耐菌的例次数/同期检出特定细菌的例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期检出特定细菌的例次数","-",MPatCase,"特定多耐菌检出率 = 检出特定多耐菌的例次数/同期检出特定细菌的例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	//11~12--医务人员手卫生依从率统计表统计表
  	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S380HandHyCom","QryHandHyRegSta",aHospIDs,aDateFrom,aDateTo,aMethod,aObsType)
  	If (rs.GetAt(1)'=""){
  		//11.2.手消”+“洗手”+“洗手+手消”+无
  		Set HandCount=rs.GetAt(1).GetAt("HandCount")
		Set SoapCount=rs.GetAt(1).GetAt("SoapCount")
		Set SHandCount=rs.GetAt(1).GetAt("SHandCount")
		Set NotCount=rs.GetAt(1).GetAt("NotCount")
		Set Count=HandCount+SoapCount+SHandCount+NotCount
  		//11.1.手消”+“洗手”+“洗手+手消”
  		Set ComCount=HandCount+SoapCount+SHandCount
  		//11.依从率
  		Set CompRatio=rs.GetAt(1).GetAt("CompRatio")
	
		//12.正确率
		Set CorrectRatio=rs.GetAt(1).GetAt("CorrectRatio")
  		//12.1.正确的“手消”+“洗手”+“洗手+手消”
  		Set CorrectCount=rs.GetAt(1).GetAt("CorrectCount")
  		//12.2.手消”+“洗手”+“洗手+手消”
		Set ComCount=HandCount+SoapCount+SHandCount
  	}
  	Set Data=$lb("依从率","≥60%",CompRatio,"依从率=(“手消”+“洗手”+“洗手+手消”)/(“手消”+“洗手”+“洗手+手消”+无)*100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  “手消”+“洗手”+“洗手+手消”","-",ComCount,"依从率=(“手消”+“洗手”+“洗手+手消”)/(“手消”+“洗手”+“洗手+手消”+无)*100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  “手消”+“洗手”+“洗手+手消”+无","-",Count,"依从率=(“手消”+“洗手”+“洗手+手消”)/(“手消”+“洗手”+“洗手+手消”+无)*100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("正确率","≥75%",CorrectRatio,"正确率=(正确的“手消”+“洗手”+“洗手+手消”)/(“手消”+“洗手”+“洗手+手消”) *100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  正确的“手消”+“洗手”+“洗手+手消”","-",CorrectCount,"正确率=(正确的“手消”+“洗手”+“洗手+手消”)/(“手消”+“洗手”+“洗手+手消”) *100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  “手消”+“洗手”+“洗手+手消”","-",ComCount,"正确率=(正确的“手消”+“洗手”+“洗手+手消”)/(“手消”+“洗手”+“洗手+手消”) *100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	//13--住院患者抗菌药物使用率统计表
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S130AntUse","QryAntUse",aHospIDs,aDateFrom,aDateTo,aLocType)
  	If (rs.GetAt(1)'=""){
  		//13.抗菌药物使用率
  		Set UseAntiRatio=rs.GetAt(1).GetAt("UseAntiRatio")
  		//13.1.全身应用抗菌药物的人数
  		Set UseAntiCnt=rs.GetAt(1).GetAt("UseAntiCnt")
  		//13.2.同期住院患者人数
		Set PatAdmCnt=rs.GetAt(1).GetAt("PatAdmCnt")
  	}
  	Set Data=$lb("抗菌药物使用率","≤60%",UseAntiRatio,"抗菌药物使用率 = 全身应用抗菌药物的人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  全身应用抗菌药物的人数","-",UseAntiCnt,"抗菌药物使用率 = 全身应用抗菌药物的人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者人数","-",PatAdmCnt,"抗菌药物使用率 = 全身应用抗菌药物的人数/同期住院患者人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	//14~16--住院患者抗菌药物治疗前病原学送检率统计表
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S170AntTheSub","QryAntTheSub",aHospIDs,aDateFrom,aDateTo,aSubDateType,aSubHourType,aLocType,"2",aUseSubDateType)
  	If (rs.GetAt(1)'=""){
  		//14.抗菌药物治疗前病原学送检率
  		Set BfCureSubRatio=rs.GetAt(1).GetAt("BfCureSubRatio")
  		//14.1.治疗性应用抗菌药物前病原学送检人数
  		Set BfCureSubmissCnt=rs.GetAt(1).GetAt("BfCureSubmissCnt")
  		//14.2.同期治疗性应用抗菌药物的人数
  		Set CureUseAntiCnt=rs.GetAt(1).GetAt("CureUseAntiCnt")
  		
  		//15.住院患者限制使用级抗菌药物治疗前病原学送检率
  		Set UseKSS2SubRatio=rs.GetAt(1).GetAt("UseKSS2SubRatio")
  		//15.1.住院患者中治疗性应用限制使用级抗菌药物前病原学送检人数
  		Set UseKSS2AndSub=rs.GetAt(1).GetAt("UseKSS2AndSub")
  		//15.2.同期住院患者中治疗性应用限制使用级抗菌药物的人数
  		Set CureUseKSS2=rs.GetAt(1).GetAt("CureUseKSS2")
  		
  		//16.住院患者特殊使用级抗菌药物治疗前病原学送检率
  		Set UseKSS3SubRatio=rs.GetAt(1).GetAt("UseKSS3SubRatio")
  		//16.1.住院患者中治疗性应用特殊使用级抗菌药物前病原学送检人数
  		Set UseKSS3AndSub=rs.GetAt(1).GetAt("UseKSS3AndSub")
  		//16.2.同期住院患者中治疗性应用特殊使用级抗菌药物的人数
  		Set CureUseKSS3=rs.GetAt(1).GetAt("CureUseKSS3")
  	}
  	Set Data=$lb("抗菌药物治疗前病原学送检率","≥30%",BfCureSubRatio,"抗菌药物治疗前病原学送检率 = 治疗性应用抗菌药物前病原学送检人数/同期治疗性应用抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  治疗性应用抗菌药物前病原学送检人数","-",BfCureSubmissCnt,"抗菌药物治疗前病原学送检率 = 治疗性应用抗菌药物前病原学送检人数/同期治疗性应用抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期治疗性应用抗菌药物的人数","-",CureUseAntiCnt,"抗菌药物治疗前病原学送检率 = 治疗性应用抗菌药物前病原学送检人数/同期治疗性应用抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data=$lb("住院患者限制使用级抗菌药物治疗前病原学送检率","≥50%",UseKSS2SubRatio,"住院患者限制使用级抗菌药物治疗前病原学送检率 = 住院患者中治疗性应用限制使用级抗菌药物前病原学送检人数/同期住院患者中治疗性应用限制使用级抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  住院患者中治疗性应用限制使用级抗菌药物前病原学送检人数","-",UseKSS2AndSub,"住院患者限制使用级抗菌药物治疗前病原学送检率 = 住院患者中治疗性应用限制使用级抗菌药物前病原学送检人数/同期住院患者中治疗性应用限制使用级抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者中治疗性应用限制使用级抗菌药物的人数","-",CureUseKSS2,"住院患者限制使用级抗菌药物治疗前病原学送检率 = 住院患者中治疗性应用限制使用级抗菌药物前病原学送检人数/同期住院患者中治疗性应用限制使用级抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data=$lb("住院患者特殊使用级抗菌药物治疗前病原学送检率","≥80%",UseKSS3SubRatio,"住院患者特殊使用级抗菌药物治疗前病原学送检率 = 住院患者中治疗性应用特殊使用级抗菌药物前病原学送检人数/同期住院患者中治疗性应用特殊使用级抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  住院患者中治疗性应用特殊使用级抗菌药物前病原学送检人数","-",UseKSS3AndSub,"住院患者特殊使用级抗菌药物治疗前病原学送检率 = 住院患者中治疗性应用特殊使用级抗菌药物前病原学送检人数/同期住院患者中治疗性应用特殊使用级抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者中治疗性应用特殊使用级抗菌药物的人数","-",CureUseKSS3,"住院患者特殊使用级抗菌药物治疗前病原学送检率 = 住院患者中治疗性应用特殊使用级抗菌药物前病原学送检人数/同期住院患者中治疗性应用特殊使用级抗菌药物的人数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	//17--Ⅰ类切口手术部位感染率统计表
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S240AIncInf","QryAIncInf",aHospIDs,aDateFrom,aDateTo,aLocType)
	If (rs.GetAt(1)'=""){
		//17.Ⅰ类切口手术部位感染率
		Set SuperIncRatio=rs.GetAt(1).GetAt("SuperIncRatio")
  		//17.1.Ⅰ类切口手术中发生手术部位感染例次数
  		Set OperCaseInfCount=rs.GetAt(1).GetAt("OperCaseInfCount")
  		//17.2.同期Ⅰ类切口手术例次数
		Set OperCaseCount=rs.GetAt(1).GetAt("OperCaseCount")
	}
	Set Data=$lb("Ⅰ类切口手术部位感染率","≤1.5%",SuperIncRatio,"Ⅰ类切口手术部位感染率 = Ⅰ类切口手术中发生手术部位感染例次数/同期Ⅰ类切口手术例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  Ⅰ类切口手术中发生手术部位感染例次数","-",OperCaseInfCount,"Ⅰ类切口手术部位感染率 = Ⅰ类切口手术中发生手术部位感染例次数/同期Ⅰ类切口手术例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期Ⅰ类切口手术例次数","-",OperCaseCount,"Ⅰ类切口手术部位感染率 = Ⅰ类切口手术中发生手术部位感染例次数/同期Ⅰ类切口手术例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	//18-Ⅰ类切口手术抗菌药物预防使用率统计表
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S260AIncAntUse","QryAIncAntUse",aHospIDs,aDateFrom,aDateTo,aLocType)
	If (rs.GetAt(1)'=""){
		//18.Ⅰ类切口手术抗菌药物预防使用率
		Set SuperAntiRatio=rs.GetAt(1).GetAt("SuperAntiRatio")
  		//18.1.Ⅰ类切口手术中预防性应用抗菌药物的例次数
  		Set OperPreAntiCount=rs.GetAt(1).GetAt("OperPreAntiCount")
  		//18.2.同期Ⅰ类切口手术例次数
		Set OperCaseCount=rs.GetAt(1).GetAt("OperCaseCount")
	}
	Set Data=$lb("Ⅰ类切口手术抗菌药物预防使用率","≤1.5%",SuperAntiRatio,"Ⅰ类切口手术抗菌药物预防使用率 = Ⅰ类切口手术中预防性应用抗菌药物的例次数/同期Ⅰ类切口手术例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  Ⅰ类切口手术中预防性应用抗菌药物的例次数","-",OperPreAntiCount,"Ⅰ类切口手术抗菌药物预防使用率 = Ⅰ类切口手术中预防性应用抗菌药物的例次数/同期Ⅰ类切口手术例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期Ⅰ类切口手术例次数","-",OperCaseCount,"Ⅰ类切口手术抗菌药物预防使用率 = Ⅰ类切口手术中预防性应用抗菌药物的例次数/同期Ⅰ类切口手术例次数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	//19~24-三管汇总统计表
	Set rs=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.STATV2.S260AIncAntUse","QryAIncAntUse",aHospIDs,aDateFrom,aDateTo,aLocType)
	If (rs.GetAt(1)'=""){
		//19.中央血管导管使用率
		Set PICCRatio=rs.GetAt(1).GetAt("PICCRatio")
  		//19.1.中央血管导管使用天数
  		Set PICCDays=rs.GetAt(1).GetAt("PICCDays")
  		//19.2.同期住院患者住院天数
  		Set InDays=rs.GetAt(1).GetAt("InDays")
		//20.CLABSI发病率
		Set PICCINFRatio=rs.GetAt(1).GetAt("PICCINFRatio")
  		//20.1.新发生CLABSI例次数
  		Set PICCINFCount=rs.GetAt(1).GetAt("PICCINFCount")
  		//20.2.同期中央血管导管使用天数
  		Set PICCDays=rs.GetAt(1).GetAt("PICCDays")
		//21.呼吸机使用率
		Set VAPRatio=rs.GetAt(1).GetAt("VAPRatio")
  		//21.1呼吸机使用天数
  		Set VAPDays=rs.GetAt(1).GetAt("VAPDays")
  		//21.2同期住院患者住院天数
  		Set InDays=rs.GetAt(1).GetAt("InDays")
		//22.VAP发病率
		Set VAPINFRatio=rs.GetAt(1).GetAt("VAPINFRatio")
  		//22.1.新发生VAP例次数
  		Set VAPINFCount=rs.GetAt(1).GetAt("VAPINFCount")
  		//22.2.同期呼吸机使用天数
  		Set VAPDays=rs.GetAt(1).GetAt("VAPDays")
		//23.导尿管使用率
		Set UCRatio=rs.GetAt(1).GetAt("UCRatio")
  		//23.1.导尿管使用天数
  		Set UCDays=rs.GetAt(1).GetAt("UCDays")
  		//23.2.同期住院患者住院天数
  		Set InDays=rs.GetAt(1).GetAt("InDays")
		//24.CAUTI发病率
		Set UCINFRatio=rs.GetAt(1).GetAt("UCINFRatio")
  		//24.1.新发生CAUTI例次数
  		Set UCINFCount=rs.GetAt(1).GetAt("UCINFCount")
  		//24.2.同期导尿管使用天数
  		Set UCDays=rs.GetAt(1).GetAt("UCDays")
	}
	Set Data=$lb("中央血管导管使用率","",PICCRatio,"中央血管导管使用率 = 中央血管导管使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  中央血管导管使用天数","-",PICCDays,"中央血管导管使用率 = 中央血管导管使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者住院天数","-",InDays,"中央血管导管使用率 = 中央血管导管使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("CLABSI发病率","",PICCINFRatio,"CLABSI发病率 = 新发生CLABSI例次数/同期中央血管导管使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  新发生CLABSI例次数","-",PICCINFCount,"CLABSI发病率 = 新发生CLABSI例次数/同期中央血管导管使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期中央血管导管使用天数","-",PICCDays,"CLABSI发病率 = 新发生CLABSI例次数/同期中央血管导管使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("呼吸机使用率","",VAPRatio,"呼吸机使用率 = 呼吸机使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  呼吸机使用天数","-",VAPDays,"呼吸机使用率 = 呼吸机使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者住院天数","-",InDays,"呼吸机使用率 = 呼吸机使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("VAP发病率","",VAPINFRatio,"VAP发病率 = 新发生VAP例次数/同期呼吸机使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  新发生VAP例次数","-",VAPINFCount,"VAP发病率 = 新发生VAP例次数/同期呼吸机使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期呼吸机使用天数","-",VAPDays,"VAP发病率 = 新发生VAP例次数/同期呼吸机使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("导尿管使用率","",UCRatio,"导尿管使用率 = 导尿管使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  导尿管使用天数","-",UCDays,"导尿管使用率 = 导尿管使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期住院患者住院天数","-",InDays,"导尿管使用率 = 导尿管使用天数/同期住院患者住院天数×100%")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("CAUTI发病率","",UCINFRatio,"CAUTI发病率 = 新发生CAUTI例次数/同期导尿管使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
  	Set Data=$lb("  新发生CAUTI例次数","-",UCINFCount,"CAUTI发病率 = 新发生CAUTI例次数/同期导尿管使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Set Data=$lb("  同期导尿管使用天数","-",UCDays,"CAUTI发病率 = 新发生CAUTI例次数/同期导尿管使用天数×1000‰")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryHAITotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHAITotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHAITotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHAITotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
