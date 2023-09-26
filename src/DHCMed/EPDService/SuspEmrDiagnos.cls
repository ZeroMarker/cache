/// 名称: DHCMed.EPDService.SuspEmrDiagnos
/// 描述: 传染病监控与病历诊断相关服务
/// 编写者：pylian
/// 编写日期: 2019-01-31
Class DHCMed.EPDService.SuspEmrDiagnos Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-31
/// Description:  检查电子病历诊断
/// Table：       
/// Input：       aEpisodeID : 就诊号
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspEmrDiagnos).CheckEMR(59,"","")
ClassMethod CheckEMR(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aEpisodeID,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="")||(aEpisodeID="") return
	
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
   
   	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set AdmHospID = +$p($g(^CTLOC(+AdmLoc)),"^",22)
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	Set:AdmReadm="" AdmReadm="A"
	Set DischDateTime= ##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Quit:(DischDate="")||(DischTime="") return
	Set Age=##class(DHCMed.SSIO.FromHisSrv).CalAge(PatientID,aEpisodeID,"","")
	Quit:Age="" return
	If Age["岁" {
		Set Age=+$p(Age,"岁",1)
	} Else {
		Set Age=1
	}
	Set $ZT="CheckEMRErr"
	Set Count = ..CheckChange(aEpisodeID,Age)

	Set EmrDiagnosStrs=##class(DHCMed.SS.Config).GetValueByKeyHosp("EpdEmrDiagnoStr","")  //电子病历诊断编码|诊断描述
	Set EmrDiagnosStr=""
	For indx = 1:1:$l(EmrDiagnosStrs,",") {
		Set EmrDiagnosStr= $p(EmrDiagnosStrs,",",indx)
		Continue:EmrDiagnosStr=""
		Set DiagnosECode=$p(EmrDiagnosStr,"|",1)
		Set DiagnosEDesc=$p(EmrDiagnosStr,"|",2)
		Set DiagnosCode=##class(DHCMA.Util.IO.FromEmrSrv).GetEPRData(aEpisodeID,DiagnosECode,.ArrGlossary)
		Set DiagnosDesc=##class(DHCMA.Util.IO.FromEmrSrv).GetEPRData(aEpisodeID,DiagnosEDesc,.ArrGlossary)
	
	    Set DocDesc =""   
		Set RstList = ##class(DHCMed.EPDService.SuspMRDiagnos).GetDiagCheck(DiagnosCode,DiagnosDesc,Age)   //ICD/关键词检索
		Continue:RstList=""
		
		Set ScreenDr=""
        For indL=1:1:$l(RstList) {
	        Set ScreenDr=$p(RstList,",",indL)
	        Continue:ScreenDr=""
	        Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(ScreenDr)
	        Continue:'$IsObject(objScr)
	        Continue:'$IsObject(objScr.BTInfectDr)
	        Set InfectDesc = objScr.BTInfectDr.BTDesc
	        Set InfDicID =objScr.BTInfectDr.%Id()
	        
	        Set (EpdStatus,EpdDiagnos,Opinion,EvalDate,EvalTime,EvalLoc,EvalUser)=""
	      
        	Set ID=$o(^DHCMed.EPDi("CasesX","IndexEpisActDiagnos","EPDCC",aEpisodeID," "_$zcvt(InfectDesc,"U"),0))
			If ID'="" {
				Set obj=##class(DHCMed.EPD.CasesX).GetObjById(ID)
				If $IsObject(obj) {
					Set EpdStatus	= obj.CXEpdStatus
					Set EpdDiagnos	= obj.CXEpdDiagnos
					Set Opinion     = obj.CXOpinion
					Set EvalDate    = obj.CXEvalDate
					Set EvalTime    = obj.CXEvalTime
					Set EvalLoc     = obj.CXEvalLoc
					Set EvalUser    = obj.CXEvalUser
				}
			}
			
			//保存病例筛查日志信息
			Set inputStr=ID
			Set inputStr=inputStr_"^"_"EPDCC"
			Set inputStr=inputStr_"^"_aEpisodeID
			Set inputStr=inputStr_"^"_DischDate
			Set inputStr=inputStr_"^"_AdmLoc
			Set inputStr=inputStr_"^"_InfectDesc
			Set inputStr=inputStr_"^"_AdmReadm
			Set inputStr=inputStr_"^"_""
			Set inputStr=inputStr_"^"_EpdStatus
			Set inputStr=inputStr_"^"_EpdDiagnos
			Set inputStr=inputStr_"^"_Opinion
			Set inputStr=inputStr_"^"_EvalDate
			Set inputStr=inputStr_"^"_EvalTime
			Set inputStr=inputStr_"^"_EvalLoc
			Set inputStr=inputStr_"^"_EvalUser
			Set inputStr=inputStr_"^"_1
			Set inputStr=inputStr_"^"_""
			Set inputStr=inputStr_"^"_DischDate
			Set CasesXID=##class(DHCMed.EPD.CasesX).Update(inputStr,"^")
			
			//记录诊断和是否保存成功，发消息使用
			Set MsgArray(InfectDesc,CasesXID)=Comments
			
			If (+CasesXID)>0 {
				Set Count=Count+1
				Set xSubID = ""
				Set xSubID=$o(^DHCMed.EPD.CasesXI("DTL","IndexScreenDateTime",CasesXID,ScreenDr,DischDate,DischTime,xSubID))
		
				//保存筛查明细
				Set inputSub=CasesXID
				Set inputSub=inputSub_"^"_xSubID
				Set inputSub=inputSub_"^"_ScreenDr
				Set inputSub=inputSub_"^"_"EMR:"_DiagnosCode_"#"_DiagnosDesc
				Set inputSub=inputSub_"^"_DischDate
				Set inputSub=inputSub_"^"_DischTime
				Set inputSub=inputSub_"^"_1
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_DocDesc 
				Set inputSub=inputSub_"^"_""
				Set flg=##class(DHCMed.EPD.CasesXDtl).Update(inputSub,"^")			
			}
        }
	}
	//遍历是否需要发送消息
	Set EpdSuspAutoSendMsg = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdSuspAutoSendMsg",AdmHospID)	// 传染病筛查后自动发消息
	// 发送全部或发送诊断异常的
	If ((EpdSuspAutoSendMsg["1")||(EpdSuspAutoSendMsg["2")){
		Set xInfectDesc=""
		For{
			Set xInfectDesc = $o(MsgArray(xInfectDesc))
			Quit:xInfectDesc=""
			Set xCasesXID=""
			For{
				Set xCasesXID = $o(MsgArray(xInfectDesc,xCasesXID))
				Quit:xCasesXID=""
				Continue:xCasesXID<=0
				Set CommentInfo	= "该患者电子病历诊断包含："_xInfectDesc_"，疑似传染病，请及时上报！"
				Set SendMessage = ##class(websys.DHCMessageInterface).Send(CommentInfo,"1018","^med",aEpisodeID,"","","{""linkParam"":""EpisodeID="_aEpisodeID_""",""dialogWidth"":""1340px"",""dialogHeight"":""90%""}","","","")
			}
		}
	}
	Quit Count
	
	
CheckEMRErr
	Quit "-999^"_$ZError
}

/// Creator：     mayanpeng
/// CreatDate：   2023-02-02
/// Description:  检查电子病历诊断是否删除
/// Table：       
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspEmrDiagnos).CheckChange("55","22")
ClassMethod CheckChange(aEpisodeID As %String, aAge As %String) As %String
{
	new (aEpisodeID,aAge)
	Set return=0,Count=0
	
	Set $ZT="CheckChangeErr"

	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set xCasesXID=""
 	For {
 		Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectPaadm","EPDCC",aEpisodeID,xCasesXID))
 		Quit:xCasesXID=""
 		
 		Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
		Continue:'$IsObject(objCasesX)
		Set IsActive=objCasesX.CXIsActive
		Continue:IsActive'=1

		Set xSubID=""
 		For {
 			Set xSubID=$o(^DHCMed.EPD("CasesX",xCasesXID,"DTL",xSubID))
 			Quit:xSubID=""
 		
 			Set objDtl=##class(DHCMed.EPD.CasesXDtl).GetObjById(xCasesXID_"||"_xSubID)
			Continue:'$IsObject(objDtl)
			Set IsActive=objDtl.CXDIsActive
			Continue:IsActive'=1
 			Set DContent = objDtl.CXDContent
 			Continue:DContent'["EMR:"    //非电子病历诊断项目不判断
 			Set DiagnosCode = $p(DContent,"#",1)
 			Set DiagnosDesc = $p(DContent,"#",2)
			
			Set isExist=0		//是否还存在当前的诊断
			Set EmrDiagnosStrs=##class(DHCMed.SS.Config).GetValueByKeyHosp("EpdEmrDiagnoStr","")  //电子病历诊断编码|诊断描述
			Set EmrDiagnosStr=""
			For indx = 1:1:$l(EmrDiagnosStrs,",") {
				Set EmrDiagnosStr= $p(EmrDiagnosStrs,",",indx)
				Continue:EmrDiagnosStr=""
				Set DiagnosEDesc=$p(EmrDiagnosStr,"|",2)
				Set tDiagnosDesc=##class(DHCMA.Util.IO.FromEmrSrv).GetEPRData(aEpisodeID,DiagnosEDesc,.ArrGlossary)
				If (tDiagnosDesc=DiagnosDesc) {
					Set isExist=1
					Quit
				}
			}
			If isExist=0 {		//已经不存在当前的诊断
				Set objDtl=##class(DHCMed.EPD.CasesXDtl).%OpenId(xCasesXID_"||"_xSubID)
				If ($IsObject(objDtl)) {
					Set objDtl.CXDIsActive = 0
					Set sc=objDtl.%Save()
					If $system.Status.IsError(sc) {        //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc) 
				   		Set return=-1
					}Else{
						set return=objDtl.%Id()
					}
					Do objDtl.%Close()
				}
				Set Count=Count+1
			}
		}
	}
	Quit Count

CheckChangeErr
	Quit "-999^"_$ZError
}

}
