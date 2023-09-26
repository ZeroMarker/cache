Import sqluser

/// 物资导入程序(供 基础数据产品线-数据导入界面 调用)
/// Author:zhwh
/// Date:2016-12-19 
/// 修改：院区增加 20200415lihui
/// Input:		LinkHospId(医院id,如有多个,使用/隔开)
/// 
/// 导入物资
/// d ##Class(web.DHCSTMHUI.Tools.CodeInputX).SaveInci(s,LinkHospId)
///   
/// 导入供应商
/// d ##Class(web.DHCSTMHUI.Tools.CodeInputX).SaveVendor(s,LinkHospId)
///   
/// 导入生产厂家
/// d ##Class(web.DHCSTMHUI.Tools.CodeInputX).SaveManf(s,LinkHospId)
///  
/// 导入分类
/// d ##Class(web.DHCSTMHUI.Tools.CodeInputX).SaveStkCat(s,LinkHospId)
/// 
Class web.DHCSTMHUI.Tools.CodeInputX Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 是否收费(Y/N)
Property Charge As %String;

/// 库存大类
Property CatGrp As %String;

/// 库存子类
Property StkCat As %String;

/// 物资代码
Property Code As %String;

/// 物资名称
Property Desc As %String;

/// 规格
Property Spec As %String;

/// 型号
Property Model As %String;

/// 产地
Property Origin As %String;

/// 品牌
Property Brand As %String;

/// 简称
Property Abbr As %String;

/// 别名
Property Alias As %String;

/// 基本库存单位
Property BUom As %String;

/// 整包装库存单位
Property PUom As %String;

/// 整包转换系数
Property Factor As %String;

/// 账单单位
Property FeeUom As %String;

/// 进价
Property RP As %String;

/// 零售价
Property SP As %String;

/// 价格信息
Property PriceInformation As %String;

/// 是否高值(Y/N)
Property HighValue As %String;

/// 是否需要批号(Y/N)
Property BatRequired As %String;

/// 是否需要效期(Y/N)
Property ExpdateRequired As %String;

/// 监管级别（1/2/3）
Property Supervision As %String;

/// 条码
Property Barcode As %String;

/// 招标标志(Y/N)
Property PbFlag As %String;

/// 招标进价(按整包装单位计)
Property PbRP As %String;

/// 供应商名称
Property Vendor As %String;

/// 生产商名称
Property Manf As %String;

/// 配送商名称
Property Carrier As %String;

/// 注册证号
Property RegisterNo As %String;

/// 注册证效期
Property RegisterExpdate As %String;

/// 注册证批准日期
Property RegCertDate As %String;

/// 备注
Property Remarks As %String;

/// 大包装单位 2017-02-20
Property PackUomMax As %String;

/// 大包装转换系数 2017-02-20
Property PackUomFacMax As %String;

/// 医用耗材代码
Property InsuMatCode As %String;

/// *************************生产厂家 *************************
/// 代码	
Property mCode As %String;

/// 描述
Property mName As %String;

/// 简称
Property mShortName As %String;

/// 别名
Property mAlias As %String;

/// 类型(G药品,M物资材料)
Property mType As %String;

/// 电话
Property mTel As %String;

/// 地址
Property mAddress As %String;

/// 营业执照
Property mComLic As %String;

/// 营业执照起始日期
Property mComLicDateFrom As %String;

/// 营业执照截止日期
Property mComLicDateTo As %String;

/// 生产许可(II,III)
Property mInsProLic As %String;

/// 生产许可起始日期
Property mInsProLicDateFrom As %String;

/// 生产许可截止日期
Property mInsProLicDateTo As %String;

/// 一类生产备案
Property mFirstProdLic As %String;

/// 一类生产备案起始日期
Property mFirstProdLicDateFrom As %String;

/// 一类生产备案截止日期
Property mFirstProdLicDateTo As %String;

/// *************************供应商 *************************
/// 代码	
Property vCode As %String;

/// 描述
Property vName As %String;

/// 简称
Property vShortName As %String;

/// 别名
Property vAlias As %String;

/// 类型(G药品,M物资材料)
Property vType As %String;

/// 电话
Property vTel As %String;

/// 地址
Property vAddress As %String;

/// 供应商通用标志(V8.4之后,不再使用)
Property vUniversal As %String;

/// 营业执照
Property vComLic As %String;

/// 营业执照起始日期
Property vComLicDateFrom As %String;

/// 营业执照截止日期
Property vComLicDateTo As %String;

/// 器械经营许可(III)
Property vInsBusLic As %String;

/// 器械经营许可起始日期
Property vInsBusLicDateFrom As %String;

/// 器械经营许可截止日期
Property vInsBusLicDateTo As %String;

/// 二类经营备案
Property vSecondBusLic As %String;

/// 二类经营备案起始日期
Property vSecondBusLicDateFrom As %String;

/// 二类经营备案截止日期
Property vSecondBusLicDateTo As %String;

///  ***************库存"类组/分类"*****************					
/// 库存类组归类
Property scSet As %String;

/// 库存类组代码
Property scSGCode As %String;

/// 库存类组描述
Property scSGDesc As %String;

/// 库存类组结构模式(Y:医嘱项 一对多 库存项, N或空:一对一)
Property scSGStruModeFlag As %String;

/// 库存分类代码
Property scSCCode As %String;

/// 库存分类描述
Property scSCDesc As %String;

/// 库存类组类型（G药物、M材料物资）
Property scStkType As %String;

/// 进口标志
Property ImportFlag As %String;

/// 质地
Property MatQuality As %String;

/// 植入标志
Property ImplantFlag As %String;

/// 集采标志
Property CentralPurFlag As %String;

/// 临采标志
Property TemPurchase As %String;

/// 本院目录标志
Property InHosFlag As %String;

/// 账簿分类
Property BookCat As %String;

