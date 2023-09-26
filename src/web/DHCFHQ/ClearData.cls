/// 清除数据
Class web.DHCFHQ.ClearData Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 清除药品信息
ClassMethod DRUGINFO(ChangeType As %String)
{
	s RetStr=""
	if ChangeType="Clear" d
	.s RetStr="暂时不用"
	if ChangeType="Show"  d
	.s RetStr="暂时不用"
	q RetStr
}

/// 发票业务
ClassMethod INVOICE(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.;dhc_sfbuy,dhc_sfgrant,dhc_sfreceipt
	.k ^DHCSFBUY,^DHCSFGRANT,^DHCSFRECEIPT
	.;dhc_amtmag,dhc_amtdel,dhc_invoice
	.K ^DHCAMTMAG,^DHCDEL,^DHCINVOICE
	
	s RetStr1=";dhc_sfbuy,dhc_sfgrant,dhc_sfreceipt"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^DHCSFBUY,^DHCSFGRANT,^DHCSFRECEIPT"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1=";dhc_amtmag,dhc_amtdel,dhc_invoice"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="K ^DHCAMTMAG,^DHCDEL,^DHCINVOICE"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// ;医嘱清数据:
ClassMethod ORDINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.;清医嘱,在Kill整个^OEORD,^OEORI清除不了的情况下执行
	.k ^OEORDi,^OEORDi(0)
	.s ord=0
	.for  s ord=$O(^OEORD(ord)) Q:ord=""  d
	..kill ^OEORD(ord)
	.;新药品打包表
    .k ^DHCOEDISQTY
  
    s RetStr="k ^OEORDi,^OEORDi(0),^DHCOEDISQTY"
    ;收费的业务
   	s RetStr1=##class(web.DHCFHQ.ClearData).CASHIER(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// 挂号及预约记录
ClassMethod APPOINT(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^User.DHCQueueD,^User.DHCQueueI,^User.DHCOPPatInfoD,^User.DHCOPPatInfoI,^User.DHCRegistrationFeeD,^User.DHCRegistrationFeeI,^User.DHCBeforeRegD,^User.DHCBeforeRegI
    s RetStr="k ^User.DHCQueueD,^User.DHCQueueI,^User.DHCOPPatInfoD,^User.DHCOPPatInfoI,^User.DHCRegistrationFeeD,^User.DHCRegistrationFeeI,^User.DHCBeforeRegD,^User.DHCBeforeRegI"
    Q RetStr
}

/// 排班记录
ClassMethod SHEDULE(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.kill ^RBAS
    s RetStr="k ^RBAS"
    q RetStr
}

/// 收费业务
ClassMethod CASHIER(ChangeType)
{
	s RetStr=""
	s RetStr1=##class(web.DHCFHQ.ClearData).OUTPCASHIER(ChangeType)
    s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
   	s RetStr1=##class(web.DHCFHQ.ClearData).INPCASHIER(ChangeType)
   	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
   	;帐单表
   	IF ChangeType="Clear" d
    .k ^DHCPB,^DHCPBi,^DHCPBi(0)
	.s pbid=0
	.for  s pbid=$O(^DHCPB(pbid)) Q:pbid=""  d
	..kill ^DHCPB(pbid)
   	.;AR_RECEIPTS,AR_RCPTALLOC,AR_RCPTPAYMODE
	.K ^ARRCP
	s RetStr1="k ^DHCPB,^DHCPBi,^DHCPBi(0),^ARRCP"
   	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// 门诊收费业务
ClassMethod OUTPCASHIER(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.;dhc_invprt(^DHCINVPRT),DHC_INVOEItemAuthorize(^DHCINVPRT),DHC_BillConINV
	.k ^DHCINVPRT,^DHCBCI
	.;DHC_INVPRTReports及子表
	.k ^DHCOPInsFoot,^DHCOPInsFootI
	.;DHC_AccPreDeposit,DHC_AccPrePayMode
	.k ^DHCACDi,^DHCACD
	.;dhc_accpayinv,dhc_accpayinvpaymode,DHC_AccPINVCONPRT,DHC_AccQueryFoot,DHC_AccQueryFootSub
	.k ^DHCINVPRTAP,^DHCINVPRTAPi,^DHCINVPRTCAP,^DHCINVPRTCAPi,^DHCACDTMPQUERY,^DHCACDTMPQUERYi
	.s RetStr="Ok"
	if ChangeType="Show"  d
	.s RetStr=";dhc_invprt(^DHCINVPRT),DHC_INVOEItemAuthorize(^DHCINVPRT),DHC_BillConINV"
	.s RetStr=RetStr_"@"_"k ^DHCINVPRT,^DHCBCI"
	.s RetStr=RetStr_"@"_";DHC_INVPRTReports及子表"
	.s RetStr=RetStr_"@"_"k ^DHCOPInsFoot,^DHCOPInsFootI"
	.s RetStr=RetStr_"@"_";DHC_AccPreDeposit,DHC_AccPrePayMode"
	.s RetStr=RetStr_"@"_"k ^DHCACDi,^DHCACD"
	.s RetStr=RetStr_"@"_";dhc_accpayinv,dhc_accpayinvpaymode,DHC_AccPINVCONPRT,DHC_AccQueryFoot,DHC_AccQueryFootSub"
	.s RetStr=RetStr_"@"_"k ^DHCINVPRTAP,^DHCINVPRTAPi,^DHCINVPRTCAP,^DHCINVPRTCAPi,^DHCACDTMPQUERY,^DHCACDTMPQUERYi"
	q RetStr
}

/// 住院收费业务
ClassMethod INPCASHIER(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.;DHC_INVPRTZY ;
	.k ^DHCINVPRTZY
	.;DHC_SFPRINTDETAIL
	.K ^DHCSFPRINTDETAIL
	.;dhc_sfbuy,dhc_sfgrant,dhc_sfreceipt
	.k ^DHCSFBUY,^DHCSFGRANT,^DHCSFRECEIPT
	.;DHC_AdmTotalAmt
	.k ^DHCATA
	if ChangeType="Show"  d
	.s RetStr=""
	s RetStr="k ^DHCINVPRTZY,^DHCSFPRINTDETAIL,^DHCSFBUY,^DHCSFGRANT,^DHCSFRECEIPT,^DHCATA"
	q RetStr
}

/// 病人信息
ClassMethod PATINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^DHCCARDi,^DHCCARD,^PAPERi,^PAPER
	if ChangeType="Show"  d
	.s RetStr="k ^DHCCARDi,^DHCCARD,^PAPERi,^PAPER"
	s RetStr="k ^DHCCARDi,^DHCCARD,^PAPERi,^PAPER"
	q RetStr
}

/// 按科室清除库存
ClassMethod STOCKLOC(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.s RetStr=""
	if ChangeType="Show"  d
	.s RetStr=""
	s RetStr="暂无提供清除的程序"
	q RetStr
}

/// 库存管理业务
ClassMethod STOCTRANS(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^INPP									;IN_PurPlan,IN_PurPlanItm
 	.K ^DHCPA									;DHC_PlanAudit
 	.K ^DHCPPTR									;DHC_PlanPoTar
 	.k ^DHCPPI									;DHC_PlanPoItmTar
 	.k ^INPO									;IN_PO,IN_POItm 订单
 	.K ^DHCINGR									;DHC_INGdRec,DHC_INGdRecItm
 	.K ^INGRT									;DHC_INGDRET,DHC_INGRTITM	
 	.k ^INRQ									;IN_Request,IN_ReqItm
 	.k ^DHCINIT									;DHC_InIsTrf,DHC_InIsTrfItm
 	.K ^DHCINAD									;DHC_INAdj,DHC_INAdjItm
 	.K ^DHCCSR									;DHC_INCSR,DHC_INCSRItems
 	.K ^DCSRLB									;DHC_INCSRINCLB
 	.K ^DHCINMAN								;DHC_InManuOrder,DHC_InManuOrder_Batch
 	.K ^DHCINST									;DHC_InStkTk,DHC_InStkTkItm,DHC_InStkTkGrp,DHC_InStkTkItmWd
 	.K ^DHCSM									;DHC_StkMon,DHC_StkMonReport
 	.k ^SMSTATI									;DHC_StkMonStatIn									
 	.K ^SMSTAT									;DHC_StkMonStat
 	.K ^DHCSTKYEAR								;DHC_StkYear
 	.K ^DHCSTKYEARREP							;Dhc_StkYearReport
 	.K ^STADDION								;DHC_STKYEARADDION 
 	.k ^DHCPAY									;DHC_Pay,DHC_PayItm,DHC_PayMon 
 	.k ^ASPA									//DHC_ASPAmount,DHC_ASPAmountLB调价损益记录
 	.k ^DHCRETA									//业务损益表
 	.k ^DHCHI									//DHC_HHImport
 	.K ^mdata("DHCINISTRF") 			;DHC_InIsTrf,DHC_InIsTrfItm
 	.K ^mdata("INPURPLAN")				;IN_PurPlan,IN_PurPlanItm
 	.K ^mdata("DHCINGDREC")				;DHC_INGdRec,DHC_INGdRecItm
 	.K ^mdata("DHCINADJ")				;DHC_INAdj,DHC_INAdjItm
 	.k ^mdata("DHCSTKMON")				;DHC_StkMon,DHC_StkMonReport
 	.k ^mdata("DHCSTKMONSTAT")			;DHC_StkMonStat
 	.k ^mdata("DHCSTKYEAR")				;DHC_StkYear
 	.k ^mdata("DHCINSTKTK")				;DHC_InStkTk
 	.k ^mdata("DHCPAY")					;DHC_Pay
 	.k ^mdata("DHCPAYMON")				;DHC_PayMon
	s RetStr1="k ^INPP,^DHCPA,^DHCPPTR,^DHCPPI,^INPO,^DHCINGR	"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="K ^INGRT,^INRQ,^DHCINIT,^DHCINAD,^DHCCS,^DCSRLB,^DHCINMAN,^DHCINST"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="K ^DHCSM,^SMSTATI,^SMSTAT,^DHCSTKYEAR,^DHCSTKYEARREP,^STADDION"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^DHCPAY,^ASPA,^DHCRETA,^DHCHI"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// 药房业务
ClassMethod STOCKINFO(ChangeType)
{
	s RetStr=""
	s RetStr1=##class(web.DHCFHQ.ClearData).OUTPSTOCKINFO(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1=##class(web.DHCFHQ.ClearData).INPSTOCKINFO(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// 门诊药房业务
ClassMethod OUTPSTOCKINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^DHCPHDISP								;DHC_PHDISPEN
 	.k ^DHCPHDISPi								;DHC_PHDISPEN
 	.k ^DHCPHDI									;DHC_PHDISITEM,DHC_PHDISITMCLB
 	.k ^DHCPHRTI								;DHC_PHRETITM
 	.k ^DHCPHRTIi								;DHC_PHRETITM
 	.k ^DHCPHRETi								;DHC_PHRETURN
 	.k ^DHCPHRET								;DHC_PHRETURN
	.k ^DHCPHARi,^DHCPHARWi,^DHCPHARW			;DHC_PHARWIN
	.k ^DHCPHUNDi,^DHCPHUND						;DHC_PHUNDISPEN,DHC_PHUNDISPITM
 	.k ^DHCPHSERIAL,^DHCPHSERIALi				;DHC_PHSERIAL
 	.k ^DHCPHDR,^DHCPHDRi						;DHC_PHDREPRINT
 	.k ^DHCPHCW									;DHC_PHCURRWIN	
 	.k ^DHCPHRTCi,^DHCPHRTC						;DHC_PHRTCODE
 	.k ^DHCPHDAILYi,^DHCPHDAIL					;DHC_PHDAILY
 	.k ^DHCPHMON								;DHC_PHMONTH
 	.k ^DHCPHMONDEF								;DHC_PHMONDEF
 	.k ^PHPATCODE								;DHCPHPATIENCODE
 	.k ^DHCPHINPi,^DHCPHINP						;DHC_PHINPERSON
 	.k ^DHCPHUNRi,^DHCPHUNR						;DHC_PHUNRETURN,DHC_PHUNRETITM
 	.k ^DHCPHUPi,^DHCPHUP						;DHCPhUpdate
 	.k ^DHCPHNLi,^DHCPHNL						;DHC_PHNOLCD
 	.k ^DHCPHREQC								;DHC_PHREQCODE
 	.k ^DHCPHREQ,^DHCPHREQi						;DHC_PHREQITEM,DHC_PHREQUEST
 	.k ^DHCPHCALL,^DHCPHCALLi					;DHC_PHCALL
 	.k ^DHCPHEXECi,^DHCPHEXEC					;DHC_PhExeCute 
 	.K ^DHCPHLCD								;DHC_PHLCD
 	.K ^DHCPHLDCi,^DHCPHLDC						;DHC_PHLCDCODE
 	.k ^PHSKi,^PHSK								;DHC_PHSKSCREEN
 	.k ^DHCPHSM,^DHCPHSMi						//DHC_PhSendMsg
 	.k ^PHDI,^PHDISi 							;DHC_PHDISITEM 原版本
 	.k ^PHRET,^PHRETi 							;DHC_PHRETURN	原版本
 	.///
 	.k ^mdata("DHCPHDISPEN")				;DHC_PHDISPEN
 	.k ^mdata("DHCPHRETURN")				;DHC_PHRETURN
 	.k ^mdata("DHCPHARWIN")					;DHC_PHARWIN
 	.k ^mdata("DHCPHUNDISPEN")				;DHC_PHUNDISPEN
	.k ^mdata("DHCPHSERIAL")				;DHC_PHSERIAL
 	.k ^mdata("DHCPHDREPRINT")				;DHC_PHDREPRINT
 	.k ^mdata("DHCPHCURRWIN")				;DHC_PHCURRWIN
 	.k ^mdata("DHCPHRTCODE")				;DHC_PHRTCODE
 	.k ^mdata("DHCPHDAILY")					;DHC_PHDAILY
 	.k ^mdata("DHCPHMONTH")					;DHC_PHMONTH
 	.k ^mdata("DHCPHMONDEF")				;DHC_PHMONDEF
 	.k ^mdata("DHCPHPATIENCODE")			;DHCPHPATIENCODE
 	.k ^mdata("DHCPHINPERSON")				;DHC_PHINPERSON
 	.k ^mdata("DHCPHUNRETURN")				;DHC_PHUNRETURN
 	.k ^mdata("DHCPHUPDATE")				;DHCPhUpdate
 	.k ^mdata("DHCPHNOLCD")					;DHC_PHNOLCD
 	.k ^mdata("DHCPHREQCODE")				;DHC_PHREQCODE
 	.k ^mdata("DHCPHREQUEST")				;DHC_PHREQUEST
 	.k ^mdata("DHCPHCALL")					;DHC_PHCALL
 	.k ^mdata("DHCPHEXECUTE")				;DHC_PhExeCute
 	.K ^mdata("DHCPHLCD")					;DHC_PHLCD
 	.K ^mdata("DHCPHLCDCODE")				;DHC_PHLCDCODE
 	.k ^mdata("DHCPHSKSCREEN")				;DHC_PHSKSCREEN
	s RetStr1="k ^DHCPHDISP,^DHCPHDISPi,^DHCPHDI,^DHCPHRTI,^DHCPHRTIi,^DHCPHRETi,^DHCPHRET"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^DHCPHARi,^DHCPHARWi,^DHCPHARW,^DHCPHUNDi,^DHCPHUND,^DHCPHSERIAL,^DHCPHSERIALi"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^DHCPHDR,^DHCPHDRi,^DHCPHCW,^DHCPHRTCi,^DHCPHRTC,^DHCPHDAILYi,^DHCPHDAIL"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^DHCPHMON,^DHCPHMONDEF,^PHPATCODE,^DHCPHINPi,^DHCPHINP,^DHCPHUNRi,^DHCPHUNR"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^DHCPHUPi,^DHCPHUP,^DHCPHNLi,^DHCPHNL,^DHCPHREQC,^DHCPHREQ,^DHCPHREQi"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^DHCPHCALL,^DHCPHCALLi,^DHCPHEXECi,^DHCPHEXEC,^DHCPHLCD,^DHCPHLDCi,^DHCPHLDC"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	s RetStr1="k ^PHSKi,^PHSK,^DHCPHSM,^DHCPHSMi,^PHDI,^PHDISi,^PHRET,^PHRETi"
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// 住院药房业务
ClassMethod INPSTOCKINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.K ^DHCPHAC									;DHC_PHACollected,DHC_PHACollectItm
 	.K ^DHCPCOD									;DHC_PhaCollectOutDrug,DHC_PhaCollectOutDrugDet
 	.K ^RETRQ									;DHC_PhaRetRequest
 	.K ^PHARET									;DHC_PhaReturn
 	.K ^DHCPRES									;DHC_PhaReserve
 	.K ^DHCSTOUTDRUGCHECK						;DHC_STOutDrugCheck						
 	.k ^STDF									;DHC_STDRUGREFUSE
 	.K ^DHCDISPREQ								;DHC_DispRequested
 	.k ^DHCPCB									//DHC_PhaCallback
 	.//
 	.k ^mdata("DHCPHACOLLECTED")			;DHC_PHACollected
 	.K ^mdata("DHCPHACOLLECTOUTDRUG")		;DHC_PhaCollectOutDrug
 	.k ^mdata("DHCPHARETREQUEST")			;DHC_PhaRetRequest
 	.k ^mdata("DHCPHARETURN")				;DHC_PhaReturn
 	.k ^mdata("DHCPHARESERVE")				;DHC_PhaReserve
 	.K ^mdata("DHCSTOUTDRUGCHECK")			;DHC_STOutDrugCheck
 	.k ^mdata("DHCSTDRUGREFUSE")			;DHC_STDRUGREFUSE
 	.k ^mdata("DHCDISPREQUESTED")			;DHC_DispRequested
 	.k ^mdata("DHCPHACALLBACK")				//DHC_PhaCallback
	s RetStr1="K ^DHCPHAC,^DHCPCOD,^RETRQ,^PHARET,^DHCPRES,^DHCSTOUTDRUGCHECK,^STDF,^DHCDISPREQ,^DHCPCB"	
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// RIS业务
ClassMethod RISINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.s RetStr=""
	if ChangeType="Show"  d
	.s RetStr=""
	s RetStr="暂无提供清除的程序"
	q RetStr
}

/// 病理业务
ClassMethod PISINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^DHCPISArchiveRecord,^DHCPISArchiveRecordi
	.k ^DHCPISCancelLog,^DHCPISCancelLogi
	.k ^DHCPISConsultMaster,^DHCPISConsultMasteri
	.k ^DHCPISCuttingRecord,^DHCPISCuttingRecordi
	.k ^DHCPISDiagRecord,^DHCPISDiagRecordi
	.k ^DHCPISDiagnosisOwner,iDHCPISDiagnosisOwner
	.k ^DHCPISImageIndex,^DHCPISImageIndexi
	.k ^DHCPISInvalidPS,^DHCPISInvalidPSi
	.k ^DHCPISLBRecord,^DHCPISLBRecordi
	.k ^DHCPISLocMessage,^DHCPISLocMessagei
	.k ^DHCPISLock,^DHCPISLocki
	.k ^DHCPISModifyLog,^DHCPISModifyLogi
	.k ^DHCPISPieceVerify,^DHCPISPieceVerifyi
	.k ^DHCPISReport,^DHCPISReporti
	.k ^DHCPISRptAddition,^DHCPISRptAdditioni
	.k ^DHCPISRptImage,^DHCPISRptImagei
	.k ^DHCPISSliceRecord,^DHCPISSliceRecordi
	.k ^DHCPISSpecialRecord,^DHCPISSpecialRecordi
	.k ^DHCPISSubStatusR,^DHCPISSubStatusRi
	.k ^DHCPISTestMaster,^DHCPISTestMasteri

	s RetStr=RetStr_"@"_"k ^DHCPISArchiveRecord,^DHCPISArchiveRecordi"
	s RetStr=RetStr_"@"_"k ^DHCPISCancelLog,^DHCPISCancelLogi"
	s RetStr=RetStr_"@"_"k ^DHCPISConsultMaster,^DHCPISConsultMasteri"
	s RetStr=RetStr_"@"_"k ^DHCPISCuttingRecord,^DHCPISCuttingRecordi"
	s RetStr=RetStr_"@"_"k ^DHCPISDiagRecord,^DHCPISDiagRecordi"
	s RetStr=RetStr_"@"_"k ^DHCPISDiagnosisOwner,iDHCPISDiagnosisOwner"
	s RetStr=RetStr_"@"_"k ^DHCPISImageIndex,^DHCPISImageIndexi"
	s RetStr=RetStr_"@"_"k ^DHCPISInvalidPS,^DHCPISInvalidPSi"
	s RetStr=RetStr_"@"_"k ^DHCPISLBRecord,^DHCPISLBRecordi"
	s RetStr=RetStr_"@"_"k ^DHCPISLocMessage,^DHCPISLocMessagei"
	s RetStr=RetStr_"@"_"k ^DHCPISLock,^DHCPISLocki"
	s RetStr=RetStr_"@"_"k ^DHCPISModifyLog,^DHCPISModifyLogi"
	s RetStr=RetStr_"@"_"k ^DHCPISPieceVerify,^DHCPISPieceVerifyi"
	s RetStr=RetStr_"@"_"k ^DHCPISReport,^DHCPISReporti"
	s RetStr=RetStr_"@"_"k ^DHCPISRptAddition,^DHCPISRptAdditioni"
	s RetStr=RetStr_"@"_"k ^DHCPISRptImage,^DHCPISRptImagei"
	s RetStr=RetStr_"@"_"k ^DHCPISSliceRecord,^DHCPISSliceRecordi"
	s RetStr=RetStr_"@"_"k ^DHCPISSpecialRecord,^DHCPISSpecialRecordi"
	s RetStr=RetStr_"@"_"k ^DHCPISSubStatusR,^DHCPISSubStatusRi"
	s RetStr=RetStr_"@"_"k ^DHCPISTestMaster,^DHCPISTestMasteri"
	q RetStr
}

/// 体验业务
ClassMethod TJINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.s RetStr=""
	if ChangeType="Show"  d
	.s RetStr=""
	s RetStr="暂无提供清除的程序"
	q RetStr
}

