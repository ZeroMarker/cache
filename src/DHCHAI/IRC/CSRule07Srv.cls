/// 名称: DHCHAI.IRC.CSRule07Srv
/// 描述: 疑似病例筛查规则--抗菌药物等级升级
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.IRC.CSRule07Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule07Srv).GetResult("抗菌药物等级升级",9,.arr)
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
		Continue:objItmMast.CCCode'="OE-AntiUse"  //医嘱-抗菌用药
		
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
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Set AntiGrade=obj.CCAntiGrade
				Continue:AntiGrade=""
				Set objMap=##class(DHCHAI.DP.PhraseMap).GetObjByCode(SCode,"DrgPoison",AntiGrade)
				If $IsObject(objMap){
					Set AntiGrade=objMap.BTCode
				}
				Set:AntiGrade="KSS1" AntiGrade=1
				Set:AntiGrade="KSS2" AntiGrade=2
				Set:AntiGrade="KSS3" AntiGrade=3
				//Set arrResult(ActDate,"Rst",AntiGrade)=""
				//Set arrResult(ActDate,"IDs",xID)=$lb(xID,ActDate)
				Set IsNotEnd=obj.CCIsNotEnd   //考虑长期医嘱情况
				Set XDate=$s(RepDate'="":RepDate,1:"")
				Set:(XDate="")&(IsNotEnd=1) XDate=ActDate
				Set:(XDate="")&(IsNotEnd=0) XDate=+$h
				For indDate=ActDate:1:XDate {
					Set arrResult(indDate,"Rst",AntiGrade)=""
				}
				Set arrResult(ActDate,"IDs",xID)=$lb(xID,ActDate)
				
				//判断是否入院48小时后项目
				Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit:$o(arrResult(0))="" return
	
	//（*）抗菌药物等级升级
	//（1）前后{A1}天有发热或血象升高预警
	//（2）排除手术前{A3}天，手术后{A4}天抗菌药物使用
	Set Arg1=objItmScreen.CCArg1
	Set Arg3=objItmScreen.CCArg3
	Set Arg4=objItmScreen.CCArg4
	Set Arg1=+Arg1
	Set Arg3=+Arg3
	Set Arg4=+Arg4
	
	//术前日期
	Set OperPrevDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperPrevDateList(aEpisodeID,Arg3)
	//术后日期
	Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeID,Arg4)
	
	//发热日期+血常规异常日期
	Set FeverDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetFeverDateList(aEpisodeID)
	Set BloodTestDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetBloodTestDateList(aEpisodeID)
	Set FevBloDateList=FeverDateList_BloodTestDateList
	
	Set SuInfDates=##Class(%ListOfDataTypes).%New()
	Set FromDate="",ToDate="",ResultCnt=0,InfSuKeys=""
	Set xActDate="",xAntiGrade=""
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		
		Continue:'$d(arrResult(xActDate,"Rst"))  //当天无结果退出
		Continue:'$d(arrResult(xActDate,"IDs"))  //当天无记录退出
		
		//术前n天排除
		Continue:(OperPrevDateList'="")&($listfind(OperPrevDateList,xActDate)>0)
		
		//术后n天排除
		Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xActDate)>0)
		
		If xAntiGrade="" {
			Set xAntiGrade=$o(arrResult(xActDate,"Rst",""),-1)  //当天最高等级
			Continue //退出
		}
		
		Set tAntiGrade=$o(arrResult(xActDate,"Rst",""),-1)
		//Continue:tAntiGrade<=xAntiGrade 
		//Set xAntiGrade=tAntiGrade
		Set mAntiGrade=tAntiGrade   //(低->中->高,高->低->中,中->低->高) 记为升级(只与上次使用抗菌用药最高等级比较)	
		If (tAntiGrade<=xAntiGrade) {
			Set xAntiGrade=tAntiGrade 
			Continue //退出
		}
		
		Set xAntiGrade=mAntiGrade
		//等级升高合并发热、血象异常检查
		If (+Arg1)>0 {
			Set Days=Arg1,IsAct=0
			For xDate=(xActDate-Days+1):1:(xActDate+Days-1) {
				Continue:$listfind(FevBloDateList,xDate)<1
				Set IsAct=1
				Quit
			}
			Continue:IsAct'=1
		}
		
		Set SISttDate=xActDate  //$o(arrResult(xActDate),-1)
		Set SIEndDate=xActDate
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
	Set obj.CSInfSuKeys    = "抗菌用药"
	Set obj.CSSuInfDates   = SuInfDates  //疑似感染日期（日期区间）
	
	Set ArrCnt=%ArrayResult.Count()
	Do %ArrayResult.SetAt(obj,ArrCnt+1)
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
