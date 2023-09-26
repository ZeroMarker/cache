Import SQLUser

Class web.CSSDHUI.Tools.CleanData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 清除业务数据  正式启用的时候清除掉测试数据
/// d ##class(web.CSSDHUI.Tools.CleanData).CleanBusinessData()
ClassMethod CleanBusinessData() As %String
{
	k ^User.CSSDUsedPredoDetailD
	k ^User.CSSDUsedPredoDetailI
	k ^User.CSSDUsedPrdoD
	k ^User.CSSDUsedPrdoI
	k ^User.CSSDTransI
	k ^User.CSSDTransD
	k ^User.CSSDSterPrdoD
	k ^User.CSSDSterPrdoI
	k ^User.CSSDSterPredoDetailD
	k ^User.CSSDSterPredoDetailI

	//灭菌主表
	k ^User.CSSDSterilizeRecordD
	k ^User.CSSDSterilizeRecordI
	//灭菌明细
	k ^User.CSSDPackageSterilizeI
	k ^User.CSSDPackageSterilizeD
	k ^User.CSSDSterilizeMonitorI
	//打包表
	k ^User.CSSDPackagePackI
	k ^User.CSSDPackagePackD

	//清洗主子表
	k ^User.CSSDCleanD
	k ^User.CSSDCleanI
	k ^User.CSSDCleanDetailPacksD
	k ^User.CSSDCleanDetailPacksI
	//外来器械绑定
	k ^User.CSSDExtDevBindD
	k ^User.CSSDExtDevBindI
	k ^User.CSSDExtCallBackLabelD
	k ^User.CSSDExtCallBackLabelI
	k ^User.CSSDExtDevBindDetailD
	k ^User.CSSDExtDevBindDetailI
	//请领主子表
	k ^User.CSSDPackageApplyD
	k ^User.CSSDPackageApplyDetailD
	k ^User.CSSDPackageApplyDetailI
	k ^User.CSSDPackageApplyI
	
	//清洗篮筐表 20181120
	k ^User.CSSDBasketPackDetailD
	k ^User.CSSDBasketPackDetailI
	k ^User.CSSDBasketPackMainD
	k ^User.CSSDBasketPackMainI
	
	//消耗明细
	k ^User.CSSDConsumeDetailD
	k ^User.CSSDConsumeDetailI
	k ^User.CSSDLocPackageD
	k ^User.CSSDLocPackageI
	k ^User.CSSDTransOPD
	k ^User.CSSDTransOPI
	
	k ^User.CSSDPackageCallbackD
	k ^User.CSSDPackageCallbackI
	
	//发放表
	k ^User.CSSDPackageDispMainD
	k ^User.CSSDPackageDispMainI
	k ^User.CSSDPackageDispI
	k ^User.CSSDPackageDispD
	
	//发放标签明细
	k ^User.CSSDPackageDispDetailD
	k ^User.CSSDPackageDispDetailI

	k ^User.CSSDSendRoadLineDetailD
	k ^User.CSSDSendRoadLineDetailI
	k ^User.CSSDSendRoadLineMainD
	k ^User.CSSDSendRoadLineMainI
	k ^User.CSSDTransOPD
	k ^User.CSSDTransOPI
	k ^User.CSSDCleanPackComposeD
	k ^User.CSSDCleanPackComposeI
	k ^CSSDCleanDetailPacksNumberD
	k ^CSSDCleanDetailPacksNumberI

	k ^User.CSSDSterilizeCarDetailD
	k ^User.CSSDSterilizeCarDetailI
	
	;回收明细
	k ^User.CSSDCallbackDetailNewD
	k ^User.CSSDCallbackDetailNewI
	
	;设置套餐模板
	k ^User.CSSDMoudleD
	k ^User.CSSDMoudleI
	k ^User.CSSDMoudleDetailD
	k ^User.CSSDMoudleDetailI
	
	k ^User.CSSDErrorRegistrationD
	k ^User.CSSDErrorRegistrationI
	k ^User.CSSDUllageDetailD
	k ^User.CSSDUllageDetailI
	k ^User.CSSDUllageD
	k ^User.CSSDUllageI
	k ^User.CSSDConsumeDetailD
	k ^User.CSSDConsumeDetailI
	
	;错误日志和列设置
	k ^User.CSSDSysErrorRecordD
	k ^User.CSSDSysGridSetD
	k ^User.CSSDSysGridSetI
	
	k ^User.CSSDDailySurveyD
	k ^User.CSSDDailySurveyI
	k ^User.CSSDSatisfactionDetailD
	k ^User.CSSDSatisfactionDetailI
	k ^User.CSSDSatisfactionMainD
	k ^User.CSSDSatisfactionMainI
	
	;入库
	k ^User.CSSDPackageStockD
	k ^User.CSSDPackageStockI
}

