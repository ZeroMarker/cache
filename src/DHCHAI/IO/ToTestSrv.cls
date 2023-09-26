/// 名称: DHCHAI.IO.ToTestSrv
/// 描述: 医院感染管理（HAI）初始化程序
/// 编写者：pylian
/// 编写日期: 2021-10-18
Class DHCHAI.IO.ToTestSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##Class(DHCHAI.IO.ToTestSrv).ClearHAIBusiness()
/// 清医院感染管理（HAI）业务数据
ClassMethod ClearHAIBusiness()
{
	W "开始清除医院感染管理业务数据...",!
	
	//医院感染管理4.0	
	//疑似病例筛查评估
	Kill ^DHCHAI.AM.AssessModelD          //疑似病例筛查评估模型(新增)
	Kill ^DHCHAI.AM.AssessModelI
	Kill ^DHCHAI.AM.AssessResultD         //疑似病例筛查评估结果(新增)
	Kill ^DHCHAI.AM.AssessResultI
	
	Kill ^DHCHAI.ANT.ReportD              //碳青霉素/替加环素类抗菌药物用药申请表(新增)
	Kill ^DHCHAI.ANT.ReportI
	
	//数据池数据 
	Kill ^DHCHAI.DP.CSSDRecordD           //消毒供应中心(新增)
	Kill ^DHCHAI.DP.CSSDRecordI
	Kill ^DHCHAI.DP.EmConsultD            //会诊表
	Kill ^DHCHAI.DP.EmConsultI
	Kill ^DHCHAI.DP.EmrRecordD	          //电子病历
	Kill ^DHCHAI.DP.EmrRecordI
	Kill ^DHCHAI.DP.LabVisitNumberD		  //检验标本
	Kill ^DHCHAI.DP.LabVisitNumberI
	Kill ^DHCHAI.DP.LabVisitReportD		  //检验报告
	Kill ^DHCHAI.DP.LabVisitReportI
	Kill ^DHCHAI.DP.LabVisitRepResultD	  //检验结果
	Kill ^DHCHAI.DP.LabVisitRepResultI
	Kill ^DHCHAI.DP.LabVisitRepRstResD    //耐药机制结果(新增)
	Kill ^DHCHAI.DP.LabVisitRepRstResI
	Kill ^DHCHAI.DP.LabVisitRepRstSenD	  //药敏结果
	Kill ^DHCHAI.DP.LabVisitRepRstSenI
	Kill ^DHCHAI.DP.LabVisitTestSetD	  //检验医嘱/检验组套
	Kill ^DHCHAI.DP.LabVisitTestSetI
	Kill ^DHCHAI.DP.MRDiagnosD		      //诊断信息
	Kill ^DHCHAI.DP.MRDiagnosI
	Kill ^DHCHAI.DP.MRObservationsD		  //护理记录
	Kill ^DHCHAI.DP.MRObservationsI
	Kill ^DHCHAI.DP.OEOrdItemD		      //医嘱记录
	Kill ^DHCHAI.DP.OEOrdItemI
	Kill ^DHCHAI.DP.OROperAnaesD		  //手术麻醉记录
	Kill ^DHCHAI.DP.OROperAnaesI	
	Kill ^DHCHAI.DP.OROperAnaesRecordD    //手术麻醉记录原始记录
	Kill ^DHCHAI.DP.OROperAnaesRecordI
	Kill ^MA.HAI.IR.CRuleOperCatP75D      //手术分类75百分位(add 20211018)
	Kill ^MA.HAI.IR.CRuleOperCatP75I
	
	Kill ^DHCHAI.DP.OROperationD		  //手术编目信息
	Kill ^DHCHAI.DP.OROperationI
	Kill ^DHCHAI.DP.OutofbedD             //离床超过一日患者(新增)
	Kill ^DHCHAI.DP.OutofbedI 
	Kill ^DHCHAI.DP.PAAdmD			      //就诊
	Kill ^DHCHAI.DP.PAAdmI
	Kill ^DHCHAI.DP.PAAdmTransD		      //转科记录
	Kill ^DHCHAI.DP.PAAdmTransI
	Kill ^DHCHAI.DP.RBReportD		      //检查报告
	Kill ^DHCHAI.DP.RBReportI
	Kill ^DHCHAI.DP.SyncErrLogD		      //数据抓取异常日志
	Kill ^DHCHAI.DP.SyncErrLogI
	
	Kill ^MA.HAI.DP.PADocBookingD         //住院证登记表 （add 20220720）
	Kill ^MA.HAI.DP.PADocBookingI
	
	Kill ^DHCHAI.DP.LabInfVisitNumberD     //院感检验标本记录表--环境卫生学、职业暴露 (add 20211018)
	Kill ^DHCHAI.DP.LabInfVisitNumberI
	Kill ^DHCHAI.DP.LabInfVisitReportD     //院感检验报告--环境卫生学、职业暴露 (add 20211018)
	Kill ^DHCHAI.DP.LabInfVisitReportI
	Kill ^DHCHAI.DP.LabInfVisitResultD     //院感检验结果--环境卫生学、职业暴露 (add 20211018)
	Kill ^DHCHAI.DP.LabInfVisitResultI
	
	Kill ^MA.HAI.DP.BPRecordD       // 血液透析记录
	Kill ^MA.HAI.DP.BPRecordI
	Kill ^MA.HAI.DP.BPAccessTypeD   // 血管通路类型
	Kill ^MA.HAI.DP.BPAccessTypeI
	Kill ^MA.HAI.DP.BPRegisterD     // 血透登记表
	Kill ^MA.HAI.DP.BPRegisterI
	
	Kill ^MA.HAI.IR.BPSurveryD         // 血透个案登记表
	Kill ^MA.HAI.IR.BPSurveryI
	
	//分析结果 语义分析
	Kill ^DHCHAI.RME.DocMasterD            //文档主记录
	Kill ^DHCHAI.RME.DocMasterI

	//业务数据
	Kill ^DHCHAI.IR.ASPAntiRecordD		   //抗菌用药记录表
	Kill ^DHCHAI.IR.ASPAntiRecordI
	Kill ^DHCHAI.IR.ASPOpinionD			   //抗菌用药导向计划（ASP）处置意见表
	Kill ^DHCHAI.IR.ASPOpinionI
	Kill ^DHCHAI.IR.ASPOrdItemD			   //抗菌用药导向计划（ASP）医嘱表
	Kill ^DHCHAI.IR.ASPOrdItemI
	Kill ^DHCHAI.IR.ASPProgramD			   //抗菌用药导向计划（ASP）处置意见
	Kill ^DHCHAI.IR.ASPProgramI
	Kill ^DHCHAI.IR.CCDiagnosD             //患者出院感染诊断(新增)
	Kill ^DHCHAI.IR.CCDiagnosI
	Kill ^DHCHAI.IR.CCErrorLogD			   //感染监控错误日志
	Kill ^DHCHAI.IR.CCErrorLogI
	Kill ^DHCHAI.IR.CCFeedbackD			   //问题反馈列表
	Kill ^DHCHAI.IR.CCFeedbackI
	Kill ^DHCHAI.IR.CCFeverNumD			   //科室发热人数
	Kill ^DHCHAI.IR.CCFeverNumI
	Kill ^DHCHAI.IR.CCLocGroupD			   //院感科工作科室分组
	Kill ^DHCHAI.IR.CCLocGroupI
	Kill ^DHCHAI.IR.CCMessageD             //消息记录
	Kill ^DHCHAI.IR.CCMessageI
	Kill ^DHCHAI.IR.CCResultD              //医院感染监测结果
	Kill ^DHCHAI.IR.CCResultI
	Kill ^DHCHAI.IR.CCScreenAttD           //疑似病例筛查 需关注病人列表
	Kill ^DHCHAI.IR.CCScreenAttI
	Kill ^DHCHAI.IR.CCScreeningD           //疑似病例筛查病人列表
	Kill ^DHCHAI.IR.CCScreeningI
	Kill ^DHCHAI.IR.CCWarningD             //暴发预警表
	Kill ^DHCHAI.IR.CCWarningI
	Kill ^DHCHAI.IR.CCWarningActD          //暴发预警处置
	Kill ^DHCHAI.IR.CCWarningActI  
	Kill ^DHCHAI.IR.CCWarningActEpD        //暴发预警确诊排除患者记录表(add 20211018)
	Kill ^DHCHAI.IR.CCWarningActEpI
	Kill ^DHCHAI.IR.CCWarningRepD          //暴发预警报告
	Kill ^DHCHAI.IR.CCWarningRepI       

	Kill ^DHCHAI.IR.EnviHyReportD		  //环境卫生学监测报告单
	Kill ^DHCHAI.IR.EnviHyReportI
	Kill ^DHCHAI.IR.EnviHyReportC
	Kill ^DHCHAI.IR.EnviLocMLogD          //环境卫生学科室监测项目计划发送消息日志(add 20211018)
	Kill ^DHCHAI.IR.EnviLocMLogI
	Kill ^MA.HAI.IR.EnviHyReCheckD        //环境卫生学不正确原因键值对 （add 20230317）
	Kill ^MA.HAI.IR.EnviHyReCheckI
	
	Kill ^DHCHAI.IR.OutLabReportD         //外院携带多耐检验结果 （add 20230317）
	Kill ^DHCHAI.IR.OutLabReportI
	
	Kill ^DHCHAI.IR.HandHyRegD			  //手卫生依从性调查登记
	Kill ^DHCHAI.IR.HandHyRegI
	Kill ^DHCHAI.IR.HandHyConsumsD		  //手卫生用品消耗量登记
	Kill ^DHCHAI.IR.HandHyConsumsI
	
	Kill ^DHCHAI.IR.INFReportD            //感染报告、关联数据、更新日志
	Kill ^DHCHAI.IR.INFReportI
	Kill ^DHCHAI.IR.INFDiagnosD           //感染报告 诊断信息
	Kill ^DHCHAI.IR.INFDiagnosI
	Kill ^DHCHAI.IR.INFAntiD              //感染报告 抗菌用药
	Kill ^DHCHAI.IR.INFAntiI
	Kill ^DHCHAI.IR.INFICDD               //感染报告 疾病诊断
	Kill ^DHCHAI.IR.INFICDI
	Kill ^DHCHAI.IR.INFInvOperD           //感染报告 ICU侵害性操作
	Kill ^DHCHAI.IR.INFInvOperI
	Kill ^DHCHAI.IR.INFLabD               //感染报告 病原学检验
	Kill ^DHCHAI.IR.INFLabI
	Kill ^DHCHAI.IR.INFLastAdmD           //感染报告 历史就诊(新增)
	Kill ^DHCHAI.IR.INFLastAdmI
	Kill ^DHCHAI.IR.INFMBRD               //多重耐药 检验
	Kill ^DHCHAI.IR.INFMBRI
	Kill ^DHCHAI.IR.INFOPSD               //手术切口调查表
	Kill ^DHCHAI.IR.INFOPSI
	Kill ^DHCHAI.IR.INFPreFactorD         //医院感染 易感因素
	Kill ^DHCHAI.IR.INFPreFactorI
	
	Kill ^DHCHAI.IR.ICUGradeD             //ICU临床病情等级
	Kill ^DHCHAI.IR.ICUGradeI
	Kill ^DHCHAI.IR.ICUIExAD              //ICU插拔管评估表(add 20211018)
	Kill ^DHCHAI.IR.ICUIExAI
	Kill ^DHCHAI.IR.ICUIExAExtI           //ICU插拔管评估表(明细表)(add 20211018)
	Kill ^DHCHAI.IR.ICULogD               //ICU调查日志
	Kill ^DHCHAI.IR.ICULogI
	Kill ^DHCHAI.IR.ICULogDtlD            //CU三管日志表
	Kill ^DHCHAI.IR.ICULogDtlI
	Kill ^DHCHAI.IR.INFICUPICCD           //ICU调查 中心静脉置管
	Kill ^DHCHAI.IR.INFICUPICCI
	Kill ^DHCHAI.IR.INFICUUCD             //ICU调查 泌尿道插管
	Kill ^DHCHAI.IR.INFICUUCI
	Kill ^DHCHAI.IR.INFICUVAPD            //ICU调查 呼吸机
	Kill ^DHCHAI.IR.INFICUVAPI
	Kill ^DHCHAI.IR.INFCSSD               //横断面调查报告
	Kill ^DHCHAI.IR.INFCSSI
	Kill ^DHCHAI.IR.SurveyExecD  		  //横断面调查登记表
	Kill ^DHCHAI.IR.SurveyExecI

    Kill ^DHCHAI.IR.OccExpRegD            //职业暴露 扩展 血清学 日志 （新增）
	Kill ^DHCHAI.IR.OccExpRegI

	Kill ^DHCHAI.STA.ECResultD            //统计数据结果  （新增）
	Kill ^DHCHAI.STA.ECResultI
	Kill ^DHCHAI.STA.HandHyD              //手卫生统计数据 （新增）
	Kill ^DHCHAI.STA.HandHyI
	Kill ^DHCHAI.STA.MRBDetectionD        //多重耐药菌检出情况统计 （新增）
	Kill ^DHCHAI.STA.MRBDetectionI

	Kill ^DHCHAI.Task.TaskManager		  //自动任务
	
	Kill ^DHCHAI.IR.VAEResultD            // VAE筛查结果
	Kill ^DHCHAI.IR.VAEResultI
	
	KILL ^DHCHAI.DP.VAEICUPeepD           // 呼吸机数据
	KILL ^DHCHAI.DP.VAEICUPeepI
	
	KILL ^MA.HAI.IR.PDCARepD			  //PDCA报告
	KILL ^MA.HAI.IR.PDCARepI
	
	KILL ^MA.HAI.IR.PDCAFileUrlD		  //PDCA上传文件
	KILL ^MA.HAI.IR.PDCAFileUrlI
	
	W "清除医院感染管理业务数据结束...",!
	
	Quit "OK"
}

