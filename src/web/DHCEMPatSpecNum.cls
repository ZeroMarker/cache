/// Descript:   六大病种的统计
/// Creator:    huaxiaoying
/// CreateDate: 2018-04-10
Class web.DHCEMPatSpecNum Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "PatSpec:%String,Num:%String") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatSpecNum","admNumQuery","2018-08-01","2018-08-22")
 	
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
  	
  	k ^TMP("DHCEM","web.DHCEMPatSpecNum","admNumQuery")  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0,PatSpec=""
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))                    /// 过滤错误数据
    ..q:'$d(^DHCEMPCSP("0","PatCheckLev",PCLDr))
    ..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-09 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCSPId="" //hxy 2020-04-08 st
    ..f  s PCSPId = $o(^DHCEMPCSP(0,"PatCheckLev",PCLDr,PCSPId)) q:PCSPId=""  d
    ...s PCSPSpecDiseDr=$p($g(^DHCEMPCSP(+PCSPId)),"^",2) 
    ...q:+PCSPSpecDiseDr=0
    ...s PatSpec=$p(^DHCEMSPD(PCSPSpecDiseDr),"^",2)
	...s ^TMP("DHCEM","web.DHCEMPatSpecNum","admNumQuery",repid,PatSpec,PatientID)=""
    ..;s PCSPId=$o(^DHCEMPCSP("0","PatCheckLev",PCLDr,""))
    ..;s PCSPSpecDiseDr=$p(^DHCEMPCSP(PCSPId),"^",2) 
    ..;q:+PCSPSpecDiseDr=0
    ..;s PatSpec=$p(^DHCEMSPD(PCSPSpecDiseDr),"^",2)
	..;s ^TMP("DHCEM","web.DHCEMPatSpecNum","admNumQuery",repid,PatSpec,PatientID)="" //ed
	s PatSpec = 0
	f  s PatSpec = $o(^TMP("DHCEM","web.DHCEMPatSpecNum","admNumQuery",repid,PatSpec)) q:PatSpec=""  d
	.s PatientID="",num=0
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatSpecNum","admNumQuery",repid,PatSpec,PatientID)) q:PatientID=""  d
    ..s num=num+1
    .d OutputRow1
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatSpec,num)
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

Query admNumInfoQuery(stDate, edDate, PatSpec, HOSPID) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod admNumInfoQueryExecute(ByRef qHandle As %Binary, stDate, edDate, PatSpec, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatSpecNum","admNumInfoQuery","2018-08-01","2018-08-29","急性创伤")
	
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
  	
  	k ^TMP("DHCEM","web.DHCEMPatSpecNum","admNumInfoQuery",repid)  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))            ///过滤错误数据
    ..s PCLCreateDate=$p(^DHCEMPCL(PCLDr),"^",4)  ///分诊日期
    ..s PCLCreateTime=$p(^DHCEMPCL(PCLDr),"^",5)  ///分诊时间
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..q:'$d(^DHCEMPCSP("0","PatCheckLev",PCLDr)) 
    ..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..;s PCSPId=$o(^DHCEMPCSP("0","PatCheckLev",PCLDr,""))   //hxy 2020-04-08 st
    ..;s PCSPSpecDiseDr=$p(^DHCEMPCSP(PCSPId),"^",2)  
    ..;q:+PCSPSpecDiseDr=0
    ..;s PCSPPatSpec=$p(^DHCEMSPD(PCSPSpecDiseDr),"^",2)
    ..;q:(PCSPPatSpec'=PatSpec)&(PatSpec'="")
	..;s ^TMP("DHCEM","web.DHCEMPatSpecNum","admNumInfoQuery",repid,PatientID,PCLDr) = ""
	..s PCSPId="" 
    ..f  s PCSPId = $o(^DHCEMPCSP(0,"PatCheckLev",PCLDr,PCSPId)) q:PCSPId=""  d
    ...s PCSPSpecDiseDr=$p($g(^DHCEMPCSP(+PCSPId)),"^",2)  
    ...q:+PCSPSpecDiseDr=0
    ...s PCSPPatSpec=$p(^DHCEMSPD(PCSPSpecDiseDr),"^",2)
    ...q:(PCSPPatSpec'=PatSpec)&(PatSpec'="")
	...s ^TMP("DHCEM","web.DHCEMPatSpecNum","admNumInfoQuery",repid,PatientID,PCLDr) = "" //ed
	
	s PatientID=""
	f  s PatientID = $o(^TMP("DHCEM","web.DHCEMPatSpecNum","admNumInfoQuery",repid,PatientID)) q:PatientID=""  d
	.s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatientID,HOSPID) //hxy 2020-06-10
	.s name = $p(PatInfo,"^",2)
	.s curregno = $p(PatInfo,"^",1)
	.s PatCardNo = $p(PatInfo,"^",12)
	.s sexId = $p(PatInfo,"^",3)
	.s age = $p(PatInfo,"^",4)
    .s PCLDr =""
    .f  s PCLDr = $o(^TMP("DHCEM","web.DHCEMPatSpecNum","admNumInfoQuery",repid,PatientID,PCLDr)) q:PCLDr=""  d
  	..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PCLDr)
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
    ..d OutputRow999  
  
    
    k ^TMP("DHCEM","web.DHCEMPatSpecNum","admNumInfoQuery",repid)
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
