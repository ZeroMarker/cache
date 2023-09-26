/// Creator：      	谷雪萍
/// CreatDate：    	2020-6-29
/// Description:     临床决策知识库数据备份清除
Class web.CDSS.Public.CDSSDataBackup Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate:2020-06-29
/// Description:导出临床辅助决策支持系统global,导出V1.2部署的知识库数据
/// Others：d ##class(web.CDSS.Public.CDSSDataBackup).ExportCDSSGlobal("D:\CDSSGlobal\NewTable\")
ClassMethod ExportCDSSGlobal(filePath)
{
	k CList
	k myIdx
	
	//***********4.1字典表**************************/
	
	//4.1.1人体部位分类字典表
	s CList($i(CList))= "User.DHCDSSBodyPartClassD.GBL"
	s CList($i(CList))= "User.DHCDSSBodyPartClassI.GBL"  
	//4.1.1人体部位字典表
	s CList($i(CList))= "User.DHCDSSBodyParDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSBodyParDictI.GBL" 	
	//4.1.3.人体状态字典表
	s CList($i(CList))= "User.DHCDSSBodyStateDictD.GBL"  
	s CList($i(CList))= "User.DHCDSSBodyStateDictI.GBL" 	
	//4.1.4.	诊断因子字典表（临床表现、体格检查、实验室检验、影像学检查）
	s CList($i(CList))= "User.DHCDSSDiagFactorDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiagFactorDictI.GBL" 
    //4.1.6.	同义词字典表
	s CList($i(CList))= "User.DHCDSSSynonymDictD.GBL"
	s CList($i(CList))= "User.DHCDSSSynonymDictI.GBL"	
	//4.1.7.	医学知识分级字典表
	s CList($i(CList))= "User.DHCDSSKBSClassDictD.GBL"
	s CList($i(CList))= "User.DHCDSSKBSClassDictI.GBL"
	//4.1.8.	系统功能分级字典表
	s CList($i(CList))= "User.DHCDSSSYSFuncDictD.GBL"
	s CList($i(CList))= "User.DHCDSSSYSFuncDictI.GBL"	
	//4.1.9.	数据集合控件字典表
	s CList($i(CList))= "User.DHCDSSDataConDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDataConDictI.GBL"	
	//4.1.10.	功能关联数据集合控件表
	s CList($i(CList))= "User.DHCDSSDataFuncConD.GBL"
	s CList($i(CList))= "User.DHCDSSDataFuncConI.GBL"	
	//4.1.11.	基础信息字典集合表
	s CList($i(CList))= "User.DHCDSSBasicsDictD.GBL"
	s CList($i(CList))= "User.DHCDSSBasicsDictI.GBL"
	//4.1.12.	数据库表字典表
	s CList($i(CList))= "User.DHCDSSDataTableDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDataTableDictI.GBL"
	//4.1.13.	检验标本字典表
	s CList($i(CList))= "User.DHCDSSLabSpecimenDictD.GBL"
	s CList($i(CList))= "User.DHCDSSLabSpecimenDictI.GBL"
	//4.1.14.	用法字典表
	s CList($i(CList))= "User.DHCDSSUsageDictD.GBL"
	s CList($i(CList))= "User.DHCDSSUsageDictI.GBL"	
	//4.1.15.	频率字典表	
	s CList($i(CList))= "User.DHCDSSFrequencyDictD.GBL"
	s CList($i(CList))= "User.DHCDSSFrequencyDictI.GBL"		
	//4.1.16.	临床数据类型关联数据字段表
	s CList($i(CList))= "User.DHCDSSDataJoinFiledDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDataJoinFiledDictI.GBL"	
	//4.1.17.	疾病分科字典表
	s CList($i(CList))= "User.DHCDSSDiseaseDeptDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDiseaseDeptDictI.GBL"	
	
	//检验医嘱字典 20210926
	s CList($i(CList))= "User.DHCDSSLabOrdersDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabOrdersDictI.GBL" 
	
	//检查结果字典
	s CList($i(CList))= "User.DHCDSSExamResultDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSExamResultDictI.GBL" 
	
	//单位字典
	s CList($i(CList))= "User.DHCDSSUnitDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUnitDictI.GBL" 
	//单位转换表
	s CList($i(CList))= "User.DHCDSSUnitConversionD.GBL" 
	s CList($i(CList))= "User.DHCDSSUnitConversionI.GBL" 

	//定语字典
	s CList($i(CList))= "CT.WDT.CDSS.AttributeDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AttributeDictI.GBL" 
	
	//评估结果字典
	s CList($i(CList))= "CT.WDT.CDSS.AssessResultDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssessResultDictI.GBL" 
	
	//症状字典
	s CList($i(CList))= "User.DHCDSSSymptomDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSSymptomDictI.GBL" 
	//1.3.18.	药物分类字典表
	s CList($i(CList))= "User.DHCDSSDrugTypeDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDrugTypeDictI.GBL" 
	//1.3.18.	剂型字典表
	s CList($i(CList))= "CT.WDT.CDSS.DHCDSSDosageFormD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DHCDSSDosageFormI.GBL" 


	
	//**************文献管理********************/
	//文献表字典V1.0
	s CList($i(CList))= "User.MKBDocManageD.GBL" 
	s CList($i(CList))= "User.MKBDocManageI.GBL" 
	
	//**************文献管理2.0********************/
	//文献表
	s CList($i(CList))= "User.DHCDSSDocuManageD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuManageI.GBL" 
	//文献关联诊断
	s CList($i(CList))= "User.DHCDSSDocuJoinDiseaseD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDiseaseI.GBL" 
	//文献关联科室
	s CList($i(CList))= "User.DHCDSSDocuJoinDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDeptI.GBL" 	
	//文献详情
	s CList($i(CList))= "User.DHCDSSDocuDetailD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuDetailI.GBL" 
	//4.4.5.	文献发布机构表
	s CList($i(CList))= "User.DHCDSSDocuAgencyD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuAgencyI.GBL"
	
	
    //***********百科管理**************************/
	//知识库注册
	s CList($i(CList))= "CT.WDT.CDSS.TermBaseD.GBL"  //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseI.GBL" //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyI.GBL"  //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyD.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyC.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseExtendProI.GBL" //术语库注册扩展属性表
    //知识管理
    s CList($i(CList))= "CT.WDT.CDSS.TermD.GBL"  //术语表
    s CList($i(CList))= "CT.WDT.CDSS.TermI.GBL"  //术语表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyD.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyI.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyC.GBL"  //术语属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProI.GBL" //术语扩展属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailD.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailI.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValD.GBL" //扩展属性值表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValI.GBL" //扩展属性值表
	
	//***********评估表知识库管理**************************/
	//评估表基本信息
	s CList($i(CList))= "User.DHCDSSAssBasicInfoD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssBasicInfoI.GBL" 
	//评估表关联文献表
	s CList($i(CList))= "User.DHCDSSAssConDocD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssConDocI.GBL" 
	//评估表关联科室
	s CList($i(CList))= "User.DHCDSSAssConDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssConDeptI.GBL" 	
	//评估表关联关键字
	s CList($i(CList))= "User.DHCDSSAssKeyWordsD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssKeyWordsI.GBL" 
	//评估表关联疾病
	s CList($i(CList))= "User.DHCDSSDiseJoinAssessmentD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinAssessmentI.GBL" 	
	//评估表注册表
	s CList($i(CList))= "User.MKBAssessmentBaseD.GBL" 
	s CList($i(CList))= "User.MKBAssessmentBaseI.GBL" 	
	s CList($i(CList))= "User.MKBAssessmentBaseC.GBL"
	//评估表注册字段表
	s CList($i(CList))= "User.MKBAssessmentBaseFieldI.GBL" 	
	//评估表评分规则表
	s CList($i(CList))= "User.MKBAssessmentScoringRulesI.GBL" 	
	//评估表关联评估结果条件设置表
	s CList($i(CList))= "CT.WDT.MKB.AssConResCondiD.GBL" 
	s CList($i(CList))= "CT.WDT.MKB.AssConResCondiI.GBL" 
	
	//评估表关联评估结论表
	s CList($i(CList))= "CT.WDT.CDSS.AssConResultD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssConResultI.GBL" 
	
	//************4.2.	临床疾病知识库****************/
	
	//4.2.1.	疾病字典表
	s CList($i(CList))= "User.DHCDSSDiseaseDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseaseDictI.GBL" 
	//4.2.2.	疾病关联病情描述表
	s CList($i(CList))= "User.DHCDSSDiseJoinDescD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinDescI.GBL" 
	//4.2.3.	疾病关联临床表现表
	s CList($i(CList))= "User.DHCDSSDiseJoinSymptomD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinSymptomI.GBL" 	
	//4.2.4.	疾病关联体格检查表
	s CList($i(CList))= "User.DHCDSSDiseJoinPhysicalED.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinPhysicalEI.GBL" 
	//4.2.5.	疾病关联检验指标表
	s CList($i(CList))= "User.DHCDSSDiseJoinLabD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinLabI.GBL" 	
	//4.2.6.	疾病关联检查指标表
	s CList($i(CList))= "User.DHCDSSDiseJoinExamValD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinExamValI.GBL" 	
	//4.2.7.	疾病关联病因表
	s CList($i(CList))= "User.DHCDSSDiseJoinCauseD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinCauseI.GBL"	
	//4.2.8.	疾病关联病因表
	s CList($i(CList))= "User.DHCDSSDiseJoinPartD.GBL"  
	s CList($i(CList))= "User.DHCDSSDiseJoinPartI.GBL" 
	//4.2.9.	疾病关联预防表
	s CList($i(CList))= "User.DHCDSSDiseJoinPreventD.GBL"  
	s CList($i(CList))= "User.DHCDSSDiseJoinPreventI.GBL" 	
	//4.2.10.	疾病关联诊断因子表
	s CList($i(CList))= "User.DHCDSSDiseJoinFactorD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinFactorI.GBL"  
	//4.2.11.	疾病关联适用项表
	s CList($i(CList))= "User.DHCDSSDiseVSConditionD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseVSConditionI.GBL"  		
	//4.2.12.	疾病关联治疗方案表
	s CList($i(CList))= "User.DHCDSSDiseJoinTreatD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinTreatI.GBL"
	//s CList($i(CList))= "User.DHCDSSDiseJoinTreatC.GBL" 
	//4.2.13.	治疗方案关联适用项表
	s CList($i(CList))= "User.DHCDSSTreatVSConditionD.GBL" 
	s CList($i(CList))= "User.DHCDSSTreatVSConditionI.GBL" 	
	//4.2.14.	治疗方案关联禁忌证表
	s CList($i(CList))= "User.DHCDSSTreatVSTabooD.GBL"
	s CList($i(CList))= "User.DHCDSSTreatVSTabooI.GBL"	
	//4.2.15.	治疗方案关联禁忌证消除条件表
	s CList($i(CList))= "User.DHCDSSTreatCRD.GBL" 
	s CList($i(CList))= "User.DHCDSSTreatCRI.GBL" 	
	//4.2.16.	治疗方案关联措施表
	s CList($i(CList))= "User.DHCDSSTreatVSItemD.GBL" 
	s CList($i(CList))= "User.DHCDSSTreatVSItemI.GBL" 	
	//4.2.17.	治疗措施关联子措施表
	s CList($i(CList))= "User.DHCDSSItemVSChildD.GBL"
	s CList($i(CList))= "User.DHCDSSItemVSChildI.GBL" 
	//4.2.18.	治疗措施关联适用项表
	s CList($i(CList))= "User.DHCDSSItemVSConditionD.GBL"
	s CList($i(CList))= "User.DHCDSSItemVSConditionD.GBL"
	//4.2.19.	治疗措施关联禁忌证表
	s CList($i(CList))= "User.DHCDSSItemVSTabooD.GBL"  
	s CList($i(CList))= "User.DHCDSSItemVSTabooI.GBL" 
	//4.2.20.	治疗措施关联禁忌证消除条件表
	s CList($i(CList))= "User.DHCDSSItemCRD.GBL" 
	s CList($i(CList))= "User.DHCDSSItemCRI.GBL" 
	//4.2.21.	治疗措施关联明细表
	s CList($i(CList))= "User.DHCDSSItemJoinDetailD.GBL" 
	s CList($i(CList))= "User.DHCDSSItemJoinDetailI.GBL"  
	//治疗方案关联明细表——删除
	//s CList($i(CList))= "User.DHCDSSTreatJoinDetailI.GBL"  //治疗方案关联明细表 父表是疾病关联治疗方案表	
	//4.2.22.	治疗措施明细关联用法方案表
	s CList($i(CList))= "User.DHCDSSItemJoinUsageD.GBL"  
	s CList($i(CList))= "User.DHCDSSItemJoinUsageI.GBL" 
	//4.2.23.	治疗措施用法方案关联适用项表
	s CList($i(CList))= "User.DHCDSSUsageVSConditionD.GBL" 
	s CList($i(CList))= "User.DHCDSSUsageVSConditionI.GBL" 
	//4.2.24.	治疗措施用法方案关联禁忌症表
	s CList($i(CList))= "User.DHCDSSTUsageJoinTabooD.GBL"  
	s CList($i(CList))= "User.DHCDSSTUsageJoinTabooI.GBL" 
	//4.2.25.	治疗措施用法方案关联禁忌症消除表
	s CList($i(CList))= "User.DHCDSSTUsageJoinTabooCRD.GBL"  
	s CList($i(CList))= "User.DHCDSSTUsageJoinTabooCRI.GBL" 
	//4.2.26.	疾病关联并发症表
	s CList($i(CList))= "User.DHCDSSDiseJoinCompD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinCompI.GBL" 	
	//4.2.27.	疾病关联预后表
	s CList($i(CList))= "User.DHCDSSDiseJoinPrognosisD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinPrognosisI.GBL" 	
	//4.2.28.	疾病关联鉴别诊断表
	s CList($i(CList))= "User.DHCDSSDiseJoinDiffDiagD.GBL"
	s CList($i(CList))= "User.DHCDSSDiseJoinDiffDiagI.GBL"
	//4.2.29.	疾病关联鉴别诊断详述表
	s CList($i(CList))= "User.DHCDSSDiseJoinDiffDescD.GBL"
	s CList($i(CList))= "User.DHCDSSDiseJoinDiffDescI.GBL"
	//4.2.30.	疾病详述表	
	s CList($i(CList))= "User.DHCDSSDiseaseDetailD.GBL"
	s CList($i(CList))= "User.DHCDSSDiseaseDetailI.GBL"
	//4.2.31.	疾病关联辅助检查检验表
	s CList($i(CList))= "User.DHCDSSDiseJoinExamD.GBL"
	s CList($i(CList))= "User.DHCDSSDiseJoinExamI.GBL"
	//4.2.32.	疾病关联辅助检查检验明细表
	s CList($i(CList))= "User.DHCDSSDiseJoinDetailD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinDetailI.GBL"	
	//4.2.33.	疾病关联辅助检查检验评估表
	s CList($i(CList))= "User.DHCDSSDiseJoinExamAssessD.GBL"
	s CList($i(CList))= "User.DHCDSSDiseJoinExamAssessI.GBL"	
	//4.2.34.	急诊预检分诊分级标准字典表
	s CList($i(CList))= "User.DHCDSSEmerStandardDictD.GBL"
	s CList($i(CList))= "User.DHCDSSEmerStandardDictI.GBL"		
	//4.2.35.	SNOMEDCT中英文对照
	s CList($i(CList))= "User.DHCDSSSnomedctDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSSnomedctDictI.GBL"
	//4.2.36.	疾病关联科室字典表 
	s CList($i(CList))= "User.DHCDSSDiseJoinDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinDeptI.GBL"	
	//4.2.37.	疾病关联文献资料表
	s CList($i(CList))= "User.DHCDSSDiseJoinliteratureD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinliteratureI.GBL"
		
	//疾病详述表-展示数据
	s CList($i(CList))= "User.DHCDSSDiseDetailForViewD.GBL"  //疾病详述表-展示数据
	s CList($i(CList))= "User.DHCDSSDiseDetailForViewI.GBL"  //疾病详述表-展示数据
	
	//疾病关联评估表 2021-03-22
	s CList($i(CList))= "User.DHCDSSDiseJoinAssessmentD.GBL"
	s CList($i(CList))= "User.DHCDSSDiseJoinAssessmentI.GBL"
	
	//************4.3.	评估量表知识库表****************/
	
	//4.3.1.	评分量表字典表
	s CList($i(CList))= "User.DHCDSSRatingScaleDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSRatingScaleDictI.GBL" 
	//4.3.2.	评估量表评估表
	s CList($i(CList))= "User.DHCDSSRatingScaleAssessD.GBL" 
	s CList($i(CList))= "User.DHCDSSRatingScaleAssessI.GBL" 
	
	//*************4.4.	体格检查知识库表*****************/
	
	//4.4.1.	体格检查字典表
	s CList($i(CList))= "User.DHCDSSPhysicalExamDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSPhysicalExamDictI.GBL"
	//4.4.2.	体格检查关联症状表 	
	
	//*************4.5.	诊疗规则知识库表*****************/
	
	//4.5.1.	诊疗规则字典表
	s CList($i(CList))= "User.DHCDSSMedicalRuleD.GBL"
	s CList($i(CList))= "User.DHCDSSMedicalRuleI.GBL"
	//4.5.2.	诊疗规则关联规则条件表
	s CList($i(CList))= "User.DHCDSSRuleTriggerD.GBL"
	s CList($i(CList))= "User.DHCDSSRuleTriggerI.GBL"	
	//4.5.3.	诊疗规则规则条件关联子规则条件表
	s CList($i(CList))= "User.DHCDSSChildRuleTriggerD.GBL"
	s CList($i(CList))= "User.DHCDSSChildRuleTriggerI.GBL"	
	//4.5.4.	诊疗规则申请操作记录表
	s CList($i(CList))= "User.DHCDSSRuleApplyRecordD.GBL"
	s CList($i(CList))= "User.DHCDSSRuleApplyRecordI.GBL"
	
	//推荐疑似疾病中单一规则表 2020-11-17
	s CList($i(CList))= "User.DHCDSSSingleSymptomRuleD.GBL"	
	s CList($i(CList))= "User.DHCDSSSingleSymptomRuleI.GBL"	
	
	//阻断医嘱表 2021-08-12
	s CList($i(CList))= "User.DHCDSSBlockOrderListD.GBL"
	s CList($i(CList))= "User.DHCDSSBlockOrderListI.GBL"	
	//特殊诊疗规则配置表 2021-08-12
	s CList($i(CList))= "User.DHCDSSSpecialRuleConfigD.GBL"	
	s CList($i(CList))= "User.DHCDSSSpecialRuleConfigI.GBL"	
	
	//*************4.6.	质控规则知识库表*****************/	
	//4.6.1.	质控规则字典表
	s CList($i(CList))= "User.DHCDSSQCRuleDictD.GBL"
	s CList($i(CList))= "User.DHCDSSQCRuleDictI.GBL"
	//4.6.2.	质控规则关联条件表
	s CList($i(CList))= "User.DHCDSSQCRJoinConditionD.GBL"
	s CList($i(CList))= "User.DHCDSSQCRJoinConditionI.GBL"	
	//4.6.3.	质控规则条件关联子条件表
	s CList($i(CList))= "User.DHCDSSQCRJoinSConditionD.GBL"
	s CList($i(CList))= "User.DHCDSSQCRJoinSConditionI.GBL"	
	//4.6.4.	质控规则操作记录表
	s CList($i(CList))= "User.DHCDSSQCRJoinRecordD.GBL"
	s CList($i(CList))= "User.DHCDSSQCRJoinRecordI.GBL"	
	
	//*************4.7.	临床输血知识库*****************/	
	//4.7.1.	血型字典表
	s CList($i(CList))= "User.DHCDSSBloodTypeDictD.GBL"
	s CList($i(CList))= "User.DHCDSSBloodTypeDictI.GBL"	
	//4.7.2.	输血品分类字典表
	s CList($i(CList))= "User.DHCDSSBPClassDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSBPClassDictI.GBL"	
	//4.7.3.	输血品字典表	
	s CList($i(CList))= "User.DHCDSSBloodProductDictD.GBL"
	s CList($i(CList))= "User.DHCDSSBloodProductDictI.GBL" 
	//4.7.4.	输血品关联血型
	s CList($i(CList))= "User.DHCDSSBPJoinBloodTypeD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinBloodTypeI.GBL"
	//4.7.5.	输血品关联适用项
	s CList($i(CList))= "User.DHCDSSBPJoinIndicationD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinIndicationI.GBL"	
	//4.7.6.	输血品关联禁忌症
	s CList($i(CList))= "User.DHCDSSBPJoinTabooD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinTabooI.GBL"
	//4.7.7.	输血品关联禁忌症消除条件
	s CList($i(CList))= "User.DHCDSSBPJoinTabooRemoveD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinTabooRemoveI.GBL"
	//4.7.8.	输血品关联注意事项
	s CList($i(CList))= "User.DHCDSSBPJoinPrecautionsD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinPrecautionsI.GBL"	
	//4.7.9.	输血品关联不良反应
	s CList($i(CList))= "User.DHCDSSBPJoinARD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinARI.GBL"	
	//4.7.10.	输血品关联疾病	
	s CList($i(CList))= "User.DHCDSSBPJoinDiseaseD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinDiseaseI.GBL"
	//4.7.11.	输血品关联并发症
	s CList($i(CList))= "User.DHCDSSBPJoinComplicationD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinComplicationI.GBL"	
	//4.7.12.	输血品关联替代制品
	s CList($i(CList))= "User.DHCDSSBPJoinSubstituteD.GBL"
	s CList($i(CList))= "User.DHCDSSBPJoinSubstituteI.GBL"	
	
	//*************	4.8.	临床护理知识库*****************/	
	//4.8.1.	护理分类字典表
	s CList($i(CList))= "User.DHCDSSNursingClassDictD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingClassDictI.GBL"	
	//4.8.2.	护理分级字典表
	s CList($i(CList))= "User.DHCDSSNursingGradeDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSNursingGradeDictI.GBL"	
	//4.8.3.	护理项目字典表	
	s CList($i(CList))= "User.DHCDSSNursingDictD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingDictI.GBL" 
	//4.8.4.	护理明细表
	s CList($i(CList))= "User.DHCDSSNursingJoinDetailD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinDetailI.GBL"
	//4.8.5.	护理项目关联器械表
	s CList($i(CList))= "User.DHCDSSNursingJoinInstruD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinInstruI.GBL"	
	//4.8.6.	护理项目关联部位表
	s CList($i(CList))= "User.DHCDSSNursingJoinPartD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinPartI.GBL"
	//4.8.7.	护理项目关联适用项表
	s CList($i(CList))= "User.DHCDSSNursingJoinIndicD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinIndicI.GBL"
	//4.8.8.	护理项目关联禁忌症表
	s CList($i(CList))= "User.DHCDSSNursingJoinTabooD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinTabooI.GBL"	
	//4.8.9.	护理项目关联禁忌症消除表
	s CList($i(CList))= "User.DHCDSSNursingJoinTabooRD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinTabooRI.GBL"	
	//4.8.10.	护理项目关联不良反应表
	s CList($i(CList))= "User.DHCDSSNursingJoinARD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinARI.GBL"
	//4.8.11.	护理项目关联注意事项表
	s CList($i(CList))= "User.DHCDSSNursingJoinPreD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinPreI.GBL"	
	//4.8.12.	护理项目关联疾病表
	s CList($i(CList))= "User.DHCDSSNursingJoinDiseaseD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinDiseaseI.GBL"	
	//4.8.13.	护理项目关联并发症表		
	s CList($i(CList))= "User.DHCDSSNursingJoinCompD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinCompI.GBL"	
	//4.8.14.	护理项目关联评估量表
	s CList($i(CList))= "User.DHCDSSNursingJoinRSD.GBL"
	s CList($i(CList))= "User.DHCDSSNursingJoinRSI.GBL"	
	
	//*************4.9.	临床药物知识库*****************/	
	//4.9.1.	药物分类字典表
	s CList($i(CList))= "User.DHCDSSDrugClassDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugClassDictI.GBL"	
	//4.9.2.	药物字典表
	s CList($i(CList))= "User.DHCDSSDrugDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugDictI.GBL"	
	//4.9.3.	药物关联适用项表
	s CList($i(CList))= "User.DHCDSSDrugJoinIndicationD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugJoinIndicationI.GBL"	
	//4.9.4.	药物关联用法方案表
	s CList($i(CList))= "User.DHCDSSDrugJoinUsageD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugJoinUsageI.GBL"	
	//4.9.5.	药物用法方案关联适用项表
	s CList($i(CList))= "User.DHCDSSUsageJoinIndicationD.GBL"
	s CList($i(CList))= "User.DHCDSSUsageJoinIndicationI.GBL"	
	//4.9.6.	药物用法方案关联禁忌症表
	s CList($i(CList))= "User.DHCDSSUsageJoinTabooD.GBL"
	s CList($i(CList))= "User.DHCDSSUsageJoinTabooI.GBL"	
	//4.9.7.	药物用法方案关联禁忌症消除表
	s CList($i(CList))= "User.DHCDSSUsageJoinTabooCRD.GBL"
	s CList($i(CList))= "User.DHCDSSUsageJoinTabooCRI.GBL"	
	//4.9.8.	药物关联不良反应表
	s CList($i(CList))= "User.DHCDSSDrugARD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugARI.GBL"	
	//4.9.9.	药物关联禁忌症表
	s CList($i(CList))= "User.DHCDSSDrugContraindicaD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugContraindicaI.GBL"	
	//4.9.10.	药物关联禁忌症消除条件表
	s CList($i(CList))= "User.DHCDSSDrugCRD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugCRI.GBL"	
	//4.9.11.	药物关联辅料表
	s CList($i(CList))= "User.DHCDSSDrugAccessoriesD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugAccessoriesI.GBL"
	//4.9.12.	药物关联相互作用表	
	//4.9.13.	药物关联过量使用表
	s CList($i(CList))= "User.DHCDSSDrugJoinOverdoseD.GBL"
	s CList($i(CList))= "User.DHCDSSDrugJoinOverdoseI.GBL"		
	
	//*************4.10.	临床医学检验知识库表*****************/	
	//4.10.1.	检验分类字典表
	s CList($i(CList))= "User.DHCDSSLabClassDictD.GBL"
	s CList($i(CList))= "User.DHCDSSLabClassDictI.GBL"	
	//	4.10.2.	检验字典表
	s CList($i(CList))= "User.DHCDSSLabInspectionDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabInspectionDictI.GBL"	
	//4.10.3.	检验明细字典表		
	s CList($i(CList))= "User.DHCDSSInspectionDetailD.GBL"
	s CList($i(CList))= "User.DHCDSSInspectionDetailI.GBL" 
	//4.10.4.	检验项目关联标本表
	s CList($i(CList))= "User.DHCDSSLabJoinSpecimenD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinSpecimenI.GBL"
	//4.10.5.	检验项目关联器械（药物）表
	s CList($i(CList))= "User.DHCDSSLabJoinInstruD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinInstruI.GBL"	
	//4.10.6.	检验项目关联适用项表
	s CList($i(CList))= "User.DHCDSSLabJoinIndicationD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinIndicationI.GBL"
	//4.10.7.	检验项目关联禁忌症表
	s CList($i(CList))= "User.DHCDSSLabJoinTabooD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinTabooI.GBL"
	//4.10.8.	检验项目关联禁忌症消除表
	s CList($i(CList))= "User.DHCDSSLabJoinTabooRemoveD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinTabooRemoveI.GBL"	
	//4.10.9.	检验项目关联不良反应表
	s CList($i(CList))= "User.DHCDSSLabJoinARD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinARI.GBL"	
	//4.10.10.	检验项目关联注意事项表	
	s CList($i(CList))= "User.DHCDSSLabJoinPrecautionD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinPrecautionI.GBL"
	//4.10.11.	检验项目关联疾病表
	s CList($i(CList))= "User.DHCDSSLabJoinDiagnosisD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinDiagnosisI.GBL"	
	//4.10.12.	检验结果辅助诊断表
	s CList($i(CList))= "User.DHCDSSLabJoinResultD.GBL"
	s CList($i(CList))= "User.DHCDSSLabJoinResultI.GBL"		
	
	//***********4.11.	临床医学检查知识库表****************/
	//4.11.1.	检查分类字典表
	s CList($i(CList))= "User.DHCDSSExamClassDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSExamClassDictI.GBL" 	
	//4.11.2.	检查字典表
	s CList($i(CList))= "User.DHCDSSExamDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSExamDictI.GBL" 
	//4.11.3.	检查项目关联部位表
	s CList($i(CList))= "User.DHCDSSExamJoinPartsD.GBL"
	s CList($i(CList))= "User.DHCDSSExamJoinPartsI.GBL"
	//4.11.4.	检查项目关联器械（药物）表
	s CList($i(CList))= "User.DHCDSSExamJoinInstruD.GBL"
	s CList($i(CList))= "User.DHCDSSExamJoinInstruI.GBL"
	//4.11.5.	检查项目关联适用项表
	s CList($i(CList))= "User.DHCDSSExamIndicationD.GBL"
	s CList($i(CList))= "User.DHCDSSExamIndicationI.GBL"
	//	4.11.6.	检查项目关联禁忌症表
	s CList($i(CList))= "User.DHCDSSExamContraindicaD.GBL"
	s CList($i(CList))= "User.DHCDSSExamContraindicaI.GBL"	
	//4.11.7.	检查项目关联禁忌症消除条件表
	s CList($i(CList))= "User.DHCDSSExamCRD.GBL"
	s CList($i(CList))= "User.DHCDSSExamCRI.GBL"	
	//4.11.8.	检查项目关联不良反应表
	s CList($i(CList))= "User.DHCDSSExamARD.GBL"
	s CList($i(CList))= "User.DHCDSSExamARI.GBL"	
	//4.11.9.	检查项目关联注意事项表
	s CList($i(CList))= "User.DHCDSSExamPrecautionsD.GBL"
	s CList($i(CList))= "User.DHCDSSExamPrecautionsI.GBL"	
	//4.11.10.	检查项目关联疾病表
	s CList($i(CList))= "User.DHCDSSExamJoinDiagD.GBL"
	s CList($i(CList))= "User.DHCDSSExamJoinDiagI.GBL"	

	//*************	4.12.	临床手术知识库表*****************/	
	//4.12.1.	手术分级字典表
	s CList($i(CList))= "User.DHCDSSOperationGradeDictD.GBL"
	s CList($i(CList))= "User.DHCDSSOperationGradeDictI.GBL"	
	//4.12.2.	手术字典表
	s CList($i(CList))= "User.DHCDSSOperationDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSOperationDictI.GBL"	
	//4.12.3.	手术详述表	
	s CList($i(CList))= "User.DHCDSSOperationDescD.GBL"
	s CList($i(CList))= "User.DHCDSSOperationDescI.GBL" 
	//4.12.4.	手术关联部位
	s CList($i(CList))= "User.DHCDSSOperJoinBodyPartD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinBodyPartI.GBL"
	//4.12.5.	手术关联器械（药物）表
	s CList($i(CList))= "User.DHCDSSOperJoinInstruD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinInstruI.GBL"	
	//4.12.6.	手术关联疾病
	s CList($i(CList))= "User.DHCDSSOperJoinDiseaseD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinDiseaseI.GBL"
	//4.12.7.	手术关联适用项
	s CList($i(CList))= "User.DHCDSSOperJoinIndicationD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinIndicationI.GBL"
	//4.12.8.	手术关联禁忌症
	s CList($i(CList))= "User.DHCDSSOperJoinTabooD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinTabooI.GBL"	
	//4.12.9.	手术关联禁忌症消除条件
	s CList($i(CList))= "User.DHCDSSOperJoinTabooRD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinTabooRI.GBL"	
	//4.12.10.	手术关联并发症
	s CList($i(CList))= "User.DHCDSSOperJoinCompD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinCompI.GBL"
	//4.12.11.	手术关联麻醉方式
	s CList($i(CList))= "User.DHCDSSOperJoinAnesthesiaD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinAnesthesiaI.GBL"	
	//4.12.12.	手术关联术前准备
	s CList($i(CList))= "User.DHCDSSOperJoinPreoperatD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinPreoperatI.GBL"	
	//4.12.13.	手术关联切口
	//4.12.14.	手术关联止血
	//4.12.15.	手术关联引流
	//4.12.16.	手术关联操作步骤	
	s CList($i(CList))= "User.DHCDSSOperJoinDrocedureD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinDrocedureI.GBL"	
	//4.12.17.	手术关联结扎
	//4.12.18.	手术关联缝合
	//4.12.19.	手术关联术后护理
	s CList($i(CList))= "User.DHCDSSOperJoinPostoperatD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinPostoperatI.GBL"	
	//4.12.20.	手术关联注意事项
	s CList($i(CList))= "User.DHCDSSOperJoinPrecautionD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinPrecautionI.GBL"
	//4.12.21.	手术关联术后饮食
	s CList($i(CList))= "User.DHCDSSOperJoinDietD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinDietI.GBL"		
	
	//***********4.13.	病案知识库表*************/	
	//4.13.1.	病案记录表
	s CList($i(CList))= "User.DHCDSSMedicalRecordD.GBL"  
	s CList($i(CList))= "User.DHCDSSMedicalRecordI.GBL" 	
	
	//决策知识库与医为百科对照 20200923 GXP
	s CList($i(CList))= "User.DHCDSSWikiCMKBContrastD.GBL"  
	s CList($i(CList))= "User.DHCDSSWikiCMKBContrastI.GBL" 	
	
	//对接方字典 20200925 GXP
	//2021-03-20  GXP 导出方法中把字典对照去掉，用抽取数据的方法只取某一个项目的数据:w ##class(web.CDSS.CMKB.MappingGlobalInfo).GetDiaConDataToTempGlobal(hospid)
	/*s CList($i(CList))= "User.DHCDSSInterfaceDictD.GBL"  
	s CList($i(CList))= "User.DHCDSSInterfaceDictI.GBL" 	
	
	//对接方字典分类表 20200925 GXP
	s CList($i(CList))= "User.DHCDSSInterfaceClassDictD.GBL"  
	s CList($i(CList))= "User.DHCDSSInterfaceClassDictI.GBL" 	
	
	//字典对照 20200925 GXP
	s CList($i(CList))= "User.DHCDSSInterDictMappingD.GBL"  
	s CList($i(CList))= "User.DHCDSSInterDictMappingI.GBL"	
	
	// his检验医嘱和his检验项目（检验小项）关联表
	s CList($i(CList))= "User.DHCDSSLabOrderConItemD.GBL"  
	s CList($i(CList))= "User.DHCDSSLabOrderConItemI.GBL"
	 */	
	
	//*************实施管理平台****************/
	//医院表：
	s CList($i(CList))= "User.DHCDSSCustomerHospD.GBL" 
	s CList($i(CList))= "User.DHCDSSCustomerHospI.GBL" 
	s CList($i(CList))= "User.DHCDSSCustomerHospC.GBL" 
	//院区
	s CList($i(CList))= "CT.WDT.CDSS.CustomerHospAreaI.GBL" 
	//规则表：
	s CList($i(CList))= "User.DHCDSSHospLinkRulesD.GBL" 
	s CList($i(CList))= "User.DHCDSSHospLinkRulesI.GBL" 
	//记录类型表
	s CList($i(CList))= "User.DHCDSSRecordTypeD.GBL" 
	s CList($i(CList))= "User.DHCDSSRecordTypeI.GBL" 
	//映射属性表
	s CList($i(CList))= "User.DHCDSSMapPropertyD.GBL" 
	s CList($i(CList))= "User.DHCDSSMapPropertyI.GBL" 
	//模板配置表
	s CList($i(CList))= "User.DHCDSSTemplateConfigD.GBL" 
	s CList($i(CList))= "User.DHCDSSTemplateConfigI.GBL" 
	//模板配置子表
	s CList($i(CList))= "User.DHCDSSTemplateConfigItemD.GBL" 
	s CList($i(CList))= "User.DHCDSSTemplateConfigItemI.GBL" 
	
	 //平台配置
	//s CList($i(CList))= "User.MKBConfigD.GBL" 
	//s CList($i(CList))= "User.MKBConfigI.GBL" 

	
	//4.1.12.	医学组数据统计配置表
	//s CList($i(CList))= "CF.WDT.CDSS.StatisticsConfigD.GBL"
	//s CList($i(CList))= "CF.WDT.CDSS.StatisticsConfigI.GBL"
	
	//***********文献管理**************************/
	
	//文献表
	s CList($i(CList))= "User.DHCDSSDocuManageD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuManageI.GBL" 
	//文献关联诊断
	s CList($i(CList))= "User.DHCDSSDocuJoinDiseaseD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDiseaseI.GBL" 
	//文献关联科室
	s CList($i(CList))= "User.DHCDSSDocuJoinDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDeptI.GBL" 	
	//文献详情
	s CList($i(CList))= "User.DHCDSSDocuDetailD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuDetailI.GBL" 
	//4.4.5.	文献发布机构表
	s CList($i(CList))= "User.DHCDSSDocuAgencyD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuAgencyI.GBL" 
	
		
	//	4.22.1.	全文检索配置表
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetD.GBL" 
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetI.GBL" 
	
	
	//把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"CDSSData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)
	w time,!
	s filename = filePath_"CDSSData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator：      	谷雪萍
/// CreatDate:2020-06-29
/// Description:k掉临床辅助决策支持系统global
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).KillCDSSGlobal()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","CDSSData.gof")
ClassMethod KillCDSSGlobal()
{
	b ;确定库是否正确？？？确定的话输 g 不确定输 q	
	b ;确定要删除CDSS的所有数据吗？确定的话输 g 不确定输 q	
	//***********4.1字典表**************************/
	
	//4.1.1人体部位分类字典表
	k ^User.DHCDSSBodyPartClassD
	k ^User.DHCDSSBodyPartClassI  
	//4.1.1人体部位字典表
	k ^User.DHCDSSBodyParDictD 
	k ^User.DHCDSSBodyParDictI 	
	//4.1.3.人体状态字典表
	k ^User.DHCDSSBodyStateDictD  
	k ^User.DHCDSSBodyStateDictI 	
	//4.1.4.	诊断因子字典表（临床表现、体格检查、实验室检验、影像学检查）
	k ^User.DHCDSSDiagFactorDictD 
	k ^User.DHCDSSDiagFactorDictI 
    //4.1.6.	同义词字典表
	k ^User.DHCDSSSynonymDictD
	k ^User.DHCDSSSynonymDictI	
	//4.1.7.	医学知识分级字典表
	k ^User.DHCDSSKBSClassDictD
	k ^User.DHCDSSKBSClassDictI
	//4.1.8.	系统功能分级字典表
	k ^User.DHCDSSSYSFuncDictD
	k ^User.DHCDSSSYSFuncDictI	
	//4.1.9.	数据集合控件字典表
	k ^User.DHCDSSDataConDictD
	k ^User.DHCDSSDataConDictI	
	//4.1.10.	功能关联数据集合控件表
	k ^User.DHCDSSDataFuncConD
	k ^User.DHCDSSDataFuncConI	
	//4.1.11.	基础信息字典集合表
	k ^User.DHCDSSBasicsDictD
	k ^User.DHCDSSBasicsDictI
	//4.1.12.	数据库表字典表
	k ^User.DHCDSSDataTableDictD
	k ^User.DHCDSSDataTableDictI
	//4.1.13.	检验标本字典表
	k ^User.DHCDSSLabSpecimenDictD
	k ^User.DHCDSSLabSpecimenDictI
	//4.1.14.	用法字典表
	k ^User.DHCDSSUsageDictD
	k ^User.DHCDSSUsageDictI	
	//4.1.15.	频率字典表	
	k ^User.DHCDSSFrequencyDictD
	k ^User.DHCDSSFrequencyDictI		
	//4.1.16.	临床数据类型关联数据字段表
	k ^User.DHCDSSDataJoinFiledDictD
	k ^User.DHCDSSDataJoinFiledDictI	
	//4.1.17.	疾病分科字典表
	k ^User.DHCDSSDiseaseDeptDictD
	k ^User.DHCDSSDiseaseDeptDictI
	
	//检验医嘱字典 20210926
	k ^User.DHCDSSLabOrdersDictD
	k ^User.DHCDSSLabOrdersDictI
	
	//检查结果字典
	k ^User.DHCDSSExamResultDictD
	k ^User.DHCDSSExamResultDictI
	
	
	//症状字典
	k ^User.DHCDSSSymptomDictD
	k ^User.DHCDSSSymptomDictI
	
	//1.3.18.	药物分类字典表
	k ^User.DHCDSSDrugTypeDictD
	k ^User.DHCDSSDrugTypeDictI
	
	//1.3.18.	剂型字典表
	k ^CT.WDT.CDSS.DHCDSSDosageFormD
	k ^CT.WDT.CDSS.DHCDSSDosageFormI
	
	
	//单位字典
	k ^User.DHCDSSUnitDictD
	k ^User.DHCDSSUnitDictI	
	//单位转换表
	k ^User.DHCDSSUnitConversionD
	k ^User.DHCDSSUnitConversionI
	
	//定语字典
	k ^CT.WDT.CDSS.AttributeDictD
	k ^CT.WDT.CDSS.AttributeDictI
	
	
	//评估结果字典
	k ^CT.WDT.CDSS.AssessResultDictD
	k ^CT.WDT.CDSS.AssessResultDictI
	
	//**************文献管理********************/
	//文献表字典V1.0
	k ^User.MKBDocManageD
	k ^User.MKBDocManageI
	
	//***********评估表知识库管理**************************/
	//评估表基本信息
	k ^User.DHCDSSAssBasicInfoD
	k ^User.DHCDSSAssBasicInfoI
	//评估表关联文献表
	k ^User.DHCDSSAssConDocD
	k ^User.DHCDSSAssConDocI
	//评估表关联科室
	k ^User.DHCDSSAssConDeptD 
	k ^User.DHCDSSAssConDeptI	
	//评估表关联关键字
	k ^User.DHCDSSAssKeyWordsD 
	k ^User.DHCDSSAssKeyWordsI
	//评估表关联疾病
	k ^User.DHCDSSDiseJoinAssessmentD
	k ^User.DHCDSSDiseJoinAssessmentI
	//评估表注册表
	k ^User.MKBAssessmentBaseD 
	k ^User.MKBAssessmentBaseI 	
	k ^User.MKBAssessmentBaseC
	//评估表注册字段表
	k ^User.MKBAssessmentBaseFieldI 	
	//评估表评分规则表
	k ^User.MKBAssessmentScoringRulesI 	
	//评估表关联评估结果条件设置表
	k ^CT.WDT.MKB.AssConResCondiD
	k ^CT.WDT.MKB.AssConResCondiI
	
	//评估表关联评估结论表
	k ^CT.WDT.CDSS.AssConResultD
	k ^CT.WDT.CDSS.AssConResultI
	
	//************4.2.	临床疾病知识库****************/
	
	//4.2.1.	疾病字典表
	k ^User.DHCDSSDiseaseDictD 
	k ^User.DHCDSSDiseaseDictI 
	//4.2.2.	疾病关联病情描述表
	k ^User.DHCDSSDiseJoinDescD 
	k ^User.DHCDSSDiseJoinDescI 
	//4.2.3.	疾病关联临床表现表
	k ^User.DHCDSSDiseJoinSymptomD 
	k ^User.DHCDSSDiseJoinSymptomI 	
	//4.2.4.	疾病关联体格检查表
	k ^User.DHCDSSDiseJoinPhysicalED 
	k ^User.DHCDSSDiseJoinPhysicalEI 
	//4.2.5.	疾病关联检验指标表
	k ^User.DHCDSSDiseJoinLabD 
	k ^User.DHCDSSDiseJoinLabI 	
	//4.2.6.	疾病关联检查指标表
	k ^User.DHCDSSDiseJoinExamValD 
	k ^User.DHCDSSDiseJoinExamValI 	
	//4.2.7.	疾病关联病因表
	k ^User.DHCDSSDiseJoinCauseD 
	k ^User.DHCDSSDiseJoinCauseI	
	//4.2.8.	疾病关联病因表
	k ^User.DHCDSSDiseJoinPartD  
	k ^User.DHCDSSDiseJoinPartI 
	//4.2.9.	疾病关联预防表
	k ^User.DHCDSSDiseJoinPreventD  
	k ^User.DHCDSSDiseJoinPreventI 	
	//4.2.10.	疾病关联诊断因子表
	k ^User.DHCDSSDiseJoinFactorD 
	k ^User.DHCDSSDiseJoinFactorI  
	//4.2.11.	疾病关联适用项表
	k ^User.DHCDSSDiseVSConditionD 
	k ^User.DHCDSSDiseVSConditionI  		
	//4.2.12.	疾病关联治疗方案表
	k ^User.DHCDSSDiseJoinTreatD 
	k ^User.DHCDSSDiseJoinTreatI
	//k ^User.DHCDSSDiseJoinTreatC 
	//4.2.13.	治疗方案关联适用项表
	k ^User.DHCDSSTreatVSConditionD 
	k ^User.DHCDSSTreatVSConditionI 	
	//4.2.14.	治疗方案关联禁忌证表
	k ^User.DHCDSSTreatVSTabooD
	k ^User.DHCDSSTreatVSTabooI	
	//4.2.15.	治疗方案关联禁忌证消除条件表
	k ^User.DHCDSSTreatCRD 
	k ^User.DHCDSSTreatCRI 	
	//4.2.16.	治疗方案关联措施表
	k ^User.DHCDSSTreatVSItemD 
	k ^User.DHCDSSTreatVSItemI 	
	//4.2.17.	治疗措施关联子措施表
	k ^User.DHCDSSItemVSChildD
	k ^User.DHCDSSItemVSChildI 
	//4.2.18.	治疗措施关联适用项表
	k ^User.DHCDSSItemVSConditionD
	k ^User.DHCDSSItemVSConditionD
	//4.2.19.	治疗措施关联禁忌证表
	k ^User.DHCDSSItemVSTabooD  
	k ^User.DHCDSSItemVSTabooI 
	//4.2.20.	治疗措施关联禁忌证消除条件表
	k ^User.DHCDSSItemCRD 
	k ^User.DHCDSSItemCRI 
	//4.2.21.	治疗措施关联明细表
	k ^User.DHCDSSItemJoinDetailD 
	k ^User.DHCDSSItemJoinDetailI  
	//治疗方案关联明细表——删除
	//k ^User.DHCDSSTreatJoinDetailI  //治疗方案关联明细表 父表是疾病关联治疗方案表	
	//4.2.22.	治疗措施明细关联用法方案表
	k ^User.DHCDSSItemJoinUsageD  
	k ^User.DHCDSSItemJoinUsageI 
	//4.2.23.	治疗措施用法方案关联适用项表
	k ^User.DHCDSSUsageVSConditionD 
	k ^User.DHCDSSUsageVSConditionI 
	//4.2.24.	治疗措施用法方案关联禁忌症表
	k ^User.DHCDSSTUsageJoinTabooD  
	k ^User.DHCDSSTUsageJoinTabooI 
	//4.2.25.	治疗措施用法方案关联禁忌症消除表
	k ^User.DHCDSSTUsageJoinTabooCRD  
	k ^User.DHCDSSTUsageJoinTabooCRI 
	//4.2.26.	疾病关联并发症表
	k ^User.DHCDSSDiseJoinCompD 
	k ^User.DHCDSSDiseJoinCompI 	
	//4.2.27.	疾病关联预后表
	k ^User.DHCDSSDiseJoinPrognosisD 
	k ^User.DHCDSSDiseJoinPrognosisI 	
	//4.2.28.	疾病关联鉴别诊断表
	k ^User.DHCDSSDiseJoinDiffDiagD
	k ^User.DHCDSSDiseJoinDiffDiagI
	//4.2.29.	疾病关联鉴别诊断详述表
	k ^User.DHCDSSDiseJoinDiffDescD
	k ^User.DHCDSSDiseJoinDiffDescI
	//4.2.30.	疾病详述表	
	k ^User.DHCDSSDiseaseDetailD
	k ^User.DHCDSSDiseaseDetailI
	//4.2.31.	疾病关联辅助检查检验表
	k ^User.DHCDSSDiseJoinExamD
	k ^User.DHCDSSDiseJoinExamI
	//4.2.32.	疾病关联辅助检查检验明细表
	k ^User.DHCDSSDiseJoinDetailD 
	k ^User.DHCDSSDiseJoinDetailI	
	//4.2.33.	疾病关联辅助检查检验评估表
	k ^User.DHCDSSDiseJoinExamAssessD
	k ^User.DHCDSSDiseJoinExamAssessI	
	//4.2.34.	急诊预检分诊分级标准字典表
	k ^User.DHCDSSEmerStandardDictD
	k ^User.DHCDSSEmerStandardDictI		
	//4.2.35.	SNOMEDCT中英文对照
	k ^User.DHCDSSSnomedctDictD 
	k ^User.DHCDSSSnomedctDictI 
	//4.2.36.	疾病关联科室字典表 
	k ^User.DHCDSSDiseJoinDeptD
	k ^User.DHCDSSDiseJoinDeptI	
	//4.2.37.	疾病关联文献资料表
	k ^User.DHCDSSDiseJoinliteratureD 
	k ^User.DHCDSSDiseJoinliteratureI	
	//疾病详述表-展示数据
	k ^User.DHCDSSDiseDetailForViewD  //疾病详述表-展示数据
	k ^User.DHCDSSDiseDetailForViewI  //疾病详述表-展示数据
	
	//疾病关联评估表
	k ^User.DHCDSSDiseJoinAssessmentD
	k ^User.DHCDSSDiseJoinAssessmentI
	
	//************4.3.	评估量表知识库表****************/
	
	//4.3.1.	评分量表字典表
	k ^User.DHCDSSRatingScaleDictD 
	k ^User.DHCDSSRatingScaleDictI 
	//4.3.2.	评估量表评估表
	k ^User.DHCDSSRatingScaleAssessD 
	k ^User.DHCDSSRatingScaleAssessI 
	
	//*************4.4.	体格检查知识库表*****************/
	
	//4.4.1.	体格检查字典表
	k ^User.DHCDSSPhysicalExamDictD 
	k ^User.DHCDSSPhysicalExamDictI 	
	
	//*************4.5.	诊疗规则知识库表*****************/
	
	//4.5.1.	诊疗规则字典表
	k ^User.DHCDSSMedicalRuleD
	k ^User.DHCDSSMedicalRuleI
	//4.5.2.	诊疗规则关联规则条件表
	k ^User.DHCDSSRuleTriggerD
	k ^User.DHCDSSRuleTriggerI	
	//4.5.3.	诊疗规则规则条件关联子规则条件表
	k ^User.DHCDSSChildRuleTriggerD
	k ^User.DHCDSSChildRuleTriggerI	
	//4.5.4.	诊疗规则申请操作记录表
	k ^User.DHCDSSRuleApplyRecordD
	k ^User.DHCDSSRuleApplyRecordI	
	
	//推荐疑似疾病中单一规则表 2020-11-17
	k ^User.DHCDSSSingleSymptomRuleD
	k ^User.DHCDSSSingleSymptomRuleI	

	//阻断医嘱表 2021-08-12
	k ^User.DHCDSSBlockOrderListD
	k ^User.DHCDSSBlockOrderListI
	//特殊诊疗规则配置表 2021-08-12
	k ^User.DHCDSSSpecialRuleConfigD	
	k ^User.DHCDSSSpecialRuleConfigI
		
	//*************4.6.	质控规则知识库表*****************/	
	//4.6.1.	质控规则字典表
	k ^User.DHCDSSQCRuleDictD
	k ^User.DHCDSSQCRuleDictI
	//4.6.2.	质控规则关联条件表
	k ^User.DHCDSSQCRJoinConditionD
	k ^User.DHCDSSQCRJoinConditionI	
	//4.6.3.	质控规则条件关联子条件表
	k ^User.DHCDSSQCRJoinSConditionD
	k ^User.DHCDSSQCRJoinSConditionI	
	//4.6.4.	质控规则操作记录表
	k ^User.DHCDSSQCRJoinRecordD
	k ^User.DHCDSSQCRJoinRecordI	
	
	//*************4.7.	临床输血知识库*****************/	
	//4.7.1.	血型字典表
	k ^User.DHCDSSBloodTypeDictD
	k ^User.DHCDSSBloodTypeDictI	
	//4.7.2.	输血品分类字典表
	k ^User.DHCDSSBPClassDictD 
	k ^User.DHCDSSBPClassDictI	
	//4.7.3.	输血品字典表	
	k ^User.DHCDSSBloodProductDictD
	k ^User.DHCDSSBloodProductDictI 
	//4.7.4.	输血品关联血型
	k ^User.DHCDSSBPJoinBloodTypeD
	k ^User.DHCDSSBPJoinBloodTypeI
	//4.7.5.	输血品关联适用项
	k ^User.DHCDSSBPJoinIndicationD
	k ^User.DHCDSSBPJoinIndicationI	
	//4.7.6.	输血品关联禁忌症
	k ^User.DHCDSSBPJoinTabooD
	k ^User.DHCDSSBPJoinTabooI
	//4.7.7.	输血品关联禁忌症消除条件
	k ^User.DHCDSSBPJoinTabooRemoveD
	k ^User.DHCDSSBPJoinTabooRemoveI
	//4.7.8.	输血品关联注意事项
	k ^User.DHCDSSBPJoinPrecautionsD
	k ^User.DHCDSSBPJoinPrecautionsI	
	//4.7.9.	输血品关联不良反应
	k ^User.DHCDSSBPJoinARD
	k ^User.DHCDSSBPJoinARI	
	//4.7.10.	输血品关联疾病	
	k ^User.DHCDSSBPJoinDiseaseD
	k ^User.DHCDSSBPJoinDiseaseI
	//4.7.11.	输血品关联并发症
	k ^User.DHCDSSBPJoinComplicationD
	k ^User.DHCDSSBPJoinComplicationI	
	//4.7.12.	输血品关联替代制品
	k ^User.DHCDSSBPJoinSubstituteD
	k ^User.DHCDSSBPJoinSubstituteI	
	
	//*************	4.8.	临床护理知识库*****************/	
	//4.8.1.	护理分类字典表
	k ^User.DHCDSSNursingClassDictD
	k ^User.DHCDSSNursingClassDictI	
	//4.8.2.	护理分级字典表
	k ^User.DHCDSSNursingGradeDictD 
	k ^User.DHCDSSNursingGradeDictI	
	//4.8.3.	护理项目字典表	
	k ^User.DHCDSSNursingDictD
	k ^User.DHCDSSNursingDictI 
	//4.8.4.	护理明细表
	k ^User.DHCDSSNursingJoinDetailD
	k ^User.DHCDSSNursingJoinDetailI
	//4.8.5.	护理项目关联器械表
	k ^User.DHCDSSNursingJoinInstruD
	k ^User.DHCDSSNursingJoinInstruI	
	//4.8.6.	护理项目关联部位表
	k ^User.DHCDSSNursingJoinPartD
	k ^User.DHCDSSNursingJoinPartI
	//4.8.7.	护理项目关联适用项表
	k ^User.DHCDSSNursingJoinIndicD
	k ^User.DHCDSSNursingJoinIndicI
	//4.8.8.	护理项目关联禁忌症表
	k ^User.DHCDSSNursingJoinTabooD
	k ^User.DHCDSSNursingJoinTabooI	
	//4.8.9.	护理项目关联禁忌症消除表
	k ^User.DHCDSSNursingJoinTabooRD
	k ^User.DHCDSSNursingJoinTabooRI	
	//4.8.10.	护理项目关联不良反应表
	k ^User.DHCDSSNursingJoinARD
	k ^User.DHCDSSNursingJoinARI
	//4.8.11.	护理项目关联注意事项表
	k ^User.DHCDSSNursingJoinPreD
	k ^User.DHCDSSNursingJoinPreI	
	//4.8.12.	护理项目关联疾病表
	k ^User.DHCDSSNursingJoinDiseaseD
	k ^User.DHCDSSNursingJoinDiseaseI	
	//4.8.13.	护理项目关联并发症表		
	k ^User.DHCDSSNursingJoinCompD
	k ^User.DHCDSSNursingJoinCompI	
	//4.8.14.	护理项目关联评估量表
	k ^User.DHCDSSNursingJoinRSD
	k ^User.DHCDSSNursingJoinRSI	
	
	//*************4.9.	临床药物知识库*****************/	
	//4.9.1.	药物分类字典表
	k ^User.DHCDSSDrugClassDictD
	k ^User.DHCDSSDrugClassDictI	
	//4.9.2.	药物字典表
	k ^User.DHCDSSDrugDictD
	k ^User.DHCDSSDrugDictI	
	//4.9.3.	药物关联适用项表
	k ^User.DHCDSSDrugJoinIndicationD
	k ^User.DHCDSSDrugJoinIndicationI	
	//4.9.4.	药物关联用法方案表
	k ^User.DHCDSSDrugJoinUsageD
	k ^User.DHCDSSDrugJoinUsageI	
	//4.9.5.	药物用法方案关联适用项表
	k ^User.DHCDSSUsageJoinIndicationD
	k ^User.DHCDSSUsageJoinIndicationI	
	//4.9.6.	药物用法方案关联禁忌症表
	k ^User.DHCDSSUsageJoinTabooD
	k ^User.DHCDSSUsageJoinTabooI	
	//4.9.7.	药物用法方案关联禁忌症消除表
	k ^User.DHCDSSUsageJoinTabooCRD
	k ^User.DHCDSSUsageJoinTabooCRI	
	//4.9.8.	药物关联不良反应表
	k ^User.DHCDSSDrugARD
	k ^User.DHCDSSDrugARI	
	//4.9.9.	药物关联禁忌症表
	k ^User.DHCDSSDrugContraindicaD
	k ^User.DHCDSSDrugContraindicaI	
	//4.9.10.	药物关联禁忌症消除条件表
	k ^User.DHCDSSDrugCRD
	k ^User.DHCDSSDrugCRI	
	//4.9.11.	药物关联辅料表
	k ^User.DHCDSSDrugAccessoriesD
	k ^User.DHCDSSDrugAccessoriesI
	//4.9.12.	药物关联相互作用表	
	//4.9.13.	药物关联过量使用表
	k ^User.DHCDSSDrugJoinOverdoseD
	k ^User.DHCDSSDrugJoinOverdoseI		
	
	//*************4.10.	临床医学检验知识库表*****************/	
	//4.10.1.	检验分类字典表
	k ^User.DHCDSSLabClassDictD
	k ^User.DHCDSSLabClassDictI	
	//	4.10.2.	检验字典表
	k ^User.DHCDSSLabInspectionDictD 
	k ^User.DHCDSSLabInspectionDictI	
	//4.10.3.	检验明细字典表		
	k ^User.DHCDSSInspectionDetailD
	k ^User.DHCDSSInspectionDetailI 
	//4.10.4.	检验项目关联标本表
	k ^User.DHCDSSLabJoinSpecimenD
	k ^User.DHCDSSLabJoinSpecimenI
	//4.10.5.	检验项目关联器械（药物）表
	k ^User.DHCDSSLabJoinInstruD
	k ^User.DHCDSSLabJoinInstruI	
	//4.10.6.	检验项目关联适用项表
	k ^User.DHCDSSLabJoinIndicationD
	k ^User.DHCDSSLabJoinIndicationI
	//4.10.7.	检验项目关联禁忌症表
	k ^User.DHCDSSLabJoinTabooD
	k ^User.DHCDSSLabJoinTabooI
	//4.10.8.	检验项目关联禁忌症消除表
	k ^User.DHCDSSLabJoinTabooRemoveD
	k ^User.DHCDSSLabJoinTabooRemoveI	
	//4.10.9.	检验项目关联不良反应表
	k ^User.DHCDSSLabJoinARD
	k ^User.DHCDSSLabJoinARI	
	//4.10.10.	检验项目关联注意事项表	
	k ^User.DHCDSSLabJoinPrecautionD
	k ^User.DHCDSSLabJoinPrecautionI
	//4.10.11.	检验项目关联疾病表
	k ^User.DHCDSSLabJoinDiagnosisD
	k ^User.DHCDSSLabJoinDiagnosisI	
	//4.10.12.	检验结果辅助诊断表
	k ^User.DHCDSSLabJoinResultD
	k ^User.DHCDSSLabJoinResultI		
	
	//***********4.11.	临床医学检查知识库表****************/
	//4.11.1.	检查分类字典表
	k ^User.DHCDSSExamClassDictD 
	k ^User.DHCDSSExamClassDictI 	
	//4.11.2.	检查字典表
	k ^User.DHCDSSExamDictD 
	k ^User.DHCDSSExamDictI 
	//4.11.3.	检查项目关联部位表
	k ^User.DHCDSSExamJoinPartsD
	k ^User.DHCDSSExamJoinPartsI
	//4.11.4.	检查项目关联器械（药物）表
	k ^User.DHCDSSExamJoinInstruD
	k ^User.DHCDSSExamJoinInstruI
	//4.11.5.	检查项目关联适用项表
	k ^User.DHCDSSExamIndicationD
	k ^User.DHCDSSExamIndicationI
	//	4.11.6.	检查项目关联禁忌症表
	k ^User.DHCDSSExamContraindicaD
	k ^User.DHCDSSExamContraindicaI	
	//4.11.7.	检查项目关联禁忌症消除条件表
	k ^User.DHCDSSExamCRD
	k ^User.DHCDSSExamCRI	
	//4.11.8.	检查项目关联不良反应表
	k ^User.DHCDSSExamARD
	k ^User.DHCDSSExamARI	
	//4.11.9.	检查项目关联注意事项表
	k ^User.DHCDSSExamPrecautionsD
	k ^User.DHCDSSExamPrecautionsI	
	//4.11.10.	检查项目关联疾病表
	k ^User.DHCDSSExamJoinDiagD
	k ^User.DHCDSSExamJoinDiagI	

	//*************	4.12.	临床手术知识库表*****************/	
	//4.12.1.	手术分级字典表
	k ^User.DHCDSSOperationGradeDictD
	k ^User.DHCDSSOperationGradeDictI	
	//4.12.2.	手术字典表
	k ^User.DHCDSSOperationDictD 
	k ^User.DHCDSSOperationDictI	
	//4.12.3.	手术详述表	
	k ^User.DHCDSSOperationDescD
	k ^User.DHCDSSOperationDescI 
	//4.12.4.	手术关联部位
	k ^User.DHCDSSOperJoinBodyPartD
	k ^User.DHCDSSOperJoinBodyPartI
	//4.12.5.	手术关联器械（药物）表
	k ^User.DHCDSSOperJoinInstruD
	k ^User.DHCDSSOperJoinInstruI	
	//4.12.6.	手术关联疾病
	k ^User.DHCDSSOperJoinDiseaseD
	k ^User.DHCDSSOperJoinDiseaseI
	//4.12.7.	手术关联适用项
	k ^User.DHCDSSOperJoinIndicationD
	k ^User.DHCDSSOperJoinIndicationI
	//4.12.8.	手术关联禁忌症
	k ^User.DHCDSSOperJoinTabooD
	k ^User.DHCDSSOperJoinTabooI	
	//4.12.9.	手术关联禁忌症消除条件
	k ^User.DHCDSSOperJoinTabooRD
	k ^User.DHCDSSOperJoinTabooRI	
	//4.12.10.	手术关联并发症
	k ^User.DHCDSSOperJoinCompD
	k ^User.DHCDSSOperJoinCompI
	//4.12.11.	手术关联麻醉方式
	k ^User.DHCDSSOperJoinAnesthesiaD
	k ^User.DHCDSSOperJoinAnesthesiaI	
	//4.12.12.	手术关联术前准备
	k ^User.DHCDSSOperJoinPreoperatD
	k ^User.DHCDSSOperJoinPreoperatI	
	//4.12.13.	手术关联切口
	//4.12.14.	手术关联止血
	//4.12.15.	手术关联引流
	//4.12.16.	手术关联操作步骤	
	k ^User.DHCDSSOperJoinDrocedureD
	k ^User.DHCDSSOperJoinDrocedureI	
	//4.12.17.	手术关联结扎
	//4.12.18.	手术关联缝合
	//4.12.19.	手术关联术后护理
	k ^User.DHCDSSOperJoinPostoperatD
	k ^User.DHCDSSOperJoinPostoperatI	
	//4.12.20.	手术关联注意事项
	k ^User.DHCDSSOperJoinPrecautionD
	k ^User.DHCDSSOperJoinPrecautionI
	//4.12.21.	手术关联术后饮食
	k ^User.DHCDSSOperJoinDietD
	k ^User.DHCDSSOperJoinDietI		
	
	//***********4.13.	病案知识库表*************/	
	//4.13.1.	病案记录表
	k ^User.DHCDSSMedicalRecordD
	k ^User.DHCDSSMedicalRecordI
	
	//决策知识库与医为百科对照 20200923 GXP
	k ^User.DHCDSSWikiCMKBContrastD
	k ^User.DHCDSSWikiCMKBContrastI	
	
	//对接方字典 20200925 GXP
	//2021-03-20  GXP 用导临时global的方法更新某一个项目的数据:w ##class(web.CDSS.CMKB.MappingGlobalInfo).GetTempGlobalToMKBTable()
	/*k ^User.DHCDSSInterfaceDictD
	k ^User.DHCDSSInterfaceDictI
	
	//对接方字典分类表 20200925 GXP
	k ^User.DHCDSSInterfaceClassDictD 
	k ^User.DHCDSSInterfaceClassDictI	
	
	//字典对照 20200925 GXP
	k ^User.DHCDSSInterDictMappingD 
	k ^User.DHCDSSInterDictMappingI	*/
	
	//*************实施管理平台****************/
	//医院表：
	k ^User.DHCDSSCustomerHospD
	k ^User.DHCDSSCustomerHospI
	k ^User.DHCDSSCustomerHospC
	
	//院区
	k ^CT.WDT.CDSS.CustomerHospAreaI
	//规则表：
	k ^User.DHCDSSHospLinkRulesD
	k ^User.DHCDSSHospLinkRulesI
	//记录类型表
	k ^User.DHCDSSRecordTypeD
	k ^User.DHCDSSRecordTypeI
	//映射属性表
	k ^User.DHCDSSMapPropertyD
	k ^User.DHCDSSMapPropertyI
	//模板配置表
	k ^User.DHCDSSTemplateConfigD
	k ^User.DHCDSSTemplateConfigI
	//模板配置子表
	k ^User.DHCDSSTemplateConfigItemD
	k ^User.DHCDSSTemplateConfigItemI
	
	//***********文献管理**************************/
	//文献表
	k ^User.DHCDSSDocuManageD
	k ^User.DHCDSSDocuManageI
	//文献关联诊断
	k ^User.DHCDSSDocuJoinDiseaseD
	k ^User.DHCDSSDocuJoinDiseaseI
	//文献关联科室
	k ^User.DHCDSSDocuJoinDeptD
	k ^User.DHCDSSDocuJoinDeptI	
	//文献详情
	k ^User.DHCDSSDocuDetailD
	k ^User.DHCDSSDocuDetailI
	//4.4.5.	文献发布机构表
	k ^User.DHCDSSDocuAgencyD 
	k ^User.DHCDSSDocuAgencyI 	
	
	
	//***********百科管理**************************/
	//知识库注册
	k ^CT.WDT.CDSS.TermBaseD	//术语库注册表 
	k ^CT.WDT.CDSS.TermBaseI	//术语库注册表 
	k ^CT.WDT.CDSS.TermBasePropertyI	//术语库注册属性表 
	k ^CT.WDT.CDSS.TermBasePropertyD	//术语库注册属性表
	k ^CT.WDT.CDSS.TermBasePropertyC	//术语库注册属性表	
 	k ^CT.WDT.CDSS.TermBaseExtendProI	//术语库注册扩展属性表
 	
 	//知识管理
 	k ^CT.WDT.CDSS.TermD	//术语表
 	k ^CT.WDT.CDSS.TermI	//术语表
	k ^CT.WDT.CDSS.TermPropertyD	//术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyI	//术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyC	//术语属性表
	k ^CT.WDT.CDSS.TermExtendProI	//术语扩展属性表
	k ^CT.WDT.CDSS.TermProDetailD	//术语属性内容表
	k ^CT.WDT.CDSS.TermProDetailI	//术语属性内容表
	k ^CT.WDT.CDSS.TermExtendProValD	//扩展属性值表
	k ^CT.WDT.CDSS.TermExtendProValI	//扩展属性值表
	
	
	 //平台配置
	//k ^User.MKBConfigD  
	//k ^User.MKBConfigI 
	
	//4.1.12.	医学组数据统计配置表
	//k ^CF.WDT.CDSS.StatisticsConfigD
	//k ^CF.WDT.CDSS.StatisticsConfigI
	
	//***********文献管理**************************/
	//文献表
	k ^User.DHCDSSDocuManageD
	k ^User.DHCDSSDocuManageI
	//文献关联诊断
	k ^User.DHCDSSDocuJoinDiseaseD
	k ^User.DHCDSSDocuJoinDiseaseI
	//文献关联科室
	k ^User.DHCDSSDocuJoinDeptD
	k ^User.DHCDSSDocuJoinDeptI	
	//文献详情
	k ^User.DHCDSSDocuDetailD
	k ^User.DHCDSSDocuDetailI
	//4.4.5.	文献发布机构表
	k ^User.DHCDSSDocuAgencyD 
	k ^User.DHCDSSDocuAgencyI 
	
	//	4.22.1.	全文检索配置表
	k ^CF.WDT.CDSS.ALLDictSearchSetD
	k ^CF.WDT.CDSS.ALLDictSearchSetI
	
	//	4.22.2.	全文索引
	k ^CF.WDT.CDSS.ALLDictIndexD
	k ^CF.WDT.CDSS.ALLDictIndexI
	
			
	q "over"
}

