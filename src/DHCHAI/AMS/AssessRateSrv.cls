/// 名称: DHCHAI.AMS.AssessRateSrv
/// 描述: 疑似病例筛查筛查率、准确率、漏筛率相关服务
/// 编写者：pylian
/// 编写日期: 2019-03-26
Class DHCHAI.AMS.AssessRateSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-03-26
/// Description:  查询评估结果
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.AM.AssessResult
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.AMS.AssessRateSrv","QryAssessRate","3")
Query QryAssessRate(aModelDr As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "PatAdmSum:%String,ReportSum:%String,ScreenSum:%String,MissedSum:%String,DiagNoneSum:%String,DiagCancelSum:%String,DiagnosisSum:%String,ScreenRate:%String,InfRate:%String,DiagnosisRate:%String,RepUnScreenCnt:%String,UnInfScreenCnt:%String,InfScreenCnt:%String,ScreenUnInfCnt:%String,ACCRatio:%String,PPVRatio:%String,NPVRatio:%String,TPRRatio:%String,TNRRatio:%String,FNRRatio:%String,FPRRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAssessRateExecute(ByRef qHandle As %Binary, aModelDr As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aModelDr="" $$$OK
	Set:aDateFrom'="" aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom>aDateTo) $$$OK

	Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(aModelDr)
	Quit:'$IsObject(objModel) $$$OK
	Set ModelID   = objModel.%Id()
	Set AdmStatus = objModel.AMAdmStatus
	Set SttDate   = objModel.AMSttDate
	Set EndDate   = objModel.AMEndDate
	Set:(aDateFrom<SttDate)||(aDateFrom="") aDateFrom=SttDate
	Set:(aDateTo>EndDate)||(aDateTo="") aDateTo=EndDate
	
	Kill ^TMP($zn,$j,"QryAssessRate")
	
	If (AdmStatus'="I") {
	   	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
		Set Count=arrEpisodeDr.Count()
		For indEpis=1:1:Count {
			Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
			Continue:xEpisodeDr=""
			Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
			Continue:(PAAdmData="")
			Set AdmType = $lg(PAAdmData,18)
			Continue:(AdmType'["I")&&(AdmType'["EP")
			Set VisitStatus = $lg(PAAdmData,19)
			Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
	        Set AdmDate   =$lg(PAAdmData,20)
	    	Set DischDate =$lg(PAAdmData,26)
			If AdmStatus="D" {	//出院
				Continue:VisitStatus'="D"
				Continue:DischDate=""
				Continue:(DischDate<SttDate)||(DischDate>EndDate)
			} Else {	//在院 当前在院改为某段时间在院		
				Continue:AdmDate=""
				Continue:(AdmDate>EndDate)
				Continue:(DischDate'="")&&(DischDate<SttDate)
			}
				
			Set DateFrom =SttDate
		    Set DateTo =EndDate
		    If (AdmStatus="D") {
			    Set DateFrom =AdmDate
		   		Set DateTo =DischDate
		    }
			
			Continue:$d(^TMP($zn,$j,"QryAssessRate","PatAdm",xEpisodeDr))
		    Set num=$i(^TMP($zn,$j,"QryAssessRate","PatAdm"))   //在院、出院人数
			Set ^TMP($zn,$j,"QryAssessRate","PatAdm",xEpisodeDr) = ""
			
			//感染报告
			Set IsReport=##class(DHCHAI.AMC.CSAssessTask).CheckIsReport(xEpisodeDr,DateFrom,DateTo)
			
			//评估结果
			Set ARStatus="",SuMatrix=""
			Set xARID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr,0))
		    If (xARID'="") {    //疑似、感染病例
			    Set ResultData=$g(^DHCHAI.AM.AssessResultD(xARID))
			    Continue:ResultData=""    
			    Set IsActive  =$lg(ResultData,4)
			    Continue:IsActive'=1
			    Set ARStatus  =$lg(ResultData,8)
			    Set SuMatrix  =$lg(ResultData,14)
		    }
			
			Set:IsReport=1 num=$i(^TMP($zn,$j,"QryAssessRate","Report"))        //感染人数
			Set:SuMatrix'="" num=$i(^TMP($zn,$j,"QryAssessRate",SuMatrix))      //感染疑似TP 感染非疑似FN 疑似非感染FP 		
			Set:(ARStatus'="")&(ARStatus<2) num=$i(^TMP($zn,$j,"QryAssessRate","Screen"))	    //疑似人数(筛查评估中：未处置+确诊+排除)			
			Set:ARStatus=-1 num=$i(^TMP($zn,$j,"QryAssessRate","DiagNone"))     //未处置人数
			Set:ARStatus=0 num=$i(^TMP($zn,$j,"QryAssessRate","DiagCancel"))    //排除人数
			Set:ARStatus=1 num=$i(^TMP($zn,$j,"QryAssessRate","Diagnosis"))     //确诊人数
			Set:SuMatrix="" num=$i(^TMP($zn,$j,"QryAssessRate","TN"))
		}
	} Else {
		Set xEpisodeDr=""
		For {
			Set xEpisodeDr=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr))
			Quit:xEpisodeDr=""
			
			Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
			Continue:(PAAdmData="")
			Set AdmType = $lg(PAAdmData,18)
			Continue:(AdmType'["I")&&(AdmType'["EP")
			Set VisitStatus = $lg(PAAdmData,19)
			Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
	        Set AdmDate   =$lg(PAAdmData,20)
	    	Set DischDate =$lg(PAAdmData,26)
	    	
			//评估结果
			Set ARStatus="",SuMatrix=""
			Set xARID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr,0))
		    If (xARID'="") {    //疑似、感染病例
			    Set ResultData=$g(^DHCHAI.AM.AssessResultD(xARID))
			    Continue:ResultData=""    
			    Set IsActive  =$lg(ResultData,4)
			    Continue:IsActive'=1
			    Set ARStatus  =$lg(ResultData,8)
			    Set SuMatrix  =$lg(ResultData,14)
		    }
			Set num=$i(^TMP($zn,$j,"QryAssessRate","PatAdm"))   //总人数
			Set:xARID'="" num=$i(^TMP($zn,$j,"QryAssessRate","Report"))        //感染人数
			Set:SuMatrix'="" num=$i(^TMP($zn,$j,"QryAssessRate",SuMatrix))      //感染疑似TP 感染非疑似FN 疑似非感染FP 		
			Set:(ARStatus'="")&(ARStatus<2) num=$i(^TMP($zn,$j,"QryAssessRate","Screen"))	    //疑似人数(筛查评估中：未处置+确诊+排除)			
			Set:ARStatus=-1 num=$i(^TMP($zn,$j,"QryAssessRate","DiagNone"))     //未处置人数
			Set:ARStatus=0 num=$i(^TMP($zn,$j,"QryAssessRate","DiagCancel"))    //排除人数
			Set:ARStatus=1 num=$i(^TMP($zn,$j,"QryAssessRate","Diagnosis"))     //确诊人数
		}
	}
	Set PatAdmSum=+$g(^TMP($zn,$j,"QryAssessRate","PatAdm"))	       //在院、出院人数
	Set ReportSum=+$g(^TMP($zn,$j,"QryAssessRate","Report"))           //感染人数
	Set ScreenSum=+$g(^TMP($zn,$j,"QryAssessRate","Screen"))	       //疑似人数(筛查评估中：未处置+确诊+排除)
	Set DiagNoneSum=+$g(^TMP($zn,$j,"QryAssessRate","DiagNone"))       //未处置人数
	Set DiagCancelSum=+$g(^TMP($zn,$j,"QryAssessRate","DiagCancel"))   //排除人数
	Set DiagnosisSum=+$g(^TMP($zn,$j,"QryAssessRate","Diagnosis"))     //确诊人数
	Set RepUnScreenCnt=+$g(^TMP($zn,$j,"QryAssessRate","FN"))          //感染非疑似病例 假阴性（FN）
	Set InfScreenCnt=+$g(^TMP($zn,$j,"QryAssessRate","TP"))            //感染疑似病例   真阳性（TP）
	Set ScreenUnInfCnt=+$g(^TMP($zn,$j,"QryAssessRate","FP"))          //疑似非感染病例 假阳性（FP）
	Set UnInfScreenCnt=+$g(^TMP($zn,$j,"QryAssessRate","TN"))          //非感染疑似人数=全部患者-感染患者-疑似非感染患者 真阴性（TN）
	
	Set:PatAdmSum>0 InfRate=$fn((ReportSum/PatAdmSum)*100,",",2)_"%"            //感染率=感染人数/总人数
	Set:ScreenSum>0 ScreenRate=$fn((ScreenSum/PatAdmSum)*100,",",2)_"%"         //疑似率=疑似人数/总人数
	Set:(DiagnosisSum)>0 DiagnosisRate=$fn((DiagnosisSum/ScreenSum)*100,"",2)_"%" 	//确诊率
	
	//准确率 阳性预测值 阴性预测值
    Set (ACCRatio,PPVRatio,NPVRatio)="0.00%"
    Set:((PatAdmSum)>0)&((InfScreenCnt+UnInfScreenCnt)>0) ACCRatio=$fn(((InfScreenCnt+UnInfScreenCnt)/PatAdmSum)*100,"",2)_"%" 	//准确率
    Set:(ScreenSum)>0 PPVRatio=$fn((InfScreenCnt/ScreenSum)*100,"",2)_"%" 	        //阳性预测值
    Set:(RepUnScreenCnt+RepUnScreenCnt)>0 NPVRatio=$fn((UnInfScreenCnt/(RepUnScreenCnt+UnInfScreenCnt))*100,"",2)_"%" 	//阴性预测值

    //灵敏度(真阳率) 特异度(真阴率) 
    Set (TPRRatio,TNRRatio)="0.00%"
    Set:(RepUnScreenCnt+InfScreenCnt)>0 TPRRatio=$fn((InfScreenCnt/(RepUnScreenCnt+InfScreenCnt))*100,"",2)_"%" 	//灵敏度 召回率
    Set:((ScreenUnInfCnt+UnInfScreenCnt)>0)&(UnInfScreenCnt>0) TNRRatio=$fn((UnInfScreenCnt/(ScreenUnInfCnt+UnInfScreenCnt))*100,"",2)_"%" 	//特异度
   
    //假阴性率 假阳性率
    Set (FNRRatio,FPRRatio)="0.00%"
    Set:TPRRatio>0 FNRRatio =$fn((100-TPRRatio),"",2)_"%"
    Set:TNRRatio>0 FPRRatio =$fn((100-TNRRatio),"",2)_"%"
		
	Set Data= $lb(PatAdmSum,ReportSum,ScreenSum,MissedSum,DiagNoneSum,DiagCancelSum,DiagnosisSum,ScreenRate,InfRate,DiagnosisRate)
	Set Data=Data_$lb(RepUnScreenCnt,UnInfScreenCnt,InfScreenCnt,ScreenUnInfCnt,ACCRatio,PPVRatio,NPVRatio,TPRRatio,TNRRatio,FNRRatio,FPRRatio)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1

	Kill ^TMP($zn,$j,"QryAssessRate")

	Quit $$$OK
}

