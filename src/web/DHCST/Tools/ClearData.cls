Import sqluser

/// Descripton: 药房药库清除数据
///                 1. 库存项 - 调价等不在此类清除,于基础数据平台导入新装数据会清除
///                 2. 原因类字典不清,标库发布默认自带
///                 3. 非统一清除数据,单独调用时请严格阅读代码
/// 
///             产品部清配置数据 - d ClearProductBasicData^DHCClearData
///                 kInci(), kOutPhBasi(), kInPhBasi(), kPivaBasi(), kStockBasi(), kInPhMBasi(), kCNTSBasi(), kDECConfig(), kHDDConfig(), kPPRConfig()   
///                 
///             产品部请业务数据 - d ClearBusiData^DHCClearData
///                 kTrakBusi(), kOutPhBusi(), kInPhBusi(), kPivaBusi(), kStockBusi(), kDsp(0), kCNTSBusi(), kPhMonitor(), kInPhMBusi(), kDECBusiness()
///                                 
Class web.DHCST.Tools.ClearData Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description: 准备上线不需要使用此方法,此为彻底清库
ClassMethod kBasicData()
{
    //d ..kComBasi()    // 包含调价和库存项附加
    d ..kInci()         // 包括科室库存项, 库存项批次信息
    d ..kOutPhBasi()    // 门诊药房, 包括窗口配药人信息
    d ..kInPhBasi()     // 住院药房
    d ..kMedRoomBasi()  // 煎药室, 旧版
    d ..kPivaBasi()     // 配液中心
    d ..kStockBasi()    // 药库
    d ..kCNTSBasi()     // 处方点评
    d ..kPPRConfig()    // 制剂配置信息
    d ..kDECConfig()    // 煎药室配置
	d ..kHERBConfig()   // 草药房配置
    d ..KTDPConfig()    // 临购药品配置
    d ..KDULConfig()    // 限制用药
    d ..KLDLConfig()    // 科室用药目录
    d ..kHDDConfig()    // 揭药室
    d ..kCOMConfig()    // 公共配置数据
    d ..KBascData()     // 临床药学
    d ##class(PHA.COM.MOB.Clear).ClearMobConfigOP()     // 移动门诊药房
    d ##class(PHA.COM.MOB.Clear).ClearMobConfigIP()     // 移动住院药房
    d ##class(PHA.COM.MOB.Clear).ClearMobConfigHERB()   // 移动中草药房
    d ##class(PHA.COM.MOB.Clear).ClearComConfig()       // 移动公共配置
    d ##class(PHA.COM.MOB.Clear).ClearComDictionary()   // 移动字典

    q
}

/// 测试后的上线可用,仅清除业务数据
/// 2 清所有业务数据(导数据前清除)
/// d ##class(web.DHCST.Tools.ClearData).kBusiData()
ClassMethod kBusiData()
{
    d ..kTrakBusi()     // Trak
    d ..kIntr()         // 台账
    d ..kOutPhBusi()    // 门诊药房
    d ..kInPhBusi()     // 住院药房
    d ..kMedRoomBusi()  // 煎药室, 旧版
    d ..kPivaBusi()     // 配液中心
    d ..kStockBusi()    // 药库
    d ..kDsp(0)         // 打包表
    d ..kCNTSBusi()     // 处方点评
    d ..kPhMonitor()    // 医嘱审核
    d ..kPPRBusiness()  // 制剂
    d ..kDECBusiness()  // 煎药管理
    d ..KTDPBusiness()  // 临购药品
    d ..KNARCBusiness() // 毒麻药品管理
    d ..kHDDBusiness()  // 揭药室
    d ..kInclb()        // 批次信息
    d ..KilProfessData()    // 临床药学
    d ..KLog()          // 清除日志信息
    d ##class(PHA.COM.MOB.Clear).ClearMobBizOP()    // 移动门诊药房
    d ##class(PHA.COM.MOB.Clear).ClearMobBizIP()    // 移动住院药房
    d ##class(PHA.COM.MOB.Clear).ClearMobBizHERB()  // 移动中草药房
    d ##class(PHA.COM.MOB.Clear).ClearBox()         // 物流箱
    d ##class(PHA.COM.MOB.Clear).ClearRecommend()   // 移动意见反馈
    d ..KHERBBusiness()
    d ..KCOMBS()
    q
}

/// 3 门诊上线前清业务数据
/// d ##class(web.DHCST.Tools.ClearData).kOutPh()
ClassMethod kOutPh()
{
    d ..kOutPhBusi()
    d ..kDsp(1)
    d ..kInTrans(1)
    d ..kMedRoomBusi("O")
    q
}

/// 4 住院上线前清业务数据
/// d ##class(web.DHCST.Tools.ClearData).kInPh()
ClassMethod kInPh()
{
    d ..kInPhBusi()
    d ..kInPhMBusi()
    d ..kMedRoomBusi("I")
    d ..kPivaBusi()
    d ..kDsp(2)
    d ..kInTrans(2)
    q
}

/// Descript： 清库存和台帐数据,门诊、住院上线，以及药库或材料库、配液中心单独上线前参考执行,注意不同需求参数不同
///             1如果是全新上线在导入库存前必须执行，切记切记切记！！！！！！！
///             2如果要清的药房科室已经上了住院或者门诊,清库存则需要特别注意,可以考虑不用此函数而是走盘点程序,具体情况再恒量
/// kFlag-0-清全部的库存(门诊,住院,药库,材料库均未上线,),1-按科室清库存(如果库存管理系统(药库和材料库)没有上线),2-按科室清库存(如果库存管理系统(药库或材料库)上线)
/// LocID-科室RowID
/// kILFlag-是否已经维护库位,科室库存上下限(1-已经维护,0-没有维护),只对kFlag=1时起作用
/// d ##class(web.DHCST.Tools.ClearData).kItmLocQty()
ClassMethod kItmLocQty(kFlag, LocID, kILFlag = 0)
{
    q:((kFlag=1)!(kFlag=2))&(LocID="") "您选择的是按科室清库存，必须录入科室"
    i kFlag=0 d
    .d ..kInci()                        //清库存项(除去INC_itm以外的其它相关维护表)和台帐库存表
    .d ..kIntr()
    i kFlag=1 d
    .d ..kLocItm(LocID,kILFlag)     //清科室库存项和库存
    i kFlag=2 d
    .d ..kLocQty(LocID)             //只清库存数量
    q
}

/// 5.药库(医用材料库)产品单独上线前前清业务数据
/// 5.1 如库存管理(药库或材料库)在所有业务系统之前上线,执行步骤1和2即可，不需执行此函数
/// 5.2 如库存管理(药库或材料库)在门诊或住院上线之后上线
/// 5.2.1 如库存管理(药库或材料库)之前没有任何科室上线,先执行d kStockAll,然后按科室执行d kItmLocQty(1,LocID,0)
/// 清所有库存管理的业务表和基础表(包括定价规则)
/// d ##class(web.DHCST.Tools.ClearData).kStockAll()
ClassMethod kStockAll()
{
    d ..kStockBasi()
    d ..kStockBusi()
    q
}

/// 5.2.2 如库存管理(药库或材料库)之前有科室上线
/// 按科室清业务数据和库存数量
/// LocID-科室RowID
/// d ##class(web.DHCST.Tools.ClearData).kStockLoc()
ClassMethod kStockLoc(LocID)
{
    d ..KLocData(LocID)         //按科室清业务数据
    d ..kItmLocQty(1,LocID,0)   //按科室清库存
    q
}

/// 6 配液中心单独上线前导数据前清数据
/// 6.1 如果配液中心是单独的科室
/// 6.1.1 如果此配液中心是第一个上线的配液中心
/// LocID-科室RowID
/// d ##class(web.DHCST.Tools.ClearData).kPivaAll()
ClassMethod kPivaAll(LocID)
{
    d ..kPivaBasi()
    d ..kPivaBusi()
    d ..kItmLocQty(1,LocID,0)   //按科室清库存
    q
}

/// 6.1.2 如果此配液中心不是第一个上线的配液中心,则需按科室清业务表
/// LocID-科室RowID
/// d ##class(web.DHCST.Tools.ClearData).kPivaLoc()
ClassMethod kPivaLoc(LocID)
{
    d ..kPivaBusiLoc(LocID)     //按科室清业务表
    d ..kItmLocQty(1,LocID,0)   //按科室清库存
    q
}

/// 6.2 如果配液中心不是单独的科室(与住院药房是同一个科室),则不能清库存。强烈不建议配液与住院药房是同一科室
/// LocID-科室RowID
/// d ##class(web.DHCST.Tools.ClearData).kPivaLoc2()
ClassMethod kPivaLoc2(LocID)
{
    d ..kPivaBusiLoc(LocID)     //按科室清业务表
    q
}

/// 7 配液中心单独上线前前清业务数据
/// 7.1 如果此配液中心是第一个上线的配液中心
/// LocID-科室RowID
/// kFlag-是否清库存(1-清,0-不清)
/// kILFlag-是否已经维护库位,科室库存上下限(1-已经维护,0-没有维护),只对kFlag=1时起作用
/// d ##class(web.DHCST.Tools.ClearData).kPivaAllBusi()
ClassMethod kPivaAllBusi(LocID, kFlag = 0, kILFlag = 0)
{
    d ..kPivaBusi()
    i kFlag=1 d ..kItmLocQty(1,LocID,kILFlag)   //按科室清库存
    q
}

/// 7.2 如果此配液中心不是第一个上线的配液中心, 则需按科室清
/// LocID-科室RowID
/// kFlag-是否清库存(1-清,0-不清)
/// kILFlag-是否已经维护库位,科室库存上下限(1-已经维护,0-没有维护),只对kFlag=1时起作用
/// d ##class(web.DHCST.Tools.ClearData).kPivaLocBusi()
ClassMethod kPivaLocBusi(LocID, kFlag = 0, kILFlag = 0)
{
    d ..kPivaBusiLoc(LocID)             //按科室清业务表
    i kFlag=1 d ..kItmLocQty(1,LocID,kILFlag)   //按科室清库存
    q
}

