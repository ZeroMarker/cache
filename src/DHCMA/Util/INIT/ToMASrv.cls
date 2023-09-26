/// 名称: DHCMA.Util.INIT.ToMASrv
/// 描述: 医疗质量产品（MA）初始化程序
/// 编写者：zhufei
/// 编写日期: 2020-04-14
Class DHCMA.Util.INIT.ToMASrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 清临床路径管理（CPW）业务数据
ClassMethod ClearCPWBusiness()
{
	Kill ^DHCMA.CPW.CP.PathwayD
	Kill ^DHCMA.CPW.CP.PathwayI
	Kill ^DHCMA.CPW.CP.PathwayVisitD
	Kill ^DHCMA.CPW.CP.PathwayVisitI
	Kill ^DHCMA.CPW.CP.PathwayEpisRevokeD
	Kill ^DHCMA.CPW.CP.PathwayEpisRevokeI
	Kill ^DHCMA.CPW.CP.PatStsSvyD
	Kill ^DHCMA.CPW.CP.PatStsSvyI
	Kill ^DHCMA.CPW.STA.DataResultsD
	Kill ^DHCMA.CPW.STA.DataResultsI
	Kill ^DHCMA.CPW.STA.MonthDischDataD
	Kill ^DHCMA.CPW.STA.MonthDischDataI
	Do ..DelCASignData("CPW")		//住院路径CA认证日志
	Do ..DelCASignData("OPCPW")		//门诊路径CA认证日志
	
	Quit "OK"
}

/// 清临床路径管理（CPW）配置数据
ClassMethod ClearCPWConfig()
{
	Kill ^DHCMA.CPW.BT.PathAdmitD	
	Kill ^DHCMA.CPW.BT.PathAdmitI
		
	Kill ^DHCMA.CPW.BT.PathComplD	
	Kill ^DHCMA.CPW.BT.PathComplI
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathCompl")
		
	Kill ^DHCMA.CPW.BT.PathEntityD	
	Kill ^DHCMA.CPW.BT.PathEntityI
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathEntity")
		
	Kill ^DHCMA.CPW.BT.PathFormD	
	Kill ^DHCMA.CPW.BT.PathFormI
		
	Kill ^DHCMA.CPW.BT.PathItemCatD	
	Kill ^DHCMA.CPW.BT.PathItemCatI
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathItemCat")
		
	Kill ^DHCMA.CPW.BT.PathLocD	        //科室常用路径
	Kill ^DHCMA.CPW.BT.PathLocI
		
	Kill ^DHCMA.CPW.BT.PathMastD	
	Kill ^DHCMA.CPW.BT.PathMastI
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathMast")
	
	Kill ^DHCMA.CPW.BT.PathOrdGroupD
	Kill ^DHCMA.CPW.BT.PathOrdGroupI
		
	Kill ^DHCMA.CPW.BT.PathTCMD	
	Kill ^DHCMA.CPW.BT.PathTCMI
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathTCM")
		
	Kill ^DHCMA.CPW.BT.PathTCMOSD	
	Kill ^DHCMA.CPW.BT.PathTCMOSI
		
	Kill ^DHCMA.CPW.BT.PathTypeD	
	Kill ^DHCMA.CPW.BT.PathTypeI
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathType")
		
	Kill ^DHCMA.CPW.BT.PathVarCatD	
	Kill ^DHCMA.CPW.BT.PathVarCatI
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathVarCat")
		
	Kill ^DHCMA.CPW.BT.PathVariatD	
	Kill ^DHCMA.CPW.BT.PathVariatI	
	Do ..DeleteBDPMappingHosp("DHCMA_CPW_BT.PathVariat")
	
	Kill ^DHCMA.CPW.BT.BudgetCostD			// 费用测算
	Kill ^DHCMA.CPW.BT.BudgetCostI
	
	Kill ^DHCMA.CPW.BT.PathExamRoleD		// 发布审核角色
	Kill ^DHCMA.CPW.BT.PathExamRoleI
	
	Kill ^DHCMA.CPW.BT.ApplyExamRecD		// 发布申请
	Kill ^DHCMA.CPW.BT.ApplyExamRecI
	
	Kill ^DHCMA.CPW.BT.SurveyD				// 调查表维护数据
	Kill ^DHCMA.CPW.BT.SurveyI
	
	Kill ^DHCMA.CPW.BT.PathWebCreateD		// 图形化创建路径日志
	Kill ^DHCMA.CPW.BT.PathWebCreateI
	
	Kill ^DHCMA.CPW.LOG.LogTableD			//清理临床路径日志数据
	Kill ^DHCMA.CPW.LOG.LogTableI
	
	&sql(delete DHCMA_CPW_BT.PathFormOrd)	//关联医嘱
	&sql(delete DHCMA_CPW_BT.PathFormMR)	//关联病历
	&sql(delete DHCMA_CPW_BT.PathFormTCM)	//关联自定义方剂
	
	//Kill ^DHCMA.CPW.KB.PathBaseD			//国家路径相关数据，此为通用数据无需清理
	//Kill ^DHCMA.CPW.KB.PathBaseI
	//Kill ^DHCMA.CPW.KB.ClinItemBaseD
	//Kill ^DHCMA.CPW.KB.ClinItemBaseI
	//Kill ^DHCMA.CPW.KB.NurItemBaseD
	//Kill ^DHCMA.CPW.KB.NurItemBaseI
	//Kill ^DHCMA.CPW.KB.OrdItemBaseD
	//Kill ^DHCMA.CPW.KB.OrdItemBaseI

	Quit "OK"
}

