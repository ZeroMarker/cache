Class DtPortal.Doctor.D02ClinicPrompt.D0212RecordQuality Extends %RegisteredObject
{

/// Creator：   bmz--调用电子病历接口
/// CreatDate：   2019-02-16
/// Description:  根据医生工号查询病历质控患者姓名、质控提示数量
/// Input：       UserCode 	   ：用户工号
///               IsRead       : 是否阅读（N/Y）
///                D02.12.01
/// Return：      报告病人姓名，就诊号    
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0212RecordQuality","D021201","P","ys01")
Query D021201(QueryType As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "Name,RecordNum,EpisodeID")
{
}

ClassMethod D021201Execute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String) As %Status
{

   
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:UserCode="" $$$OK
    set UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	s admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserId,"")
	
	for index=1:1:$l(admIdStr,"^")
	{   
		s EpisodeID=$p(admIdStr,"^",index)
		Set rset = ##class(%ResultSet).%New("EPRservice.Quality.Interface.EMRQualityForPortal:GetPromptListForPortal")
		Do rset.Execute(EpisodeID)
		s patInfoStr=""
		s RecordNum=0
		While (rset.Next()) {
			s RecordNum=rset.%ROWCOUNT
		}
		continue:RecordNum=0
		//优化代码，直接只取姓名
		set PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
		Set Name=$P(^PAPER(PatientID,"ALL"),"^",1)
		s ^||CacheTemp(repid,ind)=$lb(Name,RecordNum,EpisodeID)
 		s ind=ind+1
        
       
	} 
	
	Quit $$$OK
}

/// Creator：   bmz--调用电子病历接口
/// CreatDate：   2016-08-29
/// Description:  根据就诊ID查询质控提示信息
/// Input：       UserCode 	   ：用户工号
///               IsRead       : 是否阅读（N/Y）
///                D02.12.01
/// Return：      报告病人姓名，就诊号    
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0212RecordQuality","D021202","1")
Query D021202(EpisodeID As %String) As DtPortal.Query(ROWSPEC = "BedNo,MedicareNo,Name,Sex,Age,AdmReason,EntryID,EntryDesc,EntryScore,StrDate,EndDate,Hours,FinishDate,OverFlag,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod D021202Execute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{

   
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:EpisodeID="" $$$OK
	Set rset = ##class(%ResultSet).%New("EPRservice.Quality.Interface.EMRQualityForPortal:GetPromptListForPortal")
	Do rset.Execute(EpisodeID)
	set EpisodeIDTemp=EpisodeID
	s patInfoStr=""
	set (BedNo,MedicareNo,Name,Sex,Age,AdmReason,EntryID,EntryDesc,EntryScore,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID)=""
	While (rset.Next()) {
		s EntryID=rset.Data("EntryID") //质控条目id
		s EntryDesc=rset.Data("EntryDesc")  //质控描述
		s EntryScore=rset.Data("EntryScore")  //分值
		
		s (StrDate,EndDate,Hours,FinishDate,OverFlag)=""
		try {
			s StrDate=rset.Data("StrDate")  //起始时间
			s EndDate=rset.Data("EndDate")  //截至时间
			s Hours=rset.Data("Hours")    //剩余时间
			s FinishDate=rset.Data("FinishDate")  //完成时间
			s OverFlag=rset.Data("OverFlag")  //是否超时
		}catch{
			//捕获没有接口字段导致报错，兼容旧版本
		}
		
		//b ;01
		
		if (patInfoStr=""){
			s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeIDTemp)
			s BedNo=$p(patInfoStr,"^",1)
			s MedicareNo=$p(patInfoStr,"^",5)
			s Name=$p(patInfoStr,"^",2)
			s Sex=$p(patInfoStr,"^",3)
			s Age=$p(patInfoStr,"^",4)
			s AdmReason=$p(patInfoStr,"^",6)
			
			
			//获取打开电子病历所需要的参数
			set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeIDTemp)
			set EMRDocID=$p(EMRinfo,"^",1)
			set EMRInstanceID=$p(EMRinfo,"^",2)
			set locID=$p(EMRinfo,"^",3)
			set PatientID=$p(EMRinfo,"^",4)
			set EpisodeID=$p(EMRinfo,"^",5)
		}
		
		
		s ^||CacheTemp(repid,ind)=$lb(BedNo,MedicareNo,Name,Sex,Age,AdmReason,EntryID,EntryDesc,EntryScore,StrDate,EndDate,Hours,FinishDate,OverFlag,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
		s ind=ind+1
	}
	Quit $$$OK
}

}