/// ***************************以下是基础函数*******************************
/// 公共配置数据
ClassMethod kCOMConfig()
{
    // 支配科室
    k ^DHCDLOC,^mdata("DHCLOG")
    // 三大项码表日志              DHC_Log代码表维护日志,DHC_Log_Arcim,DHC_Log_INCI,DHC_Log_Phcd
    k ^DHCLOG,^mdata("DHCLOG")
    // 审核权限                     DHC_WORKAUDIT
    k ^DHCWORKAUDIT,^mdata("DHCWORKAUDIT")
    // 科室组
    k ^DHCSLG,^mdata("DHCSTKLOCGROUP")  
    d ..DeleteBDPMappingHosp("DHC_StkLocGroup")
    // 易混淆                      DHC_INCEasyConDesc 
    k ^DHCINCEC,^mdata("DHCINCEASYCONDESC") 
    // 草药处方类型转换
    k ^DHCPHCCONVERT
    d ..DeleteBDPMappingHosp("DHC_PhcConvert")
    // 皮试药品维护
    k ^CF.PHA.IN.SkinTest, ^CF.PHA.IN.SkinTesti, ^mdata("CF.PHA.IN.SkinTest")
    d ..DeleteBDPMappingHosp("PHAIN_SkinTest")
    &SQL(UPDATE PAC_Allergy SET ALG_Allergy_DR=NULL)
    // 项目组
    k ^DHCLIG, ^mdata("DHCLOCITEMGRP")
    d ..DeleteBDPMappingHosp("DHC_LocItemGrp")
    // 科室扩展信息
    k ^DHCSTCtLoc,^mdata("DHCCTLOC")
    d ..DeleteBDPMappingHosp("DHCST_CtLoc")
    // 业务审核级别
    k ^DHCSTAL, ^mdata("DHCSTKAUDITLEVEL")
    d ..DeleteBDPMappingHosp("DHC_StkAuditLevel")
    // 图标维护
    // MaYuqiang 20220525 图标字典是公共数据，不能清除，且图标未做多院区改造，无需清除图标字典与院区的关联
    // k ^CF.PHA.IN.IconD, ^CF.PHA.IN.IconI
    // d ..DeleteBDPMappingHosp("CF_PHA_IN.Icon")
    k ^CF.PHA.IN.DrugIconD, ^CF.PHA.IN.DrugIconI
    d ..DeleteBDPMappingHosp("CF_PHA_IN.DrugIcon")
    // 清除错误日志
    k ^DHCSTERROR
    // 列设置(EXT版本)
    &SQL(DELETE FROM SQLUser.DHC_StkSysGridSet WHERE GS_SaveFor != 'SITE')
    // 列设置(HISUI版本)
    d ##class(PHA.SYS.Page.Save).ClearItmSet()
    // 药库流程配置(只删除人员配置，流程配置作为固定数据)
    &SQL(DELETE FROM  CF_PHA_IN.BusiProUser)
    // 科室自定义分类
    &SQL(TRUNCATE TABLE CF_PHA_IN.LocCostomGroup)
    q 0
}

/// 清公共的基础数据(包含调价和库存项附加)
/// d ##class(web.DHCST.Tools.ClearData).kComBasi()
ClassMethod kComBasi()
{
    // 涉及基础数据不清楚(调价\库存项等),基础数据平台新装数据会清除,2020-06-24,yunhaibao
    q 0
    // 支配科室
    k ^DHCDLOC,^mdata("DHCLOG")
    // 三大项码表日志              DHC_Log代码表维护日志,DHC_Log_Arcim,DHC_Log_INCI,DHC_Log_Phcd
    k ^DHCLOG,^mdata("DHCLOG")
    // 审核权限                     DHC_WORKAUDIT
    k ^DHCWORKAUDIT,^mdata("DHCWORKAUDIT")
    // 统一价调价表                   IN_AdjSalePrice
    //k ^INASP,^mdata("INADJSALEPRICE")
    // 批次价调价表                   IN_AdjPriceBatch
    //k ^DHCSTINAPB,^mdata("INADJPRICEBATCH")   
    // 调价损益                     DHC_INASP_Detail    
    //k ^DHCINASPD,^mdata("DHCINASPDETAIL")
    // 调价原因
    //k ^DHCSTREASON("ASP"),^mdata("DHCREASONFORADJUSTPRICE")
    //d ..DeleteBDPMappingHosp("DHC_ReasonForAdjustPrice")
    // 库存项别名                    INC_ALIAS   
    //k ^INCALIAS,^mdata("INCALIAS")
    // 类组                           DHC_StkCatGroup 类组分类六个表
    //k ^DHCSCG,^mdata("DHCSTKCATGROUP")
    //d ..DeleteBDPMappingHosp("DHC_StkCatGroup")
    //d ..DeleteBDPMappingHosp("INC_StkCat")
    // 库存项附加表                   DHC_ItmAddionInfo
    //k ^DHCITMINFO,^mdata("DHCITMADDIONINFO")
    // 批准文号                     DHC_ItmRemark               
    //K ^ITMREK,^mdata("DHCITMREMARK")
    // 大包装单位                    DHC_PackUOM
    //K ^DHCPU
    // 科室组                      DHCStkLocGroup,DHCStkLocGrpItm
    k ^DHCSLG,^mdata("DHCSTKLOCGROUP")  
    d ..DeleteBDPMappingHosp("DHC_StkLocGroup")
    // 库存项关联医院              DHC_ItmAddHosp 
    //k ^ITMADDHOP,^mdata("DHCITMADDHOSP")
    // 易混淆                      DHC_INCEasyConDesc 
    k ^DHCINCEC,^mdata("DHCINCEASYCONDESC") 
    // 配液小类                     DHC_PHCPivaCat 
    //k ^PHCPIVACAT,^mdata("DHCPHCPivaCat")
    //d ..DeleteBDPMappingHosp("DHC_PHCPivaCat")
    // 草药处方类型转换
    k ^DHCPHCCONVERT
    d ..DeleteBDPMappingHosp("DHC_PhcConvert")
    // 皮试药品维护
    k ^CF.PHA.IN.SkinTest, ^CF.PHA.IN.SkinTesti, ^mdata("CF.PHA.IN.SkinTest")
    d ..DeleteBDPMappingHosp("PHAIN_SkinTest")
    // 项目组
    k ^DHCLIG, ^mdata("DHCLOCITEMGRP")
    d ..DeleteBDPMappingHosp("DHC_LocItemGrp")
    // 科室扩展信息
    k ^DHCSTCtLoc,^mdata("DHCCTLOC")
    d ..DeleteBDPMappingHosp("DHCST_CtLoc")
    // 业务审核级别
    k ^DHCSTAL, ^mdata("DHCSTKAUDITLEVEL")
    d ..DeleteBDPMappingHosp("DHC_StkAuditLevel")
    // 不可退药原因
    //k ^DHCRFRETREASON,^mdata("DHCSTKREFUSERETREASON")
    //d ..DeleteBDPMappingHosp("DHC_StkRefuseRetReason")
    // 库存项不可用原因
    //k ^DHCNUR,^mdata("DHCITMNOTUSEREASON")
    //d ..DeleteBDPMappingHosp("DHC_ItmNotUseReason")
    // 质量层次
    //k ^DHCITMQL,^mdata("DHCITMQUALITYLEVEL")
    //d ..DeleteBDPMappingHosp("DHC_ItmQualityLevel")   
    // 配送商
    //k ^DHCCARR,^mdata("DHCCARRIER")               ;DHC_Carrier
    //d ..DeleteBDPMappingHosp("DHC_Carrier")
    // 厂商
    //k ^PHMNF,^DHCMANF,^DHCMANFH
    //d ..DeleteBDPMappingHosp("PH_Manufacturer")
    // 供应商
    //k ^APC("APCVM"),^DHCSTV,^DHCSTVH
    //d ..DeleteBDPMappingHosp("APC_Vendor")
    // 供应商分类
    //k ^APC("APCVC")
    //d ..DeleteBDPMappingHosp("APC_VendCat")   
    q ""
}

/// 清科室库存项基础数据(包括科室库存项()、库存项批次信息)
/// d ##class(web.DHCST.Tools.ClearData).kInci()
ClassMethod kInci()
{
    SET IND=0
    FOR  SET IND=$O(^INCI(IND)) Q:($EXTRACT(IND,1,1)<1)!($EXTRACT(IND,1,1)>9)  D
    .K ^INCI(IND,"VE"),^INCI(IND,"IB"),^INCI(IND,"IL"),^INCI(IND,"LOC")
    .S str=$G(^INCI(IND,1))
    .S $P(str,"^",4)="",$P(str,"^",5)="",$P(str,"^",11)=""
    .S ^INCI(IND,1)=str
    .S str=$G(^INCI(IND,3))
    .S $P(str,"^",4)="",$P(str,"^",5)=""
    .S ^INCI(IND,3)=str
    k ^INCI("IB_NO"),^INCI("IB_EX"),^INCI("IB_NoX")     //INC_ItmBat  库存            
    k ^INCI("LB_IB"),^INCI("IL_LOC")                    //INC_ItmLcBt,INC_ItmLoc 库存
    K ^INCI(0,"CONS")                                   //INC_ItmConsumption
    k ^INCI(0,"StLocCode"),^INCI(0,"StLocDesc")         //INC_ItmStockLocations
    K ^INCI(0,"STGLocDesc"),^INCI(0,"STGLocCode")       //INC_ItmStockLocations
    k ^DHCINCIB                                         //DHC_IncItmBat 库存项批次扩展表
    k ^DHCINCIL                                         //DHC_IncItmLoc 科室库存
    K ^DHCITMLOC                                        //DHC_ItmLoc 友谊使用
    k ^PHMCi,^PHMC                                      //DHC_PHMANCODE
    K ^DHCLMG                                           //DHC_LocManGrp
    k ^DHCINCLB,^DHCINCLBi                              //DHC_INCItmLcBt 科室批次库存附加
    k ^DHCINCILB                                        //DHC_IncItmLocBin 科室货位
    k ^DHCINBP                                          //DHC_IncBatPack 库存批次包装表
    k ^DHCILDU                                          //DHC_IncilDispUom 发药单位维护
    //
    k ^mdata("DHCINCLBADDION")                          ;DHC_IncItmBat  批次附加表
    k ^mdata("DHCINCITMLOC")                            ;DHC_IncItmLoc  科室库存附加表
    k ^mdata("DHCINCITMLCBT")                           ;DHC_INCItmLcBt 科室批次库存附加表
    k ^mdata("DHCINCBATPACK")                           ;DHC_IncBatPack 库存批次包装表 
    k ^mdata("DHCINCILDISPUOM")                         ;DHC_IncilDispUom 发药单位维护
    q
}

/// 清原MedTrak的业务数据
/// d ##class(web.DHCST.Tools.ClearData).kTrakBusi()
ClassMethod kTrakBusi()
{
    k ^INAD,^INDS,^INGR,^INGRI,^INIT,^INMAN,^INST,^INTR,^INMRQ
    k ^DHCINTRFI,^ingritmad  ;友谊医院老版本使用
    q
}

