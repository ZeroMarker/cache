Import SQLUser

Class web.UDHCJFInvprt Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 购入发票列表查询
/// do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","InvprtBuyList","O","","","",2)
Query InvprtBuyList(type As %String, stDate As %String, endDate As %String, buyerId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TBuyId:%String:ID,TBuyDate:%String:购入日期,TBuyTime:%String:购入时间,TStartno:%String:开始号码,TEndno:%String:结束号码,TBuyer:%String:购入人,TCurrentno:%String:当前号码,TUseFlag:%String,TUseFlagDisplay:%String:可用标记,TInvType:%String:发票类型,TTitle:%String:开始字母,TReturnFlag:%String") [ SqlProc ]
{
}

ClassMethod InvprtBuyListExecute(ByRef qHandle As %Binary, type As %String, stDate As %String, endDate As %String, buyerId As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (type="") quit $$$OK
	set ^TMP("InvprtBuyList")=$lb(type, stDate, endDate, buyerId, hospId)
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set invTypeId=$o(^DHCJFBILLADMREACON(0,type,0))
	set invType=$s((+invTypeId'=0):$p(^DHCJFBILLADMREACON(invTypeId),"^",2),1:"")
	set invType=##class(User.dhcjfbilladmreasonconfig).GetTranByDesc("ADMCONDesc", invType, langId)
	
	set rowId=0
	while($o(^DHCAMTMAG(0,"L",type,rowId))) {
		set rowId=$o(^DHCAMTMAG(0,"L",type,rowId))
		set magData=$g(^DHCAMTMAG(rowId))
		set buyDate=$p(magData,"^",1)
		continue:((stDate'="")&&(buyDate<stDate))
		continue:((endDate'="")&&(buyDate>endDate))
		set hospDR=$p(magData,"^",16)
		continue:(hospDR'=hospId)
		set buyDate=##class(websys.Conversions).DateLogicalToHtml(buyDate)
		set buyTime=$p(magData,"^",12)
		set buyTime=##class(websys.Conversions).TimeLogicalToHtml(buyTime)
		set startno=$p(magData,"^",5)
		set endno=$p(magData,"^",6)
		set userDR=$p(magData,"^",3)
		continue:((buyerId'="")&&(userDR'=buyerId))
		set buyer=$s(((userDR'="")):$p(^SSU("SSUSR",userDR),"^",2),1:"")
		set buyer=##class(User.SSUser).GetTranByDesc("SSUSRName", buyer, langId)
		set currentno=$p(magData,"^",10)
		set useFlag=$p(magData,"^",9)
		set useFlagDisplay=$case(useFlag,"Y":"可用","N":"已用完",:"待用")
		set useFlagDisplay=##class(websys.Translation).Get("", useFlagDisplay, langId)
		set title=$p(magData,"^",13)
		set returnflag=$p(magData,"^",14)
		set ReturnFlag=$case(returnflag,"Return":"Y",:"")
		do OutputBuyList
	}
	
	quit $$$OK

OutputBuyList
	set Data=$lb(rowId,buyDate,buyTime,startno,endno,buyer,currentno,useFlag,useFlagDisplay,invType,title,returnflag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","Invprtdeliver","I","2020-09-14","2020-09-14","671","2")
Query Invprtdeliver(type As %String, stdate As %String, enddate As %String, deliverId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "Trowid:%String:ID,Tdate:%String:领取日期,Ttime:%String:领取时间,Tstartno:%String:开始号码,Tendno:%String:结束号码,Tcurrentno:%String:当前号码,Ttype:%String:发票类型,TuseFlag:%String,TuseFlagDisplay:%String:发票状态,Ttitle:%String:开始字母,Tlquser:%String:接收人,ToriginalUserName:%String:转交人")
{
}

ClassMethod InvprtdeliverExecute(ByRef qHandle As %Binary, type As %String, stdate As %String, enddate As %String, deliverId As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	if (type="")  quit $$$OK
	set ^TMP("Invprtdeliver")=$lb(type, stdate, enddate, deliverId, hospId)
 	set stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	set enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	if (deliverId'="") {
		set rowId=""
		while($o(^DHCINVOICE(0,"USER",deliverId,rowId),-1)) {
			set rowId=$o(^DHCINVOICE(0,"USER",deliverId,rowId),-1)
			do GetDeliList
		}
	}else {
		set rowId=""
		while($o(^DHCINVOICE(0,"TYPE",type,rowId),-1)) {
			set rowId=$o(^DHCINVOICE(0,"TYPE",type,rowId),-1)
			do GetDeliList
		}
	}
	
	quit $$$OK
GetDeliList
	set invData=$g(^DHCINVOICE(rowId))
	set hospDR=$p(invData,"^",26)
	quit:(hospDR'=hospId)
	set bstartno=$p(invData,"^",1)
	set bendno=$p(invData,"^",2)
	set bcurrentno=$p(invData,"^",6)
	set btype=$p(invData,"^",8)
	quit:((type'="")&&(type'=btype))
	set btype=$case(btype,"I":"住院","O":"门诊","E":"急诊","R":"挂号","L":"注册",:btype)
	set btype=##class(websys.Translation).Get("", btype, langId)
	set useFlag=$p(invData,"^",7)
	set useFlagDisplay=$case(useFlag,"Y":"可用","N":"已用完",:"待用")
	set useFlagDisplay=##class(websys.Translation).Get("", useFlagDisplay, langId)
	set buserDR=$p(invData,"^",3)
	quit:((deliverId'="")&&(deliverId'=buserDR))
	set lqusername=$s((buserDR'=0):$p($g(^SSU("SSUSR",buserDR)),"^",2),1:"")
	set lqusername=##class(User.SSUser).GetTranByDesc("SSUSRName", lqusername, langId)
	set bdate=$p(invData,"^",4)
	//quit:((stdate'="")&&(bdate<stdate))
	//quit:((enddate'="")&&(bdate>enddate))
	set bdate=##class(websys.Conversions).DateLogicalToHtml(bdate)
	set btime=$p(invData,"^",5)
	set btime=##class(websys.Conversions).TimeLogicalToHtml(btime)
	set originalDR=$p(invData,"^",15)
	set originalUserDR=$s((+originalDR'=0):$p(^DHCINVOICE(originalDR),"^",3),1:"")
	set originalUserName=$s((+originalUserDR'=0):$p($g(^SSU("SSUSR",originalUserDR)),"^",2),1:"")
	set originalUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", originalUserName, langId)
	set title=$p(invData,"^",16)
	do OutputDeliList
	quit
OutputDeliList
   	set Data=$lb(rowId,bdate,btime,bstartno,bendno,bcurrentno,btype,useFlag,useFlagDisplay,title,lqusername,originalUserName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod Getkydeliver(userId As %String, type As %String, hospId As %String) As %String
{
	new (userId, type, hospId)
	set invoiceId="", curno="", endno="", title=""
	set rowid=0
	while($o(^DHCINVOICE(0,"USER",userId,rowid))) {
		set rowid=$o(^DHCINVOICE(0,"USER",userId,rowid))
		set invData=$g(^DHCINVOICE(rowid))
		set hospDR=$p(invData,"^",26)
		continue:(hospDR'=hospId)
		set curType=$p(invData,"^",8)
		continue:(curType'=type)
		set finalFlag=$p(invData,"^",7)
		continue:(finalFlag'="Y")
		set curno=$p(invData,"^",6)
		set endno=$p(invData,"^",2)
		set title=$p(invData,"^",16)
		set invoiceId=rowid
		quit
	}
	set leftNum=$s((+invoiceId'=0):(endno-curno+1),1:0)   //余票数
	set str=curno_"^"_endno_"^"_invoiceId_"^"_title_"^"_leftNum
    quit str
}

/// 发票转交
/// Debug: w ##class(web.UDHCJFInvprt).deliverinv("^0012791^0012888^10207^0012888^25^O^10208^5^1^0012788", 2)
ClassMethod deliverinv(str As %String, hospId As %String) As %String
{
	new (str, hospId)
	set ^TMP("deliverinv")=$lb(str, hospId)
	kill PLIST
	set flag=$p(str,"^",10)         //flag=1 时为输入开始号码
	set currStartno=$p(str,"^",11)  //flag=1 输并且currStartno=入的号码(全部转交) 改转交人发票状态为不可用,启用新的发票
	set PLIST(2)=$p(str,"^",2)
	set PLIST(3)=$p(str,"^",3)
	set PLIST(4)=$p(str,"^",4)
	set lquser=PLIST(4)
	set PLIST(5)=+$h
	set PLIST(6)=$p($h,",",2)
	set PLIST(7)=PLIST(2)
	set invtype=$p(str,"^",7)
	set userno=$p(str,"^",8)
	set userId=$p(str,"^",9)

	set Quetflag=..CheckUsrNoAvail(PLIST(2), PLIST(3), userno, invtype)
	quit:(+Quetflag'=1) -100

	set cw=..invcw(PLIST(4), invtype, hospId)
	set PLIST(8)=$s((cw>0):"",1:"Y")
	set PLIST(9)=invtype
	set PLIST(10)="N"
	set buyend=$p(str,"^",5)
	set invid=$p(str,"^",6)
	set lqenno=PLIST(3)
	set lqstno=PLIST(2)
	set PLIST(16)=invid
	set PLIST(17)=$p(^DHCINVOICE(invid),"^",16)    //INV_title
	set PLIST(26)=hospId
	
	set $zt="ERROR^DHCSSERR"
	ts
	
	&SQL(INSERT INTO DHC_INVOICE VALUES PLIST())
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if (flag=0) {
		if (lqenno'=buyend) {
			set rtn=..deliverinvupdate(lqenno, invid)
		}else {
			set rtn=..deliverinvrefund(userno, invid, invtype, hospId)
		}
	}else {
		if (lqstno'=currStartno) {
			set rtn=..deliverinvupdate1(lqstno, invid)
		}else {
			set rtn=..deliverinvrefund(userno, invid, invtype, hospId)
		}
	}
	if (+rtn) tro  quit rtn
	if ($tl>0) tc
	
	quit rtn
}

/// Creator: 2014-12-03
/// Description: 发票转交时调用  判断开始号码到结束号码段是否还在操作员的可用号码段内
ClassMethod CheckUsrNoAvail(stno As %String, endno As %String, user As %String, type As %Integer) As %String
{
	new (stno, endno, user, type)
    quit:(stno="")||(endno="")||($l(stno)'=$l(endno))||(+stno>(+endno)) -1
    set CheckFlag=0
    set invdr=""
    for  set invdr=$o(^DHCINVOICE(0,"USER",user,invdr),-1)  quit:((invdr="")||(CheckFlag=1))  do
    .set invData=$g(^DHCINVOICE(invdr))
    .set finalFlag=$p(invData,"^",7)
    .quit:(finalFlag'="Y")
    .set loc=$p(invData,"^",8)
    .quit:(loc'=type)
    .set curstno=$p(invData,"^",6)
    .set curendno=$p(invData,"^",2)
    .if ($l(curstno)=$l(stno))&&((((+curstno)=(+stno))&&((+endno)<=(+curendno)))||(((+curendno)=(+endno))&((+curstno)<=(+stno))))  set CheckFlag=1
    
    quit CheckFlag
}

ClassMethod deliverinvrefund(userId As %String, invId As %String, type As %String, hospId As %String) As %String
{
	new (userId, invId, type, hospId)
	&SQL(
		UPDATE DHC_INVOICE
		SET INV_Finalflag = 'N'
		WHERE %ID = :invId
	)
	&SQL(
		SELECT count(*) INTO :num
		FROM DHC_INVOICE
		WHERE (INV_Finalflag = '' OR INV_Finalflag IS NULL) AND INV_Usr = :userId AND INV_type = :type AND INV_hospital = :hospId
	)
	if (num'=0) {
		&SQL(
			SELECT min(%ID) INTO :invRowId
			FROM DHC_INVOICE
			WHERE (INV_Finalflag = '' OR INV_Finalflag IS NULL) AND INV_Usr = :userId AND INV_type = :type AND INV_hospital = :hospId
		)
		&SQL(
			UPDATE DHC_INVOICE
			SET INV_Finalflag = 'Y'
			WHERE %ID = :invRowId
		)
	}
	quit SQLCODE
}

/// 修改住院处领取收据的结束编号?将当前编号改为结束编号
ClassMethod deliverinvupdate(endno As %String, invId As %String) As %String
{
	new (endno, invId)
	set endno=##class(web.UDHCJFBaseCommon).incre(endno)
	&SQL(
		UPDATE DHC_INVOICE
		SET INV_LastNum = :endno
		WHERE %ID = :invId
	)
	quit SQLCODE
}

/// w ##class(web.UDHCJFInvprt).invprtgetmax("O", 2)
ClassMethod invprtgetmax(type As %String, hospId As %String) As %String
{
	new (type, hospId)
	set buyendno=""
	&SQL(
		SELECT max(%ID) INTO :maxrow
		FROM DHC_AMTMAG
		WHERE finac_loc = :type AND finac_hospital = :hospId)
	&SQL(
		SELECT nvl(finac_ednum, '') INTO :buyendno
		FROM DHC_AMTMAG
		WHERE %ID = :maxrow
	)
	if (buyendno'="") {
		set buyendno=##class(web.UDHCJFBaseCommon).incre(buyendno)    //从下一个号码开始购入
	}
	quit buyendno
}

/// Description: 发票购入
/// Debug: w ##class(web.UDHCJFInvprt).dhcamtmaginsert("^^O^17275^^01020402^01023401^^17275^^^AA","2")
ClassMethod dhcamtmaginsert(str As %String, hospId As %String) As %String
{
	new (str, hospId)
	kill PLIST
	set PLIST(3)=$p(str,"^",3)
	set PLIST(4)=$p(str,"^",4)
	set PLIST(6)=$p(str,"^",6)
	set PLIST(8)=PLIST(6)
	set PLIST(7)=$p(str,"^",7)
	set PLIST(9)=$p(str,"^",9)
	set PLIST(14)=$replace($p(str,"^",12)," ","")  //add by wangjian 2015-03-18 去掉字母中空格
	set PLIST(17)=hospId
	set cw=..finaccw(PLIST(3), hospId)
	set PLIST(11)=$s((cw>0):"",1:"Y")
	
	set myBegINVNo=PLIST(6)
	set myEndINVNo=PLIST(7)
	set myINVType=PLIST(3)
	set myPreNoABC=PLIST(14)
	
	set myCheckInfo=##class(web.UDHCINVManager).CheckINVBuyInfo(myPreNoABC, myINVType, myBegINVNo, myEndINVNo)
	set rtn=$p(myCheckInfo,"^",1)
	set myFindFlag=$p(myCheckInfo,"^",2)
	quit:(+rtn) rtn
	quit:(+myFindFlag=1) -505_"^"_"发票已经购入，不能重复购入"
	
	set $zt="ERROR^DHCSSERR"
	ts
	
	&SQL(INSERT INTO DHC_AMTMAG VALUES PLIST())
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn
}

ClassMethod finaccw(type As %String, hospId As %String) As %Integer
{
	new (type, hospId)
	&SQL(
		SELECT count(*) INTO :count
		FROM DHC_AMTMAG
		WHERE finac_avail = 'Y' AND finac_loc = :type AND finac_hospital = :hospId
	)
	quit count
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","InvprtGrantList","All","O","","2021-03-01","2021-08-06","2")
Query InvprtGrantList(invprtFlag As %String, type As %String, lquserid As %String, stdate As %String, enddate As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TgrantId:%String:ID,Tdate:%String:发放日期,Ttime:%String:发放时间,Tstartno:%String:开始号码,Tendno:%String:结束号码,Tcurrentno:%String:当前号码,Tlquser:%String:领取人,TlquserId:%String,Tflag:%String,TflagDisplay:%String:发票状态,Tbtype:%String,Ttype:%String:发票类型,Ttitle:%String:开始字母,leftinvnum:%Integer:剩余张数,TConfirmFlag:%String,TConfirmDate:%String,TConfirmTime:%String,TReturnFlag:%String,TReturnDate:%String,TReturnTime:%String,TConfirmInvRowId:%String:核销ID,TConfirmInvDate:%String:核销日期,TConfirmInvTime:%String:核销时间,TConfirmInvUser:%String:核销人") [ SqlProc ]
{
}

ClassMethod InvprtGrantListExecute(ByRef qHandle As %Binary, invprtFlag As %String, type As %String, lquserid As %String, stdate As %String, enddate As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("InvprtGrantList")=$lb(invprtFlag, type, lquserid, stdate, enddate, hospId)
 	if (type="")  quit $$$OK
 	set stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	set enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rowId=0
	while($o(^DHCINVOICE(0,"TYPE",type,rowId))) {
		set rowId=$o(^DHCINVOICE(0,"TYPE",type,rowId))
		set invData=$g(^DHCINVOICE(rowId))
		set hospDR=$p(invData,"^",26)
		continue:(hospDR'=hospId)
		set btype=$p(invData,"^",8)
		set bdate=$p(invData,"^",4)
		continue:((stdate'="")&&(bdate<stdate))
		continue:((enddate'="")&&(bdate>enddate))
		set bdate=##class(websys.Conversions).DateLogicalToHtml(bdate)
		set btime=$p(invData,"^",5)
		set btime=##class(websys.Conversions).TimeLogicalToHtml(btime)
		set bstartno=$p(invData,"^",1)
		set bendno=$p(invData,"^",2)
		set buserDR=$p(invData,"^",3)
		continue:((lquserid'="")&&(lquserid'=buserDR))
		set buser=$s((buserDR'=""):$p(^SSU("SSUSR",buserDR),"^",2),1:"")
		set buser=##class(User.SSUser).GetTranByDesc("SSUSRName", buser, langId)
		set bcurrent=$p(invData,"^",6)
		set useFlag=$p(invData,"^",7)
		set confirmInvRowId=$o(^DHCCONFIRMINVOICE(0,"InvoiceDr",rowId,0))
		if (invprtFlag="Confirm")  quit:(confirmInvRowId="")&&(invprtFlag'="All")
		if (invprtFlag'="Confirm") quit:(confirmInvRowId'="")&&(invprtFlag'="All")
		continue:((invprtFlag'="Confirm")&&(invprtFlag'="All")&&(useFlag'=invprtFlag))
		set leftinvnum=$s((useFlag="N"):0,1:(bendno-bcurrent+1))   //余票数
		set useFlagDisplay=$case(useFlag,"Y":"可用","N":"已用完",:"待用")
		//add by wanghuicai 2009-04-14
		set confirmInvDate="", confirmInvTime="", confirmInvUser=""
		if (confirmInvRowId'="") {
			set useFlagDisplay="已核销"
			set confirmInvData=$g(^DHCCONFIRMINVOICE(confirmInvRowId))
			set confirmInvDate=$p(confirmInvData,"^",2)
			set confirmInvDate=##class(websys.Conversions).DateLogicalToHtml(confirmInvDate)
			set confirmInvTime=$p(confirmInvData,"^",3)
			set confirmInvTime=##class(websys.Conversions).TimeLogicalToHtml(confirmInvTime)
		    set confirmInvUser=$p(confirmInvData,"^",4)
		    set confirmInvUser=$p(^SSU("SSUSR",confirmInvUser),"^",2)
		    set confirmInvUser=##class(User.SSUser).GetTranByDesc("SSUSRName", confirmInvUser, langId)
		}
		set useFlagDisplay=##class(websys.Translation).Get("", useFlagDisplay, langId)
	    set typeDisplay=$case(btype,"I":"住院","O":"门诊","E":"急诊","R":"挂号","L":"注册",:"")
	    set typeDisplay=##class(websys.Translation).Get("", typeDisplay, langId)
		set title=$p(invData,"^",16)
		set confirmflag=$p(invData,"^",19)
		set confirmdate=$p(invData,"^",20)
		set confirmtime=$p(invData,"^",21)
		set confirmdate=##class(websys.Conversions).DateLogicalToHtml(confirmdate)
		set confirmtime=##class(websys.Conversions).TimeLogicalToHtml(confirmtime)
		set returnflag=$p(invData,"^",22)
		set returndate=$p(invData,"^",23)
		set returntime=$p(invData,"^",24)
		set returndate=##class(websys.Conversions).DateLogicalToHtml(returndate)
		set returntime=##class(websys.Conversions).TimeLogicalToHtml(returntime)
		do OutputGrantList
	}
	
	quit $$$OK

OutputGrantList
	set Data=$lb(rowId,bdate,btime,bstartno,bendno,bcurrent,buser,buserDR,useFlag,useFlagDisplay,btype,typeDisplay,title,leftinvnum,confirmflag,confirmdate,confirmtime,returnflag,returndate,returntime,confirmInvRowId,confirmInvDate,confirmInvTime,confirmInvUser)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getmaxrow(type As %String, hospId As %String)
{
	new (type, hospId)
	set rowid=$o(^DHCAMTMAG(0,"L",type,""),-1)
	set stno=$p($g(^DHCAMTMAG(rowid)),"^",5)
	set curno=$p($g(^DHCAMTMAG(rowid)),"^",10)
	quit rowid_"^"_stno_"^"_curno
}

/// Description: 购入发票删除
/// Debug: w ##class(web.UDHCJFInvprt).DeleteBuy(2)
ClassMethod DeleteBuy(rowId As %String) As %String
{
	new (rowId)
	quit:(+rowId=0) -1_"^"_"参数错误"
	set magData=$g(^DHCAMTMAG(rowId))
	set startNo=$p(magData,"^",5)
	set curNo=$p(magData,"^",10)
	quit:(startNo'=curNo) -2_"^"_"开始号跟当前号不一致，不能删除"   //开始号跟当前号不一致，表示此号段已使用，不能删除
	&SQL(DELETE FROM DHC_AMTMAG WHERE %ID = :rowId)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// Debug: w ##class(web.UDHCJFInvprt).dhcamtmaguse("O", 2)
ClassMethod dhcamtmaguse(type As %String, hospId As %String) As %String
{
	new (type, hospId)
	set startNo="", endNo="", curNo="", buyId="", title=""
	set leftNum=0
	set id=0
	while($o(^DHCAMTMAG(0,"A","Y",id))) {
		set id=$o(^DHCAMTMAG(0,"A","Y",id))
		set buyData=$g(^DHCAMTMAG(id))
		set myType=$p(buyData,"^",2)
		continue:(type'=myType)
		set hospDR=$p(buyData,"^",16)
		continue:(hospDR'=hospId)
		set startNo=$p(buyData,"^",5)
		set endNo=$p(buyData,"^",6)
		set curNo=$p(buyData,"^",10)
		set title=$p(buyData,"^",13)
		set buyId=id
		quit
	}
	set leftNum=+endNo-curNo+1
	set rtn=startNo_"^"_endNo_"^"_curNo_"^"_buyId_"^"_title_"^"_leftNum
	quit rtn
}

/// Description: 发票发放
/// Debug: w ##class(web.UDHCJFInvprt).dhcinvoiceinsert("^2001^9999^2^9999^O^12", 2, 2)
ClassMethod dhcinvoiceinsert(str As %String, AMRowID As %String, hospId As %String) As %String
{
	new (str, AMRowID, hospId)
	kill PLIST
	set PLIST(2)=$p(str,"^",2)
	set PLIST(3)=$p(str,"^",3)
	set PLIST(4)=$p(str,"^",4)
	set PLIST(5)=+$h
	set PLIST(6)=$p($h,",",2)
	set buyend=$p(str,"^",5)
	set type=$p(str,"^",6)
	set PLIST(9)=type
	set PLIST(10)="N"
	set PLIST(7)=PLIST(2)
	set cw=..invcw(PLIST(4), type, hospId)
	set PLIST(8)=$s((cw>0):"",1:"Y")
	
	set lqenno=PLIST(3)
	set PLIST(17)=$p(str,"^",7)
	set PLIST(26)=hospId

	set myBegINVNo=PLIST(2)
	set myEndINVNo=PLIST(3)
	set myINVType=PLIST(9)
	set myPreNoABC=PLIST(17)
	
	quit:(AMRowID="") -506_"^"_"发放号段不存在"
	
	set myAmtMagData=$g(^DHCAMTMAG(AMRowID))
	quit:(myAmtMagData="") -506_"^"_"发放号段不存在"
	
	set myAmtMLastNo=$p(myAmtMagData,"^",10)    //finac_note
	quit:(myBegINVNo'=myAmtMLastNo) -507_"^"_"开始号码错误"
	
	set myAmtMEndNo=$p(myAmtMagData,"^",6)     //finac_ednum
	quit:(+myEndINVNo>+myAmtMEndNo) -508_"^"_"结束号码错误"
	
	set myCheckInfo=##class(web.UDHCINVManager).CheckINVDispenseInfo(myPreNoABC, myINVType, myBegINVNo, myEndINVNo)
	set rtn=$p(myCheckInfo,"^",1)
	quit:(+rtn) rtn
	set myFindFlag=$p(myCheckInfo,"^",2)
  	
  	set $zt="ERROR^DHCSSERR"
	ts
	
	&SQL(INSERT INTO DHC_INVOICE VALUES :PLIST())
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if (lqenno'=buyend) {
		set rtn=..invupdateByRowID(lqenno, AMRowID)
	}else  {
		set rtn=..invrefund(type, hospId, AMRowID)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
}

/// 当领取的结束编号等于可用收据的结束编号时?将标志置为不可用????同时判断是否有待用的收据
/// 有则将待用的rowid最小的变为可用标志
ClassMethod invrefund(type As %String, hospId As %String, AMRowID As %String) As %String
{
	new (type, hospId, AMRowID)
	&SQL(
		UPDATE DHC_AMTMAG
		SET finac_avail = 'N', finac_note = finac_ednum
		WHERE %ID = :AMRowID
	)
	&SQL(
		SELECT count(*) INTO :num
		FROM DHC_AMTMAG
		WHERE (finac_avail = '' OR finac_avail IS NULL) AND %ID <>'0' AND finac_loc=:type AND finac_hospital=:hospId
	)
	if (num'=0) {
		&SQL(
			SELECT min(%ID) INTO :rowid1
			FROM DHC_AMTMAG
			WHERE (finac_avail = '' OR finac_avail IS NULL) AND %ID <> '0' AND finac_loc=:type AND finac_hospital=:hospId
		)
		&SQL(
			UPDATE DHC_AMTMAG
			SET finac_avail = 'Y'
			WHERE %ID = :rowid1
		)
	}
	quit SQLCODE
}

/// 修改住院处领取收据的结束编号?将当前编号改为结束编号
ClassMethod invupdate(endno As %String, buyend As %String, type As %String, hospId As %String) As %String
{
	new (endno, buyend, type, hospId)
	if (endno'=buyend) {
		set endno=##class(web.UDHCJFBaseCommon).incre(endno)
	}
	&SQL(
		UPDATE DHC_AMTMAG
		SET finac_note = :endno
		WHERE finac_avail = 'Y' AND finac_loc = :type AND finac_hospital = :hospId
	)
	quit SQLCODE
}

/// 修改购入发票的结束编号?将当前编号改为结束编号
ClassMethod invupdateByRowID(endno As %String, AMRowID As %String) As %String
{
	new (endno, AMRowID)
	set endno=##class(web.UDHCJFBaseCommon).incre(endno)
	&SQL(
		UPDATE DHC_AMTMAG
		SET finac_note = :endno
		WHERE %ID = :AMRowID
	)
	quit SQLCODE
}

ClassMethod invcw(userId As %Integer, type As %String, hospId As %String) As %Integer
{
	new (userId, type, hospId)
	&SQL(
		SELECT count(*) INTO :count
		FROM DHC_INVOICE
		WHERE INV_Finalflag = 'Y' AND INV_Usr = :userId AND INV_type = :type AND INV_hospital = :hospId
	)
	quit count
}

ClassMethod GetInvInfo(userId As %String, type As %String, hospId As %String) As %String
{
	new (userId, type, hospId)
	set num=0
	set invStr=""
	set rowid=0
	while($o(^DHCINVOICE(0,"USER",userId,rowid))) {
		set rowid=$o(^DHCINVOICE(0,"USER",userId,rowid))
		set invData=$g(^DHCINVOICE(rowid))
	    set finalFlag=$p(invData,"^",7)
		continue:(finalFlag="N")
	    set invtype=$p(invData,"^",8)
	    continue:(type'=invtype)
	    set hospDR=$p(invData,"^",26)
	    continue:(hospDR'=hospId)
	    set currentno=$p(invData,"^",6)
	    set endno=$p(invData,"^",2)
	    set myINVPreABC=$p(invData,"^",16)
	    set num=num+(+endno)-(+currentno)+1
	    if (myINVPreABC'="") set currentno=myINVPreABC_currentno, endno=myINVPreABC_endno
	    set noStr=currentno_"-"_endno
	    set invStr=$s((invStr=""):noStr,1:(invStr_","_noStr))
	}
    
	set rtn=num_"^"_invStr
	quit rtn
}

/// Description: 收费员未使用发票查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","FindInvNum","O",2)
Query FindInvNum(type As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TCasherNo:%String:收费员工号,TCashier:%String:收费员,TInvNum:%String:张数,TInvNo:%String:发票号段")
{
}

ClassMethod FindInvNumExecute(ByRef qHandle As %Binary, type As %String, hospId As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    if (type="")  quit $$$OK
    
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

    set rowId=$o(^DHCJFRcptGroupSet(0,"Type",type,3,0))
    if (rowId="")  quit $$$OK
    
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", hospId)

	set sub=0
	while($o(^DHCJFRcptGroupSet(rowId,"Sub",sub))) {
		set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		set data=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
		continue:(data="")
		set hospDR=$p(data,"^",5)
		continue:(hospDR'=defHospId)
		set userDR=$p(data,"^",4)
		set userCode=$p($g(^SSU("SSUSR",userDR)),"^",1)
		set userName=$p($g(^SSU("SSUSR",userDR)),"^",2)
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		set rtnValue=..GetInvInfo(userDR, type, hospId)
		set invNum=$p(rtnValue,"^",1)
		continue:(+invNum=0)
		set invNo=$p(rtnValue,"^",2)
		do OutputInvNum
	}

	quit $$$OK
OutputInvNum
	set Data=$lb(userCode,userName,invNum,invNo)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","Findinvsum","O","2022-03-01","2022-04-08","","","^2")
Query Findinvsum(type As %String, stdate As %String, enddate As %String, stnum As %String, endnum As %String, Exp As %String, langId As %String = "") As websys.Query(ROWSPEC = "TCashier:%String:收费员,TCasherNo:%String:工号,TinvNum:%String:张数,TinvNo:%String:发票号段,Tinvsum:%Float:金额总计,Tinvnozf:%String:作废发票,Tinvnumzf:%String:作废张数,Tcurrno:%String:当前票号") [ SqlProc ]
{
}

ClassMethod FindinvsumExecute(ByRef qHandle As %Binary, type As %String, stdate As %String, enddate As %String, stnum As %String, endnum As %String, Exp As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    set ^TMP("Findinvsum")=$lb(type, stdate, enddate, stnum, endnum, Exp, langId)
    
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
    set enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	set InvTitle=$p(Exp,"^",1)
    set HospId=$p(Exp,"^",2)
    
    set invTotalNum=0
    set invTotalSum=0
    set AbortTotalNum=0
	set job=$j
    kill ^||TMP("INV",job)

    if ((stnum'="")&&(endnum'="")) {
		set StInv=stnum, EnInv=endnum
		if (type="O") {
			set InvLen=$l(EnInv)
		    for Inv=StInv:1:EnInv {
			    set PrtInv=##class(BILL.Util.Tools).FormatNO(Inv, InvLen)
			 	set PrtInv=InvTitle_PrtInv
			 	set PrtRowID=0
			 	while($o(^DHCINVPRT(0,"INV",PrtInv,PrtRowID))) {
				 	set PrtRowID=$o(^DHCINVPRT(0,"INV",PrtInv,PrtRowID))
					set prtData=$g(^DHCINVPRT(PrtRowID))
					continue:(prtData="")
				 	set hospDR=$p(prtData,"^",39)
				 	continue:(hospDR'=HospId)
				 	set PrtFlag=$p(prtData,"^",8)
				 	set Account=$p(prtData,"^",1)
				 	set InitInvDR=$p(prtData,"^",13)    //PRT_initInv_DR
				 	set UserDR=$p(prtData,"^",21)
				 	set ^||TMP("INV",job,UserDR,"NO",PrtInv)=""     //发票号
				 	set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
				 	set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				 	if (PrtFlag="A") {
					 	set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):PrtInv,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_PrtInv)) //作废发票
				 	}
				}
				//集中打印发票
				set AccPayInv=0
			 	while($o(^DHCINVPRTAPi(0,"INVNo",PrtInv,AccPayInv))) {
				 	set AccPayInv=$o(^DHCINVPRTAPi(0,"INVNo",PrtInv,AccPayInv))
					set prtData=$g(^DHCINVPRTAP(AccPayInv))
					continue:(prtData="")
				 	set hospDR=$p(prtData,"^",30)
				 	continue:(hospDR'=HospId)
				 	set PrtFlag=$p(prtData,"^",2)
				 	set Account=$p(prtData,"^",1)
				 	set InitInvDR=$p(prtData,"^",10)    //API_PayINV_DR
				 	set UserDR=$p(prtData,"^",5)
				 	set ^||TMP("INV",job,UserDR,"NO",PrtInv)=""     //发票号
				 	set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
				 	set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				 	if (PrtFlag="A") {
					 	set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):PrtInv,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_PrtInv)) //作废发票
				 	}
				}
		    }
		}
		if (type="I") {
			set InvLen=$l(EnInv)
		    for Inv=StInv:1:EnInv {
			    set PrtInv=##class(BILL.Util.Tools).FormatNO(Inv, InvLen)
			 	set PrtInv=InvTitle_PrtInv
			 	set PrtRowID=0
			 	while($o(^DHCINVPRTZY(0,"INV",PrtInv,PrtRowID))) {
				 	set PrtRowID=$o(^DHCINVPRTZY("0","INV",PrtInv,PrtRowID))
					set prtData=$g(^DHCINVPRTZY(PrtRowID))
				 	continue:(prtData="")
				 	set hospDR=$p(prtData,"^",35)
				 	continue:(hospDR'=HospId)
				 	set PrtFlag=$p(prtData,"^",8)
				 	set Account=$p(prtData,"^",6)
				 	set UserDR=$p(prtData,"^",7)
				 	set InitInvDR=$p(prtData,"^",13)    //PRT_initInv
				 	set ^||TMP("INV",job,UserDR,"NO",PrtInv)=""   //发票号
				 	set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
				 	set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				 	if (PrtFlag="A") {
					 	set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):PrtInv,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_PrtInv)) //作废发票
				 	}
				}
				
				//住院集中打印发票
				set spiRowId=0
			    while($o(^BILL.IP.SummaryPrtInvI("InvNo",PrtInv,spiRowId))) {
				    set spiRowId=$o(^BILL.IP.SummaryPrtInvI("InvNo",PrtInv,spiRowId))
				 	set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
				 	set hospDR=$lg(spiData,14)
				    continue:(hospDR'=HospId)
				    set UserDR=$lg(spiData,5)
				    set PrtFlag=$lg(spiData,6)
				    set InitInvDR=$p(spiData,"^",9)    //SPI_Init_DR
				    set prtRowId=##class(BILL.IP.BL.SummaryPrtInv).GetPrtRowIdStrBySPI(spiRowId)
				    set Account=$p($g(^DHCINVPRTZY(prtRowId)),"^",6)
				    set ^||TMP("INV",job,UserDR,"NO",PrtInv)=""   //发票号
				 	set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
				 	set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				    if (PrtFlag="A") {
					    set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):PrtInv,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_PrtInv)) //作废发票
				    }
				}
		    }
		}
	}else {
	    if (type="") quit $$$OK
		do ..getinvsum(type, stdate, enddate, job, HospId)
	}
	
    set userDR=""
    while($o(^||TMP("INV",job,userDR))) {
	    set userDR=$o(^||TMP("INV",job,userDR))
		set usrno=$p($g(^SSU("SSUSR",userDR)),"^",1)
		set usrname=$p($g(^SSU("SSUSR",userDR)),"^",2)
		set usrname=##class(User.SSUser).GetTranByDesc("SSUSRName", usrname, langId)
	    set invno=##class(web.DHCBillCommon).GetInvNoInfo("^||TMP", "INV", job, userDR, "NO")
	   	continue:(invno="")
	   	set invnum=+$g(^||TMP("INV",job,userDR,"USER",1))
	   	set invTotalNum=$i(invTotalNum,invnum)
	    set invsum=$g(^||TMP("INV",job,userDR,"USER",2))
	    set invTotalSum=$i(invTotalSum,invsum)
	    set AbortStr=$g(^||TMP("INV",job,userDR,"USER",4))
	    set AbortNum=+$g(^||TMP("INV",job,userDR,"USER",3))
	   	set AbortTotalNum=$i(AbortTotalNum, AbortNum)
	    //add hujunbin 15.2.4 当前票号
		set invinfo=..GetInvInfo(userDR, type, HospId)
		set currno=$p($p(invinfo,"^",2),"-",1)
	    do OutputRow9
	}

	kill ^||TMP("INV",job)
	
	//add hujunbin 15.2.4  合计、当前发票
    set usrname=##class(websys.Translation).Get("", "合计", langId)
    set usrno="",invno="",usrno="",AbortStr="",currno=""
 	set AbortNum=AbortTotalNum
    set invnum=invTotalNum,invsum=invTotalSum
    do OutputRow9
    
	quit $$$OK
OutputRow9
	set Data=$lb(usrname,usrno,invnum,invno,$fn(invsum,"",2),AbortStr,AbortNum,currno)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getinvsum(type, stdate, enddate, job, HospId) As %String
{
    if (type="I") {
	    for date=stdate:1:enddate {
		    set rowid=0
		    while($o(^DHCINVPRTZY(0,"DATE",date,rowid))) {
			    set rowid=$o(^DHCINVPRTZY(0,"DATE",date,rowid))
				set prtData=$g(^DHCINVPRTZY(rowid))
				set hospDR=$p(prtData,"^",35)
			 	continue:(hospDR'=HospId)
			    set UserDR=$p(prtData,"^",7)
			    set PrtFlag=$p(prtData,"^",8)
			    set Account=$p(prtData,"^",6)
			    set invNo=$p(prtData,"^",1)
			 	set InitInvDR=$p(prtData,"^",13)    //PRT_initInv
				set InitInvNo=invNo
			 	if ((InitInvNo="")&&(+InitInvDR'=0)) {
					set InitInvNo=$p(^DHCINVPRTZY(InitInvDR),"^",1)         //负记录不走号时取原记录发票号
		 		}
			 	if (invNo'="") {
					set ^||TMP("INV",job,UserDR,"NO",invNo)=""   //发票号
			 		set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
			 		set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				}
			 	if ((PrtFlag="A")&&(InitInvNo'="")) {
					if ((","_$g(^||TMP("INV",job,UserDR,"USER",4))_",")'[(","_InitInvNo_",")) {
						set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):InitInvNo,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_InitInvNo)) //作废发票
					}
			 	}
			}
		    
		    //住院集中打印发票 ShangXuehao
		    set spiRowId=0
		    while($o(^BILL.IP.SummaryPrtInvI("PrtDate",date,spiRowId))) {
			    set spiRowId=$o(^BILL.IP.SummaryPrtInvI("PrtDate",date,spiRowId))
			 	set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
			 	set hospDR=$lg(spiData,14)
			    continue:(hospDR'=HospId)
			    set UserDR=$lg(spiData,5)
			    set PrtFlag=$lg(spiData,6)
				set invNo=$lg(spiData,2)
			    set prtRowId=##class(BILL.IP.BL.SummaryPrtInv).GetPrtRowIdStrBySPI(spiRowId)
			    set Account=$p($g(^DHCINVPRTZY(prtRowId)),"^",6)
			    set InitInvDR=$p(spiData,"^",9)    //SPI_Init_DR
			    set InitInvNo=invNo
			    if ((InitInvNo="")&&(+InitInvDR'=0)) {
					set InitInvNo=$lg(^BILL.IP.SummaryPrtInvD(InitInvDR),2)          //负记录不走号时取原记录发票号
			    }
			    if (invNo'="") {
					set ^||TMP("INV",job,UserDR,"NO",invNo)=""   //发票号
			 		set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
					set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				}
			    if ((PrtFlag="A")&&(InitInvNo'="")) {
					if ((","_$g(^||TMP("INV",job,UserDR,"USER",4))_",")'[(","_InitInvNo_",")) {
						set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):InitInvNo,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_InitInvNo)) //作废发票
					}
			    }
			}
	    }
    }
    
    if (type="O") {
	    for date=stdate:1:enddate {
		    set rowid=0
		    while($o(^DHCINVPRT(0,"Date",date,rowid))) {
			    set rowid=$o(^DHCINVPRT(0,"Date",date,rowid))
			 	set prtData=$g(^DHCINVPRT(rowid))
			 	set hospDR=$p(prtData,"^",39)
			 	continue:(hospDR'=HospId)
			    set UserDR=$p(prtData,"^",21)
			    set PrtFlag=$p(prtData,"^",8)
			    set Account=$p(prtData,"^",1)
			    set invNo=$p(prtData,"^",14)
			    set InitInvDR=$p(prtData,"^",13)    //PRT_initInv_DR
			    if (invNo'="") {
					set ^||TMP("INV",job,UserDR,"NO",invNo)=""     //发票号
			 		set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
			 		set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				}
			 	if ((PrtFlag="A")&&(+InitInvDR'=0)) {
					set AbortInvNo=$s((invNo=""):$p($g(^DHCINVPRT(InitInvDR)),"^",14),1:invNo)
					if (AbortInvNo'="") {
						set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):AbortInvNo,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_AbortInvNo)) //作废发票
					}
			 	}
			}
			
			//集中打印发票
			set rowid=0
		 	while($o(^DHCINVPRTAPi(0,"Date",date,rowid))) {
			 	set rowid=$o(^DHCINVPRTAPi(0,"Date",date,rowid))
				set prtData=$g(^DHCINVPRTAP(rowid))
				continue:(prtData="")
			 	set hospDR=$p(prtData,"^",30)
			 	continue:(hospDR'=HospId)
			 	set PrtFlag=$p(prtData,"^",2)
			 	set Account=$p(prtData,"^",1)
			 	set InitInvDR=$p(prtData,"^",10)    //API_PayINV_DR
			 	set UserDR=$p(prtData,"^",5)
			 	set invNo=$p(prtData,"^",6)
			 	if (invNo'="") {
					set ^||TMP("INV",job,UserDR,"NO",invNo)=""     //发票号
			 		set ^||TMP("INV",job,UserDR,"USER",1)=$i(^||TMP("INV",job,UserDR,"USER",1))     //发票张数
			 		set ^||TMP("INV",job,UserDR,"USER",2)=$i(^||TMP("INV",job,UserDR,"USER",2), Account)
				}
			 	if ((PrtFlag="A")&&(+InitInvDR'=0)) {
					set AbortInvNo=$s((invNo=""):$p($g(^DHCINVPRTAP(InitInvDR)),"^",6),1:invNo)
					if (AbortInvNo'="") {
						set ^||TMP("INV",job,UserDR,"USER",3)=$i(^||TMP("INV",job,UserDR,"USER",3))     //作废张数
						set ^||TMP("INV",job,UserDR,"USER",4)=$s(('$d(^||TMP("INV",job,UserDR,"USER",4))):AbortInvNo,1:($g(^||TMP("INV",job,UserDR,"USER",4))_","_AbortInvNo)) //作废发票
					}
			 	}
			}
	    }
    }
    
    quit 0
}

/// 收款员发票退回财务科，对dhc_invoice表，将inv_finalflag置成No,将inv_reurnflag为Y,inv_returndate为日期，inv_returntime为时间
ClassMethod InsertRcptReturn(InvRowId As %String, hospId As %String) As %String
{
	//dhc_amtmag表插入记录，起始号码为dhc_invoice的当前号码，结束号码为dhc_invoice的结束号码
	//dhc_amtmag的amt_comment1为Return,amt_comment2为dhc_invoice的rowid
	set stno=$p(^DHCINVOICE(InvRowId),"^",1)
	set endno=$p(^DHCINVOICE(InvRowId),"^",2)
    set curno=$p(^DHCINVOICE(InvRowId),"^",6)
    set loc=$p(^DHCINVOICE(InvRowId),"^",8)
    set user=$p(^DHCINVOICE(InvRowId),"^",3)
    
    set $zt="ERROR^DHCSSERR"
    ts

    &SQL(
    	UPDATE DHC_INVOICE
    	SET INV_Finalflag = 'N', INV_returnflag = 'Y', INV_returndate = CONVERT(DATE, NOW()), INV_returntime = CONVERT(TIME, NOW())
    	WHERE %ID = :InvRowId
    )
    set rtn=SQLCODE
    if (+rtn) tro  quit rtn_"^"_$g(%msg)
    
    &SQL(
    	INSERT INTO DHC_AMTMAG (
    		finac_loc, finac_stnum, finac_ednum, finac_note, finac_avail,
    		finac_comment1, finac_comment2, finac_buyer, finac_hospital
    	)
   		VALUES (
   			:loc, :stno, :endno, :curno, 'Y',
   			'Return', :InvRowId, :user, :hospId
   		)
    )
    set rtn=SQLCODE
    if (+rtn) tro  quit rtn_"^"_$g(%msg)
    if ($tl>0) tc

    quit rtn
}

/// 发放给收费员的收据，收费员要确认审核后才能使用，同时要修改收费员取发票号的程序，增加确认标志
ClassMethod UpdateRcptConfirm(InvRowId As %String) As %String
{
	&SQL(
		UPDATE DHC_INVOICE
		SET INV_confirmflag = 'Y', INV_confirmdate = CONVERT(DATE, NOW()), INV_confirmtime = CONVERT(TIME, NOW())
		WHERE %ID = :InvRowId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
    quit rtn
}

/// 将退回的发票重新发放
ClassMethod UpdateRestore(BuyRowid As %String) As %String
{
	new (BuyRowid)
	set buyloc=$p(^DHCAMTMAG(BuyRowid),"^",2)
	set num=0
	set rowid=0
	while($o(^DHCAMTMAG(0,"L",buyloc,rowid))) {
		set rowid=$o(^DHCAMTMAG(0,"L",buyloc,rowid))
		set finalflag=$p(^DHCAMTMAG(rowid),"^",9)
		continue:(finalflag="N")
		set num=$i(num)
		quit
	}
	
	if (num=0) {
		&SQL(
			UPDATE DHC_AMTMAG SET finac_avail = 'Y', finac_comment1 = ''
			WHERE %ID = :BuyRowid
		)
	}else {
		&SQL(
			UPDATE DHC_AMTMAG SET finac_avail = '', finac_comment1 = ''
			WHERE %ID = :BuyRowid
		)
	}
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
    quit rtn
}

/// 修改收据的结束编号?将当前编号改为结束编号
/// 发票号自动减1
/// Debug: w ##class(web.UDHCJFInvprt).deliverinvupdate1("000345", 2)
ClassMethod deliverinvupdate1(invno As %String, invId As %String) As %String
{
	new (invno, invId)
	set ret=invno-1
	set ret=##class(BILL.Util.Tools).FormatNO(ret, $l(invno))
	&SQL(
		UPDATE DHC_INVOICE
		SET INV_EndInv = :ret
		WHERE %ID = :invId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
    quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-09-30
/// Description: 查询未使用的购入发票
/// Input: type:发票类型, hospId:CT_Hospital.RowID, userId: 购入人Id
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","FindInvBuyList", "O", 2)
Query FindInvBuyList(type As %String, hospId As %String, userId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String:ID,startNo:%String:开始号码,endNo:%String:结束号码,curNo:%String:当前号码,title:%String:开始字母,leftNum:%Integer:余票数,buyer:%String:购入人,buyDate:%String:购入日期,buyTime:%String:购入时间")
{
}

ClassMethod FindInvBuyListExecute(ByRef qHandle As %Binary, type As %String, hospId As %String, userId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (type="") quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set id=0
	while($o(^DHCAMTMAG(0,"L",type,id))) {
		set id=$o(^DHCAMTMAG(0,"L",type,id))
		set magData=$g(^DHCAMTMAG(id))
		set hospDR=$p(magData,"^",16)
		continue:(hospId'=hospDR)
		set useFlag=$p(magData,"^",9)
		continue:(useFlag="N")              //过滤已用完的
		set buyDate=$p(magData,"^",1)
		set buyDate=##class(websys.Conversions).DateLogicalToHtml(buyDate)
		set buyTime=$p(magData,"^",12)
		set buyTime=##class(websys.Conversions).TimeLogicalToHtml(buyTime)
		set userDR=$p(magData,"^",3)
		continue:(userId'="")&&(userId'=userDR)
		set buyer=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",2),1:"")
		set buyer=##class(User.SSUser).GetTranByDesc("SSUSRName", buyer, langId)
		set startNo=$p(magData,"^",5)
		set endNo=$p(magData,"^",6)
		set curNo=$p(magData,"^",10)
		set title=$p(magData,"^",13)
		set leftNum=+endNo-curNo+1
		do OutputInvBuyList
	}

	quit $$$OK

OutputInvBuyList
	set Data=$lb(id,startNo,endNo,curNo,title,leftNum,buyer,buyDate,buyTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-09-30
/// Description: 将购入发票"待用"更新为"可用"
/// Input: rowID: DHC_AMTMAG.RowID
/// Return: rtn, 0:更新成功, <>0 更新成功
/// Debug: w ##class(web.UDHCJFInvprt).UpdateAmtMagAvail()
ClassMethod UpdateAmtMagAvail(rowID As %String) As %String
{
	new (rowID)
	set rtn=0
	quit:(+rowID=0) rtn
	set avail=$p(^DHCAMTMAG(rowID),"^",9)
	quit:(avail'="") rtn
	&SQL(
		UPDATE DHC_AMTMAG
		SET finac_avail = 'Y'
		WHERE %ID = :rowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","FindInvType")
Query FindInvType(langId As %String = "") As websys.Query(ROWSPEC = "code:%String,text:%String")
{
}

ClassMethod FindInvTypeExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
 	set id=0
 	while($o(^DHCJFBILLADMREACON(id))) {
	 	set id=$o(^DHCJFBILLADMREACON(id))
	 	set data=$g(^DHCJFBILLADMREACON(id))
	 	continue:(data="")
		set code=$p(data,"^",3)
	 	set text=$p(data,"^",2)
	 	set text=##class(User.dhcjfbilladmreasonconfig).GetTranByDesc("ADMCONDesc", text, langId)
	 	do OutputInvType
	}
 	
	quit $$$OK
    
OutputInvType
	set Data=$lb(code,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-08-06
/// Description: 删除发票发放记录
/// Input: invId:DHC_INVOICE.RowId, hospId: CT_Hosptail.RowId
/// Return: =0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFInvprt).DeleteGrant("O", 2)
ClassMethod DeleteGrant(grantId As %String, hospId As %String) As %String
{
	new (grantId, hospId)
	set $zt="ERROR^DHCSSERR"
	set rtn=0
	
	&SQL(
		SELECT INV_type, INV_StartInv, INV_LastNum INTO :type, :stNo, :curNo
		FROM DHC_INVOICE
		WHERE %ID = :grantId
	)
	quit:(stNo'=curNo) -1_"^"_"该记录已使用，不能删除"
	
	&SQL(
		SELECT TOP 1 %ID INTO :maxId
		FROM DHC_INVOICE
		WHERE INV_type = :type AND INV_hospital = :hospId ORDER BY %ID DESC
	)
	quit:(maxId'=grantId) -1_"^"_"该记录不是最后一条记录，不能删除"
	
	ts
	
	&SQL(DELETE FROM DHC_INVOICE WHERE %ID = :grantId)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	set buyId=""
	set id=0
	while($o(^DHCAMTMAG(0,"L",type,id))&&(buyId="")) {
		set id=$o(^DHCAMTMAG(0,"L",type,id))
		set data=$g(^DHCAMTMAG(id))
		set hospDR=$p(data,"^",16)
		continue:(hospDR'=hospId)
		set myStNo=$p(data,"^",5)
		set myEndNo=$p(data,"^",6)
		continue:((myStNo>stNo) || (myEndNo<stNo))
		set buyId=id
	}
	if (buyId="") tro  quit -1_"^"_"没有找到符合的购入记录"
	
	&SQL(
		SELECT finac_avail INTO :useFlag
		FROM DHC_AMTMAG
		WHERE %ID = :buyId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if (useFlag="Y") {
		//可用
		&SQL(
			UPDATE DHC_AMTMAG
			SET finac_note = :stNo
			WHERE %ID = :buyId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	if (useFlag="N") {
		//已用完
		&SQL(
			UPDATE DHC_AMTMAG
			SET finac_note = :stNo, finac_avail = 'Y'
			WHERE %ID = :buyId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	if ($tl>0) tc
	
	quit rtn
}

/// add by zj 2022.11.14
/// 门诊、住院发票使用情况查询统计
/// Input: StartDate:开始日期(不能为空)
///        EndDate:结束日期(不能为空)
///        HospId:CT_Hospital.RowID(不能为空)
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","InvNoInfoReport","2022-11-01","2022-11-15","2","","DEP")
Query InvNoInfoReport(StartDate As %String, EndDate As %String, HospId As %String, UserId As %String, InvNoType As %String) As websys.Query(ROWSPEC = "TInvNoType:%String,TuserDR:%String,TuserCode:%String,TuserName:%String,TInvType:%String,TInvTypeDesc:%String,TNodeIndex:%String,TstartNo:%String,TendNo:%String,TAllInvNoNum:%Integer,TAllInvNoAmt:%Double,TNormalInvNoNum:%Integer,TNormalInvNoAmt:%Double,TAllRefundNum:%Integer,TAllRefundAmt:%Double,TParkInvNoNum:%Integer,TParkInvNoAmt:%Double,TParkInvNoStr:%String,TRefInvNoNum:%Integer,TRefInvNoAmt:%Double,TRefInvNoStr:%String,TVoidInvNoNum:%Integer,TVoidInvNoAmt:%Double,TVoidInvNoStr:%String") [ SqlProc ]
{
}

ClassMethod InvNoInfoReportExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospId As %String, UserId As %String, InvNoType As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    tro
    s ^TMP("InvNoInfoReport")=$lb(StartDate,EndDate,HospId,UserId,InvNoType)
	
	i InvNoType="" s InvNoType="IPINV,DEP,OPINV"
	s myInvNoType=""
	f i=1:1:$l(InvNoType,",") d
	.s myInvNoType=myInvNoType_$case(myInvNoType,"":"",:"、")_$case($p(InvNoType,",",i),"IPINV":"住院发票","DEP":"住院预交金","OPINV":"门诊发票",:$p(InvNoType,",",i))
    set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s:HospId=$c(0) HospId=""
    s:UserId=$c(0) UserId=""
    s job=$j
    b ; 000
    d ##class(web.UDHCJFInvprt).CollectInvNo(StartDate,EndDate,HospId,UserId,InvNoType,job)
    
    b ; 1
    s userDR="" f  s userDR=$o(^||TMP("BillInvNo",job,userDR)) q:userDR=""  d
    .s InvType="" f  s InvType=$o(^||TMP("BillInvNo",job,userDR,InvType)) q:InvType=""  d
    ..s INVInfo=##class(web.UDHCJFInvprt).RebuildInvNoInfo("^||TMP","BillInvNo",job,userDR,InvType)

	s userDR="" f  s userDR=$o(^||TMP("BillInvNoRebuild",job,userDR)) q:userDR=""  d
	.s userCode=$p($g(^SSU("SSUSR",userDR)),"^",1)
	.s userName=$p($g(^SSU("SSUSR",userDR)),"^",2)
    .s InvType="" f  s InvType=$o(^||TMP("BillInvNoRebuild",job,userDR,InvType)) q:InvType=""  d
	..s InvTypeDesc=$case(InvType,"IPINV":"住院发票","DEP":"住院预交金","OPINV":"门诊发票",:InvType)
    ..s NodeIndex="" f  s NodeIndex=$o(^||TMP("BillInvNoRebuild",job,userDR,InvType,NodeIndex)) q:NodeIndex=""  d
	...s InvNoRebInfo=$g(^||TMP("BillInvNoRebuild",job,userDR,InvType,NodeIndex))
	...s startNo=$p(InvNoRebInfo,"^",1)
	...s endNo=$p(InvNoRebInfo,"^",2)
	...s AllInvNoNum=+$p(InvNoRebInfo,"^",3)
	...s AllInvNoAmt=+$p(InvNoRebInfo,"^",4)
	...s NormalInvNoNum=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"N","Num"))
	...s NormalInvNoAmt=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"N","Amt"))
	...s ParkInvNoNum=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"A","Num"))
	...s ParkInvNoAmt=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"A","Amt"))
	...s ParkInvNoStr=$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"A","InvNo"))
	...s RefInvNoNum=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"S","Num"))
	...s RefInvNoAmt=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"S","Amt"))
	...s RefInvNoStr=$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"S","InvNo"))
	...s VoidInvNoNum=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"V","Num"))
	...s VoidInvNoAmt=+$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"V","Amt"))
	...s VoidInvNoStr=$g(^||TMP("BillInvNoRebuildSub",job,userDR,InvType,NodeIndex,"V","InvNo"))
	...; add by zj 2022.11.15
	...; 按照老系统的显示方式处理
	...s ParkInvNoAmt=0-ParkInvNoAmt
	...s RefInvNoAmt=0-RefInvNoAmt
	...s AllRefundNum=ParkInvNoNum+RefInvNoNum+VoidInvNoNum
	...s AllRefundAmt=ParkInvNoAmt+RefInvNoAmt+VoidInvNoAmt
    ...d OutputInvNo
	b ; 2
    quit $$$OK

OutputInvNo
    set data=$lb(myInvNoType,userDR,userCode,userName,InvType,InvTypeDesc,NodeIndex,startNo,endNo,AllInvNoNum,AllInvNoAmt,NormalInvNoNum,NormalInvNoAmt,AllRefundNum,AllRefundAmt,ParkInvNoNum,ParkInvNoAmt,ParkInvNoStr,RefInvNoNum,RefInvNoAmt,RefInvNoStr,VoidInvNoNum,VoidInvNoAmt,VoidInvNoStr)
    set ^CacheTemp(repid,ind)=data
    set ind=ind+1
    quit
}

// add by zj 2022.11.14

/// 发票号段查询汇总
/// d ##class(web.UDHCJFInvprt).CollectInvNo()
ClassMethod CollectInvNo(StDate, EndDate, HospId, UserId, InvNoType, job)
{
    n (StDate,EndDate,HospId,UserId,InvNoType,job)
    k ^||TMP("BillInvNo",job),^||TMP("BillInvNoPLUS",job),^||TMP("BillInvNoRebuild",job),^||TMP("BillInvNoRebuildSub",job)
    i '((InvNoType'="")&&('$lf($lfs(InvNoType,","),"OPINV")))  f Date=StDate:1:EndDate d
    .//门诊消费
    .s PrtRowId=0
    .f  s PrtRowId=$o(^DHCINVPRT(0,"Date",Date,PrtRowId)) q:(PrtRowId="")  d
    ..s PrtData=$g(^DHCINVPRT(PrtRowId))
    ..d SetOPInvNoInfo
    .//集中打印
    .s AccInv=0
    .f  s AccInv=$o(^DHCINVPRTAPi(0,"Date",Date,AccInv))  q:(AccInv="")  d
    ..d SetOPAPIInvNoInfo
    .//体检发票
    .s PEIRowID=0
    .f  s PEIRowID=$o(^DHCPEINVPRT(0,"DATE",Date,PEIRowID)) q:(PEIRowID="")  d
    ..d SetPEInvNoInfo

    //押金信息
    i '((InvNoType'="")&&('$lf($lfs(InvNoType,","),"DEP"))) for prtDate=StDate:1:EndDate do
    .set depRowId=0
    .for  set depRowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtDate,depRowId)) quit:(depRowId="")  do
    ..set depData=$g(^DHCSFPRINTDETAIL(depRowId))
    ..do SetDepNoInfo

    //发票信息
    i '((InvNoType'="")&&('$lf($lfs(InvNoType,","),"IPINV"))) for date=StDate:1:EndDate do
    .set invRowId=0
    .for  set invRowId=$o(^DHCINVPRTZY(0,"DATE",date,invRowId)) quit:(invRowId="")  do
    ..set invData=$g(^DHCINVPRTZY(invRowId))
    ..do SetIPInvNoInfo
    .//集中打印发票信息
    .set spiRowId=0
    .for  set spiRowId=$o(^BILL.IP.SummaryPrtInvI("PrtDate",date,spiRowId))  quit:(spiRowId="")  do
    ..set spiData=$g(^BILL.IP.SummaryPrtInvD(spiRowId))
    ..do SetSPINoInfo
    //跳号信息
    for voidDate=StDate:1:EndDate do
    .set voidId=0
    .for  set voidId=$o(^DHCVoidInv(0,"Date",voidDate,voidId)) quit:(voidId="")  do
    ..set voidData=$g(^DHCVoidInv(voidId))
    ..do SetVoidInfo
    
    quit

/// 设置门诊发票号
SetOPInvNoInfo
	d InitSet
	s userDR=$p(PrtData,"^",21)
    quit:(UserId'="")&&(userDR'=UserId)
    s myPrtUsr=$p(PrtData,"^",21)
    s HospDR=$p(PrtData,"^",39)
    q:((HospId'="")&&(HospId'=HospDR))
    s myFlag=$p(PrtData,"^",8)
    q:(myFlag="TP")
    s myHandin=$p(PrtData,"^",10)
    ;q:(myHandin="Y")
    s myTime=$p(PrtData,"^",20)
    s myPrintFlag=$p(PrtData,"^",3)
    //q:(myPrintFlag'="P")                                    //卡消费时是否打印发票

    s myInitInv=$p(PrtData,"^",13)
    s myPrtInvNo=$p(PrtData,"^",14)
    s myPrtAcount=$p(PrtData,"^",1)
    s InitInvNo=""

    i (myInitInv'="")  d
    .s InitInvNo=$p(^DHCINVPRT(myInitInv),"^",14)

    s Status=$s(myFlag="A":"PARK",myFlag="S":"REF",1:"NOR")
	s InvNoFlag=myFlag
    d ..SetTMPBillInvNoInfo(job, userDR, myPrtInvNo, InvNoFlag, InitInvNo, "OPINV", Status, myPrtAcount, "Y")

    quit

/// 设置门诊集中发票号
SetOPAPIInvNoInfo
	d InitSet
	s myPrtUsr=$p(^DHCINVPRTAP(AccInv),"^",5)                                         //API_PUser_DR
    s userDR=$p(^DHCINVPRTAP(AccInv),"^",5)                                            //API_PUser_DR
    quit:(UserId'="")&&(userDR'=UserId)
    s HospDR=$p(^DHCINVPRTAP(AccInv),"^",30)                                            //API_Hospital_DR
    q:((HospId'="")&&(HospId'=HospDR))
    s myHandin=$p(^DHCINVPRTAP(AccInv),"^",33)
    ;q:(myHandin="Y")
    s myRepDr=$p(^DHCINVPRTAP(AccInv),"^",20)
    ;q:(+myRepDr'=0)                                                                         //API_INVRep_DR
    s myTime=$p(^DHCINVPRTAP(AccInv),"^",4)
    //q:((Date=StDate)&&(myTime<StTime))
    ;q:((Date=EndDate)&&(myTime>EndTime))

    s Flag=$p(^DHCINVPRTAP(AccInv),"^",2)
    s myPrtInvNo=$p(^DHCINVPRTAP(AccInv),"^",6)
    s myPrtAcount=$p(^DHCINVPRTAP(AccInv),"^",1)
    s myInitInv=$p(^DHCINVPRTAP(AccInv),"^",10)
    s InitInvNo=""
    i (myInitInv'="")  d
    .s InitInvNo=$p(^DHCINVPRTAP(myInitInv),"^",6)

    s Status=$s(Flag="A":"PARK",Flag="S":"REF",1:"NOR")
	s InvNoFlag=Flag
    d ..SetTMPBillInvNoInfo(job, userDR, myPrtInvNo, InvNoFlag, InitInvNo, "OPINV", Status, myPrtAcount, "Y")
    
    quit

/// 设置体检发票号
SetPEInvNoInfo
	d InitSet
	s PEIData=$g(^DHCPEINVPRT(PEIRowID))
    s myPrtUsr=$p(PEIData,"^",10)
    s userDR=$p(PEIData,"^",10)
    quit:(UserId'="")&&(userDR'=UserId)
    s PEIRepDR=$p(PEIData,"^",13)
    ;q:(+PEIRepDR'=0)
    s HospDR=$p(PEIData,"^",26)
    q:((HospId'="")&&(HospId'=HospDR))
    s PEITime=$p(PEIData,"^",12)
    ;q:((Date=EndDate)&&(PEITime>EndTime))

    s PEBill=$p(PEIData,"^",3)
    s PEAdm=$p(PEIData,"^",2)
    s myPrtAcount=$p(PEIData,"^",7)
    s myInitInv=$p(PEIData,"^",9)
    s myPrtInvNo=$p(PEIData,"^",1)
    q:(myPrtInvNo["DHCPEYJS")    //过滤预结算记录
    s myFlag=$p(PEIData,"^",8)
    s InitInvNo=""
    i (myInitInv'="")  d
    .//先判断原票集中打印否
    .i $d(^User.DHCPEINVFocusPrtI("IFPINVDRIndex",myInitInv)) d
    ..s PEIFDr=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex",myInitInv,0))
    ..s InitInvNo=$lg(^User.DHCPEINVFocusPrtD(PEIFDr),3)
    .e  d
    .s InitInvNo=$p(^DHCPEINVPRT(myInitInv),"^",1)

    s Status=$s(myFlag="A":"PARK",myFlag="S":"REF",1:"NOR")
	s InvNoFlag=myFlag
    d ..SetTMPBillInvNoInfo(job, userDR, myPrtInvNo, InvNoFlag, InitInvNo, "OPINV", Status, myPrtAcount, "Y")

    quit

/// 设置体检集中打印票号
SetPEIFNoInfo
	d InitSet
    s myPrtInvNo=$lg(PEIFData,3)
	s InvNoFlag="N"
    d ..SetTMPBillInvNoInfo(job, userDR, myPrtInvNo, InvNoFlag, "", "OPINV", "")
    quit

/// 设置体检账户表打印票号
SetPEAPNoInfo
	d InitSet
    s SourceID=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",4)
    s myPrtInvNo=""
    //充值直接打印发票
    i (SourceID'="")&&((PEAPType="B")||(PEAPType="R"))&&($e(SourceID,1,3)'="DHC") d
    .s myPrtInvNo=SourceID
    
    //充值作废集中发票
    s InitInvNo=""
    i (SourceID'="")&&(PEAPType="RF") d
    .i $d(^User.DHCPEINVFocusPrtI("IFPINVDRIndex",SourceID)) d
    ..s PEIFDr=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_SourceID,""))
    ..s InitInvNo=$lg(^User.DHCPEINVFocusPrtD(PEIFDr),3)
    
    s Status=$s(InitInvNo'="":"REF",1:"NOR")
	s InvNoFlag=$s(InitInvNo'="":"S",1:"N")
    d ..SetTMPBillInvNoInfo(job, userDR, myPrtInvNo, InvNoFlag, InitInvNo, "OPINV", Status)

    quit

/// 设置住院押金票号
SetDepNoInfo
	d InitSet
	quit:(depData="")
    set reportDR=$p(depData,"^",30)
    ;quit:(+reportDR'=0)
    set userDR=$p(depData,"^",14)
    quit:(UserId'="")&&(userDR'=UserId)
    set prtTime=$p(depData,"^",3)
    ;quit:((prtDate=EndDate)&&(prtTime>endTime)&&(endTime'=""))
    set hospDR=$p(depData,"^",44)
    quit:(hospDR'=HospId)

    set rcptNo=$p(depData,"^",1)
    set depAmt=+$p(depData,"^",6)
    set prtStatus=$p(depData,"^",8)
    set initDepDR=$p(depData,"^",43)
    s initRcptNo=""
    if (+prtStatus=3) do
    .set initRcptNo=$s((rcptNo'=""):rcptNo,1:$p($g(^DHCSFPRINTDETAIL(initDepDR)),"^",1))   //红冲票据为空时, 取原票据号
    
    s Status=$s(
        ((+prtStatus=2)&&(+initDepDR=0)):"PARK",
        (+prtStatus=3):"REF",
        1:"NOR")
    s Amt=$s(
        (+prtStatus=3):$p($g(^DHCSFPRINTDETAIL(initDepDR)),"^",6),
        ((+prtStatus=2)&&(+initDepDR=0))||(" 1 4 "[(" "_prtStatus_" ")):depAmt,
        1:""
    )
	s InvNoFlag=$s((+prtStatus=2):"A",
        (+prtStatus=3):"S",
		(" 4 "[(" "_prtStatus_" ")):"S",
        1:"N")
    d ..SetTMPBillInvNoInfo(job, userDR, rcptNo, InvNoFlag, initRcptNo, "DEP", Status, Amt, "Y")
    
    quit
    
/// 设置住院发票号
SetIPInvNoInfo
	d InitSet
    set invNo=$p(invData,"^",1)
    set invAmt=+$p(invData,"^",6)
    set userDR=$p(invData,"^",7)
    quit:(UserId'="")&&(userDR'=UserId)
    set invFlag=$p(invData,"^",8)
    set initInvDR=$p(invData,"^",13)
    set initInvNo=invNo
    if ((initInvNo="")&&(+initInvDR'=0)) do
    .set initInvNo=$p(^DHCINVPRTZY(initInvDR),"^",1)          //负记录不走号时取原记录发票号
    s initInvAmt=""
    
    s Status=$s(
        ((invFlag="A")&&(+initInvDR=0)&&(initInvNo'="")):"PARK",
        ((invFlag="S")&&(+initInvDR'=0)&&(initInvNo'="")):"REF",
        1:"NOR")
    s Amt=$s(
        ((invFlag="S")&&(+initInvDR'=0)&&(initInvNo'="")):$p(^DHCINVPRTZY(initInvDR),"^",6),
        1:invAmt
    )
    ;w "住院发票号：",invNo,!
	s InvNoFlag=$s(
		invFlag="A":"A",
		$d(^DHCINVPRTZY(0,"InitInv",invRowId)):"S",
		1:invFlag
	)
    d ..SetTMPBillInvNoInfo(job, userDR, invNo, InvNoFlag, initInvNo, "IPINV", Status, Amt, "Y")

    quit

/// 设置住院集中打印发票号
SetSPINoInfo
	d InitSet
	quit:(spiData="")
    set userDR=$lg(spiData,5)
    quit:(UserId'="")&&(userDR'=UserId)
    set reportDR=$lg(spiData,13)
    ;quit:(+reportDR'=0)
    set spiTime=$lg(spiData,8)
    ;quit:((date=EndDate)&&(prtTime>endTime)&&(endTime'=""))
    set hospDR=$lg(spiData,14)
    quit:(hospDR'=HospId)

    set invNo=$lg(spiData,2)
    set invAmt=##class(web.DHCIPBillDailyDetails).GetSPInvSumByID(spiRowId) 
    set invFlag=$lg(spiData,6)
    set initInvDR=$lg(spiData,9)
    set initInvNo=invNo
    if ((initInvNo="")&&(+initInvDR'=0)) do
    .set initInvNo=$lg(^BILL.IP.SummaryPrtInvD(initInvDR),2)          //负记录不走号时取原记录发票号

    s Status=$s(
        ((invFlag="A")&&(+initInvDR=0)&&(initInvNo'="")):"PARK",
        ((invFlag="S")&&(+initInvDR'=0)&&(initInvNo'="")):"REF",
        1:"NOR")
    s Amt=$s(
        ((invFlag="S")&&(+initInvDR'=0)&&(initInvNo'="")):##class(web.DHCIPBillDailyDetails).GetSPInvSumByID(initInvDR),
        1:invAmt
    )
	s InvNoFlag=invFlag
    d ..SetTMPBillInvNoInfo(job, userDR, invNo, InvNoFlag, initInvNo, "IPINV", Status, Amt, "Y")

    quit

/// 设置跳号发票号(住院)
SetVoidInfo
	d InitSet
	quit:(voidData="")
    set userDR=$p(voidData,"^",5)
    quit:(UserId'="")&&(userDR'=UserId)
    set invType=$p(voidData,"^",11)
    ;quit:(invType'["I")
    set reportDR=$p(voidData,"^",6)
    ;quit:(+reportDR'=0)
    set voidTime=$p(voidData,"^",2)
    ;quit:((voidDate=EndDate)&&(voidTime>endTime)&&(endTime'=""))
    set hospDR=$p(voidData,"^",12)
    quit:(hospDR'=HospId)     //过滤院区

    set invNo=$p(voidData,"^",3)

    s Type=$s(
        (invType="IP"):"IPINV",
        (invType="ID"):"DEP",
        (invType["O"):"OPINV",
        1:""
    )
    q:(InvNoType'="")&&('$lf($lfs(InvNoType,","),Type))  
	s InvNoFlag="V"
	s initInvNo=invNo
    d ..SetTMPBillInvNoInfo(job, userDR, invNo, InvNoFlag, invNo, Type, "VOID")

    quit
InitSet
	s (userDR, invNo, InvNoFlag, initInvNo, Type, Status, Amt, AmtFlag)=""
	q
}

/// add by zj 2022.11.14
/// 统一赋值global，并规定标准化的Type（发票号类型）和Status（发票号状态）
/// Type："IPINV"、"DEP"、"OPINV"
/// Status："PARK"、"REF"、"NOR"、"VOID"
/// 所有票号输出号段、数量和金额，其他状态关联号段输出逗号分隔发票号串、数量和金额
/// w ##class(web.UDHCJFInvprt).SetTMPBillInvNoInfo(job, userDR, invNo, initInvNo, Type, Status, Amt, AmtFlag)
ClassMethod SetTMPBillInvNoInfo(job, userDR, invNo, InvNoFlag, initInvNo, Type, Status, Amt = "", AmtFlag = "N")
{
    n (job, userDR, invNo, InvNoFlag, initInvNo, Type, Status, Amt, AmtFlag)
        
    i (invNo'="") d
    .s ^||TMP("BillInvNo",job,userDR,Type,invNo)=InvNoFlag_"^"_Amt
    
    q
}

/// Creator: ZhYW
/// CreatDate: 2018-02-09
/// Description: 格式化发票号码
///              Global定义:^TMP(note1,note2,job,guser,no)
/// Input: global: global名称, note1:global第一个节点, note2:global第二个节点...
/// Return: 
/// Other: 规定前缀都是字母
/// Debug: w ##class(web.DHCBillCommon).GetInvNoInfo("^TMP", "IPBILL", 333, 222, "NORRCPTNO")
/// add by zj 2022.11.16
/// 参照 "##class(web.DHCBillCommon).GetInvNoInfo"方法，在格式化获取号段开始截止号的同时获取对应号段的发票记录集合中作废、红冲和跳号的相关数据并存入对应global中
/// w ##class(web.UDHCJFInvprt).RebuildInvNoInfo("^TMP", "IPBILL", 333, 222, "NORRCPTNO")
ClassMethod RebuildInvNoInfo(global As %String, note1 As %String, note2 As %String, note3 As %String, note4 As %String) As %String
{
	n (global,note1,note2,note3,note4)
	set invNoInfo=""
	set newFlag=0
	set startNo=""
	set endNo=""
	set num=0
	set NodeIndex=0
	s note5=note1_"Rebuild"
	s note6=note1_"RebuildSub"
	set myNo=0
	for  set myNo=$o(@global@(note1,note2,note3,note4,myNo)) quit:(myNo="")  do
	.set num=$i(num)
	.set invTmp=myNo
	.set myCurPrtNoLength=$l(myNo)
	.set myCurPreABCINfo=##class(web.DHCBillCommon).GetINVPreABCInfo(myNo)
	.set myCurPrePrtNo=$p(myCurPreABCINfo,"^",1)
	.set myCurPreABC=$p(myCurPreABCINfo,"^",2)
	.if ((num=1)||(newFlag=1))  do
	..set newFlag=0
	..set startNo=invTmp
	..set endNo=invTmp
	..set lenReceipNo=$l(startNo)
	..s NodeIndex=NodeIndex+1
	.s myInvFlag=$p($g(@global@(note1,note2,note3,note4,myNo)),"^",1)
	.s Amt=$p($g(@global@(note1,note2,note3,note4,myNo)),"^",2)
	.s $p(@global@(note5,note2,note3,note4,NodeIndex),"^",3)=$p($g(@global@(note5,note2,note3,note4,NodeIndex)),"^",3)+1
	.s $p(@global@(note5,note2,note3,note4,NodeIndex),"^",4)=$p($g(@global@(note5,note2,note3,note4,NodeIndex)),"^",4)+Amt

	.s @global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"Num")=$g(@global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"Num"))+1
	.s @global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"Amt")=$g(@global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"Amt"))+Amt	
	.i myInvFlag'="N" d
	..i $d(@global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"InvNo")) d
	...s @global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"InvNo")=@global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"InvNo")_","_myNo
	..e  d
	...s @global@(note6,note2,note3,note4,NodeIndex,myInvFlag,"InvNo")=myNo
	.set myNextPrtNo=$o(@global@(note1,note2,note3,note4,myNo))
	.set myNextPNoLength=$l(myNextPrtNo)
	.set myNextPreABCINfo=##class(web.DHCBillCommon).GetINVPreABCInfo(myNextPrtNo)
	.set myNextPrePrtNo=$p(myNextPreABCINfo,"^",1)
	.set myNextPreABC=$p(myNextPreABCINfo,"^",2)
	.//当前发票+1=下一个发票  说明在一个段，否则分段
	.if ((+myNextPrePrtNo=(+myCurPrePrtNo+1))&&(myNextPreABC=myCurPreABC)&&(+myNextPNoLength=+myCurPrtNoLength)) do
	.else  do
	..//下一个段
	..set endNo=myNo
	..if (invNoInfo="") do
	...set invNoInfo=startNo_"--"_endNo 
	..else  do
	...set invNoInfo=invNoInfo_",  "_startNo_"--"_endNo
	
	..s $p(@global@(note5,note2,note3,note4,NodeIndex),"^",1)=startNo
	..s $p(@global@(note5,note2,note3,note4,NodeIndex),"^",2)=endNo

	..set startNo="", endNo=""
	..set newFlag=1
	
	quit invNoInfo
}

/// 医院核销发票统计报表
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFInvprt","ConfirmInvprtQuery","2022-05-23","2022-08-16")
Query ConfirmInvprtQuery(startDate As %String, endDate As %String, userid As %String) As websys.Query(ROWSPEC = "ind,invType:%String,num:%String,startNo:%String,endNo:%String,StDate:%String,EndDate:%String,totalAmt:%Float,zfNum:%Integer,hcNum:%Integer,userName:%String") [ SqlProc ]
{
}

ClassMethod ConfirmInvprtQueryExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, userid As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if ((startDate="")||(endDate=""))  quit $$$OK
	set sDate=$zdh(startDate,3)
    set eDate=$zdh(endDate,3)
    
    for date=sDate:1:eDate  do
    .s conInvRowid=""
 	.f  s conInvRowid=$o(^DHCCONFIRMINVOICE(0,"Date",date,conInvRowid)) quit:(conInvRowid="")  do
	..s userDr=$p(^DHCCONFIRMINVOICE(conInvRowid),"^",4)
	..q:((userid'="")&&(userid'=userDr))
	..s userName=$p(^SSU("SSUSR",userDr),"^",2)
    ..s invRowid=$p(^DHCCONFIRMINVOICE(conInvRowid),"^",1)
    ..q:($p($g(^DHCINVOICE(invRowid)),"^",15)'="")
    ..s startNo=$p($g(^DHCINVOICE(invRowid)),"^",1)
	..s endNo=$p($g(^DHCINVOICE(invRowid)),"^",2)
    ..s invType=$p($g(^DHCINVOICE(invRowid)),"^",8)
    ..s invTitle=$p($g(^DHCINVOICE(invRowid)),"^",16)
    ..i invType="O" set invType="门诊"
    ..i invType="R" set invType="挂号"
    ..i invType="I" set invType="住院"
    ..s num=+endNo-(+startNo)+1
    ..s StDate="", EndDate=""
    ..i (startNo'="") d
   	...i $d(^DHCINVPRT(0,"INV",invTitle_startNo)) d
   	....s StPrtRowId=$o(^DHCINVPRT(0,"INV",invTitle_startNo,""))
   	....s StDate=$p(^DHCINVPRT(StPrtRowId),"^",5)
   	...e  i $d(^DHCINVPRTAPi(0,"INVNo",invTitle_startNo)) d
   	....s StPrtRowId=$o(^DHCINVPRTAPi(0,"INVNo",invTitle_startNo,""))
   	....s StDate=$p(^DHCINVPRTAP(StPrtRowId),"^",3)
   	...e  i $d(^DHCINVPRTZY(0,"INV",invTitle_startNo)) d
   	....s StPrtRowId=$o(^DHCINVPRTZY(0,"INV",invTitle_startNo,""))
   	....s StDate=$p(^DHCINVPRTZY(StPrtRowId),"^",2)
   	..i (endNo'="") d
   	...i $d(^DHCINVPRT(0,"INV",invTitle_endNo)) d
   	....s EndPrtRowId=$o(^DHCINVPRT(0,"INV",invTitle_endNo,""))
   	....s EndDate=$p(^DHCINVPRT(EndPrtRowId),"^",5)
   	...e  i $d(^DHCINVPRTAPi(0,"INVNo",invTitle_endNo)) d
   	....s EndPrtRowId=$o(^DHCINVPRTAPi(0,"INVNo",invTitle_endNo,""))
   	....s EndDate=$p(^DHCINVPRTAP(EndPrtRowId),"^",3)
   	...e  i $d(^DHCINVPRTZY(0,"INV",invTitle_endNo)) d
   	....s EndPrtRowId=$o(^DHCINVPRTZY(0,"INV",invTitle_endNo,""))
   	....s EndDate=$p(^DHCINVPRTZY(EndPrtRowId),"^",2)
   	..s StDate=##class(websys.Conversions).DateLogicalToHtml(StDate)
   	..s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
   	..s totalAmt=0
   	..s zfNum=0,hcNum=0
   	..s invLen=$l(startNo)
   	..f curNo=(+startNo):1:(+endNo) do
   	...s myNo=invTitle_""_##class(web.UDHCJFBaseCommon).FormatINVNO(curNo, invLen)
   	...i invType="住院" do
   	....s prt=$o(^DHCINVPRTZY(0,"INV",myNo,""))
   	....i (prt'="") do
   	.....s account=$p(^DHCINVPRTZY(prt),"^",6)
   	.....s flag=$p(^DHCINVPRTZY(prt),"^",8)
   	.....s totalAmt=totalAmt+account
   	.....s:flag="A" zfNum=zfNum+1
	.....s:flag="S" hcNum=hcNum+1
   	...e  do
   	....i $d(^DHCINVPRT(0,"INV",myNo)) d
   	.....s prt=$o(^DHCINVPRT(0,"INV",myNo,""))
   	.....i prt'="" d
   	......s account=$p(^DHCINVPRT(prt),"^",1)
   	......s totalAmt=totalAmt+account
   	......s flag=$p(^DHCINVPRT(prt),"^",8)
   	......s:flag="A" zfNum=zfNum+1
	......s:flag="S" hcNum=hcNum+1
	....e  i $d(^DHCINVPRTAPi(0,"INVNo",myNo)) d
	.....s prt=$o(^DHCINVPRTAPi(0,"INVNo",myNo,""))
	.....i (prt'="") d
	......s account=$p(^DHCINVPRTAP(prt),"^",1)
	......s totalAmt=totalAmt+account
	......s flag=$p(^DHCINVPRTAP(prt),"^",2)
	......s:flag="A" zfNum=zfNum+1
	......s:flag="S" hcNum=hcNum+1
   	..q:((startNo="")&&(endNo="")&&(StDate="")&&(EndDate=""))
    ..d ConfirmInvprtQuery

  	quit $$$OK

ConfirmInvprtQuery
	set Data=$lb(ind,invType,num,startNo,endNo,StDate,EndDate,totalAmt,zfNum,hcNum,userName)
    set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
