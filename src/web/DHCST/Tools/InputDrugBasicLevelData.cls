Import sqluser

/// creator:	yunhaibao
/// createdate:	2017-09-19
/// description:给基础数据平台导入数据调用,导入库存项,药学项等分级别基础数据
/// 			最终保存方法调用药品信息维护的保存程序
/// 			用法,频次等信息基础数据平台传Id,已初步验证,本类再次做验证
/// 			
/// others:	
Class web.DHCST.Tools.InputDrugBasicLevelData Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/**********************************************1级数据-药学分类**********************************************/
/// 药学分类-代码
Property PHCCCode As %String;

/// 药学分类-名称
Property PHCCDesc As %String;

/**********************************************2级数据-化学通用名**********************************************/
/// 化学通用名-代码
Property PHCMCode As %String;

/// 化学通用名-名称
Property PHCMDesc As %String;

/**********************************************3级数据-处方通用名**********************************************/
/// 处方通用名-代码
Property PHCGECode As %String;

/// 处方通用名-名称
Property PHCGEName As %String;

/// 处方通用名-别名
Property DataAlias As %String;

/// 处方通用名-剂型(Id)
Property PHCGEPHCFDr As %String;

/**********************************************4级数据-医嘱项+药学项**********************************************/
/// 药学项-处方通用名
Property PHCDGenericDR As %String;

/// 医嘱项-代码
Property ARCIMCode As %String;

/// 医嘱项-名称
Property ARCIMDesc As %String;

/// 药学项-用法(名称)
Property PHCDFPHCINDR As %String;

/// 药学项-疗程(名称)
Property PHCDFPHCDUDR As %String;

/// 药学项-基本单位(数字)
Property PHCDFCTUOMDR As %String;

/// 药学项-基本数量(默认1,目前没用)
Property PHCDFBaseQty As %String;

/// 药学项-基本单位转换系数(数字)
Property PHCDFCTUOMFac As %String;

/// 药学项-厂商(全称)
Property PHCDPHMNFDR As %String;

/// 药学项-管制分类(名称)
Property PHCDPHCPODR As %String;

/// 药学项-频次(名称)
Property PHCDFPHCFRDR As %String;

/// 药学项-医保类别(停用)
Property PHCDOfficialCode As %String;

/// 药学项-英文国际非专利药名
Property PHCDLabelName21 As %String;

/// 药学项-国际专利药名
Property PHCDLabelName22 As %String;

/// 药学项-商品名
Property PHCDLabelName1 As %String;

/// 药学项-制剂通用名
Property PHCDFOfficialCode1 As %String;

/// 药学项-原料通用名
Property PHCDFOfficialCode2 As %String;

/// 药学项-住院一天量标志(Y/N)
Property PHCDFDeductPartially As %String;

/// 药学项-门诊一天量标志(Y/N)
Property PHCDFCalcuDose As %String;

/// 药学项-门诊皮试用原液(Y/N)
Property PHCDFOPSkinTestYY As %String;

/// 药学项-住院皮试用原液(Y/N)
Property PHCDFIPSkinTestYY As %String;

/// 药学项-抗菌药标志(Y/N)
Property PHCDFAntibioticFlag As %String;

/// 药学项-危重药标志(Y/N)
Property PHCDFCriticalFlag As %String;

/// 药学项-WHONET码
Property PHCDFWHONET As %String;

/// 药学项-草药备注
Property PHCDFCHPhSpecInstr As %String;

/// 药学项-DDD值
Property PHCDFDDD As %String;

/// 药学项-WhoDDD值
Property PHCDFWHODDD As %String;

/// 药学项-WhoDDD单位(名称)
Property PHCDFWHODDDUomDr As %String;

/// 药学项-滴速(数字,对应单位gtt/min)
Property PHCDFivgttSpeed As %String;

/// 药学项-颗粒单位系数
Property PHCDFGranulesFact As %String;

/// 药学项-省属常用药物(Y/N)
Property PHCDFProvinceComm As %String;

/// 药学项-含量规格
Property PHCDFSpec As %String;

/// 药学项-处方药分类(甲类/乙类/双跨)
Property INFOOTC As %String;

/// 药学项-基本药物标志(Y/N)
Property INFOBasicDrug As %String;

/// 药学项-中国药典标志(Y/N)
Property INFOCodex As %String;

/// 药学项-临床验证用药标志(Y/N)
Property INFOTest As %String;

/// 药学项-省基本药物标志(Y/N)
Property INFODrugbase2 As %String;

/// 药学项-市级基本药物(Y/N)
Property INFOPDrugbase1 As %String;

/// 药学项-区(县)基本药物(Y/N)
Property INFOPDrugbase2 As %String;

/// 药学项-长期默认嘱托(Y/N)
Property PHCDFCQZTFlag As %String;

/// 药学项-临时默认取药(Y/N)
Property PHCDFONEFlag As %String;

/// 药学项-TPN标志(Y/N)
Property PHCDFTpnFlag As %String;

/// 药学项-等效单位1(名称)
Property EQCTUOMDR1 As %String;

/// 药学项-等效数量1
Property EQQty1 As %String;

/// 药学项-缺省数量1
Property EQDefaultDose1 As %String;

/// 药学项-等效单位2(名称)
Property EQCTUOMDR2 As %String;

/// 药学项-等效数量2
Property EQQty2 As %String;

/// 药学项-缺省数量2
Property EQDefaultDose2 As %String;

/**********************************************5级数据-库存项+收费项**********************************************/
/// 库存项-代码
Property INCICode As %String;

/// 库存项-名称
Property INCIDesc As %String;

/// 库存项-库存分类
Property INCIINCSCDR As %String;

/// 库存项-基本单位(名称)
Property INCICTUOMDR As %String;

/// 库存项-入库单位(名称)
Property INCICTUOMPurchDR As %String;

/// 库存项-别名("/"分隔)-todo
Property INCALIAS As %String;

/// 库存项-不可用标志(Y/N)
Property INCINotUseFlag As %String;

/// 库存项-条码
Property INCIBarCode As %String;

/// 库存项-售价
Property Sp As %String;