/// 心电业务
ClassMethod XDINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.s RetStr=""
	if ChangeType="Show"  d
	.s RetStr=""
	s RetStr="暂无提供清除的程序"
	q RetStr
}

/// 检验业务
ClassMethod LABINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^TDHCOldResult,^DHCSecondLabNo,^DHCTestSetDetails
 	.k ^DHCMachResLog,^DHCPrintRowidList,^DHCLabResult,^DHCSecondLabNo,^DHCItemAlias
 	.k ^DHCRSi,^DHCRS,^DHCResultLog,^DHCHISTestSet,^DHCHISTestSeti,DHCMachineEpisList,^DHCSndLabNo
 	.k ^DHCTSTrans,^DHCTSTransi,^DHCTSExtra
 	.k ^Dhcbbpackprice
 	.; 20111027
 	.k ^DHCBBDayStock,^DHCIQC,^DHCIQCi,^DHCHISTSDTi,^DHCPreReporti,^DHCPreReport,^DHCUserLog,^DHCTSTransMicFlag
 	.k ^DHCPackPrint,^DHCBBSupplierUnitPrice,^DHCResTrace,^DHCSpecimenPlace,^DHCblood,^DHCVisitTSBBPacksInfo
 	.k ^DHCMachEpis,^DHCMachineEpisList,^DHCUserRecSpecimen
 	.k ^DHCQCMonPara,^DHCSpecimenNote,^DHCBARCODEDELETE
 	.;
 	.k ^BB,^BBANT,^BBAR,^DBLock,^ERRORS
 	.k ^TAGE,^TAGEi,^TADN,^TTDQ
 	.k ^TBAL,^TBAT,^TBATi,^TBBC,^TBBP,^TBBPi,^TBDL,^TBIL
 	.k ^TCCR
 	.k ^TDAY,^TDEB,^TDEBi,^TDEBj
 	.k ^TEDI,^TEPI,^TEPIi
 	.k ^THIN,^THIR,^THIRi
 	.k ^TIND
 	.k ^TJOU
	.k ^TMCB,^TMCBi,^TMOVE
 	.k ^TOLDi,^TOLD
 	.k ^TPIT,^TPPL
 	.k ^TRCT,^TRBL,^TRPT,^TRPTi
 	.k ^TSUM
 	.k ^TTRQ,^TTRQi
 	.;k ^TTQC,^TTQCi
 	.k ^TTLT
 	.s lab="" f  s lab=$o(^TTAB("LA",lab)) q:lab=""  d
 	..s $p(^TTAB("LA",lab),"\",6)=""
 	..s site="" f  s site=$o(^TTAB("LA",lab,"SITE",site)) q:site=""  d
 	...s $p(^TTAB("LA",lab,"SITE",site),"\",2)=""
 	.s hos="" f  s hos=$o(^THOS(hos)) q:hos=""  f ind="PATIENT","PATIENT-INDEX","Date" k ^THOS(hos,ind)
 	.s mi="" f  s mi=$o(^TMIF(mi)) q:mi=""  f ind=1,9,94,95,98,99,10,15,16,17,20,"LL","LL1","LL2","QC" k ^TMIF(mi,ind)
 	.s wk="" f  s wk=$o(^TWKS(wk)) q:wk=""  f ind=2,3,4,5,"POOL" k ^TWKS(wk,ind)
 	.s x="" f  s x=$o(^AUDIT(x)) q:x=""  s xx=^(x) k ^AUDIT(x) s ^AUDIT(x)=xx
 	.k ^TMPmif,^TMPage,^TMPfis,^TMPerror,^TMPlog,^TERROR,^PR,^PRi
 	.k ^DHCMachinePara
 	.f j="DEB-CNT","DONOR-CNT","DR-SEQ","EPIS-CNT","HOSP-OUT","HOSP-SEQ","JOB-CNT","JOU-CNT" k ^CF(j) s ^CF(j)=0
 	.k ^TTAB("TS"),^TTAB("TC"),^TTAB("SY"),^TTQC,^TTQCi,^TTABi("TS")
 	.k ^TTAB("SPEC"),^TTABi("SPEC"),^TTAB("CON")
 	.k ^TTAB("GR"),^TTAB("SY"),^TTABi("DEP-TS")
 	.k ^TTAB("DEP"),^TTABi("DEP")
 	.s mi="" f  s mi=$o(^TMIF(mi)) q:mi=""  d
 	..s x1=^(mi),x2=$g(^TMIF(mi,"TCP"))
 	..k ^TMIF(mi)
 	..s ^TMIF(mi)=x1,^TMIF(mi,"TCP")=x2
 	.s wk="" f  s wk=$o(^TTAB("WS",wk)) q:wk=""  k ^TTAB("WS",wk,0)
 

	s RetStr=RetStr_"@"_"k ^TDHCOldResult,^DHCSecondLabNo,^DHCTestSetDetails"
 	s RetStr=RetStr_"@"_"k ^DHCMachResLog,^DHCPrintRowidList,^DHCLabResult,^DHCSecondLabNo,^DHCItemAlias"
 	s RetStr=RetStr_"@"_"k ^DHCRSi,^DHCRS,^DHCResultLog,^DHCHISTestSet,^DHCHISTestSeti,DHCMachineEpisList,^DHCSndLabNo"
 	s RetStr=RetStr_"@"_"k ^DHCTSTrans,^DHCTSTransi,^DHCTSExtra"
 	s RetStr=RetStr_"@"_"k ^Dhcbbpackprice"
 	; 20111027
 	s RetStr=RetStr_"@"_"k ^DHCBBDayStock,^DHCIQC,^DHCIQCi,^DHCHISTSDTi,^DHCPreReporti,^DHCPreReport,^DHCUserLog,^DHCTSTransMicFlag"
 	s RetStr=RetStr_"@"_"k ^DHCPackPrint,^DHCBBSupplierUnitPrice,^DHCResTrace,^DHCSpecimenPlace,^DHCblood,^DHCVisitTSBBPacksInfo"
 	s RetStr=RetStr_"@"_"k ^DHCMachEpis,^DHCMachineEpisList,^DHCUserRecSpecimen"
 	s RetStr=RetStr_"@"_"k ^DHCQCMonPara,^DHCSpecimenNote,^DHCBARCODEDELETE"
 	
 	s RetStr=RetStr_"@"_"k ^BB,^BBANT,^BBAR,^DBLock,^ERRORS"
 	s RetStr=RetStr_"@"_"k ^TAGE,^TAGEi,^TADN,^TTDQ"
 	s RetStr=RetStr_"@"_"k ^TBAL,^TBAT,^TBATi,^TBBC,^TBBP,^TBBPi,^TBDL,^TBIL"
 	s RetStr=RetStr_"@"_"k ^TCCR"
 	s RetStr=RetStr_"@"_"k ^TDAY,^TDEB,^TDEBi,^TDEBj"
 	s RetStr=RetStr_"@"_"k ^TEDI,^TEPI,^TEPIi"
 	s RetStr=RetStr_"@"_"k ^THIN,^THIR,^THIRi"
 	s RetStr=RetStr_"@"_"k ^TIND,^TJOU,^TMCB,^TMCBi,^TMOVE,^TOLDi,^TOLD,^TPIT,^TPPL"
 	s RetStr=RetStr_"@"_"k ^TRCT,^TRBL,^TRPT,^TRPTi,^TSUM,^TTRQ,^TTRQi"
 	s RetStr=RetStr_"@"_"k ^TTLT,^TMPmif,^TMPage,^TMPfis,^TMPerror,^TMPlog,^TERROR,^PR,^PRi"
 	s RetStr=RetStr_"@"_"k ^DHCMachinePara"
 	s RetStr=RetStr_"@"_"k ^TTAB(""""TS""""),^TTAB(""""TC""""),^TTAB(""""SY""""),^TTQC,^TTQCi,^TTABi(""""TS"""")"
 	s RetStr=RetStr_"@"_"k ^TTAB(""""SPEC""""),^TTABi(""""SPEC""""),^TTAB(""""CON"""")"
 	s RetStr=RetStr_"@"_"k ^TTAB(""""GR""""),^TTAB(""""SY""""),^TTABi(""""DEP-TS"""")"
 	s RetStr=RetStr_"@"_"k ^TTAB(""""DEP""""),^TTABi(""""DEP"""")"
 	q RetStr
}

/// 电子病历业务
ClassMethod EPRINFO(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.s RetStr=""
	if ChangeType="Show"  d
	.s RetStr=""
	s RetStr="暂无提供清除的程序"
	q RetStr
}

/// 医保业务
ClassMethod INSU(ChangeType)
{
	s RetStr=" "
	if ChangeType="Clear" d
	.k ^DHCINADM //INSUAdmInfo            医保登记信息 
	.k ^DHCINDIV //INSU_Divide            医保结算信息
	.k ^DHCINDIVPre //INSU_DividePre         医保预结算信息 
	.k ^DHCINDIS   //INSU_DivideSub         医保上传明细
	.k ^INSURPT //INSU_Report            医保上报信息
	.k ^DHCINDISIC //INSUDivideSubInsuCat   医保本地算法信息
	.s RetStr="Ok"
	if ChangeType="Show"  d
	.s RetStr=":^DHCINDIV INSU_Divide 医保结算信息"
	.s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,"^DHCINADM INSUAdmInfo  医保登记信息")
	.s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,"^DHCINDIV INSU_Divide 医保结算信息")
	.s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,"^DHCINDIVPre INSU_DividePre 医保预结算信息")
	.s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,"^DHCINDIS INSU_DivideSub 医保上传明细")
	.s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,"^INSURPT INSU_Report 医保上报信息")
	.s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,"^DHCINDISIC INSUDivideSubInsuCat 医保本地算法信息")
	q RetStr
}

