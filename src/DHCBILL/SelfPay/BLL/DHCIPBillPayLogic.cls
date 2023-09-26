Import SQLUser

/// wangjian
/// 2018-03-21
/// 门诊第三方及自助支付业务处理类
Class DHCBILL.SelfPay.BLL.DHCIPBillPayLogic Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 根据就诊ID取患者未结算总额
/// w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).TotalAmount(275)
ClassMethod TotalAmount(Adm) As %String
{
	n (Adm)
	s Total=0
	s PBRowID=0
	f  s PBRowID=$o(^DHCPB(0,"ADM",Adm,PBRowID))  q:(PBRowID="")  d
	.s PBData=$g(^DHCPB(PBRowID))
	.q:(PBData="")
	.s PayedFlag=$p(PBData,"^",16)
	.q:(PayedFlag="P")
	.s PBAmt=$p(PBData,"^",8)
	.s Total=Total+PBAmt
	q $fn(Total,"",2)
}

/// 根据就诊ID取患者未结算押金总额
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).Deposit(275)
ClassMethod Deposit(Adm As %String) As %String
{
	n (Adm)
	q ##class(web.UDHCJFBaseCommon).deposit(Adm)
}

/// 根据就诊取患者本次就诊费用总额
ClassMethod AllTotalAmount(Adm) As %String
{
	n (Adm)
	s Total=0
	s PBRowID=0
	f  s PBRowID=$o(^DHCPB(0,"ADM",Adm,PBRowID))  q:(PBRowID="")  d
	.s PBData=$g(^DHCPB(PBRowID))
	.q:(PBData="")
	.s PayedFlag=$p(PBData,"^",16)
	.s Refundflag=$p(PBData,"^",17)
	.q:(Refundflag'="")
	.s PBAmt=$p(PBData,"^",8)
	.s Total=Total+PBAmt
	q $fn(Total,"",2)
}

/// wangjian
/// 自助机出院结算将出院结算需要核查的费用相关信息统一封装
/// Output: 非0^不能结算原因  否则返回0 
/// w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).CheckFee(152049,544161)
ClassMethod CheckFee(Adm As %String, BillNo As %String, PatFee As %String = "") As %String
{
	n (Adm, BillNo, PatFee)
	;就诊状态
	;s AdmStatusCode=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(Adm)
	;s AdmStatus=$case(AdmStatusCode,"E":"医生办理出院","C":"医生撤销出院","F":"护士办理出院","R":"护士撤销出院","B":"费用调整","T":"结束费用调整",:"在院")
	;q:(AdmStatusCode'="F")&&(AdmStatusCode'="T") "-201^患者为"_AdmStatus_"状态不允许办理出院结算"
	;验证三张表
	s err=0
	s PboSum=0,PbdSum=0
	s PbSum=$p(^DHCPB(BillNo),"^",12)
	s PboSub=0
    f  s PboSub=$o(^DHCPB(BillNo,"O",PboSub)) q:(PboSub="")  d
    .s PboData=$g(^DHCPB(BillNo,"O",PboSub))
    .q:(PboData="")
 	.s PboAmt=$p(PboData,"^",11)
    .s PboSum=PboSum+PboAmt
    .s PbdSub=0
    .f  s PbdSub=$o(^DHCPB(BillNo,"O",PboSub,"D",PbdSub)) q:PbdSub=""  d
    ..s PbdAmt=$p(^DHCPB(BillNo,"O",PboSub,"D",PbdSub),"^",10)
    ..s PbdSum=PbdSum+PbdAmt
    i (+PbSum'=+PboSum)||(+PbSum'=+PbdSum)||(+PboSum'=+PbdSum) d
    .s err=-2
    i (+$g(PatFee)'=+PbSum)&&(+PatFee'=0) d
    .s err=-3
    q:err=-2 "-202^账单表不平不允许结算"
    q:err=-3 "-203^传入的总金额与账单总金额不符"
	;婴儿结算
	s CheckBabyInfo=##class(web.UDHCJFCOMMON).CheckBabyAdmDisCharge(Adm)
	s err=$p(CheckBabyInfo,"^",1)
	q:err=-1 "-204^有婴儿未结算,母亲不允许结算"
	q:err=-2 "-205^婴儿是"_AdmStatus_"状态,母亲不允许结算"
	;费用审核
	;s FeeCheckFlag= ##class(web.UDHCJFBillDetailOrder).GetCodingFlag(Adm, BillNo)
	;q:FeeCheckFlag'="Y" "-206^此病人费用还未审核通过,不允许结算"
    s FeeCheckInfo=##class(web.DHCIPBillCheckAdmCost).AdmSettlementCheck(Adm, BillNo)
    s err=$p(FeeCheckInfo,$c(2),1)
    q:(+err) $p(FeeCheckInfo,$c(2),2)
    
	q err_"^"_"正常"
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).GetDepositList(152049)
ClassMethod GetDepositList(Adm) As %String
{
	n (Adm)
	s depoistlist="^"
	s depRowId=0 
	f  s depRowId=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,depRowId))  q:(depRowId="")  d
	.s depData=$g(^DHCSFPRINTDETAIL(depRowId))
	.s depTypeDR=$p(depData,"^",13)
	.q:(depTypeDR="")
	.s depTypeCode=$p($g(^ARC("ARCDT",depTypeDR)),"^",1)
	.q:(depTypeCode'="01")
	.s payedFlag=$p(depData,"^",38)    //prt_paidflag
	.q:(payedFlag'="Y")    //过滤未参与结算的
	.s paymSub=$o(^DHCSFPRINTDETAIL(depRowId,"P",0))
	.s paymSubData=$g(^DHCSFPRINTDETAIL(depRowId,"P",+paymSub))
	.s paymDR=$p(paymSubData,"^",9)
	.s paymCode=$s((paymDR'=""):$p(^CT("CTPM",paymDR),"^",1),1:"")
	.s prtStatus=$p(depData,"^",8)
	.s depoistlist=depoistlist_depRowId_"^"
 	
	q depoistlist
}

/// 模拟界面添加的支付方式列表串
ClassMethod GetBillPaymode(Adm, BillNo, Deposit, Paymode) As %String
{
	n (Adm, BillNo, Deposit, Paymode)
	s List=""
	s NationalCode=""
	s AdmReasonDr=$p(^PAADM(Adm,1),"^",7)
	i AdmReasonDr'="" d
	.s NationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
	s Total=+$p(^DHCPB(BillNo),"^",8)
	s SlefAmt=Total ;默认支付金额为总金额
	;
	s PaymodeDesc=$p(^CT("CTPM",Paymode),"^",2)
	;支付方式ID^银行@子行^卡号支票号^PAYM_GovernNo^PAYM_AuthorCode^金额^PAYM_Branch
	i +NationalCode=0 d
	.;自费
	.s Pay=SlefAmt-Deposit
	.s Balance=Pay
	.s List="&"_Pay_"&"_Paymode_"^@^^^^"_Balance_"^^^"_PaymodeDesc
	e  d
	.;医保
	.s InsuInfo=##class(web.DHCINSUPort).GetBackStringByBillNo(BillNo)
	.i InsuInfo'="-1" d
	..s SlefAmt=$p($p(InsuInfo,$c(2),1),"^",2)
	..s Pay=SlefAmt-Deposit
	..s Balance=Pay
	..s InsuPayStr=""
	..f i=2:1:$l(InsuInfo,$c(2)) d
	...s PaymInfo=$p(InsuInfo,$c(2),i)
	...q:PaymInfo=""
	...s PaymDr=$p(PaymInfo,"^",1)
	...q:PaymDr=""
	...s PaymDesc=$p(^CT("CTPM",PaymDr),"^",2)
	...s PayAmt=$p(PaymInfo,"^",2)
	...s InsuPayStr=InsuPayStr_"&"_PaymDr_"^@^^^^"_PayAmt_"^N^Y"_PaymDesc
	..s List="&"_Pay_InsuPayStr_"&"_Paymode_"^@^^^^"_Balance_"^^^"_PaymodeDesc
	
	q List
}

/// Creator: Suhuide
/// CreatDate: 2021-08-17
/// Description: 根据患者ID找到有效住院证
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).GetIPBookIDByPatientID(Papmi)
ClassMethod GetIPBookIDByPatientID(patientId As %String) As %String
{
	new (patientId)
	set IPBookId=""
	set id=""
	while($o(^DHCDocIPBK(0,"PatientID",patientId,id),-1)) {
		set id=$o(^DHCDocIPBK(0,"PatientID",patientId,id),-1)
		set isActive=##class(web.DHCBillInterface).IIsIPBook(id)
		continue:(isActive'="")
		set IPBookId=id
		quit
	}
	
	quit IPBookId
}

/// 供自助机结算自负部分唯一支付方式
/// 支付方式ID^金额(原路退会有多种)
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).GetPatShareInfo(278542)
ClassMethod GetPatShareInfo(PrtInvRowID)
{
	n (PrtInvRowID)
	s PaymodeStr=""
	q:(PrtInvRowID="") PaymodeStr
	s PaymSub=0
	f  s PaymSub=$o(^DHCINVPRTZY(PrtInvRowID,"P",PaymSub)) q:(PaymSub="")  d
	.s PaymSubData=$g(^DHCINVPRTZY(PrtInvRowID,"P",PaymSub))
	.s PaymDR=$p(PaymSubData,"^",1)
	.s PaymAmt=$p(PaymSubData,"^",3)
	.q:(PaymAmt=0)
	.s InsuFlag=$p(PaymSubData,"^",9)
	.q:(InsuFlag="Y")
	.i (PaymodeStr="") s PaymodeStr=PaymAmt_"@"_"'"_PaymDR_"'"
	.e  s PaymodeStr=PaymodeStr_"^"_PaymAmt_"@"_"'"_PaymDR_"'"
	
	q PaymodeStr
}

}
