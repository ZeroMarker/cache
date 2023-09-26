/// 名称: DtPortal.DD.DD09Estimate31ReHosp
/// 描述: 查询当前在院患者中预计31天重返的患者
/// 编写者：mgl
/// 编写日期:2015-8-4
/// 
Class DtPortal.DD.DD09Estimate31ReHosp Extends %RegisteredObject [ ProcedureBlock ]
{

// DD09.01.01按月查询科室预计31天重返的患者信息  	

// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD09Estimate31ReHosp","DD090101","762","2016-06")

Query DD090101(StartDate As %String, EndDate As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,wardDesc,inDay,LastdiagnoseDesc,LastDisDateTime,diagnoseDesc,inDateTime") [ SqlProc ]
{
}

ClassMethod DD090101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, locGroupId As %String) As %Status
{
	set repid=$I(^||CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)

	set StartDate=$zdh(StartDate,3)
	set EndDate=$zdh(EndDate,3)
	
	//取his数据配置,取电子病历首页计划重返术语集(sql:  select InternalID,Description from eprmeta.glossary WHERE Description["31")
	set returnCode=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNEMRCODE")
	
	set KZRLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
	
	s KZRLoc="^"_KZRLoc_"^"
	
	for date=StartDate:1:EndDate
	{
		
		set disAdm=""
		for
		{
			s disAdm=$o(^PAADMi("DischDate",date,disAdm))
			quit:disAdm=""
			
			set loc=$p(^PAADM(disAdm),"^",4) 
    		set loc="^"_loc_"^"
			continue:KZRLoc'[loc  
			
			set obj=##Class(EMRservice.BIEMRService).GetDataByGlossary(disAdm,returnCode)
			set flag=obj.GetNext()
			continue:flag'="有"										//数值为 有 时,预计31天内重返
			set EpisodeID=disAdm
			
			d shouRetPat
		}
	}
	
	Quit $$$OK
	
shouRetPat
	set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
 	set bedCode=$p(patInfoStr,"^",1)
 	set name=$p(patInfoStr,"^",2)
 	set sex=$p(patInfoStr,"^",3)
 	set age=$p(patInfoStr,"^",4)
 	set medicareNo=$p(patInfoStr,"^",5)   															//病案号
 	set admReason=$p(patInfoStr,"^",6)    															//费用类型
 	set regNo=$p(patInfoStr,"^",7)   																//登记号
 	set nurseDesc=$p(patInfoStr,"^",12)																//主管护士
 	set docDesc=$p(patInfoStr,"^",11)																//主管医生
	set locDesc=$p(patInfoStr,"^",9)																//科室描述
	set wardDesc=$p(patInfoStr,"^",10)
	set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID)						//在院天数
	
	//出院患者信息
	set disDate="",disTime=""
	set LastdiagnoseDesc=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(EpisodeID)		//上次出院诊断
	set LastDisDateStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(EpisodeID)				//上次出院日期
    set disDate=$p(LastDisDateStr,"^",1)
    set:disDate'="" disDate=$zd(disDate,3)
    set disTime=$p(LastDisDateStr,"^",2)
    set:disTime'="" disTime=$zt(disTime,2)
    set LastDisDateTime=disDate_"&nbsp;"_disTime
	
	//本次住院信息
	set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)				//诊断
    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)					//就诊日期
    set inDate=$p(inTimeStr,"^",1)
    set inDate=$zd(inDate,3)
    set inTime=$p(inTimeStr,"^",2)
    set inTime=$zt(inTime,2)
    set inDateTime=inDate_"&nbsp;"_inTime
 	
	s ^||CacheTemp(repid,ind)=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,wardDesc,inDay,LastdiagnoseDesc,LastDisDateTime,diagnoseDesc,inDateTime)
	s ind=ind+1
}

}
