/// 名称:  DtPortal.MD.MD01Focus.MD0106ArrearsPat
/// 描述: 查询全院当前在院患者欠费患者
/// 编写者：程鹏
/// 编写日期:2018-12-18
Class DtPortal.MD.MD01Focus.MD0106ArrearsPat Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取全院各个科室欠费患者
/// Input：      HospitalId  院区ID  
/// Return： 科室Id,科室名称,人数,
/// 服务编码：MD01.06.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0106ArrearsPat","MD010601","")
Query MD010601(HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,locID,LocDesc,num")
{
}

ClassMethod MD010601Execute(ByRef qHandle As %Binary, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	
 	k ^||TMPPortalMD010601
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
					
					//在院欠费
					set ArrearsStr=##class(DtPortal.Common.PaadmService).IsArrears(EpisodeId)
					set flag=$p(ArrearsStr,"^",1)
					set:flag=1 ^||TMPPortalMD010601(LocID)=$g(^||TMPPortalMD010601(LocID))+1
					
				}
			}
		}
	}
    
		
	set locID=0
	for
	{
		set locID=$o(^||TMPPortalMD010601(locID))
		quit:locID=""
		
		set LocDesc=$p(^CTLOC(locID),"^",2)
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		set num=+$g(^||TMPPortalMD010601(locID))
		
		set Data=$lb(ind,locID,LocDesc,num)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
	
	}
	
    
    k ^||TMPPortalMD010601
	
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取科室欠费患者详情
/// Input：      LocID  病区ID  
/// Return： 科室Id,科室名称,人数,
/// 服务编码：MD01.06.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0106ArrearsPat","MD010602",93)
Query MD010602(LocID As %String) As DtPortal.Query(ROWSPEC = "ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,totalFee,balance")
{
}

ClassMethod MD010602Execute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	
	//欠费取数规则取配置,值为预警,或者完全控制
	//set ARREARSFLAG=##Class(DtPortal.Common.PublicService).getValueByCode("ARREARSFLAG")
  
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
				
				//在院欠费
				set ArrearsStr=##class(DtPortal.Common.PaadmService).IsArrears(EpisodeId)
				set flag=$p(ArrearsStr,"^",1)
				if flag=1  d ArrearsPat
					
			}
		}
	}
	
  	q $$$OK
  
ArrearsPat
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
	set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)		//本次入院诊断
	set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)						//在院天数
    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)					//本次就诊日期
    set inDate=$p(inTimeStr,"^",1)
    set dae=inDate
    set inDate=$zd(inDate,3)
    set inTime=$p(inTimeStr,"^",2)
    set inTime=$zt(inTime,2)
    set inDateTime=""
    if (dae'="") set inDateTime=inDate_"&nbsp;"_inTime
    
    set totalFee=$p(ArrearsStr,"^",2)																//总费用
    set balance=$p(ArrearsStr,"^",3)																//余额
    
    set Data=$lb(ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,totalFee,balance)
 	set ^||CacheTemp(repid,ind)=Data	
 	set ind=ind+1
}

}
