Class web.DHCEMPatCheckLevStat Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, Not ProcedureBlock ]
{

/// Description: 预检分级病人分区统计
/// Creator:     yuliping
/// CreateDate:  2017-07-18
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryCountOfPart","2018-08-01","2018-08-28")
Query QueryCountOfPart(stDate As %String, endDate As %String, HOSPID As %String) As %Query(ROWSPEC = "pclarea:%String,count:%Integer") [ SqlProc ]
{
}

ClassMethod QueryCountOfPartExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	//
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPart",repid) //2017-07-18 yuliping
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPart","AllPatNum",repid)
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i toDate'="" s toDate= $zdh(toDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
 	
	f Date=fromDate:1:toDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))  ;2017-08-22 qqa 58上错误数据过滤
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..q:+PCLNurseLevel=0
    ..;s CheckLevArea = $case(PCLNurseLevel,1:"红区",2:"红区",3:"黄区",4:"绿区") //hxy 2020-02-27 st
    ..s CheckLevArea = $case(PCLNurseLevel,1:"红区",2:"橙区",3:"黄区",4:"绿区",5:"绿区") //ed
	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPart",repid,CheckLevArea,PatientID)=""	
	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPart","AllPatNum",repid,PatientID)=""
	b ;data
	s CheckLevArea = 0
	f  s CheckLevArea = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPart",repid,CheckLevArea)) q:CheckLevArea=""  d
	.s PatientID="",num=0
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPart",repid,CheckLevArea,PatientID)) q:PatientID=""  d
    ..s num=num+1
    .d OutPutMataInfo
    
    ///合计列
    s num=0
    s PatientID=""
    f  s PatientID =$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPart","AllPatNum",repid,PatientID)) q:PatientID=""  d
    .s num =num+1
    s CheckLevArea="合计:"

    d OutPutMataInfo

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutMataInfo
	set Data=$lb(CheckLevArea,num)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCountOfPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCountOfPartExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryCountOfPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCountOfPartExecute ]
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