/// 库存项-进价
Property Rp As %String;

/// 库存项-价格生效日期(yyyy-MM-dd,空为当天)
Property PriceDate As %String;

/// 库存项-包装规格
Property INFOSpec As %String;

/// 库存项-进口标志(国产/进口/合资)
Property INFOImportFlag As %String;

/// 库存项-质量层次
Property INFOQualityLevel As %String;

/// 库存项-处方购药标志(Y/N)
Property INFORec As %String;

/// 库存项-质量编号
Property INFOQualityNo As %String;

/// 库存项-国(省)别
Property INFOComFrom As %String;

/// 库存项-批准文号(国药准字-H0023N1)
Property INFORemark As %String;

/// 库存项-高值类标志(Y/N)
Property INFOHighPrice As %String;

/// 库存项-定价类型(名称)
Property INFOMTDR As %String;

/// 库存项-最高售价
Property INFOMaxSp As %String;

/// 库存项-本院药品目录标志(Y/N)
Property INFOInHosFlag As %String;

/// 库存项-招标进价
Property INFOPbRp As %String;

/// 库存项-招标供应商(全称)
Property INFOPbVendorDR As %String;

/// 库存项-招标生产商(全称)
Property INFOPbManfDR As %String;

/// 库存项-招标配送商(全称)
Property INFOPbCarrierDR As %String;

/// 库存项-招标级别
Property INFOPBLevel As %String;

/// 库存项-阳光采购标志(Y/N)
Property INFOBAflag As %String;

/// 库存项-物价文件号
Property INFOPrcFile As %String;

/// 库存项-物价文件备案时间(yyyy-MM-dd)
Property INFOPrcFileD As %String;

/// 库存项-皮试标志(Y/N)
Property INFOSkinTest As %String;

/// 库存项-帐簿分类(名称)
Property INFOBCDr As %String;

/// 库存项-用药说明
Property INFODrugUse As %String;

/// 库存项-药品本位码
Property INFOStandardCode As %String;

/// 库存项-进药依据
Property INFOInMedBasis As %String;

/// 库存项-大包装单位
Property INFOPackUom As %String;

/// 库存项-大包装单位系数
Property INFOPackUomFactor As %String;

/// 库存项-门诊发药单位
Property INCICTUOMOutPatDR As %String;

/// 库存项-门诊发药单位转换系数
Property INCICTUOMOutPatFac As %String;

/// 库存项-住院发药单位
Property INCICTUOMInPatDR As %String;

/// 库存项-住院发药单位转换系数
Property INCICTUOMInPatFac As %String;

/// 库存项-协和码
Property INCIReportingDays As %String;

/// 存储条件-常温(Y/N)
Property ISCCommonTemp As %String;

/// 存储条件-干燥(Y/N)
Property ISCDry As %String;

/// 存储条件-密闭(Y/N)
Property ISCAirtight As %String;

/// 存储条件-避光(Y/N)
Property ISCDark As %String;

/// 存储条件-通风(Y/N)
Property ISCVentilate As %String;

/// 存储条件-防辐射(Y/N)
Property ISCRadiation As %String;

/// 存储条件-熔封(Y/N)
Property ISCSeal As %String;

/// 存储条件-阴凉(Y/N)
Property ISCCoolGloomy As %String;

/// 存储条件-凉暗(Y/N)
Property ISCGloomyCool As %String;

/// 存储条件-密封(Y/N)
Property ISCMeltPack As %String;

/// 存储条件-冷藏(Y/N)
Property ISCCOLDST As %String;

/// 存储条件-冷冻(Y/N)
Property ISCFREEZE As %String;

/// 存储条件-防潮(Y/N)
Property ISCDAMPPROOF As %String;

/// 存储条件-最低湿度
Property ISCMinHumidity As %String;

/// 存储条件-最高湿度
Property ISCMaxHumidity As %String;

/// 存储条件-最低温度
Property ISCMinTemp As %String;

/// 存储条件-最高温度
Property ISCMaxTemp As %String;

/// 收费项-子分类
Property TarSubCat As %String;

/// 收费项-住院子分类
Property InpaSubCat As %String;

/// 收费项-门诊子分类
Property OutpaSubCat As %String;

/// 收费项-核算子分类
Property EmSubCat As %String;

/// 收费项-病案首页分类
Property MrSubCat As %String;

/// 收费项-会计子分类
Property AcctSubCat As %String;

/// 收费项-新病案首页
Property MrCatNew As %String;

/// 收费项-项目内涵
Property TARIConnote As %String;

/// 收费项-收费项目备注
Property TARIRemark As %String;

/// 收费项-除外内容
Property TARIExclude As %String;

/**********************************************错误信息**********************************************/
Property ErrorCode As %String;

