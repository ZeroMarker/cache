/// 名称: DHCHAI.AMS.AssessResultSrv
/// 描述: 疑似病例筛查统计相关服务
/// 编写者：pylian
/// 编写日期: 2022-08-08
Class DHCHAI.AMS.ScreenResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2022-08-24
/// Description:  疑似筛查统计自动任务
/// Table：       DHCHAI.AM.AssessModel、DHCHAI.AM.AssessResult
/// Input：       aDate : 生成数据的日期（为方便手工执行任务格式YYYY-MM）
/// Return：      返回String
/// w ##class(DHCHAI.AMS.ScreenResultSrv).SuRuleTask()
ClassMethod SuRuleTask(aAssDate As %String = "") As %String
{
	Set return=0
	
	If (aAssDate'=""){
		Set SyncYear=+$p(aAssDate,"-",1) 
		Set:aAssDate'="" SyncMonth=+$p(aAssDate,"-",2)
		Set SyncDay = 1
	}Else {
		Set SyncYear=+$p($zd(+$h,3),"-",1)
		Set SyncMonth=+$p($zd(+$h,3),"-",2)
		Set SyncDay=+$p($zd(+$h,3),"-",3)
	}
	Quit:SyncDay'=1 return   //非每月首日不做自动同步

	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.Task.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"命令")="SuRuleTask("_Date_")"
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	Kill arrSyncList
	If (SyncMonth=1) {
		Set DateFrom=$zdh((SyncYear-1)_"-"_"12-01",3)
		Set DateTo=$zdh((SyncYear-1)_"-"_"12-31",3)
	}Else {
		Set DateFrom=$zdh(SyncYear_"-"_(SyncMonth-1)_"-"_"01",3)
		Set DateTo=$zdh(SyncYear_"-"_SyncMonth_"-"_"01",3)-1  //当前月减一天为上个月末
	}
	Set arrSyncList(1)=$lb(DateFrom,DateTo)
	
	If (SyncMonth=1) { //上一年 上一年四季度 上一年下半年
		//四季度
		Set DateFrom=$zdh((SyncYear-1)_"-"_"10-01",3)
		Set DateTo=$zdh((SyncYear-1)_"-"_"12-31",3)
		Set arrSyncList(2)=$lb(DateFrom,DateTo)
		//下半年
		Set DateFrom=$zdh((SyncYear-1)_"-"_"07-01",3)
		Set DateTo=$zdh((SyncYear-1)_"-"_"12-31",3)
		Set arrSyncList(3)=$lb(DateFrom,DateTo)
		//全年
		Set DateFrom=$zdh((SyncYear-1)_"-"_"01-01",3)
		Set DateTo=$zdh((SyncYear-1)_"-"_"12-31",3)
		Set arrSyncList(4)=$lb(DateFrom,DateTo)
	}ElseIf (SyncMonth=4) { //当年 当年一季度
		//一季度
		Set DateFrom=$zdh(SyncYear_"-"_"01-01",3)
		Set DateTo=$zdh(SyncYear_"-"_"03-31",3)	
		Set arrSyncList(2)=$lb(DateFrom,DateTo)
	}ElseIf (SyncMonth=7) { //当年 当年二季度 当年上半年
		//季度
		Set DateFrom=$zdh(SyncYear_"-"_"04-01",3)
		Set DateTo=$zdh(SyncYear_"-"_"06-30",3)
		Set arrSyncList(2)=$lb(DateFrom,DateTo)
		//上半年
		Set DateFrom=$zdh(SyncYear_"-"_"01-01",3)
		Set DateTo=$zdh(SyncYear_"-"_"06-30",3)	
		Set arrSyncList(3)=$lb(DateFrom,DateTo)
	}ElseIf (SyncMonth=10) { //当年 当年三季度
		//季度
		Set DateFrom=$zdh(SyncYear_"-"_"07-01",3)
		Set DateTo=$zdh(SyncYear_"-"_"09-30",3)	
		Set arrSyncList(2)=$lb(DateFrom,DateTo)
	}

    Set StatusList=$lb("A","D")
	Set xType=0
	For {
		Set xType=$o(arrSyncList(xType))
		Quit:xType=""
		
		Set SyncList =$g(arrSyncList(xType))
		Set DateFrom=$lg(SyncList,1)
		Set DateTo=$lg(SyncList,2)
		
		For indS=1:1:$l(StatusList) {
			Set AdmStatus =$lg(StatusList,indS)
			Continue:AdmStatus=""
			Set ret=##class(DHCHAI.AMS.ScreenResultSrv).SyncSuRule(DateFrom,DateTo,AdmStatus)
			If (+ret)<0 {
				Set ErrClass  = "DHCHAI.AMS.ScreenResultSrv"
				Set ErrMethod = "SyncSuRule"
				Set ErrArgStr = $lb(ret)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("",ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	//记录执行任务日志（成功标记）
	Set ^DHCHAI.Task.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	Set return =1
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-08-08
/// Description:  疑似筛查评估任务(用于疑似筛查统计)
/// Table：       DHCHAI.AM.AssessModel、DHCHAI.AM.AssessResult
/// Input：       aModelDr : 评估模型ID
/// Return：      返回String
/// w ##class(DHCHAI.AMS.ScreenResultSrv).IsExitAssSta("2020-07-01","2020-07-31","D")
ClassMethod IsExitAssSta(aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %String
{
	New (aDateFrom,aDateTo,aAdmStatus)
	Set return=0
	Quit:(aDateFrom="")||(aDateTo="")||(aAdmStatus="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	
	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
	Set Flg=0
	If $d(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"))) {
		Set Flg=1
	}
	Set return=Flg
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-08-08
/// Description:  疑似筛查评估任务(用于疑似筛查统计)
/// Table：       DHCHAI.AM.AssessModel、DHCHAI.AM.AssessResult
/// Input：       aModelDr : 评估模型ID
/// Return：      返回String
/// w ##class(DHCHAI.AMS.ScreenResultSrv).SyncSuRule("2020-08-01","2020-08-31","A")
ClassMethod SyncSuRule(aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %String
{
	New (aDateFrom,aDateTo,aAdmStatus)
	Set return=0,Count=0,arrCount=0
	Quit:(aDateFrom="")||(aDateTo="")||(aAdmStatus="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	
	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
	Set AdmStatus="住院患者"
	Set:aAdmStatus="D" AdmStatus="出院患者"
	Set AMDesc=AdmStatus_"疑似筛查统计"_"("_$zd(aDateFrom,3)_"至"_$zd(aDateTo,3)_")"
	
	Set ClassName="DHCHAI.IRC.CSResultSrv"
	Set Note="借助疑似筛查评估统计疑似筛查"
	
	Set ID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"),0))
	Set InStr=""
	Set $p(InStr,"^",1)=ID
	Set $p(InStr,"^",2)=AMCode
	Set $p(InStr,"^",3)=AMDesc
	Set $p(InStr,"^",4)=1
	Set $p(InStr,"^",5)=aAdmStatus
	Set $p(InStr,"^",6)=aDateFrom
	Set $p(InStr,"^",7)=aDateTo
	Set $p(InStr,"^",8)=ClassName
	Set $p(InStr,"^",9)=Note
	Set $p(InStr,"^",10)=""
	Set $p(InStr,"^",11)=2
	
	Set ModelID=##class(DHCHAI.AM.AssessModel).Update(InStr,"^")
	Quit:(+ModelID)<1 return
	//作废原有评估记录
	Set flg=##class(DHCHAI.AMC.CSAssessTask).CancelAMResult(ModelID)
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"命令")="SyncSuRule("_ModelID_")"
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
   
	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	Set arrCount=arrEpisodeDr.Count()
	For indEpis=1:1:arrCount {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
	  
		Write "EpisodeDr="_xEpisodeDr,!
		Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeDr_")"
		
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
		Continue:(PAAdmData="")
		Set AdmType = $lg(PAAdmData,18)
		Continue:(AdmType'["I")&&(AdmType'["EP")
		Set VisitStatus = $lg(PAAdmData,19)
		Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
        Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
		If aAdmStatus="D" {	//出院
			Continue:VisitStatus'="D"
			Continue:DischDate=""
			Continue:(DischDate<aDateFrom)||(DischDate>aDateTo)
		} Else {	//在院 当前在院改为某段时间在院		
			Continue:AdmitDate=""
			Continue:(AdmitDate>aDateTo)
			Continue:(DischDate'="")&&(DischDate<aDateFrom)
		}
			
		Set DateFrom =aDateFrom
	    Set DateTo =aDateTo
	    If (aAdmStatus="D") {
		    Set DateFrom =AdmitDate
	   		Set DateTo =DischDate
	    }
    	//感染报告
		Set IsReport=##class(DHCHAI.AMC.CSAssessTask).CheckIsReport(xEpisodeDr,DateFrom,DateTo)
		
		Do UpdateSuResult(DateFrom,DateTo)
	}
	
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit return
	
UpdateSuResult(DateFrom,DateTo)
	
	K ^TMP($zn,$j,"ItmScreen")
	K ^TMP($zn,$j,"Screen-Cnt")
    Set execute="Set arr=##class("_ClassName_").GetSuRuleResult(xEpisodeDr,DateFrom,DateTo)"
	Xecute execute
	
	Set InfType1=0,InfType2=0,InfType3=0,SusResult="",SusDiagnos=""
	For indArr=1:1:arr.Count() {
		Set obj=arr.GetAt(indArr)
		Continue:'$IsObject(obj)
		Continue:obj.CSIsActive'=1
		Continue:obj.CSRstStatus'=1   //结果状态(0触发疑似指标、1触发组合条件)
		
		Set ItmScreenID   = obj.CSItmScreenDr.%Id()
		Set ItmScreenDesc = obj.CSItmScreenDr.CCDesc
		Set ItmScreenTxt  =  $tr(obj.CSItmScreenTxt," ","")
		Set ResultNote    = obj.CSResultNote

		Set ResultDate    = obj.CSResultDate
		Set ResultCnt     = obj.CSResultCnt
		Set RstFromDate   = obj.CSRstFromDate
		Set RstToDate     = obj.CSRstToDate
		Set RstStatus     = obj.CSRstStatus
		Set OprStatus     = obj.CSOprStatus
		Set InfSuDate     = obj.CSInfSuDate     //推荐感染日期
		Set InfSuKeys     = obj.CSInfSuKeys     //疑似诊断关键词信息
		Set InfSuPosID    = obj.CSInfSuPosDr    //疑似诊断（部位）
		Set Specimen      = obj.CSSpecimen      //(新增)标本名称（多值#分隔）
		Set MRBType       = obj.CSMRBType       //(新增)多耐分类名称（多值#分隔）
		Set InfSuRuleDr   = obj.CSInfSuRuleDr   //(新增)规则ID（多值#分隔)
		Set ItmTxt=ItmScreenTxt
		Set:ItmTxt="" ItmTxt="*"
		Set ^TMP($zn,$j,"ItmScreen",InfSuRuleDr,ItmScreenID,ItmTxt,indArr) = $lb(InfSuRuleDr,InfSuPosID,InfSuKeys,InfSuDate,Specimen,MRBType,ItmScreenTxt,ResultDate,RstStatus,OprStatus,ItmScreenDesc,ResultNote,RstFromDate,RstToDate)
 	}	
    
    
    Set SuRuleDtls=""
    Set xInfSuRuleID=""
 	For{
	 	Set xInfSuRuleID=$o(^TMP($zn,$j,"ItmScreen",xInfSuRuleID))
	 	Quit:xInfSuRuleID=""
	 	
	 	Set SuMatrix=""   //评估类型
	 	Set xItmScreenID=""
	 	For{
		 	Set xItmScreenID=$o(^TMP($zn,$j,"ItmScreen",xInfSuRuleID,xItmScreenID))
		 	Quit:xItmScreenID=""
		 	
		 	Set IsScreen=0,SuRuleOpr=""      //是否疑似病例
		 	Set xItmScreenTxt=""	 	
		 	For{
		 		Set xItmScreenTxt=$o(^TMP($zn,$j,"ItmScreen",xInfSuRuleID,xItmScreenID,xItmScreenTxt))
		 		Quit:xItmScreenTxt=""	
		 	
		 	    Set IsScreen=1   //疑似
			 	Set InfSuPosIDList="",InfSuDateList="",ResultDateList="",SpecimenList="",MRBTypeList="",ItmScreenDesc="",DetailsList=""
			 	Set xindArr=""
			 	For{
			 		Set xindArr=$o(^TMP($zn,$j,"ItmScreen",xInfSuRuleID,xItmScreenID,xItmScreenTxt,xindArr))
			 		Quit:xindArr=""
			 		
			 		Set SuRuleInfo = $g(^TMP($zn,$j,"ItmScreen",xInfSuRuleID,xItmScreenID,xItmScreenTxt,xindArr))
			 	    Continue:SuRuleInfo=""
			 	    Set InfSuRuleDr  = $lg(SuRuleInfo,1)
			 	    Set InfSuPosID   = $lg(SuRuleInfo,2)
			 	    Set InfSuKeys    = $lg(SuRuleInfo,3)
			 	    Set InfSuDate    = $lg(SuRuleInfo,4)
			 	    Set Specimen     = $lg(SuRuleInfo,5)
			 	    Set MRBType      = $lg(SuRuleInfo,6)
			 	    Set ItmScreenTxt = $lg(SuRuleInfo,7)
			 	    Set ResultDate   = $lg(SuRuleInfo,8)
			 	    Set RstStatus    = $lg(SuRuleInfo,9)
			 	    Set OprStatus    = $lg(SuRuleInfo,10)   
			 	   	Set ItmScreenDesc = $lg(SuRuleInfo,11)
			 	   	Set ResultNote   = $lg(SuRuleInfo,12)
			 	   	Set RstFromDate  = $lg(SuRuleInfo,13)
			 	   	Set RstToDate    = $lg(SuRuleInfo,14)
			 	   	Set Details      = $lg(SuRuleInfo,15)
			 	    	   
			 	   	If ($listfind(ResultDateList,InfSuDate)<1) {
			 	   		Set ResultDateList=ResultDateList_$lb(ResultDate)
			 	   	}
			 	   	Set:Details'="" DetailsList=DetailsList_"#"_Details	
			 	   	Set:ResultNote["病程" DetailsList="#"_InfSuKeys	  
			 	   	Set:ResultNote["权重" ResultDateList = ResultDate   //update 2022-05-10 权重组合判断规则日期比较特殊 
			 	}
			   
			    Set:DetailsList'="" DetailsList=$e(DetailsList,2,$l(DetailsList))
			    Set ResultDate=$lg(ResultDateList,1)  
				Set:ResultDate'="" ResultDate=$zd(ResultDate,3) 
				
			    Set:DetailsList'="" ResultNote=ResultNote_"<br>"_DetailsList
			    If SusResult'="" {
					Set SusResult=SusResult_","_ResultNote_"("_ResultDate_")"
				} Else {
					Set SusResult=ResultNote_"("_ResultDate_")"
				}
		 	}
		 	
		 	Set IsOpr =0
		 	Set xScreenID=""
		   	For {
			   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",xEpisodeDr,xItmScreenID," "_$zcvt(ItmScreenTxt,"U"),xScreenID))
			   	Quit:xScreenID=""
			   	
			   	Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
	   			Continue:ScreenData=""	 
			   	Set RstFromDate=$lg(ScreenData,7)   //处置结果开始日期
			    Set RstToDate=$lg(ScreenData,8)     //处置结束开始日期
			    Continue:(DateFrom'="")&(RstToDate<DateFrom)     
			    Continue:(DateTo'="")&(RstFromDate>DateTo)
	    			   
			   	Set IsOpr=1   //处置
				Set xSubID = ""
			   	For {
			   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
			   		Quit:xSubID=""
		   		
		   		    Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
		   		    Continue:ScreenDtl=""
		   		  
		   		    Set Status= $lg(ScreenDtl,2)
		   		    Continue:Status=2
		   		    Set InfRepPosDr=$lg(ScreenDtl,4)   //确诊诊断ID
		   		    Continue:InfRepPosDr=""
		   		    
			   	    Set InfDiagData=$g(^DHCHAI.IR.INFDiagnosD(InfRepPosDr))
			   	    Continue:InfDiagData=""
			   	    Set IsActive = $lg(InfDiagData,17)
			   	    Continue:IsActive'=1
			   	    
			   	    Set SuRuleOpr=1   //确诊
			   	    Quit
			   	}
			   	
		 	}
		   	Set:(IsOpr=1)&(SuRuleOpr="") SuRuleOpr =2  //排除
		   
		 	Set InfType1=1
	 	}
	 	Set SuRuleDtls = SuRuleDtls_","_xInfSuRuleID_"-"_SuRuleOpr
 	}
	Set:SuRuleDtls'="" SuRuleDtls=$e(SuRuleDtls,2,$l(SuRuleDtls))
	
	Set InfType=0,Status=-1,IsActive=1,SuMatrix=""
	If (InfType1>0) {
		Set SuMatrix="FP"
		Set InfType=1,Status=-1  //疑似感染
		Set:(IsReport>0) Status=1,SuMatrix="TP" //自报感染和报告病例，默认“确认”状态
		
	} Else {
		If (IsReport>0) {
			Set InfType=2,Status=2
		}
		Set SuMatrix="FN"   //感染非疑似 
	}	
	Quit:InfType=0 return  //不是疑似感染,也不是自报感染
	
	Set (DiagDate,DiagNote,RstDate,RstTime,RstUserDr)=""
	Set ResultID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeDr,0))
	Set $p(InputStr,"^",1)    = ResultID
	Set $p(InputStr,"^",2)    = ModelID   //评估模型代码
	Set $p(InputStr,"^",3)    = xEpisodeDr //就诊号
	Set $p(InputStr,"^",4)    = IsActive   //是否有效
	Set $p(InputStr,"^",5)    = InfType    //1疑似病例、2自报感染、3疑似社区感染
	Set $p(InputStr,"^",6)    = SusResult  //疑似筛查结果
	Set $p(InputStr,"^",7)    = ""         //疑似感染诊断/部位
	Set $p(InputStr,"^",8)    = Status     //状态（-1未处置、0排除、1确诊、2自报）
	Set $p(InputStr,"^",9)    = DiagDate   //确诊日期
	Set $p(InputStr,"^",10)   = DiagNote   //诊断依据、排除依据
	Set $p(InputStr,"^",11)   = RstDate    //处置日期
	Set $p(InputStr,"^",12)   = RstTime    //处置时间
	Set $p(InputStr,"^",13)   = RstUserDr  //处置人	
	Set $p(InputStr,"^",14)   = SuMatrix  
	Set $p(InputStr,"^",15)   = SuRuleDtls  	
		
	Set flg=##class(DHCHAI.AM.AssessResult).Update(InputStr,"^")
	Set Count=Count+1
  
	Set return=Count
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-08-08
/// Description:  统计疑似筛查指标准确性（指标维度）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
///               AdmStatus：统计类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.AMS.ScreenResultSrv","QrySuRuleRate","1|2|3","2022-08-01","2022-08-17","A")
Query QrySuRuleRate(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %Query(ROWSPEC = "RuleID:%String,RuleNo:%String,RuleType:%String,RuleNote:%String,ItmScreenDr:%String,PatientCnt:%Integer,InfRepCnt:%Integer,InfRepRatio:%String,ScreeningCnt:%Integer,ScreenRatio:%String,DiagnosCnt:%Integer,DiagRatio:%String,ExcludeCnt:%Integer,ExcRatio:%String,RepUnScreenCnt:%Integer,UnInfScreenCnt:%Integer,InfScreenCnt:%Integer,ScreenUnInfCnt:%Integer,ACCRatio:%String,PPVRatio:%String,NPVRatio:%String,TPRRatio:%String,TNRRatio:%String,FNRRatio:%String,FPRRatio:%String,F1Value:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleRateExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Quit:(aDateFrom="")||(aDateTo="")||(aAdmStatus="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

 	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
    Set ModelID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"),0))
    Quit:ModelID="" $$$OK
 	
	Kill ^TMP($zn,$j,"ScreenRate-Cnt")
	Kill ^TMP($zn,$j,"SuRuleResult")

	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	Set arrCount=arrEpisodeDr.Count()
	For indEpis=1:1:arrCount {
		Set xPaadm=arrEpisodeDr.GetAt(indEpis)
		Continue:xPaadm=""
	  
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
		Continue:(PAAdmData="")
		Set AdmType = $lg(PAAdmData,18)
		Continue:(AdmType'["I")&&(AdmType'["EP")
		Set VisitStatus = $lg(PAAdmData,19)
		Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
        Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
		If aAdmStatus="D" {	//出院
			Continue:VisitStatus'="D"
			Continue:DischDate=""
			Continue:(DischDate<aDateFrom)||(DischDate>aDateTo)
		} Else {	//在院 当前在院改为某段时间在院		
			Continue:AdmitDate=""
			Continue:(AdmitDate>aDateTo)
			Continue:(DischDate'="")&&(DischDate<aDateFrom)
		}
        //院区过滤
        Set AdmLocID =$lg(PAAdmData,22)  
		Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocID))
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
		
		Set DateFrom =aDateFrom
	    Set DateTo =aDateTo
	    If (aAdmStatus="D") {
		    Set DateFrom =AdmitDate
	   		Set DateTo =DischDate
	    }
		Do BuildSuRulePat(xPaadm,DateFrom,DateTo)
	}
    
	Set PatientCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","PatientCnt"))    //患者人数
	Set InfRepCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","InfRepCnt"))      //感染人数
	
	//综合指标	
	Set (ScreeningCnt,ScreenOperCnt,DiagnosCnt,ExcludeCnt,RepUnScreenCnt,UnInfScreenCnt,InfScreenCnt,ScreenUnInfCnt)=0
	Set ScreeningCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllScreeningCnt"))    //疑似人数
	Set ScreenOperCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllScreenOperCnt"))  //处置人数
	Set DiagnosCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllDiagnosCnt"))        //确诊人数
	Set ExcludeCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllExcludeCnt"))        //排除人数
	Set RepUnScreenCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllCnt","FN"))      //感染非疑似病例 假阴性（FN）
	Set InfScreenCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllCnt","TP"))        //感染疑似病例   真阳性（TP）
	Set ScreenUnInfCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllCnt","FP"))      //疑似非感染病例 假阳性（FP）
	Set UnInfScreenCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","AllCnt","TN"))      //非感染疑似人数=全部患者-感染患者-疑似非感染患者 真阴性（TN）
    //感染率 疑似率 确诊率 排除率 
    Set (InfRepRatio,ScreenRatio,DiagRatio,ExcRatio)="0.00%"
	Set:(PatientCnt)>0 InfRepRatio=$fn((InfRepCnt/PatientCnt)*100,"",2)_"%" 	//感染率
	Set:(PatientCnt)>0 ScreenRatio=$fn((ScreeningCnt/PatientCnt)*100,"",2)_"%" 	//疑似率
	Set:(ScreeningCnt)>0 DiagRatio=$fn((DiagnosCnt/ScreeningCnt)*100,"",2)_"%" 	//确诊率
	Set:(ScreeningCnt)>0 ExcRatio=$fn((ExcludeCnt/ScreeningCnt)*100,"",2)_"%" 	//排除率 
   
    //准确率 阳性预测值 阴性预测值
    Set (ACCRatio,PPVRatio,NPVRatio)="0.00%"
    Set:((PatientCnt)>0)&((InfScreenCnt+UnInfScreenCnt)>0) ACCRatio=$fn(((InfScreenCnt+UnInfScreenCnt)/PatientCnt)*100,"",2)_"%" 	//准确率
    Set:(ScreeningCnt)>0 PPVRatio=$fn((InfScreenCnt/ScreeningCnt)*100,"",2)_"%" 	        //阳性预测值
    Set:(RepUnScreenCnt+RepUnScreenCnt)>0 NPVRatio=$fn((UnInfScreenCnt/(RepUnScreenCnt+UnInfScreenCnt))*100,"",2)_"%" 	//阴性预测值

    //灵敏度(真阳率) 特异度(真阴率) 
    Set (TPRRatio,TNRRatio)="0.00%"
    Set:(RepUnScreenCnt+InfScreenCnt)>0 TPRRatio=$fn((InfScreenCnt/(RepUnScreenCnt+InfScreenCnt))*100,"",2)_"%" 	//灵敏度 召回率
    Set:((ScreenUnInfCnt+UnInfScreenCnt)>0)&(UnInfScreenCnt>0) TNRRatio=$fn((UnInfScreenCnt/(ScreenUnInfCnt+UnInfScreenCnt))*100,"",2)_"%" 	//特异度
   
    //假阴性率 假阳性率
    Set (FNRRatio,FPRRatio)="0.00%"
    Set:TPRRatio>0 FNRRatio =$fn((100-TPRRatio),"",2)_"%"
    Set:TNRRatio>0 FPRRatio =$fn((100-TNRRatio),"",2)_"%"
    //F1值
    Set F1Value=0
	Set:(TPRRatio+PPVRatio)>0 F1Value =(2*TPRRatio*PPVRatio)/((TPRRatio+PPVRatio)*100)    //百分比之间转化需乘以100
	Set:(F1Value>0)&(F1Value[".") F1Value =$fn(F1Value,"",2)

	Set Data=$lb("","","","综合指标","",PatientCnt,InfRepCnt,InfRepRatio,ScreeningCnt,ScreenRatio,DiagnosCnt,DiagRatio,ExcludeCnt,ExcRatio)
	Set Data=Data_$lb(RepUnScreenCnt,UnInfScreenCnt,InfScreenCnt,ScreenUnInfCnt,ACCRatio,PPVRatio,NPVRatio,TPRRatio,TNRRatio,FNRRatio,FPRRatio,F1Value)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1	
	
	//各指标
	Set xRuleNo = ""
	For {
		Set xRuleNo = $o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleNo",xRuleNo))
		Quit:xRuleNo=""
		
		Set xRuleID = ""
		For {
			Set xRuleID = $o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleNo",xRuleNo,xRuleID))
			Quit:xRuleID=""
			
		    Set InfSuRule=$g(^DHCHAI.IR.CRuleInfSuRuleD(xRuleID))
		    Continue:InfSuRule=""
		    Set RuleNo =$lg(InfSuRule,2)
		    Set ItmScreenDr =$lg(InfSuRule,3)
		    Set RuleType =$lg(InfSuRule,5)
		    Set RuleNote =$lg(InfSuRule,6)
		    Set IsActive =$lg(InfSuRule,7)
			Continue:(IsActive'=1)		
	
			//感染非疑似病例-->假阴性(FN)
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^TMP($zn,$j,"ScreenRate-Cnt","InfRepList",xEpisodeID))
				Quit:xEpisodeID=""
				
				If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","ScreeningList",xRuleID,xEpisodeID))) {
					If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","FN",xRuleID,xEpisodeID))) {    
			   		 	Set ^TMP($zn,$j,"ScreenRate-Cnt","FN",xRuleID,xEpisodeID)=""
			    		Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","FN",xRuleID))
		   			 }
				}				
			}
		  
			Set (ScreeningCnt,ScreenOperCnt,DiagnosCnt,ExcludeCnt,RepUnScreenCnt,UnInfScreenCnt,InfScreenCnt,ScreenUnInfCnt)=0
			Set ScreeningCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","ScreeningCnt",xRuleID))    //疑似人数
			Set DiagnosCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","DiagnosCnt",xRuleID))        //确诊人数
			Set ExcludeCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","ExcludeCnt",xRuleID))        //排除人数
			Set RepUnScreenCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","FN",xRuleID))         //感染非疑似病例 假阴性（FN）
			Set InfScreenCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","TP",xRuleID))           //感染疑似病例 真阳性（TP）
			Set ScreenUnInfCnt=+$g(^TMP($zn,$j,"ScreenRate-Cnt","FP",xRuleID))         //疑似非感染病例 假阳性（FP）
			Set UnInfScreenCnt=(PatientCnt-InfRepCnt-ScreenUnInfCnt)  //非感染疑似人数=全部患者-感染患者-疑似非感染患者 真阴性（TN）

			//w !,xRuleID," ",PatientCnt," ",InfRepCnt," ",ScreeningCnt," ",ScreenOperCnt," ",DiagnosCnt," ",ExcludeCnt," ",RepUnScreenCnt," ",UnInfScreenCnt," ",InfScreenCnt," ",ScreenUnInfCnt
		    //感染率 疑似率 确诊率 排除率 
		    Set (InfRepRatio,ScreenRatio,DiagRatio,ExcRatio)="0.00%"
			Set:(PatientCnt)>0 InfRepRatio=$fn((InfRepCnt/PatientCnt)*100,"",2)_"%" 	//感染率
			Set:(PatientCnt)>0 ScreenRatio=$fn((ScreeningCnt/PatientCnt)*100,"",2)_"%" 	//疑似率
			Set:(ScreeningCnt)>0 DiagRatio=$fn((DiagnosCnt/ScreeningCnt)*100,"",2)_"%" 	//确诊率
			Set:(ScreeningCnt)>0 ExcRatio=$fn((ExcludeCnt/ScreeningCnt)*100,"",2)_"%" 	//排除率 
		   
		    //准确率 阳性预测值 阴性预测值
		    Set (ACCRatio,PPVRatio,NPVRatio)="0.00%"
            Set:((PatientCnt)>0)&((InfScreenCnt+UnInfScreenCnt)>0) ACCRatio=$fn(((InfScreenCnt+UnInfScreenCnt)/PatientCnt)*100,"",2)_"%" 	//准确率
            Set:(ScreeningCnt)>0 PPVRatio=$fn(((InfScreenCnt)/ScreeningCnt)*100,"",2)_"%" 	        //阳性预测值
            Set:(RepUnScreenCnt+RepUnScreenCnt)>0 NPVRatio=$fn((UnInfScreenCnt/(RepUnScreenCnt+UnInfScreenCnt))*100,"",2)_"%" 	//阴性预测值
	    
		    //灵敏度(真阳率) 特异度(真阴率) 
		    Set (TPRRatio,TNRRatio)="0.00%"
            Set:(RepUnScreenCnt+InfScreenCnt)>0 TPRRatio=$fn((InfScreenCnt/(RepUnScreenCnt+InfScreenCnt))*100,"",2)_"%" 	//灵敏度 召回率
            Set:((ScreenUnInfCnt+UnInfScreenCnt)>0)&(UnInfScreenCnt>0) TNRRatio=$fn((UnInfScreenCnt/(ScreenUnInfCnt+UnInfScreenCnt))*100,"",2)_"%" 	//特异度
		   
		    //假阴性率 假阳性率
		    Set (FNRRatio,FPRRatio)="0.00%"
		    Set:TPRRatio>0 FNRRatio =$fn((100-TPRRatio),"",2)_"%"
		    Set:TNRRatio>0 FPRRatio =$fn((100-TNRRatio),"",2)_"%"
		    //F1值
		    Set F1Value=0
			Set:(TPRRatio+PPVRatio)>0 F1Value =(2*TPRRatio*PPVRatio)/((TPRRatio+PPVRatio)*100)    //百分比之间转化需乘以100
			Set:(F1Value>0)&(F1Value[".") F1Value =$fn(F1Value,"",2)
				
			Set Data=$lb(xRuleID,RuleNo,RuleType,RuleNote,ItmScreenDr,PatientCnt,InfRepCnt,InfRepRatio,ScreeningCnt,ScreenRatio,DiagnosCnt,DiagRatio,ExcludeCnt,ExcRatio)
			Set Data=Data_$lb(RepUnScreenCnt,UnInfScreenCnt,InfScreenCnt,ScreenUnInfCnt,ACCRatio,PPVRatio,NPVRatio,TPRRatio,TNRRatio,FNRRatio,FPRRatio,F1Value)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
	   	}
	 }
	 Kill ^TMP($zn,$j,"ScreenRate-Cnt")
	 Kill ^TMP($zn,$j,"SuRuleResult")
	 Quit $$$OK
	 
BuildSuRulePat(aEpisodeID,aDateFrom,aDateTo)
   
	//在院、出院患者人数
	Set ^TMP($zn,$j,"ScreenRate-Cnt","PatientList",aEpisodeID)=""      //住院病例
	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","PatientCnt"))      

	//感染人数
	Set IsReport=##class(DHCHAI.AMC.CSAssessTask).CheckIsReport(aEpisodeID,aDateFrom,aDateTo)
	If (IsReport=1) {
		Set ^TMP($zn,$j,"ScreenRate-Cnt","InfRepList",aEpisodeID)=""      //报告病例
		Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","InfRepCnt"))      
	}
	
    Set ResultID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,aEpisodeID,0))
    If (ResultID'="") {    //疑似、感染病例
	    Set ResultData=$g(^DHCHAI.AM.AssessResultD(ResultID))
	    Quit:ResultData=""    
	    Set IsActive   =$lg(ResultData,4)
	    Quit:IsActive'=1
	    Set SuMatrix   =$lg(ResultData,14)
	    Set SuRuleDtls =$lg(ResultData,15)
	    For indSu = 1:1:$l(SuRuleDtls,",") {    //各指标情况
		    Set SuRuleDtl=$p(SuRuleDtls,",",indSu)
		    Continue:SuRuleDtl=""
		    
		    Set SuRuleID   =$p(SuRuleDtl,"-",1)
		    Set SuRuleOpr  =$p(SuRuleDtl,"-",2)
		    
		    If (SuRuleID'="") {	 
				If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","AllScreeningList",aEpisodeID))) {
	                Set ^TMP($zn,$j,"ScreenRate-Cnt","AllScreeningList",aEpisodeID)=""           //疑似病例
	            	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","AllScreeningCnt"))      
	            } 
	            
	            If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","ScreeningList",SuRuleID,aEpisodeID))) {
	                Set ^TMP($zn,$j,"ScreenRate-Cnt","ScreeningList",SuRuleID,aEpisodeID)=""     //疑似病例
	            	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","ScreeningCnt",SuRuleID))      
	            } 
	            
			    If ('$d(^TMP($zn,$j,"ScreenRate-Cnt",SuMatrix,SuRuleID,aEpisodeID))) {        //单个疑似指标
		        	Set ^TMP($zn,$j,"ScreenRate-Cnt",SuMatrix,SuRuleID,aEpisodeID)=""      
		        	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt",SuMatrix,SuRuleID))             
		   	 	}  
		    }
	   	 	If (SuRuleOpr=1) {  //确诊
		   	 	Set ^TMP($zn,$j,"ScreenRate-Cnt","AllDiagnosList",aEpisodeID)=""  
		   	 	
		   	 	If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","DiagnosList",SuRuleID,aEpisodeID))) {
                	Set ^TMP($zn,$j,"ScreenRate-Cnt","DiagnosList",SuRuleID,aEpisodeID)=""      
                	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","DiagnosCnt",SuRuleID))           
           	 	}  
	   	 	}
	   	 	If (SuRuleOpr=2) {
		   	 	Set ^TMP($zn,$j,"ScreenRate-Cnt","AllExcludeList",aEpisodeID)=""
		   	 	
		   	 	If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","ExcludeList",SuRuleID,aEpisodeID))) {
                	Set ^TMP($zn,$j,"ScreenRate-Cnt","ExcludeList",SuRuleID,aEpisodeID)=""      
                	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","ExcludeCnt",SuRuleID))           
           	 	}  
	   	 	}
	    }
   	 	If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","All",SuMatrix,aEpisodeID))) {      //综合 感染疑似TP 感染非疑似FN 疑似非感染FP 
        	Set ^TMP($zn,$j,"ScreenRate-Cnt","All",SuMatrix,aEpisodeID)=""      
        	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","AllCnt",SuMatrix))             
   	 	}  
	    
    } Else {
	    If ('$d(^TMP($zn,$j,"ScreenRate-Cnt","All","TN",aEpisodeID))) {    //综合
        	Set ^TMP($zn,$j,"ScreenRate-Cnt","All","TN",aEpisodeID)=""      
        	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","AllCnt","TN"))             
   	 	}  
    }
    
    If ($d(^TMP($zn,$j,"ScreenRate-Cnt","AllDiagnosList",aEpisodeID))) { //确诊病例
		Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","AllDiagnosCnt"))
	}
    
    If ($d(^TMP($zn,$j,"ScreenRate-Cnt","AllExcludeList",aEpisodeID))) {  //排除病例
    	Set num=$i(^TMP($zn,$j,"ScreenRate-Cnt","AllExcludeCnt"))
    }
	Quit
}

ClassMethod QrySuRuleRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleRateExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-07-27
/// Description:  统计疑似筛查指标准确性相关明细（指标维度）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
///               AdmStatus：统计类型
///               aType：类别
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.AMS.ScreenResultSrv","QrySuRuleRateDtl","1|2|3","2020-07-01","2020-07-31","A","1","6")
Query QrySuRuleRateDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aRuleID As %String = "", aType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,InfRepList:%String,SusResult:%String,RuleOprDtl:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleRateDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aRuleID As %String = "", aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Quit:(aDateFrom="")||(aDateTo="")||(aAdmStatus="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

 	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
    Set ModelID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"),0))
    Quit:ModelID="" $$$OK
 	
	Kill ^TMP($zn,$j,"SuRuleRateDtl")

	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	Set arrCount=arrEpisodeDr.Count()
	For indEpis=1:1:arrCount {
		Set xPaadm=arrEpisodeDr.GetAt(indEpis)
		Continue:xPaadm=""
	  
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
		Continue:(PAAdmData="")
		Set AdmType = $lg(PAAdmData,18)
		Continue:(AdmType'["I")&&(AdmType'["EP")
		Set VisitStatus = $lg(PAAdmData,19)
		Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U")  //预住院P、在院A、出院D、退院C、作废U
        Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
		If aAdmStatus="D" {	//出院
			Continue:VisitStatus'="D"
			Continue:DischDate=""
			Continue:(DischDate<aDateFrom)||(DischDate>aDateTo)
		} Else {	//在院 当前在院改为某段时间在院		
			Continue:AdmitDate=""
			Continue:(AdmitDate>aDateTo)
			Continue:(DischDate'="")&&(DischDate<aDateFrom)
		}
        //院区过滤
        Set AdmLocID =$lg(PAAdmData,22)  
		Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocID))
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
		
		Set DateFrom =aDateFrom
	    Set DateTo =aDateTo
	    If (aAdmStatus="D") {
		    Set DateFrom =AdmitDate
	   		Set DateTo =DischDate
	    }
		Do BuildSuRulePatDtl(xPaadm,DateFrom,DateTo,aType,aRuleID)
		
	}
	
	//zw ^TMP($zn,$j,"SuRuleRateDtl","PatListType"_aType)
    Set xEpisodeID=""
    For {
	    Set xEpisodeID=$o(^TMP($zn,$j,"SuRuleRateDtl","PatListType"_aType,xEpisodeID))
	    Quit:xEpisodeID=""
	    		
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeID))
		Continue:(PAAdmData="")
		 Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
		Set DateFrom =aDateFrom
	    Set DateTo =aDateTo
	    If (aAdmStatus="D") {
		    Set DateFrom =AdmitDate
	   		Set DateTo =DischDate
	    }
		Set AdmData=..BuildPaadmData(xEpisodeID)
		Continue:(AdmData="")
		
		Set InfRepList =..GetInfRepList(xEpisodeID,DateFrom,DateTo)
		Set SusResult ="",SuMatrix="",RuleOprDtl=""    //疑似筛查结果
		Set AssResuID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeID,0))
		If (AssResuID'="") {
			Set AssResultData=$g(^DHCHAI.AM.AssessResultD(AssResuID))
			Continue:ResultData=""    
			Set IsActive   =$lg(ResultData,4)
		    Continue:IsActive'=1
		    Set ARStatus  =$lg(ResultData,8)
		    Set SuMatrix   =$lg(ResultData,14)
			Set SusResult=$lg(AssResultData,6)
		}
		If (SuMatrix="TP")||(SuMatrix="FP") {
			Set RuleOprDtl=..GetSuRuleOprDtl(xEpisodeID,aRuleID,DateFrom,DateTo)
		}		
		Set Data = AdmData_$lb(InfRepList,SusResult,RuleOprDtl)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }

	 Kill ^TMP($zn,$j,"SuRuleRateDtl")
	 Quit $$$OK
	 
BuildSuRulePatDtl(aEpisodeID,aDateFrom,aDateTo,aType,aRuleID)
    
	//在院、出院患者人数
	Set ^TMP($zn,$j,"SuRuleRateDtl","PatListType1",aEpisodeID)=""      //住院病例
	//感染人数
	Set IsReport=##class(DHCHAI.AMC.CSAssessTask).CheckIsReport(aEpisodeID,DateFrom,DateTo)
	If (IsReport=1) {
		Set ^TMP($zn,$j,"SuRuleRateDtl","PatListType2",aEpisodeID)=""      //报告病例
	}
	
    Set ResultID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,aEpisodeID,0))
    If (ResultID'="") {    //疑似、感染病例
	    Set ResultData=$g(^DHCHAI.AM.AssessResultD(ResultID))
	    Quit:ResultData=""    
	    Set IsActive   =$lg(ResultData,4)
	    Quit:IsActive'=1
	    Set SuMatrix   =$lg(ResultData,14)
	    Set SuRuleDtls =$lg(ResultData,15)
	    For indSu = 1:1:$l(SuRuleDtls,",") {    //各指标情况
		    Set SuRuleDtl=$p(SuRuleDtls,",",indSu)
		    Continue:SuRuleDtl=""
		    
		    Set SuRuleID   =$p(SuRuleDtl,"-",1)
		    Set SuRuleOpr  =$p(SuRuleDtl,"-",2)
		    If (aRuleID'="") {
				Continue:(aRuleID'=SuRuleID)
		   	 	Set:(SuRuleOpr=1) ^TMP($zn,$j,"SuRuleRateDtl","PatListType4",aEpisodeID)=""  
		   	 	Set:(SuRuleOpr=2) ^TMP($zn,$j,"SuRuleRateDtl","PatListType5",aEpisodeID)=""
		   	 	
		   	 	Set:(SuMatrix="TP")||(SuMatrix="FP") ^TMP($zn,$j,"SuRuleRateDtl","PatListType3",aEpisodeID)=""     //疑似患者
			    Set:(SuMatrix="TP") ^TMP($zn,$j,"SuRuleRateDtl","PatListType6",aEpisodeID)=""     //感染疑似患者
		   	 	Set:(SuMatrix="FP") ^TMP($zn,$j,"SuRuleRateDtl","PatListType8",aEpisodeID)=""     //疑似非感染患者	  
		   	 	
		    }Else {
		   	 	Set:(SuRuleOpr=1) ^TMP($zn,$j,"SuRuleRateDtl","PatListType4",aEpisodeID)=""  
		   	 	Set:(SuRuleOpr=2) ^TMP($zn,$j,"SuRuleRateDtl","PatListType5",aEpisodeID)=""
		    }
	    }
	    If (aRuleID="") {
	    	Set:(SuMatrix="TP")||(SuMatrix="FP") ^TMP($zn,$j,"SuRuleRateDtl","PatListType3",aEpisodeID)=""     //疑似患者
	   	 	Set:(SuMatrix="TP") ^TMP($zn,$j,"SuRuleRateDtl","PatListType6",aEpisodeID)=""     //感染疑似患者
	   	 	Set:(SuMatrix="FP") ^TMP($zn,$j,"SuRuleRateDtl","PatListType8",aEpisodeID)=""     //疑似非感染患者	  
	    } 
	   	If ($d(^TMP($zn,$j,"SuRuleRateDtl","PatListType2",aEpisodeID)))&
			('$d(^TMP($zn,$j,"SuRuleRateDtl","PatListType6",aEpisodeID))) {
				Set ^TMP($zn,$j,"SuRuleRateDtl","PatListType7",aEpisodeID)=""     //感染非疑似患者
		}
 
    } 
    If ('$d(^TMP($zn,$j,"SuRuleRateDtl","PatListType6",aEpisodeID)))&
    	('$d(^TMP($zn,$j,"SuRuleRateDtl","PatListType7",aEpisodeID)))&
    	('$d(^TMP($zn,$j,"SuRuleRateDtl","PatListType8",aEpisodeID))) {
		Set ^TMP($zn,$j,"SuRuleRateDtl","PatListType9",aEpisodeID)=""  //非疑似感染患者
    }
   

	Quit
}

ClassMethod QrySuRuleRateDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleRateDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleRateDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleRateDtlExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-08-04
/// Description:  统计疑似筛查指标准确性（科室维度）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
///               aAdmStatus：统计类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.AMS.ScreenResultSrv","QryLocScreenRate","1|2|3","2020-08-01","2020-08-31","A")
Query QryLocScreenRate(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,HospID:%String,HospDesc:%String,PatCnt:%Integer,InfPatCnt:%Integer,InfPatRatio:%String,InfRepCnt:%Integer,InfRepRatio:%String,ScreenPatCnt:%Integer,ScreenRatio:%String,DiagnosCnt:%Integer,DiagRatio:%String,ExcludeCnt:%Integer,ExcRatio:%String,UnOperCnt:%Integer,UnOperRatio:%String") [ SqlProc ]
{
}

ClassMethod QryLocScreenRateExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	
 	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
    Set ModelID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"),0))
    Quit:ModelID="" $$$OK
    
	Kill ^TMP($zn,$j,"ScreenLoc-Cnt")

	If (aAdmStatus="A") {  //同期住院
		Set ListLocArray=##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate(aDateFrom,aDateTo,"E","","I|EP")
	    For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)
			Continue:TransInfo=""
			Set Paadm      = $LIST(TransInfo,1)
			Set LocID      = $LIST(TransInfo,2)
			Set TransType  = $LIST(TransInfo,3)
			Set TransDates = $LIST(TransInfo,4)
			Set LnkLocDr   = $LIST(TransInfo,5)
			Set TransIDs   = $LIST(TransInfo,6)
			Continue:LocID=""  
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set HospDr=$lg(LocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
			
			Do BuildLocPat(Paadm,HospDr,LocID)
		}
	}Else {  //出院患者
	  	Set xAdmType = ""
	    For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&&(xAdmType'="EP")	
			For xDishDate = aDateFrom:1:aDateTo{
				Set xDishTime = ""
				For {
					Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
					Quit:xDishTime=""
					
					Set xPaadm = ""
					For {
						Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
						Quit:xPaadm=""
						
						Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
						Continue:(PAAdmData="")

					    //院区过滤
					    Set DishLocID = $lg(PAAdmData,28)
						Set LocData = $g(^DHCHAI.BT.LocationD(DishLocID))
						Set HospDr=$lg(LocData,8)
						Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
						
						Do BuildLocPat(xPaadm,HospDr,DishLocID)
					}
				}
			}
	    }			
	}
  
	Set xHospID=0
	For {
		Set xHospID=$o(^TMP($zn,$j,"ScreenLoc-Cnt","HsopLocList",xHospID))
		Quit:xHospID=""
		
		Set HospPatCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","HospPatCnt",xHospID))                   //住院人数
		Set HospInfPatCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","HospInfPatCnt",xHospID))             //感染人数
		Set HospInfRepCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","HospInfRepCnt",xHospID))             //感染例次数
		Set HospScreenPatCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","HospScreenPatCnt",xHospID))       //疑似人数
		Set HospDiagnosCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","HospDiagnosCnt",xHospID))           //确诊人数
		Set HospExcludeCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","HospExcludeCnt",xHospID))           //排除人数
		Set HospUnOperCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","HospUnOperCnt",xHospID))             //未处置人数
		
		
		//感染率 疑似率 确诊率 排除率 
		Set (InfRepRatio,ScreenRatio,DiagRatio,ExcRatio,UnOperRatio)="0.00%"
		Set (InfPatRatio,InfRepRatio,ScreenRatio,DiagRatio,ExcRatio)="0.00%"
		Set:(HospPatCnt)>0 InfPatRatio=$fn((HospInfPatCnt/HospPatCnt)*100,"",2)_"%" 	         //感染率
		Set:(HospInfRepCnt)>0 InfRepRatio=$fn((HospInfRepCnt/HospPatCnt)*100,"",2)_"%" 	         //感染例次率
		Set:(HospPatCnt)>0 ScreenRatio=$fn((HospScreenPatCnt/HospPatCnt)*100,"",2)_"%" 	         //疑似率
		Set:(HospScreenPatCnt)>0 DiagRatio=$fn((HospDiagnosCnt/HospScreenPatCnt)*100,"",2)_"%"   //确诊率
		Set:(HospScreenPatCnt)>0 ExcRatio=$fn((HospExcludeCnt/HospScreenPatCnt)*100,"",2)_"%" 	 //排除率     
		Set:(HospScreenPatCnt)>0 UnOperRatio=$fn((HospUnOperCnt/HospScreenPatCnt)*100,"",2)_"%"  //未处置率
		Set HospData =$g(^DHCHAI.BT.HospitalD(xHospID))
		Set HospDesc =$lg(HospData,3)

		Set Data=$lb("",HospDesc,xHospID,HospDesc,HospPatCnt,HospInfPatCnt,InfPatRatio,HospInfRepCnt,InfRepRatio,HospScreenPatCnt,ScreenRatio,HospDiagnosCnt,DiagRatio,HospExcludeCnt,ExcRatio,HospUnOperCnt,UnOperRatio)
	 	Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
		
		
		Set xLocID=0
		For {
			Set xLocID=$o(^TMP($zn,$j,"ScreenLoc-Cnt","HsopLocList",xHospID,xLocID))
			Quit:xLocID=""
			
			Set Location=$g(^DHCHAI.BT.LocationD(xLocID))
			Set LocDesc=$lg(Location,3)
			
			Set ScreenPatCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocScreenPatCnt",xHospID,xLocID))       //疑似人数
			Set UnOperCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocUnOperCnt",xHospID,xLocID))             //未处置人数
			
			Set (UnOperRatio)=0
			Set:(ScreenPatCnt)>0 UnOperRatio=$fn((UnOperCnt/ScreenPatCnt),"",4)      //未处置率   用于默认排序（只针对科室）
            
            Set ^TMP($zn,$j,"ScreenLoc-Cnt","UnOperOrder",UnOperRatio,xLocID)=""
		}
    
        Set xRatio=""
        For {
	        Set xRatio= $o(^TMP($zn,$j,"ScreenLoc-Cnt","UnOperOrder",xRatio),-1)   //默认降序排序（只针对科室）
	        Quit:xRatio=""
	        
			Set xLocID=""
			For {
				Set xLocID=$o(^TMP($zn,$j,"ScreenLoc-Cnt","UnOperOrder",xRatio,xLocID))
				Quit:xLocID=""
				
				Set Location=$g(^DHCHAI.BT.LocationD(xLocID))
				Set LocDesc=$lg(Location,3)
				
				Set PatCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocPatCnt",xHospID,xLocID))                   //在科人数
				Set InfPatCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocInfPatCnt",xHospID,xLocID))             //感染人数
				Set InfRepCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocInfRepCnt",xHospID,xLocID))             //感染例次数
				Set ScreenPatCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocScreenPatCnt",xHospID,xLocID))       //疑似人数
				Set DiagnosCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocDiagnosCnt",xHospID,xLocID))           //确诊人数
				Set ExcludeCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocExcludeCnt",xHospID,xLocID))           //排除人数
				Set UnOperCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt","LocUnOperCnt",xHospID,xLocID))             //未处置人数
			
			    //感染率 感染例次率 疑似率 确诊率 排除率 
			    Set (InfPatRatio,InfRepRatio,ScreenRatio,DiagRatio,ExcRatio,UnOperRatio)="0.00%"
				Set:(PatCnt)>0 InfPatRatio=$fn((InfPatCnt/PatCnt)*100,"",2)_"%" 	             //感染率
				Set:(PatCnt)>0 InfRepRatio=$fn((InfRepCnt/PatCnt)*100,"",2)_"%" 	             //感染例次率
				Set:(PatCnt)>0 ScreenRatio=$fn((ScreenPatCnt/PatCnt)*100,"",2)_"%" 	             //疑似率
				Set:(ScreenPatCnt)>0 DiagRatio=$fn((DiagnosCnt/ScreenPatCnt)*100,"",2)_"%"       //确诊率
				Set:(ScreenPatCnt)>0 ExcRatio=$fn((ExcludeCnt/ScreenPatCnt)*100,"",2)_"%" 	     //排除率 
				Set:(ScreenPatCnt)>0 UnOperRatio=$fn((UnOperCnt/ScreenPatCnt)*100,"",2)_"%"      //未处置率
				
				Set Data=$lb(xLocID,LocDesc,xHospID,HospDesc,PatCnt,InfPatCnt,InfPatRatio,InfRepCnt,InfRepRatio,ScreenPatCnt,ScreenRatio,DiagnosCnt,DiagRatio,ExcludeCnt,ExcRatio,UnOperCnt,UnOperRatio)
			 	Set ^CacheTemp(repid,ind)=Data
			 	Set ind=ind+1
		   	}
        }
	 }
	
	Kill ^TMP($zn,$j,"ScreenLoc-Cnt")
	Quit $$$OK
	 
BuildLocPat(aEpisodeID,aHospID,aLocID)
    
    Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:(PAAdmData="")
    Set AdmitDate =$lg(PAAdmData,20)
    Set DischDate =$lg(PAAdmData,26)
    Set DateFrom =aDateFrom
    Set DateTo =aDateTo
    If (aAdmStatus="D") {    //出院统计
	    Set DateFrom =AdmitDate
   		Set DateTo =DischDate
    }
	
	Set ^TMP($zn,$j,"ScreenLoc-Cnt","HsopLocList",aHospID,aLocID)=""       //科室信息	
	If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","HospPat",aHospID,aEpisodeID))) {
        Set ^TMP($zn,$j,"ScreenLoc-Cnt","HospPat",aHospID,aEpisodeID)=""        //住院病例
        Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","HospPatCnt",aHospID))      
    }
	
	Set ^TMP($zn,$j,"ScreenLoc-Cnt","LocPat",aHospID,aLocID,aEpisodeID)="" //住院病例
	Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","LocPatCnt",aHospID,aLocID))        

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
		Set RepStatus=$lg(StatusDic,2)
		Continue:(RepStatus=4)  //4作废
      
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
			Continue:(InfDate<DateFrom)
			Continue:(InfDate>DateTo)
            If (aAdmStatus="A") {
		    	Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
				Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
				Continue:(aLocID'="")&(InfLocDr'=aLocID)
			}
						
			If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","HospInfPat",aHospID,aEpisodeID))) {
		        Set ^TMP($zn,$j,"ScreenLoc-Cnt","HospInfPat",aHospID,aEpisodeID)=""        //感染报告病例
		        Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","HospInfPatCnt",aHospID))      
		    }
		    Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","HospInfRepCnt",aHospID))     //感染例次
		    
		    
		    If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","LocInfPat",aHospID,aLocID,aEpisodeID))) {
		        Set ^TMP($zn,$j,"ScreenLoc-Cnt","LocInfPat",aHospID,aLocID,aEpisodeID)=""    //感染报告病例
		        Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","LocInfPatCnt",aHospID,aLocID))      
		    }
		    Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","LocInfRepCnt",aHospID,aLocID))     //感染例次
		}
	}
	
	//评估结果
	Set ARStatus="",SuMatrix=""
	Set ResultID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,aEpisodeID,0))
    If (ResultID'="") {    //疑似、感染病例
	    Set ResultData=$g(^DHCHAI.AM.AssessResultD(ResultID))
	    Quit:ResultData=""    
	    Set IsActive   =$lg(ResultData,4)
	    Quit:IsActive'=1
	    Set ARStatus  =$lg(ResultData,8)
	    Set SuMatrix   =$lg(ResultData,14)
    }
    Set:SuMatrix="" SuMatrix="TN"   
 	If ('$d(^TMP($zn,$j,"SuRuleRateDtl",SuMatrix,aEpisodeID))) {      //综合 感染疑似TP 感染非疑似FN 疑似非感染FP 
    	Set ^TMP($zn,$j,"SuRuleRateDtl",SuMatrix,aEpisodeID)=""      
 	}  
	    
	If (SuMatrix="TP")||(SuMatrix="FP") {
 	    If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","HospScreenPat",aHospID,aEpisodeID))) {
	        Set ^TMP($zn,$j,"ScreenLoc-Cnt","HospScreenPat",aHospID,aEpisodeID)=""        //疑似病例
	        Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","HospScreenPatCnt",aHospID))      
	    }
	    
	    If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","LocScreenPat",aHospID,aLocID,aEpisodeID))) {
	        Set ^TMP($zn,$j,"ScreenLoc-Cnt","LocScreenPat",aHospID,aLocID,aEpisodeID)=""    //疑似病例
	        Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","LocScreenPatCnt",aHospID,aLocID))      
	    }		    
    }
    
    Set OprStatus=""
    Set xScreenID = ""
	For {
		Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
		Quit:xScreenID=""
		
		Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
		Continue:ScreenData=""
		Set RstFromDate=$lg(ScreenData,7)   //处置结果开始日期
	    Set RstToDate=$lg(ScreenData,8)     //处置结束开始日期
	    Continue:(DateFrom'="")&(RstToDate<DateFrom)     
	    Continue:(DateTo'="")&(RstFromDate>DateTo)

		Set xSubID = ""
	   	For {
	   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
	   		Quit:xSubID=""
   		
   		    Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
   		    Continue:ScreenDtl=""
   		    Set Status= $lg(ScreenDtl,2)
   		    Set:OprStatus'=1 OprStatus=Status
	   	}
		
	}
	If (SuMatrix="TP")||(SuMatrix="FP") {
		If (OprStatus=1) {
			If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","HospDiagnosPat",aHospID,aEpisodeID))) {
	            Set ^TMP($zn,$j,"ScreenLoc-Cnt","HospDiagnosPat",aHospID,aEpisodeID)=""      //确诊病例
	            Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","HospDiagnosCnt",aHospID))      
	        }
	        
	        If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","LocDiagnosPat",aHospID,aLocID,aEpisodeID))) {
	            Set ^TMP($zn,$j,"ScreenLoc-Cnt","LocDiagnosPat",aHospID,aLocID,aEpisodeID)=""      //确诊病例
	            Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","LocDiagnosCnt",aHospID,aLocID))      
	        }
		}
		If (OprStatus=2) {
	        If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","HospExcludePat",aHospID,aEpisodeID))) {
	            Set ^TMP($zn,$j,"ScreenLoc-Cnt","HospExcludePat",aHospID,aEpisodeID)=""      //排除病例
	            Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","HospExcludeCnt",aHospID))      
	        }
	        
	        If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","LocExcludePat",aHospID,aLocID,aEpisodeID))) {
	            Set ^TMP($zn,$j,"ScreenLoc-Cnt","LocExcludePat",aHospID,aLocID,aEpisodeID)=""      //排除病例
	            Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","LocExcludeCnt",aHospID,aLocID))      
	        }
		}
		If (OprStatus="") {
			If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","HospUnOperPat",aHospID,aEpisodeID))) {
	            Set ^TMP($zn,$j,"ScreenLoc-Cnt","HospUnOperPat",aHospID,aEpisodeID)=""      //未处置病例
	            Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","HospUnOperCnt",aHospID))      
	        }
	        
	        If ('$d(^TMP($zn,$j,"ScreenLoc-Cnt","LocUnOperPat",aHospID,aLocID,aEpisodeID))) {
	            Set ^TMP($zn,$j,"ScreenLoc-Cnt","LocUnOperPat",aHospID,aLocID,aEpisodeID)=""      //未处置病例
	            Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt","LocUnOperCnt",aHospID,aLocID))      
	        }
		}
	}
	Quit
}

