Import SQLUser

Class web.RoutineworkD Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// /自助机住院预交金报表
/// 
ClassMethod InAutoDespoitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InAutoDespoitExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","InAutoDespoit","2018-05-23","2018-05-23")

ClassMethod InAutoDespoitExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s WMIPID="",TranSction=""
	;Set repid=$I(^CacheTemp)
	set prtid="",MecCashAmt=0,MecYJKAmt=0,MecCashNum=0,MecYJKNum=0
	set tmpcashsum=0,RMB="",PrtStr=""
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	F iDate=SDate:1:EDate D
	.f  s prtid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",iDate,prtid)) q:prtid=""  d
	..s statue=$p(^DHCSFPRINTDETAIL(prtid),"^",8)
	..q:statue="2"
	..s User=$p(^DHCSFPRINTDETAIL(prtid),"^",20)
	..;s User="2499"
	..;q:User'="2499"
	..s username=$p(^SSU("SSUSR",User),"^",2)
	..s payamount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
	..s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
	..q:paymode'="35"
	..s PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",1)
	..s:+payamount<0 PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",7)
	..;s:+payamount<0 TFPrtno=$p(^DHCSFPRINTDETAIL(prtid),"^",7)
	..s WMIPID="",WMIPTFID=""
	..i +payamount>0 d  
	...s WMIPID=$O(^DHCWMIPCPNO("CPNO",PrtNo,WMIPID))
	..i +payamount<0 d 
	...s WMIPTFID=$O(^DHCWMIPCPNO("CPNO",PrtNo,WMIPTFID))
	...s WMIPID=$O(^DHCWMIPCPNO("CPNO","TF"_WMIPTFID,WMIPID))
	..s:WMIPID'="" TranSction=$p($g(^DHCWMIPDesoit(WMIPID)),"^",4)
	..s Adm=$p(^DHCSFPRINTDETAIL(prtid),"^",4)
	..s papmi=$p(^PAADM(Adm),"^",1)
	..s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s PatNO=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s Date=$zd($p(^DHCSFPRINTDETAIL(prtid),"^",2),3)
	..s Time=$zt($p(^DHCSFPRINTDETAIL(prtid),"^",3),1)
	..d BuildTarCatepatnum
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCatepatnum    
	set Data=$lb(ind,PatNO,Patname,payamount,Date,Time,PrtNo,TranSction)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InAutoDespoitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InAutoDespoitExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query InAutoDespoit(SDate, EDate) As %Query(ROWSPEC = "ind,PatNO,Patname,payamount,Date,Time,PrtNo,TranSction") [ SqlProc ]
{
}

// w ##class(web.RoutineworkD).GetStarEnd("1130000000^1130000000")

ClassMethod GetStarEnd(s) As %String
{
	k ^TMPLenstr
	s len=$L(s,"^")
	f i=1:1:len d
	.s start=$p(s,"^",i)
	.;w !,start
	.q:start=""
	.s cur=$p(s,"^",i+1)
	.i +start+1=+cur d
	..
	.e  d
	..s:i'=len ^TMPLenstr($j)=$g(^TMPLenstr($j))_"^"_i
	s retstring=""

	i $d(^TMPLenstr($j)) d
	.s Len=$L(^TMPLenstr($j),"^")
	.f i=1:1:Len  d
	..q:$p(^TMPLenstr($j),"^",i)=""
	..s zdz=$p(^TMPLenstr($j),"^",i)
	..s retstring=retstring_"--"_$p(s,"^",zdz)_","_$p(s,"^",zdz+1)
	.s retstring=$p(s,"^",2)_retstring_"--"_$p(s,"^",len)
	e  d
	.s:$p(s,"^",1)="" YjjNumS=$p(s,"^",2)
	.s:$p(s,"^",1)'="" YjjNumS=$p(s,"^",1)
	.s:$p(s,"^",len)="" YjjNumE=$p(s,"^",len-1)
	.s:$p(s,"^",len)'="" YjjNumE=$p(s,"^",len)
	.s retstring=YjjNumS_"--"_YjjNumE
	
	q retstring
}

/// /自助机住院预交金报表
/// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","InAutoDespoitCount","2018-05-23","2018-05-23")
ClassMethod InAutoDespoitCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InAutoDespoitCountExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod InAutoDespoitCountExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s WMIPID="",TranSction="",count="",Str="",SUM="",RetStr="",Tcount=0,TSUM=0
	;Set repid=$I(^CacheTemp)
	set prtid="",MecCashAmt=0,MecYJKAmt=0,MecCashNum=0,MecYJKNum=0
	set tmpcashsum=0,RMB="",PrtStr=""
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	F iDate=SDate:1:EDate D
	.f  s prtid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",iDate,prtid)) q:prtid=""  d
	..s statue=$p(^DHCSFPRINTDETAIL(prtid),"^",8)
	..q:statue="2"
	..s User=$p(^DHCSFPRINTDETAIL(prtid),"^",20)
	..;s User="2499"
	..;q:User'="2499"
	..s username=$p(^SSU("SSUSR",User),"^",2)
	..s payamount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
	..s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
	..q:paymode'="35"
	..s PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",1)
	..s:User="2499" count=count+1
	..s:User="2499" SUM=SUM+payamount
	..s:User'="2499" Tcount=Tcount+1
	..s:User'="2499" TSUM=TSUM+payamount
	..if Str="" d
	...s Str=PrtNo
	..else  d
	..s Str=Str_"^"_PrtNo
	..s RetStr=..GetStarEnd(Str)
	
	s RMB=##class(web.DHCINSUPort).RMBConvert(SUM+TSUM)
	d BuildTarCatepatCount
    Quit $$$OK
	
BuildTarCatepatCount    
	set Data=$lb(ind,count,SUM,RetStr,RMB,Tcount,TSUM)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InAutoDespoitCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InAutoDespoitCountExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query InAutoDespoitCount(SDate, EDate) As %Query(ROWSPEC = "ind,count,SUM,RetStr,RMB,Tcount,TSUM") [ SqlProc ]
{
}

// w ##class(web.RoutineworkD).IFCanCallPatient("儿科门诊","1899")

