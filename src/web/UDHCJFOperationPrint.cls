Class web.UDHCJFOperationPrint Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 病人结算费用明细清单打印
ClassMethod GetBillDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBillDetailExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

ClassMethod GetBillDetailExecute(ByRef qHandle As %Binary, BillNo As %String, job As %String) As %Status
{
  ;d ##class(%ResultSet).RunQuery("web.UDHCJFOperationPrint","GetBillDetail","3255","1484")
  Set repid=$I(^CacheTemp)
  s ind=1
  s ^TMP("ZYJF","TariDesc")=""
  k ^TMP("ZYJF","taricDescsum")
  i $g(BillNo)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
  i $g(job)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
  s gnum="",allsum=0,JudgeBabyNum=0
  s AdmRowId=""
  f  s AdmRowId=$o(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId)) q:AdmRowId=""  d
  .s AdmPatSum=0
  .s JudgeBabyNum=JudgeBabyNum+1
  .s PAPMIRowId=$p(^PAADM(AdmRowId),"^",1)
  .s PAPName=$p(^PAPER(PAPMIRowId,"ALL"),"^",1)
  .i JudgeBabyNum>1 d
  ..s tariDescn=PAPName,uomDesc="",price="",qty="",sum="",ybdesc=""
  ..d OutputRow
  .s taricDescdr=""
  .f  s taricDescdr=$o(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr)) q:taricDescdr=""  d
  ..s tarisum=0,gnum=""
  ..f  s gnum=$o(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum))  q:gnum=""  d
  ...s tarid=$p(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum),"^",1)
  ...q:(tarid="")
  ...s taricDesc=$p(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum),"^",2)
  ...i ^TMP("ZYJF","TariDesc")=taricDesc  s ^TMP("ZYJF","TariDesc")=taricDesc
  ...e  d
  ....s tariDescn=taricDesc
  ....s ^TMP("ZYJF","TariDesc")=taricDesc
  ....s (uomDesc,price,qty,sum,ybdesc)=""
  ....Do OutputRow
  ...;s taricDesc=$p(^TMP("ZYJF","BillDetail",BillNo,job,gnum),"^",2)  
  ...s ybdesc=##class(web.DHCINSUFacade).GetInusTarInfo(tarid)
  ...s tariDesc=$p(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum),"^",3)
  ...s uomDesc=$p(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum),"^",4)
  ...s price=$p(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum),"^",5)
  ...s qty=$p(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum),"^",6)
  ...s sum=$p(^TMP("ZYJF","BillDetail",BillNo,job,AdmRowId,taricDescdr,gnum),"^",7)
  ...s tarisum=tarisum+sum
  ...s allsum=allsum+sum
  ...s tariDescn=tariDesc
  ...s AdmPatSum=AdmPatSum+sum
  ...Do OutputRow
  ..s tariDescn="****小计****",uomDesc="",price="",qty="",sum=tarisum,ybdesc=""
  ..Do OutputRow
  ..s tariDescn="___________________________________________________________________",uomDesc="_________",price="",qty="_________",sum="",ybdesc="_______________"
  ..;s tariDescn="",uomDesc="",price="",qty="",sum="",ybdesc=""
  ..Do OutputRow
  .i JudgeBabyNum>1 d
  ..s tariDescn="其中合计",uomDesc="",price="",qty="",sum=AdmPatSum,ybdesc=""
  s tariDescn="合计",uomDesc="",price="",qty="",sum=+allsum,ybdesc=""
  Do OutputRow
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
  ;s tariDescn="合计",uomDesc="",price="",qty="",sum=+allsum,ybdesc=""
  set Data=$lb(tariDescn,uomDesc,price,qty,sum,ybdesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit
}

ClassMethod GetBillDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBillDetailExecute ]
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

Query GetBillDetail(BillNo As %String, job As %String) As %Query(ROWSPEC = "Torder:%String,Tuom:%String,Tunitprice:%String,Tqty:%String,Tprice:%String,Tybdesc:%String")
{
}

ClassMethod GetPatinforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatinforExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