/// Creator:丁亚男
/// CreatDate:2020-04-30
/// Description：删除患者信息相关的数据
/// Table：患者信息的所有表
/// Input：
/// Output：
/// 导出数据用d ##class(web.CDSS.Public.CDSSDataBackup).ExportPatientGlobal("D:\CDSSGlobal\NewTable\")
ClassMethod ExportPatientGlobal(filePath)
{
	k CList
	k myIdx
	//s CList($i(CList))= "User.DHCPHLibCatD.GBL"  
	//s CList($i(CList))= "User.DHCPHLibCatI.GBL"
	
	//患者信息表
	s CList($i(CList))= "User.DHCDSSPatientMasterD.GBL"  ;4.14.1患者基础信息表
	s CList($i(CList))= "User.DHCDSSPatientMasterI.GBL"
	s CList($i(CList))= "User.DHCDSSPatientVisitD.GBL"  ;4.14.2患者就诊信息表
	s CList($i(CList))= "User.DHCDSSPatientVisitI.GBL"
	s CList($i(CList))= "User.DHCDSSSignInfoD.GBL" ;4.14.3患者体征信息表
	s CList($i(CList))= "User.DHCDSSSignInfoI.GBL"
	s CList($i(CList))= "User.DHCDSSChiefCompInfoD.GBL" ;4.14.4患者主诉信息表
	s CList($i(CList))= "User.DHCDSSChiefCompInfoI.GBL"
	s CList($i(CList))= "User.DHCDSSCurrentMedHistoryD.GBL"  ;4.14.5患者现病史信息表
	s CList($i(CList))= "User.DHCDSSCurrentMedHistoryI.GBL"
	s CList($i(CList))= "User.DHCDSSPastDiagnosisD.GBL"  ;4.14.6.1患者既往史信息表
	s CList($i(CList))= "User.DHCDSSPastDiagnosisI.GBL"  
	s CList($i(CList))= "User.DHCDSSPersonalInfoD.GBL" ;4.14.6.2患者个人史
	s CList($i(CList))= "User.DHCDSSPersonalInfoI.GBL"  
	s CList($i(CList))= "User.DHCDSSMarryInfoD.GBL"   ;4.14.6.3患者婚育史
	s CList($i(CList))= "User.DHCDSSMarryInfoI.GBL"
	s CList($i(CList))= "User.DHCDSSFamilyHisInfoD.GBL"  ;4.14.6.4患者家族史
	s CList($i(CList))= "User.DHCDSSFamilyHisInfoI.GBL"  
	s CList($i(CList))= "User.DHCDSSAllergyHistoryD.GBL"  ;4.14.6.5过敏史信息
	s CList($i(CList))= "User.DHCDSSAllergyHistoryI.GBL"  
	s CList($i(CList))= "User.DHCDSSPhysicalExamD.GBL" ;4.14.7体格检查信息表
	s CList($i(CList))= "User.DHCDSSPhysicalExamI.GBL"  
	s CList($i(CList))= "User.DHCDSSSpecExamD.GBL" ;4.14.8患者专科检查表
	s CList($i(CList))= "User.DHCDSSSpecExamI.GBL"  
	s CList($i(CList))= "User.DHCDSSDiagnosisInfoD.GBL" ;4.14.9患者诊断信息表
	s CList($i(CList))= "User.DHCDSSDiagnosisInfoI.GBL"
	s CList($i(CList))= "User.DHCDSSDrugInfoD.GBL"  ;4.14.10患者处方信息表
	s CList($i(CList))= "User.DHCDSSDrugInfoI.GBL"	
	s CList($i(CList))= "User.DHCDSSExamInfoD.GBL" ;4.14.11患者检查信息表
	s CList($i(CList))= "User.DHCDSSExamInfoI.GBL"  
	s CList($i(CList))= "User.DHCDSSLabInfoD.GBL" ;4.14.12患者检验信息表
	s CList($i(CList))= "User.DHCDSSLabInfoI.GBL"  
	s CList($i(CList))= "User.DHCDSSOperationInfoD.GBL" ;4.14.13患者手术信息表
	s CList($i(CList))= "User.DHCDSSOperationInfoI.GBL"
	s CList($i(CList))= "User.DHCDSSAnestInfoD.GBL"  ;4.14.14患者麻醉信息表
	s CList($i(CList))= "User.DHCDSSAnestInfoI.GBL" 
	s CList($i(CList))= "User.DHCDSSNursingInfoD.GBL" ;4.14.15患者护理信息表
	s CList($i(CList))= "User.DHCDSSNursingInfoI.GBL"  
	s CList($i(CList))= "User.DHCDSSBloodTransInfoD.GBL"  ;4.14.16患者输血信息表
	s CList($i(CList))= "User.DHCDSSBloodTransInfoI.GBL" 
	s CList($i(CList))= "User.DHCDSSDietInfoD.GBL"   ;4.14.17患者饮食信息表
	s CList($i(CList))= "User.DHCDSSDietInfoI.GBL"
	s CList($i(CList))= "User.DHCDSSClinicalFeatureD.GBL"  ;4.14.18临床表现信息表
	s CList($i(CList))= "User.DHCDSSClinicalFeatureI.GBL" 
	s CList($i(CList))= "User.DHCDSSClinicalFDetailedD.GBL"  ;4.14.19临床表现明细表
	s CList($i(CList))= "User.DHCDSSClinicalFDetailedI.GBL" 
	s CList($i(CList))= "User.DHCDSSOtherOrderInfoD.GBL"   ;4.14.20患者其他医嘱信息表
	s CList($i(CList))= "User.DHCDSSOtherOrderInfoI.GBL" 
	s CList($i(CList))= "User.DHCDSSInpatientInfoD.GBL"  ;4.14.21.1患者住院病历信息表
	s CList($i(CList))= "User.DHCDSSInpatientInfoI.GBL"
	s CList($i(CList))= "User.DHCDSSCarryDrugD.GBL" ;4.14.22.1患者出院带药信息表
	s CList($i(CList))= "User.DHCDSSCarryDrugI.GBL"
	s CList($i(CList))= "User.DHCDSSOtherDisOrderInfoD.GBL"  ;4.14.22.2患者其他出院医嘱信息表
	s CList($i(CList))= "User.DHCDSSOtherDisOrderInfoI.GBL"
	
	/******* 4.15 业务功能表******/
	//	4.15.1.	患者推荐疑似疾病记录表
	s CList($i(CList))= "User.DHCDSSRecomDiseaseInfoD.GBL"
	s CList($i(CList))= "User.DHCDSSRecomDiseaseInfoI.GBL"	
	//4.15.2.	患者推荐评估量表记录表
	s CList($i(CList))= "User.DHCDSSRecomRatingInfoD.GBL" 
	s CList($i(CList))= "User.DHCDSSRecomRatingInfoI.GBL"	
	//4.15.3.	患者评估量表记录表	
	s CList($i(CList))= "User.DHCDSSPatientRatingScaleD.GBL"
	s CList($i(CList))= "User.DHCDSSPatientRatingScaleI.GBL" 
	//4.15.4.	推荐治疗方案记录表
	s CList($i(CList))= "User.DHCDSSRecomTreatInfoD.GBL"
	s CList($i(CList))= "User.DHCDSSRecomTreatInfoI.GBL"
	//4.15.5.	患者治疗方案记录表
	s CList($i(CList))= "User.DHCDSSExecuteTreatInfoD.GBL"
	s CList($i(CList))= "User.DHCDSSExecuteTreatInfoI.GBL"	
	//4.15.6.	患者治疗方案关联明细表
	s CList($i(CList))= "User.DHCDSSETreatJoinDetailD.GBL"
	s CList($i(CList))= "User.DHCDSSETreatJoinDetailI.GBL"
	//4.15.7.	患者预警信息记录表
	s CList($i(CList))= "User.DHCDSSWarnInfoD.GBL"
	s CList($i(CList))= "User.DHCDSSWarnInfoI.GBL"
	//4.15.8.	写回信息记录表
	s CList($i(CList))= "User.DHCDSSWriteBackInfoD.GBL"
	s CList($i(CList))= "User.DHCDSSWriteBackInfoI.GBL"	
	
	
	/******* 4.16.	系统功能******/
	//4.16.1.	用户字典表
	s CList($i(CList))= "User.DHCDSSUserDictD.GBL"
	s CList($i(CList))= "User.DHCDSSUserDictI.GBL"	
	//4.16.2.	角色字典表
	s CList($i(CList))= "User.DHCDSSRoleDictD.GBL"
	s CList($i(CList))= "User.DHCDSSRoleDictI.GBL"
	//4.16.3.	科室字典表
	s CList($i(CList))= "User.DHCDSSDeptDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDeptDictI.GBL"	
	//4.16.4.	用户关联科室表
	s CList($i(CList))= "User.DHCDSSUserJoinDeptD.GBL"
	s CList($i(CList))= "User.DHCDSSUserJoinDeptI.GBL"	
	//4.16.5.	用户关联角色	
	s CList($i(CList))= "User.DHCDSSUserJoinRoleD.GBL"
	s CList($i(CList))= "User.DHCDSSUserJoinRoleI.GBL"	
	//4.16.6.	角色关联功能
	s CList($i(CList))= "User.DHCDSSRoleJoinFunctionD.GBL"
	s CList($i(CList))= "User.DHCDSSRoleJoinFunctionI.GBL"	
	
	
	//把所有GBL拼起来
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","
		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"PatientData"_time_".gof" 
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	q "ok"
}

