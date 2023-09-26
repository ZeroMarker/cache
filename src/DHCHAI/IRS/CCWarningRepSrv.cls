/// 名称: DHCHAI.IRS.CCWarningRepSrv
/// 描述: 暴发预警保卡
/// 编写者：zhangqy
/// 编写日期: 2020-11-30
Class DHCHAI.IRS.CCWarningRepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangqy
/// CreatDate：   2020-11-30
/// Description:  通过科室ID找报卡ID
/// Table：       CWPLocID
/// Input
///  w ##class(DHCHAI.IRS.CCWarningRepSrv).FindRepByLoc("111","2021-04-07")
ClassMethod FindRepByLoc(aLocID As %String, aDate As %String) As %String
{
	New (aLocID,aDate)
	Set return=""
	Quit:((aLocID="")||(aDate="")) return
	Set:aDate'="" aDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set StatDate=aDate-7
	Set RepID=""
	For StatDate=StatDate:1:aDate{
		Quit:StatDate>aDate
		Set xActID=""
		For{
			Set xActID=$o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDate",aLocID,StatDate,xActID))
			Quit:xActID=""
			Set objAct = ##class(DHCHAI.IR.CCWarningAct).GetObjById(xActID)
			Continue:'$isobject(objAct)
			Set ActStatus=objAct.IRActStatus
			Continue:ActStatus="2"
			Set objWarnRepDr=objAct.IRWarnRepDr
			Continue:'$isobject(objWarnRepDr)
			Set rID=objWarnRepDr.%Id()
			If (RepID'=""){
				Set RepID =RepID_"^"_rID
			}Else{
				Set RepID =rID
			}
		}
	}
	Set return =RepID
	Quit return
}

/// Creator：     zhangqy
/// CreatDate：   2020-11-30
/// Description:  判断是否暴发
/// Table：      
/// Input
///  w ##class(DHCHAI.IRS.CCWarningRepSrv).JudgeRep("111","2021-04-07","气管炎、支气管炎")
ClassMethod JudgeRep(aLocID As %String, aDate As %String, aselItems As %String) As %String
{
	New (aLocID,aDate,aselItems)
	Set return=-1
	Quit:((aLocID="")||(aDate="")||(aselItems="")) return
	Set:aDate'="" aDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set xID=""
	For{
		Set xID=$o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",aLocID,aDate,aselItems,xID))
		Quit:xID=""
		Set objAct = ##class(DHCHAI.IR.CCWarningAct).GetObjById(xID)
		Continue:'$isobject(objAct)
		Set ActStatus=objAct.IRActStatus
		Set:ActStatus="1" return=1
		Set:ActStatus="2" return=2
	}
	Quit return
}

/// Creator：     zhangqy
/// CreatDate：   2020-11-30
/// Description:  通过科室ID找报卡ID
/// Table：       CWPLocID
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCWarningRepSrv","QryFindRepByLoc","54","","2020-12-08","2020-12-16")
Query QryFindRepByLoc(aHospIDs As %String = "", aLocID As %String, aStatus As %String, aDateFrom As %String, aDateTo As %String, IsActive As %String) As %Query(ROWSPEC = "xID:%String,LocID:%String,LocDesc:%String,WarnItem:%String,WarnDate:%String,ActStatus:%String,RepID:%String,ActUser:%String,ActDate:%String,CCWarnItem:%String,Opinion:%String") [ SqlProc ]
{
}

ClassMethod QryFindRepByLocExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aLocID As %String, aStatus As %String, aDateFrom As %String, aDateTo As %String, IsActive As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	
	Set:aDateFrom'="" aDateFrom = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	For aDateFrom=aDateFrom:1:aDateTo{
		Quit:aDateFrom>aDateTo
		Set xLocID=""
		For{
			Set xLocID = $o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(xLocID'=aLocID)
			Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
			Set HospDr=$lg(LocData,8)
			Continue:(aHospIDs'="")&($lf(aHospIDs,HospDr)<1) //院区过滤
					
			Set xIRWarnItem = ""
			For{
				Set xIRWarnItem = $o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xLocID,aDateFrom,xIRWarnItem))
				Quit:xIRWarnItem=""
				Set xID="",RepID=""
				For{
					Set xID = $o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",xLocID,aDateFrom,xIRWarnItem,xID))
					Quit:xID=""
					Set objAct = ##class(DHCHAI.IR.CCWarningAct).GetObjById(xID)
					Continue:'$isobject(objAct)
					Set LocID=objAct.IRWarnLocDr.%Id()
					Set LocDesc=objAct.IRWarnLocDr.BTDesc
					Set WarnItem=objAct.IRWarnItem
					Set CCWarnItem=objAct.CCWarnItems
					Continue:(IsActive=1)&&(WarnItem'["主动报告")
					if (WarnItem["菌"){
						Set WarnItem="同种菌:"_WarnItem
					}elseIf (WarnItem["发热"){
						Set WarnItem=WarnItem
					}elseIf (WarnItem["主动报告"){
						Set WarnItem=WarnItem
					}else{
						Set WarnItem="相同感染诊断:"_WarnItem
					}
						
					Set WarnDate=objAct.IRWarnDate
					Set ActStatus=objAct.IRActStatus
					Set ActUser=objAct.CCActUserDr.BTDesc
					Set ActDate=objAct.CCActDate
					Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
					Set:WarnDate'="" WarnDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(WarnDate)
					If (ActStatus=2){
						Set RepID=""
					}Else{
						Set objWarnRepDr=objAct.IRWarnRepDr
						Continue:'$isobject(objWarnRepDr)
						Set rID=objWarnRepDr.%Id()
						If (RepID'=""){
							Set RepID =RepID_"^"_rID
						}Else{
							Set RepID =rID
						}	
					}
					Continue:((aStatus'="")&&(aStatus'=ActStatus))
					Set ActStatus  = $s(ActStatus=1:"暴发",ActStatus=2:"非暴发",1:"")
					Set Opinion=objAct.CCOpinion
					
					Set Data = $lb(xID,LocID,LocDesc,WarnItem,WarnDate,ActStatus,RepID,ActUser,ActDate,CCWarnItem,Opinion)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryFindRepByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFindRepByLocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryFindRepByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFindRepByLocExecute ]
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