ClassMethod GetPatinforExecute(ByRef qHandle As %Binary, BillNo As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  q:BillNo=""
  s admId=$p(^DHCPB(BillNo),"^",1)
  s papmiId=$p(^PAADM(admId),"^",1)
  s painfo=##class(web.UDHCJFBaseCommon).GetPatAdmInfo(admId,papmiId,BillNo)
  s zydayinfo=##class(web.UDHCJFBaseCommon).GetPatAdmInDays(admId,BillNo)
  s BillDateFrom=$p(zydayinfo,"^",1)
  s BillDateTo=$p(zydayinfo,"^",2)
  s AdmDays=$p(zydayinfo,"^",3)
  s zydatestr=BillDateFrom_" 至 "_BillDateTo_"共"_AdmDays_"天"
  d OutputRowmx
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowmx
  set Data=$lb(PapNo,PapName,Medicare,PapmiId,Sex,Address,LocDesc,zydatestr)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit
}

ClassMethod GetPatinforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatinforExecute ]
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

Query GetPatinfor(BillNo As %String) As %Query(ROWSPEC = "TPapNo:%String,TPapName:%String,TMedicare:%String,TPapmiId:%String,TSex:%String,TAddress:%String,TLocDesc:%String,Tzydatestr:%String")
{
}

ClassMethod KillBillDetailTMP(BillNo, job)
{
	k ^TMP("ZYJF","BillDetail",BillNo,job)
	q
}

ClassMethod PrtOPCatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrtOPCatDetailExecute ]
{
   //住院收费大类 : 住院费用分类名称 分类总额 自付金额
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PrtOPCatDetailExecute(ByRef qHandle As %Binary, BillNo As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.UDHCJFOperationPrint","PrtOPCatDetail","150429")
	;取分类的金额
    Set repid=$I(^CacheTemp)
    q:BillNo=""
    s ind=1
    f m=1:1:25  d
	.s Catename(m)=""
	.s Catefee(m)=""
	.s Catefeezf(m)=""
	s PatFeeCateInfo="",InPatCate="",InPatSubCate=""
	s PBTotalAmount="",PBAmountUP="",PBTotalAmountall=""
	s PBAdmDr=""
    s PBAdmDr=$p(^DHCPB(BillNo),"^",1)  
    s PBTotalAmountall=##class(UDHCJFPRINTINV).Billtotalamountall(BillNo)
	s PBTotalAmount=##class(UDHCJFPRINTINV).Billtotalamountfordt(BillNo) 
    i PBTotalAmount'=""  d
    .s PBAmountUP=##class(UDHCJFBaseCommon).RMBDXXZH("","",PBTotalAmount)
	s PatFeeCateInfo=##class(UDHCJFPRINTINV).getinpatcate0(BillNo)
	s InPatCate=$p(PatFeeCateInfo,"#",1)   ;住院费用大类
	s InPatCatedetail=$p(PatFeeCateInfo,"#",2) ;母亲住院费用分类名称--分类总额--自付金额
	s PatFeeSum=0,PatShareSum=0
	f i=1:1:$g(^tmpincate($j))  d
	.s Cate=$p(InPatCatedetail,"^",i)
	.s Catename(i)=$p(Cate,$c(2),1)    ;名称
	.s Catefee(i)=$p(Cate,$c(2),2)     ;分类总额
	.s Catefeezf(i)=$p(Cate,$c(2),3)   ;自付金额
	.s PatFeeSum=PatFeeSum+$p(Cate,$c(2),2)
	.s PatShareSum=PatShareSum+$p(Cate,$c(2),3)
	//s PBTotalAmount=PatFeeSum
    Do OutputRowcate
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowcate
	set Data=$lb(PBTotalAmountall,PBTotalAmount,PBAmountUP,$g(Catename(1)),$g(Catefee(1)),$g(Catefeezf(1)),$g(Catename(2)),$g(Catefee(2)),$g(Catefeezf(2)),$g(Catename(3)),$g(Catefee(3)),$g(Catefeezf(3)),$g(Catename(4)),$g(Catefee(4)),$g(Catefeezf(4)),$g(Catename(5)),$g(Catefee(5)),$g(Catefeezf(5)),$g(Catename(6)),$g(Catefee(6)),$g(Catefeezf(6)),$g(Catename(7)),$g(Catefee(7)),$g(Catefeezf(7)),$g(Catename(8)),$g(Catefee(8)),$g(Catefeezf(8)),$g(Catename(9)),$g(Catefee(9)),$g(Catefeezf(9)),$g(Catename(10)),$g(Catefee(10)),$g(Catefeezf(10)),$g(Catename(11)),$g(Catefee(11)),$g(Catefeezf(11)),$g(Catename(12)),$g(Catefee(12)),$g(Catefeezf(12)),$g(Catename(13)),$g(Catefee(13)),$g(Catefeezf(13)),$g(Catename(14)),$g(Catefee(14)),$g(Catefeezf(14)),$g(Catename(15)),$g(Catefee(15)),$g(Catefeezf(15)),$g(Catename(16)),$g(Catefee(16)),$g(Catefeezf(16)),$g(Catename(17)),$g(Catefee(17)),$g(Catefeezf(17)),$g(Catename(18)),$g(Catefee(18)),$g(Catefeezf(18)),$g(Catename(19)),$g(Catefee(19)),$g(Catefeezf(19)),$g(Catename(20)),$g(Catefee(20)),$g(Catefeezf(20)),$g(Catename(21)),$g(Catefee(21)),$g(Catefeezf(21)),$g(Catename(22)),$g(Catefee(22)),$g(Catefeezf(22)),$g(Catename(23)),$g(Catefee(23)),$g(Catefeezf(23)),$g(Catename(24)),$g(Catefee(24)),$g(Catefeezf(24)),$g(Catename(25)),$g(Catefee(25),$g(Catefeezf(25))))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PrtOPCatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrtOPCatDetailExecute ]
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
	Quit $$$OK
}

