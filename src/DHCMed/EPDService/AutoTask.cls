/// 名称:DHCMed.EPDService.AutoTask
/// 描述: 传染病筛查 自动任务
/// 编写者：zhufei
/// 编写日期: 2014-07-17
Class DHCMed.EPDService.AutoTask Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 生成传染病筛查记录的自动任务
/// w ##Class(DHCMed.EPDService.AutoTask).CasesXTask("2013-01-01","2014-07-17","EPDCC")
ClassMethod CasesXTask(aDateFrom As %String, aDateTo As %String, aConfigCode As %String) As %String
{
	new (aDateFrom,aDateTo,aConfigCode)
	set return=0
	quit:(aConfigCode="") return
	quit:(aDateFrom="")||(aDateTo="") return
	
	set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	set return=-1
	set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aConfigCode)
	quit:'$IsObject(objConfig) return
	set ConfigID=objConfig.%Id()
	set SubjectCode=objConfig.SubjectCode
	quit:SubjectCode="" return
	
	set return=-2
	set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	quit:'$IsObject(objSubject) return
	set SubjectID=objSubject.%Id()
	quit:SubjectID="" return
	
	set xDate=aDateFrom-1
	for {
		set xDate=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate))
		quit:xDate=""
		quit:xDate>aDateTo
		
		set xEpisodeID=0
		for {
			set xEpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID))
			quit:xEpisodeID=""
			
			set AdmLoc=$p($g(^PAADM(xEpisodeID)),"^",4)
			set AdmReadm=$p($g(^PAADM(xEpisodeID)),"^",56)
			set:AdmReadm="" AdmReadm="A"
			
			/*update by zf 2019-01-24 筛查传染病是否上报*/
			Kill arrEpdDiagnos
			set xResultID=0
			for {
				set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID,SubjectID,xResultID))
				quit:xResultID=""
				
				set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
				continue:'$IsObject(objResult)
				
				set ItemID=objResult.ItemId
				continue:$d(arrItem(ItemID))
				
				set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				continue:'$IsObject(objItem)
				
				set ItemDicDr=objItem.ItemDic
				set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDr)
				continue:'$IsObject(objItemDic)
				set SubCatDr=objItemDic.IDSubCatDr
				Continue:SubCatDr=""
				Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,SubCatDr))
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
				Continue:'$IsObject(objSubCat)
				Set ISCCatDr=objSubCat.ISCCatDr
				Set ISCKeywordID=objSubCat.ISCKeywordID
				Set ISCKeywordCode=""
				If ISCKeywordID'="" {
					Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(+ISCKeywordID)
					Set:$IsObject(objKeyword) ISCKeywordCode=objKeyword.Code
				}
				
				set Score=objItem.Score  //借用Score字段作为项目等级字段
				continue:Score<1
				
				set EpdDiagnos=objResult.DataValue
				continue:EpdDiagnos=""
				for indEpd=1:1:$l(EpdDiagnos,",") {
					set tmpEpdDiagnos=$p(EpdDiagnos,",",indEpd)
					continue:tmpEpdDiagnos=""
					Set arrEpdDiagnos(tmpEpdDiagnos,xResultID)=""  //筛查传染病报告
				}
			}
			
			set xRepID=""
			for {
				set xRepID=$o(^DHCMed.EPDi("EPD","0","EpisodeID",xEpisodeID,xRepID))
				quit:xRepID=""
				
				set MEPDStatus=$p(^DHCMed.EPD("EPD",xRepID),"^",15)
				continue:(MEPDStatus=4)||(MEPDStatus=6)||(MEPDStatus=7)  //4被订、6草稿、7删除
				set IFID=$p(^DHCMed.EPD("EPD",xRepID),"^",5)
				continue:IFID=""
				set IFdesc=$p($g(^DHCMed.EPDC("IF",IFID)),"^",2)
				continue:IFdesc=""
				if $d(arrEpdDiagnos(IFdesc)) {
					set arrEpdDiagnos(IFdesc)=IFID  //已上报传染病报告
				}
			}
			
			set xIFDesc=""
			for {
				set xIFDesc=$o(arrEpdDiagnos(xIFDesc))
				quit:xIFDesc=""
				
				set RepIFDr=$g(arrEpdDiagnos(xIFDesc))
				
				Set ResultIDs=""
				set xRstID=""
				for {
					set xRstID=$o(arrEpdDiagnos(xIFDesc,xRstID))
					quit:xRepID=""
					set ResultIDs=ResultIDs_","_xRepID
				}
				set:ResultIDs'="" ResultIDs=$e(ResultIDs,2,$l(ResultIDs))
				
				//一次就诊同一传染病诊断只有一条筛查记录
				set EpdStatus	    = $s(RepIFDr'="":1,1:"-1")  //已上报默认“确认”状态
				set EpdDiagnos	    = RepIFDr
				set Opinion         = ""
				set EvalDate        = +$h
				set EvalTime        = $p($h,",",2)
				set EvalLoc         = ""
				set EvalUser        = ""
				set ID=$o(^DHCMed.EPDi("CasesX","IndexEpisActDiagnos",SubjectCode,xEpisodeID," "_$zcvt(xIFDesc,"U"),0))
				if ID'="" {
					set obj=##class(DHCMed.EPD.CasesX).GetObjById(ID)
					if $IsObject(obj) {
						set EpdStatus	= obj.CXEpdStatus
						set EpdDiagnos	= obj.CXEpdDiagnos
						set Opinion     = obj.CXOpinion
						set EvalDate    = obj.CXEvalDate
						set EvalTime    = obj.CXEvalTime
						set EvalLoc     = obj.CXEvalLoc
						set EvalUser    = obj.CXEvalUser
						if (RepIFDr'="")&&(EpdStatus'=1){
							set EpdStatus	= $s(RepIFDr'="":1,1:"-1")
							set EpdDiagnos	= RepIFDr
						}
					}
				}
				
				//保存病例筛查日志信息
				set inputStr=ID
				set inputStr=inputStr_"^"_SubjectCode
				set inputStr=inputStr_"^"_xEpisodeID
				set inputStr=inputStr_"^"_xDate
				set inputStr=inputStr_"^"_AdmLoc
				set inputStr=inputStr_"^"_xIFDesc
				set inputStr=inputStr_"^"_AdmReadm
				set inputStr=inputStr_"^"_ResultIDs
				set inputStr=inputStr_"^"_EpdStatus
				set inputStr=inputStr_"^"_EpdDiagnos
				set inputStr=inputStr_"^"_Opinion
				set inputStr=inputStr_"^"_EvalDate
				set inputStr=inputStr_"^"_EvalTime
				set inputStr=inputStr_"^"_EvalLoc
				set inputStr=inputStr_"^"_EvalUser
				set inputStr=inputStr_"^"_1
				set inputStr=inputStr_"^"_""
				set flg=##class(DHCMed.EPD.CasesX).Update(inputStr,"^")
			}
			Kill arrEpdDiagnos
		}
	}
	
	set return=1
	quit return
}

