Import SQLUser

Class web.UDHCJFAcount Extends %RegisteredObject
{

ClassMethod getlastremain(stdate, flag, hospId)
{
	s stdate=stdate-1
	s lastremain=0
	s rowid=0
	f  s rowid=$o(^DHCJFYJACOUNT(0,"ENDDATE",stdate,rowid)) q:(rowid="")  d
	.s myFlag=$p(^DHCJFYJACOUNT(rowid),"^",9)
	.q:(myFlag'=flag)
	.s myHospDR=$p(^DHCJFYJACOUNT(rowid),"^",16) //wangjian 2018-10-15
	.q:(myHospDR'=hospId)
	.s lastremain=$p(^DHCJFYJACOUNT(rowid),"^",4)
	
	q lastremain
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFAcount","FindYjAcount",62087,"",62088,"",7018)
Query FindYjAcount(stdate As %String, sttime As %String, enddate As %String, endtime As %String, hospId As %String = "", jsflag As %String = "") As websys.Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String,Tjob:%String,Tshdate:%String,Tshtime:%String")
{
}

ClassMethod FindYjAcountExecute(ByRef qHandle As %Binary, stdate As %String, sttime As %String, enddate As %String, endtime As %String, hospId As %String = "", jsflag As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (stdate="") quit $$$OK
	
	set ^TMP("FindYjAcount")=$lb(stdate, sttime, enddate, endtime, hospId, jsflag)
	
	set stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	set enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	set sttime=##class(websys.Conversions).TimeHtmlToLogical(sttime,1)
	set endtime=##class(websys.Conversions).TimeHtmlToLogical(endtime,1)
	
    kill ^TMP("ZYJF","YJACOUNT",$j)
    kill ^TMP("ZYJF","YJACOUNTHZ",$j)
    kill ^TMP("ZYJF","YJACOUNTPM",$j)
    kill ^TMP("ZYJF","YJACOUNTSTR",$j)
    kill YJAcountPM
    set dfsum=0, jfsum=0
    
    //wangjian 2019-01-14 界面勾选历史 控制结束日期不查未结算日期的
    if (jsflag=1) do
    .set HistoryInfo=..getlastAcctInfo("YJACOUNT", hospId)
    .set TMPEndDate=$p(HistoryInfo,"^",1)
    .if (TMPEndDate'="") do
    ..set TMPEndDate=##class(websys.Conversions).DateHtmlToLogical(TMPEndDate)
    ..if (+enddate>+TMPEndDate) set enddate=TMPEndDate

	set sttime=0, endtime="86399"
	set yjremain=..getlastremain(stdate, "YJACOUNT", hospId)
	set date="日期", patstr="摘要", jfamount="借方", dfamount="贷方", jd="借/贷", remain="余额"
	set ^TMP("ZYJF","YJACOUNT",$j,ind)=date_"^"_patstr_"^"_jfamount_"^"_dfamount_"^"_jd_"^"_remain
	set ^TMP("ZYJF","YJACOUNTHZ",$j,"QCRemain")=yjremain ;上期余额
	
	set ind=ind+1
	set date="", patstr="上期结转", jfamount="", dfamount="", jd="贷", remain=yjremain, shdate="", shtime=""
	do OutputYjAcount
	
	for prtdate=stdate:1:enddate do
	.;set jkid=0
	.;for  set jkid=$o(^DHCJFUSERJK(0,"date",prtdate,jkid))  quit:(jkid="")  do
	.set prtrowid=0
	.for  set prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) quit:(prtrowid="")  do 
	..;for  set prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkid,prtrowid))  quit:(prtrowid="")  do
	..set depInfo=$g(^DHCSFPRINTDETAIL(prtrowid))
	..quit:(depInfo="")
	..set depTypeDr=$p(depInfo,"^",13)
	..set depTypeCode=$s((+depTypeDr'=0):$p($g(^ARC("ARCDT",depTypeDr)),"^",1),1:"")
	..quit:(depTypeCode'="01")
	..set myHospDR=$p(depInfo,"^",44)    //wangjian 2018-10-15
	..quit:(myHospDR'=hospId)
	..set prtuser=$p(depInfo,"^",14)
	..set printdate=$p(depInfo,"^",2)
	..set prttime=$p(depInfo,"^",3)
	..set prtstatus=$p(depInfo,"^",8)
	..quit:(+prtstatus=2)
	..set admDR=$p(depInfo,"^",4)
	..quit:'$d(^PAADM(admDR))
	..set prtpaymode=$p(depInfo,"^",9)
	..set admvisitstatus=$p(^PAADM(admDR),"^",20)
	..set admloc=$p(^PAADM(admDR),"^",70)
	..if (admloc'="") set admloc=$p(^PAWARD(admloc),"^",2)
	..if (admloc["-") set admloc=$p(admloc,"-",2)
	..set papmi=$p(^PAADM(admDR),"^",1)
	..set papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..set papname=$p(^PAPER(papmi,"ALL"),"^",1)
	..set prtDate=printdate
	..set printdate=##class(websys.Conversions).DateLogicalToHtml(printdate)
	..set printtime=##class(websys.Conversions).TimeLogicalToHtml(prttime)
	..set payamount=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	..set arrcprowid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",5)
	..set shstr=..getshdate(arrcprowid)
	..set shdate=$p(shstr,"^",1)
	..set shtime=$p(shstr,"^",2)
	..set date=printdate_" "_printtime
	..set patstr=papno_" "_papname_" "_admloc
	..if (" 1 3 4 "[(" "_prtstatus_" ")) do
	...set jfamount="", dfamount=payamount, dfsum=dfsum+payamount
    ...set YJAcountPM(prtpaymode,"DF")=+$g(YJAcountPM(prtpaymode,"DF"))+payamount
	..;if (prtstatus=3) do
	...;set dfamount="", jfamount=0-payamount, jfsum=jfsum-payamount, jfamount=$j(jfamount,3,2)
    ...;set YJAcountPM(prtpaymode,"JF")=+$g(YJAcountPM(prtpaymode,"JF"))+payamount
    ..set remain=""
    ..;set ^TMP("ZYJF","YJACOUNT",$j,ind)=date_"^"_patstr_"^"_jfamount_"^"_dfamount_"^"_""_"^"_remain
    ..do OutputYjAcount
    .set prtrowid=0
	.for  set prtrowid=$o(^DHCINVPRTZY(0,"DATE",prtdate,prtrowid)) quit:(prtrowid="")  do
	..;for  set prtrowid=$o(^DHCINVPRTZY(0,"JK",jkid,prtrowid))  quit:(prtrowid="")  do
	..set invInfo=$g(^DHCINVPRTZY(prtrowid))
	..set prtuser=$p(invInfo,"^",7)
	..set myHospDR=$p(invInfo,"^",35)  //wangjian 2018-10-15
	..quit:(myHospDR'=hospId)
	..set prtstatus=$p(invInfo,"^",8)
	..quit:(prtstatus="A")
	..set admDR=$p(invInfo,"^",4)
	..quit:'$d(^PAADM(admDR))
	..set admloc=$p(^PAADM(admDR),"^",4)
	..if (admloc'="") set admloc=$p(^CTLOC(admloc),"^",2)
	..set papmi=$p(^PAADM(admDR),"^",1)
	..set papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..set papname=$p(^PAPER(papmi,"ALL"),"^",1)
	..set billno=$p(invInfo,"^",5) 
	..set printdate=$p(invInfo,"^",2)
	..set prtDate=printdate
	..set printdate=##class(websys.Conversions).DateLogicalToHtml(printdate)
	..set prttime=$p(invInfo,"^",3)
	..set printtime=##class(websys.Conversions).TimeLogicalToHtml(prttime)
	..set date=printdate_" "_printtime
	..set patstr=papno_" "_papname_" "_admloc
	..set arpbl=+$p(invInfo,"^",5)
	..set shdate="", shtime=""
	..set jfamount=0
	..set conId=0
	..for  set conId=$o(^DHCINVPRTZYCONDEPi(0,"Inv",prtrowid,conId)) quit:(conId="")  do
	...set conData=$g(^DHCINVPRTZYCONDEP(conId))
	...quit:(conData="")
	...set depId=$p(conData,"^",3)
	...set yjprtstatus=$p(conData,"^",4)
	...set depData=$g(^DHCSFPRINTDETAIL(depId))
	...set payamount=$p(depData,"^",6)
	...;set yjprtstatus=$p(depData,"^",8)
	...quit:(+yjprtstatus=2)
	...if (prtstatus="S") set payamount=0-payamount
  	...set jfamount=jfamount+payamount, jfsum=jfsum+payamount
	...set prtpaymode=$p(depData,"^",9)
	...set YJAcountPM(prtpaymode,"JF")=+$g(YJAcountPM(prtpaymode,"JF"))+payamount
	...set dfamount=""
  	...set remain=""
  	..if (jfamount'=0) do
	...do OutputYjAcount

    set jd=$s((jfsum>dfsum):"借",1:"贷")
    set prtDate=""
    set date="", patstr="期末余额", jfamount=jfsum, dfamount=dfsum, remain=yjremain+dfsum-jfsum, shdate="", shtime=""
	set ^TMP("ZYJF","YJACOUNTHZ",$j,"QMRemain")=jfsum_"^"_dfsum_"^"_remain ;期末余额
	do OutputYjAcount
	
    //计算JFAcountPM子表数据,当天有收退预交金
   	set Rowid=0, count=1, PMStr=""
   	for  set Rowid=$o(YJAcountPM(Rowid)) quit:(Rowid="")  do
   	.set lastremain=..GetPMAcount(stdate, "YJACOUNT", hospId, Rowid)
   	.set JFSum=+$g(YJAcountPM(Rowid,"JF"))
   	.set DFSum=+$g(YJAcountPM(Rowid,"DF"))
   	.set curremain=lastremain+DFSum-JFSum
   	.set ^TMP("ZYJF","YJACOUNTPM",$j,count)=Rowid_"^"_lastremain_"^"_JFSum_"^"_DFSum_"^"_curremain_"^"_$j
    .set count=count+1
    .if (PMStr="") set PMStr="^"_Rowid_"^"
    .else  set PMStr=PMStr_"^"_Rowid_"^"
    
    //当天无收退预交金，将上一次金额写进来,或者，前一日支付方式比今日多的时候也需要走
    do ..GetLastPMAmtInfo(stdate, "YJACOUNT", hospId, count, PMStr)
	set YJStr=""
	for prtdate=stdate:1:enddate do
	.set YJRowid=0
	.for  set YJRowid=$o(^DHCJFYJACOUNT(0,"ENDDATE",prtdate,YJRowid)) quit:(YJRowid="")  do
	..set Flag=$p(^DHCJFYJACOUNT(YJRowid),"^",9)
	..quit:(Flag'="YJACOUNT")
	..if (YJStr="") set YJStr=YJRowid
	..else  set YJStr=YJStr_"^"_YJRowid
	set ^TMP("ZYJF","YJACOUNTSTR",$j)=YJStr

	quit $$$OK
OutputYjAcount
	set ^TMP("ZYJF","YJACOUNT",$j,ind)=date_"^"_patstr_"^"_jfamount_"^"_dfamount_"^"_jd_"^"_remain
    if $g(prtDate)'="" do
    .set ^TMP("ZYJF","YJACOUNTHZ",$j,prtDate,"JFAmt")=+$g(^TMP("ZYJF","YJACOUNTHZ",$j,prtDate,"JFAmt"))+(+jfamount)
    .set ^TMP("ZYJF","YJACOUNTHZ",$j,prtDate,"DFAmt")=+$g(^TMP("ZYJF","YJACOUNTHZ",$j,prtDate,"DFAmt"))+(+dfamount)
    set jfamount=$fn(jfamount,"",2), dfamount=$fn(dfamount,"",2), remain=$fn(remain,"",2)
	set Data=$lb(date,patstr,jfamount,dfamount,jd,remain,$j,shdate,shtime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindQFAcount(stdate, sttime, enddate, endtime) As websys.Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String,Tjob:%String")
{
}

ClassMethod FindQFAcountExecute(ByRef qHandle As %Binary, stdate, sttime, enddate, endtime) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
    if (stdate="")  quit $$$OK
    
    k ^TMP("ZYJF","QFACOUNT",$j)
    s dfsum=0,jfsum=0
    s job=$j
    s jd=""
    s date="日期",patstr="摘要",jfamount="借方",dfamount="贷方",jd="借/贷",remain="余额"
	d OutputQFAcount
	s yjremain=..getlastremain(stdate, "QFACOUNT")
	s date="",patstr="上期结转",jfamount="",dfamount="",jd="借",remain=yjremain
	d OutputQFAcount
	f prtdate=stdate:1:enddate d
	.s rowid=0
	.f  s rowid=$o(^DHCJFQFTOTAL(0,"Date",prtdate,rowid)) q:(rowid="")  d
	..s admDR=$p(^DHCJFQFTOTAL(rowid),"^",1)
    ..q:(admDR="")
	..q:'$d(^PAADM(admDR))
	..s admloc=$p(^PAADM(admDR),"^",70)
	..i (admloc'="") s admloc=$p(^PAWARD(admloc),"^",2)
	..s admloc=$p(admloc,"-",2)
	..s papmi=$p(^PAADM(admDR),"^",1)
	..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s name=$p(^PAPER(papmi,"ALL"),"^",1)
	..s time=$p(^DHCJFQFTOTAL(rowid),"^",3)
	..s date=$zd(prtdate,3)_" "_$zt(time,1)
	..s patstr=papno_" "_name_" "_admloc
	..s amount=$p(^DHCJFQFTOTAL(rowid),"^",4)
	..s flag=$p(^DHCJFQFTOTAL(rowid),"^",5)
	..i (flag="Q") d
	...s jfamount=amount, jfsum=jfsum+amount, dfamount=""
	..i (flag="B") d
	...s dfamount=amount, dfsum=dfsum+amount, jfamount=""
    ..s jd="", remain=""
    ..d OutputQFAcount
    s date="",patstr="期末余额",jfamount=$fn(jfsum,"",2),dfamount=$fn(dfsum,"",2),jd="借",remain=$fn(yjremain-dfsum+jfsum,3,2)
    d OutputQFAcount
    s ^TMP("ZYJF","QFACOUNT",$j,ind)=$zd(stdate,3,)_"^"_$zt(sttime,1)_"^"_$zd(enddate,3)_"^"_$zt(endtime,1)

	quit $$$OK
OutputQFAcount
    set ^TMP("ZYJF","QFACOUNT",$j,ind)=date_"^"_patstr_"^"_jfamount_"^"_dfamount_"^"_jd_"^"_remain
	set Data=$lb(date,patstr,jfamount,dfamount,jd,remain,job)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// w ##class(web.UDHCJFAcount).InsertRemain("12173","YJACOUNT","12072","2","2021-03-01^2021-03-01")
ClassMethod InsertRemain(adduser As %String, flag As %String, job As %String, hospId As %String, AcctInfo As %String) As %String [ ProcedureBlock = 0 ]
{
	set ^TMP("InsertRemain")=$lb(adduser, flag, job, hospId, AcctInfo)
	if (hospId="") {
		set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(adduser)
	}
	
	set stdate=$p(AcctInfo,"^",1)
	set sttime="00:00:00"
	set enddate=$p(AcctInfo,"^",2)
	set endtime="23:59:59"

	set stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	set enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	set sttime=##class(websys.Conversions).TimeHtmlToLogical(sttime, 1)
	set endtime=##class(websys.Conversions).TimeHtmlToLogical(endtime, 1)
	
	set acMaxIdx=$o(^TMP("ZYJF",flag,job,""),-1)
	set acData=$g(^TMP("ZYJF",flag,job,acMaxIdx))
	set jfsum=$p(acData,"^",3)
	set dfsum=$p(acData,"^",4)
	set curremain=$p(acData,"^",6)
	quit:(+jfsum=0)&&(+dfsum=0)&&(+curremain=0) 0
	
	set rtn=0
	set adddate=+$h
	set addtime=$p($h,",",2)

	set lastremain=..getlastremain(stdate, flag, hospId)
	
	ts

	kill PLIST
	set PLIST(2)=lastremain      //Acct_lastremain
	set PLIST(3)=jfsum           //Acct_jfsum
	set PLIST(4)=dfsum           //Acct_dfsum
	set PLIST(5)=curremain       //Acct_curremain
	set PLIST(6)=stdate          //Acct_stdate
	set PLIST(7)=enddate         //Acct_enddate
	set PLIST(8)=adduser         //Acct_adduser
	set PLIST(9)=adddate         //Acct_adddate
	set PLIST(10)=flag           //Acct_flag
	set PLIST(12)=sttime         //Acct_sttime
	set PLIST(13)=endtime        //Acct_endtime
	set PLIST(14)=addtime        //Acct_addtime
	set PLIST(17)=hospId         //Acct_Hospital_dr
	&SQL(INSERT INTO Dhc_JFYJAcount VALUES PLIST())
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn
	
	set jkRowId=$g(%ROWID)
	if (flag="YJACOUNT") {
		//插入DHC_IPBillDeptAcountDetail
		set rtnValue=##class(web.DHCIPBillDeptAcountDetail).InsertYJAcountSub(jkRowId, "Date", hospId)
		set rtn=+rtnValue
		if (+rtn) tro  quit rtn
		//插入DHC_JFYJAcountPaym
		set pmMaxIdx=$o(^TMP("ZYJF","YJACOUNTPM",job,""),-1)
		for i=1:1:pmMaxIdx {
			set pmData=$g(^TMP("ZYJF","YJACOUNTPM",job,i))
			set paymDR=$p(pmData,"^",1)
			set lastremain=$p(pmData,"^",2)
			set jfsum=$p(pmData,"^",3)
			set dfsum=$p(pmData,"^",4)
			set curremain=$p(pmData,"^",5)
			kill PLIST
			set PLIST(0)=jkRowId
			set PLIST(3)=paymDR
			set PLIST(4)=lastremain
			set PLIST(5)=jfsum
			set PLIST(6)=dfsum
			set PLIST(7)=curremain
			&SQL(INSERT INTO DHC_JFYJAcountPaym VALUES PLIST())
			set rtn=SQLCODE
			quit:(+rtn)
		}
	}
	if (+rtn) tro  quit rtn
	
	tc
	
	quit rtn
}

/// w ##class(web.UDHCJFAcount).getstdate("YJACOUNT","3")
ClassMethod getstdate(flag As %String, hospId As %String = "") As %String
{
	s stdate=+$h-1
	s rowid=""
	//2018-10-15 wangjian 加入院区
	s lastrowid=""
	f  s lastrowid=$o(^DHCJFYJACOUNT(0,"Flag",flag,lastrowid),-1) q:((rowid'="")||(lastrowid=""))  d
	.s lastHospDR=$p(^DHCJFYJACOUNT(lastrowid),"^",16)
	.q:((lastHospDR'=hospId)&&(hospId'=""))
	.s rowid=lastrowid
	
	i (rowid'="") d
	.s enddate=$p(^DHCJFYJACOUNT(rowid),"^",6)
	.s stdate=enddate+1
	e  d
	.s PrtRowID=$o(^DHCSFPRINTDETAIL("0"))
	.i (PrtRowID'="") s stdate=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",2)
	
    i (stdate="") s stdate=+$h-1
 	i (stdate'="") s stdate=##class(websys.Conversions).DateLogicalToHtml(stdate)
	q stdate
}

/// w ##class(web.UDHCJFAcount).JudgeDate("YJACOUNT","09/02/2017","07/03/2017")
ClassMethod JudgeDate(flag As %String, stDate As %String, endDate As %String, hospId As %String) As %String
{
	s ^TMP("JudgeDate")=$lb(flag, stDate, endDate, hospId)
    s stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
    s endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s err=0
	i (stDate>endDate) s err=-1
	i (endDate>=+$h) s err=-2
	
	s acctRowId=""
	s adddate="", jsflag="", jsstdate="", jsenddate=""
	
	s rowid=""
	f  s rowid=$o(^DHCJFYJACOUNT(0,"Flag",flag,rowid),-1) q:((rowid="")||(+acctRowId'=0))  d
	.s myHospDR=$p(^DHCJFYJACOUNT(rowid),"^",16)  //wangjian 2018-10-15
	.q:(myHospDR'=hospId)
	.s acctRowId=rowid
	
	i (acctRowId'="") d
	.s jsstdate=$p(^DHCJFYJACOUNT(acctRowId),"^",5)
	.s jsenddate=$p(^DHCJFYJACOUNT(acctRowId),"^",6)
	.s adddate=$p(^DHCJFYJACOUNT(acctRowId),"^",8)
	.i (stDate'>jsenddate) d
	..s jsflag="Y"
	.s jsstdate=##class(websys.Conversions).DateLogicalToHtml(jsstdate)
	.s jsenddate=##class(websys.Conversions).DateLogicalToHtml(jsenddate)
	.s adddate=##class(websys.Conversions).DateLogicalToHtml(adddate)
	
	q jsstdate_"^"_jsenddate_"^"_acctRowId_"^"_jsflag_"^"_err
}

ClassMethod cancel(acctrowid)
{
	&sql(delete from Dhc_JFYJAcount where Acct_RowId=:acctrowid)
	q SQLCODE
}

ClassMethod getshdate(arrcp)
{
	s shdate="", shtime=""
	s arpbl=$p(^ARRCP(arrcp,"RAL",1),"^",18)
	i (arpbl'="") d
	.s invrowid=$o(^DHCINVPRTZY(0,"AR",arpbl,""))
	.i (invrowid'="") d
	..s shdate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCINVPRTZY(invrowid),"^",2))
	..s shtime=##class(websys.Conversions).TimeLogicalToHtml($p(^DHCINVPRTZY(invrowid),"^",3))

	q shdate_"^"_shtime
}

Query FindJsHis(stdate, enddate, flag) As websys.Query(ROWSPEC = "Tjsdate:%String,Tjstime:%String,Tstdate:%String,Tenddate:%String,RowId:%String,Tusername:%String")
{
}

ClassMethod FindJsHisExecute(ByRef qHandle As %Binary, stdate, enddate, flag) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
	f jkdate=stdate:1:enddate d
	.s jkdr="0"
	.f  s jkdr=$o(^DHCJFYJACOUNT(0,"Date",jkdate,jkdr)) q:(jkdr="")  d
	..s jkflag=$p(^DHCJFYJACOUNT(jkdr),"^",9)
	..q:(jkflag'=flag)
	..s jsdate=$p(^DHCJFYJACOUNT(jkdr),"^",8)
	..s jsdate=##class(websys.Conversions).DateLogicalToHtml(jsdate)
	..s jstime=$p(^DHCJFYJACOUNT(jkdr),"^",13)
	..s jstime=##class(websys.Conversions).TimeLogicalToHtml(jstime)
	..s jsStDate=$p(^DHCJFYJACOUNT(jkdr),"^",5)
	..s jsStDate=##class(websys.Conversions).DateLogicalToHtml(jsStDate)
	..s jsEndDate=$p(^DHCJFYJACOUNT(jkdr),"^",6)
	..s jsEndDate=##class(websys.Conversions).DateLogicalToHtml(jsEndDate)
	..s userid=$p(^DHCJFYJACOUNT(jkdr),"^",7)
	..s username=$s((+userid'=0):$p($g(^SSU("SSUSR",userid)),"^",2),1:"")
	..d OutputJsHis
    
    quit $$$OK
OutputJsHis
	set Data=$lb(jsdate,jstime,jsStDate,jsEndDate,jkdr,username)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: yyx
/// CreateDate: 2009-09-25
/// Description: 根据日期将结算的病人放到临时global，DHCIPBILLPAIDBILL()
ClassMethod GetPaidBill(StDate, EndDate)
{
	f PrtDate=StDate:1:EndDate d
	.s DailyRowID=""
    .f  s DailyRowID=$o(^DHCJFUSERJK(0,"date",PrtDate,DailyRowID))  q:(DailyRowID="")  d
    ..s PrtRowID="0" 
	..f  s PrtRowID=$o(^DHCINVPRTZY(0,"JK",DailyRowID,PrtRowID))  q:(PrtRowID="")  d
	...s TMPInfo=^DHCINVPRTZY(PrtRowID)
	...s PrtStatus=$p(TMPInfo,"^",8)
	...q:(PrtStatus="A")
	...s AdmRowID=$p(TMPInfo,"^",4)
	...q:'$d(^PAADM(AdmRowID))
	...s BillNo=$p(TMPInfo,"^",5) 
	...s ^DHCIPBILLPAIDBILL(PrtDate,AdmRowID,BillNo)=""
}

/// Creator: yyx
/// CreateDate: 2010-11-19
/// Description: 账务余额后台任务
/// Debug: d ##class(web.UDHCJFAcount).InsertAcountRemainByTask()
ClassMethod InsertAcountRemainByTask()
{
	s Err=0
	s HospId=0
	f  s HospId=$o(^CT("HOSP",HospId)) q:(HospId="")  d
	.s YJUser=$o(^DHCJFYJACOUNTCONFIG(0,"HOSP",HospId,""))  //目前没做前台配置及表结构可先写死global
	.q:(YJUser="")
	.s StDate=..getstdate("YJACOUNT", HospId)
	.s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	.s EndDate=+$h-1    //做前一天的任务
	.f Date=StDate:1:EndDate d
	..d ##class(%ResultSet).RunQuery("web.UDHCJFAcount", "FindYjAcount", Date, "", Date, "", HospId)
	..s AcctInfo=Date_"^"_Date
	..s Err=..InsertRemain(YJUser, "YJACOUNT", $j, HospId, AcctInfo)
	..i (Err'=0) d
	..s ^TMPERR("ZYJF","YJACOUNT",Date)=Err

	q Err
}

/// 补任务用
/// d ##class(web.UDHCJFAcount).InsertAcountRemainByTaskNew()
ClassMethod InsertAcountRemainByTaskNew()
{
	s Err=0
	s HospId=2    //注意院区
	f Date=$zdh("2014-01-26",3):1:$zdh("2014-01-26",3) d
	.s YJUser=$o(^DHCJFYJACOUNTCONFIG(0,"HOSP",HospId,"")) //目前没做前台配置及表结构可先写死global
	.d ##class(%ResultSet).RunQuery("web.UDHCJFAcount", "FindYjAcount", Date, "", Date, "", YJUser, HospId)
	.s AcctInfo=Date_"^"_Date
	.s Err=..InsertRemain(YJUser, "YJACOUNT", $j, HospId, AcctInfo)
	.i (Err'=0) d
	..s ^TMPERR("ZYJF","YJACOUNT",Date)=Err
	
	q Err
}

/// Creator: yyx
/// CreateDate: 2011-05-27
/// Function: 保存未结算的押金，^DHCIPBILLUNPAIDDEPOSIT("UDHCJFAcount",+$h,PrtRowID)=PrtStatus
ClassMethod InsertUnPaidDepositByTask()
{
	s PrtRowID=0
	f  s PrtRowID=$o(^DHCSFPRINTDETAIL(0,"PaidFlag","N",PrtRowID)) q:(PrtRowID="")  d
	.s DepTypeDR=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",13)
	.q:(DepTypeDR="")
	.s DepTypeCode=$p($g(^ARC("ARCDT",DepTypeDR)),"^",1)
	.q:(DepTypeCode'="01")
	.s PrtStatus=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",8)
	.s PrtDate=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",2)
	.q:(PrtDate>=+$h)
	.s ^DHCIPBILLUNPAIDDEPOSIT("UDHCJFAcount",+$h-1,PrtRowID)=PrtStatus
	
	q
}

ClassMethod GetPMAcount(stdate, flag, hospId, paymId)
{
	s stdate=stdate-1
	s lastremain=0
	s rowid=0
	f  s rowid=$o(^DHCJFYJACOUNT(0,"ENDDATE",stdate,rowid)) q:(rowid="")  d
	.s flag1=$p(^DHCJFYJACOUNT(rowid),"^",9)
	.q:(flag1'=flag)
	.s myUserDR=$p(^DHCJFYJACOUNT(rowid),"^",7)
	.s myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(myUserDR)
	.q:(hospId'=myHospDR)&&(hospId'="")&&(myHospDR'="")
	.s Sub=0
	.f  s Sub=$o(^DHCJFYJACOUNTPAYM(rowid,"PMSUB",Sub)) q:(Sub="")  d
	..s PMSubData=$g(^DHCJFYJACOUNTPAYM(rowid,"PMSUB",Sub))
	..q:(PMSubData="")
	..s Paym=$p(PMSubData,"^",3)
	..q:(Paym'=paymId)
	..s PaymAmt=$p(PMSubData,"^",7)
	..s lastremain=PaymAmt
	
	q lastremain
}

ClassMethod GetLastPMAmtInfo(stdate, flag, hospId, count, PMStr)
{
	s stdate=stdate-1
	s lastremain=0
	s rowid=0
	f  s rowid=$o(^DHCJFYJACOUNT(0,"ENDDATE",stdate,rowid)) q:(rowid="")  d
	.s myFlag=$p(^DHCJFYJACOUNT(rowid),"^",9)
	.q:(myFlag'=flag)
	.s myHospDR=$p(^DHCJFYJACOUNT(rowid),"^",16) //wangjian 2018-10-15
	.q:(myHospDR'=hospId)
	.s Sub=0
	.f  s Sub=$o(^DHCJFYJACOUNTPAYM(rowid,"PMSUB",Sub)) q:(Sub="")  d
	..s PMSubData=$g(^DHCJFYJACOUNTPAYM(rowid,"PMSUB",Sub))
	..q:(PMSubData="")
	..s Paym=$p(PMSubData,"^",3)
	..q:(PMStr[("^"_Paym_"^"))
	..s PaymAmt=$p(PMSubData,"^",7)
	..s lastremain=PaymAmt
	..s JFSum=0
	..s DFSum=0
	..s curremain=PaymAmt
   	..s ^TMP("ZYJF","YJACOUNTPM",$j,count)=Paym_"^"_lastremain_"^"_JFSum_"^"_DFSum_"^"_curremain_"^"_$j
	..s count=count+1
	q 0
}

/// wangjian
/// 2019-01-11
/// 获取最后一条预交金账时间
/// w ##class(web.UDHCJFAcount).getlastAcctInfo("YJACOUNT",2)
ClassMethod getlastAcctInfo(Flag As %String, HospId As %String) As %String
{
	s lastInfo="^", lastflag="N"
	s rowid=""
	f  s rowid=$o(^DHCJFYJACOUNT(0,"Flag",Flag,rowid),-1) q:((rowid="")||(lastflag'="N"))  d
	.s myHospDR=$p(^DHCJFYJACOUNT(rowid),"^",16)   //wangjian 2018-10-15
	.q:(myHospDR'=HospId)
	.s endDate=$p(^DHCJFYJACOUNT(rowid),"^",6)
	.s stDate=$p(^DHCJFYJACOUNT(rowid),"^",5)
	.s stDate=##class(websys.Conversions).DateLogicalToHtml(stDate)
	.s endDate=##class(websys.Conversions).DateLogicalToHtml(endDate)
	.s lastInfo=stDate_"^"_endDate
	.s lastflag="Y"
	
	q lastInfo
}

}