/// 清库存及台帐数据
/// d ##class(web.DHCST.Tools.ClearData).kIntr()
ClassMethod kIntr()
{
    k ^DHCINTR                              ;DHC_INTRANS
    k ^DHCLOCTOT                            ;DHC_LocDailyTotal
    k ^DHCBTLOCTOT                          ;DHC_LocBTDailyTotal
    k ^DHCRETA                              ;DHC_RetAspAmount
    //
    K ^mdata("DHCINTRANS")                  ;DHC_INTRANS
    k ^mdata("DHCLOCDAILYTOTAL")            ;DHC_LocDailyTotal
    k ^RETA(0)                              ;DHC_RetAspAmount
    q
}

/// 清门诊基础代码
/// d ##class(web.DHCST.Tools.ClearData).kOutPhBasi()
ClassMethod kOutPhBasi()
{
    // 发药窗口             DHC_PHWINDOW    
    k ^DHCPHWIN,^DHCPHWINi,^mdata("DHCPHWINDOW")        
    // 发药占用窗口           DHC_PHWPER          
    k ^DHCPHWP,^DHCPHWPi,^mdata("DHCPHWPER")
    // 配药窗口             DHC_PHPYWIN,DHC_PHPYWINSUB                  
    K ^DHCPHPY,^DHCPHPYi,^mdata("DHCPHPYWIN")   
    // 药房配药打印机设置    无User                           
    k ^DHCPYPRINTDEF    
    // 草药配药窗口设置                         
    k ^DHCPHLOCWINOPEN
    // 非正常发退原因      DHC_PHUNDREAS   停用                  
    k ^DHCPHUNDR
    // 门诊药房人员维护     DHC_PHPERSON
    k ^DHCPHPER,^DHCPHPERi,^mdata("DHCPHPERSON")
    // 门诊药房科室维护     DHC_PHLOC 
    k ^DHCPHLOC,^DHCPHLOCi,^GLobDHCPHLOC
    // 发药机药品定义      DHC_PhSend
    k ^DHCPHSEND,^DHCPHSENDi,^mdata("DHCPHSEND")
    // 基数药维护            DHC_PHBaseMedicine
    k ^DHCPHBMED,^DHCPHBMEDI,^mdata("DHCPHBASEMEDICINE")
    // 窗口工作量            DHC_PHCURRWINSUM
    k ^DHCPHCWS,^DHCPHCWSi,^mdata("DHCPHCURRWINSUM")
    // 科室指定窗口       DHC_PHWINLOC            
    k ^DHCPHWINL    
    // 人员药品发放权限     PHAOP_DispLimit
    k ^CF.PHA.OP.DispLimit,^CF.PHA.OP.DispLimiti
    // 门诊支配科室           DHC_DefLoc
    k ^DHCDLOC,^mdata("DHCDEFLOC")
    // 门诊标签用法
    k ^DHCGLobIntrLoc
    // 门诊标签用法           PHAOP_Instruction
    k ^CF.PHA.OP.INST,^CF.PHA.OP.INSTi
    //CF_PHA_OP.Flow –门诊药房流程
    k ^CF.PHA.OP.FlowD,^CF.PHA.OP.FlowI
    // CF_PHA_OP.PrescType -处方类型
    //k ^CF.PHA.OP.PrescTypeD,^CF.PHA.OP.PrescTypeI
    //仅清理带科室的处方类型
    &SQL(delete From CF_PHA_OP.PrescType WHERE PHAOPPT_DocLoc_Dr IS NOT null)
    // 清理跨科室发药的配置
    k ^CF.PHA.OP.CrossRecLocD,^CF.PHA.OP.CrossRecLocI
    
    // 门诊拒绝退药原因
    //k ^PHRREFUSE,^mdata("PHRRefuseReason")
    //d ..DeleteBDPMappingHosp("PHR_RefuseReason")
    /* 如下未用或未知 */
    // DHC_PHMANAGE
    K ^DHCPHMAi,^DHCPHMA,^mdata("DHCPHMANAGE")
    // DHC_PHMANCODE
    k ^DHCPHMCi,^DHCPHMC
    // 未知
    k ^DHCPHPL
    k ^DHCPHGC                                  ;DHC_PHGCULOC   未用
    k ^DHCPHGLi,^DHCPHGL                        ;DHC_PHGLOC     未用
    k ^PHLABi,^PHLAB                            ;DHC_PhLabel    不知道是什么标签还是条码
    // 门诊移动
    d ..kOutPhMOB()
    q
}

/// 清门诊药房业务数据
/// d ##class(web.DHCST.Tools.ClearData).kOutPhBusi()
ClassMethod kOutPhBusi()
{
    // 中间表                  DHC_PHARWIN 
    k ^DHCPHARW,^DHCPHARWi,^DHCPHARi,^mdata("DHCPHARWIN")
    // 发药表                  DHC_PHDISPEN,DHC_PHDISITEM,DHC_PHDISITMCLB
    k ^DHCPHDISP,^DHCPHDISPi,^DHCPHDI,^DHCPHDIi,^mdata("DHCPHDISPEN")
    // 退药申请                 DHC_PHREQUEST,DHC_PHREQITEM
    k ^DHCPHREQ,^DHCPHREQi,^mdata("DHCPHREQUEST")
    // 退药表                  DHC_PHRETURN,DHC_PHRETITM                               ;
    k ^DHCPHRET,^DHCPHRETi,^DHCPHRTI,^DHCPHRTIi,^mdata("DHCPHRETURN")   
    // 非正常发                 DHC_PHUNDISPEN,DHC_PHUNDISPITM
    k ^DHCPHUND,^DHCPHUNDi,^mdata("DHCPHUNDISPEN")      
    // DHC_PHSERIAL 
    k ^DHCPHSERIAL,^DHCPHSERIALi,^mdata("DHCPHSERIAL")
    // DHC_PHDREPRINT
    k ^DHCPHDR,^DHCPHDRi,^mdata("DHCPHDREPRINT")
    // 当前窗口                 DHC_PHCURRWIN
    k ^DHCPHCW,^mdata("DHCPHCURRWIN")
    // DHC_PHRTCODE
    k ^DHCPHRTC,^DHCPHRTCi,^mdata("DHCPHRTCODE")
    // DHC_PHDAILY
    k ^DHCPHDAIL,^DHCPHDAILYi,^mdata("DHCPHDAILY")
    // DHC_PHMONTH
    k ^DHCPHMON,^mdata("DHCPHMONTH")
    // DHC_PHMONDEF
    k ^DHCPHMONDEF,^mdata("DHCPHMONDEF")
    // DHC_PHPATIENCODE
    k ^PHPATCODE,^mdata("DHCPHPATIENCODE")
    // 非正常发退患者          DHC_PHINPERSON
    k ^DHCPHINP,^DHCPHINPi,^mdata("DHCPHINPERSON")
    // 非正常退                 DHC_PHUNRETURN,DHC_PHUNRETITM   停用
    k ^DHCPHUNR,^DHCPHUNR,^mdata("DHCPHUNRETURN")
    // DHC_PhUpdate
    k ^DHCPHUP,^DHCPHUPi,^mdata("DHCPHUPDATE")
    // DHC_PHNOLCD
    k ^DHCPHNL,^DHCPHNLi,^mdata("DHCPHNOLCD")
    // 申请单号                 DHC_PHREQCODE   停用
    k ^DHCPHREQC,^mdata("DHCPHREQCODE")
    // 基数补货                 DHC_PHSUPPLY,DHC_PHSUPPLYITM
    k ^DHCPHSUPP,^DHCPHSUPPI,^mdata("DHCPHSUPPLY")
    // 欠药                       DHC_PHOweList,DHC_PHOweListItm
    k ^DHCPHOW,^DHCPHOWi,^mdata("DHCPHOweList")                     ;
    //k ^DHCPHOWEI          
    // 报到机排号                DHC_PHWINQUEUE
    k ^DHCPHWQU,^DHCPHWQUi,^mdata("DHCPHWINQUEUE")
    // 门诊处方状态               BS_PHA_OP.PHA_OP_PrescState
    k ^BS.PHA.OP.PrescStateD,^BS.PHA.OP.PrescStateI
    // --发药窗口日志表            BS.PHA.OP.WinLog
    k ^BS.PHA.OP.WinLogD,^BS.PHA.OP.WinLogI
    /* 如下 未知 */
    // DHC_PHCALL
    k ^DHCPHCALL,^DHCPHCALLi,^mdata("DHCPHCALL")
    // DHC_PhExeCute 
    k ^DHCPHEXEC,^DHCPHEXECi,^mdata("DHCPHEXECUTE")
    // DHC_PHLCD
    K ^DHCPHLCD,^mdata("DHCPHLCD")
    // DHC_PHLCDCODE
    K ^DHCPHLDC,^DHCPHLDCi,^mdata("DHCPHLCDCODE")
    // DHC_PHSKSCREEN
    k ^PHSK,^PHSKi,^mdata("DHCPHSKSCREEN")
    // DHC_PhSendMsg
    k ^DHCPHSM,^DHCPHSMi,^mdata("DHCPHSENDMSG")
    /* 如下 原版本,早已停用 */
    k ^PHDI,^PHDISi                             ;DHC_PHDISITEM 原版本
    k ^PHRET,^PHRETi                            ;DHC_PHRETURN   原版本
    q
}

/// 清住院基础代码
/// d ##class(web.DHCST.Tools.ClearData).kInPhBasi()
ClassMethod kInPhBasi()
{
    // 发药类别                 DHCStkDrugGroup,DHCStkDrugGrpItm
    k ^DHCSTDRUGGRP,^mdata("DHCSTKDRUGGROUP")
    d ..DeleteBDPMappingHosp("DHCStkDrugGroup")
    // 住院药房科室维护         DHC_PhaLocation,DHC_PhaLocDisType
    k ^DHCPL,^mdata("DHCPHALOC"),^DHCSTPHACONFIG
    // 本地客户端配置          DHC_PhaPriority,DHC_PhaPriorDisType
    k ^DHCPPRIOR,^mdata("DHCPHAPRIORITY")                   
    // 医嘱需审核科室          DHC_STPhAuditLoc
    k ^DHCSTPAL
    // 处方追踪状态               DHC_PhaPreState     此字典没有前台维护界面，删除后会导致无法追踪处方信息
    //k ^DHCPHAPSTATE,^DHCPHAPSTATEi,^mdata("DHCPhaPreState")
    // 拒绝发药原因
    //k ^DHCRFREASON,^mdata("DHCSTREFUSEREASON")
    //d ..DeleteBDPMappingHosp("DHC_STRefuseReason")
    // 住院退药原因
    //k ^BLC("RFR")
    //d ..DeleteBDPMappingHosp("BLC_ReasonForRefund")
    /* 如下未知 */
    // DHC_PhaLocConfig
    k ^DHCPHLC,^mdata("DHCPHALOCCONFIG")
    q
}