/// creator:	 yunhaibao
/// createdate:	 2018-11-06
/// description: 保存药学项\库存项\收费项数据(收费项数据数据平台存?)
/// return:		 $p(ret,"^",1)<0:失败,$p(ret,"^",2):失败信息
/// 			 成功:药学项Id^库存项Id
/// w ##class(web.DHCST.Tools.InputDrugBasicLevelData).SaveDrug(1)
ClassMethod SaveDrug(level1List, level2List = "", level3List = "", level4List = "", level5List = "") As %String
{
	n (level1List,level2List,level3List,level4List, level5List,%session)
	//i level1List="1" d
	//.s level1List="INCICode^XWY000002cs11111|INCIDesc^盐酸利多卡因胶浆[2%*10ML]cs11111|INCALIAS^LSNYGCY(HL)[133ML]/LSNYGCY/HL/DSQFIEIIL/LSNYGCYHL/XWY000002/盐酸利多卡因胶浆[2%*10ML]|Rp^|Sp^54.1|INCICTUOMPurchDR^3|INCICTUOMPurchFac^1|INCICTUOMDR^3|INC ICTUOMOutPatDR^3|INCICTUOMOutPatFac^1|INCICTUOMInPatDR^3|INCICTUOMInPatFac^1|INFOSpec^|INCIINCSCDR^16|INFOSkinTest^|INFOPDrugbase2^|INFOPDrugbase1^|INFORemark^|INFODrugbase2^|INFOBasicDrug^|INFOBAflag^|INFOInHosFlag^|INFORec^|INFOTest^|INFOCodex^|INCINotUseFlag^|INFOPackUom^|INFOPackUomFactor^|INFOMTDR^|INFOOTC^|INFOQualityLevel^|INFOImportFlag^|PriceDate^|INCIBarCode^|INFOQualityNo^|INFOInMedBasis^|INCIReportingDays^|INFOStandardCode^|INFOMaxSp^|INFOPbManfDR^|INFOPbVendorDR^|INFOPbRp^|INFOHighPrice^|INFOComFrom^|INFOBCDr^|INFOPrcFileD^|INFOPrcFile^|INFOPBLevel^|INFOPbCarrierDR^|ISCDark^|ISCAirtight^|ISCDry^|ISCCommonTemp^|INFODrugUse^|ISCGloomyCool^|ISCCoolGloomy^|ISCSeal^|ISCRadiation^|ISCVentilate^|ISCMinHumidity^|ISCDAMPPROOF^|ISCFREEZE^|ISCCOLDST^|ISCMeltPack^|ISCMaxTemp^|ISCMinTemp^|ISCMaxHumidity^"
	//.s level2List="PHCCCode^XWY000002cs8|PHCCDesc^盐酸利多卡因胶浆[2%*10ML]cs8|ARCIMCode^XWY000002cs8|ARCIMDesc^盐酸利多卡因胶浆[2%*10ML]cs8|PHCDFCTUOMDR^3|PHCDGenericDR^7|PHCDFPHCINDR^|PHCDFPHCFDR^|PHCDFCTUOMFac^1|PHCDFCTUOMDR^3|EQDefaultDose1^|EQCTUOMDR1^|EQQty1^|PHCDFPHCDUDR^|PHCDFPHCFRDR^|PHCDPHCPODR^|PHCDPHMNFDR^|EQDefaultDose2^|EQCTUOMDR2^|EQQty2^|PHCDFCQZTFlag^|PHCDFONEFlag^|PHCDFAntibioticFlag^|PHCDFCalcuDose^|PHCDFDeductPartially^|PHCDFDDD^|PHCDFCriticalFlag^|PHCDOfficialCode^|PHCDFIPSkinTestYY^|PHCDFOPSkinTestYY^|PHCDFProvinceComm^|PHCDFTpnFlag^|PHCDFWHODDDUomDr^|PHCDFWHODDD^|PHCDFWHONET^|PHCDLabelName21^|PHCDFOfficialCode2^|PHCDFOfficialCode1^|PHCDLabelName1^|PHCDLabelName22^|PHCDFSpec^|PHCDFGranulesFact^|PHCDFivgttSpeed^|PHCDFCHPhSpecInstr^"
	s obj=..%New()
	s ret=obj.SetPrValue(level1List)
	q:ret<0 ret
	i level2List'="" s ret=obj.SetPrValue(level2List)
	q:ret<0 ret
	i level3List'="" s ret=obj.SetPrValue(level3List)
	q:ret<0 ret
	i level4List'="" s ret=obj.SetPrValue(level4List)
	q:ret<0 ret
	i level5List'="" s ret=obj.SetPrValue(level5List)
	q:ret<0 ret
	/// 保存药学项数据
	s level4Ret=obj.InputLevel4()
	q:$p(level4Ret,"^",1)<0 level4Ret
	s phcdfId=level4Ret
	/// 保存库存项数据
	s level5Ret=obj.InputLevel5()
	q:$p(level5Ret,"^",1)<0 level5Ret
	s incId=level5Ret
	/// s stkCatDr=$p($g(^PHCGE("GE",level3Ret,"DHC")),"^",4)
	/// &SQL(UPDATE INC_Itm SET INCI_INCSC_DR=:stkCatDr WHERE INCI_RowId=:level5Ret1)
	/// 保存收费项信息-平台存
	/// s level6Ret=obj.InputLevel6(level5Ret)
	/// q:level6Ret<0 level6Ret
	q phcdfId_"^"_incId
}

/// creator:	 yunhaibao
/// createdate:	 2018-11-05
/// description: 保存化学通用名\处方通用名字典,并关联药学分类
/// return:		 $p(ret,"^",1)<0:失败,$p(ret,"^",2):失败信息
/// 			 成功:药学分类Id^化学通用名Id^处方通用名Id
ClassMethod SaveChemGene(inputList) As %String
{
	n (inputList)
	s errCode=""
	s obj=..%New()
	s setRet=obj.SetPrValue(inputList)
	q:setRet<0 setRet
	s phccCode=obj.PHCCCode
	s phccDesc=obj.PHCCDesc
	s chemCode=obj.PHCMCode
	s chemDesc=obj.PHCMDesc
	s geneCode=obj.PHCGECode
	s geneDesc=obj.PHCGEName
	s geneAlias=obj.DataAlias
	s geneFormDr=obj.PHCGEPHCFDr
	// 获取-药学分类Id
	s phcCatId=..GetPhcCatIdByCode(phccCode)
	q:$p(phcCatId,"^",1)<0 phcCatId
	// 获取-化学通用名Id,为空时插入
	s chemId=..GetChemIdByCode(chemCode)
	q:$p(chemId,"^",1)<0 chemId
	i chemId="" d
	.s saveStr=""_"^"_chemCode_"^"_chemDesc
	.s chemId=##class(web.DHCST.PHCChemical).Save("",saveStr)
	.i chemId="" s errCode="-1^插入化学通用名失败"
	q:chemId="" errCode
	// 获取处方通用名Id,为空插入
	s geneId=..GetGeneIdByCode(geneCode)
	q:$p(geneId,"^",1)<0 geneId
	i geneId="" d
	.s saveStr=chemId_"^"_geneCode_"^"_geneDesc_"^"_(+$h-1)_"^"_""_"^"_""_"^"_geneFormDr_"^"_phcCatId
	.s geneId=##class(web.DHCST.PHCGeneric).Save("",saveStr)
	q:$p(geneId,"^",1)<0 geneId
	q phcCatId_"^"_chemId_"^"_geneId
}

