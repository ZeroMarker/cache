/// 名称: DHCHAI.IRS.INFInvOperSrv
/// 描述: 医院感染 侵害性操作服务
/// 编写者：liyi
/// 编写日期: 2017-09-21
Class DHCHAI.IRS.INFInvOperSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-09-21
/// Description:  查询报告侵害性操作
/// Table：       DHCHAI.IR.INFInvOper
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFInvOperSrv","QryInvOperByRep","",150)
Query QryInvOperByRep(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "ReportID:%String,ID:%String,EpisodeID:%String,InvOperID:%String,InvOper:%String,SttDate:%String,EndDate:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String")
{
}

ClassMethod QryInvOperByRepExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aReportID'="" {
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
		Quit:'$IsObject(objRep) $$$OK
		Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
		
		Set LinkInvOpers=objRep.GetRepLinkIDs("DHCHAI.IR.INFInvOper")
		Quit:LinkInvOpers="" $$$OK
		for indx = 1:1:$length(LinkInvOpers,","){
			Set ID=$p(LinkInvOpers,",",indx)
			Continue:ID=""
			Set Data=..BuildInvOperData(ID)
			Continue:Data=""
			Set Data=$lb(aReportID)_Data
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}else{
		Set ReportID=""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFInvOperI("IndexEpisodeDr",aEpisodeID,xID))
			Quit:xID=""
			Set Data=..BuildInvOperData(xID)
			Continue:Data=""
			Set Data=$lb(ReportID)_Data
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryInvOperByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInvOperByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInvOperByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInvOperByRepExecute ]
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

/// 取单个侵害性操作信息
ClassMethod BuildInvOperData(aINFInvOperID As %String) As %String
{
	New (aINFInvOperID)
	Set return=""
	Quit:aINFInvOperID="" return
	
	Set objInvOper = ##class(DHCHAI.IR.INFInvOper).GetObjById(aINFInvOperID)
	Quit:'$IsObject(objInvOper) return
	Quit:'$IsObject(objInvOper.IREpisodeDr) return
	
	Set EpisodeID=objInvOper.IREpisodeDr.%Id()
	Set objInvOperDic = objInvOper.IRInvOperDr
	Quit:'$IsObject(objInvOperDic) return
	
	Set (InvOperID,InvOper)=""
	If $IsObject(objInvOperDic){
		Set InvOperID = objInvOperDic.%Id()
		Set InvOper = objInvOperDic.BTDesc
	}
	Set SttDate = objInvOper.IRSttDate
	Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
	Set EndDate = objInvOper.IREndDate
	Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set UpdateDate = objInvOper.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = objInvOper.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser = objInvOper.IRUpdateUserDr
	Set (UpdateUserID,UpdateUser)=""
	If $IsObject(objUpdateUser){
		Set UpdateUserID = objUpdateUser.%Id()
		Set UpdateUser = objUpdateUser.BTDesc
	}
	Set return = $lb(aINFInvOperID,EpisodeID,InvOperID,InvOper,SttDate,EndDate,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-05-09
/// Description:  查询患者是否存在配置的侵害性操作
/// Table：       DHCHAI.BT.InvasOper
/// Input：       aReportID报告ID,aEpisodeID就诊号,aActive是否有效
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFInvOperSrv","QryInvOperOfConfig","232","","1")
Query QryInvOperOfConfig(aReportID As %String, aEpisodeID As %String, aActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,IsInfInvOper:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryInvOperOfConfigExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String, aActive As %String = "") As %Status
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
	 	Set xID=$o(^DHCHAI.BT.InvasOperD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.BT.InvasOper).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code=obj.BTCode
		Set Desc=obj.BTDesc
		Set IndNo=obj.BTIndNo
		Set IsActive=obj.BTIsActive
		Continue:(aActive'="")&&(aActive'=IsActive)
		Set BTIsActive=$s(IsActive=1:"是",1:"否")
		
		Set IsInfInvOper="否"
		Set xInfInvID=""
		For {
			Set xInfInvID=$o(^DHCHAI.IR.INFInvOperI("IndexEpisodeDr",aEpisodeID,xInfInvID))
			Quit:xInfInvID=""
			
			Set objInfInv=##class(DHCHAI.IR.INFInvOper).GetObjById(xInfInvID)
			Continue:'$IsObject(objInfInv)
			Set IRInvOperDr=objInfInv.IRInvOperDr
			Continue:'$IsObject(IRInvOperDr)
			If (xID=IRInvOperDr.%Id()){
				Set IsInfInvOper="是"
				Quit
			}
		}
				
		set Data=$lb(xID,Code,Desc,IndNo,IsInfInvOper,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInvOperOfConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInvOperOfConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInvOperOfConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInvOperOfConfigExecute ]
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
