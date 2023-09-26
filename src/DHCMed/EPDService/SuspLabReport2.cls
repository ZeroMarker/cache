/// 名称: DHCMed.EPDService.SuspLabReport2
/// 描述: 传染病监控与检验相关服务
/// 编写者：pylian
/// 编写日期: 2019-02-01
Class DHCMed.EPDService.SuspLabReport2 Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-02-01
/// Description:  检验项目
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID : 就诊号
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspLabReport2).CheckLIS(1416,"2016-01-01","2019-02-28")
ClassMethod CheckLIS(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aEpisodeID,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	Set MRADMDR=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRADMDR="" return
	Quit:'$d(^MR(MRADMDR,"DIA")) return
	
	Set AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	Set:AdmReadm="" AdmReadm="A"
	
	Set $ZT="CheckLIS2Err"
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:QryLabVisitReport")
	Set sc=rs.Execute(aEpisodeID,aDateFrom,aDateTo)
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
		    
        Set RstList = ..GetLISCheck(ReportID,SpecDesc)   //检验项目判断
		Continue:RstList=""

        Set ScreenDr=""
        For indL=1:1:$l(RstList,",") {
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
			Set inputStr=inputStr_"^"_RecDate
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
			
			If (+CasesXID)>0 {
				Set Count=Count+1
				Set xSubID = ""
				Set xSubID=$o(^DHCMed.EPD.CasesXI("DTL","IndexScreenDateTime",CasesXID,ScreenDr,RecDate,RecTime,xSubID))

				//保存筛查明细
				Set inputSub=CasesXID
				Set inputSub=inputSub_"^"_xSubID
				Set inputSub=inputSub_"^"_ScreenDr
				Set inputSub=inputSub_"^"_"LIS:"_VisitNumberID_"#"_EpisodeNo_"#"_ReportID_"#"_TestSetStr
				Set inputSub=inputSub_"^"_RecDate
				Set inputSub=inputSub_"^"_RecTime
				Set inputSub=inputSub_"^"_1
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_RecUserName 
				Set flg=##class(DHCMed.EPD.CasesXDtl).Update(inputSub,"^")			
			}
        }
	}

	Quit Count
	
