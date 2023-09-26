/// 名称: DHCHAI.STATV2.LabResultDetails
/// 描述: 患者送检结果明细
/// 编写者：zhugz
/// 编写日期: 2019-11-21
Class DHCHAI.STATV2.LabResultDetails Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-11-21
/// Description:  查询患者病原学送检列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.LabVisitNumber
/// Input:        aEpisodeID：就诊ID
/// 			  aDateFrom：开始日期(转科信息分组下 为转科开始日期)
/// 			  aDateTo：  结束日期(转科信息分组下 为转科结束日期)
/// 			  aSpecimen：标本
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.LabResultDetails","QryLabResultInfo","1887","2020-07-01","2020-07-31","血","细菌检测")
Query QryLabResultInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aSpecimen As %String = "", aTestSetCat As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,VisitNumberID:%String,EpisodeNo:%String,OrdTSDesc:%String,Specimen:%String,CollDate:%String,VisitReportID:%String,AuthDate:%String,ResultList:%String") [ SqlProc ]
{
}

ClassMethod QryLabResultInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aSpecimen As %String = "", aTestSetCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:aEpisodeID="" $$$OK
	Set:aDateTo="" aDateTo=+$h
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo) 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//患者基本信息
	Set PatData =..BuildPaadmData(aEpisodeID)
    Quit:PatData="" $$$OK
 	Set LabInfoArr=..GetLabInfo(aEpisodeID,aDateFrom,aDateTo,aSpecimen,aTestSetCat)
	for LabInd=1:1:LabInfoArr.Count(){
		Set LabInfo=LabInfoArr.GetAt(LabInd)
		Set xVisitNumberDr	= $li(LabInfo,1)
		Set CollDate		= $li(LabInfo,2)
		Set Specimen		= $li(LabInfo,3)
		Set SCode			= $li(LabInfo,4)
		Set EpisodeNo		= $li(LabInfo,5)
        Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				Set VisitReportData=$g(^DHCHAI.DP.LabVisitReportD(xVisitReportDr))
				Continue:VisitReportData=""
				
				Set Status = $li(VisitReportData,6)
				Continue:Status=6	//作废
				Set IsActive = $li(VisitReportData,18)
				Continue:IsActive=0
				
				Set VisitReportID 	= xVisitReportDr
				Set LabReportID 	= $li(VisitReportData,3)
				Set LabRepOrder 	= $li(VisitReportData,4)
				Set AuthDate		= $li(VisitReportData,10)
				Set AuthTime		= $li(VisitReportData,11)
				Set:AuthDate'="" AuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
				
				Set VisitTestSetDr	= $li(VisitReportData,13)
				Continue:VisitTestSetDr=""
				Set VisitTestSetData=$g(^DHCHAI.DP.LabVisitTestSetD(VisitTestSetDr))
				Set TestSetDesc	= $li(VisitTestSetData,3)
				Set OrdTsDesc	= $li(VisitTestSetData,5)
				Set CollDateR=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
				Set AuthDateR=AuthDate
				Set xResultID="",ResultList=""
				For {
					Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
					Quit:xResultID=""
					Set ResultData=$g(^DHCHAI.DP.LabVisitRepResultD(xResultID))
					Continue:ResultData=""
					Set RstFormat	= $li(ResultData,5)
					Continue:RstFormat=""
					Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
					Continue:MapRstFormat=""
					Continue:MapRstFormat'="M"
					Set Bacteria	= $li(ResultData,6)
					Continue:Bacteria=""
					Continue:(Bacteria["阴性")||(Bacteria["-")
					Continue:(Bacteria["大于3种菌")
					Continue:(Bacteria["无")&&(Bacteria["生长")
					Continue:(Bacteria["未见")&&(Bacteria["菌")
					Continue:(Bacteria["未检出")&&(Bacteria["菌")
					Continue:$listfind(ResultList,Bacteria)>0  //判断是否同种菌
					Set ResultList=ResultList_$lb(Bacteria)		
				}
				
				Set Data=PatData_$lb(xVisitNumberDr,EpisodeNo,OrdTsDesc,Specimen,CollDateR,VisitReportID,AuthDateR)_ResultList
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1

			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabResultInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabResultInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabResultInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabResultInfoExecute ]
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

}
