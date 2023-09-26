/// 名称:  DtPortal.MD.MD01Focus.MD0104TwiceOpration
/// 描述: 查询全院当前在院患者二次手术
/// 编写者：程鹏
/// 编写日期:2018-12-19
Class DtPortal.MD.MD01Focus.MD0104TwiceOpration Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取全院各个科室二次手术数量
/// Input：      HospitalId  院区ID  
/// Return： 科室Id,科室名称,人数,
/// 服务编码：MD01.04.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0104TwiceOpration","MD010401","")
Query MD010401(HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "locID,LocDesc,num")
{
}

ClassMethod MD010401Execute(ByRef qHandle As %Binary, HospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	
 	k ^||TMPPortalMD010401
 	
 	//取his数据配置,是否取标识二次手术(1:取全部二次手术  2 取标识二次手术)
	//标识二次手术是指取在手术申请单中【重返手术】选【是】的患者信息
	set isBiao=##Class(DtPortal.Common.PublicService).getValueByCode("TWICEOPRATION")
 	
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
					
					//二次手术
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
						set:((opNum>1)&&(isY=1)) ^||TMPPortalMD010401(LocID)=$g(^||TMPPortalMD010401(LocID))+1
					}else
					{
						set:(opNum>1) ^||TMPPortalMD010401(LocID)=$g(^||TMPPortalMD010401(LocID))+1
					}	
				}
			}
		}
	}
    
		
	set locID=0
	for
	{
		set locID=$o(^||TMPPortalMD010401(locID))
		quit:locID=""
		
		set LocDesc=$p(^CTLOC(locID),"^",2)
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		set num=+$g(^||TMPPortalMD010401(locID))
		
		set Data=$lb(locID,LocDesc,num)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
	
	}
	
    
    k ^||TMPPortalMD010401
	
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-19
/// Description: 取科室二次手术患者详情
/// Input：      HospitalId  院区ID  
/// Return： 科室Id,科室名称,人数,
/// 服务编码：MD01.04.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0104TwiceOpration","MD010402",114)
Query MD010402(LocID As %String) As DtPortal.Query(ROWSPEC = "ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,opNum,opName1,opName2,opDateTime1,opDateTime2,EpisodeId,OpNameAndTime1,OpNameAndTime2")
{
}

ClassMethod MD010402Execute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 		
 	//取his数据配置,是否取标识二次手术(1:取全部二次手术  2 取标识二次手术)
	//标识二次手术是指取在手术申请单中【重返手术】选【是】的患者信息
	set isBiao=##Class(DtPortal.Common.PublicService).getValueByCode("TWICEOPRATION")
  
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
				
				//二次手术
				set opNum=0,opIDStr="",isY=0,BSOpID=""
				set anopid="" 
				for
				{
					set anopid=$o(^DHCANOPArrange(0,"Adm",EpisodeId,anopid))
					quit:anopid=""
					
					s stats=$P(^DHCANOPArrange(anopid),"^",27)
					continue:stats=""
					continue:"PLF"'[stats
					set UnPlanedOperation=$p(^DHCANOPArrange(anopid),"^",46)
					
					if UnPlanedOperation="Y" 
					{
						set isY=1
						set:BSOpID'="" BSOpID=BSOpID_"^"_anopid
						set:BSOpID="" BSOpID=anopid
						
					}
					
					
					set:opIDStr'="" opIDStr=opIDStr_"^"_anopid
					set:opIDStr="" opIDStr=anopid
					set opNum=+opNum+1
					
				}
				//如果配置取非计划二次手术,重返标志是Y退出
				if isBiao=2 
				{
					if ((opNum>1)&&(isY=1)) d TwiceOprationPat
				}else
				{
					if (opNum>1) d TwiceOprationPat
				}	
				
				
				
			}
		}
	}
	
  	q $$$OK
  
TwiceOprationPat
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
	set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)				//诊断
	set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)						//在院天数
    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)					//就诊日期
    set inDate=$p(inTimeStr,"^",1)
    set inDate=$zd(inDate,3)
    set inTime=$p(inTimeStr,"^",2)
    set inTime=$zt(inTime,2)
    set inDateTime=inDate_"&nbsp;"_inTime
    
    set opID1=$p(opIDStr,"^",1)
    //取手术信息
    set OpNameAndTime1="",OpNameAndTime2=""
    set OPInfo1=##class(DtPortal.Common.Interface.Operation).GetOPInfo(opID1)
	set opName1=$p(OPInfo1,"^",1)
	set opDate1=$p(OPInfo1,"^",2)
	set opTime1=$p(OPInfo1,"^",3)
	
	set bStr="^"_BSOpID_"^"		
	set:(bStr[("^"_opID1_"^")) opName1=opName1_"(重返标志)"
	
	set:opDate1'="" opDate1=$zd(opDate1,3)
	set:opTime1'="" opTime1=$zt(opTime1,2)
	set opDateTime1=opDate1_"&nbsp;"_opTime1
	set OpNameAndTime1=opName1_"("_opDateTime1_")"
										
    set opName2="",opDateTime2=""	//第二次手术名称,多次手术拼在一起
    
   															
    for index=2:1:$l(opIDStr,"^")
    {
	    set opIDN=$p(opIDStr,"^",index)
	    set OPInfoN=##class(DtPortal.Common.Interface.Operation).GetOPInfo(opIDN)
		set opNameN=$p(OPInfoN,"^",1)
		set opDateN=$p(OPInfoN,"^",2)
		set opTimeN=$p(OPInfoN,"^",3)
		
		set:(bStr[("^"_opIDN_"^")) opNameN=opNameN_"(重返标志)"
		
		set:opDateN'="" opDateN=$zd(opDateN,3)
		set:opTimeN'="" opTimeN=$zt(opTimeN,2)
		set opDateTimeN=opDateN_"&nbsp;"_opTimeN
		
	    set:opName2'="" opName2=opName2_"<br/>"_opNameN,opDateTime2=opDateTime2_"<br/>"_opDateTimeN
		set:opName2="" opName2=opNameN,opDateTime2=opDateTimeN		//第二次手术日期时间
		
		if (OpNameAndTime2=""){
			set OpNameAndTime2="<span class=""marginR10"">"_opNameN_"("_opDateTimeN_")"_"</span>"
		}else{
			set OpNameAndTime2=OpNameAndTime2_"<span class=""marginR10"">"_opNameN_"("_opDateTimeN_")"_"</span>"
		}
		
	}
	
	
    set Data=$lb(ind,bedCode,name,sex,age,medicareNo,admReason,regNo,nurseDesc,docDesc,locDesc,wardDesc,diagnoseDesc,inDay,inDateTime,opNum,opName1,opName2,opDateTime1,opDateTime2,EpisodeId,OpNameAndTime1,OpNameAndTime2)
 	set ^||CacheTemp(repid,ind)=Data	
 	set ind=ind+1
}

}
