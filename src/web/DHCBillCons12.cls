Import SQLUser

Class web.DHCBillCons12 Extends BILL.COM.Abstract
{

ClassMethod ReBill(UserId As %String, PARowid As %String, myPayor As %String, myPatPaySum As %String, rbPayinfo As %String, SFlag As %String, OldINVRID As %String = "", ExpStr As %String = "") As %String
{
	set $zt="ERROR"

	if ('$g(^||TMP("BillINV",$j))) quit 101_"^"_"门诊结算没有数据"
	
	set rtn=0
	set myAdmLGFlag=$p(ExpStr,"^",11)       //发票记录是否留观发票
	
	set myRecNoStr=""
	set myrbpatsum=0
	set myrbroundsum=0
	
	ts
	
	set rbInvIdx=""
	while($o(^||TMP("BillINV",$j,rbInvIdx))) {
		set rbInvIdx=$o(^||TMP("BillINV",$j,rbInvIdx))
		set nbillrid=""				//新账单RowID的字符串?
		set myinstypenew=""
		set rbinstype=""
		while($o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype))) {
			set rbinstype=$o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype))
			set myinstypenew=rbinstype
			set rbarcpb=""			//对于每个账单重新结算?账单层?
			while($o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb))) {
				set rbarcpb=$o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb))
				set pbData=$g(^DHCPB(rbarcpb))
				set pbDateFrom=$p(pbData,"^",6)      //PB_DateFrom
				set pbDateTo=$p(pbData,"^",7)        //PB_DateTo
				if ((pbDateFrom="")||(pbDateTo="")) {
					set rtn=1_"^"_"账单:"_rbarcpb_"日期错误"
					quit
				}
				set idatestr=pbDateFrom_"^"_pbDateTo
				if (myAdmLGFlag="Y") {     //+2018-07-27 ZhYW 留观结算时，不重新账单，直接返回原来的账单
					set nbillrid=nbillrid_rbarcpb_$c(2)
					continue
				}
				set myordrid=""
				set rbordrid=""
				while($o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb,"ORD",rbordrid))) {
					set rbordrid=$o(^||TMP("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpb,"ORD",rbordrid))
					set myordrid=myordrid_rbordrid_"^"
				}
				if (myordrid'="") {
					set rtnValue=##class(web.UDHCJFIntBill).RINBILL(rbarcpb, idatestr, myordrid, UserId, rbinstype, SFlag)   //重新生成账单
					set rtn=$p(rtnValue,"^",1)   //取得新账单的RowID
					if (+rtn) {
						set rtn=rtnValue
						quit
					}
					set newBill=$p(rtnValue,"^",2)
					set nbillrid=nbillrid_newBill_$c(2)
				}
			}
		}
		//这一层是票据层;把这个循环完毕，一张票据
		quit:(+rtn)
		//当前的票据金额?
		set CurBillSum=$g(^||TMP("BillINV",$j,rbInvIdx,"PatPaySum"))
		set myPreSum=$g(^||TMP("BillINV",$j,rbInvIdx,"OPPreSum"))
		set myChargeSum=$g(^||TMP("BillINV",$j,rbInvIdx,"OPChargeSum"))
		set myRoundSum=$g(^||TMP("BillINV",$j,rbInvIdx,"OPRoundSum"))
		set mySubAvailDR=$g(^||TMP("BillINV",$j,rbInvIdx,"SubAvail"))
		if (myinstypenew="") set myinstypenew=myPayor
		set rtnValue=..SaveINV(UserId, CurBillSum, rbPayinfo, PARowid, nbillrid, myinstypenew, SFlag, OldINVRID, myPreSum, myChargeSum, myRoundSum, mySubAvailDR, ExpStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set myIvtRID=$p(rtnValue,"^",2)
		set myIvtData=$g(^DHCINVPRT(myIvtRID))
		set myrbpatsum=myrbpatsum+$p(myIvtData,"^",16)
		set myrbroundsum=myrbroundsum+$p(myIvtData,"^",37)		//PRT_OPCRoundErr
		set myRecNoStr=$s((myRecNoStr=""):myIvtRID,1:(myRecNoStr_"^"_myIvtRID))
	}
	if (+rtn) tro  quit rtn
	
	//+2018-03-10 xiongwang
	do ##class(web.DHCOPBillChargExcepitonAnalyse).SaveReBillOrdLog(myRecNoStr)
	
	//判断收钱，界面显示与后台计算合一   如果大于1分退出
	if ($zabs(myrbpatsum-myPatPaySum)>0.01) {
		tro
		quit 102_"^"_"支付金额不符，计算金额："_$fn(myrbpatsum,"",2)_"，传入金额："_$fn(myPatPaySum,"",2)
	}
	
	//判断舍入金额
	if ($zabs(myrbroundsum)>0.2) {
		tro
		quit 112_"^"_"四舍五入舍入金额过大，请分批结算"
	}
	
	//2019-01-22 Lid 注释，药房程序已改，可以按拆分处方结算了
	//判断处方是否被拆分了，被拆分不能结算
	/*
	set isSplitPresno=..IsSplitPresno(myRecNoStr)
	if (isSplitPresno="Y") {
		tro
		quit 132_"^"_"同一个处方被拆分"
	}
	*/
	
	if ($tl>0) tc
	
	quit rtn_"^"_myRecNoStr

ERROR
	quit ..AppException()
}

