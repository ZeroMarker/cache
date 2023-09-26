/// 名称: DHCHAI.IRC.CSResultSrv
/// 描述: 疑似病例筛查规则相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRC.CSResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断患者是否是CLABSI患者
ClassMethod CheckPatCLABSI(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %ArrayOfDataTypes
{
	New (aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Set:aDateTo="" aDateTo=+$h
	Quit:(aDateFrom="")||(aDateFrom="") return
	//输出结果
	Set result=##Class(%ArrayOfDataTypes).%New()
	//血流感染(CLABSI)
	Set flg=##class(DHCHAI.IRC.CSRuleExpZSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	Quit result
}

/// 根据筛查结果返回数组
/// set arr=##class(DHCHAI.IRC.CSResultSrv).GetScreenResult(78900)
/// do $system.OBJ.Dump(arr)
ClassMethod GetScreenResult(aEpisodeDr As %String) As %ArrayOfDataTypes
{
	New (aEpisodeDr)
	
	//输出结果
	Set result=##Class(%ArrayOfDataTypes).%New()
	
	//自报感染
	Set flg=##class(DHCHAI.IRC.CSRule00Srv).GetResult("自报感染",aEpisodeDr,.result)
	
	//检出致病菌
	Set flg=##class(DHCHAI.IRC.CSRule01Srv).GetResult("检出致病菌",aEpisodeDr,.result)
	
	//常规送检
	Set flg=##class(DHCHAI.IRC.CSRule02Srv).GetResult("便常规3天送检3次及以上",aEpisodeDr,.result)
	Set flg=##class(DHCHAI.IRC.CSRule02Srv).GetResult("脑脊液常规7天送检3次及以上",aEpisodeDr,.result)
	
	//常规检验异常
	Set flg=##class(DHCHAI.IRC.CSRule03Srv).GetResult("脑脊液常规异常",aEpisodeDr,.result)
	Set flg=##class(DHCHAI.IRC.CSRule03Srv).GetResult("尿常规2次异常",aEpisodeDr,.result)
	Set flg=##class(DHCHAI.IRC.CSRule03Srv).GetResult("胸水常规异常",aEpisodeDr,.result)
	Set flg=##class(DHCHAI.IRC.CSRule03Srv).GetResult("腹水常规异常",aEpisodeDr,.result)
	Set flg=##class(DHCHAI.IRC.CSRule03Srv).GetResult("C反应蛋白异常",aEpisodeDr,.result)
	Set flg=##class(DHCHAI.IRC.CSRule03Srv).GetResult("降钙素原异常",aEpisodeDr,.result)
	
	//血常规2次异常（均排除入院3天内，手术后3天内）
	//--白细胞异常前后3天内有发热或使用抗菌药物则预警
	//--白细胞异常前后5内有明确感染诊断的不再预警
	Set flg=##class(DHCHAI.IRC.CSRule04Srv).GetResult("血常规2次异常",aEpisodeDr,.result)
	
	//连续发热3天（但手术后3天连续发热排除）
	//--发热前后3天使用抗菌药物或血常规异常产生预警
	//--连续发热5天前后如果有明确的感染诊断则不预警
	Set flg=##class(DHCHAI.IRC.CSRule05Srv).GetResult("连续发热3天",aEpisodeDr,.result)
	
	//启用抗菌药物
	//--入院3天未用，其后使用
	Set flg=##class(DHCHAI.IRC.CSRule06Srv).GetResult("启用抗菌药物",aEpisodeDr,.result)
	
	//抗菌药物等级升级
	//--前后3天有发热或血象升高预警
	//--前后5天有感染诊断排除
	Set flg=##class(DHCHAI.IRC.CSRule07Srv).GetResult("抗菌药物等级升级",aEpisodeDr,.result)
	
	//抗菌药物使用升级（排除手术前1天，手术后3天抗菌药物使用）
	//--抗菌药物使用2天后联用大于3天前联用
	Set flg=##class(DHCHAI.IRC.CSRule08Srv).GetResult("抗菌药物使用升级",aEpisodeDr,.result)
	
	//病程阳性症状或体征
	Set flg=##class(DHCHAI.IRC.CSRule09Srv).GetResult("病程阳性症状或体征",aEpisodeDr,.result)
	
	//放射学检查阳性症状
	Set flg=##class(DHCHAI.IRC.CSRule10Srv).GetResult("放射学检查异常症状",aEpisodeDr,.result)
	
	//再入院
	Set flg=##class(DHCHAI.IRC.CSRule11Srv).GetResult("再入院",aEpisodeDr,.result)
	
	//请感染(呼吸)科会诊
	Set flg=##class(DHCHAI.IRC.CSRule12Srv).GetResult("请感染科会诊",aEpisodeDr,.result)
	
	//诊断血流感染
	Set flg=##class(DHCHAI.IRC.CSRule13Srv).GetResult("诊断血流感染",aEpisodeDr,.result)
	
	//流感样症状监测
	Set flg=##class(DHCHAI.IRC.CSRule14Srv).GetResult("流感样症状监测",aEpisodeDr,.result)
	
	//*************************************************************
	//处理关键词匹配疑似诊断方法
	Set flg=..CheckInfSuPos(aEpisodeDr,.result)
	
	//处理疑似状态及处置状态
	Set flg=..CheckRstStatus(aEpisodeDr,.result)
	//*************************************************************
	
	Quit result
}

/// 处理疑似状态及处置状态
ClassMethod CheckRstStatus(aEpisodeDr As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="") return
	Quit:'$IsObject(%ArrayResult) return
	
	//疑似病例筛查检查天数设置
	Set ScreeningCheckDay=##class(DHCHAI.BT.Config).GetValByCode("IR-CCScreeningCheckDay","")
	Set ScreeningCheckDay=+ScreeningCheckDay
	Set:ScreeningCheckDay=0 ScreeningCheckDay=365
	Set:ScreeningCheckDay<10 ScreeningCheckDay=10
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set CheckEndDate=objEpisode.PADischDate
	Set:CheckEndDate="" CheckEndDate=+$h
	
	//检查合并发热
	Set cfgIsCheckFe=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheckFe")
	Set cfgIsCheckFe=+cfgIsCheckFe
	//检查合并阳性症状或体征方法
	Set cfgIsCheckSx=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheckSx")
	Set cfgIsCheckSx=+cfgIsCheckSx
	Set SxDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetSxDateList(aEpisodeDr)
	//确诊感染日期
	Set InfDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetInfDiagDateList(aEpisodeDr)
	
	For indArr=1:1:%ArrayResult.Count() {
		Set obj=%ArrayResult.GetAt(indArr)
		Continue:'$IsObject(obj)
		Set ItmScreen   = obj.CSItmScreenDr.CCDesc
		Set ItmScreenDr = obj.CSItmScreenDr.%Id()
		Set ItmScreenTxt= obj.CSItmScreenTxt
		Set InfSuKeys   = obj.CSInfSuKeys
		Set RstFromDate = obj.CSRstFromDate
		Set RstToDate   = obj.CSRstToDate
		Set RstStatus   = +obj.CSRstStatus
		Set OprStatus   = +obj.CSOprStatus
		Set SuInfDates  = obj.CSSuInfDates
		Set IsCheckSx   = +obj.CSIsCheckSx
		Set IsCheckFe   = +obj.CSIsCheckFe
		Set IsActive    = obj.CSIsActive
		Continue:IsActive'=1 //是否有效
		
		//疑似筛查确诊/排除记录
		Set tRstFromDate="",tRstToDate=""
		Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeDr,ItmScreenDr," "_$zcvt(ItmScreenTxt,"U"),""),-1)
		If xID'="" {
			Set objScreening=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
			If $IsObject(objScreening){
				Set tStatus=objScreening.CSStatus
				Set tRstFromDate=objScreening.CSRstFromDate
				Set tRstToDate=objScreening.CSRstToDate
				If tStatus=1 { //确诊
					Set RstStatus=1
					If (RstFromDate<tRstFromDate)||(RstToDate>tRstToDate) {
						Set OprStatus=-1
					} Else {
						Set OprStatus=1
					}
				} ElseIf tStatus=2 {  //排除
					Set RstStatus=1
					If (RstFromDate<tRstFromDate)||(RstToDate>tRstToDate) {
						Set OprStatus=-2
					} Else {
						Set OprStatus=2
					}
				} Else {}
			}
		}
		
		Set IsI48Hour=0
		If (RstStatus=0) {
			Set Count=SuInfDates.Count()
			For indSI=1:1:Count {
				Quit:RstStatus=1
				
				Set SIDateInfo=SuInfDates.GetAt(indSI)
				Continue:SIDateInfo=""
				Set ActDate=$listget(SIDateInfo,1)
				Set IsI48Hour=$listget(SIDateInfo,2)    //是否48小时内项目
				Set IsO48Hour=$listget(SIDateInfo,3)    //是否48小时后项目
				Set SISttDate=$listget(SIDateInfo,4)
				Set SIEndDate=$listget(SIDateInfo,5)
				Continue:IsI48Hour>0 //当天有入院48小时内项目
				Continue:(SISttDate="")||(SIEndDate="")
				
				For xDate=SISttDate:1:SIEndDate {
					Quit:RstStatus=1
					Continue:(xDate<(CheckEndDate-ScreeningCheckDay))
					
					//疑似筛查确认/排除区间内不再重复检查
					If (tRstFromDate'="")&(tRstToDate'="") {
						Continue:(xDate>=tRstFromDate)&(xDate<=tRstToDate)
					}
					
					//明确感染诊断前后n天内排除
					If InfDateList'="" {
						Set Days=5,IsAct=0
						For xDay=(xDate-Days+1):1:(xDate+Days-1) {
							Continue:$listfind(InfDateList,xDay)<1
							Set IsAct=1
							Quit
						}
						Continue:IsAct=1
					}
					
					//判断是否有发热
					Set IsFever=1
					If (IsCheckFe>0)&(cfgIsCheckFe>0) {
						Set IsFever=0
						For xDay=(xDate-3):1:(xDate+3) {
							Continue:$listfind(SxDateList,"Fe"_xDay)<1
							Set IsFever=1
							Quit
						}
					}
					//判断是否合并阳性症状或体征
					Set IsSx=1
					If (IsCheckSx>0)&(cfgIsCheckSx>0) {
						Set IsSx=0
						For xDay=(xDate-3):1:(xDate+3) {
							Continue:$listfind(SxDateList,"Sx"_xDay)<1
							Set IsSx=1
							Quit
						}
					}
					If (cfgIsCheckFe>1)&&(cfgIsCheckSx>1) {
						Continue:(IsFever<1)&&(IsSx<1)
					} Else {
						Continue:(IsFever<1)||(IsSx<1)
					}
					
					Set RstStatus=1
					Quit //退出
				}
				//w RstStatus_"--"_IsCheckFe_"/"_cfgIsCheckFe_"--"_IsCheckSx_"/"_cfgIsCheckSx_"--"_ItmScreen_"--"_$zd(ActDate,3)_"【"_$zd(SISttDate,3)_"--"_$zd(SIEndDate,3)_"】",!
			}
		}
		Set obj.CSRstStatus=RstStatus
		Set obj.CSOprStatus=OprStatus
		Set obj.CSIsI48Hour=IsI48Hour
		//w $system.OBJ.Dump(obj)
		Do %ArrayResult.SetAt(obj,indArr)
	}
	Set return=1
	Quit return
}

