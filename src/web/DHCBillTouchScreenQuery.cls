Import Sqluser

/// Lid
/// 2015-09-09
/// BS版触摸屏查询业务类
Class web.DHCBillTouchScreenQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPatInfo(CardNo, RegNo)
{
	n (CardNo, RegNo)
   	i CardNo'="" d
    .s PAPMINo=..GetRegNoByCardNo(CardNo)
    i RegNo'="" d
    .s PAPMINo=RegNo
    i $g(PAPMINo)="" q ""_"^"_""
    s PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
    s PapmiID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
    i PapmiID'="" s PAPMIName=$p(^PAPER(PapmiID,"ALL"),"^",1)
    q $g(PAPMIName)_"^"_$g(PAPMINo)
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Function  :根据病人的登记号，类型取住院病人的分类汇总费用
ClassMethod FindInPatFeeInfoExecute(ByRef qHandle As %Binary, CardNo, RegNo) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s RegNo=$g(RegNo),CardNo=$g(CardNo)
    i (RegNo="")&(CardNo="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    S ^YYY=CardNo_"^"_RegNo
    i CardNo'="" d
    .s PAPMINo=..GetRegNoByCardNo(CardNo)
    i RegNo'="" d
    .s PAPMINo=RegNo
    i $g(PAPMINo)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    s PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
    s PAPMIID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
    i $g(PAPMIID)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s AdmType=""
    b ;2
    f  s AdmType=$o(^PAPERdr(PAPMIID,"ADM",AdmType)) q:AdmType=""  d
    .q:AdmType'="I"
    .s AdmRowID=""
    .f  s AdmRowID=$o(^PAPERdr(PAPMIID,"ADM",AdmType,AdmRowID)) q:AdmRowID=""  d
    ..s PBRowID=""
    ..f  s PBRowID=$o(^DHCPB(0,"ADM",AdmRowID,PBRowID)) q:PBRowID=""  d
    ...b ;3
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
    ...Do OutputRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PBRowID,$zd(DateFrom,3),$zd(DateTo,3),$p(TotalAmt,$c(1)),+$g(Deposit),PaidFlag,InvNo,AdmLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInPatFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInPatFeeInfoExecute ]
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

ClassMethod FindInPatFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInPatFeeInfoExecute ]
{
  
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindInPatFeeInfo(CardNo, RegNo) As %Query(CONTAINID = 1, ROWSPEC = "账单号,开始日期,结束日期,总费用,预交金,结算标志,收据号,就诊科室")
{
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Function  :根据病人的登记号，类型取门诊病人的就诊发票记录
ClassMethod FindOutPatFeeInfoExecute(ByRef qHandle As %Binary, CardNo, RegNo) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i (RegNo="")&(CardNo="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i CardNo'="" d
    .s PAPMINo=..GetRegNoByCardNo(CardNo)
    i RegNo'="" d
    .s PAPMINo=RegNo
   i $g(PAPMINo)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    s PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
    
    s PAPMIID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
    i $g(PAPMIID)="" Set qHandle=$lb(0,repid,0) Quit $$$OK

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
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(ind,PrtDate,PrtInv,$j(PrtAcount,3,2),PaidFlag,AdmLoc,PrtRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOutPatFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutPatFeeInfoExecute ]
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

ClassMethod FindOutPatFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutPatFeeInfoExecute ]
{
  
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindOutPatFeeInfo(CardNo, RegNo) As %Query(CONTAINID = 1, ROWSPEC = "序号,发票日期,发票号,总费用,结算标志,就诊科室,发票ID")
{
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Function  :根据病人的登记号，类型取住院病人的就诊记录
ClassMethod FindInPatCateFeeInfoExecute(ByRef qHandle As %Binary, PBRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    
    i $g(PBRowID)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
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
	..s CateAmt(j)=$p($g(^TMP("DHCIPBillTouchFeeTMP",$j,Num)),"^",2)
    .Do OutputRow2
    s CateDesc(1)="合计",CateAmt(1)=PatFeeSum,CateDesc(2)="",CateDesc(3)="",CateDesc(4)="",CateDesc(5)=""
    s CateAmt(2)="",CateAmt(3)="",CateAmt(4)="",CateAmt(5)=""
 
    d OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb($g(CateDesc(1)),$g(CateAmt(1)),$g(CateDesc(2)),$g(CateAmt(2)),$g(CateDesc(3)),$g(CateAmt(3)),$g(CateDesc(4)),$g(CateAmt(4)),$g(CateDesc(5)),$g(CateAmt(5)))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInPatCateFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInPatCateFeeInfoExecute ]
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

ClassMethod FindInPatCateFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInPatCateFeeInfoExecute ]
{
  
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindInPatCateFeeInfo(PBRowID As %String) As %Query(CONTAINID = 1, ROWSPEC = "分类1,金额1,分类2,金额2,分类3,金额3,分类4,金额4,分类5,金额5")
{
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Function  :根据病人的登记号，类型取住院病人的就诊记录
ClassMethod FindOutPatCateFeeInfoExecute(ByRef qHandle As %Binary, PrtRowID) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i $g(PrtRowID)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;s AdmRowID=$p(^DHCPB(PBRowID),"^",1)
    ;s PapmiRowID=$p(^PAADM(AdmRowID),"^",1)
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
	...q:'$d(^DHCTarC("TOC",TariCate))
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
	..s CateAmt(j)=$p($g(^TMP("DHCIPBillTouchFeeTMP",$j,Num)),"^",2)
    .Do OutputRow6
    s CateDesc(1)="合计",CateAmt(1)=PatFeeSum,CateDesc(2)="",CateDesc(3)="",CateDesc(4)="",CateDesc(5)=""
    s CateAmt(2)="",CateAmt(3)="",CateAmt(4)="",CateAmt(5)=""
    d OutputRow6
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb($g(CateDesc(1)),$j($g(CateAmt(1)),3,2),$g(CateDesc(2)),$j($g(CateAmt(2)),3,2),$g(CateDesc(3)),$j($g(CateAmt(3)),3,2),$g(CateDesc(4)),$j($g(CateAmt(4)),3,2),$g(CateDesc(5)),$j($g(CateAmt(5)),3,2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOutPatCateFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutPatCateFeeInfoExecute ]
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

ClassMethod FindOutPatCateFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutPatCateFeeInfoExecute ]
{
  
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindOutPatCateFeeInfo(PrtRowID) As %Query(CONTAINID = 1, ROWSPEC = "分类1,金额1,分类2,金额2,分类3,金额3,分类4,金额4,分类5,金额5")
{
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Function  :根据账单号查询病人的费用明细
ClassMethod FindInPatCateFeeDetailExecute(ByRef qHandle As %Binary, PBRowID As %String, BillDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i $g(PBRowID)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    k ^TMP($j)
    i BillDate["/" d
    .i $l($p(BillDate,"/",1))=4 d
    ..s BillDate=$zdh(BillDate,5)
    .else  do
    ..s BillDate=$zdh(BillDate,4)
    i BillDate["-" d
    .s BillDate=$zdh(BillDate,3)
    
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
	...Do OutputRow8
	...s tarticDesc=""
	.s tarticDesc="小计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(TariCateSum,3,2)
    .d OutputRow8
    s tarticDesc="合计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(all,3,2)
    d OutputRow8
    k ^TMP($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ind,tarticDesc,tariDesc,uomDesc,UnitPrice,BillQty,Total)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
SetPBDetail(OERowID,PBRowID,OrdSub,DetSub)
   s PBInfo=^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)
   s tariId=$p(PBInfo,"^",3) ;PBD_TARI_DR,指向DHC_TarItem
   q:+tariId=0
   s UnitPrice=$p(PBInfo,"^",4) ;PBD_UnitPrice
   s BillQty=$p(PBInfo,"^",5) ;PBD_BillQty
   s Total=$p(PBInfo,"^",7)
   s Total=$fn(Total,"",2)
   q:+Total=0
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

ClassMethod FindInPatCateFeeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInPatCateFeeDetailExecute ]
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

ClassMethod FindInPatCateFeeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInPatCateFeeDetailExecute ]
{
  
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindInPatCateFeeDetail(PBRowID As %String, BillDate As %String) As %Query(CONTAINID = 1, ROWSPEC = "ind,收费项目分类,收费项目名称,单位,单价,数量,金额")
{
}

/// Creator:yyx 
/// CreateDate:2009-12-08
/// Function  :根据账单号查询病人的费用明细
ClassMethod FindOutPatCateFeeDetailExecute(ByRef qHandle As %Binary, PrtRowID) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i $g(PrtRowID)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    k ^TMP($j)
    i $g(PrtRowID)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;s AdmRowID=$p(^DHCPB(PBRowID),"^",1)
    ;s PapmiRowID=$p(^PAADM(AdmRowID),"^",1)
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
	....Do OutputRow7
	....s tarticDesc=""
	.s tarticDesc="小计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(TariCateSum,3,2)
    .d OutputRow7
    s tarticDesc="合计",tariDesc="",uomDesc="",UnitPrice="",BillQty="",Total=$j(all,3,2)
    d OutputRow7
    k ^TMP($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(ind,tarticDesc,tariDesc,uomDesc,UnitPrice,BillQty,Total)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
SetPBDetail1(OERowID,PBRowID,OrdSub,DetSub)
   s PBInfo=^DHCPB(PBRowID,"O",OrdSub,"D",DetSub)
   s tariId=$p(PBInfo,"^",3) ;PBD_TARI_DR,指向DHC_TarItem
   q:+tariId=0
   s UnitPrice=$p(PBInfo,"^",4) ;PBD_UnitPrice
   s BillQty=$p(PBInfo,"^",5) ;PBD_BillQty
   s Total=$p(PBInfo,"^",7)
   s Total=$fn(Total,"",2)
   q:+Total=0
   s tarcId=$p(^DHCTARI(tariId),"^",15) ;TARI_InpatCate,指向DHC_TarInpatCate
   s taricId=$p(^DHCTarC("OC",tarcId),"^",3) ;TARIC_TARTIC_DR
   if $d(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3))) d
    .s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",1)=$p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",1)+BillQty
	.s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",2)=$p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",2)+Total
   e  d
    .s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",1)=BillQty
    .s $p(^TMP($j,"BillDetail",taricId,tariId,OERowID,$fn(UnitPrice,"",3)),"^",2)=Total
   q
}

ClassMethod FindOutPatCateFeeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutPatCateFeeDetailExecute ]
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

ClassMethod FindOutPatCateFeeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutPatCateFeeDetailExecute ]
{
  
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindOutPatCateFeeDetail(PrtRowID) As %Query(CONTAINID = 1, ROWSPEC = "序号,收费项目分类,收费项目名称,单位,单价,数量,金额")
{
}

/// Creator:yyx
/// CreateDate:2009-12-02
/// Function  :按别名查询药品，非药品的价格
/// Output    :(非药品)>序号|>收费依据|>项目名称|>代码|>价格|>单位|>生产厂家|>注册证号|>注册有效期|>内容说明"
///           (非药品)>序号|>收费依据|>项目名称|>代码|>价格|>单位
///           (药品)>药品名称|>代码|>价格(元)|>药品类别|>剂型|>单位|>生产厂家|>等级
ClassMethod GetTarItmPrice(ItmAlias, Flag) [ WebMethod ]
{
    k ^TMPtext($j)
    s flag=$g(Flag),num=1
    K P1
    s ItmAlias=$$ALPHAUP^SSUTIL4(ItmAlias)
    s OldItmAlias=ItmAlias
    s ItmAlias=$o(^DHCTARAL("A",0,"Desc",OldItmAlias),-1)
    f  s ItmAlias=$o(^DHCTARAL("A",0,"Desc",ItmAlias)) q:(ItmAlias="")!(ItmAlias'[OldItmAlias)  d
    .s TarItmRowID=""
    .f  s TarItmRowID=$o(^DHCTARAL("A",0,"Desc",ItmAlias,TarItmRowID)) q:TarItmRowID=""  d
    ..s TariDesc(num)=$p(^DHCTARI(TarItmRowID),"^",2)
    ..q:$d(^TMPtext($j,TarItmRowID)) 
    ..s ^TMPtext($j,TarItmRowID)=""
    ..s CSFPrice(num)=##class(web.UDHCJFPRICE).GetItmPrice(TarItmRowID,+$h,"","","")
    ..q:+CSFPrice(num)=0
    ..q:$p($g(^DHCTARI(TarItmRowID)),"^",7)'="Y"
    ..s tarcode(num)=$p($g(^DHCTARI(TarItmRowID)),"^",1)
    ..s InsuName(num)=$p($g(^DHCTARI(TarItmRowID)),"^",20)  ;收费依据
    ..s uomid=$p($g(^DHCTARI(TarItmRowID)),"^",3)
    ..s Uom(num)=""
    ..i uomid'="" s Uom(num)=$p($g(^CT("UOM",uomid)),"^",2)
    ..s comment(num)=$p($g(^DHCTARI(TarItmRowID)),"^",19)  ;内容说明
    ..s activeflag(num)=$p($g(^DHCTARI(TarItmRowID)),"^",7)
    ..q:activeflag(num)="N"
    ..s DrugFlag="F"
    ..s incflag="F"
    ..s linok="F"
    ..s StartDate=0
    ..f  s StartDate=$o(^DHCOLT(0,"TAR",TarItmRowID,StartDate)) q:(StartDate="")!(StartDate>+$h)  d
    ...s OrdLinkTarID=0
    ...f  s OrdLinkTarID=$o(^DHCOLT(0,"TAR",TarItmRowID,StartDate,OrdLinkTarID)) q:(OrdLinkTarID="")  d
    ....s linok="F"
    ....s arcim=$p($g(^DHCOLT(OrdLinkTarID)),"^",1)
    ....s likto=$p($g(^DHCOLT(OrdLinkTarID)),"^",5)
    ....q:(likto'="")&(likto<+$h)
    ....s subcatid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
    ....q:subcatid=""
    ....s subdesc=$p($g(^ARC("IC",subcatid)),"^",2)
    ....s subdesc=$$ALPHAUP^SSUTIL4(subdesc)
    ....q:subdesc="HIDE"
    ....s arcto=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
    ....q:(arcto'="")&(arcto<+$h)
    ....s linok="T"
    ....s subcattype=$p($g(^ARC("IC",subcatid)),"^",7)
    ....i subcattype="R" s DrugFlag="T"
    ....s nextit=$o(^DHCOLT(0,"ARTTA",arcim,TarItmRowID))
    ....s nextit=$tr(nextit," ")
    ....q:nextit'=""
    ....i $d(^INCI(0,"ARCIM_DR",+arcim))  d
    .....s incflag="T"
    ....q:linok="F"
    ....s manf1=""
    ....i incflag="T" s intid=$o(^INCI(0,"ARCIM_DR",+arcim,""))
    ....e  s intid=""
    ....i intid'="" q:..HasQty(intid)'=1	
    ....s MedInfo=..GetMedInfo(intid)
    ....s manf(num)=manf
    ....i intid'="" s Uom(num)=puom
    ....e  s convqty=1
    ....i $g(intid)'="" s icfrowid=$o(^DHCICF(0,"INCI",intid,""))
    ....i $g(icfrowid)'="" d
    .....s registerno(num)=$p(^DHCICF(icfrowid),"^",10)       ;注册证号
    .....s registerdate(num)=$p(^DHCICF(icfrowid),"^",11)           
    .....i +registerdate(num)'=0 s registerdate(num)=$Zd(registerdate(num),3)   ;注册证有效期
    ....s CommName=..GetDrugCommonNameByArcimId(arcim)
    ....i $g(comname)'="" s TariDesc(num)=CommName
    ..;w !,CSFPrice(num)_"^"_convqty_"^"_$j(CSFPrice(num)*convqty,3,2)
    ..s mPLIST(num)=TariDesc(num)_"^"_tarcode(num)_"^"_$j(CSFPrice(num)*+$g(convqty),3,2)_"^"_$g(alias(num))_"^"_$g(Uom(num))_"^"_$g(InsuName(num))_"^"_$g(manf(num))_"^"_$g(registerno(num))_"^"_$G(registerdate(num))_"^"_$G(comment(num))
    ..;w !,mPLIST(num)
    ..s num=num+1
   
    s P1=num-1
    k ^TMPtext($j)
    q 0
}

ClassMethod GetManfName1(itmcode)
{
	
    &sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phmnf_dr->phmnf_name
         into :manf from inc_itm where inci_code = :itmcode)
    q $g(manf)
}

ClassMethod HasQty(inci)
{
 //tari:收费项rowid
 //inci:库存项
 //返回结果: 
 // =1 - 有库存 
 // =0 - 无库存 
 // <0 - 无库存 
 //.q:$$HasQty(itmid(num))'=1
 n (inci)
 q:inci="" -1
 s result=0
 s ch=0
 s qty=100
 s loc=""
 f  s ch=$O(^INCI(inci,"IL",ch)  ) q:(ch="")!(qty>0)  d
 .q:$g(^INCI(inci,"IL",ch))=""
 .s loc=$p(^INCI(inci,"IL",ch),"^",1) q:loc=""
 .s qty=..IL(inci,loc,+$h)
 i qty>0 s result=1
 s notuseflag=$p(^INCI(inci,2),"^",9)  ;库存项不可用时不显示
 i notuseflag="Y" s result=0
 q result
}

ClassMethod IL(inci, loc, Date)
{
 ;ret value :
 ; <0 - error occurs
 n (inci,loc,Date)
 q:inci="" 0
 q:loc="" 0
 q:Date="" 0
 s nextdate=Date+1
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
 i rr="" q 0
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
 i rr="" q 0
 s qty=+$p(^DHCLOCTOT(rr),"^",4)
 q qty
}

/// Creator:yyx
/// CreateDate:2009-12-08
/// Function:  取医嘱项的通用名
ClassMethod GetDrugCommonNameByArcimId(ArcimId)
{
 	n (ArcimId)
	s DrugCommonName=""
	i ArcimId'="" d
	.s ItmCat=$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1)),"^",10)
	.q:ItmCat=""
 	.s OrdType=$p($g(^ARC("IC",ItmCat)),"^",7)	;ARCIC_OrderType
 	.Q:OrdType'="R" 
	.s DrugCommonName =$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),8)),"^",21) ;ARCIM_GenericDesc 通用名 8 21
 	Quit DrugCommonName
}

