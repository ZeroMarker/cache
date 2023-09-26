Import SQLUser

Class web.udhcOPRefEdit1 Extends BILL.COM.Abstract
{

/// 对于退费的统一数据操作?增删改等?同时在类方法中提供事务?
/// 1.写票据负单
/// 2.更新原来的票据
/// 3.同时写负担的票据帐单连接表
/// Input: ULoadLocDR  用户登录的科室
///        RPayModeDR  退费的支付模式
/// Debug: w ##class(web.udhcOPRefEdit1).RefundReceipt("1097","17275","S","1073||7","0.07","239","1","3","3","1","N^N^^^")
ClassMethod RefundReceipt(INVPRTRowid As %String, rUser As %String, sFlag As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String, NewInsType As %String = "", ExpStr As %String = "") As %String
{
	set ^TMP("RefundReceipt")=$lb(INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR, NewInsType, ExpStr)
	
	set $zt="ERROR"
	
	set MulityPayModeFlag=$p(ExpStr,"^",1)

	set rtn=0

    set AdmStayFlag=$p(^DHCINVPRT(INVPRTRowid),"^",44)  //发票上的急诊留观标志
	if ((AdmStayFlag="Y")&&(+NInvPay>0)) {
		//留观病人退费在前台界面只显示退费医嘱，所有RebillFlag传过来值是0，实际上是部分退费,所以需求重新赋值
		//认为留观病人不存在全部退费
		set RebillFlag=1
	}
    
	//Lid 2010-07-07 设置设置作废重打或部分退费标志
	//0:全退, 1:部分退, 2:作废重打
	set refundFlag=0     //默认全退
	if (+RebillFlag=1) {
		set refundFlag=$s((+StopOrdStr=0):2,1:1)
	}
	
	//是否配置打印负票 yyx 2010-09-06
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(ULoadLocDR)
	set myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfig(HospDR)
	set rtn=$p(myBCInfo,"^")
	quit:(+rtn) rtn_"^"_"取门诊基本配置信息失败"
	
	set RefundInvFlag=$p(myBCInfo,"^",31)     //为Y，则需要打印负票，否则不打印负票
	set RefundInvFlag=$s(((sFlag="S")&&(RefundInvFlag="Y")):"Y",1:"N")
	
	set PrtData=$g(^DHCINVPRT(INVPRTRowid))
	set myINVNo=$p(PrtData,"^",14)
	set myPINVFlag=$s((myINVNo'=""):"Y",1:$p(ExpStr,"^",2))	  //是否需要发票(Y:是,N:否)
	//验证票据
	set PrtInsType=$p(PrtData,"^",9)
	set myFairType=$p(PrtData,"^",34)
	set myExpStr=myFairType_"^"_PrtInsType_"^"_HospDR
	set myINVNoInfo=##class(web.udhcOPBillIF).ReadReceiptNO(rUser, gloc, myExpStr)
	set ReceiptNo=$p(myINVNoInfo,"^",2)
	if ((ReceiptNo="")&&(+RebillFlag=1)&&(myPINVFlag="Y")) {
		quit 109_"^"_"没有可用发票，请先领取"
	}
	
	//验证发票有了变化
	set rtn=##class(web.UDHCOEORDOPIF).CheckOEORDChangeStatus(INVPRTRowid, StopOrdStr, "")
	quit:(+rtn) rtn
	
	ts
		
	//+2019-05-09 ZhYW 自动撤销集中打印发票
	set accPInvDR=$p(ExpStr,"^",5)
	if (+accPInvDR'=0) {
		set rtn=##class(web.udhcOPRefEditIF).WriteOffAPI(accPInvDR, rUser)
		if (+rtn) tro  quit rtn   //撤消失败退出
	}
	
	//更新原来的票据
	set rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid, rUser, sFlag)
	if (+rtn) tro  quit rtn
	
	//写票据负单
	set myCurDate=+$h
	set myCurTime=$p($h,",",2)
	set myExpStr=gloc_"^"_ULoadLocDR_"^"_HospDR_"^"_RefundInvFlag_"^"_myPINVFlag
	set rtnValue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, rUser, sFlag, myCurDate, myCurTime, myExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set strikePrtRowId=$p(rtnValue,"^",2)   //票据负单
	
	set admStr=""
	set billConInv=0
	while($o(^DHCBCI(0,"INV",INVPRTRowid,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",INVPRTRowid,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		set adm=$p(conData,"^",3)
		set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
		set rtnValue=##class(web.UDHCJFPBCANCEL).PBCancel(adm, pb, rUser)    //写负账单
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set refBillRowId=$p(rtnValue,"^",2)   //负账单RowId
		//写发票和账单连接表
		&SQL(
			INSERT INTO DHC_BillConINV (
				DHCBCI_ADMDR, DHCBCI_INVDR, DHCBCI_PatBillDR
			)
		    VALUES (
		    	:adm, :strikePrtRowId, :refBillRowId
		    )
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	//ZhYW 2022-03-24 插入发票对应的门诊门诊子分类金额和会计子分类金额
	set rtn=##class(BILL.OP.BL.SubCateFee).SaveCateFee(strikePrtRowId)
	if (+rtn) tro  quit rtn
	
	//写负单的支付方式
	set myDTStr=myCurDate_"^"_myCurTime_"^"_refundFlag_"^"_MulityPayModeFlag
	set rtnValue=##class(web.UDHCINVPRT).INVPRTPayModeCancel(INVPRTRowid, strikePrtRowId, ULoadLocDR, RPayModeDR, rUser, myDTStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	//停止医嘱
	set rtn=##class(web.UDHCOEORDOP).UpdateOrderStat(StopOrdStr, INVPRTRowid, rUser)
	if (+rtn) tro  quit rtn
	
	//2021-07-21 Lid 更新退费申请表退费状态
	set rtn=##class(web.DHCOPBillOERefundQty).UpdatePartRefundStauts(StopOrdStr, rUser, "")
	if (+rtn) tro  quit rtn
	
	//插入药房中间表
	set rtn=##class(web.DHCBillCons12).InsertPHARWIN(INVPRTRowid, "refund")
	if (+rtn) tro  quit rtn
	
	//获取负单的支付模式=新正单的支付模式
	set myPayinfo=##class(web.UDHCINVPRT).ReadINVPayMode(strikePrtRowId)
	set Payinfo=$p(myPayinfo,$c(2),1)
    if (+RPayModeDR'=0) set $p(Payinfo,"^",1)=RPayModeDR        //update by zhl  20110830   
	set myAccRowID=$p($p(myPayinfo,$c(2),2),"||",1)
	
	//重新计费
	set newPrtRowId=""   //新票RowId
	if (+RebillFlag=1) {
		//退费中,RebillFlag=1 生成新的票据
		set insTypeId=..GetPrtOrdInsTypeId(INVPRTRowid)   //获取医嘱费别
		if (insTypeId="") set insTypeId=##class(web.DHCBillCons).ReadDefInsType(HospDR)
		//求出不在票据中,未结算的医嘱RowID
		//2005-11-15增加严格?把非本票据内的OEORI_RowID都加到字符串中?
		set unordrid=##class(web.UDHCOEORDOP).ReadUnINVOrdStr(INVPRTRowid)
		set actualMoney=""      //实付
		set changeAmt=""        //找零
		set roundErr=0
		set LocalIPAddress=$system.Process.ClientIPAddress()
		set myExpStr=gloc_"^"_ULoadLocDR_"^"_myAccRowID_"^"_myPINVFlag_"^"_myFairType
		set myExpStr=myExpStr_"^"_actualMoney_"^"_changeAmt_"^"_roundErr_"^"_NewInsType_"^"_LocalIPAddress_"^"_AdmStayFlag
		//再收
		set rtnValue=##class(web.DHCOPINVCons).OPBillCharge(admStr, rUser, unordrid, insTypeId, NInvPay, Payinfo, gloc, 1, INVPRTRowid, 0, myExpStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set newPrtRowId=$p(rtnValue,"^",2)
		/*
		set rtnValue=##class(web.DHCOPBillOERefundQty).UpdateRefStauts(StopOrdStr, rUser, newPrtRowId, "")    //Lid 2012-08-23 更新部分退费状态
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		*/
	}
	
	//2022-03-25 ZhYW 门诊退费时记录需要重新收费的医嘱，方便在收费界面再收
	set rtn=##class(BILL.OP.BL.ReChgOrder).SaveReChgOrder(INVPRTRowid, strikePrtRowId, newPrtRowId, StopOrdStr, rUser)
	if (+rtn) tro  quit rtn
	
	//+2019-10-17 TianZJ 客户套餐退费
	if (StopOrdStr'="") {
		set rtn=##class(BILL.PKG.BL.PatPackage).RefundPatKage(StopOrdStr, rUser)
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc
	
	//+2019-08-01 ZhYW 退费服务接口
	if (StopOrdStr'="") {
		set SendExpStr=rUser
		job ##class(web.DHCOPBillSendService).SendOPRefundInfo(StopOrdStr, SendExpStr)
	}
	
	quit rtn_"^"_newPrtRowId_"^"_strikePrtRowId_"^"_RefundInvFlag

ERROR
	quit ..AppException()
}

/// 专门用来卡支付的退费
/// 输入参数：APIRowID, 现在的支付方式RPayModeDR, ULoadLocDR, gloc, rUser,
/// PRTOrdStr=INVPRTRowid_StopOrdStr_NInvPay_RebillFlag
/// RefPaySum界面上显示的退款金额   正数表示退款   负数表示收款
/// Debug: w ##class(web.udhcOPRefEdit1).AccPayINVRefund("22530","234214"_$c(3,3)_"1"_$c(3)_"0","5","A","122","238","3","0.00","1","^^^^^0")
ClassMethod AccPayINVRefund(APIRowID As %String, PRTOrdStr As %String, rUser As %String, sFlag As %String, gloc As %String, ULoadLocDR As %String, RPayModeDR As %String, RefPaySum As %String, RebillFlag As %String, ExpStr As %String = "") As %String
{
	set ^TMP("AccPayINVRefund")=$lb(APIRowID, PRTOrdStr, rUser, sFlag, gloc, ULoadLocDR, RPayModeDR, RefPaySum, RebillFlag, ExpStr)
	//quit 0
	set $zt="ERROR"
	
	set NewInsType=$p(ExpStr,"^",7)   //+2019-05-10 ZhYW 新费别
	
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(ULoadLocDR)
	set PrtInsType=$p(^DHCINVPRTAP(APIRowID),"^",31)          //API_InsType_DR
	set StayFlag=$p(^DHCINVPRTAP(APIRowID),"^",29)            //API_StayFlag
	set myFairType="F"
	set myExpStr=myFairType_"^"_PrtInsType_"^"_HospDR
	set ReceiptNo=##class(web.udhcOPBillIF).ReadReceiptNO(rUser, "", myExpStr)
	if ((ReceiptNo="")&&(+RebillFlag=1)){
		quit 109_"^"_"没有可用发票，请先领取"
	}
	
	ts
	
	//1.作废DHC_INVPRT 表中的记录
	//2.作废DHC_AccPayINV表
	//3.写新的DHC_AccPayINV表
	//Lid 2011-04-02 设置设置作废重打或部分退费标志
	//0:全退, 1:部分退, 2:作废重打
	if (+RebillFlag=1) {
		set refundFlag=2
		set tmpInvCount=$l(PRTOrdStr,$c(2))
		for i=1:1:tmpInvCount {
			set singleInvStopOrdInfo=$p(PRTOrdStr,$c(2),i)
			set stopOrdStr=$p(singleInvStopOrdInfo,$c(3),2)
			if (+stopOrdStr'=0) {
				set refundFlag=1
				quit
			}
		}
	}else {
		set refundFlag=0
	}
	
	//2017-09-20 ZhYW 结算实时医保分解的, 不往账户返钱
	set OldAutoFlag=$p(^DHCINVPRTAP(APIRowID),"^",25)
	set NewAutoFlag=OldAutoFlag
	if (+NewInsType=+PrtInsType) {
		set NewInsType=""
	}
	set NewAdmSource=$s((+NewInsType'=0):$p(^PAC("ADMREA",NewInsType),"^",9),1:"")
	if (+NewAdmSource>0) {
		set NewAutoFlag=1
	}
	
	set myNewAccRIDStr=""
	set myAPIStr=""
 	
	set myTFRIDSTR=""
	set myNPRTRStr=""

	set rtn=0
	
	set mylen=$l(PRTOrdStr,$c(2))
	for i=1:1:mylen {
		set myPrtInfo=$p(PRTOrdStr,$c(2),i)
		set myINVPRTRowid=$p(myPrtInfo,$c(3),1)				//OldPrtRowID
		set myStopOrdStr=$p(myPrtInfo,$c(3),2)				//需要退费的医嘱串
		if (myStopOrdStr="") {
			set myAPIStr=myAPIStr_myINVPRTRowid_"^"
			set myNPRTRStr=myNPRTRStr_myINVPRTRowid_"^"			//不用退费的DHC_INVPRT串
			continue                                            //不退费的小票，退出
		}
		//获取参与退费小票RowID
		set myTFRIDSTR=myTFRIDSTR_myINVPRTRowid_"^"
		set myRebillFlag=$p(myPrtInfo,$c(3),3)				  //部分退费标志
		set myPatPaySum=$p(^DHCINVPRT(myINVPRTRowid),"^",16)
		set myNInvPay=$p(myPrtInfo,$c(3),4)					  //新票据的支付额
		set myNInvPay=myPatPaySum-myNInvPay
		set rtnValue=..RefundSinglePRT(myINVPRTRowid, rUser, myStopOrdStr, myNInvPay, gloc, myRebillFlag, ULoadLocDR, RPayModeDR)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set myNewPrtRowID=$p(rtnValue,"^",2)
		if (myNewPrtRowID'="") {
			set myNewAccRIDStr=myNewAccRIDStr_myNewPrtRowID_"^"
		}
	}
	if (+rtn) tro  quit rtn
	
	set myAPIStr=myAPIStr_"^"_myNewAccRIDStr
	
	//按照帐户直接退钱；放到退费字段中
	//退费方式: 卡帐户
	//hujunbin 2014-12-05 添加扩展串
	set rtn=##class(web.UDHCAccPrtPayFoot).CancleAPayINV(APIRowID, rUser, sFlag, myTFRIDSTR, myNPRTRStr, ExpStr)
	if (+rtn) tro  quit rtn
	
	set myTMPGID=$i(^DHCTMPACCColPRT)
	
	//如果不是全部退，则生成新的发票
	set myAPINRowID=""    //新集中打印发票RowId
	if (+RebillFlag=1) {
		set myExpStr=ULoadLocDR_"^"_gloc_"^"_HospDR_"^"_APIRowID
		set myExpStr=myExpStr_"^"_StayFlag_"^"_NewAutoFlag_"^"_NewInsType
		set rtnValue=##class(web.UDHCAccPrtPayFoot).ParPrtToAPINV(myAPIStr, myTMPGID, myExpStr)
		set rtn=$p(rtnValue,$c(2),1)
		if (+rtn) tro  quit rtn
		set myAPIInfo=$p(rtnValue,$c(2),2)
		//生成新的发票
		set myAccDR=$p(^DHCINVPRTAP(APIRowID),"^",12)
		set myPAPMIDR=$p(^DHCINVPRTAP(APIRowID),"^",11)
		set rtnValue=##class(web.UDHCAccPrtPayFoot).AccINVPayInsert(myAPIInfo, rUser, myAccDR, myPAPMIDR, myExpStr)
		set rtn=+$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set myAPINRowID=$p(rtnValue,"^",2)    //一张发票作废一定出来一张发票
	}
	
	//删除Global
	do ##class(web.UDHCACINVColPrt).KillINVTMP(myTMPGID)

	//为了医保提供接口
	set myTMPGID=""
	set myAconInvStr=""
	if (myAPINRowID'="") {
		//查看废票是否是医保发票
		set myInsDivDR=$p($g(^DHCINVPRTAP(+APIRowID)),"^",19)			//API_InsDiv_DR
		if ((+myInsDivDR'=0)||(+NewAdmSource'=0)) {
			set myAPIAmount=$p($g(^DHCINVPRTAP(+myAPINRowID)),"^",13)
			set myINSTypeDR=$p($g(^DHCINVPRTAP(+myAPINRowID)),"^",31)           //API_InsType_DR
			set myTMPGID=$i(^DHCTMPACCColPRT)
			if (+NewInsType'=0) {      //+2019-05-10 ZhYW
				merge ^DHCTMPACCColPRT("IP",myTMPGID,NewInsType)=^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR)
				kill ^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR)
			}
			set myACPRowID=0
			while($o(^DHCINVPRTCAPi(0,"APINVDR",myAPINRowID,myACPRowID))) {
				set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",myAPINRowID,myACPRowID))
				set myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
				set ^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR,1,"PrtRowID",myPRTRowID)=myPRTRowID
				set ^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR,1,"APIRowID")=myAPINRowID
				set ^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR,1,"PatPaySum")=myAPIAmount
				set myAconInvStr=$s((myAconInvStr=""):myPRTRowID,1:(myAconInvStr_"^"_myPRTRowID))
			}
		}
	}
	
	if ($tl>0) tc

	quit rtn_"^"_myAPINRowID_"^"_myTMPGID_"^"_myAconInvStr

ERROR
	quit ..AppException()
}

/// 作废一张单个的INVPRT记录
ClassMethod RefundSinglePRT(INVPRTRowid As %String, rUser As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String) As %String
{
	set $zt="ERROR"
	
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(ULoadLocDR)
	
	set rtn=0
	set myCurDate=+$h
	set myCurTime=$p($h,",",2)
	
	set PrtData=$g(^DHCINVPRT(INVPRTRowid))
	set reportsDR=$p(PrtData,"^",6)
	set userDR=$p(PrtData,"^",21)
	set sFlag=$s(((+reportsDR=0)&&(+userDR=+rUser)):"A",1:"S")
	set AdmStayFlag=$p(PrtData,"^",44)  //发票上的急诊留观标志
	
	//更新原来的票据
	set rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid, rUser, sFlag)
	if (+rtn) quit rtn
	
	//写票据负单
	set RefundInvFlag="N"
	set myPINVFlag="N"
	set myExpStr=gloc_"^"_ULoadLocDR_"^"_HospDR_"^"_RefundInvFlag_"^"_myPINVFlag
	set rtnValue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, rUser, sFlag, myCurDate, myCurTime, myExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) quit rtn
	set strikePrtRowId=$p(rtnValue,"^",2)
	
	//写负帐单
	set admStr=""
	set billConInv=0
	while($o(^DHCBCI(0,"INV",INVPRTRowid,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",INVPRTRowid,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		set adm=$p(conData,"^",3)
		set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
		set rtnValue=##class(web.UDHCJFPBCANCEL).PBCancel(adm,  pb, rUser)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set refBillRowId=$p(rtnValue,"^",2)    //负账单RowId
		//写发票和账单连接表
		&SQL(
			INSERT INTO DHC_BillConINV (
				DHCBCI_ADMDR, DHCBCI_INVDR, DHCBCI_PatBillDR
			)
		    VALUES (
		    	:adm, :strikePrtRowId, :refBillRowId
		    )
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) quit rtn
	
	//ZhYW 2022-03-24 插入发票对应的门诊门诊子分类金额和会计子分类金额
	set rtn=##class(BILL.OP.BL.SubCateFee).SaveCateFee(strikePrtRowId)
	if (+rtn) quit rtn
	
	//写负单的支付方式
	set myDTStr=myCurDate_"^"_myCurTime
	set rtnValue=##class(web.UDHCINVPRT).INVPRTPayModeCancel(INVPRTRowid, strikePrtRowId, ULoadLocDR, RPayModeDR, rUser, myDTStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) quit rtnValue
	
	//停止医嘱
	set rtn=##class(web.UDHCOEORDOP).UpdateOrderStat(StopOrdStr, INVPRTRowid, rUser)
	if (+rtn) quit rtn
	
	//2021-07-21 Lid 更新退费申请表退费状态
	set rtn=##class(web.DHCOPBillOERefundQty).UpdatePartRefundStauts(StopOrdStr, rUser, "")
	if (+rtn) quit rtn
	
	////插入药房中间表
	set rtn=##class(web.DHCBillCons12).InsertPHARWIN(INVPRTRowid, "refund")
	if (+rtn) quit rtn
	
	//获取原来的支付方式
	//获取负单的支付模式=新正单的支付模式
	set myPayinfo=##class(web.UDHCINVPRT).ReadINVPayMode(strikePrtRowId)
	set Payinfo=$p(myPayinfo,$c(2),1)
	set myAccRowID=$p($p(myPayinfo,$c(2),2),"||",1)
	
	//重新计费
	set newPrtRowId=""   //新票RowId
	if (+RebillFlag=1) {
		//退费中,=1 生成新的票据
		set insTypeId=..GetPrtOrdInsTypeId(INVPRTRowid)    //获取医嘱费别
		if (insTypeId="") set insTypeId=##class(web.DHCBillCons).ReadDefInsType(HospDR)
		//求出不在票据中,未结算的医嘱RowID
		//2005-11-15增加严格?把非本票据内的OEORI_RowID都加到字符串中?
		set unordrid=##class(web.UDHCOEORDOP).ReadUnINVOrdStr(INVPRTRowid)
		set actualMoney=""      //实付
		set changeAmt=""        //找零
		set roundErr=0
		set myPINVFlag="N"     //此处这个值必须为"N"
		set NewInsType=""
		set LocalIPAddress=$system.Process.ClientIPAddress()
		set myExpStr=gloc_"^"_ULoadLocDR_"^"_myAccRowID_"^"_myPINVFlag_"^F"
		set myExpStr=myExpStr_"^"_actualMoney_"^"_changeAmt_"^"_roundErr_"^"_NewInsType_"^"_LocalIPAddress_"^"_AdmStayFlag
		set rtnValue=##class(web.DHCOPINVCons).OPBillCharge(admStr, rUser, unordrid, insTypeId, NInvPay, Payinfo, gloc, 1, INVPRTRowid, 0, myExpStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
		set newPrtRowId=$p(rtnValue,"^",2)
		
		//Lid 2012-04-20 确认完成
		set myPayInfo=##class(web.DHCBillConsIF).GetNewInvPayMList(INVPRTRowid, strikePrtRowId, newPrtRowId, "")
		set rtnValue=##class(web.DHCBillConsIF).CompleteCharge(6, rUser, insTypeId, newPrtRowId, 1, INVPRTRowid, myExpStr, myPayInfo)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
		/*
		set rtn=##class(web.DHCOPBillOERefundQty).UpdateRefStauts(StopOrdStr, rUser, newPrtRowId, "")  //Lid 2012-08-23 更新部分退费状态
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
		*/
	}
	
	//+2019-10-17 TianZJ 客户套餐退费
	if (StopOrdStr'="") {
		set rtn=##class(BILL.PKG.BL.PatPackage).RefundPatKage(StopOrdStr, rUser)
		if (+rtn) quit rtn
	}
	
	//+2019-08-01 ZhYW 退费服务接口
	if (StopOrdStr'="") {
		set SendExpStr=rUser
		job ##class(web.DHCOPBillSendService).SendOPRefundInfo(StopOrdStr, SendExpStr)
	}
	
	quit rtn_"^"_newPrtRowId_"^"_strikePrtRowId

ERROR
	quit ..AppException()
}

/// 取消错误的作废发票
/// w ##class(web.udhcOPRefEdit1).CancleRefundINVPRT()
ClassMethod CancleRefundINVPRT(INVPRTRowid As %String, rUser As %String, gloc As %String, ULoadLocDR As %String) As %String
{
	set $zt="ERROR"
	
	set myINVFlag=$p(^DHCINVPRT(INVPRTRowid),"^",8)
	quit:(myINVFlag="N") 117
	
	set myRefundRowID=$o(^DHCINVPRT(0,"InitInvDR",INVPRTRowid,0))
	quit:(myRefundRowID="") 115
	
	set myHandFlag=$p(^DHCINVPRT(myRefundRowID),"^",10)
	set myRepHandStatus=$p(^DHCINVPRT(myRefundRowID),"^",61)
	quit:(myHandFlag="Y")&&(myRepHandStatus="N") 116

	set myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)
	set myPINVFlag=$s((myINVNo'=""):"Y",1:"")   //需要发票的支持
	
	ts
	
	set rtn=0
	
	set myCurDate=+$h
	set myCurTime=$p($h,",",2)
	
	//更新原来的票据
	set mysFlag="N"
	set rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid, rUser, mysFlag)
	if (+rtn) tro  quit rtn
	
	//撤销对账单的作废
	set billConInv=0
	while($o(^DHCBCI(0,"INV",INVPRTRowid,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",INVPRTRowid,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		&SQL(
			UPDATE DHC_PatientBill
			SET PB_RefundFlag = NULL
			WHERE %ID = :pb
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	//撤销对账单的作废
	set rtn=##class(web.UDHCOEORDOPIF).CancleStopOrdItemStatus(INVPRTRowid, "")
	if (+rtn) tro  quit rtn
	
	&SQL(DELETE FROM DHC_INVPRT WHERE %ID = :myRefundRowID)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	set myRefBCIRowID=0
	while($o(^DHCBCI(0,"INV",myRefundRowID,myRefBCIRowID))) {
		set myRefBCIRowID=$o(^DHCBCI(0,"INV",myRefundRowID,myRefBCIRowID))
		set myRefPBRowID=$p(^DHCBCI(myRefBCIRowID),"^",2)
		&SQL(DELETE FROM DHC_PatientBill WHERE %ID = :myRefPBRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		&SQL(DELETE FROM DHC_BillConINV WHERE %ID = :myRefBCIRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	set myNewINVRowID=$o(^DHCINVPRT(0,"OldINV",INVPRTRowid,0))
	if (myNewINVRowID'="") {
		set rtn=##class(web.UDHCINVPRT).CancleNewPRTINVStatus(myNewINVRowID)
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: zhl
/// CreatDate: 2014-02-27
/// Description: 集中打印发票补调医保接口需补调时使用，给医保生成临时数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.udhcOPRefEdit1).BuildInsuTmp(184, 4)
ClassMethod BuildInsuTmp(AccPInvID As %String, InsTypeID As %String) As %String
{
	set myTMPGID=""
	quit:((+AccPInvID=0)||(+InsTypeID=0)) myTMPGID
	
	set PatPaySum=$p($g(^DHCINVPRTAP(AccPInvID)),"^",13)
	set myTMPGID=$i(^DHCTMPACCColPRT)
	if (InsTypeID="") {
		set InsTypeID=$p($g(^DHCINVPRTAP(AccPInvID)),"^",31)
	}
	set ^DHCTMPACCColPRT("IP",myTMPGID,InsTypeID,1,"APIRowID")=AccPInvID
	set ^DHCTMPACCColPRT("IP",myTMPGID,InsTypeID,1,"PatPaySum")=PatPaySum
	
	set myACPRowID=0
	while($o(^DHCINVPRTCAPi(0,"APINVDR",AccPInvID,myACPRowID))) {
		set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",AccPInvID,myACPRowID))
		set myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
		set ^DHCTMPACCColPRT("IP",myTMPGID,InsTypeID,1,"PrtRowID",myPRTRowID)=myPRTRowID
	}

	quit myTMPGID
}

/// Lid
/// 2016-01-21
/// 根据发票RowId获取医保结算指针
ClassMethod GetInsDivDrByPrtRowid(prtRowId As %String) As %String
{
	quit:(+prtRowId=0) ""
	set insuDivDR=$p($g(^DHCINVPRT(prtRowId)),"^",30)     //PRT_InsDiv_DR	
	quit insuDivDR
}

/// Creator: ZhYW
/// CreatDate: 2019-04-29
/// Modify: 2022-11-18 ZhYW
/// Description: 过号重打
/// Input: invRowId: 发票rowid
///        invFlag: (API:集中打印发票, PRT:门诊结算发票)
/// 	   sessionStr: 扩展串 (格式：userId^groupId^ctLocId^hospId)
/// Return: 
/// Other: 
/// Debug: w ##class(web.udhcOPRefEdit1).PassNoRePrint("6361","PRT","17275^239^3^2^20")
ClassMethod PassNoRePrint(invRowId As %String, invFlag As %String, sessionStr As %String) As %String
{
	set ^TMP("PassNoRePrint")=$lb(invRowId, invFlag, sessionStr)

	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set rtn=0
	if ((+invRowId=0)||(invFlag="")) {
		quit -1_"^"_"参数错误"
	}
	
	if (invFlag="API") {
		set logDesc="跳号记录：集中打印发票ID："_invRowId
		set fairType="F"
		set accPInvData=$g(^DHCINVPRTAP(invRowId))
		set prtFlag=$p(accPInvData,"^",2)           //API_Flag
		set userDR=$p(accPInvData,"^",5)
		set reportsDR=$p(accPInvData,"^",20)       //API_INVRep_DR
		set prtInvNo=$p(accPInvData,"^",6)         //API_INVNo
		set insTypeDR=$p(accPInvData,"^",31)       //API_InsType_DR
	}else {
		set logDesc="跳号记录：结算发票ID："_invRowId
		set prtInvData=$g(^DHCINVPRT(invRowId))
		set prtFlag=$p(prtInvData,"^",8)        //PRT_Flag
		set reportsDR=$p(prtInvData,"^",6)      //PRT_DHCINVPRTR_DR
	    set userDR=$p(prtInvData,"^",21)
		set prtInvNo=$p(prtInvData,"^",14)      //PRT_inv
		set insTypeDR=$p(prtInvData,"^",9)      //PRT_InsType_DR
		set fairType=$p(prtInvData,"^",34)
	}
	if (prtInvNo="") quit -1_"^"_"没有打印发票，不能过号重打"
	if (prtFlag'="N") tro  quit -1_"^"_"已退费发票，不能过号重打"
	if (userDR'=userId) quit -1_"^"_"非您本人打印的发票，不能过号重打"
	if (+reportsDR'=0) quit -1_"^"_"已做日结的发票，不能过号重打"
	
	set expStr=fairType_"^"_insTypeDR_"^"_hospId
	set myReceipStr=##class(web.udhcOPBillIF).ReadReceiptNO(userId, $s((invFlag="API"):"",1:groupId), expStr)
	set rtn=$p(myReceipStr,"^",1)
	quit:(+rtn) +rtn_"^"_"您没有可用票据，不能过号重打"
	set receiptNo=$p(myReceipStr,"^",2)
	set receiptId=$p(myReceipStr,"^",3)
	set receiptTitle=$p(myReceipStr,"^",5)
	
	set invExtType=$s((invFlag="API"):"OS",1:"O")
	set invExtId=$o(^BILL.INV.PrtExtI("TypeInvDR",invExtType,invRowId,0))
	quit:(+invExtId=0) -1_"^"_"发票扩展表记录不存在，不能过号重打"

	set invoiceId=$lg(^BILL.INV.PrtExtD(invExtId),15)
	quit:(+invoiceId=0) -1_"^"_"发票发放表记录不存在，不能过号重打"
	set invTitle=$p($g(^DHCINVOICE(invoiceId)),"^",16)
	
	ts

	set voidReason="过号重打发票系统自动跳号，"_logDesc
	&SQL(
		INSERT INTO DHC_VoidInv (
			VOI_InvNo, VOI_User_DR, VOI_Reason, VOI_Type, VOI_Hosp_DR
		)
		VALUES (
			:prtInvNo, :userId, :voidReason, 'OP', :hospId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	set voidId=$g(%ROWID)

	set dto=##class(BILL.INV.DTO.Entity.PrtExt).%New()
	set dto.InvType="OT"
	set dto.InvDR=voidId
	set dto.BatchNo=invTitle
	set dto.InvNo=$e(prtInvNo,$l(invTitle)+1,*)
	set dto.PAPMIDR=""
	set dto.Payer=""
	set dto.PayerIdentifier=""
	set dto.UserDR=userId
	set dto.Reviewer=""
	set dto.InvoiceDR=invoiceId
	set rtn=##class(BILL.INV.BL.PrtExt).Save(dto)
	if (+rtn) tro  quit rtn

	set rtn=##class(web.udhcOPBill).UpdateReceipNO(userId, (+receiptNo+1), $s((invFlag="API"):"",1:groupId), fairType, insTypeDR, hospId)
	if (+rtn) tro  quit rtn

	//更新业务表发票号
	set invNo=receiptTitle_receiptNo
	if (invFlag="API") {
		&SQL(
			UPDATE DHC_AccPayINV
			SET API_INVNo = :invNo
			WHERE %ID = :invRowId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}else {
		&SQL(
			UPDATE DHC_INVPRT
			SET PRT_inv = :invNo
			WHERE %ID = :invRowId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}

	//更新发票扩展表
	&SQL(
		UPDATE BILL_INV.PrtExt
		SET BatchNo = :receiptTitle, InvNo = :receiptNo, BatchInvNo = :invNo, InvoiceDR = :receiptId
		WHERE %ID = :invExtId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)

	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: Lid
/// CreatDate: 2020-06-02
/// Description: 获取部分退费新发票的支付方式信息
/// Input: oldPrtRowId: 原发票rowid
///        strikeRowId: 负票rowid
///        prtRowId: 新票rowid
///        refundPayMode: 退费界面选择的退费支付方式，默认为空时取负票的支付方式
/// Return: 支付方式列表
/// Debug: w ##class(web.udhcOPRefEdit1).GetNewInvPayMList("8478","8479","8480","2")
ClassMethod GetNewInvPayMList(oldPrtRowId As %String, strikeRowId As %String, prtRowId As %String, refundPayMode As %String = "") As %String
{
	set ^TMP("GetNewInvPayMList")=$lb(oldPrtRowId, strikeRowId, prtRowId, refundPayMode)
	
	set payMList=""
	
	//取新发票的自费金额
	set patSelfPayAmt=##class(web.DHCBillConsIF).GetPatSelfPayAmt(prtRowId)
	
	set myPayInfo="", onePayInfo=""
	//取原发票的自费支付方式
	set payInfoRtn=##class(web.DHCBillConsIF).ReadINVPayModeNew(oldPrtRowId)   //自费支付方式信息串
	if ($l(payInfoRtn,$c(3))>1) {
		//多种支付方式
		//需要把自费金额拆分到发票上
		set payMList=..SplitAmtToPayMode(prtRowId, patSelfPayAmt, payInfoRtn)
	}else {
		//单种支付方式
		//？？此处回避了一个再收支付方式金额大于原支付金额的情况，以后再做考虑
		set onePayInfo=##class(web.DHCBillConsIF).ReadINVPayModeNew(strikeRowId)
		if (refundPayMode'="") {
			set $p(onePayInfo,"^",1)=refundPayMode
		}
		set invRoundErrDetails=""
		set refundPayMId=$p(onePayInfo,"^",1)
		set refundPayMCode=$p($g(^CT("CTPM",refundPayMId)),"^",1)
		if (refundPayMCode="CASH") {
			//计算分币误差
			set invRoundInfo=##class(web.DHCBillConsIF).GetManyInvRoundErrAmt(prtRowId, patSelfPayAmt, refundPayMId)
			//分币误差后的收现金金额^发票rowid|误差金额|舍入前金额|舍入后金额!发票rowid|误差金额|舍入前金额|舍入后金额
			set patSelfPayAmt=$p(invRoundInfo,"^",1)
			set invRoundErrDetails=$p(invRoundInfo,"^",2)
		}
		set $p(onePayInfo,"^",8)=patSelfPayAmt
		set $p(onePayInfo,"^",9)=invRoundErrDetails
		set payMList=onePayInfo
	}
	
	quit payMList
}

/// Creator: Lid
/// CreatDate: 2020-06-02
/// Description: 把给定的金额拆分到支付方式上
///    注意点：
///      1.优先往哪个支付方式上拆分，以后再做配置，默认按负发票中支付方式的顺序拆分。
///      2.对于现金支付方式要考虑分币误差
///      3.按支付方式拆分完后，如果还有剩余金额，则按现金支付
/// 
///    场景：医保发票转自费且是微信支付时，一般情况下新品的微信支付是不能大于原票的，此时就用现金来补。
///     另外，针对这个问题的其他处理方式：
///         方式一：发票支付方式表不做修改，在js中退第三方支付时，正负票捏合计，如果微信支付大于0，则先全退（原交易全部退费，交易明细表与负发票关联），
/// 				再重新收（新发票重新发起收费交易，交易明细表与新发票关联）—武汉人民采取了这个方案。
///        方式二：发票支付方式表不做修改，在js中退第三方支付时，正负票捏合计，如果微信支付大于0，则发起收费交易（收取差额部分，交易明细表关联负、正两条发票rowid）。
/// 				这种方式逻辑上合理，但是不好理解且退费时比较麻烦（如果全部退费，就需要退两笔），不推荐。
/// Input: prtRowId-发票rowid，amt-要拆分的金额， payMList-支付方式列表
/// Return: 支付方式列表
/// Debug: w ##class(web.udhcOPRefEdit1).SplitAmtToPayMode("")
ClassMethod SplitAmtToPayMode(prtRowId As %String, amt As %String, payMList As %String) As %String
{
	set payMSort="CASH^ZP^CPP^YHK^HP"   //这个串以后改为配置项
	if (payMSort'="") do
	.set payMList=..SortPayInfo(payMList, payMSort)
	
	set rtn=""
	set isHasCASH=0
	set balaneAmt=amt //定义一个临时平衡金额
	for i=1:1:$l(payMList,$c(3)) quit:(balaneAmt<=0)  do
	.set tmp=$p(payMList,$c(3),i)
	.set onePayMInfo=tmp
	.set payMDr=$p(onePayMInfo,"^",1)
	.set accMRowId=$p(onePayMInfo,"^",4)
	.set payMCode=$p(^CT("CTPM",payMDr),"^",1)
	.set payMAmt=$p(onePayMInfo,"^",8)
	.set invRoundErrInfo=$p(onePayMInfo,"^",9)  //分币误差信息
	.if ($p(invRoundErrInfo,"|",1)'="")  do
	..//改为新发票的rowid，因为支付方式可能是通过原发票获取的，分币误差信息中的发票指针是原发票的。
	..set $p(invRoundErrInfo,"|",1)=prtRowId
	..set $p(onePayMInfo,"^",9)=invRoundErrInfo
	.set roundErrAmt=$p(invRoundErrInfo,"|",2)
	.set payMAmt=payMAmt-roundErrAmt
	.if (balaneAmt<payMAmt) do
	..set invRoundAmt=balaneAmt
	..set invRoundErrDetails=""
	..if (payMCode="CASH") do
	...set isHasCASH=i
	...set invRoundErrInfo=##class(web.DHCBillConsIF).GetManyInvRoundErrAmt(prtRowId, balaneAmt, payMDr)
	...set invRoundAmt=$p(invRoundErrInfo,"^",1)
	...set invRoundErrDetails=$p(invRoundErrInfo,"^",2)
	..set $p(onePayMInfo,"^",8)=invRoundAmt
	..set $p(onePayMInfo,"^",9)=invRoundErrDetails
	..set balaneAmt=0
	.else  do
	..set balaneAmt=balaneAmt-payMAmt
	.quit:(+$p(onePayMInfo,"^",8)=0)    //过滤金额为0的支付方式
	.set rtn=$s((rtn=""):onePayMInfo,1:(rtn_$c(2)_onePayMInfo))
	
	if (balaneAmt>0) do
	.if (isHasCASH'=0) do
	..//支付列表中已经包含现金支付
	..set payinfo=$p(rtn,$c(2),isHasCASH)
	..set invRoundErrDetails=$p(payinfo,"^",9) //分币误差后的收现金金额^发票rowid|误差金额|舍入前金额|舍入后金额!发票rowid|误差金额|舍入前金额|舍入后金额
	..set payMAmt=$p(invRoundErrDetails,"|",3)
	..set tmpAmt=balaneAmt+payMAmt  //取上边现金支付舍入前金额加上剩余金额，做为现金支付金额
	..set invRoundErrInfo=##class(web.DHCBillConsIF).GetManyInvRoundErrAmt(prtRowId, tmpAmt)
	..set invRoundAmt=$p(invRoundErrInfo,"^",1)
	..set invRoundErrDetails=$p(invRoundErrInfo,"^",2)
	..set $p(payinfo,"^",8)=invRoundAmt
	..set $p(payinfo,"^",9)=invRoundErrDetails
	..;
	..set $p(rtn,$c(2),isHasCASH)=payinfo
	..;
	.else  do
	..set ctpayrid=0, flag=0
	..for  set ctpayrid=$o(^CT("CTPM",ctpayrid)) quit:((ctpayrid="")||(flag=1))  do
	...set myPMCode=$p(^CT("CTPM",ctpayrid),"^",1)
	...if (myPMCode="CASH") do
	....set invRoundErrInfo=##class(web.DHCBillConsIF).GetManyInvRoundErrAmt(prtRowId, balaneAmt, ctpayrid)
	....set invRoundAmt=$p(invRoundErrInfo,"^",1)
	....set invRoundErrDetails=$p(invRoundErrInfo,"^",2)
	....set payinfo=ctpayrid_"^^^^^^^^^^"
	....set $p(payinfo,"^",8)=invRoundAmt
	....set $p(payinfo,"^",9)=invRoundErrDetails
	....set rtn=$s((rtn=""):payinfo,1:(rtn_$c(2)_payinfo))
	....set flag=1
	
	quit rtn
}

/// 排序支付方式
/// w ##class(web.udhcOPRefEdit1).GetNewInvPayMList("")
ClassMethod SortPayInfo(payMList, payMSort)
{
	quit:($l(payMList,$c(3))=1) payMList
	
	kill aryPayMCodeIndex, aryPayMSubIndex
	set index=-100
	for i=1:1:$l(payMSort,"^")  do
	.set payModeCode=$p(payMSort,"^",i)
	.set sub=index+i
	.set aryPayMCodeIndex(payModeCode)=sub
	.set aryPayMSubIndex(sub)=payModeCode
	
	kill aryPayMSort
	for i=1:1:$l(payMList,$c(3))  do
	.set tmpPayInfo=$p(payMList,$c(3),i)
	.quit:(tmpPayInfo="")
	.set payMDr=$p(tmpPayInfo,"^",1)
	.set payMCode=$p(^CT("CTPM",payMDr),"^",1)
	.set sub=+$g(aryPayMCodeIndex(payMCode))
	.set aryPayMSort(sub)=tmpPayInfo
	
	set rtn=""
	set sub="" //下标有负数，这里一定不能是0
	for  set sub=$o(aryPayMSort(sub)) quit:(sub="")  do
	.set tmp=aryPayMSort(sub)
	.set rtn=$s((rtn=""):tmp,1:(rtn_$c(3)_tmp))
		
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-07-09
/// Description: 补调医保接口后更新发票费别和找平支付方式
/// Input: prtRowId:DHC_INVPRT.RowId
///        insTypeId:PAC_AdmReason.RowId
///        userId:SS_User.RowId
/// Return: rtn_"^"_insuPaySum (rtn =0:成功, <>0:失败)
/// Debug: w ##class(web.udhcOPRefEdit1).UpdateInvInsuDiv(4406, 4, 12173)
ClassMethod UpdateInvInsuDiv(prtRowId As %String, insTypeId As %String, userId As %String) As %String
{
	set $zt="ERROR"
	
	set hospId=$p(^DHCINVPRT(prtRowId),"^",39)
	
	//自费金额
	set selfPaySum=##class(web.DHCBillConsIF).GetPatSelfPayAmt(prtRowId)
	//医保支付金额
	set insuPaySum=$p(^DHCINVPRT(prtRowId),"^",31)   //PRT_YBPaySum
	
	ts
	
	//1.更新发票费别
	set rtn=##class(web.DHCBillCons12).UpdateInvInstype(prtRowId, insTypeId, userId)
	quit:(+rtn) rtn
	
	//2.更新支付方式
	set balanceAmt=selfPaySum
	set roundErrSum=0
	set sub=0
	while($o(^DHCINVPRT(prtRowId,"P",sub))) {
		set sub=$o(^DHCINVPRT(prtRowId,"P",sub))
		set myPMData=$g(^DHCINVPRT(prtRowId,"P",sub))
		continue:(myPMData="")
		set myPMRowId=prtRowId_"||"_sub
		set myPMNote=$p(myPMData,"^",12)
		continue:(+myPMNote'=1)     //过滤医保支付方式
		set myPMDR=$p(myPMData,"^",1)
		set myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
		set myPMAmt=$p(myPMData,"^",3)
		set myPMAmt=$fn(myPMAmt,"",2)
		set myAccPLDR=$p(myPMData,"^",8)
		if (balanceAmt>=myPMAmt) {
			//患者剩余自费金额大于此支付方式的金额
			set myRoundPatAmt=myPMAmt
			set balanceAmt=balanceAmt-myPMAmt
		}else {
			//患者剩余自费金额小于次支付方式的金额
			set myRoundPatAmt=balanceAmt
			set balanceAmt=0
		}
		if (myPMCode="CASH") {
			set tmpAmt=##class(web.DHCBillConsIF).OPCRound(myRoundPatAmt, hospId, myPMDR)
			set myRoundErrAmt=tmpAmt-myRoundPatAmt
			set roundErrSum=$i(roundErrSum, myRoundErrAmt)
			set myRoundPatAmt=tmpAmt
		}
		&SQL(
			UPDATE DHC_INVPayMode
			SET IPM_Amt = :myRoundPatAmt
			WHERE %ID = :myPMRowId
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		if (myAccPLDR'="") {
			lock +^DHCACD("AccM",+myAccPLDR):5
			if ('$test) {
				set rtn=-110_"^"_"账户："_+myAccPLDR_"被锁定"
				quit
			}
			set myAccPLData=$g(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)))
			set myInitAmt=$p(myAccPLData,"^",8)
			set myLeftAmt=$p(myAccPLData,"^",9)
			set myRetMoney=myInitAmt-myRoundPatAmt
			&SQL(
				UPDATE DHC_AccPayList
				SET AccPL_PayNum = :myRoundPatAmt, AccPL_Left = (:myLeftAmt + :myRetMoney)
				WHERE %ID = :myAccPLDR
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				lock -^DHCACD("AccM",+myAccPLDR)
				quit
			}
			if (+myRetMoney'=0) {
				set rtnValue=##class(web.DHCACPayList).UpdateAM(+myAccPLDR, myRetMoney)
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) {
					set rtn=rtnValue
					lock -^DHCACD("AccM",+myAccPLDR)
					quit
				}
			}
		}
	}
	if (+rtn)  tro  quit rtn

	&SQL(UPDATE DHC_INVPRT
		SET PRT_OPCRoundErr = :roundErrSum
		WHERE %ID = :prtRowId
	)
	set rtn=SQLCODE
	if (+rtn)  tro  quit rtn_"^"_$g(%msg)
	
	//验证发票表与支付方式表是否平衡
	set rtn=##class(web.DHCBillCons12).CheckInvPayMInfo(prtRowId)
	if (+rtn)  tro  quit rtn

	if ($tl>0) tc
	
	quit rtn_"^"_insuPaySum

ERROR
	quit ..AppException()
}

/// Creator: tangtao
/// CreatDate: 2011-11-17
/// Description: 撤销集中打印发票
///             DHC_AccPayINV, DHC_AccPayINVMode表只添加负记录，DHC_INVPRT置回未打印发票状态
/// Input：集中打印发票Id，收费员Id
/// Return: 
/// Debug: w ##class(web.udhcOPRefEdit1).WriteOffAPI("3","5")
ClassMethod WriteOffAPI(AccPInvId As %String, UserId As %String) As %String
{
	set $zt="ERROR"
    quit:(AccPInvId="") -1_"^"_"参数错误"
    
    ts
    
	set rtn=0
	
	set userDR=$p($g(^DHCINVPRTAP(AccPInvId)),"^",5)
	set reportsDR=$p($g(^DHCINVPRTAP(AccPInvId)),"^",20)
	set sFlag=$s(((+reportsDR=0)&&(+userDR=+UserId)):"A",1:"S")
	
	//作废原发票
    set rtnValue=##class(web.UDHCACINVColPrt).ParkAPayINV(AccPInvId, sFlag)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	//写负发票
	set rtnValue=##class(web.UDHCACINVColPrt).CancleAPayINV(AccPInvId, UserId, sFlag, 0)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set myPAPIRowID=$p(rtnValue,"^",2)
	
 	//写负发票连接表
	set myACPRowID=0
	while($o(^DHCINVPRTCAPi(0,"APINVDR",AccPInvId,myACPRowID))) {
		set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",AccPInvId,myACPRowID))
		set myPrtRowID=$p(^DHCINVPRTCAP(myACPRowID),"^",1)
		&SQL(
			INSERT INTO DHC_AccPINVCONPRT (
				ACP_INVPRT_DR, ACP_APINV_DR
			)
			VALUES (
				:myPrtRowID, :myPAPIRowID
			)
		)
  		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
    if (+rtn) tro  quit rtn
    
    set sub=0
    while($o(^DHCINVPRTAP(AccPInvId,"P",sub))) {
	    set sub=$o(^DHCINVPRTAP(AccPInvId,"P",sub))
	    set paymData=$g(^DHCINVPRTAP(AccPInvId,"P",sub))
	    set paymDR=$p(paymData,"^",1)
		set paymAmt=$p(paymData,"^",3)
		&SQL(
			INSERT INTO DHC_AccPayINVMode (
				APM_API_ParRef, APM_PayMode_DR, APM_Amt, APM_Date, APM_Time
			)
			VALUES (
				:myPAPIRowID, :paymDR, -:paymAmt, CONVERT(DATE, NOW()), CONVERT(TIME, NOW())
			)
		)
   		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
   	//将DHC_INVPRT置回未打印发票状态
    set myACPRowID=0
    while($o(^DHCINVPRTCAPi(0,"APINVDR",AccPInvId,myACPRowID))) {
	    set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",AccPInvId,myACPRowID))
	    set myPrtRowID=$p(^DHCINVPRTCAP(myACPRowID),"^",1)
	    &SQL(
			UPDATE DHC_INVPRT
			SET PRT_INVPrintFlag = 'N', PRT_ACCPINV_DR = NULL
			WHERE %ID = :myPrtRowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
    if (+rtn) tro  quit rtn
    
    if ($tl>0) tc
    
    quit rtn
    
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-05-18
/// Description: 根据结算记录RowId获取结算医嘱的费别
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: insTypeId: PAC_AdmReason.RowId
/// Debug: w ##class(web.udhcOPRefEdit1).GetPrtOrdInsTypeId("10654")
ClassMethod GetPrtOrdInsTypeId(prtRowId As %String) As %String
{
	set insTypeId=""
	quit:(+prtRowId=0) insTypeId
	
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInv))&&(insTypeId="")) {
		set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
		set pb=$p($g(^DHCBCI(billConInv)),"^",2)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))&&(insTypeId="")) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set oeitm=$p(^DHCPB(pb,"O",pbo),"^",4)
			set insTypeId=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11)),"^",18)   //OEORI_BBExtCode
		}
	}
	
	quit insTypeId
}

}
