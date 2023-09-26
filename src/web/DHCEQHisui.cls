Class web.DHCEQHisui Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 更新组件按钮图标样式  除付款管理，辅助管理按钮图标
/// w ##Class(web.DHCEQHisui).ChangeComponentImage()
ClassMethod ChangeComponentImage()
{

	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-add' WHERE image='uiimages/edit_add.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-close' WHERE image='uiimages/cancel.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-find' WHERE image='uiimages/search.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-import' WHERE image='uiimages/importdata.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-save' WHERE image='uiimages/filesave.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-print' WHERE image='uiimages/print.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-close' WHERE image='uiimages/edit_remove.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-submit' WHERE image='uiimages/locsubmit.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-back' WHERE image='uiimages/undo.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-stamp' WHERE image='uiimages/audit.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-paper' WHERE image='uiimages/yellow_paper.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-setting' WHERE image='uiimages/arcossets.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-img' WHERE image='uiimages/printapplycard.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-cancel' WHERE image='uiimages/no.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-copy' WHERE image='uiimages/copy.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-config' WHERE image='uiimages/config.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-export' WHERE image='uiimages/redo.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-clean' WHERE image='uiimages/clearscreen.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-arrow-up' WHERE image='uiimages/moveup.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-arrow-down' WHERE image='uiimages/movedown.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-rent' WHERE image='uiimages/bill1.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-takes' WHERE image='uiimages/backbill1.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-line-key' WHERE image='uiimages/bluepaper.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componentitems SET image='icon-w-run' WHERE image='uiimages/enablepaper.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.websys.componenttableitems SET image='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' WHERE image='uiimages/paper.png' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
}

/// w ##Class(web.DHCEQHisui).ChangeComponentImagetwo()
ClassMethod ChangeComponentImagetwo()
{

	 &SQL(Update SQLUSER.websys.componentitems SET image='../scripts_lib/hisui-0.1.0/dist/css/icons/white/config.png' WHERE image='icon-w-config' AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap' AND DisplayType='A') 
	 i SQLCODE q SQLCODE
}

/// w ##Class(web.DHCEQHisui).ChangeComponentImagethird("../scripts_lib/hisui-0.1.0/dist/css/icons/white/add.png","icon-w-add")
ClassMethod ChangeComponentImagethird(newimage, oldimage)
{
	 &SQL(Update SQLUSER.websys.componentitems SET image=:newimage WHERE image=:oldimage AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 Q 0
}

/// w ##Class(web.DHCEQHisui).ChangeComponentTableItemImage("../scripts_lib/hisui-0.1.0/dist/css/icons/white/add.png","icon-w-add")
/// Modified By QW20181107 HISUI改造:修改旧图标
ClassMethod ChangeComponentTableItemImage(newimage, oldimage)
{
	 &SQL(Update SQLUSER.websys.componenttableitems SET image=:newimage WHERE image=:oldimage AND ParRef->name LIKE "DHCEQ%" AND ParRef->name NOT LIKE "DHCEQPayRequest%" AND ParRef->name NOT LIKE "DHCEQAdjustData%" AND ParRef->name NOT LIKE "DHCEQSnapEquip%" AND ParRef->name NOT LIKE "DHCEQFinancialReview%" AND ParRef->name<>'DHCEQInvoiceUseMap') 
	 i SQLCODE q SQLCODE
	 Q 0
}

/// add by lmm 2019-02-17
/// w ##Class(web.DHCEQHisui).UpdateComponentShowWindow()
ClassMethod UpdateComponentShowWindow()
{
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='title=,size=small' WHERE CI_Name='FundsInfo' AND CI_ComponentDR->c_name='EM.G.InStock.InStockList') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='title=设备附件' WHERE CI_Name='Affix' AND CI_ComponentDR->c_name='EM.G.InStock.InStockList') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=large,title=设备入库单' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='EM.G.Queue.InStock') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=small,title=审批进度' WHERE CI_Name='TApproveDetail' AND CI_ComponentDR->c_name='EM.G.Queue.InStock') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='width=95%,height=95%,title=设备验收单' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='EM.G.Queue.OpenCheckRequest') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=small,title=审批进度' WHERE CI_Name='TApproveDetail' AND CI_ComponentDR->c_name='EM.G.Queue.OpenCheckRequest') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='width=98%,height=98%,title=设备租赁单' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='RM.G.Queue.Rent') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=small,title=审批进度' WHERE CI_Name='TApproveDetail' AND CI_ComponentDR->c_name='RM.G.Queue.Rent') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='width=98%,height=95%,title=设备维修单' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='EM.G.Queue.MaintRequest') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=small,title=审批进度' WHERE CI_Name='TApproveDetail' AND CI_ComponentDR->c_name='EM.G.Queue.MaintRequest') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=large,title=设备转移单' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='EM.G.Queue.StoreMove') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=small,title=审批进度' WHERE CI_Name='TApproveDetail' AND CI_ComponentDR->c_name='EM.G.Queue.StoreMove') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=large,title=设备报废单' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='EM.G.Queue.DisuseRequest') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=small,title=审批进度' WHERE CI_Name='TApproveDetail' AND CI_ComponentDR->c_name='EM.G.Queue.DisuseRequest') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=large,title=设备退货单' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='EM.G.Queue.Return') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='size=small,title=审批进度' WHERE CI_Name='TApproveDetail' AND CI_ComponentDR->c_name='EM.G.Queue.Return') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='title=计划执行' WHERE CI_Name='TLastExSchedule' AND CI_ComponentDR->c_name='EM.G.Maint.MaintPlanAlert') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='title=设备明细' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='CON.G.Contract.ContractDetail') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='title=设备明细' WHERE CI_Name='TDetail' AND CI_ComponentDR->c_name='CON.G.Contract.ContractForMaintDetail') 
	 i SQLCODE q SQLCODE
	 &SQL(Update SQLUSER.DHC_EQCComponentItem SET CI_ShowInNewWindow='width=90%,height=98%,title=配置明细' WHERE CI_Name='CTLContractConfig' AND CI_ComponentDR->c_name='CON.G.Contract.ContractList') 
	 i SQLCODE q SQLCODE
	 q SQLCODE
}

}
