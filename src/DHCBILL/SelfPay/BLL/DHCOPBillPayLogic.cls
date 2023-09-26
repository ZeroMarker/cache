Import SQLUser

/// wangjian
/// 2018-03-14
/// 门诊第三方及自助支付业务处理类
Class DHCBILL.SelfPay.BLL.DHCOPBillPayLogic Extends BILL.COM.Abstract
{

/// 生成订单规则 (1按就诊费别生成 2按拆票规则生成)
Parameter CreatOrderFlag = 2;

/// 预结算锁定分钟数（撤销自己预结算不控制时间, 锁定时间范围内他人不可撤销预结算记录）
Parameter LockedMin = 3;

/// Input: ExpStr: UserID收费员ID^Grup安全组^GLoc默认登录科室^HospDR院区ID^TerminalID
/// Description: 根据就诊生成自助机结算单或者返回未结算结算单
ClassMethod GetOrder(CardNo As %String, Adm As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	
	set UserID=$p(ExpStr,"^",1)
	set Grup=$p(ExpStr,"^",2)
	set GLoc=$p(ExpStr,"^",3)
	set HospID=$p(ExpStr,"^",4)
	set TerminalID=$p(ExpStr,"^",5)
	
	lock +^DBLock("GetOrder",Adm):3
	if ('$Test) {
		quit ""
	}
	
	set RtnValue=##class(web.UDHCJFBILL).BILL(Adm, UserID)
	set Rtn=$p(RtnValue,"^",1)
	if (+Rtn) {
		lock -^DBLock("GetOrder",Adm)
		quit ""
	}
	
	set BillNoStr=""
	set PayedFlag=""
	set PBRowID=0
	for  set PBRowID=$o(^DHCPB(0,"ADM",Adm,PBRowID)) quit:(PBRowID="")  do
	.set PayedFlag=$p($g(^DHCPB(PBRowID)),"^",16)
	.quit:(PayedFlag'="B")
	.set BillNoStr=$s((BillNoStr=""):PBRowID,1:(BillNoStr_"^"_PBRowID))
	if (BillNoStr="") {
		lock -^DBLock("GetOrder",Adm)
		quit ""
	}
	
	set RecLoc=""
	if (Grup'="") {
		set RecLoc=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(Grup, HospID, GLoc)
	}
	set DefultInsType=$p(^PAADM(Adm,1),"^",7)
	//组织订单数据
	kill OPINSTypeArr
	set TBillCount=$l(BillNoStr,"^")
	for i=1:1:TBillCount do
	.set Bill=$p(BillNoStr,"^",i)
	.quit:(Bill="")
	.set AdmID=$p(^DHCPB(Bill),"^",1)
	.set PBO=0
	.for  set PBO=$o(^DHCPB(Bill,"O",PBO))  quit:(PBO="")  do
	..set PBOData=$g(^DHCPB(Bill,"O",PBO))
	..quit:(PBOData="")
	..set OEORI=$p(PBOData,"^",4)
	..set OrdRecLoc=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",6)
	..//quit:((RecLoc'="")&&(RecLoc'[OrdRecLoc))
	..set Billed=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",5)
	..quit:(" P I "[(" "_Billed_" "))
	..set StatDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
	..set StatCode=$s((StatDR'=""):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
	..quit:(" V E "'[(" "_StatCode_" "))
	..set Arcim=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
	..set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(Arcim, 0)
	..set Prescno=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",14)    //处方号
	..set Limit=""
	..if ((OrderType="R")&&(Prescno'=""))  do
	...if $d(PrescnoSkinAry($j,Prescno)) do
	....set Limit=PrescnoSkinAry($j,Prescno)
	...else  do
	....set Limit=##class(web.DHCOPAdmFind).CheckPrescnoSkinFlag(Prescno, "", "")
	....set PrescnoSkinAry($j,Prescno)=Limit
    ..set OrdIns=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORI, DefultInsType, HospID)   //根据结算配置可否按默认就诊费别
    ..set OPINSTypeArr(AdmID,"INS",OrdIns)=OrdIns
    ..if (Limit="Y")||((RecLoc'="")&&(RecLoc'[OrdRecLoc))  do
    ...set UnOrder=$g(OPINSTypeArr(AdmID,"INS",OrdIns,"UnOrder"))
    ...if (UnOrder="") set OPINSTypeArr(AdmID,"INS",OrdIns,"UnOrder")="^"_OEORI_"^"
    ...else  do
    ....if (UnOrder'[("^"_OEORI_"^")) set OPINSTypeArr(AdmID,"INS",OrdIns,"UnOrder")=OPINSTypeArr(AdmID,"INS",OrdIns,"UnOrder")_OEORI_"^" 
    ..else  do
    ...set BillOrder=$g(OPINSTypeArr(AdmID,"INS",OrdIns,"Order"))
    ...if (BillOrder="") set OPINSTypeArr(AdmID,"INS",OrdIns,"Order")="^"_OEORI_"^"
    ...else  do
    ....if (BillOrder'[("^"_OEORI_"^")) set OPINSTypeArr(AdmID,"INS",OrdIns,"Order")=OPINSTypeArr(AdmID,"INS",OrdIns,"Order")_OEORI_"^" 
	
	set HISOrderStr=""
	
	//根据全局变量 生的订单规则生成订单
	if (..#CreatOrderFlag=2) {
		//根据拆票规则生成订单
		//获取收费配置
		set myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(Grup, HospID)
		set Rtn=$p(myBCInfo,"^",1)
		if (+Rtn) {
			lock -^DBLock("GetOrder",Adm)
			quit ""
		}
		set RecInvCount=$p(myBCInfo,"^",8)
		set PrintCount=$p(myBCInfo,"^",9)

		set Rtn=0
		set InsTypeId=""
		for  set InsTypeId=$o(OPINSTypeArr(Adm,"INS",InsTypeId)) quit:((InsTypeId="")||(+Rtn))  do
		.set PayOEORIStr=$g(OPINSTypeArr(Adm,"INS",InsTypeId,"Order"))
		.//校验订单
		.set CheckInfo=..CheckOrder(Adm, InsTypeId, PayOEORIStr)
		.set NewFlag=$p(CheckInfo,"!",1)
		.if (NewFlag=1)  do
		..//此费别重新生成订单
		..set UnPayOEORIStr=$g(OPINSTypeArr(Adm,"INS",InsTypeId,"UnOrder"))
		..//"gLoc^LoadCTLoc^AccManRowID^RequirINVFlag^FairType^OPPreSum^OPChange^OPRoundErr"
		..set ParExpStr=Grup_"^"_GLoc_"^^"_"Y^F^^^0^"
		..do ##class(web.DHCBillConsIF).KTMP()
		..set Rtn=##class(web.DHCBillConsIF).GetBillData(BillNoStr, UnPayOEORIStr, InsTypeId, 0, ParExpStr)
		..quit:(+Rtn)
		..set Rtn=##class(web.DHCBillConsIF).ParDataToBill(RecInvCount, PrintCount, ParExpStr)
		..set RtnValue=..BuildOrder(CardNo, Adm, InsTypeId, "", PayOEORIStr, ExpStr)
		..set Rtn=$p(RtnValue,$c(2),1)
		..do ##class(web.DHCBillConsIF).KTMP()
		..quit:(+Rtn)
		..set ETPIDStr=$p(RtnValue,$c(2),2)
		.else  do
		..set ETPIDStr=$p(CheckInfo,"!",2)
		.do GetHISOrderStr
	}elseif (..#CreatOrderFlag=1) {
		//根据就诊和费生成订单
		set Rtn=0
		set InsTypeId=""
		for  set InsTypeId=$o(OPINSTypeArr(Adm,"INS",InsTypeId)) quit:((InsTypeId="")||(+Rtn))  do
		.set PayOEORIStr=$g(OPINSTypeArr(Adm,"INS",InsTypeId,"Order"))
		.//校验订单
		.set CheckInfo=..CheckOrder(Adm, InsTypeId, PayOEORIStr)
		.set NewFlag=$p(CheckInfo,"!",1)
		.if (NewFlag=1)  do
		..set RtnValue=..BuildOrder(CardNo, Adm, InsTypeId, BillNoStr, PayOEORIStr, ExpStr)
		..set Rtn=$p(RtnValue,$c(2),1)
		..quit:(+Rtn)
		..set ETPIDStr=$p(RtnValue,$c(2),2)
		.else  do
		..set ETPIDStr=$p(CheckInfo,"!",2)
		.do GetHISOrderStr
	}
	
	lock -^DBLock("GetOrder",Adm)
	
	quit HISOrderStr
	
GetHISOrderStr
	//拼结算的订单串
	for j=1:1:$l(ETPIDStr,"^") {
		set ETPRowID=$p(ETPIDStr,"^",j)
		continue:(+ETPRowID=0)
		set HisTradeNo=$p(^DHCBILLETP(ETPRowID),"^",32)
		set TMPStr=ETPRowID_"!"_HisTradeNo
		set HISOrderStr=$s((HISOrderStr=""):TMPStr,1:(HISOrderStr_"^"_TMPStr))
	}
	quit
ERROR
	do ..AppException()
	quit ""
}

/// Creator: wangjian
/// CreatDate: 2017-05-24
/// Description: 校验 未结算医嘱是否有增减 作废原结算单 返回重新生成结算单
/// Input: 
/// Return：0 返回原订单  1 重新生成订单 2 更新订单
/// Debug: w ##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).CheckOEORITrade("7470297","2","^7446014||16^")
ClassMethod CheckOrder(Adm As %String, InsTypeId As %String, PayOEORIStr As %String) As %String
{
	set NewTradeFlag=1  //默认生成新订单
	
	set ETPIDStr="", BillFlag="B"
	set StopOrdStr="", ETPOrderStr=""
	set AdmOrderSum=0
	set ToDayFlag="Y"
	set ETPRowID=0
	while($o(^DHCBILLETPi(0,"ADMINS",Adm,InsTypeId,ETPRowID))) {
		set ETPRowID=$o(^DHCBILLETPi(0,"ADMINS",Adm,InsTypeId,ETPRowID))
		set ETPData=$g(^DHCBILLETP(ETPRowID))
		set ETPRc=$p(ETPData,"^",1)
		continue:(ETPRc'="01")      //非待支付的不校验
		set ETPIDStr=$s((ETPIDStr=""):ETPRowID,1:(ETPIDStr_"^"_ETPRowID))
		set OrderSum=$p(ETPData,"^",23)
		set AdmOrderSum=$i(AdmOrderSum, OrderSum)
		set ETPDate=$p(ETPData,"^",21)
		if (ETPDate'=+$h) {
			set ToDayFlag="N"
			continue
		}
		set ETPSub=0
		while($o(^DHCBILLETP(ETPRowID,"O",ETPSub))) {
			set ETPSub=$o(^DHCBILLETP(ETPRowID,"O",ETPSub))
			set ETPSubData=$g(^DHCBILLETP(ETPRowID,"O",ETPSub))
			continue:(ETPSubData="")
			set OEORI=$p(ETPSubData,"^",1)
			set Billed=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",5)
			if (Billed="P") {
				set BillFlag=Billed
				continue           //有支付的医嘱一定需要重新生成
			}
			set StatDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
			set StatCode=$s((+StatDR'=0):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
			if (" V E "'[(" "_StatCode_" ")) {
				set StopOrdStr=$s((StopOrdStr=""):OEORI,1:(StopOrdStr_"^"_OEORI))
				continue
			}
			set ETPOrderStr=$s((ETPOrderStr=""):OEORI,1:(ETPOrderStr_"^"_OEORI))
		}
	}
	
	if ((StopOrdStr="")&&(BillFlag="B")&&(ToDayFlag="Y")) {
		set EquFlag=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).CheckStrEqu(ETPOrderStr, PayOEORIStr, "^")
		set NewTradeFlag=EquFlag
		if (EquFlag'=0) {
			//新增医嘱需要重新生成  撤销现有订单
			do CancelAliTrade
		}
	}else {
		//有停止医嘱或者线下结算或者订单跨天需要重新生成 撤销现有订单
		do CancelAliTrade
	}
	/*
	//2019-06-11 wangjian 增加金额校验针对调价
	set AdmOrderSum=$fn(AdmOrderSum,"",2)
	if (NewTradeFlag=0) {
		set PatSum=..GetOEORDSum(PayOEORIStr)
		if (+AdmOrderSum'=+PatSum) {
			set NewTradeFlag=1
			do CancelAliTrade
		}
	}
	*/
	
	quit NewTradeFlag_"!"_ETPIDStr
	
CancelAliTrade
	//撤销现有订单 将订单变成不可用状态
	for i=1:1:$l(ETPIDStr,"^") {
		set ETPRowID=$p(ETPIDStr,"^",i)
		continue:(ETPRowID="")
		&SQL(
			UPDATE DHC_BillExtTradePay
			SET ETP_Rc = '04', ETP_Rc_Detail = '订单作废'
			WHERE %ID = :ETPRowID
		)
	}
	
	quit
}

ClassMethod BuildOrder(CardNo As %String, Adm As %String, InsTypeId As %String, BillNoStr As %String, PayOEORIStr As %String, ExpStr As %String) As %String
{
	if (..#CreatOrderFlag=1) {
		//就诊费别生成订单
		set rtn=..BuildOrder1(CardNo, Adm, InsTypeId, BillNoStr, PayOEORIStr, ExpStr)
	}else {
		//预拆票生成订单
		set rtn=..BuildOrder2(CardNo, Adm, InsTypeId, ExpStr)
	}
	quit rtn
}

ClassMethod BuildOrder1(CardNo As %String, Adm As %String, InsTypeId As %String, BillNoStr As %String, PayOEORIStr As %String, ExpStr As %String) As %String
{
	kill HaveOEORIArr
	
	set UserID=$p(ExpStr,"^",1)
	set Grup=$p(ExpStr,"^",2)
	set GLoc=$p(ExpStr,"^",3)
	set HospID=$p(ExpStr,"^",4)
	set TerminalID=$p(ExpStr,"^",5)
	
	set Rtn=0
	set PatPaySum=0
	
	ts
	
	//先插入结算单主表
	set myExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospID_"^"_TerminalID_"^"_"OP"
	set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradePay(CardNo, Adm, InsTypeId, "C", PatPaySum, myExpStr)
	set Rtn=$p(RtnValue,"^",1)
	if (+Rtn) tro  quit Rtn
	set ETPRowID=$p(RtnValue,"^",2)
	set HisTradeNo=$p(RtnValue,"^",3)
	
	set TBillCount=$l(BillNoStr,"^")
	for i=1:1:TBillCount {
		set Bill=$p(BillNoStr,"^",i)
		continue:(+Bill=0)
		set PBO=0
		while($o(^DHCPB(Bill,"O",PBO))) {
			set PBO=$o(^DHCPB(Bill,"O",PBO))
			set PBOData=$g(^DHCPB(Bill,"O",PBO))
			continue:(PBOData="")
			set PBORowID=Bill_"||"_PBO
			set OEORI=$p(PBOData,"^",4)
			continue:(PayOEORIStr'[("^"_OEORI_"^"))   //非结算医嘱过滤
			continue:($d(HaveOEORIArr(OEORI)))          //插过的医嘱不再插入防止一个医嘱两个账单重复出现
			set Billed=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",5)
			continue:(" P I "[(" "_Billed_" "))
			set StatDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
			set StatCode=$s((+StatDR'=0):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
			continue:(" V E "'[(" "_StatCode_" "))
			set PatientShare=$p(PBOData,"^",11)
			set PatPaySum=$i(PatPaySum, PatientShare)
			set Rtn=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradeOrdSub(ETPRowID, PBORowID)
			quit:(+Rtn)
			set HaveOEORIArr(OEORI)=""
		}
	}
	if (+Rtn) tro  quit Rtn
	
	//InsertBankTradeSub
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_TradeAmt = :PatPaySum
		WHERE %ID = :ETPRowID
	)
	set Rtn=SQLCODE
	if (+Rtn) tro  quit Rtn_"^"_$g(%msg)
	
	if (+$tl>0) tc
	
	quit Rtn_$c(2)_ETPRowID
}

ClassMethod BuildOrder2(CardNo As %String, Adm As %String, InsTypeId As %String, ExpStr As %String) As %String
{
	kill HaveOEORIArr
	Kill HaveOECoverMainIns
	set UserID=$p(ExpStr,"^",1)
	set Grup=$p(ExpStr,"^",2)
	set GLoc=$p(ExpStr,"^",3)
	set HospID=$p(ExpStr,"^",4)
	set TerminalID=$p(ExpStr,"^",5)
	
	set PatientID=$p(^PAADM(Adm),"^",1)
	
	set Rtn=0

	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("ZZJOPCHAR.ZZJOPChar.CFDDJSAQZ", "", Grup, HospID)
	set success=##class(%DynamicObject).%FromJSON(jsonStr).success   //按医嘱中的自费医保标志拆订单

	ts
	
	set myExpStr=UserID_"^"_Grup_"^"_GLoc_"^"_HospID_"^"_TerminalID_"^"_"OP"

	set ETPRowIDStr=""
	set rbInvIdx=""
	while($o(^||TMP("BillINV",$j,rbInvIdx))){
		set rbInvIdx=$o(^||TMP("BillINV",$j,rbInvIdx))
		set rbinstype=""
		while($o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype))) {
			set rbinstype=$o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype))
			set rbarcpb=""
			while($o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb))) {
				set rbarcpb=$o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb))
				set rbordrid=""
				while($o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb,"ORD",rbordrid))) {
					set rbordrid=$o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb,"ORD",rbordrid))
					set PBOData=$g(^DHCPB(+rbordrid,"O",$p(rbordrid,"||",2)))
					set PatientShare=$p(PBOData,"^",11)
					set rbOEOrder=$p(PBOData,"^",4)
					set CoverMainIns=$p(^OEORD(+rbOEOrder,"I",$p(rbOEOrder,"||",2),3),"^",3)
					if (CoverMainIns="")  set CoverMainIns="2"
					else  set CoverMainIns="1"
					if (success'=1) set CoverMainIns="2"
					set HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype,CoverMainIns,"BR",rbarcpb,"ORD",rbordrid)=""
				}
			}
		}
	}
	
	set rbInvIdx=""
	while($o(HaveOECoverMainIns("BillINV",$j,rbInvIdx))) {
		set rbInvIdx=$o(HaveOECoverMainIns("BillINV",$j,rbInvIdx))
		set rbinstype=""
		while($o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype))) {
			set rbinstype=$o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype))
			set CoverMainIns=""
			while($o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype,CoverMainIns))'=""){
				set CoverMainIns=$o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype,CoverMainIns))
				//一张票据生成一个订单
				set PatPaySum=0
				set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradePay(CardNo, Adm, InsTypeId, "C", PatPaySum, myExpStr)
				set Rtn=$p(RtnValue,"^",1)
				if (+Rtn) {
					set Rtn=RtnValue
					quit
				}
				set ETPRowID=$p(RtnValue,"^",2)
				set HisTradeNo=$p(RtnValue,"^",3)
				set rbarcpb=""
				while($o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype,CoverMainIns,"BR",rbarcpb))'="") {
					set rbarcpb=$o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype,CoverMainIns,"BR",rbarcpb))
					set rbordrid=""
					while($o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype,CoverMainIns,"BR",rbarcpb,"ORD",rbordrid))) {
						set rbordrid=$o(HaveOECoverMainIns("BillINV",$j,rbInvIdx,"INT",rbinstype,CoverMainIns,"BR",rbarcpb,"ORD",rbordrid))
						set PBOData=$g(^DHCPB(+rbordrid,"O",$p(rbordrid,"||",2)))
						set PatientShare=$p(PBOData,"^",11)
						set rbOEOrder=$p(PBOData,"^",4)
						continue:$d(HaveOEORIArr(rbOEOrder))    //插过的医嘱不再插入，防止一个医嘱两个账单重复出现
						set HaveOEORIArr(rbOEOrder)=""
						set PatPaySum=PatPaySum+PatientShare
						set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertExtTradeOrdSub(ETPRowID, rbordrid)
						set Rtn=$p(RtnValue,"^",1)
						if (+Rtn) {
							set Rtn=RtnValue
							quit
						}
					}
					quit:(+Rtn)
				}
				quit:(+Rtn)
				&SQL(
					UPDATE DHC_BillExtTradePay
					SET ETP_TradeAmt = :PatPaySum
					WHERE %ID = :ETPRowID
				)
				set Rtn=SQLCODE
				if (+Rtn) {
					set Rtn=Rtn_"^"_$g(%msg)
					quit
				}
				set ETPRowIDStr=$s((ETPRowIDStr=""):ETPRowID,1:(ETPRowIDStr_"^"_ETPRowID))	
			}
			quit:(+Rtn)
		}
		quit:(+Rtn)
	}
	if (+Rtn) tro  quit Rtn
	
	if ($tl>0) tc
	
	quit Rtn_$c(2)_ETPRowIDStr
}

