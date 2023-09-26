Import SQLUser

/// 名称: 多院区共公方法
/// 编写者：xueying
/// 编写日期: 2021-11-1
Class web.DHCPE.CT.Public.Setting Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：    xy 
/// CreatDate：  20211111
/// Description: 体检清理数据基础数据
/// Input:       TabName:表名, ClsName:类名
/// Return
/// d ##class(web.DHCPE.CT.Public.Setting).KillPECTGlobal()
ClassMethod KillPECTGlobal()
{
 
    //表登记授权管理 DHC_PE_PowerTableList
	k ^CT.PE.PowerTableListD  
    k ^CT.PE.PowerTableListI    
    
    //体检关联业务定义表 DHC_PE_LnkAppConfig
	k ^CT.PE.LnkAppConfigD 
    k ^CT.PE.LnkAppConfigI
      
    //由于^DHCPEST既有基础数据,又有配置数据,所以用sql删除
    //站点字典表 DHC_PE_Station
    //站点分类字典表 DHC_PE_StationLoc
    //k ^DHCPEST
    &sql(delete from DHC_PE_Station)
    &sql(delete from DHC_PE_StationLoc)
    
    //职业病结论分类 DHC_PE_Conclusion
    k ^User.DHCPEConclusionD
    k ^User.DHCPEConclusionI
    
    //职业健康检查种类 DHC_PE_OMEType
    k ^User.DHCPEOMETypeD
    k ^User.DHCPEOMETypeI
    
    //职业病目标疾病表 DHC_PE_OMEIllness
    k ^User.DHCPEOMEIllnessD
    k ^User.DHCPEOMEIllnessI
    
    //职业病诊断标准 DHC_PE_DiagnosticCriteria
    k ^User.DHCPEDiagnosticCriteriaD
    k ^User.DHCPEDiagnosticCriteriaDI
    
    //职业病危害因素分类 DHC_PE_EndangerType
   k ^User.DHCPEEndangerTypeD
   k ^User.DHCPEEndangerTypeI
   
   //危害因素 DHC_PE_Endanger
   //危害因素关联诊断标准 DHC_PE_EDCheckCriteria
   //危害因素关联目标疾病 DHC_PE_EDIllness
   //危害因素关联检查周期 DHC_PE_EDCheckCycle
   k ^User.DHCPEEndangerD
   k ^User.DHCPEEndangerI
   k ^User.DHCPEEndangerC
   k ^User.DHCPEEndangerS

     
   //防护措施维护 DHC_PE_ProtectiveMeasures
   k ^User.DHCPEProtectiveMeasuresD
   k ^User.DHCPEProtectiveMeasuresI
   
   //行业维护 DHC_PE_Industry
   k ^User.DHCPEIndustryD
   k ^User.DHCPEIndustryI
   
   //工种维护 DHC_PE_WorkType
   k ^User.DHCPEWorkTypeD
   k ^User.DHCPEWorkTypeI
   
   //由于^User.DHCPEWorkDistributeTypeD既有基础数据,又有配置数据,所以用sql删除
   //工作量分配类型 DHC_PE_WorkDistributeType
    ;k ^User.DHCPEWorkDistributeTypeD
  	;k ^User.DHCPEWorkDistributeTypeI
  	&sql(delete from DHC_PE_WorkDistributeType)
    
  
   //工作量分配类型链接CSP DHC_PE_WorkLinkUrl
   ;k ^User.DHCPEWorkDistributeTypeD
   ;k ^User.DHCPEWorkLinkUrlI
   &sql(delete from DHC_PE_WorkLinkUrl)
   	
   //VIP等级字典 DHC_PE_VIPLevel
   k ^CT.PE.VIPLevelD
   k ^CT.PE.VIPLevelI
   //多院区改造之前的VIP等级数据
   k ^DHCPEVIPLevel  
   
   //体检质量错误类型 DHC_PE_QMType
   k ^User.DHCPEQMTypeD
   k ^User.DHCPEQMTypeI
   
   //体检特殊客户类型维护 DHC_PE_SpecialType
   k ^User.DHCPESpecialTypeD
   k ^User.DHCPESpecialTypeI
   
   //问卷问题维护 DHC_HM_CQuestionsDetail
   k ^User.DHCHMCQuestionsDetailD
   k ^User.DHCHMCQuestionsDetailI
   
   //问卷问题选项维护 DHC_HM_CQDOptions
   //k ^User.DHCHMCQuestionsDetailD
   k ^User.DHCHMCQuestionsDetailC("QDOptions")
   k ^User.DHCHMCQDOptionsI
   
   //问卷量表(主题)定义 DHC_HM_CQDSubject
   //问卷量表(主题)与问题关联表 DHC_HM_CQDSubjectDtl
   k ^CT.PE.HM.CQDSubjectD
   k ^CT.PE.HM.CQDSubjectI
   
   //问卷评估内容维护 DHC_HM_CEvaluationDetail
   k ^User.DHCHMCEvaluationDetailD
   k ^User.DHCHMCEvaluationDetailI
   
   //问卷评估内容与问题关联表 DHC_HM_EvaluationLinkDetail
   k ^User.DHCHMEvaluationLinkDetailD
   k ^User.DHCHMEvaluationLinkDetailI
   
   //问卷评估内容与问题选项关联表 DHC_HM_EvaluationLinkOption
   //k ^User.DHCHMEvaluationLinkDetailD
   k ^User.DHCHMEvaluationLinkOptionC("ELDOption")
   k ^User.DHCHMEvaluationLinkOptionI
    
   //问卷提示类型  DHC_HM_InquiryType
   k ^User.DHCHMInquiryTypeD
   k ^User.DHCHMInquiryTypeI
    
   //问卷提示结果 DHC_HM_InquiryResult
   //k ^User.DHCHMInquiryTypeD
   k ^User.DHCHMInquiryTypeC("ITResult")
   k ^User.DHCHMInquiryResultI
   
   //问卷提示结果详细说明 DHC_HM_InquiryResultDetail
   //k ^User.DHCHMInquiryTypeD
   k ^User.DHCHMInquiryResultC("IRDetail")
   k ^User.DHCHMInquiryResultDetailI
   
   //问卷提示结果与问题关联表 DHC_HM_InquiryQuesRelate  
   k ^User.DHCHMInquiryQuesRelateD
   k ^User.DHCHMInquiryQuesRelateI
   
   //问卷提示结果与问题选项关联表 DHC_HM_InquiryOptionRelate
   //k ^User.DHCHMInquiryQuesRelateD
   k ^User.DHCHMInquiryQuesRelateC("IQROption")
   k ^User.DHCHMInquiryOptionRelateI
   
   k ^DHCPECFDataEx
   
   //体检公共参数配置
   k ^DHCPESettingsParam
   k ^DHCPESettingsValue
   k ^DHCPESettingsValue
   
   w "清理体检基础数据完成！"
}

