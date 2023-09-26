Import sqluser

Class web.DHCSTMHUI.Tools.CreateAppPara Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 2014-12-22: 参数设置界面添加调用, 修改时注意!
/// w ##class(web.DHCSTMHUI.Tools.CreateAppPara).Prop()
ClassMethod Prop() As %String
{
	new
	d ##class(web.DHCSTMHUI.Tools.CreateApp).App()	;同步参数前,先补充应用

	k ^TMP("DHCSTM_PROP_ERR")
	
	;调价
	s PARAM($i(PARAM))=$lb("DHCSTADJSPM","DefaRp","默认调前进价取法","2","1-上次入库进价 2-当前进价(调价表) 3-招标进价")
	s PARAM($i(PARAM))=$lb("DHCSTADJSPM","CalSpByMarkType","是否根据定价类型计算售价","2", "1-是 2-否")
	s PARAM($i(PARAM))=$lb("DHCSTADJSPM","DefaAspReason","是否默认调价原因","Y","Y-新录行的调价原因默认为上一行的调价原因 N-不默认")
	s PARAM($i(PARAM))=$lb("DHCSTADJSPM","AllowAdjRp","是否可以调整进价","Y","N:否, 其他:是")
	s PARAM($i(PARAM))=$lb("DHCSTADJSPM","AllowAdjSp","是否可以调整售价","Y","N:否, 其他:是")
	s PARAM($i(PARAM))=$lb("DHCSTADJSPM","AllowSaveReasonEmpty","是否允许调价原因是否为空","N","Y允许为空,其他未不允许为空")
	//s PARAM($i(PARAM))=$lb("DHCSTADJSPM","ValidateMaxSp","验证最高售价","N","Y/N 调后售价超过最高售价时提示")

	;入库
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaStartDate","默认“查找”起始日期","-10","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaEndDate","默认“查找”截止日期","0","0-当天 -30-当天前推30天 10-当天后推10天")
	//s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaManf","默认厂家取法","2","1-上次入库厂家 2-当前厂家")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaRp","默认进价取法","2","1-上次入库进价 2-当前进价 3-招标进价")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaSp","售价取法","0","0-当前取法 1-根据定价类型计算入库售价 为空时视为0")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","NotBatDefaSp","统一售价下非收费材料售价取法","","0-取0，1-取进价 为空不判断收费标志")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaBatNo","默认批号取法","3","1-上次入库批号 2-自动生成批号 为空时默认批号是空")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaExpDate","默认有效期的取法","3","1-上次入库有效期 2-依据当前日期自动生成 3-依据生产日期自动生成 为空时默认有效期是空")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ExpDateValue","有效期长度","2","XX表示当前日期后XX年失效 自动生成有效期用")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","CheckInvNo","是否检查发票号;检查该发票号是否已经存在于其他入库单","Y","Y-检查 N-不检查 为空视为不检查")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ChkExpDateDays","效期提示天数","","提示的天数，当效期距今天数<该天数时，则提示；为空时不提示")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","MarginWarning","加价率超限提示范围","","当售价和进价比例超出一定范围时进行提示")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AllowAspWhileReceive","允许入库调价","N","Y/N 为空时视为“N”")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","PurchaserNotNull","采购员不可为空","N","Y/N 为空时视为“N”")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","MakeByPoOnly","入库受订单约束","N","Y/N 为空时视为“N”")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ValVendorQualification","验证供应商资质信息","Y","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ValVendorPb","验证供应商中标信息","Y","Y/N")
	//s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ValidateMaxSp","验证最高售价","N","Y/N 当前售价超过最高售价时提示")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaItmVendor","取默认供应商","1","1-最后一次入库供应商 其它-招标供应商")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ImpTypeNotNull","入库类型不可为空","Y","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AutoPrintAfterSave","入库单保存后自动打印","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AutoPrintAfterAudit","入库单审核后自动打印","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AutoAuditAfterComp","完成后自动审核","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaInvNo","默认上一行发票号","N","Y-默认 其他-不默认")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","RecQtyExceedOrderAllowed","入库数量允许高于订单","Y","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AutoTransAfterAudit","审核时候自动出库(存在出库科室)","Y","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DoubleAudit","需要多级审核的类组","","类组id前后以*间隔如*8*，缺省值为空的时候全部不需要验收")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","PbVendorFilter","入库时是否按照供应商过滤","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","InvNoNotNull","发票号不能为空提示","N","Y:进行提示，其他：不提示")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","Allowflash","完成后是否刷新","1","缺省刷新")
	//s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ManfNotNull","入库时生产厂家是否可以为空","Y","Y,可以为空;N不可以为空")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AutoCompAfterSaveIN","入库时保存后自动完成","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","CompareNamePrice","是否与上次入库物资名称和进价进行比较","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","PrintNoComplete","是否允许打印未完成的入库单","Y","设置为Y时,保存后即可打印")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","PrintNum","入库单单次打印份数","1","数字,缺省为1")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","ConfirmBeforeAudit","审核前提示","","Y:提示,其他:不提示")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","UpdItmCertByRec","依据入库明细中注册证信息维护档案中的注册证信息（入库审核时）","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","IndirPrint","是否预览打印","","Y/N Y预览打印，N直接打印，为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","NewSpAsSp","批次价格下入库售价作为售价","N","Y/N Y是，N否，为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","RequiredSourceOfFund","资金来源是否必选项","N","Y-必选,N-可选可不选")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","DefaUom","单位默认值","0","0-入库单位,1-基本单位")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","UseAllUserAsPur","使用全院人员作为采购人员","N","Y:是,其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","InsertSpecListAfterAudit","入库审核插入具体规格","Y","Y:插入具体规格,其他:不插入")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AllowEditRp","是否允许修改进价","Y","Y:允许,其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","AllowEditRpAmt","允许修改进价金额,自动计算进价","N","Y:允许,其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTIMPORTM","UpdateVendor","入库单保存后是否允许修改供应商","N","Y:允许,其他:不允许")

	;付款
	s PARAM($i(PARAM))=$lb("DHCSTPAYM","ApprovalFlag","是否需要审批再付款","0","0-不需要 1-需要")
	s PARAM($i(PARAM))=$lb("DHCSTPAYM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTPAYM","RecPayTrans","记录付款台账的环节,只能选择其中一种","1","1.发票确认界面; 2.付款审批界面")

	;订单
	s PARAM($i(PARAM))=$lb("DHCSTPOM","DefaManf","生产厂家默认值","2","1-上次入库生产厂家 2-当前生产厂家")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","DefaRp","进价","2","1- 上次入库进价 2-当前进价 3-招标进价")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","PoByLoc","是否按申请科室拆分订单","N","N-不拆分 Y拆分")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","AutoAduit","是否自动审批","Y","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","NeedDays","要求到货日期默认为几天后","2","天数(整数)")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","PoByProLoc","是否按供应科室拆分订单，只有PoByLoc为N时起作用","N","N-不拆分 Y拆分，为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","AutoGenerateIngr","验收自动生成入库单","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","DefaUom","制单单位默认值","0","0-入库单位,1-基本单位")
	s PARAM($i(PARAM))=$lb("DHCSTPOM","VendorFilter","订单录入时是否按招标供应商过滤","Y","Y/N")
	;采购计划
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","DefaItmVendor","供应商默认值","2","1-最后一次入库供应商 其它-招标供应商")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","DefaManf","生产厂家默认值","2","1-上次入库厂家 2-当前厂家")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","DefaRp","进价","2","1-上次入库进价 2-当前进价 3-招标进价")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","RpNotNull","进价不可为空","Y","Y-不可为空")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","DefaItmCarrier","默认库存项配送商","2","1-上次采购配送商 2-招标配送商")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","AutoAuditAfterCompleted","自动审批","N","Y-采购单完成时自动审批 为空时视为“N”")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","DefaStartDate","默认“查找”起始日期","-30","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","DefaEndDate","默认“查找”截止日期","0","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","TrfQty","根据请求生成采购计划时，是否减去已转移数量","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","AvaQty","根据请求生成采购计划时，是否减去可用库存","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","VendorNeeded","供应商是否必填","Y","Y/N Y必填，N非必填，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","AutoSendToSci","采购审核自动发送订单到平台","N","Y/N Y发送，N不发送，为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTPURPLANAUDITM","DefaUom","制单单位默认值","0","0-入库单位,1-基本单位")
	;退货
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","DefStartDate","默认“查找”起始日期","-30","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","DefEndDate","默认“查找”截止日期","0","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","PrintNegative","打印显示“负值”","Y","")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","AutoCompAfterSaveDRET","退货时保存自动完成","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","AutoAuditAfterCompDRET","退货时完成自动审核","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","AutoPrintAfterAuditDRET","退货时审核后自动打印","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","AutoPrintAfterSaveDRET","退货时保存后自动打印","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","PrintNum","退货单单次打印份数","1","数字,缺省为1")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	;s PARAM($i(PARAM))=$lb("DHCSTRETURNM","CreateInitByIngRet","根据退货单生成出库单","N","Y/N Y生成，N不生成，为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","DefaRetReason","是否默认退货原因","Y","Y-新录行的退货原因默认为上一行的退货原因 N-不默认")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","AllowSaveReasonEmpty","允许退货原因为空","N","Y-退货原因可以为空，其他不允许为空")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","AllowReturnElse","(针对高值条码)是否允许操作其他库房入库的物资","N","Y/N, 缺省为N")
	s PARAM($i(PARAM))=$lb("DHCSTRETURNM","PrintNoAudit","是否允许打印未审核的退货单","N","Y/N 为空视为N")

	;库存请求
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","RecLocAuditRequired","请求单需要请求方审核","N","Y/N,不为Y时自动审核,根据科室,全院设置")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","ProvLocAuditRequired","请求单需要供应方审核","N","Y/N,不为Y时自动审核,根据科室,全院设置")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","DefaStartDate","请求单请求方审核“查找”起始日期","-30","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","DefaEndDate","请求单请求方审核“查找”截止日期","0","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","IsSplit","是否启动请求单分流功能","N","")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","NoScgLimit","单据不控制类组","N","设置为Y时,出库制单根据类组拆分")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","PrintNoComplete","是否允许打印未完成的请求单","Y","设置为Y时,保存后请求单即可打印")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","IsRequestNoStock","是否允许未入库的物资制请求单","N","设置为Y时,未入库的物资也可制请求单")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","IfRequestMoreThanStock","当请求数量大于供方库存是否允许制单","Y","Y允许,否则不允许")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","ReqLocUseLinkLoc","请求科室是否使用其关联科室","N","Y允许,否则不允许")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","IfAllowReqBQtyUsed","是否允许使用库房请领基数控制","N","Y:是;否则不使用")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","SetReserverdQty","供应方是否设置在途(按科室或全院配置)","N","Y:设置;否则不设置")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","QtyFlag","被请领物资库存需大于0(按库房判断)","Y","Y允许,否则不允许(若IsRequestNoStock为'Y',此项默认为'N')")
	s PARAM($i(PARAM))=$lb("DHCSTINREQM","DefaUom","制单默认单位","0","0:入库单位；1:基本单位")

	;库存转移
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","DefaStartDate","默认“查找”起始日期","-30","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","DefaEndDate","默认“查找”截止日期","0","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoAckOutAfterCompleted","“完成”后自动出库审核","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoAckInAfterAckOut","出库审核时自动入库审核（针对接收科室配置）","Y","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoPrintAfterSave","保存后自动打印库存转移单","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoPrintAfterAckOut","出库审核后自动打印库存转移单","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoPrintAfterAckIn","入库审核后自动打印库存转移单","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoLoadRequest","启动制单时自动调出待出库请求单","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","RequestNeeded","库存转移是否必须依据请求单，为空时视为“N”","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","SeekBatMethod","转移批次自动匹配算法","0","0-效期先后 1-先进先出")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoCompAfterSaveOUT","库存转移时保存自动完成","N","Y/N 为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","PrintNoComplete","是否允许打印未完成的转移单","Y","设置为Y时,保存后请求单即可打印")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","PrintNum","出库单单次打印重复份数","1","数字, 缺省为1")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","ConfirmBeforeAudit","是否弹出审核该出库单的提示","Y","Y:提示, 其他:不提示")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","LogicalDelete","逻辑删除(仅将未完成且未打印的单据直接删除,其他按作废处理)","Y","Y:逻辑删除, 其他:物理删除(按全院或科室设置)") 
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","OutTypeNotNull","出库类型不可为空","N","Y:不可为空, 其他:可为空")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoPrintAfterComp","出库完成时自动打印","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","IfMergeReq","是否将同一个科室多个请求单合并在一个出库单","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","UseLocLimitAmt","是否启用科室控额","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","SplitReqScgMode","根据请求单出库时按类组拆单的模式","","1:按底层类组,0:按顶层类组,其他:不拆分")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","HVReqScanInit","高值申请单扫码制单","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","ConfirmCompAfterSave","保存后是否提示完成操作","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AutoAckInByOut","出库审核时自动入库审核（针对出库方配置）","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","SetStatBUom","汇总报表是否默认基本单位(控制出库汇总界面)","N","Y:是,其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","CrossMonInAuditNo","跨月(自然月)不允许拒绝接收","Y","Y:是,其他:否(按库房配置)")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","AllowExpDateOut","过期批次是否允许出库","Y","Y:允许,其他:不允许")
	s PARAM($i(PARAM))=$lb("DHCSTTRANSFERM","DefaReturnLoc","科室取值(退库制单，退库制单(高值)，退库单查询)","0","0:库房,1:临床科室")

	;物资信息维护
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","SameCode","物资信息（库存项，医嘱项）维护代码一致","Y","Y-一致 N-可以不一致")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","SameDesc","物资信息（库存项，医嘱项）维护名称一致","Y","Y-一致 N-可以不一致")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoCodeLengthOfSerialNo","自动生成代码流水号位数","3","数值")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","SetInitStatusNotUse","新建药品为“不可用”状","N","Y-新建药品默认为不可用 N-根据界面值")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoSetArcimEffDateto","设置库存项“不可用”时：自动设置医嘱项目截止日期","Y","Y-设置为当天 N-不设置")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddAAByIA","维护库存项别名时：自动维护医嘱项别名","Y","Y-使用库存项别名 N-不维护")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddIAByAA","维护医嘱项别名时：自动维护库存项别名","Y","Y-使用医嘱项别名 N-不维护")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddIAByDesc","库存项新建时:自动生成库存项别名","Y","Y-依据库存项描述拼音首字母 N-不生成")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddAAByDesc","医嘱项新建时:自动生成医嘱项别名","Y","Y-依据医嘱项描述拼音首字母 N-不生成")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddIAByCode","库存项新建时:自动生成库存项别名(代码)","Y","Y-依据代码生成别名")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddAAByCode","医嘱项新建时:自动生成医嘱项别名(代码)","Y","Y-依据代码生成别名")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","ItmQueryDefaRp","物资查询进价显示设置","2","1-上次入库进价2-当前进价3-招标进价")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","ScMap","根据配置生成医嘱项计费项","N","Y:是（按库存分类）,G:按高值标志,其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoCreateIncCode","自动生成库存项代码","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddIncAliasWB","自动按名称生成库存项五笔码别名","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddIncAliasXieHe","自动按协和码生成库存项别名","N","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","UpdateTarFollowArc","修改医嘱项是否同时修改收费项代码名称","Y","Y:是, 其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","INCIBatchReq","库存项批号要求","O","R:要求,N:不要求,O:随意,其他按R处理")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","INCIExpReq","库存项效期要求","O","R:要求,N:不要求,O:随意,其他按R处理")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","ArcimDescAutoMode","医嘱项名称自动生成模式","0","0:医嘱项名称库存项名称；1:医嘱项名称库存项名称+规格；2:医嘱项名称库存项名称+规格+型号")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddTAByAA","医嘱项别名增加时:自动生成收费项别名","Y","Y-是,其他-否")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoSetArcimNotUse","设置库存项“不可用”时:自动设置医嘱项不可用","N","Y-设置(收费标志,独立医嘱,无库存医嘱),N-不设置")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","AutoAddIARegItmDesc","库存项新建时:自动生成注册证名称别名","Y","Y-依据注册证名称拼音首字母 N-不生成")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","ModifyBillCode","收费项代码名称是否可修改", "N", "默认值为医嘱项代码名称;Y-可修改收费项代码名称,N-不可修改")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","NeedAudit","物资修改新增审核","","1:新增需要审核;2:修改需要审核;其他不需要审核(多个则逗号隔开)")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","UseSpecList","是否使用具体规格",  "Y","Y:是,其他:否")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","CancelArcimSetArcimEffDateTo","取消医嘱项关联自动设置医嘱项截止日期,重新关联置空","N","Y-设置医嘱项截止日期为当天,N-不设置")
	s PARAM($i(PARAM))=$lb("DHCSTDRUGMAINTAINM","NotAllowUpdateIncsc","库存项开始使用后不允许修改库存分类",  "Y","Y:不允许修改,其他:允许修改")
	;公共
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","FmtRP","进价小数位数（入库单位）","0.00","2位：0.00，3位：0.000")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","FmtPP","批价小数位数（入库单位）","0.00","2位：0.00，3位：0.000")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","FmtSP","售价小数位数（入库单位）","0.00","2位：0.00，3位：0.000")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","FmtRA","进价金额小数位数","0.00","2位：0.00，3位：0.000")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","FmtPA","批价金额小数位数","0.00","2位：0.00，3位：0.000")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","FmtSA","售价金额小数位数","0.00","2位：0.00，3位：0.000")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","FmtQTY","数量小数位数","0.00","2位：0.00，3位：0.000")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","ApcScg","供应商下拉框取值范围","","全部:空;按类组授权:S;按科室授权:L;")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","ManfScg","生产厂家下拉框按类组授权取值","N","Y/N, 缺省为N, 尽量按全院设置")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","BatSp","批次售价","0","0/1/2；0-统一售价:进价取批次表,售价取统一调价表；1-批次售价:进价/售价都取批次调价表；2-统一进/售价：进价/售价都取统一调价表,同步批次表进价")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","BatSpHV","高值批次售价","0","0/1/2；0-统一售价:进价取批次表,售价取统一调价表；1-批次售价:进价/售价都取批次调价表；2-统一进/售价：进价/售价都取统一调价表,同步批次表进价")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","StopItmDate","自动停用物资的日期天数","30","")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","StopApcDate","自动停用供应商的日期天数","30","")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","AllowEnterSpec","是否允许输入具体规格","Y","Y/N, 缺省为N")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","SelBatRule","批次价格发放顺序","1","1/0, 1效期优先，0先进先出")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","IfPortal","是否和protal相关","N","Y/N, Y相关，N不相关")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","GetLocDesc","取科室名称","0","0科室全称，1取“-”前部分，2取“-”后部分")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","UseIMedicalDate","使用iMedical日期格式","Y","Y/N, 缺省为N (仅支持院区以上级别设置)") 
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","GridColSetPer","是否有权限进行列设置！","Y","Y/N, 缺省为Y,Y 有权限 N无权限")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","PageElementAuthor","页面元素授权","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","ShowAllHospFlag","所有院区科室标志","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","IfSelFirstRow","业务界面查询后是否默认选择第一行","Y","Y/N, 缺省为Y,Y 默认选择 N默认不选择")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","SunPurPlan","阳光采购启用省份或者地区","","如:四川省、深圳市等")
	s PARAM($i(PARAM))=$lb("DHCSTCOMMONM","CarrierRange","配送商下拉框取值范围","","全部:空;按科室授权:L;")
	;高值跟踪
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","UseItmTrack","是否使用高值跟踪","Y","Y-使用 N或空-不使用")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","DefaStartDate","默认<查找>开始日期","-30","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","DefaEndDate","默认<查找>结束日期","0","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","CreBarByIngdrec","高值耗材入库自动产生高值条码","N","Y-使用 N或空-不使用")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","UseRet","是否进行高值退货验收","N","Y-使用 N或空-不使用")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","DeleteWhileOeoriOver","(按全院或科室设置)停医嘱时是否删除补录信息","N","Y-删除; 其他:不删除")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","DispAutoRecHV","高值减库存是否自动生成入库单","N","Y/N Y-是；N-否，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","RecAdmLoc","高值自动出库接收科室取法","0","0-医嘱接收科室;1-病人就诊科室;2-医嘱录入科室;3-病人所在科室;其他视为0")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","DefaRecLoc","高值条码临时业务的入库科室(描述)","","高值条码生成(紧急业务)使用")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","VendorNeeded","高值条码生成供应商是否必填","Y","Y-必填 N-非必填")
	s PARAM($i(PARAM))=$lb("DHCITMTRACKM","IfRecVenManfEdit","高值入库控制供应商是否可以修改","Y","Y-是,N-否")
	s PARAM($i(PARAM))=$lb( "DHCITMTRACKM","AutoVirFlag","暂存库标志是否自动勾选","N","Y:是,其他:否")
	s PARAM($i(PARAM))=$lb( "DHCITMTRACKM","HiddenOrigiBarCode","是否隐藏自带条码","Y","Y-隐藏 其他-不隐藏")
	;文件ftp上传
	s PARAM($i(PARAM))=$lb("DHCSTFTPFILEM","FtpIp","服务器Ip","","")
	s PARAM($i(PARAM))=$lb("DHCSTFTPFILEM","FtpUser","服务器用户名","","")
	s PARAM($i(PARAM))=$lb("DHCSTFTPFILEM","FtpPassword","服务器用户密码","","")
	s PARAM($i(PARAM))=$lb("DHCSTFTPFILEM","FtpPicSrc","Ftp存放图片目录","","")
	s PARAM($i(PARAM))=$lb("DHCSTFTPFILEM","FtpPort","Ftp端口","","")
	s PARAM($i(PARAM))=$lb("DHCSTFTPFILEM","FtpHttpSrc","Ftp文件夹的HTTP访问路径","","")
	s PARAM($i(PARAM))=$lb("DHCSTFTPFILEM","FtpSSL","FtpSSL配置","FTPS","FTP或FTPS")

	;窗口小贴士
	s PARAM($i(PARAM))=$lb("DHCSTTIPSWIN","Minutes","定时刷新间隔","10","分钟数")
	s PARAM($i(PARAM))=$lb("DHCSTTIPSWIN","VendorQualification","供应商资质报警","Y","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTIPSWIN","ManfQualification","生产厂家资质报警","Y","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTTIPSWIN","QualificationDate","报警提示天数","30","离到期多少天就提示")
	s PARAM($i(PARAM))=$lb("DHCSTTIPSWIN","CertQualification","物资注册证报警","Y","Y/N") 

	;批次调价
	s PARAM($i(PARAM))=$lb("DHCSTADJSPBATCHM","DefaRp","默认调前进价取法","2","1-上次入库进价 2-当前进价(调价表) 3-招标进价")
	s PARAM($i(PARAM))=$lb("DHCSTADJSPBATCHM","CalSpByMarkType","是否根据定价类型计算售价","2","1-是 2-否")
	s PARAM($i(PARAM))=$lb("DHCSTADJSPBATCHM","DefaAspReason","是否默认调价原因","Y","Y-新录行的调价原因默认为上一行的调价原因 N-不默认")

	;供应商管理
	s PARAM($i(PARAM))=$lb("DHCSTVENDORMTM","CodeAlphaUp","代码自动大写处理","","1：是，0或空：否")
	s PARAM($i(PARAM))=$lb("DHCSTVENDORMTM","NameAlphaUp","名称自动大写处理","","1：是，0或空：否")

	;盘点帐盘
	s PARAM($i(PARAM))=$lb("DHCSTINSTKTKM","StkQtyNotZero","生成盘点单时批次数量不为0","N","Y/N,Y表示批次数量不为0，N表位数量为0也生成盘点单,为空视为N")
	s PARAM($i(PARAM))=$lb("DHCSTINSTKTKM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTINSTKTKM","NoFreezeZeroWhilePrint","打印时过滤冻结零库存","N","Y:过滤, 其他:不过滤")
	s PARAM($i(PARAM))=$lb("DHCSTINSTKTKM","AllLoc","是否允许盘点所有科室","N","Y/N Y可以盘点全部科室，其他只能盘点授权科室")
	s PARAM($i(PARAM))=$lb("DHCSTINSTKTKM","AllowBusiness","是否允许盘点期间发生业务","Y","Y/N Y允许，其他不允许")

	;库存调整
	s PARAM($i(PARAM))=$lb("DHCSTSTOCKADJM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTSTOCKADJM","AllowAdjAllLoc","是否允许调整所有科室","","Y/N Y可以调整全部科室，其他为授权科室")

	;库存报损
	s PARAM($i(PARAM))=$lb("DHCSTINSCRAPM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTINSCRAPM","AllowSrapAllLoc","是否允许报损所有科室","","Y/N Y可以报损全部科室，其他为授权科室")
	s PARAM($i(PARAM))=$lb("DHCSTINSCRAPM","SelScrapIfLocEmpty","(库存报损统计)科室为空时是否可以查询","N","Y/N Y可以查询全院科室，为空时将不能查询")

	;二级库物资请领
	s PARAM($i(PARAM))=$lb("DHCINDISPREQM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")

	;二级库物资退回
	s PARAM($i(PARAM))=$lb("DHCSTINDISPRETM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTINDISPRETM","AutoCompAfterSave","保存后自动完成","N","Y/N, 缺省为N")
	s PARAM($i(PARAM))=$lb("DHCSTINDISPRETM","AutoAuditAfterComp","完成后自动审核退回","N","Y/N, 缺省为N")

	;二级库物资发放
	s PARAM($i(PARAM))=$lb("DHCSTINDISPM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")
	s PARAM($i(PARAM))=$lb("DHCSTINDISPM","AllowChargeMat","是否允许收费耗材进行发放","N","Y/N Y允许，N不允许 为空默认N")
	s PARAM($i(PARAM))=$lb("DHCSTINDISPM","AutoCompAfterSave","保存后自动完成","N","Y/N, 缺省为N")
	s PARAM($i(PARAM))=$lb("DHCSTINDISPM","AutoAckDispAfterCompleted","完成后自动审核发放","N","Y/N")
	s PARAM($i(PARAM))=$lb("DHCSTINDISPM","AllowCrossLoc","是否允许跨科室发放","N","Y/N Y允许，N不允许 为空默认N")

	;被服类管理
	s PARAM($i(PARAM))=$lb("DHCSTBCM","IndirPrint","是否预览打印","Y","Y/N Y预览打印，N直接打印，为空视为Y")

	;物资门诊发放
	s PARAM($i(PARAM))=$lb("DHCSTMATDISPM","MatDisp","普通物资是否走门诊发放","N","Y/N 为空视为N")
	;s PARAM($i(PARAM))=$lb("DHCSTMATDISPM","HVMatDisp","高值物资是否走门诊发放","N","Y/N 为空视为N")

	;高值医嘱提取
	s PARAM($i(PARAM))=$lb("HVMatOrdItm","IfAutoAuditRecInit","提取高值医嘱是否自动审核入库单(审核入库单自动生成出库单)","Y","Y:自动审核;否则不自动审核")
	s PARAM($i(PARAM))=$lb("HVMatOrdItm","IfHavePermCancel","是否有权限取消补录","N","Y:有权限,否则无")
	s PARAM($i(PARAM))=$lb("HVMatOrdItm","IfPreAudit","医嘱补录是否进行预审","N","Y:是,N:否")
	s PARAM($i(PARAM))=$lb("HVMatOrdItm","IfReapricale","医嘱补录时进价取值方式","1","1:计费时调价表进价,2:暂存库入库进价,3:调价表最新进价")

	;发票组合
	s PARAM($i(PARAM))=$lb("DHCSTVendorINVM","DefaStartDate","默认“查找”起始日期","-30","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTVendorINVM","DefaEndDate","默认“查找”截止日期","0","0-当天 -30-当天前推30天 10-当天后推10天")

	;试剂Lis接口
	s PARAM($i(PARAM))=$lb("DHCSTMSERFORLISM","CreateInitBarCode","出库时,根据接收科室判断是否需有生成试剂条码","","Y:是, 其他:否")

	;物资门诊退回
	s PARAM($i(PARAM))=$lb("DHCSTMATDISPRETM","AllowRetByNoReq","是否允许未申请进行退回","N","Y/N Y允许，N不允许 为空默认N")

	;物资住院发放
	s PARAM($i(PARAM))=$lb("DHCSTINMATDISPM","InMatDisp","普通物资是否走住院发放","N","Y/N 为空视为N")
	
	;红冲
	s PARAM($i(PARAM))=$lb("DHCSTMREDOFFSET","DefaStartDate","默认“查找”起始日期","-10","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTMREDOFFSET","DefaEndDate","默认“查找”截止日期","0","0-当天 -30-当天前推30天 10-当天后推10天")
	s PARAM($i(PARAM))=$lb("DHCSTMREDOFFSET","AutoCompAfterSave","保存后自动完成","N","Y/N 为空视为N")
	s cnt=0,addcnt=0,updcnt=0
	s i=0
	f  s i=$o(PARAM(i)) q:i=""  d
	.s cnt=cnt+1
	.s lbdata=PARAM(i)
	.s appname=$list(lbdata,1)
	.s code=$list(lbdata,2)
	.s desc=$list(lbdata,3)
	.s v=$list(lbdata,4)
	.s memo=$list(lbdata,5)
	.s prop=..getpar2(appname,code)
	.s propValue=""
	.s:prop'="" propValue=$p(^DHCSSA(+prop,"AP",$p(prop,"||",2)),"^",3)
	.q:propValue'=""				;如参数缺省值已存在,不再处理
	.;参数不存在的导入参数, 参数存在但缺省值为空的进行update(全院设置的pf优先)
	.i prop="" d
	..s par=..getpar(appname)
	..s ch=..getch(par)
	..&sql(insert into DHC_StkSysAProp (ssap_ssa_parref,ssap_childsub,ssap_code,ssap_desc,ssap_value,ssap_memo) values (:par,:ch,:code,:desc,:v,:memo))
	..i SQLCODE'=0 d
	...s x=$O(^TMP("DHCSTM_PROP_ERR",""),-1)+1
	...s ^TMP("DHCSTM_PROP_ERR",x)=code_"^"_desc
	..e  d
	...s addcnt=addcnt+1
	.e  d
	..s PFValue=""
	..&sql(select PF_Value into :PFValue from dhc_stksysaproppref where PF_SSAP_ParRef=:prop and PF_Type='D')
	..s:PFValue'="" v=PFValue		;若已经有全院级别的设置,按此值进行
	..q:v=""						;计算后v仍为空的,不处理
	..&sql(update DHC_StkSysAProp set ssap_value=:v where %id=:prop)
	..i SQLCODE'=0 d
	...s x=$O(^TMP("DHCSTM_PROP_ERR",""),-1)+1
	...s ^TMP("DHCSTM_PROP_ERR",x)=code_"^"_desc
	..e  d
	...s updcnt=updcnt+1
	q addcnt_"^"_updcnt_"^"_cnt
}

