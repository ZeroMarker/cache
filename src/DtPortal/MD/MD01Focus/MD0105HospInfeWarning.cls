/// 名称:  DtPortal.MD.MD01Focus.MD0105HospInfeWarning
/// 描述: 查询全院院感爆发信息
/// 编写者：程鹏
/// 编写日期:2018-12-19
Class DtPortal.MD.MD01Focus.MD0105HospInfeWarning Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取全院院感爆发病区数量
/// Input：     hospitalId  院区ID   
/// Return： 科室Id,科室名称,科室类型,人数,
/// 服务编码：MD01.05.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0105HospInfeWarning","MD010501","")
Query MD010501(HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "WardID,ActWard,WarnTypes,AllSum")
{
}

ClassMethod MD010501Execute(ByRef qHandle As %Binary, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	
 	//改为取前一天院感信息  update 程鹏 2019-03-28
 	Set startDate=$zd(+$h-1,3)
	Set endDate=$zd(+$h-1,3)
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocWarning")
	d obj.Execute(startDate,endDate,"",HospitalId)

	While (obj.Next()) {
	
		set WardID=obj.Data("WardID")
		set ActWard=obj.Data("ActWard")
		set WarnTypes=obj.Data("WarnTypes")			//医院感染暴发预警类型
		set AllSum=obj.Data("AllSum")			//一个患者由多个预警类型，算一人数
		
		Set Data=$lb(WardID,ActWard,WarnTypes,AllSum)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取全院院感爆发病区数量
/// Input：     WardID  病区ID   
/// 服务编码：MD01.05.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0105HospInfeWarning","MD010502",193)
Query MD010502(WardID As %String) As DtPortal.Query(ROWSPEC = "bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,WarnSummary,WarnDate,WarnTypes,inDate,Diagnosis")
{
}

ClassMethod MD010502Execute(ByRef qHandle As %Binary, WardID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 
 	Set startDate=$zd(+$h-1,3)
	Set endDate=$zd(+$h-1,3)
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocWarningDtl")
	d obj.Execute(startDate,endDate,WardID,"")
	//PatientName,Sex,Age,InPatientMrNo,Ward,Bed,AdmitDate,DisDate,DataSummary,EpisodeID,PapmiNo,WardID,NoticeType,ActDate,ActTime,ICDDesc,DoctorName 
	While (obj.Next()) {
		set EpisodeID=obj.Data("EpisodeID")
		set WarnSummary=obj.Data("WarnSummary")					//预警信息摘要
		set WarnDate=obj.Data("WarnDate")						//预警日期
		if ((WarnDate'["-")&&(WarnDate'["/")){
			set WarnDate=$zd(WarnDate,3)
		}
		set WarnTypes=obj.Data("WarnTypes")						//预警提示类型
		
		set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
   		set inDate=$p(inTimeStr,"^",1)
    	set inDate=$zd(inDate,3)
		set inHospDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID) 
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
	
		//取诊断
		set Diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
		
		Set Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,WarnSummary,WarnDate,WarnTypes,inDate,Diagnosis)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
  	q $$$OK
}

}
