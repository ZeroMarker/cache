Class web.DHCThreeEr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetEROBS(adm, datestr) As %String
{
  // 生命体征数据 s a=##class(web.DHCThreeEr).GetEROBS()
 // n (adm,datestr)
 // s adm=317429  //s a=##class(web.DHCThreeNew).GetPatValue()
 // s datestr="2011-5-24 0:00:00^2011-5-24 0:00:00|"
  s l=$L(datestr,"^")
  s data=""
  
  for i=1:1:l
  {
    s itm=$P(datestr,"|",i)
    if itm="" continue
    s std=$P(itm,"^",1)
    s edt=$P(itm,"^",2)
    //w !, std,"|",edt
   // b //
    s data=data_##class(web.DHCThreeEr).GetEROBSData(adm,$P(std," "),$P(edt," "))_$C(1)
    b
  }
  q data
}

ClassMethod GetEROBSData(Adm As %String, StDate As %String, EndDate As %String) As %String
{
 //s a=##class(web.DHCThreeEr).GetOBSData()
  //	n (Adm,StDate,EndDate)
	//s Adm="45"      //高压（收缩压）和低压（舒张压），
   // s StDate="2010-12-10"
  	//s EndDate="2010-12-10"

   s DM="",DayNum=""
   s ret=""
  // b //ss
   d ##class(web.DHCThreeNew).PatLeave(Adm, StDate, EndDate,.DM,.DayNum)
   //b 
   s n=""  f  s n=$O(DM(n)) q:n=""  d
   .s st=$P(DM(n),"^",1),ed=$P(DM(n),"^",2)
   .if $ZDH(st,3)=0 b
   .//w !,st,"/",ed
   .//b //
   .s ret=ret_##class(web.DHCThreeEr).GetERPatValue(Adm,st,ed,.DayNum)_"!"
   q ret
}

