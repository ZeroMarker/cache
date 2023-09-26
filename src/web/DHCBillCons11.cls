Import SQLUser

Class web.DHCBillCons11 Extends BILL.COM.Abstract
{

/// 医保已结算能否撤销？("Y":能撤销, "N":不能撤销)
Parameter RollBackInsuDiv [ Final ] = "N";

/// Description: 撤销HIS预结算
/// Input: INVStr: DHC_INVPRT.RowId串(多个以"^"分割)
///        ExpStr: SS_Group.RowId^SS_User.RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.DHCBillCons11).DelINVPRTForYB("17462","122^5")
ClassMethod DelINVPRTForYB(INVStr As %String, ExpStr As %String) As %String
{
	set ^TMP("DelINVPRTForYB")=$lb(INVStr, ExpStr)
	set groupId=$p(ExpStr,"^",1)
	set userId=$p(ExpStr,"^",2)
	
	set $zt="ERROR"
	set rtn=0
	
	set logStr=""
	set myINVStr=""
	set myPBRStr=""
	set myBCIStr=""
	
	kill billStayAry  //记录账单对应发票的急诊留观状态
	
	set mylen=$l(INVStr,"^")
	for i=1:1:mylen {
		set myPRTRowID=$p(INVStr,"^",i)
		continue:(+myPRTRowID=0)
		//验证发票状态
		set myPrtData=$g(^DHCINVPRT(myPRTRowID))
		continue:(myPrtData="")
		set myPrtFlag=$p(myPrtData,"^",8)
		continue:(myPrtFlag'="TP")             //过滤非预结算的发票记录
		set myReportsDR=$p(myPrtData,"^",6)
		if (+myReportsDR'=0) {
			set rtn=-1_"^"_"已日结记录不能撤销"
			quit
		}
		set myOldInvDR=$p(myPrtData,"^",29)
		if (+myOldInvDR'=0) {
			set rtn=-1_"^"_"退费重收记录不能撤销"
			quit
		}
		//Lid 2015-04-29 医保结算成功后HIS不能撤销
		set insuDivFlag=##class(web.DHCBillCons11).CheckYBCharge(myPRTRowID)
		if ((insuDivFlag=0)&&(..#RollBackInsuDiv'="Y")) {
			set rtn=-1_"^"_"医保未撤销，HIS不能撤销"
			quit
		}
		set myPrtAmt=$p(myPrtData,"^",1)
		set myPrtDate=$p(myPrtData,"^",5)
		set myPapmiDR=$p(myPrtData,"^",15)
		set myPrtTime=$p(myPrtData,"^",20)
		set myPrtUserDR=$p(myPrtData,"^",21)
		set myPrtInsDivDR=$p(myPrtData,"^",30)     //PRT_InsDiv_DR
		set myStayFlag=$p(myPrtData,"^",44)        //PRT_StayFlag
		set myINVStr=myINVStr_myPRTRowID_"^"
		set singleBCIDRStr=""
		set singlePBDRStr=""
		set myBCIRowID=0
		while($o(^DHCBCI(0,"INV",myPRTRowID,myBCIRowID))) {
			set myBCIRowID=$o(^DHCBCI(0,"INV",myPRTRowID,myBCIRowID))
			set myPBRowID=$p(^DHCBCI(myBCIRowID),"^",2)
			continue:(myPBRowID="")
			set billStayAry(myPBRowID)=myStayFlag
			set myBCIStr=myBCIStr_myBCIRowID_"^"
			set singleBCIDRStr=singleBCIDRStr_myBCIRowID_"|"
			set myPBRStr=myPBRStr_myPBRowID_"^"
			set singlePBDRStr=singlePBDRStr_myPBRowID_"|"
		}
		set invInfo=myPRTRowID_"^"_myPapmiDR_"^"_myPrtUserDR_"^"_myPrtAmt_"^"_myPrtDate_"^"_myPrtTime_"^"_myPrtInsDivDR_"^"_singleBCIDRStr_"^"_singlePBDRStr
		set logStr=logStr_invInfo_"#"
	}
	quit:(+rtn) rtn
	quit:((myPBRStr="")&&(myBCIStr="")) ""
	
	ts
	
	set mylen=$l(myPBRStr,"^")
	for i=1:1:mylen {
		set myPBRowID=$p(myPBRStr,"^",i)
		continue:(+myPBRowID=0)
		set myStayFlag=$g(billStayAry(myPBRowID))
		continue:(myStayFlag="Y")                        //+2022-01-21 ZhYW 急诊留观结算的账单对应医嘱不修改
		set myPBO=0
		while($o(^DHCPB(myPBRowID,"O",myPBO))) {
			set myPBO=$o(^DHCPB(myPBRowID,"O",myPBO))
			set pboData=$g(^DHCPB(myPBRowID,"O",myPBO))
			continue:(pboData="")
			set pboRowId=myPBRowID_"||"_myPBO
			set myOEORI=$p(pboData,"^",4)
			set myBilled=$p($g(^OEORD(+myOEORI,"I",+$p(myOEORI,"||",2),3)),"^",5)
			if (myBilled="B") {
				set statDR=$p($g(^OEORD(+myOEORI,"I",+$p(myOEORI,"||",2),1)),"^",13)
				set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
				continue:(statCode="D")		//停止的医嘱不更新
				&SQL(
					UPDATE OE_OrdItem
					SET OEORI_Billed = 'TB', OEORI_ARPBLItem_DR = NULL
					WHERE %ID = :myOEORI
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			//更新新版检查申请单中间表
			set artiDR=0
			while($o(^DHCAPREPTA(0,"PBO",pboRowId,artiDR))) {
				set artiDR=$o(^DHCAPREPTA(0,"PBO",pboRowId,artiDR))
				&SQL(
					UPDATE DHC_AppRepTarItm
					SET ARTI_Billed = 'TB', ARTI_PBO_Dr = NULL
					WHERE %ID = :artiDR
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
	}
	if (+rtn)  tro  quit rtn
	
	//删除发票表
	set mylen=$l(myINVStr,"^")
	for i=mylen:-1:1 {
		set myPRTRowID=$p(myINVStr,"^",i)
		continue:(+myPRTRowID=0)
		set myPrtData=$g(^DHCINVPRT(myPRTRowID))
		continue:(myPrtData="")
		set myPrtINV=$p(myPrtData,"^",14)
		set myUserDR=$p(myPrtData,"^",21)
		set myFairType=$p(myPrtData,"^",34)
		set myInsType=$p(myPrtData,"^",9)
		set myHospDR=$p(myPrtData,"^",39)
		//如果是卡支付,要删除支付记录,并把金额返回账户
		set rtn=..CancelAccountPay(myPRTRowID)
		quit:(+rtn)
		//如果是留观支付,要删除支付记录,并把金额返回留观押金账户
		set rtn=..CancelEPMPay(myPRTRowID)
		quit:(+rtn)
		&SQL(DELETE FROM DHC_INVPRT WHERE %ID = :myPRTRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		continue:(myPrtINV="")
		//修复当前的发票号码
		set myPreABCInfo=##class(web.DHCBillCommon).GetINVPreABCInfo(myPrtINV)
		set myPrtINV=$p(myPreABCInfo,"^",1)
		set myPrtINVTitle=$p(myPreABCInfo,"^",2)
		set myINVRowID=0
		while($o(^DHCINVOICE(0,"USER",myUserDR,myINVRowID))) {
			set myINVRowID=$o(^DHCINVOICE(0,"USER",myUserDR,myINVRowID))
			set myINVData=$g(^DHCINVOICE(myINVRowID))
			set myINVHospDR=$p(myINVData,"^",26)
			continue:(myINVHospDR'=myHospDR)
			set myINVType=$p(myINVData,"^",8)
			continue:(myINVType'="O")
			set myINVTitle=$p(myINVData,"^",16)
			continue:(myPrtINVTitle'=myINVTitle)
			set myBegINV=$p(myINVData,"^",1)
			set myEndINV=$p(myINVData,"^",2)
			set myLastINV=$p(myINVData,"^",6)
			continue:('((+myBegINV<=+myPrtINV)&&(+myPrtINV<=+myEndINV)))
			set myINVFlag=$p(myINVData,"^",7)    //INV_Finalflag
			continue:((myINVFlag="N")&&(+myEndINV'=+myLastINV))
			if ('(+myLastINV=(+myPrtINV+1))&&(myINVFlag'="N")) {
				set rtn=-1_"^"_"不是最后一张发票，不能撤销"
				quit
			}
			if (myINVFlag'="N") {
				set rtn=##class(web.udhcOPBill).UpdateReceipNO(myUserDR, myPrtINV, groupId, myFairType, myInsType, myHospDR)
				quit:(+rtn)
			}
			set nextINVRowID=myINVRowID
			while($o(^DHCINVOICE(0,"USER",myUserDR,nextINVRowID))) {
				set nextINVRowID=$o(^DHCINVOICE(0,"USER",myUserDR,nextINVRowID))
				set myNextINVData=$g(^DHCINVOICE(nextINVRowID))
				set nextINVHospDR=$p(myNextINVData,"^",26)
				continue:(nextINVHospDR'=myHospDR)
				set nextINVType=$p(myNextINVData,"^",8)
				continue:(nextINVType'="O")
				set nextINVFlag=$p(myNextINVData,"^",7)
				continue:(nextINVFlag'="Y")
				&SQL(
					UPDATE DHC_INVOICE
					SET INV_Finalflag = NULL
					WHERE %ID = :nextINVRowID
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
				&SQL(
					UPDATE DHC_INVOICE
					SET INV_Finalflag = 'Y'
					WHERE %ID = :myINVRowID
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
	}
	if (+rtn)  tro  quit rtn
	
	//删除连接表
	set mylen=$l(myBCIStr,"^")
	for i=1:1:mylen {
		set myBCIRowID=$p(myBCIStr,"^",i)
		continue:((+myBCIRowID=0)||('$d(^DHCBCI(myBCIRowID))))
		&SQL(DELETE FROM DHC_BillConINV WHERE %ID = :myBCIRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn)  tro  quit rtn
	
	//删除账单
	set mylen=$l(myPBRStr,"^")
	for i=1:1:mylen {
		set myPBRowID=$p(myPBRStr,"^",i)
		continue:((+myPBRowID=0)||('$d(^DHCPB(myPBRowID))))
		set myPayedFlag=$p($g(^DHCPB(myPBRowID)),"^",16)    //+2020-01-18 ZhYW 控制已结算账单不能删除
		continue:(myPayedFlag="P")
		set myStayFlag=$g(billStayAry(myPBRowID))
		continue:(myStayFlag="Y")                        //+2022-01-21 ZhYW 急诊留观结算的账单不删除
		continue:($d(^DHCBCI(0,"Bill",myPBRowID)))       //+2018-01-04 ZhYW 控制门诊有结算记录之后不删除账单
		do ##class(web.UDHCJFBaseCommon).DelPBONullData(myPBRowID)   //+2020-06-19 ZhYW 先kill空账单，防止delete失败
		&SQL(DELETE FROM DHC_PatientBill WHERE %ID = :myPBRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn)  tro  quit rtn
	
	//删除欠费结算记录
	set mylen=$l(myINVStr,"^")
	for i=mylen:-1:1 {
		set myPRTRowID=$p(myINVStr,"^",i)
		continue:(+myPRTRowID=0)
		set qfdr=$o(^DHCOPQFPatInfo(0,"InvPrt",myPRTRowID,0))
		continue:(+qfdr=0)
		set flag=$p($g(^DHCOPQFPatInfo(qfdr)),"^",7)
		if (flag'="Owe") {
			set rtn=-111
			quit
		}
		&SQL(DELETE FROM DHC_OPQFPatTotal WHERE %ID = :qfdr)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn)  tro  quit rtn
	
	//删除中间表记录
	set mylen=$l(myINVStr,"^")
	for i=mylen:-1:1 {
		set myPRTRowID=$p(myINVStr,"^",i)
		continue:(+myPRTRowID=0)
		continue:('$d(^DHCPHARi("PRT",myPRTRowID)))
		&SQL(DELETE FROM DHC_PHARWIN WHERE PHA_PRT_DR = :myPRTRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn)  tro  quit rtn
	
	set rtn=..DeleteLog(logStr, ExpStr)	  //记录删除日志
	if (+rtn)  tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-07-17
/// Description: 门诊撤销异常结算日志
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillCons11).DeleteLog()
ClassMethod DeleteLog(logStr As %String, expStr As %String) As %String
{
	set groupId=$p(expStr,"^",1)
	set userId=$p(expStr,"^",2)

	set rtn=0
	
	ts
	
	set count=$l(logStr,"#")
	for i=1:1:count {
		set invInfo=$p(logStr,"#",i)
		continue:(invInfo="")
		set invPrtDR=$p(invInfo,"^",1)
		set papmi=$p(invInfo,"^",2)
		set userDR=$p(invInfo,"^",3)
		set invAcount=$p(invInfo,"^",4)
		set invDate=$p(invInfo,"^",5)
		set invTime=$p(invInfo,"^",6)
		set insDivDR=$p(invInfo,"^",7)
		set billConInvDRStr=$p(invInfo,"^",8)
		set billNoStr=$p(invInfo,"^",9)
		set delPrtObj=##class(User.DHCOPBillDelInvPrtLog).%New()
		set delPrtObj.DILDate=+$h
		set delPrtObj.DILTime=$p($h,",",2)
		do delPrtObj.DILUserDRSetObjectId(userId)
		set delPrtObj.DILInvPrtDR=invPrtDR
		do delPrtObj.DILPAPMIDRSetObjectId(papmi)
		do delPrtObj.DILInvUserDRSetObjectId(userDR)
		set delPrtObj.DILInvAcount=invAcount
		set delPrtObj.DILInvDate=invDate
		set delPrtObj.DILInvTime=invTime
		set delPrtObj.DILBCIDRStr=billConInvDRStr
		set delPrtObj.DILPBDRStr=billNoStr
		set delPrtObj.DILInsDivDR=insDivDR
		do delPrtObj.DILGroupDRSetObjectId(groupId)
		set sc=delPrtObj.%Save()
		do delPrtObj.%Close()
		if ($$$ISERR(sc)) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
}

/// 门诊收费通用上传医保接口
/// 更新发票表为医保
/// 医保病人自负金额才进行分币误差的舍入计算
/// rtn^INSU_Divide.RowId^PatSelfPaySum^DHC_INVPRT.RowId^NewPayMode_$c(2)_PayMode_DR^12.01_$c(2)_PayMode_DR^20_$c(3)_发票2
/// Debug: w ##class(web.DHCBillCons11).UpdateINVPRTYBInfo("0^517^.0600000000000001^8084"_$c(2)_"6^0")
/// 2020-05-26 Lid Modify 预结算不插入支付方式，医保结算后调用此接口时，支付方式表只插入医保支付方式，自付金额的支付方式不再此处更新或插入
ClassMethod UpdateINVPRTYBInfo(YBInfo As %String) As %String
{
	set ^TMP("UpdateINVPRTYBInfo")=$lb(YBInfo)
	set $zt="ERROR"

	set rtn=""
	set myYBErrlog=""
	
	set YBInvInfo=$p(YBInfo,"|",1)
	set PreDepInfo=$p(YBInfo,"|",2)
	
	for i=1:1:$l(YBInvInfo,$c(3)) {
		set myYBInv=$p(YBInvInfo,$c(3),i)
		continue:(myYBInv="")
		set myINVInfo=$p(myYBInv,$c(2),1)
		set rtn=$p(myINVInfo,"^",1)
		quit:(+rtn)
		set myInsuDivID=$p(myINVInfo,"^",2)
		if (+myInsuDivID=0) {
			set rtn=2608
			quit
		}
		//每张发票都分别提交
		set myPrtRowID=$p(myINVInfo,"^",4)
		//验证医保总额分解是否正确
		set myPrtData=$g(^DHCINVPRT(myPrtRowID))
		set myPatShare=$p(myPrtData,"^",16)
		set myPatShare=$fn(myPatShare,"",2)
		set myPatSum=$p(myINVInfo,"^",3)
		for j=2:1:$l(myYBInv,$c(2)) {
			set myPMInfo=$p(myYBInv,$c(2),j)
			continue:(myPMInfo="")
			set myPMSum=$p(myPMInfo,"^",2)
			set myPatSum=$i(myPatSum, myPMSum)
		}
		set myPatSum=$fn(myPatSum,"",2)
		if (+myPatSum'=+myPatShare) {
			set rtn=2606					//医保分解金额错误
			set ^TMPOPCHYB(+$h,$p($h,",",2),myPrtRowID)=rtn_"^"_myYBInv
			set myYBErrlog=myYBErrlog_$c(3)_rtn_"^"_myPrtRowID
			quit:(+rtn)
		}
		//单独发票提交事务
		set rtn=..UpdateSingleINVYBInfo(myYBInv)
		if (+rtn) {
			//写入日志
			set ^TMPOPCHYB(+$h,$p($h,",",2),myPrtRowID)=myYBInv
			set myYBErrlog=myYBErrlog_$c(3)_rtn_"^"_myPrtRowID
		}
	}
	
	if (myYBErrlog'="") {
		set rtn=2607			//医保分解错误
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// 2020-05-26 Lid Modify 预结算不插入支付方式，医保结算后调用此接口时，支付方式表只插入医保支付方式，自付金额的支付方式不再此处更新或插入
ClassMethod UpdateSingleINVYBInfo(YBInv As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set myINVInfo=$p(YBInv,$c(2),1)
	set myInsuRowID=$p(myINVInfo,"^",2)
	set mySelfPaySum=$p(myINVInfo,"^",3)
	set myPRTRowID=$p(myINVInfo,"^",4)
	
	set myInvData=$g(^DHCINVPRT(myPRTRowID))
	set myPrtFlag=$p(myInvData,"^",8)             //PRT_Flag
	quit:(myPrtFlag'="TP") 2611_"^"_"非预结算收费记录，不能保存医保支付信息"      //+2023-04-07 ZhYW
	
	set myPatShare=$p(myInvData,"^",16)           //PRT_PatientShare
	set insuPaySum=myPatShare-mySelfPaySum        //医保支付金额
	set myInsuDivDR=$p(myInvData,"^",30)          //PRT_InsDiv_DR
	quit:(+myInsuDivDR'=0) 2610_"^"_"已有医保结算信息，不能重复保存"   //+2023-04-07 ZhYW
	
	set myFairType=$p(myInvData,"^",34)           //PRT_FairType (F:发票，R:挂号)
	if ((myFairType="F")&&(+myInsuRowID=0)) {     //2015-12-24 Lid 挂号时可能传空，所以只过滤收费记录
		quit 2608_"^"_"医保结算Id为空，不能保存"
	}
	
	//2020-09-28 ZhYW 验证医保结算RowId是否重复
	if (+myInsuRowID'=0)&&($d(^DHCINVPRT(0,"INSDIV",myInsuRowID))) {
		quit 2609_"^"_"医保结算Id已保存，不能重复保存"
	}
	
	ts

	&SQL(
		UPDATE DHC_INVPRT
		SET PRT_InsDiv_DR = :myInsuRowID, PRT_YBPaySum = :insuPaySum, PRT_InvkInsuDivFlag = 'Y'
		WHERE %ID = :myPRTRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	set myCurDate=+$h
	set myCurTime=$p($h,",",2)	  //这里先取当前系统日期，也可以取发票日期。
	//增加医保支付模式
	for myIdx=2:1:$l(YBInv,$c(2)) {
		set myPMInfo=$p(YBInv,$c(2),myIdx)
		continue:(myPMInfo="")
		set myPMDR=$p(myPMInfo,"^",1)
		set myPMSum=$p(myPMInfo,"^",2)
		&SQL(
			INSERT INTO DHC_INVPayMode (
				IPM_PRT_ParRef, IPM_PayMode_DR, IPM_Amt, IPM_Date, IPM_Time
			)
			VALUES (
				:myPRTRowID, :myPMDR, :myPMSum, :myCurDate, :myCurTime
			)
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

/// Description: 如果是卡支付,要删除支付记录,并把金额返回账户
ClassMethod CancelAccountPay(myPRTRowID As %String) As %String
{
	set rtn=0
	quit:(myPRTRowID="") rtn
	
	set paymSub=0
	while(($o(^DHCINVPRT(myPRTRowID,"P",paymSub)))) {
		set paymSub=$o(^DHCINVPRT(myPRTRowID,"P",paymSub))
		set paymSubData=$g(^DHCINVPRT(myPRTRowID,"P",paymSub))
		set myAmt=+$p(paymSub,"^",3)
		set myAccPLDR=$p(paymSub,"^",8)
		continue:(myAccPLDR="")
		&SQL(DELETE FROM DHC_AccPayList WHERE %ID = :myAccPLDR)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set myAccMRowID=$p(myAccPLDR,"||",1)
		set myAccLeft=$p(^DHCACD("AccM",myAccMRowID),"^",8)
		set myAccLeft=myAccLeft+myAmt
		&SQL(
			UPDATE DHC_AccManager
			SET AccM_Balance = :myAccLeft
			WHERE %ID = :myAccMRowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	quit rtn
}

/// Lid
/// 2015-01-13
/// Description: HIS回滚时，把留观押金支付的金额返回到留观押金表中
ClassMethod CancelEPMPay(myPRTRowID As %String) As %String
{
	set rtn=0
	quit:(myPRTRowID="") rtn
	
	set paymSub=0
	while(($o(^DHCINVPRT(myPRTRowID,"P",paymSub)))) {
		set paymSub=$o(^DHCINVPRT(myPRTRowID,"P",paymSub))
		set paymSubData=$g(^DHCINVPRT(myPRTRowID,"P",paymSub))
		set myAmt=+$p(paymSub,"^",3)
		set myEPMPLDR=$p(paymSub,"^",14)
		continue:(myEPMPLDR="")
		&SQL(DELETE FROM DHC_EPPayList WHERE %ID = :myEPMPLDR)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set myEPMRowID=$p(myEPMPLDR,"||",1)
		set myAccLeft=$p(^DHCEPM("EPM",myEPMRowID),"^",9)
		set myAccLeft=myAccLeft+myAmt
		&SQL(
			UPDATE DHC_EPManager
			SET EPM_Balance = :myAccLeft
			WHERE %ID = :myEPMRowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	
	quit rtn
}

/// Lid
/// 2011-03-07
/// Description: 根据医保组返回值，汇总医保支付额(只汇总医保结算成功的记录)
/// Debug: w ##class(web.DHCBillCons11).GetYBAmtSum(^PPP("YBInfo"))
ClassMethod GetYBAmtSum(YBInfo As %String) As %String
{
	s YBInvInfo=$p(YBInfo,"|",1)
	s PreDepInfo=$p(YBInfo,"|",2)
	s myYBPaySum=0,rtn=0,InvStr="",myYBErrlog=""
	s myInvlen=$l(YBInvInfo,$c(3))
	f i=1:1:myInvlen  d
	.s myYBInv=$p(YBInvInfo,$c(3),i)
	.q:(myYBInv="")
	.s myINVInfo=$p(myYBInv,$c(2),1)
	.s rtn=+$p(myINVInfo,"^",1)
	.q:rtn
	.;每张发票都分别提交
	.s myPRTRowID=$p(myINVInfo,"^",4)
	.i (InvStr="") s InvStr=myPRTRowID
	.e  s InvStr=InvStr_"^"_myPRTRowID
	.;验证医保总额分解是否正确
	.s myPatShare=+$p(^DHCINVPRT(myPRTRowID),"^",16)
	.s myPatSum=+$p(myINVInfo,"^",3)
	.s myCurYBPaySum=+myPatShare-$g(myPatSum)
	.s myPlen=$l(myYBInv,$c(2))
	.f j=2:1:myPlen d
	..s myPMInfo=$p(myYBInv,$c(2),j)
	..q:(myPMInfo="")
	..s myPMSum=+$p(myPMInfo,"^",2)
	..s myPatSum=+myPatSum+myPMSum
	.s myPatShare=$fn(myPatShare,"",2)
	.s myPatSum=$fn(myPatSum,"",2)
	.i (myPatSum'=myPatShare) d
	..s rtn=2606					   ;医保分解金额错误
	..s ^TMPOPCHYB(+$h,$p($h,",",2),myPRTRowID)=rtn_"^"_myYBInv
	..s myYBErrlog=$g(myYBErrlog)_$c(3)_rtn_"^"_myPRTRowID
	.q:(myPatSum'=myPatShare)
	.s myYBPaySum=$g(myYBPaySum)+myCurYBPaySum
	
	s:(myYBErrlog'="") rtn=2606
	
	q rtn_$c(4)_myYBErrlog_$c(4)_myYBPaySum
}

/// Creator: Lid
/// CreatDate: 2014-10-23
/// Description: 判断医保结算是否成功
/// Return: 0:医保结算成功，其他：医保结算失败或非医保病人
/// Debug: w ##class(web.DHCBillCons11).CheckYBCharge(4120148)
ClassMethod CheckYBCharge(prtRowID As %String) As %String
{
	set rtn=1
	quit:'$d(^DHCINDIV(0,"DHCInvPrt",prtRowID)) rtn	//非医保结算
	set tmp=##class(web.DHCINSUPort).CheckINSUDivFlag(prtRowID, "", "", "", "N")
	set flag=$p(tmp,"!",1)
	if (flag="Y") {
		set rtn=0
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-08-14
/// Description: 实现退费失败或退费再收失败时的回滚。
/// Input: AbortPrtRowID:负记录RowID,NewPrtRowID:新生成的记录RowID,GroupDR:安全组RowID,ExpStr:扩展参数
/// Return: 0：回退成功，非0：回退不成功
/// Other: w ##class(web.DHCBillCons11).DelRefundInvPrt(8515,8516,239,"")
ClassMethod DelRefundInvPrt(AbortPrtRowID As %String, NewPrtRowID As %String, GroupDR As %String = "", ExpStr As %String = "") As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set myReportsDR=$p(^DHCINVPRT(AbortPrtRowID),"^",6)
	set:(myReportsDR'="") rtn=111			//结算过的发票不能删除
	set OldInvPrtDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	//PRT_initInv_DR
	set myBCIStr="", myPBRStr="", InvAdmStr=""
	//删除新生成的正票记录
	if (+NewPrtRowID'=0) {
		set myBCIRowID=0
		while($o(^DHCBCI(0,"INV",NewPrtRowID,myBCIRowID))) {
			set myBCIRowID=$o(^DHCBCI(0,"INV",NewPrtRowID,myBCIRowID))
			set myBCIData=$g(^DHCBCI(myBCIRowID))
			set myPBRowID=$p(myBCIData,"^",2)
			set myAdm=$p(myBCIData,"^",3)
			set myBCIStr=myBCIStr_myBCIRowID_"^"
			set myPBRStr=myPBRStr_myPBRowID_"^"
			set InvAdmStr=InvAdmStr_myAdm_"^"
		}
	}
	
	//负票记录
	set myBCIRowID=0
	while($o(^DHCBCI(0,"INV",AbortPrtRowID,myBCIRowID))) {
		set myBCIRowID=$o(^DHCBCI(0,"INV",AbortPrtRowID,myBCIRowID))
		set myBCIData=$g(^DHCBCI(myBCIRowID))
		set myPBRowID=$p(myBCIData,"^",2)
		set myBCIStr=$s((myBCIStr=""):myBCIRowID,1:(myBCIStr_"^"_myBCIRowID))
		set myPBRStr=$s((myPBRStr=""):myPBRowID,1:(myPBRStr_"^"_myPBRowID))
	}
	
	ts

	//删除账单
	set mylen=$l(myPBRStr,"^")
	for i=1:1:mylen {
		set myPBRowID=$p(myPBRStr,"^",i)
		continue:(myPBRowID="")
		&SQL(DELETE FROM DHC_PatientBill WHERE %ID = :myPBRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	//删除连接表
	set mylen=$l(myBCIStr,"^")
	for i=1:1:mylen {
		set myBCIRowID=$p(myBCIStr,"^",i)
		continue:(myBCIRowID="")
		&SQL(DELETE FROM DHC_BillConINV WHERE %ID = :myBCIRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	//删除新发票记录->删除负票记录
	set INVStr=AbortPrtRowID_"^"_NewPrtRowID
	set mylen=$l(INVStr,"^")
	for i=mylen:-1:1 {
		set myPRTRowID=$p(INVStr,"^",i)
		continue:(myPRTRowID="")
		set myPrtData=$g(^DHCINVPRT(myPRTRowID))
		set myPrtINV=$p(myPrtData,"^",14)
		set myUserDR=$p(myPrtData,"^",21)
		&SQL(DELETE FROM DHC_INVPRT WHERE %ID = :myPRTRowID)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		//修复当前的发票号码
		continue:(myPrtINV="")
		set myINVRowID=0
		while($o(^DHCINVOICE(0,"USER",myUserDR,myINVRowID))) {
			set myINVRowID=$o(^DHCINVOICE(0,"USER",myUserDR,myINVRowID))
			set myINVData=$g(^DHCINVOICE(myINVRowID))
			set myBegINV=$p(myINVData,"^",1)
			set myEndINV=$p(myINVData,"^",2)
			set myLastINV=$p(myINVData,"^",6)
			set myINVType=$p(myINVData,"^",8)
			set myPreABC=$p(myINVData,"^",16)
			set myNumPRTINV=$e(myPrtINV,$l(myPreABC)+1,$l(myPrtINV))
			continue:(myINVType'="O")		  //不是门诊发票
			continue:'((+myBegINV<=+myNumPRTINV)&&(+myNumPRTINV<=+myEndINV))
			if '(+myLastINV=(+myNumPRTINV+1)) {
				//如果不是最后一张发票报错，不能办理删除
				set rtn=110
				quit:(+rtn)
			}			
			set rtn=##class(web.udhcOPBill).UpdateReceipNO(myUserDR, myNumPRTINV, GroupDR)
			quit:(+rtn)
		}
	}
	if (+rtn) tro  quit rtn
	
	//更新原发票的对应的医嘱记录
	set myOldPBRStr=""
	set myOldBCIRowID=0
	while($o(^DHCBCI(0,"INV",OldInvPrtDR,myOldBCIRowID))) {
		set myOldBCIRowID=$o(^DHCBCI(0,"INV",OldInvPrtDR,myOldBCIRowID))
		set myOldPBRowID=$p(^DHCBCI(myOldBCIRowID),"^",2)
		continue:(myOldPBRowID="")
		set myOldPBRStr=myOldPBRStr_myOldPBRowID_"^"
	}
	
	for i=1:1:myOldPBRStr {
		set myPBDR=$p(myOldPBRStr,"^",i)
		continue:(myPBDR="")
		/*
		set myPBOriginalBillDR=$p(^DHCPB(myPBDR),"^",18)	   //PB_OriginalBill_DR
		&SQL(DELETE FROM DHC_PatientBill WHERE %ID = :myPBOriginalBillDR)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		*/
		&SQL(
			UPDATE DHC_PatientBill
			SET PB_RefundFlag = NULL, PB_OriginalBill_DR = NULL
			WHERE %ID = :myPBDR
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set OldPBO=0
		while($o(^DHCPB(myPBDR,"O",OldPBO))) {
			set OldPBO=$o(^DHCPB(myPBDR,"O",OldPBO))
			set OldPBOData=$g(^DHCPB(myPBDR,"O",OldPBO))
			continue:(OldPBOData="")
			set OldPBORowID=myPBDR_"||"_OldPBO
			set myOldOEORIDR=$p(OldPBOData,"^",4)
			set rtn=..ResumeStopOEORI(myOldOEORIDR, OldPBORowID)
			quit:(+rtn)
			set $p(^OEORD(+myOldOEORIDR,"I",$p(myOldOEORIDR,"||",2),1),"^",16)=OldPBORowID
			set $p(^OEORD(+myOldOEORIDR,"I",$p(myOldOEORIDR,"||",2),3),"^",5)="P"
		}
	}
	if (+rtn) tro  quit rtn
	
	//wangjian 2019-06-14 删除多余拆分出来账单 防止102
	for j=1:1:$l(InvAdmStr,"^") {
		set InvAdm=$p(InvAdmStr,"^",j)
		continue:(+InvAdm=0)
		set myPBRowID=0
		while($o(^DHCPB(0,"ADM",InvAdm,myPBRowID))) {
			set myPBRowID=$o(^DHCPB(0,"ADM",InvAdm,myPBRowID))
			set myPBData=$g(^DHCPB(myPBRowID))
			set myPayedFlag=$p(myPBData,"^",16)
			continue:(myPayedFlag'="B")
			set DisChargeD=$p(myPBData,"^",3)
			continue:(DisChargeD="")
			do ##class(web.UDHCJFBaseCommon).DelPBONullData(myPBRowID)
			&SQL(DELETE FROM DHC_PatientBill WHERE %ID = :myPBRowID)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
	}
	if (+rtn) tro  quit rtn
	
	//修改卡支付的相应数据处理
	set INVStr=NewPrtRowID_"^"_AbortPrtRowID
	set mylen=$l(INVStr,"^")
	for i=1:1:mylen {
		set myPRTRowID=$p(INVStr,"^",i)
		continue:(+myPRTRowID=0)
		set AccDr=0
		while($o(^DHCACDi("AccM",0,"InvPrtDR","OP",myPRTRowID,AccDr))) {
			set AccDr=$o(^DHCACDi("AccM",0,"InvPrtDR","OP",myPRTRowID,AccDr))
			lock +^DHCACD("AccM",AccDr):5
			if ('$test) {
				set rtn=rtn_"^"_"账户："_AccDr_"被锁定"
				quit
			}
			set AccPaySum=0
			set AccPLSub=0
			while($o(^DHCACDi("AccM",0,"InvPrtDR","OP",myPRTRowID,AccDr,"AccPL",AccPLSub))) {
				set AccPLSub=$o(^DHCACDi("AccM",0,"InvPrtDR","OP",myPRTRowID,AccDr,"AccPL",AccPLSub))
				set AccPLData=$g(^DHCACD("AccM",AccDr,"AccPL",AccPLSub))
				set AccPLRowID=AccDr_"||"_AccPLSub
				set AccPayAmt=$p(AccPLData,"^",8)
				set AccPaySum=AccPaySum+AccPayAmt
				&SQL(DELETE FROM DHC_AccPayList WHERE %ID = :AccPLRowID)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			if (+rtn) {
				lock -^DHCACD("AccM",AccDr)
				quit
			}
			if (+AccPaySum'=0) {
				set rtn=##class(web.DHCACPayList).UpdateAM(AccDr, AccPaySum)
			}
			lock -^DHCACD("AccM",AccDr)
		}
	}
	if (+rtn) tro  quit rtn
	
	if ((+NewPrtRowID'=0)&&($d(^DHCPHARi("PRT",NewPrtRowID)))) {
		&SQL(DELETE FROM DHC_PHARWIN WHERE PHA_PRT_DR = :NewPrtRowID)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	&SQL(
		UPDATE DHC_INVPRT
		SET PRT_Flag = 'N'
		WHERE %ID = :OldInvPrtDR
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//更新原发票药品中间表的退药标志
	set conRowid=0
	while($o(^DHCBCI(0,"INV",OldInvPrtDR,conRowid))) {
		set conRowid=$o(^DHCBCI(0,"INV",OldInvPrtDR,conRowid))
		set conData=$g(^DHCBCI(conRowid))
		set adm=$p(conData,"^",3)
		set pb=$p(conData,"^",2)
		kill PrescNoAry      //存处方号
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set oeitm=$p(pboData,"^",4)
			set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm, 1)
			set OrdPrescNo=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",14)
			continue:(OrdPrescNo="")
			set PrescNoAry(OrderType,OrdPrescNo)=""
		}
		set PrescNo=""
		while($o(PrescNoAry("R",PrescNo))'="") {
			set PrescNo=$o(PrescNoAry("R",PrescNo))
			continue:('$d(^DHCPHARi("PRT",OldInvPrtDR)))
			&SQL(
				UPDATE DHC_PHARWIN
				SET PHA_NOUSER = NULL
				WHERE PHA_PRT_DR = :OldInvPrtDR AND PHa_PrescNo = :PrescNo
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
	}
	if (+rtn)  tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: wangjian
/// CreatDate: 2019-06-14
/// Description: 恢复医嘱
/// Debug: w ##class(web.DHCBillCons11).ResumeStopOEORI("30844796||7",")
ClassMethod ResumeStopOEORI(StopOEORI As %String, PBORowID As %String) As %String
{
	set Rtn=0
	quit:(+StopOEORI=0) Rtn
	quit:(StopOEORI'["||") Rtn
	set StopStatus=$o(^OEC("OSTAT",0,"Code","D",""))
	set OEORIStatus=$p(^OEORD(+StopOEORI,"I",$p(StopOEORI,"||",2),1),"^",13)
	quit:(OEORIStatus'=StopStatus) Rtn
	
	set OldSTStatusDR=""
	set TMPSTChildsub=""
	for  set TMPSTChildsub=$o(^OEORD(+StopOEORI,"I",$p(StopOEORI,"||",2),"ST",TMPSTChildsub),-1) quit:((TMPSTChildsub="")||(OldSTStatusDR'=""))  do
	.quit:(+TMPSTChildsub=0)
	.set TMPSTStatusDR=$p(^OEORD(+StopOEORI,"I",$p(StopOEORI,"||",2),"ST",TMPSTChildsub),"^",3)
	.quit:(StopStatus=TMPSTStatusDR)
	.set OldSTStatusDR=TMPSTStatusDR
	
	if (OldSTStatusDR="") do
	.set OldSTStatusDR=$o(^OEC("OSTAT",0,"Code","V",""))

	&SQL(
		UPDATE OE_OrdItem
		SET OEORI_Billed = 'P', OEORI_ItemStat_DR = :OldSTStatusDR,
		 	OEORI_ARPBLItem_DR = :PBORowID, OEORI_XDate = NULL, OEORI_XTime = NULL, OEORI_XCTCP_DR = NULL 
		WHERE OEORI_RowId = :StopOEORI
	)
	set Rtn=SQLCODE
	quit:(+Rtn) Rtn_"^"_$g(%msg)
	;考虑库存等问题 根据各家医院实际情况
	
	quit Rtn
}

}
