Import SQLUser

Class web.DHCBillCons1 Extends BILL.COM.Abstract
{

/// OPPreSum: 预收
/// OPChargeSum: 找零
/// OPRoundSum: 舍入
/// 目的是为了给每张发票打入一个收入，找零和舍入的节点值
ClassMethod BuildOPCINVRound(PreSum As %String, ChargeSum As %String, RoundSum As %String, PayModeDR As %String, ExpStr As %String) As %String
{
	set myCTLoc=$p(ExpStr,"^",2)
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myCTLoc)
	
	quit:('$d(^||TMP("BillINV",$j))) 0
	
	set myINVCount=+$g(^||TMP("BillINV",$j))
	
	set myInvIdx=0
	for  set myInvIdx=$o(^||TMP("BillINV",$j,myInvIdx)) quit:((myInvIdx=""))  do
	.if (myInvIdx=myINVCount) do
	..set:(+PreSum>0) ^||TMP("BillINV",$j,myInvIdx,"OPPreSum")=+PreSum
	..set ^||TMP("BillINV",$j,myInvIdx,"OPChargeSum")=+ChargeSum
	..;
	..set myPatPaySum=^||TMP("BillINV",$j,myInvIdx,"PatPaySum")
	..set myCurPreSum=##class(web.DHCBillConsIF).OPCRound(myPatPaySum, myHospDR, PayModeDR)
	..set RoundSum=$fn(myCurPreSum-myPatPaySum,"",2)
	..set ^||TMP("BillINV",$j,myInvIdx,"OPRoundSum")=+RoundSum
	.else  do
	..set myPatPaySum=^||TMP("BillINV",$j,myInvIdx,"PatPaySum")
	..set myCurPreSum=##class(web.DHCBillConsIF).OPCRound(myPatPaySum, myHospDR, PayModeDR)
	..set myCurChargeSum=0
	..;多收的在字段中显示为正，少收在字段中显示为负
	..set myCurRoundSum=$fn((myCurPreSum-myPatPaySum),"",2)
	..set PreSum=PreSum-myCurPreSum
	..set ChargeSum=ChargeSum-myCurChargeSum
	..set RoundSum=RoundSum-myCurRoundSum
	..set:(+PreSum>0) ^||TMP("BillINV",$j,myInvIdx,"OPPreSum")=+myCurPreSum
	..set ^||TMP("BillINV",$j,myInvIdx,"OPChargeSum")=+myCurChargeSum
	..set ^||TMP("BillINV",$j,myInvIdx,"OPRoundSum")=+myCurRoundSum
	
	quit 0
}

/// Description: 获取当前医嘱的费别
/// Debug: w ##class(web.DHCBillCons1).GetCurrentOrdInsType()
ClassMethod GetCurrentOrdInsType(OEORIDR As %String, INSType As %String, HospDR As %String) As %String
{
	//获取系统的费别类型
	set rtnValue=##class(web.DHCOPConfig).GetOPUseFareTypeConfig(HospDR)
	set myFareType=+$p(rtnValue,"^",2)
	
	//获取此费别的费用类型
	set rtnValue=##class(web.DHCOPConfig).ReadINSInfoByINS(INSType)
	set myINSFareType=+$p(rtnValue,"^",4)
	
	set myINSType=INSType   //默认为操作员手工指定的费别
	
	if ((+myFareType=0)||(+myINSFareType'=0)) {
		//使用医生工作站指定的费别
		set ordInsType=$p($g(^OEORD($p(OEORIDR,"||",1),"I",$p(OEORIDR,"||",2),11)),"^",18)    //OE_OrdItem->OEORI_BBExtCode
		if (ordInsType="") set ordInsType=##class(web.DHCBillCons).ReadDefInsType(HospDR)	  //按照默认费别
		set myINSType=ordInsType
	}
	
	quit myINSType
}

/// Creator: Lid
/// CreatDate: 2015-03-24
/// Description: 门诊收费时把作废医嘱按停止医嘱处理
/// Input: orderstatus:医嘱状态表rowid(oec_orderstatus)
/// Return: 医嘱状态表rowid
/// Debug: w ##class(web.DHCBillCons1).ResetOrderStatus()
ClassMethod ResetOrderStatus(ordStatus As %String) As %String
{
	quit:(+ordStatus=0) ordStatus
	set ostatCode=$p(^OEC("OSTAT",ordStatus),"^",1)
	if (ostatCode="U") {
		set ostatCode="D"
		set ordStatus=$o(^OEC("OSTAT",0,"Code",ostatCode,0))
	}
	quit ordStatus
}

}
