/// Creator:yyx
/// CreateDate:2010-05-11
/// Function  :在所有病人预订完成并录入系统，生成并打印厨房生产与送餐汇总表
Class DHCBILL.Diet.DHCIPMealBookMealPrint Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindMealBookInfoByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealBookInfoByDateExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :yyx
/// CreateDate:2010-05-11
/// Function  :汇总某天的订餐记录
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem
/// Input     :BookDate:订餐日期；MealModality:餐谱形态
/// OutPut    :病区，订餐的数量
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealBookMealPrint","FindMealBookInfoByDate","2010-05-13","6")
ClassMethod FindMealBookInfoByDateExecute(ByRef qHandle As %Binary, BookDate As %String, MealModality As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i $g(MealModality)="" Set qHandle=$lb(0,repid,0) Quit $$$OK   
    k ^TMP("DHCIPMealBookMealPrint",$j)
    i BookDate["-" s BookDate=$zdh(BookDate,3)
    
    s MOrdRowID=""
    f  s MOrdRowID=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID)) q:MOrdRowID=""  d
    .s ChildSub=0
    .f  s ChildSub=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID,ChildSub)) q:ChildSub=""  d
    ..s MealItmRowID=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",1)
    ..s BookMealModalityID=$p(^DHCIPMEALITEM(MealItmRowID),"^",4)
    ..q:(MealModality'=BookMealModalityID)
    ..s BookQty=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",5)
    ..s BookWard=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",8)
    ..s ^TMP("DHCIPMealBookMealPrint",$j,BookWard,MealItmRowID)=+$g(^TMP("DHCIPMealBookMealPrint",$j,BookWard,MealItmRowID))+BookQty
    ..s ^TMP("DHCIPMealBookMealPrint",$j,"Ward",BookWard)=""
    ..s ^TMP("DHCIPMealBookMealPrint",$j,"Menu",MealItmRowID)=""
    
    s MealItmStr=""
    s OutMealItmRowID="0",Num=0
    f  s OutMealItmRowID=$o(^TMP("DHCIPMealBookMealPrint",$j,"Menu",OutMealItmRowID)) q:OutMealItmRowID=""  d
    .s MealItmDesc=$p(^DHCIPMEALITEM(OutMealItmRowID),"^",2)
    .s Num=Num+1
    .s OutStr(Num)=MealItmDesc
   
    s OutWardDesc="病区"
    f i=(Num+1):1:30 d
    .s OutStr(i)=""
    d OutputRow1
    k OutStr
    s OutWardRowID="0"
    f  s OutWardRowID=$o(^TMP("DHCIPMealBookMealPrint",$j,"Ward",OutWardRowID)) q:OutWardRowID=""  d 
    .s OutWardDesc=$p(^PAWARD(OutWardRowID),"^",2)
    .i OutWardDesc["-" s OutWardDesc=$p(OutWardDesc,"-",2)
    .s OutMealItmRowID="0",num=0,OutStr=""
    .f  s OutMealItmRowID=$o(^TMP("DHCIPMealBookMealPrint",$j,"Menu",OutMealItmRowID)) q:OutMealItmRowID=""  d
    ..s num=num+1
    ..s OutStr(num)=$g(^TMP("DHCIPMealBookMealPrint",$j,OutWardRowID,OutMealItmRowID))
    .d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(OutWardDesc,$g(OutStr(1)),$g(OutStr(2)),$g(OutStr(3)),$g(OutStr(4)),$g(OutStr(5)),$g(OutStr(6)),$g(OutStr(7)),$g(OutStr(8)),$g(OutStr(9)),$g(OutStr(10)),$g(OutStr(11)),$g(OutStr(12)),$g(OutStr(13)),$g(OutStr(14)),$g(OutStr(15)),$g(OutStr(16)),$g(OutStr(17)),$g(OutStr(18)),$g(OutStr(19)),$g(OutStr(20)),$g(OutStr(21)),$g(OutStr(22)),$g(OutStr(23)),$g(OutStr(24)),$g(OutStr(25)),$g(OutStr(26)),$g(OutStr(27)),$g(OutStr(28)),$g(OutStr(29)),$g(OutStr(30)))
 	b
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealBookInfoByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealBookInfoByDateExecute ]
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

Query FindMealBookInfoByDate(BookDate As %String, MealModality As %String) As %Query(ROWSPEC = "warddesc,itm1,itm2,itm3,itm4,itm5,itm6,itm7,itm8,itm9,itm10,itm11,itm12,itm13,itm14,itm15,itm16,itm17,itm18,itm19,itm20,itm21,itm22,itm23,itm24,itm25,itm26,itm27,itm28,itm29,itm30")
{
}

ClassMethod FindMealBookInfoByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealBookInfoByWardExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :yyx
/// CreateDate:2010-05-17
/// Function  :查询某天的病区的订餐记录
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem
/// Input     :BookDate:订餐日期；BookWard:病区
/// OutPut    :病人姓名，床号，菜名，数量
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealBookMealPrint","FindMealBookInfoByWard","2010-12-11","3")
ClassMethod FindMealBookInfoByWardExecute(ByRef qHandle As %Binary, BookDate As %String, BookWard As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i $g(BookDate)="" Set qHandle=$lb(0,repid,0) Quit $$$OK   
    k ^TMP("DHCIPMealBookMealPrint",$j)
    i BookDate["-" s BookDate=$zdh(BookDate,3)
    s MOrdRowID=""
    f  s MOrdRowID=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID)) q:MOrdRowID=""  d
    .s MOrdAdm=$p(^DHCIPMEALORDER(MOrdRowID),"^",1)
    .s ChildSub=0
    .f  s ChildSub=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID,ChildSub)) q:ChildSub=""  d
    ..s MealItmRowID=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",1)
    ..s BookMealModalityID=$p(^DHCIPMEALITEM(MealItmRowID),"^",4)
    ..;q:(MealModality'=BookMealModalityID)
    ..s OrdQty=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",5)
    ..s OrdWard=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",8)
    ..q:(OrdWard'=BookWard)&(BookWard'="")
    ..s ^TMP("DHCIPMealBookMealPrint",$j,MOrdAdm,MealItmRowID)=+$g(^TMP("DHCIPMealBookMealPrint",$j,MOrdAdm,MealItmRowID))+OrdQty
    ..s ^TMP("DHCIPMealBookMealPrint",$j,"Pat",MOrdAdm)=""
    ..s ^TMP("DHCIPMealBookMealPrint",$j,"Menu",MealItmRowID)=""
    
    s MealItmStr=""
    s OutMealItmRowID="0",Num=0
    f  s OutMealItmRowID=$o(^TMP("DHCIPMealBookMealPrint",$j,"Menu",OutMealItmRowID)) q:OutMealItmRowID=""  d
    .s MealItmDesc=$p(^DHCIPMEALITEM(OutMealItmRowID),"^",2)
    .s Num=Num+1
    .s OutStr(Num)=MealItmDesc
    
    s AdmWardDesc="病区"
    s PatInfo="病人信息"
    f i=(Num+1):1:30 d
    .s OutStr(i)=""
    d OutputRow1
    k OutStr
    s OutAdmRowID="0"
    f  s OutAdmRowID=$o(^TMP("DHCIPMealBookMealPrint",$j,"Pat",OutAdmRowID)) q:OutAdmRowID=""  d 
    .s PapmiRowID=$p(^PAADM(OutAdmRowID),"^",1)
    .s PatInfo=$p(^PAPER(PapmiRowID,"ALL"),"^",1)
    .s AdmWard=$p(^PAADM(OutAdmRowID),"^",70)
	.s dischgDate = $p(^PAADM(OutAdmRowID),"^",17)
	.s flag=0
	.s:dischgDate'="" flag=(BookDate>dischgDate)
	.q:flag			;add by wanghc 2010-12-21且小于出院时间的帐单
    .s AdmWardDesc=$p($p(^PAWARD(AdmWard),"^",2),"-",2)
    .s BedRowid=$p(^PAADM(OutAdmRowID),"^",73)
	.if BedRowid'="" d
	..s BedCode=$p(^PAWARD($p(BedRowid,"||",1),"BED",$p(BedRowid,"||",2)),"^",1)
	.s PatInfo=PatInfo_" "_$g(BedCode)
    .s OutMealItmRowID="0",num=0,OutStr=""
    .f  s OutMealItmRowID=$o(^TMP("DHCIPMealBookMealPrint",$j,"Menu",OutMealItmRowID)) q:OutMealItmRowID=""  d
    ..s num=num+1
    ..s OutStr(num)=$g(^TMP("DHCIPMealBookMealPrint",$j,OutAdmRowID,OutMealItmRowID))
    .;d OutputRow1
    .;test
    .f i=1:1:10 d
    ..d OutputRow1 
    .;test
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(AdmWardDesc,PatInfo,$g(OutStr(1)),$g(OutStr(2)),$g(OutStr(3)),$g(OutStr(4)),$g(OutStr(5)),$g(OutStr(6)),$g(OutStr(7)),$g(OutStr(8)),$g(OutStr(9)),$g(OutStr(10)),$g(OutStr(11)),$g(OutStr(12)),$g(OutStr(13)),$g(OutStr(14)),$g(OutStr(15)),$g(OutStr(16)),$g(OutStr(17)),$g(OutStr(18)),$g(OutStr(19)),$g(OutStr(20)),$g(OutStr(21)),$g(OutStr(22)),$g(OutStr(23)),$g(OutStr(24)),$g(OutStr(25)),$g(OutStr(26)),$g(OutStr(27)),$g(OutStr(28)),$g(OutStr(29)),$g(OutStr(30)))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealBookInfoByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealBookInfoByWardExecute ]
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

