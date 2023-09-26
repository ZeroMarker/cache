Import sqluser

Class web.UDHCJFInvprtzySub Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 将多张发票的记录插入住院发票子表
ClassMethod InsertInvzySub(itmjs As %String = "", itmjsex As %String = "", str)
{
	s Invno=$p(str,"^",1)
	s Adm=$p(str,"^",2)
	s Billno=$p(str,"^",3)
	s prtrowid=$p(str,"^",4)
	s invsum=$p(str,"^",5)
	s userId=$p(str,"^",6)
	s invflag=$p(str,"^",7)
	s rid=$p(str,"^",8)
	s jkdate=+$h
	s jktime=$p($h,",",2)
    s patfeeall=$p(str,"^",9)
    s papmi=$p(^PAADM(Adm),"^",1)
    
    s err=0
    s amtsum=0
    s invprtzysub=0
    f  s invprtzysub=$o(^DHCInvprtzySub(0,"InvprtzyDr",prtrowid,invprtzysub))  q:(invprtzysub="")  d
    .s prtsubstatus=$p(^DHCInvprtzySub(invprtzysub),"^",9)
    .q:(prtsubstatus="A")
    .s prtamt=$p(^DHCInvprtzySub(invprtzysub),"^",7)
    .s amtsum=amtsum+prtamt
    s amtremain=patfeeall-amtsum
    q:(amtremain<invsum) "1"
    
    s $ZT="ERROR^DHCSSERR"  d ..tb()	
	k PLIST
	s PLIST(2)=Invno
	s PLIST(3)=jkdate
	s PLIST(4)=jktime
	s PLIST(5)=Adm
	s PLIST(6)=Billno
	s PLIST(7)=prtrowid
	s PLIST(8)=invsum
	s PLIST(9)=userId
	s PLIST(10)="N"
	s PLIST(12)="N"
	s PLIST(16)=papmi
	&sql(insert into DHC_InvprtzySub values :PLIST())
	s err=SQLCODE
	i (err) tro  q err
	
	i (invflag="Y") d
	.i (Invno'="") d
	..s err=##class(web.UDHCJFINV).SELECT(rid),endinv=+PLIST(3)
	..s tmpinvno=+Invno
	..i (tmpinvno=endinv)  d      ;如果是最后一张领取的发票??标记为已用完
	...s err=..invrefund(rid, Invno, userId)
    ..i (+Invno<endinv)  d
	...s lastnum=##class(UDHCJFBaseCommon).incre(Invno)
	...&sql(update DHC_INVOICE set inv_lastnum=:lastnum where inv_rowid=:rid)  
	...s err=SQLCODE
	i (err) tro  q err
	d ..tc()
	
	q err
}

ClassMethod UpdateInvzySub(itmjs As %Library.String = "", itmjsex As %Library.String = "", str)
{
	;作废发票时将原来的纪录更新到住院发票子表
	;有待进一步完善哦
    s SQLCODE=0
    s err=0
    s $ZT="ERROR^DHCSSERR"  d ..tb()	
	&sql(update DHC_InvprtzySub set PrtSub_flag='A' where PrtSub_rowid=:str ) 
	i SQLCODE'=0 Trollback
	q:(SQLCODE'=0) SQLCODE
	d ..tc()
	q err
}

ClassMethod invrefund(rid As %String, invno As %String, usr As %String) As %String
{
	&sql(update DHC_INVOICE set inv_lastnum=:invno,inv_finalflag='N' where inv_rowid=:rid)
	&sql(select count(*) into :num from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:usr and inv_type='I')
	i num'=0  d
	.&sql(select min(inv_rowid) into :rowid1  from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:usr and inv_type='I')
	.&sql(update DHC_INVOICE set inv_finalflag='Y' where inv_rowid=:rowid1)
	q SQLCODE
}

/// 合计多张发票的费用
/// w ##class(web.UDHCJFInvprtzySub).InvSubAmout("","","81")
ClassMethod InvSubAmout(itmjs As %Library.String = "", itmjsex As %Library.String = "", prtrowid)
{
 	s Invamout=0
 	s prtsub=""
 	f  s prtsub=$o(^DHCInvprtzySub(0,"InvprtzyDr",prtrowid,prtsub)) q:prtsub=""  d
 	.s prtsubacount=$p(^DHCInvprtzySub(prtsub),"^",7)
 	.s prtsubflag=$p(^DHCInvprtzySub(prtsub),"^",9)
 	.q:prtsubflag="A"
 	.s Invamout=Invamout+prtsubacount
 	q $j(Invamout,3,2)
}

/// 北京地坛多张发票明细
/// d ##class(%ResultSet).RunQuery("web.UDHCJFInvprtzySub","InvSubInfo","")
Query InvSubInfo(Adm As %String, BillNo As %String, prtrowid As %String) As websys.Query(ROWSPEC = "Tinvno,Tpayamout,Tprtdate,Tprttime,Tuserrowid,Tjkdate,Tjktime,Tjkdr,Tsubflag,Tsubrowid")
{
}

ClassMethod InvSubInfoExecute(ByRef qHandle As %Binary, Adm, BillNo, prtrowid As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
	set ind=1
 	if (prtrowid="") quit $$$OK

 	s prtsubrowid=0
 	f  s prtsubrowid=$o(^DHCInvprtzySub(0,"InvprtzyDr",prtrowid,prtsubrowid)) q:(prtsubrowid="")  d
 	.s prtinvsubno=$p(^DHCInvprtzySub(prtsubrowid),"^",1)
 	.s prtinvsubsum=$p(^DHCInvprtzySub(prtsubrowid),"^",7)
 	.s prtinvsubprtdate=$p(^DHCInvprtzySub(prtsubrowid),"^",2)
 	.i prtinvsubprtdate'=""  s prtinvsubprtdate=$zd(prtinvsubprtdate,3)
 	.s prtinvsubprttime=$p(^DHCInvprtzySub(prtsubrowid),"^",3)
 	.i prtinvsubprttime'=""  s prtinvsubprttime=$zt(prtinvsubprttime,1)
 	.s prtinvsubuserdr=$p(^DHCInvprtzySub(prtsubrowid),"^",8)
 	.s prtinvsubhaddate=$p(^DHCInvprtzySub(prtsubrowid),"^",12)
 	.i prtinvsubhaddate'=""  s prtinvsubhaddate=$zd(prtinvsubhaddate,3)
 	.s prtinvsubhadtime=$p(^DHCInvprtzySub(prtsubrowid),"^",13)
 	.i prtinvsubhadtime'=""  s prtinvsubhadtime=$zt(prtinvsubhadtime,1)
 	.s prtinvsubhaddr=$p(^DHCInvprtzySub(prtsubrowid),"^",14)
 	.s prtinvsubflag=$p(^DHCInvprtzySub(prtsubrowid),"^",9)
 	.d outputrow

    quit $$$OK	
outputrow
	set Data=$lb(prtinvsubno,$j(prtinvsubsum,3,2),prtinvsubprtdate,prtinvsubprttime,prtinvsubuserdr,prtinvsubhaddate,prtinvsubhadtime,prtinvsubhaddr,prtinvsubflag,prtsubrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

/// 打印拆分后的发票的基本信息
/// w ##class(web.UDHCJFInvprtzySub).GetPatInfo("200800149")
ClassMethod GetPatInfo(PrtRowid)
{
	s medicare=""
    s subrowid=""
	f  s subrowid=$o(^DHCInvprtzySub(0,"INV",PrtRowid,subrowid)) q:subrowid=""  d
	.s prtsubamt=$p(^DHCInvprtzySub(subrowid),"^",7)
	.s sumdx=##class(web.UDHCJFBaseCommon).RMBDXXZH(+prtsubamt) ;现金大写
	.s Adm=$p(^DHCInvprtzySub(subrowid),"^",4)
	.q:(Adm="")
	.s PaperId=$p(^PAADM(Adm),"^",1)
	.s papno=$p($g(^PAPER(PaperId,"PAT",1)),"^",1)   ;登记号
	.s medicare=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Adm, "I", "")  ;病案号
	.s patname=$p($g(^PAPER(PaperId,"ALL")),"^",1)   ;姓名     
	.s disdate=""
	.s admdate=$p(^PAADM(Adm),"^",6)
	.i admdate'=""  s admdate=$zd(admdate,3)
	.s disdate=$p(^PAADM(Adm),"^",17)
	.i disdate'=""  s disdate=$zd(disdate,3)
	.s prtsubuser=$p(^DHCInvprtzySub(subrowid),"^",8)
	.s prtsubdate=$p(^DHCInvprtzySub(subrowid),"^",2)
 	.i prtsubdate'=""  s prtsubdate=$zd(prtsubdate,3)
 	.s prtsubtime=$p(^DHCInvprtzySub(subrowid),"^",3)
 	.i prtsubtime'=""  s prtsubtime=$zt(prtsubtime,1)
	s PrintInfo="patname"_$c(2)_patname_"^"_"medcare"_$c(2)_medicare_"^"_"inadmdate"_$c(2)_admdate_"^"_"outadmdate"_$c(2)_disdate_"^"_"patshareUP"_$c(2)_sumdx_"^"_"patshare"_$c(2)_$j(prtsubamt,3,2)_"^"_"username"_$c(2)_prtsubuser_"^"_"Date"_$c(2)_prtsubdate_"^"_"time"_$c(2)_prtsubtime
	q PrintInfo
}

ClassMethod tc()
{
	n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
