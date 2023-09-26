/// 名称: DHCWMR.SSService.RsRquestSrv
/// 描述: 门诊病案调阅申请单相关服务
/// 编写者：liyi
/// 编写日期: 2015-03-30
Class DHCWMR.SSService.RsRquestSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-04-01
/// Description:  门诊病历调阅记录查询
/// Table：       DHCWMR.SS.RsRquest
/// Input：       aReqDate ：
///               aReqStatus ：
///               aReqLoc ：
///               aReqUser ：
/// 				  aLocGrpID:
/// 				  aLocID:
/// 				  aMrNo:
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.RsRquestSrv","QryRsRquest","2015-06-07","2015-06-07","A","117","9")
Query QryRsRquest(aDateFrom As %String, aDateTo As %String, aReqStatus As %String = "", aReqLoc As %String = "", aReqUser As %String = "", aLocGrpID As %String = "", aLocID As %String = "", aMrNo As %String = "") As %Query(ROWSPEC = "RquestID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,EpisodeID:%String,PatName:%String,Sex:%String,Age:%String,VolumeID:%String,VolumeStatusDr:%String,VolumeStatus:%String,ReqLoc:%String,ReqLocDesc:%String,ReqUser:%String,ReqUserDesc:%String,ReqStatus:%String,ReqStatusDesc:%String,ReqDate:%String,ReqTime:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String,UpdateUserDesc:%String,Marker:%String,ReqTypeDesc:%String")
{
}

ClassMethod QryRsRquestExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aReqStatus As %String = "", aReqLoc As %String = "", aReqUser As %String = "", aLocGrpID As %String = "", aLocID As %String = "", aMrNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aMrNo = ##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aMrNo)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}

	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	For xDate = aDateFrom:1:aDateTo{
		Set xVolumeID = "" 
		For {
			Set xVolumeID = $o(^DHCWMR.SS.RsRquestI("IndexRepDateVolumeDr",xDate,xVolumeID))
			Quit:xVolumeID=""

			Set xRsRquestID = "" 
			For {
					Set xRsRquestID = $o(^DHCWMR.SS.RsRquestI("IndexRepDateVolumeDr",xDate,xVolumeID,xRsRquestID))
					Quit:xRsRquestID=""
					
					Set objRsRquest = ##class(DHCWMR.SS.RsRquest).GetObjById(xRsRquestID)
					Set ReqLoc 	  = objRsRquest.RRReqLoc
					Set ReqLocDesc = $p($g(^CTLOC(+ReqLoc)),"^",2)
					Set ReqUser	  = objRsRquest.RRReqUser
					Set ReqUserDesc = ""
					Set:ReqUser'="" ReqUserDesc = $p($g(^SSU("SSUSR",ReqUser)),"^",2)
					Set ReqStatus = objRsRquest.RRReqStatus
					Set ReqTypeDesc = objRsRquest.RRReqType.SDDesc
					Set ReqDate = objRsRquest.RRReqDate
					Set:ReqDate'="" ReqDate=$zd(ReqDate,3)
					Set ReqTime = objRsRquest.RRReqTime
					Set:ReqTime'="" ReqTime=$zt(ReqTime)
					Set UpdateDate = objRsRquest.RRUpdateDate
					Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
					Set UpdateTime = objRsRquest.RRUpdateTime
					Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
					Set UpdateUser = objRsRquest.RRUpdateUser
					Set UpdateUserDesc = ""
					Set:UpdateUser'="" UpdateUserDesc = $p($g(^SSU("SSUSR",UpdateUser)),"^",2)
					Set Marker = objRsRquest.RRMarker
				
					Continue:(aReqStatus'="")&&(aReqStatus'=ReqStatus)
					Continue:(aReqLoc'="")&&(aReqLoc'=ReqLoc)
					Continue:(aReqUser'="")&&(aReqUser'=ReqUser)
					
					Set objVolume = ##class(DHCWMR.SS.Volume).GetObjById(xVolumeID)
					Continue:'$IsObject(objVolume)
					Continue:'objVolume.SVIsActive
					Continue:'objVolume.SVMainDr.SMIsActive
			
					Set VolumeStatus = objVolume.SVStatus.WIDesc
					Set VolumeStatusDr = objVolume.SVStatus.%Id()
					Set MrNo = objVolume.SVMainDr.SMMrNo
					Continue:((aMrNo'="")&&(MrNo'=aMrNo))
				
					Set xSubID=$o(^DHCWMR.SS.VolumeD(xVolumeID,"P",0))
					Set objVolPaadm = ##class(DHCWMR.SS.VolPaadm).GetObjById(xVolumeID_"||"_xSubID)
					Continue:'$IsObject(objVolPaadm)
				
					Set EpisodeID = objVolPaadm.VPEpisodeID
					Set PatientID = objVolPaadm.VPPatientID
					Set PapmiNo = $p(^PAPER(PatientID,"PAT",1),"^",1)
					Set PatName = objVolPaadm.VPPatName
					Set Sex = objVolPaadm.VPSex
					Set Age = objVolPaadm.VPAge
					Set VolumeID = xVolumeID
			
					Set AdmLoc = +$p($g(^PAADM(+EpisodeID)),"^",4)
					If aLocID'="" {
				    	Continue:aLocID'[("|"_AdmLoc_"|")
				    }
			
					Set Data = $lb(xRsRquestID,PatientID,PapmiNo,MrNo,EpisodeID,PatName,Sex,Age,VolumeID,VolumeStatusDr,VolumeStatus,ReqLoc,ReqLocDesc,ReqUser,ReqUserDesc,ReqStatus,ReqStatusDesc,ReqDate,ReqTime,UpdateDate,UpdateTime,UpdateUser,UpdateUserDesc,Marker,ReqTypeDesc)
					Set ^CacheTemp(repid,ind)=Data
		        	Set ind=ind+1
				}
		}
	}
	Quit $$$OK
}

ClassMethod QryRsRquestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRsRquestExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRsRquestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRsRquestExecute ]
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
