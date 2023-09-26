Class web.UDHCPRTOEAuthCommon Extends BILL.COM.Abstract
{

/// 通用审批标志
/// 增加一个
/// 按照配置判断票据是否被审批
/// 读取票据级别的是否需要审批
/// Debug: w ##class(web.UDHCPRTOEAuthCommon).ReadINVAuthFlag(251,5,207)
ClassMethod ReadINVAuthFlag(PRTRowID As %String, GLocDR As %String, ULocDR As %String) As %String
{
	;发票能够直接退费的有效时间:
	;如果在有效时间内 强制  Verifyflag=Y  而其他两项 根据配置而定
	;return 审批标志^
	;Y   审批
	;N   未审批
	
	;医嘱的混合状态；
	;药物医嘱
	;非药物医嘱
	
	;默认审批不受限医嘱标志,受限是按照接收科室来受限的
	s myAuditLimit="N"
	
	s Verifyflag=$p($g(^DHCINVPRT(PRTRowID)),"^",22)			;审批标志
	s myPRTDate=$p($g(^DHCINVPRT(PRTRowID)),"^",5)
	s myPRTTime=$p($g(^DHCINVPRT(PRTRowID)),"^",20)
	s myHospDR=$p($g(^DHCINVPRT(PRTRowID)),"^",39)

	s myRecLocStr=""
	i (GLocDR'="")&&(ULocDR'="") d
	.;如果有配置表示为受限
	.s myAuditLimit="Y"
	.s myRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(GLocDR, myHospDR, ULocDR)
	
	;判断是否需要审批  医院基本配置表中
	;myConAppFlag=0    不需要审核
	;myConAppFlag=1    需要审核
	;myConAppFlag=2	   需要先申请后审核
	s myConInfo=##class(web.DHCOPConfig).ReadOPSPConfig(myHospDR)
	s myAuditSpaceTime=+$p(myConInfo, "^", 28)			    //OPFC_AuditSpaceTime
	s myConAppFlag=$p(myConInfo,"^",15)			            //OPFC_AppFlag
	i (+myConAppFlag=0) d
	.s Verifyflag="Y"
	e  d
	.s mySub=0
	.f  s mySub=$o(^DHCINVPRT(PRTRowID,"OA",mySub))  q:((mySub="")||(Verifyflag="Y"))  d
	..s tmp=$g(^DHCINVPRT(PRTRowID,"OA",mySub))
	..q:(tmp="")
	..s myFlag=$p(tmp,"^",6)   //IOA_Flag
	..i (myFlag="P") d
	..s Verifyflag="Y"
	
	;如果是含有药物医嘱，DHC_INVPRT属于审批的支付票据
	;对于包含药物和非药物医嘱的，在明细中包含那个被审批
	s myOETypeDrug=0
	s myOETypeItem=0
	s conRowid=0
	f  s conRowid=$o(^DHCBCI(0,"INV",PRTRowID,conRowid)) q:(conRowid="")  d
	.s bill=$p($g(^DHCBCI(conRowid)),"^",2)
	.s PBOChildsub=0
	.f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:(PBOChildsub="")  d
	..q:$d(^DHCPB(bill,"O",PBOChildsub))=10
	..s myOEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4)   //DHC_PatBillOrder->PBO_OEORI_DR
	..s ARCOrdType=##class(web.UDHCJFBaseCommon).GetOrdCateType(myOEORI, 1)
	..i (ARCOrdType="R")  d
	...s dspRetQty=##class(web.DHCOutPhReturn).GetRetOrdQty(myOEORI, PRTRowID)
	...i (+dspRetQty'=0) d
	....s Verifyflag="Y"
	...s myOETypeDrug=1
	..e  d
	...s myOETypeItem=1
	..s recdepcode=$p($g(^OEORD(+myOEORI,"I",+$p(myOEORI,"||",2),3)),"^",6)  //接收科室
	..q:((myRecLocStr'="")&&(myRecLocStr'[("^"_recdepcode_"^")))
	..s myAuditLimit="N"
	
	;判断是否混合医嘱
	s myOETypeDI=""
	i ((myOETypeDrug=1)&&(myOETypeItem=1)) d
	.s myOETypeDI="M"
	
	i (Verifyflag="") d
	.s Verifyflag="N"
	
	;最后增加一个时间判断  Verifyflag
	;如果没有审批
	;如果是当天的发票判断是否超出5分钟,超出5分
	s mySpecFlag=""
	i (myPRTDate=+$h)&&(Verifyflag'="Y") d
	.s myCurTime=$p($h,",",2)
	.s myDifTime=+(myCurTime-myPRTTime)/60
	.i (myDifTime>myAuditSpaceTime) d
	..s mySpecFlag="Y"
	
	s myrtn=Verifyflag_"^"_myOETypeDI_"^"_myAuditLimit_"^"_mySpecFlag
	
	q myrtn
}

/// Creator: ZhYW
/// CreatDate: 2018-11-20
/// Description: auditFlag_"^"_disabled_"^"_select
///   cfgAppFlag
/// 	(0: 不需要审核)
///     	1.没有发药和没有执行医嘱 auditFlag="Y", disabled="N", select=0
///           直接可以退费, 由操作员来决定
///    		2.已经发药和被执行的医嘱 auditFlag="Y", disabled="Y", select=0
///           强制医嘱不能被退费
///   		3.被退药的医嘱 auditFlag="Y", disabled="Y", select=1
///           强制医嘱退费
///     (1: 需要审核)
///           要求在这个情况下 医嘱的退费不能够操作员自己选择 强制要求: disabled="Y"
///      	1.验证此发票是否被审批 如果审批,auditFlag="Y"; 如果没有审批,auditFlag="N"
///      	2.存在没有执行医嘱 如果没有审批 auditFlag="N", disabled="Y", select=0
///      	2.存在没有执行医嘱 如果审批 auditFlag="Y", disabled="Y", select=1
///      	3.已经发药和被执行的医嘱 就是审批 auditFlag="N", disabled="Y", select=0
///      	4.已经发药和被执行的医嘱 如果没有审批 auditFlag="N", disabled="Y", select=0
///     	5.如果发票中存在没有发药药物医嘱 auditFlag="Y", disabled="N", select=0
///     	6.已经退药的医嘱 auditFlag="Y", disabled="Y", select=1
///     (2: 需要申请后审核)
///      	同appFlagCfg=1
/// Input: prtRowId:DHC_INVPRT.RowId, oeitm:OE_ordItem.RowId, expStr
/// Return: 
/// Debug: w ##class(web.UDHCPRTOEAuthCommon).ReadOEORDAuthFlag("7035","5464||2","")
ClassMethod ReadOEORDAuthFlag(prtRowId As %String, oeitm As %String, expStr As %String = "") As %String
{
	set ^TMP("ReadOEORDAuthFlag")=$lb(prtRowId, oeitm, expStr)
	set auditFlag="N"         //"Y":认为已审核,可以自动/手动勾选退费; "N":未审核,不能勾选
	set disabled="Y"          //"Y":勾选框被禁用; "N":勾选框不被禁用
	set select=0              //"1":加载页面时自动勾选; "0":加载页面时不勾选
	set cantRefReason=""      //不可退费原因
		
	//判断医嘱是不是转入住院，转入住院的医嘱需要退费
	set isOP2IP=##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)
	if (+isOP2IP=1) {
		do OP2IP
	}else {
		do UnOP2IP
	}
	
	set rtn=auditFlag_"^"_disabled_"^"_select_"^"_cantRefReason
	quit rtn

OP2IP
	//转入住院的医嘱需要退费
	set auditFlag="Y"
	set disabled="Y"
	set select=1
	quit
UnOP2IP
	set hospDR=$p(^DHCINVPRT(prtRowId),"^",39)
	set baseConfig=##class(web.DHCOPConfig).ReadOPSPConfig(hospDR)
	set cfgAppFlag=$p(baseConfig,"^",15)	     //OPFC_AppFlag
	set unAuditOrderCateStr=$p(baseConfig,"^",37)    //免审核医嘱子类
	set rcptUserFlag=$p(baseConfig,"^",41)   //OPFC_RcptUserFlag
	set appFlag=cfgAppFlag
	//2022-11-29，发票金额超过配置的需退费审核最大金额时，需要申请
	if ((appFlag=0)&&(##class(web.DHCOPBillRefundRequest).ChkRefAppByCfgAmt(prtRowId))) {
		set appFlag=1
	}

	set isExecute=0    //"0":未执行/未发药; "1":已执行/已发药
	set dspRetQty=0
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	if (ordCateType="R") {
		//药品
		set isExecute=##class(web.UDHCOEORDOPIF).CheckPhDispRet(oeitm)           //发药标识
		set isOPIVAS=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",16)   //静配标识
		if (isOPIVAS="Y") {
			set effectiveQty=##class(BILL.Interface.Inside.Invoke).GetEffectiveQtyForOPIVAS(oeitm)
			set billQty=##class(BILL.OP.COM.Method).GetOrdPrtBillQty(prtRowId, oeitm)
			set dspRetQty=billQty-effectiveQty
			if (dspRetQty>0) set isExecute=1     //有效数量<计费数量时，需要退费
		}else {
			set dspRetQty=##class(BILL.Interface.Inside.Invoke).GetRetOrdQty(oeitm, prtRowId)    //退药数量
		}
	}else {
		set isMatGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(oeitm)
		if (isMatGrant="Y") {
			//发放模式的物资材料
			set isExecute=##class(web.DHCOPBillRefundRequest).CheckMatDisp(oeitm)       //发放标识
			if (isExecute=1) {
				set applyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(oeitm, prtRowId)   //退回数量
				set dspRetQty=+$p(applyRefQtyInfo,"^",2)
			}
		}else {
			set ordStatDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",13)
			set ordStatCode=$s((+ordStatDR'=0):$p($g(^OEC("OSTAT",ordStatDR)),"^",1),1:"")
			if (ordStatCode="E") {
				set isExecute=1
			}
			//新版检查申请单
			set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
			if (isAppRep="Y") {
				set isPartExec=##class(web.DHCOPBillRefund).IsPartExecut(oeitm)
				if (isPartExec=0) set isExecute=0
			}else {
				set execQty=##class(web.UDHCJFBILL).GetOrdExecQty(oeitm)
				set billQty=##class(BILL.OP.COM.Method).GetOrdPrtBillQty(prtRowId, oeitm)
				if (billQty=execQty) set isExecute=1   //计费数量=已执行数量时，不能退费
			}
		}
	}
	
	set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	set arcGrp=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)    //医嘱子类
	if (($c(2)_unAuditOrderCateStr_$c(2))[($c(2)_arcGrp_$c(2))) {
		set appFlag=0      //免审核医嘱子类时，不需要审核
	}
	//判断医嘱录入人是否为医护人员
	set isCareProv=##class(web.UDHCJFBaseCommon).CheckISCareProvByOeoriDr(oeitm)
	if (rcptUserFlag=1) {
		set isCareProv=0          //如果配置收费员补录的医嘱也需要审核，则默认收费员也是医护人员.
	}
	if (isCareProv=1) {
		set appFlag=0             //非医护人员录入医嘱时，不需要审核
	}
	
	set auditFlag=..CheckOrdItmIsAudit(prtRowId, oeitm)
	if (isExecute=0) {
		//未发药/未发放/未执行的医嘱
		do UnExecute
	}else {
		do Execute
	}
	
	quit
Execute
	//药品(材料)材料未退
	if (+dspRetQty=0) {
		set cantRefReason="未退回(已执行)"
		quit
	}
	//药品(材料)已退
	set auditFlag="Y"
	set disabled="Y"
	set select=1
	
	quit
	
UnExecute
	if (auditFlag="Y") {
		//已审核时可以退费
		set select=1
		quit
	}
	//不需审核
	if (+appFlag=0) {
		set auditFlag="Y"
		set disabled="N"
		quit
	}
	set cantRefReason="未做退费"_$case(cfgAppFlag,1:"申请",:"审核(申请)")
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-11-19
/// Description: 判断医嘱是否审核
/// Input: prtRowId:DHC_INVPRT.RowId, oeitm:OE_OrdItem.RowId
/// Reutrn: Y:审核, N:未审
/// Debug: w ##class(web.UDHCPRTOEAuthCommon).CheckOrdItmIsAudit("2224", "111||14")
ClassMethod CheckOrdItmIsAudit(prtRowId As %String, oeitm As %String) As %String
{
	set rtn="N"
	quit:(+prtRowId=0) rtn
	
	set sub=0
	while($o(^DHCINVPRT(prtRowId,"OA",sub))) {
		set sub=$o(^DHCINVPRT(prtRowId,"OA",sub))
		set subData=$g(^DHCINVPRT(prtRowId,"OA",sub))
		continue:(subData="")
		set myOrdItm=$p(subData,"^",1)
		continue:(myOrdItm'=oeitm)
		set myFlag=$p(subData,"^",6)
		continue:(myFlag'="P")
		set rtn="Y"
		quit
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-07-28
/// Description: 获取医嘱退费申请状态
/// Input: oeitm: OE_OrdItem.RowID, expStr:扩展串
/// Return: "Y":已申请, "N":未申请
/// Debug: w ##class(web.UDHCPRTOEAuthCommon).CheckOrderIsRefAudit("2141||2", "")
ClassMethod CheckOrderIsRefAudit(oeitm As %String, expStr As %String = "") As %String
{
	set rtn="N"
	quit:($l(oeitm,"||")'=2) rtn
	
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	
	set prtRowId=""
	while($o(^DHCINVPRT(0,"OEORI",oeitm,prtRowId),-1)&&(rtn="N")) {
		set prtRowId=$o(^DHCINVPRT(0,"OEORI",oeitm,prtRowId),-1)
		set authSub=0
		while($o(^DHCINVPRT(0,"OEORI",oeitm,prtRowId,"OA",authSub))&&(rtn="N")) {
			set authSub=$o(^DHCINVPRT(0,"OEORI",oeitm,prtRowId,"OA",authSub))
			set authData=$g(^DHCINVPRT(prtRowId,"OA",authSub))
			set authFlag=$p(authData,"^",6)
			continue:((orderType'="R")&&(authFlag'="P"))    //药品医嘱不判断审核状态，只要申请了就算。
			set isQuit=0
			if (expStr'="") {
				if (orderType="R") {
					set dspbDR=$p(authData,"^",9)
					if (("^"_expStr_"^")'[("^"_dspbDR_"^")) {
						set isQuit=1
					}
				}elseif (isAppRep="Y") {
					set refRepPartStr=$p(authData,"^",19)
					for i=1:1:$l(refRepPartStr,"!!") {
						set refRepPartId=$p(refRepPartStr,"!!",i)
						continue:(refRepPartId="")
						continue:(("^"_expStr_"^")'[("^"_refRepPartId_"^"))
						set isQuit=1
						quit
					}
				}
			}
			continue:(isQuit=1)
			set rtn="Y"
			quit
		}
	}
	quit rtn
}

}