/// 医政业务
ClassMethod DHCMED(ChangeType)
{
	
	s RetStr="包含:传染病,死亡管理,垃圾业务,医院感染业务,临床路径"
	//传染病
	s RetStr1=##class(web.DHCFHQ.ClearData).DHCMEDINFECT(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	//死亡管理
	s RetStr1=##class(web.DHCFHQ.ClearData).DHCMEDDIE(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	//垃圾业务
	s RetStr1=##class(web.DHCFHQ.ClearData).DHCRUBBISH(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	///医院感染业务
	s RetStr1=##class(web.DHCFHQ.ClearData).DHCINFECT(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)	
	//临床路径
	s RetStr1=##class(web.DHCFHQ.ClearData).CLINICPATH(ChangeType)
	s RetStr=##class(web.DHCFHQ.DHCFCommon).RetValue(RetStr,RetStr1)
	q RetStr
}

/// 传染病业务
ClassMethod DHCMEDINFECT(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.kill ^DHCMEPD	//传染病报告		  DHC_MedEpidemic DHC_MedEpidemicSub
	.kill ^DHCMEPA	//传染病监测评价记录  DHC_MedEpidApp DHC_MedEpidAppSub
	.kill ^DHCMAC	//传染病附卡		  DHC_MedAppendixCard	DHC_MedAppendixCardItem
	.//以下为BS程序用
	.kill ^DHCMed.EPD
	.kill ^DHCMed.EPDi
	.s RetStr="Ok"
	if ChangeType="Show"  d
	.s RetStr="kill ^DHCMEPD	//传染病报告		  DHC_MedEpidemic DHC_MedEpidemicSub"
	.s RetStr=RetStr_"@"_"kill ^DHCMEPA	//传染病监测评价记录  DHC_MedEpidApp DHC_MedEpidAppSub"
	.s RetStr=RetStr_"@"_"kill ^DHCMAC	//传染病附卡		  DHC_MedAppendixCard	DHC_MedAppendixCardItem"
	.s RetStr=RetStr_"@"_"以下为BS程序用@kill ^DHCMed.EPD@kill ^DHCMed.EPDi"
	q RetStr
}

