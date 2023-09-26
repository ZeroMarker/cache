Import sqluser

Class web.UDHCJFAcountCommon Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod getlastremain(stdate, wardid, flag)
{
	//取上期余额
	;s stdate=$zdh(stdate,4)
	s stdate=stdate-1
	s lastjfsum=0,lastdfsum=0,lastremain=0
	s rowid="0"
	f  s rowid=$o(^DHCJFYJACOUNT(0,"ENDDATE",stdate,rowid)) q:rowid=""  d
	.s flag1=$p(^DHCJFYJACOUNT(rowid),"^",9)
	.s ward=$p(^DHCJFYJACOUNT(rowid),"^",14)
	.q:((ward'=wardid)&(wardid'=""))
	.q:flag1'=flag
	.s lastjfsum=$p(^DHCJFYJACOUNT(rowid),"^",2)
	.s lastdfsum=$p(^DHCJFYJACOUNT(rowid),"^",3)
	.s lastremain=$p(^DHCJFYJACOUNT(rowid),"^",4)
	q $j($g(lastjfsum),3,2)_"^"_$j($g(lastdfsum),3,2)_"^"_$j($g(lastremain),3,2)
}

ClassMethod judgedate(flag, ksdate, jsdate) As %String
{
    s ksdate=$zdh(ksdate,4)
    s jsdate=$zdh(jsdate,4)
	s cancelerr="0"
	s adddate="",rowid="",jsflag="",jsstdate="",jsenddate="",err=0
	i ksdate>jsdate s err=-1
	s rowid=$o(^DHCJFYJACOUNT(0,"Flag",flag,""),-1)
	i (rowid'="") d
	.s jsstdate=$p(^DHCJFYJACOUNT(rowid),"^",5)
	.s jsenddate=$p(^DHCJFYJACOUNT(rowid),"^",6)
	.s adddate=$p(^DHCJFYJACOUNT(rowid),"^",8)
	.i (ksdate'>jsenddate) d
	..s jsflag="Y"
	.i (ksdate'=jsstdate)!(jsdate'=jsenddate)  d
	..s cancelerr="1"
	.s jsstdate=$zd(jsstdate,3),jsenddate=$zd(jsenddate,3)
	.s adddate=$zd(adddate,3)
	e  d
	.s cancelerr="1"
	q jsstdate_"^"_jsenddate_"^"_rowid_"^"_jsflag_"^"_err_"^"_cancelerr
}

ClassMethod cancel(acctrowid, stdate, enddate, flag)
{
	s acctrowid=$g(acctrowid),stdate=$g(stdate),enddate=$g(enddate),flag=$g(flag)
	q:(acctrowid="") "-1"
	q:(stdate="") "-1"
	q:(enddate="") "-1"
	q:(flag="") "-1"
	s stdate=$zdh(stdate,3)
	s enddate=$zdh(enddate,3)
	&sql(delete from dhc_jfyjacount where acct_stdate=:stdate and acct_enddate=:enddate and acct_flag=:flag)
	;&sql(delete from dhc_jfyjacount where acct_rowid=:acctrowid)
	q SQLCODE
}

ClassMethod getyearmonthsum(enddate, wardid, flag, yearmonflag)
{
	//flag,标志是预交金帐YJACOUNTSAVE，应收款帐FEEACOUNTSAVE，
   s enddate=$zd(enddate,3)
   s year=$p(enddate,"-",1),month=$p(enddate,"-",2)
   i yearmonflag="Y" s startday=year_"-"_"01"_"-"_"01"
   i yearmonflag="M" s startday=year_"-"_month_"-"_"01"
   s yearmonstdate=$zdh(startday,3)
   s yearjfsum=0,yeardfsum=0
   s yearmonstenddate=$Zdh(enddate,3)-1
   f i=yearmonstdate:1:yearmonstenddate d
   .s acctrowid=""
   .f  s acctrowid=$o(^DHCJFYJACOUNT(0,"ENDDATE",i,acctrowid)) q:acctrowid=""  d
   ..s acountflag=$p(^DHCJFYJACOUNT(acctrowid),"^",9)
   ..s patward=$p(^DHCJFYJACOUNT(acctrowid),"^",14)
   ..q:((patward'=wardid)&(wardid'=""))
   ..q:((+patward'=0)&(+wardid=0))
   ..q:acountflag'=flag
   ..s yearjfsum=yearjfsum+$p(^DHCJFYJACOUNT(acctrowid),"^",2),yeardfsum=yeardfsum+$p(^DHCJFYJACOUNT(acctrowid),"^",3)
   q +$g(yearjfsum)_"^"_+$g(yeardfsum)
}

ClassMethod InserQFRemain(adduser, job)
{
	//保存结算的预交金病区帐，总帐
	s $ZT="ERROR^DHCSSERR" d ..tb()   
	s adddate=+$h,addtime=$p($h,",",2)
	s stdate=$p($g(^TMP("ZYJF","QFDetail",job)),"^",1)
	s enddate=$p($g(^TMP("ZYJF","QFDetail",job)),"^",2)
	s sttime=$p($g(^TMP("ZYJF","QFDetail",job)),"^",3)
	s endtime=$p($g(^TMP("ZYJF","QFDetail",job)),"^",4)
		
	s alljfsum=0,alldfsum=0,allremain=0
	s flag="QFACOUNTSAVE"
	s wardid=""
	s retcode=0
	f  s wardid=$o(^TMP("ZYJF","QFDetail",job,wardid)) q:wardid=""  d
	.s jfsum=+$g(^TMP("ZYJF","QFDetail",job,wardid,"JF"))
	.s alljfsum=+alljfsum+jfsum
	.s dfsum=+$g(^TMP("ZYJF","QFDetail",job,wardid,"DF"))
	.s alldfsum=+alldfsum+dfsum
	.s remain=0
	.s qfdr=""
	.f  s qfdr=$o(^DHCJFYJACOUNT(0,"Ward",wardid,"EndDate",stdate,qfdr),-1)  q:(qfdr="")||(+remain'=0)   d
	..s qfflag=$p($g(^DHCJFYJACOUNT(qfdr)),"^",9)
	..q:qfflag'["QFACOUNTSAVE"
	..s remain=$p($g(^DHCJFYJACOUNT(qfdr)),"^",4)
    .s remain=remain+jfsum-dfsum
	.s allremain=+allremain+remain
	.&sql(insert into dhc_jfyjacount(acct_stdate,acct_sttime,acct_enddate,acct_endtime,acct_jfsum,acct_dfsum,acct_curremain,acct_adddate,acct_addtime,acct_adduser,acct_flag,acct_ward_dr) values (:stdate,:sttime,:enddate,:endtime,:jfsum,:dfsum,:remain,:adddate,:addtime,:adduser,:flag,:wardid))
	.s retcode=retcode+SQLCODE
	
	i retcode'=0  d
	.Trollback
	q:(retcode'=0) retcode
	&sql(insert into dhc_jfyjacount(acct_stdate,acct_sttime,acct_enddate,acct_endtime,acct_jfsum,acct_dfsum,acct_curremain,acct_adddate,acct_addtime,acct_adduser,acct_flag,acct_ward_dr) values (:stdate,:sttime,:enddate,:endtime,:alljfsum,:alldfsum,:allremain,:adddate,:addtime,:adduser,:flag,""))
	s retcoded=retcode+SQLCODE
	i retcode'=0  d
	.Trollback
	q:(retcode'=0) retcode
	d ..tc()
	
	k ^TMP("ZYJF","QFDetail",job)
	q retcode
}

ClassMethod InsertWardRemain(adduser, flag, job)
{
   //保存结算的预交金病区帐，总帐
	s $ZT="ERROR^DHCSSERR" d ..tb()   
	s adddate=+$h,addtime=$p($h,",",2)
	s alljfsum=0,alldfsum=0,allremain=0
	s wardid=""
	s retcode=0
	f  s wardid=$o(^TMP("ZYJF",flag,job,wardid)) q:wardid=""  d
	.s jfsum=$p(^TMP("ZYJF",flag,job,wardid),"^",1)
	.s dfsum=$p(^TMP("ZYJF",flag,job,wardid),"^",2)
	.s remain=$p(^TMP("ZYJF",flag,job,wardid),"^",3)
	.s stdate=$p(^TMP("ZYJF",flag,job,wardid),"^",4)
	.s sttime=$p(^TMP("ZYJF",flag,job,wardid),"^",5)
	.s enddate=$p(^TMP("ZYJF",flag,job,wardid),"^",6)
	.s endtime=$p(^TMP("ZYJF",flag,job,wardid),"^",7)
	.s alljfsum=alljfsum+jfsum,alldfsum=alldfsum+dfsum,allremain=allremain+remain
	.&sql(insert into dhc_jfyjacount(acct_stdate,acct_sttime,acct_enddate,acct_endtime,acct_jfsum,acct_dfsum,acct_curremain,acct_adddate,acct_addtime,acct_adduser,acct_flag,acct_ward_dr) values (:stdate,:sttime,:enddate,:endtime,:jfsum,:dfsum,:remain,:adddate,:addtime,:adduser,:flag,:wardid))
	.s retcode=retcode+SQLCODE
	
	i retcode'=0  d
	.Trollback
	q:(retcode'=0) retcode
	&sql(insert into dhc_jfyjacount(acct_stdate,acct_sttime,acct_enddate,acct_endtime,acct_jfsum,acct_dfsum,acct_curremain,acct_adddate,acct_addtime,acct_adduser,acct_flag,acct_ward_dr) values (:stdate,:sttime,:enddate,:endtime,:alljfsum,:alldfsum,:allremain,:adddate,:addtime,:adduser,:flag,""))
	s retcoded=retcode+SQLCODE
	i retcode'=0  d
	.Trollback
	q:(retcode'=0) retcode
	d ..tc()
	;s jkrowid=$g(%ROWID)
	;i flag="FLFEEACOUNT" d
	.;s ind=ind-1
	.;f i=1:1:ind d
	..;s s=^TMP("ZYJF",flag,job,i)
	..;s flrowid=$p(s,"^",1)
	..;s jfsum=$p(s,"^",4)
	..;s dfsum=$p(s,"^",5)
	..;s curremain=$p(s,"^",6)
	..;&sql(insert into dhc_jffeeacount(fee_acct_dr,fee_tari_dr,fee_jfsum,fee_dfsum,fee_currentremain) values(:jkrowid,:flrowid,:jfsum,:dfsum,:curremain))
	k ^TMP("ZYJF",flag,job)
	q retcode
}

ClassMethod InsertRemain(adduser, flag, job)
{
   //保存结算的预交金病区帐，总帐
	s $ZT="ERROR^DHCSSERR" d ..tb()   
	s adddate=+$h,addtime=$p($h,",",2)
	s alljfsum=0,alldfsum=0,allremain=0
	s tmpstr=^TMP("ZYJF",flag,$j)
	s alljfsum=$p(tmpstr,"^",1)
	s alldfsum=$p(tmpstr,"^",2)
	s allremain=$p(tmpstr,"^",3)
	s stdate=$p(tmpstr,"^",4)
	s sttime=$p(tmpstr,"^",5)
	s enddate=$p(tmpstr,"^",6)
	s endtime=$p(tmpstr,"^",7)
	&sql(insert into dhc_jfyjacount(acct_stdate,acct_sttime,acct_enddate,acct_endtime,acct_jfsum,acct_dfsum,acct_curremain,acct_adddate,acct_addtime,acct_adduser,acct_flag,acct_ward_dr) values (:stdate,:sttime,:enddate,:endtime,:alljfsum,:alldfsum,:allremain,:adddate,:addtime,:adduser,:flag,""))
	d ..tc()
	k ^TMP("ZYJF",flag,job)
	q SQLCODE
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

Query admlistlookup(Regno, Medicare) As websys.Query(ROWSPEC = "admno:%String,papno:%String,papname:%String,medicare:%String,admdate:%String,dischargedate:%String,warddesc:%String,admstatus:%String,wardid:%String,rowid:%String")
{
}

ClassMethod admlistlookupExecute(ByRef qHandle As %Binary, Regno, Medicare) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	s Regno=$g(Regno),Medicare=$g(Medicare)
	i (Regno="")&(Medicare="") Quit $$$OK
	s papmiid=""
	i (Regno'="")  d
	.s Regno=##class(web.UDHCJFBaseCommon).regnocon(Regno)
	.s papmiid=""
	.s papmiid=$o(^PAPERi("PAPMI_PatNo",Regno,papmiid),-1)  q:(papmiid="")  d
	i (Medicare'="") d
	.s Medicare=$$ALPHAUP^SSUTIL4(Medicare)
	.s papmiid=""
	.s papmiid=$o(^PAPERi("Medicare1",Medicare,papmiid))
	i (papmiid="") Quit $$$OK 
	i (Regno="")  s Regno=$p(^PAPER(papmiid,"PAT",1),"^",1)
	s papname=$p(^PAPER(papmiid,"ALL"),"^",1)
	i (Medicare="")  s Medicare=$p(^PAPER(papmiid,"PAT",1),"^",22)
	s admid=""
	f  s admid=$o(^PAPERdr(papmiid,"ADM","I",admid),-1)  q:(admid="")  d
	.s visitsatus=$p(^PAADM(admid),"^",20)
	.q:(visitsatus="C")
	.s admno=$p(^PAADM(admid),"^",81)
	.s admdate=$p(^PAADM(admid),"^",6)
	.i admdate'=""  s admdate=$zd(admdate,3)
	.s dischargedate=$p(^PAADM(admid),"^",17)
	.i dischargedate'=""  s dischargedate=$zd(dischargedate,3)
	.s admstatus=""
	.i visitsatus="A"  s admstatus="在院"
    .i visitsatus="D"  s admstatus="出院"
    .s wardid=$p(^PAADM(admid),"^",70)
    .s warddesc=""
    .i wardid'=""  d
    ..i $d(^PAWARD(wardid))'=0  d
    ...s warddesc=$p(^PAWARD(wardid),"^",2)
    .s rowid=admid
	.d OutputRow1	

	Quit $$$OK
	
OutputRow1    
	set Data=$lb(admno,Regno,papname,Medicare,admdate,dischargedate,warddesc,admstatus,wardid,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getpatinfo(regno, medicare)
{
   s regno=$g(regno),medicare=$g(medicare)
   s patinfo=""
   q:(regno="")&(medicare="") patinfo
   s papmiid=""
   i (regno'="")  d
   .s regno=##class(web.UDHCJFBaseCommon).regnocon(regno)
   .s papmiid=""
   .s papmiid=$o(^PAPERi("PAPMI_PatNo",regno,papmiid),-1)
   i medicare'="" d
   .s medicare=$$ALPHAUP^SSUTIL4(medicare)
   .s papmiid=""
   .s papmiid=$o(^PAPERi("Medicare1",medicare,papmiid))
   q:(papmiid="") patinfo
   i regno=""  s regno=$p(^PAPER(papmiid,"PAT",1),"^",1)
   s papname=$p(^PAPER(papmiid,"ALL"),"^",1)
   i medicare=""  s medicare=$p(^PAPER(papmiid,"PAT",1),"^",22)
   s admno="",rowid="",warddesc="",wardid=""
   s admid="",admnum=0
   f  s admid=$o(^PAPERdr(papmiid,"ADM","I",admid),-1)  q:(admid="")!(admnum>0)  d
   .s vistatus=$p(^PAADM(admid),"^",20)
   .q:(vistatus="C")
   .s admnum=admnum+1
   .s admno=$p(^PAADM(admid),"^",81)
   .s wardid=$p(^PAADM(admid),"^",70)
   .s warddesc=""
   .i wardid'=""  d
   ..i $d(^PAWARD(wardid))'=0  d
   ...s warddesc=$p(^PAWARD(wardid),"^",2)
   .s rowid=admid 
   q:(admnum=0) patinfo
   s patinfo=regno_"^"_papname_"^"_medicare_"^"_admno_"^"_warddesc_"^"_wardid_"^"_rowid
   q patinfo
}

ClassMethod gettoday()
{
 s str=+$h-1
 s str1=+$h
 s str=$zd(str,4)
 s str1=$zd(str1,4)
 q str_"^"_str1
}

}