ClassMethod QryLocScreenRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocScreenRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocScreenRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocScreenRateExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-08-15
/// Description:  统计科室疑似筛查结果明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
///               aAdmStatus：统计类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.AMS.ScreenResultSrv","QryLocScreenDtl","1|2|3","2020-07-01","2020-07-31","D","38","3")
Query QryLocScreenDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aLocID As %String = "", aType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,InfRepList:%String,SusResult:%String,RuleOprDtl:%String") [ SqlProc ]
{
}

ClassMethod QryLocScreenDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aLocID As %String = "", aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	
 	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
    Set ModelID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"),0))
    Quit:ModelID="" $$$OK
    
	Kill ^TMP($zn,$j,"LocScreenDtl")

	If (aAdmStatus="A") {  //同期住院
		Set ListLocArray=##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate(aDateFrom,aDateTo,"E",aLocID,"I|EP")
	    For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)
			Continue:TransInfo=""
			Set Paadm      = $LIST(TransInfo,1)
			Set LocID      = $LIST(TransInfo,2)
			Set TransType  = $LIST(TransInfo,3)
			Set TransDates = $LIST(TransInfo,4)
			Set LnkLocDr   = $LIST(TransInfo,5)
			Set TransIDs   = $LIST(TransInfo,6)
			Continue:LocID=""  
			Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
			Set HospDr=$lg(LocData,8)
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		
			Do BuildLocPatDtl(Paadm,aDateFrom,aDateTo,aType)
		}
	}Else {  //出院患者
	  	Set xAdmType = ""
	    For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&&(xAdmType'="EP")	
			For xDishDate = aDateFrom:1:aDateTo{
				Set xDishTime = ""
				For {
					Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
					Quit:xDishTime=""
					
					Set xPaadm = ""
					For {
						Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
						Quit:xPaadm=""
						
						Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
						Continue:(PAAdmData="")

					    //院区过滤
					    Set DishLocID = $lg(PAAdmData,28)
					    Continue:(aLocID'="")&(aLocID'=DishLocID)
						Set LocData = $g(^DHCHAI.BT.LocationD(DishLocID))
						Set HospDr=$lg(LocData,8)
						Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
						
						Set AdmDate = $li(PAAdmData,20)
	   					Set DischDate = $li(PAAdmData,26)
						Do BuildLocPatDtl(xPaadm,AdmDate,DischDate,aType)
					}
				}
			}
	    }			
	}
  
	//zw ^TMP($zn,$j,"LocScreenDtl","PatListType"_aType)
    Set xEpisodeID=""
    For {
	    Set xEpisodeID=$o(^TMP($zn,$j,"LocScreenDtl","PatListType"_aType,xEpisodeID))
	    Quit:xEpisodeID=""
	    	    		
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeID))
		Continue:(PAAdmData="")
		Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
		Set DateFrom =aDateFrom
	    Set DateTo =aDateTo
	    If (aAdmStatus="D") {
		    Set DateFrom =AdmitDate
	   		Set DateTo =DischDate
	    }
		Set AdmData=..BuildPaadmData(xEpisodeID)
		Continue:(AdmData="")
		Set InfRepList =..GetInfRepList(xEpisodeID,DateFrom,DateTo)
		Set SusResult ="",SuMatrix="",RuleOprDtl=""    //疑似筛查结果
		Set AssResuID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeID,0))
		If (AssResuID'="") {
			Set AssResultData=$g(^DHCHAI.AM.AssessResultD(AssResuID))
			Continue:ResultData=""    
			Set IsActive   =$lg(ResultData,4)
		    Continue:IsActive'=1
		    Set ARStatus  =$lg(ResultData,8)
		    Set SuMatrix   =$lg(ResultData,14)
			Set SusResult=$lg(AssResultData,6)
		}
		If (SuMatrix="TP")||(SuMatrix="FP") {
			Set RuleOprDtl=..GetSuRuleOprDtl(xEpisodeID,"",DateFrom,DateTo)
		}		

		Set Data = AdmData_$lb(InfRepList,SusResult,RuleOprDtl)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }

	 Kill ^TMP($zn,$j,"LocScreenDtl")
	
	 Quit $$$OK
	 