/// Creator：    xy 
/// CreatDate：  20211111
/// Description: 体检清理数据配置数据
/// Input:       TabName:表名, ClsName:类名
/// Return
/// d ##class(web.DHCPE.CT.Public.Setting).KillPECFGlobal()
ClassMethod KillPECFGlobal()
{
	//科室分组配置 DHC_PE_LocGrpConfig
	k ^CF.PE.LocGrpConfigD   
    k ^CF.PE.LocGrpConfigI
    
    //表记录授权管理 DHC_PE_PowerControl
	k ^CF.PE.PowerControlD  
    k ^CF.PE.PowerControlI
    
    //体检超级用户授权表 DHC_PE_PowerSuperUser
	k ^CF.PE.PowerSuperUserD  
    k ^CF.PE.PowerSuperUserI
    
    //体检关联业务科室对照表 DHC_PE_LnkLocConfig
    k ^CF.PE.LnkLocConfigD
    k ^CF.PE.LnkLocConfigI
    
    //基础表公用更新日志表 DHC_PE_CTUpdateLog
    k ^CF.PE.CTUpdateLogD
    k ^CF.PE.CTUpdateLogI
    
    
    //由于^DHCPEST既有基础数据,又有配置数据,所以用sql删除
    //站点项目组合表 DHC_PE_StationOrder
    //站点项目关联科室 DHC_PE_StationOrderLoc
    //站点细项表  DHC_PE_OrderDetail
    //站点细项选择表  DHC_PE_ODStandard
    //k ^DHCPEST
    &sql(delete from DHC_PE_StationOrder)
    &sql(delete from DHC_PE_StationOrderLoc)
    &sql(delete from DHC_PE_OrderDetail)
    &sql(delete from DHC_PE_ODStandard)
     
    //科室站点详情表 DHC_PE_StationSet
    k ^CF.PE.StationSetD
    k ^CF.PE.StationSetI
    
    //科室站点分类序号表 DHC_PE_StationOrdCatSort
    //科室站点项目序号表 DHC_PE_StationOrderSort
    k ^CF.PE.StationOrdSortD
    k ^CF.PE.StationOrdSortI
    
    //科室站点项目扩展表 DHC_PE_StationOrderSet
    k ^CF.PE.StationOrderSetD
    k ^CF.PE.StationOrderSetI
    
    //科室站点细项扩展表 DHC_PE_OrderDetailSet
    K ^CF.PE.OrderDetailSetD
    k ^CF.PE.OrderDetailSetI
    
    //科室站点大项细项组合表 DHC_PE_OrderDetailRelate
    k ^DHCPEODR
    
    //科室排斥项目维护表 DHC_PE_ExcludeArcItem
    k ^User.DHCPEExcludeArcItemD
    k ^User.DHCPEExcludeArcItemI
    
    //科室导诊单项目分类表 DHC_PE_UsherItemCat
    k ^CF.PE.UsherItemCatD
    k ^CF.PE.UsherItemCatI
    
    //专家建议主表 DHC_PE_ExpertDiagnosis
    k ^DHCPEED
    
    //建议别名表 DHC_PE_EDAlias
    k ^DHCPEEDA
    
    //专家建议与疾病对照表 DHC_PE_IDRelate
    k ^DHCPEIDR
    
    //专家建议自动表达式维护 DHC_PE_Express
    k ^User.DHCPEExpressD
    k ^User.DHCPEExpressI
    
    //建议与级别关联表 DHC_PE_EDCRelate
    k ^DHCPEEDCR

    //建议级别表 DHC_PE_EDClass
    k ^DHCPEEDC
    
    //建议关键词表 DHC_PE_EDKey
    k ^User.DHCPEEDKeyD
    k ^User.DHCPEEDKeyI
    
    //疾病维护表 DHC_PE_IllnessStandard
    k ^DHCPEILLS
    
    //疾病别名表 DHC_PE_ILLSAlias
    k ^DHCPEILLSA
    
    //疾病关联疾病解释表 DHC_PE_ILLSExplain
    k ^CF.PE.ILLSExplainD
    k ^CF.PE.ILLSExplainI
    
    //疾病关联运动指导表 DHC_PE_ILLSSportGuide
    k ^CF.PE.ILLSSportGuideD
    k ^CF.PE.ILLSSportGuideI
     
    //疾病关联饮食指导表 DHC_PE_ILLSDietGuide
    k ^CF.PE.ILLSDietGuideD
    k ^CF.PE.ILLSDietGuideI
    
    //职业健康处理意见 DHC_PE_HandlingOpinions
    k ^User.DHCPEHandlingOpinionsD
    k ^User.DHCPEHandlingOpinionsI
    
    //由于^User.DHCPEEndangerD既有基础数据,又有配置数据,所以用sql删除
    //危害因素关联检查周期 DHC_PE_EDItem
    &sql(delete from DHC_PE_EDItem)
   
    //危害因素关联检查细项 DHC_PE_EDItemDetail
    &sql(delete from DHC_PE_EDItemDetail)
   
   //体检医嘱套扩展表 DHC_PE_OrdSetsEx
   k ^DHCPEOSE
       
   //体检医嘱扩展    DHC_PE_ItemExtend
   //自定义价格医嘱  DHC_PE_IEPrice
   //体检赠送项目    DHC_PE_IESendItem
   k ^DHCPEIE  
   
   //网上套餐项目分类字典表 DHC_PE_NetItemType
   k ^User.DHCPENetItemTypeD
   k ^User.DHCPENetItemTypeI
   
   //网上套餐介绍主表 DHC_PE_NetOrdSets
   //网上套餐介绍项目分类表 DHC_PE_NetSetsItemType
   //网上套餐介绍项目表 DHC_PE_NetSetsItem
   //网上套餐介绍项目明细表 DHC_PE_NetSetsItemDetail
   k ^User.DHCPENetOrdSetsD
   k ^User.DHCPENetOrdSetsI
   
   
   //体检医生维护 DHC_PE_ChartAssign
   //体检医生站点权限 DHC_PE_ChartAssignDtl
   k ^CF.PE.ChartAssignD
   k ^CF.PE.ChartAssignI
   
   //体检收费权限维护 DHC_PE_ChargeLimit
   k ^CF.PE.ChargeLimitD
   k ^CF.PE.ChargeLimitI
   
   //特殊项目权限维护 DHC_PE_SpecialContral
   k ^CF.PE.SpecialContralD
   k ^CF.PE.SpecialContralI
   
   //会诊费收费设置 DHC_PE_OthPatToHPBase
   k ^CF.PE.OthPatToHPBaseD
   k ^CF.PE.OthPatToHPBaseI
   
   //住院医生
   k ^DHCPEOtherPatientToHPBase 
    
   //由于^User.DHCPEWorkDistributeTypeD既有基础数据,又有配置数据,所以用sql删除
   //工作量分配医生 DHC_PE_WorkDoctor
   &sql(delete from DHC_PE_WorkDoctor)
		
	
  	//体检诊室分区维护 DHC_PE_Area
  	//体检诊室维护     DHC_PE_Room
  	//体检诊室IP表     DHC_PE_RoomIP
 	//体检诊室前面诊室 DHC_PE_RoomSpecialRoom
  	//体检诊室位置     DHC_PE_RoomRoomPlace
  	k ^User.DHCPEAreaD
  	k ^User.DHCPEAreaC
	k ^User.DHCPEAreaI
	k ^CF.PE.RoomPlaceD
	k ^User.DHCPERoomC
	k ^User.DHCPERoomI
	k ^User.DHCPERoomIPI
	k ^User.DHCPERoomSpecialRoomI
	k ^User.DHCPERoomRoomPlaceI
	k ^User.DHCPERoomSpecimenI
	
    //科室VIP等级维护 DHC_PE_LocVIPLevel
    k ^CF.PE.LocVIPLevelD
    k ^CF.PE.LocVIPLevelI
   
    //科室短信模板维护 DHC_PE_NewMessageTemplet
    k ^User.DHCPENewMessageTempletD
    k ^User.DHCPENewMessageTempletI
    
 
    //服务级别表 DHC_HM_CServiceClass
    k ^User.DHCHMCServiceClassD
    k ^User.DHCHMCServiceClassI
    
    //服务级别关联问卷表 DHC_HM_CSCQLink
    //k ^User.DHCHMCServiceClassD
    k ^User.DHCHMCServiceClassC
    k ^User.DHCHMCSCQLinkI
  
  
    //调查问卷主表 DHC_HM_CQuestionnaire
    k ^User.DHCHMCQuestionnaireD
    k ^User.DHCHMCQuestionnaireI
    
    //调查问卷主题表 DHC_HM_CQuestionSubject
    //k ^User.DHCHMCQuestionnaireD
    k ^User.DHCHMCQuestionnaireC("QSubject")
    k ^User.DHCHMCQuestionSubjectI
    
    //调查问卷与评估内容关联表 DHC_HM_CQEDLink
    //k ^User.DHCHMCQuestionnaireD
    k ^User.DHCHMCQuestionnaireC("QEDLink")
    k ^User.DHCHMCQEDLinkI
    
    //调查问卷主题与问题关联表 DHC_HM_CSDLink
    //k ^User.DHCHMCQuestionnaireD
    k ^User.DHCHMCQuestionSubjectC("QSDLink")
    k ^User.DHCHMCSDLinkI
   
    //问卷关联体检套餐维护 DHC_HM_OrdSetsLink
    k ^User.DHCHMOrdSetsLinkD
    k ^User.DHCHMOrdSetsLinkI
    
    //问卷套餐与问卷问题关联表 DHC_HM_OrdSetsQDetail
    //k ^User.DHCHMOrdSetsLinkD
    k ^User.DHCHMOrdSetsLinkC("OLDetail")
    k ^User.DHCHMOrdSetsQDetailI
   
    //问卷套餐与问卷问题选项关联表 DHC_HM_OrdSetsQDOption
    //k ^User.DHCHMOrdSetsLinkD
    k ^User.DHCHMOrdSetsQDetailC("OLOption")
    k ^User.DHCHMOrdSetsQDOptionI
    
    //站点医嘱项设置表/对照表 DHC_PE_STOrderSetting
	k ^User.DHCPESTOrderSettingD
	k ^User.DHCPESTOrderSettingI

    
    //体检基础、前台、报告、收费的配置数据
    k ^DHCPESetting("DHCPE")
    k ^DHCPESetting("NAMESPACE","LABDATA")
    k ^DHCPESetting("NAMESPACE","MEDDATA")
    
    //扩展字段（多院区改造前）
	k ^DHCPECTDataEx
	
	//体检设备维护界面
	k ^CT.PE.UpLoadResultD
	k ^CT.PE.UpLoadResultI
	k ^CF.PE.LocUpLoadResultD
	k ^CF.PE.LocUpLoadResultI
	
	//报告配置
	k ^User.DHCPEReportSettingD
	k ^User.DHCPEReportSettingI

    w "清理体检配置数据完成！"
}

