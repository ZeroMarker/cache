Import SQLUser

Class web.DHCPE.DHCPEUSERREPORT Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 441;

ClassMethod getPDbyUserOld(userid As %Library.String = "") As %String
{
   q:userid="" "-1"
   q:'$d(^DHCPEINVPRT(0,"USER",userid)) "-2"
   k pdPLIST
   s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
   s footnum=0,refundnum=0,rcptstr="",RefInvNoStr=""
   s stdate="",sttime="",enddate="",endtime=""
   s rtn=..getUserPDFootLastOld(userid)
   i +rtn>"0"  s stdate=$p(rtn,"^",2),sttime=$p(rtn,"^",3)
   s prtid=0
   f  s prtid=$o(^DHCPEINVPRT(0,"RPFLAG",userid,"N",prtid)) q:prtid=""  d
   .i (+rtn="0")&(footnum=0)  d
   ..s stdate=$p(^DHCPEINVPRT(prtid),"^",11)
   ..i stdate'=""  s stdate=$ZD(stdate,4)
   ..s sttime=$p(^DHCPEINVPRT(prtid),"^",12)
   ..i sttime'=""  s sttime=$ZT(sttime)
   .s footnum=footnum+1
   .s prtflag=$p(^DHCPEINVPRT(prtid),"^",8)
   .i prtflag="S"  d
   ..s refundnum=refundnum+1
   ..s refinvid=$p(^DHCPEINVPRT(prtid),"^",9)
   ..s tmprefinvno=""
   ..i refinvid'="" s tmprefinvno=$p($g(^DHCPEINVPRT(refinvid)),"^",1)
   ..i tmprefinvno'=""  d
   ...i RefInvNoStr="" s RefInvNoStr=tmprefinvno
   ...e  s RefInvNoStr=RefInvNoStr_","_tmprefinvno
   .s pdPLIST(footnum)=prtid
   .s pdPLIST=footnum
   
dhcsfbuy
   .s arrcp=$p(^DHCPEINVPRT(prtid),"^",4)
   .s paym="0"
   .f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
   ..s ss=^ARRCP(arrcp,"PAYM",paym)
   ..s mode=$p(ss,"^",1)
   ..i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
   ..e  s pmdesc="现金"
   ..s pdamt=+$p(ss,"^",3)
   ..i pmdesc="现金" s cashsum=cashsum+pdamt
   ..i pmdesc="支票" s chequesum=chequesum+pdamt
   ..s footsum=footsum+pdamt
   ..i pdamt>0  s pdsum=pdsum+pdamt
   ..i pdamt<0  s refundsum=refundsum-pdamt
   .s receiptsno=$p(^DHCPEINVPRT(prtid),"^",1)
   .s rcptstr=..getrcptstr(rcptstr,receiptsno,"1",userid)
   .
   q:footnum=0 "-2"
   s othersum=footsum-cashsum-chequesum
   s enddate=$ZD(+$H,4),endtime=$ZT($p($H,",",2))
   s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr_"^"_RefInvNoStr
   q rtn
}

ClassMethod getUserPDFootLastOld(userid As %Library.String = "") As %String
{
   q:'$d(^DHCPEUSERREPORT(0,"USER",userid)) "0^^^^"
   s lastfootdate1="",lastfoottime1=""
   s lastfootid=$o(^DHCPEUSERREPORT(0,"USER",userid,""),-1)
   
   s lastfootdate=$p(^DHCPEUSERREPORT(lastfootid),"^",2)
   i lastfootdate'=""  s lastfootdate1=$ZD(lastfootdate,4)
   s lastfoottime=$p(^DHCPEUSERREPORT(lastfootid),"^",3)
   i lastfoottime'=""  s lastfoottime1=$ZT(lastfoottime)
   
   q lastfootid_"^"_lastfootdate1_"^"_lastfoottime1_"^"_lastfootdate_"^"_lastfoottime
}

// w ##class(web.DHCPE.DHCPEUSERREPORT).getrcptstr(rcptstr,"",1)

ClassMethod getrcptstr(rcptstr As %Library.String = "", receiptsno As %Library.String = "", Type As %Library.String = "1", User = "") As %String
{
	i User="" s User=%session.Get("LOGON.USERID")
	s ZMLength=##class(web.DHCPE.DHCPECommon).GetStrNum(receiptsno)
	i Type'="2"
	{
   		s p="-"
   		q:receiptsno="" rcptstr
   		i Type="1" s ^TEMPDHCPEInv($J,User,receiptsno)=""
   		q:rcptstr="" receiptsno_p_receiptsno
   		s len=$l(rcptstr,p)
   		s endno=$p(rcptstr,p,len),tmpstr1=$p(rcptstr,p,1,len-1)
   		//i (+receiptsno)-(+endno)=1  s rcptstr=tmpstr1_p_receiptsno q rcptstr
   		i ($e(receiptsno,ZMLength,$l(receiptsno)))-($e(endno,ZMLength,$l(endno)))=1 s rcptstr=tmpstr1_p_receiptsno q rcptstr
   		s rcptstr=rcptstr_","_receiptsno_p_receiptsno
   		
   		q rcptstr
	}
	else
	{
		s invno=""
		s rstr=""
		f  s invno=$o(^TEMPDHCPEInv($J,User,invno)) q:invno=""  d
		.s rstr=..getrcptstr(rstr,invno,"3",User)
		k ^TEMPDHCPEInv($J,User)
		q rstr
	}
}

// w ##class(web.DHCPE.DHCPEUSERREPORT).FootPDbyUser(3786,1,900) 

// 生成日报

