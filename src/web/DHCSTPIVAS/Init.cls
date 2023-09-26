Import sqluser

/// creator:	yunhaibao
/// createdate:	201-03-01 
/// description:初始化配液中心的一些打印数据
Class web.DHCSTPIVAS.Init Extends %RegisteredObject
{

/// description:增加排批流程
/// w ##class(web.DHCSTPIVAS.Init).InitPivaStateNumber()
ClassMethod InitPivaStateNumber()
{
	&SQL(SELECT * FROM PIVA_StateNumber WHERE PSN_Number=3)
	q:SQLCODE=0 "已存在排批,不再插入"
	&SQL(INSERT INTO PIVA_StateNumber VALUES (3,'排批','Y'))
	q 0
}

/// description:初始化通用字典数据
/// w ##class(web.DHCSTPIVAS.Init).InitComDict()
ClassMethod InitComDict()
{
	s warnInfo=",不需再插入"
	s dataJson={
		"type":"MedicalType",
		"typeDesc":"药品信息->主辅用药",
		"arr":[
			{"code":"P","desc":"主治用药"},
			{"code":"A","desc":"辅助用药"}
		]
	}
	w ..SaveDHCStkComDictionary(dataJson),!
	
	s dataJson={
		"type":"PivasDrugNum",
		"typeDesc":"住院配液->药品种数",
		"arr":[
			{"code":"1","desc":"单药"},
			{"code":"2","desc":"双药"},
			{"code":"3","desc":"三药"},
			{"code":"n","desc":"多药"}
		]
	}
	w ..SaveDHCStkComDictionary(dataJson),!

	q 0
}

/// description:初始化配伍审核原因代码
/// w ##class(web.DHCSTPIVAS.Init).InitPivasWay()
ClassMethod InitPivasWay()
{
	&SQL(SELECT * FROM DHC_PHCNTSWAY WHERE PWAY_Code='PIVAS')
	q:SQLCODE=0 "配伍审核已存在,不需再插入"
	&SQL(INSERT INTO DHC_PHCNTSWAY VALUES ("PIVAS","配伍审核","Y",NULL,"N"))
	q SQLCODE
}

/// description: 初始化默认参数
/// w ##class(web.DHCSTPIVAS.Init).InitPivasSettings()
ClassMethod InitPivasSettings()
{
	s warnInfo=",已存在,不需再插入"
	&SQL(SELECT SSA_RowId into :ssaId FROM DHC_StkSysApp WHERE SSA_Code="DHCSTINPIVA")
	q:ssaId="" "不存在该应用程序,请检查药库-参数设置中是否命名为 DHCSTINPIVA,如果否则在应用程序维护中住院配液中心代码修改"
	// 配伍审核
	i $$CheckSSAPExist("OeAudit.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^OeAudit.OrdStDate^配伍审核-默认-用药开始日期^t(今天),t-1(昨天)"),!	
	i $$CheckSSAPExist("OeAudit.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^OeAudit.OrdEdDate^配伍审核-默认-用药结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("OeAudit.AuditTimes")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^OeAudit.AuditTimes^配伍审核-按用药日期审核前N天执行记录(一天首次有效)^2(两天),0(每天),默认为新医嘱(一天)"),!
	i $$CheckSSAPExist("OeAudit.Pass")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^OeAudit.Pass^配伍审核-合理用药厂商^MK(美康),DT(大通),DHC(东华知识库)"),!
	i $$CheckSSAPExist("OeAudit.Formula")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^OeAudit.Formula^配伍审核使用指标公式^指标公式名称"),!
	i $$CheckSSAPExist("OeAudit.GroupView")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^OeAudit.GroupView^配伍审核-默认-明细表格显示类型^是否分组显示"),!
	i $$CheckSSAPExist("OeAudit.MaxDrugCnt")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^OeAudit.MaxDrugCnt^配伍审核-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	// 配液排批
	i $$CheckSSAPExist("BatUpdate.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^BatUpdate.OrdStDate^配液排批-默认-用药开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("BatUpdate.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^BatUpdate.OrdEdDate^配液排批-默认-用药结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("BatUpdate.ReferBeforeBat")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^BatUpdate.ReferBeforeBat^配液排批-是否参照昨日批次^Y(是)"),!
	i $$CheckSSAPExist("BatUpdate.MaxDrugCnt")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^BatUpdate.MaxDrugCnt^配伍排批-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	// 配液打签
	i $$CheckSSAPExist("LabelPrint.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^LabelPrint.OrdStDate^配液打签-默认-用药开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("LabelPrint.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^LabelPrint.OrdEdDate^配液打签-默认-用药结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("LabelPrint.NeedUser30")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^LabelPrint.NeedUser30^配液打签-是否录入排药核对人^Y(是),其它(否)"),!
	i $$CheckSSAPExist("LabelPrint.NeedUser40")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^LabelPrint.NeedUser40^配液打签-是否录入贴签核对人^Y(是),其它(否)"),!	
	i $$CheckSSAPExist("LabelPrint.NeedUser50")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^LabelPrint.NeedUser50^配液打签-是否录入核对核对人^Y(是),其它(否)"),!	
	i $$CheckSSAPExist("LabelPrint.MaxDrugCnt")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^LabelPrint.MaxDrugCnt^配伍打签-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	// 配液状态执行
	i $$CheckSSAPExist("Execute.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.OrdStDate^配液状态执行-默认-用药开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Execute.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.OrdEdDate^配液状态执行-默认-用药结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Execute.PrtStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.PrtStDate^配液状态执行-默认-打签开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Execute.PrtEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.PrtEdDate^配液状态执行-默认-打签结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Execute.PrtWardBatPS")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.PrtWardBatPS^打印交接单所在流程标识号^对应流程定制的标识号"),!
	i $$CheckSSAPExist("Execute.MaxDrugCnt")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.MaxDrugCnt^配液状态执行-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	i $$CheckSSAPExist("Execute.GeneWay")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.GeneWay^配液状态执行-默认-生成交接单类型^0 - 按所有, 1 - 按病区 , 2 - 按病区批次"),!
	i $$CheckSSAPExist("Execute.PrtWay")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Execute.PrtWay^配液状态执行-默认-打印交接单类型^0 - 按病区批次, 2 - 按药品汇总, 3 -  按医嘱明细"),!
	// 配液综合查询
	i $$CheckSSAPExist("Generally.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Generally.OrdStDate^配液综合查询-默认-用药开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Generally.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Generally.OrdEdDate^配液综合查询-默认-用药结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Generally.PrtStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Generally.PrtStDate^配液综合查询-默认-打签开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Generally.PrtEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Generally.PrtEdDate^配液综合查询-默认-打签结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Generally.MaxDrugCnt")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Generally.MaxDrugCnt^配液综合查询-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	// 排药统计
	i $$CheckSSAPExist("Arrange.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Arrange.OrdStDate^排药统计-默认-用药开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Arrange.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Arrange.OrdEdDate^排药统计-默认-用药结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Arrange.PrtStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Arrange.PrtStDate^排药统计-默认-打签开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Arrange.PrtEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Arrange.PrtEdDate^排药统计-默认-打签结束日期^t(今天),t-1(昨天)"),!	
	// 病区批次汇总
	i $$CheckSSAPExist("Report_WardBat.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Report_WardBat.OrdStDate^病区批次汇总-默认-用药开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Report_WardBat.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Report_WardBat.OrdEdDate^病区批次汇总-默认-用药结束日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Report_WardBat.PrtStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Report_WardBat.PrtStDate^病区批次汇总-默认-打签开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Report_WardBat.PrtEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Report_WardBat.PrtEdDate^病区批次汇总-默认-打签结束日期^t(今天),t-1(昨天)"),!	
	// 配液大屏
	i $$CheckSSAPExist("ScreenWardState.PageSize")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^ScreenWardState.PageSize^配液大屏-默认-行数^数字"),!
	// 是否启用置为可退
	i $$CheckSSAPExist("RetNeedAudit")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^RetNeedAudit^是否启用置为可退^Y(是),退药申请时,配液综合查询需要置为可退才可申请,配液状态为配置以及之后,不包含打包药品"),!
	// 配液拒绝
	i $$CheckSSAPExist("Refuse.MaxDrugCnt")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Refuse.MaxDrugCnt^配液拒绝-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	// 流程单据记录
	i $$CheckSSAPExist("LabelRecord.MaxDrugCnt")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^LabelRecord.MaxDrugCnt^流程单据记录-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	// 配液扫描执行
	i $$CheckSSAPExist("Scan.OrdStDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Scan.OrdStDate^配液扫描执行-默认-用药开始日期^t(今天),t-1(昨天)"),!
	i $$CheckSSAPExist("Scan.OrdEdDate")'=0 d
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Scan.OrdEdDate^配液扫描执行-默认-用药结束日期^t(今天),t-1(昨天)"),!
	.w ##class(web.DHCST.StkSysAppParame).Save("^"_ssaId_"^Scan.MaxDrugCnt^配液扫描执行-默认-成组医嘱显示几条记录^显示全请录入一个大数值即可"),!
	q "ok"
CheckSSAPExist(ssapCode)
	&SQL(SELECT * FROM DHC_StkSysAProp WHERE SSAP_SSA_Parref=:ssaId and SSAP_Code=:ssapCode)
	i SQLCODE=0 d
	.w ssapCode_warnInfo,!
	q SQLCODE
}

/// description: 重生索引
/// w ##class(web.DHCSTPIVAS.Init).BuildIndices()
ClassMethod BuildIndices()
{
	w ##class(User.INCItm).%BuildIndices()
	q "ok"
}

/// description: 批量插入医嘱-测试用
/// w ##class(web.DHCSTPIVAS.Init).InsertMultipleOrders(1)
ClassMethod InsertMultipleOrders(num)
{
	s mI=1
	f mI=1:1:num d
	.//中西医结合二科护理单元 0000000645
	.w ##class(PHA.FACE.IN.Com).SaveOrderItems(1232,"12858||1^R^5^2018-04-25^10:30:00^^8.310000^101^1^1994||1^^500^20^1500^40^63^8^1^^1^N^^N^^^^^^^N^^^2^^^^^^^^^^^^^2018-04-25^12:02:33^Y^^^^^N^^18^^N^^^"_$c(1)_"1090||1^R^5^2018-04-25^10:30:00^^2.350000^101^1^1090||1^^100^20^300^40^63^8^1^1^2^N^^N^^^^^^^N^^^2^^^^^^^^^^^^^2018-04-25^12:02:33^Y^^^^^N^^7^^N^^^"_$c(1)_"13325||1^R^5^2018-04-25^10:30:00^^10.020000^101^1^2161||1^^2^156^6^40^63^8^1^1^3^N^^N^^^^^^^N^^^2^^^^^^^^^^^^^2018-04-25^12:02:33^Y^^^^^N^^17^^N^^^",600,10,838,"LABDATA")
	.//中西医结合一科护理单元 0000000385
	.w ##class(PHA.FACE.IN.Com).SaveOrderItems(716,"1088||1^R^5^2018-04-27^10:05:21^^7.400000^101^1^1088||1^^500^20^1500^40^63^8^1^^1^N^^N^^^^^^^N^^^2^^^^^^^^^^^^^2018-04-27^10:03:54^N^^^^^N^^18^^N^^^"_$c(1)_"1089||1^R^5^2018-04-27^10:05:22^^6.810000^101^1^1089||1^^100^20^300^40^63^8^1^1^2^N^^N^^^^^^^N^^^2^^^^^^^^^^^^^2018-04-27^10:03:54^N^^^^^N^^18^^N^^^"_$c(1)_"13325||1^R^5^2018-04-27^10:05:21^^10.020000^101^1^2161||1^^2^156^6^40^63^8^1^1^4^N^^N^^^^^^^N^^^2^^^^^^^^^^^^^2018-04-27^10:03:54^N^^^^^N^^17^^N^^^",600,6,838,"LABDATA")
	.//中西医结合一科护理单元 0000000470
	.w ##class(PHA.FACE.IN.Com).SaveOrderItems(1010,"1058||1^R^5^2018-04-27^10:30:00^^14.990000^101^1^1058||1^^10^20^60^25^63^4^1^^1^N^^N^^^^^^^N^^^4^^^^^^^^^^^^^2018-04-27^10:23:22^Y^^^^^N^^17^^N^^^"_$c(1)_"1063||1^R^5^2018-04-27^10:30:00^^416.000000^101^1^1063||1^^1440^20^8640^25^63^4^1^1^2^N^^N^^^^^^^N^^^4^^^^^^^^^^^^^2018-04-27^10:23:22^Y^^^^^N^^18^^N^^^"_$c(1)_"1066||1^R^5^2018-04-27^10:30:00^^105.990000^101^1^1066||1^^250^20^1500^25^63^4^1^1^3^N^^N^^^^^^^N^^^4^^^^^^^^^^^^^2018-04-27^10:23:22^Y^^^^^N^^7^^N^^^"_$c(1)_"1077||1^R^5^2018-04-27^10:30:00^^7.400000^101^1^1077||1^^500^20^3000^25^63^4^1^1^4^N^^N^^^^^^^N^^^4^^^^^^^^^^^^^2018-04-27^10:23:22^Y^^^^^N^^18^^N^^^"_$c(1)_"599||1^R^5^2018-04-27^10:30:00^^74.190000^101^1^599||1^^10^156^60^25^63^4^1^1^5^N^^N^^^^^^^N^^^4^^^^^^^^^^^^^2018-04-27^10:23:22^Y^^^^^N^^7^^N^^^",600,6,838,"LABDATA")
	.// 内二科 0000000008
	.w ##class(PHA.FACE.IN.Com).SaveOrderItems(280,"12858||1^R^5^2018-04-27^10:30:00^^8.310000^101^1^1994||1^^500^20^500^4^63^8^1^^1^N^^N^^^^^^^N^^^0^^^^^^^^^^^^^2018-04-27^10:39:37^Y^^^^^N^^18^^N^^^"_$c(1)_"13325||1^R^5^2018-04-27^10:30:00^^10.020000^101^1^2161||1^^2^156^2^4^63^8^1^1^2^N^^N^^^^^^^N^^^0^^^^^^^^^^^^^2018-04-27^10:39:37^Y^^^^^N^^17^^N^^^",600,5,838,"LABDATA")
	q ""
}

/*
ClassMethod UpdatePhaOrdDoseDate()
{
	s phaordId=""
	f  s phaordId=$o(^DHCPHORDM(phaordId)) q:phaordId=""  d
	.q:+phaordId=0
	.s phaordItm=""
	.f  s phaordItm=$o(^DHCPHORDM(phaordId,"I",phaordItm)) q:phaordItm=""  d
	..q:+phaordItm=0
	..s phaordItmId=phaordId_"||"_phaordItm
	..s oeori=$p(^DHCPHORDM(phaordId,"I",phaordItm),"^",2)
	..q:oeori=""
	..s firstDate=$o(^DHCOEDISQTY(0,"SEQNO",oeori,""))
	..&SQL(UPDATE DHC_PHAORDMONITORLIST SET PCTL_DoseDate=:firstDate WHERE PCTL_ROWID=:phaordItmId)
	..w SQLCODE,!
	q 1
}
*/
/// Description: 初始化药学成分字典
/// w ##class(web.DHCSTPIVAS.Init).InitIngRed()
ClassMethod InitIngRed()
{
	&SQL(DELETE from PHC_Ingredient)
	s saveStr="^脂肪乳能量^脂肪乳能量"
	s saveStr=saveStr_"!!"_"^氨基酸能量^氨基酸能量"
	s saveStr=saveStr_"!!"_"^葡萄糖能量^葡萄糖能量"
	
	s saveStr=saveStr_"!!"_"^钠离子^钠离子"
	s saveStr=saveStr_"!!"_"^钾离子^钾离子"
	s saveStr=saveStr_"!!"_"^钙离子^钙离子"
	s saveStr=saveStr_"!!"_"^镁离子^镁离子"
	s saveStr=saveStr_"!!"_"^磷离子^磷离子"
	
	s saveStr=saveStr_"!!"_"^氨基酸含量^氨基酸含量"
	s saveStr=saveStr_"!!"_"^氨基酸含氮量^氨基酸含氮量"
	
	
	s saveStr=saveStr_"!!"_"^氯化钾含量^氯化钾含量"
	s saveStr=saveStr_"!!"_"^氯化钠含量^氯化钠含量"
	s saveStr=saveStr_"!!"_"^脂肪乳含量^脂肪乳含量"
	s saveStr=saveStr_"!!"_"^葡萄糖含量^葡萄糖含量"
	
	s saveStr=saveStr_"!!"_"^力文脂肪乳^力文脂肪乳"
	s saveStr=saveStr_"!!"_"^力能脂肪乳^力能脂肪乳"
	s saveStr=saveStr_"!!"_"^力保脂肪乳^力保脂肪乳"
	s saveStr=saveStr_"!!"_"^力邦脂肪乳^力邦脂肪乳"
	
	s saveStr=saveStr_"!!"_"^力邦液体量^力邦液体量"
	s saveStr=saveStr_"!!"_"^脂肪乳液体量^脂肪乳液体量"
	
	s saveStr=saveStr_"!!"_"^胰岛素^胰岛素"
	w ##class(web.DHCSTPIVAS.Ingredient).Save(saveStr)
	q ""
}

/// Description: 初始化药学成分公式
/// w ##class(web.DHCSTPIVAS.Init).InitFormula()
ClassMethod InitFormula()
{
	k ^PHCDrgIngredIndex
	&SQL(DELETE from PHC_DrgIngredIndex where DII_RowID>0 and DII_Desc='TPN')
	w ##class(web.DHCSTPIVAS.Formula).SavePHCDrgIngredIndex("^TPN"),!
	s ingIndId=""
	&SQL(SELECT DII_RowID into :ingIndId FROM PHC_DrgIngredIndex WHERE DII_Desc='TPN')
	q:ingIndId="" "-1^插入主表失败" 
	s i=1
	s num=0
	s SaveArr(i)=ingIndId_"^"_""_"^"_"总液体量"_"^"_""_"^"_""_"^"_""_"^"_"总液体量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"总能量(kcal)"_"^"_""_"^"_""_"^"_""_"^"_"脂肪乳能量+氨基酸能量+葡萄糖能量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"总非蛋白能量(kcal)"_"^"_""_"^"_""_"^"_""_"^"_"葡萄糖能量+脂肪乳能量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"总氨基酸量(g)"_"^"_""_"^"_""_"^"_""_"^"_"葡萄糖能量+脂肪乳能量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"总氮量(g)"_"^"_""_"^"_""_"^"_""_"^"_"氨基酸含量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"糖脂比"_"^"_"2"_"^"_"1"_"^"_""_"^"_"葡萄糖含量/脂肪乳含量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"卡氮比"_"^"_"200"_"^"_"100"_"^"_""_"^"_"(葡萄糖能量+脂肪乳能量)/氨基酸含氮量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"钾浓度(mmol/L)"_"^"_"45"_"^"_""_"^"_""_"^"_"(钾离子*1000)/总液体量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"一价阳离子(mmol/L)"_"^"_"150"_"^"_""_"^"_""_"^"_"((钾离子*1000)+(钠离子*1000))/总液体量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"二价阳离子(mmol/L)"_"^"_"10"_"^"_""_"^"_""_"^"_"((钙离子*1000)+(镁离子*1000))/总液体量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"葡萄糖浓度(%)"_"^"_"23"_"^"_""_"^"_""_"^"_"(葡萄糖含量*100)/1000"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"糖胰比(g:1IU)"_"^"_""_"^"_""_"^"_""_"^"_"葡萄糖含量/胰岛素"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"氨基酸浓度(%)"_"^"_""_"^"_""_"^"_""_"^"_"(氨基酸含量*100)/1000"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"钙磷乘积"_"^"_""_"^"_""_"^"_""_"^"_"((钙离子*1000)/(总液体量-脂肪乳液体量))*((磷离子*1000)/(总液体量-脂肪乳液体量))"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s SaveArr(i)=ingIndId_"^"_""_"^"_"渗透压"_"^"_""_"^"_""_"^"_""_"^"_"(((葡萄糖含量*5)+(脂肪乳含量*0.67)+(氨基酸含量*10)+(氯化钠含量*27))*1000)/总液体量"_"^"_$replace($j(i,3)," ",0)_"^"_"",i=i+1
	s i=""
	f  s i=$o(SaveArr(i)) q:i=""  d
	.w ##class(web.DHCSTPIVAS.Formula).SavePHCDrgIngIndItm(SaveArr(i)),!
	q ""
}

ClassMethod SaveDHCStkComDictionary(dataJson As %DynamicObject)
{
	
	s type = dataJson.%Get("type")
	s typeDesc = dataJson.%Get("typeDesc")
	s arr = dataJson.%Get("arr")
	
	&SQL(DELETE FROM DHC_StkComDictionary WHERE SCDI_Type=:type)
	s iter  =  arr.%GetIterator()
  	while iter.%GetNext(.key, .value) {
		s code = value.%Get("code")
		s desc = value.%Get("desc")
		&SQL(
			INSERT INTO DHC_StkComDictionary
			(SCDI_Code, SCDI_Desc, SCDI_Type, SCDI_TypeDesc)
			VALUES
			(:code, :desc, :type, :typeDesc)
		)
		w SQLCODE,!
	}	
	q ""
}

/// Description: 筛选出翻译数据
/// w ##class(web.DHCSTPIVAS.Init).SetTransDict("web.DHCSTPIVAS",1)
/// w ##class(web.DHCSTPIVAS.Init).SetTransDict4App(1)
ClassMethod SetTransDict(packageName, langID, pageName = "PHA.PIVAS.TRANSLATE")
{
    q:(+langID '= langID) "请输入正确的语言ID" // SS_Language
    q:(pageName = "") "页面翻译名称不能为空"
    q:(packageName '= "web.DHCSTPIVAS") "住院配液只能处理此包web.DHCSTPIVAS"
    d $system.OBJ.GetPackageList(.classArr, packageName)
	s className = ""
	for {
		s className = $o(classArr(className)) q:(className = "")
        //^websys.TranslationD("PAGE",,"PHA.OPIVAS.TRANSLATE"
        s methodName = ""
        for {
            s methodName = $o(^oddDEF(className, "m", methodName)) q:(methodName = "")
            s line = 0
            for {
                s line = $o(^oddDEF(className, "m", methodName, 30, line), 1, lineCode) q:(line = "")
                if (lineCode [ "@translate" ){
                    s lineCode = $tr(lineCode, $c(1,2,3,4,5,6,7,8,9,10, 11,12,13), "")
                    s needTrans = $$$NO
                    if (lineCode [ ".Translate(") {
                        s lineCode = $p(lineCode, ".Translate(", 2)
                        s lineCode = $p(lineCode, """)", 1, * - 1)
                        s needTrans = $$$YES
                    }
                    if (lineCode [ ".ReplaceTranslation(") {
                        s lineCode = $p(lineCode, ".ReplaceTranslation(", 2)
                        s lineCode = $p(lineCode, "$lb", 1, * - 1)
                        if ($e(lineCode, *) = " "){
                            s $e(lineCode, *) = ""
                        }
                        if ($e(lineCode, *) = ","){
                            s $e(lineCode, *) = ""
                        }
                        s needTrans = $$$YES
                    }
                    continue:(needTrans = $$$NO)
                    #; 前后有双引号
                    if ($e(lineCode, 1) = """"){
                        s $e(lineCode, 1) = ""
                    }
                    if ($e(lineCode, *) = """"){
                        s $e(lineCode, *) = ""
                    }
                    if (lineCode [ "^")&&($e(lineCode, 1) = "-"){
                        s lineCode = $p(lineCode, "^", 2, *)
                    }
                    continue:(lineCode = "")
                    if ('$d(^websys.TranslationD("PAGE", langID, pageName, lineCode))){
                        s ^websys.TranslationD("PAGE", langID, pageName, lineCode) = ""
                    }
                }
            }
        }
    }
    q $$$OK
}

/// w ##class(web.DHCSTPIVAS.Init).SetTransDict4App(1)
ClassMethod SetTransDict4App(langID)
{
    q:(+langID '= langID) "请输入正确的语言ID" // SS_Language
    s pageName = "PHA.PIVAS.TRANSLATE"
    s dataList = ..GetComTransDict()
    for i = 1 : 1 : $ll(dataList){
        s str = $lg(dataList, i)
        continue:(str = "")
        if ('$d(^websys.TranslationD("PAGE", langID, pageName, str))){
            s ^websys.TranslationD("PAGE", langID, pageName, str) = ""
        }
    }
    q $$$OK
}

/// Description: 常规翻译内容
/// 
ClassMethod GetComTransDict()
{
    q $lb("未申请")
    _ $lb("已申请")
    _ $lb("全部")
    _ $lb("已打包")
    _ $lb("未打包")
    _ $lb("未审核")
    _ $lb("待审核")
    _ $lb("已审核")
    _ $lb("审核通过")
    _ $lb("审核拒绝")
    _ $lb("医生申诉")
    _ $lb("未申请")
    _ $lb("已申请")
    _ $lb("已接收")
    _ $lb("拒绝接收")
    _ $lb("取消申请")
    _ $lb("押金欠费")
    _ $lb("未执行")
    _ $lb("库存不足")
    _ $lb("无法处理")
    _ $lb("置为可退")
    _ $lb("置为不可退")
    _ $lb("未处理")
    _ $lb("当前状态为{{status}}, 不需要再次操作")
}

}