/// 清单病种（SD）业务数据
ClassMethod ClearSDBusiness()
{
	K ^DHCMA.CPW.SD.QCOptionMatchD
	K ^DHCMA.CPW.SD.QCOptionMatchI
	//标准抗菌药与HIS医嘱项对照
	K ^DHCMA.CPW.SDMatch.AntiItemMatchD
	K ^DHCMA.CPW.SDMatch.AntiItemMatchI
	//入组记录，表单执行记录
	K ^DHCMA.CPW.SD.QCMrListD
	K ^DHCMA.CPW.SD.QCMrListI
	K ^DHCMA.CPW.SD.QCItemExecI
	K ^DHCMA.CPW.SD.QCMrListStateI
	K ^DHCMA.CPW.SD.QCMrStateAliasI
	Do ..DelCASignData("SD")		//CA认证日志
	
	Quit "OK"
}

/// 清单病种（SD）配置数据
ClassMethod ClearSDConfig()
{
	/*
	K ^DHCMA.CPW.SD.PCEntityD	    //按病种付费病种  		    
	K ^DHCMA.CPW.SD.PCEntityI	                    
	K ^DHCMA.CPW.SD.PCItemCatD	    //病种框架 项目分类 
	K ^DHCMA.CPW.SD.PCItemCatI	  	
	K ^DHCMA.CPW.SD.PCItemEpisD	    //病种框架 项目阶段	
	K ^DHCMA.CPW.SD.PCItemEpisI		 
	K ^DHCMA.CPW.SD.PCPriceMastD    //医疗服务价格项目规范	
	K ^DHCMA.CPW.SD.PCPriceMastI
	K ^DHCMA.CPW.SD.QCEntityC       //特定（单）病种质量控制 病种定义 	
	K ^DHCMA.CPW.SD.QCMrListD	    //质控病种病历列表	
	K ^DHCMA.CPW.SD.QCMrListI	   
	K ^DHCMA.CPW.SD.QCMrListStateI  //质控病种病历列表状态记录
	*/
	Quit "OK"
}

/// 清单病种（SD）基础数据
ClassMethod ClearSDCodeTable()
{
	
	//值域字典标准抗菌药对照
	K ^DHCMA.CPW.SD.QCOptionMatchAntiD
	K ^DHCMA.CPW.SD.QCOptionMatchAntiI	
	
	//病种项目值域字典
	K ^DHCMA.CPW.SD.DicTypeD
	K ^DHCMA.CPW.SD.DicTypeI
	K ^DHCMA.CPW.SD.DictionaryD
	K ^DHCMA.CPW.SD.DictionaryI
	K ^DHCMA.CPW.SD.QCEntityD               //特定（单）病种质量控制 病种定义
	K ^DHCMA.CPW.SD.QCEntityI
	K ^DHCMA.CPW.SD.QCEntityItemI
	K ^DHCMA.CPW.SD.QCEntityMatchRuleI
	//单病种表达式维护
	K ^DHCMA.CPW.SD.QCExpressD
	K ^DHCMA.CPW.SD.QCExpressI
	
	K ^DHCMA.CPW.SD.QCIndexI
	//标准抗菌药物
	K ^DHCMA.CPW.SDMatch.AnticatD
	K ^DHCMA.CPW.SDMatch.AnticatI
	K ^DHCMA.CPW.SDMatch.AntiItemD
	K ^DHCMA.CPW.SDMatch.AntiItemI
		
	Quit "OK"
}