ClassMethod FootPDbyUser(userid As %String, num As %String = "", sum As %String = "") As %String
{
   
   s rtn=..getPDbyUser(userid)
   q:+rtn<0 rtn
   s paylistinfo=$p(rtn,"&",2)
   s rtn=$p(rtn,"&",1)
   s pdnum0=+rtn
   q:(pdnum0'=num)&(num'="") "-3"
   s pdsum0=$p(rtn,"^",3)
   q:(+pdsum0'=+sum)&(sum'="") "-3"
   s str=rtn
   k PLIST
   s PLIST(2)=userid
   s PLIST(3)=+$H
   s PLIST(4)=$p($H,",",2)
   
   i $g(lastfootdate)'=""  s PLIST(5)=lastfootdate
   e  d
   .i $p(str,"^",9)'="" s PLIST(5)=$zdh($p(str,"^",9),4)
   i $g(lastfoottime)'=""  s PLIST(6)=lastfoottime
   e  d
   .i $p(str,"^",10)'=""  s PLIST(6)=$zth($p(str,"^",10),4)
   
   s InvStr=$p(str,"^",13)
   s RefStr=$p(str,"^",14)
   s PLIST(7)=""
   s PLIST(10)="N"
   s PLIST(15)=$p(str,"^",1)
   s PLIST(16)=$p(str,"^",2)
   s PLIST(17)=$p(str,"^",3)
   s PLIST(18)=$p(str,"^",4)
   s PLIST(19)=$p(str,"^",5)
   s PLIST(20)=$p(str,"^",6)
   s PLIST(21)=$p(str,"^",7)
   s PLIST(22)=$p(str,"^",8)
   s PLIST(23)="" //$p(str,"^",14)
   s PLIST(13)=$p(str,"^",30)  //四舍五入收入
   s PLIST(14)=$p(str,"^",31)  //四舍五入退费
   s $ZT="ERROR^DHCSSERR" d ..tb()
	
	&SQL(INSERT INTO DHC_PE_USERREPORT Values PLIST() )
	s rtn=SQLCODE,myRowID=%ROWID
	i myRowID'="" d
	.s $p(^DHCPEUSERREPORT(myRowID),"^",6)=InvStr
	.s $p(^DHCPEUSERREPORT(myRowID),"^",22)=RefStr
	i (rtn=0)&($g(myRowID)'="")  d          //s rtn=..DepositFootUpdate(myRowID)
	.s nowdate=+$H,nowtime=$p($H,",",2)
	.&sql(update DHC_PE_INVPRT set PRT_REPORT_DR=:myRowID,PRT_RPFLAG='Y',PRT_RPUSER_DR=:userid,PRT_RPDATE=:nowdate,PRT_RPTIME=:nowtime where PRT_User_DR=:userid and PRT_RPFLAG='N')
	.s rtn=SQLCODE
	.s:rtn=100 rtn=0
	s timestmp=$p(str,"^",15)      //Add 20080707               
    d ..RecordPayReciptNo(myRowID,userid,timestmp)  //Add 20080707
	s j=$l(paylistinfo,"#")
	for k=1:1:j 
	{
		if rtn=0 d
		.s payinfo=$p(paylistinfo,"#",k)
		.s paymode=$p(payinfo,"^",1)
		.s payamount=$p(payinfo,"^",2)
		.s normalamount=$p(payinfo,"^",3)
		.s normalnum=$p(payinfo,"^",4)
		.s refundamount=$p(payinfo,"^",5)
		.s refundnum=$p(payinfo,"^",6)
		.&SQL(Insert Into DHC_PE_UserReportPayMode(RPM_ParRef,RPM_PayMode_DR,RPM_PayAmount,RPM_NormalAmount,RPM_NormalNum,RPM_RefundAmount,RPM_RefundNum) values (:myRowID,:paymode,:payamount,:normalamount,:normalnum,:refundamount,:refundnum) )
		.s rtn=SQLCODE 		
	}
	i rtn'=0
	{
		TROLLBACK
		q rtn
	}
	&SQL(Update DHC_PE_APAmountChange Set APAC_Report_DR=:myRowID,APAC_1='Y' where APAC_UpdateUser_DR=:userid and APAC_1='N')
	i SQLCODE=100 s SQLCODE=0
	s rtn=SQLCODE
	i rtn=0
	{
		m ^DHCPEUserReportEx("CatFee",myRowID)=^DHCPEUserReportEx("Temp","CatFee",userid)
		m ^DHCPEUserReportEx("PayMode",myRowID)=^DHCPEUserReportEx("Temp","PayMode",userid)
		m ^DHCPEUserReportEx("InvNoStr",myRowID)=^DHCPEUserReportEx("Temp","InvNoStr",userid)
		m ^DHCPEUserReportEx("InvNoCount",myRowID)=^DHCPEUserReportEx("Temp","InvNoCount",userid)
		k ^DHCPEUserReportEx("Temp","CatFee",userid)
		k ^DHCPEUserReportEx("Temp","PayMode",userid)
		k ^DHCPEUserReportEx("Temp","InvNoStr",userid)
		k ^DHCPEUserReportEx("Temp","InvNoCount",userid)
		
		d ..tc()
		
	}
	else
	{
		TROLLBACK
	}
   	if rtn=0
   	{
	   	//调用生成卡月报
	   	d ##class(web.DHCPE.CardMonthReport).CreateReport(userid)
	   	q myRowID
   	}
	q rtn
}

// w ##class(web.DHCPE.DHCPEUSERREPORT).FootPDbyUser(3786,1,900) 

ClassMethod FootPDbyUserOLD(userid As %String, num As %String, sum As %String) As %String
{
   
   s rtn=..getPDbyUser(userid)
   q:+rtn<0 rtn
   s paylistinfo=$p(rtn,"&",2)
   s rtn=$p(rtn,"&",1)
   s pdnum0=+rtn
   q:pdnum0'=num "-3"
   s pdsum0=$p(rtn,"^",3)
   q:+pdsum0'=+sum "-3"
   s str=rtn
   k PLIST
   s PLIST(2)=userid
   s PLIST(3)=+$H
   s PLIST(4)=$p($H,",",2)
   
   i $g(lastfootdate)'=""  s PLIST(5)=lastfootdate
   e  d
   .i $p(str,"^",9)'="" s PLIST(5)=$zdh($p(str,"^",9),4)
   i $g(lastfoottime)'=""  s PLIST(6)=lastfoottime
   e  d
   .i $p(str,"^",10)'=""  s PLIST(6)=$zth($p(str,"^",10),4)
   
   s InvStr=$p(str,"^",13)
   s RefStr=$p(str,"^",14)
   s PLIST(7)=""
   s PLIST(10)="N"
   s PLIST(15)=$p(str,"^",1)
   s PLIST(16)=$p(str,"^",2)
   s PLIST(17)=$p(str,"^",3)
   s PLIST(18)=$p(str,"^",4)
   s PLIST(19)=$p(str,"^",5)
   s PLIST(20)=$p(str,"^",6)
   s PLIST(21)=$p(str,"^",7)
   s PLIST(22)=$p(str,"^",8)
   s PLIST(23)="" //$p(str,"^",14)
   s PLIST(13)=$p(str,"^",30)  //四舍五入收入
   s PLIST(14)=$p(str,"^",31)  //四舍五入退费
   s $ZT="ERROR^DHCSSERR" d ..tb()
	
	&SQL(INSERT INTO DHC_PE_USERREPORT Values PLIST() )
	s rtn=SQLCODE,myRowID=%ROWID
	i myRowID'="" d
	.s $p(^DHCPEUSERREPORT(myRowID),"^",6)=InvStr
	.s $p(^DHCPEUSERREPORT(myRowID),"^",22)=RefStr
	i (rtn=0)&($g(myRowID)'="")  d          //s rtn=..DepositFootUpdate(myRowID)
	.s nowdate=+$H,nowtime=$p($H,",",2)
	.&sql(update DHC_PE_INVPRT set PRT_REPORT_DR=:myRowID,PRT_RPFLAG='Y',PRT_RPUSER_DR=:userid,PRT_RPDATE=:nowdate,PRT_RPTIME=:nowtime where PRT_User_DR=:userid and PRT_RPFLAG='N')
	.s rtn=SQLCODE
	.s:rtn=100 rtn=0
	s timestmp=$p(str,"^",15)      //Add 20080707               
    d ..RecordPayReciptNo(myRowID,userid,timestmp)  //Add 20080707
	s j=$l(paylistinfo,"#")
	for k=1:1:j 
	{
		if rtn=0 d
		.s payinfo=$p(paylistinfo,"#",k)
		.s paymode=$p(payinfo,"^",1)
		.s payamount=$p(payinfo,"^",2)
		.s normalamount=$p(payinfo,"^",3)
		.s normalnum=$p(payinfo,"^",4)
		.s refundamount=$p(payinfo,"^",5)
		.s refundnum=$p(payinfo,"^",6)
		.&SQL(Insert Into DHC_PE_UserReportPayMode(RPM_ParRef,RPM_PayMode_DR,RPM_PayAmount,RPM_NormalAmount,RPM_NormalNum,RPM_RefundAmount,RPM_RefundNum) values (:myRowID,:paymode,:payamount,:normalamount,:normalnum,:refundamount,:refundnum) )
		.s rtn=SQLCODE 		
	}
	i rtn'=0
	{
		TROLLBACK
		q rtn
	}
	&SQL(Update DHC_PE_APAmountChange Set APAC_Report_DR=:myRowID,APAC_1='Y' where APAC_UpdateUser_DR=:userid and APAC_1='N')
	i SQLCODE=100 s SQLCODE=0
	s rtn=SQLCODE
	i rtn=0
	{
		m ^DHCPEUserReportEx("CatFee",myRowID)=^DHCPEUserReportEx("Temp","CatFee",userid)
		m ^DHCPEUserReportEx("PayMode",myRowID)=^DHCPEUserReportEx("Temp","PayMode",userid)
		m ^DHCPEUserReportEx("InvNoStr",myRowID)=^DHCPEUserReportEx("Temp","InvNoStr",userid)
		m ^DHCPEUserReportEx("InvNoCount",myRowID)=^DHCPEUserReportEx("Temp","InvNoCount",userid)
		k ^DHCPEUserReportEx("Temp","CatFee",userid)
		k ^DHCPEUserReportEx("Temp","PayMode",userid)
		k ^DHCPEUserReportEx("Temp","InvNoStr",userid)
		k ^DHCPEUserReportEx("Temp","InvNoCount",userid)
		
		d ..tc()
		
	}
	else
	{
		TROLLBACK
	}
   	if rtn=0 q myRowID
	q rtn
}

/// RptType:报表类型 1日结  2日结汇总
/// FootId：日结id,
ClassMethod getPD(RptType As %Library.String = "", FootId As %Library.String = "", RptUserId As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "")
{
	if ("1"=RptType)
	{
		if (""'=FootId)
			{q ..getPDbyFootID(FootId,RptUserId)}
		else
			{q ..getPDbyUser(RptUserId)}
	}
	elseif ("2"=RptType)
	{
		q ..getPDbyDate(BeginDate,EndDate,RptUserId)
	}
	else
	{
		q "-2"
	}
}

ClassMethod getPDbyDate(BeginDate As %Library.String = "", EndDate As %Library.String = "", RptUserId As %Library.String = "") As %String
{
	//set result=0	
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)   
	
	i (BeginDate="")!(EndDate="") Quit "-1"
	s stdate=##class(websys.Conversions).DateLogicalToHtml(BeginDate)
	s enddate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	
	/*
	i BeginDate["/" s BeginDate=$ZDH(BeginDate,4)
	i EndDate["/" s EndDate=$ZDH(EndDate,4)
	i BeginDate["-" s BeginDate=$ZDH(BeginDate,3)
	i EndDate["-" s EndDate=$ZDH(EndDate,3)
	*/
	
	
	k ^DHCPETemp("UserReportStat",RptUserId)
	s timestmp=$h
 	s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
   	s footnum=0,refundnum=0,rcptstr="",RefInvNoStr=""
   	s sttime="",endtime=""
   	s usercount=0
   	s usernos=""
   	s usernames=""
   	s paymodeinfos=""
   	s (cashsum,cashnormal,cashrefund)=0
   	s roundfee=0
   	s normalroundfee=0
   	s refundroundfee=0
   	s RefInvNoStr=""
   	s FootIDStr=""  //add by zhouli
 	f fdate=BeginDate:1:EndDate  d
	.s FootID=0
	.f  s FootID=$o(^DHCPEUSERREPORT(0,"DATE",fdate,FootID))  q:FootID=""  d
	..q:'$d(^DHCPEUSERREPORT(FootID))
	..s str=^DHCPEUSERREPORT(FootID)
	..//Add 20091009
	..//s invid=$o(^DHCPEINVPRT(0,"REPORT",FootID,0))
	..//q:invid=""
	..//s paadm=$p(^DHCPEINVPRT(invid),"^",2)
	..//s gadm=$o(^DHCPEGADM(0,"DelegateADM",paadm,0))
	..//i gadm="" d
	..//.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm)
	..//e  d 
	..//.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",gadm)
	..//q:LocFlag=1
	..//End
	..i FootIDStr=""  s FootIDStr=FootID   //add by zhouli
	..e  s FootIDStr=FootIDStr_"^"_FootID  //add by zhouli
	..s footnum=+footnum+$p(str,"^",14)
	..s refundnum=+refundnum+$p(str,"^",15)
	..s footsum=+footsum+$p(str,"^",16)
	..s pdsum=+pdsum+$p(str,"^",17)
	..s refundsum=+refundsum+$p(str,"^",18)
	..s cashsum=+cashsum+$p(str,"^",19)
	..s chequesum=+chequesum+$p(str,"^",20)
	..s othersum=+othersum+$p(str,"^",21)
	..s userid=$p(str,"^",1)
	..s userno=$p($g(^SSU("SSUSR",userid)),"^",1)
	..i usernos="" s usernos=","
	..i usernames="" s usernames=","
   	..i (usernos'[(","_userno_","))  d
   	...s usernos=usernos_userno_","
   	...s username=$p($g(^SSU("SSUSR",userid)),"^",2)
   	...s usernames=usernames_username_","
   	...s usercount=usercount+1
	..
	..s roundfee=..GetRoundingFeeByUserRpt(FootID)
	..s normalroundfee=normalroundfee+$p(roundfee,"^",1)
	..s refundroundfee=refundroundfee+$p(roundfee,"^",2)
	..
	..s childsub=0
	..f  s childsub=$o(^DHCPEUSERREPORT(FootID,"PAYMODE",childsub)) q:childsub=""  d
   	...s paymodedata=$g(^DHCPEUSERREPORT(FootID,"PAYMODE",childsub))
   	...s payModeDR=$p(paymodedata,"^",1)
   	...i '$d(^DHCPETemp("UserReportStat",RptUserId,timestmp,payModeDR)) d
   	....s ^DHCPETemp("UserReportStat",RptUserId,timestmp,payModeDR)=paymodedata
   	...e  d
   	....s j=$l(paymodedata,"^")
   	....for k=2:1:j d
   	.....s $p(paymodedata,"^",k)=+$p(paymodedata,"^",k)+$p($g(^DHCPETemp("UserReportStat",RptUserId,timestmp,payModeDR)),"^",k)
   	....s ^DHCPETemp("UserReportStat",RptUserId,timestmp,payModeDR)=paymodedata
   	
   	s childsub=""
   	f  s childsub=$o(^DHCPETemp("UserReportStat",RptUserId,timestmp,childsub)) q:childsub=""  d
   	.s paymodedata=$g(^DHCPETemp("UserReportStat",RptUserId,timestmp,childsub))
   	.s pmddesc=$p(paymodedata,"^",1)
   	.i pmddesc'="" s pmddesc=$p(^CT("CTPM",pmddesc),"^",2)
   	.if paymodeinfos'="" s paymodeinfos=paymodeinfos_"#"
   	.s $p(paymodedata,"^",2)=$j($p(paymodedata,"^",2),3,2)
   	.s paymodeinfos=paymodeinfos_paymodedata_"^"_pmddesc
   	.i "现金"=pmddesc  d
   	..s cashsum= $p(paymodedata,"^",2)
   	..s cashnormal= $p(paymodedata,"^",3)
   	..s cashrefund= $p(paymodedata,"^",5)
   
   	k ^DHCPETemp("UserReportStat",RptUserId)
   	if usernos'="" s usernos=$e(usernos,2,$l(usernos)-1)
   	if usernames'="" s usernames=$e(usernames,2,$l(usernames)-1)
   	s userid=RptUserId
   	s username=$p($g(^SSU("SSUSR",userid)),"^",2)
   	s userno=$p($g(^SSU("SSUSR",userid)),"^",1)
   	s roundfee=normalroundfee-refundroundfee
   	s catInfos=..GetCatInfoByFootID(FootIDStr)
   	//s PersonAndGroupStr=..GetInfoStrStrByFootID(FootIDStr)
    //s catInfos=catInfos_"$"_PersonAndGroupStr
   	s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr_"^"_RefInvNoStr_"^"_usercount_"^"_usernos_"^"_$j(cashnormal,3,2)_"^"_$j(cashrefund,3,2)_"^"_userid_"^"_username_"^"_userno_"^^^^"_usernames_"^"_$j(roundfee,3,2)_"^"_$j(normalroundfee,3,2)_"^"_$j(refundroundfee,3,2)_"^&"_paymodeinfos_"^%%"_catInfos
   	q rtn
}

ClassMethod getPDbyFootID(FootID As %Library.String = "", RptUserId As %Library.String = "") As %String
{
   q:FootID="" "-1"
   q:'$d(^DHCPEUSERREPORT(FootID)) "-2"
   i RptUserId="" s RptUserId=$p(^DHCPEUSERREPORT(FootID),"^",1)
   s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
   s footnum=0,refundnum=0,rcptstr=""
   s stdate="",sttime="",enddate="",endtime=""
   s str=^DHCPEUSERREPORT(FootID)
   s footnum=$p(str,"^",14),refundnum=$p(str,"^",15),footsum=$p(str,"^",16),pdsum=$p(str,"^",17),refundsum=$p(str,"^",18),cashsum=$p(str,"^",19),chequesum=$p(str,"^",20),othersum=$p(str,"^",21)
   s stdate=$p(str,"^",4),sttime=$p(str,"^",5),enddate=$p(str,"^",2),endtime=$p(str,"^",3),rcptstr=$p(str,"^",6)
   i stdate'="" s stdate=##class(websys.Conversions).DateLogicalToHtml(stdate)
   i sttime'="" s sttime=$zt(sttime)
   i enddate'="" s enddate=##class(websys.Conversions).DateLogicalToHtml(enddate)
   i endtime'="" s endtime=$zt(endtime)
   s RefInvNoStr=$p(str,"^",22)
   s sswr=$p(str,"^",12)
   s refundSswr=$p(str,"^",13)
   s userid=$p(str,"^",1)
   s usercount=1
   s usernos=""
   s username=$p($g(^SSU("SSUSR",userid)),"^",2)
   s userno=$p($g(^SSU("SSUSR",userid)),"^",1)
   if usernos="" s usernos=","
   s usernos=usernos_userno_","
   s usernames=username
   
   s childsub=0
   s paymodeinfos=""
   s (cashsum,cashnormal,cashrefund)=0
   f  s childsub=$o(^DHCPEUSERREPORT(FootID,"PAYMODE",childsub)) q:childsub=""  d
   .s paymodedata=$g(^DHCPEUSERREPORT(FootID,"PAYMODE",childsub))
   .s pmddesc=$p(paymodedata,"^",1)
   .i pmddesc'="" s pmddesc=$p(^CT("CTPM",pmddesc),"^",2)
   .if paymodeinfos'="" s paymodeinfos=paymodeinfos_"#"
   .s $p(paymodedata,"^",2)=$j($p(paymodedata,"^",2),3,2)
   .s paymodeinfos=paymodeinfos_paymodedata_"^"_pmddesc
   .i "现金"=pmddesc  d
   ..s cashsum= $p(paymodedata,"^",2)
   ..s cashnormal= $p(paymodedata,"^",3)
   ..s cashrefund= $p(paymodedata,"^",5)
   if usernos'="" s usernos=$e(usernos,2,$l(usernos)-1)
   s rptusername=$p($g(^SSU("SSUSR",RptUserId)),"^",2)
   s rptuserno=$p($g(^SSU("SSUSR",RptUserId)),"^",1)
   s roundfee=..GetRoundingFeeByUserRpt(FootID)
   //s ^zl("roundfee")=roundfee
   s normalroundfee=$p(roundfee,"^",1)
   s refundroundfee=$p(roundfee,"^",2)
   s roundfee=normalroundfee-refundroundfee
   s catInfos=..GetCatInfoByFootID(FootID)
    //s PersonAndGroupStr=..GetInfoStrStrByFootID(FootID)
   //s catInfos=catInfos_"$"_PersonAndGroupStr
   s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr_"^"_RefInvNoStr_"^"_usercount_"^"_usernos_"^"_$j(cashnormal,3,2)_"^"_$j(cashrefund,3,2)_"^"_RptUserId_"^"_rptusername_"^"_rptuserno_"^"_userid_"^"_username_"^"_userno_"^"_usernames_"^"_$j(roundfee,3,2)_"^"_$j(normalroundfee,3,2)_"^"_$j(refundroundfee,3,2)_"^^"_sswr_"^"_refundSswr_"^&"_paymodeinfos_"^%%"_catInfos
   q rtn
}

ClassMethod getPDbyFootIDOld(FootID As %Library.String = "") As %String
{
   q:FootID="" "-1"
   q:'$d(^DHCPEUSERREPORT(FootID)) "-2"
   k pdPLIST
   s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
   s footnum=0,refundnum=0,rcptstr=""
   s stdate="",sttime="",enddate="",endtime=""
   s str=^DHCPEUSERREPORT(FootID)
   s footnum=$p(str,"^",14),refundnum=$p(str,"^",15),footsum=$p(str,"^",16),pdsum=$p(str,"^",17),refundsum=$p(str,"^",18),cashsum=$p(str,"^",19),chequesum=$p(str,"^",20),othersum=$p(str,"^",21)
   s stdate=$p(str,"^",4),sttime=$p(str,"^",5),enddate=$p(str,"^",2),endtime=$p(str,"^",3),rcptstr=$p(str,"^",6)
   i stdate'="" s stdate=$zd(stdate,4)
   i sttime'="" s sttime=$zt(sttime)
   i enddate'="" s enddate=$zd(enddate,4)
   i endtime'="" s endtime=$zt(endtime)
   s RefInvNoStr=$p(str,"^",22)
   s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr_"^"_RefInvNoStr
   q rtn
}

ClassMethod FindFootClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFootExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindFootExecute(ByRef qHandle As %Binary, UserID As %String, RecStartDate As %String, RecEndDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i ($g(UserID)="")!(RecStartDate="")!(RecEndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	
	i RecStartDate'="" s RecStartDate=##class(websys.Conversions).DateHtmlToLogical(RecStartDate)
	i RecEndDate'=""   s RecEndDate=##class(websys.Conversions).DateHtmlToLogical(RecEndDate)
	
	f fdate=RecStartDate:1:RecEndDate  d
	.s rowid=0
	.f  s rowid=$o(^DHCPEUSERREPORT(0,"DATE",fdate,rowid))  q:rowid=""  d
	..
	..s user=$p(^DHCPEUSERREPORT(rowid),"^",1)
	..q:user'=UserID
	..s tdate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEUSERREPORT(rowid),"^",2))
	..s ttime=$zt($p(^DHCPEUSERREPORT(rowid),"^",3))
	..s tsum=$j($p(^DHCPEUSERREPORT(rowid),"^",16),3,2)
	..s tid=rowid
	..
 	..Do OutputRow1	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow1
	set Data=$lb(tdate,ttime,tsum,tid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFootFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFootExecute ]
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

Query FindFoot(UserID As %String, RecStartDate As %String, RecEndDate As %String) As %Query(ROWSPEC = "Tdate:%String,Ttime:%String,Tsum:%String,TID:%String")
{
}

ClassMethod FindInvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindInvExecute(ByRef qHandle As %Binary, USERID As %String, FOOTID As %String, RefundChk As %Library.String = "", Charged As %Library.String = "") As %Status
{
	s puserId=%session.Get("LOGON.USERID")
	k ^DHCCashierTemp("UserReport","InvDetail",puserId)
	k ^DHCCashierTemp("UserReport","InvDetailTemp",puserId)
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s Rows=1
 	i ($g(USERID)="")&&($g(FOOTID)="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i +FOOTID'="0"  d
 	.s USERID=$p($g(^DHCPEUSERREPORT(FOOTID)),"^",1)
 	.s lastdate=$p($g(^DHCPEUSERREPORT(FOOTID)),"^",4)
 	.s lasttime=$p($g(^DHCPEUSERREPORT(FOOTID)),"^",5)
 	e  d
 	.s USERID=puserId
 	.s lastdate=+$h
 	.s lasttime=$p($h,",",2)
 	//i USERID="" s USERID=puserId
 	s userno=$p($g(^SSU("SSUSR",USERID)),"^",1)
 	s username=$p($g(^SSU("SSUSR",USERID)),"^",2)
 	s lastdate=##class(websys.Conversions).DateLogicalToHtml(lastdate)
 	s lasttime=$zt(lasttime)
	s ^DHCCashierTemp("UserReport","InvDetail",puserId)=FOOTID_"^"_USERID_"^"_userno_"^"_username_"^"_lastdate_"^"_lasttime_"^"_RefundChk
	
	i (USERID'="")&&(FOOTID="0")  d
	.
	.s rowid=0
	.f  s rowid=$o(^DHCPEINVPRT(0,"RPFLAG",USERID,"N",rowid))  q:rowid=""  d
	..
	..d getinvdetail
	..q:(RefundChk="on")&(tflag="正常")
	..q:(Charged="on")&(tflag'="正常")
	..d OutputRow2
	.
	.s APID=0
   	.f  s APID=$o(^DHCPEAP(0,"ReportFlag",USERID,"N",APID)) q:APID=""  d
   	..s Sub=0
   	..f  s Sub=$o(^DHCPEAP(0,"ReportFlag",USERID,"N",APID,Sub)) q:Sub=""  d
   	...s Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   	...q:(Type'="B")&&(Type'="R")&&(Type'="RF")
   	...d getyjjdetail
   	...q:(RefundChk="on")&(Type'="RF")
   	...q:(Charged="on")&(tflag'="正常")
   	...d OutputRow2
	
	i +$g(FOOTID)>0  d
	.s rowid=0
	.f  s rowid=$o(^DHCPEINVPRT(0,"REPORT",FOOTID,rowid))  q:rowid=""  d
	..
	..d getinvdetail
	..q:(RefundChk="on")&(tflag="正常")
	..q:(Charged="on")&(tflag'="正常")
 	..d OutputRow2	 	
 	.
 	.s APID=0
   	.f  s APID=$o(^DHCPEAP(0,"Report",FOOTID,APID)) q:APID=""  d
   	..s Sub=0
   	..f  s Sub=$o(^DHCPEAP(0,"Report",FOOTID,APID,Sub)) q:Sub=""  d
   	...s Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   	...q:(Type'="B")&&(Type'="R")&&(Type'="RF")
   	...d getyjjdetail
   	...q:(RefundChk="on")&(Type'="RF")
   	...q:(Charged="on")&(tflag="RF")
   	...d OutputRow2
 	s TotalAmout=0,TOneTotalAmout=0
 	s TotalRoundFee=0
 	s PayModeDesc=""
 	f  s PayModeDesc=$O(^DHCCashierTemp("UserReport","InvDetailTemp",puserId,PayModeDesc)) q:PayModeDesc=""  d
 	.s Rows=0
 	.s OneTotalAmout=0
 	.s OneTotalRoundFee=0
 	.f  s Rows=$O(^DHCCashierTemp("UserReport","InvDetailTemp",puserId,PayModeDesc,Rows)) q:Rows=""  d
 	..s StrInfo=$G(^DHCCashierTemp("UserReport","InvDetailTemp",puserId,PayModeDesc,Rows))
 	..s tdate=$P(StrInfo,"^",1)
 	..s ttime=$P(StrInfo,"^",2)
 	..s tamt=$P(StrInfo,"^",3)
 	..s tflag=$P(StrInfo,"^",4)
 	..s tuser=$P(StrInfo,"^",5)
 	..s treceiptsno=$P(StrInfo,"^",6)
 	..s tjkdate=$P(StrInfo,"^",7)
 	..s tpayamt=$P(StrInfo,"^",8)
 	..s tpaymode=$P(StrInfo,"^",9)
 	..s tchequeno=$P(StrInfo,"^",10)
 	..s tbank=$P(StrInfo,"^",11)
 	..s tcompany=$P(StrInfo,"^",12)
 	..s tdeposit=$P(StrInfo,"^",13)
 	..s tregno=$P(StrInfo,"^",14)
 	..s tname2=$P(StrInfo,"^",15)
 	..s trowid=$P(StrInfo,"^",16)
 	..s trefinvno=$P(StrInfo,"^",17)
 	..s TRoundFee=$P(StrInfo,"^",18)
 	..S TISYJJ=$P(StrInfo,"^",19)
 	..s OneTotalAmout=OneTotalAmout+tamt
 	..s OneTotalRoundFee=OneTotalRoundFee+TRoundFee
 	..d OutPutFindInv
 	.s (tdate,ttime,tamt,tflag,tuser,treceiptsno,tjkdate,tpayamt,tpaymode,tchequeno,tbank,tcompany,tdeposit,tregno,tname2,trowid,trefinvno,TRoundFee,TISYJJ)=""
 	.s tname2="小计:"
 	.s tamt=OneTotalAmout
 	.s TRoundFee=OneTotalRoundFee
 	.s TotalAmout=TotalAmout+OneTotalAmout
 	.s TotalRoundFee=TotalRoundFee+OneTotalRoundFee
 	.S TOneTotalAmout=TOneTotalAmout+OneTotalAmout
 	.d OutPutFindInv
 	s (tdate,ttime,tamt,tflag,tuser,treceiptsno,tjkdate,tpayamt,tpaymode,tchequeno,tbank,tcompany,tdeposit,tregno,tname2,trowid,trefinvno,TRoundFee,TISYJJ)=""
 	s tname2="总计:"
 	//s tamt=$G(OneTotalAmout)
 	s tamt=$G(TOneTotalAmout)
 	s TRoundFee=$G(OneTotalRoundFee)
 	d OutPutFindInv
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
getinvdetail
    S TISYJJ=""
    s tmpstr=$g(^DHCPEINVPRT(rowid))
    //Tdate,Ttime,Tamt,Tflag,Tuser,Treceiptsno,Tjkdate,Tpayamt,Tpaymode,Tchequeno,Tbank,Tcompany,Tdeposit,Tregno,tname2,Trowid
    s tchequeno="",tbank="",tcompany=""
    s tdate=$p(tmpstr,"^",11) i tdate'="" s tdate=##class(websys.Conversions).DateLogicalToHtml(tdate)
    s ttime=$p(tmpstr,"^",12) i ttime'="" s ttime=$ZT(ttime)
    s tamt=+$p(tmpstr,"^",7)
    s sswr=+$p(tmpstr,"^",21)
    s tflag=$p(tmpstr,"^",8) 
    //s tamt=tamt+sswr  
    i tflag="N" d
    .s tflag="正常"
    i tflag="S" s tflag="冲红"
    i tflag="A" s tflag="作废"
    s trefinvno=$p(tmpstr,"^",9) i trefinvno'="" s trefinvno=$p($g(^DHCPEINVPRT(trefinvno)),"^",1)
    s tuser=$p(tmpstr,"^",10) i tuser'="" s tuser=$p(^SSU("SSUSR",tuser),"^",2)
    s treceiptsno=$p(tmpstr,"^",1)
    
    s RFocusPrintID=""
    s RFocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_rowid,""))
	i RFocusPrintID'="" d
	.s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(RFocusPrintID),3)
	.s treceiptsno=RealInvNo_" ("_treceiptsno_")"

    s tjkdate=$p(tmpstr,"^",15) i tjkdate'="" s tjkdate=##class(websys.Conversions).DateLogicalToHtml(tjkdate)
    s tdeposit=+$p(tmpstr,"^",6)
    s adm=$p(tmpstr,"^",2),papmi=$p(^PAADM(adm),"^")
    s tname2=$P($g(^PAPER(papmi,"ALL")),"^",1)
    s tregno=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
    s trowid=rowid
    s arrcp=$p(tmpstr,"^",4)
    s tpayamt=0,tpaymode=""
    s paym="0"
    f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
    .s ss=^ARRCP(arrcp,"PAYM",paym)
    .s mode=$p(ss,"^",1)
    .Q:'$D(^CT("CTPM",mode))
    .i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
    .e  s pmdesc="现金"
    .s pdamt=+$p(ss,"^",3)+sswr,tpayamt=tpayamt+pdamt
    .S pdamt=$FN(pdamt,"",2) ,tpayamt=$FN(tpayamt,"",2)
    .i tpaymode="" s tpaymode=pmdesc_":"_pdamt
    .e  s tpaymode=tpaymode_","_pmdesc_":"_pdamt
    .s chequeno=$p(ss,"^",4)
    .i tchequeno=""  s tchequeno=chequeno
    .e  d
    ..i chequeno'="" s tchequeno=tchequeno_",  "_chequeno
    s TRoundFee=..GetRoundingFeeByInvPrt(rowid)
    i tflag="冲红" s TRoundFee=-TRoundFee
    
    
    q
getyjjdetail
  	S TISYJJ="预缴金"
    s tmpstr=$g(^DHCPEAP(APID,"AC",Sub))
    //Tdate,Ttime,Tamt,Tflag,Tuser,Treceiptsno,Tjkdate,Tpayamt,Tpaymode,Tchequeno,Tbank,Tcompany,Tdeposit,Tregno,tname2,Trowid
    s tchequeno="",tbank="",tcompany=""
    s tdate=$p(tmpstr,"^",5) i tdate'="" s tdate=##class(websys.Conversions).DateLogicalToHtml(tdate)
    s ttime=$p(tmpstr,"^",6) i ttime'="" s ttime=$ZT(ttime)
    ;s ttime="预缴金"
    s tamt=+$p(tmpstr,"^",2)
    //s tflag=##class(web.DHCPE.AdvancePayment).HadRefund(APID_"||"_Sub)   
    i Type'="RF" s tflag="正常"
    i Type="RF" s tflag="作废"
    s trefinvno=$p(tmpstr,"^",4)
     
    i Type="RF" d
    .s NReport=""
    .s FUserDR=$p($g(^DHCPEAP(+trefinvno,"AC",$p(trefinvno,"||",2))),"^",7)
    .S NUserDR=$p(tmpstr,"^",7) 
    .s FReport=$p($g(^DHCPEAP(+trefinvno,"AC",$p(trefinvno,"||",2))),"^",9)
    .i NReport=$p(tmpstr,"^",9)
    .I (FReport="")&(NReport="")&(FUserDR'=NUserDR) S tflag="冲红"
    .I (FReport'=NReport) S tflag="冲红"
    

    i Type="RF" s trefinvno=$p($g(^DHCPEAP(+trefinvno,"AC",$p(trefinvno,"||",2))),"^",4)
    
    s tuser=$p(tmpstr,"^",7) i tuser'="" s tuser=$p(^SSU("SSUSR",tuser),"^",2)
    s treceiptsno="" //$p(tmpstr,"^",1)
    i Type'="RF" d
    .s trefinvno=""
    .s treceiptsno=$p(tmpstr,"^",4)
    s tjkdate="" //$p(tmpstr,"^",15) i tjkdate'="" s tjkdate=$ZD(tjkdate,4)
    s tdeposit=tamt //+$p(tmpstr,"^",6)
    //s adm=$p(tmpstr,"^",2),papmi=$p(^PAADM(adm),"^")
    s regno=$p(^DHCPEAP(APID),"^",1)
    i regno'="" d
    .s papmi=$O(^PAPERi("PAPMI_PatNo",regno,0))
    .s tname2=$P($g(^PAPER(papmi,"ALL")),"^",1)
    .s regno=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
    e  d
    .s tname2=""
    .s tname2=$p($G(^DHCPEDataEx("DHCPEAD","InvID",APID_"||"_Sub)),"^",1)
    s tregno=regno
    s trowid=APID_"||"_Sub
    s arrcp="" //$p(tmpstr,"^",4)
    s tpayamt=0,tpaymode=""
    s mode=$p(tmpstr,"^",10)
    i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
    e  s pmdesc="现金"
    s pdamt=$p(tmpstr,"^",2)
    s tpayamt=pdamt
    S pdamt=$FN(pdamt,"",2) ,tpayamt=$FN(tpayamt,"",2)
    i tpaymode="" s tpaymode=pmdesc_":"_pdamt
    e  s tpaymode=tpaymode_","_pmdesc_":"_pdamt
    s tchequeno=""
    S tchequeno=$g(^DHCPEDataEx("DHCPEAD","paymode",APID_"||"_Sub))
    s TRoundFee=""
    s tdeposit=""
    q
OutputRow2	
	
	set ^DHCCashierTemp("UserReport","InvDetailTemp",puserId,pmdesc,Rows)=tdate_"^"_ttime_"^"_tamt_"^"_tflag_"^"_tuser_"^"_treceiptsno_"^"_tjkdate_"^"_tpayamt_"^"_tpaymode_"^"_tchequeno_"^"_tbank_"^"_tcompany_"^"_tdeposit_"^"_tregno_"^"_tname2_"^"_trowid_"^"_trefinvno_"^"_$G(TRoundFee)_"^"_TISYJJ
 	
 	Set Rows=Rows+1
	quit
OutPutFindInv
	set Data=$lb(tdate,ttime,tamt,tflag,tuser,treceiptsno,tjkdate,tpayamt,tpaymode,tchequeno,tbank,tcompany,tdeposit,tregno,tname2,trowid,trefinvno,$G(TRoundFee),TISYJJ)
 	Set ^CacheTemp(repid,ind)=Data
 	set ^DHCCashierTemp("UserReport","InvDetail",puserId,ind)=tdate_"^"_ttime_"^"_tamt_"^"_tflag_"^"_tuser_"^"_treceiptsno_"^"_tjkdate_"^"_tpayamt_"^"_tpaymode_"^"_tchequeno_"^"_tbank_"^"_tcompany_"^"_tdeposit_"^"_tregno_"^"_tname2_"^"_trowid_"^"_trefinvno_"^"_$G(TRoundFee)
 	Set ind=ind+1
 	quit
}

ClassMethod FindInvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvExecute ]
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

Query FindInv(USERID As %String, FOOTID As %String, RefundChk As %Library.String = "", Charged As %Library.String = "") As %Query(ROWSPEC = "Tdate,Ttime,Tamt,Tflag,Tuser,Treceiptsno,Tjkdate,Tpayamt,Tpaymode,Tchequeno,Tbank,Tcompany,Tdeposit,Tregno,Tname,Trowid,Trefinvno,TRoundFee,TISYJJ")
{
}

/// w ##class(web.DHCPE.DHCPEUSERREPORT).GetCardDaySumHZ("01/04/2018","11/04/2018")
/// 日结rowid获得这段时间内的预交金的信息
ClassMethod GetCardDaySumHZ(begindate, enddate)
{
	s BDate=##class(websys.Conversions).DateHtmlToLogical(begindate)
	s EDate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	
	s Data="",AllToltal=0
	s AllCashamount=0,AllCashamountRF=0,AllYHKamount=0,AllYHKamountRF=0,AllZPamount=0,AllZPamountRF=0
	s Date=BDate-1
	f  s Date=$O(^DHCPEUSERREPORT(0,"DATE",Date)) q:(Date="")||(Date>EDate)  d
	.s RowID=""
	.f  s RowID=$O(^DHCPEUSERREPORT(0,"DATE",Date,RowID)) q:RowID=""  d
	..;w !,RowID
	..s APRowID=0
	..f  s APRowID=$o(^DHCPEAP(0,"Report",RowID,APRowID)) q:APRowID=""  d
	...s OnePersonToltal=0,Cashamount=0,CashamountRF=0,YHKamount=0,YHKamountRF=0,ZPamount=0,ZPamountRF=0
	...s APChildSub=""
	...f  s APChildSub=$o(^DHCPEAP(0,"Report",RowID,APRowID,APChildSub)) q:APChildSub=""  d
	....s CurData=$g(^DHCPEAP(APRowID,"AC",APChildSub))
	....s ConsumeAmount=$p(CurData,"^",2)
	....q:((ConsumeAmount="")||(ConsumeAmount=0))
	....s PayModeDr=$p(CurData,"^",10)
	....s Type=$p(CurData,"^",1)
	....q:((Type'="B")&&(Type'="R")&&(Type'="RF"))
	
	....s:((PayModeDr=1)&&((Type="B")||(Type="R"))) Cashamount=Cashamount+ConsumeAmount
	....s:((PayModeDr=1)&&(Type="RF")) CashamountRF=CashamountRF+ConsumeAmount
	....s:((PayModeDr=4)&&((Type="B")||(Type="R"))) YHKamount=YHKamount+ConsumeAmount
	....s:((PayModeDr=4)&&(Type="RF")) YHKamountRF=YHKamountRF+ConsumeAmount
	....s:((PayModeDr=2)&&((Type="B")||(Type="R"))) ZPamount=ZPamount+ConsumeAmount
	....s:((PayModeDr=2)&&(Type="RF")) ZPamountRF=ZPamountRF+ConsumeAmount
	
	...s OnePersonToltal=Cashamount+YHKamount+ZPamount-CashamountRF-YHKamountRF-ZPamountRF
	...s CardInfo=$g(^DHCPEAP(APRowID))
	
	...s DateTime=$zd($p(CardInfo,"^",6))_" "_$zt($p(CardInfo,"^",7))
	...s UserName=$p($G(^SSU("SSUSR",$p(CardInfo,"^",8))),"^",2)
	...s Type=$p(CardInfo,"^",3)
	...i Type="C" s Name=$p(CardInfo,"^",2)_"  "_$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",1)
	...i Type="R"  d
	....s RegNo=$p(CardInfo,"^",1)
	....s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	....s Name=$p(CardInfo,"^",1)_"  "_$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)_"(预缴金)"
	...s OneData=DateTime_"^"_UserName_"^"_Name_"^"_Cashamount_"^"_CashamountRF_"^"_YHKamount_"^"_YHKamountRF_"^"_ZPamount_"^"_ZPamountRF_"^"_OnePersonToltal
	...s:(Data'="") Data=Data_"$"_OneData
	...s:Data="" Data=OneData
   
	...s AllCashamount=Cashamount+AllCashamount
	...s AllCashamountRF=CashamountRF+AllCashamountRF
	...s AllYHKamount=YHKamount+AllYHKamount
	...//s AllYHKamountRF=YHKamount+AllYHKamountRF
	...s AllYHKamountRF=YHKamountRF+AllYHKamountRF
	...s AllZPamount=ZPamount+AllZPamount
	...s AllZPamountRF=ZPamountRF+AllZPamountRF
	...s AllToltal=OnePersonToltal+AllToltal
	
	s:(Data'="") Data=Data_"$^^总计^"_AllCashamount_"^"_AllCashamountRF_"^"_AllYHKamount_"^"_AllYHKamountRF_"^"_AllZPamount_"^"_AllZPamountRF_"^"_AllToltal

	s:(Data="") Data="^^总计^"_AllCashamount_"^"_AllCashamountRF_"^"_AllYHKamount_"^"_AllYHKamountRF_"^"_AllZPamount_"^"_AllZPamountRF_"^"_AllToltal

	q Data
}

/// w ##class(web.DHCPE.DHCPEUSERREPORT).GetCardDaySum("")
/// /根据日结rowid获得这段时间内的预交金的信息
ClassMethod GetCardDaySum(RowID)
{
	
	q:(RowID="0") ""
	s APRowID=0,APChildSub=0,Data="",AllToltal=0
	s AllCashamount=0,AllCashamountRF=0,AllYHKamount=0,AllYHKamountRF=0,AllZPamount=0,AllZPamountRF=0
	
	f  s APRowID=$o(^DHCPEAP(0,"Report",RowID,APRowID)) q:APRowID=""  d
	.s OnePersonToltal=0,Cashamount=0,CashamountRF=0,YHKamount=0,YHKamountRF=0,ZPamount=0,ZPamountRF=0
	.f  s APChildSub=$o(^DHCPEAP(0,"Report",RowID,APRowID,APChildSub)) q:APChildSub=""  d
	..s CurData=$g(^DHCPEAP(APRowID,"AC",APChildSub))
	..s ConsumeAmount=$p(CurData,"^",2)
	..q:((ConsumeAmount="")||(ConsumeAmount=0))
	..s PayModeDr=$p(CurData,"^",10)
	..s Type=$p(CurData,"^",1)
	..q:((Type'="B")&&(Type'="R")&&(Type'="RF"))
	..s:((PayModeDr=1)&&((Type="B")||(Type="R"))) Cashamount=Cashamount+ConsumeAmount
	..s:((PayModeDr=1)&&(Type="RF")) CashamountRF=CashamountRF+ConsumeAmount
	..s:((PayModeDr=4)&&((Type="B")||(Type="R"))) YHKamount=YHKamount+ConsumeAmount
	..s:((PayModeDr=4)&&(Type="RF")) YHKamountRF=YHKamountRF+ConsumeAmount
	..s:((PayModeDr=2)&&((Type="B")||(Type="R"))) ZPamount=ZPamount+ConsumeAmount
	..s:((PayModeDr=2)&&(Type="RF")) ZPamountRF=ZPamountRF+ConsumeAmount
	.s OnePersonToltal=Cashamount+YHKamount+ZPamount-CashamountRF-YHKamountRF-ZPamountRF
	.s CardInfo=$g(^DHCPEAP(APRowID))
	.s Date=$zd($p(CardInfo,"^",6))_" "_$zt($p(CardInfo,"^",7))
	.s UserName=$p($G(^SSU("SSUSR",$p(CardInfo,"^",8))),"^",2)
	.s Type=$p(CardInfo,"^",3)
	.i Type="C" s Name=$p(CardInfo,"^",2)_" "_$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",1)
	.i Type="R" d
	..s RegNo=$p(CardInfo,"^",1)
	..s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	..s Name=$p(CardInfo,"^",1)_" "_$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)_"(预缴金)"

	.;s Name=$p(CardInfo,"^",2)_"  "_$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",1)
	
	.s OneData=Date_"^"_UserName_"^"_Name_"^"_Cashamount_"^"_CashamountRF_"^"_YHKamount_"^"_YHKamountRF_"^"_ZPamount_"^"_ZPamountRF_"^"_OnePersonToltal
	.s:(Data'="") Data=Data_"$"_OneData
	.s:Data="" Data=OneData
	.s AllCashamount=Cashamount+AllCashamount
	.s AllCashamountRF=CashamountRF+AllCashamountRF
	.s AllYHKamount=YHKamount+AllYHKamount
	.//s AllYHKamountRF=YHKamount+AllYHKamountRF
	.s AllYHKamountRF=YHKamountRF+AllYHKamountRF
	.s AllZPamount=ZPamount+AllZPamount
	.s AllZPamountRF=ZPamountRF+AllZPamountRF
	.
	.s AllToltal=OnePersonToltal+AllToltal
	s:(Data'="") Data=Data_"$^^总计^"_AllCashamount_"^"_AllCashamountRF_"^"_AllYHKamount_"^"_AllYHKamountRF_"^"_AllZPamount_"^"_AllZPamountRF_"^"_AllToltal

	s:(Data="") Data="^^总计^"_AllCashamount_"^"_AllCashamountRF_"^"_AllYHKamount_"^"_AllYHKamountRF_"^"_AllZPamount_"^"_AllZPamountRF_"^"_AllToltal

	q Data
}

ClassMethod tb()
{
 n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// -------------------------------
ClassMethod UserReportStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UserReportStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##"^61758^61948^^^on" 

// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEUSERREPORT","UserReportStat","","61758","61948","","","on")

ClassMethod UserReportStatExecute(ByRef qHandle As %Binary, UserID As %String = "", BeginDate As %String = "", EndDate As %String = "", AuditFlag As %String = "", CashierTotal As %String = "", NoDayHand As %String = "") As %Status
{
   
	s Flag="N",HandFlag="Y"
	if CashierTotal="on"  s Flag="Y"
	if NoDayHand="on"  s HandFlag="N"
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=5
 	;set Data=$lb("序号","操作员","","",PayModeTotal(1),PayModeTotal(2),PayModeTotal(3),PayModeTotal(4),PayModeTotal(5),PayModeTotal(6),PayModeTotal(7),PayModeTotal(8),PayModeTotal(9),PayModeTotal(10),PayModeTotal(11),PayModeTotal(12),PayModeTotal(13),PayModeTotal(14),PayModeTotal(15),PayModeTotal(16),PayModeTotal(17),PayModeTotal(18),PayModeTotal(19),SumAll,CashierAll,ChequeAll,OtherAll,RefundAll,NormalAll,RcptAll,"","","")
 	;Set ^CacheTemp(repid,1)=Data
 	;Set ind=ind+1
 	s ^zl("20100810")=UserID_"^"_BeginDate_"^"_EndDate_"^"_AuditFlag_"^"_CashierTotal_"^"_NoDayHand
 	k ^TempDHCPE($J,"PayModeDetail")
	k ^DHCPECashierTemp("PrintInfo")
    k ^DHCPECashierTemp("RefundTotal") 
    k ^DHCPECashierTemp("NormalTotal")
    k ^DHCPECashierTemp("RcptTotal")
    k ^DHCPECashierTemp("USER")
	s (PayModeTotal(1),PayModeTotal(2),PayModeTotal(3),PayModeTotal(4),PayModeTotal(5),PayModeTotal(6),PayModeTotal(7),PayModeTotal(8),PayModeTotal(9),PayModeTotal(10),PayModeTotal(11),PayModeTotal(12),PayModeTotal(13),PayModeTotal(14),PayModeTotal(15),PayModeTotal(16),PayModeTotal(17),PayModeTotal(18),PayModeTotal(19))=""
	s (PayModeDesc(1),PayModeDesc(2),PayModeDesc(3),PayModeDesc(4),PayModeDesc(5),PayModeDesc(6),PayModeDesc(7),PayModeDesc(8),PayModeDesc(9),PayModeDesc(10),PayModeDesc(11),PayModeDesc(12),PayModeDesc(13),PayModeDesc(14),PayModeDesc(15),PayModeDesc(16),PayModeDesc(17),PayModeDesc(18),PayModeDesc(19))=""
	s (SumAll,CashierAll,ChequeAll,OtherAll,RefundAll,NormalAll,RcptAll)=0
	s No=0
	i BeginDate'=""  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	i EndDate'=""     s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
 	i (BeginDate="")!(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK	
 	;s (PayMode1All,PayMode2All,PayMode3All,PayMode4All,PayMode5All,PayMode6All,PayMode7All,PayMode8All,PayMode9All,PayMode10All,PayMode11All,PayMode12All,PayMode13All,PayMode14All,PayMode15All,PayMode16All,PayMode17All,PayMode18All,PayMode19All,SumAll,CashierAll,ChequeAll,OtherAll,RefundAll,NormalAll,RcptAll)=0
	i HandFlag="Y"
	{
	f fdate=BeginDate:1:EndDate  d
	.s rowid=0
	.f  s rowid=$o(^DHCPEUSERREPORT(0,"DATE",fdate,rowid))  q:rowid=""  d
	..d ClearVariable
	..s ReportID=rowid
	..s User=$p($G(^DHCPEUSERREPORT(rowid)),"^",1)
	..q:User=""
	..q:((UserID'="")&&(User'=UserID))
	..s No=No+1
	..i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
	..s ReportDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEUSERREPORT(rowid),"^",2))
	..//s ttime=$zt($p(^DHCPEUSERREPORT(rowid),"^",3))
	..s Sum=$j($p(^DHCPEUSERREPORT(rowid),"^",16),3,2)
	..
	..s Cashier=$j($p(^DHCPEUSERREPORT(rowid),"^",19),3,2)
	..s Cheque=$j($p(^DHCPEUSERREPORT(rowid),"^",20),3,2)
	..s Other=$j($p(^DHCPEUSERREPORT(rowid),"^",21),3,2)
	..s Refund=$j($p(^DHCPEUSERREPORT(rowid),"^",18),3,2)
	..s Normal=$j($p(^DHCPEUSERREPORT(rowid),"^",17),3,2)
	..s Rcpt=$j($p(^DHCPEUSERREPORT(rowid),"^",16),3,2)
	..s InceptFlag=$p(^DHCPEUSERREPORT(rowid),"^",9)
	..i InceptFlag="" s InceptFlag="N"
	..q:((AuditFlag'="")&&(AuditFlag'=InceptFlag))
	..s InceptDate=$p(^DHCPEUSERREPORT(rowid),"^",10)
	..i InceptDate'="" s InceptDate=##class(websys.Conversions).DateLogicalToHtml(InceptDate)
	..s InceptUser=$p(^DHCPEUSERREPORT(rowid),"^",8)
	..i InceptUser'="" s InceptUser=$p($g(^SSU("SSUSR",InceptUser)),"^",2) 
	..s SumAll=SumAll+Sum
	..s CashierAll=CashierAll+Cashier
	..s ChequeAll=ChequeAll+Cheque
	..s OtherAll=OtherAll+Other
	..s RefundAll=RefundAll+Refund
	..s NormalAll=NormalAll+Normal
	..s RcptAll=RcptAll+Rcpt
	..s sub=0
	..f  s sub=$o(^DHCPEUSERREPORT(rowid,"PAYMODE",sub)) q:sub=""  d
	...s ModeDR=$P(^DHCPEUSERREPORT(rowid,"PAYMODE",sub),"^",1)
	...i '$D(^TempDHCPE($J,"PayModeDetail",ModeDR)) d
	....s ^TempDHCPE($J,"PayModeDetail",ModeDR)=1+$G(^TempDHCPE($J,"PayModeDetail"))
	....s ^TempDHCPE($J,"PayModeDetail")=^TempDHCPE($J,"PayModeDetail",ModeDR)
	....
	...s i=$G(^TempDHCPE($J,"PayModeDetail",ModeDR))
	...s PayModeDesc(i)=$p($g(^CT("CTPM",ModeDR)),"^",2)
	...s Amount=$P(^DHCPEUSERREPORT(rowid,"PAYMODE",sub),"^",2)
	...s PayMode(i)=Amount
	...s PayModeTotal(i)=PayModeTotal(i)+Amount
	...s PayModeTotal(User,i)=$G(PayModeTotal(User,i))+Amount
	..s ^DHCPECashierTemp("RefundTotal",User)=+$g(^DHCPECashierTemp("RefundTotal",User))+Refund
	..s ^DHCPECashierTemp("NormalTotal",User)=+$g(^DHCPECashierTemp("NormalTotal",User))+Normal
	..s ^DHCPECashierTemp("RcptTotal",User)=+$g(^DHCPECashierTemp("RcptTotal",User))+Rcpt
 	..if CashierTotal'="on" Do OutputRowUserReportStat
 	}
	else
	{	
	    if BeginDate="" s BeginDate=+$h
		if BeginDate="" s BeginDate=0
		s BeginDate=BeginDate-1
		d ClearVariable
		S RcptAll="0",Rcpt="0"
		s TRowId=""
		f  s BeginDate=$o(^DHCPEINVPRT(0,"DATE",BeginDate)) q:((BeginDate="")||(EndDate<BeginDate))  d
	 	.f  s TRowId=$o(^DHCPEINVPRT(0,"DATE",BeginDate,TRowId)) q:((TRowId=""))  d
	 	..s InvData=$g(^DHCPEINVPRT(TRowId))
	 	..s PRTFlag=$p(InvData,"^",24)
	 	..s PRTAcount=$p(InvData,"^",7)
	 	..s RPEINVID=$p(InvData,"^",9)
	    ..q:((HandFlag'="")&&(HandFlag'=PRTFlag))
	    ..s User=$p(InvData,"^",10)
	    ..s ^DHCPECashierTemp("USER", User)=1
	    ..i RPEINVID'="" d
	    ...s ^DHCPECashierTemp("RefundTotal",User)=+$g(^DHCPECashierTemp("RefundTotal",User))+PRTAcount
	    ..else  d
	    ...s ^DHCPECashierTemp("NormalTotal",User)=+$g(^DHCPECashierTemp("NormalTotal",User))+PRTAcount
	   
	    S No=0
	    s UserId=0
	    f  s UserId=$o(^DHCPECashierTemp("USER",UserId)) Q:UserId=""  d
	    .s Refund=+$g(^DHCPECashierTemp("RefundTotal",UserId))
	    .s Normal=+$g(^DHCPECashierTemp("NormalTotal",UserId))
	    .i UserId'="" s User=$p($g(^SSU("SSUSR",UserId)),"^",2)
	    .S RefundAll=RefundAll+Refund
	    .S NormalAll=NormalAll+Normal
	    .S No=No+1
	    .if CashierTotal'="on" Do OutputRowUserReportStat
	    
		}

 	if CashierTotal="on" Do OutputRowUserTotal
 	set Data=$lb("","合计","","",PayModeTotal(1),PayModeTotal(2),PayModeTotal(3),PayModeTotal(4),PayModeTotal(5),PayModeTotal(6),PayModeTotal(7),PayModeTotal(8),PayModeTotal(9),PayModeTotal(10),PayModeTotal(11),PayModeTotal(12),PayModeTotal(13),PayModeTotal(14),PayModeTotal(15),PayModeTotal(16),PayModeTotal(17),PayModeTotal(18),PayModeTotal(19),SumAll,CashierAll,ChequeAll,OtherAll,RefundAll,NormalAll,RcptAll,"","","","Y")
 	Set ^CacheTemp(repid,2)=Data
 	s DateStr="日结日期"
 	if CashierTotal="on" s DateStr=""
 	set Data=$lb("序号","操作员",DateStr,"",PayModeDesc(1),PayModeDesc(2),PayModeDesc(3),PayModeDesc(4),PayModeDesc(5),PayModeDesc(6),PayModeDesc(7),PayModeDesc(8),PayModeDesc(9),PayModeDesc(10),PayModeDesc(11),PayModeDesc(12),PayModeDesc(13),PayModeDesc(14),PayModeDesc(15),PayModeDesc(16),PayModeDesc(17),PayModeDesc(18),PayModeDesc(19),"合计","现金","支票","其它","退款金额","收款金额","结算总金额","","","","Y")
 	Set ^CacheTemp(repid,1)=Data
 	Set ind=ind+1
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowUserReportStat
	
	set Data=$lb(No,User,ReportDate,ReportID,PayMode(1),PayMode(2),PayMode(3),PayMode(4),PayMode(5),PayMode(6),PayMode(7),PayMode(8),PayMode(9),PayMode(10),PayMode(11),PayMode(12),PayMode(13),PayMode(14),PayMode(15),PayMode(16),PayMode(17),PayMode(18),PayMode(19),Sum,Cashier,Cheque,Other,Refund,Normal,Rcpt,InceptFlag,InceptDate,InceptUser,Flag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OutputRowUserTotal
    
    s (UserIDNo,User,ReportDate,ReportID,PayMode(1),PayMode(2),PayMode(3),PayMode(4),PayMode(5),PayMode(6),PayMode(7),PayMode(8),PayMode(9),PayMode(10),PayMode(11),PayMode(12),PayMode(13),PayMode(14),PayMode(15),PayMode(16),PayMode(17),PayMode(18),PayMode(19),Sum,Cashier,Cheque,Other,Refund,Normal,Rcpt,InceptFlag,InceptDate,InceptUser)=""
    s No=0 
    s User=0 
    f  s User=$o(^DHCPECashierTemp("RefundTotal",User))  q:User=""  d
    .d Clear
    .s Refund=$g(^DHCPECashierTemp("RefundTotal",User))
    .s Normal=$g(^DHCPECashierTemp("NormalTotal",User))
    .s Rcpt=$g(^DHCPECashierTemp("RcptTotal",User))
    .s ReportID=$g(^DHCPECashierTemp("UserInvPrt",User))
    .s No=No+1
    .s i=0
    .f  s i=$O(PayModeTotal(User,i)) q:i=""  d
    ..s PayMode(i)=$G(PayModeTotal(User,i))
    .s ^DHCPECashierTemp("PrintInfo",BeginDate,EndDate,No)=User_"^"_Refund_"^"_Normal_"^"_Rcpt_"^"_ReportID
	.set Data=$lb(No,User,ReportDate,ReportID,PayMode(1),PayMode(2),PayMode(3),PayMode(4),PayMode(5),PayMode(6),PayMode(7),PayMode(8),PayMode(9),PayMode(10),PayMode(11),PayMode(12),PayMode(13),PayMode(14),PayMode(15),PayMode(16),PayMode(17),PayMode(18),PayMode(19),Sum,Cashier,Cheque,Other,Refund,Normal,Rcpt,InceptFlag,InceptDate,InceptUser,Flag)
 	.Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
ClearVariable
	s (User,ReportDate,ReportID,PayMode(1),PayMode(2),PayMode(3),PayMode(4),PayMode(5),PayMode(6),PayMode(7),PayMode(8),PayMode(9),PayMode(10),PayMode(11),PayMode(12),PayMode(13),PayMode(14),PayMode(15),PayMode(16),PayMode(17),PayMode(18),PayMode(19),Sum,Cashier,Cheque,Other,Refund,Normal,Rcpt,InceptFlag,InceptDate,InceptUser)=""
	quit
Clear
	s (PayMode(1),PayMode(2),PayMode(3),PayMode(4),PayMode(5),PayMode(6),PayMode(7),PayMode(8),PayMode(9),PayMode(10),PayMode(11),PayMode(12),PayMode(13),PayMode(14),PayMode(15),PayMode(16),PayMode(17),PayMode(18),PayMode(19))=""
	q
}

ClassMethod UserReportStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserReportStatExecute ]
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

Query UserReportStat(UserID As %String = "", BeginDate As %String = "", EndDate As %String = "", AuditFlag As %String = "", CashierTotal As %String = "", NoDayHand As %String = "") As %Query(ROWSPEC = "TNo:%String,TUser:%String,TReportDate:%String,TReportID:%String,TPayMode1:%String,TPayMode2:%String,TPayMode3:%String,TPayMode4:%String,TPayMode5:%String,TPayMode6:%String,TPayMode7:%String,TPayMode8:%String,TPayMode9:%String,TPayMode10:%String,TPayMode11:%String,TPayMode12:%String,TPayMode13:%String,TPayMode14:%String,TPayMode15:%String,TPayMode16:%String,TPayMode17:%String,TPayMode18:%String,TPayMode19:%String,TSum:%String,TCashier:%String,TCheque:%String,TOther:%String,TRefund:%String,TNormal:%String,TRcpt:%String,TInceptFlag:%String,TInceptDate:%String,TInceptUser:%String")
{
}

/// w ##Class(web.DHCPE.DHCPEUSERREPORT).getUserPDFootLast(3786)
/// 获取上次结算日期，如果第一次结算，则取第一张发票时间
ClassMethod getUserPDFootLast(userid As %Library.String = "") As %String
{
	s (lastfootdate,lastfoottime,lastfootdate1,lastfoottime1)=""
	s lastfootid=0
   	if '$d(^DHCPEUSERREPORT(0,"USER",userid))
   	{
	   s invid=$o(^DHCPEINVPRT(0,"RPFLAG",userid,"N",0))
	   if invid'=""
	   {
       		s lastfootdate=$p(^DHCPEINVPRT(invid),"^",11)
   	   		s lastfoottime=$p(^DHCPEINVPRT(invid),"^",12)
	   }
   	}
   	else
   	{
	   	s lastfootid=$o(^DHCPEUSERREPORT(0,"USER",userid,""),-1)   
   		s lastfootdate=$p(^DHCPEUSERREPORT(lastfootid),"^",2)
   		s lastfoottime=$p(^DHCPEUSERREPORT(lastfootid),"^",3)
   	}
   	i lastfootdate'=""  s lastfootdate1=##class(websys.Conversions).DateLogicalToHtml(lastfootdate)
   	i lastfoottime'=""  s lastfoottime1=$ZT(lastfoottime)
   	q lastfootid_"^"_lastfootdate1_"^"_lastfoottime1_"^"_lastfootdate_"^"_lastfoottime
}

// w ##class(web.DHCPE.DHCPEUSERREPORT).getPDbyUser(3786)

ClassMethod getPDbyUser(userid As %Library.String = "") As %String
{
   q:userid="" "-1"
   
   q:'($d(^DHCPEINVPRT(0,"USER",userid))||($D(^DHCPEAP(0,"User",userid)))) "-2"
   k pmPLIST,paPLIST
	k ^DHCPEUserReportEx("Temp","CatFee",userid)
	k ^DHCPEUserReportEx("Temp","PayMode",userid)
	k ^DHCPEUserReportEx("Temp","InvNoStr",userid)
	k ^DHCPEUserReportEx("Temp","InvNoCount",userid)
	k ^DHCPEUserReportEx("Temp","SSP",userid)
   s usercount=1
   s usernos=""
   s username=$p($g(^SSU("SSUSR",userid)),"^",2)
   s userno=$p($g(^SSU("SSUSR",userid)),"^",1)
   if usernos="" s usernos=","
   s usernos=usernos_userno_","
   s usernames=username
   
   s rtn=..getUserPDFootLast(userid)
   s stdate=$p(rtn,"^",2),sttime=$p(rtn,"^",3)
   s enddate=##class(websys.Conversions).DateLogicalToHtml(+$H),endtime=$ZT($p($H,",",2))
   
   s timestmp=$h
   s splitChar="^"
   k ^DHCPETemp("UserReport",userid)
   k ^DHCPECashierTemp("UserReportPayMode",userid)
   s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
   s footnum=0,refundnum=0,rcptstr="",RefInvNoStr=""
   s roundfee=0
   s normalroundfee=0
   s refundroundfee=0
   s sswr=0   //四舍五入金额
   s refundSswr=0  //
   s prtid=0
	
   f  s prtid=$o(^DHCPEINVPRT(0,"RPFLAG",userid,"N",prtid)) q:(prtid="")  d
   .//预结算的跳过 
   .s InvoNo=$P($G(^DHCPEINVPRT(prtid)),"^",1)
   .q:InvoNo=("DHCPEYJS"_userid)
   .s prtflag=$p(^DHCPEINVPRT(prtid),"^",8)
   .s oneSswr=$p(^DHCPEINVPRT(prtid),"^",21)
   .i prtflag="S"  d
   ..s refinvid=$p(^DHCPEINVPRT(prtid),"^",9)
   ..s tmprefinvno=""
   ..i refinvid'="" d
   ...s tmprefinvno=$p($g(^DHCPEINVPRT(refinvid)),"^",1)
   ...s RFocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_refinvid,""))
   ...i RFocusPrintID'="" d
   ....s tmprefinvno=$LG(^User.DHCPEINVFocusPrtD(RFocusPrintID),3)
   ...s oneamt=$p($g(^DHCPEINVPRT(refinvid)),"^",7)
   ...s tmprefinvno=tmprefinvno_"("_oneamt_")"
   ...
   ..q:tmprefinvno["DHC"
   ..s refundnum=refundnum+1
   ..s refundSswr=refundSswr-oneSswr
   ..i tmprefinvno'=""  d
   ...i RefInvNoStr="" s RefInvNoStr=tmprefinvno
   ...e  s RefInvNoStr=RefInvNoStr_","_tmprefinvno
   .e  d
   ..s sswr=sswr+oneSswr
   ..s tmprefinvno=$p($g(^DHCPEINVPRT(prtid)),"^",1)
   .q:tmprefinvno["DHC"
   .s arrcp=$p(^DHCPEINVPRT(prtid),"^",4)
   .s paym="0"
   .f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d   
   ..s ss=^ARRCP(arrcp,"PAYM",paym)
   ..s pmdesc=""
   ..s mode=$p(ss,"^",1)
   ..Q:'$D(^CT("CTPM",mode))
   ..i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
   ..s pdamt=+$p(ss,"^",3)
   ..s (payamount,paynormalamount,paynormalnum,payrefundamount,payrefundnum)=0
   ..//q:mode=""
   ..i $d(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode))  d
   ...s payamount=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,1)
   ...s paynormalamount=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,2)
   ...s paynormalnum=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,3)
   ...s payrefundamount=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,4)
   ...s payrefundnum=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,5)
   ..s payamount=+payamount+pdamt+oneSswr
   ..i prtflag'="S"  d
   ...s paynormalamount=+paynormalamount+pdamt+oneSswr
   ...s paynormalnum=+paynormalnum+1
   ...s ^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Normal")=$g(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Normal"))_"^"_$p(^DHCPEINVPRT(prtid),"^",1)   //Add 20080707
   ..e  d
   ...s payrefundamount=+payrefundamount-pdamt-oneSswr
   ...s payrefundnum=+payrefundnum+1
   ...s ^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Refund")=$g(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Refund"))_"^"_$p(^DHCPEINVPRT(prtid),"^",1)   //Add 20080707
   ..s ^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)=$j(payamount,3,2)_splitChar_$j(paynormalamount,3,2)_splitChar_paynormalnum_splitChar_$j(payrefundamount,3,2)_splitChar_payrefundnum_splitChar_pmdesc
   ..s footsum=footsum+pdamt
   ..i prtflag'="S"  s pdsum=pdsum+pdamt
   ..i prtflag="S"  s refundsum=refundsum-pdamt
   ..i pmdesc="现金" s cashsum=cashsum+pdamt
   ..i pmdesc="支票" s chequesum=chequesum+pdamt
   .s receiptsno=$p(^DHCPEINVPRT(prtid),"^",1)
   .i prtflag'="S" d
   ..q:receiptsno["DHC"
   ..s footnum=footnum+1
   ..s rcptstr=..getrcptstr(rcptstr,receiptsno,"1",userid)

   .i prtflag'="S"  d
   ..s refundroundfee=refundroundfee+..GetRoundingFeeByInvPrt(prtid)
   .e  d
   ..s normalroundfee=normalroundfee+..GetRoundingFeeByInvPrt(prtid)
   .d ##class(web.DHCPE.DHCPEUSERREPORT).GetUserCatInfo(userid,prtid)

   s roundfee=normalroundfee-refundroundfee
  
   ////////////////////////////////////////////////////////////////////////////////
   
   s APID=0
   f  s APID=$o(^DHCPEAP(0,"ReportFlag",userid,"N",APID)) q:APID=""  d
   .s Sub=0
   .f  s Sub=$o(^DHCPEAP(0,"ReportFlag",userid,"N",APID,Sub)) q:Sub=""  d
   ..s Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   ..q:(Type'="B")&&(Type'="R")&&(Type'="RF")
   ..s Fee=$P(^DHCPEAP(APID,"AC",Sub),"^",2)
   ..s pdamt=Fee
   ..s OldID=$P(^DHCPEAP(APID,"AC",Sub),"^",4)
   ..i Type'="RF" s footnum=footnum+1
   ..i Type="RF" d
   ...s refinvid=$P(^DHCPEAP(+OldID,"AC",$P(OldID,"||",2)),"^",4)
   ...i refinvid'="" s refundnum=refundnum+1
   ...s oneamt=$P(^DHCPEAP(+OldID,"AC",$P(OldID,"||",2)),"^",2)
   ...i refinvid'="" s refinvid=refinvid_"("_oneamt_")"
   ...i RefInvNoStr="" s RefInvNoStr=refinvid
   ...e  s RefInvNoStr=RefInvNoStr_","_refinvid
   ..s mode=$P(^DHCPEAP(APID,"AC",Sub),"^",10)
   ..s pmdesc=""
   ..i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
   ..s (payamount,paynormalamount,paynormalnum,payrefundamount,payrefundnum)=0
   ..//q:mode=""
   ..i $d(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode))  d
   ...s payamount=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,1)
   ...s paynormalamount=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,2)
   ...s paynormalnum=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,3)
   ...s payrefundamount=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,4)
   ...s payrefundnum=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)),splitChar,5)
   ..s payamount=+payamount+pdamt
   ..i Type'="RF" d
   ...s paynormalamount=+paynormalamount+pdamt
   ...s paynormalnum=+paynormalnum+1
   ...s ^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Normal")=$g(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Normal"))_"^"_OldID   //Add 20080707
   ..e  d
   ...s payrefundamount=+payrefundamount-pdamt
   ...s payrefundnum=+payrefundnum+1
   ...s ^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Refund")=$g(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,mode,"Refund"))_"^"_refinvid   //Add 20080707
   ..s ^DHCPETemp("UserReport",userid,"PayMode",timestmp,mode)=$j(payamount,3,2)_splitChar_$j(paynormalamount,3,2)_splitChar_paynormalnum_splitChar_$j(payrefundamount,3,2)_splitChar_payrefundnum_splitChar_pmdesc
   ..s footsum=footsum+pdamt
   ..i Type'="RF"  s pdsum=pdsum+pdamt
   ..i Type="RF"  s refundsum=refundsum-pdamt
   ..i pmdesc="现金" s cashsum=cashsum+pdamt
   ..i pmdesc="支票" s chequesum=chequesum+pdamt
   ..i Type'="RF" d
   ...s receiptsno=$P(^DHCPEAP(APID,"AC",Sub),"^",4)
   ...s rcptstr=..getrcptstr(rcptstr,receiptsno,"1",userid)
   

   s rcptstr=..getrcptstr("","","2",userid)
   
   ///////////////////////////////////////////////////////////////////////////////
   ;q:footnum=0 "-2"
   s (cashnormal,cashrefund)=""
   s paymodeinfos=""
   s paymode=0
   f  s paymode=$o(^DHCPETemp("UserReport",userid,"PayMode",timestmp,paymode)) q:paymode=""  d
   .if paymodeinfos'="" s paymodeinfos=paymodeinfos_"#"
   .s paymodeinfos=paymodeinfos_paymode_splitChar_$g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,paymode))
   .i "现金"=$p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,paymode)),"^",6)  d
   ..s cashsum= $p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,paymode)),"^",1)
   ..s cashnormal= $p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,paymode)),"^",2)
   ..s cashrefund= $p($g(^DHCPETemp("UserReport",userid,"PayMode",timestmp,paymode)),"^",4)
   
   k ^DHCPETemp("UserReport",userid)
   s othersum=footsum-cashsum-chequesum
   s usernos=$e(usernos,2,$l(usernos)-1)
   s footsum=footsum+sswr-refundSswr
   s pdsum=pdsum+sswr
   s refundsum=refundsum+refundSswr
   s cashsum=cashsum //+sswr-refundSswr
   s cashnormal=cashnormal //+sswr
   s cashrefund=cashrefund //+refundSswr
   s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr_"^"_RefInvNoStr_"^"_usercount_"^"_usernos_"^"_$j(cashnormal,3,2)_"^"_$j(cashrefund,3,2)_"^"_userid_"^"_username_"^"_userno_"^"_userid_"^"_username_"^"_userno_"^"_usernames_"^"_$j(roundfee,3,2)_"^"_$j(normalroundfee,3,2)_"^"_$j(refundroundfee,3,2)_"^"_timestmp_"^"_sswr_"^"_refundSswr_"^&"_paymodeinfos    //Modify 20080707
    
   q rtn
}