BuildLocPatDtl(aEpisodeID,aDateFrom,aDateTo,aType)
    
   	//在院、出院患者人数
	Set ^TMP($zn,$j,"LocScreenDtl","PatListType1",aEpisodeID)=""      //住院病例
	//感染人数
	Set IsReport=0
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,1,xRepID))
		Quit:xRepID=""
		Quit:IsReport=1
		Set InfRepData=$g(^DHCHAI.IR.INFReportD(xRepID))
		Continue:InfRepData=""
		Set StatusDr = $lg(InfRepData,8)
		Continue:StatusDr=""
		Set StatusDic = $g(^DHCHAI.BT.DictionaryD(StatusDr))
		Continue:StatusDic=""
		Set RepStatus=$lg(StatusDic,2)
		Continue:(RepStatus=4)  //4作废
      
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
			Continue:(InfDate<aDateFrom)
			Continue:(InfDate>aDateTo)
            If (aAdmStatus="A") {
		    	Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
				Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
				Continue:(aLocID'="")&(InfLocDr'=aLocID)
			}
			Set IsReport=1
			Quit
		}
	}
	If (IsReport=1) {
		Set ^TMP($zn,$j,"LocScreenDtl","PatListType2",aEpisodeID)=""      //报告病例
	}
	
	
	Set ARStatus="",SuMatrix=""
	Set ResultID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,aEpisodeID,0))
    If (ResultID'="") {    //疑似、感染病例
	    Set ResultData=$g(^DHCHAI.AM.AssessResultD(ResultID))
	    Quit:ResultData=""    
	    Set IsActive   =$lg(ResultData,4)
	    Quit:IsActive'=1
	    Set ARStatus  =$lg(ResultData,8)
	    Set SuMatrix   =$lg(ResultData,14)
    }
	
 	Set OprStatus=""
    Set xScreenID = ""
	For {
		Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
		Quit:xScreenID=""
		
		Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
		Continue:ScreenData=""
		Set RstFromDate=$lg(ScreenData,7)   //处置结果开始日期
	    Set RstToDate=$lg(ScreenData,8)     //处置结束开始日期
	    Continue:(aDateFrom'="")&(RstToDate<aDateFrom)     
	    Continue:(aDateTo'="")&(RstFromDate>aDateTo)

		Set xSubID = ""
	   	For {
	   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
	   		Quit:xSubID=""
   		
   		    Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
   		    Continue:ScreenDtl=""
   		    Set Status= $lg(ScreenDtl,2)
   		    Set:OprStatus'=1 OprStatus=Status
	   	}

	}
	If (SuMatrix="TP")||(SuMatrix="FP") {
		Set ^TMP($zn,$j,"LocScreenDtl","PatListType3",aEpisodeID)=""    //疑似病例   
		If (OprStatus=1) {
			Set ^TMP($zn,$j,"LocScreenDtl","PatListType4",aEpisodeID)=""    //确诊病例   
		}
		If (OprStatus=2) {
	        Set ^TMP($zn,$j,"LocScreenDtl","PatListType5",aEpisodeID)=""    //排除病例  
		}
		If (OprStatus="") {
	        Set ^TMP($zn,$j,"LocScreenDtl","PatListType6",aEpisodeID)=""    //未处置病例  
		}
	}
    
	Quit
}

ClassMethod QryLocScreenDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocScreenDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocScreenDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocScreenDtlExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-08-18
/// Description:  统计疑似筛查指标准确性（感染诊断维度）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
///               AdmStatus：统计类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.AMS.ScreenResultSrv","QryDiagScreenRate","1|2|3","2020-08-01","2020-08-31","A")
Query QryDiagScreenRate(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %Query(ROWSPEC = "ID:%String,InfCode:%String,InfDiag:%String,InfPatCnt:%Integer,InfRepCnt:%Integer,ScreenPatCnt:%Integer,UnOperCnt:%Integer,DiagnosCnt:%Integer,ExcludeCnt:%Integer,InfUnScreenCnt:%Integer,InfScreenCnt:%Integer,DiagRatio:%String,ExcRatio:%String,TPRRatio:%String,FNRRatio:%String") [ SqlProc ]
{
}

ClassMethod QryDiagScreenRateExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Quit:(aDateFrom="")||(aDateTo="")||(aAdmStatus="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")

 	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
    Set ModelID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"),0))
    Quit:ModelID="" $$$OK
 	
	Kill ^TMP($zn,$j,"DiagScreen-Cnt")

	Set xPaadm=""
	For {
   	 	Set xPaadm=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xPaadm))
   	 	Quit:xPaadm=""
   	 	
   	 	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
		Continue:(PAAdmData="")
        Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
    	//院区过滤
        Set AdmLocID =$lg(PAAdmData,22)  
		Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocID))
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
    
    	Set DateFrom =aDateFrom
	    Set DateTo =aDateTo
	    If (aAdmStatus="D") {
		    Set DateFrom =AdmitDate
	   		Set DateTo =DischDate
	    }
    	Set ARStatus="",SuMatrix=""
   	 	Set xARID=""
   	 	For {
   	 		Set xARID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xPaadm,xARID))
   	 		Quit:xARID=""

   	 		Set ResultData=$g(^DHCHAI.AM.AssessResultD(xARID))
		    Continue:ResultData=""    
		    Set IsActive  =$lg(ResultData,4)
		    Continue:IsActive'=1
		    Set ARStatus  =$lg(ResultData,8)
		    Set SuMatrix  =$lg(ResultData,14)
		    
		    Set OprStatus=""
		    Set xScreenID = ""
			For {
				Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",xPaadm,xScreenID))
				Quit:xScreenID=""
	
				Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
				Continue:ScreenData=""
				Set RstFromDate=$lg(ScreenData,7)   //处置结果开始日期
			    Set RstToDate=$lg(ScreenData,8)     //处置结束开始日期
			    Continue:(DateFrom'="")&(RstToDate<DateFrom)     
			    Continue:(DateTo'="")&(RstFromDate>DateTo)

				Set xSubID = ""
			   	For {
			   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
			   		Quit:xSubID=""
		   		
		   		    Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
		   		    Continue:ScreenDtl=""
		   		    Set Status= $lg(ScreenDtl,2)
		   		    Set:OprStatus'=1 OprStatus=Status
			   	}
			}
		    
		    Set IsReport =0
		    If (SuMatrix="TP")||(SuMatrix="FN") {    
			   	Set xRepID=""
				For {
					Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,1,xRepID))
					Quit:xRepID=""
				
					Set InfRepData=$g(^DHCHAI.IR.INFReportD(xRepID))
					Continue:InfRepData=""
					Set StatusDr = $lg(InfRepData,8)
					Continue:StatusDr=""
					Set StatusDic = $g(^DHCHAI.BT.DictionaryD(StatusDr))
					Continue:StatusDic=""
					Set RepStatus=$lg(StatusDic,2)
					Continue:(RepStatus=4)  //4作废
			      
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
						Continue:(InfDate<DateFrom)
						Continue:(InfDate>DateTo)
						Set InfPosDr = $lg(DiagData,3)
			         	If ('$d(^TMP($zn,$j,"DiagScreen-Cnt","InfPat",xPaadm))) {
				         	Set ^TMP($zn,$j,"DiagScreen-Cnt","InfPat",xPaadm)=""        //感染报告病例
					        Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt","InfPatSum"))      
			         	}
			         	Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt","InfRepSum"))     //感染例次
			         				
						If ('$d(^TMP($zn,$j,"DiagScreen-Cnt","InfPosPat",InfPosDr,xPaadm))) {
					        Set ^TMP($zn,$j,"DiagScreen-Cnt","InfPosPat",InfPosDr,xPaadm)=""        //感染报告病例
					        Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt","InfPosPatCnt",InfPosDr))      
					    }
					    Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt","InfPosRepCnt",InfPosDr))     //感染例次
					    
					    
						If ('$d(^TMP($zn,$j,"DiagScreen-Cnt","InfTypePat",InfPosDr,SuMatrix,xPaadm))) {
					        Set ^TMP($zn,$j,"DiagScreen-Cnt","InfTypePat",InfPosDr,SuMatrix,xPaadm)=""      
					        Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt","InfTypeCnt",InfPosDr,SuMatrix))      
					    }
					    If (SuMatrix="TP") {
						    If (OprStatus'="") {
							    If ('$d(^TMP($zn,$j,"DiagScreen-Cnt","OprStatusPat",InfPosDr,OprStatus,xPaadm))) {
							        Set ^TMP($zn,$j,"DiagScreen-Cnt","OprStatusPat",InfPosDr,OprStatus,xPaadm)=""      
							        Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt","OprStatusCnt",InfPosDr,OprStatus))      
							    }
						    }Else {
							    If ('$d(^TMP($zn,$j,"DiagScreen-Cnt","OprStatusPat",InfPosDr,"-1",xPaadm))) {
							        Set ^TMP($zn,$j,"DiagScreen-Cnt","OprStatusPat",InfPosDr,"-1",xPaadm)=""      
							        Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt","OprStatusCnt",InfPosDr,"-1"))      
							    }
						    }
					    }
					   Set IsReport =1
					}
				}
			}			
			Set num=$i(^TMP($zn,$j,"DiagScreen-Cnt",SuMatrix))     
			If (IsReport =1)&(SuMatrix="TP") {				
				Set:OprStatus="" num=$i(^TMP($zn,$j,"DiagScreen-Cnt","DiagNone"))        //未处置人数
				Set:OprStatus=2 num=$i(^TMP($zn,$j,"DiagScreen-Cnt","DiagCancel"))       //排除人数
				Set:OprStatus=1 num=$i(^TMP($zn,$j,"DiagScreen-Cnt","Diagnosis"))        //确诊人数
			}
		}	    
	}
   
    //汇总
   	Set InfPatSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","InfPatSum"))	       //感染人数
	Set InfRepSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","InfRepSum"))           //感染例次数
	Set ScreenSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","TP"))	               //疑似人数(筛查评估中：感染疑似病例)
	Set UnOperSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","DiagNone"))            //未处置人数
	Set ExcludeSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","DiagCancel"))         //排除人数
	Set DiagnosSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","Diagnosis"))          //确诊人数
	Set InfUnScreenSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","FN"))             //感染非疑似病例 假阴性（FN）
	Set InfScreenSum=+$g(^TMP($zn,$j,"DiagScreen-Cnt","TP"))               //感染疑似病例   真阳性（TP）

    //确诊率 排除率 
    Set (DiagRatio,ExcRatio)="0.00%"
	Set:(ScreenSum)>0 DiagRatio=$fn((DiagnosSum/ScreenSum)*100,"",2)_"%" 	//确诊率
	Set:(ScreenSum)>0 ExcRatio=$fn((ExcludeSum/ScreenSum)*100,"",2)_"%" 	//排除率 
   
    //灵敏度(真阳率)
    Set (TPRRatio)="0.00%"
    Set:(InfUnScreenSum+InfScreenSum)>0 TPRRatio=$fn((InfScreenSum/(InfUnScreenSum+InfScreenSum))*100,"",2)_"%" 	//灵敏度 召回率
   
    //假阴性率
    Set (FNRRatio)="0.00%"
    Set:TPRRatio>0 FNRRatio =$fn((100-TPRRatio),"",2)_"%"

	Set Data=$lb("","","合计",InfPatSum,InfRepSum,ScreenSum,UnOperSum,DiagnosSum,ExcludeSum,InfUnScreenSum,InfScreenSum,DiagRatio,ExcRatio,TPRRatio,FNRRatio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1

   	//各感染诊断
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.InfPosD(xID))
		Quit:xID=""
		
	    Set InfPosData=$g(^DHCHAI.BT.InfPosD(xID))
	    Continue:InfPosData=""
	    Set Code =$lg(InfPosData,2)
	    Set Desc =$lg(InfPosData,3)
	    Set DiagFlag =$lg(InfPosData,4)
	  
	    Continue:(DiagFlag'=1)	
	    Set IsActive =$lg(InfPosData,6)
		Continue:(IsActive'=1)			
	   
		Set (InfPosCnt,InfRepCnt,ScreeningCnt,UnOperCnt,DiagnosCnt,ExcludeCnt,InfUnScreenCnt,InfScreenCnt)=0
		
		Set InfPatCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","InfPosPatCnt",xID))               //感染人数
		Set InfRepCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","InfPosRepCnt",xID))               //感染例次
		Set ScreeningCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","InfTypeCnt",xID,"TP"))	      //疑似人数(筛查评估中：未处置+确诊+排除)
		Set UnOperCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","OprStatusCnt",xID,"-1"))             //未处置人数
		Set ExcludeCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","OprStatusCnt",xID,"2"))             //排除人数
		Set DiagnosCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","OprStatusCnt",xID,"1"))             //确诊人数
		Set InfUnScreenCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","InfTypeCnt",xID,"FN"))       //感染非疑似病例 假阴性（FN）
		Set InfScreenCnt=+$g(^TMP($zn,$j,"DiagScreen-Cnt","InfTypeCnt",xID,"TP"))         //感染疑似病例   真阳性（TP）
	
	    //确诊率 排除率 
	    Set (DiagRatio,ExcRatio)="0.00%"
		Set:(ScreeningCnt)>0 DiagRatio=$fn((DiagnosCnt/ScreeningCnt)*100,"",2)_"%" 	//确诊率
		Set:(ScreeningCnt)>0 ExcRatio=$fn((ExcludeCnt/ScreeningCnt)*100,"",2)_"%" 	//排除率 
	   
	    //阳性预测值
	    Set (PPVRatio)="0.00%"
        Set:(ScreeningCnt)>0 PPVRatio=$fn(((InfScreenCnt)/ScreeningCnt)*100,"",2)_"%" 	        //阳性预测值
    
	    //灵敏度(真阳率)
	    Set (TPRRatio)="0.00%"
        Set:(InfUnScreenCnt+InfScreenCnt)>0 TPRRatio=$fn((InfScreenCnt/(InfUnScreenCnt+InfScreenCnt))*100,"",2)_"%" 	//灵敏度 召回率
	   
	    //假阴性率
	    Set (FNRRatio)="0.00%"
	    Set:TPRRatio>0 FNRRatio =$fn((100-TPRRatio),"",2)_"%"
			
		Set Data=$lb(xID,Code,Desc,InfPatCnt,InfRepCnt,ScreeningCnt,UnOperCnt,DiagnosCnt,ExcludeCnt,InfUnScreenCnt,InfScreenCnt,DiagRatio,ExcRatio,PPVRatio,TPRRatio,FNRRatio)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
   	}

	 Kill ^TMP($zn,$j,"DiagScreen-Cnt")
	 Quit $$$OK
}

