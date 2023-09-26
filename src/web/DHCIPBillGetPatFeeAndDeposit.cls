/// Creator:yyx
/// creatdate:2009-06-16
/// Function:肿瘤医院要求将病人的医保押金，自费押金，医保费用，自付费用，医保余额，自费余额分别显示
Class web.DHCIPBillGetPatFeeAndDeposit Extends %RegisteredObject
{

/// Creator:yyx 
/// CreateDate:2009-06-16
/// Function:根据病人的就诊rowid,取当前病人的未红冲的医保(DepositInsu)，自费预交金(DepositSelf)
ClassMethod GetPatDeposit(Adm)
{
    ;get current patient's deposits
	k PLIST
	s DepositInsu=0,DepositSelf=0
	i '$d(^ARRCP("Adm_DR",+Adm)) q "0.00"_"^"_"0.00"
	s ARRCPRowID="",dep=0,n=0 
	f  s ARRCPRowID=$o(^ARRCP("Adm_DR",+Adm,ARRCPRowID))  q:ARRCPRowID=""  d
	.s ARRCPSub=""  f  s ARRCPSub=$o(^ARRCP("Adm_DR",Adm,ARRCPRowID,ARRCPSub))  q:ARRCPSub=""   d
	..q:'$d(^DHCSFPRINTDETAIL(0,"RcptDR",ARRCPRowID))
	..s DepositInfo=^ARRCP(ARRCPRowID,"RAL",ARRCPSub),ARPBLDr=$p(DepositInfo,"^",18),flag=$p(DepositInfo,"^",5)
	..s Deposit=+$p(DepositInfo,"^",2)
	..s DepTypeDr=$p(DepositInfo,"^",9)
	..q:(DepTypeDr="")
	..q:$d(^ARC("ARCDT",DepTypeDr))=0
	..s DepTypeCode=$p(^ARC("ARCDT",DepTypeDr),"^",2)
    ..i DepTypeCode="DepositInsu" s DepositInsu=DepositInsu+Deposit
    ..i DepTypeCode="DepositSelf" s DepositSelf=DepositSelf+Deposit
	q $j(DepositSelf,3,2)_"^"_$j(DepositInsu,3,2)
}

/// Creator:yyx 
/// CreateDate:2009-06-16
/// Function:根据病人的就诊rowid,取当前病人的未结算的医保费用，自费费用
ClassMethod GetPatUnPaidFee(PAADMRowID) As %String
{
    q:$g(PAADMRowID)="" 0.00_"^"_0.00
	s PatFee=0
	i $d(^DHCPB(0,"ADM",PAADMRowID))  d
	.s PBRowID=""
	.f  s PBRowID=$o(^DHCPB(0,"ADM",PAADMRowID,PBRowID))  q:PBRowID=""  d 
	..i $d(^DHCPB(PBRowID))  d
	...s PaidFLag=$p(^DHCPB(PBRowID),"^",16)
	...q:PaidFLag="P"
	...s PatientShare=$p($g(^DHCPB(PBRowID)),"^",8)               ;自付费用
	...s InsuPatientShare=$p($g(^DHCPB(PBRowID,"INSU",1)),"^",4)   ;医保费用
	...s SelfPatientShare=PatientShare-+$g(InsuPatientShare)
	q $j($g(SelfPatientShare),3,2)_"^"_$j($g(InsuPatientShare),3,2)
}

ClassMethod GetPatFeeDeposit(Adm)
{
	s DepositInfo=..GetPatDeposit(Adm)
	s FeeInfo=..GetPatUnPaidFee(Adm)
	s RemainSelf=+$p(DepositInfo,"^",1)-+$p(FeeInfo,"^",1)
	s RemainInsu=+$p(DepositInfo,"^",2)-+$p(FeeInfo,"^",2)
	//自费押金，医保押金，自费费用，医保费用，自费余额，医保余额
	q DepositInfo_"^"_FeeInfo_"^"_$j(RemainSelf,3,2)_"^"_$j(RemainInsu,3,2)
}

/// Creator:yyx
/// CreateDate:2009-06-17
/// Function:取病人的医保押金，医保费用，医保余额，自费押金，自费费用，自费余额
ClassMethod GetPatFeeDepositInfo(Adm)
{
	s PatInfo=##class(web.DHCIPBillGetPatFeeAndDeposit).GetPatFeeDeposit(Adm)
	s TDepositSelf=$p(PatInfo,"^",1),TDepositInsu=$p(PatInfo,"^",2)
	s TPatFeeSelf=$p(PatInfo,"^",3),TPatFeeInsu=$p(PatInfo,"^",4)
	s TRemainSelf=$p(PatInfo,"^",5),TRemainInsu=$p(PatInfo,"^",6)
	q TDepositSelf_"^"_TDepositInsu_"^"_TPatFeeSelf_"^"_TPatFeeInsu_"^"_TRemainSelf_"^"_TRemainInsu
}

}