/// 收费员日结后台核对
ClassMethod AuditUserRpt(userreportid, userid) As %String
{
	if userreportid="" q "未指定要核对的日结记录!"
	if userid="" q "未指定核对人!"
	s curDate=+$h
	s curTime=$p($h,",",2)
	
	&SQL(Update DHC_PE_USERREPORT set rp_inceptflag='Y',rp_inceptuser_dr=:userid,rp_inceptdate=:curDate,rp_incepttime=:curTime
		Where rp_rowid=:userreportid and rp_inceptflag='N')
	if SQLCODE'=0 q "更新日结核对状态失败,请检查该日结是否已经核对!"
	q ""
}

/// 根据日结获取凑整费
ClassMethod GetRoundingFeeByUserRpt(userreportid) As %String
{
	new rtn,normalamount,refundamount
	new invid
	s rtn=""
	if userreportid="" q rtn
	if '$d(^DHCPEUSERREPORT(userreportid)) q ""
	s invid=""
	s amount=0
	s (normalamount,refundamount)=0
	f  s invid=$o(^DHCPEINVPRT(0,"REPORT",userreportid,invid)) q:(invid="")  d
	.if $p($g(^DHCPEINVPRT(invid)),"^",8)="N"  d
	..s normalamount=normalamount+..GetRoundingFeeByInvPrt(invid)
	.e  d
	..s refundamount=refundamount+..GetRoundingFeeByInvPrt(invid)
	
	q normalamount_"^"_refundamount
}