/// Creator:丁亚男
/// CreatDate:2020-04-30
/// Description：删除患者信息相关的数据
/// Table：患者信息的所有表
/// Input：
/// Output：
/// w ##class(web.CDSS.Public.CDSSDataBackup).KillPatientGlobal()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","PatientGlobal.gof")
ClassMethod KillPatientGlobal()
{
	//患者信息相关的所有表
	k ^User.DHCDSSPatientMasterD ;4.14.1.	患者基础信息表
	k ^User.DHCDSSPatientMasterI 
	k ^User.DHCDSSPatientVisitD  ;4.14.2.	就诊信息表
	k ^User.DHCDSSPatientVisitI
	k ^User.DHCDSSSignInfoD  ;4.14.3.	体征信息表
	k ^User.DHCDSSSignInfoI
	k ^User.DHCDSSChiefCompInfoD  ;4.14.4.	主诉信息表
	k ^User.DHCDSSChiefCompInfoI
	k ^User.DHCDSSCurrentMedHistoryD ;4.14.5.	现病史信息表
	k ^User.DHCDSSCurrentMedHistoryI
	k ^User.DHCDSSPastDiagnosisD ;4.14.6.1.	既往史信息表
	k ^User.DHCDSSPastDiagnosisI
	k ^User.DHCDSSPersonalInfoD  ;4.14.6.2.	个人史信息表
	k ^User.DHCDSSPersonalInfoI
	k ^User.DHCDSSMarryInfoD  ;4.14.6.3.	婚育史信息表
	k ^User.DHCDSSMarryInfoI   
	k ^User.DHCDSSFamilyHisInfoD  ;4.14.6.4.	家族史信息表
	k ^User.DHCDSSFamilyHisInfoI
	k ^User.DHCDSSAllergyHistoryD    ;4.14.6.5.	过敏史信息表
	k ^User.DHCDSSAllergyHistoryI
	k ^User.DHCDSSPhysicalExamD ;4.14.7.	体格检查表
	k ^User.DHCDSSPhysicalExamI  
	k ^User.DHCDSSSpecExamD ;4.14.8.	专科检查表
	k ^User.DHCDSSSpecExamI  
	k ^User.DHCDSSDiagnosisInfoD ;4.14.9.	诊断信息表
	k ^User.DHCDSSDiagnosisInfoI
	k ^User.DHCDSSDrugInfoD  ;4.14.10.	处方信息表
	k ^User.DHCDSSDrugInfoI
	
	k ^User.DHCDSSExamInfoD  ;4.14.11.	检查信息表
	k ^User.DHCDSSExamInfoI
	k ^User.DHCDSSLabInfoD ;4.14.12.	检验信息表
	k ^User.DHCDSSLabInfoI
	k ^User.DHCDSSOperationInfoD  ;4.14.13.	手术信息表
	k ^User.DHCDSSOperationInfoI  
	k ^User.DHCDSSAnestInfoD ;4.14.14.	麻醉信息表
	k ^User.DHCDSSAnestInfoI
	k ^User.DHCDSSNursingInfoD  ;4.14.15.	护理信息表
	k ^User.DHCDSSNursingInfoI
	k ^User.DHCDSSBloodTransInfoD ;4.14.16.	输血信息表
	k ^User.DHCDSSBloodTransInfoI
	k ^User.DHCDSSDietInfoD  ;4.14.17.	饮食信息表
	k ^User.DHCDSSDietInfoI
	k ^User.DHCDSSClinicalFeatureD ;4.14.18.	临床表现信息表
	k ^User.DHCDSSClinicalFeatureI
	k ^User.DHCDSSClinicalFDetailedD ;4.14.19.	临床表现明细表
	k ^User.DHCDSSClinicalFDetailedI
	
	k ^User.DHCDSSOtherOrderInfoD ;4.14.20.	其他在院医嘱信息
	k ^User.DHCDSSOtherOrderInfoI
	k ^User.DHCDSSInpatientInfoD  ;4.14.21.1.	病历信息表
	k ^User.DHCDSSInpatientInfoI
	
	k ^User.DHCDSSCarryDrugD   ;4.14.22.1.	出院带药信息表
	k ^User.DHCDSSCarryDrugI
	k ^User.DHCDSSOtherDisOrderInfoD ;4.14.22.2.	其他出院医嘱信息表
	k ^User.DHCDSSOtherDisOrderInfoI
	
	/******* 4.15 业务功能表******/
	//	4.15.1.	患者推荐疑似疾病记录表
	k ^User.DHCDSSRecomDiseaseInfoD
	k ^User.DHCDSSRecomDiseaseInfoI
		
	//4.15.2.	患者推荐评估量表记录表
	k ^User.DHCDSSRecomRatingInfoD
	k ^User.DHCDSSRecomRatingInfoI	
	//4.15.3.	患者评估量表记录表
	k ^User.DHCDSSPatientRatingScaleD
	k ^User.DHCDSSPatientRatingScaleI 
	//4.15.4.	推荐治疗方案记录表
	k ^User.DHCDSSRecomTreatInfoD
	k ^User.DHCDSSRecomTreatInfoI
	//4.15.5.	患者治疗方案记录表
	k ^User.DHCDSSExecuteTreatInfoD
	k ^User.DHCDSSExecuteTreatInfoI	
	//4.15.6.	患者治疗方案关联明细表
	k ^User.DHCDSSETreatJoinDetailD
	k ^User.DHCDSSETreatJoinDetailI
	//4.15.7.	患者预警信息记录表
	k ^User.DHCDSSWarnInfoD
	k ^User.DHCDSSWarnInfoI
	//4.15.8.	写回信息记录表
	k ^User.DHCDSSWriteBackInfoD
	k ^User.DHCDSSWriteBackInfoI
	
	/******* 4.16.	系统功能******/
	//4.16.1.	用户字典表
	k ^User.DHCDSSUserDictD
	k ^User.DHCDSSUserDictI
	//4.16.2.	角色字典表
	k ^User.DHCDSSRoleDictD
	k ^User.DHCDSSRoleDictI
	//4.16.3.	科室字典表
	k ^User.DHCDSSDeptDictD
	k ^User.DHCDSSDeptDictI
	//4.16.4.	用户关联科室表
	k ^User.DHCDSSUserJoinDeptD
	k ^User.DHCDSSUserJoinDeptI	
	//4.16.5.	用户关联角色
	k ^User.DHCDSSUserJoinRoleD
	k ^User.DHCDSSUserJoinRoleI
	//4.16.6.	角色关联功能
	k ^User.DHCDSSRoleJoinFunctionD
	k ^User.DHCDSSRoleJoinFunctionI
	
	
	q "ok"
}

/// Creator:丁亚男
/// CreatDate:2020-04-30
/// Description：删除患者信息相关的数据
/// Table：患者信息的所有表
/// Input：
/// Output：
/// 导出数据用d ##class(web.CDSS.Public.CDSSDataBackup).BuildPatientIndices()
ClassMethod BuildPatientIndices()
{
	
	//患者信息表
	d ##class(User.DHCDSSPatientMaster).%BuildIndices()   ;4.14.1患者基础信息表
	
	d ##class(User.DHCDSSPatientVisit).%BuildIndices()    ;4.14.2患者就诊信息表
	
	d ##class(User.DHCDSSSignInfo).%BuildIndices()   ;4.14.3患者体征信息表
	
	d ##class(User.DHCDSSChiefCompInfo).%BuildIndices()  ;4.14.4患者主诉信息表
	
	d ##class(User.DHCDSSCurrentMedHistory).%BuildIndices()   ;4.14.5患者现病史信息表
	
	d ##class(User.DHCDSSPastDiagnosis).%BuildIndices()   ;4.14.6.1患者既往史信息表
	
	d ##class(User.DHCDSSPersonalInfo).%BuildIndices()   ;4.14.6.2患者个人史
	
	d ##class(User.DHCDSSMarryInfo).%BuildIndices()    ;4.14.6.3患者婚育史
	
	d ##class(User.DHCDSSFamilyHisInfo).%BuildIndices()    ;4.14.6.4患者家族史
	
	d ##class(User.DHCDSSAllergyHistory).%BuildIndices()  ;4.14.6.5过敏史信息
	 
	d ##class(User.DHCDSSPhysicalExam).%BuildIndices() ;4.14.7体格检查信息表
	
	d ##class(User.DHCDSSSpecExam).%BuildIndices() ;4.14.8患者专科检查表
	 
	d ##class(User.DHCDSSDiagnosisInfo).%BuildIndices() ;4.14.9患者诊断信息表
	
	d ##class(User.DHCDSSDrugInfo).%BuildIndices()  ;4.14.10患者处方信息表
	
	d ##class(User.DHCDSSExamInfo).%BuildIndices() ;4.14.11患者检查信息表
	 
	d ##class(User.DHCDSSLabInfo).%BuildIndices() ;4.14.12患者检验信息表
	
	d ##class(User.DHCDSSOperationInfo).%BuildIndices() ;4.14.13患者手术信息表
	
	d ##class(User.DHCDSSAnestInfo).%BuildIndices()  ;4.14.14患者麻醉信息表
	
	d ##class(User.DHCDSSNursingInfo).%BuildIndices() ;4.14.15患者护理信息表

	d ##class(User.DHCDSSBloodTransInfo).%BuildIndices()  ;4.14.16患者输血信息表
	 
	d ##class(User.DHCDSSDietInfo).%BuildIndices()   ;4.14.17患者饮食信息表
	
	d ##class(User.DHCDSSClinicalFeature).%BuildIndices()  ;4.14.18临床表现信息表
	
	d ##class(User.DHCDSSClinicalFDetailed).%BuildIndices()  ;4.14.19临床表现明细表
	
	d ##class(User.DHCDSSOtherOrderInfo).%BuildIndices()   ;4.14.20患者其他医嘱信息表
	
	d ##class(User.DHCDSSInpatientInfo).%BuildIndices()  ;4.14.21.1患者住院病历信息表

	d ##class(User.DHCDSSCarryDrug).%BuildIndices() ;4.14.22.1患者出院带药信息表
	
	d ##class(User.DHCDSSOtherDisOrderInfo).%BuildIndices()  ;4.14.22.2患者其他出院医嘱信息表
	
	/******* 4.15 业务功能表******/
	//	4.15.1.	患者推荐疑似疾病记录表
	d ##class(User.DHCDSSRecomDiseaseInfo).%BuildIndices()
	
	//4.15.2.	患者推荐评估量表记录表
	d ##class(User.DHCDSSRecomRatingInfo).%BuildIndices()
		
	//4.15.3.	患者评估量表记录表	
	d ##class(User.DHCDSSPatientRatingScale).%BuildIndices()
	 
	//4.15.4.	推荐治疗方案记录表
	d ##class(User.DHCDSSRecomTreatInfo).%BuildIndices()
	
	//4.15.5.	患者治疗方案记录表
	d ##class(User.DHCDSSExecuteTreatInfo).%BuildIndices()
		
	//4.15.6.	患者治疗方案关联明细表
	d ##class(User.DHCDSSETreatJoinDetail).%BuildIndices()
	
	//4.15.7.	患者预警信息记录表
	d ##class(User.DHCDSSWarnInfo).%BuildIndices()
	
	//4.15.8.	写回信息记录表
	d ##class(User.DHCDSSWriteBackInfo).%BuildIndices()
	
	
	
	/******* 4.16.	系统功能******/
	//4.16.1.	用户字典表
	d ##class(User.DHCDSSUserDict).%BuildIndices()
	
	//4.16.2.	角色字典表
	d ##class(User.DHCDSSRoleDict).%BuildIndices()
	
	//4.16.3.	科室字典表
	d ##class(User.DHCDSSDeptDict).%BuildIndices()

	//4.16.4.	用户关联科室表
	d ##class(User.DHCDSSUserJoinDept).%BuildIndices()
	
	//4.16.5.	用户关联角色	
	d ##class(User.DHCDSSUserJoinRole).%BuildIndices()
	
	//4.16.6.	角色关联功能
	d ##class(User.DHCDSSRoleJoinFunction).%BuildIndices()
}

/// Creator：丁亚男
/// CreatDate:2020-09-25
/// Description:编译CDSS字典表及决策支持库相关表
/// Others：d ##class(web.CDSS.Public.CDSSDataBackup).BuildCDSSGlobalIndices()
ClassMethod BuildCDSSGlobalIndices()
{
	
	
	//***********4.1字典表**************************/
	
	//4.1.1人体部位分类字典表
	d ##class(User.DHCDSSBodyPartClass).%BuildIndices()  
	//4.1.1人体部位字典表
	d ##class(User.DHCDSSBodyParDict).%BuildIndices()	
	//4.1.3.人体状态字典表
	d ##class(User.DHCDSSBodyStateDict).%BuildIndices() 	
	//4.1.4.	诊断因子字典表（临床表现、体格检查、实验室检验、影像学检查）
	d ##class(User.DHCDSSDiagFactorDict).%BuildIndices()
    //4.1.6.	同义词字典表
    d ##class(User.DHCDSSSynonymDict).%BuildIndices()	
	//4.1.7.	医学知识分级字典表
	d ##class(User.DHCDSSKBSClassDict).%BuildIndices()
	//4.1.8.	系统功能分级字典表
	d ##class(User.DHCDSSSYSFuncDict).%BuildIndices()
	//4.1.9.	数据集合控件字典表
	d ##class(User.DHCDSSDataConDict).%BuildIndices()	
	//4.1.10.	功能关联数据集合控件表
	d ##class(User.DHCDSSDataFuncCon).%BuildIndices()	
	//4.1.11.	基础信息字典集合表
	d ##class(User.DHCDSSBasicsDict).%BuildIndices()
	//4.1.12.	数据库表字典表
	d ##class(User.DHCDSSDataTableDict).%BuildIndices()
	//4.1.13.	检验标本字典表
	d ##class(User.DHCDSSLabSpecimenDict).%BuildIndices()
	//4.1.14.	用法字典表
	d ##class(User.DHCDSSUsageDict).%BuildIndices()	
	//4.1.15.	频率字典表
	d ##class(User.DHCDSSFrequencyDict).%BuildIndices()
	//4.1.16.	临床数据类型关联数据字段表
	d ##class(User.DHCDSSDataJoinFiledDict).%BuildIndices()
	//4.1.17.	疾病分科字典表
	d ##class(User.DHCDSSDiseaseDeptDict).%BuildIndices()
	
	//************4.2.	临床疾病知识库****************/
	
	//4.2.1.	疾病字典表
	d ##class(User.DHCDSSDiseaseDict).%BuildIndices()
	//4.2.2.	疾病关联病情描述表
	d ##class(User.DHCDSSDiseJoinDesc).%BuildIndices()
	//4.2.3.	疾病关联临床表现表
	d ##class(User.DHCDSSDiseJoinSymptom).%BuildIndices() 	
	//4.2.4.	疾病关联体格检查表
	d ##class(User.DHCDSSDiseJoinPhysicalE).%BuildIndices()
	//4.2.5.	疾病关联检验指标表
	d ##class(User.DHCDSSDiseJoinLab).%BuildIndices()	
	//4.2.6.	疾病关联检查指标表
	d ##class(User.DHCDSSDiseJoinExamVal).%BuildIndices()	
	//4.2.7.	疾病关联病因表
	d ##class(User.DHCDSSDiseJoinCause).%BuildIndices()
	//4.2.8.	疾病关联病因表
	d ##class(User.DHCDSSDiseJoinPart).%BuildIndices()
	//4.2.9.	疾病关联预防表
	d ##class(User.DHCDSSDiseJoinPrevent).%BuildIndices()	
	//4.2.10.	疾病关联诊断因子表
	d ##class(User.DHCDSSDiseJoinFactor).%BuildIndices()
	//4.2.11.	疾病关联适用项表
	d ##class(User.DHCDSSDiseVSCondition).%BuildIndices()		
	//4.2.12.	疾病关联治疗方案表
	d ##class(User.DHCDSSDiseJoinTreat).%BuildIndices()
	//4.2.13.	治疗方案关联适用项表
	d ##class(User.DHCDSSTreatVSCondition).%BuildIndices()	
	//4.2.14.	治疗方案关联禁忌证表
	d ##class(User.DHCDSSTreatVSTaboo).%BuildIndices()
	//4.2.15.	治疗方案关联禁忌证消除条件表
	d ##class(User.DHCDSSTreatCR).%BuildIndices()	
	//4.2.16.	治疗方案关联措施表
	d ##class(User.DHCDSSTreatVSItem).%BuildIndices()	
	//4.2.17.	治疗措施关联子措施表
	d ##class(User.DHCDSSItemVSChild).%BuildIndices()
	//4.2.18.	治疗措施关联适用项表
	d ##class(User.DHCDSSItemVSCondition).%BuildIndices()
	//4.2.19.	治疗措施关联禁忌证表
	d ##class(User.DHCDSSItemVSTaboo).%BuildIndices()
	//4.2.20.	治疗措施关联禁忌证消除条件表
	d ##class(User.DHCDSSItemCR).%BuildIndices()
	//4.2.21.	治疗措施关联明细表
	d ##class(User.DHCDSSItemJoinDetail).%BuildIndices()  
	//治疗方案关联明细表——删除
	//s CList($i(CList))= "User.DHCDSSTreatJoinDetailI.GBL"  //治疗方案关联明细表 父表是疾病关联治疗方案表	
	//4.2.22.	治疗措施明细关联用法方案表
	d ##class(User.DHCDSSItemJoinUsage).%BuildIndices()
	//4.2.23.	治疗措施用法方案关联适用项表
	d ##class(User.DHCDSSUsageVSCondition).%BuildIndices()
	//4.2.24.	治疗措施用法方案关联禁忌症表
	d ##class(User.DHCDSSTUsageJoinTaboo).%BuildIndices() 
	//4.2.25.	治疗措施用法方案关联禁忌症消除表
	d ##class(User.DHCDSSTUsageJoinTabooCR).%BuildIndices()
	//4.2.26.	疾病关联并发症表
	d ##class(User.DHCDSSDiseJoinComp).%BuildIndices()	
	//4.2.27.	疾病关联预后表
	d ##class(User.DHCDSSDiseJoinPrognosis).%BuildIndices()	
	//4.2.28.	疾病关联鉴别诊断表
	d ##class(User.DHCDSSDiseJoinDiffDiag).%BuildIndices()
	//4.2.29.	疾病关联鉴别诊断详述表
	d ##class(User.DHCDSSDiseJoinDiffDesc).%BuildIndices()
	//4.2.30.	疾病详述表	
	d ##class(User.DHCDSSDiseaseDetail).%BuildIndices()
	//4.2.31.	疾病关联辅助检查检验表
	d ##class(User.DHCDSSDiseJoinExam).%BuildIndices()
	//4.2.32.	疾病关联辅助检查检验明细表
	d ##class(User.DHCDSSDiseJoinDetail).%BuildIndices()
	//4.2.33.	疾病关联辅助检查检验评估表
	d ##class(User.DHCDSSDiseJoinExamAssess).%BuildIndices()
	//4.2.34.	急诊预检分诊分级标准字典表
	d ##class(User.DHCDSSEmerStandardDict).%BuildIndices()		
	//4.2.35.	SNOMEDCT中英文对照
	d ##class(User.DHCDSSSnomedctDict).%BuildIndices()
	//4.2.36.	疾病关联科室字典表 
	d ##class(User.DHCDSSDiseJoinDept).%BuildIndices()	
	//4.2.37.	疾病关联文献资料表
	d ##class(User.DHCDSSDiseJoinliterature).%BuildIndices()
			
	//疾病详述表-展示数据
	d ##class(User.DHCDSSDiseDetailForView).%BuildIndices()
	
	//************4.3.	评估量表知识库表****************/
	
	//4.3.1.	评分量表字典表
	d ##class(User.DHCDSSRatingScaleDict).%BuildIndices()
	//4.3.2.	评估量表评估表
	d ##class(User.DHCDSSRatingScaleAssess).%BuildIndices() 
	
	//*************4.4.	体格检查知识库表*****************/
	
	//4.4.1.	体格检查字典表
	d ##class(User.DHCDSSPhysicalExamDict).%BuildIndices()
	//4.4.2.	体格检查关联症状表 	
	
	
	//*************4.5.	诊疗规则知识库表*****************/
	
	//4.5.1.	诊疗规则字典表
	d ##class(User.DHCDSSMedicalRule).%BuildIndices()
	//4.5.2.	诊疗规则关联规则条件表
	d ##class(User.DHCDSSRuleTrigger).%BuildIndices()
	//4.5.3.	诊疗规则规则条件关联子规则条件表
	d ##class(User.DHCDSSChildRuleTrigger).%BuildIndices()	
	//4.5.4.	诊疗规则申请操作记录表
	d ##class(User.DHCDSSRuleApplyRecord).%BuildIndices()
	
	//*************4.6.	质控规则知识库表*****************/	
	//4.6.1.	质控规则字典表
	d ##class(User.DHCDSSQCRuleDict).%BuildIndices()
	//4.6.2.	质控规则关联条件表
	d ##class(User.DHCDSSQCRJoinCondition).%BuildIndices()	
	//4.6.3.	质控规则条件关联子条件表
	d ##class(User.DHCDSSQCRJoinSCondition).%BuildIndices()	
	//4.6.4.	质控规则操作记录表
	d ##class(User.DHCDSSQCRJoinRecord).%BuildIndices()
	
	//*************4.7.	临床输血知识库*****************/	
	//4.7.1.	血型字典表
	d ##class(User.DHCDSSBloodTypeDict).%BuildIndices()
	//4.7.2.	输血品分类字典表
	d ##class(User.DHCDSSBPClassDict).%BuildIndices()	
	//4.7.3.	输血品字典表
	d ##class(User.DHCDSSBloodProductDict).%BuildIndices() 
	//4.7.4.	输血品关联血型
	d ##class(User.DHCDSSBPJoinBloodType).%BuildIndices()
	//4.7.5.	输血品关联适用项
	d ##class(User.DHCDSSBPJoinIndication).%BuildIndices()	
	//4.7.6.	输血品关联禁忌症
	d ##class(User.DHCDSSBPJoinTaboo).%BuildIndices()
	//4.7.7.	输血品关联禁忌症消除条件
	d ##class(User.DHCDSSBPJoinTabooRemove).%BuildIndices()
	//4.7.8.	输血品关联注意事项
	d ##class(User.DHCDSSBPJoinPrecautions).%BuildIndices()	
	//4.7.9.	输血品关联不良反应
	d ##class(User.DHCDSSBPJoinAR).%BuildIndices()	
	//4.7.10.	输血品关联疾病	
	d ##class(User.DHCDSSBPJoinDisease).%BuildIndices()
	//4.7.11.	输血品关联并发症
	d ##class(User.DHCDSSBPJoinComplication).%BuildIndices()	
	//4.7.12.	输血品关联替代制品
	d ##class(User.DHCDSSBPJoinSubstitute).%BuildIndices()
	
	//*************	4.8.	临床护理知识库*****************/	
	//4.8.1.	护理分类字典表
	d ##class(User.DHCDSSNursingClassDict).%BuildIndices()
	//4.8.2.	护理分级字典表
	d ##class(User.DHCDSSNursingGradeDict).%BuildIndices()
	//4.8.3.	护理项目字典表	
	d ##class(User.DHCDSSNursingDict).%BuildIndices()
	//4.8.4.	护理明细表
	d ##class(User.DHCDSSNursingJoinDetail).%BuildIndices()
	//4.8.5.	护理项目关联器械表
	d ##class(User.DHCDSSNursingJoinInstru).%BuildIndices()
	//4.8.6.	护理项目关联部位表
	d ##class(User.DHCDSSNursingJoinPart).%BuildIndices()
	//4.8.7.	护理项目关联适用项表
	d ##class(User.DHCDSSNursingJoinIndic).%BuildIndices()
	//4.8.8.	护理项目关联禁忌症表
	d ##class(User.DHCDSSNursingJoinTaboo).%BuildIndices()	
	//4.8.9.	护理项目关联禁忌症消除表
	d ##class(User.DHCDSSNursingJoinTabooR).%BuildIndices()
	//4.8.10.	护理项目关联不良反应表
	d ##class(User.DHCDSSNursingJoinAR).%BuildIndices()
	//4.8.11.	护理项目关联注意事项表
	d ##class(User.DHCDSSNursingJoinPre).%BuildIndices()	
	//4.8.12.	护理项目关联疾病表
	d ##class(User.DHCDSSNursingJoinDisease).%BuildIndices()
	//4.8.13.	护理项目关联并发症表
	d ##class(User.DHCDSSNursingJoinComp).%BuildIndices()	
	//4.8.14.	护理项目关联评估量表
	d ##class(User.DHCDSSNursingJoinRS).%BuildIndices()	
	
	//*************4.9.	临床药物知识库*****************/	
	//4.9.1.	药物分类字典表
	d ##class(User.DHCDSSDrugClassDict).%BuildIndices()
	//4.9.2.	药物字典表
	d ##class(User.DHCDSSDrugDict).%BuildIndices()	
	//4.9.3.	药物关联适用项表
	d ##class(User.DHCDSSDrugJoinIndication).%BuildIndices()	
	//4.9.4.	药物关联用法方案表
	d ##class(User.DHCDSSDrugJoinUsage).%BuildIndices()	
	//4.9.5.	药物用法方案关联适用项表
	d ##class(User.DHCDSSUsageJoinIndication).%BuildIndices()	
	//4.9.6.	药物用法方案关联禁忌症表
	d ##class(User.DHCDSSUsageJoinTaboo).%BuildIndices()
	//4.9.7.	药物用法方案关联禁忌症消除表
	d ##class(User.DHCDSSUsageJoinTabooCR).%BuildIndices()	
	//4.9.8.	药物关联不良反应表
	d ##class(User.DHCDSSDrugAR).%BuildIndices()
	//4.9.9.	药物关联禁忌症表
	d ##class(User.DHCDSSDrugContraindica).%BuildIndices()	
	//4.9.10.	药物关联禁忌症消除条件表
	d ##class(User.DHCDSSDrugCR).%BuildIndices()
	//4.9.11.	药物关联辅料表
	d ##class(User.DHCDSSDrugAccessories).%BuildIndices()
	//4.9.12.	药物关联相互作用表	
	//4.9.13.	药物关联过量使用表
	d ##class(User.DHCDSSDrugJoinOverdose).%BuildIndices()	
	
	//*************4.10.	临床医学检验知识库表*****************/	
	//4.10.1.	检验分类字典表
	d ##class(User.DHCDSSLabClassDict).%BuildIndices()
	//	4.10.2.	检验字典表
	d ##class(User.DHCDSSLabInspectionDict).%BuildIndices()
	//4.10.3.	检验明细字典表
	d ##class(User.DHCDSSInspectionDetail).%BuildIndices()
	//4.10.4.	检验项目关联标本表
	d ##class(User.DHCDSSLabJoinSpecimen).%BuildIndices()
	//4.10.5.	检验项目关联器械（药物）表
	d ##class(User.DHCDSSLabJoinInstru).%BuildIndices()
	//4.10.6.	检验项目关联适用项表
	d ##class(User.DHCDSSLabJoinIndication).%BuildIndices()
	//4.10.7.	检验项目关联禁忌症表
	d ##class(User.DHCDSSLabJoinTaboo).%BuildIndices()
	//4.10.8.	检验项目关联禁忌症消除表
	d ##class(User.DHCDSSLabJoinTabooRemove).%BuildIndices()	
	//4.10.9.	检验项目关联不良反应表
	d ##class(User.DHCDSSLabJoinAR).%BuildIndices()
	//4.10.10.	检验项目关联注意事项表	
	d ##class(User.DHCDSSLabJoinPrecaution).%BuildIndices()
	//4.10.11.	检验项目关联疾病表
	d ##class(User.DHCDSSLabJoinDiagnosis).%BuildIndices()	
	//4.10.12.	检验结果辅助诊断表
	d ##class(User.DHCDSSLabJoinResult).%BuildIndices()	
	
	//***********4.11.	临床医学检查知识库表****************/
	//4.11.1.	检查分类字典表
	d ##class(User.DHCDSSExamClassDict).%BuildIndices() 	
	//4.11.2.	检查字典表
	d ##class(User.DHCDSSExamDict).%BuildIndices() 
	//4.11.3.	检查项目关联部位表
	d ##class(User.DHCDSSExamJoinParts).%BuildIndices()
	//4.11.4.	检查项目关联器械（药物）表
	d ##class(User.DHCDSSExamJoinInstru).%BuildIndices()
	//4.11.5.	检查项目关联适用项表
	d ##class(User.DHCDSSExamIndication).%BuildIndices()
	//	4.11.6.	检查项目关联禁忌症表
	d ##class(User.DHCDSSExamContraindica).%BuildIndices()
	//4.11.7.	检查项目关联禁忌症消除条件表
	d ##class(User.DHCDSSExamCR).%BuildIndices()	
	//4.11.8.	检查项目关联不良反应表
	d ##class(User.DHCDSSExamAR).%BuildIndices()
	//4.11.9.	检查项目关联注意事项表
	d ##class(User.DHCDSSExamPrecautions).%BuildIndices()
	//4.11.10.	检查项目关联疾病表
	d ##class(User.DHCDSSExamJoinDiag).%BuildIndices()	

	//*************	4.12.	临床手术知识库表*****************/	
	//4.12.1.	手术分级字典表
	d ##class(User.DHCDSSOperationGradeDict).%BuildIndices()	
	//4.12.2.	手术字典表
	d ##class(User.DHCDSSOperationDict).%BuildIndices()	
	//4.12.3.	手术详述表
	d ##class(User.DHCDSSOperationDesc).%BuildIndices()
	//4.12.4.	手术关联部位
	d ##class(User.DHCDSSOperJoinBodyPart).%BuildIndices()
	//4.12.5.	手术关联器械（药物）表
	d ##class(User.DHCDSSOperJoinInstru).%BuildIndices()
	//4.12.6.	手术关联疾病
	d ##class(User.DHCDSSOperJoinDisease).%BuildIndices()
	//4.12.7.	手术关联适用项
	d ##class(User.DHCDSSOperJoinIndication).%BuildIndices()
	//4.12.8.	手术关联禁忌症
	d ##class(User.DHCDSSOperJoinTaboo).%BuildIndices()	
	//4.12.9.	手术关联禁忌症消除条件
	d ##class(User.DHCDSSOperJoinTabooR).%BuildIndices()	
	//4.12.10.	手术关联并发症
	d ##class(User.DHCDSSOperJoinComp).%BuildIndices()
	//4.12.11.	手术关联麻醉方式
	d ##class(User.DHCDSSOperJoinAnesthesia).%BuildIndices()	
	//4.12.12.	手术关联术前准备
	d ##class(User.DHCDSSOperJoinPreoperat).%BuildIndices()	
	//4.12.13.	手术关联切口
	//4.12.14.	手术关联止血
	//4.12.15.	手术关联引流
	//4.12.16.	手术关联操作步骤	
	d ##class(User.DHCDSSOperJoinDrocedure).%BuildIndices()
	//4.12.17.	手术关联结扎
	//4.12.18.	手术关联缝合
	//4.12.19.	手术关联术后护理
	d ##class(User.DHCDSSOperJoinPostoperat).%BuildIndices()	
	//4.12.20.	手术关联注意事项
	d ##class(User.DHCDSSOperJoinPrecaution).%BuildIndices()
	//4.12.21.	手术关联术后饮食
	d ##class(User.DHCDSSOperJoinDiet).%BuildIndices()		
	
	//***********4.13.	病案知识库表*************/	
	//4.13.1.	病案记录表
	d ##class(User.DHCDSSMedicalRecord).%BuildIndices()	
	
	//决策知识库与医为百科对照 20200923 GXP
	d ##class(User.DHCDSSWikiCMKBContrast).%BuildIndices()
}