Query QueryCountOfPartInfo(stDate, edDate, checkLevArea, HOSPID) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod QueryCountOfPartInfoExecute(ByRef qHandle As %Binary, stDate, edDate, checkLevArea, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryCountOfPartInfo","2017-01-04","2017-08-04","红区")
	
	n (qHandle,stDate, edDate, checkLevArea,HOSPID)
	
    Set repid=$I(^CacheTemp)
    set ind=1
	s qHandle=$lb(0,repid,0)
  	//编码开始
  	i (stDate="")||(edDate="" ) Quit $$$OK
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	s:checkLevArea["合计" checkLevArea=""
  	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid)  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PCLCheckLevArea=""
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))  ;2017-08-22 qqa 58上错误数据过滤
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..;s PCLCheckLevArea = $case(PCLNurseLevel,1:"红区",2:"红区",3:"黄区",4:"绿区") //hxy 2020-02-27 st
    ..s PCLCheckLevArea = $case(PCLNurseLevel,1:"红区",2:"橙区",3:"黄区",4:"绿区",5:"绿区") //ed
    ..
    ..q:(PCLCheckLevArea'=checkLevArea)&(checkLevArea'="")
	..
	..i $d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid,PatientID)) d
	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid,PatientID) = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid,PatientID)_":"_PCLDr
	..e  d
	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid,PatientID) = PCLDr
	
	b ;Data
	
	.s PatientID=""
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid,PatientID)) q:PatientID=""  d
    ..
    
    s PatDr=0
	f  s PatDr = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid,PatDr)) q:PatDr=""  d
	.s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr,HOSPID) //hxy 2020-06-11
	.s PclRowStr = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryCountOfPartInfo",repid,PatDr)
	.s name = $p(PatInfo,"^",2)
	.s curregno = $p(PatInfo,"^",1)
	.s PatCardNo = $p(PatInfo,"^",12)
	.s sexId = $p(PatInfo,"^",3)
	.s age = $p(PatInfo,"^",4)
	.f i=1:1:$l(PclRowStr,":") d
	..s PclDr = $p(PclRowStr,":",i)
	..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PclDr)
	..s pclDate = $p(pclData,"^",2)			//日期
	..s pclTime = $p(pclData,"^",3)			//时间
	..s symptom = $p(pclData,"^",4)			//症状
	..s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	..s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	..s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	..s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	..s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	..s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	..s NurseLevel=$p(pclData,"^",16)      	//护士分级
	..s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-27 st
	..s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	..s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	..s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
    ..d OutPutMataInfo666
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutMataInfo666
	s Data=$lb(curregno,name,sexId,age,PatCardNo,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel,pclDate,pclTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCountOfPartInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCountOfPartInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCountOfPartInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admNumtQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 预检分级病72小时重返统计
/// Creator:     yuliping
/// CreateDate:  2017-07-18
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryReturnOfAdm","2017-03-19","2017-03-20")
Query QueryReturnOfAdm(stDate As %String, endDate As %String) As %Query(ROWSPEC = "countReturn:%Integer,num:%Integer") [ SqlProc ]
{
}

ClassMethod QueryReturnOfAdmExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String) As %Status
{
	n (qHandle,stDate,endDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
	
	
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","PAPMIDr") //2017-07-18 yuliping
	s all=0
 	s PCLRowID="0" 
 	f  s PCLRowID=$o(^DHCEMPCL(PCLRowID)) q:PCLRowID=""  d
 	.s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1)    	//来诊病人dr  Pa_PatMas	
 	.s Date=$p(^DHCEMPCL(PCLRowID),"^",4) 			//分诊日期
 	.q:((stDate'="")&&(stDate>Date))
 	.q:((endDate'="")&&(endDate<Date))
 	
 	.s reg="", str="",count=0									
 	.f  s reg=$o(^DHCEMPCL(0,"EmPatReg",PAPMIDr,reg))  q:reg=""  d
 	..s pclrid=""				
 	..f  s pclrid=$o(^DHCEMPCL(0,"EmPatReg",PAPMIDr,reg,pclrid)) q:pclrid=""  d
 	...i str=""  d
 	....s str=pclrid
 	...e  d
 	....s str=pclrid_"^"_str
 	...s count=count+1
 	..q:count<2									// 计数器，若只有一条数据，肯定不是重返。
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","PAPMIDr",PAPMIDr)=str

 	s admdr="",countReturn=0
 	f  s admdr=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","PAPMIDr",admdr))  q:admdr=""  d
 	.s str=^TMP("DHCEM","web.DHCEMPatCheckLevStat","PAPMIDr",admdr)				//登记号组
 	.s all=all+1
 	.s rtn=..getReturnOfAdm(str)
 	.s:rtn>1 countReturn=countReturn+1

 	d OutPutMataInfo1
	
	Quit $$$OK
OutPutMataInfo1
	s num=all-countReturn
	s Data=$lb(countReturn,num)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryReturnOfAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReturnOfAdmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryReturnOfAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReturnOfAdmExecute ]
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

/// Description: 预检分级病72小时重返统计
/// Creator:     qqa
/// CreateDate:  2017-07-18
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew","2017-03-19","2017-03-20")
Query QueryReturnOfAdmNew(stDate As %String, endDate As %String, HOSPID As %String) As %Query(ROWSPEC = "countReturn:%Integer,num:%Integer") [ SqlProc ]
{
}

ClassMethod QueryReturnOfAdmNewExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
	
	
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew") //2017-07-18 yuliping
	s IsReturnPatNum=0,NoReturnPatNum=0,count=0
	
 	f Date=stDate:1:endDate  d                       ///通过时间肯定走时间索引
 	.s PCLDr="" 
 	.f  s PCLDr  = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
 	..s PAPMIDr = $p(^DHCEMPCL(PCLDr),"^",1)
 	..q:+PAPMIDr=0
 	..q:'$d(^PAPER(PAPMIDr))  ;2017-08-22 qqa 58上错误数据过滤
 	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
 	..i $d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew",PAPMIDr)) d       ///这里很明显临时globle保存病人ID以及对应的分诊ID
 	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew",PAPMIDr) = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew",PAPMIDr)_":"_PCLDr
 	..e  d
 	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew",PAPMIDr) = PCLDr
	
	b ;data
	
	s PAPMIDr=""
	f  s PAPMIDr = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew",PAPMIDr)) q:PAPMIDr=""  d
	.s pclRowIdStr = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmNew",PAPMIDr)
	.i (..PatIsReturn(pclRowIdStr)) d
	..s IsReturnPatNum=IsReturnPatNum+1
	.e  s NoReturnPatNum=NoReturnPatNum+1
	
 	d OutPutMataInfo999
	
	Quit $$$OK
OutPutMataInfo999
	s Data=$lb(IsReturnPatNum,NoReturnPatNum)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryReturnOfAdmNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReturnOfAdmNewExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryReturnOfAdmNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReturnOfAdmNewExecute ]
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

/// Description: 预检分级病72小时重返病人明细
/// Creator:     qqa
/// CreateDate:  2017-07-18
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","2017-03-19","2017-03-20","Y")
Query QueryReturnOfAdmInfo(stDate As %String, endDate As %String, returnPatFlag As %String, HOSPID As %String) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod QueryReturnOfAdmInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, returnPatFlag As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,returnPatFlag,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
	
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo") //2017-07-18 yuliping
	
 	f Date=stDate:1:endDate  d                       ///通过时间肯定走时间索引
 	.s PCLDr="" 
 	.f  s PCLDr  = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
 	..s PAPMIDr = $p(^DHCEMPCL(PCLDr),"^",1)
 	..q:+PAPMIDr=0
 	..q:'$d(^PAPER(PAPMIDr))   ///2107-08-22 QQA 58上存在错误数据，这里进行过滤
 	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
 	..i $d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr)) d       ///这里很明显临时globle保存病人ID以及对应的分诊ID
 	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr) = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr)_":"_PCLDr
 	..e  d
 	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr) = PCLDr
 	
 	b ;data
 	
 	s PAPMIDr=""
	f  s PAPMIDr = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr)) q:PAPMIDr=""  d
	.s pclRowIdStr = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr)
	.i (..PatIsReturn(pclRowIdStr)) d
	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","ReturnPat","Y",PAPMIDr)=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr)
	.e  s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","ReturnPat","N",PAPMIDr)=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","Pat",PAPMIDr)
 	
	s PatDr=0
	f  s PatDr = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","ReturnPat",returnPatFlag,PatDr)) q:PatDr=""  d
	.s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr,HOSPID) //hxy 2020-06-11 HOSPID
	.s PclRowStr = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo","ReturnPat",returnPatFlag,PatDr)
	.s name = $p(PatInfo,"^",2)
	.s curregno = $p(PatInfo,"^",1)
	.s PatCardNo = $p(PatInfo,"^",12)
	.s sexId = $p(PatInfo,"^",3)
	.s age = $p(PatInfo,"^",4)
	.f i=1:1:$l(PclRowStr,":") d
	..b ;err
	..s PclDr = $p(PclRowStr,":",i)
	..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PclDr)
	..s pclDate = $p(pclData,"^",2)			//日期
	..s pclTime = $p(pclData,"^",3)			//时间
	..s symptom = $p(pclData,"^",4)			//症状
	..s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	..s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	..s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	..s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	..s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	..s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	..s NurseLevel=$p(pclData,"^",16)      	//护士分级
	..s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-27 st
	..s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	..s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	..s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
 	..d OutPutMataInfo888
	Quit $$$OK
