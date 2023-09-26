/// 名称: DHCMed.EPDService.SuspLabReport
/// 描述: 传染病监控与检验相关服务
/// 编写者：pylian
/// 编写日期: 2019-02-01
Class DHCMed.EPDService.SuspLabReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-02-01
/// Description:  检验项目（支持一天内送检，多份报告结果中的检验项目异常判定一种传染病）
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID : 就诊号
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspLabReport).CheckLIS(395,"2019-04-01","2019-05-08")
ClassMethod CheckLIS(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aEpisodeID,aDateFrom,aDateTo)
	Set return=0,Count=0
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return

	Set MRADMDR=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRADMDR="" return

	Set AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set AdmHospID = +$p($g(^CTLOC(+AdmLoc)),"^",22)
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	Set:AdmReadm="" AdmReadm="A"
	
	Set PatinetSex=""
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)         //病人ID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID) // 患者性别
	Set:$IsObject(objPatient) PatinetSex=objPatient.Sex
	
	Set $ZT="CheckLISErr"
	
	Set TCCodes=##class(DHCMed.EPDService.SuspTestCodeSrv).GetTestCode()
	Kill arrTCResult
	 //检验版本
    Set LabRepVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSLabReportVer")
	If LabRepVer="LIS1.0" {
		//直接从东华检验1.0取值
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis1Srv:QryLabVisitRepItem")
	} ElseIf LabRepVer="LIS2.0" {
		//直接从东华检验2.0取值
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:QryLabVisitRepItem")
	} ElseIf LabRepVer="LISC1.0" {
		//从平台组数据中心取值
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.EnsSyncLis1Srv:QryLabVisitRepItem")
	} ElseIf LabRepVer="LISC2.0" {
		//iMedical8.4之后统一从平台组HIS结构中取值
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.EnsSyncLis2Srv:QryLabVisitRepItem")
	} Else {
		//默认iMedical8.4之后统一从平台组HIS结构中取值
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.EnsSyncLis2Srv:QryLabVisitRepItem")
	}
	Set sc=rs.Execute(aEpisodeID,aDateFrom,aDateTo,TCCodes)
	Set return=0,Count=0	//重新初始化(Query调用会覆盖相同变量名) add by mayanpeng
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set VisitNumberID=rs.Data("VisitNumberID")          //送检ID
	    Set EpisodeNo=rs.Data("EpisodeNo")
	    Set SpecCode=rs.Data("SpecCode")
	    Set SpecDesc=rs.Data("SpecDesc")
	    Set LocID=rs.Data("LocID")
	    Set LocDesc=rs.Data("LocDesc") 
        Set CollDate=rs.Data("CollDate")
	    Set CollTime=rs.Data("CollTime")
	    Set CollUserCode=rs.Data("CollUserCode")
	    Set CollUserName=rs.Data("CollUserName")
	    Set RecDate=rs.Data("RecDate")
	    Set RecTime=rs.Data("RecTime")
	    Set RecUserCode=rs.Data("RecUserCode")
	    Set RecUserName=rs.Data("RecUserName")
	    Set WardID=rs.Data("WardID")
	    Set WardDesc=rs.Data("WardDesc")
	    Set TestSetStr=rs.Data("TestSetStr")  //医嘱信息
	    
	    Set ReportID = rs.Data("ReportID")         
		Set TestSetRow = rs.Data("TestSetRow")     
		Set Order = rs.Data("Order")               
		Set RepStatus = rs.Data("RepStatus")       
		Set RegDate = rs.Data("RegDate")           
		Set RegTime = rs.Data("RegTime")           
		Set RegUserCode = rs.Data("RegUserCode")   
		Set RegUserName = rs.Data("RegUserName")   
		Set AuthDate = rs.Data("AuthDate")         
		Set AuthTime = rs.Data("AuthTime")         
		Set AuthUserCode = rs.Data("AuthUserCode") 
		Set AuthUserName = rs.Data("AuthUserName")
		
		Set TCResultID = rs.Data("TCResultID")
		Set TCID = rs.Data("TCID")
		Set TCCode = rs.Data("TCCode")
		Set TCDesc = rs.Data("TCDesc")
		Set TCRstFormat = rs.Data("TCRstFormat")
		Set TCResult = rs.Data("TCResult")
		Set TCTextRes = rs.Data("TCTextRes")
		Set TCAbFlag = rs.Data("TCAbFlag")
		Set TCRefRanges = rs.Data("TCRefRanges")
		
    	Set Comments = TCResult
		Set arrTCResult(RecDate,TCCode,TCResultID)=$lb(VisitNumberID,SpecCode,SpecDesc,TCResultID,TCID,TCCode,TCDesc,TCRstFormat,TCResult,TCTextRes,TCAbFlag,TCRefRanges,EpisodeNo,ReportID,RecDate,RecTime,RecUserName,RegDate,RegTime,RegUserName,AuthDate,AuthTime,AuthUserName,TestSetStr)
	}
    //检验项目判断
	Set RstList=""
	Set xScreeningID=""
	For {
		Set xScreeningID=$o(^DHCMed.EPD.SuspScreeningI("IdxofType","L",xScreeningID))
		Quit:xScreeningID=""
		
		Set objScr=##class(DHCMed.EPD.SuspScreening).GetObjById(xScreeningID)
		Continue:'$Isobject(objScr)
		Continue:'$Isobject(objScr.BTInfectDr)
		Set IsActive=objScr.BTIsActive
        Continue:IsActive'=1
		Set LisItems = objScr.BTLisItems  //检验项目
		Continue:LisItems=""
		Set LisLogic = objScr.BTLisLogic   //逻辑运算
		Set lisKeyWords = objScr.BTExcludeKeys // 排除关键字
		
		//arrTCResult(RegDate,TCCode,TCResultID)
		Set xRecDate=""
		For {
			Set xRecDate=$o(arrTCResult(xRecDate))
			Quit:xRecDate=""
			
			//判断是否满足并且条件
			Set LisLogicCnt=0,LisLogicDate="",LisLogicItem=""
			For indx=1:1:$l(LisItems,",") {
				Set LisItemDr=$p(LisItems,",",indx)
				Continue:LisItemDr=""
				Set objTest=##class(DHCMed.EPD.SuspTestCode).GetObjById(LisItemDr)
				Continue:'$Isobject(objTest)
				Set STCDesc=objTest.BTDesc
				
				//判断是否满足单个条件
			    Set IsAbFlag=0,IsAbDate="",IsAbItemList=""
				Set xSubID=""
				For {
					Set xSubID=$o(^DHCMed.EPD.SuspTestCodeD(LisItemDr,"EXT",xSubID))
					Quit:xSubID=""
					Quit:IsAbFlag=1
					
					Set ExtID =LisItemDr_"||"_xSubID
					Set objExt=##class(DHCMed.EPD.SuspTestCodeExt).GetObjById(ExtID)
					Continue:'$Isobject(objExt)
					Continue:objExt.IsActive'=1
					
					Set TestCode      = objExt.TestCode 
				    Set TestDesc      = objExt.TestDesc 
				    Set SpecCode      = objExt.SpecCode   
				    Set SpecDesc      = objExt.SpecDesc   
				    Set ResultType    = objExt.ResultType  //结果类型
				    Set ResultUnit    = objExt.ResultUnit  
				    Set CompValueMax  = objExt.CompValueMax
				    Set CompValueMin  = objExt.CompValueMin
				    Set CompValues    = objExt.CompValues  //结果比较值(List等于、Key包含）多值!!分隔
				    Set PatSex = ""
				    Set PatSex		  = objExt.PatSex	// 性别
				    Set objSex 		  = ##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDPetSex",PatSex,"1")
				    Set:$IsObject(objSex) PatSex = objSex.Description
	   			 	Continue:((PatSex'="")&&(PatSex'=PatinetSex))
					Continue:TestCode=""
					
				    Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(TestCode)
				    Continue:'$IsObject(objTC)
				    Set TCCode = objTC.BTCode       //对应LIS检验项目代码
				    Set TCDesc = objTC.BTDesc
				    Continue:TCCode=""
				    
				    Set xResultID=""
				    For {
					    Set xResultID=$o(arrTCResult(xRecDate,TCCode,xResultID))
					    Quit:xResultID=""
					    
					    Set ResultData=$g(arrTCResult(xRecDate,TCCode,xResultID))
					    Continue:ResultData=""
					    
					    //$lb(VisitNumberID,SpecCode,SpecDesc,TCResultID,TCID,TCCode,TCDesc,TCRstFormat,TCResult,TCTextRes,TCAbFlag,TCRefRanges,EpisodeNo,ReportID,RecDate,RecTime,RecUserName,RegDate,RegTime,RegUserName,AuthDate,AuthTime,AuthUserName,TestSetStr)
					  	Set TCSpecCode  = $lg(ResultData,2)	      //检验标本代码
					  	Set TCSpecDesc  = $lg(ResultData,3)	      //检验标本名称
					  	Set TCResultID  = $lg(ResultData,4)	      //检测结果ID
						Set TCCode      = $lg(ResultData,6)	      //检验项目代码
						Set TCDesc      = $lg(ResultData,7)	      //检验项目名称
						Set TCRstFormat = $lg(ResultData,8)       //结果类型
						Set TCResult	= $lg(ResultData,9)	      //检测结果
						Set TCTextRes	= $lg(ResultData,10)	  //定性结果
						Set TCAbFlag	= $lg(ResultData,11)	  //异常提示
						Set TCRefRanges = $lg(ResultData,12)      //参考范围
						Set AuthDate    = $lg(ResultData,21)      //审核日期
						Continue:(TCResult="")&&(TCTextRes="")
						Continue:(SpecDesc'="")&&(TCSpecDesc'=SpecDesc)  //检验标本不为空时，比较标本
						// 先判断疑似筛查条件中的，排除关键字
				    	If (lisKeyWords'="") {
							For ind=1:1:$l(lisKeyWords,"#") {  //排除关键词列表
								Set lisKeyWord=$p(lisKeyWords,"#",ind)
								Continue:lisKeyWord=""
								Continue:(($zcvt(lisKeyWord,"U")[$zcvt(TCTextRes,"U"))||($zcvt(lisKeyWord,"U")[$zcvt(TCResult,"U")))
								Set IsAbFlag=1
								Quit
							}
						}
						
						If (ResultType="N") {   //数值类型比较大小,不能同时为空
							Continue:(CompValueMax="")&&(CompValueMin="")
							
							//特殊检验结果处理($ZPOWER为幂函数,10的n次方)
							Set:((TCResult["E+")||(TCResult["e+")) TCResult=$p(TCResult,"E+",1) * $ZPOWER(10,+$p(TCResult,"E+",2))
							Set:((CompValueMax["E+")||(CompValueMax["e+")) CompValueMax=$p(CompValueMax,"E+",1) * $ZPOWER(10,+$p(CompValueMax,"E+",2))
							Set:((CompValueMax["E+")||(CompValueMax["e+")) CompValueMin=$p(CompValueMin,"E+",1) * $ZPOWER(10,+$p(CompValueMin,"E+",2))
							
							If ((CompValueMax'="")&&(+TCResult>CompValueMax)) {  //结果大于最大值 属于异常
								Set IsAbFlag=1	
							}
							If ((CompValueMin'="")&&(+TCResult<CompValueMin)) {	//或小于最小值属于异常
								Set IsAbFlag=1
							}
						} ElseIf (ResultType="L") {   //列表类型相等
							Set CompValue=""
							For indy=1:1:$l(CompValues,"!!") {
								Set CompValue=$p(CompValues,"!!",indy)
								Continue:CompValue=""
								Continue:((CompValue'=TCTextRes)&&(CompValue'=TCResult))
								Set IsAbFlag=1
								Quit
							}
						} ElseIf (ResultType="K") {   //关键词类型包含
							Set CompValue=""
							For indz=1:1:$l(CompValues,"!!") {
								Set CompValue=$p(CompValues,"!!",indz)
								Continue:CompValue=""
								Continue:((TCTextRes'[CompValue)&&(TCResult'[CompValue))
								Set IsAbFlag=1
								Quit
							}
						}
						Continue:IsAbFlag<1
						
						Set:IsAbDate="" IsAbDate=AuthDate
						Set IsAbItemList=IsAbItemList_$lb(ResultData)
					}
				}
				Continue:IsAbFlag<1
				
				Set LisLogicCnt=LisLogicCnt+1
				Set LisLogicItem=LisLogicItem_IsAbItemList
				Set:LisLogicDate="" LisLogicDate=IsAbDate
			}
			Continue:LisLogicCnt<$l(LisItems,",")
			
			Set RstList=RstList_$lb($lb(xScreeningID,xRecDate,LisLogicDate,LisLogicItem))
		}
	}
	Quit:RstList="" return
	
    Set ScreenDr=""
    For indL=1:1:$ll(RstList) {
        Set tScreenInfo=$lg(RstList,indL)
        Continue:tScreenInfo=""
        Set ScreenDr=$listget(tScreenInfo,1)
        Set RegDate=$listget(tScreenInfo,2)
        Set AuthDate=$listget(tScreenInfo,3)
        Set ResultList=$listget(tScreenInfo,4)
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
		Set inputStr=inputStr_"^"_LocID
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
		Set inputStr=inputStr_"^"_AuthDate
		
		Set CasesXID=##class(DHCMed.EPD.CasesX).Update(inputStr,"^")
			
		//记录诊断和是否保存成功，发消息使用
		Set MsgArray(InfectDesc,CasesXID)=Comments
			
		If (+CasesXID)>0 {
			Set Count=Count+1
			
			//保存明细
			For indRst=1:1:$ll(ResultList) {
				Set tResult=$lg(ResultList,indRst)
				Continue:tResult=""
				
				//$lb(VisitNumberID,SpecCode,SpecDesc,TCResultID,TCID,TCCode,TCDesc,TCRstFormat,TCResult,TCTextRes,TCAbFlag,TCRefRanges,EpisodeNo,ReportID,RecDate,RecTime,RecUserName,RegDate,RegTime,RegUserName,AuthDate,AuthTime,AuthUserName,TestSetStr)
				Set VisitNumberID= $lg(tResult,1)
				Set SpecDesc     = $lg(tResult,3)
				Set TCResultID   = $lg(tResult,4)
				Set TCDesc       = $lg(tResult,7)
				Set TCResult     = $lg(tResult,9)
				Set EpisodeNo    = $lg(tResult,13)
				Set ReportID     = $lg(tResult,14)
				Set TestSetStr   = $lg(tResult,24)
				Set RegUserName  = $lg(tResult,17)
				Set RegDate      = $lg(tResult,18)
				Set RegTime      = $lg(tResult,19)
				Continue:EpisodeNo=""
				
				Set TestCodeStr="["_SpecDesc_"]"_TCDesc
				
				Set xSubID = ""
				Set xSubID=$o(^DHCMed.EPD.CasesXI("DTL","IndexScreenResultID",CasesXID,ScreenDr,TCResultID,xSubID))
				
				//保存筛查明细
				Set inputSub=CasesXID
				Set inputSub=inputSub_"^"_xSubID
				Set inputSub=inputSub_"^"_ScreenDr
				Set inputSub=inputSub_"^"_"LIS:"_VisitNumberID_"#"_EpisodeNo_"#"_ReportID_"#"_$tr(TestSetStr,"#","$")_"#"_TestCodeStr
				Set inputSub=inputSub_"^"_RegDate
				Set inputSub=inputSub_"^"_RegTime
				Set inputSub=inputSub_"^"_1
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_RecUserName
				Set inputSub=inputSub_"^"_TCResultID
				Set flg=##class(DHCMed.EPD.CasesXDtl).Update(inputSub,"^")
			}
		}
    }
	//遍历是否需要发送消息
	Set EpdSuspAutoSendMsg = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdSuspAutoSendMsg",AdmHospID)	// 传染病筛查后自动发消息
	// 发送全部或发送检验异常的
	If ((EpdSuspAutoSendMsg["1")||(EpdSuspAutoSendMsg["3")){
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
				Set CommentInfo	= "该患者检验报告结果为："_TComments_"疑似"_xInfectDesc_"传染病，请及时上报！"
				Set SendMessage = ##class(websys.DHCMessageInterface).Send(CommentInfo,"1018","^med",aEpisodeID,"","","{""linkParam"":""EpisodeID="_aEpisodeID_""",""dialogWidth"":""1340px"",""dialogHeight"":""90%""}","","","")
			}
		}
	}
	Quit Count
	
CheckLISErr
	Quit "-999^"_$ZError
}

}