/// Creator：谷雪萍
/// CreatDate:2021-01-26
/// Description:导出临床辅助决策支持系统V2.0的global
/// Input:ProjectFlag：非空-清掉演示评测系统和智能分诊系统数据（用于腾讯云更数据），空-不清演示评测系统和智能分诊系统数据（用于项目更数据）
/// Return:CDSSV2Data"_time_".gof文件
/// Others：d ##class(web.CDSS.Public.CDSSDataBackup).ExportCDSSV2Global("D:\CDSSGlobal\NewTable\")
ClassMethod ExportCDSSV2Global(filePath As %String = "", ProjectFlag As %String = "")
{
	k CList
	k myIdx
	
	//***********字典表**************************/
	
	//治疗方案字典
	s CList($i(CList))= "User.DHCDSSTreatDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSTreatDictI.GBL" 
	//单位字典
	s CList($i(CList))= "User.DHCDSSUnitDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUnitDictI.GBL" 			
	//通用字典类型
	s CList($i(CList))= "User.DHCDSSCommonDictTypeD.GBL" 
	s CList($i(CList))= "User.DHCDSSCommonDictTypeI.GBL" 	
	//通用字典
	s CList($i(CList))= "User.DHCDSSCommonDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSCommonDictI.GBL" 
	//过敏史字典
	s CList($i(CList))= "User.DHCDSSAllergyDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSAllergyDictI.GBL" 	
	//症状字典
	s CList($i(CList))= "User.DHCDSSSymptomDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSSymptomDictI.GBL" 
	//诱因、病因字典
	s CList($i(CList))= "User.DHCDSSPathogenyDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSPathogenyDictI.GBL" 
	//检验结果字典
	s CList($i(CList))= "User.DHCDSSLabResultDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabResultDictI.GBL" 
	//检查结果字典
	s CList($i(CList))= "User.DHCDSSExamResultDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSExamResultDictI.GBL" 
	//护理结果字典
	s CList($i(CList))= "User.DHCDSSNurseResultDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSNurseResultDictI.GBL" 
	//评估结果字典
	s CList($i(CList))= "User.DHCDSSAssessResultDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssessResultDictI.GBL" 
	//定语字典
	s CList($i(CList))= "User.DHCDSSAttributeDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSAttributeDictI.GBL" 
    //扩展码字典
	s CList($i(CList))= "User.DHCDSSExtendCodeDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSExtendCodeDictI.GBL" 
	//会诊医嘱字典
	s CList($i(CList))= "User.DHCDSSConsultationDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSConsultationDictI.GBL" 
	
	//单位转换表
	s CList($i(CList))= "User.DHCDSSUnitConversionD.GBL" 
	s CList($i(CList))= "User.DHCDSSUnitConversionI.GBL" 
	//检验医嘱字典
	s CList($i(CList))= "User.DHCDSSLabOrdersDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabOrdersDictI.GBL" 
	
	//1.3.18.	药物分类字典表
	s CList($i(CList))= "User.DHCDSSDrugTypeDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDrugTypeDictI.GBL" 
	
	//1.3.18.	剂型字典表
	s CList($i(CList))= "CT.WDT.CDSS.DHCDSSDosageFormD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DHCDSSDosageFormI.GBL" 
	
	//4.3.19.	疾病字典表
	s CList($i(CList))= "User.DHCDSSDiseaseDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseaseDictI.GBL" 
	//4.3.20.	药物字典表
	s CList($i(CList))= "User.DHCDSSDrugDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDrugDictI.GBL" 
	//4.3.21.	检查字典表
	s CList($i(CList))= "User.DHCDSSExamDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSExamDictI.GBL" 
	//4.3.22.	检验项目字典表
	s CList($i(CList))= "User.DHCDSSLabInspectionDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabInspectionDictI.GBL" 
	//4.3.23.	用法字典表
	s CList($i(CList))= "User.DHCDSSUsageDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUsageDictI.GBL" 
	//4.3.24.	手术字典表
	s CList($i(CList))= "User.DHCDSSOperationDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSOperationDictI.GBL" 
	//4.3.25.	护理字典表
	s CList($i(CList))= "User.DHCDSSNursingDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSNursingDictI.GBL" 
	//4.3.26.	输血品字典表
	s CList($i(CList))= "User.DHCDSSBloodProductDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSBloodProductDictI.GBL" 
	//4.3.27.	检验标本字典表
	s CList($i(CList))= "User.DHCDSSLabSpecimenDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabSpecimenDictI.GBL" 
	//4.3.28.	频率字典表
	s CList($i(CList))= "User.DHCDSSFrequencyDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSFrequencyDictI.GBL" 
	//4.3.29.	用法字典表
	s CList($i(CList))= "User.DHCDSSUsageDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUsageDictI.GBL" 
	//4.3.30.	体格检查字典表
	s CList($i(CList))= "User.DHCDSSPhysicalExamDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSPhysicalExamDictI.GBL" 
	//4.3.31.	科室字典表
	s CList($i(CList))= "User.DHCDSSDiseaseDeptDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseaseDeptDictI.GBL" 
	//4.3.32.	输血品分类字典表
	s CList($i(CList))= "User.DHCDSSBPClassDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSBPClassDictI.GBL" 
	//4.3.33.	部位字典表
	s CList($i(CList))= "User.DHCDSSBodyPartsDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSBodyPartsDictI.GBL" 
	//4.3.34.	别名通用表	
	s CList($i(CList))= "CT.WDT.CDSS.AliasD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.AliasI.GBL"
	//4.3.35.	部位层级表	
	s CList($i(CList))= "CT.WDT.CDSS.BodyPartsLevelD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.BodyPartsLevelI.GBL"	
	//4.3.36.	方位词字典表	
	s CList($i(CList))= "CT.WDT.CDSS.PositionWordD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.PositionWordI.GBL"

	 //4.3.37.	同义词检索字典	
	s CList($i(CList))= "CT.WDT.CDSS.SynSearchDictD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.SynSearchDictI.GBL"
	
	//手术关联科室
	s CList($i(CList))= "User.DHCDSSOperJoinDeptD.GBL"
	s CList($i(CList))= "User.DHCDSSOperJoinDeptI.GBL"
		
	//***********出院指导**************************/
	//出院指导字典表
	s CList($i(CList))= "CT.WDT.CDSS.DischargeGuideD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DischargeGuideI.GBL" 
	//出院指导详情表
	s CList($i(CList))= "CT.WDT.CDSS.DGuideDetailD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DGuideDetailI.GBL" 	
	
	
	//***********文献管理**************************/
	
	//文献表
	s CList($i(CList))= "User.DHCDSSDocuManageD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuManageI.GBL" 
	//文献关联诊断
	s CList($i(CList))= "User.DHCDSSDocuJoinDiseaseD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDiseaseI.GBL" 
	//文献关联科室
	s CList($i(CList))= "User.DHCDSSDocuJoinDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDeptI.GBL" 	
	//文献详情
	s CList($i(CList))= "User.DHCDSSDocuDetailD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuDetailI.GBL" 
	//4.4.5.	文献发布机构表
	s CList($i(CList))= "User.DHCDSSDocuAgencyD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuAgencyI.GBL" 
	
	//***********疑似诊断管理**************************/
	//疾病关联诊断因子
	s CList($i(CList))= "User.DHCDSSDiseJFactorD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJFactorI.GBL" 
	//疾病关联诊断因子组合
	s CList($i(CList))= "User.DHCDSSDiseJFactorCombD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJFactorCombI.GBL" 
	//疾病关联属性
	s CList($i(CList))= "User.DHCDSSDiseJPropertyD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJPropertyI.GBL" 	
	//诊断因子库
	s CList($i(CList))= "User.DHCDSSDiagFactorBaseD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiagFactorBaseI.GBL" 
	//4.5.5.	疾病关联识别词表
	s CList($i(CList))= "User.DHCDSSDiseJIWordsD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJIWordsI.GBL" 
	
	//***********字典对照管理**************************/
	/*
	//对接方药品字典
	s CList($i(CList))= "User.DHCDSSConDrugDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSConDrugDictI.GBL" 
	//对接方诊断字典
	s CList($i(CList))= "User.DHCDSSConDiseaseDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSConDiseaseDictI.GBL" 
	//对接方检验检查字典
	s CList($i(CList))= "User.DHCDSSConExamDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSConExamDictI.GBL" 	
	//对接方手术字典
	s CList($i(CList))= "User.DHCDSSConOperDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSConOperDictI.GBL" 
	//对接方护理字典
	s CList($i(CList))= "User.DHCDSSConNurseDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSConNurseDictI.GBL" 	
	//对照字典
	s CList($i(CList))= "User.DHCDSSContrastDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSContrastDictI.GBL" 
	//其他类型对接方字典表
	s CList($i(CList))= "CT.WDT.CDSS.ConOtherDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConOtherDictI.GBL" 
	//医院字典表
	s CList($i(CList))= "User.DHCDSSCustomerHospD.GBL" 
	s CList($i(CList))= "User.DHCDSSCustomerHospI.GBL" 
	s CList($i(CList))= "User.DHCDSSCustomerHospC.GBL" 
	//院区
	s CList($i(CList))= "CT.WDT.CDSS.CustomerHospAreaI.GBL" 
	//对接方字典分类表
	s CList($i(CList))= "User.DHCDSSInterfaceClassDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSInterfaceClassDictI.GBL"
	
	//4.10.12.	对接方字典关联院区表
	s CList($i(CList))= "CT.WDT.CDSS.ConDictConAreaD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConDictConAreaI.GBL" 
	*/
	//***********诊疗规则管理**************************/
	//诊疗规则字典
	s CList($i(CList))= "User.DHCDSSRuleDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleDictI.GBL" 
	//诊疗流程节点
	s CList($i(CList))= "User.DHCDSSRuleNodeD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleNodeI.GBL" 
	//诊疗流程线表
	s CList($i(CList))= "User.DHCDSSRuleLinkD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleLinkI.GBL" 	
	//诊疗流程图Json信息表
	s CList($i(CList))= "User.DHCDSSRuleChartD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleChartI.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleChartS.GBL" 
	//触发条件表
	s CList($i(CList))= "User.DHCDSSRuleConditionD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleConditionI.GBL" 	
	//诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，推荐确诊）
	s CList($i(CList))= "User.DHCDSSRuleResultD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleResultI.GBL" 
	//诊疗节点内容表（预警规则-合理性）
	s CList($i(CList))= "User.DHCDSSRuleRationalityD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleRationalityI.GBL" 
	//诊疗节点内容表（预警规则-并发症）
	s CList($i(CList))= "User.DHCDSSRuleComplicationD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleComplicationI.GBL" 
	//治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
	s CList($i(CList))= "User.DHCDSSRuleDetailD.GBL" 
	s CList($i(CList))= "User.DHCDSSRuleDetailI.GBL" 	
	//诊疗规则流程类型表
	s CList($i(CList))= "User.DHCDSSChartTypeD.GBL" 
	s CList($i(CList))= "User.DHCDSSChartTypeI.GBL" 
	//诊疗规则流程节点类型表
	s CList($i(CList))= "User.DHCDSSNodeTypeD.GBL" 
	s CList($i(CList))= "User.DHCDSSNodeTypeI.GBL" 		
	//诊疗规则流程类型与节点类型关联表
	s CList($i(CList))= "User.DHCDSSChartNodeTypeConD.GBL" 
	s CList($i(CList))= "User.DHCDSSChartNodeTypeConI.GBL" 
	//诊疗节点内容依据表
	s CList($i(CList))= "User.DHCDSSRuleBasisD.GBL"	
	s CList($i(CList))= "User.DHCDSSRuleBasisI.GBL"	
	
	//推荐疑似疾病中单一规则表 
	s CList($i(CList))= "User.DHCDSSSingleSymptomRuleD.GBL"	
	s CList($i(CList))= "User.DHCDSSSingleSymptomRuleI.GBL"	
	
	//***********识别词管理**************************/
	//识别词字典
	s CList($i(CList))= "User.DHCDSSIdentifyWordsD.GBL" 
	s CList($i(CList))= "User.DHCDSSIdentifyWordsI.GBL" 
	//识别词流程节点表
	s CList($i(CList))= "User.DHCDSSWordsNodeD.GBL" 
	s CList($i(CList))= "User.DHCDSSWordsNodeI.GBL" 
	//识别词流程线表
	s CList($i(CList))= "User.DHCDSSWordsLinkD.GBL" 
	s CList($i(CList))= "User.DHCDSSWordsLinkI.GBL" 	
	//识别词节点内容表（触发条件）
	s CList($i(CList))= "User.DHCDSSWordsConditionD.GBL" 
	s CList($i(CList))= "User.DHCDSSWordsConditionI.GBL" 
	//识别词流程图Json信息表 （用于还原流程图）
	s CList($i(CList))= "User.DHCDSSWordsChartD.GBL" 
	s CList($i(CList))= "User.DHCDSSWordsChartI.GBL" 	
	s CList($i(CList))= "User.DHCDSSWordsChartS.GBL" 	
	//识别词项目字典
	s CList($i(CList))= "User.DHCDSSWordsItemD.GBL" 
	s CList($i(CList))= "User.DHCDSSWordsItemI.GBL" 		

	//***********评估表知识库管理**************************/
	//评估表基本信息
	s CList($i(CList))= "User.DHCDSSAssBasicInfoD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssBasicInfoI.GBL" 
	//评估表关联文献表
	s CList($i(CList))= "User.DHCDSSAssConDocD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssConDocI.GBL" 
	//评估表关联科室
	s CList($i(CList))= "User.DHCDSSAssConDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssConDeptI.GBL" 	
	//评估表关联关键字
	s CList($i(CList))= "User.DHCDSSAssKeyWordsD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssKeyWordsI.GBL" 
	//评估表关联疾病
	s CList($i(CList))= "User.DHCDSSDiseJoinAssessmentD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinAssessmentI.GBL" 	
	//评估表注册表
	s CList($i(CList))= "User.MKBAssessmentBaseD.GBL" 
	s CList($i(CList))= "User.MKBAssessmentBaseI.GBL" 	
	s CList($i(CList))= "User.MKBAssessmentBaseC.GBL"
	//评估表注册字段表
	s CList($i(CList))= "User.MKBAssessmentBaseFieldI.GBL" 	
	//评估表评分规则表
	s CList($i(CList))= "User.MKBAssessmentScoringRulesI.GBL" 	
	//评估表关联评估结果条件设置表
	s CList($i(CList))= "CT.WDT.MKB.AssConResCondiD.GBL" 
	s CList($i(CList))= "CT.WDT.MKB.AssConResCondiI.GBL" 
	//评估表关联评估结论表
	s CList($i(CList))= "User.DHCDSSAssConResultD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssConResultI.GBL" 
	
	//***********中医CDSS**************************/
	//中医证候字典
	s CList($i(CList))= "User.DHCDSSTCMSymptomD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMSymptomI.GBL" 
	//中医方剂字典
	s CList($i(CList))= "User.DHCDSSTCMPrescriptionD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMPrescriptionI.GBL" 
	//方剂关联疾病字典
	s CList($i(CList))= "User.DHCDSSTCMPreJoinDisD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMPreJoinDisI.GBL" 	
	//方剂关联中药字典
	s CList($i(CList))= "User.DHCDSSTCMPreJoinMedD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMPreJoinMedI.GBL" 
	//中药字典
	s CList($i(CList))= "User.DHCDSSTCMMedicineD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMMedicineI.GBL" 		
	//腧穴字典
	s CList($i(CList))= "User.DHCDSSTCMAcupointsD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMAcupointsI.GBL" 	
	//中药煎法字典
	s CList($i(CList))= "User.DHCDSSTCMDecoctionD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMDecoctionI.GBL" 		
	//中医疾病字典
	s CList($i(CList))= "User.DHCDSSTCMDiseaseD.GBL" 
	s CList($i(CList))= "User.DHCDSSTCMDiseaseI.GBL"
	
	//4.4.9.	中医症状字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMSymDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMSymDictI.GBL"
	
	//4.4.10.	中医体征字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMSignsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMSignsI.GBL"
	
	//4.4.11.	中医治法字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMTreatmentD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMTreatmentI.GBL"
	
	//4.4.12.	中医疾病关联证候表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJSymD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJSymI.GBL"
	
	//4.4.13.	中医疾病关联属性表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJPropertyD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJPropertyI.GBL"
	//4.4.14.	中医疾病关联识别词表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJWordsI.GBL"
	//4.4.15.	中医辩证识别词表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseSymJWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseSymJWordsI.GBL"
	
	//***********百科管理**************************/
	//知识库注册
	s CList($i(CList))= "CT.WDT.CDSS.TermBaseD.GBL"  //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseI.GBL" //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyI.GBL"  //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyD.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyC.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseExtendProI.GBL" //术语库注册扩展属性表
    //知识管理
    s CList($i(CList))= "CT.WDT.CDSS.TermD.GBL"  //术语表
    s CList($i(CList))= "CT.WDT.CDSS.TermI.GBL"  //术语表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyD.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyI.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyC.GBL"  //术语属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProI.GBL" //术语扩展属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailD.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailI.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValD.GBL" //扩展属性值表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValI.GBL" //扩展属性值表
	
	if (ProjectFlag'="")  //如果是腾讯云部署才导出病历质控评测工具的数据，项目部署的话不需要导出
	{
		//***********1.11.	病历质控评测工具**************************/
		s CList($i(CList))= "User.DHCDSSChiefIdentifyD.GBL"	//1.11.1.	主诉识别表
	 	s CList($i(CList))= "User.DHCDSSChiefIdentifyI.GBL"	
		s CList($i(CList))= "User.DHCDSSChiefIdentifyEvalD.GBL"	//1.11.2.	主诉识别评测表
	 	s CList($i(CList))= "User.DHCDSSChiefIdentifyEvalI.GBL"
	 	s CList($i(CList))= "User.DHCDSSChiefDiaHitRateD.GBL"	//1.11.3.	诊断命中率统计表
	 	s CList($i(CList))= "User.DHCDSSChiefDiaHitRateI.GBL"	
	 	s CList($i(CList))= "CT.WDT.CDSS.ChiefTasksD.GBL"  //任务集
	 	s CList($i(CList))= "CT.WDT.CDSS.ChiefTasksI.GBL"
	 	
	}
 	
	 //平台配置
	 s CList($i(CList))= "CT.WDT.MKB.ConfigCategoryD.GBL"   //平台配置分类
	 s CList($i(CList))= "CT.WDT.MKB.ConfigCategoryI.GBL" 
	//s CList($i(CList))= "User.MKBConfigD.GBL" 
	//s CList($i(CList))= "User.MKBConfigI.GBL" 
	//s CList($i(CList))= "User.MKBConfigDetailD.GBL" 
	//s CList($i(CList))= "User.MKBConfigDetailI.GBL" 
	
	//菜单管理
	//s CList($i(CList))= "CT.WDT.MKB.MenuD.GBL"
	//s CList($i(CList))= "CT.WDT.MKB.MenuI.GBL"
	//s CList($i(CList))= "CT.WDT.MKB.MenuC.GBL"
	//4.1.11.	基础信息字典集合表
	s CList($i(CList))= "CT.WDT.MKB.FunctionalElementI.GBL"
	
	//4.1.12.	数据库表字典表
	s CList($i(CList))= "User.DHCDSSDataTableDictD.GBL"
	s CList($i(CList))= "User.DHCDSSDataTableDictI.GBL"
	
	//4.1.12.	医学组数据统计配置表
	s CList($i(CList))= "CF.WDT.CDSS.StatisticsConfigD.GBL"
	s CList($i(CList))= "CF.WDT.CDSS.StatisticsConfigI.GBL"	
	
	//	4.22.1.	全文检索配置表
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetD.GBL" 
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetI.GBL" 
	

	
    //把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"CDSSV2Data"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)  //删掉10天前的global
	w time,!
	s filename = filePath_"CDSSV2Data"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator：谷雪萍
/// CreatDate:2021-01-26
/// Description:k掉临床辅助决策支持系统V2.0的global
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).KillCDSSV2Global()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","CDSSV2Data.gof")
ClassMethod KillCDSSV2Global()
{
	
	b ;确定库是否正确？？？确定的话输 g 不确定输 q	
	b ;确定要删除CDSSV2.0的所有数据吗？确定的话输 g 不确定输 q	
	//***********字典表**************************/
	
	//治疗方案字典
	k ^User.DHCDSSTreatDictD
	k ^User.DHCDSSTreatDictI
	//单位字典
	k ^User.DHCDSSUnitDictD
	k ^User.DHCDSSUnitDictI			
	//通用字典类型
	k ^User.DHCDSSCommonDictTypeD
	k ^User.DHCDSSCommonDictTypeI	
	//通用字典
	k ^User.DHCDSSCommonDictD
	k ^User.DHCDSSCommonDictI
	//过敏史字典
	k ^User.DHCDSSAllergyDictD
	k ^User.DHCDSSAllergyDictI	
	//症状字典
	k ^User.DHCDSSSymptomDictD
	k ^User.DHCDSSSymptomDictI
	//诱因、病因字典
	k ^User.DHCDSSPathogenyDictD
	k ^User.DHCDSSPathogenyDictI
	//检验结果字典
	k ^User.DHCDSSLabResultDictD
	k ^User.DHCDSSLabResultDictI
	//检查结果字典
	k ^User.DHCDSSExamResultDictD
	k ^User.DHCDSSExamResultDictI
	//护理结果字典
	k ^User.DHCDSSNurseResultDictD
	k ^User.DHCDSSNurseResultDictI
	//评估结果字典
	k ^User.DHCDSSAssessResultDictD
	k ^User.DHCDSSAssessResultDictI
	//定语字典
	k ^User.DHCDSSAttributeDictD
	k ^User.DHCDSSAttributeDictI
    //扩展码字典
	k ^User.DHCDSSExtendCodeDictD
	k ^User.DHCDSSExtendCodeDictI
	//会诊医嘱字典
	k ^User.DHCDSSConsultationDictD
	k ^User.DHCDSSConsultationDictI
		//单位转换表
	k ^User.DHCDSSUnitConversionD
	k ^User.DHCDSSUnitConversionI
	//检验医嘱字典
	k ^User.DHCDSSLabOrdersDictD
	k ^User.DHCDSSLabOrdersDictI

	//1.3.18.	药物分类字典表
	k ^User.DHCDSSDrugTypeDictD 
	k ^User.DHCDSSDrugTypeDictI 
	
	//1.3.18.	剂型字典表
	k ^CT.WDT.CDSS.DHCDSSDosageFormD
	k ^CT.WDT.CDSS.DHCDSSDosageFormI
	
		//4.3.19.	疾病字典表
	k ^User.DHCDSSDiseaseDictD 
	k ^User.DHCDSSDiseaseDictI 
	//4.3.20.	药物字典表
	k ^User.DHCDSSDrugDictD 
	k ^User.DHCDSSDrugDictI 
	//4.3.21.	检查字典表
	k ^User.DHCDSSExamDictD 
	k ^User.DHCDSSExamDictI 
	//4.3.22.	检验项目字典表
	k ^User.DHCDSSLabInspectionDictD 
	k ^User.DHCDSSLabInspectionDictI 
	//4.3.23.	用法字典表
	k ^User.DHCDSSUsageDictD 
	k ^User.DHCDSSUsageDictI 
	//4.3.24.	手术字典表
	k ^User.DHCDSSOperationDictD 
	k ^User.DHCDSSOperationDictI 
	//4.3.25.	护理字典表
	k ^User.DHCDSSNursingDictD 
	k ^User.DHCDSSNursingDictI 
	//4.3.26.	输血品字典表
	k ^User.DHCDSSBloodProductDictD 
	k ^User.DHCDSSBloodProductDictI 
	//4.3.27.	检验标本字典表
	k ^User.DHCDSSLabSpecimenDictD 
	k ^User.DHCDSSLabSpecimenDictI 
	//4.3.28.	频率字典表
	k ^User.DHCDSSFrequencyDictD 
	k ^User.DHCDSSFrequencyDictI 
	//4.3.29.	用法字典表
	k ^User.DHCDSSUsageDictD 
	k ^User.DHCDSSUsageDictI 
	//4.3.30.	体格检查字典表
	k ^User.DHCDSSPhysicalExamDictD 
	k ^User.DHCDSSPhysicalExamDictI 
	//4.3.31.	科室字典表
	k ^User.DHCDSSDiseaseDeptDictD 
	k ^User.DHCDSSDiseaseDeptDictI 
	//4.3.32.	输血品分类字典表
	k ^User.DHCDSSBPClassDictD 
	k ^User.DHCDSSBPClassDictI 
	//4.3.33.	部位字典表
	k ^User.DHCDSSBodyPartsDictD 
	k ^User.DHCDSSBodyPartsDictI 
	//4.3.34.	别名通用表	
	k ^CT.WDT.CDSS.AliasD
	k ^CT.WDT.CDSS.AliasI
	//4.3.35.	部位层级表	
	k ^CT.WDT.CDSS.BodyPartsLevelD
	k ^CT.WDT.CDSS.BodyPartsLevelI
	//4.3.36.	方位词字典表	
	k ^CT.WDT.CDSS.PositionWordD
	k ^CT.WDT.CDSS.PositionWordI
	//4.3.37.	同义词检索字典	
	k ^CT.WDT.CDSS.SynSearchDictD
	k ^CT.WDT.CDSS.SynSearchDictI
		//手术关联科室
	k ^User.DHCDSSOperJoinDeptD
	k ^User.DHCDSSOperJoinDeptI
	
	//***********出院指导**************************/
	//出院指导字典表
	k ^CT.WDT.CDSS.DischargeGuideD
	k ^CT.WDT.CDSS.DischargeGuideI
	//出院指导详情表
	k ^CT.WDT.CDSS.DGuideDetailD 
	k ^CT.WDT.CDSS.DGuideDetailI 	
	//***********文献管理**************************/
	//文献表
	k ^User.DHCDSSDocuManageD
	k ^User.DHCDSSDocuManageI
	//文献关联诊断
	k ^User.DHCDSSDocuJoinDiseaseD
	k ^User.DHCDSSDocuJoinDiseaseI
	//文献关联科室
	k ^User.DHCDSSDocuJoinDeptD
	k ^User.DHCDSSDocuJoinDeptI	
	//文献详情
	k ^User.DHCDSSDocuDetailD
	k ^User.DHCDSSDocuDetailI
	//4.4.5.	文献发布机构表
	k ^User.DHCDSSDocuAgencyD 
	k ^User.DHCDSSDocuAgencyI 	
	//***********疑似诊断管理**************************/
	//疾病关联诊断因子
	k ^User.DHCDSSDiseJFactorD
	k ^User.DHCDSSDiseJFactorI
	//疾病关联诊断因子组合
	k ^User.DHCDSSDiseJFactorCombD
	k ^User.DHCDSSDiseJFactorCombI
	//疾病关联属性
	k ^User.DHCDSSDiseJPropertyD
	k ^User.DHCDSSDiseJPropertyI	
	//诊断因子库
	k ^User.DHCDSSDiagFactorBaseD
	k ^User.DHCDSSDiagFactorBaseI
		//4.5.5.	疾病关联识别词表
	k ^User.DHCDSSDiseJIWordsD 
	k ^User.DHCDSSDiseJIWordsI 
	
	//***********字典对照管理（后面如果给项目部署需要用抽数据的方法只抽取本医院的字典对照数据）**************************/
	//对接方药品字典
	/*k ^User.DHCDSSConDrugDictD
	k ^User.DHCDSSConDrugDictI
	//对接方诊断字典
	k ^User.DHCDSSConDiseaseDictD
	k ^User.DHCDSSConDiseaseDictI
	//对接方检验检查字典
	k ^User.DHCDSSConExamDictD
	k ^User.DHCDSSConExamDictI	
	//对接方手术字典
	k ^User.DHCDSSConOperDictD
	k ^User.DHCDSSConOperDictI
	//对接方护理字典
	k ^User.DHCDSSConNurseDictD
	k ^User.DHCDSSConNurseDictI	
	//对照字典
	k ^User.DHCDSSContrastDictD
	k ^User.DHCDSSContrastDictI
	//其他类型对接方字典表
	k ^CT.WDT.CDSS.ConOtherDictD
	k ^CT.WDT.CDSS.ConOtherDictI
	//医院字典表
	k ^User.DHCDSSCustomerHospD
	k ^User.DHCDSSCustomerHospI
	k ^User.DHCDSSCustomerHospC
	
	//院区
	k ^CT.WDT.CDSS.CustomerHospAreaI
	//对接方字典分类表
	k ^User.DHCDSSInterfaceClassDictD
	k ^User.DHCDSSInterfaceClassDictI
	//4.10.12.	对接方字典关联院区表
	k ^CT.WDT.CDSS.ConDictConAreaD
	k ^CT.WDT.CDSS.ConDictConAreaI*/
		
	//***********诊疗规则管理**************************/
	//诊疗规则字典
	k ^User.DHCDSSRuleDictD
	k ^User.DHCDSSRuleDictI
	//诊疗流程节点
	k ^User.DHCDSSRuleNodeD
	k ^User.DHCDSSRuleNodeI
	//诊疗流程线表
	k ^User.DHCDSSRuleLinkD
	k ^User.DHCDSSRuleLinkI	
	//诊疗流程图Json信息表
	k ^User.DHCDSSRuleChartD
	k ^User.DHCDSSRuleChartI
	k ^User.DHCDSSRuleChartS
	//触发条件表
	k ^User.DHCDSSRuleConditionD
	k ^User.DHCDSSRuleConditionI	
	//诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，推荐确诊）
	k ^User.DHCDSSRuleResultD
	k ^User.DHCDSSRuleResultI
	//诊疗节点内容表（预警规则-合理性）
	k ^User.DHCDSSRuleRationalityD
	k ^User.DHCDSSRuleRationalityI
	//诊疗节点内容表（预警规则-并发症）
	k ^User.DHCDSSRuleComplicationD
	k ^User.DHCDSSRuleComplicationI
	//治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
	k ^User.DHCDSSRuleDetailD
	k ^User.DHCDSSRuleDetailI	
	//诊疗规则流程类型表
	k ^User.DHCDSSChartTypeD
	k ^User.DHCDSSChartTypeI
	//诊疗规则流程节点类型表
	k ^User.DHCDSSNodeTypeD
	k ^User.DHCDSSNodeTypeI		
	//诊疗规则流程类型与节点类型关联表
	k ^User.DHCDSSChartNodeTypeConD
	k ^User.DHCDSSChartNodeTypeConI
	//诊疗节点内容依据表
	k ^User.DHCDSSRuleBasisD
	k ^User.DHCDSSRuleBasisI
	
	//推荐疑似疾病中单一规则表 
	k ^User.DHCDSSSingleSymptomRuleD
	k ^User.DHCDSSSingleSymptomRuleI	
	//***********识别词管理**************************/
	//识别词字典
	k ^User.DHCDSSIdentifyWordsD
	k ^User.DHCDSSIdentifyWordsI
	//识别词流程节点表
	k ^User.DHCDSSWordsNodeD
	k ^User.DHCDSSWordsNodeI
	//识别词流程线表
	k ^User.DHCDSSWordsLinkD
	k ^User.DHCDSSWordsLinkI	
	//识别词节点内容表（触发条件）
	k ^User.DHCDSSWordsConditionD
	k ^User.DHCDSSWordsConditionI
	//识别词流程图Json信息表 （用于还原流程图）
	k ^User.DHCDSSWordsChartD
	k ^User.DHCDSSWordsChartI	
	k ^User.DHCDSSWordsChartS
	//识别词项目字典
	k ^User.DHCDSSWordsItemD
	k ^User.DHCDSSWordsItemI	
	
	//***********评估表知识库管理**************************/
	//评估表基本信息
	k ^User.DHCDSSAssBasicInfoD
	k ^User.DHCDSSAssBasicInfoI
	//评估表关联文献表
	k ^User.DHCDSSAssConDocD
	k ^User.DHCDSSAssConDocI
	//评估表关联科室
	k ^User.DHCDSSAssConDeptD 
	k ^User.DHCDSSAssConDeptI	
	//评估表关联关键字
	k ^User.DHCDSSAssKeyWordsD 
	k ^User.DHCDSSAssKeyWordsI
	//评估表关联疾病
	k ^User.DHCDSSDiseJoinAssessmentD
	k ^User.DHCDSSDiseJoinAssessmentI
	//评估表注册表
	k ^User.MKBAssessmentBaseD 
	k ^User.MKBAssessmentBaseI 	
	k ^User.MKBAssessmentBaseC
	//评估表注册字段表
	k ^User.MKBAssessmentBaseFieldI 	
	//评估表评分规则表
	k ^User.MKBAssessmentScoringRulesI 	
	//评估表关联评估结果条件设置表
	k ^CT.WDT.MKB.AssConResCondiD
	k ^CT.WDT.MKB.AssConResCondiI
	//评估表关联评估结论表
	k ^User.DHCDSSAssConResultD
	k ^User.DHCDSSAssConResultI
	
	//***********中医CDSS**************************/
	//中医证候字典
	k ^User.DHCDSSTCMSymptomD 
	k ^User.DHCDSSTCMSymptomI 
	//中医方剂字典
	k ^User.DHCDSSTCMPrescriptionD 
	k ^User.DHCDSSTCMPrescriptionI 
	//方剂关联疾病字典
	k ^User.DHCDSSTCMPreJoinDisD 
	k ^User.DHCDSSTCMPreJoinDisI 	
	//方剂关联中药字典
	k ^User.DHCDSSTCMPreJoinMedD 
	k ^User.DHCDSSTCMPreJoinMedI 
	//中药字典
	k ^User.DHCDSSTCMMedicineD 
	k ^User.DHCDSSTCMMedicineI 		
	//腧穴字典
	k ^User.DHCDSSTCMAcupointsD 
	k ^User.DHCDSSTCMAcupointsI 	
	//中药煎法字典
	k ^User.DHCDSSTCMDecoctionD 
	k ^User.DHCDSSTCMDecoctionI 		
	//中医疾病字典
	k ^User.DHCDSSTCMDiseaseD 
	k ^User.DHCDSSTCMDiseaseI 
	
	//4.4.9.	中医症状字典
	k ^CT.WDT.CDSS.TCMSymDictD 
	k ^CT.WDT.CDSS.TCMSymDictI
	
	//4.4.10.	中医体征字典
	k ^CT.WDT.CDSS.TCMSignsD 
	k ^CT.WDT.CDSS.TCMSignsI
	
	//4.4.11.	中医治法字典
	k ^CT.WDT.CDSS.TCMTreatmentD 
	k ^CT.WDT.CDSS.TCMTreatmentI
	
	//4.4.12.	中医疾病关联证候表
	k ^CT.WDT.CDSS.TCMDiseJSymD 
	k ^CT.WDT.CDSS.TCMDiseJSymI
	
	//4.4.13.	中医疾病关联属性表
	k ^CT.WDT.CDSS.TCMDiseJPropertyD 
	k ^CT.WDT.CDSS.TCMDiseJPropertyI
	//4.4.14.	中医疾病关联识别词表
	k ^CT.WDT.CDSS.TCMDiseJWordsD 
	k ^CT.WDT.CDSS.TCMDiseJWordsI
	//4.4.15.	中医辩证识别词表
	k ^CT.WDT.CDSS.TCMDiseSymJWordsD 
	k ^CT.WDT.CDSS.TCMDiseSymJWordsI
	
	
	//***********百科管理**************************/
	//知识库注册
	k ^CT.WDT.CDSS.TermBaseD	//术语库注册表 
	k ^CT.WDT.CDSS.TermBaseI	//术语库注册表 
	k ^CT.WDT.CDSS.TermBasePropertyI	//术语库注册属性表 
	k ^CT.WDT.CDSS.TermBasePropertyD	//术语库注册属性表
	k ^CT.WDT.CDSS.TermBasePropertyC	//术语库注册属性表	
 	k ^CT.WDT.CDSS.TermBaseExtendProI	//术语库注册扩展属性表
 	
 	//知识管理
 	k ^CT.WDT.CDSS.TermD	//术语表
 	k ^CT.WDT.CDSS.TermI	//术语表
	k ^CT.WDT.CDSS.TermPropertyD	//术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyI	//术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyC	//术语属性表
	k ^CT.WDT.CDSS.TermExtendProI	//术语扩展属性表
	k ^CT.WDT.CDSS.TermProDetailD	//术语属性内容表
	k ^CT.WDT.CDSS.TermProDetailI	//术语属性内容表
	k ^CT.WDT.CDSS.TermExtendProValD	//扩展属性值表
	k ^CT.WDT.CDSS.TermExtendProValI	//扩展属性值表
	
	//***********1.11.	病历质控评测工具**************************/
	k ^User.DHCDSSChiefIdentifyD	//1.11.1.	主诉识别表
 	k ^User.DHCDSSChiefIdentifyI	
	k ^User.DHCDSSChiefIdentifyEvalD	//1.11.2.	主诉识别评测表
 	k ^User.DHCDSSChiefIdentifyEvalI	
 	k ^User.DHCDSSChiefDiaHitRateD	//1.11.3.	诊断命中率统计表
 	k ^User.DHCDSSChiefDiaHitRateI		
 	k ^CT.WDT.CDSS.ChiefTasksD  //任务集
 	k ^CT.WDT.CDSS.ChiefTasksI 
 
 	
 	//平台配置
	k ^CT.WDT.MKB.ConfigCategoryD  //平台配置分类
	k ^CT.WDT.MKB.ConfigCategoryI
	//k ^User.MKBConfigD  //平台配置
	//k ^User.MKBConfigI 
	//k ^User.MKBConfigDetailD
	//k ^User.MKBConfigDetailI
	
	//菜单管理
	//k ^CT.WDT.MKB.MenuD
	//k ^CT.WDT.MKB.MenuI
	//k ^CT.WDT.MKB.MenuC
	//4.1.11.	基础信息字典集合表
	k ^CT.WDT.MKB.FunctionalElementI
	//4.1.12.	数据库表字典表
	k ^User.DHCDSSDataTableDictD
	k ^User.DHCDSSDataTableDictI
	//4.1.12.	医学组数据统计配置表
	k ^CF.WDT.CDSS.StatisticsConfigD
	k ^CF.WDT.CDSS.StatisticsConfigI
	
	//	4.22.1.	全文检索配置表
	k ^CF.WDT.CDSS.ALLDictSearchSetD
	k ^CF.WDT.CDSS.ALLDictSearchSetI
	
	//	4.22.2.	全文索引
	k ^CF.WDT.CDSS.ALLDictIndexD
	k ^CF.WDT.CDSS.ALLDictIndexI
	
	q "over"
}

/// Creator:谷雪萍
/// CreatDate:2020-09-10
/// Description：把百科管理的内容转移到CDSS新建的表
/// Input：
/// Return:1
/// w ##class(web.CDSS.Public.CDSSDataBackup).TransMKBTermDataToCDSS()
ClassMethod TransMKBTermDataToCDSS() As %String
{
    //遍历知识库注册表
    k ^CT.WDT.CDSS.TermBaseD  //术语库注册表 
    k ^CT.WDT.CDSS.TermBaseI
	k ^CT.WDT.CDSS.TermBasePropertyD  //术语库注册属性表 
	k ^CT.WDT.CDSS.TermBasePropertyC
	k ^CT.WDT.CDSS.TermBasePropertyI
	k ^CT.WDT.CDSS.TermBaseExtendProI	//术语库注册扩展属性表
	k ^CT.WDT.CDSS.TermD  //术语表
	k ^CT.WDT.CDSS.TermI
	k ^CT.WDT.CDSS.TermPropertyD  //术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyC
	k ^CT.WDT.CDSS.TermPropertyI
	k ^CT.WDT.CDSS.TermExtendProI  //术语扩展属性表	
	k ^CT.WDT.CDSS.TermProDetailD  //术语属性内容表
	k ^CT.WDT.CDSS.TermProDetailI
	k ^CT.WDT.CDSS.TermExtendProValD  //扩展属性值表
	k ^CT.WDT.CDSS.TermExtendProValI
	
	s ^CT.WDT.CDSS.TermBaseD=^User.MKBTermBaseD
	s ^CT.WDT.CDSS.TermBasePropertyD=^User.MKBTermBasePropertyD
	s ^CT.WDT.CDSS.TermBasePropertyC("ChildExt")=^User.MKBTermBasePropertyC("ChildExt")
	s ^CT.WDT.CDSS.TermD=^User.MKBTermD
    s ^CT.WDT.CDSS.TermPropertyD=^User.MKBTermPropertyD
    s ^CT.WDT.CDSS.TermPropertyC("ChildExtPro")=^User.MKBTermPropertyC("ChildExtPro")
    s ^CT.WDT.CDSS.TermProDetailD=^User.MKBTermProDetailD
    s ^CT.WDT.CDSS.TermExtendProValD=^User.MKBTermExtendProValD
	s MKBTBRowId=0
	for
	{    
		s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId)) q:MKBTBRowId=""  

		s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)  //知识库注册名称
		
		//如果是部署CDSS和结构化诊断  去掉症状和疾病出院指导数据
		if (MKBTBDesc="疾病")||(MKBTBDesc="检查")||(MKBTBDesc="检验")||(MKBTBDesc="手术")||(MKBTBDesc="护理")
		{
			s ^CT.WDT.CDSS.TermBaseD(MKBTBRowId)=^User.MKBTermBaseD(MKBTBRowId)
			//遍历属性
			s MKBTBPRowId=0
			for  
			{	s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId)) q:MKBTBPRowId="" 
				s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3)
				continue:MKBTBPDesc=""
				s ^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)=^User.MKBTermBasePropertyD(MKBTBPRowId)
				//遍历扩展属性
				s MKBTBEPChildsub=0
				for 
				{
					S MKBTBEPChildsub=$o(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)) q:MKBTBEPChildsub=""
					s MKBTBEPRowId=MKBTBPRowId_"||"_MKBTBEPChildsub
					s MKBTBEPName=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)),2)
					continue:MKBTBEPName=""
					s ^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)=^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)
				}
			}
			//遍历术语
			s MKBTRowId=0
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId)) q:MKBTRowId="" 
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				continue:MKBTDesc=""
				s ^CT.WDT.CDSS.TermD(MKBTRowId)=^User.MKBTermD(MKBTRowId)	
				//遍历该术语属性
				s MKBTPRowId=""
				for  
				{	
					s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId)) q:MKBTPRowId=""  
					s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
					continue:MKBTPDesc=""
					s ^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)=^User.MKBTermPropertyD(MKBTPRowId)		
					//遍历扩展属性表
					s MKBTEPChildsub=0    
					for   
					{
						S MKBTEPChildsub=$o(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)) q:MKBTEPChildsub=""
						s MKBTEPRowId=MKBTPRowId_"||"_MKBTEPChildsub
						s MKBTEPName=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),2)
						continue:MKBTEPName=""
						s ^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)=^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)
					}
					
					//遍历属性内容
					s MKBTPDRowId=0
					for  
					{	
						s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId=""
						s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
						continue:MKBTPDDesc=""
						s ^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)=^User.MKBTermProDetailD(MKBTPDRowId)
						//遍历扩展属性内容表
						s MKBTEPVRowId=0
						for  
						{	
							s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("DetailIndex",MKBTPDRowId,MKBTEPVRowId)) q:MKBTEPVRowId=""
							s MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4)
							continue:MKBTEPVValue=""
							s ^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)=^User.MKBTermExtendProValD(MKBTEPVRowId)
						}
					}	
					
				}
			}
		}	  	  
	}
	
	d ##class(CT.WDT.CDSS.TermBase).%BuildIndices()
	d ##class(CT.WDT.CDSS.TermBaseProperty).%BuildIndices()
	d ##class(CT.WDT.CDSS.TermBaseExtendPro).%BuildIndices()
	d ##class(CT.WDT.CDSS.Term).%BuildIndices()
	d ##class(CT.WDT.CDSS.TermProperty).%BuildIndices()
	d ##class(CT.WDT.CDSS.TermExtendPro).%BuildIndices()	
	d ##class(CT.WDT.CDSS.TermProDetail).%BuildIndices()
	d ##class(CT.WDT.CDSS.TermExtendProVal).%BuildIndices()
	//修改术语表的状态和责任人
	d ##class(web.CDSS.Public.CDSSDataBackup).TransTermState()
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2020-09-10
/// Description：修改术语表的状态和责任人
/// Input：
/// Return:{success:'true',info:'保存成功'}/"{success:'false',errorinfo:'错误信息'}"
/// w ##class(web.CDSS.Public.CDSSDataBackup).TransTermState()
ClassMethod TransTermState() As %String
{
	s result=""
	s MKBTRowId=0
	TS 
	for  
	{	
		s MKBTRowId=$o(^CT.WDT.CDSS.TermD(MKBTRowId)) 
		q:MKBTRowId=""
		s ResponUser=##class(web.CDSS.CMKB.TermProDetail).GetDetailByTermIdProName(MKBTRowId,"责任人")
		s Status=##class(web.CDSS.CMKB.TermProDetail).GetDetailByTermIdProName(MKBTRowId,"状态")
		s obj=##class(CT.WDT.CDSS.Term).%OpenId(MKBTRowId)
		s obj.ResponUser=ResponUser

		if (Status="待审核")
		{
			s Status="3"
		}
		elseif (Status="审核通过")
		{
			s Status="2"  //已审核
		}
		else  //编辑中、待修改、审核不通过
		{
			s Status="0"  //编辑中
		}	
		s obj.Status=Status
		
		if (Status="2")  //已审核的数据，审核人那里保存责任人
		{
			s obj.ReviewUser=ResponUser
		}
		s sc=obj.%Save()			
		d obj.%Close()
		If '$$$ISOK(sc)
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
			q
		}	
	}

	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result="{success:'true',info:'保存成功'}"   //返回错误信息
	}
	q result
}

