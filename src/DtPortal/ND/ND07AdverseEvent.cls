/// creator:        bmz
/// date:           2018.12.16
/// description:    不良事件统计-封装新产品组提供的接口
Class DtPortal.ND.ND07AdverseEvent Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator： 白明哲
/// CreatDate： 2018-12-16
/// Description: 查询不良事件类型
/// Input：        
/// Return： 
/// 服务编码：ND07.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND07AdverseEvent","ND070101FindAdverseType","H")
/// Creator： 白明哲
/// CreatDate： 2018-12-16
/// Description: 查询不良事件类型
/// Input：        
/// Return： 
/// 服务编码：ND07.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND07AdverseEvent","ND070101","D")
Query ND070101(type As %String, reptypecode As %String = "") As DtPortal.Query(ROWSPEC = "displayDesc,parentid,desc,subdesc,code")
{
}

ClassMethod ND070101Execute(ByRef qHandle As %Binary, type As %String, reptypecode As %String = "") As %Status
{
	//n (qHandle,type)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//全部
	s desc="全部"
	s subdesc="全部"
	s parentid=""
	s code=""
	s displayDesc="全部"
	d ND070101FindAdverseType
	
	
	Set object = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportType")
	Do object.Execute(type,reptypecode)
	
	While (object.Next()) {
		//b ;0001
		s desc=object.Data("desc")
		s subdesc=object.Data("subdesc")
		s parentid=object.Data("parentid")
		
		s displayDesc=subdesc
		if (displayDesc=""){
			s displayDesc=desc
		}
		s code=object.Data("code")
		d ND070101FindAdverseType
	}
	

	
  	q $$$OK
ND070101FindAdverseType 
    s Data=$lb(displayDesc,parentid,desc,subdesc,code)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2018-12-16
/// Description: 查询不良事件趋势图信息
/// Input：   AuditStatus-查询A          
///   	startDate-开始日期、endDate-结束日期  ----这两个必须穿足月的日期，因为按月输出数据
///     typeId-不良事件类型ID、depId-科室表ID（病区、科室公用这个参数）
///     NurStatus-A护理部审核  S-科护士长审核  T-AS组合查询    userCode-（护理部传参，其他传空）       isNur "H"-护理  ""-全部
/// Return： I (RepStaus="护理部审核") S NurStatusFlag="A" I (RepStaus="科护士长审核") S NurStatusFlag="S" I NurStatus="T" D I (RepStaus="护理部审核")||(RepStaus="科护士长审核") S NurStatusFlag="T"
/// 服务编码：ND07.01.02
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND07AdverseEvent","ND070102","2020-01-01","2021-11-10","","195^","","A","D","","","")
Query ND070102(startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "") As DtPortal.Query(ROWSPEC = "month,monthDesc,num,typeId,isFinish,depId")
{
}

ClassMethod ND070102Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//传all用户查询全部科室
	if depId="" q $$$OK
	if (depId="all") set depId=""
	s userId=""
	
	if (depId'=""){
		s depId=##class(DtPortal.ND.ND07AdverseEvent).getNewDeptStr(depId)	
	}
	
	i userCode'=""  s userId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	//按年查询，固定输出1-12月
	
	
	
	Set object = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportDetail")
	Do object.Execute(startDate,endDate,depId,typeId,userId,AuditStatus,NurType,hospitalId,NurStatus,isFinish)
	
	k AdverseEventTrend($j)
	s allMonth=""
	s SeriesDataArray="all"
	
	While (object.Next()) {
		
		//b ;0001
		s id=object.Data("id")
		s desc=object.Data("desc")
		s subdesc=object.Data("subdesc")
		s emrdate=object.Data("emrdate")
		continue:emrdate=""||($l(emrdate,"-")'=3)
		s emrtime=object.Data("emrtime")
		s subdesc=object.Data("subdesc")
		s locdr=object.Data("locdr")
		continue:+locdr=0
		s locdesc=object.Data("locdesc")
		;b ;009
		//w !,locdesc
		s month=$p(emrdate,"-",1)_"-"_$p(emrdate,"-",2)
		s AdverseEventTrend($j,month,locdr)=$g(AdverseEventTrend($j,month,locdr))+1
		
		if ('$LF($LISTFROMSTRING(SeriesDataArray,"^"),locdr)){
				set SeriesDataArray=SeriesDataArray_"^"_locdr
			}
		
		
	}

	
	//初始化年月数据
	s yearTempStart=$p(startDate,"-",1)
	s yearTempEnd=$p(endDate,"-",1)
	for yearIndex=yearTempStart:1:yearTempEnd{
		for monthIndex=1:1:12 {
			s monthTemp=monthIndex
			if monthIndex<10 s monthTemp="0"_monthTemp
			s yearMonthTemp=yearIndex_"-"_monthTemp
			
			s nowmonth=$p($zd($p($h,",",1),3),"-",2)
			s nowyear=$p($zd($p($h,",",1),3),"-",1)
			
			continue:yearIndex>nowyear
			if (yearIndex=nowyear){
				continue:monthIndex>nowmonth
			}
			
			if ($g(AdverseEventTrend($j,yearMonthTemp))="") s AdverseEventTrend($j,yearMonthTemp)=0
		}
	}
	
		
	
	
	s month=""
	for{
		s month=$o(AdverseEventTrend($j,month))
		q:month=""
		s allLocNum=0
		s locdr=0
		s locNumStr=""
		s locStrTemp=""
		for{
			s locdr=$o(AdverseEventTrend($j,month,locdr))
			q:locdr=""
			s locDesc=$p($g(^CTLOC(locdr)),"^",2)
			i locDesc["-" s locDesc=$p(locDesc,"-",2)
			if (locNumStr=""){
				s locNumStr=locdr_"^"_locDesc_"^"_AdverseEventTrend($j,month,locdr)
			}else{
				s locNumStr=locNumStr_"#"_locdr_"^"_locDesc_"^"_AdverseEventTrend($j,month,locdr)
			}
			s allLocNum=allLocNum+AdverseEventTrend($j,month,locdr)
			if (locStrTemp="") {
				s locStrTemp=locdr
			}else{
				s locStrTemp=locStrTemp_"*"_locdr
			}
			
		}
				
		
		s monthDesc=$p(month,"-",1)_"年"_$p(month,"-",2)_"月"
		d ND070102
	}
	
	
	
  	q $$$OK
ND070102 
	
    s Data=$lb(month,monthDesc,allLocNum,typeId,isFinish,depId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2018-12-16
/// Description: 查询不良事件明细信息
/// Input：   AuditStatus-查询A        NurStatus-A护理部审核  S-科护士长审核  T-AS组合查询
/// Return： 
/// 服务编码：ND07.01.03
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND07AdverseEvent","ND070103","2020-01-01","2020-01-31","","all","","A","D","","","","","")
Query ND070103(startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "", state As %String = "", dId As %String) As DtPortal.Query(ROWSPEC = "typeid,desc,subdesc,emrdate,emrtime,locdr,locdesc,statusdesc,reportid,statuscode,recaudituser,recauditdate,eventInfo,diagnosis,recordr,stausdr,receivedr,statuslast,statuslastid,statusnext,statusnextid,repappauditflag,userleadflag,fileflag,stafistaudituser,userId,stsusgrant")
{
}

ClassMethod ND070103Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "", state As %String = "", dId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s userId=""
	
	//传all用户查询全部科室
	if depId="" q $$$OK

	if (depId="all"){
		if (state="DD"){
			 s depId=dId
		}else{
			 s depId=""
			}
		
	}
	
	
	if (depId'=""){
		s depId=##class(DtPortal.ND.ND07AdverseEvent).getNewDeptStr(depId)	
	}
	
	i userCode'=""  s userId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	Set object = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportDetail")
	Do object.Execute(startDate,endDate,depId,typeId,userId,AuditStatus,NurType,hospitalId,NurStatus,isFinish)
	While (object.Next()) {
		//b ;0001
		s typeid=object.Data("typeid")
		s desc=object.Data("desc")
		s subdesc=object.Data("subdesc")
		s emrdate=object.Data("emrdate")
		continue:emrdate=""||($l(emrdate,"-")'=3)
		s emrtime=object.Data("emrtime")
		s subdesc=object.Data("subdesc")
		s locdr=object.Data("locdr")
		continue:+locdr=0
		
		
		s EpisodeId=object.Data("EpisodeId")
		s locdesc=object.Data("locdesc")
		s statusdesc=object.Data("statusdesc")
		s reportid=object.Data("reportid")
		s statuscode=object.Data("statuscode")
		s recaudituser=object.Data("recaudituser")
		s recauditdate=object.Data("recauditdate")
		s eventInfo=object.Data("eventInfo")
		s recordr=object.Data("recordr")
		s stausdr=object.Data("stausdr")
		s receivedr=object.Data("receivedr")
		s statuslast=object.Data("statuslast")
		s statuslastid=object.Data("statuslastid")
		s statusnext=object.Data("statusnext")
		s statusnextid=object.Data("statusnextid")
		s repappauditflag=object.Data("repappauditflag")
		s userleadflag=object.Data("userleadflag")
		s fileflag=object.Data("fileflag")
		s stafistaudituser=object.Data("stafistaudituser")
		s stsusgrant=object.Data("stsusgrant")
		s diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
		
		d ND070103
	}
	
  	q $$$OK
ND070103
	
    s Data=$lb(typeid,desc,subdesc,emrdate,emrtime,locdr,locdesc,statusdesc,reportid,statuscode,recaudituser,recauditdate,eventInfo,diagnosis,recordr,stausdr,receivedr,statuslast,statuslastid,statusnext,statusnextid,repappauditflag,userleadflag,fileflag,stafistaudituser,userId,stsusgrant)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2018-12-16
/// Description: 查询不良事件构成图
/// Input：   AuditStatus-查询A        NurStatus-A护理部审核  S-科护士长审核  T-AS组合查询
/// Return： 
/// 服务编码：ND07.01.04
/// 暂时预留，讨论是否有意见字段
/// ##class(web.DHCADVINTERFACE).NurAuditReport("11","10||3","4","1496","82","advAccidentFill")   
/// Creator： 白明哲
/// CreatDate： 2018-12-16
/// Description: 查询不良事件构成图
/// Input：   AuditStatus-查询A        NurStatus-A护理部审核  S-科护士长审核  T-AS组合查询
/// Return： 
/// 服务编码：ND07.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND07AdverseEvent","ND070201","2019-01-01","2019-01-31","","169^56","","A","D","","","")
Query ND070201(startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "") As DtPortal.Query(ROWSPEC = "typeid,desc,num,depId")
{
}

ClassMethod ND070201Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//传all用户查询全部科室
	if depId="" q $$$OK
	if (depId="all") set depId=""
	
	if (depId'=""){
		s depId=##class(DtPortal.ND.ND07AdverseEvent).getNewDeptStr(depId)	
	}
	
	
	s userId=""
	i userCode'=""  s userId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	Set object = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportDetail")
	Do object.Execute(startDate,endDate,depId,typeId,userId,AuditStatus,NurType,hospitalId,NurStatus,isFinish)
	While (object.Next()) {
		s typeid=object.Data("typeid")
		s desc=object.Data("desc")
		s subdesc=object.Data("subdesc")
		s emrdate=object.Data("emrdate")
		continue:emrdate=""||($l(emrdate,"-")'=3)
		s emrtime=object.Data("emrtime")
		s subdesc=object.Data("subdesc")
		s locdr=object.Data("locdr")
		continue:+locdr=0
		s locdesc=object.Data("locdesc")
		s statusdesc=object.Data("statusdesc")
		s reportid=object.Data("reportid")
		s statuscode=object.Data("statuscode")
		s recaudituser=object.Data("recaudituser")
		s recauditdate=object.Data("recauditdate")
		s eventInfo=object.Data("eventInfo")
		s AdverseEventChart($j,typeid,desc)=$g(AdverseEventChart($j,typeid,desc))+1
	}
	
	s typeIDTemp=0
	for {
		s typeIDTemp=$o(AdverseEventChart($j,typeIDTemp))
		q:typeIDTemp=""
		s typeid=typeIDTemp
		s desc=$o(AdverseEventChart($j,typeIDTemp,""))
		s num=AdverseEventChart($j,typeIDTemp,desc)
		d ND070201
	}
	
	
  	q $$$OK
ND070201
	
    s Data=$lb(typeid,desc,num,depId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 
/// CreatDate：2020-11-10 
/// Description: 
/// Input：   AuditStatus-查询A        NurStatus-A护理部审核  S-科护士长审核  T-AS组合查询
/// Return： 
/// 
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND07AdverseEvent","ND070103CS","2020-11-01","2020-11-10","","all","","A","D","","","","","")
Query ND070105(startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "", state As %String = "", dId As %String) As DtPortal.Query(ROWSPEC = "locID,LocDesc,num")
{
}

ClassMethod ND070105Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, typeId As %String, depId As %String, userCode As %String = "", AuditStatus As %String = "", NurType As %String = "", hospitalId As %String = "", NurStatus As %String = "", isFinish As %String = "", state As %String = "", dId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s userId=""
	
	k ^||TMPPortalND070105
	//传all用户查询全部科室
	if depId="" q $$$OK

	if (depId="all"){
		if (state="DD"){
			 s depId=dId
		}else{
			 s depId=""
			}
		
	}
	
	if (depId'=""){
		s depId=##class(DtPortal.ND.ND07AdverseEvent).getNewDeptStr(depId)	
	}
	
	i userCode'=""  s userId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	Set object = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportDetail")
	set opNum=0
	Do object.Execute(startDate,endDate,depId,typeId,userId,AuditStatus,NurType,hospitalId,NurStatus,isFinish)
	While (object.Next()) {
		//b ;0001
		s locID=object.Data("locdr")
		set opNum=+opNum+1
		set ^||TMPPortalND070105(locID)=$g(^||TMPPortalND070105(locID))+1
	}
	set locID=0
	for
	{
		set locID=$o(^||TMPPortalND070105(locID))
		quit:locID=""
		
		set LocDesc=$p(^CTLOC(locID),"^",2)
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		
		set num=+$g(^||TMPPortalND070105(locID))
		
		set Data=$lb(locID,LocDesc,num)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
	
	}
	
    
    k ^||TMPPortalND070105
	
  	q $$$OK
}

/// w ##class(DtPortal.ND.ND07AdverseEvent).getNewDeptStr("195^^1267^")
ClassMethod getNewDeptStr(depId)
{
	q:depId="" ""
	s depNewStr=""
	//整理去除空的科室
	S iNNum=$l(depId,"^")
	for i=1:1:iNNum
	{	
		set depIdTemp=$p(depId,"^",i)	
		continue:depIdTemp=""
		if (depNewStr=""){
			s depNewStr=depIdTemp
		}else{
			s depNewStr=depNewStr_"^"_depIdTemp
		}
		
 	}
 	q depNewStr
}

}
