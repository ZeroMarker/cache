/// 名称: DHCHAI.IRC.CSRule04Srv
/// 描述: 疑似病例筛查规则--血常规2次异常
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.IRC.CSRule04Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule04Srv).GetResult("血常规2次异常",9,.arr)
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
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-TestAb"  //检验-常规检验异常
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:KeyWords'[tKeyword  //血常规、尿常规...
			
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
				Set Specimen=obj.CCSpecimen
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Set MapSpecDesc=""
				Set objMapSpec=##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc(SCode,Specimen)
				If $IsObject(objMapSpec){
					Set MapSpecDesc=objMapSpec.BTSpecDesc
				}
				Set:MapSpecDesc'="" arrResult(ActDate,"INF",MapSpecDesc)=""
				
				Set arrResult(ActDate,"Rst",xID)=$lb(xID,ActDate)
				
				//判断是否入院48小时后项目
				Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit:$o(arrResult(0))="" return
	
	//（*）血常规{A1}天送检{A2}次异常
	//（1）均排除入院{A3}天内，手术后{A4}天内
	//（2）白细胞异常前后{A5}天内有发热或使用抗菌药物则预警
	Set Arg1=objItmScreen.CCArg1
	Set Arg2=objItmScreen.CCArg2
	Set Arg3=objItmScreen.CCArg3
	Set Arg4=objItmScreen.CCArg4
	Set Arg5=objItmScreen.CCArg5
	Set Arg1=+Arg1
	Set Arg2=+Arg2
	Set Arg3=+Arg3
	Set Arg4=+Arg4
	Set Arg5=+Arg5
	
	//入院日期
	Set AdmDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetAdmDateList(aEpisodeID,Arg3)
	//术后日期
	Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeID,Arg4)
	
	//发热+抗菌药物使用日期
	Set FeverDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetFeverDateList(aEpisodeID)
	Set AntiDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetAntiDateList(aEpisodeID)
	Set FevAntDateList=FeverDateList_AntiDateList
	
	Set SuInfDates=##Class(%ListOfDataTypes).%New()
	Set FromDate="",ToDate="",ResultCnt=0,InfSuKeys=""
	Set xActDate=""
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		
		Continue:'$d(arrResult(xActDate,"Rst"))  //当天无记录退出
		
		//X天内送检次数大于Y次
		Set Count=0
		Set SISttDate="",SIEndDate=""
		For xDate=(xActDate-Arg1+1):1:xActDate {
			Set xID=""
			For {
				Set xID=$o(arrResult(xDate,"Rst",xID))
				Quit:xID=""
				Set Count=Count+1
				Set SISttDate=$s(SISttDate="":xDate,SISttDate>xDate:xDate,1:SISttDate)
				Set SIEndDate=$s(SIEndDate="":xDate,SIEndDate<xDate:xDate,1:SIEndDate)
			}
		}
		Continue:Count<1
		Continue:Count<Arg2
		
		//入院后n天排除
		If Arg3>0 {
			Continue:$listfind(AdmDateList,xActDate)>0
		}
		
		//术后n天排除
		Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xActDate)>0)
		
		//发热或使用抗菌药物n天内
		If (+Arg5)>0 {
			Set Days=Arg5,IsAct=0
			For xDate=(xActDate-Days+1):1:(xActDate+Days-1) {
				Continue:$listfind(FevAntDateList,xDate)<1
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
		
		//疑似诊断关键词
		Set xSpec=""
		For {
			Set xSpec=$o(arrResult(xActDate,"INF",xSpec))
			Quit:xSpec=""
			Set InfSuKeys=InfSuKeys_"^"_xSpec
		}
	}
	
	Kill arrResult
	Quit:ResultCnt<1 return
	Set:InfSuKeys'="" InfSuKeys=$e(InfSuKeys,2,$l(InfSuKeys))
	
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