/// Creator：丁亚男
/// CreatDate:2022-03-09
/// Description:导出临床辅助决策支持系统global
/// Others：d ##class(web.CDSS.Public.CDSSDataBackup).ExportCDSSBKGlobal("D:\CDSSGlobal\NewTable\")
ClassMethod ExportCDSSBKGlobal(filePath)
{
	k CList
	k myIdx
    //***********百科管理**************************/
	//知识库注册
	s CList($i(CList))= "CT.WDT.CDSS.TermBaseD.GBL"  //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseI.GBL" //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyI.GBL"  //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyD.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyC.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseExtendProI.GBL" //术语库注册扩展属性表
    //知识管理
    s CList($i(CList))= "CT.WDT.CDSS.TermD.GBL"  //术语表
    s CList($i(CList))= "CT.WDT.CDSS.TermI.GBL"  //术语表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyD.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyI.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyC.GBL"  //术语属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProI.GBL" //术语扩展属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailD.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailI.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValD.GBL" //扩展属性值表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValI.GBL" //扩展属性值表
			
	//把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"CDSSBKData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)
	w time,!
	s filename = filePath_"CDSSBKData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator：丁亚男
/// CreatDate:2022-03-09
/// Description:k掉临床辅助决策支持系统百科管理global
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).KillCDSSBKGlobal()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","CDSSBKData20220309.gof")
ClassMethod KillCDSSBKGlobal()
{
	b ;确定库是否正确？？？确定的话输 g 不确定输 q	
	b ;确定要删除CDSS百科的所有数据吗？确定的话输 g 不确定输 q	
	
	
	//***********百科管理**************************/
	//知识库注册
	k ^CT.WDT.CDSS.TermBaseD	//术语库注册表 
	k ^CT.WDT.CDSS.TermBaseI	//术语库注册表 
	k ^CT.WDT.CDSS.TermBasePropertyI	//术语库注册属性表 
	k ^CT.WDT.CDSS.TermBasePropertyD	//术语库注册属性表
	k ^CT.WDT.CDSS.TermBasePropertyC	//术语库注册属性表	
 	k ^CT.WDT.CDSS.TermBaseExtendProI	//术语库注册扩展属性表
 	
 	//知识管理
 	k ^CT.WDT.CDSS.TermD	//术语表
 	k ^CT.WDT.CDSS.TermI	//术语表
	k ^CT.WDT.CDSS.TermPropertyD	//术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyI	//术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyC	//术语属性表
	k ^CT.WDT.CDSS.TermExtendProI	//术语扩展属性表
	k ^CT.WDT.CDSS.TermProDetailD	//术语属性内容表
	k ^CT.WDT.CDSS.TermProDetailI	//术语属性内容表
	k ^CT.WDT.CDSS.TermExtendProValD	//扩展属性值表
	k ^CT.WDT.CDSS.TermExtendProValI	//扩展属性值表
	
	q "OK"
}

/// Creator：丁亚男
/// CreatDate:2022-06-13
/// Description:导出诊疗规则库数据
/// Others：d ##class(web.CDSS.Public.CDSSDataBackup).ExportMedRuleGlobal("D:\CDSSGlobal\NewTable\")
ClassMethod ExportMedRuleGlobal(filePath)
{
	k CList
	k myIdx

	//*************4.5.	诊疗规则知识库表*****************/
	
	//4.5.1.	诊疗规则字典表
	s CList($i(CList))= "User.DHCDSSMedicalRuleD.GBL"
	s CList($i(CList))= "User.DHCDSSMedicalRuleI.GBL"
	//4.5.2.	诊疗规则关联规则条件表
	s CList($i(CList))= "User.DHCDSSRuleTriggerD.GBL"
	s CList($i(CList))= "User.DHCDSSRuleTriggerI.GBL"	
	//4.5.3.	诊疗规则规则条件关联子规则条件表
	s CList($i(CList))= "User.DHCDSSChildRuleTriggerD.GBL"
	s CList($i(CList))= "User.DHCDSSChildRuleTriggerI.GBL"	
	//4.5.4.	诊疗规则申请操作记录表
	s CList($i(CList))= "User.DHCDSSRuleApplyRecordD.GBL"
	s CList($i(CList))= "User.DHCDSSRuleApplyRecordI.GBL"
	
	//推荐疑似疾病中单一规则表 2020-11-17
	s CList($i(CList))= "User.DHCDSSSingleSymptomRuleD.GBL"	
	s CList($i(CList))= "User.DHCDSSSingleSymptomRuleI.GBL"	
	
	//阻断医嘱表 2021-08-12
	s CList($i(CList))= "User.DHCDSSBlockOrderListD.GBL"
	s CList($i(CList))= "User.DHCDSSBlockOrderListI.GBL"	
	//特殊诊疗规则配置表 2021-08-12
	s CList($i(CList))= "User.DHCDSSSpecialRuleConfigD.GBL"	
	s CList($i(CList))= "User.DHCDSSSpecialRuleConfigI.GBL"	
	
	
			
	//把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"MedRuleData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)
	w time,!
	s filename = filePath_"MedRuleData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator：丁亚男
/// CreatDate:2022-06-13
/// Description:k掉诊疗规则库global
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).KillMedRuleGlobal()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","MedRuleData.gof")
ClassMethod KillMedRuleGlobal()
{
	b ;确定库是否正确？？？确定的话输 g 不确定输 q	
	b ;确定要删除CDSS的所有数据吗？确定的话输 g 不确定输 q	
	
	//*************4.5.	诊疗规则知识库表*****************/
	
	//4.5.1.	诊疗规则字典表
	k ^User.DHCDSSMedicalRuleD
	k ^User.DHCDSSMedicalRuleI
	//4.5.2.	诊疗规则关联规则条件表
	k ^User.DHCDSSRuleTriggerD
	k ^User.DHCDSSRuleTriggerI	
	//4.5.3.	诊疗规则规则条件关联子规则条件表
	k ^User.DHCDSSChildRuleTriggerD
	k ^User.DHCDSSChildRuleTriggerI	
	//4.5.4.	诊疗规则申请操作记录表
	k ^User.DHCDSSRuleApplyRecordD
	k ^User.DHCDSSRuleApplyRecordI	
	
	//推荐疑似疾病中单一规则表 2020-11-17
	k ^User.DHCDSSSingleSymptomRuleD
	k ^User.DHCDSSSingleSymptomRuleI	

	//阻断医嘱表 2021-08-12
	k ^User.DHCDSSBlockOrderListD
	k ^User.DHCDSSBlockOrderListI
	//特殊诊疗规则配置表 2021-08-12
	k ^User.DHCDSSSpecialRuleConfigD	
	k ^User.DHCDSSSpecialRuleConfigI
		
	
	q "over"
}