/// 根据发票获取凑整费
ClassMethod GetRoundingFeeByInvPrt(invid) As %String
{
	new rtn,i
	new invData,roundfeeid
	new billId,relateId,preAuditId
	new preAdmId,childsub,feesub,FeeType,subroot,feeData
	new amount,FactAmount
	s rtn=""
	if invid="" q rtn
	s invData=$g(^DHCPEINVPRT(invid))
	if invData="" q rtn
	s roundfeeid=..GetPESetting("RoundingFee")
	if roundfeeid=""  q rtn
	
	s i=0
	s billId=$p(invData,"^",3)
	s relateId=""

	s amount=0		
	f  s relateId=$o(^DHCPEPAPBR(0,"PBDR",billId,relateId)) q:(relateId="")  d
	.s preAuditId=$p($g(^DHCPEPAPBR(relateId)),"^",1)
	.q:preAuditId=""
	.///取项目
	.s FeeType=1
	.s subroot="ORDITEM"
	.s preAdmId=""
	.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId=""))  d
	..s childsub=""
	..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub=""))  d
	...
	...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
	...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",1)'=roundfeeid	//判断是否有效
	...
	...s feesub=0
	...f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,feesub)) q:((feesub=""))  d
	....s feeData=$g(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub))	
	....s FactAmount=$p(feeData,"^",2)
	....s amount=amount+FactAmount
	q amount
}