/// 清住院移动药房基础代码
/// d ##class(web.DHCST.Tools.ClearData).kInPhMBasi()
ClassMethod kInPhMBasi()
{
    // 备药排序规则               DHC_PHDrawSort,DHC_PHDrawSortItm
    k ^DHCPHDWSORT,^DHCPHDWSORTi,^mdata("DHCPHDRAWSORT")        
    // 送药科室维护               DHC_PHSendLoc
    k ^DHCPHSL,^DHCPHSLi,^mdata("DHCPHSENDLOC")                     
    q ""
}

/// 清住院业务数据
/// d ##class(web.DHCST.Tools.ClearData).kInPhBusi()
ClassMethod kInPhBusi()
{
    // 住院发药                 DHC_PHACollected,DHC_PHACollectItm,DHC_PhaCollectItmLB
    K ^DHCPHAC,^DHCPHACi,^mdata("DHCPHACOLLECTED")  
    // 出院带药发药               DHC_PhaCollectOutDrug,DHC_PhaCollectOutDrugDet
    K ^DHCPCOD,^mdata("DHCPHACOLLECTOUTDRUG")
    // 退药申请                 DHC_PhaRetRequest
    K ^RETRQ,^mdata("DHCPHARETREQUEST")     
    // 退药                       DHC_PhaReturn,DHC_PhaReturnItm,DHC_PhaReturnItmLB
    K ^PHARET,^PHARETi,^mdata("DHCPHARETURN")
    // 冲减退药                 DHC_PhaReserve
    K ^DHCPRES,^mdata("DHCPHARESERVE")
    // 拒绝发药                 DHC_STDRUGREFUSE
    k ^STDF,^mdata("DHCSTDRUGREFUSE")   
    // 发药申请                 DHC_DispRequested   未用  
    K ^DHCDISPREQ,^mdata("DHCDISPREQUESTED")                                                            
    // 基数药                  DHC_BaseDrugDisp
    k ^DHCBDD                   
    // 处方追踪                 DHC_PhaPresTrack,DHC_PhaPresTrackItm
    k ^PHAPRESTRACK,^PHAPRESTRACKi,^mdata("DHCPhaPresTrack")
    // 科室协定方申请          DHC_PhaAgrPartyReq,DHC_PhaAgrPartyReqItm
    k ^DHCPHAAPR,^mdata("DHCPhaAgrPartyReq")
    // 揭药表                  DHC_PhaMedBroth,DHC_PhaMedBrothItm
    k ^DHCPHAMEDB,^DHCPHAMEDBi,^mdata("DHCPhaMedBroth")
    // todo护士领药审核完成         DHC_InPhWardComp
    // 
    /* 如下,未知 */
    // 回收?                  DHC_PhaCallback
    k ^DHCPCB,^mdata("DHCPHACALLBACK")
    // DHC_STOutDrugCheck   
    K ^DHCSTOUTDRUGCHECK,^mdata("DHCSTOUTDRUGCHECK")
    
    /* 如下,非数据结构 */
    k ^DHCSTPHARMACY("COLL")                    ;发药界面的计数器
    k ^DHCSTPHARETURN("COLL")                   ;退药界面的计数器
    q
}

/// 清移动药房业务数据
/// d ##class(web.DHCST.Tools.ClearData).kInPhMBusi()
ClassMethod kInPhMBusi()
{
    // 病区请领发药               DHC_InPhReq,DHC_InPhReqItm
    k ^DHCINPHREQ,^DHCINPHREQi,^mdata("DHCINPHREQ") 
    // 备药表                  DHC_PHDraw,DHC_PHDrawInc,DHC_PHDrawOrder
    k ^DHCPHDRAW,^DHCPHDRAWi,^mdata("DHCPHDRAW")
    // 物流箱                  DHC_PHBox       
    k ^DHCPHBOX,^DHCPHBOXi,^mdata("DHCPHBOX")
    // 移动药房计数器
    k ^DHCINPHAPID("DHCINPHA")
}

/// 清煎药室基础代码
/// d ##class(web.DHCST.Tools.ClearData).kMedRoomBasi()
ClassMethod kMedRoomBasi()
{
    k ^DHCMBCS                                  ;DHCST_MBCState
    //
    k ^mdata("DHCSTMBCState")                   ;DHCST_MBCState
}

/// 清煎药室揭药室业务数据
/// d ##class(web.DHCST.Tools.ClearData).kMedRoomBusi()
ClassMethod kMedRoomBusi(killFlag = "")
{
    k ^DHCPHAMEDB,^DHCPHAMEDBi                  ;DHC_PhaMedBroth,DHC_PhaMedBrothItm
    k ^mdata("DHCPhaMedBroth")                  ;DHC_PhaMedBroth,DHC_PhaMedBrothItm
    i killFlag'="" d
    .&sql(delete from DHCST_MBCCollDrug where MBC_Type=:killFlag)
    .&sql(delete from DHCST_MBCRegistration where MBCR_MBC_Dr->MBC_Type=:killFlag)
    Q:killFlag'="" "" 
    k ^DHCMBC                                   ;DHCST_MBCCollDrug,DHCST_MBCCollDrugItem
    k ^DHCMBCR                                  ;DHCST_MBCRegistration
    //
    k ^mdata("DHCSTMBCCollDrug")                ;DHCST_MBCCollDrug,DHCST_MBCCollDrugItem
    k ^mdata("DHCSTMBCRegistration")            ;DHCST_MBCRegistration
}

/// 清配液基础代码
/// d ##class(web.DHCST.Tools.ClearData).kPivaBasi()
ClassMethod kPivaBasi()
{
    k ^PLGR                     // 配液工作组(已不用)
    k ^PIVAA                    // 配液医嘱子类(已不用)
    k ^PIVABF                   // 频次规则定义(已不用)
    k ^PIVATY                   // 配液分类(已不用)
    k ^PIVAO                    // 配液医嘱优先级(已不用)
    k ^PIVAPS                   // 配液标签标识(已不用)
    k ^PIVAW                    // 配液病区(已不用)
    
    k ^PIVAS                    // 配液流程设置
    
    k ^PIVABT                   // 排批定义-时间规则
    k ^PIVAINST                 // 排批定义-用法固定规则
    k ^PIVAFREQR                // 排批定义-容积频次规则
    k ^PIVALBAT                 // 排批定义-病区规则
    k ^PIVALBATCU               // 排批定义-容积规则
    k ^PIVAOTHR                 // 排批定义-其他规则

    k ^PIVAWT,^PIVAWTi          // 工作组
    k ^PIVACT,^PIVACTi          // 配置台
    k ^POLI                     // 配液大类
    d ..DeleteBDPMappingHosp("PIVA_OrderLink")
    k ^Code.PIVA.Duty           // 岗位
    k ^Code.PIVA.Holiday        // 寒暑假
    k ^Code.PIVA.LeaveType      // 请假类型
    k ^Config.PIVA.DutySchedul  // 岗位班次对照
    k ^Code.PIVA.Schedul        // 班次
    k ^Config.PIVA.DutyUser     // 岗位人员
    k ^Code.PIVA.SchedulType    // 班次类型
    k ^Config.PIVA.UserSchedul
    //k ^PHC("INGR")            // 药学成分,目前仅配液中心使用
    k ^PHCDINGRED               // 药品药学成分
    //k ^PHCDII                 // 审核指标公式
    // 配液收费规则
    k ^CF.PHA.PIVAS.FeeRule,^CF.PHA.PIVAS.FeeRulei,^mdata("^CF.PHA.PIVAS.FeeRule")
    d ..DeleteBDPMappingHosp("PHAPIVAS_FeeRule")
    // 配液收费上限,需要权限 &SQL(TRUNCATE TABLE SQLUser.PHAPIVAS_FeeCfg)
    k ^CF.PHA.PIVAS.FeeCfg, ^CF.PHA.PIVAS.FeeCfgs, ^CF.PHA.PIVAS.FeeCfgi
    d ..DeleteBDPMappingHosp("PHAPIVAS_FeeCfg")
    q 0
}

/// 清配液业务数据
/// d ##class(web.DHCST.Tools.ClearData).kPivaBusi()
ClassMethod kPivaBusi()
{
    k ^PIVABU                   // 批次记录表
    k ^PIVACP                   // 停止签记录表
    k ^PIVA                     // 配液主表
    
    k ^PIVADIS                  // 门诊配液申请表
    
    k ^Busi.PIVA.Leave          // 请假
    k ^Busi.PIVA.ScheArrange    // 排班
    k ^Busi.PIVA.Rest           // 存假
    
    
    // 计数器
    k ^mdata("PIVAORDGRP")                      ;PIVA_OrdGrp,PIVA_OrdGrpItm,PIVA_OrdGrpState
    
    // 配伍审核记录
    &SQL(DELETE FROM DHC_PHAORDMONITOR WHERE PHAOM_AppType='PIVAS')
    q 0
}

/// 清DHC_OEDispensing
/// killFlag:0-全清门诊和住院都未上线,1-清门诊,2-清住院
/// d ##class(web.DHCST.Tools.ClearData).kDsp()
ClassMethod kDsp(killFlag)
{
    I killFlag=0 d
    .k ^DHCOEDISQTY,^DHCOEDISQTYi               ;DHC_OEDispensing
    .k ^DHCSTINCRQD,^DHCSTINCRQDi               ;DHC_IncReservedQtyDetail
    .k ^mdata("DHCIncReservedQtyDetail")
    I killFlag=1 d
    .s flag1="F"
    .s flag2="H"
    .s flag3="S"
    .s flag4="Z"
    .&sql(delete from DHC_OEDispensing where DSP_Type=:flag1)
    .&sql(delete from DHC_OEDispensing where DSP_Type=:flag2)
    .&sql(delete from DHC_OEDispensing where DSP_Type=:flag3)
    .&sql(delete from DHC_OEDispensing where DSP_Type=:flag4)
    I killFlag=2 d
    .s flag1="P"
    .s flag2="Y"
    .&sql(delete from DHC_OEDispensing where DSP_Type=:flag1)
    .&sql(delete from DHC_OEDispensing where DSP_Type=:flag2)
    q
}