ClassMethod QryAssessRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAssessRateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAssessRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssessRateExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2019-03-26
/// Description:  查询评估结果
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.AM.AssessResult
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.AMS.AssessRateSrv","QryRateDtl","3","","",2)
Query QryRateDtl(aModelDr As %String, aDateFrom As %String = "", aDateTo As %String = "", aType As %String = 1) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,AdmDays:%String,InfRepList:%String,SusResult:%String,RuleOprDtl:%String") [ SqlProc ]
{
}

ClassMethod QryRateDtlExecute(ByRef qHandle As %Binary, aModelDr As %String, aDateFrom As %String = "", aDateTo As %String = "", aType As %String = 1) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aModelDr="" $$$OK
	Set:aType="" aType =1
	Set:aDateFrom'="" aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom>aDateTo) $$$OK

	Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(aModelDr)
	Quit:'$IsObject(objModel) $$$OK
	Set ModelID   = objModel.%Id()
	Set AdmStatus = objModel.AMAdmStatus
	Set SttDate   = objModel.AMSttDate
	Set EndDate   = objModel.AMEndDate
	Set:(aDateFrom<SttDate)||(aDateFrom="") aDateFrom=SttDate
	Set:(aDateTo>EndDate)||(aDateTo="") aDateTo=EndDate
	
	Kill ^TMP($zn,$j,"QryRateDtl")
	
	If (AdmStatus'="I") {
	   	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
		Set Count=arrEpisodeDr.Count()
		For indEpis=1:1:Count {
			Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
			Continue:xEpisodeDr=""
			Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
			Continue:(PAAdmData="")
			Set AdmType = $lg(PAAdmData,18)
			Continue:(AdmType'["I")&&(AdmType'["EP")
			Set VisitStatus = $lg(PAAdmData,19)
			Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
	        Set AdmDate   =$lg(PAAdmData,20)
	    	Set DischDate =$lg(PAAdmData,26)
			If AdmStatus="D" {	//出院
				Continue:VisitStatus'="D"
				Continue:DischDate=""
				Continue:(DischDate<SttDate)||(DischDate>EndDate)
			} Else {	//在院 当前在院改为某段时间在院		
				Continue:AdmDate=""
				Continue:(AdmDate>EndDate)
				Continue:(DischDate'="")&&(DischDate<SttDate)
			}
				
			Set DateFrom =aDateFrom
		    Set DateTo =aDateTo
		    If (AdmStatus="D") {
			    Set DateFrom =AdmDate
		   		Set DateTo =DischDate
		    }
		    
			Continue:$d(^TMP($zn,$j,"QryRateDtl","PatAdm",xEpisodeDr))
	    	Set ^TMP($zn,$j,"QryRateDtl","PatAdm",xEpisodeDr) = ""

			Do BuildPatDtl(xEpisodeDr,DateFrom,DateTo,aType)
		}	
	} Else {
		Set xEpisodeDr=""
		For {
			Set xEpisodeDr=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr))
			Quit:xEpisodeDr=""
			
			Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
			Continue:(PAAdmData="")
			Set AdmType = $lg(PAAdmData,18)
			Continue:(AdmType'["I")&&(AdmType'["EP")
			Set VisitStatus = $lg(PAAdmData,19)
			Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
	        Set AdmDate   =$lg(PAAdmData,20)
	    	Set DischDate =$lg(PAAdmData,26)
			If AdmStatus="D" {	//出院
				Continue:VisitStatus'="D"
				Continue:DischDate=""
				Continue:(DischDate<SttDate)||(DischDate>EndDate)
			} Else {	//在院 当前在院改为某段时间在院		
				Continue:AdmDate=""
				Continue:(AdmDate>EndDate)
				Continue:(DischDate'="")&&(DischDate<SttDate)
			}
				
			Set DateFrom =aDateFrom
		    Set DateTo =aDateTo
		    If (AdmStatus="D") {
			    Set DateFrom =AdmDate
		   		Set DateTo =DischDate
		    }
			Do BuildPatDtl(xEpisodeDr,DateFrom,DateTo,aType)
		}
	}
	
	Set xEpisodeID=""
    For {
	    Set xEpisodeID=$o(^TMP($zn,$j,"QryRateDtl","PatListType"_aType,xEpisodeID))
	    Quit:xEpisodeID=""
	    
	    Set AdmData=..BuildPaadmData(xEpisodeID)
		Continue:(AdmData="")
		
		Set InfRepList =..GetInfRepList(xEpisodeID,DateFrom,DateTo)
		Set SusResult =""     //疑似筛查结果
		Set AssResuID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeID,0))
		If (AssResuID'="") {
			 Set AssResultData=$g(^DHCHAI.AM.AssessResultD(AssResuID))
			 Set SusResult=$lg(AssResultData,6)
		}
		Set RuleOprDtl=..GetSuRuleOprDtl(xEpisodeID,DateFrom,DateTo)
				
		Set Data = AdmData_$lb(InfRepList,SusResult,RuleOprDtl)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }

		
	Kill ^TMP($zn,$j,"QryRateDtl")
	Quit $$$OK
