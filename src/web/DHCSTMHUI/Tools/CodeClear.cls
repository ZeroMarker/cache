Import sqluser

Class web.DHCSTMHUI.Tools.CodeClear Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// [仅限上线前使用] 清除所有数据(库存、业务、基础代码)
/// d ##class(web.DHCSTMHUI.Tools.CodeClear).Clear()
ClassMethod Clear1() As %String
{
	d ..ClearBussinessData()	//清除业务数据
	d ..ClearStk()				//清除库存数据
	d ..ClearCode()				//清除基础代码数据
	q 0
}

/// 清除某科室的数据(适用于存在某科室的测试数据的情况)
/// Input:		loc -科室rowid, clearType - 科室库存项目处理类型(0-库存归零, 1-删除库存项条目)
/// d ##class(web.DHCSTMHUI.Tools.CodeClear).Clear2(loc,clearType)
ClassMethod Clear2(loc As %String, clearType As %String) As %String
{
	n (loc,clearType)
	q:loc="" -1
	d ..ClearLocBusinessData(loc)	//科室业务单据数据
	d ..ClearInTrans(loc)			//科室台帐数据
	i clearType=1 d
	. d ..ClearLocStk(loc)			//科室库存归零
	e  d
	. d ..SetLocStkZero(loc)		//科室库存清除(包括科室库存项目)
	q
}