/// 死亡管理数据
ClassMethod DHCMEDDIE(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.kill ^DHCMDR	//死亡报告单		DHC_MedDeathRep
	.kill ^DHCMDB	//死亡证明入库		DHC_MedDeathBook DHC_MedDeathBSub
	.kill ^DHCMDBD	//死亡证明发放明细	DHC_MedDeathBDetail DHC_MedDBDSub
	.kill ^DHCMed.DM.MainReportD           ;死亡报告相关数据
   	.kill ^DHCMed.DM.MainReportI           ;死亡报告相关索引
   	.kill ^DHCMed.DM.ReportNoD             ;死亡证明书编号相关数据
   	.kill ^DHCMed.DM.ReportNoI             ;死亡证明书编号相关索引
	.s RetStr="Ok"
	if ChangeType="Show"  d
	.s RetStr="kill ^DHCMDR	//死亡报告单		DHC_MedDeathRep"
	.s RetStr=RetStr_"@"_"kill ^DHCMDB	//死亡证明入库		DHC_MedDeathBook DHC_MedDeathBSub"
	.s RetStr=RetStr_"@"_"kill ^DHCMDBD	//死亡证明发放明细	DHC_MedDeathBDetail DHC_MedDBDSub"
	q RetStr
}

/// 垃圾业务
ClassMethod DHCRUBBISH(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.kill ^DHCMRB	//垃圾登记表		DHC_MedRubRep DHC_MedRubRepSub
	.kill ^DHCMRO	//垃圾外运		DHC_MedRubbishOut
	.s RetStr="Ok"
	if ChangeType="Show"  d
	.s RetStr="kill ^DHCMRB	//垃圾登记表		DHC_MedRubRep DHC_MedRubRepSub"
	.s RetStr=RetStr_"@"_"kill ^DHCMRO	//垃圾外运		DHC_MedRubbishOut"
	q RetStr
}

