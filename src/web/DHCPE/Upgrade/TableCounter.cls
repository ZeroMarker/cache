/// 系统升级表计数器迁移
Class web.DHCPE.Upgrade.TableCounter Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// User表计数器修改方法（默认参数 新旧计数器下都更新）
/// w ##class(web.DHCPE.Upgrade.TableCounter).SetCounter(0)
ClassMethod SetCounter(aFlag As %Boolean = 1) As %String
{
	New (aFlag)
	
	//************************************************************************
	//体检系统^mdata计数器修改
	//************************************************************************
	//User.DHCPEAdvancePayment.cls  预交金主表	DHC_PE_AdvancePayment
	Set:aFlag>0 ^DHCPEAP=+$o(^DHCPEAP("9999999999999999"),-1)
	Set ^mdata("DHCPEADVANCEPAYMENT")=+$o(^DHCPEAP("9999999999999999"),-1)
	
	//User.DHCPEAsChargedOrder.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEACO=+$o(^DHCPEACO("9999999999999999"),-1)
	Set ^mdata("DHCPEASCHARGEDORDER")=+$o(^DHCPEACO("9999999999999999"),-1)
	
	//User.DHCPECRMOrder.cls  与CRM大项对照表	DHC_PE_CRMOrder
	Set:aFlag>0 ^DHCPECRMO=+$o(^DHCPECRMO("9999999999999999"),-1)
	Set ^mdata("DHCPECRMORDER")=+$o(^DHCPECRMO("9999999999999999"),-1)
	
	//User.DHCPEEDAlias.cls  专家建议别名表	DHC_PE_EDAlias
	Set:aFlag>0 ^DHCPEEDA=+$o(^DHCPEEDA("9999999999999999"),-1)
	Set ^mdata("DHCPEEDALIAS")=+$o(^DHCPEEDA("9999999999999999"),-1)
	
	//User.DHCPEEDClass.cls  建议级别表	DHC_PE_EDClass
	Set:aFlag>0 ^DHCPEEDC=+$o(^DHCPEEDC("9999999999999999"),-1)
	Set ^mdata("DHCPEEDCLASS")=+$o(^DHCPEEDC("9999999999999999"),-1)
	
	//User.DHCPEEDCRelate.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEEDCR=+$o(^DHCPEEDCR("9999999999999999"),-1)
	Set ^mdata("DHCPEEDCRELATE")=+$o(^DHCPEEDCR("9999999999999999"),-1)
	
	//User.DHCPEExpertDiagnosis.cls  专家建议主表	DHC_PE_ExpertDiagnosis
	Set:aFlag>0 ^DHCPEED=+$o(^DHCPEED("9999999999999999"),-1)
	Set ^mdata("DHCPEEXPERTDIAGNOSIS")=+$o(^DHCPEED("9999999999999999"),-1)
	
	//User.DHCPEGADM.cls  团体客户ADM表	DHC_PE_GADM
	Set:aFlag>0 ^DHCPEGADM=+$o(^DHCPEGADM("9999999999999999"),-1)
	Set ^mdata("DHCPEGADM")=+$o(^DHCPEGADM("9999999999999999"),-1)
	
	//User.DHCPEGBaseInfo.cls  团体客户基本信息登记表	DHC_PE_GBaseInfo
	Set:aFlag>0 ^DHCPEGBI=+$o(^DHCPEGBI("9999999999999999"),-1)
	Set ^mdata("DHCTJGBASEINFO")=+$o(^DHCPEGBI("9999999999999999"),-1)
	
	//User.DHCPEGeneralAdvice.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEGA=+$o(^DHCPEGA("9999999999999999"),-1)
	Set ^mdata("DHCPEGENERALADVICE")=+$o(^DHCPEGA("9999999999999999"),-1)
	
	//User.DHCPEGeneralSummarize.cls  总检结论	DHC_PE_GeneralSummarize
	Set:aFlag>0 ^DHCPEGS=+$o(^DHCPEGS("9999999999999999"),-1)
	Set ^mdata("DHCPEGENERALSUMMARIZE")=+$o(^DHCPEGS("9999999999999999"),-1)
	
	//User.DHCPEGGeneralSummarize.cls  总检结论(团体)	DHC_PE_GGeneralSummarize
	Set:aFlag>0 ^DHCPEGGS=+$o(^DHCPEGGS("9999999999999999"),-1)
	Set ^mdata("DHCPEGGENERALSUMMARIZE")=+$o(^DHCPEGGS("9999999999999999"),-1)
	
	//User.DHCPEGroupChart.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEGC=+$o(^DHCPEGC("9999999999999999"),-1)
	Set ^mdata("DHCPEGROUPCHART")=+$o(^DHCPEGC("9999999999999999"),-1)
	
	//User.DHCPEGSDModifiedRecords.cls  总检结论诊断明细修改记录	DHC_PE_GSDModifiedRecords  //计数器定义到了RowID字段上
	Set:aFlag>0 ^DHCPEGSDM=+$o(^DHCPEGSDM("9999999999999999"),-1)
	Set ^mdata("DHCPEGSDM")=+$o(^DHCPEGSDM("9999999999999999"),-1)
	
	//User.DHCPEHealthRecord.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEHR=+$o(^DHCPEHR("9999999999999999"),-1)
	Set ^mdata("DHCPEHEALTHRECORD")=+$o(^DHCPEHR("9999999999999999"),-1)
	
	//User.DHCPEHealthRecordDetail.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEHRD=+$o(^DHCPEHRD("9999999999999999"),-1)
	Set ^mdata("DHCPEHEALTHRECORDDETAIL")=+$o(^DHCPEHRD("9999999999999999"),-1)
	
	//User.DHCPEHRDRelate.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEHRDR=+$o(^DHCPEHRDR("9999999999999999"),-1)
	Set ^mdata("DHCPEHRDRELATE")=+$o(^DHCPEHRDR("9999999999999999"),-1)
	
	//User.DHCPEIADM.cls  体检人员ADM表	DHC_PE_IADM
	Set:aFlag>0 ^DHCPEIADM=+$o(^DHCPEIADM("9999999999999999"),-1)
	Set ^mdata("DHCPEIADM")=+$o(^DHCPEIADM("9999999999999999"),-1)
	
	//User.DHCPEIDRelate.cls  专家建议与疾病对照表	DHC_PE_IDRelate
	Set:aFlag>0 ^DHCPEIDR=+$o(^DHCPEIDR("9999999999999999"),-1)
	Set ^mdata("DHCPEIDRELATE")=+$o(^DHCPEIDR("9999999999999999"),-1)
	
	//User.DHCPEIllnessStandard.cls  疾病维护表	DHC_PE_IllnessStandard
	Set:aFlag>0 ^DHCPEILLS=+$o(^DHCPEILLS("9999999999999999"),-1)
	Set ^mdata("DHCPEILLNESSSTANDARD")=+$o(^DHCPEILLS("9999999999999999"),-1)
	
	//User.DHCPEILLSAlias.cls  疾病别名维护	DHC_PE_ILLSAlias
	Set:aFlag>0 ^DHCPEILLSA=+$o(^DHCPEILLSA("9999999999999999"),-1)
	Set ^mdata("DHCPEILLSALIAS")=+$o(^DHCPEILLSA("9999999999999999"),-1)
	
	//User.DHCPEINVPRT.cls  体检发票表	DHC_PE_INVPRT
	Set:aFlag>0 ^DHCPEINVPRT=+$o(^DHCPEINVPRT("9999999999999999"),-1)
	Set ^mdata("DHCPEINVPRT")=+$o(^DHCPEINVPRT("9999999999999999"),-1)
	
	//User.DHCPEItemExtend.cls  站点项目组合关联表	DHC_PE_ItemExtend
	Set:aFlag>0 ^DHCPEIE=+$o(^DHCPEIE("9999999999999999"),-1)
	Set ^mdata("DHCPEITEMEXTEND")=+$o(^DHCPEIE("9999999999999999"),-1)
	
	//User.DHCPEODAdvice.cls  ***暂时不用？
	Set:aFlag>0 ^DHCPEODA=+$o(^DHCPEODA("9999999999999999"),-1)
	Set ^mdata("DHCTJODADVICE")=+$o(^DHCPEODA("9999999999999999"),-1)
	
	//User.DHCPEOrderDetailRelate.cls  科室站点大项细项组合表	DHC_PE_OrderDetailRelate
	Set:aFlag>0 ^DHCPEODR=+$o(^DHCPEODR("9999999999999999"),-1)
	Set ^mdata("DHCTJORDERDETAILRELATE")=+$o(^DHCPEODR("9999999999999999"),-1)
	
	//User.DHCPEOrdSetsEx.cls  体检医嘱套扩展表	DHC_PE_OrdSetsEx
	Set:aFlag>0 ^DHCPEOSE=+$o(^DHCPEOSE("9999999999999999"),-1)
	Set ^mdata("DHCPEORDSETSEX")=+$o(^DHCPEOSE("9999999999999999"),-1)
	
	//User.DHCPEPAPBRelate.cls  (预约)审核表和收费表的对照	DHC_PE_PAPBRelate
	Set:aFlag>0 ^DHCPEPAPBR=+$o(^DHCPEPAPBR("9999999999999999"),-1)
	Set ^mdata("DHCPEPAPBRELATE")=+$o(^DHCPEPAPBR("9999999999999999"),-1)
	
	//User.DHCPEPreAudit.cls  (预约)团体和个人ADM审核表	DHC_PE_PreAudit
	Set:aFlag>0 ^DHCPEPreA=+$o(^DHCPEPreA("9999999999999999"),-1)
	Set ^mdata("DHCPEPREAUDIT")=+$o(^DHCPEPreA("9999999999999999"),-1)
	
	//User.DHCPEPreGADM.cls  (预约)团体客户ADM表	DHC_PE_PreGADM
	Set:aFlag>0 ^DHCPEPreGADM=+$o(^DHCPEPreGADM("9999999999999999"),-1)
	Set ^mdata("DHCPEPREGADM")=+$o(^DHCPEPreGADM("9999999999999999"),-1)
	
	//User.DHCPEPreGBaseInfo.cls  (预约)团体客户基本信息表	DHC_PE_PreGBaseInfo
	Set:aFlag>0 ^DHCPEPreGBI=+$o(^DHCPEPreGBI("9999999999999999"),-1)
	Set ^mdata("DHCPEPREGBASEINFO")=+$o(^DHCPEPreGBI("9999999999999999"),-1)
	
	//User.DHCPEPreIADM.cls  (预约)个人ADM表	DHC_PE_PreIADM
	Set:aFlag>0 ^DHCPEPreIADM=+$o(^DHCPEPreIADM("9999999999999999"),-1)
	Set ^mdata("DHCPEPREIADM")=+$o(^DHCPEPreIADM("9999999999999999"),-1)
	
	//User.DHCPEPreIBaseInfo.cls  (预约)个人基本信息表	DHC_PE_PreIBaseInfo
	Set:aFlag>0 ^DHCPEPreIBI=+$o(^DHCPEPreIBI("9999999999999999"),-1)
	Set ^mdata("DHCPEPREIBASEINFO")=+$o(^DHCPEPreIBI("9999999999999999"),-1)
	
	//User.DHCPEReport.cls  体检报告	DHC_PE_Report
	Set:aFlag>0 ^DHCPERPT=+$o(^DHCPERPT("9999999999999999"),-1)
	Set ^mdata("DHCPEREPORT")=+$o(^DHCPERPT("9999999999999999"),-1)
	
	//User.DHCPEResult.cls  体检结果表	DHC_PE_Result
	Set:aFlag>0 ^DHCPERLT=+$o(^DHCPERLT("9999999999999999"),-1)
	Set ^mdata("DHCTJRESULT")=+$o(^DHCPERLT("9999999999999999"),-1)
	
	//User.DHCPEStation.cls  站点字典表	DHC_PE_Station
	Set:aFlag>0 ^DHCPEST=+$o(^DHCPEST("9999999999999999"),-1)
	Set ^mdata("DHCTJSTATION")=+$o(^DHCPEST("9999999999999999"),-1)
	
	//User.DHCPEStationSummarize.cls  站点(科室)小结	DHC_PE_StationSummarize
	Set:aFlag>0 ^DHCPESS=+$o(^DHCPESS("9999999999999999"),-1)
	Set ^mdata("DHCPESTATIONSUMMARIZE")=+$o(^DHCPESS("9999999999999999"),-1)
	
	//User.DHCPEUSERREPORT.cls  体检结算表	DHC_PE_USERREPORT
	Set:aFlag>0 ^DHCPEUSERREPORT=+$o(^DHCPEUSERREPORT("9999999999999999"),-1)
	Set ^mdata("DHCPEUSERREPORT")=+$o(^DHCPEUSERREPORT("9999999999999999"),-1)
	
	Quit "OK!!!"
}

}
