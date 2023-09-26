/// 名称: DtPortal.MD.MD12Cases
/// 描述: Portal疑似病例
/// 编写者：bmz
/// 编写日期: 2020-03-16
Class DtPortal.MD.MD12Cases Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     bmz
/// CreatDate：   2020-03-16
/// Description:  根据日期和院区id获取到医院各个病区的感染疑似病历情况信息
/// Input：  StartDate		开始日期
/// 			 StartDate		结束日期
/// 			 HospitalId     院区 ID
/// 				 dateType(D--出院患者；A--在院)
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD12Cases","MD120101","2019-12-15","2020-12-26","","A")
Query MD120101(StartDate As %String, EndDate As %String, HospitalId As %String = "", dateType As %String = "") As DtPortal.Query(ROWSPEC = "WardID,WardDesc,SuspectedUnprocessed,ConfirmedUnreported,InfectionPatients,InfectionCases")
{
}

ClassMethod MD120101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospitalId As %String = "", dateType As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocCases")
	d obj.Execute(StartDate,EndDate,HospitalId,dateType)

	While (obj.Next()) {
		set WardID=obj.Data("WardID")
		set WardDesc=obj.Data("WardDesc")
		set SuspectedUnprocessed=obj.Data("SuspectedUnprocessed")	//疑似未处置人数
		set ConfirmedUnreported=obj.Data("ConfirmedUnreported")		//确诊未报人数
		set InfectionPatients=obj.Data("InfectionPatients")			//感染人数
		set InfectionCases=obj.Data("InfectionCases")				//感染例数
		
		Set Data=$lb(WardID,WardDesc,SuspectedUnprocessed,ConfirmedUnreported,InfectionPatients,InfectionCases)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：     bmz
/// CreatDate：   2020-03-16
/// Description:  根据日期和院区id获取到医院各个病区的感染疑似病历情况信息
/// Input：  StartDate		开始日期
/// 			 StartDate		结束日期
/// 			 wardId     病区ID
/// 				InfectionType   疑似感染类型(1-疑似未处置人数；2-确诊未上报人数；3-感染人数；4-感染例数)
/// 				 dateType(D--出院患者；A--在院)     
/// D ##class(%ResultSet).RunQuery("DtPortal.MD.MD12Cases","MD120102","2019-12-15","2020-12-26",114)
Query MD120102(StartDate As %String, EndDate As %String, WardID As %String, InfectionType As %String = "", dateType As %String = "") As DtPortal.Query(ROWSPEC = "EpisodeID,PatientID,InfectionDiagnosis,InfectionKPI,InfectionFactors,inDate,inHospDay,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,InfectionNum")
{
}

ClassMethod MD120102Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardID As %String, InfectionType As %String = "", dateType As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocCasesXDtl")
	d obj.Execute(StartDate,EndDate,WardID,InfectionType,dateType)

	While (obj.Next()) {
		set EpisodeID=obj.Data("EpisodeID")
		set PatientID=obj.Data("PatientID")

		set InfectionDiagnosis=obj.Data("InfectionDiagnosis")  //感染诊断
		set InfectionDiagnosis=##class(DtPortal.MD.MD12Cases).GetInfectionDiagnosis(InfectionDiagnosis)
		
		set InfectionKPI=obj.Data("InfectionKPI")  //感染指标
		set InfectionFactors=obj.Data("InfectionFactors")  //感染因素
		set InfectionFactors=##class(DtPortal.MD.MD12Cases).GetInfectionFactors(InfectionFactors)
		
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
		
		Set Data=$lb(EpisodeID,PatientID,InfectionDiagnosis,InfectionKPI,InfectionFactors,inDate,inHospDay,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,InfectionNum)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

/// 获取感染因素数据，过滤掉为空的拼接
/// w ##class(DtPortal.MD.MD12Cases).GetInfectionFactors("1,2,3,4,5")
ClassMethod GetInfectionFactors(val As %String) As %String
{

	Set return=""
	Quit:val="" return
	
	for i=1:1:$l(val) {
		set temp=$p(val,",",i)
		continue:temp=""
		if (return="") {
			set return=temp
		}else{
			set return=return_","_temp
		}
	
	}
	
	Quit return
}

/// 获取感染诊断数据
/// w ##class(DtPortal.MD.MD12Cases).GetInfectionDiagnosis("1###2")
ClassMethod GetInfectionDiagnosis(InfectionDiagnosisStr As %String) As %String
{

	Set InfectionDiagnosis=""
	Quit:InfectionDiagnosisStr="" InfectionDiagnosis
	
	
	set InfectionNum=$l(InfectionDiagnosisStr,"###")
	if (InfectionNum=1){
		if (InfectionDiagnosisStr'=""){
			set InfectionDiagnosis="1、"_InfectionDiagnosisStr
		}
	}else{
		for index=1:1:InfectionNum
	    {
		    set InfectionDiagnosisTemp=$p(InfectionDiagnosisStr,"###",index)
		    continue:InfectionDiagnosisTemp=""
			set InfectionDiagnosis=InfectionDiagnosis_"<span class=""marginR10"">"_index_"、"_InfectionDiagnosisTemp_"</span>"
			
		}
	}
	
	Quit InfectionDiagnosis
}

}
