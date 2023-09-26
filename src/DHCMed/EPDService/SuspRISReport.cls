/// 名称: DHCMed.EPDService.SuspRISReport
/// 描述: 传染病监控与检查报告相关服务
/// 编写者：pylian
/// 编写日期: 2019-01-30
Class DHCMed.EPDService.SuspRISReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-30
/// Description:  检查项目
/// Table：       DHCRB_Report、DHCPACRegInfo
/// Input：       aEpisodeID : 就诊号
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.AutoTask).CheckRIS(80,"2016-01-01","2019-01-31")
ClassMethod CheckRIS(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aEpisodeID,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aEpisodeID="") return

	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)

	Set AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set AdmHospID = +$p($g(^CTLOC(+AdmLoc)),"^",22)
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	Set:AdmReadm="" AdmReadm="A"

	Set $ZT="CheckRISErr"
	
	//检查报告版本
	// RIS1.0  ：从东华影像检查直接获取报告信息
	// RISC1.0 ：从平台（文档）获取报告信息
	// RISC2.0 ：从平台（结构化）获取报告信息
    Set LabRepVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSRISReportVer")
	If LabRepVer="RISC1.0" {
		//add by zf 2019-09-25 从平台直接取值
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.EnsSyncRis1Srv:QryRisReportInfo")
	}ElseIf LabRepVer="RISC2.0" {
		//add by zf 2019-09-25 从平台直接取值
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.EnsSyncRis2Srv:QryRisReportInfo")
	} Else {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncRisSrv:QryRisReportInfo")
	}
	Set sc=rs.Execute(aEpisodeID,aDateFrom,aDateTo,"")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set ReportID     = rs.Data("ID")              //报告ID
	    Set StatusCode   = rs.Data("StatusCode")      //状态代码
	    Set StatusDesc   = rs.Data("StatusDesc")      //状态名称
	    Set StudyNo      = rs.Data("StudyNo")         //报告号
	    Set OEItemID     = rs.Data("OEItemID")        //医嘱ID
	    Set OrdItemCode  = rs.Data("OrdItemCode")     //医嘱代码
	    Set OrdItemDesc  = rs.Data("OrdItemDesc")     //医嘱名称
        Set RegDate      = rs.Data("RegDate")         //登记日期
	    Set RegTime      = rs.Data("RegTime")         //登记时间
	    Set RegUserCode  = rs.Data("RegUserCode")     //登记人代码
	    Set RegUserDesc  = rs.Data("RegUserDesc")     //登记人姓名
	    Set RepDate      = rs.Data("RepDate")         //报告日期
	    Set RepTime      = rs.Data("RepTime")         //报告时间
	    Set RepUserCode  = rs.Data("RepUserCode")     //报告人代码
	    Set RepUserDesc  = rs.Data("RepUserDesc")     //报告人姓名
	    Set ExamDesc     = rs.Data("ExamDesc")        //检查所见
	    Set ExamResult   = rs.Data("ExamResult")      //诊断意见
	    Set Memo         = rs.Data("Memo")            //备注信息
	    Set:RegDate="" RegDate=RepDate
	    Set:RegTime="" RegTime=RepTime
    	Set Comments = ExamDesc_" "_ExamResult
 		Set RstList = ..GetRISCheck(Comments)   //ICD/关键词检索
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
			Set inputStr=inputStr_"^"_RegDate
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
			Set inputStr=inputStr_"^"_RepDate
			Set CasesXID=##class(DHCMed.EPD.CasesX).Update(inputStr,"^")
			
			//记录诊断和是否保存成功，发消息使用
			Set MsgArray(InfectDesc,CasesXID)=Comments
			
			If (+CasesXID)>0 {
				Set Count=Count+1
				Set xSubID = ""
				Set xSubID=$o(^DHCMed.EPD.CasesXI("DTL","IndexScreenDateTime",CasesXID,ScreenDr,RegDate,RegTime,xSubID))
		
				//保存筛查明细
				Set inputSub=CasesXID
				Set inputSub=inputSub_"^"_xSubID
				Set inputSub=inputSub_"^"_ScreenDr
				Set inputSub=inputSub_"^"_"RIS:"_ReportID_"#"_StudyNo_"#"_OEItemID_"#"_OrdItemDesc
				Set inputSub=inputSub_"^"_RegDate
				Set inputSub=inputSub_"^"_RegTime
				Set inputSub=inputSub_"^"_1
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_RepUserDesc 
				Set inputSub=inputSub_"^"_StudyNo 
				Set flg=##class(DHCMed.EPD.CasesXDtl).Update(inputSub,"^")			
			}
        }
	}
	//遍历是否需要发送消息
	Set EpdSuspAutoSendMsg = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdSuspAutoSendMsg",AdmHospID)	// 传染病筛查后自动发消息
	// 发送全部或发送检查异常的
	If ((EpdSuspAutoSendMsg["1")||(EpdSuspAutoSendMsg["4")){
		Set xInfectDesc=""
		For{
			Set xInfectDesc = $o(MsgArray(xInfectDesc))
			Quit:xInfectDesc=""
			Set xCasesXID=""
			For{
				Set xCasesXID = $o(MsgArray(xInfectDesc,xCasesXID))
				Quit:xCasesXID=""
				Continue:xCasesXID<=0
				Set TComments	= MsgArray(xInfectDesc,xCasesXID)
				Set CommentInfo	= "该患者检查报告结果为："_TComments_"疑似"_xInfectDesc_"传染病，请及时上报！"
				Set SendMessage = ##class(websys.DHCMessageInterface).Send(CommentInfo,"1018","^med",aEpisodeID,"","","{""linkParam"":""EpisodeID="_aEpisodeID_""",""dialogWidth"":""1340px"",""dialogHeight"":""90%""}","","","")
			}
		}
	}
	Quit Count
	
CheckRISErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2019-01-30
/// Description:  检查(RIS)关键词检索判断是否传染病
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       aKeys : 检查诊断描述
/// Return：      返回String
/// w ##class(DHCMed.EPDService.AutoTask).GetRISCheck("脓性分泌物")
ClassMethod GetRISCheck(aKeys As %String) As %String
{
	new (aKeys)
	Set return=""
	Quit:(aKeys="") return
	
	Set RstList=""
	Set Isflg = 0, Noflg = 0
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspScreeningI("IdxofType","R",xID))
		Quit:xID=""
		Continue:(Isflg=1)&&(Noflg'=1)  //传染病不再检索
			
		Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(xID)
		Continue:'$Isobject(objScr)
		Continue:'$Isobject(objScr.BTInfectDr)
		Set IsActive = objScr.BTIsActive
        Continue:IsActive'=1
       
		Set IncludeKey  = objScr.BTIncludeKey 
		Set ExcludeKeys = objScr.BTExcludeKeys
	 
		If (aKeys[IncludeKey) {
			 Set Isflg=1
		}
		If (ExcludeKeys'="") {
			For ind=1:1:$l(ExcludeKeys,"#") {
				Set ExcludeKey=$p(ExcludeKeys,"#",ind)
				Continue:ExcludeKey=""
				Continue:Noflg=1
				Set Noflg=1
				
				Continue:(aKeys[$zcvt(ExcludeKey,"U"))
				Set Noflg=0
			}
		}
		If (Isflg=1)&&(Noflg'=1) {   //是传染病
			Set RstList=RstList_$lb(xID)
		}		
	}
	
	For indx=1:1:$listlength(RstList) {
		Set ScreenDr=$list(RstList,indx)
		Continue:ScreenDr=""
		Set return=return_","_ScreenDr
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

}