OutPutMataInfo888
	s Data=$lb(curregno,name,sexId,age,PatCardNo,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel,pclDate,pclTime)       
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryReturnOfAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReturnOfAdmInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmInfo")
 Quit $$$OK
}

ClassMethod QueryReturnOfAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReturnOfAdmInfoExecute ]
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

/// Description: 预检分级病人转归人数统计
/// Creator:     yuliping
/// CreateDate:  2017-07-21
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryVisitStatus","2017-08-01","2017-08-02")
Query QueryVisitStatus(stDate As %String, endDate As %String, HOSPID As %String) As %Query(ROWSPEC = "visitDesc:%String,num:%Integer") [ SqlProc ]
{
}

ClassMethod QueryVisitStatusExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	s count=0
	k ^s
	s ^s=stDate_","_endDate
	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i stDate="" s stDate=+$h
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
	i endDate="" s endDate=+$h
	
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus") //2017-07-21 yuliping
	
	f Date=stDate:1:endDate  d 
 	.s AdmTime=""
 	.f  s AdmTime=$o(^PAADMi("TypeDate","E",Date,AdmTime))   Q:AdmTime=""  D
 	..s Time =$zt(AdmTime,2)
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TypeDate","E",Date,AdmTime,EpisodeID))   Q:EpisodeID=""  D
 	...s PAPMIDr = $p(^PAADM(EpisodeID),"^",1)
 	...;q:(Time'="")&(StaTime'="")&(StaTime>Time) ;2016-09-23  开始日早于就诊时间Q
    ...;q:(Time'="")&(EndTime'="")&(StaTime<Time) ;2016-09-23  结束日晚于就诊
 	...q:PAPMIDr="" 								 				//号别过滤
 	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-11 st
    ...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	...q:CurHospID'=HOSPID //ed
 	...s PCLRowID=""                                                  						//这里判断有无进行分诊
	...s:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	...q:PCLRowID=""
	...s patWhere=..getPatWhere(EpisodeID)													//病人转归状态
	...q:patWhere=""
	...i $d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus",patWhere)) d
	....s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus",patWhere)=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus",patWhere)+1
	...e  d
	....s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus",patWhere)=1
	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus",patWhere,PCLRowID)=PCLRowID
	
	s visitId=""
	f  s visitId=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus",visitId))  q:visitId=""  d
	.s num=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisitStatus",visitId)
 	.d OutPutVisitStatus
	
	Quit $$$OK
OutPutVisitStatus
	i visitId'="" s visitDesc=$p(^DHCPACVisitStatus(visitId),"^",2)
	
	s Data=$lb(visitDesc,num)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryVisitStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVisitStatusExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryVisitStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVisitStatusExecute ]
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

/// Description: 预检分级病人首诊分布统计
/// Creator:     yuliping
/// CreateDate:  2017-07-18
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryFirstVisOfAdm","2016-11-01","2017-11-27")
Query QueryFirstVisOfAdm(stDate As %String, endDate As %String, HOSPID As %String) As %Query(ROWSPEC = "EmLocDesc:%String,numOfAdm:%Integer") [ SqlProc ]
{
}

ClassMethod QueryFirstVisOfAdmExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
 	d ..killTmpGlobal(pid) //k掉临时global

	s count=0
	
	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)

	f Date=stDate:1:endDate  d 
 	.s AdmTime=""
 	.f  s AdmTime=$o(^PAADMi("TypeDate","E",Date,AdmTime))   Q:AdmTime=""  D
 	..s Time =$zt(AdmTime,2)
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TypeDate","E",Date,AdmTime,EpisodeID))   Q:EpisodeID=""  D
 	...s PAPMIDr = $p(^PAADM(EpisodeID),"^",1)
 	...s loc=$p(^PAADM(EpisodeID),"^",4)						//就诊科室
 	...q:PAPMIDr="" 								 				//号别过滤
 	...s CurHospID=$p($g(^CTLOC(+loc)),"^",22) //hxy 2020-06-11 st
	...q:CurHospID'=HOSPID //ed
 	...S PCLRowID=""                                                  						//这里判断有无进行分诊
	...S:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	...q:PCLRowID=""
	...q:$d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute",pid,Date,PAPMIDr))		//当日该病人非第一次就诊
	...s count=count+1
 	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute",pid,Date,PAPMIDr)=EpisodeID_"^"_loc
 	...i $d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute","Loc",pid,loc))  d
 	....s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute","Loc",pid,loc)=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute","Loc",pid,loc)+1
 	...e  d
 	....s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute","Loc",pid,loc)=1
 	
 	s locdr=""
 	f  s locdr=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute","Loc",pid,locdr)) q:locdr=""  d
 	.s numOfAdm=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute","Loc",pid,locdr)   //该科室急诊人数
 	.d OutPutMataInfo2
 	d ..killTmpGlobal(pid) //k掉临时global
	
	Quit $$$OK