/// 处理关键词匹配疑似诊断方法
ClassMethod CheckInfSuPos(aEpisodeDr As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="") return
	Quit:'$IsObject(%ArrayResult) return
	
	For indArr=1:1:%ArrayResult.Count() {
		Set %Result=%ArrayResult.GetAt(indArr)
		Continue:'$IsObject(%Result)
		Continue:'$IsObject(%Result.CSItmScreenDr)
		Set ItmScreen=%Result.CSItmScreenDr.CCDesc
		Set ItmScreenDr=%Result.CSItmScreenDr.%Id()
		Set ItmScreenTxt=%Result.CSItmScreenTxt
		Set InfSuKeys=%Result.CSInfSuKeys
		Set RstFromDate=%Result.CSRstFromDate
		Set RstToDate=%Result.CSRstToDate
		Set RstStatus=%Result.CSRstStatus
		Set IsActive=%Result.CSIsActive
		Continue:IsActive'=1 //是否有效
		
		//疑似筛查确认诊断
		Set InfSuPosDr="",InfSuPosDesc=""
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeDr,ItmScreenDr," "_$zcvt(ItmScreenTxt,"U"),xID))
			Quit:xID=""
			Set obj=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CSInfSuPosDr)
			Continue:obj.CSStatus'=1 //只保留确认疑似诊断
			Set InfSuPosDr=obj.CSInfSuPosDr.%Id()
			Set InfSuPosDesc=obj.CSInfSuPosDr.BTDiagnos
			Set %Result.CSInfPosDr=InfSuPosDr
			Set %Result.CSInfPosDesc=InfSuPosDesc
			Do %ArrayResult.SetAt(%Result,indArr)
			Quit //退出循环
		}
		Continue:InfSuPosDr'=""
		
		//疑似筛查确认诊断（感染窗口期）
		Set InfSuPosList=""
		Set InfSuPosDr="",InfSuPosDesc=""
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeDr,xID))
			Quit:xID=""
			Set obj=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CSInfSuPosDr)
			Continue:obj.CSStatus'=1 //只保留确认疑似诊断
			
			Set tRstFromDate=obj.CSRstFromDate
			Set tRstToDate=obj.CSRstToDate
			Continue:RstFromDate<(tRstFromDate-3)  //感染归因期
			Continue:RstFromDate>(tRstToDate+14)   //感染窗口期
			
			Set SuPosDr=obj.CSInfSuPosDr.%Id()
			Set SuPosDesc=obj.CSInfSuPosDr.BTDiagnos
			Continue:$listfind(InfSuPosList,SuPosDr)>0
			Set InfSuPosList=InfSuPosList_$lb(SuPosDr)
			Set InfSuPosDr=InfSuPosDr_";"_SuPosDr
			Set InfSuPosDesc=InfSuPosDesc_";"_SuPosDesc
		}
		Set:InfSuPosDr'="" InfSuPosDr=$e(InfSuPosDr,2,$l(InfSuPosDr))
		Set:InfSuPosDesc'="" InfSuPosDesc=$e(InfSuPosDesc,2,$l(InfSuPosDesc))
		If InfSuPosDesc'="" {
			Set %Result.CSInfPosDr=InfSuPosDr
			Set %Result.CSInfPosDesc=InfSuPosDesc
			Do %ArrayResult.SetAt(%Result,indArr)
		}
		Continue:InfSuPosDr'=""
		
		//疑似筛查关键词匹配诊断
		Set InfSuPosList=""
		Set InfSuPosDr="",InfSuPosDesc=""
		Set InfSuRst=##class(DHCHAI.IRS.CRuleInfSuSrv).CheckInfSuRule(InfSuKeys)
		If InfSuRst'="" {
			For indSuPos=1:1:$listlength(InfSuRst){
				Set tInfSuPos=$listget(InfSuRst,indSuPos)
				Continue:tInfSuPos=""
				Set SuPosDr=$listget(tInfSuPos,2)
				Set SuPosDesc=$listget(tInfSuPos,3)
				Continue:$listfind(InfSuPosList,SuPosDr)>0
				Set InfSuPosList=InfSuPosList_$lb(SuPosDr)
				Set InfSuPosDr=InfSuPosDr_";"_SuPosDr
				Set InfSuPosDesc=InfSuPosDesc_";"_SuPosDesc
			}
		}
		Set:InfSuPosDr'="" InfSuPosDr=$e(InfSuPosDr,2,$l(InfSuPosDr))
		Set:InfSuPosDesc'="" InfSuPosDesc=$e(InfSuPosDesc,2,$l(InfSuPosDesc))
		If InfSuPosDesc'="" {
			Set %Result.CSInfPosDr=InfSuPosDr
			Set %Result.CSInfPosDesc=InfSuPosDesc
			Do %ArrayResult.SetAt(%Result,indArr)
		}
		Continue:InfSuPosDr'=""
	}
	Set return=1
	Quit return
}