ClassMethod IFCanCallPatient(CTdesc, Userid) As %String
{
	
	/*s vistype="", visid="",visstate=""
	f  s vistype=$O(^DHCVISQueuei(0,"TypeStateDate",vistype))  q:vistype=""  d
	.f  s visstate=$O(^DHCVISQueuei(0,"TypeStateDate",vistype,visstate))  q:visstate=""  d
	..f  s visid=$O(^DHCVISQueuei(0,"TypeStateDate",vistype,visstate,+$h,visid))  q:visid=""  d
	...s Createuser=$p(^DHCVISQueue(visid),"^",11)
	...s servername=$p(^DHCVISQueue(visid),"^",10)
	...q:Createuser'=Userid
	...q:servername'=CTdesc
	...w !,visid */
	s rtn=0
	s visid=""
	s visid=$O(^DHCVISQueuei(0,"CreateUser",Userid,visid),-1)
	s CallDate=$P(^DHCVISQueue(visid),"^",12)
	s CreateTime=$P(^DHCVISQueue(visid),"^",13)
	s NowTime=$p($h,",",2)
	s sub=NowTime-CreateTime
	s NowDate=+$h
	
	if sub<60 d
	.s rtn="-1"
	else  d
	.s rtn="0"
	if (CallDate'=NowDate) d ;这种表示每一天的第一次呼叫都视为是可以的
	.s rtn="0"
	q rtn
}

// w ##class(web.RoutineworkD).InsertWMIPAddDet("0^00000000001123^38^14126^000000000012^^^2000^WMZY20170926124545112^2499^^^^")

ClassMethod InsertWMIPAddDet(data) As %String
{
	//Data=0^00000000001123^38^14126^000000000012^^^2000^WMZY20170926124545112^2499^^^^
	//     
		
	k PLIST
	
	b ;insert
	s CPNO=$p(data,"^",2)
	i CPNO'="" s PLIST(2)=CPNO                       //预交金票号
	
	s Papmi=$p(data,"^",3)
	i Papmi'="" s PLIST(3)=Papmi                       //papmi
	
	s Adm=$p(data,"^",4)
	i Adm'="" s PLIST(4)=Adm                   //就诊号
	
	s Card=$p(data,"^",5)
	i Card'="" s PLIST(5)=Card                     //卡号
	
	
	s TradeDate=$p($h,",",1)
	i TradeDate'="" s PLIST(6)=TradeDate                     	 //日期
	
	s TradeTime=$p($h,",",2)
	i TradeTime'="" s PLIST(7)=TradeTime               //时间
	
	s Amt=$p(data,"^",8)
	i Amt'="" s PLIST(8)=Amt                //金额
	
	s Transction=$p(data,"^",9)
	i Transction'="" s PLIST(9)=Transction                      //交易流水
	
	s User=$p(data,"^",10)
	i User'="" s PLIST(10)=User            //操作员
	
	
	s Str1="N"
	i Str1'="" s PLIST(11)=Str1            //预留1
	
	
	s Str2=$p(data,"^",12)
	i Str2'="" s PLIST(12)=Str2                     //预留2
	
	s Str3=$p(data,"^",13)
	i Str3'="" s PLIST(13)=Str3                     //预留3
	
	s Str4=$p(data,"^",14)
	i Str4'="" s PLIST(14)=Str4           //预留4
	


	
	&SQL(INSERT INTO SQLUser.DHCWMIPAddDetail VALUES PLIST())
	i SQLCODE'=0 Trollback
	q SQLCODE
}

// w ##class(web.RoutineworkD).InsertWMIPAddDet("0^00000000001123^38^14126^000000000012^^^2000^WMZY20170926124545112^2499^^^^")

ClassMethod InsertWMIPAddDetTF(data) As %String
{
	//Data=0^00000000001123^38^14126^000000000012^^^2000^WMZY20170926124545112^2499^^^^
	//     
		
	k PLIST
	
	b ;insert
	s CPNO=$p(data,"^",2)
	i CPNO'="" s PLIST(2)=CPNO                       //预交金票号
	
	s Papmi=$p(data,"^",3)
	i Papmi'="" s PLIST(3)=Papmi                       //papmi
	
	s Adm=$p(data,"^",4)
	i Adm'="" s PLIST(4)=Adm                   //就诊号
	
	s Card=$p(data,"^",5)
	i Card'="" s PLIST(5)=Card                     //卡号
	
	
	s TradeDate=$p($h,",",1)
	i TradeDate'="" s PLIST(6)=TradeDate                     	 //日期
	
	s TradeTime=$p($h,",",2)
	i TradeTime'="" s PLIST(7)=TradeTime               //时间
	
	s Amt=$p(data,"^",8)
	i Amt'="" s PLIST(8)=Amt                //金额
	
	s Transction=$p(data,"^",9)
	i Transction'="" s PLIST(9)=Transction                      //交易流水
	
	s User=$p(data,"^",10)
	i User'="" s PLIST(10)=User            //操作员
	
	
	s Str1="S"
	i Str1'="" s PLIST(11)=Str1            //预留1
	
	
	s Str2=$p(data,"^",12)
	i Str2'="" s PLIST(12)=Str2                     //预留2
	
	s Str3=$p(data,"^",13)
	i Str3'="" s PLIST(13)=Str3                     //预留3
	
	s Str4=$p(data,"^",14)
	i Str4'="" s PLIST(14)=Str4           //预留4
	


	
	&SQL(INSERT INTO SQLUser.DHCWMIPAddDetail VALUES PLIST())
	i SQLCODE'=0 Trollback
	q SQLCODE
}

ClassMethod GetMrAdm(Adm) As %String
{
	s Mrid="",Papmi=""	
	s Mrid=$p(^PAADM(Adm),"^",61)
	s Papmi=$p(^PAADM(Adm),"^",1)
	
	q Mrid_"^"_Papmi
}

// 查询失败记录

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","JCFailRecord","2017-10-20","2017-10-20")

ClassMethod JCFailRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JCFailRecordExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod JCFailRecordExecute(ByRef qHandle As %Binary, Stdate, Enddate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;n (SDate,EDate)
	s jzksID="",jzks="",jzbqID="",jzbq="",jsys="",jsysID="",patmasrow="",cs="",DischgDate="",date1="",date2="",iDate=""
	;s ^TMPwang("JZks")=Stdate_"  "_Enddate
	;s:Stdate="" Stdate=$zdh($h,3)
	;Set repid=$I(^CacheTemp)

	s admrowid="",INVNO="发票号不存在"
	s:Stdate["-" Stdate=$zdh(Stdate,3)
	s:Enddate["-" Enddate=$zdh(Enddate,3)
	F Idate=Stdate:1:Enddate D
    .s rowid=""  f  s rowid=$o(^JCWAPayDatei("Date",Idate,rowid)) q:rowid=""  d
    ..s code=$p(^JCWeiAliPayO(rowid),"^",1)
    ..q:(code'="E")&(code'="F") //成功的退出
    ..s desc=$p(^JCWeiAliPayO(rowid),"^",2)
 
    ..s adm=$p(^JCWeiAliPayO(rowid),"^",12) //就诊号
    ..s papmi=$p(^PAADM(adm),"^",1) //用来获取姓名，性别，年龄，身份证号，手机号
    ..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..s name=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s sex=$p(^PAPER((papmi),"ALL"),"^",7)
	..s:sex=1 sex="男"
	..s:sex=2 sex="女"
    ..//s dob=
    ..s ID=$p(^PAPER((papmi),"ALL"),"^",9) //	身份证号
	..s phone=$p(^PAPER((papmi),"ALL"),"^",4) //	手机号码
    ..s inv=$p(^JCWeiAliPayO(rowid),"^",5) //原发票
    ..s INVNO=$p($g(^DHCINVPRT(inv)),"^",14)
    ..s ctlocdesc=$p(^CTLOC($p(^PAADM(adm),"^",4)),"^",2) //就诊科室
    ..s admdate=$zd($p(^PAADM(adm),"^",6)) //就诊日期
    ..s doctor=$p(^CTPCP($p(^PAADM(adm),"^",9),1),"^",2) //就诊医生
    ..s invdate=$p(^JCWeiAliPayO(rowid),"^",3) //缴费日期
    ..s invtime=$p(^JCWeiAliPayO(rowid),"^",3) //缴费时间
    ..s OutTrade=$p(^JCWeiAliPayO(rowid),"^",9) //交易流水号
    ..s userid=$p(^JCWeiAliPayO(rowid),"^",11) //缴费终端
    ..s user=$p( ^SSU("SSUSR",userid),"^",2)
    ..s Paymodeid=$p(^JCWeiAliPayO(rowid),"^",7)
    ..s Paymode=$P(^CT("CTPM",Paymodeid),"^",2)
    ..s amt=$p(^JCWeiAliPayO(rowid),"^",8) //订单总金额
    ..d BuildTar
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTar  
	set Data=$lb(ind,code,desc,papno,name,sex,ID,phone,inv,amt,ctlocdesc,admdate,doctor,$zd(invdate,3),$zt(invtime,1),OutTrade,user,Paymode,INVNO)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod JCFailRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JCFailRecordExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query JCFailRecord(Stdate, Enddate) As %Query(ROWSPEC = "ind,code,desc,papno,name,sex,ID,phone,inv,amt,ctlocdesc,admdate,doctor,invdate,invtime,OutTrade,user,Paymode,INVNO") [ SqlProc ]
{
}

// w ##class(web.RoutineworkD).JCException("5610114","2114")

ClassMethod JCException(PrtInvID, User) As %String
{
	set JCID="",rtn="-1"
	set JCID=$O(^JCWAPayINVi("INVPRT",PrtInvID,JCID))
	q:JCID="" "无此记录"
	s ^tmpprtinvid=PrtInvID
	q:'$d(^DHCINVPRT(PrtInvID)) "His无此发票记录,请手工退费!"
	set PrtFlag=$p(^DHCINVPRT(PrtInvID),"^",8)
	q:PrtFlag="N" "His此发票尚未退费,无法退费!"
	set Input=$p(^JCWeiAliPayO(JCID),"^",16)
	set myPayModeDR=$p(^JCWeiAliPayO(JCID),"^",7)
	set NewPrtRowid=$p(^JCWeiAliPayO(JCID),"^",18)
	set myPRTRowID=$p(^JCWeiAliPayO(JCID),"^",19)
	set StopOrdStr=$p(^JCWeiAliPayO(JCID),"^",17)
	
	set StopOrdStr=$tr(StopOrdStr,"_","^")
	set AbortPrtRowID=PrtInvID
	set TradeOrderNo=$p(^JCWeiAliPayO(JCID),"^",9)
	set IPAddress="172.16.11.12"
	set:JCID="17744" StopOrdStr="1529103||8"
	set:JCID="17745" StopOrdStr="1529103||2^1529103||3^1529103||4"
	set:JCID="17746" StopOrdStr="1529103||9^1529103||10^1529103||11^1529103||12"
	b ;323w
	q:(StopOrdStr="")||(NewPrtRowid="") "缺少信息,请扫码退款!"
	
	set rtn=##class(web.JCSMPay.JCPrtRefund).JCRefund(myPayModeDR, myPRTRowID,StopOrdStr,NewPrtRowid, AbortPrtRowID,TradeOrderNo,IPAddress,User)
	q rtn
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","JCAliWeiDetail","2017-11-28","2017-11-28","NULL","JC")

ClassMethod JCAliWeiDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JCAliWeiDetailExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod JCAliWeiDetailExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov, Type) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s:Type="" type="HIS"
	
	s Invconid=""
	s admrowid=""
	s Prtsta=""
	s xs=1
	s ydmoney=""
	k ^tmpjctrade
	if Type="HIS" {
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	f idate=SDate:1:EDate  d
	.set JCID=""
	.f  s JCID=$O(^JCWAPayDatei("Date",idate,JCID))  q:JCID=""   d
	..s paycode=$p(^JCWeiAliPayO(JCID),"^",1)
	..q:paycode="I"
	..q:paycode="C"
	..s payDesc=$p(^JCWeiAliPayO(JCID),"^",2)
	..s paadm=$p(^JCWeiAliPayO(JCID),"^",12)
	..s papmi=$p(^PAADM(paadm),"^",1)
	..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s PayMode=$p(^JCWeiAliPayO(JCID),"^",7)
	..s Paymodesc=$p(^CT("CTPM",PayMode),"^",2)
	..s PayDate=$p(^JCWeiAliPayO(JCID),"^",3)
	..s PayTime=$p(^JCWeiAliPayO(JCID),"^",4)
	..s PrtID=$p(^JCWeiAliPayO(JCID),"^",5)
	..s PrtAccout=$p(^JCWeiAliPayO(JCID),"^",6)
	..s TradeNo=$p(^JCWeiAliPayO(JCID),"^",9)
	..q:(ctcareprov'=PayMode)&&(ctcareprov'="NULL")
	..d BuildTarCatepatnum1 
	f idate=SDate:1:EDate  d
	.s RegID=""
	.f  s RegID=$O(^JCRegRecordDatei("Date",idate,RegID))   q:RegID=""  d
	..s paycode=$p(^JCRegRecordO(RegID),"^",6)
	..q:paycode="I"
	..q:paycode="C"
	..s payDesc=$p(^JCRegRecordO(RegID),"^",7)
	..;s paadm=$p(^JCRegRecordO(RegID),"^",4)
	..s papmi=$p(^JCRegRecordO(RegID),"^",13)
	..;s papmi=$p(^PAADM(paadm),"^",1)
	..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s PayMode=$p(^JCRegRecordO(RegID),"^",1)
	..s Paymodesc=$p(^CT("CTPM",PayMode),"^",2)
	..s PayDate=$p(^JCRegRecordO(RegID),"^",8)
	..s PayTime=$p(^JCRegRecordO(RegID),"^",9)
	..s PrtID=$p(^JCRegRecordO(RegID),"^",3)
	..s PrtAccout=$p(^JCRegRecordO(RegID),"^",2)
	..s TradeNo=$p(^JCRegRecordO(RegID),"^",10)
	..q:(ctcareprov'=PayMode)&&(ctcareprov'="NULL")
	..d BuildTarCatepatnum1
	
	
	
	}
	if Type="JC" 
	{
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	f idate=SDate:1:EDate  d
	.set JCID=""
	.f  s JCID=$O(^JCWAPayDatei("Date",idate,JCID))  q:JCID=""   d
	..s paycode=$p(^JCWeiAliPayO(JCID),"^",1)
	..q:paycode="I"
	..q:paycode="C"
	..s payDesc=$p(^JCWeiAliPayO(JCID),"^",2)
	..s paadm=$p(^JCWeiAliPayO(JCID),"^",12)
	..s papmi=$p(^PAADM(paadm),"^",1)
	..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s PayMode=$p(^JCWeiAliPayO(JCID),"^",7)
	..s Paymodesc=$p(^CT("CTPM",PayMode),"^",2)
	..s PayDate=$p(^JCWeiAliPayO(JCID),"^",3)
	..s PayTime=$p(^JCWeiAliPayO(JCID),"^",4)
	..s PrtID=$p(^JCWeiAliPayO(JCID),"^",5)
	..s PrtAccout=$p(^JCWeiAliPayO(JCID),"^",6)
	
	..s OrderNO=$p(^JCWeiAliPayO(JCID),"^",9)
	..q:(ctcareprov'=PayMode)&&(ctcareprov'="NULL")
	..s ^tmpjctrade($j,OrderNO)=$g(^tmpjctrade($j,OrderNO))+PrtAccout

	..s ^tmpjctrade($j,OrderNO,"Info")=papno_"^"_Patname_"^"_PayDate_"^"_PayTime_"^"_Paymodesc
	..;w !,PrtAccout_"  "_OrderNO
	f idate=SDate:1:EDate  d
	.s RegID=""
	.f  s RegID=$O(^JCRegRecordDatei("Date",idate,RegID))  q:RegID=""  d
	..s paycode=$p(^JCRegRecordO(RegID),"^",6)
	..q:paycode="I"
	..q:paycode="C"
	..s payDesc=$p(^JCRegRecordO(RegID),"^",7)
	..;s paadm=$p(^JCRegRecordO(RegID),"^",4)
	..s papmi=$p(^JCRegRecordO(RegID),"^",13)
	..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s PayMode=$p(^JCRegRecordO(RegID),"^",1)
	..s Paymodesc=$p(^CT("CTPM",PayMode),"^",2)
	..s PayDate=$p(^JCRegRecordO(RegID),"^",8)
	..s PayTime=$p(^JCRegRecordO(RegID),"^",9)
	..s PrtID=$p(^JCRegRecordO(RegID),"^",3)
	..s PrtAccout=$p(^JCRegRecordO(RegID),"^",2)
	..s TradeNo=$p(^JCRegRecordO(RegID),"^",10)
	..q:(ctcareprov'=PayMode)&&(ctcareprov'="NULL")
	..s ^tmpjctrade($j,TradeNo)=$g(^tmpjctrade($j,TradeNo))+PrtAccout
	..b ;1
	..s ^tmpjctrade($j,TradeNo,"Info")=papno_"^"_Patname_"^"_PayDate_"^"_PayTime_"^"_Paymodesc
	
	
	
	s TradeNo=""
	f  s TradeNo=$O(^tmpjctrade($j,TradeNo))  q:TradeNo=""  d
	.s PrtAccout=$g(^tmpjctrade($j,TradeNo))
	.s OutStr=$g(^tmpjctrade($j,TradeNo,"Info"))
	.s papno=$p(OutStr,"^",1)
	.s payDesc=""
	.s Patname=$p(OutStr,"^",2)
	.s PayDate=$p(OutStr,"^",3)
	.s PayTime=$p(OutStr,"^",4)
	.s Paymodesc=$p(OutStr,"^",5)
	.d BuildTarCatepatnum1

		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCatepatnum1    
	set Data=$lb(ind,payDesc,PrtAccout,papno,Patname,Paymodesc,$zd(PayDate,3),$zt(PayTime,1),TradeNo)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod JCAliWeiDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JCAliWeiDetailExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query JCAliWeiDetail(SDate, EDate, ctcareprov, Type) As %Query(ROWSPEC = "ind,payDesc,PrtAccout,papno,Patname,Paymodesc,PayDate,PayTime,TradeNo") [ SqlProc ]
{
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","JCAliWeiSum","2022-05-18","2022-05-18","","")

ClassMethod JCAliWeiSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JCAliWeiSumExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod JCAliWeiSumExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov, Type) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s:Type="" type="HIS"
	s ctcareprov="NULL"
	s Invconid=""
	s admrowid=""
	s Prtsta=""
	s xs=1
	s ydmoney=""
	s ZFBGZH=0
	s WXGZH=0
	s GHWXGZH=0
	s ZYWXGZH=0
	s ZFBGZH=0
	s GHZFBGZH=0
	s ZYZFBGZH=0
	s zzjalisum=0
	s zzjalinum=0
	s zzjweisum=0
	s zzjweinum=0
	s zjzfWeiNum=0
	s zjzfWeiSum=0
	s zjzfAliNum=0
	s zjzfAliSum=0 
	;k ^tmpjctradeSum
	set ZFBGZHNum=0,ZFBGZHSum=0,ZFBGZHHCNum=0,ZFBGZHHCSum=0
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	s AliSFCount=0,AliSFAmt=0,AliTFCount=0,AliTFAmt=0
	s WeiSFCount=0,WeiSFAmt=0,WeiTFCount=0,WeiTFAmt=0
	f idate=SDate:1:EDate  d
	.set JCID=""
	.f  s JCID=$O(^JCWAPayDatei("Date",idate,JCID))  q:JCID=""   d
	..s paycode=$p(^JCWeiAliPayO(JCID),"^",1)
	..q:paycode="I"
	..q:paycode="C"
	..q:paycode="F"
	..s payDesc=$p(^JCWeiAliPayO(JCID),"^",2)
	..s Userid=$p(^JCWeiAliPayO(JCID),"^",11)
	..I Userid="2126"  S Userid="2889"
	..s paadm=$p(^JCWeiAliPayO(JCID),"^",12)
	..s papmi=$p(^PAADM(paadm),"^",1)
	..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s PayMode=$p(^JCWeiAliPayO(JCID),"^",7)
	..s Paymodesc=$p(^CT("CTPM",PayMode),"^",2)
	..s PayDate=$p(^JCWeiAliPayO(JCID),"^",3)
	..s PayTime=$p(^JCWeiAliPayO(JCID),"^",4)
	..s PrtID=$p(^JCWeiAliPayO(JCID),"^",5)
	..s PrtAccout=$p(^JCWeiAliPayO(JCID),"^",6)
	..s TradeNo=$p(^JCWeiAliPayO(JCID),"^",9)
	..s:Userid="2611" WXGZH=WXGZH+PrtAccout
	..s:Userid="2612" ZFBGZH=ZFBGZH+PrtAccout,ZFBGZHNum=ZFBGZHNum+1
	..s:(Userid="2672")&(PayMode="37")&(PrtAccout>0) zjzfWeiSum=zjzfWeiSum+PrtAccout,zjzfWeiNum=zjzfWeiNum+1
	..s:(Userid="2672")&(PayMode="36")&(PrtAccout>0) zjzfAliSum=zjzfAliSum+PrtAccout,zjzfAliNum=zjzfAliNum+1
	..;q:(ctcareprov'=PayMode)&&(ctcareprov'="NULL")
	..s:((PrtAccout>0)&(Paymodesc="支付宝")) AliSFCount=AliSFCount+1,AliSFAmt=AliSFAmt+PrtAccout
	..s:((PrtAccout<0)&(Paymodesc="支付宝")) AliTFCount=AliTFCount+1,AliTFAmt=AliTFAmt+PrtAccout
	..s:((+PrtAccout>0)&(Paymodesc="微信")) WeiSFCount=WeiSFCount+1,WeiSFAmt=WeiSFAmt+PrtAccout
	..s:((+PrtAccout<0)&(Paymodesc="微信")) WeiTFCount=WeiTFCount+1,WeiTFAmt=WeiTFAmt+PrtAccout
	
	f idate=SDate:1:EDate  d
	.s RegID=""
	.f  s RegID=$O(^JCRegRecordDatei("Date",idate,RegID))  q:RegID=""  d
	..s paycode=$p(^JCRegRecordO(RegID),"^",6)
	..q:paycode="I"
	..q:paycode="C"
	..q:paycode="F"
	..s PayMode=$p(^JCRegRecordO(RegID),"^",1)
	..s Paymodesc=$p(^CT("CTPM",PayMode),"^",2)
	..s PrtAccout=$p(^JCRegRecordO(RegID),"^",2)
	..s Userid=$p(^JCRegRecordO(RegID),"^",12)
	..I Userid="2126" S Userid="2889"
	..s:Userid="2611" GHWXGZH=GHWXGZH+PrtAccout
	..s:Userid="2612" GHZFBGZH=GHZFBGZH+PrtAccout,ZFBGZHNum=ZFBGZHNum+1
	..s:(Userid="2672")&(PayMode="37")&(PrtAccout>0) zjzfWeiSum=zjzfWeiSum+PrtAccout,zjzfWeiNum=zjzfWeiNum+1
	..s:(Userid="2672")&(PayMode="36")&(PrtAccout>0) zjzfAliSum=zjzfAliSum+PrtAccout,zjzfAliNum=zjzfAliNum+1
	..;s:(Userid="2612")&(paycode="B") ZFBGZHHCSum=ZFBGZHHCSum+PrtAccout,ZFBGZHHCNum=ZFBGZHHCNum+1
	..s:((PrtAccout>0)&(Paymodesc="支付宝")) AliSFCount=AliSFCount+1,AliSFAmt=AliSFAmt+PrtAccout
	..s:((PrtAccout<0)&(Paymodesc="支付宝")) AliTFCount=AliTFCount+1,AliTFAmt=AliTFAmt+PrtAccout
	..s:((+PrtAccout>0)&(Paymodesc="微信")) WeiSFCount=WeiSFCount+1,WeiSFAmt=WeiSFAmt+PrtAccout
	..s:((+PrtAccout<0)&(Paymodesc="微信")) WeiTFCount=WeiTFCount+1,WeiTFAmt=WeiTFAmt+PrtAccout
	s ZYAliScount=0,ZYAliSamt=0,ZYAliTcount=0,ZYAliTamt=0,ZYWeiScount=0,ZYWeiSAmt=0,ZYWeiTcount=0,ZYWeiTAmt=0
	s (ZYZZJAliScount,ZYZZJAliSamt,ZYZZJAliTcount,ZYZZJAliTamt,ZYZZJWeiScount,ZYZZJWeiSAmt,ZYZZJWeiTcount,ZYZZJWeiTAmt)=0
	s (MNZYZZJAliScount,MNZYZZJAliSamt,MNZYZZJAliTcount,MNZYZZJAliTamt,MNZYZZJWeiScount,MNZYZZJWeiSAmt,MNZYZZJWeiTcount,MNZYZZJWeiTAmt)=0
	s ZYWXGZH=0,ZYWXGZHcount=0,ZYWXGZHHC=0,ZYWXGZHHCcount=0
	s ZYZFBGZH=0,ZYZFBGZHcount=0,ZYZFBGZHHC=0,ZYZFBGZHHCcount=0
	
	f idate=SDate:1:EDate  d
	.set JCRcptID=""
	.f  set JCRcptID=$O(^JCReceiptDatei("Date",idate,JCRcptID))  q:JCRcptID=""  d
	..s JCReptCode=$P(^JCReceiptO(JCRcptID),"^",1)
	..q:JCReptCode="I"
	..q:JCReptCode="C"
	..q:JCReptCode="A"
	..q:JCReptCode="F"
	..s JCReptDesc=$P(^JCReceiptO(JCRcptID),"^",2)
	..q:JCReptDesc="订单取消"
	..s JCReptAmt=$P(^JCReceiptO(JCRcptID),"^",8) //金额
	..s JCReptAdm=$P(^JCReceiptO(JCRcptID),"^",3) 
	..s JCReptpapmi=$P(^JCReceiptO(JCRcptID),"^",10)
	..s JCPayMode=$P(^JCReceiptO(JCRcptID),"^",11)
	..s JCPaymodesc=$p(^CT("CTPM",JCPayMode),"^",2)
	..s Userid=$P(^JCReceiptO(JCRcptID),"^",15)
	..I Userid="2126"  S Userid="2889"
	..s Usergroup=$p(^SSU("SSUSR",Userid),"^",5)
	..;q:Userid'="2131"
	..s:Userid="2611" ZYWXGZH=ZYWXGZH+JCReptAmt,ZYWXGZHcount=ZYWXGZHcount+1
	..s:Userid="2612" ZYZFBGZH=ZYZFBGZH+JCReptAmt,ZYZFBGZHcount=ZYZFBGZHcount+1
	..s:(Userid="2611")&(JCReptCode="B") ZYWXGZHHC=ZYWXGZHHC+JCReptAmt,ZYWXGZHHCcount=ZYWXGZHHCcount+1
	..s:(Userid="2612")&(JCReptCode="B") ZYZFBGZHHC=ZYZFBGZHHC+JCReptAmt,ZYZFBGZHHCcount=ZYZFBGZHHCcount+1
	..s Username=$p(^SSU("SSUSR",Userid),"^",2)
	..if ((Usergroup="10")&(Userid'="2611")&(Userid'="2612")&(Userid'="2661")&(Username'["迷你")) d
	...s:(JCReptAmt>0)&(JCPaymodesc="支付宝") ZYZZJAliScount=ZYZZJAliScount+1,ZYZZJAliSamt=ZYZZJAliSamt+JCReptAmt
	...s:(JCReptAmt<0)&(JCPaymodesc="支付宝") ZYZZJAliTcount=ZYZZJAliTcount+1,ZYZZJAliTamt=ZYZZJAliTamt+JCReptAmt
	...s:(JCReptAmt>0)&(JCPaymodesc="微信") ZYZZJWeiScount=ZYZZJWeiScount+1,ZYZZJWeiSAmt=ZYZZJWeiSAmt+JCReptAmt
	...s:(JCReptAmt<0)&(JCPaymodesc="微信") ZYZZJWeiTcount=ZYZZJWeiTcount+1,ZYZZJWeiTAmt=ZYZZJWeiTAmt+JCReptAmt
	
	..if ((Usergroup="10")&(Username["迷你")) d
	...s:(JCReptAmt>0)&(JCPaymodesc="支付宝") MNZYZZJAliScount=MNZYZZJAliScount+1,MNZYZZJAliSamt=MNZYZZJAliSamt+JCReptAmt
	...s:(JCReptAmt<0)&(JCPaymodesc="支付宝") MNZYZZJAliTcount=MNZYZZJAliTcount+1,MNZYZZJAliTamt=MNZYZZJAliTamt+JCReptAmt
	...s:(JCReptAmt>0)&(JCPaymodesc="微信") MNZYZZJWeiScount=MNZYZZJWeiScount+1,MNZYZZJWeiSAmt=MNZYZZJWeiSAmt+JCReptAmt
	...s:(JCReptAmt<0)&(JCPaymodesc="微信") MNZYZZJWeiTcount=MNZYZZJWeiTcount+1,MNZYZZJWeiTAmt=MNZYZZJWeiTAmt+JCReptAmt
	
	
	..s:(JCReptAmt>0)&(JCPaymodesc="支付宝") ZYAliScount=ZYAliScount+1,ZYAliSamt=ZYAliSamt+JCReptAmt
	..s:(JCReptAmt<0)&(JCPaymodesc="支付宝") ZYAliTcount=ZYAliTcount+1,ZYAliTamt=ZYAliTamt+JCReptAmt
	..s:(JCReptAmt>0)&(JCPaymodesc="微信") ZYWeiScount=ZYWeiScount+1,ZYWeiSAmt=ZYWeiSAmt+JCReptAmt
	..s:(JCReptAmt<0)&(JCPaymodesc="微信") ZYWeiTcount=ZYWeiTcount+1,ZYWeiTAmt=ZYWeiTAmt+JCReptAmt
	;i MNZYZZJWeiSAmt="10601.0" s MNZYZZJWeiSAmt="10601"
	;b ;MNZYZZJWeiSAmt_"^"_MNZYZZJWeiTAmt
	set WXGzhStr=##class(web.RoutineworkA).GetGHZRegNumSum(SDate, EDate,"2611")
 	set WXGZHNum=$p(WXGzhStr,"^",1)
 	set WXGZHSum=$p(WXGzhStr,"^",2)
 	set WXGZHHCNum=$p(WXGzhStr,"^",3)
 	set WXGZHHCSum=-1*$p(WXGzhStr,"^",4)
 	set ZFBGZHStr=##class(web.RoutineworkA).GetGHZRegNumSum(SDate, EDate,"2612")
 	;set WXGZHNum=$p(WXGzhStr,"^",1)
 	;set WXGZHSum=$p(WXGzhStr,"^",2)
 	set ZFBGZHHCNum=$p(ZFBGZHStr,"^",3)
 	set ZFBGZHHCSum=-1*$p(ZFBGZHStr,"^",4)
 	s zzjinfo=..getZZJAliWei(SDate,EDate) //自助机门诊和迷你自助
	s zzjalisum=$p(zzjinfo,"^",1)
	s zzjalinum=$p(zzjinfo,"^",2)
	s zzjweisum=$p(zzjinfo,"^",3)
	s zzjweinum=$p(zzjinfo,"^",4)
	
	s MNzzjalisum=$p(zzjinfo,"^",5)
	s MNzzjalinum=$p(zzjinfo,"^",6)
	s MNzzjweisum=$p(zzjinfo,"^",7)
	s MNzzjweinum=$p(zzjinfo,"^",8)
	s (MZZFB1,MZZFB2,MZZFB3,MZZFB4,MZWX1,MZWX2,MZWX3,MZWX4,ZYZFB1,ZYZFB2,ZYZFB3,ZYZFB4,ZYWX1,ZYWX2,ZYWX3,ZYWX4)=0
	s MZZFB1=AliSFCount-ZFBGZHNum
	b ;111
	s MZZFB2=AliSFAmt-GHZFBGZH-ZFBGZH-zjzfAliSum
	s MZZFB3=AliTFCount-ZFBGZHHCNum
	s MZZFB4=AliTFAmt-ZFBGZHHCSum
	s MZWX1=WeiSFCount-WXGZHNum
	s MZWX2=WeiSFAmt-WXGZHSum-zjzfWeiSum
	s MZWX3=WeiTFCount-WXGZHHCNum
	s MZWX4=WeiTFAmt-WXGZHHCSum
	s ZYZFB1=ZYAliScount-ZYZFBGZHcount-ZYZZJAliScount-MNZYZZJAliScount
	s ZYZFB2=ZYAliSamt-ZYZFBGZH-ZYZZJAliSamt-MNZYZZJAliSamt
	s ZYZFB3=ZYAliTcount-ZYZFBGZHHCcount-ZYZZJAliTcount-MNZYZZJAliTcount
	s ZYZFB4=ZYAliTamt //-ZYZFBGZHHC-ZYZZJAliTamt-MNZYZZJAliTamt
	s ZYWX1=ZYWeiScount-ZYWXGZHcount-ZYZZJWeiScount-MNZYZZJWeiScount
	s ZYWX2=ZYWeiSAmt-ZYWXGZH-ZYZZJWeiSAmt-MNZYZZJWeiSAmt
	s ZYWX3=ZYWeiTcount-ZYWXGZHHCcount-ZYZZJWeiTcount-MNZYZZJWeiTcount
	s ZYWX4=ZYWeiTAmt ;-ZYWXGZHHC-ZYZZJWeiTAmt-MNZYZZJWeiTAmt ;ZYWeiTAmt-ZYWXGZHHC-ZYZZJWeiTAmt-MNZYZZJWeiTAmt

	
	
	d BuildOrdSum 
	
	
	
	/*f idate=SDate:1:EDate  d
	.set JCID=""
	.f  s JCID=$O(^JCWAPayDatei("Date",idate,JCID))  q:JCID=""   d
	..s paycode=$p(^JCWeiAliPayO(JCID),"^",1)
	..q:paycode="I"
	..s payDesc=$p(^JCWeiAliPayO(JCID),"^",2)
	..s paadm=$p(^JCWeiAliPayO(JCID),"^",12)
	..s papmi=$p(^PAADM(paadm),"^",1)
	..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s PayMode=$p(^JCWeiAliPayO(JCID),"^",7)
	..s Paymodesc=$p(^CT("CTPM",PayMode),"^",2)
	..s PayDate=$p(^JCWeiAliPayO(JCID),"^",3)
	..s PayTime=$p(^JCWeiAliPayO(JCID),"^",4)
	..s PrtID=$p(^JCWeiAliPayO(JCID),"^",5)
	..s PrtAccout=$p(^JCWeiAliPayO(JCID),"^",6)
	
	..s OrderNO=$p(^JCWeiAliPayO(JCID),"^",9)
	..q:(ctcareprov'=PayMode)&&(ctcareprov'="NULL")
	..s ^tmpjctradeSum($j,OrderNO,Paymodesc)=$g(^tmpjctradeSum($j,OrderNO,Paymodesc))+PrtAccout
	..s ^tmpjctradeSum($j,OrderNO, Paymodesc,"Count")=$g(^tmpjctradeSum($j,OrderNO, Paymodesc,"Count"))+1
	..;s ^tmpjctradeSum($j,OrderNO,"Info")=papno_"^"_Patname_"^"_PayDate_"^"_PayTime_"^"_Paymodesc
	..;w !,PrtAccout_"  "_OrderNO
	s TradeNo="",TradePaymode="",Alisum=0,Alicount=0,Weisum=0,Weicount=0
	b ;123
	f  s TradeNo=$O(^tmpjctradeSum($j,TradeNo))  q:TradeNo=""  d
	.f  s TradePaymode=$O(^tmpjctradeSum($j,TradeNo,TradePaymode))  q:TradePaymode=""  d
	..s TradeSum=$g(^tmpjctradeSum($j,TradeNo,TradePaymode))
	..s:TradePaymode="支付宝" Alisum=Alisum+TradeSum,Alicount=Alicount+1
	..s:TradePaymode="微信" Weisum=Weisum+TradeSum,Weicount=Weicount+1
	
	set SumAcount=Weisum+Alisum */
	
	 

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildOrdSum    
	 ;set Data=$lb(ind,AliSFCount,AliSFAmt,AliTFCount,AliTFAmt,WeiSFCount,WeiSFAmt,WeiTFCount,WeiTFAmt,ZYAliScount,ZYAliSamt,ZYAliTcount,ZYAliTamt,ZYWeiScount,ZYWeiSAmt,ZYWeiTcount,ZYWeiTAmt,WXGZH+GHWXGZH,ZFBGZH+GHZFBGZH,ZYWXGZH,ZYZFBGZH,WXGZHNum,WXGZHSum,WXGZHHCNum,WXGZHHCSum,ZFBGZHNum,ZFBGZHSum,0,"0.00",ZYWXGZH,ZYWXGZHcount,"0.00",ZYWXGZHHCcount,ZYZFBGZH,0,"0.00",ZYZFBGZHHCcount,MZZFB1,MZZFB2,MZZFB3,MZZFB4,MZWX1,MZWX2,MZWX3,MZWX4,ZYZFB1,ZYZFB2,ZYZFB3,ZYZFB4,ZYWX1,ZYWX2,ZYWX3,ZYWX4,zzjalisum,zzjalinum,zzjweisum,zzjweinum,ZYZZJAliScount,ZYZZJAliSamt,ZYZZJAliTcount,ZYZZJAliTamt,ZYZZJWeiScount,ZYZZJWeiSAmt,ZYZZJWeiTcount,ZYZZJWeiTAmt,MNZYZZJAliScount,MNZYZZJAliSamt,MNZYZZJAliTcount,MNZYZZJAliTamt,MNZYZZJWeiScount,MNZYZZJWeiSAmt,MNZYZZJWeiTcount,MNZYZZJWeiTAmt,MNzzjalisum,MNzzjalinum,MNzzjweisum,MNzzjweinum,zjzfWeiNum,zjzfWeiSum,zjzfAliNum,zjzfAliSum)   //出参值
 	 set Data=$lb(ind,AliSFCount,AliSFAmt,AliTFCount,AliTFAmt,WeiSFCount,WeiSFAmt,WeiTFCount,WeiTFAmt,ZYAliScount,ZYAliSamt,ZYAliTcount,ZYAliTamt,ZYWeiScount,ZYWeiSAmt,ZYWeiTcount,ZYWeiTAmt,WXGZH+GHWXGZH,ZFBGZH+GHZFBGZH,ZYWXGZH,ZYZFBGZH,WXGZHNum,WXGZHSum,WXGZHHCNum,WXGZHHCSum,ZFBGZHNum,ZFBGZHSum,ZFBGZHHCNum,ZFBGZHHCSum,ZYWXGZH,ZYWXGZHcount,"0.00",ZYWXGZHHCcount,ZYZFBGZH,0,"0.00",ZYZFBGZHHCcount,MZZFB1,MZZFB2,MZZFB3,MZZFB4,MZWX1,MZWX2,MZWX3,MZWX4,ZYZFB1,ZYZFB2,ZYZFB3,ZYZFB4,ZYWX1,ZYWX2,ZYWX3,ZYWX4,zzjalisum,zzjalinum,zzjweisum,zzjweinum,ZYZZJAliScount,ZYZZJAliSamt,ZYZZJAliTcount,ZYZZJAliTamt,ZYZZJWeiScount,ZYZZJWeiSAmt,ZYZZJWeiTcount,ZYZZJWeiTAmt,MNZYZZJAliScount,MNZYZZJAliSamt,MNZYZZJAliTcount,MNZYZZJAliTamt,MNZYZZJWeiScount,MNZYZZJWeiSAmt,MNZYZZJWeiTcount,MNZYZZJWeiTAmt,MNzzjalisum,MNzzjalinum,MNzzjweisum,MNzzjweinum,zjzfWeiNum,zjzfWeiSum,zjzfAliNum,zjzfAliSum)   //出参值

 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod JCAliWeiSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JCAliWeiSumExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query JCAliWeiSum(SDate, EDate, ctcareprov, Type) As %Query(ROWSPEC = "ind,AliSFCount,AliSFAmt,AliTFCount,AliTFAmt,WeiSFCount,WeiSFAmt,WeiTFCount,WeiTFAmt,ZYAliScount,ZYAliSamt,ZYAliTcount,ZYAliTamt,ZYWeiScount,ZYWeiSAmt,ZYWeiTcount,ZYWeiTAmt,WXGZH:%Float,ZFBGZH:%Float,ZYWXGZH:%Float,ZYZFBGZH:%Float,WXGZHNum,WXGZHSum,WXGZHHCNum,WXGZHHCSum,ZFBGZHNum,ZFBGZHSum,ZFBGZHHCNum,ZFBGZHHCSum,ZYWXGZH,ZYWXGZHcount,ZYWXGZHHC,ZYWXGZHHCcount,ZYZFBGZH,ZYZFBGZHcount,ZYZFBGZHHC,ZYZFBGZHHCcount,MZZFB1,MZZFB2,MZZFB3,MZZFB4,MZWX1,MZWX2,MZWX3,MZWX4,ZYZFB1,ZYZFB2,ZYZFB3,ZYZFB4,ZYWX1,ZYWX2,ZYWX3,ZYWX4,zzjalisum,zzjalinum,zzjweisum,zzjweinum,ZYZZJAliScount,ZYZZJAliSamt,ZYZZJAliTcount,ZYZZJAliTamt,ZYZZJWeiScount,ZYZZJWeiSAmt,ZYZZJWeiTcount,ZYZZJWeiTAmt,MNZYZZJAliScount,MNZYZZJAliSamt,MNZYZZJAliTcount,MNZYZZJAliTamt,MNZYZZJWeiScount,MNZYZZJWeiSAmt,MNZYZZJWeiTcount,MNZYZZJWeiTAmt,MNzzjalisum,MNzzjalinum,MNzzjweisum,MNzzjweinum,zjzfWeiNum,zjzfWeiSum,zjzfAliNum,zjzfAliSum") [ SqlProc ]
{
}

// w ##class(web.RoutineworkD).TranDateFunc("")

ClassMethod TranDateFunc(DateStr) As %String
{
	s Str="2017年3月2日 1:25"
	
	set DateStr=$p(Str," ",1)
	set TimeStr=$p(Str," ",2)
	s Year=$p(DateStr,"年",1)
	s Mon=$p($p(DateStr,"年",2),"月",1)
	s Day=$p($p($p(DateStr,"年",2),"月",2),"日",1)
	s:$L(Mon)=1 Mon="0"_Mon
	s:$L(Day)=1 Day="0"_Day
	set Hour=$p(TimeStr,":",1)
	set Min=$p(TimeStr,":",2)
	set Sec=$p(TimeStr,":",3)
	set:Min="" Min="00"
	set:$L(Min)=1 Min="0"_Min
	set:Hour="" Hour="00"
	set:$L(Hour)=1 Hour="0"_Hour
	set:Sec="" Sec="00"
	set:$L(Sec)=1 Sec="0"_Sec
	
	s rtn=Year_"-"_Mon_"-"_Day_" "_Hour_":"_Min_":"_Sec
	
	
	q rtn
}

// w ##class(web.RoutineworkD).GetBLFee("4038241")

ClassMethod GetBLFee(PB) As %String
{
	s Rowid="",sum=0
	f  s Rowid=$O(^DHCINDIS("0","PBDr",PB,Rowid))  q:Rowid=""  d
	.s Flag=$P(^DHCINDIS(Rowid),"^",18)
	.q:Flag'="N"
	.s INDISINSUXMLB=$P(^DHCINDIS(Rowid),"^",10)
	.q:INDISINSUXMLB'="丙类"
	.s Amount=$P(^DHCINDIS(Rowid),"^",13)
	.s sum=sum+Amount
	
	q sum
}

ClassMethod GetInsuAdmInfo(Adm) As %String
{
	s InsuAdmid="",AdmSerno=""
	
	f  s InsuAdmid=$O(^DHCINADM("0","ADM",Adm,InsuAdmid))  q:InsuAdmid=""  d
	.s AdmFlag=$p(^DHCINADM(InsuAdmid),"^",11)
	.q:AdmFlag'="A"
	.s AdmSerno=$p(^DHCINADM(InsuAdmid),"^",10)
	
	q AdmSerno
}

// w ##class(web.RoutineworkD).GetInsuAdmInfoByPrt("3854337")

ClassMethod GetInsuAdmInfoByPrt(INVPrt) As %String
{
	
	s ConID="",ret=""
	
	f  s ConID=$O(^DHCBCI(0,"INV",INVPrt,ConID))   q:ConID=""  d
	.s Admid=$p(^DHCBCI(ConID),"^",3)
	.s ret=..GetInsuAdmInfo(Admid)
	
	q ret
}

// w ##class(web.RoutineworkD).GetPatDelTime("1591554")

ClassMethod GetPatDelTime(Adm) As %String
{
	
	s delid="",delidsub="",prebabyid="",ret="",BabyDate="",BabyTime=""
	
	f  s delid=$O(^PAPRGi("DEL_Adm_DR",Adm,delid))  q:delid=""   d
	.f  s delidsub=$O(^PAPRGi("DEL_Adm_DR",Adm,delid,"DEL",delidsub))  q:delidsub=""  d
	..f  s prebabyid=$O(^PAPRG(delid,"DEL",delidsub,"BABY",prebabyid))  q:prebabyid=""  d
	...s BabyDate=$zd($p(^PAPRG(delid,"DEL",delidsub,"BABY",prebabyid),"^",13),3)
	...s BabyTime=$zt($p(^PAPRG(delid,"DEL",delidsub,"BABY",prebabyid),"^",49),1)
	
	s ret=BabyDate_" "_BabyTime
	
	
	q ret
}

// w ##class(web.RoutineworkD).GetArcitmprice("4517||1")

ClassMethod GetArcitmprice(ArcimDr) As %String
{
	s PrtDate=+$h
	//^DHCOLT(0,"ARCIM","1003||1","Z",63550,1003) ^DHCOLT(0,"ARCIM",{OLT_ARCIM_DR},{OLT_Inst_DR}_"Z",{OLT_StartDate},{OLT_RowId})
	s amount=0
	s stdate="",sum=0  f  s stdate=$o(^DHCOLT(0,"ARCIM",ArcimDr,"Z",stdate)) q:stdate=""  d
	.s rowid=""  f  s rowid=$o(^DHCOLT(0,"ARCIM",ArcimDr,"Z",stdate,rowid)) q:rowid=""  d
	..s enddate=$p(^DHCOLT(rowid),"^",5)
	..q:enddate'=""
	..s tar=$p(^DHCOLT(rowid),"^",2)
	..s qty=$p(^DHCOLT(rowid),"^",3)
	..s tarsub=""  f  s tarsub=$o(^DHCTARI(tar,"P",tarsub)) q:tarsub=""  d
	...s enddate=$p(^DHCTARI(tar,"P",tarsub),"^",4)
	...q:enddate'=""
	...s StartDate=$p(^DHCTARI(tar,"P",tarsub),"^",3)
	...s price=##class(web.UDHCJFPRICE).GetItmPrice(tar,PrtDate, "1", "1", "", "","")
	...;s qty=$p(^DHCTARI(tar,"P",tarsub),"^",5)
	...s amount=price*qty
	..s sum=sum+amount
	q sum
}

/// 2017-12-15 瑞美需要基础信息表 走kettle传送
/// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","ApplyItem","")
/// call web.RoutineworkD_ApplyItem("")
ClassMethod ApplyItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ApplyItemExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod ApplyItemExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s arcid="0",sub="0"
	
	f  s arcid=$O(^ARCIM(arcid))  q:arcid=""  d
	.f  s sub=$O(^ARCIM(arcid,sub))  q:sub=""    d
	..s ArcItmCat=$p($g(^ARCIM(arcid,sub,1)),"^",10)
	..q:(ArcItmCat="")
	..s ordcatdr=$P( ^ARC("IC",ArcItmCat),"^",7)
	..q:ordcatdr'="L"
	..s Arcitmcode=$p(^ARCIM(arcid,sub,1),"^",1)
	..s Arcitmdesc=$p(^ARCIM(arcid,sub,1),"^",2)
	..s Arcitmprice=..GetArcitmprice(arcid_"||"_sub)
	..s ArcitemCateDesc=$P(^ARC("IC",ArcItmCat),"^",2)
	..s ArcitemLoc="" 
	..;w !,Arcitmcode_"^"_Arcitmdesc_"^"_Arcitmprice
	..d BuildTarCateoutput1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput1   
    ;i Arcitmcode="CWK658"  b
	set Data=$lb(Arcitmcode,Arcitmdesc,Arcitmprice,ArcitemCateDesc,ArcitemLoc)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ApplyItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ApplyItemExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ApplyItem(Input) As %Query(ROWSPEC = "项目代码,项目名称,项目单价,项目归类,执行科室") [ SqlProc ]
{
}

// 科室

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","CTLoc","")

ClassMethod CTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTLocExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod CTLocExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s CTLocID="0"
	
	f  s CTLocID=$O(^CTLOC(CTLocID))  q:CTLocID=""  d
	.s ctloccode=$p(^CTLOC(CTLocID),"^",1)
	.s ctlocdesc=$p(^CTLOC(CTLocID),"^",2)
	
	.d BuildTarCateoutput2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput2    
	set Data=$lb(ctloccode,ctlocdesc,CTLocID)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTLocExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CTLoc(Input) As %Query(ROWSPEC = "科室代码,科室名称,科室code") [ SqlProc ]
{
}

// 病区

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","PACWard","")

ClassMethod PACWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PACWardExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod PACWardExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s PACWardID=""
	b ;123
	f  s PACWardID=$O(^PAWARD(PACWardID))  q:PACWardID=""  d
	.q:+PACWardID=0
	.s PACWardcode=$p(^PAWARD(PACWardID),"^",1)
	.s PACWardid=PACWardID
	.s PACWarddesc=PACWardcode
	.d BuildTarCateoutput3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput3    
	set Data=$lb(PACWardcode,PACWarddesc,PACWardid)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PACWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PACWardExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query PACWard(Input) As %Query(ROWSPEC = "病区代码,病区名称,病区CODE") [ SqlProc ]
{
}

// 临床诊断

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","Diagnosis","")

ClassMethod DiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosisExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod DiagnosisExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DiagnosisID=""
	
	f  s DiagnosisID=$O(^MRC("ID",DiagnosisID))  q:DiagnosisID=""  d
	.q:+DiagnosisID=0
	.s Diagnosiscode=$p( ^MRC("ID",DiagnosisID),"^",1)
	.s Diagnosisdesc=$p( ^MRC("ID",DiagnosisID),"^",2)
	.s DiagnosisICD=$p( ^MRC("ID",DiagnosisID),"^",4)

	.d BuildTarCateoutput4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput4   
	set Data=$lb(Diagnosiscode,Diagnosisdesc,DiagnosisICD)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosisExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query Diagnosis(Input) As %Query(ROWSPEC = "诊断代码,诊断名称,诊断ICD10代码") [ SqlProc ]
{
}

// 医生信息

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","Doctor","")

ClassMethod DoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DoctorExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod DoctorExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DoctorID=""
	f  s DoctorID=$O(^CTPCP(DoctorID))  q:DoctorID=""  d
	.q:+DoctorID=0
	.s Doccode=$p($g(^CTPCP(DoctorID,1)),"^",1)
	.q:Doccode=""
	.s Docdesc=$p($g(^CTPCP(DoctorID,1)),"^",2)
	.s DocTypeID=$p($g(^CTPCP(DoctorID,1)),"^",4)
	.s DocType=$p(^CT("CPT",DocTypeID),"^",1)
	.i DoctorID'="" s idcard=$p($g(^CTPCP(DoctorID,2)),"^",8)
	.q:DocType="实名号别"
	.q:DocType="科室号别"
	.d BuildTarCateoutput5
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput5    
	set Data=$lb(Doccode,Docdesc,DocType,idcard)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DoctorExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","Doctor","")

Query Doctor(Input) As %Query(ROWSPEC = "医生代码,医生姓名,医生类别,身份证号") [ SqlProc ]
{
}

// 收费类型

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","FeeType","")

ClassMethod FeeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FeeTypeExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod FeeTypeExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s FeeTypeID=""
	f  s FeeTypeID=$O(^PAC("ADMREA",FeeTypeID))  q:FeeTypeID=""   d
	.q:+FeeTypeID=0
	.s code=$p(^PAC("ADMREA",FeeTypeID),"^",1)
	.s Desc=$p(^PAC("ADMREA",FeeTypeID),"^",2)	
	.d BuildTarCateoutput6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput6    
	set Data=$lb(code,Desc)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FeeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FeeTypeExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FeeType(Input) As %Query(ROWSPEC = "收费类型代码,收费类型名称") [ SqlProc ]
{
}

// 标本类型

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","Specimen","")

ClassMethod SpecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SpecimenExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod SpecimenExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s SpecimenID=""
	f  s SpecimenID=$O(^TTAB("SPEC",SpecimenID))  q:SpecimenID=""   d
	.s Code=SpecimenID
	.s Desc=$p(^TTAB("SPEC",SpecimenID),"\",1)
	.;s Desc=$p(^PAC("ADMREA",SpecimenID),"^",2)	
	.d BuildTarCateoutput7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput7    
	set Data=$lb(Code,Desc)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SpecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SpecimenExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query Specimen(Input) As %Query(ROWSPEC = "HIS标本类型代码,HIS标本类型名称") [ SqlProc ]
{
}

// 用户

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","SSUSER","")

ClassMethod SSUSERClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SSUSERExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod SSUSERExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s SSUSERID="0"
	f  s SSUSERID=$O(^SSU("SSUSR",SSUSERID))  q:SSUSERID=""   d
	.;w !,SSUSERID
	.;用户代码,用户姓名,用户大类,HIS原始用户代码,医生级别,主任标志,身份证号
	.s LeaderFlag="否"
	.s Usercode=$p(^SSU("SSUSR",SSUSERID),"^",1)
	.;q:Usercode'="1648"
	.s Username=$p(^SSU("SSUSR",SSUSERID),"^",2)
	.s Usertypeid=$p(^SSU("SSUSR",SSUSERID),"^",5)
	.s Usertype=$p(^SSU("SSGRP",Usertypeid),"^",1)
	.q:Usertype=""
	.q:Usertype="自助收费"
	.s ProvID=$p(^SSU("SSUSR",SSUSERID),"^",14)
	.i ProvID'="" s idcard=$p(^CTPCP(ProvID,2),"^",8)  //身份证
	.s ProvType="",UserLevel="",LeaderFlag=""
	.s:ProvID'="" ProvType=$p($g(^CTPCP(ProvID,1)),"^",4)
	.s:ProvType'="" UserLevel=$p( $g(^CT("CPT",ProvType)),"^",1)
	.s LeaderFlag="否"
	.s:(UserLevel["主任")&(UserLevel'["副主任") LeaderFlag="是"
	.d BuildTarCateoutput8
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput8  
	set Data=$lb(Usercode,Username,Usertype,Usercode,UserLevel,LeaderFlag,idcard)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SSUSERFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SSUSERExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query SSUSER(Input) As %Query(ROWSPEC = "用户代码,用户姓名,用户大类,HIS原始用户代码,医生级别,主任标志,身份证号") [ SqlProc ]
{
}

// 用户对应科室

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","UserLinkLoc","")

ClassMethod UserLinkLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UserLinkLocExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod UserLinkLocExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s resourceid=""
	f  s resourceid=$O(^RB("RES",resourceid))  q:resourceid=""  d
	.s Provid=$p(^RB("RES",resourceid),"^",2)
	.s CtLOCID=$p(^RB("RES",resourceid),"^",1)
	.q:Provid=""
	.s UserCode=$p(^CTPCP(Provid,1),"^",1)
	.s DocTypeID=$p($g(^CTPCP(Provid,1)),"^",4)
	.s DocType=$p(^CT("CPT",DocTypeID),"^",1)
	.q:DocType="实名号别"
	.q:DocType="科室号别"
	.s CTloccode=$p(^CTLOC(CtLOCID),"^",1)
	.s WardFlag=$p(^CTLOC(CtLOCID),"^",5)
	.q:WardFlag="Y"
	
	.d BuildTarCateoutput9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput9  
	set Data=$lb(UserCode,CTloccode,CtLOCID)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod UserLinkLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserLinkLocExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query UserLinkLoc(Input) As %Query(ROWSPEC = "用户代码,科室代码,科室code") [ SqlProc ]
{
}

// 用户对应病区

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","UserLinkWard","")

ClassMethod UserLinkWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UserLinkLocExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod UserLinkWardExecute(ByRef qHandle As %Binary, Input) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s resourceid=""
	f  s resourceid=$O(^RB("RES",resourceid))  q:resourceid=""  d
	.s Provid=$p(^RB("RES",resourceid),"^",2)
	.s CtLOCID=$p(^RB("RES",resourceid),"^",1)
	.q:Provid=""
	.s UserCode=$p(^CTPCP(Provid,1),"^",1)
	.s DocTypeID=$p($g(^CTPCP(Provid,1)),"^",4)
	.s DocType=$p(^CT("CPT",DocTypeID),"^",1)
	.q:DocType="实名号别"
	.q:DocType="科室号别"
	.s CTloccode=$p(^CTLOC(CtLOCID),"^",1)
	.s CTlocid=""
	.s CTlocid=$O(^PAWARD(0,"WARD_Code",CTloccode,CTlocid))
	.s WardFlag=$p(^CTLOC(CtLOCID),"^",5)
	.q:WardFlag'="Y"
	
	.d BuildTarCateoutput10
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutput10  
	set Data=$lb(UserCode,CTloccode,CTlocid)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod UserLinkWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserLinkWardExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query UserLinkWard(Input) As %Query(ROWSPEC = "用户代码,病区代码,病区code") [ SqlProc ]
{
}

ClassMethod OEOrditemExec(OEORD, Date, Time, User) As %String
{
}

// w ##class(web.RoutineworkD).CheckUserTPInv("17/12/2017","21/12/2017","2114")

ClassMethod CheckUserTPInv(stDate, endDate, guser) As %String
{
	
	;For PDate=stDate:1:endDate  d  3890322
	s Rtn=0
	b ;s ^tmpCheckUserTPInv=$lb(stDate,endDate,guser)
	
	s SDate=$p(stDate,"/",3)_"-"_$p(stDate,"/",2)_"-"_$p(stDate,"/",1)
	s SDate=$zdh(SDate,3)
	s EDate=$p(endDate,"/",3)_"-"_$p(endDate,"/",2)_"-"_$p(endDate,"/",1)
	s EDate=$zdh(EDate,3)
	s PrtRowID=""
	for PDate=SDate:1:EDate  d
	. For  Set PrtRowID=$Order(^DHCINVPRT(0,"Date",PDate,PrtRowID)) Quit:PrtRowID=""  Do
 	. . Quit:'$Data(^DHCINVPRT(PrtRowID))
 	. . Set InvInfo=$Get(^DHCINVPRT(PrtRowID))
 	. . Set PrtUser=$Piece(InvInfo,"^",21) 
 	. . Set PrtFlag=$Piece(InvInfo,"^",8)
 	. . q:PrtFlag'="TP"
 	. . q:PrtUser'=guser
 	. . s Rtn="-1"
	
	
	q Rtn
}

/// /公众号 预交金报表
/// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","GZHZYDesposit","2017-12-27","2017-12-27")
ClassMethod GZHZYDespositClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GZHZYDespositExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GZHZYDespositExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s WMIPID="",TranSction="",count="",Str="",SUM="",RetStr=""
	;Set repid=$I(^CacheTemp)
	set prtid="",MecCashAmt=0,MecYJKAmt=0,MecCashNum=0,MecYJKNum=0
	set tmpcashsum=0,RMB="",PrtStr=""
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	F iDate=SDate:1:EDate D
	.f  s prtid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",iDate,prtid)) q:prtid=""  d
	..s statue=$p(^DHCSFPRINTDETAIL(prtid),"^",8)
	..q:statue="2"
	..s User=$p(^DHCSFPRINTDETAIL(prtid),"^",20)
	..;s User="2499"
	..q:User'="2611"
	..s username=$p(^SSU("SSUSR",User),"^",2)
	..s payamount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
	..s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
	..s PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",1)
	..s count=count+1
	..s SUM=SUM+payamount
	..if Str="" d
	...s Str=PrtNo
	..else  d
	..s Str=Str_"^"_PrtNo
	..if (count=1) d
	...s RetStr=$tr(Str,"^","--")
	..e  d
	...s RetStr=..GetStarEnd(Str)

	s RMB=##class(web.DHCINSUPort).RMBConvert(SUM)
	d BuildTarCatepatCount1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCatepatCount1  
	set Data=$lb(ind,count,SUM,RetStr,RMB)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GZHZYDespositFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GZHZYDespositExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GZHZYDesposit(SDate, EDate) As %Query(ROWSPEC = "ind,count,SUM,RetStr,RMB") [ SqlProc ]
{
}

// w ##class(web.RoutineworkD).WJ("2017-07-01","2017-07-3")

ClassMethod WJ(SDate, EDate) As %String
{
 s startdate=$zdh(SDate,3)
 s enddate=$zdh(EDate,3)
 k ^tmpstuff
 f date=startdate:1:enddate d
 .s workloadrowid="",sumtotal=0,num=0 f  s workloadrowid=$o(^DHCWorkLoad(0,"ORDDATE",date,workloadrowid))  q:workloadrowid=""  d
 ..s AccCateid=$p(^DHCWorkLoad(workloadrowid),"^",40)
 ..q:((AccCateid="1")||(AccCateid="12")||(AccCateid="13"))
 ..s Catedesc=$p(^DHCTarC("AC",AccCateid),"^",2)
 ..s Price=$p(^DHCWorkLoad(workloadrowid),"^",14)
 ..s Qty=$p(^DHCWorkLoad(workloadrowid),"^",15)
 ..s Amount=$p(^DHCWorkLoad(workloadrowid),"^",16) //总金额
 ..q:Amount=0
 ..s taritemdr=$p(^DHCWorkLoad(workloadrowid),"^",22) //医嘱名称
 ..s ItemDesc=$p(^DHCTARI(taritemdr),"^",2)
 ..s receiveLocdr=$p(^DHCWorkLoad(workloadrowid),"^",1) //接收科室
 ..s Locdesc=$p(^CTLOC(receiveLocdr),"^",1)
 ..s ^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Qty")=$g(^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Qty"))+Qty
 ..s ^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Price")=Price
 ..s ^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Amount")=$g(^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Amount"))+Amount
 q SDate_"~"_EDate
}

// w ##class(web.RoutineworkD).WJ2()

ClassMethod WJ2() As %String
{
 s Itm="",loc="",tarAcCate="",sum=0
 f  s Itm=$O(^tmpstuff(Itm))  q:Itm=""  d
 .f  s loc=$O(^tmpstuff(Itm,loc))  q:loc=""  d
 ..f  s tarAcCate=$O(^tmpstuff(Itm,loc,tarAcCate))  q:tarAcCate=""  d
 ...s Itmcode=$p(^DHCTARI(Itm),"^",1)
 ...s Itmdesc=$p(^DHCTARI(Itm),"^",2)
 ...s:Itm="3257" Itmdesc="血清肌酸激酶－MB同工酶活性测定"
 ...s Qty=$g(^tmpstuff(Itm,loc,tarAcCate,"Qty"))
 ...s Price=$g(^tmpstuff(Itm,loc,tarAcCate,"Price"))
 ...s Amount=$g(^tmpstuff(Itm,loc,tarAcCate,"Amount"))
 ...q:Amount=0
 ...s sum=sum+Amount
 ...s Catedesc=$p(^DHCTarC("AC",loc),"^",2)

 ...s Locdesc=$p(^CTLOC(tarAcCate),"^",1) 
 ...;w !,Itmcode_"^"_Itmdesc_"^"_tarAcCate_"^"_Locdesc_"^"_Qty_"^"_Price_"^"_Amount_"^"_loc_"^"_Catedesc
 ...w !,tarAcCate_"^"_Locdesc_"^"_Itmcode_"^"_Itmdesc_"^"_Price_"^"_Qty_"^"_Amount_"^"_loc_"^"_Catedesc
}

// w ##class(web.RoutineworkD).GetPatNowListNo("妇科门诊","0881","1628176","59849")

ClassMethod GetPatNowListNo(Deptcode, DocCode, Adm, PatTime) As %String
{
	s rtn="未查询到等候排队信息,请至相应分诊台咨询!"
	s ^tmpqueuestacse=$lb(Deptcode,DocCode,Adm,PatTime)
	s LocID="",QueDr="",DHcount="",FZcount="",Flag="",GHFlag="",DocCode=""
	s LocID=$O(^CTLOC(0,"Code",Deptcode,LocID))
	s:DocCode'="" QueDr=$O(^CTPCP(0,"Code",DocCode,QueDr))
	s Papmr=$p(^PAADM(Adm),"^",1)
	s Patno=$P(^PAPER(Papmr,"PAT",1),"^",1)
	For  Set QueDr=$O(^User.DHCQueueI("QueDateDeptIndex",+$H,LocID,QueDr)) Quit:QueDr=""  Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
	.Set QuitFlag=0
	.Set QueStatus=QueObj.QueStateDr.PersName
	.s Quepatno=QueObj.QuePaadmDr.PAADMPAPMIDR.PAPMINo
	.s QueDocCode=QueObj.QueDocDr.CTPCPCode
	.q:(QueDocCode'=DocCode)&(DocCode'="")
	.q:(QueStatus'="等候")&(QueStatus'="复诊")&(QueStatus'="过号")
	.s QueStateTime=QueObj.QueStateTime //所有时间 比病人大的都不算了 小的才算有效

	.q:(PatTime<QueStateTime)&(Quepatno'=Patno)

	.s:(Quepatno=Patno)&(QueStatus="过号") GHFlag="过号"

	.s:QueStatus="等候" DHcount=DHcount+1
	.s:QueStatus="复诊" FZcount=FZcount+1
	
	
	if (DHcount'="")&(FZcount="") {
	s rtn="您前面还有等候病人"_(DHcount-1)_"人"
	}
	if (DHcount="")&(FZcount'="") {
	s rtn="您前面还有复诊病人"_(FZcount-1)_"人"
	}
	if (DHcount'="")&(FZcount'="") {
	s rtn="您前面还有初诊病人"_DHcount_"人,复诊病人"_FZcount_"人"
	}
	if (DHcount="")&(FZcount="") {
	s rtn="未查询到您的排队信息请确认是否报到!"
	}
	if (GHFlag="过号") {
	s rtn="您已过号,请至分诊台重新报到!"
	}
	if (DHcount="1")||(FZcount="1") {
	s rtn="您即将就诊请做好准备,等待呼叫!"
	}
	q rtn
}

// w ##class(web.RoutineworkD).GetFBMZRegFlag()

ClassMethod GetFBMZRegFlag() As %String
{
	s date=+$h
	s WeekDay=$zd(+$h,10)
	s rtn="-1"
	// 周一至周五 上午8~12 下午 14~17
	// 周六 上午8 ~12
	/*w $zth(
	  "08:00:00"  28800
	  "12:00:00"  43200
	  "14:00:00"  50400
	  "17:00:00"  61200
	  	  */
	s CurtTime=$p($h,",",2)
	
	//s CurtTime=$zth("08:59:59",1)
	if WeekDay=0  //星期天不能挂
	{
		b ;0
		q rtn
		
		}
	if (0<WeekDay<6)  //周一至周五
	{
		if (28799<CurtTime)&(CurtTime<43199)
		{
			b ;1-5
			s rtn="0"
		}
		if (50399<CurtTime)&(CurtTime<61199)
		{
			
			s rtn="0"
			
			}
	}
	
	if WeekDay=6  //星期天不能挂
	{
		if (28799<CurtTime<43199)
		{
		b ;6
		s rtn="0"	
			
			}
		
		
		}
	
	
	q rtn
}

// w ##class(web.RoutineworkD).NowpatJM()

ClassMethod NowpatJM() As %String
{
	s ctid="",Date="",Time="",Admid="",Insuid="",i=1
	f  s ctid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid))  q:ctid=""  d
	.f  s Date=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date)) q:Date=""  d
	..f  s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time)) q:Time=""  d
	...f  s Admid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time,Admid)) q:Admid=""  d
	....s Monthid=$p(^PAADM(Admid),"^",75)
	....q:Monthid'=""
	....s wardid=$p(^PAADM(Admid),"^",70)
	....s ctloc=$P(^PAWARD(wardid),"^",1)
	....s Bed=$p(^PAADM(Admid),"^",73)
	....s Insuid=$O(^DHCINADM("0","ADM",Admid,Insuid),-1)
	....q:Insuid=""
	....s InsuType=$p(^DHCINADM(Insuid),"^",18)
	....q:InsuType'="XZFYA"
	....s Pattype=$p(^DHCINADM(Insuid),"^",29)
	....q:Pattype'="JM"
	....s zyno=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Admid)
	....s Center=$p(^DHCINADM(Insuid),"^",8)
	....q:Center'="320399"
	....s papmi=$p(^PAADM(Admid),"^",1)
	....s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
	....s patname=$$GetPapmiName^DHCWLCommon(papmi)
	....s Address=$$GetDetailAddress^DHCWLCommon(papmi)
	....s tel=$p(^PAPER((papmi),"PER",1),"^",11)
	....s IDNO=$p(^PAPER((papmi),"ALL"),"^",9)

	....w !,i_"^"_PatNo_"^"_patname_"^"_zyno_"^"_PatNo_"^"_IDNO_"^"_tel_"^"_Address
	....s i=i+1
}

