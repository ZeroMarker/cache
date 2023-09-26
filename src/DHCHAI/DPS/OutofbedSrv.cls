/// 名称: DHCHAI.DPS.OutofbedSrv
/// 描述: 离床超过一日患者相关服务
/// 编写者：pylian
/// 编写日期: 2020-03-11
Class DHCHAI.DPS.OutofbedSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  查询离床超过一日患者列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.Outofbed
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.OutofbedSrv","QryOutofbed","2020-01-01","2020-06-19","1|6|7","")
Query QryOutofbed(aDateFrom As %String = "", aDateTo As %String = "", aHospIDs As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,VisitStatus:%String,VisitStatusDesc:%String,OutbedDate:%String,OutbedTime:%String,OprStatus:%String,OprStatusDesc:%String,DischDate:%String,DischTime:%String,IsActive:%String,IsActiveDesc:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOutofbedExecute(ByRef qHandle As %Binary, aDateFrom As %String = "", aDateTo As %String = "", aHospIDs As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set:aDateFrom'="" aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

    Set xVisitStatus =""
    For {
	    Set xVisitStatus = $o(^DHCHAI.DP.OutofbedI("IndexEpsStatus",xVisitStatus))
	    Quit:xVisitStatus=""

	    Set xEpisodeID =""
	    For {
		    Set xEpisodeID = $o(^DHCHAI.DP.OutofbedI("IndexEpsStatus",xVisitStatus,xEpisodeID))
		    Quit:xEpisodeID=""
		    
		    Set xID =""
		    For {
			    Set xID = $o(^DHCHAI.DP.OutofbedI("IndexEpsStatus",xVisitStatus,xEpisodeID,xID))
			    Quit:xID=""
		        
		        Set objOut=##class(DHCHAI.DP.Outofbed).GetObjById(xID)
				Continue:'$IsObject(objOut)
				
			    Set VisitStatus = objOut.VisitStatus
			    Set VisitStatusDesc = $s(VisitStatus="A":"在院",VisitStatus="D":"出院",1:"")
				Set OutbedDate  = objOut.OutbedDate 
				Continue:(aDateFrom'="")&&(OutbedDate<aDateFrom)
				Continue:(aDateTo'="")&&(OutbedDate>aDateTo)
				Set:OutbedDate'="" OutbedDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutbedDate)
				Set OutbedTime  = objOut.OutbedTime 
				Set:OutbedTime'="" OutbedTime=$zt(OutbedTime,1)
				Set OprStatus   = objOut.OprStatus 
			    Set OprStatusDesc = $s(OprStatus="1":"标记",OprStatus="2":"取消标记",1:"")
				Set DischDate   = objOut.DischDate
				Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
				Set DischTime =  objOut.DischTime  
				Set:DischTime'="" DischTime=$zt(DischTime,1)
				Set IsActive    = objOut.IsActive  
				Set IsActiveDesc = $s(IsActive="1":"是",IsActive="0":"否",1:"") 
			
				Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
				Continue:'$IsObject(objPaadm)
				Set PapmiNo = objPaadm.PAPapmiNo
				Set MrNo = objPaadm.PAMrNo
				Set PatName = objPaadm.PAPatName
				Set Sex = objPaadm.PASex
				Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
				Set Nation = objPaadm.PANation
				Set Birthday = objPaadm.PABirthday
				Set AdmDate = objPaadm.PAAdmDate
				Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
				Set AdmTime = objPaadm.PAAdmTime
				Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
				Set objAdmLoc = objPaadm.PAAdmLocDr
				If $IsObject(objAdmLoc.BTHospDr){
					Set HospID=objAdmLoc.BTHospDr.%Id()			
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
				}
				Set AdmLocDesc="",AdmLocID =""
				If $isobject(objAdmLoc) {
					Set LocDesc2 = objAdmLoc.BTDesc2
					Set LocDesc = objAdmLoc.BTDesc
					Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
					Set AdmLocID = objAdmLoc.%Id()
				}
				Continue:(aLocID'="")&&(aLocID'=AdmLocID)
				Set objAdmWard = objPaadm.PAAdmWardDr
				Set AdmWardID="",AdmWardDesc=""
				If $isobject(objAdmWard) {
					Set AdmWardID = objAdmWard.%Id()
					Set WardDesc2 = objAdmWard.BTDesc2
					Set WardDesc = objAdmWard.BTDesc
					Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
				}
	
				Set Data= $lb(xID,xEpisodeID,VisitStatus,VisitStatusDesc,OutbedDate,OutbedTime,OprStatus,OprStatusDesc,DischDate,DischTime,IsActive,IsActiveDesc,PapmiNo,MrNo,PatName,Sex,Nation,Birthday,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		    }
	    }
    }

	Kill ^TMP($zn,$j,"QryOutofbed")

	Quit $$$OK
}

ClassMethod QryOutofbedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutofbedExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOutofbedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutofbedExecute ]
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

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  查询离床超过一日患者操作日志
/// Table：       DHCHAI.DP.OutofbedLog
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.OutofbedSrv","QryOutofbedLog",1)
Query QryOutofbedLog(aOutBedID As %String) As %Query(ROWSPEC = "ID:%String,OprStatus:%String,DischDate:%String,DischTime:%String,UpdateDate:%String,UpdateTime:%String,UserID:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOutofbedLogExecute(ByRef qHandle As %Binary, aOutBedID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aOutBedID="") $$$OK
	
	Set xSubID =""
    For {
	    Set xSubID = $o(^DHCHAI.DP.OutofbedD(aOutBedID,"Log",xSubID))
	    Quit:xSubID=""
        
        Set xID =aOutBedID_"||"_xSubID
        Set objLog=##class(DHCHAI.DP.OutofbedLog).GetObjById(xID)
		Continue:'$IsObject(objLog)
				
		Set OprStatus   = objLog.OprStatus 
	    Set OprStatus = $s(OprStatus="1":"标记",OprStatus="2":"取消标记",1:"")
		Set DischDate   = objLog.DischDate
		Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
		Set DischTime =  objLog.DischTime  
		Set:DischTime'="" DischTime=$zt(DischTime,1)
		Set UpdateDate   = objLog.UpdateDate
		Set:UpdateDate'="" UpdateDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
		Set UpdateTime =  objLog.UpdateTime  
		Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	    Set (UserID,UserDesc)=""
		If $IsObject(objLog.UpdateUserDr ){
			Set UserID   = objLog.UpdateUserDr.%Id()
			Set UserDesc = objLog.UpdateUserDr.BTDesc
		}

		Set Data= $lb(xID,OprStatus,DischDate,DischTime,UpdateDate,UpdateTime,UserID,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    
    }

	Kill ^TMP($zn,$j,"QryOutofbedLog")

	Quit $$$OK
}

ClassMethod QryOutofbedLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutofbedLogExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOutofbedLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutofbedLogExecute ]
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

/// Creator：     pylian
/// CreatDate：   2020-03-12
/// Description:  标记、取消标记患者离床日期
/// Table：        DHCHAI.DP.Outofbed、DHCHAI.DP.OutofbedLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.DPS.OutofbedSrv).SaveOprStatus("1^1^2019-12-21^14:44:00^8","^")
ClassMethod SaveOprStatus(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="") return
	
	Set aID = $p(aInputStr,aSeparate,1)
	Set aStatus = $p(aInputStr,aSeparate,2)
	Set DischDate = $p(aInputStr,aSeparate,3)
	Set DischTime = $p(aInputStr,aSeparate,4)
	Set aUserID = $p(aInputStr,aSeparate,5)
	Set obj=##class(DHCHAI.DP.Outofbed).%OpenId(aID)
	Quit:'$IsObject(obj) return
	
	Set EpisodeID = obj.EpisodeDr.%Id()
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DischDate)
	Set:DischTime[":" DischTime = $zth(DischTime,1)
		
	Set obj.OprStatus	= aStatus     //状态（0未标记、1标记、2取消标记）
	Set obj.DischDate	= DischDate   //标记出院日期
	Set obj.DischTime	= DischTime   //标记出院时间
	Set obj.UpdateDate	= +$h    
	Set obj.UpdateTime	= $p($h,",",2)   
	
	Set LogDtl=""
	Set $p(LogDtl,aSeparate,1)=aID
	Set $p(LogDtl,aSeparate,2)=""
	Set $p(LogDtl,aSeparate,3)=aStatus
	Set $p(LogDtl,aSeparate,4)=DischDate  
	Set $p(LogDtl,aSeparate,5)=DischTime   
	Set $p(LogDtl,aSeparate,6)=+$h
	Set $p(LogDtl,aSeparate,7)=$p($h,",",2) 
	Set $p(LogDtl,aSeparate,8)=aUserID
		
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		Set Dtl=##class(DHCHAI.DP.OutofbedLog).Update(LogDtl,aSeparate)	
		
		//修改就诊表、转科记录表
		Set objPAAdm=##class(DHCHAI.DP.PAAdm).%OpenId(EpisodeID)
		If ($IsObject(objPAAdm)) {
			Set VisitStatus = "D"
			Set AdmDays=DischDate-objPAAdm.PAAdmDate   //修复bug:557856统一住院天数计算
			Set:AdmDays<1 AdmDays=1		
			If (aStatus=2) {
				Set VisitStatus="A"
				Set AdmDays=-1
				Set objDischLoc = ""
				Set objDischWard= ""
			}Else {
				Set DischInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,DischDate,DischTime)
				Set DischLocID = $p(DischInfo,"^",1)
				Set DischWardID= $p(DischInfo,"^",2)
				Set objDischLoc = ##class(DHCHAI.BT.Location).GetObjById(DischLocID)
				Set objDischWard = ##class(DHCHAI.BT.Location).GetObjById(DischWardID)
			}
			Set objPAAdm.PAVisitStatus =VisitStatus
			Set objPAAdm.PADischDate =DischDate
			Set objPAAdm.PADischTime =DischTime
			Set objPAAdm.PADischLocDr =objDischLoc
			Set objPAAdm.PADischWardDr =objDischWard	
			Set objPAAdm.PAUpdateDate =+$h
			Set objPAAdm.PAUpdateTime =$p($h,",",2)
			Set objPAAdm.PAAdmDays=AdmDays 
			Set EpisodeIDx = objPAAdm.PAEpisodeIDx
			Set SCode = $p(EpisodeIDx,"||",1)
			Set sc=objPAAdm.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}Else{
				Do ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmTransLoc(SCode,EpisodeIDx)
			}
			Do objPAAdm.%Close()			
		}
	}
	Do obj.%Close()
	
	Quit return
}

}
