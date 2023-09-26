Import sqluser

Class DHCBILL.Diet.DHCIPMealFeePay Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Function:结算账单费用
/// Table:dhc_ipmealinvprt,dhc_ipmealorditem,dhc_ipmealbill
ClassMethod LanPay(BillRowID, PayUser, PatLanFee, Deposit, Flag)
{
   tstart
   k PLIST
   S Adm=$P(^DHCIPMEALBILL(BillRowID),"^",1)
   ;s DepStr=..GetPatLanchDeposit(Adm,"N")
   s AdmReason=$p(^PAADM(Adm,1),"^",7)
   s PrtDate=+$h
   s PrtTime=$p($h,",",2)
   &sql(insert into dhc_ipmealinvprt(dhcmi_adm,dhcmi_prtdate,dhcmi_acount,dhcmi_user,dhcmi_flag,dhcmi_pattype,dhcmi_bill_dr,dhcmi_prttime)
   values (:Adm,:PrtDate,:PatLanFee,:PayUser,:Flag,:AdmReason,:BillRowID,:PrtTime))
   s err=SQLCODE
   ;s err=##class(DHCBILL.Diet.DHCIPMealInvprt).INSERT()
   s LanRowId=$g(%ROWID)
   i err=0 d
   .&sql(update dhc_ipmealbill set dhcmb_paidflag='Y' where dhcmb_rowid=:BillRowID)
   .s err=SQLCODE
   i err=0 d
   .d ..UpdateOrdItmBillFlag(BillRowID)
   i err=0 tcommit
   e  d
   .trollback
   q err
}

ClassMethod GetPatLanchDeposit(Adm, PaidFlag)
{
    ;按押金类型取病人的已结算或未结算押金总额
    s DepositList=""
	s DepositSum=0
	s rowid=""
	f  s rowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,rowid)) q:rowid=""  d
	.s DepositTypeRowId=$p(^DHCSFPRINTDETAIL(rowid),"^",13)
	.s TypeDesc=$p(^ARC("ARCDT",DepositTypeRowId),"^",2) 
	.q:TypeDesc'="伙食押金"
	.s PayAmt=$p(^DHCSFPRINTDETAIL(rowid),"^",6)
	.s PrtFlag=$p(^DHCSFPRINTDETAIL(rowid),"^",8)
	.s InvDr=$p(^DHCSFPRINTDETAIL(rowid),"^",38)
	.q:(InvDr'="")&(PaidFlag="N")
	.q:(InvDr="")&(PaidFlag="Y")
	.q:PrtFlag="2"
	.s DepositSum=DepositSum+PayAmt
	.i DepositList'="" s DepositList=DepositList_"^"_rowid
	.e  s DepositList=rowid
	q DepositSum_"!"_DepositList
}

ClassMethod UpdateOrdItmBillFlag(BillRowID)
{
	s ChildSub=0
	f  s ChildSub=$o(^DHCIPMEALBILL(BillRowID,"D",ChildSub)) q:ChildSub=""  d
	.s MORowID=$p(^DHCIPMEALBILL(BillRowID,"D",ChildSub),"^",1)
	.s $p(^DHCIPMEALORDER(+MORowID,"I",$p(MORowID,"||",2)),"^",17)="P"
}

}