/// 判断入院48小时项目过滤
/// w ##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst()
ClassMethod CheckIs48HourRst(obj As DHCHAI.IR.CCResult, aTimeFlag As %String = 0) As %String
{
	New (obj,aTimeFlag)
	Set return=0
	Quit:'$IsObject(obj) return
	
	//判断入院48小时项目过滤
	//同行新算法按日历算，入院2个日历日后，就是从第3天开始算
	Set AdmDate=obj.CCEpisodeDr.PAAdmDate
	Set AdmTime=obj.CCEpisodeDr.PAAdmTime
	If aTimeFlag=0 {
		Set ActDate=obj.CCActDate
		Set ActTime=obj.CCActTime
		Quit:ActDate<(AdmDate+2) return
		//Quit:(ActDate=(AdmDate+2))&(ActTime<AdmTime) return
	} Else {
		Set ActDate=obj.CCRepDate
		Set ActTime=obj.CCRepTime
		Quit:ActDate<(AdmDate+2) return
		//Quit:(ActDate=(AdmDate+2))&(ActTime<AdmTime) return
	}
	Set return=1
	Quit return
}

/// w ##Class(DHCHAI.IRC.CSResultSrv).Test(78900)
ClassMethod Test(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set arr=##class(DHCHAI.IRC.CSResultSrv).GetScreenResult(aEpisodeDr)
	For indArr=1:1:arr.Count() {
		Set obj=arr.GetAt(indArr)
		Continue:'$IsObject(obj)
		
		Set OutputStr=indArr
		Set OutputStr=OutputStr_"-"_obj.CSIsActive
		Set OutputStr=OutputStr_"-"_obj.CSRstStatus
		Set OutputStr=OutputStr_"-"_obj.CSOprStatus
		Set OutputStr=OutputStr_"-"_obj.CSIsI48Hour
		Set OutputStr=OutputStr_"-"_obj.CSItmScreenDr.%Id()
		Set OutputStr=OutputStr_"|"_obj.CSItmScreenDr.CCDesc
		Set OutputStr=OutputStr_"|"_obj.CSResultNote
		Set OutputStr=OutputStr_"|"_obj.CSItmScreenTxt
		Set OutputStr=OutputStr_"|"_obj.CSResultDate
		Set OutputStr=OutputStr_"|"_obj.CSResultCnt
		Set OutputStr=OutputStr_"|"_obj.CSRstFromDate
		Set OutputStr=OutputStr_"|"_obj.CSRstToDate
		Set OutputStr=OutputStr_"|"_obj.CSInfSuKeys
		Set OutputStr=OutputStr_"|"_obj.CSInfDiagnosDr
		Set OutputStr=OutputStr_"|"_obj.CSInfPosDr
		Set OutputStr=OutputStr_"|"_obj.CSInfPosDesc
		Set OutputStr=OutputStr_"|"_obj.CSIsCheckSx
		Write OutputStr,!
		
		//Do $system.OBJ.Dump(obj.CSSuInfDates)
	}
	Quit "OK"
}