// w ##class(web.RoutineworkD).UpdateRMLabNo("<Request><OEORDID>1972698||11</OEORDID><LabNo>2801257897</LabNo><User>0357</User><Statue>C</Statue></Request>")

// w ##class(web.RoutineworkD).UpdateRMLabNo("<Request><OEORDID>1972698_11</OEORDID><LabNo>3801090059</LabNo><Statue>Z</Statue></Request>")

ClassMethod UpdateRMLabNo(Input As %String) As %String
{
	Set $ZT="UpdateRMLabNo"
	Set OutputXML=""
	;set ^RMUPdateiput(Input)=""
	Set InputObj=##class(web.RMupdateLabNo.MSG.RMRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set OEORDID=InputObj.OEORDID
    Set LabNo=InputObj.LabNo
    Set Statue=InputObj.Statue
	set User=InputObj.User
	b ;123444
	if Statue="S"  //生成条码
	{
	set Len=$L(OEORDID,"^")
	for i=1:1:Len  d
	.s Oeordid=$p(InputObj.OEORDID,"^",i)
	.s update1=..UPdateExtLabNo(Oeordid) //扩展表 存储HIS原条码号
	.s update2=..UPdateItmLabNo(Oeordid,LabNo) //医嘱表 更新瑞美条码号
	
	q "<ReportMsgReturn><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></ReportMsgReturn>"
	
	}
	elseif Statue="Z" //作废条码
	{
	set Len=$L(OEORDID,"^")
	
	for i=1:1:Len  d
	.s Oeordid=$p(InputObj.OEORDID,"^",i)
	.q:Oeordid=""
	.s update1=..ZFUPdateItmLabNo(Oeordid) //扩展表 存储HIS原条码号
	.s update2=..ZFUPdateExtLabNo(Oeordid) //医嘱表 更新瑞美条码号	
	.s:User'="" execcode=..RMCancleExecOrder(Oeordid,User) //撤销执行
	
	q "<ReportMsgReturn><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></ReportMsgReturn>"
		
	}
	elseif Statue="C" //采样确认 his执行医嘱
	{
	set ret=""
	if (User'="") {
	set Len=$L(OEORDID,"^")
	for i=1:1:Len  d
	.s Oeordid=$p(InputObj.OEORDID,"^",i)
	.s ret=..RMExecOrder(Oeordid,User)
	q "<ReportMsgReturn><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></ReportMsgReturn>"
	}
	
	else
	{
		
	q "<ReportMsgReturn><ResultCode>-2</ResultCode><ResultContent>用户为空</ResultContent></ReportMsgReturn>"
		
	}
	
	}
	else{
		q "<ReportMsgReturn><ResultCode>-1</ResultCode><ResultContent>无法对应的状态</ResultContent></ReportMsgReturn>"
		
	}
	
UpdateRMLabNo
	set outputlist=##class(web.RMupdateLabNo.MSG.RMResponse).%New()
   	Set outputlist.ResultCode=-10
   	Set outputlist.ResultContent="程序处理出错:"_$ZERROR
	s string=""
	;do outputlist.XMLExportToStream(.RpStream,"Response")
	d outputlist.XMLExport(.string,"Response")
 	q string
}

