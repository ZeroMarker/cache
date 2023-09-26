/// 名称: DHCWMR.SSService.MergerQry
/// 描述: 病案合并、拆分、修改号码相关服务
/// 编写者：zhufei
/// 编写日期: 2014-12-05
Class DHCWMR.SSService.MergerQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-12-05
/// Description:  通过病案类型、病案号查询卷列表
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       MrTypeID : 病案类型ID
///               MrNo : 病案号
/// Debug:	      d ##class(%ResultSet).RunQuery("DHCWMR.SSService.MergerQry","QryVolumeByMrNo","7","500388")
Query QryVolumeByMrNo(aMrTypeID As %String, aMrNo As %String) As %Query(ROWSPEC = "VolID:%String,MainID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryVolumeByMrNoExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aMrNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aMrTypeID="")||(aMrNo="") $$$OK
	Set aMrNo=$zcvt(aMrNo,"U")
	Quit:aMrNo="" $$$OK
	
	Set xMainID=0
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
		Quit:xMainID=""
		
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
			Quit:xVolID=""
			
			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryVolumeByMrNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolumeByMrNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVolumeByMrNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolumeByMrNoExecute ]
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
	Quit:'$IsObject(objVol.SVMainDr.SMMrType.MTMrClass) return
	
	Set MrClass=objVol.SVMainDr.SMMrType.MTMrClass.MCCode
	Set objMain=objVol.SVMainDr
	Set MainID=objVol.SVMainDr.%Id()
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	;Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set BackDate=objVol.SVBackDate
	;Set:BackDate'="" BackDate=$zd(BackDate,3)
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时")
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
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
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	If (MrClass="O")  //门诊就诊科室和日期为初诊科室和初诊日期
	{
		Set FirstLoc=objMain.SMFirstLoc
		Set AdmLocDesc=$p($g(^CTLOC(+FirstLoc)),"^",2)
		Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Set FirstDate=objMain.SMFirstDate
		;Set AdmDate=$zd(FirstDate,3)
		Set AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FirstDate)
	}
	Set return=$lb(aVolID,MainID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Set return=return_$lb(EncryptLevel,PatLevel)
	Quit return
}

}
