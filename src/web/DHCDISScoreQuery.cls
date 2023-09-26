Class web.DHCDISScoreQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description:科室列表下拉
/// Creator:     zhanghailong
/// CreateDate:  2017-02-08
/// Table: 		 
/// Input:  	 HospID
/// Return： 	 
/// W ##Class(web.DHCDISScoreQuery).GetApplayLoc("2")   
ClassMethod GetApplayLoc(HospID As %String)
{
	s Count=0
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	.s tmp = LocId_"^"_LocDesc
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description:分数列表下拉
/// Creator:     zhanghailong
/// CreateDate:  2017-02-09
/// Table: 		 DHC_DisRequestAsse
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISScoreQuery).GetListScore()
ClassMethod GetListScore()
{
	s Count=0
	s sid=""
	f  s sid=$o(^DHCDISRA(sid))  q:sid=""  d
	.q:sid=0
	.s info=$g(^DHCDISRA(sid))
	.q:info=""
	.s rareqtypei=$p(info,"^",1)
	.i rareqtypei="1" d
	..s score=$p(info,"^",3)_"分"
	..s Count=Count+1
	..s tmp = sid_"^"_score
	..i Count=1 d
	...w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator：      zhanghailong
/// CreatDate：    2017-02-08
/// Description:   配送人员得分查询
/// Table：        DHC_DisRequestAsse
/// Input：	       
/// Return：     
/// w ##class(web.DHCDISScoreQuery).ListPeScore("2017-02-14^^^")
ClassMethod ListPeScore(Param As %String) As %String
{
	s StrDate=$p(Param,"^",1)
    s EndDate=$p(Param,"^",2)
	s StrDate=$case(+StrDate,0:+$h-100,:$zdh(StrDate,3))
	s EndDate=$case(+EndDate,0:+$h,:$zdh(EndDate,3))
	s ApplayLoc=$p(Param,"^",3)
	s Score=$p(Param,"^",4)
	s pid=$i(^CacheTemp)
	Kill ^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore")
	s prowid="0"
	f  s prowid=$o(^DHCDISPE(prowid)) q:prowid=""  d
	.s UserDr = $p(^DHCDISPE(prowid),"^",3)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore",UserDr)=""   //临时globle
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore",UserDr)) q:UserDr=""  d
	.s (num,price)=0
	.s LocName=""
	.s LocName = ..GetLocName(UserDr)
	.q:(ApplayLoc'="")&(ApplayLoc'=LocName)
	.s UserName=""
	.s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	.s prowid="0"
	.f  s prowid=$o(^DHCDISPE(prowid)) q:prowid=""  d
	..q:UserDr'=$p(^DHCDISPE(prowid),"^",3)      
	..s Pointer = $p(^DHCDISPE(prowid),"^",2)
	..s point=$p(Pointer,"||",1)
	..s score=..GetScro(StrDate,EndDate,point)
	..q:(Score'="")&(Score'=score)
	..s num = num+score
	..q:score=0
	..s price=price+1
	.s ^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore",UserDr)=num_"^"_price_"^"_UserDr_"^"_UserName_"^"_LocName
	s count=0
	w "{""rows"":["
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore",UserDr)) q:UserDr=""  d
	.q:$p((^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore",UserDr)),"^",1)=0
	.s LocName=""
	.s LocName = ..GetLocName(UserDr)
	.q:(ApplayLoc'="")&(ApplayLoc'=LocName)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("totalScore^general^pepleNo^pepeleName^acceptLoc",^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore",UserDr)) 
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("totalScore^general^pepleNo^pepeleName^acceptLoc",^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore",UserDr))
	 w "],""total"":"_count_"}"
	Kill ^TMP("DHCEM","web.DHCDISScoreQuery","ListPeScore")
	q ""
}

/// Description:获取项目分数
/// Creator:     zhanghailong
/// CreateDate:  2017-02-15
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// w ##class(web.DHCDISScoreQuery).GetScores(820)
ClassMethod GetScores(UserDr As %String)
{
	s count=0
	w "{""rows"":["
	s prowid=0
	s score=0
	f  s prowid=$o(^DHCDISPE(prowid)) q:prowid=""  d
	.q:UserDr'=$p(^DHCDISPE(prowid),"^",3)      
	.s Pointer = $p(^DHCDISPE(prowid),"^",2)       
	.s point =$p(Pointer,"||",1)
	.s pointitm=$p(Pointer,"||",2)                  //取任务id              
	.s UserName=""																																
	.s UserName=$p(^SSU("SSUSR",UserDr),"^",2)    //取用户名
	.s reqi=""
	.f  s reqi=$o(^DHCDISGRE(point,"ITM",reqi)) q:reqi=""  d
	..q:pointitm'=reqi
	..s itmdr=$p(^DHCDISGRE(point,"ITM",reqi),"^",1)    //项目id
	..s itmdrdesc=$p(^DHCDISLI(itmdr),"^",2)       //项目名称     
	..;s itmname=$p()
	..s recloc=$p(^DHCDISGRE(point,"ITM",reqi),"^",2)
	..s LocDesc=$p(^CTLOC(recloc),"^",2)
	..s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)       //科室名称
    ..s score=..GetScroList(point)
    ..q:score=0                    //获取分数
	..s tmp=UserName_"^"_itmdrdesc_"^"_LocDesc_"^"_score
	..s count=count+1
	..w $case(count,1:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData("UserName^itmdrdesc^LocDesc^score",tmp)
	w "],""total"":"_count_"}"
	q ""
}

/// Description:获取分数
/// Creator:     zhanghailong
/// CreateDate:  2017-02-09
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// w ##class(web.DHCDISScoreQuery).GetScro("64328","64328",73)
ClassMethod GetScro(StrDate As %String, EndDate As %String, Pointer As %String)
{
	s ranubmer=0
	
	 s RAid=""
	 f  s RAid=$o(^DHCDISRA(RAid))  q:RAid=""  d
	 .q:RAid=0
	 .s msg=$g(^DHCDISRA(RAid))
	 .q:msg=""
	 .s rareqtype=$p(msg,"^",1)
	 .i rareqtype="1" d
	 ..s rapointer=$p(msg,"^",2)
	 ..q:rapointer=""
	 ..s data=""
	 ..i rapointer=Pointer s data=$p(msg,"^",5) 
	 ..q:(StrDate'="")&(EndDate'="")&(EndDate<data)
	 ..q:(StrDate'="")&(EndDate'="")&(StrDate>data)
	 ..q:(StrDate'="")&(EndDate="")&(data<StrDate)
	 ..q:data>+$h
	 ..i rapointer=Pointer  s ranubmer=$p(msg,"^",3)
	 q ranubmer
}

/// Description:获取项目分数
/// Creator:     zhanghailong
/// CreateDate:  2017-02-015
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// w ##class(web.DHCDISScoreQuery).GetScroList(73)
ClassMethod GetScroList(Pointer As %String)
{
	n (Pointer)
	s ranubmer=0
	 s RAid=""
	 f  s RAid=$o(^DHCDISRA(RAid))  q:RAid=""  d
	 .q:RAid=0
	 .s msg=$g(^DHCDISRA(RAid))
	 .q:msg=""
	 .s rareqtype=$p(msg,"^",1)
	 .i rareqtype="1" d
	 ..s rapointer=$p(msg,"^",2)
	 ..q:rapointer=""
	 ..i rapointer=Pointer  s ranubmer=$p(msg,"^",3)
	 q ranubmer
}

/// Description:获取科室的名称
/// Creator:     zhanghailong
/// CreateDate:  2017-02-09
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISScoreQuery).GetLocName()
ClassMethod GetLocName(User As %String)
{
	s acceptLoc=""
	s LUid="" 
	f  s LUid=$o(^DHCDISLU(LUid))  q:LUid=""  d
	.s msgiii=$g(^DHCDISLU(LUid))
	.q:msgiii="" 
	.s userdr=$p(msgiii,"^",2)
	.i userdr=User  d
	..s acLoc=$p(msgiii,"^",1)
	..i acLoc'="" s acceptLoc=$p(^CTLOC(acLoc),"^",1)   //取科室名称
	q acceptLoc
}

}