Query PrtOPCatDetail(BillNo As %String) As %Query(ROWSPEC = "PBTotalAmountall:%String,PBTotalAmount:%String,PBAmountUP:%String,Catename1:%String,Catefee1:%String,Catefeehz1:%String,Catename2:%String,Catefee2:%String,Catefeehz2:%String,Catename3:%String,Catefee3:%String,Catefeehz3:%String,Catename4:%String,Catefee4:%String,Catefeehz4:%String,Catename5:%String,Catefee5:%String,Catefeehz5:%String,Catename6:%String,Catefee6:%String,Catefeehz6:%String,Catename7:%String,Catefee7:%String,Catefeehz7:%String,Catename8:%String,Catefee8:%String,Catefeehz8:%String,Catename9:%String,Catefee9:%String,Catefeehz9:%String,Catename10:%String,Catefee10:%String,Catefeehz10:%String,Catename11:%String,Catefee11:%String,Catefeehz11:%String,Catename12:%String,Catefee12:%String,Catefeehz12:%String,Catename13:%String,Catefee13:%String,Catefeehz13:%String,Catename14:%String,Catefee14:%String,Catefeehz14:%String,Catename15:%String,Catefee15:%String,Catefeehz15:%String,Catename16:%String,Catefee16:%String,Catefeehz16:%String,Catename17:%String,Catefee17:%String,Catefeehz17:%String,Catename18:%String,Catefee18:%String,Catefeehz18:%String,Catename19:%String,Catefee19:%String,Catefeehz19:%String,Catename20:%String,Catefee20:%String,Catefeehz20:%String,Catename21:%String,Catefee21:%String,Catefeehz21:%String,Catename22:%String,Catefee22:%String,Catefeehz22:%String,Catename23:%String,Catefee23:%String,Catefeehz23:%String,Catename24:%String,Catefee24:%String,Catefeehz24:%String,Catename25:%String,Catefee25:%String,Catefeehz25:%String")
{
}