/// 合并检查阳性症状或体征
/// w ##class(DHCHAI.IRC.CSResultSrv).CheckSymptom(150,64666,15,"",1)
ClassMethod CheckSymptom(aEpisodeDr As %String, aRstDate As %String, aInfPosDr As %String, aSuPosDr As %String, aRuleDr As %String) As %String
{
	New (aEpisodeDr,aRstDate,aInfPosDr,aSuPosDr,aRuleDr)
	Set return=0
	Quit:(aEpisodeDr="")||(aRstDate="")||(aRuleDr="") return
	
	Set aInfPosDr=##class(DHCHAI.Utils.CommonSrv).ListFromString(aInfPosDr,"#")
	Set aSuPosDr=##class(DHCHAI.Utils.CommonSrv).ListFromString(aSuPosDr,"#")
	Set InfSuDate=aRstDate  //推荐感染日期
    
    Set EmrKey=""
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,"症状或体征(体温+病程)")
	If ArgStr'="" {
		Set SymptomCnt=+$p(ArgStr,"^",5) //体温与病程或者关系，阳性症状限定次数
		Set ObsMax=+$p(ArgStr,"^",2)     //此值小于等于38、大于等于35
		Set ObsMin=+$p(ArgStr,"^",3)     //此值小于等于38、大于等于35
		Set ObsAbDay=+$p(ArgStr,"^",4)   //此值小于等于3
		Set:ObsAbDay<1 ObsAbDay=3
		Set EmrKey=##class(DHCHAI.Utils.CommonSrv).ListFromString($p(ArgStr,"^",1),"#")
		Set EmrAbDay=+$p(ArgStr,"^",4) //此值小于等于3
		Set:EmrAbDay<1 EmrAbDay=3
	} Else {
		Set SymptomCnt=-1                //体温与病程并且关系
		Set ArgStr2=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,"症状或体征(体温)")
		If ArgStr2'="" {
			Set ObsMax=+$p(ArgStr2,"^",2)   //此值小于等于38、大于等于35
			Set ObsMin=+$p(ArgStr2,"^",3)   //此值小于等于38、大于等于35
			Set ObsAbDay=+$p(ArgStr2,"^",4) //此值小于等于3
			Set:ObsAbDay<1 ObsAbDay=3
			Set ObsAbCnt=+$p(ArgStr2,"^",5) //体温，阳性症状限定次数
		} Else {
			Set ObsMax=-1
			Set ObsMin=-1
			Set ObsAbDay=3
			Set ObsAbCnt=-1
		}
		Set ArgStr3=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,"症状或体征(病程)")
		If ArgStr3'="" {
			Set EmrKey=##class(DHCHAI.Utils.CommonSrv).ListFromString($p(ArgStr3,"^",1),"#")
			Set EmrAbDay=+$p(ArgStr3,"^",4) //此值小于等于3
			Set:EmrAbDay<1 EmrAbDay=3
			Set EmrAbCnt=+$p(ArgStr3,"^",5) //病程，阳性症状限定次数
		} Else {
			Set EmrAbCnt=-1
			Set EmrAbDay=3
		}
	}
	Set ArgStr4=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(aRuleDr,"常规检验异常")
	If ArgStr4'="" {
		Set LISKey=##class(DHCHAI.Utils.CommonSrv).ListFromString($p(ArgStr4,"^",1),"#")
		Set LISAbDay=+$p(ArgStr4,"^",4) //此值小于等于3
		Set:LISAbDay<1 LISAbDay=3
		Set LISAbCnt=+$p(ArgStr4,"^",5) //血常规限定次数
	} Else {
		Set LISAbCnt=-1
		Set LISAbDay=3
	}
	//检查是否发热
	Set ObsItemDr="",ObsAbNum=0,ObsAbDays=""
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")  //护理-发热
	If $IsObject(objItem) {
		If objItem.CCIsActive=1 {
			Set ObsItemDr=objItem.%Id()
		}
	}
	
	If ObsItemDr'="" {
		Set xActDate=(aRstDate-ObsAbDay-1)
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ObsItemDr,xActDate))
			Quit:xActDate=""
			Quit:xActDate>(aRstDate+ObsAbDay)
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ObsItemDr,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set ActDate=obj.CCActDate
				Continue:ActDate=""
				
				//合并检查体温限定值
				Set Result=obj.CCResult
				Set TextRes=obj.CCTextRes
				Continue:((ObsMax>0)&&((+Result)<ObsMax))&&((ObsMin>0)&&((+Result)>ObsMin))
				
				//发热日期
				Continue:$listfind(ObsAbDays,ActDate)>0
				Set ObsAbDays=ObsAbDays_$lb(ActDate)
				
				Set:ActDate<InfSuDate InfSuDate=ActDate
			}
		}
	}
	
	Set ObsAbNum=$ll(ObsAbDays)
  
	//检查阳性症状或体征
	Set EmrItemDr="",EmrAbNum=0,EmrSuKey=""
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-Symptom")  //语义-症状或体征
	If $IsObject(objItem) {
		If objItem.CCIsActive=1 {
			Set EmrItemDr=objItem.%Id()
		}
	}
	If EmrItemDr'="" {
		Set xActDate=(aRstDate-EmrAbDay-1)
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,EmrItemDr,xActDate))
			Quit:xActDate=""
			Quit:xActDate>(aRstDate+EmrAbDay)
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,EmrItemDr,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set ActDate=obj.CCActDate
				Continue:ActDate=""
				Set Result=obj.CCResult
				Set TextRes=obj.CCTextRes
				Continue:Result=""
				
				//合并检查病程关键词
				Set IsAbKeyword=0
				Set ThemeWords=##class(DHCHAI.Utils.CommonSrv).ListFromString(Result,";")
				For indKL=1:1:$ll(ThemeWords) {
					Set tThemeWord=$lg(ThemeWords,indKL)
					Continue:tThemeWord=""
					
					If EmrKey'="" {
						Continue:$listfind(EmrSuKey,tThemeWord)>0
						For indEK=1:1:$l(EmrKey,"#") {
							Set tKey=$p(EmrKey,"#",indEK)
							Continue:tKey=""
							Set tKey1=$p(tKey,"+",1)
							Set tKey2=$p(tKey,"+",2)
							Set tKey3=$p(tKey,"+",3)
							Continue:tThemeWord'[tKey1
							Continue:(tKey2'="")&(tThemeWord'[tKey2)
							Continue:(tKey3'="")&(tThemeWord'[tKey3)
							Set EmrSuKey=EmrSuKey_$lb(tThemeWord)
							Set IsAbKeyword=1
						}
					} Else {
						Continue:$listfind(EmrSuKey,tThemeWord)>0
						Set EmrSuKey=EmrSuKey_$lb(tThemeWord)
						Set IsAbKeyword=1
						
						//通过阳性症状或体征推荐感染部位
						If (aInfPosDr="")&&(aSuPosDr="") {
							Set xRuleSuPosID=0
							For {
								Set xRuleSuPosID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyWord2"," "_$zcvt(tThemeWord,"U"),xRuleSuPosID))
								Quit:xRuleSuPosID=""
								
								Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xRuleSuPosID)
								Continue:'$IsObject(obj)
								Continue:'$IsObject(obj.BTCatDr)
								Continue:obj.BTCatDr.BTCode'="5" //阳性症状或体征
								Continue:'$IsObject(obj.BTSuPosDr)
								Set SuPosDr=obj.BTSuPosDr.%Id()
								Continue:$listfind(aSuPosDr,SuPosDr)>0
								Set aSuPosDr=aSuPosDr_$lb(SuPosDr)
							}
						}
					}
					Continue:IsAbKeyword<1
					Set:ActDate<InfSuDate InfSuDate=ActDate
				}
			}
		}
	}
	Set EmrAbNum=$ll(EmrSuKey)
    
    //检查是否常规检验异常
	Set LISItemDr="",LISAbNum=0,LISAbDays=""
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-TestAb")  //常规检验异常
	If $IsObject(objItem) {
		If objItem.CCIsActive=1 {
			Set LISItemDr=objItem.%Id()
		}
	}
	
	If LISItemDr'="" {
		Set xActDate=(aRstDate-LISAbDay-1)
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,LISItemDr,xActDate))
			Quit:xActDate=""
			Quit:xActDate>(aRstDate+LISAbDay)
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,LISItemDr,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
			
				Set ActDate=obj.CCActDate
				Continue:ActDate=""
				
				//异常日期
				Continue:$listfind(LISAbDays,ActDate)>0
				Set LISAbDays=LISAbDays_$lb(ActDate)
				
				Set:ActDate<InfSuDate InfSuDate=ActDate
			}
		}
	}
	
	Set LISAbNum=$ll(LISAbDays)
  
  
	Set EmrSuKey=##class(DHCHAI.Utils.CommonSrv).ListToString(EmrSuKey,"#")
	Set ObsAbDays=##class(DHCHAI.Utils.CommonSrv).ListToString(ObsAbDays,"#")
	Set LISAbDays=##class(DHCHAI.Utils.CommonSrv).ListToString(LISAbDays,"#")
	Set aInfPosDr=##class(DHCHAI.Utils.CommonSrv).ListToString(aInfPosDr,"#")
	Set aSuPosDr=##class(DHCHAI.Utils.CommonSrv).ListToString(aSuPosDr,"#")

    Set return=0_"^"_aInfPosDr_"^"_aSuPosDr_"^"_InfSuDate_"^"_ObsAbDays_"^"_EmrSuKey
	If SymptomCnt=-1 {
		
		Quit:(ObsAbCnt>0)&(ObsAbNum<ObsAbCnt) return   //检查发热天数
		Quit:(EmrAbCnt>0)&(EmrAbNum<EmrAbCnt) return   //检查症状次数
	} Else {
	
		Set SymptomNum=EmrAbNum
		Set:ObsAbNum>0 SymptomNum=SymptomNum+1
		//Quit:(ArgStr4'="")&&(LISAbNum<LISAbCnt) return  //筛查规则 且的关系
		Set LISFlg=0
		Set:ArgStr4="" LISFlg=1  //常规异常次数满足
		Set:(ArgStr4'="")&&(LISAbNum>=LISAbCnt) LISFlg=1  //常规异常次数满足
		Quit:(((SymptomCnt>0)&(SymptomNum<SymptomCnt))&&(LISFlg'=1)) return    //筛查或的关系
	}

	Set return=1_"^"_aInfPosDr_"^"_aSuPosDr_"^"_InfSuDate_"^"_ObsAbDays_"^"_EmrSuKey

	Quit return
}

/// 通过标本取感染部位
/// w ##class(DHCHAI.IRC.CSResultSrv).GetPosBySpec()
ClassMethod GetPosBySpec(aSpecimen As %String) As %String
{
	New (aSpecimen)
	Set return=""
	Quit:aSpecimen="" return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyWord2"," "_$zcvt(aSpecimen,"U"),xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.BTCatDr)
		Continue:obj.BTCatDr.BTCode'="1" //标本
		Continue:'$IsObject(obj.BTSuPosDr)
		Set SuPosDr=obj.BTSuPosDr.%Id()
		Set return=return_$lb(SuPosDr)
	}
	Quit return
}

/// 通过关键词取感染部位
/// w ##class(DHCHAI.IRC.CSResultSrv).GetPosByKeyWord()
ClassMethod GetPosByKeyWord(aKeyWord As %String) As %String
{
	New (aKeyWord)
	Set return=""
	Quit:aKeyWord="" return
	
	Set xSuPosDr=0
	For {
		Set xSuPosDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr))
		Quit:xSuPosDr=""
		
		Set xCateDr=0
		For {
			Set xCateDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr))
			Quit:xCateDr=""
			
			Set objCate=##class(DHCHAI.BT.Dictionary).GetObjById(xCateDr)
			Continue:'$IsObject(objCate)
			Continue:objCate.BTCode'="9"  //关键词
			
			Set xKeyword=""
			For {
				Set xKeyword=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword))
				Quit:xKeyword=""
				
				Set Keyword=$e(xKeyword,2,$l(xKeyword))
				Continue:aKeyWord'[Keyword
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.BTCatDr)
					Continue:'$IsObject(obj.BTSuPosDr)
					Set SuPosDr=obj.BTSuPosDr.%Id()
					Set return=return_$lb(SuPosDr)
				}
			}
		}
	}
	Quit return
}

