/// 名称:DtPortal.MD.MD23HospitalMonitor
/// 描述:住院监控的服务
/// 编写者：白明哲
/// 编写日期: 2015-11-23
Class DtPortal.MD.MD23HospitalMonitor Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 白明哲
/// CreatDate： 2015-11-26
/// Description:按楼查询病区的床位数
/// Input： 无 
/// Return： 楼id、床位数 
/// 服务代码：MD2301.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findBedNumByBuilding","23301#1^2^17^15^18^14^6^53^46^19^13^16")
Query findBedNumByBuilding(buildingInfo As %String) As DtPortal.Query(ROWSPEC = "id:%String,bedNum:%String")
{
}

ClassMethod findBedNumByBuildingExecute(ByRef qHandle As %Binary, buildingInfo As %String) As %Status
{
	New (qHandle,buildingInfo)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;1#6^10^15*2#14^16^9^25
	
	s length=$l(buildingInfo,"*")
	
	f i=1:1:length d
	.s pamaInfo=$p(buildingInfo,"*",i)
	.s buildingId=$p(pamaInfo,"#",1)
	.q:+buildingId=0
	.s wardStr=$p(pamaInfo,"#",2)
	.s wardLen=$l(wardStr,"^")
	.s bedNumById=0
	.f j=1:1:wardLen d
	..s wardId=$p(wardStr,"^",j)
	..q:+wardId=0
	..s bedNumTemp=##class(DtPortal.MD.MD23CommonService).getBedNumByWardId(wardId)
	..s bedNumTemp=$p(bedNumTemp,"^")
	..s bedNumById=bedNumById+bedNumTemp
	.s bedNum=bedNumById
	.s id=buildingId
	.d BedNumByBuilding
	
	
	
	q $$$OK
	

  
BedNumByBuilding
    s Data=$lb(id,bedNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-26
/// Description:按楼取当前在院、昨日在院、今日出院等的病人数量
/// Input： 无 
/// Return： 楼id、床位数
/// 服务代码：MD2301.01.02  id；inHosNum；YinHosNum；outHosNum
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findPatByBuilding","36775#106^33^19^27^26^61^30^17^58^37^22^62^38^65^63^66^60^10^132*36776#59^56^55^16^9^29^7^42^15^43^44^46^24^13^39^40^1^2^57^45*36857#32^75^31^34^35^47^6*36858#49^50^51^54^118^119^120^121")
Query findPatByBuilding(buildingInfo As %String) As DtPortal.Query(ROWSPEC = "id:%String,inHosNum:%String,YinHosNum:%String,outHosNum:%String,tHosPatNum:%String,arrearsPatNum:%String,deadPatNum:%String,speciaNurNum:%String,reOpeNum:%String,rescuePatNum:%String,criticalPatNum:%String,criPatNum:%String,seriousPatNum:%String")
{
}

ClassMethod findPatByBuildingExecute(ByRef qHandle As %Binary, buildingInfo As %String) As %Status
{
	New (qHandle,buildingInfo)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//配置死亡患者查询天数
	s deadDays=+##Class(DtPortal.Common.PublicService).getValueByCode("DEADPATDAYS")
	
	;s ^testTemp("88")=buildingInfo
	//1-特级护理 2-抢救 3-病危 4-病重
	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID("CRITICALCARE^RESCUE^CRITICALLY^SERIOUSLY",1)
	
	
	s length=$l(buildingInfo,"*")
	
	f i=1:1:length d
	.s pamaInfo=$p(buildingInfo,"*",i)
	.s buildingId=$p(pamaInfo,"#",1)
	.q:+buildingId=0
	.s wardStr=$p(pamaInfo,"#",2)
	.s wardLen=$l(wardStr,"^")
	.;今日在院，昨日在院，今日出院，本院病人
	.s inpatientNum=0,yesInpatientNum=0,dischargeNum=0,tHosPatNum=0
	.;欠费患者，死亡患者，特级护理，再次手术，抢救患者，危重患者,病危患者，病重患者
	.s arrearsPatNum=0,deadPatNum=0,speciaNurNum=0,reOpeNum=0,rescuePatNum=0,criticalPatNum=0,criPatNum=0,seriousPatNum=0
	.f j=1:1:wardLen d
	..s wardId=$p(wardStr,"^",j)
	..s inpatientNumTemp=##class(DtPortal.MD.MD23CommonService).getPatNumByWardId(wardId)
	..s yesInpatientNumTemp=##class(DtPortal.MD.MD23CommonService).getYesPatNumByWardId(wardId)
	..s dischargeNumTemp=##class(DtPortal.MD.MD23CommonService).getDisPatNumByWardId(wardId)
	..s inpatientNum=inpatientNum+inpatientNumTemp
	..s yesInpatientNum=yesInpatientNum+yesInpatientNumTemp
	..s dischargeNum=dischargeNum+dischargeNumTemp
	..;死亡患者数量
	..s deadPatNumStr=##class(DtPortal.MD.MD23CommonService).getDeadNumByWardId(wardId,+$h-deadDays,+$h)  //死亡人数按配置查询
	..s deadPatNum1=$p(deadPatNumStr,"#",1)
	..s deadPatNum=deadPatNum+deadPatNum1
	..;遍历就诊id--获取病区就诊ID串
	..s admIDStr=##Class(DtPortal.Common.PaadmService).getAdmIDStrByWardID(wardId)
	..Set inNum=$l(admIDStr,"^")
	..f inNumIndex=1:1:inNum d
	...s episodeId=""
	...s episodeId=$p(admIDStr,"^",inNumIndex)
	...q:episodeId=""
    ...;本院患者数量
    ...s AdmReasonDr=$P($g(^PAADM(episodeId)),"^",73)  //取费用类别--就诊类别？用于判断本院
    ...s AdmReason=""
	...Set AdmReasonDr=$P($g(^PAADM(episodeId,1)),"^",7)
	...If AdmReasonDr'="" Set AdmReason=$P($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	...i (AdmReason'="")&&(AdmReason["本院") d
	....s tHosPatNum=tHosPatNum+1   
	...;欠费患者数量
	...i ##class(DtPortal.MD.MD23CommonService).ifQFPat(episodeId)="Y" s arrearsPatNum=arrearsPatNum+1   //欠费
	
	...;b ;1
	...;死亡患者数量
	...;i ##class(DtPortal.MD.MD23CommonService).ifPatDead(episodeId)=1 s deadPatNum=deadPatNum+1
	...set ArcNums=##class(DtPortal.Common.PaadmService).getArcNums(episodeId,arcimIDs)
	...;特级护理
	...s speciaNurNum=speciaNurNum+$p(ArcNums,"^",1)
	...;i ##class(DtPortal.MD.MD23CommonService).ifSpecialNur(episodeId)=1 s speciaNurNum=speciaNurNum+1
	...;再次手术
	...i ##class(DtPortal.MD.MD23CommonService).ifReOpeByAdm(episodeId)=1 s reOpeNum=reOpeNum+1
	...;抢救患者
	...s rescuePatNum=rescuePatNum+$p(ArcNums,"^",2)
	...;i ##class(DtPortal.MD.MD23CommonService).ifRescuePat(episodeId)=1 s rescuePatNum=rescuePatNum+1
	...;危重患者
	...;i ##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId)=1 s criticalPatNum=criticalPatNum+1
	...i ($p(ArcNums,"^",3)=1)&&($p(ArcNums,"^",4)=1) s criticalPatNum=criticalPatNum+1
	...e  s criticalPatNum=criticalPatNum+$p(ArcNums,"^",3)+$p(ArcNums,"^",4)
	...;病危患者
	...s criPatNum=criPatNum+$p(ArcNums,"^",3)
	...;病重患者
	...s seriousPatNum=seriousPatNum+$p(ArcNums,"^",4)
	.s id=buildingId
	.d PatByBuilding
	
	q $$$OK
	
PatByBuilding
    s Data=$lb(id,inpatientNum,yesInpatientNum,dischargeNum,tHosPatNum,arrearsPatNum,deadPatNum,speciaNurNum,reOpeNum,rescuePatNum,criticalPatNum,criPatNum,seriousPatNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-26
/// Description:按病区串和类型查询患者信息
/// Input： 无 
/// Return： 病区串、类型
/// 服务代码：MD2301.01.03  
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findPatInfoByType","106^33^19^27^26^61^30^17^58^37^22^62^38^65^63^66^60^10^132","9")
Query findPatInfoByType(wardIdStr As %String, pType As %String) As DtPortal.Query(ROWSPEC = "bedNo,medicareNo,name,sex,age,admReason,episodeID,patientID,inTime,diagnosis,locName,wardName,managerDoc,aReason,disdiag,deceasedDateTime,deadSummary,nurseLevel,wardId")
{
}

ClassMethod findPatInfoByTypeExecute(ByRef qHandle As %Binary, wardIdStr As %String, pType As %String) As %Status
{
	New (qHandle,wardIdStr,pType)
	;s ^testTemp("findPatInfoByType")=wardIdStr_"&"_pType
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i (wardIdStr="")||(pType="") q $$$OK
	;1、当前在院  2,今天出院  3,本院：4,欠费  5,死亡患者
	;6、特级护理  7 再次手术  8、抢救  9、危重
	
	
	//配置死亡患者查询天数
	s deadDays=+##Class(DtPortal.Common.PublicService).getValueByCode("DEADPATDAYS")
	
	s length=$l(wardIdStr,"^")
	
	f i=1:1:length d
	.s wardId=$p(wardIdStr,"^",i)
	.q:+wardId=0
	.i pType'="5" d  //死亡患者特殊取值
	..;遍历就诊id--获取病区就诊ID串
	..s admIDStr=##Class(DtPortal.Common.PaadmService).getAdmIDStrByWardID(wardId)
	..Set inNum=$l(admIDStr,"^")
	..f inNumIndex=1:1:inNum d
	...s episodeId=""
	...s episodeId=$p(admIDStr,"^",inNumIndex)
	...q:episodeId=""
    ...;今日出院
    ...q:(pType=2)&&(##class(DtPortal.MD.MD23CommonService).ifTOutHosNum(episodeId)=0)
    ...;本院患者
	...q:(pType=3)&&(##class(DtPortal.MD.MD23CommonService).ifTHosPat(episodeId)=0)   ;过滤非本院
	...s QFflag=0
	...i pType=4 d
	....;s arrPatStr=##class(DtPortal.MD.MD23CommonService).UDHCJFGetQFPatDetailByEpisodeId(episodeId)
	....;s arrPatStr=##class(web.ConCurrBillAmtRecord).GetCBAAmtInfoByAdm(episodeId)
	....;s QFflag=$p(arrPatStr,"^",1)
	...q:(pType=4)&&(QFflag'="Y")
	...;死亡患者
	...;q:(pType=5)&&(##class(DtPortal.MD.MD23CommonService).ifPatDead(episodeId)=0)
	...;特级护理
	...q:(pType=6)&&(##class(DtPortal.MD.MD23CommonService).ifSpecialNur(episodeId)=0)
	...;再次手术
	...q:(pType=7)&&(##class(DtPortal.MD.MD23CommonService).ifReOpeByAdm(episodeId)=0)
	...;抢救
	...q:(pType=8)&&(##class(DtPortal.MD.MD23CommonService).ifRescuePat(episodeId)=0)
	...;危重
	...q:(pType=9)&&(##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"all")=0)
	...;病危
	...q:(pType="c")&&(##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"c")=0)
	...;病重
	...q:(pType="s")&&(##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"s")=0)
	...d getPatInfo
	
	
	...;取危重患者字段
	...s nurseLevel=""
	...i (pType=9)||(pType="c")||(pType="s") d
	....s nurseLevel=##class(DtPortal.MD.MD23CommonService).getPatNurseLevel(episodeId)
	...d PatInfoByType
	
	.e  d
	..s deadPatNumStr=##class(DtPortal.MD.MD23CommonService).getDeadNumByWardId(wardId,+$h-deadDays,+$h)  //死亡人数按配置查询
	..s episodeIdStr=$p(deadPatNumStr,"#",2)
	..q:episodeIdStr=""
	..s num=$l(episodeIdStr,"^")
	..f j=1:1:num d
	...s episodeId=$p(episodeIdStr,"^",j)
	...;s patinfo=##Class(DtPortal.Common.PaadmService).GetPatInfo(episodeId)
	...s patWardId=$p(^PAADM(episodeId),"^",70)
	...i (patWardId'="")&&(patWardId=wardId) d
	....;w !,patinfo_"*"_deadNum
	....;取病人信息
	....d getPatInfo
	....;取死亡患者的字段AReason_"^"_Disdiag_"^"_DeceasedDateTime_"^"_deadSummary
	....s aReason="",disdiag="",deceasedDateTime="",deadSummary=""
	
	....;先从报告中取死亡时间,没有取到再从按之前的方式取   by cfyc 20170824
	....s PatId=$P($g(^PAADM(episodeId)),"^",1)
	....q:PatId=""  
	....s deadReportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(episodeId)
	....s deadReportID=$p(deadReportStr,"^",1)
	....s DeathDate=""
	....i +deadReportID>0 d
	.....s DeathDate=$p(deadReportStr,"^",2)
	.....s DeathTime=$p(deadReportStr,"^",3)
	.....s aReason=$p(deadReportStr,"^",4)
	
	....i DeathDate="" d
	.....s DeathDate=$p(^PAPER(PatId,"ALL"),"^",13)
	.....s DeathTime=$p(^PAPER(PatId,"ALL"),"^",8)
	....i (DeathDate'=""&&DeathDate'["-") d
	.....s DeathDate=$zd(DeathDate,3)
	.....s DeathTime=$zt(DeathTime)
	....s deceasedDateTime=DeathDate_"&nbsp;"_DeathTime
	....s deadSummary=##class(DtPortal.Common.PaadmService).getDeadPatSummary(episodeId)  //死亡小结
	....s disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(episodeId)   //出院诊断
	....d PatInfoByType
	
	
	q $$$OK


getPatInfo
	;取病人信息
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(episodeId)
	s bedNo=$p(patInfoStr,"^",1)
	s medicareNo=$p(patInfoStr,"^",5)
	s name=$p(patInfoStr,"^",2)
	s sex=$p(patInfoStr,"^",3)
	s age=$p(patInfoStr,"^",4)
	s admReason=$p(patInfoStr,"^",6)
	s patId=$P($g(^PAADM(episodeId)),"^",1)
	s inTime="" //入科时间--分床时间  by cfyc20170306
	s inDateTimeStr=##class(web.DHCDischargeHistory).GetAdminDateTime(episodeId)
	;s TRANSId=$o(^PAADM(episodeId,"TRANS",0)) 
	;i TRANSId'="" d
	s inTime=$p(inDateTimeStr,"^",2)
	s inDate=$p(inDateTimeStr,"^",1)
	i inDate'="" s inDate=$zd(inDate,3)
	i inTime'="" s inTime=$zt(inTime,2)
	s inTime=inDate_"&nbsp;"_inTime   //加空格，用于前台显示
	s diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(episodeId)  //取诊断
	s locName="" //取科室描述
	s locId=$p(^PAADM(episodeId),"^",4)
	i locId'="" d
	s locName=$p(^CTLOC(locId),"^",2)
	i locName["-" s locName=$p(locName,"-",2)
	s wardName="" //取病区描述
	s wardId=$p(^PAADM(episodeId),"^",70)
	s wardName=$p(^PAWARD(wardId),"^",2)
	i wardName["-" s wardName=$p(wardName,"-",2)
	s managerDoc=""   //主管医生
	s DocDr=$P($g(^PAADM(episodeId)),"^",9)
	s managerDoc=""
	i DocDr'="" s managerDoc=$p(^CTPCP(DocDr,1),"^",2)
	q

PatInfoByType
    s Data=$lb(bedNo,medicareNo,name,sex,age,admReason,episodeId,patId,inTime,diagnosis,locName,wardName,managerDoc,aReason,disdiag,deceasedDateTime,deadSummary,nurseLevel,wardId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-26
/// Description:按病区串查询病区的信息
/// Input： 无 
/// Return： 楼id、床位数
/// 服务代码：MD2301.02.01  id；inHosNum；YinHosNum；outHosNum
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findWardInfoByWardStr","6^10^15^14^16^9^25")
Query findWardInfoByWardStr(wardStr As %String) As DtPortal.Query(ROWSPEC = "wardId:%String,name:%String,inHosNum:%String,yInHosNum:%String,deadNum:%String,exceed30:%String,bedNum:%String,bedPatNum:%String")
{
}

ClassMethod findWardInfoByWardStrExecute(ByRef qHandle As %Binary, wardStr As %String) As %Status
{
	New (qHandle,wardStr)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	q:wardStr="" ""
	s length=$l(wardStr,"^")
	f i=1:1:length d
	.s wardId=$p(wardStr,"^",i)
	.q:+wardId=0
	.s name=$p(^PAWARD(wardId),"^",2)
	.i name["-" s name=$p(name,"-",2)
	.s inHosNum=0
	.s yInHosNum=##class(DtPortal.MD.MD23CommonService).getYesPatNumByWardId(wardId)  //昨日在院
	.s deadNum=0  //by cfyc
	.s bedPatNum=0
	.s exceed30=0  ;超过30天入院
	.s bedNumStr=##class(DtPortal.MD.MD23CommonService).getBedNumByWardId(wardId) //床位数
	.s bedNum=$p(bedNumStr,"^")
	.s bedPatNum=$p(bedNumStr,"^",2)
	
	.set bedId=0
	.for  set bedId=$o(^PAWARD(wardId,"BED",bedId)) q:bedId=""  d
	.;遍历就诊id--获取病区就诊ID串
	.s admIDStr=##Class(DtPortal.Common.PaadmService).getAdmIDStrByWardID(wardId)
	.Set inNum=$l(admIDStr,"^")
	.f inNumIndex=1:1:inNum d
	..s EpisodeId=$p(admIDStr,"^",inNumIndex)
	..q:EpisodeId=""
	
    ..s deadPatFlag=##class(DtPortal.MD.MD23CommonService).ifPatDead(EpisodeId)  //by cfyc 1116
	..i deadPatFlag=1 s deadNum=deadNum+1                                        //by cfyc
    ..s patVisit=$p($g(^PAADM(EpisodeId)),"^",20)     
    ..s inHosNum=inHosNum+1
    ..;判断住院天数
    ..s InDay=0
    ..s PAAdmDate=$ZD($P($g(^PAADM(EpisodeId)),"^",6),3)
	..;s:PAAdmDate'="" InDay=+$h-$zdh(PAAdmDate,3)+1     //取住院天数原方法，现在使用公共方法，如下行  by cfyc20180302
	..s InDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
	..q:InDay<30   ;取住院大于等于30天的
	..s exceed30=exceed30+1
	.d WardInfoByWardStr
	
	q $$$OK
	
WardInfoByWardStr
    s Data=$lb(wardId,name,inHosNum,yInHosNum,deadNum,exceed30,bedNum,bedPatNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-28
/// Description:通过病区id查询床位信息
/// Input： 无 
/// Return： 
/// 服务代码：MD2301.03.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findBedInfoByWardId","10")
Query findBedInfoByWardId(wardId As %String = "") As DtPortal.Query(ROWSPEC = "wardId:%String,bedId:%String,bedCode:%String,ifBaoChuang:%String,patName:%String,bedAppInfo:%String")
{
}

ClassMethod findBedInfoByWardIdExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	New (qHandle,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind1=1
	
	q:wardId="" ""
	
	s bedIdStr=##class(DtPortal.Common.PublicService).getBedIDStrByWardID(wardId,2)
	q:bedIdStr="" ""
	s bedNum=$l(bedIdStr,"^")
	for i=1:1:bedNum {
		s bedId=$p(bedIdStr,"^",i)
		continue:bedId=""
		s bedChild=$p(bedId,"||",2)
		s bedCode=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",1)
		s bedAvailable=$$CO18^at153(bedId)
		s ifBaoChuang=##class(DtPortal.Common.PublicService).ifBaoChuang(bedId)
		
		
		s patName=""
		if (ifBaoChuang'=0){
			s patName=##class(web.DHCSETIMAGE).FindStatPat(wardId_"||"_bedChild) //新增包床患者显示
		}
		
		//床位预约信息
		s bedAppInfo=##Class(Nur.NIS.Service.Base.Bed).GetBedAppedInfo(wardId_"||"_bedChild)
		s bedAppInfo=##class(Nur.NIS.Common.JSON).Encode(bedAppInfo)
		
		d BedInfoByWardStr
	
	}
	
	q $$$OK
	

  
BedInfoByWardStr
    s Data=$lb(wardId,bedChild,bedCode,ifBaoChuang,patName,bedAppInfo)
 	s ^||CacheTemp(repid,ind1)=Data	
 	s ind1=ind1+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-28
/// Description:通过病区id查询病人信息
/// Input： 无 
/// Return： 
/// 服务代码：MD2301.03.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findPatInfoByWardId","10")
Query findPatInfoByWardId(wardId As %String = "") As DtPortal.Query(ROWSPEC = "bedId,wardId,bedCode,episodeID,patientID,patName,sex,age,inHosNum,diagnosis,speciaNur,infectionGra,opeAfter,deadPat,tHosPat,arrearsPat,criticalPat,criPat,seriousPat,reOpe,rescuePat,loc,medicareNo")
{
}

ClassMethod findPatInfoByWardIdExecute(ByRef qHandle As %Binary, wardId As %String = "") As %Status
{
	New (qHandle,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	q:wardId="" ""
	
	/*
	;遍历就诊id--获取病区就诊ID串
	s admIDStr=##Class(DtPortal.Common.PaadmService).getAdmIDStrByWardID(wardId)
	Set inNum=$l(admIDStr,"^")
	f inNumIndex=1:1:inNum d
	.s episodeId=$p(admIDStr,"^",inNumIndex)
	.q:episodeId=""
	*/
	
	
	s bedIdStr=##class(DtPortal.Common.PublicService).getBedIDStrByWardID(wardId,2)
	s bedLength=$l(bedIdStr,"^")
	f bedIndex=1:1:bedLength d
	.s bedId=$p(bedIdStr,"^",bedIndex)
	.q:bedId=""
	.s bedChild=$p(bedId,"||",2)
	.s isValidBed=##class(DtPortal.Common.PublicService).isValidBed(bedId)
	.q:isValidBed'=1
	.;根据床位查找到患者
	.s currId=$o(^PAWARDA($p(bedId,"||",1),"BED",bedChild,"ADM",0))  
	.q:currId=""
	.s episodeId=$p($g(^PAWARDA($p(bedId,"||",1),"BED",bedChild,"ADM",currId)),"^",1)
	
	
	
	.s bedId=$P($g(^PAADM(episodeId)),"^",73)
    .s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(episodeId)
    .s bedId=$P($g(^PAADM(episodeId)),"^",73)
    .s bedChild=$p(bedId,"||",2)
    .s patientID=$P($g(^PAADM(episodeId)),"^",1)
    .s bedCode=$p(patInfoStr,"^",1)
    .s patName=$p(patInfoStr,"^",2)
    .s sex=$p(patInfoStr,"^",3)
    .s age=$p(patInfoStr,"^",4)
    .s medicareNo=$p(patInfoStr,"^",5)
    .s locId=$p(^PAADM(episodeId),"^",4)
	.s loc=$p(^CTLOC(locId),"^",2)
	.i loc["-" s loc=$p(loc,"-",2)   //就诊科室
	.s inHosNum=0   //住院天数
	.s inDateTimeStr=##class(web.DHCDischargeHistory).GetAdminDateTime(episodeId)
	.s InDate=$p(inDateTimeStr,"^",1)
	.;i InDate'="" s inHosNum=+$h-$zdh($zd(InDate,3),3)  //by cfyc20170306
	.s inHosNum=##class(DtPortal.Common.PaadmService).getInDayByInPat(episodeId)  //bmz20170810 在院患者在院天数取公共方法
	.s diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(episodeId)  //取诊断
	.s deadPat="N"
	.s deadPatFlag=##class(DtPortal.MD.MD23CommonService).ifPatDead(episodeId)
	.i deadPatFlag=1 s deadPat="Y" 
	.;i deadPat="Y" d PatInfoByWardId   //死亡病人不判断特级护理、是否感染等
	.;e  d
	.s speciaNur="N"  //--需要根据床位图--是否特级护理
	.s speciaNurFlag=##class(DtPortal.MD.MD23CommonService).ifSpecialNur(episodeId)
	.i speciaNurFlag=1 s speciaNur="Y"
	
	.s infectionGra="N"  //感染类别--取的医政数据
	.;s infectionGraDesc=##class(DHCMed.EPDService.InfectionSrv).GetstrMDR(episodeId)  by cfyc 1026
	.;i infectionGraDesc'="" s infectionGra="Y"
	
	.s opeAfter="N"  //是否术后--已完成手术的患者---手麻组根据就诊id判断是否完成手术患者
	.i ##class(DtPortal.MD.MD23CommonService).ifOpeAfterByAdm(episodeId)=1 s opeAfter="Y"
	
    .s tHosPat="N"  //本院患者----就诊费别包括本院
    .s AdmReasonDr=$P($g(^PAADM(episodeId)),"^",73)  //取费用类别--就诊类别？用于判断本院
    .s AdmReason=""
	.Set AdmReasonDr=$P($g(^PAADM(episodeId,1)),"^",7)
	.If AdmReasonDr'="" Set AdmReason=$P($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	.i (AdmReason'="")&&(AdmReason["本院") s tHosPat="Y"  
    
    .s arrearsPat=##class(DtPortal.MD.MD23CommonService).ifQFPat(episodeId)  //欠费患者
    .s criticalPat="N"   //是否危重患者--需要根据床位图
	.s criticalFlag=##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"all")
	.i criticalFlag=1 s criticalPat="Y"
	
	.s criPat="N"   //是否病危患者--需要根据床位图
	.s criFlag=##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"c")
	.i criFlag=1 s criPat="Y"
	
	.s seriousPat="N"   //是否病重患者--需要根据床位图
	.s seriousFlag=##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"s")
	.i seriousFlag=1 s seriousPat="Y"
	
    .s reOpe="N"    //再次手术--取手麻组global数据
    .i ##class(DtPortal.MD.MD23CommonService).ifReOpeByAdm(episodeId)=1 s reOpe="Y"
	.s rescuePat="N"  //抢救患者---需要根据床位图
	.i ##class(DtPortal.MD.MD23CommonService).ifRescuePat(episodeId)=1 s rescuePat="Y"
	.;b ;1
	.d PatInfoByWardId

	q $$$OK
	

  
PatInfoByWardId
    s Data=$lb(bedChild,wardId,bedCode,episodeId,patientID,patName,sex,age,inHosNum,diagnosis,speciaNur,infectionGra,opeAfter,deadPat,tHosPat,arrearsPat,criticalPat,criPat,seriousPat,reOpe,rescuePat,loc,medicareNo)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-26
/// Description:查询所有病区的不同类型的数量
/// Input： 无 
/// Return： 患者类型、数量
/// 服务代码：MD2302.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findPatTypeNumByWard","8^38^19^20^21^5^13^1^2^3^9^11^12^53^55^28^29^30^31^32^42^43^44^45^15^16^")
Query findPatTypeNumByWard(wardIdStr As %String = "") As DtPortal.Query(ROWSPEC = "wardId,wardName,emptyBedNum,speciaNurNum,deadPatNum,tHosPatNum,arrearsPatNum,criticalPatNum,criPatNum,seriousPatNum,rescuePatNum,reOpeNum,primaryNurNum,twoNurNum,threeNurNum,emrNum")
{
}

ClassMethod findPatTypeNumByWardExecute(ByRef qHandle As %Binary, wardIdStr As %String = "") As %Status
{
	New (qHandle,wardIdStr)
	;s ^testTemp("1")=wardIdStr
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:wardIdStr="" ""
	 
	//1-特级护理  2-一级护理  3-二级护理  4-三级护理  5、6-危重患者（病重、病危）  7-抢救
	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID("CRITICALCARE^FIRSTCLSCARE^SECONDCLSCARE^THIRDCLSCARE^SERIOUSLY^CRITICALLY^RESCUE",1)
	s length=$l(wardIdStr,"^")
	f i=1:1:length d
	.s wardId=$p(wardIdStr,"^",i)
	.;q:wardId'=20  //测试
	.q:+wardId=0
	.s (emptyBedNum,speciaNurNum,deadPatNum,tHosPatNum,arrearsPatNum,criticalPatNum,criPatNum,seriousPatNum,rescuePatNum,reOpeNum,primaryNurNum,twoNurNum,threeNurNum,emrNum)=0
	
	.s bedIdStr=##class(DtPortal.Common.PublicService).getBedIDStrByWardID(wardId,2)
	.s bedLength=$l(bedIdStr,"^")
	.f bedIndex=1:1:bedLength d
	..s bedId=$p(bedIdStr,"^",bedIndex)
	..q:bedId=""
	..s bedChild=$p(bedId,"||",2)
	..s isValidBed=##class(DtPortal.Common.PublicService).isValidBed(bedId)
	..q:isValidBed'=1
	..;根据床位查找到患者
	..s currId=$o(^PAWARDA($p(bedId,"||",1),"BED",bedChild,"ADM",0))  
	..s episodeId=0
	..i currId'="" s episodeId=$p($g(^PAWARDA($p(bedId,"||",1),"BED",bedChild,"ADM",currId)),"^",1)
	..i +episodeId'=0 d GetPatTypeNumByAdm
	..s bedAvailable=$$CO18^at153(wardId_"||"_bedChild)  //取床位是否可用
	..s baoFlag=0
	..s baoFlag=##class(DtPortal.Common.PublicService).ifBaoChuang(wardId_"||"_bedChild)
	..q:((bedAvailable'="Y")||(baoFlag'=0))  //过滤床位被用和判断是否包床
	..s emptyBedNum=emptyBedNum+1  //空床数
	.s wardName=$p($g(^PAWARD(wardId)),"^",2)
	.i wardName["-" s wardName=$p(wardName,"-",2)
	.d PatTypeNumByWard
	
	q $$$OK
	
GetPatTypeNumByAdm
	set ArcNums=##class(DtPortal.Common.PaadmService).getArcNums(episodeId,arcimIDs)
	;特级护理
	s speciaNurNum=speciaNurNum+$p(ArcNums,"^",1)
	;一级护理 add by zl
	s primaryNurNum=primaryNurNum+$p(ArcNums,"^",2)
	;二级护理 add by zl
	s twoNurNum=twoNurNum+$p(ArcNums,"^",3)
	;三级护理 add by zl
	s threeNurNum=threeNurNum+$p(ArcNums,"^",4)
	;急症转住院 add by zl
	i ##class(DtPortal.MD.MD23CommonService).ifEmergency(episodeId)=1 s emrNum=emrNum+1
	;死亡患者
	i ##class(DtPortal.MD.MD23CommonService).ifPatDead(episodeId)=1  d
	.s deadPatNum=deadPatNum+1
	;本院患者
	i ##class(DtPortal.MD.MD23CommonService).ifTHosPat(episodeId)=1 s tHosPatNum=tHosPatNum+1
	;欠费患者--
	i ##class(DtPortal.MD.MD23CommonService).ifQFPat(episodeId)="Y" d
	.s arrearsPatNum=arrearsPatNum+1
	
	;危重   判断了同时是病危、病重的情况
	i ($p(ArcNums,"^",5)=1)&&($p(ArcNums,"^",6)=1) s criticalPatNum=criticalPatNum+1
	e  s criticalPatNum=criticalPatNum+$p(ArcNums,"^",5)+$p(ArcNums,"^",6)
	;病危
	s criPatNum=criPatNum+$p(ArcNums,"^",6)
	;病重
	s seriousPatNum=seriousPatNum+$p(ArcNums,"^",5)
	;抢救
	s rescuePatNum=rescuePatNum+$p(ArcNums,"^",7)
	;再次手术
	i ##class(DtPortal.MD.MD23CommonService).ifReOpeByAdm(episodeId)=1 s reOpeNum=reOpeNum+1
	
	q
	
PatTypeNumByWard
    s Data=$lb(wardId,wardName,emptyBedNum,speciaNurNum,deadPatNum,tHosPatNum,arrearsPatNum,criticalPatNum,criPatNum,seriousPatNum,rescuePatNum,reOpeNum,primaryNurNum,twoNurNum,threeNurNum,emrNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-26
/// Description:按类型和病区串检索床位信息
/// Input： 无 
/// Return： 患者类型、数量
/// 服务代码：MD2302.01.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findPatBedInfoByType","1","18^19^20^21^5^13^1^2^3^9^11^12^53^55^28^29^30^31^32^")
Query findPatBedInfoByType(pType As %String = "", wardIdStr As %String = "") As DtPortal.Query(ROWSPEC = "wardId,wardName,bedName,bedId,ifEmpty")
{
}

ClassMethod findPatBedInfoByTypeExecute(ByRef qHandle As %Binary, pType As %String = "", wardIdStr As %String = "") As %Status
{
	New (qHandle,pType,wardIdStr)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:(wardIdStr="")||(pType="") ""
	s length=$l(wardIdStr,"^")
	
	;s startTime=$p($h,",",2)
	s ifEmpty="false"
	if (pType=0)||(pType=1){
		
		s wardId=0
		f i=1:1:length d
		.s wardId=$p(wardIdStr,"^",i)
		.q:+wardId=0
		.s wardName=$p(^PAWARD(wardId),"^",2)
		.i wardName["-" s wardName=$p(wardName,"-",2)
		.s ifHasBed=0   //该病区是否有床
		.s bedIdStr=##class(DtPortal.Common.PublicService).getBedIDStrByWardID(wardId,2)
		.s bedLength=$l(bedIdStr,"^")
		.f bedIndex=1:1:bedLength d
		..s bedId=$p(bedIdStr,"^",bedIndex)
		..q:bedId=""
		..s bedChild=$p(bedId,"||",2)
		..s bedAvailable=$$CO18^at153(wardId_"||"_bedChild)  //取床位是否可用
		..s baoFlag=0
		..s baoFlag=##class(DtPortal.Common.PublicService).ifBaoChuang(wardId_"||"_bedChild)
		..s ifEmpty=""
		..q:(pType=1)&&((bedAvailable'="Y")||(baoFlag'=0))  //过滤床位被用和判断是否包床
		..s bedName=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",1)
		..s wardName=$p(^PAWARD(wardId),"^",2)
		..i wardName["-" s wardName=$p(wardName,"-",2)
		..d PatBedInfoByType
	
	}elseif (pType="0^1"){   //优化前台调用，0、1整合成一个服务
		s wardId=0
		f i=1:1:length d
		.s wardId=$p(wardIdStr,"^",i)
		.q:+wardId=0
		.s wardName=$p(^PAWARD(wardId),"^",2)
		.i wardName["-" s wardName=$p(wardName,"-",2)
		.s ifHasBed=0   //该病区是否有床
		.s bedIdStr=##class(DtPortal.Common.PublicService).getBedIDStrByWardID(wardId,2)
		.s bedLength=$l(bedIdStr,"^")
		.f bedIndex=1:1:bedLength d
		..s bedId=$p(bedIdStr,"^",bedIndex)
		..q:bedId=""
		..s bedChild=$p(bedId,"||",2)
		..s bedAvailable=$$CO18^at153(wardId_"||"_bedChild)  //取床位是否可用
		..s baoFlag=0
		..s baoFlag=##class(DtPortal.Common.PublicService).ifBaoChuang(wardId_"||"_bedChild)
		..//q:(pType=1)&&((bedAvailable'="Y")||(baoFlag'=0))  //过滤床位被用和判断是否包床
		..i (bedAvailable'="Y")||(baoFlag'=0) d
		...s ifEmpty="false"
		..e  s ifEmpty="true"
		..s bedName=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",1)
		..s wardName=$p(^PAWARD(wardId),"^",2)
		..i wardName["-" s wardName=$p(wardName,"-",2)
		..d PatBedInfoByType
	}else{
		f i=1:1:length d
		.s wardId=$p(wardIdStr,"^",i)
		.;q:wardId'=20 //测试
		.q:+wardId=0
		.k bedSortHos2   //删除数组数据
		
		
		.s bedIdStr=##class(DtPortal.Common.PublicService).getBedIDStrByWardID(wardId,2)
		.s bedLength=$l(bedIdStr,"^")
		.f bedIndex=1:1:bedLength d
		..s bedId=$p(bedIdStr,"^",bedIndex)
		..q:bedId=""
		..s bedChild=$p(bedId,"||",2)
		..s isValidBed=##class(DtPortal.Common.PublicService).isValidBed(bedId)
		..q:isValidBed'=1
		..;根据床位查找到患者
		..s currId=$o(^PAWARDA($p(bedId,"||",1),"BED",bedChild,"ADM",0))  
		..q:currId=""
		..s episodeId=$p($g(^PAWARDA($p(bedId,"||",1),"BED",bedChild,"ADM",currId)),"^",1)
		
		
		..;特级护理
		..q:(pType="SN")&&(##class(DtPortal.MD.MD23CommonService).ifSpecialNur(episodeId)=0)
		..;一级护理 add by zhaoli
		..q:(pType="PC")&&(##class(DtPortal.MD.MD23CommonService).ifNur(episodeId,"1")=0)
		..;二级护理 add by zhaoli
		..q:(pType="SC")&&(##class(DtPortal.MD.MD23CommonService).ifNur(episodeId,"2")=0)
		..;三级护理 add by zhaoli
		..q:(pType="TC")&&(##class(DtPortal.MD.MD23CommonService).ifNur(episodeId,"3")=0)
		..;急诊转住院 add by zhaoli
		..q:(pType="EP")&&(##class(DtPortal.MD.MD23CommonService).ifEmergency(episodeId)=0)
		..;死亡患者
		
		..q:(pType="DP")&&(##class(DtPortal.MD.MD23CommonService).ifPatDead(episodeId)=0)
		..;w !,episodeId
		..;本院患者
    	..s tHosPatFlag=##class(DtPortal.MD.MD23CommonService).ifTHosPat(episodeId)
		..q:(pType="THP")&&(tHosPatFlag=0)   ;过滤非本院
		..;欠费患者--
		..s QFflag=""
		..;s arrPatFlag=0
		..i pType="RP" d
		...;s arrPatFlag=##class(web.DHCSETIMAGE).IFArrea($g(episodeId))
		...;s arrPatStr=##class(DtPortal.MD.MD23CommonService).UDHCJFGetQFPatDetailByEpisodeId(episodeId)
		...;S arrPatStr=##class(web.ConCurrBillAmtRecord).GetCBAAmtInfoByAdm(episodeId)
		...s QFflag=##class(DtPortal.MD.MD23CommonService).ifQFPat(episodeId)
		..q:(pType="RP")&&(QFflag'="Y")
		
		..;q:(pType=5)&&(arrPatFlag=0)
		..;w !,episodeId
		..;危重
		..q:(pType="CP")&&(##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"all")=0)
		..;病危
		..q:(pType="CRIP")&&(##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"c")=0)
		..;病重
		..q:(pType="SERP")&&(##class(DtPortal.MD.MD23CommonService).ifCritical(episodeId,"s")=0)
		..;抢救
		..q:(pType="RSP")&&(##class(DtPortal.MD.MD23CommonService).ifRescuePat(episodeId)=0)
		..;再次手术
		..q:(pType="RO")&&(##class(DtPortal.MD.MD23CommonService).ifReOpeByAdm(episodeId)=0)
		..s bedId=$P($g(^PAADM(episodeId)),"^",73)
		..s bedCode=""
		..q:bedId=""   //不统计无床位的
		..s bedTypeCode=##class(DtPortal.Common.PublicService).getBedTypeCode(bedId)   //4-过滤婴儿床
		..q:bedTypeCode="MATERNALBABY"
		..s bedName=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)  //
		..s bedChild=$P(bedId,"||",2)   //存入床位子id
		..s bedSortHos2(bedName_" ",bedChild)=wardId   //病区id排序用
		
		.s bedCodeP=""
		.f  s bedCodeP=$o(bedSortHos2(bedCodeP)) q:bedCodeP=""  d
		..s bedChild=""
		..f bedChild=$o(bedSortHos2(bedCodeP,bedChild)) q:bedChild=""  d
		...s bedName=$tr(bedCodeP," ")
		...s wardId=bedSortHos2(bedCodeP,bedChild)
		...s wardName=$p(^PAWARD(wardId),"^",2)
		...i wardName["-" s wardName=$p(wardName,"-",2)
		
		
		...d PatBedInfoByType
		
	}
	;s endTime=$p($h,",",2)
	;w !,endTime-startTime
	k bedSortHos2   //删除数组数据
	q $$$OK
	
PatBedInfoByType
	
    s Data=$lb(wardId,wardName,bedName,bedChild,ifEmpty)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2015-11-23
/// Description:查询所有的病区信息--用于维护楼层的病区信息
/// Input： 无 
/// Return： 
/// 服务代码：MD2303.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findAllWardInfo","")
Query findAllWardInfo(q As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "wardDesc:%String,wardCode:%String,wardId:%String")
{
}

ClassMethod findAllWardInfoExecute(ByRef qHandle As %Binary, q As %String, hospitalId As %String = "") As %Status
{
	New (qHandle,q,hospitalId)
	
	set q=$ZConvert(q,"U")
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s num=0
	Set id=0
	For  s id=$o(^PAWARD(id)) q:id=""  d
	.q:+id=0
	.set locID=$p(^PAWARD(id),"^",5)
	.q:+locID=0
	.set CTLOCHospitalDR=$P($G(^CTLOC(locID)),"^",22)			//科室所属院区
	.q:((hospitalId'="")&&(hospitalId'=CTLOCHospitalDR))
	.set shoutName=$P(^CTLOC(locID),"^",43)
	.s wardDesc=$p(^PAWARD(id),"^",2)
	.set shoutName=$ZConvert(shoutName,"U")
	.q:((shoutName'[q)&&(wardDesc'[q))
	.s wardCodeDesc=wardDesc
	.i $p(wardDesc,"-",2)'="" s wardDesc=$p(wardDesc,"-",2)
	.s wardCode=$p(^PAWARD(id),"^",1)
	.s wardId=id
	.s num=num+1
	.d MDWard
	q $$$OK
	

  
MDWard
    s Data=$lb(wardDesc,shoutName,wardId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 淡培军
/// CreatDate： 2016-03-03
/// Description:根据病区Id获取病区的总虚床数、有人虚床数、有人固定床数、总固定床数信息
/// Input： 病区Id串
/// Return： 病区Id,病区、总虚床数、有人虚床数、有人固定床数、总固定床数
/// 服务代码：MD2301.02.02  id；inHosNum；YinHosNum；outHosNum
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findBedInforByLocId","5^10^6^11^22^8^9^12^13^21^20^")wardId,ward,loc,totalVirtualBed,virtualBed,fixedBed,totalFixedBed
Query findBedInforByLocId(locIdStr As %String) As DtPortal.Query(ROWSPEC = "wardId,ward,totalFixedBed,emptyFixedBed,disableBed,fixedBedAll,baochuangBed")
{
}

ClassMethod findBedInforByLocIdExecute(ByRef qHandle As %Binary, locIdStr As %String) As %Status
{
	New (qHandle,locIdStr)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set length=$l(locIdStr,"^")
	set wardId=0
	for i=1:1:length  d
	.set wardId=$p(locIdStr,"^",i)	//病区Id
	.quit:+wardId=0
	.set ward=$p(^PAWARD(wardId),"^",2)		//病区描述
	.if ward["-" set ward=$p(ward,"-",2)	//去掉病区前面的字符
	.set bedId=0
	.set totalVirtualBed=0,virtualBed=0,fixedBed=0,totalFixedBed=0,emptyFixedBed=0,disableBed=0,baochuangBed=0
	.for  set bedId=$o(^PAWARD(wardId,"BED",bedId)) q:bedId=""  d
	..s isValid=##class(DtPortal.Common.PublicService).isValidBed(wardId_"||"_bedId)
	..q:isValid'="1"
	..set totalFixedBed=totalFixedBed+1	//总固定床
	..s BedNo=$P($g(^PAWARD(+wardId,"BED",bedId)),"^",1)
	..if ($p(##class(DtPortal.Common.PublicService).ifBaoChuang(wardId_"||"_bedId),"^",1)=2) d  //获取不可用床位数（测试） by cfyc20170616
	...set disableBed=disableBed+1
	..if ($p(##class(DtPortal.Common.PublicService).ifBaoChuang(wardId_"||"_bedId),"^",1)=1) d  //获取不可用床位数（包床） by cfyc20170616
	...set baochuangBed=baochuangBed+1
	.s bedNumStr=##class(DtPortal.MD.MD23CommonService).getBedNumByWardId(wardId)
	.s fixedBedAll=$p(bedNumStr,"^",2)
	.s emptyFixedBed=totalFixedBed-fixedBedAll
	.d BedInfor

	q $$$OK
	
BedInfor
	s Data=$lb(wardId,ward,totalFixedBed,emptyFixedBed,disableBed,fixedBedAll,baochuangBed)
 	s ^||CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

/// Creator： 淡培军
/// CreatDate： 2016-03-09
/// Description:根据病区Id获取病房患者就诊科室和占用床数
/// Input： 病区Id串
/// Return： 病区Id,就诊科室Id、占用虚床数、占用床位数
/// 服务代码：MD2301.02.02  id；inHosNum；YinHosNum；outHosNum
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD23HospitalMonitor","findPatMasInforByWardId","10")
/// w ##class(DtPortal.MD.MD23HospitalMonitor).findPatMasInforByWardId("21")
ClassMethod findPatMasInforByWardId(wardId)
{
	New (wardId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	;根据科室id获取对应的所有科室
	s wardDr=$p(^PAWARD(wardId),"^",5)
	s subLink=0 ;^CTLOC(WARDLocationDR,"LINK",subLink) //获取所有的科室
	f  s subLink=$o(^CTLOC(wardDr,"LINK",subLink)) q:(subLink="")||(subLink=0)  d
	.s locDrId=^CTLOC(wardDr,"LINK",subLink)
	.q:(locDrId="")||(locDrId=0)
	.s bedNum(locDrId,1)=0,bedNum(locDrId,2)=0
	;遍历就诊id--获取病区就诊ID串
	s admIDStr=##Class(DtPortal.Common.PaadmService).getAdmIDStrByWardID(wardId)
	Set inNum=$l(admIDStr,"^")
	f inNumIndex=1:1:inNum d
	.s admId=$p(admIDStr,"^",inNumIndex)
	.q:admId=""
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admId)
	.s bedCode=$p(patInfoStr,"^",1)		//床号信息
	.s locId=$p(^PAADM(admId),"^",4)	//就诊科室Id
	.q:(locId="")||(bedCode="")
	.set bedId=$P($g(^PAADM(admId)),"^",73)
	.s isValidBed=##class(DtPortal.Common.PublicService).isValidBed(bedId)
	.q:isValidBed'=1
	.i (bedCode["x")||(bedCode["X") s bedXFlag=1  //虚床
	.e  s bedXFlag=2
	.s bedNum(locId,bedXFlag)=$g(bedNum(locId,bedXFlag))+1  //如果两个科室Id相同，说明该科室有病人
	
	s ret=""
	s virtualBed=0,fixedBed=0
	s locDesc=""
	s paadmLocId=""
	f  s paadmLocId=$o(bedNum(paadmLocId)) q:(paadmLocId="")||(paadmLocId=0)  d
	.;b ;paadmLocId
	.i $d(bedNum(paadmLocId,1)) s virtualBed=bedNum(paadmLocId,1)
	.i $d(bedNum(paadmLocId,2)) s fixedBed=bedNum(paadmLocId,2)
	.s locDesc=$p($g(^CTLOC(paadmLocId)),"^",2)
	.i locDesc["-" s locDesc=$p(locDesc,"-",2)
	.i ret="" s ret=locDesc_"|"_virtualBed_"|"_fixedBed
	.e  s ret=ret_"^"_locDesc_"|"_virtualBed_"|"_fixedBed
	q ret
}

}