/// 清DHC_INTRANS,DHC_RetAspAmount
/// killFlag:0-全清门诊和住院都未上线,1-清门诊,2-清住院
/// d ##class(web.DHCST.Tools.ClearData).kDsp()
ClassMethod kInTrans(killFlag)
{
    I killFlag=1 d
    .s flag1="F"
    .s flag2="H"
    .s flag3="S"
    .s flag4="Z"
    .&sql(delete from DHC_INTRANS where INTR_Type=:flag1)
    .&sql(delete from DHC_INTRANS where INTR_Type=:flag2)
    .&sql(delete from DHC_INTRANS where INTR_Type=:flag3)
    .&sql(delete from DHC_INTRANS where INTR_Type=:flag4)
    .&sql(delete from DHC_RetAspAmount where RETA_Type=:flag1)
    .&sql(delete from DHC_RetAspAmount where RETA_Type=:flag2)
    .&sql(delete from DHC_RetAspAmount where RETA_Type=:flag3)
    .&sql(delete from DHC_RetAspAmount where RETA_Type=:flag4)
    I killFlag=2 d
    .s flag1="P"
    .s flag2="Y"
    .s flag3="L"
    .&sql(delete from DHC_INTRANS where INTR_Type=:flag1)
    .&sql(delete from DHC_INTRANS where INTR_Type=:flag2)
    .&sql(delete from DHC_INTRANS where INTR_Type=:flag3)
    .&sql(delete from DHC_RetAspAmount where RETA_Type=:flag1)
    .&sql(delete from DHC_RetAspAmount where RETA_Type=:flag2)
    .&sql(delete from DHC_RetAspAmount where RETA_Type=:flag3)
    q
}

/// 清药库(医用材料库)基础代码
/// d ##class(web.DHCST.Tools.ClearData).kStockBasi()
ClassMethod kStockBasi()
{
    K ^DHCSTTKW,^DHCSTTKWi                  ;DHC_InStkTkWindow盘点窗口
    
    K ^DHCDSB                               ;DHC_SingleBuy
    K ^DHCPSI                               ;DHC_PlanStatusInit
    K ^DHCPS                                ;DHC_PlanStatus
    k ^DHCPBLIST                            ;DHC_PublicBiddingList,DHC_PubBidItm
    d ..DeleteBDPMappingHosp("DHC_PublicBiddingList")
    k ^DHCIV                                ;DHC_ItmVen
    //k ^DHCOPTYPE                          ;DHC_OperateType
    //d ..DeleteBDPMappingHosp("DHC_OperateType")
    k ^DHCINMT                              ;DHC_MarkType
    d ..DeleteBDPMappingHosp("DHC_MarkType")
    k ^DHCINMR                              ;DHC_MarkRule
    d ..DeleteBDPMappingHosp("DHC_MarkRule")
    k ^DHCWTF                               ;DHC_WinTenderFlag
    k ^DHCICF                               ;DHC_ItmCertificate
    k ^DHCITMAGE                            ;DHC_ItmAgentVendor
    k ^DHCINMRA                             ;DHC_MarkRuleAdd
    k ^DHCSD                                ;DHC_StkDecimal
    d ..DeleteBDPMappingHosp("DHC_StkDecimal")
    k ^DHCLOCREL                            ;DHCST_LocRelation  请领科室关联
    //k ^DHCSTORI                               ;DHC_STOrigin
    //d ..DeleteBDPMappingHosp("DHC_STOrigin")
    k ^DHCLOCPPUSER                         ;DHC_LocPurPlanUser 采购人员
    k ^mdata("DHCPUBLICBIDDING")            ;DHC_PublicBiddingList
    k ^mdata("DHCITMVEN")                   ;DHC_ItmVen
    K ^mdata("DHCSTVENDOR")                 ;DHC_STVendor
    k ^mdata("DHCMANFADDIONINFO")           ;DHC_Manf_AddionInfo
    K ^mdata("DHCSTREFUSEREASON")           ;DHC_STRefuseReason
    k ^mdata("DHCMARKTYPE")                 ;DHC_MarkType
    k ^mdata("DHCMARKFACTOR")               ;DHC_MarkRule
    k ^mdata("DHCWINTENDERFLAG")            ;DHC_WinTenderFlag
    k ^mdata("DHCSTKDECIMAL")               ;DHC_StkDecimal 
    // 采购计划类型                   PHAIN_PurPlanType
    k ^PINPPT,^PINPPTi,^mdata("PHAINPPT")   
    // 统计报表类型                   PHAIN_StatType,PHAIN_StatCat,PHAIN_StatDetail
    //k ^CD.PHA.IN.STAT,^mdata("PHAINStatType")  统计报表类型作为固定分类数据不再清除，只清药品目录孙表 2022-10-31
    //d ..DeleteBDPMappingHosp("PHAIN_StatType")
    &sql(DELETE FROM PHAIN_StatDetail)
    
    // 科室类组定义                   DHC_StkLocCatGroup
    k ^DHCSLCG,^mdata("DHCSTKLOCDRUGGROUP")
    // 手术药房药箱                   PHAIN_DrugBox
    k ^CF.PHA.IN.DRUGBOX,^CF.PHA.IN.DRUGBOXi
    // 库存调整原因
    //k ^INC("ADJ")
    //d ..DeleteBDPMappingHosp("INC_ReasonForAdjustment")
    // 退货原因
    //k ^INC("RET")
    //d ..DeleteBDPMappingHosp("INC_ReasonForReturn")
    // 报损原因
    //k ^DHCSTREASON("SCRAP"),^mdata("DHCINCREASONFORSTOCKSCRAP")
    //d ..DeleteBDPMappingHosp("DHC_IncReasonForStockScrap")
    &SQL(TRUNCATE TABLE CF_PHA_IN.MonSettle)
    d ..DeleteBDPMappingHosp("CF_PHA_IN.MonSettle")
    &SQL(TRUNCATE TABLE CF_PHA_IN.StkBin)
    q
}

/// 清库存管理(医用材料库)业务数据
/// d ##class(web.DHCST.Tools.ClearData).kStockBusi()
ClassMethod kStockBusi()
{
    k ^INPP                                 ;IN_PurPlan,IN_PurPlanItm
    K ^DHCPA                                ;DHC_PlanAudit
    K ^DHCPPTR                              ;DHC_PlanPoTar
    k ^DHCPPI                               ;DHC_PlanPoItmTar
    k ^INPO                                 ;IN_PO,IN_POItm 订单
    K ^DHCINGR                              ;DHC_INGdRec,DHC_INGdRecItm
    K ^INGRT                                ;DHC_INGDRET,DHC_INGRTITM   
    k ^INRQ                                 ;IN_Request,IN_ReqItm
    k ^DHCINIT                              ;DHC_InIsTrf,DHC_InIsTrfItm
    K ^DHCINAD                              ;DHC_INAdj,DHC_INAdjItm
    K ^DHCCSR                               ;DHC_INCSR,DHC_INCSRItems
    K ^DCSRLB                               ;DHC_INCSRINCLB
    K ^DHCINMAN                             ;DHC_InManuOrder,DHC_InManuOrder_Batch
    K ^DHCINST                              ;DHC_InStkTk,DHC_InStkTkItm,DHC_InStkTkGrp,DHC_InStkTkItmWd
    K ^DHCSM                                ;DHC_StkMon,DHC_StkMonReport
    k ^SMSTATI                              ;DHC_StkMonStatIn                                   
    K ^SMSTAT                               ;DHC_StkMonStat
    K ^DHCSTKYEAR                           ;DHC_StkYear
    K ^DHCSTKYEARREP                        ;Dhc_StkYearReport
    K ^STADDION                             ;DHC_STKYEARADDION 
    k ^DHCPAY                               ;DHC_Pay,DHC_PayItm,DHC_PayMon 
    k ^ASPA                                 ;DHC_ASPAmount,DHC_ASPAmountLB调价损益记录
    k ^DHCRETA                              ;业务损益表
    k ^DHCHI                                ;DHC_HHImport
    k ^DHCINRQ                              ;DHC_INRequest
    k ^DHCINRQI                             ;DHC_INReqItm
    k ^DHCINPO                              ;DHC_INPO
    k ^DHCINPOI                             ;DHC_INPOItm
    k ^DHCSTPDRQ                            ;DHCST_PHADOCReq,DHCST_PHADOCReqItm
    k ^DHCPAYM                              ;DHC_PayMon
    k ^DHCSTPDRQ                            ;DHCST_PHADOCReq,DHCST_PHADOCReqItm 四级库,领药记录
    k ^DHCINASPD,^mdata("DHCINASPDETAIL")   ;调价损益
    
    //  
    K ^mdata("DHCINISTRF")                  ;DHC_InIsTrf,DHC_InIsTrfItm
    K ^mdata("INPURPLAN")                   ;IN_PurPlan,IN_PurPlanItm
    K ^mdata("DHCINGDREC")                  ;DHC_INGdRec,DHC_INGdRecItm
    K ^mdata("DHCINADJ")                    ;DHC_INAdj,DHC_INAdjItm
    k ^mdata("DHCSTKMON")                   ;DHC_StkMon,DHC_StkMonReport
    k ^mdata("DHCSTKMONSTAT")               ;DHC_StkMonStat
    k ^mdata("DHCSTKMONSTATIN")             ;DHC_StkMonStatIn
    k ^mdata("DHCSTKYEAR")                  ;DHC_StkYear
    k ^mdata("DHCINSTKTK")                  ;DHC_InStkTk
    k ^mdata("DHCPAY")                      ;DHC_Pay
    k ^mdata("DHCPAYMON")                   ;DHC_PayMon
    k ^mdata("DHCINREQUEST")                ;DHC_INRequest,DHC_INReqItm
    k ^mdata("DHCINPO")                     ;DHC_INPO,DHC_INPOItm
    // 月报凭证状态记录表            DHC_StkMon_VoucherStatus 
    k ^DHCSMVchStatus
    // 科室月消耗统计表             DHC_StkMonSum_TransLoc 
    k ^DHCSMSum
    // 入库调价补差表              DHC_ASPAmtVend,DHC_ASPAmtVendItm,DHC_ASPAmtVendItmLoc
    k ^DHCASPAV,^mdata("DHCASPAV")
    // todo 发票表                 PHAIN_Inv,PHAIN_InvItm
    k ^BS.PHA.In.Inv
    // todo 配送表                 PHAIN_Distrib,PHAIN_DistribItm
    k ^BS.PHA.In.Distrib
    k ^DHCMONSTAT,^DHCMONSTATLB
    &SQL(TRUNCATE TABLE BS_PHA_IN.InvNo)
    &SQL(TRUNCATE TABLE BS_PHA_IN.DataLink)  
    &SQL(TRUNCATE TABLE BS_PHA_IN.Report)
    &SQL(TRUNCATE TABLE BS_PHA_IN.InitReqRelations)
    
    q
}