/// // 清除基础代码
/// // !!! 注意：本方法仅在系统导入基础数据之前执行 ( 一旦执行导入数据后即不允许执行，切切 !!! )
ClassMethod ClearCode()
{
#;	// ******  以下数据的清除已被整理到HIS产品清除数据中，因此屏蔽掉 2017年4月21日 ******************
#;	;药学项
#;	K ^PHCD
#;	;库存项
#;	k ^INCI   ;INC_Itm
#;	k ^INCALIAS,^mdata("INCALIAS")   ;INC_Alias
#;	k ^INASP,^mdata("INADJSALEPRICE")  ;IN_AdjSalePrice
#;	k ^DHCINASPD,^mdata("DHCINASPDETAIL")  ; DHC_INASP_Detail
#;	k ^DHCSTINAPB,^mdata("INADJPRICEBATCH")	;IN_AdjPriceBatch
#;	k ^DHCITMINFO,^mdata("DHCITMADDIONINFO")  ;DHC_ItmAddioninfo
#;	k ^ITMREK,^mdata("DHCITMREMARK")		;DHC_ItmRemark,DHC_ItmReVendor
#;	k ^DHCItemSC,^mdata("DHCITMSTORECOND")  ;DHC_ItmStoreCond
#;	k ^DHCILT,^mdata("DHCINCILINKTAR")  ;DHC_InciLinkTar
#;	k ^DHCItmSpecList ; DHC_ItmSpecList
#;	k ^DHCITMDOC,^mdata("DHCITMDOC")   ; DHC_ItmDocStorage
#;	
#;	;医嘱项
#;	k ^ARCIM,^ARC("ALIAS"),^ARC("KEYW")
#;	;收费项
#;	k ^DHCTARAL,^DHCTARI,^DHCTARIi,^mdata("DHCTARITEM"),^mdata("DHCTARITEMALIAS")
#;	k ^DHCOLT,^mdata("DHCORDERLINKTAR"),^DHCTARF,^mdata("DHCTARFACTOR")
#;	;供应商
#;	k ^APC("APCVM") ,^DHCSTV,^mdata("DHCSTVENDOR")	;APC_Vendor
#;	k ^APC("APCVC")	;APC_VendCat
#;	k ^APCVENDORINFO,^mdata("APCVENDORADDINFO")	;APC_VendorAddionInfo
#;	;生产厂家
#;	k ^PHMNF,^DHCMANF,^mdata("DHCMANFADDIONINFO")	;PH_Manufacturer,DHC_Manf_AddionInfo
#;	;配送商
#;	k ^DHCCARR,^mdata("DHCCARRIER") ;DHC_Carrier
#;	
#;	;产地
#;	k ^DHCSTORI  ;DHC_STOrigin
#;	
#;	;类组-库存分类	
#;	k ^DHCSCG,^mdata("DHCSTKCATGROUP")  ;DHC_StkCatGroup,DHC_StkCatGrpRelations,DHC_StkCatSubGrp
#;	k ^DHCSLCG,^mdata("DHCSTKLOCDRUGGROUP")		;DHC_StkLocCatGroup,DHCStkLocUserCatGrp
#;	k ^INC("SC")	;INC_StkCat
#;	// ***** 以上数据的清除已被整理到HIS系统数据清除中，因此屏蔽掉 2017年4月21日************* 
						
	;货位码
	k ^INC("SB")								;INC_StkBin
	d ..DeleteBDPMappingHosp("INC_StkBin")
	k ^DHCPBLIST,^mdata("DHCPUBLICBIDDING")		;DHC_PublicBiddingList 招标轮次
	d ..DeleteBDPMappingHosp("DHC_PublicBiddingList")
	k ^DHCIV,^mdata("DHCITMVEN")				;DHC_ItmVen
	;
	k ^DHCLIG,^mdata("DHCLOCITEMGRP")			;DHC_LocItemGrp  科室项目组
	d ..DeleteBDPMappingHosp("DHC_LocItemGrp")
	
	k ^DHCLMG,^mdata("DHCLOCMANGRP")			;DHC_LocManGrp 科室管理组
	
	k ^DHCINMT,^mdata("DHCMARKTYPE")			;DHC_MarkType 定价类型
	d ..DeleteBDPMappingHosp("DHC_MarkType")
	
	k ^DHCINMR,^mdata("DHCMARKFACTOR")			;DHC_MarkRule 定价规则
	d ..DeleteBDPMappingHosp("DHC_MarkRule")
	
	k ^DHCINMRA									;DHC_MarkRuleAdd
	
	k ^DHCITMPBL,^mdata("DHCITMPUBBIDDINGLEVEL")	;DHC_ItmPbLevel 招标级别代码
	d ..DeleteBDPMappingHosp("DHC_ItmPbLevel")	
	
	k ^DHCRFUREQ,^mdata("DHCREFUSEREQLOCITM")	;DHC_RefuseReqLocItm 拒绝请求设置
	
	k ^DHCLUG,^mdata("DHCSUBLOCUSERGROUP")		;DHC_SubLocUserGroup,DHC_SubLocUser 科室专业组 科室专业组人员
	k ^DHCLOCRQCONFIG,^mdata("DHCSUBLOCUSERREQMONTHLYCONFIG"),^mdata("DHCSUBLOCREQMONTHLYCONFIG")	;DHC_SubLocReqMonthlyConfig,DHC_SubLocUserReqMonthlyConfig 专业组请领限制 人员请领限制
	k ^DHCSLGA,^mdata("DHCSLGA")				;DHC_SubLocGrpAllot,DHC_SubLocGrpAllotItm,DHC_SubLocGrpAllotScale 专业组发放分配
	k ^DHCIMCSA									;DHC_ItmManfCert,DHC_ItmManfCertPic,DHC_ItmManfCert_SA,DHC_ItmManfCert_SAPic 供应链生产厂家注册
	
	k ^DHCLOCPPUSER								; DHC_LocPurPlanUser 采购员维护
	k ^DHCPAYMODE,^mdata("DHCPAYMODE")			;DHC_PayMode 支付方式
	k ^DHCItmRepLoc								;DHC_ItmRepLoc 科室物资补货库房定义
	k ^DHCINCHOSP								;DHC_IncHosp 库存项零库存设置
	k ^DHCMCG,^mdata("DHCMANFCATGROUP")			;DHC_ManfCatGroup 生产厂家-类组对照表
	k ^DHCACG,^mdata("DHCAPCCATGROUP")			;DHC_ApcCatGroup 供应商-类组对照表
	k ^DHCItmChgType							;DHC_ItmChargeType 物资收费类型
	d ..DeleteBDPMappingHosp("DHC_ItmChargeType")
	k ^DHCMECAT									;DHC_MedEqptCat 器械材料分类表
	k ^DHCMANFPIC,^mdata("DHCMANFADDIONINFOPIC")	;DHC_Manf_AddionInfoPic
	k ^APCVENDORINFO,^mdata("APCVENDORADDINFO")	;APC_VendorAddionInfo
	
	k ^DHCPS,^mdata("DHCPLANSTATUS")			;DHC_PlanStatus 计划状态表
	d ..DeleteBDPMappingHosp("DHC_PlanStatus")
	k ^DHCPSI,^mdata("DHCPLANSTATUSINIT")		;DHC_PlanStatusInit 科室采购审核级别维护
	
	k ^DHCSTLOCCONF,^mdata("DHCSTOCKTRANSFERLOCCONF")	;DHC_StockTransferLocConf 库存转移科室配置表
	
	;药品不清理原因表与平台关联表 与药品同步
	;k ^INC("ADJ"),^INC("RET")  ;INC_ReasonForAdjustment,INC_ReasonForReturn 库存调整原因 退货原因
	;d ..DeleteBDPMappingHosp("INC_ReasonForAdjustment")
	;d ..DeleteBDPMappingHosp("INC_ReasonForReturn")
	
	;k ^DHCOPTYPE,^mdata("DHCIMPORTTYPE") ;DHC_OperateType 业务类型
	;d ..DeleteBDPMappingHosp("DHC_OperateType")
	
	;k ^DHCSTREASON("ASP"),^mdata("DHCREASONFORADJUSTPRICE")  ;DHC_ReasonForAdjustPrice 调价原因表
	;d ..DeleteBDPMappingHosp("DHC_ReasonForAdjustPrice")
	;k ^DHCSTREASON("TRFI")   ;DHC_ReasonForTrfIn  20160427  这个表有问题啊 应该是不用了
	;k ^DHCSTREASON("SCRAP"),^mdata("DHCINCREASONFORSTOCKSCRAP")	;DHC_IncReasonForStockScrap 报损原因
	;d ..DeleteBDPMappingHosp("DHC_IncReasonForStockScrap")
	;k ^DHCNUR,^mdata("DHCITMNOTUSEREASON")  ;DHC_ItmNotUseReason 不可用原因
	;d ..DeleteBDPMappingHosp("DHC_ItmNotUseReason")
	
	k ^DHCSTTKW,^mdata("DHCLOCWINDOW")			;DHC_InStkTkWindow 科室窗口定义表
	
	k ^DHCItmRQLL								;DHC_ItmReqLocList
	k ^DHCLVCONFIG,^mdata("DHCLVCONFIG")		;DHC_LVConfig 低值耗材限制请求表
	k ^INC("RFRQ")								;DHC_ReasonForRefuseRequest 请求单拒绝原因维护
	d ..DeleteBDPMappingHosp("DHC_ReasonForRefuseRequest")
	
	k ^DHCMapScArcic							;DHC_ScMapArcic 库存分类与医嘱项、收费项相关分类对照表
	d ..DeleteBDPMappingHosp("DHC_ScMapArcic")
	k ^DHCHVMAPARC,^mdata("DHCHVMAPARC")		;DHC_HvMapArc  高值关联医嘱收费
	d ..DeleteBDPMappingHosp("DHC_HvMapArc")
	
	
	k ^DHCSOUROFFUND,^mdata("DHCSOUROFFUND")	;DHC_SourceOfFund 资金来源
	d ..DeleteBDPMappingHosp("DHC_SourceOfFund")
	
	k ^DHCSTBC,^mdata("DHCSTBOOKCAT")			;DHCST_BookCat 账簿分类
	d ..DeleteBDPMappingHosp("DHCST_BookCat")
	k ^DHCLOC,^mdata("DHCCTLOC")				;DHCST_CtLoc 科室库管信息维护
	
	k ^DHCSD,^mdata("DHCSTKDECIMAL")			;DHC_StkDecimal,DHC_StkDecimalItm 小数规则
	d ..DeleteBDPMappingHosp("DHC_StkDecimal")
	
	k ^DHCStkLocBillPrintMode					;DHC_StkLocBillPrintMode
	k ^DHCSLG,^mdata("DHCSTKLOCGROUP")			;DHC_StkLocGroup,DHC_StkLocGrpItm 科室组
	d ..DeleteBDPMappingHosp("DHC_StkLocGroup")
	
	k ^DHCSTERROR,^mdata("DHCSTKSYSERRORRECORD")	;DHC_StkSysErrorRecord 系统错误日志记录表

	k ^DHCHVMIL								;DHC_HVMat_ItmCheckList 物资对照
	k ^DHCHVMLL								;DHC_HVMat_LocCheckList 科室对照
	k ^DHCHVMVML,^mdata("^DHCHVMVML")		;DHC_HVMat_APCVMCheckList 供应商对照
	k ^DHCHVMMFL,^mdata("^DHCHVMMFL")		;DHC_HVMat_MANFCheckList 生产厂家对照
	k ^DHCHVMUML,^mdata("^DHCHVMUML")		;DHC_HVMat_UOMCheckList 单位对照
	k ^DHCHVMUSRL,^mdata("DHCHVMUSRL")		;DHC_HVMat_USERCheckList 人员对照
	
	k ^INC("CFR")								;INC_POCanc_FullFillReason 订单取消原因
	d ..DeleteBDPMappingHosp("INC_POCanc_FullFillReason")
	
	;k ^DHCITMQL,^mdata("DHCITMQUALITYLEVEL")	;DHC_ItmQualityLevel  质量层次
	;d ..DeleteBDPMappingHosp("DHC_ItmQualityLevel")  ;待确定 药品的已注释 ？？
	
	k ^INC("SCAT")								;INC_SterileCategory  灭菌分类 
	d ..DeleteBDPMappingHosp("INC_SterileCategory")
	
	k ^DHCVEI,^mdata("DHCVENEVALINDEX")  ;DHC_VendorEvaluationIndex  供应商评价
	d ..DeleteBDPMappingHosp("DHC_VendorEvaluationIndex")
	
	k ^DHCMCO									;DHC_MatCatOfficial  官方分类
	d ..DeleteBDPMappingHosp("DHC_MatCatOfficial")
	k ^DHCMCC									;DHC_MatCatClinical  临床分类
	d ..DeleteBDPMappingHosp("DHC_MatCatClinical")
	k ^DHCMCS									;DHC_MatCatSpecial  特殊分类
	d ..DeleteBDPMappingHosp("DHC_MatCatSpecial")
	
	k ^DHCHUPL,^mdata("DHCHVUSEPERMISSONLOC")	;DHC_HVUsePermisson_Loc,DHC_HVUsePermisson_LocUser 高值紧急业务授权
	;单号规则如何处理  ？？？
	k ^DMALM,^mdata("DHCMatAuditLevel")			;DHC_MatAuditLevel 业务审核级别维护
	
	;合同
	k ^DHCSTMCONTRACK,^DHCSTMITMCONTRACK,^DHCSTMCONTPIC
	k ^mdata("DHCSTMCONTRACK"),^mdata("DHCSTMITMCONTRACK"),^mdata("DHCSTMCONTPIC")
	
	k ^User.DHCDealerD,^User.DHCDealerI			;DHC_Dealer  经销商
	d ..DeleteBDPMappingHosp("DHC_Dealer")
	
	;打印模式
	k ^User.MATPrintRulesD,^User.MATPrintRulesI ;MAT_PrintRules打印模式说明
	
	;资质信息表
	k ^User.DHCCertDetailD,^User.DHCCertDetailI ;DHC_CertDetail供应商生产厂家资质信息表
	
	;医保分类
	k ^User.MATInsuCodeD,^User.MATInsuCodeI		;MAT_InsuCode
	k ^User.MATInsuSpecD,^User.MATInsuSpecI		;MAT_InsuSpec
	
	;接口配置
	k ^User.DHCServiceConfigD,^User.DHCServiceConfigI
	
	;资质类型
	k ^User.DHCCertTypeD,^User.DHCCertTypeI	;DHC_CertType
	
	;供应商修改历史表
	k ^DHCSTVH,^mdata("DHCSTVENDORHISTORY")	;DHC_STVendor_History
	
	;生产厂家修改历史表
	k ^DHCMANFH,^mdata("DHCMANFHISTORY")
	
	;图片文件
	k ^DHCIPIC,^mdata("DHCIPIC")
	
	;高值点评
	k ^User.DHCMatCNTAdviceD,^User.DHCMatCNTAdviceI ;DHC_MatCNT_Advice
	k ^User.DHCMatCNTLocD,^User.DHCMatCNTLocI	;DHC_MatCNT_Loc
	k ^User.DHCMatCNTLocUserI	;DHC_MatCNT_LocUser
	k ^User.DHCMatCNTReasonD,^User.DHCMatCNTReasonI	;DHC_MatCNT_Reason
	
	;配送商科室授权
	k ^CF.HRP.MAT.CarrierLocD,^CF.HRP.MAT.CarrierLocI
	
	;界面科室授权
	k ^CF.HRP.MAT.LocConfigD,^CF.HRP.MAT.LocConfigI
	
	;数据初始化
	k ^CT.HRP.MAT.DataInitRecordD,^CT.HRP.MAT.DataInitRecordI
	
	;通用字典类型值
	k ^CT.HRP.MAT.ComDictValueD,^CT.HRP.MAT.ComDictValueI
	d ..DeleteBDPMappingHosp("CT_HRP_MAT.ComDictValue")
	
	;带量采购信息
	k ^CT.HRP.MAT.PurchaseInfoD,^CT.HRP.MAT.PurchaseInfoI
	k ^CT.HRP.MAT.PurInfoRelationD,^CT.HRP.MAT.PurInfoRelationI
	
	;授权书
	k ^CT.HRP.MAT.SupplyChainD,^CT.HRP.MAT.SupplyChainI
	k ^CT.HRP.MAT.SupplyChainItmI,^CT.HRP.MAT.SupplyChainLevelI
	
	;科室定额维护
	k ^DHCLRL	;DHC_LocReqLimit,DHC_LocItmLimitAmt
}

