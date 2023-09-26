/// 名称: DtPortal.MD.MD10InfectionAlert
/// 描述: Portal感染爆发预警及疑似病例方法接口
/// 编写者：程鹏
/// 编写日期: 2018-12-26
Class DtPortal.MD.MD10InfectionAlert Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     程鹏
/// CreatDate：   2018-12-26
/// Description:  查询一段时间内各个病区爆发预警数量
/// Input：  StartDate		开始日期
/// 			 StartDate		结束日期
/// 			 HospitalId     院区 ID
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD10InfectionAlert","MD100101","2019-3-1","2018-12-26","")
Query MD100101(StartDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,WardID:%String,ActWard:%String,WarnTypes:%String,AllSum:%String")
{
}

ClassMethod MD100101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocWarning")
	d obj.Execute(StartDate,EndDate,"",HospitalId)

	While (obj.Next()) {
	
		set WardID=obj.Data("WardID")
		set ActWard=obj.Data("ActWard")
		set WarnTypes=obj.Data("WarnTypes")			//医院感染暴发预警类型
		set AllSum=obj.Data("AllSum")			//一个患者由多个预警类型，算一人数
		
		Set Data=$lb(ind,WardID,ActWard,WarnTypes,AllSum)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：     程鹏
/// CreatDate：   2018-12-26
/// Description:  查询一段时间内病区爆发预警详情
/// Input：  StartDate		开始日期
/// 			 StartDate		结束日期
/// 			 WardID     	病区 ID      
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD10InfectionAlert","MD100102","2020-3-1","2018-12-26",114)
Query MD100102(StartDate As %String, EndDate As %String, WardID As %String, aHospID As %String = "", aWarnType As %String = "") As DtPortal.Query(ROWSPEC = "ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,WarnSummary,WarnDate,WarnTypes,inDate,Diagnosis")
{
}

ClassMethod MD100102Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardID As %String, aHospID As %String = "", aWarnType As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocWarningDtl")
	d obj.Execute(StartDate,EndDate,WardID,aWarnType)

	While (obj.Next()) {
	
		set WarnLocID=obj.Data("WarnLocID")
		if (aHospID'=""){
			if (WarnLocID'=""){
			 	//set wardLocID=$p($g(^PAWARD(WardID)),"^",5)
			 	Set hospID=$p($g(^CTLOC(wardLocID)),"^",22)
			 	//w !,hospID
				Continue:(aHospID'=hospID)
			}
		}
		
		//b ;01
		set EpisodeID=obj.Data("EpisodeID")
		set WarnSummary=obj.Data("WarnSummary")					//预警信息摘要
		set WarnDate=obj.Data("WarnDate")						//预警日期
		if ((WarnDate'["-")&&(WarnDate'["/")){
			set WarnDate=$zd(WarnDate,3)
		}
		//预警提示类型
		try{
			set WarnTypes=obj.Data("WarnTypes")
		}catch{
			w !,"接口WarnTypes字段不存在"
		}
								
		
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
		
		Set Data=$lb(ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,WarnSummary,WarnDate,WarnTypes,inDate,Diagnosis)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：     程鹏
/// CreatDate：   2018-12-26
/// Description:  查询一段时间内各个病区疑似未处置和确诊未报数量
/// Input：  	 StartDate		开始日期
/// 			 StartDate		结束日期
/// 			 HospitalId     院区 ID
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD10InfectionAlert","MD100201","2018-12-23","2018-12-26","")
Query MD100201(StartDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,WardID,ActWard,Num1,Num2,Num3,Num4")
{
}

ClassMethod MD100201Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocCases")
	d obj.Execute(StartDate,EndDate,HospitalId)

	While (obj.Next()) {
	
		set WardID=obj.Data("WardID")
		set ActWard=obj.Data("ActWard")
		set Num1=obj.Data("Num1")			//疑似未确诊
		set Num2=obj.Data("Num2")			//确诊未上报
		set Num3=obj.Data("Num3")			//疑似人数
		set Num4=obj.Data("Num4")			//疑似例数
		
		Set Data=$lb(ind,WardID,ActWard,Num1,Num2,Num3,Num4)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：     程鹏
/// CreatDate：   2018-12-26
/// Description:  查询一段时间内病区疑似未处置和确诊未报详情
/// Input：  StartDate		开始日期
/// 			 StartDate		结束日期
/// 			 WardID     	病区 ID      
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD10InfectionAlert","MD100202","2018-03-01","2018-03-30",8)
Query MD100202(StartDate As %String, EndDate As %String, WardID As %String, aLocID As %String = "", aHospID As %String = "") As DtPortal.Query(ROWSPEC = "ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,HandleOpion,TishiType,inDate,Diagnosis,HandleDocName,HandleDate")
{
}

ClassMethod MD100202Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardID As %String, aLocID As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocCasesXDtl")
	d obj.Execute(StartDate,EndDate,WardID,aLocID,aHospID)

	While (obj.Next()) {
	
		set EpisodeID=obj.Data("EpisodeID")
		set HandleOpion=obj.Data("HandleOpion")					//处置意见
		set TishiType=obj.Data("TishiType")					//提示类型
		
		set HandleDocName=obj.Data("HandleDocName")  //处置医生
		set HandleDate=obj.Data("HandleDate")			//处置日期
		
		set inHospDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID) 
		set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
   		set inDate=$p(inTimeStr,"^",1)
    	set inDate=$zd(inDate,3)
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
		
		Set Data=$lb(ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,HandleOpion,TishiType,inDate,Diagnosis,HandleDocName,HandleDate)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

}