ClassMethod PrtSTYJJdetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrtSTYJJdetailExecute ]
{
   //收退预交金明细 : 预交金总额  支付方式  退预交金金额  退款支付方式  补预交金金额  补款支付方式
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PrtSTYJJdetailExecute(ByRef qHandle As %Binary, BillNo As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.UDHCJFOperationPrint","PrtSTYJJdetail","108265")
    Set repid=$I(^CacheTemp)
    s ind=1
    q:BillNo=""
    s PaperId="",PBAdmDr=""
    s PBAdmDr=$p(^DHCPB(BillNo),"^",1)
    //add by wangli20081119 新生儿的预交金为0
    s ordsub=""
    f  s ordsub=$o(^DHCPB(BillNo,"O",ordsub)) q:ordsub=""  d
	.q:ordsub=0
    .s oerowid=$p(^DHCPB(BillNo,"O",ordsub),"^",4)
	.;insert by cx 2008.01.16
	.s oeorderid=$p(oerowid,"||",1)
	.s oeordadm=$p(^OEORD(oeorderid),"^",1)
	.s oeordmotadm=$p(^PAADM(oeordadm),"^",75)
	.s oeordmotadm=$g(oeordmotadm)
    s PBTotalAmount=##class(UDHCJFPRINTINV).Billtotalamount(PBAdmDr) 
    i PBTotalAmount'=""  d
    .s PBAmountUP=##class(UDHCJFBaseCommon).RMBDXXZH("","",PBTotalAmount)
    ;病人预交金明细
    s DepositDetail="",PATdeposit="",PATdepositdetail="",Tamout="",Bamout="",Tpaymodestr="",Bpaymodestr=""
	s DepositDetail=##class(UDHCJFPRINTINV).depositdetail(PBAdmDr,BillNo)
	s PATdeposit=$p(DepositDetail,"^",1)
	s PATdepositdetail=$p(DepositDetail,"^",2)
	s Tamout=$p(DepositDetail,"^",3)
	s Bamout=$p(DepositDetail,"^",4)
	s Tpaymodestr=$p(DepositDetail,"^",6)
	s Bpaymodestr=$p(DepositDetail,"^",7)
	s YBamout=$p(DepositDetail,"^",9)
	s ZFamout=$p(DepositDetail,"^",10)
    Do OutputRowdetail
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowdetail
	set Data=$lb(PBTotalAmount,PBAmountUP,PATdeposit,PATdepositdetail,Tamout,Bamout,QFamout,Tpaymodestr,Bpaymodestr,YBamout,ZFamout)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PrtSTYJJdetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrtSTYJJdetailExecute ]
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
	Quit $$$OK
}

Query PrtSTYJJdetail(BillNo As %String) As %Query(ROWSPEC = "PBTotalAmount:%String,PBAmountUP:%String,PATdeposit:%String,PATdepositdetail:%String,Tamout:%String,Bamout:%String,QFamout:%String,Tpaymodestr:%String,Bpaymodestr:%String,YBamout:%String,ZFamout:%String")
{
}

ClassMethod PrtDepositClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrtDepositExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

ClassMethod PrtDepositExecute(ByRef qHandle As %Binary, yjrowid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s DepositInfo=""
  i $g(yjrowid)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
  ;;d ##class(%ResultSet).RunQuery("web.UDHCJFOperationPrint","PrtDeposit","60")
  s DepositInfo=##class(UDHCJFDeposit).getyjdetail("","",yjrowid)
  s patno=$p(DepositInfo,"^",2)
  s prtyear=$p(DepositInfo,"^",21)
  s prtmonth=$p(DepositInfo,"^",22)
  s prtday=$p(DepositInfo,"^",23)
  s prtdate=prtyear_"年"_prtmonth_"月"_prtday_"日"
  s prttime=$p(DepositInfo,"^",24)
  s prtdepno=$p(DepositInfo,"^",15)
  s patdepart=$p(DepositInfo,"^",3)
  s patnamt=$p(DepositInfo,"^",1)
  s paymode=$p(DepositInfo,"^",5)
  s upamout=$p(DepositInfo,"^",6)
  s prtamout=$p(DepositInfo,"^",4)
  s username=$p(DepositInfo,"^",25)
  q:DepositInfo=""
  Do OutputRowdep
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowdep
  set Data=$lb(patno,prtdate,prttime,prtdepno,patdepart,patnamt,paymode,upamout,prtamout,username)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit
}