ClassMethod tb() [ ProcedureBlock = 0 ]
{
	new SQLCODE
	ts  set SQLCODE=$zu(34)
	quit
}

ClassMethod tc() [ ProcedureBlock = 0 ]
{
	new SQLCODE
	tc  set SQLCODE=$zu(34)
	quit
}

/// Creator: wangjian
/// CreatDate: 2014-07-07
/// Description: 根据订单号返回交易子表医嘱串
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInTradeSubOrd("20180316193432DHSZ0089")
ClassMethod GetInTradeSubOrd(HisTradeNo) As %String
{
	set OrdStr=""
	set ETPRowId=$o(^DHCBILLETPi(0,"HISTradeID",HisTradeNo,0))
	quit:(+ETPRowId=0) OrdStr
	set ETOSub=0
	for  set ETOSub=$o(^DHCBILLETP(ETPRowId,"O",ETOSub)) quit:(ETOSub="")  do
	.set ETOData=$g(^DHCBILLETP(ETPRowId,"O",ETOSub))
	.quit:(ETOData="")
	.set OrdStatus=$p(ETOData,"^",3)
	.quit:(OrdStatus="D")
	.set OEORI=$p(ETOData,"^",1)
	.set OrdStr=$s((OrdStr=""):OEORI,1:(OrdStr_"^"_OEORI))
	
	quit OrdStr
}

