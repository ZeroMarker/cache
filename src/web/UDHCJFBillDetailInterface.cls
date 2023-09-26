/// Creator:yyx
/// CreateDate:2012-09-11
/// Function:与医政组接口,按就诊返回结算过的账单的费用清单
Class web.UDHCJFBillDetailInterface Extends %RegisteredObject
{

ClassMethod FindBillDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBillDetailExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

/// 入参：Adm
/// 返回：日期	项目收费分类名称	费用名称	数量	单价	总计
ClassMethod FindBillDetailExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
 ;d ##class(%ResultSet).RunQuery("web.UDHCJFBillDetailInterface","FindBillDetail","4")
  Set repid=$I(^CacheTemp)
  s ind=1
  s sum=0,discount=0,payorshare=0,patshare=0,tarisum=0
  k ^mtemp($j,"BillDetail")
  s BillNo=""
  f  s BillNo=$o(^DHCPB(0,"ADM",Adm,BillNo)) q:BillNo=""  d
  .s PayFlag=$p(^DHCPB(BillNo),"^",16)
  .q:PayFlag'="P"
  .d ..SetPBDetail(Adm,BillNo)
  s gnum=0,curid=0,all=0,blzfSum=0,grzfSum=0
  s count=0,sumall=0,count1=0

  s billdate=""
  f  s billdate=$o(^mtemp($j,"BillDetail",billdate)) q:billdate=""  d
  .s taricID=""
  .f  s taricID=$o(^mtemp($j,"BillDetail",billdate,taricID)) q:taricID=""  d  ;分类Id
  ..s oldtaricDesc="",tarisum=0,tariblzfSum=0,tarigrzfSum=0
  ..s tariID=""
  ..f  s tariID=$o(^mtemp($j,"BillDetail",billdate,taricID,tariID)) q:tariID=""  d  ;项目ID
  ...s price=""
  ...f  s price=$o(^mtemp($j,"BillDetail",billdate,taricID,tariID,price)) q:price=""  d  ;金额
  ....s taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
  ....s tariDesc=$p(^DHCTARI(tariID),"^",2)
  ....s uomDesc=$p(^mtemp($j,"BillDetail",billdate,taricID,tariID,price),"^",4)          //单位
  ....s qty=$p(^mtemp($j,"BillDetail",billdate,taricID,tariID,price),"^",1)
  ....q:+qty=0
  ....s sum=$fn($p(^mtemp($j,"BillDetail",billdate,taricID,tariID,price),"^",2),"",2)
  ....s tarisum=tarisum+sum
  ....s all=all+sum
  ....s sumall=sumall+$fn($p(^mtemp($j,"BillDetail",billdate,taricID,tariID,price),"^",2),"",2)
  ....s myArcimId=$p(^mtemp($j,"BillDetail",billdate,taricID,tariID,price),"^",3) ;
  ....s myArcimId=$p(myArcimId,$c(1))
  ....s DrugCommonDesc=""
  ....s DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
  ....s:DrugCommonDesc'="" tariDesc=DrugCommonDesc 
  ....i billdate'="" s billdate1=$zd(billdate,3)
  ....Do OutputRow
  ...;s taricDesc="小计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(tarisum,"",2)
  ...;q:+sum=0
  ...;Do OutputRow
   
  s taricDesc="合计",tariDesc="",uomDesc="",price="",qty="",sum=$fn(sumall,"",2)
  s gnum=gnum+1                                                               
  Do OutputRow
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
 
  set Data=$lb(billdate1,taricDesc,tariDesc,uomDesc,qty,price,sum)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit
}

ClassMethod FindBillDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBillDetailExecute ]
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

Query FindBillDetail(Adm As %String) As %Query(ROWSPEC = "TBillDate:%String,Ttaridesc:%String,Torder:%String,Tuom:%String,Tqty:%String,Tunitprice:%String,Tprice:%String") [ SqlProc ]
{
}

ClassMethod SetPBDetail(Adm, BillNo)
{
  //D ##class(web.UDHCJFBillDetail).SetPBDetail(118029)
  s pboSub=0,sum=0
  s allsum=0
  f  s pboSub=$o(^DHCPB(BillNo,"O",pboSub)) q:(+pboSub=0)  d
  .s oerowid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",4)   ;YYX增加，判断医嘱不存在，则过滤掉
  .s oeadm=+$p(^OEORD(+oerowid),"^",1)
  .s oeorderid=$p(oerowid,"||",1)
  .s arcimid=$p($g(^DHCPB(BillNo,"O",pboSub)),"^",3)
  .d ..GetDetail(BillNo,pboSub,arcimid,Adm)
  q
}

ClassMethod GetDetail(BillNo, pboSub, arcimid, AdmRowId)
{
 
  s pbdSub=0 
  f  s pbdSub=$o(^DHCPB(BillNo,"O",pboSub,"D",pbdSub)) q:(+pbdSub=0)  d
  .s pbdstr=$G(^DHCPB(BillNo,"O",pboSub,"D",pbdSub))
  .s tariId=$p($g(pbdstr),"^",3) ;PBD_TARI_DR,指向DHC_TarItem
  .q:+tariId=0
  .s tariUom=$p($G(^DHCTARI(tariId)),"^",3)
  .i tariUom="" s uomDesc=""
  .e  s uomDesc=$p($G(^CT("UOM",tariUom)),"^",2)
  .s taridesc=$p(^DHCTARI(tariId),"^",2)
  .s price=$p(pbdstr,"^",4) ;PBD_UnitPrice
  .s qty=$p(pbdstr,"^",5) ;PBD_BillQty
  .s total=$p(pbdstr,"^",7)
  .s billdate=$p(pbdstr,"^",11)
  .q:+total=0
  .;q:$g(^DHCTARI(tariId))=""  ;有些材料项目被删除判断
  .s tarcId=$p($g(^DHCTARI(tariId)),"^",14) ;TARI_InpatCate,指向DHC_TarInpatCate
  .s taricId=$p($g(^DHCTarC("IC",tarcId)),"^",3) ;TARIC_TARTIC_DR
  .s taricDesc=$p(^DHCTarC("TIC",taricId),"^",2)
  .s admReasonDr=$p(^DHCPB(BillNo),"^",4)
  .s nationalCode=+$p(^PAC("ADMREA",admReasonDr),"^",5)
  .i nationalCode>0 d
  .if $d(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3))) d
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",1)=$p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",1)+qty
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",2)=$p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",2)+total
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",3)=arcimid
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",4)=uomDesc
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",5)=AdmRowId
  .e  d
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",1)=qty
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",2)=total
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",3)=arcimid
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",4)=uomDesc
  ..s $p(^mtemp($j,"BillDetail",billdate,taricId,tariId,$fn(price,"",3)),"^",5)=AdmRowId
  
  q
}

}
