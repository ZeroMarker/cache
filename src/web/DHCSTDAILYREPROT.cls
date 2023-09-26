Import sqluser

/// 药房日报统计与查询
Class web.DHCSTDAILYREPROT Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 取进程号
ClassMethod StatDispPID(input)
{
	q $I(^DHCSTPHARMACY("DailyReportPID"))
}

/// LastUpdate:yunhaibao,20160126,添加参数,用于重新生成日报
/// w ##class(web.DHCSTDAILYREPROT).CreateDailyReportData("2020-03-04","2020-03-17")
ClassMethod CreateDailyReportData(stdate = "", enddate = "", locrowid = "")
{
  i stdate["-" s stdate=$zdh(stdate,3)
  i enddate["-" s enddate=$zdh(enddate,3)
  i stdate["/" s stdate=$zdh(stdate,4)
  i enddate["/" s enddate=$zdh(enddate,4)
  i stdate="" s stdate=+$h-1
  i enddate="" s enddate=+$h-1
  s sttime=""
  s endtime=""
  s user="1"
  s ctloctype="D"
  s ctlocdr=""
  f  s ctlocdr=$o(^CTLOC(0,"LocType",ctloctype,ctlocdr)) q:ctlocdr=""  d
  .q:(locrowid'="")&&(locrowid'=ctlocdr)
  .s dateto=$p(^CTLOC(ctlocdr),"^",25)
  .i dateto'=""  q:dateto'<+$h
  .s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
  .s input=ctlocdr_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_user
  .s ret=..CreateReportData(input)
  .
  q "Over"
}

/// 按天生成日报数据
/// Input:科室ID^开始日期^开始时间(可为空)^结束日期^结束时间(可为空)^用户ID
/// Return:操作的记录数
/// w ##Class(web.DHCSTDAILYREPROT).CreateReportData(Input)
ClassMethod CreateReportData(input)
{
	s phalocdr=$p(input,"^",1)
	q:phalocdr="" 0
	s stdate=$p(input,"^",2)
	q:stdate="" 0
	s sttime=$p(input,"^",3)
	s endate=$p(input,"^",4)
	q:endate="" 0
	s endtime=$p(input,"^",5)
	s user=$p(input,"^",6)
	q:user="" 0
	s typestr="P^F^Y^H"
	s pid=..StatDispPID()
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(phalocdr)
    s HospID=$p(CustStr,"^",5)
    s CustID=$p(CustStr,"^",1)    
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
    ...s inclb=$p(^DHCINTR(intr),"^",7)
    ...q:inclb=""
    ...S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    ...q:LocID'=phalocdr
	...s intrtime=$p(^DHCINTR(intr),"^",3)
    ...q:(date=stdate)&(sttime'="")&(intrtime<sttime)
    ...q:(date=endate)&(endtime'="")&(intrtime>endtime)
    ...s inci=+inclb
    ...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s baseuom=$p(^INCI(inci,1),"^",10) ;baseuom
	...s qty=$p(^DHCINTR(intr),"^",6)     ;qty for transaction
	...s uom=$p(^DHCINTR(intr),"^",10)    ;uom
	...s sp=$p(^DHCINTR(intr),"^",14)
	...s spamt=$p(^DHCINTR(intr),"^",8)
	...s rp=$p(^DHCINTR(intr),"^",16)
	...s rpamt=$p(^DHCINTR(intr),"^",17)
	...i +sp=0 d
	....s sp=##class(web.DHCSTPRICE).GetSp(inclb,date,baseuom,HospID,"") ;sale price of base uom
	...i +rp=0 d
	....s rp=##Class(web.DHCSTPRICE).GetRp(inclb,date,baseuom,HospID,"")
	...i (+rpamt=0)!(+spamt=0) d
	....s amt=..GetAmt(type,pointer,intr)
	....i +rpamt=0 s rpamt=$p(amt,"^",1)
	....i +spamt=0 s spamt=$p(amt,"^",2)
	...s fac=##class(DHCSTCOMMONSRV).UOMFac(uom,baseuom) 
	...s qty=qty*fac
	...s index=phalocdr_"^"_date
	...s indexinci=sp_"^"_rp_"^"_inci
	...//按药品存
	...i '$d(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type)) d
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type)=$g(qty)_"^"_$g(spamt)_"^"_$g(rpamt)
	...e  d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type),"^",1)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type),"^",1)+qty
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type),"^",2)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type),"^",2)+spamt
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type),"^",3)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type),"^",3)+rpamt
	...//按医生科室存
	...s indexdocloc=..GetTransDocLoc(intr)
	...i '$d(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc)) d
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc)=$g(qty)_"^"_$g(spamt)_"^"_$g(rpamt)
	...e  d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc),"^",1)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc),"^",1)+qty
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc),"^",2)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc),"^",2)+spamt
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc),"^",3)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Doc",index,indexinci,type,indexdocloc),"^",3)+rpamt
	...//按病区存
	...s indexward=..GetTransWardDr(intr)
	...
	...i '$d(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward)) d
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward)=$g(qty)_"^"_$g(spamt)_"^"_$g(rpamt)
	...e  d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward),"^",1)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward),"^",1)+qty
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward),"^",2)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward),"^",2)+spamt
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward),"^",3)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Ward",index,indexinci,type,indexward),"^",3)+rpamt
	
	 tstart
	 s err=0
     s n=0
     s index=""
     f  s index=$o(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index)) q:(index="")||(err'=0)  d
     .s phalocdr=$p(index,"^",1)
     .s date=$p(index,"^",2)
     .i $D(^DHCSDR(0,"DateLoc",date,phalocdr)) d
     ..s dailydr=$o(^DHCSDR(0,"DateLoc",date,phalocdr,""))
     ..&sql(delete from DHC_StkDaily where SD_RowID=:dailydr)
     ..i SQLCODE'=0  tro 
	 ..i SQLCODE'=0 s err=-1
	 .q:err'=0
     .k PLIST
	 .s PLIST(2)=user
	 .s PLIST(3)=date
	 .s PLIST(4)=""
	 .s PLIST(5)=phalocdr
	 .&sql(INSERT INTO DHC_StkDaily  VALUES :PLIST())
	 .i SQLCODE'=0  tro 
	 .i SQLCODE'=0 s err=-1
	 .s dailydr=+%ROWID
	 .s indexinci=""
	 .f  s indexinci=$o(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci)) q:indexinci=""  d
	 ..s sp=$p(indexinci,"^",1)
	 ..s rp=$p(indexinci,"^",2)
	 ..s inci=$p(indexinci,"^",3)
	 ..s dispdata=..GetTransTotalAmt(pid,index,indexinci,"P,F")
	 ..s dispqty=$p(dispdata,"^",1)
	 ..s dispspamt=$p(dispdata,"^",2)
	 ..s disprpamt=$p(dispdata,"^",3)
	 ..s retdata=..GetTransTotalAmt(pid,index,indexinci,"Y,H")
	 ..s retqty=$p(retdata,"^",1)
	 ..s retspamt=$p(retdata,"^",2)
	 ..s retrpamt=$p(retdata,"^",3)
     ..k PLIST
     ..s PLIST(0)=dailydr
	 ..s PLIST(2)=+$o(^DHCSDR(dailydr,"R",""),-1)+1
	 ..s PLIST(3)=inci
	 ..s PLIST(4)=rp
	 ..s PLIST(5)=sp
	 ..s PLIST(6)=dispqty
	 ..s PLIST(7)=disprpamt
	 ..s PLIST(8)=dispspamt
	 ..s PLIST(9)=retqty
	 ..s PLIST(10)=retrpamt
	 ..s PLIST(11)=retspamt
	 ..&sql(INSERT INTO DHC_StkDailyReport  VALUES :PLIST())
	 ..i SQLCODE'=0  tro 
	 ..i SQLCODE'=0 s err=-2
	 ..q:err'=0
	 ..s dailyitm=dailydr_"||"_PLIST(2)
	 ..s err=..SaveReportTrans(pid,dailyitm,index,indexinci,"Doc")
	 ..i err'=0  tro 
	 ..q:err'=0
	 ..s err=..SaveReportTrans(pid,dailyitm,index,indexinci,"Ward")
	 ..i err'=0  tro 
	 ..q:err'=0
	 ..s n=n+1
	 
	 k ^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid)
	 
     q:err'=0 err
     
     tcommit
	 q n
}