/// Creator：     pylian
/// CreatDate：   2019-01-30
/// Description:  根据日期生成传染病筛查记录
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      "OK"
/// w ##class(DHCMed.EPDService.AutoTask).AutoTask("2016-01-01","2019-02-28")
ClassMethod AutoTask(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set $ZT="AutoTaskErr"
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") "OK"

	//检验结果在就诊之后任务
	Set ret=..AutoTaskLIS(aDateFrom,aDateTo)

	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD))
	Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"命令")="AutoTask("_aDateFrom_","_aDateTo_")"
	Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	//就诊信息
	Set arrEpisodeID=##class(DHCMed.EPDService.AutoTask).GetAdmList(aDateFrom,aDateTo)
	Set Count=arrEpisodeID.Count()
	For indEpis=1:1:Count {
		Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
		Continue:xEpisodeID=""
		
		Write "EpisodeID="_xEpisodeID,!
		Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeID_")"
		
		Set ret = ##class(DHCMed.EPDService.AutoTask).GetCtrlResult(xEpisodeID,aDateFrom,aDateTo)			
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	Quit "OK"
	
AutoTaskErr
	Quit "Error"
}

/// Creator：     pylian
/// CreatDate：   2019-02-02
/// Description:  就诊列表
/// Table：       PA_Adm
/// Input：       aDateFrom : 开始日期
/// Input：       aDateTo : 结束日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.AutoTask).GetAdmList("2019-01-01","2019-02-28")
ClassMethod GetAdmList(aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	
	New (aDateFrom,aDateTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="GetAdmListErr"
  
    Set Count=0 
    //门、急诊患者
	For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:($p(AdmInfo,"^",2)'="O")&&($p(AdmInfo,"^",2)'="E")      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			
			Set Count=Count+1
			Do return.SetAt(xPaadm,Count)
		}
	}
  
	//在院患者列表、急诊留观列表
	Set xWardID=""
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",xWardID,xRoomID,xPaadm))
				Quit:xPaadm=""
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:($p(AdmInfo,"^",2)'="I")&&($p(AdmInfo,"^",2)'="E")      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			
				Set Count=Count+1
			    Do return.SetAt(xPaadm,Count)
			}
		}
	}
	
	//出院患者列表
	Set CurrDate=+$h
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  
	For xDate=aDateFrom:1:CurrDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:($p(AdmInfo,"^",2)'="I")&&($p(AdmInfo,"^",2)'="E")      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"         //就诊状态过滤
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(xPaadm)
    		Continue:$p(AdmDateTime,"^",1)>aDateTo   //就诊时间过滤
    		
			Set Count=Count+1
			Do return.SetAt(xPaadm,Count)
		}
	}
	
	Quit return
	