/// Creator: wangjian
/// CreatDate: 2018-03-16
/// Description: 校验订单是否是预结算状态
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).CheckPreCharge("20180316193432DHSZ0089","178.60")
ClassMethod CheckPreCharge(HisTradeNo As %String, PatPaySum As %String, UserId As %String, TerminalID As %String) As %String
{
	set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",HisTradeNo,""))
	quit:(ETPRowID="") "N"
	
	set myTerminalID=$g(^PreBillChargeLog(HisTradeNo))
	
	set LockedFlag=""   //预结算记录锁定3分钟不能删除
	set InsuChgFlag=0   //医保结算成功标识
	set InvStr=""
	set TradeAmt=0
	set ETCSub=0
	while($o(^DHCBILLETP(ETPRowID,"C",ETCSub))) {
		set ETCSub=$o(^DHCBILLETP(ETPRowID,"C",ETCSub))
		set ConInv=$p(^DHCBILLETP(ETPRowID,"C",ETCSub),"^",1)
		continue:'$d(^DHCINVPRT(ConInv))
		set ConInvFlag=$p(^DHCINVPRT(ConInv),"^",8)
		continue:(ConInvFlag'="TP")
		set ConInvAmt=$p(^DHCINVPRT(ConInv),"^",1)
		set ConInvUserDR=$p(^DHCINVPRT(ConInv),"^",21)
		set ConInvDate=$p(^DHCINVPRT(ConInv),"^",5)
		set ConInvTime=$p(^DHCINVPRT(ConInv),"^",20)
		set ConInvInsuDivDR=$p(^DHCINVPRT(ConInv),"^",30)
		set InsuChgFlag=##class(web.DHCBillCons11).CheckYBCharge(ConInv)
		if ($SYSTEM.SQL.DATEDIFF("ss", ConInvDate_","_ConInvTime, $h)<(..#LockedMin*60)) {
			set LockedFlag="L"
		}
		set TradeAmt=TradeAmt+ConInvAmt
		if (InvStr="") set InvStr=ConInv
		else  set InvStr=InvStr_"|"_ConInv
	}
	
	if ((InvStr="")||(+TradeAmt'=+PatPaySum)) {
		quit "N"
	}
	if ((UserId=ConInvUserDR)&&(TerminalID=myTerminalID)) {
		quit "Y"
	}
	//防止多终端结算，控制3分钟内的不能回滚
	if (LockedFlag="L") {
		quit "L"   //锁定
	}
	if (InsuChgFlag=0) {
		quit "I"   //医保已结算
	}
	set GroupId=$p($g(^SSU("SSUSR",UserId)),"^",5)
	set ExpStr=GroupId_"^"_UserId
	do ##class(web.DHCBillConsIF).DelINVPRTForYB(InvStr, ExpStr)

	quit "N"
}

/// Description: 根据订单获取关联票据
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPrtStrByOrder("20180504125008DHSZ0005","")
ClassMethod GetPrtStrByOrder(OrderNo As %String, ETPRowID As %String) As %String
{
	set PrtStr=""
	if ((ETPRowID="")&&(OrderNo'="")) {
		set ETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OrderNo,""))
	}
	quit:(+ETPRowID=0) PrtStr
	
	set ETCSub=0
	while($o(^DHCBILLETP(ETPRowID,"C",ETCSub))) {
		set ETCSub=$o(^DHCBILLETP(ETPRowID,"C",ETCSub))
		set ConInv=$p(^DHCBILLETP(ETPRowID,"C",ETCSub),"^",1)
		set PrtStr=$s((PrtStr=""):ConInv,1:(PrtStr_"^"_ConInv))
	}
	
	quit PrtStr
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).Test()
ClassMethod Test()
{
    set OutXML=""
    set OutputObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.Request).%New()
    set OutputObj.CardNo="0000000262"
    set OutputObj.CardType="1"
    set OutputObj.PatientID="0000000262"
    set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Res.PayDetails).%New()
    set PayDetailsObj.PayModeCode="CASH"
    set PayDetailsObj.PayAccountNo="0000000262"
    set PayDetailsObj.PayAmt="178.6"
    set PayDetailsObj.PlatformNo="2018031911123000001"
    set PayDetailsObj.OutPayNo="123456789"
    set PayDetailsObj.POSPayStr=""
    set PayDetailsObj.PayDate="2018-03-19"
    set PayDetailsObj.PayTime="11:12:22"
    set OutputObj.PayDetails=PayDetailsObj
    do OutputObj.XMLExportToString(.OutXML,"Response")
    
    quit OutXML
}