ClassMethod GetPESetting(key)
{
	i key="" q ""
	q $g(^DHCPESetting("DHCPE", key))
}

/// w ##class(web.DHCPE.DHCPEUSERREPORT).GetPDFeeCatInfo()
ClassMethod GetPDFeeCatInfo(userreportid)
{
	new rowid,invid
	new curdatetime,job
	new feecat,feeCatInfos,c,feeamount,feecatdesc
	new prtflag,rptnum,rptAmount
	s rptAmount=0
	i userreportid="" q ""
	i '$d(^DHCPECashierTemp("UserReport",userreportid))  d
	.s rowid=0
	.f  s rowid=$o(^DHCPEINVPRT(0,"REPORT",userreportid,rowid))  q:rowid=""  d
	..s prtflag=$p(^DHCPEINVPRT(rowid),"^",8)
	..s rptnum=1
	..s invid=rowid
   	..i prtflag="S"  d
   	...s rptnum=-1
   	...s invid=$p(^DHCPEINVPRT(rowid),"^",9)
   	..s curdatetime=$p($g(^DHCPECashierTemp("InvListInfo",invid)),"^",1)
   	..s job=$p($g(^DHCPECashierTemp("InvListInfo",invid)),"^",2)
   	..q:((curdatetime="")||(job=""))
	..s feecat=""
	..f  s feecat=$o(^DHCPECashierTemp("InvListInfo",curdatetime,job,1,"FeeCatData",feecat)) q:((feecat=""))  d
	...s feeamount=$g(^DHCPECashierTemp("InvListInfo",curdatetime,job,1,"FeeCatData",feecat))
	...s feeamount=$j(feeamount,3,2)
	...s feeamount=feeamount*rptnum
	...//w feecat_":"_feeamount,!
	...s ^DHCPECashierTemp("UserReport",userreportid,feecat)=+feeamount+$g(^DHCPECashierTemp("UserReport",userreportid,feecat))
	
	s feecat=""
	s feeCatInfos=""
 	f  s feecat=$o(^DHCPECashierTemp("UserReport",userreportid,feecat)) q:((feecat=""))  d
 	.s feeamount=^DHCPECashierTemp("UserReport",userreportid,feecat)
 	.s feecatdesc=$p($g(^DHCTarC("TOC",feecat)),"^",2)
 	.s rptAmount=rptAmount+feeamount
 	.s feeCatInfos=feeCatInfos_"#"_feecatdesc_"^"_feeamount
 	//q feeCatInfos
 	i feeCatInfos'="" s feeCatInfos=$e(feeCatInfos,2,$l(feeCatInfos))
 	q feeCatInfos
}

ClassMethod GetReportInvDetail(ind)
{
	s puserId=%session.Get("LOGON.USERID")	
	s nextInd=$o(^DHCCashierTemp("UserReport","InvDetail",puserId,ind))
	if ind=0
	{	q nextInd_"^"_$g(^DHCCashierTemp("UserReport","InvDetail",puserId))}
	else
	{	q nextInd_"^"_$g(^DHCCashierTemp("UserReport","InvDetail",puserId,ind))}
}

ClassMethod RecordPayReciptNo(userreportid, userid, timestmp)
{
	s paymode=""
	k ^DHCPEUSERRPTPAYMODE(userreportid)
	f  s paymode=$o(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,paymode)) q:(paymode="")  d
	.s status=""
	.f  s status=$o(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,paymode,status)) q:(status="")  d
	..s tmp=$g(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,paymode,status))
	..i tmp'="" s tmp=$e(tmp,2,$l(tmp))
	..s ^DHCPEUSERRPTPAYMODE(userreportid,paymode,status)=$g(^DHCPECashierTemp("UserReportPayMode",userid,timestmp,paymode,status))
}

/// w ##Class(web.DHCPE.DHCPEUSERREPORT).GetReceiptsByPayMode(9,"",4)
ClassMethod GetReceiptsByPayMode(userreportid, userid, paymodedr)
{
	//q userreportid_"^"_userid_"^"_paymodedr
	s receiptnos=""
	s invprtid=""
	i userreportid=""  d
	.f  s invprtid=$o(^DHCPEINVPRT(0,"RPFLAG",userid,"N",invprtid)) q:invprtid=""  d
	..d AddReceiptNos
	e  d
	.f  s invprtid=$o(^DHCPEINVPRT(0,"REPORT",userreportid,invprtid)) q:invprtid=""  d
	..d AddReceiptNos
	
	q receiptnos
	
AddReceiptNos
	i ..InvHasPayMode(invprtid,paymodedr)=1  d
	.i $p(^DHCPEINVPRT(invprtid),"^",8)="S"  d
	..s receiptno=$p(^DHCPEINVPRT(invprtid),"^",9)
	..s receiptno=$p(^DHCPEINVPRT(receiptno),"^",1)
	.e  d
	..s receiptno=$p(^DHCPEINVPRT(invprtid),"^",1)
	.q:($p(^DHCPEINVPRT(invprtid),"^",8)="S")
	.i receiptnos=""  d
	..s receiptnos=receiptno
	.e  d
	..s receiptnos=receiptnos_","_receiptno
	q
}

ClassMethod InvHasPayMode(invprtid, paymodedr)
{
	s result=0
	s recipet=$p(^DHCPEINVPRT(invprtid),"^",4)
	s paym=0
	f  s paym=$o(^ARRCP(recipet,"PAYM",paym)) q:paym=""  d
	.i $p(^ARRCP(recipet,"PAYM",paym),"^",1)=paymodedr s result=1
	q result
}