ClassMethod getpar(appname As %String) As %String
{
	n (appname)
	s rowid=""
	&sql(select %id into :rowid from dhc_stksysapp where ssa_code=:appname)  
	q rowid
}

ClassMethod getch(parref)
{
	n (parref)
	q:parref="" ""
	s ch=$o(^DHCSSA(parref,"AP",""),-1)+1
	q ch
}

ClassMethod getpar2(appname As %String, pname As %String) As %String
{
	n (appname,pname)
	s rowid=""
	&sql(select %id into :rowid from DHC_StkSysAProp where ssap_ssa_parref->ssa_code=:appname and ssap_code=:pname)  
	q rowid
}

ClassMethod getch2(parref)
{
	n (parref)
	q:parref="" ""
	s par=$p(parref,"||",1)
	s ch=$p(parref,"||",2)
	s pfch=$o(^DHCSSA(par,"AP",ch,"PF",""),-1)+1
	q pfch
}

/// 返回值 空:未设置参数值, 其他:已设置参数值
ClassMethod getPF(appname As %String, pname As %String) As %String
{
	n (appname,pname)
	s rowid=""
	&sql(select %id into :rowid from DHC_StkSysAPropPref
		where pf_ssap_parref->ssap_ssa_parref->ssa_code=:appname
			and pf_ssap_parref->ssap_code=:pname)  
	q rowid
}

