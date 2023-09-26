/// 名称: DHCMA.Util.INIT.ToMedSrv
/// 描述: 医务管理产品（Med）初始化程序
/// 编写者：zhufei
/// 编写日期: 2020-04-14
Class DHCMA.Util.INIT.ToMedSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 清传染病管理（EPD）业务数据
ClassMethod ClearEPDBusiness()
{
	Kill ^DHCMed.EPD("EPD")                //传染病报告
	Kill ^DHCMed.EPDi("EPD")
	Kill ^DHCMed.EPD("CasesX")              //传染病例筛查日志
	Kill ^DHCMed.EPDi("CasesX") 
	Kill ^DHCMed.EPD.CasesXI	            //传染病例筛查明细  
	
	Kill ^DHCMed.EPD.CaseFollowD	        //HIV个案调查        
	Kill ^DHCMed.EPD.CaseFollowI	                    	         
	Kill ^DHCMed.EPD.ERReportILID	        //流感样病历标本登记卡信息     
	Kill ^DHCMed.EPD.ERReportILII	       
	Kill ^DHCMed.EPD.ERReportILIC	        //流感样病历日志信息 	
	Kill ^DHCMed.EPD.ReferralRepD	        //肺结核转诊单      
	Kill ^DHCMed.EPD.ReferralRepI	        
	Kill ^DHCMed.EPD.ReportNo	            //流感样、肺结核转诊单编号    
	
	Kill ^DHCMed.EPD.NCPInvestigationD	    //新冠肺炎个案调查
	Kill ^DHCMed.EPD.NCPInvestigationI	
	Kill ^DHCMed.EPD.NCPCardNoC	            //新冠肺炎个案调查编号
	
	Kill ^MA.EPD.ImportReportD           //历史导入数据
	Kill ^MA.EPD.ImportReportI
	
	Kill ^DHCMed.EPDService.AutoTask
	
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("EPD")		//CA认证日志
	
	Quit "OK"
}

/// 清传染病管理（EPD）配置数据
ClassMethod ClearEPDConfig()
{
	Kill ^DHCMed.EPD.SuspInfectDicD	    
	Kill ^DHCMed.EPD.SuspInfectDicI	    
	Kill ^DHCMed.EPD.SuspScreeningD	    
	Kill ^DHCMed.EPD.SuspScreeningI	    
	Kill ^DHCMed.EPD.SuspTestCodeD	    
	Kill ^DHCMed.EPD.SuspTestCodeI
		
	Quit "OK"
}

/// 清传染病管理（EPD）基础数据
ClassMethod ClearEPDCodeTable()
{
	Kill ^DHCMed.EPDC	    //传染病疾病字典、传染病附卡、传染病地址  
	Kill ^DHCMed.EPDCi	    
	
	Quit "OK"
}

/// 清死亡证明书（DTH）业务数据
ClassMethod ClearDTHBusiness()
{
	Kill ^DHCMed.DTH("REPNO")
	Kill ^DHCMed.DTHi("REPNO")
	Kill ^DHCMed.DTH("REP")
	Kill ^DHCMed.DTHi("REP")
	Kill ^DHCMed.DTH("ChildREP")
	Kill ^DHCMed.DTHi("ChildREP")
	Kill ^DHCMed.DTH("PAPERNO")
	Kill ^DHCMed.DTHi("PAPERNO")
	Kill ^DHCMed.DTH("MaterREP")      //孕产妇死亡报告附卡
	Kill ^DHCMed.DTHi("MaterREP")	
	Kill ^DHCMed.DTH("DTHNO")         //死亡证明书编号生成计数器
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("DTH")		//CA认证日志
	
	Quit "OK"
}

/// 清食源性疾病（FBD）业务数据
ClassMethod ClearFBDBusiness()
{
	Kill ^DHCMed.FBD("ReportNo")     //食源性疾病报告编号
	Kill ^DHCMed.FBD("SampleNo")     //样本编号
	Kill ^DHCMed.FBD.ReportD         //食源性疾病
	Kill ^DHCMed.FBD.ReportI	
	Kill ^DHCMed.FBD.SusAbRepD       //疑似食源性疾病
	Kill ^DHCMed.FBD.SusAbRepI
    Kill ^DHCMed.FBD.SusAbRepC
    Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("FBD")		//CA认证日志
    
	Quit "OK"
}

/// 清食源性疾病（FBD）基础数据
ClassMethod ClearFBDCodeTable()
{
	Kill ^DHCMed.FBD.SignDicD       // 症状体征字典
	Kill ^DHCMed.FBD.SignDicI
	
	Quit "OK"
}

/// 清精神疾病报卡（SMD）业务数据
ClassMethod ClearSMDBusiness()
{
	Kill ^DHCMed.SMD.CardNoC               //报卡编号计数器
	Kill ^DHCMed.SMD.ReportD
	Kill ^DHCMed.SMD.ReportI
	Kill ^DHCMed.SMD.ReportC
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("SMD")		//CA认证日志
	
	Quit "OK"
}

/// 清精神疾病报卡（SMD）配置数据
ClassMethod ClearSMDConfig()
{
	//外部接口
	Kill ^DHCMed.SMD.IODictionaryD
	Kill ^DHCMed.SMD.IODictionaryI
	Kill ^DHCMed.SMD.IOMappingD
	Kill ^DHCMed.SMD.IOMappingI
	//药品字典
	Kill ^DHCMed.SMD.PsychDrugD
	Kill ^DHCMed.SMD.PsychDrugI
	
	Quit "OK"
}