/// Creator：    xy 
/// CreatDate：  20211111
/// Description: 体检清理数据业务数据
/// Input:       TabName:表名, ClsName:类名
/// Return
/// d ##class(web.DHCPE.CT.Public.Setting).KillPECBGlobal()
ClassMethod KillPECBGlobal()
{
	k ^DHCPEPreIBI	//预约）个人基本信息表DHC_PE_PreIBaseInfo
	
	k ^DHCPEPreIADM //（预约）个人ADM表DHC_PE_PreIADM
					//（预约）个人项目套餐表 DHC_PE_PreIOrdEnt（个人ADM表的子表）
					//（预约）个人项目套餐费用表 DHC_PE_PreIOrdEntFee（个人项目套餐表的子表）
					//（预约）个人项目表 DHC_PE_PreIOrdItem（个人ADM表的子表）
					//（预约）个人项目费用表 DHC_PE_PreIOrdItemFee（个人项目表的子表）
					
	k ^DHCPEPreGBI	//（预约）团体客户基本信息表DHC_PE_PreGBaseInfo
	
	k ^DHCPEPreGADM //（预约）团体客户ADM表 DHC_PE_PreGADM
	 				//（预约）团体分组表 DHC_PE_PreGTeam（团体ADM表的子表）
	 				//（预约）团体分组项目套餐表 DHC_PE_PreGTOrdEnt（团体分组表的子表）
	 				//（预约）团体分组项目表 DHC_PE_PreGTOrdItem（团体分组表的子表）
	 				
	k ^DHCPEPreA	//（预约）团体和个人ADM审核表 DHC_PE_PreAudit
	
	k ^DHCPEPAPBR	//（预约）审核表和收费表的对照 DHC_PE_PAPBRelate
		
	k ^DHCPEGBI   //团体客户基本信息登记表DHC_PE_GBaseInfo
	
	k ^DHCPEGADM  //1、团体客户ADM表 DHC_PE_GADM
				  //2、团体分组表 DHC_PE_GTeam（团体ADM表的子表）
	k ^DHCPEIADM  //体检人员表ADM表DHC_PE_IADM
	
	//k ^DHCPEACO	  //视同收费项目费用状态表DHC_PE_AsChargedOrder（挂账）
	
	k ^DHCPECRMO  //与CRM大项对照表DHC_PE_CRMOrder
	
	k ^DHCPERPT   //体检报告DHC_PE_Report
	
	k ^DHCPERLT   //体检结果表DHC_PE_Result
	
	k ^DHCPETempResult
	
	k ^DHCPESS    //科室小结DHC_PE_StationSummarize
	              //站点（科室）小结阳性体征DHC_PE_SSResult（所有阳性体征）
	              //站点（科室）小结诊断明细DHC_PE_SSDiagnosis（所有诊断）
	              
	k ^DHCPEGA	  //总检建议DHC_PE_GeneralAdvice
				  //总检建议明细表DHC_PE_GeneralAdviceDetail
				  
	k ^DHCPEGS	  //总检结论DHC_PE_GeneralSummarize
				  //总检结论阳性体征DHC_PE_GSResult（各个科室阳性体征）
				  //总检结论诊断明细DHC_PE_GSDiagnosis（各个科室所有诊断）
	k ^DHCPEGGS
	
    k ^DHCPEGSDM
    
    //总检疾病列表			  
    k ^User.DHCPEGSIllnessD 
    k ^User.DHCPEGSIllnessI
    
    //体检报告DHC_PE_Report			  
	k ^DHCPERPT   
	
	//发票表
	k ^DHCPEINVPRT
	
	//集中打印发票
	k ^User.DHCPEINVFocusPrtI
	k ^User.DHCPEINVFocusPrtD
	
	//集中打印发票报表
	k ^User.DHCPEFocusPrtReportI
	k ^User.DHCPEFocusPrtReportD
		
	//收费员日结表
	k ^DHCPEUSERREPORT	
	
	//保存的业务阳性体征
	k ^DHCPEGenED	
	
	k ^DHCPEACO
	
    k ^DHCPEAP
    
    //个人基本信息修改日志表
    k ^User.DHCPEModifyRecordD
	k ^User.DHCPEModifyRecordI 
	
    //个人操作日志(体检过程记录)
	k ^User.DHCPEAdmRecordManagerD
	k ^User.DHCPEAdmRecordManagerI
	
	//团体操作日志
	k ^User.DHCPEGAdmRecordManagerD
	k ^User.DHCPEGAdmRecordManagerI
    
    //延期项目
    k ^User.DHCPEDelayRecordD
    k ^User.DHCPEDelayRecordI
  
    //体检诊室记录
    k ^User.DHCPEAdmRoomRecordD
    k ^User.DHCPEAdmRoomRecordI
    
    //当天报到记录
    k ^User.DHCPECurDateAdmInfoD
    k ^User.DHCPECurDateAdmInfoI
    
   	//高危记录
    k ^User.DHCPEHighRiskDetailI
    k ^User.DHCPEHighRiskResultC
    k ^User.DHCPEHighRiskResultD
    k ^User.DHCPEHighRiskResultI
    
    //预约管理
    k ^User.DHCPEPreManagerD
	k ^User.DHCPEPreManagerI 
	
	//送总检
	k ^User.DHCPESendAuditI
	k ^User.DHCPESendAuditD
	
	//短信
	k ^User.DHCPENewSendMessageD
	k ^User.DHCPENewSendMessageI
	
	//
	k ^User.DHCPEGSSumD
	k ^User.DHCPEGSSumI
	k ^User.DHCPEGSSumS
	
	//体检卡日报表
	k ^User.DHCPECardMonthReportD
	k ^User.DHCPECardMonthReportI
	k ^User.DHCPECardMonthReportS
	
	//分诊记录
	k ^User.DHCPEAdmRoomRecordD
	k ^User.DHCPEAdmRoomRecordI
	k ^User.DHCPEAdmRoomRecordS
	
	
    //采血记录
    k ^DHCPETempLabEpisodeNo
    k ^DHCPETempLabEpisodeScan
    
    
    //收表确认
    k ^DHCPEDataEx("ConfirmRecPaper")
    k ^DHCPEDataEx("DHC_PE_PreIOrdItem")
    k ^DHCPEDataEx("DHCPEResult")
    k ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser")
    k ^DHCPEDataExi("DHCPEPreIADM")
    k ^DHCPEDataExi("DHCPEPreGADM")
    k ^DHCPEDataEx("DHCPEIADM")
    k ^DHCPEDataEx("DHCPEPreIADM")
    K ^DHCPEDataEX("DHCPEGTeamTemplate") //分组存为预置
    k ^DHCPEDataEx("DHCPEPreGADM")
    k ^DHCPEDataEx("InsertRoundFee")  //凑整费记录信息
    k ^DHCPEDataEx("SendRisRequest")
    k ^DHCPECBVIPLevel("PIBI")
    k ^DHCPEHPNoRecord  //体检号计数器
    k ^DHCPEOEITEM  //收费拆分为收费项
    k ^DHCPEConfirmInfo //确认加项
    k ^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor")
    k ^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck") //拒绝项目
    K ^DHCPEDataEx("DHCPESendPACSApplay","OEORDID") //新产品检查申请
    k ^DHCPENetReport //新版打印报告
   
    //取报告
    k ^DHCPEDataEx("FetchReport")
    
     /***********图片上传*********/
    k ^DHCPEDataEx("UpLoadImgNumType")
    k ^DHCPEDataEx("UploadImg")
    k ^DHCPEDataEx("UploadImgInfo")
    k ^DHCPEDataEx("UploadImgDate")
    k ^DHCPEDataEx("UploadImgDelete")
    /*************图片上传*******/
    
    //k ^DHCPESpecialContral("DHCPEXH")
    k ^DHCPESpecial
    
    k ^DHCPEPatItemPrintFlag //导诊单打印的标记
	
	//团体合同  主场设置
	K ^User.DHCPEContractD
	K ^User.DHCPEContractI
	K ^User.DHCPEPreHomeInfoI
	K ^User.DHCPEPreHomeInfoD

    //职业病
	K ^User.DHCPEPreIADMExI
    K ^User.DHCPEPreIADMExD
    k ^User.DHCPEPreIBaseInfoExD
    k ^User.DHCPEPreIBaseInfoExI
    k ^User.DHCPEGeneralSummarizeExI
    k ^User.DHCPEGeneralSummarizeExD
    
    //住院体检
    k ^User.DHCPEOtherPatientToHPI
    k ^User.DHCPEOtherPatientToHPD
    
    //质量管理错误类型上报
    K ^User.DHCPEQualityManagerI
    K ^User.DHCPEQualityManagerD
    
    //体检结果分析指标global
    k ^DHCPEQueryTarget 
    
    //体检结果对比   
	k ^User.DHCPEGSContrastD
	k ^User.DHCPEGSContrastI  
	
	//网上预约记录
	k ^User.DHCPENetPreRecordD 
	k ^User.DHCPENetPreRecordI 

	//医生工作量分配(业务数据) DHC_PE_WorkDistribution
	K ^User.DHCPEWorkDistributionD
	k ^User.DHCPEWorkDistributionI
	
	//调查问卷
	k ^User.DHCHMOBaseInfoD
	k ^User.DHCHMOBaseInfoI
	k ^User.DHCHMOBaseInfoS
	k ^User.DHCHMOEvaluationRecordD
	k ^User.DHCHMOEvaluationRecordI
	k ^User.DHCHMOEvaluationRecordS
	k ^User.DHCHMOQEQuestionD
	k ^User.DHCHMOQEQuestionI
	k ^User.DHCHMOQEQuestionS
	k ^User.DHCHMOQEQuestionC
	k ^User.DHCHMOQResultI
	k ^User.DHCHMOQResultS
	k ^User.DHCHMOQEvaluationI
	k ^User.DHCHMOQEvaluationS
	k ^User.DHCHMOQMedicalTipsI
	k ^User.DHCHMOQMedicalTipsS
	
	k ^DHCPEDataNewEx("HMToPreIADM")
	
	k ^DHCPEDataNewEx("PreIADMToHM")

    k ^DHCPESetting("DHCPE","DefaultPAADM")
    
    //其他
    k ^DHCPE("Url")
    k ^DHCPE("InfoType")
    k ^DHCPEA 
    k ^DHCPEBGYLGetAdmCurRoomErr 
    k ^DHCPECBSpecial 
    k ^DHCPECBVIPLevel 
   
    k ^DHCPECashierTemp 
    
    k ^DHCPECreateSMSID  
    
    k ^DHCPEData
    k ^DHCPEDataEX
    k ^DHCPEDateEx
    k ^DHCPEDataEx
    k ^DHCPEDataExI 
    k ^DHCPEDataExi 
    k ^DHCPEDataNewEx 
    k ^DHCPEDataExNew
     
    k ^DHCPEFactAmount
     
    k ^DHCPEHR 
    k ^DHCPEHRD 
    k ^DHCPEHRDR
     
    k ^DHCPEHighRiskOrder 
    
    k ^DHCPEImportGInfo 
    
    k ^DHCPEItemSort 
    
    k ^DHCPEMarkPis 
    k ^DHCPEMarkPisTemp
     
    k ^DHCPENetReportPage 
    
    k ^DHCPEODA 
    
    k ^DHCPEOEITEMAccAcc 
    k ^DHCPEOEITEMAccAccTemp 
    k ^DHCPEOEITEMTemp
    
    k ^DHCPEOtherPatientToHP 
    
    k ^DHCPEPRT 
    
    k ^DHCPEPreAI
     
    k ^DHCPEPreIADMMark 
    
    k ^DHCPERLTTMP
    
    k ^DHCPERSON 
    
    k ^DHCPERecord 
    
    k ^DHCPERegisterTempData 
   
   
    k ^DHCPETMP
    k ^DHCPETMPChargeStr 
    k ^DHCPETMPContrast 
    k ^DHCPETMPLabEpisode 
    k ^DHCPETMPLocNum 
    k ^DHCPETMPNRData 
    k ^DHCPETMPNormalFlag 
    k ^DHCPETMPOrdSets 
    k ^DHCPETMPPA 
    k ^DHCPETMPRECPAPERData 
    k ^DHCPETMPSendPACSApplay  //检查、检验申请记录
    k ^DHCPETEMPAdviceNew 
     
    k ^DHCPETemp 
    k ^DHCPETempARCIMOrdItem 
    k ^DHCPETempHPNo 
    k ^DHCPETempQuery 
    k ^DHCPETempReport 
    k ^DHCPETmpHadCheck 
    
    k ^DHCPEVIPLevelI
    
    k ^DHCPEWebServiceRecord 
    
    k ^DHCPEXWMTMP 
    
    k ^DHCPEYDTEST 
    
    k ^DHCPETEST 
    
    k ^User.DHCPEPreIADMReplaceD  //个人预约信息替换
	k ^User.DHCPEPreIADMReplaceI
    
    
    //体检操作人员
    k ^CF.PE.SSUserD
    k ^CF.PE.SSUserI
    
    // 项目发生明细记录、到达时项目、加项时项目、停止时项目
    k ^User.DHCPEItemDetailRecordD 
    k ^User.DHCPEItemDetailRecordI
    	
	//保存用户列表设置信息
	k ^User.DHCPEDataGridSetD
	k ^User.DHCPEDataGridSetI
	k ^User.DHCPEDataGridColsSetI
	k ^User.DHCPEDataGridSetC
	
	k ^User.DHCPEGridExportSetD
	k ^User.DHCPEGridExportSetI
	k ^User.DHCPEGridExportColsSetI
	k ^User.DHCPEGridExportSetC
	
	
	//项目预约管理树结构      DHC_PE_ArcimPreTree 
	//项目预约管理树节点条件  DHC_PE_ArcimNodeCondition
	k ^User.DHCPEArcimPreTreeD
	k ^User.DHCPEArcimPreTreeI
	k ^User.DHCPEArcimNodeConditionI
	
	//项目预约限额管理表 DHC_PE_ArcimPreManager
	k ^User.DHCPEArcimPreManagerD
	k ^User.DHCPEArcimPreManagerI
	
    //外出体检
    k ^DHCPESecretPAADM
	k ^DHCPESecretPAADMi
	
	//投诉管理
	k ^User.DHCPEComplainD
    k ^User.DHCPEComplainI
    k ^User.DHCPECompDisposeD
    k ^User.DHCPECompDisposeI
    
    //体检号源管理
	k ^User.DHCPESourceManagerD 
	k ^User.DHCPESourceManagerI
	k ^User.DHCPESourceTimeManagerI
	k ^User.DHCPESourceTimeTemplateI
	k ^User.DHCPESourceTimeVIPManagerI
	k ^User.DHCPESourceTVIPTemplateI
	 
	k ^User.DHCPESourceTemplateD
    k ^User.DHCPESourceTemplateI
    
    //服务调用日志
    k ^User.DHCPESrvLogD
    k ^User.DHCPESrvLogI
	
	//电子签名 
	k ^User.DHCPECASignLogD 
    k ^User.DHCPECASignLogI
    k ^User.DHCPECAHandSignLogD 
    k ^User.DHCPECAHandSignLogI

    w "清理体检业务数据完成！"
}