/// w ##class(web.DHCSTMHUI.Tools.CreateAppPara).ProCounter()
ClassMethod ProCounter(HospStr = "")
{
	n (HospStr)
	
	d ##class(web.DHCSTMHUI.Tools.CreateApp).App()	;同步参数前,先补充应用
	
	k ^TMP("DHCSTM_PROCounter_ERR")
	//appname,ssc_hosp,ssc_loc,ssc_catgrp,ssc_prefix,ssc_year,ssc_month,ssc_day,ssc_nolength,ssc_desc,ssc_suffix
	;调价M
	s APPINFO($i(APPINFO))=$lb("DHCSTADJSPM","N","N","N","MASP","Y","Y","Y",3,"","")
	;入库M
	s APPINFO($i(APPINFO))=$lb("DHCSTIMPORTM","N","N","N","MIP","Y","Y","Y",3,"","")
	;盘点帐盘M
	s APPINFO($i(APPINFO))=$lb("DHCSTINSTKTKM","N","N","N","MST","Y","Y","Y",3,"","")
	;付款M
	s APPINFO($i(APPINFO))=$lb("DHCSTPAYM","N","N","N","MPAY","Y","Y","Y",3,"","")
	;订单M
	s APPINFO($i(APPINFO))=$lb("DHCSTPOM","N","N","N","MPO","Y","Y","Y",3,"","")
	;采购计划M
	s APPINFO($i(APPINFO))=$lb("DHCSTPURPLANAUDITM","N","N","N","MPUR","Y","Y","Y",3,"","")
	;退货M
	s APPINFO($i(APPINFO))=$lb("DHCSTRETURNM","N","N","N","MPT","Y","Y","Y",3,"","")
	;库存调整M
	s APPINFO($i(APPINFO))=$lb("DHCSTSTOCKADJM","N","N","N","MADJ","Y","Y","Y",3,"","")
	;库存转移M
	s APPINFO($i(APPINFO))=$lb("DHCSTTRANSFERM","N","N","N","MTR","Y","Y","Y",3,"","")
	;库存转移请求M
	s APPINFO($i(APPINFO))=$lb("DHCSTINREQM","N","N","N","MREQ","Y","Y","Y",3,"","")
	;库存报损M
	s APPINFO($i(APPINFO))=$lb("DHCSTINSCRAPM","N","N","N","MSC","Y","Y","Y",3,"","")
	;物资维护M
	s APPINFO($i(APPINFO))=$lb("DHCSTDRUGMAINTAINM","N","N","N","MAIN","Y","Y","Y",3,"","")
	;应用程序语法M
	s APPINFO($i(APPINFO))=$lb("DHCSTPARAMERM","N","N","N","","Y","Y","Y",3,"","")
	;公共M
	s APPINFO($i(APPINFO))=$lb("DHCSTCOMMONM","N","N","N","","Y","Y","Y",3,"","")
	;虚拟入库M
	s APPINFO($i(APPINFO))=$lb("DHCSTVIRIMPORTM","N","N","N","MVIR","Y","Y","Y",3,"","")
	;高值跟踪M
	s APPINFO($i(APPINFO))=$lb("DHCITMTRACKM","N","N","N","MGZ","Y","Y","Y",3,"","")
	;高值医嘱提取
	s APPINFO($i(APPINFO))=$lb("HVMatOrdItm","N","N","N","","Y","Y","Y",3,"","")
	;二级库物资请领M
	s APPINFO($i(APPINFO))=$lb("DHCINDISPREQM","N","N","N","MDREQ","Y","Y","Y",3,"","")
	;二级库物资发放
	s APPINFO($i(APPINFO))=$lb("DHCSTINDISPM","N","N","N","MDISP","Y","Y","Y",3,"","")
	;二级库物资请退M
	s APPINFO($i(APPINFO))=$lb("DHCSTINDISPRETM","N","N","N","MDISPR","Y","Y","Y",3,"","")
	;专业组分配
	s APPINFO($i(APPINFO))=$lb("DHCSTSLGALLOTM","N","N","N","","Y","Y","Y",3,"","")
	;ftp上传配置M
	s APPINFO($i(APPINFO))=$lb("DHCSTFTPFILEM","N","N","N","","Y","Y","Y",3,"","")
	;发票组合M
	s APPINFO($i(APPINFO))=$lb("DHCSTVendorINVM","N","N","N","MVINV","Y","Y","Y",3,"","")
	;批次调价M
	s APPINFO($i(APPINFO))=$lb("DHCSTADJSPBATCHM","N","N","N","MASPB","Y","Y","Y",3,"","")
	;供应商
	s APPINFO($i(APPINFO))=$lb("DHCSTVENDORMTM","N","N","N","MVEN","Y","Y","Y",3,"","")
	;二级库快捷盘点M
	s APPINFO($i(APPINFO))=$lb("DHCSTSUBLOCSTKTKM","N","N","N","MPD","Y","Y","Y",3,"","")
	;月报M
	s APPINFO($i(APPINFO))=$lb("DHCSTKMONREPM","N","N","N","MON","Y","Y","Y",3,"","")
	;被服类管理M
	s APPINFO($i(APPINFO))=$lb("DHCSTBCM","N","N","N","","Y","Y","Y",3,"","")
	;付款月报M
	s APPINFO($i(APPINFO))=$lb("DHCSTMPAYMON","N","N","N","","Y","Y","Y",3,"","")
	;生产厂家管理M
	s APPINFO($i(APPINFO))=$lb("DHCSTPHMANFM","N","N","N","MPH","Y","Y","Y",3,"","")
	;物资门诊发放
	s APPINFO($i(APPINFO))=$lb("DHCSTMATDISPM","N","N","N","MDIS","Y","Y","Y",3,"","")
	;物资门诊退回
	s APPINFO($i(APPINFO))=$lb("DHCSTMATDISPRETM","N","N","N","MDISR","Y","Y","Y",3,"","")
	;新项申请
	s APPINFO($i(APPINFO))=$lb("DHCSTNEWITMM","N","N","N","MNEW","Y","Y","Y",3,"","")
	;付款封面
	s APPINFO($i(APPINFO))=$lb("DHCSTMRECCOVERM","N","N","N","MCOV","Y","Y","Y",3,"","")
	;报销支付单
	s APPINFO($i(APPINFO))=$lb("DHCSTMDHCREIMPAY","N","N","N","MREP","Y","Y","Y",3,"","")
	;高值点评
	s APPINFO($i(APPINFO))=$lb("DHCSTMCOMMENT","N","N","N","MCOM","Y","Y","Y",3,"","")
	;试剂Lis接口M
	s APPINFO($i(APPINFO))=$lb("DHCSTMSERFORLISM","N","N","N","","Y","Y","Y",3,"","")
	;住院发放
	s APPINFO($i(APPINFO))=$lb("DHCSTINMATDISPM","N","N","N","MIDS","Y","Y","Y",3,"","")
	;住院退回
	s APPINFO($i(APPINFO))=$lb("DHCSTINMATDISPRETM","N","N","N","MIDR","Y","Y","Y",3,"","")
	;红冲
	s APPINFO($i(APPINFO))=$lb("DHCSTMREDOFFSET","N","N","N","MRED","Y","Y","Y",3,"","")
	//appname,ssc_hosp,ssc_loc,ssc_catgrp,ssc_prefix,ssc_year,ssc_month,ssc_day,ssc_nolength,ssc_desc,ssc_suffix
	s cnt=0,addcnt=0,failcun=0
	s Len=$l(HospStr,"^")
	f j=1:1:Len d
	.s HospId=$p(HospStr,"^",j)
	.s i=0
	.f  s i=$o(APPINFO(i)) q:i=""  d
	..s cnt=cnt+1
	..s lbdata=APPINFO(i)
	..s appname=$list(lbdata,1)
	..s hosp=$list(lbdata,2)
	..s loc=$list(lbdata,3)
	..s catgrp=$list(lbdata,4)
	..s prefix=$list(lbdata,5)
	..s year=$list(lbdata,6)
	..s month=$list(lbdata,7)
	..s day=$list(lbdata,8)
	..s length=$list(lbdata,9)
	..s desc=$list(lbdata,10)
	..s suffix=$list(lbdata,11)
	..s parref=$o(^DHCSSA(0,"ACODE",$$ALPHAUP^SSUTIL4(appname),0))
	..s flag=..counterExists(parref,HospId)
	..i flag=0 d
	...s ch=..getch3(parref)
	...&sql(insert into DHC_StkSysCounter(SSC_SSA_Parref,SSC_ChildSub,ssc_hosp,ssc_loc,ssc_catgrp,ssc_prefix,
		ssc_year,ssc_month,ssc_day,ssc_nolength,ssc_desc,ssc_suffix) 
		values(:parref,:ch,:hosp,:loc,:catgrp,:prefix,:year,:month,:day,:length,:desc,:suffix))
	...i SQLCODE'=0 d
	....s x=$O(^TMP("DHCSTM_PROCounter_ERR",""),-1)+1
	....s ^TMP("DHCSTM_PROCounter_ERR",x)=appname_"^"_SQLCODE
	....s failcun=failcun+1
	...e  d
	....s addcnt=addcnt+1
	....s RowId=parref_"||"_ch
	....s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_StkSysCounter",RowId,HospId)
	....s:ret'=0 failcun=failcun+1
	q addcnt_"^"_cnt_"^"_failcun
}

