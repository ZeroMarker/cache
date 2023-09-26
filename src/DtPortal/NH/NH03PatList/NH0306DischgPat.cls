Class DtPortal.NH.NH03PatList.NH0306DischgPat Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH03PatList.NH0306DischgPat
/// CreatDate： 2018-11-21
/// Description: 查询护士长患者列表出院患者
/// Input：  UserCode         
/// Return： 
/// 服务代码 NH03.06.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03PatList.NH0306DischgPat","NH030601DischgPat","2156","1","2018-01-01","2018-11-24")
Query NH030601DischgPat(UserCode As %String, WardId As %String, StartDate As %String, EndDate As %String) As DtPortal.Query(ROWSPEC = "ind,name,sex,age,medicareNo,admReason,regNo,PatientID,locDesc,wardDesc,docDesc,nurseDescs,diagnoseDesc,InDay,DischgDate")
{
}

ClassMethod NH030601DischgPatExecute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	
	if StartDate["-"  Set StartDate=$zdh(StartDate,3)
	if EndDate["-" Set EndDate=$zdh(EndDate,3)
	if StartDate="" Set StartDate=+$h
	if EndDate=""  Set EndDate=+$h
	
	for disDate=StartDate:1:EndDate
	{
		set EpisodeId=""
		for
		{
			set EpisodeId=$o(^PAADMi("DischDate",disDate,EpisodeId))
			quit:EpisodeId=""
			
			set paadmType=$P($g(^PAADM(EpisodeId)),"^",2)
			continue:(paadmType'="I")
			
			set pacWard=$P($g(^PAADM(EpisodeId)),"^",70)
			continue:pacWard'=WardId
			
			set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
			set name=$p(patInfoStr,"^",2)
			set sex=$p(patInfoStr,"^",3)
			set age=$p(patInfoStr,"^",4)
			set medicareNo=$p(patInfoStr,"^",5) 
			set admReason=$p(patInfoStr,"^",6)
			set regNo=$p(patInfoStr,"^",7)
			set PatientID=$p(patInfoStr,"^",8)
			set locDesc=$p(patInfoStr,"^",9)
			set wardDesc=$p(patInfoStr,"^",10)
			set docDesc=$p(patInfoStr,"^",11)
			set nurseDescs=$p(patInfoStr,"^",12)
			
			set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(EpisodeId)
			set InDay=##class(DtPortal.Common.PaadmService).getInDayByOutPat(EpisodeId)
			set DischgDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(EpisodeId)
			set DischgDate=$zd($p(DischgDateTimeStr,"^",1),3)
			set DischgTime=$zt($p(DischgDateTimeStr,"^",2),2)
			set DischgDate=DischgDate_"&nbsp;"_DischgTime
			
			Set ^||CacheTemp(repid,ind)=$lb(ind,name,sex,age,medicareNo,admReason,regNo,PatientID,locDesc,wardDesc,docDesc,nurseDescs,diagnoseDesc,InDay,DischgDate)
			Set ind=ind+1
		
		}
		 
	}
	quit $$$OK
}

}
