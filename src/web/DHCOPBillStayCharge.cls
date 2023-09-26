Import SQLUser

/// Creator: Lid
/// CreatDate: 2012-06-14
/// Description: 急诊留观结算业务
Class web.DHCOPBillStayCharge Extends BILL.COM.Abstract
{

/// 留观结算默认使用"留观押金(ECPP)"方式支付
Parameter PayModeCode = "ECPP";

/// 是否锁账单表的条数设置
Parameter LimitCount = 1000;

/// Creator: Lid
/// CreatDate: 2012-06-15
/// Description: 取留观病人费用信息(只取Bill状态的账单)
/// Input: adm:就诊RowId, billId:账单表RowId, sessionStr:用户Id^安全组Id^科室Id^医院Id
/// Return: 总费用^折扣金额^记账金额^自付金额
/// Other: billId为空时，按adm取病人的费用, billId不为空时，按billId取病人费用
/// Debug: w ##class(web.DHCOPBillStayCharge).GetStayTotalAmt("436","17771","5^122^49^2")
ClassMethod GetStayTotalAmt(adm As %String, billId As %String, sessionStr As %String) As %String
{
	set rtn="0.00^0.00^0.00^0.00"
	
	quit:((+adm=0)&&(+billId=0)) rtn
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set (totalAmt, discAmt, payorShareAmt, patientShareAmt)=0

	do ##class(web.UDHCJFBILL).BILLN(adm, userId)   //账单
	
	set returnFlag=0	 //门诊停医嘱就会退费，这里需要判断是否药品已经退了，如果未退药控制不让退费
	
	set stopOrdStatDR=$o(^OEC("OSTAT",0,"Code","D",0))   //医嘱停止状态RowId
	
	if (+billId'=0) {
		set admDR=$p($g(^DHCPB(billId)),"^",1)
		quit:((+adm'=0)&&(adm'=admDR)) rtn
		do GetFeeInfo(billId)
    	set rtn=$fn(totalAmt,"",2)_"^"_$fn(discAmt,"",2)_"^"_$fn(payorShareAmt,"",2)_"^"_$fn(patientShareAmt,"",2)_"^"_returnFlag
		quit rtn
	}
	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		do GetFeeInfo(pb)
	}
	
	set rtn=$fn(totalAmt,"",2)_"^"_$fn(discAmt,"",2)_"^"_$fn(payorShareAmt,"",2)_"^"_$fn(patientShareAmt,"",2)_"^"_returnFlag
    
	quit rtn

GetFeeInfo(pb)
	set pbData=$g(^DHCPB(pb))
	set payedFlag=$p(pbData,"^",16)  //PB_PayedFlag
	quit:(payedFlag'="B")
	set pbo=0
	while($o(^DHCPB(pb,"O",pbo))) {
		set pbo=$o(^DHCPB(pb,"O",pbo))
		set pboData=$g(^DHCPB(pb,"O",pbo))
		continue:(pboData="")
		set oeitm=$p(pboData,"^",4)
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)=1)  //将急诊转出到住院的医嘱退出
		set arcim=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",2)
		set inciDR=$o(^INCI(0,"ARCIM_DR",+arcim,0))   //+2019-01-02 ZhYW
		set pboAmount=+$p(pboData,"^",8)
		set pboDiscAmount=+$p(pboData,"^",9)
		set pboPayorShare=+$p(pboData,"^",10)
		set pboPatientShare=+$p(pboData,"^",11)
		set totalAmt=$i(totalAmt, pboAmount)
		set discAmt=$i(discAmt, pboDiscAmount)
		set payorShareAmt=$i(payorShareAmt, pboPayorShare)
		set patientShareAmt=$i(patientShareAmt, pboPatientShare)
		set ordStatDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",13)
		//2015-03-24 Lid 作废医嘱按停止医嘱处理，防止收费时报"102"错误
		set ordStatDR=##class(web.DHCBillCons1).ResetOrderStatus(ordStatDR)
		continue:(ordStatDR'=stopOrdStatDR)
		if (inciDR'="") {
			set pboQty=$p(pboData,"^",5)
			set pboRefundQty=$p(pboData,"^",6)
			if ((+pboQty'=0)&&(+pboRefundQty=0)) set returnFlag=1    //+2019-01-10 ZhYW
		}
	}
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-12-16
/// Description: 获取就诊对应的账单列表
/// Input: adm:PA_Adm.RowId, sessionStr:用户Id^安全组Id^科室Id^医院Id
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillStayCharge","QryBillList","436","5^122^49^2^20")
Query QryBillList(adm As %String, sessionStr As %String) As websys.Query(ROWSPEC = "adm:%String:就诊ID,stayStatus:%String:留观状态,dept:%String:科室,ward:%String:病区,bedCode:%String:床号,admDate:%String:入院日期,admTime:%String:入院时间,disDate:%String:出院日期,disTime:%String:出院时间,billId:%String:账单ID,pbStatus:%String:账单状态,insTypeDR:%String:费别ID,insTypeDesc:%String:费别,totalAmt:%Float:总金额,discAmt:%Float:折扣金额,payorAmt:%Float:记账金额,patShareAmt:%Float:自付金额,prtRowId:%String,prtDate:%String:财务结算日期,prtTime:%String:财务结算时间")
{
}

ClassMethod QryBillListExecute(ByRef qHandle As %Binary, adm As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (+adm=0)  quit $$$OK
	
	set userId=$p(sessionStr,"^",1)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	do ##class(web.UDHCJFBILL).BILLN(adm, userId)   //账单
	
	set stayStatus=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(adm)
	
	set admData=$g(^PAADM(adm))
	set deptDR=$p(admData,"^",4)
	set dept=$s((+deptDR'=0):$p($g(^CTLOC(deptDR)),"^",2),1:"")
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
	set wardDR=$p(admData,"^",70)
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set bedDR=$p(admData,"^",73)
	set bed=$s((bedDR'=""):$p($g(^PAWARD(+bedDR,"BED",+$p(bedDR,"||",2))),"^",1),1:"")
	set admDate=$p(admData,"^",6)
	set admTime=$p(admData,"^",7)
	set disDate=$p(admData,"^",17)
	set disTime=$p(admData,"^",18)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime, 1)
	set disDate=##class(websys.Conversions).DateLogicalToHtml(disDate)
	set disTime=##class(websys.Conversions).TimeLogicalToHtml(disTime, 1)
	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		set payedFlag=$p(pbData,"^",16)
		set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
 		continue:((payedFlag="P")&&(isCloseAcount'="Y"))
		set pbStatus=$case(payedFlag,"P":"已结算",:"未结算")
		if (isCloseAcount="Y") {
			set pbStatus="已封账"
		}
		set pbStatus=##class(websys.Translation).Get("", pbStatus, langId)
		set refundFlag=$p(pbData,"^",17)
		set insTypeDR=$p(pbData,"^",4)
		set insTypeDesc=$p(^PAC("ADMREA",insTypeDR),"^",2)
		set insTypeDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", insTypeDesc, langId)
		set totalAmt=$p(pbData,"^",8)
		set totalAmt=$fn(totalAmt,"",2)
		set discAmt=$p(pbData,"^",9)
		set discAmt=$fn(discAmt,"",2)
		set payorAmt=$p(pbData,"^",11)
		set payorAmt=$fn(payorAmt,"",2)
		set patShareAmt=$p(pbData,"^",12)
		set patShareAmt=$fn(patShareAmt,"",2)
		set billConInvDR=$o(^DHCBCI(0,"Bill",pb,0))
		set prtInvDR="", prtDate="", prtTime=""
		if (+billConInvDR'=0) {
			set prtInvDR=$p($g(^DHCBCI(billConInvDR)),"^",1)
		}
		if (+prtInvDR'=0) {
			set prtDate=$p($g(^DHCINVPRT(prtInvDR)),"^",5)
			set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
			set prtTime=$p($g(^DHCINVPRT(prtInvDR)),"^",20)
			set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime, 1)
		}
		do OutputBillList
	}
	
	quit $$$OK
    
OutputBillList
	set Data=$lb(adm,stayStatus,dept,ward,bed,admDate,admTime,disDate,disTime,pb,pbStatus,insTypeDR,insTypeDesc,totalAmt,discAmt,payorAmt,patShareAmt,prtInvDR,prtDate,prtTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: Lid
/// CreatDate: 2012-11-15
/// Description: 获取已结束留观患者的财务结算标识
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId, expStr:扩展参数
/// Return:	(N:有未作财务结算的就诊记录, Y:无)
/// Debug: w ##class(web.DHCOPBillStayCharge).GetBillFlag(375430, 2, "")
ClassMethod GetBillFlag(patientId As %String, hospId As %String, expStr As %String = "")
{
	set rtn="Y"
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","E",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","E",adm),-1)
		set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(hospDR'=hospId)
		set stayInfo=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(adm)
		set stayFlag=$p(stayInfo,"^",2)
		set visitStatus=$p(^PAADM(adm),"^",20)
		continue:(visitStatus'="D")
		set billFlag=$p(^PAADM(adm),"^",45)	  //PAADM_BillFlag
		continue:(billFlag="Y")
		set rtn="N"
		quit
	}

	quit rtn
}

ClassMethod GetChargePayMID()
{
	quit $o(^CT("CTPM",0,"Code",$$ALPHAUP^SSUTIL4(..#PayModeCode),""))
}

/// Creator: ZhYW
/// CreatDate: 2019-08-20
/// Description: 急诊留观预结算
/// Input: billId:DHC_PatientBill.RowId, userId:SS_User.RowId, insTypeId:PAC_AdmReaon.RowId, patPaySum:支付金额, expStr: 
/// Return: 
/// Other: 
/// Debug: w ##class(web.DHCOPBillStayCharge).StayCharge("381","5","1","6.00","122^3^^Y^F^^^^1^192.168.2.184^Y")
ClassMethod StayCharge(billId As %String, userId As %String, insTypeId As %String, patPaySum As %String, expStr As %String) As %String
{
	set ^TMP("StayCharge")=$lb(billId, userId, insTypeId, patPaySum, expStr)
	set $zt="ERROR"
	set rtn=0
	
	quit:(+billId=0) -1_"^"_"参数错误"
	
	set prtInvDR=##class(BILL.OP.COM.Method).GetPrtInvIdByBill(billId)
	quit:(+prtInvDR'=0) -1_"^"_"账单已结算，不能重复结算"
	
	set adm=$p($g(^DHCPB(billId)),"^",1)
	quit:(+adm=0) -1_"^"_"账单表中就诊ID为空"
	
	set rtn=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByEpisodeID(adm)
	quit:(+rtn) 120_"^"_"有异常收费记录需要处理"
	
	set papmi=$p($g(^PAADM(adm)),"^",1)

	ts
	
	set payInfo=""
	
	set billIdStr=billId_$c(2)   //这里拼接的$c(2)不能少
	
	set sFlag=0
	set oldINVRID=""
	set preSum=""
	set changeSum=""
	set roundSum=""
	set subAvailDR=""
	set rtnValue=##class(web.DHCBillCons12).SaveINV(userId, patPaySum, payInfo, papmi, billIdStr, insTypeId, sFlag, oldINVRID, preSum, changeSum, roundSum, subAvailDR, expStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set prtRowId=$p(rtnValue,"^",2)

	set prtData=$g(^DHCINVPRT(prtRowId))
	set prtInsTypeId=$p(prtData,"^",9)
	set prtPatShare=$p(prtData,"^",16)
	
	if ($zabs(prtPatShare-patPaySum)>0.01) {
		set rtn=102_"^"_"患者的支付金额不符，账单金额："_$fn(prtPatShare,"",2)_"，传入金额："_$fn(patPaySum,"",2)
		tro
		quit rtn
	}
	
	if ($tl>0) tc
	
	quit rtn_"^"_prtRowId
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-08-20
/// Description: 急诊留观确认完成
/// Input: billId:DHC_PatientBill.RowId, userId:SS_User.RowId, insTypeId:PAC_AdmReaon.RowId, prtRowIdStr:DHC_INVPRT.RowId串, expStr: 
/// Return: 
/// Other: 
/// Debug: w ##class(web.DHCOPBillStayCharge).CompleteStayCharge(5569, 1, 1, 1, "122^303^2^Y^F^0^464")
ClassMethod CompleteStayCharge(billId As %String, userId As %String, insTypeId As %String, prtRowIdStr As %String, expStr As %String, payInfo As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	quit:(+billId=0) -1_"^"_"参数错误"
	
	set adm=$p($g(^DHCPB(billId)),"^",1)
	quit:(+adm=0) -1_"^"_"账单表中就诊ID为空"
	
	ts
	
	set sFlag=0
	set oldINVRID=""
	set rtn=##class(web.DHCBillConsIF).CompleteCharge(2, userId, insTypeId, prtRowIdStr, sFlag, oldINVRID, expStr, payInfo)
	if (+rtn) tro  quit rtn
	
	//如果是封账账单，则删除封账标记
    set rtn=##class(BILL.OP.BL.CloseBill).DelCloseAcount(billId)
    if (+rtn) tro  quit rtn
    
	set stayStatus=##class(web.UDHCJFBaseCommon).GetObsPatYetDisHosp(adm)
	if (stayStatus=1) {
		//留观出院且无待结算账单时，就诊表已做财务结算标识留痕
		set isNotPayed=..HasNotPayedBill(adm)
		if (isNotPayed=0) {
			&SQL(
				UPDATE PA_Adm
				SET PAADM_BillFlag = 'Y'
				WHERE %ID =:adm
			)
			set rtn=SQLCODE
			if (+rtn) tro  quit rtn_"^"_$g(%msg)
		}
	}
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: Lid
/// CreatDate: 2018-10-11
/// Description: 撤销留观结算
/// Input: prtRowId:发票rowid, sessionStr:用户Id^安全组Id^科室Id^医院Id, expStr:扩展串(格式：DHC_AccPayInv.RowId^^^)
/// Return: 
/// Other: 
/// Debug: w ##class(web.DHCOPBillStayCharge).StayChargeCancel("17887","5^122^49^2^1","^")
ClassMethod StayChargeCancel(prtRowId As %String, sessionStr As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("StayChargeCancel")=$lb(prtRowId, sessionStr, expStr)

	set stayFlag=##class(web.UDHCJFBaseCommon).GetPrtInvStat(prtRowId)
	quit:(stayFlag'="Y") -301_"^"_"非留观发票，不能撤销"
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set accPInvDR=$p(expStr,"^",1)      //DHC_AccPayInv.RowId
		
	set prtReportDR=$p(^DHCINVPRT(prtRowId),"^",6)     //PRT_DHCINVPRTR_DR
	set prtUserDR=$p(^DHCINVPRT(prtRowId),"^",21)
	set sFlag=$s(((+prtReportDR=0)&&(prtUserDR=userId)):"A",1:"S")
	
	ts
	
	set rtn=0
	
	set myCurDate=+$h
	set myCurTime=$p($h,",",2)

	if (+accPInvDR'=0) {
		set rtn=##class(web.udhcOPRefEditIF).WriteOffAPI(accPInvDR, userId)
		if (+rtn) tro  quit rtn
	}
	
	//更新原来的票据
	set rtn=##class(web.UDHCINVPRT).INVPRTPark(prtRowId, userId, sFlag)
	if (+rtn) tro  quit rtn
	
	//插入发票负记录
	set refundInvFlag="N"     //留观退费负记录不走发票号
	set myPINVFlag="N"
	set mtExpStr=groupId_"^"_ctLocId_"^"_hospId_"^"_refundInvFlag_"^"_myPINVFlag
	set rtnValue=##class(web.UDHCINVPRT).INVPRTCancel(prtRowId, userId, sFlag, myCurDate, myCurTime, mtExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set strikePrtRowId=$p(rtnValue,"^",2)

	//写负账单
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		set adm=$p(conData,"^",3)
		set rtnValue=##class(web.UDHCJFPBCANCEL).PBCancel(adm, pb, userId)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set refBillRowId=$p(rtnValue,"^",2)    //负账单RowId
		set newBillRowId=$p(rtnValue,"^",3)    //新账单RowId
		//写连接表
		&SQL(INSERT INTO DHC_BillConINV (
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
	
	//写负单的支付方式  Input Para :废单RowID，负单RowID
	set refundFlag=0                   //撤销相当于全退
	set mulityPayModeFlag=""           //留观使用押金，不存在多种支付方式
	set rPayModeDR=""
	set myDTStr=myCurDate_"^"_myCurTime_"^"_refundFlag_"^"_mulityPayModeFlag
	set rtnValue=##class(web.UDHCINVPRT).INVPRTPayModeCancel(prtRowId, strikePrtRowId, ctLocId, rPayModeDR, userId, myDTStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	if ($tl>0) tc
	
	set newPrtRowId=""      //全部退费，不存在新票rowid
	
	quit rtn_"^"_newPrtRowId_"^"_strikePrtRowId_"^"_refundInvFlag

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-12-17
/// Description: 判断该就诊下是否有未结算账单
/// Input: adm: PA_Adm.RowId
/// Return: 0:否，1:是
/// Debug:w ##class(web.DHCOPBillStayCharge).HasNotPayedBill("12538")
ClassMethod HasNotPayedBill(adm As %String) As %String
{
	set rtn=0
	quit:(+adm=0) rtn
	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		set payedFlag=$p(pbData,"^",16)
		set isCloseAcount=##class(BILL.OP.BL.CloseBill).GetPaidCAcountFlag(pb)
 		continue:((payedFlag="P")&&(isCloseAcount'="Y"))
		set rtn=1
		quit
	}
	
	quit rtn
}

}
