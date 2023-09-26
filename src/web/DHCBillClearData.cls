/// 名称: web.DHCBillClearData.cls
/// 描述: 处理计费医保组清数据业务--慎用
/// 编写者: Lid
/// 编写日期: 2017-04-18
/// 产品组：计费医保组--计费
Class web.DHCBillClearData Extends BILL.COM.Abstract
{

/// Creator：Lid
/// CreatDate: 2017-04-18
/// Description: 清计费配置数据--慎用--执行前请备份
ClassMethod ClearConfigData()
{
	//病人就诊类别与标准价格--不建议清
	//kill ^DHCTAREP //表：DHC_TarEpisode	实体类：User.DHCTarEpisode
	
	//病人折扣记账系数维护: DHC_TarFactor  User.DHCTarFactor
	kill ^DHCTARF
	
	//计费点设置: DHC_BillCondition  User.DHCBillCondition
	kill ^DHCTarC("BC")
	
	//欠费额度设置
	kill ^DHCJFARREARS	//表：DHC_JFArrears、DHC_JFArrearsMoney	实体类：User.DHCJFArrears、User.DHCJFArrearsMoney
	
	//欠费不受控制科室
	kill ^DHCJFARREARSLOCEXCEPT	//表：DHC_JFArrearsLocExcept	实体类：User.DHCJFArrearsLocExcept
	
	//欠费控制级别内医嘱分类   表: DHC_JFArrearsOrdCat, 实体类: User.DHCJFArrearsOrdCat
	set rowid=0
	while($o(^DHCJFARREARSLEVEL(rowid))) {
		set rowid=$o(^DHCJFARREARSLEVEL(rowid))
		kill ^DHCJFARREARSLEVEL(rowid,"O")
	}

	//押金、预交金和发票人员设置
	kill ^DHCJFRcptGroupSet //表：DHC_JFRcptGroupSet、DHC_JFRcptGroupUser	实体类：User.DHCJFRcptGroupSet、User.DHCJFRcptGroupUser
	
	//调价生效日期设置  存到Global
	kill ^DHCJFHOSPRICEDATECONFIG("DHCBILL")
	
	//门诊收费安全组配置(只清能收费的科室)：DHC_OPGSRecLoc  User.DHCOPGSRecLoc
	set rowid=0
	while($o(^DHCOPGS("GS",rowid))) {
		set rowid=$o(^DHCOPGS("GS",rowid))
		set $p(^DHCOPGS("GS",rowid),"^",2)="N"	//设置表DHC_OPGroupSettings的GS_RecLocFlag字段
		kill ^DHCOPGS("GS",rowid,"RL")
	}
	kill ^DHCOPGSi("GS",0,"LRDR")   //DHC_OPGSRecLoc索引
	
	//门诊收费安全组配置
	set rowid=0
	while($o(^DHCOPGS("GS",rowid))) {
		set rowid=$o(^DHCOPGS("GS",rowid))
		kill ^DHCOPGS("GS",rowid,"PT")     //DHC_OPGSPrintTask  User.DHCOPGSPrintTask
		//kill ^DHCOPGS("GS",rowid,"PM")   //DHC_OPGSPayMode  User.DHCOPGSPayMode   //2021-11-30 ZhYW 清数据方法不清除授权的支付方式配置
	}
	//kill ^DHCOPGSi("GS",0,"CTPMDR")   //DHC_OPGSPayMode索引   //2021-11-30 ZhYW 清数据方法不清除授权的支付方式配置
	
	//门诊允许部分退费医嘱配置: DHC_JFOrderRefundAppConfig User.DHCJFOrderRefundAppConfig
	kill ^DHCJFOrderRefundAppConfig
	
	//退费安全组与科室对照: DHC_OPRefundRequestLoc User.DHCOPRefundRequestLoc
	kill ^DHCOPRefundRequestLoc
	
	//安全组与病人类型配置
	kill ^DHCJFSSGRPADMREASONCONFIG 	//表：DHC_JFSSGrpAdmReasonConfig	实体类：User.DHCJFSSGrpAdmReasonConfig
	
	//费用核查 DHC_BillCheckData User.DHCBillCheckData.cls
	set rowid=0
	while($o(^DHCMPConfig(rowid))) {
		set rowid=$o(^DHCMPConfig(rowid))
		kill ^DHCMPConfig(rowid,"D")
	}
	kill ^DHCMPConfigi(0,"ARCType")
	
	//门诊收费员日报、日报汇总界面页签维护: DHC_BillGroupSetTabs User.DHCBillGroupSetTabs.cls
	kill ^DHCBILLGROUPSETTABS
	kill ^DHCBILLGROUPSETTABSi
	
	//清采血地点维护数据 DHC_OPBillHDDC User.DHCOPBillHDDC,DHC_OPBillHDDCSub User.DHCOPBillHDDCSub 
	kill ^DHCOPBillHDDC
	
	//打印医嘱项子类设置: DHC_JFOrdItemCatSet  User.DHCJFOrdItemCatSet
	kill ^DHCJFORDITEMCATSET
	
	//担保额度设置: DHC_JFWarrantLocLimit  User.DHCJFWarrantLocLimit
	kill ^DHCJFWARRANTLOCLIMIT
	kill ^DHCJFWARRANTLOCLIMITi
	
	//收费类别与发票类型配置: DHC_SOPADMReasonExp  User.DHCSOPADMReasonExp
	kill ^DHCSOPADMRExp
	kill ^DHCSOPADMRExpi
	
	//安全组与押金类型配置: DHC_JFSSGrpDepTypeConfig User.DHCJFSSGrpDepTypeConfig
	kill ^DHCJFSSGRPDEPTYPECONFIG
	
	//费别的支付方式：DHC_OPPACCONPayMode User.DHCOPPACCONPayMode
	kill ^DHCOPPARCONPMODE
	kill ^DHCOPPARCONPMODEi
	
	//自定义价格 存到Global
	kill ^DHCINTBILLARC("ARC")
	
	//住院收费菜单配置: DHC_JFMenuGroupGrant User.DHCJFMenuGroupGrant
	kill ^DHCJFMGG
	
	//页面配置: DHC_BillPageConf User.DHCBillPageConf
	set rowid=0
	while($o(^DHCBillWP(rowid))) {
		set rowid=$o(^DHCBillWP(rowid))
		set data=$g(^DHCBillWP(rowid))
		set code=$p(data,"^",1)
		continue:(code="InterfaceTest")     //对外接口测试属于基础数据，不能清
		kill ^DHCBillWP(rowid,"C")
		kill ^DHCBillWP(0,rowid)     //DHC_BillPageConf索引
	}
	
	//第三方支付配置：DHC_CTPayModeExp User.DHCCTPayModeExp  DHC_CTPayModeRefundRule User.DHCCTPayModeRefundRule
	kill ^User.DHCCTPayModeExpD
	kill ^User.DHCCTPayModeExpI
	
	//清除指标授权
	do ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("Bill_Com_KPI")  
	
	//儿童加收规则维护
	kill ^CF.BILL.CFG.CHIEXTCHARGERULE
	
	//儿童加收
	kill ^CF.BILL.CFG.CHIEXTCHARGE
	
	//允许零价格医嘱配置表
	kill ^CF.BILL.OP.ZeroPriceArcimD
	kill ^CF.BILL.OP.ZeroPriceArcimI
	
	//免费项目维护表
	kill ^CF.BILL.DC.UnAuditItmD
	kill ^CF.BILL.DC.UnAuditItmI
	
	//通用配置-配置数据表:CF_BILL_COM.CfgRelaData
	do ##class(BILL.CFG.COM.GeneralCfg).ClearCfgRelaData()
	
	//数据核查 免审项目审核
    kill ^CF.BILL.DC.UnAuditItmD
    kill ^CF.BILL.DC.UnAuditItmI

	//价格优惠优惠类型：CF_BILL_COM.PriceRule
	kill ^CF.BILL.COM.PriceRuleD
	kill ^CF.BILL.COM.PriceRuleI

	//价格优惠优惠类型关联优惠条件：CF_BILL_COM.PriceRuleAllowPoint
	kill ^CF.BILL.COM.PriceRuleAPD
	kill ^CF.BILL.COM.PriceRuleAPI

	//价格优惠优惠类型关联项目表：CF_BILL_COM.PriceRuleConItm
	kill ^CF.BILL.COM.PriceRuleConItmD
	kill ^CF.BILL.COM.PriceRuleConItmI

	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2020-04-24
/// Description: 清计费业务数据
ClassMethod ClearBusinessData()
{
	do ..ClearComBizData()
	
	do ..ClearRcptsMData()
	
	do ..ClearOPBizData()
	
	do ..ClearIPBizData()
	
	do ..ClearComBizLogData()
	
	do ..ClearTradeBizData()
	
	do ..ClearEInvBizData()
	
	do ..ClearOutPayBizData()
	
	do ..ClearDCBizChkData()
	
	do ..ClearCESLog()
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2020-04-24
/// Description: 清门诊账户数据
ClassMethod ClearAccMData() As %String
{
	kill ^DHCACD
	kill ^DHCACDi
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除公共业务相关数据
ClassMethod ClearComBizData() As %String
{
	kill ^ARRCP
	
	kill ^DHCPB
	kill ^DHCPBi

	kill ^DHCVoidInv    //DHC_VoidInv

	//给统计组用的Global
	kill ^DHCBILLDEL	      //重新生成账单
	kill ^DHCBillCancel	      //中途结算
	kill ^DHCBillCancelOld	  //撤销中途结算

	//收费员借入、借出金额表
	kill ^DHCBCF
	kill ^DHCBCFi
	
	//叫号队列表
	kill ^BILL.AUX.CallQueueD
	kill ^BILL.AUX.CallQueueI
	
	//发票扩展表
	kill ^BILL.INV.PrtExtD
	kill ^BILL.INV.PrtExtI

	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除票据管理相关数据
ClassMethod ClearRcptsMData() As %String
{
	kill ^DHCAMTMAG
	kill ^DHCAMTMAGi
	kill ^DHCINVOICE
	kill ^DHCINVOICEi
	
	kill ^DHCSFBUY
	kill ^DHCSFGRANT
	kill ^DHCSFRECEIPT

	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除门诊业务数据
ClassMethod ClearOPBizData() As %String
{
	kill ^DHCCARDINVPRT
	kill ^DHCCARDINVPRTi
	
	kill ^DHCINVPRT
	kill ^DHCINVPRTi
	
	kill ^DHCINVPRTInsu

	kill ^DHCBCI
	kill ^DHCOPInsFoot
	kill ^DHCOPInsFootI
	
	kill ^DHCOERefundQTY
	
	kill ^DHCOPQFPatInfo     //DHC_OPQFPatTotal

	kill ^DHCJFOPCASHTOBANK  //这个是做什么的？
	
	kill ^DHCINVPRTAP
	kill ^DHCINVPRTAPi
	
	kill ^DHCINVPRTCAP
	kill ^DHCINVPRTCAPi

	kill ^DHCOPBILLRECEIVE      //DHC_OPBillReceive
	kill ^DHCOPBILLRECEIVEi
	
	kill ^DHCEPM
	kill ^DHCEPMi

	//门急诊转住院
	kill ^DHCOPIPADMCON

	//门诊收费异常撤销日志
	kill ^DHCOPBillDelInvPrtLog
	kill ^DHCOPBillDelInvPrtLogi
	
	//单机版应急收费系统数据导入日志表
	kill ^BILL.CES.PO.DHCImportLogD
	kill ^BILL.CES.PO.DHCImportLogI

	//门诊结算子分类金额表
	kill ^BILL.OP.SubCateFeeD
	kill ^BILL.OP.SubCateFeeI
	
	//门诊退费重收医嘱表
	kill ^BILL.OP.ReChgOrderD
	kill ^BILL.OP.ReChgOrderI
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除住院业务数据
ClassMethod ClearIPBizData() As %String
{
	kill ^DHCSFPRINTDETAIL  //住院押金
	kill ^DHCIPBILL   //日志Global
	
	kill ^DHCINVPRTZY
	kill ^DHCINVPRTZYi
	kill ^DHCINVPRTMEDICAL   //DHC_InvprtMedicalSub
	kill ^DHCInvprtzySub     //DHC_InvprtzySub
	
	kill ^DHCINVPRTZYCONDEP
	kill ^DHCINVPRTZYCONDEPi
	
	kill ^DHCJFDepositRowID
	kill ^DHCJFUSERJK

	kill ^DHCIPBILLRECEIVE
	kill ^DHCIPBILLRECEIVEi
	
	kill ^DHCWARRANT
	
	kill ^DHCJFPATIPSUBCATFEE
	
	//病人信息修改查询
	kill ^DHCJFUPR
    
    //住院预交金账
	kill ^DHCJFYJACOUNT
	kill ^DHCIPBillDeptAcountD
    kill ^DHCJFYJACOUNTPAYM
    kill ^DHCJFFEEACOUNT
    
	kill ^DHCIPBILLCONFIRM   //医嘱费用查询界面的审核功能
	
	kill ^DHCJFQFTOTAL       //DHC_JFQFTotal
    
	kill ^DHCJFCheckAdmFee   //DHC_JFCheckAdmFee 费用核查
	
	//预住院转归
	kill ^DHCBillPreIPAdmTransLog
	kill ^DHCBillPreIPAdmTransLogi
	
	kill ^DHCBILLPREDEL     //预住院转门诊/住院， 统计组冲账的

	//住院押金挂失表
	kill ^BILL.IP.DepLostRegist
	
	//住院集中打印发票
	kill ^BILL.IP.SummaryPrtInvD
	kill ^BILL.IP.SummaryPrtInvI
	
	//转诊信息申请登记表
	kill ^BILL.IP.AppRegForRefePatD
	kill ^BILL.IP.AppRegForRefePatI
	
	//住院集中打印发票表和住院发票表关联表
	kill ^BILL.IP.SPInvConPRTD
	kill ^BILL.IP.SPInvConPRTI
	
	//回充押金记录与原发票的”参与结算押金“和”补款“的关联表
	kill ^BILL.IP.StriDepConInvDepD
	kill ^BILL.IP.StriDepConInvDepI
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除公共业务日志数据
ClassMethod ClearComBizLogData() As %String
{
	//清程序执行异常日志
	kill ^BILLSYSERROR

	//打印日志记录
	kill ^DHCBillDtlListPrtLog
	kill ^DHCBillDtlListPrtLogi

	//持久类表数据更新日志表
	kill ^BILL.COM.PO.TriggerLogD
	kill ^BILL.COM.PO.TriggerLogI
	
	//单据打印日志表
	kill ^BILL.COM.PO.PrintLogD
	kill ^BILL.COM.PO.PrintLogI
	kill ^BILL.COM.PO.PrintLogS
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除第三方支付相关业务数据
ClassMethod ClearTradeBizData() As %String
{
	//第三方支付交易明细表
	kill ^DHCBILLETP
	kill ^DHCBILLETPi
	kill ^DHCBILLETB
	kill ^DHCBILLETBi
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除电子发票业务数据
ClassMethod ClearEInvBizData() As %String
{
	//电子票据按日对总账表
	kill ^BILL.EINV.PO.BalanceDayD
	kill ^BILL.EINV.PO.BalanceDayI
	
	//对账明细表
	kill ^BILL.EINV.PO.BalanceDetailsD
	kill ^BILL.EINV.PO.BalanceDetailsI
	
	//电子发票按日对分类账
	kill ^BILL.EINV.PO.BalanceSubDayD
	kill ^BILL.EINV.PO.BalanceSubDayI
	
	//业务数据上传流水表
	kill ^BILL.EINV.PO.BLDataUpDetailsD
	kill ^BILL.EINV.PO.BLDataUpDetailsI
	
	//对账差异表
	kill ^BILL.EINV.PO.CenterDifferEinvD
	kill ^BILL.EINV.PO.CenterDifferEinvI
	
	//票据明细信息表
	kill ^BILL.EINV.PO.CenterEInvInfoD
	kill ^BILL.EINV.PO.CenterEInvInfoI
	
	kill ^BILL.EINV.PO.HISBalanceDayD
	kill ^BILL.EINV.PO.HISBalanceDayI
	
	kill ^BILL.EINV.PO.HisDifferEinvD
	kill ^BILL.EINV.PO.HisDifferEinvI
	
	kill ^BILL.EINV.PO.InvBuyApplyD
	kill ^BILL.EINV.PO.InvBuyApplyI
	
	//发票发放申请
	kill ^BILL.EINV.PO.InvGrantApplyD
	kill ^BILL.EINV.PO.InvGrantApplyI
	
	kill ^BILL.EINV.PO.InvUpDetailsD
	kill ^BILL.EINV.PO.InvUpDetailsI
	kill ^BILL.EINV.PO.InvUpDetailsS
	
	//电子票据日志表
	kill ^BILL.EINV.PO.LogInfoD
	kill ^BILL.EINV.PO.LogInfoI
	
	//HIS对账明细表
	kill ^BILL.EINV.PO.MedicalEInvInfoD
	kill ^BILL.EINV.PO.MedicalEInvInfoI
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-12-28
/// Description: 清除外院报销业务数据
ClassMethod ClearOutPayBizData() As %String
{
	//外院流水表
	kill ^BILL.OUTPAY.InsuInvD
	kill ^BILL.OUTPAY.InsuInvI
	
	//外院项目明细表
	kill ^BILL.OUTPAY.ItemsD
	kill ^BILL.OUTPAY.ItemsI
	
	//外院报销结算表
	kill ^BILL.OUTPAY.InvPrtD
	kill ^BILL.OUTPAY.InvPrtI
	
	//外院报销结算发票关联表
	kill ^BILL.OUTPAY.InvConD
	kill ^BILL.OUTPAY.InvConI
	
	//外院报销结算支付方式表
	kill ^BILL.OUTPAY.InvPayModeD
	kill ^BILL.OUTPAY.InvPayModeI
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2022-06-30
/// Description: 清除数据核查业务数据
ClassMethod ClearDCBizChkData() As %String
{
	kill ^BILL.DC.PO.CheckResultD
    kill ^BILL.DC.PO.CheckResultI
    
    kill ^BILL.DC.PO.CheckResultDetD
    kill ^BILL.DC.PO.CheckResultDetI
	
	quit 0
}

/// Creator：ZhYW
/// CreatDate: 2023-05-18
/// Description: 清除单机版数据导入导出日志
ClassMethod ClearCESLog() As %String
{
	//单机版数据导出日志
	kill ^BILL.CES.PO.DHCExportLogD
    kill ^BILL.CES.PO.DHCExportLogI
    
    //单机版数据回写日志
    kill ^BILL.CES.PO.DHCImportLogD
    kill ^BILL.CES.PO.DHCImportLogI
	
	quit 0
}

}
