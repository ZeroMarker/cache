/// 名称: DHCMed.EPDService.SuspLabReport1
/// 描述: 传染病监控与检验相关服务
/// 编写者：pylian
/// 编写日期: 2019-02-26
Class DHCMed.EPDService.SuspLabReport1 Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-02-26
/// Description:  检验项目
/// Table：       
/// Input：       aEpisodeID : 就诊号
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspLabReport1).CheckLIS(1416,"2016-01-01","2019-02-28")
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
	
	Set $ZT="CheckLIS1Err"
	
	Set rs=##Class(%ResultSet).%New("DHCMed.EPDService.SuspLabReport1:QryLabVisitReport")
	Set sc=rs.Execute(aEpisodeID,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	  Do rowData.Clear()  //清空数组
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
	
CheckLIS1Err
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2019-02-27
/// Description:  检验(LIS)检索判断是否传染病
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       aReportID : 检验报告
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspLabReport1).GetLISCheck("40647")
ClassMethod GetLISCheck(aReportID As %String, aSpecDesc As %String = "") As %String
{
	new (aReportID,aSpecDesc)
	Set return=""
	Quit:(aReportID="") return
	
	Set RstList="",RstItem=""
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
			    
				Set LabResult=..GetTestCodeResult(aReportID,TCID)
				Continue:LabResult=""
				
				Set ItemResult=$p(LabResult,$c(2),3)  //结果
				Set ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
				Set AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
				Set ItemRangs=$p(LabResult,$c(2),6)   //参考范围
				Set RstFormat=$p(LabResult,$c(2),8)   //输出数据类型
			    Set Comments =$p(LabResult,$c(2),9)   //备注
			    
				If (ResultType="N") {   //数值类型比较大小
					If ((ItemResult>CompValueMax)||(ItemResult<CompValueMin)) {  //结果大于最大值或小于最小值属于异常
						Set IsAbFlag = 1						
					}
				}
				If (ResultType="L") {   //列表类型相等
					Set CompValue=""
					For indy=1:1:$l(CompValues,"!!") {
						Set CompValue=$p(CompValues,"!!",indy)
						Continue:CompValue=""
						Continue:IsAbFlag=1
						Continue:CompValue'=ItemResult
						Set IsAbFlag =1
					}
				}
				If (ResultType="K") {   //关键词类型包含
					Set CompValue=""
					For indz=1:1:$l(CompValues,"!!") {
						Set CompValue=$p(CompValues,"!!",indz)
						Continue:CompValue=""
						Continue:IsAbFlag=1
						Continue:(ItemResult'[CompValue)&&(Comments'[CompValue)
						Set IsAbFlag =1
					}
				}
				
				If (AbnorFlag'="") { //有异常标志
					Set IsAbFlag = 1    
				}
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
/// CreatDate：   2019-02-26
/// Description:  查询接收标本记录（传染病检验项目相关）
/// Table：       
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspLabReport1","QryLabVisitNumber","1416","2016-01-01","2019-02-18")
Query QryLabVisitNumber(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocID:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardID:%String,WardDesc:%String,TestSetStr:%String")
{
}

ClassMethod QryLabVisitNumberExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aEpisodeID'="" {
		Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
		Quit:OrdID="" $$$OK
		Set AdmStr=$g(^PAADM(aEpisodeID))
		Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
		Quit:(AdmType'="I")&(AdmType'="E") $$$OK
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
			Quit:xArcimID=""
			
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 	Continue:'$IsObject(objArcim)
		 	Set ArcimType=objArcim.ARCICOrderType
		 	Continue:ArcimType'="L"
		 	
			Set xSttDate=0
			For {
				Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate))
				Quit:xSttDate=""
				
				Set xSub=0
				For {
					Set xSub=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate,xSub))
					Quit:xSub=""
					
					Set xEpis=$p($g(^OEORD(OrdID,"I",xSub,3)),"^",20)
					Continue:xEpis=""
					
					Set VisitNumberData=$g(^TEPI(xEpis))
					Continue:VisitNumberData=""
					Set CollDate=$p(VisitNumberData,"\",10) //采集标本时间
					Set RecDate=$p(VisitNumberData,"\",32)  //接收标本时间
					Set:RecDate="" RecDate=CollDate
					Continue:RecDate=""
					Continue:RecDate<aDateFrom
					Continue:RecDate>aDateTo
					
					Set VisitNumberDr=xEpis
					Set Data=..BuildVisitNumber(VisitNumberDr)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} Else {
		//标本采集日期
		//检验号基本信息EP_VisitNumber
		//^TDAY(1,{EPVIS_DateOfCollection},{EPVIS_StatusPatient},{EPVIS_VisitNumber})
		//接收标本日期(无结果)
		//检验号基本信息EP_VisitNumber
		//^TDAY(6,{EPVIS_DateOfReceiving},{EPVIS_StatusPatient},{EPVIS_VisitNumber})
		For xDate=aDateFrom:1:aDateTo {
			Set IndexNote=$s($d(^TDAY(6,xDate)):6,1:1)
			Set xStatus=""
			For {
				Set xStatus=$o(^TDAY(IndexNote,xDate,xStatus))
				Quit:xStatus=""
				
				Set xEpis=0
				For {
					Set xEpis=$o(^TDAY(IndexNote,xDate,xStatus,xEpis))
					Quit:xEpis=""
					
					Set VisitNumberData=$g(^TEPI(xEpis))
					Continue:VisitNumberData=""
					Set EpisodeID=..GetEpisodeIDByLab(xEpis)
					Continue:EpisodeID=""
					Set AdmStr=$g(^PAADM(EpisodeID))
					Set AdmType=$p(AdmStr,"^",2)	   //就诊类型
					Continue:(AdmType'="I")&(AdmType'="E")
					
					Set VisitNumberDr=xEpis
					Set Data=..BuildVisitNumber(VisitNumberDr)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabVisitNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitNumberExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-08-21
/// Description:  组织Query输出标本记录
/// Input：       aVisitNumberID : 标本ID
/// Return：      返回List
/// w ##Class(DHCMed.EPDService.SuspLabReport1).BuildVisitNumber(40110)
ClassMethod BuildVisitNumber(aVisitNumberID As %String, ByRef errMsg As %String = "") As %List
{
	New (aVisitNumberID,errMsg)
	Set return=""
	Quit:(aVisitNumberID="") return
	
	Set $ZT="BuildVisitNumberErr"
	
	Set VisitNumberData=..GetVisitNumber(aVisitNumberID)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<17 return
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr=""
	Set TestSetInfo=..GetVisitTestSet(aVisitNumberID)
	
	For indTS=1:1:$ll(TestSetInfo) {
		Set tData=$listget(TestSetInfo,indTS)
		Continue:tData=""
		Set TSCode=$listget(tData,2)
		Set TSDesc=$listget(tData,3)
		Set ArcimCode=$listget(tData,4)
		Set ArcimDesc=$listget(tData,5)
		Set OEOrdItemID=$listget(tData,7)
		If TestSetStr="" {
			Set TestSetStr=TSCode_"#"_TSDesc_"#"_OEOrdItemID_"#"_ArcimCode_"#"_ArcimDesc
		} Else {
			Set TestSetStr=TestSetStr_"!!"_TSCode_"#"_TSDesc_"#"_OEOrdItemID_"#"_ArcimCode_"#"_ArcimDesc
		}
	}
	Quit:TestSetStr="" return

	Set return=$list(VisitNumberData,1,17)
	Set return=return_$lb(TestSetStr)
	Quit return
	
BuildVisitNumberErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  通过标本ID取标本信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCMed.EPDService.SuspLabReport1).GetVisitNumber(40110)
ClassMethod GetVisitNumber(aVisitNumberID As %String) As %List
{
	New (aVisitNumberID)
	Set return=""
	Quit:(aVisitNumberID="") return
	
	Set VisitNumberData=$g(^TEPI(aVisitNumberID))
	Quit:VisitNumberData="" return
	Set EpisodeNo=aVisitNumberID  // 检验号/标本号
	Set EpisodeID=..GetEpisodeIDByLab(EpisodeNo)  // 就诊号
	Quit:EpisodeID="" return
	
	Set (SpecCode,SpecDesc,CollDate,CollTime,CollUser,RecDate,RecTime,RecUser,LocCode,LocDesc,WardCode,WardDesc)=""
	Set OEItemIDs=..GetOEItemIDsByLab(EpisodeNo)
	Quit:OEItemIDs="" return
	For indOE=1:1:$l(OEItemIDs,",") {
		Set OEItemID=$p(OEItemIDs,",",indOE)
		Continue:OEItemID=""
		
		Set OrdID=$p(OEItemID,"||",1)
		Set SubID=$p(OEItemID,"||",2)
		Continue:(OrdID="")||(SubID="")
		
		//标本
		If SpecDesc="" {
			Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
			Set:SpecDr'="" SpecCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
			Set:SpecCode'="" SpecDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
			If SpecDesc="" {
				Set SpecCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
				Set:SpecCode'="" SpecDesc=$p($g(^DHCSpS("SPS",SpecCode)),"^",2)
			}
		}
		
		//采集日期时间
		If CollDate="" {
			Set CollDateTime=..GetCollDateTime(OEItemID)
			Set CollDate=$p(CollDateTime,"^",1)
			Set CollTime=$p(CollDateTime,"^",2)
			Set CollUser=$p(CollDateTime,"^",3)
			If CollDate="" {
				Set OrdExecId=$o(^DHCOrdExec(0,"DHCOEORI",OEItemID,""),-1)
				If $l(OrdExecId){
					Set CollDate=$p($g(^DHCOrdExec(OrdExecId)),"^",13)
					Set CollTime=$p($g(^DHCOrdExec(OrdExecId)),"^",14)
				}
			}
		}
		
		//接收日期时间
		If RecDate="" {
			Set RecDateTime=..GetRecDateTime(OEItemID)
			Set RecDate=$p(RecDateTime,"^",1)
			Set RecTime=$p(RecDateTime,"^",2)
			Set RecUser=$p(RecDateTime,"^",3)
			If RecDate="" {
				Set LabTestSetRow=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",35)
				If LabTestSetRow'="" {
					Set LabNo=+LabTestSetRow
					Set TS=$p(LabTestSetRow,"||",2)		//updae by liuyh 2018-03-20 bug修复
					Set TSCnt=+$p(LabTestSetRow,"||",3)
					Set RecDate=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",21)
					If $l(RecDate) Set RecDate=RecDate
					Set RecTime=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",22)
					If $l(RecTime) Set RecTime=RecTime*60
				}
			}
		}
		
		//申请科室
		If LocDesc="" {
			Set LocDr=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",3)
			Set:LocDr'="" LocCode=$p($g(^CTLOC(LocDr)),"^",1)
			Set:LocDr'="" LocDesc=$p($g(^CTLOC(LocDr)),"^",2)
		}
		
		//开医嘱时病人所在病区
		If WardDesc="" {
			Set WardDr=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",2)
			Set:WardDr'="" WardCode=$p($g(^CTLOC(WardDr)),"^",1)
			Set:WardDr'="" WardDesc=$p($g(^CTLOC(WardDr)),"^",2)
		}

	}
	Set CollUserCode=$p(CollUser,"|",2)
	Set CollUserName=$p(CollUser,"|",3)
	Set RecUserCode=$p(RecUser,"|",2)
	Set RecUserName=$p(RecUser,"|",3)
	
	Set return=$lb(aVisitNumberID)
	Set return=return_$lb(EpisodeID)       //就诊号
	Set return=return_$lb(EpisodeNo)       //检验号 对应医嘱表OEORI_LabEpisodeNo
	Set return=return_$lb(SpecCode)        //标本
	Set return=return_$lb(SpecDesc)
	Set return=return_$lb(LocDr)         //申请科室
	Set return=return_$lb(LocDesc)
	Set return=return_$lb(CollDate)        //采集日期
	Set return=return_$lb(CollTime)
	Set return=return_$lb(CollUserCode)    //采集用户
	Set return=return_$lb(CollUserName)
	Set return=return_$lb(RecDate)         //接收日期
	Set return=return_$lb(RecTime)
	Set return=return_$lb(RecUserCode)     //接收用户
	Set return=return_$lb(RecUserName)
	Set return=return_$lb(WardDr)        //申请病区
	Set return=return_$lb(WardDesc)

	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  查询检验报告记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspLabReport1","QryLabVisitReport",19787631,"2016-08-01","2017-08-01")
Query QryLabVisitReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocID:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardID:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String")
{
}

ClassMethod QryLabVisitReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aEpisodeID'="" {
		Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
		Quit:OrdID="" $$$OK
		Set AdmStr=$g(^PAADM(aEpisodeID))
		Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
		Quit:(AdmType'="I")&(AdmType'="E") $$$OK
		
		Set xArcimID=""
		For {
			Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
			Quit:xArcimID=""
			
			Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
		 	Continue:'$IsObject(objArcim)
		 	Set ArcimType=objArcim.ARCICOrderType
		 	Continue:ArcimType'="L"
		 	
			Set xSttDate=0
			For {
				Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate))
				Quit:xSttDate=""
				
				Set xSub=0
				For {
					Set xSub=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate,xSub))
					Quit:xSub=""
					
					Set xEpis=$p($g(^OEORD(OrdID,"I",xSub,3)),"^",20)
					Continue:xEpis=""
					
					Set xTS=""
					For {
						Set xTS=$o(^TEPI(xEpis,1,xTS))
						Quit:xTS=""
						
						Set xCnt=0
						For {
							Set xCnt=$o(^TEPI(xEpis,1,xTS,xCnt))
							Quit:xCnt=""
							
							Set ReportData=$g(^TEPI(xEpis,1,xTS,xCnt))
							Continue:ReportData=""
							Set AuthDate=$p(ReportData,"\",4)
							Continue:AuthDate=""
							Continue:AuthDate<aDateFrom
							Continue:AuthDate>aDateTo
							
							Set ReportID=xEpis_"||"_xTS_"||"_xCnt
							Set Data=..BuildVisitReport(ReportID)
							Continue:Data=""
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
	} Else {
		//报告审核日期
		//检验医嘱EP_VisitTestSet
		//^TEPIi("AUTHORISED",{VISTS_DateOfAuthorisation},{EP_VisitNumber.EPVIS_VisitNumber},{VISTS_TestSet_DR},EP_VisitTestSet.VISTS_TestSetCounter})
		For xDate=aDateFrom:1:aDateTo {
			Set xEpis=0
			For {
				Set xEpis=$o(^TEPIi("AUTHORISED",xDate,xEpis))
				Quit:xEpis=""
				
				Set xTS=""
				For {
					Set xTS=$o(^TEPIi("AUTHORISED",xDate,xEpis,xTS))
					Quit:xTS=""
					
					Set xCnt=0
					For {
						Set xCnt=$o(^TEPIi("AUTHORISED",xDate,xEpis,xTS,xCnt))
						Quit:xCnt=""
						
						Set ReportData=$g(^TEPI(xEpis,1,xTS,xCnt))
						Continue:ReportData=""
						Set EpisodeID=..GetEpisodeIDByLab(xEpis)  // 就诊号
						Continue:EpisodeID=""
						Set AdmStr=$g(^PAADM(+EpisodeID))
						Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
						Continue:(AdmType'="I")&(AdmType'="E")
						
						Set ReportID=xEpis_"||"_xTS_"||"_xCnt
						Set Data=..BuildVisitReport(ReportID)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabVisitReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-08-21
/// Description:  组织Query输出检验报告
/// Input：       aReportID:检验报告ID
/// Return：      返回List
/// w ##Class(DHCMed.EPDService.SuspLabReport1).BuildVisitReport("2000000001||H1514||1")
ClassMethod BuildVisitReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildVisitReportErr"
	
	Set Epis=$p(aReportID,"||",1)
	Set TS=$p(aReportID,"||",2)
	Set Cnt=$p(aReportID,"||",3)
	Quit:(Epis="")||(TS="")||(Cnt="") return
	Set VisitNumberDr=Epis
	Set ReportID=Epis_"||"_TS
	Set Order=Cnt
	
	Set ReportData=$g(^TEPI(Epis,1,TS,Cnt))
	Quit:ReportData="" return
	Set RepStatus       = $p(ReportData,"\",31)
	Quit:RepStatus'="A" return //报告未审核
	
	Set RegDate         = $p(ReportData,"\",1)
	Set RegTime         = $p(ReportData,"\",2)
	Set:$l(RegTime) RegTime=RegTime*60
	Set RegUserCode     = $p(ReportData,"\",3)
	Set RegUserDesc     = ""
	If RegUserCode'="" {
		Set RegUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(RegUserCode,"U"),0))
		Set:RegUserDr'="" RegUserDesc=$p($g(^SSU("SSUSR",RegUserDr)),"^",2)
	}
	Set AuthDate        = $p(ReportData,"\",4)
	Set AuthTime        = $p(ReportData,"\",5)
	Set:$l(AuthTime) AuthTime=AuthTime*60
	Set AuthUserCode    = $p(ReportData,"\",6)
	Set AuthUserDesc    = ""
	If AuthUserCode'="" {
		Set AuthUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(AuthUserCode,"U"),0))
		Set:AuthUserDr'="" AuthUserDesc=$p($g(^SSU("SSUSR",AuthUserDr)),"^",2)
	}
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr="",ArcimCode="",ArcimDesc=""
	Set TestSetRow=aReportID
	Set TSCode=TS
	Set TSDesc=$p($g(^TTAB("TS",TSCode)),"\",1)
	Set HISOrderID=..GetOEItemIDsByLab("",TestSetRow)
	If HISOrderID'="" {
		Set ArcimID=$p($g(^OEORD(+HISOrderID,"I",+$p(HISOrderID,"||",2),1)),"^",2)
		If ArcimID'="" {
			Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)
			Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)
		}
	}
	Set TestSetStr=TSCode_"#"_TSDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_HISOrderID
	
	Set VisitNumberData=..GetVisitNumber(VisitNumberDr)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<17 return
	
	Set return=$lb(ReportID)
	Set return=return_$list(VisitNumberData,1,17)
	Set return=return_$lb(TestSetStr)
	Set return=return_$lb(TestSetRow)
	Set return=return_$lb(Order)
	Set return=return_$lb(RepStatus)
	Set return=return_$lb(RegDate)
	Set return=return_$lb(RegTime)
	Set return=return_$lb(RegUserCode)
	Set return=return_$lb(RegUserName)
	Set return=return_$lb(AuthDate)
	Set return=return_$lb(AuthTime)
	Set return=return_$lb(AuthUserCode)
	Set return=return_$lb(AuthUserName)
	Quit return
	
BuildVisitReportErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// w ##Class(DHCMed.EPDService.SuspLabReport1).GetEpisodeIDByLab(2000000001,"2000000001||H1514||1")
ClassMethod GetEpisodeIDByLab(aLabEpisodeNo As %String, aLabTestSetRow As %String = "") As %String
{
	New (aLabEpisodeNo,aLabTestSetRow)
	Set return=""
	Quit:(aLabEpisodeNo="")&(aLabTestSetRow="") return
	
	//检验号索引
	//^OEORD(0,"EpisNo",{OEORI_LabEpisodeNo},{OE_Order.OEORD_RowId},{OEORI_Childsub})
	If aLabTestSetRow'="" {
		Set LabEpisodeNo=$p(aLabTestSetRow,"||",1)
	} Else {
		Set LabEpisodeNo=aLabEpisodeNo
	}
	Set OrdID=$o(^OEORD(0,"EpisNo",LabEpisodeNo,0))
	Quit:OrdID="" return
	Set return=$p($g(^OEORD(OrdID)),"^",1)
	Quit return
}

/// w ##Class(DHCMed.EPDService.SuspLabReport1).GetOEItemIDsByLab(2000000001,"2000000001||H1514||1")
ClassMethod GetOEItemIDsByLab(aLabEpisodeNo As %String, aLabTestSetRow As %String = "") As %String
{
	New (aLabEpisodeNo,aLabTestSetRow)
	Set return=""
	Quit:(aLabEpisodeNo="")&(aLabTestSetRow="") return
	
	//检验号索引
	//^OEORD(0,"EpisNo",{OEORI_LabEpisodeNo},{OE_Order.OEORD_RowId},{OEORI_Childsub})
	If aLabTestSetRow'="" {
		Set LabEpisodeNo=$p(aLabTestSetRow,"||",1)
	} Else {
		Set LabEpisodeNo=aLabEpisodeNo
	}
	
	Set xOrdID=0
	For {
		Set xOrdID=$o(^OEORD(0,"EpisNo",LabEpisodeNo,xOrdID))
		Quit:xOrdID=""
		Quit:(aLabTestSetRow'="")&(return'="")
		
		Set xSub=0
		For {
			Set xSub=$o(^OEORD(0,"EpisNo",LabEpisodeNo,xOrdID,xSub))
			Quit:xSub=""
			Quit:(aLabTestSetRow'="")&(return'="")
			
			If $p(aLabTestSetRow,"||",2)'="" {
				Set LabTestSetRow=$p($g(^OEORD(xOrdID,"I",xSub,3)),"^",35)
				Continue:$p(LabTestSetRow,"||",2)'=$p(aLabTestSetRow,"||",2)
			}
			
			Set return=return_","_xOrdID_"||"_xSub
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// 取标本采集日期时间
/// OEItemID为医嘱ID
ClassMethod GetCollDateTime(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
    Set OrdXSub=$o(^OEORD(OrdID,"I",SubID,"X",0))
    Quit:OrdXSub="" return
    Set OEItemXID=OrdID_"||"_SubID_"||"_OrdXSub
    Set OrdExecID=$o(^DHCOrdExec(0,"OEOREDR",OrdID_"||"_SubID_"||"_OrdXSub,""))
    Quit:OrdExecID="" return
	
	Set (CollUserCode,CollUserDesc)=""
	Set CollUserID=$p(^DHCOrdExec(OrdExecID),"^",12)
	If CollUserID'="" {
		Set CollUserCode=$p($g(^SSU("SSUSR",CollUserID)),"^",1)
		Set CollUserDesc=$p($g(^SSU("SSUSR",CollUserID)),"^",2)
	}
	Set CollDate=$p(^DHCOrdExec(OrdExecID),"^",13)
	Set CollTime=$p(^DHCOrdExec(OrdExecID),"^",14)
	Quit:CollDate="" return
	
	Set return=CollDate_"^"_CollTime_"^"_CollUserID_"|"_CollUserCode_"|"_CollUserDesc
    Quit return
}

/// 取标本接受日期时间
/// OEItemID为医嘱ID，Flag标本状态（R）
ClassMethod GetRecDateTime(aOEItemID As %String, aFlag As %String = "R") As %String
{
	New (aOEItemID, aFlag)
	Set return=""
	Quit:(aOEItemID="")||(aFlag="") return
	
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
	Set RESSTID=$o(^OEC("RESST",0,"Code",aFlag,""))
	
	Set (RecDate,RecTime,RecUserID,RecUserCode,RecUserDesc)=""
	Set xRES=""
	For {
		Set xRES=$O(^OEORD(OrdID,"I",SubID,"RES",xRES))
		Quit:xRES=""
		Set Values=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",2)
		If RESSTID=Values {
			Set RecDate=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",4)
			Set RecTime=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",5)
			Set RecUserID=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",3)
			If RecUserID'="" {
				Set RecUserCode=$p($g(^SSU("SSUSR",RecUserID)),"^",1)
				Set RecUserDesc=$p($g(^SSU("SSUSR",RecUserID)),"^",2)
			}
		}
	}
	Quit:RecDate="" return
	
	Set return=RecDate_"^"_RecTime_"^"_RecUserID_"|"_RecUserCode_"|"_RecUserDesc
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-08-10
/// Description:  通过标本ID取检验医嘱信息（传染病检验项目相关）
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCMed.EPDService.SuspLabReport1).GetVisitTestSet(40110)
ClassMethod GetVisitTestSet(aVisitNumberID As %String) As %List
{
	New (aVisitNumberID)
	Set return=""
	Quit:aVisitNumberID="" return
	
	Set Epis=aVisitNumberID
	Set xTS=""
	For {
		Set xTS=$o(^TEPI(Epis,1,xTS))
		Quit:xTS=""
		
		//检验医嘱
		Set TSCode=xTS
		Set TSDesc=$p($g(^TTAB("TS",TSCode)),"\",1)
		Continue:TSDesc=""
		
		//HIS医嘱
		Set ArcimCode="",ArcimDesc=""
		Set TestSetRow=Epis_"||"_xTS_"||"_1
		
		 //传染病相关检验项目
		Set TestSetList= ##class(DHCMed.EPDService.SuspTestCodeSrv).GetTestSet()
		Continue:TestSetList=""
		Continue:((","_TestSetList_",")'[(","_TSCode_","))    //非传染病检验医嘱退出	

		Set HISOrdItemDr=..GetOEItemIDsByLab("",TestSetRow)
		If HISOrdItemDr'="" {
			Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
			If ArcimID'="" {
				Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
				Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
			}
		}
		
		Set ID=Epis_"||"_xTS
		Set WorkGroupMachineDr=""
		Set Data=$lb(ID,TSCode,TSDesc,ArcimCode,ArcimDesc,WorkGroupMachineDr,HISOrdItemDr)
		Set return=return_$lb(Data)
	}
	
	Quit return
}

/// 获取检验项目的描述，结果，单位，异常值，参考范围信息，英文缩写
/// [Previously private]
ClassMethod GetTestCodeResult(aReportID As %String, aTC As %String) As %String
{
	
	New (aReportID,aTC)
	Set return=""
	Quit:(aReportID="")||(aTC="") return
	
	Set Epis=$p(aReportID,"||",1)
	Set TS=$p(aReportID,"||",2)
	Set Cnt=$p(aReportID,"||",3)
	Set:Cnt="" Cnt=$o(^TEPI(Epis,1,TS,""),-1)
	Quit:(Epis="")||(TS="") return
	Quit:'$d(^TTAB("TC",aTC)) return
	
	Set ResultID=Epis_"||"_TS_"||"_Cnt_"||"_aTC
	Set ReportData=$g(^TEPI(Epis,1,TS,Cnt,"DATA",aTC))
	Quit:ReportData="" return
	Set tResult=$p(ReportData,"\",1)

	Set ItemName=$p(^TTAB("TC",aTC),"\",1)        //项目名称
	Set ItemDate=$p(^TEPI(Epis),"\",10)
	Set Synonym=$p(^TTAB("TC",aTC),"\",12)        //英文缩写
	Set ItemUnits=..GetTCUnitByDate(aTC,ItemDate) //项目单位
	Set ItemType=$p(^TTAB("TC",aTC),"\",3)        //输出数据类型
	Set ItemResult=Result
	If ItemType="V" {         //微生物 Micro Pathogen||V
		If ItemResult'="" {
			set xItemResult=ItemResult
			set xItemResult=$ZCVT($g(xItemResult),"U")
			set xItemResult=$tr(xItemResult," ","")
			Set:$d(^TTAB("BUG",xItemResult)) ItemResult=$p($g(^TTAB("BUG",xItemResult)),"\",1)
		}
	}
	If ItemType["N" {         //??
		Set Decimal=$e(ItemType,2)
		Set:Decimal="" Decimal="0"
		Set ItemResult=$$CheckResDecimal(ItemResult,Decimal)
	}
	If ItemType["S" {         //Standard Comment标准意见
		If ItemResult'="" {
			Set:$d(^TTAB("TC",aTC,2,ItemResult,1)) ItemResult=$p($g(^TTAB("TC",aTC,2,ItemResult,1)),"\",1)
		}
	}
	If ItemType="B2" {        //血型结果
		If ItemResult'="" {
			Set:$d(^TTAB("BB-BG",ItemResult)) ItemResult=$p($g(^TTAB("BB-BG",ItemResult)),"\",1)
		}
	}
	
	Set ResFlag=..GetAbnorFlag(aTC ,ItemResult)  //异常标志
	Set RefRanges=..GetTCRanges(aTC)             //参考范围
	Set RefRanges=$tr(RefRanges,$C(1),"~")      //参考范围高低值之间用“~”分隔
	Set:'$l(RefRanges) RefRanges=..GetMultiScope(aTC)
	
	//异常标志特殊字符处理
	Set ResFlag=$tr(ResFlag,$c(28),"")
	
	Set Comments=$g(^TEPI(Epis,1,TS,Cnt,"DATA",aTC,"REM",1))
	Set Comments1=$g(^TEPI(Epis,1,TS,Cnt,"DATA",aTC,"REM",0))  //增加备注取的位置
	Set:Comments1'="" Comments=Comments_Comments1

	Set $p(return,$c(2),1)=aTC
	Set $p(return,$c(2),2)=ItemName
	Set $p(return,$c(2),3)=$tr(ItemResult,$c(13,10),"")
	Set $p(return,$c(2),4)=ItemUnits
	Set $p(return,$c(2),5)=ResFlag
	Set $p(return,$c(2),6)=RefRanges
	Set $p(return,$c(2),7)=Synonym
	Set $p(return,$c(2),8)=ItemType
	Set $p(return,$c(2),9)=Comments
	
	//特殊不可见字符处理
	Set return=$tr(return,$c(0),"")
	Set return=$tr(return,$c(1),"")
	Set return=$tr(return,$c(10),"")
	Set return=$tr(return,$c(13),"")
	Quit return
	
CheckResDecimal(res,dec)
	Set res=$Get(res),dec=+$Get(dec)
	Set ret=""
	If res="" Quit ret
	If dec="" Quit ret
	Set flag=""
	If ($Extract(res)="<")!($Extract(res)=">") s flag=$Extract(res),res=$TRanslate(res,"<>")
	Set res=+res
	Set ret=$fn(res,"",dec)
	Quit flag_ret
}

/// 获取检验项目的异常标记
/// TestCode:检验项代码，TCResult:检验结果，TCRanges：检验项范围值（默认为空）
/// [Previously private]
ClassMethod GetAbnorFlag(TestCode As %String, TCResult As %String, TCRanges As %String = "") As %String
{
	Set FormatFlag=""
	//Set currNS=$znspace
	Set:$Data(^TTAB("TC",TestCode))'=0 FormatFlag=$Piece(^TTAB("TC",TestCode),"\",3)
	Quit:FormatFlag=""!TCResult=""!TestCode="" ""
	Set:TCRanges="" PType="0",TCRanges=..GetTCRanges(TestCode, "","", "", PType, "", "", "", "1","")
	Set:'$l(TCRanges) TCRanges=..GetMultiScope(TestCode)
	Set AbnorFlag=$Select(FormatFlag["N":$$GetAbnorFlagByNum(TCResult,TCRanges),FormatFlag["S":$$GetAbnorFlagByStCommen(TestCode,TCResult),FormatFlag["X":$$GetAbnorFlagByFreeText(TestCode,TCResult),1:"")
	//Set $znspace=currNS
	Quit AbnorFlag
	
	 ;数据型
GetAbnorFlagByNum(TCResult,TCRanges)
	s TCResult=$g(TCResult),TCRanges=$g(TCRanges)
	s (retvalue,retranges,retcolor)=""
	s retflag="N",lowflag="L",highflag="H"
	s reslow=$p(TCRanges,$c(1),1),reshigh=$p(TCRanges,$c(1),2)
	;panic unaccept
	s resPaniclow=$p(TCRanges,$c(1),3),resPanichigh=$p(TCRanges,$c(1),4)
	s resUnAcceptlow=$p(TCRanges,$c(1),9),resUnAccepthigh=$p(TCRanges,$c(1),10)
	;i TCRanges="" q ""
	i $l(TCRanges,$c(10))>1 q retvalue_$c(28)_retflag
	Set TCResult=$tr(TCResult,"><")
	;
	/*
	Set $znspace="LABDATA"
	Set lowflag=$p(^CF("LAB",1),"^",18),highflag=$p(^CF("LAB",1),"^",19)
	s rangsta=$p(^CF("LAB",1),"^",16),rangend=$p(^CF("LAB",1),"^",17)
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    s iBelowBColor=$P(^CF("LAB",1,"COLOUR",12),"^",1)
    s iBelowFcolor=$P(^CF("LAB",1,"COLOUR",12),"^",2)
    ;
    s iUnAcceptBColor=$P(^CF("LAB",1,"COLOUR",2),"^",1)
    s iUnAcceptFColor=$P(^CF("LAB",1,"COLOUR",2),"^",2)
    s iPanicColor=$P($tr(^CF("LAB",1,"COLOUR",15),$c(13,10)),"^",11)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    i TCRanges="" q retvalue_$c(28)_retranges_$c(28)_retcolor_$c(28)_retflag
	 
	i TCRanges="" q retvalue_$c(28)_retflag
	
	;---------add 20070914  修改范围值的显示
	i reslow="",reshigh="" d 
	.s retranges="" 
	i "<>"[$e(reslow) d ;($e(reslow,1)="<")!($e(reslow,1)=">") d
	.s retranges=rangsta_reslow_rangend
	e  d
	.s retranges=rangsta_reslow_"-"_reshigh_rangend
	;-----------
	*/
	i TCRanges="" q retvalue_$c(28)_retflag
	i '$ISVALIDNUM(TCResult) q retvalue_$c(28)_retflag
	;UnAccept check
	s rang=resUnAcceptlow_resUnAccepthigh
	i $l(rang) d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resUnAcceptlow s retvalue=lowflag,retflag="U" q
	..i TCResult>resUnAccepthigh s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="U" q
	;Panic check
	s rang=resPaniclow_resPanichigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resPaniclow s retvalue=lowflag,retflag="M" q
	..i TCResult>resPanichigh s retvalue=highflag,retflag="M" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="M" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="M" q
	;normal check
	s rang=reslow_reshigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<reslow s retvalue=lowflag,retflag="L" q
	..i TCResult>reshigh s retvalue=highflag,retflag="H" q
	.i (rang["<") d
	..s lowflag=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowflag s retvalue=highflag,retflag="H" 
	.i (rang[">") d
	..s highflag=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highflag s retvalue=lowflag,retflag="L"	
	q retvalue_$c(28)_retflag
	//q retflag
	
	;标准备注型	
GetAbnorFlagByStCommen(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	i '$l(TCResult) q $c(28,28,28)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    ;s ^aareflag=TestCode_":"_TCResult
    i $d(^TTAB("TC",TestCode,2,TCResult)) d
    .s retflag=$p(^TTAB("TC",TestCode,2,TCResult),"\",1)
    .i retflag="A" s retvalue="*"
    q retvalue_$c(28)_retflag
    //q retflag
    
	;文本类型
GetAbnorFlagByFreeText(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    s temstr=""
    s std="" f  s std=$o(^TTAB("TC",TestCode,2,std)) q:std=""  d
    .i $p(^TTAB("TC",TestCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),TCResult[$g(^TTAB("TC",TestCode,2,std,1)) ,retvalue="*",retflag="A"
    q retvalue_$c(28)_retflag
    // q retflag
    
res(rang) ; check < >
 i rang[">" s rang=$tr(rang,">")+.00000001
 i rang["<" s rang=$tr(rang,"<")-.00000001
 q rang
}

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别,Pregn:怀孕(0),PatientType:病人类型(0\0-IN),Date:日期,Cond:临床条件(0),Loc:0,mi:1\2,Weeks:周(0)
/// [Previously private]
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Pregn As %String = "", PatientType As %String = "0", Date As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "1", Weeks As %Integer = "") As %String
{
 Set (j,x,xf,age0,type,exist,result,format)=""
 Set result=""
 Set tc=$g(TestCode),age=$g(Age),spec=$g(Species),pregn=$g(Pregn),ptype=$g(PatientType),date=$g(Date),cond=$g(Cond),loc=$g(Loc),mi=$g(mi),weeks=$g(Weeks)
 ;
 If '$l(age) Set age=0
 If '$l(spec) Set spec="M"
 ;;
 Set format=$p($g(^TTAB("TC",tc)),"\",3)
 i '$l(date) s date=+$h
 i '$d(^TTAB("TC",tc,4,date)) s date=$o(^TTAB("TC",tc,4,date),-1)
 i $l(date) d
 .For type=ptype,$e(ptype) i $d(^TTAB("TC",tc,4,date,type)) d  q
 ..k xf s x="" f  s x=$o(^TTAB("TC",tc,4,date,type,x)) q:x=""  d
 ...i $l($p(^(x),"\",23)),'$l(age) q
 ...i $l($p(^(x),"\",23)),$l($p(^(x),"\",23),"-")'>1 Set $p(^(x),"\",23)="0-"_$p(^(x),"\",23) //如果年龄只有最大值，则改为“0-最大值”的格式
 ...i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
 ...i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
 ...i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
 ...i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
 ...i $l($p(^(x),"\",24)),$p(^(x),"\",24)'=loc q
 ...i $l($p(^(x),"\",25)),'$l(age) q
 ...i $l($p(^(x),"\",25)),weeks<$p($p(^(x),"\",25),"-",1) q
 ...i $l($p(^(x),"\",25)),weeks>$p($p(^(x),"\",25),"-",2) q
 ...s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23)))+(''$l($p(^(x),"\",24)))+(''$l($p(^(x),"\",25))),xf(xf,x)=^(x)
 ..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
 ...s (aaLow,aaHigh,aaPLow,aaPHigh)=""
 ...//i $l(mi) s rowid=tc_"||"_date_"||"_type_"||"_x_"||"_mi i '$$select^LVBCTTCG(rowid) d
 ...//.s aaLow=PLIST(3),aaHigh=PLIST(4),aaPLow=PLIST(5),aaPHigh=PLIST(6)
 ...i $l(mi) d Select 
 ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 ...i $l(aaLow)!$l(aaHigh) s $p(xx,"\",3)=aaLow,$p(xx,"\",4)=aaHigh
 ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
 ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
 ....i 'exist d
 .....s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 .....i $l(aaPLow)!$l(aaPHigh) s $p(xx,"\",3)=aaPLow,$p(xx,"\",4)=aaPHigh
 ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
 For j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $l(x) d
 .i ($e(x)="<")!($e(x)=">") d  q
 ..s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))
 ..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 .s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 .i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
  //w !,"@Debug Start-------------------------------------",!
  //w "result:"_result
  //w !,"@Debug End---------------------------------------",!
 Quit result
 
Select
 set tc=$g(tc),date=$g(date), type=$g(type),x=$g(x),mi=$g(mi),ValDeli="\"
 If $Data(^TTAB("TC",tc,4,date,type,x,mi))=0 Quit
 Set rangesAAStr=^TTAB("TC",tc,4,date,type,x,mi)
 Set aaLow=$Piece(rangesAAStr,ValDeli,1)
 Set aaHigh=$Piece(rangesAAStr,ValDeli,2)
 Set aaPLow=$Piece(rangesAAStr,ValDeli,3)
 Set aaPHigh=$Piece(rangesAAStr,ValDeli,4)
 Quit
}

/// 检验项目结果多范围值的获取
/// [Previously private]
ClassMethod GetMultiScope(ItemCode, LabNo, date) As %String
{
   
   ;先判断有没有临床条件?若有临床条件则不需要返回多范围了
   s ItemCode=$g(ItemCode),LabNo=$g(LabNo),date=$g(date)
   ;s conditions=""    ?????  Liuzf-20090422
   ;s conditions=$P($g(^TEPI(LabNo,0)),"\",17)  ???? Liuzf-20090422
   ;i conditions'="" q ""        ???? Liuzf-20090422
   s Scopy=""
   i '$l(date) s date=+$h
   i '$d(^TTAB("TC",ItemCode,4,date)) s date=$o(^TTAB("TC",ItemCode,4,date),-1)
   i $l(date) d
   .s num=1
   .s ord="" f  s ord=$o(^TTAB("TC",ItemCode,4,date,0,ord)) q:ord=""  d
   ..i $p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)'="" d
   ...s clc=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)
   ...s temL=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1)
   ...s temH=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2)
   ...i $l(temH) s temrange=^TTAB("CLC",clc)_"("_$j(temL,3,2)_"-"_$j(temH,3,2)_")"
   ...i '$l(temH) s temrange=^TTAB("CLC",clc)_"("_temL_")"
   ...;s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   ...i (num#2)=0 d
   ....s Scopy=Scopy_temrange_$c(10,13)
   ...e  d
   ....s Scopy=Scopy_temrange_$c(32)
   ...s num=num+1
   q Scopy
}

/// 根据日期获取检验项目的单位 //$$Units^DHCCTTCU(TC,recdate) ;
/// [Previously private]
ClassMethod GetTCUnitByDate(tc, date) As %String
{
  ;table CT_TestCodePrevUnits
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s date=date+1
  s last=$o(^TTAB("TC",tc,6,""),-1)
  q:($Data(^TTAB("TC",tc))'=1)&($Data(^TTAB("TC",tc))'=11) ""
  s unit=$p(^TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^TTAB("TC",tc,6,date)) q $p(^TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^TTAB("TC",tc,6,last),"\",1)
}

/// 获得检验项目的类别
/// [Previously private]
ClassMethod GetItemOrderType(ItemCatId As %String) As %String
{
	s OrderTypeStr=^ARC("IC",ItemCatId) Quit:OrderTypeStr="" ""
	s OrderType=$P(OrderTypeStr,"^",7)	Quit:OrderType="" ""
	Quit OrderType
}

/// 获得检验项目的名称
/// [Previously private]
ClassMethod GetLabItemNameDesc(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ItemCatId=$Piece(^ARCIM(ItemId,ItemSub,1),"^",10) Quit:ItemCatId="" ""
	Quit:..GetItemOrderType(ItemCatId)'="L" ""
	Set ItemDesc=$Piece(^ARCIM(ItemId,ItemSub,1),"^",2)
	Quit ItemDesc
}

/// 获得医嘱项目对应的检验医嘱关联代码TestSetCode
/// [Previously private]
ClassMethod GetExtTestSetCode(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set:$Data(^ARCIM(ItemId,ItemSub,"EXT",1)) ItemExternalCodesStr=^ARCIM(ItemId,ItemSub,"EXT",1)
	Set TestSetCode=""
	Set:ItemExternalCodesStr'="" TestSetCode=$Piece(ItemExternalCodesStr,"^",4)
	Quit TestSetCode
}

/// 根据标本代码获取标本名称描述
/// [Previously private]
ClassMethod GetSpecimenDesc(SpecCode As %String) As %String
{
	S SpecDesc=""
	Q:'$l(SpecCode) SpecDesc
	S DataFlag=$D(^TTAB("SPEC",SpecCode))
	Q:(DataFlag'=1)&(DataFlag'=11) SpecDesc
	S SpeData=^TTAB("SPEC",SpecCode)
	S SpecDesc=$P(SpeData,"\",1)
	Q SpecDesc
}

}