/// 医院感染业务
ClassMethod DHCINFECT(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.kill ^DHCMILI	//院内感染监控辅助检查项目列表	DHC_MedInfLabItm	
	.kill ^DHCMDG	//院内感染监控 DHC_MedDepGroup	
	.kill ^DHCMPOS	//院内感染感染部位列表	DHC_MedInfPosition	 DHC_MedInfPosSubDIA
	.kill ^DHCMIDIA	//院内感染疾病监测表	DHC_MedInfDiagnose	
	.kill ^DHCMedIR	//院内感染报告		DHC_MedInfectionRep
	.kill ^DHCMINFCOLOR	//院内感染提示颜色	DHC_MedInfColor	
	.kill ^DHCMInfLD	//院感接口感染科别字典	DHC_MedInfLocDic	
	.kill ^DHCMInfLC	//院感接口感染科别对照	DHC_MedInfLocContrast	
	.kill ^DHCMInfAD	//院感接口抗菌药物字典	DHC_MedInfAntiDic	
	.kill ^DHCMInfAC	//院感接口抗菌药物对照	DHC_MedInfAntiContrast	
	.kill ^DHCMInfPD	//院感接口病原体字典	DHC_MedInfPathogenDic	
	.kill ^DHCMedHA	//行政区划表(省市乡县)	DHC_MedHomeAddress
	.s RetStr="Ok"
	if ChangeType="Show"  d
	.S RetStr="kill ^DHCMILI	//院内感染监控辅助检查项目列表	DHC_MedInfLabItm"
	.S RetStr=RetStr_"@"_"kill ^DHCMDG	//院内感染监控 DHC_MedDepGroup"
	.S RetStr=RetStr_"@"_"kill ^DHCMPOS	//院内感染感染部位列表	DHC_MedInfPosition	 DHC_MedInfPosSubDIA"
	.S RetStr=RetStr_"@"_"kill ^DHCMIDIA	//院内感染疾病监测表	DHC_MedInfDiagnose"
	.S RetStr=RetStr_"@"_"kill ^DHCMedIR	//院内感染报告		DHC_MedInfectionRep"
	.S RetStr=RetStr_"@"_"kill ^DHCMINFCOLOR	//院内感染提示颜色	DHC_MedInfColor	"
	.S RetStr=RetStr_"@"_"kill ^DHCMInfLD	//院感接口感染科别字典	DHC_MedInfLocDic"
	.S RetStr=RetStr_"@"_"kill ^DHCMInfLC	//院感接口感染科别对照	DHC_MedInfLocContrast"
	.S RetStr=RetStr_"@"_"kill ^DHCMInfAD	//院感接口抗菌药物字典	DHC_MedInfAntiDic"
	.S RetStr=RetStr_"@"_"kill ^DHCMInfAC	//院感接口抗菌药物对照	DHC_MedInfAntiContrast"
	.S RetStr=RetStr_"@"_"kill ^DHCMInfPD	//院感接口病原体字典	DHC_MedInfPathogenDic"
	.S RetStr=RetStr_"@"_"kill ^DHCMedHA	//行政区划表(省市乡县)	DHC_MedHomeAddress"
	q RetStr
}

