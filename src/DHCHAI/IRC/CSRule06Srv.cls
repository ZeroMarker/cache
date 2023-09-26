/// 名称: DHCHAI.IRC.CSRule06Srv
/// 描述: 疑似病例筛查规则--启用抗菌药物
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.IRC.CSRule06Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule06Srv).GetResult("启用抗菌药物",452,.arr)
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
		Quit:$o(arrResult(0))'=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="OE-AntiUse"  //医嘱-抗菌用药
		
		Set xActDate=""
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate))
			Quit:xActDate=""
			Quit:$o(arrResult(0))'=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate,xID))
				Quit:xID=""
				Quit:$o(arrResult(0))'=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				// Start 启用抗菌药物，过滤预防用药的抗菌药物筛查
				Set CCObjectID = obj.CCObjectID   // 业务指针
				Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(CCObjectID)
				Continue:'$IsObject(objOEItem)
				Continue:'$IsObject(objOEItem.OEEpisodeDr)
				Set IsActive=objOEItem.OEIsActive
				Continue:IsActive'=1
				Set AntFlag=objOEItem.OEAntUseFlag
				Continue:AntFlag'=1
				Set OEEpisodeDr=objOEItem.OEEpisodeDr.%Id()
				Set OESCode=objOEItem.OESCode
				Set OESttDate=objOEItem.OESttDate            //医嘱开始日期
				Set AntUsePurpose=objOEItem.OEAntUsePurpose  //使用目的
				Set AntOthPurpose=objOEItem.OEAntOthPurpose  //使用目的
				// 使用目的和同步程序保持一致
				Set IsAbFlag=1
				Set MapAntUsePurp=##class(DHCHAI.DP.PhraseMap).GetMapValue(OESCode,"OEAntUsePurpose",AntUsePurpose)
				If MapAntUsePurp="P" {  //预防用药
					Set IsAbFlag=0
				} ElseIf MapAntUsePurp="T" {  //治疗用药
					Set IsAbFlag=1
				} Else {
					If (AntOthPurpose["术前")||(AntOthPurpose["术中")||(AntOthPurpose["术后") {
						Set IsAbFlag=0  //预防用药
					} Else {
						If OESttDate'="" {
							Set OperDates=##class(DHCHAI.DPS.OROperationSrv).GetOperaDates(OEEpisodeDr)
							For indOP=1:1:$ll(OperDates){
								Set OperDate=$listget(OperDates,indOP)
								Continue:OperDate=""
								
								Set tDays=OperDate-OESttDate
								Continue:tDays>0
								Continue:tDays<=3
								Set IsAbFlag=0  //预防用药
							}
						}
					}
				}
				Continue:IsAbFlag=0
				// End 启用抗菌药物，过滤预防用药的抗菌药物筛查
				
				Set arrResult(ActDate,"Rst",xID)=$lb(xID,ActDate)
				
				//判断是否入院48小时后项目
				Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit:$o(arrResult(0))="" return
	
	//（*）启用抗菌药物
	//（1）入院{A1}天未用，其后使用
	//（2）排除手术前{A2}天，手术后{A3}天抗菌药物使用
	Set Arg1=objItmScreen.CCArg1
	Set Arg2=objItmScreen.CCArg2
	Set Arg3=objItmScreen.CCArg3
	Set Arg1=+Arg1
	Set Arg2=+Arg2
	Set Arg3=+Arg3
	
	//入院日期
	Set AdmDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetAdmDateList(aEpisodeID,Arg1)
	//术前日期
	Set OperPrevDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperPrevDateList(aEpisodeID,Arg2)
	//术后日期
	Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeID,Arg3)
	
	Set SuInfDates=##Class(%ListOfDataTypes).%New()
	Set FromDate="",ToDate="",ResultCnt=0,InfSuKeys=""
	Set xActDate=""
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
		
		Set ResultCnt=ResultCnt+1
		Set:FromDate="" FromDate=SISttDate
		Set ToDate=SIEndDate
		Quit
	}
	Kill arrResult
	Quit:ResultCnt<1 return
	
	//术前n天排除
	Quit:(OperPrevDateList'="")&($listfind(OperPrevDateList,FromDate)>0) return
	
	//术后n天排除
	Quit:(OperNextDateList'="")&($listfind(OperNextDateList,FromDate)>0) return
	
	//检查入院{A1}天是否使用抗生素
	If (+Arg1)>0 {
		If $listfind(AdmDateList,FromDate)>0 {
			Quit return //退出
		}
	}
	
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