/// 清除业务数据(含药品,耗材,因为部分表是共用的)
/// !!! 注意：仅在库存系统启动业务之前执行 ( 不论任何科室，一旦库存系统启动即不允许执行，切切 !!! )
ClassMethod ClearBussinessData()
{
	//采购计划
	k ^INPP	,^mdata("INPURPLAN")			;IN_PurPlan,IN_PurPlanItm,DHC_INPPReqItm
	k ^DHCAutoPurPlan   ;DHC_AutoHandlePurPlan
	K ^DHCPA,^mdata("DHCPLANAUDIT")			;DHC_PlanAudit
	
	//订单
	k ^INPO									;IN_PO,IN_POItm 订单
	k ^DHCINPO,^mdata("DHCINPO")			;DHC_INPO
	k ^DHCINPOI								;DHC_INPOItm
	k ^DHCPoItmExpdLog						;DHC_INPOItmExpdLog
	
	//入库单退货单
	K ^DHCINGR,^mdata("DHCINGDREC")			;DHC_INGdRec,DHC_INGdRecItm
	K ^INGRT,^mdata("DHCINGDRET")			;DHC_INGDRET,DHC_INGRTITM	
	k ^DHCINGRINFO,^mdata("DHCINGdRecItmAddionInfo")	;DHC_INGdRecItmAddionInfo
	//请求单
	k ^INRQ									;IN_Request,IN_ReqItm
	k ^DHCINRQ,^mdata("DHCINREQUEST")		;DHC_INRequest
	k ^DHCINRQI,^mdata("DHCINREQITM")       ;DHC_INReqItm
	k ^DHCTMPREQREC,^mdata("DHCTMPREQRECORDS")	;DHC_TmpReqRecords
	k ^DHCINRQMOVE,^mdata("DHCINREQMOVESTATUS")	;DHC_INReq_MoveStatus (***Portal)
	k ^DHCINRQIMOVE							;DHC_INReqItm_MoveStatus
	k ^DHCAutoReq							;DHC_AutoHandleReq
	k ^DHCINRQIEVL,^mdata("DHCINREQITMEVALUATION")	;DHC_INReqItm_Evaluation  (***Portal)
	
	//库存转移
	k ^DHCINIT,^mdata("DHCINISTRF") 		;DHC_InIsTrf,DHC_InIsTrfItm
	
	//库存调整
	K ^DHCINAD,^mdata("DHCINADJ")			;DHC_INAdj,DHC_INAdjItm

	//盘点
	K ^DHCINST,^mdata("DHCINSTKTK")			;DHC_InStkTk,DHC_InStkTkItm,DHC_InStkTkGrp,DHC_InStkTkItmWd,DHC_InStkTkItmTrack
	k ^DHCSLST,^mdata("DHCSLST")			;DHC_SubLocStkTk,DHC_SubLocStkTkItm
	//月报年报
	K ^DHCSM,^mdata("DHCSTKMON")			;DHC_StkMon,DHC_StkMonReport,DHC_StkMonRepLcBt,DHC_StkMonTrans
	k ^SMSTATI,^mdata("DHCSTKMONSTAT")		;DHC_StkMonStatIn									
	K ^SMSTAT,^mdata("DHCSTKMONSTATIN")		;DHC_StkMonStat
	k ^SMSTATIM,^mdata("DHCSTKMONSTATM")	;DHC_StkMonStatIn_M									
	K ^SMSTATM,^mdata("DHCSTKMONSTATINM")	;DHC_StkMonStat_M
	k ^DHCSMSum								;DHC_StkMonSum_TransLoc,DHC_StkMonSumIn_CatGrp
	k ^DHCSMVchStatus						;DHC_StkMon_VoucherStatus

	K ^DHCSTKYEAR,^DHCSTKYEARREP,^mdata("DHCSTKYEAR") ;DHC_StkYear,Dhc_StkYearReport
	K ^STADDION,^mdata("DHCSTKYEARADDION")	;DHC_STKYEARADDION
	//付款
	k ^DHCPAY,^mdata("DHCPAY"),^DHCPAYM,^mdata("DHCPAYMON")	;DHC_Pay,DHC_PayItm,DHC_PayMon,DHC_PayMonVendor 
	k ^DHCVendorInv,^mdata("DHCVENDORINV")	;DHC_VendorInv,DHC_VendorInvItm
	
	//调价损益
	k ^ASPA,^mdata("DHCASPAMOUNT")			//DHC_ASPAmount,DHC_ASPAmountLB调价损益记录
	k ^DHCRETA,^RETA(0)						//DHC_RetAspAmount 业务损益表
	
	//报损
	k ^DHCINSP,^mdata("DHCINSCRAP")			//DHC_INScrap,DHC_INSpItm
	
	//科室内消耗
	k ^DHCINDS,^mdata("DHCINDISP")			//DHC_INDisp,DHC_INDispItm
	k ^DHCINDSREQ,^mdata("DHCINDISPREQ")    ;DHC_INDispReq,DHC_INDispReqItm
	k ^DHCINDSR,^mdata("DHCINDISPRET")		;DHC_InDispRet ,DHC_InDispRetItm
	k ^DHCLM ,^mdata("DHCLOCMAIN")			;DHC_LocMaintain,DHC_LocMaintainItm
	
	//配送记录
	k ^DHCINDSTR,^mdata("DHCINDISTRIBUTE")	//DHC_INDistribute,DHC_INDistributeItm
	
	//台帐
	k ^DHCINTR,^mdata("DHCINTRANS")			//DHC_InTrans
	
	//高值数据与跟踪
	k ^DHCHVMORI,^mdata("DHCHVMATORDITM")	;DHC_HVMat_OrdItm
	k ^DHCHVMORIRET,^mdata("DHCHVMORIRET")	;DHC_HVMat_OrdItmRet
	k ^DHCIT,^DHCITD,^mdata("DHCITMTRACK")	;DHC_ItmTrack,DHC_ItmTrackDetail,DHC_ItmTrackItm
	k ^DHCOBB,^mdata("DHCOBB")				;DHC_OeoriBindBarCode
	k ^DHCSPLIT,^mdata("DHCBARCODESPLITINFO")	;DHC_BarCodeSplitInfo
	k ^DHCHVMBB,^mdata("DHCHVMATBARCODEBINDS")	;DHC_HVMat_BarcodeBinds
	//高值包
	k ^DHCPCL,^mdata("DHCPACKCHARGELINK")	;DHC_PackChargeLink	
	
	//数据工具
	k ^DHCDATAINPUTERR ,^mdata("DHCDataInputErr") ;DHC_DataInputErr
	
	//资质授权
	k ^DHCDICGROUP,^mdata("DHCDICGROUP")	;DHC_DicGroup
	
	k ^DHCEJLVCONFIG,^mdata("DHCEJLVCONFIG")	;DHC_EJLVConfig

	//供应商
	k ^DHCVE,^mdata("DHCVENEVALUE")			;DHC_VendorEvaluation
	
	//材料发放记录
	k ^DHCMATDISP							;DHC_MatDisp,DHC_MatDispItm,DHC_MatDispItmInclb
	
	//材料发放退回记录
	k ^DHCMATDISRET							;DHC_MatDispRet,DHC_MatDispRetItm
	
	//付款封面
	k ^DHCINGRCover							;DHC_INGdRec_Cover,DHC_INGdRec_CoverItm
	
	//凭证
	k ^DHCSVC,^mdata("DHCSTOCKVOUCHER")		;DHC_StockVoucher,DHC_StockVoucherItm
	
	//物资信息审核日志
	k ^DHCMALG,^mdata("DHCAuditLog"),^mdata("DHCAuditLogINCI")	;DHC_AuditLog,DHC_AuditLog_INCI
	
	//物资信息审核操作记录
	k ^DHCDWAL,^mdata("DHCWorkAuditLog")	;DHC_WorkAuditLog
	
	//接口对接单据信息
	k ^User.DHCServiceBillD,^User.DHCServiceBillI	;DHC_ServiceBill
	
	//接口日志
	k ^User.DHCDataExchangeLogD,^User.DHCDataExchangeLogI ;DHC_DataExchangeLog
	
	//物资住院发放
	k ^User.DHCInMatDispD,^User.DHCInMatDispI ;DHC_InMatDisp
	k ^User.DHCInMatDispInclbI ;DHC_InMatDispInclb
	k ^User.DHCInMatDispItmI
	
	//物资住院发放退回记录
	k ^User.DHCInRetDispD,^User.DHCInMatRetD,^User.DHCInMatRetI
	k ^User.DHCInMatRetInclbI
	k ^User.DHCInMatRetItmI
	
	//必填项配置表
	k ^INCMI,^mdata("DHCINCIINFOMUSTINPUT")
	
	//发票
	k ^DHCRcRtInv,^mdata("DHCRcRtInv")
	k ^User.DHCInvInfoD,^User.DHCInvInfoI,^User.DHCInvInfoItmI
	
	//高值点评
	k ^User.DHCMatCommentsD,^User.DHCMatCommentsI	;DHC_MatComments
	k ^User.DHCMatCommentsItmI	;DHC_MatCommentsItm
	k ^User.DHCMatCommentsLogI	;DHC_MatCommentsLog
	k ^User.DHCMatCNTOrdReCheckD,^User.DHCMatCNTOrdReCheckI	;DHC_MatCNT_OrdReCheck
	
	;MAT_ReservedDetail耗材医嘱在途信息表
	k ^User.MATReservedDetailD,^User.MATReservedDetailI
	
	;红冲
	k ^HRP.MAT.INGRRedOffsetD,^HRP.MAT.INGRRedOffsetI
	k ^HRP.MAT.INGRRedOffsetItmI
}