/// 获取业务金额
ClassMethod GetAmt(type, pointer, dhcintr)
{
	 s oldspamt=0 
	 q:pointer="" "^^" 
	 i type="G" {
	    s INGR=+pointer
	    s CH=$p(pointer,"||",2)
	    s sp=$p(^DHCINGR(INGR,"GRI",CH),"^",32)
	    s qty=$p(^DHCINGR(INGR,"GRI",CH),"^",4)
	    s spamt=sp*qty
	    s rpamt=$p(^DHCINGR(INGR,"GRI",CH),"^",31)
	 }
	 elseif type="R" {
	 s INGRT=+pointer
	    s CH=$p(pointer,"||",2)
	    s rpamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",4)
	    s spamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",9)
	    s oldspamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",16)    
	 }
	 elseif type="T" {
	    s INIT=+pointer
	    s CH=$p(pointer,"||",2)
	    s rpamt=(-1)*$p(^DHCINIT(INIT,"ITI",CH),"^",16)
	    s spamt=(-1)*$p(^DHCINIT(INIT,"ITI",CH),"^",18)
	 }
	 elseif type="K" {
	    s INIT=+pointer
	    s CH=$p(pointer,"||",2)
	    s rpamt=$p(^DHCINIT(INIT,"ITI",CH),"^",16)
	    s spamt=$p(^DHCINIT(INIT,"ITI",CH),"^",18)
	 }
	 elseif type="P" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
	 }
	 elseif type="Y" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
	 }
	 elseif type="F" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
	 } 
	 elseif type="H" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
	 }
	 elseif type="S" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)      
	 }
	 elseif type="Z" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)
	 }
	 elseif type="A" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)
	 }
	 elseif type="D" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)
	 }
	 elseif type="C" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)
	 }
	 elseif type="M" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)
	 }
	 elseif type="X" {
	    s rpamt=..GetRpAmt(dhcintr)
	    s spamt=$p(^DHCINTR(dhcintr),"^",8)
	 }
	 else {
		 
	 }
	 q $g(rpamt)_"^"_$g(spamt)_"^"_$g(oldspamt)
}

/// 获取业务总和
ClassMethod GetTransTotalAmt(pid, index, indexinci, typestr)
{
	  s totalqty=0,totalamount=0,totalrpamount=0
	  s cnt=$l(typestr,",")
	  f i=1:1:cnt d
	  .s type=$p(typestr,",",i)
	  .s data=$g(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,"Inci",index,indexinci,type))
	  .q:data=""
	  .s qty=$p(data,"^",1),totalqty=totalqty+qty
	  .s amount=$p(data,"^",2),totalamount=totalamount+amount
	  .s rpamt=$p(data,"^",3),totalrpamount=totalrpamount+rpamt  // 数量不取舍，金额直接从业务表取
	  q +$g(totalqty)_"^"_+$g(totalamount)_"^"_+$g(totalrpamount)
}