ClassMethod PrtDepositFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrtDepositExecute ]
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

Query PrtDeposit(yjrowid As %String) As %Query(ROWSPEC = "patno,prtdate,prttime,prtdepno,patdepart,patnamt,paymode,upamout,prtamout,username")
{
}

ClassMethod PrtOPCatDetailBabyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrtOPCatDetailBabyExecute ]
{
   //住院收费大类 : 住院费用分类名称 分类总额 自付金额
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PrtOPCatDetailBabyExecute(ByRef qHandle As %Binary, BillNo As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.UDHCJFOperationPrint","PrtOPCatDetailBaby","156099")
	;取分类的金额
    Set repid=$I(^CacheTemp)
    q:BillNo=""
    s ind=1
    f m=1:1:25  d
	.s Catename(m)=""
	.s Catefee(m)=""
	.s Catefeezf(m)=""
	s PatFeeCateInfo="",InPatCate="",InPatSubCate=""
	s PBTotalAmount="",PBAmountUP="",PBTotalAmountall=""
	s PBAdmDr=""
    s PBAdmDr=$p(^DHCPB(BillNo),"^",1)  
    s PAPMIRowId=$p(^PAADM(PBAdmDr),"^",1)
    s PAPMIName=$p(^PAPER(PAPMIRowId,"ALL"),"^",1)
    S PAPMIName=PAPMIName_"之婴"
    s ordsub=""
    f  s ordsub=$o(^DHCPB(BillNo,"O",ordsub)) q:ordsub=""  d
	.s oerowid=$p(^DHCPB(BillNo,"O",ordsub),"^",4)
	.q:oerowid=""
	.s oeorderid=$p($G(oerowid),"||",1)
	.s oeordadm=$p(^OEORD(oeorderid),"^",1)
	.q:oeordadm=PBAdmDr
	.s ChildAdmDate=$ZD($p(^PAADM(oeordadm),"^",6),3)
	.s ChildDisDate=$ZD($p(^PAADM(oeordadm),"^",59),3)
    s PBTotalAmountall=##class(UDHCJFPRINTINV).Billtotalamountall(BillNo)
	s PBTotalAmount=##class(UDHCJFPRINTINV).Billtotalamountfordt(BillNo) 
    i PBTotalAmount'=""  d
    .s PBAmountUP=##class(UDHCJFBaseCommon).RMBDXXZH("","",PBTotalAmount)
	s PatFeeCateInfo=##class(UDHCJFPRINTINV).getinpatcate0(BillNo)
	s InPatCate=$p(PatFeeCateInfo,"#",1)   ;住院费用大类
	s InPatCatedetail=$p(PatFeeCateInfo,"#",6) ;婴儿住院费用分类名称--分类总额--自付金额
	s PatFeeSum=0,PatShareSum=0
	f i=1:1:$g(^tmpincate($j))  d
	.s Cate=$p(InPatCatedetail,"^",i)
	.s Catename(i)=$p(Cate,$c(2),1)    ;名称
	.s Catefee(i)=$p(Cate,$c(2),2)     ;分类总额
	.s Catefeezf(i)=$p(Cate,$c(2),3)   ;自付金额
	.s PatFeeSum=PatFeeSum+$p(Cate,$c(2),2)
	.s PatShareSum=PatShareSum+$p(Cate,$c(2),3)
    Do OutputRowcateBaby
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowcateBaby
	set Data=$lb(PAPMIName,PBTotalAmountall,PBTotalAmount,PBAmountUP,$g(Catename(1)),$g(Catefee(1)),$g(Catefeezf(1)),$g(Catename(2)),$g(Catefee(2)),$g(Catefeezf(2)),$g(Catename(3)),$g(Catefee(3)),$g(Catefeezf(3)),$g(Catename(4)),$g(Catefee(4)),$g(Catefeezf(4)),$g(Catename(5)),$g(Catefee(5)),$g(Catefeezf(5)),$g(Catename(6)),$g(Catefee(6)),$g(Catefeezf(6)),$g(Catename(7)),$g(Catefee(7)),$g(Catefeezf(7)),$g(Catename(8)),$g(Catefee(8)),$g(Catefeezf(8)),$g(Catename(9)),$g(Catefee(9)),$g(Catefeezf(9)),$g(Catename(10)),$g(Catefee(10)),$g(Catefeezf(10)),$g(Catename(11)),$g(Catefee(11)),$g(Catefeezf(11)),$g(Catename(12)),$g(Catefee(12)),$g(Catefeezf(12)),$g(Catename(13)),$g(Catefee(13)),$g(Catefeezf(13)),$g(Catename(14)),$g(Catefee(14)),$g(Catefeezf(14)),$g(Catename(15)),$g(Catefee(15)),$g(Catefeezf(15)),$g(Catename(16)),$g(Catefee(16)),$g(Catefeezf(16)),$g(Catename(17)),$g(Catefee(17)),$g(Catefeezf(17)),$g(Catename(18)),$g(Catefee(18)),$g(Catefeezf(18)),$g(Catename(19)),$g(Catefee(19)),$g(Catefeezf(19)),$g(Catename(20)),$g(Catefee(20)),$g(Catefeezf(20)),$g(Catename(21)),$g(Catefee(21)),$g(Catefeezf(21)),$g(Catename(22)),$g(Catefee(22)),$g(Catefeezf(22)),$g(Catename(23)),$g(Catefee(23)),$g(Catefeezf(23)),$g(Catename(24)),$g(Catefee(24)),$g(Catefeezf(24)),$g(Catename(25)),$g(Catefee(25)),$g(Catefeezf(25)),$g(PatFeeSum),$g(PatShareSum),$g(ChildAdmDate),$g(ChildDisDate))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PrtOPCatDetailBabyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrtOPCatDetailBabyExecute ]
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
	Quit $$$OK
}

