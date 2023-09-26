Class web.DHCOPCashReturnTicket Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 退票情况
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashReturnTicket","QryRefInvList","2022-04-25","2022-07-01","",2)
Query QryRefInvList(stDate As %String, endDate As %String, userId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "PrtRowId:%String:导航号,RefAcount:%Float:退费总额,RefDate:%String:退费日期,RefTime:%String:退费时间,InitInvNo:%String:原票据号,UserName:%String:操作员,RefundReason:%String:退费原因,HandinDate:%String:结账日期,HandinTime:%String:结账时间,RegNo:%String:登记号,PatName:%String:患者姓名,RefAuditUser:%String:审核人,RefAuditDate:%String:审核日期,RefAuditTime:%String:审核时间")
{
}

ClassMethod QryRefInvListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, userId As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((stDate="")||(endDate=""))  quit $$$OK
	set ^TMP("QryRefInvList")=$lb(stDate, endDate, userId, hospId, langId)
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	for date=stDate:1:endDate {
		set prtRowId=0
		while($o(^DHCINVPRT(0,"Date",date,prtRowId))) {
			set prtRowId=$o(^DHCINVPRT(0,"Date",date,prtRowId))
			set prtInvData=$g(^DHCINVPRT(prtRowId))
			set hospDR=$p(prtInvData,"^",39)
			continue:(hospId'=hospDR)
			set initInv=$p(prtInvData,"^",13)
			continue:(initInv="")
			set prtFlag=$p(prtInvData,"^",8)
			continue:(prtFlag="N")
			set fairType=$p(prtInvData,"^",34)
			continue:(fairType'="F")     //不需要R类型的
			set acount=$p(prtInvData,"^",1)
			set newPrtRowId=$o(^DHCINVPRT(0,"OldINV",initInv,0))
			set newPrtAcount=$s((+newPrtRowId'=0):$p($g(^DHCINVPRT(newPrtRowId)),"^",1),1:0)
			set refAcount=$zabs(acount+newPrtAcount)
			continue:(+refAcount=0)
			set refAcount=$fn(refAcount,"",2)
			set refDate=$p(prtInvData,"^",5)
			set refDate=##class(websys.Conversions).DateLogicalToHtml(refDate)
			set refTime=$p(prtInvData,"^",20)
			set refTime=##class(websys.Conversions).TimeLogicalToHtml(refTime)
			set initInvNo=$p(^DHCINVPRT(initInv),"^",14)
			set userDR=$p(prtInvData,"^",21)
			continue:((userId'="")&&(userId'=userDR))
			set userName=$s((userDR'=""):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
			set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
			set refReasonDR=$p(^DHCINVPRT(initInv),"^",32)
			set refundReason=$s((+refReasonDR'=0):$p($g(^DHCINVOPREFR(refReasonDR)),"^",2),1:"")
			set refundReason=##class(User.DHCINVOPRefReason).GetTranByDesc("IRRDesc", refundReason, langId)
			set handinDate=$p(prtInvData,"^",11)
			set handinDate=##class(websys.Conversions).DateLogicalToHtml(handinDate)
			set handinTime=$p(prtInvData,"^",12)
			set handinTime=##class(websys.Conversions).TimeLogicalToHtml(handinTime)
			set papmi=$p(prtInvData,"^",15)
			set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
			set patName=$p(^PAPER(papmi,"ALL"),"^",1)
			set refAuditDate=$p(^DHCINVPRT(initInv),"^",23)
			set refAuditDate=##class(websys.Conversions).DateLogicalToHtml(refAuditDate)
			set refAuditTime=$p(^DHCINVPRT(initInv),"^",24)
			set refAuditTime=##class(websys.Conversions).TimeLogicalToHtml(refAuditTime)
			set refAuditUserDR=$p(^DHCINVPRT(initInv),"^",25)
			set refAuditUser=$s((+refAuditUserDR'=0):$p($g(^SSU("SSUSR",refAuditUserDR)),"^",2),1:"")
			set refAuditUser=##class(User.SSUser).GetTranByDesc("SSUSRName", refAuditUser, langId)
			do OutputRefInfo
		}
	}
	
	quit $$$OK
OutputRefInfo
    set Data=$lb(initInv,refAcount,refDate,refTime,initInvNo,userName,refundReason,handinDate,handinTime,regNo,patName,refAuditUser,refAuditDate,refAuditTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: wangjian
/// Description: 退票明细
/// Modify: ZhYW
/// ModifyDate: 2020-05-18
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashReturnTicket","FindDetail","1278")
Query FindDetail(prtRowId As %String, langId As %String = "") As websys.Query(ROWSPEC = "ArcimDesc:%String:医嘱名称,RefUser:%String:操作员,RefDate:%String:退费日期,RefTime:%String:退费时间,RefOrdAmt:%Float:退费金额")
{
}

ClassMethod FindDetailExecute(ByRef qHandle As %Binary, prtRowId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (prtRowId="")  quit $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set strikeRowId=$o(^DHCINVPRT(0,"InitInvDR",prtRowId,0))   //负票
	set newPrtRowId=$o(^DHCINVPRT(0,"OldINV",prtRowId,0))      //新票
	if (+strikeRowId=0) quit $$$OK

	kill striOrdAry
	kill newOrdAry
	do GetOrdAry(strikeRowId, .striOrdAry)
	if (+newPrtRowId'=0) {
		do GetOrdAry(newPrtRowId, .newOrdAry)
	}
	set prtDate=$p(^DHCINVPRT(strikeRowId),"^",5)
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
	set prtTime=$p(^DHCINVPRT(strikeRowId),"^",20)
	set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
	set userDR=$p(^DHCINVPRT(strikeRowId),"^",21)
	set userName=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	
	set refTotalAmt=0
	set oeitm=""
	while($o(striOrdAry(oeitm))'="") {
		set oeitm=$o(striOrdAry(oeitm))
		set striOrdData=$g(striOrdAry(oeitm))
		set striOrdQty=$lg(striOrdData,1)
		set striOrdAmt=$lg(striOrdData,2)
		set newOrdData=$g(newOrdAry(oeitm))
		set newOrdQty=$lg(newOrdData,1)
		set newOrdAmt=$lg(newOrdData,2)
		set refOrdAmt=$zabs(striOrdAmt+newOrdAmt)
		continue:(+refOrdAmt=0)   //负票中医嘱数量等于新票中医嘱数量说明没有退费
		set refOrdAmt=$fn(refOrdAmt,"",2)
		set refTotalAmt=$i(refTotalAmt,refOrdAmt)
		set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
		set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
		set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
		do OutputDetail
	}
	
	set arcimDesc=##class(websys.Translation).Get("", "合计", langId)
	set (userName, prtDate, prtTime)=""
	set refOrdAmt=$fn(refTotalAmt,"",2)
	do OutputDetail
	
	quit $$$OK
GetOrdAry(prtId, ordAry)
	new (prtId, ordAry)
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtId,billConInv))
		set pb=$p(^DHCBCI(billConInv),"^",2)
		continue:(+pb=0)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set oeitm=$p(pboData,"^",4)
			set billQty=$p(pboData,"^",5)
			set refQty=$p(pboData,"^",6)
			set qty=billQty+refQty
			set totalAmt=$p(pboData,"^",8)
			set $li(ordAry(oeitm),1)=$lg($g(ordAry(oeitm)),1)+qty
			set $li(ordAry(oeitm),2)=$lg($g(ordAry(oeitm)),2)+totalAmt	
		}
	}
	quit
OutputDetail
    set Data=$lb(arcimDesc,userName,prtDate,prtTime,refOrdAmt)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: wangjian
/// Creatdate: 2012-03-31
/// Description: 智能报表工具打印退费明细
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashReturnTicket","FindReturnDetail","2011-11-11","2011-11-11")
Query FindReturnDetail(StDate, EndDate, LookUserid, LookUser) As websys.Query(ROWSPEC = "TPrtInv:%String,TPrtDate:%String,TPrtTime:%String,TPrtAcount:%Float,TPatName:%String,TReturnType:%String,PrtRowid:%String,TReAcount:%Float,TReDate:%String,TReTime:%String,TReBalance:%Float,TReInv:%String,TReitem:%String,TReqty:%String,TReSubamount:%String,Username:%String") [ SqlProc ]
{
}

ClassMethod FindReturnDetailExecute(ByRef qHandle As %Binary, StDate, EndDate, LookUserid, LookUser) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if (StDate="")||(EndDate="")  quit $$$OK
	
	s Userid=$g(LookUserid)
	s LookUser=$g(LookUser)
	i LookUser="" s Userid=""
	s Username=""
	i Userid'=""  s Username=$p($g(^SSU("SSUSR",Userid)),"^",2)
	i StDate["-" s StDate=$zdh(StDate,3)
	i StDate["/" s StDate=$zdh(StDate,4)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	k RetDetail("RetDetail","prtrowid","Taritem")
	f PrtDate=StDate:1:EndDate d
	.s PrtRowid=0
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",PrtDate,PrtRowid)) q:(PrtRowid="")  d
	..s PrtData=$g(^DHCINVPRT(PrtRowid))
	..s FairType=$p(PrtData,"^",34)
	..q:(FairType="R")        //不需要R类型的
	..s PrtAcount=$p(PrtData,"^",1)
	..s PrtFlag=$p(PrtData,"^",8)
	..s PrtUSRowId=$p(PrtData,"^",21)
	..q:((Userid'="")&&(PrtUSRowId'=Userid))
	..q:((PrtFlag="A")&&(PrtAcount>0))
	..q:((PrtFlag="S")&&(PrtAcount>0))
	..s PrtInitDr=$p(PrtData,"^",13)
	..s OldInvDr=$p(PrtData,"^",29)
	..s PrtDate=$p(PrtData,"^",5)
	..s PrtTime=$p(PrtData,"^",20)
	..s TReDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)   ;退费日期
	..s TReTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)   ;退费时间
	..s TReInv=$p(PrtData,"^",14) ;退票号
	..i (TReInv'="") s TReInv="退票"_TReInv
	..i ((PrtFlag="N")&&(OldInvDr'="")) d
	...s TReturnType="部分退费"
	...s OldInvData=$g(^DHCINVPRT(OldInvDr))
	...s TPrtInv=$p(OldInvData,"^",14)     ;最初发票号
	...s TPrtDate=##class(websys.Conversions).DateLogicalToHtml($p(OldInvData,"^",5))   ;最初发票日期
	...s TPrtTime=##class(websys.Conversions).TimeLogicalToHtml($p(OldInvData,"^",20))  ;最初发票时间
	...s TPrtAcount=$p(OldInvData,"^",1)   ;最初发票金额
	...s PapmiRowId=$p(OldInvData,"^",15)
	...s TPatName=$p(^PAPER(PapmiRowId,"ALL"),"^",1)  ;患者姓名
	...s TReAcount=PrtAcount-TPrtAcount  ;退费金额
	...q:(TReAcount=0)    ;作废从打
	...s TReBalance=PrtAcount   ;余额
	...d ..GetReturnTaritemDetail("", OldInvDr, PrtRowid)
	..i (PrtInitDr'="")&&('$d(^DHCINVPRT(0,"OldINV",PrtInitDr))) d
	...s TReturnType="全部退费"
	...s InitInvData=$g(^DHCINVPRT(PrtInitDr))
	...s TPrtInv=$p(InitInvData,"^",14)  ;最初发票号
	...s TPrtDate=##class(websys.Conversions).DateLogicalToHtml($p(InitInvData,"^",5))   ;最初发票日期
	...s TPrtTime=##class(websys.Conversions).TimeLogicalToHtml($p(InitInvData,"^",20))  ;最初发票时间
	...s TPrtAcount=$p(InitInvData,"^",1)  ;最初发票金额
	...s PapmiRowId=$p(InitInvData,"^",15)
	...s TPatName=$p(^PAPER(PapmiRowId,"ALL"),"^",1)  ;患者姓名
	...s TReAcount=PrtAcount   ;退费金额
	...s TReBalance=0.00       ;余额
	...d ..GetReturnTaritemDetail(PrtInitDr,"",PrtRowid)
	
	quit $$$OK
}

ClassMethod GetReturnTaritemDetail(PrtInitDr, OldInvDr, PrtRowid)
{
	k RetDetail("RetDetail","prtrowid","Taritem",PrtRowid)
	i (PrtInitDr'="") d
	.s DHCBCIRowid=0
	.f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",PrtRowid,DHCBCIRowid)) q:(DHCBCIRowid="")  d
	..s bill=$p(^DHCBCI(DHCBCIRowid),"^",2)
	..s TReSubamount=0
	..s ordsub=0
	..f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:(ordsub="")  d
    ...s detsub=0
	...f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:(detsub="")  d
	....s detData=$g(^DHCPB(bill,"O",ordsub,"D",detsub))
	....s taritemdr=$p(detData,"^",3)
    ....s TReitem=$p(^DHCTARI(taritemdr),"^",2)     ;收费项目
	....s TReqty=$p(detData,"^",5)         ;数量
	....s TReSubamount=$p(detData,"^",7)   ;总额
	....d OutputRow5
	i (OldInvDr'="") d
	.s DHCBCIRowid=0
	.f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",PrtRowid,DHCBCIRowid)) q:(DHCBCIRowid="")  d
	..s bill=$p(^DHCBCI(DHCBCIRowid),"^",2)
	..s ordsub=0
	..f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:(ordsub="")  d
	...s detsub=0
	...f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:(detsub="")  d
	....s detData=$g(^DHCPB(bill,"O",ordsub,"D",detsub))
	....s taritemdr=$p(detData,"^",3)
	....s RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,taritemdr,1)=$g(RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,taritemdr,1))+$p(detData,"^",5) ;数量
	....s RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,taritemdr,2)=$g(RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,taritemdr,2))+$p(detData,"^",7) ;总额
	.;中间那笔负数据
	.s myinit=$o(^DHCINVPRT(0,"InitInvDR",OldInvDr,""))
	.s OldDHCBCIRowid=0
	.f  s OldDHCBCIRowid=$o(^DHCBCI(0,"INV",myinit,OldDHCBCIRowid)) q:(OldDHCBCIRowid="")  d
	..s oldbill=$p(^DHCBCI(OldDHCBCIRowid),"^",2)
	..s oldordsub=0
	..f  s oldordsub=$o(^DHCPB(oldbill,"O",oldordsub)) q:(oldordsub="")  d
	...s olddetsub=0
	...f  s olddetsub=$o(^DHCPB(oldbill,"O",oldordsub,"D",olddetsub))  q:(olddetsub="")  d
	....s detData=$g(^DHCPB(oldbill,"O",oldordsub,"D",olddetsub))
	....s oldtaritemdr=$p(detData,"^",3)
	....s RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,oldtaritemdr,1)=$g(RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,oldtaritemdr,1))+$p(detData,"^",5)
	....s RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,oldtaritemdr,2)=$g(RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,oldtaritemdr,2))+$p(detData,"^",7)
	.//统计输出
	.s mytaritemdr=0
	.f  s mytaritemdr=$o(RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,mytaritemdr)) q:(mytaritemdr="")  d
    ..s TReitem=$p(^DHCTARI(mytaritemdr),"^",2)     ;收费项目
	..s TReqty=RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,mytaritemdr,1)         ;数量
	..q:(+TReqty=0)
	..s TReSubamount=RetDetail("RetDetail","prtrowid","Taritem",PrtRowid,mytaritemdr,2) ;总额	      
	..d OutputRow5
	quit
OutputRow5
	set Data=$lb(TPrtInv,TPrtDate,TPrtTime,TPrtAcount,TPatName,TReturnType,PrtRowid,TReAcount,TReDate,TReTime,TReBalance,TReInv,TReitem,TReqty,TReSubamount,Username)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: wangjian
/// Creatdate: 2012-04-01
/// Description: 智能报表工具打印退费汇总表
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashReturnTicket","FindReturnHZ","2015-07-02","2015-08-02")
Query FindReturnHZ(StDate, EndDate) As websys.Query(ROWSPEC = "TUsername:%String,TOPCateDesc:%String,TOPCateFee:%Float,Tflag:%String") [ SqlProc ]
{
}

ClassMethod FindReturnHZExecute(ByRef qHandle As %Binary, StDate, EndDate) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((StDate="")||(EndDate=""))  quit $$$OK
	
	i StDate["-" s StDate=$zdh(StDate,3)
	i StDate["/" s StDate=$zdh(StDate,4)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	k RetDetail("RetDetail","prtrowid","Taritem")
	k ReturnOutpatCate("ReturnHZ","User""TOC")
	f PrtDate=StDate:1:EndDate d
	.s PrtRowid=0
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",PrtDate,PrtRowid)) q:(PrtRowid="")  d
	..s PrtData=$g(^DHCINVPRT(PrtRowid))
	..s FairType=$p(PrtData,"^",34)
	..q:(FairType="R")     //不需要R类型的
	..s PrtAcount=$p(PrtData,"^",1)
	..s PrtFlag=$p(PrtData,"^",8)
	..s PrtUSRowId=$p(PrtData,"^",21)
	..q:((PrtFlag="A")&&(PrtAcount>0))
	..q:((PrtFlag="S")&&(PrtAcount>0))
	..s PrtInitDr=$p(PrtData,"^",13)
	..s OldInvDr=$p(PrtData,"^",29)
	..i ((PrtFlag="N")&&(OldInvDr'="")) d
	...//s TReturnType="部分退费"
	...s OldInvData=$g(^DHCINVPRT(OldInvDr))
	...s TPrtAcount=$p(OldInvData,"^",1)    ;最初发票金额
	...s TReAcount=PrtAcount-TPrtAcount     ;退费金额
	...q:(TReAcount=0)   ;作废从打
	...s TReBalance=PrtAcount ;余额
	...d ..GetReturnOutpatCate("", OldInvDr, PrtRowid, PrtUSRowId)
	..i (PrtInitDr'="")&&('$d(^DHCINVPRT(0,"OldINV",PrtInitDr))) d
	...//s TReturnType="全部退费"
	...d ..GetReturnOutpatCate(PrtInitDr, "", PrtRowid, PrtUSRowId)

	//统计输出
	s MyPrtuser=""
	f  s MyPrtuser=$o(ReturnOutpatCate("ReturnHZ","User""TOC",MyPrtuser)) q:(MyPrtuser="")  d
	.s TUsername=$p($g(^SSU("SSUSR",MyPrtuser)),"^",2)     ;收费员
	.s MyTotalAmt=0
	.s MyOutpatCate=""
	.f  s MyOutpatCate=$o(ReturnOutpatCate("ReturnHZ","User""TOC",MyPrtuser,MyOutpatCate)) q:(MyOutpatCate="")  d
	..s TOPCateFee=0-$g(ReturnOutpatCate("ReturnHZ","User""TOC",MyPrtuser,MyOutpatCate))
	..s TOPCateDesc=$p(^DHCTarC("TOC",MyOutpatCate),"^",2)
	..s flag=(TOPCateDesc["药")
	..q:(+TOPCateFee=0)
	..d OutputRow1
	k ReturnOutpatCate("ReturnHZ","User""TOC")

	quit $$$OK
OutputRow1
	set Data=$lb(TUsername,TOPCateDesc,TOPCateFee,flag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod GetReturnOutpatCate(PrtInitDr, OldInvDr, PrtRowid, PrtUSRowId)
{
	i (PrtInitDr'="")  d
	.s DHCBCIRowid=0
	.f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",PrtRowid,DHCBCIRowid)) q:(DHCBCIRowid="")  d
	..s bill=$p(^DHCBCI(DHCBCIRowid),"^",2)
	..s totalamount=0
	..s ordsub=0
	..f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:(ordsub="")  d
    ...s detsub=0
	...f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:(detsub="")  d
	....s detData=$g(^DHCPB(bill,"O",ordsub,"D",detsub))
	....s taritem=$p(detData,"^",3)
	....s totalamount=$p(detData,"^",7) ;总额
	....q:(taritem="")
	....s outpatcate=$p(^DHCTARI(taritem),"^",15)     ;门诊费用子分类         
	....q:(outpatcate="")
	....s outcate=$p(^DHCTarC("OC",outpatcate),"^",3) 
	....q:(outcate="")
	....s ReturnOutpatCate("ReturnHZ","User""TOC",PrtUSRowId,outcate)=$g(ReturnOutpatCate("ReturnHZ","User""TOC",PrtUSRowId,outcate))+totalamount
	i (OldInvDr'="") d
	.s DHCBCIRowid=0
	.f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",PrtRowid,DHCBCIRowid)) q:(DHCBCIRowid="")  d
	..s bill=$p(^DHCBCI(DHCBCIRowid),"^",2)
	..s totalamount=0
	..s ordsub=0
	..f  s ordsub=$o(^DHCPB(bill,"O",ordsub)) q:(ordsub="")  d
	...s detsub=0
	...f  s detsub=$o(^DHCPB(bill,"O",ordsub,"D",detsub))  q:(detsub="")  d
	....s detData=$g(^DHCPB(bill,"O",ordsub,"D",detsub))
	....s taritem=$p(detData,"^",3)
	....s totalamount=$p(detData,"^",7)          ;总额
	....q:(taritem="")
	....s outpatcate=$p(^DHCTARI(taritem),"^",15)     ;门诊费用子分类
	....q:(outpatcate="")
	....s outcate=$p(^DHCTarC("OC",outpatcate),"^",3) 
	....q:(outcate="")
	....s ReturnOutpatCate("ReturnHZ","User""TOC",PrtUSRowId,outcate)=$g(ReturnOutpatCate("ReturnHZ","User""TOC",PrtUSRowId,outcate))+totalamount
	.//中间那笔负数据
	.s myinit=$o(^DHCINVPRT(0,"InitInvDR",OldInvDr,""))
	.s OldDHCBCIRowid=0
	.f  s OldDHCBCIRowid=$o(^DHCBCI(0,"INV",myinit,OldDHCBCIRowid)) q:(OldDHCBCIRowid="")  d
	..s oldbill=$p(^DHCBCI(OldDHCBCIRowid),"^",2)
	..s totalamount=0
	..s oldordsub=0
	..f  s oldordsub=$o(^DHCPB(oldbill,"O",oldordsub)) q:(oldordsub="")  d
	...s olddetsub=0
	...f  s olddetsub=$o(^DHCPB(oldbill,"O",oldordsub,"D",olddetsub))  q:(olddetsub="")  d
	....s detData=$g(^DHCPB(oldbill,"O",oldordsub,"D",olddetsub))
	....s taritem=$p(detData,"^",3)
	....s totalamount=$p(detData,"^",7)
	....q:(taritem="")
	....s outpatcate=$p(^DHCTARI(taritem),"^",15)     ;门诊费用子分类
	....q:(outpatcate="")
	....s outcate=$p(^DHCTarC("OC",outpatcate),"^",3)
	....q:(outcate="")
	....s ReturnOutpatCate("ReturnHZ","User""TOC",PrtUSRowId,outcate)=$g(ReturnOutpatCate("ReturnHZ","User""TOC",PrtUSRowId,outcate))+totalamount
	
	q
}

}
