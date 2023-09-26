Import SQLUser

/// 名称: web.DHCOPBillRefundRequest.cls
/// 描述: 门诊退费申请
/// 编写者：ZhYW
/// 编写日期: 2018-11-09
Class web.DHCOPBillRefundRequest Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// Creator: 2019-12-13
/// Description: 票据查询
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillRefundRequest","FindInvInfo","2021-03-15","2021-03-31","","","测试","","5^122^49^2")
Query FindInvInfo(StDate As %String, EndDate As %String, ReceiptNO As %String, PatientNO As %String, PatientName As %String, ChargeUser As %String, SessionStr As %String) As websys.Query(ROWSPEC = "TINVRowid:%String:发票ID,TINVNO:%String:发票号,TPatID:%String:登记号,TPatName:%String:患者姓名,TAcount:%Float:自付金额,TUser:%String:收费员,TDate:%String:收费日期,TTime:%String:收费时间,TotSum:%Float:费用总额,TabFlag:%String")
{
}

ClassMethod FindInvInfoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, ReceiptNO As %String, PatientNO As %String, PatientName As %String, ChargeUser As %String, SessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindInvInfo")=$lb(StDate, EndDate, ReceiptNO, PatientNO, PatientName, ChargeUser, SessionStr)

	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	set userId=$p(SessionStr,"^",1)
	set groupId=$p(SessionStr,"^",2)
	set ctLocId=$p(SessionStr,"^",3)
	set hospId=$p(SessionStr,"^",4)
	set langId=$p(SessionStr,"^",5)
	
	set IsAllowRefReg=##class(web.DHCOPBillRefund).IsAllowedRefundReg(hospId)   //获取门诊是否允许退挂号费   LuanZhenhui  2022-09-8
	
	if (ReceiptNO'="") {
		//门诊收费
		set TabFlag="PRT"
		set PrtRowid=0
		while($o(^DHCINVPRT(0,"INV",ReceiptNO,PrtRowid))) {
			set PrtRowid=$o(^DHCINVPRT(0,"INV",ReceiptNO,PrtRowid))
			do GetInfoOfInv(PrtRowid)
		}
		//集中打印发票
		set TabFlag="API"
		set PrtRowid=0
		while($o(^DHCINVPRTAPi(0,"INVNo",ReceiptNO,PrtRowid))) {
			set PrtRowid=$o(^DHCINVPRTAPi(0,"INVNo",ReceiptNO,PrtRowid))
			do GetInfoOfAPI(PrtRowid)
		}
		
		quit $$$OK
	}

	kill PatIdAry
	if (PatientNO'="") {
		set PatientNO=##class(web.UDHCJFBaseCommon).regnocon(PatientNO)
		set PatientNO=$zcvt(PatientNO,"U")
		set Papmi=$o(^PAPERi("PAPMI_PatNo",PatientNO,""))
		if (Papmi'="") {
			set PatIdAry(Papmi)=""
		}
	}elseif (PatientName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(PatientName, .PatIdAry)
	}

	if ($d(PatIdAry)) {
		set Papmi=0
		while($o(PatIdAry(Papmi))) {
			set Papmi=$o(PatIdAry(Papmi))
			//门诊收费
			set TabFlag="PRT"
			set PrtRowid=""
			while($o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid),-1)
				set PrtData=$g(^DHCINVPRT(PrtRowid))
				set prtDate=$p(PrtData,"^",5)
				set prtTime=$p(PrtData,"^",20)
				continue:((prtDate<StDate)||(prtDate>EndDate))
				do GetInfoOfInv(PrtRowid)
			}
			//集中打印发票
			set TabFlag="API"
			set PrtRowid=""
			while($o(^DHCINVPRTAPi(0,"PAPMI",Papmi,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRTAPi(0,"PAPMI",Papmi,PrtRowid),-1)
				set PrtData=$g(^DHCINVPRTAP(PrtRowid))
				set prtDate=$p(PrtData,"^",3)
				set prtTime=$p(PrtData,"^",4)
				continue:((prtDate<StDate)||(prtDate>EndDate))
				do GetInfoOfAPI(PrtRowid)
			}
		}
	}else {
		for date=EndDate:-1:StDate {
			//门诊收费
			set TabFlag="PRT"
			set PrtRowid=""
			while($o(^DHCINVPRT(0,"Date",date,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRT(0,"Date",date,PrtRowid),-1)
				do GetInfoOfInv(PrtRowid)
			}
			//集中打印发票
			set TabFlag="API"
			set PrtRowid=""
			while($o(^DHCINVPRTAPi(0,"Date",date,PrtRowid),-1)) {
				set PrtRowid=$o(^DHCINVPRTAPi(0,"Date",date,PrtRowid),-1)
				do GetInfoOfAPI(PrtRowid)
			}
		}
	}
	
	quit $$$OK
	
GetInfoOfInv(PrtRowid)
	set PrtInvData=$g(^DHCINVPRT(PrtRowid))
	set HospDR=$p(PrtInvData,"^",39)
	quit:(hospId'=HospDR)
	set PrtFlag=$p(PrtInvData,"^",8)
	quit:(PrtFlag'="N")
	set FairType=$p(PrtInvData,"^",34)
	quit:((IsAllowRefReg=0)&&(FairType="R")) //R:过滤挂号发票
	set StayFlag=$p(PrtInvData,"^",44)
	quit:(StayFlag="Y")      //急诊留观发票退出
	set PrtUsrDR=$p(PrtInvData,"^",21)
	set PrtUsr=$s((+PrtUsrDR'=0):$p($g(^SSU("SSUSR",PrtUsrDR)),"^",1),1:"")
	set PrtUserName=$s((+PrtUsrDR'=0):$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2),1:"")
	set PrtUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", PrtUserName, langId)
	quit:(ChargeUser'="")&&($$ALPHAUP^SSUTIL4(PrtUsr)'[$$ALPHAUP^SSUTIL4(ChargeUser))&&($$ALPHAUP^SSUTIL4(PrtUserName)'[$$ALPHAUP^SSUTIL4(ChargeUser))
	
	set PrtInvNO=$p(PrtInvData,"^",14)
	set PAPMIDR=$p(PrtInvData,"^",15)
	set PatNo=$s((+PAPMIDR'=0):$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",2),1:"")
	set PatName=$s((+PAPMIDR'=0):$p($g(^PAPER(PAPMIDR,"ALL")),"^",1),1:"")
	
	set Acount=$fn(+$p(PrtInvData,"^",16),"",2)
	set TotSum=$fn(+$p(PrtInvData,"^",1),"",2)
	
	set PrtDate=$p(PrtInvData,"^",5)
	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	set PrtTime=$p(PrtInvData,"^",20)
	set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	set AccPInvDR=$p(PrtInvData,"^",4)
	quit:(AccPInvDR'="")          //过虑已经集中打印发票的支付小条，防止重复查询
	
	do OutputInvInfo
	quit
	
GetInfoOfAPI(PrtRowid)
	set AccPInvData=$g(^DHCINVPRTAP(PrtRowid))
	set HospDR=$p(AccPInvData,"^",30)
	quit:(hospId'=HospDR)
	set PrtFlag=$p(AccPInvData,"^",2)
	quit:(PrtFlag'="N")
	set StayFlag=$p(AccPInvData,"^",29)
	quit:(StayFlag="Y")      //急诊留观发票退出
	set PrtUsrDR=$p(AccPInvData,"^",5)
	set PrtUsr=$s((+PrtUsrDR'=0):$p($g(^SSU("SSUSR",PrtUsrDR)),"^",1),1:"")
	set PrtUserName=$s((+PrtUsrDR'=0):$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2),1:"")
	set PrtUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", PrtUserName, langId)
	quit:(ChargeUser'="")&&($$ALPHAUP^SSUTIL4(PrtUsr)'[$$ALPHAUP^SSUTIL4(ChargeUser))&&($$ALPHAUP^SSUTIL4(PrtUserName)'[$$ALPHAUP^SSUTIL4(ChargeUser))
	
	set PrtInvNO=$p(AccPInvData,"^",6)
	set PAPMIDR=$p(AccPInvData,"^",11)
	set PatNo=$s((+PAPMIDR'=0):$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",2),1:"")
	set PatName=$s((+PAPMIDR'=0):$p($g(^PAPER(PAPMIDR,"ALL")),"^",1),1:"")
	set Acount=$fn(+$p(AccPInvData,"^",13),"",2)
	set TotSum=$fn(+$p(AccPInvData,"^",1),"",2)
	
	set PrtDate=$p(AccPInvData,"^",3)
	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	set PrtTime=$p(AccPInvData,"^",4)
	set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	do OutputInvInfo
	quit
OutputInvInfo
	set Data=$lb(PrtRowid,PrtInvNO,PatNo,PatName,Acount,PrtUserName,PrtDate,PrtTime,TotSum,TabFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-11-09
/// Description: 查询退费申请明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillRefundRequest","FindOrdItm","8716:PRT","17275^239^3^2^20")
Query FindOrdItm(invStr As %String, sessionStr As %String) As websys.Query(ROWSPEC = "arcimDesc:%String,billAmt:%String,billQty:%String,packUom:%String,packQty:%String,canRetQty:%String,reqQty:%String,alreadyReqQty:%String,execInfo:%String,oeori:%String,prescNo:%String,ordDept:%String,recDept:%String,select:%String,isExecute:%String,price:%String,confac:%String,prtId:%String,pboId:%String,dspbId:%String,phdicId:%String,arcim:%String,ordCateType:%String,isEdit:%String,isAppRep:%String,isCNMedItem:%String,isOweDrug:%String,reqRowId:%String,reqUserName:%String,reqDate:%String,reqTime:%String,auditUserName:%String,auditDate:%String,auditTime:%String,cantRetReasonStr:%String,cantDelReasonStr:%String")
{
}

ClassMethod FindOrdItmExecute(ByRef qHandle As %Binary, invStr As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set ^TMP("FindOrdItm")=$lb(invStr, sessionStr)
	if (invStr="") quit $$$OK
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set contraRecLocIdStr=..GetContraRecLocIdStr(hospId, ctLocId)  //+2022-11-17 ZhYW 登录科室对照的医嘱接收科室
	
	set bCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set cfgAppFlag=$p(bCfgInfo,"^",15)             //(0:不用审核, 1:一级审核, 2:二级审核)
	set supAudLocStr=$p(bCfgInfo,"^",43)           //超级审核权限科室
	set treatItmReqMode=$p(bCfgInfo,"^",50)        //检查、治疗医嘱审核模式
	set isSupAudPer=(($c(2)_supAudLocStr_$c(2))[($c(2)_ctLocId_$c(2)))   //是否有超级审核权限
	set userCarPrvType=##class(web.DHCDocOrderCommon).GetCareProvType(userId)
	
	set unExecAuditCfg=..GetUnExecAuditCfg(hospId)   //+2023-04-12 ZhYW 未执行医嘱是否需要审核

	for i=1:1:$l(invStr,"^") {
		set myInvStr=$p(invStr,"^",i)
		continue:(myInvStr="")
		set invId=$p(myInvStr,":",1)
		set invType=$p(myInvStr,":",2)
		continue:((invId="")||(invType=""))
		set isDirectRefAudit=##class(BILL.OP.BL.DirectRefundAudit).CheckIsAudited(invId, invType)
		set isRefInsuDiffMth=##class(web.DHCOPBillRefund).IsAllowedRefInsuDiffMth(invId, invType)  //+2022-11-22 ZhYW 医保收费跨月是否能退费
		if (invType="API") {
			set apiConDR=0
			while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))) {
				set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))
				set prtId=$p($g(^DHCINVPRTCAP(apiConDR)),"^",1)
				do GetInvOrdItm(prtId)
			}
			continue
		}
		
		do GetInvOrdItm(invId)
	}
	
	quit $$$OK
	
GetInvOrdItm(prtId)
	set hospDR=$p(^DHCINVPRT(prtId),"^",39)
	
	set appFlag=cfgAppFlag
	//+2023-02-16 ZhYW 根据发票的结算费别判断是否需要退费审核
	if ((appFlag=2)&&(..ChkRefAppByChrgInsType(prtId))) {
		set appFlag=1
	}
	//+2023-03-22 ZhYW 根据发票的结算时间判断是否需要退费审核
	if ((appFlag=2)&&(..ChkRefAppByChrgPrtTime(prtId))) {
		set appFlag=1
	}
	//+2023-04-12 ZhYW 根据医嘱的执行状态判断是否需要退费审核
	if ((appFlag=2)&&('unExecAuditCfg)) {
		set appFlag=1
	}
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtId,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			do InitVables
			set pboId=pb_"||"_pbo
			set arcim=$p(pboData,"^",3)
			set arcGrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)       //医嘱子类
			set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
			set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
			set oeori=$p(pboData,"^",4)
			set ordDeptDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",2)    //开单科室
			set ordDept=$s((+ordDeptDR'=0):$p($g(^CTLOC(ordDeptDR)),"^",2),1:"")
			set ordDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", ordDept, langId)
			set recDeptDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),3)),"^",6)       //接收科室
			set recDept=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
			set recDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDept, langId)
			set userAddDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),7)),"^",1)       //OEORI_UserAdd
			set userAddCarPrvType=##class(web.DHCDocOrderCommon).GetCareProvType(userAddDR)
			set cantRetReasonStr=""      //不能退费原因
			if (+isRefInsuDiffMth=0) {
				set cantRetReason="医保结算发票已跨月，不能申请退费"
				set cantRetReasonStr=$s((cantRetReasonStr=""):cantRetReason,1:(cantRetReasonStr_"^"_cantRetReason))
			}
			if (+isDirectRefAudit=1) {
				set cantRetReason="已做直接退费审核，不能申请退费"
				set cantRetReasonStr=$s((cantRetReasonStr=""):cantRetReason,1:(cantRetReasonStr_"^"_cantRetReason))
			}
			if ('isSupAudPer) {
				set cantRetReason=""
				if ((ctLocId'=ordDeptDR) && (("^"_contraRecLocIdStr_"^")'[("^"_recDeptDR_"^"))) {
					set cantRetReason="本科室没有权限为"_ordDept_"开的医嘱申请退费"
				}elseif ((userAddCarPrvType'="")&&(userCarPrvType'=userAddCarPrvType)) {
					//控制医生不能退护士开的医嘱，护士不能退医生开的医嘱
					set cantRetReason="您没有权限为"_$case($zcvt(userAddCarPrvType,"U"),"DOCTOR":"医生","NURSE":"护士",:"")_"开的医嘱申请退费"
				}
				if (cantRetReason'="") {
					set cantRetReasonStr=$s((cantRetReasonStr=""):cantRetReason,1:(cantRetReasonStr_"^"_cantRetReason))
				}
			}
			set packQty=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),9)),"^",4)         //OEORI_QtyPackUOM
			set doseQty=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",12)		//OEORI_PhQtyOrd
			set prescNo=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",14)        //处方号
			set itmStatDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",13)
			set itmStatCode=$s((+itmStatDR'=0):$p($g(^OEC("OSTAT",itmStatDR)),"^",1),1:"")
			//set price=$fn($p(pboData,"^",7),"",4)    //PBO_UnitPrice
			set price=$fn($p(pboData,"^",19),"",4)     //PBO_PatPrice
			set pboBillQty=$p(pboData,"^",5)		   //PBO_BillQty
			set pboRefQty=$p(pboData,"^",6)	           //PBO_RefundQty
			set pboQty=pboBillQty+pboRefQty
			continue:(pboQty=0)
			set isAllowPartRef=..CheckOrdAllowPartRequest(oeori, hospId)      //判断是否允许部分退费
			set packUom=##class(web.DHCBillCommon).GetPackUom(arcim, oeori)
			set packUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", packUom, langId)
			set confac=##class(web.DHCBillCommon).GetUomConvFactor(arcim, oeori)
			set billQty=pboQty/confac
			set billQty=$fn(billQty,"N")
			set canRetQty=billQty                            //可退数量初始化为计费数量
			//set billAmt=$fn($p(pboData,"^",8),"",2)        //PBO_ToTalAmount
			set billAmt=$fn($p(pboData,"^",11),"",2)         //PBO_PatientShare
			set dspbId=""          //打包子表RowId
			set isCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(arcim, hospDR)
			set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeori, 1)
			if (ordCateType="R") {
				//药品
				do DrugOrder
				continue
			}
			
			//非药品
			set packQty=doseQty
			set auditInfo=..GetAuditInfo(prtId, pboId)
			set auditUserName=$p(auditInfo,"^",1)
			set auditDate=$p(auditInfo,"^",2)
			set auditTime=$p(auditInfo,"^",3)
			set reqRowId=..GetReqRowId(prtId, pboId)   //已申请数量
			set isMatGrant=..CheckIsMatDispGrant(oeori)
			//走发放的材料
			if (isMatGrant="Y") {
				do MatGrantOrder
				continue
			}
			
			//多部位检查申请单
			set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeori)
			if (isAppRep="Y") {
				do AppRepOrder
				continue
			}
			
			//其他医嘱
			do OtherOrder
			continue
		}
	}
	
	quit

InitVables
	set select=1          //能否被勾选标识(1:能, 0:不能)
	set isEdit=0          //是否允许填写退费数量(0:否, 1:是)
	set isAppRep="N"      //是否多部位检查申请单(N:否, Y:是)
	set isOweDrug=1       //欠药标识(1:非欠药, 0:欠药)
	set isExecute=0       //药品是否发药、检查检验是否执行、物资材料是否发放标识 (0:否, 1:是)
	set phdicId=""        //发药时，发药子表或欠药子表RowId
	quit

DrugOrder
	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
		continue:(pbdData="")
		set pbdId=pb_"||"_pbo_"||"_pbd
		set dspbId=$p(pbdData,"^",27)
		continue:(dspbId="")
		set dspbData=$g(^DHCOEDISQTY(+dspbId,"I",$p(dspbId,"||",2)))
		continue:(dspbData="")
		set dspbStatus=$p(dspbData,"^",6)      //一次发药记录一个申请 根据是否发药建立分支
		continue:(dspbStatus="R")
		set inci=$p(dspbData,"^",5)            //库存项指针
		set baseUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",10),1:"")     //库存项基本单位
		set outUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",12),1:"")      //门诊药品取门诊发药单位
		set dispUomDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",13)     //协议包装单位
		set uomDR=""
		if (dispUomDR'="") {
			set uomDR=dispUomDR
		}else {
			set uomDR=$s((outUomDR'=""):outUomDR,1:baseUomDR)
		}
		set confac=##class(PHA.FACE.OUT.Com).UOMFac(uomDR, baseUomDR)
		set packUom=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
		set packUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", packUom, langId)
		set tmpCantReason=cantRetReasonStr
		if (dspbStatus="C") {
			do DispenDrug
		}else {
			do NotDispenDrug
		}
		set cantRetReasonStr=tmpCantReason
	}
	
	quit
	
DispenDrug
	//包括正常发药和欠药发药
	set cantRetReason=##class(PHA.FACE.OUT.Com).CheckIfRetFlag(prescNo, inci, dspbId)   //取药房不能退药原因
	if ((cantRetReason'="") && (("^"_cantRetReasonStr_"^")'[("^"_cantRetReason_"^"))) {
		set cantRetReasonStr=$s((cantRetReasonStr=""):cantRetReason,1:(cantRetReasonStr_"^"_cantRetReason))
	}
	//正常发药记录
	do NormalDispen
	
	//欠药发药记录
	do OweDispen
	
	quit
	
NormalDispen
	//正常发药记录
	if (+isCNMedItem=1) {
		//2022-12-07 ZhYW 药房新的草药发药流程
		//草药(草药不能填写退费数量)
		set phbdId=0
		while($o(^BS.PHA.HERB.DISPENI("DspBatch",dspbId,phbdId))) {
			set phbdId=+$o(^BS.PHA.HERB.DISPENI("DspBatch",dspbId,phbdId))
			set phbdSub=0
			while($o(^BS.PHA.HERB.DISPENI("DspBatch",dspbId,phbdId,phbdSub))) {
				set phbdSub=$o(^BS.PHA.HERB.DISPENI("DspBatch",dspbId,phbdId,phbdSub))
				set phbdicSub=0
				while($o(^BS.PHA.HERB.DISPENI("DspBatch",dspbId,phbdId,phbdSub,phbdicSub))) {
					set phbdicSub=$o(^BS.PHA.HERB.DISPENI("DspBatch",dspbId,phbdId,phbdSub,phbdicSub))
					do InitVables
					set phdicId=phbdId_"||"_phbdSub_"||"_phbdicSub
					set isExecute=1
					set billInfo=..GetDrugBillInfo(pboId, dspbId)
					set price=$p(billInfo,"^",1)
					//set billQty=$p(billInfo,"^",2)
					set billAmt=$p(billInfo,"^",3)
					set phbdQtyInfo=..GetPhbdQtyByDspbId(dspbId, phdicId)
					set dspQty=$p(phbdQtyInfo,"^",1)      //发药数量
					set retQty=$p(phbdQtyInfo,"^",2)      //退药数量
					//+2023-02-08 ZhYW 如果是循环小数（先判断小数点后6位），则按基本单位处理
					if ($l($p(dspQty/confac,".",2))>6) {
						set confac=1
						set packUom=$s((+baseUomDR'=0):$p($g(^CT("UOM",baseUomDR)),"^",2),1:"")
						set packUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", packUom, langId) 
					}
					set dspQty=dspQty/confac      //发药数量
					set dspQty=$fn(dspQty,"N")
					set retQty=retQty/confac      //退药数量
					set retQty=$fn(retQty,"N")
					set execInfo=##class(websys.Translation).Get("", "已发药", langId)_"："_dspQty_"&emsp;"_##class(websys.Translation).Get("", "已退药", langId)_"："_retQty
					set billQty=dspQty
					set billAmt=##class(web.UDHCJFBILL).round((billQty*confac*price))
					set auditInfo=..GetAuditInfo(prtId, pboId, dspbId, phdicId)
					set auditUserName=$p(auditInfo,"^",1)
					set auditDate=$p(auditInfo,"^",2)
					set auditTime=$p(auditInfo,"^",3)
					set reqRowId=..GetReqRowId(prtId, pboId, dspbId, phdicId)   //已申请数量
					set canRetQty=dspQty-retQty                      //可退数量
					do FormatOutput
				}
			}
		}
		quit
	}
	
	//非草药
	set phdId=0
	while($o(^DHCPHDIi("DSPB",dspbId,phdId))) {
		set phdId=$o(^DHCPHDIi("DSPB",dspbId,phdId))
		set fyFlag=$p($g(^DHCPHDISP(phdId)),"^",4)
		continue:(+fyFlag'=1)
		set phdSub=0
		while($o(^DHCPHDIi("DSPB",dspbId,phdId,phdSub))) {
			set phdSub=$o(^DHCPHDIi("DSPB",dspbId,phdId,phdSub))
			set phdicSub=0
			while($o(^DHCPHDIi("DSPB",dspbId,phdId,phdSub,phdicSub))) {
				set phdicSub=$o(^DHCPHDIi("DSPB",dspbId,phdId,phdSub,phdicSub))
				do InitVables
				set phdicId=phdId_"||"_phdSub_"||"_phdicSub
				set isEdit=$case(isAllowPartRef,"Y":1,:isEdit)
				set isExecute=1
				set billInfo=..GetDrugBillInfo(pboId, dspbId)
				set price=$p(billInfo,"^",1)
				//set billQty=$p(billInfo,"^",2)
				set billAmt=$p(billInfo,"^",3)
				set phdQtyInfo=..GetPhdQtyByDspbId(dspbId, phdicId)
				set dspQty=$p(phdQtyInfo,"^",1)      //发药数量
				set retQty=$p(phdQtyInfo,"^",2)      //退药数量
				//+2023-02-08 ZhYW 如果是循环小数（先判断小数点后6位），则按基本单位处理
				if ($l($p(dspQty/confac,".",2))>6) {
					set confac=1
					set packUom=$s((+baseUomDR'=0):$p($g(^CT("UOM",baseUomDR)),"^",2),1:"")
					set packUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", packUom, langId) 
				}
				set dspQty=dspQty/confac      //发药数量
				set dspQty=$fn(dspQty,"N")
				set retQty=retQty/confac      //退药数量
				set retQty=$fn(retQty,"N")
				set execInfo=##class(websys.Translation).Get("", "已发药", langId)_"："_dspQty_"&emsp;"_##class(websys.Translation).Get("", "已退药", langId)_"："_retQty
				set billQty=dspQty
				set billAmt=##class(web.UDHCJFBILL).round((billQty*confac*price))
				set auditInfo=..GetAuditInfo(prtId, pboId, dspbId, phdicId)
				set auditUserName=$p(auditInfo,"^",1)
				set auditDate=$p(auditInfo,"^",2)
				set auditTime=$p(auditInfo,"^",3)
				set reqRowId=..GetReqRowId(prtId, pboId, dspbId, phdicId)   //已申请数量
				set canRetQty=dspQty-retQty                      //可退数量
				do FormatOutput
			}
		}
	}
	quit
	
OweDispen
	//欠药发药记录
	set phow=0
	while($o(^DHCPHOWi(0,"DspSub",dspbId,phow))) {
		set phow=$o(^DHCPHOWi(0,"DspSub",dspbId,phow))
		set phowData=$g(^DHCPHOW(phow))
		set status=$p(phowData,"^",8)
		continue:(status=2)     //如果欠药单已发药状态,库存已减,不考虑
		set phowRetDate=$p(phowData,"^",10)
		continue:(phowRetDate'="")
		set phowSub=0
		while($o(^DHCPHOWi(0,"DspSub",dspbId,phow,phowSub))) {
			set phowSub=$o(^DHCPHOWi(0,"DspSub",dspbId,phow,phowSub))
			set phowSubData=$g(^DHCPHOW(phow,"I",phowSub))
			continue:(phowSubData="")
			do InitVables
			set phdicId=phow_"||"_phowSub
			set isOweDrug=0       //欠药标识(0:欠药)
			set isExecute=1
			set orditm=$p(phowSubData,"^",1)
			set oweQty=$p(phowSubData,"^",2)
			//+2023-02-08 ZhYW 如果是循环小数（先判断小数点后6位），则按基本单位处理
			if ($l($p(oweQty/confac,".",2))>6) {
				set confac=1
				set packUom=$s((+baseUomDR'=0):$p($g(^CT("UOM",baseUomDR)),"^",2),1:"")
				set packUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", packUom, langId) 
			}
			set oweQty=oweQty/confac
			set oweQty=$fn(oweQty,"N")
			set billInfo=..GetDrugBillInfo(pboId, dspbId)
			set price=$p(billInfo,"^",1)
			//set billQty=$p(billInfo,"^",2)
			set billQty=oweQty
			set billAmt=##class(web.UDHCJFBILL).round((billQty*confac*price))
			set execInfo=##class(websys.Translation).Get("", "尚欠药", langId)_"："_oweQty
			set auditInfo=..GetAuditInfo(prtId, pboId, dspbId, phdicId)
			set auditUserName=$p(auditInfo,"^",1)
			set auditDate=$p(auditInfo,"^",2)
			set auditTime=$p(auditInfo,"^",3)
			set reqRowId=..GetReqRowId(prtId, pboId, dspbId, phdicId)  //已申请数量
			set canRetQty=oweQty                              //可退数量
			do FormatOutput
		}
	}
	quit

NotDispenDrug
	//未发药
	//2022-10-11 ZhYW 药房不能退费原因(如正在备药中的草药不能退费)
	set cantRetReason=##class(PHA.FACE.OUT.Com).IfHerbRetFlag(prescNo)   //调用药房接口取药房不能退费原因
	if ((cantRetReason'="") && (("^"_cantRetReasonStr_"^")'[("^"_cantRetReason_"^"))) {
		set cantRetReasonStr=$s((cantRetReasonStr=""):cantRetReason,1:(cantRetReasonStr_"^"_cantRetReason))
	}
	do InitVables
	set itmDR=$p(pbdData,"^",3)
	set pbdQty=$p(pbdData,"^",5)
	quit:(+pbdQty'>0)
	set billInfo=..GetDrugBillInfo(pboId, dspbId)
	set price=$p(billInfo,"^",1)
	set billQty=$p(billInfo,"^",2)
	quit:(+billQty=0)
	set billQty=billQty/confac
	set billQty=$fn(billQty,"N")
	set billAmt=$fn($p(billInfo,"^",3),"",2)
	set execInfo=##class(websys.Translation).Get("", "未发药", langId)
	set auditInfo=..GetAuditInfo(prtId, pboId, dspbId)
	set auditUserName=$p(auditInfo,"^",1)
	set auditDate=$p(auditInfo,"^",2)
	set auditTime=$p(auditInfo,"^",3)
	set reqRowId=..GetReqRowId(prtId, pboId, dspbId)   //已申请数量
	set canRetQty=billQty                              //可退数量
	do FormatOutput
	quit
	
MatGrantOrder
	//走发放的材料
	set isExecute=..CheckMatDisp(oeori)
	set isEdit=((isAllowPartRef="Y")&&(isExecute=1))
	set matDspQty=..GetMatDispQty(oeori)
	set dspQty=$p(matDspQty,"^",1)      //发放数量
	set dspQty=$fn(dspQty,"N")
	set retQty=$p(matDspQty,"^",2)      //退回数量
	set retQty=$fn(retQty,"N")
	set execInfo=##class(websys.Translation).Get("", "已发放", langId)_"："_dspQty_"&emsp;"_##class(websys.Translation).Get("", "已退回", langId)_"："_retQty
	do FormatOutput
	quit
	
AppRepOrder
	//多部位检查申请单
	set isEdit=0   //不能填数量退费
	set partDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(oeori)
	set arcimDesc=arcimDesc_partDesc
	set isPartExec=##class(web.DHCOPBillRefund).IsPartExecut(oeori)    //判断是否是部分执行
	if (isPartExec=0) set itmStatCode=""
	set isExecute=(itmStatCode="E")
	set select=$s(((+treatItmReqMode=0)&&(itmStatCode="E")):0,1:select)     //+2020-10-16 增加检查、治疗医嘱审核模式配置判断
	set execInfo=$s((isExecute=1):##class(websys.Translation).Get("", "已执行", langId),1:"")
	do FormatOutput
	quit

OtherOrder
	//其他医嘱
	set execQty=##class(web.UDHCJFBILL).GetOrdExecQty(oeori)   //已执行数量
	set execQty=execQty/confac
	set execQty=$fn(execQty,"N")
	set unExecQty=packQty-execQty                        //未执行数量(总数量-已执行数量)
	set unExecQty=$fn(unExecQty,"N")
	set isEdit=$s(((isAllowPartRef="Y")&&(itmStatCode'="E")):1,1:isEdit)    //医嘱未执行且配置了允许部分退时才可以部分退
	set isExecute=(+execQty'=0)                          //当执行数量不为0时，认为已执行
	if (itmStatCode="E") {
		//执行了的医嘱，走先审核后撤销执行时可退数量为收费时的数量，否则为计费数量-执行数量
		set canRetQty=$s((treatItmReqMode=1):canRetQty,1:(canRetQty-execQty))
		set select=(treatItmReqMode=1)
	}else {
		set canRetQty=canRetQty-execQty                      //可退数量为计费数量-执行数量
		set select=(canRetQty>0)                             //可退数量>0时，可以申请退费
	}
	//+2023-02-08 ZhYW 医嘱执行后，提示"医嘱已执行，不能申请退费"
	if (+select=0) {
		set cantRetReason="医嘱已执行，不能申请退费"
		set cantRetReasonStr=$s((cantRetReasonStr=""):cantRetReason,1:(cantRetReasonStr_"^"_cantRetReason))
	}
	set execInfo=##class(websys.Translation).Get("", "已执行", langId)_"："_execQty_"&emsp;"_##class(websys.Translation).Get("", "未执行", langId)_"："_unExecQty
	do FormatOutput
	quit
	
FormatOutput
	set reqData=$s((+reqRowId'=0):$g(^DHCINVPRT(+reqRowId,"OA",$p(reqRowId,"||",2))),1:"")
	set reqUserDR=$p(reqData,"^",2)
	set reqDate=$p(reqData,"^",3)
	set reqDate=##class(websys.Conversions).DateLogicalToHtml(reqDate)
	set reqTime=$p(reqData,"^",4)
	set reqTime=##class(websys.Conversions).TimeLogicalToHtml(reqTime)
	set alreadyReqQty=$p(reqData,"^",5)
	set reqFlag=$p(reqData,"^",6)
	set reqDeptDR=$p(reqData,"^",16)
	set alreadyReqQty=alreadyReqQty/confac
	set alreadyReqQty=$s((+alreadyReqQty'=0):$fn(alreadyReqQty,"N"),1:alreadyReqQty)
	
	set reqUserName=$s((+reqUserDR'=0):$p($g(^SSU("SSUSR",reqUserDR)),"^",2),1:"")
	set reqUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", reqUserName, langId)
	set reqDeptName=$s((+reqDeptDR'=0):$p($g(^CTLOC(reqDeptDR)),"^",2),1:"")
	set reqDeptName=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", reqDeptName, langId)
	
	set cantDelReasonStr=""    //不能撤销申请原因
	if ('isSupAudPer) {
		if ((reqDeptDR'="")&&(ctLocId'=reqDeptDR)) {
			set cantDelReason=reqDeptName_"发起的退费申请，您无撤销权限"
			set cantDelReasonStr=cantDelReason
		}
	}
	if ((appFlag=2)&&(reqFlag="P")) {
		set cantDelReason="已审核的申请不能撤销"
		set cantDelReasonStr=$s((cantDelReasonStr=""):cantDelReason,1:(cantDelReasonStr_"^"_cantDelReason))
	}
	set select=$s(((cantRetReasonStr'="") || (cantDelReasonStr'="")):0,1:select)     //不能退费原因或不能撤销原因不为空时，不能再勾选
	set canRetQty=$fn(canRetQty,"N")
	set reqQty=""       //申请数量
	if (+reqRowId=0) {
		set reqQty=$s((+isEdit=0):$s(((canRetQty-alreadyReqQty)>0):(canRetQty-alreadyReqQty),1:0),1:"")  //能够编辑申请数量时，申请数量默认为空
	}
	set reqQty=$s((+reqQty'=0):$fn(reqQty,"N"),1:reqQty)
	
	do OutputOrdItm
	quit
	
OutputOrdItm
	set Data=$lb(arcimDesc,billAmt,billQty,packUom,packQty,canRetQty,reqQty,alreadyReqQty,execInfo,oeori,prescNo,ordDept,recDept,select,isExecute,price,confac,prtId,pboId,dspbId,phdicId,arcim,ordCateType,isEdit,isAppRep,isCNMedItem,isOweDrug,reqRowId,reqUserName,reqDate,reqTime,auditUserName,auditDate,auditTime,cantRetReasonStr,cantDelReasonStr)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-11-09
/// Description: 取退费申请RowId
/// Input: 
/// Return: reqRowId
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetReqRowId(228173, "272344||1", "")
ClassMethod GetReqRowId(prtId As %String, pboId As %String, dspbId As %String = "", phdicId As %String = "") As %String
{
	set reqRowId=""
	set sub=0
	while($o(^DHCINVPRT(0,"PBO",pboId,prtId,"OA",sub))) {
		set sub=$o(^DHCINVPRT(0,"PBO",pboId,prtId,"OA",sub))
		set subData=$g(^DHCINVPRT(prtId,"OA",sub))
		set dspbDR=$p(subData,"^",9)
		continue:((dspbId'="")&&(dspbId'=dspbDR))
		set myPHDItm=$p(subData,"^",21)
		continue:((phdicId'="")&&(phdicId'=myPHDItm))
		set reqRowId=prtId_"||"_sub
		quit
	}
	quit reqRowId
}

/// Creator: ZhYW
/// CreatDate: 2018-11-09
/// Description: 取已审核信息
/// Input: 
/// Return: auditUserName_"^"_auditDate_"^"_auditTime
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetAuditInfo(228173, "272344||1", "")
ClassMethod GetAuditInfo(prtId As %String, pboId As %String, dspbId As %String = "", phdicId As %String = "") As %String
{
	set auditUserName=""
	set auditDate=""
	set auditTime=""
	set sub=0
	while($o(^DHCINVPRT(0,"PBO",pboId,prtId,"OA",sub))) {
		set sub=$o(^DHCINVPRT(0,"PBO",pboId,prtId,"OA",sub))
		set subData=$g(^DHCINVPRT(prtId,"OA",sub))
		set myReqFlag=$p(subData,"^",6)
		continue:(myReqFlag'="P")
		set myReqQty=$p(subData,"^",5)
		set dspbDR=$p(subData,"^",9)
		continue:(dspbId'=dspbDR)&&(dspbId'="")
		set myPHDItm=$p(subData,"^",21)
		continue:((phdicId'="")&&(phdicId'=myPHDItm))
		set myAuditUserDR=$p(subData,"^",12)
		set auditUserName=$s((+myAuditUserDR'=0):$p($g(^SSU("SSUSR",myAuditUserDR)),"^",2),1:"")
		set myAuditDate=$p(subData,"^",13)
		set auditDate=##class(websys.Conversions).DateLogicalToHtml(myAuditDate)
		set myAuditTime=$p(subData,"^",14)
		set auditTime=##class(websys.Conversions).TimeLogicalToHtml(myAuditTime)
	}

	quit auditUserName_"^"_auditDate_"^"_auditTime
}

/// Creator: ZhYW
/// CreatDate: 2018-11-09
/// Description: 取此次结算记录的药品医嘱的金额数量
/// Input: pboId:DHC_PatBillOrder.RowId, dspbId:发药记录的DHC_OEDispBatch.RowId
/// Return: 单价^数量^总金额
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetDrugBillInfo("273567||3", "11643||1")
ClassMethod GetDrugBillInfo(pboId As %String, dspbId As %String) As %String
{
	set pb=$p(pboId,"||",1)
	set pbo=$p(pboId,"||",2)
	set retDspbIdStr=##class(PHA.FACE.OUT.Com).GetRetDspbStr(dspbId)
	
	set price=0
	set billQty=0
	set billAmt=0
	set retQty=0
	set retAmt=0
	
	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
		continue:(pbdData="")
		set pbdPrice=$p(pbdData,"^",4)
		set pbdPrice=$fn(pbdPrice,"N")            //PBD_UnitPrice
		set pbdPatPrice=$p(pbdData,"^",20)
		set pbdPatPrice=$fn(pbdPatPrice,"N")      //PBD_PatPrice
		set pbdQty=$p(pbdData,"^",5)
		set pbdTotalAmt=$p(pbdData,"^",7)
		set pbdTotalAmt=$fn(pbdTotalAmt,"",2)     //PBD_TotalAmount
		set pbdPatAmt=$p(pbdData,"^",10)
		set pbdPatAmt=$fn(pbdPatAmt,"",2)         //PBD_PatientShare
		set dspbDR=$p(pbdData,"^",27)
		if (dspbId=dspbDR) {
			set price=pbdPatPrice
			set billQty=billQty+pbdQty              //收费数量
			set billAmt=billAmt+pbdPatAmt           //收费金额
		}else {
			if ("^"_retDspbIdStr_"^")[("^"_dspbDR_"^") {
				set retQty=retQty+pbdQty            //退费数量
				set retAmt=retAmt+pbdPatAmt         //退费金额
			}
		}
	}

	set billQty=billQty+retQty
	set billAmt=billAmt+retAmt
	
	quit price_"^"_billQty_"^"_billAmt
}

/// Creator: ZhYW
/// CreatDate: 2018-11-09
/// Description: 判断物资材料是否已发
/// Input: oeitm:OE_OrdItem.RowId
/// Return: 1:已发, 0:未发
/// Debug: w ##class(web.DHCOPBillRefundRequest).CheckMatDisp("272497||1")
ClassMethod CheckMatDisp(oeitm As %String) As %String
{
	set rtn=0
   	set dspId=0
   	while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dspId))&&(rtn=0)) {
	   	set dspId=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dspId))
	   	set dspData=$g(^DHCOEDISQTY(dspId))
	   	set dspStatus=$p(dspData,"^",7)
	   	set rtn=(dspStatus="C")
	}
   	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-11-09
/// Description: 取物资材料已发和已退数量
/// Input: oeitm:OE_OrdItem.RowId
/// Return: 已发数量^已退数量
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetMatDispQty("272497||1")
ClassMethod GetMatDispQty(oeitm As %String) As %String
{
	set dspQty=0
	set retQty=0
   	set dspId=0
   	while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dspId))) {
	   	set dspId=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dspId))
	   	set dspData=$g(^DHCOEDISQTY(dspId))
	   	set myDspStatus=$p(dspData,"^",7)
		set myDspQty=$p(dspData,"^",11)
		if (myDspStatus="C") {
			set dspQty=dspQty+myDspQty
			continue
		}
		if (myDspStatus="R") {
			set retQty=retQty+myDspQty
			continue
		}
	}

   	quit dspQty_"^"_retQty
}

/// Creator: ZhYW
/// CreatDate: 2017-08-28
/// Description: 判断是否是走发放流程的物资
/// Input: oeitm:OE_OrdItem.RowId
/// Return: Y:是，N:不是
/// Debug: w ##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant("111||14")
ClassMethod CheckIsMatDispGrant(oeitm As %String) As %String
{
	set grantFlag="N"
	quit:($l(oeitm,"||")'=2) grantFlag
	set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
	set isMatArcim=##class(BILL.Interface.Inside.Invoke).IsMatArcim(arcim)
	quit:(isMatArcim'=1) grantFlag
	set recDeptDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),3)),"^",6)   //接收科室
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(recDeptDR)
	set expStr="^"_recDeptDR_"^^"_hospDR
	set grantCfg=##class(BILL.Interface.Inside.Invoke).GetAppPropValue(expStr)
	if (grantCfg="Y") {
		set grantFlag="Y"
	}
	quit grantFlag
}

/// Creator: wangjian
/// CreatDate: 2018-11-09
/// Description: 门诊退费申请
/// Input: ReqDrugInfo:药品申请信息 Info1_$c(2)_Info2_$c(2)_Info3_$c(2)……
/// 							Info=(InvID发票ID^PBODR账单医嘱ID^OEORI医嘱ID^ReqQty申请数量^ReqAmt申请金额^DSPBDR打包子表ID^OweFlag欠药标志^PHDItm发药子表或欠药子表ID^DispFlag已发药标志)
/// 	   ReqNonDrugInfo:非药品申请信息 Info1_$c(2)_Info2_$c(2)_Info3_$c(2)……
/// 							Info=(InvID发票ID^PBODR账单医嘱ID^OEORI医嘱ID^ReqQty申请数量^ReqAmt申请金额^ARTI_DR新版申请单中间表指针^RefundRepPart部分退费部位rowid串)
/// 	   ReqReason: 退费申请原因
/// 	   SessionStr: 收费员^安全组^登陆科室^院区
/// Return: 0^申请成功, 非0^错误描述
/// Debug: w ##class(web.DHCOPBillRefundRequest).RefundRequest("","1452^2339||3^1357||5^1^40.00^^","23","18850^225^39^2^20")
ClassMethod RefundRequest(ReqDrugInfo As %String, ReqNonDrugInfo As %String, ReqReason As %String, SessionStr As %String) As %String
{
 	set $zt="ERROR"
  	set ^TMP("RefundRequest")=$lb(ReqDrugInfo, ReqNonDrugInfo, ReqReason, SessionStr)
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	
  	set BCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(HospId)
	set CfgAppFlag=$p(BCfgInfo,"^",15)             //(0:不用审核, 1:一级审核, 2:二级审核)
	set TreatItmReqMode=$p(BCfgInfo,"^",50)        //检查、治疗医嘱审核模式
	
	set UnExecAuditCfg=..GetUnExecAuditCfg(HospId)   //+2023-04-12 ZhYW 未执行医嘱是否需要审核
	
  	set ErrCode=0
  	set OrdItmStr=""
  	
  	ts
  	
  	//药品申请
  	if (ReqDrugInfo'="") {
		kill DISPARY
		set Len=$l(ReqDrugInfo,$c(2))
		for i=1:1:Len {
			set SingleReqDrug=$p(ReqDrugInfo,$c(2),i)
			set InvPrtID=$p(SingleReqDrug,"^",1)
			set OEORI=$p(SingleReqDrug,"^",3)
			set ReqQty=$p(SingleReqDrug,"^",4)
			continue:(+ReqQty=0)
			set DSPBDR=$p(SingleReqDrug,"^",6)
		 	set OweFlag=$p(SingleReqDrug,"^",7)     //欠药标识(1:非欠药; 0:欠药)
			set PHDItm=$p(SingleReqDrug,"^",8)
			set DispFlag=$p(SingleReqDrug,"^",9)
			if ($$IsDirectRefAudit(InvPrtID)) {
				set ErrCode=-1_"^"_"已做直接退费审核，不能申请退费"
				quit
			}
			set DSPBStatus=$p($g(^DHCOEDISQTY(+DSPBDR,"I",$p(DSPBDR,"||",2))),"^",6)
			if ((+DispFlag=0)&&(DSPBStatus'="TC")) {
				set ErrCode=-1_"^"_"有药品已发药请重新申请"     //前台显示未发,后台已发返回错误重新申请
				quit
			}
			//+2023-02-16 ZhYW 根据配置的金额判断发票是否需要退费申请
			set AppFlag=CfgAppFlag
			if ((AppFlag=0)&&(..ChkRefAppByCfgAmt(InvPrtID))) {
				set AppFlag=1
			}
			//+2023-02-16 ZhYW 根据发票的结算费别判断是否需要退费审核
			if ((AppFlag=2)&&(..ChkRefAppByChrgInsType(InvPrtID))) {
				set AppFlag=1
			}
			//+2023-03-22 ZhYW 根据发票的结算时间判断是否需要退费审核
			if ((AppFlag=2)&&(..ChkRefAppByChrgPrtTime(InvPrtID))) {
				set AppFlag=1
			}
			set OrdItmStr=$s((OrdItmStr=""):OEORI,1:(OrdItmStr_"^"_OEORI))
			if (DSPBStatus="C") {
				set PrescNo=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",14)        //处方号
				set RecLocDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)
				set ReqDrugStr=OEORI_"^"_ReqQty_"^"_OweFlag_"^"_PHDItm_"^"_InvPrtID
				set DISPARY(RecLocDR,PrescNo)=$s(('$d(DISPARY(RecLocDR,PrescNo))):ReqDrugStr,1:(DISPARY(RecLocDR,PrescNo)_$c(2)_ReqDrugStr))
			}elseif (DSPBStatus="TC") {
				//+2023-04-12 ZhYW 未执行医嘱不需要审核时，申请即认为审核通过
				if ((AppFlag=2)&&('UnExecAuditCfg)) {
					set AppFlag=1
				}
				set IsOPIVAS=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",16)
				if (IsOPIVAS="Y") {
					//门诊静脉配液医嘱
					set OEORE=$p(^DHCOEDISQTY(+DSPBDR),"^",3)
					if (OEORE'="") {
						set RtnValue=##class(PHA.FACE.OUT.Com).SaveOPIVASStatus(OEORE, "Request")
						if ('(+RtnValue>0)) {
							set ErrCode=-416_"^"_"药房组接口[PHA.FACE.OUT.Com||SaveOPIVASStatus("_$lts($lb(OEORE, "Request"))_")]失败:"_RtnValue
							quit
						}
					}
				}
			}
		  	set ErrCode=..DrugRequest(SingleReqDrug, ReqReason, AppFlag, SessionStr)
		  	quit:(+ErrCode)
		}
		quit:(+ErrCode) ErrCode
		
		//已发药的发送退药申请单
		set RecLocDR=0
		while($o(DISPARY(RecLocDR))&&(+ErrCode=0)) {
			set RecLocDR=$o(DISPARY(RecLocDR))
			set PrescNo=""
			while(($o(DISPARY(RecLocDR,PrescNo))'="")&&(+ErrCode=0)) {
				set PrescNo=$o(DISPARY(RecLocDR,PrescNo))
				set OrdReqInfo=$g(DISPARY(RecLocDR,PrescNo))
				set RtnValue=##class(PHA.FACE.OUT.Com).SaveOutPhReq(RecLocDR, PrescNo, OrdReqInfo, ReqReason, UserId)
				if ('(+RtnValue>0)) {
					set ErrCode=-415_"^"_"药房组接口[PHA.FACE.OUT.Com||SaveOutPhReq("_$lts($lb(RecLocDR, PrescNo, OrdReqInfo, ReqReason, UserId))_")]失败:"_RtnValue
				}
			}
		}
	  	if (+ErrCode) tro  quit ErrCode
	}
	
	//非药品申请
	if (ReqNonDrugInfo'="") {
		set Len=$l(ReqNonDrugInfo,$c(2))
		for i=1:1:Len {
			set SingleReq=$p(ReqNonDrugInfo,$c(2),i)
			set InvPrtID=$p(SingleReq,"^",1)
			set OEORI=$p(SingleReq,"^",3)
			set DoseQty=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",12)		  //OEORI_PhQtyOrd
			continue:$d(^DHCINVPRT(0,"OEORI",OEORI,InvPrtID))       //申请过不再申请
		 	set ReqQty=$p(SingleReq,"^",4)
			continue:(+ReqQty=0)
			if ($$IsDirectRefAudit(InvPrtID)) {
				set ErrCode=-1_"^"_"已做直接退费审核，不能申请退费"
				quit
			}
			set ItemStatDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",13)
			set StatCode=$s((+ItemStatDR'=0):$p($g(^OEC("OSTAT",ItemStatDR)),"^",1),1:"")
			set Arcim=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
			set Confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
			set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
			if (isAppRep="Y") {
				set PartExecFlag=##class(web.DHCOPBillRefund).IsPartExecut(OEORI)
				if (PartExecFlag=0) {
					set StatCode=""
				}
			}else {
				//在执行记录上操作执行的，控制申请数量不能大于可退数量
				if (StatCode'="E") {
					set ExecQty=##class(web.UDHCJFBILL).GetOrdExecQty(OEORI)
					set UnExecQty=(DoseQty*Confac)-ExecQty
					if (ReqQty>UnExecQty) {
						set ErrCode=-1_"^"_"申请数量不能大于可退数量"
						quit
					}
				}
			}
			
			if ((+TreatItmReqMode=0)&&(StatCode="E")) {         //+2020-10-16 增加检查、治疗医嘱审核模式配置判断
				set ErrCode=-1_"^"_"有申请的医嘱已执行请重新申请"       //执行的医嘱不能申请
				quit
			}
			
			//+2023-02-16 ZhYW 根据配置的金额判断发票是否需要退费申请
			set AppFlag=CfgAppFlag
			if ((AppFlag=0)&&(..ChkRefAppByCfgAmt(InvPrtID))) {
				set AppFlag=1
			}
			//+2023-02-16 ZhYW 根据发票的结算费别判断是否需要退费审核
			if ((AppFlag=2)&&(..ChkRefAppByChrgInsType(InvPrtID))) {
				set AppFlag=1
			}
			//+2023-03-22 ZhYW 根据发票的结算时间判断是否需要退费审核
			if ((AppFlag=2)&&(..ChkRefAppByChrgPrtTime(InvPrtID))) {
				set AppFlag=1
			}
			if (StatCode'="E") {
				//+2023-04-12 ZhYW 未执行医嘱不需要审核时，申请即认为审核通过
				if ((AppFlag=2)&&('UnExecAuditCfg)) {
					set AppFlag=1
				}
			}
			set OrdItmStr=$s((OrdItmStr=""):OEORI,1:(OrdItmStr_"^"_OEORI))
		  	set ErrCode=..NonDrugRequest(SingleReq, ReqReason, AppFlag, SessionStr)
		}
		if (+ErrCode) tro  quit ErrCode
	}
	
	set ErrCode=..UpdateOEItmFAuth(OrdItmStr, UserId, CTLocId, ReqReason, "A")
	if (+ErrCode) tro  quit ErrCode
	
  	if ($tl>0)  tc
  	
  	quit ErrCode_"^"_"申请成功"
  
IsDirectRefAudit(prtRowId)
	//判断是否做了直接退费审核
	quit:(+prtRowId=0) 0
	set accPInvId=$p($g(^DHCINVPRT(prtRowId)),"^",4)
	if (+accPInvId'=0) {
		quit ##class(BILL.OP.BL.DirectRefundAudit).CheckIsAudited(accPInvId, "API")
	}
	quit ##class(BILL.OP.BL.DirectRefundAudit).CheckIsAudited(prtRowId, "PRT")
ERROR
	quit ..AppException()
}

/// Creator: wangjian
/// CreatDate: 2018-11-09
/// Description: 单条药品退费申请
/// Input:  SingleReqDrug: (InvID发票ID^PBODR账单医嘱ID^OEORI医嘱ID^ReqQty申请数量^ReqAmt申请金额^DSPBDR打包子表ID^OweFlag欠药标志^PHDItm发药子表或欠药子表ID^DispFlag已发药标志
ClassMethod DrugRequest(SingleReqDrug As %String, ReqReason As %String, AppFlag As %String, SessionStr As %String) As %String
{
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)

	set ErrCode=0

	set InvPrtID=$p(SingleReqDrug,"^",1)
	set PBODR=$p(SingleReqDrug,"^",2)
	set OEORI=$p(SingleReqDrug,"^",3)
	set ReqQty=$p(SingleReqDrug,"^",4)
	set ReqAmt=$p(SingleReqDrug,"^",5)
	set DSPBDR=$p(SingleReqDrug,"^",6)
	set OweFlag=$p(SingleReqDrug,"^",7)   //欠药标识(1:非欠药; 0:欠药)
	set PHDItm=$p(SingleReqDrug,"^",8)    //不欠药取发药孙表，欠药取欠药子表
	
	set PrescNo=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",14)        //处方号
	set ARCIMDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
	//判断是否已申请
	set reqRowId=..GetReqRowId(InvPrtID, PBODR, DSPBDR, PHDItm)
	quit:(reqRowId'="") -1_"^"_"有申请的药品医嘱已做退费申请，不能重复申请"
	
	set ReqDate=+$h
	set ReqTime=$p($h,",",2)

	//插入申请明细 申请表最大PLIST
	kill RequestAry
	do ..GetAuthPLIST(.RequestAry)
	set RequestAry(3)=OEORI
	set RequestAry(4)=UserId
	set RequestAry(5)=ReqDate
	set RequestAry(6)=ReqTime
	set RequestAry(7)=ReqQty
	set RequestAry(8)="A"
	set RequestAry(9)=PBODR
	set RequestAry(11)=DSPBDR
	set RequestAry(12)=OweFlag
	set RequestAry(13)=ReqReason
	set RequestAry(18)=CTLocId
	set RequestAry(19)=ARCIMDR
	set RequestAry(20)=PrescNo
	set RequestAry(23)=PHDItm    //不欠药存发药孙表, 欠药存欠药子表
	set RequestAry(24)=ReqAmt
	//如果是一级，状态改为审批通过
	if (AppFlag=1) {
		set RequestAry(8)="P"
		set RequestAry(14)=UserId
		set RequestAry(15)=ReqDate
		set RequestAry(16)=ReqTime
	}
	set RtnValue=..InsertINVOEItemAuth(InvPrtID, .RequestAry)
	set ErrCode=$p(RtnValue,"^",1)
	quit:(+ErrCode) RtnValue
	set IOARowID=$p(RtnValue,"^",2)
	
	//更新DHC_INVPRT表标志
	&SQL(
		UPDATE DHC_INVPRT
		SET PRT_AllowRefund = 1, PRT_AllRefundUser = :UserId, PRT_AllRefundDate = :ReqDate, 
			PRT_AllRefundTime = :ReqTime, PRT_RefundReason = :ReqReason, PRT_RefAuditLoc_DR = :CTLocId
		WHERE %ID = :InvPrtID
	)
	set ErrCode=SQLCODE
	quit:(+ErrCode) ErrCode_"^"_$g(%msg)
	
	quit ErrCode
}

/// Creator: wangjian
/// CreatDate: 2018-11-09
/// Description: 单条非药品退费申请
/// Input: SingleReq: InvID发票ID^PBODR账单医嘱ID^OEORI医嘱ID^ReqQty申请数量^ReqAmt申请金额^ARTI_DR新版申请单中间表指针^RefundRepPart部分退费部位rowid串
ClassMethod NonDrugRequest(SingleReq As %String, ReqReason As %String, AppFlag As %String, SessionStr As %String) As %String
{
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	
	set ErrCode=0
	
	set InvPrtID=$p(SingleReq,"^",1)
	set PBODR=$p(SingleReq,"^",2)
	set OEORI=$p(SingleReq,"^",3)
	set ReqQty=$p(SingleReq,"^",4)
	set ReqAmt=$p(SingleReq,"^",5)
	set ARTIDR=$p(SingleReq,"^",6)
	set RefundRepPart=$p(SingleReq,"^",7)
	
	set LabNo=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",20)     //检验号
	set ARCIMDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)
	
	//判断是否已申请
	set reqRowId=..GetReqRowId(InvPrtID, PBODR)
	quit:(reqRowId'="") -1_"^"_"有申请的非药品医嘱已做退费申请，不能重复申请"
	
	set ReqDate=+$h
	set ReqTime=$p($h,",",2)

	//插入申请明细 申请表最大PLIST
	kill RequestAry
	do ..GetAuthPLIST(.RequestAry)
	set RequestAry(3)=OEORI
	set RequestAry(4)=UserId
	set RequestAry(5)=ReqDate
	set RequestAry(6)=ReqTime
	set RequestAry(7)=ReqQty
	set RequestAry(8)="A"
	set RequestAry(9)=PBODR
	set RequestAry(10)=ARTIDR
	set RequestAry(13)=ReqReason
	set RequestAry(18)=CTLocId
	set RequestAry(19)=ARCIMDR
	set RequestAry(21)=RefundRepPart
	set RequestAry(22)=LabNo
	set RequestAry(24)=ReqAmt
	//如果是一级，状态改为审批通过
	if (AppFlag=1) {
		set RequestAry(8)="P"
		set RequestAry(14)=UserId
		set RequestAry(15)=ReqDate
		set RequestAry(16)=ReqTime
	}
	set RtnValue=..InsertINVOEItemAuth(InvPrtID, .RequestAry)
	set ErrCode=$p(RtnValue,"^",1)
	quit:(+ErrCode) RtnValue
	set IOARowID=$p(RtnValue,"^",2)
	
	//调用新产品组接口
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
	if ((isAppRep="Y")&&(RefundRepPart'="")) {
		set RtnValue=##class(web.DHCAPPInterface).SetExaReqFlag(OEORI, RefundRepPart, "Y")
		set ErrCode=$p(RtnValue,"^",1)
		quit:(+ErrCode) +ErrCode_"^"_"医生站组接口[web.DHCAPPInterface||SetExaReqFlag("_$lts($lb(OEORI, RefundRepPart, "Y"))_")]失败:"_RtnValue
	}

	//插入退费数量
	set OrdReqInfo=OEORI_"^"_ReqQty
	set myExpStr=InvPrtID
	set RtnValue=##class(web.DHCOPBillOERefundQty).InertApplyRefundQty(OrdReqInfo, UserId, myExpStr)
	set ErrCode=$p(RtnValue,"^",1)
	quit:(+ErrCode) RtnValue
	
	&SQL(
		UPDATE DHC_INVPRT
		SET PRT_AllowRefund = 1, PRT_AllRefundUser = :UserId, PRT_AllRefundDate = :ReqDate, 
			PRT_AllRefundTime = :ReqTime, PRT_RefundReason = :ReqReason, PRT_RefAuditLoc_DR = :CTLocId
		WHERE %ID = :InvPrtID
	)
	set ErrCode=SQLCODE
	quit:(+ErrCode) ErrCode_"^"_$g(%msg)
	
	quit ErrCode
}

/// Creator: wangjian
/// CreatDate: 2018-11-09
/// Description: 插入申请单
ClassMethod InsertINVOEItemAuth(PRTRowID As %String, ByRef RequestAry) As %String
{
	set rtn=0
	ts
	
	&SQL(
		INSERT INTO DHC_INVOEItemAuthorize (
			PRT_IOA_ParRef, IOA_OEORI_DR, IOA_User_DR, IOA_Date, IOA_Time,
			IOA_RequestQty, IOA_Flag, IOA_PBO_DR, IOA_ARTI_DR, IOA_DSPB_DR,
			IOA_DrugOweFlag, IOA_ReasonDR, IOA_AuditUser, IOA_AuditDate, IOA_AuditTime,
			IOA_AuditView, IOA_ReqestDeptDR, IOA_ARCIM_DR, IOA_PrescNo, IOA_RefundRepPart,
			IOA_LabNo, IOA_PHDISITMCLB, IOA_RequestAmt
		)
		VALUES (
			:PRTRowID, :RequestAry(3), :RequestAry(4), :RequestAry(5), :RequestAry(6),
			:RequestAry(7), :RequestAry(8), :RequestAry(9), :RequestAry(10), :RequestAry(11),
			:RequestAry(12), :RequestAry(13), :RequestAry(14), :RequestAry(15), :RequestAry(16),
			:RequestAry(17), :RequestAry(18), :RequestAry(19), :RequestAry(20), :RequestAry(21),
			:RequestAry(22), :RequestAry(23), :RequestAry(24)
		)
	)
    set rtn=SQLCODE
    if (+rtn) tro  quit rtn_"^"_$g(%msg)
    set IOARowID=$g(%ROWID)
    
   	if ($tl>0)  tc
    
    quit rtn_"^"_IOARowID
}

/// Description: 更新医嘱表的审核
ClassMethod UpdateOEItmFAuth(OEORDStr As %String, UserDR As %String, RefAuditLocDR As %String, RefundReason As %String, AuditStatus As %String) As %String
{
	set rtn=0
	set curDate=+$h
	set curTime=$p($h,",",2)
	
	set myCount=$l(OEORDStr,"^")
	for i=1:1:myCount {
		set myOEORI=$p(OEORDStr,"^",i)
		continue:(myOEORI="")
		set myExpOERowID=$o(^DHCORDItem(0,myOEORI,0))
		if (myExpOERowID="") {
			&SQL(
				INSERT INTO DHC_OE_OrdItem (
					DHCORI_OEORI_Dr, DHCORI_RefundAuditStatus, DHCORI_RefundAuditUser_Dr,
					DHCORI_RefundAuditDate, DHCORI_RefundAuditTime, DHCORI_RefundReason,
					DHCORI_RefAuditLoc_DR
				)
				VALUES (
					:myOEORI, :AuditStatus, :UserDR,
					:curDate, :curTime, :RefundReason,
					:RefAuditLocDR
				)
			)
		}else {
			&SQL(
				UPDATE DHC_OE_OrdItem
				SET DHCORI_RefundAuditStatus = :AuditStatus, DHCORI_RefundAuditUser_Dr = :UserDR,
					DHCORI_RefundAuditDate = :curDate, DHCORI_RefundAuditTime = :curTime,
					DHCORI_RefundReason = :RefundReason, DHCORI_RefAuditLoc_DR = :RefAuditLocDR
				WHERE %ID = :myExpOERowID
			)
		}
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2021-08-24
/// Description: 判断医嘱是否允许部分退费
/// Input: oeitm:OE_OrdItem.RowId, hospId:CT_Hospital.RowId
/// Output: Y:是，<>Y:否
/// Debug: w ##class(web.DHCOPBillRefundRequest).CheckOrdAllowPartRequest("3632||13", 2)
ClassMethod CheckOrdAllowPartRequest(oeitm As %String, hospId As %String) As %String
{
	set rtn="N"
	quit:($l(oeitm,"||")'=2) rtn
	set ord=$p(oeitm,"||",1)
	set itm=$p(oeitm,"||",2)
	quit:('$d(^OEORD(ord,"I",itm,1))) rtn
	set arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	quit:(arcim="") rtn
	set arcGrp=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	quit:(arcGrp="") rtn
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_OP_PartRefApp", hospId)
	
	//查询该医嘱项的配置
	set cfgId=""
	while($o(^DHCJFOrderRefundAppConfig(0,"Arcim",arcim,cfgId),-1)) {
		set cfgId=$o(^DHCJFOrderRefundAppConfig(0,"Arcim",arcim,cfgId),-1)
		set cfgData=$g(^DHCJFOrderRefundAppConfig(cfgId))
		set hospDR=$p(cfgData,"^",15)
		continue:(hospDR'=defHospId)
		set dateFrom=$p(cfgData,"^",3)
		set dateTo=$p(cfgData,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set isActive=$p(cfgData,"^",14)
		continue:(isActive'="Y")
		set rtn="Y"
		quit
	}
	quit:(rtn="Y") rtn
	
	//查询该医嘱分类的配置
	set cfgId=""
	while($o(^DHCJFOrderRefundAppConfig(0,"Arcic",arcGrp,cfgId),-1)) {
		set cfgId=$o(^DHCJFOrderRefundAppConfig(0,"Arcic",arcGrp,cfgId),-1)
		set cfgData=$g(^DHCJFOrderRefundAppConfig(cfgId))
		set hospDR=$p(cfgData,"^",15)
		continue:(hospDR'=defHospId)
		set arcimDR=$p(cfgData,"^",2)
		continue:(arcimDR'="")     //过滤了配置了医嘱项的记录
		set dateFrom=$p(cfgData,"^",3)
		set dateTo=$p(cfgData,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set isActive=$p(cfgData,"^",14)
		continue:(isActive'="Y")
		set rtn="Y"
		quit
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-11-08
/// Description: 判断是否是急诊留观发票
/// Input: invNo:发票号
/// Return: Y:是，<>Y:否
/// Debug: w ##class(web.DHCOPBillRefundRequest).CheckIsStayInv()
ClassMethod CheckIsStayInv(invNo As %String) As %String
{
	set stayFlag="N"
	quit:(invNo="") stayFlag
	set prtRowId=$o(^DHCINVPRT(0,"INV",invNo,0))
	quit:(prtRowId="") stayFlag
	set stayFlag=$p($g(^DHCINVPRT(prtRowId)),"^",44)
	quit stayFlag
}

/// Creator: ZhYW
/// CreatDate: 2018-11-08
/// Description: 取票据已申请退费金额
/// Input: invStr
/// Return: reqAmt
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetAlreadyReqAmt("228460:PRT")
ClassMethod GetAlreadyReqAmt(invStr As %String) As %String
{
	set reqAmt=0
	for i=1:1:$l(invStr,"^") {
		set myInvStr=$p(invStr,"^",i)
		continue:(myInvStr="")
		set invId=$p(myInvStr,":",1)
		set invType=$p(myInvStr,":",2)
		continue:((invId="")||(invType=""))
		if (invType="API") {
			set apiConDR=0
			while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))) {
				set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))
				set prtId=$p($g(^DHCINVPRTCAP(apiConDR)),"^",1)
				do GetInvReqAmt(prtId, .reqAmt)
			}
		}else {
			do GetInvReqAmt(invId, .reqAmt)
		}
	}
	
	quit $fn(reqAmt,"",2)
	
GetInvReqAmt(prtId, reqAmt)
	set sub=0
	while($o(^DHCINVPRT(prtId,"OA",sub))) {
		set sub=$o(^DHCINVPRT(prtId,"OA",sub))
		set subData=$g(^DHCINVPRT(prtId,"OA",sub))
		continue:(subData="")
		set myAmt=$p(subData,"^",22)
		set reqAmt=$i(reqAmt,myAmt)
	}
	
	quit
}

/// Creator: wangjian
/// CreatDate: 2018-11-12
/// Description: 门诊撤销退费申请
/// Input: CancelReqInfo, SessionStr:收费员^安全组^登陆科室^院区
/// Return: code^desc
/// Debug: w ##class(web.DHCOPBillRefundRequest).CancelRequest("14838||1^14836||1","12173^239^49^2")
ClassMethod CancelRequest(CancelReqInfo As %String, SessionStr As %String) As %String
{
	set $zt="ERROR"
  	set ^TMP("CancelReqInfo")=$lb(CancelReqInfo, SessionStr)
  	
  	set rtn=0
  	quit:(CancelReqInfo="") -1_"^"_"没有已申请的票据"

  	ts
  	
	set Len=$l(CancelReqInfo,"^")
	for i=1:1:Len {
		set ReqID=$p(CancelReqInfo,"^",i)
		continue:(ReqID="")
		set rtn=..CancelReqSingle(ReqID, SessionStr)
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn

  	if ($tl>0)  tc
  	
  	quit rtn_"^"_"撤销成功"
  	
ERROR
	quit ..AppException()
}

/// Creator: wangjian
/// CreatDate: 2018-11-12
/// Description: 门诊撤销退费申请
/// Input: ReqID:DHC_INVOEItemAuthorize.RowId, SessionStr:收费员^安全组^登陆科室^院区
/// Return: code^desc
/// Debug: w ##class(web.DHCOPBillRefundRequest).CancelReqSingle("228470", 1)
ClassMethod CancelReqSingle(ReqID As %String, SessionStr As %String) As %String
{
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	
	set ErrCode=0
	
	set InvPrtID=$p(ReqID,"||",1)
	set IOASub=$p(ReqID,"||",2)

	//取配置
  	set BCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(HospId)
	set CfgAppFlag=$p(BCfgInfo,"^",15)    //(0:不用审核, 1:一级审核, 2:二级审核)
	
	set UnExecAuditCfg=..GetUnExecAuditCfg(HospId)   //+2023-04-12 ZhYW 未执行医嘱是否需要审核
	
	set IOAData=$g(^DHCINVPRT(InvPrtID,"OA",IOASub))
	quit:(IOAData="") ErrCode
	set OEORI=$p(IOAData,"^",1)
 	quit:(OEORI="") ErrCode
	set IOAFlag=$p(IOAData,"^",6)
	
	set AppFlag=CfgAppFlag
	//+2023-02-16 ZhYW 根据发票的结算费别判断是否需要退费审核
	if ((AppFlag=2)&&(..ChkRefAppByChrgInsType(InvPrtID))) {
		set AppFlag=1
	}
	//+2023-03-22 ZhYW 根据发票的结算时间判断是否需要退费审核
	if ((AppFlag=2)&&(..ChkRefAppByChrgPrtTime(InvPrtID))) {
		set AppFlag=1
	}
	//+2023-04-12 ZhYW 根据医嘱的执行状态判断是否需要退费审核
	if ((AppFlag=2)&&('UnExecAuditCfg)) {
		set AppFlag=1
	}
	if ((AppFlag=2)&&(IOAFlag="P")) {      //配置了二级审核时，已审核过的不能取消申请
		set ErrCode=-500_"^"_"已审核发票，请先撤销审核后再取消申请"
		quit ErrCode
	}
 	
	//校验物资材料是否已退
 	set MatDispGrant=..CheckIsMatDispGrant(OEORI)
	if (MatDispGrant="Y") {
		set DispStat=..CheckMatDisp(OEORI)
	 	set RefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, InvPrtID)
	  	set RefQty=+$p(RefQtyInfo,"^",2)
	  	if ((DispStat'=0)&&(RefQty'=0)) {
		  	set ErrCode=-503_"^"_"材料已退，撤销申请失败"
		  	quit ErrCode
		}
	}
	
	//非药品退费数量更新为0
	set OrdCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORI)
	if (OrdCateType'="R") {
		set myExpStr=InvPrtID
		set RtnValue=##class(web.DHCOPBillOERefundQty).Insert(OEORI, 0, UserId, myExpStr)
		set ErrCode=$p(RtnValue,"^",1)
 		quit:(+ErrCode) RtnValue
	}
	
	//撤销退药申请
	set DSPBDR=$p(IOAData,"^",9)
	set DSPBStatus=$s((DSPBDR'=""):$p($g(^DHCOEDISQTY(+DSPBDR,"I",$p(DSPBDR,"||",2))),"^",6),1:"")
	if (DSPBStatus="TC") {
		set IsOPIVAS=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",16)
		if (IsOPIVAS="Y") {
			//门诊静脉配液医嘱
			set OEORE=$p(^DHCOEDISQTY(+DSPBDR),"^",3)
			if (OEORE'="") {
				set RtnValue=##class(PHA.FACE.OUT.Com).SaveOPIVASStatus(OEORE, "")
				if ('(+RtnValue>0)) {
					set ErrCode=-416_"^"_"药房组接口[PHA.FACE.OUT.Com||SaveOPIVASStatus("_$lts($lb(OEORE, ""))_")]失败:"_RtnValue
					quit ErrCode
				}
			}
		}
	}
	set OweFlag=$p(IOAData,"^",10)
	set PHDItm=$p(IOAData,"^",21)
	if (DSPBStatus="C") {
		set ParamStr=OEORI_"^"_InvPrtID_"^"_OweFlag_"^"_PHDItm
		set RtnValue=##class(PHA.FACE.OUT.Com).IsAllowDelPhReq(ParamStr)
		set ErrCode=$p(RtnValue,"^",1)
		if (+ErrCode) quit RtnValue   //退药申请已退药，不能撤销
		
		set ParamStr=OEORI_"^"_InvPrtID_"^"_OweFlag_"^"_PHDItm
		set RtnValue=##class(PHA.FACE.OUT.Com).DelOutPhReq(ParamStr)   //撤销退药申请时，按照发票RowId来撤销
		set ErrCode=$p(RtnValue,"^",1)
		quit:(+ErrCode) +ErrCode_"^"_"药房组接口[PHA.FACE.OUT.Com||DelOutPhReq("_$lts($lb(ParamStr))_")]失败:"_RtnValue
	}
	
	//撤销多部位申请单
	set RefundRepPart=$p(IOAData,"^",19)
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
	if ((isAppRep="Y")&&(RefundRepPart'="")) {
		set RtnValue=##class(web.DHCAPPInterface).SetExaReqFlag(OEORI, RefundRepPart, "N")
		set ErrCode=$p(RtnValue,"^",1)
		quit:(+ErrCode) +ErrCode_"^"_"医生站组接口[web.DHCAPPInterface||SetExaReqFlag("_$lts($lb(OEORI, RefundRepPart, "N"))_")]失败:"_RtnValue
	}
	
	set ErrCode=..UpdateOEItmFAuth(OEORI, UserId, "", "", "C")
	quit:(+ErrCode) ErrCode
	
	//删除申请表记录
	&SQL(DELETE FROM DHC_INVOEItemAuthorize WHERE %ID = :ReqID)
	set ErrCode=SQLCODE
	quit:(+ErrCode) ErrCode_"^"_$g(%msg)
	
	//全部撤销申请时，将发票表记录更新为未审核状态
	if ($o(^DHCINVPRT(InvPrtID,"OA",0))="") {
		&SQL(
			UPDATE DHC_INVPRT
			SET PRT_AllowRefund = NULL, PRT_AllRefundUser = NULL, PRT_AllRefundDate = NULL, 
				PRT_AllRefundTime = NULL, PRT_RefundReason = NULL, PRT_RefAuditLoc_DR = NULL
			WHERE %ID = :InvPrtID
		)
		set ErrCode=SQLCODE
		quit:(+ErrCode) ErrCode_"^"_$g(%msg)
	}
    
    quit ErrCode
}

/// Creator: hulihua
/// CreatDate: 2018-11-09
/// Description: 通过门诊打包子表ID获取发药数量和已退药数量
/// Table: DHC_OEDispBatch、DHC_PHDISITMCLB
/// Input: DspBatchId: 打包子表ID
/// Return: 发药数量，退药数量
/// Others: 对应的库存项基本单位的数量
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetPhdQtyByDspbId("269766||1","1476||1||1")
ClassMethod GetPhdQtyByDspbId(DspBatchId As %String, PhdicId As %String = "") As %String
{
	quit:(DspBatchId="") "^"
	
	set (SumDispQty, SumRetQty)=0
	
	set PhdId=0
	while($o(^DHCPHDIi("DSPB",DspBatchId,PhdId))) {
		set PhdId=$o(^DHCPHDIi("DSPB",DspBatchId,PhdId))
		set PhdCh=0
		while($o(^DHCPHDIi("DSPB",DspBatchId,PhdId,PhdCh))) {
			set PhdCh=$o(^DHCPHDIi("DSPB",DspBatchId,PhdId,PhdCh))
			set PhdSub=0
			while($o(^DHCPHDIi("DSPB",DspBatchId,PhdId,PhdCh,PhdSub))) {
				set PhdSub=$o(^DHCPHDIi("DSPB",DspBatchId,PhdId,PhdCh,PhdSub))
				set PhdicData=$g(^DHCPHDI(PhdId,"PHDI",PhdCh,"INCLB",PhdSub))
				continue:(PhdicData="")
				set PhdicRowId=PhdId_"||"_PhdCh_"||"_PhdSub
				continue:((PhdicId'="")&&(PhdicId'=PhdicRowId))
				set DispQty=$p(PhdicData,"^",1)
				set RetQty=$p(PhdicData,"^",2)
				set SumDispQty=$i(SumDispQty, DispQty)
				set SumRetQty=$i(SumRetQty, RetQty)
			}
		}
	}
	
	quit SumDispQty_"^"_SumRetQty
}

/// Creator: MaYuqiang
/// CreateDate:	2021-06-11
/// Description: 通过门诊打包子表ID获取草药发药数量和已退药数量
/// Table: DHC_OEDispBatch、bs_pha_herb.dispen
/// Input: DspBatchId-打包子表ID
/// Return: 发药数量，退药数量
/// Others: 对应的库存项基本单位的数量
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetPhbdQtyByDspbId("30542||1")
ClassMethod GetPhbdQtyByDspbId(DspBatchId As %String, PhbdicId As %String = "") As %String
{
	quit:(DspBatchId="") "^"
	
	set (SumDispQty, SumRetQty)=0
	
	set phbdId=0
	while($o(^BS.PHA.HERB.DISPENI("DspBatch",DspBatchId,phbdId))) {
		set phbdId=$o(^BS.PHA.HERB.DISPENI("DspBatch",DspBatchId,phbdId))
		set phbdCh=0
		while($o(^BS.PHA.HERB.DISPENI("DspBatch",DspBatchId,phbdId,phbdCh))) {
			set phbdCh=$o(^BS.PHA.HERB.DISPENI("DspBatch",DspBatchId,phbdId,phbdCh))
			set phbdSub=0
			while($o(^BS.PHA.HERB.DISPENI("DspBatch",DspBatchId,phbdId,phbdCh,phbdSub))) {
				set phbdSub=$o(^BS.PHA.HERB.DISPENI("DspBatch",DspBatchId,phbdId,phbdCh,phbdSub))
				set phbdicData=$g(^BS.PHA.HERB.DISPEND(phbdId,"I",phbdCh,"B",phbdSub))
				continue:(phbdicData="")
				set phbdicRowId=phbdId_"||"_phbdCh_"||"_phbdSub
				continue:((PhbdicId'="")&&(PhbdicId'=phbdicRowId))
				set DispQty=$lg(phbdicData,2)
				set RetQty=$lg(phbdicData,3)
				set SumDispQty=$i(SumDispQty, DispQty)
				set SumRetQty=$i(SumRetQty, RetQty)
			}
		}
	}
	
	quit SumDispQty_"^"_SumRetQty
}

/// Creator: ZhYW
/// CreatDate: 2018-11-16
/// Description: 查询做了申请/审核的票据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillRefundRequest","FindReqInvInfo","2021-03-01","2021-11-08","","","","","5^122^49^2^1")
Query FindReqInvInfo(stDate As %String, endDate As %String, receiptNo As %String, patientNo As %String, patientName As %String, chargeUser As %String, sessionStr As %String) As websys.Query(ROWSPEC = "invNo:%String:发票号,patNo:%String:登记号,patName:%String:患者姓名,prtAcount:%Float:费用总额,prtPatShare:%Float:自付金额,prtUserName:%String:收费员,prtDate:%String:收费日期,prtTime:%String:收费时间,prtRowId:%String:发票ID,invFlag:%String:发票类型标识")
{
}

ClassMethod FindReqInvInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, receiptNo As %String, patientNo As %String, patientName As %String, chargeUser As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindReqInvInfo")=$lb(stDate, endDate, receiptNo, patientNo, patientName, chargeUser, sessionStr)
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)

	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	if (receiptNo'="") {
		//门诊收费
		set invFlag="PRT"
		set prtRowId=0
		while($o(^DHCINVPRT(0,"INV",receiptNo,prtRowId))) {
			set prtRowId=$o(^DHCINVPRT(0,"INV",receiptNo,prtRowId))
			continue:('..CheckInvIsReqById(prtRowId, invFlag))
			do GetInvInfo(prtRowId)
		}
		//集中打印发票
		set invFlag="API"
		set prtRowId=0
		while($o(^DHCINVPRTAPi(0,"INVNo",receiptNo,prtRowId))) {
			set prtRowId=$o(^DHCINVPRTAPi(0,"INVNo",receiptNo,prtRowId))
			continue:('..CheckInvIsReqById(prtRowId, invFlag))
			do GetAPIInfo(prtRowId)
		}
		
		quit $$$OK
	}
	
	kill patIdAry
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set papmi=$o(^PAPERi("PAPMI_PatNo",$zcvt(patientNo,"U"),""))
		if (papmi'="") {
			set patIdAry(papmi)=""
		}
	}elseif (patientName'="") {
		do ##class(BILL.COM.PAPatMas).GetPatientByName(patientName, .patIdAry)
	}
	
	if ($d(patIdAry)) {
		set papmi=0
		while($o(patIdAry(papmi))) {
			set papmi=$o(patIdAry(papmi))
			//门诊收费
			set invFlag="PRT"
			set prtRowId=""
			while($o(^DHCINVPRT(0,"PAPMI",papmi,prtRowId),-1)) {
				set prtRowId=$o(^DHCINVPRT(0,"PAPMI",papmi,prtRowId),-1)
				set prtDate=$p(^DHCINVPRT(prtRowId),"^",5)
				set prtTime=$p(^DHCINVPRT(prtRowId),"^",20)
				continue:((prtDate<stDate)||(prtDate>endDate))
				continue:('..CheckInvIsReqById(prtRowId, invFlag))
				do GetInvInfo(prtRowId)
			}
			//集中打印发票
			set invFlag="API"
			set prtRowId=""
			while($o(^DHCINVPRTAPi(0,"PAPMI",papmi,prtRowId),-1)) {
				set prtRowId=$o(^DHCINVPRTAPi(0,"PAPMI",papmi,prtRowId),-1)
				set prtDate=$p(^DHCINVPRTAP(prtRowId),"^",3)
				set prtTime=$p(^DHCINVPRTAP(prtRowId),"^",4)
				continue:((prtDate<stDate)||(prtDate>endDate))
				continue:('..CheckInvIsReqById(prtRowId, invFlag))
				do GetAPIInfo(prtRowId)
			}
		}
	}else {
		for date=endDate:-1:stDate {
			//门诊收费
			set invFlag="PRT"
			set prtRowId=""
			while($o(^DHCINVPRT(0,"Date",date,prtRowId),-1)) {
				set prtRowId=$o(^DHCINVPRT(0,"Date",date,prtRowId),-1)
				continue:('..CheckInvIsReqById(prtRowId, invFlag))
				do GetInvInfo(prtRowId)
			}
			//集中打印发票
			set invFlag="API"
			set prtRowId=""
			while($o(^DHCINVPRTAPi(0,"Date",date,prtRowId),-1)) {
				set prtRowId=$o(^DHCINVPRTAPi(0,"Date",date,prtRowId),-1)
				continue:('..CheckInvIsReqById(prtRowId, invFlag))
				do GetAPIInfo(prtRowId)
			}
		}
	}

	quit $$$OK
	
GetInvInfo(prtRowId)
	set invData=$g(^DHCINVPRT(prtRowId))
	quit:(invData="")
	set hospDR=$p(invData,"^",39)
	quit:((hospId'="")&&(hospDR'=hospId))
	set prtAcount=$fn($p(invData,"^",1),"",2)
	set invNo=$p(invData,"^",14)
	set invPrtFlag=$p(invData,"^",3)
	set accPayInvDR=$p(invData,"^",4)
	quit:(accPayInvDR'="")      //做了集中打印发票的退出
	set prtDate=$p(invData,"^",5)
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
	set prtTime=$p(invData,"^",20)
	set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
	set prtUserDR=$p(invData,"^",21)
	set prtUserCode=$s((+prtUserDR'=0):$p($g(^SSU("SSUSR",prtUserDR)),"^",1),1:"")
	set prtUserName=$s((+prtUserDR'=0):$p($g(^SSU("SSUSR",prtUserDR)),"^",2),1:"")
	quit:((chargeUser'="")&&($$ALPHAUP^SSUTIL4(prtUserCode)'[$$ALPHAUP^SSUTIL4(chargeUser))&&($$ALPHAUP^SSUTIL4(prtUserName)'[$$ALPHAUP^SSUTIL4(chargeUser)))
	set prtUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", prtUserName, langId)
	set papmi=$p(invData,"^",15)
	set patName=$s((+papmi'=0):$p($g(^PAPER(papmi,"ALL")),"^",1),1:"")
	set patNo=$s((+papmi'=0):$p($g(^PAPER(papmi,"PAT",1)),"^",1),1:"")
	set prtPatShare=$p(invData,"^",16)
	set prtPatShare=$fn(prtPatShare,"",2)
	do OutputReqInvInfo
	quit

GetAPIInfo(prtRowId)
	set invData=$g(^DHCINVPRTAP(prtRowId))
	quit:(invData="")
	set hospDR=$p(invData,"^",30)
	quit:((hospId'="")&&(hospDR'=hospId))
	set prtAcount=$fn($p(invData,"^",1),"",2)
	set invNo=$p(invData,"^",6)
	set prtDate=$p(invData,"^",3)
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
	set prtTime=$p(invData,"^",4)
	set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
	set prtUserDR=$p(invData,"^",5)
	set prtUserCode=$s((+prtUserDR'=0):$p($g(^SSU("SSUSR",prtUserDR)),"^",1),1:"")
	set prtUserName=$s((+prtUserDR'=0):$p($g(^SSU("SSUSR",prtUserDR)),"^",2),1:"")
	quit:((chargeUser'="")&&($$ALPHAUP^SSUTIL4(prtUserCode)'[$$ALPHAUP^SSUTIL4(chargeUser))&&($$ALPHAUP^SSUTIL4(prtUserName)'[$$ALPHAUP^SSUTIL4(chargeUser)))
	set prtUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", prtUserName, langId)
	set papmi=$p(invData,"^",11)
	set patName=$s((+papmi'=0):$p($g(^PAPER(papmi,"ALL")),"^",1),1:"")
	set patNo=$s((+papmi'=0):$p($g(^PAPER(papmi,"PAT",1)),"^",1),1:"")
	set prtPatShare=$p(invData,"^",13)
	set prtPatShare=$fn(prtPatShare,"",2)
	do OutputReqInvInfo
	quit
	
OutputReqInvInfo
	set Data=$lb(invNo,patNo,patName,prtAcount,prtPatShare,prtUserName,prtDate,prtTime,prtRowId,invFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-11-16
/// Description: 判断发票是否已做申请
/// Input: invNo:发票号
/// Return: 0:发票不存在或未做申请，1:已做申请
/// Debug: w ##class(web.DHCOPBillRefundRequest).CheckInvIsReqByInvNo("ZY100001770")
ClassMethod CheckInvIsReqByInvNo(invNo As %String) As %String
{
	quit:(invNo="") ""
	set prtRowId=$o(^DHCINVPRT(0,"INV",invNo,0))
	if (+prtRowId'=0) {
		quit ..CheckInvIsReqById(prtRowId, "PRT")
	}
	set prtRowId=$o(^DHCINVPRTAPi(0,"INVNo",invNo,0))
	if (+prtRowId'=0) {
		quit ..CheckInvIsReqById(prtRowId, "API")
	}
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2018-11-15
/// Description: 判断发票是否已做申请
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefundRequest).CheckInvIsReqById()
ClassMethod CheckInvIsReqById(prtRowId As %String, invType As %String) As %String
{
	quit:(+prtRowId=0) 0
	if (invType="API") {
		quit $$CheckAPI(prtRowId)
	}
	quit $$CheckInv(prtRowId)
	
CheckAPI(prtRowId)
	set rtn=0
	set prtFlag=$p(^DHCINVPRTAP(prtRowId),"^",2)
	quit:(prtFlag'="N") rtn
	set apiConDR=0
	while($o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,apiConDR))&&(rtn=0)) {
		set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,apiConDR))
		set prtId=$p($g(^DHCINVPRTCAP(apiConDR)),"^",1)
		set rtn=$$CheckInv(prtId)
	}
	
	quit rtn
	
CheckInv(prtRowId)
	set rtn=0
	set prtFlag=$p(^DHCINVPRT(prtRowId),"^",8)
	quit:(prtFlag'="N") rtn
	set rtn=($o(^DHCINVPRT(prtRowId,"OA",0))>0)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-11-16
/// Description: 查询已做申请的医嘱明细
/// Input: 
/// Ouput: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillRefundRequest","FindIOASubInfo","16912:PRT^16781:PRT^16769:PRT^16743:PRT^16708:PRT^16702:PRT^16609:PRT^16608:PRT^16565:PRT","U","12173^239^49^2^1")
Query FindIOASubInfo(invStr As %String, auditFlag As %String, sessionStr As %String) As websys.Query(ROWSPEC = "arcimDesc:%String,packUom:%String,reqQty:%String,reqAmt:%String,reqUserName:%String,reqDate:%String,reqTime:%String,reqReason:%String,reqFlag:%String,auditUserName:%String,auditDate:%String,auditTime:%String,prescNo:%String,recDept:%String,invSubId:%String,oeori:%String,ordCateType:%String,phdicId:%String,isCNMedItem:%String,isOweDrug:%String")
{
}

ClassMethod FindIOASubInfoExecute(ByRef qHandle As %Binary, invStr As %String, auditFlag As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (invStr="") quit $$$OK
	set ^TMP("FindIOASubInfo")=$lb(invStr, auditFlag, sessionStr)
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	for i=1:1:$l(invStr,"^") {
		set myInvStr=$p(invStr,"^",i)
		continue:(myInvStr="")
		set invId=$p(myInvStr,":",1)
		set invType=$p(myInvStr,":",2)
		continue:((invId="")||(invType=""))
		if (invType="API") {
			set apiConDR=0
			while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))) {
				set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))
				set prtId=$p($g(^DHCINVPRTCAP(apiConDR)),"^",1)
				do GetIOASub(prtId)
			}
			continue
		}
		
		do GetIOASub(invId)
	}
	
	quit $$$OK
	
GetIOASub(prtRowId)
	set prtFlag=$p($g(^DHCINVPRT(prtRowId)),"^",8)
	quit:(prtFlag'="N")
	set sub=0
	while($o(^DHCINVPRT(prtRowId,"OA",sub))) {
		set sub=$o(^DHCINVPRT(prtRowId,"OA",sub))
		set subData=$g(^DHCINVPRT(prtRowId,"OA",sub))
		continue:(subData="")
		set invSubId=prtRowId_"||"_sub
		set oeori=$p(subData,"^",1)
		set recDeptDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),3)),"^",6)       //接收科室
		set recDept=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
		set recDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDept, langId)
		set reqUserDR=$p(subData,"^",2)
		set reqUserName=$s((+reqUserDR'=0):$p($g(^SSU("SSUSR",reqUserDR)),"^",2),1:"")
		set reqUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", reqUserName, langId)
		set reqDate=$p(subData,"^",3)
		set reqDate=##class(websys.Conversions).DateLogicalToHtml(reqDate)
		set reqTime=$p(subData,"^",4)
		set reqTime=##class(websys.Conversions).TimeLogicalToHtml(reqTime)
		set reqQty=$p(subData,"^",5)
		set reqFlag=$p(subData,"^",6)
		set dspbDR=$p(subData,"^",9)
		set isOweDrug=$p(subData,"^",10)       //欠药标识(0:欠药; 1:非欠药)
		set reqReasonDR=$p(subData,"^",11)
		set reqReason=$s((+reqReasonDR'=0):$p($g(^DHCINVOPREFR(reqReasonDR)),"^",2),1:"")
		set reqReason=##class(User.DHCINVOPRefReason).GetTranByDesc("IRRDesc", reqReason, langId)
		set auditUserDR=$p(subData,"^",12)
		continue:((auditFlag="U")&&(reqFlag="P"))      //查询未审核时，已审核的过滤
		continue:((auditFlag="A")&&(reqFlag'="P"))     //查询已审核时，未审核的过滤
		set auditUserName=$s((+auditUserDR'=0):$p($g(^SSU("SSUSR",auditUserDR)),"^",2),1:"")
		set auditUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", auditUserName, langId)
		set auditDate=$p(subData,"^",13)
		set auditDate=##class(websys.Conversions).DateLogicalToHtml(auditDate)
		set auditTime=$p(subData,"^",14)
		set auditTime=##class(websys.Conversions).TimeLogicalToHtml(auditTime)
		set arcim=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
		set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeori, 1)
		set isCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(arcim, hospId)
		set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
		set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeori)              //新版检查申请单标志
		if (isAppRep="Y") {
			set partDesc=##class(web.DHCAPPInterface).GetReqBillPartIDDesc(oeori)
			set arcimDesc=arcimDesc_partDesc
		}
		set prescNo=$p(subData,"^",18)
		set phdicId=$p(subData,"^",21)     //不欠药存的发药孙表, 欠药存的欠药子表
		set reqAmt=$p(subData,"^",22)
		set reqAmt=$fn(reqAmt,"",2)
		set packUom=##class(web.DHCBillCommon).GetPackUom(arcim, oeori)
		set confac=##class(web.DHCBillCommon).GetUomConvFactor(arcim, oeori)
		if (+dspbDR'=0) {
			set dspbData=$g(^DHCOEDISQTY(+dspbDR,"I",$p(dspbDR,"||",2)))
			if (dspbData'="") {
				set inci=$p(dspbData,"^",5)            //库存项指针
				set baseUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",10),1:"")     //库存项基本单位
				set outUomDR=$s((+inci'=0):$p(^INCI(inci,1),"^",12),1:"")      //门诊药品取门诊发药单位
				set dispUomDR=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",13)     //协议包装单位
				set uomDR=""
				if (dispUomDR'="") {
					set uomDR=dispUomDR
				}else {
					set uomDR=$s((outUomDR'=""):outUomDR,1:baseUomDR)
				}
				set confac=##class(PHA.FACE.OUT.Com).UOMFac(uomDR, baseUomDR)
				set packUom=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
			}
		}
		set packUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", packUom, langId)
		set reqQty=reqQty/confac
		set reqQty=$fn(reqQty,"N")
		do OutputIOASubInfo
	}
	
	quit
	
OutputIOASubInfo
	set Data=$lb(arcimDesc,packUom,reqQty,reqAmt,reqUserName,reqDate,reqTime,reqReason,reqFlag,auditUserName,auditDate,auditTime,prescNo,recDept,invSubId,oeori,ordCateType,phdicId,isCNMedItem,isOweDrug)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-11-15
/// Description: 审核
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefundRequest).RefundAudit("4632","228490||1^228490||2","5^122^303^2")
ClassMethod RefundAudit(invSubStr As %String, sessionStr As %String) As %String
{
 	set $zt="ERROR"
  	set ^TMP("RefundAudit")=$lb(invSubStr, sessionStr)
  	
  	set rtn=0
  	
  	set userId=$p(sessionStr,"^",1)
  	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set bCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set cfgAppFlag=$p(bCfgInfo,"^",15)    //(0:不用审核, 1:一级审核, 2:二级审核)
  	quit:(cfgAppFlag'=2) -1_"^"_"未配置需要审核，不需审核"
	
	set curDate=+$h
	set curTime=$p($h,",",2)
  	
	ts
	
  	for i=1:1:$l(invSubStr,"^") {
	  	set invSubId=$p(invSubStr,"^",i)
		continue:(invSubId="")
		set reqFlag=$p($g(^DHCINVPRT(+invSubId,"OA",$p(invSubId,"||",2))),"^",6)
		continue:(reqFlag="P")    //过滤已审核的
		&SQL(
			UPDATE DHC_INVOEItemAuthorize
			SET IOA_Flag = 'P', IOA_AuditUser = :userId, IOA_AuditDate = :curDate,
				IOA_AuditTime = :curTime
			WHERE %ID = :invSubId
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
  	if (+rtn) tro  quit rtn
  	
  	if ($tl>0)  tc
  	
  	quit +rtn_"^"_"审核成功"
  	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-11-15
/// Description: 撤销审核
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefundRequest).CancelAudit("228490||1^228490||2","5^122^303^2")
ClassMethod CancelAudit(invSubStr As %String, sessionStr As %String) As %String
{
 	set $zt="ERROR"
  	set ^TMP("CancelAudit")=$lb(invSubStr, sessionStr)
  	
	set rtn=0
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
  	set cCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set cfgAppFlag=$p(cCfgInfo,"^",15)    //(0:不用审核, 1:一级审核, 2:二级审核)
  	quit:(cfgAppFlag'=2) -1_"^"_"未配置需要审核，不需撤销"
  	
	ts
	
  	for i=1:1:$l(invSubStr,"^") {
	  	set invSubId=$p(invSubStr,"^",i)
		continue:(invSubId="")
		set reqFlag=$p($g(^DHCINVPRT(+invSubId,"OA",$p(invSubId,"||",2))),"^",6)
		continue:(reqFlag'="P")    //过滤未审核的
		&SQL(
			UPDATE DHC_INVOEItemAuthorize
			SET IOA_Flag = 'A', IOA_AuditUser = NULL, IOA_AuditDate = NULL,
				IOA_AuditTime = NULL
			WHERE %ID = :invSubId
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
  	if (+rtn) tro  quit rtn
	
  	if ($tl>0)  tc
  	
  	quit +rtn_"^"_"撤销成功"

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-11-19
/// Description: 
/// Table: DHC_INVOEItemAuthorize
/// Input: 
/// Return: PLIST
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetAuthPLIST()
ClassMethod GetAuthPLIST(ByRef PLIST)
{
  	set num=0
	set clsObj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCINVOEItemAuthorize", 0)
	quit:('$IsObject(clsObj)) 0
	for i=1:1:clsObj.Properties.Count() {
		set prop=clsObj.Properties.GetAt(i).Name
		if ($e(prop)'="%") {
			set PLIST($i(num))=""
		}
	}
	do clsObj.%Close()
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-11-17
/// Description: 获取门诊退费申请登录科室对照的医嘱接收科室
/// Input: hospId:CT_Hospital.RowId, ctLocId:CT_Loc.RowId
/// Return: 
/// Others: 通用配置->门诊收费系统->门诊退费申请->登录科室与医嘱接收科室对照
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetContraRecLocIdStr(2, 55)
ClassMethod GetContraRecLocIdStr(hospId As %String, ctLocId As %String) As %String
{
	set recLocIdStr=""
	quit:(ctLocId="") recLocIdStr
	
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	do rset.Execute("OPCHRG.OPDrOrdRefdAppy.DLKSYYZJSKSDZ", ctLocId, "", hospId)
	while (rset.Next()) {
		set id=rset.Get("ID")
		set recLocIdStr=$s((recLocIdStr=""):id,1:(recLocIdStr_"^"_id))
	}
	
	quit recLocIdStr
}

/// Creator: ZhYW
/// CreatDate: 2023-02-16
/// Description: 根据配置的金额判断发票是否需要退费申请
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: 0:否, 1:是
/// Others: 通用配置->门诊收费系统->门诊退费->需退费审核最大金额
/// Debug: w ##class(web.DHCOPBillRefundRequest).ChkRefAppByCfgAmt(2)
ClassMethod ChkRefAppByCfgAmt(prtRowId As %String) As %String
{
	quit:(+prtRowId=0) 0
	if ($d(%ChkRefAppByCfgAmt($this,prtRowId))) {
		quit %ChkRefAppByCfgAmt($this,prtRowId)
	}
	set prtData=$g(^DHCINVPRT(prtRowId))
	set prtAmout=$p(prtData,"^",1)
	set hospId=$p(prtData,"^",39)
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPRefd.XTFSHZDJE", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	set cfgAmt=$p(cfgData,"^",1)
	set rtn=((+cfgAmt'=0)&&(+cfgAmt<+prtAmout))
	set %ChkRefAppByCfgAmt($this,prtRowId)=rtn
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-02-16
/// Description: 根据发票的结算费别判断是否需要退费审核
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: 0:否, 1:是
/// Others: 通用配置->门诊收费系统->门诊退费审核->不需要退费审核的结算费别配置
/// Debug: w ##class(web.DHCOPBillRefundRequest).ChkRefAppByChrgInsType(10256)
ClassMethod ChkRefAppByChrgInsType(prtRowId As %String) As %String
{
	quit:(+prtRowId=0) 0
	if ($d(%ChkRefAppByChrgInsType($this,prtRowId))) {
		quit %ChkRefAppByChrgInsType($this,prtRowId)
	}
	set prtData=$g(^DHCINVPRT(prtRowId))
	set insTypeId=$p(prtData,"^",9)
	set hospId=$p(prtData,"^",39)
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPDrOrdRefdChk.BXYTFSHDJSFBPZ", "", insTypeId, hospId)
	set rtn=##class(%DynamicObject).%FromJSON(jsonStr).success   //0:拒绝，1:通过
	set %ChkRefAppByChrgInsType($this,prtRowId)=rtn
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-03-22
/// Description: 根据发票的结算时间判断是否需要退费审核
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: 0:否, 1:是
/// Others: 通用配置->门诊收费系统->门诊退费审核->需要审核的间隔天数
/// Debug: w ##class(web.DHCOPBillRefundRequest).ChkRefAppByChrgPrtTime(10256)
ClassMethod ChkRefAppByChrgPrtTime(prtRowId As %String) As %String
{
	quit:(+prtRowId=0) 0
	if ($d(%ChkRefAppByChrgPrtTime($this,prtRowId))) {
		quit %ChkRefAppByChrgPrtTime($this,prtRowId)
	}
	set prtData=$g(^DHCINVPRT(prtRowId))
	set prtDate=$p(prtData,"^",5)
	set prtTime=$p(prtData,"^",20)
	set hospId=$p(prtData,"^",39)
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPDrOrdRefdChk.XYSHDJGTS", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).value
	set rtn=(+cfgData'=0)&&($SYSTEM.SQL.DATEDIFF("ss", prtDate_","_prtTime, $h)>(cfgData*24*3600))
	set %ChkRefAppByChrgPrtTime($this,prtRowId)=rtn
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-04-12
/// Description: 取未执行医嘱是否需要审核配置
/// Input: hospId:CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->门诊收费系统->门诊退费审核->未执行医嘱是否需要审核
/// Debug: w ##class(web.DHCOPBillRefundRequest).GetUnExecAuditCfg(2)
ClassMethod GetUnExecAuditCfg(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPDrOrdRefdChk.WZHYZSFXYSH", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

}
