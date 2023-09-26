/// 类名: DtPortal.ND.ND01.ND0104DeathPat
/// Creator： 程鹏
/// CreatDate： 2018-12-13
/// Description: 查询护理部重点关注死亡患者列表
Class DtPortal.ND.ND01.ND0104DeathPat Extends %RegisteredObject
{

/// Creator： 程鹏
/// CreatDate： 2018-12-13
/// Description: 查询全院各病区某天死亡人数
/// Input：  Date      
/// Return： 
/// 服务编码：ND01.04.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0104DeathPat","ND010401","2018-12-13","2019-12-13")
Query ND010401(startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "name:%String,y:%String,WardId:%String")
{
}

ClassMethod ND010401Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	k ^||TMPPortalND010401
	
	if (startDate="")||(endDate="") q $$$OK ///日期不能为空
	
	set:startDate["-" startDateNum=$zdh(startDate,3)
	set:endDate["-" endDateNum=$zdh(endDate,3)
	//取配置,判断是否走死亡报卡
	set deathRule=##Class(DtPortal.Common.PublicService).getValueByCode("DEATHRULE")
	for Date=startDateNum:1:endDateNum{
		set papmi=""
		for
		{
			set papmi=$o(^PAPERi("DecDate",Date,papmi)) 
			quit:papmi=""
			set admType=""
			for{
				
				set admType=$o(^PAPERdr(papmi,"ADM",admType))
				quit:admType=""
				set EpisodeId=""
				set EpisodeId=$o(^PAPERdr(papmi,"ADM",admType,""),-1) 
				quit:EpisodeId=""
				set PatWardId=$p(^PAADM(EpisodeId),"^",70)
				continue:PatWardId=""
				
				set IsReport=0
				set PatientID=$p($g(^PAADM(EpisodeId)),"^",1)
				set reportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(EpisodeId)
				continue:((deathRule=1)&&(reportStr=""))  //取配置,如果配置取死亡报卡,但是没报卡过滤
				
				set ^||TMPPortalND010401(PatWardId)=+$g(^||TMPPortalND010401(PatWardId))+1
			}
			
			
		}
		
	}
	
	

	set Ward=""	
	for
	{
		set Ward=$o(^||TMPPortalND010401(Ward))
		quit:Ward=""
		
		set WardNum1=$g(^||TMPPortalND010401(Ward))
		set WardDesc=$p(^PAWARD(Ward),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
    	
    	set Data=$lb(WardDesc,WardNum1,Ward)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	k ^||TMPPortalND010401
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-13
/// Description: 查询病区某天死亡人数
/// Input：  WardId      病区ID
/// 		 Date      日期 格式 2018-11-12    
/// Return： 
/// 服务编码：ND01.04.02
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0104DeathPat","ND010402",1,"2018-12-13","2019-12-13")
Query ND010402(WardId As %String, startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,Disdiag,AReason,DeceasedDateTime")
{
}

ClassMethod ND010402Execute(ByRef qHandle As %Binary, WardId As %String, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	if (startDate="")||(endDate="") q $$$OK ///日期不能为空
	
	set:startDate["-" startDateNum=$zdh(startDate,3)
	set:endDate["-" endDateNum=$zdh(endDate,3)
	
	//取配置,判断是否走死亡报卡
	set deathRule=##Class(DtPortal.Common.PublicService).getValueByCode("DEATHRULE")
	for Date=startDateNum:1:endDateNum{
		set papmi=""
		for
		{
			set papmi=$o(^PAPERi("DecDate",Date,papmi)) 
			quit:papmi=""
			
			set admType=""
			for{
				set admType=$o(^PAPERdr(papmi,"ADM",admType))
				quit:admType=""
				set EpisodeId=""
				set EpisodeId=$o(^PAPERdr(papmi,"ADM",admType,""),-1) 
				quit:EpisodeId=""
				set PatWardId=$p(^PAADM(EpisodeId),"^",70)
				continue:PatWardId'=WardId
				
				set IsReport=0,AReason="",DeceasedDateTime=""
				set PatientID=$p($g(^PAADM(EpisodeId)),"^",1)
				
				set reportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(EpisodeId)
					
				continue:((deathRule=1)&&(reportStr=""))  //取配置,如果配置取死亡报卡,但是没报卡过滤
				set DthDate=$p(reportStr,"^",2)
				set DthTime=$p(reportStr,"^",3)
				set:DthDate'="" DthDate=$zd(DthDate,3)
				set:DthTime'="" DthTime=$zt(DthTime,2)
				set DeathDate=DthDate_"&nbsp;"_DthTime
				set AReason=$p(reportStr,"^",4)
				
				set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
			 	set BedCode=$p(patInfoStr,"^",1)
			 	set Name=$p(patInfoStr,"^",2)
			 	set Sex=$p(patInfoStr,"^",3)
			 	set Age=$p(patInfoStr,"^",4)
			 	set MedicareNo=$p(patInfoStr,"^",5)   //病案号
			 	set AdmReason=$p(patInfoStr,"^",6)    //费用类型
			 	set Diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)  //取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
			 
			 	//出院诊断---取统一接口
				set Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(EpisodeId)
			    
			    ;死亡时间
			    set DeceasedTime=$p(^PAPER(papmi,"ALL"),"^",8)
			    i Date'="" s DeceasedDate=$zd(Date,3)
			    i DeceasedTime'="" s DeceasedTime=$zt(DeceasedTime,2)
			    set:DeceasedDateTime="" DeceasedDateTime=DeceasedDate_"&nbsp;"_DeceasedTime
				
				set Data=$lb(BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,Disdiag,AReason,DeceasedDateTime)
		 		set ^||CacheTemp(repid,ind)=Data	
		 		set ind=ind+1
			}
			
			
		}
	}
	
	

	
  	q $$$OK
}

}