/// w ##Class(web.DHCPE.DHCPEUSERREPORT).GetCatInfoByFootID("10")
/// StrType  0  原来日报格式
/// 		 1  根据收费项目分类
ClassMethod GetCatInfoByFootID(FootIDStr, StrType As %String = 0)
{
	s sswr=0
	s refundSswr=0
    i FootIDStr=""  q ""
    k ^TMPINVCAT($J)
    s len=$l(FootIDStr,"^")
    f i=1:1:len {
    	s FootID=$p(FootIDStr,"^",i)
    	s sswr=sswr+$P(^DHCPEUSERREPORT(FootID),"^",12)
    	s refundSswr=refundSswr+$P(^DHCPEUSERREPORT(FootID),"^",13)
    	s PEINVID=0
		f  s PEINVID=$o(^DHCPEINVPRT(0,"REPORT",FootID,PEINVID)) q:PEINVID=""  d
		.d ..GetCatFee(PEINVID)
     }

   
    s Fee=""
	s CatSub=""
	f  s CatSub=$o(^TMPINVCAT($J,"TotalFee",CatSub)) q:CatSub=""  d
	.s CatDesc=$p($G(^DHCTarC("TOC",CatSub)),"^",2)
	.s TotalFee="",CatFee="",ReduseFee=""
	.s TotalFee=$G(^TMPINVCAT($J,"TotalFee",CatSub))
	.s CatFee=$G(^TMPINVCAT($J,"Fee",CatSub))
	.s ReduseFee=$G(^TMPINVCAT($J,"ReduseFee",CatSub))
    .q:(TotalFee=0)&&(ReduseFee=0)&&(CatFee=0)
    .i Fee=""  d
    ..s Fee=TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
    .e  d
    ..s Fee=Fee_"$"_TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
  	
  	s TotalFee=0,ReduseFee=0,CatFee=0,CatDesc="预缴金"
   	f i=1:1:len {
    	s FootID=$p(FootIDStr,"^",i)
    	s APID=0
  	
   		f  s APID=$o(^DHCPEAP(0,"Report",FootID,APID)) q:APID=""  d
   		.s Sub=0
   		.f  s Sub=$o(^DHCPEAP(0,"Report",FootID,APID,Sub)) q:Sub=""  d
   		..s Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   		..q:(Type'="B")&&(Type'="R")&&(Type'="RF")
   		..s OneFee=$P(^DHCPEAP(APID,"AC",Sub),"^",2)
   		..s PayModeID=$P(^DHCPEAP(APID,"AC",Sub),"^",10)
   		..i Type="RF" d
   		...s ReduseFee=ReduseFee-OneFee
   		..i Type'="RF" d
   		...s TotalFee=TotalFee+OneFee
   		..s ^TMPINVCAT($J,"USERREPORT","999999999999",PayModeID)=+$G(^TMPINVCAT($J,"USERREPORT","999999999999",PayModeID))+OneFee
   		..s CatFee=CatFee+OneFee
   	}
  	i TotalFee'=0 d
  	.i Fee=""  d
    ..s Fee=TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
    .e  d
    ..s Fee=Fee_"$"_TotalFee_":"_ReduseFee_":"_CatFee_":"_CatDesc
   
   
   	i Fee=""  d
    .s Fee=sswr_":"_refundSswr_":"_(sswr-refundSswr)_":舍入费"
    e  d
    .s Fee=Fee_"$"_sswr_":"_refundSswr_":"_(sswr-refundSswr)_":舍入费"
  	
   	i StrType=1
   	{
	   	s Fee=..GetPayModeStr()
   	}
  	k ^TMPINVCAT($J)
  
  	q Fee
}

// 在日报上得到个人和团体金额

// w ##Class(web.DHCPE.DHCPEUSERREPORT).GetInfoStrStrByFootID("10")

ClassMethod GetInfoStrStrByFootID(FootStr)
{
    k ^TMPINVGroupAmount
    k ^TMPINVPersonAmount
    i FootStr=""  q ""
    
    s len=$l(FootStr,"^")
    f i=1:1:len {
    	s FootID=$p(FootStr,"^",i)
    	s INVID=0
		f  s INVID=$o(^DHCPEINVPRT(0,"REPORT",FootID,INVID)) q:INVID=""  d
              .s Flag=1
		.s RPEINVID=$p(^DHCPEINVPRT(INVID),"^",9)
		.i RPEINVID'="" d
              ..s Flag=-1
		.s PAADM=$p(^DHCPEINVPRT(INVID),"^",2)
		.s PRTAcount=$p(^DHCPEINVPRT(INVID),"^",7)
        .//s PRTAcount=(+PRTAcount)*Flag
        .i $d(^DHCPEIADM(0,"PAADM",PAADM)) d
        ..s ^TMPINVPersonAmount($J,"Fee")=+$G(^TMPINVPersonAmount($J,"Fee"))+PRTAcount
        ..i Flag=1 d
	    ...s ^TMPINVPersonAmount($J,"TotalFee")=+$G(^TMPINVPersonAmount($J,"TotalFee"))+PRTAcount
        ..i Flag=-1 d
        ...s ^TMPINVPersonAmount($J,"ReduseFee")=+$G(^TMPINVPersonAmount($J,"ReduseFee"))-PRTAcount
        .else  d
        ..s GADM=0
        ..s GADM=$O(^DHCPEGADM(0,"DelegateADM",PAADM,GADM))
        ..q:GADM=""
        ..s GBaseID=$P(^DHCPEGADM(GADM),"^",1)
        ..s ^TMPINVGroupAmount($J,GBaseID,"Fee")=+$G(^TMPINVGroupAmount($J,GBaseID,"Fee"))+PRTAcount
        ..i Flag=1 d
	    ...s ^TMPINVGroupAmount($J,GBaseID,"TotalFee")=+$G(^TMPINVGroupAmount($J,GBaseID,"TotalFee"))+PRTAcount
        ..i Flag=-1 d
        ...s ^TMPINVGroupAmount($J,GBaseID,"ReduseFee")=+$G(^TMPINVGroupAmount($J,GBaseID,"ReduseFee"))-PRTAcount
		
     }
     s PersonReduseFee="",PersonTotalFee="",PersonFee="",ReturnStr=""
     s PersonStr=PersonTotalFee_":"_PersonReduseFee_":"_PersonFee_":"_"个人"
     S PersonFee=$g(^TMPINVPersonAmount($J,"Fee"))
     s PersonTotalFee=$g(^TMPINVPersonAmount($J,"TotalFee"))
     s PersonReduseFee=$g(^TMPINVPersonAmount($J,"ReduseFee"))
     s PersonStr=PersonTotalFee_":"_PersonReduseFee_":"_PersonFee_":"_"个人"
     s GBaseID=0
     s GroupStr=""
     f  s GBaseID=$o(^TMPINVGroupAmount($J,GBaseID))  q:GBaseID=""  d
     .S GFee=$g(^TMPINVGroupAmount($J,GBaseID,"Fee"))
     .s GTotalFee=$g(^TMPINVGroupAmount($J,GBaseID,"TotalFee"))
     .s GReduseFee=$g(^TMPINVGroupAmount($J,GBaseID,"ReduseFee"))
     .s GBaseDesc=$p(^DHCPEGBI(GBaseID),"^",2)
     .i GroupStr=""  s GroupStr=GTotalFee_":"_GReduseFee_":"_GFee_":"_GBaseDesc
     .else  s GroupStr=GroupStr_"$"_GTotalFee_":"_GReduseFee_":"_GFee_":"_GBaseDesc
    
     i GroupStr'="" s ReturnStr=PersonStr_"$"_GroupStr
     else  s ReturnStr=PersonStr
     q ReturnStr
}

// w ##Class(web.DHCPE.DHCPEUSERREPORT).GetCatFee("34")

ClassMethod GetCatFee(CurINVID)
{
  	n (CurINVID)
    s RPEINVID=$p(^DHCPEINVPRT(CurINVID),"^",9)
    s Flag=1
    i RPEINVID'="" d
    .s CurINVID=RPEINVID
    .s Flag=-1
    i '$d(^DHCPEDataEX("DHCPEInvice",CurINVID)) d
    .s err=##class(web.DHCPE.Cashier).GetFeeCatInfo(CurINVID)
    //虚拟发票退出
    s InvNo=$p(^DHCPEINVPRT(CurINVID),"^",1)
    q:(InvNo["DHC") ""
    
    s PayInfo=..GetPayModeInfoByInvID(CurINVID)
    s Total=$p(PayInfo,"$",2)
    s PayInfo=$p(PayInfo,"$",1)
    
    s CatSub=""
    f  s CatSub=$o(^DHCPEDataEX("DHCPEInvice",CurINVID,CatSub)) q:CatSub=""  d
    .s CatStr=$G(^DHCPEDataEX("DHCPEInvice",CurINVID,CatSub))
    .s CatStr=(+CatStr)*Flag
    .s ^TMPINVCAT($J,"Fee",CatSub)=+$G(^TMPINVCAT($J,"Fee",CatSub))+CatStr
    .d ..SetCatPayModeFee(CatStr,CatSub,PayInfo,Total)
	.i Flag=1 d
	..s ^TMPINVCAT($J,"TotalFee",CatSub)=+$G(^TMPINVCAT($J,"TotalFee",CatSub))+CatStr
    .i Flag=-1 d
    ..s ^TMPINVCAT($J,"ReduseFee",CatSub)=+$G(^TMPINVCAT($J,"ReduseFee",CatSub))-CatStr
    
    q ""
}

ClassMethod GetPayModeInfoByInvID(InvID)
{
	n (InvID)
	s ret=""
	s Amt=0
	s ARRCPID=$p(^DHCPEINVPRT(InvID),"^",4)
	s ARRCPSub=0
	f  s ARRCPSub=$o(^ARRCP(ARRCPID,"PAYM",ARRCPSub)) q:ARRCPSub=""  d
	.s PayModeID=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",1)
	.s Amount=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",3)
	.s Amt=Amt+Amount
	.i ret=""  d
	..s ret=PayModeID_"^"_Amount
	.e  d
	..s ret=ret_"&"_PayModeID_"^"_Amount
	q ret_"$"_Amt
}

ClassMethod SetCatPayModeFee(CatStr, CatSub, PayInfo, Total)
{
	n (ReportID,CatStr,CatSub,PayInfo,Total)
	s i=$L(PayInfo,"&")
	for j=1:1:i  d
	.s OneInfo=$p(PayInfo,"&",j)
	.s PayID=$p(OneInfo,"^",1)
	.s Fee=$p(OneInfo,"^",2)
	.s Fee=(Fee/Total)*CatStr
	.s ^TMPINVCAT($J,"USERREPORT",CatSub,PayID)=+$G(^TMPINVCAT($J,"USERREPORT",CatSub,PayID))+Fee
	.i '$D(^TMPINVCAT($J,"PayModeID",PayID)) d
	..s Sort=+$G(^TMPINVCAT($J,"PayModeID"))+1
	..s ^TMPINVCAT($J,"PayModeID",PayID)=Sort
	..s ^TMPINVCAT($J,"PayModeID")=Sort
	..s ^TMPINVCAT($J,"PayModeIDSort",Sort)=PayID
}

ClassMethod GetPayModeStr()
{
	;^TMPINVCAT($J,"USERREPORT",CatID,PayModeID)
	;门诊收费项目^收入金额^现金^支票^医保&
	;化验        ^30       ^10  ^20  ^0   &
	;检查        ^90       ^30  ^40  ^20  &
	;预缴金      ^50       ^20  ^10  ^20  &
	;合计        ^170      ^60  ^70  ^40
	n ret
	s ret="门诊收费项目^收入金额"
	k PLIST
	//得到各个分类的字符串
	s i=$G(^TMPINVCAT($J,"PayModeID"))
	f j=1:1:i d
	.s PayID=^TMPINVCAT($J,"PayModeIDSort",j)
	.s PayDesc=$p(^CT("CTPM",PayID),"^",2)
	.s ret=ret_"^"_PayDesc
	s CatID=""
	f  s CatID=$o(^TMPINVCAT($J,"USERREPORT",CatID)) q:CatID=""  d
	.s PayMode=""
	.i CatID="999999999999" d
	..s CatDesc="预缴金"
	.e  d
	..s CatDesc=$p($G(^DHCTarC("TOC",CatID)),"^",2)
	.k FeePLIST
	.f  s PayMode=$o(^TMPINVCAT($J,"USERREPORT",CatID,PayMode)) q:PayMode=""  d
	..s Sort=$G(^TMPINVCAT($J,"PayModeID",PayMode))
	..s FeePLIST(Sort)=+$G(^TMPINVCAT($J,"USERREPORT",CatID,PayMode))
	..s FeePLIST(0)=+$G(FeePLIST(0))+FeePLIST(Sort)
	..s PLIST(0)=+$G(PLIST(0))+FeePLIST(Sort)
	..s PLIST(Sort)=+$G(PLIST(Sort))+FeePLIST(Sort)
	.s OneStr=CatDesc
	.f j=0:1:i  d
	..s OneStr=OneStr_"^"_$G(FeePLIST(j))
	.s ret=ret_"&"_OneStr
	//输出合计
	s OneStr="合计"
	f j=0:1:i  d
	.s OneStr=OneStr_"^"_$G(PLIST(j))
	s ret=ret_"&"_OneStr
	q ret
}

// w ##Class(web.DHCPE.DHCPEUSERREPORT).GetFootIDStrByDate("2009-1-30","2009-12-30")

ClassMethod GetFootIDStrByDate(StartDate, EndDate)
{
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	s FootIDStr=""
	s fdate=StartDate-1
	f  s fdate=$o(^DHCPEUSERREPORT(0,"DATE",fdate)) q:(fdate="")||(fdate>EndDate)  d
	.s rowid=0
	.f  s rowid=$o(^DHCPEUSERREPORT(0,"DATE",fdate,rowid))  q:rowid=""  d
	..i FootIDStr=""  d
	...s FootIDStr=rowid
	..e  d
	...s FootIDStr=FootIDStr_"^"_rowid
	q FootIDStr
}

ClassMethod AutoFootPD()
{
  
   s USERDR=0
   f  s USERDR=$o(^DHCPEINVPRT(0,"RPFLAG",USERDR))  q:USERDR=""  d
   .i $D(^DHCPEINVPRT(0,"RPFLAG",USERDR,"N")) d
   ..d ..FootPDbyUser(USERDR,"","")
   q ""
}

// d ##class(web.DHCPE.DHCPEUSERREPORT).Test()

ClassMethod Test()
{
	s prtid=0
	k ^DHCPEUserReportEx("Temp")
	f  s prtid=$O(^DHCPEINVPRT(0,"REPORT",12,prtid)) q:prtid=""  d
	.d ##class(web.DHCPE.DHCPEUSERREPORT).GetUserCatInfo("2969",prtid)
	m ^DHCPEUserReportEx("CatFee",12)=^DHCPEUserReportEx("Temp","CatFee",2969)
		m ^DHCPEUserReportEx("PayMode",12)=^DHCPEUserReportEx("Temp","PayMode",2969)
		m ^DHCPEUserReportEx("InvNoStr",12)=^DHCPEUserReportEx("Temp","InvNoStr",2969)
		m ^DHCPEUserReportEx("InvNoCount",12)=^DHCPEUserReportEx("Temp","InvNoCount",2969)
		k ^DHCPEUserReportEx("Temp","CatFee",2969)
		k ^DHCPEUserReportEx("Temp","PayMode",2969)
		k ^DHCPEUserReportEx("Temp","InvNoStr",2969)
		k ^DHCPEUserReportEx("Temp","InvNoCount",2969)
}

// d ##class(web.DHCPE.DHCPEUSERREPORT).GetUserCatInfo(2986,85)

ClassMethod GetUserCatInfo(userID, InvID)
{
	n (userID, InvID)
	s refundFlag=$p($g(^DHCPEINVPRT(InvID)),"^",8)
	s paymodeInfo=..GetPayModeInfoByInvID(InvID)
	s paymode=$P(paymodeInfo,"^",1)
	s amt=+$P(paymodeInfo,"^",2)
	s curSswr=+$p($g(^DHCPEINVPRT(InvID)),"^",21)
	s flag=0
	i refundFlag="S" d
	.s oldInvID=$p($g(^DHCPEINVPRT(InvID)),"^",9)
	.s oldInvNo=$p($g(^DHCPEINVPRT(oldInvID)),"^",1)
	.s oldAmt=$p($g(^DHCPEINVPRT(oldInvID)),"^",7)
	.s oldSswr=+$p($g(^DHCPEINVPRT(oldInvID)),"^",21)
	.s oldInvNo=oldInvNo_"("_(oldAmt+oldSswr)_")"
	.s oldUser=$p($g(^DHCPEINVPRT(oldInvID)),"^",10)
	.i (oldUser'=userID)&&((paymode=4)||(paymode=15)) s flag=1
	.s oldReportID=$p($g(^DHCPEINVPRT(oldInvID)),"^",13)
	.i (oldReportID'="")&&((paymode=4)||(paymode=15)) s flag=1
	.//红冲的不计算到汇总金额中
	.i flag=1 d
	..s ^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvCount","Other")=+$G(^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvCount","Other"))+1
	..s ^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvAmt","Other")=+$G(^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvAmt","Other"))-amt-curSswr
	..d SetFeeCatInfo(oldInvID,"Other") //红冲
	..i $D(^DHCPEUserReportEx("Temp","InvNoStr",userID,"Other")) d
	...s ^DHCPEUserReportEx("Temp","InvNoStr",userID,"Other")=$G(^DHCPEUserReportEx("Temp","InvNoStr",userID,"Other"))_","_oldInvNo
	...s ^DHCPEUserReportEx("Temp","InvNoCount",userID,"Other")=$G(^DHCPEUserReportEx("Temp","InvNoCount",userID,"Other"))+1
	..e  d
	...s ^DHCPEUserReportEx("Temp","InvNoStr",userID,"Other")=oldInvNo
	...s ^DHCPEUserReportEx("Temp","InvNoCount",userID,"Other")=1
	.e  d
	..s ^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvCount","Refund")=+$G(^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvCount","Refund"))+1
	..s ^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvAmt","Refund")=+$G(^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvAmt","Refund"))-amt-curSswr
	..d SetFeeCatInfo(oldInvID,"Refund") //退费
	..i $D(^DHCPEUserReportEx("Temp","InvNoStr",userID,"Refund")) d
	...s ^DHCPEUserReportEx("Temp","InvNoStr",userID,"Refund")=$G(^DHCPEUserReportEx("Temp","InvNoStr",userID,"Refund"))_","_oldInvNo
	...s ^DHCPEUserReportEx("Temp","InvNoCount",userID,"Refund")=$G(^DHCPEUserReportEx("Temp","InvNoCount",userID,"Refund"))+1
	..e  d
	...s ^DHCPEUserReportEx("Temp","InvNoStr",userID,"Refund")=oldInvNo
	...s ^DHCPEUserReportEx("Temp","InvNoCount",userID,"Refund")=1
	e  d
	.s ^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvCount","Normal")=+$G(^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvCount","Normal"))+1
	.s ^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvAmt","Normal")=+$G(^DHCPEUserReportEx("Temp","PayMode",userID,paymode,"InvAmt","Normal"))+amt+curSswr
	.d SetFeeCatInfo(InvID,"Normal") //正常
	q
SetFeeCatInfo(cInvID,type)
	//s curTotal=$P(^DHCPEINVPRT(cInvID),"^",7)
	//s total=0
	s fh=1
	//k ^DHCPEDataEX("DHCPEInvice",cInvID)
	i '$D(^DHCPEDataEX("DHCPEInvice",cInvID)) d ##class(web.DHCPE.Cashier).GetFeeCatInfo(cInvID)
	i type'="Normal" s fh=-1
	s TarECID=0
	f  s TarECID=$O(^DHCPEDataEX("DHCPEInvice",cInvID,TarECID)) q:TarECID=""  d
	.s ^DHCPEUserReportEx("Temp","CatFee",userID,TarECID,paymode,type)=+$G(^DHCPEUserReportEx("Temp","CatFee",userID,TarECID,paymode,type))+(+$G(^DHCPEDataEX("DHCPEInvice",cInvID,TarECID)))
	.//s total=total+(+$G(^DHCPEDataEX("DHCPEInvice",cInvID,TarECID)))
	s ^DHCPEUserReportEx("Temp","CatFee",userID,"99999999",paymode,type)=+$G(^DHCPEUserReportEx("Temp","CatFee",userID,"99999999",paymode,type))+(fh*curSswr)
	//w:total'=curTotal cInvID_"^"_total_"^"_curTotal,!
	q
}

// d ##class(web.DHCPE.DHCPEUSERREPORT).GetReportCatInfo(12)

