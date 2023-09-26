Class web.DHCWLTJSQTQuerys Extends %RegisteredObject
{

/// Creator：		CHENYI
/// CreatDate：		2019-07-09
/// Description：	住院证使用情况统计
/// Table：			pa_adm，oe_orditem
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryDHCDocIPBookingInfo","2019-09-01","2019-09-10","","","")
Query QueryDHCDocIPBookingInfo(startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", docId As %Text = "") As %Query(ROWSPEC = "oDepDesc:%String,oDocDesc:%String,szrs:%Float,wzrs:%Float,yzrs:%Float") [ SqlProc ]
{
}

ClassMethod QueryDHCDocIPBookingInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", docId As %Text = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)

	k depArr  //存选择的收治科室（门诊）
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(depId,",",.depArr) 
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k docArr   //存开住院证的医生（门诊）
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(docId,",",.docArr) 

	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate d
	.s admId="" f  s admId=$o(^PAADMi("PAADM_AdmDate",date,admId)) q:admId=""  d
 	..q:$P(^PAADM(admId),"^",2)'="I"  //门诊患者过滤
 	..q:$P(^PAADM(admId),"^",20)="P"
 	..q:$P(^PAADM(admId),"^",20)="C"
 	..s docIPBKDr=$o(^DHCDocIPBK(0,"EpisodeIDTo",admId,""),-1)
 	..q:docIPBKDr="" 
 	..s admFrom=$p(^DHCDocIPBK(docIPBKDr),"^",2)
 	..s oDepDr=$p(^PAADM(admFrom),"^",4)
 	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(oDepDr)
	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	..q:('$d(depArr(oDepDr)))&&($g(depId)'="")
	..s oDocDr=$p(^PAADM(admFrom),"^",9)
	..q:oDocDr=""
	..q:('$d(docArr(oDocDr)))&&($g(docId)'="")
	..s ^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"sz")=$g(^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"sz"))+1 //收治人数
	
	f date=startDate:1:endDate d
	.s bkId=0 f  s bkId=$o(^DHCDocIPBK(0,"BookingDate",date,bkId)) q:bkId=""  d
	..s admTo=$p(^DHCDocIPBK(bkId),"^",3)   //住院就诊号
	..s admFrom=$p(^DHCDocIPBK(bkId),"^",2)
	..s oDepDr=$p(^PAADM(admFrom),"^",4)
	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(oDepDr)
 	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	..q:('$d(depArr(oDepDr)))&&($g(depId)'="")
	..s oDocDr=$p(^PAADM(admFrom),"^",9)
	..q:oDocDr=""
	..q:('$d(docArr(oDocDr)))&&($g(docId)'="")
	..i (admTo="") s ^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"wz")=$g(^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"wz"))+1 //开住院证未住院人数
	..e  d
	...i ($P(^PAADM(admTo),"^",20)="P")||($P(^PAADM(admTo),"^",20)="C") s ^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"wz")=$g(^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"wz"))+1 //开住院证未住院人数
	...e  s ^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"yz")=$g(^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"yz"))+1 //开住院证且住院人数
	
	//output
	s oDepDr=""
	f  s oDepDr=$o(^||TEMPDHCWL($j,"data",oDepDr)) q:oDepDr=""  d
	.s oDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(oDepDr)
	.s oDocDr="" f  s oDocDr=$o(^||TEMPDHCWL($j,"data",oDepDr,oDocDr)) q:oDocDr=""  d
	..s oDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(oDocDr)
	..s szrs=$g(^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"sz"))
	..s wzrs=$g(^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"wz"))
	..s yzrs=$g(^||TEMPDHCWL($j,"data",oDepDr,oDocDr,"yz"))
 	..d OutRow
 	
 	Quit $$$OK
OutRow
	s Data=$lb(oDepDesc,oDocDesc,szrs,wzrs,yzrs)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryDHCDocIPBookingInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCDocIPBookingInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDHCDocIPBookingInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCDocIPBookingInfoExecute ]
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
/// Description：	会诊明细表
/// Table：			pa_adm，oe_orditem
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryEmConsultDetail","2019-02-01","2019-03-10",,,,)
Query QueryEmConsultDetail(startDate As %String, endDate As %String, hosId As %String = "", ecDepId As %Text = "", ecDocId As %Text = "", ecStatus As %String = "") As %Query(ROWSPEC = "nDocDesc:%String,appDepDesc:%String,patName:%String,regNo:%String,diag:%String,trePro:%String,cTypeDesc:%String,outFlag:%String,appDateDesc:%String,appTimeDesc:%String,cDocDesc:%String,appDocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryEmConsultDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", ecDepId As %Text = "", ecDocId As %Text = "", ecStatus As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)
	//1.1-将门诊科室id串转换成数组
	k depArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(ecDepId,",",.depArr) 
	//1.2-将院区id串转换成数组
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k docArr   //存会诊医生
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(ecDocId,",",.docArr) 
	k statusArr  //存会诊状态
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(ecStatus,",",.statusArr) 
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate d
	.s ecId=0
   .f  s ecId=$o(^DHCEMCON(0,"ReqDateIndex",date,ecId)) q:ecId=""  d
   ..s appDepDr=$p(^DHCEMCON(ecId),"^",2)  //申请会诊科室
   ..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(appDepDr)
 	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	..q:('$d(depArr(appDepDr)))&&($g(ecDepId)'="")
 	..
   ..s appDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(appDepDr)
   ..s appDocDr=$p(^DHCEMCON(ecId),"^",5)  //申请人 指向ss_user
   ..s appDocDr=$p($g(^SSU("SSUSR",+appDocDr)),"^",14)
   ..q:('$d(docArr(appDocDr)))&&($g(ecDocId)'="")
   ..s appDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(appDocDr)
   ..s adm=$p(^DHCEMCON(ecId),"^",1)
   ..s papmi=$p(^PAADM(adm),"^",1)
   ..s patName=$$GetPapmiName^DHCWLCommon(papmi)  //患者姓名
   ..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)	//登记号
   ..s diag=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(adm,"M")
   ..s diag=$p(diag,"^",1)
   ..s trePro=$p(^DHCEMCON(ecId),"^",7)  //会诊的理由和目的
   ..s cTypeDr=$p(^DHCEMCON(ecId),"^",8)  
   ..;S cTypeDesc=$p(^DHCEMCDT(cTypeDr),"^",2)  //会诊类别
   ..S cTypeDesc=$p(^DHCEMCDI(cTypeDr),"^",2)  //会诊类别
   ..s outFlag=$p(^DHCEMCON(ecId),"^",24)
   ..s outFlag=$case(outFlag,"N":"院内","Y":"院外")
   ..s appTime=$p(^DHCEMCON(ecId),"^",4)
   ..s appDateDesc=$zd(date,3)
   ..s appTimeDesc=$zt(appTime,1)
   ..s appStatuDr=$p(^DHCEMCON(ecId),"^",18)
   ..s:appStatuDr="" appStatuDr="999999"
   ..q:('$d(statusArr(appStatuDr)))&&($g(ecStatus)'="")
   ..s subDr=0 f  s subDr=$o(^DHCEMCON(ecId,"I",subDr)) q:subDr=""  d
   ...s cDepDr=$p(^DHCEMCON(ecId,"I",subDr),"^",1)  //会诊科室
   ...i cDepDr'="" s cDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(cDepDr)
   ...e  s cDepDesc=""
   ...s cDocDr=$p(^DHCEMCON(ecId,"I",subDr),"^",3)  //实际会诊医生
   ...i cDocDr'="" s cDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(cDocDr)
   ...e  s cDocDesc=""
   ...s nDocDr=$p(^DHCEMCON(ecId,"I",subDr),"^",2)  //要求会诊医生
   ...i nDocDr'="" s nDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(nDocDr)
   ...e  s nDocDesc=""
   ...s num=1
   ...d OutRow
 	
 	Quit $$$OK
OutRow
	s Data=$lb(nDocDesc,appDepDesc,patName,regNo,diag,trePro,cTypeDesc,outFlag,appDateDesc,appTimeDesc,cDocDesc,appDocDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryEmConsultDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmConsultDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEmConsultDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmConsultDetailExecute ]
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
/// Description：	已会诊数量统计总表
/// Table：			pa_adm，oe_orditem
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryEmConsult","2019-02-01","2019-03-10",,)
Query QueryEmConsult(startDate As %String, endDate As %String, hosId As %String = "", ecDepId As %Text = "") As %Query(ROWSPEC = "appDepDesc:%String,cDepDesc:%String,cDocDesc:%String,num:%Float") [ SqlProc ]
{
}

ClassMethod QueryEmConsultExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", ecDepId As %Text = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)
	//1.1-将门诊科室id串转换成数组
	k depArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(ecDepId,",",.depArr) 
	//1.2-将院区id串转换成数组
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate d
	.s ecId=0
   .f  s ecId=$o(^DHCEMCON(0,"ReqDateIndex",date,ecId)) q:ecId=""  d
   ..s appDepDr=$p(^DHCEMCON(ecId),"^",2)  //申请会诊科室
   ..s appDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(appDepDr)
   ..s appDocDr=$p(^DHCEMCON(ecId),"^",5)  //申请人 指向ss_user
   ..;s subDr=$o(^DHCEMCON(ecId,"I",""),-1)
   ..s subDr=0 f  s subDr=$o(^DHCEMCON(ecId,"I",subDr)) q:subDr=""  d
   ...
   ...s cDepDr=$p(^DHCEMCON(ecId,"I",subDr),"^",1)  //会诊科室
   ...q:cDepDr=""  //会诊科室是空的，过滤
   ...s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(cDepDr)
	...q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	...q:('$d(depArr(cDepDr)))&&($g(ecDepId)'="")
   ...s cDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(cDepDr)
   ...s cDocDr=$p(^DHCEMCON(ecId,"I",subDr),"^",3)  //会诊医生
   ...q:cDocDr=""   //若未会诊，这个医生为空，不统计
   ...s cDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(cDocDr)
   ...s num=1
 	...d OutRow
 	
 	Quit $$$OK
OutRow
	s Data=$lb(appDepDesc,cDepDesc,cDocDesc,num)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryEmConsultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmConsultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEmConsultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmConsultExecute ]
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
/// Description：	查询各患者的时间点用时
/// Table：			pa_adm，oe_orditem
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryPatTime","2019-02-01","2019-03-10",,)
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
 	..q:('$d(depArr(depDr)))&&($g(depId)'="")
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