/// Description: 获取发票支付方式
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInvPaymodeInfo(223291,"")
ClassMethod GetInvPaymodeInfo(InvRowID As %String, SFlag As %String) As %String
{
	if (SFlag="") set SFlag="PRT"
	set PaymodeStr=""
	if (SFlag="PRT") do
	.set IPMSub=0
	.for  set IPMSub=$o(^DHCINVPRT(InvRowID,"P",IPMSub)) quit:(IPMSub="")  do
	..set PaymDR=$p(^DHCINVPRT(InvRowID,"P",IPMSub),"^",1)
	..set PayAmt=$p(^DHCINVPRT(InvRowID,"P",IPMSub),"^",3)
	..quit:(+PayAmt=0)
	..set PaymDesc=$p(^CT("CTPM",PaymDR),"^",2)
	..if (PaymodeStr="") set PaymodeStr=PaymDesc_":"_PayAmt
	..else  set PaymodeStr=PaymodeStr_","_PaymDesc_":"_PayAmt
	quit PaymodeStr
}

/// Creator: ZhYW
/// CreatDate: 2018-03-20
/// Description: 获取门诊结算失败描述
/// Input: err: 错误代码
/// Return: 
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetPreChargeErrMsg(111)
ClassMethod GetPreChargeErrMsg(err As %String) As %String
{
	quit:(+err=0) "门诊预结算成功"

	quit:(+err=101) "门诊结算没有数据"
	
	quit:(+err=102) "支付金额不符"
	
	quit:(+err=103) "重新生成账单错误"
	
	quit:(+err=104) "取配置信息有误"
	
	quit:(+err=105) "支付方式为空"
	
	quit:(+err=107) "院内账户不存在"
	
	quit:(+err=109) "收费员没有可用票据"
	
	quit:(+err=112) "四舍五入舍入金额过大，请分批结算"
	
	quit:(+err=113) "院内账户与患者身份不符"
	
	quit:(+err=114) "医嘱被执行，不能退费"
	
	quit:(+err=120) "有异常收费记录，请先处理"
	
	quit:(+err=123) "欠费结算异常"
	
	quit:(+err=125) "账户余额不足"
	
	quit:(+err=129) "减材料库存失败"
	
	quit:(+err=130) "挂号费与处方不能一起结算"
	
	quit:(+err=131) "患者结算需要附加条件"
	
	quit:(+err=132) "同一个处方被拆分"
	
	quit:(+err=133) "账单表金额不平，请核查"
	
	quit:(+err=134) "发票表与账单表金额不平，请核查"
	
	quit:(+err=135) "发票表自负金额与支付方式金额不平，请核查"
	
	quit:(+err=140) "传入的支付方式未配置"
	
	quit:(+err=141) "有收费医嘱数据不完整，请核查"
	
	quit:(+err=142) "药品医嘱结算后药房中间表数据有误"
	
	quit "门诊预结算失败"
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetOrdDetailsByPrtRowID()
ClassMethod GetOrdDetailsByPrtRowID(PrtRowId As %String) As %String
{
	set rtn=""
	
	set BillConInv=0 
	for  set BillConInv=$o(^DHCBCI(0,"INV",PrtRowId,BillConInv)) quit:(BillConInv="")  do
	.set PB=$p($g(^DHCBCI(BillConInv)),"^",2)
	.set PBO=0
	.for  set PBO=$o(^DHCPB(PB,"O",PBO)) quit:(PBO="")  do
	..set PBOData=$g(^DHCPB(PB,"O",PBO))
	..quit:(PBOData="")
	..set Arcim=$p(PBOData,"^",3)
	..set ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)
	..set OEORI=$p(PBOData,"^",4)
	..set OrderUnitPrice=$p(PBOData,"^",7)
	..set PBORefQty=$p(PBOData,"^",6)
	..set PBOBillQty=$p(PBOData,"^",5)
	..set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
	..set BillQty=(PBOBillQty+PBORefQty)/ConFac
	..set PatSum=$p(PBOData,"^",11)
	..set PatSum=$fn(PatSum,"",2)
	..set RecDeptDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)  //接收科室
	..set RecDept=$s((RecDeptDR'=""):$p($g(^CTLOC(RecDeptDR)),"^",2),1:"")
	..set tmp=ArcimDesc_"^"_PatSum_"^"_BillQty_"^"_RecDept
	..set rtn=$s((rtn=""):tmp,1:(rtn_"!"_tmp))
	
	quit rtn
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).ParPrtToINV("1197752^1197753^","371^29^2465^2")
ClassMethod ParPrtToINV(INVPrtStr As %String, ExpStr As %String, ByRef PrtColStr As %String, ByRef TMPGID As %String) As %String
{
	;收费过程中用此函数
	;生成一个唯一的ID值 TMPGID
	do ##class(web.UDHCACINVColPrt).KTMP()
	set TMPGID=$i(^DHCTMPACCColPRT)
	;
	;获取基本配置
	set Group=$p(ExpStr,"^",2)
	set HospDR=$p(ExpStr,"^",4)
	
	set myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(Group, HospDR)
	set rtn=$p(myBCInfo,"^")
	quit:rtn 104_$c(2)
	
	set itemFlag=$p(myBCInfo,"^",5)		;1			;;这个一定设置为1   不能改变?
	set reclocFlag=$p(myBCInfo,"^",6)		;1
	set PresNoFlag=$p(myBCInfo,"^",7)		;1
	set RecInvCount=$p(myBCInfo,"^",8)			;0
	set printCount=$p(myBCInfo,"^",9)				;21
	set OnToManyFlag=$p(myBCInfo,"^",32)
	set RegInvFlag=$p(myBCInfo,"^",33)
	set InvDateFlag=$p(myBCInfo,"^",34)
	set myrtn=##class(web.UDHCACINVColPrt).GetAccPayINVData(INVPrtStr, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
	set rtn=$p(myrtn,"^")
	quit:(+rtn) rtn
	;
	set myrtn=##class(web.UDHCACINVColPrt).ParDataToABill(RecInvCount, printCount, TMPGID)
	set rtn=$p(myrtn,"^")
	quit:(+rtn) rtn
	
	;一张发票一张发票的传出
	set myInsType=0
	set myInsINVInfo=""
	set myvIdx=0
	for  set myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) quit:(myInsType="")  do
	.set YBFlag=##class(web.DHCOPConfig).ReadYBFlagByINS(myInsType)
	.set myInsDesc=$p(^PAC("ADMREA",myInsType),"^",2)
	.set myINVNum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))
	.set myINVPrtInfo=""
	.set myINVPrtDesc=""
	.set myINVIdx=0
	.for  set myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) quit:(myINVIdx="")  do
	..set myvIdx=myvIdx+1
	..set mySPrtRowID=0
	..set myCardPayDR=$o(^CT("CTPM",0,"Code","CPP",0))
	..set myCurSum= +$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..set myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..;start Lid 2012-02-09  根据支付小条重新指定支付方式（此处有点问题）
	..set myPrtStr="", singleCardPayDr=""
	..for  set mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) quit:(mySPrtRowID="")  do
	...set myPrtStr=myPrtStr_"^"_mySPrtRowID
	...if ((singleCardPayDr="")&&(mySPrtRowID'=""))  do
	....set IPMSub=$o(^DHCINVPRT(mySPrtRowID,"P","0"))   ;Lid 2011-03-26 根据支付小条重新指定支付方式（此处有点问题）
	....set singleCardPayDr=$p(^DHCINVPRT(mySPrtRowID,"P",IPMSub),"^",1)
	....set myCardPayDR=singleCardPayDr
	..;end
	..set myINVPrtInfo=myInsType_" "_myInsDesc_" 第"_myvIdx_"张发票金额:"_(myCurSum+myRoundSum)
	..set myINVPrtDesc=myINVPrtInfo
	..set myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^^^"_myRoundSum
	..set myINVPrtValue=myINVPrtValue_$c(3)_myPrtStr
	..set myINVPrtValue=myINVPrtValue_$c(3)_myCardPayDR_"^"_(myCurSum+myRoundSum)	;为DHC_AccPayINVMode提供支付信息加医保留出空间
	..set myINVPrtValue=myINVPrtValue_$c(3)_"^^^^^^^"		;为DHC_AccPay医保字段，和返钱字段
	..set myINVPrtValue=myINVPrtValue_$c(3)_"^^^^^"		;分解的明细值
	..set myINVPrtValue=myINVPrtValue_$c(3)_TMPGID			;返回进程ID
	..if (YBFlag="1")||(YBFlag="2")  do
	...set myINVPrtValue=myINVPrtValue_$c(3)_myInsType			;返回收费类别的类型
	..else  do
	...set myINVPrtValue=myINVPrtValue_$c(3)_""
	..set PrtColStr=$s((PrtColStr=""):myINVPrtValue,1:(PrtColStr_$c(2)_myINVPrtValue))
	;
	;屏蔽删除Global
	do ##class(web.UDHCACINVColPrt).KTMP()
	;
	if (myvIdx=0) do
	.set rtn=108
	;
	quit rtn
}

/// Debug:w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).GetInvoicePrintData("19937^19936","")
ClassMethod GetInvoicePrintData(APIRowIDStr As %String, PrtDataExpStr As %String) As DHCBILL.SelfPay.Entity.PrintInvoice.Res.Response
{
	set OutputObj=##class(DHCBILL.SelfPay.Entity.PrintInvoice.Res.Response).%New()
	
	for i=1:1:$l(APIRowIDStr,"^") {
		kill ^TMP("InvData",$j)
		set APIRowID=$p(APIRowIDStr,"^",i)
		continue:(+APIRowID=0)
		set PatDr=$p(^DHCINVPRTAP(APIRowID),"^",11)
		set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
		set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
		set SCH=$p(^PAPER(PatDr,"ALL"),"^",19)
		set Date=$p(^DHCINVPRTAP(APIRowID),"^",3)
		set Time=$p(^DHCINVPRTAP(APIRowID),"^",4)
		set PUserDR=$p(^DHCINVPRTAP(APIRowID),"^",5)
		set UserCode=$p($g(^SSU("SSUSR",PUserDR)),"^",1)
		set UserName=$p($g(^SSU("SSUSR",PUserDR)),"^",2)
		set myInvNo=$p(^DHCINVPRTAP(APIRowID),"^",6)
		set myTotalAmt=+$p(^DHCINVPRTAP(APIRowID),"^",1)
		set myPayDiscSum=+$p(^DHCINVPRTAP(APIRowID),"^",14)
		set myPatPaySum=+$p(^DHCINVPRTAP(APIRowID),"^",13)
		set myHospDR=$p(^DHCINVPRTAP(APIRowID),"^",30)
		
		set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,0))
		set myINVRowID=$p(^DHCINVPRTCAP(myACPRowID),"^",1)
		set myFairType=$p(^DHCINVPRT(myINVRowID),"^",34)
		set myBCIRowID=$o(^DHCBCI(0,"INV",myINVRowID,0))
		set myAdmRowID=$p(^DHCBCI(myBCIRowID),"^",3)
		set myADMDate=$p(^PAADM(myAdmRowID),"^",6)
		set myADMDate=$zd(myADMDate,3)

		set (PrtAcount,PrtDiscAmount,PrtPayorShare,PrtPatPay,AllPrtAcount,AllPrtDiscAmount,AllPrtPayorShare,AllPrtPatPay)=0
		
		set ApPrtRowid=""
		for  set ApPrtRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,ApPrtRowid)) quit:(ApPrtRowid="")  do
		.set PrtRowid=$p(^DHCINVPRTCAP(ApPrtRowid),"^",1)
		.;Start ？？如果1:n时，这段程序取最后一个小条的信息,是否有些问题？？？？，根据具体情况优化吧！！
		.set InsTypeDR=$p(^DHCINVPRT(PrtRowid),"^",9)
		.set InsType=$s((InsTypeDR'=""):$p($g(^PAC("ADMREA",InsTypeDR)),"^",2),1:"")
		.set AdmLoc=..GetAdmLocByInvID(PrtRowid)
		.set YBSCNo=myInvNo
		.if (SCH'="") set SCH="手册号: "_SCH
		.set YBSC=""
		.;End
		.set PrtAcount=$p(^DHCINVPRT(PrtRowid),"^",1)
		.set PrtDiscAmount=$p(^DHCINVPRT(PrtRowid),"^",7)
		.set PrtPatPay=$p(^DHCINVPRT(PrtRowid),"^",16)
		.set PrtPayorShare=$p(^DHCINVPRT(PrtRowid),"^",18)
		.set AllPrtPatPay=AllPrtPatPay+PrtPatPay
		.set AllPrtAcount=AllPrtAcount+PrtAcount
		.set AllPrtDiscAmount=AllPrtDiscAmount+PrtDiscAmount
		.set AllPrtPayorShare=AllPrtPayorShare+PrtPayorShare
		.set INVLinkDr=0
		.for  set INVLinkDr=$o(^DHCBCI(0,"INV",PrtRowid,INVLinkDr)) quit:(INVLinkDr="")  do
		..set Bill=$p(^DHCBCI(INVLinkDr),"^",2)
		..quit:(+Bill=0)
		..set Ord=0
		..for  set Ord=$o(^DHCPB(Bill,"O",Ord)) quit:(Ord="")  do
		...set PBOData=$g(^DHCPB(Bill,"O",Ord))
		...quit:(PBOData="")
		...set Prescno=""
		...set OEIMDR=$p(PBOData,"^",4)
		...set Arcim=$p(PBOData,"^",3)
		...set ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
		...set OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
		...set myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
		...set recDeptDR=$p($g(^OEORD(+OEIMDR,"I",+$p(OEIMDR,"||",2),3)),"^",6) ;接收科室
		...set loctype=$p(^CTLOC(recDeptDR),"^",13) 
		...if (loctype="") set loctype="Z"	;放在最后?
		...set ^TMP("InvData",$j,"PBID",loctype,recDeptDR,Bill_"||"_Ord)=""
		...set ^TMP("InvData",$j,"PBO",Bill_"||"_Ord)=Bill_"^"_Ord_"^"_myPresNo_"^"_OrderType
		
		set myLocType=""
		for  set myLocType=$o(^TMP("InvData",$j,"PBID",myLocType)) quit:(myLocType="")  do
		.set myRecDR=""
		.for  set myRecDR=$o(^TMP("InvData",$j,"PBID",myLocType,myRecDR)) quit:(myRecDR="")  do
		..set myPBORID=""
		..for  set myPBORID=$o(^TMP("InvData",$j,"PBID",myLocType,myRecDR,myPBORID)) quit:(myPBORID="")  do
		...set Bill=+myPBORID
		...set Ord=$p(myPBORID,"||",2)
		...set PBOData=$g(^DHCPB(Bill,"O",Ord))
		...set OEIMDR=$p(PBOData,"^",4)
		...set myAcrim=$p(PBOData,"^",3)
		...set myPresNo=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),1),"^",14)
		...set itmcatdr=$p(^ARCIM(+myAcrim,+$p(myAcrim,"||",2),1),"^",10)
		...set ArcicID=$p(^ARC("IC",itmcatdr),"^",8)   ;医嘱大类rowid
		...set ArcicDesc=$p(^OEC("ORCAT",ArcicID),"^",2)
		...set ordtype=$p(^ARC("IC",itmcatdr),"^",7)
		...set myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(myAcrim)
		...if (myOFFlag="F") do
		....do ..AddJFToDetails(Bill, Ord, myHospDR)
		...else  do
		....do ..AddToDetails(Bill, Ord, myHospDR)
		...set Itm=0 
		...for  set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) quit:(Itm="")  do
		....set PBDData=$g(^DHCPB(Bill,"O",Ord,"D",Itm))
		....quit:(PBDData="")
		....set ItmDr=$p(PBDData,"^",3)
		....set TotalAmount=$p(PBDData,"^",7)
		....set DiscAmount=$p(PBDData,"^",8)
		....set PayorShare=$p(PBDData,"^",9)
		....set PatientShare=$p(PBDData,"^",10)
		....do ..AddToPLIST(ItmDr, TotalAmount, DiscAmount, PatientShare, PayorShare)
		
		set ItemDetails=..GetItemDetails()
		set CateDetails=..GetCateDetails()
		
		set InvocieObj=##class(DHCBILL.SelfPay.Entity.PrintInvoice.Res.Invoice).%New()
		set InvocieObj.Index=i
		set InvocieObj.PrtDate=$zd(Date,3)
		set InvocieObj.PrtTime=$zt(Time,1)
		set FairType=$case(myFairType,"R":"挂号","F":"收费",:"")
		set InvocieObj.FairType=$g(FairType)
		set InvocieObj.AdmReason=$g(InsType)
		set InvocieObj.PatientID=PatNo
		set InvocieObj.PatName=PatName
		set InvocieObj.AdmDept=$g(AdmLoc)
		set InvocieObj.Amt=myTotalAmt
		set TotalAmtDX=##class(web.UDHCOPINVPrtIF).RMBConvert(myTotalAmt)
		set InvocieObj.AmtDX=TotalAmtDX
		set InvocieObj.User=UserCode
		set InvocieObj.UserCode=UserName
		set InvocieObj.InvNo=myInvNo
		set InvocieObj.CateDetail=CateDetails
		set InvocieObj.ItemDetail=ItemDetails
		
		;如果是挂号发票，则调用医生站接口取数据
		if (myFairType="R") {
			set RegfeeRowId=$o(^User.DHCRegistrationFeeI("ADM",myAdmRowID,0))
			continue:(RegfeeRowId="")
			set AppFlag=""
			set RegPrintData=##class(web.DHCOPAdmReg).GetPrintData(RegfeeRowId, AppFlag)
			set AdmDr=$p(RegPrintData,"^",1)	;就诊id
			set PatName=$p(RegPrintData,"^",2)	;病人姓名
			set DepDesc=$p(RegPrintData,"^",3)	;所挂号科室的名称
			set DocDesc=$p(RegPrintData,"^",4)	;所挂号医生的名称
			set SessionType=$p(RegPrintData,"^",5)	;号别（比如普通号，专家号等等）
			set AdmDateStr=$p(RegPrintData,"^",6)	;挂号日期（**年**月**日）
			set TimeRange=$p(RegPrintData,"^",7)	;时段（上午，下午等）
			set SeqNo=$p(RegPrintData,"^",8)		;所挂号的号数（比如挂的是1号，2号等）
			set RoomNo=$p(RegPrintData,"^",9)		;诊室号
			set RoomFloor=$p(RegPrintData,"^",10)	;诊室描述
			set RegFee=$p(RegPrintData,"^",18)	;挂号费
			set AppFee =$p(RegPrintData,"^",19)	;预约费
			set OtherFee=$p(RegPrintData,"^",20)	;其他费
			set ClinicGroupCode =$p(RegPrintData,"^",21)	;亚专业代码
			sET InvoiceId =$p(RegPrintData,"^",22)	;发票号
			set BoroughDesc=$p(RegPrintData,"^",23)	;诊区（例如：肝病二诊区）
			set FeeItemList=$p(RegPrintData,"^",24)	;收费项目（例如：挂号费||2！诊疗费||3  格式就是医嘱项名称||价格！医嘱项名称||价格...）
			set PrnRegFee =$p(RegPrintData,"^",25)	;挂号费??
			set PrnCheckFee=$p(RegPrintData,"^",26)	;诊查费
			set PrnReCheckFee=$p(RegPrintData,"^",27)	;复查费
			set PrnMRFee=$p(RegPrintData,"^",28)			;病历本费
			set PrnCardFee=$p(RegPrintData,"^",29)	;卡费
			set AdmDate=$p(RegPrintData,"^",30)	;就诊日期（YYYY-MM-DD)
			;
			set InvocieObj.DoctorName=DocDesc
			set InvocieObj.SessionType=SessionType
			set InvocieObj.TimeRange=TimeRange
			set InvocieObj.SeqNo=SeqNo
			set InvocieObj.RoomNo=RoomNo
			set InvocieObj.RoomFloor=RoomFloor
			set InvocieObj.RegFee=RegFee
			set InvocieObj.AppFee =AppFee
			set InvocieObj.OtherFee=OtherFee
			set InvocieObj.ClinicGroupCode=ClinicGroupCode
			set InvocieObj.BoroughDesc=BoroughDesc
			set InvocieObj.PrnRegFee=PrnRegFee
			set InvocieObj.PrnCheckFee=PrnCheckFee
			set InvocieObj.PrnReCheckFee=PrnReCheckFee
			set InvocieObj.PrnMRFee=PrnMRFee
			set InvocieObj.PrnCardFee=PrnCardFee
			set InvocieObj.AdmDate=AdmDate
			set InvocieObj.RegDate=$zd(Date,3)
		}
		do OutputObj.Invoice.Insert(InvocieObj)
		do InvocieObj.%Close()
	}
	
	quit OutputObj
}

