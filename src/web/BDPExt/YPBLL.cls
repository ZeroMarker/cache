Import SQLUser

Class web.BDPExt.YPBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 过程：先保存药学项，库存项 ，再去保存医嘱项 收费项， ARCIM_PHCDF_DR-->药学项子表 Phc_DrgForm，
/// INCI_OriginalARCIM_DR-->ARC_ItmMast医嘱项表
ClassMethod SaveEntity(Ceobj As web.BDPExt.YPEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	//字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
	//Sp售价  Rp 进价
	//INCICTUOMPurchDR入库单位   INCICTUOMDR基本单位
	s inciliststr="INCICTUOMDR^"_Ceobj.INCICTUOMDR_"|INCICTUOMPurchDR^"_Ceobj.INCICTUOMPurchDR_"|INCIINCSCDR^"_Ceobj.INCIINCSCDR_"|INCALIAS^"_Ceobj.INCALIAS_"|INCINotUseFlag^"_Ceobj.INCINotUseFlag_"|INCIBarCode^"_Ceobj.INCIBarCode
	s inciliststr=inciliststr_"|Sp^"_Ceobj.Sp_"|Rp^"_Ceobj.Rp_"|PriceDate^"_Ceobj.PriceDate_"|INFOSpec^"_Ceobj.INFOSpec_"|INFOImportFlag^"_Ceobj.INFOImportFlag_"|INFOQualityLevel^"_Ceobj.INFOQualityLevel_"|INFOOTC^"_Ceobj.INFOOTC_"|INFOBasicDrug^"_Ceobj.INFOBasicDrug_"|INFOCodex^"_Ceobj.INFOCodex_"|INFOTest^"_Ceobj.INFOTest
	s inciliststr=inciliststr_"|INFORec^"_Ceobj.INFORec_"|INFOQualityNo^"_Ceobj.INFOQualityNo_"|INFOComFrom^"_Ceobj.INFOComFrom_"|INFORemark^"_Ceobj.INFORemark_"|INFOHighPrice^"_Ceobj.INFOHighPrice_"|INFOMTDR^"_Ceobj.INFOMTDR_"|INFOMaxSp^"_Ceobj.INFOMaxSp_"|INFOInHosFlag^"_Ceobj.INFOInHosFlag_"|INFOPbRp^"_Ceobj.INFOPbRp
	s inciliststr=inciliststr_"|INFOPbVendorDR^"_Ceobj.INFOPbVendorDR_"|INFOPbManfDR^"_Ceobj.INFOPbManfDR_"|INFOPbCarrierDR^"_Ceobj.INFOPbCarrierDR_"|INFOPBLevel^"_Ceobj.INFOPBLevel_"|INFOBAflag^"_Ceobj.INFOBAflag_"|INFOPrcFile^"_Ceobj.INFOPrcFile_"|INFOPrcFileD^"_Ceobj.INFOPrcFileD_"|INFOSkinTest^"_Ceobj.INFOSkinTest_"|INFOBCDr^"_Ceobj.INFOBCDr
	s inciliststr=inciliststr_"|INFODrugUse^"_Ceobj.INFODrugUse_"|INFODrugbase2^"_Ceobj.INFODrugbase2_"|INFOPDrugbase1^"_Ceobj.INFOPDrugbase1_"|INFOPDrugbase2^"_Ceobj.INFOPDrugbase2_"|INFOStandardCode^"_Ceobj.INFOStandardCode_"|INFOInMedBasis^"_Ceobj.INFOInMedBasis_"|INFOPackUom^"_Ceobj.INFOPackUom_"|INFOPackUomFactor^"_Ceobj.INFOPackUomFactor
	s inciliststr=inciliststr_"|ISCCommonTemp^"_Ceobj.ISCCommonTemp_"|ISCDry^"_Ceobj.ISCDry_"|ISCAirtight^"_Ceobj.ISCAirtight_"|ISCDark^"_Ceobj.ISCDark_"|ISCVentilate^"_Ceobj.ISCVentilate_"|ISCRadiation^"_Ceobj.ISCRadiation_"|ISCSeal^"_Ceobj.ISCSeal_"|ISCCoolGloomy^"_Ceobj.ISCCoolGloomy_"|ISCGloomyCool^"_Ceobj.ISCGloomyCool_"|ISCMeltPack^"_Ceobj.ISCMeltPack
	s inciliststr=inciliststr_"|ISCCOLDST^"_Ceobj.ISCCOLDST_"|ISCFREEZE^"_Ceobj.ISCFREEZE_"|ISCDAMPPROOF^"_Ceobj.ISCDAMPPROOF_"|ISCMinHumidity^"_Ceobj.ISCMinHumidity_"|ISCMaxHumidity^"_Ceobj.ISCMaxHumidity_"|ISCMinTemp^"_Ceobj.ISCMinTemp_"|ISCMaxTemp^"_Ceobj.ISCMaxTemp   ///_"|INFOISCDR^"_Ceobj.INFOISCDR   
	s inciliststr=inciliststr_"|INCIReportingDays^"_Ceobj.INCIReportingDays  //2018-10-12 增加协和码


	s phcdatastr="INCICode^"_Ceobj.INCICode_"|INCIDesc^"_Ceobj.INCIDesc_"|PHCDFPHCFDR^"_Ceobj.PHCDFPHCFDR_"|PHCDFPHCINDR^"_Ceobj.PHCDFPHCINDR_"|PHCDFPHCDUDR^"_Ceobj.PHCDFPHCDUDR_"|PHCDFBaseQty^"_Ceobj.PHCDFBaseQty_"|PHCDPHMNFDR^"_Ceobj.PHCDPHMNFDR_"|PHCDPHCPODR^"_Ceobj.PHCDPHCPODR_"|PHCDFPHCFRDR^"_Ceobj.PHCDFPHCFRDR_"|PHCDOfficialCode^"_Ceobj.PHCDOfficialCode
	s phcdatastr=phcdatastr_"|PHCDGenericDR^"_Ceobj.PHCDGenericDR_"|PHCDLabelName21^"_Ceobj.PHCDLabelName21_"|PHCDLabelName22^"_Ceobj.PHCDLabelName22_"|PHCDLabelName1^"_Ceobj.PHCDLabelName1_"|PHCDFOfficialCode1^"_Ceobj.PHCDFOfficialCode1_"|PHCDFOfficialCode2^"_Ceobj.PHCDFOfficialCode2_"|PHCDFDeductPartially^"_Ceobj.PHCDFDeductPartially_"|PHCDFCalcuDose^"_Ceobj.PHCDFCalcuDose
	s phcdatastr=phcdatastr_"|PHCDFOPSkinTestYY^"_Ceobj.PHCDFOPSkinTestYY_"|PHCDFIPSkinTestYY^"_Ceobj.PHCDFIPSkinTestYY_"|PHCDFAntibioticFlag^"_Ceobj.PHCDFAntibioticFlag_"|PHCDFCriticalFlag^"_Ceobj.PHCDFCriticalFlag_"|PHCDFWHONET^"_Ceobj.PHCDFWHONET_"|PHCDFCHPhSpecInstr^"_Ceobj.PHCDFCHPhSpecInstr_"|PHCDFWHODDD^"_Ceobj.PHCDFWHODDD_"|PHCDFWHODDDUomDr^"_Ceobj.PHCDFWHODDDUomDr_"|PHCDFivgttSpeed^"_Ceobj.PHCDFivgttSpeed_"|PHCDFGranulesFact^"_Ceobj.PHCDFGranulesFact
	s phcdatastr=phcdatastr_"|PHCDFProvinceComm^"_Ceobj.PHCDFProvinceComm_"|DHCPHCCat1^"_Ceobj.DHCPHCCat1_"|DHCPHCCat2^"_Ceobj.DHCPHCCat2_"|DHCPHCCat3^"_Ceobj.DHCPHCCat3_"|DHCPHCCat4^"_Ceobj.DHCPHCCat4_"|DHCPHCCat5^"_Ceobj.DHCPHCCat5_"|DHCPHCCat6^"_Ceobj.DHCPHCCat6_"|DHCPHCCat7^"_Ceobj.DHCPHCCat7_"|EQCTUOMDR1^"_Ceobj.EQCTUOMDR1_"|EQQty1^"_Ceobj.EQQty1
	s phcdatastr=phcdatastr_"|EQDefaultDose1^"_Ceobj.EQDefaultDose1_"|EQCTUOMDR2^"_Ceobj.EQCTUOMDR2_"|EQQty2^"_Ceobj.EQQty2_"|EQDefaultDose2^"_Ceobj.EQDefaultDose2
	
	///s ^TMP("BDP","inciliststr")=inciliststr
	///s ^TMP("BDP","phcdatastr")=phcdatastr
	
	
	Ts       
	//药学项与库存项
	//s importret= ##class(web.DHCST.Tools.InputDrugBasicData).SaveDrug(^TMP("BDP","inciliststr"), ^TMP("BDP","phcdatastr"))
	try
	{
		s importret= ##class(web.DHCST.Tools.InputDrugBasicData).SaveDrug(inciliststr, phcdatastr)  //药学项id^库存项id - 成功,<0 - 失败
	
	}
	catch myvar
	{
		s importret="-1^"_$ze
	}
	if (importret["^")
	{
		s drugID=$p(importret,"^",1)
		s inciID=$p(importret,"^",2)
		if inciID>0
		{
			S INCIIsTrfFlag=$P($G(^INCI(inciID,2)),"^",6)
			i INCIIsTrfFlag["Both" s $P(^INCI(inciID,2),"^",6)="B"   ///Both Iss & Trf  表结构有问题
			///后勤类材料不需要导医嘱项
		    ///医用卫生材料中（收费）的有医嘱项,医用卫生材料中（非收费类）一般也不用医嘱项
		
			//s yzxobj=##class(web.BDPExt.YZXEntity).%New()
			s yzxobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.BDPExt.YZXEntity")  ///2017-12-07 无需每次医嘱或收费项加了字段都要改entity,除非模板里名字和实体类里不一样
			s yzxobj.ARCIMCode=Ceobj.INCICode  //医嘱项代码=库存项代码
			s yzxobj.ARCIMDesc=Ceobj.INCIDesc  //医嘱项名称=库存项名称
			s yzxobj.ARCIMAbbrev=Ceobj.INCIDesc  //医嘱项简称=库存项名称
			s yzxobj.ARCIMItemCatDR=Ceobj.OrdSubCat
			s yzxobj.ARCIMBillSubDR=Ceobj.BillSubCat
			s yzxobj.ARCIMPHCDFDR=drugID	  ///PHCDrgForm
			s yzxobj.ARCIMEffDate=Ceobj.ARCIMEffDate
			s yzxobj.ARCIMEffDateTo=Ceobj.ARCIMEffDateTo
			s yzxobj.ARCIMDefPriorityDR=Ceobj.Priority
			s yzxobj.ARCIMOrderOnItsOwn=Ceobj.Onitsown
			i (yzxobj.ARCIMOrderOnItsOwn'="N") s yzxobj.ARCIMOrderOnItsOwn="Y"
			s yzxobj.ALIASText=Ceobj.INCALIAS
			
			s yzxobj.TARICode=Ceobj.INCICode   //收费项代码=库存项代码
			s yzxobj.TARIDesc=Ceobj.INCIDesc   //收费项名称=库存项名称
			//INCICTUOMPurchDR入库单位   INCICTUOMDR基本单位
			//计算基本单位对应的价格   2017-03-21
			s yzxobj.TPPrice=Ceobj.Sp/Ceobj.INCICTUOMPurchFac
			s yzxobj.ARCIMOEMessage=Ceobj.ARCIMOEMessage   //医嘱备注20170802
			s yzxobj.ARCIMBillingUOMDR=Ceobj.ARCIMBillingUOMDR     //医嘱项走计价单位
			s yzxobj.TARIUOM=Ceobj.INCICTUOMDR     //收费项走基本单位
			s yzxobj.TARISubCate=Ceobj.TarSubCat
			s yzxobj.TARIInpatCate=Ceobj.InpaSubCat
			s yzxobj.TARIOutpatCate=Ceobj.OutpaSubCat
			s yzxobj.TARIEMCCate=Ceobj.EmSubCat
			s yzxobj.TARIAcctCate=Ceobj.AcctSubCat
			s yzxobj.TARIMRCate=Ceobj.MrSubCat
			s yzxobj.TARIMCNew=Ceobj.MrSubCatNew   
			s yzxobj.TIAAlias=Ceobj.INCALIAS
			s yzxobj.TARIInsuName=Ceobj.InsuDesc
			s yzxobj.TARIConnote=Ceobj.TARIConnote
			s yzxobj.TARIRemark=Ceobj.TARIRemark
			s yzxobj.TARIExclude=Ceobj.TARIExclude
			s yzxobj.TARIChargeBasis=Ceobj.TARIChargeBasis
			s yzxobj.TARIEngName=Ceobj.TARIEngName
			s yzxobj.TARIExternalCode=Ceobj.TARIExternalCode
			s arcimresult=##class(web.BDPExt.YXZBLL).SaveEntity(yzxobj)
			i arcimresult["success:'true'"
			{
				s arcimID=##class(web.BDPExt.FunLib).GetResultRowId(arcimresult)
				///保存完医嘱项后要修改库存项里的医嘱项dr，指向这条医嘱项
				IF arcimID["||"
				{
					s inciobj=##class(User.INCItm).%OpenId(inciID,0)
					Do inciobj.INCIOriginalARCIMDRSetObjectId(arcimID) 
					s sc=inciobj.%Save()
					do inciobj.%Close()
					if $$$ISERR(sc)
					{
						s ImportResult="{success:'false',errorinfo:'保存库存项的医嘱项指针失败！'}" 
					}
				}
				else
				{
					s ImportResult="{success:'false',errorinfo:'保存库存项的医嘱项指针失败!'}" 
				}
			}
			else
			{
				s ImportResult=arcimresult
			}	
		}
		else
		{
			s ImportResult= "药品保存失败："_inciID_"！"    ///20170809 调用药品组的程序 返回值有问题
		}
	}
	else
	{	
		s msg=importret
		if importret=-94 s msg="价格保存失败"
		if importret=-1009 s msg="基本单位"_"为空"
		if importret=-1010 s msg="基本单位"_"不存在"
		if importret=-1011 s msg="基本单位"_"不存在,插入失败"
		if importret=-1012 s msg="入库单位"_"为空"
		if importret=-1013 s msg="入库单位"_"不存在"
		if importret=-1014 s msg="入库单位"_"不存在,插入失败"
		if importret=-1015 s msg="库存分类"_"为空"
		if importret=-1016 s msg="库存分类"_"不存在"
		if importret=-1017 s msg="库存分类"_"不存在,插入失败"
		if importret=-1018 s msg="价格生效日期(yyyy-MM-dd)"_"格式错误"
		if importret=-1019 s msg="进口标志"_"不为(国产,进口,合资)之一"
		if importret=-1020 s msg="质量层次"_"不存在" 
		if importret=-1021 s msg="质量层次"_"不存在,插入失败"
		if importret=-1022 s msg="处方药分类"_"不为(处方药,非处方药)之一"
		if importret=-1023 s msg="批准文号"_"需以'-'分隔"
		if importret=-1024 s msg="定价类型"_"不存在"
		if importret=-1025 s msg="定价类型"_"不存在,插入失败"
		if importret=-1026 s msg="招标供应商"_"不存在"
		if importret=-1027 s msg="招标供应商"_"不存在,插入失败"
		if importret=-1028 s msg="招标生产商"_"不存在"
		if importret=-1029 s msg="招标生产商"_"不存在,插入失败"
		if importret=-1030 s msg="招标配送商"_"不存在"
		if importret=-1031 s msg="招标配送商"_"不存在,插入失败"
		if importret=-1032 s msg="招标级别"_"不存在"
		if importret=-1033 s msg="招标级别"_"不存在,插入失败"
		if importret=-1034 s msg="物价备案时间(yyyy-MM-dd)"_"格式错误"
		if importret=-1035 s msg="帐簿分类"_"不存在"
		if importret=-1036 s msg="帐簿分类"_"不存在,插入失败"
		if importret=-1037 s msg="大包装单位"_"为空"
		if importret=-1038 s msg="大包装单位"_"不存在"
		if importret=-1039 s msg="大包装单位"_"不存在,插入失败"
		
		if importret=-2001 s msg="药品代码"_"为空"
		if importret=-2002 s msg="药品代码"_"已存在于库存项"
		if importret=-2003 s msg="药品代码"_"已存在于医嘱项"
		if importret=-2004 s msg="药品代码"_"已存在于药学项"
		if importret=-1005 s msg="药品代码"_"为空"
		if importret=-2006 s msg="药品名称"_"已存在于库存项"
		if importret=-2007 s msg="药品代码"_"已存在于医嘱项"
		if importret=-2008 s msg="药品名称"_"已存在于药学项"
		if importret=-2009 s msg="剂型"_"为空"
		if importret=-2010 s msg="剂型"_"不存在"
		if importret=-2011 s msg="剂型"_"不存在,插入失败"
		if importret=-2012 s msg="用法"_"为空"
		if importret=-2013 s msg="用法"_"不存在"
		if importret=-2014 s msg="用法"_"不存在,插入失败"
		if importret=-2015 s msg="疗程"_"为空"
		if importret=-2016 s msg="疗程"_"不存在"
		if importret=-2017 s msg="厂商"_"为空"
		if importret=-2018 s msg="厂商"_"不存在,插入失败"
		if importret=-2019 s msg="管制分类"_"不存在"
		if importret=-2020 s msg="管制分类"_"不存在,插入失败"
		if importret=-2021 s msg="频次"_"不存在"
		if importret=-2022 s msg="频次"_"不存在,插入失败"
		if importret=-2023 s msg="医保类别"_"不存在"
		if importret=-2024 s msg="医保类别"_"不存在,插入失败"
		if importret=-2025 s msg="通用名"_"不存在"
		if importret=-2026 s msg="通用名"_"不存在,插入失败"
		if importret=-2027 s msg="whonet码"_"不存在"
		if importret=-2028 s msg="whonet码"_"不存在,插入失败"
		if importret=-2029 s msg="WhoDDD单位"_"为空"
		if importret=-2030 s msg="WhoDDD单位"_"不存在"
		if importret=-2031 s msg="WhoDDD单位"_"不存在,插入失败"
		if importret=-2032 s msg="基本单位"_"为空"
		if importret=-2033 s msg="基本单位"_"不存在"
		if importret=-2034 s msg="基本单位"_"不存在,插入失败"
		if importret=-2035 s msg="等效单位1"_"为空"
		if importret=-2036 s msg="等效单位1"_"不存在"
		if importret=-2037 s msg="等效单位1"_"不存在,插入失败"
		if importret=-2038 s msg="等效单位2"_"为空"
		if importret=-2039 s msg="等效单位2"_"不存在"
		if importret=-2040 s msg="等效单位2"_"不存在,插入失败"
		if importret=-2041 s msg="WhoDDD单位不为基本单位或等效单位"
		if importret=-2042 s msg="草药备注字典不存在"
		if importret=-2043 s msg="草药备注不存在"
		if (importret<-3300)&&(importret>-3310) s msg="药学"_(-importret-3300)_"级分类不存在,插入失败" 
		if (importret<-3200)&&(importret>-3300) s msg="药学"_(-importret-3200)_"级分类不存在"
		if (msg="") s msg=importret
		s ImportResult= "药品保存失败："_msg_"！" 
	}
	if (ImportResult="")
	{
		Tc
		s ImportResult="{success:'true',id:'"_drugID_"'}"  ///返回药学项单位
	}
	else
	{
		Tro
	}
	q ImportResult
ERROR
	Q "导入报错"_$ZE
}

/// Creator:陈莹
/// CreatDate:2016-12-14
/// Description:数据重复验证方法,导入药品数据时调用
/// Table:User.PHCDrgMast
/// Input: code, desc(PHCDName)
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.BDPExt.YPBLL).FormValidate("","")
/// s ^Config.BDPSpeConfig("PHCDCONFIG")="false"
ClassMethod FormValidate(code As %String, desc As %String) As %String
{
	new (code,desc)
	s flag=""
	if ($$ALPHAUP^SSUTIL4(code)'="")
	{
		s idc=0
		for
		{
			s idc=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			s Value=$p($g(^PHCD(idc,1)),"^",1)
			if (Value=code)
			{
				s flag=1
				q
			}
			
		}
		
	}
	if ($p($g(^Config.BDPSpeConfig("PHCDCONFIG")),"^",1)'="false")
	{
		if ($$ALPHAUP^SSUTIL4(desc)'="")
		{
			s idc=0
			for
			{
				s idc=$o(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(desc),idc)) q:idc=""
				s Value=$p($g(^PHCD(idc,1)),"^",2)
				if (Value=desc)
				{
					s flag=1
					q
				}
				
			}
			
		}
	}
	
	q flag
}

/// Creator:陈莹
/// CreatDate:2017-09-06
/// Description:通过库存项rowid获取规格
/// w ##class(web.BDPExt.YPBLL).GetINFOSpecByRowId("1")
ClassMethod GetINFOSpecByRowId(INCIRowId) As %String
{
	n (INCIRowId)
	q:INCIRowId="" ""
	s INFOSpec=""
	s INFOSpecRowId=$O(^DHCITMINFO(0,"INCI",INCIRowId,0))
	s:INFOSpecRowId'="" INFOSpec=$p($g(^DHCITMINFO(INFOSpecRowId)),"^",27)
	s INFOSpec=##class(web.DHCBL.BDP.FunLib).Util(INFOSpec)
	q INFOSpec
}

}