/// description:保存四级数据,药学项相关信息,医嘱项由基础平台单独保存
/// return:		如果根据药学代码获取到药学项Id,则直接返回Id
Method InputLevel4() As %String
{
	s errCode=""
	s obj=$this
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	/// 药学项-代码
	s phcdCode=obj.ARCIMCode
	/// 药学项-名称
	s phcdDesc=obj.ARCIMDesc
	s valRet=..ValidPhcUnique(phcdCode,phcdDesc)
	q:$p(valRet,"^",1)<0 valRet
	/// 通用名
	s genericId=obj.PHCDGenericDR
	q:genericId="" "-1^处方通用名为空"	
	s phcdId=..GetPhcdIdByCode(phcdCode)
	q:+$p(phcdId,"^",1)<0 phcdId
	q:phcdId'="" phcdId

	/// 剂型
	s formId=..GetFormIdByGeneId(genericId)
	/// 用法
	s instrId=obj.PHCDFPHCINDR
	/// 疗程
	s duraId=obj.PHCDFPHCDUDR
	/// 厂商
	s phManfId=obj.PHCDPHMNFDR
	/// 管制分类
	s poisonId=obj.PHCDPHCPODR
	/// 频次
	s freqId=obj.PHCDFPHCFRDR
	/// 医保类别(已不用)
	s officialCode=""
	/// whonet码
	s whoNetCode=obj.PHCDFWHONET
	s validRet=..ValidWhoNetCode(whoNetCode,1)
	q:$p(validRet,"^",1)<0 validRet
	/// WhoDDD单位
	s whoDDDUom=obj.PHCDFWHODDDUomDr	
	/// 药学项-基本单位
	s phcdUomId=obj.PHCDFCTUOMDR
	/// 基本数量-默认为1
	s phcdUomQty=1
	/// 英文国际非专利药名
	s labelName21=obj.PHCDLabelName21
	/// 国际专利药名
	s labelName22=obj.PHCDLabelName22
	s labelName2=labelName21_"||"_labelName22
	/// 商品名
	s goodName=obj.PHCDLabelName1
	/// 原料通用名
	s officialCode1=obj.PHCDFOfficialCode1
	/// 制剂通用名
	s officialCode2=obj.PHCDFOfficialCode2
	s pdfOfficialCode=officialCode1_"||"_officialCode2
	/// 住院一天量
	s ipOneDay=$s(obj.PHCDFDeductPartially="Y":"Y",1:"")
	/// 门诊一天量
	s opOneDay=$s(obj.PHCDFCalcuDose="Y":"1",1:"")
	/// 门诊皮试用原液
	s opSkinTest=$s(obj.PHCDFOPSkinTestYY="Y":"1",1:"")
	/// 住院皮试用原液
	s ipSkinTest=$s(obj.PHCDFIPSkinTestYY="Y":"1",1:"")
	/// 抗菌药
	s antiFlag=$s(obj.PHCDFAntibioticFlag="Y":"Y",1:"")
	/// 危重药 
	s criticalFlag=$s(obj.PHCDFCriticalFlag="Y":"Y",1:"")
	/// WhoDDD值
	s whoDDD=obj.PHCDFWHODDD
	i whoDDD'="" s whoDDD=+whoDDD
	/// 滴速
	s gttSpeed=obj.PHCDFivgttSpeed
	i gttSpeed'="" s gttSpeed=+gttSpeed
	/// 颗粒单位系数
	s granulesFac=obj.PHCDFGranulesFact
	i granulesFac'="" s granulesFac=+granulesFac
	/// 省属常用药物
	s pCommFlag=$s(obj.PHCDFProvinceComm="Y":"1",1:"")
	/// 草药备注
	s cySpecInstr=obj.PHCDFCHPhSpecInstr
	/// 含量规格
	s phcdSpec=obj.PHCDFSpec
	/// 国家基本药物
	s basicFlag=$s(obj.INFOBasicDrug="Y":"Y",1:"N")
	/// 省基本药物
	s pBasicFlag=$s(obj.INFODrugbase2="Y":"Y",1:"")
	/// 市基本药物
	s cBasicFlag=$s(obj.INFOPDrugbase1="Y":"Y",1:"")
	/// 区县基本药物
	s c1BasicFlag=$s(obj.INFOPDrugbase2="Y":"Y",1:"")
	/// 中国药典
	s codeXFlag=$s(obj.INFOCodex="Y":"Y",1:"N")
	/// 临床验证用药标志
	s testFlag=$s(obj.INFOTest="Y":"Y",1:"N")
	/// 处方药分类 
	s otcFlag=obj.INFOOTC
	i (otcFlag'="")&&(otcFlag'="处方药")&&(otcFlag'="非处方药")&&(otcFlag'="甲类")&&(otcFlag'="乙类")&&(otcFlag'="双跨") d
	.s errCode="-1^处方药分类"_"不为(处方药,非处方药)之一" 
	q:errCode'="" errCode
	/* 等效单位 start */
	s eqUom1=obj.EQCTUOMDR1
	s eqQty1=obj.EQQty1
	s eqDefQty1=obj.EQDefaultDose1
	s eqUom2=obj.EQCTUOMDR2
	s eqQty2=obj.EQQty2
	s eqDefQty2=obj.EQDefaultDose2
	/* 等效单位 end */
	i whoDDDUom'="" d
	.i (whoDDDUom'=phcdUomId)&&(whoDDDUom'=eqUom1)&&(whoDDDUom'=eqUom2) d
	..s errCode="-1^WhoDDD单位不为药学基本单位或等效单位"
	q:errCode'="" errCode
	s DDD=obj.PHCDFDDD   ; DDD值
	i DDD="" d
	.i whoDDDUom'="" d
	..i whoDDDUom=phcdUomId s DDD=whoDDD
	..e  i (whoDDDUom=eqUom1)&&(+eqQty1'=0) s DDD=whoDDD/eqQty1
	..e  i (whoDDDUom=eqUom2)&&(+eqQty2'=0) s DDD=whoDDD/eqQty2		  
	s oldPhcCat="" 	  ; 原药学大类
	s oldPhcSubCat="" ; 原药学子类
	s oldPhcMinCat="" ; 原药学小类
	s ageLimit=""	  ; 年龄限制-不用
	s userId=1		  ; 操作人-默认demo
	s pivaCat="" 	  ; 配液分类
	s highRiskLevel="" ;高危级别
	s singleUse=""    ;单味使用
 	s allergyFlag=""		;过敏
 	s dietTaboo=""			;饮食禁忌
 	s tumbleFlag=""		;跌倒风险
 	s dopeFlag=""	  		;兴奋剂
 	s tpnFlag=$s(obj.PHCDFTpnFlag="Y":"Y",1:"N")			;TPN标志
 	s cqztFlag=$s(obj.PHCDFCQZTFlag="Y":"Y",1:"N")			;长期默认嘱托
 	s oneFlag=$s(obj.PHCDFONEFlag="Y":"Y",1:"N")			;临时默认取药
	s phccCat=..GetPhcCatIdByGeneId(genericId) 				;取化学通用名的
	s phcDataList1=phcdCode_"^"_phcdDesc_"^"_formId_"^"_phcdUomId_"^"_instrId_"^"_duraId_"^"_phcdUomQty_"^"_phManfId_"^"_poisonId_"^"_freqId
	s phcDataList2=officialCode_"^"_genericId_"^"_oldPhcCat_"^"_oldPhcSubCat_"^"_oldPhcMinCat_"^"_labelName21_"^"_labelName22_"^"_goodName_"^"_officialCode2_"^"_officialCode1
	s phcDataList3=ipOneDay_"^"_opOneDay_"^"_opSkinTest_"^"_ipSkinTest_"^"_DDD_"^"_userId_"^"_antiFlag_"^"_criticalFlag_"^"_ageLimit
	s phcDataList4=phccCat_"^"_whoNetCode_"^"_cySpecInstr_"^"_whoDDD_"^"_whoDDDUom_"^"_gttSpeed_"^"_granulesFac_"^"_pCommFlag
	s phcDataList5=pivaCat_"^"_highRiskLevel_"^"_singleUse_"^"_allergyFlag_"^"_dietTaboo_"^"_tumbleFlag_"^"_dopeFlag
	s phcDataList6=basicFlag_"^"_pBasicFlag_"^"_cBasicFlag_"^"_c1BasicFlag_"^"_otcFlag_"^"_codeXFlag_"^"_testFlag
	s phcDataList7=tpnFlag_"^"_cqztFlag_"^"_oneFlag_"^"_phcdSpec
	s phcDataList=phcDataList1_"^"_phcDataList2_"^"_phcDataList3_"^"_phcDataList4_"^"_phcDataList5_"^"_phcDataList6_"^"_phcDataList7
	s savePhcRet=##class(web.DHCST.PHCDRGMAST).Insert(phcDataList)
	i savePhcRet<0 d
	.i savePhcRet=-51 s errCode="-1^保存药学主表失败,可查看错误日志"
	.e  i savePhcRet=-52 s errCode="-1^保存药学子表失败,可查看错误日志"
	.e  i savePhcRet=-53 s errCode="-1^保存药学附加表失败,可查看错误日志"
	.e  s errCode="-1^保存药学项失败,可查看错误日志"
	q:errCode'="" errCode
	i savePhcRet>0 d 
	./// 保存等效单位
	.s eqDataList=eqUom1_"^"_eqQty1_"^"_eqDefQty1_","_eqUom2_"^"_eqQty2_"^"_eqDefQty2
	.s saveEqRet=..SaveFormDoseEquiv(savePhcRet,eqDataList)
	q savePhcRet
}

/// description: 保存五级数据,库存项收费项相关信息
/// return:		 如果根据库存项代码获取到库存项Id,则不再插入,返回-1^库存项已存在
Method InputLevel5() As %String
{
	s errCode=""
	s obj=$this
	s inciCode=obj.INCICode 
	s inciDesc=obj.INCIDesc
	s valRet=..ValidIncUnique(inciCode,inciDesc)
	q:$p(valRet,"^",1)<0 valRet
	s incId=..GetIncIdByCode(inciCode)
	q:incId>0 incId
	q:$p(incId,"^",1)<0 incId
	s incId=""
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()	
	/// 基本单位
	s bUomId=obj.INCICTUOMDR	 
	/// 入库单位
	s pUomId=obj.INCICTUOMPurchDR
	/// 库存分类
	s stkCatId=obj.INCIINCSCDR
	/// 价格生效日期
	s priceDate=obj.PriceDate
	s priceDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(priceDate)
	/// 进口标志
	s importFlag=obj.INFOImportFlag
	i (importFlag'="")&&(importFlag'="国产")&&(importFlag'="进口")&&(importFlag'="合资") d
	.s errCode="-1^进口标志"_"不为(国产,进口,合资)之一"
	q:errCode'="" errCode
	/// 质量层次
	s qualityLevel=obj.INFOQualityLevel
	/// 处方药分类 
	s otcFlag=obj.INFOOTC
	i (otcFlag'="")&&(otcFlag'="处方药")&&(otcFlag'="非处方药") d
	.s errCode="-1^处方药分类"_"不为(处方药,非处方药)之一"
	q:errCode'="" errCode
	/// 批准文号
	s itmRemark=obj.INFORemark
	i itmRemark'="" s itmRemark=..FmtItmRemark(itmRemark)
	/// 定价类型
	s markType=obj.INFOMTDR
	/// 招标供应商
	s pbVendor=obj.INFOPbVendorDR
	/// 招标生产商
	s pbManf=obj.INFOPbManfDR
	/// 招标配送商
	s pbCarrier=obj.INFOPbCarrierDR	
	/// 招标级别
	s pbLevel=obj.INFOPBLevel
	/// 物价备案时间
	s prcFileDate=obj.INFOPrcFileD
	s prcFileDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(prcFileDate)
	/// 帐簿分类
	s bookCat=obj.INFOBCDr
	/// 大包装单位
	s packUomId=obj.INFOPackUom
	/// 别名
	s aliasStr=""
	s aliasStr=obj.INCALIAS	
	i aliasStr'="" d
	.s aliasStr="^"_$replace(aliasStr,"/",rowDelim_"^")
	/// 不可用标志
	s notUse=$s(obj.INCINotUseFlag="Y":"Y",1:"N")
	/// 条码
	s barCode=obj.INCIBarCode
	/// 售价
	s sp=obj.Sp
	/// 进价
	s rp=obj.Rp
	/// 规格
	s spec=obj.INFOSpec
	/// 国家基本药物-以药学项为准
	s basicDrug=$s(obj.INFOBasicDrug="Y":"Y",1:"N")
	/// 中国药典-以药学项为准
	s codeXFlag=$s(obj.INFOCodex="Y":"Y",1:"N")
	/// 临床验证用药标志-以药学项为准
	s testFlag=$s(obj.INFOTest="Y":"Y",1:"N")
	/// 处方购药标志
	s recFlag=$s(obj.INFORec="Y":"Y",1:"N")
	/// 质量编号
	s qualityNo=obj.INFOQualityNo
	/// 国省别
	s comFrom=obj.INFOComFrom
	/// 高值标志-贵重药
	s highPrice=$s(obj.INFOHighPrice="Y":"Y",1:"N")
	/// 最高售价
	s maxSp=obj.INFOMaxSp
	/// 本院药品目录
	s inHosFlag=$s(obj.INFOInHosFlag="Y":"Y",1:"N")
	/// 招标进价
	s pbRp=obj.INFOPbRp
	/// 阳光采购
	s baFlag=$s(obj.INFOBAflag="Y":"Y",1:"N")
	/// 物价文件号
	s prcFile=obj.INFOPrcFile
	/// 皮试标志
	s skinFlag=$s(obj.INFOSkinTest="Y":"Y",1:"N")
	/// 用药说明
	s drugUse=obj.INFODrugUse
	/// 省基本药物
	s pBasicDrug=$s(obj.INFODrugbase2="Y":"1",1:"")
	/// 市基本药物
	s cBasicDrug=$s(obj.INFOPDrugbase1="Y":"1",1:"")
	/// 区县基本药物
	s c1BasicDrug=$s(obj.INFOPDrugbase2="Y":"1",1:"")
	/// 药品本位码
	s standardCode=obj.INFOStandardCode
	/// 进药依据
	s inMedBasis=obj.INFOInMedBasis
	/// 大包装单位系数
	s packUomFac=$s(obj.INFOPackUomFactor'="":+obj.INFOPackUomFactor,1:"")
	/// 门诊发药单位
	s outPhUomId=obj.INCICTUOMOutPatDR
	/// 住院发药单位
	s inPhUomId=obj.INCICTUOMInPatDR	
	/// 协和码
	s xhCode=obj.INCIReportingDays
	/* 存储条件 start*/
	s storeComTemp=$s(obj.ISCCommonTemp="Y":"Y",1:"") ; 常温
	s storeDry=$s(obj.ISCDry="Y":"Y",1:"") 		; 干燥
	s storeAirLight=$s(obj.ISCAirtight="Y":"Y",1:"") ; 密闭
	s storeDark=$s(obj.ISCDark="Y":"Y",1:"") ; 避光
	s storeVentilate=$s(obj.ISCVentilate="Y":"Y",1:"") ; 通风
	s storeRadiation=$s(obj.ISCRadiation="Y":"Y",1:"") ; 防辐射
	s storeSeal=$s(obj.ISCSeal="Y":"Y",1:"") ; 熔封
	s storeCool=$s(obj.ISCCoolGloomy="Y":"Y",1:"") ; 阴凉
	s storeGloomy=$s(obj.ISCGloomyCool="Y":"Y",1:"") ; 阴暗
	s storeMeltPack=$s(obj.ISCMeltPack="Y":"Y",1:"") ; 密封
	s storeCold=$s(obj.ISCCOLDST="Y":"Y",1:"") ; 冷藏
	s storeFreeze=$s(obj.ISCFREEZE="Y":"Y",1:"") ; 防冻
	s storeAdmpProof=$s(obj.ISCDAMPPROOF="Y":"Y",1:"") ; 防潮
	s storeMinHum=obj.ISCMinHumidity	; 最低湿度
	s storeMaxHum=obj.ISCMaxHumidity ; 最高湿度
	s storeMinTemp=obj.ISCMinTemp ; 最低温度
	s storeMaxTemp=obj.ISCMaxTemp ; 最高温度
	s storeString1=storeComTemp_"^"_storeDry_"^"_storeAirLight_"^"_storeDark_"^"_storeVentilate
	s storeString2=storeRadiation_"^"_storeSeal_"^"_storeCool_"^"_storeGloomy_"^"_storeMeltPack
	s storeString3=storeCold_"^"_storeMinTemp_"^"_storeMaxTemp_"^"_storeMinHum_"^"_storeMaxHum
	s storeString=storeString1_"^"_storeString2_"^"_storeString3
	/* 存储条件 end*/
	/// 预留医嘱项ID
	s arcItmId=""
	/// 更新人-默认demo
	s updateUser=1
	/// 招标标志-不用
	s pbFlag=""
	/// 招标名称-不用
	s pblDr=""
	/// 高危药品-不用
	s highRisk=""
	/// 效期长度
	s expdateLen=""
	/// 效期要求
	s expireFlag="REQUIRED"
	///	批次要求
	s batFlag="REQUIRED"
	///	转移方式要求
	s transFlag="TRANS"
	/// 不可用原因
	s notUseReason=""
	/// 拒绝退药原因
	s refRetReason=""
	/// 库存项医嘱截止日期
	s inciOrdEndDate=""
	/// 生产企业
	s phManfId=obj.PHCDPHMNFDR
	/// 登录科室,登录安全组
	i $d(%session) d
	.s logonLoc=$Get(%session.Data("LOGON.CTLOCID"))
	.s logonGroup=$Get(%session.Data("LOGON.GROUPID"))
	e  d
	.s logonLoc="" 
	.s logonGroup="" 
	/// 存储条件指针
	s storeConDr=""
	s incDataList1=arcItmId_"^"_inciCode_"^"_inciDesc_"^"_bUomId_"^"_pUomId_"^"_stkCatId_"^"_transFlag_"^"_batFlag_"^"_expireFlag_"^"_""
	s incDataList2=notUse_"^"_xhCode_"^"_barCode_"^"_updateUser_"^"_sp_"^"_rp_"^"_priceDate_"^"_spec_"^"_importFlag_"^"_qualityLevel
	s incDataList3=otcFlag_"^"_basicDrug_"^"_codeXFlag_"^"_testFlag_"^"_recFlag_"^"_qualityNo_"^"_comFrom_"^"_itmRemark_"^"_highPrice_"^"_markType
	s incDataList4=maxSp_"^"_storeConDr_"^"_inHosFlag_"^"_pbFlag_"^"_pbRp_"^"_pbLevel_"^"_pbVendor_"^"_pbManf_"^"_pbCarrier_"^"_pblDr
	s incDataList5=baFlag_"^"_expdateLen_"^"_prcFile_"^"_prcFileDate_"^"_skinFlag_"^"_bookCat_"^"_drugUse_"^"_pBasicDrug_"^"_cBasicDrug_"^"_c1BasicDrug
	s incDataList6=standardCode_"^"_inMedBasis_"^"_packUomId_"^"_packUomFac_"^"_highRisk_"^"_notUseReason_"^^"_logonLoc_"^"_logonGroup_"^"_refRetReason
	s incDataList7=outPhUomId_"^"_inPhUomId_"^"_inciOrdEndDate_"^"_phManfId
	s incDataList=incDataList1_"^"_incDataList2_"^"_incDataList3_"^"_incDataList4_"^"_incDataList5_"^"_incDataList6_"^"_incDataList7
	s saveIncRet=##class(web.DHCST.INCITM).Insert(incDataList)
	i saveIncRet<0 d
	.i saveIncRet=-91 s errCode="-1^保存库存项表失败,可查看错误日志"
	.i saveIncRet=-94 s errCode="-1^保存调价失败,可查看错误日志"
	.e  s errCode="-1^保存库存项失败,可查看错误日志"
	q:errCode'="" errCode
	i saveIncRet>0 d 
	./// 保存存储条件
	.s saveStoreRet=##class(web.DHCST.ITMSTORECON).Insert(storeString,saveIncRet)
	./// 保存别名
	.i aliasStr'="" s saveAlias=##class(web.DHCST.INCALIAS).Save(saveIncRet,aliasStr)
	q saveIncRet
}

/// 保存收费项与库存项关联,以及收费项信息
Method InputLevel6(incItmId) As %String
{
	n (incItmId)
	s obj=$this
	s tarsubcat=obj.TarSubCat 			// 子分类 
	s inphasubcat=obj.InpaSubCat		// 住院子分类
	s outphasubcat=obj.OutpaSubCat		// 门诊子分类
	s emsubcat=obj.EmSubCat				// 核算子分类
	s mrsubcat=obj.MrSubCat				// 病案首页分类
	s accsubcat=obj.AcctSubCat 			// 会计子分类
	s mrsubcat=obj.MrCatNew				// 新病案首页
	i $d(%session) d
	.s logonuser=$Get(%session.Data("LOGON.USERID"))
	e  d
	.s logonuser=1 
	s tarItmList=tarsubcat_"^"_inphasubcat_"^"_outphasubcat_"^"_emsubcat_"^"_mrsubcat_"^"_accsubcat_"^"_mrsubcat
	s saveTarRet=##class(web.DHCST.INCITM).SaveTarItem(incItmId,tarItmList,logonuser)
	q:+saveTarRet<0 -10001
	q 0
}

/// 验证whonet码
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validWhoNetCode("validWhoNetCode",1)
ClassMethod ValidWhoNetCode(whonetcode As %String, insertflag As %String = "") As %String
{
	n (whonetcode,insertflag)
	s whonetcode=$$ALPHAUP^SSUTIL4(whonetcode)
	q:whonetcode="" ""
	s retval="" //-2
	s WhonetFlag=""
	i $d(^DHCLISBSVersion(1)) d //dhc-lisdata
	.s whonetcode=" "_whonetcode  //该索引首字符为空格
	.s LabData="dhc-lisdata"
	.i '$d(^[LabData]dbo.BTAntibioticsI("IndexWCode",whonetcode)) s retval="-1^WhoNet码不存在"
	e  d //labtrak
 	.s LabData="labdata"
    .s wCode="" f  s wCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode)) q:wCode=""  d
    ..s antCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode,"")) q:(antCode="")!(WhonetFlag'="")
    ..s retval="-1^WhoNet码不存在"
    ..q:whonetcode'=antCode
 	..s retval="",WhonetFlag=1
 	q retval
}

/// description: 保存等效单位
ClassMethod SaveFormDoseEquiv(PhcdfId, EqListData)
{
	n (EqListData,PhcdfId)
	s eqLen=$l(EqListData,",")
	s eqI=0
	f eqI=1:1:eqLen d
	.s eqData=$p(EqListData,",",eqI)
	.s eqUomDr=$p(eqData,"^",1)
	.s eqQty=$p(eqData,"^",2)
	.s eqDefQty=$p(eqData,"^",3)
	.q:(eqUomDr="")||(eqQty="")
	.&SQL(SELECT EQ_rowid into :eqId FROM PHC_FormDoseEquiv WHERE EQ_ParRef=:PhcdfId AND EQ_CTUOM_DR=:eqUomDr)
	.i SQLCODE d
	..&sql(INSERT INTO PHC_FormDoseEquiv(EQ_ParRef,EQ_CTUOM_DR,EQ_Qty,EQ_DefaultDose)
		VALUES (:PhcdfId,:eqUomDr,:eqQty,:eqDefQty))
	q 0
}

/// 根据药学分类代码获取Id
/// w ##class(web.DHCST.Tools.InputDrugBasicLevelData).GetPhcCatIdByCode("化学合成的抗菌药")
ClassMethod GetPhcCatIdByCode(PhcCatCode As %String) As %String
{
	n (PhcCatCode)
	q:PhcCatCode="" "-1^药学分类代码为空"
	s phcCatId=""
	&SQL(SELECT PHCC_RowId into :phcCatId FROM DHC_PHCCat WHERE PHCC_Code=:PhcCatCode)
	q:SQLCODE'=0 "-1^药学分类不存在"
	q phcCatId
}

/// 根据化学通用名代码获取Id
/// w ##class(web.DHCST.Tools.InputDrugBasicLevelData).GetChemIdByCode("化学合成的抗菌药")
ClassMethod GetChemIdByCode(ChemCode As %String) As %String
{
	n (ChemCode)
	q:ChemCode="" "-1^化学通用名代码为空"
	s chemId=""
	&SQL(SELECT PHCM_RowId into :chemId FROM DHC_PHChemical WHERE PHCM_Code=:ChemCode)
	q chemId
}

/// 根据处方通用名代码获取Id
ClassMethod GetGeneIdByCode(GeneCode As %String) As %String
{
	n (GeneCode)
	q:GeneCode="" "-1^处方通用名代码为空"
	s geneId=""
	&SQL(SELECT PHCGE_RowId into :geneId FROM PHC_Generic WHERE PHCGE_Code=:GeneCode)
	q geneId
}

/// 根据药学项代码获取Id,phc_drgform
ClassMethod GetPhcdIdByCode(PhcdCode)
{
	n (PhcdCode)
	q:PhcdCode="" "-1^药学项代码为空"
	s phcdId=""
	&SQL(SELECT PHCD_RowId into :phcdId FROM PHC_DrgMast WHERE PHCD_Code=:PhcdCode)
	q:phcdId'="" phcdId_"||"_1
	q phcdId
}

/// 根据库存代码获取Id
/// w ##class(web.DHCST.Tools.InputDrugBasicLevelData).GetIncIdByCode("12345")
ClassMethod GetIncIdByCode(IncCode)
{
	n (IncCode)
	q:IncCode="" "-1^库存项代码为空"
	s incId=""
	&SQL(SELECT INCI_RowId into :incId FROM INC_Itm WHERE INCI_Code=:IncCode)
	q incId
}

/// 根据处方通用名Id获取新药学分类Id
ClassMethod GetPhcCatIdByGeneId(GeneId)
{
	n (GeneId)
	q:GeneId="" ""
	s chemId=$p($g(^PHCGE("GE",GeneId,"DHC")),"^",3)
	q:chemId="" ""
	s phcCatId=$p($g(^DHCPHCM(chemId)),"^",3)
	q phcCatId
}

/// 根据处方通用名获取剂型Id
ClassMethod GetFormIdByGeneId(GeneId)
{
	n (GeneId)
	q:GeneId="" ""
	s formId=$p($g(^PHCGE("GE",GeneId,"DHC")),"^",5)
	q formId
}

/// description: 格式化批准文号为-分隔
/// 倒序以"-"分隔,第一个非汉字的开始分
/// w ##class(web.DHCST.Tools.InputDrugBasicLevelData).FmtItmRemark("国药准字A00203")
ClassMethod FmtItmRemark(ItmRemark)
{
	n (ItmRemark)
	s newRemark=""
	s len=$l(ItmRemark)
	k FmtItmRemarkData
	s hasFlag=""
	s i=0
	f i=len:-1:1 d
	.s iRemark=$e(ItmRemark,i)
	.s FmtItmRemarkData(i)=iRemark
	.s ascCode=$ASCII(iRemark)
	.i (ascCode>250)&&(ItmRemark'["-")&&(hasFlag="") d 
	..s FmtItmRemarkData(i)=iRemark_"-"
	..s hasFlag=1
	s fmtI=""
	f  s fmtI=$o(FmtItmRemarkData(fmtI)) q:fmtI=""  d
	.s newRemark=newRemark_FmtItmRemarkData(fmtI)
	q newRemark
}

/// w ##class(web.DHCST.Tools.InputDrugBasicLevelData).ValidPhcUnique("XWY000002A","盐酸利多卡因胶浆[2%*10ML]")
ClassMethod ValidPhcUnique(PhcdCode, PhcdDesc)
{
	s codeId=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(PhcdCode),"")) 
	s descId=$o(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(PhcdDesc),"")) 
	q:codeId'=descId "-1^药学项代码与名称未通过一致性检查"
	q ""
}