/// 东华数据导入库存部分接口程序
/// w ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveInci("Code^GZ0000401|Desc^补片(外科生物补片)[4*6]|Charge^Y|CatGrp^16|StkCat^53|Spec^40*60|Model^型号|Origin^24|Brand^品牌|Abbr^补片(外科生物补片)[4*6]|Alias^BP|BUom^4|PUom^4|Factor^1|FeeUom^4|RP^5620|SP^5620|PriceInformation^|HighValue^Y|BatRequired^|ExpdateRequired^|Supervision^|Barcode^|PbFlag^|PbRP^|Vendor^523|Manf^1422|Carrier^|RegisterNo^国食药监械(准)字2013第3461592号|RegisterExpdate^2029-09-09|ProductionLicense^生产经营|ProductionLicenseExpdate^2029-09-09|BusinessLicense^经营许可|BusinessLicenseDate^2029-09-09|RevReg^注册|OrgCode^机构代码|OrgCodeDate^2029-09-09|BusinessCertificate^经营|BusinessCertificateExpdate^2029-09-09|AuthorizationDate^2029-09-09|ContactPerson^授权人|ContactTel^1233434244|Remarks^|PackUomMax^箱|PackUomFacMax^2")
/// w ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveInci("Code^GZ0000401|Desc^补片(外科生物补片)[4*6]|Charge^Y|CatGrp^24|StkCat^54|Spec^40*60|Model^型号|Origin^25|Brand^品牌|Abbr^补片(外科生物补片)[4*6]|Alias^BP|BUom^4|PUom^4|Factor^1|FeeUom^4|RP^5620|SP^5620|PriceInformation^|HighValue^N|BatRequired^|ExpdateRequired^|Supervision^|Barcode^|PbFlag^|PbRP^|Vendor^522|Manf^1423|Carrier^45|RegisterNo^国食药监械(准)字2013第3461592号|RegisterExpdate^2029-09-09|ProductionLicense^生产经营|ProductionLicenseExpdate^2029-09-09|BusinessLicense^经营许可|BusinessLicenseDate^2029-09-09|RevReg^注册|OrgCode^机构代码|OrgCodeDate^2029-09-09|BusinessCertificate^经营|BusinessCertificateExpdate^2029-09-09|AuthorizationDate^2029-09-09|ContactPerson^授权人|ContactTel^1233434244|Remarks^|PackUomMax^箱|PackUomFacMax^2")
ClassMethod SaveInci(DataList As %String, LinkHospId) As %String
{
	n (DataList,LinkHospId,%session)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"SaveInci"
	s Params=DataList_";"_LinkHospId
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="SaveInciErr"
	d ..sssSetLogID()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Obj=..%New()
	s Ret=Obj.SetPrValue(DataList)
	i Ret<0 q RtnObj.Err(-1,"","参数解析失败","",0).Json()
	
	s RtnObj=Obj.InputIncItm(LinkHospId)
	d ..sssKillLogID()
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",RtnObj.Json())
	q RtnObj.Json()
SaveInciErr
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// 导入供应商的接口程序
/// w ##Class(web.DHCSTMHUI.Tools.CodeInputX).SaveVendor("vCode^AM0000401|vName^东华医为|vShortName^东华医为|vAlias^YCKYYLQXYXGS|vType^M|vTel^|vAddress^|vUniversal^")
/// w ##Class(web.DHCSTMHUI.Tools.CodeInputX).SaveVendor("vCode^AM0000402|vName^东华医为|vShortName^东华医为|vAlias^YCKYYLQXYXGS|vType^M|vTel^|vAddress^|vUniversal^")
ClassMethod SaveVendor(DataList As %String, LinkHospId) As %String
{
	n (DataList,LinkHospId,%session)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"SaveInci"
	s Params=DataList_";"_LinkHospId
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="SaveVendorErr"
	d ..sssSetLogID()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Obj=..%New()
	s Ret=Obj.SetPrValue(DataList)
	i Ret<0 q RtnObj.Err(-1,"","参数解析错误","",0)
	
	s RtnObj=Obj.InputVendor(LinkHospId)
	d ..sssKillLogID()
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",RtnObj.Json())
	q RtnObj.Json()
SaveVendorErr
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// 导入生产厂家的接口程序
/// w ##Class(web.DHCSTMHUI.Tools.CodeInputX).SaveManf("mCode^ABC0102|mName^ABC0102厂商|mShortName^0102厂商|mAlias^abc|mType^M|mTel^15610362766|mAddress^山东泰安高新区|mComLic^ABCD123456|mComLicDateFrom^2020-01-01|mComLicDateTo^2025-12-31|mInsProLic^ABCD123scxk|mInsProLicDateFrom^2019-01-01|mInsProLicDateTo^2024-12-31|mFirstProdLic^ABCD123ylba|mFirstProdLicDateFrom^2018-01-01|mFirstProdLicDateTo^2023-12-31",2)
ClassMethod SaveManf(DataList As %String, LinkHospId) As %String
{
	n (DataList,LinkHospId,%session)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"SaveInci"
	s Params=DataList_";"_LinkHospId
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="SaveManfErr"
	d ..sssSetLogID()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Obj=..%New()
	s Ret=Obj.SetPrValue(DataList)
	i Ret<0 q RtnObj.Err(-1,"","参数解析失败","",0).Json()
	
	s RtnObj=Obj.InputManf(LinkHospId)
	d ..sssKillLogID()
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",RtnObj.Json())
	q RtnObj.Json()
SaveManfErr
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// 程序库存类组/分类的接口程序
/// w ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveStkCat("scSet^|scSGCode^SG001|scSGDesc^类组重复1|scSCCode^SC001|scSCDesc^库存分类重复|scStkType^M")
ClassMethod SaveStkCat(DataList As %String, LinkHospId) As %String
{
	n (DataList,LinkHospId,%session)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"SaveInci"
	s Params=DataList_";"_LinkHospId
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="SaveStkCatErr"
	d ..sssSetLogID()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Obj=..%New()
	s Ret=Obj.SetPrValue(DataList)
	i Ret<0 q RtnObj.Err(-1,"","参数解析失败","",0).Json()
	
	s RtnObj=Obj.InputStkCat(LinkHospId)
	d ..sssKillLogID()
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",RtnObj.Json())
	q RtnObj.Json()
SaveStkCatErr
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// 处理一行数据
Method InputIncItm(LinkHospId) As web.DHCSTMHUI.RtnObj
{
	n (LinkHospId,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s HospId=LinkHospId
	s IfAllowHospNull=##class(web.DHCSTMHUI.Tools.CodeInputX).IfAllowHospNull("INC_Itm")
	i ((IfAllowHospNull="Y")&&(HospId="")) q RtnObj.Err(-11,"","医院信息为空","",0)
	
	s AdjSpNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo("DHCSTADJSPM","","",HospId)
	
	s obj=$THIS
	s code=obj.Code				;代码
	s desc=obj.Desc				;描述
	s alias=obj.Alias			;别名
	s spec=obj.Spec				;规格
	s model=obj.Model			;型号
	s brand=obj.Brand			;品牌
	s abbr=obj.Abbr				;简称
	s buom=obj.BUom				;基本单位Id
	s puom=obj.PUom				;整包装单位Id
	s factor=obj.Factor			;换算系数
	s PackUomMax=obj.PackUomMax
	s PackUomFacMax=obj.PackUomFacMax	;大包装单位与入库单位(puom)的转换因子
	s scg=obj.CatGrp			;类组(大类)
	s stkcat=obj.StkCat			;库存分类(子类)
	s manf=obj.Manf				;生产厂商Id
	s vendor=obj.Vendor			;供应商Id
	s rp=obj.RP					;进价(整包装单位)
	s sp=obj.SP					;售价(整包装单位)
	s priceinformation=obj.PriceInformation		//价格信息
	s barcode=obj.Barcode		;条码
	s charge=obj.Charge			;收费标志
	s remarks=obj.Remarks		;备注
	s batReq=obj.BatRequired	;批号要求
	s expReq=obj.ExpdateRequired	;效期要求
	s hv=obj.HighValue			;高值标志 : "Y"或者"N"
	s carrier=obj.Carrier		;配送商Id
	s stOrigin=obj.Origin		;产地Id
	s registerno=obj.RegisterNo	;器械注册证
	s registerexpdate=obj.RegisterExpdate	;器械注册证效期
	s RegCertDate=obj.RegCertDate	;注册证批准日期
	s InsuMatCode=obj.InsuMatCode	;医用耗材代码
	s ImportFlag=obj.ImportFlag	;进口标志
	s MatQuality=obj.MatQuality	;质地
	s ImplantFlag=obj.ImplantFlag	;植入标志
	s CentralPurFlag=obj.CentralPurFlag	;集采标志
	s TemPurchase=obj.TemPurchase	;临采标志
	s InHosFlag=obj.InHosFlag	;本院目录标志
	s BookCat=obj.BookCat	;账簿分类
	s PbFlag=obj.PbFlag	;招标标志
	
	s rp=+rp,sp=+sp
	s remarksList=$lfs(remarks,$c(13,10))
	s:batReq="Y" batReq="R"
	s:batReq="" batReq="O"
	s:expReq="Y" expReq="R"
	s:expReq="" expReq="O"
	
	s msg="",Flag="Y"
	
	i desc="" s msg="描述为空"
	e  i buom="" s msg="基本单位为空"
	e  i puom="" s msg="入库单位为空"
	e  i scg="" s msg="类组为空"
	e  i stkcat="" s msg="库存分类为空"
	i msg'="" q RtnObj.Err(-2,"",msg,"",0)
	
	s Flag=..RecordOfHosp("DHC_StkCatGroup",scg,HospId)
	i Flag'="Y" q RtnObj.Err(-2,"","类组不在本院区","",0)
	
	s Flag=..RecordOfHosp("INC_StkCat",stkcat,HospId)
	i Flag'="Y" q RtnObj.Err(-2,"","分类不在本院区","",0)
	
	;类组和分类建立关联
	s rela=..validStkGrpRelation(scg,stkcat)
	i rela="" q RtnObj.Err(-2,"","类组和分类无法建立关联","",0)
	s Type=$p(^DHCSCG(scg),"^",3)
	i vendor'="" d
	.s Flag=..RecordOfHosp("APC_Vendor",vendor,HospId)
	.i $p(^APC("APCVM",vendor),"^",9)'=Type d RtnObj.Err(-2,"","供应商类型错误",0)	//Type与类组Type比较
	i Flag'="Y" d RtnObj.Err(-2,"","供应商不在本院区","",0)
	q:RtnObj.success'=0 RtnObj
	i manf'="" d
	.s Flag=..RecordOfHosp("PH_Manufacturer",manf,HospId)
	.s manfinfo=$o(^DHCMANF(0,"MANF",manf,""))
	.i manfinfo'="" d
	..i $p(^DHCMANF(manfinfo),"^",7)'=Type d RtnObj.Err(-2,"","厂商类型错误","",0)
	i Flag'="Y" d RtnObj.Err(-2,"","厂商不在本院区","",0)
	q:RtnObj.success'=0 RtnObj
	i carrier'="" d
	.s Flag=..RecordOfHosp("DHC_Carrier",carrier,HospId)
	i Flag'="Y" q RtnObj.Err(-2,"","配送商不在本院区","",0)
	
	i stOrigin'="" d
	.s Flag=..RecordOfHosp("DHC_STOrigin",stOrigin,HospId)
	i Flag'="Y" q RtnObj.Err(-2,"","产地不在本院区","",0)
	
	s ctcf=..validConFac(puom,buom,factor)
	i ctcf="" q RtnObj.Err(-2,"","入库单位和基本单位无对应换算","",0)
	
	i BookCat'="" d
	.s Flag=..RecordOfHosp("DHCST_BookCat",BookCat,HospId)
	i Flag'="Y" q RtnObj.Err(-2,"","账簿分类不在本院区","",0)
	
	//自动生成代码
	i code="" s code=..createCode(scg,stkcat)
	;i code="" s code=##class(web.DHCSTMHUI.DrugInfoMaintain).NewCode(stkcat)
	i code="" q RtnObj.Err(-2,"","自动生成代码错误","",0)
	
	s codeOnlyFlag=##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("CodeOnly")
	i codeOnlyFlag="Y" d
	.s TmpId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(code)_"Z",""))
	e  d
	.s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",code,"INC_Itm",HospId,"") 
	i TmpId'=""  q RtnObj.Err(-2,"",code_"代码重复","",0)
	
	s notuse="N"
	s d=+$h,t=$p($h,",",2)
	s user=..User()
	ts
	&sql(Insert into INC_Itm(INCI_Code,INCI_Desc,INCI_CTUOM_DR,INCI_INCSC_DR,INCI_CTUOM_Purch_DR,
		INCI_NotUseFlag,INCI_UpdateDate,INCI_UpdateTime,INCI_UpdateUser,INCI_BarCode,
		inci_remarks,INCI_BatchReq,INCI_ExpReq,INCI_IsTrfFlag)
	values
		(:code,:desc,:buom,:stkcat,:puom,
		:notuse,:d,:t,:user,:barcode,
		:remarksList,:batReq,:expReq,'B')
	)
	i SQLCODE'=0 tro 1 q RtnObj.Err(-3,"","插入主表错误:"_SQLCODE_":"_$g(%msg),"",0)
	s inci=$g(%ROWID)
	
	&sql(Insert into DHC_ItmAddionInfo
		(INFO_INCI_DR,INFO_Spec,INFO_Model,INFO_Brand,INFO_HighPrice,
		INFO_PbRp,INFO_PbVendor_DR,INFO_PbManf_DR,INFO_PbCarrier_DR,INFO_ChargeFlag,
		INFO_AbbRev,INFO_PackUom,INFO_PackUomFactor,INFO_Origin,INFO_InsuMatCode,
		INFO_ImportFlag,INFO_MatQuality,INFO_ImplantationMat,INFO_CentralPurFlag,INFO_TemPurchase,
		INFO_InHos_Flag,INFO_BC_Dr,INFO_PbFlag)
	values
		(:inci,:spec,:model,:brand,:hv,
		:rp,:vendor,:manf,:carrier,:charge,
		:abbr,:PackUomMax,:PackUomFacMax,:stOrigin,:InsuMatCode,
		:ImportFlag,:MatQuality,:ImplantFlag,:CentralPurFlag,:TemPurchase,
		:InHosFlag,:BookCat,:PbFlag)
	)
	i SQLCODE'=0 tro 1 q RtnObj.Err(-3,"","插入附加表错误:"_SQLCODE_":"_$g(%msg),"",0)
	
	s err=..createAlias(inci,alias)  //生成别名
	i err<0 tro 1 q RtnObj.Err(-3,"","插入别名错误","",0)
	
	s err=..createAsp(inci,..User(),rp,sp,HospId,priceinformation,AdjSpNo)  //生成调价表记录
	i err<0 tro 1 q RtnObj.Err(-3,"","生成价格数据错误","",0)

	
	s regTitle="MRCNo^MRCApprovalDate^MRCValidUntil^MRCInciDesc^MRCValidExtend^MRCMCDR"
	s regData=registerno_"^"_RegCertDate_"^"_registerexpdate_"^"_""_"^"_""_"^"_""
	s CertStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(regData,regTitle)
	s paramstr=inci_"^"_manf
	i registerno'="" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).save(CertStr,paramstr)
	i RtnObj.success<0 tro 1 q RtnObj
	
	/*
	i inci'="",v'="" d
	.s ret=..validIV(inci,v,m,carrier,rp,sp)
	*/

	s err=##class(web.DHCSTMHUI.MatForBDPData).SaveInciHOSP(inci,HospId)
	i err<0 tro 1 q RtnObj.Err(-3,"","保存院区记录失败","",0)

	s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("INC_Itm","User.INCItm","库存项主表信息",inci,desc,"A")
	i RtnObj.success<0 tro 1 q RtnObj
	
	tc
	
	s RtnObj.rowid=inci
	q RtnObj
}

/// 导入供应商
/// 
Method InputVendor(LinkHospId) As web.DHCSTMHUI.RtnObj
{
	n (LinkHospId,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s IfAllowHospNull=##class(web.DHCSTMHUI.Tools.CodeInputX).IfAllowHospNull("APC_Vendor")
	i ((IfAllowHospNull="Y")&&(LinkHospId="")) q RtnObj.Err(-11,"","医院信息为空","",0)
	
	s obj=$THIS
	s vCode=obj.vCode
	s vName=obj.vName
	s vType=obj.vType					;类型(G药品,M物资材料)
	s vShortName=obj.vShortName			;简称
	s vAlias=obj.vAlias					;别名
	s vTel=obj.vTel						;电话
	s vAddress=obj.vAddress				;地址
	;营业执照
	s vComLic=obj.vComLic
	s vComLicDateFrom=obj.vComLicDateFrom
	s vComLicDateTo=obj.vComLicDateTo
	;器械经营许可(III)
	s vInsBusLic=obj.vInsBusLic
	s vInsBusLicDateFrom=obj.vInsBusLicDateFrom
	s vInsBusLicDateTo=obj.vInsBusLicDateTo
	;二类器械经营备案
	s vSecondBusLic=obj.vSecondBusLic
	s vSecondBusLicDateFrom=obj.vSecondBusLicDateFrom
	s vSecondBusLicDateTo=obj.vSecondBusLicDateTo
	
	
	s:vType="" vType=..sssCode()
	i (vCode="")||(vName="") q RtnObj.Err(-1,"","代码或名称不可为空","",0)
	
	s del="/"
	s len=$l(LinkHospId,del)
	
	s VendorId=""
	s (ExistCode,ExistDesc)="N"
	&sql(SELECT APCVM_RowId into :VendorId FROM APC_Vendor WHERE APCVM_Type=:vType AND APCVM_Code=:vCode)
	i SQLCODE=0 s ExistCode="Y"
	&sql(SELECT APCVM_RowId into :VendorId FROM APC_Vendor WHERE APCVM_Type=:vType AND APCVM_Name=:vName)
	i SQLCODE=0 s ExistDesc="Y"
	
	i ((ExistCode="Y")&&(ExistDesc="Y")) {
		;关联医院
		ts
		f i=1:1:len q:RtnObj.success<0  d
		.s HospId=$p(LinkHospId,del,i)
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("APC_Vendor",VendorId,HospId)
		.i ret<0 d RtnObj.Err(-10,"","关联医院处理失败")
		i RtnObj.success<0 tro 1 q RtnObj
		tc
		s RtnObj.rowid=VendorId
	}elseif(ExistCode="Y"){
		q RtnObj.Err(-1,"","代码重复:"_vCode,"",0)
	}elseif(ExistDesc="Y"){
		q RtnObj.Err(-1,"","名称重复:"_vName,"",0)
	}else{
		ts
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s Status="A"
		s vAddress=$lfs(vAddress,MemoDelim)
		&sql(INSERT INTO APC_Vendor(APCVM_Code,APCVM_Name,APCVM_Type,APCVM_Status,APCVM_Tel,
			APCVM_Addr)
			VALUES
			(:vCode,:vName,:vType,:Status,:vTel,
			:vAddress)
		)
		i (SQLCODE'=0) tro 1 q RtnObj.Err(-6,"","主表保存失败"_":"_$g(%msg),"",0)
		s VendorId=$p(%ROWID,$c(1))
		
		;保存附加表数据
		s Alias=vAlias_"/"_vCode_"/"_vName_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(vName,4)_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(vName,3,"",50)
		s STV=$o(^DHCSTV(0,VendorId,0))
		i STV="" d
		.s STVObj=##class(User.DHCSTVendor).%New()
		.d STVObj.STVVendorDRSetObjectId(VendorId)
		e  d
		.s STVObj=##class(User.DHCSTVendor).%OpenId(STV)
		s STVObj.STVType=vType
		s STVObj.STVAlias=Alias
		s STVObj.STVAbbrev=vShortName
		s Sc=STVObj.%Save()
		i $$$ISERR(Sc) tro 1 q RtnObj.Err(-9,"","附加表记录失败")
		
		;记录供应商资质
		s OrgType="Vendor"
		s OrgId=VendorId
		s CertTitle="CERTType^CERTRowId^CERTText^CERTIssuedDept^CERTIssuedDate^CERTDateFrom^CERTDateTo^CERTBlankedFlag^CERTDelayFlag^CERTDelayDateTo^CERTShowFlag"
		
		i vComLic'="" d
		.s CertData={}
		.d CertData.%Set("CERTType","comLic")
		.d CertData.%Set("CERTText",vComLic)
		.d CertData.%Set("CERTDateFrom",vComLicDateFrom)
		.d CertData.%Set("CERTDateTo",vComLicDateTo)
		.d CertData.%Set("CERTShowFlag","Y")
		.d CertData.%Set("HospId",LinkHospId)
		.s CertParams=CertData.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail(OrgType,OrgId,CertParams)
		i RtnObj.success<0 tro 1 q RtnObj
		
		i vInsBusLic'="" d
		.s CertData={}
		.d CertData.%Set("CERTType","insBusLic")
		.d CertData.%Set("CERTText",vInsBusLic)
		.d CertData.%Set("CERTDateFrom",vInsBusLicDateFrom)
		.d CertData.%Set("CERTDateTo",vInsBusLicDateTo)
		.d CertData.%Set("CERTShowFlag","Y")
		.d CertData.%Set("HospId",LinkHospId)
		.s CertParams=CertData.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail(OrgType,OrgId,CertParams)
		i RtnObj.success<0 tro 1 q RtnObj
		
		i vSecondBusLic'="" d
		.s CertData={}
		.d CertData.%Set("CERTType","secondBusLic")
		.d CertData.%Set("CERTText",vSecondBusLic)
		.d CertData.%Set("CERTDateFrom",vSecondBusLicDateFrom)
		.d CertData.%Set("CERTDateTo",vSecondBusLicDateTo)
		.d CertData.%Set("CERTShowFlag","Y")
		.d CertData.%Set("HospId",LinkHospId)
		.s CertParams=CertData.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail(OrgType,OrgId,CertParams)
		i RtnObj.success<0 tro 1 q RtnObj
		
		;关联医院
		f i=1:1:len q:RtnObj.success<0  d
		.s HospId=$p(LinkHospId,del,i)
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("APC_Vendor",VendorId,HospId)
		.i ret<0 d RtnObj.Err(-10,"","关联医院处理失败")
		i RtnObj.success<0 tro 1 q RtnObj
		
		s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("APC_Vendor","User.APCVendor","供应商信息",VendorId,vName,"A")
		i RtnObj.success<0 tro 1 q RtnObj
		
		tc
		
		s RtnObj.rowid=VendorId
	}
	
	q RtnObj
}

/// 导入生产厂家
Method InputManf(LinkHospId) As web.DHCSTMHUI.RtnObj
{
	n (LinkHospId,%session)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s obj=$THIS
	s IfAllowHospNull=##class(web.DHCSTMHUI.Tools.CodeInputX).IfAllowHospNull("PH_Manufacturer")
	if ((IfAllowHospNull="Y")&&(LinkHospId="")) q RtnObj.Err(-11,"","医院信息为空","",0)
	
	s mCode=obj.mCode
	s mName=obj.mName
	s mType=obj.mType				;类型(G药品,M物资材料)
	s mShortName=obj.mShortName		;简称
	s mAlias=obj.mAlias				;别名
	s mTel=obj.mTel					;电话
	s mAddress=obj.mAddress			;地址
	;营业执照
	s mComLic=obj.mComLic
	s mComLicDateFrom=obj.mComLicDateFrom
	s mComLicDateTo=obj.mComLicDateTo
	;生产许可(二三类)
	s mInsProLic=obj.mInsProLic
	s mInsProLicDateFrom=obj.mInsProLicDateFrom
	s mInsProLicDateTo=obj.mInsProLicDateTo
	;一类生产备案
	s mFirstProdLic=obj.mFirstProdLic
	s mFirstProdLicDateFrom=obj.mFirstProdLicDateFrom
	s mFirstProdLicDateTo=obj.mFirstProdLicDateTo
	
	s:mType="" mType=..sssCode()
	i (mCode="")||(mName="") q RtnObj.Err(-1,"","厂商代码或名称不可为空","",0)
	
	s del="/"
	s len=$l(LinkHospId,del)
	
	;管控类型数据,只记录一条
	s ManfId=""
	s (ExistCode,ExistDesc)="N"
	&sql(SELECT MANF_PhcManf_DR into :ManfId FROM DHC_Manf_AddionInfo
		WHERE MANF_Type=:mType AND MANF_PhcManf_DR->PHMNF_Code=:mCode)
	i SQLCODE=0 s ExistCode="Y"
	&sql(SELECT MANF_PhcManf_DR into :ManfId FROM DHC_Manf_AddionInfo
		WHERE MANF_Type=:mType AND MANF_PhcManf_DR->PHMNF_Name=:mName)
	i SQLCODE=0 s ExistDesc="Y"
	
	i ((ExistCode="Y")&&(ExistDesc="Y")) {
		;关联医院
		ts
		f i=1:1:len q:RtnObj.success<0  d
		.s HospId=$p(LinkHospId,del,i)
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("PH_Manufacturer",ManfId,HospId)
		.i ret<0 d RtnObj.Err(-10,"","关联医院处理失败")
		i RtnObj.success<0 tro 1 q RtnObj
		tc
		s RtnObj.rowid=ManfId
	}elseif(ExistCode="Y"){
		q RtnObj.Err(-1,"","代码重复:"_mCode,"",0)
	}elseif(ExistDesc="Y"){
		q RtnObj.Err(-1,"","名称重复:"_mName,"",0)
	}else{
		;导入厂商数据
		ts
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s mAddress=$lfs(mAddress,MemoDelim)
		&sql(INSERT INTO PH_Manufacturer
			(PHMNF_Code,PHMNF_Name,PHMNF_Tel,PHMNF_ShortName,PHMNF_Address)
			values
			(:mCode,:mName,:mTel,:mShortName,:mAddress)
		)
		i SQLCODE'=0 tro 1 q RtnObj.Err(-6,"","主表保存失败"_":"_$g(%msg),"",0)
		s ManfId=$p(%ROWID,$C(1))
		
		s Alias=mAlias_"/"_mCode_"/"_mName_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(mName,4)_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(mName,3,"",50)
		s stm=$o(^DHCMANF(0,"MANF",ManfId,0))
		i stm="" d
		.s ManfAddObj=##class(User.DHCManfAddionInfo).%New()
		.d ManfAddObj.MANFPhcManfDRSetObjectId(ManfId)
		.s ManfAddObj.MANFActive="Y"			;缺省为"激活"状态
		e  d
		.s ManfAddObj=##class(User.DHCManfAddionInfo).%OpenId(stm)
		s ManfAddObj.MANFType=mType
		s ManfAddObj.MANFAlias=Alias
		s Sc=ManfAddObj.%Save()
		i $$$ISERR(Sc) tro 1 q RtnObj.Err(-9,"","厂商附加表记录失败")
		;记录厂商资质
		s OrgType="Manf"
		s OrgId=ManfId
		s CertTitle="CERTType^CERTRowId^CERTText^CERTIssuedDept^CERTIssuedDate^CERTDateFrom^CERTDateTo^CERTBlankedFlag^CERTDelayFlag^CERTDelayDateTo^CERTShowFlag^HospId"
		
		i mComLic'="" d
		.s CertData={}
		.d CertData.%Set("CERTType","comLic")
		.d CertData.%Set("CERTText",mComLic)
		.d CertData.%Set("CERTDateFrom",mComLicDateFrom)
		.d CertData.%Set("CERTDateTo",mComLicDateTo)
		.d CertData.%Set("CERTShowFlag","Y")
		.d CertData.%Set("HospId",LinkHospId)
		.s CertParams=CertData.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail(OrgType,OrgId,CertParams)
		i RtnObj.success<0 tro 1 q RtnObj

		i mInsProLic'="" d
		.s CertData={}
		.d CertData.%Set("CERTType","insProLic")
		.d CertData.%Set("CERTText",mInsProLic)
		.d CertData.%Set("CERTDateFrom",mInsProLicDateFrom)
		.d CertData.%Set("CERTDateTo",mInsProLicDateTo)
		.d CertData.%Set("CERTShowFlag","Y")
		.d CertData.%Set("HospId",LinkHospId)
		.s CertParams=CertData.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail(OrgType,OrgId,CertParams)
		i RtnObj.success<0 tro 1 q RtnObj
		
		i mFirstProdLic'="" d
		.s CertData={}
		.d CertData.%Set("CERTType","firstProdLic")
		.d CertData.%Set("CERTText",mFirstProdLic)
		.d CertData.%Set("CERTDateFrom",mFirstProdLicDateFrom)
		.d CertData.%Set("CERTDateTo",mFirstProdLicDateTo)
		.d CertData.%Set("CERTShowFlag","Y")
		.d CertData.%Set("HospId",LinkHospId)
		.s CertParams=CertData.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail(OrgType,OrgId,CertParams)
		i RtnObj.success<0 tro 1 q RtnObj
		
		;关联医院
		f i=1:1:len q:RtnObj.success<0  d
		.s HospId=$p(LinkHospId,del,i)
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("PH_Manufacturer",ManfId,HospId)
		.i ret<0 d RtnObj.Err(-10,"","关联医院处理失败")
		i RtnObj.success<0 tro 1 q RtnObj
		
		s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("PH_Manufacturer","User.PHManufacturer","厂商信息",ManfId,mName,"A")
		i RtnObj.success<0 tro 1 q RtnObj
		
		tc
		s RtnObj.rowid=ManfId
	}
	
	q RtnObj
}

/// 导入库存分类/类组 
Method InputStkCat(LinkHospId) As web.DHCSTMHUI.RtnObj
{
	n (LinkHospId,%session)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s obj=$THIS
	s HospId=LinkHospId
	s IfAllowHospNull=##class(web.DHCSTMHUI.Tools.CodeInputX).IfAllowHospNull("DHC_StkCatGroup")
	i ((IfAllowHospNull="Y")&&(HospId="")) q RtnObj.Err(-11,"","医院信息为空","",0)
	
	s scSet=obj.scSet
	s scSGCode=obj.scSGCode
	s scSGDesc=obj.scSGDesc
	s scSCCode=obj.scSCCode
	s scSCDesc=obj.scSCDesc
	s scStkType=obj.scStkType
	s scSGStruModeFlag=obj.scSGStruModeFlag
	
	i (scSGCode="")||(scSGDesc="")||(scSCCode="")||(scSCDesc="") q RtnObj.Err(-2,"","类组或库存分类的代码,名称不可为空","",0)

	s:scStkType="" scStkType=..sssCode()
	s:scSGStruModeFlag="" scSGStruModeFlag="N"
	i scSet["医用材料" s scSet="MM"
	e  i scSet["后勤材料" s scSet="MO"
	e  i scSet["试剂" s scSet="MR"
	e  i scSet["固定资产" s scSet="MF"
	e  s scSet=""

	s scg="",sc=""
	s scg=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",scSGDesc,"DHC_StkCatGroup",HospId)
	s tmpscgid=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",scSGCode,"DHC_StkCatGroup",HospId)
	i (+scg'>0)&&(+tmpscgid>0) q RtnObj.Err(-2,"","代码重复","",0)
	
	ts
	i +scg'>0 d
	.&sql(INSERT INTO DHC_StkCatGroup(SCG_Code,SCG_Desc,SCG_Type,SCG_Set,SCG_StruModeFlag) VALUES (:scSGCode,:scSGDesc,:scStkType,:scSet,:scSGStruModeFlag))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","类组保存失败"_":"_$g(%msg)) q
	.s scg=$p($g(%ROWID),$c(1))
	i RtnObj.success<0 tro 1 q RtnObj
	
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_StkCatGroup",scg,HospId)
	i ret<0 tro 1 q RtnObj.Err(-5,"","类组关联医院失败")
	s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHC_StkCatGroup","User.DHCStkCatGroup","类组信息",scg,scSGDesc,"A")
	i RtnObj.success<0 tro 1 q RtnObj
	
	s sc=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",scSCDesc,"INC_StkCat",HospId)
	s tmpscid=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",scSCCode,"INC_StkCat",HospId)
	i (+sc'>0)&&(+tmpscid>0) tro 1 q RtnObj.Err(-3,"","库存分类代码重复")
	
	i +sc'>0 d
	.&sql(INSERT INTO INC_StkCat(INCSC_Code,INCSC_Desc,INCSC_StkType) VALUES (:scSCCode,:scSCDesc,:scStkType))
	.i SQLCODE'=0 d RtnObj.Err(-6,"","库存分类插入失败"_":"_$g(%msg))
	.s sc=$p($g(%ROWID),$c(1))
	i RtnObj.success<0 tro 1 q RtnObj
	
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("INC_StkCat",sc,HospId)
	i ret<0 tro 1 q RtnObj.Err(-6,"","库存分类关联医院失败")
	
	s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("INC_StkCat","User.INCStkCat","库存分类信息",sc,scSCDesc,"A")
	i RtnObj.success<0 tro 1 q RtnObj
	
	s RelaId=obj.validStkGrpRelation(scg,sc)
	i RelaId="" tro 1 q RtnObj.Err(-7,"","类组库存分类关联失败")
	
	tc
	
	s RtnObj.rowid=RelaId
	q RtnObj
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

/// 自动生成代码
Method createCode(scg, sc) As %String
{
	n (scg,sc)
	q:scg="" ""
	q:sc="" ""
	&sql(select scg_code into :scgCode from dhc_stkcatgroup where scg_rowid=:scg)
	&sql(select incsc_code into :scCode from inc_stkcat where incsc_rowid=:sc) 
	q:scgCode="" ""
	q:scCode="" ""

	s:$f(scCode,"CL") scCode=$p(scCode,..prefix(),2)
	s seq=$i(^INCIx("AUTOCODE",scgCode,scCode)) 
	s inciCode=scgCode_scCode_$tr($j(seq,4)," ","0")
	q inciCode
}

/// 验证类组(大类)
Method validScg(catgrp As %String) As %String
{
	n (catgrp)
	s type=..sssCode(),prefix=..prefix()
	s rowid=""
	&sql(select scg_rowid into :scg from dhc_stkcatgroup where scg_desc=:catgrp and scg_type=:type)
	i SQLCODE d
	.s code=..getScgCode(prefix)
	.&sql(insert into  dhc_stkcatgroup(scg_code,scg_desc,scg_type) values (:code,:catgrp,:type))
	.i SQLCODE'=0 q 
	.s rowid=$p($g(%ROWID),$c(1))
	e  d
	.s rowid=+scg
	q rowid
}

/// 验证分类
Method validStkCat(stkcat As %String) As %String
{
	n (stkcat)
	s type=..sssCode(),prefix=..prefix()
	s rowid=""
	&sql(select incsc_rowid into :sc from inc_stkcat where incsc_desc=:stkcat)
	i SQLCODE d
	.s code=..getScCode(prefix)
	.&sql(insert into  inc_stkcat(incsc_code,incsc_desc,incsc_stktype) values (:code,:stkcat,:type))
	.i SQLCODE'=0 q 
	.s rowid=$G(%ROWID)
	e  d
	.s rowid=+sc
	q rowid
}

/// 验证类组和分类之间的对应关联关系
/// scg:类组rowid
/// incsc:类rowid
Method validStkGrpRelation(scg As %String, sc As %String) As %String
{
	n (scg,sc)
	s rowid=""
	&sql(select scgr_rowid into :scgr From dhc_stkcatgrprelations  where scgr_scg_parref=:scg and scgr_stkcat_dr=:sc)    ; and scgr_scg_parref->scg_Type=:stktype)
	i SQLCODE d
	.&sql(select scgr_rowid into :scgr from dhc_stkcatgrprelations where scgr_stkcat_dr=:sc)
	.i 'SQLCODE   q   ;该分类已经对应
	.s ch=$o(^DHCSCG(scg,"RE",""),-1)+1
	.&sql(insert into dhc_stkcatgrprelations(scgr_scg_parref,scgr_childsub,scgr_stkcat_dr) values (:scg,:ch,:sc) )
	.i SQLCODE'=0 q
	.s rowid=$G(%ROWID)
	e  d
	.s rowid=$G(scgr) 
	q rowid
}

/// uom: from-uom rowid
/// buom :  to-uom rowid
ClassMethod validConFac(frUom As %String, toUom As %String, fac As %String) As %String
{
	n (frUom,toUom,fac)
	i frUom=toUom q 0
	s active="Y"
	s rowid=""
	&sql(select %id,ctcf_factor into :conf,:factor from ct_confac where ctcf_fruom_dr=:frUom and ctcf_touom_dr=:toUom)
	i SQLCODE d
	.&sql(insert into ct_confac (ctcf_fruom_dr,ctcf_touom_dr,ctcf_factor,ctcf_activeflag) 
		values (:frUom,:toUom,:fac,:active) )
	.i SQLCODE'=0 q
	.s rowid=+$G(%ROWID)
	e  d
	.i +factor=+fac s rowid=conf

	q rowid
}

/// 自动算出类组代码
Method getScgCode(prefix) As %String
{
	n (prefix)
	s scgCodeWidth=..ScgCodeWidth()
	s SerialNo=""
	f i=1,i<=scgCodeWidth,i=i+1 d
	.s SerialNo=SerialNo_"[0-9]"		;避免scg_code可能出现的重复
	s qcon=prefix_SerialNo
	&sql(select max(scg_code) into :x from dhc_stkcatgroup where scg_code %MATCHES :qcon)
	s x=$g(x)
	i x="" d
	.;s code="001"
	.s code=$tr($j(1,scgCodeWidth)," ","0")
	e  d
	.s serial=$p(x,prefix,2)
	.s code=$tr($j(+serial+1,scgCodeWidth)," ","0")
	q prefix_code
}

/// 自动算出分类代码
Method getScCode(prefix) As %String
{
	n (prefix)
	s scCodeWidth=..ScCodeWidth()
	s SerialNo=""
	f i=1,i<=scCodeWidth,i=i+1 d
	.s SerialNo=SerialNo_"[0-9]"		;避免scg_code可能出现的重复
	s qcon=prefix_SerialNo
	&sql(select max(incsc_code) into :x from inc_stkcat where incsc_code %MATCHES :qcon)
	s x=$g(x)
	i x="" d
	.;s code="001"
	.s code=$tr($j(1,scCodeWidth)," ","0")
	e  d
	.s serial=$p(x,prefix,2)
	.s code=$tr($j(+serial+1,scCodeWidth)," ","0")
	q prefix_code
}

Method prefix() As %String
{
	q "CL"
}

/// 库存类组代码序号宽度(缺省为3)
Method ScgCodeWidth() As %String
{
	q 3
}

/// 库存分类代码序号宽度(缺省为3)
Method ScCodeWidth() As %String
{
	q 3
}

ClassMethod User() As %String
{
	s user=""
	i $d(%session) d
	.s user=$G(%session.Data("LOGON.USERID"))
	q user
}

/// 生成别名数据，缺省可以生成如下别名：
///   1.物资名称描述拼音首字符
///   2.物资代码
///   3.五笔
///   4.协和码
///   5.指定的别名
Method createAlias(inci As %String, alias As %String) As %String
{
	n (inci,alias)
	s ret=0
	&sql(select inci_code,inci_desc,INCI_ReportingDays into :code,:desc,:xiehe from inc_itm where inci_rowid=:inci)
	;
	s py=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(desc,4,"")  ;别名一:描述的拼音首字符
	s py=$$ALPHAUP^SSUTIL4(py)
	&sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)
	values (:py,:code,:desc,:inci)  )
	i SQLCODE'=0 q -1
	
	;别名二:代码
	&sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)   
	values (:code,:code,:desc,:inci)  )
	i SQLCODE'=0 q -2
	
	;别名三:五笔码
	s five=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(desc,6,"")
	s five=$e(five,1,30) // 取前30个字符  
	&sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)   
	values (:five,:code,:desc,:inci)  )
	i SQLCODE'=0 q -3

	;别名四:协和码
	i $g(xiehe)'="" d
	. &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr) values (:xiehe,:code,:desc,:inci)  )
	. i SQLCODE'=0 s ret= -4
	q:ret<0 ret
	
	i alias'="" d
	.&sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr) values (:alias,:code,:desc,:inci)  )
	.i SQLCODE'=0 s ret=-5
	
	q ret
}

/// 生成调价记录(注意：此处当前方法不处理收费项)
/// inci -库存项目rowid
/// user -用户
/// rp -进价
/// sp -售价
/// hosp -医院rowid
/// 
Method createAsp(inci, user, rp, sp, hosp, priceinformation, AdjSpNo) As %String
{
	n (inci, user, rp, sp, hosp,priceinformation,AdjSpNo)
	
	s AdjDate=+$h
	s PreExecuteDate=AdjDate
	s ExecuteDate=AdjDate
	s ItmRowid=inci

	s ret=0
	&sql(select inci_incsc_dr,inci_ctuom_dr,inci_ctuom_purch_dr into :StkCatId,:uom,:puom from inc_itm where inci_rowid=:inci)
	i SQLCODE s ret= -1
	q:ret<0 ret

	s User=user
	s HospId=hosp
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,uom)
	s ResultSp=sp
	s ResultRp=rp
	s AdjUomId=puom

	s BResultSp=ResultSp/fac
	s BResultRp=ResultRp/fac
	s BPriorRp=0
	s BPriorSp=0

	s AdjUserId=user
	s Status="Yes"
	s Remark="初始化数据"

	&sql(insert into in_adjsaleprice
		(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,
		inasp_resultsp,inasp_ssusr_dr,inasp_status,inasp_no,INASP_ExecuteDate,inasp_ctuom_dr,inasp_ctuom_price,
		INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,
		INASP_PreExeDate,INASP_Remark,INASP_WarrentNo)
		values
		(:AdjDate,:ItmRowid,:StkCatId,:BPriorSp,:BResultSp,:AdjUserId,:Status,:AdjSpNo,:ExecuteDate,
		:AdjUomId,:ResultSp,:BPriorRp,:BResultRp,:ResultRp,:HospId,
		:PreExecuteDate,:Remark,:priceinformation)
	)
	i SQLCODE'=0  s ret=-2
	q ret
}