/// 通过检查部位或项目取感染部位
/// w ##class(DHCHAI.IRC.CSResultSrv).GetPosByCheckUnit("胸片")
ClassMethod GetPosByCheckUnit(aCheckUnit As %String) As %String
{
	New (aCheckUnit)
	Set return=""
	Quit:aCheckUnit="" return
	
	Set xSuPosDr=0
	For {
		Set xSuPosDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr))
		Quit:xSuPosDr=""
		
		Set xCateDr=0
		For {
			Set xCateDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr))
			Quit:xCateDr=""
			
			Set objCate=##class(DHCHAI.BT.Dictionary).GetObjById(xCateDr)
			Continue:'$IsObject(objCate)
			Continue:objCate.BTCode'="3"  //检查部位
			
			Set xKeyword=""
			For {
				Set xKeyword=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword))
				Quit:xKeyword=""
				
				Set Keyword=$e(xKeyword,2,$l(xKeyword))
				Continue:aCheckUnit'[Keyword
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.BTCatDr)
					Continue:obj.BTCatDr.BTCode'="3"  //检查部位
					Continue:'$IsObject(obj.BTSuPosDr)
					Set SuPosDr=obj.BTSuPosDr.%Id()
					Set return=return_$lb(SuPosDr)
				}
			}
		}
	}
	Quit return
}