// w ##class(web.RoutineworkD).UPdateExtLabNo("1520674||127")

// 1生成 留存HIS条码号

ClassMethod UPdateExtLabNo(Oeordid) As %String
{
	s Fir=$p(Oeordid,"_",1)
	s Sec=$p(Oeordid,"_",2)
	s ExtLabNo=""
	set OEORDID=Fir_"||"_Sec
	b ;122
	set rtn=""
	s Labno=$p(^OEORD(Fir,"I",Sec,3),"^",20)
	b ;123
	s ExtLabNo=$p($g(^OEORD(Fir,"I",Sec,"DHC")),"^",34)
	b ;111
	if ExtLabNo=""
	{
	&sql(UPDATE OE_OrdItemExt SET OEORI_HISLabEpisodeNo=:Labno WHERE OEORI_RowId=:OEORDID )
	set rtn=SQLCODE
	}
	else
	{
	s rtn=0
		}
	
	q rtn
}

// 2生成 更新瑞美条码号

ClassMethod UPdateItmLabNo(Oeordid, RMlabno) As %String
{
	s Fir=$p(Oeordid,"_",1)
	s Sec=$p(Oeordid,"_",2)
	set OEORDID=Fir_"||"_Sec
	&sql(UPDATE oe_orditem  SET  OEORI_LabEpisodeNo=:RMlabno WHERE OEORI_RowId=:OEORDID )
	q SQLCODE
}

// 作废条码后扩展表字段赋值为空

// 4 w ##class(web.RoutineworkD).ZFUPdateExtLabNo("1520674||85")

ClassMethod ZFUPdateExtLabNo(Oeordid) As %String
{
	s Fir=$p(Oeordid,"_",1)
	s Sec=$p(Oeordid,"_",2)
	s Labno=""
	set OEORDID=Fir_"||"_Sec
	&sql(UPDATE OE_OrdItemExt SET OEORI_HISLabEpisodeNo=:Labno WHERE OEORI_RowId=:OEORDID )
	q SQLCODE
}

// 作废条码后医嘱表字段改成原字段

// 3 d ##class(web.RoutineworkD).ZFUPdateItmLabNo("1520674||85")

ClassMethod ZFUPdateItmLabNo(Oeordid) As %String
{
	s Fir=$p(Oeordid,"_",1)
	s Sec=$p(Oeordid,"_",2)
	set OEORDID=Fir_"||"_Sec
	s HisLab=$p(^OEORD(Fir,"I",Sec,"DHC"),"^",34)
	q:HisLab="" "-1"
	&sql(UPDATE oe_orditem  SET  OEORI_LabEpisodeNo=:HisLab WHERE OEORI_RowId=:OEORDID )
	q SQLCODE
}

// d ##class(web.RoutineworkD).GetNowInpatInfo()

ClassMethod GetNowInpatInfo() As %String
{
	s ctid="",Date="",Time="",Admid=""
	f  s ctid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid))  q:ctid=""  d
	.f  s Date=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date)) q:Date=""  d
	..f  s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time)) q:Time=""  d
	...f  s Admid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time,Admid)) q:Admid=""  d
	....s Monthid=$p(^PAADM(Admid),"^",75)
	....s wardid=$p(^PAADM(Admid),"^",70)
	....s ctloc=$P(^PAWARD(wardid),"^",1)
	....s Bed=$p(^PAADM(Admid),"^",73)
	....q:Monthid'=""
	
	....s papmi=$p(^PAADM(Admid),"^",1)
	....s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
	....s patname=$$GetPapmiName^DHCWLCommon(papmi)
	....s Address=$$GetDetailAddress^DHCWLCommon(papmi)
	....s tel=$p(^PAPER((papmi),"PER",1),"^",11)
	....s IDNO=$p(^PAPER((papmi),"ALL"),"^",9)
	....w !,PatNo_"^"_patname_"^"_tel_"^"_IDNO_"^"_Address
}

// w ##class(web.RoutineworkD).UpdatePatType("398548","3B")

ClassMethod UpdatePatType(AdminfoRowid, PatType, OldType) As %String
{
	
	s ^tmpupdatepat(AdminfoRowid,PatType)=OldType
	;q:AdminfoRowid'="398548" "0"
	&Sql(UPDATE INSU_AdmInfo SET INADM_PatType=:PatType WHERE INADM_Rowid=:AdminfoRowid)
	
	q SQLCODE
}

// DHCENS.REG.BS.REGService.cls  

// w ##class(web.RoutineworkD).JCPayBanlance("<xml><optioncode></optioncode><Password></Password><IdentifyID></IdentifyID><TermNo></TermNo><BgDate>2018-05-29</BgDate><EdDate>2018-05-29</EdDate></xml>")

