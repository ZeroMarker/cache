/// Descript:   病人来源统计
/// Creator:    huaxiaoying
/// CreateDate: 2018-04-09
Class web.DHCEMPatSourceNum Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "PatSource:%String,Num:%String") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatSourceNum","admNumQuery","2018-01-04","2018-08-04")
 	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (stDate="")||(edDate="" ) Quit $$$OK
    set ind=1
	
  	//编码开始
  	
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
  	k ^TMP("DHCEM","web.DHCEMPatSourceNum","admNumQuery")  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0,PCLPatSource=""
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))                    /// 过滤错误数据
    ..s PCLPatSourceDr=$p(^DHCEMPCL(PCLDr),"^",15)  /// 病人来源id
    ..q:+PCLPatSourceDr=0
    ..q:'$d(^DHCEMPSO(PCLPatSourceDr))
    ..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLPatSource=$p(^DHCEMPSO(PCLPatSourceDr),"^",2)
	..s ^TMP("DHCEM","web.DHCEMPatSourceNum","admNumQuery",repid,PCLPatSource,PatientID)=""	
	s PCLPatSource = 0
	f  s PCLPatSource = $o(^TMP("DHCEM","web.DHCEMPatSourceNum","admNumQuery",repid,PCLPatSource)) q:PCLPatSource=""  d
	.s PatientID="",num=0
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatSourceNum","admNumQuery",repid,PCLPatSource,PatientID)) q:PatientID=""  d
    ..s num=num+1
    .d OutputRow1
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PCLPatSource,num)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admNumQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admNumQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod admNumQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admNumtQueryExecute ]
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

Query admNumInfoQuery(stDate, edDate, PatSource, HOSPID) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod admNumInfoQueryExecute(ByRef qHandle As %Binary, stDate, edDate, PatSource, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatSourceNum","admNumInfoQuery","2018-01-04","2018-08-04","120")
	
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (stDate="")||(edDate="" ) Quit $$$OK
    set ind=1

  	//编码开始
  	;s:stDate="" stDate=+$h
  	;s:edDate="" edDate=+$h
  	i (stDate="")||(edDate="" ) Quit $$$OK
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
  	k ^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery")  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))            ///过滤错误数据
    ..s PCLCreateDate=$p(^DHCEMPCL(PCLDr),"^",4)  ///分诊日期
    ..s PCLCreateTime=$p(^DHCEMPCL(PCLDr),"^",5)  ///分诊时间
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..s PCLPatSourceDr=$p(^DHCEMPCL(PCLDr),"^",15)  /// 病人来源id
    ..q:+PCLPatSourceDr=0
    ..q:'$d(^DHCEMPSO(PCLPatSourceDr))
    ..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLPatSource=$p(^DHCEMPSO(PCLPatSourceDr),"^",2)
    ..q:(PCLPatSource'=PatSource)&(PatSource'="")
	..i $d(^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery",repid,PatientID)) d
	...s ^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery",repid,PatientID) = ^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery",repid,PatientID)_":"_PCLDr
	..e  d
	...s ^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery",repid,PatientID) = PCLDr
	
	.s PatientID=""
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery",repid,PatientID)) q:PatientID=""  d
    ..
    
    s PatDr=0
	f  s PatDr = $o(^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery",repid,PatDr)) q:PatDr=""  d
	.s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr,HOSPID) //hxy 2020-06-10 HOSPID
	.s PclRowStr = ^TMP("DHCEM","web.DHCEMPatSourceNum","admNumInfoQuery",repid,PatDr)
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
	..s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-25 st
	..s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	..s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	..s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
    ..d OutputRow999
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow999
	s Data=$lb(curregno,name,sexId,age,PatCardNo,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel,pclDate,pclTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admNumInfoQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admNumInfoQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod admNumInfoQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admNumtQueryExecute ]
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

}
