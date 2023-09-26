Class web.DHCMGPersonBill Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod pay(User, edate) As %String
{
 //s a=##class(web.DHCMGPersonBill).pay(2636,"2010-04-08")
   s ret=##class(web.DHCMGPERSON).GetSortDep("TOTAL")
   s ln=$L(ret,"^")
   s edate=$ZDH(edate,3)
    for i=1:1:ln
    {
	   s itm=$P(ret,"^",i)

	   if itm="" continue
	   s dep=$P(itm,"|",1),depdes=$P(itm,"|",2)
       s stdate=..getbillstdate(dep)
       s parw=..getbillrw(dep)
       //if dep="1304" w !,dep  b
       //w !,dep
       if stdate="" continue
       if edate<stdate continue
       s parr=dep_"^"_$ZD(stdate,3)_"^"_$ZD(edate,3)_"^"_User_"^P^"_parw
        ///生成一条结算paid的，再生成一条billed的
       b ///1
       s a=..PersonBill(parr)
       s stdate1=edate+1
       s edate1=+$h
       if edate1<stdate1 continue
       s parr=dep_"^"_$ZD(stdate1,3)_"^"_$ZD(edate1,3)_"^"_User_"^B"
       b ///2
       s a=..PersonBill(parr)
       //清除
       b
       //if parw'=""  d ##class(User.DHCMGDepBill).%DeleteId(parw)
       
	}
	q 0
}

ClassMethod getbillrw(dep) As %String
{
 //s a=##class(web.DHCMGPersonBill).getbillrw(2636,"2010-04-08")
	s id=""
	s stat=""
	s date="" f  s date=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date),-1) q:(date="")!(stat="B")  d
	.s rw=""  f  s rw=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date,rw)) q:(rw="")  d
	..s br=^User.DHCMGDepBillD(rw)
	..s stat=$list(br,13)
	..i stat="B" s id=rw
	q id
}

ClassMethod billstdate(dep, user) As %String
{
  //billed ///动态计算存休s a=##class(web.DHCMGPersonbill).billstdate()
	s id=""
	s stat=""
	s stdate=""
	s date="" f  s date=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date),-1) q:(date="")!(stat="B")  d
	.s rw=""  f  s rw=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date,rw)) q:(rw="")  d
	..s br=^User.DHCMGDepBillD(rw)
	..s stat=$list(br,13)
	..s stdate=$list(br,12)
	..i stat="B" s id=rw
	if stdate=""
	{
	
	   s date="" s date=$O(^User.DHCMGPersonArrangeI("DepDate"," "_dep,date))
       if date'="" s stdate=date

	}	
    s parr=dep_"^"_$ZD(stdate,3)_"^"_$ZD(+$H,3)_"^"_user_"^B^"_id
	s a=..PersonBill(parr)
	q 0
}

ClassMethod getbillstdate(dep) As %String
{
 //获取结算的开始日期s a=##class(web.DHCMGPersonBill).getbillstdate()
	s endate="",stdate=""
	s stat="",id=""
	//s dep="" f  s dep=$O(^User.DHCMGPersonBillI("DepPerStDate",dep)) q:dep=""  d
	s date="" f  s date=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date),-1) q:(date="")!(stat="P")  d
	.s rw=""  f  s rw=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date,rw)) q:(rw="")  d
	..s br=^User.DHCMGDepBillD(rw)
	..s stat=$list(br,13)
	..i stat="B" s id=rw
	..q:stat="B"
	..s stdate=$list(br,12)
	..s endate=$list(br,4)
	if endate'="" s stdate=endate+1
	
	if stdate=""
	{
	
	   s date="" s date=$O(^User.DHCMGPersonArrangeI("DepDate"," "_dep,date))
       if date'="" s stdate=date

	}
	//w !,$ZD(stdate,3)
  q stdate
}

