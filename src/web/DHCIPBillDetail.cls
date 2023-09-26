Class web.DHCIPBillDetail Extends %RegisteredObject
{

ClassMethod FindBillDetail1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBillDetail1Execute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

ClassMethod FindBillDetail1Execute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 ;d ##class(%ResultSet).RunQuery("web.DHCIPBillDetail","FindBillDetail1","148")
  
  Set repid=$I(^CacheTemp)
  s ind=1
    ;k ^TMP("ZYJF","BillDetail",BillNo,$j)
  s sum=0,discount=0,payorshare=0,patshare=0,tarisum=0
  i EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
  s BillNo=""
  f  s BillNo=$o(^DHCPB(0,"ADM",EpisodeID,BillNo)) q:BillNo=""  d
  .s payedflag=$p(^DHCPB(BillNo),"^",16)
  .q:payedflag="P"
  .d ..SetPBDetail(BillNo)
  .s gnum=0,curid=0,all=0,blzfSum=0,grzfSum=0
  .s count=0,sumall=0,count1=0
  .s cat=""
  .f  s cat=$o(^mtemp($j,"BillDetail",cat)) q:cat=""  d  ;区分是打印收费项目还是医嘱项
  ..s taricID=""
  ..f  s taricID=$o(^mtemp($j,"BillDetail",cat,taricID)) q:taricID=""  d  ;分类Id
  ...s oldtaricDesc="",tarisum=0,tariblzfSum=0,tarigrzfSum=0
  ...s tariID=""
  ...f  s tariID=$o(^mtemp($j,"BillDetail",cat,taricID,tariID)) q:tariID=""  d  ;项目ID
  ....s price=""
  ....f  s price=$o(^mtemp($j,"BillDetail",cat,taricID,tariID,price)) q:price=""  d  ;金额
  .....q:tariID="10030"  //观察神志 无费用医嘱都对应到它，清单上不要显示 wanghc 2010-12-24

  .....i cat="IPCat" d
  ......s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
  ......s tariDesc=$p(^DHCTARI(tariID),"^",2)
 
  .....i cat="itemCat" d
  ......s taricDesc=$p(^ARC("IC",taricID),"^",2)
  ......;s taricDesc=$p(^OEC("ORCAT",ordcatid),"^",2)
  ......s tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
 
  .....s uomDesc=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",4)          //单位
  .....s qty=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",1)
  .....q:+qty=0
  .....s sum=$fn($p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",2),"",2)
  .....s tarisum=tarisum+sum
  .....s all=all+sum
  .....s ExtralFlag=""
  .....s ExtralFlag=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",10)
  .....s sumall=sumall+$fn($p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",2),"",2)
  .....s myArcimId=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",3) ;
  .....s myArcimId=$p(myArcimId,$c(1))
  .....s DrugCommonDesc=""
  .....s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
  .....i (ExtralFlag="")&(DrugCommonDesc'="") s tariDesc=DrugCommonDesc 
  .....s drugspec=##class(web.UDHCJFCOMMON).GetDrugSpec(myArcimId)
 
  .....i (drugspec'="")&(ExtralFlag="")   d
  ......;s tariDesc=tariDesc_"("_drugspec_")"
  .....;s ybdesc=##class(web.DHCINSUFacade).GetInusTarInfo(tariID)
  .....s myblzf=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",6)
  .....s mygrzf=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",7)
  .....s tariblzfSum=tariblzfSum+myblzf,tarigrzfSum=tarigrzfSum+mygrzf
  .....s blzfSum=blzfSum+myblzf,grzfSum=grzfSum+mygrzf
  .....s PhcfDesc=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",8)
  .....s PhcfDesc=$p(PhcfDesc,$c(13))
  .....s PhmnfName=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",9)
  .....Do OutputRow3
  .....s AdmRowId=$p(^mtemp($j,"BillDetail",cat,taricID,tariID,price),"^",5)
  .....s gnum=gnum+1
  .....;w !, tariID
  .....;s ^TMP("ZYJF","BillDetail",BillNo,$j,taricDesc,gnum)=tariID_"^"_taricDesc_"^"_tariDesc_"^"_uomDesc_"^"_price_"^"_qty_"^"_sum
  .....;s ^TMP("ZYJF",BillNo,$j,gnum)=taricDesc_"^"_tariDesc_"^"_price_"^"_qty_"^"_sum     ;tangtao修改 新需求无需单位
  ...s taricDesc="小计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(tarisum,"",2),ybdesc="",PhcfDesc="",PhmnfName=""
  ...s myblzf=$fn(tariblzfSum,"",2),mygrzf=$fn(tarigrzfSum,"",2)
  ...q:+sum=0
  ...Do OutputRow3
  .s taricDesc="合计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(sumall,"",2),ybdesc="" ,PhcfDesc="",PhmnfName=""
  .s myblzf=$fn(blzfSum,"",2),mygrzf=$fn(grzfSum,"",2)  ;医保比例自负，个人自费
  .s gnum=gnum+1                                                               
  .;s ^TMP("ZYJF",BillNo,$j,gnum)="合计"_"^^^^"_sum                 ;tangtao增加，新需求需要输出合计金额
  .Do OutputRow3
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow3
  s:+myblzf=0 myblzf=""
  s:+mygrzf=0 mygrzf=""
  s ^TMP("ZYJF",BillNo,$j,ind)=taricDesc_"^"_tariDesc_"^"_uomDesc_"^"_price_"^"_qty_"^"_sum_"^"_myblzf_"^"_mygrzf_"^"_PhcfDesc_"^"_PhmnfName
  set Data=$lb(taricDesc,tariDesc,uomDesc,price,qty,sum,$j,ybdesc,PhcfDesc,PhmnfName,BillNo,tariID)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit
}

ClassMethod FindBillDetail1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBillDetail1Execute ]
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

Query FindBillDetail1(EpisodeID As %String) As %Query(ROWSPEC = "Ttaridesc:%String,Torder:%String,Tuom:%String,Tunitprice:%String,Tqty:%String,Tprice:%String,Tjob:%String,Tybdesc:%String,PhcfDesc:%String,PhmnfName:%String,BillNo:%String,tariID:%String")
{
}

ClassMethod SetPBDetail(BillNo)
{
  //D ##class(web.UDHCJFBillDetail).SetPBDetail(118029)
  k ^mtemp($j,"BillDetail") 
  s mealTotalAmount=0,AdmRowId=0
  s code=##class(web.DHCHospitalCodeSet).GetHospitalCode()
  i code'="" s code=$p(code,"^",2)
  s motheradm=$p(^DHCPB(BillNo),"^",1)
  s pboSub=0,sum=0
  s allsum=0
  f  s pboSub=$o(^DHCPB(BillNo,"O",pboSub)) q:(+pboSub=0)  d
  .s oerowid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",4)   ;YYX增加，判断医嘱不存在，则过滤掉
  .s oeadm=+$p(^OEORD(+oerowid),"^",1)
  .s oeorderid=$p(oerowid,"||",1)
  .;yyx
  .//s oeordmotadm=$p(^PAADM(oeadm),"^",75)
  .//s oeordmotadm=$g(oeordmotadm)
  .//W !,oeordmotadm_"++"_oeadm
  .//i oeordmotadm'="" d
  .//.s AdmRowId=oeordmotadm
  .//e  d
  .//.s AdmRowId=oeadm
  .;yyx
  .s AdmRowId=oeadm
  .s arcimid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",3)
  .q:$g(arcimid)=""
  .s:$g(arcimid)="11220||1" mealTotalAmount=mealTotalAmount+$p($g(^DHCPB(BillNo,"O",pboSub)),"^",8)
  .q:$g(arcimid)="11220||1"  //伙食费合成一条
  .s itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
  .;i $d(^DHCJFORDITEMCATSET(0,"ItemCat",itemcat)) d
  ..;d ..GetOrder(BillNo,pboSub,arcimid,itemcat,AdmRowId)
  .;e  d
  .d ..GetDetail(BillNo,pboSub,arcimid,AdmRowId)
  
  q
}

ClassMethod GetOrder(BillNo, pboSub, arcimid, itemcat, AdmRowId)
{
  s ordcatid=$p(^ARC("IC",itemcat),"^",8)
  s ordcatdesc=$p(^OEC("ORCAT",ordcatid),"^",2)
  s orddesc=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",2)
  s PhInfo=..getdrginfo(arcimid)
  s PhcfDesc=$p(PhInfo,"^",1)
  s PhmnfName=$p(PhInfo,"^",2)
  s ordprice=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",7)
  s ordbillqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",5)
  s ordrefqty=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",6)
  s ordqty=ordbillqty+ordrefqty
  s ordtot=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",8)
  s uomId=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),8),"^",14)
  s uomDesc=$p(^CT("UOM",uomId),"^",2)
  if $d(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3))) d
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",1)=$p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",1)+ordqty
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",2)=$p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",2)+ordtot
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",3)=arcimid
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",4)=uomDesc
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",5)=AdmRowId
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",8)=PhcfDesc
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",9)=PhmnfName
  e  d
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",1)=ordqty
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",2)=ordtot
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",3)=arcimid
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",4)=uomDesc
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",5)=AdmRowId
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",8)=PhcfDesc
  .s $p(^mtemp($j,"BillDetail","itemCat",itemcat,arcimid,$fn(ordprice,"",3)),"^",9)=PhmnfName
  q
}