/// 清除库存数据(所有科室)
/// !!! 注意：仅在库存系统运行前执行( 不论任何科室，一旦库存系统启用即不允许执行，切切  !!!  )
ClassMethod ClearStk()
{
	k ^INCI("IB_NO"),^INCI("IB_EX"),^INCI("IB_NoX"),^INCI("LB_IB")

	k ^DHCINCLB,^mdata("DHCINCITMLCBT")		;DHC_IncItmLcBt ;库存批次
	k ^DHCINCIB,^mdata("DHCINCLBADDION")	;DHC_INCItmBat
	k ^DHCINCIL,^mdata("DHCINCITMLOC")		;DHC_INCItmLoc

	s inci=0 f  s inci=$o(^INCI(inci)) q:inci=""  d
	.k ^INCI(inci,"IB")						;INC_ItmBat
	.
	.s loc="" f  s loc=$o(^INCI(inci,"IL",loc)) q:loc=""  d
	..q:'$d(^INCI(inci,"IL",loc))
	..k ^INCI(inci,"IL",loc)				;INC_ItmLoc
	
	k ^INCI("IL_LOC")
	k ^INCI(0,"CONS")
	k ^DHCLOCTOT,^DHCBTLOCTOT,^mdata("DHCLOCDAILYTOTAL")	;DHC_LocDailyTotal,DHC_LocBTDailyTotal
	k ^User.MATReservedDetailD,^User.MATReservedDetailI ;MAT_ReservedDetail耗材医嘱在途信息表
	q
}