ClassMethod QryDiagScreenRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagScreenRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiagScreenRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagScreenRateExecute ]
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

/// Creator：     pylian
/// CreatDate：   2022-08-18
/// Description:  统计疑似筛查结果明细(感染诊断维度)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo :结束日期
///               aAdmStatus：统计类型
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.AMS.ScreenResultSrv","QryDiagScreenDtl","1|2|3","2020-08-01","2020-08-31","A","","3")
Query QryDiagScreenDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aInfPosID As %String = "", aType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,InfRepList:%String,SusResult:%String,RuleOprDtl:%String") [ SqlProc ]
{
}

ClassMethod QryDiagScreenDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aInfPosID As %String = "", aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	
 	Set AMCode=aAdmStatus_aDateFrom_"-"_aDateTo
    Set ModelID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(AMCode,"U"),0))
    Quit:ModelID="" $$$OK
    
	Kill ^TMP($zn,$j,"DiagScreenDtl")

	Set xPaadm=""
	For {
   	 	Set xPaadm=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xPaadm))
   	 	Quit:xPaadm=""
   	 	
   	 	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
		Continue:(PAAdmData="")
        Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
    	//院区过滤
        Set AdmLocID =$lg(PAAdmData,22)  
		Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocID))
		Set HospDr=$lg(LocData,8)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)
		
		Set xARID=""
   	 	For {
   	 		Set xARID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xPaadm,xARID))
   	 		Quit:xARID=""

   	 		Set ResultData=$g(^DHCHAI.AM.AssessResultD(xARID))
		    Continue:ResultData=""    
		    Set IsActive  =$lg(ResultData,4)
		    Continue:IsActive'=1
    
			Do BuildDiagPatDtl(xPaadm,aDateFrom,aDateTo,aType,xARID)
   	 	}
	}
	//zw ^TMP($zn,$j,"DiagScreenDtl","PatListType"_aType)
    Set xEpisodeID=""
    For {
	    Set xEpisodeID=$o(^TMP($zn,$j,"DiagScreenDtl","PatListType"_aType,xEpisodeID))
	    Quit:xEpisodeID=""
	    	    		
		Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeID))
		Continue:(PAAdmData="")
		Set AdmitDate =$lg(PAAdmData,20)
    	Set DischDate =$lg(PAAdmData,26)
		Set DateFrom =aDateFrom
	    Set DateTo =aDateTo
	    If (aAdmStatus="D") {
		    Set DateFrom =AdmitDate
	   		Set DateTo =DischDate
	    }
		Set AdmData=..BuildPaadmData(xEpisodeID)
		Continue:(AdmData="")
		Set InfRepList =..GetInfRepList(xEpisodeID,DateFrom,DateTo)
		Set SusResult ="",SuMatrix="",RuleOprDtl=""    //疑似筛查结果
		Set AssResuID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",ModelID,xEpisodeID,0))
		If (AssResuID'="") {
			Set AssResultData=$g(^DHCHAI.AM.AssessResultD(AssResuID))
			Continue:ResultData=""    
			Set IsActive   =$lg(ResultData,4)
		    Continue:IsActive'=1
		    Set ARStatus  =$lg(ResultData,8)
		    Set SuMatrix  =$lg(ResultData,14)
			Set SusResult=$lg(AssResultData,6)
		}
		Set RuleOprDtl=..GetSuRuleOprDtl(xEpisodeID,"",DateFrom,DateTo)

		Set Data = AdmData_$lb(InfRepList,SusResult,RuleOprDtl)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }

	 Kill ^TMP($zn,$j,"DiagScreenDtl")
	 Quit $$$OK
	 
