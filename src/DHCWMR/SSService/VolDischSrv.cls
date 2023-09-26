/// 名称: DHCWMR.SSService.VolDischSrv
/// 描述: 出院病历处置相关服务
/// 编写者：zhufei
/// 编写日期: 2014-10-08
Class DHCWMR.SSService.VolDischSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-10-08
/// Description:  出院病历处置(生成出院病历列表)
/// Input：       MrNo : 病案号
///               AdmType : 就诊类型
/// Return:		  返回String
/// w ##class(DHCWMR.SSService.VolDischSrv).ProcDischVolume()
ClassMethod ProcDischVolume(aMrTypeID As %String, aLocID As %String = "") As %String
{
	New (aMrTypeID,aLocID)
	Set return=0
	
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexOrdStep"," A",xVolID))
		Quit:xVolID=""
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Continue:(aMrTypeID'="")&&(objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID)
		
		Set StepCode="C",DischDate=""
		If (objVol.SVIsActive=1)&&(objVol.SVMainDr.SMIsActive=1) {
			Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(xVolID)
			Continue:VolAdmStr=""
			Set VolAdmID=$p(VolAdmStr,",",1)
			Set EpisodeID=$p(VolAdmStr,",",2)
			Continue:EpisodeID=""
			
			If aLocID'="" {
				Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
				Set AdmWard=$p($g(^PAADM(+EpisodeID)),"^",70)
				Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
				Continue:(aLocID'=AdmLoc)&&(aLocID'=AdmWard)
			}
			
			Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
			Set DischDate=$p(DischDateTime,"^",1)
			Continue:DischDate=""  //未出院病历
			Set:DischDate["-" DischDate=$zdh(DischDate,3)
			Continue:DischDate=objVol.SVDischDate  //表示已经处理过,不再重复处理
			Set StepCode=objVol.SVOrdStep
		} Else {
			Continue:StepCode=objVol.SVOrdStep     //表示已经处理过,不再重复处理
		}
		
		Set InputStr=objVol.%Id()
		Set InputStr=InputStr_"^"_objVol.SVMainDr.%Id()
		Set InputStr=InputStr_"^"_objVol.SVStatus.%Id()
		Set InputStr=InputStr_"^"_StepCode
		Set InputStr=InputStr_"^"_objVol.SVIsLend
		Set InputStr=InputStr_"^"_objVol.SVIsCopy
		Set InputStr=InputStr_"^"_objVol.SVIsStore
		Set InputStr=InputStr_"^"_objVol.SVQCLock
		Set InputStr=InputStr_"^"_DischDate
		Set InputStr=InputStr_"^"_objVol.SVBackDate
		Set InputStr=InputStr_"^"_objVol.SVIPTimes
		Set InputStr=InputStr_"^"_objVol.SVBuildDate
		Set InputStr=InputStr_"^"_objVol.SVBuildTime
		Set InputStr=InputStr_"^"_objVol.SVIsActive
		Set InputStr=InputStr_"^"_objVol.SVResume
		Set InputStr=InputStr_"^"_objVol.SVBarcode
		Set InputStr=InputStr_"^"_objVol.SVIsExPaper
		Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
		If flg<0 {
			Set return=-1
		}
	}
	Quit:return<0 return
	
	Set return=1
	Quit return
}

/// Creator:			zhourm
/// CreateDate:		2014-12-03
/// Description:		生成出院病历,自动任务
/// Input:	
/// w ##class(DHCWMR.SSService.VolDischSrv).InpatientAutoWork()		
ClassMethod InpatientAutoWork()
{
	Set return = 0
	
	Set MyTypeID = 7
	Set return = ..ProcDischVolume(MyTypeID)
	
	Quit return
}

/// Creator:			mxp
/// CreateDate:			2017-01-12
/// Description:		查询迟归病历并发送消息(自动任务)
/// Input:	
/// w ##class(DHCWMR.SSService.VolDischSrv).QryLateBackSendMsg()		
ClassMethod QryLateBackSendMsg()
{
	Set return = 0
	
	Set MyTypeID = 7
	Set return = ..ProcDischVolume(MyTypeID)
	
	//是否启用消息平台消息发送功能
	Set IsSendMsg=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("DHCWMR-IsSendMessage","")
	Quit:+IsSendMsg=0 return
	
	//设置默认发送人为医务科"med manager"
	Set UserName=$$ALPHAUP^SSUTIL4("med manager")
	Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Name",UserName,""))
	Quit:UserID="" return
	
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexOrdStep"," A",xVolID))
		Quit:xVolID=""
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Continue:objVol.SVMainDr.SMMrType.%Id()'=MyTypeID
		
		Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(xVolID)
		Continue:VolAdmStr=""
		Set VolAdmID=$p(VolAdmStr,",",1)
		Set EpisodeID=$p(VolAdmStr,",",2)
		
		Set DischDate=objVol.SVDischDate
		Continue:DischDate=""
		Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DischDate,+$h)  //假日数  //modify by pylian
		Set LateDays=+$h-DischDate-HolidaysConut
		Continue:LateDays<5 //5日迟归
		Set tmpOpinion="出院病历5日迟归(迟归天数:"_LateDays_"天)"
			
		Set DeathDate=##Class(DHCWMR.SSService.CommonSrv).GetDeathDate(EpisodeID)
		if DeathDate'="" {
			//Set HolidaysConut = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(DeathDate,+$h)  //假日数  //modify by pylian
			//Set LateDays=+$h-DeathDate-HolidaysConut
			Continue:LateDays<7 //死亡7日迟归
			Set tmpOpinion="死亡病历7日迟归(迟归天数:"_LateDays_"天)"
		}
		
		Set flg=##class(DHCWMR.IO.FromHisSrv).SendMsg(tmpOpinion,"1015",UserID,EpisodeID,"","")
	}
	
	Quit return
}

}