GetAdmListErr
	Do return.Clear()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-01-30
/// Description:  根据就诊记录监控
/// Input：       aEpisodeID：就诊ID
///               aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      "OK"
/// w ##class(DHCMed.EPDService.AutoTask).GetCtrlResult("59","2019-01-10","2010-01-31")
ClassMethod GetCtrlResult(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	Set $ZT="GetCtrlResultErr"
	
	// 临床诊断
	Set flg=##class(DHCMed.EPDService.SuspMRDiagnos).CheckHIS(aEpisodeID,aDateFrom,aDateTo)
	
	// 电子病历诊断
	Set flg=##class(DHCMed.EPDService.SuspEmrDiagnos).CheckEMR(aEpisodeID,aDateFrom,aDateTo)
	
	// 检查
	Set flg=##class(DHCMed.EPDService.SuspRISReport).CheckRIS(aEpisodeID,aDateFrom,aDateTo)
    
    // 检验
    Set flg=##class(DHCMed.EPDService.SuspLabReport).CheckLIS(aEpisodeID,aDateFrom,aDateTo)
    
	Quit 1
	
GetCtrlResultErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2019-05-06
/// Description:  出院后、就诊之后出报告结果任务
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      "OK"
/// w ##class(DHCMed.EPDService.AutoTask).AutoTaskLIS("2019-04-01","2019-05-05")
ClassMethod AutoTaskLIS(aDateFrom As %String, aDateTo As %String) As %String
{
	
	New (aDateFrom,aDateTo)
	Set $ZT="AutoTaskLISErr"
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD))
	Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"命令")="AutoTaskLIS("_aDateFrom_","_aDateTo_")"
	Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	//检验版本
    Set LabRepVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSLabReportVer")
	If LabRepVer="LIS1.0" {
		//未写
	}ElseIf LabRepVer="LISC1.0" {
		//add 2020-04-28 从平台直接取值
		
	} ElseIf LabRepVer="LISC2.0" {
		//add 2020-04-28 从平台直接取值
		Set arrEpisodeID=##class(DHCMed.EPDService.AutoTask).GetLISC2AdmList(aDateFrom,aDateTo)
		Set Count=arrEpisodeID.Count()
		For indEpis=1:1:Count {
			Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
			Continue:xEpisodeID=""
			
			Write "EpisodeID="_xEpisodeID,!
			Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeID_")"			
		
			// 检验
	    	Set ret=##class(DHCMed.EPDService.SuspLabReport).CheckLIS(xEpisodeID,aDateFrom,aDateTo)   
		}
		
	} Else {
		//延迟报告患者列表
		Set arrEpisodeID=##class(DHCMed.EPDService.AutoTask).GetLIS2AdmList(aDateFrom,aDateTo)
		Set Count=arrEpisodeID.Count()
		For indEpis=1:1:Count {
			Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
			Continue:xEpisodeID=""
			
			Write "EpisodeID="_xEpisodeID,!
			Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeID_")"
			
			// 检验
	    	Set ret=##class(DHCMed.EPDService.SuspLabReport).CheckLIS(xEpisodeID,aDateFrom,aDateTo)
	    
		}
	}

	//记录执行任务日志（成功标记）
	Set ^DHCMed.EPDService.AutoTask(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	Quit "OK"
	
AutoTaskLISErr
	Quit "Error"
}

