/// Descript:   病人来源统计
/// Creator:    huaxiaoying
/// CreateDate: 2018-04-10
Class web.DHCEMPatScreenNum Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "PatScreen:%String,Num:%String") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatScreenNum","admNumQuery","2018-01-04","2018-08-04")
 	
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
  	
  	k ^TMP("DHCEM","web.DHCEMPatScreenNum","admNumQuery",repid)  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0,PCLPatSource=""
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))                    /// 过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLPatScreen=$p(^DHCEMPCL(PCLDr),"^",18)  /// 筛查
    ..q:PCLPatScreen=""
	..s ^TMP("DHCEM","web.DHCEMPatScreenNum","admNumQuery",repid,PCLPatScreen,PatientID)=""	
	s PCLPatScreen = 0
	f  s PCLPatScreen = $o(^TMP("DHCEM","web.DHCEMPatScreenNum","admNumQuery",repid,PCLPatScreen)) q:PCLPatScreen=""  d
	.s PatientID="",num=0
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatScreenNum","admNumQuery",repid,PCLPatScreen,PatientID)) q:PatientID=""  d
    ..s num=num+1
    .d OutputRow1
    
    K ^TMP("DHCEM","web.DHCEMPatScreenNum","admNumQuery",repid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PCLPatScreen,num)
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

Query admNumInfoQuery(stDate, edDate, PatScreen, HOSPID) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod admNumInfoQueryExecute(ByRef qHandle As %Binary, stDate, edDate, PatScreen, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatScreenNum","admNumInfoQuery","2018-08-01","2018-08-28","Y")
	s ^qqa = $lb( stDate, edDate, PatScreen)
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
  	
  	k ^TMP("DHCEM","web.DHCEMPatScreenNum","admNumInfoQuery",repid)  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))            ///过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLCreateDate=$p(^DHCEMPCL(PCLDr),"^",4)  ///分诊日期
    ..s PCLCreateTime=$p(^DHCEMPCL(PCLDr),"^",5)  ///分诊时间
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..s PCLPatScreen=$p(^DHCEMPCL(PCLDr),"^",18)  /// 筛查
    ..q:PCLPatScreen=""
    ..q:(PatScreen'="")&(PCLPatScreen'=PatScreen)
	..s ^TMP("DHCEM","web.DHCEMPatScreenNum","admNumInfoQuery",repid,PatientID,PCLDr)=""
	b ;data
	s PatientID=""
	f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatScreenNum","admNumInfoQuery",repid,PatientID)) q:PatientID=""  d
    .s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatientID,HOSPID) //hxy 2020-06-11
    .s name = $p(PatInfo,"^",2)
	.s curregno = $p(PatInfo,"^",1)
	.s PatCardNo = $p(PatInfo,"^",12)
	.s sexId = $p(PatInfo,"^",3)
	.s age = $p(PatInfo,"^",4)
	.s PCLDr=""
	.f  s PCLDr = $o(^TMP("DHCEM","web.DHCEMPatScreenNum","admNumInfoQuery",repid,PatientID,PCLDr)) q:PCLDr=""  d 
    ..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PCLDr)
	..s pclDate = $p(pclData,"^",2)			//日期
	..s pclTime = $p(pclData,"^",3)			//时间
	..s symptom = ##Class(web.DHCEMECheck).GetSymDesc(PCLDr) ;$p(pclData,"^",4)			//症状
	..s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	..s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	..s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	..s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	..s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	..s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	..s NurseLevel=$p(pclData,"^",16)      	//护士分级
	..s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-28 st
	..s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	..s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	..s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
    ..d OutputRow999
    

    K ^TMP("DHCEM","web.DHCEMPatScreenNum","admNumInfoQuery",repid)
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