/// 清除库存数据(某科室)
/// loc -科室rowid
/// 
ClassMethod ClearLocStk(locdr As %String)
{
	n (locdr)
	q:loc="" -1
	&sql(delete from dhc_locdailytotal where day_loc_dr=:locdr)
	&sql(delete from inc_itmloc where incil_ctloc_dr=:locdr)
}

/// 清某科室所有台帐数据 
ClassMethod ClearInTrans(locdr As %String)
{
	n (locdr)
	q:locdr="" -1
	s i=0
	s intr=0 f  s intr=$o(^DHCINTR(intr)) q:(intr="")!(intr=0)  d
	.q:($d(^DHCINTR(intr))=0)!($d(^DHCINTR(intr))=10)
	.s inclb=$p(^DHCINTR(intr),"^",7)
	.Q:inclb=""
	.S ctloc=$$LOC^ST01(inclb)
	.q:ctloc'=locdr
	.S ttype=$p(^DHCINTR(intr),"^",1)
	.S pointer=$p(^DHCINTR(intr),"^",9)
	.s i=i+1
	.s ^TMP($j,"INTR",i)=intr
	.W "."
	.I ttype="T" D
	..S intrk=$O(^DHCINTR(0,"TypePointer","K",pointer,""))
	..Q:intrk=""
	..s i=i+1
	..s ^TMP($j,"INTR",i)=intrk
	..W "."
	
	s i=0
	f  s i=$O(^TMP($j,"INTR",i)) q:i=""  d
	.s intr= ^TMP($j,"INTR",i)
	.&sql(delete from DHC_intrans where intr_rowid=:intr)
	.w "."
	q 0
}

