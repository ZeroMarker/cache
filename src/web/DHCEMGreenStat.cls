/// Descript:   绿色通道患者统计表
/// Creator:    huaxiaoying
/// CreateDate: 2018-07-11
Class web.DHCEMGreenStat Extends %RegisteredObject
{

ClassMethod GreenQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GreenQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GreenQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMGreenStat","GreenQuery","2018-08-01","2018-08-04")
	
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
  	s stDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate) 
  	s edDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate) ;$zdh(edDate,3) ;
  	
  	s num=0
  	f CurDate=stDate:1:edDate  d
    .s PCLRowID=0  
    .f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",CurDate,PCLRowID)) q:PCLRowID=""  d
    ..s PatientID=$p(^DHCEMPCL(PCLRowID),"^",1)      /// 病人ID
    ..;q:'$d(^PAPER(PatientID,"PAT",1)) /// 过滤错误数据
    ..q:'$d(^PAPER(PatientID))
    ..s PatLocID=$p(^DHCEMPCL(PCLRowID),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..;s EmPatGreFlag=##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(PCLRowID,"") /// 绿色通道 2017-02-28 bianshuai
    ..s EmPatGreFlag=##Class(web.DHCEMPatGreenRec).checkGreenRec("",PCLRowID,"") /// 绿色通道
    ..s EpisodeID="",PCARowID=""
	..s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,PCARowID)) 
	..i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2) ///就诊号
	..s:(EmPatGreFlag'=1)&&(EpisodeID'="") EmPatGreFlag=##class(web.DHCEMPatGreenRec).checkGreenRec(EpisodeID,"","")
	..q:EmPatGreFlag'=1   // 绿色通道患者统计表(六大病种、胸痛、绿色通道) hxy 2018-08-08st  //hxy 2020-04-28 放开注释 st
	..;s SixSickStr = ##class(web.DHCEMPatCheckLevQuery).GetSixSick(PCLRowID) //六大病种 
	..;s EmSymDescStr=$p(^DHCEMPCL(PCLRowID),"^",25) 	    /// 症状 / 主诉
	..;W EmPatGreFlag_SixSickStr_EmSymDescStr,!
	..;q:(EmPatGreFlag'=1)&&(SixSickStr="")&&(EmSymDescStr'["胸痛") //2018-08-08 ed //ed 标库还是以绿通为准：注释了三行
	
    ..s PCLCreateDate=$p(^DHCEMPCL(PCLRowID),"^",4)  ///分诊日期
    ..s PCLCreateTime=$p(^DHCEMPCL(PCLRowID),"^",5)  ///分诊时间       
    ..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	///病人登记号 ：病人ID取系统的登记号
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    ///病人姓名
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 性别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(PCLRowID)   /// 年龄
	..S PatDiag=""
	..i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDescForRunQian(EpisodeID) //诊断
	..S WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)  //病人去向取病人的状态：留观、住院、离院、死亡
	..I WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2) //获取
	..//入院科室取转到哪个病区
	..s wardDr="",wardDesc="",InDate="",InTime=""
 	..;改为走住院证
 	..i EpisodeID'="" d 
    ...s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	...i IPBKRowID'="" d
	....s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	....q:ToAdmID=""
	....s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I") 	;住院号
	....s wardDr=$p(^PAADM(ToAdmID),"^",70)
	....s wardDesc=$p($g(^PAWARD(+wardDr)),"^",2)
	....s InDate = $p(^PAADM(ToAdmID),"^",6) 				;入院日期
	....s InTime = $p(^PAADM(ToAdmID),"^",7) 				;入院时间
	..//离开急诊时间:单位为分钟取门急诊就诊完成的时间  =取护士点 离院 这个状态的时间
	..//离院日期时间
	..s GoDate="",GoTime=""     //取最后一次离院时间
	..i EpisodeID'="" d
	...s avsId=""
    ...f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
    ....s patWhere=$p($g(^DHCADMVisitStatus(avsId)),"^",2) //病人状态dr
    ....q:patWhere'=6
    ....s GoDate=$p(^DHCADMVisitStatus(avsId),"^",5)  //离院时间
    ....s GoTime=$p(^DHCADMVisitStatus(avsId),"^",6)
    ..i GoTime=0 s GoTime=$p($h,",",2)  //hxy 2018-08-02
    
    ..i (GoDate="")&&(InDate'="") d //hxy 2018-08-05 针对护士可能只入院未离院，取入院时间为离院时间
    ...s GoDate=InDate
    ...s GoTime=InTime

	..//停留时间的单位:单位为分钟,大致为 离开急诊时间-接诊时间
	..i GoDate="" d
   	...s Minutes=(+$h-PCLCreateDate)*24*60+$j(($p($h,",",2)-PCLCreateTime)/60,2,2)
    ..e  d
    ...s Minutes=(GoDate-PCLCreateDate)*24*60+$j((GoTime-PCLCreateTime)/60,2,2)
    ..s:PCLCreateDate'="" PCLCreateDate=$zd(PCLCreateDate,3) //##class(web.DHCEMCommonUtil).DateLogicalToHtml(PCLCreateDate)
    ..s PCLCreateTime=$zt(PCLCreateTime)
    ..s Date=PCLCreateDate_" "_PCLCreateTime //接诊时间：取护士预检分诊的时间
    ..s:GoDate'="" GoDate=$zd(GoDate,3) //##class(web.DHCEMCommonUtil).DateLogicalToHtml(GoDate)
    ..i GoTime'="" s GoTime=$zt(GoTime)
    ..s GoDate=GoDate_" "_GoTime
	..s num=num+1
	..d OutputRow1
    
    //编码结束
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(num,Date,PatNo,PatName,PatSex,PatAge,PatDiag,WalkStatus,wardDesc,GoDate,Minutes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GreenQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GreenQueryExecute ]
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

Query GreenQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "num:%String,Date:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatDiag:%String,WalkStatus:%String,wardDesc:%String,GoDate:%String,Minutes:%String") [ SqlProc ]
{
}

}
