/// 名称: DHCHAI.AMC.CSRuleExpJSrv
/// 描述: 疑似病例筛查规则解析---持续发热{3}天及以上
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.AMC.CSRuleExpJSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpJSrv).GetResult()
ClassMethod GetResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	Quit:'$IsObject(%ArrayResult) return
	
	//规则表达式
	Kill arrRuleExp
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," J",xRuleDr))
		Quit:xRuleDr=""
		
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(xRuleDr)
		Continue:'$IsObject(objRule)
		Continue:objRule.BTIsActive'=1
		Continue:'$IsObject(objRule.BTItmScreenDr)
		Set ItmScreenDr=objRule.BTItmScreenDr.%Id()
		Set objScreen = ##class(DHCHAI.IR.CCItmScreen).GetObjById(ItmScreenDr)
		Continue:'$IsObject(objScreen)
		Set ItmScreenDesc=objScreen.CCDesc
		Set ItmScreenDesc2=objScreen.CCDesc2
		Set:ItmScreenDesc2'="" ItmScreenDesc=ItmScreenDesc2
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,ItmScreenDesc)
	}
	//感染规则筛查参数
	Set RuleDr=$o(arrRuleExp(0))
	Quit:RuleDr="" return
	Set tRuleInfo=$g(arrRuleExp(RuleDr))
	Set ItmScreenDr=$lg(tRuleInfo,2)
	Set ItmScreenDesc=$lg(tRuleInfo,3)
	//持续发热参数
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(RuleDr,"持续发热")
	Quit:ArgStr="" return
	Set ObsMax=+$p(ArgStr,"^",2)   //体温上限
	Set ObsMin=+$p(ArgStr,"^",3)   //体温下限
	Set ObsDay=+$p(ArgStr,"^",4)   //持续天数
	Set:ObsDay<=1 ObsDay=3
	
	//无需筛查连续三天发热的重点科室
	Set ExFerverLocList=##class(DHCHAI.BT.Config).GetValByCode("ExFerverLocList")
	Set ExFerverLocList=##class(DHCHAI.Utils.CommonSrv).ListFromString(ExFerverLocList,",")	 

	//MR-ObsFever	护理-发热
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//持续发热结果
	Kill arrResult
	Set AdmDate="",ActDates=""
	Set xActDate=(aDateFrom-ObsDay-1)
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>(aDateTo+ObsDay)
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
			//增加重点科室过滤 add 20210420
			Set TranInfo= ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeDr,ActDate,ActTime)
			Set ActLocDr=$p(TranInfo,"^",1)
			Continue:(ExFerverLocList'="")&($listfind(ExFerverLocList,ActLocDr)>0)

			Set Result=obj.CCResult
			Set IsError=0
			If (ObsMax'=0)&&(Result>ObsMax){
				Set IsError=1
			} ElseIf (ObsMin'=0)&&(Result<ObsMin) {
				Set IsError=1
			}
			Continue:IsError<1
			
			Set Summary=obj.CCSummary
			Set TextRes=obj.CCTextRes
			
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			
			//一天只需记录一次异常
			If ActDate'="" {
				Continue:$listfind(ActDates,ActDate)>0 
				Set ActDates=ActDates_$lb(ActDate)
			}
			
			Set arrResult(ActDate,"RST",xID)=$lb(xID,TextRes,Summary,ActDate,ActTime)
			//判断是否入院48小时后项目
			Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
			Set arrResult(ActDate,"48H",+flg)=""
		}
	}
	Quit:$o(arrResult(0))="" return
	
	Set IsCheck48=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheck48")  //0：不计入，1：计入

	//术前日期
	//Set OperPrevDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperPrevDateList(aEpisodeDr,ObsDay)
	//术后日期
	Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,3)
		
	//感染规则判断及结果输出
	Set xActDate=0
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		Continue:xActDate<aDateFrom
		Continue:xActDate>aDateTo
		
		//术前n天排除
		//Continue:(OperPrevDateList'="")&($listfind(OperPrevDateList,xActDate)>0)
		//术后n天排除
		Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xActDate)>0)
			
		//判断是否持续发热ObsDay天
		Set CurrActDate=0,AbCnt=0
		Set yActDate=(xActDate-ObsDay)
		For {
			Set yActDate=$o(arrResult(yActDate))
			
			Quit:yActDate=""
			Quit:yActDate>(xActDate+ObsDay-1)
		
		    //术后n天排除
			Continue:(OperNextDateList'="")&($listfind(OperNextDateList,yActDate)>0)
		    Set IsI48Hour=$d(arrResult(yActDate,"48H",0))
		    Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目
		    
			If (yActDate-CurrActDate)>1 {
				Set AbCnt=1
			} Else {
				Set AbCnt=AbCnt+1
			}
			Set CurrActDate=yActDate	
			
		}
		Continue:AbCnt<ObsDay
	
	
		//触发次数、触发日期、多耐结果
		Set InfSuPosDr=""       //推荐感染部位
		Set InfSuPosDr2=""  	//疑似感染部位
		Set ResultCnt=0
		Set ResultDate=xActDate
		Set xID=0
		For {
			Set xID=$o(arrResult(xActDate,"RST",xID))
			Quit:xID=""
			
			Set tResultInfo=$g(arrResult(xActDate,"RST",xID))
			Continue:tResultInfo=""
			Set ResultCnt=ResultCnt+1
		}
		Continue:ResultCnt<1
	
		//合并检查阳性症状或体征
		Set tSymptomInfo=##class(DHCHAI.AMC.CSResultSrv).CheckSymptom(aEpisodeDr,xActDate,InfSuPosDr,InfSuPosDr2,RuleDr)
		Set SyResult=+$p(tSymptomInfo,"^",1)
		Set SyInfPosDr=$p(tSymptomInfo,"^",2)
		//Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
		Set SySuPosDr=$p(tSymptomInfo,"^",3)
		Set InfSuDate=$p(tSymptomInfo,"^",4)
		Set:InfSuDate="" InfSuDate=xActDate
		Set ObsAbDay=$p(tSymptomInfo,"^",5)
		Set EmrSuKey=$p(tSymptomInfo,"^",6)
		
		//疑似关键词
		Set InfSuKeys="持续发热"
		Set:EmrSuKey'="" InfSuKeys=InfSuKeys_"#"_EmrSuKey
		
		//显示结果
		Set ResultNote=ItmScreenDesc
		
		Set ItmScreenTxt=""
		
		//如果确诊，以确诊感染部位为准；如果未确诊，以疑似感染部位为准
		Set:InfSuPosDr="" InfSuPosDr=InfSuPosDr2
		
		Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenDr)
		Continue:'$IsObject(obj)
		Set obj.CSItmScreenTxt = ItmScreenTxt    //附加项目描述
		Set obj.CSResultNote   = ResultNote      //显示结果
		Set obj.CSResultDate   = ResultDate      //结果日期
		Set obj.CSResultCnt    = ResultCnt       //结果数量
		Set obj.CSInfSuKeys    = InfSuKeys       //疑似关键词
		Set obj.CSInfSuPosDr   = InfSuPosDr      //推荐感染部位
		Set obj.CSInfSuDate    = InfSuDate       //推荐感染日期
		Set obj.CSInfSuRuleDr  = RuleDr          //规则
		Set obj.CSRstStatus    = 1               //结果状态(0触发疑似指标、1触发组合条件)
       
		Set ArrCnt=%ArrayResult.Count()
		Do %ArrayResult.SetAt(obj,ArrCnt+1)
	}
	Kill arrResult
	Kill arrRuleExp
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