OutPutMataInfo2
	i locdr'="" s EmLocDesc=$p(^CTLOC(locdr),"^",2)
	s Data=$lb(EmLocDesc,numOfAdm)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryFirstVisOfAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFirstVisOfAdmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryFirstVisOfAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFirstVisOfAdmExecute ]
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

/// Description: 预检分级病人首诊分布统计明细
/// Creator:     qqa
/// CreateDate:  2017-08-09
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryFirstAdmInfo","2016-11-01","2017-11-27","急诊内科门诊")
Query QueryFirstAdmInfo(stDate As %String, endDate As %String, locDesc As %String, HOSPID As %String) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod QueryFirstAdmInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, locDesc As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,locDesc,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK

	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
 	d ..killTmpGlobal(pid) //k掉临时global
 	
	s count=0
	
	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)

	f Date=stDate:1:endDate  d 
 	.s AdmTime=""
 	.f  s AdmTime=$o(^PAADMi("TypeDate","E",Date,AdmTime))   Q:AdmTime=""  D
 	..s Time =$zt(AdmTime,2)
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TypeDate","E",Date,AdmTime,EpisodeID))   Q:EpisodeID=""  D
 	...s PAPMIDr = $p(^PAADM(EpisodeID),"^",1)
 	...s loc=$p(^PAADM(EpisodeID),"^",4)						//就诊科室
 	...q:PAPMIDr="" 								 				//号别过滤
 	...s CurHospID=$p($g(^CTLOC(+loc)),"^",22) //hxy 2020-06-11 st
	...q:CurHospID'=HOSPID //ed
 	...S PCLRowID=""                                                  						//这里判断有无进行分诊
	...S:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	...q:PCLRowID=""
	...;判断预检分诊号别表中是否有数据  
	...q:$d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstAdmInfo",pid,Date,PAPMIDr))		//当日该病人非第一次就诊
	...s count=count+1
 	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstAdmInfo",pid,Date,PAPMIDr)=""
 	...i loc'="" s EmLocDesc=$p(^CTLOC(loc),"^",2)
	...q:(EmLocDesc'=locDesc)&(locDesc'="")
	...s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PAPMIDr,HOSPID)   ///患者信息 //hxy 2020-06-11 HOSPID
	...s name = $p(PatInfo,"^",2)
	...s curregno = $p(PatInfo,"^",1)
	...s PatCardNo = $p(PatInfo,"^",12)
	...s sexId = $p(PatInfo,"^",3)
	...s age = $p(PatInfo,"^",4)
	...s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PCLRowID)  ///分诊信息
	...s pclDate = $p(pclData,"^",2)			//日期
	...s pclTime = $p(pclData,"^",3)			//时间
	...s symptom = $p(pclData,"^",4)			//症状
	...s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	...s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	...s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	...s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	...s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	...s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	...s NurseLevel=$p(pclData,"^",16)      	//护士分级
	...s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-27 st
	...s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	...s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	...s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
 	...d OutPutMataInfo444
 	d ..killTmpGlobal(pid) //k掉临时global
 	
	Quit $$$OK
OutPutMataInfo444
	s Data=$lb(curregno,name,sexId,age,PatCardNo,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel,pclDate,pclTime)
 	Set ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryFirstAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFirstAdmInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryFirstAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFirstAdmInfoExecute ]
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

/// Description: 预检分级病人转归病人详情
/// Creator:     yuliping
/// CreateDate:  2017-07-21
/// Input:  	 开始时间，结束时间，转归状态
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryVisStaDeatil","2017-08-02","2017-08-02","到达")
Query QueryVisStaDeatil(stDate As %String, endDate As %String, visit As %String, HOSPID As %String) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String") [ SqlProc ]
{
}

