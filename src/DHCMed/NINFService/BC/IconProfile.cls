/// 名称: DHCMed.NINFService.BC.IconProfile
/// 描述: 院感图标管理
/// 编写者：zhufei
/// 编写日期: 2014-03-04
Class DHCMed.NINFService.BC.IconProfile Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.BC.IconProfile).CheckIcon(630465,1)
ClassMethod CheckIcon(aEpisodeID As %String, aCheckFlag As %String)
{
	new (aEpisodeID,aCheckFlag)
	set return=""
	quit:(aEpisodeID="")||(aCheckFlag="") return
	
	set $ZT="CheckIconErr"
	
	Set IsReport=0
	Set arrRec=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(aEpisodeID,"COMP")
	Set Count=arrRec.Count()
	For indRec=1:1:Count {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		Continue:'$isObject(objRec.ReportStatus)
		Set RepStatus=objRec.ReportStatus.Desc
		Continue:(RepStatus["删除")||(RepStatus["草稿")
		Set IsReport=1
	}
	set ConfigCode="INTCCS"
	set xCasesID=""
	for {
		set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",ConfigCode,aEpisodeID,xCasesID))
		quit:xCasesID=""
		
		set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		continue:'$IsObject(objCases)
		set IsActive=objCases.CSIsActive
		continue:IsActive'=1
		set HandleAOper=objCases.CSHandleAOper
		set HandleBOper=objCases.CSHandleBOper
		continue:(HandleAOper=1)||(HandleBOper=1)
		set SttDate=objCases.CSSttDate
		set EndDate=objCases.CSEndDate
		Continue:EndDate'="" //此次感染结束
		
		set HandleADate=objCases.CSHandleADate
		set HandleATime=objCases.CSHandleATime
		set HandleBDate=objCases.CSHandleBDate
		set HandleBTime=objCases.CSHandleBTime
		if (HandleADate'="")&&(HandleBDate="") {
			Set HandleOper=HandleAOper
			Set HandleDate=HandleADate
			Set HandleTime=HandleATime
		}
		if (HandleADate="")&&(HandleBDate'="") {
			Set HandleOper=HandleBOper
			Set HandleDate=HandleBDate
			Set HandleTime=HandleBTime
		}
		if (HandleADate'="")&&(HandleBDate'="") {
			if (HandleADate>HandleBDate)||((HandleADate=HandleBDate)&&(HandleATime>=HandleBTime)){
				Set HandleOper=HandleAOper
				Set HandleDate=HandleADate
				Set HandleTime=HandleATime
			}
			if (HandleADate<HandleBDate)||((HandleADate=HandleBDate)&&(HandleATime<HandleBTime)){
				Set HandleOper=HandleBOper
				Set HandleDate=HandleBDate
				Set HandleTime=HandleBTime
			}
		}
		Continue:HandleOper=""
		
		//黄色图标
		if aCheckFlag=0 {
			if (HandleOper=2) {
				set return="疑似病例未处理;"
			} elseif (HandleOper=3)&&(IsReport=0) {
				Set SttDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SttDate)
				set return="确诊病例未上报：确诊日期"_SttDate
			} else {
				continue
			}
		}
		
		//绿色图标
		if aCheckFlag=1 {
			if (HandleOper=2) {
				continue  //黄图标
			} elseif (HandleOper=3)&&(IsReport=0) {
				continue  //黄图标
			} elseif EndDate'=""  {
				continue  //感染结束不显示图标
			} else {
				Set HandleOper=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(HandleOper)
				;Set HandleDate=$zd(HandleDate,3)
				Set HandleDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HandleDate)
				Set HandleTime=$zt(HandleTime,2)
				
				set return="疑似病例筛查："_HandleOper_"病例,操作日期"_HandleDate_" "_HandleTime
			}
		}
	}
	
	quit return
	
CheckIconErr
	quit $ZError
}

}
