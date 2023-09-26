/// 名称: DHCHAI.IRC.CSRule08Srv
/// 描述: 疑似病例筛查规则--抗菌药物使用升级
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.IRC.CSRule08Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule08Srv).GetResult("抗菌药物使用升级",9,.arr)
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
				
				Set IsNotEnd=obj.CCIsNotEnd
				Set AntiDesc=obj.CCAntiDesc
				Continue:AntiDesc=""
				Set objMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(SCode,AntiDesc)
				Continue:'$IsObject(objMap)
				Continue:'$IsObject(objMap.BTMapItemDr)
				Set MapAntiDesc=objMap.BTMapItemDr.BTName
				Continue:MapAntiDesc=""
				
				Set XDate=$s(RepDate'="":RepDate,1:"")
				Set:(XDate="")&(IsNotEnd=1) XDate=ActDate
				Set:(XDate="")&(IsNotEnd=0) XDate=+$h
				For indDate=ActDate:1:XDate {
					Set arrResult(indDate,"Rst",MapAntiDesc)=""
				}
				Set arrResult(ActDate,"IDs",xID)=$lb(xID,ActDate)
				
				//判断是否入院48小时后项目
				Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit:$o(arrResult(0))="" return
	
	//（*）抗菌药物使用升级
	//（1）抗菌药物使用{A1}天后联用大于{A2}天前联用
	//（2）排除手术前{A3}天，手术后{A4}天抗菌药物使用
	Set Arg1=objItmScreen.CCArg1
	Set Arg2=objItmScreen.CCArg2
	Set Arg3=objItmScreen.CCArg3
	Set Arg4=objItmScreen.CCArg4
	Set Arg1=+Arg1
	Set Arg2=+Arg2
	Set Arg3=+Arg3
	Set Arg4=+Arg4
	
	//术前日期
	Set OperPrevDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperPrevDateList(aEpisodeID,Arg3)
	//术后日期
	Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeID,Arg4)
	
	Set SuInfDates=##Class(%ListOfDataTypes).%New()
	Set FromDate="",ToDate="",ResultCnt=0,InfSuKeys=""
	Set xActDate="",xAntiCnt=""
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		
		Continue:'$d(arrResult(xActDate,"Rst"))  //当天无结果退出
		Continue:'$d(arrResult(xActDate,"IDs"))  //当天无记录退出
		
		Set SISttDate="",SIEndDate=""
		Set List1="" //n天后联用，算当天
		For xDate=xActDate:1:(xActDate+Arg1-1){
			//术前n天排除
			Continue:(OperPrevDateList'="")&($listfind(OperPrevDateList,xDate)>0)
			
			//术后n天排除
			Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xDate)>0)
			
			Set xAnti=""
			For {
				Set xAnti=$o(arrResult(xDate,"Rst",xAnti))
				Quit:xAnti=""
				
				Continue:$listfind(List1,xAnti)>0
				Set List1=List1_$lb(xAnti)
				Set SISttDate=$s(SISttDate="":xDate,SISttDate>xDate:xDate,1:SISttDate)
				Set SIEndDate=$s(SIEndDate="":xDate,SIEndDate<xDate:xDate,1:SIEndDate)
			}
		}
		Set List2="" //n天前联用，不算当天
		For xDate=(xActDate-Arg2):1:(xActDate-1) {
			//术前n天排除
			Continue:(OperPrevDateList'="")&($listfind(OperPrevDateList,xDate)>0)
			
			//术后n天排除
			Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xDate)>0)
			
			Set xAnti=""
			For {
				Set xAnti=$o(arrResult(xDate,"Rst",xAnti))
				Quit:xAnti=""
				Continue:$listfind(List2,xAnti)>0
				Set List2=List2_$lb(xAnti)
				Set SISttDate=$s(SISttDate="":xDate,SISttDate>xDate:xDate,1:SISttDate)
				Set SIEndDate=$s(SIEndDate="":xDate,SIEndDate<xDate:xDate,1:SIEndDate)
			}
		}
		Continue:$listlength(List1)<1
		Continue:$listlength(List2)<1
		Continue:$listlength(List1)<=$listlength(List2)
		
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