/// 将某科室项目的截止库存全部置为0，
/// 注意：一般这种情况适用于不可删除INC_ItmLoc的情况(比如科室的库存上下限已维护、货位已维护等)
///  LocID -科室rowid
ClassMethod SetLocStkZero(LocID)
{
	n (LocID)
	q:LocID="" -1
	&sql(update inc_itmloc set incil_logqty=0,INCIL_ReservedQty=0 where incil_ctloc_dr=:LocID and incil_inci_parref->inci_incsc_dr->incsc_stktype='M')
	&sql(update INC_ItmLcBt set INCLB_PhyQty=0,INCLB_DirtyQty=0 where INCLB_INCIL_ParRef->incil_ctloc_dr=:LocID and inclb_incil_parref->incil_inci_parref->inci_incsc_dr->incsc_stktype='M')
	s ItmID=""
	f  s ItmID=$o(^DHCLOCTOT(0,"LOCITMDATE",LocID,ItmID)) q:ItmID=""  d
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmID)
	.s ScgType=$p(ScgInfo,"^",3)
	.q:ScgType'="M"
	.
	.s dah=$o(^DHCLOCTOT(0,"LOCITMDATE",LocID,ItmID,""),-1)
	.q:dah=""
	.s dayID=$o(^DHCLOCTOT(0,"LOCITMDATE",LocID,ItmID,dah,""),-1)
	.q:dayID=""
	.s $p(^DHCLOCTOT(dayID),"^",4)=0
	
	s batID=""
	f  s batID=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID)) q:batID=""  d
	.s ItmID=$p(batID,"||",1)
	.q:ItmID=""
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmID)
	.s ScgType=$p(ScgInfo,"^",3)
	.q:ScgType'="M"
	.
	.s dah=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID,""),-1)
	.q:dah=""
	.s dayID=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID,dah,""),-1)
	.q:dayID=""
	.s btSub=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID,dah,dayID,""),-1)
	.q:btSub=""
	.s $p(^DHCBTLOCTOT(dayID,"I",btSub),"^",3)=0
	q
}