ClassMethod QueryVisStaDeatilExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, visit As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,visit,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	s count=0

	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	;i stDate="" s stDate=+$h
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
	;i endDate="" s endDate=+$h
	s:visit["合计" visit=""
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisStaDeatil") //2017-07-21 yuliping
	
	f Date=stDate:1:endDate  d 
 	.s AdmTime=""
 	.f  s AdmTime=$o(^PAADMi("TypeDate","E",Date,AdmTime))   Q:AdmTime=""  D
 	..s Time =$zt(AdmTime,2)
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TypeDate","E",Date,AdmTime,EpisodeID))   Q:EpisodeID=""  D
 	...s PAPMIDr = $p(^PAADM(EpisodeID),"^",1)
 	...;q:(Time'="")&(StaTime'="")&(StaTime>Time) ;2016-09-23  开始日早于就诊时间Q
    ...;q:(Time'="")&(EndTime'="")&(StaTime<Time) ;2016-09-23  结束日晚于就诊
 	...q:PAPMIDr="" 								 				//号别过滤
 	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-11 st
    ...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	...q:CurHospID'=HOSPID //ed
 	...s PCLRowID=""                                                  						//这里判断有无进行分诊
	...s:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	...q:PCLRowID=""
	...
	...s patWhere=..getPatWhere(EpisodeID)													//病人转归状态
	...q:patWhere=""
	...s patWhereDesc=$p(^DHCPACVisitStatus(patWhere),"^",2)
	...q:((patWhere'="")&&(patWhereDesc'=visit)&&(visit'=""))												//转归状态过滤
	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisStaDeatil",EpisodeID,PCLRowID)=PAPMIDr
	
	s episId=""  
	f  s episId=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisStaDeatil",episId)) q:episId=""  d
	.s pclId=""
	.f  s pclId=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisStaDeatil",episId,pclId))  q:pclId=""  d
	..s papmiDr=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryVisStaDeatil",episId,pclId)
 	..d OutPutQueryVisStaDeatil
	
	Quit $$$OK
OutPutQueryVisStaDeatil
	s patMsg=##class(web.DHCEMRegister).getPatMessage(papmiDr,HOSPID) //hxy 2020-06-11 HOSPID
	s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(pclId)
	s curregno=$p(patMsg,"^",1)       		 ///病人登记号
 
   	s name = $p(patMsg,"^",2)				/// 病人姓名
    s sexId = $p(patMsg,"^",3)				/// 病人性别
    s age = $p(patMsg,"^",4)				/// 病人年龄
	s PatCardNo = $p(patMsg,"^",7)			/// 病人卡号
	
	s symptom = $p(pclData,"^",4)			//症状
	s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	s NurseLevel=$p(pclData,"^",16)      	//护士分级
	s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-27 st
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
	
	s Data=$lb(curregno,name,sexId,age,PatCardNo,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryVisStaDeatilClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVisStaDeatilExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryVisStaDeatilFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVisStaDeatilExecute ]
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

/// Description: 病人去向
/// Creator:     yuliping
/// CreateDate:  2017-07-21
/// Table: 		 
/// Input:  	 就诊ID
/// Return： 	 去向
/// Others:	w ##class(web.DHCEMPatCheckLevStat).getPatWhere(247)
ClassMethod getPatWhere(EpisodeID)
{

	n (EpisodeID)
	q:(EpisodeID="") ""

 	s PatStatusID = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
 	
 	q:PatStatusID="" ""
	s PatStDr = $p(^DHCADMVisitStatus(PatStatusID),"^",2)
	;s PatWhere = $p(^DHCPACVisitStatus(PatStDr),"^",2)
 	q PatStDr
}

/// Description: 预检分级病人转各住院科室统计
/// Creator:     yuliping
/// CreateDate:  2017-07-24
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryInpatientStatus","2016-09-01","2017-09-05")
Query QueryInpatientStatus(stDate As %String, endDate As %String, HOSPID As %String) As %Query(ROWSPEC = "wardDesc:%String,countOfAdm:%Integer") [ SqlProc ]
{
}

ClassMethod QueryInpatientStatusExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	s count=0

	i stDate'="" s stDate=$zdh(stDate,3) 
 	i endDate'="" s endDate= $zdh(endDate,3) 

	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientStatus") //2017-07-21 yuliping
	
	f Date=stDate:1:endDate  d 
 	.s AdmTime=""		
 	.f  s AdmTime=$o(^PAADMi("TypeDate","I",Date,AdmTime))   Q:AdmTime=""  D
 	..s Time =$zt(AdmTime,2)
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TypeDate","I",Date,AdmTime,EpisodeID))   Q:EpisodeID=""  D
 	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-11 st
    ...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	...q:CurHospID'=HOSPID //ed
 	...; 获取上次就诊是不是已经分诊的就诊
 	...s Adm = ##class(web.DHCEMPatCheckLevStat).GetIsCheckLevPat(EpisodeID)
 	...q:+Adm=0 
 	...s PAPMIDr = $p(^PAADM(EpisodeID),"^",1)
 	...s type = $p(^PAADM(EpisodeID),"^",2)
 	...s wardDr = $p(^PAADM(EpisodeID),"^",4)
 	...q:wardDr=""
 	...q:PAPMIDr="" 								 				//号别过滤
 	...s PCLRowID=""                                                						//这里判断有无进行分诊
	...s:$d(^DHCEMPCA(0,"AdmChkLev",Adm))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",Adm,""))
	...q:PCLRowID=""
	...i $d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientStatus",wardDr))  d
	....s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientStatus",wardDr)=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientStatus",wardDr)+1	
	...e  d
	....s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientStatus",wardDr)=1

	b ;data
	s wardId=""
	f  s wardId=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientStatus",wardId))  q:wardId=""  d
	.s countOfAdm=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientStatus",wardId)
 	.d OutPutInpatientStatus
	
	Quit $$$OK
OutPutInpatientStatus
	i wardId'="" s wardDesc=$p(^CTLOC(wardId),"^",2)
	s Data=$lb(wardDesc,countOfAdm)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryInpatientStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInpatientStatusExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryInpatientStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInpatientStatusExecute ]
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

/// Description: 预检分级病人转各住院科室病人明细
/// Creator:     yuliping
/// CreateDate:  2017-07-24
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryInpatientDetail","2017-09-01","2017-09-06","呼吸内科一")
Query QueryInpatientDetail(stDate As %String, endDate As %String, ward As %String, HOSPID As %String) As %Query(ROWSPEC = "wardDesc:%String,curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,warddesc:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String") [ SqlProc ]
{
}

ClassMethod QueryInpatientDetailExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, ward As %String, HOSPID As %String) As %Status
{
	n (qHandle,stDate,endDate,ward,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	s count=0

	i stDate'="" s stDate=$zdh(stDate,3)
 	i endDate'="" s endDate= $zdh(endDate,3) 
	s:ward="合计" ward=""
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientDetail") //2017-07-21 yuliping
	
	f Date=stDate:1:endDate  d 
 	.s AdmTime=""
 	.f  s AdmTime=$o(^PAADMi("TypeDate","I",Date,AdmTime))   Q:AdmTime=""  D
 	..s Time =$zt(AdmTime,2)
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TypeDate","I",Date,AdmTime,EpisodeID))   Q:EpisodeID=""  D
 	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-11 st
    ...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	...q:CurHospID'=HOSPID //ed
 	...s Adm = ##class(web.DHCEMPatCheckLevStat).GetIsCheckLevPat(EpisodeID)
 	...q:+Adm=0
 	...s PAPMIDr = $p(^PAADM(EpisodeID),"^",1)
 	...s wardDr = $p(^PAADM(EpisodeID),"^",4)
 	...q:+wardDr=0
 	...s wardDesc=""
 	...s wardDesc=$p(^CTLOC(wardDr),"^",2)
 	...b ;err
 	...q:((ward'="")&&(wardDesc'=ward))
 	...b ;err2
 	...q:PAPMIDr="" 								 				//号别过滤
 	...s PCLRowID=""                                                  						//这里判断有无进行分诊
	...s:$d(^DHCEMPCA(0,"AdmChkLev",Adm))>=10 PCLRowID =$o(^DHCEMPCA(0,"AdmChkLev",Adm,""))
	...
	...q:PCLRowID=""
	...s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientDetail",wardDesc,PCLRowID)=PAPMIDr
	s wardDesc=""
	f  s wardDesc=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientDetail",wardDesc))  q:wardDesc=""  d
	.s pclId=""
	.f  s pclId=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientDetail",wardDesc,pclId))  q:pclId=""  d
	..s paAdmdr=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryInpatientDetail",wardDesc,pclId)
 	..d OutPutInpatientDetail
	
	Quit $$$OK
OutPutInpatientDetail
	s patMsg=##class(web.DHCEMRegister).getPatMessage(paAdmdr,HOSPID) //hxy 2020-06-11 HOSPID
	s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(pclId)
	s curregno=$p(patMsg,"^",1)       		 ///病人登记号
   	s name = $p(patMsg,"^",2)				/// 病人姓名
    s sexId = $p(patMsg,"^",3)				/// 病人性别
    s age = $p(patMsg,"^",4)				/// 病人年龄
	s PatCardNo = $p(patMsg,"^",7)			/// 病人卡号
	s symptom = $p(pclData,"^",4)			//症状
	s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	s NurseLevel=$p(pclData,"^",16)      	//护士分级
	s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-27 st
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
	s Data=$lb(wardDesc,curregno,name,sexId,age,PatCardNo,warddesc,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel)     
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryInpatientDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInpatientDetailExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryInpatientDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInpatientDetailExecute ]
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

/// Description: 预检分级病72小时重返病人明细
/// Creator:     yuliping
/// CreateDate:  2017-08-01
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryReturnOfAdmDtl","2016-12-12","2017-07-07","Y")
Query QueryReturnOfAdmDtl(stDate As %String, endDate As %String, flag As %String) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod QueryReturnOfAdmDtlExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, flag As %String) As %Status
{
	n (qHandle,stDate,endDate,flag)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	i stDate'="" s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(fromDate)
 	i endDate'="" s endDate= $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(toDate)
 	
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","N") //2017-08-01 yuliping  非72小时重返
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y") //2017-08-01 yuliping  72小时重返
	
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmDtl") //2017-07-18 yuliping
	s all=0
 	s PCLRowID="0" 
 	f  s PCLRowID=$o(^DHCEMPCL(PCLRowID)) q:PCLRowID=""  d
 	.s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1)    	//来诊病人dr  Pa_PatMas	
 	.s Date=$p(^DHCEMPCL(PCLRowID),"^",4) 			//分诊日期
 	.q:((stDate'="")&&(stDate>Date))
 	.q:((endDate'="")&&(endDate<Date))
 	.s reg="", count=0									
 	.f  s reg=$o(^DHCEMPCL(0,"EmPatReg",PAPMIDr,reg))  q:reg=""  d
 	..s pclrid="",str=""			
 	..f  s pclrid=$o(^DHCEMPCL(0,"EmPatReg",PAPMIDr,reg,pclrid)) q:pclrid=""  d
 	...s all=all+1
 	...i str=""  d
 	....s str=pclrid
 	...e  d
 	....s str=pclrid_"^"_str
 	...s count=count+1
 	..i $l(str,"^")=1 s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","N",str)=PAPMIDr
 	..q:count<2									// 计数器，若只有一条数据，肯定不是重返。
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmDtl",PAPMIDr)=str
 	
 	s admdr="",countReturn=0
 	f  s admdr=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmDtl",admdr))  q:admdr=""  d
 	.s str=^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryReturnOfAdmDtl",admdr)				//登记号组
 	.s rtnStr=..getReturnOfAdmDtl(str,admdr)
 	.s rtn=$p(rtnStr,"!",1)
 	.s countReturn=rtn+countReturn
	
	i flag="Y" d							//72小时重返
	.s pclrowid=""
	.f  s pclrowid=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",pclrowid))  q:pclrowid=""  d
	..s paAdm=^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",pclrowid)

	..d OutPutQueryReturnOfAdmDtl
	e  d									//非72小时重返
	.s pclrowid=""
	.f  s pclrowid=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","N",pclrowid))  q:pclrowid=""  d
	..s paAdm=^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","N",pclrowid)
	..d OutPutQueryReturnOfAdmDtl
	
	Quit $$$OK
OutPutQueryReturnOfAdmDtl
	s patMsg=##class(web.DHCEMRegister).getPatMessage(paAdm)
	s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(pclrowid)
	s curregno=$p(patMsg,"^",1)       		 ///病人登记号
 
   	s name = $p(patMsg,"^",2)				/// 病人姓名
    s sexId = $p(patMsg,"^",3)				/// 病人性别
    s age = $p(patMsg,"^",4)				/// 病人年龄
	s PatCardNo = $p(patMsg,"^",7)			/// 病人卡号
	s pclDate = $p(pclData,"^",2)			//日期
	s pclTime = $p(pclData,"^",3)			//时间
	;i pclDate'="" s pclDate=$zd(pclDate,3)
	;i pclTime'="" s pclTime=$zt(pclTime,3)
	s symptom = $p(pclData,"^",4)			//症状
	s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	s NurseLevel=$p(pclData,"^",16)      	//护士分级
	s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",1:"")
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",1:"")
	
	
	s Data=$lb(curregno,name,sexId,age,PatCardNo,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel,pclDate,pclTime)       
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryReturnOfAdmDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReturnOfAdmDtlExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryReturnOfAdmDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReturnOfAdmDtlExecute ]
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

/// Description: 预检分级病人重返统计分析
/// Creator:     yuliping
/// CreateDate:  2017-07-19
/// Input:  	 一个病人所有分级id
/// Return: 	 重返次数
/// Others:		 w ##class(web.DHCEMPatCheckLevStat).getReturnOfAdm("1323^1322^1321^1320^1318")
ClassMethod getReturnOfAdm(plcstr As %String)
{
	
	n (plcstr)
	s count=0         //重返次数
	
	s length=$l(plcstr,"^")
	f index=1:1:length-1 d
	.s firId=$p(plcstr,"^",index)
	.s secId=$p(plcstr,"^",index+1)
	.s firDate=$p(^DHCEMPCL(firId),"^",4) 			//分诊日期
	.s firTime=$p(^DHCEMPCL(firId),"^",5) 			//分诊时间
	.s secDate=$p(^DHCEMPCL(secId),"^",4) 			//分诊日期
	.s secTime=$p(^DHCEMPCL(secId),"^",5) 			//分诊时间
	.s timeSpace=(firTime-secTime)/3600+(firDate-secDate)*24
	.q:$SYSTEM.SQL.ABS(timeSpace)>72
	.s count=count+1
	
	q count
}

/// Description: 预检分级病人重返明细统计分析
/// Creator:     yuliping
/// CreateDate:  2017-07-19
/// Input:  	 一个病人所有分级id
/// Return: 	 重返次数
/// Others:		 w ##class(web.DHCEMPatCheckLevStat).getReturnOfAdm("1323^1322^1321^1320^1318")
ClassMethod getReturnOfAdmDtl(plcstr As %String, PAPMIDr)
{
	
	n (plcstr,PAPMIDr)
	s count=0         //重返次数
	
	s length=$l(plcstr,"^")
	f index=1:1:length-1 d
	.s firId=$p(plcstr,"^",index)
	.s secId=$p(plcstr,"^",index+1)
	.s firDate=$p(^DHCEMPCL(firId),"^",4) 			//分诊日期
	.s firTime=$p(^DHCEMPCL(firId),"^",5) 			//分诊时间
	.s secDate=$p(^DHCEMPCL(secId),"^",4) 			//分诊日期
	.s secTime=$p(^DHCEMPCL(secId),"^",5) 			//分诊时间
	.s timeSpace=(firTime-secTime)/3600+(firDate-secDate)*24
	.q:$SYSTEM.SQL.ABS(timeSpace)>72
	.i '$d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",firId)) s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",firId)=PAPMIDr
	.i '$d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",secId)) s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",secId)=PAPMIDr
	.s count=count+1
	
	f index=1:1:length-1 d							//72小时重返下没有，就加到非重返global下面
	.s id=$p(plcstr,"^",index)
	.i '$d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",id)) d
	..
	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","N",id)=PAPMIDr
	
	s inId="",inStr=""
	f  s inId=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","Y",inId)) q:inId=""  d
	.i inStr'="" d
	..s inStr=inStr_"^"_inId
	.e  d
	..s inStr=inId
	
	s outId="",outStr=""
	f  s outId=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getReturnOfAdm","N",outId)) q:outId=""  d
	.i outStr'="" d
	..s outStr=outStr_"^"_outId
	.e  d
	..s outStr=outId
	
	q count_"!"_inStr_"!"_outStr
}

/// Description: 获取某个就诊的上次就诊ID
/// Creator:     qqa
/// CreateDate:  2017-09-05
/// Input:  	 PaAdm
/// Return: 	 Adm
/// w ##class(web.DHCEMPatCheckLevStat).GetIsCheckLevPat("1461")
ClassMethod GetIsCheckLevPat(Adm)
{
	n (Adm)
	q:+Adm=0
	s repid=$I(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat")
	s PatDr = $p(^PAADM(Adm),"^",1)
	s AdmType=""
 	f  s AdmType = $o(^PAPERdr(PatDr,"ADM",AdmType)) q:AdmType=""  d
 	.s AdmDr = ""
 	.f  s AdmDr = $o(^PAPERdr(PatDr,"ADM",AdmType,AdmDr))  q:AdmDr=""  d
 	..s AdmDate = $p(^PAADM(AdmDr),"^",6)
 	..s AdmTime = $p(^PAADM(AdmDr),"^",7)
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime)=AdmDr
 	
 	s AdmDate="",EmAdm=""
 	f  s AdmDate = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate),-1) q:AdmDate=""  d
 	.s AdmTime=""
 	.f  s AdmTime = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime),-1) q:AdmTime=""  d
 	..s PaAdm = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime)
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","adm",PaAdm)=""
 	
 	q $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","adm",Adm),-1)
}

