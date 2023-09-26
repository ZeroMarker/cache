/// 名称: DHCHAI.AMC.CSAssessTask
/// 描述: 疑似病例筛查评估任务
/// 编写者：zhufei
/// 编写日期: 2019-03-14
Class DHCHAI.AMC.CSAssessTask Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-03-14
/// Description:  疑似筛查评估手动任务
/// Table：       DHCHAI.AM.AssessModel、DHCHAI.AM.AssessResult
/// Input：       aModelDr : 评估模型ID
/// Return：      返回String
/// w ##class(DHCHAI.AMC.CSAssessTask).ManualTask(4)
ClassMethod ManualTask(aModelDr As %String = "") As %String
{
	New (aModelDr)
	Set return=0,Count=0,arrCount=0
	
	Set (ModelID,AdmStatus,SttDate,EndDate,ClassName)=""
	If aModelDr'="" {
		Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(aModelDr)
		If $IsObject(objModel){
			Set ModelID   = objModel.%Id()
			Set AdmStatus = objModel.AMAdmStatus
			Set SttDate   = objModel.AMSttDate
			Set EndDate   = objModel.AMEndDate
			Set ClassName = objModel.AMClassName
			Set SuRuleIDs = objModel.AMSuRule
			Set SuRuleTypes =""
			For indS =1:1:$l(SuRuleIDs,",") {
				Set SuRuleID=$p(SuRuleIDs,",",indS)
				Continue:SuRuleID=""
				Set SuRule=$li($g(^DHCHAI.IR.CRuleInfSuRuleD(SuRuleID)),5)
				Continue:(","_SuRuleTypes_",")[(","_SuRule_",")
				Set SuRuleTypes=SuRuleTypes_","_SuRule
			}
			Set:SuRuleTypes'="" SuRuleTypes=$e(SuRuleTypes,2,$l(SuRuleTypes))
		}
	} Else {
		Set xModelID=""
		For {
			Set xModelID=$o(^DHCHAI.AM.AssessModelD(xModelID),-1)
			Quit:xModelID=""
			Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(xModelID)
			Continue:'$IsObject(objModel)
			Continue:objModel.BTIsActive'=1
			Set ModelID   = objModel.%Id()
			Set AdmStatus = objModel.AMAdmStatus
			Set SttDate   = objModel.AMSttDate
			Set EndDate   = objModel.AMEndDate
			Set ClassName = objModel.AMClassName
			Set SuRuleIDs = objModel.AMSuRule
			Set SuRuleTypes =""
			For indS =1:1:$l(SuRuleIDs,",") {
				Set SuRuleID=$p(SuRuleIDs,",",indS)
				Continue:SuRuleID=""
				Set SuRule=$li($g(^DHCHAI.IR.CRuleInfSuRuleD(SuRuleID)),5)
				Continue:(","_SuRuleTypes_",")[(","_SuRule_",")
				Set SuRuleTypes=SuRuleTypes_","_SuRule
			}
			Set:SuRuleTypes'="" SuRuleTypes=$e(SuRuleTypes,2,$l(SuRuleTypes))
			Quit
		}
	}
	Quit:(ModelID="")||(SttDate="")||(EndDate="")||(AdmStatus="") return
	
	//作废原有评估记录
	Set flg=..CancelAMResult(ModelID)
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"命令")="ManualTask("_aModelDr_")"
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	If (AdmStatus'="I") {
		Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(SttDate,EndDate)
		Set arrCount=arrEpisodeDr.Count()
		For indEpis=1:1:arrCount {
			Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
			Continue:xEpisodeDr=""
		  
			//Write "EpisodeDr="_xEpisodeDr,!
			Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeDr_")"
	
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

			//感染报告
			Set IsReport=..CheckIsReport(xEpisodeDr,DateFrom,DateTo)
			
			Do UpdateResult(DateFrom,DateTo)
		}
	}Else {
		Set xEpisodeDr="",indEpis=0 
		For {
			Set xEpisodeDr=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeDr))
			Quit:xEpisodeDr=""
			
			Set IsReport=..CheckIsReport(xEpisodeDr,SttDate,EndDate)
			Continue:IsReport=0
	       	Set indEpis=indEpis+1
			
			//Write "EpisodeDr="_xEpisodeDr,!
			Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeDr_")"
			
			Do UpdateResult(SttDate,EndDate)
		}
	}
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Quit return
	