/// 按科室清库存数据(包括科室库存项)
/// d ##class(web.DHCST.Tools.ClearData).kLocItm()
ClassMethod kLocItm(LocID, kILFlag)
{
    d ..kIntran(LocID)
    i kILFlag=0 d ..kIncil(LocID)
    &SQL(Delete From DHC_LocDailyTotal Where Day_Loc_DR=:LocID)
    q
}

/// 按科室清库存数据(只清数量)
/// d ##class(web.DHCST.Tools.ClearData).kLocQty()
ClassMethod kLocQty(LocID)
{
    q:LocID="" -1
    &sql(update inc_itmloc set incil_logqty=0,INCIL_ReservedQty=0 where incil_ctloc_dr=:LocID)
    &sql(update INC_ItmLcBt set INCLB_PhyQty=0,INCLB_DirtyQty=0 where INCLB_INCIL_ParRef->incil_ctloc_dr=:LocID)
    s ItmID=""
    f  s ItmID=$o(^DHCLOCTOT(0,"LOCITMDATE",LocID,ItmID)) q:ItmID=""  d
    .s dah=$o(^DHCLOCTOT(0,"LOCITMDATE",LocID,ItmID,""),-1)
    .q:dah=""
    .s dayID=$o(^DHCLOCTOT(0,"LOCITMDATE",LocID,ItmID,dah,""),-1)
    .q:dayID=""
    .s $p(^DHCLOCTOT(dayID),"^",4)=0
    s batID=""
    f  s batID=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID)) q:batID=""  d
    .s dah=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID,""),-1)
    .q:dah=""
    .s dayID=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID,dah,""),-1)
    .q:dayID=""
    .s btSub=$o(^DHCBTLOCTOT(0,"LocBtDate",LocID,batID,dah,dayID,""),-1)
    .q:btSub=""
    .s $p(^DHCBTLOCTOT(dayID,"I",btSub),"^",3)=0
    q
}

/// 清某科室库管数据(库存,业务)  
/// 适用范围:1.单独清某科室  2.门诊或住院已上线,药库上线时必须启用该程序
/// Input:科室rowid,  清除标识: killflag - 0 如果维护了货位,标准库存数,最大量,最小量等，killflag - 1 ,货位等均未维护
/// d ##class(web.DHCST.Tools.ClearData).KLocData()
ClassMethod KLocData(locdr)
{
    Q:locdr="" 0
    &SQL(Delete from DHC_InGdRec Where INGR_Loc_Dr=:locdr)
    W "入库-"_SQLCODE,!

    &SQL(Delete from DHC_InIsTrf Where INIT_FrLoc_DR=:locdr)
    W "出库-"_SQLCODE,!

    &SQL(Delete From IN_PurPlan Where INPP_CTLOC_DR=:locdr)
    W "采购-"_SQLCODE,!

    &SQL(Delete From IN_POItm Where INPOI_CTLOC_DR=:locdr)
    W "订单-"_SQLCODE,!

    &SQL(Delete From IN_Request Where INRQ_ReqLoc_DR=:locdr)
    W "请领-"_SQLCODE,!

    &SQL(Delete From DHC_INAdjItm Where INADI_CTLOC_DR=:locdr)
    W "调整-"_SQLCODE,!

    &SQL(Delete From dhc_indisp Where inds_ctloc_dr=:locdr)
    W "报损-"_SQLCODE,! 

    &sql(Delete From DHC_PayMon where pm_ctloc_dr=:locdr)
    &SQL(Delete From DHC_Pay Where PAY_CTLOC_DR=:locdr)
    W "付款-"_SQLCODE,!

    &sql(delete from dhc_stkmonstatin where  smrdi_smr_dr->smr_sm_parref->dhcsm_ctloc_dr=:locdr)
    &sql(delete From dhc_stkmonstat where smrd_smr_dr->smr_sm_parref->dhcsm_ctloc_dr=:locdr)
    &SQL(Delete From DHC_StkMon Where DHCSM_CTLOC_DR=:locdr)
    W "月报-"_SQLCODE,!

    &SQL(Delete From DHC_InStkTk Where INST_CTLOC_DR=:locdr)
    W "盘点-"_SQLCODE,!

    ;&SQL(Delete From DHC_PHACollected Where DHC_PHALoc_DR=:locdr)
    ;W "发药-"_SQLCODE,!

    ;&SQL(Delete From DHC_PhaReturn Where PHAR_RecLoc_DR=:locdr)
    ;W "退药-"_SQLCODE,!

    ;&SQL(Delete From DHC_PhaRetRequest Where RETRQ_RecLoc_DR=:locdr)
    ;W "退药申请-"_SQLCODE,!

    W !,"ALL-OK"
    Q 0
}

// 清某科室所有台帐数据 

// d ##class(web.DHCST.Tools.ClearData).kIntran()

ClassMethod kIntran(locdr)
{
    q:locdr="" -1
    k ^TMP($j,"INTR")
    S type="",i=0
    f  s type=$o(^DHCINTR(0,"LOCTYPEDATE",locdr,type))  q:type=""  d
    .s date=""
    .f  s date=$o(^DHCINTR(0,"LOCTYPEDATE",locdr,type,date)) q:date=""  d
    ..s intr=0
    ..f  s intr=$o( ^DHCINTR(0,"LOCTYPEDATE",locdr,type,date,intr))  q:(intr="")!(intr=0)  d
    ...s i=i+1
    ...s ^TMP($j,"INTR",i)=intr
    s cnt=0
    f  s cnt=$O(^TMP($j,"INTR",cnt)) q:cnt=""  d
    .s intr= ^TMP($j,"INTR",cnt)
    .w "台账ID:"_intr,!
    .&sql(delete from DHC_intrans where intr_rowid=:intr)
    K ^TMP($j,"INTR")
    q "总计:"_i
}

/// delete Inc_itmLoc
/// d ##class(web.DHCST.Tools.ClearData).kIncil()
ClassMethod kIncil(locdr)
{
    /*
    S inci="",i=0
    F  S inci=$O(^INCI("IL_LOC",locdr,inci)) Q:inci=""  D
    .S ilsub=""
    .F  S ilsub=$O(^INCI("IL_LOC",locdr,inci,ilsub)) Q:ilsub=""  D
    ..S incil=inci_"||"_ilsub
    ..S i=i+1
    ..s ^TMP($j,"INCIL",i)=incil
    s i=0
    f  s i=$o(^TMP($j,"INCIL",i)) q:i=""  d
    .s incil=$g(^TMP($j,"INCIL",i))
    .&SQL(Delete From Inc_itmLoc Where incil_rowid=:incil)
    .I SQLCODE W "incil-"_incil_"-"_SQLCODE,!
    .w "."
    K ^TMP($j,"INCIL")
    Q 0
    
    */
    
    /* 按表结构从子到主的顺序删除数据，因为附加表数据不会跟随主表删除，需手动处理 */
    /* 1.科室库存批次附加表 */
    &SQL(DELETE From DHC_INCItmLcBt WHERE   INCLB_LB_DR ->INCLB_INCIL_ParRef->INCIL_CTLOC_DR = :locdr)
    i (SQLCODE '= 0)&&(SQLCODE '= 100) w "Detete DHC_INCItmLcBt :"_SQLCODE,! q
    /* 2.科室库存批次表 */
    &SQL(DELETE From INC_ItmLcBt WHERE INCLB_INCIL_ParRef->INCIL_CTLOC_DR = :locdr)
    i (SQLCODE '= 0)&&(SQLCODE '= 100) w "Detete INC_ItmLcBt :"_SQLCODE,! q
    /* 3.科室库存附加表 */
    &SQL(DELETE From DHC_IncItmLoc WHERE INCIL_INCIL_DR -> INCIL_CTLOC_DR = :locdr)
    i (SQLCODE '= 0)&&(SQLCODE '= 100) w "Detete DHC_IncItmLoc :"_SQLCODE,! q
    /* 4.科室库存表 */
    &SQL(DELETE From INC_ItmLoc WHERE  INCIL_CTLOC_DR = :locdr)
    i (SQLCODE '= 0)&&(SQLCODE '= 100) w "Detete INC_ItmLoc :"_SQLCODE,! q
    
    q 0
}

/// 按科室清配液业务数据
/// d ##class(web.DHCST.Tools.ClearData).kPivaBusiLoc()
ClassMethod kPivaBusiLoc(LocID)
{
    &sql(delete from PIVA_OrdGrp where POG_Ctloc_Dr=:LocID)
    W "配液表-"_SQLCODE,!
    q
}

/// creator:    yunhaibao
/// createdate: 2017-07-10
/// description:清处方点评基础代码
/// others:     DHC_PHCNTSWAY(此表不清)
ClassMethod kCNTSBasi()
{
    k ^DHCPCCON         // DHC_PHCNTSCONTROL
    d ..DeleteBDPMappingHosp("DHC_PHCNTSCONTROL")
    k ^DHCPCALU         // DHC_PHCNTSALLOTUSER
    d ..DeleteBDPMappingHosp("DHC_PHCNTSALLOTUSER")
    k ^DHCPCINST        // DHC_PHCNTSINSTRUC
    d ..DeleteBDPMappingHosp("DHC_PHCNTSINSTRUC")
#;  k ^DHCPCREASON  // DHC_PHCNTSREASON,20170710暂不清,原因都是类似的
#;  k ^DHCPCFACTOR      // DHC_PHCNTSFACTOR
#;  d ..DeleteBDPMappingHosp("DHC_PHCNTSFACTOR")
#;  k ^DHCPCADVICE      // DHC_PHCNTSADVICE
#;  d ..DeleteBDPMappingHosp("DHC_PHCNTSADVICE")
    k ^DHCPHCNTSORDER   // DHC_PHCNTSORDER;DHC_PHCNTSORDERITM
    &SQL(DELETE FROM DHC_PHCNTSWAYITM)  
    k ^mdata("DHCPHCNTSCONTROL")
    k ^mdata("DHCPHCNTSINSTRUC")
    /// k ^mdata("DHCPHCNTSREASON")
    k ^mdata("DHCPHCNTSFACTOR")
    k ^mdata("DHCPHCNTSADVICE")
    k ^mdata("DHCPHCNTSORDER")
}