/// 清慢阻肺（COP）业务数据
ClassMethod ClearCOPBusiness()
{
	Kill ^DHCMA.COP.IR.ReportD
	Kill ^DHCMA.COP.IR.ReportI
	Do ..DelCASignData("COP")		//CA认证日志
	
	Quit "OK"
}

/// 清医疗质量（MA）业务数据
ClassMethod ClearMABusiness()
{
	Kill ^DHCMA.Util.EPx.EpisodeD      //就诊列表
	Kill ^DHCMA.Util.EPx.EpisodeI

	Kill ^DHCMA.Util.EPx.EpisQueueD    //就诊队列表
	Kill ^DHCMA.Util.EPx.EpisQueueI
	Do ..DelCASignData("MA")		//CA认证日志
    
	Quit "OK"
}

/// 清医疗质量（MA）配置数据
ClassMethod ClearMAConfig()
{
	Kill ^DHCMA.Util.BT.ConfigD      //系统参数配置
	Kill ^DHCMA.Util.BT.ConfigI
	
	Kill ^DHCMA.Util.BT.HospGroupD   //医院分组
	Kill ^DHCMA.Util.BT.HospGroupI 

	Kill ^DHCMA.Util.BT.MdlPowerD    //模块操作权限
	Kill ^DHCMA.Util.BT.MdlPowerI
	
	Kill ^DHCMA.Util.BT.SYSTEMD      //HIS应用系统
	Kill ^DHCMA.Util.BT.SYSTEMI
	
    //*******************  在进入项目后一定要清理后重新同步
	Kill ^DHCMA.Util.EPx.CareProvD    //医护人员
	Kill ^DHCMA.Util.EPx.CareProvI

	Kill ^DHCMA.Util.EPx.DictionaryD   //HIS基础字典
	Kill ^DHCMA.Util.EPx.DictionaryI

	Kill ^DHCMA.Util.EPx.HospitalD     //医院表
	Kill ^DHCMA.Util.EPx.HospitalI
	 
	Kill ^DHCMA.Util.EPx.LocationD     //科室表
	Kill ^DHCMA.Util.EPx.LocationI 
	 
	Kill ^DHCMA.Util.EPx.OrdMastD      //医嘱项表
	Kill ^DHCMA.Util.EPx.OrdMastI

	Kill ^DHCMA.Util.EPx.SpecimenD     //送检标本表
	Kill ^DHCMA.Util.EPx.SpecimenI

	Kill ^DHCMA.Util.EPx.SSGroupD      //安全组表
	Kill ^DHCMA.Util.EPx.SSGroupI

	Kill ^DHCMA.Util.EPx.SSUserD       //用户表
	Kill ^DHCMA.Util.EPx.SSUserI
	 
	Kill ^DHCMA.Util.EPx.TestCodeD     //检验项目表
	Kill ^DHCMA.Util.EPx.TestCodeI

	Kill ^DHCMA.Util.EPx.TestSetD      //检验医嘱表
	Kill ^DHCMA.Util.EPx.TestSetI

	Kill ^DHCMA.Util.EPx.TestSetTCD    //检验医嘱与检验项目关联表
	Kill ^DHCMA.Util.EPx.TestSetTCI
	
	Kill ^DHCMA.Util.EPx.AppPartD      // 检查部位表
	Kill ^DHCMA.Util.EPx.AppPartI
	
	Kill ^DHCMA.Util.EPx.AppArcLinkD   // 检查医嘱与检查部位关联表
	Kill ^DHCMA.Util.EPx.AppArcLinkI

	Kill ^CF.MA.Util.BT.DictionaryMapD  //基础字典对照表
	Kill ^CF.MA.Util.BT.DictionaryMapI
	
	
	Kill ^CF.MA.Util.BT.AreaIODictionaryD  //接口地址字典
	Kill ^CF.MA.Util.BT.AreaIODictionaryI
	
	Kill ^CF.MA.Util.BT.AreaIOMappingD  //对照地址字典
	Kill ^CF.MA.Util.BT.AreaIOMappingI
	//*******************  上线前清理
	
	Quit "OK"
}