/// 清精神疾病报卡（SMD）基础数据
ClassMethod ClearSMDCodeTable()
{
	Kill ^DHCMed.SMD.SymptomD   //精神症状字典
	Kill ^DHCMed.SMD.SymptomI
		
	Quit "OK"
}

/// 清特殊患者管理（SPE）业务数据
ClassMethod ClearSPEBusiness()
{
	Kill ^DHCMed.SPE
	Kill ^DHCMed.SPEi
	Kill ^DHCMed.SPE.CaseXD
	Kill ^DHCMed.SPE.CaseXI
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("SPE")		//CA认证日志
	
	Quit "OK"
}

/// 清特殊患者管理（SPE）配置数据
ClassMethod ClearSPEConfig()
{
	Kill ^DHCMed.SPED
	Kill ^DHCMed.SPEDi
	Kill ^DHCMed.SPE.ScreeningD
	Kill ^DHCMed.SPE.ScreeningI
	
	Quit "OK"
}

/// 清慢病管理（CD）业务数据
ClassMethod ClearCDBusiness()
{
	Kill ^DHCMed.CD.CRReportD  
	Kill ^DHCMed.CD.CRReportI  
	Kill ^DHCMed.CD.CRReportNo             //报卡编号计数器					  
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("CD")		//CA认证日志
	
	Quit "OK"
}

/// 清慢病管理（CD）基础数据
ClassMethod ClearCDCodeTable()
{
	Kill ^DHCMed.CD.CRAnatomyD	
	Kill ^DHCMed.CD.CRAnatomyI	
	Kill ^DHCMed.CD.CRDiagnosPosD
	Kill ^DHCMed.CD.CRDiagnosPosI
	Kill ^DHCMed.CD.CRICDDxD
	Kill ^DHCMed.CD.CRICDDxI	   					
	Kill ^DHCMed.CD.CRPathologyD
	Kill ^DHCMed.CD.CRPathologyI	
	Kill ^DHCMed.CD.CRFormD
	Kill ^DHCMed.CD.CRFormI					  
	
	Quit "OK"
}

/// 清医疗垃圾（RUB）业务数据
ClassMethod ClearRUBBusiness()
{
	Kill ^DHCMed.RUB.ReportD
	Kill ^DHCMed.RUB.ReportI
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("RUB")		//CA认证日志
	
	Quit "OK"
}

/// 清医疗垃圾（RUB）配置数据
ClassMethod ClearRUBConfig()
{
	Kill ^DHCMed.RUB.UserInfoD
	Kill ^DHCMed.RUB.UserInfoI
	
	Quit "OK"
}

/// 清罕见病（RD）业务数据
ClassMethod ClearRDBusiness()
{
	Kill ^DHCMed.RD.InterfaceLogD
	Kill ^DHCMed.RD.InterfaceLogI
	Kill ^DHCMed.RD.ReportD
	Kill ^DHCMed.RD.ReportI
	Do ##class(DHCMA.Util.INIT.ToMASrv).DelCASignData("RD")		//CA认证日志
	
	Quit "OK"
}

/// 清罕见病（RD）配置数据
ClassMethod ClearRDConfig()
{
	Kill ^DHCMed.RD.CoopHospD
	Kill ^DHCMed.RD.CoopHospI
	Kill ^DHCMed.RD.InterfaceDefineD
	Kill ^DHCMed.RD.InterfaceDefineI
	
	Quit "OK"
}

/// 清医务管理（Med）配置数据
ClassMethod ClearMedConfig()
{
	//参数配置
	kill ^DHCMed.SS.ConfigD  
	kill ^DHCMed.SS.ConfigI  
	
	//医院 院区
	kill ^DHCMed.SS.HospitalD  
	kill ^DHCMed.SS.HospitalI  
	
	//涉密项目配置
	Kill ^DHCMed.SS.SecretC
	
	//消息
	kill ^DHCMed.SS.MessageD  
	kill ^DHCMed.SS.MessageI 
	//自定义页签设置 
	kill ^DHCMed.SS.MyPortletsD  
	kill ^DHCMed.SS.MyPortletsI  
	//自定义页签
	kill ^DHCMed.SS.PortletsD  
	kill ^DHCMed.SS.PortletsI 
	//智能报表分组
	kill ^DHCMed.SS.ReportConfigC  
	kill ^DHCMed.SS.ReportConfigD  
	kill ^DHCMed.SS.ReportConfigI  
	
	//菜单操作及自定义页签权限设置
	kill ^DHCMed.SS.MenuOperationD  
	kill ^DHCMed.SS.MenuOperationI
	kill ^DHCMed.SS.SecurityOperaD  
	kill ^DHCMed.SS.SecurityOperaI
	kill ^DHCMed.SS.SecurityPortletsD  
	kill ^DHCMed.SS.SecurityPortletsI 
	
	//菜单、权限
	//kill ^DHCMed.SS.MenusD  
	//kill ^DHCMed.SS.MenusI  
	//kill ^DHCMed.SS.SecurityD  
	//kill ^DHCMed.SS.SecurityI  
	
	Quit "OK"
}

/// 清医务管理（Med）基础数据
ClassMethod ClearMedCodeTable()
{
	//DHCMedBase2.0	
	//省市县乡
	kill ^DHCMed.SS.AreaDicD  
	kill ^DHCMed.SS.AreaDicI 
	
	//基础字典
	kill ^DHCMed.SS.DictionaryD  
	kill ^DHCMed.SS.DictionaryI  
	
	//疾病字典
	kill ^DHCMed.SS.DiseaseD  
	kill ^DHCMed.SS.DiseaseI 
	
	//产品维护
	kill ^DHCMed.SS.ProductsD  
	kill ^DHCMed.SS.ProductsI
	
	Quit "OK"
}

}
