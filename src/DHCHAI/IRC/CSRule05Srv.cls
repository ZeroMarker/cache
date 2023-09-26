/// 名称: DHCHAI.IRC.CSRule05Srv
/// 描述: 疑似病例筛查规则--连续发热3天
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.IRC.CSRule05Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule05Srv).GetResult("连续发热3天",610,.arr)
ClassMethod GetResult(aItmScreen As %String, aEpisodeID As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aItmScreen,aEpisodeID,%ArrayResult)
	Set return=0
	Quit:(aItmScreen="")||(aEpisodeID="") return
	Quit:'$IsObject(%ArrayResult) return
	
	Set objItmScreen=##class(DHCHAI.IR.CCItmScreen).GetObjByDesc(aItmScreen)
	Quit:'$IsObject(objItmScreen) return
	Quit:objItmScreen.CCIsActive'=1 return
	Set ItmScreenID=objItmScreen.%Id()
	Set ItmScreenDesc=objItmScreen.CCDesc
	Set:objItmScreen.CCDesc2'="" ItmScreenDesc=objItmScreen.CCDesc2
	Set KeyWords=objItmScreen.CCKeyWords    //关键字
	
	Kill arrResult
	Set xItemID=0,num=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="MR-ObsFever"  //护理-发热 监控项目定义
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:KeyWords'[tKeyword  //发热
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Set arrResult(ActDate,"Rst",xID)=$lb(xID,ActDate)
				
				//判断是否入院48小时后项目
				Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit:$o(arrResult(0))="" return
	
	//（*）连续发热{A1}天
	//（1）但手术后{A2}天连续发热排除
	//（2）发热前后{A3}天使用抗菌药物或血常规异常产生预警
	Set Arg1=objItmScreen.CCArg1
	Set Arg2=objItmScreen.CCArg2
	Set Arg3=objItmScreen.CCArg3
	Set Arg1=+Arg1
	Set Arg2=+Arg2
	Set Arg3=+Arg3
	
	//术后日期
	Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeID,Arg2)
	
	//血常规异常+抗菌药物使用日期
	Set BloodTestDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetBloodTestDateList(aEpisodeID)
	Set AntiDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetAntiDateList(aEpisodeID)
	Set BloAntDateList=BloodTestDateList_AntiDateList
	
	Set SuInfDates=##Class(%ListOfDataTypes).%New()
	Set FromDate="",ToDate="",ResultCnt=0,InfSuKeys=""
	Set xActDate=""
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		
		Continue:'$d(arrResult(xActDate,"Rst"))  //当天无记录退出
		
		//判断是否连续发热Arg1天
		Set IsActCount=0
		Set SISttDate="",SIEndDate=""
		For xDate=(xActDate-Arg1+1):1:xActDate {
			Continue:'$d(arrResult(xDate))
			
			//术后n天排除
			Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xDate)>0)
			
			Set IsActCount=IsActCount+1
			Set SISttDate=$s(SISttDate="":xDate,SISttDate>xDate:xDate,1:SISttDate)
			Set SIEndDate=$s(SIEndDate="":xDate,SIEndDate<xDate:xDate,1:SIEndDate)
		}
		Continue:IsActCount<1
		Continue:IsActCount<Arg1
		
		//血常规异常或使用抗菌药物n天内
		If (+Arg3)>0 {
			Set Days=Arg3,IsAct=0
			For xDate=(xActDate-Days+1):1:(xActDate+Days-1) {
				Continue:$listfind(BloAntDateList,xDate)<1
				Set IsAct=1
				Quit
			}
			Continue:IsAct'=1
		}
		
		Set IsI48Hour=$d(arrResult(xActDate,"48H",0))
		Set IsO48Hour=$d(arrResult(xActDate,"48H",1))
		Set SuInfData=$lb(xActDate,IsI48Hour,IsO48Hour,SISttDate,SIEndDate)
		Do SuInfDates.Insert(SuInfData)
		
		Set ResultCnt=ResultCnt+1
		Set:FromDate="" FromDate=SISttDate
		Set ToDate=SIEndDate
	}
	Kill arrResult
	Quit:ResultCnt<1 return
	
	Set ResultNote=ItmScreenDesc
	If FromDate=ToDate {
		//Set ResultDate=$zd(FromDate,3)
		Set ResultDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FromDate)
	} Else {
		//Set ResultDate=$zd(FromDate,3)_"～"_$zd(ToDate,3)
		Set ResultDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FromDate)_"～"_##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ToDate)
	}
	Set ItmScreenTxt=""
	Set RstFromDate=FromDate
	Set RstToDate=ToDate
	
	Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenID)
	Quit:'$IsObject(obj) return
	Set obj.CSItmScreenTxt = ItmScreenTxt
	Set obj.CSResultNote   = ResultNote
	Set obj.CSResultDate   = ResultDate
	Set obj.CSResultCnt    = ResultCnt
	Set obj.CSRstFromDate  = RstFromDate
	Set obj.CSRstToDate    = RstToDate
	Set obj.CSInfSuKeys    = "发热"
	Set obj.CSSuInfDates   = SuInfDates  //疑似感染日期（日期区间）
	Set obj.CSIsCheckSx    = 1 //是否检查阳性症状或体征
	Set obj.CSIsCheckFe    = 0 //是否检查发热
	
	Set ArrCnt=%ArrayResult.Count()
	Do %ArrayResult.SetAt(obj,ArrCnt+1)
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
