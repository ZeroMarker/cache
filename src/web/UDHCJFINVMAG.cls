Import SQLUser

Class web.UDHCJFINVMAG Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Abort(curno, newno, billno, usr)
{
	;(id,stat,invno,user,bill) 
	;
	;k (curno,newno,billno,usr)
	i (curno="")&(newno="") q 100
	i curno'=""  d
	.s prt=$o(^DHCINVPRTZY(0,"INV",curno,""))
	.s err=##CLASS(UDHCJFINVPRTZY).SELECT(prt)
	.s PLIST(10)="A"
	.s err=##CLASS(UDHCJFINVPRTZY).UPDATE(prt)
	.s arrcp=""
	.s arrcp=$o(^ARRCP("ARPBL",+billno,""),-1) 
	.i arrcp d
	..;s err=$$select^MVBARREC(arrcp)
	..;s PLIST(4)="" 
	..;s err=$$update^MVBARREC(arrcp)
	..&sql(update AR_Receipts set ARRCP_Number="" where ARRCP_ROWID=:arrcp)
	e   d  ;如果是未打印发票之前作废
	.
	.s err=##CLASS(UDHCJFPB).SELECT(billno)
	.s invdat=+$h,invtim=$p($h,",",2),adm=PLIST(2),amount=PLIST(9)
	.s err=$$select^MVBPAADM(adm),type=$p(PLIST(9),$c(1),2)
	.k PLIST
	.s PLIST(2)=newno,PLIST(3)=invdat,PLIST(4)=invtim,PLIST(5)=adm,PLIST(7)=billno
	.s PLIST(8)=amount,PLIST(9)=usr,PLIST(10)="A",PLIST(11)=type,PLIST(12)="N"
	.
	.s err=##CLASS(UDHCJFINVPRTZY).INSERT()
	;i id="" d  
	;.i stat["作废" s sign="Abort"
	;.&sql(select arpbl_paadm_dr,arpbl_totalpatient 
	;    into :adm,:amount from ar_patientbill where arpbl_rowid=:bill)
	;.&sql(select paadm_type into:type from paadm where paadm_rowid=:adm)
	;.s amount=$p(amount,$c(1)),invdat=+$h,invtim=$p($h,",",2),type=$P(type,$c(1),2)
	;.&sql(insert into DHC_INVPRT(prt_inv,prt_date,prt_time,prt_adm,prt_arpbl,prt_acount,prt_usr,prt_flag,prt_pattype)
	;    values(:invno,:invdat,:invtim,:adm,:bill,:amount,:usr,:sign,:type) )
	;i id'="" d
	;.&sql(update dhc_invprt set prt_flag="Abort" where prt_rowid=:id)
	q 0
}

/// 插入一条购入记录 ^^I^1149^1000^0001^1000^^^^Y
ClassMethod INSERT()
{
	k (PLIST)
	s PLIST(1)=""
	s PLIST(2)=+$h
	s err=##class(UDHCJFAMT1).INSERT()
	s P7=$p(%ROWID,$C(1))
	q err
}

/// 查询所有购入记录
ClassMethod SELECT(LOC)
{
	s id="",n=0
	f  s id=$o(^DHCFINAC(0,"L",LOC,id)) q:id=""  d
	.s s=^DHCFINAC(id),dat=$p(s,"^",1),loc=$p(s,"^",2),usr=$p(s,"^",3),tot=$p(s,"^",4)
	.s stno=$p(s,"^",5),edno=$p(s,"^",6),not=$p(s,"^",10),avail=$p(s,"^",9)
	.s dat=$zd(dat,3)
	.i usr="" s usr=""
	.i usr'="" s usr=$p(^SSU("SSUSR",usr),"^",2)
	.i loc["I" s loc="InPatient" i avail["Y" s avail="Yes"
	.i avail["N" s avail="No"
	.s n=n+1,PLIST(n)=dat_"^"_loc_"^"_usr_"^"_tot_"^"_stno_"^"_edno_"^"_not_"^"_avail_"^"_id
	s PLIST=n
	q 0
	;
}

/// 更新一条购入记录
ClassMethod UPDATE(rowid)
{
	k (PLIST,rowid)
	s s(5)=PLIST(5),s(6)=PLIST(6),s(7)=PLIST(7),s(8)=PLIST(8),s(9)=PLIST(9)
	s err=##class(UDHCJFAMT1).SELECT(rowid)
	s PLIST(5)=s(5),PLIST(6)=s(6),PLIST(7)=s(7),PLIST(8)=s(8),PLIST(9)=s(9)
	s PLIST(10)=+$h
	s err=##CLASS(UDHCJFAMT1).UPDATE(rowid)
	q err
}

ClassMethod getcashno(invoice)
{
	s ret=$o(^DHCINVPRTZY(0,"INV",invoice,""))
	i ret="" q 100
	q ret
}

/// 判断目前的发票号
ClassMethod getcurinvno(usr)
{
	&sql(select inv_rowid,inv_lastnum,inv_finalflag into :id,:no,:flag from dhc_invoice where inv_usr=:usr and inv_finalflag='Y' and inv_type='I')
	s id=$g(id),no=$g(no),flag=$g(flag)
	i flag["N" q "^"
	i id="" q "^"
	q $p(no,$c(1))_"^"_$p(id,$c(1))
}

/// 取被冲红的原始记录
ClassMethod getiniinv(BILL)
{
	n (BILL)
	s inv=""
	f  s inv=$o(^DHCINVPRTZY(0,"AR",BILL,inv)) q:(inv="")  d
	.s flag=$p(^DHCINVPRTZY(inv),"^",8)
	.s deposit=$p($p(^DHCINVPRTZY(inv),"^",22),$c(1))      ;yyx加
	.i flag="N"!(flag="I") s ret=inv
	q $g(ret)_"^"_deposit
}

/// 取得病人打印发票记录
ClassMethod getinvinfo(billno)
{
	k (billno)
	s admno=$p(^DHCPB(billno),"^",1) ;取得病人的adm号
	s papmi=$p(^PAADM(admno),"^",1),dep=$p(^PAADM(admno),"^",4)
	s name=$p(^PAPER(papmi,"ALL"),"^",1),depart=$p(^CTLOC(dep),"^",2)   ;取得病人的姓名和科室
	s P4=name
	i depart["-" s P5=$p(depart,"-",2)             
	&sql(select prt_date,prt_inv,prt_acount,prt_flag into :dat,:inv,:quali,:flag 
	       from dhc_invprtzy where prt_adm=:admno and prt_arpbl=:billno)       
	s P6=$g(dat),P7=$g(inv),P8=$g(quali),P9=$g(flag)    ;取得病人的发票打印日期??发票号??费用和状态   
	i P6'="" s P6=$zd(dat,3),P9=$p(flag,$c(1),2)
	q 0
}

ClassMethod getnameandep(usrid)
{
	k (usrid)
	s name=$p(^SSU("SSUSR",usrid),"^",2),dep=$p(^SSU("SSUSR",usrid),"^",4)
	s depart=$p(^CTLOC(dep),"^",2)
	s P8=name,P9=depart
	q 0
}

ClassMethod isusecurinvno(strno, endno)
{
	s P0=0
	&sql(select COUNT(finac_rowid) into:P0 from DHC_AMTMAG where finac_stnum>=:strno and finac_ednum<=:endno)
	q
}

ClassMethod savetoinvprt(invno, usr, bill, cat, rid, invflag, hospital As %String = "")
{
    n (invno, usr, bill, cat, rid, invflag, hospital)
	s Error=0
	s err=##class(web.UDHCJFPB).SELECT(bill)
	q:(err) err
	s adm=PLIST(2)
	s insTypeDR=PLIST(5)   //根据账单的费别打印发票
	s amount=PLIST(9)
	
	s deposit=0
	s rcpt="0"
	f  s rcpt=$o(^ARRCP("ARPBL",bill,rcpt)) q:(rcpt="")  d
	.s childsub="0"
	.f  s childsub=$o(^ARRCP("ARPBL",bill,rcpt,childsub))  q:(childsub="")  d
	..s deposit=deposit+$p(^ARRCP(rcpt,"RAL",childsub),"^",2)
	
	s visitStatus=$p($g(^PAADM(adm)),"^",20)
	i (cat["正常") s sign="N"
	i (visitStatus'["D") s sign="I"
	i (cat["作废") s sign="A"
	i (cat["冲红") s sign="S"
	
	s invdat=+$h
	s invtim=$p($h,",",2)
	
	//modify 2011-02-19 增加发票号段中取首字母的功能
	s invtitle=""
	i (rid'="")  d
	.s invtitle=$p($g(^DHCINVOICE(rid)),"^",16) 

	k PLIST
	//modify 2012-6-5 从被取消结算的发票里取记录的发票入院日期和出院日期
	s OldPrtRowid=$p(..getiniinv(bill),"^",1)
	i (+OldPrtRowid'=0)  d
	.s PBDateFrom=$p($g(^DHCINVPRTZY(OldPrtRowid)),"^",32)
	.s PBDateTo=$p($g(^DHCINVPRTZY(OldPrtRowid)),"^",33)
	.s PLIST(32)=PBDateFrom
	.s PLIST(33)=PBDateTo
	//
	s PLIST(2)=invtitle_invno, PLIST(3)=invdat, PLIST(4)=invtim, PLIST(5)=adm, PLIST(7)=bill
	s PLIST(8)=amount, PLIST(9)=usr, PLIST(10)=sign, PLIST(11)=insTypeDR, PLIST(12)="N", PLIST(15)=""
	s PLIST(25)=deposit
	i (sign="S") s PLIST(8)=-amount, PLIST(15)=$p(..getiniinv(bill),"^",1), PLIST(25)=-$p(..getiniinv(bill),"^",2)  ;取押金
	i (sign="S") s PLIST(7)=$p(^DHCPB(bill),"^",18), bill=PLIST(7), PLIST(16)="N", PLIST(21)=$o(^ARRCP("ARPBL",+bill,""),-1)
	s PLIST(38)=hospital
	
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	
	&sql(INSERT INTO DHC_INVPRTZY VALUES :PLIST())
	s Error=SQLCODE
	i (Error'=0) Trollback  q Error

	s PrtRowID=$p(%ROWID,$c(1))
	
	i (invflag="Y") d
	.i (invno'="") d
	..s err=##class(web.UDHCJFINV).SELECT(rid)
	..s endinv=+PLIST(3)
	..i (endinv=+invno)  d      ;如果是最后一张领取的发票??标记为已用完
	...s Error=..invrefund(rid, invno, usr)
	..i (+invno<endinv) d
	...s lastnum=##class(web.UDHCJFBaseCommon).incre(invno)
	...&sql(update DHC_INVOICE set inv_lastnum=:lastnum where inv_rowid=:rid)   
	...s Error=Error+SQLCODE
	i (Error'=0) Trollback  q Error
	
	;添加发票号到AR_RECEIPTS中
	s arrcp=$o(^ARRCP("ARPBL",+bill,""),-1)
	i ((arrcp'="")&&(invno'="")) d
	.//modify 2011-02-19 在保存的发票字段里增加字母
	.s invno1=invtitle_invno
	.&sql(update AR_Receipts set ARRCP_Number=:invno1 where ARRCP_ROWID=:arrcp)
	.s Error=SQLCODE
	i (Error'=0) Trollback  q Error
	d ..tc()

	q Error
}

ClassMethod invrefund(rid As %String, invno As %String, usr As %String) As %String
{
   s Error=0
	&sql(update DHC_INVOICE set inv_lastnum=:invno,inv_finalflag='N' where inv_rowid=:rid)
	s Error=Error+SQLCODE
	&sql(select count(*) into :num from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:usr and inv_type='I')
	i num'=0  d
	.&sql(select min(inv_rowid) into :rowid1  from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:usr and inv_type='I')
    .&sql(update DHC_INVOICE set inv_finalflag='Y' where inv_rowid=:rowid1)
    .s Error=Error+SQLCODE
    q Error
}

ClassMethod transact(start, end, name, rid)
{
    ; 生成转交记录
	&sql(select ssusr_rowid into :uid from ss_user where ssusr_name=:name)
	s dat=+$h,tim=$p($h,",",2),uid=$p(uid,$c(1))
	&sql(insert into dhc_invoice(inv_startinv,inv_endinv,inv_usr,inv_date,inv_time,inv_status,inv_type,inv_linkto,inv_finalflag)
	    values(:start,:end,:uid,:dat,:tim,'Trans','In Patient',:rid,'No'))
	q:SQLCODE'=0 SQLCODE
	;更新原有记录
	&sql(update dhc_invoice set inv_lastnum=:end where inv_rowid=:rid)
 	;取出新记录
	s en=$p(%ROWID,$c(1))
	;&sql(select INV_StartInv,inv_endinv,inv_usr->ssusr_name,inv_date,inv_time,inv_lastnum,inv_rowid
	&sql(select INV_StartInv,inv_endinv,inv_usr,inv_date,inv_time,inv_lastnum,inv_rowid
	    into :PLIST(1),:PLIST(2),:PLIST(3),:PLIST(4),:PLIST(5),:PLIST(6),:PLIST(7)
	    from DHC_INVOICE where inv_rowid=:en)
	s PLIST(4)=$ZD(PLIST(4),3),PLIST(5)=$ZT(PLIST(5)),PLIST(7)=$P(PLIST(7),$C(1))    
	s PLIST=7
	&sql(select inv_endinv into:endinitials from dhc_invoice where inv_rowid=:rid)
	i endinitials=end d
	.&sql(update dhc_invoice set inv_finalflag='Yes' where inv_rowid=:rid)  
	q SQLCODE
}

ClassMethod verify(name, passwd)
{
 ;验证用户和密码
	&sql(select ssusr_initials into :rid from ss_user where ssusr_name=:name)
	q $$select^MVBSSUSR(rid,passwd)
}

ClassMethod getinvrowid(bill)
{
   s invrowid=""
	s invrowid=$o(^DHCINVPRTZY(0,"AR",bill,""),-1)
	q invrowid
}

ClassMethod tb()
{
    n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q SQLCODE
}

ClassMethod tc()
{
    n SQLCODE
    TCOMMIT  s SQLCODE=$zu(34)
	q SQLCODE
}

}