ClassMethod PersonBill(parr As %String) As %String
{
  //冻结班次
  //每个人 实际工作小时数 应该工作小时数 
  //总天数-节假日数-周六周日=应该工作天数
  //s a=##class(web.DHCMGPersonBill).PersonBill()
  //s parr="1304^2010-04-01^2010-04-09"
	s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s User=$P(parr,"^",4)
    s year=+stdate
    b ///09
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    s stat=$P(parr,"^",5) //P B
    s parw=$P(parr,"^",6) 
    s restday=0
    s workday=0
    ///取设置
    s setstr=##class(User.DHCMGArrSystemSet).getset()
    s suckle=$P(setstr,"^",2)
    s natural=$P(setstr,"^",3)
    s weekworkdays=$P(setstr,"^",4)
    ///
    s ret=##class(web.DHCMGPerArrange).GetDepPerson(loc)
    //没有转走的人
    s ln=$L(ret,"^")
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	}
    s ovaddhours=0
    f date=stdate:1:edate
    { //计算累计加班
     //已不用 20100407 qse
      s rw=""  f  s rw=$O(^User.DHCMGPersonOverRestI("DepDate"," "_loc,date,rw)) q:rw=""  d
      .s a=^User.DHCMGPersonOverRestD(rw)
      .s ovsttime=$List(a,14),ovetime=$List(a,13)
      .s per=$List(a,4)
      .s ovtim=((ovetime-ovsttime)/3600)
      .s OVRec(per)=$G(OVRec(per))+ovtim
      .s ovaddhours=ovaddhours+ovtim
    }
    s yeardr=##class(User.DHCMGCCode).getcodedr(year,"年度")
    s realhours=0,therohours=0,feasthours=0
    f date=stdate:1:edate
    {
	    s flag=..getrestflag(date,yeardr)
	    s feastflag=##class(User.DHCMGFeastDate).getfeastflag(date,yeardr)
	    //节日标志
	    if flag="Y" s restday=restday+1  //理论休息天数
	    if flag="N" s workday=workday+1  //理论工作天数
	    
	    b // flag
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s per=$List(arr,5)
	    .s suckleflag=##class(User.DHCMGSuckleWoman).getsuckleflag(per,date) //哺乳标志
	    .if (flag="N")&(suckleflag="true") s suckleday(per)=$G(suckleday(per))+1
	    .s post=$List(arr,6)
	    .s hour=$list(^User.DHCMGPostD(post),10)
	    .s mperworklen(per)=$G(mperworklen(per))+hour //实际工作小时数
	    .if feastflag="Y" s feasthour(per)=$G(feasthour(per))+hour //个人节日工作小时数
        .if feastflag="Y" s feasthours=$G(feasthours)+hour //总节日工作小时数
        .s realhours=realhours+hour	    
    }
    s pstr=##class(User.DHCMGAllowanceAdj).getprice(edate)
    s feastprice=$P(pstr,"^",1),feriprice=$P(pstr,"^",2)
    s parr="^"_loc_"^"_stdate_"^"_edate_"^"_0_"^"_(realhours+ovaddhours)_"^"_workday_"^"_feasthours_"^"_feastprice_"^"_feriprice_"^"_stat_"^"_User_"^"_parw
    s idstr=##class(User.DHCMGDepBill).Save(parr)
    b /// bllddf
    s parent=##class(User.DHCMGDepBill).%OpenId($P(idstr,"^",2))
    s currid=$P(idstr,"^",2)
    s prev=$P(idstr,"^",1)
    s nur=""  f  s nur=$O(MNurSort(nur)) q:nur=""  d
    .s realhours(nur)=$G(mperworklen(nur))+$G(OVRec(nur)) //实际工作小时数
    .i $D(suckleday(nur)) d  //哺乳期
    ..s theoryhours(nur)=suckleday(nur)*suckle+(workday-suckleday(nur))*natural
    .e  s theoryhours(nur)=workday*natural    //应该工作小时数
    .s feasthours(nur)=$G(feasthour(nur))   //节日工作小时数
    .s dep=loc,per=nur
    .s parr=dep_"^"_per_"^"_User_"^"_stdate_"^"_edate_"^"_realhours(nur)_"^"_theoryhours(nur)_"^"_feasthours(nur)_"^"_feastprice_"^"_feriprice_"^"_stat_"^"_prev_"^"_currid
    .b ///dd
    .s ret=##class(User.DHCMGDepBillSub).Save(parent,parr)
  q 0
}