ClassMethod GetDetail(BillNo, pboSub, arcimid, AdmRowId)
{
  s PhInfo=..getdrginfo(arcimid)
  s PhcfDesc=$p(PhInfo,"^",1)
  s PhmnfName=$p(PhInfo,"^",2)
  s pbdSub=0 
  f  s pbdSub=$o(^DHCPB(BillNo,"O",pboSub,"D",pbdSub)) q:(+pbdSub=0)  d
  .s pbdstr=$G(^DHCPB(BillNo,"O",pboSub,"D",pbdSub))
  .s tariId=$p($g(pbdstr),"^",3) ;PBD_TARI_DR,指向DHC_TarItem
  .q:+tariId=0
  .s tariUom=$p($G(^DHCTARI(tariId)),"^",3)
  .;;wangli20080724
  .i tariUom="" s uomDesc=""
  .e  s uomDesc=$p($G(^CT("UOM",tariUom)),"^",2)
  .s taridesc=$p(^DHCTARI(tariId),"^",2)
  
  .s price=$p(pbdstr,"^",4) ;PBD_UnitPrice
  .s qty=$p(pbdstr,"^",5) ;PBD_BillQty
  .s total=$p(pbdstr,"^",7)
  .q:+total=0
  .q:$g(^DHCTARI(tariId))=""  ;有些材料项目被删除判断
  .s tarcId=$p($g(^DHCTARI(tariId)),"^",14) ;TARI_InpatCate,指向DHC_TarInpatCate
  .s taricId=$p($g(^DHCTarC("IC",tarcId)),"^",3) ;TARIC_TARTIC_DR
  .s taricDesc=$p(^DHCTarC("TIC",taricId),"^",2)
  .s PBDExtralFlag=""
  .s PBDExtralFlag=$p(pbdstr,"^",22)

  .s admReasonDr=$p(^DHCPB(BillNo),"^",4)
  .s nationalCode=+$p(^PAC("ADMREA",admReasonDr),"^",5)
  .s blzf=0,grzf=0
  .i nationalCode>0 d
  ..s ybInfo=##class(web.DHCINSUPort).PBDLinkInsu(BillNo_"||"_pboSub_"||"_pbdSub)
  ..s blzf=+$p($g(ybInfo),"^",1) ;比例自负
  ..s grzf=+$p($g(ybInfo),"^",2) ;个人自费 
  .if $d(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3))) d
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",1)=$p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",1)+qty
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",2)=$p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",2)+total
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",3)=arcimid
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",4)=uomDesc
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",5)=AdmRowId
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",6)=$p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",6)+blzf
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",7)=$p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",7)+grzf
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",8)=PhcfDesc
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",9)=PhmnfName
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",10)=PBDExtralFlag
  .e  d
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",1)=qty
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",2)=total
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",3)=arcimid
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",4)=uomDesc
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",5)=AdmRowId
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",6)=blzf
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",7)=grzf
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",8)=PhcfDesc
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",9)=PhmnfName
  ..s $p(^mtemp($j,"BillDetail","IPCat",taricId,tariId,$fn(price,"",3)),"^",10)=PBDExtralFlag
  
  q
}

