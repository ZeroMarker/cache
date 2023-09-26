/// 创建者：李阳
/// 创建日期：2011-04-21
/// 保存入径提示日志
Class web.DHCCPW.MR.ClinPathWayInPathLogSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWayInPathLog
{
	New (argId)
	Set return=##Class(User.DHCMRClinicalPathWayInPathLog).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// w ##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).Update(InStr)
ClassMethod Update(InStr) As %String
{
	New (InStr)
	Set return=-1
	
	Set EpisodeID=$p(InStr,"^",2)
	Set PathWayID=$p(InStr,"^",3)
	Set NoticeDate=$p(InStr,"^",4)
	Set:NoticeDate["-" NoticeDate=$zdh(NoticeDate,3)
	Set:NoticeDate["/" NoticeDate=$zdh(NoticeDate,4)
	Set:NoticeDate="" NoticeDate=+$h
	Set NoticeTime=$p(InStr,"^",5)
	set:NoticeTime'="" NoticeTime=$zth(NoticeTime,1)
	Set:NoticeTime="" NoticeTime=$p($h,",",2)
	Set DoctorID=$p(InStr,"^",6)
	Set MRCICDRowid=$p(InStr,"^",7)
	Set NoticePathWayVerID=+$p(InStr,"^",8)  //update by zf 20121010 处理多路径问题
	Set NotInCPWReason=$p(InStr,"^",9)
	Set NotInCPWResume=$p(InStr,"^",10)
	
	Set LogID=$o(^DHCMRi("LOG",0,"PaadmIndex",+EpisodeID,0))
	If LogID="" {
		Set obj=##class(User.DHCMRClinicalPathWayInPathLog).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWayInPathLog).%OpenId(LogID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Paadm=EpisodeID
	Set:PathWayID'="" obj.PathWayID=PathWayID
	Set obj.NoticeDate=NoticeDate
	Set obj.NoticeTime=NoticeTime
	Set obj.DoctorID=DoctorID
	Set:MRCICDRowid'="" obj.MRCICDRowid=MRCICDRowid
	Set:NoticePathWayVerID'="" obj.NoticePathWayVerID=+NoticePathWayVerID
	Set:NotInCPWReason'="" obj.NotInCPWReason=NotInCPWReason
	Set:NotInCPWResume'="" obj.NotInCPWResume=NotInCPWResume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {       //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

ClassMethod UpdateLogResult(ID As %String, PathWayID As %String) As %String
{
	n (ID,PathWayID)
	set return=-1
	Set obj=##class(User.DHCMRClinicalPathWayInPathLog).%OpenId(ID)
	Quit:'$IsObject(obj) return
	set obj.PathWayID=PathWayID
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// w ##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).NotInCPWReason("74362^208^3^24,^SSS")
ClassMethod NotInCPWReason(aInput As %String, argSeparete As %String) As %String
{
	New (aInput,argSeparete)
	Set return=-1
	Quit:aInput="" return
	Set:$g(argSeparete)="" argSeparete=..#SEPARATE
	
	Set $ZT="NotInCPWReasonErr"
	
	Set EpisodeID=$p(aInput,argSeparete,1)
	Set UserID=$p(aInput,argSeparete,2)
	Set VersonID=$p(aInput,argSeparete,3)
	Set Reason=$p(aInput,argSeparete,4)
	Set Resume=$p(aInput,argSeparete,5)
	
	Set LogID=$o(^DHCMRi("LOG",0,"PaadmIndex",+EpisodeID,0))
	If LogID="" {
		Set obj=##class(User.DHCMRClinicalPathWayInPathLog).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWayInPathLog).%OpenId(LogID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Paadm=EpisodeID
	Set obj.NoticeDate=+$h
	Set obj.NoticeTime=$p($h,",",2)
	Set obj.DoctorID=UserID
	//Set obj.MRCICDRowid=""
	Set obj.NoticePathWayVerID=VersonID
	Set obj.NotInCPWReason=Reason
	Set obj.NotInCPWResume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {    //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
NotInCPWReasonErr
	Quit -999
}

/// add by niepeng 20170609 再入径原因插入数据
/// w ##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).InCPWAgain("74362^208^3^24,^SSS")
ClassMethod InCPWAgain(aInput As %String, argSeparete As %String) As %String
{
	New (aInput,argSeparete)
	Set return=-1
	Quit:aInput="" return
	Set:$g(argSeparete)="" argSeparete=..#SEPARATE
	
	Set $ZT="InCPWAgainErr"
	
	Set EpisodeID=$p(aInput,argSeparete,1)
	Set UserID=$p(aInput,argSeparete,2)
	Set VersonID=$p(aInput,argSeparete,3)
	Set Reason=$p(aInput,argSeparete,4)
	Set Resume=$p(aInput,argSeparete,5)
	
	Set obj=##class(User.DHCMRClinicalPathWayInPathLog).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.Paadm=EpisodeID
	Set obj.NoticeDate=+$h
	Set obj.NoticeTime=$p($h,",",2)
	Set obj.DoctorID=UserID
	Set obj.NoticePathWayVerID=VersonID
	Set obj.NotInCPWReason=Reason
	Set obj.NotInCPWResume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {    //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
InCPWAgainErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2011-09-20
/// Description:  根据Paadm取日志信息
/// Table：       User.DHCMRClinicalPathWayInPathLog
/// Input：       Paadm:    就诊号
/// Return：      返回String
/// w ##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetLogByPaadm(74362,"^")
ClassMethod GetLogByPaadm(aPaadm As %String, argSeparete As %String) As %String
{
	New (aPaadm,argSeparete)
	Set return=""
	Set:$g(argSeparete)="" argSeparete=..#SEPARATE
	
	Set return=""
	Quit:aPaadm="" return
	
	Set LogID=$o(^DHCMRi("LOG",0,"PaadmIndex",+aPaadm,0))
	Quit:LogID="" return
	Set objLog=..GetObjById(LogID)
	Quit:'$IsObject(objLog) return
	
	Set return=objLog.%Id()
	Set return=return_argSeparete_objLog.Paadm
	Set return=return_argSeparete_objLog.PathWayID
	Set NoticeDate=objLog.NoticeDate
	Set:NoticeDate'="" NoticeDate=$zd(NoticeDate,3)
	Set return=return_argSeparete_NoticeDate
	Set NoticeTime=objLog.NoticeTime
	Set:NoticeTime'="" NoticeTime=$zt(NoticeTime,1)
	Set return=return_argSeparete_NoticeTime
	Set return=return_argSeparete_objLog.DoctorID
	Set return=return_argSeparete_objLog.MRCICDRowid
	Set return=return_argSeparete_objLog.NoticePathWayVerID
	Set return=return_argSeparete_objLog.NotInCPWReason
	Set return=return_argSeparete_objLog.NotInCPWResume
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-21
/// Description:  根据Paadm取未入径原因
/// Table：       User.DHCMRClinicalPathWayInPathLog
/// Input：       Paadm:    就诊号
/// Return：      返回String
/// w ##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetNotInReason(74362)
ClassMethod GetNotInReason(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=""
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aPaadm)
	Quit:MRAdm="" return
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,0))
	Quit:PathWayID'="" return
	
	Set LogID=$o(^DHCMRi("LOG",0,"PaadmIndex",+aPaadm,""),-1)
	Quit:LogID="" return
	Set objLog=..GetObjById(LogID)
	Quit:'$IsObject(objLog) return
	
	Set VersionID=objLog.NoticePathWayVerID
	Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(VersionID)
	Quit:'$IsObject(objCPW) return
	
	Set LogReasons=objLog.NotInCPWReason
	For indReason=1:1:$length(LogReasons,",")
	{
		Set ReasonID=$p(LogReasons,",",indReason)
		Set objReason=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(ReasonID)
		Continue:'$IsObject(objReason)
		Set return=return_objReason.VRDesc_";"
	}
	Set LogResume=objLog.NotInCPWResume
	Set return=return_LogResume
	
	Set:return'="" return="因【"_return_"】原因,不符合临床路径【"_objCPW.CPWDesc_"】准入标准!"
	
	Quit return
}

}
