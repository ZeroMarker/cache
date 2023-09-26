/// Descript:   急诊预检分级报告
/// Creator:    huaxiaoying
/// CreateDate: 2018-07-11
Class web.DHCEMLevelRep Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "Level:%String,Num:%String,inNum:%String,leaveNum:%String,deathNum:%String,Minutes:%String,stayNum:%String") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMLevelRep","admNumQuery","2018-08-02","2018-08-02")
 	
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
  	
  	k ^TMP("DHCEM","web.DHCEMLevelRep","admNumQuery")  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))            /// 过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..q:+PCLNurseLevel=0
    ..s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-28
	
	..s ^TMP("DHCEM","web.DHCEMLevelRep","admNumQuery",repid,PCLNurseLevel,PCLDr)=""	
	
	s PCLNurseLevel = 0
	f  s PCLNurseLevel = $o(^TMP("DHCEM","web.DHCEMLevelRep","admNumQuery",repid,PCLNurseLevel)) q:PCLNurseLevel=""  d
	.s PatientID="",num=0
	.s stayNum=0,leaveNum=0,deathNum=0,Minutes=0,inNum=0 //
	.f  s PCLDr = $o(^TMP("DHCEM","web.DHCEMLevelRep","admNumQuery",repid,PCLNurseLevel,PCLDr)) q:PCLDr=""  d
    ..s num=num+1
    ..s PCLCreateDate=$p(^DHCEMPCL(PCLDr),"^",4)  ///分诊日期
    ..s PCLCreateTime=$p(^DHCEMPCL(PCLDr),"^",5)  ///分诊时间
    ..s EpisodeID="",PCARowID=""
	..s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLDr,PCARowID)) 
	..i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2) ///就诊号
    ..;S WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID) //获取当前状态
    ..;I WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
    ..S WalkStatus=..GetStatusHistory(EpisodeID) //获取历史状态 2018-08-03
	..i WalkStatus["离院" s leaveNum=leaveNum+1 //WalkStatus="离院"
	..i WalkStatus["死亡" s deathNum=deathNum+1
	..i WalkStatus["留观" s stayNum=stayNum+1
	..i WalkStatus["入院" s inNum=inNum+1
	..//离院日期时间
	..s GoDate="",GoTime="",Dadvid=""     //取最后一次离院时间
	..i EpisodeID'="" d
	...s Dadvid=""
	...;s Dadvid =$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid),-1)
	...f  s Dadvid=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid)) q:Dadvid=""  d //2018-08-04
	....q:Dadvid=""
    ....s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    ....q:+DadvStu'=6
    ....s GoDate=$p(^DHCADMVisitStatus(Dadvid),"^",5)  //离院时间
    ....s GoTime=$p(^DHCADMVisitStatus(Dadvid),"^",6)
    ..i GoTime=0 s GoTime=$p($h,",",2)                             //hxy 2018-08-02
    
    ..//入院时间 2018-08-05 针对护士可能只入院未离院，取入院时间为离院时间
	..s InDate="",InTime=""
 	..i EpisodeID'="" d 
 	...s avsId=""
 	...f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
    ....s patWhere=$p($g(^DHCADMVisitStatus(avsId)),"^",2) //病人状态dr
    ....q:patWhere'=7
    ....s InDate=$p(^DHCADMVisitStatus(avsId),"^",5)  //入院日期
    ....s InTime=$p(^DHCADMVisitStatus(avsId),"^",6)  //入院时间
	..i (GoDate="")&&(InDate'="") d 
    ...s GoDate=InDate
    ...s GoTime=InTime
    
	..//停留时间的单位:单位为分钟,大致为 离开急诊时间-接诊时间
	..s Minute=0
	..i GoDate="" d
   	...s Minute=(+$h-PCLCreateDate)*24*60+$j(($p($h,",",2)-PCLCreateTime)/60,2,2)
    ..e  d
    ...s Minute=(GoDate-PCLCreateDate)*24*60+$j((GoTime-PCLCreateTime)/60,2,2)
    ..s Minutes=Minutes+Minute
    ..;s inNum=num-leaveNum-deathNum-stayNum //收住院人次
    .i num'=0 s Minutes=$j((Minutes/num),2,2)
    .//i PCLNurseLevel=4 s PCLNurseLevel="4A"
	.//i PCLNurseLevel=5 s PCLNurseLevel="4B"
    .d OutputRow1
    .//i PCLNurseLevel="4A" S PCLNurseLevel=4 //2018-08-09
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PCLNurseLevel,num,inNum,leaveNum,deathNum,Minutes,stayNum)
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

ClassMethod GetStatusHistory(EpisodeID)
{
	q:EpisodeID="" ""
	s avsId="-1",StatusHistory=""
    f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
    .s patWhere=$p($g(^DHCADMVisitStatus(avsId)),"^",2) //病人状态dr
    .q:patWhere=""	//病人状态dr
	.s patWhereDesc=$p(^DHCPACVisitStatus(patWhere),"^",2)
	.s StatusHistory=StatusHistory_patWhereDesc
	Q StatusHistory
}

}