/// UserId   SS_User->RowID
/// InvAcount	当前票据钱数   此钱是患者支付钱数?
/// 在宁波版本改造支付模式，格式如下：
/// Payinfo=
/// Payinfo 	界面传入的支付方式和支票号码
/// PARowid	Pa_PatMas->rowid
/// newBillRID	当前票据下的新的账单RowID串
/// ReceipNO	当前的票据号码?
/// myrbinstype		费别类型?
ClassMethod SaveINV(UserId As %String, InvAcount As %String, Payinfo As %String, PARowid As %String, newBillRID As %String, myrbinstype As %String, SFlag As %String, OldINVRID As %String = "", PreSum As %String, ChargeSum As %String, RoundSum As %String, SubAvailDR As %String, ExpStr As %String = "") As %String
{
	set myGroupId=$p(ExpStr,"^",1)
	set myCTLoc=$p(ExpStr,"^",2)
	set myPINVFlag=$p(ExpStr,"^",4)			//优先发票打印发票标志
	set myFairType=$p(ExpStr,"^",5)
	set NewInsType=$p(ExpStr,"^",9)			//新费别
	set LocalIPAddress=$p(ExpStr,"^",10)    //IP地址
	set FootUserId=$p(ExpStr,"^",14)		//+2023-03-17 ZhYW 做日结使用的操作员Id
	
	if (LocalIPAddress="") {
		set LocalIPAddress=$system.Process.ClientIPAddress()
	}
	set AdmLGFlag=$p(ExpStr,"^",11)			//留观标志
	if ((+NewInsType'=+myrbinstype)&&(+NewInsType'=0)) {				//费别发生变化时，以新费别结算
		set myrbinstype=NewInsType
	}
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myCTLoc)  //根据科室取医院DR
	
	set rtn=0
	
	//+2023-02-13 ZhYW 根据配置控制住院患者是否允许门诊结算配置
	set inAdm=##class(web.DHCIPBillReg).GetAdmitEpisodeID(PARowid)   //获取住院在院就诊Id
	if (+inAdm>0) {
		set isAllowed=..IsAllowedIPPatChrg(myHospDR)
		if ('isAllowed) {
			set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(inAdm)
			set admHospDesc=$s((+admHospDR'=0):$p($g(^CT("HOSP",admHospDR)),"^",2),1:"")
			quit 147_"^"_"患者正在"_admHospDesc_"住院，不能结算门诊费用"
		}
	}
	
	//获取此票据金额
	set totSum=0
	set patSum=0
	set discSum=0
	set payorSum=0
	set mylen=$l(newBillRID,$c(2))-1
	for i=1:1:mylen {
		set myPBRowId=$p(newBillRID,$c(2),i)
		continue:(+myPBRowId=0)
		set myPBData=$g(^DHCPB(myPBRowId))
		set totSum=totSum+$p(myPBData,"^",8)
		set discSum=discSum+$p(myPBData,"^",9)
		set payorSum=payorSum+$p(myPBData,"^",11)
		set patSum=patSum+$p(myPBData,"^",12)
	}
	
	//+2022-11-21 ZhYW 根据配置控制单张发票的最大金额
	if ((SFlag=0)&&(AdmLGFlag'="Y")) {
		set maxAmt=..GetSingleInvMaxAmt(myGroupId, myHospDR)
		quit:((+maxAmt'=0)&&(patSum>maxAmt)) 145_"^"_"发票金额超过"_maxAmt_"，请分开结算"
	}
	
	set ARRCP=""
	set myUseINVType="O"
	set myPFlag="N"
	
	//插入DHC_INVPRT
	set myCurDate=+$h
	set myCurTime=$p($h,",",2)
	set InvDate=myCurDate
	set InvTime=myCurTime
	set PrePayUserDR=UserId   //2020-11-16 ZhYW 增加预结日期，时间，操作员信息
	set PrePayDate=myCurDate
	set PrePayTime=myCurTime
	set myOPPreSum=PreSum
	set myOPBackChange=ChargeSum
	set myRoundErr=RoundSum
	set ReceipNO=""
	
	set myINVPInfo=totSum_"^"_ARRCP_"^"_InvDate_"^"_"TP"_"^"_PARowid_"^"_myUseINVType_"^"_""_"^"_InvTime_"^"_UserId
	set myINVPInfo=myINVPInfo_"^"_ReceipNO_"^"_payorSum_"^"_discSum_"^"_patSum_"^"_myrbinstype_"^"_OldINVRID_"^"_myPFlag
	set myINVPInfo=myINVPInfo_"^"_myFairType
	set myINVPInfo=myINVPInfo_"^"_myOPPreSum
	set myINVPInfo=myINVPInfo_"^"_myOPBackChange
	set myINVPInfo=myINVPInfo_"^"_myRoundErr			 //20
	set myINVPInfo=myINVPInfo_"^"_SubAvailDR			 //21
	set myINVPInfo=myINVPInfo_"^"_myHospDR               //22
	set myINVPInfo=myINVPInfo_"^"_myGroupId              //23
	set myINVPInfo=myINVPInfo_"^"_LocalIPAddress	     //24
	set myINVPInfo=myINVPInfo_"^"_AdmLGFlag	             //25
	set myINVPInfo=myINVPInfo_"^"_PrePayUserDR	         //26
	set myINVPInfo=myINVPInfo_"^"_PrePayDate	         //27
	set myINVPInfo=myINVPInfo_"^"_PrePayTime	         //28
	set myINVPInfo=myINVPInfo_"^"_FootUserId	         //29
	set rtnValue=##class(web.UDHCINVPRT).INVPRT(myINVPInfo)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set INVRowid=$p(rtnValue,"^",2)  //票据RowID
	
	//保存发票表与账单表的关系
	set mylen=$l(newBillRID,$c(2))-1
	for i=1:1:mylen {
		set myPBRowId=$p(newBillRID,$c(2),i)
		continue:(+myPBRowId=0)
		set myPBData=$g(^DHCPB(myPBRowId))
		set myAdmRowId=$p(myPBData,"^",1)
		if ($d(^DHCBCI(0,"Bill",myPBRowId))) {
			set rtn=144_"^"_"一个账单对应了多条结算记录"
			quit
		}
		&SQL(
			INSERT INTO DHC_BillConINV (
				DHCBCI_ADMDR, DHCBCI_INVDR, DHCBCI_PatBillDR
			)
     		VALUES (
     			:myAdmRowId, :INVRowid, :myPBRowId
     		)
     	)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	quit:(+rtn) rtn
	
	//+2017-08-25 ZhYW 门诊收费是否收费医嘱跟挂号医嘱共存
	set myGSVal=##class(web.UDHCOPGSConfig).ReadCFByGRowID(myGroupId, myHospDR)
	set regBillConfig=$p(myGSVal,"^",22)
	if (+regBillConfig=0) {     //配置不能一起结算时判断
		set rtn=..CheckBillArcim(INVRowid)
		quit:(+rtn) rtn
	}
		
	//验证账单表与发票表是否平
	set rtn=..CheckInvPBInfo(INVRowid)
	quit:(+rtn) rtn
	
	//验证发票内医嘱是否重复收费
	set rtn=..CheckOrdItmIsPay(INVRowid)
	quit:(+rtn) rtn
	
	//向药房传接口信息
	//收费过程中 在收费过程中向门诊药房传递数据?退费过程在退费中完成
	if ((SFlag=0)&&(AdmLGFlag'="Y")) {
		set rtnValue=##class(PHA.FACE.OUT.Com).ChkPhLocWin(INVRowid)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) 142_"^"_"药房组接口[PHA.FACE.OUT.Com||ChkPhLocWin("_$lts($lb(INVRowid))_")]失败:"_rtnValue
	}
	
	quit rtn_"^"_INVRowid
}

/// 目的是为了给每张发票打入一个收入，找零和舍入的节点值
/// 无只用^TMP相互之间传递数据
ClassMethod BuildOPCINVRound(PreSum As %String, ChargeSum As %String, RoundSum As %String, HospId As %String, ExpStr As %String) As %String
{
	q:('$d(^||TMP("BillINV",$j))) 0
	
	s myINVCount=+$g(^||TMP("BillINV",$j))
	
	;预收   OPPreSum
	;找零	OPChargeSum
	;舍入	OPRoundSum
	s myInvIdx=0
	f  s myInvIdx=$o(^||TMP("BillINV",$j,myInvIdx)) q:(myInvIdx="")  d
	.i (myInvIdx=myINVCount) d
	..s:(+PreSum>0) ^||TMP("BillINV",$j,myInvIdx,"OPPreSum")=+$g(PreSum)
	..s ^||TMP("BillINV",$j,myInvIdx,"OPChargeSum")=+$g(ChargeSum)
	..;
	..s myPatPaySum=^||TMP("BillINV",$j,myInvIdx,"PatPaySum")
	..s myCurPreSum=##class(web.DHCBillConsIF).OPCRound(myPatPaySum, HospId, ExpStr)
	..s RoundSum=$fn(myCurPreSum-myPatPaySum,"",2)
	..s ^||TMP("BillINV",$j,myInvIdx,"OPRoundSum")=+RoundSum
	.e  d
	..s myPatPaySum=^||TMP("BillINV",$j,myInvIdx,"PatPaySum")
	..s myCurPreSum=##class(web.DHCBillConsIF).OPCRound(myPatPaySum, HospId, ExpStr)
	..s myCurChargeSum=0
	..//多收的在字段中显示为正，少收在字段中显示为负
	..s myCurRoundSum=$fn(myCurPreSum-myPatPaySum,"",2)
	..s PreSum=PreSum-myCurPreSum
	..s ChargeSum=ChargeSum-myCurChargeSum
	..s RoundSum=RoundSum-myCurRoundSum
	..s:(+PreSum>0) ^||TMP("BillINV",$j,myInvIdx,"OPPreSum")=+myCurPreSum
	..s ^||TMP("BillINV",$j,myInvIdx,"OPChargeSum")=+myCurChargeSum
	..s ^||TMP("BillINV",$j,myInvIdx,"OPRoundSum")=+myCurRoundSum
	
	q 0
}

/// Creator: Lid
/// CreatDate: 2012-03-26
/// Description: 门诊收费确认完成
/// Input: CallFlag: 调用位置(0:自费病人且非银医卡时调用, 1:医保结算后调用, *2:第三方支付结算后调用, 3:JS中调用)
///        Guser：收费员rowid
///        InsTypeDR：费别指针
///        PrtRowIDStr：发票rowid串，与"^"分割
/// 	   SFlag：0:收费，1:退费
/// 	   OldPrtInvDR：原发票rowid，退费时传
/// 	   ExpStr: 扩张串，暂时与预结算接口的扩展串相同，不能随意添加。
/// 				=安全组^登陆科室^账户ID^是否打印发票标志^收费挂号标志^预收金额^找零^分币误差^新结算费别^终端IP^留观标志^科室卡消费不弹界面标识^病种编码^做日结使用的操作员Id(诊间收费不可以为空)
/// 	   PayInfo：支付方式列表，有多个时以$c(2)分割，默认为空（考虑第三方支付接口兼容以前的版本）
/// 					注意第9位是分币误差串，注意格式(发票rowid|误差金额|舍入前金额|舍入后金额!发票rowid|误差金额|舍入前金额|舍入后金额)。
/// 				=支付方式id^银行Id^支票号^支付卡id(暂时没用，如是CPP，可以考虑传账户rowid)^支付单位id^支票日期^账户号或银行卡号^支付金额^发票rowid|误差金额|舍入前金额|舍入后金额!发票rowid|误差金额|舍入前金额|舍入后金额^实收^找零_$c(2)_...;
/// Return: 
/// Modify: 2020-05-26 Lid 入参增加了支付方式列表
/// Debug: w ##class(web.DHCBillCons12).CompleteCharge("3","17275","1","818","0","","239^3^^Y^F^^^0^1^192.168.101.95^^^","1^^^^^^^250^^500.00^250.00^")
ClassMethod CompleteCharge(CallFlag As %String, Guser As %String, InsTypeDR As %String, PrtRowIDStr As %String, SFlag As %String, OldPrtInvDR As %String = "", ExpStr As %String = "", PayInfo As %String = "")
{
	set $zt="ERROR"

	set ^TMP("CompleteCharge")=$lb(CallFlag, Guser, InsTypeDR, PrtRowIDStr, SFlag, OldPrtInvDR, ExpStr, PayInfo)

	set rtn=0
	
	set PrtRowIDStr=..ValidatePrtRowID(PrtRowIDStr)
    set PayInfo=..SortPayInfo(PayInfo)    //对支付方式进行排序

	//2020-08-17 ZhYW 校验传入的支付方式, 该验证须在..ModifyExpStr()之前
	set Group=$p(ExpStr,"^",1)			//安全组
	set CTLocDR=$p(ExpStr,"^",2)		//登录科室
    set FairType=$p(ExpStr,"^",5)		//挂号\收费标识
    set StayFlag=$p(ExpStr,"^",11)		//留观标识
    
    //+2022-09-19 ZhYW 由于存在虚拟的支付方式在传入时修改为实际支付方式情况，所以先不控制(例如收银台选择聚合支付，但传入微信/支付宝)
    /*
    if ((+SFlag=0)&&(StayFlag'="Y")) {
		set BusiType=$case(FairType,"R":"REG",:"FEE")
		set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
		set rtn=##class(web.DHCBillConsIF).CheckPayMode(Group, HospDR, BusiType, InsTypeDR, PayInfo)
		quit:(+rtn) rtn
    }
    */
	if (+SFlag=1) {
		set ExpStr=..ModifyExpStr(ExpStr, OldPrtInvDR)
	}
	
	set curDate=+$h
	set curTime=$p($h,",",2)
	
	ts
	
	//更新发票表状态、发票号, 账单表，医嘱表的状态
	set tempPayInfo=PayInfo
	for i=1:1:$l(PrtRowIDStr,"^") {
		set PrtRowID=$p(PrtRowIDStr,"^",i)
		continue:(+PrtRowID=0)
		set PrtData=$g(^DHCINVPRT(PrtRowID))
		set PrtFlag=$p(PrtData,"^",8)
		continue:(PrtFlag'="TP")
		set myInsTypeDR=$p(PrtData,"^",9)
		//分解支付方式列表及插入发票支付方式表
		set rtn=..SplitInvPayMode(PrtRowID, .tempPayInfo)
		quit:(+rtn)
		set rtn=..CheckInvPBInfo(PrtRowID)
		quit:(+rtn)
		/*
		//将发票RowId反向更新到灵活折扣表
		set rtn=##class(BILL.PKG.BL.Flexiblediscount).UpdateFlexibleddiscountSub(PrtRowID)
		quit:(+rtn)
		//将发票更新到优惠券表
		set CouponInfo=##class(BILL.PKG.BL.Coupon).CheckCoupon(PrtRowID)
		if (+CouponInfo'=0) {
			set CouponRowId=$p(CouponInfo,"^",1)
			set rtn=##class(BILL.PKG.BL.Coupon).UpdateCoupon(CouponRowId, 0, Guser, PrtRowID)
			quit:(+rtn)
		}
		*/
		//插入账户表信息
		set rtn=..InsertAccInfo(PrtRowID, Guser, ExpStr)
		quit:(+rtn)
		//插入留观账户表信息
		set rtn=..InsertEPMInfo(PrtRowID, Guser, ExpStr)
		quit:(+rtn)
		//+2022-09-07 ZhYW 体检代金卡、体检预交金消费
		set rtn=..InsertAPMInfo(PrtRowID, Guser, ExpStr)
		quit:(+rtn)
		//插入药房中间表
		set rtn=..InsertPHARWIN(PrtRowID, "charge")
		quit:(+rtn)
		//更新账单和医嘱为收费状态
		set rtn=..UpdateInvConBill(PrtRowID, Guser, curDate, curTime)
		quit:(+rtn)
		//更新发票号
		set rtn=..UpdateReceipNO(Guser, myInsTypeDR, PrtRowID, ExpStr, curDate, curTime)
		quit:(+rtn)
		//ZhYW 2022-03-24 插入发票对应的门诊门诊子分类金额和会计子分类金额
		set rtn=##class(BILL.OP.BL.SubCateFee).SaveCateFee(PrtRowID)
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	set rtn=..CheckPayInfo(tempPayInfo)
	if (+rtn) tro  quit rtn
	
	/*
	set rtn=..build(PrtRowIDStr)
	if (+rtn) tro  quit rtn
	*/
	
	//+2017-08-25 ZhYW 调用医生站接口更新挂号流水表
	set rtn=..UpdateRegistionFeeInv(PrtRowIDStr, SFlag)
	if (+rtn) tro  quit rtn
	
	//+2018-01-02 ZhYW 验证医嘱计费状态
	for index=1:1:$l(PrtRowIDStr,"^") {
		set prtRowID=$p(PrtRowIDStr,"^",index)
		continue:(+prtRowID=0)
		set prtFlag=$p(^DHCINVPRT(prtRowID),"^",8)
		if (prtFlag'="N") {
			set rtn=136_"^"_"结算记录状态错误："_prtFlag
			quit
		}
		set rtn=..CheckOrdItmIsPay(prtRowID)    //验证发票内医嘱是否重复收费
		quit:(+rtn)
		set billConInvDR=0
		while($o(^DHCBCI(0,"INV",prtRowID,billConInvDR))) {
			set billConInvDR=$o(^DHCBCI(0,"INV",prtRowID,billConInvDR))
			set pb=$p(^DHCBCI(billConInvDR),"^",2)
			set payedFlag=..GetItmsPayedFlag(pb)
			if (payedFlag'="P") {
				set rtn=137_"^"_"医嘱状态错误："_payedFlag
				quit
			}
		}
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	//+2020-10-09 ZhYW 关联业务表和第三方支付订单表
	set rtn=##class(web.DHCBillConsIF).RelationHISToOrder(PrtRowIDStr, SFlag)
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	//调用平台接口
	if ((SFlag=0)&&(CallFlag'=2)) {
		job ##class(web.DHCOPBillSendService).SendOPChargeInfo(PrtRowIDStr, ExpStr)::5
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

ClassMethod UpdateReceipNO(UserId As %String, InsType As %String, PrtRowID As %String, ExpStr As %String, CurDate As %Date = {+$h}, CurTime As %Time = {$p($h,",",2)}) As %String
{
	set Group=$p(ExpStr,"^",1)
	set CTLocDR=$p(ExpStr,"^",2)
	set myPINVFlag=$p(ExpStr,"^",4)			   //优先发票打印发票标志
	set myFairType=$p(ExpStr,"^",5)
	set footUserId=$p(ExpStr,"^",14)		   //+2023-03-17 ZhYW 做日结使用的操作员Id
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)  //根据科室取医院DR
	
	set rtn=0
	
	//+2022-11-17 ZhYW
	set PrtData=$g(^DHCINVPRT(PrtRowID))
	set InsuDivDR=$p(PrtData,"^",30)             //PRT_InsDiv_DR
	set InvkInsuDivFlag=$p(PrtData,"^",49)       //PRT_InvkInsuDivFlag
	quit:((+InsuDivDR>0)&&(InvkInsuDivFlag'="Y")) -1_"^"_"结算不调用医保接口，医保结算指针不能有值"
	quit:((+InsuDivDR=0)&&(InvkInsuDivFlag="Y")) -1_"^"_"结算调用医保接口，医保结算指针不能为空"
	
	set prtFlag=1   //默认不打印
	if (myPINVFlag="Y") {
		//2020-08-24 ZhYW 如果是部分退费重收，退费时进行了自动撤销集中打印发票的，需要打印发票
		set OldINVDR=$p(PrtData,"^",29)       //PRT_OldINV_DR
		set ACPRowId=$s((+OldINVDR'=0):$o(^DHCINVPRTCAPi(0,"INVPRTDR",OldINVDR,"0")),1:"")
		if (+ACPRowId'=0) {
			set prtFlag=0
		}else {
			//判断是否需要打印发票?还是直接打印一个小条?由配置来定
			set prtFlag=##class(web.DHCBillConsIF).CheckPrtFlag(InsType, Group, HospDR, myPINVFlag)
			//根据安全组配置需打印发票时再根据支付方式二次判断
			if (prtFlag=0) {
				set prtFlag=##class(web.DHCBillConsIF).CheckPrtFlagByGSPM(PrtRowID)
			}
		}
	}
	
	set myUseINVType="O"
	set myGSVal=##class(web.UDHCOPGSConfig).ReadCFByGRowID(Group, HospDR)
	if (+prtFlag=0) {
		set rtn=$p(myGSVal,"^",1)
		quit:(+rtn) rtn
		set myGSUseINVType=$p(myGSVal,"^",13)
		if (myGSUseINVType'="") {
			set myUseINVType=myGSUseINVType
		}
	}
	
	//增加费别与发票类型的配置，按如果做了费别与发票类型的配置则按费别取发票类型
	set myInsINVType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(InsType, "O", HospDR)
	if (myInsINVType'="") set myUseINVType=myInsINVType
	
	set myRegReceiptType=##class(web.udhcOPBill7).GetRegReceiptType(HospDR)
	if ((myFairType="R")&&(myRegReceiptType'="")) set myUseINVType=myRegReceiptType
	
	set myINVRowId="", myReceipNO="", myINVPreABC=""
	if (+prtFlag=0) {
		&SQL(
			SELECT TOP 1 %ID, INV_LastNum, INV_title INTO :myINVRowId, :myReceipNO, :myINVPreABC
			FROM DHC_INVOICE
			WHERE INV_Usr = :UserId AND INV_Finalflag = 'Y' AND INV_type = :myUseINVType AND INV_hospital = :HospDR
			ORDER BY %ID
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$case(+rtn,100:"没有可用发票，请先领取",:$g(%msg))
		
		//更新发票发放表
		set ReceipNew=+myReceipNO+1
		set rtn=##class(web.udhcOPBill).UpdateReceipNO(UserId, ReceipNew, Group, myFairType, InsType, HospDR)
		quit:(+rtn) rtn
	}
	
	//更新发票DHC_INVPRT
	set invPrtObj=##class(User.DHCINVPRT).%OpenId(PrtRowID, 0)
	if ('$isObject(invPrtObj)) {
	    quit -1_"^"_"创建对象失败"
	}
	set invPrtObj.PRTDate=CurDate
	set invPrtObj.PRTFlag="N"
	set invPrtObj.PRTinv=myINVPreABC_myReceipNO
	set invPrtObj.PRTUseINVType=myUseINVType
	set invPrtObj.PRTTime=CurTime
	do invPrtObj.PRTUsrSetObjectId($s((+footUserId=0):UserId,1:footUserId))    //+2023-03-17 ZhYW
	set invPrtObj.PRTINVPrintFlag=$case(prtFlag,0:"P",:"N")
	do invPrtObj.PRTGroupDRSetObjectId(Group)
	do invPrtObj.PRTRealUserDRSetObjectId(UserId)
	set sc=invPrtObj.%Save()
	do invPrtObj.%Close()
	if $$$ISERR(sc) {
		set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
		quit rtn
	}
	
	//2021-04-08 ZhYW 保存发票扩展表数据
	set papmi=$p(^DHCINVPRT(PrtRowID),"^",15)
	set payer=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set payerID=$p($g(^PAPER(papmi,"ALL")),"^",9)    //身份证号
	set dto=##class(BILL.INV.DTO.Entity.PrtExt).%New()
	set dto.InvType="O"
	set dto.InvDR=PrtRowID
	set dto.BatchNo=myINVPreABC
	set dto.InvNo=myReceipNO
	set dto.PAPMIDR=papmi
	set dto.Payer=payer
	set dto.PayerIdentifier=payerID
	set dto.UserDR=UserId
	set dto.Reviewer=""
	set dto.InvoiceDR=myINVRowId
	set rtn=##class(BILL.INV.BL.PrtExt).Save(dto)
	quit:(+rtn) rtn
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-04-01
/// Description: 对于退费重新的确认完成,JS中传进的扩展串信息不全,需要重新修改一下。
/// Debug: w ##class(web.DHCBillCons12).ModifyExpStr()
ClassMethod ModifyExpStr(ExpStr As %String, OldPrtInvDR As %String) As %String
{
	quit:(+OldPrtInvDR=0) ExpStr
	
	set Group=$p(ExpStr,"^",1)			//安全组
	set CTLocDR=$p(ExpStr,"^",2)		//登录科室
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
	set AccMRowID=$p(ExpStr,"^",3)
	//+2023-03-28 ZhYW 传入账户优先
	if (AccMRowID="") {
		set PayListDR=##class(web.UDHCINVPRT).GetPayListIDByInv(+OldPrtInvDR)
		set AccMRowID=$p(PayListDR,"||",1)
	}
	set $p(ExpStr,"^",3)=AccMRowID

	set myPrtData=$g(^DHCINVPRT(+OldPrtInvDR))
	set myINVNo=$p(myPrtData,"^",14)
	if (myINVNo'="") {
		set $p(ExpStr,"^",4)="Y"			//需要发票的支持
	}
	set FairType=$p(myPrtData,"^",34)
	set $p(ExpStr,"^",5)=FairType
	set NInvPay=+$p(myPrtData,"^",16)
	set myRoundSum=##class(web.DHCBillConsIF).OPCRound(NInvPay, HospDR, "")
	set $p(ExpStr,"^",6)=myRoundSum
	set $p(ExpStr,"^",7)=0
	set $p(ExpStr,"^",8)=myRoundSum-NInvPay
	
	quit ExpStr
}

ClassMethod InsertAccInfo(INVRowid As %String, UserId As %String, ExpStr As %String) As %String
{
	set Group=$p(ExpStr,"^",1)			 //安全组
	set CTLocDR=$p(ExpStr,"^",2)		 //登录科室
	set AccMRowID=$p(ExpStr,"^",3)       //账户RowID
	set NewInsTypeDR=$p(ExpStr,"^",9)	 //新结算费别
	
	set PayMSubId=##class(web.DHCBillCons12).GetINVPayMIDByCode(INVRowid, "CPP")
	quit:(PayMSubId="") 0    //为空说明没有卡消费
	
	quit:(AccMRowID="") 1131_"^"_"预交金账户为空"

	set InvPayMData=$g(^DHCINVPRT(+PayMSubId,"P",$p(PayMSubId,"||",2)))
	set PayAmt=$p(InvPayMData,"^",3)
	
	set rtn=##class(web.UDHCAccAddDeposit).HasToRefAccPD(AccMRowID)
	quit:(+rtn) 111_"^"_"存在未完成的退款记录"

	set PARowid=$p(^DHCINVPRT(INVRowid),"^",15)
	set myPAPMINo=$p($g(^PAPER(PARowid,"PAT",1)),"^",1)
	//验证账户是否为同一账户
	set AccMPAPMIDR=$p(^DHCACD("AccM",AccMRowID),"^",2)
	quit:(PARowid'=AccMPAPMIDR) 113_"^"_"预交金账户开户人和结算患者不一致"
	
	//验证账户余额
	set rtn=##class(web.DHCBillCons12).JudgeAccBalance(AccMRowID, -PayAmt)
	quit:(+rtn) rtn
	
	set myHospDR=$p(^DHCINVPRT(INVRowid),"^",39)
	set $p(myAPLInfo,"^",1)=AccMRowID		   //AccManRef
	set $p(myAPLInfo,"^",2)=PARowid		       //PAPMIDR
	set $p(myAPLInfo,"^",3)=INVRowid		   //InvPrtDR
	set $p(myAPLInfo,"^",4)=myPAPMINo		   //PAPMINo
	set $p(myAPLInfo,"^",5)="OP"	           //业务类型
	set $p(myAPLInfo,"^",6)=UserId		       //UserDR
	set $p(myAPLInfo,"^",7)=+$h	               //PayDate
	set $p(myAPLInfo,"^",8)=$p($h,",",2)       //PayTime
	set $p(myAPLInfo,"^",9)=PayAmt		       //PayNum
	set $p(myAPLInfo,"^",10)=CTLocDR		   //PayRecLoc_DR
	set $p(myAPLInfo,"^",11)=NewInsTypeDR      //费别
	set $p(myAPLInfo,"^",12)=""	               //预留字段
	set $p(myAPLInfo,"^",13)=myHospDR	       //2018-08-02 ZhYW
	set rtnValue=##class(web.UDHCACPayList).INSPayInfo(AccMRowID, myAPLInfo)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set myPLRowID=$p(rtnValue,"^",2)
	
	&SQL(
		UPDATE DHC_INVPayMode
		SET IPM_AccPL_DR = :myPLRowID
		WHERE %ID = :PayMSubId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2015-01-13
/// Description: 支付留观押金
ClassMethod InsertEPMInfo(INVRowid As %String, UserId As %String, ExpStr As %String) As %String
{
	set Group=$p(ExpStr,"^",1)			//安全组
	set CTLocDR=$p(ExpStr,"^",2)		//登录科室
	set AccMRowID=$p(ExpStr,"^",3)	    //账户ID
	set NewInsTypeDR=$p(ExpStr,"^",9)	//新结算费别
		
	set PayMSubId=##class(web.DHCBillCons12).GetINVPayMIDByCode(INVRowid, "ECPP")
	quit:(PayMSubId="") 0    //为空说明没有急诊留观消费

	quit:(AccMRowID="") 1131_"^"_"留观账户为空"
	
	set InvPayMData=$g(^DHCINVPRT(+PayMSubId,"P",$p(PayMSubId,"||",2)))
	set PayAmt=$p(InvPayMData,"^",3)
	
	set PARowid=$p(^DHCINVPRT(INVRowid),"^",15)
	set myPAPMINo=$p($g(^PAPER(PARowid,"PAT",1)),"^",1)
	//验证账户是否为同一账户
	set myEPMPAPMIDR=$p($g(^DHCEPM("EPM",AccMRowID)),"^",3)
	quit:(PARowid'=myEPMPAPMIDR) 113_"^"_"留观账户开户人和结算患者不一致"
	
	set rtn=##class(web.DHCOPBillEPManageCLS).CheckEPMLeft(AccMRowID, -PayAmt)	 //验证账户余额是否足够
	quit:(+rtn) rtn
	
	set myHospDR=$p(^DHCINVPRT(INVRowid),"^",39)
	set $p(myAPLInfo,"^",1)=AccMRowID
	set $p(myAPLInfo,"^",2)=PARowid
	set $p(myAPLInfo,"^",3)=INVRowid
	set $p(myAPLInfo,"^",4)=myPAPMINo
	set $p(myAPLInfo,"^",5)=""
	set $p(myAPLInfo,"^",6)=UserId
	set $p(myAPLInfo,"^",7)=+$h
	set $p(myAPLInfo,"^",8)=$p($h,",",2)
	set $p(myAPLInfo,"^",9)=PayAmt
	set $p(myAPLInfo,"^",10)=CTLocDR
	set $p(myAPLInfo,"^",11)=NewInsTypeDR
	set $p(myAPLInfo,"^",12)=""           //预留字段
	set $p(myAPLInfo,"^",13)=myHospDR
	set rtnValue=##class(web.DHCOPBillEPManageCLS).INSPayInfo(AccMRowID, myAPLInfo)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set myPLRowID=$p(rtnValue,"^",2)
	
	&SQL(
		UPDATE DHC_INVPayMode
		SET IPM_EPayL_DR = :myPLRowID
		WHERE %ID = :PayMSubId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	
	quit rtn
}

ClassMethod build(PrtRowIDStr As %String) As %String
{
	set rtn=0
	for i=1:1:$l(PrtRowIDStr,"^") {
		set PrtRowID=$p(PrtRowIDStr,"^",i)
	    continue:(+PrtRowID=0)
		set PrtHospID=$p($g(^DHCINVPRT(PrtRowID)),"^",39)
		continue:(PrtHospID="")
		set HospNo=$p($g(^CT("HOSP",PrtHospID)),"^",1)
		set BuissNo=##class(web.UDHCJFCOMMON).BuildHospInvID(HospNo, "O")
		&SQL(
			UPDATE DHC_INVPRT
			SET PRT_BusinessNo = :BuissNo
			WHERE %ID = :PrtRowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
    
    quit rtn
}

/// Description: 用来更新账户是否足额
/// Debug: w ##class(web.DHCBillCons12).JudgeAccBalance(7856)
ClassMethod JudgeAccBalance(AccRowID As %String, PNum As %String, InsType As %String = "") As %String
{
	set $zt="ERROR"
	
	set PNum=$fn(PNum,"",2)
	set AccMData=$g(^DHCACD("AccM",AccRowID))
	set AccMLeft=$p(AccMData,"^",8)
	set DepNum=$p(AccMData,"^",14)
	set CNum=AccMLeft-DepNum	   //减去下限
	set CNum=$fn(CNum,"",2)
	
	set AdmSource=$s((+InsType'=0):$p($g(^PAC("ADMREA",InsType)),"^",9),1:"")
	quit:((PNum<0)&&($zabs(PNum)>+CNum)&&(+AdmSource=0)) 125_"^"_"账户余额不足"
	//quit:((PNum<0)&&($zabs(PNum)>+CNum)) 125_"^"_"账户余额不足"
	
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: zhl
/// CreatDate: 2015-05-11
/// Modify: ZhYW
/// Description: 用于门诊预结算确认完成时判断当时的发票金额与对应帐单总金额是否一致
/// Input: prtRowId:DHC_INVPRT.RowID
/// Return: 0:金额一致; -100:找不到发票数据; 133:账单金额不一致, 134:账单跟发票金额不一致
/// Debug: w ##class(web.DHCBillCons12).CheckInvPBInfo(7856)
ClassMethod CheckInvPBInfo(prtRowId As %String, langId As %String = "") As %String
{
    set rtn=0
    quit:(+prtRowId=0)||'$d(^DHCINVPRT(prtRowId)) -100_"^"_"结算数据错误"
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set prtData=$g(^DHCINVPRT(prtRowId))
	set prtAcount=$p(prtData,"^",1)
	set prtAcount=$fn(prtAcount,"",2)
	set prtDiscAmt=$p(prtData,"^",7)
	set prtDiscAmt=$fn(prtDiscAmt,"",2)
	set prtPayOrAmt=$p(prtData,"^",18)
	set prtPayOrAmt=$fn(prtPayOrAmt,"",2)
	set prtPatAmt=$p(prtData,"^",16)
	set prtPatAmt=$fn(prtPatAmt,"",2)
	set hospDR=$p(prtData,"^",39)    //PRT_Hospital_DR

	set (pbSum, pbDiscSum, pbPayOrSum, pbPatSum)=0
	set billConInvDR=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))) {
		set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
		set pb=$p(^DHCBCI(billConInvDR),"^",2)
		continue:(+pb=0)
		set pbData=$g(^DHCPB(pb))
		set pbAmt=$p(pbData,"^",8)
		set pbAmt=$fn(pbAmt,"",2)
		set pbSum=$i(pbSum,pbAmt)
		set pbDiscAmt=$p(pbData,"^",9)
		set pbDiscAmt=$fn(pbDiscAmt,"",2)
		set pbDiscSum=$i(pbDiscSum,pbDiscAmt)
		set pbPayOrAmt=$p(pbData,"^",11)
		set pbPayOrAmt=$fn(pbPayOrAmt,"",2)
		set pbPayOrSum=$i(pbPayOrSum,pbPayOrAmt)
		set pbPatAmt=$p(pbData,"^",12)
		set pbPatAmt=$fn(pbPatAmt,"",2)
		set pbPatSum=$i(pbPatSum,pbPatAmt)
		set (pboSum, pboDiscSum, pboPayOrSum, pboPatSum)=0
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set arcim=$p(pboData,"^",3)
			set price=$p(pboData,"^",7)   //PBO_UnitPrice
			set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
			set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
			if (+price=0)&&(##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(hospDR, "", "ArcItm", arcim)'="Y") {
				set rtn=145_"^"_##class(websys.Translation).Get("", "医嘱项", langId)_arcimDesc_##class(websys.Translation).Get("dhcbill.opbill.charge.main.csp", "价格为零，请核实。如确认价格无误，请在【免费项目维护】界面维护该项目并在【免费项目审核】界面审核通过。", langId)
				quit
			}
			set pboAmt=$p(pboData,"^",8)
			set pboAmt=$fn(pboAmt,"",2)
			set pboSum=$i(pboSum,pboAmt)
			set pboDiscAmt=$p(pboData,"^",9)
			set pboDiscAmt=$fn(pboDiscAmt,"",2)
			set pboDiscSum=$i(pboDiscSum,pboDiscAmt)
			set pboPayOrAmt=$p(pboData,"^",10)
			set pboPayOrAmt=$fn(pboPayOrAmt,"",2)
			set pboPayOrSum=$i(pboPayOrSum,pboPayOrAmt)
			set pboPatAmt=$p(pboData,"^",11)
			set pboPatAmt=$fn(pboPatAmt,"",2)
			set pboPatSum=$i(pboPatSum,pboPatAmt)
			set (pbdSum, pbdDiscSum, pbdPayOrSum, pbdPatSum)=0
			set pbd=0
			while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
				set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
				set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
				continue:(pbdData="")
				set tariDR=$p(pbdData,"^",3)
				set price=$p(pbdData,"^",4)   //PBD_UnitPrice
				if (+price=0)&&(##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(hospDR, "", "TarItem", tariDR)'="Y") {
					set tariDesc=$p($g(^DHCTARI(+tariDR)),"^",2)
					set tariDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", tariDesc, langId)
					set rtn=145_"^"_##class(websys.Translation).Get("", "医嘱项", langId)_arcimDesc_##class(websys.Translation).Get("", "关联", langId)_##class(websys.Translation).Get("", "收费项", langId)_tariDesc_##class(websys.Translation).Get("dhcbill.opbill.charge.main.csp", "价格为零，请核实。如确认价格无误，请在【免费项目维护】界面维护该项目并在【免费项目审核】界面审核通过。", langId)
					quit
				}
				set pbdAmt=$p(pbdData,"^",7)
				set pbdAmt=$fn(pbdAmt,"",2)
				set pbdSum=$i(pbdSum,pbdAmt)
				set pbdDiscAmt=$p(pbdData,"^",8)
				set pbdDiscAmt=$fn(pbdDiscAmt,"",2)
				set pbdDiscSum=$i(pbdDiscSum,pbdDiscAmt)
				set pbdPayOrAmt=$p(pbdData,"^",9)
				set pbdPayOrAmt=$fn(pbdPayOrAmt,"",2)
				set pbdPayOrSum=$i(pbdPayOrSum,pbdPayOrAmt)
				set pbdPatAmt=$p(pbdData,"^",10)
				set pbdPatAmt=$fn(pbdPatAmt,"",2)
				set pbdPatSum=$i(pbdPatSum,pbdPatAmt)
			}
			quit:(+rtn)
			
			if ((+pboAmt'=+pbdSum)||(+pboDiscAmt'=+pbdDiscSum)||(+pboPayOrAmt'=+pbdPayOrSum)||(+pboPatAmt'=+pbdPatSum)) {
				set rtn=133_"^"_"账单表金额不平"
				quit
			}
		}
		quit:(+rtn)
		
		if ((+pbAmt'=+pboSum)||(+pbDiscAmt'=+pboDiscSum)||(+pbPayOrAmt'=+pboPayOrSum)||(+pbPatAmt'=+pboPatSum)) {
			set rtn=133_"^"_"账单表金额不平"
			quit
		}
	}
	
	quit:(+rtn) rtn

	if ((+prtAcount'=+pbSum)||(+prtDiscAmt'=+pbDiscSum)||(+prtPayOrAmt'=+pbPayOrSum)||(+prtPatAmt'=+pbPatSum)) {
		set rtn=134_"^"_"结算表与账单表金额不平"
	}
	
    quit rtn
}

/// Creator: Lid
/// CreatDate: 2015-11-17
/// Description: 重组发票rowid串，过滤回滚的发票rowid
/// Input: prtRowIdStr:发票rowid串
/// Return: 预结算成功的rowid串
ClassMethod ValidatePrtRowID(prtRowIdStr As %String) As %String
{
	set succPrtRowIdStr=""
	for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		continue:('$d(^DHCINVPRT(prtRowId)))
		set succPrtRowIdStr=$s((succPrtRowIdStr=""):prtRowId,1:(succPrtRowIdStr_"^"_prtRowId))
	}
	quit succPrtRowIdStr
}

/// Creator: zhl
/// CreatDate: 2017-08-08
/// Description: 修改门诊发票费别
ClassMethod UpdateInvInstype(PrtRowid As %String, InsTypeDR As %String, Guser As %String) As %String
{
	quit:(+PrtRowid=0)||('$d(^DHCINVPRT(PrtRowid))) -100_"^"_"结算数据错误"
	set oldInsTypeDR=$p(^DHCINVPRT(PrtRowid),"^",9)
	set rtn=0
	if ((InsTypeDR'="")&&(InsTypeDR'=oldInsTypeDR)) {
		&SQL(
			UPDATE DHC_INVPRT
			SET PRT_InsType_DR = :InsTypeDR
			WHERE %ID = :PrtRowid
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
		set ^DHCINVPRT(0,"UpdateInstype",PrtRowid)=oldInsTypeDR_"^"_InsTypeDR_"^"_Guser_"^"_$h
	}
	set insuPaySum=$p(^DHCINVPRT(PrtRowid),"^",31)   //PRT_YBPaySum
	
	quit rtn_"^"_insuPaySum
}

/// Creator: ZhYW
/// CreatDate: 2017-08-25
/// Description: 判断门诊收费是否挂号医嘱和普通收费医嘱共存
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: 0:只有挂号医嘱或只有普通收费医嘱, <>0:挂号医嘱和普通收费医嘱共存
/// Debug: w ##class(web.DHCBillCons12).CheckBillArcim(2767)
ClassMethod CheckBillArcim(prtRowId As %String) As %String
{
	set rtn=0
	set stayFlag=$p($g(^DHCINVPRT(prtRowId)),"^",44)
	quit:(stayFlag="Y") rtn   //过滤押金模式急诊留观
	
	set hospDR=$p($g(^DHCINVPRT(prtRowId)),"^",39)
	
	set regArcimNum=0
	set OPSFArcimNum=0
	
	set billConInvDR=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))) {
		set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
		set billConData=$g(^DHCBCI(billConInvDR))
		set pb=$p(billConData,"^",2)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set arcim=$p(^DHCPB(pb,"O",pbo),"^",3)
			set billSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(arcim, hospDR)   //调用医生站接口判断是否是挂号费性质医嘱
			if (billSubType'="NotRegFee") {
				set regArcimNum=$i(regArcimNum)                        //挂号医嘱数量
			}else  {
				set OPSFArcimNum=$i(OPSFArcimNum)                      //门诊收费医嘱
			}
			if ((+regArcimNum'=0)&&(+OPSFArcimNum'=0)) {
				set rtn=130_"^"_"请选择全部的挂号相关费用进行结算"
				quit
			}
		}
		quit:(+rtn)
	}
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2018-12-27
/// Description: 判断门诊收费是否挂号发票
/// Input: prtRowId发票Rowid
/// Return: 0:只含挂号医嘱, 1:含普通收费医嘱
/// Debug: w ##class(web.DHCBillCons12).CheckRegInv(836)
ClassMethod CheckRegInv(prtRowId As %String) As %String
{
	set rtn=0
	set stayFlag=$p($g(^DHCINVPRT(prtRowId)),"^",44)
	quit:(stayFlag="Y") 1    //押金模式急诊留观结算时，如果患者费用只有挂号费诊察费时也不更新发票的类型
	
	set hospDR=$p($g(^DHCINVPRT(prtRowId)),"^",39)
	
	set billConInvDR=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))) {
		set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
		set billConData=$g(^DHCBCI(billConInvDR))
		set pb=$p(billConData,"^",2)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set arcim=$p(^DHCPB(pb,"O",pbo),"^",3)
			set billSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(arcim, hospDR)   //调用医生站接口判断是否是挂号费性质医嘱
			if (billSubType="NotRegFee") {
				set rtn=1
				quit
			}
		}
		quit:(+rtn)
	}

	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-08-25
/// Description: 调用医生站接口更新挂号流水表数据
/// Input: prtRowIdStr:DHC_INVPRT.RowId, sFlag:收退标识(0:收, 1:退)
/// Return: 
/// Debug: w ##class(web.DHCBillCons12).UpdateRegistionFeeInv("839", 0)
ClassMethod UpdateRegistionFeeInv(prtRowIdStr As %String, sFlag As %String) As %String
{
	set rtn=0
	
	for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set prtData=$g(^DHCINVPRT(prtRowId))
		set stayFlag=$p(prtData,"^",44)
		continue:(stayFlag="Y")       //过滤押金模式急诊留观
		continue:(..CheckRegInv(prtRowId))     //无挂号性质的医嘱时，不调用医生站接口更新挂号流水表
		set insuDivDR=$p(prtData,"^",30)
		set fairType=$p(prtData,"^",34)         //PRT_FairType
		continue:((sFlag=0)&&(fairType'="F"))
		set isUpdt=0    //是否需要更新发票表PRT_FairType字段标识
		set billConInvDR=0
		while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))) {
			set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
			set billConData=$g(^DHCBCI(billConInvDR))
			set pb=$p(billConData,"^",2)
			set adm=$p(billConData,"^",3)
			if (fairType="F") {
				continue:('..IsNeedToUpdtRegFee(adm))   //+2022-11-29 ZhYW
			}
			set regOrdList=""
			set pbo=0
			while($o(^DHCPB(pb,"O",pbo))) {
				set pbo=$o(^DHCPB(pb,"O",pbo))
				set pboData=$g(^DHCPB(pb,"O",pbo))
				continue:(pboData="")
				set oeitm=$p(pboData,"^",4)
				set regOrdList=$s((regOrdList=""):oeitm,1:(regOrdList_"^"_oeitm))
			}
			continue:(regOrdList="")
			set rtnValue=##class(web.DHCOPAdmReg).UpdateRegistionFeeInv(adm, prtRowId, regOrdList)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=130_"^"_"医生站组接口[web.DHCOPAdmReg||UpdateRegistionFeeInv("_$lts($lb(adm, prtRowId, $tr(regOrdList,"^","＾")))_")]失败:"_rtnValue
				quit
			}
			if ((sFlag=0)&&(fairType="F")&&(..IsPrtInRegFee(adm, prtRowId))) {
				set isUpdt=1
			}
		}
		quit:(+rtn)
		//+2022-11-29 ZhYW 当更新了挂号流水表时，将发票更新为"R"
		if (isUpdt=1) {
			&SQL(
				UPDATE DHC_INVPRT
				SET PRT_FairType = 'R'
				WHERE %ID = :prtRowId
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			//+2023-04-20 ZhYW 调用医保接口更新医保分解表"挂号"标识
			set rtnValue=##class(web.DHCINSUPort).UpdtOPRegDivFlag(insuDivDR)
			if ($p(rtnValue,"^",1)<0) {
				set rtn=rtnValue
				quit
			}
		}
	}
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2014-04-15
/// Description: 判断发票对应的医嘱是否拆分处方,有一张发票上的处方拆分了，所有的发票都要撤销
/// Input: prtRowIdStr:发票表rowid串
/// Return: Y:拆分，不能结算；N:未拆分或者不包含药品医嘱，可以结算
/// Debug: w ##class(web.DHCBillCons12).IsSplitPresno(203609)
ClassMethod IsSplitPresno(prtRowIdStr As %String) As %String
{
    set rtn="N"
    for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
    	continue:(+prtRowId=0)
	   	set rtn=##class(web.DHCBillCons12).IsSplitPresnoByPrtRowid(prtRowId)
	   	quit:(rtn="Y")
	}
    quit rtn
}

/// Creator: Lid
/// CreatDate: 2014-04-15
/// Description: 判断发票对应的医嘱是否拆分处方
/// Input: prtRowId:发票表rowid
/// Return: Y:拆分，不能结算；N:未拆分或者不包含药品医嘱，可以结算
/// Debug: w ##class(web.DHCBillCons12).IsSplitPresnoByPrtRowid(203609)
ClassMethod IsSplitPresnoByPrtRowid(prtRowId As %String) As %String
{
    kill PresnoOrdIndex(prtRowId)
    kill PresnoIndex(prtRowId)
    
	set userId=$p(^DHCINVPRT(prtRowId),"^",21)
    set billConInvDR=0
    while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))) {
	    set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
		set billConData=$g(^DHCBCI(billConInvDR))
	    set pb=$p(billConData,"^",2)
		continue:(+pb=0)
	    set adm=$p(billConData,"^",3)
	    set pbo=0
	    while($o(^DHCPB(pb,"O",pbo))) {
		    set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
		    continue:(pboData="")
		    set oeitm=$p(pboData,"^",4)
		    set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
		    continue:(orderType'="R")    //过滤非药品医嘱
		    set priorFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(oeitm)
			continue:(+priorFlag=1)	  //过滤自备药医嘱
		    set presno=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",14)
		    if (presno="") {
		   		do ##class(web.DHCBillInterface).SetPresno(adm, userId)
		    }
			set presno=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",14)
			if (presno="") {
				set ^DHCBILL("OPBILL","NULLPRESNO",oeitm)=""
			}
			continue:(presno="")
		    set PresnoOrdIndex(prtRowId,presno,oeitm)=""
		    set PresnoIndex(prtRowId,presno)=""
		}
	}
	
    set rtn="N"
    
    set tmpPresno=""
    while($o(PresnoIndex(prtRowId,tmpPresno))) {
	    set tmpPresno=$o(PresnoIndex(prtRowId,tmpPresno))
	    set ord=""
	    while($o(^OEORD(0,"PrescNo",tmpPresno,ord))) {
		    set ord=$o(^OEORD(0,"PrescNo",tmpPresno,ord))
		    set sub=""
		    while($o(^OEORD(0,"PrescNo",tmpPresno,ord,sub))) {
			    set sub=$o(^OEORD(0,"PrescNo",tmpPresno,ord,sub))
			    set oeitm=ord_"||"_sub
			    set statDR=$p($g(^OEORD(ord,"I",sub,1)),"^",13)
				set statCode=$s((statDR'=""):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
			    continue:(" V E "'[(" "_statCode_" "))
			    set priorityDR=$p($g(^OEORD(ord,"I",sub,1)),"^",8)
			    set priorityCode=$s((priorityDR'=""):$p(^OECPR(priorityDR),"^",1),1:"")
				continue:(priorityCode["OM")	   //过滤自备药医嘱
				continue:($d(PresnoOrdIndex(prtRowId,tmpPresno,oeitm)))
			    set rtn="Y"
				quit
			}
			quit:(rtn="Y")
		}
		quit:(rtn="Y")
	}

    quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-12-03
/// Description: 判断发票表自负金额与支付方式总金额是否一致
/// Input: prtRowId:DHC_INVPRT.RowID
/// Return: 0:金额一致; 135:发票表自负金额与支付方式总金额不一致
/// Debug: w ##class(web.DHCBillCons12).CheckInvPayMInfo(226763)
ClassMethod CheckInvPayMInfo(prtRowId As %String) As %String
{
    set rtn=0
    quit:(+prtRowId=0) -1_"^"_"参数错误"
	
	set prtData=$g(^DHCINVPRT(prtRowId))
	set patShareAmt=$p(prtData,"^",16)
	set patShareAmt=$fn(patShareAmt,"",2)
	set roundErrAmt=$p(prtData,"^",37)
	set roundErrAmt=$fn(roundErrAmt,"",2)
	
	set paymSum=0
	set paymSub=0
	while($o(^DHCINVPRT(prtRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub))
		set paymData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
		continue:(paymData="")
		set paymAmt=$p(paymData,"^",3)
		set paymSum=$i(paymSum,paymAmt)
	}
	set paymSum=$fn(paymSum,"",2)
	
	if ((patShareAmt+roundErrAmt)'=+paymSum) {
		set rtn=135_"^"_"结算表自负金额与支付方式金额不平"
	}
    quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-01-24
/// Description: 判断是否有非"P"状态医嘱
/// Input: bill: DHC_PatientBill.RowId
/// Return: 
/// Debug: w ##class(web.DHCBillCons12).GetItmsPayedFlag(45723614)
ClassMethod GetItmsPayedFlag(bill As %String) As %String
{
	set payed="B"
	quit:(+bill=0) payed
	set payed=$p($g(^DHCPB(bill)),"^",16)
	quit:(payed'="P") payed
	set pbo=0
	while($o(^DHCPB(bill,"O",pbo))) {
		set pbo=$o(^DHCPB(bill,"O",pbo))
		set pboData=$g(^DHCPB(bill,"O",pbo))
		continue:(pboData="")
		set oeitm=$p(pboData,"^",4)
		set payed=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)
		quit:(payed'="P")
	}
	
	quit payed
}

/// Creator: wangjian
/// CreatDate: 2019-03-21
/// Description: 验证发票内医嘱是否重复收费
/// Input: prtRowId:发票表rowid
/// Return: 0:否, 138:是
/// Debug: w ##class(web.DHCBillCons12).CheckOrdItmIsPay(233336)
ClassMethod CheckOrdItmIsPay(prtRowId As %String) As %String
{
	set rtn=0
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
		set pb=$p(^DHCBCI(billConInv),"^",2)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set oeitm=$p(pboData,"^",4)
			//找本医嘱关联的账单
			set pbRowId=0
			while($o(^DHCPBi(0,"OEORI",oeitm,pbRowId))) {
				set pbRowId=$o(^DHCPBi(0,"OEORI",oeitm,pbRowId))
				continue:(pbRowId=pb)  //本账单退出
				set pbData=$g(^DHCPB(pbRowId))
				set payed=$p(pbData,"^",16)
				set refundFlag=$p(pbData,"^",17)
				if ((refundFlag="")&&(payed="P")) {
					set rtn=138_"^"_"医嘱："_oeitm_"被重复收费"
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
	}
	
	quit rtn
}

/// Creator: liusf
/// CreatDate: 2019-10-19
/// Description: 验证医嘱是否重复收费
/// Input: oeitm
/// Return: 0:否 139:是
/// Debug: w ##class(web.DHCBillCons12).CheckOrdItmIsRepeatCharges("3950||4")
ClassMethod CheckOrdItmIsRepeatCharges(oeitm As %String) As %String
{
	set rtn=0
    set chgNum=0
    //找本医嘱关联的账单
	set pbRowId=0
	for  set pbRowId=$o(^DHCPBi(0,"OEORI",oeitm,pbRowId)) quit:((pbRowId="")||(chgNum'=0))  do
	.set billConInv=0
	.for  set billConInv=$o(^DHCBCI(0,"Bill",pbRowId,billConInv)) quit:((billConInv="")||(chgNum'=0))  do
	..set InvDr=$p(^DHCBCI(billConInv),"^",1)
	..set InvFlag= $p(^DHCINVPRT(InvDr),"^",8)
	..if (" TP N "[(" "_InvFlag_" "))  do
	...set chgNum=$i(chgNum)

	if (chgNum>1) do
	.set rtn=139
	
	quit rtn
}

/// Creator: liusf
/// CreatDate: 2019-10-19
/// Description: 验证发票内医嘱是否重复收费
/// Input: prtRowId
/// Return: 0:否 139:是
/// Debug: w ##class(web.DHCBillCons12).CheckInvIsPay("3950||4")
ClassMethod CheckInvIsPay(prtRowId As %String) As %String
{
	set rtn=0
	set billConInv=0
	for  set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv)) quit:((billConInv="")||(+rtn))  do
	.set pb=$p(^DHCBCI(billConInv),"^",2)
	.set pbo=0
	.for  set pbo=$o(^DHCPB(pb,"O",pbo)) quit:((pbo="")||(+rtn))  do
	..quit:($d(^DHCPB(pb,"O",pbo))=10)
	..set oeitm=$p(^DHCPB(pb,"O",pbo),"^",4)
    ..set rtn=##class(web.DHCBillCons12).CheckOrdItmIsRepeatCharges(oeitm)
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-28
/// Description: 校验支付方式是否正确分解到发票上
/// 		如有支付方式金额不为0，说明有异常。
/// Input: payInfo-汇总的支付方式列表
/// Return: 0：正常，非0：异常
/// Debug: w ##class(web.DHCBillCons12).CheckPayInfo("1^^^^^^^430.8")
ClassMethod CheckPayInfo(payInfo As %String) As %String
{
	set rtn=0
	for i=1:1:$l(payInfo,$c(2)) {
		set tmpPayInfo=$p(payInfo,$c(2),i)
		continue:(tmpPayInfo="")
		set payMAmt=$p(tmpPayInfo,"^",8)
		if (+payMAmt'=0) {
			set rtn=143_"^"_"支付方式金额分解到发票异常"
			quit
		}
	}
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-26
/// Description: 把汇总的支付方式分解到单张发票上
/// Input: prtRowID-发票表rowid, payInfo-汇总的支付方式列表，按引用传递
/// Return: 标志(0-成功，非0-失败)_$c(2)_本发票支付方式列表
/// Debug: w ##class(web.DHCBillCons12).SplitInvPayMode(1822,"1^^^^^^^400"_$c(2)_"2^^^^^^^30"_$c(2)_"3^^^^^^^10.8")
ClassMethod SplitInvPayMode(prtRowId As %String, ByRef payInfo As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	ts
	
	//获取本张发票的自费金额
	set selfPayAmt=..GetPatSelfPayAmt(prtRowId)     //自费金额
	set balanceAmt=selfPayAmt                       //定义一个平衡金额，用与拆分
	set hospDr=$p(^DHCINVPRT(prtRowId),"^",39)
	
	//=支付方式id^银行Id^支票号^支付卡(或账户rowid)^支付单位id^支票日期^账户号或银行卡号^支付金额^发票rowid|误差金额!发票rowid|误差金额_$c(2)_...;
	for i=1:1:$l(payInfo,$c(2)) {
		quit:(+balanceAmt=0)    //为0时退出循环
		set tmpPayInfo=$p(payInfo,$c(2),i)
		continue:(tmpPayInfo="")
		set roundErrInfo=$p(tmpPayInfo,"^",9)
		set invRoundErrAmt=+$p(roundErrInfo,(prtRowId_"|"),2)  //前边的正号不能少，此处根据串的拼接规则，使用$p取值，也可以通过循环拆分串取值
		set onePayInfo=tmpPayInfo
		set payMDr=$p(tmpPayInfo,"^",1)
		set payMCode=$p(^CT("CTPM",payMDr),"^",1)
		set payMAmt=$p(tmpPayInfo,"^",8)
		set preSum=$p(tmpPayInfo,"^",10)        //实收
		set backChange=$p(tmpPayInfo,"^",11)    //找零
		if (payMCode="CASH") {
			//更新发票表的分币误差字段
			&SQL(
				UPDATE DHC_INVPRT
				SET PRT_OPPreSum = :preSum, PRT_OPBackChange = :backChange, PRT_OPCRoundErr = :invRoundErrAmt
				WHERE %ID = :prtRowId
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			set balanceAmt=balanceAmt+invRoundErrAmt
			//+2021-11-08 ZhYW 实收、找零只往一张发票上更新
			set $p(tmpPayInfo,"^",10)=""
			set $p(tmpPayInfo,"^",11)=""
		}
		if (balanceAmt>=payMAmt) {
			//患者剩余自费金额大于此支付方式的金额
			set $p(onePayInfo,"^",8)=payMAmt
			set $p(tmpPayInfo,"^",8)=0
			set balanceAmt=balanceAmt-payMAmt
		}else {
			//患者剩余自费金额小于次支付方式的金额
			set $p(onePayInfo,"^",8)=balanceAmt
			set $p(tmpPayInfo,"^",8)=payMAmt-balanceAmt
			set balanceAmt=0
		}
		set $p(payInfo,$c(2),i)=tmpPayInfo
		continue:(+payMAmt=0)    //金额为0的不插入
		set rtn=..InsertInvPayMode(prtRowId, onePayInfo)
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	//验证发票表与支付方式表是否平衡
	set rtn=..CheckInvPayMInfo(prtRowId)
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: Lid
/// CreatDate: 2020-05-26
/// Description: 插入支付方式表
/// Input: prtRowId-发票表rowid, onePayInfo-支付方式信息
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.DHCBillCons12).InsertInvPayMode("3950||4")
ClassMethod InsertInvPayMode(prtRowId As %String, onePayInfo As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	set payMId=$p(onePayInfo,"^",1)
	set payMAmt=$p(onePayInfo,"^",8)
	
	set prtData=$g(^DHCINVPRT(prtRowId))
	set prtUser=$p(prtData,"^",21)
	set prtInitInvDr=$p(prtData,"^",13)
	set prtOldInvDr=$p(prtData,"^",29)
	set sFlag=0    //0-收费，1-退费
	if (prtOldInvDr'="") set sFlag=1
	if (prtInitInvDr'="") set sFlag=1
	
	set currDate=+$h, currTime=$p($h,",",2)
	set myarPayInfo=$p(onePayInfo,"^",1)
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",2)
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",8)
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",3)
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",4)
	set myarPayInfo=myarPayInfo_"^"_""       //DHC_AccPayList表rowid，此处传空，在扣账户金额的方法中再更新。
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",5)
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",6)
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",7)
	set myarPayInfo=myarPayInfo_"^"_currDate
	set myarPayInfo=myarPayInfo_"^"_currTime
	set myarPayInfo=myarPayInfo_"^"_$p(onePayInfo,"^",12)   //->DHC_BillExtTradePay
	set rtn=##class(web.UDHCINVPRTIF).INVPRTPayMode(prtRowId, myarPayInfo, "")
	quit:(+rtn) rtn
	
	set expStr=currDate_"^"_currTime_"^"_prtUser
	set rtn=..InsertOPQFPat(sFlag, prtRowId, payMId, payMAmt, expStr)
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: Lid
/// CreatDate: 2020-05-27
/// Description: 计算误差金额
/// Input: 	prtRowIdStr-发票表rowid串，此次rowid顺序与确认完成接口中rowid串的顺序必须相同。默认都是按rowid排序。
/// 		amt-收现金金额
///         expStr-扩展串(CT_PayMode.RowId)
/// Return: 分币误差后的收现金金额^发票rowid|误差金额|舍入前金额|舍入后金额!发票rowid|误差金额|舍入前金额|舍入后金额
/// Debug: w ##class(web.DHCBillCons12).GetManyInvRoundErrAmt("1822^1823", 0.87, "1")
ClassMethod GetManyInvRoundErrAmt(prtRowIdStr As %String, amt As %String, expStr As %String = "") As %String
{
	;规则：
	;	多张发票：
	;		1.收现金金额小于第一张发票时，只对第一张发票进行分币误差，其他发票不算误差额
	;		2.收现金金额大于第一张发票时，除第一张发票外，第二张发票也要进行分币误差，依次类推，直到剩余现金金额小于第n张发票时
	;要求:
	;	1.多张发票时，发票rowid串的顺序要与确认完成接口中发票rowid串的顺序相同
	;	2.确认完成接口中支付方式列表一定要把现金放到第一位
	
	;测试：
	;	情况一：第一张发票可以放下
	;		 w ##class(web.DHCBillCons12).GetManyInvRoundErrAmt("1822^1823",0.87)
	;	情况二:第一张发票放不下
	;		 w ##class(web.DHCBillCons12).GetManyInvRoundErrAmt("1822^1823",450.83)
	
	set prtRowIdStr=..ValidatePrtRowID(prtRowIdStr)
	
	set invRoundErrStr=""
	set flag=0, balanceAmt=amt, result=0
	for i=1:1:$l(prtRowIdStr,"^") quit:(flag=1)  do
	.set prtRowId=$p(prtRowIdStr,"^",i)
	.quit:(+prtRowId=0)
	.set hospDr=$p(^DHCINVPRT(prtRowId),"^",39)
	.set selfPayAmt=..GetPatSelfPayAmt(prtRowId)  //自费金额
	.set myRoundErrAmt=0
	.if (balanceAmt<=selfPayAmt) do
	..set beforeAmt=balanceAmt
	..set tmpAmt=##class(web.DHCBillConsIF).OPCRound(balanceAmt, hospDr, expStr)
	..set afterAmt=tmpAmt
	..set myRoundErrAmt=tmpAmt-balanceAmt
	..set result=result+tmpAmt
	..set flag=1
	.else  do
	..set balanceAmt=balanceAmt-selfPayAmt
	..set beforeAmt=selfPayAmt
	..set tmpAmt=##class(web.DHCBillConsIF).OPCRound(selfPayAmt, hospDr, expStr)
	..set afterAmt=tmpAmt
	..set myRoundErrAmt=tmpAmt-selfPayAmt
	..set result=result+tmpAmt
	.;
	.quit:(+myRoundErrAmt=0)
	.if (invRoundErrStr="") set invRoundErrStr=prtRowId_"|"_myRoundErrAmt_"|"_beforeAmt_"|"_afterAmt
	.else  set invRoundErrStr=invRoundErrStr_"!"_prtRowId_"|"_myRoundErrAmt_"|"_beforeAmt_"|"_afterAmt
	
	quit result_"^"_invRoundErrStr
}

/// Creator: Lid
/// CreatDate: 2020-05-27
/// Description: 获取发票的自费金额
///  		规则:
///             1.自费金额=自付金额(PRT_PatientShare)-医保报销金额(PRT_YBPaySum)
///             2.医保报销金额可以考虑从发票支付方式表循环获取
/// Input: prtRowIdStr:发票rowId串
/// Return: 自费金额
/// Debug: w ##class(web.DHCBillCons12).GetPatSelfPayAmt(1822)
ClassMethod GetPatSelfPayAmt(prtRowIdStr As %String) As %String
{
	set selfAmtSum=0
	for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set invData=$g(^DHCINVPRT(prtRowId))
		continue:(invData="")
		set patShareAmt=$p(invData,"^",16)       //PRT_PatientShare
		set patShareAmt=$fn(patShareAmt,"",2)
		set insuPayAmt=$p(invData,"^",31)        //PRT_YBPaySum
		set insuPayAmt=$fn(insuPayAmt,"",2)
		set selfPayAmt=patShareAmt-insuPayAmt    //本张发票的自费金额
		set selfAmtSum=selfAmtSum+selfPayAmt
	}
	quit selfAmtSum
}

/// Creator: Lid
/// CreatDate: 2020-05-27
/// Description: 获取发票金额
/// Input: prtRowIdStr:发票rowid串
/// Return: 总金额^折扣金额^记账金额^自付金额^医保支付金额
/// Debug:w ##class(web.DHCBillCons12).GetInvAmtData(1822)
ClassMethod GetInvAmtData(prtRowIdStr As %String) As %String
{
	set (totalSum, discSum, payorSum, patShareSum, insuPaySum)=0
	
	for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set invData=$g(^DHCINVPRT(prtRowId))
		set totalAmt=$p(invData,"^",1)            //PRT_Acount
		set discAmt=$p(invData,"^",7)             //PRT_DiscAmount
		set payorAmt=$p(invData,"^",18)           //PRT_PayorShare
		set patShareAmt=$p(invData,"^",16)        //PRT_PatientShare
		set insuPayAmt=$p(invData,"^",31)         //PRT_YBPaySum
		set totalSum=$i(totalSum, totalAmt)
		set discSum=$i(discSum, discAmt)
		set payorSum=$i(payorSum, payorAmt)
		set patShareSum=$i(patShareSum, patShareAmt)
		set insuPaySum=$i(insuPaySum, insuPayAmt)
	}
	
	set totalSum=$fn(totalSum,"",2)
	set discSum=$fn(discSum,"",2)
	set payorSum=$fn(payorSum,"",2)
	set patShareSum=$fn(patShareSum,"",2)
	set insuPaySum=$fn(insuPaySum,"",2)
	
	set rtn=totalSum_"^"_discSum_"^"_payorSum_"^"_patShareSum_"^"_insuPaySum
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-27
/// Description: 获取发票支付方式金额
/// Input: prtRowIdStr-发票rowid串
/// 		flag:空-全部支付方式(默认)，0-医保支付方式，1-自费支付方式
/// Return: 支付方法ID^支付方式Code^支付方式金额_$c(2)_支付方法ID^支付方式Code^支付方式金额
/// Debug: w ##class(web.DHCBillCons12).GetInvPayMAmtData(1822)
ClassMethod GetInvPayMAmtData(prtRowIdStr As %String, flag As %String = "") As %String
{
	//注意：flag前边不能加正号,加正号就只取医保支付了
	kill aryPayM
	for i=1:1:$l(prtRowIdStr,"^")  do
	.set prtRowId=$p(prtRowIdStr,"^",i)
	.quit:(+prtRowId=0)
	.set sub=0
	.for  set sub=$o(^DHCINVPRT(prtRowId,"P",sub)) quit:(sub="")  do
	..set data=$g(^DHCINVPRT(prtRowId,"P",sub))
	..quit:(data="")
	..set myPayMDr=$p(data,"^",1)
	..set myPayMAmt=$p(data,"^",3)
	..set myPayMAmt=$fn(myPayMAmt,"",2)
	..set selfFlag=$p(data,"^",12)     //IPM_Note3 1-自费支付，空-医保支付方式
	..quit:((flag=1)&&(selfFlag=""))
	..quit:((flag=0)&&(selfFlag=1))
	..set aryPayM(myPayMDr)=+$g(aryPayM(myPayMDr))+myPayMAmt
	
	set rtn=""
	set payMDr=""
	for  set payMDr=$o(aryPayM(payMDr)) quit:(payMDr="")  do
	.set payMAmt=aryPayM(payMDr)
	.set payMCode=$p(^CT("CTPM",payMDr),"^",1)
	.set payMDesc=$p(^CT("CTPM",payMDr),"^",2)
	.set tmp=payMDr_"^"_payMCode_"^"_payMDesc_"^"_payMAmt
	.set rtn=$s((rtn=""):tmp,1:(rtn_$c(2)_tmp))
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-05-27
/// Description: 排序支付方式列表，需要把现金支付放到第一位（主要是考虑一次结算多张发票且多种支付方式的分币误差算法）
/// Input: payInfo：支付方式列表
/// Return:支付方式列表
/// Debug:w ##class(web.DHCBillCons12).SortPayInfo("12^^^^^^^400"_$c(2)_"2^^^^^^^30"_$c(2)_"3^^^^^^^10.8")
ClassMethod SortPayInfo(payInfo As %String) As %String
{
	quit:($l(payInfo,$c(2))=1) payInfo
	
	kill aryPayMSort
	//现只对现金排序，其他支付方式不做要求
	for i=1:1:$l(payInfo,$c(2))  do
	.set tmpPayInfo=$p(payInfo,$c(2),i)
	.quit:(tmpPayInfo="")
	.set payMDr=$p(tmpPayInfo,"^",1)
	.set payMCode=$p(^CT("CTPM",payMDr),"^",1)
	.set sortSub=payMDr       //默认按支付方式表的顺序排序
	.if (payMCode="CASH") set sortSub=-10     //考虑以后rowid可能与排序下标重复，这里使用负数，且预留-1到-9
	.set aryPayMSort(sortSub)=tmpPayInfo
	
	set rtn=""
	set sub=""     //下标有负数，这里一定不能是0
	for  set sub=$o(aryPayMSort(sub)) quit:(sub="")  do
	.set tmp=aryPayMSort(sub)
	.set rtn=$s((rtn=""):tmp,1:(rtn_$c(2)_tmp))
	
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2020-06-10
/// Description: 欠费支付方式结算时，往欠费流水表插入记录
/// Input: payInfo：sFlag：0-收费，1-退费, prtRowId-发票id, payMId:支付方式id, payMAmt：支付金额, expStr：=当前日期^当前时间^收费员Id
/// Return: 0:成功，<>0:失败。非欠费支付方式总是返回0
/// Debug: w ##class(web.DHCBillCons12).InsertOPQFPat()
ClassMethod InsertOPQFPat(sFlag As %String, prtRowId As %String, payMId As %String, payMAmt As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	set currDate=$p(expStr,"^",1)
	set currTime=$p(expStr,"^",2)
	set userId=$p(expStr,"^",3)
	
	set prtData=$g(^DHCINVPRT(prtRowId))
	set patientId=$p(prtData,"^",15)
	set hospId=$p(prtData,"^",39)
	set admStr=..GetAdmByPrtRowId(prtRowId)
	
	set rtn=0
	
	set payMCode=$p(^CT("CTPM",payMId),"^",1)
	quit:(payMCode'="QF") rtn    //非欠费支付方式总是返回0
	
	//+2022-01-12 ZhYW 控制不能以"欠费"支付方式补回
	set rtn=##class(web.DHCOPQFPat).IsQFRestorePrtInvId(prtRowId)
	quit:(+rtn) 122_"^"_"不能使用【欠费】支付方式补回"
	
	//+2021-11-04 ZhYW 配置了欠费结算需担保时，验证担保金额是否足够抵扣
	if (..GetWarrantPayCfg(hospId)=1) {
		set rtn=##class(web.DHCOPQFPat).CheckWarBal(admStr, payMAmt, sFlag)
		quit:(+rtn) 123_"^"_"担保余额不足"
	}
	
	set $p(myQFInfo,"^",1)=admStr		        //QF_Adm
	set $p(myQFInfo,"^",2)=patientId		   	//QF_Papmi_Dr
	set $p(myQFInfo,"^",3)=currDate	          	//QF_Date
	set $p(myQFInfo,"^",4)=currTime	           	//QF_Time
	set $p(myQFInfo,"^",5)=payMAmt		      	//QF_Amount
	set $p(myQFInfo,"^",6)=userId		       	//QF_AddUser
	set $p(myQFInfo,"^",7)=prtRowId            	//QF_Prt_dr
	set $p(myQFInfo,"^",8)=hospId              	//QF_Hosp_DR
	set rtnValue=##class(web.DHCOPQFPat).INSERTOPQFPat(myQFInfo)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: Lid
/// CreatDate: 2020-06-10
/// Description: 获取发票对应得就诊
/// Input: prtRowIdStr：发票id串，以"^"分割
/// Return: adm串，以"^"分割
/// Debug: w ##class(web.DHCBillCons12).GetAdmByPrtRowId(2115)
ClassMethod GetAdmByPrtRowId(prtRowIdStr As %String) As %String
{
	set admStr=""
	for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set billConInv=0
		while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
			set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
			set adm=$p($g(^DHCBCI(billConInv)),"^",3)
			continue:(("^"_admStr_"^")[("^"_adm_"^"))
			set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
		}
	}
	quit admStr
}

/// Creator: ZhYW
/// CreatDate: 2020-06-18
/// Description: 根据发票支付方式判断是否打印发票
///              当且仅当所有支付方式都配置不打印发票时，这张发票不打印
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: prtFlag(=0:打印, =1:不打印)
/// Debug: w ##class(web.DHCBillCons12).CheckPrtFlagByGSPM()
ClassMethod CheckPrtFlagByGSPM(prtRowId As %String) As %String
{
	set hospDR=$p(^DHCINVPRT(prtRowId),"^",39)
	set groupDR=$p(^DHCINVPRT(prtRowId),"^",41)
	
	set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(groupDR, hospDR)
	quit:(+myGSRowID=0) 0
	
	set hasSelfPaym=0
	set flag=1
	set paymSub=""
	while($o(^DHCINVPRT(prtRowId,"P",paymSub),-1)&&(flag=1)) {
		set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub),-1)
		set paymData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
		continue:(paymData="")
		set paymDR=$p(paymData,"^",1)
		set isSelf=$p(paymData,"^",12)
		continue:(+isSelf'=1)    //过滤医保支付方式
		set hasSelfPaym=1
		set myGSPMRowID=$o(^DHCOPGSi("GS",0,"CTPMDR",paymDR,myGSRowID,"PM",0))
		if (+myGSPMRowID=0) {
			set flag=0
			quit
		}
		set myGSPMINVPrtFlag=$p($g(^DHCOPGS("GS",myGSRowID,"PM",myGSPMRowID)),"^",5)
		if (myGSPMINVPrtFlag="Y") {
			set flag=0
			quit
		}
	}
	
	set prtFlag=((hasSelfPaym=1)&&(flag=1))
	
	quit prtFlag
}

/// Creator: ZhYW
/// CreatDate: 2020-08-17
/// Description: 校验结算支付方式是否是配置的支付方式
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospial.RowId, 
/// 	   typeFlag: "DEP"(预交金)
/// 	  			 "FEE"(收费	-- 默认)
/// 				 "REG"(挂号)
/// 				 "REF"(退费)
/// 	   insTypeId:PAC_AdmReason.RowId, payInfo:支付方式串
/// Return: 0:是, 140:否
/// Debug: w ##class(web.DHCBillCons12).CheckPayMode(122, 2, "FEE", 1, "1^2^4"_$c(2)_"5^2^4")
ClassMethod CheckPayMode(groupId As %String, hospId As %String, typeFlag As %String, insTypeId As %String, payInfo As %String) As %String
{
	set rtn=0
	set insTypeCode=$s((+insTypeId'=0):$p($g(^PAC("ADMREA",insTypeId)),"^",1),1:"")
	quit:(insTypeCode=##class(web.DHCBillPilot).#OutAdmReasonCode) rtn
	set payModeStr=##class(web.UDHCOPGSConfig).GetGSPayModeStr(groupId, hospId, typeFlag)
	for i=1:1:$l(payInfo,$c(2)) {
		set onePayInfo=$p(payInfo,$c(2),i)
		continue:(onePayInfo="")
		set paymId=$p(onePayInfo,"^",1)
		continue:((+paymId=0)||(("^"_payModeStr_"^")[("^"_paymId_"^")))
		set rtn=140_"^"_"传入的支付方式未配置"
		quit
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-10-09
/// Description: 将业务表关联到第三方支付订单表
/// Input: prtRowIdStr:DHC_INVPRT.RowId串, sFlag:收退标识(0:收, 1:退)
/// Return: rtn(=0:成功, <>0:失败)
/// Debug: w ##class(web.DHCBillCons12).RelationHISToOrder()
ClassMethod RelationHISToOrder(prtRowIdStr As %String, sFlag As %String) As %String
{
	set rtn=0
	kill orderAry
	for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set oldInvDR=$p($g(^DHCINVPRT(prtRowId)),"^",29)   //PRT_OldINV_DR
		set paymSub=""
		while($o(^DHCINVPRT(prtRowId,"P",paymSub),-1)&&(rtn=0)) {
			set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub),-1)
			set data=$g(^DHCINVPRT(prtRowId,"P",paymSub))
			continue:(data="")
			set isSelf=$p(data,"^",12)
			continue:(+isSelf'=1)    //过滤医保支付方式
			set paymDR=$p(data,"^",1)
			set paymAmt=$p(data,"^",3)     //IPM_Amt
			set hardComFlag=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(paymDR)
			set ETPDR=$p(data,"^",15)
			continue:((+hardComFlag=0)&&(+ETPDR=0))   //过滤非第三方支付
			continue:((+oldInvDR'=0)&&(+ETPDR=0))     //部分退费重收时，如果没有重新支付，则不关联。
			if ((+hardComFlag'=0)&&(+ETPDR=0)) {
				set rtn=143_"^"_"第三方支付，订单表ID不应为空"
				quit
			}
			if ((+hardComFlag=0)&&(+ETPDR'=0)) {
				set rtn=143_"^"_"非第三方支付，订单表ID不应有值"
				quit
			}
			set $li(orderAry(ETPDR),1)=$s(($lg($g(orderAry(ETPDR)),1)=""):prtRowId,1:($lg($g(orderAry(ETPDR)),1)_"!"_prtRowId))
			set $li(orderAry(ETPDR),2)=$lg($g(orderAry(ETPDR)),2)+paymAmt
		}
	}
	quit:(+rtn) rtn
	
	set myETPId=0
	while($o(orderAry(myETPId))) {
		set myETPId=$o(orderAry(myETPId))
		set myData=$g(orderAry(myETPId))
		set myPrtStr=$lg(myData,1)
		set myPayAmt=$lg(myData,2)
		set myETPData=$g(^DHCBILLETP(myETPId))
		//+2022-08-12 ZhYW 验证第三方支付金额和HIS金额
		if (sFlag=0) {
			set myExtAmt=$p(myETPData,"^",4)   //ETP_Ext_Amt
			if (+$fn(myPayAmt,"",2)'=+$fn(myExtAmt,"",2)) {
				set rtn=146_"^"_"HIS金额和第三方支付返回金额不符，HIS金额："_$fn(myPayAmt,"",2)_"，订单金额："_$fn(myExtAmt,"",2)
				quit
			}
		}
		//HIS业务与订单建关联
		set tradeType=$p(myETPData,"^",25)    //ETP_TradeType
		set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).RelationOrderToHIS(myETPId, myPrtStr, tradeType)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
	}
	quit:(+rtn) rtn
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate 2021-11-04
/// Description: 获取欠费结算是否需要担保配置
/// Input: hospId:CT_Hospital.RowId
/// Return: 0:否，1:是
/// Debug: w ##class(web.DHCBillCons12).GetWarrantPayCfg(2)
ClassMethod GetWarrantPayCfg(hospId As %String) As %String
{
	quit ##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.opbill.charge.main.csp", "WARRPAY", "", hospId)
}

/// Creator: ZhYW
/// CreatDate: 2022-08-22
/// Description: 体检代金卡、体检预交金消费
/// Input: prtRowId:DHC_INVPRT.RowId, userId:SS_User.RowId, expStr:安全组Id^登录科室Id
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.DHCBillCons12).InsertAPMInfo(2)
ClassMethod InsertAPMInfo(prtRowId As %String, userId As %String, expStr As %String) As %String
{
	set groupId=$p(expStr,"^",2)     //安全组
	set ctLocId=$p(expStr,"^",3)	 //登录科室
	
	set prtInvData=$g(^DHCINVPRT(prtRowId))
	set patientId=$p(prtInvData,"^",15)
	set patientNo=$p($g(^PAPER(patientId,"PAT",1)),"^",1)  //登记号
	
	set rtn=0
	
	set rtn=$$InvkUpdAPM("TJYJJ")  //体检预交金消费
	quit:(+rtn) rtn
	
	set rtn=$$InvkUpdAPM("TJDJK")  //体检代金卡消费
	quit:(+rtn) rtn
	
	quit rtn
	
InvkUpdAPM(paymCode)
	set paymSubId=##class(web.DHCBillCons12).GetINVPayMIDByCode(prtRowId, paymCode)
	quit:(paymSubId="") rtn       //为空说明没有使用代金卡消费
	
	set invPayMData=$g(^DHCINVPRT(+paymSubId,"P",$p(paymSubId,"||",2)))
	set payAmt=$p(invPayMData,"^",3)
	set cardNo=$p(invPayMData,"^",5)
	set cardNo=$s((paymCode="TJYJJ"):patientNo,1:cardNo)  //体检预缴金时，卡号传登记号
	
	set sessionStr=userId_"^"_groupId_"^"_ctLocId
	set rtn=##class(web.DHCBillCons12).UpdateAPAmount(prtRowId, "", paymCode, payAmt, cardNo, sessionStr)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-08-22
/// Description: 调用体检组接口进行体检代金卡、体检预交金消费
/// Input: oldPrtRowId:DHC_INVPRT.RowId(原结算发票Id), parkPrtRowId:DHC_INVPRT.RowId(退费发票Id), paymCode:CT_PayMode.Code, payAmt:支付金额, cardNo:卡号, sessionStr:操作员Id^安全组Id^登录科室Id
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.DHCBillCons12).UpdateAPAmount()
ClassMethod UpdateAPAmount(oldPrtRowId As %String, parkPrtRowId As %String = "", paymCode As %String, payAmt As %String, cardNo As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)	     //操作员
	set groupId=$p(sessionStr,"^",2)     //安全组
	set ctLocId=$p(sessionStr,"^",3)	 //登录科室

	set rtn=0
	
	set prtInvData=$g(^DHCINVPRT(oldPrtRowId))
	set hospId=$p(prtInvData,"^",39)

	set oldPBRowIDStr=##class(BILL.OP.COM.Method).GetPBRowIDStrByPrtID(oldPrtRowId)    //结算发票对应的账单RowId
	set oldPBRowIDStr=$replace(oldPBRowIDStr,"^","#")
	
	set parkPBRowIDStr=##class(BILL.OP.COM.Method).GetPBRowIDStrByPrtID(parkPrtRowId)  //退费发票对应的账单RowId
	set parkPBRowIDStr=$replace(parkPBRowIDStr,"^","#")
	
	set cardType=$case(paymCode,"TJYJJ":"R","TJDJK":"C",:"")  //卡类型(R:体检预缴金,C:体检代金卡)
	set expStr=userId_"^"_ctLocId_"^"_hospId
	
	set rtnValue=##class(web.DHCPE.CRM.Gateway).UpdateAPAmountNew(cardType, cardNo, payAmt, oldPBRowIDStr, parkPBRowIDStr, expStr)	 //调用体检消费接口
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		set rtn=rtn_"^"_"体检组接口[web.DHCPE.CRM.Gateway||UpdateAPAmountNew("_$lts($lb(cardType, cardNo, payAmt, oldPBRowIDStr, parkPBRowIDStr, expStr))_")]失败:"_rtnValue
		quit rtn
	}

	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-08-22
/// Description: 获取门诊收费发票支付方式RowId
/// Input: prtRowId:DHC_INVPRT.RowId, paymCode:支付方式代码
/// Return: invPayMId:DHC_INVPayMode.RowId
/// Debug: w ##class(web.DHCBillCons12).GetINVPayMIDByCode(3094, "CPP")
ClassMethod GetINVPayMIDByCode(prtRowId As %String, paymCode As %String) As %String
{
	set invPayMId=""
	quit:((prtRowId="")||(paymCode="")) invPayMId
	
	set paymId=$o(^CT("CTPM",0,"Code",$$ALPHAUP^SSUTIL4(paymCode),0))
	quit:(+paymId=0) invPayMId
	
	set invPayMSub=$o(^DHCINVPRTi(0,"PMDR",prtRowId,paymId,"P",0))
	quit:(+invPayMSub=0) invPayMId
	
	set invPayMId=prtRowId_"||"_invPayMSub
	
	quit invPayMId
}

/// Creator: ZhYW
/// CreatDate: 2022-10-19
/// Description: 插入药房中间表
/// Input: prtRowId:DHC_INVPRT.RowId, operate: 操作类型(charge:收费,refund:退费)
/// Return: =0:成功, <>0:失败
/// Debug: w ##class(web.DHCBillCons12).InsertPHARWIN(3094, "charge")
ClassMethod InsertPHARWIN(prtRowId As %String, operate As %String) As %String
{
	set rtn=0
	set stayFlag=$p($g(^DHCINVPRT(prtRowId)),"^",44)   //PRT_StayFlag
	quit:(stayFlag="Y") rtn   //押金模式急诊留观先发药后收费，不需要插中间表
	
	set rtnValue=##class(PHA.FACE.OUT.Com).SavePHARWIN(prtRowId, operate)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) 142_"^"_"药房组接口[PHA.FACE.OUT.Com||SavePHARWIN("_$lts($lb(prtRowId, operate))_")]失败:"_rtnValue
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-10-19
/// Description: 门诊账单及对应医嘱置收费
/// Input: prtRowId:DHC_INVPRT.RowId, userId:SS_User.RowId, updtDate:更新日期, updtTime:更新时间
/// Return: =0:成功, <>0:失败
/// Debug: w ##class(web.DHCBillCons12).UpdateInvConBill(3094, "CPP")
ClassMethod UpdateInvConBill(prtRowId As %String, userId As %String, updtDate As %String = {+$h}, updtTime As %String = {$p($h,",",2)}) As %String
{
	set rtn=0
	set billConInvDR=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInvDR))) {
		set billConInvDR=$o(^DHCBCI(0,"INV",prtRowId,billConInvDR))
		set conData=$g(^DHCBCI(billConInvDR))
		set pb=$p(conData,"^",2)
		set rtn=##class(web.udhcOPBill).Updatearpbl(pb, userId, updtDate, updtTime)
		quit:(+rtn)
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-11-21
/// Description: 获取单张发票允许的最大金额
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: 
/// Others: 通用配置-门诊收费系统-门诊收费-单张发票最大金额设置
/// Debug: w ##class(web.DHCBillCons12).GetSingleInvMaxAmt(238, 2)
ClassMethod GetSingleInvMaxAmt(groupId As %String, hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPChrg.DZFPZDJESZ", "", groupId, hospId, "")
	set amt=##class(%DynamicObject).%FromJSON(jsonStr).ecol1
	quit amt
}

/// Creator: ZhYW
/// CreatDate: 2022-11-29
/// Description: 判断是否需要更新挂号流水表
/// Input: adm:PA_Adm.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCBillCons12).IsNeedToUpdtRegFee(238, 2)
ClassMethod IsNeedToUpdtRegFee(adm As %String) As %String
{
	set rtn=0
	quit:(+adm=0) rtn
	
	set regFeeId=0
	while($o(^User.DHCRegistrationFeeI("ADM",adm,regFeeId))) {
		set regFeeId=$o(^User.DHCRegistrationFeeI("ADM",adm,regFeeId))
		set regFeeData=$g(^User.DHCRegistrationFeeD(regFeeId))
		set prtInvDR=$lg(regFeeData,11)
		continue:(+prtInvDR=0)
		set initInvDR=$p($g(^DHCINVPRT(prtInvDR)),"^",13)
		continue:(+initInvDR'=0)
		continue:($d(^DHCINVPRT(0,"OldINV",prtInvDR)))
		set rtn=1
		quit
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-11-29
/// Description: 判断结算记录在挂号流水表中是否存在
/// Input: adm:PA_Adm.RowId, prtRowId:DHC_INVPRT.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCBillCons12).IsPrtInRegFee(238, 2)
ClassMethod IsPrtInRegFee(adm As %String, prtRowId As %String) As %String
{
	set rtn=0
	quit:(+adm=0) rtn
	
	set regFeeId=0
	while($o(^User.DHCRegistrationFeeI("ADM",adm,regFeeId))) {
		set regFeeId=$o(^User.DHCRegistrationFeeI("ADM",adm,regFeeId))
		set regFeeData=$g(^User.DHCRegistrationFeeD(regFeeId))
		set prtInvDR=$lg(regFeeData,11)
		continue:(prtInvDR'=prtRowId)
		set rtn=1
		quit
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-02-13
/// Description: 获取住院患者是否允许门诊结算配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-门诊收费系统-门诊收费-住院患者是否允许门诊结算
/// Debug: w ##class(web.DHCBillCons12).IsAllowedIPPatChrg(2)
ClassMethod IsAllowedIPPatChrg(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPChrg.ZYHZSFYXMZJS", "", "", hospId, "")
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit:($p(cfgData,"^",2)="") 1   //+2023-05-05 ZhYW 未配置时可以收费
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

}