CheckLIS2Err
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2019-02-02
/// Description:  检验(LIS)检索判断是否传染病
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       aReportID : 检验报告
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspLabReport2).GetLISCheck("40647")
ClassMethod GetLISCheck(aReportID As %String, aSpecDesc As %String = "") As %String
{
	new (aReportID,aSpecDesc)
	Set return=""
	Quit:(aReportID="") return
	
	Set RstList=""
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspScreeningI("IdxofType","L",xID))
		Quit:xID=""
		
		Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(xID)
		Continue:'$Isobject(objScr)
		Continue:'$Isobject(objScr.BTInfectDr)
		Set IsActive = objScr.BTIsActive
        Continue:IsActive'=1
        
		Set LisItems = objScr.BTLisItems  //检验项目
		Continue:LisItems=""
	
		Set LisLogic = objScr.BTLisLogic   //逻辑运算
		Set LisItemDr="" ,AbLists=""
		For indx=1:1:$l(LisItems,",") {
			Set LisItemDr=$p(LisItems,",",indx)
			Continue:LisItemDr=""
			Set objTest=##class(DHCMed.EPD.SuspTestCode).GetObjById(LisItemDr)
			Continue:'$Isobject(objTest)
		    
		    Set IsAbFlag = 0 
			Set xSubID = ""
			For {
				Set xSubID = $o(^DHCMed.EPD.SuspTestCodeD(LisItemDr,"EXT",xSubID))
				Quit:xSubID=""
				Set ExtID =LisItemDr_"||"_xSubID
				Set objExt=##class(DHCMed.EPD.SuspTestCodeExt).GetObjById(ExtID)
				Continue:'$Isobject(objExt)
				Continue:objExt.IsActive'=1 
				Continue:IsAbFlag=1
				
				Set TestCode      = objExt.TestCode 
				Continue:TestCode=""
			    Set TestDesc      = objExt.TestDesc 
			    Set SpecCode      = objExt.SpecCode   
			    Set SpecDesc      = objExt.SpecDesc   
			    Continue:(SpecDesc'="")&&(aSpecDesc'=SpecDesc)  //检验标本不为空时，比较标本 
			    Set ResultType    = objExt.ResultType  //结果类型  
			    Set ResultUnit    = objExt.ResultUnit  
			    Set CompValueMax  = objExt.CompValueMax
			    Set CompValueMin  = objExt.CompValueMin
			    Set CompValues    = objExt.CompValues  //结果比较值(List等于、Key包含）多值!!分隔
			    
			    Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(TestCode) 
			    Continue:'$IsObject(objTC)
			    Set TCID = $p(TestCode,"!!",1)  //对应LIS检验项目ID
			    Set TCCode = objTC.BTCode       //对应LIS检验项目代码
			    Set TCDesc = objTC.BTDesc
			
			    Set ResultData =..GetTestCodeResult(aReportID,TCID)
			    Set ResultData = $lg(ResultData)
			    Continue:ResultData=""
				
			  	Set ResultID  = $p(ResultData,"^",1)	  //检测结果ID
				Set TestCodeCode = $p(ResultData,"^",2)	  //检验项目代码
				Set TestCodeDesc = $p(ResultData,"^",3)	  //检验项目名称
				Set RstFormat = $p(ResultData,"^",4)      //结果类型
				Set Result	  = $p(ResultData,"^",5)	  //检测结果
				Set TextRes	  = $p(ResultData,"^",6)	  //定性结果
				Set ResNoes	  = $p(ResultData,"^",8)	  //结果说明(备注)
				Set AbFlag	  = $p(ResultData,"^",9)	  //异常提示
				Set Unit	  = $p(ResultData,"^",11)     //单位
				Set RefRanges = $p(ResultData,"^",12)     //参考范围
				Set MDRResult = $p(ResultData,"^",27)     //多耐结果
				Continue:(Result="")&&(TextRes="")
				;b ;LIS
				If (ResultType="N") {   //数值类型比较大小,不能同时为空
					Continue:(CompValueMax="")&&(CompValueMin="")
					If ((+Result>CompValueMax)||(+Result<CompValueMin)) {  //结果大于最大值或小于最小值属于异常
						
						Set IsAbFlag = 1	
											
					}
				}

				If (ResultType="L") {   //列表类型相等
					Set CompValue=""
					For indy=1:1:$l(CompValues,"!!") {
						Set CompValue=$p(CompValues,"!!",indy)
						Continue:CompValue=""
						Continue:IsAbFlag=1
						Continue:CompValue'=Result
						Set IsAbFlag =1
					}
				}
				If (ResultType="K") {   //关键词类型包含
					Set CompValue=""
					For indz=1:1:$l(CompValues,"!!") {
						Set CompValue=$p(CompValues,"!!",indz)
						Continue:CompValue=""
						Continue:IsAbFlag=1
						Continue:Result'[CompValue
						Set IsAbFlag =1
					}
				}

			    /*
				If (AbFlag'="") { //有异常标志
					Set IsAbFlag = 1    
				}
				*/
				
			}
		 
			If (IsAbFlag=1) {
				Set AbLists = AbLists_","_LisItemDr
			}
		}
		Set:AbLists'="" AbLists=$e(AbLists,2,$l(AbLists))			
		If (AbLists=LisItems) {
			Set RstList=RstList_$lb(xID)
		}	
	}

	For indt=1:1:$listlength(RstList) {
		Set ScreenDr=$list(RstList,indt)
		Continue:ScreenDr=""
		Set return=return_","_ScreenDr
	}
	Set:return'="" return=$e(return,2,$l(return))

	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-03-07
/// Description:  通过检验报告ID、检验项目ID取检验项目结果
/// Input：       aReportID:检验报告ID
/// Input：       aTCID:检验项目ID
/// Return：      标本信息
/// w ##Class(DHCMed.EPDService.SuspLabReport2).GetTestCodeResult("40110","")
ClassMethod GetTestCodeResult(aReportID As %String, aTCID As %String) As %List
{
	New (aReportID,aTCID)
	Set return=""
	Quit:(aReportID="")||(aTCID="") return	
	
	Set xResultID = ""
	For {
		Set xResultID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,aTCID,xResultID))
		Quit:xResultID=""
		
		Set ResultData=$g(^dbo.RPVisitNumberReportResultD(xResultID))
		Continue:ResultData=""
		
		Set TestCodeData    = $g(^dbo.BTTestCodeD(aTCID))
		Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
		Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
		Set RstFormat       = $lg(TestCodeData,9) //结果类型
		Set:RstFormat="X" RstFormat = "T" 	//文本格式
		Set Result			= $lg(ResultData,5)	  //检测结果
		Set TextRes			= $lg(ResultData,6)	  //定性结果
		Set ResNoes			= $lg(ResultData,8)	  //结果说明(备注)
		Set AbFlag			= $lg(ResultData,9)	  //异常提示
		Set Unit			= $lg(ResultData,11)  //单位
		Set RefRanges  	 	= $lg(ResultData,12)  //参考范围
		Set MDRResult   	= $lg(ResultData,27)  //多耐结果
	
		Set ResultData = xResultID_"^"_TestCodeCode_"^"_TestCodeDesc_"^"_RstFormat_"^"_Result_"^"_TextRes
		_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
	
		 //特殊不可见字符处理
		Set ResultData=$tr(ResultData,$c(0),"")
		Set ResultData=$tr(ResultData,$c(1),"")
		Set ResultData=$tr(ResultData,$c(10),"")
		Set ResultData=$tr(ResultData,$c(13),"")
		
		Set return = return_$lb(ResultData)

	} 	
   
 	
	Quit return
	
GetTestCodeResultErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

}
