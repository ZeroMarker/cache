Import SQLUser

/// 肿瘤医院收费员现金交款日报表
Class web.UDHCJFOP9CashDaily Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 306;

ClassMethod GetCashDaily(UserRowId, StDate, EndDate, StartTime, EndTime)
{
	n (UserRowId, pdate, StDate, EndDate, StartTime, EndTime)
	s (PrtId,PrtOperRowId,PMCode,Amount,PrtFlag,PrtDate,PrtTime)=""
	f pdate=StDate:1:EndDate d
	.f  s PrtId=$o(^DHCINVPRT(0,"Date",pdate,PrtId)) q:PrtId=""  d
	..q:$d(^DHCINVPRT(PrtId))=10
	..s PrtOperRowId=$p($g(^DHCINVPRT(PrtId)),"^",21)	;PRT_Usr
	..q:(UserRowId'=PrtOperRowId)&(UserRowId'="")	;操作员
	..s PrtFairType=$p($g(^DHCINVPRT(PrtId)),"^",34)	;PRT_FairType
	..q:PrtFairType'="F"	;只统计收费
	..s PrtDate=$p($g(^DHCINVPRT(PrtId)),"^",5)	;PRT_Date
	..s PrtTime=$p($g(^DHCINVPRT(PrtId)),"^",20)	;PRT_Time
	..q:(PrtDate=StDate)&(PrtTime<StartTime)&(StartTime'="")
	..q:(PrtDate=EndDate)&(PrtTime>EndTime)&(EndTime'="")
	..s PrtFlag=$p($g(^DHCINVPRT(PrtId)),"^",8)	;PRT_Flag
	..s Amount=$p($g(^DHCINVPRT(PrtId)),"^",1)	;PRT_Acount
	..q:(PrtFlag'="N")&(Amount>0)	;对退费发票 进行处理
	..s myPaySub="0"
	..f  s myPaySub=$o(^DHCINVPRT(PRTrowid,"P",myPaySub)) q:(myPaySub="")  d
	...s myPMDR=$p(^DHCINVPRT(PRTrowid,"P",myPaySub),"^",1)
	...s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
    ...i myPMCode="CASH" d
	....;s ^TMP("MZJF",$j,"User",PrtOperRowId,pdate)=PrtOperRowId
	....s ^TMP("MZJF",$j,"CashSum",PrtOperRowId,pdate)=+$g(^TMPWorkStat("MZJF",$j,"CashSum",PrtOperRowId,pdate))+1
	;传出每个收费员的每天交款的信息
	s User=""
	f  s User=$o(^TMPWorkStat("MZJF",$j,"CashSum",User)) q:User=""  d
	.s TUserCode=$p($g(^SSU("SSUSR",PrtOperRowId)),"^",1)	;SSUSR_Name
	.s TUserName=$p($g(^SSU("SSUSR",PrtOperRowId)),"^",2)	;SSUSR_Name
	.s jkdate=""
    .f  s jkdate=$o(^TMPWorkStat("MZJF",$j,"CashSum",User,jkdate)) q:jkdate=""  d
    ..s Tjkdate=jkdate
    ..s Tjkdate=$zd(Tjkdate,3)
    ..s ret=..GetCashToBank(User,jkdate)
    ..s ycamt1=$p(ret,"^",1),ycamt2=$p(ret,"^",2),lastremain=$p(ret,"^",3),ybdzsum=$p(ret,"^",4)
    ..s cashsum=^TMP("MZJF",$j,"CashSum",PrtOperRowId,pdate)
    ..s curremain=cashsum+lastremain-ycamt1-ycamt2-ybdzsum
	Quit 0
}

ClassMethod QueryCashDailyExecute(ByRef qHandle As %Binary, UserRowId, StDate, EndDate, StartTime, EndTime) As %Status
{
   //门诊收费员现金交款日报表
   //显示信息：工号，姓名，交款日期，上日帐余额，当日预存现金1，2
   //医保特殊病垫支借款，当日报表总额，当日报表余额
   //dhc_invprt,dhc_invpaymode
	s ind=1
	Set repid=$I(^CacheTemp)
	s PrtId=""
	s job=$j
	f pdate=StDate:1:EndDate d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",pdate,myHisRowID)) q:(myHisRowID="")  d
	..s PrtId=0,aa=0
	..f  s PrtId=$o(^DHCINVPRT(0,"Report",myHisRowID, PrtId)) q:(PrtId="")  d
	...q:$d(^DHCINVPRT(PrtId))=10
	...s PrtOperRowId=$p($g(^DHCINVPRT(PrtId)),"^",21)	;PRT_Usr
	...q:(UserRowId'=PrtOperRowId)&(UserRowId'="")	;操作员
	...s PrtFairType=$p($g(^DHCINVPRT(PrtId)),"^",34)	;PRT_FairType
	...q:PrtFairType'="F"	;只统计收费
	...s PrtDate=$p($g(^DHCINVPRT(PrtId)),"^",5)	;PRT_Date
	...s PrtTime=$p($g(^DHCINVPRT(PrtId)),"^",20)	;PRT_Time
	...q:(PrtDate=StDate)&(PrtTime<StartTime)&(StartTime'="")
	...q:(PrtDate=EndDate)&(PrtTime>EndTime)&(EndTime'="")
	...s PrtFlag=$p($g(^DHCINVPRT(PrtId)),"^",8)	;PRT_Flag
	...q:PrtFlag="A"
	...s handin=$p($g(^DHCINVPRT(PrtId)),"^",10)	;PRT_handin
	...s Amount=$p($g(^DHCINVPRT(PrtId)),"^",1)	;PRT_Acount
	...s myPaySub="0"
	...f  s myPaySub=$o(^DHCINVPRT(PrtId,"P",myPaySub)) q:(myPaySub="")  d
	....s myPMDR=$p(^DHCINVPRT(PrtId,"P",myPaySub),"^",1)
	....s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	....s cashamt=$p(^DHCINVPRT(PrtId,"P",myPaySub),"^",3)
    ....i myPMCode="CASH" d
	.....s ^TMP("MZJF",$j,"CashSum",PrtOperRowId,pdate)=+$g(^TMPWorkStat("MZJF",$j,"CashSum",PrtOperRowId,pdate))+cashamt
	;传出每个收费员的每天交款的信息
	s (TUserCode,TUserName,Tjkdate,Tlastremain,Tycamt1,Tycamt2,Tcashsum,Tcurremain,Tybdzsum)=""
	s (cashsum,remsum,ycsum1,ycsum2,lstremsum,ybdzsum)=0
	s User=""
	f  s User=$o(^TMP("MZJF",$j,"CashSum",User)) q:User=""  d
	.s TUserCode=$p($g(^SSU("SSUSR",User)),"^",1)	;SSUSR_Name
	.s TUserName=$p($g(^SSU("SSUSR",User)),"^",2)	;SSUSR_Name
	.s jkdate=""
    .f  s jkdate=$o(^TMP("MZJF",$j,"CashSum",User,jkdate)) q:jkdate=""  d
    ..s Tjkdate=jkdate
    ..s Tjkdate=$zd(Tjkdate,3)
    ..s ret=..GetCashToBank(User,jkdate)  ;返回收费员的预存现金金额，上日账余额
    ..s Tycamt1=$p(ret,"^",1),Tycamt2=$p(ret,"^",2),Tlastremain=$p(ret,"^",3),Tybdzsum=$p(ret,"^",4)
    ..s Tcashsum=+$g(^TMP("MZJF",$j,"CashSum",User,jkdate))
    ..s Tcurremain=Tcashsum+ybdzsum-Tycamt1-Tycamt2
    ..s cashsum=cashsum+(+$g(^TMP("MZJF",$j,"CashSum",User,jkdate)))
    ..s remsum=remsum+Tcurremain
    ..s ycsum1=ycsum1+Tycamt1
    ..s ycsum2=ycsum2+Tycamt2
    ..s ybdzsum=ybdzsum+Tybdzsum
    ..s lstremsum=lstremsum+Tlastremain
    ..Do OutputRow 
   
    s TUserCode="" 
    s TUserName="总计"
    s Tlastremain=lstremsum
    s Tycamt1=ycsum1
    s Tycamt2=ycsum2
    s Tcashsum=cashsum
    s Tcurremain=remsum
    s Tybdzsum=ybdzsum
    Do OutputRow 
    s ^TMP("zlprt",$j,"CashAll")=ind-1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	set Data=$lb(TUserCode,TUserName,Tjkdate,Tlastremain,Tycamt1,Tycamt2,Tybdzsum,Tcashsum,Tcurremain,"",job)
 	s ^TMP("zlprt",$j,"CashAll",ind)=TUserCode_"^"_TUserName_"^"_Tjkdate_"^"_Tlastremain_"^"_Tycamt1_"^"_Tycamt2_"^"_ybdzsum_"^"_Tcashsum_"^"_Tcurremain
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryCashDailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCashDailyExecute ]
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

ClassMethod QueryCashDailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCashDailyExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryCashDaily(UserRowId, StDate, EndDate, StartTime, EndTime) As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,Tjkdate:%String,Tlastremain:%String,Tycamt1:%String,Tycamt2:%String,TAmtYBDZ:%String,Tcashsum:%String,Tcurremain:%String,Tcomment:%String,Tjob:%String")
{
}

ClassMethod GetCashToBank(user, jkdate)
{
    ;取预存金额,及上日结帐余额
	s RowId="",num=0,ycsum=0,Amt1=0,Amt2=0,ybdzsum=0
	f  s RowId=$o(^DHCJFOPCASHTOBANK(0,"Date",jkdate,"User",user,RowId)) q:RowId=""  d
	.s num=num+1
	.i num=1 s Amt1=$p(^DHCJFOPCASHTOBANK(RowId),"^",3)
	.i num=2 s Amt2=$p(^DHCJFOPCASHTOBANK(RowId),"^",3)
	.s ybdzsum=+$p(^DHCJFOPCASHTOBANK(RowId),"^",5)+ybdzsum
	.s ycsum=ycsum+$p(^DHCJFOPCASHTOBANK(RowId),"^",3)
	;取上日账余款,从结帐表取余额
	s LastRemain=0
	q Amt1_"^"_Amt2_"^"_LastRemain_"^"_ybdzsum
}

ClassMethod SaveCashToBank(User, amt, AmtYBDZ)
{
	s opdate=+$h,optime=$p($h,",",2),AmtYBDZ=+$g(AmtYBDZ)
	&sql(insert into dhc_jfopcashtobank(op_date,op_time,op_amt,op_user,OP_AmtYBDZ) values(:opdate,:optime,:amt,:User,:AmtYBDZ))
	q SQLCODE
}

ClassMethod QueryCashUserExecute(ByRef qHandle As %Binary, UserRowId, QueryDate) As %Status
{
   //取收费员预存现金，在积水潭数据库的zydj001用户下
	s ind=1
	Set repid=$I(^CacheTemp)
    if QueryDate="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    if UserRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s rowid=""
    f  s rowid=$o(^DHCJFOPCASHTOBANK(0,"Date",QueryDate,"User",UserRowId,rowid)) q:rowid=""  d
    .s ycdate=$p(^DHCJFOPCASHTOBANK(rowid),"^",1),ycdate=$zd(ycdate,3)
    .s yctime=$p(^DHCJFOPCASHTOBANK(rowid),"^",2),yctime=$zt(yctime,1)
    .s ycamt=$p(^DHCJFOPCASHTOBANK(rowid),"^",3)
    .s amtybdz=+$p(^DHCJFOPCASHTOBANK(rowid),"^",5)
    .i UserRowId'="" s user=$p(^SSU("SSUSR",UserRowId),"^",2)
    .Do OutputRowCash    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCash
	set Data=$lb(ycdate,yctime,ycamt,$g(user),amtybdz)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryCashUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCashUserExecute ]
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

ClassMethod QueryCashUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCashUserExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryCashUser(UserRowId, QueryDate) As %Query(ROWSPEC = "Tdate:%String,Ttime:%String,Tcash:%String,Tuser:%String,TAmtYBDZ:%String")
{
}

ClassMethod GetUserCount(QueryDate, UserRowId)
{
	s QueryDate=$zdh(QueryDate,4)
    s rowid="",num=0
    f  s rowid=$o(^DHCJFOPCASHTOBANK(0,"Date",QueryDate,"User",UserRowId,rowid)) q:rowid=""  d
    .s num=num+1
    q num
}

//按就诊科室统计门诊大类的金额，与收费员日报相对应，只统计收费员结算过的

ClassMethod QueryLocFeeExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", UserRowId As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s index=1	
	i (StDate="")!(EndDate=""){
	Quit $$$OK
	}
	k ^TMP("MZJF",$j,"Loc")
	;k ^TMP("MZJF",$j,"User")
	k ^TMP("MZJF",$j,"LocFeePrt")
	s allsum=0,allnum=0,locnum=0
	s myrtn=..GetLocCateFee(StDate,EndDate,UserRowId)
	i $g(catedesc)="" Quit $$$OK
	s ^TMP("MZJF",$j,"LocFeePrt",0)="就诊科室"_"^"_catedesc_"^"_"合计"
    s loc="" 
    f  s loc=$o(^TMP("MZJF",$j,"Loc",loc))  q:loc=""  d
    .s locsum=0,locnum=locnum+1
    .s locdesc=$p($p(^CTLOC(loc),"^",2),"-",2)
    .s tmpstr=""
    .s opcate="",num=0
    .f  s opcate=$o(^TMP("MZJF",$j,"Loc",loc,opcate)) q:opcate=""  d
    ..s catefee=+^TMP("MZJF",$j,"Loc",loc,opcate)
    ..s num=num+1
    ..s Tcat(num)=catefee
    ..s Tcatsum(num)=+$g(Tcatsum(num))+catefee
    ..s locsum=locsum+catefee
    ..s allsum=allsum+catefee
    .f i=1:1:num d
    ..i $g(^TMP("MZJF",$j,"LocFeePrt",locnum))'="" s ^TMP("MZJF",$j,"LocFeePrt",locnum)=$g(^TMP("MZJF",$j,"LocFeePrt",locnum))_"^"_Tcat(i)
    ..e  s ^TMP("MZJF",$j,"LocFeePrt",locnum)=Tcat(i)
    .s ^TMP("MZJF",$j,"LocFeePrt",locnum)=locdesc_"^"_^TMP("MZJF",$j,"LocFeePrt",locnum)_"^"_locsum
    .d OutputFI
    s locdesc="合计"
    m Tcat(1)=Tcatsum(1)
    m Tcat(2)=Tcatsum(2)
    m Tcat(3)=Tcatsum(3)
    m Tcat(4)=Tcatsum(4)
    m Tcat(5)=Tcatsum(5)
    m Tcat(6)=Tcatsum(6),Tcat(7)=Tcatsum(7),Tcat(8)=Tcatsum(8),Tcat(9)=Tcatsum(9),Tcat(10)=Tcatsum(10),Tcat(11)=Tcatsum(11),Tcat(12)=Tcatsum(12),Tcat(13)=Tcatsum(13),Tcat(14)=Tcatsum(14),Tcat(15)=Tcatsum(15),Tcat(16)=Tcatsum(16),Tcat(17)=Tcatsum(17),Tcat(18)=Tcatsum(18),Tcat(19)=Tcatsum(19),Tcat(20)=Tcatsum(20),locsum=allsum
	f i=1:1:num d
    .i $g(^TMP("MZJF",$j,"LocFeePrt",locnum+1))'="" s ^TMP("MZJF",$j,"LocFeePrt",locnum+1)=$g(^TMP("MZJF",$j,"LocFeePrt",locnum+1))_"^"_Tcat(i)
    .e  s ^TMP("MZJF",$j,"LocFeePrt",locnum+1)=Tcat(i)
    s ^TMP("MZJF",$j,"LocFeePrt",locnum+1)="总计"_"^"_^TMP("MZJF",$j,"LocFeePrt",locnum+1)_"^"_locsum
	d OutputFI
	Quit $$$OK
OutputFI
	s Data=$lb(index,locdesc,Tcat(1),Tcat(2),Tcat(3),Tcat(4),Tcat(5),Tcat(6),Tcat(7),Tcat(8),Tcat(9),Tcat(10),Tcat(11),Tcat(12),Tcat(13),Tcat(14),Tcat(15),Tcat(16),Tcat(17),Tcat(18),Tcat(19),$g(Tcat(20)),locsum,$j)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod QueryLocFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocFeeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryLocFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryLocFee(StDate As %String = "", EndDate As %String = "", UserRowId As %String) As %Query(ROWSPEC = "TNO:%String,TLocName:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String, TCAT9:%String, TCAT10:%String,TCAT11:%String, TCAT12:%String, TCAT13:%String, TCAT14:%String, TCAT15:%String, TCAT16:%String, TCAT17:%String, TCAT18:%String, TCAT19:%String, TCAT20:%String, TSum:%String,TJob:%String")
{
}

ClassMethod GetLocCateFee(BDate As %String = "", EDate As %String = "", Guser As %String = "") As %String
{
	d ..InitLocCateFee()  
	i BDate["/" d
	.s BDate=$zdh(BDate,4)
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	f myDate=BDate:1:EDate d
	.f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	..s myHisRowID=""
	..f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	...s myUser=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	...q:((Guser'="")&(Guser'=myUser))
	...i myUser'="" s myUserName=$p(^SSU("SSUSR",myUser),"^",2)
	...s ^TMP("MZJF",$j,"User",myUser)=myUser_"^"_myUserName
	...s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	...s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	...s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	...s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	...d ..STATtoCAT(myHisRowID)
	q 0
}

ClassMethod STATtoCAT(INVRepRowID As %String) As %String
{
	s iteminfo=""
	s INVPRTRowid=0,aa=0
	f  s INVPRTRowid=$o(^DHCINVPRT(0,"Report",INVRepRowID, INVPRTRowid)) q:(INVPRTRowid="")  d
	.s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) Quit:conRowid=""  d
	..S Bill=$p(^DHCBCI(conRowid),"^",2)
	..q:'$D(^DHCPB(Bill))
	..s adm=$p(^DHCPB(Bill),"^",1)
	..s admloc=$p(^PAADM(adm),"^",4)
	..;s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
    ...;s ^TMP("MZJF",$j,"Loc",admloc,itmrowid)=0
    ...;s 
	..S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	...S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	....S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	....S ItmOPSubCat=$p($g(^DHCTARI(ItmDr)),"^",15)
	....s ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....s ^TMP("MZJF",$j,"Loc",admloc,ItmOPCat)=+$g( ^TMP("MZJF",$j,admloc,ItmOPCat))+TotalAmount
	q
}

ClassMethod InitLocCateFee()
{
   s admloc="",num=1,catedesc=""
   f  s admloc=$o(^PAC("ADMLOC",admloc)) q:admloc=""  d
   .s loctype=$p(^PAC("ADMLOC",admloc),"^",1)
   .q:loctype'="O"
   .s locrowid=$p(^PAC("ADMLOC",admloc),"^",2)
   .s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
   ..s ^TMP("MZJF",$j,"Loc",locrowid,itmrowid)=0
   ..s itmdesc=$p(^DHCTarC("TOC",itmrowid),"^",2)
   ..i num=1 d 
   ...i catedesc'="" s catedesc=catedesc_"^"_itmdesc
   ...e  s catedesc=itmdesc
   .s num=num+1
   q
}

ClassMethod QueryUserExecute(ByRef qHandle As %Binary) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s index=1	
	s rowid="" 
	f  s rowid=$o(^TMP("MZJF",$j,"User",rowid)) q:rowid=""  d
	.s User=$p(^TMP("MZJF",$j,"User",rowid),"^",1)
	.s UserName=$p(^TMP("MZJF",$j,"User",rowid),"^",2)
	d OutPutUser
	Quit $$$OK
OutPutUser
	s Data=$lb(UserName,User)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod QueryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryUser() As %Query(ROWSPEC = "TUserName:%String,TUserRowId:%String")
{
}

ClassMethod GetLocCatFeeNum(job)
{
   //取就诊科室的行数
	s num=$o(^TMP("MZJF",job,"LocFeePrt",""),-1)
	q num
}

ClassMethod LocCatFeePrtInfo(job, ind)
{
   //取每个就诊科室的个分类的金额
	s str=^TMP("MZJF",job,"LocFeePrt",ind)
	q str
}

ClassMethod Getnum(job)
{
	s job=$g(job)
	q:job=""
	s num=0
	q:$d(^TMP("zlprt",$j,"CashAll"))=0 0
	s num=$g(^TMP("zlprt",$j,"CashAll"))
	q num
}

ClassMethod Getdata(job, i)
{

	s job=$g(job)
	s i=$g(i)
	q:((job="")||(i=""))
	s str=""
	q:$d(^TMP("zlprt",$j,"CashAll",i))=0 0
	s str=$g(^TMP("zlprt",$j,"CashAll",i))
    q str
}

ClassMethod killtmp()
{
   
	kill ^TMP("zlprt")
}

}
