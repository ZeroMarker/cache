/// DtPortal.NH.NH03PatList.NH0307DeathPat
/// 描述:查询护士长患者列表死亡患者
/// 编写者：程鹏
/// 编写日期: 2018-11-21
Class DtPortal.NH.NH03PatList.NH0307DeathPat Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH03PatList.NH0307DeathPat
/// CreatDate： 2018-11-21
/// Description: 查询护士长患者列表死亡患者
/// Input：  UserCode         
/// Return： 
/// 服务代码 NH03.07.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03PatList.NH0307DeathPat","NH030701DeathPat","hs01","3","2019-03-19","2019-03-22")
Query NH030701DeathPat(UserCode As %String, WardId As %String, StartDate As %String, EndDate As %String) As DtPortal.Query(ROWSPEC = "ind,patname,sex,age,meNum,type,bednum,Ward,Dept,regNo,inDate,inHospDay,Diagnosis,docname,nurseDescs,DeathDate,AReason,IsReport,Disdiag")
{
}

ClassMethod NH030701DeathPatExecute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK

	if StartDate["-"  Set StartDate=$zdh(StartDate,3)
	if EndDate["-" Set EndDate=$zdh(EndDate,3)
	if StartDate="" Set StartDate=+$h
	if EndDate=""  Set EndDate=+$h
	
	//取配置,判断是否走死亡报卡
	set deathRule=##Class(DtPortal.Common.PublicService).getValueByCode("DEATHRULE")
	
	for date=StartDate:1:EndDate
	{
		set papmi=""
		for
		{
			set papmi=$o(^PAPERi("DecDate",date,papmi)) 
			quit:papmi=""
			
			set deathTime=$p(^PAPER(papmi,"ALL"),"^",8)
			set:deathTime'="" deathTime=$zt(deathTime,2)
			set admid=""
			set admid=$o(^PAPERdr(papmi,"ADM","I",""),-1) 
			quit:admid=""
				
			set aloc=$p(^PAADM(admid),"^",4)  
			set adocID=$p(^PAADM(admid),"^",9)
			set aWardID=$p(^PAADM(admid),"^",70)
			continue:WardId'=aWardID
			
			set DeathDate = $zd(date,3)_"&nbsp;"_deathTime
			set PatientID=$p($g(^PAADM(admid)),"^",1)
			set AReason="",IsReport="未上报",Ward="",Dept=""
			
			
			set reportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(admid)
			set:((reportStr'=-1)&&(reportStr'="")) IsReport="已上报"
			continue:((deathRule=1)&&(reportStr=""))  //取配置,如果配置取死亡报卡,但是没报卡过滤
			
			if reportStr'=""
			{
				set DthDate=$p(reportStr,"^",2)
				set DthTime=$p(reportStr,"^",3)
				set:DthDate'="" DthDate=$zd(DthDate,3)
				set:DthTime'="" DthTime=$zt(DthTime,2)
				set DeathDate=DthDate_"&nbsp;"_DthTime
				set AReason=$p(reportStr,"^",4)
			}
			
			
	
			set inDateStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(admid)
			set inDate=$p(inDateStr,"^",1)
			set inDate = $zd(inDate,3)
	
			set inHospDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(admid) 
			set PatInfo=##class(DtPortal.Common.PublicService).GetPatInfo(admid)
			Continue:PatInfo=""
			
			set patname=$p(PatInfo,"^",2)											//姓名
			set sex=$p(PatInfo,"^",3)												//性别
			set age=$p(PatInfo,"^",4)												//年龄
			set meNum=$p(PatInfo,"^",5)												//病案号
			set type=$p(PatInfo,"^",6)												//费用类别
			set bednum=$p(PatInfo,"^",1)
			set regNo=$p(PatInfo,"^",7)										
       		set Dept=$p(PatInfo,"^",9)
			set Ward=$p(PatInfo,"^",10)
			set docname=$p(PatInfo,"^",11)
			set nurseDescs=$p(PatInfo,"^",12)
		
				//诊断
			set Diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admid)
				//出院诊断
			s Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(admid)
			Set ^||CacheTemp(repid,ind)=$lb(ind,patname,sex,age,meNum,type,bednum,Ward,Dept,regNo,inDate,inHospDay,Diagnosis,docname,nurseDescs,DeathDate,AReason,IsReport,Disdiag)
			Set ind=ind+1
			
			
		}
	}
	quit $$$OK
}

}