/// Creator：		CHENYI
/// CreatDate：		2019-07-29
/// Description：	高危危患者统计
/// Table：			pa_adm
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryGWHZInfo","2019-02-01","2019-03-10","","","")
Query QueryGWHZInfo(startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", gwzys As %String = "") As %Query(ROWSPEC = "regNo:%String,medNo:%String,patName:%String,admDateD:%String,admDep:%String,disDate:%String,disDep:%String,diagDesc:%String,firstOrReson:%String,gwys:%String") [ SqlProc ]
{
}

ClassMethod QueryGWHZInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", gwzys As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	//1.1-将门诊科室id串转换成数组
	k depArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(depId,",",.depArr) 
	//1.2-将院区id串转换成数组
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k gwArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(gwzys,",",.gwArr) 
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate d
    .s admId=0 f  s admId=$o(^PAADMi("DischargeDateExt",date,admId)) q:admId=""  d
    ..q:$P(^PAADM(admId),"^",2)'="I"								;非住院病人，不计入。
 	..q:$p(^PAADM(admId),"^",20)="C"	
 	..s gwys=##class(web.DHCWLStatisticsInterface).GetGWYSByAdm(admId)
 	..;q:gwys=""
 	..;q:('$d(gwArr(gwys)))&&($g(gwzys)'="")
 	..s papmi=$p(^PAADM(admId),"^",1)
 	..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)   //登记号
 	..s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(admId)  //住院号
 	..s patName=$$GetPapmiName^DHCWLCommon(papmi)  //患者姓名
 	..s admDate=$P(^PAADM(admId),"^",6)   //入院时间
 	..s admDateD=$zd(admDate,3)  //当前入院时间
 	..s disDepDr=$P(^PAADM(admId),"^",4)
 	..q:('$d(depArr(disDepDr)))&&($g(depId)'="")
 	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(disDepDr)
 	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	..s disDep=$P(^CTLOC(disDepDr),"^",2)  //当前出院科室
 	..s depWardStr=$$GetFirstLocWard^DHCMRIPLoad(admId)
 	..s admDepDr=$P(depWardStr,"^",1)
 	..s admDep=$P(^CTLOC(admDepDr),"^",2)	//当前入院科室
 	..s disDate=$zd(date,3)  //当前出院时间
 	..s diagDesc=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(admId,"")
 	..s diagDesc=$p(diagDesc,"^",1)
 	..s firstOrReson=$p(^PAADM(admId),"^",72)
 	..s firstOrReson=$case(firstOrReson,"R":"复诊",:"初诊")
   ..d OutRow
 	Quit $$$OK
OutRow
	s Data=$lb(regNo,medNo,patName,admDateD,admDep,disDate,disDep,diagDesc,firstOrReson,gwys)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGWHZInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGWHZInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryGWHZInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGWHZInfoExecute ]
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
/// CreatDate：		2019-06-24
/// Description：	医嘱执行记录统计（只统计代码维护中的内容）
/// Table：			pa_adm
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryExeOrderInfo","2019-09-01","2019-09-23","","","","ZXGZL")
Query QueryExeOrderInfo(startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", recDepId As %Text = "", bsCode As %String = "") As %Query(ROWSPEC = "recDepDesc:%String,itmMastBSDesc:%String,num:%Float") [ SqlProc ]
{
}

ClassMethod QueryExeOrderInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", resDepId As %Text = "", recDepId As %Text = "", bsCode As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	k ^||TEMPDHCWL($j)
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
	k resDepArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(resDepId,",",.resDepArr) 
	k recDepArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(recDepId,",",.recDepArr) 
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
    .s time=0 f  s time=$o(^OEORDi(0,"DateExec",date,time)) q:time=""  d
    ..s ordDr=0 f  s ordDr=$o(^OEORDi(0,"DateExec",date,time,ordDr)) q:ordDr=""  d
    ...s ordSubDr=0 f  s ordSubDr=$o(^OEORDi(0,"DateExec",date,time,ordDr,ordSubDr)) q:ordSubDr=""  d
    ....s itmMastDR=$p(^OEORD(ordDr,"I",ordSubDr,1),"^",2)
    ....s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(itmMastDR,bsCode,"")
    ....;q:($p(bsret,"^",1)="")||($ZCVT($p(bsret,"^",1),"U")="NULL")
    ....s recDep=$P($G(^OEORD(ordDr,"I",ordSubDr,3)),"^",6)	;接收科室
    ....q:(recDep="")||(recDep=0)
    ....q:('$d(recDepArr(recDep)))&&($g(recDepId)'="")
    ....s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(recDep)
   	....q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
 	....;s resDep=$P($G(^OEORD(ordDr,"I",ordSubDr,1)),"^",3)	;下医嘱科室   OEORI_OrdDept_DR
 	....s resDep=$P($G(^OEORD(ordDr,"I",ordSubDr,7)),"^",2)	;下医嘱科室   OEORI_UserDepartment_DR
 	....i resDep="" s resDep="999999"
 	....q:('$d(resDepArr(resDep)))&&($g(resDepId)'="")
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
    .....s ^||TEMPDHCWL($j,"data",recDep,itmMastDR)=$g(^||TEMPDHCWL($j,"data",recDep,itmMastDR))+1
    
    //output
    s recDep=""
    f  s recDep=$o(^||TEMPDHCWL($j,"data",recDep)) q:recDep=""  d
    .s recDepDesc=$p(^CTLOC(recDep),"^",2)
    .s:recDepDesc["-" recDepDesc=$p(recDepDesc,"-",2)
    .s itmMastDR="" f  s itmMastDR=$o(^||TEMPDHCWL($j,"data",recDep,itmMastDR)) q:itmMastDR=""  d
    ..s bsret=##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(itmMastDR,bsCode,"")
    ..s itmMastBSDesc=$p(bsret,"^",1)
    ..s num=$g(^||TEMPDHCWL($j,"data",recDep,itmMastDR))
    ..d OutRow
    k ^||TEMPDHCWL($j)
 	Quit $$$OK
 	
OutRow
	s Data=$lb(recDepDesc,itmMastBSDesc,num)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryExeOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExeOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryExeOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExeOrderInfoExecute ]
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
/// CreatDate：		2019-06-24
/// Description：	出院患者各次再入院间隔统计
/// Table：			pa_adm
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryPatAgaimIn","2019-05-20","2019-05-20","","","PAADM_AdmDate")
Query QueryPatAgaimIn(startDate As %String, endDate As %String, hosId As %String, depId As %Text, dateType As %String) As %Query(ROWSPEC = "regNo:%String,medNo:%String,patName:%String,admDateD:%String,admDep:%String,disDate:%String,disDep:%String,preDisDateD:%String,preDisDep:%String,days:%Float,age:%String,sex:%String,diag:%String") [ SqlProc ]
{
}

ClassMethod QueryPatAgaimInExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, depId As %Text, dateType As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
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

	f date=startDate:1:endDate d
    .s admId=0 f  s admId=$o(^PAADMi(dateType,date,admId)) q:admId=""  d   //DischDate  PAADM_AdmDate
    ..q:$P(^PAADM(admId),"^",2)'="I"								;非住院病人，不计入。
 	..q:$p(^PAADM(admId),"^",20)="C"
 	..q:$p(^PAADM(admId),"^",20)="P"  //预约患者过滤	
 	..s papmi=$p(^PAADM(admId),"^",1)
 	..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)   //登记号
 	..s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(admId)  //住院号
 	..s patName=$$GetPapmiName^DHCWLCommon(papmi)  //患者姓名
 	..s admDate=$P(^PAADM(admId),"^",6)   //入院时间
 	..s admDateD=$zd(admDate,3)  //当前入院时间
 	..s disDepDr=$P(^PAADM(admId),"^",4)
 	..s disDep=$P(^CTLOC(disDepDr),"^",2)  //当前出院科室
 	..s depWardStr=$$GetFirstLocWard^DHCMRIPLoad(admId)
 	..s age=##class(web.DHCBillInterface).GetPapmiAge(papmi,admId)
 	..s sex=$$GetSex^DHCWLCommon(papmi) 
 	..s diag=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(admId,"")
 	..s diag=$p(diag,"^",1)
 	..s admDepDr=$P(depWardStr,"^",1)
 	..s admDep=$P(^CTLOC(admDepDr),"^",2)	//当前入院科室
 	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(admDepDr)
	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="") 
	..q:('$d(depArr(admDepDr)))&&($g(depId)'="") 
 	..s disDate=$P(^PAADM(admId),"^",17)
 	..i disDate'="" s disDate=$zd(disDate,3)  //当前出院时间
 	..s stopFlag=0
   ..s preAdm=admId f  s preAdm=$o(^PAPERdr(papmi,"ADM","I",preAdm),-1) q:(preAdm="")||(stopFlag=1)  d
   ...q:$p(^PAADM(preAdm),"^",20)="C"
   ...q:$p(^PAADM(preAdm),"^",20)="P"
   ...s preDisDate=$P(^PAADM(preAdm,"DHC"),"^",29)
   ...s preDisDateD=$zd(preDisDate,3)
   ...s preDisDepDr=$P(^PAADM(preAdm),"^",4)
   ...s preDisDep=$P(^CTLOC(preDisDepDr),"^",2)
   ...s days=admDate-preDisDate
   ...d OutRow
   ...s stopFlag=stopFlag+1
   ...//输出本次就诊记录之后保存等下次循环使用
   ...s admDate=$P(^PAADM(preAdm),"^",6)
	...s admDateD=$zd(admDate,3)
	...s disDepDr=$P(^PAADM(preAdm),"^",4)
 	...s disDep=$P(^CTLOC(disDepDr),"^",2)  //当前出院科室
 	...s depWardStr=$$GetFirstLocWard^DHCMRIPLoad(preAdm)
 	...s admDepDr=$P(depWardStr,"^",1)
 	...i admDepDr'="" s admDep=$P(^CTLOC(admDepDr),"^",2)	//当前入院科室
 	...e  s admDep=""
 	...s disDate=$zd(date,3)  //当前出院时间
 	Quit $$$OK