/// 取进价金额
ClassMethod GetRpAmt(dhcintr)
{
	 s rpamt=$p(^DHCINTR(dhcintr),"^",17)
	 q:+rpamt'=0 rpamt
	 s qty=$p(^DHCINTR(dhcintr),"^",6)
	 s inclb=$p(^DHCINTR(dhcintr),"^",7)
	 s uom=$p(^DHCINTR(dhcintr),"^",10)
	 s date=$p(^DHCINTR(dhcintr),"^",2)
	 s inci=+inclb
	 s baseuom=$p(^INCI(inci,1),"^",10)
	 ///格式化
	 S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	 s CustStr=##class(DHCSTCOMMO).GetLocCust(LocID)
	 s CustID=$p(CustStr,"^",1)
	 s HospID=$p(CustStr,"^",5)
	 S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
	 S StkTypeDesc=$P(CatGrpStr,"^",4)
	 //S Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"	//CS药库版
	 S Perv="^^^"_StkTypeDesc_"^"_$G(HospID)_"^DHC"	//BS药库版，zhouyg 20141208
	 s rp=$p(^DHCINTR(dhcintr),"^",16)
	 i +rp=0 d
	 .s rp=##Class(web.DHCSTPRICE).GetRp(inclb,date,uom,HospID,"")
	 s rpamt=rp*qty
	 ;s rp=##class(DHCSTPRICE).GetInciBasicRp(+inclb,date,baseuom,HospID)
	 //s rp=##class(web.DHCSTPRICE).LastInPrice(inclb,baseuom)
     //s rp=##Class(DHCSTCOMMPARA).GetNumbDec(rp,Perv,"FmtRP",2)/
	 //s rpamt=rp*qty
	 S rpamt=+##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtRA",1)
	 
	 q rpamt
}

