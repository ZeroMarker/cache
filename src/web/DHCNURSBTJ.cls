Class web.DHCNURSBTJ Extends %RegisteredObject [ ProcedureBlock ]
{

//判断报表

//d ##class(web.DHCNURSBTJ).JudgeReport("2013-01-01^2013-01-31^M")

ClassMethod JudgeReport(parr) As %String
{
    s ret="" 
 	s StDate=$p(parr,"^",1)
	s StDate=$zdh(StDate,3)
	s EnDate=$p(parr,"^",2)
	s EnDate=$zdh(EnDate,3)
	s RelReport=$p(parr,"^",3)
	&sql(DECLARE JudgeCursor CURSOR FOR
	Select ID into:ID from Nur.DHCNurSBReport where StDate=:StDate and EnDate=:EnDate and StatTyp=:RelReport)
	&sql(OPEN JudgeCursor)

	for  &SQL(FETCH JudgeCursor) QUIT:SQLCODE  do
	.s ID=$tr(ID,"||","_")
	.s ret=ID
	//b 
	q ret
}

//d ##class(web.DHCNURSBTJ).SaveReport("2013-01-01^2013-01-31^M")

ClassMethod SaveReport(parr) As %String
{
	s ^fishbig=parr
	//s parr="2012-06-03^2012-06-04^5^D"
	//w ##class(web.DHCNSTFun).SaveReport()
	s StartDate=$p(parr,"^",1)
	s EndDate=$p(parr,"^",2)
	s ReportType=$p(parr,"^",3)
	s DenominatorDesc=""
	s RecUser=69
	s RepLoc=118
	//s RecUser=%session.Get("LOGON.USERID") //从后台取登陆用户
	//s RepLoc=%session.Get("LOGON.CTLOCID")  //从后台取登陆科室

	//s ReportType="D"
	s a=##class(Nur.DHCNurSBReport).%New()
	//b ;
	s a.StDate=$ZDH(StartDate,3)
	s a.EnDate=$ZDH(EndDate,3)
	s a.StatTyp=ReportType
	s a.RecDate=+$h
	s a.RecTime=$p($h,",",2)
	s a.RecUser=RecUser
	s a.RepLoc=RepLoc
	d a.%Save()
	i a.%Id()="" q "eorr"
	s mid=a.%Id()
    s retval=..GetTJDatewardid($ZDH(StartDate,3),$ZDH(EndDate,3),mid)
    q retval
}

//d ##class(web.DHCNURSBTJ).deletereport("3")

ClassMethod deletereport(typid) As %String
{
    &sql(delete from Nur.DHCNurSBReport where ID=:typid)
	 //&sql(delete from Nur.DHCNurSBReportSub where RecParref=:typid)
	 q SQLCODE
}

//d ##class(web.DHCNURSBTJ).GetTJDatewardid("62823","62853","3")

ClassMethod GetTJDatewardid(StDate, EnDate, typid) As %String
{
    
    
    for DayDate=StDate:1:EnDate
	{  
	    
		s EmrCode="" f  s EmrCode=$O(^Nur.DHCNurSBDataI("emdate",DayDate,EmrCode)) q:EmrCode=""  d
		.s par="" f  s par=$O(^Nur.DHCNurSBDataI("emdate",DayDate,EmrCode,par)) q:par=""  d
		..s b=##class(Nur.DHCNurSBData).%OpenId(par)
		..s EmrLoc=b.EmrLoc
		..s Status=b.Status
		..q:Status="V"
		..q:Status="C"
		..q:Status=""
		..q:EmrLoc=""
		..s EmrCode2=$tr(EmrCode," ","")
		..i EmrCode2="DHCNURBJSB_PF" s EmrCode2="DHCNURXHSB_PF"
		..i EmrCode2="DHCNURBJSB_YW" s EmrCode2="DHCNURXHSB_YIWSH"
		..i EmrCode2="DHCNURBJSB_YYCW" s EmrCode2="DHCNURXHSB_GEIYAO"
		..i EmrCode2="DHCNURBJSB_GLHT" s EmrCode2="DHCNURXHSB_GLHUATUO"
		..i $g(^TEMP("GetTJlocCode",$j,EmrLoc,EmrCode2))="" d
		...s ^TEMP("GetTJlocCode",$j,EmrLoc,EmrCode2)=1
		..e  d
		...s ^TEMP("GetTJlocCode",$j,EmrLoc,EmrCode2)=^TEMP("GetTJlocCode",$j,EmrLoc,EmrCode2)+1
		..s ^TEMP("GetTJDatewardid",$j,EmrLoc,EmrCode2,DayDate,par)=""
	}
	//b ;
	s retvalue=0
	s loc="" f  s loc=$o(^TEMP("GetTJlocCode",$j,loc))  q:loc=""  d
	.s totlepf="",totleSSFY="",totleYIWSH="",totleGLHUATUO="",totleGEIYAO="",totleDULOU=""
	.s code="" f  s code=$o(^TEMP("GetTJlocCode",$j,loc,code)) q:code=""  d
	..i code="DHCNURXHSB_PF"  s totlepf=^TEMP("GetTJlocCode",$j,loc,code)
	..i code="DHCNURXHSB_SSFY"  s totleSSFY=^TEMP("GetTJlocCode",$j,loc,code)
	..i code="DHCNURXHSB_YIWSH"  s totleYIWSH=^TEMP("GetTJlocCode",$j,loc,code)
	..i code="DHCNURXHSB_GLHUATUO"  s totleGLHUATUO=^TEMP("GetTJlocCode",$j,loc,code)
	..i code="DHCNURXHSB_GEIYAO"  s totleGEIYAO=^TEMP("GetTJlocCode",$j,loc,code)
	..i code="DHCNURXHSB_DULOU"  s totleDULOU=^TEMP("GetTJlocCode",$j,loc,code)
	..i code="DHCNURBJSB_DD"  s totleDD=^TEMP("GetTJlocCode",$j,loc,code) //跌倒
	.s a=##class(Nur.DHCNurSBReportSub).%New() 
	.if $D(totlepf) s a.Item1=totlepf        // 压疮
	.if $D(totleSSFY) s a.Item2=totleSSFY  // 输液血反应
	.if $D(totleYIWSH) s a.Item3=totleYIWSH  //意外伤害
	.if $D(totleGLHUATUO) s a.Item4=totleGLHUATUO //管路滑脱
	.if $D(totleGEIYAO) s a.Item5=totleGEIYAO //给药
	.if $D(totleDULOU) s a.Item6=totleDULOU   //堵漏
	.if $D(totleDD) s a.Item7=totleDD   //跌倒
	.if $D(loc) s a.RepLoc=loc
    .if $D(typid) s a.RecParref=##class(Nur.DHCNurSBReport).%OpenId(typid)
	.d a.%Save()
	.s subid=a.%Id()
	
	.i a.%Id()="" d
	..s retvalue=1
	..k ^TEMP("GetTJlocCode",$j)
	..k ^TEMP("GetTJDatewardid",$j)
	
	.e  d
	..//b ;003
	..s code2="" f  s code2=$o(^TEMP("GetTJDatewardid",$j,loc,code2)) q:code2=""  d
	...s dd="" f  s dd=$o(^TEMP("GetTJDatewardid",$j,loc,code2,dd)) q:dd=""  d
	....s id="" f  s id=$o(^TEMP("GetTJDatewardid",$j,loc,code2,dd,id)) q:id=""  d
	.....s b=##class(Nur.DHCNurSBReportSubDetail).%New() 
	.....if $D(loc) s b.loc=loc
	.....if $D(code2) b b.typsj=code2
	.....if $D(dd) s b.UpsjDate=dd
	.....if $D(id) s b.NurseId=id
	.....if $D(subid) s b.RecParref=##class(Nur.DHCNurSBReportSub).%OpenId(subid)
	.....d b.%Save()
	.....//w !,subid, "^" ,id
	.....s subdetailid=b.%Id()
	.....//w !,subdetailid
	k ^TEMP("GetTJlocCode",$j)
	k ^TEMP("GetTJDatewardid",$j)
	q retvalue
}

//d ##class(web.DHCNURSBTJ).GetTJDatewardid("62823","62853","3")

//d ##class(%ResultSet).RunQuery("web.DHCNURSBTJ","DHCNurDHCNURQuery",^objcyf999g)

Query DHCNurDHCNURQuery(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurDHCNURQueryExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
   Set repid=$I(^CacheTemp)
	s ind=1
	s aa=""
	 s ret="" 
	s ^objcyf999g=Parr
 	s StDate=$p(Parr,"^",1)
	s StDate=$zdh(StDate,3)
	s EnDate=$p(Parr,"^",2)
	s EnDate=$zdh(EnDate,3)
	s RelReport=$p(Parr,"^",3)
    s ret=..JudgeReport(Parr)
    b ;00
    i ret="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s flag1=""
    s userid="" f  s userid=$o(^Nur.DHCNURLocDataSubI("NurseNoLoc",userid)) q:userid=""  d 
    .s idd=""
    .s locrw="" f  s locrw=$o(^Nur.DHCNURLocDataSubI("NurseNoLoc",userid,locrw)) q:locrw=""  d 
    ..s locrw2=$tr(locrw," ","")
    ..s userid2=$tr(userid," ","")
    ..//w !,locrw
    ..q:userid=" 02314"
    ..s locdesc=$p($p(^CTLOC(locrw2),"^",2),"-",2)
    ..i idd="" d 
    ...s bignurseareaid=$o(^Nur.DHCNURLocDataI("UserId",userid,""))
    ...b ;333
    ...i bignurseareaid'="" d
    ....s c=##class(Nur.DHCNURLocData).%OpenId(bignurseareaid)
    ....s bignursearea=c.Location
    ....b ;33
    ....s aa="loc"_"|"_bignursearea_"^"_"yc"_"|"_"^DD|^"_"tg"_"|"_"^"_"dd"_"|"_"^"_"cc"_"|"_"^"_"sy"_"|"_"^"_"dl"_"|"_"^"_"rw"_"|"_"^"_"par"_"|"_"^"_"locid"_"|"_"^"
	....do OutPatDetail1	
    ..s idd=idd+1
    ..s cvv=$d(^Nur.DHCNurSBReportSubI("RepLoc",locrw,ret))
    ..b ;09
    ..i $d(^Nur.DHCNurSBReportSubI("RepLoc",locrw,ret)) d 
    ...b ;44
   
	...s rw="" f  s rw=$o(^Nur.DHCNurSBReportSubI("RepLoc",locrw,ret,rw)) q:rw=""  d 
	....s a=##class(Nur.DHCNurSBReportSub).%OpenId(ret_"||"_rw)
	....s loc=a.RepLoc
	....s yc=a.Item1  //压疮
	....s tg=a.Item4 //管路滑脱
	....s dd=a.Item3  //意外伤害
	....s cc=a.Item5 //给药
	....s sy=a.Item2 //输液血反应
	....s dl=a.Item6 //堵漏
	....s diedao=a.Item7 //跌倒
	....s aa="loc"_"|"_locdesc_"^"_"yc"_"|"_yc_"^DD"_"|"_diedao_"^"_"tg"_"|"_tg_"^"_"dd"_"|"_dd_"^"_"cc"_"|"_cc_"^"_"sy"_"|"_sy_"^"_"dl"_"|"_dl_"^"_"rw"_"|"_ret_"^"_"par"_"|"_rw_"^"_"locid"_"|"_locrw_"^"
	....do OutPatDetail1	
	..e  d
	...s aa="loc"_"|"_locdesc_"^"_"yc"_"|"_"^"_"DD"_"|"_"^tg"_"|"_"^"_"dd"_"|"_"^"_"cc"_"|"_"^"_"sy"_"|"_"^"_"dl"_"|"_"^"_"rw"_"|"_"^"_"par"_"|"_"^"_"locid"_"|"_locrw_"^"
	...do OutPatDetail1	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail1
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurDHCNURQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurDHCNURQueryExecute ]
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
}

ClassMethod DHCNurDHCNURQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurDHCNURQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
