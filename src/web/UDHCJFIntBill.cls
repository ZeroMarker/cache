Import SQLUser

Class web.UDHCJFIntBill Extends BILL.COM.Abstract
{

/// Description: 住院取消拆分账单
/// Debug: w ##class(web.UDHCJFIntBill).DINBILL()
ClassMethod DINBILL(BILL As %String, USER As %String) As %String
{
	set $zt="ERROR"

    quit:(+BILL=0) -1_"^"_"参数错误"
    
    set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(BILL)
	quit:(isCloseAcount="Y") -1_"^"_"账单已封账，不能合并"
	
	set PBData=$g(^DHCPB(BILL))
	set Adm=$p(PBData,"^",1)          //PB_Adm_Dr
	set payedFlag=$p(PBData,"^",16)
	quit:(payedFlag="P") -1_"^"_"账单已结算，不能合并"
	
	set insuUpFlag=##class(web.DHCIPBillCashier).JudgePBInsuUpFlag(BILL, "")
	quit:(+insuUpFlag>0) -1_"^"_"该账单已"_$case(insuUpFlag,1:"医保上传",2:"医保结算",:"")_"，不能合并"
	
	set OldBill=$p(PBData,"^",18)
	quit:((OldBill="")||('$d(^DHCPB(OldBill)))) -1_"^"_"不存在原账单，不能合并"
	
	quit:($p(^DHCPB(OldBill),"^",16)="P") -1_"^"_"原账单已结算，不能合并"
	
	set oldInsuUpFlag=##class(web.DHCIPBillCashier).JudgePBInsuUpFlag(OldBill, "")
	quit:(oldInsuUpFlag>0) -1_"^"_"该账单已"_$case(oldInsuUpFlag,1:"医保上传",2:"医保结算",:"")_"，不能合并"
	
	//根据DHC_PatBillDetails表的条数判断是否锁表
	set isNoLock=##class(web.UDHCJFBaseCommon).IsNoLockTable(Adm, BILL, "")
	
	set TotalAmount=0
	set DiscAmount=0
	set PayorAmount=0
	set PatientAmount=0

	set rtn=0
	
	ts
	
	set PBO=0
	while($o(^DHCPB(BILL,"O",PBO))) {
		set PBO=$o(^DHCPB(BILL,"O",PBO))
		set PBOData=$g(^DHCPB(BILL,"O",PBO))
		continue:(PBOData="")
		set PBORowID=BILL_"||"_PBO
		set oeore=$p(PBOData,"^",20)
		set pboTotalAmount=$p(PBOData,"^",8)
		set pboDiscAmount=$p(PBOData,"^",9)
		set pboPayorShare=$p(PBOData,"^",10)
		set pboPatientShare=$p(PBOData,"^",11)
		set TotalAmount=$i(TotalAmount, pboTotalAmount)
		set DiscAmount=$i(DiscAmount, pboDiscAmount)
		set PayorAmount=$i(PayorAmount, pboPayorShare)
		set PatientAmount=$i(PatientAmount, pboPatientShare)
		if (isNoLock'="NoLock") {
			set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillOrder(PBORowID, OldBill)
		}else {
			set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillOrder(PBORowID, OldBill)
		}
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set NewPBORowID=$p(rtnValue,"^",2)
		set $p(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3),"BILL"),"^",2)=NewPBORowID
		set PBD=0
		while($o(^DHCPB(BILL,"O",PBO,"D",PBD))) {
			set PBD=$o(^DHCPB(BILL,"O",PBO,"D",PBD))
			set PBDRowID=BILL_"||"_PBO_"||"_PBD
			if (isNoLock'="NoLock") {
				set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillDetails(PBDRowID, NewPBORowID)
			}else {
				set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillDetails(PBDRowID, NewPBORowID)
			}
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		quit:(+rtn)
		if (isNoLock'="NoLock") {
			&SQL(DELETE FROM DHC_PatBillOrder WHERE %ID = :PBORowID)
		}else {
			&SQL(DELETE %NOLOCK %NOCHECK FROM DHC_PatBillOrder WHERE %ID = :PBORowID)
		}
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	//取账单的开始日期、结束日期
	//规则：将俩账单开始日期较小者作为合并后的账单的开始日期，将俩账单结束日期较大者作为合并后的账单的结束日期
	set fPBData=$g(^DHCPB(BILL))
	set fDateFrom=$p(fPBData,"^",6)    //PB_DateFrom
	set fDateTo=$p(fPBData,"^",7)      //PB_DateTo
	
	set tPBData=$g(^DHCPB(OldBill))
	set tDateFrom=$p(tPBData,"^",6)
	set tDateTo=$p(tPBData,"^",7)
	set tPBTotalAmount=$p(tPBData,"^",8)
	set tPBDiscAmount=$p(tPBData,"^",9)
	set tPBPayorShare=$p(tPBData,"^",11)
	set tPBPatientShare=$p(tPBData,"^",12)
	set DateFrom=$s((fDateFrom>tDateFrom):tDateFrom,1:fDateFrom)
	set DateTo=$s((fDateTo<tDateTo):tDateTo,1:fDateTo)
	if (DateFrom=0) set DateFrom=""
	if (DateTo=0) set DateTo=""
	set TotalAmount=$i(TotalAmount, tPBTotalAmount)
	set DiscAmount=$i(DiscAmount, tPBDiscAmount)
	set PayorAmount=$i(PayorAmount, tPBPayorShare)
	set PatientAmount=$i(PatientAmount, tPBPatientShare)
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_DateFrom = :DateFrom, PB_DateTo = :DateTo, PB_TotalAmount = :TotalAmount, PB_DiscAmount = :DiscAmount, PB_PayorShare = :PayorAmount,
			PB_PatientShare = :PatientAmount, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :USER
		WHERE %ID = :OldBill
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	&SQL(DELETE FROM DHC_PatientBill WHERE %ID = :BILL)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	set ^DHCBillCancelOld(+$h,BILL)=Adm
	set rtn=##class(web.UDHCJFBillDetailOrder).ConfirmByAdm(Adm, USER, "取消拆分账单", "C")
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Description: 门诊重新生成账单
/// Input: iDateStr: 账单的开始日期^账单的结束日期, OldPBOStr: DHC_PatBillOrder.RowId串
/// 	   InsTypeId: PAC_AdmReaon.RowId, ReBillFlag: 收费退费标识(0:收费, 1:退费)
ClassMethod RINBILL(OldBill As %String, iDateStr As %String, OldPBOStr As %String, UserId As %String, InsTypeId As %String, ReBillFlag As %String) As %String
{
	set $zt="ERROR"
	
	quit:(+OldBill=0) -1_"^"_"参数错误"
	
	set iDateFrom=$p(iDateStr,"^",1)
	set iDateTo=$p(iDateStr,"^",2)
	if ((iDateFrom="")&&(iDateTo="")&&(OldPBOStr="")&&(InsTypeId="")) quit -1_"^"_"参数错误"
	
	set OldPBData=$g(^DHCPB(OldBill))
	set Adm=$p(OldPBData,"^",1)
	set payedFlag=$p(OldPBData,"^",16)
	quit:(payedFlag="P") -1_"^"_"账单已结算"
	set OldDateF=$p(OldPBData,"^",6)
	set OldDateT=$p(OldPBData,"^",7)

	if (iDateFrom="") set iDateFrom=OldDateF
	if (iDateTo="") set iDateTo=OldDateT
	if ((OldPBOStr="")&&(InsTypeId="")&&(iDateFrom<OldDateF)&&(iDateTo>OldDateT)) quit 0_"^"_OldBill
	
	set Count=0
	set PBO=0
	while($o(^DHCPB(OldBill,"O",PBO))) {
		set PBO=$o(^DHCPB(OldBill,"O",PBO))
		set PBOData=$g(^DHCPB(OldBill,"O",PBO))
		continue:(PBOData="")
		set OldPBORowID=OldBill_"||"_PBO
		set OrdDate=$p(PBOData,"^",12)
		if ((OrdDate<iDateFrom)||(OrdDate>iDateTo)) {
			set Count=$i(Count)
			quit
		}
		if ((OldPBOStr'="")&&(("^"_OldPBOStr_"^")'[("^"_OldPBORowID_"^"))) {
			set Count=$i(Count)
			quit
		}
	}
	quit:(Count=0) 0_"^"_OldBill   //Count=0时，不需要拆分账单
	
	if ((InsTypeId'="")&&(ReBillFlag=0)) {
		set rtn=##class(web.UDHCJFREBILL1).REBILLOP(Adm, OldBill, InsTypeId)
		quit:(+rtn) rtn
	}
	
    ts
	
	//create a new bill
 	set rtn=##class(web.UDHCJFPB).PBINS(Adm, UserId)
 	if (+rtn) tro  quit rtn
	set NewBill=$p(rtn,"^",2)
	
	set TotalAmount=0
	set DiscAmount=0
	set PayorAmount=0
	set PatientAmount=0
	set DateFrom=+$h
	set DateTo=0
	set OldDateFrom=+$h
	set OldDateTo=0
	
	set PBO=0
	while($o(^DHCPB(OldBill,"O",PBO))) {
		set PBO=$o(^DHCPB(OldBill,"O",PBO))
		set PBOData=$g(^DHCPB(OldBill,"O",PBO))
		continue:(PBOData="")
		set OldPBORowID=OldBill_"||"_PBO
		set oeitm=$p(PBOData,"^",4)
		set OrdDate=$p(PBOData,"^",12)
		set pboTotalAmount=$p(PBOData,"^",8)
		set pboDiscAmount=$p(PBOData,"^",9)
		set pboPayorShare=$p(PBOData,"^",10)
		set pboPatientShare=$p(PBOData,"^",11)
		if ((OrdDate<iDateFrom)||(OrdDate>iDateTo)) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((OldPBOStr'="")&&(("^"_OldPBOStr_"^")'[("^"_OldPBORowID_"^"))) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if (OrdDate>DateTo) set DateTo=OrdDate
		if ((+OrdDate'=0)&&(OrdDate<DateFrom)) set DateFrom=OrdDate
		
		set TotalAmount=$i(TotalAmount, pboTotalAmount)
		set DiscAmount=$i(DiscAmount, pboDiscAmount)
		set PayorAmount=$i(PayorAmount, pboPayorShare)
		set PatientAmount=$i(PatientAmount, pboPatientShare)

		set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillOrder(OldPBORowID, NewBill)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set NewPBORowID=$p(rtnValue,"^",2)		
		set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",16)=NewPBORowID
		set PBD=0
		while($o(^DHCPB(OldBill,"O",PBO,"D",PBD))) {
			set PBD=$o(^DHCPB(OldBill,"O",PBO,"D",PBD))
			set PBDData=$g(^DHCPB(OldBill,"O",PBO,"D",PBD))
			set OldPBDRowID=OldBill_"||"_PBO_"||"_PBD
			set ArtiDR=$p(PBDData,"^",26)   //多部位检查申请单中间表指针
			set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillDetails(OldPBDRowID, NewPBORowID)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
			//+2021-04-23 ZhYW 将DHC_AppRepTarItm.ARTI_PBO_Dr 更新为新账单医嘱表指针
			if (ArtiDR'="") {
				&SQL(
					UPDATE DHC_AppRepTarItm
					SET ARTI_PBO_Dr = :NewPBORowID
					WHERE %ID = :ArtiDR
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
		}
		quit:(+rtn)
		&SQL(DELETE FROM DHC_PatBillOrder WHERE %ID = :OldPBORowID)
	    set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if (DateFrom=0) set DateFrom=""
	if (DateTo=0) set DateTo=""
	
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_DateFrom = :DateFrom, PB_DateTo = :DateTo, PB_TotalAmount = :TotalAmount, PB_DiscAmount = :DiscAmount, PB_PayorShare = :PayorAmount,
			PB_PatientShare = :PatientAmount, PB_OriginalBill_DR = :OldBill, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :UserId
		WHERE %ID = :NewBill
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if (OldDateFrom=0) set OldDateFrom=""
	if (OldDateTo=0) set OldDateTo=""
	
	set PBData=$g(^DHCPB(OldBill))
	set PBTotalAmount=$p(PBData,"^",8)
	set PBDiscAmount=$p(PBData,"^",9)
	set PBPayorShare=$p(PBData,"^",11)
	set PBPatientShare=$p(PBData,"^",12)
	
	set PBTotalAmount=PBTotalAmount-TotalAmount
	set PBDiscAmount=PBDiscAmount-DiscAmount
	set PBPayorShare=PBPayorShare-PayorAmount
	set PBPatientShare=PBPatientShare-PatientAmount
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_DateFrom = :OldDateFrom, PB_DateTo = :OldDateTo, PB_TotalAmount = :PBTotalAmount, PB_DiscAmount = :PBDiscAmount, PB_PayorShare = :PBPayorShare,
			PB_PatientShare = :PBPatientShare, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :UserId
		WHERE %ID = :OldBill
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ((InsTypeId'="")&&(ReBillFlag=0)) {
		set rtn=##class(web.UDHCJFREBILL1).REBILLOP(Adm, NewBill, InsTypeId)
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc

	quit rtn_"^"_NewBill

ERROR
	quit ..AppException()
}

/// Description: 计算按条件拆分的金额
/// Debug: w ##class(web.UDHCJFIntBill).ComputingCOM("27742","")
ClassMethod ComputingCOM(Bill As %String, RulesStr As %String, SessionStr As %String) As %String
{
	set ^TMP("ComputingCOM")=$lb(Bill, RulesStr, SessionStr)
	quit:(Bill="") 0
	
	set userId=$p(SessionStr,"^",1)
	set groupId=$p(SessionStr,"^",2)
	set ctLocId=$p(SessionStr,"^",3)
	set hospId=$p(SessionStr,"^",4)

	set RulesO=##class(%DynamicObject).%FromJSON(RulesStr)
	set iDateFrom=##class(websys.Conversions).DateHtmlToLogical(RulesO.DateFrom)
	set iDateTo=##class(websys.Conversions).DateHtmlToLogical(RulesO.DateTo)
	set iTimeFrom=##class(websys.Conversions).TimeHtmlToLogical(RulesO.TimeFrom, 1)
	set iTimeTo=##class(websys.Conversions).TimeHtmlToLogical(RulesO.TimeTo, 1)
	if ((iDateTo'="")&&(RulesO.FullFlag=0)) set iDateTo=iDateTo-1
	
	set Adm=$p($g(^DHCPB(Bill)),"^",1)
	set pilotRtn=##class(web.PilotProject.DHCDocPilotService).IIsPilotInAdmTwo(Adm, "I")
	set IsPilotInAdm=$p(pilotRtn,"^",1)
		
	set sum=0
	set PBO=0
	while($o(^DHCPB(Bill,"O",PBO))) {
		set PBO=$o(^DHCPB(Bill,"O",PBO))
		set PBOData=$g(^DHCPB(Bill,"O",PBO))
		continue:(PBOData="")
		set PBORowID=Bill_"||"_PBO
		set patshare=+$p(PBOData,"^",8)
		set oeore=$p(PBOData,"^",20)
		set oeitm=$p(PBOData,"^",4)
		set arcim=$p(PBOData,"^",3)
		set ordSubCatDR=$p(^ARCIM(+arcim,1,1),"^",10)
		set ordCatDR=$p(^ARC("IC",ordSubCatDR),"^",8)
		set ordDeptDR=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",3)    //OEORI_OrdDept_DR 下医嘱就诊科室
		set oeAdm=$p(^OEORD(+oeitm),"^",1)
		set OrdDatTime=..GetFstBillDateTime(PBORowID)   //+2022-05-06 ZhYW
		set OrdDate=$p(OrdDatTime,"^",1)
		set OrdTime=$p(OrdDatTime,"^",2)
		//Lid 2014-12-31 按是否为临床药理试验拆分账单
		if (RulesO.PilotFlag=1) {
			//adm上存临床药理试验时，不用判断医嘱上的指针
			if (IsPilotInAdm'=1) {
				set pilotRtn=##class(web.DHCBillPilot).IsPilotOrdItem(oeitm, "")
				set pilotFlag=$p(pilotRtn,"^",1)
			}
			if (pilotFlag'="Y") {
				continue
			}
		}
		if ((RulesO.BabyAdm'="")&&(RulesO.BabyAdm'=oeAdm)) {
			continue
		}
		if ((OrdDate<iDateFrom)||((OrdDate>iDateTo)&&(iDateTo'=""))) {
			continue
		}
		if ((OrdDate=iDateFrom)&&(OrdTime<iTimeFrom)&&(iTimeFrom'="")) {
			continue
		}
		if ((OrdDate=iDateTo)&&(OrdTime>iTimeTo)&&(iTimeTo'="")) {
			continue
		}
		if ((RulesO.OrdDeptId'="")&&(RulesO.OrdDeptId'=ordDeptDR)) {
			continue
		}
		if ((RulesO.OrdCatStr'="")&&(("^"_RulesO.OrdCatStr_"^")'[("^"_ordCatDR_"^"))) {
			continue
		}
		if ((RulesO.OrdSubCatStr'="")&&(("^"_RulesO.OrdSubCatStr_"^")'[("^"_ordSubCatDR_"^"))) {
			continue
		}
		if ((RulesO.ARCIMStr'="")&&(("^"_RulesO.ARCIMStr_"^")'[("^"_arcim_"^"))) {
			continue
		}
		if ((RulesO.OEORIStr'="")&&(("^"_RulesO.OEORIStr_"^")'[("^"_oeitm_"^"))) {
			continue
		}

		set sum=$i(sum, patshare)
	}
	
	quit $fn(sum,"",2)
}

/// Description: 拆分账单
/// Input: OldBill:DHC_PatientBill.RowId, SessionStr:用户Id^安全组Id^登录科室Id^院区Id
///        RulesStr: 拆分规则Json
///          Amount: 收集到的金额
/// 		 IntAmt: 按指定金额拆分(指定拆分金额)
///        	 InsTypeId: 将拆分后的新账单按该费别重新账单
/// 	     PilotFlag: 拆分临床药理
///          BabyAdm: 按婴儿就诊, OrdDeptId: 按下医嘱时的就诊科室, OrdCatStr: 按医嘱大类, OrdSubCatStr: 按医嘱子类, ARCIMStr: 按医嘱项, OEORIStr: 按医嘱
/// Debug: w ##class(web.UDHCJFIntBill).RINBILLCOM("73","^^^","","","","","","","","1","","17275^241^2^2^20","0","1679.00^1670.00")
ClassMethod RINBILLCOM(OldBill As %String, RulesStr As %String, SessionStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("RINBILLCOM")=$lb(OldBill, RulesStr, SessionStr)
	
	set userId=$p(SessionStr,"^",1)
	set groupId=$p(SessionStr,"^",2)
	set ctLocId=$p(SessionStr,"^",3)
	set hospId=$p(SessionStr,"^",4)
	
	set rtn=0
	
	set RulesO=##class(%DynamicObject).%FromJSON(RulesStr)
	
	set iDateFrom=##class(websys.Conversions).DateHtmlToLogical(RulesO.DateFrom)
	set iDateTo=##class(websys.Conversions).DateHtmlToLogical(RulesO.DateTo)
	set iTimeFrom=##class(websys.Conversions).TimeHtmlToLogical(RulesO.TimeFrom)
	set iTimeTo=##class(websys.Conversions).TimeHtmlToLogical(RulesO.TimeTo)
	if ((iDateTo'="")&&(RulesO.FullFlag=0)) set iDateTo=iDateTo-1
	
	set tgtInsTypeId=RulesO.InsTypeId   //将拆分后的新账单按该费别重新账单

	set insuUpFlag=##class(web.DHCIPBillCashier).JudgePBInsuUpFlag(OldBill, "")
	quit:(+insuUpFlag>0) -1_"^""该账单已"_$case(insuUpFlag,1:"医保上传",2:"医保结算",:"")_"，不能拆分"

	set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(OldBill)
	quit:(isCloseAcount="Y") -1_"^"_"账单已封账，不能拆分"
	
	set OldPBData=$g(^DHCPB(OldBill))
	set adm=$p(OldPBData,"^",1)
	set payedFlag=$p(OldPBData,"^",16)
	quit:(payedFlag="P") -1_"^"_"账单已结算，不能拆分账单"
	
	set OldDateF=$p(OldPBData,"^",6)
	set OldDateT=$p(OldPBData,"^",7)
	if (iDateFrom="") set iDateFrom=OldDateF
	if (iDateTo="") set iDateTo=OldDateT
	if (iDateTo="") set iDateTo=+$h
	
	set pilotRtn=##class(web.PilotProject.DHCDocPilotService).IIsPilotInAdmTwo(adm, "I")
	set IsPilotInAdm=$p(pilotRtn,"^",1)
	if (IsPilotInAdm=1) {
		do ..UpdtPilotInsType(OldBill, userId)
		quit 0_"^"_OldBill	//如果全部是临床药理医嘱，就不需要拆分账单，只更新账单费别
	}
	
	quit:((iDateFrom<OldDateF)&&(iDateTo>OldDateT)) 0_"^"_OldBill
	
    ts
	
	//Lid 2014-12-20 根据DHC_PatBillDetails表的条数判断是否锁表
	set isNoLock=##class(web.UDHCJFBaseCommon).IsNoLockTable("", OldBill, "")
	
    //add 2013-11-06 tangt 针对拆账单要拆整数的处理，这里定义一个自定义价格医嘱，在拆分账单后添加
    set newOrdStr=""
    set outOrdStr=""
	set DiffAmt=$s((+RulesO.IntAmt'=0):(RulesO.IntAmt-RulesO.Amount),1:0)  //需要插入的金额
    if ((+DiffAmt'=0)&&($zabs(DiffAmt)<=10)) {
	    set notPayedNum=##class(web.UDHCJFBaseCommon).JudgeBillNum(adm)
	    if (notPayedNum>1) {
		    tro
		    quit -1_"^"_"请先将其它未结算账单封账或结算”，否则不能按指定金额拆分账单"   //有多个未结算的账单时，插入的自定义价格医嘱无法账单，故先控制
		}
		set rtnValue=..InsertUnPriceArc(adm, DiffAmt, userId, hospId)
		set rtn=$p(rtnValue,"^",1)
	    if (+rtn) tro  quit rtnValue
		set oeoriStr=$p(rtnValue,"#",2)
	 	if (DiffAmt<0) {
			set newOrdStr=$p(oeoriStr,"^",2)
	 	}else {
			set newOrdStr=$p(oeoriStr,"^",1)
	 	}
		set outOrdStr=oeoriStr
		set rtn=##class(web.UDHCJFBILLIP).BILL(adm, userId)
		if (+rtn) tro  quit rtn
	}
    
	//这里先拆分账单，再拆分自定价医嘱的原因是如果拆账单没有选择医嘱拆分，
    //如果这里直接将自定价医嘱串在orderstr后面以后，拆分账单就会按照医嘱拆分，拆分金额不对，
    //所以拆分指定金额账单需要先按照页面选择的拆分规则先进行拆分，然后单独拆分原账单的医嘱。
	set rtn=##class(web.UDHCJFPB).PBINS(adm, userId)
	if (+rtn) tro  quit rtn
	set NewBill=$p(rtn,"^",2)
	
	set TotalAmount=0
	set DiscAmount=0
	set PayorAmount=0
	set PatientAmount=0
	set DateFrom=iDateFrom
	set DateTo=0
	set OldDateFrom=+$h
	set OldDateTo=0
	
	set PBO=0
	while($o(^DHCPB(OldBill,"O",PBO))) {
		set PBO=$o(^DHCPB(OldBill,"O",PBO))
		set PBOData=$g(^DHCPB(OldBill,"O",PBO))
		continue:(PBOData="")
		set OldPBORowID=OldBill_"||"_PBO
		set arcim=$p(PBOData,"^",3)
		set oeitm=$p(PBOData,"^",4)
		set oeAdm=$p(^OEORD(+oeitm),"^",1)
		set pboTotalAmount=$p(PBOData,"^",8)
		set pboDiscAmount=$p(PBOData,"^",9)
		set pboPayorShare=$p(PBOData,"^",10)
		set pboPatientShare=$p(PBOData,"^",11)
		set oeore=$p(PBOData,"^",20)
		set ordSubCatDR=$p(^ARCIM(+arcim,1,1),"^",10)
		set ordCatDR=$p(^ARC("IC",ordSubCatDR),"^",8)         //ARC_ItemCat.ARCIC_OrdCat_DR
		set ordDeptDR=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",3)    //OEORI_OrdDept_DR 下医嘱就诊科室
		set OrdDatTime=..GetFstBillDateTime(OldPBORowID)   //+2022-05-06 ZhYW
		set OrdDate=$p(OrdDatTime,"^",1)
		set OrdTime=$p(OrdDatTime,"^",2)
		if ((outOrdStr'="")&&(("^"_outOrdStr_"^")[("^"_oeitm_"^"))) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue               //将新插入的自定价医嘱过滤，不然后面不能按指定金额拆分
		}
		//Lid 2014-12-31 按是否为临床药理试验拆分账单
		if (RulesO.PilotFlag=1) {
			//adm上存临床药理试验时，不用判断医嘱上的指针
			if (IsPilotInAdm'=1) {
				set pilotRtn=##class(web.DHCBillPilot).IsPilotOrdItem(oeitm, "")
				set pilotFlag=$p(pilotRtn,"^",1)
			}
			if (pilotFlag'="Y") {
				if (OrdDate>OldDateTo) set OldDateTo=OrdDate
				if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
				continue
			}
		}
		if ((RulesO.BabyAdm'="")&&(RulesO.BabyAdm'=oeAdm)) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((OrdDate<iDateFrom)||((iDateTo'="")&&(OrdDate>iDateTo))) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((OrdDate=iDateFrom)&&(OrdTime<iTimeFrom)&&(iTimeFrom'="")&&(OrdTime'="")) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((OrdDate=iDateTo)&&(OrdTime>iTimeTo)&&(iTimeTo'="")&&(OrdTime'="")) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((RulesO.OrdDeptId'="")&&(RulesO.OrdDeptId'=ordDeptDR)) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((RulesO.OrdCatStr'="")&&(("^"_RulesO.OrdCatStr_"^")'[("^"_ordCatDR_"^"))) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((RulesO.OrdSubCatStr'="")&&(("^"_RulesO.OrdSubCatStr_"^")'[("^"_ordSubCatDR_"^"))) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((RulesO.ARCIMStr'="")&&(("^"_RulesO.ARCIMStr_"^")'[("^"_arcim_"^"))) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if ((RulesO.OEORIStr'="")&&(("^"_RulesO.OEORIStr_"^")'[("^"_oeitm_"^"))) {
			if (OrdDate>OldDateTo) set OldDateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
			continue
		}
		if (OrdDate>DateTo) set DateTo=OrdDate
		if ((+OrdDate'=0)&&(OrdDate<DateFrom)) set DateFrom=OrdDate
		
		set TotalAmount=$i(TotalAmount, pboTotalAmount)
		set DiscAmount=$i(DiscAmount, pboDiscAmount)
		set PayorAmount=$i(PayorAmount, pboPayorShare)
		set PatientAmount=$i(PatientAmount, pboPatientShare)
		
		if (isNoLock'="NoLock") {
			set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillOrder(OldPBORowID, NewBill)
		}else {
			set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillOrder(OldPBORowID, NewBill)
		}
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set NewPBORowID=$p(rtnValue,"^",2)
		set $p(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3),"BILL"),"^",2)=NewPBORowID  
		set PBD=0
		while($o(^DHCPB(OldBill,"O",PBO,"D",PBD))) {
			set PBD=$o(^DHCPB(OldBill,"O",PBO,"D",PBD))
			set OldPBDRowID=OldBill_"||"_PBO_"||"_PBD
			set ^DHCBillCancel(+$h,NewBill,OldPBDRowID)=adm      //记录撤销的收费项目费用明细
			if (isNoLock'="NoLock") {
				set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillDetails(OldPBDRowID, NewPBORowID)
			}else {
				set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillDetails(OldPBDRowID, NewPBORowID)
			}
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		quit:(+rtn)
		if (isNoLock'="NoLock") {
			&SQL(DELETE FROM DHC_PatBillOrder WHERE %ID = :OldPBORowID)
		}else {
			&SQL(DELETE %NOLOCK %NOCHECK FROM DHC_PatBillOrder WHERE %ID = :OldPBORowID)
		}
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn

	//遍历原账单，拆分出自定义价格医嘱
	if (newOrdStr'="") {
		set orderStr=newOrdStr
		set PBO=0
		while($o(^DHCPB(OldBill,"O",PBO))) {
			set PBO=$o(^DHCPB(OldBill,"O",PBO))
			set PBOData=$g(^DHCPB(OldBill,"O",PBO))
			continue:(PBOData="")
			set OldPBORowID=OldBill_"||"_PBO
			set arcim=$p(PBOData,"^",3)
			set oeitm=$p(PBOData,"^",4)
			set oeAdm=$p(^OEORD(+oeitm),"^",1)
			set pboTotalAmount=$p(PBOData,"^",8)
			set pboDiscAmount=$p(PBOData,"^",9)
			set pboPayorShare=$p(PBOData,"^",10)
			set pboPatientShare=$p(PBOData,"^",11)
			set oeore=$p(PBOData,"^",20)         //执行记录rowid
			set ordDeptDR=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",3)    //OEORI_OrdDept_DR 下医嘱就诊科室
			set OrdDatTime=..GetFstBillDateTime(OldPBORowID)   //+2022-05-06 ZhYW
			set OrdDate=$p(OrdDatTime,"^",1)
			set OrdTime=$p(OrdDatTime,"^",2)
			//
			if ((RulesO.BabyAdm'="")&&(RulesO.BabyAdm'=oeAdm)) {
				if (OrdDate>OldDateTo) set OldDateTo=OrdDate
				if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
				continue
			}
			if ((orderStr'="")&&(("^"_orderStr_"^")'[("^"_oeitm_"^"))) {
				if (OrdDate>OldDateTo) set OldDateTo=OrdDate
				if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
				continue
			}
			if ((RulesO.OrdDeptId'="")&&(RulesO.OrdDeptId'=ordDeptDR)) {
				if (OrdDate>OldDateTo) set OldDateTo=OrdDate
				if ((+OrdDate'=0)&&(OrdDate<OldDateFrom)) set OldDateFrom=OrdDate
				continue
			}
			if (OrdDate>DateTo) set DateTo=OrdDate
			if ((+OrdDate'=0)&&(OrdDate<DateFrom)) set DateFrom=OrdDate
			
			set TotalAmount=$i(TotalAmount, pboTotalAmount)
			set DiscAmount=$i(DiscAmount, pboDiscAmount)
			set PayorAmount=$i(PayorAmount, pboPayorShare)
			set PatientAmount=$i(PatientAmount, pboPatientShare)
			
			if (isNoLock'="NoLock") {
				set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillOrder(OldPBORowID, NewBill)
			}else {
				set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillOrder(OldPBORowID, NewBill)
			}
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
			set NewPBORowID=$p(rtnValue,"^",2)
			set $p(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3),"BILL"),"^",2)=NewPBORowID  
			set PBD=0
			while($o(^DHCPB(OldBill,"O",PBO,"D",PBD))) {
				set PBD=$o(^DHCPB(OldBill,"O",PBO,"D",PBD))
				set OldPBDRowID=OldBill_"||"_PBO_"||"_PBD
				set ^DHCBillCancel(+$h,NewBill,OldPBDRowID)=adm       //记录撤销的收费项目费用明细
				if (isNoLock'="NoLock") {
					set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillDetails(OldPBDRowID, NewPBORowID)
				}else {
					set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillDetails(OldPBDRowID, NewPBORowID)
				}
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) {
					set rtn=rtnValue
					quit
				}
			}
			quit:(+rtn)
			if (isNoLock'="NoLock") {
				&SQL(DELETE FROM DHC_PatBillOrder WHERE %ID = :OldPBORowID)
			}else {
				&SQL(DELETE %NOLOCK %NOCHECK FROM DHC_PatBillOrder WHERE %ID = :OldPBORowID)
			}
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
	}
	if (+rtn) tro  quit rtn
	
	if (DateFrom=0) set DateFrom=""
	if (DateTo=0) set DateTo=""
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_DateFrom = :DateFrom, PB_DateTo = :DateTo, PB_TotalAmount = :TotalAmount, PB_DiscAmount = :DiscAmount, PB_PayorShare = :PayorAmount,
			PB_PatientShare = :PatientAmount, PB_OriginalBill_DR = :OldBill, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :userId
		WHERE %ID = :NewBill
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//更新原账单
	if (OldDateFrom=0) set OldDateFrom=""
	if (OldDateTo=0) set OldDateTo=""
	set PBData=$g(^DHCPB(OldBill))
	set PBTotalAmount=$p(PBData,"^",8)
	set PBDiscAmount=$p(PBData,"^",9)
	set PBPayorShare=$p(PBData,"^",11)
	set PBPatientShare=$p(PBData,"^",12)
	
	set PBTotalAmount=PBTotalAmount-TotalAmount
	set PBDiscAmount=PBDiscAmount-DiscAmount
	set PBPayorShare=PBPayorShare-PayorAmount
	set PBPatientShare=PBPatientShare-PatientAmount
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_DateFrom = :OldDateFrom, PB_DateTo = :OldDateTo, PB_TotalAmount = :PBTotalAmount, PB_DiscAmount = :PBDiscAmount, PB_PayorShare = :PBPayorShare,
			PB_PatientShare = :PBPatientShare, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :userId
		WHERE %ID = :OldBill
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
    if (RulesO.PilotFlag=1) {
	 	set tgtInsTypeId=##class(web.DHCBillPilot).GetPilotAdmReason("IP")
		set rtn=..UpdtPatBillInsType(NewBill, tgtInsTypeId)   //Lid 2014-12-31 按临床药理试验拆分发票后，更新账单表的费别字段
	 	if (+rtn) tro  quit rtn
    }
    
	if (tgtInsTypeId'="") {
		set rtn=##class(web.UDHCJFREBILL1).REBILLIP(adm, NewBill, tgtInsTypeId)
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc
	
	quit rtn_"^"_NewBill

ERROR
	quit ..AppException()
}

/// Description: 查询医嘱大类
Query ordcatlookup(desc As %String, HospId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod ordcatlookupExecute(ByRef qHandle As %Binary, desc As %String, HospId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (HospId="")&&($d(%session)) {
		set HospId=%session.Get("LOGON.HOSPID")
	}
	set desc=$$ALPHAUP^SSUTIL4(desc)
	
	set rowId=0
	while($o(^OEC("ORCAT",rowId))) {
		set rowId=$o(^OEC("ORCAT",rowId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory", rowId, HospId)
		continue:(showFlag="N")
		set cateData=$g(^OEC("ORCAT",rowId))
		continue:(cateData="")
		set cateDesc=$p(cateData,"^",2)
		set aliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName("OEC_OrderCategory", rowId, desc)
		continue:((desc'="")&&($$ALPHAUP^SSUTIL4(cateDesc)'[desc)&&('aliasExistFlag))
		do OutputOrdCat
	}
 	
	quit $$$OK
    
OutputOrdCat
	set Data=$lb(rowId,cateDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 查询医嘱子类
Query ordsubcatlookup(ordCatId As %String, desc As %String, HospId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod ordsubcatlookupExecute(ByRef qHandle As %Binary, ordCatId As %String, desc As %String, HospId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (HospId="")&&($d(%session)) {
		set HospId=%session.Get("LOGON.HOSPID")
	}
 	if (desc'="") set desc=$$ALPHAUP^SSUTIL4(desc)
	
	set rowId=0
	while($o(^ARC("IC",rowId))) {
		set rowId=$o(^ARC("IC",rowId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", rowId, HospId)
		continue:(showFlag="N")
		set arcicData=$g(^ARC("IC",rowId))
		continue:(arcicData="")
		set ordCatDR=$p(arcicData,"^",8)
		continue:((ordCatId'="")&&(ordCatId'=ordCatDR))
		set arcicDesc=$p(arcicData,"^",2)
		set aliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName("ARC_ItemCat", rowId, desc)
		continue:(desc'="")&&($$ALPHAUP^SSUTIL4(arcicDesc)'[desc)&&('aliasExistFlag)
		do OutputSubcat
	}
	
	quit $$$OK
    
OutputSubcat
	set Data=$lb(rowId,arcicDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Debug: w ##class(web.UDHCJFIntBill).getarcitemalias("")
ClassMethod getarcitemalias(arcim As %String) As %String
{
	set arcalias=""
	&SQL(
		DECLARE orderc CURSOR FOR
		SELECT DISTINCT UPPER(ALIAS_Text)
		FROM ARC_ALIAS
		WHERE ALIAS_ARCIM_DR = :arcim
	)
	&SQL(OPEN orderc)
	for  &SQL(FETCH orderc INTO :alias) quit:SQLCODE  do
	.set arcalias=arcalias_" "_alias
 	&SQL(CLOSE orderc)
 	quit arcalias
}

Query arcitemlookup(BillNo As %String, ordcatid As %String, ordsubcatid As %String, desc As %String, langId As %String = "") As websys.Query(ROWSPEC = "text:%String,id:%String")
{
}

ClassMethod arcitemlookupExecute(ByRef qHandle As %Binary, BillNo As %String, ordcatid As %String, ordsubcatid As %String, desc As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	if (desc'="") set desc=$$ALPHAUP^SSUTIL4(desc)
	
	&SQL(
		DECLARE arcitem CURSOR FOR
		SELECT DISTINCT PBO_ARCIM_DR FROM DHC_PatBillOrder
		WHERE PBO_PB_ParRef = :BillNo
	)
	&SQL(OPEN arcitem)
	for  &SQL(FETCH arcitem INTO :arcim) quit:SQLCODE  do
	.set arcimdesc=$p(^ARCIM(+arcim,1,1),"^",2)
	.set arcimdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimdesc, langId)
	.set ordSubCatDR=$p(^ARCIM(+arcim,1,1),"^",10)
	.set ordCatDR=$p(^ARC("IC",ordSubCatDR),"^",8)
	.set alias=..getarcitemalias(arcim)
	.quit:((desc'="")&&(alias'[desc)&&(arcimdesc'[desc))
	.quit:((ordsubcatid'="")&&(ordsubcatid'=ordSubCatDR))
	.quit:((ordcatid'="")&&(ordcatid'=ordCatDR))
 	.do OutputArcim
 	&SQL(CLOSE arcitem)
 	
	quit $$$OK
    
OutputArcim
	set Data=$lb(arcimdesc,arcim)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFIntBill","orderlookup","")
Query orderlookup(BillNo As %String, ordcatid As %String, ordsubcatid As %String, arcimid As %String, desc As %String, langId As %String = "") As websys.Query(ROWSPEC = "orderdesc:%String,orderid:%String,orddate:%String")
{
}

ClassMethod orderlookupExecute(ByRef qHandle As %Binary, BillNo As %String, ordcatid As %String, ordsubcatid As %String, arcimid As %String, desc As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (BillNo="")  quit $$$OK
	set ^TMP("orderlookup")=$lb(BillNo, ordcatid, ordsubcatid, arcimid, desc)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	if (desc'="") set desc=$$ALPHAUP^SSUTIL4(desc)
	
	&SQL(
		DECLARE order0 CURSOR FOR
		SELECT PBO_OEORI_DR, PBO_ARCIM_DR, PBO_OrderDate FROM DHC_PatBillOrder
		WHERE PBO_PB_ParRef = :BillNo
	)
	&SQL(OPEN order0)
	for  &SQL(FETCH order0 INTO :OEORI,:arcim,:orddate) quit:SQLCODE  do
	.set arcimdesc=$p(^ARCIM(+arcim,1,1),"^",2)
	.set arcimdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimdesc, langId)
	.set ordSubCatDR=$p(^ARCIM(+arcim,1,1),"^",10)
	.set ordCatDR=$p(^ARC("IC",ordSubCatDR),"^",8)
	.set alias=..getarcitemalias(arcim)
	.quit:((desc'="")&&(alias'[desc)&&(arcimdesc'[desc))
	.quit:((arcimid'="")&&(arcimid'=arcim))
	.quit:((ordsubcatid'="")&&(ordsubcatid'=ordSubCatDR))
	.quit:((ordcatid'="")&&(ordcatid'=ordCatDR))
	.set orddate=##class(websys.Conversions).DateLogicalToHtml(+orddate)
 	.do OutputOrder
 	&SQL(CLOSE order0)

	quit $$$OK
    
OutputOrder
	set Data=$lb(arcimdesc,OEORI,orddate)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

Query Baby(BillNo As %String) As websys.Query(ROWSPEC = "Adm:%String,PatNo:%String,PatName:%String")
{
}

ClassMethod BabyExecute(ByRef qHandle As %Binary, BillNo As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	set motherAdm=$p(^DHCPB(BillNo),"^",1)
	set baby=0
	while($o(^PAADMi("Mother",motherAdm,baby))) {
		set baby=$o(^PAADMi("Mother",motherAdm,baby))
		set papmi=$p(^PAADM(baby),"^",1)
		continue:(+papmi=0)
		set papno=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
		set papname=$p($g(^PAPER(papmi,"ALL")),"^",1)
	 	do OutputBaby
	}
 	
	quit $$$OK
    
OutputBaby
	set Data=$lb(baby,papno,papname)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-06-11
/// Description: 获取维护的自定义价格医嘱
/// Input: CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFIntBill).GetIntBillArcim(2)
ClassMethod GetIntBillArcim(hospId As %String) As %String
{
	quit:$d(%IntBillArcim($this,hospId)) %IntBillArcim($this,hospId)
	set intArcim=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "IntArcimDR")
	set %IntBillArcim($this,hospId)=intArcim
	quit intArcim
}

/// Creator: ZhYW
/// CreatDate: 2020-06-11
/// Description: 判断医嘱是否是按指定金额拆分账单自定义价格医嘱
/// Input: Arcim:ARC_ItmMast.RowId, HospId:CT_Hospital.RowId
/// Return: 1: 是，0:否
/// Debug: w ##class(web.UDHCJFIntBill).JudgeArcIsorNot("2186||1", 2)
ClassMethod JudgeArcIsorNot(Arcim As %String, HospId As %String) As %String
{
	quit (..GetIntBillArcim(HospId)=Arcim)
}

/// Debug: w ##class(web.UDHCJFIntBill).InsertUnPriceArc(8, 6, 5, 2)
ClassMethod InsertUnPriceArc(Adm As %String, DiffAmt As %String, UserId As %String, HospId As %String)
{
	set rtn=0
	set IntArcim=..GetIntBillArcim(HospId)
	quit:(IntArcim="") -1_"^"_"未维护自定义价格医嘱"
	
	set AdmReason=$p(^PAADM(Adm,1),"^",7)
	set Loc=$p(^PAADM(Adm),"^",4)
	set DocCodeDR=$p(^PAADM(Adm),"^",9)    //PAADM_AdmDocCodeDR->CT_CareProv
	if (DocCodeDR'="") {
		set DocUserId=$o(^SSU("SSUSR",0,"CTPCP",DocCodeDR,0))
	}else {
		set DocUserId=UserId
	}
	set OrdStDate=+$h
	set DiffAmt=$zabs(DiffAmt)
	set User=DocUserId

	//插入数量为一正一负的自定义价格医嘱
	set OrdItemStr=IntArcim_"^"_1_"^"_Loc_"^"_DiffAmt_"^"_""_"^"_AdmReason_"^"_OrdStDate
	set OrdItemStr=OrdItemStr_$c(1)_IntArcim_"^"_-1_"^"_Loc_"^"_DiffAmt_"^"_""_"^"_AdmReason_"^"_OrdStDate
	
	set rtnValue=##class(web.DHCDocService).InsertOrderItem(Adm, OrdItemStr, User, Loc, DocUserId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) quit -1_"^"_"医生站组接口[web.DHCDocService||InsertOrderItem("_$lts($lb(Adm, OrdItemStr, User, Loc, DocUserId))_")]失败:"_rtnValue
	set ordItmStr=$p(rtnValue,"^",2)
	
	set oeitmStr=""
	set count=$l($p(ordItmStr,"^",1),$c(2))
	for i=1:1:count {
		set itmStr=$p(ordItmStr,$c(2),i)
		set oeitm=$p(itmStr,"*",1)
		set oeitmStr=$s((oeitmStr=""):oeitm,1:(oeitmStr_"^"_oeitm))
	}
	
	quit rtn_"#"_oeitmStr
}

/// Debug: w ##class(web.UDHCJFIntBill).UpdtPilotInsType("4729||70")
ClassMethod UpdtPilotInsType(billId As %String, userId As %String) As %String
{
	set $zt="ERROR"
	set adm=$p(^DHCPB(billId),"^",1)
	set pilotRtn=##class(web.PilotProject.DHCDocPilotService).IIsPilotInAdmTwo(adm, "I")
	set isPilotInAdm=$p(pilotRtn,"^",1)
	quit:('isPilotInAdm) 0
	set insTypeId=##class(web.DHCBillPilot).GetPilotAdmReason("IP")
	set rtn=..UpdtPatBillInsType(billId, insTypeId)
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-05-06
/// Description: 根据账单医嘱表RowId获取账单明细表第一条记录的计费日期，计费时间
/// Input：pboRowId: DHC_PatBillOrder.RowId
/// Return: 计费日期_"^"_计费时间
/// Debug: w ##class(web.UDHCJFIntBill).GetFstBillDateTime("4729||70")
ClassMethod GetFstBillDateTime(pboRowId As %String) As %String
{
	set billDate="", billTime=""
	quit:($l(pboRowId,"||")'=2) billDate_"^"_billTime
	
	set pb=+pboRowId
	set pbo=$p(pboRowId,"||",2)
	set pbd=$o(^DHCPB(pb,"O",pbo,"D",0))
	if (+pbd=0) {
		//账单明细表记录不存在时，取账单医嘱表的PBO_OrderDate，PBO_OrderTime
		set pboData=$g(^DHCPB(pb,"O",pbo))
		set billDate=$p(pboData,"^",12)     //PBO_OrderDate
		set billTime=$p(pboData,"^",13)     //PBO_OrderTime
		quit billDate_"^"_billTime
	}
	set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	set billDate=$p(pbdData,"^",11)   //PBD_BillDate
	set billTime=$p(pbdData,"^",12)   //PBD_BillTime
	quit billDate_"^"_billTime
}

/// Creator: ZhYW
/// CreatDate: 2023-05-09
/// Description: 更新账单表的费别
/// Input：billId:DHC_PatientBill.RowId, insTypeId:PAC_AdmReason.RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.UDHCJFIntBill).UpdtPatBillInsType("")
ClassMethod UpdtPatBillInsType(billId As %String, insTypeId As %String) As %String
{
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_PatInsType_DR = :insTypeId
		WHERE %ID = :billId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn
}

}