/// 获得ChildSub值
ClassMethod getch3(parref)
{
	n (parref)
	q:parref="" ""
	s ch=$o(^DHCSSA(parref,"SSC",""),-1)+1
	q ch
}

/// 检查某应用是否已经配置stksyscounter
/// Arguments: 
/// par - 应用RowId
/// Return:
///   1- exists 
///   0 - not exist
///   w ##class(web.DHCSTMHUI.Tools.CreateApp).counterExists(106,2)
ClassMethod counterExists(par As %String, HospId = "") As %String
{
	n (par,HospId)
	s flag=0
	s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag()
	i HospAutFlag="N" s HospId=""
	i HospId'="" d
	.s tmpsscsub=0,tableName="DHC_StkSysCounter"
	.f  s tmpsscsub=$O(^DHCSSA(par,"SSC",tmpsscsub)) q:(tmpsscsub="")!(flag=1)  d
	..s Rowid=par_"||"_tmpsscsub
	..s BDPMapId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPMapId(tableName,HospId,Rowid)
	..i BDPMapId>0 s flag=1
	..q:flag=1
	e  d 
	.s cnt=0
	.&sql(select count(*) into :cnt From DHC_StkSysCounter where ssc_ssa_parref=:par )
	.i cnt>0 s flag=1
	q:flag'=0 flag
	q flag
}

}