/// 通过科室取感染部位
/// w ##class(DHCHAI.IRC.CSResultSrv).GetPosByLoc("血液科")
ClassMethod GetPosByLoc(aLocDesc As %String) As %String
{
	New (aLocDesc)
	Set return=""
	Quit:aLocDesc="" return
	
	Set xSuPosDr=0
	For {
		Set xSuPosDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr))
		Quit:xSuPosDr=""
		
		Set xCateDr=0
		For {
			Set xCateDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr))
			Quit:xCateDr=""
			
			Set objCate=##class(DHCHAI.BT.Dictionary).GetObjById(xCateDr)
			Continue:'$IsObject(objCate)
			Continue:objCate.BTCode'="8"  //科室名称
			
			Set xKeyword=""
			For {
				Set xKeyword=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword))
				Quit:xKeyword=""
				
				Set Keyword=$e(xKeyword,2,$l(xKeyword))
				Continue:aLocDesc'[Keyword
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.BTCatDr)
					Continue:'$IsObject(obj.BTSuPosDr)
					Set SuPosDr=obj.BTSuPosDr.%Id()
					Set return=return_$lb(SuPosDr)
				}
			}
		}
	}
	Quit return
}

/// 检查部位致病菌、定值菌
/// w ##class(DHCHAI.IRC.CSResultSrv).CheckPosBact()
ClassMethod CheckPosBact(aSuPosDr As %String, aBacteria As %String) As %String
{
	New (aSuPosDr,aBacteria)
	Set return="^"_aSuPosDr_"^"
	Quit:(aSuPosDr="")||(aBacteria="") return
	
	//检查致病菌、定值菌、检出菌
	Set rInfSuPosDr="",rInfSuPosDr2="",rInfSuPosDr3=""
	For indP=1:1:$l(aSuPosDr,"#"){
		Set xSuPosDr=$p(aSuPosDr,"#",indP)
		Continue:xSuPosDr=""
		
		Set isBactFlag=0
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyWord",xSuPosDr," "_$zcvt(aBacteria,"U"),xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.BTCatDr)
			Continue:obj.BTCatDr.BTCode'="2" //菌
			If obj.BTProperty=0 {
				Set isBactFlag=1   //定值菌
				Set rInfSuPosDr3=rInfSuPosDr3_$lb(xSuPosDr)
			} Else {
				Set isBactFlag=2   //致病菌
				Set rInfSuPosDr=rInfSuPosDr_$lb(xSuPosDr)
			}
		}
		Continue:isBactFlag>0
		
		Set rInfSuPosDr2=rInfSuPosDr2_$lb(xSuPosDr)  //检出菌
	}
	Set rInfSuPos=##class(DHCHAI.Utils.CommonSrv).ListToString(rInfSuPosDr,"#")
	Set rInfSuPos2=##class(DHCHAI.Utils.CommonSrv).ListToString(rInfSuPosDr2,"#")
	Set rInfSuPos3=##class(DHCHAI.Utils.CommonSrv).ListToString(rInfSuPosDr3,"#")
	Set return=rInfSuPos_"^"_rInfSuPos2_"^"_rInfSuPos3  //推荐感染部位^疑似感染部位^排除感染部位
	Quit return
}

/// 通过诊断名取感染诊断
/// zw ##class(DHCHAI.AMC.CSResultSrv).GetPosByDiagnos("上呼吸道感染")
ClassMethod GetPosByDiagnos(aDiagnos As %String) As %String
{
	New (aDiagnos)
	Set return=""
	Quit:aDiagnos="" return

	Set xSuPosDr=0
	For {
		Set xSuPosDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr))
		Quit:xSuPosDr=""
		
		Set xCateDr=0
		For {
			Set xCateDr=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr))
			Quit:xCateDr=""
			
			Set objCate=##class(DHCHAI.BT.Dictionary).GetObjById(xCateDr)
			Continue:'$IsObject(objCate)
			Continue:objCate.BTCode'="4" //诊断名称
			
			Set xKeyword=""
			For {
				Set xKeyword=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword))
				Quit:xKeyword=""
				
				Set Keyword=$e(xKeyword,2,$l(xKeyword))
				Continue:aDiagnos'[Keyword
		
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofSuPosCatKey",xSuPosDr,xCateDr,xKeyword,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.BTCatDr)
					Continue:'$IsObject(obj.BTSuPosDr)
					Set SuPosDr=obj.BTSuPosDr.%Id()
					Continue:$listfind(return,SuPosDr)>0
					Set return=return_$lb(SuPosDr)
				}
			}
		}
	}
	Quit return
}

/// 获取入院感染诊断对应感染部位
/// w ##class(DHCHAI.AMC.CSResultSrv).GetAdmDiagnos(95537)
ClassMethod GetAdmDiagnos(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=""
	Quit:aEpisodeDr="" return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set AdmDate=objEpisode.PAAdmDate
	Set DischDate=objEpisode.PADischDate
	
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-AdmDiagnos")   //入院诊断
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemMastDr=objItem.%Id()
   
    Set DiagnosList = ""
	Set xActDate=AdmDate-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemMastDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>DischDate
	   
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemMastDr,xActDate,xID))
			Quit:xID=""
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
	
			Continue:obj.CCIsActive'=1
			Continue:obj.CCIsAbFlag=1    //手术切口感染计为院内感染，不过滤
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""		
			//诊断
			Set Diagnos=obj.CCResult
			
		 	Continue:$listfind(DiagnosList,Diagnos)>0
			Set DiagnosList=DiagnosList_$lb(Diagnos)
		}
	}
  
	Set InfPosList=""
	Set InfPosIDList=""
	//诊断名称查找诊断部位
    For indPos = 1:1:$l(DiagnosList) {
	    Set Keyword = $lg(DiagnosList,indPos)
	    Continue:Keyword=""

		Set xID=""
	    For {
			Set xID=$o(^DHCHAI.IR.CRuleInfSuPosI("IdxofKeyWord2"," "_$zcvt(Keyword,"U"),xID))
			Quit:xID=""
		
			Set obj=##class(DHCHAI.IR.CRuleInfSuPos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.BTCatDr)
			Continue:'$IsObject(obj.BTSuPosDr)
			Continue:'$IsObject(obj.BTSuPosDr.BTInfPosDr)
			
			Set InfPosID=obj.BTSuPosDr.BTInfPosDr.%Id()
			Set InfPosCode=obj.BTSuPosDr.BTInfPosDr.BTCode
			Set DiagFlag=obj.BTSuPosDr.BTInfPosDr.BTDiagFlag
			Set InfPos = obj.BTSuPosDr.BTInfPosDr.BTDesc
		
			If (DiagFlag=1)&&(InfPos'="新生儿感染") {
				Set Code = $e(InfPosCode,1,2)
				Set objInf = ##class(DHCHAI.BT.InfPos).GetObjByCode(Code)
				Continue:'$IsObject(objInf)
				Set InfPosID = objInf.%Id()
				Set InfPos = objInf.BTDesc
			}
			Continue:$listfind(InfPosIDList,InfPosID)>0
			Set InfPosIDList=InfPosIDList_$lb(InfPosID)
			Set InfPosList = InfPosList_","_InfPosID_"^"_InfPos
		}
	}
	Set:InfPosList'="" InfPosList=$e(InfPosList,2,$l(InfPosList))
    Set return = InfPosList
    
	Quit return
}

