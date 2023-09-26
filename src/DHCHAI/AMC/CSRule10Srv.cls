/// 名称: DHCHAI.AMC.CSRule09Srv
/// 描述: 疑似病例筛查规则--放射学检查阳性症状
/// 编写者：zhufei
/// 编写日期: 2017-10-15
Class DHCHAI.AMC.CSRule10Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRule09Srv).GetResult("放射学检查异常症状",616,.arr)
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
	Set KeyWords=objItmScreen.CCKeyWords
	
	Kill arrResult
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="RME-Radiology"  //检查-放射学检查
		
		Set xActDate=""
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate))
			Quit:xActDate=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCRepDate  //update by zf 检查按报告时间
				Continue:ActDate=""
				
				Set Result=obj.CCResult
				Continue:Result=""
				Set IsAbFlag=obj.CCIsAbFlag
				Continue:IsAbFlag'=1
				
				Set arrResult(ActDate,"Rst",xID)=$lb(xID,ActDate,Result)
				
				//判断是否入院48小时后项目
				Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj,1)
				Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit:$o(arrResult(0))="" return
	
	Set SuInfDates=##Class(%ListOfDataTypes).%New()
	Set FromDate="",ToDate="",ResultCnt=0,InfSuKeys=""
	Set xActDate="",xAntiCnt=""
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		
		Continue:'$d(arrResult(xActDate,"Rst"))  //当天无记录退出
		
		Set SISttDate=xActDate
		Set SIEndDate=xActDate
		Set IsI48Hour=$d(arrResult(xActDate,"48H",0))
		Set IsO48Hour=$d(arrResult(xActDate,"48H",1))
		Set SuInfData=$lb(xActDate,IsI48Hour,IsO48Hour,SISttDate,SIEndDate)
		Do SuInfDates.Insert(SuInfData)
		
		//add by zf 20171205 显示所有次数
		Set xID=0
		For {
			Set xID=$o(arrResult(xActDate,"Rst",xID))
			Quit:xID=""
			Set ResultCnt=ResultCnt+1
			Set tResult=$g(arrResult(xActDate,"Rst",xID))
			Set InfSuKeys=InfSuKeys_"^"_$listget(tResult,3)
		}
		//Set ResultCnt=ResultCnt+1
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
	Set obj.CSInfSuKeys    = InfSuKeys
	Set obj.CSSuInfDates   = SuInfDates  //疑似感染日期（日期区间）
	
	Set ArrCnt=%ArrayResult.Count()
	Do %ArrayResult.SetAt(obj,ArrCnt+1)
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