/// 库存项唯一
ClassMethod ValidIncUnique(IncCode, IncDesc)
{
	s codeId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(IncCode)_"Z",""))
	q:codeId'="" "-1^库存项已存在该代码"
	s descId=$o(^INCI(0,"Desc1",$$ALPHAUP^SSUTIL4(IncDesc)_"Z",""))
	q:descId'="" "-1^库存项已存在该名称"
	q:codeId'=descId "-1^库存项代码与名称未通过一致性检查"
	q ""
}

/// 将传入的数据串存储到对应的property中
/// zhwh
/// 2017-01-03
Method SetPrValue(datalist As %String) As %String
{
 n (datalist,%session)
 s Del=..Deli()
 s DelF=..DeliField()
 s dcd = ##Class(%Dictionary.ClassDefinition).%OpenId(..%ClassName(1))
 s pCount=dcd.Properties.Count()
 s len=$l(datalist,Del)
 f k=1:1:len  d
 .s data=$p(datalist,Del,k)
 .s PropName=$p(data,DelF,1)
 .s value=$p(data,DelF,2)
 .f i=1:1:pCount d
 ..s pobj=dcd.Properties.GetAt(i)
 ..s PropertyName=pobj.Name
 ..;w "property:"_PropertyName,!
 ..i $zcvt(PropertyName,"L")=$zcvt(PropName,"L") d
 ...s $ZOBJPROPERTY($THIS,PropertyName)=value
 d dcd.%Close()
 s dcd=""
 q 0
}

ClassMethod Deli() As %String
{
	q "|"
}

ClassMethod DeliField() As %String
{
	q "^"
}

Method SetError(errinfo As %String) As %String
{
	s $ZOBJPROPERTY($THIS,"ErrorCode")=errinfo
	q ""
}

}