/// 清医疗质量（MA）基础数据
ClassMethod ClearMACodeTable()
{
	Kill ^DHCMA.Util.BT.DicTypeD     //字典分类
	Kill ^DHCMA.Util.BT.DicTypeI

	Kill ^DHCMA.Util.BT.DictionaryD  //系统字典
	Kill ^DHCMA.Util.BT.DictionaryI
	Do ..DeleteBDPMappingHosp("DHCMA_Util_BT.Dictionary")

	Kill ^DHCMA.Util.BT.MdlDefD      //系统模块定义
	Kill ^DHCMA.Util.BT.MdlDefI  
	
	Kill ^DHCMA.Util.BT.ProductD     //产品线定义
	Kill ^DHCMA.Util.BT.ProductI
			
	Kill ^CT.MA.Util.BT.DicTypeMapD     //基础字典类型对照表
	Kill ^CT.MA.Util.BT.DicTypeMapI
	
	Kill ^CT.MA.Util.BT.DeleteControlD     //基础字典删除权限控制表
	Kill ^CT.MA.Util.BT.DeleteControlI
	
	//临床路径国家路径库相关Global
	Kill ^CT.MA.CPW.KB.PathBaseD
	Kill ^CT.MA.CPW.KB.PathBaseI
	
	Quit "OK"
}

/// 清重点患者管理（IMP）业务数据
ClassMethod ClearIMPBusiness()
{
	;"重点患者筛查记录"
	K ^MA.IMP.IPIMPRecordD
	K ^MA.IMP.IPIMPRecordI
	;重点患者登记主表
	K ^MA.IMP.IPIMPRegisterD
	K ^MA.IMP.IPIMPRegisterI
	;"重点患者登记表"
	K ^MA.IMP.IPCriticalIllRegD
	K ^MA.IMP.IPCriticalIllRegI
	K ^MA.IMP.IPLangHospRegD
	K ^MA.IMP.IPLangHospRegI
	K ^MA.IMP.IPOperCompRegD
	K ^MA.IMP.IPOperCompRegI
	K ^MA.IMP.IPURTHospRegD
	K ^MA.IMP.IPURTHospRegI
	K ^MA.IMP.IPURTOperRegD
	K ^MA.IMP.IPURTOperRegI
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("IMP")		//CA认证日志
	
	Quit "OK"
}

/// 清重点患者管理（IMP）配置数据
ClassMethod ClearIMPConfig()
{
	Kill ^CT.MA.IMP.BTIMPCategoryD
	Kill ^CT.MA.IMP.BTIMPCategoryI
	Kill ^CT.MA.IMP.BTIMPKeywordD
	Kill ^CT.MA.IMP.BTIMPKeywordI
	Kill ^CT.MA.IMP.BTIMPReasonDicD
	Kill ^CT.MA.IMP.BTIMPReasonDicI
	Kill ^CT.MA.IMP.BTOperCompDicD
	Kill ^CT.MA.IMP.BTOperCompDicI
	Kill ^CT.MA.IMP.BTOperCompLvLD
	Kill ^CT.MA.IMP.BTOperCompLvLI
		
	Quit "OK"
}

/// 清除平台多院区关联数据
/// w ##class(DHCMA.Util.INIT.ToMASrv).DeleteBDPMappingHosp("DHCMA_CPW_BT.PathCompl")
ClassMethod DeleteBDPMappingHosp(aTableName As %String) As %String
{
	&SQL(DELETE FROM SQLUser.BDP_MappingHosp WHERE BDPMPH_TableName=:aTableName)
	Quit SQLCODE
}

/// 清除CA认证本组下业务数据（DHCMed.CA.SignVerify)
/// w ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("")
ClassMethod DelCASignData(aProType As %String) As %String
{
	Quit:aProType="" "-1"
	&SQL(DELETE FROM DHCMed_CA.SignVerify WHERE SVProductCode=:aProType)
	Quit SQLCODE
}

}
