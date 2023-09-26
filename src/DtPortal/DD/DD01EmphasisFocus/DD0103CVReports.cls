/// 危急值列表
Class DtPortal.DD.DD01EmphasisFocus.DD0103CVReports Extends %RegisteredObject
{

/// Creator：     chengpeng
/// CreatDate：   2015-12-16
/// Description:  DD01.03.01 查询科室危急值列表
/// Input：       UserCode    :  用户工号
/// Input：       Readstate   :  状态
/// Return：     危急值患者信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0103CVReports","DD010301","ys01","C","95^6","")
Query DD010301(UserCode As %String, Readstate As %String, locGroupID As %String, DocID As %String = "", yearMonth As %String = "") As DtPortal.Query(ROWSPEC = "BedNum:%String,Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,ReportID:%String,RType:%String,TestSet:%String,Summary:%String,EpisodeID:%String,InstanceID:%String,docId:%String,AdmDocID:%String,DocLoc:%String,DiagnoseDesc:%String,ManagerDoc:%String,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID,applyDate,ReportDate")
{
}

ClassMethod DD010301Execute(ByRef qHandle As %Binary, UserCode As %String, Readstate As %String, locGroupID As %String, DocID As %String = "", yearMonth As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	set Readstate="C"  	//现在重点关注的危急值只查未响应的 程鹏
	
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	set startDate=""
	set EndDate=""
	if yearMonth=""
	{
		s days=##Class(DtPortal.Common.PublicService).getValueByCode("CRITICALVALUEQUERYDAYS")
		s startDate=(+$h)-days
		s EndDate=+$h 
	}else
	{
		set Year=$p(yearMonth,"-",1)
		set Month=$p(yearMonth,"-",2)
		set startDate=$zdh(yearMonth_"-01",3)

		set:Month'=12 EndDate=$zdh(Year_"-"_(Month+1)_"-"_"01",3)-1
		set:Month=12 EndDate=$zdh(Year_"-"_Month_"-"_"31",3)
	}
	for index=1:1:$l(DocLocStr,"^")
	{
		
	 set loc=$p(DocLocStr,"^",index)
	f reporttype=1:1:6
	{
		set obj=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
		d obj.Execute(startDate,EndDate,loc,Readstate,"I",reporttype)
		
		While (obj.Next()) {
			
			s (bedNum,name,sex,age,medicareNo,admReason,ReportID,RType,TestSet,Summary,PatientID,EpisodeID,instanceID,docId,AdmDocID)=""
			set AmdLoc=obj.Data("AmdLoc")
			set EpisodeID=obj.Data("adm")
			s ReportID=obj.Data("ReportId")
			s RType=obj.Data("ReportType")
			S TestSet=obj.Data("TSName")
			S Summary=obj.Data("DPRPResult")
			set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
			Continue:PatInfo=""
			set name=$p(PatInfo,"^",2)											//姓名
			set sex=$p(PatInfo,"^",3)											//性别
			set age=$p(PatInfo,"^",4)											//年龄
			set medicareNo=$p(PatInfo,"^",5)									//病案号
			set admReason=$p(PatInfo,"^",6)										//费用类别
			set bedNum=$p(PatInfo,"^",1)										//床号
			set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
			
			Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(AdmObj)
			
			S OEOrdItemID=obj.Data("OEOrdItemID")
			//获取申请时间
			set applyDateStr = ##Class(DtPortal.Common.PublicService).GetOrdItemDate(OEOrdItemID)
			Continue:applyDateStr=""
			
			set applyDate=$zd($p(applyDateStr,"^",1),3)_"&nbsp;"_$zt($p(applyDateStr,"^",2),2)
			
			set ReportTime=obj.Data("ReportTime")
			set ReportDate=obj.Data("ReportDate")    //增加判断是否为当天数据
			
			set ReportDate=$zd(ReportDate,3)
			set ReportTime=$zt(ReportTime,2)
			set ReportDate = ReportDate_"&nbsp;"_ReportTime
			
			set PatientID=AdmObj.PatientID
			set CPDocID=AdmObj.DoctorID
			set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			set ManagerDoc=AdmObj.DoctorName
			continue:(DocID'=AdmDocID)&&(DocID'="")
			set UserID=AdmDocID
			//获取打开电子病历所需要的参数
			set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
			set EMRDocID=$p(EMRinfo,"^",1)
			set EMRInstanceID=$p(EMRinfo,"^",2)
			set locID=$p(EMRinfo,"^",3)
			set PatientID=$p(EMRinfo,"^",4)
			set EMREpisodeID=$p(EMRinfo,"^",5)
			
			
			Set Data=$lb(bedNum,name,sex,age,medicareNo,admReason,ReportID,RType,TestSet,Summary,EpisodeID,instanceID,docId,AdmDocID,DocLoc,DiagnoseDesc,ManagerDoc,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID,applyDate,ReportDate)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		}
		d obj.Close()
	}
	
	Quit $$$OK
}

/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0103CVReports","DD010302","ys01","C","I*95||O*6","")
Query DD010302(UserCode As %String, Readstate As %String, locGroupID As %String, DocID As %String = "", yearMonth As %String = "") As DtPortal.Query(ROWSPEC = "DocID:%String,Name:%String,value:%String")
{
}

ClassMethod DD010302Execute(ByRef qHandle As %Binary, UserCode As %String, Readstate As %String, locGroupID As %String, DocID As %String = "", yearMonth As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	 K ^TempPortalDD010302
	set Readstate="C"  	//现在重点关注的危急值只查未响应的 程鹏
	
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	set startDate=""
	set EndDate=""
	set all=0
	if yearMonth=""
	{
		s days=##Class(DtPortal.Common.PublicService).getValueByCode("CRITICALVALUEQUERYDAYS")
		s startDate=(+$h)-days
		s EndDate=+$h 
	}else
	{
		set Year=$p(yearMonth,"-",1)
		set Month=$p(yearMonth,"-",2)
		set startDate=$zdh(yearMonth_"-01",3)

		set:Month'=12 EndDate=$zdh(Year_"-"_(Month+1)_"-"_"01",3)-1
		set:Month=12 EndDate=$zdh(Year_"-"_Month_"-"_"31",3)
	}
	for index=1:1:$l(DocLocStr,"^")
	{
		
	 set loc=$p(DocLocStr,"^",index)
	f reporttype=1:1:6
	{
		set obj=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
		d obj.Execute(startDate,EndDate,loc,Readstate,"I",reporttype)
		
		While (obj.Next()) {
			
			s (bedNum,name,sex,age,medicareNo,admReason,ReportID,RType,TestSet,Summary,PatientID,EpisodeID,instanceID,docId,AdmDocID)=""
			set AmdLoc=obj.Data("AmdLoc")
			set EpisodeID=obj.Data("adm")
			
			set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
			Continue:PatInfo=""
			
			
			Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(AdmObj)
			
			S OEOrdItemID=obj.Data("OEOrdItemID")
			//获取申请时间
			set applyDateStr = ##Class(DtPortal.Common.PublicService).GetOrdItemDate(OEOrdItemID)
			Continue:applyDateStr=""
					
			set PatientID=AdmObj.PatientID
			set CPDocID=AdmObj.DoctorID
			set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			set ManagerDoc=AdmObj.DoctorName
			continue:(DocID'=AdmDocID)&&(DocID'="")
			set all=all+1
			set ^TempPortalDD010302(AdmDocID)=$g(^TempPortalDD010302(AdmDocID))+1
			set ^TempPortalDD010302(AdmDocID,"name")=ManagerDoc
						
		}
		}
		d obj.Close()
	}
	Set Data=$lb("","全部",all)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1	
	
	set CPDocID=""
	for{
		set CPDocID=$o(^TempPortalDD010302(CPDocID))	
		q:CPDocID=""
		
		set name=$g(^TempPortalDD010302(CPDocID,"name"))
		set value=+$g(^TempPortalDD010302(CPDocID))
		
		Set Data=$lb(CPDocID,name,value)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	
	
	Quit $$$OK
}

}