/// Creator：谷雪萍
/// CreatDate:2022-10-13
/// Description:mapping CDSSV2.0的数据，把命名不规范的表的数据映射到新表
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).MappingCDSSV2Global()
ClassMethod MappingCDSSV2Global()
{
	
	b ;正在mapping CDSS2.0的数据，请确定库是否正确？？？确定的话输 g 不确定输 q 
	b ;确定要继续mapping所有CDSS2.0的数据吗？确定的话输 g 不确定输 q 
	m ^WDT.CDSS.ChiefTasksD=^CT.WDT.CDSS.ChiefTasksD





	m ^WDT.CDSS.DEMONLPIdentifyD=^CT.WDT.CDSS.DEMONLPIdentifyD
	m ^WDT.CDSS.DEMORareDiseRecD=^CT.WDT.CDSS.DEMORareDiseRecD
	m ^WDT.CDSS.DEMORDRDetailD=^CT.WDT.CDSS.DEMORDRDetailD
	m ^WDT.CDSS.DEMOSDRDetailD=^CT.WDT.CDSS.DEMOSDRDetailD
	m ^WDT.CDSS.DEMOSuspDiseRecD=^CT.WDT.CDSS.DEMOSuspDiseRecD
	m ^WDT.CDSS.DEMOTasksD=^CT.WDT.CDSS.DEMOTasksD
	m ^WDT.CDSS.DEMOTasksDetailD=^CT.WDT.CDSS.DEMOTasksDetailD
	m ^WDT.CDSS.DEMOTasksHitRateD=^CT.WDT.CDSS.DEMOTasksHitRateD

	m ^CT.WDT.CDSS.DosageFormD=^CT.WDT.CDSS.DHCDSSDosageFormD

	m ^WDT.CDSS.DocTasksD=^CT.WDT.CDSS.DocTasksD
	m ^WDT.CDSS.DocTasksDetailD=^CT.WDT.CDSS.DocTasksDetailD


















	m ^WDT.CDSS.TriggIWRecordD=^CT.WDT.CDSS.TriggIWRecordD
	m ^WDT.CDSS.TriggLISRDetailD=^CT.WDT.CDSS.TriggLISRDetailD
	m ^WDT.CDSS.TriggNLPIdentifyD=^CT.WDT.CDSS.TriggNLPIdentifyD
	m ^WDT.CDSS.TriggTasksD=^CT.WDT.CDSS.TriggTasksD
	m ^WDT.CDSS.TriggTasksDetailD=^CT.WDT.CDSS.TriggTasksDetailD
	m ^CT.WDT.CDSS.AssConResCondiD=^CT.WDT.MKB.AssConResCondiD
	m ^CF.WDT.CDSS.ConfigCategoryD=^CT.WDT.MKB.ConfigCategoryD


	m ^WDT.CDSS.DataFrequencyD=^User.BDPDataFrequencyD


	m ^CT.WDT.CDSS.AllergyDictD=^User.DHCDSSAllergyDictD
	m ^WDT.CDSS.AllergyHistoryD=^User.DHCDSSAllergyHistoryD
	m ^WDT.CDSS.AnestInfoD=^User.DHCDSSAnestInfoD
	m ^CT.WDT.CDSS.AssBasicInfoD=^User.DHCDSSAssBasicInfoD
	m ^CT.WDT.CDSS.AssConDeptD=^User.DHCDSSAssConDeptD
	m ^CT.WDT.CDSS.AssConDocD=^User.DHCDSSAssConDocD
	m ^CT.WDT.CDSS.AssessResultDictD=^User.DHCDSSAssessResultDictD
	m ^CT.WDT.CDSS.AssKeyWordsD=^User.DHCDSSAssKeyWordsD
	m ^CT.WDT.CDSS.AttributeDictD=^User.DHCDSSAttributeDictD
	
	m ^CT.WDT.CDSS.BloodProductDictD=^User.DHCDSSBloodProductDictD
	m ^WDT.CDSS.BloodTransInfoD=^User.DHCDSSBloodTransInfoD
	
	
	m ^CT.WDT.CDSS.BodyPartsDictD=^User.DHCDSSBodyPartsDictD
	m ^CT.WDT.CDSS.BPClassDictD=^User.DHCDSSBPClassDictD
	m ^WDT.CDSS.CarryDrugD=^User.DHCDSSCarryDrugD
	m ^CT.WDT.CDSS.ChartNodeTypeConD=^User.DHCDSSChartNodeTypeConD
	m ^CT.WDT.CDSS.ChartTypeD=^User.DHCDSSChartTypeD
	m ^WDT.CDSS.ChiefCompInfoD=^User.DHCDSSChiefCompInfoD
	m ^WDT.CDSS.ChiefDiaHitRateD=^User.DHCDSSChiefDiaHitRateD
	m ^WDT.CDSS.ChiefIdentifyD=^User.DHCDSSChiefIdentifyD
	m ^WDT.CDSS.ChiefIdentifyEvalD=^User.DHCDSSChiefIdentifyEvalD
	m ^WDT.CDSS.ClinicalFDetailedD=^User.DHCDSSClinicalFDetailedD
	m ^WDT.CDSS.ClinicalFeatureD=^User.DHCDSSClinicalFeatureD
	m ^CT.WDT.CDSS.CommonDictD=^User.DHCDSSCommonDictD
	m ^CT.WDT.CDSS.CommonDictTypeD=^User.DHCDSSCommonDictTypeD
	m ^CT.WDT.CDSS.ConDiseaseDictD=^User.DHCDSSConDiseaseDictD
	m ^CT.WDT.CDSS.ConDrugDictD=^User.DHCDSSConDrugDictD
	m ^CT.WDT.CDSS.ConExamDictD=^User.DHCDSSConExamDictD
	m ^CT.WDT.CDSS.ConNurseDictD=^User.DHCDSSConNurseDictD
	m ^CT.WDT.CDSS.ConOperDictD=^User.DHCDSSConOperDictD
	m ^CT.WDT.CDSS.ConsultationDictD=^User.DHCDSSConsultationDictD
	m ^CT.WDT.CDSS.ContrastDictD=^User.DHCDSSContrastDictD
	m ^WDT.CDSS.CurrentMedHistoryD=^User.DHCDSSCurrentMedHistoryD
	m ^CT.WDT.CDSS.CustomerHospD=^User.DHCDSSCustomerHospD
	m ^CT.WDT.CDSS.DataTableDictD=^User.DHCDSSDataTableDictD
	m ^WDT.CDSS.DEMOAdmNursRecD=^User.DHCDSSDEMOAdmNursRecD
	m ^WDT.CDSS.DEMOAdmRecD=^User.DHCDSSDEMOAdmRecD
	m ^WDT.CDSS.DEMOAnesRecD=^User.DHCDSSDEMOAnesRecD
	m ^WDT.CDSS.DEMOBloodTransD=^User.DHCDSSDEMOBloodTransD
	m ^WDT.CDSS.DEMOCheckRecD=^User.DHCDSSDEMOCheckRecD
	m ^WDT.CDSS.DEMOConsentFormD=^User.DHCDSSDEMOConsentFormD
	m ^WDT.CDSS.DEMOConsultOrdersD=^User.DHCDSSDEMOConsultOrdersD
	m ^WDT.CDSS.DEMOConsultRecD=^User.DHCDSSDEMOConsultRecD
	m ^WDT.CDSS.DEMOCriConNoteD=^User.DHCDSSDEMOCriConNoteD
	m ^WDT.CDSS.DEMODailyCuzRecD=^User.DHCDSSDEMODailyCuzRecD
	m ^WDT.CDSS.DEMODeathOrdersD=^User.DHCDSSDEMODeathOrdersD
	m ^WDT.CDSS.DEMODeathRecD=^User.DHCDSSDEMODeathRecD
	m ^WDT.CDSS.DEMODiagEntryD=^User.DHCDSSDEMODiagEntryD
	m ^WDT.CDSS.DEMODischargeDrugD=^User.DHCDSSDEMODischargeDrugD
	m ^WDT.CDSS.DEMODischargeRecD=^User.DHCDSSDEMODischargeRecD
	m ^WDT.CDSS.DEMODrugOrdersD=^User.DHCDSSDEMODrugOrdersD
	m ^WDT.CDSS.DEMODthDiscuzRecD=^User.DHCDSSDEMODthDiscuzRecD
	m ^WDT.CDSS.DEMOExamOrdersD=^User.DHCDSSDEMOExamOrdersD
	m ^WDT.CDSS.DEMOFstCuzRecD=^User.DHCDSSDEMOFstCuzRecD
	m ^WDT.CDSS.DEMOHadorRecD=^User.DHCDSSDEMOHadorRecD
	m ^WDT.CDSS.DEMOLabOrdersD=^User.DHCDSSDEMOLabOrdersD
	m ^WDT.CDSS.DEMOLISReportD=^User.DHCDSSDEMOLISReportD
	m ^WDT.CDSS.DEMOLISReportDetailD=^User.DHCDSSDEMOLISReportDetailD
	m ^WDT.CDSS.DEMONursAssessRecD=^User.DHCDSSDEMONursAssessRecD
	m ^WDT.CDSS.DEMONursingOrdersD=^User.DHCDSSDEMONursingOrdersD
	m ^WDT.CDSS.DEMOOperaApplyD=^User.DHCDSSDEMOOperaApplyD
	m ^WDT.CDSS.DEMOOperaOrdersD=^User.DHCDSSDEMOOperaOrdersD
	m ^WDT.CDSS.DEMOOperaRecD=^User.DHCDSSDEMOOperaRecD
	m ^WDT.CDSS.DEMOPatMasterD=^User.DHCDSSDEMOPatMasterD
	m ^WDT.CDSS.DEMOPostFstCuzD=^User.DHCDSSDEMOPostFstCuzD
	m ^WDT.CDSS.DEMOPreOpDiscuzRecD=^User.DHCDSSDEMOPreOpDiscuzRecD
	m ^WDT.CDSS.DEMOPreSumD=^User.DHCDSSDEMOPreSumD
	m ^WDT.CDSS.DEMORescuRecD=^User.DHCDSSDEMORescuRecD
	m ^WDT.CDSS.DEMORISReportD=^User.DHCDSSDEMORISReportD
	m ^WDT.CDSS.DEMOShiftRecD=^User.DHCDSSDEMOShiftRecD
	m ^WDT.CDSS.DEMOSignD=^User.DHCDSSDEMOSignD
	m ^WDT.CDSS.DEMOStageSumD=^User.DHCDSSDEMOStageSumD
	m ^WDT.CDSS.DEMOSupCheckRecD=^User.DHCDSSDEMOSupCheckRecD
	m ^WDT.CDSS.DEMOTFAdmDisRecD=^User.DHCDSSDEMOTFAdmDisRecD
	m ^WDT.CDSS.DEMOTFDeathRecD=^User.DHCDSSDEMOTFDeathRecD
	m ^WDT.CDSS.DEMOTlkAbtDifCaseD=^User.DHCDSSDEMOTlkAbtDifCaseD
	m ^WDT.CDSS.DEMOTransInRecD=^User.DHCDSSDEMOTransInRecD
	m ^WDT.CDSS.DEMOTransOutRecD=^User.DHCDSSDEMOTransOutRecD
	m ^WDT.CDSS.DEMOTraOpRecD=^User.DHCDSSDEMOTraOpRecD
	
	
	m ^CT.WDT.CDSS.DiagFactorBaseD=^User.DHCDSSDiagFactorBaseD
	m ^WDT.CDSS.DiagnosisInfoD=^User.DHCDSSDiagnosisInfoD
	m ^WDT.CDSS.DietInfoD=^User.DHCDSSDietInfoD
	m ^CT.WDT.CDSS.DiseaseDeptDictD=^User.DHCDSSDiseaseDeptDictD
	m ^CT.WDT.CDSS.DiseaseDictD=^User.DHCDSSDiseaseDictD
	m ^CT.WDT.CDSS.DiseJFactorD=^User.DHCDSSDiseJFactorD
	m ^CT.WDT.CDSS.DiseJFactorCombD=^User.DHCDSSDiseJFactorCombD
	m ^CT.WDT.CDSS.DiseJIWordsD=^User.DHCDSSDiseJIWordsD
	m ^CT.WDT.CDSS.DiseJoinAssessD=^User.DHCDSSDiseJoinAssessmentD
	m ^CT.WDT.CDSS.DiseJPropertyD=^User.DHCDSSDiseJPropertyD
	m ^CT.WDT.CDSS.DocuAgencyD=^User.DHCDSSDocuAgencyD
	m ^CT.WDT.CDSS.DocuDetailD=^User.DHCDSSDocuDetailD
	m ^CT.WDT.CDSS.DocuJoinDeptD=^User.DHCDSSDocuJoinDeptD
	m ^CT.WDT.CDSS.DocuJoinDiseaseD=^User.DHCDSSDocuJoinDiseaseD
	m ^CT.WDT.CDSS.DocuManageD=^User.DHCDSSDocuManageD
	m ^CT.WDT.CDSS.DrugDictD=^User.DHCDSSDrugDictD
	m ^WDT.CDSS.DrugInfoD=^User.DHCDSSDrugInfoD
	m ^CT.WDT.CDSS.DrugTypeDictD=^User.DHCDSSDrugTypeDictD
	
	m ^CT.WDT.CDSS.ExamDictD=^User.DHCDSSExamDictD
	m ^WDT.CDSS.ExamInfoD=^User.DHCDSSExamInfoD
	m ^CT.WDT.CDSS.ExamResultDictD=^User.DHCDSSExamResultDictD
	m ^CT.WDT.CDSS.ExtendCodeDictD=^User.DHCDSSExtendCodeDictD
	m ^WDT.CDSS.FamilyHisInfoD=^User.DHCDSSFamilyHisInfoD
	m ^WDT.CDSS.FeedbackD=^User.DHCDSSFeedbackD
	m ^CT.WDT.CDSS.FrequencyDictD=^User.DHCDSSFrequencyDictD
	m ^CT.WDT.CDSS.IdentifyWIndexD=^User.DHCDSSIdentifyWIndexD
	m ^CT.WDT.CDSS.IdentifyWordsD=^User.DHCDSSIdentifyWordsD
	m ^WDT.CDSS.InpatientInfoD=^User.DHCDSSInpatientInfoD
	m ^CT.WDT.CDSS.ConClassDictD=^User.DHCDSSInterfaceClassDictD
	

	
	
	
	
	m ^WDT.CDSS.LabExamInfoD=^User.DHCDSSLabExamInfoD
	m ^WDT.CDSS.LabInfoD=^User.DHCDSSLabInfoD
	m ^CT.WDT.CDSS.LabInspectionDictD=^User.DHCDSSLabInspectionDictD
	m ^CT.WDT.CDSS.LabOrdersDictD=^User.DHCDSSLabOrdersDictD
	m ^CT.WDT.CDSS.LabResultDictD=^User.DHCDSSLabResultDictD
	m ^CT.WDT.CDSS.LabSpecimenDictD=^User.DHCDSSLabSpecimenDictD
	m ^WDT.CDSS.MarryInfoD=^User.DHCDSSMarryInfoD
	m ^CT.WDT.CDSS.NodeTypeD=^User.DHCDSSNodeTypeD
	m ^CT.WDT.CDSS.NurseResultDictD=^User.DHCDSSNurseResultDictD
	
	m ^CT.WDT.CDSS.NursingDictD=^User.DHCDSSNursingDictD
	m ^WDT.CDSS.NursingInfoD=^User.DHCDSSNursingInfoD
	m ^CT.WDT.CDSS.OperationDictD=^User.DHCDSSOperationDictD
	m ^WDT.CDSS.OperationInfoD=^User.DHCDSSOperationInfoD
	m ^CT.WDT.CDSS.OperJoinDeptD=^User.DHCDSSOperJoinDeptD
	m ^WDT.CDSS.OtherDisOrderInfoD=^User.DHCDSSOtherDisOrderInfoD
	m ^WDT.CDSS.OtherOrderInfoD=^User.DHCDSSOtherOrderInfoD
	m ^WDT.CDSS.PastDiagnosisD=^User.DHCDSSPastDiagnosisD
	m ^CT.WDT.CDSS.PathogenyDictD=^User.DHCDSSPathogenyDictD
	m ^WDT.CDSS.PatientMasterD=^User.DHCDSSPatientMasterD
	m ^WDT.CDSS.PatientRatingScaleD=^User.DHCDSSPatientRatingScaleD
	m ^WDT.CDSS.PatientRecomInfoD=^User.DHCDSSPatientRecomInfoD
	m ^WDT.CDSS.PatientTransferD=^User.DHCDSSPatientTransferD
	m ^WDT.CDSS.PatientVisitD=^User.DHCDSSPatientVisitD
	m ^WDT.CDSS.PatPMTypeIndexD=^User.DHCDSSPatPMTypeIndexD
	m ^WDT.CDSS.PatTriggerIWD=^User.DHCDSSPatTriggerIWD
	m ^WDT.CDSS.PatTriggerRuleD=^User.DHCDSSPatTriggerRuleD
	m ^WDT.CDSS.PersonalInfoD=^User.DHCDSSPersonalInfoD
	m ^WDT.CDSS.PhysicalExamD=^User.DHCDSSPhysicalExamD
	m ^CT.WDT.CDSS.PhysicalExamDictD=^User.DHCDSSPhysicalExamDictD

	m ^CT.WDT.CDSS.RuleBasisD=^User.DHCDSSRuleBasisD
	m ^CT.WDT.CDSS.RuleChartD=^User.DHCDSSRuleChartD
	m ^CT.WDT.CDSS.RuleChartS=^User.DHCDSSRuleChartS
	m ^CT.WDT.CDSS.RuleComplicationD=^User.DHCDSSRuleComplicationD
	m ^CT.WDT.CDSS.RuleConditionD=^User.DHCDSSRuleConditionD
	m ^CT.WDT.CDSS.RuleDetailD=^User.DHCDSSRuleDetailD
	m ^CT.WDT.CDSS.RuleDictD=^User.DHCDSSRuleDictD
	m ^CT.WDT.CDSS.RuleIndexD=^User.DHCDSSRuleIndexD
	m ^CT.WDT.CDSS.RuleLinkD=^User.DHCDSSRuleLinkD
	m ^CT.WDT.CDSS.RuleNodeD=^User.DHCDSSRuleNodeD
	m ^CT.WDT.CDSS.RuleRationalityD=^User.DHCDSSRuleRationalityD
	m ^CT.WDT.CDSS.RuleResultD=^User.DHCDSSRuleResultD
	m ^WDT.CDSS.SignInfoD=^User.DHCDSSSignInfoD
	m ^WDT.CDSS.SpecExamD=^User.DHCDSSSpecExamD
	m ^CT.WDT.CDSS.SymptomDictD=^User.DHCDSSSymptomDictD
	m ^CT.WDT.CDSS.TCMAcupointsD=^User.DHCDSSTCMAcupointsD
	m ^CT.WDT.CDSS.TCMDecoctionD=^User.DHCDSSTCMDecoctionD
	m ^CT.WDT.CDSS.TCMDiseaseD=^User.DHCDSSTCMDiseaseD
	m ^CT.WDT.CDSS.TCMMedicineD=^User.DHCDSSTCMMedicineD
	m ^CT.WDT.CDSS.TCMPreJoinMedD=^User.DHCDSSTCMPreJoinMedD
	m ^CT.WDT.CDSS.TCMPrescriptionD=^User.DHCDSSTCMPrescriptionD
	m ^CT.WDT.CDSS.TCMSymptomD=^User.DHCDSSTCMSymptomD
	m ^CT.WDT.CDSS.TreatDictD=^User.DHCDSSTreatDictD
	m ^CT.WDT.CDSS.UnitConversionD=^User.DHCDSSUnitConversionD
	m ^CT.WDT.CDSS.UnitDictD=^User.DHCDSSUnitDictD
	m ^CT.WDT.CDSS.UsageDictD=^User.DHCDSSUsageDictD
	
	
	m ^CT.WDT.CDSS.WordsChartD=^User.DHCDSSWordsChartD
	m ^CT.WDT.CDSS.WordsChartS=^User.DHCDSSWordsChartS
	m ^CT.WDT.CDSS.WordsConditionD=^User.DHCDSSWordsConditionD
	m ^CT.WDT.CDSS.WordsItemD=^User.DHCDSSWordsItemD
	m ^CT.WDT.CDSS.WordsLinkD=^User.DHCDSSWordsLinkD
	m ^CT.WDT.CDSS.WordsNodeD=^User.DHCDSSWordsNodeD
	m ^WDT.CDSS.WriteBackInfoD=^User.DHCDSSWriteBackInfoD
	m ^CT.WDT.CDSS.AssBaseD=^User.MKBAssessmentBaseD
	m ^CT.WDT.CDSS.AssBaseC=^User.MKBAssessmentBaseC
	m ^CT.WDT.CDSS.AssBaseFieldD=^User.MKBAssessmentBaseFieldD
	m ^CT.WDT.CDSS.AssScoringRulesD=^User.MKBAssessmentScoringRulesD
	m ^CF.WDT.CDSS.MKBConfigD=^User.MKBConfigD
	m ^CF.WDT.CDSS.MKBConfigDetailD=^User.MKBConfigDetailD
	m ^CF.WDT.CDSS.DataChangeLogD=^User.MKBDataChangeLogD




	m ^CT.WDT.CDSS.SingleSymptomRuleD=^User.DHCDSSSingleSymptomRuleD


	d ##class(WDT.CDSS.ChiefTasks).%BuildIndices()





	d ##class(WDT.CDSS.DEMONLPIdentify).%BuildIndices()
	d ##class(WDT.CDSS.DEMORareDiseRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMORDRDetail).%BuildIndices()
	d ##class(WDT.CDSS.DEMOSDRDetail).%BuildIndices()
	d ##class(WDT.CDSS.DEMOSuspDiseRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTasks).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTasksDetail).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTasksHitRate).%BuildIndices()

	d ##class(CT.WDT.CDSS.DosageForm).%BuildIndices()

	d ##class(WDT.CDSS.DocTasks).%BuildIndices()
	d ##class(WDT.CDSS.DocTasksDetail).%BuildIndices()


















	d ##class(WDT.CDSS.TriggIWRecord).%BuildIndices()
	d ##class(WDT.CDSS.TriggLISRDetail).%BuildIndices()
	d ##class(WDT.CDSS.TriggNLPIdentify).%BuildIndices()
	d ##class(WDT.CDSS.TriggTasks).%BuildIndices()
	d ##class(WDT.CDSS.TriggTasksDetail).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssConResCondi).%BuildIndices()
	d ##class(CF.WDT.CDSS.ConfigCategory).%BuildIndices()


	d ##class(WDT.CDSS.DataFrequency).%BuildIndices()


	d ##class(CT.WDT.CDSS.AllergyDict).%BuildIndices()
	d ##class(WDT.CDSS.AllergyHistory).%BuildIndices()
	d ##class(WDT.CDSS.AnestInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssBasicInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssConDept).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssConDoc).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssessResultDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssKeyWords).%BuildIndices()
	d ##class(CT.WDT.CDSS.AttributeDict).%BuildIndices()
	
	d ##class(CT.WDT.CDSS.BloodProductDict).%BuildIndices()
	d ##class(WDT.CDSS.BloodTransInfo).%BuildIndices()
	
	
	d ##class(CT.WDT.CDSS.BodyPartsDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.BPClassDict).%BuildIndices()
	d ##class(WDT.CDSS.CarryDrug).%BuildIndices()
	d ##class(CT.WDT.CDSS.ChartNodeTypeCon).%BuildIndices()
	d ##class(CT.WDT.CDSS.ChartType).%BuildIndices()
	d ##class(WDT.CDSS.ChiefCompInfo).%BuildIndices()
	d ##class(WDT.CDSS.ChiefDiaHitRate).%BuildIndices()
	d ##class(WDT.CDSS.ChiefIdentify).%BuildIndices()
	d ##class(WDT.CDSS.ChiefIdentifyEval).%BuildIndices()
	d ##class(WDT.CDSS.ClinicalFDetailed).%BuildIndices()
	d ##class(WDT.CDSS.ClinicalFeature).%BuildIndices()
	d ##class(CT.WDT.CDSS.CommonDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.CommonDictType).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConDiseaseDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConDrugDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConExamDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConNurseDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConOperDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConsultationDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ContrastDict).%BuildIndices()
	d ##class(WDT.CDSS.CurrentMedHistory).%BuildIndices()
	d ##class(CT.WDT.CDSS.CustomerHosp).%BuildIndices()
	d ##class(CT.WDT.CDSS.DataTableDict).%BuildIndices()
	d ##class(WDT.CDSS.DEMOAdmNursRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOAdmRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOAnesRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOBloodTrans).%BuildIndices()
	d ##class(WDT.CDSS.DEMOCheckRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOConsentForm).%BuildIndices()
	d ##class(WDT.CDSS.DEMOConsultOrders).%BuildIndices()
	d ##class(WDT.CDSS.DEMOConsultRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOCriConNote).%BuildIndices()
	d ##class(WDT.CDSS.DEMODailyCuzRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMODeathOrders).%BuildIndices()
	d ##class(WDT.CDSS.DEMODeathRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMODiagEntry).%BuildIndices()
	d ##class(WDT.CDSS.DEMODischargeDrug).%BuildIndices()
	d ##class(WDT.CDSS.DEMODischargeRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMODrugOrders).%BuildIndices()
	d ##class(WDT.CDSS.DEMODthDiscuzRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOExamOrders).%BuildIndices()
	d ##class(WDT.CDSS.DEMOFstCuzRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOHadorRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOLabOrders).%BuildIndices()
	d ##class(WDT.CDSS.DEMOLISReport).%BuildIndices()
	d ##class(WDT.CDSS.DEMOLISReportDetail).%BuildIndices()
	d ##class(WDT.CDSS.DEMONursAssessRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMONursingOrders).%BuildIndices()
	d ##class(WDT.CDSS.DEMOOperaApply).%BuildIndices()
	d ##class(WDT.CDSS.DEMOOperaOrders).%BuildIndices()
	d ##class(WDT.CDSS.DEMOOperaRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOPatMaster).%BuildIndices()
	d ##class(WDT.CDSS.DEMOPostFstCuz).%BuildIndices()
	d ##class(WDT.CDSS.DEMOPreOpDiscuzRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOPreSum).%BuildIndices()
	d ##class(WDT.CDSS.DEMORescuRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMORISReport).%BuildIndices()
	d ##class(WDT.CDSS.DEMOShiftRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOSign).%BuildIndices()
	d ##class(WDT.CDSS.DEMOStageSum).%BuildIndices()
	d ##class(WDT.CDSS.DEMOSupCheckRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTFAdmDisRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTFDeathRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTlkAbtDifCase).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTransInRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTransOutRec).%BuildIndices()
	d ##class(WDT.CDSS.DEMOTraOpRec).%BuildIndices()
	
	
	d ##class(CT.WDT.CDSS.DiagFactorBase).%BuildIndices()
	d ##class(WDT.CDSS.DiagnosisInfo).%BuildIndices()
	d ##class(WDT.CDSS.DietInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.DiseaseDeptDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.DiseaseDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.DiseJFactor).%BuildIndices()
	d ##class(CT.WDT.CDSS.DiseJFactorComb).%BuildIndices()
	d ##class(CT.WDT.CDSS.DiseJIWords).%BuildIndices()
	d ##class(CT.WDT.CDSS.DiseJoinAssess).%BuildIndices()
	d ##class(CT.WDT.CDSS.DiseJProperty).%BuildIndices()
	d ##class(CT.WDT.CDSS.DocuAgency).%BuildIndices()
	d ##class(CT.WDT.CDSS.DocuDetail).%BuildIndices()
	d ##class(CT.WDT.CDSS.DocuJoinDept).%BuildIndices()
	d ##class(CT.WDT.CDSS.DocuJoinDisease).%BuildIndices()
	d ##class(CT.WDT.CDSS.DocuManage).%BuildIndices()
	d ##class(CT.WDT.CDSS.DrugDict).%BuildIndices()
	d ##class(WDT.CDSS.DrugInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.DrugTypeDict).%BuildIndices()
	
	d ##class(CT.WDT.CDSS.ExamDict).%BuildIndices()
	d ##class(WDT.CDSS.ExamInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.ExamResultDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ExtendCodeDict).%BuildIndices()
	d ##class(WDT.CDSS.FamilyHisInfo).%BuildIndices()
	d ##class(WDT.CDSS.Feedback).%BuildIndices()
	d ##class(CT.WDT.CDSS.FrequencyDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.IdentifyWIndex).%BuildIndices()
	d ##class(CT.WDT.CDSS.IdentifyWords).%BuildIndices()
	d ##class(WDT.CDSS.InpatientInfo).%BuildIndices()







	d ##class(WDT.CDSS.LabExamInfo).%BuildIndices()
	d ##class(WDT.CDSS.LabInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.LabInspectionDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.LabOrdersDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.LabResultDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.LabSpecimenDict).%BuildIndices()
	d ##class(WDT.CDSS.MarryInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.NodeType).%BuildIndices()
	d ##class(CT.WDT.CDSS.NurseResultDict).%BuildIndices()
	
	d ##class(CT.WDT.CDSS.NursingDict).%BuildIndices()
	d ##class(WDT.CDSS.NursingInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.OperationDict).%BuildIndices()
	d ##class(WDT.CDSS.OperationInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.OperJoinDept).%BuildIndices()
	d ##class(WDT.CDSS.OtherDisOrderInfo).%BuildIndices()
	d ##class(WDT.CDSS.OtherOrderInfo).%BuildIndices()
	d ##class(WDT.CDSS.PastDiagnosis).%BuildIndices()
	d ##class(CT.WDT.CDSS.PathogenyDict).%BuildIndices()
	d ##class(WDT.CDSS.PatientMaster).%BuildIndices()
	d ##class(WDT.CDSS.PatientRatingScale).%BuildIndices()
	d ##class(WDT.CDSS.PatientRecomInfo).%BuildIndices()
	d ##class(WDT.CDSS.PatientTransfer).%BuildIndices()
	d ##class(WDT.CDSS.PatientVisit).%BuildIndices()
	d ##class(WDT.CDSS.PatPMTypeIndex).%BuildIndices()
	d ##class(WDT.CDSS.PatTriggerIW).%BuildIndices()
	d ##class(WDT.CDSS.PatTriggerRule).%BuildIndices()
	d ##class(WDT.CDSS.PersonalInfo).%BuildIndices()
	d ##class(WDT.CDSS.PhysicalExam).%BuildIndices()	
	d ##class(CT.WDT.CDSS.PhysicalExamDict).%BuildIndices()

	d ##class(CT.WDT.CDSS.RuleBasis).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleChart).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleComplication).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleCondition).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleDetail).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleIndex).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleLink).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleNode).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleRationality).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleResult).%BuildIndices()
	d ##class(WDT.CDSS.SignInfo).%BuildIndices()
	d ##class(WDT.CDSS.SpecExam).%BuildIndices()
	d ##class(CT.WDT.CDSS.SymptomDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.TCMAcupoints).%BuildIndices()
	d ##class(CT.WDT.CDSS.TCMDecoction).%BuildIndices()
	d ##class(CT.WDT.CDSS.TCMDisease).%BuildIndices()
	d ##class(CT.WDT.CDSS.TCMMedicine).%BuildIndices()
	d ##class(CT.WDT.CDSS.TCMPreJoinMed).%BuildIndices()
	d ##class(CT.WDT.CDSS.TCMPrescription).%BuildIndices()
	d ##class(CT.WDT.CDSS.TCMSymptom).%BuildIndices()
	d ##class(CT.WDT.CDSS.TreatDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.UnitConversion).%BuildIndices()
	d ##class(CT.WDT.CDSS.UnitDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.UsageDict).%BuildIndices()
	
	
	d ##class(CT.WDT.CDSS.WordsChart).%BuildIndices()
	d ##class(CT.WDT.CDSS.WordsCondition).%BuildIndices()
	d ##class(CT.WDT.CDSS.WordsItem).%BuildIndices()
	d ##class(CT.WDT.CDSS.WordsLink).%BuildIndices()
	d ##class(CT.WDT.CDSS.WordsNode).%BuildIndices()
	d ##class(WDT.CDSS.WriteBackInfo).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssBase).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssBaseField).%BuildIndices()
	d ##class(CT.WDT.CDSS.AssScoringRules).%BuildIndices()
	d ##class(CF.WDT.CDSS.MKBConfig).%BuildIndices()
	d ##class(CF.WDT.CDSS.MKBConfigDetail).%BuildIndices()
	d ##class(CF.WDT.CDSS.DataChangeLog).%BuildIndices()




	d ##class(CT.WDT.CDSS.SingleSymptomRule).%BuildIndices()
	
	//修改CT_WDT_CDSS.DataTableDict、CT_WDT_CDSS.WordsItem表TableName的数据把User.DHCDSS-》WDT.CDSS.  修改 CT_WDT_CDSS.Alias、CF_WDT_CDSS.ALLDictSearchSet表TableName的数据把User.DHCDSS-》CT.WDT.CDSS.
	d ##class(web.CDSS.Public.CDSSDataBackup).UpdateTableName(2)


	
	q "over"
}

/// Creator：谷雪萍
/// CreatDate:2022-10-26
/// Description:mapping数据后修改CT_WDT_CDSS.DataTableDict、CT_WDT_CDSS.WordsItem表TableName的数据把User.DHCDSS-》WDT.CDSS.
/// 修改 CT_WDT_CDSS.Alias、CF_WDT_CDSS.ALLDictSearchSet、CT.WDT.CDSS.ConClassDict表TableName的数据把User.DHCDSS-》CT.WDT.CDSS.
/// Input:VersionFlag:1->1.0或者1.2版本用，VersionFlag:2:-》2.1版本用（默认）
/// Return:空或false
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).UpdateTableName(VersionFlag)
ClassMethod UpdateTableName(VersionFlag As %String = "")
{
	
	s result=""
	TS
	if (VersionFlag=1)  //如果是1.0、1.2版本用，需要把CT.WDT.CDSS.和WDT.CDSS开头的表名转换为"User.DHCDSS"
	{
		s PreBaseTableName="CT.WDT.CDSS."
		s PreBusTableName="WDT.CDSS."
		s NowBaseTableName="User.DHCDSS"  //基础数据表名开头
		s NowBusTableName="User.DHCDSS"  //业务数据表名开头
		
		s TableDictID=0   //修改数据库字典DHCDSSDataTableDict表TableName的数据把WDT.CDSS.-》User.DHCDSS
		for 
		{
			s TableDictID=$o(^User.DHCDSSDataTableDictD(TableDictID))
			q:TableDictID=""
			s TableName= $lg($g(^User.DHCDSSDataTableDictD(TableDictID)),4)
			s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBusTableName,NowBusTableName)
			s TableDictObj=##class(User.DHCDSSDataTableDict).%OpenId(TableDictID)
			s TableDictObj.TableName=NewTableName
			s TableDictSC=TableDictObj.%Save()
			d TableDictObj.%Close()
			If '$$$ISOK(TableDictSC)
			{
				s result="false"
				q
			}
			
		}
		if (result="")
		{
			s WordsItemID=0   //修改识别词项目字典DHCDSSWordsItem表TableName的数据把WDT.CDSS-》.User.DHCDSS
			for 
			{
				s WordsItemID=$o(^User.DHCDSSWordsItemD(WordsItemID))
				q:WordsItemID=""
				s TableName=$lg($g(^User.DHCDSSWordsItemD(WordsItemID)),6)		//关联表名
				s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBusTableName,NowBusTableName)
				s WordsItemObj=##class(User.DHCDSSWordsItem).%OpenId(WordsItemID)
				s WordsItemObj.TableName=NewTableName
				s WordsItemSC=WordsItemObj.%Save()
				d WordsItemObj.%Close()
				If '$$$ISOK(WordsItemSC)
				{
					s result="false"
					q
				}
			}
		}

		if (result="")   //对接方字典分类表的DictiClassMapping列要改：UPDATE DHCDSSInterfaceClassDict SET DictiClassMapping=replace(DictiClassMapping,'CT.WDT.CDSS.','User.DHCDSS')
		{
			s ConClassDictID=0
			for 
			{
				s ConClassDictID=$o(^User.DHCDSSInterfaceClassDictD(ConClassDictID))
				q:ConClassDictID=""
				s TableName=$lg($g(^User.DHCDSSInterfaceClassDictD(ConClassDictID)),5)		//表名
				s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBaseTableName,NowBaseTableName)
				s ConClassDictObj=##class(User.DHCDSSInterfaceClassDict).%OpenId(ConClassDictID)
				s ConClassDictObj.DictiClassMapping=NewTableName
				s ConClassDictSC=ConClassDictObj.%Save()
				d ConClassDictObj.%Close()
				If '$$$ISOK(ConClassDictSC)
				{
					s result="false"
					q
				}
			}
		}		
	}
	else  //如果是2.1版本用  需要把"User.DHCDSS"开头的表名转换为CT.WDT.CDSS.和WDT.CDSS
	{
		s PreBaseTableName="User.DHCDSS"
		s PreBusTableName="User.DHCDSS"
		s NowBaseTableName="CT.WDT.CDSS."  //基础数据表名开头
		s NowBusTableName="WDT.CDSS."  //业务数据表名开头
	
		s TableDictID=0   //修改CT_WDT_CDSS.DataTableDict表TableName的数据把User.DHCDSS-》WDT.CDSS.
		for 
		{
			s TableDictID=$o(^CT.WDT.CDSS.DataTableDictD(TableDictID))
			q:TableDictID=""
			s TableName= $lg($g(^CT.WDT.CDSS.DataTableDictD(TableDictID)),4)
			s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBusTableName,NowBusTableName)
			s TableDictObj=##class(CT.WDT.CDSS.DataTableDict).%OpenId(TableDictID)
			s TableDictObj.TableName=NewTableName
			s TableDictSC=TableDictObj.%Save()
			d TableDictObj.%Close()
			If '$$$ISOK(TableDictSC)
			{
				s result="false"
				q
			}
			
		}
		if (result="")
		{
			s WordsItemID=0   //修改CT_WDT_CDSS.WordsItem表TableName的数据把User.DHCDSS-》WDT.CDSS.
			for 
			{
				s WordsItemID=$o(^CT.WDT.CDSS.WordsItemD(WordsItemID))
				q:WordsItemID=""
				s TableName=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemID)),6)		//关联表名
				s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBusTableName,NowBusTableName)
				s WordsItemObj=##class(CT.WDT.CDSS.WordsItem).%OpenId(WordsItemID)
				s WordsItemObj.TableName=NewTableName
				s WordsItemSC=WordsItemObj.%Save()
				d WordsItemObj.%Close()
				If '$$$ISOK(WordsItemSC)
				{
					s result="false"
					q
				}
			}
		}
		if (result="")   //对接方字典分类表的DictiClassMapping列要改：UPDATE CT_WDT_CDSS.ConClassDict SET DictiClassMapping=replace(DictiClassMapping,'User.DHCDSS','CT.WDT.CDSS.')
		{
			s ConClassDictID=0
			for 
			{
				s ConClassDictID=$o(^CT.WDT.CDSS.ConClassDictD(ConClassDictID))
				q:ConClassDictID=""
				s TableName=$lg($g(^CT.WDT.CDSS.ConClassDictD(ConClassDictID)),5)		//表名
				s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBaseTableName,NowBaseTableName)
				s ConClassDictObj=##class(CT.WDT.CDSS.ConClassDict).%OpenId(ConClassDictID)
				s ConClassDictObj.DictiClassMapping=NewTableName
				s ConClassDictSC=ConClassDictObj.%Save()
				d ConClassDictObj.%Close()
				If '$$$ISOK(ConClassDictSC)
				{
					s result="false"
					q
				}
			}
		}
	}
	
	if (result="")   //别名表的TableName列要改：UPDATE CT_WDT_CDSS.Alias SET TableName=replace(TableName,'User.DHCDSS','CT.WDT.CDSS.')
	{
		s AliasID=0
		for 
		{
			s AliasID=$o(^CT.WDT.CDSS.AliasD(AliasID))
			q:AliasID=""
			s TableName=$lg($g(^CT.WDT.CDSS.AliasD(AliasID)),2)		//表名
			s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBaseTableName,NowBaseTableName)
			s AliasObj=##class(CT.WDT.CDSS.Alias).%OpenId(AliasID)
			s AliasObj.TableName=NewTableName
			s AliasSC=AliasObj.%Save()
			d AliasObj.%Close()
			If '$$$ISOK(AliasSC)
			{
				s result="false"
				q
			}
		}
	}
	if (result="")   //全文检索配置表的TableName列要改：UPDATE CF_WDT_CDSS.ALLDictSearchSet SET TableName=replace(TableName,'User.DHCDSS','CT.WDT.CDSS.')
	{
		s SearchSetID=0
		for 
		{
			s SearchSetID=$o(^CF.WDT.CDSS.ALLDictSearchSetD(SearchSetID))
			q:SearchSetID=""
			s TableName=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(SearchSetID)),3)		//表名
			s NewTableName=##class(web.BDP.util.String).Replace(TableName,PreBaseTableName,NowBaseTableName)
			s SearchSetObj=##class(CF.WDT.CDSS.ALLDictSearchSet).%OpenId(SearchSetID)
			s SearchSetObj.TableName=NewTableName
			s SearchSetSC=SearchSetObj.%Save()
			d SearchSetObj.%Close()
			If '$$$ISOK(SearchSetSC)
			{
				s result="false"
				q
			}
		}
	}
	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result="true"
	}
	q result
}

