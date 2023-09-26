/// 名称: DHCWMR.SSService.VolLocDisQry
/// 描述: 科室查询病历服务
/// 编写者：周瑞猛
/// 编写日期: 2015-03-26
Class DHCWMR.SSService.VolLocDisQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2015-03-26
/// Description:  根据科室查询病历
/// Table：       Pa_Adm、DHCWMR.SS.Volume、DHCWMR.SS.Main
/// Input：       MrTypeID ：病案类型ID
///               DateFrom ：开始日期
///               DateTo ：结束日期
///               LocID ：科室ID
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolLocDisQry","QryVolListByLoc","7","2015-03-01","2015-03-28","245")
Query QryVolListByLoc(aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Query(ROWSPEC = "VolID:%String,EpisodeID:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,DoctorName:%String,AdmLocDesc:%String,AdmWardDesc:%String,EstimDischDate:%String,DischDate:%String,StatusDesc:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprNurStatus:%String,EprNurStatusDesc:%String,EprPdfStatus:%String,EprPdfStatusDesc:%String")
{
}

ClassMethod QryVolListByLocExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Quit:(aLocID="")||(aMrTypeID="") $$$OK
	
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexOrdStep"," A",xVolID))
		Quit:xVolID=""
		
		Set Data=..BuildVolume(xVolID)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryVolListByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolListByLocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVolListByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolListByLocExecute ]
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

ClassMethod BuildVolume(aVolID As %String) As %List
{
	Set return=""
	Quit:aVolID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Quit:objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID return
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set StatusDesc=objVol.SVStatus.WIDesc
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Quit:EpisodeID="" return
	Set AdmLoc=$p(VolAdmStr,",",3)
	Set AdmWard=$p(VolAdmStr,",",4)
	Set AdmHosp=$p(VolAdmStr,",",5)
	If aLocID'="" {
    	Quit:(aLocID'[("|"_AdmLoc_"|"))&&(aLocID'[("|"_AdmWard_"|")) return
    }
	
	Set EstimDischDate=$p($g(^PAADM(EpisodeID)),"^",59)  //医疗结算日期
	//Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)  //最终结算日期
	//update by pylian 2016-01-22
	Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Quit:(EstimDischDate="")&&(DischDate="") return //未出院病历
	Set EstimDischFlg=1
	If EstimDischDate'="" {
		Set:(aDateFrom'="")&&(EstimDischDate<aDateFrom) EstimDischFlg=0
		Set:(aDateTo'="")&&(EstimDischDate>aDateTo) EstimDischFlg=0
	}
	Set DischFlg=1
	If DischDate'="" {
		Set:(aDateFrom'="")&&(DischDate<aDateFrom) DischFlg=0
		Set:(aDateTo'="")&&(DischDate>aDateTo) DischFlg=0
	}
	Quit:(EstimDischFlg=0)&&(DischDate=0) return
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	If EpisodeID'="" {
		Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
		Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
		Quit:VisitStatus="C" return
	}
	Set PapmiNo=""
	Set:PatientID'="" PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	Set Age=objVolAdm.VPAge
	
    Set AdmLoc=objVolAdm.VPAdmitDept
	Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
    Set AdmWard=objVolAdm.VPAdmitWard
	Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
    Set DischDept=objVolAdm.VPDischDept
	Set DischDeptDesc=objVolAdm.VPDischDeptDesc
	Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
    Set DischWard=objVolAdm.VPDischWard
	Set DischWardDesc=objVolAdm.VPDischWardDesc
	Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
	Set:DischDept'="" AdmLoc=DischDept
	Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
	Set:DischWard'="" AdmWard=DischWard
	Set:DischWardDesc'="" AdmWardDesc=DischWardDesc
	Set AdmDate=objVolAdm.VPAdmitDate
	Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	
	Set EstimDischDate=$p($g(^PAADM(EpisodeID)),"^",59)  //医疗结算日期
	Set:EstimDischDate'="" EstimDischDate=$zd(EstimDischDate,3)
	Set EstimDischTime=$p($g(^PAADM(EpisodeID)),"^",60)  //医疗结算时间
	Set:EstimDischTime'="" EstimDischTime=$zt(EstimDischTime)
	Set:EstimDischDate'="" EstimDischDate=EstimDischDate_" "_EstimDischTime
	
	//update by pylian 2016-01-22
	Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	//Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)  //最终结算日期
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	//Set DischTime=$p($g(^PAADM(EpisodeID)),"^",18)  //最终结算时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set:DischDate'="" DischDate=DischDate_" "_DischTime
	
    Set DoctorID=+$p($g(^PAADM(+EpisodeID)),"^",9)  //主管医生
    Set DoctorName=$p($g(^CTPCP(+DoctorID,1)),"^",2)
    
	Set EprStatus=##class(DHCWMR.IO.FromEprSrv).GetMedRecordStatus(EpisodeID)		//医生护士提交
	Set EprDocStatus=+$p(EprStatus,"^",2)
	Set EprDocStatusDesc=$s(EprDocStatus=1:"是",1:"否")
	Set EprNurStatus=+$p(EprStatus,"^",1)
	Set EprNurStatusDesc=$s(EprNurStatus=1:"是",1:"否")
	Set EprPdfStatus=+$p(EprStatus,"^",3)
	Set EprPdfStatusDesc=$s(EprPdfStatus=1:"是",1:"否")
	
	Set return=$lb(aVolID,EpisodeID,MrNo,PatName,Sex,Age,DoctorName)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,EstimDischDate,DischDate,StatusDesc)
	Set return=return_$lb(EprDocStatus,EprDocStatusDesc,EprNurStatus,EprNurStatusDesc,EprPdfStatus,EprPdfStatusDesc)
	Quit return
}

}