ClassMethod getrestflag(date, yeardr) As %String
{
         
 //是否休息 
   	    s flag="N"
   	    //如果是节日 flag="Y"
   	    s flag=##class(User.DHCMGFeastDate).getfeastflag(date,yeardr)
   	    if flag="Y" q flag
   	    s week=$ZD(date,10)
   	    //是周6,日 但不是停休日 flag="Y"
   	    s rw="" s rw=$O(^User.DHCMGFeastDateI("StopDate",date,rw))
	    if ((week=0)!(week=6))&(rw="") s flag="Y" 
	    //b //getrestflag
	    
        q flag
}

ClassMethod getbfhour(per As %String, perbill As %String) As %String
{
 //取发放小时数
   s parw="",chlw=""
   s par="" f  s par=$O(^User.DHCMGRpDutySubI("perbill",per,perbill,par)) q:par=""  d
   .s sub="" f  s sub=$O(^User.DHCMGRpDutySubI("perbill",per,perbill,par,sub))  q:sub=""  d
   ..s parw=par,chlw=sub
   if parw=""  q ""
   s a=^User.DHCMGRpDutyD(parw,"ChildDHCMGRpDutySub",chlw)
   s feahour=$List(a,4)
   s ferhour=$list(a,6)
   q feahour_"^"_ferhour
}

ClassMethod GetAllowRecordExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="1082^2009-02-22"
    s par=$P(parr,"^")
 	s stat=""
 	if par="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s rw="" f  s rw=$O(^User.DHCMGDepBillSubD(par,rw)) q:(rw="")   d
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //实际工作小时数 应该工作小时数，节日工作小时数 ，差额，累计结余，节日补贴单价，平日补贴单价
 //，节日补贴发放小时数，平日补贴发放小时数

out
    s (person,realhoperson,realhours,therohours,feasthours,addhours,bfeasthours,bferihours,perbill,user)=""
    s a=^User.DHCMGDepBillSubD(par,rw)
    s user=$List(a,4)
    s addhours=$FN($List(a,2),"",1)
    s realhours=$FN($List(a,5),"",1)
    s therohours=$List(a,7)
    s feasthours=$List(a,3)
    s inival=$Listget(a,8)
    s perbill=par_"||"_rw
    
    s ret=..getbfhour(user,perbill)
    s bferihours=""
    s bfeasthours=feasthours
    if (addhours-feasthours)>0 s bferihours=addhours-feasthours
    
    if ret'=""
    {
	    s bfeasthours=$P(ret,"^",1),bferihours=$P(ret,"^",2)
	}
    //s dep=$List(a,2)
    if user'="" s parr=^User.DHCMGPersonsD(user)
    if user'="" s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(person,realhours,therohours,feasthours,addhours,bfeasthours,bferihours,perbill,user,inival)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllowRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllowRecordExecute ]
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

ClassMethod GetAllowRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllowRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAllowRecord(parr As %String) As %Query(ROWSPEC = "person,realhours,therohours,feasthours,addhours,bfeasthours,bferihours,rw,user,inival")
{
}