ClassMethod GetERPatValue(Adm As %String, StDate As %String, EndDate As %String, DayNum) As %String
{
   //生命体征数据查询
   ////s a=##class(web.DHCThreeEr).GetPatValue()
 //	n (Adm,StDate,EndDate,DayNum)
	//s Adm="7619430"      //高压（收缩压）和低压（舒张压），
   // s StDate="2011-04-24"
	//s EndDate="2011-04-24"
	;b ///Enddate
	
	s StDate=$ZDH(StDate,3)
	s EndDate=$ZDH(EndDate,3)
	
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s num=0
	//s nuitGridTim=86400/6
	//s gridw=UnitW/240  //(4小时)
	//s gridh=UnitH  //(每小格0.2度，4次)
    //s Pulses="",Tw="",Breath=""
    //取设置
      s a=##class(Nur.DHCNurTempSet).GetSetID("TempERChart")
      s tmp=""
      s ret=##class(Nur.DHCNurTempSet).getVal(a)
      s aa=##class(web.DHCMGNurComm).settmp(ret,.tmp)

    ;s YW=tmp("YTemp") ,WR=tmp("UnTestReason") //口温。肛温 .腋温,未测原因
    ;s WlTemp=tmp("WlTemp")
    ;s Weight=tmp("Weight")
    ;s items=$TR(tmp("InOutCode"),",","^")  //值 
    ;s itemTime=$ZTH(tmp("InOutTime"))
    s GMSTR=""  //过敏数据
    s tmp("mru")="Item10" ,tmp("nru")="Item12"
   // k ^TMP("milk1")
	f Date=StDate:1:EndDate
	{
		s num=DayNum(Date)
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.q:'$D(^MRC("OBITM",ItmDr))
		.s code=$P(^MRC("OBITM",ItmDr),"^",1)
		.s codeitm="^"_code_"^"
		.;q:code=WlTemp
		.s flag=""
		.;if code=YW  s flag="Y"
		.//w !,code
		.//if (code=KW)!(code=GW) s code=YW   //!(code=WR)
	    .s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..s TimPos=(OBST/14400)
		..//b  //dd
		..i (Value'="")  d
		...  //时间方向位置 
		...if (code=tmp("mru"))!(code=tmp("nru")) d
		....s tmpm("milk",num)=$G(tmpm("milk",num))+Value
		....s ^TMP("milk1",num, code)=tmpm("milk",num)
    	...s p=num //s Value=$FN(((Value)),"",2)
		...;if items[codeitm s p=num-1
		...;if (items[codeitm )&(OBST'=itemTime) q  //出入量取7点的数据
		...//青医附院 卡介苗接种日期Item21/批号Item15/乙肝疫苗接种日期Item16/批号Item18
		...i "^Item21^Item15^Item16^Item18^"[("^"_code_"^") d
		....i code="Item21" s p=1
		....i code="Item15" s p=3
		....i code="Item16" s p=5
		....i code="Item18" s p=7
		...i Desc'="" s TM(code,p,OBST)=p_"^"_Value_$C(3)_flag_"^"_TimPos_"^"_Desc_"#"    ;不是物理降温
		...e  s TM(code,p,OBST)=p_"^"_Value_$C(3)_flag_"^"_TimPos_"^"_"#"
	}
	 s Data=""
	 s milk=""
	// k ^TMP("milk")
	// m ^TMP("milk")=tmpm("milk")
	 s n=""  f  s n=$O(tmpm("milk",n)) q:n=""  d
	 .s tmpm("milk",n)=n_"^"_tmpm("milk",n)_"^"_..getheight(tmpm("milk",n))
	 .s milk=milk_tmpm("milk",n)_"#"
	 s code="" f  s code=$O(TM(code)) q:code=""  d
	 .s ret=""
	 .s d=""  f  s d=$O(TM(code,d)) q:d=""  d
	 ..s t=""  f  s t=$O(TM(code,d,t)) q:t=""  d
	 ...s ret=ret_TM(code,d,t)
	 .s Data=Data_code_"|"_ret_"&"
	// s Data=HPItm_"|"_hp_"&"_Data
	// b
	q "milk|"_milk_"&"_Data
}

ClassMethod GetERPatValue1(Adm As %String, StDate As %String, EndDate As %String, DayNum) As %String
{
   //生命体征数据查询
   ////s a=##class(web.DHCThreeEr).GetPatValue()
 //	n (Adm,StDate,EndDate,DayNum)
	//s Adm="7619430"      //高压（收缩压）和低压（舒张压），
   // s StDate="2011-04-24"
	//s EndDate="2011-04-24"
	;b ///Enddate
	
	s StDate=$ZDH(StDate,3)
	s EndDate=$ZDH(EndDate,3)
	
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s num=0
	//s nuitGridTim=86400/6
	//s gridw=UnitW/240  //(4小时)
	//s gridh=UnitH  //(每小格0.2度，4次)
    //s Pulses="",Tw="",Breath=""
    //取设置
      s a=##class(Nur.DHCNurTempSet).GetSetID("TempERChart")
      s tmp=""
      s ret=##class(Nur.DHCNurTempSet).getVal(a)
      s aa=##class(web.DHCMGNurComm).settmp(ret,.tmp)

    ;s YW=tmp("YTemp") ,WR=tmp("UnTestReason") //口温。肛温 .腋温,未测原因
    s WlTemp=tmp("WlTemp")
    s Weight=tmp("Weight")
    s items=$TR(tmp("InOutCode"),",","^")  //值 
    s itemTime=$ZTH(tmp("InOutTime"))
    s GMSTR=""  //过敏数据
    s tmp("mru")="Item10" ,tmp("nru")="Item12"
   // k ^TMP("milk1")
	f Date=StDate:1:EndDate
	{
		;s num=DayNum(Date)
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.q:'$D(^MRC("OBITM",ItmDr))
		.s code=$P(^MRC("OBITM",ItmDr),"^",1)
		.s codeitm="^"_code_"^"
		.q:code=WlTemp
		.s flag=""
		.if code=YW  s flag="Y"
		.//w !,code
		.//if (code=KW)!(code=GW) s code=YW   //!(code=WR)
	    .s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..s TimPos=(OBST/14400)
		..//b  //dd
		..i (Value'="")  d
		...  //时间方向位置 
		...if (code=tmp("mru"))!(code=tmp("nru")) d
		....s tmpm("milk",num)=$G(tmpm("milk",num))+Value
		....s ^TMP("milk1",num, code)=tmpm("milk",num)
    	...s p=num //s Value=$FN(((Value)),"",2)
		...if items[codeitm s p=num-1
		...if (items[codeitm )&(OBST'=itemTime) q  //出入量取7点的数据
		...//青医附院 卡介苗接种日期Item21/批号Item15/乙肝疫苗接种日期Item16/批号Item18
		...i "^Item21^Item15^Item16^Item18^"[("^"_code_"^") d
		....i code="Item21" s p=1
		....i code="Item15" s p=3
		....i code="Item16" s p=5
		....i code="Item18" s p=7
		...i Desc'="" s TM(code,p,OBST)=p_"^"_Value_$C(3)_flag_"^"_TimPos_"^"_Desc_"#"    ;不是物理降温
		...e  s TM(code,p,OBST)=p_"^"_Value_$C(3)_flag_"^"_TimPos_"^"_"#"
	}
	 s Data=""
	 s milk=""
	// k ^TMP("milk")
	// m ^TMP("milk")=tmpm("milk")
	 s n=""  f  s n=$O(tmpm("milk",n)) q:n=""  d
	 .s tmpm("milk",n)=n_"^"_tmpm("milk",n)_"^"_..getheight(tmpm("milk",n))
	 .s milk=milk_tmpm("milk",n)_"#"
	 s code="" f  s code=$O(TM(code)) q:code=""  d
	 .s ret=""
	 .s d=""  f  s d=$O(TM(code,d)) q:d=""  d
	 ..s t=""  f  s t=$O(TM(code,d,t)) q:t=""  d
	 ...s ret=ret_TM(code,d,t)
	 .s Data=Data_code_"|"_ret_"&"
	// s Data=HPItm_"|"_hp_"&"_Data
	// b
	q "milk|"_milk_"&"_Data
}

ClassMethod GetTimePointExecute(ByRef qHandle As %Binary) As %Status
{
   //web.DHCTHREEEX.GetTimePoint
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=1,des="02:00:00"
	d out1
 	s id=2,des="06:00:00"
	d out1
 	s id=3,des="10:00:00"
	d out1
 	s id=4,des="14:00:00"
	d out1
	s id=5,des="18:00:00"
	d out1
	s id=6,des="22:00:00"
	d out1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out1
	set Data=$lb(id,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTimePointFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimePointExecute ]
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

ClassMethod GetTimePointClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimePointExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTimePoint() As %Query(ROWSPEC = "idv,des")
{
}

ClassMethod getTime() As %String
{
 //w ##class(web.DHCThreeEr).getTime() //24/6
    //s ^TMP("gg")=a
    //s tim(1)="0-6"
    //s tim(2)="6-12"
    //s tim(3)="12-18"
    //s tim(4)="18-24"
    
    s tim(1)="1-5"
    s tim(2)="5-9"
    s tim(3)="9-13"
    s tim(4)="13-17"
    s tim(5)="17-21"
    s tim(6)="21-25"

    
	s intim=$ZT($P($H,",",2),2)
	s h=$P(intim,":")
	s minute=$P(intim,":",2)
	s intim=h+(minute/60)
	//s intim=16.99
	s p=1
	s n="" f  s n=$O(tim(n)) q:n=""  d
	.s st=$P(tim(n),"-",1)
	.s et=$P(tim(n),"-",2)
	.i (intim'<st)&(intim<et) s p=n
	.b
	//s nn=1
	//s num=$FN(intim*6/86400,"",1)
	//s num1=$FN(intim*6/86400,"",0)
	//if num1>num s nn=num1
	//e  s nn=num1
	//i nn'<6 s nn=1
	
	q p
}

ClassMethod getPos(tim) As %String
{
 //w ##class(web.DHCThreeEr).getPos() //24/6
    //s ^TMP("gg")=a
    //s tim(1)="0-6"
    //s tim(2)="6-12"
    //s tim(3)="12-18"
    //s tim(4)="18-24"
    
	s tim(1)="1-5"
	s tim(2)="5-9"
	s tim(3)="9-13"
	s tim(4)="13-17"
	s tim(5)="17-21"
	s tim(6)="21-25"
    
	s intim=tim  //$ZT($P($H,",",2),2)
	s h=$P(intim,":")
	s minute=$P(intim,":",2)
	s intim=h+(minute/60)
	s p=1
	s n="" f  s n=$O(tim(n)) q:n=""  d
	.s st=$P(tim(n),"-",1)
	.s et=$P(tim(n),"-",2)
	.i (intim'<st)&(intim<et) s p=n
	//s nn=1
	//s num=$FN(intim*6/86400,"",1)
	//s num1=$FN(intim*6/86400,"",0)
	//if num1>num s nn=num1
	//e  s nn=num1
	//i nn'<6 s nn=1
	//s p=p+0.6	//20110524入院等事件使用显示在格子正中间
	q p-1
}

ClassMethod GetEvents(Adm) As %String
{
	//s a=##class(web.DHCThreeEr).GetEvents()
	s data=""
	s num=1
	s ret=##class(web.DHCADMQTREC).QtPatAdmDate(Adm)
	k TMP
	s rw=0 f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if ADate'="" s Date=$ZD(ADate,3)
	.if ATime'="" s Time=$ZT(ATime,2)
	.s timpos=ATime/21600
	.s pos=..getPos(Time)  //\14400
	.s timpos=$FN(timpos,"",1)
	.if TypDr'="" s TypCode=$P(^DHCQTRECTYP("typ",TypDr),"^",1)
	.if TypDr'="" s TypDes=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.s TMP(ADate,ATime,num)=pos_"^"_timpos_"^"_Date_"^"_Time_"^"_TypCode_"^"_TypDes
	.s num=num+1
    s date=""  f  s date=$O(TMP(date)) q:date=""  d
    .s tm=""  f  s tm=$O(TMP(date,tm)) q:tm=""  d
    ..s n=""  f  s n=$O(TMP(date,tm,n)) q:n=""  d
    ...s data=data_TMP(date,tm,n)_"|"
   q data
}

ClassMethod getheight(vl) As %String
{

	 s m(14)="0-100"
	 s m(13)="100-200"
	 s m(12)="200-300"
	 s m(11)="300-400"
	 s m(10)="400-500"
	 s m(9)="500-600"
	 s m(8)="600-700"
	 s m(7)="700-800"
	 s m(6)="800-900"
	 s m(5)="900-1000"
	 s m(4)="1000-1100"
	 s m(3)="1100-1200"
	 s m(2)="1200-1300"
	 s pos=""
	 s r="" f  s r=$O(m(r)) q:r=""  d
	 .s itm=m(r)
	 .s st=$P(itm,"-"),et=$P(itm,"-",2)
	 .if (vl>st)&(vl'>et) s pos=r
    q pos
}

}