/// 查询日报数据
/// Input:科室ID^开始日期^结束日期
/// Return:操作的记录数
/// d ##class(%ResultSet).RunQuery("web.DHCSTDAILYREPROT","StatDispData","62913","62921","307","","","0","")
ClassMethod StatDispDataExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, dispcatval, incirowid, statflag, input) As %Status
{
	
	
	s pid=..StatDispPID()
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:StartDate="" $$$OK
    s phalocdr=displocrowid
    s stdate=StartDate
    s enddate=EndDate
    s grpval=$p(input,"^",1)  //类组
    s poisonval=$p(input,"^",2) //管制分类
    s stkcatval=$p(input,"^",3) //库存分类
    s onlydisp=$p(input,"^",4) //仅发药,仅退药 1发,2退
    s onlyout=$p(input,"^",5)  //仅门诊,仅住院 1门,2住
    
    
    //统计发药数据
    s typestr="PDoc^FDoc"
    i statflag="1" s typestr="PWard" 
    i statflag'="1" d
    .i onlyout=1 s typestr="PDoc"
    .i onlyout=2 s typestr="FDoc"
    i onlydisp="2" s typestr=""
    
    
    s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.q:type=""
    .f date=stdate:1:enddate d
    ..s dailydr=""
    ..f  s dailydr=$o(^DHCSDR(0,"DateLoc",date,phalocdr,dailydr)) q:dailydr=""  d
	...s chl=""
    ...f  s chl=$o(^DHCSDR(0,"Type",type,dailydr,chl)) q:chl=""  d
    ....s sub=""
    ....f  s sub=$o(^DHCSDR(0,"Type",type,dailydr,chl,sub)) q:sub=""  d
    .....s inci=$p(^DHCSDR(dailydr,"R",chl),"^",1)
    .....q:(incirowid'="")&(inci'=incirowid)
    .....s dispcat=..GetDispCatByInci(inci)
    .....q:(dispcatval'="")&('$f(dispcatval,dispcat))
    .....s incscdr=$p(^INCI(inci,2),"^",2)  //库存分类rowid
    .....i stkcatval'="" q:incscdr'=stkcatval
    .....s stkgrp=..getStkGrpByInci(inci)
    .....i grpval'="" q:grpval'=stkgrp
    .....s tmppoison=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)  //管制分类
    .....s poisondr=$p(tmppoison,"^",1)
    .....
    .....i poisonval'="" q:poisonval'=poisondr
    .....s rp=$p(^DHCSDR(dailydr,"R",chl),"^",2)
    .....s sp=$p(^DHCSDR(dailydr,"R",chl),"^",3)
    .....s qty=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",2)
    .....s rpamt=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",3)
    .....s spamt=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",4)
    .....s pointer=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",1)
    .....
    .....s data=inci_"^"_rp_"^"_sp_"^"_qty_"^"_rpamt_"^"_spamt_"^"_0_"^"_0_"^"_0
    .....s index=inci_"^"_rp_"^"_sp
    .....i '$d(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index)) d
    ......s ^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index)=data
    .....e  d
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",4)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",4)+qty
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",5)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",5)+rpamt
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",6)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",6)+spamt
    .....//
    .....i '$d(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer)) d
    ......s ^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer)=rpamt_"^"_spamt
    .....e  d
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",1)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",1)+rpamt
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",2)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",2)+spamt

    //统计退药数据
    s typestr="YDoc^HDoc"
    i statflag="1" s typestr="YWard"
    i statflag'="1" d
    .i onlyout=1 s typestr="YDoc"
    .i onlyout=2 s typestr="HDoc"
    i onlydisp="1" s typestr=""

    s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.q:type=""
    .f date=stdate:1:enddate d
    ..s dailydr=""
    ..f  s dailydr=$o(^DHCSDR(0,"DateLoc",date,phalocdr,dailydr)) q:dailydr=""  d
	...s chl=""
    ...f  s chl=$o(^DHCSDR(0,"Type",type,dailydr,chl)) q:chl=""  d
    ....s sub=""
    ....f  s sub=$o(^DHCSDR(0,"Type",type,dailydr,chl,sub)) q:sub=""  d
    .....s inci=$p(^DHCSDR(dailydr,"R",chl),"^",1)
    .....q:(incirowid'="")&(inci'=incirowid)
    .....s dispcat=..GetDispCatByInci(inci)
    .....q:(dispcatval'="")&('$f(dispcatval,dispcat))
    .....s incscdr=$p(^INCI(inci,2),"^",2)  //库存分类rowid
    .....i stkcatval'="" q:incscdr'=stkcatval
    .....s stkgrp=..getStkGrpByInci(inci)
    .....i grpval'="" q:grpval'=stkgrp
    .....s tmppoison=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)  //管制分类
    .....s poisondr=$p(tmppoison,"^",1)
    .....i poisonval'="" q:poisonval'=poisondr
    .....s rp=$p(^DHCSDR(dailydr,"R",chl),"^",2)
    .....s sp=$p(^DHCSDR(dailydr,"R",chl),"^",3)
    .....s qty=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",2)
    .....s rpamt=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",3)
    .....s spamt=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",4)
    .....s pointer=$p(^DHCSDR(dailydr,"R",chl,"T",sub),"^",1)
    .....
    .....s data=inci_"^"_rp_"^"_sp_"^"_0_"^"_0_"^"_0_"^"_qty_"^"_rpamt_"^"_spamt
    .....s index=inci_"^"_rp_"^"_sp
    .....
    .....i '$d(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index)) d
    ......s ^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index)=data
    .....e  d
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",7)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",7)+qty
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",8)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",8)+rpamt
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",9)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer,index),"^",9)+spamt
    .....//
    .....i '$d(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer)) d
    ......s ^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer)=rpamt_"^"_spamt
    .....e  d
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",1)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",1)+rpamt
    ......s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",2)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer),"^",2)+spamt
    //
    s totalrpamt=0,totalspamt=0
    s pointer=""
    f  s pointer=$o(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",pointer)) q:pointer=""  d
    .s ctlocdesc=$p($g(^CTLOC(pointer)),"^",2) 
    .i $f(ctlocdesc,"-") s ctlocdesc=$p(ctlocdesc,"-",2)
    .i ctlocdesc="" s ctlocdesc="不详"
    .s data=^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt",pointer)
    .s rpamt=$p(data,"^",1)
    .s totalrpamt=totalrpamt+rpamt
    .s spamt=$p(data,"^",2)
    .s totalspamt=totalspamt+spamt
    .d OutRow
    d OutRowTotal
    k ^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Amt")
	Quit $$$OK
OutRow
	set Data=$lb(ctlocdesc,pointer,pid,rpamt,spamt)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
OutRowTotal
	set Data=$lb("1合计","",pid,totalrpamt,totalspamt)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod StatDispDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatDispDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish 
fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query StatDispData(StartDate, EndDate, displocrowid, dispcatval, incirowid, statflag, input) As %Query(ROWSPEC = "AdmLocDesc:%String,AdmLocRowid:%String,ProcessID:%String,TRpAmt,TSpAmt") [ SqlProc ]
{
}

ClassMethod StatDispDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatDispDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod PackUomQtyDesc(incicode As %String, qty As %String) As %String
{
     q:qty=0 0
	 s result=""
	 &sql(select inci_ctuom_dr,inci_ctuom_purch_dr into :buom,:puom from inc_itm where inci_code=:incicode)
	 q:SQLCODE ""
	 s buom=+$g(buom) q:buom'>0 ""
	 s puom=+$g(puom) q:puom'>0 ""
	 s buomdesc=$p(^CT("UOM",buom),"^",2)
	 s puomdesc=$p(^CT("UOM",puom),"^",2)
 
	 i buom=puom q qty_buomdesc
	 s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
	 s packqty=qty\fac
	 s restqty=qty-(packqty*fac)
	 i $zabs(packqty)>0 d
	 . s result=packqty_puomdesc
	 i $zabs(restqty)>0 d
	 . i result'="" d
	 . . s result=result_" \ "_restqty_buomdesc
	 . e  d
	 . . s result=restqty_buomdesc
	 q result
}

/// 获取台帐中的医嘱ID
ClassMethod GetTransOrdItem(intr) As %String
{
	s orditm=""
	s type=$p(^DHCINTR(intr),"^",1)
	s pointer=$p(^DHCINTR(intr),"^",9) 
	i type="P" d
	.s orditm=$p(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",7)
	i type="Y" d
	.s orditm=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",1)
	i type="F" d
	.s orditm=$p(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)),"^",5)
	i type="H" d
	.s orditm=$p(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)),"^",2)
	q orditm
}

/// 取台帐业务中的医生科室
ClassMethod GetTransDocLoc(intr) As %String
{
	s orditm=..GetTransOrdItem(intr)
	q:orditm="" "不详"
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s doclocdr=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
    q doclocdr
}

