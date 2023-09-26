Import SQLUser

Class web.DHCIPBillTouchFee Extends %RegisteredObject
{

ClassMethod GetPatInfo(CardNo, RegNo) [ WebMethod ]
{
	i (CardNo'="") {
    	s PAPMINo=..GetRegNoByCardNo(CardNo)
	}
    i (RegNo'="") {
    	s PAPMINo=RegNo
    }
    i $g(PAPMINo)="" q ""_"^"_""
    s PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
    s PapmiID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
    i (PapmiID'="") s PAPMIName=$p(^PAPER(PapmiID,"ALL"),"^",1)
    q $g(PAPMIName)_"^"_$g(PAPMINo)
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Description:根据病人的登记号，类型取住院病人的分类汇总费用
Query FindInPatFeeInfo(CardNo, RegNo) As websys.Query(CONTAINID = 1, ROWSPEC = "开始日期,结束日期,总费用,预交金,结算标志,收据号,就诊科室,账单号")
{
}

ClassMethod FindInPatFeeInfoExecute(ByRef qHandle As %Binary, CardNo, RegNo) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    s RegNo=$g(RegNo), CardNo=$g(CardNo)
    i (RegNo="")&&(CardNo="") quit $$$OK
    i CardNo'="" d
    .s PAPMINo=..GetRegNoByCardNo(CardNo)
    i RegNo'="" d
    .s PAPMINo=RegNo
    i $g(PAPMINo)=""  quit $$$OK
    s PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
    s PAPMIID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
    i $g(PAPMIID)="" quit $$$OK
    
    s AdmType=""
    f  s AdmType=$o(^PAPERdr(PAPMIID,"ADM",AdmType)) q:AdmType=""  d
    .q:AdmType'="I"
    .s AdmRowID=""
    .f  s AdmRowID=$o(^PAPERdr(PAPMIID,"ADM",AdmType,AdmRowID)) q:AdmRowID=""  d
    ..s PBRowID=""
    ..f  s PBRowID=$o(^DHCPB(0,"ADM",AdmRowID,PBRowID)) q:PBRowID=""  d
    ...s DateFrom=$p(^DHCPB(PBRowID),"^",6)
    ...s DateTo=$p(^DHCPB(PBRowID),"^",7)
    ...s TotalAmt=$p(^DHCPB(PBRowID),"^",8)
    ...s PaidFlag=$p(^DHCPB(PBRowID),"^",16)
    ...i PaidFlag'="P" d
    ....s InvNo=""
    ....s Deposit=##class(web.UDHCJFBaseCommon).arpbldeposit(PBRowID)
    ...e  d
    ....s InvRowID=$o(^DHCINVPRTZY(0,"AR",PBRowID,""),-1)
    ....i InvRowID'="" d
    .....s InvNo=$p(^DHCINVPRTZY(InvRowID),"^",1)
    .....s Deposit=$p(^DHCINVPRTZY(InvRowID),"^",22)    
    ...s AdmLocID=$p(^PAADM(AdmRowID),"^",4)
    ...i PaidFlag="P" s PaidFlag="已结算"
    ...i AdmLocID'="" s AdmLoc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
    ...do OutputRow1
	quit $$$OK
OutputRow1
	set Data=$lb($zd(DateFrom,3),$zd(DateTo,3),$p(TotalAmt,$c(1)),+$g(Deposit),PaidFlag,InvNo,AdmLoc,PBRowID)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Description:根据病人的登记号，类型取门诊病人的就诊发票记录
Query FindOutPatFeeInfo(CardNo, RegNo) As websys.Query(CONTAINID = 1, ROWSPEC = "发票日期,发票号,总费用,结算标志,就诊科室,发票ID")
{
}

ClassMethod FindOutPatFeeInfoExecute(ByRef qHandle As %Binary, CardNo, RegNo) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    i (RegNo="")&(CardNo="") quit $$$OK
    i CardNo'="" d
    .s PAPMINo=..GetRegNoByCardNo(CardNo)
    i RegNo'="" d
    .s PAPMINo=RegNo
   
    s PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
    i $g(PAPMINo)=""  quit $$$OK
    s PAPMIID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
    i $g(PAPMIID)="" quit $$$OK

    k ^TMP("DHCIPBillTouchFee",$j)
    s AdmType=""
    f  s AdmType=$o(^PAPERdr(PAPMIID,"ADM",AdmType)) q:AdmType=""  d
    .q:AdmType'="O"
    .s AdmRowID=""
    .f  s AdmRowID=$o(^PAPERdr(PAPMIID,"ADM",AdmType,AdmRowID)) q:AdmRowID=""  d
    ..s BilLConInv=""
    ..f  s BilLConInv=$o(^DHCBCI(0,"ADM",AdmRowID,BilLConInv)) q:BilLConInv=""  d
    ...s PrtRowID=$p(^DHCBCI(BilLConInv),"^",1)
    ...q:$d(^TMP("DHCIPBillTouchFee",$j,PrtRowID))
    ...s ^TMP("DHCIPBillTouchFee",$j,PrtRowID)=""
    ...s PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
    ...q:PrtFlag'="N"
    ...s PrtInv=$p(^DHCINVPRT(PrtRowID),"^",14)  ;发票日期,发票号,总费用,结算标志,就诊科室,发票RowID
    ...s PrtDate=$p(^DHCINVPRT(PrtRowID),"^",5)
    ...s PrtDate=$zd(PrtDate,3)
    ...s PrtAcount=$p(^DHCINVPRT(PrtRowID),"^",1)
    ...s AdmLocID=$p(^PAADM(AdmRowID),"^",4)
    ...s PaidFlag="已结算"
    ...i AdmLocID'="" s AdmLoc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
    ...D OutputRow4

	quit $$$OK
OutputRow4
	set Data=$lb(PrtDate,PrtInv,PrtAcount,PaidFlag,AdmLoc,PrtRowID)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Description:根据病人的登记号，类型取住院病人的就诊记录
/// d ##class(%ResultSet).RunQuery("web.DHCIPBillTouchFee","FindInPatCateFeeInfo",209398)
Query FindInPatCateFeeInfo(PBRowID As %String) As websys.Query(CONTAINID = 1, ROWSPEC = "分类1,金额1,分类2,金额2,分类3,金额3,分类4,金额4,分类5,金额5")
{
}

ClassMethod FindInPatCateFeeInfoExecute(ByRef qHandle As %Binary, PBRowID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    
    i $g(PBRowID)="" quit $$$OK
    s AdmRowID=$p(^DHCPB(PBRowID),"^",1)
    s PapmiRowID=$p(^PAADM(AdmRowID),"^",1)
    s PapmiName=$p(^PAPER(PapmiRowID,"ALL"),"^",1)
    s PapmiNo=$p(^PAPER(PapmiRowID,"PAT",1),"^",1)
    s AdmDate=$p(^PAADM(AdmRowID),"^",6)
    s AdmDate=$zd(AdmDate,3)
    s AdmLocID=$p(^PAADM(AdmRowID),"^",4)
    s AdmLocDesc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
    
    s CateDesc(1)="病人姓名:",CateAmt(1)=PapmiName
    s CateDesc(2)="登记号:",CateAmt(2)=PapmiNo
    s CateDesc(3)="就诊日期:",CateAmt(3)=AdmDate
    s CateDesc(4)="就诊科室:",CateAmt(4)=AdmLocDesc
    s CateDesc(5)="",CateAmt(5)=""
    ;d OutputRow2
    k ^TMP("DHCIPBillTouchFee",$j)
    s TicRowid="0",n=0
    f  s TicRowid=$o(^DHCTarC("TIC",TicRowid))  q:TicRowid=""  d
    .s ^TMP("DHCIPBillTouchFee",$j,TicRowid)=0
    s PatFeeSum=0
    s OrdSub=0
    f  s OrdSub=$o(^DHCPB(PBRowID,"O",OrdSub)) q:OrdSub=""  d
    .s DetSub=0
    .f  s DetSub=$o(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)) q:DetSub=""  d
    ..s TotalAmt=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",7) ;总额
    ..s PatFeeSum=PatFeeSum+TotalAmt
    ..s TarItemID=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",3)     ;收费项目
    ..i TarItemID'="" s InPatCate=$p(^DHCTARI(TarItemID),"^",14)     ;住院费用子分类         
	..s TariCate=$p(^DHCTarC("IC",InPatCate),"^",3)                 ;住院费用大类
	..s ^TMP("DHCIPBillTouchFee",$j,TariCate)=+$g(^TMP("DHCIPBillTouchFee",$j,TariCate))+TotalAmt
	s n=0 
	s TmpCate=""
	f  s TmpCate=$o(^TMP("DHCIPBillTouchFee",$j,TmpCate)) Q:TmpCate=""  d
	.s n=n+1
	.s TmpCateDesc=$p(^DHCTarC("TIC",TmpCate),"^",2)
	.s ^TMP("DHCIPBillTouchFeeTMP",$j,n)=TmpCateDesc_"^"_^TMP("DHCIPBillTouchFee",$j,TmpCate)
	k ^TMP("DHCIPBillTouchFee",$j)	
	s Count=0
	f i=1:5:n  d
	.s Count=Count+1
	.f j=1:1:5 d
    ..s Num=(Count-1)*5+j
	..s CateDesc(j)=$p($g(^TMP("DHCIPBillTouchFeeTMP",$j,Num)),"^",1)
	..s CateAmt(j)=$j($p($g(^TMP("DHCIPBillTouchFeeTMP",$j,Num)),"^",2),3,2)
    .do OutputRow2
    ;s CateDesc(1)="合计",CateAmt(1)=PatFeeSum,CateDesc(2)="",CateDesc(3)="",CateDesc(4)="",CateDesc(5)=""
    ;s CateAmt(2)="",CateAmt(3)="",CateAmt(4)="",CateAmt(5)=""
    
    ;s CateDesc(1)="A",CateAmt(1)="B",CateDesc(2)=11,CateAmt(2)=99
    ;d OutputRow2

	quit $$$OK
OutputRow2
	set Data=$lb($g(CateDesc(1)),$g(CateAmt(1)),$g(CateDesc(2)),$g(CateAmt(2)),$g(CateDesc(3)),$g(CateAmt(3)),$g(CateDesc(4)),$g(CateAmt(4)),$g(CateDesc(5)),$g(CateAmt(5)))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Description:根据病人的登记号，类型取住院病人的就诊记录
Query FindOutPatCateFeeInfo(PrtRowID) As websys.Query(CONTAINID = 1, ROWSPEC = "分类1,金额1,分类2,金额2,分类3,金额3,分类4,金额4,分类5,金额5")
{
}

ClassMethod FindOutPatCateFeeInfoExecute(ByRef qHandle As %Binary, PrtRowID) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    i $g(PrtRowID)=""  quit $$$OK
    s PapmiRowID=$p(^DHCINVPRT(PrtRowID),"^",15)
    s PapmiName=$p(^PAPER(PapmiRowID,"ALL"),"^",1)
    s PapmiNo=$p(^PAPER(PapmiRowID,"PAT",1),"^",1)
    s PrtInv=$p(^DHCINVPRT(PrtRowID),"^",14)
    ;s AdmDate=$p(^PAADM(AdmRowID),"^",6)
    ;s AdmDate=$zd(AdmDate,3)
    ;s AdmLocID=$p(^PAADM(AdmRowID),"^",4)
    ;s AdmLocDesc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
    
    s CateDesc(1)="病人姓名:",CateAmt(1)=PapmiName
    s CateDesc(2)="登记号:",CateAmt(2)=PapmiNo
    s CateDesc(3)="发票号",CateAmt(3)=PrtInv
    s CateDesc(4)="",CateAmt(4)=""
    s CateDesc(5)="",CateAmt(5)=""
    ;d OutputRow6
    k ^TMP("DHCIPBillTouchFee",$j)
    s TocRowid="0",n=0
    f  s TocRowid=$o(^DHCTarC("TOC",TocRowid))  q:TocRowid=""  d
    .s ^TMP("DHCIPBillTouchFee",$j,TocRowid)=0
    s PatFeeSum=0
    s BillConInv="" 
    f  s BillConInv=$o(^DHCBCI(0,"INV",PrtRowID,BillConInv)) q:BillConInv=""  d
    .s PBRowID=$p(^DHCBCI(BillConInv),"^",2)
    .s OrdSub=0
    .f  s OrdSub=$o(^DHCPB(PBRowID,"O",OrdSub)) q:OrdSub=""  d
    ..s DetSub=0
    ..f  s DetSub=$o(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)) q:DetSub=""  d
    ...s TotalAmt=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",7)       ;总额
    ...s PatFeeSum=PatFeeSum+TotalAmt
    ...s TarItemID=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",3)     ;收费项目
    ...i TarItemID'="" s OutPatCate=$p(^DHCTARI(TarItemID),"^",15)     ;门诊费用子分类         
	...s TariCate=$p(^DHCTarC("OC",OutPatCate),"^",3)                 ;门诊费用大类
	...s ^TMP("DHCIPBillTouchFee",$j,TariCate)=+$g(^TMP("DHCIPBillTouchFee",$j,TariCate))+TotalAmt
	s n=0 
	s TmpCate=""
	f  s TmpCate=$o(^TMP("DHCIPBillTouchFee",$j,TmpCate)) Q:TmpCate=""  d
	.s n=n+1
	.s TmpCateDesc=$p(^DHCTarC("TOC",TmpCate),"^",2)
	.s ^TMP("DHCIPBillTouchFeeTMP",$j,n)=TmpCateDesc_"^"_^TMP("DHCIPBillTouchFee",$j,TmpCate)
	k ^TMP("DHCIPBillTouchFee",$j)	
	s Count=0
	f i=1:5:n  d
	.s Count=Count+1
	.f j=1:1:5 d
    ..s Num=(Count-1)*5+j
	..s CateDesc(j)=$p($g(^TMP("DHCIPBillTouchFeeTMP",$j,Num)),"^",1)
	..s CateAmt(j)=$j($p($g(^TMP("DHCIPBillTouchFeeTMP",$j,Num)),"^",2),3,2)
    .do OutputRow6
    s CateDesc(1)="合计",CateAmt(1)=PatFeeSum,CateDesc(2)="",CateDesc(3)="",CateDesc(4)="",CateDesc(5)=""
    s CateAmt(2)="",CateAmt(3)="",CateAmt(4)="",CateAmt(5)=""
    d OutputRow6

	quit $$$OK
OutputRow6
	set Data=$lb($g(CateDesc(1)),$g(CateAmt(1)),$g(CateDesc(2)),$g(CateAmt(2)),$g(CateDesc(3)),$g(CateAmt(3)),$g(CateDesc(4)),$g(CateAmt(4)),$g(CateDesc(5)),$g(CateAmt(5)))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Description:根据账单号查询病人的费用明细
/// w ##class(%ResultSet).RunQuery("web.DHCIPBillTouchFee","FindInPatCateFeeDetail",205104,"")
Query FindInPatCateFeeDetail(PBRowID As %String, BillDate As %String) As websys.Query(CONTAINID = 1, ROWSPEC = "收费项目分类,收费项目名称,单位,单价,数量,金额")
{
}

ClassMethod FindInPatCateFeeDetailExecute(ByRef qHandle As %Binary, PBRowID As %String, BillDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    i $g(PBRowID)=""  quit $$$OK
    k ^TMP($j)
    i (BillDate'="") s BillDate=$zdh(BillDate,3)
    s AdmRowID=$p(^DHCPB(PBRowID),"^",1)
    s PapmiRowID=$p(^PAADM(AdmRowID),"^",1)
    s PapmiName=$p(^PAPER(PapmiRowID,"ALL"),"^",1)
    s PapmiNo=$p(^PAPER(PapmiRowID,"PAT",1),"^",1)
    s AdmDate=$p(^PAADM(AdmRowID),"^",6)
    s AdmDate=$zd(AdmDate,3)
    s AdmLocID=$p(^PAADM(AdmRowID),"^",4)
    s AdmLocDesc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
    s tarticDesc="病人姓名:"_PapmiName
    s tariDesc="登记号:"_PapmiNo
    s uomDesc="就诊日期:"_AdmDate
    s UnitPrice="就诊科室:"_AdmLocDesc
    s BillQty="",Total=""
    
    ;d OutputRow5
    i $g(BillDate)="" d    //查询全部
    .s OrdSub=0
    .f  s OrdSub=$o(^DHCPB(PBRowID,"O",OrdSub)) q:OrdSub=""  d
    ..s OERowID=$p($g(^DHCPB(PBRowID,"O",OrdSub)),"^",4)   
    ..s DetSub=0
    ..f  s DetSub=$o(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)) q:DetSub=""  d
    ...d SetPBDetail(OERowID,PBRowID,OrdSub,DetSub)
    e  d                  //查询某个日期的明细
    .;s BillDate=$zdh(BillDate,3)
    .s OrdSub=""
    .f  s OrdSub=$o(^DHCPB("BILLDATE",BillDate,PBRowID,OrdSub)) q:OrdSub=""  d
    ..s OERowID=$p($g(^DHCPB(PBRowID,"O",OrdSub)),"^",4)  
    ..s DetSub=0
    ..f  s DetSub=$o(^DHCPB("BILLDATE",BillDate,PBRowID,OrdSub,DetSub)) q:DetSub=""  d
    ...d SetPBDetail(OERowID,PBRowID,OrdSub,DetSub)
    
	s catId=0,tariId=0,OERowID=""
	s count=0,sumall=0,count1=0,all=0,Total=0
	f  s catId=$o(^TMP($j,"BillDetail",catId)) q:(+catId=0)  d
	.s TariCateSum=0
	.s tarticDesc=$p(^DHCTarC("TIC",catId),"^",2)
	.f  s tariId=$o(^TMP($j,"BillDetail",catId,tariId)) q:(+tariId=0)  d
	..s tariDesc=$p(^DHCTARI(tariId),"^",2)
	..s tariUom=$p(^DHCTARI(tariId),"^",3)
	..s uomDesc=""
	..i tariUom'="" s uomDesc=$p(^CT("UOM",tariUom),"^",2)
    ..;f  s OERowID=$o(^TMP($j,"BillDetail",catId,tariId,OERowID)) q:(+OERowID=0)  d
    ...;s BillDesc=""
    ...;i $d(^OEORD(+OERowID,"I",$p(OERowID,"||",2),2)) s BillDesc=$p(^OEORD(+OERowID,"I",$p(OERowID,"||",2),2),"^",12)
	...;i BillDesc'="" s tariDesc=BillDesc
	..s UnitPrice=""
	..f  s UnitPrice=$o(^TMP($j,"BillDetail",catId,tariId,UnitPrice)) q:UnitPrice=""  d
  	...s BillQty=$p(^TMP($j,"BillDetail",catId,tariId,UnitPrice),"^",1)
  	...s Total=$fn($p(^TMP($j,"BillDetail",catId,tariId,UnitPrice),"^",2),"",2)
  	...s TariCateSum=TariCateSum+Total
  	...s all=all+Total
	...s UnitPrice=$j(UnitPrice,3,4)
	...do OutputRow5
	...s tarticDesc=""
	.s tarticDesc="小计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(TariCateSum,3,2)
    .d OutputRow5
    s tarticDesc="合计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(all,3,2)
    d OutputRow5
    k ^TMP($j)

	quit $$$OK
OutputRow5
	set Data=$lb(tarticDesc,tariDesc,uomDesc,UnitPrice,BillQty,Total)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
SetPBDetail(OERowID,PBRowID,OrdSub,DetSub)
	s PBInfo=^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)
	s tariId=$p(PBInfo,"^",3) ;PBD_TARI_DR,指向DHC_TarItem
	q:(+tariId=0)
	s UnitPrice=$p(PBInfo,"^",4) ;PBD_UnitPrice
	s BillQty=$p(PBInfo,"^",5) ;PBD_BillQty
	s Total=$p(PBInfo,"^",7)
	s Total=$fn(Total,"",2)
	q:(+Total=0)
	s PBDRowID=PBRowID_"||"_OrdSub_"||"_DetSub
	s tarcId=$p(^DHCTARI(tariId),"^",14) ;TARI_InpatCate,指向DHC_TarInpatCate
	s taricId=$p(^DHCTarC("IC",tarcId),"^",3) ;TARIC_TARTIC_DR
	if $d(^TMP($j,"BillDetail",taricId,tariId,$fn(UnitPrice,"",3))) d
	.s $p(^TMP($j,"BillDetail",taricId,tariId,$fn(UnitPrice,"",3)),"^",1)=$p(^TMP($j,"BillDetail",taricId,tariId,$fn(UnitPrice,"",3)),"^",1)+BillQty
	.s $p(^TMP($j,"BillDetail",taricId,tariId,$fn(UnitPrice,"",3)),"^",2)=$p(^TMP($j,"BillDetail",taricId,tariId,$fn(UnitPrice,"",3)),"^",2)+Total
	e  d
	.s $p(^TMP($j,"BillDetail",taricId,tariId,$fn(UnitPrice,"",3)),"^",1)=BillQty
	.s $p(^TMP($j,"BillDetail",taricId,tariId,$fn(UnitPrice,"",3)),"^",2)=Total
	q
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Description:根据账单号查询病人的费用明细
/// w ##class(%ResultSet).RunQuery("web.DHCIPBillTouchFee","FindOutPatCateFeeDetail","184265")
Query FindOutPatCateFeeDetail(PrtRowID) As websys.Query(CONTAINID = 1, ROWSPEC = "收费项目分类,收费项目名称,单位,单价,数量,金额")
{
}

ClassMethod FindOutPatCateFeeDetailExecute(ByRef qHandle As %Binary, PrtRowID) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    i $g(PrtRowID)=""  quit $$$OK
    k ^TMP($j)

    s PapmiRowID=$p(^DHCINVPRT(PrtRowID),"^",15)
    s PapmiName=$p(^PAPER(PapmiRowID,"ALL"),"^",1)
    s PapmiNo=$p(^PAPER(PapmiRowID,"PAT",1),"^",1)
    s PrtInv=$p(^DHCINVPRT(PrtRowID),"^",14)
    ;s AdmDate=$p(^PAADM(AdmRowID),"^",6)
    ;s AdmDate=$zd(AdmDate,3)
    ;s AdmLocID=$p(^PAADM(AdmRowID),"^",4)
    ;s AdmLocDesc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
    s tarticDesc="病人姓名:",tariDesc=PapmiName,uomDesc="登记号:",UnitPrice=PapmiNo,BillQty="发票号",Total=PrtInv
    ;d OutputRow7
    s BillConInv="" 
    f  s BillConInv=$o(^DHCBCI(0,"INV",PrtRowID,BillConInv)) q:BillConInv=""  d
    .s PBRowID=$p(^DHCBCI(BillConInv),"^",2)
    .s OrdSub=0
    .f  s OrdSub=$o(^DHCPB(PBRowID,"O",OrdSub)) q:OrdSub=""  d
    ..s OERowID=$p($g(^DHCPB(PBRowID,"O",OrdSub)),"^",4)   
    ..s DetSub=0
    ..f  s DetSub=$o(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)) q:DetSub=""  d
    ...d SetPBDetail1(OERowID,PBRowID,OrdSub,DetSub)
    
	s catId=0,tariId=0,OERowID=""
	s count=0,sumall=0,count1=0,all=0,Total=0
	f  s catId=$o(^TMP($j,"BillDetail",catId)) q:(+catId=0)  d
	.s TariCateSum=0
	.s tarticDesc=$p(^DHCTarC("TOC",catId),"^",2)
	.f  s tariId=$o(^TMP($j,"BillDetail",catId,tariId)) q:(+tariId=0)  d
	..s tariDesc=$p(^DHCTARI(tariId),"^",2)
	..s tariUom=$p(^DHCTARI(tariId),"^",3)
	..s uomDesc=""
	..i tariUom'="" s uomDesc=$p(^CT("UOM",tariUom),"^",2)
    ..f  s OERowID=$o(^TMP($j,"BillDetail",catId,tariId,OERowID)) q:(+OERowID=0)  d
    ...s BillDesc=""
    ...i $d(^OEORD(+OERowID,"I",$p(OERowID,"||",2),2)) s BillDesc=$p(^OEORD(+OERowID,"I",$p(OERowID,"||",2),2),"^",12)
	...i BillDesc'="" s tariDesc=BillDesc
	...s UnitPrice=""
	...f  s UnitPrice=$o(^TMP($j,"BillDetail",catId,tariId,OERowID,UnitPrice)) q:UnitPrice=""  d
  	....s BillQty=$p(^TMP($j,"BillDetail",catId,tariId,OERowID,UnitPrice),"^",1)
  	....s Total=$fn($p(^TMP($j,"BillDetail",catId,tariId,OERowID,UnitPrice),"^",2),"",2)
  	....s TariCateSum=TariCateSum+Total
  	....s all=all+Total
	....s UnitPrice=$j(UnitPrice,3,4)
	....do OutputRow7
	....s tarticDesc=""
	.s tarticDesc="小计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(TariCateSum,3,2)
    .d OutputRow7
    s tarticDesc="合计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(all,3,2)
    d OutputRow7
    k ^TMP($j)

	quit $$$OK
OutputRow7
	set Data=$lb(tarticDesc,tariDesc,uomDesc,UnitPrice,BillQty,Total)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
SetPBDetail1(OERowID,PBRowID,OrdSub,DetSub)
	s PBInfo=^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)
	s tariId=$p(PBInfo,"^",3) ;PBD_TARI_DR,指向DHC_TarItem
	q:(+tariId=0)
	s UnitPrice=$p(PBInfo,"^",4) ;PBD_UnitPrice
	s BillQty=$p(PBInfo,"^",5) ;PBD_BillQty
	s Total=$p(PBInfo,"^",7)
	s Total=$fn(Total,"",2)
	q:(+Total=0)
	s tarcId=$p(^DHCTARI(tariId),"^",15) 
	s taricId=$p(^DHCTarC("OC",tarcId),"^",3) ;TARIC_TARTIC_DR
	if $d(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3))) d
	.s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",1)=$p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",1)+BillQty
	.s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",2)=$p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",2)+Total
	e  d
	.s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",1)=BillQty
	.s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",2)=Total
	
	q
}