/// 清某科室数据(库存,业务)  
/// Input:科室rowid,  清除标识: killflag - 0 如果维护了货位,标准库存数,最大量,最小量等，killflag - 1 ,货位等均未维护
ClassMethod ClearLocBusinessData(locdr)
{
	N (locdr)
	Q:locdr="" 0

	//注意：以下的请求和转移，仅考虑了科室作为供应方的情况
	&sql(delete from dhc_inreqitm where  INRQI_INRQI_DR->inrqi_inrq_parref->inrq_reqloc_dr=:locdr)
	&sql(delete FROM dhc_inrequest WHERE INRQ_INRQ_DR->inrq_reqloc_dr=:locdr)
	&SQL(Delete From IN_Request Where INRQ_ReqLoc_DR=:locdr)
	W "请领-"_SQLCODE,!

	&SQL(Delete from DHC_InIsTrf Where INIT_FrLoc_DR=:locdr)
	W "出库-"_SQLCODE,!

	&SQL(Delete from DHC_InGdRet Where INGRT_CTLOC_DR=:locdr)
	W "退货-"_SQLCODE,! 

	&sql(Delete from DHC_INGdRecItmAddionInfo where INGRINFO_DR->INGRI_INGR_ParRef->INGR_Loc_DR=:locdr )
	&SQL(Delete from DHC_InGdRec Where INGR_Loc_Dr=:locdr)
	W "入库-"_SQLCODE,!

	&sql(delete from DHC_INPO where PO_CTLOC_DR=:locdr)
	#; &SQL(Delete From IN_POItm Where INPOI_CTLOC_DR=:locdr)
	&sql( DELETE FROM IN_PO WHERE IN_PO IN (SELECT DISTINCT IN_PO FROM IN_POItm WHERE INPOI_CTLOC_DR=:locdr ))
	W "订单-"_SQLCODE,!

	&SQL(Delete From IN_PurPlan Where INPP_CTLOC_DR=:locdr)
	W "采购-"_SQLCODE,!

	&SQL(Delete From DHC_INAdj Where INAD_CTLOC_DR=:locdr)
	W "调整-"_SQLCODE,!

	&SQL(Delete From dhc_indisp Where inds_ctloc_dr=:locdr)
	W "发放-"_SQLCODE,! 

	&SQL(Delete From dhc_inscrap Where INSCP_CTLOC_DR=:locdr)
	w "报损-"_SQLCODE,! 

	&sql(Delete From DHC_PayMon where pm_ctloc_dr=:locdr)
	&SQL(Delete From DHC_Pay Where PAY_CTLOC_DR=:locdr)
	W "付款-"_SQLCODE,!

	&sql(delete from dhc_stkmonstatin_m where  smrdi_smr_dr->smr_sm_parref->dhcsm_ctloc_dr=:locdr)
	&sql(delete From dhc_stkmonstat_m where smrd_smr_dr->smr_sm_parref->dhcsm_ctloc_dr=:locdr)
	&sql(delete From DHC_StkMon_VoucherStatus where VCH_SM_DR->DHCSM_CTLOC_DR=:locdr)
	&sql(delete From DHC_StkMonSumIn_CatGrp where SUMCG_SM_DR->DHCSM_CTLOC_DR=:locdr) 
	&sql(delete From DHC_StkMonSum_TransLoc where SUMTL_SM_DR->DHCSM_CTLOC_DR=:locdr)

	;
	&SQL(Delete From DHC_StkMon Where DHCSM_CTLOC_DR=:locdr)
	W "月报-"_SQLCODE,!

	&SQL(Delete From DHC_InStkTk Where INST_CTLOC_DR=:locdr)
	W "盘点-"_SQLCODE,!

	&sql(Delete From DHC_MatDisp where DISP_CTLOC_DR=:locdr)
	W "材料发放记录-"_SQLCODE,!

	&sql(Delete From DHC_MatDispRet where RET_CTLOC_DR=:locdr)
	W "材料发放退回记录-"_SQLCODE,!

	W !,"ALL-OK"
	Q 0
}