BuildPatDtl(aEpisodeID,aDateFrom,aDateTo,aType)
    
	//在院、出院患者人数
	Set ^TMP($zn,$j,"QryRateDtl","PatListType1",aEpisodeID)=""      //住院病例
	//感染人数
	Set IsReport=##class(DHCHAI.AMC.CSAssessTask).CheckIsReport(aEpisodeID,DateFrom,DateTo)
	If (IsReport=1) {
		Set ^TMP($zn,$j,"QryRateDtl","PatListType2",aEpisodeID)=""      //报告病例
	}
	
	Set ARStatus="",SuMatrix=""
    Set ResultID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,aEpisodeID,0))
    If (ResultID'="") {    //疑似、感染病例
	    Set ResultData=$g(^DHCHAI.AM.AssessResultD(ResultID))
	    Quit:ResultData=""    
	    Set IsActive   =$lg(ResultData,4)
	    Quit:IsActive'=1
	    Set ARStatus   =$lg(ResultData,8)
	    Set SuMatrix   =$lg(ResultData,14)
    }
    Set:(SuMatrix="TP")||(SuMatrix="FP") ^TMP($zn,$j,"QryRateDtl","PatListType3",aEpisodeID)=""     //疑似患者
   	Set:(SuMatrix="TP") ^TMP($zn,$j,"QryRateDtl","PatListType6",aEpisodeID)=""     //感染疑似患者
   	Set:(SuMatrix="FP") ^TMP($zn,$j,"QryRateDtl","PatListType8",aEpisodeID)=""     //疑似非感染患者	  
  
   	If ($d(^TMP($zn,$j,"QryRateDtl","PatListType2",aEpisodeID)))&
		('$d(^TMP($zn,$j,"QryRateDtl","PatListType6",aEpisodeID))) {
			Set ^TMP($zn,$j,"QryRateDtl","PatListType7",aEpisodeID)=""     //感染非疑似患者
	}
 
	Set:ARStatus=0 ^TMP($zn,$j,"QryAssessRate","PatListType4",aEpisodeID)=""   //排除人数
	Set:ARStatus=1 ^TMP($zn,$j,"QryAssessRate","PatListType5",aEpisodeID)=""   //确诊人数
			
    If ('$d(^TMP($zn,$j,"QryRateDtl","PatListType6",aEpisodeID)))&
    	('$d(^TMP($zn,$j,"QryRateDtl","PatListType7",aEpisodeID)))&
    	('$d(^TMP($zn,$j,"QryRateDtl","PatListType8",aEpisodeID))) {
		Set ^TMP($zn,$j,"QryRateDtl","PatListType9",aEpisodeID)=""  //非疑似感染患者
    }
   
	Quit
}

ClassMethod QryRateDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRateDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRateDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRateDtlExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2022-08-22
/// Description:  查询评估结果对比
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.AM.AssessResult
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.AMS.AssessRateSrv","QryComparison","3,4,5")
Query QryComparison(aModelDrs As %String) As %Query(ROWSPEC = "ModelID:%String,ModelDesc:%String,ACCRatio:%String,PPVRatio:%String,NPVRatio:%String,TPRRatio:%String,TNRRatio:%String,FNRRatio:%String,FPRRatio:%String") [ SqlProc ]
{
}

ClassMethod QryComparisonExecute(ByRef qHandle As %Binary, aModelDrs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aModelDrs="" $$$OK
	
	Kill ^TMP($zn,$j,"QryComparison")
	 
	For indM=1:1:$l(aModelDrs,",") {
		
		Kill ^TMP($zn,$j,"QryComparison")   //每个模型查询前需清理global
		
		Set ModelID = $p(aModelDrs,",",indM)
		Continue:ModelID=""
		Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(ModelID)
		Continue:'$IsObject(objModel) 
		Set AdmStatus = objModel.AMAdmStatus
		Set SttDate   = objModel.AMSttDate
		Set EndDate   = objModel.AMEndDate
		Set AMDesc    = objModel.AMDesc

		If (AdmStatus'="I") {
		   	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(SttDate,EndDate)
			Set Count=arrEpisodeDr.Count()
			For indEpis=1:1:Count {
				Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
				Continue:xEpisodeDr=""
				Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
				Continue:(PAAdmData="")
				Set AdmType = $lg(PAAdmData,18)
				Continue:(AdmType'["I")&&(AdmType'["EP")
				Set VisitStatus = $lg(PAAdmData,19)
				Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
		        Set AdmDate   =$lg(PAAdmData,20)
		    	Set DischDate =$lg(PAAdmData,26)
				If AdmStatus="D" {	//出院
					Continue:VisitStatus'="D"
					Continue:DischDate=""
					Continue:(DischDate<SttDate)||(DischDate>EndDate)
				} Else {	//在院 当前在院改为某段时间在院		
					Continue:AdmDate=""
					Continue:(AdmDate>EndDate)
					Continue:(DischDate'="")&&(DischDate<SttDate)
				}
					
				Set DateFrom =SttDate
			    Set DateTo =EndDate
			    If (AdmStatus="D") {
				    Set DateFrom =AdmDate
			   		Set DateTo =DischDate
			    }
				
				Continue:$d(^TMP($zn,$j,"QryComparison","PatAdm",xEpisodeDr))
			    Set num=$i(^TMP($zn,$j,"QryComparison","PatAdm"))   //在院、出院人数
				Set ^TMP($zn,$j,"QryComparison","PatAdm",xEpisodeDr) = ""
				
				//感染报告
				Set IsReport=##class(DHCHAI.AMC.CSAssessTask).CheckIsReport(xEpisodeDr,DateFrom,DateTo)
				
				//评估结果
				Set ARStatus="",SuMatrix=""
				Set xARID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeDr,0))
			    If (xARID'="") {    //疑似、感染病例
				    Set ResultData=$g(^DHCHAI.AM.AssessResultD(xARID))
				    Continue:ResultData=""    
				    Set IsActive  =$lg(ResultData,4)
				    Continue:IsActive'=1
				    Set ARStatus  =$lg(ResultData,8)
				    Set SuMatrix  =$lg(ResultData,14)
			    }
				
				Set:IsReport=1 num=$i(^TMP($zn,$j,"QryComparison","Report"))        //感染人数
				Set:SuMatrix'="" num=$i(^TMP($zn,$j,"QryComparison",SuMatrix))      //感染疑似TP 感染非疑似FN 疑似非感染FP 		
				Set:(ARStatus'="")&(ARStatus<2) num=$i(^TMP($zn,$j,"QryComparison","Screen"))	    //疑似人数(筛查评估中：未处置+确诊+排除)			
				Set:ARStatus=-1 num=$i(^TMP($zn,$j,"QryComparison","DiagNone"))     //未处置人数
				Set:ARStatus=0 num=$i(^TMP($zn,$j,"QryComparison","DiagCancel"))    //排除人数
				Set:ARStatus=1 num=$i(^TMP($zn,$j,"QryComparison","Diagnosis"))     //确诊人数
				Set:SuMatrix="" num=$i(^TMP($zn,$j,"QryComparison","TN"))
			}
		} Else {
			Set xEpisodeDr=""
			For {
				Set xEpisodeDr=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeDr))
				Quit:xEpisodeDr=""
				
				Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
				Continue:(PAAdmData="")
				Set AdmType = $lg(PAAdmData,18)
				Continue:(AdmType'["I")&&(AdmType'["EP")
				Set VisitStatus = $lg(PAAdmData,19)
				Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
		        Set AdmDate   =$lg(PAAdmData,20)
		    	Set DischDate =$lg(PAAdmData,26)
		    	
				//评估结果
				Set ARStatus="",SuMatrix=""
				Set xARID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeDr,0))
			    If (xARID'="") {    //疑似、感染病例
				    Set ResultData=$g(^DHCHAI.AM.AssessResultD(xARID))
				    Continue:ResultData=""    
				    Set IsActive  =$lg(ResultData,4)
				    Continue:IsActive'=1
				    Set ARStatus  =$lg(ResultData,8)
				    Set SuMatrix  =$lg(ResultData,14)
			    }
				Set num=$i(^TMP($zn,$j,"QryComparison","PatAdm"))   //总人数
				Set:xARID'="" num=$i(^TMP($zn,$j,"QryComparison","Report"))        //感染人数
				Set:SuMatrix'="" num=$i(^TMP($zn,$j,"QryComparison",SuMatrix))      //感染疑似TP 感染非疑似FN 疑似非感染FP 		
				Set:(ARStatus'="")&(ARStatus<2) num=$i(^TMP($zn,$j,"QryComparison","Screen"))	    //疑似人数(筛查评估中：未处置+确诊+排除)			
				Set:ARStatus=-1 num=$i(^TMP($zn,$j,"QryComparison","DiagNone"))     //未处置人数
				Set:ARStatus=0 num=$i(^TMP($zn,$j,"QryComparison","DiagCancel"))    //排除人数
				Set:ARStatus=1 num=$i(^TMP($zn,$j,"QryComparison","Diagnosis"))     //确诊人数
			}
		}
		Set PatAdmSum=+$g(^TMP($zn,$j,"QryComparison","PatAdm"))	       //在院、出院人数
		Set ReportSum=+$g(^TMP($zn,$j,"QryComparison","Report"))           //感染人数
		Set ScreenSum=+$g(^TMP($zn,$j,"QryComparison","Screen"))	       //疑似人数(筛查评估中：未处置+确诊+排除)
		Set DiagNoneSum=+$g(^TMP($zn,$j,"QryComparison","DiagNone"))       //未处置人数
		Set DiagCancelSum=+$g(^TMP($zn,$j,"QryComparison","DiagCancel"))   //排除人数
		Set DiagnosisSum=+$g(^TMP($zn,$j,"QryComparison","Diagnosis"))     //确诊人数
		Set RepUnScreenCnt=+$g(^TMP($zn,$j,"QryComparison","FN"))          //感染非疑似病例 假阴性（FN）
		Set InfScreenCnt=+$g(^TMP($zn,$j,"QryComparison","TP"))            //感染疑似病例   真阳性（TP）
		Set ScreenUnInfCnt=+$g(^TMP($zn,$j,"QryComparison","FP"))          //疑似非感染病例 假阳性（FP）
		Set UnInfScreenCnt=+$g(^TMP($zn,$j,"QryComparison","TN"))          //非感染疑似人数=全部患者-感染患者-疑似非感染患者 真阴性（TN）
		
		Set:PatAdmSum>0 InfRate=$fn((ReportSum/PatAdmSum)*100,",",2)_"%"            //感染率=感染人数/总人数
		Set:ScreenSum>0 ScreenRate=$fn((ScreenSum/PatAdmSum)*100,",",2)_"%"         //疑似率=疑似人数/总人数
		Set:(DiagnosisSum)>0 DiagnosisRate=$fn((DiagnosisSum/ScreenSum)*100,"",2)_"%" 	//确诊率
		
		//准确率 阳性预测值 阴性预测值
	    Set (ACCRatio,PPVRatio,NPVRatio)="0.00%"
	    Set:((PatAdmSum)>0)&((InfScreenCnt+UnInfScreenCnt)>0) ACCRatio=$fn(((InfScreenCnt+UnInfScreenCnt)/PatAdmSum)*100,"",2)_"%" 	//准确率
	    Set:(ScreenSum)>0 PPVRatio=$fn((InfScreenCnt/ScreenSum)*100,"",2)_"%" 	        //阳性预测值
	    Set:(RepUnScreenCnt+RepUnScreenCnt)>0 NPVRatio=$fn((UnInfScreenCnt/(RepUnScreenCnt+UnInfScreenCnt))*100,"",2)_"%" 	//阴性预测值

	    //灵敏度(真阳率) 特异度(真阴率) 
	    Set (TPRRatio,TNRRatio)="0.00%"
	    Set:(RepUnScreenCnt+InfScreenCnt)>0 TPRRatio=$fn((InfScreenCnt/(RepUnScreenCnt+InfScreenCnt))*100,"",2)_"%" 	//灵敏度 召回率
	    Set:((ScreenUnInfCnt+UnInfScreenCnt)>0)&(UnInfScreenCnt>0) TNRRatio=$fn((UnInfScreenCnt/(ScreenUnInfCnt+UnInfScreenCnt))*100,"",2)_"%" 	//特异度
	   
	    //假阴性率 假阳性率
	    Set (FNRRatio,FPRRatio)="0.00%"
	    Set:TPRRatio>0 FNRRatio =$fn((100-TPRRatio),"",2)_"%"
	    Set:TNRRatio>0 FPRRatio =$fn((100-TNRRatio),"",2)_"%"
			
		Set Data=$lb(ModelID,AMDesc,ACCRatio,PPVRatio,NPVRatio,TPRRatio,TNRRatio,FNRRatio,FPRRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}

	Kill ^TMP($zn,$j,"QryComparison")

	Quit $$$OK
}

ClassMethod QryComparisonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryComparisonExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryComparisonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryComparisonExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildPaadmData(aEpisodeID As %String) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx=objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus = objPaadm.PAVisitStatus
	Set AdmType = $s(AdmType="I":"住院",AdmType="EP":"急诊留观")  
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName

	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Nation = objPaadm.PANation
	Set Birthday = objPaadm.PABirthday
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set Age = objPaadm.PAAge
	
	Set IsDeath = objPaadm.PAIsDeath
	Set DeathDate = objPaadm.PADeathDate
	Set:DeathDate'="" DeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime = objPaadm.PADeathTime
	Set:DeathTime'="" DeathTime=$zt(DeathTime)
	Set AdmType = objPaadm.PAAdmType
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmTimes = objPaadm.PAAdmTimes
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set AdmWardID = objAdmWard.%Id()
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmDays = objPaadm.PAAdmDays
	if AdmDays=-1{
		Set AdmDays = (+$h)-objPaadm.PAAdmDate //修复bug:557856统一住院天数计算
		if (DischDate) {  //如果已经下出院医嘱，取其中最小的住院时间
			if (DischDate["-"){
				Set AdmDays1 = $zdh(DischDate,3) - objPaadm.PAAdmDate
			} elseif(DischDate["/"){
				Set AdmDays1 = $zdh(DischDate,4) - objPaadm.PAAdmDate
			}
			
			if (AdmDays1<AdmDays) Set AdmDays=AdmDays1
		}
	}
	
	Set return = $lb(aEpisodeID,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Nation,Birthday,Age,IsDeath,DeathDate,DeathTime,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc,AdmDays)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-03-22
/// Description:  通过就诊查询感染报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       aEpisodeID: 就诊ID
/// Return：      成功：返回字符串，失败：空
/// w ##class(DHCHAI.AMS.ScreenResultSrv).GetInfRepList("1356")
ClassMethod GetInfRepList(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
    Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
    Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set InfRepList=""
	
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,1,xRepID))
		Quit:xRepID=""
		Set InfRepData=$g(^DHCHAI.IR.INFReportD(xRepID))
		Continue:InfRepData=""
		Set StatusDr = $lg(InfRepData,8)
		Continue:StatusDr=""
		Set StatusDic = $g(^DHCHAI.BT.DictionaryD(StatusDr))
		Continue:StatusDic=""
		Set StatusCode=$lg(StatusDic,2)
		Continue:(StatusCode=4)  //4作废
		Set RepStatus=$lg(StatusDic,3)
		
		Set IsReport=0
		// 感染诊断信息
		Set (InfPosDescs,InfSubDescs,InfDateDescs,InfLocDescs)=""
		Set xRepSubID=""
		For {
			Set xRepSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xRepSubID))
			Quit:xRepSubID=""

			Set RepExtData= $g(^DHCHAI.IR.INFReportD(xRepID,"EXT",xRepSubID))
	   	 	Continue:RepExtData=""
			Set ObjectID = $lg(RepExtData,3)
			Continue:ObjectID=""
			Set DiagData=$g(^DHCHAI.IR.INFDiagnosD(ObjectID))
			Continue:DiagData=""
			Set IsActive = $lg(DiagData,17)
			Continue:(IsActive'=1)
			Set InfType = $lg(DiagData,18)
			Continue:(InfType'=1)
			Set InfDate = $lg(DiagData,5)
			Continue:(aDateFrom'="")&(InfDate<aDateFrom)
			Continue:(aDateTo'="")&(InfDate>aDateTo)
			Set IsReport=1
			Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			Set:InfDate'="" InfDateDescs=InfDateDescs_","_InfDate
			// 感染诊断	
			Set InfPosDr = $lg(DiagData,3)
			Continue:InfPosDr=""
			Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPosDr))
			Set InfPos=$lg(InfPosData,3)
			Set InfPosDescs = InfPosDescs_","_InfPos
			
			Set InfSubDr= $lg(DiagData,4)
			If (InfSubDr'="") {
				Set InfSubData=$g(^DHCHAI.BT.InfSubD(InfSubDr))
				Set InfSub=$lg(InfSubData,3)
				Set InfSubDescs = InfSubDescs_","_InfSub
			}
		}
		Continue:IsReport'=1
		Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
		Set:InfSubDescs'="" InfSubDescs = $e(InfSubDescs,2,$l(InfSubDescs))
		Set:InfDateDescs'="" InfDateDescs = $e(InfDateDescs,2,$l(InfDateDescs))
	    Set InfRepList =InfRepList_"^"_xRepID_" "_InfDateDescs_" "_InfPosDescs_" "_InfSubDescs_" "_RepStatus
	}
	Set:InfRepList'="" InfRepList=$e(InfRepList,2,$l(InfRepList))
	Set return=InfRepList
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-08-11
/// Description:  疑似筛查规则确诊排除明细
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreenLog
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
/// Return：      成功：返回字符串，失败：空
/// w ##class(DHCHAI.AMS.ScreenResultSrv).GetSuRuleOprDtl("1596")
ClassMethod GetSuRuleOprDtl(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
    Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set SuOprList=""
	Set xScreenID =""
	For {
		Set xScreenID =$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
		Quit:xScreenID=""
		
		Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
	   	Continue:ScreenData=""	   	
	   	Set ItmScreenID=$lg(ScreenData,3)
	   	Set ItmScreenTxt=$lg(ScreenData,4)	
	    Set ItmScreenData=$g(^DHCHAI.IR.CCItmScreenD(ItmScreenID))
	    Set ItmScreen=$lg(ItmScreenData,2)
	    Set RstFromDate=$lg(ScreenData,7)   //处置结果开始日期
	    Set RstToDate=$lg(ScreenData,8)     //处置结束开始日期
	    Continue:(aDateFrom'="")&(RstToDate<aDateFrom)     
	    Continue:(aDateTo'="")&(RstFromDate>aDateTo)
	    
	    //检出菌对应多条疑似规则需特殊处理
	    Set RuleDetails=ItmScreen
	    If ((ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染"))&(ItmScreenTxt'=""){
		    Set RuleDetails=##class(DHCHAI.IRS.CCScreenLogSrv).BacteriaItem(aEpisodeID,ItmScreenTxt)
	    }
		Set xDtlID = ""
	   	For {
	   		Set xDtlID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xDtlID))
	   		Quit:xDtlID=""
	   		
	   		Set ScreenDtlData=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xDtlID))
	   		Continue:ScreenDtlData=""		   		
	   		Set Status = $lg(ScreenDtlData,2)
	   		Set Status =$s(Status=2:"排除",Status=1:"确诊",1:"待处理")
			
			Set DiagnosDr=$lg(ScreenDtlData,4)
			Set DiagnosData=$g(^DHCHAI.IR.INFDiagnosD(+DiagnosDr))
		    Set InfPosDr=$lg(DiagnosData,3)
		    Set InfPosData=$g(^DHCHAI.BT.InfPosD(+InfPosDr))
		    Set InfPosDesc=$lg(InfPosData,3)
		   	Set InfSubDr=$lg(DiagnosData,4)
		    Set InfSubData=$g(^DHCHAI.BT.InfSubD(+InfSubDr))
		    Set InfSubDesc=$lg(InfSubData,3)
			Set InfPosDesc=$s(InfSubDesc'="":InfPosDesc_"-"_InfSubDesc,1:InfPosDesc)
		
			Set ActDate=$lg(ScreenDtlData,5)
			Set ActTime=$lg(ScreenDtlData,6)
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActDateTime=ActDate_" "_ActTime
			Set (ActUserCode,ActUserDesc)=""
	   		Set ActUserDr	= $lg(ScreenDtlData,7)
	   		Set UserData=$g(^DHCHAI.BT.SysUserD(+ActUserDr))
	   		Set ActUserCode=$lg(UserData,2)
	   		Set ActUserDesc=$lg(UserData,3)
			   
	    	Set SuOprList =SuOprList_"^"_xScreenID_"||"_xDtlID_","_RuleDetails_","_Status_","_ActDate_","_ActTime_","_ActUserDesc
	   	}
	}
	Set:SuOprList'="" SuOprList=$e(SuOprList,2,$l(SuOprList))
	Set return=SuOprList
	Quit return
}

}