/// Creator：谷雪萍
/// CreatDate:2022-10-14
/// Description:导出临床辅助决策支持系统V2.0的global(按命名规范重命名后)
/// Input:ProjectFlag：非空-清掉演示评测系统和智能分诊系统数据（用于腾讯云更数据），空-不清演示评测系统和智能分诊系统数据（用于项目更数据）
/// Return:NEWCDSSV2Data"_time_".gof文件
/// Others：d ##class(web.CDSS.Public.CDSSDataBackup).ExportCDSSV2GlobalNew("D:\CDSSGlobal\NewTable\")
ClassMethod ExportCDSSV2GlobalNew(filePath As %String = "", ProjectFlag As %String = "")
{
	k CList
	k myIdx
	
	//***********字典表**************************/
	
	//治疗方案字典
	s CList($i(CList))= "CT.WDT.CDSS.TreatDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TreatDictI.GBL" 
	//单位字典
	s CList($i(CList))= "CT.WDT.CDSS.UnitDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.UnitDictI.GBL" 			
	//通用字典类型
	s CList($i(CList))= "CT.WDT.CDSS.CommonDictTypeD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.CommonDictTypeI.GBL" 	
	//通用字典
	s CList($i(CList))= "CT.WDT.CDSS.CommonDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.CommonDictI.GBL" 
	//过敏史字典
	s CList($i(CList))= "CT.WDT.CDSS.AllergyDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AllergyDictI.GBL" 	
	//症状字典
	s CList($i(CList))= "CT.WDT.CDSS.SymptomDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.SymptomDictI.GBL" 
	//诱因、病因字典
	s CList($i(CList))= "CT.WDT.CDSS.PathogenyDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.PathogenyDictI.GBL" 
	//检验结果字典
	s CList($i(CList))= "CT.WDT.CDSS.LabResultDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.LabResultDictI.GBL" 
	//检查结果字典
	s CList($i(CList))= "CT.WDT.CDSS.ExamResultDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ExamResultDictI.GBL" 
	//护理结果字典
	s CList($i(CList))= "CT.WDT.CDSS.NurseResultDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.NurseResultDictI.GBL" 
	//评估结果字典
	s CList($i(CList))= "CT.WDT.CDSS.AssessResultDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssessResultDictI.GBL" 
	//定语字典
	s CList($i(CList))= "CT.WDT.CDSS.AttributeDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AttributeDictI.GBL" 
    //扩展码字典
	s CList($i(CList))= "CT.WDT.CDSS.ExtendCodeDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ExtendCodeDictI.GBL" 
	//会诊医嘱字典
	s CList($i(CList))= "CT.WDT.CDSS.ConsultationDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConsultationDictI.GBL" 
	
	//单位转换表
	s CList($i(CList))= "CT.WDT.CDSS.UnitConversionD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.UnitConversionI.GBL" 
	//检验医嘱字典
	s CList($i(CList))= "CT.WDT.CDSS.LabOrdersDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.LabOrdersDictI.GBL" 
	
	//1.3.18. 药物分类字典表
	s CList($i(CList))= "CT.WDT.CDSS.DrugTypeDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DrugTypeDictI.GBL" 
	
	//1.3.18. 剂型字典表
	s CList($i(CList))= "CT.WDT.CDSS.DosageFormD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DosageFormI.GBL" 
	
	//4.3.19. 疾病字典表
	s CList($i(CList))= "CT.WDT.CDSS.DiseaseDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiseaseDictI.GBL" 
	//4.3.20. 药物字典表
	s CList($i(CList))= "CT.WDT.CDSS.DrugDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DrugDictI.GBL" 
	//4.3.21. 检查字典表
	s CList($i(CList))= "CT.WDT.CDSS.ExamDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ExamDictI.GBL" 
	//4.3.22. 检验项目字典表
	s CList($i(CList))= "CT.WDT.CDSS.LabInspectionDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.LabInspectionDictI.GBL" 
	//4.3.23. 用法字典表
	s CList($i(CList))= "CT.WDT.CDSS.UsageDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.UsageDictI.GBL" 
	//4.3.24. 手术字典表
	s CList($i(CList))= "CT.WDT.CDSS.OperationDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.OperationDictI.GBL" 
	//4.3.25. 护理字典表
	s CList($i(CList))= "CT.WDT.CDSS.NursingDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.NursingDictI.GBL" 
	//4.3.26. 输血品字典表
	s CList($i(CList))= "CT.WDT.CDSS.BloodProductDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.BloodProductDictI.GBL" 
	//4.3.27. 检验标本字典表
	s CList($i(CList))= "CT.WDT.CDSS.LabSpecimenDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.LabSpecimenDictI.GBL" 
	//4.3.28. 频率字典表
	s CList($i(CList))= "CT.WDT.CDSS.FrequencyDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.FrequencyDictI.GBL" 
	//4.3.29. 用法字典表
	s CList($i(CList))= "CT.WDT.CDSS.UsageDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.UsageDictI.GBL" 
	//4.3.30. 体格检查字典表
	s CList($i(CList))= "CT.WDT.CDSS.PhysicalExamDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.PhysicalExamDictI.GBL" 
	//4.3.31. 科室字典表
	s CList($i(CList))= "CT.WDT.CDSS.DiseaseDeptDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiseaseDeptDictI.GBL" 
	//4.3.32. 输血品分类字典表
	s CList($i(CList))= "CT.WDT.CDSS.BPClassDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.BPClassDictI.GBL" 
	//4.3.33. 部位字典表
	s CList($i(CList))= "CT.WDT.CDSS.BodyPartsDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.BodyPartsDictI.GBL" 
	//4.3.34. 别名通用表 
	s CList($i(CList))= "CT.WDT.CDSS.AliasD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.AliasI.GBL"
	//4.3.35. 部位层级表 
	s CList($i(CList))= "CT.WDT.CDSS.BodyPartsLevelD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.BodyPartsLevelI.GBL"	
	//4.3.36. 方位词字典表 
	s CList($i(CList))= "CT.WDT.CDSS.PositionWordD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.PositionWordI.GBL"

	 //4.3.37. 同义词检索字典 
	s CList($i(CList))= "CT.WDT.CDSS.SynSearchDictD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.SynSearchDictI.GBL"
	
	//手术关联科室
	s CList($i(CList))= "CT.WDT.CDSS.OperJoinDeptD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.OperJoinDeptI.GBL"
	
	//病历书写支持字典
	s CList($i(CList))= "CT.WDT.CDSS.StructEMRDictD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.StructEMRDictI.GBL"

	//辅助问诊字典
	s CList($i(CList))= "CT.WDT.CDSS.AssistConsultD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.AssistConsultI.GBL"
		
	//************推荐相似病历****************/
	//优质病历字典表
	s CList($i(CList))= "CT.WDT.CDSS.HighQualityEMRD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.HighQualityEMRI.GBL"
	//优质病历关联诊断表
	s CList($i(CList))= "CT.WDT.CDSS.HighQEMRConDiaD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.HighQEMRConDiaI.GBL"
	//优质病历关联诊断因子表
	s CList($i(CList))= "CT.WDT.CDSS.HighQEMRConSymD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.HighQEMRConSymI.GBL"	
		
	//***********出院指导**************************/
	//出院指导字典表
	s CList($i(CList))= "CT.WDT.CDSS.DischargeGuideD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DischargeGuideI.GBL" 
	//出院指导详情表
	s CList($i(CList))= "CT.WDT.CDSS.DGuideDetailD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DGuideDetailI.GBL" 	
	
	
	//***********文献管理**************************/
	
	//文献表
	s CList($i(CList))= "CT.WDT.CDSS.DocuManageD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DocuManageI.GBL" 
	//文献关联诊断
	s CList($i(CList))= "CT.WDT.CDSS.DocuJoinDiseaseD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DocuJoinDiseaseI.GBL" 
	//文献关联科室
	s CList($i(CList))= "CT.WDT.CDSS.DocuJoinDeptD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DocuJoinDeptI.GBL" 	
	//文献详情
	s CList($i(CList))= "CT.WDT.CDSS.DocuDetailD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DocuDetailI.GBL" 
	//4.4.5. 文献发布机构表
	s CList($i(CList))= "CT.WDT.CDSS.DocuAgencyD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DocuAgencyI.GBL" 
	
	//***********疑似诊断管理**************************/
	//疾病关联诊断因子
	s CList($i(CList))= "CT.WDT.CDSS.DiseJFactorD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiseJFactorI.GBL" 
	//疾病关联诊断因子组合
	s CList($i(CList))= "CT.WDT.CDSS.DiseJFactorCombD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiseJFactorCombI.GBL" 
	//疾病关联属性
	s CList($i(CList))= "CT.WDT.CDSS.DiseJPropertyD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiseJPropertyI.GBL" 	
	//诊断因子库
	s CList($i(CList))= "CT.WDT.CDSS.DiagFactorBaseD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiagFactorBaseI.GBL" 
	//4.5.5. 疾病关联识别词表
	s CList($i(CList))= "CT.WDT.CDSS.DiseJIWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiseJIWordsI.GBL" 
	
	//***********字典对照管理**************************/
	/*
	//对接方药品字典
	s CList($i(CList))= "CT.WDT.CDSS.ConDrugDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConDrugDictI.GBL" 
	//对接方诊断字典
	s CList($i(CList))= "CT.WDT.CDSS.ConDiseaseDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConDiseaseDictI.GBL" 
	//对接方检验检查字典
	s CList($i(CList))= "CT.WDT.CDSS.ConExamDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConExamDictI.GBL" 
	//对接方手术字典
	s CList($i(CList))= "CT.WDT.CDSS.ConOperDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConOperDictI.GBL" 
	//对接方护理字典
	s CList($i(CList))= "CT.WDT.CDSS.ConNurseDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConNurseDictI.GBL" 
	//对照字典
	s CList($i(CList))= "CT.WDT.CDSS.ContrastDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ContrastDictI.GBL" 
	//其他类型对接方字典表
	s CList($i(CList))= "CT.WDT.CDSS.ConOtherDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConOtherDictI.GBL" 
	//医院字典表
	s CList($i(CList))= "CT.WDT.CDSS.CustomerHospD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.CustomerHospI.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.CustomerHospC.GBL" 
	//院区
	s CList($i(CList))= "CT.WDT.CDSS.CustomerHospAreaI.GBL" 
	//对接方字典分类表
	s CList($i(CList))= "CT.WDT.CDSS.ConClassDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConClassDictI.GBL"
	
	//4.10.12. 对接方字典关联院区表
	s CList($i(CList))= "CT.WDT.CDSS.ConDictConAreaD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ConDictConAreaI.GBL" 
	*/
	//***********诊疗规则管理**************************/
	//诊疗规则字典
	s CList($i(CList))= "CT.WDT.CDSS.RuleDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleDictI.GBL" 
	//诊疗流程节点
	s CList($i(CList))= "CT.WDT.CDSS.RuleNodeD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleNodeI.GBL" 
	//诊疗流程线表
	s CList($i(CList))= "CT.WDT.CDSS.RuleLinkD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleLinkI.GBL" 	
	//诊疗流程图Json信息表
	s CList($i(CList))= "CT.WDT.CDSS.RuleChartD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleChartI.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleChartS.GBL" 
	//触发条件表
	s CList($i(CList))= "CT.WDT.CDSS.RuleConditionD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleConditionI.GBL" 	
	//诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，推荐确诊）
	s CList($i(CList))= "CT.WDT.CDSS.RuleResultD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleResultI.GBL" 
	//诊疗节点内容表（预警规则-合理性）
	s CList($i(CList))= "CT.WDT.CDSS.RuleRationalityD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleRationalityI.GBL" 
	//诊疗节点内容表（预警规则-并发症）
	s CList($i(CList))= "CT.WDT.CDSS.RuleComplicationD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleComplicationI.GBL" 
	//治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
	s CList($i(CList))= "CT.WDT.CDSS.RuleDetailD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleDetailI.GBL" 	
	//诊疗规则流程类型表
	s CList($i(CList))= "CT.WDT.CDSS.ChartTypeD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ChartTypeI.GBL" 
	//诊疗规则流程节点类型表
	s CList($i(CList))= "CT.WDT.CDSS.NodeTypeD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.NodeTypeI.GBL" 		
	//诊疗规则流程类型与节点类型关联表
	s CList($i(CList))= "CT.WDT.CDSS.ChartNodeTypeConD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.ChartNodeTypeConI.GBL" 
	//诊疗节点内容依据表
	s CList($i(CList))= "CT.WDT.CDSS.RuleBasisD.GBL"	
	s CList($i(CList))= "CT.WDT.CDSS.RuleBasisI.GBL"	
	
	//推荐疑似疾病中单一规则表 
	s CList($i(CList))= "CT.WDT.CDSS.SingleSymptomRuleD.GBL"	
	s CList($i(CList))= "CT.WDT.CDSS.SingleSymptomRuleI.GBL"	
	
	//***********识别词管理**************************/
	//识别词字典
	s CList($i(CList))= "CT.WDT.CDSS.IdentifyWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.IdentifyWordsI.GBL" 
	//识别词流程节点表
	s CList($i(CList))= "CT.WDT.CDSS.WordsNodeD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsNodeI.GBL" 
	//识别词流程线表
	s CList($i(CList))= "CT.WDT.CDSS.WordsLinkD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsLinkI.GBL" 	
	//识别词节点内容表（触发条件）
	s CList($i(CList))= "CT.WDT.CDSS.WordsConditionD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsConditionI.GBL" 
	//识别词流程图Json信息表 （用于还原流程图）
	s CList($i(CList))= "CT.WDT.CDSS.WordsChartD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsChartI.GBL" 	
	s CList($i(CList))= "CT.WDT.CDSS.WordsChartS.GBL" 	
	//识别词项目字典
	s CList($i(CList))= "CT.WDT.CDSS.WordsItemD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsItemI.GBL" 		

	//***********评估表知识库管理**************************/
	//评估表基本信息
	s CList($i(CList))= "CT.WDT.CDSS.AssBasicInfoD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssBasicInfoI.GBL" 
	//评估表关联文献表
	s CList($i(CList))= "CT.WDT.CDSS.AssConDocD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssConDocI.GBL" 
	//评估表关联科室
	s CList($i(CList))= "CT.WDT.CDSS.AssConDeptD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssConDeptI.GBL" 	
	//评估表关联关键字
	s CList($i(CList))= "CT.WDT.CDSS.AssKeyWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssKeyWordsI.GBL" 
	//评估表关联疾病
	s CList($i(CList))= "CT.WDT.CDSS.DiseJoinAssessD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.DiseJoinAssessI.GBL" 	
	//评估表注册表
	s CList($i(CList))= "CT.WDT.CDSS.AssBaseD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssBaseI.GBL" 	
	s CList($i(CList))= "CT.WDT.CDSS.AssBaseC.GBL"
	//评估表注册字段表
	s CList($i(CList))= "CT.WDT.CDSS.AssBaseFieldI.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssBaseFieldC.GBL" 
	//评估表字段选项表
	s CList($i(CList))= "CT.WDT.CDSS.AssBaseFieldItemI.GBL" 	
	//评估表评分规则表
	s CList($i(CList))= "CT.WDT.CDSS.AssScoringRulesI.GBL" 	
	//评估表关联评估结果条件设置表
	s CList($i(CList))= "CT.WDT.CDSS.AssConResCondiD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssConResCondiI.GBL" 
	//评估表关联评估结论表
	s CList($i(CList))= "CT.WDT.CDSS.AssConResultD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.AssConResultI.GBL" 
	
	//***********中医CDSS**************************/
	//中医证候字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMSymptomD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMSymptomI.GBL" 
	//中医方剂字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMPrescriptionD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMPrescriptionI.GBL" 
	//方剂关联疾病字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMPreJoinDisD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMPreJoinDisI.GBL" 	
	//方剂关联中药字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMPreJoinMedD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMPreJoinMedI.GBL" 
	//中药字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMMedicineD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMMedicineI.GBL" 		
	//腧穴字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMAcupointsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMAcupointsI.GBL" 	
	//中药煎法字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMDecoctionD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDecoctionI.GBL" 		
	//中医疾病字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseaseD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseaseI.GBL"
	
	//4.4.9. 中医症状字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMSymDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMSymDictI.GBL"
	
	//4.4.10. 中医体征字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMSignsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMSignsI.GBL"
	
	//4.4.11. 中医治法字典
	s CList($i(CList))= "CT.WDT.CDSS.TCMTreatmentD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMTreatmentI.GBL"
	
	//4.4.12. 中医疾病关联证候表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJSymD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJSymI.GBL"
	
	//4.4.13. 中医疾病关联属性表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJPropertyD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJPropertyI.GBL"
	//4.4.14. 中医疾病关联识别词表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseJWordsI.GBL"
	//4.4.15. 中医辩证识别词表
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseSymJWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.TCMDiseSymJWordsI.GBL"
	
	//***********百科管理**************************/
	//知识库注册
	s CList($i(CList))= "CT.WDT.CDSS.TermBaseD.GBL"  //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseI.GBL" //术语库注册表
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyI.GBL"  //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyD.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBasePropertyC.GBL" //术语库注册属性表 
    s CList($i(CList))= "CT.WDT.CDSS.TermBaseExtendProI.GBL" //术语库注册扩展属性表
    //知识管理
    s CList($i(CList))= "CT.WDT.CDSS.TermD.GBL"  //术语表
    s CList($i(CList))= "CT.WDT.CDSS.TermI.GBL"  //术语表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyD.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyI.GBL"  //术语维护属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermPropertyC.GBL"  //术语属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProI.GBL" //术语扩展属性表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailD.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermProDetailI.GBL" //术语属性内容表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValD.GBL" //扩展属性值表
	s CList($i(CList))= "CT.WDT.CDSS.TermExtendProValI.GBL" //扩展属性值表
	
	if (ProjectFlag'="") //如果是腾讯云部署才导出病历质控评测工具的数据，项目部署的话不需要导出
	{
		//***********1.11. 病历质控评测工具**************************/
		s CList($i(CList))= "WDT.CDSS.ChiefIdentifyD.GBL"	//1.11.1. 主诉识别表
	 	s CList($i(CList))= "WDT.CDSS.ChiefIdentifyI.GBL"	
		s CList($i(CList))= "WDT.CDSS.ChiefIdentifyEvalD.GBL"	//1.11.2. 主诉识别评测表
	 	s CList($i(CList))= "WDT.CDSS.ChiefIdentifyEvalI.GBL"
	 	s CList($i(CList))= "WDT.CDSS.ChiefDiaHitRateD.GBL"	//1.11.3. 诊断命中率统计表
	 	s CList($i(CList))= "WDT.CDSS.ChiefDiaHitRateI.GBL"	
	 	s CList($i(CList))= "WDT.CDSS.ChiefTasksD.GBL"  //任务集
	 	s CList($i(CList))= "WDT.CDSS.ChiefTasksI.GBL"	 	 	
	}
 	
	 //平台配置
	 s CList($i(CList))= "CF.WDT.CDSS.ConfigCategoryD.GBL"   //平台配置分类
	 s CList($i(CList))= "CF.WDT.CDSS.ConfigCategoryI.GBL" 
	//s CList($i(CList))= "CF.WDT.CDSS.MKBConfigD.GBL" 
	//s CList($i(CList))= "CF.WDT.CDSS.MKBConfigI.GBL" 
	//s CList($i(CList))= "CF.WDT.CDSS.MKBConfigDetailD.GBL" 
	//s CList($i(CList))= "CF.WDT.CDSS.MKBConfigDetailI.GBL" 
	
	//菜单管理
	//s CList($i(CList))= "CT.WDT.MKB.MenuD.GBL"
	//s CList($i(CList))= "CT.WDT.MKB.MenuI.GBL"
	//s CList($i(CList))= "CT.WDT.MKB.MenuC.GBL"
	//4.1.11. 基础信息字典集合表
	s CList($i(CList))= "CT.WDT.MKB.FunctionalElementI.GBL"
	
	//4.1.12. 数据库表字典表
	s CList($i(CList))= "CT.WDT.CDSS.DataTableDictD.GBL"
	s CList($i(CList))= "CT.WDT.CDSS.DataTableDictI.GBL"
	
	//4.1.12. 医学组数据统计配置表
	s CList($i(CList))= "CF.WDT.CDSS.StatisticsConfigD.GBL"
	s CList($i(CList))= "CF.WDT.CDSS.StatisticsConfigI.GBL"	
	
	// 4.22.1. 全文检索配置表
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetD.GBL" 
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetI.GBL" 
	

	
    //把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"NEWCDSSV2Data"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3) //删掉10天前的global
	w time,!
	s filename = filePath_"NEWCDSSV2Data"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator：谷雪萍
/// CreatDate:2022-10-14
/// Description:k掉临床辅助决策支持系统V2.0的global(按命名规范重命名后)
/// Return:over
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).KillCDSSV2GlobalNew ()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","NEWCDSSV2Data.gof")
ClassMethod KillCDSSV2GlobalNew()
{
	
	b ;确定库是否正确？？？确定的话输 g 不确定输 q 
	b ;确定要删除CDSSV2.0的所有数据吗？确定的话输 g 不确定输 q 
	//***********字典表**************************/
	
	//治疗方案字典
	k ^CT.WDT.CDSS.TreatDictD
	k ^CT.WDT.CDSS.TreatDictI
	//单位字典
	k ^CT.WDT.CDSS.UnitDictD
	k ^CT.WDT.CDSS.UnitDictI 
	//通用字典类型
	k ^CT.WDT.CDSS.CommonDictTypeD
	k ^CT.WDT.CDSS.CommonDictTypeI 
	//通用字典
	k ^CT.WDT.CDSS.CommonDictD
	k ^CT.WDT.CDSS.CommonDictI
	//过敏史字典
	k ^CT.WDT.CDSS.AllergyDictD
	k ^CT.WDT.CDSS.AllergyDictI 
	//症状字典
	k ^CT.WDT.CDSS.SymptomDictD
	k ^CT.WDT.CDSS.SymptomDictI
	//诱因、病因字典
	k ^CT.WDT.CDSS.PathogenyDictD
	k ^CT.WDT.CDSS.PathogenyDictI
	//检验结果字典
	k ^CT.WDT.CDSS.LabResultDictD
	k ^CT.WDT.CDSS.LabResultDictI
	//检查结果字典
	k ^CT.WDT.CDSS.ExamResultDictD
	k ^CT.WDT.CDSS.ExamResultDictI
	//护理结果字典
	k ^CT.WDT.CDSS.NurseResultDictD
	k ^CT.WDT.CDSS.NurseResultDictI
	//评估结果字典
	k ^CT.WDT.CDSS.AssessResultDictD
	k ^CT.WDT.CDSS.AssessResultDictI
	//定语字典
	k ^CT.WDT.CDSS.AttributeDictD
	k ^CT.WDT.CDSS.AttributeDictI
    //扩展码字典
	k ^CT.WDT.CDSS.ExtendCodeDictD
	k ^CT.WDT.CDSS.ExtendCodeDictI
	//会诊医嘱字典
	k ^CT.WDT.CDSS.ConsultationDictD
	k ^CT.WDT.CDSS.ConsultationDictI
		//单位转换表
	k ^CT.WDT.CDSS.UnitConversionD
	k ^CT.WDT.CDSS.UnitConversionI
	//检验医嘱字典
	k ^CT.WDT.CDSS.LabOrdersDictD
	k ^CT.WDT.CDSS.LabOrdersDictI

	//1.3.18. 药物分类字典表
	k ^CT.WDT.CDSS.DrugTypeDictD 
	k ^CT.WDT.CDSS.DrugTypeDictI 
	
	//1.3.18. 剂型字典表
	k ^CT.WDT.CDSS.DosageFormD
	k ^CT.WDT.CDSS.DosageFormI
	
		//4.3.19. 疾病字典表
	k ^CT.WDT.CDSS.DiseaseDictD 
	k ^CT.WDT.CDSS.DiseaseDictI 
	//4.3.20. 药物字典表
	k ^CT.WDT.CDSS.DrugDictD 
	k ^CT.WDT.CDSS.DrugDictI 
	//4.3.21. 检查字典表
	k ^CT.WDT.CDSS.ExamDictD 
	k ^CT.WDT.CDSS.ExamDictI 
	//4.3.22. 检验项目字典表
	k ^CT.WDT.CDSS.LabInspectionDictD 
	k ^CT.WDT.CDSS.LabInspectionDictI 
	//4.3.23. 用法字典表
	k ^CT.WDT.CDSS.UsageDictD 
	k ^CT.WDT.CDSS.UsageDictI 
	//4.3.24. 手术字典表
	k ^CT.WDT.CDSS.OperationDictD 
	k ^CT.WDT.CDSS.OperationDictI 
	//4.3.25. 护理字典表
	k ^CT.WDT.CDSS.NursingDictD 
	k ^CT.WDT.CDSS.NursingDictI 
	//4.3.26. 输血品字典表
	k ^CT.WDT.CDSS.BloodProductDictD 
	k ^CT.WDT.CDSS.BloodProductDictI 
	//4.3.27. 检验标本字典表
	k ^CT.WDT.CDSS.LabSpecimenDictD 
	k ^CT.WDT.CDSS.LabSpecimenDictI 
	//4.3.28. 频率字典表
	k ^CT.WDT.CDSS.FrequencyDictD 
	k ^CT.WDT.CDSS.FrequencyDictI 
	//4.3.29. 用法字典表
	k ^CT.WDT.CDSS.UsageDictD 
	k ^CT.WDT.CDSS.UsageDictI 
	//4.3.30. 体格检查字典表
	k ^CT.WDT.CDSS.PhysicalExamDictD 
	k ^CT.WDT.CDSS.PhysicalExamDictI 
	//4.3.31. 科室字典表
	k ^CT.WDT.CDSS.DiseaseDeptDictD 
	k ^CT.WDT.CDSS.DiseaseDeptDictI 
	//4.3.32. 输血品分类字典表
	k ^CT.WDT.CDSS.BPClassDictD 
	k ^CT.WDT.CDSS.BPClassDictI 
	//4.3.33. 部位字典表
	k ^CT.WDT.CDSS.BodyPartsDictD 
	k ^CT.WDT.CDSS.BodyPartsDictI 
	//4.3.34. 别名通用表 
	k ^CT.WDT.CDSS.AliasD
	k ^CT.WDT.CDSS.AliasI
	//4.3.35. 部位层级表 
	k ^CT.WDT.CDSS.BodyPartsLevelD
	k ^CT.WDT.CDSS.BodyPartsLevelI
	//4.3.36. 方位词字典表 
	k ^CT.WDT.CDSS.PositionWordD
	k ^CT.WDT.CDSS.PositionWordI
	//4.3.37. 同义词检索字典 
	k ^CT.WDT.CDSS.SynSearchDictD
	k ^CT.WDT.CDSS.SynSearchDictI
	//手术关联科室
	k ^CT.WDT.CDSS.OperJoinDeptD
	k ^CT.WDT.CDSS.OperJoinDeptI
	
	//病历书写支持字典
	k ^CT.WDT.CDSS.StructEMRDictD
	k ^CT.WDT.CDSS.StructEMRDictI
	
	//辅助问诊字典
	k ^CT.WDT.CDSS.AssistConsultD
	k ^CT.WDT.CDSS.AssistConsultI
	
	//************推荐相似病历****************/
	//优质病历字典表
	k ^CT.WDT.CDSS.HighQualityEMRD
	k ^CT.WDT.CDSS.HighQualityEMRI
	//优质病历关联诊断表
	k ^CT.WDT.CDSS.HighQEMRConDiaD
	k ^CT.WDT.CDSS.HighQEMRConDiaI
	//优质病历关联诊断因子表
	k ^CT.WDT.CDSS.HighQEMRConSymD
	k ^CT.WDT.CDSS.HighQEMRConSymI	
	
	//***********出院指导**************************/
	//出院指导字典表
	k ^CT.WDT.CDSS.DischargeGuideD
	k ^CT.WDT.CDSS.DischargeGuideI
	//出院指导详情表
	k ^CT.WDT.CDSS.DGuideDetailD 
	k ^CT.WDT.CDSS.DGuideDetailI 
	//***********文献管理**************************/
	//文献表
	k ^CT.WDT.CDSS.DocuManageD
	k ^CT.WDT.CDSS.DocuManageI
	//文献关联诊断
	k ^CT.WDT.CDSS.DocuJoinDiseaseD
	k ^CT.WDT.CDSS.DocuJoinDiseaseI
	//文献关联科室
	k ^CT.WDT.CDSS.DocuJoinDeptD
	k ^CT.WDT.CDSS.DocuJoinDeptI 
	//文献详情
	k ^CT.WDT.CDSS.DocuDetailD
	k ^CT.WDT.CDSS.DocuDetailI
	//4.4.5. 文献发布机构表
	k ^CT.WDT.CDSS.DocuAgencyD 
	k ^CT.WDT.CDSS.DocuAgencyI 
	//***********疑似诊断管理**************************/
	//疾病关联诊断因子
	k ^CT.WDT.CDSS.DiseJFactorD
	k ^CT.WDT.CDSS.DiseJFactorI
	//疾病关联诊断因子组合
	k ^CT.WDT.CDSS.DiseJFactorCombD
	k ^CT.WDT.CDSS.DiseJFactorCombI
	//疾病关联属性
	k ^CT.WDT.CDSS.DiseJPropertyD
	k ^CT.WDT.CDSS.DiseJPropertyI 
	//诊断因子库
	k ^CT.WDT.CDSS.DiagFactorBaseD
	k ^CT.WDT.CDSS.DiagFactorBaseI
		//4.5.5. 疾病关联识别词表
	k ^CT.WDT.CDSS.DiseJIWordsD 
	k ^CT.WDT.CDSS.DiseJIWordsI 
	
	//***********字典对照管理（后面如果给项目部署需要用抽数据的方法只抽取本医院的字典对照数据）**************************/
	//对接方药品字典
	/*k ^CT.WDT.CDSS.ConDrugDictD
	k ^CT.WDT.CDSS.ConDrugDictI
	//对接方诊断字典
	k ^CT.WDT.CDSS.ConDiseaseDictD
	k ^CT.WDT.CDSS.ConDiseaseDictI
	//对接方检验检查字典
	k ^CT.WDT.CDSS.ConExamDictD
	k ^CT.WDT.CDSS.ConExamDictI 
	//对接方手术字典
	k ^CT.WDT.CDSS.ConOperDictD
	k ^CT.WDT.CDSS.ConOperDictI
	//对接方护理字典
	k ^CT.WDT.CDSS.ConNurseDictD
	k ^CT.WDT.CDSS.ConNurseDictI 
	//对照字典
	k ^CT.WDT.CDSS.ContrastDictD
	k ^CT.WDT.CDSS.ContrastDictI
	//其他类型对接方字典表
	k ^CT.WDT.CDSS.ConOtherDictD
	k ^CT.WDT.CDSS.ConOtherDictI
	//医院字典表
	k ^CT.WDT.CDSS.CustomerHospD
	k ^CT.WDT.CDSS.CustomerHospI
	k ^CT.WDT.CDSS.CustomerHospC
	
	//院区
	k ^CT.WDT.CDSS.CustomerHospAreaI
	//对接方字典分类表
	k ^CT.WDT.CDSS.ConClassDictD
	k ^CT.WDT.CDSS.ConClassDictI
	//4.10.12. 对接方字典关联院区表
	k ^CT.WDT.CDSS.ConDictConAreaD
	k ^CT.WDT.CDSS.ConDictConAreaI*/
		
	//***********诊疗规则管理**************************/
	//诊疗规则字典
	k ^CT.WDT.CDSS.RuleDictD
	k ^CT.WDT.CDSS.RuleDictI
	//诊疗流程节点
	k ^CT.WDT.CDSS.RuleNodeD
	k ^CT.WDT.CDSS.RuleNodeI
	//诊疗流程线表
	k ^CT.WDT.CDSS.RuleLinkD
	k ^CT.WDT.CDSS.RuleLinkI 
	//诊疗流程图Json信息表
	k ^CT.WDT.CDSS.RuleChartD
	k ^CT.WDT.CDSS.RuleChartI
	k ^CT.WDT.CDSS.RuleChartS
	//触发条件表
	k ^CT.WDT.CDSS.RuleConditionD
	k ^CT.WDT.CDSS.RuleConditionI 
	//诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，推荐确诊）
	k ^CT.WDT.CDSS.RuleResultD
	k ^CT.WDT.CDSS.RuleResultI
	//诊疗节点内容表（预警规则-合理性）
	k ^CT.WDT.CDSS.RuleRationalityD
	k ^CT.WDT.CDSS.RuleRationalityI
	//诊疗节点内容表（预警规则-并发症）
	k ^CT.WDT.CDSS.RuleComplicationD
	k ^CT.WDT.CDSS.RuleComplicationI
	//治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
	k ^CT.WDT.CDSS.RuleDetailD
	k ^CT.WDT.CDSS.RuleDetailI 
	//诊疗规则流程类型表
	k ^CT.WDT.CDSS.ChartTypeD
	k ^CT.WDT.CDSS.ChartTypeI
	//诊疗规则流程节点类型表
	k ^CT.WDT.CDSS.NodeTypeD
	k ^CT.WDT.CDSS.NodeTypeI 
	//诊疗规则流程类型与节点类型关联表
	k ^CT.WDT.CDSS.ChartNodeTypeConD
	k ^CT.WDT.CDSS.ChartNodeTypeConI
	//诊疗节点内容依据表
	k ^CT.WDT.CDSS.RuleBasisD
	k ^CT.WDT.CDSS.RuleBasisI
	
	//推荐疑似疾病中单一规则表 
	k ^CT.WDT.CDSS.SingleSymptomRuleD
	k ^CT.WDT.CDSS.SingleSymptomRuleI 
	//***********识别词管理**************************/
	//识别词字典
	k ^CT.WDT.CDSS.IdentifyWordsD
	k ^CT.WDT.CDSS.IdentifyWordsI
	//识别词流程节点表
	k ^CT.WDT.CDSS.WordsNodeD
	k ^CT.WDT.CDSS.WordsNodeI
	//识别词流程线表
	k ^CT.WDT.CDSS.WordsLinkD
	k ^CT.WDT.CDSS.WordsLinkI 
	//识别词节点内容表（触发条件）
	k ^CT.WDT.CDSS.WordsConditionD
	k ^CT.WDT.CDSS.WordsConditionI
	//识别词流程图Json信息表 （用于还原流程图）
	k ^CT.WDT.CDSS.WordsChartD
	k ^CT.WDT.CDSS.WordsChartI 
	k ^CT.WDT.CDSS.WordsChartS
	//识别词项目字典
	k ^CT.WDT.CDSS.WordsItemD
	k ^CT.WDT.CDSS.WordsItemI 
	
   //***********评估表知识库管理**************************/
	//评估表基本信息
	k ^CT.WDT.CDSS.AssBasicInfoD
	k ^CT.WDT.CDSS.AssBasicInfoI
	//评估表关联文献表
	k ^CT.WDT.CDSS.AssConDocD
	k ^CT.WDT.CDSS.AssConDocI
	//评估表关联科室
	k ^CT.WDT.CDSS.AssConDeptD 
	k ^CT.WDT.CDSS.AssConDeptI 
	//评估表关联关键字
	k ^CT.WDT.CDSS.AssKeyWordsD 
	k ^CT.WDT.CDSS.AssKeyWordsI
	//评估表关联疾病
	k ^CT.WDT.CDSS.DiseJoinAssessD
	k ^CT.WDT.CDSS.DiseJoinAssessI
	//评估表注册表
	k ^CT.WDT.CDSS.AssBaseD 
	k ^CT.WDT.CDSS.AssBaseI 
	k ^CT.WDT.CDSS.AssBaseC
	//评估表注册字段表
	k ^CT.WDT.CDSS.AssBaseFieldI
	k ^CT.WDT.CDSS.AssBaseFieldC 
	//评估表字段选项表
	k ^CT.WDT.CDSS.AssBaseFieldItemI
	//评估表评分规则表
	k ^CT.WDT.CDSS.AssScoringRulesI 
	//评估表关联评估结果条件设置表
	k ^CT.WDT.CDSS.AssConResCondiD
	k ^CT.WDT.CDSS.AssConResCondiI
	//评估表关联评估结论表
	k ^CT.WDT.CDSS.AssConResultD
	k ^CT.WDT.CDSS.AssConResultI
	
	//***********中医CDSS**************************/
	//中医证候字典
	k ^CT.WDT.CDSS.TCMSymptomD 
	k ^CT.WDT.CDSS.TCMSymptomI 
	//中医方剂字典
	k ^CT.WDT.CDSS.TCMPrescriptionD 
	k ^CT.WDT.CDSS.TCMPrescriptionI 
	//方剂关联疾病字典
	k ^CT.WDT.CDSS.TCMPreJoinDisD 
	k ^CT.WDT.CDSS.TCMPreJoinDisI 
	//方剂关联中药字典
	k ^CT.WDT.CDSS.TCMPreJoinMedD 
	k ^CT.WDT.CDSS.TCMPreJoinMedI 
	//中药字典
	k ^CT.WDT.CDSS.TCMMedicineD 
	k ^CT.WDT.CDSS.TCMMedicineI 
	//腧穴字典
	k ^CT.WDT.CDSS.TCMAcupointsD 
	k ^CT.WDT.CDSS.TCMAcupointsI 
	//中药煎法字典
	k ^CT.WDT.CDSS.TCMDecoctionD 
	k ^CT.WDT.CDSS.TCMDecoctionI 
	//中医疾病字典
	k ^CT.WDT.CDSS.TCMDiseaseD 
	k ^CT.WDT.CDSS.TCMDiseaseI 
	
	//4.4.9. 中医症状字典
	k ^CT.WDT.CDSS.TCMSymDictD 
	k ^CT.WDT.CDSS.TCMSymDictI
	
	//4.4.10. 中医体征字典
	k ^CT.WDT.CDSS.TCMSignsD 
	k ^CT.WDT.CDSS.TCMSignsI
	
	//4.4.11. 中医治法字典
	k ^CT.WDT.CDSS.TCMTreatmentD 
	k ^CT.WDT.CDSS.TCMTreatmentI
	
	//4.4.12. 中医疾病关联证候表
	k ^CT.WDT.CDSS.TCMDiseJSymD 
	k ^CT.WDT.CDSS.TCMDiseJSymI
	
	//4.4.13. 中医疾病关联属性表
	k ^CT.WDT.CDSS.TCMDiseJPropertyD 
	k ^CT.WDT.CDSS.TCMDiseJPropertyI
	//4.4.14. 中医疾病关联识别词表
	k ^CT.WDT.CDSS.TCMDiseJWordsD 
	k ^CT.WDT.CDSS.TCMDiseJWordsI
	//4.4.15. 中医辩证识别词表
	k ^CT.WDT.CDSS.TCMDiseSymJWordsD 
	k ^CT.WDT.CDSS.TCMDiseSymJWordsI
	
	
	//***********百科管理**************************/
	//知识库注册
	k ^CT.WDT.CDSS.TermBaseD //术语库注册表 
	k ^CT.WDT.CDSS.TermBaseI //术语库注册表 
	k ^CT.WDT.CDSS.TermBasePropertyI //术语库注册属性表 
	k ^CT.WDT.CDSS.TermBasePropertyD //术语库注册属性表
	k ^CT.WDT.CDSS.TermBasePropertyC //术语库注册属性表 
 	k ^CT.WDT.CDSS.TermBaseExtendProI //术语库注册扩展属性表
 	
 	//知识管理
 	k ^CT.WDT.CDSS.TermD //术语表
 	k ^CT.WDT.CDSS.TermI //术语表
	k ^CT.WDT.CDSS.TermPropertyD //术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyI //术语维护属性表
	k ^CT.WDT.CDSS.TermPropertyC //术语属性表
	k ^CT.WDT.CDSS.TermExtendProI //术语扩展属性表
	k ^CT.WDT.CDSS.TermProDetailD //术语属性内容表
	k ^CT.WDT.CDSS.TermProDetailI //术语属性内容表
	k ^CT.WDT.CDSS.TermExtendProValD //扩展属性值表
	k ^CT.WDT.CDSS.TermExtendProValI //扩展属性值表
	
	//***********1.11. 病历质控评测工具**************************/
	k ^WDT.CDSS.ChiefIdentifyD //1.11.1. 主诉识别表
 	k ^WDT.CDSS.ChiefIdentifyI 
	k ^WDT.CDSS.ChiefIdentifyEvalD //1.11.2. 主诉识别评测表
 	k ^WDT.CDSS.ChiefIdentifyEvalI 
 	k ^WDT.CDSS.ChiefDiaHitRateD //1.11.3. 诊断命中率统计表
 	k ^WDT.CDSS.ChiefDiaHitRateI 
 	k ^WDT.CDSS.ChiefTasksD //任务集
 	k ^WDT.CDSS.ChiefTasksI 
 	
 	//平台配置
	k ^CF.WDT.CDSS.ConfigCategoryD //平台配置分类
	k ^CF.WDT.CDSS.ConfigCategoryI
	//k ^CF.WDT.CDSS.MKBConfigD //平台配置
	//k ^CF.WDT.CDSS.MKBConfigI 
	//k ^CF.WDT.CDSS.MKBConfigDetailD
	//k ^CF.WDT.CDSS.MKBConfigDetailI
	
	//菜单管理
	//k ^CT.WDT.MKB.MenuD
	//k ^CT.WDT.MKB.MenuI
	//k ^CT.WDT.MKB.MenuC
	//4.1.11. 基础信息字典集合表
	k ^CT.WDT.MKB.FunctionalElementI
	//4.1.12. 数据库表字典表
	k ^CT.WDT.CDSS.DataTableDictD
	k ^CT.WDT.CDSS.DataTableDictI
	//4.1.12. 医学组数据统计配置表
	k ^CF.WDT.CDSS.StatisticsConfigD
	k ^CF.WDT.CDSS.StatisticsConfigI
	
	// 4.22.1. 全文检索配置表
	k ^CF.WDT.CDSS.ALLDictSearchSetD
	k ^CF.WDT.CDSS.ALLDictSearchSetI
	
	// 4.22.2. 全文索引
	k ^CF.WDT.CDSS.ALLDictIndexD
	k ^CF.WDT.CDSS.ALLDictIndexI
	
	q "over"
}

/// Creator:谷雪萍
/// CreatDate:2022-11-02
/// Description：删除所有业务数据
/// Table：患者信息的所有表、解析器、数据统计相关表
/// Input：
/// Output：
/// w ##class(web.CDSS.Public.CDSSDataBackup).KillPatientGlobalNew()
ClassMethod KillPatientGlobalNew()
{
	b ;确定库是否正确？？？确定的话输 g 不确定输 q 
	b ;确定要删除CDSSV2.0的所有业务数据吗？确定的话输 g 不确定输 q 
	
	//患者信息相关的所有表
	k ^WDT.CDSS.PatientMasterD ;4.14.1.	患者基础信息表
	k ^WDT.CDSS.PatientMasterI 
	k ^WDT.CDSS.PatientVisitD  ;4.14.2.	就诊信息表
	k ^WDT.CDSS.PatientVisitI
	k ^WDT.CDSS.SignInfoD  ;4.14.3.	体征信息表
	k ^WDT.CDSS.SignInfoI
	k ^WDT.CDSS.ChiefCompInfoD  ;4.14.4.	主诉信息表
	k ^WDT.CDSS.ChiefCompInfoI
	k ^WDT.CDSS.CurrentMedHistoryD ;4.14.5.	现病史信息表
	k ^WDT.CDSS.CurrentMedHistoryI
	k ^WDT.CDSS.PastDiagnosisD ;4.14.6.1.	既往史信息表
	k ^WDT.CDSS.PastDiagnosisI
	k ^WDT.CDSS.PersonalInfoD  ;4.14.6.2.	个人史信息表
	k ^WDT.CDSS.PersonalInfoI
	k ^WDT.CDSS.MarryInfoD  ;4.14.6.3.	婚育史信息表
	k ^WDT.CDSS.MarryInfoI   
	k ^WDT.CDSS.FamilyHisInfoD  ;4.14.6.4.	家族史信息表
	k ^WDT.CDSS.FamilyHisInfoI
	k ^WDT.CDSS.AllergyHistoryD    ;4.14.6.5.	过敏史信息表
	k ^WDT.CDSS.AllergyHistoryI
	k ^WDT.CDSS.PhysicalExamD ;4.14.7.	体格检查表
	k ^WDT.CDSS.PhysicalExamI  
	k ^WDT.CDSS.SpecExamD ;4.14.8.	专科检查表
	k ^WDT.CDSS.SpecExamI  
	k ^WDT.CDSS.DiagnosisInfoD ;4.14.9.	诊断信息表
	k ^WDT.CDSS.DiagnosisInfoI
	k ^WDT.CDSS.DrugInfoD  ;4.14.10.	处方信息表
	k ^WDT.CDSS.DrugInfoI
	
	k ^WDT.CDSS.ExamInfoD  ;4.14.11.	检查信息表
	k ^WDT.CDSS.ExamInfoI
	k ^WDT.CDSS.LabInfoD ;4.14.12.	检验信息表
	k ^WDT.CDSS.LabInfoI
	k ^WDT.CDSS.OperationInfoD  ;4.14.13.	手术信息表
	k ^WDT.CDSS.OperationInfoI  
	k ^WDT.CDSS.AnestInfoD ;4.14.14.	麻醉信息表
	k ^WDT.CDSS.AnestInfoI
	k ^WDT.CDSS.NursingInfoD  ;4.14.15.	护理信息表
	k ^WDT.CDSS.NursingInfoI
	k ^WDT.CDSS.BloodTransInfoD ;4.14.16.	输血信息表
	k ^WDT.CDSS.BloodTransInfoI
	k ^WDT.CDSS.DietInfoD  ;4.14.17.	饮食信息表
	k ^WDT.CDSS.DietInfoI
	k ^WDT.CDSS.ClinicalFeatureD ;4.14.18.	临床表现信息表
	k ^WDT.CDSS.ClinicalFeatureI
	k ^WDT.CDSS.ClinicalFDetailedD ;4.14.19.	临床表现明细表
	k ^WDT.CDSS.ClinicalFDetailedI
	
	k ^WDT.CDSS.OtherOrderInfoD ;4.14.20.	其他在院医嘱信息
	k ^WDT.CDSS.OtherOrderInfoI
	k ^WDT.CDSS.InpatientInfoD  ;4.14.21.1.	病历信息表
	k ^WDT.CDSS.InpatientInfoI
	
	k ^WDT.CDSS.CarryDrugD   ;4.14.22.1.	出院带药信息表
	k ^WDT.CDSS.CarryDrugI
	k ^WDT.CDSS.OtherDisOrderInfoD ;4.14.22.2.	其他出院医嘱信息表
	k ^WDT.CDSS.OtherDisOrderInfoI
	
	k ^WDT.CDSS.PatientTransferD  ;转科记录表
	k ^WDT.CDSS.PatientTransferI 
	
	k ^WDT.CDSS.LabExamInfoD  ;辅助检验检查表
	k ^WDT.CDSS.LabExamInfoI 
	
	k ^WDT.CDSS.NursResultInfoD  ;护理结果信息表
	k ^WDT.CDSS.NursResultInfoI  
	
	k ^WDT.CDSS.PatientRatingScaleD  ;患者评估表记录表
	k ^WDT.CDSS.PatientRatingScaleI
	
	/******* 4.15 业务功能表******/
	//	4.20.2.	患者触发规则预警数据统计表
	k ^WDT.CDSS.PatTriggerStaticD
	k ^WDT.CDSS.PatTriggerStaticI
		
	//4.15.2.	患者推荐评估量表记录表
	k ^WDT.CDSS.UserClickStaticD
	k ^WDT.CDSS.UserClickStaticI	
	
	/******* 4.16.	解析器*****/
	//	4.12.1.	患者汇总信息索引表
	k ^WDT.CDSS.PatPMTypeIndexD
	k ^WDT.CDSS.PatPMTypeIndexI
	//4.12.2.	患者当前触发的识别词
	k ^WDT.CDSS.PatTriggerIWD
	k ^WDT.CDSS.PatTriggerIWI
	//4.12.3.	患者当前触发的规则
	k ^WDT.CDSS.PatTriggerRuleD
	k ^WDT.CDSS.PatTriggerRuleI
	//4.12.6.	患者推荐信息表
	k ^WDT.CDSS.PatientRecomInfoD
	k ^WDT.CDSS.PatientRecomInfoI	
	
	q "over"
}

/// Creator：谷雪萍
/// CreatDate:2022-11-22
/// Description:腾讯云mapping CDSS数据，把CDSS2.1的数据mapping到CDSS1.0
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).MappingCDSSV1Global()
ClassMethod MappingCDSSV1Global()
{
	b ;正在mapping 把CDSS2.1的数据mapping到1.0，请确定库是否正确？？？确定的话输 g 不确定输 q 
	b ;确定要继续mapping所有CDSS2.1的数据mapping到1.0吗？确定的话输 g 不确定输 q 	
	
	
	m ^CT.WDT.CDSS.DHCDSSDosageFormD=^CT.WDT.CDSS.DosageFormD

	m ^CT.WDT.MKB.AssConResCondiD=^CT.WDT.CDSS.AssConResCondiD
	
	m ^User.DHCDSSAllergyDictD=^CT.WDT.CDSS.AllergyDictD
	m ^User.DHCDSSAssBasicInfoD=^CT.WDT.CDSS.AssBasicInfoD
	m ^User.DHCDSSAssConDeptD=^CT.WDT.CDSS.AssConDeptD
	m ^User.DHCDSSAssConDocD=^CT.WDT.CDSS.AssConDocD
	m ^User.DHCDSSAssessResultDictD=^CT.WDT.CDSS.AssessResultDictD
	m ^User.DHCDSSAssKeyWordsD=^CT.WDT.CDSS.AssKeyWordsD
	m ^User.DHCDSSAttributeDictD=^CT.WDT.CDSS.AttributeDictD

	m ^User.DHCDSSBloodProductDictD=^CT.WDT.CDSS.BloodProductDictD
	m ^User.DHCDSSBodyParDictD=^CT.WDT.CDSS.BodyParDictD
	m ^User.DHCDSSBodyPartClassD=^CT.WDT.CDSS.BodyPartClassD
	m ^User.DHCDSSBodyPartsDictD=^CT.WDT.CDSS.BodyPartsDictD
	m ^User.DHCDSSBPClassDictD=^CT.WDT.CDSS.BPClassDictD
	m ^User.DHCDSSChartNodeTypeConD=^CT.WDT.CDSS.ChartNodeTypeConD
	m ^User.DHCDSSChartTypeD=^CT.WDT.CDSS.ChartTypeD
	m ^User.DHCDSSCommonDictD=^CT.WDT.CDSS.CommonDictD
	m ^User.DHCDSSCommonDictTypeD=^CT.WDT.CDSS.CommonDictTypeD
	m ^User.DHCDSSConDiseaseDictD=^CT.WDT.CDSS.ConDiseaseDictD
	m ^User.DHCDSSConDrugDictD=^CT.WDT.CDSS.ConDrugDictD
	m ^User.DHCDSSConExamDictD=^CT.WDT.CDSS.ConExamDictD
	m ^User.DHCDSSConNurseDictD=^CT.WDT.CDSS.ConNurseDictD
	m ^User.DHCDSSConOperDictD=^CT.WDT.CDSS.ConOperDictD
	m ^User.DHCDSSConsultationDictD=^CT.WDT.CDSS.ConsultationDictD
	m ^User.DHCDSSContrastDictD=^CT.WDT.CDSS.ContrastDictD
	m ^User.DHCDSSCustomerHospD=^CT.WDT.CDSS.CustomerHospD
	m ^User.DHCDSSDataTableDictD=^CT.WDT.CDSS.DataTableDictD
	m ^User.DHCDSSDiagFactorBaseD=^CT.WDT.CDSS.DiagFactorBaseD
	m ^User.DHCDSSDiseaseDeptDictD=^CT.WDT.CDSS.DiseaseDeptDictD
	m ^User.DHCDSSDiseaseDictD=^CT.WDT.CDSS.DiseaseDictD
	m ^User.DHCDSSDiseJFactorD=^CT.WDT.CDSS.DiseJFactorD
	m ^User.DHCDSSDiseJFactorCombD=^CT.WDT.CDSS.DiseJFactorCombD
	m ^User.DHCDSSDiseJIWordsD=^CT.WDT.CDSS.DiseJIWordsD
	m ^User.DHCDSSDiseJoinAssessmentD=^CT.WDT.CDSS.DiseJoinAssessD
	m ^User.DHCDSSDiseJPropertyD=^CT.WDT.CDSS.DiseJPropertyD
	m ^User.DHCDSSDocuAgencyD=^CT.WDT.CDSS.DocuAgencyD
	m ^User.DHCDSSDocuDetailD=^CT.WDT.CDSS.DocuDetailD
	m ^User.DHCDSSDocuJoinDeptD=^CT.WDT.CDSS.DocuJoinDeptD
	m ^User.DHCDSSDocuJoinDiseaseD=^CT.WDT.CDSS.DocuJoinDiseaseD
	m ^User.DHCDSSDocuManageD=^CT.WDT.CDSS.DocuManageD
	m ^User.DHCDSSDrugDictD=^CT.WDT.CDSS.DrugDictD
	m ^User.DHCDSSDrugTypeDictD=^CT.WDT.CDSS.DrugTypeDictD

	m ^User.DHCDSSExamDictD=^CT.WDT.CDSS.ExamDictD
	m ^User.DHCDSSExamResultDictD=^CT.WDT.CDSS.ExamResultDictD
	m ^User.DHCDSSExtendCodeDictD=^CT.WDT.CDSS.ExtendCodeDictD
	m ^User.DHCDSSFrequencyDictD=^CT.WDT.CDSS.FrequencyDictD
	m ^User.DHCDSSIdentifyWIndexD=^CT.WDT.CDSS.IdentifyWIndexD
	m ^User.DHCDSSIdentifyWordsD=^CT.WDT.CDSS.IdentifyWordsD
	m ^User.DHCDSSInterfaceClassDictD=^CT.WDT.CDSS.ConClassDictD

	m ^User.DHCDSSLabInspectionDictD=^CT.WDT.CDSS.LabInspectionDictD
	m ^User.DHCDSSLabOrdersDictD=^CT.WDT.CDSS.LabOrdersDictD
	m ^User.DHCDSSLabResultDictD=^CT.WDT.CDSS.LabResultDictD
	m ^User.DHCDSSLabSpecimenDictD=^CT.WDT.CDSS.LabSpecimenDictD
	m ^User.DHCDSSNodeTypeD=^CT.WDT.CDSS.NodeTypeD
	m ^User.DHCDSSNurseResultDictD=^CT.WDT.CDSS.NurseResultDictD

	m ^User.DHCDSSNursingDictD=^CT.WDT.CDSS.NursingDictD
	m ^User.DHCDSSOperationDictD=^CT.WDT.CDSS.OperationDictD
	m ^User.DHCDSSOperJoinDeptD=^CT.WDT.CDSS.OperJoinDeptD
	m ^User.DHCDSSPathogenyDictD=^CT.WDT.CDSS.PathogenyDictD
	m ^User.DHCDSSPhysicalExamDictD=^CT.WDT.CDSS.PhysicalExamDictD
	m ^User.DHCDSSRuleBasisD=^CT.WDT.CDSS.RuleBasisD
	m ^User.DHCDSSRuleChartD=^CT.WDT.CDSS.RuleChartD
	m ^User.DHCDSSRuleComplicationD=^CT.WDT.CDSS.RuleComplicationD
	m ^User.DHCDSSRuleConditionD=^CT.WDT.CDSS.RuleConditionD
	m ^User.DHCDSSRuleDetailD=^CT.WDT.CDSS.RuleDetailD
	m ^User.DHCDSSRuleDictD=^CT.WDT.CDSS.RuleDictD
	m ^User.DHCDSSRuleIndexD=^CT.WDT.CDSS.RuleIndexD
	m ^User.DHCDSSRuleLinkD=^CT.WDT.CDSS.RuleLinkD
	m ^User.DHCDSSRuleNodeD=^CT.WDT.CDSS.RuleNodeD
	m ^User.DHCDSSRuleRationalityD=^CT.WDT.CDSS.RuleRationalityD
	m ^User.DHCDSSRuleResultD=^CT.WDT.CDSS.RuleResultD
	m ^User.DHCDSSSymptomDictD=^CT.WDT.CDSS.SymptomDictD
	m ^User.DHCDSSTCMAcupointsD=^CT.WDT.CDSS.TCMAcupointsD
	m ^User.DHCDSSTCMDecoctionD=^CT.WDT.CDSS.TCMDecoctionD
	m ^User.DHCDSSTCMDiseaseD=^CT.WDT.CDSS.TCMDiseaseD
	m ^User.DHCDSSTCMMedicineD=^CT.WDT.CDSS.TCMMedicineD
	m ^User.DHCDSSTCMPreJoinMedD=^CT.WDT.CDSS.TCMPreJoinMedD
	m ^User.DHCDSSTCMPrescriptionD=^CT.WDT.CDSS.TCMPrescriptionD
	m ^User.DHCDSSTCMSymptomD=^CT.WDT.CDSS.TCMSymptomD
	m ^User.DHCDSSTreatDictD=^CT.WDT.CDSS.TreatDictD
	m ^User.DHCDSSUnitConversionD=^CT.WDT.CDSS.UnitConversionD
	m ^User.DHCDSSUnitDictD=^CT.WDT.CDSS.UnitDictD
	m ^User.DHCDSSUsageDictD=^CT.WDT.CDSS.UsageDictD
	m ^User.DHCDSSWordsChartD=^CT.WDT.CDSS.WordsChartD
	m ^User.DHCDSSWordsConditionD=^CT.WDT.CDSS.WordsConditionD
	m ^User.DHCDSSWordsItemD=^CT.WDT.CDSS.WordsItemD
	m ^User.DHCDSSWordsLinkD=^CT.WDT.CDSS.WordsLinkD
	m ^User.DHCDSSWordsNodeD=^CT.WDT.CDSS.WordsNodeD
	m ^User.MKBAssessmentBaseD=^CT.WDT.CDSS.AssBaseD
	m ^User.MKBAssessmentBaseC=^CT.WDT.CDSS.AssBaseC
	m ^User.MKBAssessmentBaseFieldD=^CT.WDT.CDSS.AssBaseFieldD
	m ^User.MKBAssessmentScoringRulesD=^CT.WDT.CDSS.AssScoringRulesD
	
	m ^User.DHCDSSSingleSymptomRuleD=^CT.WDT.CDSS.SingleSymptomRuleD
	
	m ^CT.WDT.MKB.ConfigCategoryD=^CF.WDT.CDSS.ConfigCategoryD
	
	d ##class(CT.WDT.CDSS.DHCDSSDosageForm).%BuildIndices()
	d ##class(CT.WDT.MKB.AssConResCondi).%BuildIndices()

	
	d ##class(User.DHCDSSAllergyDict).%BuildIndices()
	d ##class(User.DHCDSSAssBasicInfo).%BuildIndices()
	d ##class(User.DHCDSSAssConDept).%BuildIndices()
	d ##class(User.DHCDSSAssConDoc).%BuildIndices()
	d ##class(User.DHCDSSAssessResultDict).%BuildIndices()
	d ##class(User.DHCDSSAssKeyWords).%BuildIndices()
	d ##class(User.DHCDSSAttributeDict).%BuildIndices()

	d ##class(User.DHCDSSBloodProductDict).%BuildIndices()
	d ##class(User.DHCDSSBodyParDict).%BuildIndices()
	d ##class(User.DHCDSSBodyPartClass).%BuildIndices()
	d ##class(User.DHCDSSBodyPartsDict).%BuildIndices()
	d ##class(User.DHCDSSBPClassDict).%BuildIndices()
	d ##class(User.DHCDSSChartNodeTypeCon).%BuildIndices()
	d ##class(User.DHCDSSChartType).%BuildIndices()
	d ##class(User.DHCDSSCommonDict).%BuildIndices()
	d ##class(User.DHCDSSCommonDictType).%BuildIndices()
	d ##class(User.DHCDSSConDiseaseDict).%BuildIndices()
	d ##class(User.DHCDSSConDrugDict).%BuildIndices()
	d ##class(User.DHCDSSConExamDict).%BuildIndices()
	d ##class(User.DHCDSSConNurseDict).%BuildIndices()
	d ##class(User.DHCDSSConOperDict).%BuildIndices()
	d ##class(User.DHCDSSConsultationDict).%BuildIndices()
	d ##class(User.DHCDSSContrastDict).%BuildIndices()
	d ##class(User.DHCDSSCustomerHosp).%BuildIndices()
	d ##class(User.DHCDSSDataTableDict).%BuildIndices()
	d ##class(User.DHCDSSDiagFactorBase).%BuildIndices()
	d ##class(User.DHCDSSDiseaseDeptDict).%BuildIndices()
	d ##class(User.DHCDSSDiseaseDict).%BuildIndices()
	d ##class(User.DHCDSSDiseJFactor).%BuildIndices()
	d ##class(User.DHCDSSDiseJFactorComb).%BuildIndices()
	d ##class(User.DHCDSSDiseJIWords).%BuildIndices()
	d ##class(User.DHCDSSDiseJoinAssessment).%BuildIndices()
	d ##class(User.DHCDSSDiseJProperty).%BuildIndices()
	d ##class(User.DHCDSSDocuAgency).%BuildIndices()
	d ##class(User.DHCDSSDocuDetail).%BuildIndices()
	d ##class(User.DHCDSSDocuJoinDept).%BuildIndices()
	d ##class(User.DHCDSSDocuJoinDisease).%BuildIndices()
	d ##class(User.DHCDSSDocuManage).%BuildIndices()
	d ##class(User.DHCDSSDrugDict).%BuildIndices()
	d ##class(User.DHCDSSDrugTypeDict).%BuildIndices()

	d ##class(User.DHCDSSExamDict).%BuildIndices()
	d ##class(User.DHCDSSExamResultDict).%BuildIndices()
	d ##class(User.DHCDSSExtendCodeDict).%BuildIndices()
	d ##class(User.DHCDSSFrequencyDict).%BuildIndices()
	d ##class(User.DHCDSSIdentifyWIndex).%BuildIndices()
	d ##class(User.DHCDSSIdentifyWords).%BuildIndices()
	d ##class(User.DHCDSSInterfaceClassDict).%BuildIndices()

	d ##class(User.DHCDSSLabInspectionDict).%BuildIndices()
	d ##class(User.DHCDSSLabOrdersDict).%BuildIndices()
	d ##class(User.DHCDSSLabResultDict).%BuildIndices()
	d ##class(User.DHCDSSLabSpecimenDict).%BuildIndices()
	d ##class(User.DHCDSSNodeType).%BuildIndices()
	d ##class(User.DHCDSSNurseResultDict).%BuildIndices()

	d ##class(User.DHCDSSNursingDict).%BuildIndices()
	d ##class(User.DHCDSSOperationDict).%BuildIndices()
	d ##class(User.DHCDSSOperJoinDept).%BuildIndices()
	d ##class(User.DHCDSSPathogenyDict).%BuildIndices()
	d ##class(User.DHCDSSPhysicalExamDict).%BuildIndices()
	d ##class(User.DHCDSSRuleBasis).%BuildIndices()
	d ##class(User.DHCDSSRuleChart).%BuildIndices()
	d ##class(User.DHCDSSRuleComplication).%BuildIndices()
	d ##class(User.DHCDSSRuleCondition).%BuildIndices()
	d ##class(User.DHCDSSRuleDetail).%BuildIndices()
	d ##class(User.DHCDSSRuleDict).%BuildIndices()
	d ##class(User.DHCDSSRuleIndex).%BuildIndices()
	d ##class(User.DHCDSSRuleLink).%BuildIndices()
	d ##class(User.DHCDSSRuleNode).%BuildIndices()
	d ##class(User.DHCDSSRuleRationality).%BuildIndices()
	d ##class(User.DHCDSSRuleResult).%BuildIndices()
	d ##class(User.DHCDSSSymptomDict).%BuildIndices()
	d ##class(User.DHCDSSTCMAcupoints).%BuildIndices()
	d ##class(User.DHCDSSTCMDecoction).%BuildIndices()
	d ##class(User.DHCDSSTCMDisease).%BuildIndices()
	d ##class(User.DHCDSSTCMMedicine).%BuildIndices()
	d ##class(User.DHCDSSTCMPreJoinMed).%BuildIndices()
	d ##class(User.DHCDSSTCMPrescription).%BuildIndices()
	d ##class(User.DHCDSSTCMSymptom).%BuildIndices()
	d ##class(User.DHCDSSTreatDict).%BuildIndices()
	d ##class(User.DHCDSSUnitConversion).%BuildIndices()
	d ##class(User.DHCDSSUnitDict).%BuildIndices()
	d ##class(User.DHCDSSUsageDict).%BuildIndices()
	d ##class(User.DHCDSSWordsChart).%BuildIndices()
	d ##class(User.DHCDSSWordsCondition).%BuildIndices()
	d ##class(User.DHCDSSWordsItem).%BuildIndices()
	d ##class(User.DHCDSSWordsLink).%BuildIndices()
	d ##class(User.DHCDSSWordsNode).%BuildIndices()
	d ##class(User.MKBAssessmentBase).%BuildIndices()
	d ##class(User.MKBAssessmentBaseField).%BuildIndices()
	d ##class(User.MKBAssessmentScoringRules).%BuildIndices()

	d ##class(User.DHCDSSSingleSymptomRule).%BuildIndices()
	d ##class(CT.WDT.MKB.ConfigCategory).%BuildIndices()
	
	w ##class(web.CDSS.Public.CDSSDataBackup).UpdateTableName(1)  //修改CDSS2.0中5个表的TableName的数据
}

