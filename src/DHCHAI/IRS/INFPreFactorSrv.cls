/// 名称: DHCHAI.IRS.INFPreFactorSrv
/// 描述: 医院感染 易感因素服务
/// 编写者：liyi
/// 编写日期: 2017-09-21
Class DHCHAI.IRS.INFPreFactorSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-09-21
/// Description:  查询报告易感因素
/// Table：       DHCHAI.IR.INFPreFactor
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFPreFactorSrv","QryPreFactorByRep","232","")
Query QryPreFactorByRep(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "ReportID:%String,ID:%String,EpisodeID:%String,PreFactorID:%String,PreFactor:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String") [ SqlProc ]
{
}

ClassMethod QryPreFactorByRepExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aReportID'="" {
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
		Quit:'$IsObject(objRep) $$$OK
		Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
		
		Set LinkPreFactors=objRep.GetRepLinkIDs("DHCHAI.IR.INFPreFactor")
		Quit:LinkPreFactors="" $$$OK
		for indx = 1:1:$length(LinkPreFactors,","){
			Set ID=$p(LinkPreFactors,",",indx)
			Continue:ID=""
			Set Data=..BuildINFPreFactorData(ID)
			Continue:Data=""
			Set Data=$lb(aReportID)_Data
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}else{
		Set ReportID=""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFPreFactorI("IndexEpisodeDr",aEpisodeID,xID))
			Quit:xID=""
			Set Data=..BuildINFPreFactorData(xID)
			Continue:Data=""
			Set Data=$lb(ReportID)_Data
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPreFactorByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPreFactorByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPreFactorByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPreFactorByRepExecute ]
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

/// 取单个易感因素信息
ClassMethod BuildINFPreFactorData(aINFPreFactorID As %String) As %String
{
	New (aINFPreFactorID)
	Set return=""
	Quit:aINFPreFactorID="" return
	
	Set objPreFactor = ##class(DHCHAI.IR.INFPreFactor).GetObjById(aINFPreFactorID)
	Quit:'$IsObject(objPreFactor) return
	Quit:'$IsObject(objPreFactor.IREpisodeDr) return
	
	Set EpisodeID=objPreFactor.IREpisodeDr.%Id()
	Set objPreDic = objPreFactor.IRPreFactorDr
	Quit:'$IsObject(objPreDic) return
	
	Set (PreFactorID,PreFactor)=""
	If $IsObject(objPreDic){
		Set PreFactorID = objPreDic.%Id()
		Set PreFactor = objPreDic.BTDesc
	}
	Set UpdateDate = objPreFactor.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = objPreFactor.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser = objPreFactor.IRUpdateUserDr
	Set (UpdateUserID,UpdateUser)=""
	If $IsObject(objUpdateUser){
		Set UpdateUserID = objUpdateUser.%Id()
		Set UpdateUser = objUpdateUser.BTDesc
	}
	Set return = $lb(aINFPreFactorID,EpisodeID,PreFactorID,PreFactor,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-05-09
/// Description:  查询患者是否存在有效的易感因素
/// Table：       DHCHAI.IR.INFPreFactor
/// Input:        报告ID,就诊ID，aIsNewborn 是否新生儿(成人1,新生儿2,空表示全部)
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFPreFactorSrv","QryPreFactorOfConfig","232","","1","1")
Query QryPreFactorOfConfig(aReportID As %String, aEpisodeID As %String, aIsNewborn As %String, aActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,IsInfPreFactor:%String,BTIsNewborn:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryPreFactorOfConfigExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String, aIsNewborn As %String, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aEpisodeID=""{
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
		Quit:'$IsObject(objRep) $$$OK
		Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
		Set aEpisodeID=objRep.IREpisodeDr.%Id()
	}
	
	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.PreFactorD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.BT.PreFactor).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code=obj.BTCode
		Set Desc=obj.BTDesc
		Set IndNo=obj.BTIndNo
		Set IsActive=obj.BTIsActive
		Continue:(aActive'="")&&(aActive'=IsActive)
		Set BTIsActive=$s(IsActive=1:"是",1:"否")
		Set IsNewborn=obj.BTIsNewborn
	    Continue:(aIsNewborn'="")&&(aIsNewborn'=IsNewborn)
		Set BTIsNewborn=$s(IsNewborn=2:"是",1:"否")
		
		Set IsInfPreFactor="否"
		Set xPreFactorID=""
		For {
			Set xPreFactorID=$o(^DHCHAI.IR.INFPreFactorI("IndexEpisodeDr",aEpisodeID,xPreFactorID))
			Quit:xPreFactorID=""
			
			Set objPreFactor=##class(DHCHAI.IR.INFPreFactor).GetObjById(xPreFactorID)
			Continue:'$IsObject(objPreFactor)
			Set IRPreFactorDr=objPreFactor.IRPreFactorDr
			Continue:'$IsObject(IRPreFactorDr)
			If (xID=IRPreFactorDr.%Id()){
				Set IsInfPreFactor="是"
				Quit
			}
		}
		
		set Data=$lb(xID,Code,Desc,IndNo,IsInfPreFactor,BTIsNewborn,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPreFactorOfConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPreFactorOfConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPreFactorOfConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPreFactorOfConfigExecute ]
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