/// Do ##Class(DHCHAI.IO.ToTestSrv).ClearHAIConfig()
/// 清医院感染管理（HAI）配置数据
ClassMethod ClearHAIConfig()
{
	W "开始清除医院感染管理配置数据...",!
	//医院感染管理4.0
	//参数配置、数据池系统定义
	Kill ^DHCHAI.BT.ConfigI		      //系统参数
	Kill ^DHCHAI.BT.ConfigD
	Kill ^DHCHAI.BT.SystemMapI	      //应用子系统对照
	Kill ^DHCHAI.BT.SystemMapD        
	
	//科室、用户、医院字典同步
	Kill ^DHCHAI.BT.CareProvD		  //医护人员表
	Kill ^DHCHAI.BT.CareProvI
	Kill ^DHCHAI.BT.HospGroupI	      //医院分组
	Kill ^DHCHAI.BT.HospGroupD
	Kill ^DHCHAI.BT.HospitalI	      //医院信息
	Kill ^DHCHAI.BT.HospitalD
	Kill ^DHCHAI.BT.HospitalMapI	  //医院对照列表
	Kill ^DHCHAI.BT.HospitalMapD
	Kill ^DHCHAI.BT.LocationI	      //科室
	Kill ^DHCHAI.BT.LocationD
	Kill ^DHCHAI.BT.LocationMapI      //科室对照列表
	Kill ^DHCHAI.BT.LocationMapD
	Kill ^DHCHAI.BT.LocGroupI	      //科室分组
	Kill ^DHCHAI.BT.LocGroupD
	Kill ^DHCHAI.BT.LocRelevantD      //相关科室相互关联 (新增)
	Kill ^DHCHAI.BT.LocRelevantI
	Kill ^DHCHAI.BT.PACBedI           //床位列表
	Kill ^DHCHAI.BT.PACBedD
	Kill ^DHCHAI.BT.PACRoomI          //房间分布定义
	Kill ^DHCHAI.BT.PACRoomD
	Kill ^DHCHAI.BT.PACWardI          //病区分布定义
	Kill ^DHCHAI.BT.PACWardD          
	Kill ^DHCHAI.BT.SysUserI	      //系统用户表
	Kill ^DHCHAI.BT.SysUserD          
	Kill ^DHCHAI.BT.SysUserMapI	      //用户对照列表
	Kill ^DHCHAI.BT.SysUserMapD
	
	//基础字典
	Kill ^DHCHAI.BT.DictionaryI	      //系统字典
	Kill ^DHCHAI.BT.DictionaryD
	Kill ^DHCHAI.BT.DicTypeI	      //字典分类
	Kill ^DHCHAI.BT.DicTypeD
	Kill ^DHCHAI.BT.InfPosI		      //感染诊断（部位）
	Kill ^DHCHAI.BT.InfPosD
	Kill ^DHCHAI.BT.InfPosGistD		  //感染诊断诊断依据
	Kill ^DHCHAI.BT.InfPosGistI
	Kill ^DHCHAI.BT.InfSubI		      //感染诊断分类
	Kill ^DHCHAI.BT.InfSubD
	Kill ^DHCHAI.BT.InfSuPosD         //医院感染疑似诊断部位表
	Kill ^DHCHAI.BT.InfSuPosI
	Kill ^DHCHAI.BT.InvasOperI	      //侵害性操作表
	Kill ^DHCHAI.BT.InvasOperD
	Kill ^DHCHAI.BT.PreFactorI	      //易感因素
	Kill ^DHCHAI.BT.PreFactorD        
	
	//监测规则
	Kill ^DHCHAI.IR.CCItmMastD           //监控项目定义
	Kill ^DHCHAI.IR.CCItmMastI
	Kill ^DHCHAI.IR.CCItmScreenD         //疑似筛查项目定义
	Kill ^DHCHAI.IR.CCItmScreenI
	Kill ^DHCHAI.IR.CCItmWarnD           //暴发预警项目定义
	Kill ^DHCHAI.IR.CCItmWarnI
	Kill ^DHCHAI.IR.CCKeyWordD           //关键词表
	Kill ^DHCHAI.IR.CCKeyWordI
	Kill ^DHCHAI.IR.CCWarnLineD          //暴发预警阀值表(修改后)
	Kill ^DHCHAI.IR.CCWarnLineI
	Kill ^DHCHAI.IR.CRuleAntiD			 //抗菌用药筛查维护 (修改后)
	Kill ^DHCHAI.IR.CRuleAntiI	
	Kill ^DHCHAI.IR.CRuleDefD            //医院感染诊断标准、医院感染诊断定义
	Kill ^DHCHAI.IR.CRuleDefI
	Kill ^DHCHAI.IR.CRuleInfSuPosD       //医院感染关键词库
	Kill ^DHCHAI.IR.CRuleInfSuPosI
	Kill ^DHCHAI.IR.CRuleInfSuItemD      //医院感染疑似筛查规则项目(新增)
	Kill ^DHCHAI.IR.CRuleInfSuItemI
	Kill ^DHCHAI.IR.CRuleInfSuRuleD      //医院感染疑似筛查规则(新增)
	Kill ^DHCHAI.IR.CRuleInfSuRuleI

	Kill ^DHCHAI.IR.CRuleLocArgsD		  //科室参数设置
	Kill ^DHCHAI.IR.CRuleLocArgsI
	Kill ^DHCHAI.IR.CRuleMRBD             //多重耐药菌分类
	Kill ^DHCHAI.IR.CRuleMRBI
	Kill ^DHCHAI.IR.CRuleOperD            //手术筛查标准
	Kill ^DHCHAI.IR.CRuleOperI
	
	Kill ^CF.MA.HAI.IR.CRuleOperCatD      //手术分类维护
	Kill ^CF.MA.HAI.IR.CRuleOperCatI
	
	//手术分类标准
	Kill ^DHCHAI.IR.CRuleOperKeysD        //手术筛查关键词
	Kill ^DHCHAI.IR.CRuleOperKeysI
	Kill ^DHCHAI.IR.CRuleRBAbD            //影像学筛查标准
	Kill ^DHCHAI.IR.CRuleRBAbI
	Kill ^DHCHAI.IR.CRuleTestAbD          //常规检验项目
	Kill ^DHCHAI.IR.CRuleTestAbI
	Kill ^DHCHAI.IR.EnviHyItemD			  //环境卫生学监测项目
	Kill ^DHCHAI.IR.EnviHyItemI
	Kill ^DHCHAI.IR.EnviHyLocItemsD       //环境卫生学科室监测项目计划(新增)
	Kill ^DHCHAI.IR.EnviHyLocItemsI
	Kill ^DHCHAI.IR.EnviHyObjectD		  //环境卫生学监测对象
	Kill ^DHCHAI.IR.EnviHyObjectI
	
	Kill ^DHCHAI.IR.OccExpTypeD           // 职业暴露类型定义感染筛查规则 扩展项目定义 血清学计划 （新增）
	Kill ^DHCHAI.IR.OccExpTypeI
	Kill ^DHCHAI.IR.PlanManageD           //消息干预-预案管理(新增)
	Kill ^DHCHAI.IR.PlanManageI
	
	Kill ^DHCHAI.IR.HandHyProductsD       //手卫生用品字典
	Kill ^DHCHAI.IR.HandHyProductsI
	Kill ^DHCHAI.IR.HandHyUnitConFacD	  //手卫生用品单位换算关系 
	Kill ^DHCHAI.IR.HandHyUnitConFacI

	//语义分析
	Kill ^DHCHAI.RME.CorpusPhrasesD        //短语规则-语料库(新增)
	Kill ^DHCHAI.RME.CorpusPhrasesI
	Kill ^DHCHAI.RME.CorpusTaggingD        //感染标注词库-语料库(新增)
	Kill ^DHCHAI.RME.CorpusTaggingI
	Kill ^DHCHAI.RME.CorpusWordsD          //高频词-语料库(新增)
	Kill ^DHCHAI.RME.CorpusWordsI
	Kill ^DHCHAI.RME.DocTypeD              //文档类型
	Kill ^DHCHAI.RME.DocTypeI 
	Kill ^DHCHAI.RME.OneWordsD             //归一词库
	Kill ^DHCHAI.RME.OneWordsI
	Kill ^DHCHAI.RME.ParserWordsD          //语义词库
	Kill ^DHCHAI.RME.ParserWordsI
	Kill ^DHCHAI.RME.PropertyTypeD         //属性类型
	Kill ^DHCHAI.RME.PropertyTypeI
	Kill ^DHCHAI.RME.ResultCatI            //结果分类
	Kill ^DHCHAI.RME.ResultCatD
	Kill ^DHCHAI.RME.ResultTypeD           //结果类型 
	Kill ^DHCHAI.RME.ResultTypeI
	Kill ^DHCHAI.RME.SectionTypeD          //段落分类
	Kill ^DHCHAI.RME.SectionTypeI
	Kill ^DHCHAI.RME.ThemeTypeD            //主题分类
	Kill ^DHCHAI.RME.ThemeTypeI
	Kill ^DHCHAI.RME.ThemeWordsD           //主题词库
	Kill ^DHCHAI.RME.ThemeWordsI 
	Kill ^DHCHAI.RME.ThWordsMapD           //主题词映射
	Kill ^DHCHAI.RME.ThWordsMapI 
	Kill ^DHCHAI.RME.ThWordTypeD           //主题词分类
	Kill ^DHCHAI.RME.ThWordTypeI 
	Kill ^DHCHAI.RME.VersionD              //语义词库版本 
	Kill ^DHCHAI.RME.VersionI
    
    Kill ^DHCHAI.STA.ECTargetD            //统计数据类型（新增）
	Kill ^DHCHAI.STA.ECTargetI
	Kill ^DHCHAI.STA.ECTypeD              //统计数据类型（新增）
	Kill ^DHCHAI.STA.ECTypeI

	Kill ^DHCHAI.STA.NavigationD          //报表导航
	Kill ^DHCHAI.STA.NavigationI
	
	Kill ^CT.MA.HAI.DP.OperDataSourceI	  //手术相关属性数据源配置
	Kill ^CT.MA.HAI.DP.OperDataSourceD
	//数据池字典 
	Kill ^DHCHAI.DP.DataMapRuleD	     //对照匹配规则
	Kill ^DHCHAI.DP.DataMapRuleI
	Kill ^DHCHAI.DP.EmrDocTypeD	         //病历文档类型
	Kill ^DHCHAI.DP.EmrDocTypeI	
	Kill ^DHCHAI.DP.LabAntiMapD	         //检验抗生素字典对照
	Kill ^DHCHAI.DP.LabAntiMapI
	Kill ^DHCHAI.DP.LabBactMapD	         //细菌字典对照
	Kill ^DHCHAI.DP.LabBactMapI
	Kill ^DHCHAI.DP.LabSpecMapD	         //标本对照
	Kill ^DHCHAI.DP.LabSpecMapI
	Kill ^DHCHAI.DP.LabTCMapD	         //常规检验项目对照
	Kill ^DHCHAI.DP.LabTCMapI
	Kill ^DHCHAI.DP.LabTCMapRstD	     //检验项目结果对照
	Kill ^DHCHAI.DP.LabTCMapRstI
	Kill ^DHCHAI.DP.LabTCMapAbD	         //检验项目定值结果对照
	Kill ^DHCHAI.DP.LabTCMapAbI
	Kill ^DHCHAI.DP.LabTCMapTSD	         //检验项目匹配医嘱
	Kill ^DHCHAI.DP.LabTCMapTSI
	Kill ^DHCHAI.DP.LabTestCodeD	     //常规检验项目
	Kill ^DHCHAI.DP.LabTestCodeI
	Kill ^DHCHAI.DP.LabTestSetMapD		 //检验医嘱对照
	Kill ^DHCHAI.DP.LabTestSetMapI
	Kill ^DHCHAI.DP.MRICDDxMapD		     //诊断分类对照
	Kill ^DHCHAI.DP.MRICDDxMapI
	Kill ^DHCHAI.DP.MROBSItemMapD		 //护理项目对照
	Kill ^DHCHAI.DP.MROBSItemMapI
	Kill ^DHCHAI.DP.OEAntiMastMapD		 //抗菌药物对照
	Kill ^DHCHAI.DP.OEAntiMastMapI
	Kill ^DHCHAI.DP.OEItmMastMapD		 //医嘱项对照记录
	Kill ^DHCHAI.DP.OEItmMastMapI
	Kill ^DHCHAI.DP.OROperDxMapD		 //手术字典对照
	Kill ^DHCHAI.DP.OROperDxMapI
	Kill ^DHCHAI.DP.PhraseMapD		     //常用短语对照
	Kill ^DHCHAI.DP.PhraseMapI
	Kill ^DHCHAI.DP.PhraseTypeD		     //常用短语分类
	Kill ^DHCHAI.DP.PhraseTypeI
	Kill ^DHCHAI.DP.RBItmMastMapD		 //检查分类对照
	Kill ^DHCHAI.DP.RBItmMastMapI
    Kill ^DHCHAI.DP.LabInfTestSetD       //院感检验医嘱定义--环境卫生学、职业暴露 (add 20211018)
    Kill ^DHCHAI.DP.LabInfTestSetI
    Kill ^DHCHAI.DP.LabInfTestSetExtI    //院感检验医嘱外部码--环境卫生学、职业暴露 (add 20211018)
    
    //民科接口
    Kill ^DHCHAI.MK.BTDictionaryD        //民科字典项目
    Kill ^DHCHAI.MK.BTDictionaryI
    Kill ^DHCHAI.MK.BTMapDataD           //医院感染对照数据
    Kill ^DHCHAI.MK.BTMapDataI
    Kill ^DHCHAI.MK.BTMapItemD           //医政管理基础字典表
    Kill ^DHCHAI.MK.BTMapItemI
    
    
    //对照字典
    Kill ^MA.HAI.MAP.BaseMappingD   //基础字典映射
    Kill ^MA.HAI.MAP.BaseMappingI
    Kill ^MA.HAI.MAP.BaseRangeD    //基础值域字典
    Kill ^MA.HAI.MAP.BaseRangeI
    Kill ^MA.HAI.DP.CssRangeD      //横断面调查导出值域字典
    Kill ^MA.HAI.DP.CssRangeI
    Kill ^MA.HAI.DP.CssMappingD    //横断面调查导出基础字典映射
    Kill ^MA.HAI.DP.CssMappingI
    Kill ^CF.MA.HAI.MAP.MapItemD   //值域字典
    Kill ^CF.MA.HAI.MAP.MapItemI
    Kill ^CF.MA.HAI.MAP.MapDataD   //数据对照
    Kill ^CF.MA.HAI.MAP.MapDataI   
    
	W "清除医院感染管理配置数据结束...",!
	
	Quit "OK"
}