/// Description: 获取某个就诊的下次就诊ID
/// Creator:     qqa
/// CreateDate:  2018-10-25
/// Input:  	 PaAdm
/// Return: 	 Adm
/// w ##class(web.DHCEMPatCheckLevStat).GetNextAdm("1461")
ClassMethod GetNextAdm(Adm)
{
	n (Adm)
	q:+Adm=0
	s repid=$I(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat")
	s PatDr = $p(^PAADM(Adm),"^",1)
	s AdmType=""
 	f  s AdmType = $o(^PAPERdr(PatDr,"ADM",AdmType)) q:AdmType=""  d
 	.s AdmDr = ""
 	.f  s AdmDr = $o(^PAPERdr(PatDr,"ADM",AdmType,AdmDr))  q:AdmDr=""  d
 	..s AdmDate = $p(^PAADM(AdmDr),"^",6)
 	..s AdmTime = $p(^PAADM(AdmDr),"^",7)
 	..q:AdmTime="" //hxy 2020-04-03
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime)=AdmDr
 	
 	s AdmDate="",EmAdm=""
 	f  s AdmDate = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate),-1) q:AdmDate=""  d
 	.s AdmTime=""
 	.f  s AdmTime = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime),-1) q:AdmTime=""  d
 	..s PaAdm = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime)
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","adm",PaAdm)=""
 	
 	q $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","adm",Adm))
}