/// creator:    yunhaibao
/// createdate: 2017-07-10
/// description:清处方点评业务数据
ClassMethod kCNTSBusi()
{
    k ^DHCPHCNTS                            ;DHC_PHCOMMENTS,DHC_PHCOMMENTSITM,DHC_PHCOMMENTSLOG,DHC_PHCOMMENTSREITM
    k ^DHCPCTABL                            ;DHC_PHCNTSTABOOLIST
    k ^BS.PHA.PRA.ORDAUDIT                  ;PHAPRA_ORDPREAUDIT 预审核表
    k ^BS.PHA.PRA.ORDAUDITi
    k ^mdata("DHCPHCOMMENTS")
    k ^mdata("DHCPHCNTSTABOOLIST")
}

/// creator:    yunhaibao
/// createdate: 2017-07-10
/// description:清医嘱审核数据
ClassMethod kPhMonitor()
{
    k ^DHCPHORDM                             ;DHC_PHAORDMONITOR,DHC_PHAORDMONITORLIST
    k ^mdata("DHCPHAORDMONITOR")             ;DHC_PHAORDMONITOR
}

/// description: 清批次库存数据及其相关,批次库存完全为业务数据,没库存则没损益以及批次价格
/// w ##class(web.DHCST.Tools.ClearData).kInclb()
ClassMethod kInclb()
{
    &SQL(DELETE FROM INC_ItmBat)        // 批次信息
    &SQL(DELETE FROM INC_ItmLcBt)       // 批次库存
    &SQL(DELETE FROM IN_AdjPriceBatch)  // 批次价格
    &SQL(DELETE FROM DHC_ASPAmount)     // 损益
    &SQL(DELETE FROM DHC_ASPAmountLB)   // 批次损益
    &SQL(DELETE FROM DHC_IncItmBat)     // 批次信息附加
    &SQL(DELETE FROM DHC_INCItmLcBt)    // 批次库存信息附加
    k ^INCI("LB_IB")
    k ^INCI("IB_EX")
    k ^INCI("IB_NO")
    k ^DHCINCLBi,^DHCINCLB              // 批次信息附加-global
    k ^DHCINCIB
    k ^DHCSTINCRQD                      // 在途表
    k ^DHCSTINCRQDi                     // 在途明细
    s incId=""
    f  s incId=$o(^INCI(incId)) q:incId=""  d
    .q:+incId=0
    .s incCh=""
    .f  s incCh=$o(^INCI(incId,"IL",incCh)) q:incCh=""  d
    ..q:+incCh=0
    ..s $p(^INCI(incId,"IL",incCh),"^",3)=0
    ..s $p(^INCI(incId,"IL",incCh),"^",9)=0
    ..s $p(^INCI(incId,"IL",incCh),"^",10)=0
    ..s incLb=""
    ..f  s incLb=$o(^INCI(incId,"IL",incCh,"LB",incLb)) q:incLb=""  d
    ...i incLb'="" k ^INCI(incId,"IL",incCh,"LB",incLb)
    .s incIb=""
    .f  s incIb=$o(^INCI(incId,"IB",incIb)) q:incIb=""  d
    ..i incIb'="" k ^INCI(incId,"IB",incIb)
    q 0
}

/// Description: 门诊移动药房,配置业务一起了
/// Creator:     yunhaibao
/// CreateDate:  2019-09-09
ClassMethod kOutPhMOB()
{
    // 电子标签                 PHAINC_ETag
    k ^CD.PHA.INC.ETAG,^CD.PHA.INC.ETAGi,^mdata("PHAINCETAG")
    // todo移动配发类型           PHAHERB_PresType
    // todo移动配发类型对照     PHAHERB_PresTypeItm
    // 移动配发配置               PHAHERB_Config
    k ^CF.PHA.HERB.Config,^CF.PHA.HERB.Configi
    // todo移动界面配药类型分配 PHAHERB_DistPres
    // todo上药申请             PHAHERB_SupplyReq
}

/// 清除基础数据（临床药学）, 项目基本采用标库
/// d ##class(web.DHCST.Tools.ClearData).KBascData()
ClassMethod KBascData() As %String
{
    // 学科分类子表
    &SQL(DELETE FROM DHC_PHMonSubClassItm)  
    k ^DHCPHMSC(0,"LocDr")      
    // 函数项目
    k ^DHCPHFULITM
    // 用药建议模板数据维护
    k ^DHCPHDSD
    q 0
}

/// 清除基础数据（临床药学）, 项目基本采用标库数据, 不做清除, 2021-11-22 yunhaibao
/// d ##class(web.DHCST.Tools.ClearData).KillBascData()
ClassMethod KillBascData() As %String
{
    //学科分类
    k ^DHCPHMSC
    k ^mdata("DHCPHMONSUBCLASS")
    k ^mdata("DHCPHMONSUBCLASSITM")
    //监护级别
    k ^DHCPHML
    k ^mdata("DHCPHMONLEVEL")
    //纳入标准
    k ^DHCPHMS
    k ^mdata("DHCPHMONSCOPE")
    //监护项目
    k ^DHCPHMI
    k ^mdata("DHCPHMONITEM")
    //咨询类别
    k ^DHCPHCONT
    k ^mdata("DHCPHCONSULTTYPE")
    //问题类型
    k ^DHCPHCONQT
    k ^mdata("DHCPHCONQUETYPE")
    //问题回复依据
    k ^DHCPHCONTB
    k ^mdata("DHCPHCONSULTBASIS")
    //特殊人群
    k ^DHCPHCONSC
    k ^mdata("DHCPHCONSPCROWD")
    //药房函数库
    k ^DHCPHFULIB
    k ^mdata("DHCPHFUNLIBRARY")
    //函数项目
    k ^DHCPHFULITM
    k ^mdata("DHCPHFUNLIBITEM")
    //函数主题
    k ^DHCPHFUTHE
    k ^mdata("DHCPHFUNTHEME")
    //专业方向
    k ^DHCPHPDT
    k ^mdata("DHCPHPROFDIRECTION")
    //指导范围
    k ^DHCPHGS
    k ^mdata("^DHCPHGS")
    //用药建议模板数据维护
    k ^DHCPHDSD
    k ^mdata("DHCPHDRGSUGDIC")
    //咨询方式
    k ^mdata("PHACPWCONSWAYS")
    k ^CD.PHA.CPW.ConsWays
    //咨询身份
    k ^mdata("PHACPWCONSIDEN")
    k ^CD.PHA.CPW.ConsIden
    //服务时间
    k ^mdata("PHACPWCONSTIME")
    k ^CD.PHA.CPW.ConsTime
}

/// 清除业务数据（临床药学）
/// d ##class(web.DHCST.Tools.ClearData).KilProfessData()
ClassMethod KilProfessData() As %String
{
    //药学监护记录
    k ^DHCPHPC
    k ^mdata("DHCPHPHARCARE")
    //带教老师
    k ^DHCPHBMT
    k ^mdata("DHCPHBASMANTEACHER")
    //学生信息
    k ^DHCPHBMS
    k ^mdata("DHCPHBASMANSTUDENT")
    //药学查房
    k ^DHCPHWR
    k ^mdata("DHCPHWARDROUND")
    //医学查房记录表
    k ^DHCPHCP
    k ^mdata("DHCPHCliPATHOGRAPHY")
    //用药教育
    k ^DHCPHME
    k ^mdata("DHCPHMEDEDUCATION")
    //问题咨询
    k ^DHCPHCONS
    k ^mdata("DHCPHCONSULT")
    //问题回复记录
    k ^DHCPHCOND
    //咨询回复药品组合
    k ^DHCPHCONI
    //病人就诊信息扩展表
    k ^DHCPHAE
    k ^mdata("DHCPHADMEXT")
    //监控主表
    k ^DHCPHM
    k ^mdata("DHCPHMONITOR")
    //用药建议
    k ^DHCPHAD
    k ^mdata("DHCPHADVICE")
    //标注
    k ^DHCPHEP
    k ^mdata("DHCPHEMPPAT")
    //用药建议模板(个人)
    k ^DHCPHMAT
    k ^mdata("DHCPHMEDADVTEMP")
    //主题项目参数表
    k ^DHCPHFULITM
}

/// Description:    电子药历清除业务数据
/// Creator:        QuNianpeng
/// CreateDate: 2018-07-13
/// 清除业务数据（电子药历）
/// d ##class(web.DHCST.Tools.ClearData).KilEmrProfessData()
ClassMethod KilEmrProfessData() As %String
{

    kill ^DHCPHI.ECRecordD              /// User.DHCPHECRecord 记录表
    kill ^DHCPHI.ECRecordI              /// 记录表索引
    kill ^DHCPHI.InstanceDataI          /// User.DHCPHInstanceData 实例数据表，是记录表子表
    
    kill ^DHCPHI.EMRLogsD               /// User.DHCPHEMRLogs 操作日志
    kill ^DHCPHI.EMRLogsI               /// 操作日志索引
    kill ^DHCPHI.InstanceLogI           /// User.DHCPHInstanceLog  实例数据操作日志表，是操作日志的子表
    
    kill ^DHCPHI.InstancePrintRecordD   /// User.DHCPHInstancePrintRecord 药历打印记录表
    kill ^DHCPHI.InstancePrintRecordI   
    
    kill ^DHCPHI.EMRSignD               /// User.DHCPHEMRSign 药历签名表
    kill ^DHCPHI.EMRSignI               
    
    kill ^DHCPHCA.EMRSignLogD           /// User.DHCPHEMRSignLog 药历签名日志表
    kill ^DHCPHCA.EMRSignLogI           
    
    kill ^DHCPHF.FavInformationD        /// User.DHCPHFavInformation 收藏基本信息表
    kill ^DHCPHF.FavInformationI        
    kill ^DHCPHF.FavRecordI             /// User.DHCPHFavRecord 收藏记录表,是本信息表子表
    
    kill ^DHCPHF.FavTagD                /// User.DHCPHFavTag 关键字表
    kill ^DHCPHF.FavTagI                /// 关键字表索引
    
    kill ^DHCPHF.FavTagInformationD     /// User.DHCPHFavTagInformation 信息和关键字关联表
    kill ^DHCPHF.FavTagInformationI
    
    kill ^DHCPHF.FavCatalogD            /// User.DHCPHFavCatalog 目录表
    kill ^DHCPHF.FavCatalogI
    
    kill ^DHCPHF.FavUserD               /// User.DHCPHFavUser 收藏用户表
    kill ^DHCPHF.FavUserI
    
    kill ^DHCPHI.ICompositeDescD        /// User.DHCPHICompositeDesc 药历模板复合单元打散表
    kill ^DHCPHI.ICompositeDescI

    kill ^DHCPHI.ICompositeSimpleD      /// User.DHCPHICompositeSimple 药历模板基本信息简单单元打散表      
    kill ^DHCPHI.ICompositeSimpleI
    
    kill ^DHCPHI.IConceptSimpleD        /// User.DHCPHICompositeConceptSimple 实例数据-医学元素打散表
    kill ^DHCPHI.IConceptSimpleI
    
    kill ^DHCPHI.ICompositeConceptD     /// User.DHCPHICompositeConcept 实例数据-医学元素打散表
    kill ^DHCPHI.ICompositeConceptI
            
    kill ^DHCPHF.FavRecordCommentD      /// User.DHCPHFavRecordComment 收藏病历评论
    kill ^DHCPHF.FavRecordCommentI
    kill ^DHCPHF.FavCommentReplyI       // User.DHCPHFavCommentReply 评论回复,是收藏病历评论子表
}