/// Do ##Class(DHCHAI.IO.ToTestSrv).ClearHAICodeTable()
/// 清医院感染管理（HAI）基础数据
ClassMethod ClearHAICodeTable()
{
	W "开始清除医院感染管理基础数据...",!
	
	//医院感染管理4.0
    //数据池字典(基础数据)
    Kill ^DHCHAI.DP.LabAntibioticD	     //检验抗生素
	Kill ^DHCHAI.DP.LabAntibioticI
	Kill ^DHCHAI.DP.LabAntiCatD	         //检验抗生素分类
	Kill ^DHCHAI.DP.LabAntiCatI
	Kill ^DHCHAI.DP.LabBactCatD	         //细菌分类
	Kill ^DHCHAI.DP.LabBactCatI
	Kill ^DHCHAI.DP.LabBacteriaD	     //细菌
	Kill ^DHCHAI.DP.LabBacteriaI
	Kill ^DHCHAI.DP.LabBactTypeD	     //细菌类型
	Kill ^DHCHAI.DP.LabBactTypeI
	Kill ^CT.MA.HAI.DP.LabBactGenusD	 //细菌菌属
	Kill ^CT.MA.HAI.DP.LabBactGenusI
	Kill ^CT.MA.HAI.DP.LabBactAntiIntD   //天然耐药菌
	Kill ^CT.MA.HAI.DP.LabBactAntiIntI
	Kill ^DHCHAI.DP.LabSpecimenD	     //标本
	Kill ^DHCHAI.DP.LabSpecimenI
	Kill ^DHCHAI.DP.LabTestSetD		     //检验医嘱
	Kill ^DHCHAI.DP.LabTestSetI
	Kill ^DHCHAI.DP.LabTestSetCatD		 //检验医嘱分类
	Kill ^DHCHAI.DP.LabTestSetCatI
	Kill ^DHCHAI.DP.MRICDDxD		     //诊断分类
	Kill ^DHCHAI.DP.MRICDDxI
	Kill ^DHCHAI.DP.MROBSItemD		     //护理项目
	Kill ^DHCHAI.DP.MROBSItemI
	Kill ^DHCHAI.DP.MROBSItemCatD		 //护理项目分类
	Kill ^DHCHAI.DP.MROBSItemCatI
	Kill ^DHCHAI.DP.OEAntiCatD		     //抗菌药物分类
	Kill ^DHCHAI.DP.OEAntiCatI
	Kill ^DHCHAI.DP.OEAntiMastD		     //抗菌药物字典
	Kill ^DHCHAI.DP.OEAntiMastI
	Kill ^DHCHAI.DP.OEItmCatD		     //医嘱分类
	Kill ^DHCHAI.DP.OEItmCatI
	Kill ^DHCHAI.DP.OEItmMastD		     //医嘱项
	Kill ^DHCHAI.DP.OEItmMastI
	Kill ^DHCHAI.DP.OEItmTypeD           //医嘱类型
	Kill ^DHCHAI.DP.OEItmTypeI
	Kill ^DHCHAI.DP.OROperDxD		     //手术字典
	Kill ^DHCHAI.DP.OROperDxI
	Kill ^DHCHAI.DP.RBItmMastD		     //检查分类
	Kill ^DHCHAI.DP.RBItmMastI
	
	Kill ^CT.MA.HAI.BT.DeleteControlD    //院感基础字典删除权限控制表(add 20211018)
	Kill ^CT.MA.HAI.BT.DeleteControlI
	Kill ^DHCHAI.BT.RepHelpDescD         //系统报表指标项说明(add 20211018)
	Kill ^DHCHAI.BT.RepHelpDescI
	
	Kill ^CT.MA.HAI.IR.VAESubItemD      //VAE子项维护
	Kill ^CT.MA.HAI.IR.VAESubItemI
	
	Kill ^CT.MA.HAI.IR.VAERuleConfigD      //VAE配置数据
	Kill ^CT.MA.HAI.IR.VAERuleConfigI
	Kill ^CT.MA.HAI.IR.VAEMonitItemD      //VAE监测项目定义
	Kill ^CT.MA.HAI.IR.VAEMonitItemI
	
	Kill ^CT.MA.HAI.IR.BPSurveyExecD   // 血透个案调查方法执行登记表
	Kill ^CT.MA.HAI.IR.BPSurveyExecI
	
	KILL ^CT.MA.HAI.IR.PDCAIndexBaseD	 //PDCA指标库
	KILL ^CT.MA.HAI.IR.PDCAIndexBaseI
	KILL ^CT.MA.HAI.IR.PDCAModD			 //PDCA模板
	KILL ^CT.MA.HAI.IR.PDCAModI
	
	W "清除医院感染管理基础数据结束...",!
	
	Quit "OK"
}

}