/// 检验结果延迟报告列表
/// w ##class(DHCMed.EPDService.AutoTask).GetLIS2AdmList("2019-04-01","2019-05-05")
ClassMethod GetLIS2AdmList(aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	
	New (aDateFrom,aDateTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Kill ^TMP($zn,$j,"GetLIS2AdmList")
	Set Count=0
	// 新审核
	Set xWorkGrpMachDr=""
	For {
		Set xWorkGrpMachDr=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkGrpMachDr))
		Quit:xWorkGrpMachDr=""
		
		For xDate=aDateFrom:1:aDateTo {
			Set xAuthDate=$zd(xDate,8)
			Set xReportDr=""
			For {
				Set xReportDr=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkGrpMachDr,xAuthDate,xReportDr))
				Quit:xReportDr=""
				
				Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
				Continue:ReportData=""
				Set VisitNumberDr=$lg(ReportData,2)		   //标本ID
				Continue:VisitNumberDr=""
				Set VisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDr))
				Continue:VisitNumberData=""
				Set RepStatus  	= $lg(ReportData,22)		//状态
	
				Set EpisodeID=$listget(VisitNumberData,5)  // 就诊号
				Continue:EpisodeID=""
				Set AdmStr=$g(^PAADM(+EpisodeID))
				Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
				Continue:(AdmType="H")
				Set AdmDate=$p(AdmStr,"^",6)
				Set AdmTime=$p(AdmStr,"^",7)
				Set DischDate=$p(AdmStr,"^",17)
				Set DischTime=$p(AdmStr,"^",18)
				If (AdmType="I")&&((DischDate="")||(DischDate=xDate)){
					Continue
				}
				If (AdmType="O")&&(AdmDate=xDate){
					Continue
				}
				If (AdmType="E")&&(AdmDate=xDate){
					Continue
				}
			   	
			   	Continue:$d(^TMP($zn,$j,"GetLIS2AdmList","PatAdm",EpisodeID))
	    		Set ^TMP($zn,$j,"GetLIS2AdmList","PatAdm",EpisodeID) = ""
               
				Set Count=Count+1
				Do return.SetAt(EpisodeID,Count)
			}
		}
	}
	
	// 重新审核
	Set xWorkGrpMachDr=""
	For {
		Set xWorkGrpMachDr=$o(^dbo.RPVisitNumberReportI("IndexReAuthDate",xWorkGrpMachDr))
		Quit:xWorkGrpMachDr=""
		
		For xDate=aDateFrom:1:aDateTo{
			Set xReAuthDate=$zd(xDate,8)
			Set xReportDr=""
			For {
				Set xReportDr=$o(^dbo.RPVisitNumberReportI("IndexReAuthDate",xWorkGrpMachDr,xReAuthDate,xReportDr))
				Quit:xReportDr=""
				
				Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
				Continue:ReportData=""
				Set VisitNumberDr=$lg(ReportData,2)		   //标本ID
				Continue:VisitNumberDr=""
				Set VisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDr))
				Continue:VisitNumberData=""
				Set EpisodeID=$listget(VisitNumberData,5)  // 就诊号
				Continue:EpisodeID=""
				
				Set AdmStr=$g(^PAADM(+EpisodeID))
				Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
				Continue:(AdmType="H")

				Set AdmDate=$p(AdmStr,"^",6)
				Set AdmTime=$p(AdmStr,"^",7)
				Set DischDate=$p(AdmStr,"^",17)
				Set DischTime=$p(AdmStr,"^",18)
				
				If (AdmType="I")&&((DischDate="")||(DischDate=xDate)){
					Continue
				}
				If (AdmType="O")&&(AdmDate=xDate){
					Continue
				}
				If (AdmType="E")&&(AdmDate=xDate){
					Continue
				}
				Continue:$d(^TMP($zn,$j,"GetLIS2AdmList","PatAdm",EpisodeID))
	    		Set ^TMP($zn,$j,"GetLIS2AdmList","PatAdm",EpisodeID) = ""
	    		
				Set Count=Count+1
				Do return.SetAt(EpisodeID,Count)
			}
		}
	}
	
	Kill ^TMP($zn,$j,"GetLIS2AdmList")
	
	Quit return
}

