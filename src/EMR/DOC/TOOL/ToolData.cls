/// 名称:	EMR.DOC.TOOL.ToolData
/// 描述:	通用文档管理模块 Document(Doc) 通用文档数据工具类
/// 编写者:	yejian
/// 编写日期: 	2023-4-20
/// 产品组：	电子病历产品组
Class EMR.DOC.TOOL.ToolData Extends %RegisteredObject
{

/// Creator：      yejian
/// CreatDate：    2023-4-20
/// Description:   清除BS版电子病历业务数据 EMR.DB.*
/// Table：        
/// Input：        
/// Output         
/// Return：       
/// Others：       
/// Debug:         d ##Class(EMR.DOC.TOOL.ToolData).KillEMRInstanceData()	
ClassMethod KillEMRInstanceData()
{
	w "删除BS版电子病历产品组业务数据 EMR.DB.* ",!
	w "注意:确认操作的数据库是否是 正式环境！",!
	r "是否继续: 是(y) 否(n) ",flag
	if ($zcvt(flag,"U")= "Y")
	{	
		// 全局图表
		k ^EMR.GB.GlobalDataD
		k ^EMR.GB.GlobalDataI
		
		// 数据路由表
		k ^EMR.GB.RouterI
		k ^EMR.GB.RouterD
		
		// 日志表
		k ^EMR.DB.DocLogD
		k ^EMR.DB.DocLogI
		
		// 医护签数据
		k ^EMR.DB.DoctorSignStreamI
		k ^EMR.DB.DoctorSignStreamD
		k ^EMR.DB.DoctorSignStreamS
		
		// 文档表
		k ^EMR.DB.DocumentDataD
		k ^EMR.DB.DocumentDataI
		k ^EMR.DB.DocumentStreamD
		k ^EMR.DB.DocumentStreamI
		k ^EMR.DB.DocumentStreamS
		
		// 打印记录
		k ^EMR.DB.DocumentPrintRecordI
		k ^EMR.DB.DocumentPrintRecordD
		
		// 病程记录中选择的医师信息
		k ^EMR.DB.DocumentTitleDoctorI
		k ^EMR.DB.DocumentTitleDoctorD
		
		// 转科当前科室
		k ^EMR.DB.EMRDeptI
		k ^EMR.DB.EMRDeptD
		
		// 签名表
		k ^EMR.DB.EMRSignD
		k ^EMR.DB.EMRSignI
		k ^EMR.DB.EMRSignLogD
		k ^EMR.DB.EMRSignLogI
		
		// 医学公式打散表
		k ^EMR.DB.IStructMacroD
		k ^EMR.DB.IStructMacroI
		k ^EMR.DB.IStructMacroS
		k ^EMR.DB.IStructMacroSimpleD
		k ^EMR.DB.IStructMacroSimpleI
		
		// 章节打散
		k ^EMR.DB.IStructSectionD
		k ^EMR.DB.IStructSectionI
		k ^EMR.DB.IStructSectionS
		
		// 简单元素打散
		k ^EMR.DB.IStructSimpleD
		k ^EMR.DB.IStructSimpleI
		
		// 牙位打散
		k ^EMR.DB.IStructToothD
		k ^EMR.DB.IStructToothI
		k ^EMR.DB.IStructToothPositionD
		k ^EMR.DB.IStructToothPositionI
		k ^EMR.DB.IStructToothSurfaceD
		k ^EMR.DB.IStructToothSurfaceI
		
		// 患者签
		k ^EMR.DB.PatientSignD
		k ^EMR.DB.PatientSignS
		k ^EMR.DB.PatientSignStreamD
		k ^EMR.DB.PatientSignStreamI
		k ^EMR.DB.PatientSignStreamS
		
		// PDF签
		k ^EMR.DB.PDFAuditSignLogI
		k ^EMR.DB.PDFAuditSignLogD
		k ^EMR.DB.PDFAuditSignLogS
		
		// 同步数据配置
		k ^EMR.DB.SynDataConfigD
		k ^EMR.DB.SynDataConfigI

		W !, "数据 ^EMR.DB.*  清除完成！"
		
		//清除生成顺序递增的唯一编码的临时global
		//K ^Tempc0
		//K ^Tempc1
		//W !, "数据 EMRmeta.UserPageConfig 清除完成！"
		
	}
	else
	{
		W !, "取消操作！"
	}
	q
}

/// Creator：      yejian
/// CreatDate：    2023-4-20
/// Description:   清除BS版电子病历科室安全组配置数据 CF.EMR.DOC
/// Table：        
/// Input：        
/// Output         
/// Return：       
/// Others：       
/// Debug:         d ##Class(EMR.DOC.TOOL.ToolData).KillEMRCTlocGroupData()	
ClassMethod KillEMRCTlocGroupData()
{
	w "删除BS版电子病历产品组配置数据 CF.EMR.DOC.* ",!
	w "注意:确认操作的数据库是否是 正式环境！",!
	r "是否继续: 是(y) 否(n) ",flag
	if ($zcvt(flag,"U")= "Y")
	{	
		// 导航分组科室配置
		k ^CF.EMR.DOC.EMRTSchemeGroupCTI
		k ^CF.EMR.DOC.EMRTSchemeGroupCTD
		
		// 导航项目科室关联
		k ^CF.EMR.DOC.EMRTSchemeItemResI
		k ^CF.EMR.DOC.EMRTSchemeItemResD
		
		// 导航安全组关联
		k ^CF.EMR.DOC.EMRTSchemeISSGI
		k ^CF.EMR.DOC.EMRTSchemeISSGD
		
		// 病历分组科室关联
		k ^CF.EMR.DOC.EMRTemGroupLocI
		k ^CF.EMR.DOC.EMRTemGroupLocD

		// 病历引用配置
		k ^CF.EMR.DOC.QuotationSchemeI
		k ^CF.EMR.DOC.QuotationSchemeD
		
		// 模板规则
		k ^CF.EMR.DOC.TemplateRulesI
		k ^CF.EMR.DOC.TemplateRulesD
		
		// 科室模板规则
		k ^CF.EMR.DOC.LocTemplateRulesI
		k ^CF.EMR.DOC.LocTemplateRulesD
		
		// 片段科室关联
		&sql(update CF_EMR_DOC.KBCategory set CTLoc = NULL)


		W !, "数据 ^CF.EMR.DOC.*  清除完成！"
		
	}
	else
	{
		W !, "取消操作！"
	}
	q
}

}