/// Description: 制剂 - 基础数据
ClassMethod kPPRCode()
{
    q 0 // 默认不清,基础数据^INCI会统一清
    
    /* DHC_INCItmRcp */
    // k ^DHCINREC, ^mdata("DHCINCItmRcp")

    s incId=""
    f  s incId=$o(^INCI(incId)) q:incId=""  d
    .q:+incId=0
    .
    ./* INC_ItmRcp */
    .k ^INCI(incId,"REC")
    .
    ./* INCItmRecIngr */
    .k ^INCI(0,"RecDesc")    
    q 0
}

/// Description: 制剂 - 配置数据
ClassMethod kPPRConfig()
{
    q 0
}

/// Description: 制剂 - 业务数据
ClassMethod kPPRBusiness()
{
    /* DHC_InManuOrder, DHCInManuOrderBatch */
    k ^DHCINMAN
    
    /* DHC_INTRANS, DHC_RetAspAmount */
    s flag1="M"
    s flag2="X"
    &sql(delete from DHC_INTRANS where INTR_Type=:flag1)
    &sql(delete from DHC_INTRANS where INTR_Type=:flag2)
    &sql(delete from DHC_RetAspAmount where RETA_Type=:flag1)
    &sql(delete from DHC_RetAspAmount where RETA_Type=:flag2)
    q 0
}

/// Description:煎药室 - 基础数据
/// Creator:    MaYuqiang
/// CreateDate: 2020-04-16
ClassMethod kDECCode()
{
    q 0
    /* PHA_DECProDict */
    //k ^CD.PHA.DEC.PD, ^CD.PHA.DEC.PDi, ^mdata("PHADECProDict")
}

/// Description:煎药室 - 配置数据
/// Creator:    MaYuqiang
/// CreateDate: 2020-04-16
ClassMethod kDECConfig()
{
    /* PHA_DECEquiMai */
    k ^CF.PHA.DEC.EM, ^CF.PHA.DEC.EMi, ^mdata("PHADECEquiMai")
    d ..DeleteBDPMappingHosp("PHA_DECEquiMai")
    /* PHA_DECProSto */
    k ^CF.PHA.DEC.PS, ^CF.PHA.DEC.PSi, ^mdata("PHADECProSto")
    d ..DeleteBDPMappingHosp("PHA_DECProSto")
    /* PHA_DECProSche */
    k ^CF.PHA.DEC.PSE, ^CF.PHA.DEC.PSEi, ^mdata("PHADECProSche")
    d ..DeleteBDPMappingHosp("PHA_DECProSche")

    &SQL(TRUNCATE TABLE SQLUSER.PHAIN_Freq)
}

/// Description:煎药室 - 业务数据
/// Creator:    MaYuqiang
/// CreateDate: 2020-04-16
ClassMethod kDECBusiness()
{
    /* PHA_DECPreMain, PHA_DECPreItem */
    k ^BS.PHA.DEC.PM, ^BS.PHA.DEC.PMi, ^mdata("PHADECPreMain")
    
    /* PHA_DECPreAddInfo */ 
    k ^BS.PHA.DEC.PAI, ^BS.PHA.DEC.PAIi, ^mdata("PHADECPreAddInfo")
}

/// Description:揭药室 - 配置数据
ClassMethod kHDDConfig()
{
    q 0 // 不再使用, yunhaibao, 2021-11-15
    /* DHCST_MBCState */
    k ^DHCMBCS, ^mdata("DHCSTMBCState")
    q 0
}

/// Description:揭药室 - 基础数据
ClassMethod kHDDCode()
{
    q 0
}

/// Description:揭药室 - 业务数据
ClassMethod kHDDBusiness()
{
    /* DHC_PhaMedBroth, DHC_PhaMedBrothItm */
    k ^DHCPHAMEDB, ^DHCPHAMEDBi, ^mdata("DHCPhaMedBroth")
    
    /* DHCST_MBCCollDrug, DHCST_MBCCollDrugItem */
    //k ^DHCMBC, ^mdata("DHCSTMBCCollDrug") 
    
    /* DHCST_MBCRegistration */
    //k ^DHCMBCR, ^mdata("DHCSTMBCRegistration")
    
    q 0
}

/// Description: 多院区 - 同时删除平台数据
ClassMethod DeleteBDPMappingHosp(tableName)
{
    &SQL(DELETE FROM BDP_MappingHosp WHERE BDPMPH_TableName=:tableName)
    q SQLCODE
}

/// Description: 多院区 - 点评原因
/// w ##class(web.DHCST.Tools.ClearData).DeleteDHCPHCNTSREASON()
ClassMethod DeleteDHCPHCNTSREASON()
{
    s cnt=0
    s id=0
    f  s id=$o(^User.BDPMappingHospI("TableRef","DHC_PHCNTSREASON",id)) q:id=""  d
    .s refID=$lg(^User.BDPMappingHospD(id),3)
    .q:$d(^DHCPCREASON(refID))
    .&SQL(DELETE FROM BDP_MappingHosp WHERE ID=:id)
    .s cnt=cnt+1
    q cnt
}

/// Description:临购药品 - 业务数据
ClassMethod KTDPBusiness()
{
    /* BS_PHA_IN.TmpDrugPurch,BS_PHA_IN.TmpDrugPurItm,BS_PHA_IN.TmpDrugPurState,BS_PHA_IN.TmpDrugPurItmDisp */
    k ^BS.PHA.IN.TmpDrugPurchD
    k ^BS.PHA.IN.TmpDrugPurchI
    k ^BS.PHA.IN.TmpDrugPurchS
    
    q 0
}

/// Description:临购药品 - 配置数据
ClassMethod KTDPConfig()
{
    /* CF_PHA_IN.TmpDrugPurProcess,CF_PHA_IN.TmpDrugPurProcessItm */
    k ^CF.PHA.IN.TmpDrugPurProcessD
    k ^CF.PHA.IN.TmpDrugPurProcessI
    k ^CF.PHA.IN.TmpDrugPurProcessS
    
    q 0
}

/// Description:限制用药 - 配置数据
ClassMethod KDULConfig()
{
    /* PHAIN_DrugUseLimit,PHAIN_DrugULComb,PHAIN_DrugULCItm */
    k ^CF.PHA.IN.DrugUseLimit 
    k ^CF.PHA.IN.DrugUseLimiti
    d ..DeleteBDPMappingHosp("PHAIN_DrugUseLimit")
    q 0
}

/// Description:科室用药目录 - 配置数据
ClassMethod KLDLConfig()
{
    /* PHAIN_LocDrugList,PHAIN_LocDrugListItm,PHAIN_LocDrugDocItm */
    k ^CF.PHA.IN.LocDrugList
    k ^CF.PHA.IN.LocDrugDocItm
    k ^CF.PHA.IN.LocDrugListItm
    k ^CF.PHA.IN.LocDrugListi
    d ..DeleteBDPMappingHosp("PHAIN_LocDrugList")
    q 0
}

/// Description: 毒麻药品管理 - 业务数据
ClassMethod KNARCBusiness()
{
    /* PHAIN_NarcRecord,PHAIN_NarcRecordRec,PHAIN_NarcDestroyItm,PHAIN_NarcDestroyItm */
    k ^BS.PHA.IN.NarcRecord
    k ^BS.PHA.IN.NarcRecordI
    k ^BS.PHA.IN.NarcDestroy
    k ^BS.PHA.IN.NarcDestroyI
    
    /* 交接班管理 */
    k ^BS.PHA.IN.NarcBaseD
    k ^BS.PHA.IN.NarcBaseI
    k ^BS.PHA.IN.NarcBaseLogD
    k ^BS.PHA.IN.NarcBaseLogI
    k ^BS.PHA.IN.NarcHandD
    k ^BS.PHA.IN.NarcHandI
    
    q 0
}

/// Description: 草药房 - 配置数据
ClassMethod kHERBConfig()
{
    k ^CF.PHA.IN.PROD, ^CF.PHA.IN.PROI
    d ..DeleteBDPMappingHosp("CF_PHA_IN.Process")
    q 0
}

/// Description: 草药房 - 业务数据
ClassMethod KHERBBusiness()
{
    &SQL(TRUNCATE TABLE BS_PHA_HERB.DISPEN)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.DISITEM)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.DISITMCLB)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.State)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.RETREQUEST)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.RETREQITEM)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.RETURN)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.RETURNITEM)
    &SQL(TRUNCATE TABLE BS_PHA_HERB.PrescLogistics)
    &SQL(TRUNCATE TABLE BS_PHA_IN.DeliveryAddress)
    q 0
}

/// Descripotion: 公共业务记录
/// w ##class(web.DHCST.Tools.ClearData).KCOMBS()
ClassMethod KCOMBS()
{
    &SQL(TRUNCATE TABLE BS_PHA_IN.Remark)
    &SQL(TRUNCATE TABLE BS_PHA_IN.InterfaceLog)
    &SQL(TRUNCATE TABLE BS_PHA_IN.Status)
    &SQL(TRUNCATE TABLE BS_PHA_IN.OperateLog)
    &SQL(TRUNCATE TABLE BS_PHA_IN.SelectRecordLog)
    q $$$OK
}

/// Descripotion: 清除日志信息
/// w ##class(web.DHCST.Tools.ClearData).KCOMBS()
ClassMethod KLog()
{
    /* 业务数据日志 */
     &SQL(TRUNCATE TABLE BS_PHA_IN.DataLog)

    /* 运行日志 */
     &SQL(TRUNCATE TABLE BS_PHA_IN.RunLog)
    
    /* 错误日志 */
    k ^DHCSTERROR

    /* 接口日志 */
    &SQL(TRUNCATE TABLE BS_PHA_IN.InterfaceLog)

    /* 操作日志 */
    &SQL(TRUNCATE TABLE BS_PHA_IN.OperateLog)

    /* 任务日志 */
    &SQL(TRUNCATE TABLE BS_PHA_IN.TaskHistory)
}

}
