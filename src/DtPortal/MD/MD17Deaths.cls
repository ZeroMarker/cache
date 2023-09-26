/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：mgl
/// 编写日期:2014-10-14
/// 
Class DtPortal.MD.MD17Deaths Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator     :程鹏
/// description :获取全院各个时间段的死亡数量
/// 服务号 :MD17.01.01
/// input:  	DateType		日期类型 (year  month)
/// 		 	StarDate		开始时间 (格式:2018-01-01)
/// 			EndDate			结束时间 (格式:2018-01-31)
/// 			HospitalId		院区 ID
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD17Deaths","MD170101","month","2018-03-01","2018-03-31","")
Query MD170101(DateType As %String, StarDate As %String, EndDate As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,dateCode,dateDesc,num,numI,numE")
{
}

ClassMethod MD170101Execute(ByRef qHandle As %Binary, DateType As %String, StarDate As %String, EndDate As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||TMPPortalMD170101
	
	//取配置,判断是否走死亡报卡
	set deathRule=##Class(DtPortal.Common.PublicService).getValueByCode("DEATHRULE")
	
	set year=$p(StarDate,"-",1)
	set month=$p(StarDate,"-",2)
	
	s StarDate=$zdh(StarDate,3)
	s EndDate=$zdh(EndDate,3)
	
	for date=StarDate:1:EndDate
	{
		set papmi=""
		for
		{
			set papmi=$o(^PAPERi("DecDate",date,papmi)) 
			quit:papmi=""
			set admidE=$o(^PAPERdr(papmi,"ADM","E",""),-1)
			set admidI=$o(^PAPERdr(papmi,"ADM","I",""),-1)
			s maxAdm=+admidE
			if (+admidI>maxAdm) {
				s maxAdm=admidI
			}
			continue:maxAdm=0
			s admid=maxAdm
			continue:admid=""
			set admLoc=$p($g(^PAADM(admid)),"^",4)
			set hospID=$p($g(^CTLOC(admLoc)),"^",22)
			i HospitalId'=""  continue:hospID'=HospitalId
			set admType=$p(^PAADM(admid),"^",2)
			set PatientID=$p($g(^PAADM(admid)),"^",1)
			
			set reportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(admid)
			
    		continue:((deathRule=1)&&(reportStr=""))  //取配置,如果配置取死亡报卡,但是没报卡过滤
			
			set dateDesc=$zd(date,3)
			set Rmonth=+$p(dateDesc,"-",2)
			set RDay=+$p(dateDesc,"-",3)
			set RDate=""
			set:DateType="year" RDate=Rmonth
			set:DateType="month" RDate=RDay
			set ^||TMPPortalMD170101(RDate,admType)=+$g(^||TMPPortalMD170101(RDate,admType))+1
			
		}
	}
	
	set length=0
	set MonthDay=##Class(DtPortal.Common.PublicService).getMonthDay(year_"-"_month)
	set:DateType="year" length=12
	set:DateType="month" length=MonthDay
				
	for index=1:1:length
	{
		
		set numI=+$g(^||TMPPortalMD170101(index,"I"))
		set numE=+$g(^||TMPPortalMD170101(index,"E"))
		set num=numI+numE
		
		set Rindex=index
		set:$l(index)=1 Rindex="0"_index
		set dateCode="",dateDesc=""
		set:DateType="year" dateCode=year_"-"_Rindex,dateDesc=year_"年"_Rindex_"月"
		set:DateType="month" dateCode=year_"-"_month_"-"_Rindex,dateDesc=year_"年"_month_"月"_Rindex_"日"
		Set ^||CacheTemp(repid,ind)=$lb(ind,dateCode,dateDesc,num,numI,numE)
		Set ind=ind+1
	}
	
	k ^||TMPPortalMD170101
	Quit $$$OK
}

/// creator     :程鹏
/// description :查询一段时间内死亡患者详情
/// 服务号 :MD17.01.01
/// input:		StarDate		开始时间 (格式:2018-01-01)
/// 			EndDate			结束时间 (格式:2018-01-31)
/// 		  	AdmType		日期类型 (year  month)
/// 			HospitalId		院区 ID
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD17Deaths","MD170102","2019-04-01","2019-04-02","I","")
Query MD170102(StarDate As %String, EndDate As %String, AdmType As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,admid,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType")
{
}

ClassMethod MD170102Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String, AdmType As %String, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||TMPPortalMD170101
	
	//取配置,判断是否走死亡报卡
	set deathRule=##Class(DtPortal.Common.PublicService).getValueByCode("DEATHRULE")
	

	s StarDate=$zdh(StarDate,3)
	s EndDate=$zdh(EndDate,3)
	
	for date=StarDate:1:EndDate
	{
		set papmi=""
		for
		{
			set AReason=""
			set papmi=$o(^PAPERi("DecDate",date,papmi)) 
			quit:papmi=""
			
			set admidE=$o(^PAPERdr(papmi,"ADM","E",""),-1)
			set admidI=$o(^PAPERdr(papmi,"ADM","I",""),-1)
			
			s maxAdm=+admidE
			if (+admidI>maxAdm) {
				s maxAdm=admidI
			}
			continue:maxAdm=0
			s admid=maxAdm
			
			continue:admid=""
			set admLoc=$p($g(^PAADM(admid)),"^",4)
			set hospID=$p($g(^CTLOC(admLoc)),"^",22)
			i HospitalId'=""  continue:hospID'=HospitalId
			set admType=$p(^PAADM(admid),"^",2)
			continue:((AdmType'="")&&(AdmType'=admType))
			set PatientID=$p($g(^PAADM(admid)),"^",1)
			
			set deathTime=$p(^PAPER(papmi,"ALL"),"^",8)
			set:deathTime'="" deathTime=$zt(deathTime,2)
			set DeathDate = $zd(date,3)_"&nbsp;"_deathTime
			
			set reportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(admid)
			
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
			set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admid)
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
		
				//入院诊断
			set Diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admid) 
				//出院诊断
			s Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(admid)

			Set ^||CacheTemp(repid,ind)=$lb(ind,admid,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType)
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

}