/// 取台帐业务中的病区科室
ClassMethod GetTransWardDr(intr) As %String
{

	 //6.9
	 /*
	s inclb=$p(^DHCINTR(intr),"^",7)
    S phalocdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    s doclocdr=..GetTransDocLoc(intr)
    i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phalocdr,doclocdr)=1 q doclocdr
	s orditm=..GetTransOrdItem(intr)
	q:orditm="" "不详"
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s wardinfo=##class(web.DHCSTPCHCOLLS).getOrdWard(orditm)
	s warddr=$p(wardinfo,"^",1)
	q:warddr="" "不详"
	s wardlocdr=$p(^PAWARD(warddr),"^",5)
    */
    
    //7.0
    s pointer=$p(^DHCINTR(intr),"^",9)
    s inclb=$p(^DHCINTR(intr),"^",7)
    s type=$p(^DHCINTR(intr),"^",1)
    i type="P" d
	.s orditm=$p(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",7)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S phalocdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    .s doclocdr=$p($g(^OEORD(ord,"I",itm,7)),"^",2) 
    .//i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phalocdr,doclocdr)=1 S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
    .//e  d
    .//.s warddr=$p(^DHCPHAC(+pointer),"^",4)
    .//.s wardlocdr=$p(^PAWARD(warddr),"^",5)
    .s warddr=$p(^DHCPHAC(+pointer),"^",4)   //2020-03-17 yangsj  修改获取病区科室id方式
    .i warddr'="" s wardlocdr=$p(^PAWARD(warddr),"^",5)
    .e  S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
 	
	i type="Y" d
	.s orditm=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",1)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S dodis=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",13)
	.S phalocdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    .s doclocdr=$p($g(^OEORD(ord,"I",itm,7)),"^",2)   
    .i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phalocdr,doclocdr)=1 S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
    .e  d
    ..s wardlocdr=$p(^DHCOEDISQTY(dodis),"^",22)
	
	i type="F" d
	.s orditm=$p(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)),"^",5)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
	
	i type="H" d
	.s orditm=$p(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)),"^",2)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
	
	
	q wardlocdr
}

/// 保存存日报trans表
ClassMethod SaveReportTrans(pid, dailyitm, index, indexinci, indexflag) As %String
{
	s typestr="P^F^Y^H"
	s cnt=$l(typestr,"^")
	s err=0
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.s docloc=""
	.f  s docloc=$o(^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,indexflag,index,indexinci,type,docloc)) q:(docloc="")||(err'=0)  d
	..s data=^TMP("DHCST","DHCSTDAILYREPROT","CreateReportData",pid,indexflag,index,indexinci,type,docloc)
	..s qty=$p(data,"^",1)
	..s spamt=$p(data,"^",2)
	..s rpamt=$p(data,"^",3)
	..k PLIST
	..s PLIST(0)=dailyitm
	..s PLIST(2)=+$o(^DHCSDR(+dailyitm,"R",$p(dailyitm,"||",2),"T",""),-1)+1
	..s PLIST(3)=docloc
	..s PLIST(4)=qty
	..s PLIST(5)=rpamt
	..s PLIST(6)=spamt
	..s PLIST(7)=type_indexflag
	..&sql(INSERT INTO DHC_StkDailyReportTrans  VALUES :PLIST())
	..i SQLCODE'=0 s err=-3
	..q:err'=0
	q err
}

/// 发药统计明细
/// d ##class(%ResultSet).RunQuery("web.DHCSTDAILYREPROT","StatDispData","62979","62979","98")
ClassMethod StatDispItmDataExecute(ByRef qHandle As %Binary, ProcessID, AdmLocRowid) As %Status
{
    
    s pid=ProcessID
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1 
    q:ProcessID="" $$$OK
    q:AdmLocRowid="" $$$OK
    
    s disptotalamt=0
    s disptotalrpamt=0
    s rettotalamt=0
    s rettotalrpamt=0
    s totalamt=0
    s totalrpamt=0
    s disptotalnum=0
    s rettottalnum=0
    
    k ^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci")
    s cnt=$l(AdmLocRowid,"^")
    f i=1:1:cnt d
    .s admloc=$p(AdmLocRowid,"^",i)
    .q:admloc=""
    .s pointer=admloc
    .s index=""
    .f  s index=$o(^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",admloc,index)) q:index=""  d
    ..s inci=$p(index,"^",1)
    ..s rp=$p(index,"^",2)
    ..s sp=$p(index,"^",3)
    ..s data=^TMP("DHCST","DHCSTDAILYREPROT","StatDispData",pid,"Inci",admloc,index)
    ..s dispqty=$p(data,"^",4)
    ..s disprpamt=$p(data,"^",5)
    ..s dispspamt=$p(data,"^",6)
    ..s retqty=$p(data,"^",7)
    ..s retrpamt=$p(data,"^",8)
    ..s retspamt=$p(data,"^",9)
    ..s index=inci_"^"_rp_"^"_sp
    ..s data=dispqty_"^"_dispspamt_"^"_disprpamt_"^"_retqty_"^"_retspamt_"^"_retrpamt
    ..i '$d(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index)) d
    ...s ^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index)=data
    ..e  d
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",1)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",1)+dispqty
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",2)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",2)+dispspamt
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",3)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",3)+disprpamt
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",4)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",4)+retqty
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",5)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",5)+retspamt
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",6)=$p(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index),"^",6)+retrpamt
    
    s sumtotalrpamt=0
    s sumtotalamt=0
    s sumtotalqty=0
    s totalqty=0
    s totalamt=0
    s totalrpamt=0
    s index=""
    f  s index=$o(^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index)) q:index=""  d
    .s totalqty=0
    .s totalamt=0
    .s totalrpamt=0
    .s inci=$p(index,"^",1)
    .s rp=$p(index,"^",2)
    .s sp=$p(index,"^",3)
    .s data=^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci",index)
    .s dispqty=$p(data,"^",1)
    .s dispspamt=$p(data,"^",2)
    .s disprpamt=$p(data,"^",3)
    .s retqty=$p(data,"^",4)
    .s retspamt=$p(data,"^",5)
    .s retrpamt=$p(data,"^",6)
    .s incicode=$p(^INCI(inci,1),"^",1)
    .s incidesc=$p(^INCI(inci,1),"^",2)
    .s puomdr=$p(^INCI(inci,3),"^",6)
    .s puomdesc=$p(^CT("UOM",puomdr),"^",2)
    .s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
    .s phcform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
    .s spec=##class(web.DHCSTKUTIL).GetSpec(inci) 	        //规格
    .s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家
    .s totalamt=totalamt+dispspamt+retspamt
    .s totalrpamt=totalrpamt+disprpamt+retrpamt
    .s totalqty=totalqty+dispqty+retqty
    .s sumtotalamt=sumtotalamt+totalamt
    .s sumtotalrpamt=sumtotalrpamt+totalrpamt
    .s sumtotalqty=sumtotalqty+totalqty
    .d OutRow
    d OutRowTotal
    k ^TMP("DHCST","DHCSTDAILYREPROT","StatDispItmData",pid,"Inci")
	Quit $$$OK