ClassMethod JCPayBanlance(Input As %String) As %GlobalCharacterStream
{
	Set $zt="JCPayBanlance"
	Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(web.JCSMPay.JCBlanRequest).%New()
	set itemaddobj=##class(web.JCSMPay.JCItemsAddResponse).%New()
	
	set JCFeeOutPutObj=##class(web.JCSMPay.JCBlanResponse).%New()
	set sum=0
    Do inputObj.XMLNodeDeserialize(.inputObj,"xml",Input)
    Set optioncode=inputObj.optioncode
    set Password=inputObj.Password
	Set IdentifyID=inputObj.IdentifyID
    set TermNo=inputObj.TermNo
	Set BgDate=inputObj.BgDate
    set EdDate=inputObj.EdDate

	s:BgDate["-" BgDate=$zdh(BgDate,3)
	s:EdDate["-" EdDate=$zdh(EdDate,3)
	s ind=1,JCPayid="",TradeNo="",ALISum=0,WEIXINSum=0
	
	/*For PDate=BgDate:1:EdDate Do
	.Set PrtRowID=""
 	.For  Set PrtRowID=$Order(^DHCINVPRT(0,"Date",PDate,PrtRowID)) Quit:PrtRowID=""  Do
 	..Set InvInfo=$Get(^DHCINVPRT(PrtRowID))
 	..Set PrtFairType=$Piece(InvInfo,"^",34)       //PRT_FairType(F:收费, R:挂号)
	..Set PrtUser=$Piece(InvInfo,"^",21) 
	..set PrtFlag=$Piece(InvInfo,"^",8)
	..s PayModeID=""
	..f  set PayModeID=$O(^DHCINVPRT(PrtRowID,"P",PayModeID))  q:PayModeID=""  d
	...set PayModeDr=$p(^DHCINVPRT(PrtRowID,"P",PayModeID),"^",1)
	...q:(PayModeDr'="36")&(PayModeDr'="37")
	...set InvNO=$Piece(InvInfo,"^",14)
	...if PrtFairType="F" d
	....set JCPayid=$O(^JCWAPayINVi("INVPRT",PrtRowID,JCPayid))
	....set:JCPayid'="" TradeNo=$p(^JCWeiAliPayO(JCPayid),"^",9)
	...if PrtFairType="R" d
	....set JCPayid=$O(^JCRegRecordINVi("INV",PrtRowID,JCPayid))
	....set:JCPayid'="" TradeNo=$p(^JCRegRecordO(JCPayid),"^",10)
	
	...set ORDERDATE=$zd($Piece(InvInfo,"^",5),3)
	...set ORDERTIME=$zt($Piece(InvInfo,"^",20),1) //shijian
	...set papmi=$Piece(InvInfo,"^",15)
	...set PatObj=##class(web.DHCENS.Method.PatInfo).PatInfo(papmi)
	...set patname=PatObj.PatientName
	...set patcard=PatObj.CardNo
	...set patienid=PatObj.RegisterNo 
	...set Amount=$Piece(InvInfo,"^",1)
	...set sum=sum+Amount
	...set Flag=$Piece(InvInfo,"^",8)
	...set User=$Piece(InvInfo,"^",21)
	...set PAYNAME=patname_"的门诊费用"
	...set COST=Amount
	...set outputlist=##class(web.JCSMPay.JCBlanList).%New()
	...set outputlist.ID=ind
	...set outputlist.RCPTNO=PrtRowID
	...set outputlist.INVOICEID=InvNO
	...set outputlist.ORDERID=TradeNo
	
	...set outputlist.ORDERDATE=ORDERDATE
	...set outputlist.ORDERTIME=ORDERTIME
	...set outputlist.ORDERID=TradeNo
	...set outputlist.PAYNAME=PAYNAME
	...set outputlist.COST=Amount
	...set:Flag="N" outputlist.STATUS="收费"
	...set:Flag="B" outputlist.STATUS="收费"
	...set:Flag="S" outputlist.STATUS="退费"
	...set outputlist.CARDNO=patcard
	...set outputlist.PATIENTID=patienid
	...set outputlist.PATIENTNAME=patname
	...set:PayModeDr="36" outputlist.PAYTYPE="支付宝"
	...set:PayModeDr="37" outputlist.PAYTYPE="微信"
	...set outputlist.SYSTEMID="his"
	...set:PrtFairType="R" outputlist.SYSTEMTYPE="挂号"
	...set:PrtFairType="F" outputlist.SYSTEMTYPE="门诊窗口缴费"
	...set outputlist.DISTRICT="徐州市妇幼保健院"
	...set outputlist.PAYACCOUNT=""
	...set outputlist.OPERATEID=User
	...set outputlist.DEVICEID=""
	...set outputlist.REMARKS=""
	...set ind=ind+1
	...Do JCFeeOutPutObj.Item.Insert(outputlist)
	...Do JCFeeOutPutObj.%Close() 
	
	set JCRecid="",prtid=""
	F iDate=BgDate:1:EdDate D
	.f  s prtid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",iDate,prtid)) q:prtid=""  d
	..s statue=$p(^DHCSFPRINTDETAIL(prtid),"^",8)
	..q:statue="2"
	..s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
	..q:(paymode'=36)&(paymode'=37)
	..s payamount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
	..set sum=sum+payamount
	..s PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",1)
	..s Adm=$p(^DHCSFPRINTDETAIL(prtid),"^",4)
	..s papmi=$p(^PAADM(Adm),"^",1)
	..set PatObj=##class(web.DHCENS.Method.PatInfo).PatInfo(papmi)
	..set patname=PatObj.PatientName
	..set patcard=PatObj.CardNo
	..set patienid=PatObj.RegisterNo 
	..set paydate=$zd($p(^DHCSFPRINTDETAIL(prtid),"^",2),3)
	..set paytime=$zt($p(^DHCSFPRINTDETAIL(prtid),"^",3),1)
	..set Userid=$p(^DHCSFPRINTDETAIL(prtid),"^",20)
	..set outputlist=##class(web.JCSMPay.JCBlanList).%New()
	..set outputlist.ID=ind
	..set outputlist.RCPTNO=prtid
	..set outputlist.INVOICEID=PrtNo
	..set JCRecid=$O(^JCReceiptHisIDi("Reptid",PrtNo,JCRecid))
	..set:JCRecid'="" OrdNo=$p(^JCReceiptO(JCRecid),"^",9)
	..set outputlist.ORDERID=OrdNo
	..set outputlist.ORDERDATE=paydate
	..set outputlist.ORDERTIME=paytime
	..set outputlist.PAYNAME=patname_"的住院押金"
	..set outputlist.COST=payamount
	..set:statue="1" outputlist.STATUS="收费"
	..set:statue="4" outputlist.STATUS="收费"
	..set:statue="3" outputlist.STATUS="退费"
	..set outputlist.CARDNO=patcard
	..set outputlist.PATIENTID=PatObj.RegisterNo 
	..set outputlist.PATIENTNAME=patname
	..set:paymode="36" outputlist.PAYTYPE="支付宝"
	..set:paymode="37" outputlist.PAYTYPE="微信"
	..set outputlist.SYSTEMID="his"
	..set outputlist.SYSTEMTYPE="住院预交金"
	
	..set outputlist.DISTRICT="徐州市妇幼保健院"
	..set outputlist.PAYACCOUNT=""
	..set outputlist.OPERATEID=Userid
	..set outputlist.DEVICEID=""
	..set outputlist.REMARKS=""
	..set ind=ind+1
	..Do JCFeeOutPutObj.Item.Insert(outputlist)
	..Do JCFeeOutPutObj.%Close()
	set JCFeeOutPutObj.resultCode=1
	set JCFeeOutPutObj.resultDesc="成功"
	do JCFeeOutPutObj.XMLExportToStream(.RpStream,"xml")
	;d outputlist.XMLExport(.string)
	d JCFeeOutPutObj.%Close()
	;w !,string
 	q RpStream
 	;set xml=""
	;set tStatus=JCFeeOutPutObj.XMLExportToString(.xml)
	;q xml */
	For PDate=BgDate:1:EdDate Do
	.Set PrtRowID=""
 	.For  Set PrtRowID=$Order(^DHCINVPRT(0,"Date",PDate,PrtRowID)) Quit:PrtRowID=""  Do
 	..Set InvInfo=$Get(^DHCINVPRT(PrtRowID))
 	..Set PrtFairType=$Piece(InvInfo,"^",34)       //PRT_FairType(F:收费, R:挂号)
	..Set PrtUser=$Piece(InvInfo,"^",21) 
	..set PrtFlag=$Piece(InvInfo,"^",8)
	..set Papmi=$Piece(InvInfo,"^",15)
	..q:PrtRowID'="4634965"
	..;q:Papmi'="62035"
	..s PayModeID=""
	..f  set PayModeID=$O(^DHCINVPRT(PrtRowID,"P",PayModeID))  q:PayModeID=""  d
	...set PayModeDr=$p(^DHCINVPRT(PrtRowID,"P",PayModeID),"^",1)
	...;q:PrtRowID'="4039015"
	...q:(PayModeDr'="36")&(PayModeDr'="37")
	...set InvNO=$Piece(InvInfo,"^",14)
	
	...set ORDERDATE=$zd($Piece(InvInfo,"^",5),3)
	...set ORDERTIME=$zt($Piece(InvInfo,"^",20),1) //shijian
	...set papmi=$Piece(InvInfo,"^",15)
	...set PatObj=##class(web.DHCENS.Method.PatInfo).PatInfo(papmi)
	...set patname=PatObj.PatientName
	...;q:patname'="王禹泽"
	...set patcard=PatObj.CardNo
	...set patienid=PatObj.RegisterNo 
	...;q:patienid'="0000453738"
	...;w !,PrtRowID_" "_JCPayid_"  "_TradeNo
	...set Amount=$Piece(InvInfo,"^",1)
	...set sum=sum+Amount
	...set Flag=$Piece(InvInfo,"^",8)
	...set User=$Piece(InvInfo,"^",21)
	...;q:User'="2447"
	...set PAYNAME=patname_"的门诊费用"
	...set COST=Amount
	...set JCoutputlist=##class(web.JCSMPay.JCBlanList).%New()
	...set JCoutputlist.ID=ind
	...set JCoutputlist.RCPTNO=PrtRowID
	...set JCoutputlist.INVOICEID=InvNO
	...set JCoutputlist.ORDERID=TradeNo
	
	...set JCoutputlist.ORDERDATE=ORDERDATE
	...set JCoutputlist.ORDERTIME=ORDERTIME
	...set JCoutputlist.ORDERID=..GetJCPayTradeNo(PrtRowID,PrtFairType)
	...set JCoutputlist.PAYNAME=PAYNAME
	...set JCoutputlist.COST=Amount
	...set:Flag="N" JCoutputlist.STATUS="收费"
	...set:(Flag="B")&(Amount>0) JCoutputlist.STATUS="收费"
	...set:(Flag="B")&(Amount<0) JCoutputlist.STATUS="退费"
	...set:(Flag="S")&(Amount>0) JCoutputlist.STATUS="收费"
	...set:(Flag="S")&(Amount<0) JCoutputlist.STATUS="退费"
	...set:(Flag="A")&(Amount>0) JCoutputlist.STATUS="收费"
	...set:(Flag="A")&(Amount<0) JCoutputlist.STATUS="退费"
	...set JCoutputlist.CARDNO=patcard
	...set JCoutputlist.PATIENTID=patienid
	...set JCoutputlist.PATIENTNAME=patname
	...set:PayModeDr="36" JCoutputlist.PAYTYPE="支付宝",ALISum=ALISum+Amount
	...set:PayModeDr="37" JCoutputlist.PAYTYPE="微信",WEIXINSum=WEIXINSum+Amount
	...set JCoutputlist.SYSTEMID="his"
	...set:PrtFairType="R" JCoutputlist.SYSTEMTYPE="挂号"
	...set:PrtFairType="F" JCoutputlist.SYSTEMTYPE="门诊窗口缴费"
	...set JCoutputlist.DISTRICT="徐州市妇幼保健院"
	...set JCoutputlist.PAYACCOUNT=""
	...set JCoutputlist.OPERATEID=User
	...set JCoutputlist.DEVICEID=""
	...set JCoutputlist.REMARKS=""
	...;w !,PrtRowID
	...set ind=ind+1
	...Do itemaddobj.Item.Insert(JCoutputlist)
	...Do itemaddobj.%Close()
	Do JCFeeOutPutObj.Items.Insert(itemaddobj)
	Do itemaddobj.%Close()
	
		//w !,ALISum_"  "_WEIXINSum,!
		
	/*set ZYitemaddobj=##class(web.JCSMPay.JCItemsAddResponse).%New()
	set JCRecid="",prtid=""
	F iDate=BgDate:1:EdDate D
	.f  s prtid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",iDate,prtid)) q:prtid=""  d
	..s statue=$p(^DHCSFPRINTDETAIL(prtid),"^",8)
	..q:statue="2"
	..s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
	..q:(paymode'=36)&(paymode'=37)
	..s payamount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
	..set sum=sum+payamount
	..s PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",1)
	..s Adm=$p(^DHCSFPRINTDETAIL(prtid),"^",4)
	..s papmi=$p(^PAADM(Adm),"^",1)
	..set PatObj=##class(web.DHCENS.Method.PatInfo).PatInfo(papmi)
	..set patname=PatObj.PatientName
	..set patcard=PatObj.CardNo
	..set patienid=PatObj.RegisterNo 
	..set paydate=$zd($p(^DHCSFPRINTDETAIL(prtid),"^",2),3)
	..set paytime=$zt($p(^DHCSFPRINTDETAIL(prtid),"^",3),1)
	..set Userid=$p(^DHCSFPRINTDETAIL(prtid),"^",20)
	..set outputlist=##class(web.JCSMPay.JCBlanList).%New()
	..set outputlist.ID=ind
	..set outputlist.RCPTNO=prtid
	..set outputlist.INVOICEID=PrtNo
	..;set:PrtNo="" PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",7)
	..if PrtNo'="" d
	...set JCRecid=$O(^JCReceiptHisIDi("Reptid",PrtNo,JCRecid))
	...set:JCRecid'="" OrdNo=$p(^JCReceiptO(JCRecid),"^",9)
	...set outputlist.ORDERID=OrdNo
	...set outputlist.ORDERDATE=paydate
	...set outputlist.ORDERTIME=paytime
	...set outputlist.PAYNAME=patname_"的住院押金"
	...set outputlist.COST=payamount
	..else  d
	...set PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",7)
	...set JCRecid=$O(^JCReceiptHisIDi("Reptid",PrtNo,JCRecid))
	...set:JCRecid'="" OrdNo=$p(^JCReceiptO(JCRecid),"^",9)
	...set outputlist.ORDERID=OrdNo
	...set outputlist.ORDERDATE=paydate
	...set outputlist.ORDERTIME=paytime
	...set outputlist.PAYNAME=patname_"的住院押金"
	...set outputlist.COST=payamount
	..set:statue="1" outputlist.STATUS="收费"
	..set:statue="4" outputlist.STATUS="收费"
	..set:statue="3" outputlist.STATUS="退费"
	..set outputlist.CARDNO=patcard
	..set outputlist.PATIENTID=PatObj.RegisterNo 
	..set outputlist.PATIENTNAME=patname
	..set:paymode="36" outputlist.PAYTYPE="支付宝",ALISum=ALISum+payamount
	..set:paymode="37" outputlist.PAYTYPE="微信",WEIXINSum=WEIXINSum+payamount
	..set outputlist.SYSTEMID="his"
	..set outputlist.SYSTEMTYPE="住院预交金"
	
	..set outputlist.DISTRICT="徐州市妇幼保健院"
	..set outputlist.PAYACCOUNT=""
	..set outputlist.OPERATEID=Userid
	..set outputlist.DEVICEID=""
	..set outputlist.REMARKS=""
	..set ind=ind+1
	..Do ZYitemaddobj.Item.Insert(outputlist)
	..;Do ZYitemaddobj.%Close() 
	Do JCFeeOutPutObj.Items.Insert(ZYitemaddobj)
	Do itemaddobj.%Close()*/
	set JCFeeOutPutObj.resultCode=1
	set JCFeeOutPutObj.resultDesc="成功"
	do JCFeeOutPutObj.XMLExportToStream(.RpStream,"xml")
	;d outputlist.XMLExport(.string)
	d JCFeeOutPutObj.%Close()
	;w !,string
	;w !,ALISum_"  "_WEIXINSum,!
 	q RpStream
 	
JCPayBanlance
	
	set JCFeeOutPutObj=##class(web.JCSMPay.JCBlanResponse).%New()
	Set JCFeeOutPutObj.resultCode=-10
   	Set JCFeeOutPutObj.resultDesc="程序处理出错:"_$ZERROR
	s RpStream=""
	do JCFeeOutPutObj.XMLExportToStream(.RpStream,"xml")
	;d outputlist.XMLExport(.string)
	d JCFeeOutPutObj.%Close()
	;w !,string
 	q RpStream
 	;set xml=""
	;set tStatus=JCFeeOutPutObj.XMLExportToString(.xml)
	;q xml
}

ClassMethod CancleOrderCheck(JSPayCode, OrderNo) As %String
{
	s jcpaid="",ret=""
	if $d(^JCWAPayOrderNOi("OrderNO",OrderNo))  //假如存在订单号
	{
	s jcpaid=$O(^JCWAPayOrderNOi("OrderNO",OrderNo,jcpaid))
	s Invprt=$p(^JCWeiAliPayO(jcpaid),"^",5)
	s Paymode=$p(^JCWeiAliPayO(jcpaid),"^",7) //支付方式
	s:Paymode="36" PayModeDesc="inapay_alipay_micropay "
	s:Paymode="37" PayModeDesc="inapay_weixin_micropay"
	if $d(^DHCINVPRT(Invprt)) //如果发票表有记录不可 -1
	{
		q "存在有效发票记录无法直接退费!请联系管理人员!"
		
		}
	else  //发票表无记录 可退  0
	{
		
	s ret=..CancleOrderExc(Paymode,OrderNo)
	q ret
		}	
		}
	else  //不存在订单号 直接取消 但是支付方式怎么取呢  0
	{
		
	s ret=..CancleOrderExc(JSPayCode,OrderNo)
	q ret 
		
		}
}

ClassMethod CancleOrderExc(PayMode, OrdNo) As %String
{
	set IPAddress="172.16.26.253"
	set PayMode=""
	set canclexml=##class(JCPay.JCPayGetXML).CancleOrder(IPAddress,PayMode,outtradeno)
	
	set outcancle=##class(web.Routinework).CancleOrder(canclexml)	
	
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(outcancle)
	Do reader.Correlate("response","web.JCSMPay.CancleOrdRp")	 //入参解析
    set objInputRt=##class(web.JCSMPay.CancleOrdRp).%New()
	While reader.Next(.Obj,.sc) {
		 set objInputRt=Obj
	}
	set code=objInputRt.code //代码
	
	
	if code="0000"
}

ClassMethod GetRC() As %String
{
}

ClassMethod GetHLJB(Adm) As %String
{
	s oeordid="",rtn=0
	s oeordid=$O(^OEORD(0,"Adm",Adm,oeordid))
	q:oeordid="" 0
	s sub=""
	f  s sub=$O(^OEORD(oeordid,"I",sub))  q:sub=""  d
	.q:sub=0
	.s arcitem=$P(^OEORD(oeordid,"I",sub,1),"^",2)
	.q:(arcitem'="3979||1")&(arcitem'="3980||1")&(arcitem'="3981||1")
	.s:arcitem="3979||1" rtn="1"
	.s:arcitem="3980||1" rtn="2"
	.s:arcitem="3981||1" rtn="3"
	
	q rtn
}

// w ##class(web.RoutineworkD).OrdItmRowId("333828||51")

ClassMethod OrdItmRowId(OEORDItem) As %String
{
	
	s First=$p(OEORDItem,"||",1)
	s Admid=$p(^OEORD(First),"^",1)
	s AdmType=$p(^PAADM(Admid),"^",2)
	q:AdmType'="I" "0"
	s Secon=$p(OEORDItem,"||",2)
 	s ArcItm=$P(^OEORD(First,"I",Secon,1),"^",2)	
 	s ItmID=$p(ArcItm,"||",1)
 	s ItmSub=$p(ArcItm,"||",2)
 	s ArcCate=$p(^ARCIM(ItmID,ItmSub,1),"^",10)
 	s ExecCate=$p(^ARC("IC",ArcCate),"^",9)
 	q:ExecCate'="2" "0"
 	s Labno=$p(^OEORD(First,"I",Secon,3),"^",20)
	q:Labno="" "0"
	s ExtLabNo=$p($g(^OEORD(First,"I",Secon,"DHC")),"^",34)
	q:ExtLabNo="" "0"
	q "-1"
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","InpatNumfor","2015-10-01","2015-10-01","" )

/// /病案室要一个能够统计出院人数的明细报表 可以用来看需要哪些病人的病历
ClassMethod InpatNumforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InpatNumforExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod InpatNumforExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;n (SDate,EDate)
	s jzksID="",jzks="",jzbqID="",jzbq="",jsys="",jsysID="",patmasrow="",cs="",DischgDate="",date1="",date2="",iDate=""
	;k ^TMPwang("JZks")
	;Set repid=$I(^CacheTemp)
 s outyear=$p(SDate,"-",1)_"."_$p(SDate,"-",2)
	s admrowid=""
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)

 k ^tmpstuff
 f date=SDate:1:EDate d
 .s workloadrowid="",sumtotal=0,num=0 f  s workloadrowid=$o(^DHCWorkLoad(0,"ORDDATE",date,workloadrowid))  q:workloadrowid=""  d
 ..s AccCateid=$p(^DHCWorkLoad(workloadrowid),"^",40)
 ..s AdmType=$p(^DHCWorkLoad(workloadrowid),"^",4)
 ..q:(AdmType'=ctcareprov)&(ctcareprov'="NULL")
 ..q:((AccCateid="1")||(AccCateid="12")||(AccCateid="13"))
 ..s Catedesc=$p(^DHCTarC("AC",AccCateid),"^",2)
 ..s Price=$p(^DHCWorkLoad(workloadrowid),"^",14)
 ..s Qty=$p(^DHCWorkLoad(workloadrowid),"^",15)
 ..s Amount=$p(^DHCWorkLoad(workloadrowid),"^",16) //总金额
 ..q:Amount=0
 ..s taritemdr=$p(^DHCWorkLoad(workloadrowid),"^",22) //医嘱名称
 ..s ItemDesc=$p(^DHCTARI(taritemdr),"^",2)
 ..s receiveLocdr=$p(^DHCWorkLoad(workloadrowid),"^",1) //接收科室
 ..s Locdesc=$p(^CTLOC(receiveLocdr),"^",1)
 ..s ^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Qty")=$g(^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Qty"))+Qty
 ..s ^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Price")=Price
 ..s ^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Amount")=$g(^tmpstuff(taritemdr,AccCateid,receiveLocdr,"Amount"))+Amount


 s Itm="",loc="",tarAcCate="",sum=0
 f  s Itm=$O(^tmpstuff(Itm))  q:Itm=""  d
 .f  s loc=$O(^tmpstuff(Itm,loc))  q:loc=""  d
 ..f  s tarAcCate=$O(^tmpstuff(Itm,loc,tarAcCate))  q:tarAcCate=""  d
 ...s Itmcode=$p(^DHCTARI(Itm),"^",1)
 ...s Itmdesc=$p(^DHCTARI(Itm),"^",2)
 ...s:Itm="3257" Itmdesc="血清肌酸激酶－MB同工酶活性测定"
 ...s Qty=$g(^tmpstuff(Itm,loc,tarAcCate,"Qty"))
 ...s Price=$g(^tmpstuff(Itm,loc,tarAcCate,"Price"))
 ...s Amount=$g(^tmpstuff(Itm,loc,tarAcCate,"Amount"))
 ...q:Amount=0
 ...s sum=sum+Amount
 ...s Catedesc=$p(^DHCTarC("AC",loc),"^",2)

 ...s Locdesc=$p(^CTLOC(tarAcCate),"^",1) 
 ...;w !,Itmcode_"^"_Itmdesc_"^"_tarAcCate_"^"_Locdesc_"^"_Qty_"^"_Price_"^"_Amount_"^"_loc_"^"_Catedesc
 ...;w !,tarAcCate_"^"_Locdesc_"^"_Itmcode_"^"_Itmdesc_"^"_Price_"^"_Qty_"^"_Amount_"^"_loc_"^"_Catedesc

    ...d BuildTarCate
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCate   
	set Data=$lb(ind,outyear,tarAcCate,Locdesc,Itmcode,Itmdesc,Price,Qty,Amount,loc,Catedesc)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InpatNumforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InpatNumforExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query InpatNumfor(SDate, EDate, ctcareprov) As %Query(ROWSPEC = "ind,outyear,tarAcCate,Locdesc,Itmcode,Itmdesc,Price,Qty,Amount,loc,Catedesc") [ SqlProc ]
{
}

/// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","OutPatFee","2021-07-15","2021-07-15","" )
/// call web.RoutineworkD_OutPatFee("2020-11-17","2020-11-17","")
/// /病案室要一个能够统计出院人数的明细报表 可以用来看需要哪些病人的病历
ClassMethod OutPatFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OutPatFeeExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod OutPatFeeExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;n (SDate,EDate)
	s jzksID="",jzks="",jzbqID="",jzbq="",jsys="",jsysID="",patmasrow="",cs="",DischgDate="",date1="",date2="",iDate=""
	k ^TMPwang("JZks",$j)
	;Set repid=$I(^CacheTemp)
	s admrowid=""
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	F iDate=SDate:1:EDate D
	.;w !,iDate
	.f  s admrowid=$o(^PAADMi("DischDate",iDate,admrowid))  q:admrowid=""  d 
	..;w !, admrowid
	..s brtype=$P(^PAADM(admrowid),"^",2)
	..q:brtype'="I"    

	..;q:((DischgDate<SDate)||(DischgDate>EDate))

	..s jzksID=$P(^PAADM(admrowid),"^",4)       ;就诊科室
	..s jzks=$p(^CTLOC(jzksID),"^",2)
	..Set ^TMPwang("JZks",$j,jzks)=$g(^TMPwang("JZks",$j,jzks))_"^"_admrowid
	 ;zw ^TMPwang
	s paadm="",ksid="",int="",adm=""
	F  S ksid=$O(^TMPwang("JZks",$j,ksid))  Quit:ksid=""  Do
    .;w !,"科室名称节点"_ksid
    .q:(ksid'=ctcareprov)&&(ctcareprov'="NULL")&&(ctcareprov'="")
    .s Len=$l(^TMPwang("JZks",$j,ksid),"^")
    .;w !,Len_"长度"
    .f int=1:1:Len d
    ..S adm=$p(^TMPwang("JZks",$j,ksid),"^",int)
    ..;w !,adm_"#"_"adm"
    ..q:adm=""
    ..s inpayid=""
    ..s inpayid=$o(^DHCINDIV("0","Paadm",adm,inpayid))
    ..s insuadminfo="",sfz="",insutype="",admserno="",djlsh=""
    ..i inpayid'="" d
    ...s insuadminfo=$p(^DHCINDIV(inpayid),"^",2)
    ...s sfz=$p(^DHCINADM(insuadminfo),"^",34)  //身份证
    ...s insutype=$p(^DHCINADM(insuadminfo),"^",18)
    ...s admserno=$p(^DHCINADM(insuadminfo),"^",10)  //住院流水号
    ...s djlsh=$p(^DHCINDIV(inpayid),"^",8)   //结算流水号
    ..s Zyno=##class(web.DHCWMRService).IGetMrNoByEpisodeID(adm)  
    ..s Diagnos=##class(web.Routinework).GetDiagnosICDandDesc($p($g(^PAADM(adm)),"^",61))
 	..s:Diagnos["^" Diagnos=$tr(Diagnos,"^"," ") 
    ..q:((Zyno["A")||(Zyno["B")||(Zyno["C")||(Zyno["D")||(Zyno["E"))
    ..s patmasrow=$p(^PAADM(adm),"^",1)
	..s patname=$p(^PAPER((patmasrow),"ALL"),"^",1)
	..;w !,ksid_patname_Zyno
	..s jzdate=$P(^PAADM(adm),"^",6)     ;就诊日期
	..s DischgDate=$P(^PAADM(adm),"^",17)   ;出院日期
	..q:DischgDate=""
	..s date1=$zd(jzdate,3)
	..;w !,jzdate_"  "_date1
	..s date2=$zd(DischgDate,3)
	..s cs=0,Coum=0
	..s return=##class(web.DHCBillInterface).IGetTarItemCate(adm,"","TAC","")
	..s (InitPList1, InitPList2, InitPList3,InitPList4,InitPList5,InitPList6,InitPList7,InitPList8,InitPList9,InitPList10,InitPList11,InitPList12,InitPList13,InitPList14)=0
	..f tmp=1:1:$l(return,"!")  d
	...s Itemtmp=$p(return,"!",tmp)
 	...s Id=$p($g(Itemtmp),"^",1)
 	...s xm=$p($g(Itemtmp),"^",2)
 	...s Coum=$p($g(Itemtmp),"^",4)
 	...s:(Id=1) InitPList1=InitPList1+Coum
	...s:(Id=2) InitPList2=InitPList2+Coum
	...s:(Id=3) InitPList3=InitPList3+Coum
	...s:(Id=4) InitPList4=InitPList4+Coum
	...s:(Id=5) InitPList5=InitPList5+Coum
	...s:(Id=6) InitPList6=InitPList6+Coum
	...s:(Id=7) InitPList7=InitPList7+Coum
	...s:(Id=8) InitPList8=InitPList8+Coum
	...s:(Id=9) InitPList9=InitPList9+Coum
	...s:(Id=10) InitPList10=InitPList10+Coum
	...s:(Id=11) InitPList11=InitPList11+Coum
	...s:(Id=12) InitPList12=InitPList12+Coum
	...s:(Id=13) InitPList13=InitPList13+Coum
	...s:(Id=14) InitPList14=InitPList14+Coum
	...s total=InitPList1+ InitPList2+ InitPList3+InitPList4+InitPList5+InitPList6+InitPList7+InitPList8+InitPList9+InitPList10+InitPList11+InitPList12+InitPList13+InitPList14
	
	..;s PBFee=##class(web.RoutineworkC).GetPBfeeByAdm(adm)
    ..d BuildTarCateoutpat
    k ^TMPwang("JZks",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateoutpat  
	set Data=$lb(ind,ksid,patname,Zyno,date1,date2,total,Diagnos,InitPList1, InitPList2, InitPList3,InitPList4,InitPList5,InitPList6,InitPList7,InitPList8,InitPList9,InitPList10,InitPList11,InitPList12,InitPList13,InitPList14,sfz,admserno,djlsh)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OutPatFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OutPatFeeExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query OutPatFee(SDate, EDate, ctcareprov) As %Query(ROWSPEC = "ind,ksid,patname,Zyno,date1,date2,PBFee,Diagnos,InitPList1,InitPList2,InitPList3,InitPList4,InitPList5,InitPList6,InitPList7,InitPList8,InitPList9,InitPList10,InitPList11,InitPList12,InitPList13,InitPList14,sfz,admserno,djlsh") [ SqlProc ]
{
}

// W ##CLASS(web.RoutineworkD).GetIPPatinfoByLoc("<Request><DepartmentID>245</DepartmentID></Request>")

ClassMethod GetIPPatinfoByLoc(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="GetIPPatinfoByLoc"
	S ^tempggm=$lb(Input)
	Set OutputXML=""
	k ^tmprmqikui
	Set InputObj=##class(web.RMupdateLabNo.MSG.RMBloodRequest).%New()
	set outputobj=##class(web.RMupdateLabNo.MSG.RMBloodResponse).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set DepartmentID=InputObj.DepartmentID
  	s ctid="",Date="",Time="",Admid=""
	f  s ctid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid))  q:ctid=""  d
	.q:(ctid'=DepartmentID)&(DepartmentID'="")
	.f  s Date=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date)) q:Date=""  d
	..f  s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time)) q:Time=""  d
	...f  s Admid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time,Admid)) q:Admid=""  d
	....s Monthid=$p(^PAADM(Admid),"^",75)
	....q:Monthid'=""
	....;q:Admid'="1710922"
	....s BedID=$p( ^PAADM(Admid),"^",73) 
	....s:BedID'="" Ward=$p(BedID,"||",1)
	....s:BedID'="" Bedsub=$p(BedID,"||",2)
	....s:BedID'="" BedNO=$p(^PAWARD(Ward,"BED",Bedsub),"^",1)
	....s:BedID="" BedNO=Admid
	....s ^tmprmqikui($j,BedNO)=Admid
	
	S BedNOData=""
	
	f  s BedNOData=$O(^tmprmqikui($j,BedNOData))  q:BedNOData=""  d
	.s Admid=$g(^tmprmqikui($j,BedNOData))
	.s outlistObj=##class(web.RMupdateLabNo.MSG.RMBloodPatinfo).%New()
	.;w !,BedNOData
	.s PapmiDr=$p(^PAADM(Admid),"^",1)
	.s PatObj=##class(web.DHCENS.Method.PatInfo).PatInfo(PapmiDr) 
	.s AdmObj=##class(web.DHCENS.Method.AdmInfo).AdmInfo(Admid)
	.s outlistObj.hospitalcode=""
	.s outlistObj.patno=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Admid) //病人号/就诊号，门诊为门诊号住院为住院号（习惯号码）
	.s outlistObj.patid=PatObj.RegisterNo // 3. pat_id 病人唯一号  内部的唯一号，接病人id比较时使用
    .s outlistObj.patcardno=PatObj.CardNo //4. pat_cardno 就诊卡号
    .s outlistObj.inpid=Admid //5. inp_id 住院标识  用于区分同一住院号多次住院，门诊用于保存就诊序号
    .s outlistObj.inpdate=AdmObj.AdmDate //入院日期(针对住院病人)
    .s outlistObj.patname=PatObj.PatientName // 病人姓名
    .s outlistObj.patsex= PatObj.SexRowID 
    .s outlistObj.patbirth=PatObj.BirthDay //生日
    .s outlistObj.patagestr=PatObj.Age
    .s outlistObj.pattypecode=3 //病人类型  1＝门诊，2＝急诊，3＝住院，4＝体检，等
    .s Admreasondr=$p(^PAADM(Admid,1),"^",7)
    .s outlistObj.chargetypeno=$p(^PAC("ADMREA",Admreasondr),"^",2)  //收费类型（自费、医保等）
    .s outlistObj.reqdocno=AdmObj.AdmDoctorDesc //责任医生
    .s outlistObj.reqdeptno=AdmObj.CurrentDetpRowID //所属科室
    .s outlistObj.reqwardno=AdmObj.CurrentWardRowID
    .s outlistObj.reqbedno=AdmObj.CurrentBedNo //床号
    .s outlistObj.patdiag=##class(web.RoutineworkC).GetDiagnosICDandDesc(Admid)
    .s outlistObj.patdiagicd=""
    .s outlistObj.pataddress=PatObj.Address
    .s outlistObj.patnation="中国China"
    .s outlistObj.patidcardno=""
    .s outlistObj.patphone=PatObj.Telephone
    .s outlistObj.patheight=""
    .s outlistObj.abobldtype="" // ABO血型  A/B/AB/O
	.s outlistObj.rhbldtype="" // RH血型  +,- 表示阴性、阳性
	.s outlistObj.otherno="" //  其他号码
	.s outlistObj.operate="" //  手术； 代码名称都可以，传代码的情况下要在手术字典中能找得到对应的记录
	.s outlistObj.PatLocation="" //  患者所属地 ，代码名称都可以，对应系统代码Location
	.s outlistObj.reserve4="" //  备用4（以后扩展）
	.s outlistObj.bldtransfused="" //  既往有输血史
	.s outlistObj.bldpregnancyed="" //  既往有妊娠史
	.s outlistObj.bldpregcount="" //  孕育次数
	.s outlistObj.bldbirthcount="" //  生产次数
	.Do outputobj.PatientInfo.Insert(outlistObj)
	.Do outputobj.%Close()
	set outputobj.ResultCode="1"
	set outputobj.ResultContent="成功"
	s RpStream=""
	do outputobj.XMLExportToStream(.RpStream,"Response")
	;d outputlist.XMLExport(.string)
	d outputobj.%Close()
	;w !,string
 	q RpStream
	
GetIPPatinfoByLoc
	set outputlist=##class(web.RMupdateLabNo.MSG.RMResponse).%New()
   	Set outputlist.ResultCode=-10
   	Set outputlist.ResultContent="程序处理出错:"_$ZERROR
	do outputlist.XMLExportToStream(.RpStream,"xml")
	;d outputlist.XMLExport(.string)
	d outputlist.%Close()
	;w !,string
 	q RpStream
}

// 审核医嘱

// w ##class(web.RoutineworkD).RMApplyOrder("1520674||248","0864")

ClassMethod RMApplyOrder(Oeordid, UserCode) As %String
{
	s Fir=$p(Oeordid,"_",1)
	s Sec=$p(Oeordid,"_",2)
	s Userid="",rtn=""
	s Userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,Userid))
	s ExtLabNo=""
	set OEORDID=Fir_"||"_Sec
	set rtn=##class(web.DHCLCNUREXCUTE).SeeOrder(OEORDID,Userid)
	q rtn
}

// 执行医嘱

// w ##class(web.RoutineworkD).RMExecOrder("1520674_248","0864")

ClassMethod RMExecOrder(Oeordid, UserCode) As %String
{
	s Fir=$p(Oeordid,"_",1)
	s Sec=$p(Oeordid,"_",2)
	s Labno=""
	s Admid=""
	s Admid=$p(^OEORD(Fir),"^",1)
	s AdmType=$p(^PAADM(Admid),"^",2)
	set OEORDID=Fir_"||"_Sec
	s rtn="",Userid=""
	s Date=$zd($h,3)
	s datestr=$p(Date,"-",3)_"/"_$p(Date,"-",2)_"/"_$p(Date,"-",1)
	s Userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,Userid))
	if (AdmType="I"){
	s rtn=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",OEORDID_"||1","F",Userid,"","WZX",datestr,"","")
	}
	else
	{
	s rtn=0
		}
	q rtn
}

// 撤销执行

// w ##class(web.RoutineworkD).RMCancleExecOrder("1520674_248","0864")

ClassMethod RMCancleExecOrder(Oeordid, UserCode) As %String
{
	s Fir=$p(Oeordid,"_",1)
	s Sec=$p(Oeordid,"_",2)
	set OEORDID=Fir_"||"_Sec
	s rtn="",Userid=""
	s Userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,Userid))
	s Admid=""
	s Admid=$p(^OEORD(Fir),"^",1)
	s AdmType=$p(^PAADM(Admid),"^",2)
	if (AdmType="I"){
	s rtn=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",OEORDID_"||1","C",Userid,"","","","","")
	}
	else
	{
	s rtn=0
		}
	q rtn
}

// d ##class(web.RoutineworkD).GetXZSJTQ("2016-01-01","2017-12-31","I")

// d ##class(web.RoutineworkD).GetXZSJTQ("2016-01-01","2016-01-01","I")

// d ##class(web.RoutineworkD).GetXZSJTQ("2016-01-01","2016-12-31","O")

