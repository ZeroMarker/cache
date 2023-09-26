/// 临床路径基本信息监控模块
Class web.DHCCPW.MR.CtrModulePatSummary Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 获取单个病人入径的基本信息
/// PathWayID:User.DHCMRClinicalPathWay的ID
/// 患者临床路径的入径记录
/// 返回值：入径日期^入径时间^入径天数^^^^^^
/// w ##class(web.DHCCPW.MR.CtrModulePatSummary).GetPathWaySummary(2)
ClassMethod GetPathWaySummary(PathWayID As %String) As %String
{
	New (PathWayID)
	Set return=""
	Quit:PathWayID="" return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	If $IsObject(objPathWay) {
		Set MRAdm=objPathWay.CPWMRADMDR
		Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
		Set (AdmitDate,AdmitTime,DischDate,DischTime)=""
		Set objPaadm=##Class(User.PAAdm).%OpenId(EpisodeID)
	    If $IsObject(objPaadm)
	    {
		    //Set AdmitDate=objPaadm.PAADMAdmDate
		    //Set AdmitTime=objPaadm.PAADMAdmTime
		    //upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
			Set AdmitDate=$p(AdmDateTime,"^",1)
			Set AdmitTime=$p(AdmDateTime,"^",2)
		    //Set DischDate=objPaadm.PAADMDischgDate
		    //Set DischTime=objPaadm.PAADMDischgTime
		    //Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)
	    }
		Set CPWStatus=objPathWay.CPWStatus
		Set InDate=objPathWay.CPWInDate
		Set InTime=objPathWay.CPWInTime
		Set OutDate=objPathWay.CPWOutDate
		Set OutTime=objPathWay.CPWOutTime
		
		Set objBaseConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("CPWInPathStartDateType")
		Quit:'$IsObject(objBaseConfig) return
		Set StartDateConfig=objBaseConfig.BCValue
		
		Set return="^^^^^^^^^"
		If StartDateConfig=1 {
			Set $p(return,"^",1)=$zd(AdmitDate,3)
			Set $p(return,"^",2)=$zt(AdmitTime,1)
		} Else {
			Set $p(return,"^",1)=$zd(InDate,3)
			Set $p(return,"^",2)=$zt(InTime,1)
		}
		Set InDays=0
		If CPWStatus="I" {
			Set InDays=+$h-InDate          //入径状态，入径天数=当前日期-入径日期
		}
		If CPWStatus="O" {
			Set InDays=OutDate-InDate    //完成状态，入径天数=出院日期-入径日期 Modified By LiYang 2011-05-21 关闭路径的也按出径日期计算入径天数
		}
		If CPWStatus="C" {
			Set InDays=OutDate-InDate      //出径状态，入径天数=出径日期-入径日期
		}
		Set $p(return,"^",3)=InDays+1
	}
	Quit return
}

/// 查询入径天数列表
/// d ##class(%Library.ResultSet).RunQuery("web.DHCCPW.MR.CtrModulePatSummary","QueryCPDays",2)
Query QueryCPDays(argPathWayID As %String) As %Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod QueryCPDaysExecute(ByRef qHandle As %Binary, argPathWayID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set Summary=..GetPathWaySummary(argPathWayID)
	Quit:Summary="" $$$OK
	Set FromDate=$p(Summary,"^",1)
	Set:FromDate'="" FromDate=$zdh(FromDate,3)
	Set Days=$p(Summary,"^",3)
	For Cnt=1:1:Days {
		Set tmpDate=FromDate+Cnt-1                     //入径第几天作为ID
		Set tmpInfo=$zd(tmpDate,3)_" (第"_Cnt_"天)"    //描述信息
		Set Data=$lb(tmpDate,tmpInfo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryCPDaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCPDaysExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryCPDaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCPDaysExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