OutRow
	s Data=$lb(regNo,medNo,patName,admDateD,admDep,disDate,disDep,preDisDateD,preDisDep,days,age,sex,diag)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryPatAgaimInClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatAgaimInExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPatAgaimInFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatAgaimInExecute ]
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
/// CreatDate：		2019-05-29
/// Description：	各类病人明细
/// Table：			pa_adm
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryPatDetail","2019-09-01","2019-09-25","","","","死亡","")
Query QueryPatDetail(startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", docId As %Text = "", dataType As %String = "", admType As %String = "") As %Query(ROWSPEC = "regNo:%String,medNo:%String,patName:%String,age:%String,sex:%String,diag:%String,admDateDesc:%String,disDateDesc:%String,fee:%Float,remarksDesc1:%String,remarksDesc2:%String") [ SqlProc ]
{
}

ClassMethod QueryPatDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", docId As %Text = "", dataType As %String = "", admType As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	//1.1-将门诊科室id串转换成数组
	k depArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(depId,",",.depArr) 
	//1.2-将门诊id串转换成数组
	k docArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(docId,",",.docArr)
	//1.3-将院区id串转换成数组
	k hosArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr)
	k typeArr
	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(admType,",",.typeArr)
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	//门诊
	i (admType["E")||(admType["O")||(admType["H")||(admType=""){
		f date=startDate:1:endDate d
    	.s adm=0 f  s adm=$o(^PAADMi("PAADM_AdmDate",date,adm)) q:adm=""  d
    	..s papmi=$p(^PAADM(adm),"^",1)
    	..s type=$p(^PAADM(adm),"^",2)
    	..q:type="I"  //住院直接过滤
    	..q:('$d(typeArr(type)))&&($g(admType)'="")
    	..s depDr=$p(^PAADM(adm),"^",4)
    	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(depDr)
    	..s docDr=$p(^PAADM(adm),"^",9)
    	..q:docDr=""
    	..;i docDr="" s docDr="999999"
    	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
    	..q:('$d(depArr(depDr)))&&($g(depId)'="")
    	..q:('$d(docArr(docDr)))&&($g(docId)'="")
    	..s visitStatu=$p(^PAADM(adm),"^",20)
    	..q:visitStatu="C"  ;退院过滤
    	..s str=##class(web.DHCWLStatisticsInterface).GetDetPatInfoActive(adm,dataType)
    	..s isFlag=$p(str,"^",1)
    	..q:isFlag'=1
    	..s remarksDesc1=$p(str,"^",2)  //备注1
    	..s remarksDesc2=$p(str,"^",3)	//备注2
    	..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)        	//登记号
    	..s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)		//住院号
    	..s patName=$$GetPapmiName^DHCWLCommon(papmi)		//患者姓名
    	..s age=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)
    	..s sex=$$GetSex^DHCWLCommon(papmi)
    	..s diagStr=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(adm,"")
    	..s diag=$p(diagStr,"^",1)
    	..s admDateDesc=$zd(date,3)
    	..s disDateDesc=""
    	..s feeStr=##class(web.DHCWLTJSCommonFunction).GetTotalFeeByAdm(adm)
    	..s fee=$p(feeStr,"^",1)
    	..d OutRow
	} 
	i (admType["I")||(admType="") {
		f date=startDate:1:endDate d
    	.s adm=0 f  s adm=$o(^PAADMi("DischargeDateExt",date,adm)) q:adm=""  d   //护士最终结算时间
    	..s papmi=$p(^PAADM(adm),"^",1)
    	..s type=$p(^PAADM(adm),"^",2)
    	..q:type'="I"  //非住院直接过滤
    	..q:('$d(typeArr(type)))&&($g(admType)'="")
    	..s depDr=$p(^PAADM(adm),"^",4)
    	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(depDr)
    	..s docDr=$p(^PAADM(adm),"^",9)
    	..;i docDr="" s docDr="999999"
    	..q:docDr=""
    	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
    	..q:('$d(depArr(depDr)))&&($g(depId)'="")
    	..q:('$d(docArr(docDr)))&&($g(docId)'="")
    	..s visitStatu=$p(^PAADM(adm),"^",20)
    	..q:visitStatu="C"  ;退院过滤
    	..s str=##class(web.DHCWLStatisticsInterface).GetDetPatInfoActive(adm,dataType)
    	..s isFlag=$p(str,"^",1)
    	..q:isFlag'=1
    	..s remarksDesc1=$p(str,"^",2)  //备注1
    	..s remarksDesc2=$p(str,"^",3)	//备注2
    	..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)        	//登记号
    	..s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(adm)		//住院号
    	..s patName=$$GetPapmiName^DHCWLCommon(papmi)		//患者姓名
    	..s age=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)
    	..s sex=$$GetSex^DHCWLCommon(papmi)
    	..s diagStr=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(adm,"")
    	..s diag=$p(diagStr,"^",1)
    	..s admDate=$p(^PAADM(adm),"^",6)
    	..s admDateDesc=$zd(admDate,3)
    	..s disDateDesc=$zd(date,3)
    	..s feeStr=##class(web.DHCWLTJSCommonFunction).GetTotalFeeByAdm(adm)
    	..s fee=$p(feeStr,"^",1)
    	..d OutRow
	}
 	Quit $$$OK	
