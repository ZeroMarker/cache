/// DtPortal.MD.MD01Focus.MD0100FocusNum
/// 描述:查询医务处重点关注数量
/// 编写者：程鹏
/// 编写日期: 2018-12-18
Class DtPortal.MD.MD01Focus.MD0100FocusNum Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator： 程鹏
/// CreatDate： 2018-12-18
/// Description:查询医务处重点关注各个数量
/// Input：  HospitalId 		院区 ID
/// 			 InHospN			住院超N天统计天数
/// Return： 医务处重点关注各个数量
/// 服务代码：MD01.00.01
/// set obj= ##class(DtPortal.MD.MD01Focus.MD0100FocusNum).MD010001("2","")
ClassMethod MD010001(HospitalId As %String = "", InHospN As %String = "30") As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	//Set $ZT = "ErrSendMessage"
	
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	Set retVal=""
	
	//取his数据配置,是否取标识二次手术(1:取全部二次手术  2 取标识二次手术)
	//标识二次手术是指取在手术申请单中【重返手术】选【是】的患者信息
	set isBiao=##Class(DtPortal.Common.PublicService).getValueByCode("TWICEOPRATION")
	
	//取his数据配置,是否取非计划31天重返(1:取全部重返  2 取非计划重返)
	set isReturn=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNHOSPITAL")
	//取his数据配置,取电子病历首页计划重返术语集(sql:  select InternalID,Description from eprmeta.glossary WHERE Description["31")
	set returnCode=##Class(DtPortal.Common.PublicService).getValueByCode("RETURNEMRCODE")
	
	//危重总数，病危数量，病重数量，危急值未响应数量，二次入院数量(31天重返)
	set criticalNum=0,criticallyNum=0,seriouslyNum=0,criticalValueNum=0,reHospNum=0
	//二次手术患者数量，院感爆发预警,在院欠费患者,住院超N天,24小时重返
	set twiceOprationNum=0,hospInfeWarningNum=0,arrearsPatNum=0,excessDaysNum=0,returnNum=0
	
	//病危医嘱ID
	set criticallyIDs=##class(DtPortal.Configure.arcim).getArcImID("CRITICALLY",1)
	
	//病重医嘱ID
	set seriouslyIDs=##class(DtPortal.Configure.arcim).getArcImID("SERIOUSLY",1)
	
	//当日危急值未响应数量
	set criticalValueNum=##class(DtPortal.Common.PublicService).GetCommonMethodNum("ClassMethod","DtPortal.MD.MD01Focus.MD0102CriticalValue","GetUndoCVNum",HospitalId)
	
	//查询在院患者
		
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
					
					
					//判断是否病危
					set isBW=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,criticallyIDs)
					set:((isBW'=-1)&&(isBW'="")) criticallyNum=criticallyNum+1,isBW="是病危"
					
					//判断是否病重
					set isBZ=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,seriouslyIDs)
					set:((isBZ'=-1)&&(isBZ'="")) seriouslyNum=seriouslyNum+1,isBZ="是病重"
					
					//危重
					set:((isBW="是病危")||(isBZ="是病重")) criticalNum=criticalNum+1
					
					set Latloc=""
					set:LastAdm'="" Latloc=$p(^PAADM(LastAdm),"^",4)  						//上次就诊科室
    														
					//二次入院数量(31天重返)只取二次住院同一科室的数据
					if ((LastAdm'="")&&(Latloc=LocID))
					{
						set lastDisDateStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(LastAdm)
						set lastDisDate=$p(lastDisDateStr,"^",1)
						set lastDisTime=$p(lastDisDateStr,"^",2)
						set reHospDay=xDate-lastDisDate			//上次住院距本次住院天数
						
						set isJihua=0
						if isReturn=2
		    			{
			    			set obj=##Class(EMRservice.BIEMRService).GetDataByGlossary(LastAdm,returnCode)
			    			set flag=obj.GetNext()
			    			set:flag="有" isJihua=1										//数值为 有 时,上次住院计划31天内重返,过滤
			    			
			    			//统计非计划
			    			if isJihua=0
			    			{
					    		//二次入院数量(31天重返)
								set:reHospDay<31 reHospNum=reHospNum+1
								
								//24小时内重返
								if reHospDay<2
								{
									set:((reHospDay=1)&&(xTime-lastDisTime<0)) returnNum=returnNum+1
									set:reHospDay=0 returnNum=returnNum+1
								}
								
					    	}
			    		}else
			    		{
				    		//统计全部二次入院
				    		//二次入院数量(31天重返)
							set:reHospDay<31 reHospNum=reHospNum+1
							
							//24小时内重返
							if reHospDay<2
							{
								set:((reHospDay=1)&&(xTime-lastDisTime<0)) returnNum=returnNum+1
								set:reHospDay=0 returnNum=returnNum+1
							}
					
				    	}
			    		
			    		
					
						
						
						
					}
					
					//二次手术
					if $d(^DHCANOPArrange(0,"Adm",EpisodeId))
					{
						set opNum=0,isY=0
						set anopid="" 
						for
						{
							set anopid=$o(^DHCANOPArrange(0,"Adm",EpisodeId,anopid))
							quit:anopid=""
							
							s stats=$P(^DHCANOPArrange(anopid),"^",27)
							
							continue:stats=""
							continue:"PLF"'[stats
							set UnPlanedOperation=$p(^DHCANOPArrange(anopid),"^",46)
							set:UnPlanedOperation="Y" isY=1
							
							set opNum=+opNum+1
				
							
						}
						
						//如果配置取非计划二次手术,重返标志是Y退出
						if isBiao=2 
						{
							set:((opNum>1)&&(isY=1)) twiceOprationNum=twiceOprationNum+1
						}else
						{
							set:(opNum>1) twiceOprationNum=twiceOprationNum+1
						}	
					}
					
					
					//在院欠费
					set ArrearsStr=##class(DtPortal.Common.PaadmService).IsArrears(EpisodeId)
					set flag=$p(ArrearsStr,"^",1)
					set:flag=1 arrearsPatNum=arrearsPatNum+1
					
					//住院超N天
					set atHosp=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
					set:atHosp>InHospN excessDaysNum=excessDaysNum+1
				}
			}
		}
	}
	
	//新院感爆发预警（当前）---cfyc
	//改为取前一天院感信息  update 程鹏 2019-03-28
	Set startDate=$zd(+$h-1,3)
	Set endDate=$zd(+$h-1,3)
	
	set objInfe=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal02:QryLocWarning")
	d objInfe.Execute(startDate,endDate,"",HospitalId)
	While (objInfe.Next()) {
		set WardID=objInfe.Data("WardID")
		continue:WardID=""
		Set hospInfeWarningNum=hospInfeWarningNum+1
	}
	
	
	d jsonObj.Put("criticalNum",criticalNum)
	d jsonObj.Put("criticallyNum",criticallyNum)
	d jsonObj.Put("seriouslyNum",seriouslyNum)
	d jsonObj.Put("criticalValueNum",criticalValueNum)
	d jsonObj.Put("reHospNum",reHospNum)
	
	d jsonObj.Put("twiceOprationNum",twiceOprationNum)
	d jsonObj.Put("hospInfeWarningNum",hospInfeWarningNum)
	d jsonObj.Put("arrearsPatNum",arrearsPatNum)
	d jsonObj.Put("excessDaysNum",excessDaysNum)
	d jsonObj.Put("returnNum",returnNum)
	

	Set ret.status = 1
	Set ret.errMSG = ""
	Set ret.data = "["_jsonObj.Json()_"]"
	
	Quit ret
		
///ErrSendMessage
	
	Set ret.status = -1
	Set ret.errMSG = $ZE
	Set ret.data = ""

	Quit ret
}

}