/// 临床路径
ClassMethod CLINICPATH(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.kill ^DHCMR
	.kill ^DHCMRi
	.s RetStr="Ok"
	if ChangeType="Show"  d
	.s RetStr="kill ^DHCMR"
	.s RetStr=RetStr_"@"_"kill ^DHCMRi"
	q RetStr
}

/// 综合查询
ClassMethod WORKLOAD(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^DHCWLACCDATA
	.k ^DHCWLACCDETAIL
	.k ^DHCWLACCDETAILord
	.k ^DHCWLACCOUNT
	.k ^DHCWLAutoReport
	.k ^DHCWLBeIncome
	.k ^DHCWLCFG
	.k ^DHCWLCFGR
	.k ^DHCWLCFGRPT
	.k ^DHCWLCode
	.k ^DHCWLCOLESFORMULA
	.k ^DHCWLCOLSFORMULA
	.k ^DHCWLCurrentPatFeePara
	.k ^DHCWLDataInterface
	.k ^DHCWLDELLOGCFG
	.k ^DHCWLDELLOGDETAIL
	.k ^DHCWLDisPat
	.k ^DHCWLDocRegQty
	.k ^DHCWLExportCFG
	.k ^DHCWLExportCFGRUser
	.k ^DHCWLExportTask
	.k ^DHCWLFORMULA
	.k ^DHCWLFreeExportCFG
	.k ^DHCWLICCFG
	.k ^DHCWLInitStat
	.k ^DHCWLIPCFG
	.k ^DHCWLLMUPCFG
	.k ^DHCWLLOG
	.k ^DHCWLLOGERR
	.k ^DHCWLMidMonReport
	.k ^DHCWLMNMR
	.k ^DHCWLMNMRSUM
	.k ^DHCWLMONFORMULA
	.k ^DHCWLMonReport
	.k ^DHCWLMONRULE
	.k ^DHCWLOPFreeStat
	.k ^DHCWLOPInit
	.k ^DHCWLOPShare
	.k ^DHCWLOPSTAT
	.k ^DHCWLPAIDREPORT
	.k ^DHCWLPeriodRangeCode
	.k ^DHCWLPeriodRangeCodeDetail
	.k ^DHCWLPeriodReport
	.k ^DHCWLPWD
	.k ^DHCWLQueryInit
	.k ^DHCWLRegMonReport
	.k ^DHCWLREGSHARED
	.k ^DHCWLREPORT
	.k ^DHCWLReport
	.k ^DHCWLRPTCONFORMULA
	.k ^DHCWLRPTTITLE
	.k ^DHCWLRTG
	.k ^DHCWLSSCFG
	.k ^DHCWLSSGRPCFG
	.k ^DHCWLSTAT
	.k ^DHCWLSTG
	.k ^DHCWLSTS
	.k ^DHCWLTASK
	.k ^DHCWLTaskFlag
	.k ^DHCWLTemp
	.k ^DHCWLTG
	.k ^DHCWLTJOData
	.k ^DHCWLTJODataIP
	.k ^DHCWLUserStatGroup
	.k ^DHCWLUserStatGrpItem
	.k ^DHCWLUserStRpt
	.k ^DHCWLWAgeReg
	.k ^DHCWLWTEMP
	.k ^DHCWLWYCFee
	.k ^DHCWLYZStatRowID
	.k ^DHCMRAgeRangeCFG
	.k ^DHCMRBase
	.k ^DHCMRBed
	.k ^DHCMRICDConfig
	.k ^DHCMRIPDetail
	.k ^DHCMRIPLoad
	.k ^DHCMRLoad
	.k ^DHCMRLoc
	.k ^DHCMRLocBed
	.k ^DHCMRLocComp
	.k ^DHCMRLOCGRP
	.k ^DHCMRQueryIndexCond
	.k ^DHCMRReportSave
	.k ^DHCMRReportStruSave
	.k ^DHCMRReportTitleSave
	.k ^DHCMRStatItemGrpCFG
	.k ^DHCMRStatValCFG
	.k ^DHCMRTemp
	.k ^MRIPdaily
	.k ^MRIPDayDoc
	.k ^DHCWorkLoad
	.k ^DHCWorkLoadInit
	.k ^DHCWorkLoadQueryInit
	.k ^DHCWorkRegItemFee
	.k ^DHCWorkRegReport
	.k ^TEMPDHCWL
	.k ^mdata("DHCWLBEINCOME")
	.k ^mdata("DHCWLCFGRSUBGRPDOC")
	.k ^mdata("DHCWLCODE")
	.k ^mdata("DHCWLCOLESFORMULA")
	.k ^mdata("DHCWLCOLSFORMULA")
	.k ^mdata("DHCWLDATAINTERFACE")
	.k ^mdata("DHCWLDELLOGCFG")
	.k ^mdata("DHCWLDELLOGDETAIL")
	.k ^mdata("DHCWLEXPORTCFGRUSER")
	.k ^mdata("DHCWLFORMULA")
	.k ^mdata("DHCWLLOG")
	.k ^mdata("DHCWLMIDMONREPORT")
	.k ^mdata("DHCWLMNMR")
	.k ^mdata("DHCWLMNMRSUM")
	.k ^mdata("DHCWLMONFORMULA")
	.k ^mdata("DHCWLMONREPORT")
	.k ^mdata("DHCWLOPSTAT")
	.k ^mdata("DHCWLPERIODRANGECODE")
	.k ^mdata("DHCWLPERIODRANGECODEDETAIL")
	.k ^mdata("DHCWLQUERYINIT")
	.k ^mdata("DHCWLREPORTTITLE")
	.k ^mdata("DHCWLRPTCONFORMULA")
	.k ^mdata("DHCWLWAGEREG")
	.k ^mdata("DHCMRBED")
 	.k ^mdata("DHCMRBEINCOME")
 	.k ^mdata("DHCMRLOCCOMPARE")
 	.k ^mdata("DHCMRWLLOC")

	s RetStr="k ^DHCWLACCDATA@k ^DHCWLACCDETAIL@k ^DHCWLACCDETAILord@k ^DHCWLACCOUNT"
	s RetStr=RetStr_"@"_"k ^DHCWLAutoReport@k ^DHCWLBeIncome@k ^DHCWLCFG@k ^DHCWLCFGR"
	s RetStr=RetStr_"@"_"k ^DHCWLCFGRPT@k ^DHCWLCode@k ^DHCWLCOLESFORMULA@k ^DHCWLCOLSFORMULA"
	s RetStr=RetStr_"@"_"k ^DHCWLCurrentPatFeePara ^DHCWLDataInterface ^DHCWLDELLOGCFG"
	s RetStr=RetStr_"@"_"k ^DHCWLDELLOGDETAIL ^DHCWLDisPat ^DHCWLDocRegQty ^DHCWLExportCFG"
	s RetStr=RetStr_"@"_"k ^DHCWLExportCFGRUser ^DHCWLExportTask ^DHCWLFORMULA ^DHCWLFreeExportCFG"
	s RetStr=RetStr_"@"_"k ^DHCWLICCFG,^DHCWLInitStat,^DHCWLIPCFG,^DHCWLLMUPCFG,^DHCWLLOG"
	s RetStr=RetStr_"@"_"k ^DHCWLLOGERR,^DHCWLMidMonReport,^DHCWLMNMR,^DHCWLMNMRSUM,^DHCWLMONFORMULA"
	s RetStr=RetStr_"@"_"k ^DHCWLMonReport,^DHCWLMONRULE,^DHCWLOPFreeStat,^DHCWLOPInit,^DHCWLOPShare"
	s RetStr=RetStr_"@"_"k ^DHCWLOPSTAT,^DHCWLPAIDREPORT,^DHCWLPeriodRangeCode,^DHCWLPeriodRangeCodeDetail"
	s RetStr=RetStr_"@"_"k ^DHCWLPeriodReport,^DHCWLPWD,^DHCWLQueryInit,^DHCWLRegMonReport"
	s RetStr=RetStr_"@"_"k ^DHCWLREGSHARED,^DHCWLREPORT,^DHCWLReport,^DHCWLRPTCONFORMULA,^DHCWLRPTTITLE"
	s RetStr=RetStr_"@"_"k ^DHCWLRTG,^DHCWLSSCFG,^DHCWLSSGRPCFG,^DHCWLSTAT,^DHCWLSTG,^DHCWLSTS"
	s RetStr=RetStr_"@"_"k ^DHCWLTASK,^DHCWLTaskFlag,^DHCWLTemp,^DHCWLTG,^DHCWLTJOData,^DHCWLTJODataIP"
	s RetStr=RetStr_"@"_"k ^DHCWLUserStatGroup,^DHCWLUserStatGrpItem,^DHCWLUserStRpt,^DHCWLWAgeReg"
	s RetStr=RetStr_"@"_"k ^DHCWLWTEMP,^DHCWLWYCFee,^DHCWLYZStatRowID,^DHCMRAgeRangeCFG,^DHCMRBase,^DHCMRBed"
	s RetStr=RetStr_"@"_"k ^DHCMRICDConfig,^DHCMRIPDetail,^DHCMRIPLoad,^DHCMRLoad,^DHCMRLoc,^DHCMRLocBed,^DHCMRLocComp"
	s RetStr=RetStr_"@"_"k ^DHCMRLOCGRP,^DHCMRQueryIndexCond,^DHCMRReportSave,^DHCMRReportStruSave,^DHCMRReportTitleSave"
	s RetStr=RetStr_"@"_"k ^DHCMRStatItemGrpCFG,^DHCMRStatValCFG,^DHCMRTemp,^MRIPdaily,^MRIPDayDoc,^DHCWorkLoad,^DHCWorkLoadInit"
	s RetStr=RetStr_"@"_"k ^DHCWorkLoadQueryInit,^DHCWorkRegItemFee,^DHCWorkRegReport,^TEMPDHCWL"

	q RetStr
}