/// 清除耗材的库存项字典数据, 使用前提是:已经清楚了业务数据和库存数据
/// Input:		type(M-耗材)
/// d ##class(web.DHCSTMHUI.Tools.CodeClear).ClearIncItm()
ClassMethod ClearIncItm() As %String
{
	new
	s type="M"
	&sql(declare x1 cursor for select %id from inc_itm where inci_incsc_dr->incsc_stktype=:type)
	&sql(open x1)
	s ret=0
	f  &sql(fetch x1 into :rowid) q:SQLCODE!(ret<0)  d
	.ts
	.s ret=..DeleteInci(rowid)
	.i ret<0 tro  q
	.tc
	&sql(close x1)
	q ret
}

ClassMethod DeleteInci(rowid) As %String
{
	n (rowid)
	i rowid<0 q -100
	s ret=0
	&sql(delete from inc_alias where inca_inci_dr=:rowid)
	i SQLCODE<0 s ret=-1
	i ret<0 q ret
	
	&sql(delete from in_adjsaleprice where inasp_inci_dr=:rowid)
	i SQLCODE<0 s ret=-2
	i ret<0 q ret
	
	s isc=""  
	&sql(select info_isc_dr into :isc from dhc_itmaddioninfo where info_inci_dr=:rowid)
	i isc'=""  d
	.&sql(DELETE FROM dhc_itmstorecond WHERE ISC_RowID=:isc)
	.i SQLCODE<0 s ret=-3
	i ret<0 q ret
	
	&sql(delete FROM dhc_itmremark WHERE ir_inci_dr=:rowid)
	i SQLCODE<0 s ret=-4
	i ret<0 q ret
	
	&sql(delete from dhc_itmaddioninfo where info_inci_dr=:rowid)
	i SQLCODE<0 s ret=-5
	i ret<0 q ret
	
	&sql(delete from inc_itm where inci_rowid=:rowid)
	i SQLCODE<0 s ret=-6
	i ret<0 q ret
	
	q ret
}

/// Description: 多院区 - 同时删除平台数据
ClassMethod DeleteBDPMappingHosp(tableName)
{
	&SQL(DELETE FROM BDP_MappingHosp WHERE BDPMPH_TableName=:tableName)
	q SQLCODE
}

}
