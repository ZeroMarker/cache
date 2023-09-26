/// Descript:   按号别统计入院人数及明细（要分级、入院病区）
/// Creator:    huaxiaoying
/// CreateDate: 2018-08-05
Class web.DHCEMPatCare Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "PatChkCare:%String,num:%String") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatCare","admNumQuery","2018-08-01","2018-08-04")
 	
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
  	
  	k ^TMP("DHCEM","web.DHCEMPatCare","admNumQuery")  
  	
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))                    /// 过滤错误数据
    ..s EmPatChkCare=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkCare(PCLDr)      /// 预检号别表
	..s PatChkCare=$p(EmPatChkCare,"@",2) //号别
	..q:PatChkCare="" /// 过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
	..s EpisodeID="",PCARowID=""
	..s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLDr,PCARowID)) 
	..i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2) ///就诊号
	..//是否入院，没有入院记录退出
	..s PatWhere=""
	..i EpisodeID'="" S PatWhere=##class(web.DHCEMLevelRep).GetStatusHistory(EpisodeID) //获取历史状态 2018-08-03
	..q:PatWhere'["入院"
	..s ^TMP("DHCEM","web.DHCEMPatCare","admNumQuery",repid,PatChkCare,PCLDr)=""
	
	s PatChkCare = 0
	f  s PatChkCare = $o(^TMP("DHCEM","web.DHCEMPatCare","admNumQuery",repid,PatChkCare)) q:PatChkCare=""  d
	.s PCLDr="",num=0
	.f  s PCLDr = $o(^TMP("DHCEM","web.DHCEMPatCare","admNumQuery",repid,PatChkCare,PCLDr)) q:PCLDr=""  d
	..s Care=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkCare(PCLDr)      /// 预检号别表
	..s Care=$p(Care,"@",2) //号别
	..q:Care'=PatChkCare
    ..s num=num+1
    .d OutputRow1
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatChkCare,num)
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

Query admNumInfoQuery(stDate, edDate, PatCare, HOSPID = "") As %Query(ROWSPEC = "PatNo:%String,Name:%String,Sex:%String,Age:%String,Tel:%String,Address:%String,PCLSymDesc:%String,PCLNurseLevel:%String,wardDesc:%String") [ SqlProc ]
{
}

ClassMethod admNumInfoQueryExecute(ByRef qHandle As %Binary, stDate, edDate, PatCare, HOSPID = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPatCare","admNumInfoQuery","2018-08-01","2018-08-05","急诊外科号")
	
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (stDate="")||(edDate="" ) Quit $$$OK
    set ind=1

  	//编码开始
  	i (stDate="")||(edDate="" ) Quit $$$OK
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PAPMIDr=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PAPMIDr))            ///过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:(CurHospID'=HOSPID)&&(HOSPID'="") //ed
	..s Care=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkCare(PCLDr)      /// 预检号别表
	..s Care=$p(Care,"@",2) //号别
	..q:Care="" /// 过滤错误数据
    ..q:(Care'=PatCare)&(PatCare'="")
    ..s EpisodeID="",PCARowID=""
	..s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLDr,PCARowID)) 
	..i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2) ///就诊号
	..//是否入院，没有入院记录退出
	..s PatWhere=""
	..i EpisodeID'="" S PatWhere=##class(web.DHCEMLevelRep).GetStatusHistory(EpisodeID) //获取历史状态 2018-08-03
	..q:PatWhere'["转入院"
    ..s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PAPMIDr,HOSPID) //hxy 2020-06-10 HOSPID
    ..s PatNo = $p(PatInfo,"^",1) ///病人登记号 ：病人ID取系统的登记号
	..s Name = $p(PatInfo,"^",2) ///病人姓名
	..s Sex = $p(PatInfo,"^",3) /// 性别
	..s Age = $p(PatInfo,"^",4)  /// 年龄
	..s Tel=$p(^PAPER(PAPMIDr,"PER",1),"^",11) /// 电话 
	..s Address=$g(^PAPER(PAPMIDr,"PER","ADD",1)) /// 家庭住址
	..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7)   /// 护士分级
  	..;s PCLSymDesc=$p(^DHCEMPCL(PCLDr),"^",25) ///症状描述
    ..s PCLSymDesc=##Class(web.DHCEMECheck).GetSymDesc(PCLDr)
    ..s PCLSymDesc=$tr(PCLSymDesc,"!","")
    ..s PCLSymDesc=$tr(PCLSymDesc,"#",",")
    ..s PCLOther=$p(^DHCEMPCL(PCLDr),"^",36)      ///其他 
    ..s PCLSymDesc=PCLSymDesc_" "_PCLOther           ///症状描述+其他
    ..s EpisodeID="",PCARowID=""
	..s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLDr,PCARowID)) 
	..i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2) ///就诊号
    ..//入院科室取转到哪个病区
	..s wardDr="",wardDesc=""
 	..i EpisodeID'="" d
 	...s avsId=""
 	...f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
 	....q:avsId=0
    ....s patWhere=$p($g(^DHCADMVisitStatus(avsId)),"^",2) //病人状态dr
    ....s visitStatusCode=$p(^DHCPACVisitStatus(+patWhere),"^",1)
    ....q:visitStatusCode'="DisplaceOrInHospital"
    ....s wardDr=$p($g(^DHCADMVisitStatus(avsId)),"^",10) 
    ....i wardDr'="" s wardDesc=$p(^PAWARD(wardDr),"^",2) 
    ..s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-25
    ..d OutputRow999
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow999
	s Data=$lb(PatNo,Name,Sex,Age,Tel,Address,PCLSymDesc,PCLNurseLevel,wardDesc)
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