ClassMethod GetItemDetails()
{
	set myList=""
	set myidx=""
	for  set myidx=$o(^TMP("InvData",$j,"D",myidx)) quit:(myidx="")  do
	.if (myList="") do
	..set myList=^TMP("InvData",$j,"D",myidx)
	.else  do
	..set myList=myList_"!"_^TMP("InvData",$j,"D",myidx)
	
	quit myList
}

ClassMethod GetCateDetails()
{
	set CateStr=""
	set OPCSInfo=""
	for  set OPCSInfo=$o(^TMP("InvData",$j,"CAT",OPCSInfo)) quit:(OPCSInfo="")  do
	.set CateDesc=$p($g(^TMP("InvData",$j,"CAT",OPCSInfo)),"^",1)
	.set CateAmt=$fn($p($g(^TMP("InvData",$j,"CAT",OPCSInfo)),"^",2),"",2)
	.if (CateStr="") do
	..set CateStr=CateDesc_"^"_CateAmt
	.else  do  
	..set CateStr=CateStr_"!"_CateDesc_"^"_CateAmt
	
	quit CateStr
}

ClassMethod AddJFToDetails(pb As %String, pbo As %String, hospId As %String)
{
	set pboData=$g(^DHCPB(pb,"O",pbo))
	quit:(pboData="")
	
	//获取中草药配制
	set HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig(hospId)
	set rtn=$p(HerbConfig,$c(2))
	;quit:(rtn) 104   ;配置错误
	set FCHerbFlag=$p(HerbConfig,$c(2),2)		//OPFC_HerbalFlag
	set FCHerbDesc=$p(HerbConfig,$c(2),3)
	set FCHerbNum=$p(HerbConfig,$c(2),4)
	set FCHerbRange=$p(HerbConfig,$c(2),5)
	set HerbIdx=0						;草药费明细索引
	
	set Arcim=$p(pboData,"^",3)
	set OEOrdItem=$p(pboData,"^",4)
	set ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)    //ARC_ItmMast->ARCIM_ItemCat_DR
	set OrderType=$p(^ARC("IC",ItemCatDR),"^",7)                            //ARC_ItemCat->ARCIC_OrderType
	set myINCRegu=##class(web.UDHCOPINVPrtData12).GetDrugSpec(Arcim)   //规格
	set ArcimDesc=$p($g(^ARCIM(+Arcim,1,1)),"^",2)
	set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(Arcim)
	set:(DrugCommonDesc'="") ArcimDesc=DrugCommonDesc_myINCRegu
	set Price=$p(^DHCPB(pb,"O",pbo),"^",7)
	set PackUOM=##class(web.DHCBillCommon).GetPackUom(Arcim, OEOrdItem)
	set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEOrdItem)
	set PackQty=$p(pboData,"^",5)
	set RefundQty=$p(pboData,"^",6)			//OE_OrdItem->OEORI_RefundQty
	set PackQty=PackQty+RefundQty
	set PackQty=PackQty/ConFac
	set Price=$fn(Price*ConFac,"",4)

	set OrdPatSum=$fn($p(pboData,"^",11),"",2)
	set OrdTotSum=$fn($p(pboData,"^",8),"",2)
	
	set ^TMP("InvData",$j,"D")=$g(^TMP("InvData",$j,"D"))+1
	set Idx=$g(^TMP("InvData",$j,"D"))
	set ^TMP("InvData",$j,"D",Idx)=$e($g(ArcimDesc),1,15)_"^"_""_"^"_""_"^"_""_"^"_OrdTotSum

	set pbd=0
	for  set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd)) quit:(pbd="")  do
	.set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	.quit:(pbdData="")
	.set myTarRowID=$p(pbdData,"^",3)	    ;PBD_TARI_DR
	.quit:(myTarRowID="")
	.set myTarDesc=$p($g(^DHCTARI(myTarRowID)),"^",2)
	.set myUnitPrice=$p(pbdData,"^",4)		;PBD_UnitPrice
	.set myUnitPrice=$fn(myUnitPrice,"",4)
	.set PackUOMRowid=$p($g(^DHCTARI(myTarRowID)),"^",3)
	.set PackUOM=$s((PackUOMRowid'=""):$p($g(^CT("UOM",PackUOMRowid)),"^",2),1:"")
	.set PackQty=$p(pbdData,"^",5)			    ;PBD_BillQty
	.set OrdTotSum=$p(pbdData,"^",10)			;PBD_PatientShare
	.set OrdTotSum=$p(pbdData,"^",7)		    ;PBD_TotalAmount
	.set OrdTotSum=$fn(OrdTotSum,"",2)
	.set ^TMP("InvData",$j,"D")=$g(^TMP("InvData",$j,"D"))+1
	.set Idx=$g(^TMP("InvData",$j,"D"))
	.set myYBCode=""
	.set ^TMP("InvData",$j,"D",Idx)="  "_myYBCode_$e($g(myTarDesc),1,15)_"^"_$j(myUnitPrice,3,2)_"^"_$p(PackUOM,"[")_"^"_PackQty_"^"_OrdTotSum
	
	quit
}

ClassMethod AddToDetails(pb As %String, pbo As %String, hospId As %String) As %String
{
	set pboData=$g(^DHCPB(pb,"O",pbo))
	quit:(pboData="")
	
	//获取中草药配制
	set HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig(hospId)
	set rtn=$p(HerbConfig,$c(2))
	//quit:rtn 104   ;配置错误
	set FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	set FCHerbDesc=$p(HerbConfig,$c(2),3)
	set FCHerbNum=$p(HerbConfig,$c(2),4)
	set FCHerbRange=$p(HerbConfig,$c(2),5)
	set HerbIdx=0						//草药费明细索引
	
	set Arcim=$p(pboData,"^",3)
	set OEOrdItem=$p(pboData,"^",4)
	set recDeptDR=$p($g(^OEORD(+OEOrdItem,"I",+$p(OEOrdItem,"||",2),3)),"^",6)  //接收科室
	set RecLoc=$p(^CTLOC(recDeptDR),"^",2)
	set RecLoc=$p(RecLoc,"-",2)
    set RecLocAddress=$g(^CTLOC(recDeptDR,"ADDR",1))
    set RecLoc=RecLoc_" "_RecLocAddress
	set ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) //ARC_ItmMast->ARCIM_ItemCat_DR
	set OrderType=$p(^ARC("IC",ItemCatDR),"^",7)                         //ARC_ItemCat->ARCIC_OrderType
	set myINCRegu=##class(web.UDHCOPINVPrtData12).GetDrugSpec(Arcim)  //规格
	set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(Arcim)
	set ArcimDesc=$p($g(^ARCIM(+Arcim,1,1)),"^",2) ;名称
	set:(DrugCommonDesc'="") ArcimDesc=DrugCommonDesc
	set DrgDesc=""
	set myTarRowID="", tmpTarRowID="", myOwnFlag="Y"
	set pbd=0
	for  set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd)) quit:(pbd="")  do
	.set myTarRowID=$p(^DHCPB(pb,"O",pbo,"D",pbd),"^",3)
	.if (tmpTarRowID="") set tmpTarRowID=myTarRowID
	.if (myTarRowID'=tmpTarRowID) set myOwnFlag="N"
	
	if ((myTarRowID'="")&&(myOwnFlag="Y")) do
	.set myYBCode=""
	.if (myYBCode'="") set DrgDesc=myYBCode
	
	set Price=$p(pboData,"^",7)
	set PackUOM=##class(web.DHCBillCommon).GetPackUom(Arcim, OEOrdItem)
	set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEOrdItem)
	set PackQty=$p(pboData,"^",5)
	set RefundQty=$p(pboData,"^",6)			//OE_OrdItem->OEORI_RefundQty
	set PackQty=PackQty+RefundQty
	set Price=$fn(Price*ConFac,"",4)
	set PackQty=PackQty/ConFac
	set OrdPatSum=$fn($p(pboData,"^",11),"",2)
	set OrdTotSum=$fn($p(pboData,"^",8),"",2)
	
	if ((+FCHerbFlag=1)&&(FCHerbRange[("^"_ItemCatDR_"^"))) do
	.;属于草药?
	.if (HerbIdx=0) do
	..set ^TMP("InvData",$j,"D")=$g(^TMP("InvData",$j,"D"))+1
	..set HerbIdx=$g(^TMP("InvData",$j,"D"))
	.set $p(^TMP("InvData",$j,"D",HerbIdx),"^",1)=FCHerbDesc
	.set $p(^TMP("InvData",$j,"D",HerbIdx),"^",2)=""
	.set $p(^TMP("InvData",$j,"D",HerbIdx),"^",3)=""
	.set $p(^TMP("InvData",$j,"D",HerbIdx),"^",4)=""
	.set $p(^TMP("InvData",$j,"D",HerbIdx),"^",5)=+$p($g(^TMP("InvData",$j,"D",HerbIdx)),"^",5)+OrdTotSum
	quit:((+FCHerbFlag=1)&&(FCHerbRange[("^"_ItemCatDR_"^")))
	
	set ^TMP("InvData",$j,"D")=$g(^TMP("InvData",$j,"D"))+1
	set Idx=$g(^TMP("InvData",$j,"D"))
	set ^TMP("InvData",$j,"D",Idx)=$e(DrgDesc_$g(ArcimDesc),1,16)_"^"_$j(Price,3,2)_"^"_PackUOM_"^"_PackQty_"^"_OrdTotSum

	quit
}

ClassMethod AddToPLIST(ItmDr, TotalAmount, DiscAmount, PatientShare, PayorShare) As %String
{
	quit:(ItmDr="") 0
	set ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	quit:(ItmOPSubCat="") 0
	set ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	quit:(ItmOPCat="") 0
	set OPCatCode=$p(^DHCTarC("TOC",ItmOPCat),"^",1)
	set OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
   
	set $p(^TMP("InvData",$j,"CAT",OPCatCode),"^",1)=OPCatDesc
	set $p(^TMP("InvData",$j,"CAT",OPCatCode),"^",2)=$p($g(^TMP("InvData",$j,"CAT",OPCatCode)),"^",2)+TotalAmount
	set $p(^TMP("InvData",$j,"CAT",OPCatCode),"^",3)=$p($g(^TMP("InvData",$j,"CAT",OPCatCode)),"^",3)+DiscAmount
	set $p(^TMP("InvData",$j,"CAT",OPCatCode),"^",4)=$p($g(^TMP("InvData",$j,"CAT",OPCatCode)),"^",4)+PatientShare
	set $p(^TMP("InvData",$j,"CAT",OPCatCode),"^",5)=$p($g(^TMP("InvData",$j,"CAT",OPCatCode)),"^",5)+PayorShare
	
	quit 0
}

ClassMethod GetAdmLocByInvID(prtRowId) As %String
{
    set locStr=""
    quit:(prtRowId="") locStr
    set bci=0
    for  set bci=$o(^DHCBCI(0,"INV",prtRowId,bci))  quit:(bci="")  do
    .set adm=$p($g(^DHCBCI(bci)),"^",3)
    .quit:(+adm=0)
    .set deptDR=$p($g(^PAADM(adm)),"^",4)
    .quit:(+deptDR=0)
    .set dept=$p($g(^CTLOC(deptDR)),"^",2)
    .set locStr=$s((locStr=""):dept,1:(locStr_"  "_dept))
	quit locStr
}

/// Creator: wangjian
/// CreatDate: 2019-02-18
/// Description: 自助平台统一退费接口(扩展除门诊收费以外通用退费接口)
/// Input: PatType:业务类型(OP IP IPDEP CARD…)
/// 	   OrgPrtRowID:收的业务表ID(用于找原交易信息)
/// 	   AbortPrtRowID:负的业务表ID(用于计算金额与管理退费交易)
/// 	   NewPrtRowID: 新收业务表ID(用于计算金额与管理退费交易)
/// 	   RefAmt: 退款金额
/// 	   ExpStr: 操作员ID^安全组^科室^院区^卡号^退费原因
/// Return: 
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).RefundAll("OP",32977870,32977871,"","","10393^198^540^1^TQ")
ClassMethod RefundAll(PatType As %String, OrgPrtRowID As %String, AbortPrtRowID As %String, NewPrtRowID As %String, RefAmt As %String, ExpStr As %String) As %String
{
	set UserId=$p(ExpStr,"^",1)
	set GroupId=$p(ExpStr,"^",2)
	set CTLocId=$p(ExpStr,"^",3)
	set HospId=$p(ExpStr,"^",4)
	set CardNo=$p(ExpStr,"^",5)
	set Remark=$p(ExpStr,"^",6)
	
	set Rtn=0
	
	//1.判断收费业务表ID
	if (PatType="CARD") {
		set OrgPrtRowID=$p(^DHCBILLETP(OrgPrtRowID),"^",48)
	}
	if ((OrgPrtRowID="")&&(AbortPrtRowID'="")) {
		set OrgPrtRowID=..GetOrgPrtInfo(PatType, AbortPrtRowID)
	}
	quit:(OrgPrtRowID="") -1_"^"_"原业务ID不能为空"

	//2.找原交易信息
	set OrgETPRowID=$o(^DHCBILLETPi(0,"TTypePRT",PatType,"PRT",OrgPrtRowID,""))
	quit:(OrgETPRowID="") -1_"^"_"无交易信息"
	
	set OrgETPData=$g(^DHCBILLETP(OrgETPRowID))
	set PaymDR=$p(OrgETPData,"^",45)
	set PaymodeCode=$p(^CT("CTPM",PaymDR),"^",1)
	set TradeChannel=$p(OrgETPData,"^",31)
	set ETPHISTradeID=$p(OrgETPData,"^",32)
	set ETPExtTradeNo=$p(OrgETPData,"^",47)
	set ETPExtPapmi=$p(OrgETPData,"^",40)
	set ETPPayChannel=$p(OrgETPData,"^",46)
	set ETPTerminal=$p(OrgETPData,"^",9)
	
	//3.退费金额
	if (+RefAmt=0) {
		set RefAmt=..GetRefAmtByPrtRowID(PatType, AbortPrtRowID, NewPrtRowID, PaymDR)
		quit:(+RefAmt=0) Rtn_"^无需退款"
	}
	
	//4.生成负订单
	set myBizPrtStr=AbortPrtRowID_"!"_NewPrtRowID   //业务id
	set myExpStr=CTLocId_"^"_GroupId_"^"_HospId_"^"_UserId_"^"_myBizPrtStr
	set RefOrdeInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).InsertRefundExtTradePay(PatType, OrgETPRowID, "D", RefAmt, ExpStr)
	set Rtn=$p(RefOrdeInfo,"^",1)
	quit:(+Rtn) Rtn_"^"_"HIS生成负订单错误"
	set ETPRowID=$p(RefOrdeInfo,"^",2)
	set HISTradeNo=$p(RefOrdeInfo,"^",3)
	set OldExtTradeNo=$p(RefOrdeInfo,"^",4)
	set OldHISTradeNo=$p(RefOrdeInfo,"^",5)
	set RcDetail=""
	if (TradeChannel="DHCC"){
		//"<orderpayreturn><error>success</error><issuccess>T</issuccess><tradeno>4200000305201907057901629818</tradeno><money>.01</money><memo></memo><batchno>2019070518104010010023</batchno><patientid>5591</patientid></orderpayreturn>"
		set ReReturn=##class(iH.Pay.PublicPay).ReturnPay(ETPExtTradeNo, HISTradeNo, ETPExtPapmi, RefAmt, Remark)
		if (ReReturn="") {
			quit -1002_"^"_"退费接口异常"
		}
	    set RefOutputObj=##class(DHCBILL.SelfPay.Entity.RefundAll.DHCCReturnRes).%New()    
  		do RefOutputObj.XMLNodeDeserialize(.RefOutputObj, "orderpayreturn", ReReturn)
		//根据调用结果保存或返回
		if (RefOutputObj.issuccess'="T") {
			quit -1001_"^"_"退费失败"
		}
		set RcDetail=RefOutputObj.error
		set PayDetailsObj=##class(DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails).%New()
		set PayDetailsObj.PayModeCode=PaymodeCode
		set PayDetailsObj.PayAccountNo=""
		set PayDetailsObj.PayAmt=RefOutputObj.money
		set PayDetailsObj.PlatformNo=RefOutputObj.batchno
		set PayDetailsObj.OutPayNo=RefOutputObj.tradeno
		set PayDetailsObj.PayChannel=ETPPayChannel
		set PayDetailsObj.PayDate=+$h
		set PayDetailsObj.PayTime=$p($h,",",2)
		set PayDetailsObj.TradeChannel=TradeChannel
		set SaveExpStr=$p(ExpStr,"^",1,4)_"^"_ETPTerminal_"^"_PatType
		set RtnValue=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(HISTradeNo, myBizPrtStr, .PayDetailsObj, SaveExpStr)
		set Rtn=$p(RtnValue,"^",1)
	}
	
	quit Rtn_"^"_RcDetail
}

ClassMethod GetOrgPrtInfo(PatType, AbortPrtRowID)
{
	set OrgPrtRowID=""
	if (PatType="CARD") {
		set OrgPrtRowID=$p(^DHCCARDINVPRT(AbortPrtRowID),"^",8)
		quit OrgPrtRowID
	}
	
	if (PatType="OP") {
		set OrgPrtRowID=$p(^DHCINVPRT(AbortPrtRowID),"^",13)
		set myOldInvDR=$p(^DHCINVPRT(OrgPrtRowID),"^",29)
		while (+myOldInvDR'=0) {
			set OrgPrtRowID=myOldInvDR
			set myOldInvDR=$p(^DHCINVPRT(OrgPrtRowID),"^",29)	//PRT_OldINV_DR	
		}
		quit OrgPrtRowID
	}
	
	if (PatType="PRE") { 
		
	}
	
	quit OrgPrtRowID
}

ClassMethod GetRefAmtByPrtRowID(PatType, AbortPrtRowID, NewPrtRowID, RefPaymId)
{
	set RowIDStr=AbortPrtRowID_"|"_NewPrtRowID
	set Num=$l(RowIDStr,"|")
	set RefAmt=0 

	if (PatType="CARD"){
		for i=1:1:Num {
			set RowId=$p(RowIDStr,"|",i)
			continue:(+RowId=0)
			set PayMSub=0
			while($o(^DHCCARDINVPRT(RowId,"P",PayMSub))) {
				set PayMSub=$o(^DHCCARDINVPRT(RowId,"P",PayMSub))
				set PayMData=$g(^DHCCARDINVPRT(RowId,"P",PayMSub))
				continue:(PayMData="")
				set PaymDR=$p(PayMData,"^",1)
				continue:(PaymDR'=RefPaymId)
				set PaymSum=$p(PayMData,"^",3)
				set RefAmt=$i(RefAmt,PaymSum)
			}
		}
	}elseif(PatType="OP"){
		for i=1:1:Num {
			set RowId=$p(RowIDStr,"|",i)
			continue:(+RowId=0)
			set PayMSub=0
			while($o(^DHCINVPRT(RowId,"P",PayMSub))) {
				set PayMSub=$o(^DHCINVPRT(RowId,"P",PayMSub))
				set PayMData=$g(^DHCINVPRT(RowId,"P",PayMSub))
				continue:(PayMData="")
				set PaymDR=$p(PayMData,"^",1)
				continue:(PaymDR'=RefPaymId)
				set PaymSum=$p(PayMData,"^",3)
				set RefAmt=$i(RefAmt,PaymSum)
			}
		}
	}
	
	set RefAmt=$s((RefAmt<0):$fn($zabs(RefAmt),"",2),1:0)
	
	quit RefAmt
}

/// CreatDate: 2021-07-01
/// Description: 校验就诊是否有预结算状态的订单
/// Input: adm:PA_Adm.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).CheckOrderTPFlagByEpisodeID()
ClassMethod CheckOrderTPFlagByEpisodeID(adm As %String) As %String
{
	set rtn=0
	
	set id=0
	while($o(^DHCBILLETPi(0,"Adm",adm,id))&&(rtn=0)) {
		set id=$o(^DHCBILLETPi(0,"Adm",adm,id))
		set data=$g(^DHCBILLETP(id))
		set tradeType=$p(data,"^",25)
		continue:(tradeType'="OP")
		set rc=$p(data,"^",1)
		continue:(rc'="01")
		set sub=0
		while($o(^DHCBILLETP(id,"C",sub))&&(rtn=0)) {
			set sub=$o(^DHCBILLETP(id,"C",sub))
			set subData=$g(^DHCBILLETP(id,"C",sub))
			set conInvDR=$p(subData,"^",1)
			continue:(+conInvDR=0)
			set conInvFlag=$p(^DHCINVPRT(conInvDR),"^",8)
			continue:(conInvFlag'="TP")
			set rtn=1
		}
	}
	
	quit rtn
}

/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCOPBillPayLogic).ReadReceiptNO("O", 5, 2)
ClassMethod ReadReceiptNO(ReceiptType As %String, UserDR As %String, HospId As %String = "") As %String
{
	set CurrID="", BegNo="", EndNo="", ReceiptNo="", Title=""
	set INVRowID=0
	for  set INVRowID=$o(^DHCINVOICE(0,"USER",UserDR,INVRowID)) quit:((INVRowID="")||(CurrID'=""))  do
	.set INVData=$g(^DHCINVOICE(INVRowID))
	.set FinFlag=$p(INVData,"^",7)
	.quit:(FinFlag'="Y")
	.set Type=$p(INVData,"^",8)
	.quit:(Type'=ReceiptType)		//条件不等退出
	.set HospDR=$p(INVData,"^",26)
	.quit:(HospDR'=HospId)
	.set ReceiptNo=$p(INVData,"^",6)
	.set EndNo=$p(INVData,"^",2)
	.set BegNo=$p(INVData,"^",1)
	.set Title=$p(INVData,"^",16)
	.quit:(+ReceiptNo<+BegNo)
	.quit:(+ReceiptNo>+EndNo)
	.set CurrID=INVRowID
	
	quit CurrID_"^"_BegNo_"^"_EndNo_"^"_ReceiptNo_"^"_Title
}

}
