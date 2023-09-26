/// 名称: DHCMA.Util.INIT.Interface
/// 描述: 医务管理组产品初始化程序
/// 编写者：zhufei
/// 编写日期: 2020-04-14
Class DHCMA.Util.INIT.Interface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 清产品业务数据
/// W ##Class(DHCMA.Util.INIT.Interface).ClearBusiness()
ClassMethod ClearBusiness()
{
	W "开始清除医务管产品业务数据...",!
	
	//医疗质量（MA）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearMABusiness()

	//临床路径管理（CPW）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearCPWBusiness()
	
	//单病种（SD）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearSDBusiness()
		
	//慢阻肺（COP）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearCOPBusiness()
	
	//重点患者管理（IMP）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearIMPBusiness()
	
	//传染病管理（EPD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearEPDBusiness()
	
	//死亡证明书（DTH）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearDTHBusiness()
	
	//食源性疾病（FBD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearFBDBusiness()
	
	//精神疾病（SMD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearSMDBusiness()
	
	//慢性非传染性疾病（CD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearCDBusiness()

	//重点患者（SPE）
	//Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearSPEBusiness()
	
	//医疗垃圾（RUB）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearRUBBusiness()
	
	//罕见病（RD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearRDBusiness()
	
	Quit "OK"
}

/// 清产品配置数据
/// W ##Class(DHCMA.Util.INIT.Interface).ClearConfig()
ClassMethod ClearConfig()
{
	W "开始清除医务管产品配置数据...",!
	
	//医疗质量（MA）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearMAConfig()

	//临床路径管理（CPW）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearCPWConfig()
	
	//单病种（SD）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearSDConfig()
	
	//重点患者管理（IMP）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearIMPConfig()
	
	//医务管理（Med）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearMedConfig()
	
	//传染病管理（EPD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearEPDConfig()
		
	//精神疾病（SMD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearSMDConfig()
	
	//重点患者（SPE）
	//Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearSPEConfig()
	
	//医疗垃圾（RUB）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearRUBConfig()
	
	//罕见病（RD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearRDConfig()
	
		
	Quit "OK"
}

/// 清产品基础数据
/// W ##Class(DHCMA.Util.INIT.Interface).ClearCodeTable()
ClassMethod ClearCodeTable()
{
	W "开始清除医务管产品基础数据...",!

	//医疗质量（MA）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearMACodeTable()
	
	//单病种（SD）
	Do ##Class(DHCMA.Util.INIT.ToMASrv).ClearSDCodeTable()
	
	//医务管理（Med）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearMedCodeTable()  
	
    //传染病管理（EPD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearEPDCodeTable()
		
	//食源性疾病（FBD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearFBDCodeTable()
	
	//精神疾病（SMD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearSMDCodeTable()
	
	//慢性非传染性疾病（CD）
	Do ##Class(DHCMA.Util.INIT.ToMedSrv).ClearCDCodeTable()
	
	Quit "OK"
}

}