/// 根据筛查结果返回数组
/// set arr=##class(DHCHAI.IRC.CSResultSrv).GetSuRuleResult(142380,$h-30,$h-1)
/// do $system.OBJ.Dump(arr)
ClassMethod GetSuRuleResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %ArrayOfDataTypes
{
	New (aEpisodeDr,aDateFrom,aDateTo)
	
	//输出结果
	Set result=##Class(%ArrayOfDataTypes).%New()
	
	//无菌部位标本检出菌
	//就诊号150 标本胆汁 检出菌产气肠杆菌和屎肠球菌 送检时间2018-01-18 报告时间2018-01-20
	Set flg=##class(DHCHAI.IRC.CSRuleExpASrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//清洁标本培养阳性
	//就诊号328 标本痰  检出菌大肠埃希菌和嗜麦芽窄食单胞菌  送检时间2018-01-14  报告时间2018-01-17
	Set flg=##class(DHCHAI.IRC.CSRuleExpBSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//血流感染(CLABSI) 
	//就诊号930418 
	Set flg=##class(DHCHAI.IRC.CSRuleExpZSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	If (flg<1){
		//诊断血流感染
		//就诊号2405 标本外周静脉血  检出菌表皮葡萄球菌    送检时间2018-01-28 报告时间2018-02-02
		//                                                 送检时间2018-02-01 报告时间2018-02-05
		//就诊号748  标本外周静脉血  检出菌金黄色葡萄球菌  送检时间2018-01-18 报告时间2018-01-21
		Set flg=##class(DHCHAI.IRC.CSRuleExpCSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	}
	
	
	//常规检验异常
	//就诊号818  标本血  血常规异常/降钙素原异常  送检时间2018-01-01至2018-01-11
	Set flg=##class(DHCHAI.IRC.CSRuleExpDSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//放射影像学检查异常
	//就诊号823  床旁胸片  申请时间2018-01-08  报告时间2018-01-09  两肺;感染;  ***报告无效
	//           床旁胸片  申请时间2018-01-10  报告时间2018-01-11  右肺;感染灶;  ***报告无效
    //就诊号77054  床旁胸片  申请时间2019-01-10  报告时间2019-01-11  斑片影;感染
	Set flg=##class(DHCHAI.IRC.CSRuleExpESrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//医生诊断
	Set flg=##class(DHCHAI.IRC.CSRuleExpFSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//手术或组织病理学探查（无）
	
	//临床所见（无）
	
	//抗感染治疗
	//就诊号77363  使用抗生素  开始时间2018-12-19  结束时间2019-01-25
	//就诊号79064  使用抗生素  开始时间2018-12-26  结束时间2019-01-19
	Set flg=##class(DHCHAI.IRC.CSRuleExpISrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//启用治疗性抗菌药物
	Set flg=##class(DHCHAI.IRC.CSRuleExpIASrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//抗菌药物等级升级且联用升级
	Set flg=##class(DHCHAI.IRC.CSRuleExpIBSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
   
   	//停药48h后启用治疗性抗菌药物
	Set flg=##class(DHCHAI.IRC.CSRuleExpICSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//持续发热{3}天及以上
	//就诊号85  持续发热  发热时间2018-01-07、2018-01-08、2018-01-09
	Set flg=##class(DHCHAI.IRC.CSRuleExpJSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//腹泻(大便次数异常)
	//就诊号81570  腹泻4次  腹泻时间2019-01-10
    //      81452  腹泻※次  腹泻时间2019-01-10
	Set flg=##class(DHCHAI.IRC.CSRuleExpKSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//与血培养合并检出相同菌
	//就诊号88196  检出菌（表皮葡萄球菌）  标本（外周静脉血、脐部拭子）  送检时间（2019-02-13、2019-02-14）  报告时间（2019-02-16）
	Set flg=##class(DHCHAI.IRC.CSRuleExpLSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//{7}日内有{2}日培养出同种菌
	//就诊号83537  检出菌（大肠埃希菌）  标本（痰(口痰)、支气管肺泡灌洗液）  送检时间（2019-02-12、2019-02-13）  报告时间（2019-02-15、2019-02-16）
	Set flg=##class(DHCHAI.IRC.CSRuleExpMSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//{7}日内送检{3}次及以上
	//就诊号78535  便常规送检  3天送检3次  送检时间（2019-01-02、2019-01-04）  报告时间（2019-01-02、2019-01-04）
	Set flg=##class(DHCHAI.IRC.CSRuleExpNSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//疑似感染再入院
	Set flg=##class(DHCHAI.IRC.CSRuleExpOSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//请感染科会诊
	//就诊号78242  请感染科会诊  医嘱时间（2019-01-03）  申请科室骨科  接收科室感染科
	Set flg=##class(DHCHAI.IRC.CSRuleExpPSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//清创手术
	Set flg=##class(DHCHAI.IRC.CSRuleExpQSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//丙级愈合手术
	Set flg=##class(DHCHAI.IRC.CSRuleExpRSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	
	//add 20200421  筛查病程关键词，处理需求1168482
	Set flg=##class(DHCHAI.IRC.CSRuleExpTSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//手工添加感染诊断
	Set flg=##class(DHCHAI.IRC.CSRuleExpUSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)
	
	//病毒支原体
	Set flg=##class(DHCHAI.IRC.CSRuleExpVSrv).GetResult(aEpisodeDr,aDateFrom,aDateTo,.result)

    
    //疑似筛查是否启用权重组合判断规则
    Set IsStart=##class(DHCHAI.BT.Config).GetValByCode("IR-IsStartWeightScreen")
    If (IsStart=1) {
	    //是否显示负权重项目、负权重是否参与计算
	    Set IsShowCnt=##class(DHCHAI.BT.Config).GetValByCode("IR-IsShowAndCntNeg")
	    Set IsShow =$p(IsShowCnt,"-",1)
	    Set IsCnt =$p(IsShowCnt,"-",2)
	    Set:IsShow="" IsShow =1
		Set:IsCnt="" IsCnt =1
	    For indType=1:1:50 {
		    Set RuleType="DIAG"_indType
		    Continue:'$d(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," "_$zcvt(RuleType,"U")))
		    Set flg=##class(DHCHAI.IRC.CSRuleUNExpSrv).GetResult(aEpisodeDr,RuleType,IsCnt,IsShow,aDateFrom,aDateTo,.result)
		    
	    }
    }
    
	//处理处置状态
	Set flg=..CheckSuRuleStatus(aEpisodeDr,.result)
	
	Quit result
}

