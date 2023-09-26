Import sqluser

/// creator:	yunhaibao
/// createdate:	2017-01-12
/// description:给基础数据平台导入数据调用,导入库存项,药学项基础数据
/// 			最终保存方法调用药品信息维护的保存程序
/// 			此类尽量不使用事务
/// others:		入参类型String长度32768
Class web.DHCST.Tools.InputDrugBasicData Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/* 库存项 start */
/// 基本单位(名称)
Property INCICTUOMDR As %String;

/// 入库单位(名称)
Property INCICTUOMPurchDR As %String;

/// 库存分类(名称)
Property INCIINCSCDR As %String;

/// 别名("/"分隔)
Property INCALIAS As %String;

/// 不可用标志(Y/N)
Property INCINotUseFlag As %String;

/// 条码
Property INCIBarCode As %String;

/// 售价
Property Sp As %String;

/// 进价
Property Rp As %String;

/// 价格生效日期(yyyy-MM-dd,空为当天)
Property PriceDate As %String;

/// 规格
Property INFOSpec As %String;

/// 进口标志(国产/进口/合资)
Property INFOImportFlag As %String;

/// 质量层次
Property INFOQualityLevel As %String;

/// 处方药分类(甲类/乙类/双跨)
Property INFOOTC As %String;

/// 基本药物标志(Y/N)
Property INFOBasicDrug As %String;

/// 中国药典标志(Y/N)
Property INFOCodex As %String;

/// 临床验证用药标志(Y/N)
Property INFOTest As %String;

/// 处方购药标志(Y/N)
Property INFORec As %String;

/// 质量编号
Property INFOQualityNo As %String;

/// 国(省)别
Property INFOComFrom As %String;

/// 批准文号(国药准字-H0023N1)
Property INFORemark As %String;

/// 高值类标志(Y/N)
Property INFOHighPrice As %String;

/// 定价类型(名称)
Property INFOMTDR As %String;

/// 最高售价
Property INFOMaxSp As %String;

/// 本院药品目录标志(Y/N)
Property INFOInHosFlag As %String;

/// 招标进价
Property INFOPbRp As %String;

/// 招标供应商(全称)
Property INFOPbVendorDR As %String;

/// 招标生产商(全称)
Property INFOPbManfDR As %String;

/// 招标配送商(全称)
Property INFOPbCarrierDR As %String;

/// 招标级别
Property INFOPBLevel As %String;

/// 阳光采购标志(Y/N)
Property INFOBAflag As %String;

/// 物价文件号
Property INFOPrcFile As %String;

/// 物价文件备案时间(yyyy-MM-dd)
Property INFOPrcFileD As %String;

/// 皮试标志(Y/N)
Property INFOSkinTest As %String;

/// 帐簿分类(名称)
Property INFOBCDr As %String;

/// 用药说明
Property INFODrugUse As %String;

/// 省基本药物标志(Y/N)
Property INFODrugbase2 As %String;

/// 市级基本药物(Y/N)
Property INFOPDrugbase1 As %String;

/// 区(县)基本药物(Y/N)
Property INFOPDrugbase2 As %String;

/// 药品本位码
Property INFOStandardCode As %String;

/// 进药依据
Property INFOInMedBasis As %String;

/// 大包装单位
Property INFOPackUom As %String;

/// 大包装单位系数
Property INFOPackUomFactor As %String;

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

/// 协和码
Property INCIReportingDays As %String;

/* 库存项 end */

/* 药学项 start */
/// 药品代码
Property INCICode As %String;

/// 药品名称
Property INCIDesc As %String;

/// 剂型(名称)
Property PHCDFPHCFDR As %String;

/// 用法(名称)
Property PHCDFPHCINDR As %String;

/// 疗程(名称)
Property PHCDFPHCDUDR As %String;

/// 基本数量(数字)
Property PHCDFBaseQty As %String;

/// 厂商(全称)
Property PHCDPHMNFDR As %String;

/// 管制分类(名称)
Property PHCDPHCPODR As %String;

/// 频次(名称)
Property PHCDFPHCFRDR As %String;

/// 医保类别(全称-字典维护)
Property PHCDOfficialCode As %String;

/// 通用名(名称)
Property PHCDGenericDR As %String;

/// 英文国际非专利药名
Property PHCDLabelName21 As %String;

/// 国际专利药名
Property PHCDLabelName22 As %String;

/// 商品名
Property PHCDLabelName1 As %String;

/// 制剂通用名
Property PHCDFOfficialCode1 As %String;

/// 原料通用名
Property PHCDFOfficialCode2 As %String;

/// 住院一天量标志(Y/N)
Property PHCDFDeductPartially As %String;

/// 门诊一天量标志(Y/N)
Property PHCDFCalcuDose As %String;

/// 门诊皮试用原液(Y/N)
Property PHCDFOPSkinTestYY As %String;

/// 住院皮试用原液(Y/N)
Property PHCDFIPSkinTestYY As %String;

/// 抗菌药标志(Y/N)
Property PHCDFAntibioticFlag As %String;

/// 危重药标志(Y/N)
Property PHCDFCriticalFlag As %String;

/// WHONET码
Property PHCDFWHONET As %String;

/// 草药备注-----------------待确定怎么存
Property PHCDFCHPhSpecInstr As %String;

/// WhoDDD值
Property PHCDFWHODDD As %String;

/// WhoDDD单位(名称)
Property PHCDFWHODDDUomDr As %String;

/// 滴速(数字,对应单位gtt/min)
Property PHCDFivgttSpeed As %String;

/// 颗粒单位系数
Property PHCDFGranulesFact As %String;

/// 省属常用药物(Y/N)
Property PHCDFProvinceComm As %String;

/// 药学分类1级(名称)
Property DHCPHCCat1 As %String;

/// 药学分类2级(名称)
Property DHCPHCCat2 As %String;

/// 药学分类3级(名称)
Property DHCPHCCat3 As %String;

/// 药学分类4级(名称)
Property DHCPHCCat4 As %String;

/// 药学分类5级(名称)
Property DHCPHCCat5 As %String;

/// 药学分类6级(名称)
Property DHCPHCCat6 As %String;

/// 药学分类7级(名称)
Property DHCPHCCat7 As %String;

/// 等效单位1(名称)
Property EQCTUOMDR1 As %String;

/// 等效数量1
Property EQQty1 As %String;

/// 缺省数量1
Property EQDefaultDose1 As %String;

/// 等效单位2(名称)
Property EQCTUOMDR2 As %String;

/// 等效数量2
Property EQQty2 As %String;

/// 缺省数量2
Property EQDefaultDose2 As %String;

/// 错误信息
Property ErrorCode As %String;

// Property INFOISCDR As %String;

/* 药学项 end */
/// 存储条件  chenying
/// 接口同时保存库存项药学项
/// return:药学项id^库存项id
ClassMethod SaveDrug(incidatalist, phcdatalist) As %String
{
	n (incidatalist,phcdatalist,%session)
	//s $zt="ErrorSaveDrug"
	s obj=..%New()
	s ret=obj.SetPrValue(phcdatalist)
	q:ret<0 ret
	s ret=obj.SetPrValue(incidatalist)
	q:ret<0 ret
	s phcret=obj.InputPhcMast()
	/// i phcret<0 w obj.ErrorCode,! ; 测试用
	q:obj.ErrorCode'="" phcret
	s inciret=obj.InputIncItm()
	/// i inciret<0 w obj.ErrorCode,! ; 测试用
	q:obj.ErrorCode'="" inciret
	q phcret_"^"_inciret
	//ErrorSaveDrug
	//d Error^DHCSTERROR()
	//q -4444
}

/// 接口:保存库存项相关信息
ClassMethod SaveInci(datalist) As %String
{
	n (datalist,%session)
	s $zt="ErrorSaveInci"
	s obj=..%New()
	s ret=obj.SetPrValue(datalist)
	q:ret<0 ret
	s ret1=obj.InputIncItm()
	i obj.ErrorCode'="" w obj.ErrorCode /// 测试用
	q ret1
ErrorSaveInci
	q $ze
	q -1111
}

/// 接口:保存药学项相关信息
ClassMethod SavePhc(datalist) As %String
{
	n (datalist,%session)
	s $zt="ErrorSavePhc"
	s obj=..%New()
	s ret=obj.SetPrValue(datalist)
	q:ret<0 ret
	s ret1=obj.InputPhcMast()
	q ret1
ErrorSavePhc
	q $ze
	q -2222
}

