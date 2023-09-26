Import SQLUser

Class web.UDHCJFReceipt Extends BILL.COM.Abstract
{

/// 购入票据列表查询
/// do ##class(%ResultSet).RunQuery("web.UDHCJFReceipt","FindBuyRcpt","I","","","","2")
Query FindBuyRcpt(type As %String, stDate As %String, endDate As %String, buyerId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TBuyId:%String:ID,TBuyDate:%String:购入日期,TBuyTime:%String:购入时间,TStartno:%String:开始号码,TEndno:%String:结束号码,TCurrentno:%String:当前号码,TUseFlag:%String,TUseFlagDisplay:%String:可用标记,TBuyer:%String:购入人,TTitle:%String:开始字母,Tcomment1:%String,Tcomment2:%String") [ SqlProc ]
{
}

ClassMethod FindBuyRcptExecute(ByRef qHandle As %Binary, type As %String, stDate As %String, endDate As %String, buyerId As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("BuyRcpt")=$lb(type, stDate, endDate, buyerId, hospId, langId)
	if (type="") quit $$$OK

 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
 	set rowid=0
 	while($o(^DHCSFBUY(rowid))) {
	 	set rowid=$o(^DHCSFBUY(rowid))
	 	set data=$g(^DHCSFBUY(rowid))
		continue:(data="")
		set hospDR=$p(data,"^",16)
		continue:(hospDR'=hospId)
		set loc=$p(data,"^",7)
		continue:(type'=loc)
		set userDR=$p(data,"^",10)
		continue:((buyerId'="")&&(userDR'=buyerId))
		set buyer=$s((userDR'=""):$p(^SSU("SSUSR",userDR),"^",2),1:"")
		set buyer=##class(User.SSUser).GetTranByDesc("SSUSRName", buyer, langId)
		set buyDate=$p(data,"^",1)
		continue:((stDate'="")&&(buyDate<stDate))
		continue:((endDate'="")&&(buyDate>endDate))
		set buyTime=$p(data,"^",2)
		set buyDate=##class(websys.Conversions).DateLogicalToHtml(buyDate)
		set buyTime=##class(websys.Conversions).TimeLogicalToHtml(buyTime)
		set startno=$p(data,"^",3)
		set endno=$p(data,"^",4)
		set currentno=$p(data,"^",8)
		set useFlag=$p(data,"^",9)
		set useFlagDisplay=$case(useFlag,1:"可用",2:"已用完",:"待用")
		set useFlagDisplay=##class(websys.Translation).Get("", useFlagDisplay, langId)
		set title=$p(data,"^",11)
		set comment1=$p(data,"^",14)
		set comment2=$p(data,"^",15)
		do OutputRcptList
	}

	quit $$$OK
OutputRcptList
	set Data=$lb(rowid,buyDate,buyTime,startno,endno,currentno,useFlag,useFlagDisplay,buyer,title,comment1,comment2)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFReceipt","FindGrantRcpt","","2020-04-01","2020-06-26","","I","2")
Query FindGrantRcpt(lquserId As %String, stDate As %String, endDate As %String, grantFlag As %String, type As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TgrantId:%String:ID,Tlqdate:%String:发放日期,Tlqtime:%String:发放时间,Tstartno:%String:开始号码,Tendno:%String:结束号码,Tcurrentno:%String:当前号码,Tuseflag:%String,TuseflagDisplay:%String:票据状态,Tlquser:%String:领取人,Ttitle:%String:开始字母,TLeftNum:%Integer:剩余张数") [ SqlProc ]
{
}

ClassMethod FindGrantRcptExecute(ByRef qHandle As %Binary, lquserId As %String, stDate As %String, endDate As %String, grantFlag As %String, type As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindGrantRcpt")=$lb(lquserId, stDate, endDate, grantFlag, type, hospId, langId)
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
    set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

 	set rowid=0
 	while($o(^DHCSFRECEIPT(rowid))) {
	 	set rowid=$o(^DHCSFRECEIPT(rowid))
	 	set data=$g(^DHCSFRECEIPT(rowid))
		continue:(data="")
		set hospDR=$p(data,"^",22)
		continue:(hospDR'=hospId)
		set loc=$p(data,"^",15)
		continue:(loc'=type)
		set lqdate=$p(data,"^",1)
		set lqtime=$p(data,"^",2)
		continue:((stDate'="")&&(lqdate<stDate))
		continue:((endDate'="")&&(lqdate>endDate))
		set lqdate=##class(websys.Conversions).DateLogicalToHtml(lqdate)
		set lqtime=##class(websys.Conversions).TimeLogicalToHtml(lqtime)
		set lqUserDR=$p(data,"^",8)
		continue:((lquserId'="")&&(lqUserDR'=lquserId))
		set lquser=$s((lqUserDR'=""):$p(^SSU("SSUSR",lqUserDR),"^",2),1:"")
		set lquser=##class(User.SSUser).GetTranByDesc("SSUSRName", lquser, langId)
		set stno=$p(data,"^",3)
		set endno=$p(data,"^",4)
		set curno=$p(data,"^",5)
		set initDR=$p(data,"^",14)
		set useflag=$p(data,"^",7)
		if (initDR'="") set useflag=4
		set leftNum=$s((useflag=2):0,1:endno-curno+1)  //剩余张数
		continue:((grantFlag'="All")&&(useflag'=grantFlag))
		set useflagDisplay=$case(useflag,1:"可用",2:"已用完",4:"转交",:"待用")
		set useflagDisplay=##class(websys.Translation).Get("", useflagDisplay, langId)
		set title=$p(data,"^",9)
		do OutputGrantRcpt
	}

	quit $$$OK
OutputGrantRcpt
	set Data=$lb(rowid,lqdate,lqtime,stno,endno,curno,useflag,useflagDisplay,lquser,title,leftNum)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 押金收据购入
/// Debug: w ##class(web.UDHCJFReceipt).InsertBuy("009010601","009010700","5","DHC","I","2")
ClassMethod InsertBuy(startNo As %String, endNo As %String, buyerId As %String, title As %String, type As %String, hospId As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("InsertBuy")=$lb(startNo, endNo, buyerId, title, type, hospId)
	set rtnValue=##class(web.UDHCINVManager).CheckReceiptBuyInfo(title, type, startNo, endNo)
	set rtn=$p(rtnValue,"^",1)
	set findFlag=$p(rtnValue,"^",2)
	quit:(+rtn) rtn
	quit:(+findFlag=1) -505_"^"_"不能重复购入押金收据"
	
	set cw=..finaccw(type, hospId)
	set useflag=$s((cw>0):"",1:1)
	
	ts
	
	&SQL(
		INSERT INTO dhc_sfbuy (
			buy_startno, buy_endno, buy_currentno, buy_gruser, buy_useflag,
			buy_title, buy_loc, buy_hospital
		)
		VALUES (
			:startNo, :endNo, :startNo, :buyerId, :useflag,
			:title, :type, :hospId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	
    quit rtn
    
ERROR
	quit ..AppException()
}

ClassMethod finaccw(type As %String, hospId As %String) As %Integer
{
	&SQL(
		SELECT count(*) INTO :count
		FROM dhc_sfbuy
		WHERE buy_useflag = '1' AND buy_loc = :type AND buy_hospital = :hospId
	)
	quit count
}

/// 购入票据删除
/// Debug: w ##class(web.UDHCJFReceipt).DeleteBuy(2)
ClassMethod DeleteBuy(rowId As %String)
{
	quit:(+rowId=0) -1_"^"_"参数错误"
	set buyData=$g(^DHCSFBUY(rowId))
	set startNo=$p(buyData,"^",3)
	set curNo=$p(buyData,"^",8)
	quit:(startNo'=curNo) -2_"^"_"此号段已使用，不能删除"   //开始号跟当前号不一致，表示此号段已使用，不能删除
	&SQL(DELETE FROM dhc_sfbuy WHERE %ID = :rowId)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// w ##class(web.UDHCJFReceipt).GetStNo("I", 2)
ClassMethod GetStNo(type As %String, hospId As %String) As %String
{
	set endno=""
	&SQL(
		SELECT max(%ID) INTO :maxrow
		FROM dhc_sfbuy
		WHERE buy_loc = :type AND buy_hospital = :hospId
	)
	&SQL(
		SELECT nvl(buy_endno, '') INTO :endno
		FROM dhc_sfbuy
		WHERE %ID = :maxrow
	)	
	if (endno'="") {
		set endno=##class(web.UDHCJFBaseCommon).incre(endno)   //从下一个号码开始购入
	}
    quit endno
}

/// 取购入的可用押金收据信息
/// Debug: w ##class(web.UDHCJFReceipt).GetGrantStNo("I", 2)
ClassMethod GetGrantStNo(type As %String, hospId As %String) As %String
{
	set buyId="", curno="", endno="", title=""
	
	set rowid=0
	while($o(^DHCSFBUY(rowid))) {
		set rowid=$o(^DHCSFBUY(rowid))
		set data=$g(^DHCSFBUY(rowid))
		continue:(data="")
		set useflag=$p(data,"^",9)   //buy_useflag
		continue:(useflag'=1)
		set loc=$p(data,"^",7)
		continue:(type'=loc)
		set hospDR=$p(data,"^",16)
		continue:(hospDR'=hospId)
		set curno=$p(data,"^",8)
		set endno=$p(data,"^",4)
		set title=$p(data,"^",11)
		set buyId=rowid
		quit
	}
	set leftNum=+endno-curno+1
	set str=curno_"^"_endno_"^"_title_"^"_buyId_"^"_leftNum
	
    quit str
}

/// 押金收据发放
ClassMethod InsertGrant(str As %String, buyRowId As %String, hospId As %String) As %String
{
	set $zt="ERROR"
	
	set stno=$p(str,"^",1)
	set endno=$p(str,"^",2)
	set kyendno=$p(str,"^",3)
	set userid=$p(str,"^",4)
	set lquserId=$p(str,"^",5)
	set title=$p(str,"^",6)
	set type=$p(str,"^",7)
	
	/*
	set InvInfo=##class(web.UDHCJFReceipt).GetGrantStNoInfo(type, hospId)
	set InvStNo=$p(InvInfo,"^",1)
	quit:($l(InvStNo)'=$l(stno))||((+stno)'=(+InvStNo)) -100
	*/
	
	quit:(+buyRowId=0) -506_"^"_"发放号段不存在"
	
	set mySFBuyData=$g(^DHCSFBUY(buyRowId))
	quit:(mySFBuyData="") -506_"^"_"发放号段不存在"
	
	set myCurrentNO=$p(mySFBuyData,"^",8)  //buy_currentno
	quit:(stno'=myCurrentNO) -507_"^"_"开始号码错误"
	
	set myEndNO=$p(mySFBuyData,"^",4)   //buy_endno
	quit:(kyendno'=myEndNO) -508_"^"_"结束号码错误"
	
	set cw=..rcptcw(lquserId, type, hospId)   //判断收费员是否有未使用完的记录
	set useflag=$s((cw>0):"",1:"1")
	
	ts
	
	&SQL(
		INSERT INTO dhc_sfreceipt (
			rcpt_startno, rcpt_endno, rcpt_currentno, rcpt_user, rcpt_lquser,
			rcpt_useflag, rcpt_title, rcpt_loc, rcpt_hospital
		)
		VALUES (
			:stno, :endno, :stno, :userid, :lquserId,
			:useflag, :title, :type, :hospId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
    if (endno'=kyendno) {
	    set rtn=..rcptupdate(endno, buyRowId)
	}else {
		set rtn=..rcptrefund(type, hospId, buyRowId)
	}
	if (+rtn) tro  quit rtn
	if ($tl>0) tc

    quit rtn
    
ERROR
	quit ..AppException()
}

ClassMethod rcptcw(userId As %String, type As %String, hospId As %String) As %Integer
{
	&SQL(
		SELECT count(*) INTO :count
		FROM dhc_sfreceipt
		WHERE rcpt_useflag = '1' AND rcpt_lquser = :userId AND rcpt_loc = :type AND rcpt_hospital = :hospId
	)
	quit count
}

ClassMethod rcptrefund(type As %String, hospId As %String, buyRowId As %String) As %String
{
	set rtn=0
	
	&SQL(
		UPDATE dhc_sfbuy
		SET buy_useflag = '2', buy_currentno = buy_endno
		WHERE %ID = :buyRowId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
 	&SQL(
 		SELECT count(*) INTO :num
 		FROM dhc_sfbuy
 		WHERE (buy_useflag = '3' OR buy_useflag IS NULL) AND %ID <> '0' AND buy_loc = :type AND buy_hospital = :hospId
 	)
 	if (num'=0) {
		&SQL(
			SELECT min(%ID) INTO :rowid1
			FROM dhc_sfbuy
			WHERE (buy_useflag = '3' OR buy_useflag IS NULL) AND %ID<>'0' AND buy_loc = :type AND buy_hospital = :hospId
		)
		&SQL(
			UPDATE dhc_sfbuy
			SET buy_useflag = '1'
			WHERE %ID = :rowid1
		)
	}
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
    quit rtn
}

/// 修改领取收据的结束编号,将当前编号改为结束编号
ClassMethod rcptupdate(endno As %String, buyRowId As %String) As %String
{
	set endno=##class(web.UDHCJFBaseCommon).incre(endno)
	&SQL(
		UPDATE dhc_sfbuy
		SET buy_currentno = :endno
		WHERE %ID = :buyRowId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

/// Description: 删除收据发放记录
/// Return: =0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFReceipt).DeleteGrant("I", 2)
ClassMethod DeleteGrant(grantId As %String, hospId As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	&SQL(
		SELECT rcpt_loc, rcpt_startno, rcpt_currentno INTO :type, :stNo, :curNo
		FROM dhc_sfreceipt
		WHERE %ID = :grantId
	)
	quit:(stNo'=curNo) -1_"^"_"该记录已使用，不能删除"
	
	&SQL(
		SELECT TOP 1 %ID INTO :maxId
		FROM dhc_sfreceipt
		WHERE rcpt_loc = :type AND rcpt_hospital = :hospId ORDER BY %ID DESC
	)
	quit:(maxId'=grantId) -1_"^"_"该记录不是最后一条记录，不能删除"
	
	ts
	
	&SQL(DELETE FROM dhc_sfreceipt WHERE %ID = :grantId)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	&SQL(
		SELECT %ID INTO :buyrowid
		FROM dhc_sfbuy
		WHERE (buy_startno <= :stNo) AND (buy_endno >= :stNo) AND buy_hospital = :hospId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	&SQL(
		SELECT buy_useflag INTO :useflag
		FROM dhc_sfbuy
		WHERE %ID = :buyrowid
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if (useflag=1) {
		&SQL(
			UPDATE dhc_sfbuy
			SET buy_currentno = :stNo
			WHERE %ID = :buyrowid
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	if (useflag=2) {
		&SQL(
			UPDATE dhc_sfbuy
			SET buy_currentno = :stNo, buy_useflag = '1'
			WHERE %ID = :buyrowid
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFReceipt","FindDeliver","I","5","10207","2")
Query FindDeliver(type As %String, zjuserid As %String, Bezjuserid As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "Trowid:%String:ID,Tdate:%String:领取日期,Ttime:%String:领取时间,Tstartno:%String:开始号码,Tendno:%String:结束号码,Tcurrentno:%String:当前号码,TuseFlag:%String,TuseFlagDisplay:%String:收据状态,Ttitle:%String:开始字母,Ttransuser:%String:转交人,Tlqusername:%String:接收人")
{
}

ClassMethod FindDeliverExecute(ByRef qHandle As %Binary, type As %String, zjuserid As %String, Bezjuserid As %String, hospId As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindDeliver")=$lb(type, zjuserid, Bezjuserid, hospId, langId)
 	if (type="") quit $$$OK
 	
 	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set rowid=0
    while($o(^DHCSFRECEIPT(rowid))) {
	    set rowid=$o(^DHCSFRECEIPT(rowid))
		set data=$g(^DHCSFRECEIPT(rowid))
		continue:(data="")
		set hospDR=$p(data,"^",22)
		continue:(hospDR'=hospId)
		set loc=$p(data,"^",15)
		continue:(type'=loc)
		set lquser=$p(data,"^",8)
		continue:((zjuserid'=lquser)&&(zjuserid'=""))
		set lqusername=$s((lquser'=""):$p(^SSU("SSUSR",lquser),"^",2),1:"")
		set lqusername=##class(User.SSUser).GetTranByDesc("SSUSRName", lqusername, langId)
		set bdate=$p(data,"^",1)
		set bdate=##class(websys.Conversions).DateLogicalToHtml(bdate)
		set btime=$p(data,"^",2)
		set btime=##class(websys.Conversions).TimeLogicalToHtml(btime)
		set bstartno=$p(data,"^",3)
		set bendno=$p(data,"^",4)
		set bcurrent=$p(data,"^",5)
		set useFlag=$p(data,"^",7)
		set useFlagDisplay=$case(useFlag,1:"可用",2:"已发完",:"待用")
		set useFlagDisplay=##class(websys.Translation).Get("", useFlagDisplay, langId)
		set transuserid=$p(data,"^",6) 
		continue:((Bezjuserid'=transuserid)&&(Bezjuserid'=""))
		set transuser=$p(^SSU("SSUSR",transuserid),"^",2)
		set transuser=##class(User.SSUser).GetTranByDesc("SSUSRName", transuser, langId)
		set title=$p(data,"^",9)
	 	do OutputDeliverList
	}
	quit $$$OK
OutputDeliverList
   	set Data=$lb(rowid,bdate,btime,bstartno,bendno,bcurrent,useFlag,useFlagDisplay,title,transuser,lqusername)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod Getkydeliver(userId As %String, type As %String, hospId As %String) As %String
{
	set receiptId="", curno="", endno="", title=""
	set rowid=0
	while($o(^DHCSFRECEIPT(0,"lquser",userId,rowid))) {
		set rowid=$o(^DHCSFRECEIPT(0,"lquser",userId,rowid))
		set data=$g(^DHCSFRECEIPT(rowid))
		continue:(data="")
		set hospDR=$p(data,"^",22)
		continue:(hospDR'=hospId)
		set useflag=$p(data,"^",7)
		continue:(useflag'=1)
		set loc=$p(data,"^",15)
		continue:(loc'=type)
		set curno=$p(data,"^",5)
		set endno=$p(data,"^",4)
		set title=$p(data,"^",9)
		set receiptId=rowid
		quit
	}
	set leftNum=$s((+receiptId'=0):(endno-curno+1),1:0)   //余票数
	set str=curno_"^"_endno_"^"_receiptId_"^"_title_"^"_leftNum
    quit str
}

/// 押金收据转交
/// w ##class(web.UDHCJFReceipt).deliverrcpt("0000591^0000600^0000591^10207^^5^^0000700^2^I^5","2")
ClassMethod deliverrcpt(str As %String, hospId As %String)
{
	set $zt="ERROR"
	
	set ^TMP("deliverrcpt")=$lb(str, hospId)
	set lqstno=$p(str,"^",1)
	set lqenno=$p(str,"^",2)
	set lqcurno=$p(str,"^",3)
	set userno=$p(str,"^",4)
	//set lquflag=$p(str,"^",5)
	set lquser=$p(str,"^",6)
	set title=$p(str,"^",7)
	set buyend=$p(str,"^",8)
	set receipt=$p(str,"^",9)
	set loc=$p(str,"^",10)
	set Quetflag=..CheckUsrNoAvail(lqstno, lqenno, userno, loc)
	quit:(+Quetflag'=1) -100
	
	set cw=..rcptsky(lquser, loc)
	set lquflag=$s((cw>0):"",1:1)
	
	ts
	
	&SQL(
		INSERT INTO dhc_sfreceipt (
			rcpt_startno, rcpt_endno, rcpt_currentno, rcpt_user, rcpt_useflag,
			rcpt_lquser, rcpt_title, rcpt_original_dr, rcpt_loc, rcpt_hospital
		)
		VALUES (
			:lqstno, :lqenno, :lqstno, :userno, :lquflag,
			:lquser, :title, :receipt, :loc, :hospId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if (lqenno'=buyend) {
		set rtn=..deliverrcptupdate(lqenno, receipt)
	}else {
		set rtn=..deliverrcptrefund(userno, receipt, loc)
	}
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	
 	quit rtn
 	
ERROR
	quit ..AppException()
}

ClassMethod CheckUsrNoAvail(stno As %String, endno As %String, user As %String, type As %String) As %String
{
    quit:(stno="")||(endno="")||($l(stno)'=$l(endno)) -1

    set CheckFlag=0
    set rcptrowid=""
    while($o(^DHCSFRECEIPT(0,"lquser",user,rcptrowid),-1)) {
	    set rcptrowid=$o(^DHCSFRECEIPT(0,"lquser",user,rcptrowid),-1)
	 	set rcptData=$g(^DHCSFRECEIPT(rcptrowid))
	    set useflag=$p(rcptData,"^",7)
	    continue:(useflag'=1)
	    set loc=$p(rcptData,"^",15)
	    continue:(loc'=type)
	    set CurStNo=$p(rcptData,"^",5)
	    set CurEndNo=$p(rcptData,"^",4)
	    if ($l(+stno)=$l(+CurStNo))&&(+stno=(+CurStNo))&&(+CurEndNo'<(+endno))  set CheckFlag=1
	}
    quit CheckFlag
}

ClassMethod deliverrcptupdate(endno As %String, recid As %Integer) As %String
{
	set endno=##class(web.UDHCJFBaseCommon).incre(endno)
	&SQL(
		UPDATE dhc_sfreceipt
		SET rcpt_currentno = :endno
		WHERE %ID = :recid
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn
}

ClassMethod deliverrcptrefund(userid As %String, recid As %Integer, type As %String) As %String
{
	set rtn=0
    &SQL(
    	UPDATE dhc_sfreceipt
    	SET rcpt_useflag = '2'
    	WHERE %ID = :recid
    )
    set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	&SQL(
		SELECT count(*) INTO :num
		FROM dhc_sfreceipt
		WHERE (rcpt_useflag = '' OR rcpt_useflag IS NULL) AND rcpt_lquser = :userid AND rcpt_loc = :type
	)
	if (num'=0) {
		&SQL(
			SELECT min(%ID) INTO :rowid1
			FROM dhc_sfreceipt
			WHERE (rcpt_useflag = '' OR rcpt_useflag IS NULL) AND rcpt_lquser = :userid AND rcpt_loc = :type
		)
		&SQL(
			UPDATE dhc_sfreceipt
			SET rcpt_useflag = '1'
			WHERE %ID = :rowid1
		)
	}
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn
}

ClassMethod rcptsky(userId As %String, type As %String) As %Integer
{
	set count=0
	set rcptrowid=0
	for  set rcptrowid=$o(^DHCSFRECEIPT(0,"lquser",userId,rcptrowid)) quit:((rcptrowid="")||(count'=0))  do
	.set rcptData=$g(^DHCSFRECEIPT(rcptrowid))
	.set useflag=$p(rcptData,"^",7)
	.quit:(useflag'=1)
	.set loc=$p(rcptData,"^",15)
	.quit:(type'=loc)
	.set count=$i(count)
	
	quit count
}

Query FindCWGrantRcpt(lquserid As %String, langId As %String = "") As websys.Query(ROWSPEC = "Tlqdate:%String,Tlqtime:%String,Tstno:%String,Tendno:%String,Tcurno:%String,Tuseflag:%String,Tlquser:%String,Ttitle:%String,Tgrantrowid:%String")
{
}

ClassMethod FindCWGrantRcptExecute(ByRef qHandle As %Binary, lquserid As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

 	set rowid=0
 	while($o(^DHCSFGRANT(rowid))) {
	 	set rowid=$o(^DHCSFGRANT(rowid))
		set data=$g(^DHCSFGRANT(rowid))
		continue:(data="")
		set lqdate=$p(data,"^",1)
		set lqtime=$p(data,"^",2)
		set lqdate=##class(websys.Conversions).DateLogicalToHtml(lqdate)
		set lqtime=##class(websys.Conversions).TimeLogicalToHtml(lqtime)
		set stno=$p(data,"^",3)
		set endno=$p(data,"^",4)
		set curno=$p(data,"^",7)
		set useflag=$p(data,"^",8)
		set useflagDisplay=$case(useflag,1:"可用",2:"已发完",:"待用")
		set useflagDisplay=##class(websys.Translation).Get("", useflagDisplay, langId)
		set lquser=$p(data,"^",9)
		continue:((lquserid'="")&&(lquser'=lquserid))
		set lqusername=$s((lquser'=""):$p($g(^SSU("SSUSR",lquser)),"^",2),1:"")
		set lqusername=##class(User.SSUser).GetTranByDesc("SSUSRName", lqusername, langId)
		set title=$p(data,"^",10)
		do OutputCWGrantRcpt
	}
	quit $$$OK
OutputCWGrantRcpt
	set Data=$lb(lqdate,lqtime,stno,endno,curno,useflagDisplay,lqusername,title,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindZYGrantRcpt(userid As %String, langId As %String = "") As websys.Query(ROWSPEC = "Tlqdate:%String,Tlqtime:%String,Tstno:%String,Tendno:%String,Tcurno:%String,Tuseflag:%String,Tlquser:%String,Ttitle:%String,Tgrantrowid:%String")
{
}

ClassMethod FindZYGrantRcptExecute(ByRef qHandle As %Binary, userid As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

 	set rowid=0
 	while($o(^DHCSFRECEIPT(rowid))) {
	 	set rowid=$o(^DHCSFRECEIPT(rowid))
		set data=$g(^DHCSFRECEIPT(rowid))
		continue:(data="")
		set lqdate=$p(data,"^",1)
		set lqtime=$p(data,"^",2)
		set lqdate=##class(websys.Conversions).DateLogicalToHtml(lqdate)
		set lqtime=##class(websys.Conversions).TimeLogicalToHtml(lqtime)
		set stno=$p(data,"^",3)
		set endno=$p(data,"^",4)
		set curno=$p(data,"^",5)
		set useflag=$p(data,"^",7)
		set useflagDisplay=$case(useflag,1:"可用",2:"已发完",:"待用")
		set useflagDisplay=##class(websys.Translation).Get("", useflagDisplay, langId)
		set user=$p(data,"^",6)
		continue:((userid'="")&&(user'=userid))
	    set lquser=$p(data,"^",8)
		set lqusername=$s((lquser'=""):$p($g(^SSU("SSUSR",lquser)),"^",2),1:"")
		set lqusername=##class(User.SSUser).GetTranByDesc("SSUSRName", lqusername, langId)
		set title=$p(data,"^",9)
		do OutputZYGrantRcpt
	}
    
	quit $$$OK
OutputZYGrantRcpt
	set Data=$lb(lqdate,lqtime,stno,endno,curno,useflag,lqusername,title,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: 王刚
/// CreatDate: 2008.10.7
/// Description: 恢复发放
/// Table: dhc_sfbuy
ClassMethod getGrant(buyId As %String) As %String
{
	set buyloc=$p(^DHCSFBUY(buyId),"^",7)
	set num=0
	set rowid=0
	while($o(^DHCSFBUY(rowid))) {
		set rowid=$o(^DHCSFBUY(rowid))
		set buyData=$g(^DHCSFBUY(rowid))
		set userFlag=$p(buyData,"^",9)
		continue:(userFlag=2)   //过滤已用完的
		set myloc=$p(buyData,"^",7)
		continue:(myloc'=buyloc)
		set num=$i(num)
		quit
	}

	if (num=0) {
		&SQL(
			UPDATE dhc_sfbuy
			SET buy_useflag = '1', buy_comment1 = 'ReturnToFinished'
			WHERE %ID = :buyId
		)
	}else {
		&SQL(
			UPDATE dhc_sfbuy
			SET buy_useflag = '', buy_comment1 = 'ReturnToFinished'
			WHERE %ID = :buyId
		)
	}
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn
}

/// Description: 收费员已使用押金收据查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFReceipt","Findrcptsum","3","I","2022-04-08","2022-04-08","","","","2")
Query Findrcptsum(grp As %String, type As %String, stdate As %String, enddate As %String, stnum As %String, endnum As %String, title As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TCashier:%String:收费员,TCasherNo:%String:工号,TrcptNum:%String:张数,TrcptNo:%String:票据号段,Trcptsum:%Float:金额总计,Trcptnozf:%String:作废票据,Trcptnumzf:%String:作废张数,Tcurrno:%String:当前票号") [ SqlProc ]
{
}

ClassMethod FindrcptsumExecute(ByRef qHandle As %Binary, grp As %String, type As %String, stdate As %String, enddate As %String, stnum As %String, endnum As %String, title As %String, hospId As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("Findrcptsum")=$lb(grp, type, stdate, enddate, stnum , endnum, title, hospId, langId)
	if ((grp="")||(type=""))  quit $$$OK
	
    set stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
    set enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
    
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set rcptTotalNum=0
    set rcptTotalSum=0
    set rcptTotalZFNum=0

	set job=$j
	kill ^||TMP("RCPT",job)

    if ((stnum'="")&&(endnum'="")) {
	    if (type'="I")  quit $$$OK
	    
		for no=stnum:1:endnum {
			set rcptNo=##class(BILL.Util.Tools).FormatNO(no, $l(endnum))
			set rcptNo=title_rcptNo
			set depId=0
			while($o(^DHCSFPRINTDETAIL(0,"RcptNo",rcptNo,depId))) {
				set depId=$o(^DHCSFPRINTDETAIL(0,"RcptNo",rcptNo,depId))
				set depData=$g(^DHCSFPRINTDETAIL(depId))
				set hospDR=$p(depData,"^",44)
				continue:(hospDR'=hospId)
				set depUserDR=$p(depData,"^",14)
				set status=$p(depData,"^",8)
				set acount=$p(depData,"^",6)
				if (rcptNo'="") {
					set ^||TMP("RCPT",job,depUserDR,"NO",rcptNo)=""    //收据号
					set ^||TMP("RCPT",job,depUserDR,"USER",1)=$i(^||TMP("RCPT",job,depUserDR,"USER",1))     //收据张数
					set ^||TMP("RCPT",job,depUserDR,"USER",2)=$i(^||TMP("RCPT",job,depUserDR,"USER",2), acount)
				}
				if (status=2) {
					set ^||TMP("RCPT",job,depUserDR,"USER",3)=$i(^||TMP("RCPT",job,depUserDR,"USER",3))     //作废张数
					set ^||TMP("RCPT",job,depUserDR,"USER",4)=$s(('$d(^||TMP("RCPT",job,depUserDR,"USER",4))):rcptNo,1:($g(^||TMP("RCPT",job,depUserDR,"USER",4))_","_rcptNo)) //作废收据
				}
			}
		}
	}else {
		set rowid=$o(^DHCJFRcptGroupSet(0,"Type",type,grp,0))
	    if (rowid="")  quit $$$OK
	    
	    set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", hospId)
		set sub=0
		while($o(^DHCJFRcptGroupSet(rowid,"Sub",sub))) {
			set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub))
			set subData=$g(^DHCJFRcptGroupSet(rowid,"Sub",sub))
			continue:(subData="")
			set hospDR=$p(subData,"^",5)
	 		continue:(hospDR'=defHospId)
			set userDR=$p(subData,"^",4)
			
	 		for date=stdate:1:enddate  {
			    set depId=0
			    while($o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))) {
				    set depId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))
				    set depData=$g(^DHCSFPRINTDETAIL(depId))
					set hospDR=$p(depData,"^",44)
		 			continue:(hospDR'=hospId)
		  			set depUserDR=$p(depData,"^",14)
		 			continue:(depUserDR'=userDR)
		 			do BuildDepRcpt
				}
			}
		}
	}

	set userDR=0
	while($o(^||TMP("RCPT",job,userDR))) {
		set userDR=$o(^||TMP("RCPT",job,userDR))
		set userCode=$p(^SSU("SSUSR",userDR),"^",1)
		set userName=$p(^SSU("SSUSR",userDR),"^",2)
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		set rcptnum=+$g(^||TMP("RCPT",job,userDR,"USER",1))
		set rcptTotalNum=$i(rcptTotalNum, rcptnum)
		set rcptsum=$g(^||TMP("RCPT",job,userDR,"USER",2))
		set rcptsum=$fn(rcptsum,"",2)
		set rcptTotalSum=$i(rcptTotalSum, rcptsum)
		set rcptnumzf=+$g(^||TMP("RCPT",job,userDR,"USER",3))
		set rcptTotalZFNum=$i(rcptTotalZFNum, rcptnumzf)
		set rcptnozf=$g(^||TMP("RCPT",job,userDR,"USER",4))   //作废收据号
		set rcptno=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "RCPT", job, userDR, "NO")
		set rcptinfo=..getrcptinfo(userDR, "I", hospId)  //当前发票号
		set currno=$p($p(rcptinfo,"^",2),"-",1)
		do Outputrcptsum
	}
	kill ^||TMP("RCPT",job)
	
	set rcptno=""
	set userCode=""
	set userName=##class(websys.Translation).Get("", "合计", langId)
	set rcptnum=rcptTotalNum
	set rcptsum=$fn(rcptTotalSum,"",2)
	set rcptnozf=""
	set rcptnumzf=rcptTotalZFNum
	set currno=""
	do Outputrcptsum
		
	quit $$$OK
	
BuildDepRcpt
	set depUserDR=$p(depData,"^",14)
	set status=$p(depData,"^",8)
	set acount=$p(depData,"^",6)
	set rcptNo=$p(depData,"^",1)
	set initDepDR=$p(depData,"^",43)    //prt_initdep_dr
	set initRcptNo=rcptNo
	if ((initRcptNo="")&&(+initDepDR'=0)) {
		set initRcptNo=$p($g(^DHCSFPRINTDETAIL(initDepDR)),"^",1)          //负记录不走号时取原记录收据号
	}
	if (rcptNo'="") {
		set ^||TMP("RCPT",job,depUserDR,"NO",rcptNo)=""    //收据号
		set ^||TMP("RCPT",job,depUserDR,"USER",1)=$i(^||TMP("RCPT",job,depUserDR,"USER",1))     //收据张数
		set ^||TMP("RCPT",job,depUserDR,"USER",2)=$i(^||TMP("RCPT",job,depUserDR,"USER",2), acount)
	}
	if ((status=2)&&(initRcptNo'="")) {
		if ((","_$g(^||TMP("RCPT",job,depUserDR,"USER",4))_",")'[(","_initRcptNo_",")) {
			set ^||TMP("RCPT",job,depUserDR,"USER",3)=$i(^||TMP("RCPT",job,depUserDR,"USER",3))     //作废张数
			set ^||TMP("RCPT",job,depUserDR,"USER",4)=$s(('$d(^||TMP("RCPT",job,depUserDR,"USER",4))):initRcptNo,1:($g(^||TMP("RCPT",job,depUserDR,"USER",4))_","_initRcptNo)) //作废收据
		}
	}
	quit
	
Outputrcptsum
	set Data=$lb(userName,userCode,rcptnum,rcptno,rcptsum,rcptnozf,rcptnumzf,currno)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFReceipt","FindrcptNum","3","I","")
Query FindrcptNum(type As %String, hospId As %String, userId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TCashier:%String:收款员,TCasherNo:%String:工号,TrcptNum:%String:张数,TrcptNo:%String:号段")
{
}

ClassMethod FindrcptNumExecute(ByRef qHandle As %Binary, type As %String, hospId As %String, userId As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    if (type="") quit $$$OK
    set rowid=$o(^DHCJFRcptGroupSet(0,"Type",type,3,0))
    if (rowid="") quit $$$OK
    
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", hospId)
	
	set sub=0
	while($o(^DHCJFRcptGroupSet(rowid,"Sub",sub))) {
		set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub))
		set data=$g(^DHCJFRcptGroupSet(rowid,"Sub",sub))
		continue:(data="")
		set hospDR=$p(data,"^",5)
		continue:(hospDR'=defHospId)
		set userDR=$p(data,"^",4)
		continue:((userId'="")&&(userId'=userDR))
		set userCode=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",1),1:"")
		set userName=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	 	set rtnValue=..getrcptinfo(userDR, type, hospDR)
	 	set rcptnum=$p(rtnValue,"^",1)
	 	set rcptno=$p(rtnValue,"^",2)
		continue:(rcptno="")
		do OutputrcptNum
	}
    
	quit $$$OK
OutputrcptNum
	set Data=$lb(userName,userCode,rcptnum,rcptno)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getrcptinfo(userid, type, hospId) As %String
{
	s num=0
	s rcptStr=""
	s rowid=0
    f  s rowid=$o(^DHCSFRECEIPT(0,"lquser",userid,rowid)) q:(rowid="")  d
    .s rcptData=$g(^DHCSFRECEIPT(rowid))
    .s lquser=$p(rcptData,"^",8)
    .//q:(userid'=lquser)
    .s hospDR=$p(rcptData,"^",22)
    .q:(hospDR'=hospId)
    .s finalFlag=$p(rcptData,"^",7)
	.q:(finalFlag'=1)
    .s rcpttype=$p(rcptData,"^",15)
	.q:(type'=rcpttype)
    .s title=$p(rcptData,"^",9)
    .s curno=$p(rcptData,"^",5)
    .s endno=$p(rcptData,"^",4)
    .s num=$i(num,(endno-curno+1))
    .s tmp=title_curno_"-"_title_endno
    .s rcptStr=$s((rcptStr=""):tmp,1:(rcptStr_","_tmp))
	
	s rtn=num_"^"_rcptStr
	q rtn
}

ClassMethod GetGrantStNoInfo(type As %String, hospId As %String) As %String
{
	s curno="", endno="", title=""
	s rowid=0
	f  s rowid=$o(^DHCSFBUY(rowid)) q:(rowid="")  d
	.s data=$g(^DHCSFBUY(rowid))
	.q:(data="")
	.s useflag=$p(data,"^",9)
	.q:(useflag'=1)
	.s loc=$p(data,"^",7)
	.q:(type'=loc)
	.s hospDR=$p(data,"^",16)
	.q:(hospDR'=hospId)
	.s curno=$p(data,"^",8)
	.s endno=$p(data,"^",4)
	.s title=$p(data,"^",11)
	
	s str=curno_"^"_endno_"^"_title
    q str
}

/// Creator: ZhYW
/// CreatDate: 2017-09-30
/// Description: 查询未使用的购入押金收据
/// Input: type:发票类型, hospId:CT_Hospital.RowID, userId: 购入人Id
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFReceipt","FindRcptBuyList", "I", 2)
Query FindRcptBuyList(type As %String, hospId As %String, userId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String:ID,startNo:%String:开始号码,endNo:%String:结束号码,curNo:%String:当前号码,title:%String:开始字母,leftNum:%Integer:余票数,buyer:%String:购入人,buyDate:%String:购入日期,buyTime:%String:购入时间")
{
}

ClassMethod FindRcptBuyListExecute(ByRef qHandle As %Binary, type As %String, hospId As %String, userId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (type="") quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set id=0
	while($o(^DHCSFBUY(id))) {
		set id=$o(^DHCSFBUY(id))
		set buyData=$g(^DHCSFBUY(id))
		continue:(buyData="")
		set useflag=$p(buyData,"^",9)
		continue:(+useflag=2)
		set loc=$p(buyData,"^",7)
		continue:(type'=loc)
		set userDR=$p(buyData,"^",10)
		continue:((userId'="")&&(userId'=userDR))
		set buyer=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",2),1:"")
		set buyer=##class(User.SSUser).GetTranByDesc("SSUSRName", buyer, langId)
		set hospDR=$p(buyData,"^",16)
		continue:(hospId'=hospDR)
		set buyDate=$p(buyData,"^",1)
		set buyDate=##class(websys.Conversions).DateLogicalToHtml(buyDate)
		set buyTime=$p(buyData,"^",2)
		set buyTime=##class(websys.Conversions).TimeLogicalToHtml(buyTime)
		set startNo=$p(buyData,"^",3)
		set curNo=$p(buyData,"^",8)
		set endNo=$p(buyData,"^",4)
		set title=$p(buyData,"^",11)
		set leftNum=+endNo-curNo+1
		do OutputRcptBuyList
	}
	
	quit $$$OK

OutputRcptBuyList
	set Data=$lb(id,startNo,endNo,curNo,title,leftNum,buyer,buyDate,buyTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-09-30
/// Description: 将购入收据"待用"更新为"可用"
/// Input: rowID: dhc_sfbuy.RowID
/// Return: rtn, 0:更新成功, <>0 更新成功
/// Debug: w ##class(web.UDHCJFReceipt).UpdateRcptBuyAvail()
ClassMethod UpdateRcptBuyAvail(rowID As %String) As %String
{
	set rtn=0
	quit:(+rowID=0) rtn
	set useFlag=$p(^DHCSFBUY(rowID),"^",9)
	quit:(useFlag'="") rtn
	&SQL(
		UPDATE dhc_sfbuy
		SET buy_useflag = '1'
		WHERE %ID = :rowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

}