/// Creator: yyx
/// CreateDate: 2009-12-08
/// Modify: 2022-07-19 ZhYW
/// Description: 查询收费项的价格
/// Input: alias:别名, ordCateType:分类代码(1:药品, 2:非药品)
/// Output: 序号,项目名称,项目编码,物价编码,药品类别,单位,价格,收费依据,医保标识
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillTouchFee","FindTarItmList","3578","1")
Query FindTarItmList(alias As %String, ordCateType As %String = "") As websys.Query(CONTAINID = 1, ROWSPEC = "Ind:%String:序号,ItemDesc:%String:项目名称,ItemCode:%String:项目编码,ExtendCode:%String:物价编码,SubCate:%String:项目分类,UOM:%String:单位,Price:%Float:价格,ChargeStandard:%String:收费依据,InsureSign:%String:医保标识")
{
}

ClassMethod FindTarItmListExecute(ByRef qHandle As %Binary, alias As %String, ordCateType As %String = "") As %Status [ ProcedureBlock = 0 ]
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    if ($l(alias)<2) quit $$$OK
    
    kill %TarItmAry
    
    set defHospId=$o(^CT("HOSP",0))
    
    //按别名查询
	do open^DHCJFFIND("", "", alias, "", defHospId, "")
	do {
		set rtn=$$fetch^DHCJFFIND("", "", alias, "", defHospId, "")
	    do GetTariInfo()
	}while(rtn=0)
	//按代码查询
	do open^DHCJFFIND(alias, "", "", "", defHospId, "")
	do {
		set rtn=$$fetch^DHCJFFIND(alias, "", "", "", defHospId, "")
	    do GetTariInfo()
	}while(rtn=0)
	//按名称查询
	do open^DHCJFFIND("", alias, "", "", defHospId, "")
	do {
		set rtn=$$fetch^DHCJFFIND("", alias, "", "", defHospId, "")
	    do GetTariInfo()
	}while(rtn=0)
	
	do close^DHCJFFIND()
	quit $$$OK
	