/// 保存库存项相关信息
Method InputIncItm() As %String
{
	s obj=$this
	s incicode=obj.INCICode 
	s incidesc=obj.INCIDesc
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()	
	/// 基本单位
	s buom=obj.INCICTUOMDR
	s validret=..validUom(buom,3)
	i validret<0 d
	.i validret=-1 s msg="基本单位"_"为空" d obj.SetError(msg) s validret=-1009
	.e  i validret=-2 s msg="基本单位"_"不存在" d obj.SetError(msg) s validret=-1010
	.e  i validret=-3 s msg="基本单位"_"不存在,插入失败" d obj.SetError(msg) s validret=-1011
	e  s buom=validret
	q:validret<0 validret	 
	/// 入库单位
	s puom=obj.INCICTUOMPurchDR
	s validret=..validUom(puom,3)
	i validret<0 d
	.i validret=-1 s msg="入库单位"_"为空" d obj.SetError(msg) s validret=-1012
	.e  i validret=-2 s msg="入库单位"_"不存在" d obj.SetError(msg) s validret=-1013
	.e  i validret=-3 s msg="入库单位"_"不存在,插入失败" d obj.SetError(msg) s validret=-1014
	e  s puom=validret
	q:validret<0 validret
	/// 库存分类
	s stkcat=obj.INCIINCSCDR
	s validret=..validStkCat(stkcat,3)
	i validret<0 d
	.i validret=-1 s msg="库存分类"_"为空" d obj.SetError(msg) s validret=-1015
	.e  i validret=-2 s msg="库存分类"_"不存在"  d obj.SetError(msg) s validret=-1016
	.e  i validret=-3 s msg="库存分类"_"不存在,插入失败" d obj.SetError(msg) s validret=-1017
	e  s stkcat=validret
	q:validret<0 validret
	/// 价格生效日期
	s pricedate=obj.PriceDate
	s validret=..validDate(pricedate)
	i validret<0 s msg="价格生效日期(yyyy-MM-dd)"_"格式错误" d obj.SetError(msg) s validret=-1018
	e  i validret="" s pricedate=$zd(+$h,3)
	q:validret<0 validret
	/// 进口标志
	s validret=""
	s importflag=obj.INFOImportFlag
	i (importflag'="")&&(importflag'="国产")&&(importflag'="进口")&&(importflag'="合资") d
	.s msg="进口标志"_"不为(国产,进口,合资)之一" d obj.SetError(msg) s validret=-1019
	q:validret<0 validret
	/// 质量层次
	s qualitylevel=obj.INFOQualityLevel
	s validret=..validQualityLevel(qualitylevel,3)
	i validret<0 d
	.i validret=-2 s msg="质量层次"_"不存在" d obj.SetError(msg) s validret=-1020
	.e  i validret=-3 s msg="质量层次"_"不存在,插入失败" d obj.SetError(msg) s validret=-1021
	e  s qualitylevel=validret
	q:validret<0 validret
	/// 处方药分类 
	s otcflag=obj.INFOOTC
	i (otcflag'="")&&(otcflag'="处方药")&&(otcflag'="非处方药") d
	.s msg="处方药分类"_"不为(处方药,非处方药)之一" d obj.SetError(msg) s validret=-1022
	q:validret<0 validret
	/// 批准文号
	s itmremark=obj.INFORemark
	i (itmremark'="")&&(itmremark'["-") d
	.s msg="批准文号"_"需以"-"分隔" d obj.SetError(msg) s validret=-1023
	q:validret<0 validret
	s validret=""
	/// 定价类型
	s marktype=obj.INFOMTDR
	s validret=..validMarkType(marktype,3)
	i validret<0 d
	.i validret=-2 s msg="定价类型"_"不存在" d obj.SetError(msg) s validret=-1024
	.e  i validret=-3 s msg="定价类型"_"不存在,插入失败" d obj.SetError(msg) s validret=-1025
	e  s marktype=validret
	q:validret<0 validret
	/// 招标供应商
	s pbvendor=obj.INFOPbVendorDR
	s validret=..validVendor(pbvendor,3)
	i validret<0 d
	.i validret=-2 s msg="招标供应商"_"不存在" d obj.SetError(msg) s validret=-1026
	.e  i validret=-3 s msg="招标供应商"_"不存在,插入失败" d obj.SetError(msg) s validret=-1027
	e  s pbvendor=validret
	q:validret<0 validret
	/// 招标生产商
	s pbmanf=obj.INFOPbManfDR
	s validret=..validManf(pbmanf,3)
	i validret<0 d
	.i validret=-2 s msg="招标生产商"_"不存在" d obj.SetError(msg) s validret=-1028
	.e  i validret=-3 s msg="招标生产商"_"不存在,插入失败" d obj.SetError(msg) s validret=-1029
	e  s pbmanf=validret
	q:validret<0 validret
	/// 招标配送商
	s pbcarrier=obj.INFOPbCarrierDR
	s validret=..validCarrier(pbcarrier,3)
	i validret<0 d
	.i validret=-2 s msg="招标配送商"_"不存在" d obj.SetError(msg) s validret=-1030
	.e  i validret=-3 s msg="招标配送商"_"不存在,插入失败" d obj.SetError(msg) s validret=-1031
	e  s pbcarrier=validret
	q:validret<0 validret	
	/// 招标级别
	s pblevel=obj.INFOPBLevel
	s validret=..validPBLevel(pblevel,3)
	i validret<0 d
	.i validret=-2 s msg="招标级别"_"不存在" d obj.SetError(msg) s validret=-1032
	.e  i validret=-3 s msg="招标级别"_"不存在,插入失败" d obj.SetError(msg) s validret=-1033
	e  s pblevel=validret
	q:validret<0 validret
	/// 物价备案时间
	s prcfiledate=obj.INFOPrcFileD
	s validret=..validDate(prcfiledate)
	i validret<0 s msg="物价备案时间(yyyy-MM-dd)"_"格式错误" d obj.SetError(msg) s validret=-1034
	q:validret<0 validret
	/// 帐簿分类
	s bookcat=obj.INFOBCDr
	s validret=..validBookCat(bookcat,3)
	i validret<0 d
	.i validret=-2 s msg="帐簿分类"_"不存在" d obj.SetError(msg) s validret=-1035
	.e  i validret=-3 s msg="帐簿分类"_"不存在,插入失败" d obj.SetError(msg) s validret=-1036
	e  s bookcat=validret
	q:validret<0 validret
	/// 大包装单位
	s packuom=obj.INFOPackUom
	s validret=..validUom(packuom,3,1)
	i validret<0 d
	.i validret=-1 s msg="大包装单位"_"为空" d obj.SetError(msg) s validret=-1037
	.e  i validret=-2 s msg="大包装单位"_"不存在" d obj.SetError(msg) s validret=-1038
	.e  i validret=-3 s msg="大包装单位"_"不存在,插入失败" d obj.SetError(msg) s validret=-1039
	e  s packuom=validret
	q:validret<0 validret
	/// 别名
	s incaliaslist=""
	s incalias=obj.INCALIAS	
	i incalias'="" d
	.s incalias="^"_$replace(incalias,"/",rowDelim_"^")
	/// 不可用标志
	s notuse=$s(obj.INCINotUseFlag="Y":"Y",1:"N")
	/// 条码
	s barcode=obj.INCIBarCode
	/// 售价
	s sp=obj.Sp
	/// 进价
	s rp=obj.Rp
	/// 规格
	s spec=obj.INFOSpec
	/// 国家基本药物
	s basicdrug=$s(obj.INFOBasicDrug="Y":"Y",1:"N")
	/// 中国药典
	s codex=$s(obj.INFOCodex="Y":"Y",1:"N")
	/// 临床验证用药标志
	s testflag=$s(obj.INFOTest="Y":"Y",1:"N")
	/// 处方购药标志
	s recflag=$s(obj.INFORec="Y":"Y",1:"N")
	/// 质量编号
	s qualityno=obj.INFOQualityNo
	/// 国省别
	s comfrom=obj.INFOComFrom
	/// 高值标志-此标志不用
	s highprice="" //obj.INFOHighPrice
	/// 最高售价
	s maxsp=obj.INFOMaxSp
	/// 本院药品目录
	s inhosflag=$s(obj.INFOInHosFlag="Y":"Y",1:"N")
	/// 招标进价
	s pbrp=obj.INFOPbRp
	/// 阳光采购
	s baflag=$s(obj.INFOBAflag="Y":"Y",1:"N")
	/// 物价文件号
	s prcfile=obj.INFOPrcFile
	/// 皮试标志
	s skinflag=$s(obj.INFOSkinTest="Y":"Y",1:"N")
	/// 用药说明
	s druguse=obj.INFODrugUse
	/// 省基本药物
	s pbasicdrug=$s(obj.INFODrugbase2="Y":"1",1:"")
	/// 市基本药物
	s cbasicdrug=$s(obj.INFOPDrugbase1="Y":"1",1:"")
	/// 区县基本药物
	s cbasicdrug1=$s(obj.INFOPDrugbase2="Y":"1",1:"")
	/// 药品本位码
	s standardcode=obj.INFOStandardCode
	/// 进药依据
	s inmedbasis=obj.INFOInMedBasis
	/// 大包装单位系数
	s packuomfac=$s(obj.INFOPackUomFactor'="":+obj.INFOPackUomFactor,1:"")
	/* 存储条件 start*/
	s storecomtemp=$s(obj.ISCCommonTemp="Y":"Y",1:"") ; 常温
	s storedry=$s(obj.ISCDry="Y":"Y",1:"") 		; 干燥
	s storeairlight=$s(obj.ISCAirtight="Y":"Y",1:"") ; 密闭
	s storedark=$s(obj.ISCDark="Y":"Y",1:"") ; 避光
	s storeventilate=$s(obj.ISCVentilate="Y":"Y",1:"") ; 通风
	s storeradiation=$s(obj.ISCRadiation="Y":"Y",1:"") ; 防辐射
	s storeseal=$s(obj.ISCSeal="Y":"Y",1:"") ; 熔封
	s storecool=$s(obj.ISCCoolGloomy="Y":"Y",1:"") ; 阴凉
	s storegloomy=$s(obj.ISCGloomyCool="Y":"Y",1:"") ; 阴暗
	s storemeltpack=$s(obj.ISCMeltPack="Y":"Y",1:"") ; 密封
	s storecold=$s(obj.ISCCOLDST="Y":"Y",1:"") ; 冷藏
	s storefreeze=$s(obj.ISCFREEZE="Y":"Y",1:"") ; 防冻
	s storeadmpproof=$s(obj.ISCDAMPPROOF="Y":"Y",1:"") ; 防潮
	s storeminhum=obj.ISCMinHumidity	; 最低湿度
	s storemaxhum=obj.ISCMaxHumidity ; 最高湿度
	s storemintemp=obj.ISCMinTemp ; 最低温度
	s storemaxtemp=obj.ISCMaxTemp ; 最高温度
	s storestring1=storecomtemp_"^"_storedry_"^"_storeairlight_"^"_storedark_"^"_storeventilate
	s storestring2=storeradiation_"^"_storeseal_"^"_storecool_"^"_storegloomy_"^"_storemeltpack
	s storestring3=storecold_"^"_storemintemp_"^"_storemaxtemp_"^"_storeminhum_"^"_storemaxhum
	s storestring=storestring1_"^"_storestring2_"^"_storestring3
	/* 存储条件 end*/
	/// 预留医嘱项ID
	s arcimid=""
	/// 协和码-不用
	s xiehecode=obj.INCIReportingDays
	/// 更新人
	s updateuser=1
	/// 招标标志-不用
	s pbflag=""
	/// 招标名称-不用
	s pbldr=""
	/// 高危药品-不用
	s highrisk=""
	/// 效期长度
	s expdatelen=""
	/// 效期要求
	s expireflag="REQUIRED"
	///	批次要求
	s batflag="REQUIRED"
	///	转移方式要求
	s transflag="TRANS"
	/// 不可用原因
	s notusereason=""
	/// 登录科室,登录安全组
	i $d(%session) d
	.s logonloc=$Get(%session.Data("LOGON.CTLOCID"))
	.s logongroup=$Get(%session.Data("LOGON.GROUPID"))
	e  d
	.s logonloc=102 
	.s logongroup=142 
	/// 存储条件指针
	s storecondr=""
	s incdatalist1=arcimid_"^"_incicode_"^"_incidesc_"^"_buom_"^"_puom_"^"_stkcat_"^"_transflag_"^"_batflag_"^"_expireflag_"^"_incaliaslist
	s incdatalist2=notuse_"^"_xiehecode_"^"_barcode_"^"_updateuser_"^"_sp_"^"_rp_"^"_pricedate_"^"_spec_"^"_importflag_"^"_qualitylevel
	s incdatalist3=otcflag_"^"_basicdrug_"^"_codex_"^"_testflag_"^"_recflag_"^"_qualityno_"^"_comfrom_"^"_itmremark_"^"_highprice_"^"_marktype
	s incdatalist4=maxsp_"^"_storecondr_"^"_inhosflag_"^"_pbflag_"^"_pbrp_"^"_pblevel_"^"_pbvendor_"^"_pbmanf_"^"_pbcarrier_"^"_pbldr
	s incdatalist5=baflag_"^"_expdatelen_"^"_prcfile_"^"_prcfiledate_"^"_skinflag_"^"_bookcat_"^"_druguse_"^"_pbasicdrug_"^"_cbasicdrug_"^"_cbasicdrug1
	s incdatalist6=standardcode_"^"_inmedbasis_"^"_packuom_"^"_packuomfac_"^"_highrisk_"^"_notusereason_"^^"_logonloc_"^"_logongroup
	s incdatalist=incdatalist1_"^"_incdatalist2_"^"_incdatalist3_"^"_incdatalist4_"^"_incdatalist5_"^"_incdatalist6
	s saveinciret=##class(web.DHCST.INCITM).Insert(incdatalist)
	i saveinciret>0 d 
	./// 保存存储条件
	.s savestoreret=##class(web.DHCST.ITMSTORECON).Insert(storestring,saveinciret)
	./// 保存别名
	.i incalias'="" s savealias=##class(web.DHCST.INCALIAS).Save(saveinciret,incalias)
	q saveinciret
}

/// 保存药学项相关信息
Method InputPhcMast() As %String
{
	s obj=$this
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	/// 药品代码
	s incicode=obj.INCICode 
	s validret=..validCode(incicode)
	i validret<0 d
	.i validret=-1 s msg="药品代码"_"为空" d obj.SetError(msg) s validret=-2001
	.e  i validret=-2 s msg="药品代码"_"已存在于库存项" d obj.SetError(msg) s validret=-2002 
	.e  i validret=-3 s msg="药品代码"_"已存在于医嘱项" d obj.SetError(msg) s validret=-2003
	.e  i validret=-4 s msg="药品代码"_"已存在于药学项" d obj.SetError(msg) s validret=-2004 
	q:validret<0 validret
	/// 药品名称
	s incidesc=obj.INCIDesc
	s validret=..validDesc(incidesc) 
	i validret<0 d
	.i validret=-1 s msg="药品名称"_"为空" s validret=-1005 
	.e  i validret=-2 s msg="药品名称"_"已存在于库存项" d obj.SetError(msg) s validret=-2006 
	.e  i validret=-3 s msg="药品名称"_"已存在于医嘱项" d obj.SetError(msg) s validret=-2007
	.e  i validret=-4 s msg="药品名称"_"已存在于药学项" d obj.SetError(msg) s validret=-2008 
	q:validret<0 validret
	/// 剂型
	s phcform=obj.PHCDFPHCFDR
	s validret=..validPhcForm(phcform,3)
	i validret<0 d
	.i validret=-1 s msg="剂型"_"为空" d obj.SetError(msg) s validret=-2009
	.e  i validret=-2 s msg="剂型"_"不存在" d obj.SetError(msg) s validret=-2010
	.e  i validret=-3 s msg="剂型"_"不存在,插入失败" d obj.SetError(msg) s validret=-2011
	e  s phcform=validret
	q:validret<0 validret
	/// 用法
	s instruc=obj.PHCDFPHCINDR
	s validret=..validInstruc(instruc,3)
	i validret<0 d
	.i validret=-1 s msg="用法"_"为空" d obj.SetError(msg) s validret=-2012
	.e  i validret=-2 s msg="用法"_"不存在" d obj.SetError(msg) s validret=-2013
	.e  i validret=-3 s msg="用法"_"不存在,插入失败" d obj.SetError(msg) s validret=-2014
	e  s instruc=validret
	q:validret<0 validret
	/// 疗程
	s duration=obj.PHCDFPHCDUDR
	s validret=..validDuration(duration,3)
	i validret<0 d
	.i validret=-1 s msg="疗程"_"为空" d obj.SetError(msg) s validret=-2015
	.e  i validret=-2 s msg="疗程"_"不存在" d obj.SetError(msg) s validret=-2016
	e  s duration=validret
	q:validret<0 validret
	/// 厂商
	s pmanf=obj.PHCDPHMNFDR
	s validret=..validManf(pmanf,3)
	i validret<0 d
	.i validret=-2 s msg="厂商"_"不存在" d obj.SetError(msg) s validret=-2017
	.e  i validret=-3 s msg="厂商"_"不存在,插入失败" d obj.SetError(msg) s validret=-2018
	e  s pmanf=validret
	q:validret<0 validret
	/// 管制分类
	s poison=obj.PHCDPHCPODR
	s validret=..validPoison(poison,3)
	i validret<0 d
	.i validret=-2 s msg="管制分类"_"不存在" d obj.SetError(msg) s validret=-2019
	.e  i validret=-3 s msg="管制分类"_"不存在,插入失败" d obj.SetError(msg) s validret=-2020
	e  s poison=validret
	q:validret<0 validret	
	/// 频次
	s freq=obj.PHCDFPHCFRDR
	s validret=..validFreq(freq,3)
	i validret<0 d
	.i validret=-2 s msg="频次"_"不存在" d obj.SetError(msg) s validret=-2021
	.e  i validret=-3 s msg="频次"_"不存在,插入失败" d obj.SetError(msg) s validret=-2022
	e  s freq=validret
	q:validret<0 validret
	/// 医保类别
	s officialcode=obj.PHCDOfficialCode
	s validret=..validOfficialCode(officialcode,3)
	i validret<0 d
	.i validret=-2 s msg="医保类别"_"不存在" d obj.SetError(msg) s validret=-2023
	.e  i validret=-3 s msg="医保类别"_"不存在,插入失败" d obj.SetError(msg) s validret=-2024
	e  s officialcode=validret
	q:validret<0 validret
	/// 通用名
	s generic=obj.PHCDGenericDR
	s validret=..validGeneric(generic,3)
	i validret<0 d
	.i validret=-2 s msg="通用名"_"不存在" d obj.SetError(msg) s validret=-2025
	.e  i validret=-3 s msg="通用名"_"不存在,插入失败" d obj.SetError(msg) s validret=-2026
	e  s generic=validret
	q:validret<0 validret	
	/// whonet码
	s whonetcode=obj.PHCDFWHONET
	s validret=..validWhoNetCode(whonetcode,1)
	i validret<0 d
	.i validret=-2 s msg="whonet码"_"不存在" d obj.SetError(msg) s validret=-2027
	.e  i validret=-3 s msg="whonet码"_"不存在,插入失败" d obj.SetError(msg) s validret=-2028
	q:validret<0 validret	
	/// WhoDDD单位
	s whoddduom=obj.PHCDFWHODDDUomDr
	s validret=..validUom(whoddduom,3,1)
	i validret<0 d
	.i validret=-1 s msg="WhoDDD单位"_"为空" d obj.SetError(msg) s validret=-2029
	.e  i validret=-2 s msg="WhoDDD单位"_"不存在" d obj.SetError(msg) s validret=-2030
	.e  i validret=-3 s msg="WhoDDD单位"_"不存在,插入失败" d obj.SetError(msg) s validret=-2031
	e  s whoddduom=validret
	q:validret<0 validret	
	/// 基本单位
	s buom=obj.INCICTUOMDR
	s validret=..validUom(buom,3)
	i validret<0 d
	.i validret=-1 s msg="基本单位"_"为空" d obj.SetError(msg) s validret=-2032
	.e  i validret=-2 s msg="基本单位"_"不存在" d obj.SetError(msg) s validret=-2033
	.e  i validret=-3 s msg="基本单位"_"不存在,插入失败" d obj.SetError(msg) s validret=-2034
	e  s buom=validret
	q:validret<0 validret
	/// 基本数量
	s baseqty=obj.PHCDFBaseQty
	i baseqty'="" s baseqty=+baseqty
    s baseqty=1	 //默认为1
	/// 英文国际非专利药名
	s labelname21=obj.PHCDLabelName21
	/// 国际专利药名
	s labelname22=obj.PHCDLabelName22
	s labelname2=labelname21_"||"_labelname22
	/// 商品名
	s goodname=obj.PHCDLabelName1
	/// 原料通用名
	s officialcode1=obj.PHCDFOfficialCode1
	/// 制剂通用名
	s officialcode2=obj.PHCDFOfficialCode2
	s pdfofficialcode=officialcode1_"||"_officialcode2
	/// 住院一天量
	s iponeday=$s(obj.PHCDFDeductPartially="Y":"Y",1:"")
	/// 门诊一天量
	s oponeday=$s(obj.PHCDFCalcuDose="Y":"1",1:"")
	/// 门诊皮试用原液
	s opskintest=$s(obj.PHCDFOPSkinTestYY="Y":"1",1:"")
	/// 住院皮试用原液
	s ipskintest=$s(obj.PHCDFIPSkinTestYY="Y":"1",1:"")
	/// 抗菌药
	s antiflag=$s(obj.PHCDFAntibioticFlag="Y":"Y",1:"")
	/// 危重药 
	s criticalflag=$s(obj.PHCDFCriticalFlag="Y":"Y",1:"")
	/// WhoDDD值
	s whoddd=obj.PHCDFWHODDD
	i whoddd'="" s whoddd=+whoddd
	/// 滴速
	s gttspeed=obj.PHCDFivgttSpeed
	i gttspeed'="" s gttspeed=+gttspeed
	/// 颗粒单位系数
	s granulesfac=obj.PHCDFGranulesFact
	i granulesfac'="" s granulesfac=+granulesfac
	/// 省属常用药物
	s pcommflag=$s(obj.PHCDFProvinceComm="Y":"1",1:"")
	/// 草药备注
	s cyspecinstr=obj.PHCDFCHPhSpecInstr
	s validret=..validCHPhSpecInstr(cyspecinstr)
	i validret<0 d
	.i validret=-1 s msg="草药备注字典"_"不存在" d obj.SetError(msg) s validret=-2042
	.e  i validret=-2 s msg="草药备注"_"不存在" d obj.SetError(msg) s validret=-2043
	e  s cyspecinstr=validret
	/* 药学分类 start */
	s dhcphccat=""
	s phccatstr=obj.DHCPHCCat1_"^"_obj.DHCPHCCat2_"^"_obj.DHCPHCCat3_"^"_obj.DHCPHCCat4_"^"_obj.DHCPHCCat5_"^"_obj.DHCPHCCat6_"^"_obj.DHCPHCCat7
	s validret=..validPhcCat(phccatstr)
	i validret<0 d
	.i validret<-3300 s msg="药学"_(-validret-3300)_"级分类不存在,插入失败" d obj.SetError(msg) 
	.e  i validret<-3200 s msg="药学"_(-validret-3200)_"级分类不存在" d obj.SetError(msg) 
	e  s dhcphccat=validret
	q:validret<0 validret
	/* 药学分类 end */
	/* 等效单位 start */
	s equom1=obj.EQCTUOMDR1
	s validret=..validUom(equom1,3,1)
	i validret<0 d
	.i validret=-1 s msg="等效单位1"_"为空" d obj.SetError(msg) s validret=-2035
	.e  i validret=-2 s msg="等效单位1"_"不存在" d obj.SetError(msg) s validret=-2036
	.e  i validret=-3 s msg="等效单位1"_"不存在,插入失败" d obj.SetError(msg) s validret=-2037
	e  s equom1=validret
	s eqqty1=obj.EQQty1
	s eqdefqty1=obj.EQDefaultDose1
	s equom2=obj.EQCTUOMDR2
	s validret=..validUom(equom2,3,1)
	i validret<0 d
	.i validret=-1 s msg="等效单位2"_"为空" d obj.SetError(msg) s validret=-2038
	.e  i validret=-2 s msg="等效单位2"_"不存在" d obj.SetError(msg) s validret=-2039
	.e  i validret=-3 s msg="等效单位2"_"不存在,插入失败" d obj.SetError(msg) s validret=-2040
	e  s equom2=validret
	s eqqty2=obj.EQQty2
	s eqdefqty2=obj.EQDefaultDose2
	/* 等效单位 end */
	i whoddduom'="" d
	.i (whoddduom'=buom)&&(whoddduom'=equom1)&&(whoddduom'=equom2) d
	..s msg="WhoDDD单位不为基本单位或等效单位"
	..d obj.SetError(msg) 
	..s validret=-2041
	q:validret<0 validret
	s DDD=""   ; DDD值
	i whoddduom'="" d
	.i whoddduom=buom s DDD=whoddd
	.e  i (whoddduom=equom1)&&(+eqqty1'=0) s DDD=whoddd/eqqty1
	.e  i (whoddduom=equom2)&&(+eqqty2'=0) s DDD=whoddd/eqqty2
			  
	s oldphccat="" 	  ; 原药学大类
	s oldphcsubcat="" ; 原药学子类
	s oldphcmincat="" ; 原药学小类
	s agelimit=""	  ; 年龄限制-不用
	s userid=1		  ; 操作人
	s phcdatalist1=incicode_"^"_incidesc_"^"_phcform_"^"_buom_"^"_instruc_"^"_duration_"^"_baseqty_"^"_pmanf_"^"_poison_"^"_freq
	s phcdatalist2=officialcode_"^"_generic_"^"_oldphccat_"^"_oldphcsubcat_"^"_oldphcmincat_"^"_labelname21_"^"_labelname22_"^"_goodname_"^"_officialcode2_"^"_officialcode1
	s phcdatalist3=iponeday_"^"_oponeday_"^"_opskintest_"^"_ipskintest_"^"_DDD_"^"_userid_"^"_antiflag_"^"_criticalflag_"^"_agelimit
	s phcdatalist4=dhcphccat_"^"_whonetcode_"^"_cyspecinstr_"^"_whoddd_"^"_whoddduom_"^"_gttspeed_"^"_granulesfac_"^"_pcommflag
	s phcdatalist=phcdatalist1_"^"_phcdatalist2_"^"_phcdatalist3_"^"_phcdatalist4
	s savephcret=##class(web.DHCST.PHCDRGMAST).Insert(phcdatalist)
	i savephcret>0 d 
	./// 保存等效单位
	.s eqdatalist=equom1_"^"_eqqty1_"^"_eqdefqty1_","_equom2_"^"_eqqty2_"^"_eqdefqty2
	.s saveeqret=..SaveFormDoseEquiv(savephcret,eqdatalist)
	q savephcret
}

/// 验证药品代码
ClassMethod validCode(incicode As %String) As %String
{
	n (incicode)
	q:incicode="" -1
	q:$d(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(incicode)_"Z")) -2
	q:$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(incicode))) -3
	q:$d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(incicode))) -4
	q 0
}

/// 验证药品名称
ClassMethod validDesc(incidesc As %String) As %String
{
	n (incidesc)
	q:incidesc="" -1
	q:$d(^INCI(0,"Desc1",$$ALPHAUP^SSUTIL4(incidesc)_"Z")) -2
	q:$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(incidesc))) -3
	q:$d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(incidesc))) -4
	q 0
}