/// 走平台接口检验结果延迟报告列表
/// w ##class(DHCMed.EPDService.AutoTask).GetLISC2AdmList("2019-04-01","2019-05-05")
ClassMethod GetLISC2AdmList(aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	
	New (aDateFrom,aDateTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Kill ^TMP($zn,$j,"GetLISC2AdmList")
	Set Count=0
	
	
	// 时间戳索引	
	For xDate = (aDateFrom-1):1:aDateTo {
		Set xDate=$o(^Busi.ENS.EnsLISReportResultI("LISRRUpdateTimeIndex",xDate))
		Quit:xDate=""
		
		Set xTime=""
		For {
			Set xTime=$o(^Busi.ENS.EnsLISReportResultI("LISRRUpdateTimeIndex",xDate,xTime))
			Quit:xTime=""
			
			Set xID=""
			For {
				Set xID=$o(^Busi.ENS.EnsLISReportResultI("LISRRUpdateTimeIndex",xDate,xTime,xID))
				Quit:xID=""
		
				Set ReportData=$g(^Busi.ENS.EnsLISReportResultD(xID))
				Continue:ReportData=""
				Set Status=$lg(ReportData,117)       //状态（1审核、2取消审核、3作废）
				Continue:Status'=1
				Set CollectDate=$lg(ReportData,48)   //采集日期
				Set ReceiveDate=$lg(ReportData,65)   //接收日期
				Set CheckDate=$lg(ReportData,107)    //审核日期
		
				Set EpisodeID=$listget(ReportData,5)  // 就诊号
				Continue:EpisodeID=""
				Set AdmStr=$g(^PAADM(+EpisodeID))
				Set AdmType= $p(AdmStr,"^",2)	           //就诊类型
				Continue:(AdmType="H")
				Set AdmDate=$p(AdmStr,"^",6)
				Set AdmTime=$p(AdmStr,"^",7)
				Set DischDate=$p(AdmStr,"^",17)
				Set DischTime=$p(AdmStr,"^",18)
				If (AdmType="I")&&((DischDate="")||(DischDate=xDate)){
					Continue
				}
				If (AdmType="O")&&(AdmDate=xDate){
					Continue
				}
				If (AdmType="E")&&(AdmDate=xDate){
					Continue
				}
			   	
			   	Continue:$d(^TMP($zn,$j,"GetLISC2AdmList","PatAdm",EpisodeID))
	    		Set ^TMP($zn,$j,"GetLISC2AdmList","PatAdm",EpisodeID) = ""
               
				Set Count=Count+1
				Do return.SetAt(EpisodeID,Count)
			}
		}
	}
	
	
	Kill ^TMP($zn,$j,"GetLISC2AdmList")
	
	Quit return
}

}