/// Creator:yyx
/// CreateDate:2009-12-08
/// Function  :根据别名查询收费项目的价格
/// DateSet   :web.DHCIPBillTouchFeeDataSet
ClassMethod FindTarItemPriceExecute(ByRef qHandle As %Binary, ItmAlias, Flag) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    k ^TMPtext($j)
    s flag=$g(Flag)
    K P1
    s ItmAlias=$$ALPHAUP^SSUTIL4(ItmAlias)
    s OldItmAlias=ItmAlias
    s ItmAlias=$o(^DHCTARAL("A",0,"Desc",OldItmAlias),-1)
    f  s ItmAlias=$o(^DHCTARAL("A",0,"Desc",ItmAlias)) q:(ItmAlias="")!(ItmAlias'[OldItmAlias)  d
    .s TarItmRowID=""
    .f  s TarItmRowID=$o(^DHCTARAL("A",0,"Desc",ItmAlias,TarItmRowID)) q:TarItmRowID=""  d
    ..s TariDesc=$p(^DHCTARI(TarItmRowID),"^",2)
    ..q:$d(^TMPtext($j,TarItmRowID)) 
    ..s ^TMPtext($j,TarItmRowID)=""
    ..s CSFPrice=##class(web.UDHCJFPRICE).GetItmPrice(TarItmRowID,+$h,"","","")
    ..s CSFPrice=$p(CSFPrice,"^",1)
    ..q:+CSFPrice=0
    ..q:$p($g(^DHCTARI(TarItmRowID)),"^",7)'="Y"
    ..s tarcode=$p($g(^DHCTARI(TarItmRowID)),"^",1)
    ..s InsuName=$p($g(^DHCTARI(TarItmRowID)),"^",13)  ;国家编码
    ..s uomid=$p($g(^DHCTARI(TarItmRowID)),"^",3)
    ..s Uom=""
    ..i uomid'="" s Uom=$p($g(^CT("UOM",uomid)),"^",2)
    ..s comment=$p($g(^DHCTARI(TarItmRowID)),"^",19)  ;内容说明
    ..s activeflag=$p($g(^DHCTARI(TarItmRowID)),"^",7)
    ..q:activeflag="N"
    ..s DrugFlag="F"
    ..s incflag="F"
    ..s linok="F"
    ..s StartDate=0
    ..f  s StartDate=$o(^DHCOLT(0,"TAR",TarItmRowID,StartDate)) q:(StartDate="")!(StartDate>+$h)  d
    ...s OrdLinkTarID=0
    ...f  s OrdLinkTarID=$o(^DHCOLT(0,"TAR",TarItmRowID,StartDate,OrdLinkTarID)) q:(OrdLinkTarID="")  d
    ....s linok="F"
    ....s arcim=$p($g(^DHCOLT(OrdLinkTarID)),"^",1)
    ....s likto=$p($g(^DHCOLT(OrdLinkTarID)),"^",5)
    ....q:(likto'="")&(likto<+$h)
    ....s subcatid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
    ....q:subcatid=""
    ....s subdesc=$p($g(^ARC("IC",subcatid)),"^",2)
    ....s subdesc=$$ALPHAUP^SSUTIL4(subdesc)
    ....q:subdesc="HIDE"
    ....s arcto=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
    ....q:(arcto'="")&(arcto<+$h)
    ....s linok="T"
    ....s subcattype=$p($g(^ARC("IC",subcatid)),"^",7)
    ....i $g(subcattype)="" s DrugFlag="T"
    ....i (subcattype="R") s DrugFlag="T"
    ....s nextit=$o(^DHCOLT(0,"ARTTA",arcim,TarItmRowID))
    ....s nextit=$tr(nextit," ")
    ....q:nextit'=""
    ....i $d(^INCI(0,"ARCIM_DR",+arcim))  d
    .....s incflag="T"
    ....q:linok="F"
    ....s manf=""
    ....i incflag="T" s intid=$o(^INCI(0,"ARCIM_DR",+arcim,""))
    ....e  s intid=""
    ....q:intid=""
    ....s itmcode=$P(^INCI(intid,1),"^",1)
    ....s puomdr=$P(^INCI(intid,3),"^",6)
    ....s:$g(itmcode)'="" manf=..GetManfName1(itmcode)
    ....s:$l(manf,"-")>1 manf=$p(manf,"-",2)
    ....s manf=manf
    ....s puom=$P(^CT("UOM",puomdr),"^",2)
    ....s Uom=puom
    ....s icfrowid=$o(^DHCICF(0,"INCI",intid,""))
    ....i $g(icfrowid)'="" d
    .....s registerno=$p(^DHCICF(icfrowid),"^",10)       ;注册证号
    .....s registerdate=$p(^DHCICF(icfrowid),"^",11)           
    .....i +registerdate'=0 s registerdate=$Zd(registerdate,3)   ;注册证有效期
    ..q:DrugFlag="T"
    ..Do OutputRow
    k ^TMPtext($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ind,TariDesc,tarcode,CSFPrice,$g(Uom),$g(InsuName),$g(manf),$g(registerno),$G(registerdate),$G(comment))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTarItemPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTarItemPriceExecute ]
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

ClassMethod FindTarItemPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTarItemPriceExecute ]
{
  
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindTarItemPrice(ItmAlias, Flag) As %Query(CONTAINID = 1, ROWSPEC = "序号,项目名称,项目编码,价格,计价单位,国家编码,生产厂家,注册证号,注册有效期,内容说明")
{
}

/// Creator:yyx
/// CreateDate:2009-12-08
/// Function  :查询药品的信息
///           >药品名称|>代码|>价格(元)|>药品类别|>剂型|>单位|>生产厂家|>等级|>收费依据
ClassMethod GetMedInfo(MedAlias As %String = "")
{
	q:$g(MedAlias)="" 0
    K PLIST
    k ^TMPtext($j) 
    s Num=0 
    ;and inca_inci_dr->INCI_ARCIM_DR->ARCIM_ItemCat_DR->ARCIC_OrderType="Drug"
    &sql( declare Aliascur cursor for  
          select distinct inca_inci_dr,inca_text from inc_Alias
      where %ALPHAUP(inca_Text) %STARTSWITH %ALPHAUP(:MedAlias))
    &sql(open Aliascur)
    f  &sql(fetch Aliascur into :incidr,:AliasName) q:SQLCODE  d
    .;w !,incidr_"^"_AliasName
    .s arcim=$p($g(^INCI(incidr,1)),"^",3)
    .q:arcim=""
    .q:$d(^TMPtext($j,incidr)) 
    .;q:$$HasQty(incidr)'=1					//判断药品是否有库存
    .b  ;GetMedInfo
    .s subcatid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
    .q:subcatid=""
    .s subdesc=$p($g(^ARC("IC",subcatid)),"^",2)
    .s subdesc=$$ALPHAUP^SSUTIL4(subdesc)
    .q:subdesc="HIDE"
    .s subcattype=$p($g(^ARC("IC",subcatid)),"^",7)
    .q:(subcattype'="R")
     .;w !,arcim_"^"_subcattype
    .s arcto=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
    .q:(arcto'="")&(arcto<+$h)
    .s ^TMPtext($j,incidr)=""
    .s ret=..GetNameInfo(incidr)
    .q:ret=""
    .s price=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,+$h,"","","","")
    .s price=$p(price,"^",1)
    .q:$j(price,3,4)="0.0000"
    .s phcid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",12)
    .s tarid=$o(^DHCOLT(0,"ARTTA",arcim,""),-1)
    .s:(tarid'="")&&($d(^DHCTARI(tarid))) tarcode=$p($g(^DHCTARI(tarid)),"^",1),chargebasis=$p($g(^DHCTARI(tarid)),"^",20) //等级
    .s:(phcid'="")&&($d(^PHCD(+phcid,"DF",$p(phcid,"||",2)))) dfid=$p($g(^PHCD(+phcid,"DF",$p(phcid,"||",2),1)),"^",1)
    .s:(dfid'="")&&($d(^PHCF(dfid))) dfdes=$p($g(^PHCF(dfid)),"^",2)
    .s arcimdesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
    .s medname=arcimdesc
    .s comname=..GetDrugCommonNameByArcimId(arcim)
    .i $g(comname)'="" s medname=comname
    .s Num=Num+1
    .s PLIST(Num)=medname_"^"_$g(tarcode)_"^"_$j(price*convqty,3,4)_"^"_ARCDESC_"^"_$g(dfdes)_"^"_$g(puom)_"^"_$g(manf)_"^"_$g(bmname)_"^"_$G(chargebasis)     //整包装价格
    .;w !,Num_"^"_PLIST(Num)
    .;w PLIST(Num),!
     .//s PLIST(Num)=medname_"^"_$j(price,3,4)_"^"_ARCDESC_"^"_uom_"^"_manf_"^"_bmname            //基本单位价格
     &sql(close Aliascur)
    q 0
}

ClassMethod GetNameInfo(initmdr)
{
    s P1=""
    q:initmdr="" ""_"^"_""_"^"_""_"^"_""
    ;^INASP(0,"INCI",{INASP_INCI_DR},{INASP_ExecuteDate},{INASP_Rowid})
    s maxdate=0
    s exdate="" f  s exdate=$O(^INASP(0,"INCI",initmdr,exdate)) q:exdate=""  d
    .i exdate>maxdate s maxdate=exdate
    i maxdate'=0  d
    .s adjrow=$O(^INASP(0,"INCI",initmdr,maxdate,"")) ;IN_AdjSalePrice
    .s price=$p(^INASP(adjrow),"^",7)
    .s medname=$P(^INCI(initmdr,1),"^",2) ;INC_Itm
    .s itmcode=$P(^INCI(initmdr,1),"^",1)
    .;s aliasrowid=..GEtalia(initmdr)
    .;s bmname=$p(^INCALIAS(+aliasrowid),"^",4)
    .s manf1=..GetManfName1(itmcode)
    .s manf=manf1 
    .s:$l(manf1,"-")>1 manf=$p(manf1,"-",2) 
    .s uomdr=$P(^INCI(initmdr,1),"^",10)
    .s puomdr=$P(^INCI(initmdr,3),"^",6)
    .s MedUom=$P($g(^CT("UOM",uomdr)),"^",2)
    .s puom=$P($g(^CT("UOM",puomdr)),"^",2)
    .s convqty=+$$ConvFac^ST02(puomdr,uomdr)
    .i convqty=0 s convqty=1
    .s incrowid=$p(^INASP(adjrow),"^",4)        
    .S ARCrowid=$P(^INCI(incrowid,1),"^",3)      
    .S ARCrowid1=$P(^ARCIM($p(ARCrowid,"||",1),1,1),"^",10)
    .s ARCDESC=$P(^ARC("IC",ARCrowid1),"^",2)
    .s P1=medname_"^"_MedUom_"^"_ARCDESC_"^"_manf  ;_"^"_bmname
    e  s P1=""
    q P1
}

/// Creator:yyx
/// CreateDate:2009-12-08
/// Function  :查询药品的价格
/// OutPut    :药品名称|>代码|>价格(元)|>药品类别|>剂型|>单位|>生产厂家|>等级|>收费依据
ClassMethod FindMedInfoByAliasExecute(ByRef qHandle As %Binary, MedAlias) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1   
    k ^TMPtext
    &sql( declare Aliascur1 cursor for  
          select distinct inca_inci_dr,inca_text from inc_Alias   
      where %ALPHAUP(inca_Text) %STARTSWITH %ALPHAUP(:MedAlias))
    &sql(open Aliascur1)
    f  &sql(fetch Aliascur1 into :incidr,:AliasName) q:SQLCODE  d   
    .;w !,incidr_"^"_AliasName
    .s arcim=$p($g(^INCI(incidr,1)),"^",3)
    .q:arcim=""
    .q:$d(^TMPtext($j,incidr))
    .s ^TMPtext($j,incidr)="" 
    .q:..HasQty(incidr)'=1					//判断药品是否有库存
    .s subcatid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
    .q:subcatid=""
    .s subdesc=$p($g(^ARC("IC",subcatid)),"^",2)
    .s subdesc=$$ALPHAUP^SSUTIL4(subdesc)
    .q:subdesc="HIDE"
    .s subcattype=$p($g(^ARC("IC",subcatid)),"^",7)
    .q:(subcattype'="R")
     .;w !,arcim_"^"_subcattype
    .s arcto=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
    .q:(arcto'="")&(arcto<+$h)
    .
    .;b ;FindMedInfoByAliasExecute
    .s ret=..GetNameInfo(incidr)
    .q:ret=""
    .s price=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,+$h,"","","","")
    .s price=$p(price,"^",1)
    .q:$j(price,3,4)="0.0000"
    .s phcid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",12)
    .s tarid=$o(^DHCOLT(0,"ARTTA",arcim,""),-1)
    .s:(tarid'="")&&($d(^DHCTARI(tarid))) tarcode=$p($g(^DHCTARI(tarid)),"^",1),chargebasis=$p($g(^DHCTARI(tarid)),"^",20) //等级
    .s:(phcid'="")&&($d(^PHCD(+phcid,"DF",$p(phcid,"||",2)))) dfid=$p($g(^PHCD(+phcid,"DF",$p(phcid,"||",2),1)),"^",1)
    .s:(dfid'="")&&($d(^PHCF(dfid))) dfdes=$p($g(^PHCF(dfid)),"^",2)
    .s arcimdesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
    .s medname=arcimdesc
    .;b ;1
    .s comname=..GetDrugCommonNameByArcimId(arcim)
    .i $g(comname)'="" s medname=comname
    .;s PLIST(Num)=medname_"^"_$g(tarcode)_"^"_$j(price*convqty,3,4)_"^"_ARCDESC_"^"_$g(dfdes)_"^"_$g(puom)_"^"_$g(manf)_"^"_$g(bmname)_"^"_$G(chargebasis)     //整包装价格
    .;w !,Num_"^"_PLIST(Num)
    .Do OutputRow3
    &sql(close Aliascur1)
   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(ind,$g(medname),$g(tarcode),$j(price*convqty,3,4),$g(ARCDESC),$g(dfdes),$g(puom),$g(manf),$g(bmname),$G(chargebasis))

 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMedInfoByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMedInfoByAliasExecute ]
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

ClassMethod FindMedInfoByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMedInfoByAliasExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//

Query FindMedInfoByAlias(MedAlias As %String = "") As %Query(CONTAINID = 1, ROWSPEC = "序号,药品名称,代码,价格,药品类别,剂型,单位,生产厂家,等级,收费依据")
{
}

/// 根据卡号取登记号
ClassMethod GetRegNoByCardNo(CardNo)
{
	new (CardNo)
	s CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))
	i CardID'="" s PAPMINo=$p($g(^DHCCARD("CF",CardID)),"^",6)
	q $g(PAPMINo)
}

ClassMethod GetSpec(inci As %String) As %String
{
	//s inci=$o(^INCI(0,"ARCIM_DR",arcim,"")) 根据医嘱项取库存项Rowid
	;???,2007-07-23,zdm
	n (inci)
	q:inci="" ""
	s inci=+inci

	//***?????
	q $p($g(^INCI(inci,3)),"^",9)
}

ClassMethod ApptScheduleListQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ApptScheduleListQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 	  GBP
/// CreatDate：	  2010-01-28  
/// Description:  排班记录查询
/// Table:		  
/// Input:		  AdmLocID (科室ID),ScheduleDate(出诊日期)
/// Output:		  ID(排班ID),CTLocDesc(科室名称),CTPCPDesc(医生名称),ASRoomDesc(诊室名称),
///            	  ASDate(出诊日期),TimeRangeDesc(出诊时段),SessionTypeDesc(出诊级别)
/// 			  TotalNum(正号限额),BookNum(预约限额),OverBookNum(加号限额),AppStartNo(预约起始号),QueueNO(排号)
/// 			  Status(出诊状态),RegisterNum(已挂号数),TRDoc(替诊/被替诊医生)
/// Return:		  
/// Others:		  No
ClassMethod ApptScheduleListQueryExecute(ByRef qHandle As %Binary, AdmLocID As %String, ScheduleDate As %String) As %Status
{
	;s ^zhou("ApptScheduleListQuery")=LocationName_","_ClinicGroupName_","_DoctorName_","_ScheduleDate_","_ASRowId
	;d ##class(%ResultSet).RunQuery("web.DHCIPBillTouchFee","ApptScheduleListQuery","13","")
	Set repid=$I(^CacheTemp)
	//Set QHandle=$lb(0,repid,0)
	//s ^test("repid")=repid
	//Quit $$$OK
	If $g(ind)="" Set ind=1
	if (ScheduleDate="")&&(AdmLocID="") 
	{
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
	}
	if (ScheduleDate'="") {
		s ScheduleDate=$zdh(ScheduleDate,5)
		}else{
		set ScheduleDate=+$H
		}
	s ResRowId="" f  s ResRowId=$O(^RB("RES",ResRowId)) q:(ResRowId="")  d
	.s RESLocDr=$p(^RB("RES",ResRowId),"^",1)
	.q:(AdmLocID'="")&&(AdmLocID'=RESLocDr)
	.s CTLocDesc=$p($g(^CTLOC(RESLocDr)),"^",2)
	.s RESPcpDr=$p(^RB("RES",ResRowId),"^",2)
	.s CTPCPDesc=$p($g(^CTPCP(RESPcpDr,1)),"^",2)
	.q:'$d(^RBAS(ResRowId,0,"DateSTime",ScheduleDate))
	.s ASSessStartTime=0 f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	..s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	...s StartTime=ASSessStartTime
	...s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	...;Q:(StartTime'="")&&(AdmTime'>StartTime)
	...;Q:(EndTime'="")&&(AdmTime'<EndTime)
	...s ASRoomDR=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
	...s ASRoomDesc="" //$p($g(^CTLOC(ASRoomDR)),"^",2)
	...s ASDate=$P($G(^RBAS(ResRowId,ASChildSub)),"^",1)
	...s ASDate=$zd(ASDate,3)
	...s TotalNum=$P($G(^RBAS(ResRowId,ASChildSub)),"^",8)
	...s SessLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",9)
	...s BookNum=$P($G(^RBAS(ResRowId,ASChildSub)),"^",2)
	...s OverBookNum=$p(^RBAS(ResRowId,ASChildSub,"DHC"),"^",3)
	...s QueueNO=$p(^RBAS(ResRowId,ASChildSub,"DHC"),"^",6)
	...s retnum=##class(web.DHCRBResourceRule).GetRegisterNum(QueueNO)
	...s RegisterNum=$P(retnum,"^",1)
	...s QueueNO=##class(web.DHCRBResourceRule).GetFreeQueueNO(QueueNO)
	...s AppStartNo=$P($G(^RBAS(ResRowId,ASChildSub)),"^",10)
	...s SessNoSlots=$P($G(^RBAS(ResRowId,ASChildSub)),"^",1)
	...s SessNoApptSlot=$P($G(^RBAS(ResRowId,ASChildSub)),"^",11)
	...s SessNumberOfWeeks=$P($G(^RBAS(ResRowId,ASChildSub)),"^",1)
	...s ASQueueNoCount=$P($G(^RBAS(ResRowId,ASChildSub)),"^",10)
	...s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub)),"^",17)
	...i TRRowId="" d
	....s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	...i TRRowId'="" s TimeRangeDesc=$P(^DHCTimeRange(TRRowId),"^",2) 
	...s Status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	...i Status'="" s Status=$P(^DHCRBCASStatus(Status),"^",1)
	...i Status="N"   s Status="正常"
    ...i Status="TR"  s Status="被替诊"
    ...i Status="R"   s Status="替诊"
    ...i Status="S"   s Status="停诊"
	...s SESSsessionTypeDr=$p(^RBAS(ResRowId,ASChildSub,"DHC"),"^",6)
	...i SESSsessionTypeDr'="" s SessionTypeDesc=$P(^RBC("SESS",SESSsessionTypeDr),"^",2)
	...s TRRBASRowId=$p(^RBAS(ResRowId,ASChildSub,"DHC"),"^",12)
	...s TRDoc=""
	...i (TRRBASRowId'="") d
	....i $d(^RB("RES",+TRRBASRowId)) d
	.....s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
	.....s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
	...s ASRowId=ResRowId_"||"_ASChildSub
	...Do OutputRow11
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow11 
	set Data=$lb(ASRowId,CTLocDesc,ASRoomDesc,CTPCPDesc,TimeRangeDesc,ASDate,SessionTypeDesc,RegisterNum,TotalNum,BookNum,OverBookNum,Status,TRDoc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod ApptScheduleListQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ApptScheduleListQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//,诊室,医生,出诊时段,出诊日期,出诊级别,已挂号数,正号限额,预约限额,加号限额,状态,替诊医生

Query ApptScheduleListQuery(AdmLocID As %String, ScheduleDate As %String) As %Query(ROWSPEC = "ID,科室,诊室,医生,出诊时段,出诊日期,出诊级别,已挂号数,正号限额,预约限额,加号限额,状态,替诊医生")
{
}

/// Creator:GBP 
/// CreateDate:2009-01-28
/// Function  :查询门诊排班科室
ClassMethod FindLocExecute(ByRef QHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCRBResSession","FindLoc","zl")
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","O",rowid)) q:rowid=""  d
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTDesc=$P(CTDesc,"-",2)
	.Do OutputRow10
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow10 
	set Data=$lb(CTDesc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindLoc() As %Query(ROWSPEC = "科室名称,科室ID")
{
}

}