Query FindMealBookInfoByWard(BookDate As %String, BookWard As %String) As %Query(ROWSPEC = "warddesc,patinfo,itm1,itm2,itm3,itm4,itm5,itm6,itm7,itm8,itm9,itm10,itm11,itm12,itm13,itm14,itm15,itm16,itm17,itm18,itm19,itm20,itm21,itm22,itm23,itm24,itm25,itm26,itm27,itm28,itm29,itm30")
{
}

ClassMethod FindPatMealBookInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatMealBookInfoExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator :yyx
/// CreateDate:2010-05-17
/// Function  :查询某天的病区的订餐记录
/// Table     :dhc_ipmealorder,dhc_ipmealorderitem
/// Input     :BookDate:订餐日期；BookWard:病区
/// OutPut    :病人姓名，床号，菜名，数量
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealBookMealPrint","FindPatMealBookInfo","2010-04-22","")
ClassMethod FindPatMealBookInfoExecute(ByRef qHandle As %Binary, BookStDate As %String, BookEndDate As %String, Medicare As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    k ^TMP("DHCIPMealBookMealPrint",$j)
    i BookStDate["-" s BookStDate=$zdh(BookStDate,3)
    i BookEndDate["-" s BookEndDate=$zdh(BookEndDate,3)
    s PapmiRowID=$o(^PAPERi("Medicare1",Medicare,""))
    i PapmiRowID'="" d
    .s AdmRowID=""
    .f  s AdmRowID=$o(^PAPERdr(PapmiRowID,"ADM","I",AdmRowID)) q:AdmRowID=""  d
    ..s MOrdRowID=$o(^DHCIPMEALORDER(0,"Adm",AdmRowID,""))
    ..f BookDate=BookStDate:1:BookEndDate d
    ..s ChildSub=0
    ..f  s ChildSub=$o(^DHCIPMEALORDER(0,"StartDate",BookDate,MOrdRowID,ChildSub)) q:ChildSub=""  d
    ...s MealItmRowID=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",1)
    ...s BookMealTypeID=$p(^DHCIPMEALITEM(MealItmRowID),"^",3)
    ...s OrdQty=$p(^DHCIPMEALORDER(MOrdRowID,"I",ChildSub),"^",5)
    ...s ^TMP("DHCIPMealBookMealPrint",$j,BookDate,MealItmRowID)=+$g(^TMP("DHCIPMealBookMealPrint",$j,BookDate,MealItmRowID))+OrdQty
    s Date="预定日期",MealTypeDesc="餐别",MealItmDesc="菜名",Qty="数量",UnitPrice="单价",MealSum="金额"
    d OutputRow1
    s BookDate=""
    f  s BookDate=$o(^TMP("DHCIPMealBookMealPrint",$j,BookDate)) q:BookDate=""  d
    .s OutMealItmRowID="0",Num=0
    .f  s OutMealItmRowID=$o(^TMP("DHCIPMealBookMealPrint",$j,BookDate,OutMealItmRowID)) q:OutMealItmRowID=""  d
    ..s MealItmDesc=$p(^DHCIPMEALITEM(OutMealItmRowID),"^",2)
    ..s MealTypeID=$p(^DHCIPMEALITEM(OutMealItmRowID),"^",3)
    ..s MealTypeDesc=$p(^DHCIPMEALTYPE(MealTypeID),"^",2)
    ..s Qty=^TMP("DHCIPMealBookMealPrint",$j,BookDate,OutMealItmRowID)
    ..s UnitPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(OutMealItmRowID,BookDate)
    ..s MealSum=UnitPrice*Qty
    ..s Date=$zd(BookDate,3)
    .d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK   
OutputRow1
	set Data=$lb(Date,MealTypeDesc,MealItmDesc,Qty,UnitPrice,MealSum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPatMealBookInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatMealBookInfoExecute ]
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

Query FindPatMealBookInfo(BookStDate As %String, BookEndDate As %String, Medicare As %String) As %Query(ROWSPEC = "bookdate,mealtypedesc,mealitmdesc,qty,unitprice,mealsum")
{
}

}