BuildDiagPatDtl(aEpisodeID,aDateFrom,aDateTo,aType,aARID)
    
    Set ARStatus="",SuMatrix=""
    Set ResultData=$g(^DHCHAI.AM.AssessResultD(aARID))
    Quit:ResultData=""    
    Set ARStatus  =$lg(ResultData,8)
    Set SuMatrix  =$lg(ResultData,14)

	//感染人数
	Set IsReport=0
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,1,xRepID))
		Quit:xRepID=""
		Quit:IsReport=1
		Set InfRepData=$g(^DHCHAI.IR.INFReportD(xRepID))
		Continue:InfRepData=""
		Set StatusDr = $lg(InfRepData,8)
		Continue:StatusDr=""
		Set StatusDic = $g(^DHCHAI.BT.DictionaryD(StatusDr))
		Continue:StatusDic=""
		Set RepStatus=$lg(StatusDic,2)
		Continue:(RepStatus=4)  //4作废
      
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
			Continue:(InfDate<aDateFrom)
			Continue:(InfDate>aDateTo)
            Set InfPosDr = $lg(DiagData,3)
			Continue:(aInfPosID'="")&(InfPosDr'=aInfPosID)
			
			Set IsReport=1
			Set ^TMP($zn,$j,"DiagScreenDtl","PatListType1",aEpisodeID)=""      //报告病例			
			Quit
		}
	}
	If (IsReport=1) {
	 	Set OprStatus=""
	    Set xScreenID = ""
		For {
			Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
			Quit:xScreenID=""
			
			Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
			Continue:ScreenData=""
			Set RstFromDate=$lg(ScreenData,7)   //处置结果开始日期
		    Set RstToDate=$lg(ScreenData,8)     //处置结束开始日期
		    Continue:(aDateFrom'="")&(RstToDate<aDateFrom)     
		    Continue:(aDateTo'="")&(RstFromDate>aDateTo)

			Set xSubID = ""
		   	For {
		   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
		   		Quit:xSubID=""
	   		
	   		    Set ScreenDtl=$g(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
	   		    Continue:ScreenDtl=""
	   		    Set Status= $lg(ScreenDtl,2)
	   		    Set:OprStatus'=1 OprStatus=Status
		   	}
		}
		If (SuMatrix="TP") {
			Set ^TMP($zn,$j,"DiagScreenDtl","PatListType2",aEpisodeID)=""    //疑似病例   
			If (OprStatus=1) {
				Set ^TMP($zn,$j,"DiagScreenDtl","PatListType3",aEpisodeID)=""    //确诊病例   
			}
			If (OprStatus=2) {
		        Set ^TMP($zn,$j,"DiagScreenDtl","PatListType4",aEpisodeID)=""    //排除病例  
			}
		}
		If (SuMatrix="FN") {
			Set ^TMP($zn,$j,"DiagScreenDtl","PatListType5",aEpisodeID)=""    //感染非疑似   
		}
	}
    
	Quit
}

ClassMethod QryDiagScreenDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagScreenDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiagScreenDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagScreenDtlExecute ]
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

/// 取病人信息方法
ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	new (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	
	Set PapmiNo = $li(PAAdmData,4)
	Set MrNo = $li(PAAdmData,5)
	Set PatName = $li(PAAdmData,6)
	Set Sex = $li(PAAdmData,7)
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = $li(PAAdmData,37)

	Set VisitStatus = $li(PAAdmData,19)
	Set VisitStatus = $s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="C":"退院",VisitStatus="P":"预住院",VisitStatus="U":"作废",1:"")
	Set AdmDate = $li(PAAdmData,20)
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = $li(PAAdmData,21)
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	
	Set AdmLocDr = $li(PAAdmData,22)
	Set AdmLocDesc=""
	Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
	If LocData'="" {
		Set LocDesc2 = $li(LocData,4)
		Set LocDesc  = $li(LocData,3)
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set AdmWardDr = +$li(PAAdmData,23)
	Set WardData = $g(^DHCHAI.BT.LocationD(AdmWardDr))
	Set AdmWardDesc=""
	If WardData'="" {
		Set WardDesc2 = $li(WardData,4)
		Set WardDesc  = $li(WardData,3)
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmRoom  = $li(PAAdmData,24)
	Set AdmBedDr = $li(PAAdmData,25)
	Set AdmBedData=""
	If (AdmBedDr'="") {
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
	}
	Set AdmBed=""
	If AdmBedData'="" {
		Set AdmBed = $li(AdmBedData,3)
	}
	Set DischDate = $li(PAAdmData,26)
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = $li(PAAdmData,27)
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set DischLocDr = $li(PAAdmData,28)
    Set LocData=""
    If (DischLocDr'="") {
    	Set LocData = $g(^DHCHAI.BT.LocationD(DischLocDr))
    }
	Set DischLocDesc=""
	If LocData'="" {
		Set LocDesc2 = $li(LocData,4)
		Set LocDesc  = $li(LocData,3)
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set DischWardDr = $li(PAAdmData,29)
	Set WardData=""
    If (DischWardDr'="") {
    	Set WardData = $g(^DHCHAI.BT.LocationD(DischWardDr))
    }
	Set DischWardDesc=""
	If WardData'="" {
		Set WardDesc2 = $li(WardData,4)
		Set WardDesc  = $li(WardData,3)
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc)
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
ClassMethod GetSuRuleOprDtl(aEpisodeID As %String, aRuleID As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeID,aRuleID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
    Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)

    Set SuRuleData="",ItmScreenDr=""
	Set:aRuleID'="" SuRuleData= $g(^DHCHAI.IR.CRuleInfSuRuleD(aRuleID))
	Set ItmScreenDr=$lg(SuRuleData,3)
	
	Set SuOprList=""
	Set xScreenID =""
	For {
		Set xScreenID =$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
		Quit:xScreenID=""
		
		Set ScreenData=$g(^DHCHAI.IR.CCScreeningD(xScreenID))
	   	Continue:ScreenData=""	   	
	   	Set ItmScreenID=$lg(ScreenData,3)
	   	Continue:(ItmScreenDr'="")&(ItmScreenDr'=ItmScreenID)
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
	    If (ItmScreen="病程阳性症状或体征")&(ItmScreenTxt'=""){
		    Set RuleDetails=##class(DHCHAI.IRS.CCScreenLogSrv).SymptomItem(aEpisodeID,ItmScreenTxt)
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