ClassMethod GetReportCatInfo(rptID)
{
	;s payModeStr="1^1.Other^2^14^15^15.Other^5^8^4^4.Other^6"
	//CT_PayMode
	s payModeStr="1^1.Other^2^15^15.Other^4^4.Other"
	//DHC_TarOC
	s catInfostr="4^5^6^3^8^14^16^2^17^1^9^19^99999999"
	s payModeString=""
	s CatFeeString=""
	s reportString=""
	s l=$L(payModeStr,"^")
	//增加支付方式金额
	f j=1:1:l d
	.s oneTotal=0
	.s payMode=$P(payModeStr,"^",j)
	.q:payMode=""
	.q:$L(payMode,".")>1 //其它退费的退出
	.s payModeDesc=$P($G(^CT("CTPM",payMode)),"^",2)
	.s normalCount=$G(^DHCPEUserReportEx("PayMode",rptID,payMode,"InvCount","Normal"))
	.s payModePLIST(1)=+$G(payModePLIST(1))+normalCount
	.s normalAmt=$G(^DHCPEUserReportEx("PayMode",rptID,payMode,"InvAmt","Normal"))
	.s payModePLIST(2)=+$G(payModePLIST(2))+normalAmt
	.s otherCount=$G(^DHCPEUserReportEx("PayMode",rptID,payMode,"InvCount","Other"))
	.s refundCount=$G(^DHCPEUserReportEx("PayMode",rptID,payMode,"InvCount","Refund"))
	.s payModePLIST(3)=+$G(payModePLIST(3))+refundCount
	.s refundAmt=$G(^DHCPEUserReportEx("PayMode",rptID,payMode,"InvAmt","Refund"))
	.s payModePLIST(4)=+$G(payModePLIST(4))+refundAmt
	.s jkTotal=(+normalAmt)-(+refundAmt)
	.s payModePLIST(5)=+$G(payModePLIST(5))+jkTotal //交款合计
	.s payModePLIST(6)="" //
	.s payModePLIST(7)=+$G(payModePLIST(7))+(+otherCount)
	.s otherAmt=$G(^DHCPEUserReportEx("PayMode",rptID,payMode,"InvAmt","Other"))
	.s payModePLIST(8)=+$G(payModePLIST(8))+(+otherAmt)
	.s oneTotal=jkTotal-(+otherAmt)
	.s payModePLIST(9)=+$G(payModePLIST(9))+oneTotal
	.i oneTotal=0 s oneTotal=""
	.i jkTotal=0 s jkTotal=""
	.s OneString=payModeDesc_"^"_normalCount_"^"_normalAmt_"^"_refundCount_"^"_refundAmt_"^"_jkTotal_"^"_""_"^"_otherCount_"^"_otherAmt_"^"_oneTotal
	.i payModeString="" d
	..s payModeString=OneString
	.e  d
	..s payModeString=payModeString_$C(1)_OneString
	//增加支付方式汇总
	s j=$O(payModePLIST(""),-1)
	s OneString="合计："
	f i=1:1:j  d
	.s amt=payModePLIST(i)
	.s:amt=0 amt=""
	.s OneString=OneString_"^"_amt
	i payModeString="" d
	.s payModeString=OneString
	e  d
	.s payModeString=payModeString_$C(1)_OneString
	//增加分类金额
	s m=$L(catInfostr,"^")
	f n=1:1:m d
	.s tarECID=$p(catInfostr,"^",n)
	.i tarECID="99999999" d
	..s tarECDesc="舍入费"
	.e  d
	..s tarECDesc=$p($G(^DHCTarC("TOC",tarECID)),"^",2)
	.q:tarECDesc=""
	.s OneString=tarECDesc
	.s OneTotal=0
	.s jkTotal=0
	.s otherTotal=0
	.f j=1:1:l d
	..s Char=""
	..s payMode=$P(payModeStr,"^",j)
	..q:payMode=""
	..i $L(payMode,".")>1 d //其它退费信息
	...s payModeDesc="其它退费"
	...s payMode=$P(payMode,".",1)
	...s amt=$G(^DHCPEUserReportEx("CatFee",rptID,tarECID,payMode,"Other"))
	...s otherTotal=otherTotal+amt
	...s OneTotal=OneTotal-amt
	..e  d //正常收费金额
	...s payModeDesc=$P($G(^CT("CTPM",payMode)),"^",2)
	...s normalAmt=$G(^DHCPEUserReportEx("CatFee",rptID,tarECID,payMode,"Normal"))
	...s refundAmt=$G(^DHCPEUserReportEx("CatFee",rptID,tarECID,payMode,"Refund"))
	...s amt=normalAmt-refundAmt
	...s jkTotal=jkTotal+amt //交款汇总
	...s OneTotal=OneTotal+amt //总计
	..s Char=Char_"^"
	..i amt=0 s amt=""
	..s OneString=OneString_"^"_amt
	..s CatPLIST(j)=+$G(CatPLIST(j))+(+amt)
	.s CatPLIST(l+1)=+$G(CatPLIST(l+1))+jkTotal
	.s CatPLIST(l+2)=+$G(CatPLIST(l+2))+otherTotal
	.s CatPLIST(l+3)=+$G(CatPLIST(l+3))+OneTotal
	.i OneTotal=0 s OneTotal=""
	.i jkTotal=0 s jkTotal=""
	.i otherTotal=0 s otherTotal=""
	.//增加社保自负金行
	.i n=1 d
	..s SBStr="社保自负金"_Char_"^^^"
	..i CatFeeString="" d
	...s CatFeeString=SBStr
	..e  d
	...s CatFeeString=CatFeeString_$C(1)_SBStr
	.//增加结算
	.s OneString=OneString_"^"_jkTotal_"^"_otherTotal_"^"_OneTotal
	.i CatFeeString="" d
	..s CatFeeString=OneString
	.e  d
	..s CatFeeString=CatFeeString_$C(1)_OneString
	
	
	//增加分类合计
	s j=$O(CatPLIST(""),-1)
	s OneString="合计："
	f i=1:1:j  d
	.s amt=CatPLIST(i)
	.s:amt=0 amt=""
	.s OneString=OneString_"^"_amt
	i CatFeeString="" d
	.s CatFeeString=OneString
	e  d
	.s CatFeeString=CatFeeString_$C(1)_OneString
	//得到日报信息
	s user=$p(^DHCPEUSERREPORT(rptID),"^",1)
	i user'="" s user=$P(^SSU("SSUSR",user),"^",2)
	//日报开始时间
	s date=$p(^DHCPEUSERREPORT(rptID),"^",2)
	s time=$p(^DHCPEUSERREPORT(rptID),"^",3)
	s datetime=date_","_time
	s datetime=$ZDT(datetime,3)
	//日报结束时间
	s enddate=$p(^DHCPEUSERREPORT(rptID),"^",4)
	s endtime=$p(^DHCPEUSERREPORT(rptID),"^",5)
	s endtime=enddate_","_endtime
	s endtime=$ZDT(endtime,3)
	//收费张数、具体票号
	s invNum=$p(^DHCPEUSERREPORT(rptID),"^",14)
	s invNo=$p(^DHCPEUSERREPORT(rptID),"^",6)
	//s refundNo=$p(^DHCPEUSERREPORT(rptID),"^",22)
	//其它退费张数、具体票号
	s otherNo=$G(^DHCPEUserReportEx("InvNoStr",rptID,"Other"))
	s otherCount=$G(^DHCPEUserReportEx("InvNoCount",rptID,"Other"))
	//正常退费张数、具体票号
	s refundNo=$G(^DHCPEUserReportEx("InvNoStr",rptID,"Refund"))
	s refundCount=$G(^DHCPEUserReportEx("InvNoCount",rptID,"Refund"))
	//退费信息组成一个字符串
	s refundStr=""
	i (+refundCount>0) d
	.s refundStr="正常退费发票张数为"_refundCount_",详细信息为"_refundNo
	
	i (+otherCount>0) d
	.i refundStr="" d
	..s refundStr="其它退费发票张数为"_otherCount_",详细信息为"_otherNo
	.e  d
	..s refundStr=refundStr_".其它退费发票张数为"_otherCount_",详细信息为"_otherNo
	i refundStr="" s refundStr="无"
	s reportString=user_"^"_datetime_"^"_endtime_"^"_invNum_"^"_invNo_"^"_refundStr
	q reportString_$C(2)_CatFeeString_$C(2)_payModeString
}

ClassMethod GetTJDailyHandDataHZ(FootID, Guser, HISDR, Job)
{
	New (FootID,Guser,HISDR,Job)
	;
	s ^wrz=FootID_"^"_Guser_"^"_HISDR_"^"_Job
	If FootID'="" Do
	.Set UserID=$P(^DHCPEUSERREPORT(FootID),"^",1)
	.Set Date=$P(^DHCPEUSERREPORT(FootID),"^",2)
	.Set Time=$P(^DHCPEUSERREPORT(FootID),"^",3)
	.Set footInfo=$g(^DHCOPInsFoot(HISDR))
 	.Set footUser=$p(footInfo,"^",8) 
	.Set footUserCode=$p(^SSU("SSUSR",footUser),"^",1)    ;工号
 	.Quit:footUser="3881"	;过滤北京协和医院测试用户										;HIS_User 结算人
	.Set footDate=$p(footInfo,"^",2)		
	.Set Date=$ZD(Date,3)
	.Set Time=$ZT(Time,3)
	.Set ReportDate=Date_" "_Time
	.;i FootID=45   s footDate=$zdh("2013-11-08",3),footUserCode="06148"
	.;i FootID=49   s footDate=$zdh("2013-11-12",3),footUserCode="06148"
	.;i FootID=51   s footDate=$zdh("2013-11-13",3),footUserCode="06148"
	.Set InvID=""
	.For  Set InvID=$O(^DHCPEINVPRT(0,"REPORT",FootID,InvID)) Quit:InvID=""  Do
	..Do GetDailyHandInvHZ(InvID)
   	b ;11
   	q 0
GetDailyHandInvHZ(InvID)
	Set FH=1
	Set RefInvID=$P(^DHCPEINVPRT(InvID),"^",9)

	Set Inv=InvID
	Set InvNo=$P(^DHCPEINVPRT(Inv),"^",1)
	Set InvAmt=$P(^DHCPEINVPRT(Inv),"^",7)

	//计算支付方式统计金额
	Set ARRCPID=$p(^DHCPEINVPRT(Inv),"^",4)
	Set ARRCPSub=0
	For  Set ARRCPSub=$o(^ARRCP(ARRCPID,"PAYM",ARRCPSub)) Quit:ARRCPSub=""  Do
	.Set PayModeID=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",1)
	.Set Amount=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",3)
	.set:PayModeID="21" PayModeID=13 ;注："TJDJK	体检卡支付" 做报表时体现到"TJYJJ	体检储值卡"
	.Set PayModeCode=$p(^CT("CTPM",PayModeID),"^",1)
	
	.;Set ^TMP("DailyReport","PayM",Guser,Job,PayModeID)=+$g(^TMP("DailyReport","PayM",Guser,Job,PayModeID))+(FH*Amount)	;日报汇总用
	.If (Amount>0) Do
 	..Set ^TMP("DailyHandin","AdmReaPayM","Add",Guser,Job,footUserCode,footDate,PayModeCode)=+$g(^TMP("DailyHandin","AdmReaPayM","Add",Guser,Job,footUserCode,footDate,PayModeCode))+Amount
 	.If (Amount<0) Do
 	..Set ^TMP("DailyHandin","AdmReaPayM","Refund",Guser,Job,footUserCode,footDate,PayModeCode)=+$g(^TMP("DailyHandin","AdmReaPayM","Refund",Guser,Job,footUserCode,footDate,PayModeCode))+Amount
	q 0
}

/// Creator:Lid
/// CreatDate:2013-11-14
/// Desc:获取收费员日报数据
/// Debug:w ##class(web.DHCPE.DHCPEUSERREPORT)GetReportInfoInvForXH("","5093","Y","wrz")
ClassMethod GetReportInfoInvForXH(FootID, UserID As %String = "", KillFlag As %String = "Y", Job As %String = "")
{
	New (FootID,UserID,KillFlag,Job)
	s ^wrz("UserReport")=FootID_","_UserID_","_KillFlag_","_Job
	If FootID'="" Do
	.Set UserID=$P(^DHCPEUSERREPORT(FootID),"^",1)
	.Set Date=$P(^DHCPEUSERREPORT(FootID),"^",2)
	.Set Time=$P(^DHCPEUSERREPORT(FootID),"^",3)
	.Set Date=$ZD(Date,3)
	.Set Time=$ZT(Time,3)
	.Set ReportDate=Date_" "_Time
	.Set InvID="0"
	.For  Set InvID=$O(^DHCPEINVPRT(0,"REPORT",FootID,InvID)) Quit:InvID=""  Do
	..Do GetOneInvInfoINV(InvID)
	e  d
	.s InvID="0"
	.f  s InvID=$O(^DHCPEINVPRT(0,"RPFLAG",UserID,"N",InvID)) q:InvID=""  d
	..d GetOneInvInfoINV(InvID)
	
   	q 0
GetOneInvInfoINV(InvID)
	Set FH=1
	Set RefInvID=$P(^DHCPEINVPRT(InvID),"^",9)
	If RefInvID'="" Do
	.Set FH=-1
	.Set Inv=RefInvID
	Else  Do
	.Set Inv=InvID
	Set InvNo=$P(^DHCPEINVPRT(Inv),"^",1)
	Set InvAmt=$P(^DHCPEINVPRT(Inv),"^",7)
	
	Set PrtDate=$P(^DHCPEINVPRT(Inv),"^",11)
	
	Set PrtTime=$P(^DHCPEINVPRT(Inv),"^",12)
	
	If FH=-1 Do
	.;Set RefundAmt=+$g(RefundAmt)+InvAmt
	s SSPFlag=##class(web.DHCPE.CashierEx).GetSSPFlag(Inv)
	
	//计算支付方式统计金额
	Set ARRCPID=$p(^DHCPEINVPRT(Inv),"^",4)
	Set ARRCPSub=0
	For  Set ARRCPSub=$o(^ARRCP(ARRCPID,"PAYM",ARRCPSub)) Quit:ARRCPSub=""  Do
	.Set PayModeID=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",1)
	.Set Amount=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",3)
	.;Set ^TempDHCPEUserReport(Job,"PayMode",PayModeID)=+$G(^TempDHCPEUserReport(Job,"PayMode",PayModeID))+(FH*Amount)
	.set:PayModeID="21" PayModeID=13 ;注："TJDJK	体检卡支付" 做报表时体现到"TJYJJ	体检储值卡"
	.Set ^TMP("OPBILL","PayMode",UserID,Job,PayModeID)=+$g(^TMP("OPBILL","PayMode",UserID,Job,PayModeID))+(FH*Amount)	;日报用
	.q:PayModeID="20" ;原手撕票ID
	.Set:SSPFlag=1 ^TMP("OPBILL","SSPPayMode",UserID,Job,PayModeID)=+$g(^TMP("OPBILL","SSPPayMode",UserID,Job,PayModeID))+(FH*Amount)	;日报用
	
	If InvNo'[("DHC")
	{
		Set CASHPayFlag=..CheckCASHFlag(Inv)
		If (FH=1)&&(InvNo'="") Set ^TMP("DHCOPBILL","INVNO",UserID,Job,InvNo)=InvNo
		if (FH=-1)  Do
		.//s ^tmp("sxt")=PrtDate_"^"_PrtTime_"^"_CASHPayFlag_"^"_InvNo
		.Set ^TMP("DHCOPBILL","AbortINVNO",UserID,Job,PrtDate,PrtTime,CASHPayFlag,InvNo)=InvNo
	}
	//按照会计分类统计金额
	s CatTotalAmt=0
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..;TarItem_"^"_$j((CurCatFee/(qty*orderQty)),3,2)_"^"_(qty*orderQty)_"^"_$j(CurCatFee,3,2)
	..s Info=$G(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..s Amount=$P(Info,"^",4)
	..s CatTotalAmt=CatTotalAmt+Amount
	..s OneInfo=..GetTarAC(TARITEMID)
	..s ACSubID=$P(OneInfo,"^",2)
	..s ACID=$P(OneInfo,"^",1)
	..s ^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID)=+$G(^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID))+(FH*Amount)
	..s ^TempDHCPEUserReport(Job,"TarCate",ACID)=+$G(^TempDHCPEUserReport(Job,"TarCate",ACID))+(FH*Amount)
	..s ^TMP("OPBILL","CateFee",UserID,Job,ACSubID)=+$g(^TMP("OPBILL","CateFee",UserID,Job,ACSubID))+(FH*Amount)	;日报用
	b:CatTotalAmt'=InvAmt ;Inv
	q 0
}

