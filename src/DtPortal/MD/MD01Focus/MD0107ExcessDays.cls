/// 名称:  DtPortal.MD.MD01Focus.MD0107ExcessDays
/// 描述: 查询全院当前在院患者住院超N天患者
/// 编写者：程鹏
/// 编写日期:2018-12-19
Class DtPortal.MD.MD01Focus.MD0107ExcessDays Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取全院各个科室住院超N天患者
/// Input：     InHospN  取住院超过天数
/// 				HospitalId  院区ID 
/// Return： 科室Id,科室名称,人数,
/// 服务编码：MD01.07.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0107ExcessDays","MD010701",30,"")
Query MD010701(InHospN As %String = 30, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,locID,LocDesc,num")
{
}

ClassMethod MD010701Execute(ByRef qHandle As %Binary, InHospN As %String = 30, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	
 	k ^||TMPPortalMD010701
    set LocID=""
	for
	{
		set LocID=$o(^PAADMi("AdmTypeCurrLoc","I",LocID))
		quit:LocID=""
		
		set hospID=$p(^CTLOC(LocID),"^",22)
		continue:(HospitalId'="")&&(HospitalId'=hospID)
		Set xDate=0
		For {
			Set xDate=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,xDate))
			Quit:xDate=""
			Set xTime=""
			For {
				Set xTime=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,xDate,xTime))
				Quit:xTime=""
				
				Set EpisodeId=""
				For {
					Set EpisodeId=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,xDate,xTime,EpisodeId))
					Quit:EpisodeId=""
					
					Continue:$p($g(^PAADM(+EpisodeId)),"^",2)'="I"   //就诊类型过滤
					Continue:$p($g(^PAADM(+EpisodeId)),"^",20)'="A"   //就诊状态过滤
					
					//住院超N天
					set atHosp=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
					set:atHosp>InHospN ^||TMPPortalMD010701(LocID)=$g(^||TMPPortalMD010701(LocID))+1
					
					
				}
			}
		}
	}
    
		
	set locID=0
	for
	{
		set locID=$o(^||TMPPortalMD010701(locID))
		quit:locID=""
		
		set LocDesc=$p(^CTLOC(locID),"^",2)
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		set num=+$g(^||TMPPortalMD010701(locID))
		
		set Data=$lb(ind,locID,LocDesc,num)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
	
	}
	
    
    k ^||TMPPortalMD010701
	
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取科室住院超N天患者详情
/// Input：     InHospN  取住院超过天数
/// 	        LocID  病区ID  
/// 服务编码：MD01.07.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0107ExcessDays","MD010702",30,104)
Query MD010702(InHospN As %String = 30, LocID As %String) As DtPortal.Query(ROWSPEC = "ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,atHospDay")
{
}

ClassMethod MD010702Execute(ByRef qHandle As %Binary, InHospN As %String = 30, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	

  
	Set xDate=0
	For {
		Set xDate=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,xDate))
		Quit:xDate=""
		Set xTime=""
		For {
			Set xTime=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,xDate,xTime))
			Quit:xTime=""
			
			Set EpisodeId=""
			For {
				Set EpisodeId=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,xDate,xTime,EpisodeId))
				Quit:EpisodeId=""
				
				Continue:$p($g(^PAADM(+EpisodeId)),"^",2)'="I"   //就诊类型过滤
				Continue:$p($g(^PAADM(+EpisodeId)),"^",20)'="A"   //就诊状态过滤
				
				//住院超N天
				set atHosp=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
				if atHosp>InHospN  d ExcessDaysPat
					
			}
		}
	}
	
  	q $$$OK
  
ExcessDaysPat
	set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
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
	set wardDesc=$p(patInfoStr,"^",10)																//病区描述
	set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)				//本次入院诊断
	set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)						//在院天数
    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)					//本次就诊日期
    set inDate=$p(inTimeStr,"^",1)
    set inDate=$zd(inDate,3)
    set inTime=$p(inTimeStr,"^",2)
    set inTime=$zt(inTime,2)
    set inDateTime=inDate_"&nbsp;"_inTime
    
    set atHospDay=atHosp
    set Data=$lb(ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,atHospDay)
 	set ^||CacheTemp(repid,ind)=Data	
 	set ind=ind+1
}

}