OutRow
	set Data=$lb(incicode,incidesc,puomdesc,-dispqty,-retqty,genedesc,phcform,spec,manf,sp,rp,-totalamt,-totalrpamt,-totalqty)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
OutRowTotal
	set Data=$lb("合计","","","","","","","","","","",-sumtotalamt,-sumtotalrpamt,-sumtotalqty)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod StatDispItmDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatDispItmDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish 
fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query StatDispItmData(ProcessID, AdmLocRowid) As %Query(ROWSPEC = "DispItmCode,DispItmDesc,Uom,DispQty,RetQty,Tgeneric,TPhcfDesc,TBarCode,TManf,TPhciPrice,Trprice,Amount,Trpamt,Total") [ SqlProc ]
{
}

ClassMethod StatDispItmDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatDispItmDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 获取医嘱所属类别
ClassMethod GetDispCatByInci(inci As %String) As %String
{

	 s arcitm=$p(^INCI(inci,1),"^",3)
	 q:arcitm="" ""
	 s sub=$p(arcitm,"||",1)
	 s ver=$p(arcitm,"||",2)
	 q:'$d(^ARCIM(sub,ver,1)) ""
	 s ordcat=$p(^ARCIM(sub,ver,1),"^",10)
	 q:ordcat="" ""
	 s catcode=$p(^ARC("IC",ordcat),"^",1)
	 q ..GetCat(catcode)
}

ClassMethod GetCat(CATCODE As %String) As %String
{

	 s CATCODE=$$ALPHAUP^SSUTIL4(CATCODE)
	 s ordcatdr=$o(^ARC("IC",0,"Code",CATCODE,"")) q:ordcatdr="" ""
	 s SDG=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:SDG="" ""
	 s dispcat=$p(^DHCSTDRUGGRP(SDG),"^",1)
	 q dispcat
}

/// Descript:	取药品类组
/// CreateDate:	2012-12-12
/// Input:		inci-库存项rowid
/// Return:		类组rowid
ClassMethod getStkGrpByInci(inci) As %String
{

	q:inci="" ""
	s incsc=$p(^INCI(inci,2),"^",2)
	q:incsc="" ""
	q:'$d(^DHCSCG("STKCAT",incsc)) ""
	s grpid=$o(^DHCSCG("STKCAT",incsc,0))
	q grpid
}

/// 生成住院工作量数据
ClassMethod CreateDataTMP()
{
	s stdate=+$h-1
    s enddate=+$h-1
	s locdr=""
	f  s locdr=$o(^DHCPL(0,"Loc",locdr)) q:locdr=""  d
	.s ret=##class(web.DHCSTDAILYREPROT).CreateWorkData(stdate, enddate,locdr)
	b  //91
	//
	q ""
}

/// 生成住院工作量数据
ClassMethod CreatePhaWorkData()
{
	s stdate=+$h-1
    s enddate=+$h-1
	s locdr=""
	f  s locdr=$o(^DHCPL(0,"Loc",locdr)) q:locdr=""  d
	.s ret=##class(web.DHCSTDAILYREPROT).CreateWorkData(stdate, enddate,locdr)
	q ""
}