/// Creator:Lid
/// CreatDate:2014-01-26
/// Desc:判断这张发票是否为现金支付
/// 		注：一张发票除医保支付方式外只有一种支付方式且支付方式是现金。
/// 			一张发票除医保支付方式外有多种支付方式时，即使其中有现金支付，也按“非现金”计算
ClassMethod CheckCASHFlag(Inv)
{
	New (Inv)
	
	Kill ^TMP("SingInv","PayMode",$j,Inv)
	//计算支付方式统计金额
	Set ARRCPID=$p(^DHCPEINVPRT(Inv),"^",4)
	Set ARRCPSub=0
	For  Set ARRCPSub=$o(^ARRCP(ARRCPID,"PAYM",ARRCPSub)) Quit:ARRCPSub=""  Do
	.Set PayModeID=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",1)
	.Set:PayModeID'="" paymCode=$p($g(^CT("CTPM",PayModeID)),"^",1)
	.Quit:paymCode["YB"
	.Set Amount=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",3)
	.set:PayModeID="21" PayModeID=13 ;注："TJDJK	体检卡支付" 做报表时体现到"TJYJJ	体检储值卡"
	.Set ^TMPCASHFlag("SingInv","PayMode",$j,Inv,PayModeID)=+$g(^TMP("SingInv","PayMode",$j,Inv,PayModeID))+(Amount)	;日报用
	;
	Set CASHPayFlag=0
	Set Paymdr="",PayMNum=0
	For  Set Paymdr=$o(^TMPCASHFlag("SingInv","PayMode",$j,Inv,Paymdr)) Quit:Paymdr=""  Do
	.Set tmpamt=+$g(^TMPCASHFlag("SingInv","PayMode",$j,Inv,Paymdr)) 
	.If (tmpamt'=0)&(Paymdr=1) Do
	..Set CASHPayFlag=1
	.If (tmpamt'=0) Set PayMNum=PayMNum+1
	;
	If PayMNum>1 Set CASHPayFlag=0	;有多种支付方式按“非现金”结算 
	
	Quit CASHPayFlag
}

/// Creator:Lid
/// CreatDate:2013-11-14
/// Desc:获取收费员日报数据
/// Debug:w ##class(web.DHCPE.DHCPEUSERREPORT).GetReportInfoForXH2("","","","")
ClassMethod GetReportInfoYJJForXH(FootID, UserID As %String = "", KillFlag As %String = "Y", Job As %String = "")
{
	New (FootID,UserID,KillFlag,Job)
	;
	If FootID'="" Do
	.Set UserID=$P(^DHCPEUSERREPORT(FootID),"^",1)
	.Set Date=$P(^DHCPEUSERREPORT(FootID),"^",2)
	.Set Time=$P(^DHCPEUSERREPORT(FootID),"^",3)
	.Set Date=$ZD(Date,3)
	.Set Time=$ZT(Time,3)
	.Set ReportDate=Date_" "_Time
	.;代金卡
	.s APID=0
	.f  s APID=$o(^DHCPEAP(0,"Report",FootID,APID)) q:APID=""  d
   	..s Sub=0
   	..f  s Sub=$o(^DHCPEAP(0,"Report",FootID,APID,Sub)) q:Sub=""  d
   	...d GetOneYJJInfoYJJ
	e  d
	.;代金卡
	.s APID=0
   	.f  s APID=$o(^DHCPEAP(0,"ReportFlag",UserID,"N",APID)) q:APID=""  d
   	..s Sub=0
   	..f  s Sub=$o(^DHCPEAP(0,"ReportFlag",UserID,"N",APID,Sub)) q:Sub=""  d
   	...d GetOneYJJInfoYJJ
   	q 0
GetOneYJJInfoYJJ
	Set Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   	Quit:(Type'="B")&&(Type'="R")&&(Type'="RF")
   	
   	Set Fee=+$P(^DHCPEAP(APID,"AC",Sub),"^",2)
   	Set pdamt=Fee
   	Set OldID=$P(^DHCPEAP(APID,"AC",Sub),"^",4)

   	Set mode=$P(^DHCPEAP(APID,"AC",Sub),"^",10)
   	;Set ^TempDHCPEUserReport(Job,"PayMode",mode)=+$G(^TempDHCPEUserReport(Job,"PayMode",mode))+Fee
   	;Set ^TempDHCPEUserReport(Job,"YJJPayMode",mode)=+$G(^TempDHCPEUserReport(Job,"YJJPayMode",mode))+Fee
  	If Type="RF" Do
  	.Set ^TMP("MZJF","TJDepT",UserID,Job)=+$g(^TMP("MZJF","TJDepT",UserID,Job))+Fee	;体检储值卡退费金额,注：是退预交金，不是消费
  	Else  Do
  	.Set ^TMP("MZJF","TJDepS",UserID,Job)=+$g(^TMP("MZJF","TJDepS",UserID,Job))+Fee	;体检储值卡充值金额
  	
	Set ^TMP("MZJF","DepPayMode",UserID,Job,mode)=+$g(^TMP("MZJF","DepPayMode",UserID,Job,mode))+Fee ;日报用
}

/// Creator:Lid
/// CreatDate:2013-11-14
/// Desc:获取收费员日报汇总数据
/// Debug:w ##class(web.DHCPE.DHCPEUSERREPORT).GetReportInfoHZForXH("","","","")
ClassMethod GetReportInfoHZForXH(FootID, Guser As %String = "", KillFlag As %String = "Y", Job As %String = "")
{
	New (FootID,Guser,KillFlag,Job)
	s ^wrz=FootID_"^"_Guser_"^"_KillFlag_"^"_Job
	;
	If FootID'="" Do
	.Set UserID=$P(^DHCPEUSERREPORT(FootID),"^",1)
	.Set Date=$P(^DHCPEUSERREPORT(FootID),"^",2)
	.Set Time=$P(^DHCPEUSERREPORT(FootID),"^",3)
	.Set Date=$ZD(Date,3)
	.Set Time=$ZT(Time,3)
	.Set ReportDate=Date_" "_Time
	.Set InvID=""
	.For  Set InvID=$O(^DHCPEINVPRT(0,"REPORT",FootID,InvID)) Quit:InvID=""  Do
	..Do GetOneInvInfoHZ(InvID)
	.b ;代金卡
	.s APID=0
	.f  s APID=$o(^DHCPEAP(0,"Report",FootID,APID)) q:APID=""  d
   	..s Sub=0
   	..f  s Sub=$o(^DHCPEAP(0,"Report",FootID,APID,Sub)) q:Sub=""  d
   	...;d GetOneYJJInfoHZ

   	b ;11
   	q 0
GetOneInvInfoHZ(InvID)
	Set FH=1
	Set RefInvID=$P(^DHCPEINVPRT(InvID),"^",9)
	If RefInvID'="" Do
	.Set FH=-1
	.Set Inv=RefInvID
	Else  Do
	.Set Inv=InvID
	Set InvNo=$P(^DHCPEINVPRT(Inv),"^",1)
	Set InvAmt=$P(^DHCPEINVPRT(Inv),"^",7)
	If FH=-1 Do
	.;Set RefundAmt=+$g(RefundAmt)+InvAmt
	
	s SSPFlag=##class(web.DHCPE.CashierEx).GetSSPFlag(Inv)
	
	//计算支付方式统计金额
	
	
	Set ARRCPID=$p(^DHCPEINVPRT(Inv),"^",4)
	Set ARRCPSub=0
	For  Set ARRCPSub=$o(^ARRCP(ARRCPID,"PAYM",ARRCPSub)) Quit:ARRCPSub=""  Do
	.Set PayModeID=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",1)
	.Set Amount=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",3)
	.set:PayModeID="21" PayModeID=13 ;注："TJDJK	体检卡支付" 做报表时体现到"TJYJJ	体检储值卡"
	.Set ^TMP("DailyReport","PayM",Guser,Job,PayModeID)=+$g(^TMP("DailyReport","PayM",Guser,Job,PayModeID))+(FH*Amount)	;日报汇总用
	.q:PayModeID="20" ;原手撕票ID
	.Set:SSPFlag=1 ^TMP("DailyReport","SSPPayM",Guser,Job,PayModeID)=+$g(^TMP("DailyReport","SSPPayM",Guser,Job,PayModeID))+(FH*Amount)	;日报汇总用

	//按照会计分类统计金额
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..;TarItem_"^"_$j((CurCatFee/(qty*orderQty)),3,2)_"^"_(qty*orderQty)_"^"_$j(CurCatFee,3,2)
	..s Info=$G(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..s Amount=$P(Info,"^",4)
	..s OneInfo=..GetTarAC(TARITEMID)
	..s ACSubID=$P(OneInfo,"^",2)
	..s ACID=$P(OneInfo,"^",1)
	..;s ^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID)=+$G(^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID))+(FH*Amount)
	..;s ^TempDHCPEUserReport(Job,"TarCate",ACID)=+$G(^TempDHCPEUserReport(Job,"TarCate",ACID))+(FH*Amount)
	..s ^TMP("DailyReport","ACCate",Guser,Job,ACSubID)=+$g(^TMP("DailyReport","ACCate",Guser,Job,ACSubID))+(FH*Amount) ;日报汇总用
	
	q 0
GetOneYJJInfoHZ
	Set Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   	Quit:(Type'="B")&&(Type'="R")&&(Type'="RF")
   	
   	Set Fee=+$P(^DHCPEAP(APID,"AC",Sub),"^",2)
   	Set pdamt=Fee
   	Set OldID=$P(^DHCPEAP(APID,"AC",Sub),"^",4)

   	Set mode=$P(^DHCPEAP(APID,"AC",Sub),"^",10)
  	If Type="RF" Do
  	.Set ^TMP("DepDailyReportHZ","TJDepT",Guser,Job)=+$g(^TMP("DepDailyReportHZ","TJDepT",Guser,Job))+Fee	;体检储值卡退费金额,注：是退预交金，不是消费
  	Else  Do
  	.Set ^TMP("DepDailyReportHZ","TJDepS",Guser,Job)=+$g(^TMP("DepDailyReportHZ","TJDepS",Guser,Job))+Fee	;体检储值卡充值金额
  	.Set ^Lid("DepDailyReportHZ","dddddTJDepS",APID_"||"_Sub)=+$g(^Lid("DepDailyReportHZ","dddddTJDepS",APID_"||"_Sub))+Fee
	Set ^TMP("DepDailyReportHZ","PayM",Guser,Job,mode)=+$g(^TMP("DepDailyReportHZ","PayM",Guser,Job,mode))+Fee ;日报汇总用
}

ClassMethod GetReportInfoForXH(FootID, UserID As %String = "", KillFlag As %String = "Y", Job As %String = "")
{
	;d ##class(web.DHCPE.DHCPEUSERREPORT).GetReportInfoForXH(35,"")
	s ^wrz=FootID_"^"_KillFlag_"^"_Job
	s:Job="" Job=$J
	k:KillFlag="Y" ^TempDHCPEUserReport //(Job)
	s PrintDate=$ZD($H,3)
	s ReportDate=""
	s RefundAmt=0
	s YJJAmount=0
	s SYJJAmount=0
	s TYJJAmount=0
	i FootID'="" d
	.s UserID=$P(^DHCPEUSERREPORT(FootID),"^",1)
	.s Date=$P(^DHCPEUSERREPORT(FootID),"^",2)
	.s Time=$P(^DHCPEUSERREPORT(FootID),"^",3)
	.s Date=$ZD(Date,3)
	.s Time=$ZT(Time,3)
	.s ReportDate=Date_" "_Time
	.s InvID=""
	.f  s InvID=$O(^DHCPEINVPRT(0,"REPORT",FootID,InvID)) q:InvID=""  d
	..d GetOneInvInfo(InvID)
	.;代金卡
	.s APID=0
	.f  s APID=$o(^DHCPEAP(0,"Report",FootID,APID)) q:APID=""  d
   	..s Sub=0
   	..f  s Sub=$o(^DHCPEAP(0,"Report",FootID,APID,Sub)) q:Sub=""  d
   	...d GetOneYJJInfo
	e  d
	.s InvID=""
	.f  s InvID=$O(^DHCPEINVPRT(0,"RPFLAG",UserID,"N",InvID)) q:InvID=""  d
	..d GetOneInvInfo(InvID)
	.;代金卡
	.s APID=0
   	.f  s APID=$o(^DHCPEAP(0,"ReportFlag",UserID,"N",APID)) q:APID=""  d
   	..s Sub=0
   	..f  s Sub=$o(^DHCPEAP(0,"ReportFlag",UserID,"N",APID,Sub)) q:Sub=""  d
   	...d GetOneYJJInfo
	
	s UserCode=$P(^SSU("SSUSR",UserID),"^",1)
	s UserName=$P(^SSU("SSUSR",UserID),"^",2)
	s User=UserName_"("_UserCode_")"
	s BaseInfo=User_"^"_ReportDate_"^"_PrintDate
	s RefInvNo=""
	s RefInvNum=""
	s InvNo=""
	f  s InvNo=$O(^TempDHCPEUserReport(Job,"RefInvNoStr",InvNo)) q:InvNo=""  d
	.s RefInvNum=+RefInvNum+1
	.i RefInvNo="" d
	..s RefInvNo=InvNo
	.e  d
	..s RefInvNo=RefInvNo_","_InvNo
	b ;RefInvNo
	s NorInvNum=""
	s NorInvNo=""
	s PreInvNo=""
	s InvNo=""
	f  s InvNo=$O(^TempDHCPEUserReport(Job,"InvNoStr",InvNo)) q:InvNo=""  d
	.s NorInvNum=+NorInvNum+1
	.i NorInvNo="" d
	..s NorInvNo=InvNo
	.e  d
	..i InvNo-PreInvNo=1 d
	...
	..e  d
	...s NorInvNo=NorInvNo_"-"_PreInvNo_","_InvNo
	.s PreInvNo=InvNo
	s NorInvNo=NorInvNo_"-"_PreInvNo
	b ;NorInvNo
	s BaseInfo=BaseInfo_"^"_NorInvNum_"^"_NorInvNo_"^"_RefInvNum_"^"_RefInvNo
	b ;BaseInfo
	s PayModeInfo=""
	s TotalAmt=0
	s PayModeID=""
	f  s PayModeID=$O(^TempDHCPEUserReport(Job,"PayMode",PayModeID)) q:PayModeID=""  d
	.s Amt=$G(^TempDHCPEUserReport(Job,"PayMode",PayModeID))
	.i PayModeInfo=""  d
	..s PayModeInfo=PayModeID_"^"_Amt
	.e  d
	..s PayModeInfo=PayModeInfo_$C(1)_PayModeID_"^"_Amt
	.s TotalAmt=TotalAmt+Amt
	b ;PayModeInfo
	s BaseInfo=BaseInfo_"^"_RefundAmt_"^"_SYJJAmount_"^"_TYJJAmount_"^"_YJJAmount
	s TarCateInfo=""
	s ACID=""
	f  s ACID=$O(^TempDHCPEUserReport(Job,"TarCate",ACID)) q:ACID=""  d
	.;,"Detail",ACSubID)
	.s Amt=$G(^TempDHCPEUserReport(Job,"TarCate",ACID))
	.i TarCateInfo=""  d
	..s TarCateInfo=ACID_"^"_Amt
	.e  d
	..s TarCateInfo=TarCateInfo_$C(1)_ACID_"^"_Amt
	.s ACSubID=""
	.f  s ACSubID=$O(^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID)) q:ACSubID=""  d
	..s Amt=$G(^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID))
	..s TarCateInfo=TarCateInfo_$C(1)_ACSubID_"^"_Amt
	b ;TarCateInfo
	;k ^TempDHCPEUserReport(Job)
	q Job_"^"_BaseInfo
GetOneInvInfo(InvID)
	s FH=1
	s RefInvID=$P(^DHCPEINVPRT(InvID),"^",9)
	i RefInvID'="" d
	.s FH=-1
	.;s InvNo=$P(^DHCPEINVPRT(RefInvID),"^",1)
	.s Inv=RefInvID
	e  d
	.s Inv=InvID
	s InvNo=$P(^DHCPEINVPRT(Inv),"^",1)
	s InvAmt=$P(^DHCPEINVPRT(Inv),"^",7)
	i FH=-1 d
	.s RefundAmt=RefundAmt+InvAmt
	s SSPFlag=##class(web.DHCPE.CashierEx).GetSSPFlag(Inv)
	
	//计算支付方式统计金额
	s ARRCPID=$p(^DHCPEINVPRT(Inv),"^",4)
	s ARRCPSub=0
	f  s ARRCPSub=$o(^ARRCP(ARRCPID,"PAYM",ARRCPSub)) q:ARRCPSub=""  d
	.s PayModeID=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",1)
	.s Amount=$p(^ARRCP(ARRCPID,"PAYM",ARRCPSub),"^",3)
	.s ^TempDHCPEUserReport(Job,"PayMode",PayModeID)=+$G(^TempDHCPEUserReport(Job,"PayMode",PayModeID))+(FH*Amount)
	.q:PayModeID="20" ;原手撕票ID
	.s:SSPFlag=1 ^TempDHCPEUserReport(Job,"SSPPayMode",PayModeID)=+$G(^TempDHCPEUserReport(Job,"SSPPayMode",PayModeID))+(FH*Amount)
	
	i InvNo'[("DHC")
	{
		i FH=1 d
		.s ^TempDHCPEUserReport(Job,"InvNoStr",InvNo)=""
		e  d
		.s ^TempDHCPEUserReport(Job,"RefInvNoStr",InvNo)=""
		.s ^TempDHCPEUserReport(Job,"RefAmt")=+$G(^TempDHCPEUserReport(Job,"RefAmt"))+InvAmt
	}
	//按照会计分类统计金额
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..;TarItem_"^"_$j((CurCatFee/(qty*orderQty)),3,2)_"^"_(qty*orderQty)_"^"_$j(CurCatFee,3,2)
	..s Info=$G(^DHCPEOEITEM(Inv,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TARITEMID=$P(Info,"^",1)
	..s Amount=$P(Info,"^",4)
	..s OneInfo=..GetTarAC(TARITEMID)
	..s ACSubID=$P(OneInfo,"^",2)
	..s ACID=$P(OneInfo,"^",1)
	..s ^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID)=+$G(^TempDHCPEUserReport(Job,"TarCate",ACID,"Detail",ACSubID))+(FH*Amount)
	..s ^TempDHCPEUserReport(Job,"TarCate",ACID)=+$G(^TempDHCPEUserReport(Job,"TarCate",ACID))+(FH*Amount)
	
	q
GetOneYJJInfo
	s Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
   	q:(Type'="B")&&(Type'="R")&&(Type'="RF")
   	
   	s Fee=$P(^DHCPEAP(APID,"AC",Sub),"^",2)
   	s pdamt=Fee
   	s OldID=$P(^DHCPEAP(APID,"AC",Sub),"^",4)
   	i Type'="RF" d
   	.s InvNo=$P(^DHCPEAP(APID,"AC",Sub),"^",4)
   	.s SYJJAmount=SYJJAmount+Fee
   	.q:(InvNo="")
   	.s ^TempDHCPEUserReport(Job,"InvNoStr",InvNo)=""
   	i Type="RF" d
   	.s InvNo=$P(^DHCPEAP(+OldID,"AC",$P(OldID,"||",2)),"^",4)
   	.s TYJJAmount=TYJJAmount-Fee
   	.s RefundAmt=RefundAmt-Fee
   	.Q:InvNo=""
   	.s ^TempDHCPEUserReport(Job,"RefInvNoStr",InvNo)=""
	.s ^TempDHCPEUserReport(Job,"RefAmt")=+$G(^TempDHCPEUserReport(Job,"RefAmt"))-Fee
   	s YJJAmount=YJJAmount+Fee
   	s mode=$P(^DHCPEAP(APID,"AC",Sub),"^",10)
   	s ^TempDHCPEUserReport(Job,"PayMode",mode)=+$G(^TempDHCPEUserReport(Job,"PayMode",mode))+Fee
   	s ^TempDHCPEUserReport(Job,"YJJPayMode",mode)=+$G(^TempDHCPEUserReport(Job,"YJJPayMode",mode))+Fee
}

ClassMethod GetInfo(Job, Info)
{
	i $p(Info,"^",2)="" q "0^"
	if $P(Info,"^",1)="P"
	{
		
		q "1^"_$G(^TempDHCPEUserReport(Job,"PayMode",$P(Info,"^",2)))
	}
	i $P(Info,"^",1)="A"
	{
		q "1^"_$G(^TempDHCPEUserReport(Job,"TarCate",$P(Info,"^",2),"Detail",$P(Info,"^",3)))
	}
	i $P(Info,"^",1)="AP"
	{
		q "1^"_$G(^TempDHCPEUserReport(Job,"YJJPayMode",$P(Info,"^",2)))
	}
	q "0^"
}

ClassMethod GetTarAC(TarItemID)
{
	s ACSubID=$P(^DHCTARI(TarItemID),"^",5)
	s ACID=$P(^DHCTarC("AC",ACSubID),"^",3)
	q ACID_"^"_ACSubID
}

ClassMethod GetHospitalName()
{
	s HospName=""
	s HospName=$g(^DHCPESetting("DHCPE","HospitalName"))
	q HospName
}

}