/// 护理业务
ClassMethod CLINICWARD(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^DHCADMQTREC,^DHCCLNurseExec("Printed"),^DHCCLNurseExec("oeorid"),^DHCCLNurseExec("DISCON"),^DHCCLNurseExec("Audit")
	.k ^DHCCLNurseExec("SendMedic"),^DHCANOPArrange,^DHCANARRAGE("Pack"),^DHCANARRAGE("ch"),^DHCANARRAGE("jb"),^DHCANARRAGE("note")
	.k ^DHCANARRAGE("opreq"),^DHCLOGSHORTORD("longord"),^DHCLOGSHORTORD("lsord"),^DHCLONGHBORD,^DHCLONGSET("audit"),^DHCSTOPORDITEM
	.k ^DHCOrdExec,^DHCORDItem,^DHCInstrAttOrd

	s RetStr="k ^DHCADMQTREC,^DHCCLNurseExec(""""Printed""""),^DHCCLNurseExec(""""oeorid""""),^DHCCLNurseExec(""""DISCON""""),^DHCCLNurseExec(""""Audit"""")"
	s RetStr=RetStr_"@"_"k ^DHCCLNurseExec(""""SendMedic""""),^DHCANOPArrange,^DHCANARRAGE(""""Pack""""),^DHCANARRAGE(""""ch""""),^DHCANARRAGE(""""jb""""),^DHCANARRAGE(""""note"""")"
	s RetStr=RetStr_"@"_"k ^DHCANARRAGE(""""opreq""""),^DHCLOGSHORTORD(""""longord""""),^DHCLOGSHORTORD(""""lsord""""),^DHCLONGHBORD,^DHCLONGSET(""""audit""""),^DHCSTOPORDITEM"
	q RetStr
}