/// 生成住院工作量数据
/// w ##class(web.DHCSTDAILYREPROT).CreateWorkData(62913,62913,312)
ClassMethod CreateWorkData(stdate, endate, phalocdr)
{
	
	s typestr="P"
	s pid=..StatDispPID()
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(phalocdr)
    s HospID=$p(CustStr,"^",5)
    s CustID=$p(CustStr,"^",1)
    
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s ssuer=$p(^DHCINTR(intr),"^",11)
    ...s inclb=$p(^DHCINTR(intr),"^",7)
    ...q:inclb=""
    ...S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    ...q:LocID'=phalocdr
	...s intrtime=$p(^DHCINTR(intr),"^",3)
    ...s inci=+inclb
    ...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s baseuom=$p(^INCI(inci,1),"^",10) ;baseuom
	...s qty=$p(^DHCINTR(intr),"^",6)     ;qty for transaction
	...s uom=$p(^DHCINTR(intr),"^",10)    ;uom
	...s sp=##class(DHCSTCOMMONSRV).GetPriceElse(inci,date,baseuom,HospID) ;sale price of base uom
	...s amt=..GetAmt(type,pointer,intr)
	...s rpamt=$p(amt,"^",1)
	...s spamt=$p(amt,"^",2)
	...s fac=##class(DHCSTCOMMONSRV).UOMFac(uom,baseuom) 
	...s qty=qty*fac
	...s index=phalocdr_"^"_date_"^"_ssuer
	...s indexinci=inci
	...s indexpointer=$p(pointer,"||",1)_"||"_$p(pointer,"||",2)
	...//发药金额
	...i $d(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)) d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",1)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",1)+rpamt
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",2)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",2)+spamt
	...e  d
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)=rpamt_"^"_spamt_"^"_0_"^"_0_"^"_0   //发药进价金额,售价金额,发药品种数,出院带药进价金额,出院带药售价金额
	...//品种数
	...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"DispInci",index,indexpointer)) d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",3)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",3)+1
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"DispInci",index,indexpointer)=""
	...s pri=..GetTransPriority(intr)
	...//出院带药
	...i pri="OUT"  d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",4)= $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",4)+rpamt
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",5)= $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",5)+spamt
	...//处方(草药,门急)
	...s ws=0,prenum=0,dosenum=0,cookprenum=0,cookdosesum=0,outprenum=0,outdosenum=0
	...s pointer=+$p(^DHCINTR(intr),"^",9)
	...s prescno=..GetTransPrescNo(intr)
	...i prescno="" s prescno="z"
	...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PrescNo",index,prescno)) D
	....s predata=..GetPrescData(intr)
	....s ws=$p(predata,"^",1)     ;草药味数
	....s prenum=$p(predata,"^",2)    ;处方张数
	....s dosenum=$p(predata,"^",3)   ;处方剂数
	....s cookprenum=$p(predata,"^",4)    ;代煎处方张数
	....s cookdosesum=$p(predata,"^",5) ;代煎剂数
    ....s outprenum=$p(predata,"^",6) ;出院带药张数
    ....s outdosenum=$p(predata,"^",7) ;出院带药剂数
    ....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PrescNo",index,prescno)=""
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",6)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",6)+ws
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",7)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",7)+prenum
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",8)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",8)+dosenum
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",9)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",9)+cookprenum
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",10)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",10)+cookdosesum
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",11)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",11)+outprenum
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",12)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",12)+outdosenum
    ...//发药单数
    ...s dispno=$p(^DHCPHAC(+pointer),"^",14)
    ...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"NO",dispno)) d
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",23)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",23)+1
    ....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"NO",dispno)=""
    ...//配药信息 
    ...s cuserdr=$p(^DHCPHAC(+pointer),"^",13)  //第二发药人
    ...q:cuserdr=""
    ...s index=phalocdr_"^"_date_"^"_cuserdr
    ...//配药品种数
	...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PYInci",index,indexpointer)) d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",24)=+$p($g(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)),"^",24)+1
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PYInci",index,indexpointer)=""
	...//配药金额
	...i $d(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)) d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",25)=+$p($g(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)),"^",25)+rpamt
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",26)=+$p($g(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)),"^",26)+spamt
	...//配药单数
	...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PYNO",dispno)) d
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",27)=+$p($g(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)),"^",27)+1
    ....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PYNO",dispno)="" 
    ...//配药处方数
    ...s pyperscindex=phalocdr_"^"_date_"^"_cuserdr_"^"_prescno
	...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PYPRESCNO",pyperscindex)) d
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",29)=+$p($g(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)),"^",29)+prenum
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",30)=+$p($g(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)),"^",30)+dosenum
    ....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PYPRESCNO",pyperscindex)=""
    ....
    
    //退药
    s typestr="Y"
    s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s ssuer=$p(^DHCINTR(intr),"^",11)
    ...s inclb=$p(^DHCINTR(intr),"^",7)
    ...q:inclb=""
    ...S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    ...q:LocID'=phalocdr
	...s intrtime=$p(^DHCINTR(intr),"^",3)
    ...s inci=+inclb
    ...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s baseuom=$p(^INCI(inci,1),"^",10) ;baseuom
	...s qty=$p(^DHCINTR(intr),"^",6)     ;qty for transaction
	...s uom=$p(^DHCINTR(intr),"^",10)    ;uom
	...s sp=##class(DHCSTCOMMONSRV).GetPriceElse(inci,date,baseuom,HospID) ;sale price of base uom
	...s amt=..GetAmt(type,pointer,intr)
	...s rpamt=$p(amt,"^",1)
	...s spamt=$p(amt,"^",2)
	...s fac=##class(DHCSTCOMMONSRV).UOMFac(uom,baseuom) 
	...s qty=qty*fac
	...s index=phalocdr_"^"_date_"^"_ssuer
	...s indexinci=inci
	...s indexpointer=$p(pointer,"||",1)_"||"_$p(pointer,"||",2)
	...//退药金额
	...i $d(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)) d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",13)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",13)+rpamt
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",14)=$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",14)+spamt
	...e  d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",13)=rpamt_"^"_spamt_"^"_0   //发药进价金额,售价金额,发药品种数
	...//品种数
	...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"RetInci",index,indexpointer)) d
	....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",15)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",15)+1
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"RetInci",index,indexpointer)=""
	...//
	...s ws=0,prenum=0,dosenum=0,cookprenum=0,cookdosesum=0,outprenum=0,outdosenum=0
	...s pointer=+$p(^DHCINTR(intr),"^",9)
	...s prescno=..GetTransPrescNo(intr)
	...i prescno="" s prescno="z"
	...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PrescNo",pointer,prescno)) D
	....s predata=..GetPrescData(intr)
	....s ws=$p(predata,"^",1)     ;草药味数
	....s prenum=$p(predata,"^",2)    ;处方张数
	....s dosenum=$p(predata,"^",3)   ;处方剂数
	....s cookprenum=$p(predata,"^",4)    ;代煎处方张数
	....s cookdosesum=$p(predata,"^",5) ;代煎剂数
	....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"PrescNo",pointer,prescno)=""
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",16)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",16)+ws
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",17)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",17)+prenum
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",18)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",18)+dosenum
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",19)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",19)+cookprenum
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",20)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",20)+cookdosesum
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",21)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",21)+outprenum
    ...s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",22)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",22)+outdosenum
    ...//退药单号
    ...s retno=$p(^PHARET(+pointer),"^",7) 
    ...i '$D(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"RNO",retno)) d
    ....s $p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",28)=+$p(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index),"^",28)+1
    ....s ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"RNO",retno)=""
    ...//w !,intr
     
     
    //
    tstart
    s ret=0
    s index=""
    f  s index=$o(^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)) q:(index="")||(ret'=0)  d
    .s data=^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid,"Itm",index)
    .s phalocdr=$p(index,"^",1)
    .s createdate=$p(index,"^",2)
    .s ssuer=$p(index,"^",3)
    .s ssuername=$p(^SSU("SSUSR",ssuer),"^",2)
    .s disprpamt=$p(data,"^",1)
    .s dispamt=$p(data,"^",2)  
    .s dispnum=$p(data,"^",3) 
    .s dispoutrpamt=$p(data,"^",4) 
    .s dispoutspamt=$p(data,"^",5)
    .s dispws=$p(data,"^",6)     ;草药味数
	.s dispprenum=$p(data,"^",7)    ;处方张数
	.s dispdosenum=$p(data,"^",8)   ;处方剂数
	.s dispcookprenum=$p(data,"^",9)    ;代煎处方张数
	.s dispcookdosesum=$p(data,"^",10) ;代煎剂数
    .s dispoutprenum=$p(data,"^",11) ;出院带药张数
    .s dispoutdosenum=$p(data,"^",12) ;出院带药剂数
    .s retrpamt=$p(data,"^",13)
    .s retamt=$p(data,"^",14)  
    .s retnum=$p(data,"^",15) 
    .s retws=$p(data,"^",16)     ;草药味数
	.s retprenum=$p(data,"^",17)    ;处方张数
	.s retdosenum=$p(data,"^",18)   ;处方剂数
	.s retcookprenum=$p(data,"^",19)    ;代煎处方张数
	.s retcookdosesum=$p(data,"^",20) ;代煎剂数
    .s retoutprenum=$p(data,"^",21) ;出院带药张数
    .s retoutdosenum=$p(data,"^",22) ;出院带药剂数
    .s dispnonum=$p(data,"^",23) ;发药单号数
    .s pynum=$p(data,"^",24) ;配药品种数
    .s pyrpamt=$p(data,"^",25) ;配药进价金额
    .s pyamt=$p(data,"^",26) ;配药金额
    .s pynonum=$p(data,"^",27) ;发药单号数
    .s retnonum=$p(data,"^",28) ;退药单号数
    .s pyprenum=$p(data,"^",29) ;配药处方张数
    .s pydosenum=$p(data,"^",30) ;配药处方剂数
    .k PLIST
    .s PLIST(2)=ssuer
    .s PLIST(3)=phalocdr
    .s PLIST(4)=dispnum
    .s PLIST(5)=dispamt
    .s PLIST(6)=disprpamt
    .s PLIST(7)=dispprenum
    .s PLIST(8)=dispdosenum
    .s PLIST(9)=retnum
    .s PLIST(10)=dispcookprenum
    .s PLIST(11)=dispcookdosesum
    .s PLIST(12)=0
    .s PLIST(13)=0
    .s PLIST(14)=dispprenum
    .s PLIST(15)=dispdosenum
    .s PLIST(16)=0
    .s PLIST(17)=0
    .s PLIST(18)=retamt
    .s PLIST(19)=retrpamt
    .s PLIST(20)=retprenum
    .s PLIST(21)=retdosenum
    .s PLIST(22)=retcookprenum
    .s PLIST(23)=retcookdosesum
    .s PLIST(24)=0
    .s PLIST(25)=0
	.s PLIST(26)=createdate
	.s PLIST(27)=dispnonum
	.s PLIST(28)=pynum
	.s PLIST(29)=pyrpamt
	.s PLIST(30)=pyamt
	.s PLIST(31)=pynonum
	.s PLIST(32)=retnonum
	.s PLIST(33)=dispws
	.s PLIST(34)=pyprenum
	.s PLIST(35)=pydosenum
	.&sql(INSERT INTO DHC_PhaWorkLoad  VALUES :PLIST())
	.i SQLCODE'=0  tro 
	.i SQLCODE'=0 s ret=-2
	k ^TMP("DHCST","DHCSTDAILYREPROT","CreateWorkData",pid)
	q:ret'=0 ret
	tcommit
	q ret
}