/// 验证单位,insertflag=3 代表直接传的id
ClassMethod validUom(uom As %String, insertflag As %String = "", packflag As %String = "") As %String
{
	n (uom,insertflag,packflag)
	q:(insertflag=3)&&(packflag="")&&(+uom=0) -1
	q:(insertflag=3)&&(packflag'="")&&(+uom=0) ""
	q:(insertflag=3)&&('$d(^CT("UOM",uom))) -2
	q:insertflag=3 uom
	s retval=""
	q:(packflag'="")&&($$ALPHAUP^SSUTIL4(uom)="") ""
	q:$$ALPHAUP^SSUTIL4(uom)="" -1
	&sql(select ctuom_rowid into :u from ct_uom where ctuom_desc=:uom)
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into  ct_uom(ctuom_code,ctuom_desc,ctuom_foreigndesc) values (:uom,:uom,:uom))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+u
	q retval
}

/// 验证库存分类
ClassMethod validStkCat(stkcat As %String, insertflag As %String = "") As %String
{
	n (stkcat,insertflag)
	q:(insertflag=3)&&(+stkcat=0) -1
	q:(insertflag=3)&&('$d(^INC("SC",stkcat))) -2
	q:insertflag=3 stkcat
	s retval=""
	q:stkcat="" -1
	&sql(select incsc_rowid into :sc from inc_stkcat where incsc_desc=:stkcat)
	i SQLCODE d
	.i insertflag=1 d
	..s type=..sssCode()
	..&sql(insert into  inc_stkcat(incsc_code,incsc_desc,incsc_stktype) values (:stkcat,:stkcat,:type))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+sc
	q retval
}

/// 验证入库单位基本单位的转换系数
/// 验证药学分类
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validPhcCat("抗感染药物^抗3生素^青霉素类^13^1^1","1")
ClassMethod validPhcCat(phccatstr As %String, insertflag As %String = "") As %String
{
	n (phccatstr,insertflag)
	s hospid=$o(^CT("HOSP",0))
	s phccatlen=$l(phccatstr,"^")
	s phccatid="",parref=0,retval="",nullflag=""
	s phccati=""
	f phccati=1:1:phccatlen q:(nullflag'="")||(retval<0)  d
	.s phccat=$p(phccatstr,"^",phccati)
	.i phccat="" s nullflag=1
	.q:phccat=""
	.&SQL(SELECT PHCC_Rowid into :phccatid FROM DHC_PHCCat WHERE PHCC_Desc=:phccat AND PHCC_ParCat_Dr=:parref AND PHCC_Level=:phccati)
	.i SQLCODE d ; 不存在,按等级插入
	..i insertflag="1" d
	...&SQL(insert into DHC_PHCCat (
		   PHCC_Code,PHCC_Desc,PHCC_ParCat_Dr,PHCC_Level,PHCC_Hosp_Dr
		   ) 
		   values (
		   :phccat,:phccat,:parref,:phccati,:hospid		
		   )
		)
	...i SQLCODE'=0 d
	....s retval=-3300-phccati
	...e  d
	....s parref=$G(%ROWID)
	....s retval=$G(%ROWID)
	..e  s retval=-3200-phccati ; 不存在,且不插入
	.e  d
	..s parref=phccatid
	..s retval=phccatid
	q retval
}

/// 验证日期
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validDate()
ClassMethod validDate(date As %String) As %String
{
	n (date)
	q:date="" ""
	s $zt="ErrorvalidDate"
	i date["-" s date=$zdh(date,3) q date
	q ""
ErrorvalidDate
	q -1
}

/// 验证质量层次
ClassMethod validQualityLevel(qulitylevel As %String, insertflag As %String = "") As %String
{
	n (qulitylevel,insertflag)
	q:(insertflag=3)&&(+qulitylevel=0) ""
	q:(insertflag=3)&&('$d(^DHCITMQL(qulitylevel))) -2
	q:insertflag=3 qulitylevel
	s qulitylevel=$$ALPHAUP^SSUTIL4(qulitylevel)
	q:qulitylevel="" ""
	s retval=""
	&SQL(SELECT ql_rowid into :ql FROM DHC_ItmQualityLevel where QL_Desc=:qulitylevel)
	i SQLCODE d
	.i insertflag=1 d
	..s qlstartdate=+$h
	..s qlenddate=$zdh("9999-12-31",3)
	..&sql(insert into  DHC_ItmQualityLevel(ql_code,ql_desc,ql_datefrom,ql_dateto) values (:qulitylevel,:qulitylevel,:qlstartdate,:qlenddate))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+ql
	q retval
}

/// 验证处方药分类-甲类/乙类/双跨
/// 验证定价类型
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validMarkType("sss",1)
ClassMethod validMarkType(marktype As %String, insertflag As %String = "") As %String
{
	n (marktype,insertflag)
	q:(insertflag=3)&&(+marktype=0) ""
	q:(insertflag=3)&&('$d(^DHCINMT(marktype))) -2
	q:insertflag=3 marktype
	s marktype=$$ALPHAUP^SSUTIL4(marktype)
	q:marktype="" ""
	s stktype=..sssCode()
	s retval=""
	&SQL(SELECT MT_Rowid into :mt FROM DHC_MarkType where MT_Desc=:marktype and MT_Type=:stktype)
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into  DHC_MarkType(MT_Code,MT_Desc,MT_UseFlag,MT_Type) values (:marktype,:marktype,'Y',:stktype))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+mt
	q retval
}

/// 验证供应商
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validVendor("validVendor",1)
ClassMethod validVendor(vendor As %String, insertflag As %String = "") As %String
{
	n (vendor,insertflag)
	q:$$ALPHAUP^SSUTIL4(vendor)="" ""
	q:(insertflag=3)&&(+vendor=0) ""
	q:(insertflag=3)&&('$d(^APC("APCVM",vendor))) -2
	q:insertflag=3 vendor	
	s stktype=..sssCode()
	s retval=""
	&sql(select apcvm_rowid into :ar from apc_vendor where apcvm_name=:vendor and apcvm_type=:stktype)	
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into APC_Vendor(apcvm_code,apcvm_name,apcvm_type,apcvm_status,apcvm_rcflag) values (:vendor,:vendor,:stktype,"A","N"))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	..i retval>0 d
	...&sql(insert into dhc_stvendor (STV_Vendor_DR,STV_Type) values (:retval,:stktype))
	...i SQLCODE'=0 d
	....&SQL(delete from APC_Vendor where apcvm_rowid=:retval)
	....s retval=-3
	.e  s retval=-2
	e  d
	.s retval=+ar
	q retval
}

/// 验证配送商
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validCarrier("validCarrier",1)
ClassMethod validCarrier(carrier As %String, insertflag As %String = "") As %String
{
	n (carrier,insertflag)
	q:$$ALPHAUP^SSUTIL4(carrier)="" ""
	q:(insertflag=3)&&(+carrier=0) ""
	q:(insertflag=3)&&('$d(^DHCCARR(carrier))) -2
	q:insertflag=3 carrier	
	s stktype=..sssCode()
	s retval=""
	&sql(select ca_rowid into :cr from dhc_carrier where ca_desc=:carrier and ca_type=:stktype)	
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into dhc_carrier(ca_code,ca_desc,ca_type) values (:carrier,:carrier,:stktype))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+cr
	q retval
}

/// 验证厂商
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validManf("validManf")
ClassMethod validManf(manf As %String, insertflag As %String = "") As %String
{
	n (manf,insertflag)
	q:$$ALPHAUP^SSUTIL4(manf)="" ""
	q:(insertflag=3)&&(+manf=0) ""
	q:(insertflag=3)&&('$d(^PHMNF(manf))) -2
	q:insertflag=3 manf	
	s stktype=..sssCode()
	s retval=""
	&sql(select phmnf_rowid into :pr from ph_manufacturer where phmnf_name=:manf)	
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into  ph_manufacturer(phmnf_code,phmnf_name) values (:manf,:manf))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+pr
	i retval>0 d
	.&SQL(select manf_rowid into :mr from  dhc_manf_addioninfo where manf_phcmanf_dr=:retval)
	.i SQLCODE d
	..&sql(insert into dhc_manf_addioninfo (manf_phcmanf_dr,manf_type,manf_active) values (:retval,:stktype,"Y"))
	..i SQLCODE'=0 d
	...&SQL(delete from ph_manufacturer where phmnf_rowid=:retval)
	...s retval=-3
	q retval
}

/// 验证招标级别
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validPBLevel("validPBLevel")
ClassMethod validPBLevel(pblevel As %String, insertflag As %String = "") As %String
{
	n (pblevel,insertflag)
	q:$$ALPHAUP^SSUTIL4(pblevel)="" ""
	q:(insertflag=3)&&(+pblevel=0) ""
	q:(insertflag=3)&&('$d(^DHCITMPBL(pblevel))) -2
	q:insertflag=3 pblevel	
	s retval=""
	&sql(select pbl_rowid into :pr from DHC_ItmPBLevel where pbl_desc=:pblevel)	
	i SQLCODE d
	.i insertflag=1 d
	..s datefrom=+$h
	..s dateto=$zdh("9999-12-31",3)
	..&sql(insert into DHC_ItmPBLevel(pbl_code,pbl_desc,pbl_datefrom,pbl_dateto) values (:pblevel,:pblevel,:datefrom,:dateto))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+pr
	q retval
}

/// 验证账簿分类
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validBookCat("特种日记账")
ClassMethod validBookCat(bookcat As %String, insertflag As %String = "") As %String
{
	n (bookcat,insertflag)
	q:$$ALPHAUP^SSUTIL4(bookcat)="" ""
	q:(insertflag=3)&&(+bookcat=0) ""
	q:(insertflag=3)&&('$d(^DHCSTBC(bookcat))) -2
	q:insertflag=3 bookcat	
	s retval=""
	&sql(select bc_rowid into :br from DHCST_BookCat where bc_desc=:bookcat)	
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into DHCST_BookCat(bc_code,bc_desc) values (:bookcat,:bookcat))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+br
	q retval
}

/// 验证剂型
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validPhcForm("缓释胶囊",1)
ClassMethod validPhcForm(phcform As %String, insertflag As %String = "") As %String
{
	n (phcform,insertflag)
	s phcform=$$ALPHAUP^SSUTIL4(phcform)
	q:phcform="" -1
	q:(insertflag=3)&&(+phcform=0) -1
	q:(insertflag=3)&&('$d(^PHCF(phcform))) -2
	q:insertflag=3 phcform	
	s retval=""
	&SQL(SELECT PHCF_Rowid into :pfr FROM PHC_Form WHERE PHCF_Desc=:phcform)
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into  PHC_Form(PHCF_Code,PHCF_Desc) values (:phcform,:phcform))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+pfr
	q retval
}

/// 验证用法
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validInstruc("validInstruc",1)
ClassMethod validInstruc(instruc As %String, insertflag As %String = "") As %String
{
	n (instruc,insertflag)
	s instruc=$$ALPHAUP^SSUTIL4(instruc)
	q:instruc="" -1
	q:(insertflag=3)&&(+instruc=0) -1
	q:(insertflag=3)&&('$d(^PHCIN(instruc))) -2
	q:insertflag=3 instruc
	s retval=""
	&SQL(SELECT PHCIN_Rowid into :pir FROM PHC_Instruc WHERE PHCIN_Desc1=:instruc or PHCIN_Desc2=:instruc)
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into  PHC_Instruc(PHCIN_Code,PHCIN_Desc1,PHCIN_Desc2) values (:instruc,:instruc,:instruc))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+pir
	q retval
}

/// 验证疗程
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validDuration("validInstruc",1)
ClassMethod validDuration(duratrion As %String, insertflag As %String = "") As %String
{
	n (duratrion,insertflag)
	s duratrion=$$ALPHAUP^SSUTIL4(duratrion)
	q:duratrion="" -1
	q:(insertflag=3)&&(+duratrion=0) -1
	q:(insertflag=3)&&('$d(^PHCDU(duratrion))) -2
	q:insertflag=3 duratrion
	s retval=""
	&SQL(SELECT PHCDU_Rowid into :pdr FROM PHC_Duration WHERE PHCDU_Code=:duratrion OR PHCDU_Desc1=:duratrion OR PHCDU_Desc2=:duratrion)
	i SQLCODE d
	.s retval=-2
	e  d
	.s retval=+pdr
	q retval
}

/// 验证管制分类
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validPoison("validPoison",1)
ClassMethod validPoison(poison As %String, insertflag As %String = "") As %String
{
	n (poison,insertflag)
	s poison=$$ALPHAUP^SSUTIL4(poison)
	q:poison="" ""
	q:(insertflag=3)&&(+poison=0) ""
	q:(insertflag=3)&&('$d(^PHCPO(poison))) -2
	q:insertflag=3 poison	
	s retval=""
	&SQL(SELECT PHCPO_Rowid into :ppr FROM PHC_Poison WHERE PHCPO_Desc=:poison)
	i SQLCODE d
	.i insertflag=1 d
	..s poisoncode=poison
	..i poison["抗菌" d
	...i poison["非限制" s poisoncode="KSS1"
	...e  i poison["限制" s poisoncode="KSS2"
	...e  i poison["特殊" s poisoncode="KSS3"
	..&sql(insert into  PHC_Poison(PHCPO_Code,PHCPO_Desc,PHCPO_MHRpt,PHCPO_OTCFlag,PHCPO_SaleRpt) values (:poison,:poison,'N','N','N'))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+ppr
	q retval
}

/// 验证频次
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validFreq("validFreq",1)
ClassMethod validFreq(freq As %String, insertflag As %String = "") As %String
{
	n (freq,insertflag)
	s freq=$$ALPHAUP^SSUTIL4(freq)
	q:freq="" ""
	q:(insertflag=3)&&(+freq=0) ""
	q:(insertflag=3)&&('$d(^PHCFR(freq))) -2
	q:insertflag=3 freq	
	s retval=""
	&SQL(SELECT PHCFR_Rowid into :pfr FROM PHC_Freq WHERE PHCFR_Code=:freq OR PHCFR_Desc1=:freq OR PHCFR_Desc2=:freq)
	i SQLCODE d
	.s retval=-2
	e  d
	.s retval=+pfr
	q retval
}

/// 验证医保类别
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validOfficialCode("validOfficialCode",1)
ClassMethod validOfficialCode(officialcode As %String, insertflag As %String = "") As %String
{
	n (officialcode,insertflag)
	s officialcode=$$ALPHAUP^SSUTIL4(officialcode)
	q:officialcode="" ""
	q:(insertflag=3)&&(+officialcode=0) ""
	q:(insertflag=3)&&('$d(^DHCITMIC(officialcode))) -2
	q:insertflag=3 officialcode	
	s retval=""
	&SQL(SELECT IC_Rowid into :ir FROM DHC_ItmInsuCategory WHERE IC_Desc=:officialcode)
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into  DHC_ItmInsuCategory(IC_Code,IC_Desc,IC_DateFrom) values (:officialcode,:officialcode,+$h))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+ir
	q retval
}

/// 验证通用名
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validGeneric("validGeneric",1)
ClassMethod validGeneric(generic As %String, insertflag As %String = "") As %String
{
	n (generic,insertflag)
	s generic=$$ALPHAUP^SSUTIL4(generic)
	q:generic="" ""
	q:(insertflag=3)&&(+generic=0) ""
	q:(insertflag=3)&&('$d(^PHCGE("GE",generic))) -2
	q:insertflag=3 generic	
	s retval=""
	&SQL(SELECT PHCGE_Rowid into :pgr FROM PHC_Generic WHERE PHCGE_Name=:generic OR PHCGE_Code=:generic)
	i SQLCODE d
	.i insertflag=1 d
	..&sql(insert into  PHC_Generic(PHCGE_Name,PHCGE_Code,PHCGE_DateFrom) values (:generic,:generic,+$h))
	..s retval=$s(SQLCODE=0:$G(%ROWID),1:-3)
	.e  s retval=-2
	e  d
	.s retval=+pgr
	q retval
}

/// 验证草药备注
ClassMethod validCHPhSpecInstr(cyspecinstr)
{
	n (cyspecinstr)
	s cyspecinstrId=""
	q:cyspecinstr="" ""
	s cyInstrStr=$g(^DHCDocConfig("CNMedItemPhSpecInstr"))
	q:cyInstrStr="" -1
	s cyLen=$l(cyInstrStr,"^")
	f cyI=1:1:cyLen q:cyspecinstrId'=""  d
	.s cyInstr=$p(cyInstrStr,"^",cyI)
	.s cyInstrId=$p(cyInstr,$c(1),1)
	.s cyInstrDesc=$p(cyInstr,$c(1),2)
	.i cyInstrDesc=cyspecinstr s cyspecinstrId=cyInstrId
	q:cyspecinstrId'="" cyspecinstrId
	q -2
}

/// 验证whonet码
/// w ##class(web.DHCST.Tools.InputDrugBasicData).validWhoNetCode("validWhoNetCode",1)
ClassMethod validWhoNetCode(whonetcode As %String, insertflag As %String = "") As %String
{
	n (whonetcode,insertflag)
	s whonetcode=$$ALPHAUP^SSUTIL4(whonetcode)
	q:whonetcode="" ""
	s retval="" //-2
	s WhonetFlag=""
	i $d(^DHCLISBSVersion(1)) d //dhc-lisdata
	.s whonetcode=" "_whonetcode  //该索引首字符为空格
	.s LabData="dhc-lisdata"
	.i '$d(^[LabData]dbo.BTAntibioticsI("IndexWCode",whonetcode)) s retval=-2
	e  d //labtrak
 	.s LabData="labdata"
    .s wCode="" f  s wCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode)) q:wCode=""  d
    ..s antCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode,"")) q:(antCode="")!(WhonetFlag'="")
    ..s retval=-2
    ..q:whonetcode'=antCode
 	..s retval="",WhonetFlag=1
 	q retval
}

/// 保存等效单位
ClassMethod SaveFormDoseEquiv(phcdfrowid, eqlistdata)
{
	n (eqlistdata,phcdfrowid)
	s eqlen=$l(eqlistdata,",")
	s eqi=0
	f eqi=1:1:eqlen d
	.s eqdata=$p(eqlistdata,",",eqi)
	.s equomdr=$p(eqdata,"^",1)
	.s eqqty=$p(eqdata,"^",2)
	.s eqdefqty=$p(eqdata,"^",3)
	.q:(equomdr="")||(eqqty="")
	.&SQL(SELECT EQ_rowid into :eqid FROM PHC_FormDoseEquiv WHERE EQ_ParRef=:phcdfrowid AND EQ_CTUOM_DR=:equomdr)
	.i SQLCODE d
	..&sql(INSERT INTO PHC_FormDoseEquiv(EQ_ParRef,EQ_CTUOM_DR,EQ_Qty,EQ_DefaultDose)
		VALUES (:phcdfrowid,:equomdr,:eqqty,:eqdefqty))
	q 0
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

/// 测试保存库存项
/// w ##class(web.DHCST.Tools.InputDrugBasicData).TestSaveInci()
ClassMethod TestSaveInci()
{

	&SQL(DELETE FROM INC_Itm WHERE INCI_Code='YHB20170113001')
	&SQL(DELETE FROM DHC_ItmAddionInfo  WHERE INFO_INCI_DR->INCI_Code='YHB20170113001')
	s tmpdata="INCICode^YHB20170113001|"
	s tmpdata=tmpdata_"INCIDesc^云海宝测试20170113001|"
	s tmpdata=tmpdata_"INCICTUOMDR^粒|"
	s tmpdata=tmpdata_"INCICTUOMPurchDR^盒[16粒]|"
	s tmpdata=tmpdata_"INCIINCSCDR^采血耗材|"
	s tmpdata=tmpdata_"INCALIAS^aaa/bbb/ccc|"
	s tmpdata=tmpdata_"INCIBarCode^20170113|"
	s tmpdata=tmpdata_"INFOSpec^盒(16)|"
	s tmpdata=tmpdata_"INFOBasicDrug^Y|"
	s tmpdata=tmpdata_"INFORemark^国药准字-H001|"
	s tmpdata=tmpdata_"INFODrugUse^用户所没打好大赛等哈|"
	s tmpdata=tmpdata_"INFODrugbase2^Y|"
	s tmpdata=tmpdata_"INFOStandardCode^98741499721728179|"
	s tmpdata=tmpdata_"ISCDark^Y|"
	s tmpdata=tmpdata_"ISCMaxHumidity^20|"
	s tmpdata=tmpdata_"INFOImportFlag^进g口|"
	s tmpdata=tmpdata_"INFOComFrom^中国广西|"
	s tmpdata=tmpdata_"INFOInHosFlag^Y|"
	s tmpdata=tmpdata_"INFOInHosFlag^Y|"
	s tmpdata=tmpdata_"INFOPbCarrierDR^zl配送商001|"
	s tmpdata=tmpdata_"INFOMaxSp^998|"
	s return=..SaveInci(tmpdata)
	q return
}

/// 测试保存药学项
/// w ##class(web.DHCST.Tools.InputDrugBasicData).TestSavePhc()
ClassMethod TestSavePhc()
{
	&SQL(DELETE FROM INC_Itm WHERE INCI_Code='YHB20170113001')
	&SQL(DELETE FROM DHC_ItmAddionInfo  WHERE INFO_INCI_DR->INCI_Code='YHB20170113001')	
	s tmpphcdata="INCICode^YHB20170113001|"
	s tmpphcdata=tmpphcdata_"INCIDesc^云海宝测试20170113001|"
	s tmpphcdata=tmpphcdata_"INCICTUOMDR^粒|"
	s tmpphcdata=tmpphcdata_"DHCPHCCat1^11111111|"
	s tmpphcdata=tmpphcdata_"DHCPHCCat2^22222222|"
	s tmpphcdata=tmpphcdata_"DHCPHCCat3^33333333|"
	s return=..SavePhc(tmpphcdata)
	q return
}

/// /w ##class(web.DHCST.Tools.InputDrugBasicData).Testdalete()
ClassMethod Testdalete()
{
	&SQL(DELETE FROM INC_Itm WHERE INCI_Code='chenyingceshi001')
	&SQL(DELETE FROM DHC_ItmAddionInfo  WHERE INFO_INCI_DR->INCI_Code='chenyingceshi001')
	&SQL(DELETE FROM PHC_DrgMast WHERE PHCD_Code='chenyingceshi001')
	
	q 1
}

/// 测试保存库存药学项
/// w ##class(web.DHCST.Tools.InputDrugBasicData).TestSaveDrug()
ClassMethod TestSaveDrug()
{
	s obj=..%New()	
	/// 基本单位(名称)
	s buomdesc="片"
	&sql(select ctuom_rowid into :INCICTUOMDR from ct_uom where ctuom_desc=:buomdesc)
	s obj.INCICTUOMDR=INCICTUOMDR
	/// 入库单位(名称)
	s puomdesc="盒(20)"
	&sql(select ctuom_rowid into :INCICTUOMPurchDR from ct_uom where ctuom_desc=:puomdesc)
	s obj.INCICTUOMPurchDR=INCICTUOMPurchDR
	/// 库存分类(名称)
	s stkcatdesc="西药"
	&sql(select incsc_rowid into :INCIINCSCDR from inc_stkcat where incsc_desc=:stkcatdesc)
    s obj.INCIINCSCDR=INCIINCSCDR
    /// 别名
	s obj.INCALIAS="FFLJDHSY/LJDHSY/KT"
	/// 不可用标志(Y/N)
	s obj.INCINotUseFlag=""
	/// 条码
	s obj.INCIBarCode="条码"
	/// 售价
	s obj.Sp=14.67
 	/// 进价
	s obj.Rp=""
	/// 价格生效日期(yyyy-MM-dd,空为当天)
    s obj.PriceDate="2017-03-22"
	/// 规格
	s obj.INFOSpec="20片"
	/// 进口标志(国产/进口/合资)
	s obj.INFOImportFlag="国产"
	/// 质量层次
	s obj.INFOQualityLevel=""
	/// 处方药分类(甲类/乙类/双跨)
	s obj.INFOOTC=""
	/// 基本药物标志(Y/N)
	s obj.INFOBasicDrug="Y"
	/// 中国药典标志(Y/N)
	s obj.INFOCodex="Y"
	/// 临床验证用药标志(Y/N)
	s obj.INFOTest="Y"
	/// 处方购药标志(Y/N)
	s obj.INFORec="Y"
	/// 质量编号
	s obj.INFOQualityNo=""
	/// 国(省)别
	s obj.INFOComFrom=""
	/// 批准文号(国药准字-H0023N1)
	s obj.INFORemark="批准文号"
	/// 高值类标志(Y/N)
	s obj.INFOHighPrice=""
	/// 定价类型(名称)
	s obj.INFOMTDR=""
	/// 最高售价
	s obj.INFOMaxSp=100
	/// 本院药品目录标志(Y/N)
	s obj.INFOInHosFlag="Y"
	/// 招标进价
	s obj.INFOPbRp=""
	/// 招标供应商(全称)
	s obj.INFOPbVendorDR=""
	/// 招标生产商(全称)
	s obj.INFOPbManfDR=""
	/// 招标配送商(全称)
	s obj.INFOPbCarrierDR=""
	/// 招标级别
	s obj.INFOPBLevel=""
	/// 阳光采购标志(Y/N)
	s obj.INFOBAflag="Y"
	/// 物价文件号
	s obj.INFOPrcFile=""
	/// 物价文件备案时间(yyyy-MM-dd)
	s obj.INFOPrcFileD=""
	/// 皮试标志(Y/N)
	s obj.INFOSkinTest="Y"
	/// 帐簿分类(名称)
	s bookcat="特种日记账"
	&sql(select bc_rowid into :INFOBCDr from DHCST_BookCat where bc_desc=:bookcat)
	s obj.INFOBCDr=INFOBCDr
	/// 用药说明
	s obj.INFODrugUse=""
	/// 省基本药物标志(Y/N)
	s obj.INFODrugbase2="Y"
	/// 市级基本药物(Y/N)
	s obj.INFOPDrugbase1="Y"
	/// 区(县)基本药物(Y/N)
	s obj.INFOPDrugbase2="Y"
	/// 药品本位码
	s obj.INFOStandardCode=""
	/// 进药依据
	s obj.INFOInMedBasis=""
	/// 大包装单位
	s obj.INFOPackUom="盒(20)"
	/// 大包装单位系数
	s obj.INFOPackUomFactor=1
	/// 存储条件-常温(Y/N)
	s obj.ISCCommonTemp=""
	/// 存储条件-干燥(Y/N)
	s obj.ISCDry=""
	/// 存储条件-密闭(Y/N)
	s obj.ISCAirtight=""
	/// 存储条件-避光(Y/N)
	s obj.ISCDark=""
	/// 存储条件-通风(Y/N)
	s obj.ISCVentilate=""
	/// 存储条件-防辐射(Y/N)
	s obj.ISCRadiation=""
	/// 存储条件-熔封(Y/N)
	s obj.ISCSeal=""
	/// 存储条件-阴凉(Y/N)
	s obj.ISCCoolGloomy=""
	/// 存储条件-凉暗(Y/N)
	s obj.ISCGloomyCool=""
	/// 存储条件-密封(Y/N)
	s obj.ISCMeltPack=""
	/// 存储条件-冷藏(Y/N)
	s obj.ISCCOLDST=""
	/// 存储条件-冷冻(Y/N)
	s obj.ISCFREEZE=""
	/// 存储条件-防潮(Y/N)
	s obj.ISCDAMPPROOF=""
	/// 存储条件-最低湿度
	s obj.ISCMinHumidity=""
	/// 存储条件-最高湿度
	s obj.ISCMaxHumidity=""
	/// 存储条件-最低温度
	s obj.ISCMinTemp=""
	/// 存储条件-最高温度
	s obj.ISCMaxTemp=""
	/// 药品代码
	s obj.INCICode="A01AB5102A"
	/// 药品名称
	s INCIDesc="复方氯己定含片(口泰)[20片]A"
	/// 剂型(名称)
	s formdesc="溶液"
	&SQL(SELECT PHCF_Rowid into :PHCDFPHCFDR FROM PHC_Form WHERE PHCF_Desc=:formdesc)
	s obj.PHCDFPHCFDR=PHCDFPHCFDR
	/// 用法(名称)
	s instrudesc="漱口"
	&SQL(SELECT PHCIN_Rowid into :PHCDFPHCINDR FROM PHC_Instruc WHERE PHCIN_Desc1=:instruc or PHCIN_Desc2=:instrudesc)
	s obj.PHCDFPHCINDR=PHCDFPHCINDR
	/// 疗程(名称)
	s duration="1天"
	&SQL(SELECT PHCDU_Rowid into :PHCDFPHCDUDR FROM PHC_Duration WHERE PHCDU_Code=:duration OR PHCDU_Desc1=:duration OR PHCDU_Desc2=:duration)
	s obj.PHCDFPHCDUDR=PHCDFPHCDUDR
	/// 基本数量(数字)
	s obj.PHCDFBaseQty=1
	/// 厂商(全称)
	s phmanf="深圳南粤"
	&sql(select phmnf_rowid into :PHCDPHMNFDR from ph_manufacturer where phmnf_name=:phmanf)
	s obj.PHCDPHMNFDR=PHCDPHMNFDR
	/// 管制分类(名称)
	s obj.PHCDPHCPODR=""
	/// 频次(名称)
	s freqdesc="Bid"
	&SQL(SELECT PHCFR_Rowid into :PHCDFPHCFRDR FROM PHC_Freq WHERE PHCFR_Code=:freqdesc OR PHCFR_Desc1=:freqdesc OR PHCFR_Desc2=:freqdesc)
	s obj.PHCDFPHCFRDR=PHCDFPHCFRDR
	/// 医保类别(全称-字典维护)
	s obj.PHCDOfficialCode=""
	/// 通用名(名称)
	s genename="复方氯己定含漱液"
	&SQL(SELECT PHCGE_Rowid into :PHCDGenericDR FROM PHC_Generic WHERE PHCGE_Name=:genename OR PHCGE_Code=:genename)
	s obj.PHCDGenericDR=PHCDGenericDR
	/// 英文国际非专利药名
	s obj.PHCDLabelName21="英文国际非专利药名"
	/// 国际专利药名
	s obj.PHCDLabelName22="国际专利药名"
	/// 商品名
	s obj.PHCDLabelName1="商品名"
	/// 制剂通用名
	s obj.PHCDFOfficialCode1=""
	/// 原料通用名
	s obj.PHCDFOfficialCode2=""
	/// 住院一天量标志(Y/N)
	s obj.PHCDFDeductPartially="Y"
	/// 门诊一天量标志(Y/N)
	s obj.PHCDFCalcuDose="Y"
	/// 门诊皮试用原液(Y/N)
	s obj.PHCDFOPSkinTestYY="Y"
	/// 住院皮试用原液(Y/N)
	s obj.PHCDFIPSkinTestYY="Y"
	/// 抗菌药标志(Y/N)
	s obj.PHCDFAntibioticFlag="Y"
	/// 危重药标志(Y/N)
	s obj.PHCDFCriticalFlag="Y"
	/// WHONET码
	s obj.PHCDFWHONET=""
	/// 草药备注-----------------待确定怎么存
	s obj.PHCDFCHPhSpecInstr=""
	/// WhoDDD值
	s obj.PHCDFWHODDD="1"
	/// WhoDDD单位(名称)
	s whoddduomdesc="片"
	&sql(select ctuom_rowid into :PHCDFWHODDDUomDr from ct_uom where ctuom_desc=:whoddduomdesc)
	s obj.PHCDFWHODDDUomDr=PHCDFWHODDDUomDr
	/// 滴速(数字,对应单位gtt/min)
	s obj.PHCDFivgttSpeed=""
	/// 颗粒单位系数
	s obj.PHCDFGranulesFact=""
	/// 省属常用药物(Y/N)
	s obj.PHCDFProvinceComm="Y"
	/// 药学分类1级(名称)
	s phccatstr="安神剂^清肝安神"
	s validret=..validPhcCat(phccatstr)
	i validret<0 d
	.i validret<-3300 s msg="药学"_(-validret-3300)_"级分类不存在,插入失败" d obj.SetError(msg) 
	.e  i validret<-3200 s msg="药学"_(-validret-3200)_"级分类不存在" d obj.SetError(msg) 
	e  s dhcphccat=validret
	q:validret<0 validret
	/// 等效单位1(名称)
	s equom1desc="mg"
	&sql(select ctuom_rowid into :EQCTUOMDR1 from ct_uom where ctuom_desc=:equom1desc)
	s obj.EQCTUOMDR1=EQCTUOMDR1
	/// 等效数量1
	s obj.EQQty1=10
	/// 缺省数量1
	s obj.EQDefaultDose1=10
	/// 等效单位2(名称)
	s equom2desc="片"
	&sql(select ctuom_rowid into :EQCTUOMDR2 from ct_uom where ctuom_desc=:equom2desc)
	s obj.EQCTUOMDR2=EQCTUOMDR2
	/// 等效数量2
	s obj.EQQty2=10
	/// 缺省数量2
	s obj.EQDefaultDose2=10
	s phcret=obj.InputPhcMast()
	/// i phcret<0 w obj.ErrorCode,! ; 测试用
	q:obj.ErrorCode'="" phcret
	s inciret=obj.InputIncItm()
	/// i inciret<0 w obj.ErrorCode,! ; 测试用
	q:obj.ErrorCode'="" inciret
	q phcret_"^"_inciret
}

}