/// 处理处置状态
ClassMethod CheckSuRuleStatus(aEpisodeDr As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="") return
	Quit:'$IsObject(%ArrayResult) return
	
	Set AttPerDays=##class(DHCHAI.BT.Config).GetValByCode("IR-AttributionPer")
	Set ConfirmDay=$p(AttPerDays,"-",1) //感染归因期（确诊后n天内不需重复处理）
	Set ExcludeDay=$p(AttPerDays,"-",2) //排除后n天内不需重复处理
	Set:ConfirmDay="" ConfirmDay =14
	Set:ExcludeDay="" ExcludeDay =3
	
	For indArr=1:1:%ArrayResult.Count() {
		Set obj=%ArrayResult.GetAt(indArr)
		Continue:'$IsObject(obj)
		Set IsActive    = obj.CSIsActive
		Continue:IsActive'=1 //是否有效
		
		Set ItmScreen   = obj.CSItmScreenDr.CCDesc
		Set ItmScreenDr = obj.CSItmScreenDr.%Id()
		Set ItmScreenTxt= $tr(obj.CSItmScreenTxt," ","")
		Set RstStatus   = +obj.CSRstStatus
		Set OprStatus   = +obj.CSOprStatus		
		Set RstFromDate = obj.CSRstFromDate
		Set RstToDate   = obj.CSRstToDate
		Set InfSuKeys   = obj.CSInfSuKeys
		Set ResultDate  = obj.CSResultDate   //结果日期
		Set ResultCnt   = obj.CSResultCnt    //结果数量
	    Set InfSuPosDr  = obj.CSInfSuPosDr   //(新增)疑似诊断（部位）ID
		Set SuInfDate   = obj.CSInfSuDate    //(新增)推荐感染日期
		Set Specimen    = obj.CSSpecimen     //(新增)标本名称（多值#分隔）
		Set MRBType     = obj.CSMRBType      //(新增)多耐分类名称（多值#分隔）
		Set InfSuRuleDr = obj.CSInfSuRuleDr  //(新增)规则ID（多值#分隔）
		
		//疑似筛查确诊/排除记录
		Set tRstFromDate="",tRstToDate=""
		Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeDr,ItmScreenDr," "_$zcvt(ItmScreenTxt,"U"),""),-1)
		If xID'="" {
			Set objScreening=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
			If $IsObject(objScreening){
				Set tStatus=objScreening.CSStatus
				Set tRstFromDate=objScreening.CSRstFromDate
				Set tRstToDate=objScreening.CSRstToDate
				If tStatus=1 { //确诊
					Set OprStatus=1  
					If (ResultDate>tRstToDate) {
						If (ResultDate<=(tRstToDate+ConfirmDay)) {   //确诊n天内不需重复确诊
							Set OprStatus=-1
						} Else {
							Set OprStatus=0
						}
					}
				} ElseIf tStatus=2 {  //排除
					Set OprStatus=2
					If (ResultDate>tRstToDate) {
						If (ResultDate<=(tRstToDate+ExcludeDay)) {
							Set OprStatus=-2
						}Else {
							Set OprStatus=0
						}
					}
				}
			}
		}
		Set obj.CSOprStatus=OprStatus
		
		//w $system.OBJ.Dump(obj)
		Do %ArrayResult.SetAt(obj,indArr)
	}
	Set return=1
	Quit return
}

/// w ##Class(DHCHAI.IRC.CSResultSrv).Test2(147509,$zdh("2019-08-01",3),$zdh("2019-10-29",3))
ClassMethod Test2(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo)
	Set arr=##class(DHCHAI.IRC.CSResultSrv).GetSuRuleResult(aEpisodeDr,aDateFrom,aDateTo)
	For indArr=1:1:arr.Count() {
		Set obj=arr.GetAt(indArr)
		Continue:'$IsObject(obj)
		
		Do $system.OBJ.Dump(obj)
	
		Set OutputStr=indArr
		Set OutputStr=OutputStr_"-"_obj.CSIsActive
		Set OutputStr=OutputStr_"-"_obj.CSRstStatus          //结果状态(0触发疑似指标、1触发组合条件、2作废|感染诊断)
		Set OutputStr=OutputStr_"-"_obj.CSItmScreenDr.%Id()  //筛查项目
		Set OutputStr=OutputStr_"|"_obj.CSItmScreenDr.CCDesc 
		Set OutputStr=OutputStr_"|"_obj.CSResultNote
		Set OutputStr=OutputStr_"|"_obj.CSItmScreenTxt
		Set OutputStr=OutputStr_"|"_obj.CSResultDate      //结果日期
		Set OutputStr=OutputStr_"|"_obj.CSResultCnt       //结果数量
		Set OutputStr=OutputStr_"|"_obj.CSRstFromDate     //结果开始日期
		Set OutputStr=OutputStr_"|"_obj.CSRstToDate       //结果截止日期
		Set OutputStr=OutputStr_"|"_obj.CSInfSuKeys       //疑似诊断关键词信息
		Set OutputStr=OutputStr_"|"_obj.CSInfSuPosDr   //(新增)疑似诊断（部位）ID
		Set OutputStr=OutputStr_"|"_obj.CSInfSuDate    //(新增)推荐感染日期
		Set OutputStr=OutputStr_"|"_obj.CSSpecimen     //(新增)标本名称（多值#分隔）
		Set OutputStr=OutputStr_"|"_obj.CSMRBType      //(新增)多耐分类名称（多值#分隔）
		Set OutputStr=OutputStr_"|"_obj.CSInfSuRuleDr  //(新增)规则ID（多值#分隔）
		Set OutputStr=OutputStr_"|"_obj.CSOprStatus
		Set OutputStr=OutputStr_"|"_obj.CSDetails
		
		Write OutputStr,!
		
	}
	Quit "OK"
}

}