UpdateResult(aSttDate,aEndDate)
	
	K ^TMP($zn,$j,"ItmScreen")
    If (AdmStatus'="D") {
		Set execute="Set arr=##class("_ClassName_").GetSuRuleResult(xEpisodeDr,aSttDate,aEndDate,SuRuleTypes)"
    }Else {
		Set execute="Set arr=##class("_ClassName_").GetSuRuleResult(xEpisodeDr,AdmDate,+$h,SuRuleTypes)"
    }
  
	Xecute execute
	
	Set InfType1=0,InfType2=0,InfType3=0,SusResult="",SusDiagnos=""
	For indArr=1:1:arr.Count() {
		Set obj=arr.GetAt(indArr)
		Continue:'$IsObject(obj)
		Continue:obj.CSIsActive'=1
		Continue:obj.CSRstStatus'=1   //结果状态(0触发疑似指标、1触发组合条件)
		
		Set ItmScreenID   = obj.CSItmScreenDr.%Id()
		Set ItmScreenDesc = obj.CSItmScreenDr.CCDesc
		Set ItmScreenTxt  = obj.CSItmScreenTxt
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
    Set SuMatrix="",IsScreen=0,SuRuleOpr=""      //是否疑似病例    //评估类型  是否疑似病例 
    Set xInfSuRuleID=""
 	For{
	 	Set xInfSuRuleID=$o(^TMP($zn,$j,"ItmScreen",xInfSuRuleID))
	 	Quit:xInfSuRuleID=""
	 	
	 	
	 	Set xItmScreenID=""
	 	For{
		 	Set xItmScreenID=$o(^TMP($zn,$j,"ItmScreen",xInfSuRuleID,xItmScreenID))
		 	Quit:xItmScreenID=""
		 	
		 	
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
			 	    
			 	   	If ($listfind(InfSuPosIDList,InfSuPosID)<1) {
			 	   		Set InfSuPosIDList=InfSuPosIDList_$lb(InfSuPosID)
			 	   	}
			 	   
			 	   	If ($listfind(SpecimenList,Specimen)<1) {
			 	   		Set SpecimenList=SpecimenList_$lb(Specimen)
			 	   	}
			 	   	If ($listfind(MRBTypeList,MRBType)<1) {
			 	   		Set MRBTypeList=MRBTypeList_$lb(MRBType)
			 	   	} 	   
			 	   	If ($listfind(ResultDateList,InfSuDate)<1) {
			 	   		Set ResultDateList=ResultDateList_$lb(ResultDate)
			 	   	}
			 	   	
			 	   	Set:Details'="" DetailsList=DetailsList_"#"_Details	
			 	   	Set:ResultNote["病程" DetailsList="#"_InfSuKeys	  
			 	   	Set:ResultNote["权重" ResultDateList = ResultDate   //update 2022-05-10 权重组合判断规则日期比较特殊 
			 	}
			   
			    Set InfSuPosIDs="",InfSuPosID="",InfPosIDList="",InfPosList=""
			    For indPos=1:1:$ll(InfSuPosIDList) {    
				    Set InfSuPosIDs=$lg(InfSuPosIDList,indPos)
				    Continue:InfSuPosIDs=""	     
				    Set:$lv(InfSuPosIDs)=0 InfSuPosIDs=$lb(InfSuPosIDs)  //规则中一个项目推荐一个感染部位写法与推荐多个不一致
				    For indInf =1:1:$ll(InfSuPosIDs) {                   //一个项目推荐多个感染部位
					    Set InfSuPosID=$lg(InfSuPosIDs,indInf)
					    Continue:InfSuPosID=""
					    Set objInfSup =##class(DHCHAI.BT.InfSuPos).GetObjById(InfSuPosID)
				   		Continue:'$IsObject(objInfSup)
				   		Continue:'$IsObject(objInfSup.BTInfPosDr)
				   		Set InfSuPos = objInfSup.BTDiagnos
						Set InfPosID = objInfSup.BTInfPosDr.%Id()
				   		Set InfPos = objInfSup.BTInfPosDr.BTDesc
				   		Set InfPosIDList=InfPosIDList_"，"_InfPosID
				   		Set InfPosList=InfPosList_"，"_InfPos
				    }
			    }		  
			    Set:InfPosIDList'="" InfPosIDList=$e(InfPosIDList,2,$l(InfPosIDList))
			    Set:InfPosList'="" InfPosList=$e(InfPosList,2,$l(InfPosList))
			    Set:DetailsList'="" DetailsList=$e(DetailsList,2,$l(DetailsList))
			    Set ResultDate=$lg(ResultDateList,1)  
				Set:ResultDate'="" ResultDate=$zd(ResultDate,3) 
				
			    Set Specimens=""
			   	For indSpe=1:1:$ll(SpecimenList)  {
				    Set Specimen=$lg(SpecimenList,indSpe)
				    Continue:Specimen=""
				    Set Specimens=Specimens_"#"_ Specimen	    
			    }
			    Set:Specimens'="" Specimens=$e(Specimens,2,$l(Specimens))
			    
			   	Set MRBTypes=""
			   	For indMRB=1:1:$ll(MRBTypeList)  {
				    Set MRBType=$lg(MRBTypeList,indMRB)
				    Continue:MRBType=""
				    Set MRBTypes=MRBTypes_"#"_ MRBType	    
			    }
			    Set:MRBTypes'="" MRBTypes=$e(MRBTypes,2,$l(MRBTypes))
			    Set:MRBTypes'="" ItmScreenTxt = MRBTypes
			  
				Set:DetailsList'="" ResultNote=ResultNote_"<br>"_DetailsList
			    If SusResult'="" {
					Set SusResult=SusResult_","_ResultNote_"("_ResultDate_")"
				} Else {
					Set SusResult=ResultNote_"("_ResultDate_")"
				}
				
				Set IsOpr =0
			 	Set xScreenID=""
			   	For {
				   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",xEpisodeDr,xItmScreenID," "_$zcvt(ItmScreenTxt,"U"),xScreenID))
				   	Quit:xScreenID=""
				   
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
				
		 	}
		 		
			If InfPosList'="" {
				If SusDiagnos'="" {
					Set SusDiagnos=SusDiagnos_";"_InfPosList
				} Else {
					Set SusDiagnos=InfPosList
				}
			}
		 	Set InfType1=1
	 	} 
	 	Set SuRuleDtls = SuRuleDtls_","_xInfSuRuleID_"-"_SuRuleOpr
 	}
 	
 	Set:SuRuleDtls'="" SuRuleDtls=$e(SuRuleDtls,2,$l(SuRuleDtls))
 	
	Set:(IsScreen=1)&(IsReport=1) SuMatrix="TP"   //感染疑似   真阳性
	Set:(IsScreen=1)&(IsReport'=1) SuMatrix="FP"  //疑似非感染 假阳性
	Set:(IsScreen'=1)&(IsReport=1) SuMatrix="FN"  //感染非疑似 假阴性		 		
	 	
	Set InfType=0,Status=-1,IsActive=1
	If (InfType1>0) {
		Set InfType=1,Status=-1  //疑似感染
		Set:(IsReport>0) Status=1  //自报感染和报告病例，默认“确认”状态
	} Else {
		If (IsReport>0) {
			Set InfType=2,Status=2
		}
	}
	
	Quit:InfType=0 return  //不是疑似感染,也不是自报感染
	
	Set (DiagDate,DiagNote,RstDate,RstTime,RstUserDr)=""
	Set ResultID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr,0))
	If ResultID'="" {
		Set objResult=##class(DHCHAI.AM.AssessResult).GetObjById(ResultID)
		If $IsObject(objResult){
			Set AMStatus = objResult.ARStatus
			If (Status=-1) {
				If (AMStatus=0)||(AMStatus=1) {
					Set Status=AMStatus
				}
			}
			Set DiagDate = objResult.ARDiagDate
			Set DiagNote = objResult.ARDiagNote
			Set RstDate  = objResult.ARRstDate
			Set RstTime  = objResult.ARRstTime
			If $IsObject(objResult.ARRstUserDr){
				Set RstUserDr = objResult.ARRstUserDr.%Id()
			}
		}
	}
	
	Set $p(InputStr,"^",1)    = ResultID
	Set $p(InputStr,"^",2)    = aModelDr   //评估模型代码
	Set $p(InputStr,"^",3)    = xEpisodeDr //就诊号
	Set $p(InputStr,"^",4)    = IsActive   //是否有效
	Set $p(InputStr,"^",5)    = InfType    //1疑似病例、2自报感染、3疑似社区感染
	Set $p(InputStr,"^",6)    = SusResult  //疑似筛查结果
	Set $p(InputStr,"^",7)    = SusDiagnos //疑似感染诊断/部位
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

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  作废原有记录
/// Table：       DHCHAI.AM.AssessResult
/// Input：       aModelDr : 评估模型ID
/// Return：      return>0:成功，return<=0:失败
/// w ##class(DHCHAI.AMC.CSAssessTask).CancelAMResult()
ClassMethod CancelAMResult(aModelDr As %String) As %String
{
	New (aModelDr)
	Set return=0,Count=0
	Quit:aModelDr="" return
	
	Set xEpisodeDr=0
	For {
		Set xEpisodeDr=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr))
		Quit:xEpisodeDr=""
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr,xID))
			Quit:xID=""
			Set flg=##class(DHCHAI.AM.AssessResult).SetResultAct(xID,0)
			Set Count=Count+1
		}
	}
	Set return=Count
	Quit return
}