ClassMethod GetTransPriority(intr) As %String
{
	
	s orditm=..GetTransOrdItem(intr)
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s pr=+$p(^OEORD(ord,"I",chl,1),"^",8)
	q:pr=0 ""
	s priority=$p(^OECPR(pr),"^",1)
	q priority
}

ClassMethod GetTransPrescNo(intr) As %String
{
	s orditm=..GetTransOrdItem(intr)
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	q prescno
}

/// 获取处方信息(草药处方,门诊处方)
ClassMethod GetPrescData(intr)
{
	s orditm=..GetTransOrdItem(intr)
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)

	s ws=0     ;草药味数
	s prenum=0   ;处方张数
	s dosenum=0   ;处方剂数
	s cookprenum=0    ;代煎处方张数
	s cookdosesum=0 ;代煎剂数
    s outprenum=0 ;出院带药张数
    s outdosenum=0 ;出院带药剂数

	s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)  ;处方号
	q:prescno="" 0
	s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	q:queid="" 0    
	q:'$d(^PAQUE1(queid,"DHC")) 0 ;过滤非中草药
	s ord=""
    f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
    .s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
    ..s oeori=ord_"||"_itm
    ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    ..s dspstatus=$p(^DHCOEDISQTY(dsp),"^",7)
    ..Q:dspstatus'="C"
    ..s ws=ws+1
    
    s prenum=1 //处方数
    s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
    s dosenum=$p(^PHCDU(durdr),"^",2) ;剂数
 
    //出院带药
    s priority=..GetTransPriority(intr)
    i priority="OUT" d
    .s outprenum=1
    .s outdosenum=dosenum
    //代煎
    s cookprenum=0
    s cookdosesum=0
    s cookmode=$p(^PAQUE1(queid,"DHC"),"^",15)
    
    i cookmode["代煎" d
    .s cookprenum=1
    .s cookdosesum=dosenum
    .
    
	q ws_"^"_prenum_"^"_dosenum_"^"_cookprenum_"^"_cookdosesum_"^"_outprenum_"^"_outdosenum
}

}