/// 手术排班
ClassMethod OPERATION(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^OR
	.k ^DHCANOPArrange
	.k ^DHCANArr
	.k ^DHCANRoomEquip
	.k ^DHCANARRAGE("Pack")
	.k ^DHCANARRAGE("ch")
	.k ^DHCANARRAGE("jb")
	.k ^DHCANARRAGE("note")
	.k ^DHCANARRAGE("opreq")
	.k ^DHCANC("Sheet")
	.k ^DHCANOrder
	.k ^DHCANPara

	S RetStr=RetStr_"@"_"k ^OR,^DHCANOPArrange,^DHCANArr,^DHCANRoomEquip,^DHCANARRAGE(""""Pack"""")"
	S RetStr=RetStr_"@"_"k ^DHCANARRAGE(""""ch""""),^DHCANARRAGE(""""jb""""),^DHCANARRAGE(""""note"""")"
	S RetStr=RetStr_"@"_"k ^DHCANARRAGE(""""opreq""""),^DHCANC(""""Sheet""""),^DHCANOrder,^DHCANPara"
	
	q RetStr
}

/// 重症监护
ClassMethod DHCICU(ChangeType)
{
	s RetStr=""
	if ChangeType="Clear" d
	.k ^DHCICUArrange
	.k ^DHCICUOrder
	.k ^DHCICUPara
	.k ^DHCICUTotalIO
	.k ^DHCICUBedEquip
	.k ^DHCNurCare
	.k ^DHCCLScore
	
	S RetStr=RetStr_"@"_"k ^DHCICUArrange,^DHCICUOrder,^DHCICUPara,^DHCICUTotalIO,^DHCICUBedEquip,^DHCNurCare"
	S RetStr=RetStr_"@"_"k ^DHCCLScore"
	q RetStr
}

}
