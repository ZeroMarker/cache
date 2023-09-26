/// ClassName:    DtPortal.DD.DD14InfectiousDiseases
/// Description:  临床科主任死亡患者服务
/// Creator：     chengpeng
/// CreatDate:    2015-12-10
Class DtPortal.DD.DD16Deaths Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     chengpeng
/// CreatDate：   2015-12-10
/// Description:  DD16.01.01 按月查询科室急诊、住院患者死亡数量分布/死亡率
/// Table：       DHCMed_DTH.Report
/// Input：       StarDate    	 :  开始时间
/// Input：       EndDate        :  结束时间
/// Return：      死亡患者数量
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD16Deaths","QueryDeathsNum","2018-01-01","2019-01-01","I*110||O*7")
Query DD160101(StarDate As %String, EndDate As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "ind,dateCode,dateDesc,num")
{
}

ClassMethod DD160101Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String, locGroupId As %String) As %Status
{

	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
	
	set DocLoc="^"_DocLoc_"^"
	
	k ^||TMPPortalDD160101
	
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
			
			s admid=maxAdm
			
			continue:admid=""
			set admLoc=$p($g(^PAADM(admid)),"^",4)
			set admLocS="^"_admLoc_"^"
			continue:DocLoc'[admLocS
			
			set admType=$p(^PAADM(admid),"^",2)
			set PatientID=$p($g(^PAADM(admid)),"^",1)
			
			set reportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(admid)
			
    		continue:((deathRule=1)&&(reportStr=""))  //取配置,如果配置取死亡报卡,但是没报卡过滤
			
			set dateDesc=$zd(date,3)
			set Rmonth=+$p(dateDesc,"-",2)
			set RDay=+$p(dateDesc,"-",3)
			set RDate=""
		
			set ^||TMPPortalDD160101(Rmonth)=+$g(^||TMPPortalDD160101(Rmonth))+1
			
		}
	}
	
	set length=0
	set length=12
	
				
	for index=1:1:length
	{
		
		set num=+$g(^||TMPPortalDD160101(index))

		set Rindex=index
		set:$l(index)=1 Rindex="0"_index
		set dateCode="",dateDesc=""
		set dateCode=year_"-"_Rindex,dateDesc=year_"年"_Rindex_"月"
		Set ^||CacheTemp(repid,ind)=$lb(ind,dateCode,dateDesc,num)
		Set ind=ind+1
	}
	
	k ^||TMPPortalDD160101
		
	
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2015-12-10
/// Description:  DD16.01.02 按月查询科室急诊、住院死亡患者信息
/// Table：       DHCMed_DTH.Report
/// Input：       StarDate   	 :  开始时间
/// Input：       EndDate        :  结束时间
/// Return：      死亡患者信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD16Deaths","QueryDeathsPatInfo","2018-01-01","2019-01-01","I*110||O*7")
Query DD160102(StarDate As %String, EndDate As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "ind,admid,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType,PatientID")
{
}

ClassMethod DD160102Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String, locGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
	set DocLoc="^"_DocLoc_"^"

	
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
			
			s admid=maxAdm
			
			continue:admid=""
			set admLoc=$p($g(^PAADM(admid)),"^",4)
			set admLocS="^"_admLoc_"^"
			continue:DocLoc'[admLocS
			set admType=$p(^PAADM(admid),"^",2)
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
		 	set regNo=$p(patInfoStr,"^",7) 																	
		 	set PatientID=$p(patInfoStr,"^",8)														
		 	set nurseDesc=$p(patInfoStr,"^",12)																//主管护士
		 	set docDesc=$p(patInfoStr,"^",11)																//主管医生
			set locDesc=$p(patInfoStr,"^",9)																//科室描述
			set wardDesc=$p(patInfoStr,"^",10)		
		
				//入院诊断
			set Diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admid) 
				//出院诊断
			s Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(admid)
			
			Set ^||CacheTemp(repid,ind)=$lb(ind,admid,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,Diagnosis,DeathDate,AReason,admType,PatientID)
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

}
