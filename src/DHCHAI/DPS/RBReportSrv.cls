/// 名称: DHCHAI.DPS.RBReportSrv
/// 描述: 影像相关服务
/// 编写者：liyi
/// 编写日期: 2017-08-16
Class DHCHAI.DPS.RBReportSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-08-16
/// Description:  查询病人影像报告
/// Table：       DHCHAI.DP.RBReport
/// Input：       就诊ID、文档类型、文档日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.RBReportSrv","QryRBReport","241","","")
Query QryRBReport(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "ReportID:%String,CheckItem:%String,ExamDesc:%String,ResultDesc:%String,RegDate:%String,RegTime:%String,RepDate:%String,RepTime:%String,RepUser:%String") [ SqlProc ]
{
}

ClassMethod QryRBReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set xRepDate = ""
	For {
		Set xRepDate = $o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",aEpisodeID,xRepDate))
		Quit:xRepDate=""
		
		Continue:(aDateFrom'="")&&(aDateTo'="")&&((aDateTo<xRepDate)||(aDateFrom>xRepDate))
			
		Set xReportID = ""
		For {
			Set xReportID = $o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",aEpisodeID,xRepDate,xReportID))
			Quit:xReportID=""
			
			Set objReport = ##class(DHCHAI.DP.RBReport).GetObjById(xReportID)
			Continue:'$isobject(objReport)
			
			Set CheckItem = objReport.RBCheckItem
			Set ExamDesc = objReport.RBExamDesc
			Set ResultDesc = objReport.RBResultDesc
			Set RegDate = objReport.RBRegDate
			Set RegTime = objReport.RBRegTime
			Set RepDate = objReport.RBRepDate
			Set RepTime = objReport.RBRepTime
			Set RepUser = objReport.RBRepUser
			Set Status  = objReport.RBChkStatus
			//Continue:(Status="作废")||(Status="删除")
			Set IsActive= objReport.RBIsActive
			Continue:IsActive=0
			Set RepUserCode = $p(RepUser,"|",1)
			Set RepUserDesc = $p(RepUser,"|",2)
		
			Set:RegDate'="" RegDate=$zd(RegDate,3)
			Set:RepDate'="" RepDate=$zd(RepDate,3)
			Set:RegTime'="" RegTime=$zt(RegTime)
			Set:RepTime'="" RepTime=$zt(RepTime)
			
			Set Data = $lb(xReportID,CheckItem,ExamDesc,ResultDesc,RegDate,RegTime,RepDate,RepTime,RepUserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryRBReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRBReportExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRBReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRBReportExecute ]
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