/// 检查是否上报感染报告
/// w ##class(DHCHAI.AMC.CSAssessTask).CheckIsReport()
ClassMethod CheckIsReport(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
    
    Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
    Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
    
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
			Quit:IsReport=1
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
		}
	}
    Set return =IsReport
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-03-14
/// Description:  处理疑似筛查错误数据
/// Table：       DHCHAI.AM.AssessModel、DHCHAI.AM.AssessResult
/// Input：       aModelDr : 评估模型ID
/// Return：      返回String
/// w ##class(DHCHAI.AMC.CSAssessTask).ErrDataTask(3)
ClassMethod ErrDataTask(aModelDr As %String = "") As %String
{
	New (aModelDr)
	Set return=0,Count=0,arrCount=0
	
	Set (ModelID,AdmStatus,SttDate,EndDate,ClassName)=""
	If aModelDr'="" {
		Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(aModelDr)
		If $IsObject(objModel){
			Set ModelID   = objModel.%Id()
			Set AdmStatus = objModel.AMAdmStatus
			Set SttDate   = objModel.AMSttDate
			Set EndDate   = objModel.AMEndDate
			Set ClassName = objModel.AMClassName
		}
	} Else {
		Set xModelID=""
		For {
			Set xModelID=$o(^DHCHAI.AM.AssessModelD(xModelID),-1)
			Quit:xModelID=""
			Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(xModelID)
			Continue:'$IsObject(objModel)
			Continue:objModel.BTIsActive'=1
			Set ModelID   = objModel.%Id()
			Set AdmStatus = objModel.AMAdmStatus
			Set SttDate   = objModel.AMSttDate
			Set EndDate   = objModel.AMEndDate
			Set ClassName = objModel.AMClassName
			Quit
		}
	}
	Quit:(ModelID="")||(SttDate="")||(EndDate="")||(AdmStatus="") return
	
	//Set SttDate=65117
	//Set EndDate=65120
	Set IsDynamicObject=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD))
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"命令")="ErrDataTask("_aModelDr_")"
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Set ^DHCHAI.Task.TaskManager("NLPStatus")=0  //初始化语义分析服务器状态，是否能链接,异常赋值=1

	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(SttDate,EndDate)
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
		
		Set FromDate =AdmDate
		Set ToDate =DischDate
		Set:(+ToDate)<1 ToDate=+$h
	    Set EpisodeDr =xEpisodeDr
		Set EpisodeIDx =$lg(PAAdmData,2)
			
		//2.2.8 病程记录
		
		Continue:$g(^DHCHAI.Task.TaskManager("NLPStatus"))=1
		//Set flg=##class(DHCHAI.DI.ERR.SyncEmrErrInfo).SyncEmrErrByEpis("EMR01",EpisodeIDx,FromDate,ToDate)
		Set flg=##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrByDateAdm("EMR01",EpisodeIDx,FromDate,ToDate)	
		If IsDynamicObject="dhcyes" {
			//2016库+东华NLP语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCSrv).EmrAnalysisByEpis(EpisodeDr,FromDate,ToDate)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCSrv).RISAnalysisByEpis(EpisodeDr,FromDate,ToDate)
		} ElseIf IsDynamicObject="dhcno" {
			//2010库+东华NLP语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCUpSrv).EmrAnalysisByEpis(EpisodeDr,FromDate,ToDate)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalyDHCUpSrv).RISAnalysisByEpis(EpisodeDr,FromDate,ToDate)
		} ElseIf IsDynamicObject="yes" {
			//2016库+康夫子语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).EmrAnalysisByEpis(EpisodeDr,FromDate,ToDate)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).RISAnalysisByEpis(EpisodeDr,FromDate,ToDate)
		} ElseIf IsDynamicObject="no" {
			//2010库+康夫子语义分析
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalysisUpSrv).EmrAnalysisByEpis(EpisodeDr,FromDate,ToDate)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalysisUpSrv).RISAnalysisByEpis(EpisodeDr,FromDate,ToDate)
		} ElseIf IsDynamicObject="key" {
			//关键词筛查
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalysisKeySrv).EmrAnalysisByEpis(EpisodeDr,FromDate,ToDate)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalysisKeySrv).RISAnalysisByEpis(EpisodeDr,FromDate,ToDate)
		} ElseIf IsDynamicObject="key2.0" {
			//关键词筛查2.0
			//1.1 病程语义分析
			Do ##class(DHCHAI.RMES.AnalyCorpusSrv).EmrAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
			//1.2 检查报告语义分析
			Do ##class(DHCHAI.RMES.AnalyCorpusSrv).RISAnalysisByEpis(xEpisodeDr,aDateFrom,aDateTo)
		}
	
		//2.1 监控结果任务
		Do ##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlResult(EpisodeDr,FromDate,ToDate)
		
		Set Count=Count+1
	}
	//记录执行任务日志
	Set ^DHCHAI.AMC.TaskManager(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Set return=Count
	Quit return
}

}
