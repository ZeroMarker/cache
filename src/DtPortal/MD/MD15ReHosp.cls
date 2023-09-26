/// 名称: DtPortal.MD.MD15ReHosp
/// 描述: 二次重返服务
/// 编写者：程鹏
/// 编写日期:2018-12-29
/// 
Class DtPortal.MD.MD15ReHosp Extends %RegisteredObject [ ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD15ReHosp","MD150101","2019-02-01","2019-02-28","")

/// Description	:	MD15.01.01 查询某月各科室二次重返数据
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	HospitalId  院区ID
Query MD150101(StartDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,locID,locDesc,num") [ SqlProc ]
{
}

ClassMethod MD150101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalMD150101
	
	set StartDate=$p(StartDate,"-",1)_"-"_$p(StartDate,"-",2)
	set EndDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)
	
	//取his数据配置,是否取非计划31天重返(1:取全部重返  2 取非计划重返)
	set isReturn=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNHOSPITAL")
	
	s dateType="byMonth"
	s kpiRule="DtPortal0009"
	s filterRule=""
	s mode="H"
	s contract=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set locID=rs.Data("dimIdCol1")
		set retDay=rs.Data("dimIdCol2")
		set AdmStr=rs.Data("dimIdCol3")
		continue:retDay>31
		set hospID=$p($g(^CTLOC(locID)),"^",22)
		i HospitalId'=""  continue:hospID'=HospitalId
		
		set isJH=$p(AdmStr,"_",1)				//是否计划重返，计划值为"计划"，非计划值为："非计划"
		continue:((isReturn=2)&&(isJH="计划"))
		set lastAdm=$p(AdmStr,"_",2)				//上一次住院就诊号
		set EpisodeID=$p(AdmStr,"_",3)				//二次住院就诊号
		set ^||TMPPortalMD150101(locID)=+$g(^||TMPPortalMD150101(locID))+1
		
	}
	
	set locID=""
	for
	{
		set locID=$o(^||TMPPortalMD150101(locID))
		quit:locID=""
		
		set num=+$g(^||TMPPortalMD150101(locID))
		
		set locDesc=$p(^CTLOC(locID),"^",2)
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		
		Set Data=$lb(ind,locID,locDesc,num)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	k ^||TMPPortalMD150101
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD15ReHosp","MD150102","2019-02-01","2019-02-28","")

/// Description	:	MD15.01.02 查询某月各科室二次重返数据
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	LocID  科室ID
Query MD150102(StartDate As %String, EndDate As %String, LocID As %String) As DtPortal.Query(ROWSPEC = "ind,EpisodeId,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,lastAdm,LastdiagnoseDesc,LastinDay,LastDisDateTime") [ SqlProc ]
{
}

ClassMethod MD150102Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	//取his数据配置,是否取非计划31天重返(1:取全部重返  2 取非计划重返)
	set isReturn=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNHOSPITAL")
	
	s dateType="byMonth"
	s kpiRule="DtPortal0009"
	s filterRule="DtPortal0009:([{PatLoc} = "_LocID_"])"
	s mode="H"
	s contract=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set retDay=rs.Data("dimIdCol2")
		set AdmStr=rs.Data("dimIdCol3")
		continue:retDay>31
		
		set isJH=$p(AdmStr,"_",1)				//是否计划重返，计划值为"计划"，非计划值为："非计划"
		set lastAdm=$p(AdmStr,"_",2)				//上一次住院就诊号
		set EpisodeID=$p(AdmStr,"_",3)				//二次住院就诊号
		continue:((isReturn=2)&&(isJH="计划"))
		
		continue:lastAdm=""
		continue:EpisodeID=""
		set LastdiagnoseDesc=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(lastAdm)					//上次出院诊断
		set LastinDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(lastAdm)						//上次在院天数
		set LastDisDateStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(lastAdm)				//上次出院天数
	    set disDate=$p(LastDisDateStr,"^",1)
	    set disDate=$zd(disDate,3)
	    set disTime=$p(LastDisDateStr,"^",2)
	    set disTime=$zt(disTime,2)
	    set LastDisDateTime=disDate_"&nbsp;"_disTime

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
		set wardDesc=$p(patInfoStr,"^",10)																//病区描述
		set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID) 				//本次入院诊断
		set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID)						//在院天数
	    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)					//就诊日期
	    set inDate=$p(inTimeStr,"^",1)
	    set:inDate'="" inDate=$zd(inDate,3)
	    set inTime=$p(inTimeStr,"^",2)
	    set:inTime'="" inTime=$zt(inTime,2)
	    set inDateTime=inDate_"&nbsp;"_inTime
		
		set Data=$lb(ind,EpisodeId,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,lastAdm,LastdiagnoseDesc,LastinDay,LastDisDateTime)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
		
	}
	
	Quit $$$OK
}

}
