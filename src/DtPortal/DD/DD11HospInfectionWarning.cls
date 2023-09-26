/// ClassName:    DtPortal.DD.DD11HospInfectionWarning
/// Description:  临床科主任医院感染服务
/// Creator：     chengpeng
/// CreatDate:    2015-12-09
Class DtPortal.DD.DD11HospInfectionWarning Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     程鹏
/// CreatDate：   2015-12-09
/// Description:  DD11.01.01 按月查询科室感染暴发预警患者信息
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       
/// D ##class(%ResultSet).RunQuery("DtPortal.DD.DD11HospInfectionWarning","DD110101","2020-03-01","2020-02-01",1)
Query DD110101(StartDate As %String, EndDate As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "bedNum,name,sex,age,medicareNo,doctor,warningDate,warningInfo,promptType,wardName,EpisodeID,regNo,nurseDesc")
{
}

ClassMethod DD110101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, locGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 
 	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
 	for index=1:1:$l(DocLoc,"^")
 	{
	 	set locID=$P(DocLoc,"^",index)
	 	continue:locID=""
	 	set LocWardStr=##Class(DtPortal.Common.PublicService).getWardLocStrByLocIDStr(locID)
	 	
	 	for index2=1:1:$l(LocWardStr,"^")
	 	{
		 	set LocWardID=$P(LocWardStr,"^",index2)
		 	continue:LocWardID=""
		 	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocWarningDtl")
			d obj.Execute(StartDate,EndDate,LocWardID)

			While (obj.Next()) {
			
				set EpisodeID=obj.Data("EpisodeID")
				set warningInfo=obj.Data("WarnSummary")					//预警信息
				set warningDate=obj.Data("WarnDate")							//预警日期
				if ((warningDate'["-")&&(warningDate'["/")){
					set warningDate=$zd(warningDate,3)
				}
				//set ActTime=obj.Data("ActTime")							//预警时间
				//set promptType=obj.Data("NoticeType")					//提示类型
				//预警提示类型
				try{
					set promptType=obj.Data("WarnTypes")
				}catch{
					w !,"接口WarnTypes字段不存在"
				}
				
				set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
		   		set inDate=$p(inTimeStr,"^",1)
		    	set inDate=$zd(inDate,3)
				set inHospDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID) 
				set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
			 	set bedNum=$p(patInfoStr,"^",1)
			 	set name=$p(patInfoStr,"^",2)
			 	set sex=$p(patInfoStr,"^",3)
			 	set age=$p(patInfoStr,"^",4)
			 	set medicareNo=$p(patInfoStr,"^",5)   															//病案号
			 	set admReason=$p(patInfoStr,"^",6)    															//费用类型
			 	set regNo=$p(patInfoStr,"^",7)   																//登记号
			 	set nurseDesc=$p(patInfoStr,"^",12)																//主管护士
			 	set doctor=$p(patInfoStr,"^",11)																//主管医生
				set locDesc=$p(patInfoStr,"^",9)																//科室描述
				set wardName=$p(patInfoStr,"^",10)		
			
				//取诊断
				set Diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
				
				Set Data=$lb(bedNum,name,sex,age,medicareNo,doctor,warningDate,warningInfo,promptType,wardName,EpisodeID,regNo,nurseDesc)
				Set ^||CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	 	}
	}
	
	quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2015-12-09
/// Description:  DD11.02.01 查询当前病区疑似未处置和确诊未报病人信息
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       
/// D ##class(%ResultSet).RunQuery("DtPortal.DD.DD11HospInfectionWarning","DD110201","2020-3-1","2020-3-20","95")
Query DD110201(StartDate As %String, EndDate As %String, locGroupId As %String, InfectionType As %String = "", dateType As %String = "") As DtPortal.Query(ROWSPEC = "bedNum,name,sex,age,medicareNo,regNo,docDesc,nurseDesc,wardDesc,HandleOpion,HandleDate,HandleDocName,TishiType,InfectionDiagnosis,InfectionKPI,InfectionFactors,InfectionNum")
{
}

ClassMethod DD110201Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, locGroupId As %String, InfectionType As %String = "", dateType As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
 	for index=1:1:$l(DocLoc,"^")
 	{
	 	set locID=$P(DocLoc,"^",index)
	 	continue:locID=""
	 	set LocWardStr=##Class(DtPortal.Common.PublicService).getWardLocStrByLocIDStr(locID)
	 	
	 	
	 	for index2=1:1:$l(LocWardStr,"^")
	 	{
		 	set LocWardID=$P(LocWardStr,"^",index2)
		 	continue:LocWardID=""
			set wardId=$o(^PAWARD(0,"WARD_LocationDR",LocWardID,""))
			//w !,wardId
		 	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocCasesXDtl")
			d obj.Execute(StartDate,EndDate,wardId,InfectionType,dateType)

			While (obj.Next()) {
				
				set EpisodeID=obj.Data("EpisodeID")
				set InfectionDiagnosis=obj.Data("InfectionDiagnosis")  //感染诊断
				set InfectionDiagnosis=##class(DtPortal.MD.MD12Cases).GetInfectionDiagnosis(InfectionDiagnosis)
				
				set InfectionKPI=obj.Data("InfectionKPI")  //感染指标
				set InfectionFactors=obj.Data("InfectionFactors")  //感染因素
				set InfectionFactors=##class(DtPortal.MD.MD12Cases).GetInfectionFactors(InfectionFactors)
				
				set inHospDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeID) 
				set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
				set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
		   		set inDate=$p(inTimeStr,"^",1)
		    	set inDate=$zd(inDate,3)
			 	set bedNum=$p(patInfoStr,"^",1)
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
				
				Set Data=$lb(bedNum,name,sex,age,medicareNo,regNo,docDesc,nurseDesc,wardDesc,HandleOpion,HandleDate,HandleDocName,TishiType,InfectionDiagnosis,InfectionKPI,InfectionFactors,InfectionNum)
				Set ^||CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	 	}
 	}
			
		
	
	Quit $$$OK
}

/// 根据就诊号判断是否上报
/// w ##class(DtPortal.MD.MD10InfectionAlert).GetRepIDByEpisodeID(394)
ClassMethod GetRepIDByEpisodeID(EpisodeID As %String) As %String
{

	Set return=""
	Quit:EpisodeID="" return
	
	Set RepID=""
	For {
		Set RepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,RepID))
		Quit:RepID=""	
		
		Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(RepID)
		Continue:'$IsObject(objReport)
		
		Set (ReportTypeCode,ReportStatusDesc)=""
		If $IsObject(objReport.ReportType) {
			Set ReportTypeCode=objReport.ReportType.Code
		}
		Continue:ReportTypeCode'="COMP"
	
		If $IsObject(objReport.ReportStatus) {
			Set ReportStatusDesc=objReport.ReportStatus.Description
		}
		Continue:(ReportStatusDesc["删除")||(ReportStatusDesc["退回")
		set return=RepID
	}
	
	Quit return
}

}