/// *************************************************************************************************************
/// *********************************以下代码为临时清标库数据方法************************************************
/// *********************************      没事不要随便执行      ************************************************
/// *********************************         总共四部分         ************************************************
/// *********************************     第一部分：基础数据     ************************************************
/// *********************************     第二部分：配置数据     ************************************************
/// *********************************     第三部分：业务数据     ************************************************
/// *********************************     第四部分：手工处理     ************************************************
/// *************************************************************************************************************
ClassMethod ClearPECTCFData()
{
	//*******************************************第一部分：基础数据*******************************************
	//清掉站点、站点分类、站点大项、站点细项、站点细项选择
	k ^DHCPEST

	//问卷问题维护 DHC_HM_CQuestionsDetail
	k ^User.DHCHMCQuestionsDetailD
	k ^User.DHCHMCQuestionsDetailI

	//问卷问题选项维护 DHC_HM_CQDOptions
	//k ^User.DHCHMCQuestionsDetailD 父子表
	k ^User.DHCHMCQuestionsDetailC("QDOptions")
	k ^User.DHCHMCQDOptionsI

	//问卷量表(主题)定义 DHC_HM_CQDSubject
	//问卷量表(主题)与问题关联表 DHC_HM_CQDSubjectDtl
	k ^CT.PE.HM.CQDSubjectD
	k ^CT.PE.HM.CQDSubjectI

	//问卷评估内容维护 DHC_HM_CEvaluationDetail
	k ^User.DHCHMCEvaluationDetailD
	k ^User.DHCHMCEvaluationDetailI

	//问卷评估内容与问题关联表 DHC_HM_EvaluationLinkDetail
	k ^User.DHCHMEvaluationLinkDetailD
	k ^User.DHCHMEvaluationLinkDetailI

	//问卷评估内容与问题选项关联表 DHC_HM_EvaluationLinkOption
	//k ^User.DHCHMEvaluationLinkDetailD 父子表
	k ^User.DHCHMEvaluationLinkOptionC("ELDOption")
	k ^User.DHCHMEvaluationLinkOptionI

	//问卷提示类型  DHC_HM_InquiryType
	k ^User.DHCHMInquiryTypeD
	k ^User.DHCHMInquiryTypeI

	//问卷提示结果 DHC_HM_InquiryResult
	//k ^User.DHCHMInquiryTypeD
	k ^User.DHCHMInquiryTypeC("ITResult")
	k ^User.DHCHMInquiryResultI

	//问卷提示结果详细说明 DHC_HM_InquiryResultDetail
	//k ^User.DHCHMInquiryTypeD
	k ^User.DHCHMInquiryResultC("IRDetail")
	k ^User.DHCHMInquiryResultDetailI

	//问卷提示结果与问题关联表 DHC_HM_InquiryQuesRelate  
	k ^User.DHCHMInquiryQuesRelateD
	k ^User.DHCHMInquiryQuesRelateI

	//问卷提示结果与问题选项关联表 DHC_HM_InquiryOptionRelate
	//k ^User.DHCHMInquiryQuesRelateD
	k ^User.DHCHMInquiryQuesRelateC("IQROption")
	k ^User.DHCHMInquiryOptionRelateI

	//*******************************************第二部分：配置数据*******************************************
	//表记录授权管理 DHC_PE_PowerControl
	k ^CF.PE.PowerControlD  
	k ^CF.PE.PowerControlI

	//基础表公用更新日志表 DHC_PE_CTUpdateLog
	k ^CF.PE.CTUpdateLogD
	k ^CF.PE.CTUpdateLogI

	//科室站点详情表 DHC_PE_StationSet
	k ^CF.PE.StationSetD
	k ^CF.PE.StationSetI

	//科室站点分类序号表 DHC_PE_StationOrdCatSort
	//科室站点项目序号表 DHC_PE_StationOrderSort
	k ^CF.PE.StationOrdSortD
	k ^CF.PE.StationOrdSortI

	//科室站点项目扩展表 DHC_PE_StationOrderSet
	k ^CF.PE.StationOrderSetD
	k ^CF.PE.StationOrderSetI

	//科室站点细项扩展表 DHC_PE_OrderDetailSet
	K ^CF.PE.OrderDetailSetD
	k ^CF.PE.OrderDetailSetI

	//科室站点大项细项组合表 DHC_PE_OrderDetailRelate
	k ^DHCPEODR

	//科室排斥项目维护表 DHC_PE_ExcludeArcItem
	k ^User.DHCPEExcludeArcItemD
	k ^User.DHCPEExcludeArcItemI

	//建议级别表 DHC_PE_EDClass
	k ^DHCPEEDC

	//疾病维护表 DHC_PE_IllnessStandard
	k ^DHCPEILLS

	//疾病别名表 DHC_PE_ILLSAlias
	k ^DHCPEILLSA

	//疾病关联疾病解释表 DHC_PE_ILLSExplain
	k ^CF.PE.ILLSExplainD
	k ^CF.PE.ILLSExplainI

	//疾病关联运动指导表 DHC_PE_ILLSSportGuide
	k ^CF.PE.ILLSSportGuideD
	k ^CF.PE.ILLSSportGuideI

	//疾病关联饮食指导表 DHC_PE_ILLSDietGuide
	k ^CF.PE.ILLSDietGuideD
	k ^CF.PE.ILLSDietGuideI
	
    //职业健康处理意见 DHC_PE_HandlingOpinions
    k ^User.DHCPEHandlingOpinionsD
    k ^User.DHCPEHandlingOpinionsI
    
	//由于^User.DHCPEEndangerD既有基础数据,又有配置数据,所以用sql删除
	//危害因素关联检查周期 DHC_PE_EDItem
	&sql(delete from DHC_PE_EDItem)
	
	//危害因素关联检查细项 DHC_PE_EDItemDetail
	&sql(delete from DHC_PE_EDItemDetail)
	
	//体检医嘱扩展    DHC_PE_ItemExtend
	//自定义价格医嘱  DHC_PE_IEPrice
	//体检赠送项目    DHC_PE_IESendItem
	k ^DHCPEIE  
	
	//体检医生维护 DHC_PE_ChartAssign
	//体检医生站点权限 DHC_PE_ChartAssignDtl
	k ^CF.PE.ChartAssignD
	k ^CF.PE.ChartAssignI
	
	//体检收费权限维护 DHC_PE_ChargeLimit
	k ^CF.PE.ChargeLimitD
	k ^CF.PE.ChargeLimitI
	
	//特殊项目权限维护 DHC_PE_SpecialContral
	k ^CF.PE.SpecialContralD
	k ^CF.PE.SpecialContralI
	
	//会诊费收费设置 DHC_PE_OthPatToHPBase
	k ^CF.PE.OthPatToHPBaseD
	k ^CF.PE.OthPatToHPBaseI
	
	//服务级别关联问卷表 DHC_HM_CSCQLink
	//k ^User.DHCHMCServiceClassD
	k ^User.DHCHMCServiceClassC
	k ^User.DHCHMCSCQLinkI
	
	//服务级别表 DHC_HM_CServiceClass
	k ^User.DHCHMCServiceClassD
	k ^User.DHCHMCServiceClassI
	
	//服务级别关联问卷表 DHC_HM_CSCQLink
	//k ^User.DHCHMCServiceClassD
	k ^User.DHCHMCServiceClassC
	k ^User.DHCHMCSCQLinkI
	
	//调查问卷主表 DHC_HM_CQuestionnaire
	k ^User.DHCHMCQuestionnaireD
	k ^User.DHCHMCQuestionnaireI
	
	//调查问卷主题表 DHC_HM_CQuestionSubject
	//k ^User.DHCHMCQuestionnaireD
	k ^User.DHCHMCQuestionnaireC("QSubject")
	k ^User.DHCHMCQuestionSubjectI
	
	//调查问卷与评估内容关联表 DHC_HM_CQEDLink
	//k ^User.DHCHMCQuestionnaireD
	k ^User.DHCHMCQuestionnaireC("QEDLink")
	k ^User.DHCHMCQEDLinkI
	
	//调查问卷主题与问题关联表 DHC_HM_CSDLink
	//k ^User.DHCHMCQuestionnaireD
	k ^User.DHCHMCQuestionSubjectC("QSDLink")
	k ^User.DHCHMCSDLinkI
	
	//问卷关联体检套餐维护 DHC_HM_OrdSetsLink
	k ^User.DHCHMOrdSetsLinkD
	k ^User.DHCHMOrdSetsLinkI
	
	//问卷套餐与问卷问题关联表 DHC_HM_OrdSetsQDetail
	//k ^User.DHCHMOrdSetsLinkD
	k ^User.DHCHMOrdSetsLinkC("OLDetail")
	k ^User.DHCHMOrdSetsQDetailI
	
	//问卷套餐与问卷问题选项关联表 DHC_HM_OrdSetsQDOption
	//k ^User.DHCHMOrdSetsLinkD
	k ^User.DHCHMOrdSetsQDetailC("OLOption")
	k ^User.DHCHMOrdSetsQDOptionI
	
	//*******************************************第三部分：业务数据*******************************************
	d ##class(web.DHCPE.CT.Public.Setting).KillPECBGlobal()
	
	//*******************************************第四部分：手工处理*******************************************
	//4.1表登记授权管理 DHC_PE_PowerTableList
	//重新导入Global，地址：\01-体检系统\数据\基础数据\01-表登记授权管理\表登记授权管理-GBL\*
	
	//4.2导入标准站点和站点分类
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\00-1-站点代码表.xlsx
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\00-2-站点分类代码表.xlsx
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\00-3-职业健康处理意见.xlsx
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\00-4-建议级别字典.xlsx
	//管控数据，需要页面授权下
	
	//4.3同步细项、专家建议、疾病，权限同步导入
	//152体检中心，关联协和知识库
	//命令：w ##class(web.DHCPE.KBA.SynchroService).SynchroOrderDetail(152,"U01110001")
	//命令：w ##class(web.DHCPE.KBA.SynchroService).SynchroDiagnos(152,"U01110001")
	//命令：w ##class(web.DHCPE.KBA.SynchroService).SynchroDisease(152,"U01110001")
	//388体检中心[口腔]，关联同仁知识库
	//命令：w ##class(web.DHCPE.KBA.SynchroService).SynchroOrderDetail(388,"U01110003")
	//命令：w ##class(web.DHCPE.KBA.SynchroService).SynchroDiagnos(388,"U01110003")
	//命令：w ##class(web.DHCPE.KBA.SynchroService).SynchroDisease(388,"U01110003")
	
	//4.4职业健康处理意见，数据不清，需要重新授权[私有，写个单独更新方法]
	//职业健康处理意见，私有数据；授权给152,388重新手工维护
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\00-3-职业健康处理意见.xlsx
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\JS导入：00-3-职业健康处理意见.js
	
	//4.5建议级别，根据协和的数据整理一个Excel表，写程序导入
	//建议级别私有数据；授权给152,388重新手工维护
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\00-4-建议级别字典.xlsx
	//重新导入Excel，地址：\03-健康管理系统\数据\01-健康体检知识库\01-基础知识库\JS导入：00-4-建议级别字典.js
	
	//4.6诊区、诊室维护数据不清，需要重新授权和与站点对照[绝对私有，写个单独更新方法]
	//只有诊区需要授权，诊区是绝对私有数据，根据表中科室授权
	//命令：w ##class(web.DHCPE.CT.Public.Setting).toAreaPowerCtrl(1)
	
	//4.7问卷重新维护后，科室VIP等级需要重新关联问卷
	
	//4.8其他都手工配置
	
	Quit "执行完之后，请手工一步步执行第四部分内容"
}

/// 处理诊区授权记录，DHC_PE_Area--绝对私有
ClassMethod toAreaPowerCtrl(aUserID As %String) As %String
{
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEAreaD(xId))
		q:xId=""
		q:return'=""
		
		s objArea=##class(User.DHCPEArea).%OpenId(xId)
		continue:'$IsObject(objArea)
		d objArea.%Close()
		s LocID=objArea.ALocDR
		continue:LocID=""
		
		s ID=xId
		s flg=##class(User.DHCPEArea).SaveDataToPowerControl(ID,LocID,aUserID)
		if (+flg)<1 {
			s return="-1^诊区授权记录"
		}
	}
	q return
}

}
