Class web.DHCDISSplitMerge Extends %RegisteredObject
{

/// Description:获取下送项目信息
/// Creator:     zhanghailong
/// CreateDate:  2017-02-15
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// w ##class(web.DHCDISSplitMerge).GetMerge(119)
ClassMethod GetMerge(mergeid As %String)
{
	s count=0
	w "{""rows"":["
	s RecLocDr=$p(^DHCDISGRE(mergeid),"^",3) //接收科室
	s reqid=0
	f  s reqid=$o(^DHCDISGRE(reqid)) q:reqid=""  d
	.q:mergeid=reqid
	.s REQCurStatus=$p(^DHCDISGRE(reqid),"^",10)
	.s Status=$p($g(^DHCDISSA(REQCurStatus)),"^",2)  //处理状态
	.q:Status'="待处理"
	.s RecLoc=$p(^DHCDISGRE(reqid),"^",3)  //接收科室
	.q:RecLocDr'=RecLoc
	.s reqidd=""
	.f  s reqidd=$o(^DHCDISGRE(reqid,"ITM",reqidd)) q:reqidd=""  d
	..s LocDr=$p(^DHCDISGRE(reqid,"ITM",reqidd),"^",2) 
	..s num=$p(^DHCDISGRE(reqid,"ITM",reqidd),"^",3)  //数量 
	..s LocDesc=$p(^CTLOC(LocDr),"^",2)
	..s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)       //科室名称
	..s itmdr=$p(^DHCDISGRE(reqid,"ITM",reqidd),"^",1)    //项目id
	..s itmdrdesc=$p(^DHCDISLI(itmdr),"^",2)
	..s tmp=itmdrdesc_"^"_LocDesc_"^"_num_"^"_reqid
	..s count=count+1
	..w $case(count,1:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData("itmdrdesc^LocDesc^num^reqid",tmp)
	w "],""total"":"_count_"}"
	q ""
}

/// Description:获取上收项目信息
/// Creator:     zhanghailong
/// CreateDate:  2017-02-15
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// w ##class(web.DHCDISSplitMerge).GetInfo(114)
ClassMethod GetInfo(mergeid As %String)
{
	;s mergeid=114
	s count=0
	w "{""rows"":["
	s reqid=""
	f  s reqid=$o(^DHCDISGRE(mergeid,"ITM",reqid)) q:reqid=""  d
	.s LocDr=$p(^DHCDISGRE(mergeid,"ITM",reqid),"^",2) 
	.s num=$p(^DHCDISGRE(mergeid,"ITM",reqid),"^",3)  //数量 
	.s LocDesc=$p(^CTLOC(LocDr),"^",2)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)       //科室名称
	.s itmdr=$p(^DHCDISGRE(mergeid,"ITM",reqid),"^",1)    //项目id
	.s itmdrdesc=$p(^DHCDISLI(itmdr),"^",2)
	.s tmp=itmdrdesc_"^"_LocDesc_"^"_num_"^"_mergeid
	.s count=count+1
	.w $case(count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("itmdrdesc^LocDesc^num^mergeid",tmp)
	w "],""total"":"_count_"}"
	q ""
}

}