/// dhc_itmven
Method validIV(inci As %String, v As %String, m As %String, ca As %String, rp As %String, sp As %String) As %String
{
	n (inci,v,m,ca,rp,sp)
	s ret=0
	&sql(select dhciv_rowid into :iv from dhc_itmven where dhciv_inci_dr=:inci and dhciv_apcvm_dr=:v )
	i SQLCODE  d
	.s type=..sssCode()
	. &sql(insert into dhc_itmven(dhciv_inci_dr,dhciv_apcvm_dr,dhciv_manf_dr,dhciv_carrier_dr,dhciv_purprice,dhciv_saleprice,dhciv_itmtype)
		values(:inci,:v,:m,:ca,:rp,:sp,:type))
	.i SQLCODE'=0 s ret=-131 q
	e  d
	.s type=..sssCode()
	.&sql(update dhc_itmven set dhciv_manf_dr=:m,dhciv_carrier_dr=:ca,dhciv_purprice=:rp,dhciv_saleprice=:sp,dhciv_itmtype=:type where dhciv_rowid=:iv)
	.i SQLCODE'=0 s ret=-132 q

	q ret
}

/// 判断某个记录是否属于当前院区
/// 20200421 lihui
/// input: tableName, dataid, HospId
/// return: Y:存在 否则：不存在
/// w ##class(web.DHCSTMHUI.Tools.CodeInputX).RecordOfHosp()
ClassMethod RecordOfHosp(tableName, dataid, HospId) As %String
{
	n (tableName, dataid, HospId,%session)
	;判断是否开启医院授权管理
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	q:(BDPHospAutFlag'="Y") "Y"
	q:($g(tableName)="")||($g(dataid)="")||($g(HospId)="") "N" 
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(tableName)
	i TableType="G" q "Y"
	s retValue="Y"
	
	s BDPMapId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPMapId(tableName,HospId,dataid)
	i BDPMapId'>0 s retValue="N"
	q retValue
}

/// 判断是否允许医院为空 (Y:必须有;N:可有可无)
/// lihui 20200612
/// w ##class(web.DHCSTMHUI.Tools.CodeInputX).IfAllowHospNull()
ClassMethod IfAllowHospNull(TableName As %String) As %String
{
	n (TableName)
	s flag="N"
	s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag()
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(TableName)
	i ((HospAutFlag="Y")&&(TableType'="G")) d
	.s flag="Y"
	q flag
}

}
