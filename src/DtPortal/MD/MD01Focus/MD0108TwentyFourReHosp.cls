/// 名称:  DtPortal.MD.MD01Focus.MD0108TwentyFourReHosp
/// 描述: 查询全院当前在院患者是24小时内重返的患者
/// 编写者：程鹏
/// 编写日期:2018-12-19
Class DtPortal.MD.MD01Focus.MD0108TwentyFourReHosp Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取全院各个科室24小时内重返的患者
/// Input：      HospitalId  院区ID  
/// Return： 科室Id,科室名称,人数,
/// 服务编码：MD01.08.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0108TwentyFourReHosp","MD010801","")
Query MD010801(HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,locID,LocDesc,num")
{
}

ClassMethod MD010801Execute(ByRef qHandle As %Binary, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	
 	k ^||TMPPortalMD010801
 	
 	//取his数据配置,是否取非计划31天重返(1:取全部重返  2 取非计划重返)
	set isReturn=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNHOSPITAL")
	//取his数据配置,取电子病历首页计划重返术语集(sql:  select InternalID,Description from eprmeta.glossary WHERE Description["31")
	set returnCode=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNEMRCODE")
 	
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
					
					set papmidr=$p(^PAADM(EpisodeId),"^",1)				//病人基本信息表ID
					set LastAdm=$o(^PAPERdr(papmidr,"ADM","I",EpisodeId),-1)		//上次就诊ID
					
					continue:LastAdm=""
					set Latloc=$p(^PAADM(LastAdm),"^",4)  						//上次就诊科室
    				continue:LocID'=Latloc											//只取二次住院同一科室的数据
    				
					if isReturn=2
	    			{
		    			set obj=##Class(EMRservice.BIEMRService).GetDataByGlossary(LastAdm,returnCode)
		    			set flag=obj.GetNext()
		    			continue:flag="有"										//数值为 有 时,上次住院计划31天内重返,过滤
		    		}
    				
					if LastAdm'=""
					{
						set lastDisDateStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(LastAdm)
						set lastDisDate=$p(lastDisDateStr,"^",1)
						set lastDisTime=$p(lastDisDateStr,"^",2)
						
						set reHospDay=xDate-lastDisDate			//上次住院距本次住院天数
						
						//24小时内重返
						if reHospDay<2
						{
							set:((reHospDay=1)&&(xTime-lastDisTime<0)) ^||TMPPortalMD010801(LocID)=$g(^||TMPPortalMD010801(LocID))+1
							set:reHospDay=0 ^||TMPPortalMD010801(LocID)=$g(^||TMPPortalMD010801(LocID))+1
						}
							
					}
				}
			}
		}
	}
    
		
	set locID=0
	for
	{
		set locID=$o(^||TMPPortalMD010801(locID))
		quit:locID=""
		
		set LocDesc=$p(^CTLOC(locID),"^",2)
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		set num=+$g(^||TMPPortalMD010801(locID))
		
		set Data=$lb(ind,locID,LocDesc,num)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
	
	}
	
    
    k ^||TMPPortalMD010801
	
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取科室31天重返患者详情
/// Input：      LocID  病区ID  
/// Return： 科室Id,科室名称,人数,
/// 服务编码：MD01.08.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0108TwentyFourReHosp","MD010302",156)
Query MD010802(LocID As %String) As DtPortal.Query(ROWSPEC = "ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,LastdiagnoseDesc,LastinDay,LastOutDate")
{
}

ClassMethod MD010802Execute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	
	//取his数据配置,是否取非计划31天重返(1:取全部重返  2 取非计划重返)
	set isReturn=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNHOSPITAL")
	//取his数据配置,取电子病历首页计划重返术语集(sql:  select InternalID,Description from eprmeta.glossary WHERE Description["31")
	set returnCode=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNEMRCODE")
  
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
				
				set papmidr=$p(^PAADM(EpisodeId),"^",1)				//病人基本信息表ID
				set LastAdm=$o(^PAPERdr(papmidr,"ADM","I",EpisodeId),-1)		//上次就诊ID
				
				continue:LastAdm=""
				set Latloc=$p(^PAADM(LastAdm),"^",4)  						//上次就诊科室
    			continue:LocID'=Latloc	
    				
    			if isReturn=2
    			{
	    			set obj=##Class(EMRservice.BIEMRService).GetDataByGlossary(LastAdm,returnCode)
	    			set flag=obj.GetNext()
	    			continue:flag="有"										//数值为 有 时,上次住院计划31天内重返,过滤
	    		}	
		
				if LastAdm'=""
				{
					set lastDisDateStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(LastAdm)
					set lastDisDate=$p(lastDisDateStr,"^",1)
					set lastDisTime=$p(lastDisDateStr,"^",2)
					
					set reHospDay=xDate-lastDisDate			//上次住院距本次住院天数
					
					//24小时内重返
					if reHospDay<2
					{
						if ((reHospDay=1)&&(xTime-lastDisTime<0)) d TwentyFourReHospPat
						if reHospDay=0 d TwentyFourReHospPat
					}
					
				}
			}
		}
	}
	
  	q $$$OK
  
TwentyFourReHospPat
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
	set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)		 		//本次入院诊断
	set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)						//在院天数
    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)					//本次就诊日期
    set inDate=$p(inTimeStr,"^",1)
    set:inDate'="" inDate=$zd(inDate,3)
    set inTime=$p(inTimeStr,"^",2)
    set:inTime'="" inTime=$zt(inTime,2)
    set inDateTime=inDate_"&nbsp;"_inTime
    
    set LastdiagnoseDesc=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(LastAdm)					//上次出院诊断
	set LastinDay=##class(DtPortal.Common.PaadmService).getInDayByOutPat(LastAdm)						//上次住院天数
    set LastOutTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(LastAdm)				//上次出院日期
    set LastOutDate=$p(LastOutTimeStr,"^",1)
    set LastOutDate=$zd(LastOutDate,3)
    set LastOutTime=$p(LastOutTimeStr,"^",2)
    set LastOutTime=$zt(LastOutTime,2)
    set LastOutDate=LastOutDate_"&nbsp;"_LastOutTime
    
    set Data=$lb(ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,LastdiagnoseDesc,LastinDay,LastOutDate)
 	set ^||CacheTemp(repid,ind)=Data	
 	set ind=ind+1
}

}