OutRow
	s Data=$lb(regNo,medNo,patName,age,sex,diag,admDateDesc,disDateDesc,fee,remarksDesc1,remarksDesc2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryPatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatDetailExecute ]
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
/// CreatDate：		2018-06-20
/// Description：	会诊明细
/// Table：			DHC_Consultation
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryConsultation","2018-11-01","2018-11-12",,,,"C")
Query QueryConsultation(startDate As %String, endDate As %String, hosId As %String, depId As %Text, docId As %Text, statusId As %String) As %Query(ROWSPEC = "requestDocDesc:%String,patDepDesc:%String,patName:%String,regNo:%String,bedNo:%String,diagDesc:%String,conDesc:%String,conType:%String,conOutIn:%String,appDate:%String,appTime:%String,conDocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryConsultationExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, depId As %Text, docId As %Text, statusId As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	//1.1-将门诊科室id串转换成数组
	k depArr
	s depNum=$l($g(depId),",")
	i $g(depId)'="" d
	.f i=1:1:depNum d
	..s id=$p($g(depId),",",i)
	..s depArr(id)=""
	
	//1.2-将门诊id串转换成数组
	k docArr
	s docNum=$l($g(docId),",")
	i $g(docId)'="" d
	.f i=1:1:docNum d
	..s id=$p($g(docId),",",i)
	..s docArr(id)=""
	
	//1.3-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	
	
	//1.4-将会诊状态id串转换成数组
	k staArr
	s num=$l($g(statusId),",")
	i $g(statusId)'="" d
	.f i=1:1:num d
	..s id=$p($g(statusId),",",i)
	..s staArr(id)=""
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
    .s appLoc=0 f  s appLoc=$o(^User.DHCConsultationI("AppDep",date,appLoc)) q:appLoc=""  d
    ..s id=0 f  s id=$o(^User.DHCConsultationI("AppDep",date,appLoc,id)) q:id=""  d
    ...s Status=$list($G(^User.DHCConsultationD(id)),16)
    ...;q:(Status'="E")  ;C取消的过滤掉  V申请状态  E执行状态
    ...q:('$d(staArr(Status)))&&($g(statusId)'="")
    ...s ConsultDep=$list(^User.DHCConsultationD(id),11)   ;被邀请会诊科室
    ...i ConsultDep="" s ConsultDep=999999
    ...s ConsultDate=$list(^User.DHCConsultationD(id),10)    ;填写会诊意见日期
    ...i ConsultDate="" s ConsultDate=$list(^User.DHCConsultationD(id),17) ;yw 20170511 add
    ...i ConsultDate="" s ConsultDate=+$h
    ...;q:ConsultDate=date                                 ;会诊日期=申请日期的不考虑
    ...s requestDocDr=$list(^User.DHCConsultationD(id),20)		;要求的会诊医生1
    ...s requestDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(requestDocDr)
    ...s admId=$list(^User.DHCConsultationD(id),2)	
    ...s papmi=$p(^PAADM(admId),"^",1)
    ...s patDepDr=$$SelectLocWardDate(date,admId)				;病人科室
    ...q:('$d(depArr(patDepDr)))&&($g(depId)'="")
    ...s ihosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(patDepDr)
    ...s:ihosDr="" ihosDr="999999"
	...q:('$d(hosArr(ihosDr)))&&($g(hosId)'="")
    ...s patDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(patDepDr)
    ...s patName=$$GetPapmiName^DHCWLCommon(papmi)
    ...s regNo=$$GetPapmiNo^DHCWLCommon(papmi)
    ...s bedNo=$$GetBed^DHCWLCommon(admId)
    ...s diagDesc=$$GetFirstDiagByAdmDr(admId)
    ...s diagDesc=$replace(diagDesc,$c(13),"")
    ...s diagDesc=$replace(diagDesc,$c(10),"")
    ...s conDesc=$list(^User.DHCConsultationD(id),8)			;会诊建议
    ...s conType=$list(^User.DHCConsultationD(id),9)			;会诊类型
    ...s conOutIn=$list(^User.DHCConsultationD(id),14)			;院内院外
    ...s conOutIn=$case(conOutIn,"I":"院内","O":"院外")
    ...s appDate=$zd(date,3)
    ...s appTime=$list(^User.DHCConsultationD(id),6)			;申请时间
    ...s appTime=$zt(appTime,3)
    ...s conDocDr=$list(^User.DHCConsultationD(id),12)
    ...i conDocDr="" s conDocDr1="Null"
    ...e  s conDocDr1=conDocDr
    ...q:('$d(docArr(conDocDr1)))&&($g(docId)'="")
    ...i conDocDr'="" s conDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(conDocDr)
    ...e  s conDocDesc="" 
    ...d OutRow
	
 	Quit $$$OK

	
OutRow
	s Data=$lb(requestDocDesc,patDepDesc,patName,regNo,bedNo,diagDesc,conDesc,conType,conOutIn,appDate,appTime,conDocDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	
 	;根据就诊号，和时间，取出该时间病人所在病区^科室  数据来自转科表 add by chenyi.2014-3-20
	;input:时间date，paadm号
	;output:病区^科室：currwarddr_"^"_currlocdr
	;d $$selectlocwarddate^^DHCMRIPLoad(63006,310194)
SelectLocWardDate(date,admid)    ;根据就诊号，和时间，取出该时间病人所在病区^科室 add by chenyi.2014-3-20
	
	s currlocdr=""
	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:transsub=""  d    //!(flag=2)
	.s locdr=$p(^PAADM(admid,"TRANS",transsub),"^",6) 
	.s mTransSDate=$p(^PAADM(admid,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admid,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(locdr)=""
	.i $G(mTransSDate)'>$G(date) d  ;转科时间小于或等于 当时时间
	..s currlocdr=locdr
	q currlocdr
	///desc:	根据就诊号取病人的诊断信息：第一条诊断
	///output:	入院诊断^出院诊断^其他诊断
	///creator:	chenyi
	///date:	2014-3-28
	///w $$GetFirstDiagByAdmDr^DHCWLCommon(adm)		 
GetFirstDiagByAdmDr(admDr) 
	;n (admDr)
	s diag=""
	s mrAdm=$P(^PAADM(admDr),"^",61)   
	s mMRDiagnosRowId=0
	f  s mMRDiagnosRowId=$o(^MR(mrAdm,"DIA",mMRDiagnosRowId)) q:(mMRDiagnosRowId="")||($g(diag)'="")  d 	;遍历诊断子表rowid
	.s diag1=$g(^MR(mrAdm,"DIA",mMRDiagnosRowId,"DES",1))
	.i diag1'="" s diag=diag1
	.s mIDCDodeDr=$p(^MR(mrAdm,"DIA",mMRDiagnosRowId),"^",1)
	.q:$g(mIDCDodeDr)=""
	.s mMRCIDDesc=$p(^MRC("ID",mIDCDodeDr),"^",2)
	.i $g(mMRCIDDesc)'="" s diag=mMRCIDDesc

	q $g(diag)
}

ClassMethod QueryConsultationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryConsultationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryConsultationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryConsultationExecute ]
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
/// CreatDate：		2018-06-20
/// Description：	收治病人明细
/// Table：			dhcmripday
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryAdmitsNum","2019-09-01","2019-09-20",,,,"E")
Query QueryAdmitsNum(startDate As %String, endDate As %String, hosId As %String, oDepId As %Text, iDepId As %Text, dataType As %String) As %Query(ROWSPEC = "regNo:%String,medNo:%String,patName:%String,patSex:%String,oDepDesc:%String,iDepDesc:%String,cDateDesc:%String,dateDesc:%String,oDocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryAdmitsNumExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, oDepId As %Text, iDepId As %Text, dataType As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1

 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	//1.1-将门诊科室id串转换成数组
	k oDepArr
	s oDepNum=$l($g(oDepId),",")
	i $g(oDepId)'="" d
	.f i=1:1:oDepNum d
	..s id=$p($g(oDepId),",",i)
	..s oDepArr(id)=""
	
	//1.2-将住院接收科室id串转换成数组
	k iDepArr
	s iDepNum=$l($g(iDepId),",")
	i $g(iDepId)'="" d
	.f i=1:1:iDepNum d
	..s id=$p($g(iDepId),",",i)
	..s iDepArr(id)=""
	
	//1.3-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	i dataType="B"{
	f date=startDate:1:endDate d
	.s inAdmId=0 f  s inAdmId=$o(^PAADMi("PAADM_AdmDate",date,inAdmId)) q:inAdmId=""  d
	..s type=$p(^PAADM(inAdmId),"^",2)
	..q:type'="I"
	..q:$p(^PAADM(inAdmId),"^",20)="P"   //新业务变化:开住院证,住院那边已经产生就诊号,但是是预住院状态
	..q:$p(^PAADM(inAdmId),"^",20)="C"
	..i inAdmId'="" s iDepDr=$$GetFirstLocWard(inAdmId)
	..e  s iDepDr="Null"
	..i iDepDr="" s iDepDr=$p(^PAADM(inAdmId),"^",4)  //防止有就诊记录,没有专科记录的,导致的错误
	..s ihosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(iDepDr)
	..q:('$d(hosArr(ihosDr)))&&($g(hosId)'="")
	..q:('$d(iDepArr(iDepDr)))&&($g(iDepId)'="")
	..s iDepDesc=$p(^CTLOC(iDepDr),"^",2)
	..S:iDepDesc["-" iDepDesc=$p(iDepDesc,"-",2)
	..s bkId=$o(^DHCDocIPBK(0,"EpisodeIDTo",inAdmId,""))
	..q:bkId="" 	;非住院证入院的病人过滤
	..s papmi=$p(^PAADM(inAdmId),"^",1)
	..s patName=$$GetPapmiName^DHCWLCommon(papmi)
	..s patSex=$$GetSex^DHCWLCommon(papmi)
	..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)
	..s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(inAdmId)
	..s oAdmId=$p(^DHCDocIPBK(bkId),"^",2)
	..s oDepDr=$p(^PAADM(oAdmId),"^",4)
	..q:('$d(oDepArr(oDepDr)))&&($g(oDepId)'="")
	..s oDepDesc=$p(^CTLOC(oDepDr),"^",2)
	..S:oDepDesc["-" oDepDesc=$p(oDepDesc,"-",2)
	..s dateDesc=$zd(date,3)
	..s oDocDr=$p(^DHCDocIPBK(bkId),"^",7)
	..s oDocDesc=$P(^SSU("SSUSR",oDocDr),"^",2)
	..s createDate=$p(^DHCDocIPBK(bkId),"^",4)
	..s cDateDesc=$zd(createDate,3)
	..d OutRow
	}
	
	i dataType="E"{
	f date=startDate:1:endDate d
    .s time="" f  s time=$O(^DHCDocIPBK(0,"CreateDateTimeState",date,time))  q:time=""  d
    ..s stat="" f  s stat=$O(^DHCDocIPBK(0,"CreateDateTimeState",date,time,stat))  q:stat=""  d 
    ...s bookid="" f  s bookid=$O(^DHCDocIPBK(0,"CreateDateTimeState",date,time,stat,bookid))  q:bookid=""  d 
	....s oAdmId=$p(^DHCDocIPBK(bookid),"^",2) q:oAdmId=""
	....s inAdmId=$p(^DHCDocIPBK(bookid),"^",3)
	....q:inAdmId=""
	....i inAdmId'="" s iDepDr=$$GetFirstLocWard(inAdmId)
	....e  s iDepDr="Null"
	....i (iDepDr="")||(iDepDr="Null") s iDepDr=$p(^PAADM(inAdmId),"^",4)  //防止有就诊记录,没有专科记录的,导致的错误
	....q:('$d(iDepArr(iDepDr)))&&($g(iDepId)'="")
	....i iDepDr'="Null" d
	.....s iDepDesc=$p(^CTLOC(iDepDr),"^",2)
	.....S:iDepDesc["-" iDepDesc=$p(iDepDesc,"-",2)
	....e  s iDepDesc=""
	....s papmi=$p(^PAADM(oAdmId),"^",1)
	....s patName=$$GetPapmiName^DHCWLCommon(papmi)
	....s patSex=$$GetSex^DHCWLCommon(papmi)
	....s regNo=$$GetPapmiNo^DHCWLCommon(papmi)
	....s medNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(inAdmId) ;$$GetPapmiMedtare^DHCWLCommon(papmi)
	....s oDepDr=$p(^PAADM(oAdmId),"^",4)
	....q:oDepDr=""
	....s ihosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(oDepDr)
	....q:('$d(hosArr(ihosDr)))&&($g(hosId)'="")
	....q:('$d(oDepArr(oDepDr)))&&($g(oDepId)'="")
	....s oDepDesc=$p(^CTLOC(oDepDr),"^",2)
	....S:oDepDesc["-" oDepDesc=$p(oDepDesc,"-",2)
	....i inAdmId'="" d
	.....s dateDesc=""
	.....q:$p(^PAADM(inAdmId),"^",20)="P"   //没有正式收治的,没有入院日期
	.....s szDate=$p(^PAADM(inAdmId),"^",6)
	.....i szDate'="" s dateDesc=$zd(date,3)
	.....e  s dateDesc=""
	....e  s dateDesc=""
	....s oDocDr=$p(^DHCDocIPBK(bookid),"^",7)
	....s oDocDesc=$P(^SSU("SSUSR",oDocDr),"^",2)
	....s createDate=$p(^DHCDocIPBK(bookid),"^",4)
	....s cDateDesc=$zd(createDate,3)
	....d OutRow
	
	}
 	Quit $$$OK

	
OutRow
	s Data=$lb(regNo,medNo,patName,patSex,oDepDesc,iDepDesc,cDateDesc,dateDesc,oDocDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	
 //取转科表中的日期最早的科室
GetFirstLocWard(admId)    
	s locdr1=""

	s transsub=0 f  s transsub=$o(^PAADM(admId,"TRANS",transsub)) q:transsub=""  d    //!(flag=2)
	.s locdr=$p(^PAADM(admId,"TRANS",transsub),"^",6) 
	.s mTransSDate=$p(^PAADM(admId,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admId,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(locdr)=""
	.i $g(locdr1)="" d
	..s locdr1=locdr
	..s mSSTime=mTransSTime
	..s mSSDate=mTransSDate
	.e  d
	..q:$G(mTransSDate)>$G(mSSDate)
	..q:$G(mTransSTime)>$G(mSSTime)
	..s locdr1=locdr
	q locdr1
}

ClassMethod QueryAdmitsNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmitsNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAdmitsNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmitsNumExecute ]
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
/// CreatDate：		2018-06
/// Description：	医院统一调查表--门诊
/// Table：			dhc_workload
/// Input：			
/// Output：
/// Return： 		无：
/// Others： 		接口：s ptrStr=##class(web.UDHCOPINVPrtData12).GetOPPrtData(prtId,"","")	//计费组接口
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryOutQuestionnaire","2018-03-23","2018-04-23","","","")
Query QueryOutQuestionnaire(startDate As %String, endDate As %String, hosId As %String = "", depId As %Text, reaId As %String) As %Query(ROWSPEC = "medNo:%String,age:%String,birthdate:%String,sex:%String,admDate:%String,admDepDesc:%String,diagDesc:%String,diagCode:%String,totalFee:%Float,zlFee:%Float,xyFee:%Float,zcyFee:%Float,zcaoyFee:%Float,regFee:%Float,diagFee:%Float,checkFee:%Float,opFee:%Float,laboratoryFee:%Float,tczfFee:%Float,grzhFee:%Float,hzzfFee:%Float,patName:%String") [ SqlProc ]
{
}

ClassMethod QueryOutQuestionnaireExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, depId As %Text, reaId As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	k ^TEMPDHCWL($j)
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	//1.1-将科室id串转换成数组
	k depArr
	s depNum=$l($g(depId),",")
	i $g(depId)'="" d
	.f i=1:1:depNum d
	..s id=$p($g(depId),",",i)
	..s depArr(id)=""
	
	//1.2-将病人身份类型id串转换成数组
	k reaArr
	s reaNum=$l($g(reaId),",")
	i $g(reaId)'="" d
	.f i=1:1:reaNum d
	..s id=$p($g(reaId),",",i)
	..s reaArr(id)=""
	
	//1.3-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""

	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
	.s admDr=0 f  s admDr=$o(^PAADMi("PAADM_AdmDate",date,admDr)) q:admDr=""  d
	..q:$p(^PAADM(admDr),"^",75)	//婴儿不统计
	..s admReaDr=$p(^PAADM(admDr,1),"^",7)
	..q:('$d(reaArr(+$g(admReaDr))))&&($g(reaId)'="")
	..i +$g(admReaDr)=0 s admRea=""
	..e  s admRea=$$GetPatReasonDesc(admReaDr)
	..s admDepDr=$p(^PAADM(admDr),"^",4) 		//就诊科室
	..q:('$d(depArr(admDepDr)))&&($g(depId)'="")
	..s type=$p(^PAADM(admDr),"^",2)
	..q:type="I"
	..s hosDr=$p(^CTLOC(admDepDr),"^",22)
	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")
	..s papmi=$p(^PAADM(admDr),"^",1)
	..s medNo=$$GetPapmiNo^DHCWLCommon(papmi)
	..;s age=$$GetAge^DHCWLCommon(papmi)
	..s age=##class(web.DHCBillInterface).GetPapmiAge(papmi,admDr)
	..s dob=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
	..s birthdate=$zd(dob,3)
	..s sex=$$GetSex^DHCWLCommon(papmi)
	..s patName=$$GetPapmiName^DHCWLCommon(papmi)
	..s admDate=$zd(date,3)   					//就诊日期
	..s admDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(admDepDr)
	
	
	..s diagStr1=$$GetFirstDiagByAdmDr(admDr)
	..s diagDesc=$p(diagStr1,"^",1)
	..s diagCode=$p(diagStr1,"^",2)
	
	..s totalFee=0,zlFee=0,xyFee=0,zcyFee=0,zcaoyFee=0,bedFee=0,diagFee=0,checkFee=0,opFee=0,laboratoryFee=0,nursingFee=0,tczfFee=0,grzhFee=0,hzzfFee=0
	..s feeInfoStr=##class(web.DHCWLTJSQTQuerys).GetFeeInfoByAdm(admDr)
 	..S totalFee=$P(feeInfoStr,"^",1)	//总费用
 	..S zlFee=$P(feeInfoStr,"^",2)		//治疗费
 	..S xyFee=$P(feeInfoStr,"^",3)		//西药费
 	..S zcyFee=$P(feeInfoStr,"^",4)		//中成药费
 	..S zcaoyFee=$P(feeInfoStr,"^",5)	//中草药费
 	..S regFee=$P(feeInfoStr,"^",6)	//挂号费
 	..S diagFee=$P(feeInfoStr,"^",7)	//诊查费
 	..S checkFee=$P(feeInfoStr,"^",8)	//检查费
 	..S opFee=$P(feeInfoStr,"^",9)	//手术费
 	..S laboratoryFee=$P(feeInfoStr,"^",10)	//化验费
 	..s tczfFee=0,grzhFee=0,hzzfFee=0
 	..
 	..s str=##class(web.DHCWLStatisticsInterface).GetMZDCBYBFee(admDr)
 	..s tczfFee=$P(str,"^",1)	//统筹支付
 	..s grzhFee=$P(str,"^",2)	//个人账户支付
 	..S hzzfFee=$P(str,"^",3)	//患者自负
 	..
 	..d OutRow
	
    k ^TEMPDHCWL($j)
 	Quit $$$OK

	
OutRow
	s Data=$lb(medNo,age,birthdate,sex,admDate,admDepDesc,diagDesc,diagCode,totalFee,zlFee,xyFee,zcyFee,zcaoyFee,regFee,diagFee,checkFee,opFee,laboratoryFee,tczfFee,grzhFee,hzzfFee,patName)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	
	///desc:	根据就诊号取病人的诊断信息：第一条诊断
	///output:	入院诊断^出院诊断^其他诊断
	///creator:	chenyi
	///date:	2014-3-28
	///w $$GetFirstDiagByAdmDr^DHCWLCommon(adm)		 
GetFirstDiagByAdmDr(admDr) 
	;n (admDr)
	s diag=""
	s mrAdm=$P(^PAADM(admDr),"^",61)   
	s mMRDiagnosRowId=0
	f  s mMRDiagnosRowId=$o(^MR(mrAdm,"DIA",mMRDiagnosRowId)) q:(mMRDiagnosRowId="")||($g(diag)'="")  d 	;遍历诊断子表rowid
	.;s diag1=$g(^MR(mrAdm,"DIA",mMRDiagnosRowId,"DES",1))
	.;i diag1'="" s diag=diag1
	.s mIDCDodeDr=$p(^MR(mrAdm,"DIA",mMRDiagnosRowId),"^",1)
	.q:$g(mIDCDodeDr)=""
	.s mMRCIDDesc=$p(^MRC("ID",mIDCDodeDr),"^",2)
	.i $g(mMRCIDDesc)'="" s diag=mMRCIDDesc_"^"_$p(^MRC("ID",mIDCDodeDr),"^",1)

	q $g(diag)
	
 //取转科表中的日期最早的科室&病区
GetFirstLocDr(admId)    
	s transsub=0 f  s transsub=$o(^PAADM(admId,"TRANS",transsub)) q:transsub=""  d    //!(flag=2)
	.s locdr=$p(^PAADM(admId,"TRANS",transsub),"^",6) 
	.s mTransSDate=$p(^PAADM(admId,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admId,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(locdr)=""
	.i $g(locdr1)="" d
	..s locdr1=locdr
	..s mSSTime=mTransSTime
	..s mSSDate=mTransSDate
	.e  d
	..q:$G(mTransSDate)>$G(mSSDate)
	..q:$G(mTransSTime)>$G(mSSTime)
	..s locdr1=locdr
	q locdr1
		///Creator：      yw
	///CreatDate：    2013-02
	///Description:： 根据就病人身份ID取得描述
	///Table：       
	///Input：       
	///Output：      
	///Return：      
	///Others：  w $$GetPatReasonDesc^DHCWLBuildDimData(2)
GetPatReasonDesc(admReasonId)
	s reasonDesc=$P(^PAC("ADMREA",admReasonId),"^",2)	
	q reasonDesc
}

ClassMethod QueryOutQuestionnaireClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutQuestionnaireExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryOutQuestionnaireFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutQuestionnaireExecute ]
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
/// CreatDate：		2018-06
/// Description：	统一调查表--住院
/// Table：			dhc_workload
/// Input：			
/// Output：
/// Return： 		无：
/// Others： 		接口：w ##class(web.UDHCJFPRINTINV).GetPrintInfo(111826,"","")
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryDisPatQuestionnaire","2019-09-01","2019-09-16","","","")
Query QueryDisPatQuestionnaire(startDate As %String, endDate As %String, hosId As %String = "", depId As %Text, reaId As %String) As %Query(ROWSPEC = "medNo:%String,age:%String,birthdate:%String,sex:%String,admDate:%String,disDate:%String,admDepDesc:%String,disDepDesc:%String,sszdDesc:%String,diagDesc:%String,diagCode:%String,totalFee:%Float,zlFee:%Float,xyFee:%Float,zcyFee:%Float,zcaoyFee:%Float,bedFee:%Float,diagFee:%Float,checkFee:%Float,opFee:%Float,laboratoryFee:%Float,nursingFee:%Float,tczfFee:%Float,grzhFee:%Float,hzzfFee:%Float,zyts:%Float,qtFee:%Float,patName:%String") [ SqlProc ]
{
}

ClassMethod QueryDisPatQuestionnaireExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, depId As %Text, reaId As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	k ^TEMPDHCWL($j)
	K ^||TEMPDHCWL
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
	//1.1-将科室id串转换成数组
	k depArr
	s depNum=$l($g(depId),",")
	i $g(depId)'="" d
	.f i=1:1:depNum d
	..s id=$p($g(depId),",",i)
	..s depArr(id)=""
	
	//1.2-将病人身份类型id串转换成数组
	k reaArr
	s reaNum=$l($g(reaId),",")
	i $g(reaId)'="" d
	.f i=1:1:reaNum d
	..s id=$p($g(reaId),",",i)
	..s reaArr(id)=""
	
	//1.3-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""

	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
	.s admDr=0 f  s admDr=$o(^PAADMi("DischargeDateExt",date,admDr)) q:admDr=""  d
	..q:$p(^PAADM(admDr),"^",75)	//婴儿不统计
	..s admReaDr=$p(^PAADM(admDr,1),"^",7)
	..q:('$d(reaArr(+$g(admReaDr))))&&($g(reaId)'="")
	..s admRea=$$GetPatReasonDesc(admReaDr)
	..s type=$p(^PAADM(admDr),"^",2)
	..q:type'="I"
	..s disDepDr=$p(^PAADM(admDr),"^",4)
	..q:('$d(depArr(+$g(disDepDr))))&&($g(depId)'="")
	..s hosDr=$p(^CTLOC(disDepDr),"^",22)
	..q:('$d(hosArr(+$g(hosDr))))&&($g(hosId)'="")
	..s papmi=$p(^PAADM(admDr),"^",1)
	..s medNo=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(admDr) ;$$GetPapmiMedtare^DHCWLCommon(papmi)
	..;s age=$$GetAge^DHCWLCommon(papmi)
	..s age=##class(web.DHCBillInterface).GetPapmiAge(papmi,admDr)
	..s dob=$p(^PAPER(papmi,"ALL"),"^",6)  ;生日
	..s birthdate=$zd(dob,3)
	..s sex=$$GetSex^DHCWLCommon(papmi)
	..s patName=$$GetPapmiName^DHCWLCommon(papmi)
	..s admDate=$p(^PAADM(admDr),"^",6)		//入院日期
	..s zyts=date-admDate						//住院天数
	..i zyts<=0 s zyts=1
	..s disDate=$zd(date,3)
	..s admDate=$zd(admDate,3)
	..s admDepDr=$$GetFirstLocDr(admDr) 		//入院科室
	..s admDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(admDepDr)
	..;s disDepDr=$p(^PAADM(admDr),"^",4)
	..s disDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(disDepDr)
	..s sszdDesc=##class(web.DHCWLStatisticsInterface).GetSSZDWBYYByAdm(admDr)		;损伤中毒诊断
	..s diagStr1=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(admDr,"") 
	..s diagDesc=$p(diagStr1,"^",1)
	..s diagCode=$p(diagStr1,"^",2)
	..s totalFee=0,zlFee=0,xyFee=0,zcyFee=0,zcaoyFee=0,bedFee=0,diagFee=0,checkFee=0,opFee=0,laboratoryFee=0,nursingFee=0,tczfFee=0,grzhFee=0,hzzfFee=0
	..s ybFeeStr=##class(web.DHCWLStatisticsInterface).GetZYDCBYBFee(admDr)
 	..S tczfFee=$p(ybFeeStr,"^",1)	//统筹支付
 	..S grzhFee=$p(ybFeeStr,"^",2)	//个人账户支付
 	..S hzzfFee=$p(ybFeeStr,"^",3)	//患者自负
 	..s qtFee=0
 	..s wlRowId=""  f  s wlRowId=$o(^DHCWorkLoad(0,"PAADM",admDr,wlRowId)) q:wlRowId=""  d
 	...s wlFee=$p(^DHCWorkLoad(wlRowId),"^",16)
 	...s totalFee=totalFee+wlFee                             //总费用
 	...s feeType=##class(web.DHCWLStatisticsInterface).GetZYDCBFeeType(wlRowId)
 	...i (feeType="治疗费")  s zlFee=zlFee+wlFee   //治疗费
 	...i (feeType="西药费")  s xyFee=xyFee+wlFee   //西药费
 	...i (feeType="中成药费")  s zcyFee=zcyFee+wlFee  //中成药费
 	...i (feeType="中草药费")  s zcaoyFee=zcaoyFee+wlFee   //中草药费
 	...i (feeType="床位费")  s bedFee=bedFee+wlFee   //床位费
 	...i (feeType="诊察费")  s diagFee=diagFee+wlFee  //诊察费
 	...i (feeType="检查费")  s checkFee=checkFee+wlFee  //检查费
 	...i (feeType="手术费")  s opFee=opFee+wlFee  //手术费
 	...i (feeType="化验费")  s laboratoryFee=laboratoryFee+wlFee  //化验费
 	...i (feeType="护理费")  s nursingFee=nursingFee+wlFee  //护理费
    ..s qtFee=totalFee-zlFee-xyFee-zcyFee-zcaoyFee-bedFee-diagFee-checkFee-opFee-laboratoryFee-nursingFee 
 	..d OutRow
	
    k ^TEMPDHCWL($j)
    K ^||TEMPDHCWL
 	Quit $$$OK

	
OutRow
	s Data=$lb(medNo,age,birthdate,sex,admDate,disDate,admDepDesc,disDepDesc,sszdDesc,diagDesc,diagCode,totalFee,zlFee,xyFee,zcyFee,zcaoyFee,bedFee,diagFee,checkFee,opFee,laboratoryFee,nursingFee,tczfFee,grzhFee,hzzfFee,zyts,qtFee,patName)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	
SetGlobal(ptrStr)
	K ^||TEMPDHCWL
	s ln=$l(ptrStr,"^")

	f i=1:1:ln d
	.s valueStr=$p(ptrStr,"^",i)
	.q:$P(valueStr,$c(2),1)=""
	.s ^||TEMPDHCWL($P(valueStr,$c(2),1))=$P(valueStr,$c(2),2)

	Q
	
	
	
 //取转科表中的日期最早的科室&病区
GetFirstLocDr(admId) 
	s locdr1=""   //设置初始值   
	s transsub=0 f  s transsub=$o(^PAADM(admId,"TRANS",transsub)) q:transsub=""  d    //!(flag=2)
	.s locdr=$p(^PAADM(admId,"TRANS",transsub),"^",6) 
	.s mTransSDate=$p(^PAADM(admId,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admId,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(locdr)=""
	.i $g(locdr1)="" d
	..s locdr1=locdr
	..s mSSTime=mTransSTime
	..s mSSDate=mTransSDate
	.e  d
	..q:$G(mTransSDate)>$G(mSSDate)
	..q:$G(mTransSTime)>$G(mSSTime)
	..s locdr1=locdr
	q locdr1
		///Creator：      yw
	///CreatDate：    2013-02
	///Description:： 根据就病人身份ID取得描述
	///Table：       
	///Input：       
	///Output：      
	///Return：      
	///Others：  w $$GetPatReasonDesc^DHCWLBuildDimData(2)
GetPatReasonDesc(admReasonId)
	s reasonDesc=$P(^PAC("ADMREA",admReasonId),"^",2)	
	q reasonDesc
}

ClassMethod QueryDisPatQuestionnaireClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDisPatQuestionnaireExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDisPatQuestionnaireFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDisPatQuestionnaireExecute ]
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
/// CreatDate：		2017-07-31
/// Description：	返回病人费用
/// Table：			dhc_workload
/// Input：			
/// Output：
/// Return： 		无：
/// Others： 	
/// w ##class(web.DHCWLTJSQTQuerys).GetFeeInfoByAdm("12")
ClassMethod GetFeeInfoByAdm(admId) As %String
{
	s feeStr=""
	s totalFee=0,zlf=0,zcf=0,xyf=0,zcaof=0,ghf=0,zChaf=0,jcf=0,ssf=0,hyf=0
	s wlId=0 f  s wlId=$o(^DHCWorkLoad(0,"PAADM",admId,wlId)) q:wlId=""  d
	.s fee=$p(^DHCWorkLoad(wlId),"^",16)
	.s feeType=##class(web.DHCWLStatisticsInterface).GetMZDCBFeeType(wlId)
	.s totalFee=totalFee+fee		//总费用
	.i (feeType="治疗费") s zlf=zlf+fee						//治疗费
	.i (feeType="西药费") s xyf=xyf+fee	//西药费
	.i (feeType="中成药费") s zcf=zcf+fee	//中成药费
	.i (feeType="中草药费") s zcaof=zcaof+fee			//中草药费
	.i (feeType="挂号费") s ghf=ghf+fee				//挂号费
	.i (feeType="诊查费") s zChaf=zChaf+fee			//诊查费
	.i (feeType="检查费") s jcf=jcf+fee			//检查费
	.i (feeType="手术费") s ssf=ssf+fee			//手术费
	.i (feeType="化验费") s hyf=hyf+fee			//化验费
	
	s feeStr=totalFee_"^"_zlf_"^"_xyf_"^"_zcf_"^"_zcaof_"^"_ghf_"^"_zChaf_"^"_jcf_"^"_ssf_"^"_hyf
	q feeStr
}

/// Creator?      chenyi
/// CreatDate?    2018-07
/// description:  将门诊调查表的数据导到TXT
/// Table?        
/// Input?        startDate(开始日期),endDate(结束日期)，hosId（医院id，多个可用逗号串联，如：1,2,3），depId（科室id，多个可用逗号串联，如：1,2,3），reaId（病人身份id，多个可用逗号串联，如：1,2,3）
/// Output?       d ##class(web.DHCWLTJSQTQuerys).OutPutMZDCBData("2018-03-23","2018-03-25","","","")
ClassMethod OutPutMZDCBData(startDate, endDate, hosId, depId, reaId) As %String
{

	
	s file="/tmp/MZDCBData.txt"
	;s file="E:\TEST2018.txt"
    c file:"D"
    OPEN file:("NRW"):5
    WRITE !,"开始写文件到"_file_"",!
    u file 
	
	s num=0
	//表头
	w "患者编号	年龄	出生日期	性别	诊断名称	ICD-10编码	就诊科室	就诊时间	门诊总费用	治疗费	药费	西药	中成药	中草药	挂号费	诊察费	检查费	手术费	化验费	其他费	保险统筹基金支付费用	个人账户支付	患者自负费用",!
	;w medNo_"	"_age_"	"_birthdate_"	"_sex_"	"_diagDesc_"	"_diagCode_"	"_admDepDesc_"	"_totalFee_"	"_zlFee_"	"_drugFee_"	"_xyFee_"	"_zcyFee_"	"_zcaoyFee_"	"_regFee_"	"_diagFee_"	"_checkFee_"	"_opFee_"	"_laboratoryFee_"	"_qtf_"	"_tczfFee_"	"_grzhFee_"	"_hzzfFee,!
    
    set rs=##class(%ResultSet).%New("web.DHCWLTJSQTQuerys:QueryOutQuestionnaire")
	set sc=rs.Execute(startDate,endDate,hosId,depId,reaId)
	While rs.Next(.sc) { 
	    s medNo=$g(rs.Data("medNo"))
	    s age=$g(rs.Data("age"))	    
	    s birthdate=$g(rs.Data("birthdate"))
	    s sex=$g(rs.Data("sex"))
	    s diagDesc=$g(rs.Data("diagDesc"))
	    s diagCode=$g(rs.Data("diagCode"))
	    s admDepDesc=$g(rs.Data("admDepDesc"))
	    s admDate=$g(rs.Data("admDate"))
	    s totalFee=$g(rs.Data("totalFee"))
	    s zlFee=$g(rs.Data("zlFee"))
	    s xyFee=$g(rs.Data("xyFee"))
	    s zcyFee=$g(rs.Data("zcyFee"))			;中成药
	    s zcaoyFee=$g(rs.Data("zcaoyFee"))		;中草药
	    s drugFee=xyFee+zcyFee+zcaoyFee
	    s regFee=$g(rs.Data("regFee"))
	    s diagFee=$g(rs.Data("diagFee"))
	    s checkFee=$g(rs.Data("checkFee"))
	    s opFee=$g(rs.Data("opFee"))
	    s laboratoryFee=$g(rs.Data("laboratoryFee"))
	    s qtf=totalFee-zlFee-drugFee-regFee-diagFee-checkFee-opFee-laboratoryFee
	    s tczfFee=$g(rs.Data("tczfFee"))
	    s grzhFee=$g(rs.Data("grzhFee"))
	    s hzzfFee=$g(rs.Data("hzzfFee"))
	    w medNo_"	"_age_"	"_birthdate_"	"_sex_"	"_diagDesc_"	"_diagCode_"	"_admDepDesc_"	"_admDate_"	"_totalFee_"	"_zlFee_"	"_drugFee_"	"_xyFee_"	"_zcyFee_"	"_zcaoyFee_"	"_regFee_"	"_diagFee_"	"_checkFee_"	"_opFee_"	"_laboratoryFee_"	"_qtf_"	"_tczfFee_"	"_grzhFee_"	"_hzzfFee,!
		s num=num+1
   
    }
    c file
    w "写文件完成,记录数:"_num,!
    q
}

/// Creator?      chenyi
/// CreatDate?    2018-07
/// description:  将住院调查表的数据导到TXT
/// Table?        
/// Input?        startDate(开始日期),endDate(结束日期)，hosId（医院id，多个可用逗号串联，如：1,2,3），depId（科室id，多个可用逗号串联，如：1,2,3），reaId（病人身份id，多个可用逗号串联，如：1,2,3）
/// Output?       d ##class(web.DHCWLTJSQTQuerys).OutPutZYDCBData("2018-03-23","2018-03-25","","","")
ClassMethod OutPutZYDCBData(startDate, endDate, hosId, depId, reaId) As %String
{

	
	s file="/tmp/ZYDCBData.txt"
	//s file="E:\TEST2018.xls"
    c file:"D"
    OPEN file:("NRW"):5
    WRITE !,"开始写文件到"_file_"",!
    u file 
	
	s num=0
	//表头
	w "患者编号	年龄	出生日期	性别	入院日期	出院日期	实际住院天数	入院科室	出院科室	损伤、中毒的外部原因	疾病名称	ICD-10编码	住院总费用	治疗费	药费	西药	中成药	中草药	床位费	诊察费	检查费	手术费	化验费	护理费	其他费	保险统筹基金支付费用	个人账户支付	患者自负费用",!
	;w medNo	age_"_	birthdate_	sex_"	"_admDate	disDate_	zyts_"			admDepDesc_"disDepDesc_"sszdDesc_"	"_			diagDesc_"	"_diagCode_"totalFee_"	zlFee_"	drugFee_"xyFee_"zcyFee_"zcaoyFee_bedFee_diagFee_checkFee_"pFee_"laboratoryFee_nursingFee_qtf_tczfFee_"	"_		grzhFee_"	"_		hzzfFee,!		

    
    set rs=##class(%ResultSet).%New("web.DHCWLTJSQTQuerys:QueryDisPatQuestionnaire")
	set sc=rs.Execute(startDate,endDate,hosId,depId,reaId)
	While rs.Next(.sc) { 
	    s medNo=$g(rs.Data("medNo"))
	    s age=$g(rs.Data("age"))	    
	    s birthdate=$g(rs.Data("birthdate"))
	    s sex=$g(rs.Data("sex"))
	    s admDate=$g(rs.Data("admDate"))
	    s disDate=$g(rs.Data("disDate"))
	    s zyts=$g(rs.Data("zyts"))
	    s admDepDesc=$g(rs.Data("admDepDesc"))
	    s disDepDesc=$g(rs.Data("disDepDesc"))
	    s sszdDesc=$g(rs.Data("sszdDesc"))
	    s diagDesc=$g(rs.Data("diagDesc"))
	    s diagCode=$g(rs.Data("diagCode"))
	    s totalFee=$g(rs.Data("totalFee"))
		s zlFee=$g(rs.Data("zlFee"))
	    s xyFee=$g(rs.Data("xyFee"))
	    s zcyFee=$g(rs.Data("zcyFee"))			;中成药
	    s zcaoyFee=$g(rs.Data("zcaoyFee"))		;中草药
	    s drugFee=xyFee+zcyFee+zcaoyFee
	    s bedFee=$g(rs.Data("bedFee"))
	    s diagFee=$g(rs.Data("diagFee"))
	    s checkFee=$g(rs.Data("checkFee"))
	    s opFee=$g(rs.Data("opFee"))
	    s laboratoryFee=$g(rs.Data("laboratoryFee"))
	    s nursingFee=$g(rs.Data("nursingFee"))
	    s qtf=$g(rs.Data("qtFee"))
	    s tczfFee=$g(rs.Data("tczfFee"))
	    s grzhFee=$g(rs.Data("grzhFee"))
	    s hzzfFee=$g(rs.Data("hzzfFee"))
		w medNo_"	"_age_"	"_birthdate_"	"_sex_"	"_admDate_"	"_disDate_"	"_zyts_"	"_admDepDesc_"	"_disDepDesc_"	"_sszdDesc_"	"_diagDesc_"	"_diagCode_"	"_totalFee_"	"_zlFee_"	"_drugFee_"	"_xyFee_"	"_zcyFee_"	"_zcaoyFee_"	"_bedFee_"	"_diagFee_"	"_checkFee_"	"_opFee_"	"_laboratoryFee_"	"_nursingFee_"	"_qtf_"	"_tczfFee_"	"_grzhFee_"	"_hzzfFee,!		
		s num=num+1
   
    }
    c file
    w "写文件完成,记录数:"_num,!
    q
}

/// ////
/// Query：白班、晚夜班统计(7-19)
/// d ##Class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","GetBWDataByKS","2018-10-01","2018-11-10",,104)
Query GetBWDataByKS(startDate As %String, endDate As %String, hosId As %String, depId As %Text) As %Query(ROWSPEC = "PatDepdr,PatDepDesc,Type,DataT,value:%Integer") [ SqlProc ]
{
}

ClassMethod GetBWDataByKSExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, depId As %Text) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(startDate="")||(endDate="") $$$OK
    
	k ^TEMPDHCWL($j)
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	
	s LastDate=$O(^MRIPdaily("MRIP_DATE",""),-1)
	
	;q:EDate+1>LastDate $$$OK
	q:EDate+1>(+$h-1) $$$OK
	s Nextdate=EDate+1
	
	//1.1-将科室id串转换成数组
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
	
	/// 白班(7-19点)  晚夜班(19-第二天7点)
    s StTime=$zth("07:00:00",1)  ///白班开始时间
    s EtTime=$zth("19:00:00",1)  ///白班结束时间

    s MRDr=0 
    f  s MRDr=$o(^MRIPdaily("MRIP_DATE",(SDate-1),MRDr)) q:MRDr=""  d
    .s PatDepdr=$p(^MRIPdaily(MRDr),"^",7)
	.q:+PatDepdr=0
	.
	.s IPDERowid="" f  s IPDERowid=$o(^DHCMRIPDetail(0,"IPType",MRDr,"ZYRS",IPDERowid)) q:IPDERowid=""  d
 	..s admId=$p(^DHCMRIPDetail(IPDERowid),"^",1)
	..s ^TEMPDHCWL($j,"PatDep",PatDepdr,"ZYRS","A")=$g(^TEMPDHCWL($j,"PatDep",PatDepdr,"ZYRS","A"))+1
	
	f date=SDate:1:Nextdate d
    .s MRDr=0 
    .f  s MRDr=$o(^MRIPdaily("MRIP_DATE",date,MRDr)) q:MRDr=""  d
    ..s PatDepdr=$p(^MRIPdaily(MRDr),"^",7)
	..q:+PatDepdr=0
	..
	..s IPDERowid="" f  s IPDERowid=$o(^DHCMRIPDetail(0,"IPDay",MRDr,IPDERowid)) q:IPDERowid=""  d
 	...s admId=$p(^DHCMRIPDetail(IPDERowid),"^",1)
 	...s admTime=$p(^PAADM(admId),"^",7)
 	...s DisTime=$p(^PAADM(admId),"^",18)
 	...s UpTime=$p(^PAADM(admId,1),"^",43)
 	...s Type=$p(^DHCMRIPDetail(IPDERowid),"^",2)
 	...i Type="RYRS" d
 	....q:(Nextdate=date)&&(admTime>StTime) 
 	....i (admTime<StTime)&&(date=SDate) s tagNod="A"  
 	....else  d
 	.....i (admTime>=StTime)&&((admTime<EtTime))  s tagNod="B"
 	.....else  s tagNod="C"
	....s ^TEMPDHCWL($j,"PatDep",PatDepdr,"RYRS",tagNod)=$g(^TEMPDHCWL($j,"PatDep",PatDepdr,"RYRS",tagNod))+1
	...i Type="CYRS" d
 	....q:(Nextdate=date)&&(DisTime>StTime) 
 	....i (DisTime<StTime)&&(date=SDate) s tagNod="A"  
 	....else  d
 	.....i (DisTime>=StTime)&&((DisTime<EtTime))  s tagNod="B"
 	.....else  s tagNod="C"
	....s ^TEMPDHCWL($j,"PatDep",PatDepdr,"CYRS",tagNod)=$g(^TEMPDHCWL($j,"PatDep",PatDepdr,"CYRS",tagNod))+1
	...i Type="TYRS" d
 	....q:(Nextdate=date)&&(UpTime>StTime) 
 	....i (UpTime<StTime)&&(date=SDate) s tagNod="A"  
 	....else  d
 	.....i (UpTime>=StTime)&&((UpTime<EtTime))  s tagNod="B"
 	.....else  s tagNod="C"
	....s ^TEMPDHCWL($j,"PatDep",PatDepdr,"TYRS",tagNod)=$g(^TEMPDHCWL($j,"PatDep",PatDepdr,"TYRS",tagNod))+1
	...i (Type="ZCKS")||(Type="ZRKS") d
	....s ^TEMPDHCWL($j,"ZKRS",date,admId)=""   ///那一天有转科情况


	///转科情况
	s date=""
	f  s date=$O(^TEMPDHCWL($j,"ZKRS",date)) q:date=""  d
	.s admId=""
	.f  s admId=$O(^TEMPDHCWL($j,"ZKRS",date,admId)) q:admId=""  d
	..d ..GetTranData(admId,date,6,StTime,EtTime,SDate,Nextdate)
	
	
	s PatDepdr=""
	f  s PatDepdr=$O(^TEMPDHCWL($j,"PatDep",PatDepdr)) q:PatDepdr=""  d
	.q:('$d(depArr(+$g(PatDepdr))))&&($g(depId)'="")
	.s hosDr=$p(^CTLOC(PatDepdr),"^",22)
	.q:('$d(hosArr(+$g(hosDr))))&&($g(hosId)'="")
	.s PatDepDesc=$P($g(^CTLOC(PatDepdr)),"^",2)
	.i PatDepDesc["-" s PatDepDesc=$P(PatDepDesc,"-",2)
	.s Type=""
	.f  s Type=$O(^TEMPDHCWL($j,"PatDep",PatDepdr,Type)) q:Type=""  d
	..s DataT=""
	..f  s DataT=$O(^TEMPDHCWL($j,"PatDep",PatDepdr,Type,DataT)) q:DataT=""  d
	...s value=+$g(^TEMPDHCWL($j,"PatDep",PatDepdr,Type,DataT))
	...q:+value=0
  	...s Data=$lb(PatDepdr,PatDepDesc,Type,DataT,value)
    ...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	...q

    k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod GetBWDataByKSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBWDataByKSExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod GetBWDataByKSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBWDataByKSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTranData(admId, tDate, transPiece, StTime, EtTime, SDate, Nextdate) As %String
{
	;n (admId,tDate,transPiece,StTime,EtTime,SDate,Nextdate)
	k ^TEMPDHCWL("MRIPDay",$j)
	s transSub=0
	f  s transSub=$o(^PAADM(admId,"TRANS",transSub)) q:transSub=""  d
	.s transSDate=$p(^PAADM(admId,"TRANS",transSub),"^",1)
	.q:transSDate>tDate											;统计时间之后的转科记录，不计入。
	.s transSTime=$p(^PAADM(admId,"TRANS",transSub),"^",2)
	.q:(transSDate=Nextdate)&&(transSTime>StTime)   
	.q:($G(transSDate)="")!(($G(transSTime)=""))					;转科时间或日期为空的，不计入。
	.s trans=$p(^PAADM(admId,"TRANS",transSub),"^",transPiece)		;转科记录中的科室/病区。
	.q:trans=""
	.s ^TEMPDHCWL("MRIPDay",$j,"TransDate",transSDate,transSTime)=trans_"^"_transSub
 
    s fDate=0,fTrans=0
 	s cTransDate=0
 	f  s cTransDate=$o(^TEMPDHCWL("MRIPDay",$j,"TransDate",cTransDate)) q:(cTransDate="")!(cTransDate>tDate)  d
 	.s cTransTime=""
 	.f  s cTransTime=$o(^TEMPDHCWL("MRIPDay",$j,"TransDate",cTransDate,cTransTime)) q:cTransTime=""  d
 	..s tTrans=$p(^TEMPDHCWL("MRIPDay",$j,"TransDate",cTransDate,cTransTime),"^",1)		;科室/病区
 	..s transSub=$p(^TEMPDHCWL("MRIPDay",$j,"TransDate",cTransDate,cTransTime),"^",2)		;转科表rowid
 	..i cTransDate=tDate d  																;非统计时间当天相关数据，不计入。
 	...i fTrans'=tTrans d
 	....i (cTransTime<StTime)&&(SDate=cTransDate) s tagNod="A"  
 	....else  d
 	.....i (cTransTime>=StTime)&&((cTransTime<EtTime))  s tagNod="B"
 	.....else  s tagNod="C"
 	....s ^TEMPDHCWL("MRIPDay",$j,"Transaction",admId,"From",fTrans,"To",tTrans,transSub,tagNod)=(cTransDate-fDate)
 	..i fTrans'=tTrans d
 	...s fDate=cTransDate
 	..s fTrans=tTrans
 
 	s fTrans=0
 	f  s fTrans=$o(^TEMPDHCWL("MRIPDay",$j,"Transaction",admId,"From",fTrans)) q:fTrans=""  d
 	.s tTrans=0
 	.f  s tTrans=$o(^TEMPDHCWL("MRIPDay",$j,"Transaction",admId,"From",fTrans,"To",tTrans)) q:tTrans=""  d
 	..s transSub=0
 	..f  s transSub=$o(^TEMPDHCWL("MRIPDay",$j,"Transaction",admId,"From",fTrans,"To",tTrans,transSub)) q:transSub=""   d
 	...s tagNod=""
 	...f  s tagNod=$O(^TEMPDHCWL("MRIPDay",$j,"Transaction",admId,"From",fTrans,"To",tTrans,transSub,tagNod)) q:tagNod=""   d
	....s ^TEMPDHCWL($j,"PatDep",fTrans,"ZCKS",tagNod)=$g(^TEMPDHCWL($j,"PatDep",fTrans,"ZCKS",tagNod))+1
	....s ^TEMPDHCWL($j,"PatDep",tTrans,"ZRKS",tagNod)=$g(^TEMPDHCWL($j,"PatDep",tTrans,"ZRKS",tagNod))+1
	
	k ^TEMPDHCWL("MRIPDay",$j)
	
 	q 1
}

/// 以下注释默认结束时间是当前时间的前天，比如今天是10月26，那么结束时间是10月24
/// Query：白班、晚夜班统计(7-19)
/// d ##Class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","GetBWDataByBQ","2018-11-01","2018-11-30")
Query GetBWDataByBQ(startDate As %String, endDate As %String, hosId As %String, wardId As %Text) As %Query(ROWSPEC = "wardDr,wardDesc,Type,DataT,value:%Integer") [ SqlProc ]
{
}

ClassMethod GetBWDataByBQExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, wardId As %Text) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(startDate="")||(endDate="") $$$OK
    
	k ^TEMPDHCWL($j)
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	
	s LastDate=$O(^MRIPdaily("MRIP_DATE",""),-1)
	
	;q:EDate+1>LastDate $$$OK    //结束日期必须是前天
	q:EDate+1>(+$h-1) $$$OK
	s Nextdate=EDate+1			//昨天
	
	//1.1-将科室id串转换成数组
	k wardArr
	s wardNum=$l($g(wardId),",")
	i $g(wardId)'="" d
	.f i=1:1:wardNum d
	..s id=$p($g(wardId),",",i)
	..s wardArr(id)=""
	
	//1.2-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	
	/// 白班(7-19点)  晚夜班(19-第二天7点)
    s StTime=$zth("07:00:00",1)  ///白班开始时间
    s EtTime=$zth("19:00:00",1)  ///白班结束时间

    s MRDr=0 
    f  s MRDr=$o(^MRIPdaily("MRIP_DATE",(SDate-1),MRDr)) q:MRDr=""  d
    .s warddr=$p(^MRIPdaily(MRDr),"^",19)
	.q:+warddr=0
	.
	.s IPDERowid="" f  s IPDERowid=$o(^DHCMRIPDetail(0,"IPType",MRDr,"ZYRS",IPDERowid)) q:IPDERowid=""  d
 	..s admId=$p(^DHCMRIPDetail(IPDERowid),"^",1)
	..s ^TEMPDHCWL($j,"PatWard",warddr,"ZYRS","A")=$g(^TEMPDHCWL($j,"PatWard",warddr,"ZYRS","A"))+1  //原有人数
	
	//查询开始日期  到 昨天（自然日后一天的00:00:00到07:59:59属于前一天的晚班）
	f date=SDate:1:Nextdate d
    .s MRDr=0 
    .f  s MRDr=$o(^MRIPdaily("MRIP_DATE",date,MRDr)) q:MRDr=""  d
    ..s warddr=$p(^MRIPdaily(MRDr),"^",19)
	..q:+warddr=0
	..
	..s IPDERowid="" f  s IPDERowid=$o(^DHCMRIPDetail(0,"IPDay",MRDr,IPDERowid)) q:IPDERowid=""  d
 	...s admId=$p(^DHCMRIPDetail(IPDERowid),"^",1)
 	...s admTime=$p(^PAADM(admId),"^",7)
 	...s DisTime=$p(^PAADM(admId),"^",18)
 	...s UpTime=$p(^PAADM(admId,1),"^",43)
 	...s Type=$p(^DHCMRIPDetail(IPDERowid),"^",2)
 	...i Type="RYRS" d
 	....q:(Nextdate=date)&&(admTime>StTime)   //昨天07:00:00之后的数据不算入
 	....i (admTime<StTime)&&(date=SDate) s tagNod="A"   //查询的第一天，且就诊时间早于白班时间的（昨天入院人数） 
 	....else  d
 	.....i (admTime>=StTime)&&((admTime<EtTime))  s tagNod="B"  //查询时间段白班入院人数
 	.....else  s tagNod="C"										//查询时间段 晚班入院人数
	....s ^TEMPDHCWL($j,"PatWard",warddr,"RYRS",tagNod)=$g(^TEMPDHCWL($j,"PatWard",warddr,"RYRS",tagNod))+1
	...i Type="CYRS" d
 	....q:(Nextdate=date)&&(DisTime>StTime) 
 	....i (DisTime<StTime)&&(date=SDate) s tagNod="A"  
 	....else  d
 	.....i (DisTime>=StTime)&&((DisTime<EtTime))  s tagNod="B"
 	.....else  s tagNod="C"
	....s ^TEMPDHCWL($j,"PatWard",warddr,"CYRS",tagNod)=$g(^TEMPDHCWL($j,"PatWard",warddr,"CYRS",tagNod))+1
	...i Type="TYRS" d
 	....q:(Nextdate=date)&&(UpTime>StTime) 
 	....i (UpTime<StTime)&&(date=SDate) s tagNod="A"  
 	....else  d
 	.....i (UpTime>=StTime)&&((UpTime<EtTime))  s tagNod="B"
 	.....else  s tagNod="C"
	....s ^TEMPDHCWL($j,"PatWard",warddr,"TYRS",tagNod)=$g(^TEMPDHCWL($j,"PatWard",warddr,"TYRS",tagNod))+1
	...i (Type="ZCKS")||(Type="ZRKS") d
	....s ^TEMPDHCWL($j,"ZKRS",date,admId)=""   ///那一天有转科情况


	///转科情况
	s date=""
	f  s date=$O(^TEMPDHCWL($j,"ZKRS",date)) q:date=""  d
	.s admId=""
	.f  s admId=$O(^TEMPDHCWL($j,"ZKRS",date,admId)) q:admId=""  d
	..d ..GetTranData(admId,date,9,StTime,EtTime,SDate,Nextdate)
	
	
	s wardDr=""
	f  s wardDr=$O(^TEMPDHCWL($j,"PatWard",wardDr)) q:wardDr=""  d
	.q:('$d(wardArr(+$g(wardDr))))&&($g(wardId)'="")
	.s hosDr=$$GetHosIDByWard^DHCWLBuildDimDataWARD(wardDr)
	.q:('$d(hosArr(+$g(hosDr))))&&($g(hosId)'="")
	.s wardDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(wardDr)
	.s Type=""
	.f  s Type=$O(^TEMPDHCWL($j,"PatWard",wardDr,Type)) q:Type=""  d
	..s DataT=""
	..f  s DataT=$O(^TEMPDHCWL($j,"PatWard",wardDr,Type,DataT)) q:DataT=""  d
	...s value=+$g(^TEMPDHCWL($j,"PatWard",wardDr,Type,DataT))
	...q:+value=0
  	...s Data=$lb(wardDr,wardDesc,Type,DataT,value)
    ...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	...q

    k ^TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod GetBWDataByBQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBWDataByBQExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod GetBWDataByBQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBWDataByBQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ////
/// Query：医疗价格服务使用频次表--query版
/// d ##Class(%ResultSet).RunQuery("web.DHCWLTJSQTQuerys","QueryYLJGFWPCB","2013-10-01","2013-10-10")
Query QueryYLJGFWPCB(startDate As %String, endDate As %String, hosId As %String, admType As %String) As %Query(ROWSPEC = "ordLocCode:%String,ordLocDesc:%String,recLocCode:%String,recLocDesc:%String,tarCode:%String,tarDesc:%String,uomDesc:%String,qty:%Float,fee:%Float") [ SqlProc ]
{
}

ClassMethod QueryYLJGFWPCBExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, admType As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(startDate="")||(endDate="") $$$OK
    
	k ^||TEMPDHCWL($j)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	//1.1-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	//1.2-
	k typeArr
	s num=$l($g(admType),",")
	i $g(admType)'="" d
	.f i=1:1:num d
	..s id=$p($g(admType),",",i)
	..s typeArr(id)=""
	
	f date=startDate:1:endDate d
	.s wlId=0
	.f  s wlId=$o(^DHCWorkLoad(0,"FlagDate",date,wlId)) q:wlId=""  d
	..s type=$p($G(^DHCWorkLoad(wlId)),"^",4)
	..q:('$d(typeArr(+$g(type))))&&($g(admType)'="")
	..s itmMast=$p(^DHCWorkLoad(wlId),"^",2)	//医嘱项
	..q:$d(^ARC("IC",0,"OrderType","R",itmMast))  //医嘱子类  是药品的直接过滤掉
	..s fee=$p(^DHCWorkLoad(wlId),"^",16)
	..s qty=$p(^DHCWorkLoad(wlId),"^",15)
	..s ordLoc=$p(^DHCWorkLoad(wlId),"^",23)      //医嘱科室
	..s hosDr=$p(^CTLOC(ordLoc),"^",22)
	..q:('$d(hosArr(+$g(hosDr))))&&($g(hosId)'="")
	..s recLoc=$p(^DHCWorkLoad(wlId),"^",1)      //执行科室
	..;s ordDoc=$p(^DHCWorkLoad(wlId),"^",19)     //医嘱医生
	..s itemCat=$p(^DHCWorkLoad(wlId),"^",9)	//医嘱子类
	..s tarItem=$p(^DHCWorkLoad(wlId),"^",22)	//收费项
	..s ^||TEMPDHCWL($j,ordLoc,recLoc,tarItem,"qty")=$g(^||TEMPDHCWL($j,ordLoc,recLoc,tarItem,"qty"))+qty
	..s ^||TEMPDHCWL($j,ordLoc,recLoc,tarItem,"fee")=$g(^||TEMPDHCWL($j,ordLoc,recLoc,tarItem,"fee"))+fee
	
	s ordLoc=""
	f  s ordLoc=$o(^||TEMPDHCWL($j,ordLoc)) q:ordLoc=""  d
	.s ordLocCode=$$GetDepCode^DHCWLBuildDimDataCTLOC(ordLoc)
	.s ordLocDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(ordLoc)
	.s recLoc="" f  s recLoc=$o(^||TEMPDHCWL($j,ordLoc,recLoc)) q:recLoc=""  d
	..s recLocCode=$$GetDepCode^DHCWLBuildDimDataCTLOC(recLoc)
	..s recLocDesc=$$GetDepCode^DHCWLBuildDimDataCTLOC(recLoc)
	..s tar="" f  s tar=$o(^||TEMPDHCWL($j,ordLoc,recLoc,tar)) q:tar=""  d
	...s tarCode=$$GetTARICode^DHCWLBuildDimDataTARI(tar)
	...s tarDesc=$$GetTARIName^DHCWLBuildDimDataTARI(tar)
	...s uomDesc=$$GetTARIUnit(tar)
	...s qty=$g(^||TEMPDHCWL($j,ordLoc,recLoc,tar,"qty"))
	...s fee=$g(^||TEMPDHCWL($j,ordLoc,recLoc,tar,"fee"))
	...d OutRow

    k ^||TEMPDHCWL($j)
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow
	s Data=$lb(ordLocCode,ordLocDesc,recLocCode,recLocDesc,tarCode,tarDesc,uomDesc,qty,fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
GetTARIUnit(mTarItemDr)
	s unitDesc=""
 	q:$g(mTarItemDr)="" "Null"
 	s tariUom=$p($G(^DHCTARI(mTarItemDr)),"^",3)
 	i tariUom="" s unitDesc=""
 	e  d
 	.s unitDesc=$P(^CT("UOM",tariUom),"^",2)
    q unitDesc
}

ClassMethod QueryYLJGFWPCBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryYLJGFWPCBExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryYLJGFWPCBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryYLJGFWPCBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
