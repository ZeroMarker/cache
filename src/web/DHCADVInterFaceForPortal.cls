Import SQLUser

Class web.DHCADVInterFaceForPortal Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, Not ProcedureBlock ]
{

/// Description: 不良事件统计，获取不良事件类型以及数量  
/// Creator:     yuliping
/// CreateDate:  2020-10-27
/// Input:  	 开始时间，结束时间，病区ID，院区ID,用户code
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCADVInterFaceForPortal","QueryReportType","2018-08-01","2021-08-28","","2","1496")
Query QueryReportType(startTime As %String, endTime As %String, wardId As %String, hospitalId As %String, userCode As %String = "") As %Query(ROWSPEC = "eventName:%String,type:%String,count:%Integer") [ SqlProc ]
{
}

ClassMethod QueryReportTypeExecute(ByRef qHandle As %Binary, startTime As %String, endTime As %String, wardId As %String, hospitalId As %String, userCode As %String = "") As %Status
{
	n (qHandle,startTime,endTime,wardId,hospitalId,userCode)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	i (startTime = "")||(endTime = "" ) Quit $$$OK

	k ^TMP("DHCADV","web.DHCADVInterFaceForPortal","QueryReportType",repid) //2020-10-27 yuliping

 	d ..statisReportType(startTime,endTime,wardId,hospitalId,repid,userCode)   //数据存入global

	s typeId = 0
	f  s typeId = $o(^TMP("DHCADV","web.DHCADVInterFaceForPortal","QueryReportType", repid, typeId)) q:typeId=""  d
	.s:(typeId '[ "||") RepType = $p(^DHCMEDADREVT(typeId), "^", 2)      //表单描述
	.s:(typeId [ "||") RepType = $p(^DHCMEDADREVTI(+typeId, "MADREVI", $p(typeId, "||", 2)), "^", 2)
	.s num = ^TMP("DHCADV", "web.DHCADVInterFaceForPortal", "QueryReportType", repid, typeId)
    .d OutPutReportType

    Set qHandle = $lb(0,repid,0)
    k ^TMP("DHCADV", "web.DHCADVInterFaceForPortal", "QueryReportType", repid)
	Quit $$$OK
OutPutReportType
	set Data = $lb(RepType, typeId, num)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind+1
	quit
}

ClassMethod QueryReportTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportTypeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryReportTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Description: 不良事件统计，获取不良事件类型以及数量,数据存入global
/// Creator:     yuliping
/// CreateDate:  2020-10-27
/// Input:  	 开始时间,结束时间,病区id,医院id,repid,用户code
/// Return: 	 报告表数据
ClassMethod statisReportType(startTime, endTime, wardId, hospitalId, repid, userCode As %String = "")
{
		
	n (startTime, endTime, wardId, hospitalId, repid,userCode)
	i startTime '= "" s startTime = $zdh(startTime, 3) 
 	i endTime '= "" s endTime = $zdh(endTime, 3) 
 	/// 2021-07-14 cy 区分多院区 走查看权限
 	S userid="",locId=""
 	S:userCode'="" userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
 	S:wardId'="" locId = $p(^PAWARD(wardId), "^", 5)
	S lgparam=userid_"^"_locId_"^"_""_"^"_hospitalId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",lgparam)
	
	f Date = startTime: 1: endTime  d 
	.s RepID = ""
	.f  s RepID = $o(^DHCADVMASTER(0,"RepDate", Date, RepID)) q:RepID=""  d
	..S recordID = $p(^DHCADVMASTER(RepID), "^", 1)
	..Q:recordID=""
	..S RepTypeDr = ""
	..S RepTypeDr = $p(^DHCADVMASTER(RepID), "^", 2)
	..q:RepTypeDr=""
	..S RepLocDr = $p(^DHCADVMASTER(RepID), "^", 7)   					//上报科室,病区字段目前没用
	..s repWard = ""
	..s:$d(^PAWARD(0, "WARD_LocationDR", RepLocDr)) repWard = $o(^PAWARD(0, "WARD_LocationDR", RepLocDr, ""))
	..q:(("" '= wardId) && (wardId '= repWard))						  //病区过滤
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..s RepHospID=""
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(hospitalId'="")&(hospitalId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID  
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,lgparam)
	..;b ;01
	..Q:((flag'="")&&(flag'=1))
	..i $d(^TMP("DHCADV", "web.DHCADVInterFaceForPortal", "QueryReportType", repid, RepTypeDr)) d
	...s ^TMP("DHCADV", "web.DHCADVInterFaceForPortal", "QueryReportType", repid, RepTypeDr) = ^TMP("DHCADV", "web.DHCADVInterFaceForPortal", "QueryReportType", repid, RepTypeDr) + 1
	..e  s ^TMP("DHCADV", "web.DHCADVInterFaceForPortal", "QueryReportType", repid, RepTypeDr) = 1
	
	q ""
}

/// Description: 不良事件统计，获取不良事件类型以及数量   明细 
/// Creator:     yuliping
/// CreateDate:  2020-10-27
/// Input:  	 病区ID，开始时间，结束时间，院区ID,报告类型id,医院id,用户code
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCADVInterFaceForPortal","QueryReportDetail","","2018-08-01","2021-08-28","87||2","2","1496")
Query QueryReportDetail(wardId As %String, startTime As %String, endTime As %String, type As %String, hospitalId As %String, userCode As %String = "") As %Query(ROWSPEC = "medicalNo:%String, bed:%String, name:%String, event:%String, reportingTime:%String, RepUser:%String, reportingWard:%String") [ SqlProc ]
{
}

ClassMethod QueryReportDetailExecute(ByRef qHandle As %Binary, wardId As %String, startTime As %String, endTime As %String, type As %String, hospitalId As %String, userCode As %String = "") As %Status
{
	n (qHandle, wardId, startTime, endTime, type, hospitalId,userCode)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	i (startTime = "")||(endTime = "" ) Quit $$$OK
	k DetailData
    d ..getReportDetail(wardId, startTime, endTime, type, hospitalId, .DetailData,userCode)

	s repId = ""
	f  s repId = $o(DetailData(repId)) q:repId=""  d
	.d OutPutTypeDetail
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutTypeDetail
	set Data=DetailData(repId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportDetailExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportDetailExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Description: 获取不良事件数据
/// Creator:     yuliping
/// CreateDate:  2020-10-27
/// Input:  	 病区ID，开始时间，结束时间，类型ID，院区ID，  用户code
/// Return: 	 报告表数据
/// Others:		 
ClassMethod getReportDetail(wardId, startTime, endTime, type, hospitalId, ArrData, userCode As %String = "")
{
	
	n (wardId, startTime, endTime, type, hospitalId, ArrData,userCode)
	
	i startTime '= "" s startTime = $zdh(startTime, 3) 
 	i endTime '= "" s endTime = $zdh(endTime, 3) 
 	/// 2021-07-14 cy 区分多院区 走查看权限
 	S userId="",locId=""
 	S:userCode'="" userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
 	S:wardId'="" locId = $p(^PAWARD(wardId), "^", 5)
	S lgparam=userId_"^"_locId_"^"_""_"^"_hospitalId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",lgparam)
 	
	f Date = startTime: 1: endTime  d 
	.s RepID = ""
	.f  s RepID = $o(^DHCADVMASTER(0, "RepDate", Date, RepID)) q:RepID=""  d
	..S RepTypeDr = ""
	..S recordID = $p(^DHCADVMASTER(RepID), "^", 1)
	..Q:recordID=""
	..S RepTypeDr = $p(^DHCADVMASTER(RepID), "^", 2)
	..q:(type '= RepTypeDr)   
	..s:(RepTypeDr '[ "||") RepType = $p(^DHCMEDADREVT(RepTypeDr), "^", 2)      //表单描述
	..s:(RepTypeDr [ "||") RepType = $p(^DHCMEDADREVTI(+RepTypeDr, "MADREVI", $p(RepTypeDr, "||", 2)), "^", 2)
	..S RepLocDr = $p(^DHCADVMASTER(RepID), "^", 7)  						//上报科室,病区字段目前没用
	..s repWard = ""
	..s:$d(^PAWARD(0, "WARD_LocationDR", RepLocDr)) repWard = $o(^PAWARD(0, "WARD_LocationDR", RepLocDr, ""))
	..q:(("" '= wardId) && (wardId '= repWard))						  		//病区过滤
	..s medicalNo = $p(^DHCADVMASTER(RepID), "^", 14) 					//1.登记号
	..;s bed = $p(^DHCADVMASTER(RepID), "^" , 22)    					//2.床号
	..s AdmID=$p(^DHCADVMASTER(RepID),"^",16)   ///就诊ID
	..s bed=""
	..s:AdmID'="" bed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(AdmID)  //调用护理组接口获取床位号
	..s name = $p(^DHCADVMASTER(RepID), "^", 17)         				//3.姓名
	..s event = RepType													//4.事件
	..s reportingTime = $zd(Date, 3)       								//5.上报时间
	..s RepUser = ""
	..s RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..s:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2) //6.上报人
	..s RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"填报人姓名")  //取匿名信息 sufan 2019-11-07 //6.上报人
	..s:RecRepUser'="" RepUser=RecRepUser
	..s reportingWard = ""
 	..s:+repWard'=0 reportingWard = $p(^PAWARD(repWard),"^",2)  					//7.上报病区
	..s RepHospID=""
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(hospitalId'="")&(hospitalId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID  
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,lgparam)
	..Q:((flag'="")&&(flag'=1))
	..s ArrData(RepID) = $lb(medicalNo, bed, name, event, reportingTime, RepUser, reportingWard)

	q ""
}

/// Description: 不良事件按时间和类型统计，某年数据按月进行统计 
/// Creator:     yuliping
/// CreateDate:  2020-10-28
/// Input:  	 病区ID，开始时间，结束时间，院区ID，用户code
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCADVInterFaceForPortal","QueryReportByMonth","","2018-08-01","2021-08-28","2","1496")
Query QueryReportByMonth(wardId As %String, startTime As %String, endTime As %String, hospitalId As %String, userCode As %String = "") As %Query(ROWSPEC = "month:%String, monthStr:%String, valueStr:%String, SeriesDataArray:%String") [ SqlProc ]
{
}

ClassMethod QueryReportByMonthExecute(ByRef qHandle As %Binary, wardId As %String, startTime As %String, endTime As %String, hospitalId As %String, userCode As %String = "") As %Status
{
	n (qHandle, wardId, startTime, endTime, hospitalId,userCode)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	i (startTime = "")||(endTime = "" ) Quit $$$OK

	k MonthData 
 	d ..statisReportByMonth(wardId, startTime, endTime, hospitalId, .MonthData,userCode)   //数据存入数组

	s date = ""
	f  s date = $o(MonthData(date)) q:date=""  d
	.s month = $p($zd(date, 3), "-", 1, 2)
	.s monthStr = +$p(month, "-", 2)_"月"
	.s typeId = "", valueStr = "", SeriesDataArray = ""
	.f  s typeId = $o(MonthData(date,typeId)) q:typeId=""  d
	..s typeCode = ""
	..s:(typeId '[ "||") RepType = $p(^DHCMEDADREVT(typeId), "^", 2)      //表单描述
	..s:(typeId [ "||") RepType = $p(^DHCMEDADREVTI(+typeId, "MADREVI", $p(typeId, "||", 2)), "^", 2)
	..s typeInfo = typeId _ "^" _ RepType _ "^" _MonthData(date,typeId)
	..i valueStr = "" d
	...s valueStr = typeInfo 
	..e  s valueStr = valueStr _ "#" _ typeInfo   
	..i SeriesDataArray = "" d
	...s SeriesDataArray = typeId 
	..e  s SeriesDataArray = SeriesDataArray _ "^" _ typeId   
	.d OutPutMonthType
	
    Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutMonthType
	set Data = $lb(month, monthStr, valueStr, SeriesDataArray)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind+1
	quit
}

ClassMethod QueryReportByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportByMonthExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryReportByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportByMonthExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod statisReportByMonth(wardId, startTime, endTime, hospitalId, MonthData, userCode As %String = "")
{
	
	n (wardId, startTime, endTime, hospitalId, MonthData,userCode)
	i startTime '= "" s startTime = $zdh(startTime, 3) 
 	i endTime '= "" s endTime = $zdh(endTime, 3) 
 	/// 2021-07-14 cy 区分多院区 走查看权限
 	S userId="",locId=""
 	S:userCode'="" userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
 	S:wardId'="" locId = $p(^PAWARD(wardId), "^", 5)
	S lgparam=userId_"^"_locId_"^"_""_"^"_hospitalId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",lgparam)
	f Date = startTime: 1: endTime  d 
	.s RepID = ""
	.f  s RepID = $o(^DHCADVMASTER(0,"RepDate", Date, RepID)) q:RepID=""  d
	..S recordID = $p(^DHCADVMASTER(RepID), "^", 1)
	..Q:recordID=""
	..S RepTypeDr = ""
	..S RepTypeDr = $p(^DHCADVMASTER(RepID), "^", 2)
	..q:RepTypeDr=""
	..S RepLocDr = $p(^DHCADVMASTER(RepID), "^", 7)   					//上报科室,病区字段目前没用
	..s repWard = ""
	..s:$d(^PAWARD(0, "WARD_LocationDR", RepLocDr)) repWard = $o(^PAWARD(0, "WARD_LocationDR", RepLocDr, ""))
	..q:(("" '= wardId) && (wardId '= repWard))						  //病区过滤
	..s RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..s RepHospID=""
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(hospitalId'="")&(hospitalId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID  
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,lgparam)
	..Q:((flag'="")&&(flag'=1))
	..s reporDate = $SYSTEM.SQL.LASTDAY($zd(Date, 3))      				//上报时间
	..i '$d(MonthData(reporDate, RepTypeDr)) d
	... s MonthData(reporDate, RepTypeDr) = 1
	..e  s MonthData(reporDate, RepTypeDr) = MonthData(reporDate, RepTypeDr) + 1

	q ""
}

/// Description: 不良事件统计，获取不良事件类型以及数量   明细 
/// Creator:     yuliping
/// CreateDate:  2020-10-27
/// Input:  	 病区ID，开始时间，结束时间，类型id，院区ID，用户code
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCADVInterFaceForPortal","QueryRepMonthDetail","","2018-08-01","2021-08-28","87||2","2","1496")
Query QueryRepMonthDetail(wardId As %String, startTime As %String, endTime As %String, type As %String, hospitalId As %String, userCode As %String = "") As %Query(ROWSPEC = "medicalNo:%String, bed:%String, name:%String, event:%String, reportingTime:%String, RepUser:%String, reportingWard:%String") [ SqlProc ]
{
}

ClassMethod QueryRepMonthDetailExecute(ByRef qHandle As %Binary, wardId As %String, startTime As %String, endTime As %String, type As %String, hospitalId As %String, userCode As %String = "") As %Status
{
	n (qHandle, wardId, startTime, endTime, type, hospitalId,userCode)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	i (startTime = "")||(endTime = "" ) Quit $$$OK
	k MonthDetailData
    d ..getReportDetail(wardId, startTime, endTime, type, hospitalId, .MonthDetailData,userCode)

	s repId = ""
	f  s repId = $o(MonthDetailData(repId)) q:repId=""  d
	.d OutPutMonthTypeDetail
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutMonthTypeDetail
	set Data=MonthDetailData(repId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRepMonthDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRepMonthDetailExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryRepMonthDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRepMonthDetailExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Description: 不良事件统计，不良事件上报审核数量  
/// Creator:     yuliping
/// CreateDate:  2020-10-29
/// Input:  	 userCode，病区ID，安全组ID,医院id
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCADVInterFaceForPortal","QueryRevieweRepNum","1496","","",2)
Query QueryRevieweRepNum(userCode As %String, wardId As %String, groupId As %String, hospitalId As %String = "") As %Query(ROWSPEC = "OutPutReviewe:%String") [ SqlProc ]
{
}

ClassMethod QueryRevieweRepNumExecute(ByRef qHandle As %Binary, userCode As %String, wardId As %String, groupId As %String, hospitalId As %String = "") As %Status
{
	n (qHandle, userCode, wardId, groupId,hospitalId)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	i (userCode = "") Quit $$$OK
	s endTime = +$h
	s startTime = $zdh("2018-01-01",3)   //跟主界面一致
 	/// 2021-07-14 cy 区分多院区 走查看权限
 	S userId="",locId=""
 	S:userCode'="" userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
 	S:wardId'="" locId = $p(^PAWARD(wardId), "^", 5)
	S:locId="" locId = $o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4("护理部"), ""))  //科室id为空，默认护理部
	S:groupId="" groupId = ..getGroupId()
	S lgparam=userId_"^"_locId_"^"_groupId_"^"_hospitalId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",lgparam)
	S list=userId_"^"_locId_"^"_groupId

	s PendAuditnum = 0
	f Date = startTime: 1: endTime  d 
	.s RepID = ""
	.f  s RepID = $o(^DHCADVMASTER(0,"RepDate", Date, RepID)) q:RepID=""  d
	..S recordID = $p(^DHCADVMASTER(RepID), "^", 1)
	..Q:recordID=""
	..S RepTypeDr = ""
	..S RepTypeDr = $p(^DHCADVMASTER(RepID), "^", 2)
	..q:RepTypeDr=""
	..S RepLocDr = $p(^DHCADVMASTER(RepID), "^", 7)   					//上报科室,病区字段目前没用
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..Q:RepStausDr=""
	..S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr	
	..S StatusNextIDaudit=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",lgparam) ;报告下一状态（根据报告审批记录获取）
	..S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt,lgparam) 
	..S StatusNextID=$p(matalist,"^",2) ;报告下一状态 （根据报告状态获取）
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..s RepHospID=""
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(hospitalId'="")&(hospitalId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID  
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,lgparam)
	..Q:((flag'="")&&(flag'=1))
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..s MedadrNextLocDR = ""
	..i MedadrID'="" d
	...S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	..S:(StatusNextIDaudit=StatusNextID)&&((MedadrNextLocDR="")||((MedadrNextLocDR'="")&&(MedadrNextLocDR=locId))) PendAuditnum=PendAuditnum+1   //待审批报告
	
	d OutPutReviewe
    Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutReviewe
	set Data = $lb(PendAuditnum)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind+1
	quit
}

ClassMethod QueryRevieweRepNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRevieweRepNumExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryRevieweRepNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRevieweRepNumExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Description: 不良事件统计，不良事件上报审核数量  
/// Creator:     yuliping
/// CreateDate:  2020-10-29
/// Input:  	 userCode，病区ID，安全组ID,医院id
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCADVInterFaceForPortal","QueryRevieweDetail","1496","","",2)
Query QueryRevieweDetail(userCode As %String, wardId As %String, groupId As %String, hospitalId As %String = "") As %Query(ROWSPEC = "RepType:%String,reportingTime:%String,url:%String") [ SqlProc ]
{
}

ClassMethod QueryRevieweDetailExecute(ByRef qHandle As %Binary, userCode As %String, wardId As %String, groupId As %String, hospitalId As %String = "") As %Status
{
	n (qHandle, userCode, wardId, groupId,hospitalId)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	i (userCode = "") Quit $$$OK
	s endTime = +$h
	s startTime = $zdh("2018-01-01",3)   //跟主界面一致
 	/// 2021-07-14 cy 区分多院区 走查看权限
 	S userId="",locId=""
 	S:userCode'="" userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
 	S:wardId'="" locId = $p(^PAWARD(wardId), "^", 5)
	S:locId="" locId = $o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4("护理部"), ""))  //科室id为空，默认护理部
	S:groupId="" groupId = ..getGroupId()
	S lgparam=userId_"^"_locId_"^"_groupId_"^"_hospitalId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",lgparam)
	S list=userId_"^"_locId_"^"_groupId

	s PendAuditnum = 0
	f Date = startTime: 1: endTime  d 
	.s RepID = ""
	.f  s RepID = $o(^DHCADVMASTER(0,"RepDate", Date, RepID)) q:RepID=""  d
	..S recordID = $p(^DHCADVMASTER(RepID), "^", 1)
	..Q:recordID=""
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..s RepHospID="" //cy 2021-02-03 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(hospitalId'="")&(hospitalId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S RepTypeDr = ""
	..S RepTypeDr = $p(^DHCADVMASTER(RepID), "^", 2)
	..q:RepTypeDr=""
	..S RepLocDr = $p(^DHCADVMASTER(RepID), "^", 7)   					//上报科室,病区字段目前没用
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..Q:RepStausDr=""
	..S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr	
	..S StatusNextIDaudit=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",lgparam) ;报告下一状态（根据报告审批记录获取）
	..S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt,lgparam) 
	..S matalast=##class(web.DHCADVCOMMON).InsStatusLast(Listt) 
	..S StatusLastID=$p(matalast,"^",2)  //上一状态
	..S StatusNextID=$p(matalist,"^",2) ;报告下一状态 （根据报告状态获取）
	..I StatusNextID'=""  D
	...S AdrewRowIDn=$p(StatusNextID,"||",1)
	...S AdrewChildSubn=$p(StatusNextID,"||",2)
	...S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..s MedadrNextLocDR = "", Medadrreceivedr = "",StaFistAuditDr="",StaFistAuditUserDr="",StaFistAuditUser=""
	..i MedadrID'="" d
	...S MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	...S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	...S MedadrRevStatus=$p(^DHCMEDREPADT(MedadrID),"^",14) ;驳回指向
	...S:(RepTypeDr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(RepID, RepTypeDr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	...S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	..q:'((StatusNextIDaudit=StatusNextID)&&((MedadrNextLocDR="")||((MedadrNextLocDR'="")&&(MedadrNextLocDR=locId))))   //待审批报告
	..s reportingTime = $zd(Date, 3)       								//5.上报时间
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,""))
	..S File="",FileFlag=""
	..S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	..S FileFlag=$S(File="":"未归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	..S StsusGrant=##class(web.DHCADVCOMMON).CheckWorkItmGrant(RepStausDr,lgparam)
	..S UserLeadflag=##class(web.DHCADVCOMMONPART).GetSecuUserLeader(userId)
	..S RepAppAuditFlag=0
	..S:StatusNextIDaudit=StatusNextID RepAppAuditFlag=1
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID  
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,lgparam)
	..Q:((flag'="")&&(flag'=1))
	..s url = "recordId="_recordID_"&RepStaus="_RepStaus_"&RepTypeDr="_RepTypeDr_"&code="_RepTypeCode_"&desc="_RepType_"&RepID="_RepID_"&editFlag=1&adrReceive="_Medadrreceivedr_"&RepStausDr="_RepStausDr_"&StatusNextID="_StatusNextID_"&FileFlag="_FileFlag_"&StsusGrant="_StsusGrant_"&StatusLastID="_StatusLastID_"&StaFistAuditUser="_StaFistAuditUser_"&UserLeadflag="_UserLeadflag_"&RepAppAuditFlag="_RepAppAuditFlag_"&StatusNext="_StatusNext_"&winflag=2"
	..d OutPutRevieweDetail
    Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutRevieweDetail
	set Data = $lb(RepType,reportingTime,url)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind+1
	quit
}

ClassMethod QueryRevieweDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRevieweDetailExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryRevieweDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRevieweDetailExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Description: 取护理部安全组ID ，没有索引
/// Creator:     yuliping
/// CreateDate:  2020-10-29
/// Others:		 w ##class(web.DHCADVInterFaceForPortal).getGroupId()
ClassMethod getGroupId()
{
	s gpId = 0
	s id = ""
	f  s gpId = $o(^SSU("SSGRP", gpId)) q:(gpId="")||(id'="")  d
	.i $p(^SSU("SSGRP", gpId), "^", 1) = "护理部" s id = gpId
	
	q id
}

/// Description: 统计药品不良反应记录
/// Others:		 w ##class(web.DHCADVInterFaceForPortal).getDrugData("1")
ClassMethod getDrugData(adm)
{
	n (adm)
	q:adm="" "就诊号为空！"
 	//^DHCADVMASTER(0,"ADM",{ADV_Adm},{ADV_RowID})
 	s ResultList="该患者无药品不良反应记录！"
 	s RepID = ""
	f  s RepID = $o(^DHCADVMASTER(0,"ADM",adm, RepID)) q:RepID=""  d
	.S RepTypeDr = ""
	.S recordID = $p(^DHCADVMASTER(RepID), "^", 1)
	.Q:recordID=""
	.S RepTypeDr = $p(^DHCADVMASTER(RepID), "^", 2)  
	.s:(RepTypeDr '[ "||") RepType = $p(^DHCMEDADREVT(RepTypeDr), "^", 2)      //表单描述
	.q:RepType'="药品不良事件"
	.s:ResultList="" ResultList=##class(web.DHCADVCOMMONPRINT).GetPrintData(RepID)
	.s:ResultList'="" ResultList=ResultList_"[next]"_##class(web.DHCADVCOMMONPRINT).GetPrintData(RepID)
 	q ResultList
}

Storage Default
{
<Data name="DHCADVInterFaceForPortalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCADVInterFaceForPortalD</DataLocation>
<DefaultData>DHCADVInterFaceForPortalDefaultData</DefaultData>
<IdLocation>^web.DHCADVInterFaceForPortalD</IdLocation>
<IndexLocation>^web.DHCADVInterFaceForPortalI</IndexLocation>
<StreamLocation>^web.DHCADVInterFaceForPortalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