/// 清除基础数据 正式库导入数据前  比如消毒包 器械  消毒包有效期等信息前清除
/// d ##class(web.CSSDHUI.Tools.CleanData).CleanBaseData()
ClassMethod CleanBaseData() As %String
{
	k ^User.CSSDExpireD
	k ^User.CSSDExpireI
	k ^User.CSSDItemD
	k ^User.CSSDItemI
	d ..DeleteBDPMappingHosp("CSSD_Item")
	
	k ^User.CSSDPackageD
	k ^User.CSSDPackageI
	d ..DeleteBDPMappingHosp("CSSD_Package")
	k ^User.CSSDPackageItemD
	k ^User.CSSDPackageItemI
	
	k ^User.CSSDCodeDictD
	k ^User.CSSDCodeDictI
	d ..DeleteBDPMappingHosp("CSSD_CodeDict")
	
	k ^User.CSSDBaseCodeD
	k ^User.CSSDBaseCodeI
	d ..DeleteBDPMappingHosp("CSSD_BaseCode")
	
	k ^User.CSSDBaseDataTypeD
	k ^User.CSSDBaseDataTypeI
	
	k ^User.CSSDCleanItmReasonD
	k ^User.CSSDCleanItmReasonI
	d ..DeleteBDPMappingHosp("CSSD_CleanItmReason")
	
	k ^User.CSSDSteCheckReasonD
	k ^User.CSSDSteCheckReasonI
	d ..DeleteBDPMappingHosp("CSSD_SteCheckReason")
	
	k ^User.CSSDMachineConsumeReasonI
	k ^User.CSSDMachineConsumeReasonD
	d ..DeleteBDPMappingHosp("CSSD_MachineConsumeReason")
	
	k ^User.CSSDRecallReasonD
	k ^User.CSSDRecallReasonI
	d ..DeleteBDPMappingHosp("CSSD_RecallReason")
	
	k ^User.CSSDCleanTypeD
	k ^User.CSSDCleanTypeI
	d ..DeleteBDPMappingHosp("CSSD_CleanType")
	
	k ^User.CSSDDeptCenterD
	k ^User.CSSDDeptCenterI

	k ^User.CSSDParameterD
	k ^User.CSSDParameterI
	d ..DeleteBDPMappingHosp("CSSD_Parameter")
	k ^User.CSSDParameterItmI
	
	k ^User.CSSDPackageImageUrlD
	k ^User.CSSDPackageImageUrlI
	k ^User.CSSDPackageClassD
	k ^User.CSSDPackageClassI
	d ..DeleteBDPMappingHosp("CSSD_PackageClass")
	
	k ^User.CSSDMachineConfigD
	k ^User.CSSDMachineConfigI
	d ..DeleteBDPMappingHosp("CSSD_MachineConfig")
	
	k ^User.CSSDMaterialD
	k ^User.CSSDMaterialI
	d ..DeleteBDPMappingHosp("CSSD_Material")
	
	k ^User.CSSDUserLocD
	k ^User.CSSDUserLocI
	k ^User.CSSDVenD
	k ^User.CSSDVenI
	d ..DeleteBDPMappingHosp("CSSD_Ven")
	
	k ^User.CSSDSterTypeD
	k ^User.CSSDSterTypeI
	d ..DeleteBDPMappingHosp("CSSD_SterType")
	
	k ^User.CSSDBindLocI
	k ^User.CSSDBindLocD
	d ..DeleteBDPMappingHosp("CSSD_BindLoc")
	
	k ^CT.STER.CSSD.SatisfactionI
	k ^CT.STER.CSSD.SatisfactionD
	d ..DeleteBDPMappingHosp("CT_STER_CSSD.Satisfaction")
	
	k ^CT.STER.CSSD.PackageSpecI
	k ^CT.STER.CSSD.PackageSpecD
	d ..DeleteBDPMappingHosp("CT_STER_CSSD.PackageSpec")
	
	k ^CT.STER.CSSD.PrintRulesD
	k ^CT.STER.CSSD.PrintRulesI
	k ^CF.STER.CSSD.HospPrintRulesD
	k ^CF.STER.CSSD.HospPrintRulesI
	
	;初始化记录
	k ^CT.STER.CSSD.DataInitRecordI
	k ^CT.STER.CSSD.DataInitRecordD

	q ""
}

/// 增加清除基础数据的时候，清除多院区数据
/// d ##class(web.CSSDHUI.Tools.CleanData).CleanBaseData()
ClassMethod DeleteBDPMappingHosp(TableName As %String)
{
	&sql(DELETE FROM BDP_MappingHosp WHERE BDPMPH_TableName=:TableName)
	q SQLCODE
}

/// 只清除消毒包基础数据 偏于测试以及用户修改模板后重新导入
/// d ##class(web.CSSDHUI.Tools.CleanData).CleanPkgBaseData()
ClassMethod CleanPkgBaseData() As %String
{
	k ^User.CSSDExpireD
	k ^User.CSSDExpireI
	k ^User.CSSDItemD
	k ^User.CSSDItemI
	d ..DeleteBDPMappingHosp("CSSD_Item")
	
	k ^User.CSSDPackageD
	k ^User.CSSDPackageI
	d ..DeleteBDPMappingHosp("CSSD_Package")
	k ^User.CSSDPackageItemD
	k ^User.CSSDPackageItemI
	
	k ^User.CSSDCodeDictD
	k ^User.CSSDCodeDictI
	d ..DeleteBDPMappingHosp("CSSD_CodeDict")
}

/// 对应的表已删除或改名，存在冗余数据进行清除
/// d ##class(web.CSSDHUI.Tools.CleanData).TmpCleanUnUsedData()
ClassMethod TmpCleanUnUsedData() As %String
{
	k ^User.CSSDCleanCarDetailD
	k ^User.CSSDCleanCarDetailI
	k ^User.CSSDDataInitRecordD
	k ^User.CSSDDataInitRecordI
	k ^User.CSSDFunctionD
	k ^User.CSSDGroupFunctionD
	k ^User.CSSDLocHospPrintRulesD
	k ^User.CSSDLocHospPrintRulesI
	k ^User.CSSDOPPlanD
	k ^User.CSSDOPPlanI
	k ^User.CSSDPackageSpecD
	k ^User.CSSDPackageSpecI
	k ^User.CSSDPrintRulesD
	k ^User.CSSDPrintRulesI
	k ^User.CSSDSatisfactionI
	k ^User.CSSDSatisfactionD
}

}