/// w ##class(web.DHCEMPatCheckLevStat).PatIsReturn()
ClassMethod PatIsReturn(PclRowStr)
{
	n (PclRowStr)
	q:$l(PclRowStr,":")<2 0	
	s IsReturnPat=0
	f i=1:1:($l(PclRowStr,":")-1) q:IsReturnPat=1  d
	.s PclDr1 = $p(PclRowStr,":",i)
	.s PclDr2 = $p(PclRowStr,":",i+1)
	.s PCLDate1 = $p(^DHCEMPCL(PclDr1),"^",4)
	.s PCLDate2 = $p(^DHCEMPCL(PclDr2),"^",4)
	.s PCLTime1 = $p(^DHCEMPCL(PclDr1),"^",5)
	.s PCLTime2 = $p(^DHCEMPCL(PclDr2),"^",5)
	.q:PCLDate2-PCLDate1>3
	.q:(PCLDate2-PCLDate1=3)&(PCLTime1<=PCLTime2)   ///判断在72小时之内
	.s IsReturnPat=1
	q IsReturnPat
}

/// Descript:   k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute",pid)
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstVisOfAdmExecute","Loc",pid)
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","QueryFirstAdmInfo",pid) 
	q ""
}

Storage Default
{
<Data name="DHCEMPatCheckLevStatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMPatCheckLevStatD</DataLocation>
<DefaultData>DHCEMPatCheckLevStatDefaultData</DefaultData>
<IdLocation>^web.DHCEMPatCheckLevStatD</IdLocation>
<IndexLocation>^web.DHCEMPatCheckLevStatI</IndexLocation>
<StreamLocation>^web.DHCEMPatCheckLevStatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
