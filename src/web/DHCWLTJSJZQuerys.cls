Class web.DHCWLTJSJZQuerys Extends %RegisteredObject
{

/// Creator：		CHENYI
/// CreatDate：	2019-08-06
/// Description：	急诊留观信息
/// Table：			dhc_admvisitstatus  ，dhc_pacvisitstatus
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSJZQuerys","QueryEmergencyObservation","2019-02-01","2019-03-10","","")
Query QueryEmergencyObservation(startDate As %String, endDate As %String, hosId As %String = "", visitStatusId As %String = "") As %Query(ROWSPEC = "visitStatusDesc:%String,regNo:%String,patName:%String,dateDesc:%String,bedNo:%String,locDesc:%String,diag:%String") [ SqlProc ]
{
}

ClassMethod QueryEmergencyObservationExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", visitStatusId As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k visitStatusArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(visitStatusId,",",.visitStatusArr)

	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
   .s visitStatus=0 f  s visitStatus=$o(^DHCADMVisitStatus(0,"DateStatus",date,visitStatus)) q:visitStatus=""  d
   ..q:('$d(visitStatusArr(visitStatus)))&&($g(visitStatusId)'="")
   ..i $d(^DHCPACVisitStatus(visitStatus)) s visitStatusDesc=$p(^DHCPACVisitStatus(visitStatus),"^",2)
   ..e  s visitStatusDesc=""
   ..q:(visitStatusDesc'["留观")
   ..q:visitStatusDesc=""
   ..s rowId=0 f  s rowId=$o(^DHCADMVisitStatus(0,"DateStatus",date,visitStatus,rowId)) q:rowId=""  d
   ...s adm=$p(^DHCADMVisitStatus(rowId),"^",1)
   ...s papmi=$p(^PAADM(adm),"^",1)
   ...s regNo=$$GetPapmiNo^DHCWLCommon(papmi)   //登记号
   ...s patName=$$GetPapmiName^DHCWLCommon(papmi)	//病人姓名
   ...s dateDesc=$zd(date,3)   //日期描述
   ...s bedNo=$$GetBed^DHCWLCommon(adm)  //床位号
   ...s locDr=$p($g(^PAADM(adm)),"^",4)   //科室
   ...s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(locDr)
   ...q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
   ...s locDesc=$p(^CTLOC(locDr),"^",2)
   ...s:locDesc["-" locDesc=$p(locDesc,"-",2)
   ...s diag=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(adm,"")
   ...s diag=$p(diag,"^",1)
   ...d OutRow
    
   k ^||TEMPDHCWL($j)
 	Quit $$$OK
 	
OutRow
	s Data=$lb(visitStatusDesc,regNo,patName,dateDesc,bedNo,locDesc,diag)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryEmergencyObservationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmergencyObservationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEmergencyObservationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmergencyObservationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		CHENYI
/// CreatDate：	2019-08-06
/// Description：	急诊科医嘱统计（只统计代码维护中的内容）
/// Table：			pa_adm
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSJZQuerys","QueryOrderInfo","2019-02-01","2019-03-10","","","JZKGZL")
Query QueryOrderInfo(startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", bsCode As %String = "") As %Query(ROWSPEC = "dateDesc:%String,itmMastBSDesc:%String,num:%Float") [ SqlProc ]
{
}

ClassMethod QueryOrderInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", bsCode As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k resDepArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(resDepId,",",.resDepArr) 
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
   .s time=0 f  s time=$o(^OEORDi(0,"DateExec",date,time)) q:time=""  d
   ..s ordDr=0 f  s ordDr=$o(^OEORDi(0,"DateExec",date,time,ordDr)) q:ordDr=""  d
   ...s ordSubDr=0 f  s ordSubDr=$o(^OEORDi(0,"DateExec",date,time,ordDr,ordSubDr)) q:ordSubDr=""  d
   ....s itmMastDR=$p(^OEORD(ordDr,"I",ordSubDr,1),"^",2)
   ....s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(itmMastDR,bsCode,"")
   ....q:($p(bsret,"^",1)="")||($ZCVT($p(bsret,"^",1),"U")="NULL")
   ....s recDep=$P($G(^OEORD(ordDr,"I",ordSubDr,3)),"^",6)	;接收科室
 	....s resDep=$P($G(^OEORD(ordDr,"I",ordSubDr,7)),"^",2)	;下医嘱科室   OEORI_UserDepartment_DR
 	....i resDep="" s resDep="999999"
 	....s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(resDep)
 	....q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	....q:('$d(resDepArr(resDep)))&&($g(resDepId)'="")     //可以在raq中传入急诊科id，进行过滤
 	....s resDepDesc=$P($g(^CTLOC(resDep)),"^",2)
 	....q:resDepDesc'["急诊"
 	....;s resDoc=$P($G(^OEORD(ord,"I",ordSub,1)),"^",11)   //20150803   OEORI_Doctor_DR
 	....;s resUser=$P($G(^OEORD(ord,"I",ordSub,7)),"^",1)
 	....;下医嘱医生,根据user去获取下医嘱医生,长期医嘱或者非医护录入,可能导致为空
 	....;i resUser'="" s resDoc=$p($g(^SSU("SSUSR",+resUser)),"^",14)	
 	....;e  s resDoc=""
 	....
   ....s ordExeDr=0 f  s ordExeDr=$o(^OEORDi(0,"DateExec",date,time,ordDr,ordSubDr,ordExeDr)) q:ordExeDr=""  d
   .....s statu=$p(^OEORD(ordDr,"I",ordSubDr,"X",ordExeDr),"^",16)
   .....q:statu=""
   .....s statuDesc=$p(^OEC("STAT",statu),"^",2)   //SELECT * FROM OEC_Order_AdminStatus
   .....q:statuDesc'["执行"
   .....s ^||TEMPDHCWL($j,"data",date,itmMastDR)=$g(^||TEMPDHCWL($j,"data",date,itmMastDR))+1
    
    //output
    s date=""
    f  s date=$o(^||TEMPDHCWL($j,"data",date)) q:date=""  d
    .s dateDesc=$zd(date,3)
    .s itmMastDR="" f  s itmMastDR=$o(^||TEMPDHCWL($j,"data",date,itmMastDR)) q:itmMastDR=""  d
    ..s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(itmMastDR,bsCode,"")
    ..s itmMastBSDesc=$p(bsret,"^",1)
    ..s num=$g(^||TEMPDHCWL($j,"data",date,itmMastDR))
    ..d OutRow
    
    k ^||TEMPDHCWL($j)
 	Quit $$$OK
 	
OutRow
	s Data=$lb(dateDesc,itmMastBSDesc,num)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：		CHENYI
/// CreatDate：	2019-07-09
/// Description：	查询急诊科各患者的时间点用时
/// Table：			pa_adm，oe_orditem
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSJZQuerys","QueryPatTime","2019-02-01","2019-03-10",,)
Query QueryPatTime(startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "") As %Query(ROWSPEC = "regNo:%String,patName:%String,diag:%String,age:%String,sex:%String,appTimeStr:%String,regTimeStr:%String,admTimeStr:%String,ariveTimeStr:%String,diagTimeStr:%String,oeoriTimeStr:%String,prtTimeStr:%String") [ SqlProc ]
{
}

ClassMethod QueryPatTimeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)
	//1.1-将门诊科室id串转换成数组
	k depArr
	s depNum=$l($g(depId),",")
	i $g(depId)'="" d
	.f i=1:1:depNum d
	..s id=$p($g(depId),",",i)
	..s depArr(id)=""
	
	//1.2-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	//门诊
	f date=startDate:1:endDate d
   .s admId=0 f  s admId=$o(^PAADMi("PAADM_AdmDate",date,admId)) q:admId=""  d
   ..q:$P(^PAADM(admId),"^",2)="I"								;非住院病人，不计入。
 	..q:$p(^PAADM(admId),"^",20)="C"  //退号患者过滤	
 	..s depDr=$p(^PAADM(admId),"^",4)   //科室
 	..s depDesc=$p(^CTLOC(depDr),"^",2)
 	..q:depDesc'["急诊"
 	..q:('$d(depArr(depDr)))&&($g(depId)'="")  //也可以在raq中输入急诊科的id来做过滤
 	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(depDr)
 	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	..s ariveStr=##class(web.DHCWLTJSCommonFunction).GetArriveTimeByAdm(admId)
 	..i ariveStr'="" d
 	...s ariveDate=$p(ariveStr,"^",1)
 	...s ariveTime=$p(ariveStr,"^",2)
 	...s ariveTimeStr=$zd(ariveDate,3)_" "_$zt(ariveTime,1)    //到达时间
 	..e  s ariveTimeStr=""
 	..s appointmentStr=##class(web.DHCWLTJSCommonFunction).GetAppointmentTimeByAdm(admId)
 	..i appointmentStr'="" d
 	...s appDate=$p(appointmentStr,"^",1)
 	...s appTime=$p(appointmentStr,"^",2)
 	...s appTimeStr=$zd(appDate,3)_" "_$zt(appTime,1)   //预约时间
 	..e  s appTimeStr=""
 	..s regDr=$o(^User.DHCRegistrationFeeI("ADM"," "_admId,""),-1)
 	..i regDr'="" d
 	...s regDate=$li(^User.DHCRegistrationFeeD(regDr),15)  //挂号日期
 	...s regTime=$li(^User.DHCRegistrationFeeD(regDr),16)  //挂号时间
 	...s regTimeStr=$zd(regDate,3)_" "_$zt(regTime,1)
 	..e  s regTimeStr=""
 	..s admDate=$p(^PAADM(admId),"^",6)
 	..s admTime=$p(^PAADM(admId),"^",7)
 	..s admTimeStr=$zd(admDate,3)_" "_$zt(admTime,1)  //就诊时间串
 	..s diagStr=##class(web.DHCWLTJSCommonFunction).GetFirstDiagTimeByAdm(admId)
 	..i diagStr'="" d
 	...s diagDate=$p(diagStr,"^",1)
 	...s diagTime=$p(diagStr,"^",2)
 	...s diagTimeStr=$zd(diagDate,3)_" "_$zt(diagTime,1)   //第一次诊断时间
 	..e  s diagTimeStr=""
 	..s oeoriStr=##class(web.DHCWLTJSCommonFunction).GetFirstOeoriTimeByAdm(admId)
 	..i oeoriStr'="" d
 	...s oeoriDate=$p(oeoriStr,"^",1)
 	...s oeoriTime=$p(oeoriStr,"^",2)
 	...s oeoriTimeStr=$zd(oeoriDate,3)_" "_$zt(oeoriTime,1)   //第一次医嘱时间
 	..e  s oeoriTimeStr=""
 	..s prtStr=##class(web.DHCWLTJSCommonFunction).GetPRTTimeByAdm(admId)
 	..i prtStr'="" d
 	...s prtDate=$p(prtStr,"^",1)
 	...s prtTime=$p(prtStr,"^",2)
 	...s prtTimeStr=$zd(prtDate,3)_" "_$zt(prtTime,1)   //结算时间
 	..e  s prtTimeStr=""
 	..s papmi=$p(^PAADM(admId),"^",1)
 	..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)	//登记号
 	..s patName=$$GetPapmiName^DHCWLCommon(papmi)	//患者姓名
 	..s diag=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(admId,"")
 	..s diag=$p(diag,"^",1)
 	..s age=##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
 	..s sex=$$GetSex^DHCWLCommon(papmi) 
 	..d OutRow
 	
 	Quit $$$OK
OutRow
	s Data=$lb(regNo,patName,diag,age,sex,appTimeStr,regTimeStr,admTimeStr,ariveTimeStr,diagTimeStr,oeoriTimeStr,prtTimeStr)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryPatTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPatTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatTimeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