ClassMethod GetDepAllRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="1082^2009-02-1^2009-04-13"
 	s stdate1=$P(parr,"^",2)
  	s edate1=$P(parr,"^",3)
 	s dep=$P(parr,"^",1)
 	s stdate1=$ZDH(stdate1,3)
 	s edate1=$ZDH(edate1,3)
 	s stat=""
 	s i=""
 	for date=stdate1:1:edate1
 	{
	 	s i=0
		s rw=""  f  s rw=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date,rw)) q:(rw="")  d
	    .d out
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //实际工作小时数 应该工作小时数，节日工作小时数 ，差额，累计结余，节日补贴单价，平日补贴单价
 //，节日补贴发放小时数，平日补贴发放小时数

out
    s (depdes,stdate,edate,tworkdays,realhours,feahours,status,feaprice,feriprice,paiddate,paidtime,paiduser,dep)=""
    s a=^User.DHCMGDepBillD(rw)
  	s status=$list(a,13)
    s stdate=$List(a,12)
    s edate=$List(a,4)
    s realhours=$FN($List(a,11),"",1)
    s tworkdays=$List(a,14)
    s feahours=$List(a,5)
    s feaprice=$List(a,6)
    s feriprice=$List(a,7)
    s dep=$List(a,2)
    s paiddate=$List(a,8)
    s paidtime=$List(a,9)
    s paiduser=$List(a,10)
    if dep'="" s depdes=$P(^CTLOC(dep),"^",2)
    s edate=$ZD(edate,3)
    s stdate=$ZD(stdate,3)
    s paiddate=$ZD(paiddate,3)
    s paidtime=$Zt(paidtime,3)
    if paiduser'="" s parr=^User.DHCMGPersonsD(paiduser)
    if paiduser'="" s paiduser=$list(parr,21) 
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,stdate,edate,tworkdays,realhours,feahours,feaprice,feriprice,status,paiddate,paidtime,paiduser,dep,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDepAllRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepAllRecExecute ]
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

ClassMethod GetDepAllRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepAllRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepAllRec(parr As %String) As %Query(ROWSPEC = "depdes,stdate,edate,tworkdays,realhours,feahours,feaprice,feriprice,status,paiddate,paidtime,paiduser,dep,rw")
{
}

ClassMethod getperhlBx(per, hlcode, stdate, edate) As %String
{
 //Index DepDate On (HOLDepDr, HOLFromDate);计算补休小时数
  //##class(web.DHCMGPersonBill).getperhlBx()
  // s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
   s sumhours=0
   s setstr=##class(User.DHCMGArrSystemSet).getset()
   s suckle=$P(setstr,"^",2)
   s natural=$P(setstr,"^",3)

   for date=stdate:1:edate
   {
    .s rw=""  f  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_per,date,rw)) q:rw=""  d
    ..s perhol=^User.DHCMGPersonHolidayD(rw)
    ..s per=$List(perhol,6)
    ..s hl=$List(perhol,4)
    ..q:hl=""
    ..s a=^User.DHCMGCHolidayD(hl)
    ..s Code=$List(a,2)
    ..s Desc=$List(a,4)
    ..q:Code'=hlcode
    ..s hlstdate=$List(perhol,3),hledate=$List(perhol,2)
    ..if hlstdate'<stdate s sd=hlstdate
    ..if stdate'<hlstdate s sd=stdate
    ..if edate'>hledate s ed=edate
    ..if hledate'>edate s ed=hledate
    ..s sttime=$List(perhol,15),etime=$List(perhol,14)
    ..s suckleflag=##class(User.DHCMGSuckleWoman).getsuckleflag(per,date)
    ..if suckleflag="true" s unithours=suckle
    ..e  s unithours=natural
    ..s reshours=0
    ..if sttime'=""  s reshours=(etime-sttime)/3600
    ..e  s reshours=((hledate-hlstdate)+1)*unithours
    ..s sumhours=sumhours+reshours
    ..//w !,$zd(hlstdate,3),",",$ZD(hledate,3),",",$ZD(stdate,3),",",$ZD(edate,3)
   }
   //计算补休小时数
  q sumhours
}

}