Query PrtOPCatDetailBaby(BillNo As %String) As %Query(ROWSPEC = "PAPMIName:%String,PBTotalAmountall:%String,PBTotalAmount:%String,PBAmountUP:%String,Catename1:%String,Catefee1:%String,Catefeehz1:%String,Catename2:%String,Catefee2:%String,Catefeehz2:%String,Catename3:%String,Catefee3:%String,Catefeehz3:%String,Catename4:%String,Catefee4:%String,Catefeehz4:%String,Catename5:%String,Catefee5:%String,Catefeehz5:%String,Catename6:%String,Catefee6:%String,Catefeehz6:%String,Catename7:%String,Catefee7:%String,Catefeehz7:%String,Catename8:%String,Catefee8:%String,Catefeehz8:%String,Catename9:%String,Catefee9:%String,Catefeehz9:%String,Catename10:%String,Catefee10:%String,Catefeehz10:%String,Catename11:%String,Catefee11:%String,Catefeehz11:%String,Catename12:%String,Catefee12:%String,Catefeehz12:%String,Catename13:%String,Catefee13:%String,Catefeehz13:%String,Catename14:%String,Catefee14:%String,Catefeehz14:%String,Catename15:%String,Catefee15:%String,Catefeehz15:%String,Catename16:%String,Catefee16:%String,Catefeehz16:%String,Catename17:%String,Catefee17:%String,Catefeehz17:%String,Catename18:%String,Catefee18:%String,Catefeehz18:%String,Catename19:%String,Catefee19:%String,Catefeehz19:%String,Catename20:%String,Catefee20:%String,Catefeehz20:%String,Catename21:%String,Catefee21:%String,Catefeehz21:%String,Catename22:%String,Catefee22:%String,Catefeehz22:%String,Catename23:%String,Catefee23:%String,Catefeehz23:%String,Catename24:%String,Catefee24:%String,Catefeehz24:%String,Catename25:%String,Catefee25:%String,Catefeehz25:%String,PatFeeSum:%String,PatShareSum:%String,ChildAdmDate:%String,ChildDisDate:%String")
{
}

}