/// Creator：谷雪萍
/// CreatDate:2023-1-11
/// Description:导出决策知识库所需字典表的数据（V1.0的数据）用于备份，备份后执行下面的MappingDecisionKBGlobal方法
/// Return:DecisionKBGlobal"_time_".gof文件
/// Others：d ##class(web.CDSS.Public.CDSSDataBackup).ExportDecisionKBGlobal("D:\CDSSGlobal\NewTable\")
ClassMethod ExportDecisionKBGlobal(filePath As %String = "")
{
	k CList
	k myIdx
	
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetD.GBL" 
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictSearchSetI.GBL" 
	s CList($i(CList))= "User.DHCDSSTreatDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUnitDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUnitConversionD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabOrdersDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseaseDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDrugDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSExamDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabInspectionDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUsageDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSOperationDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSNursingDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSBloodProductDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSLabSpecimenDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSFrequencyDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSUsageDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSPhysicalExamDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseaseDeptDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuManageD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDiseaseD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuJoinDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuDetailD.GBL" 
	s CList($i(CList))= "User.DHCDSSDocuAgencyD.GBL" 
	
	s CList($i(CList))= "CT.WDT.MKB.AssConResCondiD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssBasicInfoD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssConDeptD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssConDocD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssessResultDictD.GBL" 
	s CList($i(CList))= "User.DHCDSSAssKeyWordsD.GBL" 
	s CList($i(CList))= "User.DHCDSSDiseJoinAssessmentD.GBL" 
	s CList($i(CList))= "User.MKBAssessmentBaseD.GBL" 
	s CList($i(CList))= "User.MKBAssessmentBaseC.GBL" 
	s CList($i(CList))= "User.MKBAssessmentBaseFieldD.GBL" 
	s CList($i(CList))= "User.MKBAssessmentScoringRulesD.GBL" 	

	
    //把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"DecisionKBGlobal"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3) //删掉10天前的global
	w time,!
	s filename = filePath_"DecisionKBGlobal"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator：谷雪萍
/// CreatDate:2022-11-22
/// Description:电信云映射决策知识库用到的字典表数据，把2.0表数据映射到1.0表
/// Others：w ##class(web.CDSS.Public.CDSSDataBackup).MappingDecisionKBGlobal()
ClassMethod MappingDecisionKBGlobal()
{
	m ^User.DHCDSSTreatDictD=^CT.WDT.CDSS.TreatDictD  //治疗方案
	m ^User.DHCDSSUnitDictD=^CT.WDT.CDSS.UnitDictD  //单位字典
	m ^User.DHCDSSUnitConversionD=^CT.WDT.CDSS.UnitConversionD  //单位转换
	m ^User.DHCDSSLabOrdersDictD=^CT.WDT.CDSS.LabOrdersDictD  //检验医嘱
	m ^User.DHCDSSDiseaseDictD=^CT.WDT.CDSS.DiseaseDictD  //疾病字典
	m ^User.DHCDSSDrugDictD=^CT.WDT.CDSS.DrugDictD  //药品
	m ^User.DHCDSSExamDictD=^CT.WDT.CDSS.ExamDictD  //检查项目
	m ^User.DHCDSSLabInspectionDictD=^CT.WDT.CDSS.LabInspectionDictD  //检验项目
	m ^User.DHCDSSUsageDictD=^CT.WDT.CDSS.UsageDictD  //用法
	m ^User.DHCDSSOperationDictD=^CT.WDT.CDSS.OperationDictD  //手术
	m ^User.DHCDSSNursingDictD=^CT.WDT.CDSS.NursingDictD  //护理
	m ^User.DHCDSSBloodProductDictD=^CT.WDT.CDSS.BloodProductDictD  //输血
	m ^User.DHCDSSLabSpecimenDictD=^CT.WDT.CDSS.LabSpecimenDictD  //检验标本
	m ^User.DHCDSSFrequencyDictD=^CT.WDT.CDSS.FrequencyDictD  //频率
	m ^User.DHCDSSUsageDictD=^CT.WDT.CDSS.UsageDictD  //用法
	m ^User.DHCDSSPhysicalExamDictD=^CT.WDT.CDSS.PhysicalExamDictD  //体格检查字典
	m ^User.DHCDSSDiseaseDeptDictD=^CT.WDT.CDSS.DiseaseDeptDictD  //科室
	m ^User.DHCDSSDocuManageD=^CT.WDT.CDSS.DocuManageD  //文献
	m ^User.DHCDSSDocuJoinDiseaseD=^CT.WDT.CDSS.DocuJoinDiseaseD  //文献关联诊断
	m ^User.DHCDSSDocuJoinDeptD=^CT.WDT.CDSS.DocuJoinDeptD  //文献关联科室
	m ^User.DHCDSSDocuDetailD=^CT.WDT.CDSS.DocuDetailD  //文献详情
	m ^User.DHCDSSDocuAgencyD=^CT.WDT.CDSS.DocuAgencyD  //文献发布机构表
	m ^User.DHCDSSBodyParDictD=^CT.WDT.CDSS.BodyParDictD  //部位
	m ^User.DHCDSSExamResultDictD=^CT.WDT.CDSS.ExamResultDictD  //检查结果
	m ^User.DHCDSSSymptomDictD=^CT.WDT.CDSS.SymptomDictD  //症状字典
	
	//评估表
	m ^CT.WDT.MKB.AssConResCondiD=^CT.WDT.CDSS.AssConResCondiD	
	m ^User.DHCDSSAssBasicInfoD=^CT.WDT.CDSS.AssBasicInfoD
	m ^User.DHCDSSAssConDeptD=^CT.WDT.CDSS.AssConDeptD
	m ^User.DHCDSSAssConDocD=^CT.WDT.CDSS.AssConDocD
	m ^User.DHCDSSAssessResultDictD=^CT.WDT.CDSS.AssessResultDictD
	m ^User.DHCDSSAssKeyWordsD=^CT.WDT.CDSS.AssKeyWordsD
	m ^User.DHCDSSDiseJoinAssessmentD=^CT.WDT.CDSS.DiseJoinAssessD
	m ^User.MKBAssessmentBaseD=^CT.WDT.CDSS.AssBaseD
	m ^User.MKBAssessmentBaseC=^CT.WDT.CDSS.AssBaseC
	m ^User.MKBAssessmentBaseFieldD=^CT.WDT.CDSS.AssBaseFieldD
	m ^User.MKBAssessmentScoringRulesD=^CT.WDT.CDSS.AssScoringRulesD
	
	d ##class(User.DHCDSSTreatDict).%BuildIndices()
	d ##class(User.DHCDSSUnitDict).%BuildIndices()
	d ##class(User.DHCDSSUnitConversion).%BuildIndices()
	d ##class(User.DHCDSSLabOrdersDict).%BuildIndices()
	d ##class(User.DHCDSSDiseaseDict).%BuildIndices()
	d ##class(User.DHCDSSDrugDict).%BuildIndices()
	d ##class(User.DHCDSSExamDict).%BuildIndices()
	d ##class(User.DHCDSSLabInspectionDict).%BuildIndices()
	d ##class(User.DHCDSSUsageDict).%BuildIndices()
	d ##class(User.DHCDSSOperationDict).%BuildIndices()
	d ##class(User.DHCDSSNursingDict).%BuildIndices()
	d ##class(User.DHCDSSBloodProductDict).%BuildIndices()
	d ##class(User.DHCDSSLabSpecimenDict).%BuildIndices()
	d ##class(User.DHCDSSFrequencyDict).%BuildIndices()
	d ##class(User.DHCDSSUsageDict).%BuildIndices()
	d ##class(User.DHCDSSPhysicalExamDict).%BuildIndices()
	d ##class(User.DHCDSSDiseaseDeptDict).%BuildIndices()
	d ##class(User.DHCDSSDocuManage).%BuildIndices()
	d ##class(User.DHCDSSDocuJoinDisease).%BuildIndices()
	d ##class(User.DHCDSSDocuJoinDept).%BuildIndices()
	d ##class(User.DHCDSSDocuDetail).%BuildIndices()
	d ##class(User.DHCDSSDocuAgency).%BuildIndices()
	d ##class(User.DHCDSSBodyParDict).%BuildIndices()
	d ##class(User.DHCDSSExamResultDict).%BuildIndices()
	d ##class(User.DHCDSSSymptomDict).%BuildIndices()
	
	d ##class(CT.WDT.MKB.AssConResCondi).%BuildIndices()
	d ##class(User.DHCDSSAssBasicInfo).%BuildIndices()
	d ##class(User.DHCDSSAssConDept).%BuildIndices()
	d ##class(User.DHCDSSAssConDoc).%BuildIndices()
	d ##class(User.DHCDSSAssessResultDict).%BuildIndices()
	d ##class(User.DHCDSSAssKeyWords).%BuildIndices()
	d ##class(User.DHCDSSDiseJoinAssessment).%BuildIndices()
	d ##class(User.MKBAssessmentBase).%BuildIndices()
	d ##class(User.MKBAssessmentBaseField).%BuildIndices()
	d ##class(User.MKBAssessmentScoringRules).%BuildIndices()
	q "over"
}

/// Creator:谷雪萍
/// CreatDate:2022-11-02
/// Description：重新生成业务表索引
/// Table：患者信息的所有表、解析器、数据统计相关表
/// Input：
/// Output：
/// w ##class(web.CDSS.Public.CDSSDataBackup).BuildPatientTableIndices()
ClassMethod BuildPatientTableIndices()
{
	k ^WDT.CDSS.PatientMasterI
	k ^WDT.CDSS.PatientVisitI
	k ^WDT.CDSS.SignInfoI
	k ^WDT.CDSS.ChiefCompInfoI
	k ^WDT.CDSS.CurrentMedHistoryI
	k ^WDT.CDSS.PastDiagnosisI
	k ^WDT.CDSS.PersonalInfoI
	k ^WDT.CDSS.MarryInfoI
	k ^WDT.CDSS.FamilyHisInfoI
	k ^WDT.CDSS.AllergyHistoryI
	k ^WDT.CDSS.PhysicalExamI
	k ^WDT.CDSS.SpecExamI
	k ^WDT.CDSS.DiagnosisInfoI
	k ^WDT.CDSS.DrugInfoI
	k ^WDT.CDSS.ExamInfoI
	k ^WDT.CDSS.LabInfoI
	k ^WDT.CDSS.OperationInfoI
	k ^WDT.CDSS.AnestInfoI
	k ^WDT.CDSS.NursingInfoI
	k ^WDT.CDSS.BloodTransInfoI
	k ^WDT.CDSS.DietInfoI
	k ^WDT.CDSS.ClinicalFeatureI
	k ^WDT.CDSS.ClinicalFDetailedI
	k ^WDT.CDSS.OtherOrderInfoI
	k ^WDT.CDSS.InpatientInfoI
	k ^WDT.CDSS.CarryDrugI
	k ^WDT.CDSS.OtherDisOrderInfoI
	k ^WDT.CDSS.PatientTransferI
	k ^WDT.CDSS.LabExamInfoI
	k ^WDT.CDSS.NursResultInfoI
	k ^WDT.CDSS.PatTriggerStaticI
	k ^WDT.CDSS.UserClickStaticI
	k ^WDT.CDSS.PatPMTypeIndexI
	k ^WDT.CDSS.PatTriggerIWI
	k ^WDT.CDSS.PatTriggerRuleI
	k ^WDT.CDSS.PatientRecomInfoI
	k ^WDT.CDSS.PatientRatingScaleI
	d ##class(WDT.CDSS.PatientMaster).%BuildIndices()
	d ##class(WDT.CDSS.PatientVisit).%BuildIndices()
	d ##class(WDT.CDSS.SignInfo).%BuildIndices()
	d ##class(WDT.CDSS.ChiefCompInfo).%BuildIndices()
	d ##class(WDT.CDSS.CurrentMedHistory).%BuildIndices()
	d ##class(WDT.CDSS.PastDiagnosis).%BuildIndices()
	d ##class(WDT.CDSS.PersonalInfo).%BuildIndices()
	d ##class(WDT.CDSS.MarryInfo).%BuildIndices()
	d ##class(WDT.CDSS.FamilyHisInfo).%BuildIndices()
	d ##class(WDT.CDSS.AllergyHistory).%BuildIndices()
	d ##class(WDT.CDSS.PhysicalExam).%BuildIndices()
	d ##class(WDT.CDSS.SpecExam).%BuildIndices()
	d ##class(WDT.CDSS.DiagnosisInfo).%BuildIndices()
	d ##class(WDT.CDSS.DrugInfo).%BuildIndices()
	d ##class(WDT.CDSS.ExamInfo).%BuildIndices()
	d ##class(WDT.CDSS.LabInfo).%BuildIndices()
	d ##class(WDT.CDSS.OperationInfo).%BuildIndices()
	d ##class(WDT.CDSS.AnestInfo).%BuildIndices()
	d ##class(WDT.CDSS.NursingInfo).%BuildIndices()
	d ##class(WDT.CDSS.BloodTransInfo).%BuildIndices()
	d ##class(WDT.CDSS.DietInfo).%BuildIndices()
	d ##class(WDT.CDSS.ClinicalFeature).%BuildIndices()
	d ##class(WDT.CDSS.ClinicalFDetailed).%BuildIndices()
	d ##class(WDT.CDSS.OtherOrderInfo).%BuildIndices()
	d ##class(WDT.CDSS.InpatientInfo).%BuildIndices()
	d ##class(WDT.CDSS.CarryDrug).%BuildIndices()
	d ##class(WDT.CDSS.OtherDisOrderInfo).%BuildIndices()
	d ##class(WDT.CDSS.PatientTransfer).%BuildIndices()
	d ##class(WDT.CDSS.LabExamInfo).%BuildIndices()
	d ##class(WDT.CDSS.NursResultInfo).%BuildIndices()
	d ##class(WDT.CDSS.PatTriggerStatic).%BuildIndices()
	d ##class(WDT.CDSS.UserClickStatic).%BuildIndices()
	d ##class(WDT.CDSS.PatPMTypeIndex).%BuildIndices()
	d ##class(WDT.CDSS.PatTriggerIW).%BuildIndices()
	d ##class(WDT.CDSS.PatTriggerRule).%BuildIndices()
	d ##class(WDT.CDSS.PatientRecomInfo).%BuildIndices()
	d ##class(WDT.CDSS.PatientRatingScale).%BuildIndices()
	q "over"
}

}