ClassMethod GetXZSJTQ(SDate, EDate, PayType) As %String
{
 s SDate=$zdh(SDate,3)
 s EDate=$zdh(EDate,3)
 k ^tmpcwktjsj
 f date=SDate:1:EDate d
 .s workloadrowid="",sumtotal=0,num=0 f  s workloadrowid=$o(^DHCWorkLoad(0,"ORDDATE",date,workloadrowid))  q:workloadrowid=""  d
 ..s AccCateid=$p(^DHCWorkLoad(workloadrowid),"^",40)
 ..s AdmType=$p(^DHCWorkLoad(workloadrowid),"^",4)
 ..q:AdmType'=PayType
 ..s Taritem=$p(^DHCWorkLoad(workloadrowid),"^",22)
 ..;q:(Taritem'="3844")&(Taritem'="3845")&(Taritem'="3846")&(Taritem'="3847")&(Taritem'="3848")&(Taritem'="3849")&(Taritem'="3850")&(Taritem'="3851")&(Taritem'="3852")&(Taritem'="4670")&(Taritem'="4675")&(Taritem'="4677")&(Taritem'="4678")&(Taritem'="4679")&(Taritem'="4680")&(Taritem'="4681")&(Taritem'="4682")&(Taritem'="4683")&(Taritem'="5411")
 ..q:('$d(^TMPFXGlo(Taritem)))
 ..;q:(Taritem'="3125")&(Taritem'="3126")&(Taritem'="3127")&(Taritem'="3128")
 ..;q:Taritem'="3001"
 ..s Price=$p(^DHCWorkLoad(workloadrowid),"^",14)
 ..s Qty=$p(^DHCWorkLoad(workloadrowid),"^",15)
 ..s Amount=$p(^DHCWorkLoad(workloadrowid),"^",16) //总金额	
 ..s RecLoc=$p(^DHCWorkLoad(workloadrowid),"^",1)
 ..s Locdesc=$p(^CTLOC(RecLoc),"^",1) //接收科室
 ..s ordDateTime=$zd($p(^DHCWorkLoad(workloadrowid),"^",5),3)_" "_$zt($p(^DHCWorkLoad(workloadrowid),"^",6),1)

 ..s PBDDR=$p(^DHCWorkLoad(workloadrowid),"^",48)
 ..s Papmi=$p(^DHCWorkLoad(workloadrowid),"^",13)
 ..s patname=$p(^PAPER(Papmi,"ALL"),"^",1)
 ..s PB=$p(PBDDR,"||",1)
 ..if PayType="O" d
 ...s Conid=""
 ...s Conid=$O(^DHCBCI(0,"Bill",PB,Conid))
 ...s INVid=$p(^DHCBCI(Conid),"^",1)
 ...s PrtNo=$p(^DHCINVPRT(INVid),"^",14)
 ...s:PrtNo="" PrtNo=INVid
 ...s Tardesc=$p(^DHCTARI(Taritem),"^",2)
 ...s Tarcode=$p(^DHCTARI(Taritem),"^",1)
 ...s UomId=$p(^DHCTARI(Taritem),"^",3)
 ...s Uom=$p(^CT("UOM",UomId),"^",1)
 ..else  d
 ...s adm=$p(^DHCWorkLoad(workloadrowid),"^",12)
 ...s PrtNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(adm) 
 ...s Tardesc=$p(^DHCTARI(Taritem),"^",2)
 ...s Tarcode=$p(^DHCTARI(Taritem),"^",1)
 ...s UomId=$p(^DHCTARI(Taritem),"^",3)
 ...s Uom=$p(^CT("UOM",UomId),"^",1) 
 ..s OEorditem=$p(^DHCWorkLoad(workloadrowid),"^",21)
 ..;s First=$p(OEorditem,"||",1)
 ..;s Secon=$p(OEorditem,"||",2)
 ..;s OrdDate=$zd($p(^OEORD(First,"I",Secon,1),"^",9),3)
 ..;s OrdTime=$zt($p(^OEORD(First,"I",Secon,1),"^",10),1)
 ..s ^tmpcwktjsj(OEorditem,"Qty")=$g(^tmpcwktjsj(OEorditem,"Qty"))+Qty
 ..s ^tmpcwktjsj(OEorditem,"Amount")=$g(^tmpcwktjsj(OEorditem,"Amount"))+Amount
 ..s ^tmpcwktjsj(OEorditem)=Tarcode_"^"_Tardesc_"^"_Uom_"^"_patname_"^"_PrtNo_"^"_Locdesc
 q 0
}

// d ##class(web.RoutineworkD).BulidFXSJ()

ClassMethod BulidFXSJ() As %String
{
	
	s taritemid=0
	k ^TMPFXGlo
	f  s taritemid=$O(^DHCTARI(taritemid))  q:taritemid=""   d
	.s Code=$p($g(^DHCTARI(taritemid)),"^",1)
	.w !,Code
	.q:Code'["33-i"
	.s ^TMPFXGlo(taritemid)=""
}

// d ##class(web.RoutineworkD).DateViewer()

ClassMethod DateViewer() As %String
{
	s OrdID="",String="",sum=0	
	f  s OrdID=$O(^tmpcwktjsj(OrdID))  q:OrdID=""  d
	.s String=$g(^tmpcwktjsj(OrdID))
	.s Tarcode=$p(String,"^",1)
	.s Tardesc=$p(String,"^",2)
	.s Qty=$g(^tmpcwktjsj(OrdID,"Qty"))
	.s Amount=$g(^tmpcwktjsj(OrdID,"Amount"))
	.s Uom=$p(String,"^",3)
	.s PatName=$p(String,"^",4)
	.s PrtNo=$p(String,"^",5)
	.s Locdesc=$p(String,"^",6)
	.s First=$p(OrdID,"||",1)
 	.s Secon=$p(OrdID,"||",2)
	.s OrdDate=$zd($p(^OEORD(First,"I",Secon,1),"^",9),3)
	.s OrdTime=$zt($p(^OEORD(First,"I",Secon,1),"^",10),1)
	.s sum=sum+Amount
	.q:Amount=0
	.w !,Tarcode_"^"_Tardesc_"^"_Qty_"^"_Uom_"^"_Amount_"^"_OrdDate_" "_OrdTime_"^"_PatName_"^"_PrtNo_"^"_Locdesc
	
	w !,sum
}

// d ##class(web.RoutineworkD).DHCWorkloadSum("2016-01-01","2016-12-31")

ClassMethod DHCWorkloadSum(SDate, EDate) As %String
{

 s SDate=$zdh(SDate,3)
 s EDate=$zdh(EDate,3)
 s sum=0
 f date=SDate:1:EDate d
 .s workloadrowid="",sumtotal=0,num=0 f  s workloadrowid=$o(^DHCWorkLoad(0,"ORDDATE",date,workloadrowid))  q:workloadrowid=""  d
 ..s AccCateid=$p(^DHCWorkLoad(workloadrowid),"^",40)
 ..s Taritem=$p(^DHCWorkLoad(workloadrowid),"^",22)
 ..;q:(Taritem'="3844")&(Taritem'="3845")&(Taritem'="3846")&(Taritem'="3847")&(Taritem'="3848")&(Taritem'="3849")&(Taritem'="3850")&(Taritem'="3851")&(Taritem'="3852")&(Taritem'="4670")&(Taritem'="4675")&(Taritem'="4677")&(Taritem'="4678")&(Taritem'="4679")&(Taritem'="4680")&(Taritem'="4681")&(Taritem'="4682")&(Taritem'="4683")&(Taritem'="5411")
 ..;q:('$d(^TMPFXGlo(Taritem)))
 ..;q:(Taritem'="3125")&(Taritem'="3126")&(Taritem'="3127")&(Taritem'="3128")
 ..q:Taritem'="4929"
 ..s Amount=$p(^DHCWorkLoad(workloadrowid),"^",16) //总金额	
 ..s sum=sum+Amount
 w !,sum
}

// w ##class(web.RoutineworkD).GetJCPayTradeNo("4038985","R")

ClassMethod GetJCPayTradeNo(PrtRowID, PrtFairType) As %String
{
	s JCPayid=""
	s InitID=$p(^DHCINVPRT(PrtRowID),"^",13)
	s TradeNo="",Conid=""
	if (PrtFairType="F")&(InitID="") d
	.if $d(^JCWAPayINVi("INVPRT",PrtRowID))  d
	..set JCPayid=$O(^JCWAPayINVi("INVPRT",PrtRowID,JCPayid))
	..set:JCPayid'="" TradeNo=$p(^JCWeiAliPayO(JCPayid),"^",9)
	.else  d
	..s TradeNo="无此支付对应记录1!"
	if (PrtFairType="F")&(InitID'="") d
	.if $d(^JCWAPayINVi("INVPRT",InitID))  d
	..set JCPayid=$O(^JCWAPayINVi("INVPRT",InitID,JCPayid))
	..set:JCPayid'="" TradeNo=$p(^JCWeiAliPayO(JCPayid),"^",9)
	.else  d
	..s TradeNo="无此支付对应记录2!"
	
	if PrtFairType="R" d
	.if $d(^JCRegRecordINVi("INV",PrtRowID))  d
	..set JCPayid=$O(^JCRegRecordINVi("INV",PrtRowID,JCPayid))
	..set:JCPayid'="" TradeNo=$p(^JCRegRecordO(JCPayid),"^",10)
	.else  d
	..s Conid=$O(^DHCBCI(0,"INV",PrtRowID,Conid))
	..s Admid=$P(^DHCBCI(Conid),"^",3)
	..s JCPayid=$O(^JCRegRecordAdmi("Adm",Admid,JCPayid),-1)
	..s:JCPayid'="" TradeNo=$p(^JCRegRecordO(JCPayid),"^",10)
	..s:JCPayid="" TradeNo="无此支付对应记录3!"
	
	
	
	/*if (PrtFairType="R")&(InitID="") d
	.if $d(^JCRegRecordINVi("INV",PrtRowID))  d
	..set JCPayid=$O(^JCRegRecordINVi("INV",PrtRowID,JCPayid))
	..set:JCPayid'="" TradeNo=$p(^JCRegRecordO(JCPayid),"^",10)
	.else  d
	..s TradeNo="无此支付记录3！"
	if (PrtFairType="R")&(InitID'="") d
	.if $d(^JCRegRecordINVi("INV",InitID))  d
	..set JCPayid=$O(^JCRegRecordINVi("INV",InitID,JCPayid))
	..set:JCPayid'="" TradeNo=$p(^JCRegRecordO(JCPayid),"^",10)
	.else  d
	..s TradeNo="无此支付记录4！"*/
	

	q TradeNo
}

// w ##class(web.RoutineworkD).GetPatInNum("64629")

ClassMethod GetPatInNum(Qday) As %String
{
  Set ind=1
 s sumpre=0
 s Flag=0
 k ^tmpGetPatInNum
 s prtRowid="",count=0
 s ^tmptimedateinput=$h
 q:Qday="" $$$OK
 s day=Qday
 s AccPeriodID=0 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",day,AccPeriodID))  q:AccPeriodID=""  d
 .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",AccPeriodID," C",accDataDr)) q:accDataDr=""  d
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
 ..s disdate=$p(^PAADM(adm),"^",17)
 ..s Flag=0
 ..s:(disdate="")!(disdate>day) Flag="1"  ;出院日期为空 并且出院日期大于查询日期
 ..//q:disdate>=day
 ..;s:disdate="" disdate=(+day+11)
 ..;q:(disdate<day)
 ..q:Flag'="1"
 ..s Loc=$p(^PAADM(adm),"^",4)
 ..s:'$d(^tmpGetPatInNum("Adm",adm)) ^tmpGetPatInNum(day,Loc)=$g(^tmpGetPatInNum(day,Loc))+1
 ..s ^tmpGetPatInNum("Adm",adm)=""

 q 0
}

// w ##class(web.RoutineworkD).CheckPatRegAge("22天","儿科门诊")

ClassMethod CheckPatRegAge(Age, Loc) As %String
{
	
	s rtn=0
	s AgeY=""
	s:Age["岁" AgeY=$p(Age,"岁",1)
	s:Age'["岁" AgeY=0

	if (Loc="儿科门诊")&(+AgeY>15)
	{
		s rtn="-1"
		}
	if (Loc["儿童")&(+AgeY>15)
	{
		s rtn="-1"
		if (Loc="儿童心理保健科门诊")&(+AgeY<18)
		{
			s rtn="0"
			}
		}
	
	q rtn
}

// d ##class(web.RoutineworkD).GetCenter("0000404304","2018-01-08")

ClassMethod GetCenter(PatNo, InDate) As %String
{

	s papmi="",adm="",PB="",sub1="",sub2=""
	s InDate=$zdh(InDate,3)
	s papmi=$O(^PAPERi("PAPMI_PatNo",PatNo,papmi))
	q:papmi="" "未查询到此病人id"
	s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	;b ;1
	f  s adm=$O(^PAPERdr(papmi,"ADM","I",adm))  q:adm=""   d
	.;b ;1
	.s AdmFlag=$p( ^PAADM(adm),"^",20)
	.q:AdmFlag'="A"
	.s AdmLoc=$p(^PAADM(adm),"^",4)
	.s AdmLocdesc=$p(^CTLOC(AdmLoc),"^",1)
	.s PB=$O(^DHCPB(0,"ADM",adm,PB),-1)
	.;b ;23
	.f  s sub1=$O(^DHCPB(PB,"O",sub1))  q:sub1=""  d
	
	..f  s sub2=$O(^DHCPB(PB,"O",sub1,"D",sub2) )  q:sub2=""  d
	...s BillDate=$p(^DHCPB(PB,"O",sub1,"D",sub2),"^",11) 
	...q:BillDate'=InDate
	...s taritem=$p(^DHCPB(PB,"O",sub1,"D",sub2),"^",3)
	...s code=$p(^DHCTARI(taritem),"^",1)
	...s desc=$p(^DHCTARI(taritem),"^",2)
	...s price=$p(^DHCPB(PB,"O",sub1,"D",sub2),"^",4)
	...s qty=$p(^DHCPB(PB,"O",sub1,"D",sub2),"^",5) 
	...s amt=$p(^DHCPB(PB,"O",sub1,"D",sub2),"^",7)
	...w !,$zd(BillDate,3)_"^"_desc_"^"_price_"^"_qty_"^"_amt_"^"_code
	w !,"患者姓名:"_patname_"  登记号:"_PatNo_" 住院科室:"_AdmLocdesc
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","GetYDPatPayInfo","2021-09-01","2021-09-01","O","","1")

ClassMethod getlx(pattypedr) As %String
{
	s pattype="职工"
	s:(pattypedr=14)||(pattypedr=15)||(pattypedr=16)||(pattypedr=1401)||(pattypedr=1402)||(pattypedr=1403)||(pattypedr=1404) pattype="居民"
	s:(pattypedr=1405)||(pattypedr=1460)||(pattypedr=1501)||(pattypedr=1560) pattype="居民"
	;s:(pattypedr=116014) pattype="伤残"
	q pattype
}

/// /异地门诊和异地住院报表
ClassMethod GetYDPatPayInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYDPatPayInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetYDPatPayInfoExecute(ByRef qHandle As %Binary, SDate, EDate, PatType, RYLX As %Status = "", SNSW) As %Status
{
	;n (SDate,EDate,InsuType)
	Set repid=$I(^CacheTemp)
	s ind=1
	s YGT=""
	s ^tmpGetYDPatPayInfo=$lb(SDate,EDate,PatType,RYLX,SNSW)
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	F iDate=SDate:1:EDate D
	.s DivDr="" 
	. f  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
	..s DivStr=$g(^DHCINDIV(DivDr))
	..s PBDr=$p(DivStr,"^",3) //账单id
	..s InvDr=$p(DivStr,"^",4) // 发票id
	..s Flag=$p(DivStr,"^",5)
	..I DivDr="2512658" S Flag="I"
	..I DivDr="2508496" S Flag="I"
	..q:Flag'="I"
	..s paydate=$zd(iDate,3)
	..s InsuAdmDr=$p(DivStr,"^",2)
	..s AdmDr=$p(DivStr,"^",1)
	..q:AdmDr=""
	..s AdmType=$p(^PAADM(AdmDr),"^",2)
	..q:AdmType'=PatType
	..s PAPMIID=$p($g(^PAADM(AdmDr)),"^",1)    ;病人基本信息ID
	..s patno=$p(^PAPER(PAPMIID,"PAT",1),"^",1)
	..s AdmreasonDrTmp=$p($g(^PAADM(AdmDr,"1")),"^",7)
	..s (mrno,ADMdate,DISdate)=""    //add by zz
	..s mrno=$p(^PAPER(PAPMIID,"PAT",1),"^",22)
	..s ADMdate=$p($g(^PAADM(AdmDr)),"^",6)
	..s DISdate=$p($g(^PAADM(AdmDr)),"^",17)
	..s:ADMdate'="" ADMdate=$zd(ADMdate,3)
	..s:DISdate'="" DISdate=$zd(DISdate,3)
	..;q:AdmreasonDrTmp'="32"
	
	..s InsuAdmStr=$g(^DHCINADM(InsuAdmDr))
	..s InsuTypeLS=$p(InsuAdmStr,"^",18)  ;医保类别
	..q:(InsuTypeLS'="XZFYA")&&(InsuTypeLS'="00A")
	..s Xstring10=$p(InsuAdmStr,"^",39)
	..s Xstring17=$p(InsuAdmStr,"^",46)
	..;q:(Xstring10'="1")&&(Xstring17'["YD") //异地医保  
	..;w !,Xstring17
	..s Center=""
	..i InsuTypeLS="XZFYA" s Center=$p(InsuAdmStr,"^",8)
	..i InsuTypeLS="00A" s Center=$p(InsuAdmStr,"^",7)
    ..q:Center=""
	..q:(Center="320305")||(Center="320312")||(Center="320321")||(Center="320322")||(Center="320324")||(Center="320325")||(Center="320381")||(Center="320382")||(Center="320399")
	..;q:(Center="320399")
	..s szm=$e(Center,1,2)
	..;b ;szm
	..;w !,szm _" "_Center
	..if szm="32" d
	...s SNFlag="1" //省内
	..else  d
	...s SNFlag="0" //省外
	..i DivDr="2508496" s SNFlag="0"
	..;w !,SNFlag
	..q:(SNFlag'=SNSW)&(SNSW'="NULL")
	..s Name=$p(InsuAdmStr,"^",35)   ;姓名
	..s:Name["|" Name=$p(Name,"|",1)
 	..s XB=$p(InsuAdmStr,"^",42)    ;性别
	..s GRNO=$p(InsuAdmStr,"^",2)   ;个人编号
	..s IDNO=$p(InsuAdmStr,"^",34)   ;身份证号
	..;b ;w !,InsuAdmStr
	..s PatTypeHis=$p(InsuAdmStr,"^",4)
	..s PatTypeHisnew=$p(InsuAdmStr,"^",4)
	..s PatTypekknew=..getlx(PatTypeHisnew)
	..;b ;w !,PatTypeHis
	..s PatTypekk=""
	..s:((PatTypeHis="11")||(PatTypeHis="21")||(PatTypeHis="31")||(PatTypeHis="32")||(PatTypeHis="33")||(PatTypeHis="34")) PatTypekk="职工"
	..s:((PatTypeHis="38")||(PatTypeHis="39")||(PatTypeHis="37")||(PatTypeHis="3B")) PatTypekk="居民"	
	..;s PatTypekk=##class(web.DHCINSUPort).mwthfmnew(PatTypeHis)
	..;b ;333
	..i InsuTypeLS="XZFYA" q:((PatTypekk'=RYLX)&&(RYLX'="NULL"))
	..;b ;4556
	..i InsuTypeLS="00A" q:((PatTypekknew'=RYLX)&&(RYLX'="NULL"))
	..;b ;InsuTypeLS
	..s AdmDr=$p($g(^DHCINDIV(DivDr)),"^",1)
	..;w !,Name
    ..s PapmiDr=$p(^PAADM(AdmDr),"^",1)
    ..s PatInfo=$$GetPatInfoByPatID^DHCINSUPatInfo(PapmiDr)  
    ..;s Name=$p(PatInfo,"^",3)            //姓名
    ..s Telephone=$p($g(^PAPER(PapmiDr,"PER",1)),"^",11)  //联系电话 
	..s SeriNo=Telephone   ;jiuzhenhao  
	..s (ZFY,InsuPay1,zhzfe0,GWY,DBZF,MZJZ,DBBX,BCBX,qybc)=0 
    ..i InsuTypeLS="XZFYA" d
	...s ZFY=$p(DivStr,"^",7)    ;总费用
    ...s InsuPay1=$p(DivStr,"^",31)	    ;医保统筹支付
	...s zhzfe0=$p(DivStr,"^",28)    ;账户支付
	...s grzfe0=$p(DivStr,"^",15)    ;个人自付
	...s GWY=$p(DivStr,"^",33)  //公务员
	...s DBZF=$p(DivStr,"^",32) //大病
	...s MZJZ=$p(DivStr,"^",49) // 民政救助
	...s DBBX=$p(DivStr,"^",35)+$p(DivStr,"^",46) // 大病保险
	...s CZGWY="0.0" // 参照公务员
	...s BCBX=$p(DivStr,"^",47)

	..i InsuTypeLS="00A" d
	..s ZFY=$p(DivStr,"^",7)    ;总费用
    ..s InsuPay1=$p(DivStr,"^",31)	    ;医保统筹支付
	..s zhzfe0=$p(DivStr,"^",28)    ;账户支付
	..s grzfe0=$p(DivStr,"^",15)    ;个人自付
	..s GWY=$p(DivStr,"^",33)  //公务员补助或公务员支出
	..s DBZF=$p(DivStr,"^",32)+$p(DivStr,"^",47)  //大病支付或大额补助
	..s MZJZ=$p(DivStr,"^",34) // 民政救助 
	..s DBBX=$p(DivStr,"^",46) // 大病保险
	..s CZGWY="0.0" // 参照公务员
	..s BCBX=$p(DivStr,"^",35)  //企业补充医疗保险,补充保险，参照公务员补助
    ..s qybc=$p(DivStr,"^",35)  //企业补充医疗保险,补充保险，参照公务员补助
    ..d BuildTarCateYD
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateYD     
	set Data=$lb(ind,patno,Name,GRNO,BQ,ZFY,InsuPay1,zhzfe0,grzfe0,GWY,DBZF,MZJZ,DBBX,CZGWY,BCBX,IDNO,Center,PatTypekk,paydate,qybc,mrno,ADMdate,DISdate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetYDPatPayInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYDPatPayInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetYDPatPayInfo(SDate, EDate, PatType, RYLX As %Status = "", SNSW) As %Query(ROWSPEC = "ind,patno,Name,GRNO,BQ,ZFY,InsuPay1,zhzfe0,grzfe0,GWY,DBZF,MZJZ,DBBX,CZGWY,BCBX,IDNO,Center,PatTypekk,paydate,qybc,mrno,ADMdate,DISdate") [ SqlProc ]
{
}

// w ##class(web.RoutineworkD).GetPatBLtotalInfo("1718673")

ClassMethod GetPatBLtotalInfo(adm) As %String
{
	s rtn=""
	s s=##Class(EPRservice.BIL.BIToHIP).GetInstanceIDSByTemIDTest(adm,"HDSD00.14")	
	q s
}

// w ##class(web.RoutineworkD).GetBLMegInfo("1718673","1660632||4")

ClassMethod GetBLMegInfo(adm, Input) As %String
{
	s out=##Class(EPRservice.BIL.BIToHIP).GetDataByGlossaryCategoryTest(adm,"HDSD00.14.02",Input)
	q out
}

// d ##class(web.RoutineworkD).GetTimeRange("1733963")

ClassMethod GetTimeRange(PAAdmDR) As %String
{
	s RegfeeRowId=""
	s RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM"," "_$g(PAAdmDR),""))
	i RegfeeRowId'="" s RegFeeRBASDr=$List(^User.DHCRegistrationFeeD(RegfeeRowId),18)
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RegFeeRBASDr)
	s TimeRange=DHCRBASObj.ASTimeRangeDR.TRDesc
	w !,TimeRange
}

// w ##class(web.RoutineworkD).GetTimeRangeByRBA("673||250")

ClassMethod GetTimeRangeByRBA(RegFeeRBASDr) As %String
{
	q:RegFeeRBASDr="" ""
	s rtn=""
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RegFeeRBASDr)
	s TimeRange=DHCRBASObj.ASTimeRangeDR.TRDesc
	s:TimeRange="上午" rtn="1"
	s:TimeRange="下午" rtn="2"
	s:TimeRange="晚上" rtn="3"
	s:TimeRange="全天" rtn="4"
	q rtn
}

ClassMethod GetRegTimePrintDate(RBApptID, RegQue) As %String
{
}

// 597||1373

/// 根据序号取分时段信息里对应的时间段
/// w ##class(web.RoutineworkD).GetAdmTimeBySeqNo("597||1373","7")
ClassMethod GetAdmTimeBySeqNo(ASRowid As %String, SeqNo As %String)
{
	//1-1,2-2,3-3,4-4,5-5,6-6,7-7,8-8,9-9,10-10,11-11,12-12,13-13,14-14,15-15,16-16,17-17,18-18,19-19,20-20
	//08:00-08:30,08:30-09:00,09:00-09:30,09:30-10:00,10:00-10:30,10:30-11:00,11:00-11:30,11:30-12:00,12:00-12:30,12:30-13:00,13:00-13:30,13:30-14:00,14:00-14:30,14:30-15:00,15:00-15:30,15:30-16:00,16:00-16:30,16:30-17:00,17:00-17:30,17:30-18:00
	Set SeqNoStr=$p(^RBAS(+ASRowid,$p(ASRowid,"||",2),"DHC"),"^",24)
	Set TimeRangeStr=$p(^RBAS(+ASRowid,$p(ASRowid,"||",2),"DHC"),"^",25)
	Set SeqNoLen=$l(SeqNoStr,",")
	Set Index=""
	Set TimeStr=""
	for i=1:1:SeqNoLen {
		Quit:Index'=""
		Set NumStr=$p(SeqNoStr,",",i)
		Set StartNum=$p(NumStr,"-",1)
		Set EndNum=$p(NumStr,"-",2)
		continue:(SeqNo>EndNum)||(SeqNo<StartNum)
		Set Index=i	
	}
	if Index'="" {
		Set TimeStr=$p(TimeRangeStr,",",Index)		
	}
	Quit TimeStr
}

// w ##class(web.RoutineworkD).GetTimeRangeByPrtID("4212632","16")

ClassMethod GetTimeRangeByPrtID(PrtID, SeqNo) As %String
{
	q:(PrtID="")||(SeqNo="") ""
	s Conid="",TimeRagne=""
	s Conid=$O(^DHCBCI(0,"INV",PrtID,Conid))
	s PAAdmDR=$p(^DHCBCI(Conid),"^",3)
	s RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM"," "_$g(PAAdmDR),""))
	i RegfeeRowId'="" s RegFeeRBASDr=$List(^User.DHCRegistrationFeeD(RegfeeRowId),18)
	s TimeRagne=..GetAdmTimeBySeqNo(RegFeeRBASDr,SeqNo)
	
	q TimeRagne
}

// w ##class(web.RoutineworkD).SaveOrderItems("<Request><patno>R05118</patno><reqitem>XYZP002</reqitem><qty>3.00</qty><barcode>1803197837</barcode><patdept>245</patdept><recdept></recdept><docno>0225</docno><reqtime>2018/3/19 16:04:53</reqtime></Request>")

// 304396

// w ##Class(web.DHCWMRService).IGetPatientIDByMrNo("304396","")

ClassMethod SaveOrderItems(Input As %String) As %String
{
	
	//aAdm As %String, aOrdItemStr As %String, aUser As %String, aLoc As %String, aDoc As %String, aPrescPara As %String = ""
	Set $ZT="SaveOrderItemseErr"
	Set InputObj=##class(web.RMupdateLabNo.MSG.InserOrdRequest).%New()
	set outputobj=##class(web.RMupdateLabNo.MSG.InsertBloodresponse).%New() //出参
	set outputobj.ResultCode="-100"
	set outputobj.ResultContent="失败,未查询到此病人在院记录!"
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set patno=InputObj.patno //住院号
	Set reqitemCode=InputObj.reqitem //申请项目
	Set OrdQty=InputObj.qty //数量
	Set barcode=InputObj.barcode //申请单号
	Set patdept=InputObj.patdept //开单科室
	Set recdept=InputObj.recdept //执行科室
	Set docno=InputObj.docno //医生工号
	Set reqtime=InputObj.reqtime //时间
	set ReqItmid=""
	set ReqItmsub="0"
	b ;1
	f  set ReqItmid=$O(^ARCIM(0,"Code",reqitemCode,ReqItmid))  q:ReqItmid=""  d
	.f  set ReqItmsub=$O(^ARCIM(0,"Code",reqitemCode,ReqItmid,ReqItmsub))  q:ReqItmsub=""  d
	..s reqitem=ReqItmid_"||"_ReqItmsub
	q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",docno)) "<Response><ResultCode>-6<ResultCode><ResultContent>此用户不存在.</ResultContent><OEORDID></OEORDID></Response>"
	q:reqitem="" "<Response><ResultCode>-3<ResultCode><ResultContent>申请项目"_reqitemCode_"不存在.</ResultContent><OEORDID></OEORDID></Response>"
	q:patdept="" "<Response><ResultCode>-1<ResultCode><ResultContent>申请科室为空.</ResultContent><OEORDID></OEORDID></Response>"
	set Papmi=""
	set Papmi= ##Class(web.DHCWMRService).IGetPatIDByMrNo(patno,"")
	b ;123
	q:Papmi="" "<Response><ResultCode>-2<ResultCode><ResultContent>此住院号未查询到病人信息.</ResultContent><OEORDID></OEORDID></Response>"
	set adm=""
	set ArcItmSub=$p(reqitem,"||",2)
	q:'$d(^ARCIM(+reqitem)) "<Response><ResultCode>-3<ResultCode><ResultContent>此医嘱"_reqitem_"项目不存在.</ResultContent><OEORDID></OEORDID></Response>"
	set Uom=$p(^ARCIM(+reqitem,ArcItmSub,8),"^",14)
	set Price=##class(web.RoutineworkD).GetArcitmprice(reqitem)
	set UserID=""
	set UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",docno,UserID))
	set DocID=""
	set DocID=$O(^CTPCP(0,"Code",docno,DocID))
	set OrdItemStr=reqitem_"^N^3^^^^"_Price_"^67^1^^^^^"_+OrdQty_"^5^^^^^1^N^^N^^^^^^^N^^^^^^^^^^N^^^^^^^^N^undefined^^^^N^^"
	b ;34
	f  s adm=$O(^PAPERdr(Papmi,"ADM","I",adm),-1)   q:adm=""   d
	.s ActiveFlag=$p(^PAADM(adm),"^",20)
	.q:ActiveFlag'="A"
	.Set return=##class(web.DHCOEOrdItem).SaveOrderItems(adm,OrdItemStr,UserID,patdept,DocID,"") 
	.b ;return
	.set Oeordid=$p(return,"*",2)
	.if Oeordid'="" d
	..set outputobj.ResultCode="0"
	..set outputobj.ResultContent="成功"
	..set outputobj.OEORDID=Oeordid
	.else  d
	..set outputobj.ResultCode="-100"
	..set outputobj.ResultContent="未能成功插入"
	..set outputobj.OEORDID=Oeordid
	do outputobj.XMLExportToString(.OutputXml,"Response")
	quit OutputXml
	
	//Set return=##class(web.DHCOEOrdItem).SaveOrderItems(aAdm,aOrdItemStr,aUser,aLoc,aDoc,aPrescPara)
	//Quit return
	
SaveOrderItemseErr
	Set outputobj=##class(web.RMupdateLabNo.MSG.InsertBloodresponse).%New()
	Set outputobj.ResultCode="-1"
	Set outputobj.ResultContent="查询失败:"_$ZERROR
	do outputobj.XMLExportToString(.OutputXml,"Response")
	quit OutputXml
}

// <Request><OEORDID>1520674||403</OEORDID><Userid>0225</Userid></Request>

ClassMethod CancleOeOrd(Input As %String) As %String
{
	;set ^cancleoeordtemp("input",Input)=$zt($p($h,",",2),1)
	
	//aAdm As %String, aOrdItemStr As %String, aUser As %String, aLoc As %String, aDoc As %String, aPrescPara As %String = ""
	Set $ZT="CancleOeOrdErr"
	Set InputObj=##class(web.RMupdateLabNo.MSG.RMBloodCanOrdReq).%New()
	set outputobj=##class(web.RMupdateLabNo.MSG.InsertBloodresponse).%New() //出参
	set outputobj.ResultCode="-200"
	set outputobj.ResultContent="失败,撤销异常!"
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set OEORDID=InputObj.OEORDID //住院号
	Set Usercode=InputObj.Userid //申请项目
	set ret="",Userid=""
	set Userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",Usercode,Userid))
	q:Userid="" "<Response><ResultCode>-1</ResultCode><ResultContent>此用户不存在</ResultContent></Response>"
	set ret=##class(appcom.OEOrdItem).UnUse(OEORDID,Userid)
	if ret=0 {
	set outputobj.ResultCode="0"
	set outputobj.ResultContent="成功"
	}
	else
	{
	set outputobj.ResultCode=ret
	set outputobj.ResultContent="失败"	
	}
	do outputobj.XMLExportToString(.OutputXml,"Response")
	quit OutputXml
	;set ^cancleoeordtemp("out",OutputXml)=$zt($p($h,",",2),1)
CancleOeOrdErr
	Set outputobj=##class(web.RMupdateLabNo.MSG.InsertBloodresponse).%New()
	Set outputobj.ResultCode="-2"
	Set outputobj.ResultContent="查询失败:"_$ZERROR
	do outputobj.XMLExportToString(.OutputXml,"Response")
	quit OutputXml
}

// w ##class(web.RoutineworkD).WMDepositRefundStr("1120030005")

ClassMethod WMDepositRefundStr(WMIPDeposit) As %String
{
	

	;s Flag=$p(^DHCWMIPDesoit(WMIPDeposit),"^",2)
	;q:Flag'="N" ""
	s WMTranNo=""
	s WMTranNo=$p(^DHCWMIPDesoit(WMIPDeposit),"^",4)
	s Amount=$p(^DHCWMIPDesoit(WMIPDeposit),"^",6)
	s Datetime=$tr($zd(+$h,"3"),"-","")_$tr($zt($p($h,",",2),1),":","")
	Set Obj=##class(web.WMIPRefund.MSG.WMIPRefundRequst).%New()
	set Obj.jigoubh="912000000005400555"
	set Obj.pingtaijsbh=WMTranNo
	set Obj.tuikuanlsh="TF"_WMIPDeposit
	set Obj.jine=Amount
	set Obj.tuifeisj=Datetime
	set Obj.beizhu=""
	set XML=""
	DO Obj.XMLExportToString(.XML,"head")
	q XML
}

// w ##class(web.RoutineworkD).WMDepositRefund("1120030015","2499")

ClassMethod WMDepositRefund(DepositNo, UserID) As %String
{
	Set $zt="WMDepositRefund"	
	set WMIPDeposit=""
	set WMIPDeposit=$O(^DHCWMIPCPNO("CPNO",DepositNo,WMIPDeposit))	
	q:WMIPDeposit="" ""
	
	set return=""
	set InputStr=..WMDepositRefundStr(WMIPDeposit)
	q:InputStr="" "-1"
	s ^tmpwmrefundinput=InputStr
	b ;123
	set MethodObj=##class(web.WMIPRefund.CommonWebServiceHttpSoap12Endpoint).%New()
	set rtn=MethodObj.appWebService("912000000005400555","912000000005400555","wmpt_zyyj_yjktf",InputStr)
	b ;23
	s ^tmpwmrefund=DepositNo_"^"_UserID
	s ^tmpwmrefundoutput=rtn
	s OutObj=##class(web.WMIPRefund.MSG.WMIPRefundResponse).%New()
    d OutObj.XMLNodeDeserialize(.OutObj,"Param_ZYYJTFOUT",rtn)
  	b ;d WMAIObj.XMLNodeDeserialize
    s ResultCode=OutObj.retcode ;1 成功 其他失败
    s ResultMsg=OutObj.retmessage
	if (ResultCode="1")
	{
	s return="0"
	s update=..UpdateWMIPADD(WMIPDeposit)
	b ;123
	s Prtno="TF"_WMIPDeposit
	s PatientID=$p(^DHCWMIPDesoit(WMIPDeposit),"^",13)
	s Adm=$p(^DHCWMIPDesoit(WMIPDeposit),"^",10)
	s PatientCard=""
	s Amt=$p(^DHCWMIPDesoit(WMIPDeposit),"^",6)
	s Amount=-1*Amt
	s BankTransactionId=$p(^DHCWMIPDesoit(WMIPDeposit),"^",4)
	s returncode=..UpdateWMIPADD(WMIPDeposit)
	s inserStr="0^"_Prtno_"^"_PatientID_"^"_Adm_"^"_PatientCard_"^^^"_Amount_"^"_BankTransactionId_"^"_UserID_"^^"_DepositNo_"^^"
	s returncode= ##class(web.RoutineworkD).InsertWMIPAddDetTF(inserStr)
	
	q returncode
	}
	else
	{
	s return="-1"	
		
	}
	q return
WMDepositRefund
	
	q $ZERROR
}

// 

ClassMethod UpdateWMIPADD(ID) As %String
{
	s Flag="B"
	
	&sql(UPDATE DHCWMIPAddDetail SET DHCWM_String1=:Flag WHERE ID=:ID)
	
	q SQLCODE
}

// w ##class(web.RoutineworkD).UpdateWMIPRefundNo("<head><jigoubh></jigoubh><huanzheid></huanzheid><jiuzhenid></jiuzhenid><binganhao></binganhao><jiezhilx></jiezhilx><jiezhihm></jiezhihm><xingming></xingming><shenfenzh></shenfenzh><pingtaijsbh>123415</pingtaijsbh><yuanneitfbh>TF5</yuanneitfbh><tuifeije></tuifeije><tuifeisj></tuifeisj><beizhu></beizhu></head>")

ClassMethod UpdateWMIPRefundNo(Input As %String) As %String
{
	Set $zt="UpdateWMIPRefundNo"
	set InputObj=##class(web.WMIPRefund.MSG.UpdateIPRefundRequest).%New()
	b ;2
	set OutObj=##class(web.WMIPRefund.MSG.UpdateIPRefundResponse).%New()
	b ;1
	set OutObjlist=##class(web.WMIPRefund.MSG.WMIPRefundList).%New()
	b ;3
	Do InputObj.XMLNodeDeserialize(.InputObj,"head",Input)
	Set pingtaijsbh=InputObj.pingtaijsbh //平台结算编号
	Set yuanneitfbh=InputObj.yuanneitfbh //院内退费编号
	b ;123
	set WMIPDeposit=""
	set WMIPDeposit=$O(^DHCWMIPCPNO("CPNO",yuanneitfbh,WMIPDeposit))
	b  ;213	
	q:WMIPDeposit="" "<wemay><retcode>-2</retcode><retmessage>失败,HIS无此订单</retmessage></wemay>"
	b ;1
	set RefundDate=$zd($p(^DHCWMIPDesoit(WMIPDeposit),"^",1),3)
	set RefundTime=$zt($p(^DHCWMIPDesoit(WMIPDeposit),"^",3),1)
	b ;2
	set RefundAmt=-1*$p(^DHCWMIPDesoit(WMIPDeposit),"^",6)
	b ;5
	set rtn=..UpdateTFTransNo(WMIPDeposit,pingtaijsbh)
	b ;4
	if rtn="0" 
	{
	set OutObjlist=##class(web.WMIPRefund.MSG.WMIPRefundList).%New()
	set OutObjlist.yuanneitfbh=yuanneitfbh
	set OutObjlist.yuanneitfsj=RefundDate_" "_RefundTime
	set OutObjlist.yuanneitfje=RefundAmt
	Do OutObj.ParmOutZhuYuanTFQR.Insert(OutObjlist)
	Do OutObj.%Close() 
	b ;1
	set OutObj.retcode="0"
	set OutObj.retmessage="成功"
	d OutObj.XMLExportToString(.string,"wemay")
	b ;1
	d OutObj.%Close()
 	q string 
	}
	else
	{
	set OutObj.retcode="-1"
	set OutObj.retmessage="失败"	
	d OutObj.XMLExportToString(.string,"wemay")
	d OutObj.%Close()
 	q string 	
		
	}
	
	
	
UpdateWMIPRefundNo
	set OutObj.retcode="-1"
	set OutObj.retmessage="失败"_$ze	
	d OutObj.XMLExportToString(.string,"wemay")
	d OutObj.%Close()
 	q string
}

// w ##class(web.RoutineworkD).UpdateTFTransNo("TF3","1234353")

ClassMethod UpdateTFTransNo(TFID, WMTFTran) As %String
{
	
	&sql(UPDATE DHCWMIPAddDetail SET DHCWM_TransactionId=:WMTFTran WHERE ID=:TFID)
	
	q SQLCODE
}

// w ##class(web.RoutineworkD).UpdateFBMZ()

ClassMethod UpdateFBMZ() As %String
{
 set Statue="2"
 set Res="1843"
 &sql(UPDATE  DHC_RBApptSchedule SET AS_Status_DR=:Statue WHERE AS_RES_ParRef=:Res AND AS_SessionType_DR IS NULL)
 q SQLCODE
}

// w ##class(web.RoutineworkD).CheckBloodCancle("1520674||456")

ClassMethod CheckBloodCancle(OEORdid) As %String
{
 set sub=$p(OEORdid,"||",2)
 set rtn=0
 s KDKS=$P(^OEORD(+OEORdid,"I",sub,7),"^",2)
 s:KDKS="67" rtn="-1"

 q rtn
}

// w ##class(web.RoutineworkD).GetDivideNum("000008021911374389")

ClassMethod GetDivideNum(INPAYLsh) As %String
{
 s InsuDivid=""
 s i="0"
 f  s InsuDivid=$o(^DHCINDIV("0","Djlsh0",INPAYLsh,InsuDivid))  q:InsuDivid=""  d	 
 .s PayFlag=$p(^DHCINDIV(InsuDivid),"^",5)
 .q:PayFlag="S"
 .s i=i+1
 
 q i
}

// w ##class(web.RoutineworkD).CheckPatInPathWay("330771")

ClassMethod CheckPatInPathWay(Adm) As %String
{
  s ^tmpcheckpatinpath($h)=Adm
  s AdmDate=$p(^PAADM(Adm),"^",6)
  s AdmTime=$p(^PAADM(Adm),"^",7)
  s NowDate=+$h
  s NowTime=$p($h,",",2)
  
  s Datesub=NowDate-AdmDate
  s Timesub=NowTime-AdmTime
  
 if (Datesub>2) //超过2天了
  {
	 q "N" 
	 }
   
 if (Datesub=2)&(Timesub<0) //差2天 但是不到24小时
  {
	 q "Y" 
	 }
 if (Datesub=2)&(Timesub>0) //差2天 但是超过24小时
  {
	 q "N" 
	 }
	 
 if (Datesub<2) //不超过2天
  {
	 q "Y" 
	 }
}

// w ##class(web.RoutineworkD).GetUserCode("王海舰","321321312")

ClassMethod GetUserCode(Name, Tel) As %String
{
	q:Name="" ""
	q ""
	
	s Usercode=""
	
	s Userid=""
	b ;123
	if $d(^SSU("SSUSR",0,"SSUSR_Name",Name)) {
	
	s Userid=$O(^SSU("SSUSR",0,"SSUSR_Name",Name,Userid))
	b ;123
	&sql(update SS_User set SSUSR_Mobile=:Tel where SSUSR_RowId=:Userid)
	b ;213
	s Usercode=$p(^SSU("SSUSR",Userid),"^",1)
	
	q SQLCODE
	}
	else
	{
		q ""
		
		}
}

// w ##class(web.RoutineworkD).GetPatFirstSecond("2017-01-01","2017-04-30")

// w ##class(web.RoutineworkD).GetPatFirstSecond("2017-05-01","2017-09-30")

// w ##class(web.RoutineworkD).GetPatFirstSecond("2017-10-01","2017-12-31")

ClassMethod GetPatFirstSecond(SDate, EDate) As %String
{
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	s Fir=0,Sec=0,count=0,AdmID=""
	f idate=SDate:1:EDate  d
	.f  s AdmID=$O(^PAADMi("PAADM_AdmDate",idate,AdmID)) q:AdmID=""  d
	..s AdmType=$p(^PAADM(AdmID),"^",2)
	..q:AdmType'="O"
	..s ActiveFlag=$p(^PAADM(AdmID),"^",20)
	..q:ActiveFlag="C"
	..s AdmFR=$p(^PAADM(AdmID),"^",72)
	..s:AdmFR="F" Fir=Fir+1
	..s:AdmFR="R" Sec=Sec+1
	..s count=count+1
	w !,"总："_count_" 初: "_Fir_" 复："_Sec
}

// w ##class(web.RoutineworkD).GetDocType("23")

ClassMethod GetDocType(TypeID) As %String
{
  s rtn=5
  q:TypeID="" 5
  if (TypeID="1")||(TypeID="2")||(TypeID="3")||(TypeID="4")||(TypeID="5")   d
  .set rtn="4"
  if (TypeID="6")||(TypeID="17")  d
  .set rtn="2"
  if (TypeID="7")||(TypeID="8")||(TypeID="13")||(TypeID="14")||(TypeID="16")||(TypeID="20")  d
  .set rtn="3"
  if (TypeID="9")||(TypeID="10")||(TypeID="18")||(TypeID="19")||(TypeID="22")    d
  .set rtn="1"
  
  q rtn
}

// w ##class(web.RoutineworkD).GetCTLocType("23")

ClassMethod GetCTLocType(LocID) As %String
{
 //1、住院 2、门诊 3、其他
 set rtn="3"
 
 q:LocID="" 3
 
 set LocTypeid=""
 
 set LocTypeid=$p(^CTLOC(LocID),"^",19)
 
 if (LocTypeid="1") d
 .set rtn="2"
  if (LocTypeid="2")||(LocTypeid="3") d
 .set rtn="1"
 
 q rtn
}

// w ##class(web.RoutineworkD).InsertINSURegRecord("330526^100^123^0^0^test^")

ClassMethod InsertINSURegRecord(data) As %String
{
	//Data="200^100^123^0^0^0^"
	//     
		
	k PLIST
	
	;b ;insert
	s data="0"_"^"_data
	s Collection=$p(data,"^",2)
	i Collection'="" s PLIST(2)=Collection           //Adm
	q:Collection="" "0"
	q:Collection="" "1"
	
	s Refund=""
	s:Collection'="" Refund=$p(^PAADM(Collection),"^",1)
	i Refund'="" s PLIST(3)=Refund                  //papmi
	
	s TradeDate=$p($h,",",1)
	i TradeDate'="" s PLIST(4)=TradeDate              //交易日期
	
	s TradeTime=$p($h,",",2)
	i TradeTime'="" s PLIST(5)=TradeTime              //交易时间	
	
	s Balance=$p(data,"^",6)
	i Balance'="" s PLIST(6)=Balance                //流水号
	
	s Str1=""
	s:Collection'="" Str1=$p(^PAPER(Refund,"ALL"),"^",1)
	i Str1'="" s PLIST(7)=Str1                      //str1
	


	&SQL(INSERT INTO SQLUser.DHC_INSURegRecord VALUES PLIST())
	
	q SQLCODE
}

ClassMethod GetPrtTypeByDivDr(DivDr) As %String
{

	s PrtID=$p(^DHCINDIV(DivDr),"^",4)
	
	s PrtType=$p(^DHCINVPRT(PrtID),"^",34)
	
	q PrtType
}

ClassMethod GetInsuAdmTypeByDivDr(DivDr) As %String
{

	s Adminfoid=""
	s Adminfoid=$p(^DHCINDIV(DivDr),"^",1)	

	q Adminfoid
}

// w ##class(web.RoutineworkD).GetInsDivDr("843026")

ClassMethod GetInsDivDr(InvPrt) As %String
{
	s Divid=""
	s Rtn=""
	f  s Divid=$O(^DHCINDIV("0","DHCInvPrt",InvPrt,Divid))  q:Divid=""  d
	.s DivFlag=$P(^DHCINDIV(Divid),"^",5)
	.q:DivFlag'="I"
	.s Rtn=Divid
	q Rtn
}

// w ##class(web.RoutineworkD).UpdateRegisterFee("1877412","4531140")

ClassMethod UpdateRegisterFee(AdmRowId, NewInvoiceId) As %String
{
	s ^tmpUpdateRegisterFee(AdmRowId,NewInvoiceId)=""
	s RegFeeRowId=0
	s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM"," "_AdmRowId,0))
	
	if NewInvoiceId'="" {
			&SQL(Update SQLUser.DHCRegistrationFee Set Regfeetemp1=:NewInvoiceId Where %Id=:RegFeeRowId)
			if SQLCODE {
				TRollback
				Q "-204"
			}
		}
	
	
	q SQLCODE
}

// w ##class(web.RoutineworkD).getZZJAliWei("64895","64895")

ClassMethod getZZJAliWei(sdate, edate) As %String
{
	s accid="",sub="",paymodesub="",AliSum=0,AliNum=0,WeiSum=0,WeiNum=0
	s MNAliSum=0,MNAliNum=0,MNWeiSum=0,MNWeiNum=0
	f idate=sdate:1:edate  d
	.f  s accid=$O(^DHCACDi("AccM",0,"APDDate",idate,accid))  q:accid=""  d
	..f  s sub=$O(^DHCACDi("AccM",0,"APDDate",idate,accid,"AccPD",sub))  q:sub=""  d
	...s Amount=$p(^DHCACD("AccM",accid,"AccPD",sub),"^",2)
	...s user=$p(^DHCACD("AccM",accid,"AccPD",sub),"^",5)
	...i user="2126"  s user="2889"
	...s usergroup=$p(^SSU("SSUSR",user),"^",5)
	...q:usergroup'="10"
	...q:user="2499"
 	...q:user="2498"
 	...q:user="2611"
 	...q:user="2612"
 	...;q:user="2661"
 	...s Username=$p(^SSU("SSUSR",user),"^",2)
 	...f  s paymodesub=$O(^DHCACD("AccM",accid,"AccPD",sub,"P",paymodesub))  q:paymodesub=""  d
 	....s paymode=$p(^DHCACD("AccM",accid,"AccPD",sub,"P",paymodesub),"^",1)
	....s paymodeamount=$p(^DHCACD("AccM",accid,"AccPD",sub,"P",paymodesub),"^",6)
	....s:(paymode="36")&(Username'["迷你") AliSum=AliSum+paymodeamount,AliNum=AliNum+1
	....s:(paymode="37")&(Username'["迷你") WeiSum=WeiSum+paymodeamount,WeiNum=WeiNum+1
	....s:(paymode="36")&(Username["迷你") MNAliSum=MNAliSum+paymodeamount,MNAliNum=MNAliNum+1
	....s:(paymode="37")&(Username["迷你") MNWeiSum=MNWeiSum+paymodeamount,MNWeiNum=MNWeiNum+1
	....if (paymode="37")&(user="2661") d
	.....;w !,accid_"||"_sub_"  "_user_" "_paymodeamount
	
	
	
	q AliSum_"^"_AliNum_"^"_WeiSum_"^"_WeiNum_"^"_MNAliSum_"^"_MNAliNum_"^"_MNWeiSum_"^"_MNWeiNum
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","MZLocFee","2020-06-25","2020-06-25")

/// /麻醉科医嘱报表
ClassMethod MZLocFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MZLocFeeExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod MZLocFeeExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	;n (SDate,EDate,InsuType)
	Set repid=$I(^CacheTemp)
	s ind=1
	s YGT=""
	k ^tmpMZLocFee  
	;=$lb(SDate,EDate,PatType,RYLX,SNSW)
	;s ^tmpmzloc=SDate_"#"_EDate
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	;q:SDate="" $$$OK
	;q:EDate="" $$$OK
	F iDate=SDate:1:EDate D
	.set WorkID=""
	.f  s WorkID=$O(^DHCWorkLoad(0,"ORDDATE",iDate,WorkID))  q:WorkID=""  d
	..s admType=$p(^DHCWorkLoad(WorkID),"^",4)
	..q:admType'="I"
	..s Taritem=$p(^DHCWorkLoad(WorkID),"^",22) //收费项
	..s Amt=$p(^DHCWorkLoad(WorkID),"^",16) //金额
	..s KDLoc=$p(^DHCWorkLoad(WorkID),"^",23) //开单科室
	..s PatLoc=$p(^DHCWorkLoad(WorkID),"^",3) //病人科室
	..s KDDoc=$p(^DHCWorkLoad(WorkID),"^",19) //开单医生
	..s TarItemCat=$p(^DHCTARI(Taritem),"^",5)
	..s FeeType=""
	..s ^tmpMZLocFee(PatLoc)=$g(^tmpMZLocFee(PatLoc))+Amt
	..s:TarItemCat="9" FeeType="耗材"
	..s:(TarItemCat="1")||(TarItemCat="12")||(TarItemCat="13") FeeType="药品"
	..if (FeeType'="") d
	...;s ^tmpMZLocFee(PatLoc,KDLoc,FeeType)=$G(^tmpMZLocFee(PatLoc,KDLoc,FeeType))+Amt,^tmpMZLocFee(PatLoc,FeeType)=$g(^tmpMZLocFee(PatLoc,FeeType))+Amt
	...s ^tmpMZLocFee(PatLoc,FeeType)=$g(^tmpMZLocFee(PatLoc,FeeType))+Amt
	...s KDLocDesc=$p(^CTLOC(KDLoc),"^",1)
	...s:(KDLocDesc["麻醉")||(KDLocDesc["手术室") ^tmpMZLocFee(PatLoc,FeeType,"麻醉")=$g(^tmpMZLocFee(PatLoc,FeeType,"麻醉"))+Amt
	...s:(KDLocDesc'["麻醉")&&(KDLocDesc'["手术室") ^tmpMZLocFee(PatLoc,FeeType,"科室")=$g(^tmpMZLocFee(PatLoc,FeeType,"科室"))+Amt
	
	set TPatLoc="",TKDLoc="",TFeeType=""
	set LocTotal=0,LocToatlYP=0,LocToatlCL=0
	set LocToatlYPZB=0,LocToatlCLZB=0
	
	set PatLocYPFee=0,PatLocCLFee=0
	set PatLocYPFeeZB=0,PatLocCLFeeZB=0
	
	set MZLocYPFee=0,MZLocCLFee=0
	set MZLocYPFeeZB=0,MZLocCLFeeZB=0
	
	set TFeetype="",TPatLoc=""
	for  s TPatLoc=$O(^tmpMZLocFee(TPatLoc))  q:TPatLoc=""  d
	.set LocDesc=$p(^CTLOC(TPatLoc),"^",1)
	.set LocTotal=$g(^tmpMZLocFee(TPatLoc))
	.q:LocTotal="0"
	.set LocToatlYP=$g(^tmpMZLocFee(TPatLoc,"药品"))
	.set LocToatlCL=$g(^tmpMZLocFee(TPatLoc,"耗材"))
	.set LocToatlYPZB=(LocToatlYP/LocTotal)
	.set LocToatlYPZB=$j(LocToatlYPZB,3,4)*100_"%"
	.set LocToatlCLZB=(LocToatlCL/LocTotal)
	.set LocToatlCLZB=$j(LocToatlCLZB,3,4)*100_"%"
	.set PatLocYPFee=+$g( ^tmpMZLocFee(TPatLoc,"药品","科室"))
	.set PatLocCLFee=+$g( ^tmpMZLocFee(TPatLoc,"耗材","科室"))
	.set PatLocYPFeeZB=(PatLocYPFee/LocTotal)
	.set PatLocYPFeeZB=$j(PatLocYPFeeZB,3,4)*100_"%"
	.set PatLocCLFeeZB=(PatLocCLFee/LocTotal)
	.set PatLocCLFeeZB=$j(PatLocCLFeeZB,3,4)*100_"%"
	.set MZLocYPFee=+$g( ^tmpMZLocFee(TPatLoc,"药品","麻醉"))
	.set MZLocCLFee=+$g( ^tmpMZLocFee(TPatLoc,"耗材","麻醉"))
	
	
	.set MZLocYPFeeZB=(MZLocYPFee/LocTotal)
	.set MZLocYPFeeZB=$j(MZLocYPFeeZB,3,4)*100_"%"
	
	.set MZLocCLFeeZB=(MZLocCLFee/LocTotal)
	.set MZLocCLFeeZB=$j(MZLocCLFeeZB,3,4)*100_"%"
	
	

    .d BuildTarCateMZ
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCateMZ     
	set Data=$lb(LocDesc,LocTotal,LocToatlYP,LocToatlCL,LocToatlYPZB,LocToatlCLZB,PatLocYPFee,PatLocCLFee,PatLocYPFeeZB,PatLocCLFeeZB,MZLocYPFee,MZLocCLFee,MZLocYPFeeZB,MZLocCLFeeZB)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod MZLocFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MZLocFeeExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query MZLocFee(SDate, EDate) As %Query(ROWSPEC = "LocDesc,LocTotal,LocToatlYP,LocToatlCL,LocToatlYPZB,LocToatlCLZB,PatLocYPFee,PatLocCLFee,PatLocYPFeeZB,PatLocCLFeeZB,MZLocYPFee,MZLocCLFee,MZLocYPFeeZB,MZLocCLFeeZB") [ SqlProc ]
{
}

// 以收费项目为基准不按照workload的工作量进行报表的统计

// gongzuoliang d ##class(%ResultSet).RunQuery("web.RoutineworkE","queQTbyItemAllLoc","2019-09-01","2019-09-01","","诊疗","")

Query queQTbyItemAllLoc(startDate As %String, endDate As %String, AdmLoc As %String, ItemCate As %String, AdmType As %String, QueryType As %String) As %Query(ROWSPEC = "TAdmLocdesc,TPatWarddesc,tarcode,tardesc,TQty,TAmt") [ SqlProc ]
{
}

ClassMethod queQTbyItemAllLocExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, AdmLoc As %String, ItemCate As %String, PatType As %String, QueryType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" $$$OK
 	q:endDate="" $$$OK
 	s ^tmpitemtb=startDate_"^"_endDate_"^"_AdmLoc_"^"_ItemCate_"^"_PatType
 	s:AdmLoc="" AdmLoc="NULL"
 	s:PatType="" PatType="NULL"
 	s rowidend="",rowid="",workloadID="",Idate="",totalmoney="",total=0
 	s Wtype="",WtaID="",tarcode="",tardesc="",Wtotalp="",Wsinp="",cat=""
 	s code="",desc="",sum=0,row1="",row2="",newprice="",oldprice="",qty=0
 	s flag=""
 	k ^wangchaoTEEMP4($j)
	s:startDate["-" startDate=$zdh(startDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	if (QueryType="MX")
	{
	f Idate=startDate:1:endDate  d
    .s workloadID="" f  s workloadID=$o(^DHCWorkLoad(0,"ORDDATE",Idate,workloadID))  q:workloadID=""  d
	..s Wtype=$p(^DHCWorkLoad(workloadID),"^",4)  ;病人类型
	..q:((Wtype'=PatType)&&(PatType'="NULL"))
	..s KDKS=$p(^DHCWorkLoad(workloadID),"^",23) //开单科室
	..;q:(KDKS'="79")&(KDKS'="80")&(KDKS'="95")&(KDKS'="81")
	..q:(KDKS'=AdmLoc)&(AdmLoc'="NULL")
	..s BRBQ=$p(^DHCWorkLoad(workloadID),"^",24) //病人所在病区
	..s:BRBQ="" BRBQ=$p(^DHCWorkLoad(workloadID),"^",3)
	..s WtaID=$p(^DHCWorkLoad(workloadID),"^",22)
	..s tarcode=$p(^DHCTARI(WtaID),"^",1)
	..s tardesc=$p(^DHCTARI(WtaID),"^",2)
	..s Wtotalp=$p(^DHCWorkLoad(workloadID),"^",16)  ;金额
	..s Wqty=$p(^DHCWorkLoad(workloadID),"^",15)  ;金额
	..s Wsinp=$p(^DHCWorkLoad(workloadID),"^",14)  ;单价
	..s cat=$p(^DHCTARI(WtaID),"^",5)
	..s codeflag=""
	..s:ItemCate="" ItemCate="诊疗"
	..s:(ItemCate="诊疗")&&(cat'=1)&&(cat'=9)&&(cat'=12)&&(cat'=13) codeflag="1"
	..s:(ItemCate="药品")&&((cat=1)||(cat=12)||(cat=13)) codeflag="1"
	..s:(ItemCate="材料")&&(cat=9) codeflag="1"
	..s:(ItemCate="全部") codeflag="1"
	..q:codeflag'="1"
	
	..;s ^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Amt")=$g(^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Amt"))+Wtotalp
	..;s ^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Qty")=$g(^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Qty"))+Wqty
	..s ^wangchaoTEEMP4($j,BRBQ,KDKS,WtaID,"Amt")=$g(^wangchaoTEEMP4($j,BRBQ,KDKS,WtaID,"Amt"))+Wtotalp
	..s ^wangchaoTEEMP4($j,BRBQ,KDKS,WtaID,"Qty")=$g(^wangchaoTEEMP4($j,BRBQ,KDKS,WtaID,"Qty"))+Wqty
	;zw ^wangchaoTMP($j)
	
	s TAdmLoc="",TPatWard="",TItemID=""
	
	f  s TAdmLoc=$O(^wangchaoTEEMP4($j,TAdmLoc))  q:TAdmLoc=""  d
	.f  s TPatWard=$O(^wangchaoTEEMP4($j,TAdmLoc,TPatWard))  q:TPatWard=""  d
	..f  s TItemID=$O(^wangchaoTEEMP4($j,TAdmLoc,TPatWard,TItemID))  q:TItemID=""  d
	...s TAdmLocdesc=$p(^CTLOC(TAdmLoc),"^",1)
	...s TPatWarddesc=$p(^CTLOC(TPatWard),"^",1)
	...s tarcode=$p(^DHCTARI(TItemID),"^",1)
	...s tardesc=$p(^DHCTARI(TItemID),"^",2)
	...s TQty=+$G(^wangchaoTEEMP4($j,TAdmLoc,TPatWard,TItemID,"Qty"))
	...s TAmt=+$G(^wangchaoTEEMP4($j,TAdmLoc,TPatWard,TItemID,"Amt"))
	...s sum=sum+TAmt
	...d Outputworkitem2
	}
  if (QueryType="HZ")
	{
	f Idate=startDate:1:endDate  d
    .s workloadID="" f  s workloadID=$o(^DHCWorkLoad(0,"ORDDATE",Idate,workloadID))  q:workloadID=""  d
	..s Wtype=$p(^DHCWorkLoad(workloadID),"^",4)  ;病人类型
	..q:((Wtype'=PatType)&&(PatType'="NULL"))
	..s KDKS=$p(^DHCWorkLoad(workloadID),"^",23) //开单科室
	..;q:(KDKS'="79")&(KDKS'="80")&(KDKS'="95")&(KDKS'="81")
	..q:(KDKS'=AdmLoc)&(AdmLoc'="NULL")
	..s BRBQ=$p(^DHCWorkLoad(workloadID),"^",24) //病人所在病区
	..s:BRBQ="" BRBQ=$p(^DHCWorkLoad(workloadID),"^",3)
	..s WtaID=$p(^DHCWorkLoad(workloadID),"^",22)
	..s tarcode=$p(^DHCTARI(WtaID),"^",1)
	..s tardesc=$p(^DHCTARI(WtaID),"^",2)
	..s Wtotalp=$p(^DHCWorkLoad(workloadID),"^",16)  ;金额
	..s Wqty=$p(^DHCWorkLoad(workloadID),"^",15)  ;金额
	..s Wsinp=$p(^DHCWorkLoad(workloadID),"^",14)  ;单价
	..s cat=$p(^DHCTARI(WtaID),"^",5)
	..s codeflag=""
	..s:ItemCate="" ItemCate="诊疗"
	..s:(ItemCate="诊疗")&&(cat'=1)&&(cat'=9)&&(cat'=12)&&(cat'=13) codeflag="1"
	..s:(ItemCate="药品")&&((cat=1)||(cat=12)||(cat=13)||(cat=15)) codeflag="1"
	..s:(ItemCate="材料")&&(cat=9) codeflag="1"
	..s:(ItemCate="全部") codeflag="1"
	..q:codeflag'="1"
	..s ItemCateA=""
	..s:(cat=9) ItemCateA="材料"
	..s:((cat=1)||(cat=12)||(cat=13)||(cat=15)) ItemCateA="药品"
	..s:((cat=2)||(cat=3)||(cat=4)||(cat=5)||(cat=6)||(cat=7)||(cat=8)||(cat=10)||(cat=11)||(cat=14)) ItemCateA="诊疗"
	..;s ^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Amt")=$g(^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Amt"))+Wtotalp
	..;s ^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Qty")=$g(^wangchaoTEEMP4($j,KDKS,BRBQ,WtaID,"Qty"))+Wqty
	..s ^wangchaoTEEMP4($j,BRBQ,KDKS,ItemCateA,"Amt")=$g(^wangchaoTEEMP4($j,BRBQ,KDKS,ItemCateA,"Amt"))+Wtotalp
	..s ^wangchaoTEEMP4($j,BRBQ,KDKS,ItemCateA,"Qty")=$g(^wangchaoTEEMP4($j,BRBQ,KDKS,ItemCateA,"Qty"))+Wqty
	;zw ^wangchaoTMP($j)
	
	s TAdmLoc="",TPatWard="",TItemCateA=""
	
	f  s TAdmLoc=$O(^wangchaoTEEMP4($j,TAdmLoc))  q:TAdmLoc=""  d
	.f  s TPatWard=$O(^wangchaoTEEMP4($j,TAdmLoc,TPatWard))  q:TPatWard=""  d
	..f  s TItemCateA=$O(^wangchaoTEEMP4($j,TAdmLoc,TPatWard,TItemCateA))  q:TItemCateA=""  d
	...s TAdmLocdesc=$p(^CTLOC(TAdmLoc),"^",1)
	...s TPatWarddesc=$p(^CTLOC(TPatWard),"^",1)
	...s tarcode=TItemCateA
	...s tardesc=TItemCateA
	...s TQty=+$G(^wangchaoTEEMP4($j,TAdmLoc,TPatWard,TItemCateA,"Qty"))
	...s TAmt=+$G(^wangchaoTEEMP4($j,TAdmLoc,TPatWard,TItemCateA,"Amt"))
	...s sum=sum+TAmt
	...d Outputworkitem2
	}
	
	Quit $$$OK
	
Outputworkitem2
    s Data=$lb(TAdmLocdesc,TPatWarddesc,tarcode,tardesc,TQty,TAmt)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod queQTbyItemAllLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = queQTbyItemAllLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod queQTbyItemAllLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = queQTbyItemAllLocExecute ]
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

// w ##class(web.RoutineworkD).UpdateWMIPRefundNo("<head><jigoubh></jigoubh><huanzheid></huanzheid><jiuzhenid></jiuzhenid><binganhao></binganhao><jiezhilx></jiezhilx><jiezhihm></jiezhihm><xingming></xingming><shenfenzh></shenfenzh><pingtaijsbh>123415</pingtaijsbh><yuanneitfbh>TF5</yuanneitfbh><tuifeije></tuifeije><tuifeisj></tuifeisj><beizhu></beizhu></head>")

ClassMethod UpdateWMRegRefundTrade(Input As %String) As %String
{
	Set $zt="UpdateWMRegRefundTrade"
	set InputObj=##class(web.WMIPRefund.MSG.UpdateIPRefundRequest).%New()
	b ;2
	set OutObj=##class(web.WMIPRefund.MSG.UpdateIPRefundResponse).%New()
	b ;1
	set OutObjlist=##class(web.WMIPRefund.MSG.WMIPRefundList).%New()
	b ;3
	Do InputObj.XMLNodeDeserialize(.InputObj,"head",Input)
	Set pingtaijsbh=InputObj.pingtaijsbh //平台结算编号
	Set yuanneitfbh=InputObj.yuanneitfbh //院内退费编号
	q:'$d(^DHCINVPRT(0,"InitInvDR",yuanneitfbh)) "<wemay><retcode>-2</retcode><retmessage>失败,HIS无此订单</retmessage></wemay>"
	set SubPrtID=$O(^DHCINVPRT(0,"InitInvDR",yuanneitfbh,SubPrtID))
	
	
	set rtn=..UpdateRefunRegTransNo(yuanneitfbh,SubPrtID,pingtaijsbh)
	b ;4
	if rtn="0" 
	{
	set OutObjlist=##class(web.WMIPRefund.MSG.WMIPRefundList).%New()
	set OutObjlist.yuanneitfbh=yuanneitfbh
	set OutObjlist.yuanneitfsj=RefundDate_" "_RefundTime
	set OutObjlist.yuanneitfje=RefundAmt
	Do OutObj.ParmOutZhuYuanTFQR.Insert(OutObjlist)
	Do OutObj.%Close() 
	b ;1
	set OutObj.retcode="0"
	set OutObj.retmessage="成功"
	d OutObj.XMLExportToString(.string,"wemay")
	b ;1
	d OutObj.%Close()
 	q string 
	}
	else
	{
	set OutObj.retcode="-1"
	set OutObj.retmessage="失败"	
	d OutObj.XMLExportToString(.string,"wemay")
	d OutObj.%Close()
 	q string 	
		
	}
	
	
	
UpdateWMRegRefundTrade
	set OutObj.retcode="-1"
	set OutObj.retmessage="失败"_$ze	
	d OutObj.XMLExportToString(.string,"wemay")
	d OutObj.%Close()
 	q string
}

// w ##class(web.RoutineworkD).UpdateRefunRegTransNo("7762840","7762990","1966571428794372")

ClassMethod UpdateRefunRegTransNo(yuanneitfbh, SubPrtID, pingtaijsbh) As %String
{
	s wmid=""
	s Neddid=""
	f  s wmid=$O(^WMRegisterSerialINV("INV",yuanneitfbh,wmid)) q:wmid=""  d
	.s Amt=$p(^WMRegisterSerial(wmid),"^",1)
	.q:Amt>0
	.s Neddid=wmid
	q:Neddid="" "-1"
	if ($d(^WMRegisterSerial(Neddid)))
	{
	&sql(Update WMRegisterSerial set WMAReg_Ser=:pingtaijsbh where ID=:Neddid)
	&sql(Update WMRegisterSerial set WMAReg_Inv=:SubPrtID where ID=:Neddid)
	}
	
	q SQLCODE
}

// 2017当前在院病人信息院长查询用  d ##CLASS(%ResultSet).RunQuery("web.RoutineworkD","NowInpatInfo","一病区(儿科)")

ClassMethod NowInpatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NowInpatInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod NowInpatInfoExecute(ByRef qHandle As %Binary, PacWard As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	s DivID="",PB=""
	s Statue=""
	;s:EDate="" EDate=$h
	;s:SDate="" SDate=$h
	;s:SDate["-" SDate=$zdh(SDate,3)
	;s:EDate["-" EDate=$zdh(EDate,3)
	s ctid="",Date="",Time="",Admid=""
	f  s ctid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid))  q:ctid=""  d
	.f  s Date=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date)) q:Date=""  d
	..f  s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time)) q:Time=""  d
	...f  s Admid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time,Admid)) q:Admid=""  d
	....s Monthid=$p(^PAADM(Admid),"^",75)
	....s papmi=$p(^PAADM(Admid),"^",1)
	....s Patname=$p(^PAPER(papmi,"ALL"),"^",1)
	....s PatNO=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s wardid=$p(^PAADM(Admid),"^",70)
	....s ctloc=$P(^PAWARD(wardid),"^",2)
	....s Bed=$p(^PAADM(Admid),"^",73)
	....s Monthid=$p(^PAADM(Admid),"^",75)
	....q:Monthid'=""
	....s BedNO=""
	....s:Bed'="" BedNO=$p(^PAWARD(+Bed,"BED",$p(Bed,"||",2)),"^",1)
	....s:Statue'="" Statue="在院患者"
	....s:BedNO="" Statue="等待区患者"
	....s PacWardCode=$p(^PAWARD(wardid),"^",2)
	....q:PacWardCode'=PacWard
	....d BuildPatinfo
	
	/*k ^tmppatinfo
	f  s ctid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid))  q:ctid=""  d
	.f  s Date=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date)) q:Date=""  d
	..f  s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time)) q:Time=""  d
	...f  s Admid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time,Admid)) q:Admid=""  d
	....s Monthid=$p(^PAADM(Admid),"^",75)
	....s wardid=$p(^PAADM(Admid),"^",70)
	....s ctloc=$P(^PAWARD(wardid),"^",1)
	....s Bed=$p(^PAADM(Admid),"^",73)
	....s BWFlag=##class(web.Routinework).GetPatBWBZ(Admid)
	....;w !,Admid_"  "_BWFlag
	....s:Monthid="" ^tmppatinfo($j,ctloc)=$g(^tmppatinfo($j,ctloc))+1
	....s:(Monthid="")&(Bed'="") ^tmppatinfo($j,ctloc,"Bed")=$g(^tmppatinfo($j,ctloc,"Bed"))+1
	....s:BWFlag=1 ^tmppatinfo($j,ctloc,"BW")=$g(^tmppatinfo($j,ctloc,"BW"))+1
	....s:BWFlag=2 ^tmppatinfo($j,ctloc,"BZ")=$g(^tmppatinfo($j,ctloc,"BZ"))+1
	....s:BWFlag=3 ^tmppatinfo($j,ctloc,"WZ")=$g(^tmppatinfo($j,ctloc,"WZ"))+1
	....s:Monthid'="" ^tmppatinfo($j,ctloc,"Newborn")=$g(^tmppatinfo($j,ctloc,"Newborn"))+1
	....s:(Date=+$h)&(Monthid="") ^tmppatinfo($j,ctloc,"NewPat")=$g(^tmppatinfo($j,ctloc,"NewPat"))+1
	
	s Adm=""
	
	f  s Adm=$O(^PAADMi("DischDate",+$h,Adm))  q:Adm=""  d
	.s Monthid=$p(^PAADM(Adm),"^",75)
	.q:Monthid'=""
	.s wardid=$p(^PAADM(Adm),"^",70)
	.s ctloc=$P(^PAWARD(wardid),"^",1)
	.s Admdate=$p(^PAADM(Adm),"^",6)
	.s:Admdate=+$h ^tmppatinfo($j,ctloc,"NewPat")=$g(^tmppatinfo($j,ctloc,"NewPat"))+1
	.s ^tmppatinfo($j,ctloc,"Disc")=$g(^tmppatinfo($j,ctloc,"Disc"))+1
	
	
	
	
	
	
	
	s a="",b=0,c=0,d=0,e=0,f=0,g=0,h=0
	f  s a=$O(^tmppatinfo($j,a))  q:a=""   d
	.s b=$g(^tmppatinfo($j,a))
	.s c=$g(^tmppatinfo($j,a,"NewPat"))
	.s d=$g(^tmppatinfo($j,a,"Newborn"))
	.s e=$g(^tmppatinfo($j,a,"Disc"))
	.s f=$g(^tmppatinfo($j,a,"BW"))
	.s g=$g(^tmppatinfo($j,a,"BZ"))
	.s h=$g(^tmppatinfo($j,a,"WZ"))
	.s i=$g(^tmppatinfo($j,a,"Bed"))
	.s:b="" b=0   //当前在院
	.s:c="" c=0	  //新入院
	.s:d="" d=0   //新出生
	.s:e="" e=0  // 出院病人
	.s:f="" f=0  // 病危
	.s:g="" g=0  //病重
	.s:h="" h=0  //危重
	.s:i="" i=0  //在床病人
    .d BuildPatinfo*/
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildPatinfo   
	set Data=$lb(ind,PatNO,Patname,PacWardCode,BedNO,Statue)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod NowInpatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NowInpatInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query NowInpatInfo(PacWard) As %Query(ROWSPEC = "ind,PatNO,Patname,PacWardCode,BedNO,Statue") [ SqlProc ]
{
}

// d ##class(web.RoutineworkD).AdmTime("2020-01-01","2020-07-01")

ClassMethod AdmTime(SDate, EDate) As %String
{
	
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	s Adm=""
	s MrSub=""
	s EmerNum=0,NorNum=0,InPatNum=0
	s MrSub=0
	f idate=SDate:1:EDate  d
	.f  s Adm=$O(^PAADMi("PAADM_AdmDate",idate,Adm))  q:Adm=""  d
	..s Stat=$P($g(^PAADM(Adm)),"^",20)
	..q:Stat="C"
	..s AdmType=$P($G(^PAADM(Adm)),"^",2)
	..q:AdmType="I"
	..s AdmLoc=$p(^PAADM(Adm),"^",4)
	..s LocDesc=$p(^CTLOC(AdmLoc),"^",1)
	..s AdmTime=$p(^PAADM(Adm),"^",42)
	..s MrAdm=$p(^PAADM(Adm),"^",61)
	..s papmi=$p(^PAADM(Adm),"^",1)
	..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s Regno=$p(($g(^PAPER(papmi,"PAT",1))),"^",1)
	..s MrTime2=..GetDiagTime(MrAdm)
	..;w !,$zt(MrTime2,1)_"^"_$zt(AdmTime,1)_"^"_$fn((MrTime2-AdmTime)/60,"",0)
	
	..if +MrTime2'=0 d
	...s subcount=$fn((MrTime2-AdmTime)/60,"",0)
	...s:(subcount<0)&(subcount>-1440) subcount=subcount+1440
	...w !,Regno_"^"_patname_"^"_LocDesc_"^"_Adm_"^"_$zd(idate,3)_"^"_$zt(AdmTime,1)_"^"_$zt(MrTime2,1)_"^"_subcount
	..else  d
	...w !,Regno_"^"_patname_"^"_LocDesc_"^"_Adm_"^"_$zd(idate,3)_"^"_$zt(AdmTime,1)_"^"_""_"^"_""
}

ClassMethod GetDiagTime(MrAdm) As %String
{
	s MrTime2=""
	s MrSub=""
	f  s MrSub=$O(^MR(MrAdm,"DIA",MrSub))  q:MrSub=""  d
	.s MrTime=$p(^MR(MrAdm,"DIA",MrSub),"^",20)
	.q:(MrTime>MrTime2)&(MrTime2'="")
	.s MrTime2=MrTime
	q MrTime2
}

// d ##class(web.RoutineworkD).AdmTimeMZBL("2019-01-01","2019-12-31")

ClassMethod AdmTimeMZBL(SDate, EDate) As %String
{
	
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	s Adm=""
	s MrSub=""
	s EmerNum=0,NorNum=0,InPatNum=0
	s MrSub=0
	f idate=SDate:1:EDate  d
	.f  s Adm=$O(^PAADMi("PAADM_AdmDate",idate,Adm))  q:Adm=""  d
	..s Stat=$P($g(^PAADM(Adm)),"^",20)
	..q:Stat="C"
	..s AdmType=$P($G(^PAADM(Adm)),"^",2)
	..q:AdmType="I"
	..s AdmLoc=$p(^PAADM(Adm),"^",4)
	..s LocDesc=$p(^CTLOC(AdmLoc),"^",1)
	..s AdmTime=$p(^PAADM(Adm),"^",42)
	..s MrAdm=$p(^PAADM(Adm),"^",61)
	..s papmi=$p(^PAADM(Adm),"^",1)
	..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s Regno=$p(($g(^PAPER(papmi,"PAT",1))),"^",1)
	..s MZBLFlag=..MZBLFlagMethod(Adm)
	..s:MZBLFlag<0 MZBLFlag="未写"
	..s:MZBLFlag=0 MZBLFlag="完成书写"
	..w !,Regno_"^"_patname_"^"_LocDesc_"^"_Adm_"^"_$zd(idate,3)_"^"_$zt(AdmTime,1)_"^"_MZBLFlag
}

ClassMethod MZBLFlagMethod(Adm)
{
	set recordID=""
	set EprID=""
	&sql(SELECT ID into:recordID FROM eprinstance.ecrecord WHERE EpisodeID=:Adm)
	q:recordID="" "-1"
	&sql(SELECT  ID into:EprID FROM  eprinstance. instancedata WHERE TheECRecord =:recordID AND TemplateID='302')
	q:EprID="" "-2"
	
	q 0
}

}