/// 新需求要在打印费用明细里添加剂型和产地
/// CreatDate 2011-09-06
/// Creator wangjian
/// Input 医嘱项Rowid
ClassMethod getdrginfo(itemrowid)
{
 s Subscript=+itemrowid
 s Version=$p(itemrowid,"||",2)
 s PhcdfDr=$p(^ARCIM(Subscript,Version,1),"^",12)
 q:PhcdfDr="" ""_"^"_""
 s DrgMast=+PhcdfDr
 s PHCDFSub=$p(PhcdfDr,"||",2)
 i $d(^PHCD(DrgMast,"DF",PHCDFSub,1)) d
 .s PhcfDr=$p(^PHCD(DrgMast,"DF",PHCDFSub,1),"^",1) ;指向表phc_form
 .s PhcfDesc=$p(^PHCF( PhcfDr),"^",2) ;剂型
 .s PhmnfDr=$p(^PHCD(DrgMast,2),"^",4) ;phc_drgmast   指向表PH_Manufacturer 
 .s PhmnfName=$p(^PHMNF(PhmnfDr),"^",2) ;产地
 e  d
 .s PhcfDesc="" ;剂型
 .s PhmnfName="" ;产地
 q PhcfDesc_"^"_PhmnfName
}

ClassMethod FindTariAboutOeordExecute(ByRef qHandle As %Binary, Billno, TARIDR) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    k ^TMP("zyjf","BillItem","Oeord",$j)
    i (Billno="")!(TARIDR="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
   s Oldoerowid=""
   s Pbosub="",pqty=0,pamt=0
   f  s Pbosub=$o(^DHCPB(0,"TARI",TARIDR,Billno,Pbosub)) q:Pbosub=""  d
   .q:$g(Pbosub)=""
   .s oerowid=$p($g(^DHCPB(Billno,"O",Pbosub)),"^",4)
   .s pborowid=Billno_"||"_Pbosub
   .q:$d(^TMP("zyjf","BillItem","Oeord",$j,oerowid))
   .s ^TMP("zyjf","BillItem","Oeord",$j,oerowid)=""
   .i Oldoerowid'=oerowid  s Oldoerowid=oerowid
   .s ordrowid=+oerowid ,ordsub=$p(oerowid,"||",2)
   .s SttDate=$p(^OEORD(ordrowid,"I",ordsub,1),"^",9)
   .s SttTime=$p(^OEORD(ordrowid,"I",ordsub,1),"^",10)
   .s arcim=$p(^OEORD(ordrowid,"I",ordsub,1),"^",2)
   .s itmdesc=$p((^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2) ;医嘱名称
   .s EndDate=$p(^OEORD(ordrowid,"I",ordsub,3),"^",34)
   .i $g(EndDate)'="" s EndDate=$zd(EndDate,3) ;结束时间
   .s SttDate=$zd(SttDate,3)_$zt(SttTime,1) ;开始时间
   .s PBOESub=0,pamt=0,pqty=0
   .f  s PBOESub=$o(^DHCPBi(0,"OEORI",oerowid,Billno,PBOESub)) q:PBOESub=""  d
   ..s punit=$p(^DHCPB(Billno,"O",PBOESub),"^",7),pqty=pqty+$p(^DHCPB(Billno,"O",PBOESub),"^",5)+$p(^DHCPB(Billno,"O",PBOESub),"^",6),pamt=pamt+$p(^DHCPB(Billno,"O",PBOESub),"^",8) ;单价，计费量，小计
   ..;w !,Billno_"||"_Pbosub_"^"_pqty_"^"_pamt
   .;s punit=pamt/pqty
   .s num=$p($g(^OEORD(ordrowid,"I",ordsub,2)),"^",1),uom0=$p($g(^OEORD(ordrowid,"I",ordsub,2)),"^",3)
   .s uom=$s(uom0'="":$p(^CT("UOM",uom0),"^",2),uom0="":"")
   .s dose=num_uom ;处方量
   .s pfreq0=$p($g(^OEORD(ordrowid,"I",ordsub,2)),"^",4)
   .s pfreq=$s(pfreq0'="":$p(^PHCFR(pfreq0),"^",1),1:"") ;频次
   .s admLocdr=$p(^OEORD(ordrowid,"I",ordsub,9),"^",2)
   .s admLoc=$s($g(admLocdr)'="":$p(^CTLOC(admLocdr),"^",2),$g(admLocdr)="":"")
   .i admLoc["-" s admLoc=$p(admLoc,"-",2)
   .d OutputRow1
   k ^TMP("zyjf","BillItem","Oeord",$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(admLoc,itmdesc,dose,pfreq,SttDate,EndDate,pqty,$fn(punit,"",4),$fn(pamt,"",2),oerowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindTariAboutOeordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTariAboutOeordExecute ]
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

ClassMethod FindTariAboutOeordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTariAboutOeordExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindTariAboutOeord(Billno, TARIDR) As %Query(ROWSPEC = "TadmLoc:%String,Titmdesc:%String,Tdose:%String,Tpfreq:%String,TSttDate:%String,TEndDate:%String,Tpqty:%String,Tpunit:%String,Tpamt:%String,Toerowid")
{
}

ClassMethod FindOeordexecInfoExecute(ByRef qHandle As %Binary, Oeordrowid, StDate, EndDate) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
   
  i Oeordrowid=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
  i StDate["/" s StDate=$zdh(StDate,4)
  i EndDate["/" s EndDate=$zdh(EndDate,4)
  s oeord=+Oeordrowid ,oeordsub=$p(Oeordrowid,"||",2)
  s OEChildsub=""
  f  s OEChildsub=$o(^OEORD(oeord,"I",oeordsub,"X",OEChildsub)) q:OEChildsub=""  d
  .q:OEChildsub=0
  .q:$g(^OEORD(oeord,"I",oeordsub,"X",OEChildsub))=""
  .s ctpcpdr=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",15)
  .s ctpcp=$s($g(ctpcpdr)'="":$p(^CTPCP(ctpcpdr,1),"^",2),$g(ctpcpdr)="":"") ;执行人
  .s OrderStatusdr=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",16)
  .s OrderStatus=$s($g(OrderStatusdr)'="":$p(^OEC("STAT",OrderStatusdr),"^",2),1:"未执行") ;状态
  .s DateExecuted=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",19)
  .s TimeExecuted=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",20)
  .;s OeoreLocdr=2  ;$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub,"NUR"),"^",5)
  .s OeoreLocdr=$p(^OEORD(oeord,"I",oeordsub,1),"^",3)
  .s OeoreLoc=$s($g(OeoreLocdr)'="":$p(^CTLOC(OeoreLocdr),"^",2),$g(OeoreLocdr)="":"")
  .i $g(DateExecuted)'="" s DateExecuted=$zd(DateExecuted,3)_" "_$zt(TimeExecuted,1) ;执行时间
  .s TExStDate = $p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",1) // OEORE_ExStDate 要求执行时间
  .q:((TExStDate<StDate)&(StDate'=""))
  .q:((TExStDate>EndDate)&(EndDate'=""))
  .s TExStTime = $p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",2) //OEORE_ExStTime
  .i $g(TExStDate)'="" s TExStDate=$zd(TExStDate,3)_" "_$zt(TExStTime,1)
  .s Patamt="0.00"
  .s BillOrdrowid=""
  .s OEExcRowID=oeord_"||"_oeordsub_"||"_OEChildsub
  .s PBRowid=""  f  s PBRowid=$o(^DHCPB(0,"OEEXC",OEExcRowID,PBRowid)) q:PBRowid=""  d
  ..s OrdSub=""   f  s OrdSub=$o(^DHCPB(0,"OEEXC",OEExcRowID,PBRowid,OrdSub)) q:OrdSub=""  d
  ...i $g(^DHCPB(PBRowid,"O",OrdSub))'=""  s Patamt=$fn($p(^DHCPB(PBRowid,"O",OrdSub),"^",8),"",2)
  ...s BillOrdrowid=$g(PBRowid)_"||"_$g(OrdSub)
  .s TBillFlag=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",6)
  .i TBillFlag="TB" s TBillFlag="未计费"
  .i TBillFlag="B" s TBillFlag="已计费"
  .i TBillFlag="I" s TBillFlag="需要退费"
  .i TBillFlag="R" s TBillFlag="已退费"
  .i TBillFlag="P" s TBillFlag="已结算"
  .s DspRowID="",TColQty=0,TRefQty=0
  .f  s DspRowID=$o(^DHCOEDISQTY(0,"OEORE",OEExcRowID,DspRowID)) q:DspRowID=""  d
  ..s disp=^DHCOEDISQTY(DspRowID)
  ..s dspstatus=$P(disp,"^",7)
  ..s DspQty=$P(disp,"^",11)
  ..i dspstatus="C" Do
  ...s TColQty=TColQty+DspQty
  ..If dspstatus="R" Do
  ...s TRefQty=TRefQty+DspQty
	
  .d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DateExecuted,OrderStatus,ctpcp,OeoreLoc,TExStDate,Patamt,BillOrdrowid,TBillFlag,TColQty,RefQty,OEExcRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOeordexecInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOeordexecInfoExecute ]
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

ClassMethod FindOeordexecInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOeordexecInfoExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindOeordexecInfo(Oeordrowid, StDate, EndDate) As %Query(ROWSPEC = "DateExecuted:%String,OrderStatus:%String,ctpcp:%String,OeoreLoc:%String,TExStDate:%String,TPatamt:%String,TBillOrdrowid:%String,TBillFlag,TCollectQty,TRefundQty,TOrdExcRowID")
{
}

}