GetTariInfo()
	set TarId=$g(PLIST(14))
	quit:(+TarId=0)
	quit:($d(%TarItmAry(TarId)))
	set %TarItmAry(TarId)=""
	set InciDR=##class(web.DHCIPBillTouchFee).GetInciDRByTarId(TarId)   //库存项
	set IsDrug=##class(PHA.FACE.OUT.Com).IsDrug("", InciDR)
	quit:((ordCateType=1)&&(IsDrug'=1))  //过滤非药品
	quit:((ordCateType=2)&&(IsDrug=1))   //过滤药品
	set TarData=$g(^DHCTARI(TarId))
	set TarActiveFlag=$p(TarData,"^",7)
	quit:(TarActiveFlag="N")
	set TarStartDate=$p(TarData,"^",11)
	set TarEndDate=$p(TarData,"^",12)
	quit:((TarStartDate'="")&&(TarStartDate>+$h))
	quit:((TarEndDate'="")&&(TarEndDate<+$h))
	set TarCode=$p(TarData,"^",1)
	set TarDesc=$p(TarData,"^",2)
	set TarUomDR=$p(TarData,"^",3)
	set TarUomDesc=$s((+TarUomDR'=0):$p($g(^CT("UOM",TarUomDR)),"^",2),1:"")
	set TarSubCateDR=$p(TarData,"^",4)   //收费项目子分类
	set TarSubCate=$s((+TarSubCateDR'=0):$p($g(^DHCTarC("SC",TarSubCateDR)),"^",2),1:"")
	set TarExtendCode=$p(TarData,"^",22)	  //物价编码 TARI_ExtendCode
	set TarChargeBasis=$p(TarData,"^",20)
	set YBCode=""
	set rtnValue=##class(web.UDHCJFPRICE).GetItmPrice(TarId, +$h, "", "", "", defHospId, "")
	set TarPrice=$p(rtnValue,"^",1)
	set TarPrice=$fn(TarPrice,"N")
	do OutputTarItmList
	quit
OutputTarItmList
	set Data=$lb(ind,TarDesc,TarCode,TarExtendCode,TarSubCate,TarUomDesc,TarPrice,TarChargeBasis,YBCode)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 根据卡号取登记号
ClassMethod GetRegNoByCardNo(CardNo As %String) As %String
{
	set CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
	quit:(+CardID=0) ""
	set PAPMINo=$p(^DHCCARD("CF",CardID),"^",6)
	quit PAPMINo
}

/// Creator: yyx
/// CreateDate: 2009-12-09
/// Description: 返回收费项目数据集
ClassMethod GetTarItemPriceDataSet(Alias As %String = "", Flag As %String) As web.DHCIPBillTouchFeeDataSet [ WebMethod ]
{
	set result=##class(web.DHCIPBillTouchFeeDataSet).%New()
	do result.SetArgs(Alias, Flag)
	quit result
}

/// Creator: ZhYW
/// CreateDate: 2022-07-19
/// Description: 根据收费项获取对应库存项（目前只针对药品）
/// Table: DHC_IncTarRela
/// Input: tarId: DHC_TarItem.RowId
/// Return: inci: INC_Itm.RowId
/// Debug: w ##class(web.DHCIPBillTouchFee).GetInciDRByTarId(8169)
ClassMethod GetInciDRByTarId(tarId As %String) As %String
{
	set inci=""
	quit:(+tarId=0) inci
	set incTarDR=$o(^DHCINCTARi("TAR",tarId,""),-1)
	quit:(incTarDR="") inci
	set inci=$p($g(^DHCINCTAR(incTarDR)),"^",1)   //库存项
	quit inci
}

}
